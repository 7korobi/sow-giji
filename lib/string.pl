package SWString;

#----------------------------------------
# ������֘A
#----------------------------------------

#----------------------------------------
# ��������w�肵���������ŋ�؂�
#----------------------------------------
sub GetTrimString {
	my ($sow, $vil, $text) = @_;
	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	$text =~ s/<br( \/)?>/\n/ig;
	&SWBase::ExtractChrRef(\$text);

	my $mes;
	if ($saycnt->{'COST_SAY'} eq 'count') {
		$mes = &GetTrimStringCounts($text, $saycnt->{'MAX_MESLINE'}, $saycnt->{'MAX_MESCNT'});
	} else {
		$mes = &GetTrimStringBytes($text, $saycnt->{'MAX_MESLINE'}, $saycnt->{'MAX_MESCNT'});
	}

	&SWBase::EscapeChrRef(\$mes);
	$mes =~ s/\n/<br>/g;

	return $mes;
}

#----------------------------------------
# ��������w�肵���s���ƕ������ŋ�؂�i�o�C�g�P�ʁj
#----------------------------------------
sub GetTrimStringBytes {
	my ($text, $maxline, $maxcount) = @_;

	$text = substr($text, 0, $maxcount);
	$text .= "\n";
#	$text =~ s/<br( \/)?>/\n/ig;
	if ($maxline > 0) {
		$text =~ /(.*\n){1,$maxline}/; # 1�̌��ɂ͋󔒂����Ȃ�
		$text = $&;
	}
	$text =~ s/\n*$//g;
#	$text =~ s/\n/<br>/g;

	my $desc = $text;
	my $sjis = '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';
	$desc =~ s/$sjis//g;
	chop($text) if ($desc ne '');

#	$text =~ s/<[^>]*\z//i;
	return $text;
}

#----------------------------------------
# ��������w�肵���s���ƕ������ŋ�؂�i�������P�ʁj
#----------------------------------------
sub GetTrimStringCounts {
	my ($text, $maxline, $maxcount) = @_;
	my $sjis = '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';

	$text .= "\n";
#	$text =~ s/<br( \/)?>/\n/ig;
	if ($maxline > 0) {
		$text =~ /(.*\n){1,$maxline}/; # 1�̌��ɂ͋󔒂����Ȃ�
		$text = $&;
		$text =~ /($sjis){1,$maxcount}/;
		$text = $&;
	}
	$text =~ s/\n*$//g;
#	$text =~ s/\n/<br>/g;

	return $text;
}

#----------------------------------------
# �������̎擾
#----------------------------------------
sub GetCountStr {
	my ($sow, $vil, $text) = @_;
	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	$text =~ s/<br( \/)?>/\n/ig;
	&SWBase::ExtractChrRef(\$text);

	my $mescount;
	if ($saycnt->{'COST_SAY'} eq 'count') {
		# �������P��
		$mescount = &GetCountStrCounts($text);
	} else {
		# �o�C�g�P��
		$mescount = length($text);
	}

	return $mescount;
}

#----------------------------------------
# ������̕������𐔂���i�S�p�E���p��킸�j
#----------------------------------------
sub GetCountStrCounts {
	my $text = $_[0];

	my $sjis = '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';
	$text =~ s/$sjis/ /g;

	return length($text);
}

#----------------------------------------
# Description�p�̕�����𓾂�
# �i�w�肵���������ŋ�؂�j
# �i�ȗ����ꂽ��u...�v��t���j
#----------------------------------------
sub GetTrimStringRSSDesc {
	my ($result, $n) = @_;
	return $result if (length($result) <= $n);

	$result = substr($result, 0, $n - 3);
	my $desc = $result;
	my $sjis = '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';
	$desc =~ s/$sjis//g;
	chop($result) if ($desc ne '');

	$result =~ s/<[^>]*\z//i;
	$result =~ s/&[^\;]*\z//i;
	$result .= '...';
	return $result;
}

#----------------------------------------
# ���������`�F�b�N
#----------------------------------------
sub CheckNoSay {
	my ($sow, $mes) = @_;
	$mes =~ s/ //g;
	$mes =~ s/<br>//g;
	$mes =~ s/�@//g;
	if ($mes eq '') {
		return 0;
	} else {
		return 1;
	}
}

1;
