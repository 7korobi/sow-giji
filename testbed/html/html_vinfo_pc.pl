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
    &SWHtmlPC::OutHTMLChangeCSS($sow);

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

	# 発言フィルタ
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_sayfilter.pl";
	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLSayFilter($sow, $vil) if ($modesingle == 0);
	&SWHtmlSayFilter::OutHTMLTools    ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLFooter   ($sow, $vil);
	print <<"_HTML_";
<script>
window.gon = {};
_HTML_
	$vil->gon_story();
	$vil->gon_potofs();
	print <<"_HTML_";
</script>
_HTML_

	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
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

<p class="text head" ng-bind-html-unsafe="story.comment"></p>
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
<dt>更新間隔<dd>{{story.upd.interval_text}}{{story.type.recovery}}
<dt>発言制限<dd>{{story.type.saycnt.CAPTION}}<br>{{story.type.saycnt.HELP}}
<dt>役職配分<dd>{{story.type.roletable_text}}
<br>{{story.card.config_names}}
<dt>定員<dd>{{event.player.limit}}人 （ダミーキャラを含む）
<dt>人数<dd>{{potofs.length}}人 （ダミーキャラを含む）
<dt ng-show="story.is_wbbs">最低人数<dd ng-show="story.is_wbbs">{{event.player.start}}人 （ダミーキャラを含む）
<dt>投票方法<dd>{{story.type.vote_text.CAPTION}}
<dt>見物人<dd>{{story.type.mob_text.CAPTION}}に {{event.player.mob}}人まで （{{story.type.mob_text.HELP}}）
<dt>廃村期限<dd>{{lax_time(story.timer.scraplimitdt)}}
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

	# 村建て人フォーム／管理人フォーム表示
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	if ($sow->{'user'}->logined() > 0) {
		my $showbtn = 0;
		$showbtn = 1 if ($sow->{'uid'} eq $vil->{'makeruid'});
		$showbtn = 1 if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'});
		if ($showbtn){
			print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="makerpr"$net>$hidden
    <select id="maker" name="target">
_HTML_
			# 村建て権移譲
			$targetlist = $vil->getallpllist();
			foreach (@$targetlist) {
				next if (($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'}));
				my $chrname = $_->getlongchrname();
				my $pno     = $_->{'pno'};
				print "<option value=\"$pno\">$chrname$sow->{'html'}->{'option'}\n";
			}
			print "</select>";
			print <<"_HTML_";
    <input type="submit" class="btn" value="この人に村を任せる！"$net><br$net>
  </p>
  </form>
_HTML_
		}
		my $showturn = 0;
		$showturn = 1 if ($vil->{'turn'} == 0);
		$showturn = 1 if ($vil->isepilogue() );

		if ($showbtn and $showturn) {
			print <<"_HTML_";
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="editvilform"$net>$hidden
    <input type="submit" class="btn" value="村を編集しよう！"$net>
  </p>
  </form>
</div>
_HTML_
		}
	}

	return;
}

1;
