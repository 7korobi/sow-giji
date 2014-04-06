package SWHtmlOldLog;

#----------------------------------------
# 終了済みの村一覧のHTML出力
#----------------------------------------
sub OutHTMLOldLog {
	my $sow = $_[0];

	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_LIB'}/file_vindex.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_vindex.pl";

	# 村一覧データ読み込み
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();

	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('終了済みの村の一覧'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	print <<"_HTML_";
<h2>終了済みの村の一覧</h2>

_HTML_

	# 終了済み村の表示
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'oldlog');

	print <<"_HTML_";
<h2>廃村の一覧</h2>

_HTML_

	# 終了済み村の表示
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'dispose');

	$vindex->closevindex();

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
