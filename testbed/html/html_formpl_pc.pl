package SWHtmlPlayerFormPC;

#----------------------------------------
# �v���C���[�����^�s����HTML�o��
#----------------------------------------
sub OutHTMLPlayerFormPC {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};

	# ������HTML�o��
	&OutHTMLSayPC($sow, $vil);

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
	&OutHTMLExitButtonPC($sow, $vil) if ($vil->{'turn'} == 0);

	# �����Đl�t�H�[���^�Ǘ��l�t�H�[���\��
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
# ������HTML�o��
#----------------------------------------
sub OutHTMLSayPC {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net   = $sow->{'html'}->{'net'};

	my $curpl   = $sow->{'curpl'};
	my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

	# �L�����摜�A�h���X�̎擾
	my $img = &SWHtmlPC::GetImgUrl($sow, $curpl, $charset->{'BODY'});

	my $rolename = $sow->{'curpl'}->getrolename();

	my $markbonds = '';
	$markbonds = " ��$sow->{'textrs'}->{'MARK_BONDS'}" if ($curpl->isvisiblebonds($vil));

	# �L�����摜
	print <<"_HTML_";
<table class="formpl_common">
<tr class="say">
<td class="img">
<img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net>

_HTML_

# ���O��ID
#	my $reqvals = &SWBase::GetRequestValues($sow);
#	$reqvals->{'prof'} = $sow->{'uid'};
#	my $link    = &SWBase::GetLinkValues($sow, $reqvals);
	my %link = (
		'user' => $sow  ->{'uid'},
		'css'  => $query->{'css'},
	);
	my $urluser = $cfg->{'URL_USER'}.'?'.&SWBase::GetLinkValues($sow, \%link);
	my $uidtext = $sow->{'uid'};
	$uidtext =~ s/ /&nbsp\;/g;
	$uidtext = '<a href="'.$urluser.'">'.$uidtext.'</a>';
	my $chrname = $curpl->getlongchrname();

	print <<"_HTML_";
<td class="field">
<div class="msg">
<div class="formpl_content">$chrname ($uidtext) $rolename $markbonds</div>

_HTML_
	if ( $vil->{'turn'} < 0){
		print <<"_HTML_";
<div class="formpl_content">
<label for="selectrole">��]����\\�́F</label>
<select id="selectrole" name="role">
<option value="-1">�����_��$sow->{'html'}->{'option'}
_HTML_
		require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
		# ��]����\�͂̕\��
		my $rolename = $sow->{'textrs'}->{'ROLENAME'};
		my ( $rolematrix, $giftmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'});

		my $i;
		foreach ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
			my $output = $rolematrix->[$i];
			$output = 1 if ($i == 0); # ���܂����͕K���\��
			if ($i == $curpl->{'selrole'}){
				print "        <option value=\"$i\" selected>$rolename->[$i] *$sow->{'html'}->{'option'}\n";
			}else{
				print "        <option value=\"$i\">$rolename->[$i]$sow->{'html'}->{'option'}\n" if ($output > 0);
			}
		}
		print <<"_HTML_";
</select>
</div>
_HTML_
	}

	# ���[��ύX�v���_�E��
	&OutHTMLVotePC($sow, $vil, 'vote');

	# �e�L�X�g�{�b�N�X�Ɣ����{�^������
	print <<"_HTML_";
<form class="form-inline" action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

	# �\��I��
	&OutHTMLExpressionFormPC($sow, $vil);

	print <<"_HTML_";
<div class="controls controls-row formpl_content">
_HTML_

	# ������textarea�v�f�̏o��
	my %htmlsay;
	$htmlsay{'saycnttext'}  = '';
	$htmlsay{'buttonlabel'} = $curpl->getsaybuttonlabel( $vil, $sow->{'textrs'}->{'CAPTION_SAY_PC'}, $sow->{'textrs'}->{'CAPTION_GSAY_PC'}, $sow->{'textrs'}->{'BUTTONLABEL_PC'} );
	$htmlsay{'disabled'} = 0;
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	my $draft = 0;
	$draft = 1 if (($sow->{'savedraft'} ne '') && (($sow->{'draftmestype'} == $sow->{'MESTYPE_SAY'}) || ($sow->{'draftmestype'} == $sow->{'MESTYPE_TSAY'})));
	if (($query->{'mes'} ne '') && (($query->{'cmdfrom'} eq 'write') || ($query->{'cmdfrom'} eq 'writepr'))) {
		my $mes = $query->{'mes'};
		$mes =~ s/<br( \/)?>/\n/ig;
#		&SWBase::ExtractChrRef(\$mes);
		$htmlsay{'text'} = $mes;
	} elsif ($draft > 0) {
		my $mes = $sow->{'savedraft'};
		$mes =~ s/<br( \/)?>/\n/ig;
		$htmlsay{'text'} = $mes;
	}

	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'writepr', \%htmlsay);

	# �Ƃ茾�`�F�b�N�{�b�N�X
	my ($saycnt,$cost,$unit) = $vil->getsayptcosts();
	my $draft_say  = ' selected' if ($sow->{'draftmestype'} == $sow->{'MESTYPE_SAY' });
	my $draft_tsay = ' selected' if ($sow->{'draftmestype'} == $sow->{'MESTYPE_TSAY'});
	my $tsaycnttext = "����".$curpl->{'tsay'}.$unit                                if ($cost ne 'none');
	my $ssaycnttext = "����".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if ($cost ne 'none');
	my $asaycnttext = $ssaycnttext;

	print <<"_HTML_";
<select name="target" class="input-medium">
<option value="-1"$draft_say>$ssaycnttext ($sow->{'textrs'}->{'CAPTION_SAY_PC'})$sow->{'html'}->{'option'}
<option value="$curpl->{'pno'}"$draft_tsay>$tsaycnttext ($sow->{'textrs'}->{'CAPTION_TSAY_PC'})$sow->{'html'}->{'option'}
_HTML_

	if ((1 == $cfg->{'ENABLED_AIMING'})
      ||($sow->{'uid'} eq $cfg->{'USERID_ADMIN'})
      ||($sow->{'uid'} eq $cfg->{'USERID_NPC'})){
		# �����b�̑Ώێ�
		my $pllist = $vil->getallpllist();
		foreach (@$pllist) {
			next if (0 == $curpl->isAim($_));

			my $targetname = $_->getshortchrname();
			print "<option value=\"$_->{'pno'}\">$asaycnttext $targetname�Ɠ����b$sow->{'html'}->{'option'}\n";
		}
	}
	print <<"_HTML_";
</select>
<select name="monospace" class="input-mini">
<option value="">(�ʏ�)
<option value="monospace">����
<option value="report">���o��
</select><br$net>
    </div>
    </form>

</div>
</table>
<div class="">
_HTML_

	# �A�N�V����
	&OutHTMLActionFormPC($sow, $vil);

	print <<"_HTML_";
</div>
<div class="clearboth">
  <hr class="invisible_hr"$net>
</div>

_HTML_

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
	print <<"_HTML_";
<div class="action">
{{form.action.result()}}
</div>
<div class="action">
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
<div class="formpl_action controls controls-row">
<select name="target" ng-model="form.action.target">
<option value="-1">�i�I�����Ȃ��j$sow->{'html'}->{'option'}
_HTML_

	# �A�N�V�����̑Ώێ�
	foreach (@$pllist) {
		next if (0 == $curpl->isAction($_));

		my $targetname = $_->getchrname();
		print "        <option value=\"$_->{'pno'}\">$targetname$sow->{'html'}->{'option'}\n";
	}

	print <<"_HTML_";
</select><br$net>

<fieldset class="action_type">
<legend>�A�N�V�������e</legend>
<select name="actionno" ng-model="form.action.no">
<option value="-99">�i�����R�ɓ��́j$sow->{'html'}->{'option'}
_HTML_
	# �g�ݍ��ݍς݃A�N�V����
	my $actions = $sow->{'textrs'}->{'ACTIONS'};
	my $i;
	for ($i = 0; $i < @$actions; $i++) {
		print "<option value=\"$i\">$actions->[$i]$sow->{'html'}->{'option'}\n";
	}

	if ($curpl->{'live'} eq 'live'){
		# ���i�ƍ~�i
		my $actions_up = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_UP'};
		if( $actions_up ){
			print "<option value=\"-4\">$actions_up$sow->{'html'}->{'option'}\n";
		}
		my $actions_down = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_DOWN'};
		if( $actions_down ){
			print "<option value=\"-5\">$actions_down$sow->{'html'}->{'option'}\n";
		}

		# zap!zap!zap!
		# ���Y�����邤���̓N���[���i���o�[�͑����Ȃ��B
		my $actions_zap = $sow->{'textrs'}->{'ACTIONS_ZAP'}  if ( $vil->{'turn'} < 2 || $vil->{'epilogue'} <= $vil->{'turn'});
		if( $actions_zap ){
			my $zapcount = $sow->{'textrs'}->{'ACTIONS_ZAPCOUNT'};
			$zapcount =~ s/_POINT_/$curpl->{'zapcount'}/g;
			$actions_zap =~ s/_COUNT_/$zapcount/g;
			print "<option value=\"-3\">$actions_zap$sow->{'html'}->{'option'}\n";
		}

		# ������
		my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		print "<option value=\"-2\">$actions_bookmark$sow->{'html'}->{'option'}\n";

		# ����
		if ((defined($curpl->{'actaddpt'})) && ($curpl->{'actaddpt'} > 0)) {
			my $restaddpt = $sow->{'textrs'}->{'ACTIONS_RESTADDPT'};
			my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
			$restaddpt =~ s/_POINT_/$curpl->{'actaddpt'}/g;
			$actions_addpt =~ s/_REST_/$restaddpt/g;
			print "<option value=\"-1\">$actions_addpt$sow->{'html'}->{'option'}\n";
		}
	} else {
		# ������
		my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		print "<option value=\"-2\">$actions_bookmark$sow->{'html'}->{'option'}\n";
	}

	# �A�N�V�������͗��ƃA�N�V�����{�^��
	my ($saycnt,$costaction,$unitaction) = $vil->getactptcosts();
	my $actcnttext = "����".$curpl->{'say_act'}.$unitaction  if ($costaction ne 'none');
	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($vil->{'emulated'} > 0);

	print <<"_HTML_";
</select><br$net>
<input type="hidden" name="cmd" ng-model="form.action.text" value="action"$net>$hidden
<input class="formpl_actiontext" type="text" name="actiontext" ng-model="form.action.text" value="" size="30"$net><br$net>
</fieldset>
<input type="submit" value="�A�N�V����"$disabled$net> $actcnttext
</div>
</form>
</div>
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

	# �\�͎җ��̃X�^�C���V�[�g�̃N���X��
	my $rolestyle = $curpl->win_visible();

	if (($curpl->{'role'} == -1) || ($curpl->{'role'} == $sow->{'ROLEID_MOB'})) {
		# �\�͊�]�\��
		my $mes = $curpl->rolemessage( $role->{'explain'} );
		&SWHtml::ConvertNET($sow, \$mes);
		print <<"_HTML_";
<div class="$rolestyle">
$mes
</div>

_HTML_
	} elsif (($vil->isepilogue() == 0) && ($curpl->{'live'} ne 'live')) {
		# �\�͗��\���i�扺�j
		my $mes = $role->{'explain'};
		&SWHtml::ConvertNET($sow, \$mes);
		print <<"_HTML_";
<div class="$rolestyle">
$mes
</div>

_HTML_
	} else {
		# �\�͗��\��
		my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

		my $winmes = '';
		if ($vil->isepilogue() == 0){
			$winmes = $curpl->winmessage();
		}

		# �L�����摜�A�h���X�̎擾
		my $img = &SWHtmlPC::GetImgUrl($sow, $curpl, $charset->{'BODY'});

		print <<"_HTML_";
<table class="$rolestyle">
<tr class="say">
<td>
_HTML_

		# �\�͑Ώې�ύX�v���_�E��
		&OutHTMLVotePC($sow, $vil, 'role');

		# ����/����/�O�b
		my $sayswitch = "";
		$sayswitch = $curpl->rolesayswitch($vil);
		if ( '' ne $sayswitch ){
			my $label   = $sow->{'textrs'}->{'CAPTION_ROLESAY'}->[$curpl->{'role'}];
			my $countid = $sow->{'ROLESAYCOUNTID'}->[$curpl->{'role'}];
			&OutHTMLSayTextAreaExtPC($sow,$vil, $sayswitch, $label,$countid );
		}
		# �\�͎Ґ����̕\��
		my $rolemes = $curpl->rolemessage( $role->{'explain_role'}->[$role->{'role'}] );
		&SWHtml::ConvertNET($sow, \$rolemes);
		print <<"_HTML_";
<div class="formpl_content">$rolemes</div>
_HTML_

		# �\�͑Ώې�ύX�v���_�E��
		&OutHTMLVotePC($sow, $vil, 'gift');

		# ����/����/�O�b
		$sayswitch = $curpl->giftsayswitch($vil);
		if ( '' ne $sayswitch ){
			my $label   = $sow->{'textrs'}->{'CAPTION_GIFTSAY'}->[$curpl->{'gift'}];
			my $countid = $sow->{'GIFTSAYCOUNTID'}->[$curpl->{'gift'}];
			&OutHTMLSayTextAreaExtPC($sow,$vil, $sayswitch, $label,$countid );
		}
		# �A�C�e�������̕\��
		my $giftmes = $curpl->rolemessage( $role->{'explain_gift'}->[$role->{'gift'}] );
		&SWHtml::ConvertNET($sow, \$giftmes);
		print <<"_HTML_";
<div class="formpl_content">$giftmes</div>
<div class="formpl_content">$winmes</div>
_HTML_

		# �\�͌��ʗ���
		my $history = $curpl->{'history'};
		&SWHtml::ConvertNET($sow, \$history);
		print "    <div class=\"formpl_content\"><p><strong>$history</strong></p>\n" if ($history ne '');

		# �^�����J
		my $lovestate = $curpl->getvisiblelovestate();
		my $love = '';
		$love = '�܂�A���Ȃ��͗������Ă���̂ł��B' if ($lovestate eq 'love');
		$love = '�܂�A���Ȃ��͎E�Ӗ��X�Ȃ̂ł��B'   if ($lovestate eq 'hate');
		my $targets = $curpl->getvisiblebonds($vil);
		foreach $target (@$targets) {
			print "<p>";
			my $targetname   = $target->getchrname();
			my $resultbonds  = $sow->{'textrs'}->{'STATE_BONDS'};
			$resultbonds =~ s/_TARGET_/$targetname/g;
			print "<strong>$resultbonds</strong><br$net>\n";
			print "</p>";
		}
		if ( '' ne $love ) {
			print "<strong>$love</strong><br$net>\n";
		}
		# �U�����܂ꂽ
		if ($curpl->{'sheep'} ne '') {
			my $sheeps = $vil->getsheeppllist();
			print "<p><strong>";
			if ( 1 < scalar(@$sheeps) ) {
				foreach (@$sheeps) {
					next if ($curpl eq $_);
					my $targetname = $_->getchrname();
					print "<b>$targetname</b>��";
				}
			}
			print "$sow->{'textrs'}->{'STATE_SHEEPS'}";
			print "</strong></p>";
		}

		# ���
		my $textAbility = $curpl->textDisableAbility();
		print "<p><strong>$textAbility</strong></p>" if ( $curpl->hasDisableAbility() && $curpl->issensible() );

		print <<"_HTML_";
</div>
<hr class="invisible_hr"$net>
</div>
<td>
<img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net>
</table>
_HTML_
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

	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

	# �\��I��
	&OutHTMLExpressionFormPC($sow, $vil);

	print <<"_HTML_";
<div class="formpl_content">
_HTML_

	# ������textarea�v�f�̏o��
	my ($saycnt,$cost,$unit) = $vil->getsayptcosts();
	my %htmlsay;
	$htmlsay{'buttonlabel'} = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	$htmlsay{'buttonlabel'} =~ s/_BUTTON_/$label/g;
	$htmlsay{'saycnttext'}  = " ����$curpl->{$countid}$unit" if ($cost ne 'none');
	$htmlsay{'disabled'} = 0;
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);

	my $draft = 0;
	$draft = 1 if (($sow->{'savedraft'} ne '') && (($sow->{'draftmestype'} == $sow->{'MESTYPE_WSAY'}) || ($sow->{'draftmestype'} == $sow->{'MESTYPE_SPSAY'}) || ($sow->{'draftmestype'} == $sow->{'MESTYPE_XSAY'})));
	if ($draft > 0) {
		my $mes = $sow->{'savedraft'};
		$mes =~ s/<br( \/)?>/\n/ig;
		$htmlsay{'text'} = $mes;
	}
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'writepr', \%htmlsay);
	print <<"_HTML_";
<select name="monospace">
<option value="">(�ʏ�)
<option value="monospace">����
<option value="report">���o��
</select>
<input type="hidden" name="$sayswitch" value="on"$net>
<input type="hidden" name="target" value="-1"$net>
</div>
</form>
_HTML_
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

	my $disabled = '';
	my $nosay = '';
	if (($sow->{'curpl'}->{'saidcount'} == 0)&&($vil->{'event'} != $sow->{'EVENTID_NIGHTMARE'})) {
		$disabled = " $sow->{'html'}->{'disabled'}";
		$nosay = "<br$net><br$net>�Œ�ꔭ�����Ċm�肵�Ȃ��ƁA���Ԃ�i�߂鎖���ł��܂���B";
	}

	print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <div class="formpl_content">
  <select name="commit"$disabled>
_HTML_

	my $star = ' *';
	my $option = $sow->{'html'}->{'option'};
	if ($sow->{'curpl'}->{'commit'} > 0) {
		print <<"_HTML_";
    <option value="0">���Ԃ�i�߂Ȃ�$option
    <option value="1" $sow->{'html'}->{'selected'}>���Ԃ�i�߂�$star$option
_HTML_
	} else {
		print <<"_HTML_";
    <option value="0" $sow->{'html'}->{'selected'}>���Ԃ�i�߂Ȃ�$star$option
    <option value="1">���Ԃ�i�߂�$option
_HTML_
	}

	print <<"_HTML_";
  </select>
  <input type="hidden" name="cmd" value="commit"$net>$hidden
  <input type="submit" value="�ύX"$disabled$net>
  </div>
  </form>

  <p class="formpl_content">�S�����u���Ԃ�i�߂�v��I�ԂƑO�|���ōX�V����܂��B$nosay</p>
</div>

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
	return if ($cmd eq 'vote' && ! $curpl->isEnableVote($vil->{'turn'}) );
	return if ($cmd eq 'role' && ! $curpl->isEnableRole($vil->{'turn'}) );
	return if ($cmd eq 'gift' && ! $curpl->isEnableGift($vil->{'turn'}) );

	# �����l�̎擾
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
      <div class="formpl_content">$hidden
      <input type="hidden" name="cmd" value="$cmd"$net>
_HTML_

	# ���[�^�ϔC�I��
	if ($cmd eq 'vote') {
		my $votelabels = $sow->{'textrs'}->{'VOTELABELS'};
		my $selected_vote = " $sow->{'html'}->{'selected'}";
		my $selectstar_vote = ' *';
		my $selected_entrust = '';
		my $selectstar_entrust = '';
		if ($curpl->{'entrust'} > 0) {
			$selected_vote = '';
			$selectstar_vote = '';
			$selected_entrust = " $sow->{'html'}->{'selected'}";
			$selectstar_entrust = ' *';
		}
		my $option = $sow->{'html'}->{'option'};
		if(     $curpl->setentrust($sow,$vil) == 0 ){
			print <<"_HTML_";
<select name="entrust">
<option value=""$selected_vote>$votelabels->[0]$selectstar_vote$option
</select>
_HTML_
		}elsif( $curpl->setvote_to($sow,$vil) == 0 ){
			print <<"_HTML_";
<select name="entrust">
<option value="on"$selected_entrust>$votelabels->[1]$selectstar_entrust$option
</select>
_HTML_
		}else{
			print <<"_HTML_";
<select name="entrust">
<option value=""$selected_vote>$votelabels->[0]$selectstar_vote$option
<option value="on"$selected_entrust>$votelabels->[1]$selectstar_entrust$option
</select>
_HTML_
		}
	} else {
		my $votelabel = $curpl->getlabel($cmd);
		print <<"_HTML_";
<label for="select$cmd">$votelabel�F</label>
_HTML_
	}

	print <<"_HTML_";
<select id="select$cmd" name="target">
_HTML_

	# �Ώۂ̕\��
	$targetlist = $curpl->gettargetlistwithrandom($cmd);
	foreach (@$targetlist) {
		my $selected = '';
		my $selstar = '';
		if ($curpl->{$cmd.'1'} == $_->{'pno'}) {
			$selected = " $sow->{'html'}->{'selected'}";
			$selstar = ' *';
		}
		print "<option value=\"$_->{'pno'}\"$selected>$_->{'chrname'}$selstar$sow->{'html'}->{'option'}\n";
	}
	if (($cmd eq 'vote')&&( $curpl->{$cmd.'1'} == $curpl->{'pno'})){
		my $pno      = $curpl->{'pno'};
		my $chrname  = $curpl->getlongchrname();
		my $selected = $sow->{'html'}->{'selected'};
		my $option   = $sow->{'html'}->{'option'};
		print '<option value="'.$pno.'" '.$selected.'>�����֓��[ *'.$option."\n";
	}

	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($vil->{'emulated'} > 0);

	print "</select>";

	my $votelabel = $curpl->gettargetlabel($cmd,$vil->{'turn'});
	if ( $votelabel ne '' ) {
		print " �ƁA";
		print <<"_HTML_";
<select id="select2$cmd" name="target2">
_HTML_

		# �Ώۂ̕\��
		$targetlist = $curpl->gettargetlistwithrandom($cmd);
		foreach (@$targetlist) {
			my $selected = '';
			my $selstar = '';
			if ($curpl->{$cmd.'2'} == $_->{'pno'}) {
				$selected = " $sow->{'html'}->{'selected'}";
				$selstar = ' *';
			}
			print "<option value=\"$_->{'pno'}\"$selected>$_->{'chrname'}$selstar$sow->{'html'}->{'option'}\n";
		}
		print "</select>";
	}
	print "\n";

	print <<"_HTML_";
      <input type="submit" value="�ύX"$disabled$net>
      </div>
    </form>

_HTML_

	return;
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
	my %imgpl = (
		cid      => $writemode,
		csid     => $keys[0],
		deathday => -1,
	);
	$imgpl{'deathday'} = $curpl->{'deathday'} if (defined($curpl->{'deathday'}));
	my $charset = $sow->{'charsets'}->{'csid'}->{$imgpl{'csid'}};

	# �L�����摜�A�h���X�̎擾
	my $img = &SWHtmlPC::GetImgUrl($sow, \%imgpl, $charset->{'BODY'});

	# �L�����摜
	print <<"_HTML_";
<table class="formpl_common">
<tr class="say">
<td class="img">
<img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net>

_HTML_

	# ���O��ID
	my $chrname = $sow->{'charsets'}->getchrname($imgpl{'csid'}, $imgpl{'cid'});
	print <<"_HTML_";
<td class="field">
<div class="msg">
<div class="formpl_content">$chrname ($sow->{'uid'})</div>

_HTML_

	# �e�L�X�g�{�b�N�X�Ɣ����{�^������
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_content">
_HTML_

	# ������textarea�v�f�̏o��
	my %htmlsay;
	$htmlsay{'saycnttext'} = '';
	$htmlsay{'buttonlabel'} = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_PC'};
	$htmlsay{'buttonlabel'} =~ s/_BUTTON_/$caption_say/g;
	$htmlsay{'disabled'} = 0;
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'writepr', \%htmlsay);

	print <<"_HTML_";
<select name="monospace">
<option value="">(�ʏ�)
<option value="monospace">����
<option value="report">���o��
</select>
<input type="hidden" name="$writemode" value="on"$net>
</div>
</form>

</div>
</table>

_HTML_

	return;
}

#----------------------------------------
# �\��I��HTML�o��
#----------------------------------------
sub OutHTMLExpressionFormPC {
	my ($sow, $vil) = @_;
	my $net = $sow->{'html'}->{'net'};

	my $expression = $sow->{'charsets'}->{'csid'}->{$sow->{'curpl'}->{'csid'}}->{'EXPRESSION'};
	if (@$expression > 0) {
		print <<"_HTML_";
    <div class="formpl_content">
      <label for="expression">�\\��F</label>
      <select id="expression" name="expression">
_HTML_

		my $i;
		for ($i = 0; $i < @$expression; $i++) {
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($i == 0);
			print "        <option value=\"$i\"$selected>$expression->[$i]$sow->{'html'}->{'option'}\n";
		}
		print "      </select>\n";
		print "    </div>\n";
	}

}

#----------------------------------------
# �L�b�N/�ҏW/����/���J�n/�X�V�{�^��HTML�o��
#----------------------------------------
sub OutHTMLUpdateSessionButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my %button;
	if ($vil->{'turn'} == 0) {
		%button = (
			label => '�����n�߂��Ⴈ��',
			cmd   => 'startpr',
		);
	} else {
		%button = (
			label => '�X�V���������悤�I�i����'.$vil->{'extend'}.'��j',
			cmd   => 'extendpr',
		);
	}

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="makerpr"$net>$hidden
    <select id="maker" name="target">
_HTML_
		# �����Č��ڏ�
		$targetlist = $vil->getallpllist();
		foreach (@$targetlist) {
			next if (($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'}));
			my $chrname = $_->getlongchrname();
			my $pno     = $_->{'pno'};
			print "<option value=\"$pno\">$chrname$sow->{'html'}->{'option'}\n";
		}
		print "</select>";
		print <<"_HTML_";
    <input type="submit" value="���̐l�ɑ���C����I"$net><br$net>
  </p>
  </form>

_HTML_

	my $disabled = '';
	if ($button{'cmd'} eq 'startpr') {
		my $upddatetime = sprintf('%02d:%02d',$vil->{'updhour'},$vil->{'updminite'});

		print <<"_HTML_";
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="kickpr"$net>$hidden
    <select id="kick" name="target">
_HTML_
		# �L�b�N�@�\
		$targetlist = $vil->getallpllist();
		foreach (@$targetlist) {
			next if (($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'}));
			my $chrname = $_->getlongchrname();
			my $pno     = $_->{'pno'};
			print "<option value=\"$pno\">$chrname$sow->{'html'}->{'option'}\n";
		}
		print "</select>";
		print <<"_HTML_";
    <input type="submit" value="�ދ������������A���ȁc�c"$net><br$net>
  </p>
  </form>
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="editvilform"$net>$hidden
    <input type="submit" value="����ҏW���悤�I"$net>
  </p>
  </form>
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="musterpr"$net>$hidden
    <input type="submit" value="�_�Ă��悤�I($upddatetime�܂�)"$net>
  </p>
  </form>
_HTML_
	} else {
		if ($vil->isepilogue()) {
			print <<"_HTML_";
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="editvilform"$net>$hidden
    <input type="submit" value="����ҏW���悤�I"$net>
  </p>
  </form>
_HTML_
		}

		if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}) {
			print <<"_HTML_";
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="updatepr"$net>$hidden
    <input type="submit" value="�X�V�����Ⴈ���I"$net>
  </p>
  </form>
_HTML_
		} else {
			# �����Đl�̉����@�\���p�͐�������
			$disabled = ' disabled' if ($vil->{'extend'} == 0);
		}
	}

	print <<"_HTML_";
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="$button{'cmd'}"$net>$hidden
    <input type="submit" value="$button{'label'}"$disabled$net>
  </p>
  </form>
</div>

_HTML_

	return;
}

#----------------------------------------
# �p���{�^��HTML�o��
#----------------------------------------
sub OutHTMLScrapVilButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="scrapvilpr"$net>$hidden
    <input type="submit" value="�p������"$net>
  </p>
  </form>
</div>

_HTML_

	return;
}



#----------------------------------------
# �u�����o��vHTML�o��
#----------------------------------------
sub OutHTMLExitButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');
	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($sow->{'uid'} eq $cfg->{'USERID_NPC'});

	print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="exitpr"$net>$hidden
    <input type="submit" value="�����o��"$disabled$net>
  </p>
  </form>
</div>

_HTML_

	return;
}



1;
