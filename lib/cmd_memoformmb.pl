package SWCmdWriteMemoFormMb;

#----------------------------------------
# モバイル用メモ書き込み画面表示
#----------------------------------------
sub CmbWriteMemoFormMb {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_memoform_mb.pl";

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $sow->{'query'}->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 入力値チェック
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
	my $debug = $sow->{'debug'};
	$debug->raise($sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0); # 通常起きない
	$debug->raise($sow->{'APLOG_CAUTION'}, "あなたはこの村に参加していません。", "no entry.$errfrom") if (($vil->checkentried() < 0) && ($query->{'maker'} eq '') && ($query->{'admin'} eq '')); # 通常起きない
	$debug->raise($sow->{'APLOG_NOTICE'}, "この村は終了しました。", "It's ended.$errfrom") if ($vil->{'turn'} > $vil->{'epilogue'}); # 通常起きない
	my $writepl = &SWBase::GetCurrentPl($sow, $vil);
#	my $enable = 0;
#	$enable = $vil->ispublic($writepl);
#	$debug->raise($sow->{'APLOG_NOTICE'}, "あなたは死んでいます。", "you dead.$errfrom") if ($enable == 0); # 通常起きない

	&SWHtmlMemoFormMb::OutHTMLMemoFormMb ($sow, $vil);

	$vil->closevil();

}

1;