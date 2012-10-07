package SWBoa;

#----------------------------------------
# SWBBS Log Driver Library 'SW-Boa'
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $turn, $mode) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log_data.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log_idx.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log_cnt.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log_que.pl";

	my $self = {
		sow    => $sow,
		vil      => $vil,
		turn     => $turn,
		version  => ' 2.1',
		startpos => 0,
	};
	bless($self, $class);

	if ($turn < 0) {
		$self->{'dummy'} = 1;
		return $self ;
	}
	# ログファイルの新規作成／開く
	$self->{'logfile'} = SWBoaLog->new($sow, $vil, $turn, $mode);

	if ($sow->{'query'}->{'cmd'} eq 'restruct') {
		# インデックスファイルの再構築
		$self->{'logindex'} = SWBoaLogIndex->new($sow, $vil, $turn, 1);
		$self->restructure();
		$self->{'logindex'}->{'file'}->close();
#		$self->{'logindex'}->{'file_last'}->close();

#		$self->{'logcnt'} = SWBoaLogCount->new($sow, $vil, $turn, 1);
	}

	# ログインデックスファイルの新規作成／開く
	$self->{'logindex'} = SWBoaLogIndex->new($sow, $vil, $turn, $mode);
	# ログカウントファイルの新規作成／開く
	$self->{'logcnt'} = SWBoaLogCount->new($sow, $vil, $turn, $mode);
	# キューファイルの新規作成／開く
	$self->{'que'} = SWBoaQue->new($sow, $vil, $turn, $mode);

	return $self;
}

#----------------------------------------
# ファイルを閉じる
#----------------------------------------
sub close {
	my $self = shift;

	return if ($self->{'dummy'} ==  1);
	$self->{'logfile'}->{'file'}->close();
	$self->{'logindex'}->{'file'}->close();
#	$self->{'logindex'}->{'file_last'}->close();
	$self->{'logcnt'}->{'file'}->close();
	$self->{'que'}->{'file'}->close();
}

#----------------------------------------
# ログデータの読み込み
#----------------------------------------
sub read {
	my ($self, $pos, $logpermit) = @_;
	return if ($self->{'dummy'} ==  1);

	my $data = $self->{'logfile'}->{'file'}->read($pos);
	if( 7 <  $logpermit  ){
		my $sow = $self->{'sow'};
		$data->{'mestype'} = $sow->{'MESTYPE_INFOSP'};
		$data->{'chrname'} = '？';
		$data->{'cid'} = '';
	}
	if( 9 == $logpermit  ){
# のぞきみ系内容マスク
		my $log = '';
		my $exp = '';
		my $exp_sw = 0;
		while( $data->{'log'} =~ /(\x82[\x9F-\xF1])+|(<br>)|(\[.*?\])|(.)/g ) {
			if ( defined($4)|| defined($3) ){
				if ($exp_sw){
					$exp_sw = 0 ;
					$exp = '…' ;
				} else {
					$exp = '' ;
				}
			} else {
				$exp = $& ;
				$exp_sw = 1;
			}
			$log .= $exp;
		}
		$data->{'log'} = $log;
	}

	return $data;
}

#----------------------------------------
# ログデータの追加
#----------------------------------------
sub add {
	my ($self, $log) = @_;
	return if ($self->{'dummy'} ==  1);

	$self->setip($log);
	$self->{'logfile'}->{'file'}->add($log);
	$self->addlogidx($log);
}

#----------------------------------------
# ログデータの更新
#----------------------------------------
sub update {
	my ($self, $log, $indexno) = @_;
	return if ($self->{'dummy'} ==  1);

	$self->{'logfile'}->{'file'}->update($log);
	my $logidx = $self->{'logindex'}->set($log);
	$self->{'logindex'}->{'file'}->update($logidx, $indexno);
#	$self->{'logindex'}->{'file_last'}->update($logidx, $indexno);
}

#----------------------------------------
# インデックスデータの再構築
#----------------------------------------
sub restructure {
	my $self = shift;
	return if ($self->{'dummy'} ==  1);

	my $logfile = $self->{'logfile'}->{'file'};
	$self->{'logindex'}->{'file'}->clear();

	my $pos = $logfile->{'startpos'};
	my $log = $logfile->read($pos);
	while (defined($log->{'uid'})) {
		$self->addlogidx($log, 1);
		$pos = $log->{'nextpos'};
		$log = $logfile->read($pos);
	}
	$self->{'logindex'}->{'file'}->write();
}

#----------------------------------------
# インデックスデータの追加
#----------------------------------------
sub addlogidx {
	my ($self, $log, $nowrite) = @_;
	return if ($self->{'dummy'} ==  1);

	my $logidx = $self->{'logindex'}->set($log);
	$self->{'logindex'}->{'file'}->add($logidx, $nowrite);
	return;
}

#----------------------------------------
# IPアドレスのセット
#----------------------------------------
sub setip {
	my ($self, $data) = @_;
	return if ($self->{'dummy'} ==  1);

	my $sow = $self->{'sow'};

	$data->{'remoteaddr'}  = '';
	$data->{'fowardedfor'} = '';
	$data->{'agent'}       = '';

	$data->{'remoteaddr'}  = $ENV{'REMOTE_ADDR'} if (defined($ENV{'REMOTE_ADDR'}));
	$data->{'fowardedfor'} = $ENV{'HTTP_X_FORWARDED_FOR'} if (defined($ENV{'HTTP_X_FORWARDED_FOR'}));
	$data->{'agent'}       = $ENV{'HTTP_USER_AGENT'} if (defined($ENV{'HTTP_USER_AGENT'}));

	$data->{'remoteaddr'}  = $sow->{'DATATEXT_NONE'} if ($data->{'remoteaddr'} eq '');
	$data->{'fowardedfor'} = $sow->{'DATATEXT_NONE'} if ($data->{'fowardedfor'} eq '');
	$data->{'agent'}       = $sow->{'DATATEXT_NONE'} if ($data->{'agent'} eq '');

	return;
}

#----------------------------------------
# 発言
#----------------------------------------
sub executesay {
	my ($self, $say) = @_;
	return if ($self->{'dummy'} ==  1);

	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $logcnt = $self->{'logcnt'}->{'file'};
	my $saypl = $self->{'vil'}->getpl($say->{'uid'});

	# 隠しメッセージ／独り言用ログID生成
	my $maskedid = '';
	my $cntmaskedid = '';
	if ((($say->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) || ($say->{'mestype'} == $sow->{'MESTYPE_TSAY'})) && ($self->{'vil'}->isepilogue() == 0)) {
		$cntmaskedid = "$sow->{'LOGMESTYPE'}->[$say->{'mestype'}]$sow->{'LOGSUBID_SAY'}";
		$maskedid = &SWLog::CreateLogID($sow, $say->{'mestype'}, $say->{'logsubid'}, $saypl->{$cntmaskedid});
	}

	my $mestype = $say->{'mestype'};
	$mestype = $sow->{'MESTYPE_QUEUE'} if ($say->{'que'} > 0);
	$mestype = $sow->{'MESTYPE_UNDEF'} if ($say->{'undef'} > 0);

	# ログIDカウンタのデータラベルを生成
	my $logcntid = "$sow->{'LOGMESTYPE'}->[$mestype]$say->{'logsubid'}";
	if (!defined($logcnt->{$logcntid})) {
		# カウンタ用データがないなら未定義として扱う
		if ($say->{'mestype'} != $sow->{'MESTYPE_CAST'}) {
			$say->{'mestype'}  = $sow->{'MESTYPE_UNDEF'};
			$say->{'logsubid'} = $sow->{'LOGSUBID_UNDEF'};
		}
		$logcntid = "$sow->{'LOGMESTYPE'}->[$say->{'mestype'}]$say->{'logsubid'}";
	}

	# ログID生成

	my $logid = &SWLog::CreateLogID($sow, $mestype, $say->{'logsubid'}, $logcnt->{$logcntid});
	$maskedid = $logid if ($maskedid eq '');

	# 名前の取得
	my $chrname = $sow->{'CHRNAME_INFO'};
	$chrname = $say->{'chrname'} if ($say->{'chrname'} ne '');

	# ログへの書き込み
	my $mes = &SWLog::ReplaceAnchor($sow, $self->{'vil'}, $say);
	my $memoid = $sow->{'DATATEXT_NONE'};
	$memoid = $say->{'memoid'} if (defined($say->{'memoid'}));
	my %log = (
		logid      => $logid,
		mestype    => $say->{'mestype'},
		logsubid   => $say->{'logsubid'},
		maskedid   => $maskedid,
		chrname    => $chrname,
		uid        => $say->{'uid'},
		target     => $say->{'target'},
		cid        => $say->{'cid'},
		csid       => $say->{'csid'},
		expression => $say->{'expression'},
		date       => $sow->{'time'},
		log        => $mes,
		memoid     => $memoid,
		monospace  => $say->{'monospace'},
	);
	$self->add(\%log);

	# ログの更新情報の更新
	my $label = $sow->{'MODIFIED_MESTYPE'}->[$say->{'mestype'}];
	$vil->{$label} = $sow->{'time'} if ($label ne '');

	my $pno = $vil->checkentried();
	if ($pno >= 0) {
		my $pl = $vil->getplbypno($pno);
		$pl->{'modified'} = $sow->{'time'};
	}

	if ($say->{'que'} == 1) {
		# 発言キューに積む
		my %que = (
			queid   => $logid,
			pos     => $log{'pos'},
			fixtime => $sow->{'time'} + $sow->{'cfg'}->{'MESFIXTIME'},
		);
		$self->{'que'}->{'file'}->add(\%que);
	}
	$logcnt->{$logcntid}++;
	$saypl->{$cntmaskedid}++ if ($cntmaskedid ne '');
	$logcnt->write();
	$vil->writevil();

	return $log{'pos'};
}

#----------------------------------------
# キャラクタの参加
#----------------------------------------
sub entrychara {
	my ($self, $entry) = @_;
	return if ($self->{'dummy'} ==  1);

	my $sow = $self->{'sow'};

	my $epl = $entry->{'pl'};
	my $chrname = $epl->getlongchrname();
	my $textrs = $sow->{'textrs'};
	my %say;

	if (($entry->{'npc'} == 0) || ($textrs->{'NPCENTRYMES'} != 0)) {
		# エントリー表示
		my $pno = $epl->{'pno'} + 1;
		my $mes = $textrs->{'ENTRYMES'};
		$mes =~ s/_NO_/$pno/;
		$mes =~ s/_NAME_/$chrname/;

		%say = (
			mestype    => $sow->{'MESTYPE_INFONOM'},
			logsubid   => $sow->{'LOGSUBID_INFO'},
			uid        => $epl->{'uid'},
			target     => $epl->{'uid'},
			csid       => $epl->{'csid'},
			cid        => $epl->{'cid'},
			chrname    => $epl->getlongchrname(),
			expression => 0,
			mes        => $mes,
			undef      => 0,
			monospace  => 0,
			que        => 0,
		);
		$self->executesay(\%say);
	}

	# 役職希望
	if ($sow->{'cfg'}->{'ENABLED_PLLOG'} > 0) {
		my $selrolename = $textrs->{'ROLENAME'}->[$epl->{'selrole'}];
		$selrolename = $textrs->{'RANDOMROLE'} if ($epl->{'selrole'} < 0);
		$mes = $textrs->{'ANNOUNCE_SELROLE'};
		$mes =~ s/_NAME_/$chrname/;
		$mes =~ s/_SELROLE_/$selrolename/;
		%say = (
			mestype    => $sow->{'MESTYPE_INFOSP'},
			logsubid   => $sow->{'LOGSUBID_INFO'},
			uid        => $epl->{'uid'},
			target     => $epl->{'uid'},
			csid       => $epl->{'csid'},
			cid        => $epl->{'cid'},
			chrname    => $epl->getlongchrname(),
			expression => 0,
			mes        => $mes,
			undef      => 0,
			monospace  => 0,
			que        => 0,
		);
		$self->executesay(\%say);
	}


	my $que = 1;
	$que = 0 if ($entry->{'npc'} > 0); # NPCなら保留なし
	my $mestype = $sow->{'MESTYPE_SAY'}; # 審問は MESTYPE_SAY
	$mestype    = $sow->{'MESTYPE_VSAY'} if ($epl->{'role'} == $sow->{'ROLEID_MOB'});

	# エントリー発言
	%say = (
		mestype    => $mestype,
		logsubid   => $sow->{'LOGSUBID_SAY'},
		uid        => $epl->{'uid'},
		target     => $epl->{'uid'},
		csid       => $epl->{'csid'},
		cid        => $epl->{'cid'},
		chrname    => $epl->getlongchrname(),
		expression => $entry->{'expression'},
		mes        => $entry->{'mes'},
		undef      => 0,
		monospace  => $entry->{'monospace'},
		que        => $que,
	);
	$epl->{'lastwritepos'} = $self->executesay(\%say);
}

#----------------------------------------
# 発言キューの確定
#----------------------------------------
sub fixque {
	my ($self, $force) = @_;
	return if ($self->{'dummy'} ==  1);

	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $logfile = $self->{'logfile'}->{'file'};
	my $logcnt  = $self->{'logcnt'}->{'file'};
	my $quelist = $self->{'que'}->{'file'}->getlist();

	foreach (@$quelist) {
		next if (($sow->{'time'} < $_->{'fixtime'}) && ($force == 0)); # 撤回猶予期間中かつ強制確定でない時は確定させない
		my $log = $logfile->read($_->{'pos'});
		my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);
		if (($log->{'logid'} ne $_->{'queid'})) {
			# ログデータに該当するログがない。
			$sow->{'debug'}->writeaplog($sow->{'APLOG_NOTICE'}, "FixQue, [queid=$_->{'queid'}, logid=$log->{'logid'}]");
		} else {
			# 発言確定
			my $indexno  = $self->{'logindex'}->{'file'}->getbyid($log->{'logid'});
			my $logcntid = "$sow->{'LOGMESTYPE'}->[$log->{'mestype'}]$log->{'logsubid'}";
			$log->{'logid'} = &SWLog::CreateLogID($sow, $log->{'mestype'}, $log->{'logsubid'}, $logcnt->{$logcntid});
			$logcnt->{$logcntid}++;
			$self->update($log, $indexno);

			# キューから削除
			$_->{'delete'} = 1;

			# 表発言なら、発言回数を増やす。
			next if ( $log->{'mestype'} == $sow->{'MESTYPE_AIM'} );
			my $pl = $vil->getpl($log->{'uid'});
			$pl->{'modified'} = $sow->{'time'};
			$pl->{'saidcount'}++;
			$vil->{'modifiedsay'} = $sow->{'time'};

		}
	}
	$self->{'que'}->{'file'}->write();
	$logcnt->write();
	$vil->writevil();
}

#----------------------------------------
# 表示できるログの取得（インデックス配列）
#----------------------------------------
sub getlist {
	my $self = shift;

	my $list = $self->{'logindex'}->{'file'}->getlist();
	my @result;

	foreach (@$list) {
		push(@result, $_) if ($self->CheckLogPermition($_) > 0);
	}

	return \@result;
}

#----------------------------------------
# 表示するログの取得（インデックス配列）
#----------------------------------------
sub getvlogs {
	my ($self, $maxrow) = @_;

	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	my %rows = (
		rowover => 0,
		start   => 0,
		end     => 0,
	);

	# 検索モードのセット
	my $mode = '';
	my $skip = 0;
	if ($query->{'logid'} ne '') {
		if ($query->{'move'} eq 'next') {
			$mode = 'next';
		} elsif ($query->{'move'} eq 'prev') {
			# 「前」移動の場合、基準ログIDまでスキップ
			$mode = 'prev';
			$skip = 1;
		} else {
			# 直接指定の場合、基準ログIDまでスキップ
			$mode = 'logid';
			$skip = 1;
		}
	}

	# maskedid のチェック
	$masked = 0;
	if ($sow->{'query'}->{'logid'} ne '') {
		my ($logmestype, $logsubid, $logcnt) = &SWLog::GetLogIDArray($sow->{'query'});
		$masked = 1 if ((($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_INFOSP'}]) || ($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_TSAY'}])) && ($self->{'vil'}->isepilogue() == 0));
	}

	# 検索
	my ($logs, $rowover, $firstlog, $lastlog);
	my $foward = 0;
	$foward = 1 if ($sow->{'query'}->{'move'} eq 'first');
	$foward = 1 if ($maxrow < 0);
	$foward = 1 if ($sow->{'query'}->{'move'} eq 'page');
	$foward = 1 if (($mode eq 'logid') && (($sow->{'query'}->{'order'} eq 'a') || ($sow->{'query'}->{'order'} eq 'asc') || ($sow->{'outmode'} eq 'pc')));
	if ($foward > 0) {
		# 順方向探索
		($logs, $logkeys, $rowover, $firstlog) = $self->GetVLogsForward($mode, $skip, $maxrow, $masked);
		if ($firstlog >= 0) {
			$rows{'start'} = 1 if ((defined($logs->[0])) && ($logs->[0]->{'indexno'} == $firstlog));
			$rows{'end'}   = 1 if ($rowover == 0);
		}
	} else {
		# 逆方向探索
		($logs, $logkeys, $rowover, $lastlog) = $self->GetVLogsReverse($mode, $skip, $maxrow, $masked);
		if ($lastlog >= 0) {
			$rows{'start'} = 1 if ($rowover == 0);
			$rows{'end'}   = 1 if (($#$logs >= 0) && ($logs->[$#$logs]->{'indexno'} == $lastlog));
		}
	}
	$rows{'rowover'} = $rowover;

	return ($logs, $logkeys, \%rows);
}

#----------------------------------------
# ログの取得（順方向探索）
#----------------------------------------
sub GetVLogsForward {
	my ($self, $mode, $skip, $maxrow, $masked) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $query  = $sow->{'query'};
	my $cookie = $sow->{'cookie'};
	my $i;
	my @logs;
	my %logkeys;
	my $rowcount = 0;
	my $rowover = 0;
	my $firstlog = -1;
	my $list = $self->{'logindex'}->{'file'}->getlist();

	my $pagecount = 0;
	my $pagefirst = -1;
	my $pageno = -1;
	$pageno = $query->{'pageno'} if (defined($query->{'pageno'}));
	if (($query->{'move'} eq 'page') && ($pageno >= 0)) {
		$pagefirst = ($pageno - 1) * $maxrow;
		$skip = 1;
	}

	for ($i = 0; $i < @$list; $i++) {
		my $logidx = $list->[$i];

		# maskedid 対応
		my $logid = $logidx->{'logid'};
		if ($masked > 0) {
			$logid = $logidx->{'maskedid'};
			my $curpl = $vil->getpl($logidx->{'uid'});
			if (defined($curpl->{'uid'})) {
				if ((!defined($curpl->{'entrieddt'})) || ((defined($logidx->{'date'})) && ($curpl->{'entrieddt'} > $logidx->{'date'}))) {
					$logid = 'xxnnnnn';
				}
			}
		}

		next if ($self->CheckLogPermition($logidx) == 0);

		# 先頭の可視ログ番号
		$firstlog = $logidx->{'indexno'} if ($firstlog < 0);
		if (($rowcount >= $maxrow) && ($maxrow > 0)) {
			# 指定行数を超えたらループから抜ける
			$rowover = 1;
			last;
		}

		if (($mode eq 'logid') && ($sow->{'outmode'} ne 'mb') && ($query->{'move'} ne 'page') && ($skip == 0)) {
			$rowover = 1;
			last;
		}

		if (($mode eq 'logid') && ($logid eq $query->{'logid'})) {
			$skip = 0;
		}

		$skip = 0 if ($pagecount == $pagefirst);

		if ($skip == 0) {
			# ログインデックスを登録
			push(@logs, $logidx);
			$logkeys{$logid} = $logidx->{'indexno'};
			$rowcount++ if (($logidx->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0)); # アクションは行数に数えない
		}

		if (($rowcount > $maxrow) && ($maxrow > 0)) {
			# 行数がオーバーした場合は削る
			my $dellog;
			do {
				$dellog = shift(@logs);
				$logkeys{$dellog->{'logid'}} = -1;
			} until (($dellog->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0) || (@logs == 0));
			$rowcount = $maxrow;
		}

		$pagecount++ if (($logidx->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0)); # アクションは行数に数えない
	}

	return (\@logs, \%logkeys, $rowover, $firstlog);
}

#----------------------------------------
# ログの取得（逆方向探索）
#----------------------------------------
sub GetVLogsReverse {
	my ($self, $mode, $skip, $maxrow, $masked) = @_;
	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	my $i;
	my @logs;
	my %logkeys;
	my $rowcount = 0;
	my $rowover = 0;
	my $lastlog = -1;
	my $list = $self->{'logindex'}->{'file'}->getlist();

	for ($i = $#$list; $i >= 0; $i--) {
		my $logidx = $list->[$i];

		# maskedid 対応
		my $logid = $logidx->{'logid'};
		my $uid = $logidx->{'uid'};
		if ($masked > 0) {
			$logid = $logidx->{'maskedid'};
			$uid = $sow->{'uid'};
		}

		if (($mode eq 'next') && ($logid eq $query->{'logid'}) && ($uid eq $logidx->{'uid'})) {
			# 「次」移動の場合は基準ログIDに辿り着いた時点でループから抜ける
			$rowover = 1;
			last;
		}

		next if ($self->CheckLogPermition($logidx) == 0);

		# 末尾の可視ログ番号
		$lastlog = $logidx->{'indexno'} if ($lastlog < 0);

		if (($rowcount >= $maxrow) && ($maxrow > 0) && ($mode ne 'next')) {
			# 指定行数を超えたらループから抜ける
			$rowover = 1;
			last;
		}

		if (($mode eq 'logid') && ($sow->{'outmode'} ne 'mb') && ($query->{'move'} ne 'page') && ($skip == 0)) {
			$rowover = 1;
			last;
		}

		if (($mode eq 'logid') && ($logid eq $query->{'logid'})) {
			# ログID直接指定処理
			$skip = 0;
		}

		if ($skip == 0) {
			# ログインデックスを登録
			unshift(@logs, $logidx);
			$logkeys{$logidx->{'logid'}} = $logidx->{'indexno'};
			$rowcount++ if (($logidx->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0)); # アクションは行数に数えない
		}

		if (($rowcount > $maxrow) && ($maxrow > 0)) {
			# 行数がオーバーした場合は削る
			my $dellog;
			do {
				$dellog = pop(@logs);
				$logkeys{$dellog->{'logid'}} = -1;
			} until (($dellog->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0) || (@logs == 0));
			$rowcount = $maxrow;
		}

		if (($mode eq 'prev') && ($logid eq $query->{'logid'}) && ($uid eq $logidx->{'uid'})) {
			# 「前」移動の処理
			$skip = 0;
		}
	}

	return (\@logs, \%logkeys, $rowover, $lastlog);
}

#----------------------------------------
# 発言の撤回削除
#----------------------------------------
sub delete {
	my ($self, $del_queid) = @_;

	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $logfile = $self->{'logfile'}->{'file'};
	my $logcnt  = $self->{'logcnt'}->{'file'};
	my $quefile = $self->{'que'}->{'file'};

	my $queindexno = $quefile->getbyid($del_queid);
	if ($queindexno >= 0) {
		my $que = $quefile->getlist->[$queindexno];
		my $log = $logfile->read($que->{'pos'});

		my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);
		if (($log->{'logid'} ne $del_queid)) {
			# ログデータに該当するログがない（本来ありえない）
			$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, "Cancel, [queid=$del_queid, logid=$log->{'logid'}]");
		} else {
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "削除しようとした保留中の発言が見つかりません。", "cannot delete say.[cmd=cancel, vid=$self->{'vil'}->{'vid'}, del_queid=$del_queid]") if (($log->{'uid'} ne $sow->{'uid'})&&($log->{'uid'} ne $sow->{'cfg'}->{'USERID_NPC'})); # 権限のないユーザからの撤回コマンドが飛んできた場合、セキュリティのためこういう警告にする
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "削除しようとした保留中の発言が見つかりません。", "cannot delete say.[cmd=cancel, vid=$self->{'vil'}->{'vid'}, del_queid=$del_queid]") if ($sow->{'time'} >= $que->{'fixtime'});

			# ログから削除
			my $logindexno = $self->{'logindex'}->{'file'}->getbyid($log->{'logid'});
			$log->{'mestype'} = $sow->{'MESTYPE_DELETED'};
			$log->{'logid'} = &SWLog::CreateLogID($sow, $log->{'mestype'}, $log->{'logsubid'}, $logcount);
			$self->update($log, $logindexno);

			my $pl = $vil->getpl($log->{'uid'});
			$pl->{'modified'} = $sow->{'time'};
			$vil->writevil();

			# キューから削除
			$que->{'delete'} = 1;
			$quefile->write();
		}
	} else {
		# キューに該当するデータがない（＝確定している）
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "削除しようとした保留中の発言が見つかりません。", "cannot delete say.[cmd=cancel, vid=$self->{'vil'}->{'vid'}, del_queid=$del_queid]");
	}
}

#----------------------------------------
# インフォメーション（個別）の書き込み
#----------------------------------------
sub writeinfo {
	my ($self, $uid, $mestype, $mes) = @_;

	my $sow = $self->{'sow'};
	$uid = $sow->{'cfg'}->{'USERID_ADMIN'} if ($uid eq '');

	# 書き込み
	my %say = (
		uid        => $uid,
		target     => $uid,
		mestype    => $mestype,
		logsubid   => $sow->{'LOGSUBID_INFO'},
		csid       => $sow->{'DATATEXT_NONE'},
		cid        => $sow->{'DATATEXT_NONE'},
		chrname    => '',
		expression => 0,
		mes        => $mes,
		undef      => 0,
		monospace  => 0,
		que        => 0,
	);
	$self->executesay(\%say);
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, $mes);

	return;
}

#----------------------------------------
# ログの閲覧権チェック
#----------------------------------------
sub CheckLogPermition {
	my ($self, $log) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};
	my $logined = $sow->{'user'}->logined();
	my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);
	my $logpermit = 0;
	my $isque = 0;
	my $overhear = (1 == $sow->{'cfg'}->{'ENABLED_BITTY'})?(9):(8);

	$logpermit = 1 if (($logined > 0) && ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})); # 管理者モード
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'})); # インフォ（通常）
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'})); # 村建て人発言
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'})); # 管理人発言
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_SAY'})&&($log->{'logsubid'} ne $sow->{'LOGSUBID_BOOKMARK'})); # 通常発言
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_MSAY'}));  # 憑依発言
	# 見物人
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'alive'));
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} ne 'alive')&&($vil->{'turn'} == 0));
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} ne 'alive')&&(defined($query->{'turn'}))&&($query->{'turn'} == 0));

	# 日蝕
	if ($vil->iseclipse($sow->{'turn'})){
		$logpermit = 8 if ($log->{'mestype'} == $sow->{'MESTYPE_SAY'});
	}

	# 未確定発言を見せない。
	if ($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_QUEUE'}]){
		$isque = 1;
		$logpermit = 0;
	}

	if ($vil->{'epilogue'} < $vil->{'turn'}) {
		# 終了後
		$logpermit = $overhear if (($log->{'mestype'} == $sow->{'MESTYPE_WSAY'})      && ($query->{'mode'} eq 'girl')); # 少女視点
		$logpermit = $overhear if (($log->{'mestype'} == $sow->{'MESTYPE_XSAY'})      && ($query->{'mode'} eq 'girl')); # 少女視点
		$logpermit = $overhear if (($log->{'mestype'} == $sow->{'MESTYPE_SPSAY'})     && ($query->{'mode'} eq 'girl')); # 少女視点
		$logpermit = $overhear if (($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})      && ($query->{'mode'} eq 'necro')); # 降霊者視点
		$logpermit = 8 if (($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'})  && ($query->{'mode'} eq 'girl')); # 少女視点
		$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_WSAY'})      && ($query->{'mode'} eq 'wolf')); # 狼視点
		$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})      && ($query->{'mode'} eq 'grave')); # 墓視点
		$logpermit = 1 if ($query->{'mode'} eq 'all'); # 全視点
		$logpermit = 1 if ($query->{'mode'} eq ''); # 全視点
	} elsif (($vil->isepilogue() > 0) && ($isque != 1)) {
		# エピローグ中
		$logpermit = 1;
	} elsif ((0 < $logined)) {
		# 進行中
		$logpermit = $curpl->isLogPermition($sow, $vil, $log, $logpermit, $isque) if (defined($curpl->{'uid'}));
	}

	# 削除済み発言は見せない
	$logpermit = 0 if (($log->{'mestype'} == $sow->{'MESTYPE_DELETED'}) && ($sow->{'cfg'}->{'ENABLED_DELETED'} == 0));

	# 個人フィルタ
	# 隠れ系のログに対しては動作しない。
	if (($logpermit < 2)) {
		if      ($query->{'pno'} == 0) {
		} elsif ($query->{'pno'} <  0) {
			my $targetid = -$query->{'pno'};
			my $logtypeid    = $sow->{'MESTYPE2TYPEID'}->[$log->{'mestype'}];
			$logpermit = 0 if ($logpermit != 1);
			$logpermit = 0 if ($logtypeid != $targetid);
		} elsif ($sow->{'turn'} > 0) {
			my $targetpl = $vil->getplbypno($query->{'pno'});
			if (defined($targetpl->{'uid'})) {
				$logpermit = 0 if ($logpermit != 1);
# 内緒話を発している時と、受けているとき表示する場合。
#				$logpermit = 0 if (($log->{'uid'}  ne $targetpl->{'uid'} )&&($log->{'target'} ne $targetpl->{'uid'} ));
# 内緒話を発しているときのみ表示する場合。
				$logpermit = 0 if (($log->{'csid'} ne $targetpl->{'csid'})||($log->{'cid'} ne $targetpl->{'cid'}));
#				$logpermit = 0 if ($log->{'date'} < $targetpl->{'entrieddt'});
				$logpermit = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}); # 村建て人発言
				$logpermit = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}); # 管理人発言
			}
		}
	}

	$log->{'logpermit'} = $logpermit;
	return $logpermit;
}

1;
