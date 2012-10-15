package SWHtmlVlogPC;

#----------------------------------------
# 村ログ表示（PCモード）のHTML出力
#----------------------------------------
sub OutHTMLVlogPC {
	my ($sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows) = @_;
	my $pllist = $vil->getpllist();

	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $reqvals = &SWBase::GetRequestValues($sow);

	$reqvals->{'row'} = '';
	$reqvals->{'rowall'} = '';
	my $news_link = &SWBase::GetLinkValues($sow, $reqvals);
	$news_link   = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $news_link;

	$reqvals->{'rowall'} = 'on';
	my $rowall_link = &SWBase::GetLinkValues($sow, $reqvals);
	$rowall_link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $rowall_link;

	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	my $logfilelist = $logfile->getlist();

	# ログID指定表示スイッチ
	my $modesingle = 0;
	$modesingle = 1 if (($query->{'logid'} ne '') && ($query->{'move'} ne 'prev') && ($query->{'move'} ne 'next'));

	# ログインHTML
	$sow->{'html'}->outcontentheader();
	&SWHtmlPC::OutHTMLLogin($sow) if ($modesingle == 0);


	# 見出し（村名とRSS）
	my $linkrss = " <a href=\"$link$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);

    &SWHtmlPC::OutHTMLChangeCSS($sow);

	print <<"_HTML_";
<h2>$query->{'vid'} $vil->{'vname'} $linkrss</h2>
<div class="pagenavi" template="navi/page_navi">
<a ng-show="event.is_news" class="btn" href="$rowall_link">全て表\示</a>
<a ng-hide="event.is_news" class="btn" href="$news_link">最新の発言</a>
</div>
_HTML_

	print <<"_HTML_";
<div id="messages" template="navi/messages"></div>
_HTML_

	# アナウンス／入力・参加フォーム表示
	if (($modesingle == 0) && ($sow->{'turn'} == $vil->{'turn'}) && ($rows->{'end'} > 0)) {
		&OutHTMLVlogFormArea($sow, $vil)
	}

	if ($modesingle == 0) {
		$reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'order'} = '';
		$reqvals->{'row'} = '';
		my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

		my $option = $sow->{'html'}->{'option'};
		my $desc = '';
		my $asc = " $sow->{'html'}->{'selected'}";
		my $star_desc = '';
		my $star_asc = ' *';
		if (($query->{'order'} eq 'd') || ($query->{'order'} eq 'desc')) {
			$desc = " $sow->{'html'}->{'selected'}";
			$asc = '';
			$star_desc = ' *';
			$star_asc = '';
		}

		print <<"_HTML_";
<hr class="invisible_hr"$net>
<div class="pagenavi" template="navi/page_navi">
<a ng-show="event.is_news" class="btn" href="$rowall_link">全て表\示</a>
<a ng-hide="event.is_news" class="btn" href="$news_link">最新の発言</a>
</div>
_HTML_
	}

	# トップページへ戻る
	&SWHtmlPC::OutHTMLReturnPC($sow) if ($modesingle == 0);

	# 発言フィルタ
	$sow->{'html'}->outcontentfooter();

	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLSayFilter($sow, $vil) if ($modesingle == 0);
	&SWHtmlSayFilter::OutHTMLTools    ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLFooter   ($sow, $vil);
	print <<"_HTML_";
<script>
window.gon = {};
_HTML_
	$vil->gon_story();
	$vil->gon_event();
	$vil->gon_potofs();

	# 村ログ表示
	require "$cfg->{'DIR_HTML'}/html_vlogsingle_pc.pl";
	my %anchor = (
		logfile => $logfile,
		logkeys => $logkeys,
		rowover => $rowover,
		reqvals => $reqvals,
	);


	if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'})) {
		print <<"_HTML_"
var mes = {
	"subid":  "I",
	"logid":  "IX00000",
	"mestype":  "CAUTION",
	"style":    "head",
	"log":   "終了しました。",
	"date":  new Date
};
gon.event.messages.push(mes);
_HTML_
	} else {
		my $i;
		for ($i = 0; $i < @$logs; $i++) {
			my $newsay = 0;
			$newsay = 1 if ($i == $#$logs);
			my $log = $logfile->read($logs->[$i]->{'pos'},$logs->[$i]->{'logpermit'});
			&SWHtmlVlogSinglePC::OutHTMLSingleLogPC($sow, $vil, $log, $i, $newsay, \%anchor, $modesingle);
		}
	}

	# 全表示リンク
	my $is_news = 0 + (0 < $maxrow);

	print <<"_HTML_";
gon.event.is_news    = (0 != $is_news);
</script>
_HTML_

	return;
}

#----------------------------------------
# アナウンス／入力・参加フォーム表示
#----------------------------------------
sub OutHTMLVlogFormArea {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $pllist = $vil->getpllist();
	my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});

	if (($vil->{'turn'} == 0) && ($vil->checkentried() < 0) && ($vil->{'vplcnt'} > @$pllist)) {
		# プロローグ未参加／未ログイン時アナウンス
		my $scraplimit = "\n\n<p class=\"caution\">\n" . $sow->{'dt'}->cvtdt($vil->{'scraplimitdt'}) . "までに開始しなかった場合、この村は廃村となります。\n</p>";
		$scraplimit = '' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
<p class="caution">
演じたいキャラクターを選び、発言してください。<br$net>
ルールをよく理解した上でご参加下さい。<br$net>
※希望能\力についての発言は控えてください。
</p>$scraplimit
<hr class="invisible_hr"$net>

_HTML_
	} elsif ($vil->isepilogue() > 0) {
		# エピローグ用アナウンス
		my $caption_winner = $sow->{'textrs'}->{'CAPTION_WINNER'};
		my $victorytext = $sow->{'textrs'}->{'ANNOUNCE_VICTORY'};
		my $caption = $caption_winner->[$vil->{'winner'}];
		$victorytext =~ s/_VICTORY_/$caption/g;
		$victorytext = '' if ($vil->{'winner'} == 0);
		my $epiloguetext = $sow->{'textrs'}->{'ANNOUNCE_EPILOGUE'};
		$epiloguetext =~ s/_AVICTORY_/$victorytext/g;
		$epiloguetext =~ s/_DATE_/$date/g;
		&SWHtml::ConvertNET($sow, \$epiloguetext);

		print <<"_HTML_";
<p class="caution">
$epiloguetext
</p>
<hr class="invisible_hr"$net>

_HTML_
	}

	# 未発言者リストの表示
	my $nosaytext = &SWHtmlVlog::GetNoSayListText($sow, $vil);
	if (($vil->isepilogue() == 0) && ($nosaytext ne '')) {
		print "<p class=\"caution\">$nosaytext</p>\n";
		print "<hr class=\"invisible_hr\"$net>\n\n";
	}

	# 発言欄／エントリーフォーム
	if ($vil->{'turn'} == 0) {
		# プロローグ
		if ($sow->{'user'}->logined() > 0) {
			# ログイン済み
			if ($vil->checkentried() >= 0) {
				print <<"_HTML_";
<p class="caution" ng-show="0 < potof.timer.limitentrydt">
{{potof.timer.entry_limit()}}までに一度も発言せず村も開始されなかった場合、あなたは自動的に村から追い出されます。<br$net>
※発言すると期限が延長されます。
</p>
_HTML_

				# 発言欄の表示
				require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
				&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil);
			} else {
				# エントリーフォームの表示
				require "$cfg->{'DIR_HTML'}/html_entryform_pc.pl";
				&SWHtmlEntryFormPC::OutHTMLEntryFormPC($sow, $vil);
				&OutHTMLVilMakerInFormPlPC($sow, $vil);
			}
		} else {
			# 未ログイン
			if ($vil->{'vplcnt'} > @$pllist) {
				print "<p class=\"infonologin\">\nゲーム参加者希望者はログインして下さい。\n</p>\n";
				print "<hr class=\"invisible_hr\"$net>\n\n";
			} else {
				print "<p class=\"caution\">\n既に定員に達しています。\n</p>\n";
				print "<hr class=\"invisible_hr\"$net>\n\n";
			}
		}
	} else {
		# 進行中
		if ($sow->{'user'}->logined() > 0) {
			# ログイン済み
			if ($vil->checkentried() >= 0){
				# 発言欄の表示
				require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
				&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil);
			} else {
				# 村建て人／管理人発言フォームの表示
				&OutHTMLVilMakerInFormPlPC($sow, $vil);
			}
		} elsif ($vil->isepilogue() == 0) {
			# 未ログイン
			print "<p class=\"infonologin\">\n参加者はログインして下さい。\n</p>\n";
			print "<hr class=\"invisible_hr\"$net>\n\n";
		}
	}
	return;
}

#----------------------------------------
# 村建て人フォーム／管理人フォームの表示
# （村建て人／管理人が参加していない時）
#----------------------------------------
sub OutHTMLVilMakerInFormPlPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};

	if ($vil->{'makeruid'} eq $sow->{'uid'}) {
		require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
		print "<div class=\"formpl_frame\">\n";
		&SWHtmlPlayerFormPC::OutHTMLVilMakerPC($sow, $vil, 'maker');
		&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
		print "</div>\n";
	}

	if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'}) {
		require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
		print "<div class=\"formpl_frame\">\n";
		&SWHtmlPlayerFormPC::OutHTMLVilMakerPC($sow, $vil, 'admin');
		&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
		&SWHtmlPlayerFormPC::OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
		print "</div>\n";
	}

	return;
}

1;
