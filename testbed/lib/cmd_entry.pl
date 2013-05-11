package SWCmdEntry;

#----------------------------------------
# �G���g���[
#----------------------------------------
sub CmdEntry {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};

	# �f�[�^����
	&SetDataCmdEntry($sow);

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		require "$cfg->{'DIR_LIB'}/file_log.pl";
		require "$cfg->{'DIR_LIB'}/log.pl";
		require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
		my $vil = SWFileVil->new($sow, $sow->{'query'}->{'vid'});
		$vil->readvil();
		&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
		$vil->closevil();
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = "$link";
		$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
		$sow->{'http'}->outfooter();
	}
}
#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdEntry {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/string.pl";

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	my $mobs = $vil->getrolepllist($sow->{'ROLEID_MOB'});
	my $pllist = $vil->getpllist();
	my $allpllist = $vil->getallpllist();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);
	my ($q_csid, $q_cid) = split('/', $query->{'csid_cid'});

	# �v���C���[�Q���ς݃`�F�b�N
	if (defined($sow->{'curpl'})) {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '���Ȃ��͊��ɂ��̑��֎Q�����Ă��܂��B', "user found.[$sow->{'uid'}]");
	}

	my $user = SWUser->new($sow);
	$user->{'uid'} = $sow->{'uid'};
	$user->openuser(1);
	# ���d���O�C�����̃`�F�b�N����������΁A�����ŁB
	$user->closeuser();

	# ����`�F�b�N
	if ($query->{'role'} == $sow->{'ROLEID_MOB'}) {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "���Ɍ����l�͂����ς��ł��B", 'too many mobs.') if ( $vil->{'cntmob'} <= @$mobs   );
	} else {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "���ɒ���ɒB���Ă��܂��B", 'too many plcnt.')  if ( $vil->{'vplcnt'} <= @$pllist );
	}

	foreach (@$allpllist) {
		# �L�����N�^�Q���ς݃`�F�b�N
		next if ($_->{'csid'} ne $q_csid);
		my $chrname = $sow->{'charsets'}->getchrname($q_csid, $q_cid);
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "$chrname �͊��ɎQ�����Ă��܂��B", 'cid found.') if ($_->{'cid'} eq $q_cid);
	}

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�Q���p�X���[�h���Ⴂ�܂��B', "invalid entrypwd.") if (($vil->{'entrylimit'} eq 'password') && ($query->{'entrypwd'} ne $vil->{'entrypwd'}));

	# �Q���҃f�[�^���R�[�h�̐V�K�쐬
	my $role = -1;
	my $live = 'live';
	my $deathday = -1;

	# �����l�͂������肷��B
	if ($query->{'role'} == $sow->{'ROLEID_MOB'}) {
		$role = $sow->{'ROLEID_MOB'}; 
		$gift = $sow->{'GIFTID_NOT_HAVE'}; 
		$live = 'mob';
		$deathday = -2;
	}

	my $plsingle = SWPlayer->new($sow);
	$plsingle->createpl($sow->{'uid'});
	$plsingle->{'postfix'}      = -1  if( $vil->{'trsid'} eq 'zap' );
	$plsingle->{'cid'}          = $q_cid;
	$plsingle->{'csid'}         = $q_csid;
	$plsingle->{'selrole'}      = $query->{'role'};
	$plsingle->{'role'}         = $role;
	$plsingle->{'live'}         = $live;
	$plsingle->{'deathday'}     = $deathday;
	$plsingle->{'limitentrydt'} = $writepl->{'limitentrydt'} = $sow->{'time'} + $sow->{'cfg'}->{'TIMEOUT_ENTRY'} * 24 * 60 * 60;
	$vil->addpl($plsingle);   # ���֒ǉ�
	$plsingle->setsaycount(); # ������������

	# �G���g���[���b�Z�[�W��������
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);

	my $monospace = 0 + $query->{'monospace'};

	my $expression = 0;
	$expression = $query->{'expression'} if (defined($query->{'expression'}));
	my $mes = &SWString::GetTrimString($sow, $vil, $query->{'mes'});
	my %entry = (
		pl         => $plsingle,
		mes        => &SWLog::CvtRandomText($sow, $vil, $mes),
		expression => $expression,
		npc        => 0,
		monospace  => $monospace,
	);
	$logfile->entrychara(\%entry);
	$logfile->close();
	$vil->writevil();

	# ���[�U�[�f�[�^�̍X�V
	$user->writeentriedvil($sow->{'uid'}, $vil->{'vid'}, $vil->{'vname'}, $plsingle->getlongchrname(), 1);

	# ���O�o��
	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Entry. [$sow->{'uid'}]");

	# ���J�n�`�F�b�N�i�l�T�R��^�j
	$pllist = $vil->getpllist();
	if (($vil->{'starttype'} eq 'juna') && (@$pllist >= $vil->{'vplcnt'})) {
		# ���J�n
		require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
		&SWCommit::StartSession($sow, $vil, 1);
	} else {
		# ���ꗗ�f�[�^�̍X�V
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
		my $vindex = SWFileVIndex->new($sow);
		$vindex->openvindex();
		$vindex->updatevindex($vil, $sow->{'VSTATUSID_PRO'});
		$vindex->closevindex();
	}
	$vil->closevil();

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

	$sow->{'http'}->{'location'} = "$link";
	return;
}

1;
