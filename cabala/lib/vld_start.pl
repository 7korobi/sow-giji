package SWValidityStart;

#----------------------------------------
# ���蓮�J�n���l�`�F�b�N
#----------------------------------------
sub CheckValidityStart {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $pllist = $vil->getpllist();
	my $committablepl = $vil->getcommittablepl();
	my $errfrom = "[uid=$sow->{'uid'}, vid=$vil->{'vid'}, cmd=$query->{'cmd'}]";

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	$debug->raise($sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	$debug->raise($sow->{'APLOG_CAUTION'}, "�l��������܂���B�_�~�[�L�������܂߁A�Œ� 4 �l�K�v�ł��B", "need 4 persons.$errfrom") if (@$pllist < 4);
	$debug->raise($sow->{'APLOG_CAUTION'}, "�l��������܂���B���[���锆�R�����K�v�ł��B", "need juror.$errfrom") if (($committablepl < 1)&&($vil->{'mob'} eq 'juror');

	$debug->raise($sow->{'APLOG_CAUTION'}, "�����J�n����ɂ͑����Đl�������Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if (($sow->{'uid'} ne $vil->{'makeruid'}) && ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}));

	return;
}

1;