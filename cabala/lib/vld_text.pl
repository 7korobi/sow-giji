package SWValidityText;

#----------------------------------------
# ��������͒l�̃`�F�b�N
#----------------------------------------
sub CheckValidityText {
	my ($sow, $errfrom, $data, $dataconst, $dataid, $dataname, $nozero) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/string.pl";

	my $lendata = length($data);
	if (($nozero > 0) || ($lendata != 0)) {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "$dataname���Z�����܂��i$lendata�o�C�g�j�B$sow->{'cfg'}->{'MINSIZE_' . $dataconst} �o�C�g�ȏ�K�v�ł��B","$dataid too short.$errfrom") if ($lendata < $sow->{'cfg'}->{"MINSIZE_$dataconst"});
	}
	if ($lendata > $sow->{'cfg'}->{"MAXSIZE_$dataconst"}) {
#		my $enabletext = &SWString::GetTrimStringBytes($data, 0, $sow->{'cfg'}->{"MAXSIZE_$dataconst"});
#		my $disenabletext = substr($data, length($enabletext));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "$dataname���������܂��i$lendata�o�C�g�j�B�ő�$sow->{'cfg'}->{'MAXSIZE_' . $dataconst} �o�C�g�܂łł��B","$dataid too long.$errfrom");
	}

	return;
}

1;