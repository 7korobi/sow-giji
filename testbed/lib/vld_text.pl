package SWValidityText;

#----------------------------------------
# 文字列入力値のチェック
#----------------------------------------
sub CheckValidityText {
	my ($sow, $errfrom, $data, $dataconst, $dataid, $dataname, $nozero) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/string.pl";

	my $lendata = length($data);
	if (($nozero > 0) || ($lendata != 0)) {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "$datanameが短すぎます（$lendataバイト）。$sow->{'cfg'}->{'MINSIZE_' . $dataconst} バイト以上必要です。","$dataid too short.$errfrom") if ($lendata < $sow->{'cfg'}->{"MINSIZE_$dataconst"});
	}
	if ($lendata > $sow->{'cfg'}->{"MAXSIZE_$dataconst"}) {
#		my $enabletext = &SWString::GetTrimStringBytes($data, 0, $sow->{'cfg'}->{"MAXSIZE_$dataconst"});
#		my $disenabletext = substr($data, length($enabletext));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "$datanameが長すぎます（$lendataバイト）。最大$sow->{'cfg'}->{'MAXSIZE_' . $dataconst} バイトまでです。","$dataid too long.$errfrom");
	}

	return;
}

1;