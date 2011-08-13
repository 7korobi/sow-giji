package SWCmdChrList;

#----------------------------------------
# キャラ一覧表示
#----------------------------------------
sub CmdChrList {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_chrlist.pl";
	my $title = &SWHtmlChrList::GetHTMLChrListTitle();

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader($title); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログインボタン

	# キャラ一覧画面のHTML出力
	&SWHtmlChrList::OutHTMLChrList($sow);

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter('');
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

}

1;