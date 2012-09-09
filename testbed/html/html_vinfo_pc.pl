package SWHtmlVilInfo;

#----------------------------------------
# 村情報画面のHTML出力
#----------------------------------------
sub OutHTMLVilInfo {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# JavaScriptの設定
	$sow->{'html'}->{'file_js'} = $sow->{'cfg'}->{'FILE_JS_VIL'};

	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader("村の情報 / $sow->{'query'}->{'vid'} $vil->{'vname'}"); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログインボタン表示

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	# 村データの読み込み
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();
	my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $vid = $vil->{'turn'};
	$vid = $vil->{'epilogue'} if ($vid > $vil->{'epilogue'});
	my $logfile = SWBoa->new($sow, $vil, $vid, 0);
	$logfile->close();

	print <<"_HTML_";
<h2>村の情報</h2>
_HTML_
	&OutHTMLVilInfoInner($sow,$vil);

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	# 発言フィルタ
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_sayfilter.pl";
	$sow->{'html'}->outcontentfooter();

	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLSayFilter($sow, $vil) if ($modesingle == 0);
	&SWHtmlSayFilter::OutHTMLTools    ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLFooter   ($sow, $vil);

	my $secret_show = $vil->isepilogue();
	print <<"_HTML_";
<script>
window.gon = {};
_HTML_
	$vil->gon_story($secret_show);
	$vil->gon_event($secret_show);
	$vil->gon_potofs($secret_show);
	print <<"_HTML_";
</script>
_HTML_

}


sub OutHTMLVilInfoInner {
	my ($sow,$vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $i;

	my $docid = "css=$query->{'css'}&trsid=$vil->{'trsid'}&game=$vil->{'game'}";

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);


	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = $query->{'vid'};
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	my $vplcntstart = '';
	$vplcntstart = $vil->{'vplcntstart'} if ($vil->{'vplcntstart'} > 0);


	my $pllist = $vil->getpllist();
	my $lastcnt = $vil->{'vplcnt'} - @$pllist;
	if (($vil->{'turn'} == 0) && ($lastcnt > 0)) {
		print <<"_HTML_";
<p class="caution">
あと $lastcnt 人参加できます。
</p>
<hr class="invisible_hr"$net>

_HTML_
	}


	my $rating = 'default';
	$rating = $vil->{'rating'} if ($vil->{'rating'} ne '');

	&SWHtml::ConvertNET($sow, \$vil->{'vcomment'});

	require "$cfg->{'DIR_RS'}/doc_rule.pl";
	my $doc = SWDocRule->new($sow);
	my $css = $query->{'css'};
	my $nrule = $doc->{'n_rule'};
	my $saycnttype = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $recovery = ' （発言の補充はありません。）';
	$recovery    = ' （発言の補充があります。）' if (( 1 == $saycnttype->{'RECOVERY'} )&&( 1 < $vil->{'updinterval'} ));

	my $ncomment = "■<a href=\"sow.cgi?cmd=rule&css=$css#rule\">国のルール</a>";
	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		$ncomment .= "<br$net>".($i+1).".$name";
	}

	my @csidlist = split('/', "$vil->{'csid'}/");
	chomp(@csidlist);
	my $csidcaptions;
	foreach (@csidlist) {
		$sow->{'charsets'}->loadchrrs($_);
		$csidcaptions .= "$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} ";
	}

	print <<"_HTML_";
<div class="mes_maker">
<dl class="dl-horizontal">
<dt>村の名前<dd>{{story.name}}
<dt>こだわり
<dd><img name=cd_img src="$cfg->{'DIR_IMG'}/icon/cd_{{story.rating}}.png">
    $sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'}
</dl>
<p class="head" ng-bind-html-unsafe="story.comment"></p>
<p>$ncomment</p>
<p>
■<a href=\"sow.cgi?cmd=rule&css=$css#mind\">心構\え</a>
</p>
</div>
<div class="mes_maker">
<dl>
<dt>$sow->{'textrs'}->{'CAPTION'}
<dd>$sow->{'textrs'}->{'HELP'}
</dl>

<dl>
<dt>$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'CAPTION'}
<dd>$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'HELP'}
</dl>

<dl class="dl-horizontal">
<dt>登場人物<dd>$csidcaptions
<dt>更新時間<dd>{{story.upd.time_text}}
<dt>更新間隔<dd>{{story.upd.interval_text}}$recovery
<dt>発言制限<dd>$saycnttype->{'CAPTION'}<br>$saycnttype->{'HELP'}
<dt>役職配分<dd>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}
<br>{{story.card.config_names}}
_HTML_

	my $plcnt;
	if ($vil->{'turn'} == 0) {
		print <<"_HTML_";
<dt>定員<dd>{{event.player.limit}}人 （ダミーキャラを含む）</p>
_HTML_
	} else {
		$plcnt = @$pllist;
		print <<"_HTML_";
<dt>人数<dd>$plcnt人 （ダミーキャラを含む）</p>
_HTML_
	}

	if (($vil->{'starttype'} eq 'wbbs') && ($vil->{'turn'} == 0)) {
		print <<"_HTML_";
<dt>最低人数<dd>{{event.player.start}}人
_HTML_
	}

	my $mob = 'visiter';
	if ($vil->{'mob'} ne ''){
		$mob = $vil->{'mob'};
		print <<"_HTML_";
<dt>見物人<dd>$sow->{'basictrs'}->{'MOB'}->{$mob}->{'CAPTION'}に $vil->{'cntmob'}人まで （$sow->{'basictrs'}->{'MOB'}->{$mob}->{'HELP'}）
_HTML_
	}

	my %votecaption = (
		anonymity => '無記名投票',
		sign => '記名投票',
	);
	my $votetype = '----';
	if (defined($vil->{'votetype'})) {
		$votetype = $votecaption{$vil->{'votetype'}} if (defined($votecaption{$vil->{'votetype'}}));
	}
	print <<"_HTML_";
<dt>投票方法<dd>$votetype
_HTML_

	if ($vil->{'turn'} == 0) {
		my $scraplimit = $sow->{'dt'}->cvtdt($vil->{'scraplimitdt'});
		$scraplimit = '自動廃村なし' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
<dt>廃村期限<dd>{{lax_time(story.timer.scraplimitdt)}}
_HTML_
	}

	print <<"_HTML_";
</dl>
</div>
<div class="mes_maker">
<ul>
<li>$sow->{'basictrs'}->{'STARTTYPE'}->{$vil->{'starttype'}}
<li ng-repeat="option_help in story.option_helps">{{option_help}}</li>
</ul>
</div>
_HTML_

	if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0)) {
		# コミット状況
		my $textrs = $sow->{'textrs'};
		my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);
		my $nextcommitdt = '';
		if ($totalcommit == 3) {
			$nextcommitdt = $sow->{'dt'}->cvtdt($vil->{'nextcommitdt'});
			$nextcommitdt = '（' . $nextcommitdt . '更新予定）';
		}
		print <<"_HTML_";
<div class="paragraph">
<dl class="dl-horizontal">
<dt>コミット状況<dd>$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[$totalcommit]
<br>$nextcommitdt
</dl>
</div>
_HTML_
	}

	return;
}

1;
