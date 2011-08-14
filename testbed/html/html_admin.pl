package SWHtmlAdminManager;

#----------------------------------------
# 管理画面メニューのHTML出力
#----------------------------------------
sub OutHTMLAdminManager {
	my $sow   = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "管理人権限が必要です。", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	require "$cfg->{'DIR_HTML'}/html.pl";
	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('管理画面'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	$reqvals->{'cmd'} = 'restrec';
	my $linkrecord = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'restviform';
	my $linkvi = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'movevil';
	my $linkmovevil = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<h2>管理画面メニュー</h2>
<ul class="paragraph">
  <li><a href="$urlsow?$linkrecord">戦績の再構\築</a></li>
  <li><a href="$urlsow?$linkvi">村一覧の再構\築</a></li>
</ul>

<ul class="paragraph">
  <li><a href="$urlsow?$linkmovevil">村データの移動</a></li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
