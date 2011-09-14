package SWCmdWrite;

#----------------------------------------
# 発言
#----------------------------------------
sub CmdWrite {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	require "$cfg->{'DIR_LIB'}/write.pl";

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# 誤爆チェック
	if (&CheckWriteSafety($sow, $vil) == 0) {
		# 人狼の通常発言でチェックを付けていない時
		$vil->closevil();
		require "$cfg->{'DIR_LIB'}/cmd_writepr.pl";
		$query->{'cmd'} = 'writepr';
		&SWCmdWritePreview::CmdWritePreview($sow);
		return;
	}

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 入力値のチェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_write.pl";
	&SWValidityWrite::CheckValidityWrite($sow, $vil);

	# 発言書き込み
	my $checknosay = &SWString::CheckNoSay($sow, $sow->{'query'}->{'mes'});
	if ($checknosay > 0) {
		my $writepl = &SWBase::GetCurrentPl($sow, $vil);
		&SWWrite::ExecuteCmdWrite($sow, $vil, $writepl);
		$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "WriteSay. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");
	}
	$vil->closevil();

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		if ($checknosay > 0) {
			require "$cfg->{'DIR_LIB'}/file_log.pl";
			require "$cfg->{'DIR_LIB'}/log.pl";
			require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
			&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
		} else {
			require "$cfg->{'DIR_HTML'}/html.pl";
			require "$cfg->{'DIR_HTML'}/html_formpl_mb.pl";
			&SWHtmlPlayerFormMb::OutHTMLPlayerFormMb ($sow, $vil);
		}
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
# 誤爆チェック
#----------------------------------------
sub CheckWriteSafety {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	$curpl = $sow->{'curpl'};

	return 1 if (($query->{'admin'} ne '') && ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})); # 管理人発言なら問題ない
	return 1 if (($query->{'maker'} ne '') && ($sow->{'uid'} eq $vil->{'makeruid'})); # 村建て人発言なら問題ない

	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);
	return 1 if (&SWBase::CheckWriteSafetyRole($sow, $vil) == 0); # 秘密会話のできない役職なら問題ない
	return 1 if ($que == 0); # 通常発言ではないなら問題ない
	return 1 if ($vil->isepilogue() > 0); # エピなら問題ない
	return 1 if ($query->{'safety'} eq 'on'); # 確認のチェックが付いているなら問題ない

	return 0;
}

1;