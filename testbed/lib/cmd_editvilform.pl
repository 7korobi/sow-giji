package SWCmdEditVilForm;

#----------------------------------------
# 村編集表示
#----------------------------------------
sub CmdEditVilForm {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	if($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}){
		if($sow->{'uid'} eq $vil->{'makeruid'}){
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "村作成者にはこの村の編集は行えません。", "no permition.$errfrom") if (($vil->isscrap()));
		}else{
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "村作成者以外には村の編集は行えません。", "no permition.$errfrom") if (($vil->isepilogue() == 0));
		}
	}

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevilform.pl";

	# 村作成画面のHTML出力
	# 廃村からの復活機能のため、廃村時の編集はログ再作成。
	$vil->{'turn'} = 0 if ($vil->isscrap());
	&SWHtmlMakeVilForm::OutHTMLMakeVilForm($sow, $vil);
}

1;