package SWCmdEditMes;

#----------------------------------------
# �C���{�^���̏����i�b��j
#----------------------------------------
sub CmdEditMes {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	my $curpl = $sow->{'curpl'};
	if (defined($curpl->{'uid'})) {
		$curpl->{'savedraft'} = $query->{'mes'};
		my $mestype = $sow->{'MESTYPE_SAY'};
		$mestype = $sow->{'MESTYPE_TSAY'} if ($query->{'think'} ne '');
		$mestype = $sow->{'MESTYPE_WSAY'} if ($query->{'wolf'} ne '');
		$mestype = $sow->{'MESTYPE_SPSAY'} if ($query->{'sympathy'} ne '');
		$mestype = $sow->{'MESTYPE_PSAY'} if ($query->{'pixi'} ne '');
		$curpl->{'draftmestype'} = $mestype;
		$curpl->{'draftmspace'} = 0;
		$curpl->{'draftmspace'} = 1 if ($query->{'monospace'} ne '');
		$vil->writevil();
	}
	$vil->closevil();

	# HTTP/HTML�o��
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmdfrom'} = $query->{'cmdfrom'};
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

	$sow->{'http'}->{'location'} = "$link";
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'http'}->outfooter();
}

1;