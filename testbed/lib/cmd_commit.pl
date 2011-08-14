package SWCmdCommit;

#----------------------------------------
# コミット設定
#----------------------------------------
sub CmdCommit {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# データ処理
	my $vil = &SetDataCmdCommit($sow);

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_wrformmb.pl";
		&SWCmdWriteFormMb::CmbWriteFormMb($sow);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
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
sub SetDataCmdCommit {
	my $sow = $_[0];
	my $query  = $sow->{'query'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 村ログ関連基本入力値チェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	my $curpl = $sow->{'curpl'};
	# 参加チェック
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "今日は時間を進める事はできません。", "cannot commit.") if (($vil->{'turn'} == 0) || ($vil->isepilogue() > 0)); # 通常起きない
	if ( $vil->{'event'} != $sow->{'EVENTID_NIGHTMARE'} ) {
		$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "あなたは未発言です。最低一発言しないと時間を進める事はできません。", "no say.") if ($curpl->{'saidcount'} <= 0);
	}

	# コミット処理
	my $savecommit = $curpl->{'commit'};
	$curpl->{'commit'} = 0;
	$curpl->{'commit'} = 1 if ($query->{'commit'} > 0);
	if ($curpl->{'commit'} > 0) {
		$vil->{'nextcommitdt'} = $sow->{'dt'}->getcommitdt($sow->{'time'});
	}
	$curpl->{'modified'} = $sow->{'time'} if ($curpl->{'commit'} != $savecommit);
	$vil->writevil();

	# 投票／能力対象変更操作を村ログへ書き込み
	if (($sow->{'cfg'}->{'ENABLED_PLLOG'} > 0) && ($curpl->{'commit'} != $savecommit)) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

		# ログデータファイルを開く
		my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);

		# 書き込み文の生成
		my $textrs = $sow->{'textrs'};
		my $mes = $textrs->{'ANNOUNCE_COMMIT'}->[$curpl->{'commit'}];
		my $curplchrname = $curpl->getlongchrname();
		$mes =~ s/_NAME_/$curplchrname/g;

		# 書き込み
		$logfile->writeinfo($curpl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes);
		$logfile->close();
	}
	$vil->closevil();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Committed. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, action=$query->{'commit'}]");

	return $vil;
}

1;