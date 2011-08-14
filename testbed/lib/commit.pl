package SWCommit;


#----------------------------------------
# 勝利判定
#----------------------------------------
sub WinnerCheckGM {
	my ($sow, $vil) = @_;
	my $pllist = $vil->getpllist();

	# 集計開始
	my $winner   = 0;
	my $humen    = 0;
	my $villager = 0;
	my $wolves   = 0;
	my $lonewolves = 0;
	my $pixies   = 0;
	my $others   = 0;
	my $sheeps   = 0;
	my $loves    = 0;
	my $hates    = 0;
	my $bonds    = 0;
	my $dishes   = 0;
	my $lives    = 0;
	my $zombies  = 0;
	$vil->{'wincnt_suddendead'} = 0;
	$vil->{'wincnt_executed'  } = 0;
	$vil->{'wincnt_cursed'    } = 0;
	$vil->{'wincnt_feared'    } = 0;
	$vil->{'wincnt_victim'    } = 0;
	$vil->{'wincnt_suicide'   } = 0;
	$vil->{'wincnt_droop'     } = 0;
	$vil->{'wincnt_zombie'    } = 0;

	foreach $plsingle (@$pllist) {
		$vil->{'wincnt_'.$plsingle->{'live'}}++;
		# 個別勝利
		if (($plsingle->{'role'} == $sow->{'ROLEID_DISH'})&&($plsingle->{'live'} eq 'victim')){
			my $targetname = $plsingle->getlongchrname();
			$dishes++;
		}
		
		# 以下、生存者のみ表示。
		next if ($plsingle->{'live'} ne 'live');
		next if ($plsingle->{'role'} == $sow->{'ROLEID_MOB'});
		next if ($plsingle->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
		$lives++;

		# ゾンビーになっていない人物のみ集計する。
		if ( $plsingle->isEnableState('MASKSTATE_ZOMBIE') ) {
			if      ($plsingle->ishuman() > 0) {
				$humen++;
				$villager++ if ($plsingle->{'role'} == $sow->{'ROLEID_VILLAGER'});
			} elsif ($plsingle->ispixi()  > 0) {
				$pixies++;
			} elsif ($plsingle->iswolf()  > 0) {
				$wolves++;
				$lonewolves++ if ($plsingle->{'role'} == $sow->{'ROLEID_LONEWOLF'});
			} else {
				$humen++;
				$others++;
			}
		} else {
			$zombies++;
		}

		# 誘われた人または、教祖であれば勧誘済み扱い。
		if ($plsingle->{'sheep'} eq 'pixi'){
			$sheeps++;
		}elsif($plsingle->{'role'} == $sow->{'ROLEID_GURU'}){
			$sheeps++;
		}
		# 片想い対応
		# 自分のために死んでくれる人リストが空の恋人がありえる。

		# 運命の絆（自分のために死んでくれる人）に引かれる者
		if ('' ne $plsingle->{'bonds'}){
			$bonds++;
		}
		# 幸福な恋人
		if ($plsingle->ishappy($vil) > 0 ){
			$loves++;
		}
		# 殺す気満々の人
		if ('hate' eq $plsingle->{'love'}){
			$hates++;
		}
	}

	$vil->{'wincnt_human'   } = $humen;
	$vil->{'wincnt_villager'} = $villager;
	$vil->{'wincnt_wolf'    } = $wolves;
	$vil->{'wincnt_lonewolf'} = $lonewolves;
	$vil->{'wincnt_pixi'    } = $pixies;
	$vil->{'wincnt_dish'    } = $dishes;
	$vil->{'wincnt_love'    } = $loves;
	$vil->{'wincnt_hate'    } = $hates;
	$vil->{'wincnt_bond'    } = $bonds;
	$vil->{'wincnt_sheep'   } = $sheeps;
	$vil->{'wincnt_live'    } = $lives;
	$vil->{'wincnt_zombie'  } = $zombies;
	# 集計ここまで

	my $win_wolf = 0;
	my $win_vil  = 0;
	# 狼の勝利条件
	$win_wolf = 1 if (($vil->{'game'} eq 'TABULA')           &&($humen <= $wolves));
	$win_wolf = 1 if (($vil->{'game'} eq 'LIVE_TABULA')      &&($humen <= $wolves));
	$win_wolf = 1 if (($vil->{'game'} eq 'TROUBLE')          &&($humen <= $wolves));
	$win_wolf = 1 if (($vil->{'game'} eq 'VOV')              &&($humen <= $wolves));
	$win_wolf = 1 if (($vil->{'game'} eq 'MISTERY')          &&(0 == $villager));
	$win_wolf = 1 if (($vil->{'game'} eq 'MILLERHOLLOW')     &&(0 == $villager));
	$win_wolf = 1 if (($vil->{'game'} eq 'LIVE_MILLERHOLLOW')&&(0 == $villager));
	# 村の勝利条件
	$win_vil  = 1 if ( 0 == $wolves );

	if ($loves == $lives) {
		# 特殊な種類の恋人勝利（恋人以外が全滅。これがないと恋人が勝利不可能になることがある。）
		$winner = $sow->{'WINNER_LOVER'};
	} elsif ( 1 == $win_vil ) {
		# 村人側勝利
		$winner = $sow->{'WINNER_HUMAN'};
	} elsif ( 1 == $win_wolf) {
		# 人狼側勝利
		$winner = $sow->{'WINNER_WOLF'};
		$winner = $sow->{'WINNER_LONEWOLF'} if( $wolves == $lonewolves );
	}

	# 勝利を横取りする連中
	# あらゆる絆は後追いする。邪気に惑った者だけが例外。
	# 恋人が勝利できなくなる可能性がある（邪気を吊らないと邪気勝利になる状況の可能性）
	# ので、邪気は自分以外の絆（邪気に限らず）を滅ぼさなくては勝てない。
	$winner = $sow->{'WINNER_PIXI_W'} if (($pixies > 0) && ($winner == $sow->{'WINNER_WOLF'}));
	$winner = $sow->{'WINNER_PIXI_W'} if (($pixies > 0) && ($winner == $sow->{'WINNER_LONEWOLF'}));
	$winner = $sow->{'WINNER_PIXI_H'} if (($pixies > 0) && ($winner == $sow->{'WINNER_HUMAN'}));
	$winner = $sow->{'WINNER_GURU'}   if (($sheeps > 0) && ($lives == $sheeps ));
	$winner = $sow->{'WINNER_HATER'}  if (($bonds == 1) && ($hates == 1) && ($winner > 0));
	$winner = $sow->{'WINNER_LOVER'}  if (($loves  > 0) && ($winner > 0));
	$winner = $sow->{'WINNER_NONE'}   if (($lives == 0));

	return $winner;
}

sub StartGM {
	my ($sow, $vil) = @_;
	my $textrs = $sow->{'textrs'};
	my $ar      = $textrs->{'ANNOUNCE_ROLE'};
	&Deployment($sow, $vil, $logfile, $score);

	# 盗賊にあまり札開示、変身の都合上、なによりも手前。
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "rolediscard".$vil->{'rolediscard'});
	my @rolediscard = split('/', $vil->{'rolediscard'});
	my $pllist  = $vil->getlivepllist();
	my $member;
	foreach $member (@$pllist) {
		if ($member->{'role'} == $sow->{'ROLEID_ROBBER'}){
			my @rolelist;
			foreach $discard (@rolediscard){
				push (@rolelist, '<b>'.$vil->getTextByID('ROLENAME',$discard).'</b>');
			}
			my $roletext = join($ar->[3], @rolelist);
			my $result = $vil->getText('RESULT_ROBBER');
			$result  =~ s/_ROLE_/$roletext/g;
			$member->addhistory($result);
		} else {
			$member->setfriends();
		}
	}

	# 聖痕者処理
	my $stigma = $vil->getrolepllist($sow->{'ROLEID_STIGMA'});
	if (@$stigma > 1) {
		my $i;
		my $loopcount = @$stigma;
		for ($i = 0; $i < $loopcount; $i++) {
			my $stigmano = int(rand(@$stigma));
			my $stigmapl = splice(@$stigma, $stigmano, 1);
			$stigmapl->{'rolesubid'} = $i;
		}
	}
}

sub MidNight{
	my ($sow, $vil, $logfile, $score, $jammtargetpl) = @_;

	# 占い・呪殺
	&Seer($sow, $vil, $logfile, $score, $jammtargetpl);

	# 魔女
	&Witch($sow, $vil, $logfile, $score, $jammtargetpl);

	# 錬金術師
	&Alchemist($sow, $vil, $logfile, $score, $jammtargetpl);
}

sub UpdateGM {
	my ($sow, $vil, $logfile) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
	my $score = SWScore->new($sow, $vil, 0);

	&Deployment($sow, $vil, $logfile, $score);

	# 突然死 なによりも手前に処理する。
	&SuddenDeath($sow, $vil, $logfile, $score ) if ($sow->{'cfg'}->{'ENABLED_SUDDENDEATH'} > 0);

	# 準備フェーズ
	&Equipment($sow, $vil, $logfile, $score );

	# 処刑
	if ($vil->{'turn'}-1 > 1){
		&Execution($sow, $vil, $logfile, $score, 1);
		&Execution($sow, $vil, $logfile, $score, 2) if ($vil->{'riot'} == $vil->{'turn'}-1 );
	}

	# 黄昏フェーズ
	&Twilight($sow, $vil, $logfile, $score ) ;

	# 護衛対象表示
	my $jammtargetpl = &WriteGuardTarget($sow, $vil, $logfile, $score, 'ROLEID_JAMMER','EXECUTEJAMM' );
	my $guardtargetpl= &WriteGuardTarget($sow, $vil, $logfile, $score, 'ROLEID_GUARD' ,'EXECUTEGUARD');

	# 光の環・魔鏡・魔女・占霊
	&ThrowGift($sow, $vil, $logfile, $score, $jammtargetpl);
	&MidNight($sow, $vil, $logfile, $score, $jammtargetpl);

	# 襲撃先決定
	my ($murderpl, $killers ,$killedpl ) = &SelectKill($sow, $vil, $logfile, $score, 1);
	my ($murderpl2,$killers2,$killedpl2) = &SelectKill($sow, $vil, $logfile, $score, 2) if ($vil->{'grudge'} == $vil->{'turn'}-1 );
        
	# 襲撃 (邪魔ーが知狼などから判定を隠すために$jammtargetplを渡す。$guardtargetplではない。）
	&Kill($sow, $vil, $logfile, $score, $murderpl , $killers,  $killedpl, $jammtargetpl);
	&Kill($sow, $vil, $logfile, $score, $murderpl2, $killers2, $killedpl2,$jammtargetpl) if ($vil->{'grudge'} == $vil->{'turn'}-1);
	&KillLoneWolf($sow, $vil, $logfile, $score);

	# 黎明フェーズ
	&Dawn($sow, $vil, $logfile, $score );
	&Snatch($sow, $vil, $logfile, $score );

	# 死亡者発見
	&Regret($sow, $vil, $logfile, $score, $jammtargetpl);

	$score->write($vil->{'turn'}-1);
	$score->close();

}

sub EventReset {
	my ($sow, $vil, $logfile) = @_;
	# 事件の終焉
	if ( $sow->{'EVENTID_UNDEF'} < $vil->{'event'} ){
		$vil->{'event'} = $sow->{'EVENTID_UNDEF'};
	}
}

sub EventGM {
	my ($sow, $vil, $logfile) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
	my $score = SWScore->new($sow, $vil, 0);

	# 翌日のための処理
	
	# 死んだスケープゴートは咎められない。
	my $scapegoatpl = $vil->getplbypno($vil->{'scapegoat'});
	if ((0 < $vil->{'scapegoat'})&&( 'live' ne $scapegoatpl->{'live'} )) {
		my $canceltext  = $vil->getText('RESULT_SCAPEGOAT');
		my $targetname  = $scapegoatpl->getchrname();
		$canceltext =~ s/_TARGET_/$targetname/g;
		$vil->{'scapegoat'} = -1;
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $canceltext);
	}

	# 生存状況の開示
	if ('MISTERY' eq $vil->{'game'}){
		my $balance = 0;
		$balance = 1 if ($vil->{'wincnt_villager'} > $vil->{'wincnt_wolf'    });
		$balance = 2 if ($vil->{'wincnt_villager'} < $vil->{'wincnt_wolf'    });
		$logfile->writeinfo('', $sow->{'MESTYPE_INFOWOLF'}, $vil->getTextByID('ANNOUNCE_LEAD',$balance));
	}

	# 事件の終焉
	if ( $sow->{'EVENTID_UNDEF'} < $vil->{'event'} ){
		if ($vil->{'event'} == $sow->{'EVENTID_APRIL_FOOL'}){
			my $livepllist = $vil->getlivepllist();
			my $eventname = $vil->getTextByID('EVENTNAME',$vil->{'event'});
			foreach $plsingle (@$livepllist) {
				$plsingle->{'rolechange'} = $plsingle->{'role'};
				$plsingle->{'rolechange'} = $sow->{'ROLEID_SEERROLE'} if ($plsingle->{'role'} == $sow->{'ROLEID_WITCH'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_WITCH'}    if ($plsingle->{'role'} == $sow->{'ROLEID_SEERROLE'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_GUARD'}    if ($plsingle->{'role'} == $sow->{'ROLEID_ELDER'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_ELDER'}    if ($plsingle->{'role'} == $sow->{'ROLEID_GUARD'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_HUNTER'}   if ($plsingle->{'role'} == $sow->{'ROLEID_GIRL'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_GIRL'}     if ($plsingle->{'role'} == $sow->{'ROLEID_HUNTER'});
			}
			foreach $plsingle (@$livepllist) {
				$plsingle->{'role'} = $plsingle->{'rolechange'};
				$score->addresult($eventname, $plsingle->getlongchrname());
			}
		}

		$event = $sow->{'EVENTID_UNDEF'};
		$event = $sow->{'EVENTID_NIGHTMARE'} if (($vil->{'event'} == $sow->{'EVENTID_CLAMOR'})&&('boo' eq $vil->{'content'}));
		$event = $sow->{'EVENTID_NIGHTMARE'} if (($vil->{'event'} == $sow->{'EVENTID_FIRE'}  )&&('boo' eq $vil->{'content'}));
		$vil->{'event'} = $event;
	}

	# 次の事件発生！
	if ( $vil->{'event'} <= $sow->{'EVENTID_UNDEF'} ){
		my @events = split('/', $vil->{'eventcard'});
		# イベントがまだ残っているなら、消費する。
		if ( 0 < scalar(@events) ){
			my $choice = splice(@events, int(rand(@events)), 1);
			$vil->{'eventcard'} = join('/', @events );
			$vil->{'event'} = $choice;
		}
	}

	# 事件処理。表示。
	if ( $sow->{'EVENTID_UNDEF'} < $vil->{'event'} ){
		my $livepllist = $vil->getlivepllist();
		my $eventtext = $vil->getTextByID('EXPLAIN_EVENT',$vil->{'event'});
		my $eventname = $vil->getTextByID('EVENTNAME'    ,$vil->{'event'});
		if ($vil->{'event'} == $sow->{'EVENTID_APRIL_FOOL'}){
			foreach $plsingle (@$livepllist) {
				$plsingle->{'rolechange'} = $plsingle->{'role'};
				$plsingle->{'rolechange'} = $sow->{'ROLEID_SEERROLE'} if ($plsingle->{'role'} == $sow->{'ROLEID_WITCH'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_WITCH'}    if ($plsingle->{'role'} == $sow->{'ROLEID_SEERROLE'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_GUARD'}    if ($plsingle->{'role'} == $sow->{'ROLEID_ELDER'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_ELDER'}    if ($plsingle->{'role'} == $sow->{'ROLEID_GUARD'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_HUNTER'}   if ($plsingle->{'role'} == $sow->{'ROLEID_GIRL'});
				$plsingle->{'rolechange'} = $sow->{'ROLEID_GIRL'}     if ($plsingle->{'role'} == $sow->{'ROLEID_HUNTER'});
			}
			foreach $plsingle (@$livepllist) {
				$plsingle->{'role'} = $plsingle->{'rolechange'};
				$score->addresult($eventname, $plsingle->getlongchrname());
			}
		}

		if ($vil->{'event'} == $sow->{'EVENTID_ECLIPSE'}){
			&addcheckedday($vil, 'eclipse', $vil->{'turn'} );
			$score->addresult($eventname, "");
		}

		if ($vil->{'event'} == $sow->{'EVENTID_SEANCE'}){
			&addcheckedday($vil, 'seance', $vil->{'turn'} );
			$score->addresult($eventname, "");
		}

		# 二重スパイ　役職系の恩恵以外は上書き候補。
		if ($vil->{'event'} == $sow->{'EVENTID_TURN_FINK'}){
			my @cleanpllist;
			foreach $plsingle (@$livepllist) {
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_FINK'});
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_OGRE'});
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_FAIRY'});
				next if ($plsingle->iskiller('role'));
				next if ($plsingle->isenemy());
				push(@cleanpllist,$plsingle);
			}
			# 恩恵なしの人がいれば、一人選ぶ。
			if ( 0 < scalar(@cleanpllist) ){
				my $plsingle = splice(@cleanpllist, int(rand(@cleanpllist)), 1);
				$plsingle->{'gift'} = $sow->{'GIFTID_FINK'};
				$plsingle->setfriends();
				$score->addresult($eventname, $plsingle->getlongchrname());
			}
		}

		# 妖精の輪　役職系の恩恵以外は上書き候補。
		if ($vil->{'event'} == $sow->{'EVENTID_TURN_FAIRY'}){
			my @cleanpllist;
			foreach $plsingle (@$livepllist) {
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_FINK'});
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_OGRE'});
				next if ($plsingle->{'gift'} == $sow->{'GIFTID_FAIRY'});
				next if ($plsingle->iscursed('role'));
				push(@cleanpllist,$plsingle);
			}
			# 恩恵なしの人がいれば、一人選ぶ。
			if ( 0 < scalar(@cleanpllist) ){
				my $plsingle = splice(@cleanpllist, int(rand(@cleanpllist)), 1);
				$plsingle->{'gift'} = $sow->{'GIFTID_FAIRY'};
				$plsingle->setfriends();
				$score->addresult($eventname, $plsingle->getlongchrname());
			}
		}
		# 奇跡　その日襲撃死した人が生き返る。ただし、能力を失う。
		if ($vil->{'event'} == $sow->{'EVENTID_MIRACLE'}){
			my $pllist = $vil->getpllist();
			foreach $plsingle (@$pllist) {
				next if ($plsingle->{'live'} ne 'victim');
				next if ($plsingle->{'deathday'} ne $vil->{'turn'});
				next if ($plsingle->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
				&heal($sow, $vil, $plsingle, $logfile);
				&toCurse($sow,$vil,$plsingle,$logfile);
				$score->addresult($eventname, $plsingle->getlongchrname());
				$plsingle->define_delay();
			}
		}

		# 決定者を再選任する。
		if ($vil->{'event'} == $sow->{'EVENTID_PROPHECY'}){
			my @selectpllist;
			my @decidepllist;
			foreach $plsingle (@$livepllist) {
				push(@selectpllist,$plsingle) if ($plsingle->{'gift'} == $sow->{'GIFTID_NOT_HAVE'});
				push(@decidepllist,$plsingle) if ($plsingle->{'gift'} == $sow->{'GIFTID_DECIDE'});
			}
			foreach $plold (@decidepllist) {
				my $plnew = splice(@selectpllist, int(rand(@selectpllist)), 1);
				$plnew->{'gift'} = $sow->{'GIFTID_DECIDE'}   if (defined($plnew->{'gift'}));
				$plold->{'gift'} = $sow->{'GIFTID_NOT_HAVE'};
				$score->addresult($eventname, $plold->getlongchrname()." ⇒ ".$plnew->getlongchrname() );
			}
		}
		
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $eventtext);
	}

	# 生存者表示
	my @livesnamelist;
	my $livepllist = $vil->getlivepllist();
	my $livescnt = @$livepllist;
	foreach $plsingle (@$livepllist) {
		push(@livesnamelist, $plsingle->getchrname());
	}
	my $livesnametext = join($vil->getTextByID('ANNOUNCE_LIVES',1), @livesnamelist);
	my $livesnametextend = $vil->getTextByID('ANNOUNCE_LIVES',2);
	$livesnametextend =~ s/_LIVES_/$livescnt/g;
	$livesnametext = $vil->getTextByID('ANNOUNCE_LIVES',0) . $livesnametext . $livesnametextend;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $livesnametext);

	$score->write($vil->{'turn'}-1);
	$score->close();
}

sub addcheckedday {
	my ($self,$target,$turn) = @_;
	my @list = split('/', $self->{$target});
	push( @list, $turn );
	$self->{$target} = join('/', @list );
}

# 対象が光の輪を保持中、失ったあと、無能、の場合は光の輪を渡さない。
sub breakGift {
	my ($sow,$vil,$logfile,$targetpl,$giftname) = @_;
	my $result = $targetpl->getText('EXECUTELOST');
	$result =~ s/_NAME_/$targetname/g;
	$result =~ s/_GIFT_/$giftname/g;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFOSP'}, $result);
}

sub breakGiftCheck {
	my ($sow,$vil,$plsingle,$logfile) = @_;

	# 贈り物があれば破壊する。
	my $has_gift = 0;
	$has_gift = $plsingle->{'gift'} if ($plsingle->{'gift'} == $sow->{'GIFTID_SHIELD'});
	$has_gift = $plsingle->{'gift'} if ($plsingle->{'gift'} == $sow->{'GIFTID_GLASS' });
	if ( $has_gift ){
		my $giftname   = $vil->getTextByID('GIFTNAME',$has_gift);
		&breakGift($sow,$vil,$logfile,$plsingle,$giftname);
	}
}

sub toCurse {
	my ($sow,$vil,$plsingle,$logfile) = @_;
	$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_CURSED'};

	&breakGiftCheck($sow,$vil,$plsingle,$logfile);
}

sub toZombie {
	my ($sow,$vil,$plsingle,$logfile) = @_;
	$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ZOMBIE'};

	&breakGiftCheck($sow,$vil,$plsingle,$logfile);
}

# 共通下準備
sub Deployment{
	my ($sow, $vil, $logfile, $score) = @_;

	# スケープゴートは投票操作に影響するのみなので、更新したらもうリセットしてよい。
	$vil->{'scapegoat'} = $sow->{'TARGETID_TRUST'};

	my $pllist = $vil->getpllist();
	foreach $plsingle (@$pllist) {
		# 死亡遅延、状態遅延サポート。
		# タイミングを整理し、名簿順メタを排除する。
		$plsingle->{'delay_rolestate'} = $plsingle->{'rolestate'};
		$plsingle->{'delay_live'}      = $plsingle->{'live'};
		# 一時的状態（この夜のみ有効な内容）をここで初期化。
		$plsingle->{'tmp_rolestate'} = $plsingle->{'rolestate'};
		$plsingle->{'tmp_suicide'}   = $sow->{'TARGETID_TRUST'};
	}
}

# 能力を使う人のための準備
sub Equipment{
	my ($sow, $vil, $logfile, $score) = @_;

	# 能力対象ランダム指定時処理
	# 決定者の能力行使前であること
	&SetRandomTarget($sow, $vil, $logfile, 'role','ABI_ROLE');
	&SetRandomTarget($sow, $vil, $logfile, 'gift','ABI_GIFT');

	my $pllist = $vil->getpllist();
	foreach $plsingle (@$pllist) {
		next if ( $plsingle->{'live'} ne 'live' ); # 死者は準備しない。
		my $chrname  = $plsingle->getchrname();
		if    ($plsingle->isdo('role1')){
			# 誰かのところへ。
			my $targetpl = $vil->getplbypno($plsingle->{'role1'});
			my $targetname = $targetpl->getchrname();
			# 魔女の投薬
			# 使う薬の種類は、操作時に誰を対象に選んでいるか、で決まる。この時点の生死を保存する。
			# （ただし、突然死は投薬時にキャンセルする。）
			if ( $plsingle->iscanrole($sow->{'ROLEID_WITCH'}) ){
				$plsingle->{'tmp_targetlive'} = $targetpl->{'live'};
				$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "target is " . $plsingle->{'tmp_targetlive'} );
			}
		}elsif($plsingle->{'role1'} == $plsingle->{'pno'}){
			# 独りになる
		}else{
			# おまかせ
		}
	}
}



#----------------------------------------
# 突然死処理
#----------------------------------------
sub SuddenDeath {
	my ($sow, $vil, $logfile, $score ) = @_;
	return if ($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'});
	return if ($vil->{'event'} == $sow->{'EVENTID_ESCAPE'});
	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	my $livepllist = $vil->getlivepllist();
	foreach $plsingle (@$livepllist) {
		next if ($plsingle->{'saidcount'} > 0); # 発言していれば除外
		&nowdead($sow, $vil, 0, $plsingle, 'suddendead',$logfile, $score, 0);

		# 突然死メッセージ出力
		my $mes = $plsingle->getText('SUDDENDEATH');
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $mes);
	}
}

#----------------------------------------
# 処刑処理
#----------------------------------------
sub Execution {
	my ($sow, $vil, $logfile, $score, $no) = @_;
	my $history;
	my $livepllist = $vil->getlivepllist();
	my $allpllist  = $vil->getallpllist();
	my $votablepl  = $vil->getvotablepl();
	my $vote = 'vote'.$no;
	my $gift = 'gift'.$no;
	my $entrust = 'temp_entrust'.$no;

	# 投票数の初期化
	my @votes;
	my $i;
	for ($i = 0; $i < @$allpllist; $i++) {
		$votes[$i] = 0;
	}

	# 突然死優先投票処理（未実装）

	# 投票指示を複製。内部使用
	foreach $plsingle (@$allpllist) {
		$plsingle->{$entrust} = $plsingle->{'entrust'};
		next unless ( $plsingle->isvoter() );

		# ランダム委任
		$plsingle->{'randomentrust'} = '';
		if (($plsingle->{$entrust} > 0) && ($plsingle->{$vote} == $sow->{'TARGETID_RANDOM'})) {
			$plsingle->{$vote} = $livepllist->[rand(@$livepllist - 1)]->{'pno'};
			$plsingle->{$vote} = $livepllist->[$#$livepllist]->{'pno'} if ($plsingle->{$vote} == $plsingle->{'pno'});
			$plsingle->{'randomentrust'} = $vil->getText('RANDOMENTRUST');
		}
	}

	# 委任投票処理
	my $curpl;
	foreach $curpl (@$allpllist) {
		next unless ( $curpl->isvoter() );
		my @entrusts;
		my $srcpl = $curpl;
		$i = 0;
		
		# 委任指示の人たちから委任先を特定。
		# また、ランダム投票の人を切り分け。
		while ($srcpl->{$entrust} > 0) {
			# 投票を他人に委任している人を配列に追加
			push(@entrusts, $srcpl);
			$i++;
			$srcpl = $vil->getplbypno($srcpl->{$vote});
			if (($i > $votablepl) || ($srcpl->{'live'} ne 'live')) {
				# 委任ループに入っている時
				# （又は委任先が死者の時）
				foreach $plentrust (@entrusts) {
					next if ($plentrust->{$entrust} <= 0);

					# 投票先をランダムに設定
					my $entrusttext = $plentrust->getTextByID('ANNOUNCE_ENTRUST',1);
					my $targetpl = $vil->getplbypno($plentrust->{$vote});
					my $targetname = $targetpl->getchrname();
					$entrusttext =~ s/_TARGET_/$targetname/g;
					$entrusttext =~ s/_RANDOM_/$plentrust->{'randomentrust'}/g;
					$logfile->writeinfo($plentrust->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $entrusttext);
					$plentrust->{$vote} = $sow->{'TARGETID_TRUST'};
					$plentrust->{$entrust} = -1;
				}
				@entrusts = ();
				last;
			}
		}

		if (@entrusts > 0) {
			# 委任している時
			my $entrust;
			my $targetname = $srcpl->getchrname();
			for ($i = 0; $i < @entrusts; $i++) {
				#	委任先を参照して、投票へ変更。
				$entrusts[$i]->{$vote} = $srcpl->{$vote};
				$entrusts[$i]->{$entrust} = 0;

				my $randomvote = 0;
				if (($entrusts[$i]->{$vote} == $entrusts[$i]->{'pno'}) || ($srcpl->{$entrust} < 0)) {
					# ランダム投票
					$randomvote = 1;
					$entrusts[$i]->{$vote} = -1;
				}

				# 委任メッセージ表示
				my $entrusttext = $entrusts[$i]->getTextByID('ANNOUNCE_ENTRUST',$randomvote);
				$entrusttext =~ s/_TARGET_/$targetname/g;
				$entrusttext =~ s/_RANDOM_/$entrusts[$i]->{'randomentrust'}/g;
				$logfile->writeinfo($entrusts[$i]->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $entrusttext);
			}
			next;
		}

	}

	# 投票結果集計＆表示
	my $votestext;
	foreach $plvote (@$allpllist) {
		if ( $plvote->isvoter() ){
			my $randomvote = '';
			if ($plvote->{$vote} < 0) {
				$plvote->{$vote} = $livepllist->[rand(@$livepllist - 1)]->{'pno'};
				if ($plvote->{$vote} == $plvote->{'pno'}) {
					$plvote->{$vote} = $livepllist->[$#$livepllist]->{'pno'};
				}
				$randomvote = $vil->getText('ANNOUNCE_RANDOMVOTE');
			}
			$votes[$plvote->{$vote}]++;

			# 各投票結果
			my $votedpl   = $vil->getplbypno($plvote->{$vote});
			my $votedname = $votedpl->getlongchrname();

			my $votetext = $plvote->getTextByID('ANNOUNCE_VOTE',0);
			$votetext    =~ s/_TARGET_/$votedname/g;
			$votetext    =~ s/_RANDOM_/$randomvote/g;
			$votestext  .=  "$votetext<br>" if ($vil->{'votetype'} eq 'sign');

			# $plvote->addhistory($votetext);
			$logfile->writeinfo($plvote->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $votetext) if ($vil->{'votetype'} ne 'sign');
		}

		next if ( $plvote->{'live'} ne 'live');
		# 決定者の能力は投票に反映。ランダム解決はこの手前で済んでいる。はず。
		if ( $plvote->iscangift($sow->{'GIFTID_DECIDE'}) ){
			next if ($plvote->{$gift} < 0);
			$votes[$plvote->{$gift}]++;

			$votedpl = $vil->getplbypno($plvote->{$gift});
			$votedname = $votedpl->getlongchrname();

			$votetext = $plvote->getTextByID('ANNOUNCE_VOTE',0);
			$votetext =~ s/_TARGET_/$votedname/g;
			$votetext =~ s/_RANDOM_//g;
			$votestext = $votestext . "$votetext<br>" if ($vil->{'votetype'} eq 'sign');
	
			$plvote->addhistory($votetext);
			$logfile->writeinfo($plvote->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $votetext) if ($vil->{'votetype'} ne 'sign');
		}

	}

	# 無記名投票の投票結果表示
	for ($i = 0; $i < @votes; $i++) {
		next if ($votes[$i] == 0);

		my $targetpl = $vil->getplbypno($i);
		my $votetext = $targetpl->getTextByID('ANNOUNCE_VOTE',1);
		$votetext =~ s/_COUNT_/$votes[$i]/g;

		$votestext = $votestext . "$votetext<br>" if ($vil->{'votetype'} ne 'sign');
	}

	# 結果は見るが、投票を無視する（かもしれない）。
	if (($vil->{'event'} == $sow->{'EVENTID_COINTOSS'})&&(1 == int(rand(2)))) {
		my $chrname  = $vil->getTextByID('EVENTNAME',$sow->{'EVENTID_COINTOSS'});
		my $votetext = $vil->getText('CANCELTARGET');

		$votetext    =~ s/_NAME_/$chrname/g;
		$votetext    =~ s/_ABILITY_/処刑/g;
		# 投票結果の出力
		$votestext = $votestext . "<br>$votetext<br>";
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $votestext);
		return;
	}

	# 最大得票数のチェック
	my $maxvote = 0;
	for ($i = 0; $i < @votes; $i++) {
		$maxvote = $votes[$i] if ($maxvote < $votes[$i]);
	}

	return if ($maxvote == 0); # 処刑候補がいない（全員突然死？）

	# 最大得票者の取得
	my @lastvote;
	for ($i = 0; $i < @votes; $i++) {
		push(@lastvote,      $i) if  ($votes[$i] == $maxvote);
	}

	return if (@lastvote == 0); # 処刑候補がいない（全員突然死？）

	# スケープゴート計上
	my @scapegoat;
	foreach $pl (@$livepllist) {
		push(@scapegoat, $pl) if ( $pl->isbindrole($sow->{'ROLEID_SCAPEGOAT'}) );
	}

	# 処刑対象の決定
	my $executepl;
	my $executetype = 'execute';
	if (@lastvote > 1){
		if (@scapegoat > 0){
			# スケープゴートがいるので、スケープゴート処刑。
			# スケープゴートが疑う者がいるなら、フラグを立てる。
			$executepl   = $scapegoat[int(rand(@scapegoat))];
			$executetype = 'scapegoat' if (($executepl->isEnableState('MASKSTATE_ABI_ROLE'))&&( -1 < $executepl->{'role1'}));
		} else {
			# タブラの場合、ランダム処刑
			# 「深い霧の夜」の場合、ランダム処刑
			# ミラーズホロウの場合、取りやめ。
			$executepl   = $vil->getplbypno( $lastvote[int(rand(@lastvote))] );
			$executetype = 'abort' if ($vil->{'game'} eq 'MILLERHOLLOW');
			$executetype = 'abort' if ($vil->{'game'} eq 'LIVE_MILLERHOLLOW');
		}
	} else {
		# 処刑候補が独りなので、粛々と処刑。
		$executepl = $vil->getplbypno($lastvote[0]);
	}
	
	my $chrname;
	my $votetext;
	if ($executetype eq 'abort') {
		# 処刑を取りやめる（ミラーズホロウ）
		$chrname  = scalar(@lastvote).'名';
		$votetext = $vil->getTextByID('ANNOUNCE_VOTE',3);
	} elsif ($executepl->{'live'} eq 'live') {
		# 処刑を実施する。
		$chrname = $executepl->getchrname();
		$score->addresult($executetype,$chrname );
		if ($vil->{'event'} == $sow->{'EVENTID_ESCAPE'}){
			# 処刑ではなく、逃走。
		} elsif ( $executepl->iscanrole($sow->{'ROLEID_PRINCE'}) ){
			# 王子様は恐れ多くも一度だけ処刑されない。
			my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_PRINCE'});
			$score->addresult($scorehead,$chrname );

			$votetext = $vil->getTextByID('ANNOUNCE_VOTE',3);
			$executepl->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_NOROLE'};
		} else {
			if ($executetype eq 'scapegoat'){
				# 次のスケープゴートを指さす
				$votetext = $vil->getTextByID('ANNOUNCE_VOTE',4);
				my $targetpl = $vil->getplbypno($executepl->{'role1'});
				my $targetname = $targetpl->getchrname();
				$votetext =~ s/_TARGET_/$targetname/g;
				$vil->{'scapegoat'} = $targetpl->{'pno'};

				my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_SCAPEGOAT'});
				$score->addresult($scorehead,$targetname );
			} else {
				$votetext = $vil->getTextByID('ANNOUNCE_VOTE',2);
			}
			&nowdead($sow, $vil, 0, $executepl, 'executed',$logfile, $score, 0);
		}
	}

	$votetext  =~ s/_NAME_/$chrname/g;
	$votestext .= "<br>$votetext";
	# 投票結果の出力
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $votestext);
}

sub ShootLink {
	my ($sow, $vil, $logfile, $score, $plsingle, $roleid ) = @_;

	# 悪戯妖精（必ず打つ）
	if ( $plsingle->{'role'} == $roleid ){
		return if (($plsingle->{'role1'} < 0)&&($plsingle->{'role2'} < 0)); # おまかせは除外
		# 絆の追加
		# 陰謀11 絆の名前がない（$chrname未宣言）
		my $targetpl  = $vil->getplbypno($plsingle->{'role1'});
		my $target2pl = $vil->getplbypno($plsingle->{'role2'});
		my $message   = '';

		if ($targetpl->{'live'} ne 'live') {
			# 設定対象１が突然死している時
			my $srctargetpno;
			$srctargetpno = $plsingle->{'role2'} if (($plsingle->{'role2'} >= 0) && ($target2pl->{'live'} eq 'live'));
			$targetpl  = $plsingle->setRandomTarget('role',1, 'ABI_ROLE',$logfile, $srctargetpno);
		}

		if ($target2pl->{'live'} ne 'live') {
			# 設定対象２が突然死している時
			$target2pl = $plsingle->setRandomTarget('role',2, 'ABI_ROLE',$logfile, $plsingle->{'role1'});
		}

		if (($plsingle->{'role1'} < 0) || ($plsingle->{'role2'} < 0)) {
			# 対象候補が存在しない
			my $ability = $vil->getTextByID('ABI_ROLE',$plsingle->{'role'});
			my $canceltarget = $plsingle->getText('CANCELTARGET');
			$canceltarget =~ s/_ABILITY_/$ability/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $canceltarget);
			return;
		}

		if($plsingle->{'role'} == $sow->{'ROLEID_BITCH'}){
			$plsingle->{'love'} = 'love';
			$plsingle->addbond($plsingle->{'role1'});
			$plsingle ->addpseudobond($plsingle->{'role2'});
			$targetpl->{'love'} = 'love';
			$targetpl->addbond($plsingle->{'pno'});
			$target2pl->{'pseudolove'} = 'love';
			$target2pl->addpseudobond($plsingle->{'pno'});
			$message = 'BITCH';
		} else {
			$target2pl->addbond($plsingle->{'role1'});
			$targetpl->addbond($plsingle->{'role2'});
			$message = 'TRICKSTER';
			if($plsingle->{'role'} == $sow->{'ROLEID_LOVEANGEL'}){
				$targetpl->{'love'} = 'love';
				$target2pl->{'love'} = 'love';
			}
			if($plsingle->{'role'} == $sow->{'ROLEID_HATEDEVIL'}){
				$targetpl->{'love'} = 'hate';
				$target2pl->{'love'} = 'hate';
			}
		}

		my $result = $plsingle->getText('EXECUTE'.$message);
		my $targetname = $targetpl->getchrname();
		my $target2name = $target2pl->getchrname();
		$result =~ s/_TARGET1_/$targetname/g;
		$result =~ s/_TARGET2_/$target2name/g;
		$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
		$result = $vil->getText('RESULT_'.$message);
		$result =~ s/_TARGET1_/$targetname/g;
		$result =~ s/_TARGET2_/$target2name/g;
		$plsingle->addhistory($result);

		my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_TRICKSTER'});
		$score->addresult($scorehead,$targetname );
		$score->addresult($scorehead,$target2name );
	}
}

sub Twilight {
	my ($sow, $vil, $logfile, $score ) = @_;

	my $livepllist = $vil->getlivepllist();
	my $pllist     = $vil->getpllist();

	foreach $plsingle (@$livepllist) {
		next if ($plsingle->issensible());
		if     ($plsingle->{'role1'} == $plsingle->{'pno'}){
			# 独りになる
			my $execute = $plsingle->getText('EXECUTEALONE');
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $execute);
		} elsif($plsingle->isdo('role1')) {
			# 誰かのところへ。
			my $targetpl = $vil->getplbypno($plsingle->{'role1'});
			my $targetname = $targetpl->getchrname();
			my $execute = $plsingle->getText('EXECUTEGOTO');
			$execute =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $execute);
		} else {
			# おまかせ
		}
	}

	# 盗賊はあまり札に変身するため、何よりも手前に扱う。
	foreach $plsingle (@$livepllist) {
		my $chrname  = $plsingle->getchrname();
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		
		# 盗賊の変身（必ず変身する）
		if ($plsingle->{'role'} == $sow->{'ROLEID_ROBBER'}){
			my @rolediscard = split('/', $vil->{'rolediscard'});
			do {
				my $choice = splice(@rolediscard, int(rand(@rolediscard)), 1);
				# 盗賊が盗賊を引く場合、もう一度（盗賊は余らないので、ありえない）
				next if ($choice == $sow->{'ROLEID_ROBBER'});
				$plsingle->{'role'} = $choice;
				# 選択によって勝負が終わってしまい、カードが残っているなら引きなおす。
			} while ((0 < scalar(@rolediscard))&&(0 < &WinnerCheckGM($sow,$vil)));
			@rolediscard = split('/', $vil->{'rolediscard'});
			# 実際に選んだカードを一枚抜く。
			my $count;
			for ($count = scalar(@rolediscard)-1; ( $count >= 0 )&&($plsingle->{'role'} != $rolediscard[$count] ); $count--){}
			splice(@rolediscard, $count, 1);
			$vil->{'rolediscard'} = join('/', @rolediscard );

			# ランダムで能力行使
			$plsingle->setRandomTarget('role',1, 'ABI_ROLE',$logfile, -1);
			$plsingle->setRandomTarget('role',2, 'ABI_ROLE',$logfile, $plsingle->{'role1'});
			$plsingle->setfriends();

			my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_ROBBER'});
			my $scorebody = $vil->getTextByID('ROLENAME',$plsingle->{'role'});
			$score->addresult($scorehead,$scorebody );
		}
	}

	# （深い霧）村人同士がお互いに向かうと、結社を結ぶ。
	# いったんボツにする。
	if ($vil->{'game'} eq '--MISTERY--'){
		foreach $pl1 (@$livepllist) {
			next if ($pl1->{'role1'} < 1);
			next if ($pl1->{'role1'} < 1);
			my $pl2 = $vil->getplbypno($pl1->{'role1'});
			next if ($pl1->{'pno'}  != $pl2->{'role1'});
			next if ($pl1->{'pno'}  == $pl2->{'pno'});
			next if ($pl1->{'role'} != $sow->{'ROLEID_VILLAGER'});
			next if ($pl2->{'role'} != $sow->{'ROLEID_VILLAGER'});

			# 結社化発動！
			$pl1->{'role'} = $sow->{'ROLEID_FM'};
			$pl2->{'role'} = $sow->{'ROLEID_FM'};
			$pl1->setfriends();
			$pl2->setfriends();
		}
	}
	
	# 入門には連鎖があるため、盗賊より後に扱う。
	foreach $plsingle (@$livepllist) {
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		
		# 入門（必ず入門する）。
		if ($plsingle->{'role'} == $sow->{'ROLEID_LOVER'}){
			$targetpl->addbond($plsingle->{'pno'});
			$plsingle->addbond($plsingle->{'role1'});
			my $targetname = $targetpl->getchrname();
			# 絆を結んだ表示
			my $result = $plsingle->getText('EXECUTELOVER');
			$result =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
			# 入門
			$result = $vil->getText('RESULT_LOVER');
			$result =~ s/_TARGET_/$targetname/g;
			$plsingle->addhistory($result);

			$result = $plsingle->getText('RESULT_LOVEE');
			$targetpl->addhistory($result);
			# 変身の解決。弟子が弟子を指している場合、その先を辿る。
			my $loopcount = 0;
			do {
				$plsingle->{'role'} = $targetpl->{'role'};

				$loopcount++;
				if ($loopcount < @$livepllist) {
					# 通常は、選択先の選択先に注目
					$targetpl = $vil->getplbypno($targetpl->{'role1'});
				} else {
					# ループに入ってる時はランダムに設定
					$targetpl = $livepllist->[int(rand(@$livepllist))];
				}
			} while ($plsingle->{'role'} == $sow->{'ROLEID_LOVER'});

			# ランダムで能力行使
			$plsingle->setRandomTarget('role',1, 'ABI_ROLE',$logfile, -1);
			$plsingle->setRandomTarget('role',2, 'ABI_ROLE',$logfile, $plsingle->{'role1'});
			$plsingle->setfriends();

			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_LOVER'});
			$score->addresult($scorehead,$targetname );
		}
	}
	foreach $plsingle (@$livepllist) {
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		
		# 少女の夜遊び
		if ( $plsingle->iscanrole($sow->{'ROLEID_GIRL'}) ){
			next if ( $plsingle->{'role1'} != $plsingle->{'pno'} ); # 独りにならないとだめ

			&addcheckedday($plsingle, 'overhear', $vil->{'turn'} - 1 );
			# 夜遊び表示
			my $result = $plsingle->getText('EXECUTEGIRL');
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_GIRL'});
			$score->addresult($scorehead,$chrname );
		}

		# 手負いの人犬は死ぬ。
		if ( $plsingle->ishurtrole($sow->{'ROLEID_WEREDOG'}) ) {
			&dead($sow, $vil, 0, $plsingle,'victim', $logfile, $score, 0);
		}

		# 笛吹き
		if ( $plsingle->iscanrole($sow->{'ROLEID_GURU'}) ){
			next if (($plsingle->{'role1'} < 0)&&($plsingle->{'role2'} < 0)); # おまかせは除外
			my $targetname = '';

			if ( -1 < $plsingle->{'role1'}){
				$targetname = '<b>'.$targetpl->getchrname().'</b>';
				$targetpl->{'sheep'}  = 'pixi';
			}
			if ( -1 < $plsingle->{'role2'}) {
				my $target2pl = $vil->getplbypno($plsingle->{'role2'});
				my $target2name = '<b>'.$target2pl->getchrname().'</b>';
				$targetname .= 'と' if ($targetname ne '');
				$targetname .= $target2name;
				$target2pl->{'sheep'} = 'pixi';
			}

			next if ($targetname eq '');
			my $result = $plsingle->getText('EXECUTEGURU');
			$result =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
			$result = $vil->getText('RESULT_GURU');
			$result =~ s/_TARGET_/$targetname/g;
			$plsingle->addhistory($result);

			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_GURU'});
			$score->addresult($scorehead,$targetname );
		}
	}

	# 悪戯妖精（必ず打つ）
	foreach $plsingle (@$livepllist) {
		&ShootLink($sow, $vil, $logfile, $score, $plsingle, $sow->{'ROLEID_TRICKSTER'} );
	}
	# 邪気悪魔（必ず打つ）
	foreach $plsingle (@$livepllist) {
		&ShootLink($sow, $vil, $logfile, $score, $plsingle, $sow->{'ROLEID_HATEDEVIL'} );
	}
	# 恋愛天使（必ず打つ）
	foreach $plsingle (@$livepllist) {
		&ShootLink($sow, $vil, $logfile, $score, $plsingle, $sow->{'ROLEID_LOVEANGEL'} );
	}
	# 悪女（必ず打つ）
	foreach $plsingle (@$livepllist) {
		&ShootLink($sow, $vil, $logfile, $score, $plsingle, $sow->{'ROLEID_BITCH'}     );
	}
	# 片想い
	foreach $plsingle (@$livepllist) {
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		
		if ($plsingle->{'role'} == $sow->{'ROLEID_PASSION'}){
			next if (1 != $plsingle->isdo('role1')); # おまかせは除外
			$targetpl->addbond($plsingle->{'pno'});
			$plsingle->{'love'} = 'love';

			my $targetname = $targetpl->getchrname();
			# 絆を結んだ表示
			my $result = $plsingle->getText('EXECUTELOVER');
			$result =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);

			$result = $vil->getText('RESULT_LOVER');
			$result =~ s/_TARGET_/$targetname/g;
			$plsingle->addhistory($result);

			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_LOVER'});
			$score->addresult($scorehead,$targetname );
		}
	}
}

sub ThrowGift {
	my ($sow, $vil, $logfile, $score, $jammed) = @_;
	my $livepllist = $vil->getlivepllist();
	my $pllist     = $vil->getpllist();
	foreach $plsingle (@$livepllist) {
		next if (1 != $plsingle->isdo('gift1')); # おまかせは除外
		my $targetpl = $vil->getplbypno($plsingle->{'gift1'});
		
		# 贈り物をなげる（必ず）
		my $throw_gift = 0;
		$throw_gift = $plsingle->{'gift'} if ($plsingle->{'gift'} == $sow->{'GIFTID_SHIELD'});
		$throw_gift = $plsingle->{'gift'} if ($plsingle->{'gift'} == $sow->{'GIFTID_GLASS' });
		if ( 0 < $throw_gift ){
			$plsingle->{'gift'} = $sow->{'GIFTID_LOST'};

			my $result     = $plsingle->getText('EXECUTETHROW');
			my $targetname = $targetpl->getchrname();
			my $giftname   = $vil->getTextByID('GIFTNAME',$throw_gift);
			$result =~ s/_TARGET_/$targetname/g;
			$result =~ s/_GIFT_/$giftname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
			$result = $vil->getText('RESULT_THROW');
			$result =~ s/_TARGET_/$targetname/g;
			$result =~ s/_GIFT_/$giftname/g;

			my $scorehead = $vil->getTextByID('ABI_GIFT',$throw_gift);
			$score->addresult($scorehead,$targetname );

			# 破壊するかどうかを問う前に処理し、処理順メタを排する。
			# 魔鏡を渡すときは、占い結果を得る。
			if ($throw_gift == $sow->{'GIFTID_GLASS' } ){
				my $seerresultrole = GetResultSeer($sow, $vil, $score, $targetpl, $jammed);
				&SeerEffect($sow, $vil, $plsingle, $targetpl, $result.$seerresultrole, $logfile, $score, $jammed);
			} else {
				$plsingle->addhistory($result); 
			}

			# 対象が贈り物を保持中、失ったあと、無能、の場合は贈り物を壊す。
			my $target_gift = 0;
			$target_gift = 1 if($targetpl->isDisableState('MASKSTATE_ABI_GIFT'));
			$target_gift = $targetpl->{'gift'} if($targetpl->{'gift'} == $sow->{'GIFTID_SHIELD'});
			$target_gift = $targetpl->{'gift'} if($targetpl->{'gift'} == $sow->{'GIFTID_GLASS' });
			$target_gift = $targetpl->{'gift'} if($targetpl->{'gift'} == $sow->{'GIFTID_LOST'  });
			if ( 0 < $target_gift ){
				&breakGift($sow,$vil,$logfile,$targetpl,$giftname);
				next;
			}
			
			$targetpl->{'gift_tmp'} = $throw_gift;
		}
	}
	# 光の輪を受け取る
	foreach $plsingle (@$livepllist) {
		$plsingle->{'gift'} = $sow->{'GIFTID_SHIELD'} if ($plsingle->{'gift_tmp'} == $sow->{'GIFTID_SHIELD'});
		$plsingle->{'gift'} = $sow->{'GIFTID_GLASS' } if ($plsingle->{'gift_tmp'} == $sow->{'GIFTID_GLASS' });
		$plsingle->{'gift_tmp'} = 0;
	}
}

sub SelectKill {
	my ($sow, $vil, $logfile, $score, $no) = @_;

	my $pllist = $vil->getpllist();
	my $livepllist = $vil->getlivepllist();
	my $targetpl; # 襲撃対象

	# 投票数の初期化
	my @votes;
	my $i;
	for ($i = 0; $i < @$pllist; $i++) {
		$votes[$i] = 0;
	}

	# 襲撃先集計 襲撃フォームの数だけおこなう。
	my @cmdlist = ('role','gift');
	foreach $cmd (@cmdlist) {
		foreach $plsingle (@$livepllist) {
			next unless ( $plsingle->iskiller($cmd) );
			my $target = $cmd.$no;
			$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "KillTarget: $plsingle->{'uid'}($plsingle->{'pno'})=$plsingle->{$target}");

			next unless ($plsingle->isdo($target)); # おまかせは除外
			my $targetpl   = $vil->getplbypno($plsingle->{$target});
			# 少女は、人狼にひとにらみされるだけで死ぬ
			if (($targetpl->{'live'} eq 'live') && ($targetpl->isbindrole($sow->{'ROLEID_GIRL'})) ) {
				if ($targetpl->{'role1'} != $sow->{'TARGETID_TRUST'}){
					&dead($sow, $vil, $plsingle, $targetpl, 'feared', $logfile, $score, 0);

					my $result = $targetpl->getText('EXECUTEGIRLFEAR');
					$logfile->writeinfo('', $sow->{'MESTYPE_INFOSP'}, $result);
					next;
				}
			}
			$votes[$plsingle->{$target}] += 1;
			# 深い霧の夜（と、酔っぱらい）は、狙われると不審な人影を見る。
			if (! $targetpl->issensible()){
				my $murdername = $plsingle->getchrname();
				my $votetext = $vil->getText('RESULT_ENCOUNT');
				$votetext =~ s/_TARGET_/$murdername/g;
				$targetpl->addhistory($votetext);
			}
		}
	}

	# 最大得票数のチェック
	my $murderpl;
	my $maxvote = 0;
	for ($i = 0; $i < @votes; $i++) {
		$maxvote = $votes[$i] if ($maxvote < $votes[$i]);

		# 無記名投票風に投票結果集計
		next if ($votes[$i] == 0);
		next if ($vil->{'game'} ne 'TROUBLE');
		my $targetpl = $vil->getplbypno($i);
		my $votetext = $targetpl->getTextByID('ANNOUNCE_SELECTKILL',1);
		$votetext =~ s/_COUNT_/$votes[$i]/g;

		$logfile->writeinfo($targetpl->{'uid'}, $sow->{'MESTYPE_INFOWOLF'}, $votetext);
	}

	if ($maxvote > 0) { # 全員お任せでない場合
		# 襲撃先候補の取得
		my @lastvote;
		for ($i = 0; $i < @votes; $i++) {
			push(@lastvote, $i) if ($votes[$i] == $maxvote);
		}
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "KillTarget(All): @lastvote");

		# 襲撃対象の決定
		my $killtarget = $lastvote[int(rand(@lastvote))];
		$targetpl = $vil->getplbypno($killtarget);
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "Final KillTarget: $targetname");

		# 襲撃者決定 投票フォームの数だけ参加する
		my @murders;
		my @cmdlist = ('role','gift');
		foreach $cmd (@cmdlist) {
			foreach $plsingle (@$livepllist) {
				next if ( 0 == $plsingle->iskiller($cmd) );
				my $target = $cmd.$no;
				next if ($plsingle->{$target} != $killtarget); # 襲撃決定者に投票していない者は除外
				push(@murders, $plsingle);
			}
		}
		$murderpl = $murders[int(rand(@murders))];

		# 感染者による威力追加 たぶん、不要。
#		foreach $plsingle (@$livepllist) {
#			$maxvote ++ if ( $self->isDisableState('MASKSTATE_ZOMBIE') );
#		}

		# 襲撃メッセージ生成
		if (($vil->{'turn'}-1 > 1) && ($targetpl->{'live'} eq 'live')) {
			# ダミーキャラ襲撃時は除外する

			# 襲撃メッセージ
			my $targetname = $targetpl->getchrname();

			if (!defined($murderpl->{'uid'})) {
				# 襲撃者が未定義（ありえないはず）
				$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, "murderpl is undef.");
			} elsif ($vil->{'game'} eq 'TROUBLE'){
				# 無記名投票風に投票結果表示
				my $votetext = $targetpl->getTextByID('ANNOUNCE_SELECTKILL',2);
				# 投票結果の出力
				$logfile->writeinfo($targetpl->{'uid'}, $sow->{'MESTYPE_INFOWOLF'}, $votetext);
			} else {
				# 襲撃メッセージ書き込み
				&postKillMessage($murderpl,$targetname,$logfile,'MESTYPE_WSAY');
			}
		}
		my $scorehead = $vil->getTextByID('ABI_ROLE',$murderpl->{'role'});
		$score->addresult($scorehead,$targetname );
	}

	return $murderpl,$maxvote,$targetpl;
}

sub WriteGuardTarget {
	my ($sow, $vil, $logfile, $score, $rolename, $execute) = @_;
	my $livepllist = $vil->getlivepllist();
	my @guardtargetpl;
	foreach $plsingle (@$livepllist) {
		next unless ( $plsingle->iscanrole($sow->{$rolename})); # 狩人以外は除外
		next unless ( $plsingle->isdo('role1') ); # おまかせは除外

		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		my $targetname = $targetpl->getchrname();
		if ($plsingle->issensible()){
			my $guardtext  = $plsingle->getText($execute);
			$guardtext =~ s/_TARGET_/$targetname/g;
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $guardtext);
		}
		push(@guardtargetpl, $targetpl);
		my $scorehead = $vil->getTextByID('ABI_ROLE',$plsingle->{'role'});
		$score->addresult($scorehead,$targetname );
	}

	return \@guardtargetpl;
}

sub Kill {
	my ($sow, $vil, $logfile, $score, $murderpl, $killers, $targetpl, $jammed) = @_;

	if ((defined($targetpl->{'cid'})) && ($targetpl->{'live'} eq 'live')) {
		my $deadflag = &CheckKill($sow, $vil, $logfile, $score, $murderpl, $killers, $targetpl);
		if ($deadflag ne 'live') {
			
			if ($vil->{'event'} == $sow->{'EVENTID_GHOST'}) {
				$targetpl->{'role'}      = $sow->{'ROLEID_WOLF'};
				$targetpl->addhistory($vil->getText('RESULT_SEMIWOLF'));
				$targetpl->setfriends();
				$targetpl = $murderpl; # 襲撃対象＝襲撃者。という扱いで殺される。
			}
			&dead($sow, $vil, $murderpl, $targetpl, $deadflag, $logfile, $score);

			# 襲撃結果追記
			my $livepllist = $vil->getlivepllist();
			foreach $plsingle (@$livepllist) {
				next unless (  $plsingle->cankiller() );
				my $result_kill;
				if( 'zombie' eq $deadflag ){
					$result_kill= $vil->getText('RESULT_ZOMBIE');
				} else {
					$result_kill= $vil->getText('RESULT_KILL');
				}
				my $targetname = $targetpl->getchrname();
				my $seerresult = '';
				$seerresult = GetResultAura($sow, $vil, $score, $targetpl, $jammed) if ($plsingle->{'role'} == $sow->{'ROLEID_AURAWOLF'});
				$seerresult = GetResultRole($sow, $vil, $score, $targetpl, $jammed) if ($plsingle->{'role'} == $sow->{'ROLEID_INTWOLF'});
				$result_kill =~ s/_TARGET_/$targetname/g;
				$result_kill .= $seerresult;
				$plsingle->addhistory($result_kill);
			}
		}
	}
}

sub KillLoneWolf {
	my ($sow, $vil, $logfile, $score) = @_;
	my $livepllist = $vil->getlivepllist();

	# 一匹狼の襲撃を別処理
	foreach $murderpl (@$livepllist) {
		if ( $murderpl->iscanrole($sow->{'ROLEID_LONEWOLF'}) ){
			next if (1 != $murderpl->isdo('role1')); # おまかせは除外
			my $targetpl = $vil->getplbypno($murderpl->{'role1'});
			my $targetname = $targetpl->getchrname();
			if (($targetpl->{'live'} eq 'live')) {
				&postKillMessage($murderpl,$targetname,$logfile,'MESTYPE_TSAY');
				my $deadflag = &CheckKill($sow, $vil, $logfile, $score, $murderpl, 1.01, $targetpl);

				if ($deadflag ne 'live') {
					&dead($sow, $vil, $murderpl, $targetpl, $deadflag, $logfile, $score);

					my $result_kill;
					if( 'zombie' eq $deadflag ){
						$result_kill= $vil->getText('RESULT_ZOMBIE');
					} else {
						$result_kill= $vil->getText('RESULT_KILL');
					}
					$result_kill =~ s/_TARGET_/$targetname/g;
					$murderpl->addhistory($result_kill);
				}
			}
		}
	}
}

sub Dawn{
	my ($sow, $vil, $logfile, $score) = @_;

	my $pllist = $vil->getpllist();
	my $livepllist = $vil->getlivepllist();
	# でぃーっしゅ
	foreach $dish (@$livepllist) {
		if ( $dish->iscanrole($sow->{'ROLEID_DISH'}) ){
			next if ( $dish->{'role1'} != $dish->{'pno'} ); # おまかせは除外
			
			my $scorehead = $vil->getTextByID('ABI_ROLE',$dish->{'role'});
			$score->addresult($scorehead,$dish->getlongchrname() );

			my $dishtext = $vil->getText('EXECUTEJUMP');
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFONOM'}, $dishtext);
			$dish->addhistory($dishtext);
		}
	}

	# 「運命の日」を計算
	my $wolves = 0;
	foreach $plsingle (@$livepllist) {
		$wolves += 1 if ( $plsingle->iswolf() > 0 );
	}

	if ($wolves + 2 == $vil->{'turn'}){
		foreach $plsingle (@$livepllist){
			my $deadflag = 'live';
			# 死に行く者
			$deadflag = 'droop' if ($plsingle->isbindrole($sow->{'ROLEID_DYING'})       ); 
			$deadflag = 'droop' if ($plsingle->isbindrole($sow->{'ROLEID_DYINGPOSSESS'}));
			$deadflag = 'droop' if ($plsingle->isbindrole($sow->{'ROLEID_DYINGWOLF'})   );
			$deadflag = 'droop' if ($plsingle->isbindrole($sow->{'ROLEID_DYINGPIXI'})   );
			next if ($deadflag eq 'live' );
			&dead($sow, $vil, 0, $plsingle, 'droop', $logfile, $score, 0);
		} 
	}
	$wolves = $vil->{'turn'} - 1;
	if (0 < $wolves){
		foreach $plsingle (@$livepllist){
			next unless ( $plsingle->issensible() );
			# 運命を自覚する。
			my $result = $vil->getText('RESULT_DYING');
			$result =~ s/_NUMBER_/$wolves/g;
			$plsingle->addhistory($result) if ($plsingle->isbindrole($sow->{'ROLEID_DYING'})       ); 
			$plsingle->addhistory($result) if ($plsingle->isbindrole($sow->{'ROLEID_DYINGPOSSESS'}));
			$plsingle->addhistory($result) if ($plsingle->isbindrole($sow->{'ROLEID_DYINGWOLF'})   );
			$plsingle->addhistory($result) if ($plsingle->isbindrole($sow->{'ROLEID_DYINGPIXI'})   );
		}
	}
}

sub Snatch{
	my ($sow, $vil, $logfile, $score ) = @_;
	my $livepllist = $vil->getlivepllist();
	my @snatch;

	# いったんスナッチャー活動者リストを作る。
	foreach $plsingle (@$livepllist) {
		next if ( 1 != $plsingle->isdo('role1')); # おまかせは除外
		next if ( 0 == $plsingle->iscanrole($sow->{'ROLEID_SNATCH'}) );

		# スナッチ
		push(@snatch, $plsingle);
		my $targetpl = $vil->getplbypno($plsingle->{'role1'}); 
		my $snatchname = $plsingle->getchrname(); 
		my $targetname = $targetpl->getchrname(); 
		# 情報書き込み 
		my $snatchtext = $plsingle->getText('EXECUTESNATCH');
		$snatchtext =~ s/_NAME_/$snatchname/g; 
		$snatchtext =~ s/_TARGET_/$targetname/g; 
		$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $snatchtext); 
		$plsingle->addhistory($snatchtext);

		my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SNATCH'});
		$score->addresult($scorehead,$snatchname );
		$score->addresult($scorehead,$targetname );
	}
	
	# スナッチャー能力行使。
	foreach $snatchpl (@snatch) {
		my $targetpl = $vil->getplbypno($snatchpl->{'role1'}); 

		# これらを取り残すことで、貌、名前の入れ替えを実現。
		# ($snatchpl->{'cid'}, $targetpl->{'cid'}) = ($targetpl->{'cid'}, $snatchpl->{'cid'}); 
		# ($snatchpl->{'csid'}, $targetpl->{'csid'}) = ($targetpl->{'csid'}, $snatchpl->{'csid'}); 
		# ($snatchpl->{'jobname'}, $targetpl->{'jobname'}) = ($targetpl->{'jobname'}, $snatchpl->{'jobname'}); 
		# ($snatchpl->{'postfix'}, $targetpl->{'postfix'}) = ($targetpl->{'postfix'}, $snatchpl->{'postfix'}); 
		# ($snatchpl->{'clearance'}, $targetpl->{'clearance'}) = ($targetpl->{'clearance'}, $snatchpl->{'clearance'}); 

		# sheep, bonds, lovers は、貌に準ずるので取り残す。
		# <=> uid, role, rolesubid, selrole, live, deathday, vote, target, target2, entrust, history
		($snatchpl->{'uid'},       $targetpl->{'uid'})       = ($targetpl->{'uid'},       $snatchpl->{'uid'}      ); 
		($snatchpl->{'role'},      $targetpl->{'role'})      = ($targetpl->{'role'},      $snatchpl->{'role'}     ); 
		($snatchpl->{'gift'},      $targetpl->{'gift'})      = ($targetpl->{'gift'},      $snatchpl->{'gift'}     ); 
		($snatchpl->{'rolesubid'}, $targetpl->{'rolesubid'}) = ($targetpl->{'rolesubid'}, $snatchpl->{'rolesubid'}); 
		($snatchpl->{'rolestate'}, $targetpl->{'rolestate'}) = ($targetpl->{'rolestate'}, $snatchpl->{'rolestate'}); 
		($snatchpl->{'selrole'},   $targetpl->{'selrole'})   = ($targetpl->{'selrole'},   $snatchpl->{'selrole'}  ); 
		($snatchpl->{'history'},   $targetpl->{'history'})   = ($targetpl->{'history'},   $snatchpl->{'history'}  ); 

#		後追い決意者にスナッチしちゃったら、おとなしく死ぬ。
#		($snatchpl->{'tmp_suicide'},$targetpl->{'tmp_suicide'})=($targetpl->{'tmp_suicide'},$snatchpl->{'tmp_suicide'}); 
		($snatchpl->{'live'},      $targetpl->{'live'})      = ($targetpl->{'live'},      $snatchpl->{'live'}      ); 
		($snatchpl->{'delay_live'},$targetpl->{'delay_live'})= ($targetpl->{'delay_live'},$snatchpl->{'delay_live'}); 
		($snatchpl->{'deathday'},  $targetpl->{'deathday'})  = ($targetpl->{'deathday'},  $snatchpl->{'deathday'}  ); 
		($snatchpl->{'saidcount'}, $targetpl->{'saidcount'}) = ($targetpl->{'saidcount'}, $snatchpl->{'saidcount'} ); 

		# カレントプレイヤー（ログイン中のプレイヤー）を変更するかもしれない。
		$sow->{'curpl'} = $vil->getpl($sow->{'uid'}) if ($vil->checkentried() >= 0);
	}
}


#----------------------------------------
# 夜明けの後悔
# 死亡者の判定や、死亡者による影響を解決する。
#----------------------------------------
sub Regret{
	my ($sow, $vil, $logfile, $score, $jammed ) = @_;

	my $pllist = $vil->getpllist();

	# 死者の確定。
	# 後追いした人に他の死因がないなら、後追いも表記。
	# ただし、後追い者の行動は先に済ませてあるので、ここは表記のみ。
	foreach $targetpl (@$pllist){
		# 状態確定。
		if ($targetpl->{'delay_rolestate'} != $targetpl->{'rolestate'}){
			$targetpl->{'rolestate'} = $targetpl->{'delay_rolestate'};
		}
		$targetpl->define_delay();
		if ($targetpl->{'delay_live'} eq 'live' ){
			# 他の理由では死ななかった人だけ、後追いチェック。
			if ($targetpl->{'tmp_suicide'} != $sow->{'TARGETID_TRUST'} ){
				$targetpl->{'live'}     = 'suicide';
				$targetpl->{'deathday'} = $vil->{'turn'};
				$targetpl->{'rolestate'} |= $sow->{'MASKSTATE_HEAL'};

				my $deadpl = $targetpl->{'tmp_suicide'};
				my $suicidetext = $vil->getText('SUICIDEBONDS');
				my $chrname    = $deadpl->getchrname();
				my $targetname = $targetpl->getchrname();
				$suicidetext =~ s/_TARGET_/$chrname/g;
				$suicidetext =~ s/_NAME_/$targetname/g;
				$logfile->writeinfo($targetpl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $suicidetext);
			}
		}
	}

	my $deadplcnt = 0;
	my $deadtext = $vil->getTextByID('ANNOUNCE_KILL',0);
	my $millerhollow;

	# 平素は、復讐、暴動は発生しない。
	$vil->{'grudge'} = -1;
	$vil->{'riot'} = -1;
	# 死者を表記。
	foreach $plsingle (@$pllist){
		next if ($plsingle->{'live'} eq 'live');
		next if ($plsingle->{'deathday'} ne $vil->{'turn'});

		my $deadchrname = $plsingle->getchrname();
		my $scorehead = $sow->{'textrs'}->{'STATUS_LIVE'}->{$plsingle->{'live'}};
		$score->addresult($scorehead,$deadchrname );

		# 仔狼の死体。復讐！
		if ($plsingle->iscanrole($sow->{'ROLEID_CHILDWOLF'}) ){
			$vil->{'grudge'} = $vil->{'turn'};
			my $result = $plsingle->getText('EXECUTECHILDWOLF');
			$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOWOLF'}, $result);
		}
		
		# 煽動者の死体。暴動！
		if ($plsingle->iscanrole($sow->{'ROLEID_FAN'}) ){
			$vil->{'riot'} = $vil->{'turn'};
			my $result = $plsingle->getText('EXECUTEFAN');
			$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $result);
		}

		# ミラーズホロウの死者判定
		$ismillerhollow = 0;
		$ismillerhollow = 1 if ('MILLERHOLLOW'      eq $vil->{'game'});
		$ismillerhollow = 1 if ('LIVE_MILLERHOLLOW' eq $vil->{'game'});
		
		if ( $ismillerhollow ){
			$millerhollow .= GetResultRole($sow, $vil, $score, $plsingle, $jammed);
		}


		if ( $plsingle->ismediumed() ){
			# 処刑結果によっては、ブーイング発生。
			if ($plsingle->ishuman()){
				$vil->{'content'} = 'boo' if (($vil->{'event'} == $sow->{'EVENTID_CLAMOR'}));
			} else {
				$vil->{'content'} = 'boo' if (($vil->{'event'} == $sow->{'EVENTID_FIRE'}  ));
			}
		} else {
			# 無残な死体を発見、数え上げる。
			$deadplcnt += 1 ;

			$deadtext .= '<br>'.$vil->getTextByID('ANNOUNCE_KILL',2);
			$deadtext =~ s/_TARGET_/$deadchrname/g;
		}
	}
	if ($deadplcnt == 0) {
		# 無残な屍体なし
		$deadtext .= '<br>'.$vil->getTextByID('ANNOUNCE_KILL',1);
	}
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $deadtext);

	if ($millerhollow ne '' ){
		$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $millerhollow);
	}
}


#----------------------------------------
# 後追い、賞金稼ぎ
#----------------------------------------
sub cycle {
	my ($sow, $vil, $deadpl, $logfile, $score) = @_;

	my $chrname = $deadpl->getchrname();
	# 絆の後追い （四月馬鹿の日にはおこらない）
	if ( $vil->{'event'} != $sow->{'EVENTID_APRIL_FOOL'} ){
		my @bonds = $deadpl->getbondlist();
		foreach $plsingle (@bonds) {
			my $targetpl = $vil->getplbypno($plsingle);
			next if ('hate' eq $targetpl->{'love'}   );
			next if (  -1   != $targetpl->{'tmp_suicide'});
			$targetpl->{'tmp_suicide'} = $deadpl;
			&cycle($sow, $vil, $targetpl, $logfile, $score); # 後追い連鎖
		}
	}

	# 賞金稼ぎ
	if ( $deadpl->iscanrole($sow->{'ROLEID_HUNTER'}) ){
		return if ( $deadpl->{'role1'} < 0); # おまかせは除外
		# 「当夜内無能」に設定し、賞金稼ぎの能力が二重発動しないように。
		$deadpl->{'tmp_rolestate'} = $sow->{'ROLESTATE_ABI_NONE'};
		my $targetpl = $vil->getplbypno($deadpl->{'role1'});
		my $targetname = $targetpl->getchrname();
		if (($targetpl->{'live'} eq 'live')) {
			&postKillMessage($deadpl,$targetname,$logfile,'MESTYPE_TSAY');
			my $deadflag = &CheckKill($sow, $vil, $logfile, $score, $deadpl, 1.01, $targetpl);
			if ($deadflag ne 'live') {
				&dead($sow, $vil, $deadpl, $targetpl, $deadflag, $logfile, $score);
			}
		}
	}
}

sub revenge {
	my ($sow, $vil, $killer, $deadpl, $logfile, $score) = @_;
	return if (!defined( $killer->{'pno'}));
	return if ($deadpl->{'pno'} == $killer->{'pno'});

	my $chrname = $deadpl->getchrname();
	# 長老を殺害すると、殺害者は能力を失う。
	# 病人を殺害すると、殺害者は能力を失う。
	if (($deadpl->iscanrole($sow->{'ROLEID_ELDER'})  )
	  ||($deadpl->iscanrole($sow->{'ROLEID_INVALID'}))  ) {
		&toCurse($sow,$vil,$killer,$logfile);
		my $scorehead = $vil->getTextByID('ROLENAME',$deadpl->{'role'});
		$score->addresult($scorehead, $chrname );
	}
	# 飲薬すると能力を失うので、飲薬中はすでに「有能な錬金術師」ではない。
	# 飲薬中の錬金術師を殺害すると、殺害者はしぬ。
	if (($deadpl->isbindrole($sow->{'ROLEID_ALCHEMIST'}))&&($deadpl->{'role1'} == $deadpl->{'pno'})) {
		&dead($sow, $vil, $killer, $killer, 'cursed', $logfile, $score);
	}
}

sub nowdead {
	my ($sow, $vil, $killer, $deadpl, $deadflag, $logfile, $score) = @_;
	if ( 'zombie' eq $deadflag ){
		# 感染の処理。
		&toZombie($sow,$vil,$deadpl,$logfile);
	} else {
		$deadpl->{'deathday'} = $vil->{'turn'};
		$deadpl->{      'live'} = $deadflag;
		$deadpl->{'delay_live'} = $deadflag;
		&cycle($sow, $vil, $deadpl, $logfile, $score);
		&revenge($sow, $vil, $killer, $deadpl, $logfile, $score);
	}

}

sub dead {
	my ($sow, $vil, $killer, $deadpl, $deadflag, $logfile, $score) = @_;
	if ( 'zombie' eq $deadflag ){
		# 感染の処理。
		&toZombie($sow,$vil,$deadpl,$logfile);
	} else {
		$deadpl->{'delay_live'} = $deadflag;
		&cycle($sow, $vil, $deadpl, $logfile, $score);
		&revenge($sow, $vil, $killer, $deadpl, $logfile, $score);
	}
}

sub heal {
	my ($sow, $vil, $deadpl, $logfile) = @_;

	# 蘇生した場合、ゾンビ状態、負傷状態が癒える。
	$deadpl->{'delay_live'} = 'live';
	$deadpl->{'rolestate'} |= $sow->{'MASKSTATE_HEAL'};

	# 能力行使のリセット
	$deadpl->{'vote1'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'vote2'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'role1'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'role2'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'gift1'} = $sow->{'TARGETID_TRUST'};
	$deadpl->{'gift2'} = $sow->{'TARGETID_TRUST'};
}

sub CheckKill {
	my ($sow, $vil, $logfile, $score, $murderpl, $killers, $targetpl) = @_;
	my $deadflag = 'victim';

	return $deadflag if($targetpl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});

	my $livepllist = $vil->getlivepllist();
	my $targetname = $targetpl->getchrname();

	# 感染者をもう一度襲撃した場合は、殺傷力を持つ。
	$killers += 0.01 if ($targetpl->isDisableState('MASKSTATE_ZOMBIE'));

	my $hasGJ=0;
	my @guards;
	# 護衛判定
	foreach $plsingle (@$livepllist) {
		next unless ( $plsingle->isdo('role1') );                      # おまかせは除外
		next unless ( $plsingle->iscanrole($sow->{'ROLEID_GUARD'}) );  # 狩人以外は除外
		next if ($plsingle->{'role1'} != $targetpl->{'pno'});         # 対象を護衛してなければ除外

		my $result_guard = "";
		if (($plsingle->issensible())){
			$result_guard = $vil->getText('RESULT_GUARD');
		} else {
			$result_guard = $vil->getText('RESULT_ENCOUNT');
		}
		$result_guard =~ s/_TARGET_/$targetname/g;
		$plsingle->addhistory($result_guard);
		# 護衛側を集計
		push(@guards, $plsingle);
		$hasGJ++;
	}
	my $guardpl = $guards[int(rand(@guards))];

	# 光の輪を持っている（必ず発動）
	if (($targetpl->{'live'} eq 'live') && ($targetpl->{'gift'} == $sow->{'GIFTID_SHIELD'})) {
		$hasGJ++;
	}
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "GJ count $hasGJ.");

	# 「感染あり」モード
	my $enable_zombie = 0;
	$enable_zombie = 1 if ('TROUBLE' eq $vil->{'game'} );
	$enable_zombie = 1 if ('VOV'     eq $vil->{'game'} );

	if ((0 < $hasGJ)&&(0 < $killers)){
		if ($enable_zombie){
			# 守護側と人狼側の争い。整数化してから比較
			if      (int($hasGJ) < int($killers)){
				# 襲撃側が優勢
				# 力負けした守護者達は、即死ではない（感染ですむ）
				foreach $guardpl (@guards) {
					my $g_deadflag = &CheckKill($sow, $vil, $logfile, $score, $murderpl, 1, $guardpl);
					if ($g_deadflag ne 'live') {
						&dead($sow, $vil, $murderpl, $guardpl, $g_deadflag, $logfile, $score);
					}
				}
			} elsif (int($hasGJ) > int($killers)){
				# 護衛側が優勢
				# 護衛側からの返り討ちでは、対象は死亡する。
				my $g_deadflag = &CheckKill($sow, $vil, $logfile, $score, $guardpl, $hasGJ + 0.01, $murderpl);
				if ($g_deadflag ne 'live') {
					&dead($sow, $vil, $guardpl, $murderpl, $g_deadflag, $logfile, $score);
				}
			}
		}
		# 守護発生の場合、どう転んでも本来の犠牲者は無事。
		return 'live';
	} else {
		if ($enable_zombie){
			# 守護のない場合。
			if    (1 < $killers){
			}elsif(0 < $killers){
				$deadflag = 'zombie';
			} else {
				return 'live'; # 生存の時は下のチェックを挟まない。
			}
		}
	}
	
	# 長老は一度だけ死なない
	# 人犬は即死しない
	if ( ($targetpl->iscanrole($sow->{'ROLEID_ELDER'})  )
	   ||($targetpl->iscanrole($sow->{'ROLEID_WEREDOG'})) ) {
		if (($targetpl->issensible())){
			$targetpl->addhistory($vil->getText('RESULT_WEREDOG')) if($targetpl->{'role'} == $sow->{'ROLEID_WEREDOG'}); 
			$targetpl->addhistory($vil->getText('RESULT_ELDER'  )) if($targetpl->{'role'} == $sow->{'ROLEID_ELDER'}  ); 
		}
		$targetpl->{'delay_rolestate'} &= $sow->{'ROLESTATE_HURT'};
		$targetpl->{'tmp_deathday'} = $vil->{'turn'};
		$deadflag = 'live';

		my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_WEREDOG'});
		$score->addresult($scorehead, $targetname );
	}

	# 半狼は死なず、人狼になる。
	if ( $targetpl->iscanrole($sow->{'ROLEID_SEMIWOLF'})) {
		$targetpl->{'role'}      = $sow->{'ROLEID_WOLF'};
		$targetpl->addhistory($vil->getText('RESULT_SEMIWOLF'));
		$targetpl->setfriends();
		$deadflag = 'live';

		my $scorehead = $vil->getTextByID('ROLENAME',$sow->{'ROLEID_SEMIWOLF'});
		$score->addresult($scorehead, $targetname );
	}

	# 妖精は襲撃では死なない。
	if (( $targetpl->iscursed('role') )&&( $targetpl->isEnableState('MASKSTATE_ABI_ROLE') )){
		$deadflag = 'live';
		my $scorehead = $vil->getTextByID('ROLENAME',$targetpl->{'role'});
		$score->addresult($scorehead, $targetname );
	}
	if (( $targetpl->iscursed('gift') )&&( $targetpl->isEnableState('MASKSTATE_ABI_GIFT') )){
		$deadflag = 'live';
		my $scorehead = $vil->getTextByID('ROLENAME',$targetpl->{'gift'});
		$score->addresult($scorehead, $targetname );
	}

	if ( $targetpl->iscanrole($sow->{'ROLEID_LONEWOLF'}) ) {
		$deadflag = 'live';

		my $scorehead = $vil->getTextByID('ROLENAME',$targetpl->{'role'});
		$score->addresult($scorehead, $targetname );
	}

	$score->addresult($deadflag, $targetname );
	return $deadflag;
}

sub Seer {
	my ($sow, $vil, $logfile, $score, $jammed) = @_;

	my $pllist = $vil->getpllist();
	foreach $plsingle (@$pllist) {
		if ( $plsingle->{'live'} eq 'live' ) {
			if ( $plsingle->isdo('role1') ) {
				# おまかせは除外
				my $targetpl = $vil->getplbypno($plsingle->{'role1'});
				my $seerresultrole = '';
				my $isseer = 0;

				if (    $plsingle->iscanrole($sow->{'ROLEID_SEERWIN' }) ){ $isseer = 1; $seerresultrole = GetResultWin ($sow, $vil, $score, $targetpl, $jammed) };
				if (    $plsingle->iscanrole($sow->{'ROLEID_SEERROLE'}) ){ $isseer = 1; $seerresultrole = GetResultRole($sow, $vil, $score, $targetpl, $jammed) };
				if (    $plsingle->iscanrole($sow->{'ROLEID_SORCERER'}) ){ $isseer = 1; $seerresultrole = GetResultRole($sow, $vil, $score, $targetpl, $jammed) };
				if (($plsingle->issensible())){
					if ($plsingle->iscanrole($sow->{'ROLEID_SEER'    }) ){ $isseer = 1; $seerresultrole = GetResultSeer  ($sow, $vil, $score, $targetpl, $jammed) };
					if ($plsingle->iscanrole($sow->{'ROLEID_AURA'    }) ){ $isseer = 1; $seerresultrole = GetResultAura  ($sow, $vil, $score, $targetpl, $jammed) };
				} else {
					if ($plsingle->iscanrole($sow->{'ROLEID_SEER'    }) ){ $isseer = 1; $seerresultrole = GetResultSeerEncount  ($sow, $vil, $score, $targetpl, $jammed) };
					if ($plsingle->iscanrole($sow->{'ROLEID_AURA'    }) ){ $isseer = 1; $seerresultrole = GetResultAuraEncount  ($sow, $vil, $score, $targetpl, $jammed) };
				}
				# 智狼、判狼の判定は、襲撃フェーズで。

				&SeerEffect($sow, $vil, $plsingle, $targetpl, $seerresultrole, $logfile, $score, $jammed) if ($isseer);
			}

			if ( $plsingle->isdo('gift1') ) {
				# おまかせは除外
				my $targetpl = $vil->getplbypno($plsingle->{'gift1'});
				my $seerresultgift = '';
				my $isseer = 0;

				if (    $plsingle->iscangift($sow->{'GIFTID_SEERONCE'}) ) { $isseer = 1; $seerresultgift = GetResultSeer($sow, $vil, $score, $targetpl, $jammed) };
				&SeerEffect($sow, $vil, $plsingle, $targetpl, $seerresultgift, $logfile, $score, $jammed) if ($isseer);
				# 夢占師が力を使い果たした。
				if ($plsingle->isbindgift($sow->{'GIFTID_SEERONCE'})){
					$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_NOGIFT'};
				}
			}
		} else {
			# 死者は、霊判定の対象になるかもしれない。
			next if ( $plsingle->{'deathday'} ne $vil->{'turn'} );
			next unless ( $plsingle->ismediumed() );
			# 霊能判定
			my $seerencount = GetResultSeerEncount($sow, $vil, $score, $plsingle, $jammed);
			my $auraencount = GetResultAuraEncount($sow, $vil, $score, $plsingle, $jammed);
			my $seerresult = GetResultSeer($sow, $vil, $score, $plsingle, $jammed);
			my $auraresult = GetResultAura($sow, $vil, $score, $plsingle, $jammed);
			my $winresult  = GetResultWin( $sow, $vil, $score, $plsingle, $jammed);
			my $roleresult = GetResultRole($sow, $vil, $score, $plsingle, $jammed);
			# 霊能判定追記
			my $livepllist = $vil->getlivepllist();
			foreach $plsingle (@$livepllist) {
				if (($plsingle->issensible())){
					$plsingle->addhistory($seerresult) if ($plsingle->iscanrole($sow->{'ROLEID_NECROMANCER'}) );
					$plsingle->addhistory($seerresult) if ($plsingle->iscanrole($sow->{'ROLEID_MEDIUM'})      );
				} else {
					$plsingle->addhistory($seerencount) if ($plsingle->iscanrole($sow->{'ROLEID_NECROMANCER'}) );
					$plsingle->addhistory($seerencount) if ($plsingle->iscanrole($sow->{'ROLEID_MEDIUM'})      );
				}
				$plsingle->addhistory($winresult)  if ($plsingle->iscanrole($sow->{'ROLEID_MEDIUMWIN'})   );
				$plsingle->addhistory($roleresult) if ($plsingle->iscanrole($sow->{'ROLEID_MEDIUMROLE'})  );
				$plsingle->addhistory($roleresult) if ($plsingle->iscanrole($sow->{'ROLEID_ORACLE'})      );
			}
		}
	}

	# 治療の効果を持ち状態を変えてしまうので、医師の能力は最後。
	foreach $plsingle (@$pllist) {
		next if ( $plsingle->{'live'} ne 'live' );
		if ( $plsingle->isdo('role1') ) {
			# おまかせは除外
			my $targetpl = $vil->getplbypno($plsingle->{'role1'});
			my $seerresultrole = '';
			my $isseer = 0;

			if (($plsingle->issensible())){
				if ($plsingle->iscanrole($sow->{'ROLEID_DOCTOR'  }) ){ $isseer = 1; $seerresultrole = GetResultDoctor($sow, $vil, $score, $targetpl, $jammed) };
			} else {
				if ($plsingle->iscanrole($sow->{'ROLEID_DOCTOR'  }) ){ $isseer = 1; $seerresultrole = GetResultDoctorEncount($sow, $vil, $score, $targetpl, $jammed) };
			}
			&SeerEffect($sow, $vil, $plsingle, $targetpl, $seerresultrole, $logfile, $score, $jammed) if ($isseer);
		}
	}
}

sub SeerEffect {
	my ($sow, $vil, $plsingle, $targetpl, $seerresult, $logfile, $score, $jammed) = @_;

	my $livepllist = $vil->getlivepllist();

	# 占いの副作用を実施。
	# 使うときはかならず、占い発動時のみ実行する工夫をすること。
	# 占い発動
	my $targetname = $targetpl->getchrname();
	$plsingle->addhistory($seerresult);
	if (($plsingle->issensible())){
		my $seertext   = $plsingle->getText('EXECUTESEER');
		$seertext =~ s/_TARGET_/$targetname/g;
		$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $seertext.'<br>'.$seerresult);
	}
	my $hasGJ=0;
	foreach $plsingle (@$livepllist) {
		# 邪魔でのGJ
		if ($plsingle->{'role'} eq $sow->{'ROLEID_JAMMER'} && $plsingle->{'role1'} == $targetpl->{'pno'}) { 
			my $result = $vil->getText('RESULT_JAMM');
			$result =~ s/_TARGET_/$targetname/g;
			$plsingle->addhistory($result) if (defined($targetpl->{'uid'}));
			$hasGJ++;
		}
	}
	return if ($hasGJ > 0);
	# 妖精呪殺
	if (($targetpl->{'live'} eq 'live') && ($targetpl->iscursed('role')+$targetpl->iscursed('gift'))) {
		&dead($sow, $vil, $plsingle, $targetpl, 'cursed', $logfile, $score);
	}
	# 呪人
	if ($targetpl->iscanrole($sow->{'ROLEID_CURSE'})) {
		&dead($sow, $vil, $targetpl, $plsingle, 'cursed', $logfile, $score);
	}
	# 呪狼
	if ($targetpl->iscanrole($sow->{'ROLEID_CURSEWOLF'})) {
		&dead($sow, $vil, $targetpl, $plsingle, 'cursed', $logfile, $score);
	}
	# 狼血族
	if ($targetpl->isbindrole($sow->{'ROLEID_RIGHTWOLF'})) {
		if (($targetpl->issensible())){
			my $result_seered = $vil->getText('RESULT_RIGHTWOLF');
			$targetpl->addhistory($result_seered);
		}
	}
}


sub Alchemist{
	my ($sow, $vil, $logfile, $score, $jammtargetpl) = @_;

	my $pllist = $vil->getpllist();
	foreach $plsingle (@$pllist) {
		next if ( $plsingle->{'role1'} != $plsingle->{'pno'} ); # おまかせは除外
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		my $targetname = $targetpl->getchrname();
		# 飲薬
		if ($plsingle->iscanrole($sow->{'ROLEID_ALCHEMIST'})){
			$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_NOROLE'};

			if ($plsingle->issensible()){
				my $result = $plsingle->getText('EXECUTEALCHEMIST');
				$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);

				$result = $vil->getText('RESULT_ALCHEMIST');
				$result =~ s/_TARGET_/$targetname/g;
				$plsingle->addhistory($result);
			}

			my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_ALCHEMIST'});
			$score->addresult($scorehead, $targetname );
		}
	}
}

sub Witch{
	my ($sow, $vil, $logfile, $score, $jammtargetpl) = @_;
	my $pllist = $vil->getlivepllist();
	foreach $plsingle (@$pllist) {
		next if (1 != $plsingle->isdo('role1')); # おまかせは除外
		my $targetpl = $vil->getplbypno($plsingle->{'role1'});
		my $targetname = $targetpl->getchrname();
		# 魔女の投薬
		if ($plsingle->iscanrole($sow->{'ROLEID_WITCH'})){
			# 実際の生死にかかわらず、薬を使う。
			if ($plsingle->{'tmp_targetlive'} eq 'live'){
				# 毒薬がない場合NG
				next if ($plsingle->isDisableState('MASKSTATE_ABI_KILL'));
				$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_KILL'};
				# 毒薬を使う
				if ($plsingle->issensible()){
					my $result = $plsingle->getText('EXECUTEKILLWITCH');
					$result =~ s/_TARGET_/$targetname/g;
					$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
					$result = $vil->getText('RESULT_KILL');
					$result =~ s/_TARGET_/$targetname/g;
					$plsingle->addhistory($result);
				}

				my $scorehead = $sow->{'textrs'}->{'STATUS_LIVE'}->{'cursed'};
				$score->addresult($scorehead, $targetname );

				&dead($sow, $vil, $plsingle, $targetpl, 'cursed', $logfile, $score, $jammtargetpl);
			} elsif ($plsingle->{'tmp_targetlive'} eq 'suddendead'){
				# 突然死相手に、薬は使わない。
				next;
			} else {
				# 蘇生薬がない場合NG
				next if ($plsingle->isDisableState('MASKSTATE_ABI_LIVE'));
				$plsingle->{'delay_rolestate'} &= $sow->{'ROLESTATE_ABI_LIVE'};
				# 蘇生薬を使う
				if ($plsingle->issensible()){
					my $result = $plsingle->getText('EXECUTELIVEWITCH');
					$result =~ s/_TARGET_/$targetname/g;
					$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result);
					$result = $vil->getText('RESULT_LIVE');
					$result =~ s/_TARGET_/$targetname/g;
					$plsingle->addhistory($result);
				}

				my $scorehead = $sow->{'textrs'}->{'STATUS_LIVE'}->{'live'};
				$score->addresult($scorehead, $targetname );

				&heal($sow, $vil, $targetpl, $logfile, $score);
			}

		}
	}
}

sub GetResultSeerEncount {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = "";
	my $result_hit = $vil->getText('RESULT_ENCOUNT');
	# 人狼判定。役職が人狼、恩恵が人狼、一匹狼、狼血族。また、白狼は人間判定。
	$result = $result_hit if  ($targetpl->iskiller('role')); # 人狼勢力
	$result = $result_hit if  ($targetpl->iskiller('gift')); # 人狼勢力
	$result = $result_hit if  ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # ゾンビにされました。
	$result = $result_hit if  ($targetpl->{'role'} == $sow->{'ROLEID_LONEWOLF'}  );
	$result = $result_hit if  ($targetpl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'} );
	$result = ""          if  ($targetpl->iscanrole(  $sow->{'ROLEID_WHITEWOLF'}));
	foreach $plsingle (@$jammed){
		$result =  "" if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	$result =~ s/_TARGET_/$chrname/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SEER'});
	$score->addresult($scorehead, $chrname );
	return $result;
}

sub GetResultDoctorEncount {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = "";
	my $result_hit = $vil->getText('RESULT_ENCOUNT');
	# 人狼判定。感染者のみ。
	$result = $result_hit if  ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # 感染者
	foreach $plsingle (@$jammed){
		$result =  "" if ($plsingle == $targetpl);
	}
	$targetpl->{'delay_rolestate'} |= $sow->{'MASKSTATE_MEDIC'} if ("" ne $result);
	my $chrname = $targetpl->getchrname();
	$result =~ s/_TARGET_/$chrname/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_DOCTOR'});
	$score->addresult($scorehead, $chrname );
	return $result;
}

sub GetResultAuraEncount {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = $vil->getText('RESULT_ENCOUNT');
	$result = "" if ($targetpl->{'role'} == $sow->{'ROLEID_VILLAGER'} );
	$result = "" if ($targetpl->{'role'} == $sow->{'ROLEID_WOLF'}     );
	$result = "" if ($targetpl->iscanrole( $sow->{'ROLEID_WHITEWOLF'}));
	$result = "" if ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # ゾンビにされました。
	foreach $plsingle (@$jammed){
		$result = "" if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	$result =~ s/_TARGET_/$chrname/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_AURA'});
	$score->addresult($scorehead, $chrname );
	return $result;
}


sub GetResultSeer {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = 1;
	# 人狼判定。役職が人狼、恩恵が人狼、一匹狼、狼血族。ゾンビ。また、白狼は人間判定。
	$result = 2 if  ($targetpl->iskiller('role')); # 人狼勢力
	$result = 2 if  ($targetpl->iskiller('gift')); # 人狼勢力
	$result = 2 if  ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # ゾンビにされました。
	$result = 2 if  ($targetpl->{'role'} == $sow->{'ROLEID_LONEWOLF'}  );
	$result = 2 if  ($targetpl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'} );
	$result = 1 if  ($targetpl->iscanrole(  $sow->{'ROLEID_WHITEWOLF'}));
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SEER'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

sub GetResultDoctor {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = 5;
	# 人狼判定。感染者のみ。
	$result = 6 if ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # 感染者
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	$targetpl->{'delay_rolestate'} |= $sow->{'MASKSTATE_MEDIC'} if (6 eq $result);
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_DOCTOR'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

sub GetResultAura {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = 4;
	$result = 3 if ($targetpl->{'role'} == $sow->{'ROLEID_VILLAGER'} );
	$result = 3 if ($targetpl->{'role'} == $sow->{'ROLEID_WOLF'}     );
	$result = 3 if ($targetpl->iscanrole( $sow->{'ROLEID_WHITEWOLF'}));
	$result = 3 if ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # ゾンビにされました。
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_AURA'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

sub GetResultWin {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $textrs = $sow->{'textrs'};
	# 勝利条件を参照する。
	my $result = 7;
	my $win    = $textrs->{'ROLEWIN'}->{ $targetpl->win_if() };
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;
	$result_seer =~ s/_ROLE_/$win/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SEERWIN'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

sub GetResultRole {
	my ($sow, $vil, $score, $targetpl, $jammed) = @_;
	my $result = 7;
	my $role   = $vil->getTextByID('ROLENAME',$targetpl->{'role'});
	foreach $plsingle (@$jammed){
		$result = 8 if ($plsingle == $targetpl);
	}
	my $chrname = $targetpl->getchrname();
	my $result_seer = $targetpl->getTextByID('RESULT_SEER',0);
	my $result_text = $vil->getTextByID('RESULT_SEER',$result);
	$result_seer =~ s/_RESULT_/$result_text/g;
	$result_seer =~ s/_ROLE_/$role/g;

	my $scorehead = $vil->getTextByID('ABI_ROLE',$sow->{'ROLEID_SEERROLE'});
	$score->addresult($scorehead, $chrname );
	return $result_seer;
}

#----------------------------------------
# 能力対象ランダム指定時処理
#----------------------------------------
sub SetRandomTarget {
	my ($sow, $vil, $logfile, $role,$abi_role) = @_;
	my $livepllist = $vil->getlivepllist();

	my $srcpl;
	foreach $srcpl (@$livepllist) {
		my $abirole = $vil->getTextByID($abi_role,$srcpl->{$role});
		if ($srcpl->{$role.'1'} == $sow->{'TARGETID_RANDOM'}) {
			# ランダム対象
			my $srctargetpno;
			$srctargetpno = $srcpl->{$role.'2'} if (($srcpl->{$role.'2'} >= 0) && ($srcpl->{'live'} eq 'live'));
			$srcpl->setRandomTarget($role,1, $abi_role,$logfile, $srctargetpno);
		}

		if (($srcpl->{$role.'2'} == $sow->{'TARGETID_RANDOM'})) {
			$srcpl->setRandomTarget($role,2, $abi_role,$logfile, $srcpl->{$role.'1'});
		}
	}
}

#----------------------------------------
# 初期投票先の設定
#----------------------------------------
sub SetInitVoteTarget {
	my ($sow, $vil, $logfile) = @_;
	my $allpllist = $vil->getallpllist();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "Start: SetInitVoteTarget.");
	foreach $plsingle (@$allpllist) {
		if( $plsingle->{'live'} eq 'live' ){
			$plsingle->setInitTarget('gift',1, $logfile, -1);
			$plsingle->setInitTarget('gift',2, $logfile, $plsingle->{'gift1'}); # 仔狼死亡時。
			$plsingle->setInitTarget('role',1, $logfile, -1);
			$plsingle->setInitTarget('role',2, $logfile, $plsingle->{'role1'}); # 仔狼死亡時とトリックスターで使い回し。
		}
		if( $plsingle->isvoter() ){
			$plsingle->setInitTarget('vote',1, $logfile, -1);
			$plsingle->setInitTarget('vote',2, $logfile, $plsingle->{'vote1'}); # 扇動者死亡時。
		}
		# 委任
		if(     $plsingle->setentrust($sow,$vil) == 0 ){
			$plsingle->{'entrust'} = 0 ;
		}elsif( $plsingle->setvote_to($sow,$vil) == 0 ){
			$plsingle->{'entrust'} = 1 ;
		}
	}
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "End: SetInitVoteTarget.");

	return;
}

#----------------------------------------
# 確定待ち発言の強制確定
#----------------------------------------
sub FixQueUpdateSession {
	my ($sow, $vil) = @_;

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	$logfile->fixque(1);
	$logfile->close();
}

sub postKillMessage{
	my ($murderpl,$targetname,$logfile,$mestype) = @_;
	my $sow = $murderpl->{'sow'};
	my $vil = $murderpl->{'vil'};

	my $killtext = $vil->getText('EXECUTEKILL');
	$killtext =~ s/_TARGET_/$targetname/g;
	my %say = (
		mestype    => $sow->{$mestype},
		logsubid   => $sow->{'LOGSUBID_SAY'},
		uid        => $murderpl->{'uid'},
		target     => $murderpl->{'uid'},
		csid       => $murderpl->{'csid'},
		cid        => $murderpl->{'cid'},
		chrname    => $murderpl->getlongchrname(),
		mes        => $killtext,
		undef      => 1, # 囁きとして扱わない
		expression => 0,
		monospace  => 0,
		que        => 0,
	);
	$logfile->executesay(\%say);
}

#----------------------------------------
# 村開始処理
#----------------------------------------
sub StartSession {
	my ($sow, $vil, $commit) = @_;
	my $textrs = $sow->{'textrs'};
	my $pllist = $vil->getpllist();

	# 確定待ち発言の強制確定
	&FixQueUpdateSession($sow, $vil);

	# 時間を進める
	$vil->UpdateTurn($commit);

	# ログ・メモデータファイルの作成
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
	my $logfile  = SWBoa->new($sow, $vil, $vil->{'turn'}, 1);
	my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 1);

	# 役職配分割り当て
	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
	my ( $rolematrix, $giftmatrix ) = &SWSetRole::SetRole($sow, $vil, $logfile);
	foreach $plsingle (@$pllist) {
		$plsingle->{'selrole'} = $plsingle->{'backupselrole'};
	}

	# 発言数初期化
	$vil->setsaycountall();

	# １日目開始アナウンス
	my $announce_first = $vil->getTextByID('ANNOUNCE_FIRST',1);
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $announce_first );

	# 役職割り当てアナウンス
	my $rolename = $textrs->{'ROLENAME'};
	my $giftname = $textrs->{'GIFTNAME'};
	my $i;

	my @rolelist;
	my @giftlist;
	my $ar = $textrs->{'ANNOUNCE_ROLE'};
	for ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
		my $roleplcnt = $rolematrix->[$i];
		$roleplcnt++ if ($i == $sow->{'ROLEID_VILLAGER'}); # ダミーキャラの分１増やす
		push (@rolelist, "$rolename->[$i]$ar->[1]$roleplcnt$ar->[2]") if ($roleplcnt > 0);
	}
	for ($i = 2; $i < @{$sow->{'GIFTID'}}; $i++) {
		my $giftplcnt = $giftmatrix->[$i];
		push (@rolelist, "$giftname->[$i]$ar->[1]$giftplcnt$ar->[2]") if ($giftplcnt > 0);
	}
	my $rolelist = join($ar->[3], @rolelist);
	my $giftlist = join($ar->[3], @giftlist);
	my $roleinfo = $ar->[0];
	$roleinfo =~ s/_ROLE_/$rolelist/;
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $roleinfo);

	# ダミーキャラ発言
	$plsingle = $vil->getpl($sow->{'cfg'}->{'USERID_NPC'});
	my $charset = $sow->{'charsets'}->{'csid'}->{$plsingle->{'csid'}};
	%say = (
		mestype    => $sow->{'MESTYPE_SAY'},
		logsubid   => $sow->{'LOGSUBID_SAY'},
		uid        => $sow->{'cfg'}->{'USERID_NPC'},
		target     => $sow->{'cfg'}->{'USERID_NPC'},
		csid       => $plsingle->{'csid'},
		cid        => $plsingle->{'cid'},
		chrname    => $plsingle->getlongchrname(),
		expression => 0,
		mes        => $charset->{'NPCSAY'}->[1],
		undef      => 0,
		monospace  => 0,
		que        => 0,
	);
	$plsingle->{'lastwritepos'} = $logfile->executesay(\%say);
	my $saypoint = &SWBase::GetSayPoint($sow, $vil, $say{'mes'});
	$plsingle->{'say'} -= $saypoint; # 発言数消費
	$plsingle->{'saidcount'}++;
	$plsingle->{'saidpoint'} += $saypoint;

	# ダミーキャラのコミット
	$plsingle->{'commit'} = 1;
	my $mes = $plsingle->getTextByID('ANNOUNCE_COMMIT',$plsingle->{'commit'});
	$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes);

	# 人狼譜の出力
	if ($sow->{'cfg'}->{'ENABLED_SCORE'} > 0) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
		my $score = SWScore->new($sow, $vil, 0);
 		$score->writestart();
		$score->close();
	}

	# 初期投票先の設定
	&SetInitVoteTarget($sow, $vil, $logfile);

	$logfile->close();
	$memofile->close();
	$vil->writevil();

	# 村一覧の更新
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	$vindex->updatevindex($vil, $sow->{'VSTATUSID_PLAY'});
	$vindex->closevindex();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Start Session. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");

	return;
}

#----------------------------------------
# 村更新処理
#----------------------------------------
sub UpdateSession {
	my ($sow, $vil, $commit, $scrapvil) = @_;
	my $pllist = $vil->getpllist();

	return if ($vil->{'epilogue'} < $vil->{'turn'}); # 終了済み

	# 確定待ち発言の強制確定
	&FixQueUpdateSession($sow, $vil);

	# 時間を進める
	$vil->UpdateTurn($commit);

	if ($vil->{'epilogue'} < $vil->{'turn'}) {
		# 終了
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
		my $vindex = SWFileVIndex->new($sow);
		$vindex->openvindex();
		my $vi = $vindex->getvindex($vil->{'vid'});
		my $vstatusid = $sow->{'VSTATUSID_END'};
		$vstatusid = $sow->{'VSTATUSID_SCRAPEND'} if ($vi->{'vstatus'} eq $sow->{'VSTATUSID_SCRAP'});
		$vindex->updatevindex($vil, $vstatusid);
		$vindex->closevindex();
	} else {
		# ログ・メモデータファイルの作成
		my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 1);
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
		my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 1);

		my $winner = 0;
		if ($scrapvil == 0) {
			&UpdateGM($sow, $vil, $logfile);

			# 人狼譜出力はとりあえずナシ。めどい。

			# 勝利判定
			$winner = &WinnerCheckGM($sow, $vil);
		}

		if (($winner > 0) || ($scrapvil > 0)) { # ゲーム終了
			# 終了メッセージ
			my $epinfo = $vil->getTextByID('ANNOUNCE_WINNER',$winner);
			$epinfo .= '<br>'. $vil->getText('ANNOUNCE_WINNER_DISH') if (0 < $vil->{'wincnt_dish'});
			$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $epinfo);

			# 配役一覧
			$logfile->writeinfo('', $sow->{'MESTYPE_CAST'}, '*CAST*');

			# 村一覧情報の更新
			my $vstatusid = $sow->{'VSTATUSID_EP'};
			$vstatusid = $sow->{'VSTATUSID_SCRAP'} if ($winner == 0);
			require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
			my $vindex = SWFileVIndex->new($sow);
			$vindex->openvindex();
			$vindex->updatevindex($vil, $vstatusid);
			$vindex->closevindex();

			$vil->{'winner'} = $winner;
			$vil->{'epilogue'} = $vil->{'turn'};
			&EventReset($sow, $vil, $logfile);
		} else {
			if ($vil->{'turn'} == 2) {
				# ２日目開始アナウンス
				my $announce_first = $vil->getTextByID('ANNOUNCE_FIRST',2);
				$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $announce_first );
			}

			# 事件の発動
			&EventGM($sow, $vil, $logfile);

			# 手抜き。そのうち直そう。
			require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
			my $vindex = SWFileVIndex->new($sow);
			$vindex->openvindex();
			$vindex->updatevindex($vil, $sow->{'VSTATUSID_PLAY'});
			$vindex->closevindex();
		}
		# 発言数初期化
		$vil->setsaycountall();

		# 初期投票先の設定
		&SetInitVoteTarget($sow, $vil, $logfile);

		$logfile->close();
		$memofile->close();
	}
	$vil->writevil();

	my $nextupdatedt = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Update Session. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, next=$nextupdatedt]");

	return;
}

1;
