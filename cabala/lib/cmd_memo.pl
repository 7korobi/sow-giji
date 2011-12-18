package SWCmdMemo;

#----------------------------------------
# メモ表示
#----------------------------------------
sub CmdMemo {
	my $sow = $_[0];

	# データ処理
	my $vil = &SetDataCmdMemo($sow);

	# HTML出力
	&OutHTMLCmdMemo($sow, $vil);
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdMemo {
	my $sow = shift;
	my $query = $sow->{'query'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	return $vil;
}

#----------------------------------------
# HTML出力
#----------------------------------------
sub OutHTMLCmdMemo {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $ua    = $sow->{'outmode'};

	# ライブラリの読み込み
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_LIB'}/file_memo.pl";
	require "$cfg->{'DIR_LIB'}/file_log.pl";
	require "$cfg->{'DIR_LIB'}/log.pl";

	my $turn = $sow->{'turn'};
	$turn = $vil->{'epilogue'} if ($sow->{'turn'} > $vil->{'epilogue'}); # 終了している時は終了日

	# メモファイル・村ログファイルを開く
	my $logfile = SWBoa->new($sow, $vil, $turn, 0);
	my $memofile = SWSnake->new($sow, $vil, $turn, 0);

	# タイトルの取得
#	my $title = &SWHtmlMemo::GetHTMLMemoTitle($sow, $vil);

	# HTMLモードの初期化
	$sow->{'html'} = SWHtml->new($sow);
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# JavaScriptの設定
	$sow->{'html'}->{'file_js'} = $sow->{'cfg'}->{'FILE_JS_VIL'};

	# HTTPヘッダ・HTMLヘッダの出力
	my $outhttp = $sow->{'http'}->outheader();
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('メモ');

	# 表示行数の設定
	my $maxrow = $sow->{'cfg'}->{'MAX_ROW'};
	$maxrow = $query->{'row'} if (defined($query->{'row'}) && ($query->{'row'} ne ''));
	$query->{'rowall'} = 'on' if ((($ua ne 'mb')) && ($sow->{'turn'} < $vil->{'turn'}));
	$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne ''));
	$maxrow = -1 if ($sow->{'outmode'} eq 'pc');

	# ログの取得
	my ($logs, $logkeys, $rows);
	if (($sow->{'turn'} != $vil->{'turn'}) || ($vil->{'epilogue'} >= $vil->{'turn'})) {
		($logs, $logkeys, $rows) = $memofile->getmemo($maxrow);
	} else {
		my @logs;
		$logs = \@logs;
	}
	$sow->{'lock'}->gunlock();

	# HTMLの出力
	if ($ua eq 'mb') {
		require "$cfg->{'DIR_HTML'}/html_memo_mb.pl";
		&SWHtmlMemoMb::OutHTMLMemoMb($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows);
	} else {
		require "$cfg->{'DIR_HTML'}/html_memo_pc.pl";
		&SWHtmlMemoPC::OutHTMLMemoPC($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows);
	}
	$memofile->close();
	$logfile->close();

	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
}

1;