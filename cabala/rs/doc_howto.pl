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
	my $mob    = $sow->{'basictrs'}->{'MOB'};
	my $mobodr = $mob->{'ORDER'};
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

	&SWBase::LoadTextRS($sow, $vil);

	print <<"_HTML_";
<DIV class=toppage>
<p class="paragraph">
基本設定で、ゲームの詳細なルールを決めています。ルールを確認したい基本設定を選んでから、この下を読みましょう。
</p>
<h2>遊び方</h2>
<p class="paragraph">
$cfg->{'NAME_SW'}は、やや敷居の高いゲームです。遊び方をよく読み、更に既に終了した村のログを２～３村ほど読んで感覚をある程度掴んでから、参加される事をお薦めします。
</p>

<ul>
  <li><a href="#regist">ユーザー登録とログイン</a></li>
  <li><a href="#entry">村への参加</a></li>
  <li><a href="#exit">村から出る</a></li>
  <li><a href="#muster">点呼をとる</a></li>
  <li><a href="#rolerule">能\力者</a></li>
<ul>
  <li><b><a href="sow.cgi?cmd=roleaspect&$docid">能\力、恩恵ごとの、細かい特徴</a></b></li>
  <li><b><a href="sow.cgi?cmd=rolelist&$docid">役職とインターフェース</a></b></li>
</ul>
  <li><a href="#role">村側の能\力者（役職）</a></li>
  <li><a href="#rolewolf">人狼側の能\力者（役職）</a></li>
  <li><a href="#rolepixi">妖精の能\力者（役職）</a></li>
  <li><a href="#roleother">その他の能\力者（役職）</a></li>
  <li><a href="#rolegift">能\力者以外の要素（恩恵）</a></li>
  <li><a href="#rolerule">能\力とルールの細かいところ</a></li>
  <li><a href="#event">村を翻弄する運命（事件）</a></li>
  <li><a href="#start">村が始まったら</a></li>
  <li><a href="#die">死亡</a></li>
  <li><a href="#suddendeath">突然死</a></li>
  <li><a href="#ending">勝敗の決定</a></li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="regist">ユーザー登録とログイン</a></h3>
<p class="paragraph">
$cfg->{'NAME_SW'}で遊ぶためには、まずユーザー登録が必要です。ユーザー登録をするには、右上にある「ログイン」ボタンで行います（「ログイン」ボタンはユーザー登録ボタンを兼ねています）。
</p>

<p class="paragraph">
好きなユーザーIDと悪用を防ぐためのパスワードを決めたら、「user id」欄にユーザID、「password:」欄にパスワードを入力して「ログイン」ボタンを押してください。そのユーザーIDを誰かが既に使用していなければ、user id:xxxxx [ログアウト] と表\示されます。この表\示が出れば登録成功です。
</p>

<p class="paragraph">
ゲームをするには、ログインしなければなりません。既にログインしているなら「ログアウト」ボタンが表\示されていますが、表\示されていないならログインしましょう。<br$net>
ログインのやり方には、ユーザー登録のやり方と同じです。右上の入力欄にユーザIDとパスワードを入力して「ログイン」ボタンを押してください。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="entry">村への参加</a></h3>
<p class="paragraph">
次に、参加したい村をトップページの「村の一覧」から選びます。村の一覧の「進行」という欄を見て下さい。ここが「募集中」なら、あなたはその村へ参加する事ができます。<br$net>
参加したい村を決めたら、村の名前をクリックしてください。その村のプロローグが表\示され、一番下に参加者入力欄が表\示されます。
</p>

<p class="paragraph">
「希望する配役」は、あなたの好きな配役（キャラ）を選ぶ欄です。プレイ中に発言をすると、その発言の発言者名がここで選んだ配役の名前となります。<br$net>
$cfg->{'NAME_SW'}は村の勝敗が決するまでの間、誰が参加しているのか誰にもわからないようになっています。「配役」とは、あなたが誰なのかをわからないようにするための変名のようなものです。雰囲気を盛り上げるため、ある程度配役になりきった方が楽しめるでしょう。<br$net>

</p>

<p class="paragraph">
「希望する能\力」は、あなたが村人になりたいか人狼になりたいかの希望を出す欄です。希望が必ず通るとは限りません。希望者が多かった場合、抽選で外れて希望していない能\力者になってしまう事があります。<br$net>
$cfg->{'NAME_SW'}には、「村人」「人狼」以外にも様々な「能\力者」がいます。彼らはそれぞれ特有の特殊能\力を持っています。<br$net>
</p>

<p class="paragraph">
このとき、村によっては「見物する」選択肢が含まれていることがあります。見物人は勝敗にかかわらず、ただ村の行く末を見届ける立場です。村ごとに見物人の立場が設定してあり、会話できる範囲が異なります。
</p>
<ul>
_HTML_
	foreach (@$mobodr){
		my $caption = $mob->{$_}->{'CAPTION'};
		my $help    = $mob->{$_}->{'HELP'};
		print "<li>$caption ： $help</li>";
	}
	print <<"_HTML_";
</ul>
<p class="paragraph">
「希望する配役」「希望する能\力」「参加する時のセリフ」を選択・入力し終わったら、「この村に参加」ボタンを押してください。あなたが希望した配役の名前で「参加する時のセリフ」が村の画面に表\示されます。<br$net>
これであなたは、この村の参加者となりました。ゲームが開始するまで、他の村人たちと雑談でもしましょう。
</p>

<p class="paragraph">
参加人数が定員まで達してしまうと、たとえ見物人の席が空いていても開始待ちとなります。見物人の募集は締め切られませんが、今まさに開始するかもしれません。
</p>

<hr class="invisible_hr"$net>

<h3><a $atr_id="exit">村から出る</a></h3>
<p class="paragraph">
一旦参加しても、プロローグ中であれば村から出ることが可能です。<br$net>
発言フォームの下にある「村を出る」を選びましょう。<br$net>
あなたの操作以外に、プロローグで長い間発言がないとき、あなたが村に居るべきでないと判断されたとき、あなたは村から出ています。<br$net>
村建て人は、村の中にいてはまずい、と判断した人を退去させる機能を持っています。「村の情報」欄の理解が浅い、参加姿勢に不安があるなどの判断をされた場合、立ち退きとなりますので、しっかりと村の情報を読んで参加し、全員で楽しめるプレイを心がけましょう。<br$net>
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="muster">点呼をとる</a></h3>
<p class="paragraph">
そろそろ開始、というときに、集まりが悪いといざ始まったときにも勢いよくは会話できませんね。<br$net>
それはつまらない、と考える村建て人のために、点呼をとる機能があります。点呼を開始すると、いちど全員の発言した回数をゼロにするので、その瞬間以降で発言のない人がはっきりわかります。<br$net>
その次の更新時まで待機すれば自動的に無発言扱いで村を出ますし、手動更新のつもりでいるなら、更新の１０分前あたりをめどに、そこまで無発言のままの人は参加できない事情ができたと見なします。などとアナウンスしておくと、参加に不自由しそうな人をはっきり見分けることができます。それが決めておいた方針なら、退去いただくのもいいでしょう<br$net>
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolerule">能\力</a></h3>
<p class="paragraph">
村には、様々な特殊能\力を持つ者（または持たない者）がいます。その多くは村側の能\力者、いくらかは人狼側の能\力者、もしかしたら、それ以外の陣営の者もいるかもしれません。<a href="sow.cgi?cmd=roleaspect&$docid">能\力、恩恵ごとの、細かい特徴</a>を参考にしましょう。また、<a href="sow.cgi?cmd=rolelist&$docid">役職とインターフェース</a>で、ゲーム中の操作盤や結果表\示をみることができます。
</p>



<h3 title="村側の能\力者"><a $atr_id="role">村側の能\力者（役職）</a></h3> 
<p class="paragraph" onclick="\$('#filter_role').slideToggle('slow');">
力を合わせて、悪者達を撃退しましょう。彼らは特別なことがない限り、村人陣営として活躍します。<br>
$sow->{'textrs'}->{'WIN_HUMAN'}
</p>
<div id="filter_role"> 
<table border="1" class="vindex" summary="能\力者一覧（村側）">
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
	
	my $enemy = "狼側";
	$enemy    = "破滅側" if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );
	my $enemy_win = $sow->{'textrs'}->{'WIN_WOLF'};
	$enemy_win    = $sow->{'textrs'}->{'WIN_EVIL'} if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<h3><a $atr_id="roleenemy">$enemyの能\力者（役職）</a></h3>
<p class="paragraph" onclick="\$('#filter_roleenemy').slideToggle('slow');">
村には善良な村人達の他に、人間でありながら敵に回る裏切り者達もいます。夜はあなたたちの時間です。<br>
$enemy_win
</p>
<div id="filter_roleenemy"> 
<table border="1" class="vindex" summary="能\力者一覧（$enemy）">
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
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolewolf">人狼側の能\力者（役職）</a></h3>
<p class="paragraph" onclick="\$('#filter_rolewolf').slideToggle('slow');">
村には善良な村人達の他に、彼らになりすまして村人を襲う人狼や、人間でありながら人狼に協力する裏切り者達もいます。夜はあなたたちの時間です。<br>
$sow->{'textrs'}->{'WIN_WOLF'}
</p>
<div id="filter_rolewolf"> 
<table border="1" class="vindex" summary="能\力者一覧（人狼側）">
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

<h3><a $atr_id="rolepixi">第三勢力の能\力者（役職）</a></h3>
<p class="paragraph" onclick="\$('#filter_rolepixi').slideToggle('slow');">
村には村側にも人狼側にも属さない者達がいます。村人側か人狼側が勝利する条件を満たした時、彼らは横から勝利を浚っていきます。<br>
$sow->{'textrs'}->{'WIN_PIXI'}
</p>
<div id="filter_rolepixi"> 
<table border="1" class="vindex" summary="能\力者一覧（第三勢力）">
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

<h3><a $atr_id="roleother">それ以外の能\力者（役職）</a></h3>
<p class="paragraph" onclick="\$('#filter_roleother').slideToggle('slow');">
上記にあてはまらない、特殊な能\力の持ち主です。どうしたら勝利するか、どのような性質の役職か、まちまちなのでよく確認しましょう。
</p>

<div id="filter_roleother"> 
<table border="1" class="vindex" summary="能\力者一覧（その他）">
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

<h3><a $atr_id="rolegift">役職以外の能\力（恩恵）</a></h3>
<p class="paragraph" onclick="\$('#filter_rolegift').slideToggle('slow');">
能\力とは独立して、特別なルールが加わることもあります。どうしたら勝利するか、どのような性質の役職か、まちまちなのでよく確認しましょう。
</p>

<div id="filter_rolegift"> 
<table border="1" class="vindex" summary="恩恵一覧">
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


<h3><a $atr_id="start">村が始まったら</a></h3>
<p class="paragraph">
村が始まると参加者の希望に応じて能\力者が決定され、そしてどんな能\力者が何人いるのかという内訳が表\示されます。<br$net>
まずはあなたがどんな能\力者になっているのか確認しましょう。希望が通って望み通りの能\力者になっているかもしれませんし、思いがけない能\力者になってしまっているかもしれません。
</p>

<p class="paragraph">
あなたの能\力を確認したら、さあいよいよゲームの始まりです。<br$net>
あなたが村人側であれば、人狼を探し始めましょう。人狼は人間になりすましています。しかし、完全に人間になりすますのは難しいものです。おかしいと感じたところがあれば、その人の発言をよく見直してみましょう。
</p>

<p class="paragraph">
あなたが人狼であれば、きっと仲間がいるはずです。人狼だけがこっそりと会話を交わせる「囁き」と呼ばれる特殊な発言欄があるはずです。まずはそこで挨拶をしてみましょう。そして、表\では人間の振りをして、「私は人狼を探しているのだ」というようなポーズを取り、周りの人間達を信用させましょう。
</p>

<p class="paragraph">
最初はどう発言すればいいのかわからないかもしれません。大丈夫、きっと誰かが「議題」を出してくれます。最初はこの議題に答えていけばいいのです。議題に答えるうち、誰かがあなたの回答に質問をぶつけて来るでしょう。今度はその質問に答えてみましょう。そうやっている内に、あなたもだんだん慣れてくるはず。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="event">事件</a></h3>
<p class="paragraph" onclick="\$('#filter_event').slideToggle('slow');">
特殊な事情が発生する日があります。その日、村は提示されたルールに従うでしょう。
</p>

<div id="filter_event"> 
<table border="1" class="vindex" summary="事件一覧">
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


<h3><a $atr_id="die">死亡</a></h3>
<p class="paragraph">
ゲームを進めていくうち、処刑されたり人狼に襲撃されたりして、あなたが命を落とす事になるかもしれません。<br$net>
死亡すると、あなたは死者の世界へ向かいます。死者の世界では死者同士が会話を交わす事ができます。ただし、死者同士の会話は生存者には聞こえません。死者たるあなたは生存者と会話を交わす事ができません。<br$net>
「幽界トーク」の設定がされている村では、死亡していても生存している人狼、妖精と会話を交わすことが可能\です。
</p>

<p class="paragraph">
一つ注意しておいて下さい。あなたが一人きりの孤独なハムスター人間などではない限り、あなたには仲間がいます。<br$net>
このゲームは他のゲームと違い、あなたが死亡してもすぐあなたの敗北となるわけではありません。あなたの仲間達が勝利すれば、あなたもこのゲームに勝利する事になります。このゲームの勝敗に、あなた個人の生死は直接関係しません。<br$net>
状況によっては、あなたが死を受け入れる事で、あなた自身の勝ち目を高める事もあるでしょう。
</p>

<p class="paragraph">
しかし、死亡してしまったあなたには、もう直接勝敗に関わる事はできません。ですので、他の死者たちとともにまだ生きている仲間たちを応援したり、生存者のおかしな意見にツッコミを入れたり、あるいは単に雑談したりして、死者の世界を楽しみましょう。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="suddendeath">突然死</a></h3>
<p class="paragraph">
発言をしないまま更新を迎えると、ゲーム放棄とみなされて自動的に「突然死」し、ゲームから除外されます。<br$net>
この動作はときに乱暴すぎ、村の方針と馴染まないこともあるでしょう。
</p>

<p class="paragraph">
突然死を防ぐには、更新までに通常発言を最低一回してください。アクションや独り言、人狼のささやきなどで発言しても突然死を防げません。<br$net>
また、通常発言を行っても確定する前に削除してしまった場合は「通常発言をした」とはみなされません。
</p>

<p class="paragraph">
村に未発言者がいる場合、発言入力欄のすぐ上に「本日まだ発言していない者は～」というシステムメッセージが表\示されます。ここに自分の名前が表\示されていなければ、あなたは更新を迎えても突然死しません。
</p>
<hr class="invisible_hr"$net>

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
