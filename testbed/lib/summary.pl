package SWSummary;

#----------------------------------------
# ���ꗗ�����o��
#----------------------------------------
sub OutSWSummary {
	my ($sow, $title, $desc, $link, $items) = @_;
	my $cfg = $sow->{'cfg'};
	my $i;

	# �ŏI�X�V����
	if (@$items > 0) {
		$sow->{'http'}->setnotmodified($items->[$#$items]->{'date'});
	} else {
		$sow->{'http'}->setnotmodified(0);
	}

	$sow->{'html'} = SWHtml->new($sow);
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader(''); # HTML�w�b�_�̏o��

	my $urlsow = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);

	my $titlerss = "$title - $sow->{'cfg'}->{'NAME_HOME'}";

	print <<"_HTML_";
<div class="channel">
<h1 class="title">$titlerss</h1>
<p class="link">$link</p>
<p class="description">$desc</p>
</div>

_HTML_

	# item�v�f�̏o��
	for ($i = $#$items; $i >= 0; $i--) {
		my $date = $sow->{'dt'}->cvtdtmb($items->[$i]->{'date'});
		my $dcdate = $sow->{'dt'}->cvtw3cdtf($items->[$i]->{'date'});
		my $desc = $items->[$i]->{'content'};
		$desc =~ s/<br( \/)?>/ /ig;
		$desc = &SWString::GetTrimStringRSSDesc($desc, $sow->{'cfg'}->{'MAXSIZE_RSSDESC'});
		&SWHtml::ConvertNET($sow, \$items->[$i]->{'content'});

		print  <<"_HTML_";
<div class="item">
<h2 class="title">$items->[$i]->{'title'}</h2>
<p class="link">$items->[$i]->{'link'}</p>
<p class="description">$desc</p>
<p class="dc:date">$dcdate</p>
<p class="content:encoded">$items->[$i]->{'content'}</p>
</div>

_HTML_
	}

	$sow->{'html'}->outfooter();
	$sow->{'http'}->outfooter();
}

#----------------------------------------
# Description�p�̕�����𓾂�
# �i�w�肵���������ŋ�؂�j
# �i�ȗ����ꂽ��u...�v��t���j
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
