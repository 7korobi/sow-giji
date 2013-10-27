package SWCmdEditProfile;

#----------------------------------------
# ユーザー情報編集完了表示
#----------------------------------------
sub CmdEditProfile {
	my $sow = $_[0];

	# 村編集処理
	&SetDataCmdEditProfile($sow);

	# HTML出力
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_editprof.pl";
	&SWHtmlEditProfile::OutHTMLEditProfile($sow);
}

#----------------------------------------
# ユーザー情報編集処理
#----------------------------------------
sub SetDataCmdEditProfile {
	my $sow  = shift;
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$debug->raise($sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0); # 通常起きない

	my $lenhn = length($query->{'handlename'});
	$debug->raise($sow->{'APLOG_CAUTION'}, "ハンドル名が長すぎます（$lenhnバイト）。最大$sow->{'cfg'}->{'MAXSIZE_HANDLENAME'}バイトまでです。", "handle name too long.$errfrom") if ($lenhn > $sow->{'cfg'}->{'MAXSIZE_HANDLENAME'});

	my $lenurl = length($query->{'url'});
	$debug->raise($sow->{'APLOG_CAUTION'}, "URLが長すぎます（$lenurlバイト）。最大$sow->{'cfg'}->{'MAXSIZE_URL'}バイトまでです。", "url too long.$errfrom") if ($lenurl > $sow->{'cfg'}->{'MAXSIZE_URL'});

	my $lenintro = length($query->{'intro'});
	$debug->raise($sow->{'APLOG_CAUTION'}, "自己紹介が長すぎます（$lenintroバイト）。最大$sow->{'cfg'}->{'MAXSIZE_INTRO'}バイトまでです。", "introduction too long.$errfrom") if ($lenintro > $sow->{'cfg'}->{'MAXSIZE_INTRO'});

	# ユーザー情報の更新
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