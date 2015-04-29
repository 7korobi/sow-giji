
package SWHtmlEntryFormPC;

#----------------------------------------
# �G���g���[�t�H�[���̏o��
#----------------------------------------
sub OutHTMLEntryFormPC {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $query = $sow->{'query'};
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $hidden  = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	my $allpllist = $vil->getallpllist();
	my $pllist    = $vil->getpllist();
	my $mobs      = $vil->getrolepllist($sow->{'ROLEID_MOB'});
	my $isplok    = $vil->{'vplcnt'} - @$pllist;
	my $ismobok   = $vil->{'cntmob'} - @$mobs  ;

	print "<p class=\"caution\">\n���ɒ���ɒB���Ă��܂��B\n</p>\n<hr class=\"invisible_hr\"$net>\n\n" unless ($isplok);
	return unless (($isplok)||($ismobok));

	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";

	# �L�����Z�b�g�̓ǂݍ���
	my @csidkey = split('/', "$vil->{'csid'}/");
	foreach (@csidkey) {
		$sow->{'charsets'}->loadchrrs($_);
	}

	# �L�����摜�A�h���X�̎擾
	my $charset = $sow->{'charsets'}->{'csid'}->{$csidkey[0]}; # ��
	my $body = '';
	$body = '_body' if ($charset->{'BODY'} ne '');
	my $img = "$charset->{'DIR'}/undef$body$charset->{'EXT'}";

	# �L�����摜���Ƃ��̑����̉������擾
	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');


	my $tag = $query->{'tag'};
	print <<"_HTML_";
<div class="formpl_frame">
<table class="formpl_common">
<tr class="say">
<td class="img"><img name="chr_img" src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}">
<td class="field"><div class="msg">
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}#newsay" method="$cfg->{'METHOD_FORM_MB'}">
<div class="formpl_content">
<label for="tag">���ރ^�O����T���F</label>
<select name="tag">
_HTML_
	foreach $csid_val (@csidkey) {
		my $charset = $sow->{'charsets'}->{'csid'}->{$csid_val};
		my $tagorder = $charset->{'TAG_ORDER'};
		foreach (@$tagorder) {
			if (! $tag) { $tag = $_; }
			my $tagname = $sow->{'charsets'}->{'tag'}->{'TAG_NAME'}->{$_};
			my $selected = '';
			my $star = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($_ eq $tag);
			$star = "* " if ($_ eq $tag);
			print "<option value=\"$_\"$selected>$star$tagname$sow->{'html'}->{'option'}\n";
		}
	}
	print <<"_HTML_";
</select>
<input type="hidden" name="cmd" value="$query->{'cmd'}"$net>$hidden
<input type="submit" value="�T��"$net>
</div>
</form>
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<div class="formpl_content">
<label for="selectcid">��]����z���F</label>
<select id="selectcid" name="csid_cid" onFocus='javascript:chrImgChange(document.chr_img,this,"$charset->{'DIR'}","$vil->{'csid'}","$body$charset->{'EXT'}")' onChange='javascript:chrImgChange(document.chr_img,this,"$charset->{'DIR'}","$vil->{'csid'}","$body$charset->{'EXT'}")'>
_HTML_

	# �Q���ς݂̃L�������`�F�b�N
	my %csid_cid;
	foreach (@$allpllist) {
		$csid_cid{"$_->{'csid'}/$_->{'cid'}"} = 1;
	}

	# ��]����z���̕\��
	my $csid_val;
	foreach $csid_val (@csidkey) {
		my $charset = $sow->{'charsets'}->{'csid'}->{$csid_val};
		my $chrorder = $charset->{'CHRORDER'}->{$tag};
		foreach (@$chrorder) {
			next if (defined($csid_cid{"$csid_val/$_"})); # �Q���ς݂̃L�����͏��O
			my $chrname = $sow->{'charsets'}->getchrname($csid_val, $_);
			print "      <option value=\"$csid_val/$_\">$chrname$sow->{'html'}->{'option'}\n";
		}
	}

	print <<"_HTML_";
</select>
</div>

<div class="formpl_content">
<label for="selectrole">��]����\\�́F</label>
<select id="selectrole" name="role">
_HTML_
	# ��]����\�͂̕\��
	if ($isplok) {
		print "<option value=\"-1\">$sow->{'textrs'}->{'RANDOMROLE'}$sow->{'html'}->{'option'}";
		my $rolename = $sow->{'textrs'}->{'ROLENAME'};
		my ( $rolematrix, $giftmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'});

		my $i;
		foreach ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
			my $output = $rolematrix->[$i];
			$output = 1 if ($i == 0); # ���܂����͕K���\��
			print "<option value=\"$i\">$rolename->[$i]$sow->{'html'}->{'option'}\n" if ($output > 0);
		}
	}
	if ($ismobok){
		my $mob = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'};
		print "        <option value=\"$sow->{'ROLEID_MOB'}\">$mob�Ō���$sow->{'html'}->{'option'}\n";
	}
	print <<"_HTML_";
      </select>
    </div>

    <div class="formpl_content">
      �Q�����鎞�̃Z���t�F
_HTML_

	# ������textarea�v�f�̏o��
	my %htmlsay;
	$htmlsay{'buttonlabel'} = '���̑��ɎQ��';
	$htmlsay{'saycnttext'} = '';
	$htmlsay{'disabled'} = 0;
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	if (($query->{'mes'} ne '') && ($query->{'cmdfrom'} eq 'entrypr')) {
		my $mes = $query->{'mes'};
		$mes =~ s/<br( \/)?>/\n/ig;
#		&SWBase::ExtractChrRef(\$mes);
		$htmlsay{'text'} = $mes;
	}
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'entrypr', \%htmlsay);

	print <<"_HTML_";
<select name="monospace">
<option value="">(�ʏ�)
<option value="monospace">����
<option value="report">���o��
</select>
    </div>
_HTML_

	# �Q���p�X���[�h���͗��̕\��
	if ($vil->{'entrylimit'} eq 'password') {
		print <<"_HTML_";

    <div class="formpl_content">
      <label for="entrypwd">�Q���p�X���[�h�F</label>
      <input id="entrypwd" type="password" name="entrypwd" maxlength="8" size="8" value=""$net>
    </div>
_HTML_
	}

	print <<"_HTML_";
</div>
</form>
</table>

  <div class="clearboth">
    <hr class="invisible_hr"$net>
  </div>
</div>

_HTML_

}

1;
