package SWCmdMakeVil;

#----------------------------------------
# 村作成
#----------------------------------------
sub CmdMakeVil {
	my $sow = $_[0];

	# 村作成時値チェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_makevil.pl";
	&SWValidityMakeVil::CheckValidityMakeVil($sow);

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	my $vcnt = $vindex->getactivevcnt();
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "現在稼働中の村の数が上限に達しているので、村を作成できません。", "too many villages.") if ($vcnt >= $sow->{'cfg'}->{'MAX_VILLAGES'});
	$vindex->closevindex();

	# 村作成処理
	my $vil = &WriteDataCmdMakeVil($sow);

	# HTML出力
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevil.pl";
	&SWHtmlMakeVil::OutHTMLMakeVil($sow, $vil);
}

#----------------------------------------
# 村作成プレビュー
#----------------------------------------
sub CmdMakeVilPr {
	my $sow = $_[0];

	# 村作成時値チェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_makevil.pl";
	&SWValidityMakeVil::CheckValidityMakeVil($sow);

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	my $vcnt = $vindex->getactivevcnt();
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "現在稼働中の村の数が上限に達しているので、村を作成できません。", "too many villages.") if ($vcnt >= $sow->{'cfg'}->{'MAX_VILLAGES'});
	$vindex->closevindex();

	# 村作成処理
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, 0);
	$vil->createdummyvil();
	&SetDataCmdMakeVil($sow,$vil);

	$query->{'vid'} = 0;
	# HTML出力
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_vinfo_pc.pl";
	&SWHtmlVilInfo::OutHTMLVilInfo($sow, $vil);
}

#----------------------------------------
# 村作成処理
#----------------------------------------
sub WriteDataCmdMakeVil {
	my ($sow) = @_;
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_sowgrobal.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";

	# キャラセットの設定
	my $csids = $query->{'csid'};
	my $trsid = $sow->{'cfg'}->{'DEFAULT_TEXTRS'};
	$trsid = $query->{'trsid'} if (defined($query->{'trsid'}));
	my $oldvid = 0;
	my $sowgrobal = '';
	if( $query->{'vid'} > 0 ){
		# 強制復活。
		$oldvid = 1;
	}else{
		# 管理データから村番号を取得
		$sowgrobal = SWFileSWGrobal->new($sow);
		$sowgrobal->openmw();
		$sowgrobal->{'vlastid'}++;
	
		# 村データの作成
		$query->{'vid'} = $sowgrobal->{'vlastid'};
		$oldvid = 0;
	}

	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->createvil();

	&SetDataCmdMakeVil($sow,$vil);


	# キャラセットの読み込み
	my @csids = split('/', $csids);
	my $csid = $csids[0];
	foreach (@csids) {
		$sow->{'charsets'}->loadchrrs($_);
	}
	my $charset = $sow->{'charsets'}->{'csid'}->{$csid};
	&SWBase::LoadTextRS($sow, $vil);
	my $textrs = $sow->{'textrs'};

	# ダミーキャラデータ作成
	my $plsingle = SWPlayer->new($sow);
	$plsingle->createpl($sow->{'cfg'}->{'USERID_NPC'});
	$plsingle->{'cid'}      = $charset->{'NPCID'};
	$plsingle->{'csid'}     = $csid;
	$plsingle->{'role'}     = -1;
	$plsingle->{'selrole'}  = $sow->{'ROLEID_VILLAGER'};

	$vil->addpl($plsingle); # 村へ追加
	$plsingle->setsaycount(); # 発言数初期化

	# 管理データの書き込み
	if($oldvid == 0){
		$sowgrobal->writemw();
		$sowgrobal->closemw();
	}

	# ログデータ・メモデータファイルの作成
	my $logfile  = SWBoa->new($sow, $vil, $vil->{'turn'}, 1);
	my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 1);

	# プロローグアナウンス
	my $announce_first = $vil->getTextByID('ANNOUNCE_FIRST',0);
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $announce_first );

	# ダミーキャラ参加
	my %entry = (
		pl         => $plsingle,
		mes        => $charset->{'NPCSAY'}->[0],
		expression => 0,
		monospace  => 0,
		npc        => 1,
	);
	$logfile->entrychara(\%entry);
	$plsingle->{'saidcount'}++;
	$logfile->close();
	$vil->writevil(); # 村データの書き込み
	$vil->closevil();

	# 村一覧データの更新
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	if($oldvid == 0){
		$vindex->addvindex($vil);
	} else {
		$vindex->updatevindex($vil,$sow->{'VSTATUSID_PRO'});
	}
	$vindex->writevindex();
	$vindex->closevindex();

	# 人狼譜出力用ファイルの作成
	if ($sow->{'cfg'}->{'ENABLED_SCORE'} > 0) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
		my $score = SWScore->new($sow, $vil, 1);
		$score->close();
	}

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Make Vil. [uid=$sow->{'uid'}]");

	return $vil;
}

#----------------------------------------
# 村設定処理
#----------------------------------------
sub SetDataCmdMakeVil {
	my ($sow,$vil) = @_;
	my $query = $sow->{'query'};
	# キャラセットの設定
	my $csids = $query->{'csid'};
	my $trsid = $sow->{'cfg'}->{'DEFAULT_TEXTRS'};
	$trsid = $query->{'trsid'} if (defined($query->{'trsid'}));

	$vil->{'vname'}        = $query->{'vname'};
	$vil->{'vcomment'}     = $query->{'vcomment'};
	$vil->{'vcomment'}     = $sow->{'basictrs'}->{'NONE_TEXT'} if ($vil->{'vcomment'} eq '');
	$vil->{'makeruid'}     = $sow->{'uid'};
	$vil->{'trsid'}        = $trsid;
	$vil->{'csid'}         = $csids;
	$vil->{'roletable'}    = $query->{'roletable'};
	$vil->{'updhour'}      = $query->{'hour'};
	$vil->{'updminite'}    = $query->{'minite'};
	$vil->{'updinterval'}  = $query->{'updinterval'};
	$vil->{'vplcnt'}       = $query->{'vplcnt'};
	$vil->{'entrylimit'}   = $query->{'entrylimit'};
	$vil->{'entrypwd'}     = $query->{'entrypwd'};
	$vil->{'rating'}       = $query->{'rating'};

	$vil->{'vplcntstart'}  = $query->{'vplcntstart'};
	$vil->{'vplcntstart'}  = 0 if (!defined($vil->{'vplcntstart'}));
	$vil->{'saycnttype'}   = $query->{'saycnttype'};
	$vil->{'nextupdatedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
	$vil->{'nextchargedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
	$vil->{'scraplimitdt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, $sow->{'cfg'}->{'TIMEOUT_SCRAP'}, 1);

	$vil->{'votetype'}     = $query->{'votetype'};
	$vil->{'starttype' }   = $query->{'starttype'};
	$vil->{'randomtarget'} = 0;
	$vil->{'randomtarget'} = 1 if (($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) && ($query->{'randomtarget'} ne ''));
	$vil->{'showid'}       = 0;
	$vil->{'showid'}       = 1 if ($query->{'showid'} ne '');
	$vil->{'undead'}       = 0;
	$vil->{'undead'}       = 1 if ($query->{'undead'} ne '');
	$vil->{'noselrole'}    = 0;
	$vil->{'noselrole'}    = 1 if ($query->{'noselrole'} ne '');
	$vil->{'mob'}          = $query->{'mob'};
	$vil->{'game'}         = $query->{'game'};

	my $cntmob = 0;
	$cntmob = $query->{"cntmob"} if (defined($query->{"cntmob"}));
	$vil->{"cntmob"} = int($cntmob);

	my $roleid = $sow->{'ROLEID'};
	for ($i = 1; $i < @$roleid; $i++) {
		my $countrole = 0;
		$countrole = $query->{"cnt$roleid->[$i]"} if (defined($query->{"cnt$roleid->[$i]"}));
		$vil->{"cnt$roleid->[$i]"} = int($countrole);
	}

	my $giftid = $sow->{'GIFTID'};
	for ($i = 1; $i < @$giftid; $i++) {
		my $countgift = 0;
		$countgift = $query->{"cnt$giftid->[$i]"} if (defined($query->{"cnt$giftid->[$i]"}));
		$vil->{"cnt$giftid->[$i]"} = int($countgift);
	}

	my $eventid = $sow->{'EVENTID'};
	for ($i = 1; $i < @$eventid; $i++) {
		my $countevent = 0;
		$countevent = $query->{"cnt$eventid->[$i]"} if (defined($query->{"cnt$eventid->[$i]"}));
		$vil->{"cnt$eventid->[$i]"} = int($countevent);
	}
}


1;