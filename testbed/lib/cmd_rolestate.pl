package SWCmdRoleState;

#----------------------------------------
# �_�ď���
#----------------------------------------
sub CmdRoleState {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# �f�[�^����
	my $vil = &SetDataCmdRoleState($sow,$query->{'vid'},$query->{'target'},$query->{'rolestate'},$query->{'calcstate'});

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
sub SetDataCmdRoleState {
	my ($sow, $vid, $target_pno, $rolestate, $calcstate) = @_;
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $vid);
	$vil->readvil();

	my $cursor = $sow->{'curpl'};
	my $target = $vil->getplbypno($target_pno);
	my $command = '';

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�����łȂ��Ă͂����܂���B", "no permition.$errfrom") unless (($vil->{'mob'} eq 'gamemaster')&&($cursor->{'live'} eq 'mob'));	
	if ($calcstate eq 'enable'){
		$command = 'MASKSTATE_'.$rolestate;
		$target->{'rolestate'} |= $sow->{$command};
	}
	if ($calcstate eq 'disable'){
		$command = 'ROLESTATE_'.$rolestate;
		$target->{'rolestate'} &= $sow->{$command};
	}
	# ���f�[�^�̏�������
	$vil->writevil();

	# �A�i�E���X
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	my $chrname = $target->getlongchrname();
	my $message = $sow->{'textrs'}->{'MASKSTATE_VOTE_TARGET'};
	$message =~ s/_NAME_/$chrname/g;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $message);
	$logfile->close();

	$vil->closevil();

	return $vil;
}

1;