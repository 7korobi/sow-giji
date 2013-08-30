package SWCmdVote;

#----------------------------------------
# 投票／能力対象設定
#----------------------------------------
sub CmdVote {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# データ処理
	my $vil = &SetDataCmdVote($sow);

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
sub SetDataCmdVote {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 投票／能力対象設定
	my $cmd   = $query->{'cmd'};
	my $curpl = $sow->{'curpl'};
	if('mb' eq $sow->{'ua'}){
		$cmd = 'entrust' if ($query->{'entrust'} = 'on');
	}

	# 村ログ関連基本入力値チェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	$target = $curpl->gettargetlistwithrandom($cmd);
	my $targetcount  = 0;
	my $target2count = 0;
	foreach ( @$target ){
		$targetcount++  if ($query->{'target'}  == $_->{'pno'});
		$target2count++ if ($query->{'target2'} == $_->{'pno'});
	}

	$debug->raise($sow->{'APLOG_CAUTION'}, "選択できない対象を選んでいます。", "cannot vote.") if (( $targetcount == 0));
	if ( $curpl->gettargetlabel($cmd,$vil->{'turn'}) ne '' ) {
		$debug->raise($sow->{'APLOG_CAUTION'}, "対象１と対象２が同じ人です。", "same both target.")  if (($query->{'target'} == $query->{'target2'}) && ($query->{'target'} >= 0));
		$debug->raise($sow->{'APLOG_CAUTION'}, "選択できない対象を選んでいます。", "cannot vote.")   if (($curpl->gettargetlistwithrandom($cmd) == 0));
		$debug->raise($sow->{'APLOG_CAUTION'}, "選択できない対象２を選んでいます。", "cannot vote.") if (( $target2count == 0));
	}

	$debug->raise($sow->{'APLOG_CAUTION'}, "今日は投票できる日ではありません。", "cannot vote.")              if (($cmd eq 'entrust') && ($curpl->isEnableVote($vil->{'turn'}) == 0));
	$debug->raise($sow->{'APLOG_CAUTION'}, "今日は投票できる日ではありません。", "cannot vote.")                 if (($cmd eq 'vote') && ($curpl->isEnableVote($vil->{'turn'}) == 0));
	$debug->raise($sow->{'APLOG_CAUTION'}, "今日は能\力対象を設定できる日ではありません。", "cannot set target.") if (($cmd eq 'role') && ($curpl->isEnableRole($vil->{'turn'}) == 0));
	$debug->raise($sow->{'APLOG_CAUTION'}, "今日は能\力対象を設定できる日ではありません。", "cannot set target.") if (($cmd eq 'gift') && ($curpl->isEnableGift($vil->{'turn'}) == 0));

	my $modified = 0;
		if ($curpl->{$cmd.'1'} != $query->{'target'}) {
			$curpl->{$cmd.'1'}  = $query->{'target'};
			$modified = 1;
		}
	if ( $curpl->gettargetlabel($cmd,$vil->{'turn'}) ne '' ) {
		if ($curpl->{$cmd.'2'} != $query->{'target2'}) {
			$curpl->{$cmd.'2'}  = $query->{'target2'};
			$modified = 1;
		}
	}
	$curpl->queryentrust($sow,$vil,$query) if (($query->{'cmd'} eq 'vote') or ($query->{'cmd'} eq 'entrust'));
	$curpl->{'modified'} = $sow->{'time'} if (($modified > 0) || ($saveentrust != $curpl->{'entrust'}));
	$vil->writevil();

	# 投票／能力対象変更操作を村ログへ書き込み
	if ((($vil->{'event'} == $sow->{'EVENTID_FORCE'})||($sow->{'cfg'}->{'ENABLED_PLLOG'} > 0))
	 && (($modified > 0) || ($saveentrust != $curpl->{'entrust'}))  ){
		require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

		# ログデータファイルを開く
		my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);

		# 書き込み文の生成
		my $textrs = $sow->{'textrs'};
		my $format = 'ANNOUNCE_SETTARGET';
		$format    = 'ANNOUNCE_SETVOTE'     if($cmd eq 'vote');
		$format    = 'ANNOUNCE_SETENTRUST'  if($cmd eq 'entrust');
		my $mes = $textrs->{$format};
		$mes =~ s/_ABILITY_/$textrs->{'ABI_ROLE'}->[$curpl->{'role'}]/g if ($cmd eq 'role');
		$mes =~ s/_ABILITY_/$textrs->{'ABI_GIFT'}->[$curpl->{'gift'}]/g if ($cmd eq 'gift');

		my $curplchrname = $curpl->getlongchrname();
		$mes =~ s/_NAME_/$curplchrname/g;

		my $targetpl = $vil->getplbypno($curpl->{$cmd.'1'});
		my $targetname;
		if ($curpl->{$cmd.'1'} >= 0) {
			$targetname = $targetpl->getlongchrname();
		} elsif ($curpl->{$cmd.'1'} == $sow->{'TARGETID_RANDOM'}) {
			$targetname = $textrs->{'RANDOMTARGET'};
		} else {
			$targetname = $textrs->{'UNDEFTARGET'};
		}
		if ( $curpl->gettargetlabel($cmd,$vil->{'turn'}) ne '' ) {
			if ($curpl->{$cmd.'2'} == $sow->{'TARGETID_RANDOM'}) {
				$targetname .= ' と ' . $textrs->{'RANDOMTARGET'};
			} else {
				my $target2pl = $vil->getplbypno($curpl->{$cmd.'2'});
				$targetname .= ' と ' . $target2pl->getlongchrname();
			}
		}
		$mes =~ s/_TARGET_/$targetname/g;

		# 書き込み
		if (($vil->{'event'} == $sow->{'EVENTID_FORCE'})&&($cmd eq 'vote')){
			$logfile->writeinfo($curpl->{'uid'}, $sow->{'MESTYPE_INFONOM'}, $mes);
		} else {
			$logfile->writeinfo($curpl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes) if ($curpl->issensible());
		}
		$logfile->close();
	}
	$vil->closevil();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Set Vote/Role/Gift. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, action=$cmd]");

	return $vil;
}

1;
