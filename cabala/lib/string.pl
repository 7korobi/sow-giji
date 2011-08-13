package SWString;

#----------------------------------------
# 文字列関連
#----------------------------------------

#----------------------------------------
# 文字列を指定した文字数で区切る
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
# 文字列を指定した行数と文字数で区切る（バイト単位）
#----------------------------------------
sub GetTrimStringBytes {
	my ($text, $maxline, $maxcount) = @_;

	$text = substr($text, 0, $maxcount);
	$text .= "\n";
#	$text =~ s/<br( \/)?>/\n/ig;
	if ($maxline > 0) {
		$text =~ /(.*\n){1,$maxline}/; # 1の後ろには空白を入れない
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
# 文字列を指定した行数と文字数で区切る（文字数単位）
#----------------------------------------
sub GetTrimStringCounts {
	my ($text, $maxline, $maxcount) = @_;
	my $sjis = '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';

	$text .= "\n";
#	$text =~ s/<br( \/)?>/\n/ig;
	if ($maxline > 0) {
		$text =~ /(.*\n){1,$maxline}/; # 1の後ろには空白を入れない
		$text = $&;
		$text =~ /($sjis){1,$maxcount}/;
		$text = $&;
	}
	$text =~ s/\n*$//g;
#	$text =~ s/\n/<br>/g;

	return $text;
}

#----------------------------------------
# 文字数の取得
#----------------------------------------
sub GetCountStr {
	my ($sow, $vil, $text) = @_;
	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	$text =~ s/<br( \/)?>/\n/ig;
	&SWBase::ExtractChrRef(\$text);

	my $mescount;
	if ($saycnt->{'COST_SAY'} eq 'count') {
		# 文字数単位
		$mescount = &GetCountStrCounts($text);
	} else {
		# バイト単位
		$mescount = length($text);
	}

	return $mescount;
}

#----------------------------------------
# 文字列の文字数を数える（全角・半角問わず）
#----------------------------------------
sub GetCountStrCounts {
	my $text = $_[0];

	my $sjis = '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';
	$text =~ s/$sjis/ /g;

	return length($text);
}

#----------------------------------------
# Description用の文字列を得る
# （指定した文字数で区切る）
# （省略されたら「...」を付加）
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
# 発言無しチェック
#----------------------------------------
sub CheckNoSay {
	my ($sow, $mes) = @_;
	$mes =~ s/ //g;
	$mes =~ s/<br>//g;
	$mes =~ s/　//g;
	if ($mes eq '') {
		return 0;
	} else {
		return 1;
	}
}

1;
