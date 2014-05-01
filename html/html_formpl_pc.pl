package SWHtmlPlayerFormPC;

#----------------------------------------
# �v���C���[�����^�s����HTML�o��
#----------------------------------------
sub OutHTMLPlayerFormPC {
	my ($sow, $vil, $memofile) = @_;
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};

	# ������HTML�o��
	&OutHTMLSayPC($sow, $vil, $memofile);

	# �R�~�b�g�{�^��
	&OutHTMLCommitFormPC($sow, $vil) if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0) && ($sow->{'curpl'}->iscommitter()));

	# �\�͎җ�HTML�o��
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

	# �����Đl�t�H�[���^�Ǘ��l�t�H�[���\��
	if ($sow->{'user'}->logined() > 0) {
		&OutHTMLUpdateSessionButtonPC($sow, $vil);
		if ($vil->{'makeruid'} eq $sow->{'uid'}) {
			&OutHTMLVilMakerPC($sow, $vil, 'maker');
		}
		if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}) {
			&OutHTMLVilMakerPC($sow, $vil, 'admin');
			&OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
		}
	}

	print "\n\n";

	return;
}

#----------------------------------------
# ������HTML�o��
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

	# �L�����摜
	my $img = $curpl->{'csid'}."/".$curpl->{'cid'};

    my $mestype = "SAY";
    $mestype = "GSAY" if('live' ne $curpl->{'live'});
    $mestype = "VSAY" if('mob'  eq $curpl->{'live'});

    # ����/�Ƃ茾/�����b
	my ($saycnt,$cost,$unit,$max_line,$max_size) = $vil->getsayptcosts();
	my $tsaycnttext = "����".$curpl->{'tsay'}.$unit                                if ($cost ne 'none');
	my $ssaycnttext = "����".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if ($cost ne 'none');
	my $asaycnttext = $ssaycnttext;

	# ������textarea�v�f�̏o��
	my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_PC'};
	my $title = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	$title =~ s/_BUTTON_/$caption_say/g;

    # �����֘A
	my ($saycnt,$costmemo,$unitmemo,$max_line_memo,$max_size_memo) = $vil->getmemoptcosts();
	my $memocost = '�������ɓ\��t�����';
	my $memocnttext;
	$memocost    = '�g���ƃA�N�V�����񐔂����' if( $cost eq 'count' );
	$memocost    = '�g���Ɣ�����20pt���'       if( $cost eq 'point' );
	$memocnttext = "����".$curpl->{'say_act'}.$unitmemo                         if( $costmemo eq 'count' );
	$memocnttext = "����".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if( $costmemo eq 'point' );

	print <<"_HTML_";
text_form = {
	cmd: "wrmemo",
	jst: "memo",
	text: "",
	votes: [],
	style: "",
	title: "������\\��",
	count: "$memocnttext",
	caption: "��������$memocost�܂��B",
	max: {
		unit: "$costmemo",
		line: $max_line_memo,
		size: $max_size_memo
	},
	mestype: "$mestype",
	csid_cid: "$img",
	longname: "$longchrname"
}
gon.form.texts.push(text_form);

text_form = {
	cmd: "write",
	jst: "open",
	text: "",
	votes: [],
	style: "",
	title: "$title",
	mestype: "SAY",
	caption: "",
	max: {
		unit: "$cost",
		line: $max_line,
		size: $max_size
	},
	csid_cid: "$img",
	longname: "$longchrname",
	target: "-1"
};
(function(){
var a = [];
var b = [];
a.push({val:"-1",          mestype:"$mestype", name:"$ssaycnttext ($sow->{'textrs'}->{'CAPTION_SAY_PC'})"});
a.push({val:"$curpl->{'pno'}", mestype:"TSAY", name:"$tsaycnttext ($sow->{'textrs'}->{'CAPTION_TSAY_PC'})"});
_HTML_

	if ((1 == $vil->{'aiming'})
      ||($sow->{'uid'} eq $cfg->{'USERID_ADMIN'})
      ||($sow->{'uid'} eq $cfg->{'USERID_NPC'})){
		# �����b�̑Ώێ�
		my $pllist = $vil->getallpllist();
		foreach (@$pllist) {
			next if (0 == $curpl->isAim($_));

			my $targetname = $_->getlongchrname();
			print "a.push({val:\"$_->{'pno'}\", mestype:\"AIM\", name:\"$asaycnttext $targetname�Ɠ����b\"});"
		}
	}

	# ��]����\�͂̕\��
	if ( $vil->{'turn'} < 1){
		if ($isplok) {
			print "b.push({val:\"-1\", name:\"$sow->{'textrs'}->{'RANDOMROLE'}\"});\n";
			my $rolename = $sow->{'textrs'}->{'ROLENAME'};
			my ( $rolematrix, $giftmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'});

			my $i;
			foreach ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
				my $output = $rolematrix->[$i];
				$output = 1 if ($i == 0); # ���܂����͕K���\��
				print "b.push({val:\"$i\", name:\"$rolename->[$i]\"});\n" if ($output > 0);
			}
		}
		if ($ismobok){
			my $mob = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'};
			print "b.push({val:\"$sow->{'ROLEID_MOB'}\", name:\"$mob�Ō���\"});\n";
		}
	}

	print <<"_HTML_";
text_form.targets = a;
text_form.roles   = b;
})();
gon.form.texts.push(text_form);
_HTML_

	# ���[��ύX�v���_�E��
	if( $curpl->setvote_to($sow,$vil) != 0 ){
		&OutHTMLVotePC($sow, $vil, 'vote');
	}
	if( $curpl->setentrust($sow,$vil) != 0 ){
		&OutHTMLVotePC($sow, $vil, 'entrust');
	}

	# �\��I��
	#&OutHTMLExpressionFormPC($sow, $vil);

	# �A�N�V����
	&OutHTMLActionFormPC($sow, $vil);
	return;
}

#----------------------------------------
# �A�N�V�����t�H�[���̏o��
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

    my $mestype = "SAY";
    $mestype = "GSAY" if('live' ne $curpl->{'live'});
    $mestype = "VSAY" if('mob'  eq $curpl->{'live'});

	# �A�N�V�������͗��ƃA�N�V�����{�^��
	my ($saycnt,$cost,$unit,$max_line,$max_size) = $vil->getactptcosts();
	my $actcnttext = "����".$curpl->{'say_act'}.$unit  if ($cost ne 'none');

	print <<"_HTML_";
text_form = {
	cmd: "action",
	jst: "action",
	action: "-99",
	target: "-1",
	text: "",
	title: "�A�N�V����",
	count: "$actcnttext",
	max: {
		unit: "$cost",
		line: $max_line,
		size: $max_size
	},
	mestype: "$mestype",
	shortname: "$chrname"
};
(function(){
var a = [];
var b = [];
a.push({val:"-1", name:"�i�I�����Ȃ��j"});
b.push({val:"-99", name:"�i�����R�ɓ��́j"});
_HTML_
	# �A�N�V�����̑Ώێ�
	foreach (@$pllist) {
		next if (0 == $curpl->isAction($_));

		my $targetshortname = $_->getshortchrname();
		my $targetlongname  = $_->getlongchrname();
		print <<"_HTML_";
a.push({val:"$_->{'pno'}", name:"$targetshortname", longname:"$targetlongname"});
_HTML_
	}
	# �g�ݍ��ݍς݃A�N�V����
	my $actions = $sow->{'textrs'}->{'ACTIONS'};
	my $i;
	for ($i = 0; $i < @$actions; $i++) {
		print <<"_HTML_";
b.push({val:"$i", name:"$actions->[$i]"});
_HTML_
	}
	if ($curpl->{'live'} eq 'live'){
		# ���i�ƍ~�i
		my $actions_up = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_UP'};
		if( $actions_up ){
			print <<"_HTML_";
b.push({val:"-4", name:"$actions_up"});
_HTML_
		}
		my $actions_down = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_DOWN'};
		if( $actions_down ){
			print <<"_HTML_";
b.push({val:"-5", name:"$actions_down"});
_HTML_
		}

		# zap!zap!zap!
		# ���Y�����邤���̓N���[���i���o�[�͑����Ȃ��B
		my $actions_zap = $sow->{'textrs'}->{'ACTIONS_ZAP'}  if ( $vil->{'turn'} < 2 || $vil->{'epilogue'} <= $vil->{'turn'});
		if( $actions_zap ){
			my $zapcount = $sow->{'textrs'}->{'ACTIONS_ZAPCOUNT'};
			$zapcount =~ s/_POINT_/$curpl->{'zapcount'}/g;
			$actions_zap =~ s/_COUNT_/$zapcount/g;
			print <<"_HTML_";
b.push({val:"-3", name:"$actions_zap"});
_HTML_
		}

		# ������
		my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		print <<"_HTML_";
b.push({val:"-2", name:"$actions_bookmark"});
_HTML_

		# ����
		if ((defined($curpl->{'actaddpt'})) && ($curpl->{'actaddpt'} > 0)) {
			my $restaddpt = $sow->{'textrs'}->{'ACTIONS_RESTADDPT'};
			my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
			$restaddpt =~ s/_POINT_/$curpl->{'actaddpt'}/g;
			$actions_addpt =~ s/_REST_/$restaddpt/g;
			print <<"_HTML_";
b.push({val:"-1", name:"$actions_addpt"});
_HTML_
		}
	} else {
		# ������
		my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		print <<"_HTML_";
b.push({val:"-2", name:"$actions_bookmark"});
_HTML_
	}
	print <<"_HTML_";
text_form.targets = a;
text_form.actions = b;
})();
gon.form.texts.push(text_form);
_HTML_
	return;
}

#----------------------------------------
# �\�͎җ�HTML�o��
#----------------------------------------
sub OutHTMLRolePC {
	my ($sow, $vil, $role) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $curpl = $sow->{'curpl'};

	my $active = 0;
	my $rolemes = '';
	my $giftmes = '';
	my $winmes = '';

	my $longname    = $curpl->getlongchrname();
	my $win_visible = $curpl->win_visible();
		print <<"_HTML_";
gon.form.win = "$win_visible";
_HTML_

	# �L�����摜
	my $img = $curpl->{'csid'}."/".$curpl->{'cid'};

	if (($curpl->{'role'} == -1) || ($curpl->{'role'} == $sow->{'ROLEID_MOB'})) {
		$active = 1 if ($vil->{'mob'} eq 'gamemaster');

		# �\�͊�]�\��
		my $mes = $curpl->rolemessage( $role->{'explain'} );
		&SWHtml::ConvertJSON(\$mes);
		print <<"_HTML_";
gon.form.secrets.push("$mes");
_HTML_
	} elsif ($curpl->ispowerlessgrave($vil) ) {
		# �\�͗��\���i�扺�j
		my $mes = $role->{'explain'};
		&SWHtml::ConvertJSON(\$mes);
		print <<"_HTML_";
gon.form.secrets.push("$mes");
_HTML_
	} else {
		$active = 1;

		# �\�͗��\��
		my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

		# �\�͎Ґ����̕\��
		$rolemes = $curpl->rolemessage( $role->{'explain_role'}->[$role->{'role'}] );
		&SWHtml::ConvertJSON(\$rolemes);

		# �A�C�e�������̕\��
		$giftmes = $curpl->rolemessage( $role->{'explain_gift'}->[$role->{'gift'}] );
		&SWHtml::ConvertJSON(\$giftmes);

		# �����������
		if ($vil->isepilogue() == 0){
			$winmes = $curpl->winmessage();
			&SWHtml::ConvertJSON(\$winmes);
		}
	}

	if ($active){
		# �\�͌��ʗ���
		my $history = $curpl->{'history'};
		&SWHtml::ConvertJSON(\$history);

		# ����/����/�O�b
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
	csid_cid: "$img"
};
gon.form.texts.push(text_form);
_HTML_
		}
		&OutHTMLVotePC($sow, $vil, 'role');

		# ����/����/�O�b
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
	csid_cid: "$img"
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

		# �^�����J
		my $lovestate = $curpl->getvisiblelovestate();
		my $love = '';
		$love = '�܂�A���Ȃ��͗������Ă���̂ł��B' if ($lovestate eq 'love');
		$love = '�܂�A���Ȃ��͎E�Ӗ��X�Ȃ̂ł��B'   if ($lovestate eq 'hate');
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
		# �U�����܂ꂽ
		if ($curpl->{'sheep'} ne '') {
			my $sheeps = $vil->getsheeppllist();
			print "gon.form.secrets.push(\"";
			if ( 1 < scalar(@$sheeps) ) {
				foreach (@$sheeps) {
					next if ($curpl eq $_);
					my $targetname = $_->getchrname();
					print "<b>$targetname</b>��";
				}
			}
			print "$sow->{'textrs'}->{'STATE_SHEEPS'}";
			print "\");\n";
		}

		# ���
		if ( $curpl->hasDisableAbility() && $curpl->issensible() ){
			my $textAbility = $curpl->textDisableAbility();
			&SWHtml::ConvertJSON(\$textAbility);
			print "gon.form.secrets.push(\"$textAbility\");\n";
		}
	}

	return;
}


#----------------------------------------
# �\�͎҂̔�����
#----------------------------------------
sub  OutHTMLSayTextAreaExtPC {
	my ($sow, $vil, $sayswitch, $label, $countid ) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $curpl = $sow->{'curpl'};

	# �l�`�����̂��߂̓��ʃR�[�h�B�{���́Afile_player#GetMesType���g���ׂ��B
	$curpl = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} ) if ('muppet' eq $sayswitch);

	# �L�����摜
	my $img = $curpl->{'csid'}."/".$curpl->{'cid'};

	my $longname = $curpl->getlongchrname();

	# �\��I��
	# &OutHTMLExpressionFormPC($sow, $vil);

	# ������textarea�v�f�̏o��
	my ($saycnt,$cost,$unit,$max_line,$max_size) = $vil->getsayptcosts();
	my $title = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	$title =~ s/_BUTTON_/$label/g;
	my $count = " ����$curpl->{$countid}$unit" if ($cost ne 'none');

    # �����֘A
	my ($saycnt,$costmemo,$unitmemo,$max_line_memo,$max_size_memo) = $vil->getmemoptcosts();

	print <<"_HTML_";
text_form = {
	cmd: "wrmemo",
	jst: "memo",
	text: "",
	style: "",
	title: "������\\��",
	count: "",
	caption: "",
	max: {
		unit: "$costmemo",
		line: $max_line_memo,
		size: $max_size_memo
	},
	votes: [],
	switch: "$sayswitch",
	mestype: giji.form.mestype("$sayswitch"),
	longname: "$longname",
	csid_cid: "$img",
};
gon.form.texts.push(text_form);

text_form = {
	cmd: "write",
	jst: "secret",
	text: "",
	title: "$label",
	count: "$count",
	caption: "",
	max: {
		unit: "$cost",
		line: $max_line,
		size: $max_size
	},
	votes: [],
	style: "",
	target: "-1",
	switch: "$sayswitch",
	mestype: giji.form.mestype("$sayswitch"),
	csid_cid: "$img",
	longname: "$longname"
};
gon.form.texts.push(text_form);
_HTML_
}

#----------------------------------------
# �����Đl��HTML�o��
#----------------------------------------
sub OutHTMLVilMakerPC {
	my ($sow, $vil, $writemode) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};
	my $csidlist = $sow->{'csidlist'};
	my @keys = keys(%$csidlist);
	my $mestype = uc $writemode;

	# ���O��ID
	my $longname = $sow->{'charsets'}->getchrname($keys[0], $writemode);

	# ������textarea�v�f�̏o��
	my ($saycnt,$cost,$unit,$max_line,$max_size) = $vil->getsayptcosts();
	my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_PC'};
	my $title = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	$title =~ s/_BUTTON_/$caption_say/g;

    # �����֘A
	my ($saycnt,$costmemo,$unitmemo,$max_line_memo,$max_size_memo) = $vil->getmemoptcosts();

	print <<"_HTML_";
text_form = {
	cmd: "wrmemo",
	jst: "memo",
	text: "",
	style: "",
	title: "������\\��",
	count: "",
	caption: "",
	max: {
		unit: "$costmemo",
		line: $max_line_memo,
		size: $max_size_memo
	},
	votes: [],
	switch: "$writemode",
	mestype: "$mestype",
	longname: "$longname",
	csid_cid: "$keys[0]/$writemode"
};
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
		unit: "$cost",
		line: $max_line,
		size: $max_size
	},
	votes: [],
	target: "-1",
	switch: "$writemode",
	mestype: "$mestype",
	longname: "$longname",
	csid_cid: "$keys[0]/$writemode"
};
gon.form.texts.push(text_form);
_HTML_
	return;
}

#----------------------------------------
# �u���Ԃ�i�߂�v�{�^��HTML�o��
#----------------------------------------
sub OutHTMLCommitFormPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	my $disabled = 0;
	my $nosay = '';
	if (($sow->{'curpl'}->{'saidcount'} == 0)&&($vil->{'event'} != $sow->{'EVENTID_NIGHTMARE'})) {
		$disabled = 1;
		$nosay = "<br>�Œ�ꔭ�����Ċm�肵�Ȃ��ƁA���Ԃ�i�߂鎖���ł��܂���B";
	}

	print <<"_HTML_";
command = {
	cmd: "commit",
	jst: "commit",
	disabled: (1 == $disabled),
	title: "�ύX",
	caption: "�S�����u���Ԃ�i�߂�v��I�ԂƑO�|���ōX�V����܂��B$nosay",
	commit: "$sow->{'curpl'}->{'commit'}",
	commits: [
{val:"0", name:"���Ԃ�i�߂Ȃ�"},
{val:"1", name:"���Ԃ�i�߂�"}
	]
};
gon.form.commands[command.cmd] = command;
_HTML_
	return;
}


#----------------------------------------
# ���[�^�\�͑Ώۃv���_�E�����X�g�o��
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

	# �����l�̎擾
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	# ���[�^�ϔC�I��
	my $votelabel = $curpl->getlabel($cmd);
	my $votechoice = $curpl->getchoice($cmd);
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
	title: "$votechoice $votelabel",
	target1: "$target1",
	target2: "$target2"
};
(function(){
var a = [];
_HTML_
	if (($cmd eq 'vote')&&( $curpl->{$cmd.'1'} == $curpl->{'pno'})){
		my $pno      = $curpl->{'pno'};
		my $chrname  = $curpl->getlongchrname();
		print "a.push({val:\"$pno\", name:\"�����֓��[\"});\n";
	}

	# �Ώۂ̕\��
	$targetlist = $curpl->gettargetlistwithrandom($cmd);
	foreach (@$targetlist) {
		print "a.push({val:\"$_->{'pno'}\", name:\"$_->{'chrname'}\"});\n";
	}
	print <<"_HTML_";
vote.targets = a;
})();
text_form.votes.push(vote);
_HTML_
	return;
}

#----------------------------------------
# ����/�L�b�N/�ҏW/����/���J�n/�X�V�{�^��HTML�o��
#----------------------------------------
sub OutHTMLUpdateSessionButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $cursor = $sow->{'curpl'};

	my $maker = ($vil->{'makeruid'} eq $sow->{'uid'});
	my $admin = ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'});
	my $gamemaster = ($vil->{'mob'} eq 'gamemaster')&&($cursor->{'live'} eq 'mob');

	my %button;
	if ($vil->{'turn'} == 0) {
		%button = (
			label => '�����n�߂��Ⴈ��',
			cmd   => 'start',
		);
	} else {
		%button = (
			label => '�X�V���������悤�I�i����'.$vil->{'extend'}.'��j',
			cmd   => 'extend',
		);
	}

	print <<"_HTML_";
var command;
var a = [];
gon.form.command_targets = a;
_HTML_
	$targetlist = $vil->getallpllist();
	foreach (@$targetlist) {
		next if (($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'}));
		my $chrname = $_->getlongchrname();
		my $pno     = $_->{'pno'};
		print "a.push({val:\"$pno\", name:\"$chrname\"});\n";
	}


	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	if ($gamemaster || $admin){
		print <<"_HTML_";
command = {
	cmd: "gamemaster",
	jst: "target",
	live: "droop",
	targets: a,
	title: "�Q���҂Ƃ��Ď��ʁB"
};
gon.form.commands.gm_droop = command;
command = {
	cmd: "gamemaster",
	jst: "target",
	live: "live",
	rolestate: 'HEAL',
	calcstate: 'enable',
	targets: a,
	title: "�Q���҂Ƃ��Đ�����B"
};
gon.form.commands.gm_live = command;
command = {
	cmd: "gamemaster",
	jst: "target",
	rolestate: 'VOTE_TARGET',
	calcstate: 'disable',
	targets: a,
	title: "���[����ی삷��B"
};
gon.form.commands.gm_disable_vote = command;
command = {
	cmd: "gamemaster",
	jst: "target",
	rolestate: 'VOTE_TARGET',
	calcstate: 'enable',
	targets: a,
	title: "���[��F����B"
};
gon.form.commands.gm_enable_vote = command;
_HTML_
	}

	if ( $admin || $maker ) {
		print <<"_HTML_";
command = {
	cmd: "maker",
	jst: "target",
	targets: a,
	title: "���̐l�ɑ���C����I"
};
gon.form.commands[command.cmd] = command;
_HTML_
	}

	if (($vil->{'turn'} == 0)&&( $maker || $admin )) {
		my $upddatetime = sprintf('%02d:%02d',$vil->{'updhour'},$vil->{'updminite'});

		print <<"_HTML_";
command = {
	cmd: "kick",
	jst: "target",
	targets: a,
	title: "�ދ������������A���ȁc"
};
gon.form.commands[command.cmd] = command;
command = {
	cmd: "editvilform",
	jst: "button",
	title: "����ҏW���悤�I"
};
gon.form.commands[command.cmd] = command;
command = {
	cmd: "muster",
	jst: "button",
	title: "�_�Ă��悤�I($upddatetime�܂�)"
};
gon.form.commands[command.cmd] = command;
_HTML_
	}

	if ($vil->isepilogue()&&( $maker || $admin )) {
		print <<"_HTML_";
command = {
	cmd: "editvilform",
	jst: "button",
	title: "����ҏW���悤�I"
};
gon.form.commands[command.cmd] = command;
_HTML_
	}

	my $disabled = 0;
	if ($admin) {
		print <<"_HTML_";
command = {
	cmd: "update",
	jst: "button",
	title: "�X�V�����Ⴈ���I"
};
gon.form.commands[command.cmd] = command;
_HTML_
	} else {
		# �����Đl�̉����@�\���p�͐�������
		$disabled = 1 if ($vil->{'extend'} == 0);
	}

	if ($admin || $maker && (! $disabled)) {
		print <<"_HTML_";
command = {
	cmd: "$button{'cmd'}",
	jst: "button",
	title: "$button{'label'}"
};
gon.form.commands[command.cmd] = command;
_HTML_
	}

	return;
}

#----------------------------------------
# �p���{�^��HTML�o��
#----------------------------------------
sub OutHTMLScrapVilButtonPC {
	print <<"_HTML_";
command = {
	cmd: "scrapvil",
	jst: "button",
	title: "�p������"
};
gon.form.commands[command.cmd] = command;
_HTML_
	return;
}



#----------------------------------------
# �u�����o��vHTML�o��
#----------------------------------------
sub OutHTMLExitButtonPC {
	print <<"_HTML_";
command = {
	cmd: "exit",
	jst: "button",
	title: "�����o��"
};
gon.form.commands[command.cmd] = command;
_HTML_
	return;
}



1;
