package SWCmdLogin;

#----------------------------------------
# ���O�C��
#----------------------------------------
sub CmdLogin {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# ���C�u�����̓ǂݍ���
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_pc.pl";

	# �f�[�^����
	&SetDataCmdLogin($sow);
	$sow->{'uid'} = $query->{'uid'};

	# HTML���[�h�̏�����
	$sow->{'html'} = SWHtml->new($sow, "javascript");
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# HTTP�w�b�_�EHTML�w�b�_�̏o��
	my $outhttp = $sow->{'http'}->outheader();
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('js');

	&SWHtmlPC::OutHTMLGonInit($sow);
	print "\n</script>\n";

	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
	return;
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdLogin {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $user = $sow->{'user'};

	my $matchpw = $user->login();
	if ($matchpw > 0) {
		# �p�X���[�h�ƍ�����
		$user->setcookie($sow->{'setcookie'});
	} elsif (($matchpw < 0) && ($query->{'pwd'} ne '')) {
		# ���[�U�[�f�[�^�V�K�쐬
		$user->createuser($query->{'uid'}, $query->{'pwd'});
		$user->setcookie($sow->{'setcookie'});
	}
	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Login. [$query->{'uid'}]");

	return;
}

1;
