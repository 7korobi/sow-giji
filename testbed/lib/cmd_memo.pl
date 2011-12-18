package SWCmdMemo;

#----------------------------------------
# �����\��
#----------------------------------------
sub CmdMemo {
	my $sow = $_[0];

	# �f�[�^����
	my $vil = &SetDataCmdMemo($sow);

	# HTML�o��
	&OutHTMLCmdMemo($sow, $vil);
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdMemo {
	my $sow = shift;
	my $query = $sow->{'query'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	return $vil;
}

#----------------------------------------
# HTML�o��
#----------------------------------------
sub OutHTMLCmdMemo {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $ua    = $sow->{'outmode'};

	# ���C�u�����̓ǂݍ���
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_LIB'}/file_memo.pl";
	require "$cfg->{'DIR_LIB'}/file_log.pl";
	require "$cfg->{'DIR_LIB'}/log.pl";

	my $turn = $sow->{'turn'};
	$turn = $vil->{'epilogue'} if ($sow->{'turn'} > $vil->{'epilogue'}); # �I�����Ă��鎞�͏I����

	# �����t�@�C���E�����O�t�@�C�����J��
	my $logfile = SWBoa->new($sow, $vil, $turn, 0);
	my $memofile = SWSnake->new($sow, $vil, $turn, 0);

	# �^�C�g���̎擾
#	my $title = &SWHtmlMemo::GetHTMLMemoTitle($sow, $vil);

	# HTML���[�h�̏�����
	$sow->{'html'} = SWHtml->new($sow);
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# JavaScript�̐ݒ�
	$sow->{'html'}->{'file_js'} = $sow->{'cfg'}->{'FILE_JS_VIL'};

	# HTTP�w�b�_�EHTML�w�b�_�̏o��
	my $outhttp = $sow->{'http'}->outheader();
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('����');

	# �\���s���̐ݒ�
	my $maxrow = $sow->{'cfg'}->{'MAX_ROW'};
	$maxrow = $query->{'row'} if (defined($query->{'row'}) && ($query->{'row'} ne ''));
	$query->{'rowall'} = 'on' if ((($ua ne 'mb')) && ($sow->{'turn'} < $vil->{'turn'}));
	$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne ''));
	$maxrow = -1 if ($sow->{'outmode'} eq 'pc');

	# ���O�̎擾
	my ($logs, $logkeys, $rows);
	if (($sow->{'turn'} != $vil->{'turn'}) || ($vil->{'epilogue'} >= $vil->{'turn'})) {
		($logs, $logkeys, $rows) = $memofile->getmemo($maxrow);
	} else {
		my @logs;
		$logs = \@logs;
	}
	$sow->{'lock'}->gunlock();

	# HTML�̏o��
	if ($ua eq 'mb') {
		require "$cfg->{'DIR_HTML'}/html_memo_mb.pl";
		&SWHtmlMemoMb::OutHTMLMemoMb($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows);
	} else {
		require "$cfg->{'DIR_HTML'}/html_memo_pc.pl";
		&SWHtmlMemoPC::OutHTMLMemoPC($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows);
	}
	$memofile->close();
	$logfile->close();

	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
}

1;