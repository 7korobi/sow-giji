package SWDocRoleAspect;

#----------------------------------------
# 遊び方
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => '能力とルールの細かい特徴', # タイトル
	};

	return bless($self, $class);
}

sub outhtml {
	my $self   = shift;
	my $sow    = $self->{'sow'};
	my $cfg    = $sow->{'cfg'};
	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $mob    = $sow->{'basictrs'}->{'MOB'};
	my $mobodr = $mob->{'ORDER'};
	my $query  = $sow->{'query'};
	my $docid = "css=$query->{'css'}&trsid=$query->{'trsid'}";

	print <<"_HTML_";
<DIV class=toppage>
_HTML_
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, 0);
	$vil->createdummyvil();
	$vil->{'csid'}  = $sow->{'cfg'}->{'DEFAULT_CSID'};
	$vil->{'trsid'} = $sow->{'query'}->{'trsid'};
	$vil->{'game'}  = $sow->{'query'}->{'game'};
	$vil->{'saycnttype'} = 'juna';
	$vil->{'turn'} = 1;
	$vil->{'winner'} = 0;
	$vil->{'randomtarget'} = 1;
	$vil->{'makeruid'} = $sow->{'cfg'}->{'USERID_ADMIN'};

	&SWBase::LoadTextRS($sow, $vil);
	print <<"_HTML_";
<h2><a $atr_id="rolerule">能\力とルールの細かい特徴</a></h2>
<p class="paragraph">
能\力、恩恵ごとの、細かいルールは下の表\のようになります。参考にしましょう。
</p>
<ul>
  <li>襲撃⇒選択可？　　「選」の振られた役職は、襲撃の対象に選ばれます。</li>
  <li>襲撃⇒結果　　もしその役職で襲撃されるとどうなるか。</li>
  <li>占・霊\能\力⇒作用　　占われたときに特別なことがおこるか、なにがおこるか。</li>
  <li>占・霊\能\力⇒占/オーラ/役職　　占い結果/オーラ占い結果/役職占い結果がどうなるか。</li>
  <li>気配　　その役職になったとき、周囲に発する気配。</li>
  <li>寿命に関わる狼人数　　生存者が何名○にあてはまるかが、予\言\者や風化妖精の寿命を決める。</li>
  <li>生存人数カウント　　人間一人、と数えるのか、人狼ひとり、と数えるのか、どちらにも数えないのか。</li>
  <li>勝利条件　　どの条件で終了したとき、勝利するのか</li>
</ul>
<table class=vindex>
<thead>
<tr><td rowspan=3><td rowspan=3>ログ<td colspan=2>襲撃<td rowspan=2 colspan=4>占・霊能\力判定結果<td rowspan=3>気配<td colspan=3 class=sayfilter_incontent>寿命に関わる狼人数
<tr class=small><td colspan=2>選択可？<td><td colspan=2>生存人数カウント
<tr class=small><td><td>結果<td>作用<td>占<td>オーラ<td>役職<td><td><td>勝利条件
</thead>
<tbody class=small>
_HTML_

	my $rolename = $sow->{'textrs'}->{'ROLENAME'};
	my $giftname = $sow->{'textrs'}->{'GIFTNAME'};

	# 見物人
	my $mobpl = SWPlayer->new($sow);
	$mobpl->createpl('a98');
	$mobpl->{'pno'}       = 98;
	$mobpl->{'csid'}      = $vil->{'csid'};
	$mobpl->{'cid'}       = $order->[-2];
	$mobpl->{'selrole'}   = $sow->{'ROLEID_MOB'};
	$mobpl->{'gift'}      = 1;
	$mobpl->{'role'}      = $sow->{'ROLEID_MOB'};
	$mobpl->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
	$mobpl->{'live'}      = 'live' ;
	$mobpl->{'deathday'}  =  -1;
	$vil->addpl($mobpl);   # 村へ追加
	$mobpl->setsaycount(); # 発言数初期化
	$mobpl->{'title'}     = '見物人';

	my %sayswitch = (
		sympathy => '共鳴',
		wolf     => '人狼',
		pixi     => '念話',
		muppet   => '憑依',
	);

	for ($j = 1; $j <= @$giftname; $j++) {
		for ($i = 1; $i <= @$rolename; $i++) {

			$mobpl->{'role'}      = $i;
			$mobpl->{'gift'}      = $j;
			$mobpl->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};

			next if  ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
			next if (( '' eq $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$j] )&&($j != $sow->{'GIFTID_NOT_HAVE'}));
			next if ($j == $sow->{'GIFTID_DECIDE'});
			next if (($j < $sow->{'SIDEST_DEAL'})&&($j != $sow->{'GIFTID_NOT_HAVE'}));
			next if (($l==1)&&( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$sow->{'ROLEID_LOVEANGEL'}] ));
#			next if (($j == $sow->{'GIFTID_SHIELD'})&&( $mobpl->ispixi()));
#			next if (($j == $sow->{'GIFTID_SHIELD'})&&( $mobpl->isenemy()));
#			next if (($j == $sow->{'GIFTID_SHIELD'})&&( $mobpl->iswolf()));

			my $saylogrole = $sayswitch{$sow->{'ROLESAYSWITCH'}->[$i]};
			my $sayloggift = $sayswitch{$sow->{'GIFTSAYSWITCH'}->[$j]};
			my $saylog     = join(" ",($saylogrole,$sayloggift));
			my $winlnk = $cfg->{'URL_WIN'}.uc($mobpl->win_if());
			my $win    = '<a href="'.$winlnk.'">'.$sow->{'textrs'}->{'ROLEWIN'}->{$mobpl->win_if()}.'</a>';

			my $count='';
			if      ($mobpl->ishuman() > 0) {
				$count = '人';
			} elsif ($mobpl->ispixi()  > 0) {
				$count = '';
			} elsif ($mobpl->iswolf()  > 0) {
				$count = '狼';
			} else {
				$count = '人';
			}

			my $droop='';
			$droop   = '○'   if ( $mobpl->iswolf());

			my $kill='死亡';
			$kill = '負傷'   if ($mobpl->{'role'} == $sow->{'ROLEID_ELDER'});
			$kill = '負傷'   if ($mobpl->{'role'} == $sow->{'ROLEID_WEREDOG'});
			$kill = '人狼化' if ($mobpl->{'role'} == $sow->{'ROLEID_SEMIWOLF'});
			$kill = '生存'   if ($mobpl->{'role'} == $sow->{'ROLEID_LONEWOLF'});
			$kill = '生存'   if ($mobpl->iscursed('role')+$mobpl->iscursed('gift') );
			$kill = '生存'   if ($mobpl->{'gift'} == $sow->{'GIFTID_SHIELD'});

			my $killtarget = '選';
			$killtarget = '' if ($mobpl->iskiller('role')+$mobpl->iskiller('gift') );
			$killtarget = '' if ( $mobpl->{'role'} == $sow->{'ROLEID_MIMICRY'}     );

			my $sense='';
			$sense = $rolename->[$i] if( $mobpl->{'role'} == $sow->{'ROLEID_FM'} );
			$sense = $rolename->[$i] if( $mobpl->{'role'} == $sow->{'ROLEID_SYMPATHY'} );
			$sense .= ' 妖精'      if(   $mobpl->iscursed('role')+$mobpl->iscursed('gift') );
			$sense .= ' 人狼'      if( ( $mobpl->iskiller('role')+$mobpl->iskiller('gift') )
			                         ||( $mobpl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'}    )
			                         ||( $mobpl->{'role'} == $sow->{'ROLEID_MIMICRY'}      ) );

			my $result = '';
			$result .= '死亡' if( $mobpl->iscursed('role')+$mobpl->iscursed('gift') );
			$result .= ' 呪返' if ($mobpl->{'role'} == $sow->{'ROLEID_CURSE'});
			$result .= ' 呪返' if ($mobpl->{'role'} == $sow->{'ROLEID_CURSEWOLF'});

			my $role = $rolename->[$i];

			my $aura='能力者';
			$aura = 'なし'  if ($mobpl->{'role'} == $sow->{'ROLEID_VILLAGER'});
			$aura = 'なし'  if ($mobpl->{'role'} == $sow->{'ROLEID_WOLF'});
			$aura = 'なし' if  ($mobpl->iscanrole(  $sow->{'ROLEID_WHITEWOLF'}));

			my $seer_result = 1;
			# 人狼判定。役職が人狼、恩恵が人狼、一匹狼、狼血族。ゾンビ。また、白狼は人間判定。
			$seer_result = 2 if  ($targetpl->iskiller('role')); # 人狼勢力
			$seer_result = 2 if  ($targetpl->iskiller('gift')); # 人狼勢力
			$seer_result = 2 if  ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # ゾンビにされました。
			$seer_result = 2 if  ($targetpl->{'role'} == $sow->{'ROLEID_LONEWOLF'}  );
			$seer_result = 2 if  ($targetpl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'} );
			$seer_result = 1 if  ($targetpl->iscanrole(  $sow->{'ROLEID_WHITEWOLF'}));
			my $seer=('','人','狼')[$seer_result];

			my $rolelnk  =  $cfg->{'URL_ROLE'}.uc($sow->{'ROLEID'}->[$i]);
			my $giftlnk  =  $cfg->{'URL_GIFT'}.uc($sow->{'GIFTID'}->[$j]);

			my $head = '<a href="'.$rolelnk.'">'.$rolename->[$i].'</a>';
			$head .= "、".'<a href="'.$giftlnk.'">'.$giftname->[$j].'</a>' if ( '' ne $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$j] );

			print "<tr><td>$head<td>$saylog<td>$killtarget<td>$kill<td>$result<td>$seer<td>$aura<td>$role<td>$sense<td>$droop<td>$count<td>$win\n";
			if ( $mobpl->{'role'} == $sow->{'ROLEID_WHITEWOLF'} ){
				$head = '　※能力なし';
				$seer = '狼';
				print "<tr><td>$head<td>$saylog<td>$killtarget<td>$kill<td>$result<td>$seer<td>$aura<td>$role<td>$sense<td>$droop<td>$count<td>$win\n";
			}
			if ( $mobpl->{'role'} == $sow->{'ROLEID_GIRL'} ){
				$head = '　※夜遊び中';
				$kill = '恐怖死';
				print "<tr><td>$head<td>$saylog<td>$killtarget<td>$kill<td>$result<td>$seer<td>$aura<td>$role<td>$sense<td>$droop<td>$count<td>$win\n";
			}
		}
	}

	print '<tr><td>邪気になった<td colspan=10>邪気になる以前と同じ<td><a href="'.$cfg->{'URL_WIN'}.'WIN_HATER">'.$sow->{'textrs'}->{'ROLEWIN'}->{'WIN_HATER'}.'</a>' if ( '' ne $sow->{'textrs'}->{'ROLESHORTNAME'}->[$sow->{'ROLEID_HATEDEVIL'}] );
	print '<tr><td>恋人になった<td colspan=10>恋人になる以前と同じ<td><a href="'.$cfg->{'URL_WIN'}.'WIN_LOVER">'.$sow->{'textrs'}->{'ROLEWIN'}->{'WIN_LOVER'}.'</a>' if ( '' ne $sow->{'textrs'}->{'ROLESHORTNAME'}->[$sow->{'ROLEID_LOVEANGEL'}] );
	print <<"_HTML_";
</tbody>
</table>

<h3><a $atr_id="ending">勝敗の決定</a></h3>
<p class="paragraph">
村人側が人狼を全滅させるか、人間の人数が人狼の人数と同じまたはそれ以下にまで減るか、そのどちらかの条件を満たすと勝負が終わります。人間に数える役職、人狼に数える役職については<a href="#rolerule">こちらを見ましょう</a>。<br$net>
</p>

<p class="paragraph">
勝負が終わると、生き残りの人数や、特定の役が生きているか、どのように死んだのかによって、勝敗が決定します。結果によって勝利宣言がなされ、全員のIDと割り当てられた能\力が公開されます。また、独り言や囁きなど、勝負の最中には他人に見えないようになっていた発言も公開されます。
</p>

<table class=vindex>
<thead>
<tr>
<th scope="col">勝敗</th>
<th scope="col">勝利宣言</th>
</tr>
</thead>
<tbody class=sayfilter_incontent>
_HTML_
	
	my $announce_winner = $sow->{'textrs'}->{'ANNOUNCE_WINNER'};
	for( $i=1; $i< @$announce_winner; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'CAPTION_WINNER'}->[$i] );
		my $name    = $sow->{'textrs'}->{'CAPTION_WINNER'}->[$i];
		my $explain = $sow->{'textrs'}->{'ANNOUNCE_WINNER'}->[$i];
		$name = "みんな踊って<br>　".$name if ( $i == $sow->{'WINNER_PIXI'}   );
		$name = "村人の陰で<br>　".$name  if ( $i == $sow->{'WINNER_PIXI_H'} );
		$name = "人狼の陰で<br>　".$name if ( $i == $sow->{'WINNER_PIXI_W'} );
		$name = "勝利者なし" if ( $i == $sow->{'WINNER_NONE'} );
	print <<"_HTML_";
<tr>
<td nowrap>$name</td>
<td>$explain</td>
</tr>
_HTML_
	}
	
	print <<"_HTML_";
<tr>
<td><td>
</tr>
<tr>
<td nowrap>+据え膳も勝利</td>
<td>$sow->{'textrs'}->{'ANNOUNCE_WINNER_DISH'}</td>
</tr>
</tbody>
</table>

<p class="paragraph">
ここからはエピローグの時間です。明かされた全ての発言などを話の種にして、みんなで色々笑ったり嘆いたりしましょう。楽しくて別れ難いなら、村建て人さんは更新を延長してもいいでしょう。お疲れ様でした。
</p>
<hr class="invisible_hr"$net>
</DIV>
_HTML_

}

1;
