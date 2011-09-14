package SWValidityMakeVil;

#----------------------------------------
# 村作成・編集時値チェック
#----------------------------------------
sub CheckValidityMakeVilSummary {
	my $sow = shift;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "村の作成はできません。", "cannot vmake.$errfrom") if ($sow->{'cfg'}->{'ENABLED_VMAKE'} == 0);

	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'vname'}, 'VNAME', 'vname', '村の名前', 1);
}

sub CheckValidityMakeVil {
	my $sow = shift;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	&CheckValidityMakeVilSummary($sow);

	$query->{'vcomment'} = '' if ($query->{'vcomment'} eq $sow->{'basictrs'}->{'NONE_TEXT'});
	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'vcomment'}, 'VCOMMENT', 'vcomment', '村の説明', 1);

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '文字列リソースが未選択です。', "no trsid.$errfrom") if ($query->{'trsid'} eq '');
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '登場人物が未選択です。', "no csid.$errfrom") if ($query->{'csid'} eq ''); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '役職配分が未選択です。', "no roletable.$errfrom") if ($query->{'roletable'} eq ''); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '投票方法が未選択です。', "no votetype.$errfrom") if ($query->{'votetype'} eq ''); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新時間（時）が未選択です。', "no hour.$errfrom") if (!defined($query->{'hour'})); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新時間（時）は0～23の範囲で選んで下さい。', "invalid hour.$errfrom") if (($query->{'hour'} < 0) || ($query->{'hour'} > 23)); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新時間（分）が未選択です。', "no minite.$errfrom") if (!defined($query->{'minite'})); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新時間（分）は0～59の範囲で選んで下さい。', "invalid minite.$errfrom") if (($query->{'minite'} < 0) || ($query->{'minite'} > 59)); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新間隔が未選択です。', "no updinterval.$errfrom") if (!defined($query->{'updinterval'})); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新間隔は1～3の範囲で選んで下さい。', "invalid updinterval.$errfrom") if (($query->{'updinterval'} < 1) || ($query->{'updinterval'} > 3)); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '定員が未入力です。', "no vplcnt.$errfrom") if (!defined($query->{'vplcnt'}));
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "定員は$sow->{'cfg'}->{'MINSIZE_VPLCNT'}～$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}の範囲で入力して下さい。", "invalid vplcnt.$errfrom") if (($query->{'vplcnt'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'}) || ($query->{'vplcnt'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'}));
	if ($query->{'starttype'} eq 'wbbs') {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '最低人数が未入力です。', "no vplcntstart.$errfrom") if (!defined($query->{'vplcntstart'}));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "最低人数は$sow->{'cfg'}->{'MINSIZE_VPLCNT'}～$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}の範囲で入力して下さい。", "invalid vplcntstart.$errfrom") if (($query->{'vplcntstart'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'}) || ($query->{'vplcntstart'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'}));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '開始方法が人狼BBS型で役職配分自由設定の場合、最低人数と定員を同じ人数にしてください。', "vplcnt != vplcntstart.$errfrom") if (($query->{'vplcntstart'} != $query->{'vplcnt'}) && ($query->{'roletable'} eq 'custom'));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '最低人数は定員以下の人数で入力して下さい。', "too many vplcntstart.$errfrom") if ($query->{'vplcntstart'} > $query->{'vplcnt'});
	}

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '発言制限が未選択です。', "no saycnttype.$errfrom") if ($query->{'saycnttype'} eq ''); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '非対応の参加制限を選択しています。', "invalid entrylimit.$errfrom") if (($query->{'entrylimit'} ne 'free') && ($query->{'entrylimit'} ne 'password')); # 通常起きない
	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'entrypwd'}, 'PASSWD', 'entrypwd', '参加パスワード', 1) if ($query->{'entrylimit'} eq 'password');

	my $roleid = $sow->{'ROLEID'};
	my $giftid = $sow->{'GIFTID'};
	my $total     = 0;
	my $vplcnt    = $query->{'vplcnt'};

	if( 'custom' eq $query->{'roletable'} ){
		my $i;
		for ($i = 1; $i < @$roleid; $i++) {
			next if ( $i == $sow->{'ROLEID_MOB'} );
			my $count = 0;
			$count = $query->{"cnt$roleid->[$i]"} if (defined($query->{"cnt$roleid->[$i]"}));
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '役職配分の人数は0以上を入力して下さい。', "invalid role count.[$roleid->[$i] = $count] $errfrom") if ($count < 0);
			$total += $count;
		}
		for ($i = 1; $i < @$giftid; $i++) {
			my $count = 0;
			$count = $query->{"cnt$giftid->[$i]"} if (defined($query->{"cnt$giftid->[$i]"}));
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '役職配分の人数は0以上を入力して下さい。', "invalid gift count.[$giftid->[$i] = $count] $errfrom") if ($count < 0);
		}
	}
	my $mobs = $query->{'cntmob'}         if (defined($query->{'cntmob'}));

	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
	# 役職配分を取得
	my ($roletable, $gifttable, $eventtable ) = &SWSetRole::GetSetRoleTable($sow, $query, $query->{'roletable'}, $query->{'vplcnt'});

	# 人狼の数
	my $wolves = 0;
	$wolves += $roletable->[$sow->{'ROLEID_WOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_AURAWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_INTWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_CURSEWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_WHITEWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_CHILDWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_DYINGWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_SILENTWOLF'}];
	$wolves += $roletable->[$sow->{'ROLEID_HEADLESS'}];
	$wolves += $roletable->[$sow->{'ROLEID_LONEWOLF'}];
	$wolves += $gifttable->[$sow->{'GIFTID_OGRE'}];
	my $pixies = 0;
	$pixies += $roletable->[$sow->{'ROLEID_HAMSTER'}];
	$pixies += $roletable->[$sow->{'ROLEID_MIMICRY'}];
	$pixies += $roletable->[$sow->{'ROLEID_DYINGPIXI'}];
	$pixies += $roletable->[$sow->{'ROLEID_TRICKSTER'}];
	$pixies += $gifttable->[$sow->{'GIFTID_FAIRY'}];
	my $others = 0;
	$others += $roletable->[$sow->{'ROLEID_HATEDEVIL'}];
	$others += $roletable->[$sow->{'ROLEID_LOVEANGEL'}];
	$others += $roletable->[$sow->{'ROLEID_GURU'}];
	my $dishes = 0;
	$dishes += $roletable->[$sow->{'ROLEID_DISH'}];
	my $cntrobber = $roletable->[$sow->{'ROLEID_ROBBER'}];
	my $giftitems = 0;
	$giftitems += $gifttable->[$sow->{'GIFTID_SHIELD'}];
	$giftitems += $gifttable->[$sow->{'GIFTID_GLASS' }];
	my $giftappends = 0;
	$giftappends += $gifttable->[$sow->{'GIFTID_DECIDE'}];
	$giftappends += $gifttable->[$sow->{'GIFTID_SEERONCE'}];
	my $giftsides = 0;
	$giftsides += $gifttable->[$sow->{'GIFTID_OGRE'} ];
	$giftsides += $gifttable->[$sow->{'GIFTID_FINK'} ];
	$giftsides += $gifttable->[$sow->{'GIFTID_FAIRY'}];
	$giftsides += $eventtable->[$sow->{'EVENTID_TURN_FINK'}];
	$giftsides += $eventtable->[$sow->{'EVENTID_TURN_FAIRY'}];

	# 共通
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, 'ダミーキャラの分、村人は最低 1 人入れてください。', "no villagers. $errfrom") if ($roletable->[$sow->{'ROLEID_VILLAGER'}] < 0);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "聖痕者は $sow->{'cfg'}->{'MAXCOUNT_STIGMA'} 人までです。", "too many stigma. $errfrom") if ($sow->{'cfg'}->{'MAXCOUNT_STIGMA'} < $roletable->[$sow->{'ROLEID_STIGMA'}]);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼がいません。', "no wolves. $errfrom") if ($wolves <= 0);

	# 恩恵の、排他制約
	if      (0 < $giftitems){
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '光の輪や魔鏡と、勝利条件が変わる恩恵は共存できません。', "exclusion shield. $errfrom") if (0 < $giftsides);
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '光の輪や魔鏡と、能力を加える恩恵は共存できません。', "exclusion shield. $errfrom") if (0 < $giftappends);
	} elsif (0 < $giftappends){
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '能力を加える恩恵と、勝利条件が変わる恩恵は共存できません。', "exclusion appendex. $errfrom") if (0 < $giftsides);
	}


	if( 'custom' eq $query->{'roletable'} ){
		my $diff =  $total - $cntrobber - $vplcnt;
		if (0 < $cntrobber){
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '役職配分の合計人数'."($total人)".'が定員'."($vplcnt人)".'に'."($diff)".'人足りません。', "invalid vplcnt or total plcnt.[$vplcnt + $cntrobber < $total] $errfrom") if ( $diff < 0 );
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼が盗賊より多くなっていません。', "too many robbers than wolves . $errfrom") if ( $wolves <= $cntrobber  );
		} else {
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '役職配分の合計人数'."($total人)".'が定員'."($vplcnt人)".'と異なります。', "invalid vplcnt or total plcnt.[$vplcnt != $total] $errfrom") if ( $diff != 0 );
		}
	}


	$isjuror        = 0;
	$isjuror        = 1 if ('juror'             eq $query->{'mob'});
	$isdeadlose     = 0;
	$ismillerhollow = 0;
	$istabula       = 0;
	$istabula       = 1 if ('TABULA'            eq $query->{'game'});
	$istabula       = 1 if ('LIVE_TABULA'       eq $query->{'game'});
	$ismillerhollow = 1 if ('MILLERHOLLOW'      eq $query->{'game'});
	$ismillerhollow = 1 if ('LIVE_MILLERHOLLOW' eq $query->{'game'});
	$ismillerhollow = 1 if ('MISTERY'           eq $query->{'game'});
	$isdeadlose     = 1 if ('LIVE_TABULA'       eq $query->{'game'});
	$isdeadlose     = 1 if ('LIVE_MILLERHOLLOW' eq $query->{'game'});
	$isdeadlose     = 1 if ('TROUBLE'           eq $query->{'game'});
	if ( $istabula ){
		# タブラの人狼特有のチェック
		if ($wolves *2 + 1 >= ($vplcnt - $pixies )) {
			if ($others > 0) {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼が多すぎます。', "too many wolves and pixies. $errfrom");
			} elsif ($pixies > 0) {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼が多すぎます（妖精は人間にも人狼にもカウントされません）。', "too many wolves and pixies. $errfrom");
			} else {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼が多すぎます。', "too many wolves. $errfrom");
			}
		}
	}

	if ( $isdeadlose ){
		# 「死んだら負け」特有のチェック
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '据え膳は勝利できません。', "DISH can't win. $errfrom") if (0 < $dishes );
	}
	
	if ( $ismillerhollow ){
		# ミラーズホロー特有のチェック
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, 'ダミーキャラ以外に、村人は最低 1 人入れてください。', "no villagers. $errfrom") if ($roletable->[$sow->{'ROLEID_VILLAGER'}] < 1);
	}

	if ( $isjuror ){
		# 陪審員制度特有のチェック
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '最低 1 人、陪審員を入れてください。', "no Juror. $errfrom") if (0 == $mobs );
	}
	

	return;
}

1;