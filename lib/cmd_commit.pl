package SWCmdCommit;

#----------------------------------------
# �R�~�b�g�ݒ�
#----------------------------------------
sub CmdCommit {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# �f�[�^����
	my $vil = &SetDataCmdCommit($sow);

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_wrformmb.pl";
		&SWCmdWriteFormMb::CmbWriteFormMb($sow);
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
sub SetDataCmdCommit {
	my $sow = $_[0];
	my $query  = $sow->{'query'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# �����O�֘A��{���͒l�`�F�b�N
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	my $curpl = $sow->{'curpl'};
	# �Q���`�F�b�N
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�����͎��Ԃ�i�߂鎖�͂ł��܂���B", "cannot commit.") if (($vil->{'turn'} == 0) || ($vil->isepilogue() > 0)); # �ʏ�N���Ȃ�
	if ( $vil->{'event'} != $sow->{'EVENTID_NIGHTMARE'} ) {
		$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���Ȃ��͖������ł��B�Œ�ꔭ�����Ȃ��Ǝ��Ԃ�i�߂鎖�͂ł��܂���B", "no say.") if ($curpl->{'saidcount'} <= 0);
	}

	# �R�~�b�g����
	my $savecommit = $curpl->{'commit'};
	$curpl->{'commit'} = 0;
	$curpl->{'commit'} = 1 if ($query->{'commit'} > 0);
	if ($curpl->{'commit'} > 0) {
		$vil->{'nextcommitdt'} = $sow->{'dt'}->getcommitdt($sow->{'time'});
	}
	$curpl->{'modified'} = $sow->{'time'} if ($curpl->{'commit'} != $savecommit);
	$vil->writevil();

	# ���[�^�\�͑ΏەύX����𑺃��O�֏�������
	if (($sow->{'cfg'}->{'ENABLED_PLLOG'} > 0) && ($curpl->{'commit'} != $savecommit)) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

		# ���O�f�[�^�t�@�C�����J��
		my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);

		# �������ݕ��̐���
		my $textrs = $sow->{'textrs'};
		my $mes = $textrs->{'ANNOUNCE_COMMIT'}->[$curpl->{'commit'}];
		my $curplchrname = $curpl->getlongchrname();
		$mes =~ s/_NAME_/$curplchrname/g;

		# ��������
		$logfile->writeinfo($curpl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes);
		$logfile->close();
	}
	$vil->closevil();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Committed. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, action=$query->{'commit'}]");

	return $vil;
}

1;