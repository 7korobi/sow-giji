package SWCmdStartSession;

#----------------------------------------
# 村開始
#----------------------------------------
sub CmdStartSession {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# データ処理
	my $vil = &SetDataCmdStartSession($sow);

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_vlog.pl";
		&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = $link;
		$sow->{'http'}->outheader(); # HTTPヘッダの出力
		$sow->{'http'}->outfooter();
	}
	$vil->closevil();
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdStartSession {
	my $sow = $_[0];
	my $query  = $sow->{'query'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	$vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 村開始処理
	require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
	&SWCommit::StartSession($sow, $vil, 1);

	return $vil;
}

1;