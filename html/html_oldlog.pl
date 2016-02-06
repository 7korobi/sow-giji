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


	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('終了済みの村の一覧'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();
	print "<DIV class=toppage>";
	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力
	&SWHtmlPC::OutHTMLChangeCSS($sow);
	&SWHtmlPC::OutHTMLGonInit($sow); # ログイン欄の出力

	print <<"_HTML_";
var now = new Date() - 0;

gon.stories = [];
gon.items = [
gon.story_oldlog = { _id: "oldlog-stories-oldlog-11",
updated_at: now },

gon.story_dispose = { _id: "oldlog-stories-dispose-21",
updated_at: now }
];
_HTML_

	# 村一覧データ読み込み
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'oldlog'); # 終了済み村の表示
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'dispose'); # 終了済み村の表示
	$vindex->closevindex();

	print <<"_HTML_";
</script>
<div class="message_filter" id="item-oldlog"></div>
_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る
	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
