package SWCmdLogin;

#----------------------------------------
# ���O�C��
#----------------------------------------
sub CmdLogin {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# �f�[�^����
	&SetDataCmdLogin($sow);

	# HTTP�o��
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'uid'} = '';
	$reqvals->{'pwd'} = '';
	$reqvals->{'cmd'} = $query->{'cmdfrom'} if ($query->{'cmdfrom'} ne '');
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = '?' . $link if ($link ne '');
	$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}$link";
	$link .= '#newsay' if (defined($query->{'vid'}));

	$sow->{'http'}->{'location'} = "$link";
	$sow->{'http'}->outheader();
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