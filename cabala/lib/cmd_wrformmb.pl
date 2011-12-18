package SWCmdWriteFormMb;

#----------------------------------------
# ���o�C���p�������݉�ʕ\��
#----------------------------------------
sub CmbWriteFormMb {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_formpl_mb.pl";

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $sow->{'query'}->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# ���͒l�`�F�b�N
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
	my $debug = $sow->{'debug'};
	$debug->raise($sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0); # �ʏ�N���Ȃ�
	$debug->raise($sow->{'APLOG_CAUTION'}, "���Ȃ��͂��̑��ɎQ�����Ă��܂���B", "no entry.$errfrom") if (($vil->checkentried() < 0) && ($query->{'maker'} eq '') && ($query->{'admin'} eq '')); # �ʏ�N���Ȃ�
	$debug->raise($sow->{'APLOG_NOTICE'}, "���̑��͏I�����܂����B", "It's ended.$errfrom") if ($vil->{'turn'} > $vil->{'epilogue'}); # �ʏ�N���Ȃ�

	&SWHtmlPlayerFormMb::OutHTMLPlayerFormMb ($sow, $vil);

	$vil->closevil();

}

1;