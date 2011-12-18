package SWCmdMaker;

#----------------------------------------
# �����Č����Ϗ�
#----------------------------------------
sub CmdMaker {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	# �f�[�^����
	&SetDataCmdMaker($sow,$query->{'target'});

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
sub SetDataCmdMaker {
	my $sow = $_[0];
	my $target = $_[1];
	my $query  = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	my $curpl = $sow->{'curpl'};
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '���Ȃ��͑����Č���������܂���B', "you are not maker.[$sow->{'uid'}]")   if (($sow->{'uid'} ne $vil->{'makeruid'})&&($sow->{'uid'} ne $cfg->{'USERID_ADMIN'}));

	$curpl = $vil->getplbypno($target) if ($target);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '���̑��֎Q�����Ă��܂���B', "user not found.[$curpl->{'uid'}]")             if (!defined($curpl));
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '�_�~�[�L�����͑����Č������Ă܂���B', "npc cannot exit.[$curpl->{'uid'}]") if ($curpl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});

	# �����Đl���X�V
	$vil->{'makeruid'} = $curpl->{'uid'};
	$vil->writevil();

	# �A�i�E���X
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	my $nextupdatedt = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
#	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, '�����Đl���ω����܂����B');
	$logfile->close();

	$vil->closevil();

	return;
}

1;
