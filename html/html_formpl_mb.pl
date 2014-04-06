package SWHtmlPlayerFormMb;

#----------------------------------------
# プレイヤー発言／行動欄HTML出力
#----------------------------------------
sub OutHTMLPlayerFormMb {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader("$sow->{'query'}->{'vid'} $vil->{'vname'}"); # HTMLヘッダの出力

	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $option = $sow->{'html'}->{'option'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	print <<"_HTML_";
<a name="say">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>
<a href="$link" accesskey="4">戻る</a>/<a href="#action" accesskey="6">ACT</a>/<a href="#role" accesskey="8">能\力</a><br$net>
<hr$net>
_HTML_

	# 発言欄HTML出力
	&OutHTMLSayMb($sow, $vil);

	# 能力者欄HTML出力
	my %role;
	if ($curpl->{'role'} < 0) {
		$role{'role'} = $curpl->{'selrole'};
	} else {
		if ($curpl->issensible()){
			$role{'role'} = $curpl->{'role'};
		} else {
			$role{'role'} = 0;
		}
	}
	$role{'gift'} = $curpl->{'gift'};
	my $textrs = $sow->{'textrs'};
	if ($curpl->{'role'} < 0) {
		$role{'explain'} = $textrs->{'EXPLAIN'}->{'prologue'};
	} elsif ($vil->isepilogue() != 0) {
		$role{'explain'} = $textrs->{'EXPLAIN'}->{'epilogue'};
	} else {
		$role{'explain'} = $textrs->{'EXPLAIN'}->{'dead'};
	}
	my $selrolename = $textrs->{'ROLENAME'}->[$curpl->{'selrole'}];
	$selrolename = $textrs->{'RANDOMROLE'} if ($curpl->{'selrole'} < 0);
	$role{'explain_role'} = $textrs->{'EXPLAIN'}->{'explain_role'};
	$role{'explain_gift'} = $textrs->{'EXPLAIN'}->{'explain_gift'};
	if ($curpl->{'role'} == $sow->{'ROLEID_MOB'}) {
		$role{'explain'} = $textrs->{'EXPLAIN'}->{'mob'};
		$role{'explain'} =~ s/_ROLE_/$sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'}/;
	} else {
		$role{'explain'} =~ s/_SELROLE_/$selrolename/;
		$role{'explain'} =~ s/_ROLE_/$textrs->{'ROLENAME'}->[$curpl->{'role'}]/;
	}

	&OutHTMLRoleMb($sow, $vil, \%role);

	print <<"_HTML_";
<hr$net>
<a href="$link">戻る</a>/<a href="#say" accesskey="2">発言</a>/<a href="#action">ACT</a>
_HTML_

	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# 発言欄HTML出力
#----------------------------------------
sub OutHTMLSayMb {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};
	my $markbonds = '';
	$markbonds = " ★$sow->{'textrs'}->{'MARK_BONDS'}" if ($curpl->isvisiblebonds($vil));

	# 名前とID
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $chrname = $curpl->getlongchrname();
	print "■$chrname$markbonds<br$net>\n";



	# 希望する能力の表示


	# 投票先変更プルダウン
	&OutHTMLVoteMb($sow, $vil, 'vote');
	&OutHTMLVoteMb($sow, $vil, 'entrust');

	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

	# 表情選択欄
	&OutHTMLExpressionFormMb($sow, $vil);

	# テキストボックスと発言ボタン
	my $buttonlabel = $curpl->getsaybuttonlabel( $vil, $sow->{'textrs'}->{'CAPTION_SAY_MB'}, $sow->{'textrs'}->{'CAPTION_GSAY_MB'}, $sow->{'textrs'}->{'BUTTONLABEL_MB'} );

	# 発言欄textarea要素の出力
	my $mes = '';
	$mes = $query->{'mes'} if (($query->{'wolf'}     ne 'on')
	                        && ($query->{'sympathy'} ne 'on')
	                        && ($query->{'pixi'}     ne 'on')
	                        && ($query->{'muppet'}   ne 'on')
	                        && ($query->{'maker'}    ne 'on')
	                        && ($query->{'admin'}    ne 'on'));
	$mes =~ s/<br( \/)?>/\n/ig;

	# 独り言チェックボックス
	my ($saycnt,$cost,$unit) = $vil->getsayptcosts();
	my $draft_say  = ' selected' if ($sow->{'draftmestype'} == $sow->{'MESTYPE_SAY' });
	my $draft_tsay = ' selected' if ($sow->{'draftmestype'} == $sow->{'MESTYPE_TSAY'});
	my $tsaycnttext = "あと".$curpl->{'tsay'}.$unit                                if ($cost ne 'none');
	my $ssaycnttext = "あと".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if ($cost ne 'none');
	my $asaycnttext = $ssaycnttext;

	print <<"_HTML_";
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="cmd" value="writepr"$net>$hidden
<input type="submit" value="$buttonlabel"$net>
<select name="target">
<option value="-1"$draft_say>$ssaycnttext ($sow->{'textrs'}->{'CAPTION_SAY_PC'})
<option value="$curpl->{'pno'}"$draft_tsay>$tsaycnttext ($sow->{'textrs'}->{'CAPTION_TSAY_PC'})
_HTML_


	if ((1 == $vil->{'aiming'})
      ||($sow->{'uid'} eq $cfg->{'USERID_ADMIN'})
      ||($sow->{'uid'} eq $cfg->{'USERID_NPC'})){
		# 内緒話の対象者
		my $pllist = $vil->getallpllist();
		foreach (@$pllist) {
			next if (0 == $curpl->isAim($_));

			my $targetname = $_->getshortchrname();
			print "<option value=\"$_->{'pno'}\">$asaycnttext $targetnameと内緒話$sow->{'html'}->{'option'}\n";
		}
	}
	print <<"_HTML_";
</select>
<select name="monospace">
<option value="">(通常)
<option value="monospace">等幅
<option value="report">見出し
</select>
</form>
<hr$net>

_HTML_

	# コミットボタン
	&OutHTMLCommitFormMb($sow, $vil) if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0) && ($sow->{'curpl'}->iscommitter()));

	# 村を出る
	&OutHTMLExitVilButtonMb($sow, $vil) if ($vil->{'turn'} == 0);

	# アクション
	&OutHTMLActionFormMb($sow, $vil); # if ($vil->ispublic($curpl));

	return;
}

#----------------------------------------
# アクションフォームの出力
#----------------------------------------
sub OutHTMLActionFormMb {
	my ($sow, $vil) = @_;
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};
	my $net    = $sow->{'html'}->{'net'};
	my $curpl  = $sow->{'curpl'};
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $pllist = $vil->getpllist();
	my $option = $sow->{'html'}->{'option'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	my $chrname = $curpl->getchrname();
	print <<"_HTML_";
<a name="action"><a href="$link">戻る</a></a>/<a href="#say">発言</a>/<a href="#role">能\力</a><br$net>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM_MB'}">
$chrnameは、
<select name="target">
<option value="-1">（選択しない）$option
_HTML_

	# アクションの対象者
	foreach (@$pllist) {
		next if (0 == $curpl->isAction($_));

		my $targetname = $_->getchrname();
		print "<option value=\"$_->{'pno'}\">$targetname$option\n";
	}

	print <<"_HTML_";
</select><br$net>

<select name="actionno">
<option value="-99">（↓自由に入力）
_HTML_
	# 組み込み済みアクション
	my $actions = $sow->{'textrs'}->{'ACTIONS'};
	my $i;
	for ($i = 0; $i < @$actions; $i++) {
		print "<option value=\"$i\">$actions->[$i]$option\n";
	}

	if ($curpl->{'live'} eq 'live'){
	# 昇進と降格
		my $actions_up = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_UP'};
		if( $actions_up ){
			print "<option value=\"-4\">$actions_up\n";
		}
		my $actions_down = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_DOWN'};
		if( $actions_down ){
			print "<option value=\"-5\">$actions_down\n";
		}

		# zap!zap!zap!
		# 処刑があるうちはクローンナンバーは増えない。
		my $actions_zap = $sow->{'textrs'}->{'ACTIONS_ZAP'}  if ( $vil->{'turn'} < 2 || $vil->{'epilogue'} <= $vil->{'turn'});
		if( $actions_zap ){
			my $zapcount = $sow->{'textrs'}->{'ACTIONS_ZAPCOUNT'};
			$zapcount =~ s/_POINT_/$curpl->{'zapcount'}/g;
			$actions_zap =~ s/_COUNT_/$zapcount/g;
			print "<option value=\"-3\">$actions_zap$option\n";
		}

		# しおり
		my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		print "<option value=\"-2\">$actions_bookmark$option\n";

		# 促し
		if ((defined($curpl->{'actaddpt'})) && ($curpl->{'actaddpt'} > 0)) {
			my $restaddpt = $sow->{'textrs'}->{'ACTIONS_RESTADDPT'};
			my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
			$restaddpt =~ s/_POINT_/$curpl->{'actaddpt'}/g;
			$actions_addpt =~ s/_REST_/$restaddpt/g;
			print "<option value=\"-1\">$actions_addpt$option\n";
		}
	} else {
		# しおり
		my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		print "<option value=\"-2\">$actions_bookmark$option\n";
	}

	# アクション入力欄とアクションボタン
	my ($saycnt,$costaction,$unitaction) = $vil->getactptcosts();
	my $actcnttext = "あと".$curpl->{'say_act'}.$unitaction  if ($costaction ne 'none');
	print <<"_HTML_";
</select><br$net>
<input type="hidden" name="cmd" value="action"$net>$hidden
<input type="text" name="actiontext" value=""$net><br$net>
<input type="submit" value="アクション"$net> $actcnttext
</form>
<hr$net>

_HTML_

	return;
}

#----------------------------------------
# 能力者欄HTML出力
#----------------------------------------
sub OutHTMLRoleMb {
	my ($sow, $vil, $role) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	print <<"_HTML_";
<a name="role"><a href="$link">戻る</a></a>/<a href="#say">発言</a>/<a href="#action">ACT</a><br$net>
_HTML_

	if (($curpl->{'role'} == -1) || ($curpl->{'role'} == $sow->{'ROLEID_MOB'})) {
		# 能力希望表示
		my $mes = $curpl->rolemessage( $role->{'explain'} );
		&SWHtml::ConvertNET($sow, \$mes);
		print <<"_HTML_";
$mes<br$net>

_HTML_
	} elsif ($curpl->ispowerlessgrave($vil) ) {
		# 能力欄表示（墓下）
		my $mes = $role->{'explain'};
		&SWHtml::ConvertNET($sow, \$mes);
		print <<"_HTML_";
$mes<br$net>

_HTML_
	} else {
		my $abi_role = $sow->{'textrs'}->{'ABI_ROLE'};

		my $winmes = '';
		if ($vil->isepilogue() == 0){
			$winmes = $curpl->winmessage();
		}

		# 能力対象先変更プルダウン
		&OutHTMLVoteMb($sow, $vil, 'role');

		# 囁き/共鳴/念話
		my $sayswitch;
		$sayswitch = $curpl->rolesayswitch($vil);
		if ( '' ne $sayswitch ){
			my $label   = $sow->{'textrs'}->{'CAPTION_ROLESAY'}->[$curpl->{'role'}];
			my $countid = $sow->{'ROLESAYCOUNTID'}->[$curpl->{'role'}];
			&OutHTMLSayTextAreaExtMb($sow,$vil,$sayswitch,$label,$countid );
		}
		# 能力者説明の表示
		my $rolemes = $curpl->rolemessage( $role->{'explain_role'}->[$role->{'role'}] );
		&SWHtml::ConvertNET($sow, \$rolemes);
		print <<"_HTML_";
$rolemes
_HTML_

		# 能力対象先変更プルダウン
		&OutHTMLVoteMb($sow, $vil, 'gift');

		# 囁き/共鳴/念話
		$sayswitch = $curpl->giftsayswitch($vil);
		if ( '' ne $sayswitch ){
			my $label   = $sow->{'textrs'}->{'CAPTION_GIFTSAY'}->[$curpl->{'gift'}];
			my $countid = $sow->{'GIFTSAYCOUNTID'}->[$curpl->{'gift'}];
			&OutHTMLSayTextAreaExtMb($sow,$vil,$sayswitch,$label,$countid );
		}
		# アイテム説明の表示
		my $giftmes = $curpl->rolemessage( $role->{'explain_gift'}->[$role->{'gift'}] );
		&SWHtml::ConvertNET($sow, \$giftmes);

		# 能力結果履歴
		my $history = $curpl->{'history'};
		print <<"_HTML_";
$giftmes
$winmes
<font color="red">$history</font>
_HTML_

		# 運命の絆
		my $lovestate = $curpl->getvisiblelovestate();
		my $love = '';
		$love = 'つまり、あなたは恋をしているのです。' if ($lovestate eq 'love');
		$love = 'つまり、あなたは殺意満々なのです。'   if ($lovestate eq 'hate');
		my $targets = $curpl->getvisiblebonds($vil);
		foreach $target (@$targets) {
			my $targetname   = $target->getchrname();
			my $resultbonds  = $sow->{'textrs'}->{'STATE_BONDS'};
			$resultbonds =~ s/_TARGET_/$targetname/g;
			print "<font color=\"red\">$resultbonds</font>\n";
		}
		if ( '' ne $love ) {
			print "<font color=\"red\">$love</font>\n";
		}
		# 誘い込まれた
		if ($curpl->{'sheep'} ne '') {
			my $sheeps = $vil->getsheeppllist();
			print "<font color=\"red\">";
			if ( 1 < scalar(@$sheeps) ) {
				foreach (@$sheeps) {
					next if ($curpl eq $_);
					my $targetname = $_->getchrname();
					print "<b>$targetname</b>と";
				}
			}
			print "$sow->{'textrs'}->{'STATE_SHEEPS'}";
			print "</font>\n";
		}

		# 状態
		my $textAbility = $curpl->textDisableAbility();
		print "<font color=\"red\">$textAbility</font>" if ( $curpl->hasDisableAbility() && $curpl->issensible() );
	}

	return;
}


#----------------------------------------
# 能力者の発言欄
#----------------------------------------
sub OutHTMLSayTextAreaExtMb {
	my ($sow, $vil, $sayswitch, $label, $countid ) = @_;
	my $cfg   = $sow->{'cfg'};
	my $curpl = $sow->{'curpl'};
	# 人形遣いのための特別コード。本当は、file_player#GetMesTypeを使うべき。
	$curpl = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} ) if ('muppet' eq $sayswitch);

	# 名前とID
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden  = &SWBase::GetHiddenValues($sow, $reqvals, '');


	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

	# 表情選択欄
	&OutHTMLExpressionFormMb($sow, $vil);
	my $buttonlabel = $sow->{'textrs'}->{'BUTTONLABEL_MB'};
	$buttonlabel =~ s/_BUTTON_/$label/g;

	# 発言欄textarea要素の出力
	my ($saycnt,$cost,$unit) = $vil->getsayptcosts();
	my $saycnttext = " あと$curpl->{$countid}$unit" if ($cost ne 'none');

	my $mes = '';
	$mes = $query->{'mes'} if ($query->{$sayswitch} ne '');
	$mes =~ s/<br( \/)?>/\n/ig;
	print <<"_HTML_";
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="$sayswitch" value="on"$net>
<input type="hidden" name="target" value="-1"$net>
<input type="hidden" name="cmd" value="writepr"$net>$hidden
<input type="submit" value="$buttonlabel"$net>$saycnttext
_HTML_

	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};

	print <<"_HTML_";
<select name="monospace">
<option value="">(通常)
<option value="monospace">等幅
<option value="report">見出し
</select>
</form>
_HTML_
}

#----------------------------------------
# 「時間を進める」ボタンHTML出力
#----------------------------------------
sub OutHTMLCommitFormMb {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	my $nosay = '';
	if (($sow->{'curpl'}->{'saidcount'} > 0)||($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'})) {
		print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<select name="commit">
_HTML_

		my $selectstar_nocommit = ' *';
		my $selectstar_commit = '';
		my $selected_nocommit = " $sow->{'html'}->{'selected'}";
		my $selected_commit = '';
		if ($sow->{'curpl'}->{'commit'} > 0) {
			$selectstar_nocommit = '';
			$selectstar_commit = ' *';
			$selected_nocommit = '';
			$selected_commit = " $sow->{'html'}->{'selected'}";
		}
		print <<"_HTML_";
    <option value="0"$selected_nocommit>時間を進めない$selectstar_nocommit$sow->{'html'}->{'option'}
    <option value="1"$selected_commit>時間を進める$selectstar_commit$sow->{'html'}->{'option'}
  </select>
  <input type="hidden" name="cmd" value="commit"$net>$hidden<br$net>
  <input type="submit" value="変更"$net>
</form>
_HTML_
	} else {
		$nosay = "<br$net><br$net>最低一発言して確定しないと、時間を進める事ができません。";
		print <<"_HTML_";
[時間を進めない *]<br$net>
_HTML_
	}

	print <<"_HTML_";
全員が「時間を進める」を選ぶと前倒しで更新されます。$nosay
<hr$net>

_HTML_

	return;
}


#----------------------------------------
# 投票／能力対象プルダウンリスト出力
#----------------------------------------
sub OutHTMLVoteMb {
	my ($sow, $vil, $cmd) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};
	my $curpl = $sow->{'curpl'};
	my $option = $sow->{'html'}->{'option'};
	return if ($cmd eq 'entrust' && ! $curpl->isEnableVote($vil->{'turn'}) );
	return if ($cmd eq 'vote'    && ! $curpl->isEnableVote($vil->{'turn'}) );
	return if ($cmd eq 'role'    && ! $curpl->isEnableRole($vil->{'turn'}) );
	return if ($cmd eq 'gift'    && ! $curpl->isEnableGift($vil->{'turn'}) );

	# 属性値の取得
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
<input type="hidden" name="cmd" value="$cmd">$hidden
_HTML_

    my $cmd_is_entrust = "";
    $cmd_is_entrust = "on" if ("entrust" eq $cmd);
    my $votestar  = $curpl->getchoice($cmd);
	my $votelabel = $curpl->getlabel($cmd);

	print <<"_HTML_";
<input type="submit" value="$votestar $votelabel\">
<input type="hidden" name="entrust" value="$cmd_is_entrust">$hidden
<select name="target">
_HTML_

	# 対象の表示
	$targetlist = $curpl->gettargetlistwithrandom($cmd);
	foreach (@$targetlist) {
		my $selected = '';
		my $selstar = '';
		if ($curpl->{$cmd.'1'} == $_->{'pno'}) {
			$selected = " $sow->{'html'}->{'selected'}";
			$selstar = ' *';
		}
		print "<option value=\"$_->{'pno'}\"$selected>$_->{'chrname'}$selstar$option\n";
	}
	if (($cmd eq 'vote')&&( $curpl->{$cmd.'1'} == $curpl->{'pno'})){
		my $pno      = $curpl->{'pno'};
		my $chrname  = $curpl->getlongchrname();
		my $selected = $sow->{'html'}->{'selected'};
		my $option   = $sow->{'html'}->{'option'};
		print '<option value="'.$pno.'" '.$selected.'>自分へ投票 *'.$option."\n";
	}
	print "</select>";

	my $votelabel = $curpl->gettargetlabel($cmd,$vil->{'turn'});
	if ( $votelabel ne '' ) {
		print " と、<br$net>\n";
		print <<"_HTML_";
<select name="target2">
_HTML_

		# 対象の表示
		$targetlist = $curpl->gettargetlistwithrandom($cmd);
		foreach (@$targetlist) {
			my $selected = '';
			my $selstar = '';
			if ($curpl->{$cmd.'2'} == $_->{'pno'}) {
				$selected = " $sow->{'html'}->{'selected'}";
				$selstar = ' *';
			}
			print "<option value=\"$_->{'pno'}\"$selected>$_->{'chrname'}$selstar$sow->{'html'}->{'option'}\n";
		}
		print "</select>";
	}
	print "\n";

	print <<"_HTML_";
</form>

_HTML_

	return;
}

#----------------------------------------
# 表情選択欄HTML出力
#----------------------------------------
sub OutHTMLExpressionFormMb {
	my ($sow, $vil) = @_;
	my $net = $sow->{'html'}->{'net'};

	my $expression = $sow->{'charsets'}->{'csid'}->{$sow->{'curpl'}->{'csid'}}->{'EXPRESSION'};
	if (@$expression > 0) {
		print <<"_HTML_";
表\情：<select name="expression">
_HTML_

		my $i;
		for ($i = 0; $i < @$expression; $i++) {
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($i == 0);
			print "<option value=\"$i\"$selected>$expression->[$i]$sow->{'html'}->{'option'}\n";
		}
		print "</select><br$net>\n\n";
	}
}

#----------------------------------------
# 村を出るボタンHTML出力（暫定）
#----------------------------------------
sub OutHTMLExitVilButtonMb {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmdfrom'} = $sow->{'query'}->{'cmd'};
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');
	if ((defined($sow->{'curpl'})) && ($sow->{'curpl'}->{'uid'} eq $cfg->{'USERID_NPC'})) {
		print <<"_HTML_";
[村を出る]<br$net>
（ダミーキャラは村を出られません）
<hr$net>
_HTML_

	} else {
		print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <input type="submit" value="村を出る"$net>
  <input type="hidden" name="cmd" value="exitpr"$net>$hidden
</form>
<hr$net>
_HTML_
	}

	return;
}

1;
