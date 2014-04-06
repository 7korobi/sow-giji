package SWCmdLogin;

#----------------------------------------
# ログイン
#----------------------------------------
sub CmdLogin {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# データ処理
	&SetDataCmdLogin($sow);

	# HTTP出力
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
# データ処理
#----------------------------------------
sub SetDataCmdLogin {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $user = $sow->{'user'};

	my $matchpw = $user->login();
	if ($matchpw > 0) {
		# パスワード照合成功
		$user->setcookie($sow->{'setcookie'});
	} elsif (($matchpw < 0) && ($query->{'pwd'} ne '')) {
		# ユーザーデータ新規作成
		$user->createuser($query->{'uid'}, $query->{'pwd'});
		$user->setcookie($sow->{'setcookie'});
	}
	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Login. [$query->{'uid'}]");

	return;
}

1;