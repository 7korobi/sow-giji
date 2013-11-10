package SWHtmlEntryFormMb;

#----------------------------------------
# �G���g���[�t�H�[���̏o�́i���o�C���j
#----------------------------------------
sub OutHTMLEntryFormMb {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $allpllist = $vil->getallpllist();
	my $pllist    = $vil->getpllist();
	my $mobs      = $vil->getrolepllist($sow->{'ROLEID_MOB'});
	my $isplok    = $vil->{'vplcnt'} - @$pllist;
	my $ismobok   = $vil->{'cntmob'} - @$mobs  ;

	if (($isplok)||($ismobok)){
	} else {
		# ����`�F�b�N
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "���ɒ���ɒB���Ă��܂��B�B", 'too many plcnt.');
		return;
	}

	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";

	# �L�����Z�b�g�̓ǂݍ���
	my @csidkey = split('/', "$vil->{'csid'}/");
	foreach (@csidkey) {
		$sow->{'charsets'}->loadchrrs($_);
	}

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader("$sow->{'query'}->{'vid'} $vil->{'vname'}"); # HTML�w�b�_�̏o��

	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $option = $sow->{'html'}->{'option'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	print <<"_HTML_";
<a name="say">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>
<a href="$link" accesskey="4">�߂�</a><br$net>
<hr$net>
_HTML_

	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
��]�z��<br$net>
<select name="csid_cid">
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
		my $chrorder = $charset->{'ORDER'};
		foreach (@$chrorder) {
			next if (defined($csid_cid{"$csid_val/$_"})); # �Q���ς݂̃L�����͏��O
			my $chrname = $sow->{'charsets'}->getchrname($csid_val, $_);
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ("$csid_val/$_" eq $query->{'csid_cid'});
			print "<option value=\"$csid_val/$_\"$selected>$chrname$sow->{'html'}->{'option'}\n";
		}
	}

	my $roleselected = '';
	$roleselected = " $sow->{'html'}->{'selected'}" if ((defined($query->{'role'})) && ($query->{'role'} < 0));

	print <<"_HTML_";
</select><br$net>

��]�\\��<br$net>
<select name="role">
_HTML_

	# ��]����\�͂̕\��
	if ($isplok) {
		print "<option value=\"-1\"$roleselected>$sow->{'textrs'}->{'RANDOMROLE'}$sow->{'html'}->{'option'}";
		my $rolename = $sow->{'textrs'}->{'ROLENAME'};
		if ($vil->{'mob'} eq 'gamemaster'){
			print "<option value=\"0\">$rolename->[0]\n";
		} else {
			my ( $rolematrix, $giftmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'});

			my $i;
			foreach ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
				my $output = $rolematrix->[$i];
				$output = 1 if ($i == 0); # ���܂����͕K���\��
				$roleselected = '';
				$roleselected = " $sow->{'html'}->{'selected'}" if ((defined($query->{'role'})) && ($query->{'role'} == $i));
				print "<option value=\"$i\"$roleselected>$rolename->[$i]$sow->{'html'}->{'option'}\n" if ($output > 0);
			}
		}
	}
	if ($ismobok){
		my $mob = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'};
		print "<option value=\"$sow->{'ROLEID_MOB'}\">$mob�Ō���$sow->{'html'}->{'option'}\n" ;
	}
	print <<"_HTML_";
</select><br$net>

_HTML_

	# �e�L�X�g�{�b�N�X�Ɣ����{�^��
	my $buttonlabel = '�Q��';

	# �Q���p�X���[�h���͗��̕\��
	if ($vil->{'entrylimit'} eq 'password') {
		my $entrypwd = '';
		$entrypwd = $query->{'entrypwd'} if ($query->{'entrypwd'} ne '');
		print <<"_HTML_";
�p�X���[�h<br$net>
<input type="text" name="entrypwd" size="8" istyle="3" value="$entrypwd"$net><br$net>
_HTML_
}

	my $mes = '';
	$mes = $query->{'mes'} if (($query->{'wolf'} eq '') && ($query->{'maker'} eq '') && ($query->{'admin'} eq ''));
	$mes =~ s/<br( \/)?>/\n/ig;

	print <<"_HTML_";
�Z���t<br$net>
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="cmd" value="entrypr"$net>$hidden
<input type="submit" value="$buttonlabel"$net>
_HTML_

	print <<"_HTML_";
<select name="monospace">
<option value="">(�ʏ�)
<option value="monospace">����
<option value="report">���o��
</select>
</form>
<hr$net>

<a href="$link">�߂�</a>
_HTML_

	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;
