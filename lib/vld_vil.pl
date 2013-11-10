package SWValidityVil;

#----------------------------------------
# �����O�֘A��{���͒l�`�F�b�N
#----------------------------------------
sub CheckValidityVil {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$debug->raise($sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0); # �ʏ�N���Ȃ�
	$debug->raise($sow->{'APLOG_CAUTION'}, "���Ȃ��͂��̑��ɎQ�����Ă��܂���B", "no entry.$errfrom") if (($vil->checkentried() < 0) && ($query->{'maker'} eq '') && ($query->{'admin'} eq '')); # �ʏ�N���Ȃ�
	$debug->raise($sow->{'APLOG_NOTICE'}, "���̑��͏I�����܂����B", "It's ended.$errfrom") if ($vil->{'turn'} > $vil->{'epilogue'}); # �����I�����Ă��鎞

	return;
}

1;