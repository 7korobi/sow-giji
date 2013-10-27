package SWHttp;

#----------------------------------------
# HTTP����
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow        => $sow,
		outheader    => '',
		cache        => '',
		contenttype  => '',
		charset      => '',
		styletype    => '',
		scripttype   => '',
		location     => '',
		lastmodified => 0,
		notmodified  => 0,
		unavailable  => 0,
		etag         => '',
	};

	$self->{'protocol'} = 1;
	$self->{'protocol'} = 0 if (index($ENV{'SERVER_PROTOCOL'}, '1.0') >= 0);

	&CheckModPerl($self);
	&LoadApacheModule($self);

	return bless($self, $class);
}

#----------------------------------------
# HTTP�w�b�_�̏o��
#----------------------------------------
sub outheader {
	my $self = shift;
	my $sow = $self->{'sow'};

	return -1 if ($self->{'outheader'} eq 'output'); # ���ɏo�͍ς�
	$self->{'outheader'} = 'output';

	$self->{'gzip'} = 'off'; # gzip���[�h�ϐ����Z�b�g

	my $header = '';

	#8++ �L���b�V������̒�~�i�܁j
	if ($sow->{'cfg'}->{'ENABLED_HTTP_CACHE'} == 0) {
		$self->{'lastmodified'} = 0;
		$self->{'notmodified'} = 0;
		$self->{'etag'} = '';
	}

	# http�o�́i�f�o�b�O�p�j
	if ($sow->{'cfg'}->{'ENABLED_HTTPLOG'} > 0) {
		open (HTTP, ">$sow->{'cfg'}->{'DIR_LOG'}/" . sprintf("http%x-%3d.txt", $sow->{'time'}, rand(1000)));
		my @envkeys = keys(%ENV);
		foreach(@envkeys) {
			print HTTP "[$_] $ENV{$_}\n";
		}
	}

	# �G���e�B�e�B�^�O�̏o��
	if (($self->{'protocol'} > 0) && ($self->{'etag'} ne '') && ($self->{'notmodified'} == 0)) {
		$header .= "Etag: \"$self->{'etag'}\"\n";
	}

	# If-Modified-Since�w�b�_�Ή�
	if ($self->{'notmodified'} > 0) {
		$header .= "Status: 304 Not Modified\n";
		$header .= "\n";
		$self->CallSendHTTPHeader($header);

		print HTTP "\n\n$header" if ($sow->{'cfg'}->{'ENABLED_HTTPLOG'} > 0);
		$sow->{'debug'}->writeaplog('http', "Status: 304 Not Modified") if (defined($sow->{'cfg'}->{'FILE_304LOG'}));
		return 0; # �w�b�_�o�͂̂�
	}

	# �N�b�L�[�̏o��
	my $expirescookie = $sow->{'dt'}->getcookiedt($sow->{'time'} + $sow->{'cfg'}->{'TIMEOUT_COOKIE'});
	$sow->{'cookie_expires'} =  $sow->{'dt'}->cvtdt($sow->{'time'} + $sow->{'cfg'}->{'TIMEOUT_COOKIE'});
	my $setcookie = $sow->{'setcookie'}; # �ۗ�
	my @keys = keys(%$setcookie);
	foreach (@keys) {
		my $value = &SWBase::EncodeURL($setcookie->{$_});
		$header .= "Set-Cookie: $_=$value; expires=$expirescookie;\n";
	}

	# �L���b�V���̗L�������o��
	# �iIf-Modified-Since�t�����N�G�X�g�̗v���̂��߁j
	my $expires = $sow->{'dt'}->gethttpdt($sow->{'time'});
	$header .= "Expires: $expires\n";

	# �L���b�V���I�t���[�h
	if ($self->{'cache'} eq 'nocache') {
		$header .= "Cache-Control: no-cache, no-store\n";
		$header .= "Pragma: no-cache\n";
	}

	# Content-Type
	if ($self->{'contenttype'} eq 'xml') {
		$header .= "Content-Type: text/xml; ";
	} elsif (($self->{'contenttype'} eq 'xhtml') && (index($ENV{'HTTP_ACCEPT'}, 'application/xhtml+xml') >= 0)) {
		$header .= "Content-Type: application/xhtml+xml; ";
	} elsif ($self->{'contenttype'} eq 'plain') {
		$header .= "Content-Type: text/plain; ";
	} else {
		$header .= "Content-Type: text/html; ";
	}

	# �o�͂��镶���R�[�h�Z�b�g
	if ($self->{'charset'} eq 'jis') {
		$header .= "charset=iso-2022-jp\n";
	} elsif ($self->{'charset'} eq 'euc') {
		$header .= "charset=EUC-JP\n";
	} elsif ($self->{'charset'} eq 'utf8') {
		$header .= "charset=UTF-8\n";
	} else {
		$header .= "charset=Shift_JIS\n";
	}

	# Location
	if ($self->{'location'} ne '') {
		my $operaver = &SWBase::GetOperaVersion();
		if (($operaver >= 0) && ($operaver < 9)) {
			# Ver 8.x�ȑO�� Opera �̏ꍇ�A
			# Location �� # �ȍ~�����
			my $pos = index($self->{'location'}, '#');
			$self->{'location'} = substr($self->{'location'}, 0, $pos) if ($pos >= 0);
		}

		my $location = $self->{'location'};
		$location =~ s/&amp\;/&/;
		$header = "Status: 303 See Other\n" . $header;
		$sow->{'debug'}->writeaplog('http', "Status: 303 See Other") if (defined($sow->{'cfg'}->{'FILE_304LOG'}));
		$header .= "Location: $location\n\n";
		$self->CallSendHTTPHeader($header);

		# 303���Ή��u���E�U�̂��߂�HTML�o��
		print <<"_HTML_";
<!doctype html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
  <meta http-equiv="refresh" content="0; URL=$self->{'location'}">
  <title>See Other</title>
</head>
<body>
<p>
<a href="$self->{'location'}">See Other.</a>
</p>
</body>
</html>
_HTML_
		return 0;
	}

	# Content-Style-Type�o��
	$header .= "Content-Style-Type: $self->{'styletype'}\n" if ($self->{'styletype'} ne '');

	# Content-Script-Type�o��
	$header .= "Content-Script-Type: $self->{'scripttype'}\n" if ($self->{'scripttype'} ne '');

	#8++ �ŏI�X�V�����̏o��
	if (($self->{'lastmodified'} != 0) && ($self->{'protocol'} > 0)) {
		my $lastmodified = $sow->{'dt'}->gethttpdt($self->{'lastmodified'});
		$header .= "Last-Modified: $lastmodified\n";
	}

	if ($self->{'unavailable'} > 0) {
		# ������
		# ���ۂɂ͎g��Ȃ��i����
		$header = "Status: 503 Service Unavailable\n" . $header;
		$sow->{'debug'}->writeaplog('http', "Status: 503 Service Unavailable") if (defined($sow->{'cfg'}->{'FILE_304LOG'}));
	} else {
		# ����o��
		$header = "Status: 200 OK\n" . $header;
		$sow->{'debug'}->writeaplog('http', "Status: 200 OK") if (defined($sow->{'cfg'}->{'FILE_304LOG'}));
	}

	print HTTP "\n\n$header" if ($sow->{'cfg'}->{'ENABLED_HTTPLOG'} > 0);

	# HEAD���N�G�X�g��
	if ($ENV{'REQUEST_METHOD'} eq 'HEAD') {
		$header .= "\n";
		$self->CallSendHTTPHeader($header);
		return 0; # �w�b�_�o�͂̂�
	}

	if ($sow->{'cfg'}->{'ENABLED_HTTPLOG'} > 0) {
		print HTTP "have entity.\n";
		close(HTTP);
	}

	# �u���E�U�� gzip ���󂯕t���邩�`�F�b�N
	my $encoding = '';
	if (defined($ENV{'HTTP_ACCEPT_ENCODING'})) {
		$ENV{'HTTP_ACCEPT_ENCODING'} =~ /(x-gzip|gzip)/;
		$encoding = $1;
	}

	# gzip�]�������Ȃ�
	if (!(-e $sow->{'cfg'}->{'FILE_GZIP'}) || !$encoding || ($self->{'modperl'} != 0) || !open(GZIP, "| ". $sow->{'cfg'}->{'FILE_GZIP'})) {
		$self->CallSendHTTPHeader($header);
		return 1;
	}

	# gzip�]�����s��
	$header .= "Content-encoding: $encoding\n";
	$self->CallSendHTTPHeader($header);

	$| = 1;	# �o�͂��邽�тɃL���b�V�����X�V
	$self->{'gzip'} = 'on'; # gzip���[�h�I��
	select(GZIP);

	return 1;
}

#----------------------------------------
# GZIP�]���I��
#----------------------------------------
sub outfooter {
	my $self = shift;

	if ($self->{'gzip'} eq 'on') {
		# gzip�]�����s������
		close(GZIP);
		select(STDOUT);
		$self->{'gzip'} = 'off';
	}
	return;
}

#----------------------------------------
# ���͒l�̏���
#----------------------------------------
sub getquery {
	my $self = shift;
	my $sow = $self->{'sow'};

	my %query = ();
	my $buffer = '';
	$sow->{'QUERY_STRING'} = '';
	if ($ENV{'REQUEST_METHOD'} eq 'POST') {
		my $content_length = $ENV{'CONTENT_LENGTH'};
		if ($ENV{'CONTENT_LENGTH'} > $sow->{'cfg'}->{'MAXSIZE_QUERY'}) {
			$sow->{'debug'}->writeaplog($sow->{'APLOG_CAUTION'}, "query too long.[post/$content_length bytes]");
			$content_length = $sow->{'cfg'}->{'MAXSIZE_QUERY'};
		}
		read(STDIN, $buffer, $content_length);
	} else {
		my $content_length = length($ENV{'QUERY_STRING'});
		if ($content_length > $sow->{'cfg'}->{'MAXSIZE_QUERY'}) {
			$sow->{'debug'}->writeaplog($sow->{'APLOG_CAUTION'}, "query too long.[get/$content_length bytes]");
			$content_length = $sow->{'cfg'}->{'MAXSIZE_QUERY'};
		}
		$buffer = substr($ENV{'QUERY_STRING'}, 0, $content_length);
	}
	$sow->{'QUERY_STRING'} = $buffer;

	foreach (split(/[&;]/, $buffer)) { 
		my ($key, $data) = split(/=/);
		next if ((!defined($key)) || ($key eq ''));

		$key =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("H2", $1)/eg;
		$key =~ s/\W/ /g; #a-zA-Z0-9_ �ȊO�̕����𖳌���

		$data = '' if (!defined($data));
		$data =~ tr/\?/ /; # '?'���󔒂ɕϊ�
		$data =~ tr/+/ /;
		$data =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("H2", $1)/eg;
		my ($datalen) = length($data);
		$data =~ s/&#13\;/\n/g; # #13�̂݉��s�ɕϊ��i&#13; �������ł��Ȃ��[���΍�j
		$data =~ s/\[\[br\]\]/\n/g; # #13�̂݉��s�ɕϊ��i&#13; ���󔒂ɕϊ����Ă��܂��[���΍�j
		&SWBase::EscapeChrRef(\$data);

		if ((defined($sow->{'QUERY_INVALID'}->{$key})) && ($sow->{'QUERY_INVALID'}->{$key} == 2)) {
			# ���s��br�v�f�ɕϊ�
			$data =~ s/\r\n/<br>/g;
			$data =~ s/\r/<br>/g;
			$data =~ s/\n/<br>/g;
		} else {
			# ���s�𖳌���
			$data =~ s/\r\n/ /g;
			$data =~ s/\r/ /g;
			$data =~ s/\n/ /g;
		}
		$data =~ s/[\x00-\x1f\x7f]/ /g; # ����R�[�h�𖳌���

		# Not a Number(NaN)�AInfinity(Inf) �΍�
		if (!defined($sow->{'QUERY_INVALID'}->{$key})) {
			$sow->{'debug'}->writeaplog($sow->{'APLOG_CAUTION'}, "invalid querydata. [$key]");
			$query{$key} = 'INVALID';
		} elsif (($sow->{'QUERY_INVALID'}->{$key} == 0) && ($data =~ /(nan|inf)/i)) {
			$query{$key} = 0;
		} else {
			$query{$key} = $data;
		}

		$querylen{$key} = $datalen;
	}

	# �Z�k�n�����̕ϊ�
	my $shortquery = $sow->{'QUERY_SHORT2FULL'};
	my @keys = keys(%{$sow->{'QUERY_INVALID'}});
	foreach (@keys) {
		if ((defined($shortquery->{$_})) && (defined($query{$_}))) {
			$query{$shortquery->{$_}} = $query{$_};
			$query{$_} = '';
		}
	}

	# �߂�ǂ����[�B
	foreach (@keys) {
		$query{$_} = '' if ((!defined($query{$_})) && ($sow->{'QUERY_INVALID'}->{$_} > 0));
		$query{$_} = -1 if ((defined($query{$_})) && ($sow->{'QUERY_INVALID'}->{$_} == 0) && ($query{$_} eq ''));
	}

	return \%query;
}

#----------------------------------------
# �N�b�L�[���̎擾
#----------------------------------------
sub getcookie {
	my $self = shift;
	my %cookie = ();

	if (defined($ENV{'HTTP_COOKIE'})) {
		foreach (split(/\s*;\s*/, $ENV{'HTTP_COOKIE'})) {
			$_ =~ /=/;
			my $name = $`;
			my $value = $';
			$value =~ tr/\?/ /; # '?'���󔒂ɕϊ�
			$value =~ tr/+/ /;
			$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("H2", $1)/eg;
			$cookie{$name} = $value;
		}
	}

	return \%cookie;
}

#----------------------------------------
# Not Modified �`�F�b�N
#----------------------------------------
sub setnotmodified {
	my $self = shift;
	my $result = 0;

	if ($self->{'protocol'} == 0) {
		$self->{'lastmodified'} = 0;
		return;
	}

	# If-Modified-Since �`�F�b�N
	my $ifmodifiedsince = $self->SetIfModifiedSince();
	if ($ifmodifiedsince < 0) {
		# If-Modified-Since ������`
		return;
	} elsif ($ifmodifiedsince == 0) {
		# If-Modified-Since �� Last-Modified �������B
		$result = 1;
	}

	# If-None-Match �`�F�b�N
	my $isetag = $self->VerifyEntityTag();
	if ($isetag > 0) {
		return;
	} elsif (($isetag == 0) && ($result > 0)) {
		$result = 1;
	} else {
		$result = 0;
		$self->{'lastmodified'} = 0;
		$self->{'etag'} = '';
	}

	$self->{'notmodified'} = 1 if ($result > 0);
	return;
}

#----------------------------------------
# If-Modified-Since �̓������`�F�b�N����
# 1: �X�V����Ă���
#----------------------------------------
sub SetIfModifiedSince {
	my $self = shift;

	return -1 if (!defined($ENV{'HTTP_IF_MODIFIED_SINCE'}));

	my %month2num = (
		Jan =>  1,
		Feb =>  2,
		Mar =>  3,
		Apr =>  4,
		May =>  5,
		Jun =>  6,
		Jul =>  7,
		Aug =>  8,
		Sep =>  9,
		Oct => 10,
		Nov => 11,
		Dec => 12,
	);

	my ($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = gmtime($self->{'lastmodified'});
	$year += 1900;
	$mon++;
	my @dt = ($year, $mon, $day, $hour, $min, $sec);

	my ($ssec, $smin, $shour, $sday, $smon, $syear, $sweek);
	my @sincedt;

	my $result = 1;
	if ($ENV{'HTTP_IF_MODIFIED_SINCE'} =~ m/([A-Za-z]+,) ([0-9]+) ([A-Z][a-z][a-z]) ([0-9]+) ([0-9]+):([0-9]+):([0-9]+) GMT/) {
		@sincedt = ($4, $month2num{$3}, $2, $5, $6, $7);

		my $i;
		$result = 0;
		for ($i = 0; $i < @sincedt; $i++) {
			if ($sincedt[$i] != $dt[$i]) {
				$result = 1;
				last;
			}
		}
	}

	return $result;
}    

#----------------------------------------
# �G���e�B�e�B�^�O�̏ƍ�
# 1: �G���e�B�e�B�^�O���قȂ�
#----------------------------------------
sub VerifyEntityTag {
	my $self = shift;

	return -1 if (!defined($ENV{'HTTP_IF_NONE_MATCH'}));

	my $requestetag = $ENV{'HTTP_IF_NONE_MATCH'};
	$requestetag =~ s/^\"//;
	$requestetag =~ s/\"$//;

	if ($requestetag eq $self->{'etag'}) {
		return 0;
	} else {
		return 1;
	}
}

#----------------------------------------
# HTTP�w�b�_�̏o�͎��s
#----------------------------------------
sub CallSendHTTPHeader {
	my ($self, $header) = @_;
	my $mode = 0;
	if ($self->{'modperl'} == 0) {
		print "$header\n";
	} else {
		$mode = 1;
		my $r = '';
		if ($self->{'modperl'} >= 2) {
			$r = Apache2::RequestUtil->request;
		} else {
			$r = Apache->request;
		}
		$r->send_cgi_header("$header\n");
	}
	return $mode;
}

#----------------------------------------
# mod_perl �̃`�F�b�N
#----------------------------------------
sub CheckModPerl {
	my $self = shift;

	my $modperl = 0;
	$modperl = 1 if ($ENV{'GATEWAY_INTERFACE'} =~ /^CGI-Perl/);
	if (defined($ENV{'MOD_PERL'})) {
		if ($ENV{'MOD_PERL'} =~ /mod_perl\//i) {
			$modperl = $';
			$modperl =~ /[0-9]*\.[0-9]*/;
			$modperl = $&;
		}
	}

	$self->{'modperl'} = $modperl;
	return;
}

#----------------------------------------
# Apache���W���[���̓ǂݍ���
#----------------------------------------
sub LoadApacheModule {
	my $self = shift;
	if ($self->{'modperl'} >= 2) {
		require Apache2::RequestUtil;
	} elsif (($self->{'modperl'} >= 1.9) && ($self->{'modperl'} < 2)){
		require Apache::RequestUtil;
	} elsif ($self->{'modperl'} != 0) {
		require Apache;
	}
	return;
}

1;