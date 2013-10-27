package SWCmdEditVilForm;

#----------------------------------------
# ���ҏW�\��
#----------------------------------------
sub CmdEditVilForm {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	if($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}){
		if($sow->{'uid'} eq $vil->{'makeruid'}){
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���쐬�҂ɂ͂��̑��̕ҏW�͍s���܂���B", "no permition.$errfrom") if (($vil->isscrap()));
		}else{
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���쐬�҈ȊO�ɂ͑��̕ҏW�͍s���܂���B", "no permition.$errfrom") if (($vil->isepilogue() == 0));
		}
	}

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevilform.pl";

	# ���쐬��ʂ�HTML�o��
	# �p������̕����@�\�̂��߁A�p�����̕ҏW�̓��O�č쐬�B
	$vil->{'turn'} = 0 if ($vil->isscrap());
	&SWHtmlMakeVilForm::OutHTMLMakeVilForm($sow, $vil);
}

1;