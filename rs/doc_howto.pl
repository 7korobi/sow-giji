package SWDocHowTo;

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
		title => '遊び方', # タイトル
	};

	return bless($self, $class);
}

#---------------------------------------------
# 遊び方の表示
#---------------------------------------------
sub outhtml {
	my $self   = shift;
	my $sow    = $self->{'sow'};
	my $cfg    = $sow->{'cfg'};
	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $query  = $sow->{'query'};
	my $docid = "css=$query->{'css'}&trsid=$query->{'trsid'}";

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, 0);
	$vil->createdummyvil();
	$vil->{'csid'}  = $sow->{'cfg'}->{'DEFAULT_CSID'};
	$vil->{'trsid'} = $sow->{'query'}->{'trsid'};
	$vil->{'saycnttype'} = 'juna';
	$vil->{'turn'} = 1;
	$vil->{'winner'} = 0;
	$vil->{'randomtarget'} = 1;
	$vil->{'makeruid'} = $sow->{'cfg'}->{'USERID_ADMIN'};

	my $enemy = "WIN_WOLF";
	$enemy    = "WIN_EVIL" if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );

	&SWBase::LoadTextRS($sow, $vil);

	print <<"_HTML_";
<script>
gon.items = [
{ _id: "howto-paragraph--20",
  log: '村には、様々な特殊能力を持つ者（または持たない者）がいます。\\
その多くは村側の能力者、いくらかは人狼側の能力者、もしかしたら、それ以外の陣営の者もいるかもしれません。\\
<a class="btn edge" href="sow.cgi?cmd=roleaspect&$docid">能力、恩恵ごとの、細かい特徴</a>を参考にしましょう。\\
また、\\
<a class="btn edge" href="sow.cgi?cmd=rolelist&$docid">役職とインターフェース</a>\\
で、ゲーム中の操作盤や結果表示をみることができます。'
},
{ _id: "howto-head-h3-31",
  log: 'RAILS.winner.$enemy.CAPTION-HUMAN'
},
{ _id: "howto-paragraph--32",
  log: '村には善良な村人達の他に、人間でありながら敵に回る裏切り者達もいます。夜はあなたたちの時間です。'
},
{ _id: "howto-paragraph--33",
  log: 'RAILS.winner.$enemy.HELP'
}
];

</script>

<div class="message_filter" id="item-howto"></div>

<div id="filter_role">
<table border="1" class="table" summary="能\力者一覧（村側）">
<thead>
  <tr>
    <th scope="col">能\力</th>
    <th scope="col">説明</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_HUMANSIDE'}; $i<$sow->{'SIDEED_HUMANSIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain .= '<br><b>（占われると、正体を自覚し表示が増えます）</b><br>'.$sow->{'textrs'}->{'RESULT_RIGHTWOLF'} if ($sow->{'ROLEID_RIGHTWOLF'} == $i);
		$explain =~ s/_ROLESUBID_/色のついた/g if ($sow->{'ROLEID_STIGMA'}    == $i);

	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}

	print <<"_HTML_";
</tbody>
</table>
</div>
</div>
<hr class="invisible_hr"$net>

<div id="filter_roleenemy">
<table border="1" class="table" summary="能\力者一覧（$enemy）">
<thead>
  <tr>
    <th scope="col">能\力</th>
    <th scope="col">説明</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_ENEMY'}; $i<$sow->{'SIDEED_ENEMY'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain =~ s/_NPC_/さいしょの犠牲者/g if ($sow->{'ROLEID_MUPPETING'} == $i);

	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
</div>
<hr class="invisible_hr"$net>

<div id="filter_rolewolf">
<table border="1" class="table" summary="能\力者一覧（人狼側）">
<thead>
  <tr>
    <th scope="col">能\力</th>
    <th scope="col">説明</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_WOLFSIDE'}; $i<$sow->{'SIDEED_WOLFSIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain =~ s/_NPC_/さいしょの犠牲者/g if ($sow->{'ROLEID_MUPPETING'} == $i);

	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<div id="filter_rolepixi">
<table border="1" class="table" summary="能\力者一覧（第三勢力）">
<thead>
  <tr>
    <th scope="col">能\力</th>
    <th scope="col">説明</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_PIXISIDE'}; $i<$sow->{'SIDEED_PIXISIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<div id="filter_roleother">
<table border="1" class="table" summary="能\力者一覧（その他）">
<thead>
  <tr>
    <th scope="col">能\力</th>
    <th scope="col">説明</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_OTHER'}; $i<$sow->{'SIDEED_OTHER'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain .= '<br><b>（盗賊入りの村の注意点）</b><br>盗賊がいる村を遊ぶには、人数より多めの量の役職を指定します。例えば、10人の村に13人の役職が指定してあれば、3人分の役職が、「誰もならなかった残り役職」です。' if ($sow->{'ROLEID_ROBBER'} == $i);
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<div id="filter_rolegift">
<table border="1" class="table" summary="恩恵一覧">
<thead>
  <tr>
    <th scope="col">恩恵</th>
    <th scope="col">説明</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'GIFTID_DEAL'}; $i<$sow->{'COUNT_GIFT'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&giftid=GIFTID_".uc($sow->{'GIFTID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'GIFTNAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_gift'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<div id="filter_event">
<table border="1" class="table" summary="事件一覧">
<thead>
  <tr>
    <th scope="col">事件</th>
    <th scope="col">説明</th>
  </tr>
</thead>

<tbody>
_HTML_
	# ダミーデータの生成
	for( $i=1; $i<$sow->{'COUNT_EVENT'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'EVENTNAME'}->[$i] );
		my $name    = $sow->{'textrs'}->{'EVENTNAME'}->[$i];
		my $explain = $sow->{'textrs'}->{'EXPLAIN_EVENT'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<table class=table>
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
</div>
<hr class="invisible_hr"$net>
</div>
</DIV>
_HTML_

}

1;
