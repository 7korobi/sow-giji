package SWCmdLogout;

#----------------------------------------
# ログアウト
#----------------------------------------
sub CmdLogout {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# ライブラリの読み込み
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_pc.pl";

	# データ処理
	&SetDataCmdLogout($sow);
	$sow->{'uid'} = "";

	# HTMLモードの初期化
	$sow->{'html'} = SWHtml->new($sow, "javascript");
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# HTTPヘッダ・HTMLヘッダの出力
	my $outhttp = $sow->{'http'}->outheader();
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('js');

	&SWHtmlPC::OutHTMLGonInit($sow);
	print "\n</script>\n";

	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
	return;
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdLogout {
	my $sow = $_[0];
	my $query  = $sow->{'query'};

	if ($sow->{'user'}->logined() > 0) {
		# ログインしていればログアウトする
		$sow->{'user'}->resetcookie($sow->{'setcookie'});
		$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Logout. [$sow->{'uid'}]");
	}

	return;
}

1;
