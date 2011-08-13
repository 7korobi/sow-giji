package SWCmdWrite;

#----------------------------------------
# ����
#----------------------------------------
sub CmdWrite {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	require "$cfg->{'DIR_LIB'}/write.pl";

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# �딚�`�F�b�N
	if (&CheckWriteSafety($sow, $vil) == 0) {
		# �l�T�̒ʏ픭���Ń`�F�b�N��t���Ă��Ȃ���
		$vil->closevil();
		require "$cfg->{'DIR_LIB'}/cmd_writepr.pl";
		$query->{'cmd'} = 'writepr';
		&SWCmdWritePreview::CmdWritePreview($sow);
		return;
	}

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# ���͒l�̃`�F�b�N
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_write.pl";
	&SWValidityWrite::CheckValidityWrite($sow, $vil);

	# ������������
	my $checknosay = &SWString::CheckNoSay($sow, $sow->{'query'}->{'mes'});
	if ($checknosay > 0) {
		my $writepl = &SWBase::GetCurrentPl($sow, $vil);
		&SWWrite::ExecuteCmdWrite($sow, $vil, $writepl);
		$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "WriteSay. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");
	}
	$vil->closevil();

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		if ($checknosay > 0) {
			require "$cfg->{'DIR_LIB'}/file_log.pl";
			require "$cfg->{'DIR_LIB'}/log.pl";
			require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
			&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
		} else {
			require "$cfg->{'DIR_HTML'}/html.pl";
			require "$cfg->{'DIR_HTML'}/html_formpl_mb.pl";
			&SWHtmlPlayerFormMb::OutHTMLPlayerFormMb ($sow, $vil);
		}
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
# �딚�`�F�b�N
#----------------------------------------
sub CheckWriteSafety {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	$curpl = $sow->{'curpl'};

	return 1 if (($query->{'admin'} ne '') && ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})); # �Ǘ��l�����Ȃ���Ȃ�
	return 1 if (($query->{'maker'} ne '') && ($sow->{'uid'} eq $vil->{'makeruid'})); # �����Đl�����Ȃ���Ȃ�

	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);
	return 1 if (&SWBase::CheckWriteSafetyRole($sow, $vil) == 0); # �閧��b�̂ł��Ȃ���E�Ȃ���Ȃ�
	return 1 if ($que == 0); # �ʏ픭���ł͂Ȃ��Ȃ���Ȃ�
	return 1 if ($vil->isepilogue() > 0); # �G�s�Ȃ���Ȃ�
	return 1 if ($query->{'safety'} eq 'on'); # �m�F�̃`�F�b�N���t���Ă���Ȃ���Ȃ�

	return 0;
}

1;