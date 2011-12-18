package SWCmdStartSession;

#----------------------------------------
# ���J�n
#----------------------------------------
sub CmdStartSession {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# �f�[�^����
	my $vil = &SetDataCmdStartSession($sow);

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_vlog.pl";
		&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = $link;
		$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
		$sow->{'http'}->outfooter();
	}
	$vil->closevil();
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdStartSession {
	my $sow = $_[0];
	my $query  = $sow->{'query'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	$vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# ���J�n����
	require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
	&SWCommit::StartSession($sow, $vil, 1);

	return $vil;
}

1;