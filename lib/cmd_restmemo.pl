package SWCmdRestMemoIndex;

#----------------------------------------
# �����C���f�b�N�X�̍č\�z
#----------------------------------------
sub CmdRestMemoIndex {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# �f�[�^����
	my $vil = &SetRestMemoIndex($sow);

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_memo.pl";
		$sow->{'query'}->{'cmd'} = 'memo';
		&SWCmdMemo::CmdMemo($sow);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'}  = 'memo';
		$reqvals->{'turn'} = '';
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
sub SetRestMemoIndex {
	my $sow = $_[0];
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$debug->raise($sow->{'APLOG_CAUTION'}, '�Ǘ�����������܂���B', "cannot restructure memoidx.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	# ���f�[�^�̓ǂݍ���
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
	my $memofile = SWSnake->new($sow, $vil, $sow->{'turn'}, 0);
	$memofile->restructure();
	$memofile->close();
	$vil->closevil();

	return ($vil, $checknosay);
}

1;