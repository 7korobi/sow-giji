package SWCmdRestMemoIndex;

#----------------------------------------
# メモインデックスの再構築
#----------------------------------------
sub CmdRestMemoIndex {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	my $vil = &SetRestMemoIndex($sow);

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_memo.pl";
		$sow->{'query'}->{'cmd'} = 'memo';
		&SWCmdMemo::CmdMemo($sow);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'}  = 'memo';
		$reqvals->{'turn'} = '';
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
sub SetRestMemoIndex {
	my $sow = $_[0];
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$debug->raise($sow->{'APLOG_CAUTION'}, '管理権限がありません。', "cannot restructure memoidx.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	# 村データの読み込み
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
	my $memofile = SWSnake->new($sow, $vil, $sow->{'turn'}, 0);
	$memofile->restructure();
	$memofile->close();
	$vil->closevil();

	return ($vil, $checknosay);
}

1;