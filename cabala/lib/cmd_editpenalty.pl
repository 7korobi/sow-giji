package SWCmdEditPenalty;

#----------------------------------------
# 
#----------------------------------------
sub CmdEditPenalty {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	&SetDataCmdEditPenalty($sow);

	# HTTP/HTML出力
	&OutHTMLCmdEditPenalty($sow);
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdEditPenalty {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "管理人権限が必要です。", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	return;

	return if ($query->{'cmd'} eq 'restviform');

	my $vidend = 1;
	opendir(DIR, "$sow->{'cfg'}->{'DIR_VIL'}");
	my @vfiles;
	foreach (readdir(DIR)) {
		next if ((length($_) != 4) && (index($_, "_$sow->{'cfg'}->{'FILE_VIL'}") < 0));
		my $n;
		if (length($_) == 4) {
			$n = int($_);
		} else {
			$n = int(substr($_, 0, 4));
		}
		push(@vfiles, $n);
	}
	closedir(DIR);

	return if (@vfiles == 0);

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_sowgrobal.pl";
	my $sowgrobal = SWFileSWGrobal->new($sow);
	$sowgrobal->openmw();
	$sowgrobal->{'vlastid'} = @vfiles;
	$sowgrobal->writemw();
	$sowgrobal->closemw();

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";

	# 村一覧の再構築実行
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex(1);

	my @vi = sort {$a <=> $b} @vfiles;
	foreach (@vi) {
		my $vil = SWFileVil->new($sow, $_);
		$vil->readvil();
		&SWBase::LoadVilRS($sow, $vil); # リソースの読み込み
		$vindex->addvindex($vil);
		$vil->closevil();
	}
	$vindex->writevindex();
	$vindex->closevindex();

	return;
}

#----------------------------------------
# HTML出力
#----------------------------------------
sub OutHTMLCmdEditPenalty {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML出力用ライブラリの読み込み
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_editpenalty.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('村一覧再構築'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlEditPenalty::OutHTMLEditPenalty($sow);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
}

1;