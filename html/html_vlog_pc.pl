package SWHtmlVlogPC;

#----------------------------------------
# 村ログ表示（PCモード）のHTML出力
#----------------------------------------
sub OutHTMLVlogPC {
	my ($sow, $vil, $maxrow, $logfile, $logs, $logkeys, $logrows, $memofile, $memos, $memokeys, $memorows) = @_;

	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'row'} = '';
	$reqvals->{'rowall'} = '';

	my $news_link = &SWBase::GetLinkValues($sow, $reqvals);
	my $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?".$news_link.$amp."cmd=rss";

	# ログインHTML
	$sow->{'html'}->outcontentheader();
	&SWHtmlPC::OutHTMLLogin($sow);
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	# 見出し（村名とRSS）
	my $linkrss = " <a tabindex=\"-1\" href=\"$link$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);

	print <<"_HTML_";
<div id="messages"></div>
<div id="forms"></div>
<hr class="invisible_hr"$net>
_HTML_

	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);

	# トップページへ戻る
	&SWHtmlPC::OutHTMLReturnPC($sow) if ($modesingle == 0);
	$sow->{'html'}->outcontentfooter();
	print '<div id="tab" template="sow/navi"></div>';

	require "$cfg->{'DIR_HTML'}/html_vlog_js.pl";
	&SWHtmlVlogJS::OutHTMLVlogJS($sow, $vil, $maxrow, $logfile, $logs, $logkeys, $logrows, $memofile, $memos, $memokeys, $memorows);
	return;
}

1;
