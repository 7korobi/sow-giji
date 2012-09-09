package SWSetRole;

#----------------------------------------
# 役職配分割り当て
#----------------------------------------
sub SetRole {
	my ($sow, $vil, $logfile) = @_;
	my $textrs  = $sow->{'textrs'};
	my $rolename = $textrs->{'ROLENAME'};

	my $pllist = $vil->getpllist();
	# 役職配分を取得
	my ($roletable, $gifttable, $eventtable ) = &GetSetRoleTable($sow, $vil, $vil->{'roletable'}, scalar(@$pllist));
	my ($i, @roles, @gifts, @events);

	# アイテム用の配列を用意\n";
	for ($i = 0; $i < $sow->{'COUNT_GIFT'}; $i++) {
		my @giftpllist;
		$gifts[$i] = \@giftpllist;
	}

	# アイテム希望は未実装
	for (@$pllist) {
		next if ($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
		# 全員をいったん「なし」に
		$giftpllist = $gifts[$sow->{'GIFTID_NOT_HAVE'}];
		push(@$giftpllist, $_);
	}

	# 「なし」の人を空いているアイテムへ割り当て
	for ($i = 2; $i < $sow->{'COUNT_GIFT'}; $i++) {
		my $giftpllist = $gifts[$i];

		while ($gifttable->[$i] > @$giftpllist) {
			my $freepllist = $gifts[$sow->{'GIFTID_NOT_HAVE'}];
			my $pno      = int(rand(@$freepllist));
			my $movepl = splice(@$freepllist, $pno, 1);
			push(@$giftpllist, $movepl);
		}
	}

	# アイテムを決定
	my $dummypl = $vil->getpl($sow->{'cfg'}->{'USERID_NPC'});
	$dummypl->{'gift'} = $sow->{'GIFTID_NOT_HAVE'}; # ダミーキャラ
	for ($i = 1; $i < $sow->{'COUNT_GIFT'}; $i++) {
		my $giftpllist = $gifts[$i];
		foreach (@$giftpllist) {
 			if (!defined($_->{'gift'})) {
				# $_が未定義（ありえないはず）
				$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, 'invalid pl. [setgift.]');
			}
			$_->{'gift'} = $i;
		}
	}

	# 各役職用の配列を用意\n";
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		my @rolepllist;
		$roles[$i] = \@rolepllist;
	}

	# 役職希望を保存\n";
	foreach (@$pllist) {
		$_->{'backupselrole'} = $_->{'selrole'};
	}


	# ランダム用、役職ＩＤ選択肢一覧作成\n";
	my $rolecards = 0;
	my @randomroletable;
	my $roleid;
	for ($roleid = 0; $roleid < @$roletable; $roleid++) {
		my $rolecount = $roletable->[$roleid];
		$rolecards += $rolecount;
		while ($rolecount > 0) {
			push(@randomroletable, $roleid);
			$rolecount--;
		}
	}


	# 余り札確保\n";
	my $robbers = $roletable->[$sow->{'ROLEID_ROBBER'}];
	if ($robbers > 0) {
		# 確保する余り札は、ダミーを差し引いたうえで計算する。
		for($i = ($rolecards - (scalar(@$pllist)-1)); 0 < $i ; $i--){
			$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "余り札に流す数:$i");
#			分捕り盗賊にするなら、この式で盗賊ぶんを配属
#			my $choice = $randomroletable[int(rand(@randomroletable))];
#			盗賊は余らない。
#			redo if ($choice == $sow->{'ROLEID_ROBBER'} );
#			my $rolepllist = $roles[$choice];
#			おまかせ盗賊なら、お任せ枠に盗賊ぶんを配属
			my $rolepllist = $roles[0];
			push(@$rolepllist, 0);
		}
	}
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $textrs->{'NOSELROLE'}) if ($vil->{'noselrole'} > 0);

	# ランダム希望の処理\n";
	foreach (@$pllist) {
		next if ($_->{'selrole'} >= 0);

		if ($vil->{'noselrole'} > 0) {
			$_->{'selrole'} = 0; # 役職希望無視の時はおまかせに
		} else {
			$_->{'selrole'} = $randomroletable[int(rand(@randomroletable))];
			my $randomroletext = $textrs->{'SETRANDOMROLE'};
			my $chrname = $_->getlongchrname();
			$randomroletext =~ s/_NAME_/$chrname/g;
			$randomroletext =~ s/_SELROLE_/$textrs->{'ROLENAME'}->[$_->{'selrole'}]/g;
			$logfile->writeinfo($dummypl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $randomroletext);
		}
	}

	# 役職希望者IDを希望した役職の配列に格納\n";
	for (@$pllist) {
		next if ($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
		my $selrolelist = $roles[$_->{'selrole'}];
		# 役職希望を無視して、全員をおまかせに
		$selrolelist = $roles[0] if (($vil->{'noselrole'} > 0)&&($_->{'role'} == -1));
		push(@$selrolelist, $_);
	}

	my $freepllist;
	my $roleslist;
	my $movepl;
	for ($i = 1; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$roleslist  = $roles[$i];

		# あぶれた人をおまかせ配列に移動
		while ($roletable->[$i] < @$roleslist) {
			$freepllist = $roles[0]; # おまかせ配列
			my $pno = int(rand(@$roleslist));

			# おまかせ配列へ移動
			$movepl    = splice(@$roleslist, $pno, 1);
			push(@$freepllist, $movepl);
		}
	}

	# おまかせの人を空いている役職へ割り当て
	for ($i = $sow->{'COUNT_ROLE'}; 0 < $i  ; $i--) {
		$roleslist = $roles[$i];

		while ($roletable->[$i] > @$roleslist) {
			$freepllist = $roles[0];
			my $targetpl   = int(rand(@$freepllist));
#			盗賊は余らない。
			redo if (($targetpl == 0)&&($i == $sow->{'ROLEID_ROBBER'} ));
			$movepl = splice(@$freepllist, $targetpl, 1);
			push(@$roleslist, $movepl);
		}
	}

	# 割り当て一覧表示（テスト用）
	for ($i = 0; $i < @$rolename; $i++) {
		my $pid = $roles[$i];
		my $n = @$pid;
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "[$rolename->[$i]] $n");
	}

	# 役職を決定
	$dummypl->{'role'} = $sow->{'ROLEID_VILLAGER'}; # ダミーキャラ
	my @rolediscard;
	for ($i = 1; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$roleslist = $roles[$i];
		foreach (@$roleslist) {
			if ($_ == 0) {
				push(@rolediscard, $i);
			} else {
	 			if (!defined($_->{'role'})) {
					# $_が未定義（ありえないはず）
					$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, 'invalid pl. [setrole.]');
				}
				$_->{'role'} = $i;
				$_->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
			}
		}
	}
	$vil->{'rolediscard'} = join('/',@rolediscard);

	# 割り当て一覧表示（テスト用）#	foreach (@$pllist) {
#		print "[$_->{'uid'}] $rolename->[$_->{'selrole'}] → $rolename->[$_->{'role'}]\n";
#	}
	&SWCommit::StartGM($sow, $vil);
	return $roletable, $gifttable ;
}


#----------------------------------------
# 配分表の取得
#----------------------------------------
sub GetSetRoleTable {
	my ($sow, $vil, $roletable, $plcnt) = @_;

	my ( @roles,@gifts,@eventcard );
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$roles[$i] = 0;
	}
	for ($i = 0; $i < $sow->{'COUNT_GIFT'}; $i++) {
		$gifts[$i] = 0;
	}

	if      ($roletable eq 'default') {
		# 標準配分表の取得
		&GetSetRoleTableDefault($sow, $plcnt, \@roles, \@gifts, \@eventcard );
	} elsif ($roletable eq 'mistery') {
		# 深い霧の夜の表の取得
		&GetSetRoleTableMistery($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'wbbs_c') {
		# Ｃ国配分表の取得
		&GetSetRoleTableWBBS_C($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'wbbs_f') {
		# F国配分表の取得
		&GetSetRoleTableWBBS_F($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'wbbs_g') {
		# G国配分表の取得
		&GetSetRoleTableWBBS_G($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'test1st') {
		# 試験壱型配分表の取得
		&GetSetRoleTableTest1st($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'test2nd') {
		# 試験弐型配分表の取得
		&GetSetRoleTableTest2nd($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'starwars') {
		&GetSetRoleTableStarWars($sow, $plcnt, \@roles, \@gifts, \@eventcard );

	} elsif ($roletable eq 'ocarina') {
		&GetSetRoleTableEssence($sow, $plcnt, \@roles, \@gifts, \@eventcard, 'ROLEID_GURU' );

	} elsif ($roletable eq 'lover') {
		&GetSetRoleTableEssence($sow, $plcnt, \@roles, \@gifts, \@eventcard, 'ROLEID_LOVEANGEL' );

	} elsif ($roletable eq 'hater') {
		&GetSetRoleTableEssence($sow, $plcnt, \@roles, \@gifts, \@eventcard, 'ROLEID_HATEDEVIL' );

	} else {
		# カスタム配分表の取得
		&GetSetRoleTableCustom($sow, $vil, \@roles, \@gifts, \@eventcard );
	}

	return( \@roles, \@gifts, \@eventcard );
}

#----------------------------------------
# 村人人数決定
#----------------------------------------
sub GetSetVillager {
	my ($sow, $plcnt, $roles) = @_;

	my $total = 0;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$total += $roles->[$i];
	}

	# サイモンを引くこと。
	$roles->[$sow->{'ROLEID_VILLAGER'}] = $plcnt - $total - 1;
}


#----------------------------------------
# 標準配分表の取得
#----------------------------------------
sub GetSetRoleTableDefault {
	my ($sow, $plcnt, $roles, $gifts, $eventcard ) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}] = 1;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);
	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt == 10);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt == 11);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 0 if ($plcnt == 12);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 2 if ($plcnt == 13);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 2 if ($plcnt == 14);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 0 if ($plcnt == 15);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt >= 16);
	# 狂信者
	$roles->[$sow->{'ROLEID_FANATIC'}] = 1 if ($plcnt == 12);
	# Ｃ国狂人
	$roles->[$sow->{'ROLEID_WISPER'}] = 1 if ($plcnt == 15);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]  = 1;
	# レオナルド
	$gifts->[$sow->{'GIFTID_DECIDE'}] = 1 if ($plcnt >= 8);

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 10);
	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 8);
	# 聖痕者
	$roles->[$sow->{'ROLEID_STIGMA'}] = 1 if ($plcnt == 13);
	$roles->[$sow->{'ROLEID_STIGMA'}] = 1 if ($plcnt == 14);
	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}


#----------------------------------------
# 深い霧の夜の取得
#----------------------------------------
sub GetSetRoleTableMistery {
	my ($sow, $plcnt, $roles, $gifts, $eventcard ) = @_;

	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}]   = 1 if ($plcnt ==  6);
	$roles->[$sow->{'ROLEID_POSSESS'}]   = 1 if ($plcnt ==  7);
	$roles->[$sow->{'ROLEID_MUPETTING'}] = 1 if ($plcnt ==  9);
	$roles->[$sow->{'ROLEID_MUPETTING'}] = 1 if ($plcnt == 10);
	$roles->[$sow->{'ROLEID_MUPETTING'}] = 1 if ($plcnt == 11);
	$roles->[$sow->{'ROLEID_MUPETTING'}] = 1 if ($plcnt == 12);
	$roles->[$sow->{'ROLEID_JAMMER'}]    = 1 if ($plcnt >= 13);

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]      = 1;
	$roles->[$sow->{'ROLEID_WOLF'}]      = 0 if ( 8 > $plcnt);
	$roles->[$sow->{'ROLEID_LONEWOLF'}]  = 1 if ( 8 > $plcnt);
	$roles->[$sow->{'ROLEID_WOLF'}]      = 2 if ($plcnt ==  8);
	$roles->[$sow->{'ROLEID_WOLF'}]      = 2 if ($plcnt ==  9);
	$roles->[$sow->{'ROLEID_WOLF'}]      = 2 if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_CHILDWOLF'}] = 1 if ($plcnt >= 10);

	# 第三陣営
	$roles->[$sow->{'ROLEID_GURU'}]    = 1 if ($plcnt >= 19);

	# 占い師、気占い師、少女、霊能者
	$roles->[$sow->{'ROLEID_AURA'}]   = 1 if ($plcnt >=  8);
	$roles->[$sow->{'ROLEID_SEER'}]   = 1 if ($plcnt ==  4);
	$roles->[$sow->{'ROLEID_SEER'}]   = 1 if ($plcnt ==  5);
	$roles->[$sow->{'ROLEID_SEER'}]   = 1 if ($plcnt >= 11);
	$roles->[$sow->{'ROLEID_MEDIUM'}] = 1 if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_GIRL'}]   = 1 if ($plcnt >= 17);
	# 守護者、医者
	$roles->[$sow->{'ROLEID_GUARD'}]  = 1 if ($plcnt >=  6);
	$roles->[$sow->{'ROLEID_DOCTOR'}] = 1 if ($plcnt >=  8);
	# 魔女
	$roles->[$sow->{'ROLEID_WITCH'}]  = 1 if ($plcnt >= 15);
	# 錬金術師、賞金稼ぎ、扇動者、呪人
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  5);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  6);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  7);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  8);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt ==  9);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt == 14);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}] = 1 if ($plcnt == 20);
	$roles->[$sow->{'ROLEID_FAN'}]       = 1 if ($plcnt ==  7);
	$roles->[$sow->{'ROLEID_HUNTER'}]    = 1 if ($plcnt >= 12);
	$roles->[$sow->{'ROLEID_HUNTER'}]    = 1 if ($plcnt >= 12);
	$roles->[$sow->{'ROLEID_CURSE'}]     = 1 if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_FAN'}]       = 1 if ($plcnt >= 18);

	# レオナルド
	$gifts->[$sow->{'GIFTID_DECIDE'}] = 1 if ($plcnt >= 7);

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

#----------------------------------------
# Ｃ国配分表の取得
#----------------------------------------
sub GetSetRoleTableWBBS_C {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# Ｃ国狂人
	$roles->[$sow->{'ROLEID_WISPER'}]++ if ($plcnt >= 10);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

sub GetSetRoleTableWBBS_F {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 10);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

sub GetSetRoleTableWBBS_G {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 11);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

#----------------------------------------
# 試験壱型配分表の取得
#----------------------------------------
sub GetSetRoleTableTest1st {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 23);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 10);
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if (($plcnt >= 13) && ($plcnt <= 14)); # 15～18では１人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 19);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 19);

	# 聖痕者
	$roles->[$sow->{'ROLEID_STIGMA'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_STIGMA'}]++ if (($plcnt >= 16) && ($plcnt <= 18));

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

#----------------------------------------
# 試験弐型配分表の取得
#----------------------------------------
sub GetSetRoleTableTest2nd {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 21);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 26);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# 狂信者
	$roles->[$sow->{'ROLEID_FANATIC'}]++ if ($plcnt >= 10);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}

#----------------------------------------
# 小部屋の宇宙戦争の取得
#----------------------------------------
sub GetSetRoleTableStarWars {
	my ($sow, $plcnt, $roles, $gifts, $eventcard ) = @_;

	my @enemy = ('ROLEID_JAMMER','ROLEID_SNATCH','ROLEID_BAT');

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 23);

	# ハムスター人間
	$roles->[$sow->{'ROLEID_HAMSTER'}]++ if ($plcnt >= 16);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_NECROMANCER'}]++ if ($plcnt >= 9);

	# 狂人
	$roles->[$sow->{@enemy[rand(@enemy)]}]++ if  ($plcnt >= 10);
	$roles->[$sow->{@enemy[rand(@enemy)]}]++ if (($plcnt >= 13) && ($plcnt <= 14)); # 15～18では１人
	$roles->[$sow->{@enemy[rand(@enemy)]}]++ if  ($plcnt >= 19);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_WITCH'}] = 1 if ($plcnt >= 19);

	# 聖痕者
	$roles->[$sow->{'ROLEID_ALCHEMIST'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}]++ if (($plcnt >= 16) && ($plcnt <= 18));

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}



#----------------------------------------
# リトル・オーケストラの取得
#----------------------------------------
sub GetSetRoleTableEssence {
	my ($sow, $plcnt, $roles, $gifts, $eventcard, $essence ) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}] = 1;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);
	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt == 10);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt == 11);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 0 if ($plcnt == 12);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 2 if ($plcnt == 13);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 2 if ($plcnt == 14);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 0 if ($plcnt == 15);
	$roles->[$sow->{'ROLEID_POSSESS'}] = 1 if ($plcnt >= 16);
	# 人形遣い
	$roles->[$sow->{'ROLEID_MUPPETING'}] = 1 if ($plcnt == 12);
	# Ｃ国狂人
	$roles->[$sow->{'ROLEID_WISPER'}] = 1 if ($plcnt == 15);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]  = 1;

	# 霊能者
	$roles->[$sow->{'ROLEID_NECROMANCER'}]++ if ($plcnt >= 9);
	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 8);

	# 共有者
	$roles->[$sow->{'ROLEID_WITCH'}] = 1 if ($plcnt >= 19);

	# 聖痕者
	$roles->[$sow->{'ROLEID_ALCHEMIST'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_ALCHEMIST'}]++ if (($plcnt >= 16) && ($plcnt <= 18));
	# 笛吹き
	$roles->[$sow->{$essence}]++  if ($plcnt >= 15);

	# 村人
	&GetSetVillager($sow, $plcnt, $roles);

	return;
}



#----------------------------------------
# カスタム配分表の取得
#----------------------------------------
sub GetSetRoleTableCustom {
	my ($sow, $vil, $roles, $gifts, $eventcard ) = @_;

	my $i;
	my $roleid = $sow->{'ROLEID'};
	for ($i = 1; $i < @$roleid; $i++) {
		$roles->[$i] = $vil->{"cnt$roleid->[$i]"};
	}
	$roles->[1]--; # ダミーキャラの分

	my $giftid = $sow->{'GIFTID'};
	for ($i = 2; $i < @$giftid; $i++) {
		$gifts->[$i] = $vil->{"cnt$giftid->[$i]"};
	}

	my $eventid = $sow->{'EVENTID'};
	for ($i = 1; $i < @$eventid; $i++) {
		$eventcard->[$i] = $vil->{"cnt$eventid->[$i]"};
	}

	return;
}

1;

