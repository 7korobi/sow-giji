package SWHtml;

#----------------------------------------
# HTML�o�͊֌W
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
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
	$self->initua($forceua); # �[������

	return $self;
}

#----------------------------------------
# �[���ʏ�����
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
		# au HDML�n�[��
		# ���Ή��i�Ƃ肠����i-mode�p�ő�p�j
		require "$dirhtml/html_mb.pl";
		require "$dirhtml/dtd_ihtml.pl";
		$self->{'dtd'} = SWiHtml->new($self);
	} elsif ($ua eq 'au') {
		# au WAP2.0�n�[��
		# XHTMLbasic DTD
		require "$dirhtml/html_mb.pl";
		require "$dirhtml/dtd_xhtmlbasic.pl";
		$self->{'dtd'} = SWXHtmlBasic->new($self);
	} elsif (($ua eq 'sb') || ($ua eq 'vodax')) {
		# SoftBank�iVodafone�j�v�[���^3GC�[��
		# �Ƃ肠����i-mode�p�ő�p
		require "$dirhtml/html_mb.pl";
		require "$dirhtml/dtd_ihtml.pl";
		$self->{'dtd'} = SWiHtml->new($self);
	} elsif ($ua eq 'voda') {
		# Vodafone �b�^�^�o�^�[��
		# �Ƃ肠����i-mode�p�ő�p
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
# HTML�w�b�_�̏o��
#----------------------------------------
sub outheader {
	my ($self, $title) = @_;
	$self->{'dtd'}->outheader($title);
	return;
}

#----------------------------------------
# HTML�t�b�^�̏o��
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
# �{�R���e���c���i�񔭌��t�B���^�j�w�b�_�̕\��
#----------------------------------------
sub outcontentheader {
	my $self = $_[0];
	$self->{'dtd'}->outcontentheader();
	return;
}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�t�b�^�̕\��
#----------------------------------------
sub outcontentfooter {
	my $self = $_[0];
	$self->{'dtd'}->outcontentfooter();
	return;
}

#----------------------------------------
# br/img/hr�v�f��NET����������
#----------------------------------------
sub ConvertNET {
	my ($sow, $text) = @_;
	my $net = $sow->{'html'}->{'net'};

	$$text =~ s/<(br|img|hr)([^>]*)( \/)?>/<$1$2$net>/ig;
	return $text;
}

#----------------------------------------
# JSON����
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
# �u�g�b�v�y�[�W�ɖ߂�vHTML�o��
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
# ���_�؂�ւ����[�h�̎擾
#----------------------------------------
sub GetViewMode {
	my $sow   = shift;
	my $query = $sow->{'query'};

	my $mode = 'human'; # �C���M�����[�l�� human �ɁB
	$mode = 'all'   if ($query->{'mode'} eq 'all');
	$mode = 'all'   if ($query->{'mode'} eq '');
	$mode = 'wolf'  if ($query->{'mode'} eq 'wolf');
	$mode = 'girl'  if ($query->{'mode'} eq 'girl');
	$mode = 'necro' if ($query->{'mode'} eq 'necro');
	$mode = 'grave' if ($query->{'mode'} eq 'grave');
	my @modes = ('human', 'wolf', 'grave', 'girl', 'necro', 'all');
	my @modename = ('�l', '�T', '��', '��', '��', '�S');

	return ($mode, \@modes, \@modename);
}

#----------------------------------------
# �����O�̎擾
#----------------------------------------
sub GetPagesPermit {
	my ($sow, $logs, $list) = @_;

	my @pages;
	my $indexno = -1;
	my $plogid = '';
	$plogid = $logs->[0]->{'logid'} if (@$logs > 0);
	foreach (@$list) {
		push(@pages, $_) if ((!defined($_->{'logsubid'})) || ($_->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0)); # �A�N�V�����͏��O
		$indexno = $#pages if ($_->{'logid'} eq $plogid);
	}

	return (\@pages, $indexno);
}

1;
