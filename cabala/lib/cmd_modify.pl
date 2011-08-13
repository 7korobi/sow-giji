package SWCmdModify;

#----------------------------------------
# 発言の修正
#----------------------------------------
sub CmdModify {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 発言書き込み
	my $writepl = &SWBase::GetCurrentPl($sow, $vil);
	&SWWrite::ExecuteCmdWrite($sow, $vil, $writepl);
	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "WriteSay. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");
	}
	$vil->closevil();

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

	$sow->{'http'}->{'location'} = "$link";
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'http'}->outfooter();
}

1;