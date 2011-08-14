package SWCmdMoveVil;

#----------------------------------------
# 村データ移動処理
#----------------------------------------
sub CmdMoveVil {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	&SetDataCmdMoveVil($sow);

	# HTTP/HTML出力
	&OutHTMLCmdMoveVil($sow);
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdMoveVil {
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

	# 村データ移動の実行
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, 0);

	my $i;
	for ($i = $query->{'vidstart'}; $i <= $query->{'vidend'}; $i++) {
		my $dirname = &SWFileVil::GetFNameDirVid($sow, $i);
		if ($query->{'vidmove'} ne 'dir2file') {
			umask(0);
			mkdir($dirname, $sow->{'cfg'}->{'PERMITION_MKDIR'});
			open(DUMMY, ">$dirname/index.html");
			close(DUMMY);

			my @files;
			opendir(DIR, $sow->{'cfg'}->{'DIR_VIL'});
			foreach (readdir(DIR)) {
				next if (index($_, sprintf("%04d_", $i)) < 0);
				push(@files, $_);
			}
			closedir(DIR);

			foreach(@files) {
				rename("$sow->{'cfg'}->{'DIR_VIL'}/$_", "$dirname/$_");
			}
		} else {
			my @files;
			opendir(DIR, $dirname);
			foreach (readdir(DIR)) {
				next if (($_ eq '.') || ($_ eq '..'));
				push(@files, $_);
			}
			closedir(DIR);

			foreach(@files) {
				rename("$dirname/$_", "$sow->{'cfg'}->{'DIR_VIL'}/$_");
			}
			unlink("$dirname/index.html");
			rmdir($dirname);
		}
	}

	return;
}

#----------------------------------------
# HTML出力
#----------------------------------------
sub OutHTMLCmdMoveVil {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML出力用ライブラリの読み込み
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_movevil.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('村データ移動'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlMoveVil::OutHTMLMoveVil($sow);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
}

1;