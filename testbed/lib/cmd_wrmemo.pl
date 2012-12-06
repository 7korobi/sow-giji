package SWCmdWriteMemo;

#----------------------------------------
# メモ書き込み
#----------------------------------------
sub CmdWriteMemo {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	my ($vil, $checknosay) = &SetDataCmdWriteMemo($sow);

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_memo.pl";
		$sow->{'query'}->{'cmd'} = 'memo';
		$sow->{'query'}->{'cmdfrom'} = 'wrmemo';
		&SWCmdMemo::CmdMemo($sow);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'}  = '';
		$reqvals->{'turn'} = '';
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = "$link";
		$sow->{'http'}->outheader(); # HTTPヘッダの出力
		$sow->{'http'}->outfooter();
	}
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdWriteMemo {
	my $sow = $_[0];
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# 村データの読み込み
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 村ログ関連基本入力値チェック
	require "$cfg->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	my $curpl = &SWBase::GetCurrentPl($sow, $vil);
	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);
#	my $enable = 0;
#	$enable = $vil->ispublic($writepl);
#	$enable = 0 if ($vil->iseclipse($sow->{'turn'})); # 日蝕
#	$debug->raise($sow->{'APLOG_NOTICE'}, "メモを使えません。", "you can not use memo.$errfrom") if ($enable == 0); # 通常起きない

	# 残りアクションがゼロの時
	my  $saypoint = 0;
	if      ( $cost eq 'none' ){
		$saypoint = 0;
	} elsif ( $cost eq 'count' ) {
		$saypoint = 1;
	} elsif ( $cost eq 'point' ) {
		$saypoint = &SWBase::GetSayPoint($sow, $vil, $mes);
	}
	if ( $saypoint > 0 ){
		# 発言数がない（仮）
		$debug->raise($sow->{'APLOG_NOTICE'}, "アクションが足りません。","not enough saypoint.[$pttype: $writepl->{$pttype} / $saypoint]") if ((!defined($writepl->{$pttype})) || (($writepl->{$pttype} - $saypoint) < 0));
	}

	require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
	# 行数・文字数の取得の取得
	my $mes = $query->{'mes'};
	my @lineslog = split('<br>', $mes);
	my $lineslogcount = @lineslog;
	my $countmes = &SWString::GetCountStr($sow, $vil, $mes);

	# 行数／文字数制限警告
	$debug->raise($sow->{'APLOG_NOTICE'}, "行数が多すぎます（$lineslogcount行）。$cfg->{'MAXSIZE_MEMOLINE'}行以内に収めないと書き込めません。", "too many mes lines.$errfrom") if ($lineslogcount > $cfg->{'MAXSIZE_MEMOLINE'});
	my $unitcaution = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COST_SAY'}}->{'UNIT_CAUTION'};
	$debug->raise($sow->{'APLOG_NOTICE'}, "文字が多すぎます（$countmes$unitcaution）。$cfg->{'MAXSIZE_MEMOCNT'}$unitcaution以内に収めないと書き込めません。", "too many mes.$errfrom") if ($countmes > $cfg->{'MAXSIZE_MEMOCNT'});
	my $lenmes = length($query->{'mes'});
	$debug->raise($sow->{'APLOG_NOTICE'}, "メモが短すぎます（$lenmes バイト）。$cfg->{'MINSIZE_MEMOCNT'} バイト以上必要です。", "memo too short.$errfrom") if (($lenmes < $cfg->{'MINSIZE_MEMOCNT'}) && ($lenmes != 0));

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
	my $checknosay = &SWString::CheckNoSay($sow, $query->{'mes'});

	my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 0);
	my $newmemo = $memofile->getnewmemo($writepl);
	$debug->raise($sow->{'APLOG_NOTICE'}, 'メモを貼っていません。', "memo not found.$errfrom") if (($checknosay == 0) && ($newmemo->{'log'} eq ''));

	# メモデータファイルへの書き込み
	my $monospace = 0 + $query->{'monospace'};

	if ($checknosay == 0) {
		$mes = '';
	}

	my %say = (
		uid     => $writepl->{'uid'},
		mes     => $mes,
		mestype => $mestype,
	);

    my $memoid = sprintf("%05d", $vil->{'cntmemo'});
	$mes = &SWLog::ReplaceAnchor($sow, $vil, \%say);
	my %memo = (
		logid     => $memoid,
		mestype   => $mestype,
		uid       => $writepl->{'uid'},
		cid       => $writepl->{'cid'},
		csid      => $writepl->{'csid'},
		chrname   => $chrname,
		date      => $sow->{'time'},
		log       => &SWLog::CvtRandomText($sow, $vil, $mes),
		monospace => $monospace,
	);
	$memofile->add(\%memo);
	$vil->{'cntmemo'}++;

	# ログデータファイルへの書き込み
	# $query->{'cmd'} = 'action';
	if ($checknosay > 0) {
		# メモを貼る
		$query->{'mes'} = 'メモを貼った。';
		&SWWrite::ExecuteCmdWrite($sow, $vil, $writepl, $memo{'logid'}, '<mw MM'.$memoid.','.$vil->{'turn'}.',メモ>');

		$debug->writeaplog($sow->{'APLOG_POSTED'}, "WriteMemo. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");
	} else {
		# メモをはがす
		$query->{'mes'} = 'メモをはがした。';
		&SWWrite::ExecuteCmdWrite($sow, $vil, $writepl, $memo{'logid'});

		$debug->writeaplog($sow->{'APLOG_POSTED'}, "DeleteMemo. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");
	}
	$vil->closevil();

	return ($vil, $checknosay);
}

1;
