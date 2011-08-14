package SWCmdMuster;

#----------------------------------------
# �_�ď���
#----------------------------------------
sub CmdMuster {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# �f�[�^����
	my $vil = &SetDataCmdMuster($sow);

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
sub SetDataCmdMuster {
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
	my $pllist = $vil->getpllist();
	foreach (@$pllist) {
		next if (($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'}));
		$_->{'saidcount'} = 0;
	}
	# ���f�[�^�̏�������
	$vil->writevil();

	# �A�i�E���X
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	my $nextupdatedt = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, '�_�Ă��J�n���܂��B'.$nextupdatedt.'�܂łɔ��������肢���܂��B');
	$logfile->close();

	$vil->closevil();

	return $vil;
}

1;