package SWHtmlVlogPC;

#----------------------------------------
# 村ログ表示（PCモード）のHTML出力
#----------------------------------------
sub OutHTMLVlogPC {
	my ($sow, $vil, $maxrow, $logfile, $logs, $logkeys, $logrows, $memofile, $memos, $memokeys, $memorows) = @_;
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

	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	my $logfilelist = $logfile->getlist();

	# ログID指定表示スイッチ
	my $modesingle = 0;
	$modesingle = 1 if (($query->{'logid'} ne '') && ($query->{'move'} ne 'prev') && ($query->{'move'} ne 'next'));

	# ログインHTML
	$sow->{'html'}->outcontentheader();
	&SWHtmlPC::OutHTMLLogin($sow) if ($modesingle == 0);
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	# 見出し（村名とRSS）
	my $linkrss = " <a href=\"$link$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);

	print <<"_HTML_";
<h2>{{story.vid}} {{story.name}} $linkrss</h2>
<div class="pagenavi form-inline" template="navi/page_navi" ng-show="page"></div>
<h3>{{subtitle}}</h3>
<div template="navi/messages" id="messages"></div>
<div template="navi/forms" id="forms"></div>
<hr class="invisible_hr"$net>
<div class="pagenavi form-inline" template="navi/page_navi" ng-show="page"></div>

<h3 ng-show="page">表\示している状態</h3>
<div class="pagenavi form-inline" template="navi/switch" ng-show="page"></div>
_HTML_

	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);

	# トップページへ戻る
	&SWHtmlPC::OutHTMLReturnPC($sow) if ($modesingle == 0);
	$sow->{'html'}->outcontentfooter();

	&SWHtmlPC::OutHTMLGonInit($sow); # ログイン欄の出力
	# アナウンス／入力・参加フォーム表示
	if (($modesingle == 0) && ($sow->{'turn'} == $vil->{'turn'}) && ($logrows->{'end'} > 0)) {
		&OutHTMLVlogFormArea($sow, $vil, $memofile)
	}
	$vil->gon_story();
	$vil->gon_event();
	$vil->gon_potofs();
	require "$cfg->{'DIR_HTML'}/html_vlogsingle_pc.pl";

	# 村ログ表示
    my $last = "";
	my $has_all_messages = 0 + (($maxrow < 1)&&($sow->{'turn'} != $vil->{'turn'}));

	print <<"_HTML_";
gon.event.is_news = (0 == $has_all_messages);
gon.event.has_all_messages = (0 != $has_all_messages);
var mes = {
	"template": "sow/village_info",
	"logid": "vilinfo00000"
};
gon.event.messages.push(mes);
_HTML_

	if (@$memos > 0) {
		my %memokeys;
		my %anchor = (
			logfile => $logfile,
			logkeys => \%memokeys,
			rowover => 1,
			reqvals => $reqvals,
		);
		foreach (@$memos) {
			&SWHtmlVlogSinglePC::OutHTMLMemoSinglePC($sow, $vil, $memofile, $_, \%anchor);
		}
	} else {
		$last .= "メモはありません。";
	}

	if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'})) {
		$last .= "終了しました。";
	} else {
		my %anchor = (
			logfile => $logfile,
			logkeys => $logkeys,
			rowover => $rowover,
			reqvals => $reqvals,
		);

		my $i;
		for ($i = 0; $i < @$logs; $i++) {
			my $newsay = 0;
			$newsay = 1 if ($i == $#$logs);
			my $log = $logfile->read($logs->[$i]->{'pos'},$logs->[$i]->{'logpermit'});
			&SWHtmlVlogSinglePC::OutHTMLSingleLogPC($sow, $vil, $log, $i, $newsay, \%anchor, $modesingle);
		}
	}

	print <<"_HTML_";
var log = "← " + ((new Date).format('({dow}){TT}{hh}時{mm}分', 'ja')) + " より先を見る<br />$last";
var mes = {
	"template": "sow/log_last",
	"logid":  "IX99999",
	"log": log,
	"updated_at": new Date
};
gon.event.messages.push(mes);
</script>
_HTML_

	return;
}

#----------------------------------------
# アナウンス／入力・参加フォーム表示
#----------------------------------------
sub OutHTMLVlogFormArea {
	my ($sow, $vil, $memofile) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $pllist = $vil->getpllist();
	my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});

	if (($vil->{'turn'} == 0) && ($vil->checkentried() < 0) && ($vil->{'vplcnt'} > @$pllist)) {
		# プロローグ未参加／未ログイン時アナウンス
		my $scraplimit = "{{lax_time(story.timer.scraplimitdt)}}までに開始しなかった場合、この村は廃村となります。";
		$scraplimit = '' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
gon.cautions.push("演じたいキャラクターを選び、発言してください。");
gon.cautions.push("ルールをよく理解した上でご参加下さい。");
gon.cautions.push("※希望能\力についての発言は控えてください。");
gon.cautions.push("$scraplimit");
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
gon.cautions.push("$epiloguetext");
_HTML_
	}

	# 未発言者リストの表示
	my $nosaytext = &SWHtmlVlog::GetNoSayListText($sow, $vil);
	if (($vil->isepilogue() == 0) && ($nosaytext ne '')) {
		print <<"_HTML_";
gon.cautions.push("$nosaytext");
_HTML_
	}

	# 発言欄／エントリーフォーム
	if ($vil->{'turn'} == 0) {
		# プロローグ
		if ($sow->{'user'}->logined() > 0) {
			# ログイン済み
			if ($vil->checkentried() >= 0) {
				print <<"_HTML_";
gon.cautions.push("{{potof.timer.entry_limit()}}までに一度も発言せず村も開始されなかった場合、あなたは自動的に村から追い出されます。");
gon.cautions.push("※発言すると期限が延長されます。");
_HTML_

				# 発言欄の表示
				require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
				&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil, $memofile);
			} else {
				# エントリーフォームの表示
				require "$cfg->{'DIR_HTML'}/html_entryform_pc.pl";
				&SWHtmlEntryFormPC::OutHTMLEntryFormPC($sow, $vil);
				&OutHTMLVilMakerInFormPlPC($sow, $vil);
			}
		} else {
			# 未ログイン
			if ($vil->{'vplcnt'} > @$pllist) {
				print <<"_HTML_";
gon.cautions.push("ゲーム参加者希望者はログインして下さい。");
_HTML_
			} else {
				print <<"_HTML_";
gon.cautions.push("すでに定員に達しています。");
_HTML_
			}
		}
	} else {
		# 進行中
		if ($sow->{'user'}->logined() > 0) {
			# ログイン済み
			if ($vil->checkentried() >= 0){
				# 発言欄の表示
				require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
				&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil, $memofile);
			} else {
				# 村建て人／管理人発言フォームの表示
				&OutHTMLVilMakerInFormPlPC($sow, $vil);
			}
		} elsif ($vil->isepilogue() == 0) {
			print <<"_HTML_";
gon.cautions.push("参加者はログインしてください。");
_HTML_
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
		&SWHtmlPlayerFormPC::OutHTMLVilMakerPC($sow, $vil, 'maker');
		&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
	}

	if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'}) {
		require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
		&SWHtmlPlayerFormPC::OutHTMLVilMakerPC($sow, $vil, 'admin');
		&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
		&SWHtmlPlayerFormPC::OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
	}

	return;
}

1;
