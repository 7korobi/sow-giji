package SWHtmlVilInfoMb;

#----------------------------------------
# 村情報画面のHTML出力（モバイル）
#----------------------------------------
sub OutHTMLVilInfoMb {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $i;

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

	# 村データの読み込み
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader("村の情報 / $sow->{'query'}->{'vid'} $vil->{'vname'}"); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	my $vplcntstart = '';
	$vplcntstart = $vil->{'vplcntstart'} if ($vil->{'vplcntstart'} > 0);

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	# 村名及びリンク表示
	print "<a $atr_id=\"top\">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>\n";

	# キャラ名表示
	if (defined($sow->{'curpl'}->{'uid'})) {
		my $chrname = $sow->{'curpl'}->getlongchrname();
		my $rolename = $sow->{'curpl'}->getrolename();
		print "$chrname$rolename<br$net>\n";
	}

	# 日付別ログへのリンク
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0);

	my $pllist = $vil->getpllist();
	my $lastcnt = $vil->{'vplcnt'} - @$pllist;
	if (($vil->{'turn'} == 0) && ($lastcnt > 0)) {
		print <<"_HTML_";
あと $lastcnt 人参加できます。
<hr$net>
_HTML_
	}

	# $vil->{'vcomment'} =~ s/(s?https?:\/\/[^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/<a href=\"$&\">&lt;$1&gt;<\/a>/g;

	require "$cfg->{'DIR_RS'}/doc_rule.pl";
	my $doc = SWDocRule->new($sow);
	my $nrule = $doc->{'n_rule'};

	my $ncomment = "■国のルール";

	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		$ncomment .= "<br$net>".($i+1).".$name";
	}

	print <<"_HTML_";
■村の名前<br$net>$vil->{'vname'}
<hr$net>

_HTML_

	my $rating = 'default';
	$rating = $vil->{'rating'} if ($vil->{'rating'} ne '');
	print <<"_HTML_";
■こだわり：<br$net>$sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'}
<hr$net>

_HTML_

	print <<"_HTML_";
■村の説明<br$net>$vil->{'vcomment'}<br$net>$ncomment<br$net><br$net>
<hr$net>
_HTML_

	my $updatedt = sprintf("%02d時%02d分", $vil->{'updhour'}, $vil->{'updminite'});
	print <<"_HTML_";
■更新時間<br$net>$updatedt
<hr$net>
_HTML_

	my $interval   = sprintf('%02d時間', $vil->{'updinterval'} * 24);
	my $saycnttype = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	print <<"_HTML_";
■更新間隔<br$net>$interval
<hr$net>
■発言制限：<br$net>$saycnttype->{'CAPTION'} $saycnttype->{'HELP'}
<hr$net>
_HTML_

	my $plcnt;
	if ($vil->{'turn'} == 0) {
		$plcnt = $vil->{'vplcnt'};
		print <<"_HTML_";
■定員（ダミー込み）<br$net>$plcnt人
<hr$net>
_HTML_
	} else {
		$plcnt = @$pllist;
		print <<"_HTML_";
■人数（ダミー込み）<br$net>$plcnt人
<hr$net>
_HTML_
	}

	if (($vil->{'starttype'} eq 'wbbs') && ($vil->{'turn'} == 0)) {
		print <<"_HTML_";
■最低人数<br$net>$vplcntstart人
<hr$net>
_HTML_
	}

	my $secret = $vil->isepilogue();
	$secret = 1 if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});
	my $maker = ($sow->{'uid'} eq $vil->{'makeruid'});

	if ($secret||$maker||($vil->{'mob'} ne 'gamemaster')) {
		my $roleid = $sow->{'ROLEID'};
		my $giftid = $sow->{'GIFTID'};
		my $eventid = $sow->{'EVENTID'};
		my $roletabletext;

		print <<"_HTML_";
■役職配分：<br$net>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}
_HTML_
		# 役職配分表示
		require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
		my ( $rolematrix, $giftmatrix, $eventmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $plcnt);
		$roletabletext = '';
		for ($i = 1; $i < @$roleid; $i++) {
			my $roleplcnt = $rolematrix->[$i];
			$roleplcnt++ if ($i == $sow->{'ROLEID_VILLAGER'}); # ダミーキャラの分１増やす
			if ($roleplcnt > 0) {
				$roletabletext .= "$sow->{'textrs'}->{'ROLENAME'}->[$i]x$roleplcnt ";
			}
		}
		for ($i = 2; $i < @$giftid; $i++) {
			my $giftplcnt = $giftmatrix->[$i];
			if ($giftplcnt > 0) {
				$roletabletext .= "$sow->{'textrs'}->{'GIFTNAME'}->[$i]x$giftplcnt ";
			}
		}
		for ($i = 1; $i < @$eventid; $i++) {
			my $eventplcnt = $eventmatrix->[$i];
			if ($eventplcnt > 0) {
				$roletabletext .= "$sow->{'textrs'}->{'EVENTNAME'}->[$i]x$eventplcnt件 ";
			}
		}
		print "（$roletabletext）<br$net>\n"
	} else {
		print <<"_HTML_";
■役職配分：（非公開）
_HTML_
	}
	print "<hr$net>\n";


	my $mob = 'visiter';
	if ($vil->{'mob'} ne ''){
		$mob = $vil->{'mob'};
		print <<"_HTML_";
■見物人：<br$net>$sow->{'basictrs'}->{'MOB'}->{$mob}->{'CAPTION'}に $vil->{'cntmob'}人まで （$sow->{'basictrs'}->{'MOB'}->{$mob}->{'HELP'}）</p>
<hr$net>

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
■投票方法<br$net>$votetype
<hr$net>
_HTML_

	if ($vil->{'turn'} == 0) {
		my $scraplimit = $sow->{'dt'}->cvtdtmb($vil->{'scraplimitdt'});
		$scraplimit = '自動廃村なし' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
■廃村期限：<br$net>$scraplimit
<hr$net>

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
■登場人物<br$net>$csidcaptions
<hr$net>
■開始方法：<br$net>$sow->{'basictrs'}->{'STARTTYPE'}->{$vil->{'starttype'}}
<hr$net>
■文章系：<br$net>
$sow->{'textrs'}->{'CAPTION'}<br$net>
$sow->{'textrs'}->{'HELP'}
<hr$net>
■ルール：<br$net>
$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'CAPTION'}<br$net>
$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'HELP'}
<hr$net>
_HTML_

	if ($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) {
		my $randomtarget = '投票・能力の対象に「ランダム」を含めない';
		$randomtarget = '投票・能力の対象に「ランダム」を含める' if ($vil->{'randomtarget'} > 0);
		print <<"_HTML_";
■ランダム：<br$net>$randomtarget
<hr$net>
_HTML_
	}

	my $showid = '公開しない';
	$showid = '公開する' if ($vil->{'showid'} > 0);
	print <<"_HTML_";
■ID公開：<br$net>$showid
<hr$net>
_HTML_

	if ($cfg->{'ENABLED_UNDEAD'} == 1){
		my $undead = 'しない';
		$undead = 'する' if ($vil->{'undead'} > 0);
		print <<"_HTML_";
■幽界トーク：<br$net>$undead
<hr$net>
_HTML_
	}

	my $noselrole = '役職希望有効';
	$noselrole = '役職希望無効' if ($vil->{'noselrole'} > 0);
	print <<"_HTML_";
■役職希望：<br$net>$noselrole
<hr$net>

_HTML_

	}

	if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0)) {
		# コミット状況
		my $textrs = $sow->{'textrs'};
		my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);
		my $nextcommitdt = '';
		if ($totalcommit == 3) {
			$nextcommitdt = $sow->{'dt'}->cvtdtmb($vil->{'nextcommitdt'});
			$nextcommitdt = "<br$net>(" . $nextcommitdt . '更新予定)' . "<br$net>";
		}

		print <<"_HTML_";
■コミット状況：<br$net>$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[$totalcommit]
$nextcommitdt<hr$net>

_HTML_
	}

	print <<"_HTML_";
■絞り込み：<br$net>
_HTML_
	print "(プロローグは対象外)<br$net>
\n" if ($vil->{'turn'} == 0);

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'pno'} = '';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	&OutHTMLSayFilterPlayersMb($sow, $vil, 'live'      ,'生存者');
	&OutHTMLSayFilterPlayersMb($sow, $vil, 'victim'    ,'犠牲者');
	&OutHTMLSayFilterPlayersMb($sow, $vil, 'executed'  ,'処刑者');
	&OutHTMLSayFilterPlayersMb($sow, $vil, 'suddendead','突然死者');
	&OutHTMLSayFilterPlayersMb($sow, $vil, 'mob'       ,$sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'});

	print "<a href=\"$urlsow?$linkvalue\">解除</a><br$net>\n" if ($vil->{'turn'} != 0);

	print <<"_HTML_";
<hr$net>

_HTML_

	# 日付別ログへのリンク
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# 個人フィルタの人物欄の表示
#----------------------------------------
sub OutHTMLSayFilterPlayersMb {
	my ($sow, $vil, $livetype, $header) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};


	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'pno'} = '';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	my $pllist = $vil->getallpllist();
	my @filterlist;
	foreach (@$pllist) {
		push(@filterlist, $_) if ($_->{'live'} eq $livetype);
		push(@filterlist, $_) if (($_->{'live'} eq 'cursed')  && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'droop')   && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'suicide') && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'feared')  && ($livetype eq 'victim'));
	}
	my $persuades = 0;
	foreach (@$pllist) {
		next if ($_->{'live'} ne $livetype);
		next if ($_->{'uid'}  eq $cfg->{'USERID_NPC'});
		$persuades += $_->{'actaddpt'}
	}

	@filterlist = sort {$a->{'deathday'} <=> $b->{'deathday'} ? $a->{'deathday'} <=> $b->{'deathday'} : $a->{'pno'} <=> $b->{'pno'}} @filterlist if ($livetype ne 'live');
	my $filtercnt = @filterlist;

	print "□$header ($filtercnt人 $persuades促)<br$net>\n" if($livetype eq 'live');
	print "□$header ($filtercnt人)<br$net>\n"              if($livetype ne 'live');


	foreach (@filterlist) {
		my $chrname = $_->getlongchrname();
		my $unit = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COST_SAY'}}->{'UNIT_SAY'};
		my $restsay = $_->{'say'};
		$restsay = $_->{'gsay'} if ($_->{'live'} ne 'live');

		if ($vil->{'turn'} == 0) {
			print "$chrname";
		} else {
			print "<a href=\"$urlsow?$linkvalue$amp" . "pno=$_->{'pno'}\">$chrname</a>";
		}
		print "($_->{'deathday'}d)" if (($livetype ne 'live')&&($livetype ne 'mob'));
		my $live = 'live';
		$live = $sow->{'curpl'}->{'live'} if (defined($sow->{'curpl'}->{'live'}));
		my $viewall = 0;
		$viewall = $vil->ispublic($_);
		$viewall = 1 if ($live ne 'live');
		# 日蝕
		$viewall = 0 if ($vil->iseclipse($vil->{'turn'}));
		if ($viewall != 0) {
			my $restsay = &SWBase::GetSayCountText($sow, $vil, $_);
			print " 残$restsay<br$net>\n";
		} else {
			print "<br$net>\n";
		}
	}

	return;
}

1;
