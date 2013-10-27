package SWHtml;

#----------------------------------------
# HTML出力関係
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow, $forceua) = @_;
	my %bodyjs;
	my $self = {
		sow    => $sow,
		bodyjs => \%bodyjs,
		rss    => '',
	};
	$self->{'file_js'} = $sow->{'cfg'}->{'FILE_JS'};

	bless($self, $class);
	$self->initua($forceua); # 端末識別

	return $self;
}

#----------------------------------------
# 端末別初期化
#----------------------------------------
sub initua {
	my ($self, $forceua) = @_;
	my $sow = $self->{'sow'};
	my $dirlib  = $sow->{'cfg'}->{'DIR_LIB'};
	my $dirhtml = $sow->{'cfg'}->{'DIR_HTML'};

	my $ua = $sow->{'ua'};
	$ua = $forceua if (defined($forceua));

	if ($ua eq 'ihtml') {
		# DoCoMo i-mode
		# iHTML DTD
		require "$dirhtml/html_mb.pl";
		require "$dirhtml/dtd_ihtml.pl";
		$self->{'dtd'} = SWiHtml->new($self);
	} elsif ($ua eq 'hdml') {
		# au HDML系端末
		# 未対応（とりあえずi-mode用で代用）
		require "$dirhtml/html_mb.pl";
		require "$dirhtml/dtd_ihtml.pl";
		$self->{'dtd'} = SWiHtml->new($self);
	} elsif ($ua eq 'au') {
		# au WAP2.0系端末
		# XHTMLbasic DTD
		require "$dirhtml/html_mb.pl";
		require "$dirhtml/dtd_xhtmlbasic.pl";
		$self->{'dtd'} = SWXHtmlBasic->new($self);
	} elsif (($ua eq 'sb') || ($ua eq 'vodax')) {
		# SoftBank（Vodafone）Ｗ端末／3GC端末
		# とりあえずi-mode用で代用
		require "$dirhtml/html_mb.pl";
		require "$dirhtml/dtd_ihtml.pl";
		$self->{'dtd'} = SWiHtml->new($self);
	} elsif ($ua eq 'voda') {
		# Vodafone Ｃ型／Ｐ型端末
		# とりあえずi-mode用で代用
		require "$dirhtml/html_mb.pl";
		require "$dirhtml/dtd_ihtml.pl";
		$self->{'dtd'} = SWiHtml->new($self);
	} elsif ($ua eq 'rss') {
		# RSS1.0
		require "$dirhtml/dtd_rss10.pl";
		$self->{'dtd'} = SWXmlRSS10->new($self);
	} elsif ($ua eq 'plain') {
		# Plain Text
		require "$dirhtml/dtd_plaintext.pl";
		$self->{'dtd'} = SWPlainText->new($self);
	} elsif ($ua eq 'xhtml') {
		# XHTML1.1 DTD
		require "$dirhtml/html_pc.pl";
		require "$dirhtml/dtd_xhtml.pl";
		$self->{'dtd'} = SWXHtml11->new($self);
	} elsif ($ua eq 'javascript') {
		require "$dirhtml/dtd_javascript.pl";
		$self->{'dtd'} = SWjavascript->new($self);
	} else {
		# HTML4.01 Transitional DTD
		$sow->{'ua'} = 'html401';
		$sow->{'outmode'} = 'pc';
		require "$dirhtml/html_pc.pl";
		require "$dirhtml/dtd_html401.pl";
		$self->{'dtd'} = SWHtml401->new($self);
	}

	return;
}

#----------------------------------------
# HTMLヘッダの出力
#----------------------------------------
sub outheader {
	my ($self, $title) = @_;
	$self->{'dtd'}->outheader($title);
	return;
}

#----------------------------------------
# HTMLフッタの出力
#----------------------------------------
sub outfooter {
	my $self = shift;

	my $t = 0;
	my @t2 = times(); $t2[0] = $t2[0] + $t2[1];
	$t = $t2[0] - $self->{'sow'}->{'starttime'};
	$t = $t2[0];

	$self->{'dtd'}->outfooter($t);
	return;
}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）ヘッダの表示
#----------------------------------------
sub outcontentheader {
	my $self = $_[0];
	$self->{'dtd'}->outcontentheader();
	return;
}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）フッタの表示
#----------------------------------------
sub outcontentfooter {
	my $self = $_[0];
	$self->{'dtd'}->outcontentfooter();
	return;
}

#----------------------------------------
# br/img/hr要素のNETを処理する
#----------------------------------------
sub ConvertNET {
	my ($sow, $text) = @_;
	my $net = $sow->{'html'}->{'net'};

	$$text =~ s/<(br|img|hr)([^>]*)( \/)?>/<$1$2$net>/ig;
	return $text;
}

#----------------------------------------
# JSON処理
#----------------------------------------
sub ConvertJSONbyUser {
	my ($text) = @_;

	$$text =~ s/\x5c/\\\x5c/ig;
	$$text =~ s/([\x81-\x9f\xe0-\xfc]\x5c)\x5c/$1/ig; # shift-jis kanji escape cancel.
	$$text =~ s/\x22/\\\x22/ig;
	$$text =~ s/\x27/\\\x27/ig;
	return $text;
}

sub ConvertJSON {
	my ($text) = @_;

	$$text =~ s/\x22/\\\x22/ig;
	$$text =~ s/\x27/\\\x27/ig;
	return $text;
}


#----------------------------------------
# 「トップページに戻る」HTML出力
#----------------------------------------
sub OutHTMLReturn {
	my $sow = $_[0];

	if ($sow->{'query'}->{'ua'} eq 'mb') {
		&SWHtmlMb::OutHTMLReturnMb(@_);
	} else {
		&SWHtmlPC::OutHTMLReturnPC(@_);
	}

	return;
}

#----------------------------------------
# 視点切り替えモードの取得
#----------------------------------------
sub GetViewMode {
	my $sow   = shift;
	my $query = $sow->{'query'};

	my $mode = 'human'; # イレギュラー値は human に。
	$mode = 'all'   if ($query->{'mode'} eq 'all');
	$mode = 'all'   if ($query->{'mode'} eq '');
	$mode = 'wolf'  if ($query->{'mode'} eq 'wolf');
	$mode = 'girl'  if ($query->{'mode'} eq 'girl');
	$mode = 'necro' if ($query->{'mode'} eq 'necro');
	$mode = 'grave' if ($query->{'mode'} eq 'grave');
	my @modes = ('human', 'wolf', 'grave', 'girl', 'necro', 'all');
	my @modename = ('人', '狼', '墓', '少', '霊', '全');

	return ($mode, \@modes, \@modename);
}

#----------------------------------------
# 可視ログの取得
#----------------------------------------
sub GetPagesPermit {
	my ($sow, $logs, $list) = @_;

	my @pages;
	my $indexno = -1;
	my $plogid = '';
	$plogid = $logs->[0]->{'logid'} if (@$logs > 0);
	foreach (@$list) {
		push(@pages, $_) if ((!defined($_->{'logsubid'})) || ($_->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0)); # アクションは除外
		$indexno = $#pages if ($_->{'logid'} eq $plogid);
	}

	return (\@pages, $indexno);
}

1;
