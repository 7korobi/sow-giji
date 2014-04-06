package SWCmdExit;

#----------------------------------------
# �����o��
#----------------------------------------
sub CmdExit {
	my $sow = $_[0];
	my $cfg    = $sow->{'cfg'};

	# �f�[�^����
	&SetDataCmdExit($sow);

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
# ���ދ��肤
#----------------------------------------
sub CmdKick {
	my $sow = $_[0];
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};

	# �f�[�^����
	&SetDataCmdExit($sow,$query->{'target'});

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		require "$cfg->{'DIR_LIB'}/file_log.pl";
		require "$cfg->{'DIR_LIB'}/log.pl";
		require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
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
sub SetDataCmdExit {
	my $sow    = $_[0];
	my $target = $_[1];
	my $query  = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	my $pllist = $vil->getallpllist();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);
	my ($q_csid, $q_cid) = split('/', $query->{'csid_cid'});

	my $curpl = $sow->{'curpl'};
	$curpl = $vil->getplbypno($target) if ($target);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '���Ȃ��͂��̑��֎Q�����Ă��܂���B', "user not found.[$sow->{'uid'}]") if (!defined($curpl));
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�_�~�[�L�����͑����o�鎖���ł��܂���B', "npc cannot exit.[$sow->{'uid'}]") if ($curpl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�����J�n���Ă��瑺���o�鎖�͂ł��܂���B', "already started.[$sow->{'uid'}]") if ($vil->{'turn'} != 0);

	# ����������
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	&SWBase::ExitVillage($sow, $vil, $curpl, $logfile);
	$logfile->close();
	$vil->writevil();

	# ���[�U�[�f�[�^�̍X�V
	my $user = SWUser->new($sow);
	$user->writeentriedvil($sow->{'uid'}, $vil->{'vid'}, $vil->{'vname'}, '', -1);

	# ���ꗗ�f�[�^�̍X�V
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	$vindex->updatevindex($vil, $sow->{'VSTATUSID_PRO'});
	$vindex->closevindex();

	return;
}

1;