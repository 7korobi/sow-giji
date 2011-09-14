package SWHtmlNoReady;

#----------------------------------------
# 準備中のHTML出力
#----------------------------------------
sub OutHTMLNoReady {
	my ($sow, $noregist) = @_;
	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_HTML'}/html.pl";

	my $noregistname = "管理人用ID";
	$noregistname = "ダミーキャラ用ID" if ($noregist == 2);
	my $noregistid = "$noregistname（$sow->{'cfg'}->{'USERID_ADMIN'}）";
	$noregistid = "$noregistname（$sow->{'cfg'}->{'USERID_NPC'}）" if ($noregist == 2);

	# HTTP/HTMLの出力
	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader('準備中'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力
	my $net = $sow->{'html'}->{'net'}; # Null End Tag

	print <<"_HTML_";
<h2>$noregistnameがまだ登録されていません</h2>
<p class="paragraph">
$noregistidが未登録です。<br$net>
右上のログイン欄で新規作成して下さい。
</p>
<hr class="invisible_hr"$net>

_HTML_

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
