package SWFileVil;

#----------------------------------------
# 村データファイル制御
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow, $vid) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_player.pl";

	my %pl;
	my @pllist;
	my $self = {
		sow  => $sow,
		vid    => $vid,
		pl     => \%pl,
		pllist => \@pllist,
		dir    => $sow->{'cfg'}->{'ENABLED_DIRVIL'},
	};
	my %csidlist = ();
	$sow->{'csidlist'} = \%csidlist;

	return bless($self, $class);
}

#----------------------------------------
# 村データの作成
#----------------------------------------
sub createvil {
	my $self = shift;
	my $sow = $self->{'sow'};

	my $filename;
	if ($self->{'dir'} == 0) {
		$filename = &GetFNameVil($self->{'sow'}, $self->{'vid'});
	} else {
		my $dirname = &GetFNameDirVid($sow, $self->{'vid'});
		umask(0);
		mkdir($dirname, $sow->{'cfg'}->{'PERMITION_MKDIR'});
		open(INDEXHTML, ">$dirname/index.html");
		close(INDEXHTML);
		$filename = &GetFNameVilDirVid($self->{'sow'}, $self->{'vid'});
	}

	my $fh = \*VIL;
	my $file = SWFile->new($self->{'sow'}, 'vil', $fh, $filename, $self);
	$file->openfile(
		'>',
		'村データ',
		"[vid=$self->{'vid'}]",
	);
	$self->{'file'} = $file;
	$self->closevil();

	$self->{'turn'}          = 0;
	$self->{'rolediscard'}   = '';
	$self->{'eventcard'}     = '';
	$self->{'eclipse'}       = '';
	$self->{'seance'}        = '';
	$self->{'noselrole'}     = 1;
	$self->{'updateddt'}     = $sow->{'time'};
	$self->{'nextupdatedt'}  = $sow->{'time'};
	$self->{'nextchargedt'}  = $sow->{'time'};
	$self->{'nextcommitdt'}  = $sow->{'time'};
	$self->{'epilogue'}      = 9999;
	$self->{'winner'}        = 0;
	$self->{'useless'}       = 0;
	$self->{'modifiedsay'}   = 0;
	$self->{'modifiedwsay'}  = 0;
	$self->{'modifiedgsay'}  = 0;
	$self->{'modifiedspsay'} = 0;
	$self->{'modifiedxsay'}  = 0;
	$self->{'modifiedvsay'}  = 0;
	$self->{'cntmemo'}       = 0;
	$self->{'extend'}        = 2;
	$self->{'emulated'}      = 0;
	$self->{'grudge'}        = -1;
	$self->{'riot'}          = -1;
	$self->{'scapegoat'}     = -1;
	$self->{'event'}         = 0;
	%{$self->{'pl'}} = ();
	%{$self->{'plface'}} = ();
	@{$self->{'pllist'}} = ();
	%{$sow->{'csidlist'}} = ();
	$sow->{'turn'} = 0;

	return;
}

#----------------------------------------
# ダミーの村データの作成
#----------------------------------------
sub createdummyvil {
	my $self = shift;
	my $sow = $self->{'sow'};

	$self->{'turn'}         = 0;
	$self->{'rolediscard'}  = '';
	$self->{'updateddt'}    = $sow->{'time'};
	$self->{'nextupdatedt'} = $sow->{'time'};
	$self->{'nextchargedt'} = $sow->{'time'};
	$self->{'nextcommitdt'} = $sow->{'time'};
	$self->{'epilogue'}     = 9999;
	$self->{'winner'}       = 0;
	$self->{'randomtarget'} = 0;
	$self->{'showid'}       = 0;
	$self->{'undead'}       = 0;
	$self->{'extend'}       = 2;
	$self->{'emulated'}     = 1;
	%{$self->{'pl'}} = ();
	%{$self->{'plface'}} = ();
	@{$self->{'pllist'}} = ();
	%{$sow->{'csidlist'}} = ();
	$sow->{'turn'} = 0;

	return;
}

#----------------------------------------
# 村データの読み込み
#----------------------------------------
sub readvil {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $filename;
	my $dirname = &GetFNameDirVid($sow, $self->{'vid'});
	if (-e $dirname) {
		$self->{'dir'} = 1;
		$filename = &GetFNameVilDirVid($self->{'sow'}, $self->{'vid'});
	} else {
		$self->{'dir'} = 0;
		$filename = &GetFNameVil($sow, $self->{'vid'});
	}

	# ファイルを開く
	my $fh = \*VIL;
	my $file = SWFile->new($self->{'sow'}, 'vil', $fh, $filename, $self);
	$file->openfile(
		'+<',
		'村データ',
		"[vid=$self->{'vid'}]",
	);
	$self->{'file'} = $file;

	seek($fh, 0, 0);
	my @data = <$fh>;

	# 村データの読み込み
	my $villabel = shift(@data);
	my @villabel = split(/<>/, $villabel);
	@villabel = &GetVilDataLabel() if ($villabel[0] eq '');
	@$self{@villabel} = split(/<>/, shift(@data));

	my @villabelnew = &GetVilDataLabel();
	# 移行用コード
	foreach (@villabelnew) {
		$self->{$_} = 0 if (!defined($self->{$_}));
	}
	$self->{'useless'} = 0;

	$self->{'entrypwd'} = '' if (!defined($self->{'entrypwd'}));
	$self->{'entrypwd'} = '' if ($self->{'entrypwd'} eq $self->{'sow'}->{'DATATEXT_NONE'});

	my $pllabel = shift(@data);
	chomp($pllabel);
	my @pllabel = split(/<>/, $pllabel);
	%{$self->{'pl'}} = ();
	%{$self->{'plface'}} = ();
	@{$self->{'pllist'}} = ();
	%{$sow->{'csidlist'}} = ();

	my $i = 0;
	my $datacnt = @data;
	while ($i < $datacnt) {
		chomp($data[$i]);
		if ($data[$i] ne '') {
			my $plsingle = SWPlayer->new($sow);
			$plsingle->readpl(\@pllabel, $data[$i]);
			$self->addpl($plsingle);
		}
		$i++;
	}

	# 参照中の村番号とログ日付番号をセット
	if (defined($sow->{'query'}->{'turn'})) {
		$sow->{'turn'} = $sow->{'query'}->{'turn'};
	} else {
		$sow->{'turn'} = $self->{'turn'};
#		$sow->{'turn'} = $self->{'epilogue'} if ($self->{'epilogue'} < $self->{'turn'});
	}

	# カレントプレイヤー（ログイン中のプレイヤー）
	$sow->{'curpl'} = $self->getpl($sow->{'uid'}) if ($self->checkentried() >= 0);

	$self->{'emulated'} = 0;

	$self->closevil();

	return;
}

#----------------------------------------
# 村データの書き込み
#----------------------------------------
sub writevil {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $pllist = $self->{'pllist'};

#	my $fh = $self->{'file'}->{'filehandle'};
#	truncate($fh, 0);
#	seek($fh, 0, 0);

	my $fh = \*TMP;
	my $tempfname = sprintf(
		"%s/%04d%s_%s_%s",
		$sow->{'cfg'}->{'DIR_VIL'},
		$self->{'vid'},
		$ENV{'REMOTE_PORT'},
		$$,
		$sow->{'cfg'}->{'FILE_VIL'},
	);
	open($fh, ">$tempfname") || $sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, "村データの書き込みに失敗しました。", "cannot write vil data.");

	$self->{'entrypwd'} = $self->{'sow'}->{'DATATEXT_NONE'} if ($self->{'entrypwd'} eq '');
	my @villabel = &GetVilDataLabel();
	print $fh join("<>", @villabel). "<>\n";
	print $fh join("<>", map{$self->{$_}}@villabel). "<>\n";

	if (@$pllist > 0) {
		my @pllabel = $pllist->[0]->getdatalabel();
		print $fh join("<>", @pllabel). "<>\n";
		foreach (@$pllist) {
			next if ($_->{'delete'} > 0); # 削除
			$_->writepl($fh);
		}
	}
	close($fh);

	my $filename;
	my $dirname = &GetFNameDirVid($sow, $self->{'vid'});
	if (-e $dirname) {
		$self->{'dir'} = 1;
		$filename = &GetFNameVilDirVid($self->{'sow'}, $self->{'vid'});
	} else {
		$self->{'dir'} = 0;
		$filename = &GetFNameVil($sow, $self->{'vid'});
	}
	rename($tempfname, $filename);

	$self->{'entrypwd'} = '' if ($self->{'entrypwd'} eq $self->{'sow'}->{'DATATEXT_NONE'});
}

#----------------------------------------
# 村データの削除
#----------------------------------------
sub deletevil {
	my $self = shift;
	my $sow = $self->{'sow'};

	my $dirname = &GetFNameDirVid($sow, $self->{'vid'});
	my @files;
	opendir(DIR, $dirname);
	foreach (readdir(DIR)) {
		next if (($_ eq '.') || ($_ eq '..'));
		push(@files, "$dirname/$_");
	}
	closedir(DIR);
	unlink(@files);
	rmdir($dirname);
}

#----------------------------------------
# 村データを閉じる
#----------------------------------------
sub closevil {
	my $self = shift;
	$self->{'file'}->closefile();
}

#----------------------------------------
# プレイヤー追加
#----------------------------------------
sub addpl {
	my ($self, $plsingle) = @_;

	my $pllist = $self->{'pllist'};

	$plsingle->{'vil'} = $self;
	$self->{'pl'}->{$plsingle->{'uid'}} = $plsingle;
	$self->{'plface'}->{$plsingle->{'csid'}.$plsingle->{'cid'}} = $plsingle;
	$plsingle->{'pno'} = @$pllist;
	$pllist->[$plsingle->{'pno'}] = $plsingle;
	$self->{'sow'}->{'csidlist'}->{$plsingle->{'csid'}} = 1;

	return;
}

#----------------------------------------
# １村分の戦績データを追加
#----------------------------------------
sub addrecord {
	my $self = shift;
	my $sow = $self->{'sow'};

	return if (!(-w $sow->{'cfg'}->{'DIR_RECORD'})); # 念のため

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_record.pl";

	my $pllist = $self->getpllist();
	foreach (@$pllist) {
		my $record = SWUserRecord->new($sow, $_->{'uid'});
		my $indexno = -1;
		my $recordlist = $record->{'file'}->getlist();
		my $i;
		for ($i = 0; $i < @$recordlist; $i++) {
			$indexno = $i if ($recordlist->[$i]->{'vid'} eq $self->{'vid'});
		}
		if (@$recordlist == 0) {
			$record->add($self, $_);
		} elsif ($indexno >= 0) {
			$record->update($self, $_, $indexno);
		} else {
			$record->append($self, $_);
		}
		$record->close();
	}

	return;
}

#----------------------------------------
# １村分の戦績データを追加
#----------------------------------------
sub addappend {
	my $self = shift;
	my $sow = $self->{'sow'};

	return if (!(-w $sow->{'cfg'}->{'DIR_RECORD'})); # 念のため

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_record.pl";

	my $pllist = $self->getpllist();
	foreach (@$pllist) {
		my $record = SWUserRecord->new($sow, $_->{'uid'}, 1);
		$record->append($self, $_);
		$record->close();
	}

	return;
}


#----------------------------------------
# 「参加中の村」データの更新
#----------------------------------------
sub updateentriedvil {
	my ($self, $playing) = @_;
	my $sow = $self->{'sow'};

	my $pllist = $self->getpllist();
	foreach (@$pllist) {
		my $user = SWUser->new($sow);
		$user->writeentriedvil($_->{'uid'}, $self->{'vid'}, $self->{'vname'}, $_->getlongchrname(), $playing);
	}

	return;
}

#----------------------------------------
# 指定したuidのプレイヤーデータを得る
#----------------------------------------
sub getpl {
	my ($self, $uid) = @_;
	return $self->{'pl'}->{$uid};
}

#----------------------------------------
# 指定したuidのプレイヤーデータを得る
#----------------------------------------
sub getplbyface {
	my ($self, $csid, $cid) = @_;
	return $self->{'plface'}->{$csid.$cid};
}

#----------------------------------------
# 指定した番号のプレイヤーデータを得る
#----------------------------------------
sub getplbypno {
	my ($self, $pno) = @_;
	return $self->{'pllist'}->[$pno];
}

#----------------------------------------
# プレイヤーデータの配列を得る
#----------------------------------------
sub getallpllist {
	my $self = shift;
	return $self->{'pllist'};
}

#----------------------------------------
# 勝敗に影響するプレイヤーデータの配列を得る
#----------------------------------------
sub getpllist {
	my $self = shift;
	my @pllist;
	foreach (@{$self->{'pllist'}}) {
		next if (($_->{'live'} eq 'mob'));
		push(@pllist, $_);
	}
	return \@pllist;
}

#----------------------------------------
# 特定のプレイヤーデータの配列を得る
#----------------------------------------
sub getsheeppllist{
	my $self = shift;
	my @sheeppl;
	foreach (@{$self->{'pllist'}}) {
		push(@sheeppl, $_) if ($_->{'sheep'} ne '');
	}
	return \@sheeppl;
}

sub getrolepllist{
	my ($self, $roleid) = @_;
	my @rolepl;
	foreach (@{$self->{'pllist'}}) {
		push(@rolepl, $_) if ($_->{'role'} == $roleid);
	}
	return \@rolepl;
}

sub getlivepllist {
	my $self = shift;
	my @livepllist;
	foreach (@{$self->{'pllist'}}) {
		push(@livepllist, $_) if ($_->{'live'} eq 'live');
	}
	return \@livepllist;
}

#----------------------------------------
# アクセスしているプレイヤーが参加済みかどうかを得る
#----------------------------------------
sub checkentried {
	my $self = shift;
	my $pno = $self->{'pl'}->{$self->{'sow'}->{'uid'}}->{'pno'};
	if (defined($pno)) {
		return $pno;
	} else {
		return -1;
	}
}

#----------------------------------------
# 発言数初期化
#----------------------------------------
sub setsaycountall {
	my $self = $_[0];

	foreach (@{$self->{'pllist'}}) {
		$_->setsaycount();
	}

	return;
}

#----------------------------------------
# 発言数回復
#----------------------------------------
sub chargesaycountall {
	my $self = $_[0];

	foreach (@{$self->{'pllist'}}) {
		$_->chargesaycount();
	}

	return;
}

#----------------------------------------
# 更新処理
#----------------------------------------
sub UpdateTurn {
	my ($vil, $commit) = @_;
	my $sow = $vil->{'sow'};

	$vil->{'turn'} += 1;
	$vil->{'cntmemo'} = 0;
	$vil->{'nextupdatedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, $vil->{'updinterval'}, $commit);
#	$vil->{'nextchargedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, $commit);
	$vil->{'nextchargedt'} = $sow->{'time'} + 24 * 60 * 60;
	$sow->{'turn'} += 1;
}

#----------------------------------------
# コミット済みの人数を得る
#----------------------------------------
sub getcommittedpl {
	my $self = shift;
	my $sow = $self->{'sow'};

	my $count = 0;
	# コミット権利者がコミットしている人数を数えること。
	foreach (@{$self->{'pllist'}}) {
		$count++ if (($_->iscommitter())&&($_->{'commit'} > 0));
	}

	return $count;
}

sub getcommittablepl {
	my $self = shift;
	my $sow = $self->{'sow'};

	my $count = 0;
	foreach (@{$self->{'pllist'}}) {
		$count++ if ($_->iscommitter());
	}

	return $count;
}
#----------------------------------------
# 投票有権者の人数を得る
#----------------------------------------
sub getvotablepl {
	my $self = shift;
	my $sow = $self->{'sow'};

	my $count = 0;
	foreach (@{$self->{'pllist'}}) {
		$count++ if ($_->isvoter());
	}

	return $count;
}



sub getptcosts {
	my $vil = shift;
	my $cost_key = shift;
	my $unit_key = shift;
	my $sow = $vil->{'sow'};
	my $cfg = $sow->{'cfg'};
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $cost   = $saycnt->{$cost_key};
	my $unit   = $sow->{'basictrs'}->{'SAYTEXT'}->{$cost}->{$unit_key};
	
	$cost = 'none'  if ($vil->isfreecost());
	return ($saycnt,$cost,$unit);
}

sub getsayptcosts {
	my $vil = shift;
	return $vil->getptcosts('COST_SAY','UNIT_SAY');
}

sub getactptcosts {
	my $vil = shift;
	return $vil->getptcosts('COST_ACT','UNIT_ACTION');
}

sub getmemoptcosts {
	my $vil = shift;
	return $vil->getptcosts('COST_MEMO','UNIT_ACTION');
}

#----------------------------------------
# 村の状態を取得
#----------------------------------------
sub getvstatus {
	my $self = shift;
	my $sow = $self->{'sow'};

	my $draw = 0;
	my $pllist = $self->getpllist();
	foreach (@$pllist) {
		$draw = 1 if ($_->{'live'} eq 'live');
	}
	$draw = 0 if ($self->{'winner'} != 0);

	my $result = $sow->{'VSTATUSID_PRO'};
	$result = $sow->{'VSTATUSID_PLAY'} if ($self->{'turn'} > 0);
	if ($self->{'turn'} == $self->{'epilogue'}) {
		$result = $sow->{'VSTATUSID_EP'};
		$result = $sow->{'VSTATUSID_SCRAP'} if ($draw > 0);
	}
	if ($self->{'turn'} > $self->{'epilogue'}) {
		$result = $sow->{'VSTATUSID_END'};
		$result = $sow->{'VSTATUSID_SCRAPEND'} if ($draw > 0);
	}

	return $result;
}

#----------------------------------------
# 表示内容の基本加工
#----------------------------------------
sub Tag2Text {
	my ($self, $text) = @_;

	my $plnpc   = $self->{'pllist'}->[0];
	my $npcname = $plnpc->getshortchrname();
	$text =~ s/_NPC_/$npcname/g;

	my $nightdate  = ($self->{'turn'} - 1 );
	$text =~ s/_DATE_/$nightdate/g;

	my $gmt = time + $self->{'sow'}->{'cfg'}->{'TIMEZONE'} * 60 * 60;
	my($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = gmtime($gmt);
	$text =~ s/_HOUR_/$hour/g;

	return $text
}

sub getTextByID {
	my ($self, $key, $id) = @_;
	my $sow  = $self->{'sow'};
	my $text = $sow->{'textrs'}->{$key}->[$id];

	return  $self->Tag2Text($text);
}

sub getText {
	my ($self, $key) = @_;
	my $sow  = $self->{'sow'};
	my $text = $sow->{'textrs'}->{$key};
	
	return  $self->Tag2Text($text);
}

#----------------------------------------
# メモ・アクションOK?
#----------------------------------------
sub ischeckedday {
	my ($vil,$turn,$target) = @_;
	my $query = $vil->{'sow'}->{'query'};
	my @eclipse = split('/', $vil->{$target});
	my $check = 0;
	foreach  ( @eclipse ){
		$check = 1 if ( $_ == $turn );
	}
	return $check;
}

# 日食
sub iseclipse {
	my ($vil,$turn) = @_;
	return $vil->ischeckedday($turn,'eclipse');
}

# 降霊会
sub isseance {
	my ($vil,$turn) = @_;
	return $vil->ischeckedday($turn,'seance');
}

#----------------------------------------
# 生存者扱いしてよい?
#----------------------------------------
sub ispublic {
	my ($vil, $pl) = @_;
	my $live = 0;
	if( defined($pl) ){
		$live = 1 if  ($pl->{'live'} eq 'live');
		$live = 1 if (($pl->{'live'} eq 'mob') && ($vil->{'mob'} eq 'alive'));
		$live = 1 if (($pl->{'live'} eq 'mob') && ($vil->{'turn'} == 0));
	}
	$live = 1 if ( 0  < $vil->isepilogue() );
	$live = 1 if ( 0 == $vil->{'turn'}     );
	return $live;
}

#----------------------------------------
# 村がエピローグに入っている／終了しているかどうか
#----------------------------------------
sub isepilogue {
	my $self = shift;
	my $result = 0;
	$result = 1 if ($self->{'turn'} >= $self->{'epilogue'});

	return $result;
}

sub isscrap {
	my $self = shift;
	my $result = 1;
	$result = 0 if ( 0 != $self->{'winner'}   );
	$result = 0 if ( 0 == $self->isepilogue() );

	return $result;
}

sub isfreecost {
	my $vil = shift;
	my $cfg = $vil->{'sow'}->{'cfg'};
	my $result = 1;
	$result = 0 if (! $vil->isepilogue()         );
	$result = 0 if (  $cfg->{'ENABLED_MAX_ESAY'} );
	return $result;
}

sub isstartable {
	my $vil = shift;
	my $pllist = $vil->getpllist();
	my $committablepl = $vil->getcommittablepl();

	my $result = 1;
	$result = 0 if (@$pllist < $vil->{'vplcntstart'});
	$result = 0 if (($committablepl < 1)&&($vil->{'mob'} eq 'juror'));
	return $result;
}

#----------------------------------------
# 村データラベル
#----------------------------------------
sub GetVilDataLabel {
	my @datalabel = (
		'makeruid',
		'turn',
		'event',
		'grudge',
		'riot',
		'scapegoat',
		'rating',
		'epilogue',
		'winner',
		'rolediscard',
		'eventcard',
		'eclipse',
		'seance',
		'useless',
		'game',
		'vname',
		'vcomment',
		'ruleid',
		'trsid',
		'csid',
		'roletable',
		'updhour',
		'updminite',
		'updinterval',
		'entrylimit',
		'entrypwd',
		'vplcnt',
		'vplcntstart',
		'saycnttype',
		'updateddt',
		'nextupdatedt',
		'nextchargedt',
		'nextcommitdt',
		'scraplimitdt',
		'votetype',
		'starttype',
		'randomtarget',
		'showid',
		'undead',
		'extend',
		'noselrole',
		'mob',
		'cntvillager',
		'cntstigma',
		'cntfm',
		'cntsympathy',
		'cntseer',
		'cntseeronce',
		'cntaura',
		'cntseerwin',
		'cntseerrole',
		'cntguard',
		'cntmedium',
		'cntmediumwin',
		'cntmediumrole',
		'cntnecromancer',
		'cntfollow',
		'cntfan',
		'cnthunter',
		'cntweredog',
		'cntprince',
		'cntrightwolf',
		'cntdoctor',
		'cntcurse',
		'cntdying',
		'cntinvalid',
		'cntalchemist',
		'cntwitch',
		'cntgirl',
		'cntscapegoat',
		'cntelder',
		'cntpossess',
		'cntfanatic',
		'cntmuppeting',
		'cntwisper',
		'cntsemiwolf',
		'cntdyingpossess',
		'cntoracle',
		'cntsorcerer',
		'cntwolf',
		'cntaurawolf',
		'cntintwolf',
		'cntcursewolf',
		'cntwhitewolf',
		'cntchildwolf',
		'cntdyingwolf',
		'cntsilentwolf',
		'cntheadless',
		'cnthamster',
		'cntguru',
		'cntbat',
		'cnttrickster',
		'cntjammer',
		'cntmimicry',
		'cntsnatch',
		'cntdyingpixi',
		'cntrobber',
		'cntlover',
		'cntpassion',
		'cntlonewolf',
		'cntloveangel',
		'cnthatedevil',
		'cntdish',
		'cntbitch',
		'cntdipsy',
		'cntdecide',
		'cntshield',
		'cntglass',
		'cntogre',
		'cntfairy',
		'cntfink',
		'cntmob',
		'cntnothing',
		'cntaprilfool',
		'cntturnfink',
		'cntturnfairy',
		'cnteclipse',
		'cntcointoss',
		'cntforce',
		'cntmiracle',
		'cntprophecy',
		'cntclamor',
		'cntfire',
		'cntnightmare',
		'cntghost',
		'cntescape',
		'cntseance',
		'modifiedsay',
		'modifiedwsay',
		'modifiedgsay',
		'modifiedspsay',
		'modifiedxsay',
		'modifiedvsay',
		'cntmemo',
	);
	return @datalabel;
}

#----------------------------------------
# 村データファイル名の取得
#----------------------------------------
sub GetFNameVil {
	my ($sow, $vid, $turn) = @_;
	$vid = 0 if ($vid eq '');

	my $datafile = sprintf(
		"%s/%04d_%s",
		$sow->{'cfg'}->{'DIR_VIL'},
		$vid,
		$sow->{'cfg'}->{'FILE_VIL'},
	);
	return $datafile;
}

#----------------------------------------
# 村番号ディレクトリ名の取得
#----------------------------------------
sub GetFNameDirVid {
	my ($sow, $vid) = @_;
	$vid = 0 if ($vid eq '');

	my $datafile = sprintf(
		"%s/%04d",
		$sow->{'cfg'}->{'DIR_VIL'},
		$vid,
	);
	return $datafile;
}

#----------------------------------------
# 村データファイル名の取得
# （村番号ディレクトリ式）
#----------------------------------------
sub GetFNameVilDirVid {
	my ($sow, $vid) = @_;
	$vid = 0 if ($vid eq '');

	my $datafile = sprintf(
		"%s/%04d/%04d_%s",
		$sow->{'cfg'}->{'DIR_VIL'},
		$vid,
		$vid,
		$sow->{'cfg'}->{'FILE_VIL'},
	);
	return $datafile;
}

1;