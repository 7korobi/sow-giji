package SWRSS;

#----------------------------------------
# RSSを出力
#----------------------------------------
sub OutXMLRSS {
	my ($sow, $title, $desc, $link, $items) = @_;
	my $cfg = $sow->{'cfg'};
	my $i;

	# UTF-8 出力モード
	my $utf8 = 0;
	$utf8 = 1 if (($sow->{'jcode'} eq 'pm') && ($cfg->{'RSS_ENCODING_UTF8'} > 0));

	# 最終更新日時
	if (@$items > 0) {
		$sow->{'http'}->setnotmodified($items->[$#$items]->{'date'});
	} else {
		$sow->{'http'}->setnotmodified(0);
	}
	$sow->{'http'}->{'charset'} = 'utf8' if ($utf8 > 0);

	$sow->{'html'} = SWHtml->new($sow, 'rss'); # XMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader(''); # HTMLヘッダの出力

	my $urlsow = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);

	my $titlerss = "$title";
	if ($utf8 > 0) {
		&SWBase::JcodeConvert($sow, \$titlerss, 'utf8', 'sjis');
		&SWBase::JcodeConvert($sow, \$desc, 'utf8', 'sjis');
	}

	print <<"_XML_";
  <channel rdf:about="$urlsow?$linkvalues">
    <title>$titlerss</title>
    <link>$link</link>
    <description>$desc</description>
_XML_

	# items要素の出力
	print <<"_XML_";
    <items>
      <rdf:Seq>
_XML_

	for ($i = $#$items; $i >= 0; $i--) {
		print "        <rdf:li rdf:resource=\"$items->[$i]->{'link'}\" />\n";
	}

	print <<"_XML_";
      </rdf:Seq>
    </items>
  </channel>

_XML_

	# item要素の出力
	for ($i = $#$items; $i >= 0; $i--) {
		my $date = $sow->{'dt'}->cvtdtmb($items->[$i]->{'date'});
		my $dcdate = $sow->{'dt'}->cvtw3cdtf($items->[$i]->{'date'});
		my $desc = $items->[$i]->{'content'};
		$desc =~ s/<br( \/)?>/ /ig;
		$desc = &SWString::GetTrimStringRSSDesc($desc, $sow->{'cfg'}->{'MAXSIZE_RSSDESC'});
		&SWHtml::ConvertNET($sow, \$items->[$i]->{'content'});
		if ($utf8 > 0) {
			&SWBase::JcodeConvert($sow, \$items->[$i]->{'title'}, 'utf8', 'sjis');
			&SWBase::JcodeConvert($sow, \$desc, 'utf8', 'sjis');
			&SWBase::JcodeConvert($sow, \$items->[$i]->{'name'}, 'utf8', 'sjis');
			&SWBase::JcodeConvert($sow, \$items->[$i]->{'content'}, 'utf8', 'sjis');
		}

		print  <<"_XML_";
  <item rdf:about="$items->[$i]->{'link'}">
    <title>$items->[$i]->{'title'}</title>
    <link>$items->[$i]->{'link'}</link>
    <description>$desc</description>
    <dc:date>$dcdate</dc:date>
    <dc:creator>$items->[$i]->{'name'}</dc:creator>
    <content:encoded><![CDATA[
$items->[$i]->{'content'}
    ]]></content:encoded>
  </item>
_XML_
	}

	$sow->{'html'}->outfooter();
	$sow->{'http'}->outfooter();
}

#----------------------------------------
# Description用の文字列を得る
# （指定した文字数で区切る）
# （省略されたら「...」を付加）
#----------------------------------------
sub GetRSSDescText {
	my ($result, $n) = @_;
	return $result if (length($result) <= $n);

	$result = substr($result, 0, $n - 3);
	my $desc = $result;
	my $sjis = '[\x00-\x7F\xA1-\xDF]|[\x81-\x9F\xE0-\xFC][\x40-\x7E\x80-\xFC]';
	$desc =~ s/$sjis//g;
	chop($result) if ($desc ne '');

	$result =~ s/<[^>]*\z//i;
	$result .= '...';
	return $result;
}

1;
