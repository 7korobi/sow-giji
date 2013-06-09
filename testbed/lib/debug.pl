package SWDebug;

#----------------------------------------
# �f�o�b�O�p�֘A
#----------------------------------------
# APLOG_WARNING: �ی��Ƃ��ăG���[���o��R�[�h�͏����Ă��邪�A�{���������Ȃ��͂��̃G���[�i����`��ݒ�~�X�������̂��́j
# APLOG_CAUTION: �s�����삪�����Ǝv����G���[
# APLOG_NOTICE: ����~�X�ɂ��G���[
# APLOG_POSTED: ���샍�O
# APLOG_OTHERS: ���Ƃǂ��ł�������

# LEVEL_APLOG
# 0: �A�v���P�[�V�������O��f���Ȃ�
# 1: APLOG_WARNING �� APLOG_CAUTION �̂ݏo��
# 2: 1�ɉ��� APLOG_NOTICE ���o��
# 3: 2�ɉ��� APLOG_POSTED ���o��
# 4: �S�ďo��
# 5: sow.cgi�ւ̑S�ẴA�N�Z�X�ɑ΂��� QUERY_STRING �� cookie ���o��

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow => $sow,
		check => 'check',
		checklogin => 0,
		error => 0,
	};

	return bless($self, $class);
}

#----------------------------------------
# �G���[����
#----------------------------------------
sub raise {
	my ($self, $level, $mes1, $mes2, $mes3, $mes4) = @_;
	my $sow = $self->{'sow'};

	$self->writeaplog($level, $mes2);
	$sow->{'lock'}->gunlock();
	$sow->{'user'}->resetcookie($sow->{'setcookie'}) if ($self->{'checklogin'} > 0);
	$self->OutHTMLError($mes1, $mes2, $mes3, $mes4);
}

#----------------------------------------
# �A�v���P�[�V�������O��������
#----------------------------------------
sub writeaplog {
	my ($self, $type, $mes) = @_;
	my $sow = $self->{'sow'};

	return if ($sow->{'cfg'}->{'ENABLED_APLOG'} == 0);

	my $level = $sow->{'cfg'}->{'LEVEL_APLOG'};
	return if ($level == 0);
	return if (($level < 2) && ($type eq $sow->{'APLOG_NOTICE'}));
	return if (($level < 3) && ($type eq $sow->{'APLOG_POSTED'}));
	return if (($level < 4) && ($type eq $sow->{'APLOG_OTHERS'}));

	my $datafile = $sow->{'cfg'}->{'FILE_ERRLOG'};
	$datafile = $sow->{'cfg'}->{'FILE_APLOG'} if (($type eq $sow->{'APLOG_POSTED'}) || ($type eq $sow->{'APLOG_OTHERS'}));
	$datafile = "$sow->{'cfg'}->{'DIR_LOG'}/$sow->{'cfg'}->{'FILE_304LOG'}" if (($type eq 'http') && (defined($sow->{'cfg'}->{'FILE_304LOG'}))); # �f�o�b�O�p

	my ($pkg, $fname, $line) = caller;

	# �t�@�C�����b�N�ł��Ă��Ȃ����� die ����
#	die "[$type] $mes [from $pkg $fname line $line]" if ($sow->{'lock'}->{'lock'} ne 'lock');

	# �t�@�C�����b�N�ł��Ă��Ȃ����� return ����
#	return if ($sow->{'lock'}->{'lock'} ne 'lock');

	# ���O�̃��[�e�[�V����
	&FileRotation($sow, $datafile);

	# ��������
	open (APLOG, ">>$datafile") || die "aplog could not create.[from $pkg $fname line $line]";
	my $t = $sow->{'dt'}->cvtdt($sow->{'time'});
	print APLOG "($type) [$t] $mes";

	# WARNING �� CAUTION �̏ꍇ�̓G���[���x���Ɋ֌W�Ȃ� cookie �� ���͒l���o��
	if (($type eq $sow->{'APLOG_WARNING'}) || ($type eq $sow->{'APLOG_CAUTION'})) {
		my $querystring = $sow->{'QUERY_STRING'} . ';';
		$querystring =~ s/pwd=.*?[&;]/pwd=xxxxxxxx&/g;
		print APLOG " / $querystring";

		if (defined($ENV{'HTTP_COOKIE'})) {
			my $cookies = $ENV{'HTTP_COOKIE'} . ';';
			$cookies =~ s/pwd=.*?;/pwd=xxxxxxxx;/g;
			print APLOG " / $cookies";
		}
	}
	print APLOG "\n";
	close(APLOG);
	return;
}

#----------------------------------------
# ���͒l���A�v���P�[�V�������O�֏o��
#----------------------------------------
sub writequerylog {
	my ($self, $type, $mes) = @_;
	my $sow = $self->{'sow'};

	my $querystring = $sow->{'QUERY_STRING'} . ';';
	$querystring =~ s/pwd=.*?[&;]/pwd=xxxxxxxx&/g;
	$querystring =~ s/p=.*?[&;]/p=xxxxxxxx&/g;
	$self->writeaplog($sow->{'APLOG_OTHERS'}, "QUERY_STRING: $querystring");

	if (defined($ENV{'HTTP_COOKIE'})) {
		my $cookies = $ENV{'HTTP_COOKIE'} . ';';
		$cookies =~ s/pwd=.*?;/pwd=xxxxxxxx;/g;
		$self->writeaplog($sow->{'APLOG_OTHERS'}, "COOKIES: $cookies");
	}
}

#----------------------------------------
# cookie�o�͒l���A�v���P�[�V�������O�֏o��
#----------------------------------------
sub writecookielog {
	my ($self, $type, $mes) = @_;
	my $sow = $self->{'sow'};

	if (defined($sow->{'setcookie'})) {
		my $setcookie = $sow->{'setcookie'};
		my @keys = keys(%$setcookie);
		$self->writeaplog($sow->{'APLOG_OTHERS'}, "SET-COOKIES: @keys");
	}
}

#----------------------------------------
# �t�@�C�����[�e�[�V����
#----------------------------------------
sub FileRotation {
	my ($sow, $datafile) = @_;

	return unless (-e $datafile);
	my $size = (-s $datafile);
	if ($size >= $sow->{'cfg'}->{'MAXSIZE_APLOG'}) {
		for ($i = $sow->{'cfg'}->{'MAXNO_APLOG'}; $i > 0; $i--) {
			my $fileid = '.' . ($i - 1);
			my $fileidnext = ".$i";
			$fileid = '' if ($i == 1);
			rename("$datafile$fileid", "$datafile$fileidnext") if (-e "$datafile$fileid");
		}
	}
}

#----------------------------------------
# �G���[�\��
#----------------------------------------
sub OutHTMLError {
	my ($self, $mes1, $mes2, $mes3, $mes4) = @_;
	my $sow = $self->{'sow'};
	my $cfg = $sow->{'cfg'};

	# ������i�v���[�v�ɓ����Ă����� die ����i�{�����蓾�Ȃ��j�B
	die "$mes1 $mes2\n" if ($self->{'error'} == 1);
	$self->{'error'} = 1;

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	$sow->{'html'} = SWHtml->new($sow) if (!defined($sow->{'html'}->{'sow'}));;
	$sow->{'http'}->outheader();
	$sow->{'html'}->outheader($mes1);
	$sow->{'html'}->outcontentheader();

	if ($sow->{'outmode'} eq 'mb') {
		$self->OutHTMLErrorMb($mes1, $mes2, $mes3, $mes4);
	} else {
		$self->OutHTMLErrorPC($mes1, $mes2, $mes3, $mes4);
	}

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter();
	$sow->{'http'}->outfooter();
	exit();
}

#----------------------------------------
# �G���[�\���iPC���[�h�j
#----------------------------------------
sub OutHTMLErrorPC {
	my ($self, $mes1, $mes2, $mes3, $mes4) = @_;
	my $sow = $self->{'sow'};
	my $cfg = $sow->{'cfg'};
	my $cmd = $sow->{'query'}->{'cmd'};

	print <<"_HTML_";
<script>
var errors = [];
errors.push("$mes1");
errors.push("$mes2");
gon = {
	"errors": {
		"$cmd": errors
	}
};
</script>
<div class="paragraph">
<p>$mes1</p>
<p>$mes2</p>
</div>

_HTML_

	if (defined($mes3)) {
		print <<"_HTML_";
<blockquote>
$mes3<span class="infotext">$mes4</span>
</blockquote>

_HTML_
	}

	print <<"_HTML_";
<p class="return">
<a href="$cfg->{'BASEDIR_CGIERR'}/$cfg->{'FILE_SOW'}">�K���Ƀg�b�v�y�[�W�ɖ߂�</a>
</p>

_HTML_

}

#----------------------------------------
# �G���[�\���i���o�C�����[�h�j
#----------------------------------------
sub OutHTMLErrorMb {
	my ($self, $mes1, $mes2, $mes3, $mes4) = @_;
	my $sow = $self->{'sow'};
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	if (defined($sow->{'file'}->{'vil'})) {
		my $vil = $sow->{'file'}->{'vil'}->{'parent'};
		&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0);
	}

	print <<"_HTML_";
<p>$mes1</p>
<p>$mes2</p>
<hr$net>

_HTML_

	if (defined($sow->{'file'}->{'vil'})) {
		my $vil = $sow->{'file'}->{'vil'}->{'parent'};
		&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'uid'} = '';
		$reqvals->{'pwd'} = '';
		$reqvals->{'vid'} = '';
		my $urlsow = &SWBase::GetLinkValues($sow, $reqvals);
		print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$urlsow\">�߂�</a>\n";
	}
}

1;
