package SWCmdEditPenalty;

#----------------------------------------
# 
#----------------------------------------
sub CmdEditPenalty {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# �f�[�^����
	&SetDataCmdEditPenalty($sow);

	# HTTP/HTML�o��
	&OutHTMLCmdEditPenalty($sow);
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdEditPenalty {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	return;

	return if ($query->{'cmd'} eq 'restviform');

	my $vidend = 1;
	opendir(DIR, "$sow->{'cfg'}->{'DIR_VIL'}");
	my @vfiles;
	foreach (readdir(DIR)) {
		next if ((length($_) != 4) && (index($_, "_$sow->{'cfg'}->{'FILE_VIL'}") < 0));
		my $n;
		if (length($_) == 4) {
			$n = int($_);
		} else {
			$n = int(substr($_, 0, 4));
		}
		push(@vfiles, $n);
	}
	closedir(DIR);

	return if (@vfiles == 0);

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_sowgrobal.pl";
	my $sowgrobal = SWFileSWGrobal->new($sow);
	$sowgrobal->openmw();
	$sowgrobal->{'vlastid'} = @vfiles;
	$sowgrobal->writemw();
	$sowgrobal->closemw();

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";

	# ���ꗗ�̍č\�z���s
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex(1);

	my @vi = sort {$a <=> $b} @vfiles;
	foreach (@vi) {
		my $vil = SWFileVil->new($sow, $_);
		$vil->readvil();
		&SWBase::LoadVilRS($sow, $vil); # ���\�[�X�̓ǂݍ���
		$vindex->addvindex($vil);
		$vil->closevil();
	}
	$vindex->writevindex();
	$vindex->closevindex();

	return;
}

#----------------------------------------
# HTML�o��
#----------------------------------------
sub OutHTMLCmdEditPenalty {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML�o�͗p���C�u�����̓ǂݍ���
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_editpenalty.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('���ꗗ�č\�z'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlEditPenalty::OutHTMLEditPenalty($sow);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
}

1;