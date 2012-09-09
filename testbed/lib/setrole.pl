package SWSetRole;

#----------------------------------------
# ��E�z�����蓖��
#----------------------------------------
sub SetRole {
	my ($sow, $vil, $logfile) = @_;
	my $textrs  = $sow->{'textrs'};
	my $rolename = $textrs->{'ROLENAME'};

	my $pllist = $vil->getpllist();
	# ��E�z�����擾
	my ($roletable, $gifttable, $eventtable ) = &GetSetRoleTable($sow, $vil, $vil->{'roletable'}, scalar(@$pllist));
	my ($i, @roles, @gifts, @events);

	# �A�C�e���p�̔z���p��\n";
	for ($i = 0; $i < $sow->{'COUNT_GIFT'}; $i++) {
		my @giftpllist;
		$gifts[$i] = \@giftpllist;
	}

	# �A�C�e����]�͖�����
	for (@$pllist) {
		next if ($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
		# �S������������u�Ȃ��v��
		$giftpllist = $gifts[$sow->{'GIFTID_NOT_HAVE'}];
		push(@$giftpllist, $_);
	}

	# �u�Ȃ��v�̐l���󂢂Ă���A�C�e���֊��蓖��
	for ($i = 2; $i < $sow->{'COUNT_GIFT'}; $i++) {
		my $giftpllist = $gifts[$i];

		while ($gifttable->[$i] > @$giftpllist) {
			my $freepllist = $gifts[$sow->{'GIFTID_NOT_HAVE'}];
			my $pno      = int(rand(@$freepllist));
			my $movepl = splice(@$freepllist, $pno, 1);
			push(@$giftpllist, $movepl);
		}
	}

	# �A�C�e��������
	my $dummypl = $vil->getpl($sow->{'cfg'}->{'USERID_NPC'});
	$dummypl->{'gift'} = $sow->{'GIFTID_NOT_HAVE'}; # �_�~�[�L����
	for ($i = 1; $i < $sow->{'COUNT_GIFT'}; $i++) {
		my $giftpllist = $gifts[$i];
		foreach (@$giftpllist) {
 			if (!defined($_->{'gift'})) {
				# $_������`�i���肦�Ȃ��͂��j
				$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, 'invalid pl. [setgift.]');
			}
			$_->{'gift'} = $i;
		}
	}

	# �e��E�p�̔z���p��\n";
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		my @rolepllist;
		$roles[$i] = \@rolepllist;
	}

	# ��E��]��ۑ�\n";
	foreach (@$pllist) {
		$_->{'backupselrole'} = $_->{'selrole'};
	}


	# �����_���p�A��E�h�c�I�����ꗗ�쐬\n";
	my $rolecards = 0;
	my @randomroletable;
	my $roleid;
	for ($roleid = 0; $roleid < @$roletable; $roleid++) {
		my $rolecount = $roletable->[$roleid];
		$rolecards += $rolecount;
		while ($rolecount > 0) {
			push(@randomroletable, $roleid);
			$rolecount--;
		}
	}


	# �]��D�m��\n";
	my $robbers = $roletable->[$sow->{'ROLEID_ROBBER'}];
	if ($robbers > 0) {
		# �m�ۂ���]��D�́A�_�~�[�����������������Ōv�Z����B
		for($i = ($rolecards - (scalar(@$pllist)-1)); 0 < $i ; $i--){
			$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "�]��D�ɗ�����:$i");
#			���߂蓐���ɂ���Ȃ�A���̎��œ����Ԃ��z��
#			my $choice = $randomroletable[int(rand(@randomroletable))];
#			�����͗]��Ȃ��B
#			redo if ($choice == $sow->{'ROLEID_ROBBER'} );
#			my $rolepllist = $roles[$choice];
#			���܂��������Ȃ�A���C���g�ɓ����Ԃ��z��
			my $rolepllist = $roles[0];
			push(@$rolepllist, 0);
		}
	}
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $textrs->{'NOSELROLE'}) if ($vil->{'noselrole'} > 0);

	# �����_����]�̏���\n";
	foreach (@$pllist) {
		next if ($_->{'selrole'} >= 0);

		if ($vil->{'noselrole'} > 0) {
			$_->{'selrole'} = 0; # ��E��]�����̎��͂��܂�����
		} else {
			$_->{'selrole'} = $randomroletable[int(rand(@randomroletable))];
			my $randomroletext = $textrs->{'SETRANDOMROLE'};
			my $chrname = $_->getlongchrname();
			$randomroletext =~ s/_NAME_/$chrname/g;
			$randomroletext =~ s/_SELROLE_/$textrs->{'ROLENAME'}->[$_->{'selrole'}]/g;
			$logfile->writeinfo($dummypl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $randomroletext);
		}
	}

	# ��E��]��ID����]������E�̔z��Ɋi�[\n";
	for (@$pllist) {
		next if ($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
		my $selrolelist = $roles[$_->{'selrole'}];
		# ��E��]�𖳎����āA�S�������܂�����
		$selrolelist = $roles[0] if (($vil->{'noselrole'} > 0)&&($_->{'role'} == -1));
		push(@$selrolelist, $_);
	}

	my $freepllist;
	my $roleslist;
	my $movepl;
	for ($i = 1; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$roleslist  = $roles[$i];

		# ���Ԃꂽ�l�����܂����z��Ɉړ�
		while ($roletable->[$i] < @$roleslist) {
			$freepllist = $roles[0]; # ���܂����z��
			my $pno = int(rand(@$roleslist));

			# ���܂����z��ֈړ�
			$movepl    = splice(@$roleslist, $pno, 1);
			push(@$freepllist, $movepl);
		}
	}

	# ���܂����̐l���󂢂Ă����E�֊��蓖��
	for ($i = $sow->{'COUNT_ROLE'}; 0 < $i  ; $i--) {
		$roleslist = $roles[$i];

		while ($roletable->[$i] > @$roleslist) {
			$freepllist = $roles[0];
			my $targetpl   = int(rand(@$freepllist));
#			�����͗]��Ȃ��B
			redo if (($targetpl == 0)&&($i == $sow->{'ROLEID_ROBBER'} ));
			$movepl = splice(@$freepllist, $targetpl, 1);
			push(@$roleslist, $movepl);
		}
	}

	# ���蓖�Ĉꗗ�\���i�e�X�g�p�j
	for ($i = 0; $i < @$rolename; $i++) {
		my $pid = $roles[$i];
		my $n = @$pid;
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "[$rolename->[$i]] $n");
	}

	# ��E������
	$dummypl->{'role'} = $sow->{'ROLEID_VILLAGER'}; # �_�~�[�L����
	my @rolediscard;
	for ($i = 1; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$roleslist = $roles[$i];
		foreach (@$roleslist) {
			if ($_ == 0) {
				push(@rolediscard, $i);
			} else {
	 			if (!defined($_->{'role'})) {
					# $_������`�i���肦�Ȃ��͂��j
					$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, 'invalid pl. [setrole.]');
				}
				$_->{'role'} = $i;
				$_->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
			}
		}
	}
	$vil->{'rolediscard'} = join('/',@rolediscard);

	# ���蓖�Ĉꗗ�\���i�e�X�g�p�j#	foreach (@$pllist) {
#		print "[$_->{'uid'}] $rolename->[$_->{'selrole'}] �� $rolename->[$_->{'role'}]\n";
#	}
	&SWCommit::StartGM($sow, $vil);
	return $roletable, $gifttable ;
}


#----------------------------------------
# �z���\�̎擾
#----------------------------------------
sub GetSetRoleTable {
	my ($sow, $vil, $roletable, $plcnt) = @_;

	my ( @roles,@gifts,@eventcard );
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$roles[$i] = 0;
	}
	for ($i = 0; $i < $sow->{'COUNT_GIFT'}; $i++) {
		$gifts[$i] = 0;
	}

	if      ($roletable eq 'default') {
		# �W���z���\�̎擾
		&GetSetRoleTableDefault($sow, $plcnt, \@roles, \@gifts, \@eventcard );
	} elsif ($roletable eq 'mistery') {
		# �[�����̖�̕\�̎擾
		&GetSetRoleTableMistery($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'wbbs_c') {
		# �b���z���\�̎擾
		&GetSetRoleTableWBBS_C($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'wbbs_f') {
		# F���z���\�̎擾
		&GetSetRoleTableWBBS_F($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'wbbs_g') {
		# G���z���\�̎擾
		&GetSetRoleTableWBBS_G($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'test1st') {
		# ������^�z���\�̎擾
		&GetSetRoleTableTest1st($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'test2nd') {
		# ������^�z���\�̎擾
		&GetSetRoleTableTest2nd($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'starwars') {
		&GetSetRoleTableStarWars($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'ocarina') {
		&GetSetRoleTableEssence($sow, $plcnt, \@roles, \@gifts, \@eventcard, 'ROLEID_GURU' );

	} elsif ($roletable eq 'lover') {
		&GetSetRoleTableEssence($sow, $plcnt, \@roles, \@gifts, \@eventcard, 'ROLEID_LOVEANGEL' );

	} elsif ($roletable eq 'hater') {
		&GetSetRoleTableEssence($sow, $plcnt, \@roles, \@gifts, \@eventcard, 'ROLEID_HATEDEVIL' );

	} else {
		# �J�X�^���z���\�̎擾
		&GetSetRoleTableCustom($sow, $vil, \@roles, \@gifts, \@eventcard );
	}

	return( \@roles, \@gifts, \@eventcard );
}

#----------------------------------------
# ���l�l������
#----------------------------------------
sub GetSetVillager {
	my ($sow, $plcnt, $roles) = @_;

	my $total = 0;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$total += $roles->[$i];
	}

	# �T�C�������������ƁB
	$roles->[$sow->{'ROLEID_VILLAGER'}] = $plcnt - $total - 1;
}


#----------------------------------------
# �W���z���\�̎擾
#----------------------------------------
sub GetSetRoleTableDefault {
	my ($sow, $plcnt, $roles, $gifts, $eventcard ) = @_;

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}] = 1;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);
	# ���l
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt == 10);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt == 11);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 0 if ($plcnt == 12);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 2 if ($plcnt == 13);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 2 if ($plcnt == 14);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 0 if ($plcnt == 15);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt >= 16);
	# ���M��
	$roles->[$sow->{'ROLEID_FANATIC'}] = 1 if ($plcnt == 12);
	# �b�����l
	$roles->[$sow->{'ROLEID_WISPER'}] = 1 if ($plcnt == 15);

	# �肢�t
	$roles->[$sow->{'ROLEID_SEER'}]  = 1;
	# ���I�i���h
	$gifts->[$sow->{'GIFTID_DECIDE'}] = 1 if ($plcnt >= 8);

	# ��\��
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 10);
	# ��l
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 8);
	# ������
	$roles->[$sow->{'ROLEID_STIGMA'}] = 1 if ($plcnt == 13);
	$roles->[$sow->{'ROLEID_STIGMA'}] = 1 if ($plcnt == 14);
	# ���L��
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}


#----------------------------------------
# �[�����̖�̎擾
#----------------------------------------
sub GetSetRoleTableMistery {
	my ($sow, $plcnt, $roles, $gifts, $eventcard ) = @_;

	# ���l
	$roles->[$sow->{'ROLEID_POSSESS'}]   = 1 if ($plcnt ==  6);
	$roles->[$sow->{'ROLEID_POSSESS'}]   = 1 if ($plcnt ==  7);
	$roles->[$sow->{'ROLEID_MUPETTING'}] = 1 if ($plcnt ==  9);
	$roles->[$sow->{'ROLEID_MUPETTING'}] = 1 if ($plcnt == 10);
	$roles->[$sow->{'ROLEID_MUPETTING'}] = 1 if ($plcnt == 11);
	$roles->[$sow->{'ROLEID_MUPETTING'}] = 1 if ($plcnt == 12);
	$roles->[$sow->{'ROLEID_JAMMER'}]    = 1 if ($plcnt >= 13);

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}]      = 1;
	$roles->[$sow->{'ROLEID_WOLF'}]      = 0 if ( 8 > $plcnt);
	$roles->[$sow->{'ROLEID_LONEWOLF'}]  = 1 if ( 8 > $plcnt);
	$roles->[$sow->{'ROLEID_WOLF'}]      = 2 if ($plcnt ==  8);
	$roles->[$sow->{'ROLEID_WOLF'}]      = 2 if ($plcnt ==  9);
	$roles->[$sow->{'ROLEID_WOLF'}]      = 2 if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_CHILDWOLF'}] = 1 if ($plcnt >= 10);

	# ��O�w�c
	$roles->[$sow->{'ROLEID_GURU'}]    = 1 if ($plcnt >= 19);

	# �肢�t�A�C�肢�t�A�����A��\��
	$roles->[$sow->{'ROLEID_AURA'}]   = 1 if ($plcnt >=  8);
	$roles->[$sow->{'ROLEID_SEER'}]   = 1 if ($plcnt ==  4);
	$roles->[$sow->{'ROLEID_SEER'}]   = 1 if ($plcnt ==  5);
	$roles->[$sow->{'ROLEID_SEER'}]   = 1 if ($plcnt >= 11);
	$roles->[$sow->{'ROLEID_MEDIUM'}] = 1 if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_GIRL'}]   = 1 if ($plcnt >= 17);
	# ���ҁA���
	$roles->[$sow->{'ROLEID_GUARD'}]  = 1 if ($plcnt >=  6);
	$roles->[$sow->{'ROLEID_DOCTOR'}] = 1 if ($plcnt >=  8);
	# ����
	$roles->[$sow->{'ROLEID_WITCH'}]  = 1 if ($plcnt >= 15);
	# �B���p�t�A�܋��҂��A��ҁA���l
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  5);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  6);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  7);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  8);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  9);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt == 14);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt == 20);
	$roles->[$sow->{'ROLEID_FAN'}]       = 1 if ($plcnt ==  7);
	$roles->[$sow->{'ROLEID_HUNTER'}]    = 1 if ($plcnt >= 12);
	$roles->[$sow->{'ROLEID_HUNTER'}]    = 1 if ($plcnt >= 12);
	$roles->[$sow->{'ROLEID_CURSE'}]     = 1 if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_FAN'}]       = 1 if ($plcnt >= 18);

	# ���I�i���h
	$gifts->[$sow->{'GIFTID_DECIDE'}] = 1 if ($plcnt >= 7);

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

#----------------------------------------
# �b���z���\�̎擾
#----------------------------------------
sub GetSetRoleTableWBBS_C {
	my ($sow, $plcnt, $roles) = @_;

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# �肢�t
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# ��\��
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# �b�����l
	$roles->[$sow->{'ROLEID_WISPER'}]++ if ($plcnt >= 10);

	# ��l
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# ���L��
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

sub GetSetRoleTableWBBS_F {
	my ($sow, $plcnt, $roles) = @_;

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# �肢�t
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# ��\��
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# ���l
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 10);

	# ��l
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# ���L��
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

sub GetSetRoleTableWBBS_G {
	my ($sow, $plcnt, $roles) = @_;

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# �肢�t
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# ��\��
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# ���l
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 11);

	# ��l
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# ���L��
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

#----------------------------------------
# ������^�z���\�̎擾
#----------------------------------------
sub GetSetRoleTableTest1st {
	my ($sow, $plcnt, $roles) = @_;

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 23);

	# �肢�t
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# ��\��
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# ���l
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 10);
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if (($plcnt >= 13) && ($plcnt <= 14)); # 15�`18�ł͂P�l
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 19);

	# ��l
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# ���L��
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 19);

	# ������
	$roles->[$sow->{'ROLEID_STIGMA'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_STIGMA'}]++ if (($plcnt >= 16) && ($plcnt <= 18));

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

#----------------------------------------
# ������^�z���\�̎擾
#----------------------------------------
sub GetSetRoleTableTest2nd {
	my ($sow, $plcnt, $roles) = @_;

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 21);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 26);

	# �肢�t
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# ��\��
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# ���M��
	$roles->[$sow->{'ROLEID_FANATIC'}]++ if ($plcnt >= 10);

	# ��l
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# ���L��
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

#----------------------------------------
# �������̉F���푈�̎擾
#----------------------------------------
sub GetSetRoleTableStarWars {
	my ($sow, $plcnt, $roles, $gifts, $eventcard ) = @_;

	my @enemy = ('ROLEID_JAMMER','ROLEID_SNATCH','ROLEID_BAT');

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 23);

	# �n���X�^�[�l��
	$roles->[$sow->{'ROLEID_HAMSTER'}]++ if ($plcnt >= 16);

	# �肢�t
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# ��\��
	$roles->[$sow->{'ROLEID_NECROMANCER'}]++ if ($plcnt >= 9);

	# ���l
	$roles->[$sow->{@enemy[rand(@enemy)]}]++ if  ($plcnt >= 10);
	$roles->[$sow->{@enemy[rand(@enemy)]}]++ if (($plcnt >= 13) && ($plcnt <= 14)); # 15�`18�ł͂P�l
	$roles->[$sow->{@enemy[rand(@enemy)]}]++ if  ($plcnt >= 19);

	# ��l
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# ���L��
	$roles->[$sow->{'ROLEID_WITCH'}] = 1 if ($plcnt >= 19);

	# ������
	$roles->[$sow->{'ROLEID_ALCHEMIST'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}]++ if (($plcnt >= 16) && ($plcnt <= 18));

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}



#----------------------------------------
# ���g���E�I�[�P�X�g���̎擾
#----------------------------------------
sub GetSetRoleTableEssence {
	my ($sow, $plcnt, $roles, $gifts, $eventcard, $essence ) = @_;

	# �l�T
	$roles->[$sow->{'ROLEID_WOLF'}] = 1;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);
	# ���l
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt == 10);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt == 11);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 0 if ($plcnt == 12);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 2 if ($plcnt == 13);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 2 if ($plcnt == 14);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 0 if ($plcnt == 15);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt >= 16);
	# �l�`����
	$roles->[$sow->{'ROLEID_MUPPETING'}] = 1 if ($plcnt == 12);
	# �b�����l
	$roles->[$sow->{'ROLEID_WISPER'}] = 1 if ($plcnt == 15);

	# �肢�t
	$roles->[$sow->{'ROLEID_SEER'}]  = 1;

	# ��\��
	$roles->[$sow->{'ROLEID_NECROMANCER'}]++ if ($plcnt >= 9);
	# ��l
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 8);

	# ���L��
	$roles->[$sow->{'ROLEID_WITCH'}] = 1 if ($plcnt >= 19);

	# ������
	$roles->[$sow->{'ROLEID_ALCHEMIST'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}]++ if (($plcnt >= 16) && ($plcnt <= 18));
	# �J����
	$roles->[$sow->{$essence}]++  if ($plcnt >= 15);

	# ���l
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}



#----------------------------------------
# �J�X�^���z���\�̎擾
#----------------------------------------
sub GetSetRoleTableCustom {
	my ($sow, $vil, $roles, $gifts, $eventcard ) = @_;

	my $i;
	my $roleid = $sow->{'ROLEID'};
	for ($i = 1; $i < @$roleid; $i++) {
		$roles->[$i] = $vil->{"cnt$roleid->[$i]"};
	}
	$roles->[1]--; # �_�~�[�L�����̕�

	my $giftid = $sow->{'GIFTID'};
	for ($i = 2; $i < @$giftid; $i++) {
		$gifts->[$i] = $vil->{"cnt$giftid->[$i]"};
	}

	my $eventid = $sow->{'EVENTID'};
	for ($i = 1; $i < @$eventid; $i++) {
		$eventcard->[$i] = $vil->{"cnt$eventid->[$i]"};
	}

	return;
}

1;

