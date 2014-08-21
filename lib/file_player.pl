package SWPlayer;

#----------------------------------------
# �v���C���[�f�[�^
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow => $sow,
	};

	return bless($self, $class);
}

#----------------------------------------
# �v���C���[�f�[�^���x��
#----------------------------------------
sub getdatalabel {
	my @datalabel = (
		'uid',
		'cid',
		'csid',
		'jobname',
		'gift',
		'role',
		'rolestate',
		'rolesubid',
		'selrole',
		'sheep',
		'live',
		'deathday',
		'overhear',
		'say',
		'tsay',
		'spsay',
		'wsay',
		'xsay',
		'gsay',
		'say_act',
		'actaddpt',
		'saidcount',
		'saidpoint',
		'countinfosp',
		'countthink',
		'entrust1',
		'vote1',
		'vote2',
		'role1',
		'role2',
		'gift1',
		'gift2',
		'entrust',
		'entrusted',
		'bonds',
		'love',
		'pseudobonds',
		'pseudolove',
		'commit',
		'entrieddt',
		'limitentrydt',
		'lastwritepos',
		'history',
		'modified',
		'savedraft',
		'draftmestype',
		'draftmspace',
		'postfix',
		'zapcount',
		'clearance',
	);

	return @datalabel;
}

#----------------------------------------
# �v���C���[�f�[�^�̐V�K�쐬
#----------------------------------------
sub createpl {
	my ($self, $uid) = @_;

	$self->{'uid'}          = $uid;
	$self->{'live'}         = 'live';
	$self->{'deathday'}     = -1;
	$self->{'gift'}         = -1;
	$self->{'role'}         = -1;
	$self->{'rolestate'}    = -1;
	$self->{'rolesubid'}    = -1;
	$self->{'jobname'}      = '';
	$self->{'entrust'}      = 0;
	$self->{'entrusted'}    = 1;
	$self->{'entrust1'}     = 0;
	$self->{'vote1'}        = 0;
	$self->{'vote2'}        = 0;
	$self->{'role1'}        = 0;
	$self->{'role2'}        = 0;
	$self->{'gift1'}        = 0;
	$self->{'bonds'}        = '',
	$self->{'love'}         = '',
	$self->{'history'}      = '';
	$self->{'saidcount'}    = 0;
	$self->{'saidpoint'}    = 0;
	$self->{'countinfosp'}  = 0;
	$self->{'countthink'}   = 0;
	$self->{'delete'}       = 0;
	$self->{'entrieddt'}    = $self->{'sow'}->{'time'};
	$self->{'limitentrydt'} = 0;
	$self->{'modified'}     = 0;
	$self->{'savedraft'}    = '';
	$self->{'draftmestype'} = 0;
	$self->{'draftmspace'}  = 0;
	$self->{'postfix'}      = '';
	$self->{'overhear'}     = -1;
	$self->{'zapcount'}     = 0;
	$self->{'clearance'}    = 1;

	# �ꎞ�I��ԁi���̖�̂ݗL���ȓ��e�j�������ŏ������B
	$self->{'tmp_suicide'}   = -1;
	$self->{'tmp_rolestate'} = -1;
	return;
}

#----------------------------------------
# �v���C���[�f�[�^�̓ǂݍ���
#----------------------------------------
sub readpl {
	my ($self, $datalabel, $data) = @_;
	$self->createpl('');
	@$self{@$datalabel} = split(/<>/, $data);

	my @datalabelnew = $self->getdatalabel();
	foreach (@datalabelnew) {
		$self->{$_} = '' if ($self->{$_} eq $self->{'sow'}->{'DATATEXT_NONE'});
	}

	my $sow = $self->{'sow'};
	$self->{'delete'}  = 0;

	return;
}

#----------------------------------------
# �v���C���[�f�[�^�̏�������
#----------------------------------------
sub writepl {
	my ($self, $fh) = @_;
	my $sow = $self->{'sow'};

	my $none = $sow->{'DATATEXT_NONE'};

	my @datalabel = $self->getdatalabel();
	foreach (@datalabel) {
		$self->{$_} = $none if ($self->{$_} eq '');
	}

	print $fh join("<>", map{$self->{$_}}@datalabel). "<>\n";
	foreach (@datalabel) {
		$self->{$_} = '' if ($self->{$_} eq $none);
	}
}

sub define_delay {
	my ($self) = @_;
	my $vil = $self->{'vil'};

	# ��Ԋm��B
	if ($self->{'delay_rolestate'} != $self->{'rolestate'}){
		$self->{'rolestate'} = $self->{'delay_rolestate'};
	}

	# �����m��B
	if ($self->{'delay_live'} ne $self->{'live'}){
		$self->{'live'} = $self->{'delay_live'};
		if( $self->{'live'} eq 'live' ){
			$self->{'deathday'} = -1;
		} else {
			$self->{'deathday'} = $vil->{'turn'};
		}
	}
}

#----------------------------------------
# �������[��^�\�͑Ώۂ̐ݒ�
#----------------------------------------
sub setTarget {
	my ($self, $targethd, $targetno, $turn, $logfile, $srctargetpno) = @_;

	my $sow = $self->{'sow'};
	my $cfg = $sow->{'cfg'};

	my $targetid = $targethd . $targetno;
	my $targetlist = $self->gettargetlist($targethd, $turn, $srctargetpno);
	if (@$targetlist == 0) {
		# �Ώی�₪���݂��Ȃ�
		$self->{$targetid} = $sow->{'TARGETID_TRUST'};
		$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, $self->getlongchrname() . "�̑Ώ�($targetid)��₪����܂���B");
	} else {
		$self->{$targetid} = $targetlist->[int(rand(@$targetlist))]->{'pno'};
	}
}

sub setInitTarget {
	my ($self, $targethd, $targetno, $logfile, $srctargetpno) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $cfg = $sow->{'cfg'};
	$self->setTarget($targethd, $targetno, $vil->{'turn'}, $logfile, $srctargetpno);

	# �l�T�A�h�؁A�����̓f�t�H���g���p�X�B
	# �������A�����̖�E�����o���Ă���Ƃ������B
	my $trusttarget = 0;
	if ( $self->issensible() ){
		$trusttarget = 1 if (($vil->{'turn'} > 1)&&($self->iskiller($targethd)));
		$trusttarget = 1 if (($targethd eq 'role')&&($self->{'role'} == $sow->{'ROLEID_SNATCH'   }));
		$trusttarget = 1 if (($targethd eq 'role')&&($self->{'role'} == $sow->{'ROLEID_WITCH'    }));
		$trusttarget = 1 if (($targethd eq 'role')&&($self->{'role'} == $sow->{'ROLEID_WALPURGIS'}));
	}
#	$trusttarget = 0;

	my $targetid = $targethd . $targetno;

	# ���E���[���f�t�H���g�ݒ�ɂ���ꍇ�B
	if ((1 == $cfg->{'ENABLED_SUICIDE_VOTE'})&&($vil->{'mob'} ne 'juror')){
		$trusttarget = 2 if ($targethd eq 'vote');
	}
	if ($trusttarget == 1){
		$self->{$targetid} = $sow->{'TARGETID_TRUST'}; # ���܂���
	}
	if ($trusttarget == 2){
		$self->{$targetid} = $self->{'pno'};
	}
	return;
}

#----------------------------------------
# �\�͑Ώۃ����_�������i�P�Ɓj
#----------------------------------------
sub setRandomTarget {
	my ($self, $targethd, $targetno, $abi_role,$logfile, $srctargetpno) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $cfg = $sow->{'cfg'};

	my $targetid = $targethd . $targetno;

	return if (( 1 < $targetno )&&( '' eq $self->gettargetlabel($targethd,$vil->{'turn'}-1) ));
	$self->setTarget($targethd, $targetno, $vil->{'turn'}-1, $logfile, $srctargetpno);

	return if ( $self->{$targetid} == $sow->{'TARGETID_TRUST'} );
	$targetpl = $vil->getplbypno($self->{$targetid});

	# ���O��������
	my $ability    = $self->getlabel($targethd);
	my $targetname = $targetpl->getchrname();
	my $randomtext = $self->getText('SETRANDOMTARGET');
	$randomtext =~ s/_ABILITY_/$ability/g;
	$randomtext =~ s/_TARGET_/$targetname/g;
	$logfile->writeinfo($self->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $randomtext);

	return $targetpl;
}

#----------------------------------------
# ������������
#----------------------------------------
sub setsaycount {
	my $self   = shift;
	my $vil    = $self->{'vil'};
	my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	$self->{'tsay'}         = $saycnt->{'MAX_TSAY'};
	$self->{'wsay'}         = $saycnt->{'MAX_WSAY'};
	$self->{'spsay'}        = $saycnt->{'MAX_SPSAY'};
#	$self->{'xsay'}         = $saycnt->{'MAX_XSAY'};
	$self->{'say_act'}      = $saycnt->{'MAX_SAY_ACT'};
	$self->{'saidcount'}    = 0;
	$self->{'saidpoint'}    = 0;
	$self->{'actaddpt'}     = $saycnt->{'MAX_ADDSAY'};
	$self->{'countinfosp'}  = 0;
	$self->{'countthink'}   = 0;
	$self->{'commit'}       = 0;
	$self->{'entrust'}      = 0;
	$self->{'lastwritepos'} = -1;

	if ($vil->isepilogue() > 0) {
		$self->{'say'}      = $saycnt->{'MAX_ESAY'};
		$self->{'gsay'}     = $saycnt->{'MAX_ESAY'};
	} elsif ($vil->{'turn'} == 0) {
		$self->{'say'}      = $saycnt->{'MAX_PSAY'};
		$self->{'gsay'}     = $saycnt->{'MAX_PSAY'};
	} else {
		$self->{'say'}      = $saycnt->{'MAX_SAY'};
		$self->{'gsay'}     = $saycnt->{'MAX_GSAY'};
	}

	return;
}

#----------------------------------------
# ��������
#----------------------------------------
sub chargesaycount {
	my $self   = shift;
	my $vil    = $self->{'vil'};
	my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	$self->{'tsay'}     += $saycnt->{'MAX_TSAY'};
	$self->{'wsay'}     += $saycnt->{'MAX_WSAY'};
	$self->{'spsay'}    += $saycnt->{'MAX_SPSAY'};
#	$self->{'xsay'}     += $saycnt->{'MAX_XSAY'};
	$self->{'say_act'}  += $saycnt->{'MAX_SAY_ACT'};
	$self->{'actaddpt'} += $saycnt->{'MAX_ADDSAY'};

	if ($vil->isepilogue() > 0) {
		$self->{'say'}      += $saycnt->{'MAX_ESAY'};
		$self->{'gsay'}     += $saycnt->{'MAX_ESAY'};
	} elsif ($vil->{'turn'} == 0) {
		$self->{'say'}      += $saycnt->{'MAX_PSAY'};
		$self->{'gsay'}     += $saycnt->{'MAX_PSAY'};
	} else {
		$self->{'say'}      += $saycnt->{'MAX_SAY'};
		$self->{'gsay'}     += $saycnt->{'MAX_GSAY'};
	}

	return;
}

#----------------------------------------
# �^�����J��ǉ�����
#----------------------------------------
sub addbondlist {
	my ($self, $target,$bonds) = @_;

	my $isbond = 0;
	my @bonds = split('/', $self->{$bonds});

	foreach(@bonds) {
		$isbond = 1 if ($_ == $target);
	}

	# �J��ǉ�
	if ($isbond == 0) {
		push( @bonds, $target );
		$self->{$bonds} = join('/', @bonds);
	}
}
sub addbond {
	my ($self, $target) = @_;

	$self->addbondlist($target,'bonds')
}
sub addpseudobond {
	my ($self, $target) = @_;

	$self->addbondlist($target,'pseudobonds')
}

#----------------------------------------
# �������𑝂₷�i�����j
#----------------------------------------
sub addsaycount {
	my $self = shift;
	my $vil    = $self->{'vil'};
	my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	$self->{'say'}  += $saycnt->{'ADD_SAY'};
	$self->{'gsay'} += $saycnt->{'ADD_SAY'};
	return;
}

#----------------------------------------
# history�����M����
#----------------------------------------
sub addhistory {
	my ($self,$result) = @_;
	return if ("" eq $result);
	if ( index($self->{'history'},$result) < 0 ){
		$self->{'history'} .= $result."<br>";
	}
	return;
}

#----------------------------------------
# �N���[���i���o�[�𑝂₷�iZAP�j
#----------------------------------------
sub zap {
	my $self = shift;
	$self->{'postfix'} -= 1;
	return;
}

#----------------------------------------
# �J�̏��擾
#----------------------------------------
sub getbondlist {
	my ($self) = @_;
	my $bonds = $self->{'bonds'};

	return  split('/', $bonds );
}
sub getpseudobondlist {
	my ($self) = @_;
	my $bonds = $self->{'pseudobonds'};

	return  split('/', $bonds );
}

sub getallbondlist {
	my ($self) = @_;
	my $bonds = $self->all_bonds_str();

	return  split('/', $bonds );
}

#----------------------------------------
# ���[�^�\�͑Ώی��̃��X�g���擾�i���܂�������j
#----------------------------------------
sub gettargetlist {
	my ($self, $cmd, $turn, $targetpno) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $cfg = $sow->{'cfg'};

	my @bonds = $self->getallbondlist();
	my @targetlist;

	# ���o�̂Ȃ��ꍇ�B�X�C�b�`�I���ŁA�����̂Ƃ��B
	my $sensible = $self->issensible();

	# �V��E�̂��߁A�P����ȊO�ł����܂�����F�߂�
	my $abstain = 1;
#	$abstain = 0 if (($vil->{'debug'} == 1 ));
	# ���[�ɂ͂��C����F�߂Ȃ��B
	$abstain = 0 if (($cmd eq 'vote'));
	$abstain = 0 if (($cmd eq 'entrust'));
	if (($cmd eq 'role')&&($turn == 1)){
	# �P���ځA��q�A���Y�d���A�P���ɂ͂��C����F�߂Ȃ��B
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_PASSION'}  ));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_LOVER'}    ));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_TRICKSTER'}));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_LOVEANGEL'}));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_HATEDEVIL'}));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_BITCH'}    ));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_LONEWOLF'} ));
		$abstain = 0 if (($self->iskiller('role')                      ));
	}
	if (($cmd eq 'gift')){
	# �Q���ڈȍ~�A���̗ւ͂��C����F�߂Ȃ��B
    # �����͂��C����F�߂Ȃ��B
		$abstain = 0 if (($turn  > 1)&&($self->{'gift'} == $sow->{'GIFTID_SHIELD'}));
		$abstain = 0 if (              ($self->{'gift'} == $sow->{'GIFTID_GLASS'} ));
		$abstain = 0 if (($turn == 1)&&($self->iskiller('gift')                   ));
	}
	if ( $abstain > 0 ){
		my %target = (
			chrname => $sow->{'textrs'}->{'UNDEFTARGET'},
			pno     => $sow->{'TARGETID_TRUST'},
		);
		push(@targetlist, \%target);
	}

	# �\�͎g�p���ȊO�́A�p�X�ȊO�I�ׂȂ��B
	return \@targetlist if (($cmd eq 'entrust')&&($self->isEnableVote($turn) == 0));
	return \@targetlist if (($cmd eq 'vote'   )&&($self->isEnableVote($turn) == 0));
	return \@targetlist if (($cmd eq 'role'   )&&($self->isEnableRole($turn) == 0));
	return \@targetlist if (($cmd eq 'gift'   )&&($self->isEnableGift($turn) == 0));

	# ���o�̂Ȃ��ꍇ�A���ʈ��������͂��Ȃ��B
	# �����̔\�͂̏ꍇ
	if (($cmd eq 'role')&&(1 == $sensible)){
		return \@targetlist if ($self->isDisableState('MASKSTATE_ABI_ROLE'));
		if (($self->{'role'} == $sow->{'ROLEID_GIRL'}     )
		  ||($self->{'role'} == $sow->{'ROLEID_ALCHEMIST'})
		  ||($self->{'role'} == $sow->{'ROLEID_DISH'}     )){
			my %target = (
				chrname => '(����)',
				pno     => $self->{'pno'},
			);
			push(@targetlist, \%target);
			return \@targetlist;
		}
	}
	if (($cmd eq 'role')&&(0 == $sensible)){
		my %target = (
			chrname => '�i�Ƃ�ɂȂ�j',
			pno     => $self->{'pno'},
		);
		push(@targetlist, \%target);
	}

	my $livepl;
	# �l���n���F�J������ƁA�J�̑���݂̂ɓ��[
	# �Ўv���́A�v���Ă鑤���v���Ă鑤�����I�ׂȂ��Ȃ�B
	# �s������A�����̂�������B
	if ( $vil->{'event'} == $sow->{'EVENTID_APRIL_FOOL'} ){
		my @bondpno = $self->getallbondlist();
		if ($cmd eq 'vote'){
			if ( 0 < scalar(@bondpno) ){
				foreach $pno (@bondpno) {
					$livepl = $vil->getplbypno($pno);
					my $postfix = '';
					$postfix = '(�̐l)' if ($livepl->{'live'} ne 'live');
					my %target = (
						chrname => $livepl->getlongchrname().$postfix,
						pno     => $pno,
					);
					push(@targetlist, \%target);
				}
				return \@targetlist;
			}
		}
	}

	my $pllist = $vil->getpllist();
	# ����ȊO
	foreach $livepl (@$pllist) {
		next if ($livepl->{'live'} eq 'mob');        # �����l�͔\�́A���[�̑Ώۂł͂Ȃ��B
		next if ($livepl->{'live'} eq 'suddendead'); # �ˑR���҂͔\�́A���[�̑Ώۂł͂Ȃ��B
		next if ((defined($targetpno)) && ($livepl->{'pno'} == $targetpno)); # ���ΏۂƓ����ꍇ�͏��O
		# ���o�̂Ȃ��ꍇ�A���ʈ��������͂��Ȃ��B
		if ((0 == $sensible)&&($cmd eq 'role')){
			next if ($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
			next if ($livepl->{'pno'} eq $self->{'pno'});
		} elsif ($cmd eq 'role'){
			if (($self->{'role'} == $sow->{'ROLEID_WITCH' })
			  ||($self->{'role'} == $sow->{'ROLEID_WALPURGIS' })) {
				next if ( $self->isDisableState('MASKSTATE_ABI_ROLE') );
				next if (($self->isDisableState('MASKSTATE_ABI_LIVE') )&&($livepl->{'live'} ne 'live'));
				next if (($self->isDisableState('MASKSTATE_ABI_KILL') )&&($livepl->{'live'} eq 'live'));
				next if (($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'})); # �_�~�[�͓���̑Ώۂɂ��Ȃ��B
			} elsif ($self->{'role'} == $sow->{'ROLEID_TANGLE'}) {
				next if ($livepl->{'live'} eq 'live');
				next if (($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'})); # �_�~�[�͓���̑Ώۂɂ��Ȃ��B
			}else{
				next if ($livepl->{'live'} ne 'live');
			}

			if (($self->{'role'} == $sow->{'ROLEID_LONEWOLF'})) {
				next if (($turn == 1) && ($livepl->{'uid'} ne $sow->{'cfg'}->{'USERID_NPC'})); # �P���ڂ̏P���Ώۂ̓_�~�[�L�����̂�
			}
			if (($self->{'role'} == $sow->{'ROLEID_GURU'})) {
				next if ($livepl->{'sheep'} eq 'pixi'); # ���U�ςݑΏۂ͏��O
			}
			if (($self->{'role'} == $sow->{'ROLEID_TRICKSTER'})
			  ||($self->{'role'} == $sow->{'ROLEID_LOVEANGEL'})
			  ||($self->{'role'} == $sow->{'ROLEID_HATEDEVIL'})) {
				# �s�N�V�[�̑Ώۂɂ̓_�~�[�L�������܂܂Ȃ�
				next if ($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
			} elsif (($self->{'role'} == $sow->{'ROLEID_BITCH' })
				   ||($self->{'role'} == $sow->{'ROLEID_TANGLE'})){
				# �V�ѐl�A����̑Ώۂɂ̓_�~�[�A�������g���܂܂Ȃ��B
				next if ($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
				next if (($livepl->{'uid'} eq $self->{'uid'}));
			} else {
				# �ȊO�ł́A�ΏۂɎ������g���܂܂Ȃ��B
				next if (($livepl->{'uid'} eq $self->{'uid'}));
			}
		}
		if (($cmd eq 'gift')) {
			next if ($livepl->{'live'} ne 'live');
			next if (($livepl->{'uid'} eq $self->{'uid'}));
			if (($self->{'gift'} == $sow->{'GIFTID_SEERONCE'})) {
				next if ( $self->isDisableState('MASKSTATE_ABI_GIFT') );
			}
		}
		if (($cmd eq 'vote') or ($cmd eq 'entrust')) {
			next if (($vil->{'scapegoat'} > 0)
                   &&($livepl->{'pno'} != $vil->{'scapegoat'})
                   &&($self->{'pno'}   != $vil->{'scapegoat'})
                   );
			next if ( $livepl->isDisableState('MASKSTATE_VOTE_TARGET') );
			next if ( $livepl->{'live'} ne 'live');
			next if ( $livepl->{'uid'}  eq $self->{'uid'});
			# �ϔC�̎��͎������I�ׂ��獢��B�Ƃ�����̂ŁB
			# �ł����ՂɁA���E�[�̂Ƃ��͑I�����Ɂu*�v�����Ȃ��B
		}

		# ���ꂪ�P���t�H�[���Ȃ�
		if ( $self->iskiller($cmd) ) {
			next if (($turn == 1) && ($livepl->{'uid'} ne $sow->{'cfg'}->{'USERID_NPC'})); # �P���ڂ̏P���Ώۂ̓_�~�[�L�����̂�
			my $knight = 0;
			$knight = 1	if ($vil->{'game'} eq 'TROUBLE');
			$knight = 1	if ($vil->{'game'} eq 'SECRET');
			$knight = 1 if (($cmd eq 'role')&&($self->{'role'} == $sow->{'ROLEID_HEADLESS'}));
			if (0 == $knight){
				next if ( $livepl->{'role'} == $sow->{'ROLEID_MIMICRY'}); # �[�T�d���͏��O
				next if ( $livepl->iskiller('gift'));
				next if ( $livepl->iskiller('role'));
			}
		}

		my $postfix = '';
		$postfix = '(�̐l)' if ($livepl->{'live'} ne 'live');
		my %target = (
			chrname => $livepl->getlongchrname().$postfix,
			pno     => $livepl->{'pno'},
		);
		push(@targetlist, \%target);
	}

	if ( 0 == scalar(@targetlist) ){
		$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, $self->getlongchrname() . "�̑Ώی�₪����܂���B");
		my %target = (
			chrname => $sow->{'textrs'}->{'UNDEFTARGET'},
			pno     => $sow->{'TARGETID_TRUST'},
		);
		push(@targetlist, \%target);
	}
	return \@targetlist;
}

#----------------------------------------
# ���[�^�\�͑Ώی��̃��X�g���擾
# �i�����_������j
#----------------------------------------
sub gettargetlistwithrandom {
	my ($self, $cmd) = @_;
	my $sow  = $self->{'sow'};
	my $vil  = $self->{'vil'};
	my $turn = $self->{'vil'}->{'turn'};
	my $targetlist = $self->gettargetlist($cmd, $turn);
	my $randomtarget = @$targetlist;

	# �����_��
	$randomtarget = 0 if ($vil->{'randomtarget'} == 0); # ���ݒ肪�����_���֎~
	# ���o�̂��鏭���̂悠���тɂ̓����_����F�߂Ȃ��B�i�Ӗ����Ȃ��j
	if (($cmd eq 'role')&&($self->issensible())){
		$randomtarget = 0 if ($self->{'role'} == $sow->{'ROLEID_GIRL'});
		$randomtarget = 0 if ($self->{'role'} == $sow->{'ROLEID_ALCHEMIST'});
		$randomtarget = 0 if ($self->{'role'} == $sow->{'ROLEID_DISH'});
	}

	# �P���ڂ̏P���Ώۂ̓_�~�[�L�����̂�
	$randomtarget = 0 if (($self->iskiller($cmd))&&($turn == 1));
	if ($randomtarget > 0) {
		my %randomtarget = (
			chrname => $sow->{'textrs'}->{'RANDOMTARGET'},
			pno     => $sow->{'TARGETID_RANDOM'},
		);
		unshift(@$targetlist, \%randomtarget);
	}

	return $targetlist;
}

#----------------------------------------
# �L�����̖��O���擾����
#----------------------------------------
sub getrolename {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	my $giftname = $sow->{'textrs'}->{'GIFTNAME'}->[$self->{'gift'}];
	my $rolename = $sow->{'textrs'}->{'ROLENAME'}->[$self->{'role'}];
	$rolename = $sow->{'textrs'}->{'ROLENAME'}->[$sow->{'ROLEID_VILLAGER'}] if ($self->{'role'} == $sow->{'ROLEID_RIGHTWOLF'});
	$rolename = ''                             if (($self->issensible() == 0)||($self->{'role'} == 0));
	$rolename .= "�A".$giftname  if ($self->{'gift'} > $sow->{'GIFTID_NOT_HAVE'});;
	return $rolename;
}


sub getchrname {
	my $self = shift;
	return $self->getshortchrname();
}

sub getlongchrname {
	my $self = shift;
	my $clearance = ('IR-','R-','O-','Y-','G-','B-','I-','V-','UV-')[$self->{'clearance'}] if( $self->{'postfix'} < 0  );
	return $self->{'sow'}->{'charsets'}->getchrname($self->{'csid'}, $self->{'cid'}, $self->{'jobname'}, $clearance, $self->{'postfix'});
}

sub getshortchrname {
	my $self = shift;
	my $clearance = ('IR-','R-','O-','Y-','G-','B-','I-','V-','UV-')[$self->{'clearance'}] if( $self->{'postfix'} < 0 );
	return $self->{'sow'}->{'charsets'}->getshortchrname($self->{'csid'}, $self->{'cid'}, $clearance, $self->{'postfix'});
}

sub getText {
	my ($self, $text) = @_;
	my $vil = $self->{'vil'};
	my $chrname = $self->getchrname();
	my $result  = $vil->getText($text);
	$result =~ s/_NAME_/$chrname/;

	return $result;
}

sub getTextByID {
	my ($self, $text, $id) = @_;
	my $vil = $self->{'vil'};
	my $chrname = $self->getchrname();
	my $result  = $vil->getTextByID($text,$id);
	$result =~ s/_NAME_/$chrname/;

	return $result;
}

#----------------------------------------
# �����{�^��
#----------------------------------------
sub getsaybuttonlabel {
	my ($self, $vil, $caption_say, $caption_gsay, $buttonlabel) = @_;
	my $live = $vil->ispublic($self);
	$caption_say = $caption_gsay if ($live == 0);
	$buttonlabel =~ s/_BUTTON_/$caption_say/g;
	return $buttonlabel;
}

sub getchoice {
	my ($self, $cmd) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

    my $choice = '';
	if      ( $cmd eq 'entrust'){
		$choice = "* " if( 0 != $self->{'entrust'});
		return $choice;

	} elsif ( $cmd eq 'vote' ){
		$choice = "* " if( 0 == $self->{'entrust'});
		return $choice;
	} elsif ( $cmd eq 'role' ){
		$choice = "* ";
		return $choice ;
	} elsif ( $cmd eq 'gift' ){
		$choice = "* ";
		return $choice ;
	} else {
		return "";
	}
	return $votelabel;
}

sub getlabel {
	my ($self, $cmd) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	if      ( $cmd eq 'entrust'){
		return $sow->{'textrs'}->{'VOTELABELS'}->[1] ;

	} elsif ( $cmd eq 'vote' ){
		return $sow->{'textrs'}->{'VOTELABELS'}->[0] ;
	} elsif ( $cmd eq 'role' ){
		if ( $self->issensible() ){
			return $sow->{'textrs'}->{'ABI_ROLE'}->[$self->{'role'}] ;
		} else {
			return $sow->{'textrs'}->{'ABI_ROLE'}->[0] ;
		}
	} elsif ( $cmd eq 'gift' ){
		return $sow->{'textrs'}->{'ABI_GIFT'}->[$self->{'gift'}];
	} else {
		return "";
	}
	return $votelabel;
}

#----------------------------------------
# 2�l�I��\�͂̃��x��
#----------------------------------------
sub gettargetlabel {
	my ($self, $cmd, $turn) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $abi_vote = $sow->{'textrs'}->{'VOTELABELS'};
	my $abi_role = $sow->{'textrs'}->{'ABI_ROLE'};
	my $abi_gift = $sow->{'textrs'}->{'ABI_GIFT'};

	my $targetlabel = '';

	# ���[�ɂ��āB
	if ($vil->{'riot'} == $turn) {
		$targetlabel = $abi_vote->[0]               if (($cmd eq 'vote'));
		$targetlabel = $abi_gift->[$self->{'gift'}] if (($cmd eq 'gift')&&($self->{'gift'} == $sow->{'GIFTID_DECIDE'} ));
	}
	if ($cmd eq 'role') {
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_TRICKSTER'} );
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_LOVEANGEL'} );
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_HATEDEVIL'} );
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_BITCH'}     );
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_GURU'}      );
	}
	# �P���t�H�[���ɂ���
	if (($self->iskiller($cmd))&&($vil->{'grudge'} == $turn)) {
		$targetlabel = $abi_gift->[$self->{'gift'}] if ($cmd eq 'gift');
		$targetlabel = $abi_role->[$self->{'role'}] if ($cmd eq 'role');
	}

	return $targetlabel;
}

#----------------------------------------
# �����\������
#----------------------------------------
sub setfriends {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	my $sense_fm       = $vil->getrolepllist($sow->{'ROLEID_FM'});
	my $sense_sympathy = $vil->getrolepllist($sow->{'ROLEID_SYMPATHY'});
	my $sense_bat      = $vil->getrolepllist($sow->{'ROLEID_BAT'});
	my $sense_fanatic  = $vil->getrolepllist($sow->{'ROLEID_FANATIC'});
	my $sense_mob      = $vil->getmobpllist();

	# ���L�ҏ���
	if( $self->{'role'} == $sow->{'ROLEID_FM'} ){
		$self->result_friend('RESULT_MEMBER', $sense_fm);
		$self->result_friend('RESULT_MEMBER', $sense_sympathy);
	}
	# ���ҏ���
	if( $self->{'role'} == $sow->{'ROLEID_SYMPATHY'} ){
		$self->result_friend('RESULT_MEMBER', $sense_fm);
		$self->result_friend('RESULT_MEMBER', $sense_sympathy);
	}

	# ���M�ҏ���
	if( ( $self->iskiller('role')+$self->iskiller('gift') )
	  ||( $self->{'role'} == $sow->{'ROLEID_RIGHTWOLF'}   )
	  ||( $self->{'role'} == $sow->{'ROLEID_MIMICRY'}     ) ){
		$self->result_friend('RESULT_FANATIC', $sense_fanatic);
	}

	# �����ɂނ��āA�S�����C�z�𔭂���B
	if($vil->{'mob'} eq 'gamemaster'){
		$self->result_friend('RESULT_SECRET', $sense_mob);
	}
}

sub result_friend {
	my ($self, $basetext, $senses) = @_;
	my $sow = $self->{'sow'};
	my $textrs = $sow->{'textrs'};
	my $rolename = $textrs->{'ROLENAME'};
	my $giftname = $textrs->{'GIFTNAME'};

	my $chrrole = $rolename->[$self->{'role'}];
	my $chrrolegift = $chrrole;
	$chrrolegift .= "�A" . $giftname->[$self->{'gift'}] if ($self->{'gift'} >= $sow->{'SIDEST_DEAL'});

	my $sense;
	foreach $sense (@$senses) {
		next if ($self->{'uid'} eq $sense->{'uid'});
		next if ( $self->isDisableState('MASKSTATE_ABI_ROLE') );
		# �Z���T�[�����͂��ׂĖ�E�Ȃ̂ŁA����ł����B
		my $result  = $self->getText($basetext);
		$result =~ s/_ROLE_/$chrrole/g;
		$result =~ s/_ROLEGIFT_/$chrrolegift/g;
		$sense->{'history'} .= "$result<br>";
	}
}

sub rolemessage {
	my ($self, $mes) = @_;

	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $textrs = $sow->{'textrs'};

	if ($self->{'role'} == $sow->{'ROLEID_STIGMA'}) {
		# �����ҏ���
		my $stigma_subid = $textrs->{'STIGMA_SUBID'};
		if ($self->{'rolesubid'} >= 0) {
			my $color = $stigma_subid->[$self->{'rolesubid'}];
			$mes =~ s/_ROLESUBID_/$color/g;
		} else {
			$mes =~ s/_ROLESUBID_//g;
		}
	}
	return $vil->Tag2Text($mes);
}

sub win_if {
	my ($self) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $cfg = $sow->{'cfg'};

	my $isjuror = (('mob' eq $self->{'live'} )&&($vil->{'mob'} eq 'juror'));
	my $ismob   = (('mob' eq $self->{'live'} )&&($vil->{'mob'} ne 'juror'));

	my $winner = 'WIN_NONE';
	# ��C�T�w�c�́A�l�T�w�c�����D�悷�鏟������
	# ��C�T�͖�E�Ȃ̂ŁA���b�A���ł̂�������肪��������B
	# �؋��l�͖�E�Ȃ̂ŁA���b�A���ł̂�������肪��������B
	# ���͊������������B��ʂɏ��Ȃ��l���ɂȂ邾�낤�w�c��D�悷��B
	$winner = 'WIN_LOVER'    if ( $self->{'role'} == $sow->{'ROLEID_LOVEANGEL'} );
	$winner = 'WIN_HATER'    if ( $self->{'role'} == $sow->{'ROLEID_HATEDEVIL'} );
	$winner = 'WIN_LONEWOLF' if ( $self->{'role'} == $sow->{'ROLEID_LONEWOLF'}  );
	$winner = 'WIN_DISH'     if ( $self->{'role'} == $sow->{'ROLEID_DISH'}  );
	$winner = 'WIN_GURU'     if ( $self->{'role'} == $sow->{'ROLEID_GURU'}  );
	$winner = 'WIN_HUMAN'    if ( $self->ishuman() );
	$winner = 'WIN_EVIL'     if (($self->isenemy() )&&($cfg->{'ENABLED_AMBIDEXTER'} == 1));
	$winner = 'WIN_WOLF'     if (($self->isenemy() )&&($cfg->{'ENABLED_AMBIDEXTER'} != 1));
	$winner = 'WIN_WOLF'     if (($self->iswolf()  )&&($self->{'role'} != $sow->{'ROLEID_LONEWOLF'}));
	$winner = 'WIN_PIXI'     if ( $self->ispixi()  );
	$winner = 'WIN_WOLF'     if (('TROUBLE' eq $vil->{'game'})&&($self->isDisableState('MASKSTATE_ZOMBIE')));
	$winner = 'WIN_LOVER'    if ( $self->{'love'} eq 'love' );
	$winner = 'WIN_HATER'    if ( $self->{'love'} eq 'hate' );
	$winner = 'WIN_HUMAN'    if ( $isjuror );
	return $winner;
}

sub win_visible {
	my ($self) = @_;

	my $winner = $self->win_if();
	$winner = 'WIN_LOVER'    if ( $self->{'pseudolove'} eq 'love' );
	$winner = 'WIN_HATER'    if ( $self->{'pseudolove'} eq 'hate' );
	return $winner;
}

sub winresult {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $win_if = $self->win_if();

	my $isdeadlose = 0;
	$isdeadlose = 1 if ('LIVE_TABULA'       eq $vil->{'game'});
	$isdeadlose = 1 if ('LIVE_MILLERHOLLOW' eq $vil->{'game'});
	$isdeadlose = 1 if ('SECRET'            eq $vil->{'game'});
	$isdeadlose = 1 if (('TROUBLE'          eq $vil->{'game'})&&($win_if eq 'WIN_HUMAN'));
	$isdeadlose = 1 if (($win_if eq 'WIN_LONEWOLF'));
	$isdeadlose = 1 if (($win_if eq 'WIN_PIXI'    ));
	$isdeadlose = 1 if (($win_if eq 'WIN_HATER'   )&&( $self->{'role'} != $sow->{'ROLEID_HATEDEVIL'} ));
	my $islonelose = 0;
	$islonelose = 1 if (($win_if eq 'WIN_LOVER'   )&&( $self->{'role'} != $sow->{'ROLEID_LOVEANGEL'} ));

	my $result = '�s�k';
	$result = '����' if (($win_if eq 'WIN_HUMAN'   )&&( $sow->{'WINNER_HUMAN'}    == $vil->{'winner'} ));
	$result = '����' if (($win_if eq 'WIN_WOLF'    )&&( $sow->{'WINNER_WOLF'}     == $vil->{'winner'} ));
	$result = '����' if (($win_if eq 'WIN_GURU'    )&&( $sow->{'WINNER_GURU'}     == $vil->{'winner'} ));
	$result = '����' if (($win_if eq 'WIN_PIXI'    )&&( $sow->{'WINNER_PIXI_H'}   == $vil->{'winner'} ));
	$result = '����' if (($win_if eq 'WIN_PIXI'    )&&( $sow->{'WINNER_PIXI_W'}   == $vil->{'winner'} ));
	$result = '����' if (($win_if eq 'WIN_LONEWOLF')&&( $sow->{'WINNER_LONEWOLF'} == $vil->{'winner'} ));
	$result = '����' if (($win_if eq 'WIN_LOVER'   )&&( $sow->{'WINNER_LOVER'}    == $vil->{'winner'} ));
	$result = '����' if (($win_if eq 'WIN_HATER'   )&&( $sow->{'WINNER_HATER'}    == $vil->{'winner'} ));
	$result = '����' if (($win_if eq 'WIN_DISH'    )&&( 'victim' eq $self->{'live'}  ));
	$result = '����' if (($win_if eq 'WIN_EVIL'    )&&( $sow->{'WINNER_HUMAN'}    != $vil->{'winner'} )
	                                                &&( $sow->{'WINNER_LOVER'}    != $vil->{'winner'} ));
#	           ���؂�҂́A�׋C�����͋��e����B     &&( $sow->{'WINNER_HATER'}    != $vil->{'winner'} ));
	$result = '�s�k' if (($islonelose)&&( $self->ishappy($vil) == 0 ));
	$result = '�s�k' if (($isdeadlose)&&('live' ne $self->{'live'} ));
	$result = ''     if (          'suddendead' eq $self->{'live'} );
	$result = ''     if (($win_if eq 'WIN_NONE'    ));
	return $result;
}

sub winmessage {
	my ($self) = @_;
	my $sow = $self->{'sow'};
	my $winmes = $sow->{'textrs'}->{$self->win_visible()} ;
	return $winmes;
}

sub ispowerlessgrave {
	my ($self, $vil) = @_;
	my $sow = $self->{'sow'};

	my $result = 1;
	$result = 0 if ($vil->isepilogue());
	$result = 0 if ($self->{'live'} eq 'live');
	$result = 0 if ($self->{'role'} eq $sow->{'ROLEID_WALPURGIS'});
	return $result;
}

sub ischeckedday {
	my ($self,$turn,$target) = @_;
	my @eclipse = split('/', $self->{$target});
	my $check = 0;
	foreach  ( @eclipse ){
		$check = 1 if ( $_ == $turn );
	}
	return $check;
}

#----------------------------------------
# �K���ȗ��l�i�����J�̐�������Ă��Ȃ��j
#----------------------------------------
sub ishappy {
	my ($self, $vil) = @_;
	my $sow = $self->{'sow'};

	my $happy = 0;
	# ���������l�ŁA�������Ă�����Ƃ肠�����K���B
	if (($self->{'love'} eq 'love')&&($self->{'live'} eq 'live')){
		$happy = 1;

		# �Ƃ��Ƃ��A�����`�F�b�N�Ń��X�g�擾���B�B�B�d���Ȃ��Ƃ悢���B
		my $pllist = $vil->getpllist();
		foreach $target (@$pllist) {
			# �����Ă���H
			next if ($target->{'live'} eq 'live');
			# �J���Ȃ��H
			my @target_bonds = $target->getbondlist();
			next if ( 0 == grep{$_ == $self->{'pno'}} @target_bonds );
			# ����ł��āA�J������Ȃ�A���̎��Ɍ���s�K�ł��B
			$happy = 0;
		}
	}

	return $happy;
}

sub getvisiblelovestate {
	my ($self) = @_;

	my $lovestate       = $self->{'love'};
	my $pseudolovestate = $self->{'pseudolove'};

	$lovestate = $pseudolovestate if( $pseudolovestate ne '' );
	return $lovestate;
}


#----------------------------------------
# �J����Ɍ����邩
#----------------------------------------
sub all_bonds_str {
	my ($self) = @_;
	my $str = $self->{'bonds'};
	$str   .= '/' if (($self->{'bonds'} ne '')&&($self->{'pseudobonds'} ne ''));
	$str   .= $self->{'pseudobonds'};
	return $str;
}

sub getvisiblebonds {
	my ($self,$vil) = @_;
	my @pllist;

	my $self_bondlist = $self->all_bonds_str();
	if ($self_bondlist ne '') {
		my @bonds = split('/', $self_bondlist );
		foreach(@bonds) {
			my $target          = $vil->getplbypno($_);
			my $target_bondlist = $target->all_bonds_str();
			my @target_bonds    = split('/', $target_bondlist );
			# ���v�����J�������A�ڂɌ�����B
			if ( 0 < grep{$_ == $self->{'pno'}} @target_bonds ) {
				push(@pllist, $target);
			}
		}
	}
	return \@pllist;
}

sub isvisiblebonds {
	my ($self,$vil) = @_;
	my $bonds = $self->getvisiblebonds($vil);
	return scalar(@$bonds);
}

#----------------------------------------
# ���̖�E�̓�������ɔ����邩�B
#----------------------------------------
sub isbindrole {
	my ($self,$roleid) = @_;
	my $isok = 1;
	$isok = 0 if ( $self->{'role'} != $roleid  );
	return $isok;
}
sub ishurtrole {
	my ($self,$roleid) = @_;
	my $sow = $self->{'sow'};
	my $isok = 1;
	$isok = 0 if ( $self->{'role'} != $roleid  );
	$isok = 0 if ( $self->isEnableState('MASKSTATE_HURT') );
	$isok = 0 if ( defined( $self->{'tmp_deathday'} )     );
	return $isok;
}
sub isbindgift {
	my ($self,$giftid) = @_;
	my $isok = 1;
	$isok = 0 if ( $self->{'gift'} != $giftid  );
	return $isok;
}
#----------------------------------------
# ���̖�E�\�͂��\���B
#----------------------------------------

sub isactive {
	my ($self) = @_;
	my $sow = $self->{'sow'};
	my $isok = 0;

	if ($self->{'live'} eq 'live'){
		$isok = 1;
	} else {
		$isok = 1 if ($self->{'role'} == $sow->{'ROLEID_WALPURGIS'});
	}
	return $isok;
}

sub iscanrole_or_dead {
	my ($self,$roleid) = @_;
	my $sow = $self->{'sow'};

	my $isok = ($self->{'role'} == $roleid);
	$isok = 0 if ( $self->isDisableState('MASKSTATE_HURT') && ($roleid == $sow->{'ROLEID_ELDER'})    );
	$isok = 0 if ( $self->isDisableState('MASKSTATE_HURT') && ($roleid == $sow->{'ROLEID_WEREDOG'})  );
	$isok = 0 if ( $self->isDisableState('MASKSTATE_ZOMBIE') );
	$isok = 0 if ( $self->isDisableState('MASKSTATE_ABI_ROLE') );
	return $isok;
}

sub iscanrole {
	my ($self,$roleid) = @_;
	my $isok = $self->isactive();
	$isok = 0 if ( 0 == $self->iscanrole_or_dead($roleid));
	return $isok;
}

sub iscangift_or_dead {
	my ($self,$giftid) = @_;
	my $sow = $self->{'sow'};

	my $isok = ($self->{'gift'} == $giftid);
	$isok = 0 if ( $self->isDisableState('MASKSTATE_ZOMBIE') );
	$isok = 0 if ( $self->isDisableState('MASKSTATE_ABI_GIFT') );
	return $isok;
}

sub iscangift {
	my ($self,$giftid) = @_;
	my $isok = 1;
	$isok = 0 if ( 0 == $self->iscangift_or_dead($giftid));
	return $isok;
}

sub isdo {
	my ($self,$roleid) = @_;
	my $action = 1;
	$action = 0 if ($self->{$roleid}  < 0);
	$action = 0 if ($self->{$roleid} == $self->{'pno'});
	return $action;
}

#----------------------------------------
# ��b�X�C�b�`
#----------------------------------------
sub rolesayswitch {
	my ($self,$vil,$listen) = @_;
	my $sow = $self->{'sow'};

	my $sayswitch = $sow->{'ROLESAYSWITCH'}->[$self->{'role'}];
	$sayswitch = '' if ($self->{'role'} < 1);
	return $sayswitch if ($listen);
	# ����ׂ�ꍇ�̏���
	$sayswitch = '' if (($sayswitch eq 'wolf')&&($vil->{'game'} eq 'SECRET'));
	$sayswitch = '' if (($sayswitch eq 'wolf')&&($vil->{'game'} eq 'TROUBLE'));
	$sayswitch = '' if  ( $self->isDisableState('MASKSTATE_ABI_ROLE') );
	return $sayswitch;
}
sub giftsayswitch {
	my ($self,$vil,$listen) = @_;
	my $sow = $self->{'sow'};

	my $sayswitch = $sow->{'GIFTSAYSWITCH'}->[$self->{'gift'}];
	$sayswitch = '' if ($self->{'gift'} < 1);
	return $sayswitch if ($listen);
	# ����ׂ�ꍇ�̏���
	$sayswitch = '' if (($sayswitch eq 'wolf')&&($vil->{'game'} eq 'SECRET'));
	$sayswitch = '' if (($sayswitch eq 'wolf')&&($vil->{'game'} eq 'TROUBLE'));
	$sayswitch = '' if  ( $self->isDisableState('MASKSTATE_ABI_GIFT') );
	return $sayswitch;
}


#----------------------------------------
# �����̕�����
#----------------------------------------
sub isoverhear {
	my ($self,$turn) = @_;
	return $self->ischeckedday($turn,'overhear');
}

#----------------------------------------
# ��E�����̂��ǂ���
#----------------------------------------
sub iscursed {
	my ($self, $cmd) = @_;
	my $sow = $self->{'sow'};

	my $iskill = 0;
	$iskill = 1 if (($cmd eq 'gift')&&( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} ));
	$iskill = 1 if (($cmd eq 'role')&&(                   $sow->{'SIDEST_PIXISIDE'} <= $self->{'role'} )
	                                &&( $self->{'role'} < $sow->{'SIDEED_PIXISIDE'} ));
	return $iskill;
}

#----------------------------------------
# ���k���Ă̏P���A�������ǂ���
#----------------------------------------
sub iskiller {
	my ($self, $cmd) = @_;
	my $sow = $self->{'sow'};

	my $iskill = 0;
	$iskill = 1 if (($cmd eq 'gift')&&( $self->{'gift'} == $sow->{'GIFTID_OGRE'} ));
	$iskill = 1 if (($cmd eq 'role')&&(                    $sow->{'SIDEST_WOLFSIDE'} <= $self->{'role'} )
	                                &&( $self->{'role'}  < $sow->{'SIDEED_WOLFSIDE'} ));
	return $iskill;
}

sub cankiller {
	my ($self) = @_;
	my $cankillrole = ($self->iskiller('role'))&&($self->isEnableState('MASKSTATE_ABI_ROLE'));
	my $cankillgift = ($self->iskiller('gift'))&&($self->isEnableState('MASKSTATE_ABI_GIFT'));
	return ( $cankillrole || $cankillgift );
}


sub ismediumed {
	my $self = shift;
	my $medium = 0;
	$medium = 1 if ($self->{'live'} eq 'executed');
	$medium = 1 if ($self->{'live'} eq 'suddendead');
	return $medium;
}

#----------------------------------------
# ���[�ɎQ������̂�
#----------------------------------------
sub isvoter {
	my $self = shift;
	my $sow  = $self->{'sow'};
	my $vil  = $self->{'vil'};

	# �󋵂ɂ��ω�
#	return 0 if ($self->isDisableState('MASKSTATE_ABI_VOTE'));

	# ���̐ݒ�ɂ��ω�
	my $result = 1;
	if ($vil->{'mob'} eq 'juror'){
		$result = 0 if ($self->{'live'} ne 'mob');
	}else{
		$result = 0 if ($self->{'role'} == $sow->{'ROLEID_MOB'});
		$result = 0 if ($self->{'live'} ne 'live');
	}
	return $result;
}


#----------------------------------------
# ���o�̂��鑺�����ǂ����𒲂ׂ�
#----------------------------------------
sub issensible {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	my $sensible = 1;
	if('WIN_HUMAN' eq $self->win_if()){
		$sensible = 0 if ('MISTERY' eq $vil->{'game'});
		$sensible = 0 if ( $self->{'gift'} == $sow->{'GIFTID_DIPSY'} );
	}

	return $sensible;
}


#----------------------------------------
# �l�Ԃ��ǂ����𒲂ׂ�
#----------------------------------------
sub ishuman {
	my $self = shift;
	my $sow = $self->{'sow'};

	return 2 if ( $self->{'gift'} == $sow->{'GIFTID_FINK'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_OGRE'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} );
	my $result = 0;
	$result = 1 if (                   $sow->{'SIDEST_HUMANSIDE'} <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_HUMANSIDE'} );
	$result = 1 if (                   $sow->{'SIDEST_ENEMY'}     <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_ENEMY'} );
	return $result;
}

#----------------------------------------
# �l�T���̐l�Ԃ��ǂ����𒲂ׂ�
#----------------------------------------
sub isenemy {
	my $self = shift;
	my $sow = $self->{'sow'};

	return 2 if ( $self->{'gift'} == $sow->{'GIFTID_FINK'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_OGRE'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} );
	my $result = 0;
	$result = 1 if (                   $sow->{'SIDEST_ENEMY'} <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_ENEMY'} );
	return $result;
}

#----------------------------------------
# �l�T���ǂ����𒲂ׂ�
#----------------------------------------
sub iswolf {
	my $self = shift;
	my $sow = $self->{'sow'};

	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FINK'}  );
	return 2 if ( $self->{'gift'} == $sow->{'GIFTID_OGRE'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} );
	my $result = 0;
	$result = 1 if (                   $sow->{'SIDEST_WOLFSIDE'} <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_WOLFSIDE'} );
	$result = 1 if ( $self->{'role'} == $sow->{'ROLEID_LONEWOLF'} );
	return $result;
}

#----------------------------------------
# �d�����ǂ����𒲂ׂ�
#----------------------------------------
sub ispixi {
	my $self = shift;
	my $sow = $self->{'sow'};

	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FINK'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_OGRE'}  );
	return 2 if ( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} );
	my $result = 0;
	$result = 1 if (                   $sow->{'SIDEST_PIXISIDE'} <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_PIXISIDE'} );
	return $result;
}

#----------------------------------------
# �R�~�b�g���邩�ǂ���
#----------------------------------------
sub iscommitter {
	my $self = shift;
	my $result = 0;
	$result = 1 if( 'live' eq $self->{'live'} );
	$result = 1 if( $self->isvoter() );
	return $result;
}


#----------------------------------------
# ���\���ǂ����B
#----------------------------------------
sub textDisableAbility {
	my ($self) = @_;
	my $sow = $self->{'sow'};
	# return $self->{'live'}.' --- '.$self->{'delay_live'}.' --- '.$self->{'rolestate'}.' --- '.$self->{'delay_rolestate'}.' --- '.$self->{'tmp_rolestate'};
	return $sow->{'textrs'}->{'STATE_BIND'     } if ($self->isDisableState('MASKSTATE_ZOMBIE')  );
	return $sow->{'textrs'}->{'STATE_BIND'     } if ($self->isDisableState('MASKSTATE_ABILITY') );
	return $sow->{'textrs'}->{'STATE_BIND_GIFT'} if ($self->isDisableState('MASKSTATE_ABI_GIFT'));
	return $sow->{'textrs'}->{'STATE_BIND_ROLE'} if ($self->isDisableState('MASKSTATE_ABI_ROLE'));
	return "";
}

sub hasDisableAbility {
	my ($self) = @_;
	return 1 if ($self->isDisableState('MASKSTATE_ZOMBIE')  );
	return 1 if ($self->isDisableState('MASKSTATE_ABILITY') );
	return 1 if ($self->isDisableState('MASKSTATE_ABI_GIFT'));
	return 1 if ($self->isDisableState('MASKSTATE_ABI_ROLE'));
	return 1 if ($self->isDisableState('MASKSTATE_ABI_VOTE'));
	return 0;
}

sub isDisableState {
	my ($self,$maskstate) = @_;
	my $sow = $self->{'sow'};
	my $isD = 0;
	$isD = 1 unless ( $self->{'rolestate'}     & $sow->{$maskstate} );
	$isD = 1 unless ( $self->{'tmp_rolestate'} & $sow->{$maskstate} );
	return $isD;
}


#----------------------------------------
# �L�\���ǂ����𒲂ׂ�
#----------------------------------------
sub isEnableState {
	my ($self,$maskstate) = @_;
	my $sow = $self->{'sow'};
	my $isE = 1;
	$isE = 0 unless ( $self->{'rolestate'}     & $sow->{$maskstate});
	$isE = 0 unless ( $self->{'tmp_rolestate'} & $sow->{$maskstate});
	return $isE;
}

sub isEnableGift {
	my ($self,$turn) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $abi_gift = $sow->{'textrs'}->{'ABI_GIFT'};

	# �󋵂ɂ��ω�
	return 0 if ($vil->isepilogue());
	return 0 if ($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'});

	# ��Ԃɂ��ω�
	return 0 if ($self->isDisableState('MASKSTATE_ABI_GIFT'));
	return 0 if ($abi_gift->[$self->{'gift'}] eq '');
	my $result = 1;
	$result = 0 if (($self->{'gift'} == $sow->{'GIFTID_SHIELD'}) && ($turn < 2));
	$result = 0 if (($self->{'gift'} == $sow->{'GIFTID_DECIDE'}) && ($turn < 2));
	return $result;
}

sub isEnableRole {
	my ($self,$turn) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $abi_role = $sow->{'textrs'}->{'ABI_ROLE'};

	# �󋵂ɂ��ω�
	return 0 if ($vil->isepilogue());
	return 0 if ($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'});

	# ���o�̂Ȃ��ꍇ�A�Ƃ肠�����s���͂ł��邪�������Ȃ����Ƃ�����B
	return 1 if (0 == $self->issensible());

	# ��Ԃɂ��ω�
	return 0 if ($self->isDisableState('MASKSTATE_ABI_ROLE'));
	return 0 if ($abi_role->[$self->{'role'}] eq '');
	my $result = 1;
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_WALPURGIS'}) && ($self->{'live'} eq 'live'));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_WALPURGIS'}) && ($turn == 1));

	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_GIRL'}) && ($turn == 1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_WITCH'}) && ($turn == 1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_GUARD'})  && ($turn == 1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_DECIDE'})  && ($turn == 1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_PASSION'})  && ($turn >  1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_BITCH'})     && ($turn >  1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_TRICKSTER'})  && ($turn >  1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_LOVEANGEL'})   && ($turn >  1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_HATEDEVIL'})    && ($turn >  1));
	return $result;
}

sub isEnableVote {
	my ($self,$turn) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	# �󋵂ɂ��ω�
	return 0 if ($vil->isepilogue());

	# ���̐ݒ�ɂ��ω�
	my $result = $self->isvoter();
	$result = 0 if ($turn < 2 );
	return $result;
}

#----------------------------------------
# �����b�𑗂邱�Ƃ��ł���H
#----------------------------------------
sub isAim {
	my ($this,$that) = @_;
	my $cfg = $this->{'sow'}->{'cfg'};
	my $vil = $this->{'vil'};
	return 0 if ($this->{'uid'} eq $that->{'uid'}); # �������g�͏��O

	my $this_is_mob  =  ($this->{'live'} eq 'mob');
	my $that_is_mob  =  ($that->{'live'} eq 'mob');
	my $this_is_live =  ($this->{'live'} eq 'live');
	my $that_is_live =  ($that->{'live'} eq 'live');
	my $this_is_dead = !($this_is_live);
	my $that_is_dead = !($that_is_live);
	if  ($cfg->{'ENABLED_MOB_AIMING'}){
		# �����l�����bON�Ȃ�
		# �@���������l�͌����l�����B���҈����B���҈����B
		# �@���䌩���l�͌����l�����B���҈����B���҈����B
		# �@���������l�͌����l�����B���҈����B
		# �@�q�ȁA���R�͌����l�����B
		$this_is_live = 1 if ($this_is_mob && ($vil->{'mob'} eq 'alive'));
		$this_is_live = 1 if ($this_is_mob && ($vil->{'mob'} eq 'gamemaster'));

		$that_is_live = 1 if ($that_is_mob && ($vil->{'mob'} eq 'alive'));
		$that_is_live = 1 if ($that_is_mob && ($vil->{'mob'} eq 'gamemaster'));

		$this_is_dead = 0 if ($this_is_mob && ($vil->{'mob'} eq 'juror'));
		$this_is_dead = 0 if ($this_is_mob && ($vil->{'mob'} eq 'visiter'));

		$that_is_dead = 0 if ($that_is_mob && ($vil->{'mob'} eq 'juror'));
		$that_is_dead = 0 if ($that_is_mob && ($vil->{'mob'} eq 'visiter'));
	} else {
		# �����l�ł���ΐ��҂ƈ���Ȃ��B���҂ƈ���Ȃ��B�����l�ƈ���Ȃ��B
		$this_is_live  = 0 if ($this_is_mob);
		$that_is_live  = 0 if ($that_is_mob);
		$this_is_dead  = 0 if ($this_is_mob);
		$that_is_dead  = 0 if ($that_is_mob);
		$this_is_mob   = 0;
		$that_is_mob   = 0;
	}

	my $res = 0;

	$res = 1 if ($vil->isepilogue());      # �G�s�͊��S����
	$res = 1 if (($this_is_live)&&($that_is_live)); # ���҂̓����b
	$res = 1 if (($this_is_dead)&&($that_is_dead)); # ���҂̓����b
	$res = 1 if (($this_is_mob )&&($that_is_mob )); # �����l�̓����b

	return $res;
}

#----------------------------------------
# �A�N�V�����Ώۂɂ��邩�H
#----------------------------------------
sub isAction {
	my ($this,$that) = @_;
	my $cfg = $this->{'sow'}->{'cfg'};
	my $vil = $this->{'vil'};
	return 0 if ($this->{'uid'} eq $that->{'uid'}); # �������g�͏��O
	return 1 if (1 == $vil->isepilogue());
	if      ($this->{'live'} eq 'live'){
		return 1 if ($that->{'live'} eq 'live');
		return 0;
	} elsif ($this->{'live'} eq 'mob') {
		return 1;
	} else {
		return 1;
	}
}

#----------------------------------------
# �����ϔC�A�������[�𐧌�
#----------------------------------------
sub queryentrust {
	my($curpl,$sow,$vil,$query) = @_;
	if(     $curpl->setentrust($sow,$vil) == 0 ){
		$query->{'entrust'} = '' ;
	}elsif( $curpl->setvote_to($sow,$vil) == 0 ){
		$query->{'entrust'} = 'on' ;
	}
	$curpl->{'entrust'} = 0;
	$curpl->{'entrust'} = 1 if ($query->{'entrust'} ne '');
}
sub setvote_to {
	my($curpl,$sow,$vil) = @_;
	my $setvote_to = 1;
	$setvote_to = 0 if ($curpl->{'role'} == $sow->{'ROLEID_FOLLOW'});
	return $setvote_to;
}
sub setentrust {
	my($curpl,$sow,$vil) = @_;
	my $setentrust = 1;
	$setentrust = 0 if (($vil->{'entrust'} != 1));
	$setentrust = 0 if (($vil->{'mob'} eq 'juror'));
	$setentrust = 0 if (($vil->{'scapegoat'} > 0));
	$setentrust = 0 if (($vil->{'event'} == $sow->{'EVENTID_APRIL_FOOL'})&&( 0 < $curpl->getallbondlist() ));
	return $setentrust;
}

#----------------------------------------
# ������ʂ̎擾
#----------------------------------------
sub GetMesType {
	my($writepl, $sow, $vil) = @_;
	my ($mestype, $saytype, $pttype, $modified, $cost);
	my $query  = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	my $que    = 0;
	my $targetpl = $writepl;
	my $chrname  = '';

	# �����̂Ȃ���������O
	# �s�\�̏ꍇ�A���ꔭ���ł��Ȃ��Ȃ�B
	my $wisperrole = '';
	my $wispergift = '';
	$wisperrole = $writepl->rolesayswitch($vil);
	$wispergift = $writepl->giftsayswitch($vil);

	$query->{'target'}   = -1 if (!defined($query->{'target'}));
	$query->{'admin'}    = '' if (($query->{'admin'}    ne '') && ($sow->{'uid'} ne $cfg->{'USERID_ADMIN'}));
	$query->{'maker'}    = '' if (($query->{'maker'}    ne '') && ($sow->{'uid'} ne $vil->{'makeruid'}));
	$query->{'muppet'}   = '' if (($query->{'muppet'}   ne '') && ($wisperrole ne 'muppet')   && ($wispergift ne 'muppet')   );
	$query->{'sympathy'} = '' if (($query->{'sympathy'} ne '') && ($wisperrole ne 'sympathy') && ($wispergift ne 'sympathy') );
	$query->{'wolf'}     = '' if (($query->{'wolf'}     ne '') && ($wisperrole ne 'wolf')     && ($wispergift ne 'wolf')     );
	$query->{'pixi'}     = '' if (($query->{'pixi'}     ne '') && ($wisperrole ne 'pixi')     && ($wispergift ne 'pixi')     );

	# �����������A�����I�ɓƂ茾�I���B
	my $nightmare = 0;
	if (($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'})&&($query->{'admin'} eq '')&&($query->{'maker'} eq '')){
		$query->{'target'}   = $writepl->{'pno'};
		$query->{'muppet'}   = '';
		$query->{'sympathy'} = '';
		$query->{'wolf'}     = '';
		$query->{'pixi'}     = '';
		$nightmare = 1;
	}

	# ������ނƐݒ�l���m��
	if      ($query->{'cmd'} eq 'wrmemo') {
		if      (($query->{'admin'} ne '')) {
						# �Ǘ��l����
						$mestype = $sow->{'MESTYPE_ADMIN'};
						$saytype = 'admin';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif (($query->{'maker'} ne '')) {
						$mestype = $sow->{'MESTYPE_MAKER'};
						$saytype = 'maker';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif ($nightmare) {
						# �Ƃ胁���i�������̂݁j
						$mestype = $sow->{'MESTYPE_TSAY'};
						$saytype = 'say_act';
						$pttype  = 'tsay';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
		} else {
			if        ($writepl->{'live'} eq 'mob') {
						# �����\��t��
						$mestype = $sow->{'MESTYPE_VSAY'};
						$saytype = 'say_act';
						$pttype  = 'gsay';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
			} elsif ( ($writepl->{'live'} eq 'live')||(0 < $vil->isepilogue() )){
						# ����
				if      (($query->{'muppet'}   eq 'on')) {
						# �߈˃���
						$mestype = $sow->{'MESTYPE_MSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$writepl = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} );
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'sympathy'} eq 'on')) {
						# ������
						$mestype = $sow->{'MESTYPE_SPSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'wolf'}     eq 'on')) {
						# ��������
						$mestype = $sow->{'MESTYPE_WSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'pixi'}     eq 'on')) {
						# �O�b����
						$mestype = $sow->{'MESTYPE_XSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
				} else {
						# �ʏ탁��
						$mestype = $sow->{'MESTYPE_SAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
				}
			} else {
						# ���҃���
						$mestype = $sow->{'MESTYPE_GSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
			}
		}
		if ($cost eq 'count') {
						# �����ł̔�������ɂ��āA�ݒ�ɏ]���B
						$pttype = 'say_act';
		}
	} elsif ($query->{'cmd'} eq 'action') {
		if      (($query->{'admin'} ne '')) {
						# �Ǘ��lact
						$mestype = $sow->{'MESTYPE_ADMIN'};
						$saytype = 'say_act';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif (($query->{'maker'} ne '')) {
						# ������act
						$mestype = $sow->{'MESTYPE_MAKER'};
						$saytype = 'say_act';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif ($nightmare) {
						# �Ƃ�act�i�������̂݁j
						$mestype = $sow->{'MESTYPE_TSAY'};
						$saytype = 'say_act';
						$pttype  = 'tsay';
						$cost    = $saycnt->{'COST_ACT'};
						$chrname = $writepl->getchrname();
		} elsif ($writepl->{'live'} eq 'mob') {
						# �A�N�V����
						$mestype = $sow->{'MESTYPE_VSAY'};
						$saytype = 'say_act';
						$pttype  = 'gsay';
						$cost    = $saycnt->{'COST_ACT'};
						$chrname = $writepl->getchrname();
		} elsif ( ($writepl->{'live'} eq 'live')||( 0 < $vil->isepilogue() ) ){
						# �A�N�V����
						$mestype = $sow->{'MESTYPE_SAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_ACT'};
						$chrname = $writepl->getchrname();
		} else {
						# �A�N�V����
						$mestype = $sow->{'MESTYPE_GSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_ACT'};;
						$chrname = $writepl->getchrname();
		}
		if ($cost eq 'count') {
						# act�ł̔�������ɂ��āA�ݒ�ɏ]���B
						$pttype = 'say_act';
		}
		# �����܂œǂ񂾁B�͔閧
		$mestype = $sow->{'MESTYPE_TSAY'} if ($query->{'actionno'} == -2);
	} else {
		if (0 <= $query->{'target'}) {
						$targetpl = $vil->getplbypno( $query->{'target'} ) ;
						$targetpl = $writepl if (0 == $writepl->isAim($targetpl));
		}
		if      (($query->{'admin'} ne '')) {
						# �Ǘ��l����
						$mestype = $sow->{'MESTYPE_ADMIN'};
						$saytype = 'admin';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif (($query->{'maker'} ne '')) {
						# �����Đl����
						$mestype = $sow->{'MESTYPE_MAKER'};
						$saytype = 'maker';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif (0 <= $query->{'target'}) {
			if ( $writepl->{'uid'} eq $targetpl->{'uid'} ){
						# �Ƃ茾�B
						$mestype = $sow->{'MESTYPE_TSAY'};
						$saytype = 'tsay';
						$pttype  = 'tsay';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  0;
						$chrname = $writepl->getlongchrname();
			} else {
						# �����b�g�[�N
						$mestype = $sow->{'MESTYPE_AIM'};
						if ($writepl->{'live'} eq 'live') {
							$saytype = 'say';
							$pttype  = 'say';
						} else {
							$saytype = 'gsay';
							$pttype  = 'gsay';
						}
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$chrname = $writepl->getlongchrname()." �� ".$targetpl->getlongchrname();
			}
		} else {
			if        ($writepl->{'live'} eq 'mob') {
			# �����l
						# ����
						$mestype = $sow->{'MESTYPE_VSAY'};
						$saytype = 'gsay';
						$pttype  = 'gsay';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$chrname = $writepl->getlongchrname();
			} elsif ( ($writepl->{'live'} eq 'live')||( 0 < $vil->isepilogue() ) ){
			# ����
				if     (($query->{'muppet'}   eq 'on')) {
						# �߈˔��� �i�_�~�[��pt������j
						$mestype = $sow->{'MESTYPE_MSAY'};
						$saytype = 'say';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$writepl = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} );
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'sympathy'} eq 'on')) {
						# ����
						$mestype = $sow->{'MESTYPE_SPSAY'};
						$saytype = 'spsay';
						$pttype  = 'spsay';
						$cost    = $saycnt->{'COST_SAY'};
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'wolf'}     eq 'on')) {
						# ����
						$mestype = $sow->{'MESTYPE_WSAY'};
						$saytype = 'wsay';
						$pttype  = 'wsay';
						$cost    = $saycnt->{'COST_SAY'};
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'pixi'}     eq 'on')) {
						# �O�b
						$mestype = $sow->{'MESTYPE_XSAY'};
						$saytype = 'wsay';
						$pttype  = 'wsay';
						$cost    = $saycnt->{'COST_SAY'};
						$chrname = $writepl->getlongchrname();
				} else {
						# ����
						$mestype = $sow->{'MESTYPE_SAY'};
						$saytype = 'say';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$chrname = $writepl->getlongchrname();
				}
			} else {
			# ���S
						# ���߂�
						$mestype = $sow->{'MESTYPE_GSAY'};
						$saytype = 'gsay';
						$pttype  = 'gsay';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$chrname = $writepl->getlongchrname();
			}
		}
	}

	$cost = 'none'  if ($vil->isfreecost());

	return ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost);
}

#----------------------------------------
# ���O�{������ 0:�����Ȃ� 1:������ 9:������
#----------------------------------------
sub isLogPermition {
	my ($self, $sow, $vil, $log, $logpermit, $isque) = @_;
	my $query = $sow->{'query'};

	my $overhear = (1 == $sow->{'cfg'}->{'ENABLED_BITTY'})?(9):(8);

	my $wisperrole = '';
	my $wispergift = '';
	$wisperrole = $self->rolesayswitch($vil,1);
	$wispergift = $self->giftsayswitch($vil,1);

	# �i�s��

	if (($self->{'live'} eq 'live') || ($sow->{'cfg'}->{'ENABLED_PERMIT_DEAD'} > 0)) {
		# �����̕�����
		if ($self->isoverhear($sow->{'turn'})){
			$logpermit = 8         if (                        ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'}));
			$logpermit = $overhear if (                        ($log->{'mestype'} == $sow->{'MESTYPE_WSAY'}));
			$logpermit = $overhear if (                        ($log->{'mestype'} == $sow->{'MESTYPE_XSAY'}));
			$logpermit = $overhear if (                        ($log->{'mestype'} == $sow->{'MESTYPE_SPSAY'}));
		}
		# �����邱�Ƃ����長�����\�́B
		if ( $self->isEnableState('MASKSTATE_ABI_ROLE') ) {
			# �~��҂̗�b
			$logpermit = $overhear if (($self->{'role'} == $sow->{'ROLEID_NECROMANCER'})
		                                                    && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		}
		# �~���
		$logpermit = $overhear if (($vil->isseance($sow->{'turn'}))
		                                                    && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		# �����₫
		$logpermit = 1 if (($wisperrole eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_WSAY'}));
		$logpermit = 1 if (($wispergift eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_WSAY'}));
		$logpermit = 1 if (($wisperrole eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'}));
		$logpermit = 1 if (($wispergift eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'}));
		# ����
		$logpermit = 1 if (($wisperrole eq 'sympathy')      && ($log->{'mestype'} == $sow->{'MESTYPE_SPSAY'}));
		$logpermit = 1 if (($wispergift eq 'sympathy')      && ($log->{'mestype'} == $sow->{'MESTYPE_SPSAY'}));
		# �O�b
		$logpermit = 1 if (($wisperrole eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_XSAY'}));
		$logpermit = 1 if (($wispergift eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_XSAY'}));
	}
	if      (($self->{'live'} eq 'mob')) {
		$logpermit = 1 if (                                    ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})); # �����l
		$logpermit = 1 if (($vil->{'mob'} eq 'grave')       && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})); # �����l����扺��������̂́A
		$logpermit = 1 if (($vil->{'mob'} eq 'alive')       && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})); # ����A�����A�����̂Ƃ��B
		$logpermit = 1 if (($vil->{'mob'} eq 'gamemaster')  && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})); #
		$logpermit = 1 if (($vil->{'mob'} eq 'gamemaster')  && ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'})); # ����
		$logpermit = 1 if (($vil->{'mob'} eq 'gamemaster')  && ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}));   # ����
	} elsif (($self->{'live'} ne 'live')) {
		$logpermit = 1 if (                                    ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})); # ���߂�
		$logpermit = 1 if (($vil->{'mob'} eq 'grave')       && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})); # �扺���猩���l������̂́A�����̂Ƃ��B
	}
	# �H�E�g�[�N�ł̒ǉ���
	if($vil->{'undead'}>0){
		$logpermit = 1 if (($wisperrole eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		$logpermit = 1 if (($wispergift eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		$logpermit = 1 if (($wisperrole eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		$logpermit = 1 if (($wispergift eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		$logpermit = 1 if (($wisperrole eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
		$logpermit = 1 if (($wispergift eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
		$logpermit = 1 if (($wisperrole eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
		$logpermit = 1 if (($wispergift eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
		$logpermit = 1 if (($self->{'live'} ne 'live')      && ($log->{'mestype'} == $sow->{'MESTYPE_WSAY'}));
		$logpermit = 1 if (($self->{'live'} ne 'live')      && ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'}));
		$logpermit = 1 if (($self->{'live'} ne 'live')      && ($log->{'mestype'} == $sow->{'MESTYPE_XSAY'}));
		# ���͕�Ɖ�b�ł��Ȃ��B�m��V��������B
	}

	# �L���[�̔����͖{�l�̂݁B�������A�m�o�b�����͜߈ˎ҂����͌��邱�Ƃ��ł���B
	$logpermit = 1 if (($log->{'target'} eq $self->{'uid'}));

	$logpermit = 0 if  ($log->{'mestype'} == $sow->{'MESTYPE_DELETED'});
	$logpermit = 0 if  ($isque == 1);

	$logpermit = 1 if (($log->{'uid'} eq $self->{'uid'}));

	$logpermit = 1 if ( ($wisperrole eq 'muppet'                       )
	                  &&($log->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'})
	                  &&($self->isEnableState('MASKSTATE_ABI_ROLE')    )
	                  &&($log->{'mestype'} == $sow->{'MESTYPE_MSAY'}   )
	                  );

	return $logpermit;
}
# �_�~�[�����Ɯ߈ˎҁA�ԃ��O�Ɛl�T�A�Ȃǂ̓��ꃍ�O
# �́A�s��̉e�����ꕔ�̐l�ɂ����o��B
# �؂蕪�����A�����Ƃ��Ȃ��悤���ӁB
# �ڈ��F��E�n�̃p�[�~�b�V�����̓��O�C�����̂ݔ�������B
# �@�@�@���̂��߁A���O�C���ł��Ȃ��Ȃ�A�Ƃ�����������
# �@�@�@�A�J�E���g���������Ȃ��ꍇ�A�������^���ׂ��B


sub gon_potof {
	my ($pl, $vil) = @_;
	my $sow = $vil->{'sow'};
	my $cfg = $sow->{'cfg'};

    # ����/�Ƃ茾/�����b
	my ($saycnt,$cost,$unit,$max_line,$max_size) = $vil->getsayptcosts();

	my $is_epi = $vil->isepilogue();
	my $blined = $is_epi;
	my $secret = $is_epi;
	my $showpt = $is_epi;
	$showpt = $secret = $blined = 1 if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});
	$showpt = $secret = 1 if ($pl->{'uid'} eq $sow->{'uid'});
	my $showid = $vil->{'showid'} || $secret;

	my $longchrname  = $pl->getlongchrname();
	my $shortchrname = $pl->getshortchrname();
	my $actaddpt = 0 + $pl->{'actaddpt'};
	my $selrole = 0 + $pl->{'selrole'};
	my $say   = 0 + $pl->{'say'};
	my $tsay  = 0 + $pl->{'tsay'};
	my $spsay = 0 + $pl->{'spsay'};
	my $wsay  = 0 + $pl->{'wsay'};
	my $gsay  = 0 + $pl->{'gsay'};
	my $say_act = 0 + $pl->{'say_act'};
	my $live = $pl->{'live'};
	my $turn = 0 + $sow->{'turn'};

	if(!$blined){
		$live = 'victim' if(('executed' ne $live)and('suddendead' ne $live)and('live' ne $live)and('mob' ne $live));

		my $live_from = 'live';
		$live_from = $sow->{'curpl'}->{'live'} if (defined($sow->{'curpl'}->{'live'}));
		$showpt = $vil->ispublic($pl);
		$showpt = 1 if ($live_from ne 'live');
		# ���I
		$showpt = 0 if ($vil->iseclipse($vil->{'turn'}));
	}

	print <<"_HTML_";
var pl = {
	"turn":    $turn,
    "pno":     $pl->{'pno'},
	"csid":    "$pl->{'csid'}",
	"face_id": "$pl->{'cid'}",
	"deathday": $pl->{'deathday'},
	"is_delete": true,

	"name":    "$shortchrname",
	"jobname": "$pl->{'jobname'}",
	"longname": "$longchrname",
	"shortname": "$shortchrname",
	"clearance": $pl->{'clearance'},
	"zapcount": $pl->{'zapcount'},
	"postfix": "$pl->{'postfix'}",

	"live": "$live",
	"bonds": [],
	"pseudobonds": [],

	"point":{},
	"say":{
		"say": $say
	}
};
_HTML_

	if ($showpt){
		if ($cost eq 'count'){
			print <<"_HTML_";
pl.point = {
	"actaddpt":  $actaddpt,
	"saidcount": $pl->{'saidcount'}
};
_HTML_
		} else {
			print <<"_HTML_";
pl.point = {
	"actaddpt":  $actaddpt,
	"saidcount": $pl->{'saidcount'},
	"saidpoint": $pl->{'saidpoint'}
};
_HTML_
		}
	}

	if ($showid ){
		print <<"_HTML_";
pl.sow_auth_id = "$pl->{'uid'}";
_HTML_
	}
	if ($secret) {
		my $win_visible = "";
		my $win_result  = $pl->winresult();
		my $role = 0 + $pl->{'role'};
		my $gift = 0 + $pl->{'gift'};

		my $is_wolf = $pl->iswolf();
		my $is_pixi = $pl->ispixi();
		my $is_voter = $pl->isvoter();
		my $is_canrole = $pl->iscanrole($pl->{'role'});
		my $is_cangift = $pl->iscangift($pl->{'gift'});
		my $is_human = $pl->ishuman();
		my $is_enemy = $pl->isenemy();
		my $is_sensible = $pl->issensible();
		my $is_committer = $pl->iscommitter();

		my $history = $pl->{'history'};
		&SWHtml::ConvertJSON(\$history);

		my $love = "";
		my $bonds = "";
		my $pseudolove = "";
		my $pseudobonds = "";
		if ($blined){
			$win_visible = $pl->win_if();
			$love = $pl->{'love'};
			$bonds = $pl->{'bonds'};
			$pseudolove = $pl->{'pseudolove'};
			$pseudobonds = $pl->{'pseudobonds'};
		} else {
			$win_visible = $pl->win_visible();
			$love = $pl->getvisiblelovestate();
			$bonds = $pl->all_bonds_str();
			$role = $sow->{'ROLEID_VILLAGER'} if ($pl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'});
			$role = 0   if (($is_sensible == 0)||($pl->{'role'} == 0));
		}
		$bonds =~ s/\//,/g;
		$pseudobonds =~ s/\//,/g;

		print <<"_HTML_";
pl.is_canrole = (0 !== $is_canrole);
pl.is_cangift = (0 !== $is_cangift);

pl.win = {
	visible: "$win_visible",
	result:  "$win_result"
};

pl.live = "$pl->{'live'}";
pl.role = giji.potof.roles($role, $gift);
pl.rolestate = $pl->{'rolestate'};
pl.select = giji.potof.select($selrole);

pl.history = "$history";
pl.sheep = "$pl->{'sheep'}";
pl.overhear = [];

pl.love = "$love";
pl.bonds = [$bonds];
pl.pseudolove = "$pseudolove";
pl.pseudobonds = [$pseudobonds];

pl.is_voter = (0 !== $is_voter);
pl.is_human = (0 !== $is_human);
pl.is_enemy = (0 !== $is_enemy);
pl.is_wolf = (0 !== $is_wolf);
pl.is_pixi = (0 !== $is_pixi);
pl.is_sensible = (0 !== $is_sensible);
pl.is_committer = (0 !== $is_committer);
pl.say = {
	"say":   $say,
	"tsay":  $tsay,
	"spsay": $spsay,
	"wsay":  $wsay,
	"gsay":  $gsay,
	"say_act": $say_act
};
pl.timer = {
	"entrieddt":    new Date(1000 * $pl->{'entrieddt'}),
	"limitentrydt": new Date(1000 * $pl->{'limitentrydt'})
};
_HTML_
	}
}

1;
