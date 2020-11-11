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

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $vid = $vil->{'turn'};
	$vid = $vil->{'epilogue'} if ($vid > $vil->{'epilogue'});
	my $logfile = SWBoa->new($sow, $vil, $vid, 0);
	$logfile->close();

	# 日付別ログへのリンク
	my $list = $logfile->getlist();
	my @dummy;
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil, \@dummy, $list);

	my $score = '';
	$score =" (<a href=\"$urlsow?$linkvalue$amp" . "cmd=score\">人狼譜</a>)" if ($vil->{'turn'} >= $vil->{'epilogue'});

	print <<"_HTML_";
<h2>村の情報</h2>
_HTML_
	&OutHTMLVilInfoInner($sow,$vil);

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
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

	print <<"_HTML_";
<div class="mes_maker"><div class="guide">
<p class="multicolumn_label">村の名前：</p>
<p class="multicolumn_left">$vil->{'vname'}</p>
<br class="multicolumn_clear"$net>

_HTML_

	my $rating = 'default';
	$rating = $vil->{'rating'} if ($vil->{'rating'} ne '');
	print <<"_HTML_";

<p class="multicolumn_label">こだわり：</p>
<p class="multicolumn_left">$sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'}</p>
<br class="multicolumn_clear"$net>
_HTML_

	&SWHtml::ConvertNET($sow, \$vil->{'vcomment'});
	$vil->{'vcomment'} =~ s/(s?https?:\/\/[^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/<a href=\"$&\">$1...<\/a>/g;

	require "$cfg->{'DIR_RS'}/doc_rule.pl";
	my $doc = SWDocRule->new($sow);
	my $nrule = $doc->{'n_rule'};
	
	my $css      = $query->{'css'};
	my $ncomment = "■<a href=\"sow.cgi?cmd=rule&css=$css#rule\">国のルール</a>";

	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		$ncomment .= "<br$net>".($i+1).".$name";
	}

	print <<"_HTML_";
<dl class="mes_text_report">
<dd>$vil->{'vcomment'}<br$net>$ncomment<br$net>■<a href=\"sow.cgi?cmd=rule&css=$css#mind\">心構\え</a><br$net>
</dl>
</div></div>

<div class="mes_maker"><div class="guide">
<dl class="mes_text_report">
<dt>$sow->{'textrs'}->{'CAPTION'}
<dd>$sow->{'textrs'}->{'HELP'}
</dl>
<dl class="mes_text_report">
<dt>$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'CAPTION'}
<dd>$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'HELP'}
</dl>
_HTML_

	my $updatedt = sprintf("%02d時%02d分", $vil->{'updhour'}, $vil->{'updminite'});
	print <<"_HTML_";
<p class="multicolumn_label">更新時間：</p>
<p class="multicolumn_left">$updatedt</p>
<br class="multicolumn_clear"$net>

_HTML_
	my $saycnttype = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $recovery = ' （発言の補充はありません。）';
	$recovery    = ' （発言の補充があります。）' if (( 1 == $saycnttype->{'RECOVERY'} )&&( 1 < $vil->{'updinterval'} ));
	my $interval = sprintf('%02d時間', $vil->{'updinterval'} * 24).$recovery;
	print <<"_HTML_";
<p class="multicolumn_label">更新間隔：</p>
<p class="multicolumn_left">$interval</p>
<br class="multicolumn_clear"$net>

<p class="multicolumn_label">発言制限：</p>
<p class="multicolumn_left">$saycnttype->{'CAPTION'} $saycnttype->{'HELP'}</p>
<br class="multicolumn_clear"$net>

_HTML_

	my $plcnt;
	if ($vil->{'turn'} == 0) {
		$plcnt = $vil->{'vplcnt'};
		print <<"_HTML_";
<p class="multicolumn_label">定員：</p>
<p class="multicolumn_left">$vil->{'vplcnt'}人 （ダミーキャラを含む）</p>
<br class="multicolumn_clear"$net>
_HTML_
	} else {
		$plcnt = @$pllist;
		print <<"_HTML_";
<p class="multicolumn_label">人数：</p>
<p class="multicolumn_left">$plcnt人 （ダミーキャラを含む）</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	if (($vil->{'starttype'} eq 'wbbs') && ($vil->{'turn'} == 0)) {
		print <<"_HTML_";
<p class="multicolumn_label">最低人数：</p>
<p class="multicolumn_left">$vplcntstart人</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	my $roleid  = $sow->{'ROLEID'};
	my $giftid  = $sow->{'GIFTID'};
	my $eventid = $sow->{'EVENTID'};
	my $roletabletext;

	print <<"_HTML_";
<dl class="mes_text_report">
<dt>
役職配分：$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}
_HTML_

	if (1){
#	if (($vil->{'turn'} > 0)||($vil->{'roletable'} eq 'custom')) {
		# 役職配分表示
		require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
		my ( $rolematrix, $giftmatrix, $eventmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $plcnt);
		$roletabletext = '';
		for ($i = 1; $i < @$roleid; $i++) {
			
			my $roleplcnt = $rolematrix->[$i];
			$roleplcnt++ if ($i == $sow->{'ROLEID_VILLAGER'}); # ダミーキャラの分１増やす
			if ($roleplcnt > 0) {
				my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
				$roletabletext .= "<a href=\"$url\">$sow->{'textrs'}->{'ROLENAME'}->[$i]</a>x$roleplcnt ";
			}
		}
		for ($i = 2; $i < @$giftid; $i++) {
			my $giftplcnt = $giftmatrix->[$i];
			if ($giftplcnt > 0) {
				my $url     = "sow.cgi?cmd=rolelist&$docid&giftid=GIFTID_".uc($sow->{'GIFTID'}->[$i]);
				$roletabletext .= "<a href=\"$url\">$sow->{'textrs'}->{'GIFTNAME'}->[$i]</a>x$giftplcnt ";
			}
		}
		for ($i = 1; $i < @$eventid; $i++) {
			my $eventplcnt = $eventmatrix->[$i];
			if ($eventplcnt > 0) {
				$roletabletext .= "$sow->{'textrs'}->{'EVENTNAME'}->[$i]x$eventplcnt件 ";
			}
		}
		print "<dd>$roletabletext</dd>\n"
	}


	print <<"_HTML_";
<br class="multicolumn_clear"$net>

_HTML_

	my $mob = 'visiter';
	if ($vil->{'mob'} ne ''){
		$mob = $vil->{'mob'};
		print <<"_HTML_";

<p class="multicolumn_label">見物人：</p>
<p class="multicolumn_left">$sow->{'basictrs'}->{'MOB'}->{$mob}->{'CAPTION'}に $vil->{'cntmob'}人まで （$sow->{'basictrs'}->{'MOB'}->{$mob}->{'HELP'}）</p>
<br class="multicolumn_clear"$net>
_HTML_

	my %votecaption = (
		anonymity => '無記名投票',
		sign => '記名投票',
	);
	my $votetype = '----';
	if (defined($vil->{'votetype'})) {
		$votetype = $votecaption{$vil->{'votetype'}} if (defined($votecaption{$vil->{'votetype'}}));
	}
	print <<"_HTML_";
<p class="multicolumn_label">投票方法：</p>
<p class="multicolumn_left">$votetype</p>
<br class="multicolumn_clear"$net>

_HTML_

	if ($vil->{'turn'} == 0) {
		my $scraplimit = $sow->{'dt'}->cvtdt($vil->{'scraplimitdt'});
		$scraplimit = '自動廃村なし' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
<p class="multicolumn_label">廃村期限：</p>
<p class="multicolumn_left">$scraplimit</p>
<br class="multicolumn_clear"$net>

_HTML_
	}

	my @csidlist = split('/', "$vil->{'csid'}/");
	chomp(@csidlist);
	my $csidcaptions;
	foreach (@csidlist) {
		$sow->{'charsets'}->loadchrrs($_);
		$csidcaptions .= "$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} ";
	}

	print <<"_HTML_";
</div></div>

<div class="mes_maker"><div class="guide">
<p class="multicolumn_label">登場人物：</p>
<p class="multicolumn_left">$csidcaptions</p>
<br class="multicolumn_clear"$net>

<p class="multicolumn_label">開始方法：</p>
<p class="multicolumn_left">$sow->{'basictrs'}->{'STARTTYPE'}->{$vil->{'starttype'}}</p>
<br class="multicolumn_clear"$net>

_HTML_

	if ($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) {
		my $randomtarget = '投票・能力の対象に「ランダム」を含めない';
		$randomtarget = '投票・能力の対象に「ランダム」を含める' if ($vil->{'randomtarget'} > 0);
		print <<"_HTML_";

<p class="multicolumn_label">ランダム：</p>
<p class="multicolumn_left">$randomtarget</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	my $showid = '公開しない';
	$showid = '公開する' if ($vil->{'showid'} > 0);
	print <<"_HTML_";

<p class="multicolumn_label">ID公開：</p>
<p class="multicolumn_left">$showid</p>
<br class="multicolumn_clear"$net>
_HTML_

	if( $sow->{'cfg'}->{'ENABLED_UNDEAD'} == 1 ){
		my $undead = 'しない';
		$undead = 'する' if ($vil->{'undead'} > 0);
		print <<"_HTML_";

<p class="multicolumn_label">幽界トーク：</p>
<p class="multicolumn_left">$undead</p>
<br class="multicolumn_clear"$net>
_HTML_
	}
	my $noselrole = '役職希望有効';
	$noselrole = '役職希望無効' if ($vil->{'noselrole'} > 0);
	print <<"_HTML_";

<p class="multicolumn_label">役職希望：</p>
<p class="multicolumn_left">$noselrole</p>
<br class="multicolumn_clear"$net>
_HTML_

	}

	print "</div>\n\n";

	if (($cfg->{'ENABLED_QR'} > 0) && ($sow->{'user'}->logined() > 0)) {
		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'}   = '';
		$reqvals->{'uid'}   = $sow->{'uid'};
		$reqvals->{'pwd'}   = $sow->{'cookie'}->{'pwd'}; # 暫定
		$reqvals->{'order'} = 'd'; # 暫定
		$reqvals->{'row'}   = 10; # 暫定
		my $backupamp = $sow->{'html'}->{'amp'};
		$sow->{'html'}->{'amp'} = '&';
		my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
		$sow->{'html'}->{'amp'} = $backupamp;
		my $urlsow = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}";
		my $url = &SWBase::EncodeURL("$urlsow?$linkvalue");
		my $imgurl = "$cfg->{'URL_QR'}?s=3$amp" . "d=$url";
		print <<"_HTML_";
<div class="paragraph">
<p class="multicolumn_label">QRコード：</p>
<p class="multicolumn_left">
<img src="$imgurl" alt="QRコード画像"$net><br$net>
</p>
<br class="multicolumn_clear"$net>
</div></div>

_HTML_
	}

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
<p class="multicolumn_label">コミット状況：</p>
<p class="multicolumn_left">
$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[$totalcommit]<br$net>
$nextcommitdt
</p>
<br class="multicolumn_clear"$net>
</div></div>

_HTML_
	}

	return;
}

1;
