package SWPlayer;

#----------------------------------------
# プレイヤーデータ
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow => $sow,
	};

	return bless($self, $class);
}

#----------------------------------------
# プレイヤーデータラベル
#----------------------------------------
sub getdatalabel {
	my @datalabel = (
		'uid',
		'cid',
		'csid',
		'jobname',
		'gift',
		'role',
		'rolestate',
		'rolesubid',
		'selrole',
		'sheep',
		'live',
		'deathday',
		'overhear',
		'say',
		'tsay',
		'spsay',
		'wsay',
		'xsay',
		'gsay',
		'say_act',
		'actaddpt',
		'saidcount',
		'saidpoint',
		'countinfosp',
		'countthink',
		'entrust1',
		'vote1',
		'vote2',
		'role1',
		'role2',
		'gift1',
		'gift2',
		'entrust',
		'entrusted',
		'bonds',
		'love',
		'pseudobonds',
		'pseudolove',
		'commit',
		'entrieddt',
		'limitentrydt',
		'lastwritepos',
		'history',
		'modified',
		'savedraft',
		'draftmestype',
		'draftmspace',
		'postfix',
		'zapcount',
		'clearance',
	);

	return @datalabel;
}

#----------------------------------------
# プレイヤーデータの新規作成
#----------------------------------------
sub createpl {
	my ($self, $uid) = @_;

	$self->{'uid'}          = $uid;
	$self->{'live'}         = 'live';
	$self->{'deathday'}     = -1;
	$self->{'gift'}         = -1;
	$self->{'role'}         = -1;
	$self->{'rolestate'}    = -1;
	$self->{'rolesubid'}    = -1;
	$self->{'jobname'}      = '';
	$self->{'entrust'}      = 0;
	$self->{'entrusted'}    = 1;
	$self->{'entrust1'}     = 0;
	$self->{'vote1'}        = 0;
	$self->{'vote2'}        = 0;
	$self->{'role1'}        = 0;
	$self->{'role2'}        = 0;
	$self->{'gift1'}        = 0;
	$self->{'bonds'}        = '',
	$self->{'love'}         = '',
	$self->{'history'}      = '';
	$self->{'saidcount'}    = 0;
	$self->{'saidpoint'}    = 0;
	$self->{'countinfosp'}  = 0;
	$self->{'countthink'}   = 0;
	$self->{'delete'}       = 0;
	$self->{'entrieddt'}    = $self->{'sow'}->{'time'};
	$self->{'limitentrydt'} = 0;
	$self->{'modified'}     = 0;
	$self->{'savedraft'}    = '';
	$self->{'draftmestype'} = 0;
	$self->{'draftmspace'}  = 0;
	$self->{'postfix'}      = '';
	$self->{'overhear'}     = -1;
	$self->{'zapcount'}     = 0;
	$self->{'clearance'}    = 1;

	# 一時的状態（この夜のみ有効な内容）をここで初期化。
	$self->{'tmp_suicide'}   = -1;
	$self->{'tmp_rolestate'} = -1;
	return;
}

#----------------------------------------
# プレイヤーデータの読み込み
#----------------------------------------
sub readpl {
	my ($self, $datalabel, $data) = @_;
	$self->createpl('');
	@$self{@$datalabel} = split(/<>/, $data);

	my @datalabelnew = $self->getdatalabel();
	foreach (@datalabelnew) {
		$self->{$_} = '' if ($self->{$_} eq $self->{'sow'}->{'DATATEXT_NONE'});
	}

	my $sow = $self->{'sow'};
	$self->{'delete'}  = 0;

	return;
}

#----------------------------------------
# プレイヤーデータの書き込み
#----------------------------------------
sub writepl {
	my ($self, $fh) = @_;
	my $sow = $self->{'sow'};

	my $none = $sow->{'DATATEXT_NONE'};

	my @datalabel = $self->getdatalabel();
	foreach (@datalabel) {
		$self->{$_} = $none if ($self->{$_} eq '');
	}

	print $fh join("<>", map{$self->{$_}}@datalabel). "<>\n";
	foreach (@datalabel) {
		$self->{$_} = '' if ($self->{$_} eq $none);
	}
}

sub define_delay {
	my ($self) = @_;
	my $vil = $self->{'vil'};

	# 状態確定。
	if ($self->{'delay_rolestate'} != $self->{'rolestate'}){
		$self->{'rolestate'} = $self->{'delay_rolestate'};
	}

	# 生死確定。
	if ($self->{'delay_live'} ne $self->{'live'}){
		$self->{'live'} = $self->{'delay_live'};
		if( $self->{'live'} eq 'live' ){
			$self->{'deathday'} = -1;
		} else {
			$self->{'deathday'} = $vil->{'turn'};
		}
	}
}

#----------------------------------------
# 初期投票先／能力対象の設定
#----------------------------------------
sub setTarget {
	my ($self, $targethd, $targetno, $turn, $logfile, $srctargetpno) = @_;

	my $sow = $self->{'sow'};
	my $cfg = $sow->{'cfg'};

	my $targetid = $targethd . $targetno;
	my $targetlist = $self->gettargetlist($targethd, $turn, $srctargetpno);
	if (@$targetlist == 0) {
		# 対象候補が存在しない
		$self->{$targetid} = $sow->{'TARGETID_TRUST'};
		$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, $self->getlongchrname() . "の対象($targetid)候補がありません。");
	} else {
		$self->{$targetid} = $targetlist->[int(rand(@$targetlist))]->{'pno'};
	}
}

sub setInitTarget {
	my ($self, $targethd, $targetno, $logfile, $srctargetpno) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $cfg = $sow->{'cfg'};
	$self->setTarget($targethd, $targetno, $vil->{'turn'}, $logfile, $srctargetpno);

	# 人狼、宿借、魔女はデフォルトがパス。
	# ただし、自分の役職を自覚しているときだけ。
	my $trusttarget = 0;
	if ( $self->issensible() ){
		$trusttarget = 1 if (($vil->{'turn'} > 1)&&($self->iskiller($targethd)));
		$trusttarget = 1 if (($targethd eq 'role')&&($self->{'role'} == $sow->{'ROLEID_SNATCH'   }));
		$trusttarget = 1 if (($targethd eq 'role')&&($self->{'role'} == $sow->{'ROLEID_WITCH'    }));
		$trusttarget = 1 if (($targethd eq 'role')&&($self->{'role'} == $sow->{'ROLEID_WALPURGIS'}));
	}
#	$trusttarget = 0;

	my $targetid = $targethd . $targetno;

	# 自殺投票をデフォルト設定にする場合。
	if ((1 == $cfg->{'ENABLED_SUICIDE_VOTE'})&&($vil->{'mob'} ne 'juror')){
		$trusttarget = 2 if ($targethd eq 'vote');
	}
	if ($trusttarget == 1){
		$self->{$targetid} = $sow->{'TARGETID_TRUST'}; # おまかせ
	}
	if ($trusttarget == 2){
		$self->{$targetid} = $self->{'pno'};
	}
	return;
}

#----------------------------------------
# 能力対象ランダム処理（単独）
#----------------------------------------
sub setRandomTarget {
	my ($self, $targethd, $targetno, $abi_role,$logfile, $srctargetpno) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $cfg = $sow->{'cfg'};

	my $targetid = $targethd . $targetno;

	return if (( 1 < $targetno )&&( '' eq $self->gettargetlabel($targethd,$vil->{'turn'}-1) ));
	$self->setTarget($targethd, $targetno, $vil->{'turn'}-1, $logfile, $srctargetpno);

	return if ( $self->{$targetid} == $sow->{'TARGETID_TRUST'} );
	$targetpl = $vil->getplbypno($self->{$targetid});

	# ログ書き込み
	my $ability    = $self->getlabel($targethd);
	my $targetname = $targetpl->getchrname();
	my $randomtext = $self->getText('SETRANDOMTARGET');
	$randomtext =~ s/_ABILITY_/$ability/g;
	$randomtext =~ s/_TARGET_/$targetname/g;
	$logfile->writeinfo($self->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $randomtext);

	return $targetpl;
}

#----------------------------------------
# 発言数初期化
#----------------------------------------
sub setsaycount {
	my $self   = shift;
	my $vil    = $self->{'vil'};
	my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	$self->{'tsay'}         = $saycnt->{'MAX_TSAY'};
	$self->{'wsay'}         = $saycnt->{'MAX_WSAY'};
	$self->{'spsay'}        = $saycnt->{'MAX_SPSAY'};
#	$self->{'xsay'}         = $saycnt->{'MAX_XSAY'};
	$self->{'say_act'}      = $saycnt->{'MAX_SAY_ACT'};
	$self->{'saidcount'}    = 0;
	$self->{'saidpoint'}    = 0;
	$self->{'actaddpt'}     = $saycnt->{'MAX_ADDSAY'};
	$self->{'countinfosp'}  = 0;
	$self->{'countthink'}   = 0;
	$self->{'commit'}       = 0;
	$self->{'entrust'}      = 0;
	$self->{'lastwritepos'} = -1;

	if ($vil->isepilogue() > 0) {
		$self->{'say'}      = $saycnt->{'MAX_ESAY'};
		$self->{'gsay'}     = $saycnt->{'MAX_ESAY'};
	} elsif ($vil->{'turn'} == 0) {
		$self->{'say'}      = $saycnt->{'MAX_PSAY'};
		$self->{'gsay'}     = $saycnt->{'MAX_PSAY'};
	} else {
		$self->{'say'}      = $saycnt->{'MAX_SAY'};
		$self->{'gsay'}     = $saycnt->{'MAX_GSAY'};
	}

	return;
}

#----------------------------------------
# 発言数回復
#----------------------------------------
sub chargesaycount {
	my $self   = shift;
	my $vil    = $self->{'vil'};
	my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	$self->{'tsay'}     += $saycnt->{'MAX_TSAY'};
	$self->{'wsay'}     += $saycnt->{'MAX_WSAY'};
	$self->{'spsay'}    += $saycnt->{'MAX_SPSAY'};
#	$self->{'xsay'}     += $saycnt->{'MAX_XSAY'};
	$self->{'say_act'}  += $saycnt->{'MAX_SAY_ACT'};
	$self->{'actaddpt'} += $saycnt->{'MAX_ADDSAY'};

	if ($vil->isepilogue() > 0) {
		$self->{'say'}      += $saycnt->{'MAX_ESAY'};
		$self->{'gsay'}     += $saycnt->{'MAX_ESAY'};
	} elsif ($vil->{'turn'} == 0) {
		$self->{'say'}      += $saycnt->{'MAX_PSAY'};
		$self->{'gsay'}     += $saycnt->{'MAX_PSAY'};
	} else {
		$self->{'say'}      += $saycnt->{'MAX_SAY'};
		$self->{'gsay'}     += $saycnt->{'MAX_GSAY'};
	}

	return;
}

#----------------------------------------
# 運命の絆を追加する
#----------------------------------------
sub addbondlist {
	my ($self, $target,$bonds) = @_;

	my $isbond = 0;
	my @bonds = split('/', $self->{$bonds});

	foreach(@bonds) {
		$isbond = 1 if ($_ == $target);
	}

	# 絆を追加
	if ($isbond == 0) {
		push( @bonds, $target );
		$self->{$bonds} = join('/', @bonds);
	}
}
sub addbond {
	my ($self, $target) = @_;

	$self->addbondlist($target,'bonds')
}
sub addpseudobond {
	my ($self, $target) = @_;

	$self->addbondlist($target,'pseudobonds')
}

#----------------------------------------
# 発言数を増やす（促し）
#----------------------------------------
sub addsaycount {
	my $self = shift;
	my $vil    = $self->{'vil'};
	my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	$self->{'say'}  += $saycnt->{'ADD_SAY'};
	$self->{'gsay'} += $saycnt->{'ADD_SAY'};
	return;
}

#----------------------------------------
# historyを加筆する
#----------------------------------------
sub addhistory {
	my ($self,$result) = @_;
	return if ("" eq $result);
	if ( index($self->{'history'},$result) < 0 ){
		$self->{'history'} .= $result."<br>";
	}
	return;
}

#----------------------------------------
# クローンナンバーを増やす（ZAP）
#----------------------------------------
sub zap {
	my $self = shift;
	$self->{'postfix'} -= 1;
	return;
}

#----------------------------------------
# 絆の情報取得
#----------------------------------------
sub getbondlist {
	my ($self) = @_;
	my $bonds = $self->{'bonds'};

	return  split('/', $bonds );
}
sub getpseudobondlist {
	my ($self) = @_;
	my $bonds = $self->{'pseudobonds'};

	return  split('/', $bonds );
}

sub getallbondlist {
	my ($self) = @_;
	my $bonds = $self->all_bonds_str();

	return  split('/', $bonds );
}

#----------------------------------------
# 投票／能力対象候補のリストを取得（おまかせ入り）
#----------------------------------------
sub gettargetlist {
	my ($self, $cmd, $turn, $targetpno) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $cfg = $sow->{'cfg'};

	my @bonds = $self->getallbondlist();
	my @targetlist;

	# 自覚のない場合。スイッチオンで、村側のとき。
	my $sensible = $self->issensible();

	# 新役職のため、襲撃先以外でもおまかせを認める
	my $abstain = 1;
#	$abstain = 0 if (($vil->{'debug'} == 1 ));
	# 投票にはお任せを認めない。
	$abstain = 0 if (($cmd eq 'vote'));
	$abstain = 0 if (($cmd eq 'entrust'));
	if (($cmd eq 'role')&&($turn == 1)){
	# １日目、弟子、悪戯妖精、襲撃にはお任せを認めない。
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_PASSION'}  ));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_LOVER'}    ));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_TRICKSTER'}));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_LOVEANGEL'}));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_HATEDEVIL'}));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_BITCH'}    ));
		$abstain = 0 if (($self->{'role'} == $sow->{'ROLEID_LONEWOLF'} ));
		$abstain = 0 if (($self->iskiller('role')                      ));
	}
	if (($cmd eq 'gift')){
	# ２日目以降、光の輪はお任せを認めない。
    # 魔鏡はお任せを認めない。
		$abstain = 0 if (($turn  > 1)&&($self->{'gift'} == $sow->{'GIFTID_SHIELD'}));
		$abstain = 0 if (              ($self->{'gift'} == $sow->{'GIFTID_GLASS'} ));
		$abstain = 0 if (($turn == 1)&&($self->iskiller('gift')                   ));
	}
	if ( $abstain > 0 ){
		my %target = (
			chrname => $sow->{'textrs'}->{'UNDEFTARGET'},
			pno     => $sow->{'TARGETID_TRUST'},
		);
		push(@targetlist, \%target);
	}

	# 能力使用日以外は、パス以外選べない。
	return \@targetlist if (($cmd eq 'entrust')&&($self->isEnableVote($turn) == 0));
	return \@targetlist if (($cmd eq 'vote'   )&&($self->isEnableVote($turn) == 0));
	return \@targetlist if (($cmd eq 'role'   )&&($self->isEnableRole($turn) == 0));
	return \@targetlist if (($cmd eq 'gift'   )&&($self->isEnableGift($turn) == 0));

	# 自覚のない場合、特別扱い処理はしない。
	# 少女の能力の場合
	if (($cmd eq 'role')&&(1 == $sensible)){
		return \@targetlist if ($self->isDisableState('MASKSTATE_ABI_ROLE'));
		if (($self->{'role'} == $sow->{'ROLEID_GIRL'}     )
		  ||($self->{'role'} == $sow->{'ROLEID_ALCHEMIST'})
		  ||($self->{'role'} == $sow->{'ROLEID_DISH'}     )){
			my %target = (
				chrname => '(する)',
				pno     => $self->{'pno'},
			);
			push(@targetlist, \%target);
			return \@targetlist;
		}
	}
	if (($cmd eq 'role')&&(0 == $sensible)){
		my %target = (
			chrname => '（独りになる）',
			pno     => $self->{'pno'},
		);
		push(@targetlist, \%target);
	}

	my $livepl;
	# 四月馬鹿：絆があると、絆の相手のみに投票
	# 片思いは、思われてる側が思ってる側しか選べなくなる。
	# 不具合だが、直すのを放棄中。
	if ( $vil->{'event'} == $sow->{'EVENTID_APRIL_FOOL'} ){
		my @bondpno = $self->getallbondlist();
		if ($cmd eq 'vote'){
			if ( 0 < scalar(@bondpno) ){
				foreach $pno (@bondpno) {
					$livepl = $vil->getplbypno($pno);
					my $postfix = '';
					$postfix = '(故人)' if ($livepl->{'live'} ne 'live');
					my %target = (
						chrname => $livepl->getlongchrname().$postfix,
						pno     => $pno,
					);
					push(@targetlist, \%target);
				}
				return \@targetlist;
			}
		}
	}

	my $pllist = $vil->getpllist();
	# それ以外
	foreach $livepl (@$pllist) {
		next if ($livepl->{'live'} eq 'mob');        # 見物人は能力、投票の対象ではない。
		next if ($livepl->{'live'} eq 'suddendead'); # 突然死者は能力、投票の対象ではない。
		next if ((defined($targetpno)) && ($livepl->{'pno'} == $targetpno)); # 第一対象と同じ場合は除外
		# 自覚のない場合、特別扱い処理はしない。
		if ((0 == $sensible)&&($cmd eq 'role')){
			next if ($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
			next if ($livepl->{'pno'} eq $self->{'pno'});
		} elsif ($cmd eq 'role'){
			if (($self->{'role'} == $sow->{'ROLEID_WITCH' })
			  ||($self->{'role'} == $sow->{'ROLEID_WALPURGIS' })) {
				next if ( $self->isDisableState('MASKSTATE_ABI_ROLE') );
				next if (($self->isDisableState('MASKSTATE_ABI_LIVE') )&&($livepl->{'live'} ne 'live'));
				next if (($self->isDisableState('MASKSTATE_ABI_KILL') )&&($livepl->{'live'} eq 'live'));
				next if (($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'})); # ダミーは投薬の対象にしない。
			} elsif ($self->{'role'} == $sow->{'ROLEID_TANGLE'}) {
				next if ($livepl->{'live'} eq 'live');
				next if (($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'})); # ダミーは投薬の対象にしない。
			}else{
				next if ($livepl->{'live'} ne 'live');
			}

			if (($self->{'role'} == $sow->{'ROLEID_LONEWOLF'})) {
				next if (($turn == 1) && ($livepl->{'uid'} ne $sow->{'cfg'}->{'USERID_NPC'})); # １日目の襲撃対象はダミーキャラのみ
			}
			if (($self->{'role'} == $sow->{'ROLEID_GURU'})) {
				next if ($livepl->{'sheep'} eq 'pixi'); # 勧誘済み対象は除外
			}
			if (($self->{'role'} == $sow->{'ROLEID_TRICKSTER'})
			  ||($self->{'role'} == $sow->{'ROLEID_LOVEANGEL'})
			  ||($self->{'role'} == $sow->{'ROLEID_HATEDEVIL'})) {
				# ピクシーの対象にはダミーキャラを含まない
				next if ($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
			} elsif (($self->{'role'} == $sow->{'ROLEID_BITCH' })
				   ||($self->{'role'} == $sow->{'ROLEID_TANGLE'})){
				# 遊び人、怨霊の対象にはダミー、自分自身を含まない。
				next if ($livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
				next if (($livepl->{'uid'} eq $self->{'uid'}));
			} else {
				# 以外では、対象に自分自身を含まない。
				next if (($livepl->{'uid'} eq $self->{'uid'}));
			}
		}
		if (($cmd eq 'gift')) {
			next if ($livepl->{'live'} ne 'live');
			next if (($livepl->{'uid'} eq $self->{'uid'}));
			if (($self->{'gift'} == $sow->{'GIFTID_SEERONCE'})) {
				next if ( $self->isDisableState('MASKSTATE_ABI_GIFT') );
			}
		}
		if (($cmd eq 'vote') or ($cmd eq 'entrust')) {
			next if (($vil->{'scapegoat'} > 0)
                   &&($livepl->{'pno'} != $vil->{'scapegoat'})
                   &&($self->{'pno'}   != $vil->{'scapegoat'})
                   );
			next if ( $livepl->isDisableState('MASKSTATE_VOTE_TARGET') );
			next if ( $livepl->{'live'} ne 'live');
			next if ( $livepl->{'uid'}  eq $self->{'uid'});
			# 委任の時は自分が選べたら困る。とかあるので。
			# 最も安易に、自殺票のときは選択肢に「*」をつけない。
		}

		# それが襲撃フォームなら
		if ( $self->iskiller($cmd) ) {
			next if (($turn == 1) && ($livepl->{'uid'} ne $sow->{'cfg'}->{'USERID_NPC'})); # １日目の襲撃対象はダミーキャラのみ
			my $knight = 0;
			$knight = 1	if ($vil->{'game'} eq 'TROUBLE');
			$knight = 1	if ($vil->{'game'} eq 'SECRET');
			$knight = 1 if (($cmd eq 'role')&&($self->{'role'} == $sow->{'ROLEID_HEADLESS'}));
			if (0 == $knight){
				next if ( $livepl->{'role'} == $sow->{'ROLEID_MIMICRY'}); # 擬狼妖精は除外
				next if ( $livepl->iskiller('gift'));
				next if ( $livepl->iskiller('role'));
			}
		}

		my $postfix = '';
		$postfix = '(故人)' if ($livepl->{'live'} ne 'live');
		my %target = (
			chrname => $livepl->getlongchrname().$postfix,
			pno     => $livepl->{'pno'},
		);
		push(@targetlist, \%target);
	}

	if ( 0 == scalar(@targetlist) ){
		$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, $self->getlongchrname() . "の対象候補がありません。");
		my %target = (
			chrname => $sow->{'textrs'}->{'UNDEFTARGET'},
			pno     => $sow->{'TARGETID_TRUST'},
		);
		push(@targetlist, \%target);
	}
	return \@targetlist;
}

#----------------------------------------
# 投票／能力対象候補のリストを取得
# （ランダム入り）
#----------------------------------------
sub gettargetlistwithrandom {
	my ($self, $cmd) = @_;
	my $sow  = $self->{'sow'};
	my $vil  = $self->{'vil'};
	my $turn = $self->{'vil'}->{'turn'};
	my $targetlist = $self->gettargetlist($cmd, $turn);
	my $randomtarget = @$targetlist;

	# ランダム
	$randomtarget = 0 if ($vil->{'randomtarget'} == 0); # 村設定がランダム禁止
	# 自覚のある少女のよあそびにはランダムを認めない。（意味がない）
	if (($cmd eq 'role')&&($self->issensible())){
		$randomtarget = 0 if ($self->{'role'} == $sow->{'ROLEID_GIRL'});
		$randomtarget = 0 if ($self->{'role'} == $sow->{'ROLEID_ALCHEMIST'});
		$randomtarget = 0 if ($self->{'role'} == $sow->{'ROLEID_DISH'});
	}

	# １日目の襲撃対象はダミーキャラのみ
	$randomtarget = 0 if (($self->iskiller($cmd))&&($turn == 1));
	if ($randomtarget > 0) {
		my %randomtarget = (
			chrname => $sow->{'textrs'}->{'RANDOMTARGET'},
			pno     => $sow->{'TARGETID_RANDOM'},
		);
		unshift(@$targetlist, \%randomtarget);
	}

	return $targetlist;
}

#----------------------------------------
# キャラの名前を取得する
#----------------------------------------
sub getrolename {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	my $giftname = $sow->{'textrs'}->{'GIFTNAME'}->[$self->{'gift'}];
	my $rolename = $sow->{'textrs'}->{'ROLENAME'}->[$self->{'role'}];
	$rolename = $sow->{'textrs'}->{'ROLENAME'}->[$sow->{'ROLEID_VILLAGER'}] if ($self->{'role'} == $sow->{'ROLEID_RIGHTWOLF'});
	$rolename = ''                             if (($self->issensible() == 0)||($self->{'role'} == 0));
	$rolename .= "、".$giftname  if ($self->{'gift'} > $sow->{'GIFTID_NOT_HAVE'});;
	return $rolename;
}


sub getchrname {
	my $self = shift;
	return $self->getshortchrname();
}

sub getlongchrname {
	my $self = shift;
	my $clearance = ('IR-','R-','O-','Y-','G-','B-','I-','V-','UV-')[$self->{'clearance'}] if( $self->{'postfix'} < 0  );
	return $self->{'sow'}->{'charsets'}->getchrname($self->{'csid'}, $self->{'cid'}, $self->{'jobname'}, $clearance, $self->{'postfix'});
}

sub getshortchrname {
	my $self = shift;
	my $clearance = ('IR-','R-','O-','Y-','G-','B-','I-','V-','UV-')[$self->{'clearance'}] if( $self->{'postfix'} < 0 );
	return $self->{'sow'}->{'charsets'}->getshortchrname($self->{'csid'}, $self->{'cid'}, $clearance, $self->{'postfix'});
}

sub getText {
	my ($self, $text) = @_;
	my $vil = $self->{'vil'};
	my $chrname = $self->getchrname();
	my $result  = $vil->getText($text);
	$result =~ s/_NAME_/$chrname/;

	return $result;
}

sub getTextByID {
	my ($self, $text, $id) = @_;
	my $vil = $self->{'vil'};
	my $chrname = $self->getchrname();
	my $result  = $vil->getTextByID($text,$id);
	$result =~ s/_NAME_/$chrname/;

	return $result;
}

#----------------------------------------
# 発言ボタン
#----------------------------------------
sub getsaybuttonlabel {
	my ($self, $vil, $caption_say, $caption_gsay, $buttonlabel) = @_;
	my $live = $vil->ispublic($self);
	$caption_say = $caption_gsay if ($live == 0);
	$buttonlabel =~ s/_BUTTON_/$caption_say/g;
	return $buttonlabel;
}

sub getchoice {
	my ($self, $cmd) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

    my $choice = '';
	if      ( $cmd eq 'entrust'){
		$choice = "* " if( 0 != $self->{'entrust'});
		return $choice;

	} elsif ( $cmd eq 'vote' ){
		$choice = "* " if( 0 == $self->{'entrust'});
		return $choice;
	} elsif ( $cmd eq 'role' ){
		$choice = "* ";
		return $choice ;
	} elsif ( $cmd eq 'gift' ){
		$choice = "* ";
		return $choice ;
	} else {
		return "";
	}
	return $votelabel;
}

sub getlabel {
	my ($self, $cmd) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	if      ( $cmd eq 'entrust'){
		return $sow->{'textrs'}->{'VOTELABELS'}->[1] ;

	} elsif ( $cmd eq 'vote' ){
		return $sow->{'textrs'}->{'VOTELABELS'}->[0] ;
	} elsif ( $cmd eq 'role' ){
		if ( $self->issensible() ){
			return $sow->{'textrs'}->{'ABI_ROLE'}->[$self->{'role'}] ;
		} else {
			return $sow->{'textrs'}->{'ABI_ROLE'}->[0] ;
		}
	} elsif ( $cmd eq 'gift' ){
		return $sow->{'textrs'}->{'ABI_GIFT'}->[$self->{'gift'}];
	} else {
		return "";
	}
	return $votelabel;
}

#----------------------------------------
# 2人選択能力のラベル
#----------------------------------------
sub gettargetlabel {
	my ($self, $cmd, $turn) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $abi_vote = $sow->{'textrs'}->{'VOTELABELS'};
	my $abi_role = $sow->{'textrs'}->{'ABI_ROLE'};
	my $abi_gift = $sow->{'textrs'}->{'ABI_GIFT'};

	my $targetlabel = '';

	# 投票について。
	if ($vil->{'riot'} == $turn) {
		$targetlabel = $abi_vote->[0]               if (($cmd eq 'vote'));
		$targetlabel = $abi_gift->[$self->{'gift'}] if (($cmd eq 'gift')&&($self->{'gift'} == $sow->{'GIFTID_DECIDE'} ));
	}
	if ($cmd eq 'role') {
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_TRICKSTER'} );
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_LOVEANGEL'} );
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_HATEDEVIL'} );
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_BITCH'}     );
		$targetlabel = $abi_role->[$self->{'role'}] if ( $self->{'role'} == $sow->{'ROLEID_GURU'}      );
	}
	# 襲撃フォームについて
	if (($self->iskiller($cmd))&&($vil->{'grudge'} == $turn)) {
		$targetlabel = $abi_gift->[$self->{'gift'}] if ($cmd eq 'gift');
		$targetlabel = $abi_role->[$self->{'role'}] if ($cmd eq 'role');
	}

	return $targetlabel;
}

#----------------------------------------
# 相方表示処理
#----------------------------------------
sub setfriends {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	my $sense_fm       = $vil->getrolepllist($sow->{'ROLEID_FM'});
	my $sense_sympathy = $vil->getrolepllist($sow->{'ROLEID_SYMPATHY'});
	my $sense_bat      = $vil->getrolepllist($sow->{'ROLEID_BAT'});
	my $sense_fanatic  = $vil->getrolepllist($sow->{'ROLEID_FANATIC'});
	my $sense_mob      = $vil->getmobpllist();

	# 共有者処理
	if( $self->{'role'} == $sow->{'ROLEID_FM'} ){
		$self->result_friend('RESULT_MEMBER', $sense_fm);
		$self->result_friend('RESULT_MEMBER', $sense_sympathy);
	}
	# 共鳴者処理
	if( $self->{'role'} == $sow->{'ROLEID_SYMPATHY'} ){
		$self->result_friend('RESULT_MEMBER', $sense_fm);
		$self->result_friend('RESULT_MEMBER', $sense_sympathy);
	}

	# 狂信者処理
	if( ( $self->iskiller('role')+$self->iskiller('gift') )
	  ||( $self->{'role'} == $sow->{'ROLEID_RIGHTWOLF'}   )
	  ||( $self->{'role'} == $sow->{'ROLEID_MIMICRY'}     ) ){
		$self->result_friend('RESULT_FANATIC', $sense_fanatic);
	}

	# 黒幕にむけて、全員が気配を発する。
	if($vil->{'mob'} eq 'gamemaster'){
		$self->result_friend('RESULT_SECRET', $sense_mob);
	}
}

sub result_friend {
	my ($self, $basetext, $senses) = @_;
	my $sow = $self->{'sow'};
	my $textrs = $sow->{'textrs'};
	my $rolename = $textrs->{'ROLENAME'};
	my $giftname = $textrs->{'GIFTNAME'};

	my $chrrole = $rolename->[$self->{'role'}];
	my $chrrolegift = $chrrole;
	$chrrolegift .= "、" . $giftname->[$self->{'gift'}] if ($self->{'gift'} >= $sow->{'SIDEST_DEAL'});

	my $sense;
	foreach $sense (@$senses) {
		next if ($self->{'uid'} eq $sense->{'uid'});
		next if ( $self->isDisableState('MASKSTATE_ABI_ROLE') );
		# センサー持ちはすべて役職なので、これでいい。
		my $result  = $self->getText($basetext);
		$result =~ s/_ROLE_/$chrrole/g;
		$result =~ s/_ROLEGIFT_/$chrrolegift/g;
		$sense->{'history'} .= "$result<br>";
	}
}

sub rolemessage {
	my ($self, $mes) = @_;

	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $textrs = $sow->{'textrs'};

	if ($self->{'role'} == $sow->{'ROLEID_STIGMA'}) {
		# 聖痕者処理
		my $stigma_subid = $textrs->{'STIGMA_SUBID'};
		if ($self->{'rolesubid'} >= 0) {
			my $color = $stigma_subid->[$self->{'rolesubid'}];
			$mes =~ s/_ROLESUBID_/$color/g;
		} else {
			$mes =~ s/_ROLESUBID_//g;
		}
	}
	return $vil->Tag2Text($mes);
}

sub win_if {
	my ($self) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $cfg = $sow->{'cfg'};

	my $isjuror = (('mob' eq $self->{'live'} )&&($vil->{'mob'} eq 'juror'));
	my $ismob   = (('mob' eq $self->{'live'} )&&($vil->{'mob'} ne 'juror'));

	my $winner = 'WIN_NONE';
	# 一匹狼陣営は、人狼陣営よりも優先する勝利条件
	# 一匹狼は役職なので、恩恵、恋でのさしかわりが発生する。
	# 鱗魚人は役職なので、恩恵、恋でのさしかわりが発生する。
	# 恋は感染よりも強い。一般に少ない人数になるだろう陣営を優先する。
	$winner = 'WIN_LOVER'    if ( $self->{'role'} == $sow->{'ROLEID_LOVEANGEL'} );
	$winner = 'WIN_HATER'    if ( $self->{'role'} == $sow->{'ROLEID_HATEDEVIL'} );
	$winner = 'WIN_LONEWOLF' if ( $self->{'role'} == $sow->{'ROLEID_LONEWOLF'}  );
	$winner = 'WIN_DISH'     if ( $self->{'role'} == $sow->{'ROLEID_DISH'}  );
	$winner = 'WIN_GURU'     if ( $self->{'role'} == $sow->{'ROLEID_GURU'}  );
	$winner = 'WIN_HUMAN'    if ( $self->ishuman() );
	$winner = 'WIN_EVIL'     if (($self->isenemy() )&&($cfg->{'ENABLED_AMBIDEXTER'} == 1));
	$winner = 'WIN_WOLF'     if (($self->isenemy() )&&($cfg->{'ENABLED_AMBIDEXTER'} != 1));
	$winner = 'WIN_WOLF'     if (($self->iswolf()  )&&($self->{'role'} != $sow->{'ROLEID_LONEWOLF'}));
	$winner = 'WIN_PIXI'     if ( $self->ispixi()  );
	$winner = 'WIN_WOLF'     if (('TROUBLE' eq $vil->{'game'})&&($self->isDisableState('MASKSTATE_ZOMBIE')));
	$winner = 'WIN_LOVER'    if ( $self->{'love'} eq 'love' );
	$winner = 'WIN_HATER'    if ( $self->{'love'} eq 'hate' );
	$winner = 'WIN_HUMAN'    if ( $isjuror );
	return $winner;
}

sub win_visible {
	my ($self) = @_;

	my $winner = $self->win_if();
	$winner = 'WIN_LOVER'    if ( $self->{'pseudolove'} eq 'love' );
	$winner = 'WIN_HATER'    if ( $self->{'pseudolove'} eq 'hate' );
	return $winner;
}

sub winresult {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $win_if = $self->win_if();

	my $isdeadlose = 0;
	$isdeadlose = 1 if ('LIVE_TABULA'       eq $vil->{'game'});
	$isdeadlose = 1 if ('LIVE_MILLERHOLLOW' eq $vil->{'game'});
	$isdeadlose = 1 if ('SECRET'            eq $vil->{'game'});
	$isdeadlose = 1 if (('TROUBLE'          eq $vil->{'game'})&&($win_if eq 'WIN_HUMAN'));
	$isdeadlose = 1 if (($win_if eq 'WIN_LONEWOLF'));
	$isdeadlose = 1 if (($win_if eq 'WIN_PIXI'    ));
	$isdeadlose = 1 if (($win_if eq 'WIN_HATER'   )&&( $self->{'role'} != $sow->{'ROLEID_HATEDEVIL'} ));
	my $islonelose = 0;
	$islonelose = 1 if (($win_if eq 'WIN_LOVER'   )&&( $self->{'role'} != $sow->{'ROLEID_LOVEANGEL'} ));

	my $result = '敗北';
	$result = '勝利' if (($win_if eq 'WIN_HUMAN'   )&&( $sow->{'WINNER_HUMAN'}    == $vil->{'winner'} ));
	$result = '勝利' if (($win_if eq 'WIN_WOLF'    )&&( $sow->{'WINNER_WOLF'}     == $vil->{'winner'} ));
	$result = '勝利' if (($win_if eq 'WIN_GURU'    )&&( $sow->{'WINNER_GURU'}     == $vil->{'winner'} ));
	$result = '勝利' if (($win_if eq 'WIN_PIXI'    )&&( $sow->{'WINNER_PIXI_H'}   == $vil->{'winner'} ));
	$result = '勝利' if (($win_if eq 'WIN_PIXI'    )&&( $sow->{'WINNER_PIXI_W'}   == $vil->{'winner'} ));
	$result = '勝利' if (($win_if eq 'WIN_LONEWOLF')&&( $sow->{'WINNER_LONEWOLF'} == $vil->{'winner'} ));
	$result = '勝利' if (($win_if eq 'WIN_LOVER'   )&&( $sow->{'WINNER_LOVER'}    == $vil->{'winner'} ));
	$result = '勝利' if (($win_if eq 'WIN_HATER'   )&&( $sow->{'WINNER_HATER'}    == $vil->{'winner'} ));
	$result = '勝利' if (($win_if eq 'WIN_DISH'    )&&( 'victim' eq $self->{'live'}  ));
	$result = '勝利' if (($win_if eq 'WIN_EVIL'    )&&( $sow->{'WINNER_HUMAN'}    != $vil->{'winner'} )
	                                                &&( $sow->{'WINNER_LOVER'}    != $vil->{'winner'} ));
#	           裏切り者は、邪気勝利は許容する。     &&( $sow->{'WINNER_HATER'}    != $vil->{'winner'} ));
	$result = '敗北' if (($islonelose)&&( $self->ishappy($vil) == 0 ));
	$result = '敗北' if (($isdeadlose)&&('live' ne $self->{'live'} ));
	$result = ''     if (          'suddendead' eq $self->{'live'} );
	$result = ''     if (($win_if eq 'WIN_NONE'    ));
	return $result;
}

sub winmessage {
	my ($self) = @_;
	my $sow = $self->{'sow'};
	my $winmes = $sow->{'textrs'}->{$self->win_visible()} ;
	return $winmes;
}

sub ispowerlessgrave {
	my ($self, $vil) = @_;
	my $sow = $self->{'sow'};

	my $result = 1;
	$result = 0 if ($vil->isepilogue());
	$result = 0 if ($self->{'live'} eq 'live');
	$result = 0 if ($self->{'role'} eq $sow->{'ROLEID_WALPURGIS'});
	return $result;
}

sub ischeckedday {
	my ($self,$turn,$target) = @_;
	my @eclipse = split('/', $self->{$target});
	my $check = 0;
	foreach  ( @eclipse ){
		$check = 1 if ( $_ == $turn );
	}
	return $check;
}

#----------------------------------------
# 幸福な恋人（恋の絆の先を失っていない）
#----------------------------------------
sub ishappy {
	my ($self, $vil) = @_;
	my $sow = $self->{'sow'};

	my $happy = 0;
	# 自分が恋人で、生存していたらとりあえず幸福。
	if (($self->{'love'} eq 'love')&&($self->{'live'} eq 'live')){
		$happy = 1;

		# とうとう、条件チェックでリスト取得を。。。重くないとよいが。
		my $pllist = $vil->getpllist();
		foreach $target (@$pllist) {
			# 生きている？
			next if ($target->{'live'} eq 'live');
			# 絆がない？
			my @target_bonds = $target->getbondlist();
			next if ( 0 == grep{$_ == $self->{'pno'}} @target_bonds );
			# 死んでいて、絆があるなら、その時に限り不幸です。
			$happy = 0;
		}
	}

	return $happy;
}

sub getvisiblelovestate {
	my ($self) = @_;

	my $lovestate       = $self->{'love'};
	my $pseudolovestate = $self->{'pseudolove'};

	$lovestate = $pseudolovestate if( $pseudolovestate ne '' );
	return $lovestate;
}


#----------------------------------------
# 絆が眼に見えるか
#----------------------------------------
sub all_bonds_str {
	my ($self) = @_;
	my $str = $self->{'bonds'};
	$str   .= '/' if (($self->{'bonds'} ne '')&&($self->{'pseudobonds'} ne ''));
	$str   .= $self->{'pseudobonds'};
	return $str;
}

sub getvisiblebonds {
	my ($self,$vil) = @_;
	my @pllist;

	my $self_bondlist = $self->all_bonds_str();
	if ($self_bondlist ne '') {
		my @bonds = split('/', $self_bondlist );
		foreach(@bonds) {
			my $target          = $vil->getplbypno($_);
			my $target_bondlist = $target->all_bonds_str();
			my @target_bonds    = split('/', $target_bondlist );
			# 両思いの絆だけが、目に見える。
			if ( 0 < grep{$_ == $self->{'pno'}} @target_bonds ) {
				push(@pllist, $target);
			}
		}
	}
	return \@pllist;
}

sub isvisiblebonds {
	my ($self,$vil) = @_;
	my $bonds = $self->getvisiblebonds($vil);
	return scalar(@$bonds);
}

#----------------------------------------
# その役職の特殊条件に縛られるか。
#----------------------------------------
sub isbindrole {
	my ($self,$roleid) = @_;
	my $isok = 1;
	$isok = 0 if ( $self->{'role'} != $roleid  );
	return $isok;
}
sub ishurtrole {
	my ($self,$roleid) = @_;
	my $sow = $self->{'sow'};
	my $isok = 1;
	$isok = 0 if ( $self->{'role'} != $roleid  );
	$isok = 0 if ( $self->isEnableState('MASKSTATE_HURT') );
	$isok = 0 if ( defined( $self->{'tmp_deathday'} )     );
	return $isok;
}
sub isbindgift {
	my ($self,$giftid) = @_;
	my $isok = 1;
	$isok = 0 if ( $self->{'gift'} != $giftid  );
	return $isok;
}
#----------------------------------------
# その役職能力が可能か。
#----------------------------------------

sub isactive {
	my ($self) = @_;
	my $sow = $self->{'sow'};
	my $isok = 0;

	if ($self->{'live'} eq 'live'){
		$isok = 1;
	} else {
		$isok = 1 if ($self->{'role'} == $sow->{'ROLEID_WALPURGIS'});
	}
	return $isok;
}

sub iscanrole_or_dead {
	my ($self,$roleid) = @_;
	my $sow = $self->{'sow'};

	my $isok = ($self->{'role'} == $roleid);
	$isok = 0 if ( $self->isDisableState('MASKSTATE_HURT') && ($roleid == $sow->{'ROLEID_ELDER'})    );
	$isok = 0 if ( $self->isDisableState('MASKSTATE_HURT') && ($roleid == $sow->{'ROLEID_WEREDOG'})  );
	$isok = 0 if ( $self->isDisableState('MASKSTATE_ZOMBIE') );
	$isok = 0 if ( $self->isDisableState('MASKSTATE_ABI_ROLE') );
	return $isok;
}

sub iscanrole {
	my ($self,$roleid) = @_;
	my $isok = $self->isactive();
	$isok = 0 if ( 0 == $self->iscanrole_or_dead($roleid));
	return $isok;
}

sub iscangift_or_dead {
	my ($self,$giftid) = @_;
	my $sow = $self->{'sow'};

	my $isok = ($self->{'gift'} == $giftid);
	$isok = 0 if ( $self->isDisableState('MASKSTATE_ZOMBIE') );
	$isok = 0 if ( $self->isDisableState('MASKSTATE_ABI_GIFT') );
	return $isok;
}

sub iscangift {
	my ($self,$giftid) = @_;
	my $isok = 1;
	$isok = 0 if ( 0 == $self->iscangift_or_dead($giftid));
	return $isok;
}

sub isdo {
	my ($self,$roleid) = @_;
	my $action = 1;
	$action = 0 if ($self->{$roleid}  < 0);
	$action = 0 if ($self->{$roleid} == $self->{'pno'});
	return $action;
}

#----------------------------------------
# 会話スイッチ
#----------------------------------------
sub rolesayswitch {
	my ($self,$vil,$listen) = @_;
	my $sow = $self->{'sow'};

	my $sayswitch = $sow->{'ROLESAYSWITCH'}->[$self->{'role'}];
	$sayswitch = '' if ($self->{'role'} < 1);
	return $sayswitch if ($listen);
	# しゃべる場合の条件
	$sayswitch = '' if (($sayswitch eq 'wolf')&&($vil->{'game'} eq 'SECRET'));
	$sayswitch = '' if (($sayswitch eq 'wolf')&&($vil->{'game'} eq 'TROUBLE'));
	$sayswitch = '' if  ( $self->isDisableState('MASKSTATE_ABI_ROLE') );
	return $sayswitch;
}
sub giftsayswitch {
	my ($self,$vil,$listen) = @_;
	my $sow = $self->{'sow'};

	my $sayswitch = $sow->{'GIFTSAYSWITCH'}->[$self->{'gift'}];
	$sayswitch = '' if ($self->{'gift'} < 1);
	return $sayswitch if ($listen);
	# しゃべる場合の条件
	$sayswitch = '' if (($sayswitch eq 'wolf')&&($vil->{'game'} eq 'SECRET'));
	$sayswitch = '' if (($sayswitch eq 'wolf')&&($vil->{'game'} eq 'TROUBLE'));
	$sayswitch = '' if  ( $self->isDisableState('MASKSTATE_ABI_GIFT') );
	return $sayswitch;
}


#----------------------------------------
# 少女の聞き耳
#----------------------------------------
sub isoverhear {
	my ($self,$turn) = @_;
	return $self->ischeckedday($turn,'overhear');
}

#----------------------------------------
# 呪殺されるのかどうか
#----------------------------------------
sub iscursed {
	my ($self, $cmd) = @_;
	my $sow = $self->{'sow'};

	my $iskill = 0;
	$iskill = 1 if (($cmd eq 'gift')&&( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} ));
	$iskill = 1 if (($cmd eq 'role')&&(                   $sow->{'SIDEST_PIXISIDE'} <= $self->{'role'} )
	                                &&( $self->{'role'} < $sow->{'SIDEED_PIXISIDE'} ));
	return $iskill;
}

#----------------------------------------
# 相談しての襲撃、を持つかどうか
#----------------------------------------
sub iskiller {
	my ($self, $cmd) = @_;
	my $sow = $self->{'sow'};

	my $iskill = 0;
	$iskill = 1 if (($cmd eq 'gift')&&( $self->{'gift'} == $sow->{'GIFTID_OGRE'} ));
	$iskill = 1 if (($cmd eq 'role')&&(                    $sow->{'SIDEST_WOLFSIDE'} <= $self->{'role'} )
	                                &&( $self->{'role'}  < $sow->{'SIDEED_WOLFSIDE'} ));
	return $iskill;
}

sub cankiller {
	my ($self) = @_;
	my $cankillrole = ($self->iskiller('role'))&&($self->isEnableState('MASKSTATE_ABI_ROLE'));
	my $cankillgift = ($self->iskiller('gift'))&&($self->isEnableState('MASKSTATE_ABI_GIFT'));
	return ( $cankillrole || $cankillgift );
}


sub ismediumed {
	my $self = shift;
	my $medium = 0;
	$medium = 1 if ($self->{'live'} eq 'executed');
	$medium = 1 if ($self->{'live'} eq 'suddendead');
	return $medium;
}

#----------------------------------------
# 投票に参加するのか
#----------------------------------------
sub isvoter {
	my $self = shift;
	my $sow  = $self->{'sow'};
	my $vil  = $self->{'vil'};

	# 状況による変化
#	return 0 if ($self->isDisableState('MASKSTATE_ABI_VOTE'));

	# 村の設定による変化
	my $result = 1;
	if ($vil->{'mob'} eq 'juror'){
		$result = 0 if ($self->{'live'} ne 'mob');
	}else{
		$result = 0 if ($self->{'role'} == $sow->{'ROLEID_MOB'});
		$result = 0 if ($self->{'live'} ne 'live');
	}
	return $result;
}


#----------------------------------------
# 自覚のある村側かどうかを調べる
#----------------------------------------
sub issensible {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	my $sensible = 1;
	if('WIN_HUMAN' eq $self->win_if()){
		$sensible = 0 if ('MISTERY' eq $vil->{'game'});
		$sensible = 0 if ( $self->{'gift'} == $sow->{'GIFTID_DIPSY'} );
	}

	return $sensible;
}


#----------------------------------------
# 人間かどうかを調べる
#----------------------------------------
sub ishuman {
	my $self = shift;
	my $sow = $self->{'sow'};

	return 2 if ( $self->{'gift'} == $sow->{'GIFTID_FINK'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_OGRE'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} );
	my $result = 0;
	$result = 1 if (                   $sow->{'SIDEST_HUMANSIDE'} <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_HUMANSIDE'} );
	$result = 1 if (                   $sow->{'SIDEST_ENEMY'}     <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_ENEMY'} );
	return $result;
}

#----------------------------------------
# 人狼側の人間かどうかを調べる
#----------------------------------------
sub isenemy {
	my $self = shift;
	my $sow = $self->{'sow'};

	return 2 if ( $self->{'gift'} == $sow->{'GIFTID_FINK'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_OGRE'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} );
	my $result = 0;
	$result = 1 if (                   $sow->{'SIDEST_ENEMY'} <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_ENEMY'} );
	return $result;
}

#----------------------------------------
# 人狼かどうかを調べる
#----------------------------------------
sub iswolf {
	my $self = shift;
	my $sow = $self->{'sow'};

	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FINK'}  );
	return 2 if ( $self->{'gift'} == $sow->{'GIFTID_OGRE'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} );
	my $result = 0;
	$result = 1 if (                   $sow->{'SIDEST_WOLFSIDE'} <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_WOLFSIDE'} );
	$result = 1 if ( $self->{'role'} == $sow->{'ROLEID_LONEWOLF'} );
	return $result;
}

#----------------------------------------
# 妖精かどうかを調べる
#----------------------------------------
sub ispixi {
	my $self = shift;
	my $sow = $self->{'sow'};

	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_FINK'}  );
	return 0 if ( $self->{'gift'} == $sow->{'GIFTID_OGRE'}  );
	return 2 if ( $self->{'gift'} == $sow->{'GIFTID_FAIRY'} );
	my $result = 0;
	$result = 1 if (                   $sow->{'SIDEST_PIXISIDE'} <= $self->{'role'}
	              && $self->{'role'} < $sow->{'SIDEED_PIXISIDE'} );
	return $result;
}

#----------------------------------------
# コミットするかどうか
#----------------------------------------
sub iscommitter {
	my $self = shift;
	my $result = 0;
	$result = 1 if( 'live' eq $self->{'live'} );
	$result = 1 if( $self->isvoter() );
	return $result;
}


#----------------------------------------
# 無能かどうか。
#----------------------------------------
sub textDisableAbility {
	my ($self) = @_;
	my $sow = $self->{'sow'};
	# return $self->{'live'}.' --- '.$self->{'delay_live'}.' --- '.$self->{'rolestate'}.' --- '.$self->{'delay_rolestate'}.' --- '.$self->{'tmp_rolestate'};
	return $sow->{'textrs'}->{'STATE_BIND'     } if ($self->isDisableState('MASKSTATE_ZOMBIE')  );
	return $sow->{'textrs'}->{'STATE_BIND'     } if ($self->isDisableState('MASKSTATE_ABILITY') );
	return $sow->{'textrs'}->{'STATE_BIND_GIFT'} if ($self->isDisableState('MASKSTATE_ABI_GIFT'));
	return $sow->{'textrs'}->{'STATE_BIND_ROLE'} if ($self->isDisableState('MASKSTATE_ABI_ROLE'));
	return "";
}

sub hasDisableAbility {
	my ($self) = @_;
	return 1 if ($self->isDisableState('MASKSTATE_ZOMBIE')  );
	return 1 if ($self->isDisableState('MASKSTATE_ABILITY') );
	return 1 if ($self->isDisableState('MASKSTATE_ABI_GIFT'));
	return 1 if ($self->isDisableState('MASKSTATE_ABI_ROLE'));
	return 1 if ($self->isDisableState('MASKSTATE_ABI_VOTE'));
	return 0;
}

sub isDisableState {
	my ($self,$maskstate) = @_;
	my $sow = $self->{'sow'};
	my $isD = 0;
	$isD = 1 unless ( $self->{'rolestate'}     & $sow->{$maskstate} );
	$isD = 1 unless ( $self->{'tmp_rolestate'} & $sow->{$maskstate} );
	return $isD;
}


#----------------------------------------
# 有能かどうかを調べる
#----------------------------------------
sub isEnableState {
	my ($self,$maskstate) = @_;
	my $sow = $self->{'sow'};
	my $isE = 1;
	$isE = 0 unless ( $self->{'rolestate'}     & $sow->{$maskstate});
	$isE = 0 unless ( $self->{'tmp_rolestate'} & $sow->{$maskstate});
	return $isE;
}

sub isEnableGift {
	my ($self,$turn) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $abi_gift = $sow->{'textrs'}->{'ABI_GIFT'};

	# 状況による変化
	return 0 if ($vil->isepilogue());
	return 0 if ($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'});

	# 状態による変化
	return 0 if ($self->isDisableState('MASKSTATE_ABI_GIFT'));
	return 0 if ($abi_gift->[$self->{'gift'}] eq '');
	my $result = 1;
	$result = 0 if (($self->{'gift'} == $sow->{'GIFTID_SHIELD'}) && ($turn < 2));
	$result = 0 if (($self->{'gift'} == $sow->{'GIFTID_DECIDE'}) && ($turn < 2));
	return $result;
}

sub isEnableRole {
	my ($self,$turn) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $abi_role = $sow->{'textrs'}->{'ABI_ROLE'};

	# 状況による変化
	return 0 if ($vil->isepilogue());
	return 0 if ($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'});

	# 自覚のない場合、とりあえず行動はできるが発動しないことがある。
	return 1 if (0 == $self->issensible());

	# 状態による変化
	return 0 if ($self->isDisableState('MASKSTATE_ABI_ROLE'));
	return 0 if ($abi_role->[$self->{'role'}] eq '');
	my $result = 1;
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_WALPURGIS'}) && ($self->{'live'} eq 'live'));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_WALPURGIS'}) && ($turn == 1));

	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_GIRL'}) && ($turn == 1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_WITCH'}) && ($turn == 1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_GUARD'})  && ($turn == 1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_DECIDE'})  && ($turn == 1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_PASSION'})  && ($turn >  1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_BITCH'})     && ($turn >  1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_TRICKSTER'})  && ($turn >  1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_LOVEANGEL'})   && ($turn >  1));
	$result = 0 if (($self->{'role'} == $sow->{'ROLEID_HATEDEVIL'})    && ($turn >  1));
	return $result;
}

sub isEnableVote {
	my ($self,$turn) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};

	# 状況による変化
	return 0 if ($vil->isepilogue());

	# 村の設定による変化
	my $result = $self->isvoter();
	$result = 0 if ($turn < 2 );
	return $result;
}

#----------------------------------------
# 内緒話を送ることができる？
#----------------------------------------
sub isAim {
	my ($this,$that) = @_;
	my $cfg = $this->{'sow'}->{'cfg'};
	my $vil = $this->{'vil'};
	return 0 if ($this->{'uid'} eq $that->{'uid'}); # 自分自身は除外

	my $this_is_mob  =  ($this->{'live'} eq 'mob');
	my $that_is_mob  =  ($that->{'live'} eq 'mob');
	my $this_is_live =  ($this->{'live'} eq 'live');
	my $that_is_live =  ($that->{'live'} eq 'live');
	my $this_is_dead = !($this_is_live);
	my $that_is_dead = !($that_is_live);
	if  ($cfg->{'ENABLED_MOB_AIMING'}){
		# 見物人内緒話ONなら
		# 　黒幕見物人は見物人扱い。死者扱い。生者扱い。
		# 　舞台見物人は見物人扱い。死者扱い。生者扱い。
		# 　裏方見物人は見物人扱い。死者扱い。
		# 　客席、陪審は見物人扱い。
		$this_is_live = 1 if ($this_is_mob && ($vil->{'mob'} eq 'alive'));
		$this_is_live = 1 if ($this_is_mob && ($vil->{'mob'} eq 'gamemaster'));

		$that_is_live = 1 if ($that_is_mob && ($vil->{'mob'} eq 'alive'));
		$that_is_live = 1 if ($that_is_mob && ($vil->{'mob'} eq 'gamemaster'));

		$this_is_dead = 0 if ($this_is_mob && ($vil->{'mob'} eq 'juror'));
		$this_is_dead = 0 if ($this_is_mob && ($vil->{'mob'} eq 'visiter'));

		$that_is_dead = 0 if ($that_is_mob && ($vil->{'mob'} eq 'juror'));
		$that_is_dead = 0 if ($that_is_mob && ($vil->{'mob'} eq 'visiter'));
	} else {
		# 見物人であれば生者と扱わない。死者と扱わない。見物人と扱わない。
		$this_is_live  = 0 if ($this_is_mob);
		$that_is_live  = 0 if ($that_is_mob);
		$this_is_dead  = 0 if ($this_is_mob);
		$that_is_dead  = 0 if ($that_is_mob);
		$this_is_mob   = 0;
		$that_is_mob   = 0;
	}

	my $res = 0;

	$res = 1 if ($vil->isepilogue());      # エピは完全解禁
	$res = 1 if (($this_is_live)&&($that_is_live)); # 生者の内緒話
	$res = 1 if (($this_is_dead)&&($that_is_dead)); # 死者の内緒話
	$res = 1 if (($this_is_mob )&&($that_is_mob )); # 見物人の内緒話

	return $res;
}

#----------------------------------------
# アクション対象にするか？
#----------------------------------------
sub isAction {
	my ($this,$that) = @_;
	my $cfg = $this->{'sow'}->{'cfg'};
	my $vil = $this->{'vil'};
	return 0 if ($this->{'uid'} eq $that->{'uid'}); # 自分自身は除外
	return 1 if (1 == $vil->isepilogue());
	if      ($this->{'live'} eq 'live'){
		return 1 if ($that->{'live'} eq 'live');
		return 0;
	} elsif ($this->{'live'} eq 'mob') {
		return 1;
	} else {
		return 1;
	}
}

#----------------------------------------
# 強制委任、強制投票を制御
#----------------------------------------
sub queryentrust {
	my($curpl,$sow,$vil,$query) = @_;
	if(     $curpl->setentrust($sow,$vil) == 0 ){
		$query->{'entrust'} = '' ;
	}elsif( $curpl->setvote_to($sow,$vil) == 0 ){
		$query->{'entrust'} = 'on' ;
	}
	$curpl->{'entrust'} = 0;
	$curpl->{'entrust'} = 1 if ($query->{'entrust'} ne '');
}
sub setvote_to {
	my($curpl,$sow,$vil) = @_;
	my $setvote_to = 1;
	$setvote_to = 0 if ($curpl->{'role'} == $sow->{'ROLEID_FOLLOW'});
	return $setvote_to;
}
sub setentrust {
	my($curpl,$sow,$vil) = @_;
	my $setentrust = 1;
	$setentrust = 0 if (($vil->{'entrust'} != 1));
	$setentrust = 0 if (($vil->{'mob'} eq 'juror'));
	$setentrust = 0 if (($vil->{'scapegoat'} > 0));
	$setentrust = 0 if (($vil->{'event'} == $sow->{'EVENTID_APRIL_FOOL'})&&( 0 < $curpl->getallbondlist() ));
	return $setentrust;
}

#----------------------------------------
# 発言種別の取得
#----------------------------------------
sub GetMesType {
	my($writepl, $sow, $vil) = @_;
	my ($mestype, $saytype, $pttype, $modified, $cost);
	my $query  = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	my $que    = 0;
	my $targetpl = $writepl;
	my $chrname  = '';

	# 権限のない操作を除外
	# 不能の場合、特殊発言できなくなる。
	my $wisperrole = '';
	my $wispergift = '';
	$wisperrole = $writepl->rolesayswitch($vil);
	$wispergift = $writepl->giftsayswitch($vil);

	$query->{'target'}   = -1 if (!defined($query->{'target'}));
	$query->{'admin'}    = '' if (($query->{'admin'}    ne '') && ($sow->{'uid'} ne $cfg->{'USERID_ADMIN'}));
	$query->{'maker'}    = '' if (($query->{'maker'}    ne '') && ($sow->{'uid'} ne $vil->{'makeruid'}));
	$query->{'muppet'}   = '' if (($query->{'muppet'}   ne '') && ($wisperrole ne 'muppet')   && ($wispergift ne 'muppet')   );
	$query->{'sympathy'} = '' if (($query->{'sympathy'} ne '') && ($wisperrole ne 'sympathy') && ($wispergift ne 'sympathy') );
	$query->{'wolf'}     = '' if (($query->{'wolf'}     ne '') && ($wisperrole ne 'wolf')     && ($wispergift ne 'wolf')     );
	$query->{'pixi'}     = '' if (($query->{'pixi'}     ne '') && ($wisperrole ne 'pixi')     && ($wispergift ne 'pixi')     );

	# 悪夢発生時、強制的に独り言選択。
	my $nightmare = 0;
	if (($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'})&&($query->{'admin'} eq '')&&($query->{'maker'} eq '')){
		$query->{'target'}   = $writepl->{'pno'};
		$query->{'muppet'}   = '';
		$query->{'sympathy'} = '';
		$query->{'wolf'}     = '';
		$query->{'pixi'}     = '';
		$nightmare = 1;
	}

	# 発言種類と設定値を確定
	if      ($query->{'cmd'} eq 'wrmemo') {
		if      (($query->{'admin'} ne '')) {
						# 管理人メモ
						$mestype = $sow->{'MESTYPE_ADMIN'};
						$saytype = 'admin';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif (($query->{'maker'} ne '')) {
						$mestype = $sow->{'MESTYPE_MAKER'};
						$saytype = 'maker';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif ($nightmare) {
						# 独りメモ（悪夢時のみ）
						$mestype = $sow->{'MESTYPE_TSAY'};
						$saytype = 'say_act';
						$pttype  = 'tsay';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
		} else {
			if        ($writepl->{'live'} eq 'mob') {
						# メモ貼り付け
						$mestype = $sow->{'MESTYPE_VSAY'};
						$saytype = 'say_act';
						$pttype  = 'gsay';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
			} elsif ( ($writepl->{'live'} eq 'live')||(0 < $vil->isepilogue() )){
						# 生存
				if      (($query->{'muppet'}   eq 'on')) {
						# 憑依メモ
						$mestype = $sow->{'MESTYPE_MSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$writepl = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} );
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'sympathy'} eq 'on')) {
						# 共鳴メモ
						$mestype = $sow->{'MESTYPE_SPSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'wolf'}     eq 'on')) {
						# 囁きメモ
						$mestype = $sow->{'MESTYPE_WSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'pixi'}     eq 'on')) {
						# 念話メモ
						$mestype = $sow->{'MESTYPE_XSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
				} else {
						# 通常メモ
						$mestype = $sow->{'MESTYPE_SAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
				}
			} else {
						# 死者メモ
						$mestype = $sow->{'MESTYPE_GSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_MEMO'};
						$chrname = $writepl->getlongchrname();
			}
		}
		if ($cost eq 'count') {
						# メモでの発言消費について、設定に従う。
						$pttype = 'say_act';
		}
	} elsif ($query->{'cmd'} eq 'action') {
		if      (($query->{'admin'} ne '')) {
						# 管理人act
						$mestype = $sow->{'MESTYPE_ADMIN'};
						$saytype = 'say_act';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif (($query->{'maker'} ne '')) {
						# 村建てact
						$mestype = $sow->{'MESTYPE_MAKER'};
						$saytype = 'say_act';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif ($nightmare) {
						# 独りact（悪夢時のみ）
						$mestype = $sow->{'MESTYPE_TSAY'};
						$saytype = 'say_act';
						$pttype  = 'tsay';
						$cost    = $saycnt->{'COST_ACT'};
						$chrname = $writepl->getchrname();
		} elsif ($writepl->{'live'} eq 'mob') {
						# アクション
						$mestype = $sow->{'MESTYPE_VSAY'};
						$saytype = 'say_act';
						$pttype  = 'gsay';
						$cost    = $saycnt->{'COST_ACT'};
						$chrname = $writepl->getchrname();
		} elsif ( ($writepl->{'live'} eq 'live')||( 0 < $vil->isepilogue() ) ){
						# アクション
						$mestype = $sow->{'MESTYPE_SAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_ACT'};
						$chrname = $writepl->getchrname();
		} else {
						# アクション
						$mestype = $sow->{'MESTYPE_GSAY'};
						$saytype = 'say_act';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_ACT'};;
						$chrname = $writepl->getchrname();
		}
		if ($cost eq 'count') {
						# actでの発言消費について、設定に従う。
						$pttype = 'say_act';
		}
		# ここまで読んだ。は秘密
		$mestype = $sow->{'MESTYPE_TSAY'} if ($query->{'actionno'} == -2);
	} else {
		if (0 <= $query->{'target'}) {
						$targetpl = $vil->getplbypno( $query->{'target'} ) ;
						$targetpl = $writepl if (0 == $writepl->isAim($targetpl));
		}
		if      (($query->{'admin'} ne '')) {
						# 管理人発言
						$mestype = $sow->{'MESTYPE_ADMIN'};
						$saytype = 'admin';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif (($query->{'maker'} ne '')) {
						# 村建て人発言
						$mestype = $sow->{'MESTYPE_MAKER'};
						$saytype = 'maker';
						$pttype  = 'none';
						$cost    = 'none';
						$chrname = $sow->{'charsets'}->getchrname($writepl->{'csid'}, $writepl->{'cid'});
		} elsif (0 <= $query->{'target'}) {
			if ( $writepl->{'uid'} eq $targetpl->{'uid'} ){
						# 独り言。
						$mestype = $sow->{'MESTYPE_TSAY'};
						$saytype = 'tsay';
						$pttype  = 'tsay';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  0;
						$chrname = $writepl->getlongchrname();
			} else {
						# 内緒話トーク
						$mestype = $sow->{'MESTYPE_AIM'};
						if ($writepl->{'live'} eq 'live') {
							$saytype = 'say';
							$pttype  = 'say';
						} else {
							$saytype = 'gsay';
							$pttype  = 'gsay';
						}
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$chrname = $writepl->getlongchrname()." → ".$targetpl->getlongchrname();
			}
		} else {
			if        ($writepl->{'live'} eq 'mob') {
			# 見物人
						# 見物
						$mestype = $sow->{'MESTYPE_VSAY'};
						$saytype = 'gsay';
						$pttype  = 'gsay';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$chrname = $writepl->getlongchrname();
			} elsif ( ($writepl->{'live'} eq 'live')||( 0 < $vil->isepilogue() ) ){
			# 生存
				if     (($query->{'muppet'}   eq 'on')) {
						# 憑依発言 （ダミーのptを消費）
						$mestype = $sow->{'MESTYPE_MSAY'};
						$saytype = 'say';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$writepl = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} );
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'sympathy'} eq 'on')) {
						# 共鳴
						$mestype = $sow->{'MESTYPE_SPSAY'};
						$saytype = 'spsay';
						$pttype  = 'spsay';
						$cost    = $saycnt->{'COST_SAY'};
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'wolf'}     eq 'on')) {
						# 囁き
						$mestype = $sow->{'MESTYPE_WSAY'};
						$saytype = 'wsay';
						$pttype  = 'wsay';
						$cost    = $saycnt->{'COST_SAY'};
						$chrname = $writepl->getlongchrname();
				} elsif (($query->{'pixi'}     eq 'on')) {
						# 念話
						$mestype = $sow->{'MESTYPE_XSAY'};
						$saytype = 'wsay';
						$pttype  = 'wsay';
						$cost    = $saycnt->{'COST_SAY'};
						$chrname = $writepl->getlongchrname();
				} else {
						# 発言
						$mestype = $sow->{'MESTYPE_SAY'};
						$saytype = 'say';
						$pttype  = 'say';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$chrname = $writepl->getlongchrname();
				}
			} else {
			# 死亡
						# うめき
						$mestype = $sow->{'MESTYPE_GSAY'};
						$saytype = 'gsay';
						$pttype  = 'gsay';
						$cost    = $saycnt->{'COST_SAY'};
						$que     =  1;
						$chrname = $writepl->getlongchrname();
			}
		}
	}

	$cost = 'none'  if ($vil->isfreecost());

	return ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost);
}

#----------------------------------------
# ログ閲覧権限 0:見えない 1:見える 9:制限つき
#----------------------------------------
sub isLogPermition {
	my ($self, $sow, $vil, $log, $logpermit, $isque) = @_;
	my $query = $sow->{'query'};

	my $overhear = (1 == $sow->{'cfg'}->{'ENABLED_BITTY'})?(9):(8);

	my $wisperrole = '';
	my $wispergift = '';
	$wisperrole = $self->rolesayswitch($vil,1);
	$wispergift = $self->giftsayswitch($vil,1);

	# 進行中

	if (($self->{'live'} eq 'live') || ($sow->{'cfg'}->{'ENABLED_PERMIT_DEAD'} > 0)) {
		# 少女の聞き耳
		if ($self->isoverhear($sow->{'turn'})){
			$logpermit = 8         if (                        ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'}));
			$logpermit = $overhear if (                        ($log->{'mestype'} == $sow->{'MESTYPE_WSAY'}));
			$logpermit = $overhear if (                        ($log->{'mestype'} == $sow->{'MESTYPE_XSAY'}));
			$logpermit = $overhear if (                        ($log->{'mestype'} == $sow->{'MESTYPE_SPSAY'}));
		}
		# 失われることもある聞き取り能力。
		if ( $self->isEnableState('MASKSTATE_ABI_ROLE') ) {
			# 降霊者の霊話
			$logpermit = $overhear if (($self->{'role'} == $sow->{'ROLEID_NECROMANCER'})
		                                                    && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		}
		# 降霊会
		$logpermit = $overhear if (($vil->isseance($sow->{'turn'}))
		                                                    && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		# ささやき
		$logpermit = 1 if (($wisperrole eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_WSAY'}));
		$logpermit = 1 if (($wispergift eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_WSAY'}));
		$logpermit = 1 if (($wisperrole eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'}));
		$logpermit = 1 if (($wispergift eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'}));
		# 共鳴
		$logpermit = 1 if (($wisperrole eq 'sympathy')      && ($log->{'mestype'} == $sow->{'MESTYPE_SPSAY'}));
		$logpermit = 1 if (($wispergift eq 'sympathy')      && ($log->{'mestype'} == $sow->{'MESTYPE_SPSAY'}));
		# 念話
		$logpermit = 1 if (($wisperrole eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_XSAY'}));
		$logpermit = 1 if (($wispergift eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_XSAY'}));
	}
	if      (($self->{'live'} eq 'mob')) {
		$logpermit = 1 if (                                    ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})); # 見物人
		$logpermit = 1 if (($vil->{'mob'} eq 'grave')       && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})); # 見物人から墓下が見えるのは、
		$logpermit = 1 if (($vil->{'mob'} eq 'alive')       && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})); # 舞台、裏方、黒幕のとき。
		$logpermit = 1 if (($vil->{'mob'} eq 'gamemaster')  && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})); #
		$logpermit = 1 if (($vil->{'mob'} eq 'gamemaster')  && ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'})); # 黒幕
		$logpermit = 1 if (($vil->{'mob'} eq 'gamemaster')  && ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}));   # 黒幕
	} elsif (($self->{'live'} ne 'live')) {
		$logpermit = 1 if (                                    ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})); # うめき
		$logpermit = 1 if (($vil->{'mob'} eq 'grave')       && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})); # 墓下から見物人見えるのは、裏方のとき。
	}
	# 幽界トークでの追加分
	if($vil->{'undead'}>0){
		$logpermit = 1 if (($wisperrole eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		$logpermit = 1 if (($wispergift eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		$logpermit = 1 if (($wisperrole eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		$logpermit = 1 if (($wispergift eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_GSAY'}));
		$logpermit = 1 if (($wisperrole eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
		$logpermit = 1 if (($wispergift eq 'wolf')          && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
		$logpermit = 1 if (($wisperrole eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
		$logpermit = 1 if (($wispergift eq 'pixi')          && ($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
		$logpermit = 1 if (($self->{'live'} ne 'live')      && ($log->{'mestype'} == $sow->{'MESTYPE_WSAY'}));
		$logpermit = 1 if (($self->{'live'} ne 'live')      && ($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'}));
		$logpermit = 1 if (($self->{'live'} ne 'live')      && ($log->{'mestype'} == $sow->{'MESTYPE_XSAY'}));
		# 共鳴は墓と会話できない。確定シロだから。
	}

	# キューの発言は本人のみ。ただし、ＮＰＣ発言は憑依者だけは見ることができる。
	$logpermit = 1 if (($log->{'target'} eq $self->{'uid'}));

	$logpermit = 0 if  ($log->{'mestype'} == $sow->{'MESTYPE_DELETED'});
	$logpermit = 0 if  ($isque == 1);

	$logpermit = 1 if (($log->{'uid'} eq $self->{'uid'}));

	$logpermit = 1 if ( ($wisperrole eq 'muppet'                       )
	                  &&($log->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'})
	                  &&($self->isEnableState('MASKSTATE_ABI_ROLE')    )
	                  &&($log->{'mestype'} == $sow->{'MESTYPE_MSAY'}   )
	                  );

	return $logpermit;
}
# ダミー発言と憑依者、赤ログと人狼、などの特殊ログ
# は、不具合の影響が一部の人にだけ出る。
# 切り分け時、見落とさないよう注意。
# 目安：役職系のパーミッションはログイン時のみ発生する。
# 　　　このため、ログインできなくなる、という言い方で
# 　　　アカウントが怪しくない場合、ここを疑うべき。


sub gon_potof {
	my ($pl, $vil) = @_;
	my $sow = $vil->{'sow'};
	my $cfg = $sow->{'cfg'};

    # 発言/独り言/内緒話
	my ($saycnt,$cost,$unit,$max_line,$max_size) = $vil->getsayptcosts();

	my $is_epi = $vil->isepilogue();
	my $blined = $is_epi;
	my $secret = $is_epi;
	my $showpt = $is_epi;
	$showpt = $secret = $blined = 1 if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});
	$showpt = $secret = 1 if ($pl->{'uid'} eq $sow->{'uid'});
	my $showid = $vil->{'showid'} || $secret;

	my $longchrname  = $pl->getlongchrname();
	my $shortchrname = $pl->getshortchrname();
	my $actaddpt = 0 + $pl->{'actaddpt'};
	my $selrole = 0 + $pl->{'selrole'};
	my $say   = 0 + $pl->{'say'};
	my $tsay  = 0 + $pl->{'tsay'};
	my $spsay = 0 + $pl->{'spsay'};
	my $wsay  = 0 + $pl->{'wsay'};
	my $gsay  = 0 + $pl->{'gsay'};
	my $say_act = 0 + $pl->{'say_act'};
	my $live = $pl->{'live'};
	my $turn = 0 + $sow->{'turn'};

	if(!$blined){
		$live = 'victim' if(('executed' ne $live)and('suddendead' ne $live)and('live' ne $live)and('mob' ne $live));

		my $live_from = 'live';
		$live_from = $sow->{'curpl'}->{'live'} if (defined($sow->{'curpl'}->{'live'}));
		$showpt = $vil->ispublic($pl);
		$showpt = 1 if ($live_from ne 'live');
		# 日蝕
		$showpt = 0 if ($vil->iseclipse($vil->{'turn'}));
	}

	print <<"_HTML_";
var pl = {
	"turn":    $turn,
    "pno":     $pl->{'pno'},
	"csid":    "$pl->{'csid'}",
	"face_id": "$pl->{'cid'}",
	"deathday": $pl->{'deathday'},
	"is_delete": true,

	"name":    "$shortchrname",
	"jobname": "$pl->{'jobname'}",
	"longname": "$longchrname",
	"shortname": "$shortchrname",
	"clearance": $pl->{'clearance'},
	"zapcount": $pl->{'zapcount'},
	"postfix": "$pl->{'postfix'}",

	"live": "$live",
	"bonds": [],
	"pseudobonds": [],

	"point":{},
	"say":{
		"say": $say
	}
};
_HTML_

	if ($showpt){
		if ($cost eq 'count'){
			print <<"_HTML_";
pl.point = {
	"actaddpt":  $actaddpt,
	"saidcount": $pl->{'saidcount'}
};
_HTML_
		} else {
			print <<"_HTML_";
pl.point = {
	"actaddpt":  $actaddpt,
	"saidcount": $pl->{'saidcount'},
	"saidpoint": $pl->{'saidpoint'}
};
_HTML_
		}
	}

	if ($showid ){
		print <<"_HTML_";
pl.sow_auth_id = "$pl->{'uid'}";
_HTML_
	}
	if ($secret) {
		my $win_visible = "";
		my $win_result  = $pl->winresult();
		my $role = 0 + $pl->{'role'};
		my $gift = 0 + $pl->{'gift'};

		my $is_wolf = $pl->iswolf();
		my $is_pixi = $pl->ispixi();
		my $is_voter = $pl->isvoter();
		my $is_canrole = $pl->iscanrole($pl->{'role'});
		my $is_cangift = $pl->iscangift($pl->{'gift'});
		my $is_human = $pl->ishuman();
		my $is_enemy = $pl->isenemy();
		my $is_sensible = $pl->issensible();
		my $is_committer = $pl->iscommitter();

		my $history = $pl->{'history'};
		&SWHtml::ConvertJSON(\$history);

		my $love = "";
		my $bonds = "";
		my $pseudolove = "";
		my $pseudobonds = "";
		if ($blined){
			$win_visible = $pl->win_if();
			$love = $pl->{'love'};
			$bonds = $pl->{'bonds'};
			$pseudolove = $pl->{'pseudolove'};
			$pseudobonds = $pl->{'pseudobonds'};
		} else {
			$win_visible = $pl->win_visible();
			$love = $pl->getvisiblelovestate();
			$bonds = $pl->all_bonds_str();
			$role = $sow->{'ROLEID_VILLAGER'} if ($pl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'});
			$role = 0   if (($is_sensible == 0)||($pl->{'role'} == 0));
		}
		$bonds =~ s/\//,/g;
		$pseudobonds =~ s/\//,/g;

		print <<"_HTML_";
pl.is_canrole = (0 !== $is_canrole);
pl.is_cangift = (0 !== $is_cangift);

pl.win = {
	visible: "$win_visible",
	result:  "$win_result"
};

pl.live = "$pl->{'live'}";
pl.role = giji.potof.roles($role, $gift);
pl.rolestate = $pl->{'rolestate'};
pl.select = giji.potof.select($selrole);

pl.history = "$history";
pl.sheep = "$pl->{'sheep'}";
pl.overhear = [];

pl.love = "$love";
pl.bonds = [$bonds];
pl.pseudolove = "$pseudolove";
pl.pseudobonds = [$pseudobonds];

pl.is_voter = (0 !== $is_voter);
pl.is_human = (0 !== $is_human);
pl.is_enemy = (0 !== $is_enemy);
pl.is_wolf = (0 !== $is_wolf);
pl.is_pixi = (0 !== $is_pixi);
pl.is_sensible = (0 !== $is_sensible);
pl.is_committer = (0 !== $is_committer);
pl.say = {
	"say":   $say,
	"tsay":  $tsay,
	"spsay": $spsay,
	"wsay":  $wsay,
	"gsay":  $gsay,
	"say_act": $say_act
};
pl.timer = {
	"entrieddt":    new Date(1000 * $pl->{'entrieddt'}),
	"limitentrydt": new Date(1000 * $pl->{'limitentrydt'})
};
_HTML_
	}
}

1;
