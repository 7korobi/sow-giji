package SWCmdEpilogueEditVil;

#----------------------------------------
# 閲覧制限変更（暫定）
#----------------------------------------
sub CmdEpilogueEditVil {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	my $vil = &SetDataCmdEpilogueEditVil($sow);

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		# 村ログ表示
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_vlog.pl";
		&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
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
sub SetDataCmdEpilogueEditVil {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "管理人権限が必要です。", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "閲覧権限IDが不正です。", "no rating.$errfrom") if (!defined($sow->{'cfg'}->{'RATING'}->{$query->{'rating'}}->{'CAPTION'}));
	$vil->{'rating'} = $query->{'rating'};
	$vil->writevil();
	$vil->closevil();

	return $vil;
}

1;