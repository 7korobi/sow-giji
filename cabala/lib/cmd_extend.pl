package SWCmdExtend;

#----------------------------------------
# ���������i�b��j
#----------------------------------------
sub CmdExtend {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# �f�[�^����
	my $vil = &SetDataCmdExtend($sow);

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		# �����O�\��
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_vlog.pl";
		&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
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
sub SetDataCmdExtend {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�Ǘ��l���A�����Đl�łȂ��Ă͂����܂���B", "no permition.$errfrom") if (($sow->{'uid'} ne $vil->{'makeruid'})&&($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}));
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�����񐔂̏���𒴂��Ă��܂��B", "no more extend.$errfrom") if (($vil->{'extend'} == 0)&&($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}));
	$vil->{'extend'}       = $vil->{'extend'} - 1 if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});
	$vil->{'nextupdatedt'} = $vil->{'nextupdatedt'} + 24 * 60 * 60;
	# ���f�[�^�̏�������
	$vil->writevil();

	# �A�i�E���X
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, '���̍X�V������������܂����B');
	$logfile->close();

	$vil->closevil();

	return $vil;
}

1;