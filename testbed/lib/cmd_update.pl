package SWCmdUpdateSession;

#----------------------------------------
# 更新（手動）
#----------------------------------------
sub CmdUpdateSession {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# データ処理
	my $vil = &SetDataCmdUpdateSession($sow);

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
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
sub SetDataCmdUpdateSession {
	my $sow = $_[0];
	my $query  = $sow->{'query'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 更新処理
	require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
	my $scrapvil = 0;
	$scrapvil = 1 if ($sow->{'query'}->{'cmd'} eq 'scrapvil');
	&SWCommit::UpdateSession($sow, $vil, 1, $scrapvil);

	$vil->closevil();

	return $vil;
}

1;