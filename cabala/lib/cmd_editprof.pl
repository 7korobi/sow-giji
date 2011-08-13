package SWCmdEditProfile;

#----------------------------------------
# ���[�U�[���ҏW�����\��
#----------------------------------------
sub CmdEditProfile {
	my $sow = $_[0];

	# ���ҏW����
	&SetDataCmdEditProfile($sow);

	# HTML�o��
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_editprof.pl";
	&SWHtmlEditProfile::OutHTMLEditProfile($sow);
}

#----------------------------------------
# ���[�U�[���ҏW����
#----------------------------------------
sub SetDataCmdEditProfile {
	my $sow  = shift;
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$debug->raise($sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0); # �ʏ�N���Ȃ�

	my $lenhn = length($query->{'handlename'});
	$debug->raise($sow->{'APLOG_CAUTION'}, "�n���h�������������܂��i$lenhn�o�C�g�j�B�ő�$sow->{'cfg'}->{'MAXSIZE_HANDLENAME'}�o�C�g�܂łł��B", "handle name too long.$errfrom") if ($lenhn > $sow->{'cfg'}->{'MAXSIZE_HANDLENAME'});

	my $lenurl = length($query->{'url'});
	$debug->raise($sow->{'APLOG_CAUTION'}, "URL���������܂��i$lenurl�o�C�g�j�B�ő�$sow->{'cfg'}->{'MAXSIZE_URL'}�o�C�g�܂łł��B", "url too long.$errfrom") if ($lenurl > $sow->{'cfg'}->{'MAXSIZE_URL'});

	my $lenintro = length($query->{'intro'});
	$debug->raise($sow->{'APLOG_CAUTION'}, "���ȏЉ�������܂��i$lenintro�o�C�g�j�B�ő�$sow->{'cfg'}->{'MAXSIZE_INTRO'}�o�C�g�܂łł��B", "introduction too long.$errfrom") if ($lenintro > $sow->{'cfg'}->{'MAXSIZE_INTRO'});

	# ���[�U�[���̍X�V
	my $user = SWUser->new($sow);
	$user->{'uid'} = $sow->{'uid'};
	$user->openuser(1);
	$user->{'handlename'} = $query->{'handlename'};
	$user->{'url'} = $query->{'url'};
	$user->{'url'} = '' if ($query->{'url'} eq 'http://');
	$user->{'introduction'} = $query->{'intro'};
	$user->writeuser();
	$user->closeuser();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Edit Profile. [uid=$sow->{'uid'}]");

	return;
}

1;