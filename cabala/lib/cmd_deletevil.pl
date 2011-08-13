package SWCmdDeleteVil;

#----------------------------------------
# 村データ削除処理
#----------------------------------------
sub CmdDeleteVil {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	&SetDataCmdDeleteVil($sow);

	# HTTP/HTML出力
	&OutHTMLCmdDeleteVil($sow);
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdDeleteVil {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "管理人権限が必要です。", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	$query->{'vidstart'} = -1 if (!defined($query->{'vidstart'}));
	$query->{'vidend'} = -1 if (!defined($query->{'vidend'}));

	return if ($query->{'vidstart'} <= 0);

	if ($query->{'vidend'} == 0) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_sowgrobal.pl";
		my $sowgrobal = SWFileSWGrobal->new($sow);
		$sowgrobal->openmw();
		$sowgrobal->closemw();
		$query->{'vidend'} = $sowgrobal->{'vlastid'};
	}

	$query->{'vidend'} = $query->{'vidstart'} if ($query->{'vidend'} <= 0);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "村番号が不正です。", "vidstart > vidend.[$query->{'vidstart'}, $query->{'vidend'}] $errfrom") if ($query->{'vidstart'} > $query->{'vidend'});

	# 村データ削除の実行
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

	my $i;
	for ($i = $query->{'vidstart'}; $i <= $query->{'vidend'}; $i++) {
		my $vil = SWFileVil->new($sow, $i);
		$vil->deletevil();
	}

	return;
}

#----------------------------------------
# HTML出力
#----------------------------------------
sub OutHTMLCmdDeleteVil {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML出力用ライブラリの読み込み
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_deletevil.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('村データ削除'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlDeleteVil::OutHTMLDeleteVil($sow);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
}

1;