package SWCmdEntryPreview;

#----------------------------------------
# エントリー発言プレビュー表示
#----------------------------------------
sub CmdEntryPreview {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# 文字列リソースの読み込み
	&SWBase::LoadTextRS($sow, $vil);

	require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
	$debug->raise($sow->{'APLOG_NOTICE'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	my $lenmes = length($query->{'mes'});
	$debug->raise($sow->{'APLOG_NOTICE'}, "参加する時のセリフが短すぎます（$lenmes バイト）。$sow->{'cfg'}->{'MINSIZE_MES'} バイト以上必要です。", "mes too short.$errfrom") if (($lenmes < $sow->{'cfg'}->{'MINSIZE_MES'}) && ($lenmes != 0));
	$debug->raise($sow->{'APLOG_NOTICE'}, "参加する時のセリフがありません。", "no entry message.$errfrom") if (&SWString::CheckNoSay($sow, $sow->{'query'}->{'mes'}) == 0);
	$debug->raise($sow->{'APLOG_NOTICE'}, '参加パスワードが違います。', "invalid entrypwd.$errfrom") if (($vil->{'entrylimit'} eq 'password') && ($query->{'entrypwd'} ne $vil->{'entrypwd'}));
	my $mobs = $vil->getrolepllist($sow->{'ROLEID_MOB'});
	$debug->raise($sow->{'APLOG_NOTICE'}, '見物人が一杯です。', "out of mob.$errfrom") if (($query->{'role'} == $sow->{'ROLEID_MOB'})&&($vil->{'cntmob'} <= @$mobs));

	# HTML出力
	require "$sow->{'cfg'}->{'DIR_LIB'}/string.pl";
	if (&SWString::CheckNoSay($sow, $sow->{'query'}->{'mes'}) > 0) {
		# プレビュー表示
		&OutHTMLCmdEntryPreview($sow, $vil);
	} else {
		# 村ログ表示
		my $cfg = $sow->{'cfg'};
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = "$link";
		$sow->{'http'}->outheader(); # HTTPヘッダの出力
		$sow->{'http'}->outfooter();
	}
	$vil->closevil();
}

#----------------------------------------
# HTML出力
#----------------------------------------
sub OutHTMLCmdEntryPreview {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};

	# プレビュー表示の準備
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";

	my $mestype = $sow->{'MESTYPE_SAY'};
	$mestype    = $sow->{'MESTYPE_VSAY'} if ($query->{'role'} == $sow->{'ROLEID_MOB'});
	my $logid = &SWLog::CreateLogID($sow, $mestype, $sow->{'LOGSUBID_SAY'}, $sow->{'LOGCOUNT_UNDEF'});

	# キャラクタセットの読み込み
	my ($csid, $cid) = split('/', $query->{'csid_cid'});
	$sow->{'charsets'}->loadchrrs($csid);

	my $monospace = 0 + $query->{'monospace'};

	my %log = (
		logid    => $logid,
		mestype  => $mestype,
		logsubid => $sow->{'LOGSUBID_SAY'},
		log      => $query->{'mes'},
		date     => $sow->{'time'},
		uid      => $sow->{'uid'},
		target   => $sow->{'uid'},
		csid     => $csid,
		cid      => $cid,
		chrname  => $sow->{'charsets'}->getchrname($csid, $cid),
		monospace => $monospace,
		que       => 0,
	);

	my $plsingle = SWPlayer->new($sow);
	$plsingle->createpl($log{'uid'});

	my %preview = (
		cmd => 'entry',
	);
	if ($sow->{'outmode'} eq 'mb') {
		$preview{'cmdfrom'} = 'enformmb';
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_preview_mb.pl";
		&SWHtmlPreviewMb::OutHTMLPreviewMb($sow, $vil, \%log, \%preview);
	} else {
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_preview_pc.pl";
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_vlog_pc.pl";
		&SWHtmlPreviewPC::OutHTMLPreviewPC($sow, $vil, \%log, \%preview);
	}
}

1;