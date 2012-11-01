
package SWHtmlEntryFormPC;

#----------------------------------------
# �G���g���[�t�H�[���̏o��
#----------------------------------------
sub OutHTMLEntryFormPC {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};

	my $allpllist = $vil->getallpllist();
	my $pllist    = $vil->getpllist();
	my $mobs      = $vil->getrolepllist($sow->{'ROLEID_MOB'});
	my $isplok    = $vil->{'vplcnt'} - @$pllist;
	my $ismobok   = $vil->{'cntmob'} - @$mobs  ;

	print <<"_HTML_" unless ($isplok);
gon.cautions.push("���ɒ���ɒB���Ă��܂��B");
_HTML_
	return unless (($isplok)||($ismobok));

	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";

	# �L�����Z�b�g�̓ǂݍ���
	my @csidkey = split('/', "$vil->{'csid'}/");
	foreach (@csidkey) {
		$sow->{'charsets'}->loadchrrs($_);
	}

	# �Q���ς݂̃L�������`�F�b�N
	my %csid_cid;
	foreach (@$allpllist) {
		$csid_cid{"$_->{'csid'}/$_->{'cid'}"} = 1;
	}

	print <<"_HTML_";
gon.potof || (gon.potof = {
    sow_auth_id: "$sow->{'uid'}",
});
text_form = {
	cmd: "entry",
	jst: "entry",
	text: "",
	style: "",
	count: "",
	title: "���̑��ɎQ��",
	mestype: "SAY",
	longname: "",
	csid_cids: [
_HTML_
	# ��]����z���̕\��
	my $csid_val;
	foreach $csid_val (@csidkey) {
		my $charset = $sow->{'charsets'}->{'csid'}->{$csid_val};
		my $chrorder = $charset->{'ORDER'};
		foreach (@$chrorder) {
			next if (defined($csid_cid{"$csid_val/$_"})); # �Q���ς݂̃L�����͏��O
			my $chrname = $sow->{'charsets'}->getchrname($csid_val, $_);
			print "{val:\"$csid_val/$_\", name:\"$chrname\"},\n";
		}
	}
	print <<"_HTML_";
	],
	roles: [
_HTML_
	# ��]����\�͂̕\��
	if ($isplok) {
		print "{val:-1, name:\"$sow->{'textrs'}->{'RANDOMROLE'}\"},\n";
		my $rolename = $sow->{'textrs'}->{'ROLENAME'};
		my ( $rolematrix, $giftmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'});

		my $i;
		foreach ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
			my $output = $rolematrix->[$i];
			$output = 1 if ($i == 0); # ���܂����͕K���\��
			print "{val:$i, name:\"$rolename->[$i]\"},\n" if ($output > 0);
		}
	}
	if ($ismobok){
		my $mob = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'};
		print "{val:$sow->{'ROLEID_MOB'}, name:\"$mob�Ō���\"},\n";
	}
	print <<"_HTML_";
	],
};
text_form.csid_cid = text_form.csid_cids[0].val
text_form.role     = text_form.roles[0].val
gon.form.texts.push(text_form);
_HTML_

}

1;
