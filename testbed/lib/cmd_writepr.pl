package SWCmdWritePreview;

#----------------------------------------
# 発言プレビュー表示
#----------------------------------------
sub CmdWritePreview {
	my $sow = $_[0];

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $sow->{'query'}->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 入力値のチェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_write.pl";
	&SWValidityWrite::CheckValidityWrite($sow, $vil);

	# HTML出力
	require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
	if (&SWString::CheckNoSay($sow, $sow->{'query'}->{'mes'}) > 0) {
		# プレビュー表示
		&OutHTMLCmdWritePreview($sow, $vil);
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
sub OutHTMLCmdWritePreview {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};

	# HTML表示用ファイル読み込み
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	my $logid = &SWLog::CreateLogID($sow, $sow->{'MESTYPE_SAY'}, $sow->{'LOGSUBID_SAY'}, $sow->{'LOGCOUNT_UNDEF'});
	my $curpl = &SWBase::GetCurrentPl($sow, $vil);
	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);

	my $monospace = 0;
	$monospace = 1 if ($query->{'monospace'} eq 'monospace');
	$monospace = 2 if ($query->{'monospace'} eq 'report'); 

	my $expression = 0;
	$expression = $query->{'expression'} if (defined($query->{'expression'}));

	my %say = (
		uid     => $writepl->{'uid'},
		mes     => $query->{'mes'},
		mestype => $mestype,
	);
	&SWLog::ReplaceAnchor($sow, $vil, \%say); # とりあえず妥当性チェック代わり

	my $logsubid = $sow->{'LOGSUBID_SAY'};
	my %log = (
		logid      => $logid,
		mestype    => $mestype,
		logsubid   => $logsubid,
		log        => $query->{'mes'},
		date       => $sow->{'time'},
		uid        => $writepl->{'uid'},
		target     => $targetpl->{'uid'},
		csid       => $writepl->{'csid'},
		cid        => $writepl->{'cid'},
		chrname    => $chrname,
		que        => 0,
		expression => $expression,
		monospace  => $monospace,
	);
	my %preview = (
		cmd => 'write',
	);

	# HTML表示
	if ($sow->{'outmode'} eq 'mb') {
		$preview{'cmdfrom'} = 'wrformmb';
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_preview_mb.pl";
		&SWHtmlPreviewMb::OutHTMLPreviewMb($sow, $vil, \%log, \%preview);
	} else {
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_preview_pc.pl";
		require "$sow->{'cfg'}->{'DIR_HTML'}/html_vlog_pc.pl";
		&SWHtmlPreviewPC::OutHTMLPreviewPC($sow, $vil, \%log, \%preview);
	}
}

1;