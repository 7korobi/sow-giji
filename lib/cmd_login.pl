package SWCmdLogin;

#----------------------------------------
# ログイン
#----------------------------------------
sub CmdLogin {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# ライブラリの読み込み
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_pc.pl";

	# データ処理
	&SetDataCmdLogin($sow);
	$sow->{'uid'} = $query->{'uid'};

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
sub SetDataCmdLogin {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $user = $sow->{'user'};

	my $matchpw = $user->login();
	if ($matchpw > 0) {
		# パスワード照合成功
		$user->setcookie($sow->{'setcookie'});
	} elsif (($matchpw < 0) && ($query->{'pwd'} ne '')) {
		# ユーザーデータ新規作成
		$user->createuser($query->{'uid'}, $query->{'pwd'});
		$user->setcookie($sow->{'setcookie'});
	}
	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Login. [$query->{'uid'}]");

	return;
}

1;
