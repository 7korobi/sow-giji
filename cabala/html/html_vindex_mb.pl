package SWHtmlVIndexMb;

#----------------------------------------
# ���ꗗ��HTML�o�́i���o�C���j
#----------------------------------------
sub OutHTMLVIndexMb {
	my $sow = $_[0];
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	require "$cfg->{'DIR_LIB'}/file_vindex.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_vindex.pl";

	# ���ꗗ�f�[�^�ǂݍ���
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();

	my $linkvalue;
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	# HTTP/HTML�̏o��
	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader('���ꗗ'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $vilist = $vindex->getvilist();

#	my @imgratings = '';
#	my $rating = $cfg->{'RATING'};
#	my $ratingorder = $rating->{'ORDER'};
#	foreach (@$ratingorder) {
#		push(@imgratings, "[$rating->{$_}->{'ALT'}]") if ($rating->{$_}->{'FILE'} ne '');
#	}
#	my $imgrating = join(' ', @imgratings);

	if ($sow->{'query'}->{'cmd'} eq 'vindex') {
		print <<"_HTML_";
����W���^�J�n�҂�<br$net>
_HTML_

		# ��W���^�J�n�҂����̕\��
		my $vicount = 0;
		foreach (@$vilist) {
			next if ($_->{'vstatus'} ne $sow->{'VSTATUSID_PRO'});
			$vicount += &OutHTMLVIndexSingleMb($sow, $_);
		}
		if ($vicount == 0) {
			print "�Ȃ��B<br$net>";
		}

		print <<"_HTML_";
<hr$net>

���i�s���^����<br$net>
_HTML_

		# �i�s���^�����ς݂̑��̕\��
		$vicount = 0;
		foreach (@$vilist) {
			next if (($_->{'vstatus'} ne $sow->{'VSTATUSID_PLAY'}) && ($_->{'vstatus'} ne $sow->{'VSTATUSID_EP'}) && ($_->{'vstatus'} ne $sow->{'VSTATUSID_SCRAP'}));
			$vicount += &OutHTMLVIndexSingleMb($sow, $_);
		}
		if ($vicount == 0) {
			print "�Ȃ��B<br$net>";
		}

		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'} = 'oldlog';
		my $link = &SWBase::GetLinkValues($sow, $reqvals);

		print <<"_HTML_";
<hr$net>

<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">�I���ς�</a>
<hr$net>

_HTML_
	} else {
		print <<"_HTML_";
���I���ς�<br$net>
_HTML_

		my $maxrow = $sow->{'cfg'}->{'MAX_ROW_MB'}; # �W���s��
		$maxrow = $query->{'row'} if (defined($query->{'row'}) && ($query->{'row'} ne '')); # �����ɂ��s���w��
		$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne '')); # �����ɂ��S�\���w��

		my $pageno = 0;
		$pageno = $query->{'pageno'} if (defined($query->{'pageno'}));

		# �I���ς݂̑��̕\��
		my $vicount = 0;
		my $virow = -1;
		foreach (@$vilist) {
			next if (($_->{'vstatus'} ne $sow->{'VSTATUSID_END'}) && ($_->{'vstatus'} ne $sow->{'VSTATUSID_SCRAPEND'}));
			$virow++;
			if ($maxrow > 0) {
				next if ($virow < $pageno * $maxrow);
				next if ($virow >= ($pageno + 1) * $maxrow);
			}
			$vicount += &OutHTMLVIndexSingleMb($sow, $_);
		}
		if ($vicount == 0) {
			print "�Ȃ��B<br$net>";
		}

		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'} = $query->{'cmd'};

		my $prev = '�O';
		if (($pageno > 0) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno - 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			$prev = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">�O</a>";
		}

		my $next = '��';
		if ((($pageno + 1) * $maxrow <= $virow) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno + 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			$next = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">��</a>";
		}

		$reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'} = 'vindex';
		my $link = &SWBase::GetLinkValues($sow, $reqvals);

		print <<"_HTML_";
<hr$net>

$prev/$next/<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">���ꗗ</a>
<hr$net>

_HTML_
	}

	# �T�|�[�g�f���ւ̃����N
	my $urlbbs = $sow->{'cfg'}->{'URL_BBS_MB'};
	my $namebbs = $sow->{'cfg'}->{'NAME_BBS_MB'};
	if ($sow->{'cfg'}->{'URL_BBS_MB'} eq '') {
		$urlbbs  = $sow->{'cfg'}->{'URL_BBS'};
		$namebbs = $sow->{'cfg'}->{'NAME_BBS'};
	}
	if ($urlbbs ne '') {
		print <<"_HTML_";
<a href="$urlbbs">$namebbs</a>
_HTML_
	}
	print "\n";

	$vindex->closevindex();
	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# ���f�[�^��HTML�o�́i��s���j
#----------------------------------------
sub OutHTMLVIndexSingleMb {
	my ($sow, $vindexsingle) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	my $vil = SWFileVil->new($sow, $_->{'vid'});
	$vil->readvil();
	my $pllist = $vil->getpllist();
	$vil->closevil();

	if (!defined($vil->{'trsid'})) {
		print <<"_HTML_";
$vil->{'vid'}���̃f�[�^���擾�ł��܂���B<br$net>
_HTML_
		return 0;
	}

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = $vindexsingle->{'vid'};
	$reqvals->{'c'}   = 'vinfo';
	my $link = &SWBase::GetLinkValues($sow, $reqvals);

	my $imgpwdkey = '';
	if (defined($vil->{'entrylimit'})) {
		$imgpwdkey = "[��] " if ($vil->{'entrylimit'} eq 'password');
	}

	my $imgrating = '';
	if ((defined($vil->{'rating'})) && ($vil->{'rating'} ne '')) {
		if (defined($sow->{'cfg'}->{'RATING'}->{$vil->{'rating'}}->{'FILE'})) {
			my $rating = $sow->{'cfg'}->{'RATING'}->{$vil->{'rating'}};
			$imgrating = "[$rating->{'ALT'}] " if ($rating->{'FILE'} ne '');
		}
	}

	print <<"_HTML_";
$imgpwdkey$imgrating<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">$_->{'vid'} $vil->{'vname'}</a><br$net>
_HTML_

	return 1;
}

1;
