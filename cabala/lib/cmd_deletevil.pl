package SWCmdDeleteVil;

#----------------------------------------
# ���f�[�^�폜����
#----------------------------------------
sub CmdDeleteVil {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# �f�[�^����
	&SetDataCmdDeleteVil($sow);

	# HTTP/HTML�o��
	&OutHTMLCmdDeleteVil($sow);
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdDeleteVil {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	$query->{'vidstart'} = -1 if (!defined($query->{'vidstart'}));
	$query->{'vidend'} = -1 if (!defined($query->{'vidend'}));

	return if ($query->{'vidstart'} <= 0);

	if ($query->{'vidend'} == 0) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_sowgrobal.pl";
		my $sowgrobal = SWFileSWGrobal->new($sow);
		$sowgrobal->openmw();
		$sowgrobal->closemw();
		$query->{'vidend'} = $sowgrobal->{'vlastid'};
	}

	$query->{'vidend'} = $query->{'vidstart'} if ($query->{'vidend'} <= 0);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "���ԍ����s���ł��B", "vidstart > vidend.[$query->{'vidstart'}, $query->{'vidend'}] $errfrom") if ($query->{'vidstart'} > $query->{'vidend'});

	# ���f�[�^�폜�̎��s
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

	my $i;
	for ($i = $query->{'vidstart'}; $i <= $query->{'vidend'}; $i++) {
		my $vil = SWFileVil->new($sow, $i);
		$vil->deletevil();
	}

	return;
}

#----------------------------------------
# HTML�o��
#----------------------------------------
sub OutHTMLCmdDeleteVil {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML�o�͗p���C�u�����̓ǂݍ���
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_deletevil.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('���f�[�^�폜'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlDeleteVil::OutHTMLDeleteVil($sow);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
}

1;