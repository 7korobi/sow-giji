package SWCmdGameMaster;

#----------------------------------------
# 点呼処理
#----------------------------------------
sub CmdGameMaster {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	my $vil = &SetDataCmdGameMaster($sow,$query->{'vid'},$query->{'target'});

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
sub SetDataCmdGameMaster {
	my ($sow, $vid, $target_pno) = @_;
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

	my $admin      = ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'});
	my $gamemaster = ($vil->{'mob'} eq 'gamemaster')&&($cursor->{'live'} eq 'mob');

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "管理人権限か、黒幕の権限が必要です。", "no permition.$errfrom") unless ($gamemaster || $admin);

	my $rolestate = $query->{'rolestate'};
	my $calcstate = $query->{'calcstate'};
	if ($calcstate eq 'enable'){
		$command = 'MASKSTATE_'.$rolestate;
		$target->{'rolestate'} |= $sow->{$command};
	}
	if ($calcstate eq 'disable'){
		$command = 'ROLESTATE_'.$rolestate;
		$target->{'rolestate'} &= $sow->{$command};
	}

	my $live = $query->{'live'};
	if ($live){
		$command = uc($live);
		$target->{'live'} = $live;

		# 能力行使のリセット
		$target->{'vote1'} = $sow->{'TARGETID_TRUST'};
		$target->{'vote2'} = $sow->{'TARGETID_TRUST'};
		$target->{'role1'} = $sow->{'TARGETID_TRUST'};
		$target->{'role2'} = $sow->{'TARGETID_TRUST'};
		$target->{'gift1'} = $sow->{'TARGETID_TRUST'};
		$target->{'gift2'} = $sow->{'TARGETID_TRUST'};
	}

	# 村データの書き込み
	$vil->writevil();

	# アナウンス
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	my $chrname = $target->getlongchrname();
	my $message = $sow->{'textrs'}->{$command};
	$message =~ s/_NAME_/$chrname/g;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $message);
	$logfile->close();

	$vil->closevil();

	return $vil;
}

1;