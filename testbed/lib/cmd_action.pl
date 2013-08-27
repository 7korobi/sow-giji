package SWCmdAction;

#----------------------------------------
# アクション
#----------------------------------------
sub CmdAction {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	my ($vil, $checknosay) = &SetDataCmdAction($sow);

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		if ($checknosay > 0) {
			# 村ログ表示
			require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_vlog.pl";
			&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
		} else {
			# リロード扱い
			require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
			require "$sow->{'cfg'}->{'DIR_HTML'}/html_formpl_mb.pl";
			&SWHtmlPlayerFormMb::OutHTMLPlayerFormMb ($sow, $vil);
		}
	} else {
		$sow->{'http'}->outheader();
		$sow->{'http'}->outfooter();
	}
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdAction {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# アクション対象者と、その名前を取得
	my $mes    = '';
	my $target = '';
	my $action = '';
	my $targetpl;
	if (defined($query->{'target'}) && ($query->{'target'} >= 0)) {
		if ((!defined($query->{'actionno'})) || ($query->{'actionno'} != -2)) {
			$targetpl = $vil->getplbypno($query->{'target'});
			$debug->raise($sow->{'APLOG_CAUTION'}, "対象番号が不正です。","invalid target.") if (!defined($targetpl->{'pno'}));
			$debug->raise($sow->{'APLOG_CAUTION'}, "対象に自分は選べません。","target is you.") if ($sow->{'curpl'}->{'pno'} == $targetpl->{'pno'});
			$debug->raise($sow->{'APLOG_CAUTION'}, "アクション対象の人は死んでいます。","target is dead.") if (($sow->{'curpl'}->{'live'} eq 'live')&&($targetpl->{'live'} ne 'live')&&($vil->isepilogue() == 0));
			$target = $targetpl->getchrname();
		}
	}

	# 村ログ関連基本入力値チェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	my $actions = $sow->{'textrs'}->{'ACTIONS'};
	if ( $query->{'actionno'} == -99 ) {
		$action = "";
	} else {
		# 定型アクション
		if ($query->{'actionno'} != -2) {
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "アクションの対象が未選択です。", "no target.$errfrom") if (!defined($targetpl->{'pno'}));
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "アクション番号が不正です。", "invalid action no.$errfrom") if (!defined($actions->[$query->{'actionno'}]));
		}

		if ($query->{'actionno'} == -1) {
			# 話の続きを促す
			$debug->raise($sow->{'APLOG_CAUTION'}, "促しはもう使い切っています。","not enough actaddpt.") if ($sow->{'curpl'}->{'actaddpt'} <= 0);
			my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
			$actions_addpt =~ s/_REST_//g;
			$action = $actions_addpt;
			$targetpl->addsaycount();
			$sow->{'curpl'}->{'actaddpt'}--;
		} elsif ($query->{'actionno'} == -2) {
			# しおり
			$action = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		} elsif ($query->{'actionno'} == -3) {
			# zap
			my $actions_zap = $sow->{'textrs'}->{'ACTIONS_ZAP'};
			$actions_zap =~ s/_COUNT_//g;
			$action = $actions_zap;
			$targetpl->zap();
			$sow->{'curpl'}->{'zapcount'}++;
		} elsif ($query->{'actionno'} == -4) {
			# 昇進
			$action = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_UP'};
			if( $targetpl->{'clearance'} < 8 ){
				$targetpl->{'clearance'}++ ;
			}else{
				$action .= $sow->{'textrs'}->{'ACTIONS_CLEARANCE_NG'};
			}
		} elsif ($query->{'actionno'} == -5) {
			# 降格
			$action = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_DOWN'};
			if( 0 < $targetpl->{'clearance'} ){
				$targetpl->{'clearance'}-- ;
			}else{
				$action .= $sow->{'textrs'}->{'ACTIONS_CLEARANCE_NG'};
			}
		} else {
			# 話の続きを促す以外の定型アクション
			$action = $actions->[$query->{'actionno'}];
		}
	}
	require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
	my $checkfreetext = &SWString::CheckNoSay($sow, $query->{'actiontext'});
	if ($checkfreetext > 0 ) {
		# 自由入力アクション
		require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";
		&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'actiontext'}, 'ACTION', 'actiontext', 'アクションの内容', 1);
		$action = $query->{'actiontext'};
	}
	$mes = $target . $action;


	require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
	my $checknosay = &SWString::CheckNoSay($sow, $mes);
	if ($checknosay > 0) {
		# アクションの書き込み
		$query->{'mes'} = $mes;
		my $writepl = &SWBase::GetCurrentPl($sow, $vil);
		&SWWrite::ExecuteCmdWrite($sow, $vil, $writepl);

		$debug->writeaplog($sow->{'APLOG_POSTED'}, "WriteAction. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");
	}
	$vil->closevil();

	return ($vil, $checknosay);
}

1;