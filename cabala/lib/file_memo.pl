package SWSnake;

#----------------------------------------
# SWBBS Memo Driver Library 'SW-Snake'
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $turn, $mode) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo_data.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo_idx.pl";

	my $self = {
		sow    => $sow,
		vil      => $vil,
		turn     => $turn,
		version  => ' 1.0',
		startpos => 0,
	};
	bless($self, $class);

	# メモファイルの新規作成／開く
	$self->{'memo'} = SWSnakeMemo->new($sow, $vil, $turn, $mode);
	if ($sow->{'query'}->{'cmd'} eq 'restmemo') {
		# メモインデックスファイルの新規作成／開く
		$self->{'memoindex'} = SWSnakeMemoIndex->new($sow, $vil, $turn, 1);
	}

	# メモインデックスファイルの新規作成／開く
	$self->{'memoindex'} = SWSnakeMemoIndex->new($sow, $vil, $turn, $mode);

	return $self;
}

#----------------------------------------
# ファイルを閉じる
#----------------------------------------
sub close {
	my $self = shift;

	$self->{'memo'}->{'file'}->close();
	$self->{'memoindex'}->{'file'}->close();
}

#----------------------------------------
# メモデータの読み込み
#----------------------------------------
sub read {
	my ($self, $pos, $logpermit) = @_;
	my $data = $self->{'memo'}->{'file'}->read($pos);
	if( 7 <  $logpermit  ){
		my $sow = $self->{'sow'};
		$data->{'mestype'} = $sow->{'MESTYPE_INFOSP'};
		$data->{'chrname'} = '？';
		$data->{'cid'} = '';
	}
	$data->{'log'} = '' if ($data->{'log'} eq $self->{'sow'}->{'DATATEXT_NONE'});
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
# メモデータの追加
#----------------------------------------
sub add {
	my ($self, $log) = @_;
	my $sow = $self->{'sow'};
	$log->{'log'} = $sow->{'DATATEXT_NONE'} if ($log->{'log'} eq '');

	$self->setip($log);
	$self->{'memo'}->{'file'}->add($log);
	$self->addmemoidx($log);

	$log->{'log'} = '' if ($log->{'log'} eq $sow->{'DATATEXT_NONE'});
}

#----------------------------------------
# メモデータの更新
#----------------------------------------
sub update {
	my ($self, $log, $indexno) = @_;
	my $sow = $self->{'sow'};
	$log->{'log'} = $sow->{'DATATEXT_NONE'} if ($log->{'log'} eq '');

	$self->{'memo'}->{'file'}->update($log);
	my $logidx = $self->{'memoindex'}->set($log);
	$self->{'memoindex'}->{'file'}->update($logidx, $indexno);
	$log->{'log'} = '' if ($log->{'log'} eq $sow->{'DATATEXT_NONE'});
}

#----------------------------------------
# インデックスデータの追加
#----------------------------------------
sub addmemoidx {
	my ($self, $log) = @_;
	my $logidx = $self->{'memoindex'}->set($log);
	$self->{'memoindex'}->{'file'}->add($logidx);
	return;
}

#----------------------------------------
# IPアドレスのセット
#----------------------------------------
sub setip {
	my ($self, $data) = @_;
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
# メモ全体の取得（インデックス配列）
#----------------------------------------
sub getmemolist {
	my $self  = shift;
	my $sow   = $self->{'sow'};
	my $query = $sow->{'query'};

	my $list = $self->getlist();
	if ($query->{'cmd'} eq 'memo') {
		# 最新のものだけ抽出
		my @newlogs = ();
		my %uids = ();
		my $i;

		# 優先表示（管理系）
		for ($i = $#$list; $i >= 0; $i--) {
			my $log = $list->[$i];
			my $disable_mestype = 1;
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_MAKER'});
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'});
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'});
			next if (1 == $disable_mestype);
			next if (defined($uids{$log->{'mestype'}}));
			unshift(@newlogs, $log);
			$uids{$log->{'mestype'}} = 1;
		}

		# それ以外
		for ($i = $#$list; $i >= 0; $i--) {
			my $log = $list->[$i];
			my $disable_mestype = 1;
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_MAKER'});
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'});
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'});
			next if (0 == $disable_mestype);
			my $plsingle = $self->{'vil'}->getpl($log->{'uid'});
			next if (!defined($plsingle->{'uid'}));
			next if (defined($uids{$log->{'uid'}}));
			next if (($plsingle->{'entrieddt'} > $log->{'date'}) && ($plsingle->{'entrieddt'} != 0));
			unshift(@newlogs, $log);
			$uids{$log->{'uid'}} = 1;
		}
		$list = \@newlogs;
	}

	return $list;
}

#----------------------------------------
# インデックスデータの再構築
#----------------------------------------
sub restructure {
	my $self = shift;
	my $logfile = $self->{'memo'}->{'file'};
	$self->{'memoindex'}->{'file'}->clear();

	my $pos = $logfile->{'startpos'};
	my $log = $logfile->read($pos);
	while (defined($log->{'uid'})) {
		$self->addmemoidx($log);
		$pos = $log->{'nextpos'};
		$log = $logfile->read($pos);
	}
}

#----------------------------------------
# 表示するメモの取得（インデックス配列）
#----------------------------------------
sub getmemo {
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

	# 検索
	my ($logs, $rowover, $firstlog, $lastlog);
	my $foward = 0;
	$foward = 1 if ($sow->{'query'}->{'move'} eq 'first');
	$foward = 1 if ($maxrow < 0);
	$foward = 1 if ($sow->{'query'}->{'move'} eq 'page');
	if ($foward > 0) {
		# 順方向探索
		($logs, $logkeys, $rowover, $firstlog) = $self->GetVLogsForward($mode, $skip, $maxrow);
		if ($firstlog >= 0) {
			$rows{'start'} = 1 if ((defined($logs->[0])) && ($logs->[0]->{'indexno'} == $firstlog));
			$rows{'end'}   = 1 if ($rowover == 0);
		}
	} else {
		# 逆方向探索
		($logs, $logkeys, $rowover, $lastlog) = $self->GetVLogsReverse($mode, $skip, $maxrow);
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
	my ($self, $mode, $skip, $maxrow) = @_;
	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	my $i;
	my @logs;
	my %logkeys;
	my $rowcount = 0;
	my $rowover = 0;
	my $firstlog = -1;
	my $list = $self->getmemolist();

	for ($i = 0; $i < @$list; $i++) {
		my $logidx = $list->[$i];
		next if ($self->CheckMemoPermition($logidx) == 0);

		# 先頭のメモ番号
		$firstlog = $logidx->{'indexno'} if ($firstlog < 0);
		if (($rowcount >= $maxrow) && ($maxrow > 0)) {
			# 指定行数を超えたらループから抜ける
			$rowover = 1;
			last;
		}

		last if (($mode eq 'logid') && ($sow->{'outmode'} ne 'mb') && ($skip == 0));

		if (($mode eq 'logid') && ($logidx->{'logid'} eq $query->{'logid'})) {
			$skip = 0;
		}

		if ($skip == 0) {
			# ログインデックスを登録
			push(@logs, $logidx);
			$logkeys{$logidx->{'logid'}} = $logidx->{'indexno'};
			$rowcount++; # アクションは行数に数えない
		}

		if (($rowcount > $maxrow) && ($maxrow > 0)) {
			# 行数がオーバーした場合は削る
			my $dellog = shift(@logs);
			$logkeys{$dellog->{'logid'}} = -1;
			$rowcount = $maxrow;
		}
	}

	return (\@logs, \%logkeys, $rowover, $firstlog);
}

#----------------------------------------
# ログの取得（逆方向探索）
#----------------------------------------
sub GetVLogsReverse {
	my ($self, $mode, $skip, $maxrow) = @_;
	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	my $i;
	my @logs;
	my %logkeys;
	my $rowcount = 0;
	my $rowover = 0;
	my $lastlog = -1;
	my $list = $self->getmemolist();

	for ($i = $#$list; $i >= 0; $i--) {
		my $logidx = $list->[$i];
		my $logid = $logidx->{'logid'};

		if (($mode eq 'next') && ($logid eq $query->{'logid'})) {
			# 「次」移動の場合は基準ログIDに辿り着いた時点でループから抜ける
			$rowover = 1;
			last;
		}
		next if ($self->CheckMemoPermition($logidx) == 0);

		# 末尾のメモログ番号
		$lastlog = $logidx->{'indexno'} if ($lastlog < 0);

		if (($rowcount >= $maxrow) && ($maxrow > 0) && ($mode ne 'next')) {
			# 指定行数を超えたらループから抜ける
			$rowover = 1;
			last;
		}

		last if (($mode eq 'logid') && ($sow->{'outmode'} ne 'mb') && ($skip == 0));

		if (($mode eq 'logid') && ($logid eq $query->{'logid'})) {
			# ログID直接指定処理
			$skip = 0;
		}

		if ($skip == 0) {
			# ログインデックスを登録
			unshift(@logs, $logidx);
			$logkeys{$logidx->{'logid'}} = $logidx->{'indexno'};
			$rowcount++;
		}

		if (($rowcount > $maxrow) && ($maxrow > 0)) {
			# 行数がオーバーした場合は削る
			my $dellog = pop(@logs);
			$logkeys{$dellog->{'logid'}} = -1;
			$rowcount = $maxrow;
		}

		if (($mode eq 'prev') && ($logid eq $query->{'logid'})) {
			# 「前」移動の処理
			$skip = 0;
		}
	}

	return (\@logs, \%logkeys, $rowover, $lastlog);
}

#----------------------------------------
# 指定したプレイヤーの最新メモを取得
#----------------------------------------
sub getnewmemo {
	my ($self, $curpl) = @_;
	my $logs = $self->getlist();
	my $i;
	my $log = {
		log => '',
	};
	for ($i = $#$logs; $i >= 0; $i--) {
		next if ($curpl->{'uid'} ne $logs->[$i]->{'uid'});
		next if ($curpl->{'csid'} ne $logs->[$i]->{'csid'});
		next if ($curpl->{'cid'} ne $logs->[$i]->{'cid'});
		next if (($curpl->{'entrieddt'} > $logs->[$i]->{'date'}) && ($curpl->{'entrieddt'} != 0));
		$log = $self->read($logs->[$i]->{'pos'});
		last;
	}

	return $log;
}

#----------------------------------------
# 表示できるメモの取得（インデックス配列）
#----------------------------------------
sub getlist {
	my $self = shift;

	my $list = $self->{'memoindex'}->{'file'}->getlist();
	my @result;

	foreach (@$list) {
		push(@result, $_) if ($self->CheckMemoPermition($_) > 0);
	}

	return \@result;
}

#----------------------------------------
# ログの閲覧権チェック
#----------------------------------------
sub CheckMemoPermition {
	my ($self, $log) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};
	my $logined = $sow->{'user'}->logined();
	my $logpermit = 0;
	my $overhear = (1 == $sow->{'cfg'}->{'ENABLED_BITTY'})?(9):(8);

	$logpermit = 1 if (($logined > 0) && ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})); # 管理者モード
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'})); # インフォ（通常）
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'})); # 村建て人発言
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'})); # 管理人発言
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'})); # 匿名発言
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_SAY'})); # 通常発言
	# 見物人
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'alive')); 
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} ne 'alive')&&($vil->{'turn'} == 0)); 
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} ne 'alive')&&(defined($query->{'turn'}))&&($query->{'turn'} == 0)); 

	# 日蝕
	if ($vil->iseclipse($sow->{'turn'})){
		$logpermit = 8 if ($log->{'mestype'} == $sow->{'MESTYPE_SAY'});
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
	} elsif (($vil->isepilogue() > 0)) {
		# エピローグ中
		$logpermit = 1;
	} elsif ((0 < $logined)) {
		# 進行中
		$logpermit = $curpl->isLogPermition($sow, $vil, $log, $logpermit ) if (defined($curpl->{'uid'}));
	}

	# 削除済み発言は見せない
	$logpermit = 0 if (($log->{'mestype'} == $sow->{'MESTYPE_DELETED'}) && ($sow->{'cfg'}->{'ENABLED_DELETED'} == 0));	

	$log->{'logpermit'} = $logpermit;
	return $logpermit;
}

1;