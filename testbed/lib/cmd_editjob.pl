package SWCmdEditJobName;

#----------------------------------------
# �������ύX�i�b��j
#----------------------------------------
sub CmdEditJobName {
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

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	my $curpl = $vil->getplbypno($query->{'target'});
	$curpl->{'jobname'} = $query->{'jobname'};
	$vil->writevil();
	$vil->closevil();

	return $vil;
}

1;