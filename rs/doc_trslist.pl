package SWDocTrsList;

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => "ゲーム内での文章一覧", # タイトル
	};

	return bless($self, $class);
}

#----------------------------------------
# 役職配分表のHTML出力
#----------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	print <<"_HTML_";
<hr class="invisible_hr"$net>
<h2>ゲーム内での文章一覧</h2>

<p>
　ゲーム内で現れる文章の一覧です。参考にどうぞ。
</p>
_HTML_

	my %vil = (
		trsid => $sow->{'query'}->{'trsid'},
	);
	&SWBase::LoadTextRS($sow, \%vil);
	my $textrs = $sow->{'textrs'};
	
	my $announce_roles = $textrs->{'ANNOUNCE_ROLE'}->[0];
	my $announce_role = 
			 "●●".$textrs->{'ANNOUNCE_ROLE'}->[1]."●".$textrs->{'ANNOUNCE_ROLE'}->[2]
			       .$textrs->{'ANNOUNCE_ROLE'}->[3]
			."●●".$textrs->{'ANNOUNCE_ROLE'}->[1]."●".$textrs->{'ANNOUNCE_ROLE'}->[2]
	;
	$announce_roles =~ s/_ROLE_/$announce_role/g;
	my $announce_lives = 
			 $textrs->{'ANNOUNCE_LIVES'}->[0]
			."●●".$textrs->{'ANNOUNCE_LIVES'}->[1]
			."●●".$textrs->{'ANNOUNCE_LIVES'}->[2]
	;
	my $result_seer1 = $textrs->{'RESULT_SEER'}->[0];
	my $result_seer2 = $textrs->{'RESULT_SEER'}->[0];
	my $result_seer3 = $textrs->{'RESULT_SEER'}->[0];
	my $result_seer4 = $textrs->{'RESULT_SEER'}->[0];
	my $result_seer5 = $textrs->{'RESULT_SEER'}->[0];
	my $result_seer6 = $textrs->{'RESULT_SEER'}->[0];
	my $result_seer7 = $textrs->{'RESULT_SEER'}->[0];
	my $result_seer8 = $textrs->{'RESULT_SEER'}->[0];
	my $result_seer_1 = $textrs->{'RESULT_SEER'}->[1];
	my $result_seer_2 = $textrs->{'RESULT_SEER'}->[2];
	my $result_seer_3 = $textrs->{'RESULT_SEER'}->[3];
	my $result_seer_4 = $textrs->{'RESULT_SEER'}->[4];
	my $result_seer_5 = $textrs->{'RESULT_SEER'}->[5];
	my $result_seer_6 = $textrs->{'RESULT_SEER'}->[6];
	my $result_seer_7 = $textrs->{'RESULT_SEER'}->[7];
	my $result_seer_8 = $textrs->{'RESULT_SEER'}->[8];
	$result_seer1 =~ s/_RESULT_/$result_seer_1/g;
	$result_seer2 =~ s/_RESULT_/$result_seer_2/g;
	$result_seer3 =~ s/_RESULT_/$result_seer_3/g;
	$result_seer4 =~ s/_RESULT_/$result_seer_4/g;
	$result_seer5 =~ s/_RESULT_/$result_seer_5/g;
	$result_seer6 =~ s/_RESULT_/$result_seer_6/g;
	$result_seer7 =~ s/_RESULT_/$result_seer_7/g;
	$result_seer8 =~ s/_RESULT_/$result_seer_8/g;
	my $avictory0 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $avictory1 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $avictory2 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $avictory3 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $avictory4 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $avictory5 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $avictory6 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $avictory7 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $avictory8 = $textrs->{'ANNOUNCE_EPILOGUE'};
	my $victory1 = $textrs->{'ANNOUNCE_VICTORY'};
	my $victory2 = $textrs->{'ANNOUNCE_VICTORY'};
	my $victory3 = $textrs->{'ANNOUNCE_VICTORY'};
	my $victory4 = $textrs->{'ANNOUNCE_VICTORY'};
	my $victory5 = $textrs->{'ANNOUNCE_VICTORY'};
	my $victory6 = $textrs->{'ANNOUNCE_VICTORY'};
	my $victory7 = $textrs->{'ANNOUNCE_VICTORY'};
	my $victory8 = $textrs->{'ANNOUNCE_VICTORY'};
	my $victory_c0 = $textrs->{'CAPTION_WINNER'}->[0];
	my $victory_c1 = $textrs->{'CAPTION_WINNER'}->[1];
	my $victory_c2 = $textrs->{'CAPTION_WINNER'}->[2];
	my $victory_c3 = $textrs->{'CAPTION_WINNER'}->[3];
	my $victory_c4 = $textrs->{'CAPTION_WINNER'}->[4];
	my $victory_c5 = $textrs->{'CAPTION_WINNER'}->[5];
	my $victory_c6 = $textrs->{'CAPTION_WINNER'}->[6];
	my $victory_c7 = $textrs->{'CAPTION_WINNER'}->[7];
	my $victory_c8 = $textrs->{'CAPTION_WINNER'}->[8];
	$victory1 =~ s/_VICTORY_/$victory_c1/g;
	$victory2 =~ s/_VICTORY_/$victory_c2/g;
	$victory3 =~ s/_VICTORY_/$victory_c3/g;
	$victory4 =~ s/_VICTORY_/$victory_c4/g;
	$victory5 =~ s/_VICTORY_/$victory_c5/g;
	$victory6 =~ s/_VICTORY_/$victory_c6/g;
	$victory7 =~ s/_VICTORY_/$victory_c7/g;
	$victory8 =~ s/_VICTORY_/$victory_c8/g;
	$avictory0 =~ s/_AVICTORY_/$victory_c0/g;
	$avictory1 =~ s/_AVICTORY_/$victory1/g;
	$avictory2 =~ s/_AVICTORY_/$victory2/g;
	$avictory3 =~ s/_AVICTORY_/$victory3/g;
	$avictory4 =~ s/_AVICTORY_/$victory4/g;
	$avictory5 =~ s/_AVICTORY_/$victory5/g;
	$avictory6 =~ s/_AVICTORY_/$victory6/g;
	$avictory7 =~ s/_AVICTORY_/$victory7/g;
	$avictory8 =~ s/_AVICTORY_/$victory8/g;
	my @infos = (
		['info',    	$textrs->{'ANNOUNCE_FIRST'}->[0],],
		['info',    	$textrs->{'ANNOUNCE_FIRST'}->[1],],
		['info',    	$textrs->{'ANNOUNCE_FIRST'}->[2],],
		['info',    	$announce_roles,],
		['info',    	$announce_lives,],
		['infosp',  	$textrs->{'ANNOUNCE_VOTE'}->[0],],
		['info',    	$textrs->{'ANNOUNCE_VOTE'}->[1],],
		['info',    	$textrs->{'ANNOUNCE_VOTE'}->[2],],
		['info',    	$textrs->{'ANNOUNCE_VOTE'}->[3],],
		['info',    	$textrs->{'ANNOUNCE_VOTE'}->[4],],
		['infowolf',	$textrs->{'ANNOUNCE_SELECTKILL'}->[1],],
		['infowolf',	$textrs->{'ANNOUNCE_SELECTKILL'}->[2],],
		['info',    	$textrs->{'ANNOUNCE_LEAD'}->[0],],
		['info',    	$textrs->{'ANNOUNCE_LEAD'}->[1],],
		['info',    	$textrs->{'ANNOUNCE_LEAD'}->[2],],
		['infosp',    	$textrs->{'ANNOUNCE_ENTRUST'}->[0],],
		['infosp',    	$textrs->{'ANNOUNCE_ENTRUST'}->[1],],
		['infosp',    	$textrs->{'ANNOUNCE_COMMIT'}->[0],],
		['infosp',    	$textrs->{'ANNOUNCE_COMMIT'}->[1],],
		['caution',   	$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[0],],
		['caution',   	$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[1],],
		['caution',   	$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[2],],
		['caution',   	$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[3],],
		['info',    	$textrs->{'ANNOUNCE_KILL'}->[0],],
		['info',    	$textrs->{'ANNOUNCE_KILL'}->[1],],
		['info',    	$textrs->{'ANNOUNCE_KILL'}->[2],],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[0],],
		['caution', 	$avictory0,],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[1],],
		['caution', 	$avictory1,],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[2],],
		['caution', 	$avictory2,],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[3],],
		['caution', 	$avictory3,],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[4],],
		['caution', 	$avictory4,],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[5],],
		['caution', 	$avictory5,],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[6],],
		['caution', 	$avictory6,],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[7],],
		['caution', 	$avictory7,],
		['info',    	$textrs->{'ANNOUNCE_WINNER'}->[8],],
		['caution', 	$avictory8,],
		['info',    	$textrs->{'ANNOUNCE_WINNER_DISH'},],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[0],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[1],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[2],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[3],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[4],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[5],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[6],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[7],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[8],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[9],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[10],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[11],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[12],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[13],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[14],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[15],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[16],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[17],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[18],],
		['info',    	$textrs->{'EXPLAIN_EVENT'}->[19],],
		['infosp',  	$result_seer1,],
		['infosp',  	$result_seer2,],
		['infosp',  	$result_seer3,],
		['infosp',  	$result_seer4,],
		['infosp',  	$result_seer5,],
		['infosp',  	$result_seer6,],
		['infosp',  	$result_seer7,],
		['infosp',  	$result_seer8,],
		['info',    	$textrs->{'ANNOUNCE_EXTENSION'},],
		['infosp',  	$textrs->{'ANNOUNCE_SELROLE'},],
		['infosp',  	$textrs->{'ANNOUNCE_SETVOTE'},],
		['infosp',  	$textrs->{'ANNOUNCE_SETENTRUST'},],
		['infosp',  	$textrs->{'ANNOUNCE_SETTARGET'},],
		['info',    	$textrs->{'ENTRYMES'},],
		['info',    	$textrs->{'EXITMES'},],
		['info',    	$textrs->{'SUDDENDEATH'},],
		['info',    	$textrs->{'SUICIDEBONDS'},],
		['info',    	$textrs->{'SUICIDELOVERS'},],
		['infosp',  	$textrs->{'NOSELROLE'},],
		['infosp',  	$textrs->{'SETRANDOMTARGET'},],
		['infosp',  	$textrs->{'CANCELTARGET'},],
		['infosp',  	$textrs->{'EXECUTEGOTO'},],
		['infosp',  	$textrs->{'EXECUTEALONE'},],
		['infosp',  	$textrs->{'EXECUTESEER'},],
		['infosp',  	$textrs->{'EXECUTEALCHEMIST'},],
		['infosp',  	$textrs->{'EXECUTEKILLWITCH'},],
		['infosp',  	$textrs->{'EXECUTELIVEWITCH'},],
		['infosp',  	$textrs->{'EXECUTEGUARD'},],
		['infosp',  	$textrs->{'EXECUTEJAMM'},],
		['infosp',  	$textrs->{'EXECUTETRICKSTER'},],
		['infosp',  	$textrs->{'EXECUTEBITCH'},],
		['infosp',  	$textrs->{'EXECUTELOVER'},],
		['infosp',  	$textrs->{'EXECUTEGURU'},],
		['infosp',  	$textrs->{'EXECUTESNATCH'},],
		['info',    	$textrs->{'EXECUTESCAPEGOAT'},],
		['info',    	$textrs->{'EXECUTEFAN'},],
		['infowolf',	$textrs->{'EXECUTECHILDWOLF'},],
		['infosp',  	$textrs->{'EXECUTEGIRL'},],
		['infosp',  	$textrs->{'EXECUTEGIRLFEAR'},],
		['infosp',  	$textrs->{'EXECUTETHROW'},],
		['infosp',  	$textrs->{'EXECUTELOST'},],
		['info',    	$textrs->{'EXECUTEJUMP'},],
	);
	my @messages = (
		['mes_wolf',	$textrs->{'EXECUTEKILL'},],
	);
	my $actions = $textrs->{'ACTIONS'};
	for (my $index=0; $index < @infos; $index++) {
		my $style  = $infos[$index][0];
		my $logmsg = $infos[$index][1];
		my $randomvote = $textrs->{'ANNOUNCE_RANDOMVOTE'};

		$logmsg =~ s/_ABILITY_/●●/g;
		$logmsg =~ s/_COUNT_/4/g;
		if ( $style eq 'caution' ){
			$logmsg =~ s/_DATE_/9999\/12\/31\(Fri\) 23時半頃/g;
		} else {
			$logmsg =~ s/_DATE_/3/g;
		}
		$logmsg =~ s/_HOUR_/1/g;
		$logmsg =~ s/_GIFT_/●●/g;
		$logmsg =~ s/_LIVES_/2/g;
		$logmsg =~ s/_NAME_/●●/g;
		$logmsg =~ s/_NPC_/●●/g;
		$logmsg =~ s/_RANDOM_/$randomvote/g;
		$logmsg =~ s/_ROLE_/●●/g;
		$logmsg =~ s/_SELROLE_/●●/g;
		$logmsg =~ s/_TARGET_/●●/g;
		$logmsg =~ s/_TARGET1_/●●/g;
		$logmsg =~ s/_TARGET2_/●●/g;

		print <<"_HTML_";
<div><div class="message_filter" id="$index_-1_6"><p class="$style">
$logmsg
</p>
<hr class="invisible_hr">
</div></div>
_HTML_
	}
	for (my $index=0; $index < @messages; $index++) {
		my $style  = $messages[$index][0];
		my $logmsg = $messages[$index][1];
		my $chrid  = $index + 10;

		$logmsg =~ s/_TARGET_/●●/g;

		print <<"_HTML_";
<div><div class="message_filter" id="$index_0_0">
<table class="$style"> 
<tbody> 
<tr class="say"> 
<td class="img" style=" width: 110px;"><img src="http://utage.sytes.net/wolf/img/ririnra/c$chrid.jpg" width="90" alt=""> 
<td class="field"><DIV class="msg"> 
    <h3 class="mesname"> <a name="SS$index">●● ●●</a></h3> 
<p class="mes_text" style=" width: 442px;">$logmsg</p> 
<P class="mes_date"> 9999/12/31(Fri) 23時半頃</P> 
</DIV></td> 
</tr></table> 
</div></div> 
_HTML_
	}
	for (my $index=0; $index < @$actions; $index++) {
		my $logmsg = $actions->[$index];

		print <<"_HTML_";
<div><div class="message_filter" id="$index_0_0"><div class="mes_nom"> 
<div class="action"> 
<p> 
<a name="SA$index">●●</a>は、●●$logmsg
</p> 
<P class="mes_date"> 9999/12/31(Fri) 23時半頃</P> 
<hr class="invisible_hr"> 
</div> 
</div> 
</div></div> 
_HTML_
	}
}

1;
