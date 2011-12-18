package SWValidityMakeVil;

#----------------------------------------
# ���쐬�E�ҏW���l�`�F�b�N
#----------------------------------------
sub CheckValidityMakeVilSummary {
	my $sow = shift;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���̍쐬�͂ł��܂���B", "cannot vmake.$errfrom") if ($sow->{'cfg'}->{'ENABLED_VMAKE'} == 0);

	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'vname'}, 'VNAME', 'vname', '���̖��O', 1);
}

sub CheckValidityMakeVil {
	my $sow = shift;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	&CheckValidityMakeVilSummary($sow);

	$query->{'vcomment'} = '' if ($query->{'vcomment'} eq $sow->{'basictrs'}->{'NONE_TEXT'});
	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'vcomment'}, 'VCOMMENT', 'vcomment', '���̐���', 1);

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�����񃊃\�[�X�����I���ł��B', "no trsid.$errfrom") if ($query->{'trsid'} eq '');
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�o��l�������I���ł��B', "no csid.$errfrom") if ($query->{'csid'} eq ''); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '��E�z�������I���ł��B', "no roletable.$errfrom") if ($query->{'roletable'} eq ''); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '���[���@�����I���ł��B', "no votetype.$errfrom") if ($query->{'votetype'} eq ''); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�X�V���ԁi���j�����I���ł��B', "no hour.$errfrom") if (!defined($query->{'hour'})); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�X�V���ԁi���j��0�`23�͈̔͂őI��ŉ������B', "invalid hour.$errfrom") if (($query->{'hour'} < 0) || ($query->{'hour'} > 23)); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�X�V���ԁi���j�����I���ł��B', "no minite.$errfrom") if (!defined($query->{'minite'})); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�X�V���ԁi���j��0�`59�͈̔͂őI��ŉ������B', "invalid minite.$errfrom") if (($query->{'minite'} < 0) || ($query->{'minite'} > 59)); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�X�V�Ԋu�����I���ł��B', "no updinterval.$errfrom") if (!defined($query->{'updinterval'})); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�X�V�Ԋu��1�`3�͈̔͂őI��ŉ������B', "invalid updinterval.$errfrom") if (($query->{'updinterval'} < 1) || ($query->{'updinterval'} > 3)); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '����������͂ł��B', "no vplcnt.$errfrom") if (!defined($query->{'vplcnt'}));
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�����$sow->{'cfg'}->{'MINSIZE_VPLCNT'}�`$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}�͈̔͂œ��͂��ĉ������B", "invalid vplcnt.$errfrom") if (($query->{'vplcnt'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'}) || ($query->{'vplcnt'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'}));
	if ($query->{'starttype'} eq 'wbbs') {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�Œ�l���������͂ł��B', "no vplcntstart.$errfrom") if (!defined($query->{'vplcntstart'}));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�Œ�l����$sow->{'cfg'}->{'MINSIZE_VPLCNT'}�`$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}�͈̔͂œ��͂��ĉ������B", "invalid vplcntstart.$errfrom") if (($query->{'vplcntstart'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'}) || ($query->{'vplcntstart'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'}));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�J�n���@���l�TBBS�^�Ŗ�E�z�����R�ݒ�̏ꍇ�A�Œ�l���ƒ���𓯂��l���ɂ��Ă��������B', "vplcnt != vplcntstart.$errfrom") if (($query->{'vplcntstart'} != $query->{'vplcnt'}) && ($query->{'roletable'} eq 'custom'));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�Œ�l���͒���ȉ��̐l���œ��͂��ĉ������B', "too many vplcntstart.$errfrom") if ($query->{'vplcntstart'} > $query->{'vplcnt'});
	}

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�������������I���ł��B', "no saycnttype.$errfrom") if ($query->{'saycnttype'} eq ''); # �ʏ�N���Ȃ�
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '��Ή��̎Q��������I�����Ă��܂��B', "invalid entrylimit.$errfrom") if (($query->{'entrylimit'} ne 'free') && ($query->{'entrylimit'} ne 'password')); # �ʏ�N���Ȃ�
	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'entrypwd'}, 'PASSWD', 'entrypwd', '�Q���p�X���[�h', 1) if ($query->{'entrylimit'} eq 'password');

	my $roleid = $sow->{'ROLEID'};
	my $giftid = $sow->{'GIFTID'};
	my $total     = 0;
	my $vplcnt    = $query->{'vplcnt'};

	if( 'custom' eq $query->{'roletable'} ){
		my $i;
		for ($i = 1; $i < @$roleid; $i++) {
			next if ( $i == $sow->{'ROLEID_MOB'} );
			my $count = 0;
			$count = $query->{"cnt$roleid->[$i]"} if (defined($query->{"cnt$roleid->[$i]"}));
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '��E�z���̐l����0�ȏ����͂��ĉ������B', "invalid role count.[$roleid->[$i] = $count] $errfrom") if ($count < 0);
			$total += $count;
		}
		for ($i = 1; $i < @$giftid; $i++) {
			my $count = 0;
			$count = $query->{"cnt$giftid->[$i]"} if (defined($query->{"cnt$giftid->[$i]"}));
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '��E�z���̐l����0�ȏ����͂��ĉ������B', "invalid gift count.[$giftid->[$i] = $count] $errfrom") if ($count < 0);
		}
	}
	my $mobs = $query->{'cntmob'}         if (defined($query->{'cntmob'}));

	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
	# ��E�z�����擾
	my ($roletable, $gifttable, $eventtable ) = &SWSetRole::GetSetRoleTable($sow, $query, $query->{'roletable'}, $query->{'vplcnt'});

	# �l�T�̐�
	my $wolves = 0;
	$wolves += $roletable->[$sow->{'ROLEID_WOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_AURAWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_INTWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_CURSEWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_WHITEWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_CHILDWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_DYINGWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_SILENTWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_HEADLESS'}];
	$wolves += $roletable->[$sow->{'ROLEID_LONEWOLF'}];
	$wolves += $gifttable->[$sow->{'GIFTID_OGRE'}];
	my $pixies = 0;
	$pixies += $roletable->[$sow->{'ROLEID_HAMSTER'}];
	$pixies += $roletable->[$sow->{'ROLEID_MIMICRY'}];
	$pixies += $roletable->[$sow->{'ROLEID_DYINGPIXI'}];
	$pixies += $roletable->[$sow->{'ROLEID_TRICKSTER'}];
	$pixies += $gifttable->[$sow->{'GIFTID_FAIRY'}];
	my $others = 0;
	$others += $roletable->[$sow->{'ROLEID_HATEDEVIL'}];
	$others += $roletable->[$sow->{'ROLEID_LOVEANGEL'}];
	$others += $roletable->[$sow->{'ROLEID_GURU'}];
	my $dishes = 0;
	$dishes += $roletable->[$sow->{'ROLEID_DISH'}];
	my $cntrobber = $roletable->[$sow->{'ROLEID_ROBBER'}];
	my $giftitems = 0;
	$giftitems += $gifttable->[$sow->{'GIFTID_SHIELD'}];
	$giftitems += $gifttable->[$sow->{'GIFTID_GLASS' }];
	my $giftappends = 0;
	$giftappends += $gifttable->[$sow->{'GIFTID_DECIDE'}];
	$giftappends += $gifttable->[$sow->{'GIFTID_SEERONCE'}];
	my $giftsides = 0;
	$giftsides += $gifttable->[$sow->{'GIFTID_OGRE'} ];
	$giftsides += $gifttable->[$sow->{'GIFTID_FINK'} ];
	$giftsides += $gifttable->[$sow->{'GIFTID_FAIRY'}];
	$giftsides += $eventtable->[$sow->{'EVENTID_TURN_FINK'}];
	$giftsides += $eventtable->[$sow->{'EVENTID_TURN_FAIRY'}];

	# ����
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�_�~�[�L�����̕��A���l�͍Œ� 1 �l����Ă��������B', "no villagers. $errfrom") if ($roletable->[$sow->{'ROLEID_VILLAGER'}] < 0);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�����҂� $sow->{'cfg'}->{'MAXCOUNT_STIGMA'} �l�܂łł��B", "too many stigma. $errfrom") if ($sow->{'cfg'}->{'MAXCOUNT_STIGMA'} < $roletable->[$sow->{'ROLEID_STIGMA'}]);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�l�T�����܂���B', "no wolves. $errfrom") if ($wolves <= 0);

	# ���b�́A�r������
	if      (0 < $giftitems){
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '���̗ւ▂���ƁA�����������ς�鉶�b�͋����ł��܂���B', "exclusion shield. $errfrom") if (0 < $giftsides);
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '���̗ւ▂���ƁA�\�͂������鉶�b�͋����ł��܂���B', "exclusion shield. $errfrom") if (0 < $giftappends);
	} elsif (0 < $giftappends){
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�\�͂������鉶�b�ƁA�����������ς�鉶�b�͋����ł��܂���B', "exclusion appendex. $errfrom") if (0 < $giftsides);
	}


	if( 'custom' eq $query->{'roletable'} ){
		my $diff =  $total - $cntrobber - $vplcnt;
		if (0 < $cntrobber){
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '��E�z���̍��v�l��'."($total�l)".'�����'."($vplcnt�l)".'��'."($diff)".'�l����܂���B', "invalid vplcnt or total plcnt.[$vplcnt + $cntrobber < $total] $errfrom") if ( $diff < 0 );
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�l�T��������葽���Ȃ��Ă��܂���B', "too many robbers than wolves . $errfrom") if ( $wolves <= $cntrobber  );
		} else {
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '��E�z���̍��v�l��'."($total�l)".'�����'."($vplcnt�l)".'�ƈقȂ�܂��B', "invalid vplcnt or total plcnt.[$vplcnt != $total] $errfrom") if ( $diff != 0 );
		}
	}


	$isjuror        = 0;
	$isjuror        = 1 if ('juror'             eq $query->{'mob'});
	$isdeadlose     = 0;
	$ismillerhollow = 0;
	$istabula       = 0;
	$istabula       = 1 if ('TABULA'            eq $query->{'game'});
	$istabula       = 1 if ('LIVE_TABULA'       eq $query->{'game'});
	$ismillerhollow = 1 if ('MILLERHOLLOW'      eq $query->{'game'});
	$ismillerhollow = 1 if ('LIVE_MILLERHOLLOW' eq $query->{'game'});
	$ismillerhollow = 1 if ('MISTERY'           eq $query->{'game'});
	$isdeadlose     = 1 if ('LIVE_TABULA'       eq $query->{'game'});
	$isdeadlose     = 1 if ('LIVE_MILLERHOLLOW' eq $query->{'game'});
	$isdeadlose     = 1 if ('TROUBLE'           eq $query->{'game'});
	if ( $istabula ){
		# �^�u���̐l�T���L�̃`�F�b�N
		if ($wolves *2 + 1 >= ($vplcnt - $pixies )) {
			if ($others > 0) {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�l�T���������܂��B', "too many wolves and pixies. $errfrom");
			} elsif ($pixies > 0) {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�l�T���������܂��i�d���͐l�Ԃɂ��l�T�ɂ��J�E���g����܂���j�B', "too many wolves and pixies. $errfrom");
			} else {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�l�T���������܂��B', "too many wolves. $errfrom");
			}
		}
	}

	if ( $isdeadlose ){
		# �u���񂾂畉���v���L�̃`�F�b�N
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�����V�͏����ł��܂���B', "DISH can't win. $errfrom") if (0 < $dishes );
	}
	
	if ( $ismillerhollow ){
		# �~���[�Y�z���[���L�̃`�F�b�N
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�_�~�[�L�����ȊO�ɁA���l�͍Œ� 1 �l����Ă��������B', "no villagers. $errfrom") if ($roletable->[$sow->{'ROLEID_VILLAGER'}] < 1);
	}

	if ( $isjuror ){
		# ���R�����x���L�̃`�F�b�N
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�Œ� 1 �l�A���R�������Ă��������B', "no Juror. $errfrom") if (0 == $mobs );
	}
	

	return;
}

1;