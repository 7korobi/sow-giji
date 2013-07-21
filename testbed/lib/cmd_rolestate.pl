package SWCmdRoleState;

#----------------------------------------
# 点呼処理
#----------------------------------------
sub CmdRoleState {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	my $vil = &SetDataCmdRoleState($sow,$query->{'vid'},$query->{'target'},$query->{'rolestate'},$query->{'calcstate'});

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
sub SetDataCmdRoleState {
	my ($sow, $vid, $target_pno, $rolestate, $calcstate) = @_;
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $vid);
	$vil->readvil();

	my $cursor = $sow->{'curpl'};
	my $target = $vil->getplbypno($target_pno);
	my $command = '';

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "黒幕でなくてはいけません。", "no permition.$errfrom") unless (($vil->{'mob'} eq 'gamemaster')&&($cursor->{'live'} eq 'mob'));	
	if ($calcstate eq 'enable'){
		$command = 'MASKSTATE_'.$rolestate;
		$target->{'rolestate'} |= $sow->{$command};
	}
	if ($calcstate eq 'disable'){
		$command = 'ROLESTATE_'.$rolestate;
		$target->{'rolestate'} &= $sow->{$command};
	}
	# 村データの書き込み
	$vil->writevil();

	# アナウンス
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	my $chrname = $target->getlongchrname();
	my $message = $sow->{'textrs'}->{'MASKSTATE_VOTE_TARGET'};
	$message =~ s/_NAME_/$chrname/g;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $message);
	$logfile->close();

	$vil->closevil();

	return $vil;
}

1;