package SWCommit;


#----------------------------------------
# ��������
#----------------------------------------
sub WinnerCheckGM {
	my ($sow, $vil) = @_;
	my $pllist = $vil->getpllist();

	# �W�v�J�n
	my $winner   = 0;
	my $humen    = 0;
	my $villager = 0;
	my $wolves   = 0;
	my $lonewolves = 0;
	my $pixies   = 0;
	my $others   = 0;
	my $sheeps   = 0;
	my $loves    = 0;
	my $hates    = 0;
	my $bonds    = 0;
	my $dishes   = 0;
	my $lives    = 0;
	my $zombies  = 0;
	$vil->{'wincnt_suddendead'} = 0;
	$vil->{'wincnt_executed'  } = 0;
	$vil->{'wincnt_cursed'    } = 0;
	$vil->{'wincnt_feared'    } = 0;
	$vil->{'wincnt_victim'    } = 0;
	$vil->{'wincnt_suicide'   } = 0;
	$vil->{'wincnt_droop'     } = 0;
	$vil->{'wincnt_zombie'    } = 0;

	foreach $plsingle (@$pllist) {
		$vil->{'wincnt_'.$plsingle->{'live'}}++;
		# �ʏ���
		if (($plsingle->{'role'} == $sow->{'ROLEID_DISH'})&&($plsingle->{'live'} eq 'victim')){
			my $targetname = $plsingle->getlongchrname();
			$dishes++;
		}
		
		# �ȉ��A�����҂̂ݕ\���B
		next if ($plsingle->{'live'} ne 'live');
		next if ($plsingle->{'role'} == $sow->{'ROLEID_MOB'});
		next if ($plsingle->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
		$lives++;

		# �]���r�[�ɂȂ��Ă��Ȃ��l���̂ݏW�v����B
		if ( $plsingle->isEnableState('MASKSTATE_ZOMBIE') ) {
			if      ($plsingle->ishuman() > 0) {
				$humen++;
				$villager++ if ($plsingle->{'role'} == $sow->{'ROLEID_VILLAGER'});
			} elsif ($plsingle->ispixi()  > 0) {
				$pixies++;
			} elsif ($plsingle->iswolf()  > 0) {
				$wolves++;
				$lonewolves++ if ($plsingle->{'role'} == $sow->{'ROLEID_LONEWOLF'});
			} else {
				$humen++;
				$others++;
			}
		} else {
			$zombies++;
		}

		# �U��ꂽ�l�܂��́A���c�ł���Ί��U�ς݈����B
		if ($plsingle->{'sheep'} eq 'pixi'){
			$sheeps++;
		}elsif($plsingle->{'role'} == $sow->{'ROLEID_GURU'}){
			$sheeps++;
		}
		# �Бz���Ή�
		# �����̂��߂Ɏ���ł����l���X�g����̗��l�����肦��B

		# �^�����J�i�����̂��߂Ɏ���ł����l�j�Ɉ�������
		if ('' ne $plsingle->{'bonds'}){
			$bonds++;
		}
		# �K���ȗ��l
		if ($plsingle->ishappy($vil) > 0 ){
			$loves++;
		}
		# �E���C���X�̐l
		if ('hate' eq $plsingle->{'love'}){
			$hates++;
		}
	}

	$vil->{'wincnt_human'   } = $humen;
	$vil->{'wincnt_villager'} = $villager;
	$vil->{'wincnt_wolf'    } = $wolves;
	$vil->{'wincnt_lonewolf'} = $lonewolves;
	$vil->{'wincnt_pixi'    } = $pixies;
	$vil->{'wincnt_dish'    } = $dishes;
	$vil->{'wincnt_love'    } = $loves;
	$vil->{'wincnt_hate'    } = $hates;
	$vil->{'wincnt_bond'    } = $bonds;
	$vil->{'wincnt_sheep'   } = $sheeps;
	$vil->{'wincnt_live'    } = $lives;
	$vil->{'wincnt_zombie'  } = $zombies;
	# �W�v�����܂�

	my $win_wolf = 0;
	my $win_vil  = 0;
	# �T�̏�������
	$win_wolf = 1 if (($vil->{'game'} eq 'TABULA')           &&($humen <= $wolves));
	$win_wolf = 1 if (($vil->{'game'} eq 'LIVE_TABULA')      &&($humen <= $wolves));
	$win_wolf = 1 if (($vil->{'game'} eq 'TROUBLE')          &&($humen <= $wolves));
	$win_wolf = 1 if (($vil->{'game'} eq 'VOV')              &&($humen <= $wolves));
	$win_wolf = 1 if (($vil->{'game'} eq 'MISTERY')          &&(0 == $villager));
	$win_wolf = 1 if (($vil->{'game'} eq 'MILLERHOLLOW')     &&(0 == $villager));
	$win_wolf = 1 if (($vil->{'game'} eq 'LIVE_MILLERHOLLOW')&&(0 == $villager));
	# ���̏�������
	$win_vil  = 1 if ( 0 == $wolves );

	if ($loves == $lives) {
		# ����Ȏ�ނ̗��l�����i���l�ȊO���S�ŁB���ꂪ�Ȃ��Ɨ��l�������s�\�ɂȂ邱�Ƃ�����B�j
		$winner = $sow->{'WINNER_LOVER'};
	} elsif ( 1 == $win_vil ) {
		# ���l������
		$winner = $sow->{'WINNER_HUMAN'};
	} elsif ( 1 == $win_wolf) {
		# �l�T������
		$winner = $sow->{'WINNER_WOLF'};
		$winner = $sow->{'WINNER_LONEWOLF'} if( $wolves == $lonewolves );
	}

	# ����������肷��A��
	# �������J�͌�ǂ�����B�׋C�ɘf�����҂�������O�B
	# ���l�������ł��Ȃ��Ȃ�\��������i�׋C��݂�Ȃ��Ǝ׋C�����ɂȂ�󋵂̉\���j
	# �̂ŁA�׋C�͎����ȊO���J�i�׋C�Ɍ��炸�j��łڂ��Ȃ��Ă͏��ĂȂ��B
	$winner = $sow->{'WINNER_PIXI_W'} if (($pixies > 0) && ($winner == $sow->{'WINNER_WOLF'}));
	$winner = $sow->{'WINNER_PIXI_W'} if (($pixies > 0) && ($winner == $sow->{'WINNER_LONEWOLF'}));
	$winner = $sow->{'WINNER_PIXI_H'} if (($pixies > 0) && ($winner == $sow->{'WINNER_HUMAN'}));
	$winner = $sow->{'WINNER_GURU'}   if (($sheeps > 0) && ($lives == $sheeps ));
	$winner = $sow->{'WINNER_HATER'}  if (($bonds == 1) && ($hates == 1) && ($winner > 0));
	$winner = $sow->{'WINNER_LOVER'}  if (($loves  > 0) && ($winner > 0));
	$winner = $sow->{'WINNER_NONE'}   if (($lives == 0));

	return $winner;
}

sub StartGM {
	my ($sow, $vil) = @_;
	my $textrs = $sow->{'textrs'};
	my $ar      = $textrs->{'ANNOUNCE_ROLE'};
	&Deployment($sow, $vil, $logfile, $score);

	# �����ɂ��܂�D�J���A�ϐg�̓s����A�Ȃɂ�����O�B
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "rolediscard".$vil->{'rolediscard'});
	my @rolediscard = split('/', $vil->{'rolediscard'});
	my $pllist  = $vil->getlivepllist();
	my $member;
	foreach $member (@$pllist) {
		if ($member->{'role'} == $sow->{'ROLEID_ROBBER'}){
			my @rolelist;
			foreach $discard (@rolediscard){
				push (@rolelist, '<b>'.$vil->getTextByID('ROLENAME',$discard).'</b>');
			}
			my $roletext = join($ar->[3], @rolelist);
			my $result = $vil->getText('RESULT_ROBBER');
			$result  =~ s/_ROLE_/$roletext/g;
			$member->addhistory($result);
		} else {
			$member->setfriends();
		}
	}

	# �����ҏ���
	my $stigma = $vil->getrolepllist($sow->{'ROLEID_STIGMA'});
	if (@$stigma > 1) {
		my $i;
		my $loopcount = @$stigma;
		for ($i = 0; $i < $loopcount; $i++) {
			my $stigmano = int(rand(@$stigma));
			my $stigmapl = splice(@$stigma, $stigmano, 1);
			$stigmapl->{'rolesubid'} = $i;
		}
	}
}

sub MidNight{
	my ($sow, $vil, $logfile, $score, $jammtargetpl) = @_;

	# �肢�E��E
	&Seer($sow, $vil, $logfile, $score, $jammtargetpl);

	# ����
	&Witch($sow, $vil, $logfile, $score, $jammtargetpl);

	# �B���p�t
	&Alchemist($sow, $vil, $logfile, $score, $jammtargetpl);
}

sub UpdateGM {
	my ($sow, $vil, $logfile) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
	my $score = SWScore->new($sow, $vil, 0);

	&Deployment($sow, $vil, $logfile, $score);

	# �ˑR�� �Ȃɂ�����O�ɏ�������B
	&SuddenDeath($sow, $vil, $logfile, $score ) if ($sow->{'cfg'}->{'ENABLED_SUDDENDEATH'} > 0);

	# �����t�F�[�Y
	&Equipment($sow, $vil, $logfile, $score );

	# ���Y
	if ($vil->{'turn'}-1 > 1){
		&Execution($sow, $vil, $logfile, $score, 1);
		&Execution($sow, $vil, $logfile, $score, 2) if ($vil->{'riot'} == $vil->{'turn'}-1 );
	}

	# �����t�F�[�Y
	&Twilight($sow, $vil, $logfile, $score ) ;

	# ��q�Ώە\��
	my $jammtargetpl = &WriteGuardTarget($sow, $vil, $logfile, $score, 'ROLEID_JAMMER','EXECUTEJAMM' );
	my $guardtargetpl= &WriteGuardTarget($sow, $vil, $logfile, $score, 'ROLEID_GUARD' ,'EXECUTEGUARD');

	# ���̊E�����E�����E���
	&ThrowGift($sow, $vil, $logfile, $score, $jammtargetpl);
	&MidNight($sow, $vil, $logfile, $score, $jammtargetpl);

	# �P���挈��
	my ($murderpl, $killers ,$killedpl ) = &SelectKill($sow, $vil, $logfile, $score, 1);
	my ($murderpl2,$killers2,$killedpl2) = &SelectKill($sow, $vil, $logfile, $score, 2) if ($vil->{'grudge'} == $vil->{'turn'}-1 );
        
	# �P�� (�ז��[���m�T�Ȃǂ��画����B�����߂�$jammtargetpl��n���B$guardtargetpl�ł͂Ȃ��B�j
	&Kill($sow, $vil, $logfile, $score, $murderpl , $killers,  $killedpl, $jammtargetpl);
	&Kill($sow, $vil, $logfile, $score, $murderpl2, $killers2, $killedpl2,$jammtargetpl) if ($vil->{'grudge'} == $vil->{'turn'}-1);
	&KillLoneWolf($sow, $vil, $logfile, $score);

	# �t���t�F�[�Y
	&Dawn($sow, $vil, $logfile, $score );
	&Snatch($sow, $vil, $logfile, $score );

	# ���S�Ҕ���
	&Regret($sow, $vil, $logfile, $score, $jammtargetpl);

	$score->write($vil->{'turn'}-1);
	$score->close();

}

sub EventReset {
	my ($sow, $vil, $logfile) = @_;
	# �����̏I��
	if ( $sow->{'EVENTID_UNDEF'} < $vil->{'event'} ){
		$vil->{'event'} = $sow->{'EVENTID_UNDEF'};
	}
}

sub EventGM {
	my ($sow, $vil, $logfile) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
	my $score = SWScore->new($sow, $vil, 0);

	# �����̂��߂̏���
	
	# ���񂾃X�P�[�v�S�[�g�͙�߂��Ȃ��B
	my $scapegoatpl = $vil->getplbypno($vil->{'scapegoat'});
	if ((0 < $vil->{'scapegoat'})&&( 'live' ne $scapegoatpl->{'live'} )) {
		my $canceltext  = $vil->getText('RESULT_SCAPEGOAT');
		my $targetname  = $scapegoatpl->getchrname();
		$canceltext =~ s/_TARGET_/$targetname/g;
		$vil->{'scapegoat'} = -1;
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $canceltext);
	}

	# �����󋵂̊J��
	if ('MISTERY' eq $vil->{'game'}){
		my $balance = 0;
		$balance = 1 if ($vil->{'wincnt_villager'} > $vil->{'wincnt_wolf'    });
		$balance = 2 if ($vil->{'wincnt_villager'} < $vil->{'wincnt_wolf'    });
		$logfile->writeinfo('', $sow->{'MESTYPE_INFOWOLF'}, $vil->getTextByID('ANNOUNCE_LEAD',$balance));
	}

	# �����̏I��
	if ( $sow->{'EVENTID_UNDEF'} < $vil->{'event'} ){
		if ($vil->{'event'} == $sow->{'EVENTID_APRIL_FOOL'}){
			my $livepllist = $vil->getlivepllist();
			my $eventname = $vil->getTextByID('EVENTNAME',$vil->{'event'});
			foreach $plsingle (@$livepllist) {
				$plsingle->{'rolechange'} = $plsingle->{'role'};
				$plsingle->{'rolechange'} = $sow->{'ROLEID_SEERROLE'} if ($plsingle->{'role'} == $sow->{'ROLEID_WITCH'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_WITCH'}    if ($plsingle->{'role'} == $sow->{'ROLEID_SEERROLE'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_GUARD'}    if ($plsingle->{'role'} == $sow->{'ROLEID_ELDER'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_ELDER'}    if ($plsingle->{'role'} == $sow->{'ROLEID_GUARD'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_HUNTER'}   if ($plsingle->{'role'} == $sow->{'ROLEID_GIRL'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_GIRL'}     if ($plsingle->{'role'} == $sow->{'ROLEID_HUNTER'});
			}
			foreach $plsingle (@$livepllist) {
				$plsingle->{'role'} = $plsingle->{'rolechange'};
				$score->addresult($eventname, $plsingle->getlongchrname());
			}
		}

		$event = $sow->{'EVENTID_UNDEF'};
		$event = $sow->{'EVENTID_NIGHTMARE'} if (($vil->{'event'} == $sow->{'EVENTID_CLAMOR'})&&('boo' eq $vil->{'content'}));
		$event = $sow->{'EVENTID_NIGHTMARE'} if (($vil->{'event'} == $sow->{'EVENTID_FIRE'}  )&&('boo' eq $vil->{'content'}));
		$vil->{'event'} = $event;
	}

	# ���̎��������I
	if ( $vil->{'event'} <= $sow->{'EVENTID_UNDEF'} ){
		my @events = split('/', $vil->{'eventcard'});
		# �C�x���g���܂��c���Ă���Ȃ�A�����B
		if ( 0 < scalar(@events) ){
			my $choice = splice(@events, int(rand(@events)), 1);
			$vil->{'eventcard'} = join('/', @events );
			$vil->{'event'} = $choice;
		}
	}

	# ���������B�\���B
	if ( $sow->{'EVENTID_UNDEF'} < $vil->{'event'} ){
		my $livepllist = $vil->getlivepllist();
		my $eventtext = $vil->getTextByID('EXPLAIN_EVENT',$vil->{'event'});
		my $eventname = $vil->getTextByID('EVENTNAME'    ,$vil->{'event'});
		if ($vil->{'event'} == $sow->{'EVENTID_APRIL_FOOL'}){
			foreach $plsingle (@$livepllist) {
				$plsingle->{'rolechange'} = $plsingle->{'role'};
				$plsingle->{'rolechange'} = $sow->{'ROLEID_SEERROLE'} if ($plsingle->{'role'} == $sow->{'ROLEID_WITCH'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_WITCH'}    if ($plsingle->{'role'} == $sow->{'ROLEID_SEERROLE'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_GUARD'}    if ($plsingle->{'role'} == $sow->{'ROLEID_ELDER'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_ELDER'}    if ($plsingle->{'role'} == $sow->{'ROLEID_GUARD'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_HUNTER'}   if ($plsingle->{'role'} == $sow->{'ROLEID_GIRL'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_GIRL'}     if ($plsingle->{'role'} == $sow->{'ROLEID_HUNTER'});
			}
			foreach $plsingle (@$livepllist) {
				$plsingle->{'role'} = $plsingle->{'rolechange'};
				$score->addresult($eventname, $plsingle->getlongchrname());
			}
		}

		if ($vil->{'event'} == $sow->{'EVENTID_ECLIPSE'}){
			&addcheckedday($vil, 'eclipse', $vil->{'turn'} );
			$score->addresult($eventname, "");
		}

		if ($vil->{'event'} == $sow->{'EVENTID_SEANCE'}){
			&addcheckedday($vil, 'seance', $vil->{'turn'} );
			$score->addresult($eventname, "");
		}

		# ��d�X�p�C�@��E�n�̉��b�ȊO�͏㏑�����B
		if ($vil->{'event'} == $sow->{'EVENTID_TURN_FINK'}){
			my @cleanpllist;
			foreach $plsingle (@$livepllist) {
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_FINK'});
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_OGRE'});
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_FAIRY'});
				next if ($plsingle->iskiller('role'));
				next if ($plsingle->isenemy());
				push(@cleanpllist,$plsingle);
			}
			# ���b�Ȃ��̐l������΁A��l�I�ԁB
			if ( 0 < scalar(@cleanpllist) ){
				my $plsingle = splice(@cleanpllist, int(rand(@cleanpllist)), 1);
				$plsingle->{'gift'} = $sow->{'GIFTID_FINK'};
				$plsingle->setfriends();
				$score->addresult($eventname, $plsingle->getlongchrname());
			}
		}

		# �d���̗ց@��E�n�̉��b�ȊO�͏㏑�����B
		if ($vil->{'event'} == $sow->{'EVENTID_TURN_FAIRY'}){
			my @cleanpllist;
			foreach $plsingle (@$livepllist) {
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_FINK'});
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_OGRE'});
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_FAIRY'});
				next if ($plsingle->iscursed('role'));
				push(@cleanpllist,$plsingle);
			}
			# ���b�Ȃ��̐l������΁A��l�I�ԁB
			if ( 0 < scalar(@cleanpllist) ){
				my $plsingle = splice(@cleanpllist, int(rand(@cleanpllist)), 1);
				$plsingle->{'gift'} = $sow->{'GIFTID_FAIRY'};
				$plsingle->setfriends();
				$score->addresult($eventname, $plsingle->getlongchrname());
			}
		}
		# ��Ձ@���̓��P���������l�������Ԃ�B�������A�\�͂������B
		if ($vil->{'event'} == $sow->{'EVENTID_MIRACLE'}){
			my $pllist = $vil->getpllist();
			foreach $plsingle (@$pllist) {
				next if ($plsingle->{'live'} ne 'victim');
				next if ($plsingle->{'deathday'} ne $vil->{'turn'});
				next if ($plsingle->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
				&heal($sow, $vil, $plsingle, $logfile);
				&toCurse($sow,$vil,$plsingle,$logfile);
				$score->addresult($eventname, $plsingle->getlongchrname());
				$plsingle->define_delay();
			}
		}

		# ����҂��đI�C����B
		if ($vil->{'event'} == $sow->{'EVENTID_PROPHECY'}){
			my @selectpllist;
			my @decidepllist;
			foreach $plsingle (@$livepllist) {
				push(@selectpllist,$plsingle) if ($plsingle->{'gift'} == $sow->{'GIFTID_NOT_HAVE'});
				push(@decidepllist,$plsingle) if ($plsingle->{'gift'} == $sow->{'GIFTID_DECIDE'});
			}
			foreach $plold (@decidepllist) {
				my $plnew = splice(@selectpllist, int(rand(@selectpllist)), 1);
				$plnew->{'gift'} = $sow->{'GIFTID_DECIDE'}   if (defined($plnew->{'gift'}));
				$plold->{'gift'} = $sow->{'GIFTID_NOT_HAVE'};
				$score->addresult($eventname, $plold->getlongchrname()." �� ".$plnew->getlongchrname() );
			}
		}
		
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $eventtext);
	}

	# �����ҕ\��
	my @livesnamelist;
	my $livepllist = $vil->getlivepllist();
	my $livescnt = @$livepllist;
	foreach $plsingle (@$livepllist) {
		push(@livesnamelist, $plsingle->getchrname());
	}
	my $livesnametext = join($vil->getTextByID('ANNOUNCE_LIVES',1), @livesnamelist);
	my $livesnametextend = $vil->getTextByID('ANNOUNCE_LIVES',2);
	$livesnametextend =~ s/_LIVES_/$livescnt/g;
	$livesnametext = $vil->getTextByID('ANNOUNCE_LIVES',0) . $livesnametext . $livesnametextend;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $livesnametext);

	$score->write($vil->{'turn'}-1);
	$score->close();
}

sub addcheckedday {
	my ($self,$target,$turn) = @_;
	my @list = split('/', $self->{$target});
	push( @list, $turn );
	$self->{$target} = join('/', @list );
}

# �Ώۂ����̗ւ�ێ����A���������ƁA���\�A�̏ꍇ�͌��̗ւ�n���Ȃ��B
sub breakGift {
	my ($sow,$vil,$logfile,$targetpl,$giftname) = @_;
	my $result = $targetpl->getText('EXECUTELOST');
	$result =~ s/_NAME_/$targetname/g;
	$result =~ s/_GIFT_/$giftname/g;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFOSP'}, $result);
}

sub breakGiftCheck {
	my ($sow,$vil,$plsingle,$logfile) = @_;

	# ���蕨������Δj�󂷂�B
	my $has_gift = 0;
	$has_gift = $plsingle->{'gift'} if ($plsingle->{'gift'} == $sow->{'GIFTID_SHIELD'});
	$has_gift = $plsingle->{'gift'} if ($plsingle->{'gift'} == $sow->{'GIFTID_GLASS' });
	if ( $has_gift ){
		my $giftname   = $vil->getTextByID('GIFTNAME',$has_gift);
		&breakGift($sow,$vil,$logfile,$plsingle,$giftname);
	}
}

sub toCurse {
	my ($sow,$vil,$plsingle,$logfile) = @_;
	$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_CURSED'};

	&breakGiftCheck($sow,$vil,$plsingle,$logfile);
}

sub toZombie {
	my ($sow,$vil,$plsingle,$logfile) = @_;
	$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ZOMBIE'};

	&breakGiftCheck($sow,$vil,$plsingle,$logfile);
}

# ���ʉ�����
sub Deployment{
	my ($sow, $vil, $logfile, $score) = @_;

	# �X�P�[�v�S�[�g�͓��[����ɉe������݂̂Ȃ̂ŁA�X�V������������Z�b�g���Ă悢�B
	$vil->{'scapegoat'} = $sow->{'TARGETID_TRUST'};

	my $pllist = $vil->getpllist();
	foreach $plsingle (@$pllist) {
		# ���S�x���A��Ԓx���T�|�[�g�B
		# �^�C�~���O�𐮗����A���돇���^��r������B
		$plsingle->{'delay_rolestate'} = $plsingle->{'rolestate'};
		$plsingle->{'delay_live'}      = $plsingle->{'live'};
		# �ꎞ�I��ԁi���̖�̂ݗL���ȓ��e�j�������ŏ������B
		$plsingle->{'tmp_rolestate'} = $plsingle->{'rolestate'};
		$plsingle->{'tmp_suicide'}   = $sow->{'TARGETID_TRUST'};
	}
}

# �\�͂��g���l�̂��߂̏���
sub Equipment{
	my ($sow, $vil, $logfile, $score) = @_;

	# �\�͑Ώۃ����_���w�莞����
	# ����҂̔\�͍s�g�O�ł��邱��
	&SetRandomTarget($sow, $vil, $logfile, 'role','ABI_ROLE');
	&SetRandomTarget($sow, $vil, $logfile, 'gift','ABI_GIFT');

	my $pllist = $vil->getpllist();
	foreach $plsingle (@$pllist) {
		next if ( $plsingle->{'live'} ne 'live' ); # ���҂͏������Ȃ��B
		my $chrname  = $plsingle->getchrname();
		if    ($plsingle->isdo('role1')){
			# �N���̂Ƃ���ցB
			my $targetpl = $vil->getplbypno($plsingle->{'role1'});
			my $targetname = $targetpl->getchrname();
			# �����̓���
			# �g����̎�ނ́A���쎞�ɒN��ΏۂɑI��ł��邩�A�Ō��܂�B���̎��_�̐�����ۑ�����B
			# �i�������A�ˑR���͓��򎞂ɃL�����Z������B�j
			if ( $plsingle->iscanrole($sow->{'ROLEID_WITCH'}) ){
				$plsingle->{'tmp_targetlive'} = $targetpl->{'live'};
				$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "target is " . $plsingle->{'tmp_targetlive'} );
			}
		}elsif($plsingle->{'role1'} == $plsingle->{'pno'}){
			# �Ƃ�ɂȂ�
		}else{
			# ���܂���
		}
	}
}



#----------------------------------------
# �ˑR������
#----------------------------------------
sub SuddenDeath {
	my ($sow, $vil, $logfile, $score ) = @_;
	return if ($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'});
	return if ($vil->{'event'} == $sow->{'EVENTID_ESCAPE'});
	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	my $livepllist = $vil->getlivepllist();
	foreach $plsingle (@$livepllist) {
		next if ($plsingle->{'saidcount'} > 0); # �������Ă���Ώ��O
		&nowdead($sow, $vil, 0, $plsingle, 'suddendead',$logfile, $score, 0);

		# �ˑR�����b�Z�[�W�o��
		my $mes = $plsingle->getText('SUDDENDEATH');
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $mes);
	}
}

#----------------------------------------
# ���Y����
#----------------------------------------
sub Execution {
	my ($sow, $vil, $logfile, $score, $no) = @_;
	my $history;
	my $livepllist = $vil->getlivepllist();
	my $allpllist  = $vil->getallpllist();
	my $votablepl  = $vil->getvotablepl();
	my $vote = 'vote'.$no;
	my $gift = 'gift'.$no;
	my $entrust = 'temp_entrust'.$no;

	# ���[���̏�����
	my @votes;
	my $i;
	for ($i = 0; $i < @$allpllist; $i++) {
		$votes[$i] = 0;
	}

	# �ˑR���D�擊�[�����i�������j

	# ���[�w���𕡐��B�����g�p
	foreach $plsingle (@$allpllist) {
		$plsingle->{$entrust} = $plsingle->{'entrust'};
		next unless ( $plsingle->isvoter() );

		# �����_���ϔC
		$plsingle->{'randomentrust'} = '';
		if (($plsingle->{$entrust} > 0) && ($plsingle->{$vote} == $sow->{'TARGETID_RANDOM'})) {
			$plsingle->{$vote} = $livepllist->[rand(@$livepllist - 1)]->{'pno'};
			$plsingle->{$vote} = $livepllist->[$#$livepllist]->{'pno'} if ($plsingle->{$vote} == $plsingle->{'pno'});
			$plsingle->{'randomentrust'} = $vil->getText('RANDOMENTRUST');
		}
	}

	# �ϔC���[����
	my $curpl;
	foreach $curpl (@$allpllist) {
		next unless ( $curpl->isvoter() );
		my @entrusts;
		my $srcpl = $curpl;
		$i = 0;
		
		# �ϔC�w���̐l��������ϔC������B
		# �܂��A�����_�����[�̐l��؂蕪���B
		while ($srcpl->{$entrust} > 0) {
			# ���[�𑼐l�ɈϔC���Ă���l��z��ɒǉ�
			push(@entrusts, $srcpl);
			$i++;
			$srcpl = $vil->getplbypno($srcpl->{$vote});
			if (($i > $votablepl) || ($srcpl->{'live'} ne 'live')) {
				# �ϔC���[�v�ɓ����Ă��鎞
				# �i���͈ϔC�悪���҂̎��j
				foreach $plentrust (@entrusts) {
					next if ($plentrust->{$entrust} <= 0);

					# ���[��������_���ɐݒ�
					my $entrusttext = $plentrust->getTextByID('ANNOUNCE_ENTRUST',1);
					my $targetpl = $vil->getplbypno($plentrust->{$vote});
					my $targetname = $targetpl->getchrname();
					$entrusttext =~ s/_TARGET_/$targetname/g;
					$entrusttext =~ s/_RANDOM_/$plentrust->{'randomentrust'}/g;
					$logfile->writeinfo($plentrust->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $entrusttext);
					$plentrust->{$vote} = $sow->{'TARGETID_TRUST'};
					$plentrust->{$entrust} = -1;
				}
				@entrusts = ();
				last;
			}
		}

		if (@entrusts > 0) {
			# �ϔC���Ă��鎞
			my $entrust;
			my $targetname = $srcpl->getchrname();
			for ($i = 0; $i < @entrusts; $i++) {
				#	�ϔC����Q�Ƃ��āA���[�֕ύX�B
				$entrusts[$i]->{$vote} = $srcpl->{$vote};
				$entrusts[$i]->{$entrust} = 0;

				my $randomvote = 0;
				if (($entrusts[$i]->{$vote} == $entrusts[$i]->{'pno'}) || ($srcpl->{$entrust} < 0)) {
					# �����_�����[
					$randomvote = 1;
					$entrusts[$i]->{$vote} = -1;
				}

				# �ϔC���b�Z�[�W�\��
				my $entrusttext = $entrusts[$i]->getTextByID('ANNOUNCE_ENTRUST',$randomvote);
				$entrusttext =~ s/_TARGET_/$targetname/g;
				$entrusttext =~ s/_RANDOM_/$entrusts[$i]->{'randomentrust'}/g;
				$logfile->writeinfo($entrusts[$i]->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $entrusttext);
			}
			next;
		}

	}

	# ���[���ʏW�v���\��
	my $votestext;
	foreach $plvote (@$allpllist) {
		if ( $plvote->isvoter() ){
			my $randomvote = '';
			if ($plvote->{$vote} < 0) {
				$plvote->{$vote} = $livepllist->[rand(@$livepllist - 1)]->{'pno'};
				if ($plvote->{$vote} == $plvote->{'pno'}) {
					$plvote->{$vote} = $livepllist->[$#$livepllist]->{'pno'};
				}
				$randomvote = $vil->getText('ANNOUNCE_RANDOMVOTE');
			}
			$votes[$plvote->{$vote}]++;

			# �e���[����
			my $votedpl   = $vil->getplbypno($plvote->{$vote});
			my $votedname = $votedpl->getlongchrname();

			my $votetext = $plvote->getTextByID('ANNOUNCE_VOTE',0);
			$votetext    =~ s/_TARGET_/$votedname/g;
			$votetext    =~ s/_RANDOM_/$randomvote/g;
			$votestext  .=  "$votetext<br>" if ($vil->{'votetype'} eq 'sign');

			# $plvote->addhistory($votetext);
			$logfile->writeinfo($plvote->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $votetext) if ($vil->{'votetype'} ne 'sign');
		}

		next if ( $plvote->{'live'} ne 'live');
		# ����҂̔\�͓͂��[�ɔ��f�B�����_�������͂��̎�O�ōς�ł���B�͂��B
		if ( $plvote->iscangift($sow->{'GIFTID_DECIDE'}) ){
			next if ($plvote->{$gift} < 0);
			$votes[$plvote->{$gift}]++;

			$votedpl = $vil->getplbypno($plvote->{$gift});
			$votedname = $votedpl->getlongchrname();

			$votetext = $plvote->getTextByID('ANNOUNCE_VOTE',0);
			$votetext =~ s/_TARGET_/$votedname/g;
			$votetext =~ s/_RANDOM_//g;
			$votestext = $votestext . "$votetext<br>" if ($vil->{'votetype'} eq 'sign');
	
			$plvote->addhistory($votetext);
			$logfile->writeinfo($plvote->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $votetext) if ($vil->{'votetype'} ne 'sign');
		}

	}

	# ���L�����[�̓��[���ʕ\��
	for ($i = 0; $i < @votes; $i++) {
		next if ($votes[$i] == 0);

		my $targetpl = $vil->getplbypno($i);
		my $votetext = $targetpl->getTextByID('ANNOUNCE_VOTE',1);
		$votetext =~ s/_COUNT_/$votes[$i]/g;

		$votestext = $votestext . "$votetext<br>" if ($vil->{'votetype'} ne 'sign');
	}

	# ���ʂ͌��邪�A���[�𖳎�����i��������Ȃ��j�B
	if (($vil->{'event'} == $sow->{'EVENTID_COINTOSS'})&&(1 == int(rand(2)))) {
		my $chrname  = $vil->getTextByID('EVENTNAME',$sow->{'EVENTID_COINTOSS'});
		my $votetext = $vil->getText('CANCELTARGET');

		$votetext    =~ s/_NAME_/$chrname/g;
		$votetext    =~ s/_ABILITY_/���Y/g;
		# ���[���ʂ̏o��
		$votestext = $votestext . "<br>$votetext<br>";
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $votestext);
		return;
	}

	# �ő哾�[���̃`�F�b�N
	my $maxvote = 0;
	for ($i = 0; $i < @votes; $i++) {
		$maxvote = $votes[$i] if ($maxvote < $votes[$i]);
	}

	return if ($maxvote == 0); # ���Y��₪���Ȃ��i�S���ˑR���H�j

	# �ő哾�[�҂̎擾
	my @lastvote;
	for ($i = 0; $i < @votes; $i++) {
		push(@lastvote,      $i) if  ($votes[$i] == $maxvote);
	}

	return if (@lastvote == 0); # ���Y��₪���Ȃ��i�S���ˑR���H�j

	# �X�P�[�v�S�[�g�v��
	my @scapegoat;
	foreach $pl (@$livepllist) {
		push(@scapegoat, $pl) if ( $pl->isbindrole($sow->{'ROLEID_SCAPEGOAT'}) );
	}

	# ���Y�Ώۂ̌���
	my $executepl;
	my $executetype = 'execute';
	if (@lastvote > 1){
		if (@scapegoat > 0){
			# �X�P�[�v�S�[�g������̂ŁA�X�P�[�v�S�[�g���Y�B
			# �X�P�[�v�S�[�g���^���҂�����Ȃ�A�t���O�𗧂Ă�B
			$executepl   = $scapegoat[int(rand(@scapegoat))];
			$executetype = 'scapegoat' if (($executepl->isEnableState('MASKSTATE_ABI_ROLE'))&&( -1 < $executepl->{'role1'}));
		} else {
			# �^�u���̏ꍇ�A�����_�����Y
			# �u�[�����̖�v�̏ꍇ�A�����_�����Y
			# �~���[�Y�z���E�̏ꍇ�A����߁B
			$executepl   = $vil->getplbypno( $lastvote[int(rand(@lastvote))] );
			$executetype = 'abort' if ($vil->{'game'} eq 'MILLERHOLLOW');
			$executetype = 'abort' if ($vil->{'game'} eq 'LIVE_MILLERHOLLOW');
		}
	} else {
		# ���Y��₪�Ƃ�Ȃ̂ŁA�l�X�Ə��Y�B
		$executepl = $vil->getplbypno($lastvote[0]);
	}
	
	my $chrname;
	my $votetext;
	if ($executetype eq 'abort') {
		# ���Y������߂�i�~���[�Y�z���E�j
		$chrname  = scalar(@lastvote).'��';
		$votetext = $vil->getTextByID('ANNOUNCE_VOTE',3);
	} elsif ($executepl->{'live'} eq 'live') {
		# ���Y�����{����B
		$chrname = $executepl->getchrname();
		$score->addresult($executetype,$chrname );
		if ($vil->{'event'} == $sow->{'EVENTID_ESCAPE'}){
			# ���Y�ł͂Ȃ��A�����B
		} elsif ( $executepl->iscanrole($sow->{'ROLEID_PRINCE'}) ){
			# ���q�l�͋��ꑽ������x�������Y����Ȃ��B
			my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_PRINCE'});
			$score->addresult($scorehead,$chrname );

			$votetext = $vil->getTextByID('ANNOUNCE_VOTE',3);
			$executepl->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_NOROLE'};
		} else {
			if ($executetype eq 'scapegoat'){
				# ���̃X�P�[�v�S�[�g���w����
				$votetext = $vil->getTextByID('ANNOUNCE_VOTE',4);
				my $targetpl = $vil->getplbypno($executepl->{'role1'});
				my $targetname = $targetpl->getchrname();
				$votetext =~ s/_TARGET_/$targetname/g;
				$vil->{'scapegoat'} = $targetpl->{'pno'};

				my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_SCAPEGOAT'});
				$score->addresult($scorehead,$targetname );
			} else {
				$votetext = $vil->getTextByID('ANNOUNCE_VOTE',2);
			}
			&nowdead($sow, $vil, 0, $executepl, 'executed',$logfile, $score, 0);
		}
	}

	$votetext  =~ s/_NAME_/$chrname/g;
	$votestext .= "<br>$votetext";
	# ���[���ʂ̏o��
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $votestext);
}

sub ShootLink {
	my ($sow, $vil, $logfile, $score, $plsingle, $roleid ) = @_;

	# ���Y�d���i�K���łj
	if ( $plsingle->{'role'} == $roleid ){
		return if (($plsingle->{'role1'} < 0)&&($plsingle->{'role2'} < 0)); # ���܂����͏��O
		# �J�̒ǉ�
		# �A�d11 �J�̖��O���Ȃ��i$chrname���錾�j
		my $targetpl  = $vil->getplbypno($plsingle->{'role1'});
		my $target2pl = $vil->getplbypno($plsingle->{'role2'});
		my $message   = '';

		if ($targetpl->{'live'} ne 'live') {
			# �ݒ�ΏۂP���ˑR�����Ă��鎞
			my $srctargetpno;
			$srctargetpno = $plsingle->{'role2'} if (($plsingle->{'role2'} >= 0) && ($target2pl->{'live'} eq 'live'));
			$targetpl  = $plsingle->setRandomTarget('role',1, 'ABI_ROLE',$logfile, $srctargetpno);
		}

		if ($target2pl->{'live'} ne 'live') {
			# �ݒ�ΏۂQ���ˑR�����Ă��鎞
			$target2pl = $plsingle->setRandomTarget('role',2, 'ABI_ROLE',$logfile, $plsingle->{'role1'});
		}

		if (($plsingle->{'role1'} < 0) || ($plsingle->{'role2'} < 0)) {
			# �Ώی�₪���݂��Ȃ�
			my $ability = $vil->getTextByID('ABI_ROLE',$plsingle->{'role'});
			my $canceltarget = $plsingle->getText('CANCELTARGET');
			$canceltarget =~ s/_ABILITY_/$ability/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $canceltarget);
			return;
		}

		if($plsingle->{'role'} == $sow->{'ROLEID_BITCH'}){
			$plsingle->{'love'} = 'love';
			$plsingle->addbond($plsingle->{'role1'});
			$plsingle ->addpseudobond($plsingle->{'role2'});
			$targetpl->{'love'} = 'love';
			$targetpl->addbond($plsingle->{'pno'});
			$target2pl->{'pseudolove'} = 'love';
			$target2pl->addpseudobond($plsingle->{'pno'});
			$message = 'BITCH';
		} else {
			$target2pl->addbond($plsingle->{'role1'});
			$targetpl->addbond($plsingle->{'role2'});
			$message = 'TRICKSTER';
			if($plsingle->{'role'} == $sow->{'ROLEID_LOVEANGEL'}){
				$targetpl->{'love'} = 'love';
				$target2pl->{'love'} = 'love';
			}
			if($plsingle->{'role'} == $sow->{'ROLEID_HATEDEVIL'}){
				$targetpl->{'love'} = 'hate';
				$target2pl->{'love'} = 'hate';
			}
		}

		my $result = $plsingle->getText('EXECUTE'.$message);
		my $targetname = $targetpl->getchrname();
		my $target2name = $target2pl->getchrname();
		$result =~ s/_TARGET1_/$targetname/g;
		$result =~ s/_TARGET2_/$target2name/g;
		$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
		$result = $vil->getText('RESULT_'.$message);
		$result =~ s/_TARGET1_/$targetname/g;
		$result =~ s/_TARGET2_/$target2name/g;
		$plsingle->addhistory($result);

		my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_TRICKSTER'});
		$score->addresult($scorehead,$targetname );
		$score->addresult($scorehead,$target2name );
	}
}

sub Twilight {
	my ($sow, $vil, $logfile, $score ) = @_;

	my $livepllist = $vil->getlivepllist();
	my $pllist     = $vil->getpllist();

	foreach $plsingle (@$livepllist) {
		next if ($plsingle->issensible());
		if     ($plsingle->{'role1'} == $plsingle->{'pno'}){
			# �Ƃ�ɂȂ�
			my $execute = $plsingle->getText('EXECUTEALONE');
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $execute);
		} elsif($plsingle->isdo('role1')) {
			# �N���̂Ƃ���ցB
			my $targetpl = $vil->getplbypno($plsingle->{'role1'});
			my $targetname = $targetpl->getchrname();
			my $execute = $plsingle->getText('EXECUTEGOTO');
			$execute =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $execute);
		} else {
			# ���܂���
		}
	}

	# �����͂��܂�D�ɕϐg���邽�߁A��������O�Ɉ����B
	foreach $plsingle (@$livepllist) {
		my $chrname  = $plsingle->getchrname();
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		
		# �����̕ϐg�i�K���ϐg����j
		if ($plsingle->{'role'} == $sow->{'ROLEID_ROBBER'}){
			my @rolediscard = split('/', $vil->{'rolediscard'});
			do {
				my $choice = splice(@rolediscard, int(rand(@rolediscard)), 1);
				# �����������������ꍇ�A������x�i�����͗]��Ȃ��̂ŁA���肦�Ȃ��j
				next if ($choice == $sow->{'ROLEID_ROBBER'});
				$plsingle->{'role'} = $choice;
				# �I���ɂ���ď������I����Ă��܂��A�J�[�h���c���Ă���Ȃ�����Ȃ����B
			} while ((0 < scalar(@rolediscard))&&(0 < &WinnerCheckGM($sow,$vil)));
			@rolediscard = split('/', $vil->{'rolediscard'});
			# ���ۂɑI�񂾃J�[�h���ꖇ�����B
			my $count;
			for ($count = scalar(@rolediscard)-1; ( $count >= 0 )&&($plsingle->{'role'} != $rolediscard[$count] ); $count--){}
			splice(@rolediscard, $count, 1);
			$vil->{'rolediscard'} = join('/', @rolediscard );

			# �����_���Ŕ\�͍s�g
			$plsingle->setRandomTarget('role',1, 'ABI_ROLE',$logfile, -1);
			$plsingle->setRandomTarget('role',2, 'ABI_ROLE',$logfile, $plsingle->{'role1'});
			$plsingle->setfriends();

			my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_ROBBER'});
			my $scorebody = $vil->getTextByID('ROLENAME',$plsingle->{'role'});
			$score->addresult($scorehead,$scorebody );
		}
	}

	# �i�[�����j���l���m�����݂��Ɍ������ƁA���Ђ����ԁB
	# ��������{�c�ɂ���B
	if ($vil->{'game'} eq '--MISTERY--'){
		foreach $pl1 (@$livepllist) {
			next if ($pl1->{'role1'} < 1);
			next if ($pl1->{'role1'} < 1);
			my $pl2 = $vil->getplbypno($pl1->{'role1'});
			next if ($pl1->{'pno'}  != $pl2->{'role1'});
			next if ($pl1->{'pno'}  == $pl2->{'pno'});
			next if ($pl1->{'role'} != $sow->{'ROLEID_VILLAGER'});
			next if ($pl2->{'role'} != $sow->{'ROLEID_VILLAGER'});

			# ���Љ������I
			$pl1->{'role'} = $sow->{'ROLEID_FM'};
			$pl2->{'role'} = $sow->{'ROLEID_FM'};
			$pl1->setfriends();
			$pl2->setfriends();
		}
	}
	
	# ����ɂ͘A�������邽�߁A��������Ɉ����B
	foreach $plsingle (@$livepllist) {
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		
		# ����i�K�����傷��j�B
		if ($plsingle->{'role'} == $sow->{'ROLEID_LOVER'}){
			$targetpl->addbond($plsingle->{'pno'});
			$plsingle->addbond($plsingle->{'role1'});
			my $targetname = $targetpl->getchrname();
			# �J�����񂾕\��
			my $result = $plsingle->getText('EXECUTELOVER');
			$result =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
			# ����
			$result = $vil->getText('RESULT_LOVER');
			$result =~ s/_TARGET_/$targetname/g;
			$plsingle->addhistory($result);

			$result = $plsingle->getText('RESULT_LOVEE');
			$targetpl->addhistory($result);
			# �ϐg�̉����B��q����q���w���Ă���ꍇ�A���̐��H��B
			my $loopcount = 0;
			do {
				$plsingle->{'role'} = $targetpl->{'role'};

				$loopcount++;
				if ($loopcount < @$livepllist) {
					# �ʏ�́A�I���̑I���ɒ���
					$targetpl = $vil->getplbypno($targetpl->{'role1'});
				} else {
					# ���[�v�ɓ����Ă鎞�̓����_���ɐݒ�
					$targetpl = $livepllist->[int(rand(@$livepllist))];
				}
			} while ($plsingle->{'role'} == $sow->{'ROLEID_LOVER'});

			# �����_���Ŕ\�͍s�g
			$plsingle->setRandomTarget('role',1, 'ABI_ROLE',$logfile, -1);
			$plsingle->setRandomTarget('role',2, 'ABI_ROLE',$logfile, $plsingle->{'role1'});
			$plsingle->setfriends();

			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_LOVER'});
			$score->addresult($scorehead,$targetname );
		}
	}
	foreach $plsingle (@$livepllist) {
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		
		# �����̖�V��
		if ( $plsingle->iscanrole($sow->{'ROLEID_GIRL'}) ){
			next if ( $plsingle->{'role1'} != $plsingle->{'pno'} ); # �Ƃ�ɂȂ�Ȃ��Ƃ���

			&addcheckedday($plsingle, 'overhear', $vil->{'turn'} - 1 );
			# ��V�ѕ\��
			my $result = $plsingle->getText('EXECUTEGIRL');
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_GIRL'});
			$score->addresult($scorehead,$chrname );
		}

		# �蕉���̐l���͎��ʁB
		if ( $plsingle->ishurtrole($sow->{'ROLEID_WEREDOG'}) ) {
			&dead($sow, $vil, 0, $plsingle,'victim', $logfile, $score, 0);
		}

		# �J����
		if ( $plsingle->iscanrole($sow->{'ROLEID_GURU'}) ){
			next if (($plsingle->{'role1'} < 0)&&($plsingle->{'role2'} < 0)); # ���܂����͏��O
			my $targetname = '';

			if ( -1 < $plsingle->{'role1'}){
				$targetname = '<b>'.$targetpl->getchrname().'</b>';
				$targetpl->{'sheep'}  = 'pixi';
			}
			if ( -1 < $plsingle->{'role2'}) {
				my $target2pl = $vil->getplbypno($plsingle->{'role2'});
				my $target2name = '<b>'.$target2pl->getchrname().'</b>';
				$targetname .= '��' if ($targetname ne '');
				$targetname .= $target2name;
				$target2pl->{'sheep'} = 'pixi';
			}

			next if ($targetname eq '');
			my $result = $plsingle->getText('EXECUTEGURU');
			$result =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
			$result = $vil->getText('RESULT_GURU');
			$result =~ s/_TARGET_/$targetname/g;
			$plsingle->addhistory($result);

			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_GURU'});
			$score->addresult($scorehead,$targetname );
		}
	}

	# ���Y�d���i�K���łj
	foreach $plsingle (@$livepllist) {
		&ShootLink($sow, $vil, $logfile, $score, $plsingle, $sow->{'ROLEID_TRICKSTER'} );
	}
	# �׋C�����i�K���łj
	foreach $plsingle (@$livepllist) {
		&ShootLink($sow, $vil, $logfile, $score, $plsingle, $sow->{'ROLEID_HATEDEVIL'} );
	}
	# �����V�g�i�K���łj
	foreach $plsingle (@$livepllist) {
		&ShootLink($sow, $vil, $logfile, $score, $plsingle, $sow->{'ROLEID_LOVEANGEL'} );
	}
	# �����i�K���łj
	foreach $plsingle (@$livepllist) {
		&ShootLink($sow, $vil, $logfile, $score, $plsingle, $sow->{'ROLEID_BITCH'}     );
	}
	# �Бz��
	foreach $plsingle (@$livepllist) {
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		
		if ($plsingle->{'role'} == $sow->{'ROLEID_PASSION'}){
			next if (1 != $plsingle->isdo('role1')); # ���܂����͏��O
			$targetpl->addbond($plsingle->{'pno'});
			$plsingle->{'love'} = 'love';

			my $targetname = $targetpl->getchrname();
			# �J�����񂾕\��
			my $result = $plsingle->getText('EXECUTELOVER');
			$result =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);

			$result = $vil->getText('RESULT_LOVER');
			$result =~ s/_TARGET_/$targetname/g;
			$plsingle->addhistory($result);

			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_LOVER'});
			$score->addresult($scorehead,$targetname );
		}
	}
}

sub ThrowGift {
	my ($sow, $vil, $logfile, $score, $jammed) = @_;
	my $livepllist = $vil->getlivepllist();
	my $pllist     = $vil->getpllist();
	foreach $plsingle (@$livepllist) {
		next if (1 != $plsingle->isdo('gift1')); # ���܂����͏��O
		my $targetpl = $vil->getplbypno($plsingle->{'gift1'});
		
		# ���蕨���Ȃ���i�K���j
		my $throw_gift = 0;
		$throw_gift = $plsingle->{'gift'} if ($plsingle->{'gift'} == $sow->{'GIFTID_SHIELD'});
		$throw_gift = $plsingle->{'gift'} if ($plsingle->{'gift'} == $sow->{'GIFTID_GLASS' });
		if ( 0 < $throw_gift ){
			$plsingle->{'gift'} = $sow->{'GIFTID_LOST'};

			my $result     = $plsingle->getText('EXECUTETHROW');
			my $targetname = $targetpl->getchrname();
			my $giftname   = $vil->getTextByID('GIFTNAME',$throw_gift);
			$result =~ s/_TARGET_/$targetname/g;
			$result =~ s/_GIFT_/$giftname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
			$result = $vil->getText('RESULT_THROW');
			$result =~ s/_TARGET_/$targetname/g;
			$result =~ s/_GIFT_/$giftname/g;

			my $scorehead = $vil->getTextByID('ABI_GIFT',$throw_gift);
			$score->addresult($scorehead,$targetname );

			# �j�󂷂邩�ǂ�����₤�O�ɏ������A���������^��r����B
			# ������n���Ƃ��́A�肢���ʂ𓾂�B
			if ($throw_gift == $sow->{'GIFTID_GLASS' } ){
				my $seerresultrole = GetResultSeer($sow, $vil, $score, $targetpl, $jammed);
				&SeerEffect($sow, $vil, $plsingle, $targetpl, $result.$seerresultrole, $logfile, $score, $jammed);
			} else {
				$plsingle->addhistory($result); 
			}

			# �Ώۂ����蕨��ێ����A���������ƁA���\�A�̏ꍇ�͑��蕨���󂷁B
			my $target_gift = 0;
			$target_gift = 1 if($targetpl->isDisableState('MASKSTATE_ABI_GIFT'));
			$target_gift = $targetpl->{'gift'} if($targetpl->{'gift'} == $sow->{'GIFTID_SHIELD'});
			$target_gift = $targetpl->{'gift'} if($targetpl->{'gift'} == $sow->{'GIFTID_GLASS' });
			$target_gift = $targetpl->{'gift'} if($targetpl->{'gift'} == $sow->{'GIFTID_LOST'  });
			if ( 0 < $target_gift ){
				&breakGift($sow,$vil,$logfile,$targetpl,$giftname);
				next;
			}
			
			$targetpl->{'gift_tmp'} = $throw_gift;
		}
	}
	# ���̗ւ��󂯎��
	foreach $plsingle (@$livepllist) {
		$plsingle->{'gift'} = $sow->{'GIFTID_SHIELD'} if ($plsingle->{'gift_tmp'} == $sow->{'GIFTID_SHIELD'});
		$plsingle->{'gift'} = $sow->{'GIFTID_GLASS' } if ($plsingle->{'gift_tmp'} == $sow->{'GIFTID_GLASS' });
		$plsingle->{'gift_tmp'} = 0;
	}
}

sub SelectKill {
	my ($sow, $vil, $logfile, $score, $no) = @_;

	my $pllist = $vil->getpllist();
	my $livepllist = $vil->getlivepllist();
	my $targetpl; # �P���Ώ�

	# ���[���̏�����
	my @votes;
	my $i;
	for ($i = 0; $i < @$pllist; $i++) {
		$votes[$i] = 0;
	}

	# �P����W�v �P���t�H�[���̐����������Ȃ��B
	my @cmdlist = ('role','gift');
	foreach $cmd (@cmdlist) {
		foreach $plsingle (@$livepllist) {
			next unless ( $plsingle->iskiller($cmd) );
			my $target = $cmd.$no;
			$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "KillTarget: $plsingle->{'uid'}($plsingle->{'pno'})=$plsingle->{$target}");

			next unless ($plsingle->isdo($target)); # ���܂����͏��O
			my $targetpl   = $vil->getplbypno($plsingle->{$target});
			# �����́A�l�T�ɂЂƂɂ�݂���邾���Ŏ���
			if (($targetpl->{'live'} eq 'live') && ($targetpl->isbindrole($sow->{'ROLEID_GIRL'})) ) {
				if ($targetpl->{'role1'} != $sow->{'TARGETID_TRUST'}){
					&dead($sow, $vil, $plsingle, $targetpl, 'feared', $logfile, $score, 0);

					my $result = $targetpl->getText('EXECUTEGIRLFEAR');
					$logfile->writeinfo('', $sow->{'MESTYPE_INFOSP'}, $result);
					next;
				}
			}
			$votes[$plsingle->{$target}] += 1;
			# �[�����̖�i�ƁA�����ς炢�j�́A�_����ƕs�R�Ȑl�e������B
			if (! $targetpl->issensible()){
				my $murdername = $plsingle->getchrname();
				my $votetext = $vil->getText('RESULT_ENCOUNT');
				$votetext =~ s/_TARGET_/$murdername/g;
				$targetpl->addhistory($votetext);
			}
		}
	}

	# �ő哾�[���̃`�F�b�N
	my $murderpl;
	my $maxvote = 0;
	for ($i = 0; $i < @votes; $i++) {
		$maxvote = $votes[$i] if ($maxvote < $votes[$i]);

		# ���L�����[���ɓ��[���ʏW�v
		next if ($votes[$i] == 0);
		next if ($vil->{'game'} ne 'TROUBLE');
		my $targetpl = $vil->getplbypno($i);
		my $votetext = $targetpl->getTextByID('ANNOUNCE_SELECTKILL',1);
		$votetext =~ s/_COUNT_/$votes[$i]/g;

		$logfile->writeinfo($targetpl->{'uid'}, $sow->{'MESTYPE_INFOWOLF'}, $votetext);
	}

	if ($maxvote > 0) { # �S�����C���łȂ��ꍇ
		# �P������̎擾
		my @lastvote;
		for ($i = 0; $i < @votes; $i++) {
			push(@lastvote, $i) if ($votes[$i] == $maxvote);
		}
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "KillTarget(All): @lastvote");

		# �P���Ώۂ̌���
		my $killtarget = $lastvote[int(rand(@lastvote))];
		$targetpl = $vil->getplbypno($killtarget);
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "Final KillTarget: $targetname");

		# �P���Ҍ��� ���[�t�H�[���̐������Q������
		my @murders;
		my @cmdlist = ('role','gift');
		foreach $cmd (@cmdlist) {
			foreach $plsingle (@$livepllist) {
				next if ( 0 == $plsingle->iskiller($cmd) );
				my $target = $cmd.$no;
				next if ($plsingle->{$target} != $killtarget); # �P������҂ɓ��[���Ă��Ȃ��҂͏��O
				push(@murders, $plsingle);
			}
		}
		$murderpl = $murders[int(rand(@murders))];

		# �����҂ɂ��З͒ǉ� ���Ԃ�A�s�v�B
#		foreach $plsingle (@$livepllist) {
#			$maxvote ++ if ( $self->isDisableState('MASKSTATE_ZOMBIE') );
#		}

		# �P�����b�Z�[�W����
		if (($vil->{'turn'}-1 > 1) && ($targetpl->{'live'} eq 'live')) {
			# �_�~�[�L�����P�����͏��O����

			# �P�����b�Z�[�W
			my $targetname = $targetpl->getchrname();

			if (!defined($murderpl->{'uid'})) {
				# �P���҂�����`�i���肦�Ȃ��͂��j
				$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, "murderpl is undef.");
			} elsif ($vil->{'game'} eq 'TROUBLE'){
				# ���L�����[���ɓ��[���ʕ\��
				my $votetext = $targetpl->getTextByID('ANNOUNCE_SELECTKILL',2);
				# ���[���ʂ̏o��
				$logfile->writeinfo($targetpl->{'uid'}, $sow->{'MESTYPE_INFOWOLF'}, $votetext);
			} else {
				# �P�����b�Z�[�W��������
				&postKillMessage($murderpl,$targetname,$logfile,'MESTYPE_WSAY');
			}
		}
		my $scorehead = $vil->getTextByID('ABI_ROLE',$murderpl->{'role'});
		$score->addresult($scorehead,$targetname );
	}

	return $murderpl,$maxvote,$targetpl;
}

sub WriteGuardTarget {
	my ($sow, $vil, $logfile, $score, $rolename, $execute) = @_;
	my $livepllist = $vil->getlivepllist();
	my @guardtargetpl;
	foreach $plsingle (@$livepllist) {
		next unless ( $plsingle->iscanrole($sow->{$rolename})); # ��l�ȊO�͏��O
		next unless ( $plsingle->isdo('role1') ); # ���܂����͏��O

		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		my $targetname = $targetpl->getchrname();
		if ($plsingle->issensible()){
			my $guardtext  = $plsingle->getText($execute);
			$guardtext =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $guardtext);
		}
		push(@guardtargetpl, $targetpl);
		my $scorehead = $vil->getTextByID('ABI_ROLE',$plsingle->{'role'});
		$score->addresult($scorehead,$targetname );
	}

	return \@guardtargetpl;
}

sub Kill {
	my ($sow, $vil, $logfile, $score, $murderpl, $killers, $targetpl, $jammed) = @_;

	if ((defined($targetpl->{'cid'})) && ($targetpl->{'live'} eq 'live')) {
		my $deadflag = &CheckKill($sow, $vil, $logfile, $score, $murderpl, $killers, $targetpl);
		if ($deadflag ne 'live') {
			
			if ($vil->{'event'} == $sow->{'EVENTID_GHOST'}) {
				$targetpl->{'role'}      = $sow->{'ROLEID_WOLF'};
				$targetpl->addhistory($vil->getText('RESULT_SEMIWOLF'));
				$targetpl->setfriends();
				$targetpl = $murderpl; # �P���Ώہ��P���ҁB�Ƃ��������ŎE�����B
			}
			&dead($sow, $vil, $murderpl, $targetpl, $deadflag, $logfile, $score);

			# �P�����ʒǋL
			my $livepllist = $vil->getlivepllist();
			foreach $plsingle (@$livepllist) {
				next unless (  $plsingle->cankiller() );
				my $result_kill;
				if( 'zombie' eq $deadflag ){
					$result_kill= $vil->getText('RESULT_ZOMBIE');
				} else {
					$result_kill= $vil->getText('RESULT_KILL');
				}
				my $targetname = $targetpl->getchrname();
				my $seerresult = '';
				$seerresult = GetResultAura($sow, $vil, $score, $targetpl, $jammed) if ($plsingle->{'role'} == $sow->{'ROLEID_AURAWOLF'});
				$seerresult = GetResultRole($sow, $vil, $score, $targetpl, $jammed) if ($plsingle->{'role'} == $sow->{'ROLEID_INTWOLF'});
				$result_kill =~ s/_TARGET_/$targetname/g;
				$result_kill .= $seerresult;
				$plsingle->addhistory($result_kill);
			}
		}
	}
}

sub KillLoneWolf {
	my ($sow, $vil, $logfile, $score) = @_;
	my $livepllist = $vil->getlivepllist();

	# ��C�T�̏P����ʏ���
	foreach $murderpl (@$livepllist) {
		if ( $murderpl->iscanrole($sow->{'ROLEID_LONEWOLF'}) ){
			next if (1 != $murderpl->isdo('role1')); # ���܂����͏��O
			my $targetpl = $vil->getplbypno($murderpl->{'role1'});
			my $targetname = $targetpl->getchrname();
			if (($targetpl->{'live'} eq 'live')) {
				&postKillMessage($murderpl,$targetname,$logfile,'MESTYPE_TSAY');
				my $deadflag = &CheckKill($sow, $vil, $logfile, $score, $murderpl, 1.01, $targetpl);

				if ($deadflag ne 'live') {
					&dead($sow, $vil, $murderpl, $targetpl, $deadflag, $logfile, $score);

					my $result_kill;
					if( 'zombie' eq $deadflag ){
						$result_kill= $vil->getText('RESULT_ZOMBIE');
					} else {
						$result_kill= $vil->getText('RESULT_KILL');
					}
					$result_kill =~ s/_TARGET_/$targetname/g;
					$murderpl->addhistory($result_kill);
				}
			}
		}
	}
}

sub Dawn{
	my ($sow, $vil, $logfile, $score) = @_;

	my $pllist = $vil->getpllist();
	my $livepllist = $vil->getlivepllist();
	# �ł��[������
	foreach $dish (@$livepllist) {
		if ( $dish->iscanrole($sow->{'ROLEID_DISH'}) ){
			next if ( $dish->{'role1'} != $dish->{'pno'} ); # ���܂����͏��O
			
			my $scorehead = $vil->getTextByID('ABI_ROLE',$dish->{'role'});
			$score->addresult($scorehead,$dish->getlongchrname() );

			my $dishtext = $vil->getText('EXECUTEJUMP');
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFONOM'}, $dishtext);
			$dish->addhistory($dishtext);
		}
	}

	# �u�^���̓��v���v�Z
	my $wolves = 0;
	foreach $plsingle (@$livepllist) {
		$wolves += 1 if ( $plsingle->iswolf() > 0 );
	}

	if ($wolves + 2 == $vil->{'turn'}){
		foreach $plsingle (@$livepllist){
			my $deadflag = 'live';
			# ���ɍs����
			$deadflag = 'droop' if ($plsingle->isbindrole($sow->{'ROLEID_DYING'})       ); 
			$deadflag = 'droop' if ($plsingle->isbindrole($sow->{'ROLEID_DYINGPOSSESS'}));
			$deadflag = 'droop' if ($plsingle->isbindrole($sow->{'ROLEID_DYINGWOLF'})   );
			$deadflag = 'droop' if ($plsingle->isbindrole($sow->{'ROLEID_DYINGPIXI'})   );
			next if ($deadflag eq 'live' );
			&dead($sow, $vil, 0, $plsingle, 'droop', $logfile, $score, 0);
		} 
	}
	$wolves = $vil->{'turn'} - 1;
	if (0 < $wolves){
		foreach $plsingle (@$livepllist){
			next unless ( $plsingle->issensible() );
			# �^�������o����B
			my $result = $vil->getText('RESULT_DYING');
			$result =~ s/_NUMBER_/$wolves/g;
			$plsingle->addhistory($result) if ($plsingle->isbindrole($sow->{'ROLEID_DYING'})       ); 
			$plsingle->addhistory($result) if ($plsingle->isbindrole($sow->{'ROLEID_DYINGPOSSESS'}));
			$plsingle->addhistory($result) if ($plsingle->isbindrole($sow->{'ROLEID_DYINGWOLF'})   );
			$plsingle->addhistory($result) if ($plsingle->isbindrole($sow->{'ROLEID_DYINGPIXI'})   );
		}
	}
}

sub Snatch{
	my ($sow, $vil, $logfile, $score ) = @_;
	my $livepllist = $vil->getlivepllist();
	my @snatch;

	# ��������X�i�b�`���[�����҃��X�g�����B
	foreach $plsingle (@$livepllist) {
		next if ( 1 != $plsingle->isdo('role1')); # ���܂����͏��O
		next if ( 0 == $plsingle->iscanrole($sow->{'ROLEID_SNATCH'}) );

		# �X�i�b�`
		push(@snatch, $plsingle);
		my $targetpl = $vil->getplbypno($plsingle->{'role1'}); 
		my $snatchname = $plsingle->getchrname(); 
		my $targetname = $targetpl->getchrname(); 
		# ��񏑂����� 
		my $snatchtext = $plsingle->getText('EXECUTESNATCH');
		$snatchtext =~ s/_NAME_/$snatchname/g; 
		$snatchtext =~ s/_TARGET_/$targetname/g; 
		$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $snatchtext); 
		$plsingle->addhistory($snatchtext);

		my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SNATCH'});
		$score->addresult($scorehead,$snatchname );
		$score->addresult($scorehead,$targetname );
	}
	
	# �X�i�b�`���[�\�͍s�g�B
	foreach $snatchpl (@snatch) {
		my $targetpl = $vil->getplbypno($snatchpl->{'role1'}); 

		# ���������c�����ƂŁA�e�A���O�̓���ւ��������B
		# ($snatchpl->{'cid'}, $targetpl->{'cid'}) = ($targetpl->{'cid'}, $snatchpl->{'cid'}); 
		# ($snatchpl->{'csid'}, $targetpl->{'csid'}) = ($targetpl->{'csid'}, $snatchpl->{'csid'}); 
		# ($snatchpl->{'jobname'}, $targetpl->{'jobname'}) = ($targetpl->{'jobname'}, $snatchpl->{'jobname'}); 
		# ($snatchpl->{'postfix'}, $targetpl->{'postfix'}) = ($targetpl->{'postfix'}, $snatchpl->{'postfix'}); 
		# ($snatchpl->{'clearance'}, $targetpl->{'clearance'}) = ($targetpl->{'clearance'}, $snatchpl->{'clearance'}); 

		# sheep, bonds, lovers �́A�e�ɏ�����̂Ŏ��c���B
		# <=> uid, role, rolesubid, selrole, live, deathday, vote, target, target2, entrust, history
		($snatchpl->{'uid'},       $targetpl->{'uid'})       = ($targetpl->{'uid'},       $snatchpl->{'uid'}      ); 
		($snatchpl->{'role'},      $targetpl->{'role'})      = ($targetpl->{'role'},      $snatchpl->{'role'}     ); 
		($snatchpl->{'gift'},      $targetpl->{'gift'})      = ($targetpl->{'gift'},      $snatchpl->{'gift'}     ); 
		($snatchpl->{'rolesubid'}, $targetpl->{'rolesubid'}) = ($targetpl->{'rolesubid'}, $snatchpl->{'rolesubid'}); 
		($snatchpl->{'rolestate'}, $targetpl->{'rolestate'}) = ($targetpl->{'rolestate'}, $snatchpl->{'rolestate'}); 
		($snatchpl->{'selrole'},   $targetpl->{'selrole'})   = ($targetpl->{'selrole'},   $snatchpl->{'selrole'}  ); 
		($snatchpl->{'history'},   $targetpl->{'history'})   = ($targetpl->{'history'},   $snatchpl->{'history'}  ); 

#		��ǂ����ӎ҂ɃX�i�b�`�����������A���ƂȂ������ʁB
#		($snatchpl->{'tmp_suicide'},$targetpl->{'tmp_suicide'})=($targetpl->{'tmp_suicide'},$snatchpl->{'tmp_suicide'}); 
		($snatchpl->{'live'},      $targetpl->{'live'})      = ($targetpl->{'live'},      $snatchpl->{'live'}      ); 
		($snatchpl->{'delay_live'},$targetpl->{'delay_live'})= ($targetpl->{'delay_live'},$snatchpl->{'delay_live'}); 
		($snatchpl->{'deathday'},  $targetpl->{'deathday'})  = ($targetpl->{'deathday'},  $snatchpl->{'deathday'}  ); 
		($snatchpl->{'saidcount'}, $targetpl->{'saidcount'}) = ($targetpl->{'saidcount'}, $snatchpl->{'saidcount'} ); 

		# �J�����g�v���C���[�i���O�C�����̃v���C���[�j��ύX���邩������Ȃ��B
		$sow->{'curpl'} = $vil->getpl($sow->{'uid'}) if ($vil->checkentried() >= 0);
	}
}


#----------------------------------------
# �閾���̌��
# ���S�҂̔����A���S�҂ɂ��e������������B
#----------------------------------------
sub Regret{
	my ($sow, $vil, $logfile, $score, $jammed ) = @_;

	my $pllist = $vil->getpllist();

	# ���҂̊m��B
	# ��ǂ������l�ɑ��̎������Ȃ��Ȃ�A��ǂ����\�L�B
	# �������A��ǂ��҂̍s���͐�ɍς܂��Ă���̂ŁA�����͕\�L�̂݁B
	foreach $targetpl (@$pllist){
		# ��Ԋm��B
		if ($targetpl->{'delay_rolestate'} != $targetpl->{'rolestate'}){
			$targetpl->{'rolestate'} = $targetpl->{'delay_rolestate'};
		}
		$targetpl->define_delay();
		if ($targetpl->{'delay_live'} eq 'live' ){
			# ���̗��R�ł͎��ȂȂ������l�����A��ǂ��`�F�b�N�B
			if ($targetpl->{'tmp_suicide'} != $sow->{'TARGETID_TRUST'} ){
				$targetpl->{'live'}     = 'suicide';
				$targetpl->{'deathday'} = $vil->{'turn'};
				$targetpl->{'rolestate'} |= $sow->{'MASKSTATE_HEAL'};

				my $deadpl = $targetpl->{'tmp_suicide'};
				my $suicidetext = $vil->getText('SUICIDEBONDS');
				my $chrname    = $deadpl->getchrname();
				my $targetname = $targetpl->getchrname();
				$suicidetext =~ s/_TARGET_/$chrname/g;
				$suicidetext =~ s/_NAME_/$targetname/g;
				$logfile->writeinfo($targetpl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $suicidetext);
			}
		}
	}

	my $deadplcnt = 0;
	my $deadtext = $vil->getTextByID('ANNOUNCE_KILL',0);
	my $millerhollow;

	# ���f�́A���Q�A�\���͔������Ȃ��B
	$vil->{'grudge'} = -1;
	$vil->{'riot'} = -1;
	# ���҂�\�L�B
	foreach $plsingle (@$pllist){
		next if ($plsingle->{'live'} eq 'live');
		next if ($plsingle->{'deathday'} ne $vil->{'turn'});

		my $deadchrname = $plsingle->getchrname();
		my $scorehead = $sow->{'textrs'}->{'STATUS_LIVE'}->{$plsingle->{'live'}};
		$score->addresult($scorehead,$deadchrname );

		# �e�T�̎��́B���Q�I
		if ($plsingle->iscanrole($sow->{'ROLEID_CHILDWOLF'}) ){
			$vil->{'grudge'} = $vil->{'turn'};
			my $result = $plsingle->getText('EXECUTECHILDWOLF');
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOWOLF'}, $result);
		}
		
		# �����҂̎��́B�\���I
		if ($plsingle->iscanrole($sow->{'ROLEID_FAN'}) ){
			$vil->{'riot'} = $vil->{'turn'};
			my $result = $plsingle->getText('EXECUTEFAN');
			$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $result);
		}

		# �~���[�Y�z���E�̎��Ҕ���
		$ismillerhollow = 0;
		$ismillerhollow = 1 if ('MILLERHOLLOW'      eq $vil->{'game'});
		$ismillerhollow = 1 if ('LIVE_MILLERHOLLOW' eq $vil->{'game'});
		
		if ( $ismillerhollow ){
			$millerhollow .= GetResultRole($sow, $vil, $score, $plsingle, $jammed);
		}


		if ( $plsingle->ismediumed() ){
			# ���Y���ʂɂ���ẮA�u�[�C���O�����B
			if ($plsingle->ishuman()){
				$vil->{'content'} = 'boo' if (($vil->{'event'} == $sow->{'EVENTID_CLAMOR'}));
			} else {
				$vil->{'content'} = 'boo' if (($vil->{'event'} == $sow->{'EVENTID_FIRE'}  ));
			}
		} else {
			# ���c�Ȏ��̂𔭌��A�����グ��B
			$deadplcnt += 1 ;

			$deadtext .= '<br>'.$vil->getTextByID('ANNOUNCE_KILL',2);
			$deadtext =~ s/_TARGET_/$deadchrname/g;
		}
	}
	if ($deadplcnt == 0) {
		# ���c�Ȏr�̂Ȃ�
		$deadtext .= '<br>'.$vil->getTextByID('ANNOUNCE_KILL',1);
	}
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $deadtext);

	if ($millerhollow ne '' ){
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $millerhollow);
	}
}


#----------------------------------------
# ��ǂ��A�܋��҂�
#----------------------------------------
sub cycle {
	my ($sow, $vil, $deadpl, $logfile, $score) = @_;

	my $chrname = $deadpl->getchrname();
	# �J�̌�ǂ� �i�l���n���̓��ɂ͂�����Ȃ��j
	if ( $vil->{'event'} != $sow->{'EVENTID_APRIL_FOOL'} ){
		my @bonds = $deadpl->getbondlist();
		foreach $plsingle (@bonds) {
			my $targetpl = $vil->getplbypno($plsingle);
			next if ('hate' eq $targetpl->{'love'}   );
			next if (  -1   != $targetpl->{'tmp_suicide'});
			$targetpl->{'tmp_suicide'} = $deadpl;
			&cycle($sow, $vil, $targetpl, $logfile, $score); # ��ǂ��A��
		}
	}

	# �܋��҂�
	if ( $deadpl->iscanrole($sow->{'ROLEID_HUNTER'}) ){
		return if ( $deadpl->{'role1'} < 0); # ���܂����͏��O
		# �u��������\�v�ɐݒ肵�A�܋��҂��̔\�͂���d�������Ȃ��悤�ɁB
		$deadpl->{'tmp_rolestate'} = $sow->{'ROLESTATE_ABI_NONE'};
		my $targetpl = $vil->getplbypno($deadpl->{'role1'});
		my $targetname = $targetpl->getchrname();
		if (($targetpl->{'live'} eq 'live')) {
			&postKillMessage($deadpl,$targetname,$logfile,'MESTYPE_TSAY');
			my $deadflag = &CheckKill($sow, $vil, $logfile, $score, $deadpl, 1.01, $targetpl);
			if ($deadflag ne 'live') {
				&dead($sow, $vil, $deadpl, $targetpl, $deadflag, $logfile, $score);
			}
		}
	}
}

sub revenge {
	my ($sow, $vil, $killer, $deadpl, $logfile, $score) = @_;
	return if (!defined( $killer->{'pno'}));
	return if ($deadpl->{'pno'} == $killer->{'pno'});

	my $chrname = $deadpl->getchrname();
	# ���V���E�Q����ƁA�E�Q�҂͔\�͂������B
	# �a�l���E�Q����ƁA�E�Q�҂͔\�͂������B
	if (($deadpl->iscanrole($sow->{'ROLEID_ELDER'})  )
	  ||($deadpl->iscanrole($sow->{'ROLEID_INVALID'}))  ) {
		&toCurse($sow,$vil,$killer,$logfile);
		my $scorehead = $vil->getTextByID('ROLENAME',$deadpl->{'role'});
		$score->addresult($scorehead, $chrname );
	}
	# ���򂷂�Ɣ\�͂������̂ŁA���򒆂͂��łɁu�L�\�ȘB���p�t�v�ł͂Ȃ��B
	# ���򒆂̘B���p�t���E�Q����ƁA�E�Q�҂͂��ʁB
	if (($deadpl->isbindrole($sow->{'ROLEID_ALCHEMIST'}))&&($deadpl->{'role1'} == $deadpl->{'pno'})) {
		&dead($sow, $vil, $killer, $killer, 'cursed', $logfile, $score);
	}
}

sub nowdead {
	my ($sow, $vil, $killer, $deadpl, $deadflag, $logfile, $score) = @_;
	if ( 'zombie' eq $deadflag ){
		# �����̏����B
		&toZombie($sow,$vil,$deadpl,$logfile);
	} else {
		$deadpl->{'deathday'} = $vil->{'turn'};
		$deadpl->{      'live'} = $deadflag;
		$deadpl->{'delay_live'} = $deadflag;
		&cycle($sow, $vil, $deadpl, $logfile, $score);
		&revenge($sow, $vil, $killer, $deadpl, $logfile, $score);
	}

}

sub dead {
	my ($sow, $vil, $killer, $deadpl, $deadflag, $logfile, $score) = @_;
	if ( 'zombie' eq $deadflag ){
		# �����̏����B
		&toZombie($sow,$vil,$deadpl,$logfile);
	} else {
		$deadpl->{'delay_live'} = $deadflag;
		&cycle($sow, $vil, $deadpl, $logfile, $score);
		&revenge($sow, $vil, $killer, $deadpl, $logfile, $score);
	}
}

sub heal {
	my ($sow, $vil, $deadpl, $logfile) = @_;

	# �h�������ꍇ�A�]���r��ԁA������Ԃ�������B
	$deadpl->{'delay_live'} = 'live';
	$deadpl->{'rolestate'} |= $sow->{'MASKSTATE_HEAL'};

	# �\�͍s�g�̃��Z�b�g
	$deadpl->{'vote1'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'vote2'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'role1'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'role2'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'gift1'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'gift2'} = $sow->{'TARGETID_TRUST'};
}

sub CheckKill {
	my ($sow, $vil, $logfile, $score, $murderpl, $killers, $targetpl) = @_;
	my $deadflag = 'victim';

	return $deadflag if($targetpl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});

	my $livepllist = $vil->getlivepllist();
	my $targetname = $targetpl->getchrname();

	# �����҂�������x�P�������ꍇ�́A�E���͂����B
	$killers += 0.01 if ($targetpl->isDisableState('MASKSTATE_ZOMBIE'));

	my $hasGJ=0;
	my @guards;
	# ��q����
	foreach $plsingle (@$livepllist) {
		next unless ( $plsingle->isdo('role1') );                      # ���܂����͏��O
		next unless ( $plsingle->iscanrole($sow->{'ROLEID_GUARD'}) );  # ��l�ȊO�͏��O
		next if ($plsingle->{'role1'} != $targetpl->{'pno'});         # �Ώۂ���q���ĂȂ���Ώ��O

		my $result_guard = "";
		if (($plsingle->issensible())){
			$result_guard = $vil->getText('RESULT_GUARD');
		} else {
			$result_guard = $vil->getText('RESULT_ENCOUNT');
		}
		$result_guard =~ s/_TARGET_/$targetname/g;
		$plsingle->addhistory($result_guard);
		# ��q�����W�v
		push(@guards, $plsingle);
		$hasGJ++;
	}
	my $guardpl = $guards[int(rand(@guards))];

	# ���̗ւ������Ă���i�K�������j
	if (($targetpl->{'live'} eq 'live') && ($targetpl->{'gift'} == $sow->{'GIFTID_SHIELD'})) {
		$hasGJ++;
	}
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "GJ count $hasGJ.");

	# �u��������v���[�h
	my $enable_zombie = 0;
	$enable_zombie = 1 if ('TROUBLE' eq $vil->{'game'} );
	$enable_zombie = 1 if ('VOV'     eq $vil->{'game'} );

	if ((0 < $hasGJ)&&(0 < $killers)){
		if ($enable_zombie){
			# ��쑤�Ɛl�T���̑����B���������Ă����r
			if      (int($hasGJ) < int($killers)){
				# �P�������D��
				# �͕����������ҒB�́A�����ł͂Ȃ��i�����ł��ށj
				foreach $guardpl (@guards) {
					my $g_deadflag = &CheckKill($sow, $vil, $logfile, $score, $murderpl, 1, $guardpl);
					if ($g_deadflag ne 'live') {
						&dead($sow, $vil, $murderpl, $guardpl, $g_deadflag, $logfile, $score);
					}
				}
			} elsif (int($hasGJ) > int($killers)){
				# ��q�����D��
				# ��q������̕Ԃ蓢���ł́A�Ώۂ͎��S����B
				my $g_deadflag = &CheckKill($sow, $vil, $logfile, $score, $guardpl, $hasGJ + 0.01, $murderpl);
				if ($g_deadflag ne 'live') {
					&dead($sow, $vil, $guardpl, $murderpl, $g_deadflag, $logfile, $score);
				}
			}
		}
		# ��씭���̏ꍇ�A�ǂ��]��ł��{���̋]���҂͖����B
		return 'live';
	} else {
		if ($enable_zombie){
			# ���̂Ȃ��ꍇ�B
			if    (1 < $killers){
			}elsif(0 < $killers){
				$deadflag = 'zombie';
			} else {
				return 'live'; # �����̎��͉��̃`�F�b�N�����܂Ȃ��B
			}
		}
	}
	
	# ���V�͈�x�������ȂȂ�
	# �l���͑������Ȃ�
	if ( ($targetpl->iscanrole($sow->{'ROLEID_ELDER'})  )
	   ||($targetpl->iscanrole($sow->{'ROLEID_WEREDOG'})) ) {
		if (($targetpl->issensible())){
			$targetpl->addhistory($vil->getText('RESULT_WEREDOG')) if($targetpl->{'role'} == $sow->{'ROLEID_WEREDOG'}); 
			$targetpl->addhistory($vil->getText('RESULT_ELDER'  )) if($targetpl->{'role'} == $sow->{'ROLEID_ELDER'}  ); 
		}
		$targetpl->{'delay_rolestate'} &= $sow->{'ROLESTATE_HURT'};
		$targetpl->{'tmp_deathday'} = $vil->{'turn'};
		$deadflag = 'live';

		my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_WEREDOG'});
		$score->addresult($scorehead, $targetname );
	}

	# ���T�͎��Ȃ��A�l�T�ɂȂ�B
	if ( $targetpl->iscanrole($sow->{'ROLEID_SEMIWOLF'})) {
		$targetpl->{'role'}      = $sow->{'ROLEID_WOLF'};
		$targetpl->addhistory($vil->getText('RESULT_SEMIWOLF'));
		$targetpl->setfriends();
		$deadflag = 'live';

		my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_SEMIWOLF'});
		$score->addresult($scorehead, $targetname );
	}

	# �d���͏P���ł͎��ȂȂ��B
	if (( $targetpl->iscursed('role') )&&( $targetpl->isEnableState('MASKSTATE_ABI_ROLE') )){
		$deadflag = 'live';
		my $scorehead = $vil->getTextByID('ROLENAME',$targetpl->{'role'});
		$score->addresult($scorehead, $targetname );
	}
	if (( $targetpl->iscursed('gift') )&&( $targetpl->isEnableState('MASKSTATE_ABI_GIFT') )){
		$deadflag = 'live';
		my $scorehead = $vil->getTextByID('ROLENAME',$targetpl->{'gift'});
		$score->addresult($scorehead, $targetname );
	}

	if ( $targetpl->iscanrole($sow->{'ROLEID_LONEWOLF'}) ) {
		$deadflag = 'live';

		my $scorehead = $vil->getTextByID('ROLENAME',$targetpl->{'role'});
		$score->addresult($scorehead, $targetname );
	}

	$score->addresult($deadflag, $targetname );
	return $deadflag;
}

sub Seer {
	my ($sow, $vil, $logfile, $score, $jammed) = @_;

	my $pllist = $vil->getpllist();
	foreach $plsingle (@$pllist) {
		if ( $plsingle->{'live'} eq 'live' ) {
			if ( $plsingle->isdo('role1') ) {
				# ���܂����͏��O
				my $targetpl = $vil->getplbypno($plsingle->{'role1'});
				my $seerresultrole = '';
				my $isseer = 0;

				if (    $plsingle->iscanrole($sow->{'ROLEID_SEERWIN' }) ){ $isseer = 1; $seerresultrole = GetResultWin ($sow, $vil, $score, $targetpl, $jammed) };
				if (    $plsingle->iscanrole($sow->{'ROLEID_SEERROLE'}) ){ $isseer = 1; $seerresultrole = GetResultRole($sow, $vil, $score, $targetpl, $jammed) };
				if (    $plsingle->iscanrole($sow->{'ROLEID_SORCERER'}) ){ $isseer = 1; $seerresultrole = GetResultRole($sow, $vil, $score, $targetpl, $jammed) };
				if (($plsingle->issensible())){
					if ($plsingle->iscanrole($sow->{'ROLEID_SEER'    }) ){ $isseer = 1; $seerresultrole = GetResultSeer  ($sow, $vil, $score, $targetpl, $jammed) };
					if ($plsingle->iscanrole($sow->{'ROLEID_AURA'    }) ){ $isseer = 1; $seerresultrole = GetResultAura  ($sow, $vil, $score, $targetpl, $jammed) };
				} else {
					if ($plsingle->iscanrole($sow->{'ROLEID_SEER'    }) ){ $isseer = 1; $seerresultrole = GetResultSeerEncount  ($sow, $vil, $score, $targetpl, $jammed) };
					if ($plsingle->iscanrole($sow->{'ROLEID_AURA'    }) ){ $isseer = 1; $seerresultrole = GetResultAuraEncount  ($sow, $vil, $score, $targetpl, $jammed) };
				}
				# �q�T�A���T�̔���́A�P���t�F�[�Y�ŁB

				&SeerEffect($sow, $vil, $plsingle, $targetpl, $seerresultrole, $logfile, $score, $jammed) if ($isseer);
			}

			if ( $plsingle->isdo('gift1') ) {
				# ���܂����͏��O
				my $targetpl = $vil->getplbypno($plsingle->{'gift1'});
				my $seerresultgift = '';
				my $isseer = 0;

				if (    $plsingle->iscangift($sow->{'GIFTID_SEERONCE'}) ) { $isseer = 1; $seerresultgift = GetResultSeer($sow, $vil, $score, $targetpl, $jammed) };
				&SeerEffect($sow, $vil, $plsingle, $targetpl, $seerresultgift, $logfile, $score, $jammed) if ($isseer);
				# ����t���͂��g���ʂ������B
				if ($plsingle->isbindgift($sow->{'GIFTID_SEERONCE'})){
					$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_NOGIFT'};
				}
			}
		} else {
			# ���҂́A�씻��̑ΏۂɂȂ邩������Ȃ��B
			next if ( $plsingle->{'deathday'} ne $vil->{'turn'} );
			next unless ( $plsingle->ismediumed() );
			# ��\����
			my $seerencount = GetResultSeerEncount($sow, $vil, $score, $plsingle, $jammed);
			my $auraencount = GetResultAuraEncount($sow, $vil, $score, $plsingle, $jammed);
			my $seerresult = GetResultSeer($sow, $vil, $score, $plsingle, $jammed);
			my $auraresult = GetResultAura($sow, $vil, $score, $plsingle, $jammed);
			my $winresult  = GetResultWin( $sow, $vil, $score, $plsingle, $jammed);
			my $roleresult = GetResultRole($sow, $vil, $score, $plsingle, $jammed);
			# ��\����ǋL
			my $livepllist = $vil->getlivepllist();
			foreach $plsingle (@$livepllist) {
				if (($plsingle->issensible())){
					$plsingle->addhistory($seerresult) if ($plsingle->iscanrole($sow->{'ROLEID_NECROMANCER'}) );
					$plsingle->addhistory($seerresult) if ($plsingle->iscanrole($sow->{'ROLEID_MEDIUM'})      );
				} else {
					$plsingle->addhistory($seerencount) if ($plsingle->iscanrole($sow->{'ROLEID_NECROMANCER'}) );
					$plsingle->addhistory($seerencount) if ($plsingle->iscanrole($sow->{'ROLEID_MEDIUM'})      );
				}
				$plsingle->addhistory($winresult)  if ($plsingle->iscanrole($sow->{'ROLEID_MEDIUMWIN'})   );
				$plsingle->addhistory($roleresult) if ($plsingle->iscanrole($sow->{'ROLEID_MEDIUMROLE'})  );
				$plsingle->addhistory($roleresult) if ($plsingle->iscanrole($sow->{'ROLEID_ORACLE'})      );
			}
		}
	}

	# ���Â̌��ʂ�������Ԃ�ς��Ă��܂��̂ŁA��t�̔\�͍͂Ō�B
	foreach $plsingle (@$pllist) {
		next if ( $plsingle->{'live'} ne 'live' );
		if ( $plsingle->isdo('role1') ) {
			# ���܂����͏��O
			my $targetpl = $vil->getplbypno($plsingle->{'role1'});
			my $seerresultrole = '';
			my $isseer = 0;

			if (($plsingle->issensible())){
				if ($plsingle->iscanrole($sow->{'ROLEID_DOCTOR'  }) ){ $isseer = 1; $seerresultrole = GetResultDoctor($sow, $vil, $score, $targetpl, $jammed) };
			} else {
				if ($plsingle->iscanrole($sow->{'ROLEID_DOCTOR'  }) ){ $isseer = 1; $seerresultrole = GetResultDoctorEncount($sow, $vil, $score, $targetpl, $jammed) };
			}
			&SeerEffect($sow, $vil, $plsingle, $targetpl, $seerresultrole, $logfile, $score, $jammed) if ($isseer);
		}
	}
}

sub SeerEffect {
	my ($sow, $vil, $plsingle, $targetpl, $seerresult, $logfile, $score, $jammed) = @_;

	my $livepllist = $vil->getlivepllist();

	# �肢�̕���p�����{�B
	# �g���Ƃ��͂��Ȃ炸�A�肢�������̂ݎ��s����H�v�����邱�ƁB
	# �肢����
	my $targetname = $targetpl->getchrname();
	$plsingle->addhistory($seerresult);
	if (($plsingle->issensible())){
		my $seertext   = $plsingle->getText('EXECUTESEER');
		$seertext =~ s/_TARGET_/$targetname/g;
		$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $seertext.'<br>'.$seerresult);
	}
	my $hasGJ=0;
	foreach $plsingle (@$livepllist) {
		# �ז��ł�GJ
		if ($plsingle->{'role'} eq $sow->{'ROLEID_JAMMER'} && $plsingle->{'role1'} == $targetpl->{'pno'}) { 
			my $result = $vil->getText('RESULT_JAMM');
			$result =~ s/_TARGET_/$targetname/g;
			$plsingle->addhistory($result) if (defined($targetpl->{'uid'}));
			$hasGJ++;
		}
	}
	return if ($hasGJ > 0);
	# �d����E
	if (($targetpl->{'live'} eq 'live') && ($targetpl->iscursed('role')+$targetpl->iscursed('gift'))) {
		&dead($sow, $vil, $plsingle, $targetpl, 'cursed', $logfile, $score);
	}
	# ���l
	if ($targetpl->iscanrole($sow->{'ROLEID_CURSE'})) {
		&dead($sow, $vil, $targetpl, $plsingle, 'cursed', $logfile, $score);
	}
	# ���T
	if ($targetpl->iscanrole($sow->{'ROLEID_CURSEWOLF'})) {
		&dead($sow, $vil, $targetpl, $plsingle, 'cursed', $logfile, $score);
	}
	# �T����
	if ($targetpl->isbindrole($sow->{'ROLEID_RIGHTWOLF'})) {
		if (($targetpl->issensible())){
			my $result_seered = $vil->getText('RESULT_RIGHTWOLF');
			$targetpl->addhistory($result_seered);
		}
	}
}


sub Alchemist{
	my ($sow, $vil, $logfile, $score, $jammtargetpl) = @_;

	my $pllist = $vil->getpllist();
	foreach $plsingle (@$pllist) {
		next if ( $plsingle->{'role1'} != $plsingle->{'pno'} ); # ���܂����͏��O
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		my $targetname = $targetpl->getchrname();
		# ����
		if ($plsingle->iscanrole($sow->{'ROLEID_ALCHEMIST'})){
			$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_NOROLE'};

			if ($plsingle->issensible()){
				my $result = $plsingle->getText('EXECUTEALCHEMIST');
				$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);

				$result = $vil->getText('RESULT_ALCHEMIST');
				$result =~ s/_TARGET_/$targetname/g;
				$plsingle->addhistory($result);
			}

			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_ALCHEMIST'});
			$score->addresult($scorehead, $targetname );
		}
	}
}

sub Witch{
	my ($sow, $vil, $logfile, $score, $jammtargetpl) = @_;
	my $pllist = $vil->getlivepllist();
	foreach $plsingle (@$pllist) {
		next if (1 != $plsingle->isdo('role1')); # ���܂����͏��O
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		my $targetname = $targetpl->getchrname();
		# �����̓���
		if ($plsingle->iscanrole($sow->{'ROLEID_WITCH'})){
			# ���ۂ̐����ɂ�����炸�A����g���B
			if ($plsingle->{'tmp_targetlive'} eq 'live'){
				# �Ŗ򂪂Ȃ��ꍇNG
				next if ($plsingle->isDisableState('MASKSTATE_ABI_KILL'));
				$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_KILL'};
				# �Ŗ���g��
				if ($plsingle->issensible()){
					my $result = $plsingle->getText('EXECUTEKILLWITCH');
					$result =~ s/_TARGET_/$targetname/g;
					$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
					$result = $vil->getText('RESULT_KILL');
					$result =~ s/_TARGET_/$targetname/g;
					$plsingle->addhistory($result);
				}

				my $scorehead = $sow->{'textrs'}->{'STATUS_LIVE'}->{'cursed'};
				$score->addresult($scorehead, $targetname );

				&dead($sow, $vil, $plsingle, $targetpl, 'cursed', $logfile, $score, $jammtargetpl);
			} elsif ($plsingle->{'tmp_targetlive'} eq 'suddendead'){
				# �ˑR������ɁA��͎g��Ȃ��B
				next;
			} else {
				# �h���򂪂Ȃ��ꍇNG
				next if ($plsingle->isDisableState('MASKSTATE_ABI_LIVE'));
				$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_LIVE'};
				# �h������g��
				if ($plsingle->issensible()){
					my $result = $plsingle->getText('EXECUTELIVEWITCH');
					$result =~ s/_TARGET_/$targetname/g;
					$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
					$result = $vil->getText('RESULT_LIVE');
					$result =~ s/_TARGET_/$targetname/g;
					$plsingle->addhistory($result);
				}

				my $scorehead = $sow->{'textrs'}->{'STATUS_LIVE'}->{'live'};
				$score->addresult($scorehead, $targetname );

				&heal($sow, $vil, $targetpl, $logfile, $score);
			}

		}
	}
}

sub GetResultSeerEncount {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = "";
	my $result_hit = $vil->getText('RESULT_ENCOUNT');
	# �l�T����B��E���l�T�A���b���l�T�A��C�T�A�T�����B�܂��A���T�͐l�Ԕ���B
	$result = $result_hit if  ($targetpl->iskiller('role')); # �l�T����
	$result = $result_hit if  ($targetpl->iskiller('gift')); # �l�T����
	$result = $result_hit if  ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # �]���r�ɂ���܂����B
	$result = $result_hit if  ($targetpl->{'role'} == $sow->{'ROLEID_LONEWOLF'}  );
	$result = $result_hit if  ($targetpl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'} );
	$result = ""          if  ($targetpl->iscanrole(  $sow->{'ROLEID_WHITEWOLF'}));
	foreach $plsingle (@$jammed){
		$result =  "" if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	$result =~ s/_TARGET_/$chrname/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SEER'});
	$score->addresult($scorehead, $chrname );
	return $result;
}

sub GetResultDoctorEncount {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = "";
	my $result_hit = $vil->getText('RESULT_ENCOUNT');
	# �l�T����B�����҂̂݁B
	$result = $result_hit if  ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # ������
	foreach $plsingle (@$jammed){
		$result =  "" if ($plsingle == $targetpl);
	}
	$targetpl->{'delay_rolestate'} |= $sow->{'MASKSTATE_MEDIC'} if ("" ne $result);
	my $chrname = $targetpl->getchrname();
	$result =~ s/_TARGET_/$chrname/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_DOCTOR'});
	$score->addresult($scorehead, $chrname );
	return $result;
}

sub GetResultAuraEncount {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = $vil->getText('RESULT_ENCOUNT');
	$result = "" if ($targetpl->{'role'} == $sow->{'ROLEID_VILLAGER'} );
	$result = "" if ($targetpl->{'role'} == $sow->{'ROLEID_WOLF'}     );
	$result = "" if ($targetpl->iscanrole( $sow->{'ROLEID_WHITEWOLF'}));
	$result = "" if ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # �]���r�ɂ���܂����B
	foreach $plsingle (@$jammed){
		$result = "" if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	$result =~ s/_TARGET_/$chrname/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_AURA'});
	$score->addresult($scorehead, $chrname );
	return $result;
}


sub GetResultSeer {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = 1;
	# �l�T����B��E���l�T�A���b���l�T�A��C�T�A�T�����B�]���r�B�܂��A���T�͐l�Ԕ���B
	$result = 2 if  ($targetpl->iskiller('role')); # �l�T����
	$result = 2 if  ($targetpl->iskiller('gift')); # �l�T����
	$result = 2 if  ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # �]���r�ɂ���܂����B
	$result = 2 if  ($targetpl->{'role'} == $sow->{'ROLEID_LONEWOLF'}  );
	$result = 2 if  ($targetpl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'} );
	$result = 1 if  ($targetpl->iscanrole(  $sow->{'ROLEID_WHITEWOLF'}));
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SEER'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

sub GetResultDoctor {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = 5;
	# �l�T����B�����҂̂݁B
	$result = 6 if ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # ������
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	$targetpl->{'delay_rolestate'} |= $sow->{'MASKSTATE_MEDIC'} if (6 eq $result);
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_DOCTOR'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

sub GetResultAura {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = 4;
	$result = 3 if ($targetpl->{'role'} == $sow->{'ROLEID_VILLAGER'} );
	$result = 3 if ($targetpl->{'role'} == $sow->{'ROLEID_WOLF'}     );
	$result = 3 if ($targetpl->iscanrole( $sow->{'ROLEID_WHITEWOLF'}));
	$result = 3 if ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # �]���r�ɂ���܂����B
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_AURA'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

sub GetResultWin {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $textrs = $sow->{'textrs'};
	# �����������Q�Ƃ���B
	my $result = 7;
	my $win    = $textrs->{'ROLEWIN'}->{ $targetpl->win_if() };
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;
	$result_seer =~ s/_ROLE_/$win/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SEERWIN'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

sub GetResultRole {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = 7;
	my $role   = $vil->getTextByID('ROLENAME',$targetpl->{'role'});
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;
	$result_seer =~ s/_ROLE_/$role/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SEERROLE'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

#----------------------------------------
# �\�͑Ώۃ����_���w�莞����
#----------------------------------------
sub SetRandomTarget {
	my ($sow, $vil, $logfile, $role,$abi_role) = @_;
	my $livepllist = $vil->getlivepllist();

	my $srcpl;
	foreach $srcpl (@$livepllist) {
		my $abirole = $vil->getTextByID($abi_role,$srcpl->{$role});
		if ($srcpl->{$role.'1'} == $sow->{'TARGETID_RANDOM'}) {
			# �����_���Ώ�
			my $srctargetpno;
			$srctargetpno = $srcpl->{$role.'2'} if (($srcpl->{$role.'2'} >= 0) && ($srcpl->{'live'} eq 'live'));
			$srcpl->setRandomTarget($role,1, $abi_role,$logfile, $srctargetpno);
		}

		if (($srcpl->{$role.'2'} == $sow->{'TARGETID_RANDOM'})) {
			$srcpl->setRandomTarget($role,2, $abi_role,$logfile, $srcpl->{$role.'1'});
		}
	}
}

#----------------------------------------
# �������[��̐ݒ�
#----------------------------------------
sub SetInitVoteTarget {
	my ($sow, $vil, $logfile) = @_;
	my $allpllist = $vil->getallpllist();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "Start: SetInitVoteTarget.");
	foreach $plsingle (@$allpllist) {
		if( $plsingle->{'live'} eq 'live' ){
			$plsingle->setInitTarget('gift',1, $logfile, -1);
			$plsingle->setInitTarget('gift',2, $logfile, $plsingle->{'gift1'}); # �e�T���S���B
			$plsingle->setInitTarget('role',1, $logfile, -1);
			$plsingle->setInitTarget('role',2, $logfile, $plsingle->{'role1'}); # �e�T���S���ƃg���b�N�X�^�[�Ŏg���񂵁B
		}
		if( $plsingle->isvoter() ){
			$plsingle->setInitTarget('vote',1, $logfile, -1);
			$plsingle->setInitTarget('vote',2, $logfile, $plsingle->{'vote1'}); # ��Ҏ��S���B
		}
		# �ϔC
		if(     $plsingle->setentrust($sow,$vil) == 0 ){
			$plsingle->{'entrust'} = 0 ;
		}elsif( $plsingle->setvote_to($sow,$vil) == 0 ){
			$plsingle->{'entrust'} = 1 ;
		}
	}
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "End: SetInitVoteTarget.");

	return;
}

#----------------------------------------
# �m��҂������̋����m��
#----------------------------------------
sub FixQueUpdateSession {
	my ($sow, $vil) = @_;

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	$logfile->fixque(1);
	$logfile->close();
}

sub postKillMessage{
	my ($murderpl,$targetname,$logfile,$mestype) = @_;
	my $sow = $murderpl->{'sow'};
	my $vil = $murderpl->{'vil'};

	my $killtext = $vil->getText('EXECUTEKILL');
	$killtext =~ s/_TARGET_/$targetname/g;
	my %say = (
		mestype    => $sow->{$mestype},
		logsubid   => $sow->{'LOGSUBID_SAY'},
		uid        => $murderpl->{'uid'},
		target     => $murderpl->{'uid'},
		csid       => $murderpl->{'csid'},
		cid        => $murderpl->{'cid'},
		chrname    => $murderpl->getlongchrname(),
		mes        => $killtext,
		undef      => 1, # �����Ƃ��Ĉ���Ȃ�
		expression => 0,
		monospace  => 0,
		que        => 0,
	);
	$logfile->executesay(\%say);
}

#----------------------------------------
# ���J�n����
#----------------------------------------
sub StartSession {
	my ($sow, $vil, $commit) = @_;
	my $textrs = $sow->{'textrs'};
	my $pllist = $vil->getpllist();

	# �m��҂������̋����m��
	&FixQueUpdateSession($sow, $vil);

	# ���Ԃ�i�߂�
	$vil->UpdateTurn($commit);

	# ���O�E�����f�[�^�t�@�C���̍쐬
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
	my $logfile  = SWBoa->new($sow, $vil, $vil->{'turn'}, 1);
	my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 1);

	# ��E�z�����蓖��
	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
	my ( $rolematrix, $giftmatrix ) = &SWSetRole::SetRole($sow, $vil, $logfile);
	foreach $plsingle (@$pllist) {
		$plsingle->{'selrole'} = $plsingle->{'backupselrole'};
	}

	# ������������
	$vil->setsaycountall();

	# �P���ڊJ�n�A�i�E���X
	my $announce_first = $vil->getTextByID('ANNOUNCE_FIRST',1);
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $announce_first );

	# ��E���蓖�ăA�i�E���X
	my $rolename = $textrs->{'ROLENAME'};
	my $giftname = $textrs->{'GIFTNAME'};
	my $i;

	my @rolelist;
	my @giftlist;
	my $ar = $textrs->{'ANNOUNCE_ROLE'};
	for ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
		my $roleplcnt = $rolematrix->[$i];
		$roleplcnt++ if ($i == $sow->{'ROLEID_VILLAGER'}); # �_�~�[�L�����̕��P���₷
		push (@rolelist, "$rolename->[$i]$ar->[1]$roleplcnt$ar->[2]") if ($roleplcnt > 0);
	}
	for ($i = 2; $i < @{$sow->{'GIFTID'}}; $i++) {
		my $giftplcnt = $giftmatrix->[$i];
		push (@rolelist, "$giftname->[$i]$ar->[1]$giftplcnt$ar->[2]") if ($giftplcnt > 0);
	}
	my $rolelist = join($ar->[3], @rolelist);
	my $giftlist = join($ar->[3], @giftlist);
	my $roleinfo = $ar->[0];
	$roleinfo =~ s/_ROLE_/$rolelist/;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $roleinfo);

	# �_�~�[�L��������
	$plsingle = $vil->getpl($sow->{'cfg'}->{'USERID_NPC'});
	my $charset = $sow->{'charsets'}->{'csid'}->{$plsingle->{'csid'}};
	%say = (
		mestype    => $sow->{'MESTYPE_SAY'},
		logsubid   => $sow->{'LOGSUBID_SAY'},
		uid        => $sow->{'cfg'}->{'USERID_NPC'},
		target     => $sow->{'cfg'}->{'USERID_NPC'},
		csid       => $plsingle->{'csid'},
		cid        => $plsingle->{'cid'},
		chrname    => $plsingle->getlongchrname(),
		expression => 0,
		mes        => $charset->{'NPCSAY'}->[1],
		undef      => 0,
		monospace  => 0,
		que        => 0,
	);
	$plsingle->{'lastwritepos'} = $logfile->executesay(\%say);
	my $saypoint = &SWBase::GetSayPoint($sow, $vil, $say{'mes'});
	$plsingle->{'say'} -= $saypoint; # ����������
	$plsingle->{'saidcount'}++;
	$plsingle->{'saidpoint'} += $saypoint;

	# �_�~�[�L�����̃R�~�b�g
	$plsingle->{'commit'} = 1;
	my $mes = $plsingle->getTextByID('ANNOUNCE_COMMIT',$plsingle->{'commit'});
	$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes);

	# �l�T���̏o��
	if ($sow->{'cfg'}->{'ENABLED_SCORE'} > 0) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
		my $score = SWScore->new($sow, $vil, 0);
 		$score->writestart();
		$score->close();
	}

	# �������[��̐ݒ�
	&SetInitVoteTarget($sow, $vil, $logfile);

	$logfile->close();
	$memofile->close();
	$vil->writevil();

	# ���ꗗ�̍X�V
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	$vindex->updatevindex($vil, $sow->{'VSTATUSID_PLAY'});
	$vindex->closevindex();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Start Session. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");

	return;
}

#----------------------------------------
# ���X�V����
#----------------------------------------
sub UpdateSession {
	my ($sow, $vil, $commit, $scrapvil) = @_;
	my $pllist = $vil->getpllist();

	return if ($vil->{'epilogue'} < $vil->{'turn'}); # �I���ς�

	# �m��҂������̋����m��
	&FixQueUpdateSession($sow, $vil);

	# ���Ԃ�i�߂�
	$vil->UpdateTurn($commit);

	if ($vil->{'epilogue'} < $vil->{'turn'}) {
		# �I��
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
		my $vindex = SWFileVIndex->new($sow);
		$vindex->openvindex();
		my $vi = $vindex->getvindex($vil->{'vid'});
		my $vstatusid = $sow->{'VSTATUSID_END'};
		$vstatusid = $sow->{'VSTATUSID_SCRAPEND'} if ($vi->{'vstatus'} eq $sow->{'VSTATUSID_SCRAP'});
		$vindex->updatevindex($vil, $vstatusid);
		$vindex->closevindex();
	} else {
		# ���O�E�����f�[�^�t�@�C���̍쐬
		my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 1);
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
		my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 1);

		my $winner = 0;
		if ($scrapvil == 0) {
			&UpdateGM($sow, $vil, $logfile);

			# �l�T���o�͂͂Ƃ肠�����i�V�B�߂ǂ��B

			# ��������
			$winner = &WinnerCheckGM($sow, $vil);
		}

		if (($winner > 0) || ($scrapvil > 0)) { # �Q�[���I��
			# �I�����b�Z�[�W
			my $epinfo = $vil->getTextByID('ANNOUNCE_WINNER',$winner);
			$epinfo .= '<br>'. $vil->getText('ANNOUNCE_WINNER_DISH') if (0 < $vil->{'wincnt_dish'});
			$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $epinfo);

			# �z���ꗗ
			$logfile->writeinfo('', $sow->{'MESTYPE_CAST'}, '*CAST*');

			# ���ꗗ���̍X�V
			my $vstatusid = $sow->{'VSTATUSID_EP'};
			$vstatusid = $sow->{'VSTATUSID_SCRAP'} if ($winner == 0);
			require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
			my $vindex = SWFileVIndex->new($sow);
			$vindex->openvindex();
			$vindex->updatevindex($vil, $vstatusid);
			$vindex->closevindex();

			$vil->{'winner'} = $winner;
			$vil->{'epilogue'} = $vil->{'turn'};
			&EventReset($sow, $vil, $logfile);
		} else {
			if ($vil->{'turn'} == 2) {
				# �Q���ڊJ�n�A�i�E���X
				my $announce_first = $vil->getTextByID('ANNOUNCE_FIRST',2);
				$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $announce_first );
			}

			# �����̔���
			&EventGM($sow, $vil, $logfile);

			# �蔲���B���̂����������B
			require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
			my $vindex = SWFileVIndex->new($sow);
			$vindex->openvindex();
			$vindex->updatevindex($vil, $sow->{'VSTATUSID_PLAY'});
			$vindex->closevindex();
		}
		# ������������
		$vil->setsaycountall();

		# �������[��̐ݒ�
		&SetInitVoteTarget($sow, $vil, $logfile);

		$logfile->close();
		$memofile->close();
	}
	$vil->writevil();

	my $nextupdatedt = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Update Session. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, next=$nextupdatedt]");

	return;
}

1;
