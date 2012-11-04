package SWHtmlPlayerFormPC;

#----------------------------------------
# プレイヤー発言／行動欄HTML出力
#----------------------------------------
sub OutHTMLPlayerFormPC {
	my ($sow, $vil, $memofile) = @_;
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};

	# 発言欄HTML出力
	&OutHTMLSayPC($sow, $vil, $memofile);

	# コミットボタン
	&OutHTMLCommitFormPC($sow, $vil) if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0) && ($sow->{'curpl'}->iscommitter()));

	# 能力者欄HTML出力
	my %role;
	if ($curpl->{'role'} < 0) {
		$role{'role'} = $curpl->{'selrole'};
	} else {
		if ($curpl->issensible()){
			$role{'role'} = $curpl->{'role'};
		} else {
			$role{'role'} = 0;
		}
	}
	$role{'gift'} = $curpl->{'gift'};
	my $textrs = $sow->{'textrs'};
	if ($curpl->{'role'} < 0) {
		$role{'explain'} = $textrs->{'EXPLAIN'}->{'prologue'};
	} elsif ($vil->isepilogue() != 0) {
		$role{'explain'} = $textrs->{'EXPLAIN'}->{'epilogue'};
	} else {
		$role{'explain'} = $textrs->{'EXPLAIN'}->{'dead'};
	}
	my $url = $sow->{'cfg'}->{'URL_ROLE'} . uc($sow->{'ROLEID'}->[$curpl->{'selrole'}]);
	my $selrolename = "<a href=\"$url\">". $textrs->{'ROLENAME'}->[$curpl->{'selrole'}] ."</a>";
	$selrolename = $textrs->{'RANDOMROLE'} if ($curpl->{'selrole'} < 0);
	$role{'explain_role'} = $textrs->{'EXPLAIN'}->{'explain_role'};
	$role{'explain_gift'} = $textrs->{'EXPLAIN'}->{'explain_gift'};
	if ($curpl->{'role'} == $sow->{'ROLEID_MOB'}) {
		$role{'explain'} = $textrs->{'EXPLAIN'}->{'mob'};
		$role{'explain'} =~ s/_ROLE_/$sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'}/;
	} else {
		$role{'explain'} =~ s/_SELROLE_/$selrolename/;
		$role{'explain'} =~ s/_ROLE_/$textrs->{'ROLENAME'}->[$curpl->{'role'}]/;
	}

	&OutHTMLRolePC($sow, $vil, \%role);
	&OutHTMLExitButtonPC() if ($vil->{'turn'} == 0);

	# 村建て人フォーム／管理人フォーム表示
	if ($sow->{'user'}->logined() > 0) {
		if ($vil->{'makeruid'} eq $sow->{'uid'}) {
			&OutHTMLVilMakerPC($sow, $vil, 'maker');
			&OutHTMLUpdateSessionButtonPC($sow, $vil);
		}
		if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}) {
			&OutHTMLVilMakerPC($sow, $vil, 'admin');
			&OutHTMLUpdateSessionButtonPC($sow, $vil);
			&OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
		}
	}

	print "\n\n";

	return;
}

#----------------------------------------
# 発言欄HTML出力
#----------------------------------------
sub OutHTMLSayPC {
	my ($sow, $vil, $memofile) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net   = $sow->{'html'}->{'net'};

	my $curpl   = $sow->{'curpl'};
	my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

	my $rolename = $curpl->getrolename();
	my $longchrname  = $curpl->getlongchrname();

	# キャラ画像
	my $img = $curpl->{'csid'}."/".$curpl->{'cid'};

    my $mestype = "SAY";
    $mestype = "GSAY" if('live' ne $curpl->{'live'});

    # 発言/独り言/内緒話
	my ($saycnt,$cost,$unit, $max_unit,$max_line,$max_size) = $vil->getsayptcosts();
	my $tsaycnttext = "あと".$curpl->{'tsay'}.$unit                                if ($cost ne 'none');
	my $ssaycnttext = "あと".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if ($cost ne 'none');
	my $asaycnttext = $ssaycnttext;

	# 発言欄textarea要素の出力
	my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_PC'};
	my $title = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	$title =~ s/_BUTTON_/$caption_say/g;

    # メモ関連
	my ($saycnt,$cost,$unitaction, $max_unit,$max_line,$max_size) = $vil->getmemoptcosts();
	my $memocost = '無制限に貼り付けられ';
	my $memocnttext;
	$memocost    = '使うとアクション回数を消費し' if( $cost eq 'count' );
	$memocost    = '使うと発言を20pt消費し'       if( $cost eq 'point' );
	$memocnttext = "あと".$curpl->{'say_act'}.$unitaction                       if( $cost eq 'count' );
	$memocnttext = "あと".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if( $cost eq 'point' );

	my $mes = "";
	if ($memofile){
		my $memo = $memofile->getnewmemo($curpl);
		$mes = $memo->{'log'};
		$mes = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $mes, $anchor);
		$mes =~ s/<br( \/)?>/\\n/ig;
		&SWHtml::ConvertJSON(\$mes);
	}

	print <<"_HTML_";
text_form = {
	cmd: "wrmemo",
	jst: "memo",
	text: "$mes",
	votes: [],
	style: "",
	title: "メモを貼\る",
	count: "$memocnttext",
	caption: "※メモを$memocostます。",
	max: {
		unit: "$max_unit",
		line: $max_line,
		size: $max_size,
	},
	mestype: "$mestype",
	csid_cid: "$img",
	longname: "$longchrname",
}
gon.form.texts.push(text_form);

text_form = {
	cmd: "write",
	jst: "open",
	text: "",
	votes: [],
	style: "",
	title: "$title",
	caption: "",
	max: {
		unit: "$max_unit",
		line: $max_line,
		size: $max_size,
	},
	csid_cid: "$img",
	longname: "$longchrname",
	target: "-1",
	targets: [
{val:"-1",          mestype:"$mestype", name:"$ssaycnttext ($sow->{'textrs'}->{'CAPTION_SAY_PC'})"},
{val:"$curpl->{'pno'}", mestype:"TSAY", name:"$tsaycnttext ($sow->{'textrs'}->{'CAPTION_TSAY_PC'})"},
_HTML_
	if ((1 == $cfg->{'ENABLED_AIMING'})
      ||($sow->{'uid'} eq $cfg->{'USERID_ADMIN'})
      ||($sow->{'uid'} eq $cfg->{'USERID_NPC'})){
		# 内緒話の対象者
		my $pllist = $vil->getallpllist();
		foreach (@$pllist) {
			next if (0 == $curpl->isAim($_));

			my $targetname = $_->getshortchrname();
			print <<"_HTML_";
{val:"$_->{'pno'}", mestype:"AIM", name:"$asaycnttext $targetnameと内緒話"},
_HTML_
		}
	}
	print <<"_HTML_";
	],
	roles: [
_HTML_
	# 希望する能力の表示
	if ( $vil->{'turn'} < 1){
		if ($isplok) {
			print "{val:\"-1\", name:\"$sow->{'textrs'}->{'RANDOMROLE'}\"},\n";
			my $rolename = $sow->{'textrs'}->{'ROLENAME'};
			my ( $rolematrix, $giftmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'});

			my $i;
			foreach ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
				my $output = $rolematrix->[$i];
				$output = 1 if ($i == 0); # おまかせは必ず表示
				print "{val:\"$i\", name:\"$rolename->[$i]\"},\n" if ($output > 0);
			}
		}
		if ($ismobok){
			my $mob = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'};
			print "{val:\"$sow->{'ROLEID_MOB'}\", name:\"$mobで見物\"},\n";
		}
	}
	print <<"_HTML_";
	],
};
gon.form.texts.push(text_form);
_HTML_

	# 投票先変更プルダウン
	if( $curpl->setvote_to($sow,$vil) != 0 ){
		&OutHTMLVotePC($sow, $vil, 'vote');
	}
	if( $curpl->setentrust($sow,$vil) != 0 ){
		&OutHTMLVotePC($sow, $vil, 'entrust');
	}

	# 表情選択欄
	#&OutHTMLExpressionFormPC($sow, $vil);

	# アクション
	&OutHTMLActionFormPC($sow, $vil);
	return;
}

#----------------------------------------
# アクションフォームの出力
#----------------------------------------
sub OutHTMLActionFormPC {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};
	my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $pllist = $vil->getpllist();

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	my $chrname = $curpl->getchrname();

	# アクション入力欄とアクションボタン
	my ($saycnt,$costaction,$unitaction, $max_unit,$max_line,$max_size) = $vil->getactptcosts();
	my $actcnttext = "あと".$curpl->{'say_act'}.$unitaction  if ($costaction ne 'none');

	print <<"_HTML_";
text_form = {
	cmd: "action",
	jst: "action",
	text: "",
	title: "アクション",
	count: "$actcnttext",
	max: {
		unit: "$max_unit",
		line: $max_line,
		size: $max_size,
	},
	mestype: "SAY",
	shortname: "$chrname",
	target: "-1",
	targets: [
{val:"-1", name:"（選択しない）"},
_HTML_
	# アクションの対象者
	foreach (@$pllist) {
		next if (0 == $curpl->isAction($_));

		my $targetname = $_->getchrname();
		print <<"_HTML_";
{val:"$_->{'pno'}", name:"$targetname"},
_HTML_
	}
	print <<"_HTML_";
	],
	action: "-99",
	actions: [
{val:"-99", name:"（↓自由に入力）"},
_HTML_
	# 組み込み済みアクション
	my $actions = $sow->{'textrs'}->{'ACTIONS'};
	my $i;
	for ($i = 0; $i < @$actions; $i++) {
		print <<"_HTML_";
{val:"$i", name:"$actions->[$i]"},
_HTML_
	}
	if ($curpl->{'live'} eq 'live'){
		# 昇進と降格
		my $actions_up = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_UP'};
		if( $actions_up ){
			print <<"_HTML_";
{val:"-4", name:"$actions_up"},
_HTML_
		}
		my $actions_down = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_DOWN'};
		if( $actions_down ){
			print <<"_HTML_";
{val:"-5", name:"$actions_down"},
_HTML_
		}

		# zap!zap!zap!
		# 処刑があるうちはクローンナンバーは増えない。
		my $actions_zap = $sow->{'textrs'}->{'ACTIONS_ZAP'}  if ( $vil->{'turn'} < 2 || $vil->{'epilogue'} <= $vil->{'turn'});
		if( $actions_zap ){
			my $zapcount = $sow->{'textrs'}->{'ACTIONS_ZAPCOUNT'};
			$zapcount =~ s/_POINT_/$curpl->{'zapcount'}/g;
			$actions_zap =~ s/_COUNT_/$zapcount/g;
			print <<"_HTML_";
{val:"-3", name:"$actions_zap"},
_HTML_
		}

		# しおり
		my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		print <<"_HTML_";
{val:"-2", name:"$actions_bookmark"},
_HTML_

		# 促し
		if ((defined($curpl->{'actaddpt'})) && ($curpl->{'actaddpt'} > 0)) {
			my $restaddpt = $sow->{'textrs'}->{'ACTIONS_RESTADDPT'};
			my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
			$restaddpt =~ s/_POINT_/$curpl->{'actaddpt'}/g;
			$actions_addpt =~ s/_REST_/$restaddpt/g;
			print <<"_HTML_";
{val:"-1", name:"$actions_addpt"},
_HTML_
		}
	} else {
		# しおり
		my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		print <<"_HTML_";
{val:"-2", name:"$actions_bookmark"},
_HTML_
	}

	print <<"_HTML_";
	],
};
gon.form.texts.push(text_form);
_HTML_
	return;
}

#----------------------------------------
# 能力者欄HTML出力
#----------------------------------------
sub OutHTMLRolePC {
	my ($sow, $vil, $role) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $curpl = $sow->{'curpl'};

	my $longname    = $curpl->getlongchrname();
	my $win_visible = $curpl->win_visible();
		print <<"_HTML_";
gon.form.win = "$win_visible";
_HTML_

	# キャラ画像
	my $img = $curpl->{'csid'}."/".$curpl->{'cid'};

	if (($curpl->{'role'} == -1) || ($curpl->{'role'} == $sow->{'ROLEID_MOB'})) {
		# 能力希望表示
		my $mes = $curpl->rolemessage( $role->{'explain'} );
		&SWHtml::ConvertJSON(\$mes);
		print <<"_HTML_";
gon.form.secrets.push("$mes");
_HTML_
	} elsif (($vil->isepilogue() == 0) && ($curpl->{'live'} ne 'live')) {
		# 能力欄表示（墓下）
		my $mes = $role->{'explain'};
		&SWHtml::ConvertJSON(\$mes);
		print <<"_HTML_";
gon.form.secrets.push("$mes");
_HTML_
	} else {
		# 能力欄表示
		my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

		# 能力者説明の表示
		my $rolemes = $curpl->rolemessage( $role->{'explain_role'}->[$role->{'role'}] );
		&SWHtml::ConvertJSON(\$rolemes);

		# アイテム説明の表示
		my $giftmes = $curpl->rolemessage( $role->{'explain_gift'}->[$role->{'gift'}] );
		&SWHtml::ConvertJSON(\$giftmes);

		# 能力結果履歴
		my $history = $curpl->{'history'};
		&SWHtml::ConvertJSON(\$history);

		my $winmes = '';
		if ($vil->isepilogue() == 0){
			$winmes = $curpl->winmessage();
			&SWHtml::ConvertJSON(\$winmes);
		}

		# 囁き/共鳴/念話
		my $sayswitch = "";
		$sayswitch = $curpl->rolesayswitch($vil);
		if ( '' ne $sayswitch ){

			my $label   = $sow->{'textrs'}->{'CAPTION_ROLESAY'}->[$curpl->{'role'}];
			my $countid = $sow->{'ROLESAYCOUNTID'}->[$curpl->{'role'}];
			&OutHTMLSayTextAreaExtPC($sow, $vil, $sayswitch, $label, $countid );
		} elsif ($curpl->isEnableRole($vil->{'turn'})) {
			print <<"_HTML_";
text_form = {
	cmd: "write",
	jst: "silent",
	votes: [],
	mestype: "TSAY",
	longname: "$longname",
	csid_cid: "$img",
};
gon.form.texts.push(text_form);
_HTML_
		}
		&OutHTMLVotePC($sow, $vil, 'role');

		# 囁き/共鳴/念話
		$sayswitch = $curpl->giftsayswitch($vil);
		if ( '' ne $sayswitch ){
			my $label   = $sow->{'textrs'}->{'CAPTION_GIFTSAY'}->[$curpl->{'gift'}];
			my $countid = $sow->{'GIFTSAYCOUNTID'}->[$curpl->{'gift'}];
			&OutHTMLSayTextAreaExtPC($sow, $vil, $sayswitch, $label, $countid );
		} elsif ($curpl->isEnableGift($vil->{'turn'})) {
			print <<"_HTML_";
text_form = {
	cmd: "write",
	jst: "silent",
	votes: [],
	mestype: "TSAY",
	longname: "$longname",
	csid_cid: "$img",
};
gon.form.texts.push(text_form);
_HTML_
		}
		&OutHTMLVotePC($sow, $vil, 'gift');

		print <<"_HTML_";
gon.form.secrets.push("$rolemes");
gon.form.secrets.push("$giftmes");
gon.form.secrets.push("$winmes");
gon.form.secrets.push("$history");
_HTML_

		# 運命の絆
		my $lovestate = $curpl->getvisiblelovestate();
		my $love = '';
		$love = 'つまり、あなたは恋をしているのです。' if ($lovestate eq 'love');
		$love = 'つまり、あなたは殺意満々なのです。'   if ($lovestate eq 'hate');
		my $targets = $curpl->getvisiblebonds($vil);
		foreach $target (@$targets) {
			my $targetname   = $target->getchrname();
			my $resultbonds  = $sow->{'textrs'}->{'STATE_BONDS'};
			$resultbonds =~ s/_TARGET_/$targetname/g;
			print "gon.form.secrets.push(\"$resultbonds\");\n";
		}
		if ( '' ne $love ) {
			print "gon.form.secrets.push(\"$love\");\n";
		}
		# 誘い込まれた
		if ($curpl->{'sheep'} ne '') {
			my $sheeps = $vil->getsheeppllist();
			print "gon.form.secrets.push(\"";
			if ( 1 < scalar(@$sheeps) ) {
				foreach (@$sheeps) {
					next if ($curpl eq $_);
					my $targetname = $_->getchrname();
					print "<b>$targetname</b>と";
				}
			}
			print "$sow->{'textrs'}->{'STATE_SHEEPS'}";
			print "\");\n";
		}

		# 状態
		if ( $curpl->hasDisableAbility() && $curpl->issensible() ){
			my $textAbility = $curpl->textDisableAbility();
			&SWHtml::ConvertJSON(\$textAbility);
			print "gon.form.secrets.push(\"$textAbility\");\n";
		}
	}

	return;
}


#----------------------------------------
# 能力者の発言欄
#----------------------------------------
sub  OutHTMLSayTextAreaExtPC {
	my ($sow, $vil, $sayswitch, $label, $countid ) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $curpl = $sow->{'curpl'};

	# 人形遣いのための特別コード。本当は、file_player#GetMesTypeを使うべき。
	$curpl = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} ) if ('muppet' eq $sayswitch);

	# キャラ画像
	my $img = $curpl->{'csid'}."/".$curpl->{'cid'};

	my $longname = $curpl->getlongchrname();

	# 表情選択欄
	# &OutHTMLExpressionFormPC($sow, $vil);

	# 発言欄textarea要素の出力
	my ($saycnt,$cost,$unit, $max_unit,$max_line,$max_size) = $vil->getsayptcosts();
	my $title = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	$title =~ s/_BUTTON_/$label/g;
	my $count = " あと$curpl->{$countid}$unit" if ($cost ne 'none');

	print <<"_HTML_";
text_form = {
	cmd: "write",
	jst: "secret",
	text: "",
	title: "$label",
	count: "$count",
	caption: "",
	max: {
		unit: "$max_unit",
		line: $max_line,
		size: $max_size,
	},
	votes: [],
	style: "",
	target: "-1",
	switch: "$sayswitch",
	mestype: SOW.switch["$sayswitch"].mestype,
	csid_cid: "$img",
	longname: "$longname",
};
gon.form.texts.push(text_form);
_HTML_
}

#----------------------------------------
# 村建て人欄HTML出力
#----------------------------------------
sub OutHTMLVilMakerPC {
	my ($sow, $vil, $writemode) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};
	my $csidlist = $sow->{'csidlist'};
	my @keys = keys(%$csidlist);

	# 名前とID
	my $longname = $sow->{'charsets'}->getchrname($keys[0], $writemode);

	# 発言欄textarea要素の出力
	my ($saycnt,$cost,$unit, $max_unit,$max_line,$max_size) = $vil->getsayptcosts();
	my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_PC'};
	my $title = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	$title =~ s/_BUTTON_/$caption_say/g;

	print <<"_HTML_";
text_form = {
	cmd: "wrmemo",
	jst: "memo",
	text: "",
	style: "",
	title: "メモを貼\る",
	count: "",
	caption: "",
	max: {
		unit: "$max_unit",
		line: $max_line,
		size: $max_size,
	},
	votes: [],
	switch: "$writemode",
	mestype: "SAY",
	longname: "$longname",
	csid_cid: "$keys[0]/$writemode",
}
gon.form.texts.push(text_form);

text_form = {
	cmd: "write",
	jst: "secret",
	text: "",
	style: "",
	title: "$title",
	count: "",
	caption: "",
	max: {
		unit: "$max_unit",
		line: $max_line,
		size: $max_size,
	},
	votes: [],
	target: "-1",
	switch: "$writemode",
	mestype: "SAY",
	longname: "$longname",
	csid_cid: "$keys[0]/$writemode",
};
gon.form.texts.push(text_form);
_HTML_
	return;
}

#----------------------------------------
# 「時間を進める」ボタンHTML出力
#----------------------------------------
sub OutHTMLCommitFormPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	my $disabled = '';
	my $nosay = '';
	if (($sow->{'curpl'}->{'saidcount'} == 0)&&($vil->{'event'} != $sow->{'EVENTID_NIGHTMARE'})) {
		$disabled = " $sow->{'html'}->{'disabled'}";
		$nosay = "<br><br>最低一発言して確定しないと、時間を進める事ができません。";
	}

	print <<"_HTML_";
command = {
	cmd: "commit",
	jst: "commit",
	title: "変更",
	caption: "全員が「時間を進める」を選ぶと前倒しで更新されます。$nosay",
	commit: "$sow->{'curpl'}->{'commit'}",
	commits: [
{val:"0", name:"時間を進めない"},
{val:"1", name:"時間を進める"},
	],
}
gon.form.commands[command.cmd] = command;
_HTML_
	return;
}


#----------------------------------------
# 投票／能力対象プルダウンリスト出力
#----------------------------------------
sub OutHTMLVotePC {
	my ($sow, $vil, $cmd) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};
	my $curpl = $sow->{'curpl'};
	return if ($cmd eq 'vote'    && ! $curpl->isEnableVote($vil->{'turn'}) );
	return if ($cmd eq 'entrust' && ! $curpl->isEnableVote($vil->{'turn'}) );
	return if ($cmd eq 'role'    && ! $curpl->isEnableRole($vil->{'turn'}) );
	return if ($cmd eq 'gift'    && ! $curpl->isEnableGift($vil->{'turn'}) );

	# 属性値の取得
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	# 投票／委任選択欄
	my $votelabel = $curpl->getlabel($cmd);
	my $target_label = $curpl->gettargetlabel($cmd,$vil->{'turn'});

    my $jst = "";
	if ($target_label ne ''){
		$jst = 'vote2';
	} else {
		$jst = 'vote1';
	}

    my $target1 = $curpl->{$cmd.'1'};
    my $target2 = $curpl->{$cmd.'2'};

	print <<"_HTML_";
vote = {
	cmd: "$cmd",
	jst: "$jst",
	title: "$votelabel",
	target1: "$target1",
	target2: "$target2",
	targets: [
_HTML_
	if (($cmd eq 'vote')&&( $curpl->{$cmd.'1'} == $curpl->{'pno'})){
		my $pno      = $curpl->{'pno'};
		my $chrname  = $curpl->getlongchrname();
		print "{val:\"$pno\", name:\"自分へ投票\"},\n";
	}

	# 対象の表示
	$targetlist = $curpl->gettargetlistwithrandom($cmd);
	foreach (@$targetlist) {
		print "{val:\"$_->{'pno'}\", name:\"$_->{'chrname'}\"},\n";
	}
	print <<"_HTML_";
	],
};
text_form.votes.push(vote);
_HTML_
	return;
}

#----------------------------------------
# キック/編集/延長/村開始/更新ボタンHTML出力
#----------------------------------------
sub OutHTMLUpdateSessionButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my %button;
	if ($vil->{'turn'} == 0) {
		%button = (
			label => '村を始めちゃおう',
			cmd   => 'start',
		);
	} else {
		%button = (
			label => '更新を延長しよう！（あと'.$vil->{'extend'}.'回）',
			cmd   => 'extend',
		);
	}

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	print <<"_HTML_";
command = {
	cmd: "maker",
	jst: "target",
	title: "この人に村を任せる！",
	targets: [
_HTML_
		# 村建て権移譲
		$targetlist = $vil->getallpllist();
		foreach (@$targetlist) {
			next if (($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'}));
			my $chrname = $_->getlongchrname();
			my $pno     = $_->{'pno'};
			print "{val:\"$pno\", name:\"$chrname\"},\n";
		}
		print <<"_HTML_";
	],
};
gon.form.commands[command.cmd] = command;
_HTML_

	my $disabled = '';
	if ($button{'cmd'} eq 'start') {
		my $upddatetime = sprintf('%02d:%02d',$vil->{'updhour'},$vil->{'updminite'});

		print <<"_HTML_";
command = {
	cmd: "kick",
	jst: "target",
	title: "退去いただこう、かな…",
	targets: [
_HTML_
		# キック機能
		$targetlist = $vil->getallpllist();
		foreach (@$targetlist) {
			next if (($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'}));
			my $chrname = $_->getlongchrname();
			my $pno     = $_->{'pno'};
			print "{val:\"$pno\", name:\"$chrname\"},\n";
		}
		print <<"_HTML_";
	],
};
gon.form.commands[command.cmd] = command;
command = {
	cmd: "editvilform",
	jst: "button",
	title: "村を編集しよう！",
};
gon.form.commands[command.cmd] = command;
command = {
	cmd: "muster",
	jst: "button",
	title: "点呼しよう！($upddatetimeまで)",
};
gon.form.commands[command.cmd] = command;
_HTML_
	} else {
		if ($vil->isepilogue()) {
			print <<"_HTML_";
command = {
	cmd: "editvilform",
	jst: "button",
	title: "村を編集しよう！",
};
gon.form.commands[command.cmd] = command;
_HTML_
		}

		if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}) {
			print <<"_HTML_";
command = {
	cmd: "update",
	jst: "button",
	title: "更新しちゃおう！",
};
gon.form.commands[command.cmd] = command;
_HTML_
		} else {
			# 村立て人の延長機能利用は制限あり
			$disabled = ' disabled' if ($vil->{'extend'} == 0);
		}
	}

	print <<"_HTML_";
command = {
	cmd: "$button{'cmd'}",
	jst: "button",
	title: "$button{'label'}",
};
gon.form.commands[command.cmd] = command;
_HTML_

	return;
}

#----------------------------------------
# 廃村ボタンHTML出力
#----------------------------------------
sub OutHTMLScrapVilButtonPC {
	print <<"_HTML_";
command = {
	cmd: "scrapvil",
	jst: "button",
	title: "廃村する",
}
gon.form.commands[command.cmd] = command;
_HTML_
	return;
}



#----------------------------------------
# 「村を出る」HTML出力
#----------------------------------------
sub OutHTMLExitButtonPC {
	print <<"_HTML_";
command = {
	cmd: "exit",
	jst: "button",
	title: "村を出る",
};
gon.form.commands[command.cmd] = command;
_HTML_
	return;
}



1;
