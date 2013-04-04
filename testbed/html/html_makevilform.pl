package SWHtmlMakeVilForm;

#----------------------------------------
# ���쐬�^�ҏW��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLMakeVilForm {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_RS'}/doc_rule.pl";
	my $doc = SWDocRule->new($sow);

	my $vmode = '�쐬';
	my $vcmd = 'makevil';
	if ($sow->{'query'}->{'cmd'} eq 'editvilform') {
		$vmode = '�ҏW';
		$vcmd = 'editvil' if ($sow->{'query'}->{'status'} ne 'dispose');
	}
#	$vcmd = 'makevilpr';

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader("����$vmode"); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = '';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $urlwiki = $cfg->{'URL_CONST'};
	my $linkmake  = '(Knowledge)Manual';

	$vil->{'trsid'} = $sow->{'query'}->{'trsid'} if ($sow->{'query'}->{'trsid'} ne '');
	&SWBase::LoadTextRS($sow, $vil);

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C���{�^��
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	print <<"_HTML_";
<div class="toppage">
<h2>����$vmode</h2>
_HTML_

	print "<p class=\"caution\">����$vmode����ɂ̓��O�C�����K�v�ł��B</p>\n\n" if ($sow->{'user'}->logined() <= 0);

	my $fullmanage  = ( $vil->{'turn'} == 0 );
	if ( $fullmanage ) {
		print <<"_HTML_";
<p class="paragraph">
<a href="$urlwiki$linkmake">�����ă}�j���A��</a>�⓯���҂̈ӌ����Q�l�ɁA���͓I�ȑ�������Ă����܂��傤�B
��W�����͍쐬����������$sow->{'cfg'}->{'TIMEOUT_SCRAP'}���Ԃł��B�������ɑ����J�n���Ȃ������ꍇ�A�p���ƂȂ�܂��B
</p>
_HTML_
	} else {
		$input = 'hidden';
	}

	my $vcomment = $vil->{'vcomment'};

	if ($vcomment eq ""){
		$vcomment="�i���̃��[���́A���R�ɕҏW�ł����I�j\n�����̃��[��";
		my $vrule = $doc->{'v_rule'};
		$list = $vrule->{'name'};
		for( $i=0; $i<@$list; $i++ ){
			next if ( '' eq $list->[$i] );
			my $name = $vrule->{'name'}->[$i];
			$vcomment .= "<br>".($i+1).".$name";
		}
	}

	$reqvals->{'cmd'} = 'rule';
	my $url_rule = &SWBase::GetLinkValues($sow, $reqvals);
	$url_rule = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$url_rule";

	print <<"_HTML_";
<form action="$urlsow" method="$cfg->{'METHOD_FORM'}">
<div class="form_vmake">

<fieldset>
<legend>���̖��O�Ɛ���</legend>
<input id="vname" type="text" name="vname" ng-model="story.name" size="50">
_HTML_
	if ( $fullmanage ) {
		$vcomment =~ s/<br( \/)?>/\n/ig;
		print <<"_HTML_";
<textarea id="vcomment" class="multicolumn_role" name="vcomment" cols="30" rows="10">$vcomment</textarea>
</fieldset>
<fieldset>
<p>
_HTML_
	} else {
		print <<"_HTML_";
<p>
$vcomment
<br>
_HTML_
	}
	print <<"_HTML_";
_HTML_

	print "�����̃��[��<br$net>";
	my $nrule = $doc->{'n_rule'};
	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		print "<strong>".($i+1).".$name</strong><br$net>";
	}

	print <<"_HTML_";
</p>
</fieldset>
<fieldset>
<p class="tips">
�ȏ�̍��ڂ��A<a href="$url_rule">$sow->{'cfg'}->{'NAME_SW'}�̃��[��</a>�Ȃ񂾁B�ҏW���Ă��������́A���R�ɕύX���Ă��܂�Ȃ��B
</p>
</fieldset>
_HTML_

	if ( $fullmanage ) {
		print <<"_HTML_";
<fieldset>
<legend>��{�ݒ�</legend>
<input type="hidden" name="trsid" value="$vil->{'trsid'}">
<dl>
<dt>$sow->{'textrs'}->{'CAPTION'}
<dd>$sow->{'textrs'}->{'HELP'}
</dl>
<dl class="dl-horizontal">
<dt><label for="vplcnt">���</label>
<dd><input id="vplcnt" class="input-mini" type="text" name="vplcnt" ng-model="event.player.limit" size="5">�l
<dt><label for="vplcntstart" >�Œ�l��</label>
<dd><input id="vplcntstart" class="input-mini" type="text" name="vplcntstart" ng-model="event.player.start" size="5">�l  ���J�n���@���l�TBBS�^�̎��̂�
<dt><label for="updhour">�X�V����</label>
<dd><select id="updhour" name="hour" class="input-small" ng-model="story.upd.hour">
</dl>
_HTML_

		my $i;
		for ($i = 0; $i < 24; $i++) {
			my $hour = sprintf('%02d��', $i);
			print "<option value=\"$i\">$hour</option>\n";
		}

		print <<"_HTML_";
</select>
<select id="updminite" name="minite" class="input-small" ng-model="story.upd.minute">
_HTML_

		for ($i = 0; $i < 60; $i += 30) {
			my $min = sprintf('%02d��', $i);
			print "<option value=\"$i\">$min</option>\n";
		}

		print <<"_HTML_";
</select>�ɍX�V

<dt><label for="updinterval">�X�V�Ԋu</label>
<dd><select id="updinterval" name="updinterval" class="input-large" ng-model="story.upd.interval">
_HTML_

		for ($i = 1; $i <= 3; $i++) {
			my $interval = sprintf('%02d����', $i * 24);
			print "<option value=\"$i\">$interval</option>\n";
		}

		print <<"_HTML_";
</select>���ƂɍX�V

<dt><label for="votetype">���[���@</label>
<dd><select id="votetype" name="votetype" ng-model="story.type.vote">
<option value="anonymity">���L�����[</option>
<option value="sign">�L�����[</option>
</select>

<dt><label for="roletable">��E�z��</label>
<dd><select id="roletable" name="roletable" ng-model="story.type.roletable">
_HTML_

		my $order_roletable = $sow->{'ORDER_ROLETABLE'};
		foreach (@$order_roletable) {
			my $caption  = $sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_};
			next if (!defined($caption));
			print "      <option value=\"$_\">$caption</option>\n";
		}

		print <<"_HTML_";
</select>
</fieldset>

<fieldset ng-show="story.type.roletable == 'custom'">
<legend>��E�z�����R�ݒ�</legend>
<TABLE class="multicolumn_role"><TBODY>
_HTML_

		my $hr = '<hr>';
		my $imgwidth = $charset->{'IMGBODYW'} + 2;
		my $tdwidth = 4;
		my $roleid  = $sow->{'ROLEID'};
		my $giftid  = $sow->{'GIFTID'};
		my $eventid = $sow->{'EVENTID'};
		for ($i=0,$d=0; $i <= @$roleid; $i++) {
			if    ($i == $sow->{'SIDEST_HUMANSIDE'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>�l��</h3><TR>\n ";
                $d = 0;
			}elsif($i == $sow->{'SIDEST_ENEMY'} ){
				my $enemy = "�l�T��";
				$enemy    = "�j�ő�" if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );
				print "\n\n<TR><TD colspan=$tdwidth><h3>$enemy�̐l��</h3><TR>\n ";
                $d = 0;
			}elsif($i == $sow->{'SIDEST_WOLFSIDE'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>�l�T</h3><TR>\n ";
                $d = 0;
			}elsif($i == $sow->{'SIDEST_PIXISIDE'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>�d��</h3><TR>\n ";
                $d = 0;
			}elsif($i == $sow->{'SIDEST_OTHER'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>����ȊO</h3><TR>\n ";
                $d = 0;
            }elsif($d >= $tdwidth){
                print "\n\n<TR> ";
                $d = 0;
            }
			next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
            $d++;
			print <<"_HTML_";
<TD nowrap align=right class="input-append input-prepend">
<label for="cnt$roleid->[$i]" class="add-on">$sow->{'textrs'}->{'ROLENAME'}->[$i]</label>
<input  id="cnt$roleid->[$i]" type="text" name="cnt$roleid->[$i]" class="input-tiny" size="2" value="$vil->{"cnt$roleid->[$i]"}"$net><span class="add-on">�l</span>
_HTML_
		}
		for ($i=$sow->{'SIDEST_DEAL'}; $i <= @$giftid; $i++) {
			if    ($i == $sow->{'SIDEST_DEAL'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>���b</h3><TR>\n ";
                $d = 0;
            }elsif($d >= $tdwidth){
                print "\n\n<TR> ";
                $d = 0;
            }
			next if ( '' eq $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$i] );
            $d++;
			print <<"_HTML_";
<TD nowrap align=right class="input-append input-prepend">
<label for="cnt$giftid->[$i]" class="add-on">$sow->{'textrs'}->{'GIFTNAME'}->[$i]</label>
<input  id="cnt$giftid->[$i]" type="text" name="cnt$giftid->[$i]" class="input-tiny" size="2" value="$vil->{"cnt$giftid->[$i]"}"$net><span class="add-on">�l</span>
_HTML_
		}
		print <<"_HTML_";
</TABLE>
</fieldset>
<fieldset style="text-align:center;">
<h3>����</h3>

<input type="text" id="eventcard" name="eventcard" ng-init="tokenInput('#eventcard', 'events', story.card.event)">
_HTML_

		for ($i=1,$d=0; $i <= @$eventid; $i++) {
			next if ( '' eq $sow->{'textrs'}->{'EVENTNAME'}->[$i] );
			print <<"_HTML_";
<span class="btn" onclick="tokenInput['#eventcard'].eventAdd('$eventid->[$i]')">$sow->{'textrs'}->{'EVENTNAME'}->[$i]</span>
_HTML_
		}

		print <<"_HTML_";
</fieldset>
_HTML_


		# �V���v���R���t�B�O�H
		if ('simple' eq $sow->{'textrs'}->{'FORCE_DEFAULT'}) {
			print <<"_HTML_";
<input type="hidden" name="entrylimit"   value="free"$net>
<input type="hidden" name="randomtarget" value=""$net>
<input type="hidden" name="noselrole"    value=""$net>
<input type="hidden" name="undead"       value=""$net>
<input type="hidden" name="showid"       value=""$net>
<input type="hidden" name="game"         value="TABULA"$net>

<fieldset>
<legend>�g���ݒ�</legend>
�v���C���[ID�̓G�s���[�O�܂Ŕ閧�ł��B�܂��A�T�E�d���́A���҂Ɖ�b�ł��܂���B�܂��A��E��]�𑸏d���A���[�E�\\�͂̑Ώۂ��A�����_���Ō��肷�邱�Ƃ͂ł��܂���B���[�������ɂȂ����Ƃ��̓����_���ɉ������A�l�Ԃ̐l�����l�T�ȉ��ɂȂ����瑺���̔s�k�ł��B
<br class="multicolumn_clear"$net>
_HTML_

		} else {

			print <<"_HTML_";
<fieldset>
<legend>�Q������</legend>
<label><input type="radio" name="entrylimit" value="free" ng-checked="0 == story.entry.password.length">�����Ȃ�</label><br>
<label>
<input type="radio" name="entrylimit" value="password" ng-checked="0 < story.entry.password.length">�Q���p�p�X���[�h�K�{�i���p�W�����ȓ��j
</label>
<input type="text" name="entrypwd" maxlength="8" size="8" ng-model="story.entry.password">
<br>
</fieldset>

<fieldset>
<legend>�g���ݒ�</legend>
<dl class="dl-horizontal">
<dt><label for="seqevent">��������</label>
<dd><input id="seqevent" name="seqevent" type="checkbox" ng-checked="story.options.some('seq-event')">
  �����������ǂ���ɔ�������
<dt><label for="entrust">�ϔC���[</label>
<dd><input id="entrust" name="entrust" type="checkbox" ng-checked="story.options.some('entrust')">
  �ϔC���[������
<dt><label for="noselrole">��E��]</label>
<dd><input id="noselrole" name="noselrole" type="checkbox" ng-checked="! story.options.some('select-role')">
  ��E��]�𖳎�����
<dt><label for="showid">ID���J</label>
<dd><input id="showid" name="showid" type="checkbox" ng-checked="story.options.some('show-id')">
  �v���C���[ID�����J����
_HTML_
			# �����_���Ώ�
			if ($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) {
				print <<"_HTML_";
<dt><label for="randomtarget">�����_��</label>
<dd><input id="randomtarget" name="randomtarget" type="checkbox" ng-checked="story.options.some('random-target')">
  ���[�E�\\�͂̑ΏۂɁu�����_���v���܂߂�
_HTML_
			}

			if ($cfg->{'ENABLED_UNDEAD'} == 1){
				print <<"_HTML_";
<dt><label for="undead">�H�E�g�[�N</label>
<dd><input id="undead" name="undead" type="checkbox" ng-checked="story.options.some('undead-talk')">
  �T�E�d���Ǝ��҂Ƃ̊ԂŁA��b���ł���
_HTML_
			}

			if ($cfg->{'ENABLED_AIMING'} == 1){
				print <<"_HTML_";
<dt><label for="aiming">�����b</label>
<dd><input id="aiming" name="aiming" type="checkbox" ng-checked="story.options.some('aiming-talk')">
  �ӂ��肾���̓����b�����邱�Ƃ��ł���
_HTML_
			}

			# ��E��]����
			print <<"_HTML_";
<dt><label for="game">�Q�[�����[��</label>
<dd><select id="game" name="game" class="input-large" ng-model="story.type.game">
_HTML_

			my $game     = $sow->{'basictrs'}->{'GAME'};
			my $gamelist = $sow->{'cfg'}->{'GAMELIST'};
			foreach (@$gamelist) {
				print "<option value=\"$_\">$game->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
			}

			# �����l���
			print <<"_HTML_";
</select>
_HTML_
		}
	} else {
		print <<"_HTML_";
<fieldset>
<legend>�g���ݒ�</legend>
_HTML_
	}
	print <<"_HTML_";
<dt><label for="rating">�������</label>
<dd><select id="rating" name="rating" class="input-large" ng-model="story.rating">
_HTML_

	# ���C�e�B���O
	my $rating = $sow->{'cfg'}->{'RATING'};
	foreach (@{$rating->{'ORDER'}}) {
		print "<option value=\"$_\">$rating->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
	}

	print <<"_HTML_";
</select>
<img name=cd_img src="$cfg->{'DIR_IMG'}/icon/cd_{{story.rating}}.png">
_HTML_

	if ( $fullmanage ) {
		print <<"_HTML_";
<dt><label for="csid">�o��l��</label>
<dd><select id="csid" name="csid" class="input-large" ng-model="story.csid">
_HTML_

		my $csidlist = $sow->{'cfg'}->{'CSIDLIST'};
		foreach (@$csidlist) {
			my @csids = split('/', "$_/");
			my @captions;
			foreach (@csids) {
				$sow->{'charsets'}->loadchrrs($_);
				push(@captions, $sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'});
			}
			my $caption = join('��', @captions);
			print "      <option value=\"$_\"$selected> $caption$sow->{'html'}->{'option'}\n";
		}

		# ���ҏW�œo��l������ύX����Ɓc�c�B

		print <<"_HTML_";
</select>
<dt><label for="saycnttype">��������</label>
<dd><select id="saycnttype" name="saycnttype" class="input-large" ng-model="story.type.say">
_HTML_

		my $countssay = $sow->{'cfg'}->{'COUNTS_SAY'};
		my $countssay_order = $countssay->{'ORDER'};
		foreach (@$countssay_order) {
			print "      <option value=\"$_\">$countssay->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
</select>
<dt><label for="starttype">�J�n���@</label>
<dd><select id="starttype" name="starttype" class="input-large" ng-model="story.type.start">
_HTML_

		my $starttype = $sow->{'basictrs'}->{'STARTTYPE'};
		foreach (@{$starttype->{'ORDER'}}) {
			print "      <option value=\"$_\">$starttype->{$_}$sow->{'html'}->{'option'}\n";
		}

		# �����l���
		print <<"_HTML_";
</select>
<dt><label for="mob">�����l</label>
<dd class="input-append input-prepend"><select id="mob" name="mob" class="input-small" ng-model="story.type.mob">
_HTML_
		my $mob = $sow->{'basictrs'}->{'MOB'};
		foreach (@{$mob->{'ORDER'}}) {
			print "<option value=\"$_\">$mob->{$_}->{'CAPTION'}�i$mob->{$_}->{'HELP'}�j$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
</select>
<span class="add-on">��</span>
<input id="cntmob" type="text" name="cntmob" class="input-tiny" size="3" value="$vil->{"cntmob"}">
<span class="add-on">�l</span>
</fieldset>

<div class="exevmake">
<input type="hidden" name="cmd" value="$vcmd"$net>$hidden
_HTML_
	} else {
		print <<"_HTML_";
</fieldset>
<div class="exevmake">
<input type="hidden" name="cmd" value="$vcmd"$net>$hidden
_HTML_
	}
	print "<input type=\"hidden\" name=\"vid\" value=\"$vil->{'vid'}\"$net>\n" if ($vil->{'vid'} > 0);

	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($sow->{'user'}->logined() <= 0);

	print <<"_HTML_";
<input type="submit" value="����$vmode"$disabled$net>
</div>
</div>
</form>
</div>

_HTML_

	# ���t�ʃ��O�ւ̃����N
	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	$sow->{'html'}->outcontentfooter();

	require "$cfg->{'DIR_HTML'}/html_sayfilter.pl";
	print <<"_HTML_";
<div id="tab" ng-cloak="ng-cloak">

<div class="sayfilter" id="sayfilter">
<h4 class="sayfilter_heading" ng-hide="navi.hide">�ݒ�</h4>
<div class="insayfilter" ng-show="navi.show.link"><div class="paragraph">
</div>
</div>
_HTML_
#	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLSayFilter($sow, $vil) if ($modesingle == 0);
	&SWHtmlSayFilter::OutHTMLTools    ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLFooter   ($sow, $vil);
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��

	print <<"_HTML_";
<script>
window.gon = OPTION.gon.clone(true);
_HTML_
	$vil->gon_story(true);
	$vil->gon_event(true);
	print <<"_HTML_";
</script>
_HTML_
	$sow->{'http'}->outfooter();

	return;
}

1;
