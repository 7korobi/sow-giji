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

	# 日付別ログへのリンク
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil) if ($sow->{'query'}->{'cmd'} eq 'editvilform');

	print <<"_HTML_";
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
	$reqvals->{'css'} = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
	my $url_rule = &SWBase::GetLinkValues($sow, $reqvals);
	$url_rule = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$url_rule";

	print <<"_HTML_";
<form action="$urlsow" method="$cfg->{'METHOD_FORM'}">
<div class="form_vmake">

<fieldset>
<legend>村の名前と説明</legend>
<input id="vname" type="text" name="vname" value="$vil->{'vname'}" size="30"$net>
<br class="multicolumn_clear"$net>
_HTML_
	if ( $fullmanage ) {
		$vcomment =~ s/<br( \/)?>/\n/ig;
		print <<"_HTML_";
<textarea id="vcomment" class="multicolumn_role" name="vcomment" cols="30" rows="10">$vcomment</textarea>
</fieldset>
<fieldset>
<p class="multicolumn_role">
_HTML_
	} else {
		print <<"_HTML_";
<p class="multicolumn_role">
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
<fieldset>
<legend>基本設定</legend>

<input type="hidden" name="trsid" value="$vil->{'trsid'}">
<strong><a href="sow.cgi?cmd=trsdiff&trsid=$vil->{'trsid'}">$sow->{'textrs'}->{'CAPTION'} </a></strong>
<p class="multicolumn_role">
$sow->{'textrs'}->{'HELP'}
</p>

<label for="vplcnt" class="multicolumn_label" >定員：</label>
<input id="vplcnt" class="multicolumn_left" type="text" name="vplcnt" value="$vil->{'vplcnt'}" size="5"$net>人
<br class="multicolumn_clear"$net>

<label for="vplcntstart" class="multicolumn_label" >最低人数：</label>
<input id="vplcntstart" class="multicolumn_left" type="text" name="vplcntstart" value="$vil->{'vplcntstart'}" size="5"$net>人  ※開始方法が人狼BBS型の時のみ
<br class="multicolumn_clear"$net>

<label for="updhour" class="multicolumn_label">更新時間：</label>
<select id="updhour" name="hour" class="multicolumn_left">
_HTML_

		my $i;
		for ($i = 0; $i < 24; $i++) {
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($vil->{'updhour'} == $i);
			print "      <option value=\"$i\"$selected>$i時$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
</select>
<select id="updminite" name="minite" class="multicolumn_left">
_HTML_

		for ($i = 0; $i < 60; $i += 30) {
			my $min = sprintf('%02d分', $i);
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($vil->{'updminite'} == $i);
			print "      <option value=\"$i\"$selected>$min$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
</select>に更新
<br class="multicolumn_clear"$net>

<label for="updinterval" class="multicolumn_label">更新間隔：</label>
<select id="updinterval" name="updinterval" class="multicolumn_left">
_HTML_


		for ($i = 1; $i <= 3; $i++) {
			my $interval = sprintf('%02d時間', $i * 24);
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($vil->{'updinterval'} == $i);
			print "      <option value=\"$i\"$selected>$interval$sow->{'html'}->{'option'}\n";
		}

		my $votetype_anonymity = " $sow->{'html'}->{'selected'}";
		my $votetype_sign = '';
		if ($vil->{'votetype'} eq 'sign') {
			$votetype_anonymity = '';
			$votetype_sign = " $sow->{'html'}->{'selected'}";
		}

		print <<"_HTML_";
</select>ごとに更新
<br class="multicolumn_clear"$net>

<label for="votetype" class="multicolumn_label">投票方法：</label>
<select id="votetype" name="votetype" class="multicolumn_left">
<option value="anonymity"$votetype_anonymity>無記名投票$sow->{'html'}->{'option'}
<option value="sign"$votetype_sign>記名投票$sow->{'html'}->{'option'}
</select>
<br class="multicolumn_clear"$net>

<label for="roletable" class="multicolumn_label">役職配分：</label>
<select id="roletable" name="roletable" class="multicolumn_left">
_HTML_

		my $order_roletable = $sow->{'ORDER_ROLETABLE'};
		foreach (@$order_roletable) {
			my $caption  = $sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_};
			next if (!defined($caption));
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($vil->{'roletable'} eq $_);
			print "      <option value=\"$_\"$selected>$caption$sow->{'html'}->{'option'}\n";
		}

#      <option value="later">後で設定$sow->{'html'}->{'option'}

		print <<"_HTML_";
</select>
<br class="multicolumn_clear"$net>
</fieldset>

<fieldset>
<legend>役職配分自由設定</legend>
<TABLE align=center class="multicolumn_role"><TBODY>
_HTML_

		my $cssid = 'default';
		$cssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
		$cssid = 'default' if (!defined($cfg->{'CSS'}->{$cssid}));
		my $csswidth = $cfg->{'CSS'}->{$cssid}->{'WIDTH'};
		my $imgwidth = $charset->{'IMGBODYW'} + 2;
		my $maxwidth = 460;
		$maxwidth = 460 if ( 480 <= $csswidth);
		$maxwidth = 560 if ( 800 <= $csswidth);
		my $tdwidth = int( $maxwidth/140 );
		my $roleid  = $sow->{'ROLEID'};
		my $giftid  = $sow->{'GIFTID'};
		my $eventid = $sow->{'EVENTID'};
		my $d;
		for ($i=0,$d=0; $i <= @$roleid; $i++) {
			if    ($i == $sow->{'SIDEST_HUMANSIDE'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>人間</h3><TR>\n ";
				$d = 0; 
			}elsif($i == $sow->{'SIDEST_ENEMY'} ){
				my $enemy = "人狼側";
				$enemy    = "破滅側" if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );
				print "\n\n<TR><TD colspan=$tdwidth><h3>$enemyの人間</h3><TR>\n ";
				$d = 0; 
			}elsif($i == $sow->{'SIDEST_WOLFSIDE'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>人狼</h3><TR>\n ";
				$d = 0; 
			}elsif($i == $sow->{'SIDEST_PIXISIDE'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>妖精</h3><TR>\n ";
				$d = 0; 
			}elsif($i == $sow->{'SIDEST_OTHER'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>それ以外</h3><TR>\n ";
				$d = 0; 
			}elsif($d >= $tdwidth){
				print "\n\n<TR> ";
				$d = 0; 
			}
			next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
			$d++;
			print <<"_HTML_";
<TD nowrap align=right>
<label for="cnt$roleid->[$i]">$sow->{'textrs'}->{'ROLENAME'}->[$i]</label>
<input  id="cnt$roleid->[$i]" type="text" name="cnt$roleid->[$i]" size="3" value="$vil->{"cnt$roleid->[$i]"}"$net>人 
_HTML_
		}
		for ($i=$sow->{'SIDEST_DEAL'},$d=0; $i <= @$giftid; $i++) {
			if    ($i == $sow->{'SIDEST_DEAL'} ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>恩恵</h3><TR>\n ";
				$d = 0; 
			}elsif($d >= $tdwidth){
				print "\n\n<TR> ";
				$d = 0; 
			}
			next if ( '' eq $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$i] );
			$d++;
			print <<"_HTML_";
<TD nowrap align=right>
<label for="cnt$giftid->[$i]">$sow->{'textrs'}->{'GIFTNAME'}->[$i]</label>
<input id="cnt$giftid->[$i]" type="text" name="cnt$giftid->[$i]" size="3" value="$vil->{"cnt$giftid->[$i]"}"$net>人 
_HTML_
		}
		for ($i=1,$d=0; $i <= @$eventid; $i++) {
			if    ($i == 1 ){
				print "\n\n<TR><TD colspan=$tdwidth><h3>事件</h3><TR>\n ";
				$d = 0; 
			}elsif($d >= $tdwidth){
				print "\n\n<TR> ";
				$d = 0; 
			}
			next if ( '' eq $sow->{'textrs'}->{'EVENTNAME'}->[$i] );
			$d++;
			print <<"_HTML_";
<TD nowrap align=right>
<label for="cnt$eventid->[$i]">$sow->{'textrs'}->{'EVENTNAME'}->[$i]</label>
<input id="cnt$eventid->[$i]" type="text" name="cnt$eventid->[$i]" size="3" value="$vil->{"cnt$eventid->[$i]"}"$net>件
_HTML_
		}
		for (; $d <3 ; $d++){
			print "<TD><TD>";
		}

		my $limitfree     = " $sow->{'html'}->{'checked'}";
		my $limitpassword = '';
		if ($vil->{'entrylimit'} eq 'password') {
			$limitfree     = '';
			$limitpassword = " $sow->{'html'}->{'checked'}";
		}

		print <<"_HTML_";
</TABLE>
</fieldset>
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
<label><input type="radio" name="entrylimit" value="free"$limitfree$net>制限なし</label><br$net>
<label>
<input type="radio" name="entrylimit" value="password"$limitpassword$net>参加用パスワード必須（半角８文字以内）
</label>
<input type="password" name="entrypwd" maxlength="8" size="8" value="$vil->{'entrypwd'}"$net>
<br class="multicolumn_clear"$net>
</fieldset>

<fieldset>
<legend>拡張設定</legend>
_HTML_

			# ランダム対象
			if ($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) {
				my $checkedrndtarget = '';
				$checkedrndtarget = " $sow->{'html'}->{'checked'}" if ($vil->{'randomtarget'} > 0);

				print <<"_HTML_";
<label for="randomtarget" class="multicolumn_label">ランダム： </label>
<input type="checkbox" id="randomtarget" class="multicolumn_left" name="randomtarget" value="on"$checkedrndtarget$net>投票・能\力の対象に「ランダム」を含める
<br class="multicolumn_clear"$net>

_HTML_
			}

			# 役職希望無視
			my $checkednoselrole = '';
			$checkednoselrole = " $sow->{'html'}->{'checked'}" if ($vil->{'noselrole'} > 0);

			print <<"_HTML_";
<label for="noselrole" class="multicolumn_label">役職希望： </label>
<input type="checkbox" id="noselrole" class="multicolumn_left" name="noselrole" value="on"$checkednoselrole$net>役職希望を無視する
<br class="multicolumn_clear"$net>

_HTML_

			my $checkedshowid = '';
			$checkedshowid = " $sow->{'html'}->{'checked'}" if ($vil->{'showid'} > 0);
			my $checkedundead = '';
			$checkedundead = " $sow->{'html'}->{'checked'}" if ($vil->{'undead'} > 0);

			if ($cfg->{'ENABLED_UNDEAD'} == 1){
				print <<"_HTML_";
<label for="undead" class="multicolumn_label">幽界トーク： </label>
<input type="checkbox" id="undead" class="multicolumn_left" name="undead" value="on"$checkedundead$net>狼・妖精と死者との間で、会話ができる
<br class="multicolumn_clear"$net>
_HTML_
			}

			print <<"_HTML_";
<label for="showid" class="multicolumn_label">ID公開： </label>
<input type="checkbox" id="showid" class="multicolumn_left" name="showid" value="on"$checkedshowid$net>プレイヤーIDを公開する
<br class="multicolumn_clear"$net>

<label for="game" class="multicolumn_label">ゲームルール： </label>
<select id="game" name="game" class="multicolumn_left">
_HTML_

			my $game     = $sow->{'basictrs'}->{'GAME'};
			my $gamelist = $sow->{'cfg'}->{'GAMELIST'};
			foreach (@$gamelist) {
				my $selected = '';
				$selected = " $sow->{'html'}->{'selected'}" if ($vil->{'game'} eq $_);
				print "<option value=\"$_\"$selected>$game->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
			}

			# 見物人種類
			print <<"_HTML_";
</select>
<br class="multicolumn_clear"$net>
_HTML_
		}
	} else {
		print <<"_HTML_";
<fieldset>
<legend>拡張設定</legend>
_HTML_
	}
	print <<"_HTML_";
<label for="rating" class="multicolumn_label">こだわり： </label>
<select id="rating" name="rating" class="multicolumn_left" onFocus='javascript:chrImgChange(document.cd_img,this,"$cfg->{'DIR_IMG'}/cd_","",".png")' onChange='javascript:chrImgChange(document.cd_img,this,"$cfg->{'DIR_IMG'}/cd_","",".png")'>
_HTML_

	# レイティング
	my $rating = $sow->{'cfg'}->{'RATING'};
	foreach (@{$rating->{'ORDER'}}) {
		my $selected = '';
		$selected = "$sow->{'html'}->{'selected'}" if ($vil->{'rating'} eq $_);
		print "<option value=\"$_\"$selected>$rating->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
	}

	print <<"_HTML_";
</select>
<img name=cd_img src="$cfg->{'DIR_IMG'}/cd_default.png">
<br class="multicolumn_clear"$net>
_HTML_

	if ( $fullmanage ) {
		print <<"_HTML_";
<label for="csid" class="multicolumn_label">登場人物：</label>
<select id="csid" name="csid" class="multicolumn_left">
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
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($vil->{'csid'} eq $_);
			print "      <option value=\"$_\"$selected> $caption$sow->{'html'}->{'option'}\n";
		}

		# 村編集で登場人物欄を変更すると……。

		print <<"_HTML_";
</select>
<br class="multicolumn_clear"$net>

<label for="saycnttype" class="multicolumn_label">発言制限： </label>
<select id="saycnttype" name="saycnttype" class="multicolumn_left">
_HTML_

		my $countssay = $sow->{'cfg'}->{'COUNTS_SAY'};
		my $countssay_order = $countssay->{'ORDER'};
		foreach (@$countssay_order) {
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($vil->{'saycnttype'} eq $_);
			print "      <option value=\"$_\"$selected>$countssay->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
</select>
<br class="multicolumn_clear"$net>

<label for="starttype" class="multicolumn_label">開始方法： </label>
<select id="starttype" name="starttype" class="multicolumn_left">
_HTML_

		my $starttype = $sow->{'basictrs'}->{'STARTTYPE'};
		foreach (@{$starttype->{'ORDER'}}) {
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($vil->{'starttype'} eq $_);
			print "      <option value=\"$_\"$selected>$starttype->{$_}$sow->{'html'}->{'option'}\n";
		}

		# 見物人種類
		print <<"_HTML_";
</select>
<br class="multicolumn_clear"$net>

<label for="cntmob" class="multicolumn_label">見物人： </label>
<select id="mob" name="mob" class="multicolumn_left">
_HTML_
		my $mob = $sow->{'basictrs'}->{'MOB'};
		foreach (@{$mob->{'ORDER'}}) {
			my $selected = '';
			$selected = "$sow->{'html'}->{'selected'}" if ($vil->{'mob'} eq $_);
			print "<option value=\"$_\"$selected>$mob->{$_}->{'CAPTION'}（$mob->{$_}->{'HELP'}）$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
</select>に
<input id="cntmob" type="text" name="cntmob" size="3" value="$vil->{"cntmob"}">人 
<br class="multicolumn_clear"$net>
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
<input type="submit" value="村の$vmode"$disabled$net>
</div>
</div>
</form>

_HTML_

	# 日付別ログへのリンク
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil) if ($sow->{'query'}->{'cmd'} eq 'editvilform');

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
