package SWCmdMaker;

#----------------------------------------
# 村建て権限委譲
#----------------------------------------
sub CmdMaker {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	# データ処理
	&SetDataCmdMaker($sow,$query->{'target'});

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		require "$cfg->{'DIR_LIB'}/file_log.pl";
		require "$cfg->{'DIR_LIB'}/log.pl";
		require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
		my $vil = SWFileVil->new($sow, $sow->{'query'}->{'vid'});
		$vil->readvil();
		&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
		$vil->closevil();
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = "$link";
		$sow->{'http'}->outheader(); # HTTPヘッダの出力
		$sow->{'http'}->outfooter();
	}
}
#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdMaker {
	my $sow = $_[0];
	my $target = $_[1];
	my $query  = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	my $curpl = $sow->{'curpl'};
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, 'あなたは村建て権限を譲れません。', "you are not maker.[$sow->{'uid'}]")   if (($sow->{'uid'} ne $vil->{'makeruid'})&&($sow->{'uid'} ne $cfg->{'USERID_ADMIN'}));

	$curpl = $vil->getplbypno($target) if ($target);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, 'この村へ参加していません。', "user not found.[$curpl->{'uid'}]")             if (!defined($curpl));
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, 'ダミーキャラは村建て権を持てません。', "npc cannot exit.[$curpl->{'uid'}]") if ($curpl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});

	# 村建て人を更新
	$vil->{'makeruid'} = $curpl->{'uid'};
	$vil->writevil();

	# アナウンス
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	my $nextupdatedt = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
#	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, '村建て人が変化しました。');
	$logfile->close();

	$vil->closevil();

	return;
}

1;
