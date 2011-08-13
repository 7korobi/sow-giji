package SWCmdLogout;

#----------------------------------------
# ログアウト
#----------------------------------------
sub CmdLogout {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# データ処理
	&SetDataCmdLogout($sow);

	# HTTP出力
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'uid'} = '';
	$reqvals->{'pwd'} = '';
	$query->{'cmdfrom'} = '' if ($query->{'cmdfrom'} eq 'entrypr');
	$query->{'cmdfrom'} = '' if ($query->{'cmdfrom'} eq 'writepr');
	$reqvals->{'cmd'} = $query->{'cmdfrom'} if ($query->{'cmdfrom'} ne '');
		
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = '?' . $link if ($link ne '');
	$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}$link";

	$sow->{'http'}->{'location'} = "$link";
	$sow->{'http'}->outheader();
	$sow->{'http'}->outfooter();
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdLogout {
	my $sow = $_[0];
	my $query  = $sow->{'query'};

	if ($sow->{'user'}->logined() > 0) {
		# ログインしていればログアウトする
		$sow->{'user'}->resetcookie($sow->{'setcookie'});
		$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Logout. [$sow->{'uid'}]");
	}

	return;
}

1;