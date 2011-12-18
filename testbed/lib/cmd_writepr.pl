package SWCmdWritePreview;

#----------------------------------------
# �����v���r���[�\��
#----------------------------------------
sub CmdWritePreview {
	my $sow = $_[0];

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $sow->{'query'}->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# ���͒l�̃`�F�b�N
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_write.pl";
	&SWValidityWrite::CheckValidityWrite($sow, $vil);

	# HTML�o��
	require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
	if (&SWString::CheckNoSay($sow, $sow->{'query'}->{'mes'}) > 0) {
		# �v���r���[�\��
		&OutHTMLCmdWritePreview($sow, $vil);
	} else {
		# �����O�\��
		my $cfg = $sow->{'cfg'};
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = "$link";
		$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
		$sow->{'http'}->outfooter();
	}
	$vil->closevil();
}

#----------------------------------------
# HTML�o��
#----------------------------------------
sub OutHTMLCmdWritePreview {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};

	# HTML�\���p�t�@�C���ǂݍ���
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	my $logid = &SWLog::CreateLogID($sow, $sow->{'MESTYPE_SAY'}, $sow->{'LOGSUBID_SAY'}, $sow->{'LOGCOUNT_UNDEF'});
	my $curpl = &SWBase::GetCurrentPl($sow, $vil);
	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);

	my $monospace = 0;
	$monospace = 1 if ($query->{'monospace'} eq 'monospace');
	$monospace = 2 if ($query->{'monospace'} eq 'report'); 

	my $expression = 0;
	$expression = $query->{'expression'} if (defined($query->{'expression'}));

	my %say = (
		uid     => $writepl->{'uid'},
		mes     => $query->{'mes'},
		mestype => $mestype,
	);
	&SWLog::ReplaceAnchor($sow, $vil, \%say); # �Ƃ肠�����Ó����`�F�b�N����

	my $logsubid = $sow->{'LOGSUBID_SAY'};
	my %log = (
		logid      => $logid,
		mestype    => $mestype,
		logsubid   => $logsubid,
		log        => $query->{'mes'},
		date       => $sow->{'time'},
		uid        => $writepl->{'uid'},
		target     => $targetpl->{'uid'},
		csid       => $writepl->{'csid'},
		cid        => $writepl->{'cid'},
		chrname    => $chrname,
		que        => 0,
		expression => $expression,
		monospace  => $monospace,
	);
	my %preview = (
		cmd => 'write',
	);

	# HTML�\��
	if ($sow->{'outmode'} eq 'mb') {
		$preview{'cmdfrom'} = 'wrformmb';
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_preview_mb.pl";
		&SWHtmlPreviewMb::OutHTMLPreviewMb($sow, $vil, \%log, \%preview);
	} else {
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_preview_pc.pl";
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_vlog_pc.pl";
		&SWHtmlPreviewPC::OutHTMLPreviewPC($sow, $vil, \%log, \%preview);
	}
}

1;