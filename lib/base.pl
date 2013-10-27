package SWBase;

#----------------------------------------
# SWBBS Base
#----------------------------------------

#----------------------------------------
# SWBBS�̏�����
#----------------------------------------
sub InitSW {
	my $cfg = $_[0];

	require "$cfg->{'DIR_LIB'}/const.pl";
	my $sow = &SWConst::InitConst(); # �萔�̒�`

	$sow->{'cfg'} = $cfg;

	require "$cfg->{'DIR_LIB'}/datetime.pl";
	require "$cfg->{'DIR_LIB'}/string.pl";
	require "$cfg->{'DIR_LIB'}/http.pl";
	require "$cfg->{'DIR_LIB'}/file.pl";
	require "$cfg->{'DIR_LIB'}/lock.pl";
	require "$cfg->{'DIR_LIB'}/debug.pl";
	require "$cfg->{'DIR_LIB'}/user.pl";
	require "$cfg->{'DIR_LIB'}/charsets.pl";

	&LoadJcode($sow); # jcode.pl/JCode.pm �̓ǂݍ���

	$sow->{'http'}   = SWHttp->new($sow); # HTTP����̏�����
	$sow->{'query'}  = $sow->{'http'}->getquery(); # ���͒l
	$sow->{'cookie'} = $sow->{'http'}->getcookie(); # �N�b�L�[
	$sow->{'filter'} = &GetCookieFilter($sow); # �t�B���^�p�N�b�L�[
	$sow->{'user'} = SWUser->new($sow);
	my %setcookie;
	$sow->{'setcookie'} = \%setcookie;

	($sow->{'ua'}, $sow->{'outmode'}) = &CheckUA($sow);

	$sow->{'charsets'} = SWCharsets->new($sow);
	&LoadBasicTextRS($sow);

	$sow->{'dt'}     = SWDateTime->new($sow); # ���t�ϊ��p
	$sow->{'debug'} = SWDebug->new($sow);
	$sow->{'lock'} = SWLock->new($sow);
	$sow->{'lock'}->glock(); # �t�@�C�����b�N

	return $sow;
}

#----------------------------------------
# �����t�B���^�pCookie�f�[�^�̎擾
#----------------------------------------
sub GetCookieFilter {
	my $sow = $_[0];
	my $cookie = $sow->{'cookie'};
	my $i;

	my $pnofilters = &GetCookieValueStr($sow, 'pnofilter');
	my @pnofilter = split(/,/, $pnofilters . ',');
	my $livetypeses = &GetCookieValueStr($sow, 'livetypes');
	my @livetypes = split(/,/, $livetypeses . ',');
	for ($i = 0; $i < 4; $i++) {
		$livetypes[$i] = 0 if (!defined($livetypes[$i]));
	}
	my $typefilters = &GetCookieValueStr($sow, 'typefilter');
	my @typefilter = split(/,/, $typefilters . ',');
	for ($i = 0; $i < 4; $i++) {
		$typefilter[$i] = 0 if (!defined($typefilter[$i]));
	}
	my $clips = &GetCookieValueStr($sow, 'clip');
	my @clip = split(/,/, $clips . ',');

	my %filter = (
		pnofilter => \@pnofilter,
		livetypes => \@livetypes,
		typefilter => \@typefilter,
		layoutfilter => &GetCookieValueStr($sow, 'layoutfilter'),
		fixfilter => &GetCookieValueStr($sow, 'fixfilter'),
		mestypes => &GetCookieValueStr($sow, 'mestypes'),
		lumpfilter => &GetCookieValueStr($sow, 'lumpfilter'),
		insay => &GetCookieValueStr($sow, 'insay'),
		notepad => &GetCookieValueStr($sow, 'notepad'),
		clipboard => &GetCookieValueStr($sow, 'clipboard'),
		clip => \@clip,
	);
	return \%filter;
}

#----------------------------------------
# ������^�N�b�L�[�̒l�𓾂�
#----------------------------------------
sub GetCookieValueStr {
	my $data = '';
	$data = $_[0]->{'cookie'}->{$_[1]} if (defined($_[0]->{'cookie'}->{$_[1]}));
	return $data;
}

#----------------------------------------
# �[������
#----------------------------------------
sub CheckUA {
	my $sow = $_[0];

	# �����F��
	my $ua = '';
	my $envagent = $ENV{'HTTP_USER_AGENT'};
	$envagent = 'J-PHONE5.0' if (index($envagent, 'J-EMULATOR') == 0);
	my $is_upbrowser = index($envagent, 'UP.Browser');
	$ua = 'ihtml' if (index($envagent, 'DoCoMo') == 0);
	if (index($envagent, 'SoftBank') == 0) {
		$ua = 'sb';
	} elsif ((index($envagent, 'J-PHONE5.') == 0) || (index($envagent, 'Vodafone') == 0)) {
		$ua = 'vodax'
	} elsif (index($envagent, 'J-PHONE') == 0) {
		$ua = 'voda'
	}

	# UP.Browser�n
	if ($is_upbrowser >= 0) {
		$envagent =~ /UP\.Browser\/(\d*)\./;
		if ($1 > 5) {
			$ua = 'au';
		} else {
			$ua = 'hdml';
		}
	}

	# ua�����F��
	my @ualist = ('ihtml', 'hdml', 'au', 'voda', 'vodax', 'xhtml', 'html401', 'rss');
	foreach (@ualist) {
		$ua = $_ if ($sow->{'query'}->{'ua'} eq $_);
	}
	$ua = 'ihtml' if ($sow->{'query'}->{'ua'} eq 'mb');
	$ua = $sow->{'cfg'}->{'DEFAULT_UA'} if ($ua eq '');

	my $outmode = 'pc';
	$outmode = 'mb' if ($ua eq 'ihtml');
	$outmode = 'mb' if ($ua eq 'hdml');
	$outmode = 'mb' if ($ua eq 'au');
	$outmode = 'mb' if ($ua eq 'sb');
	$outmode = 'mb' if ($ua eq 'vodax');
	$outmode = 'mb' if ($ua eq 'voda');
	$outmode = 'rss' if ($ua eq 'rss');

	return ($ua, $outmode);
}

#----------------------------------------
# URL�G���R�[�h
#----------------------------------------
sub EncodeURL {
	my $url = $_[0];
	$url =~ s/(\W)/sprintf("%%%02X", ord($1))/eg;
	return $url;
}

#----------------------------------------
# ��{�����񃊃\�[�X�̓ǂݍ���
#----------------------------------------
sub LoadBasicTextRS {
	my $sow = $_[0];
	require "$sow->{'cfg'}->{'DIR_RS'}/trs_basic.pl";
	$sow->{'basictrs'} = &SWBasicTextRS::SWBasicTextRS($sow);

	return;
}

#----------------------------------------
# �����񃊃\�[�X�̓ǂݍ���
#----------------------------------------
sub LoadTextRS {
	my ($sow, $vil) = @_;
	my $trsid = $vil->{'trsid'};

	my $fname = "$sow->{'cfg'}->{'DIR_RS'}/trs_$trsid.pl";
	$sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, "�����񃊃\\�[�X $trsid ��������܂���B", "trsid not found.[$trsid]") if (!(-e $fname));

	require "$fname";
	my $sub = '::SWTextRS_' . $trsid . '::GetTextRS';
	my $textrs = &$sub($sow);

	$sow->{'trsid'} = $trsid;
	$sow->{'textrs'} = $textrs;
}

#----------------------------------------
# ���\�[�X�̓ǂݍ���
#----------------------------------------
sub LoadVilRS {
	my ($sow, $vil) = @_;

	# ���\�[�X�̓ǂݍ���
	my $csidlist = $sow->{'csidlist'};
	my @keys = keys(%$csidlist);
	foreach (@keys) {
		$sow->{'charsets'}->loadchrrs($_);
	}
	&LoadTextRS($sow, $vil);
}

#----------------------------------------
# ���M�p�����l�̐���
#----------------------------------------
sub GetHiddenValues {
	my ($sow, $reqvals, $tab) = @_;
	my $net = $sow->{'html'}->{'net'};

	my $hidden = '';
	my @keys = keys(%$reqvals);
	foreach (@keys) {
		next if (!defined($reqvals->{$_}));
		next if ($reqvals->{$_} eq '');
		$hidden .= "\n$tab<input type=\"hidden\" name=\"$_\" value=\"$reqvals->{$_}\"$net>";
	}
	return $hidden;
}

#----------------------------------------
# �����N�p�����l�̐���
#----------------------------------------
sub GetLinkValues {
	my ($sow, $reqvals) = @_;
	my $linkvalues = '';
	my $amp = '&';
	$amp = $sow->{'html'}->{'amp'} if (defined($sow->{'html'}->{'amp'}));

	my ($pkg, $fname, $line) = caller;

	my %shortquery = (
		cmd   => 'c',
		logid => 'l',
		mode  => 'm',
		order => 'o',
		pwd   => 'p',
		row   => 'r',
		turn  => 't',
		uid   => 'u',
		vid   => 'v',
	);

	my @keys = keys(%$reqvals);
	foreach (@keys) {
		next if (!defined($reqvals->{$_}));
		next if ($reqvals->{$_} eq '');
		$linkvalues .= $amp if ($linkvalues ne '');
		my $key = $_;
		$key = $shortquery{$_} if ((defined($shortquery{$_})) && ($sow->{'outmode'} eq 'mb'));
		my $data = &EncodeURL($reqvals->{$_});
		$linkvalues .= "$key=$data";
	}
	return $linkvalues;
}

#----------------------------------------
# �����p���������X�g���擾
#----------------------------------------
sub GetRequestValues {
	my ($sow, $reqkeys) = @_;
	my $query = $sow->{'query'};

	if ((defined($query->{'row'})) && ($query->{'row'} eq 'all')) {
		$query->{'row'} = '';
		$query->{'rowall'} = 'on'; # �����p���Ȃ�
	}

	my @basereqkeys;
	if ($query->{'cmd'} eq 'rss') {
		@basereqkeys = ('cmd', 'vid', 'row');
	} elsif (defined($query->{'vid'})) {
		@basereqkeys = ('ua', 'uid', 'pwd', 'order', 'row', 'css', 'vid', 'turn', 'mode', 'pno');
	} else {
		@basereqkeys = ('ua', 'uid', 'pwd', 'order', 'row', 'css');
	}
	push (@$reqkeys, @basereqkeys);

	my %reqvals = ();
	foreach (@$reqkeys) {
		$reqvals{$_} = $sow->{'query'}->{$_} if ((defined($sow->{'query'}->{$_})) && ($sow->{'query'}->{$_} ne ''));
	}
	return \%reqvals;
}

#----------------------------------------
# ����������ʂ̎擾
#----------------------------------------
sub GetSayPoint {
	my ($sow, $vil, $text) = @_;
	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	my $point;
	if ($saycnt->{'COST_SAY'} eq 'count') {
		$point = 1;
	} elsif ($saycnt->{'COST_SAY'} eq 'point') {
		$text =~ s/<br( \/)?>/\n/ig;
		&ExtractChrRef(\$text);
		$point = &GetSayPointJuna($text);
	} else {
		$text =~ s/<br( \/)?>/\n/ig;
		&ExtractChrRef(\$text);
		$point = &GetSayPointJunaAlpha2($text);
	}

	return $point;
}

#----------------------------------------
# ����������ʂ̎擾�i�l�T�R��j
# 50�o�C�g�܂�20pt�A�ȉ�14�o�C�g���Ƃ�1pt�B
# ���s�͈������S�o�C�g�i<br>�Ƃ��Čv�Z�j�B
#----------------------------------------
sub GetSayPointJuna {
	my $text = $_[0];

	my $count = length($text);
	my $point = 20;
	$count -= 50;
	$count = 0 if ($count < 0);
	$point += int($count / 14);

	return $point;
}

#----------------------------------------
# ����������ʂ̎擾�i�l�T�R�⃿�Q�`���P�����j
# 60�o�C�g�܂�25pt�A�ȉ�4�o�C�g���Ƃ�1pt�B
# ���s�͈������S�o�C�g�i<br>�Ƃ��Čv�Z�j�B
#----------------------------------------
sub GetSayPointJunaAlpha2 {
	my $text = $_[0];

	my $count = length($text);
	my $point = 25;
	$count -= 60;
	$count = 0 if ($count < 0);
	$point += int($count / 4);

	return $point;
}

#----------------------------------------
# Jcode.pm/jcode.pl �̓ǂݍ���
#----------------------------------------
sub LoadJcode {
	my $sow = $_[0];
	$sow->{'jcode'} = '';

	eval 'use Jcode;';
	if ($@ eq '') {
		$sow->{'jcode'} = 'pm';
	} else {
		eval "require \"$sow->{'cfg'}->{'FILE_JCODE'}\";";
		if ($@ eq '') {
			$sow->{'jcode'} = 'pl';
		}
	}

	return;
}

#----------------------------------------
# Jcode.pm/jcode.pl �ŕ����R�[�h�Z�b�g�ϊ�
#----------------------------------------
sub JcodeConvert {
	my $sow = $_[0];
	if ($sow->{'jcode'} eq 'pm') {
		&Jcode::convert($_[1], $_[2], $_[3]);
	} elsif ($sow->{'jcode'} eq 'pl') {
		&jcode::convert($_[1], $_[2], $_[3]);
	}
	return;
}

#----------------------------------------
# �������\���p�e�L�X�g�̎擾
#----------------------------------------
sub GetSayCountText {
	my ($sow, $vil, $curpl) = @_;
	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $unit = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COST_SAY'}}->{'UNIT_SAY'};

#	if ($vil->checkentried() < 0) {
#		# �G���g���[��
#		return '';
#	}

	my $say = $curpl->{'say'};
	$say = $curpl->{'gsay'} if (($curpl->{'live'} eq 'mob'));
	$say = $curpl->{'gsay'} if (($curpl->{'live'} ne 'live')&&($vil->isepilogue() == 0));

	my $saytext = "$say$unit";

	return $saytext;
}

#----------------------------------------
# �A�N�Z�X���Ă���v���C���[�̃f�[�^�𓾂�
# �������Đl���Ǘ��l�����Ή�
#----------------------------------------
sub GetCurrentPl {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_player.pl";
	my $plsingle = SWPlayer->new($sow);
	$plsingle->createpl($sow->{'uid'});
	$plsingle->{'jobname'}   = '';
	$plsingle->{'pno'}       = -1;
	$plsingle->{'live'}      = 'live';
	$plsingle->{'entrieddt'} = 0;
	$plsingle->{'emulated'}  = 0;

	my $curpl = $sow->{'curpl'};
	if (defined($curpl->{'uid'})) {
		my @keys = keys(%$curpl);
		foreach (@keys) {
			$plsingle->{$_} = $curpl->{$_};
		}
	}

	my $csidlist = $sow->{'csidlist'};
	my @keys = keys(%$csidlist);
	if ($vil->checkentried() < 0) {
		$plsingle->{'csid'}      = $keys[0];
		$plsingle->{'role'}      = $sow->{'ROLEID_UNDEF'};
		$plsingle->{'emulated'}  = 1;
	}

	if (($query->{'admin'} ne '') && ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})) {
		# �Ǘ��l�������[�h
		$plsingle->{'cid'}       = $sow->{'cfg'}->{'CID_ADMIN'};
		$plsingle->{'csid'}      = $keys[0];
		$plsingle->{'emulated'}  = 1;
	} elsif (($query->{'maker'} ne '') && ($sow->{'uid'} eq $vil->{'makeruid'})) {
		# �����Đl�������[�h
		$plsingle->{'cid'}       = $sow->{'cfg'}->{'CID_MAKER'};
		$plsingle->{'csid'}      = $keys[0];
		$plsingle->{'emulated'}  = 1;
	}

	if ($plsingle->{'emulated'} > 0) {
		return $plsingle;
	} else {
		return $curpl;
	}
}

#----------------------------------------
# �R�~�b�g�󋵂�ID�ԍ��𓾂�
#----------------------------------------
sub GetTotalCommitID {
	my ($sow, $vil) = @_;

	my $committablepl = $vil->getcommittablepl();
	my $committedpl   = $vil->getcommittedpl();
	my $totalcommit = 0;
	$totalcommit = 1 if ($committedpl >  $committablepl / 3);
	$totalcommit = 2 if ($committedpl >  $committablepl * 2 / 3);
	$totalcommit = 3 if ($committedpl == $committablepl);

	return $totalcommit;
}

#----------------------------------------
# UA��Opera�̎��o�[�W�����ԍ��𓾂�
#----------------------------------------
sub GetOperaVersion {
	my $result = -1;
	if ($ENV{'HTTP_USER_AGENT'} =~ /Opera[ \/]\d+.\d+/) {
		my $operaid = $&;
		$operaid =~ /\d+.\d+/;
		$result = $&;
	}

	return $result;
}

#----------------------------------------
# �딚���Ӄ`�F�b�N���K�v�Ȗ�E���ǂ���
#----------------------------------------
sub CheckWriteSafetyRole {
	my ($sow, $vil) = @_;

	my $curpl = &SWBase::GetCurrentPl($sow, $vil);
	my $enablecheck = 0;
	$enablecheck = 1 if ( $curpl->rolesayswitch($vil,1) ne ''); 
	$enablecheck = 1 if ( $curpl->giftsayswitch($vil,1) ne ''); 
	
	return $enablecheck;
}

#----------------------------------------
# �����Q�Ƃ̓W�J
#----------------------------------------
sub ExtractChrRef {
	my $text = shift;

	$$text =~ s/&lt\;/</g;
	$$text =~ s/&gt\;/>/g;
	$$text =~ s/&quot\;/\"/g;
	$$text =~ s/&amp\;/&/g;
}

#----------------------------------------
# �����Q�Ƃւ̃G�X�P�[�v
#----------------------------------------
sub EscapeChrRef {
	my $text = shift;

	$$text =~ s/&/&amp\;/g;
	$$text =~ s/&amp\;(#\d{3,}\;)/&$1/ig; # �P�`�Q���̕����Q�Ƃ͔O�̂��ߏR��i�蔲���j
	$$text =~ s/&(#0*127;)/&amp\;$1/g; # 127�͐���R�[�h�Ȃ̂ňꉞ�R��
#	$$text =~ s/&\#0*160\;/ /g;

	$$text =~ s/</&lt\;/g;
	$$text =~ s/>/&gt\;/g;
	$$text =~ s/\"/&quot\;/g;
}

#----------------------------------------
# �����o��
#----------------------------------------
sub ExitVillage {
	my ($sow, $vil, $exitpl, $logfile) = @_;

	$exitpl->{'delete'} = 1;
	my $chrname = $exitpl->getlongchrname();
	my $exitmes = $sow->{'textrs'}->{'EXITMES'};
	$exitmes =~ s/_NAME_/$chrname/g;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $exitmes);

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Exit. [$exitpl->{'uid'}]");
}

1;
