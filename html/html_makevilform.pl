package SWHtmlMakeVilForm;

#----------------------------------------
# 村作成／編集画面のHTML出力
#----------------------------------------
sub OutHTMLMakeVilForm {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_RS'}/doc_rule.pl";
	my $doc = SWDocRule->new($sow);

	my $vmode = '作成';
	my $vcmd = 'makevil';
	if ($sow->{'query'}->{'cmd'} eq 'editvilform') {
		$vmode = '編集';
		$vcmd = 'editvil' if ($sow->{'query'}->{'status'} ne 'dispose');
	}
#	$vcmd = 'makevilpr';

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader("村の$vmode"); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = '';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $urlwiki = $cfg->{'URL_CONST'};
	my $linkmake  = '(Knowledge)Manual';

	$vil->{'trsid'} = $sow->{'query'}->{'trsid'} if ($sow->{'query'}->{'trsid'} ne '');
	&SWBase::LoadTextRS($sow, $vil);

	&SWHtmlPC::OutHTMLLogin($sow); # ログインボタン
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	&SWHtmlPC::OutHTMLGonInit($sow); # ログイン欄の出力
	$vil->gon_story(true);
	$vil->gon_event(true);
	print <<"_HTML_";
</script>
<div class="toppage">
<h2>村の$vmode</h2>
_HTML_

	print "<p class=\"caution\">村を$vmodeするにはログインが必要です。</p>\n\n" if ($sow->{'user'}->logined() <= 0);

	my $fullmanage  = ( $vil->{'turn'} == 0 );
	if ( $fullmanage ) {
		print <<"_HTML_";
<p class="paragraph">
<a href="$urlwiki$linkmake">村建てマニュアル</a>や同村者の意見を参考に、魅力的な村を作っていきましょう。
募集期限は作成した日から$sow->{'cfg'}->{'TIMEOUT_SCRAP'}日間です。期限内に村が開始しなかった場合、廃村となります。
</p>
_HTML_
	} else {
		$input = 'hidden';
	}

	my $vcomment = $vil->{'vcomment'};

	if ($vcomment eq ""){
		$vcomment="（村のルールは、自由に編集できるよ！）\n■村のルール";
		my $vrule = $doc->{'v_rule'};
		$list = $vrule->{'name'};
		for( $i=0; $i<@$list; $i++ ){
			next if ( '' eq $list->[$i] );
			my $name = $vrule->{'name'}->[$i];
			$vcomment .= "<br>".($i+1).".$name";
		}
	}

	$reqvals->{'cmd'} = 'rule';
	my $url_rule = &SWBase::GetLinkValues($sow, $reqvals);
	$url_rule = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$url_rule";

	print <<"_HTML_";
<form action="$urlsow" method="$cfg->{'METHOD_FORM'}">
<div class="form_vmake">

<fieldset>
<legend>村の名前と説明</legend>
<input id="vname" type="text" name="vname" ng-model="story.name" class="form-control">
_HTML_
	if ( $fullmanage ) {
		$vcomment =~ s/<br( \/)?>/\n/ig;
		print <<"_HTML_";
<textarea id="vcomment" class="form-control" name="vcomment" cols="30" rows="10">$vcomment</textarea>
</fieldset>
<fieldset>
<p>
_HTML_
	} else {
		print <<"_HTML_";
<p>
$vcomment
<br>
_HTML_
	}
	print <<"_HTML_";
_HTML_

	print "■国のルール<br$net>";
	my $nrule = $doc->{'n_rule'};
	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		print "<strong>".($i+1).".$name</strong><br$net>";
	}

	print <<"_HTML_";
</p>
</fieldset>
<fieldset>
<p class="tips">
以上の項目が、<a href="$url_rule">$sow->{'cfg'}->{'NAME_SW'}のルール</a>なんだ。編集していい部分は、自由に変更してかまわない。
</p>
</fieldset>
_HTML_

	if ( $fullmanage ) {
		print <<"_HTML_";
<div template="sow/form/configs">
<script>
e = [];
f = [];
g = [];
i = [];

a = [];
b = [];
c = [];
d = {};

_HTML_
		my $order_roletable = $sow->{'ORDER_ROLETABLE'};
		my $i;
		for ($i = 0; $i < 24; $i++) {
			my $hour = sprintf('%02d時', $i);
			print "e.push({val:$i,name:'$hour'});";
		}

		for ($i = 0; $i < 60; $i += 30) {
			my $min = sprintf('%02d分', $i);
			print "f.push({val:$i,name:'$min'});";
		}

		for ($i = 1; $i <= 3; $i++) {
			my $interval = sprintf('%02d時間', $i * 24);
			print "g.push({val:$i,name:'$interval'});";
		}
		foreach (@$order_roletable) {
			my $caption  = $sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_};
			next if (!defined($caption));
			print "i.push({val:'$_',name:'$caption'});";
		}

		my $roleid  = $sow->{'ROLEID'};
		my $giftid  = $sow->{'GIFTID'};
		my $eventid = $sow->{'EVENTID'};
		for ($i=0,$d=0; $i <= @$roleid; $i++) {
            next if ($sow->{'ROLEID_TANGLE'}    == $i && $sow->{'cfg'}->{'ENABLED_TEST_ROLE'} != 1);
            next if ($sow->{'ROLEID_WALPURGIS'} == $i && $sow->{'cfg'}->{'ENABLED_TEST_ROLE'} != 1);
			next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
			print "a.push('" . $roleid->[$i] . "');";
			print "d." . $roleid->[$i] . " = " . $vil->{"cnt$roleid->[$i]"} . ";";
		}
		for ($i=$sow->{'SIDEST_DEAL'}; $i <= @$giftid; $i++) {
			next if ( '' eq $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$i] );
			print "b.push('" . $giftid->[$i] . "');";
			print "d." . $giftid->[$i] . " = " . $vil->{"cnt$giftid->[$i]"} . ";";
		}
		for ($i=1,$d=0; $i <= @$eventid; $i++) {
			next if ( '' eq $sow->{'textrs'}->{'EVENTNAME'}->[$i] );
			print "c.push('" . $eventid->[$i] . "');";
		}
		print <<"_HTML_";

gon.config = {
	roles: a,
	gifts: b,
	events: c,
	counts: d,
	roletables: i,
	votetypes: [
		{val:"anonymity",name:"無記名投票"},
		{val:"sign",name:"記名投票"}
	],
	intervals: g,
	minutes: f,
	hours: e,
	trs: {
		caption:"$sow->{'textrs'}->{'CAPTION'}",
		help:"$sow->{'textrs'}->{'HELP'}"
	},
	trsid: "$vil->{'trsid'}"
};
</script>
</div>
_HTML_


		# シンプルコンフィグ？
		if ('simple' eq $sow->{'textrs'}->{'FORCE_DEFAULT'}) {
			print <<"_HTML_";
<input type="hidden" name="entrylimit"   value="free"$net>
<input type="hidden" name="randomtarget" value=""$net>
<input type="hidden" name="noselrole"    value=""$net>
<input type="hidden" name="undead"       value=""$net>
<input type="hidden" name="showid"       value=""$net>
<input type="hidden" name="game"         value="TABULA"$net>

<fieldset>
<legend>拡張設定</legend>
プレイヤーIDはエピローグまで秘密です。また、狼・妖精は、死者と会話できません。また、役職希望を尊重し、投票・能\力の対象を、ランダムで決定することはできません。投票が同数になったときはランダムに解決し、人間の人数が人狼以下になったら村側の敗北です。
<br class="multicolumn_clear"$net>
_HTML_

		} else {

			print <<"_HTML_";
<fieldset>
<legend>参加制限</legend>
<label><input type="radio" name="entrylimit" value="free" ng-checked="0 == story.entry.password.length">制限なし</label><br>
<label>
<input type="radio" name="entrylimit" value="password" ng-checked="0 < story.entry.password.length">参加用パスワード必須（半角８文字以内）
<input type="text" class="form-control" name="entrypwd" maxlength="8" size="8" ng-model="story.entry.password">
</label>
<br>
</fieldset>

<fieldset>
<legend>拡張設定</legend>
<dl class="dl-horizontal">
_HTML_
			if ($sow->{'cfg'}->{'ENABLED_SEQ_EVENT'} > 0) {
				print <<"_HTML_";
<dt><label for="seqevent">事件正順</label>
<dd><input id="seqevent" name="seqevent" type="checkbox" ng-checked="story_has_option('seq-event')">
  事件が順序どおりに発生する
_HTML_
			}
			print <<"_HTML_";
<dt><label for="entrust">委任投票</label>
<dd><input id="entrust" name="entrust" type="checkbox" ng-checked="story_has_option('entrust')">
  委任投票をする
<dt><label for="noselrole">役職希望</label>
<dd><input id="noselrole" name="noselrole" type="checkbox" ng-checked="! story_has_option('select-role')">
  役職希望を無視する
<dt><label for="showid">ID公開</label>
<dd><input id="showid" name="showid" type="checkbox" ng-checked="story_has_option('show-id')">
  プレイヤーIDを公開する
_HTML_
			# ランダム対象
			if ($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) {
				print <<"_HTML_";
<dt><label for="randomtarget">ランダム</label>
<dd><input id="randomtarget" name="randomtarget" type="checkbox" ng-checked="story_has_option('random-target')">
  投票・能\力の対象に「ランダム」を含める
_HTML_
			}

			if ($cfg->{'ENABLED_UNDEAD'} == 1){
				print <<"_HTML_";
<dt><label for="undead">幽界トーク</label>
<dd><input id="undead" name="undead" type="checkbox" ng-checked="story_has_option('undead-talk')">
  狼・妖精と死者との間で、会話ができる
_HTML_
			}

			if ($cfg->{'ENABLED_AIMING'} == 1){
				print <<"_HTML_";
<dt><label for="aiming">内緒話</label>
<dd><input id="aiming" name="aiming" type="checkbox" ng-checked="story_has_option('aiming-talk')">
  ふたりだけの内緒話をすることができる
_HTML_
			}

			# 役職希望無視
			print <<"_HTML_";
<dt><label for="game">ゲームルール</label>
<dd><select id="game" name="game" class="form-control" ng-model="story.type.game">
_HTML_

			my $game     = $sow->{'basictrs'}->{'GAME'};
			my $gamelist = $sow->{'cfg'}->{'GAMELIST'};
			foreach (@$gamelist) {
				print "<option value=\"$_\">$game->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
			}

			# 見物人種類
			print <<"_HTML_";
</select>
_HTML_
		}
	} else {
		print <<"_HTML_";
<fieldset>
<legend>拡張設定</legend>
_HTML_
	}
	print <<"_HTML_";
<dt><label for="rating">
こだわり
<img name=cd_img src="$cfg->{'DIR_IMG'}/icon/cd_{{story.rating}}.png">
</label>
<dd><select id="rating" name="rating" class="form-control" ng-model="story.rating">
_HTML_

	# レイティング
	my $rating = $sow->{'cfg'}->{'RATING'};
	foreach (@{$rating->{'ORDER'}}) {
		print "<option value=\"$_\">$rating->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
	}

	print <<"_HTML_";
</select>
_HTML_

	if ( $fullmanage ) {
		print <<"_HTML_";
<dt><label for="csid">登場人物</label>
<dd><select id="csid" name="csid" class="form-control" ng-model="story.csid">
_HTML_

		my $csidlist = $sow->{'cfg'}->{'CSIDLIST'};
		foreach (@$csidlist) {
			my @csids = split('/', "$_/");
			my @captions;
			foreach (@csids) {
				$sow->{'charsets'}->loadchrrs($_);
				push(@captions, $sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'});
			}
			my $caption = join('と', @captions);
			print "      <option value=\"$_\"$selected> $caption$sow->{'html'}->{'option'}\n";
		}

		# 村編集で登場人物欄を変更すると……。

		print <<"_HTML_";
</select>
<dt><label for="saycnttype">発言制限</label>
<dd><select id="saycnttype" name="saycnttype" class="form-control" ng-model="story.type.say">
_HTML_

		my $countssay = $sow->{'cfg'}->{'COUNTS_SAY'};
		my $countssay_order = $countssay->{'ORDER'};
		foreach (@$countssay_order) {
			print "      <option value=\"$_\">$countssay->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
</select>
<dt><label for="starttype">開始方法</label>
<dd><select id="starttype" name="starttype" class="form-control" ng-model="story.type.start">
_HTML_

		my $starttype = $sow->{'basictrs'}->{'STARTTYPE'};
		foreach (@{$starttype->{'ORDER'}}) {
			print "      <option value=\"$_\">$starttype->{$_}$sow->{'html'}->{'option'}\n";
		}

		# 見物人種類
		print <<"_HTML_";
</select>
<dt><label for="mob">見物人</label>
<dd>
<div class="form-inline"><div class="form-group">
<select id="mob" name="mob" class="form-control input-medium" ng-model="story.type.mob">
_HTML_
		my $mob = $sow->{'basictrs'}->{'MOB'};
		foreach (@{$mob->{'ORDER'}}) {
			print "<option value=\"$_\">$mob->{$_}->{'CAPTION'}（$mob->{$_}->{'HELP'}）$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
</select>
<span>に</span>
</div>
<div class="form-group"><div class="input-group input-small">
<input id="cntmob" type="number" name="cntmob" class="form-control" size="3" value="$vil->{"cntmob"}">
<span class="input-group-addon">人</span>
</div></div>
</div>
</fieldset>

<div class="exevmake">
<input type="hidden" name="cmd" value="$vcmd"$net>$hidden
_HTML_
	} else {
		print <<"_HTML_";
</fieldset>
<div class="exevmake">
<input type="hidden" name="cmd" value="$vcmd"$net>$hidden
_HTML_
	}
	print "<input type=\"hidden\" name=\"vid\" value=\"$vil->{'vid'}\"$net>\n" if ($vil->{'vid'} > 0);

	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($sow->{'user'}->logined() <= 0);

	print <<"_HTML_";
<input class="form-control" type="submit" value="村の$vmode"$disabled$net>
</div>
</div>
</form>
</div>

_HTML_

	# 日付別ログへのリンク
	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
