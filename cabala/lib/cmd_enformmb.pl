package SWCmdEntryFormMb;

#----------------------------------------
# ���o�C���p�G���g���[��ʕ\��
#----------------------------------------
sub CmbEntryFormMb {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_formpl_mb.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_entryform_mb.pl";

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $sow->{'query'}->{'vid'});
	$vil->readvil();
	my $pllist = $vil->getpllist();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# ���͒l�`�F�b�N
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
	my $debug = $sow->{'debug'};
	$debug->raise($sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0); # �ʏ�N���Ȃ�

	# �v���C���[�Q���ς݃`�F�b�N
	if (defined($sow->{'curpl'})) {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '���Ȃ��͊��ɂ��̑��֎Q�����Ă��܂��B', "user found.[$sow->{'uid'}]");
	}

	&SWHtmlEntryFormMb::OutHTMLEntryFormMb($sow, $vil);

	$vil->closevil();

}

1;