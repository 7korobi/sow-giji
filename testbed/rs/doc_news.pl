package SWDocSpec;

#----------------------------------------
# 仕様FAQ
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => "他の人狼クローンとの違い（仕様FAQ）", # タイトル
	};

	return bless($self, $class);
}

#----------------------------------------
# 仕様FAQの表示
#----------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg = $sow->{'cfg'};

	print <<"_HTML_";
<DIV class=toppage>
<h2>他の人狼クローンとの違い（仕様FAQ）</h2>
<p class="paragraph">
※ここでは人狼クローンによって名前の異なる役職について、以下のように表\記します。
</p>
<ul>
  <li>狩人／守護者 → 守護者</li>
  <li>共有者／結社員 → 共有者</li>
  <li>ハムスター人間／妖魔／妖狐 → 妖精</li>
</ul>
<hr class="invisible_hr"$net>

<h3>目次</h3>
<ul>
  <li><a href="#diff_wbbs">人狼BBSとの大まかな違い</a></li>
  <li><a href="#diff_juna">人狼審問との大まかな違い</a></li>
  <li><a href="#update">処刑や占いなどの処理順はどうなっていますか？</a></li>
  <li><a href="#curseandkillseer">その他の疑問</a></li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="diff_wbbs">人狼BBSとの大まかな違い</a></h3>
<ul>
  <li>アクション・メモ機能\が使えます。</li>
  <li>引用に便利なアンカー（>>0:0 とか）が使えます。</li>
  <li>更新の前倒し（「時間を進める」、コミットとも言う）が使えます。</li>
  <li>村が自動で生成されません。プレイヤーが自分で遊びたい村を作成してください。</li>
  <li>タブラの人狼、以外の楽しみ方を選ぶことができます。</li>
  <li>投票方式として無記名投票方式があります（投票COができなくなります）。</li>
  <li>誰かに投票先を委任することができます。</li>
  <li>発言フィルタや携帯モードがあります。</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="diff_juna">人狼審問との大まかな違い</a></h3>
<ul>
  <li>村が自動で生成されません。カスタム村のみです。</li>
  <li>タブラの人狼、以外の楽しみ方を選ぶことができます。</li>
  <li>突然死通知機能\がありません。</li>
  <li>突然死優先処刑機能\がありません。</li>
  <li>参加方法が微妙に違います。右上で「ログイン」した後、村のページを表\示すると参加欄が表\示されます。</li>
  <li>定員にはダミーキャラ（人狼審問でいうアーヴァイン）の人数を含みます（人狼審問の15人村＝$sow->{'cfg'}->{'NAME_SW'}での16人村）。</li>
  <li>アクションの対象にダミーキャラが含まれます。</li>
  <li>占い先と処刑先が同じだった場合でも占う事ができます。</li>
  <li>占い・霊能\などの判定結果はログの上部ではなく能\力者欄（発言入力欄の下）に表\示されます。</li>
  <li>村人の多数意志による廃村はできません。</li>
  <li>「パス」による意図的不襲撃、意図的な\能\力の不行使ができます。</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="update">処刑や占いなどの処理順はどうなっていますか？</a></h3>
<p class="paragraph">
下記の通りです。
</p>

<ol><li>夜の準備</li>
    <ol><li>魔女が薬を準備。</li>
    </ol>
    <li>突然死の処理</li>
    <li>（「ランダム」を指定した\能\力の宛先解決）</li>
    <li>処刑</li>
    <ol><li>開票、委任、決定者の追加票</li>
        <li>Sir Cointoss による採否</li>
        <li>混乱時、生贄を処刑</li>
    </ol>
    <li>黄昏時</li>
    <ol><li>盗賊の処理</li>
        <li>神話マニアの処理</li>
        <li>少女の処理</li>
        <li>人犬の処理</li>
        <li>笛吹きの処理</li>
        <li>キューピッドの処理</li>
        <li>光の輪の処理</li>
    </ol>
    <li>護衛or邪魔対象決定</li>
    <li>夜半</li>
    <ol><li>霊能\者の処理</li>
        <li>占い師の処理</li>
        <li>魔女の処理</li>
        <li>錬金術師の処理</li>
    </ol>
    <li>襲撃</li>
    <ol><li>襲撃先決定</li>
        <li>人狼達による襲撃</li>
        <li>一匹狼による襲撃</li>
    </ol>
    <li>黎明</li>
    <ol><li>予\告された死の処理</li>
        <li>宿借妖精の処理</li>
    </ol>
    <li>夜明け</li>
    <ol><li>鱗魚人が跳ねる</li>
        <li>後追い、道連れ処理</li>
        <li>仔狼の死を発見</li>
        <li>扇動家の死を発見</li>
    </ol>
    <li>勝利判定</li>
    <li>翌日の開始</li>
    <ol><li>以前の事件の収束</li>
        <li><a href="sow.cgi?cmd=howto#event">事件</a>の発生</li>
        <li>初期投票先の設定</li>
    </ol>
    
</ol>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">占い師が妖精を占い先にした状態で襲撃された場合、妖精を呪殺できますか？</a></h3>
<p class="paragraph">
できます。
</p>
<p class="paragraph">
<a href="#update">更新時の処理順</a>にある通り、襲撃処理よりも呪殺判定の方が先に処理されるので、占い師が襲撃で死亡する前に妖精が呪殺により死亡します。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">占い師は、処刑先を占えますか？</a></h3>
<p class="paragraph">
できます。
</p>
<p class="paragraph">
占いは、対象の生死にかかわらず実施します。投票によって既に処刑された対象や、別の占い師に先に占われて呪殺された妖精を占っても、問題なく占い結果を得られます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">Ｃ狂って村側じゃないよね？</a></h3>
<p class="paragraph">
いいえ、村側で数えています。
囁き狂人＝Ｃ国狂人、は、人狼と相談できます。誤解が生じないので、村囁狼のときなどは確実に狼勝利になり、人狼ＢＢＳではそれを理由に、この時点でエピローグに突入しています。この伝統は大乱闘では、妖精がいるとき、魔女が薬を持って生き残っているとき、賞金稼ぎがいるとき、など、多くのパターンで成り立たないものなので、廃止しています。
なお、人狼議事の祖先である物語系では、Ｃ国狂人の動作はＢＢＳ互換です。ただし、第三勢力がいるときは人間と扱います。
</p>

<h3><a $atr_id="curseandkillseer">光の輪を村側以外が持つことはありますか？</a></h3>
<p class="paragraph">
ありません。人狼や狂人や妖精は、光の輪が最初に配布されたときと、光の輪を渡されたときに破壊します。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">事件はいつまで有効なの？</a></h3>
<p class="paragraph">
事件があった日と、その後の夜が明けるまでです。議事録の変化などは当日のものが、\能\力の行使などは翌日のものが影響下にあります。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">\能\力を失うとどうなるの？</a></h3>
<p class="paragraph">
魔女が薬を使い果たす、人狼の代表\が病人や長老を襲う、奇跡のおかげで生き返る、などの理由で\能\力を失うことがあります。
たとえば霊能\者の悪鬼が病人を襲うと、処刑対象の判定を見ることができず、襲撃に参加することもできません。ただし、囁きなどの特殊発言はのこります。
天と地に見放され、人と話す\能\力以外を取り上げられてしまうのです。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">\能\力を失っても、受身の\能\力は残るよね？</a></h3>
<p class="paragraph">
残念。霊\能\力などは対象を指し示す\能\力ではありませんが、\能\力を失った人物にはもう与えられません。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">狼血族って、本当に占われたのか解るの？</a></h3>
<p class="paragraph">
占われたときだけ出るシステムメッセージで、占われたか、占うと言って占われなかったかが解ります。もし占い先が統一されていないと……。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">魔女の準備ってなに？</a></h3>
<p class="paragraph">
魔女は夜になる前に蘇生薬か毒薬を準備します。その後処刑、襲撃、呪殺などの事情で対象が死んでしまうと、もはや準備してしまった薬を無駄にしてしまうことになります。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">絆のある追従者は、四月馬鹿のときにどうなるの？</a></h3>
<p class="paragraph">
検討中です。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">じゃあ、生贄がだれかを指差してるときの追従者は？</a></h3>
<p class="paragraph">
検討中です。/:-）
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="atkhamster">妖精が襲撃対象となった場合、妖精は自分が襲撃された事がわかりますか？</a></h3>
<p class="paragraph">
わかりません。<br$net>
妖精が襲撃されても、妖精には自分が襲われた事はわかりませんし、妖精襲撃と守護者の護衛成功との見分けも付きません。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">盗賊が変身して、エピローグになっちゃったりして……</a></h3>
<p class="paragraph">
盗賊は、勝負がついてしまう役職を避けて、変身先を選びます。とはいえ、どれを選んでも終了してしまう場合はあきらめて村にとどめを刺します。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">弟子入りした先が弟子だったんですけれど、どうなるの？</a></h3>
<p class="paragraph">
あなたの師匠がだれに弟子入りするかによります。あなたは孫弟子として、師匠の師匠と同じ役職になり、師匠と絆を結びます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">たくさんの光の輪を、ひとりに集めると？</a></h3>
<p class="paragraph">
光の輪はひとつに纏まり、次に誰かに渡すときもひとつのままです。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">人狼が死者を襲撃対象にしていた場合、人狼には襲撃時にその人物が死んでいた事がわかりますか？</a></h3>
<p class="paragraph">
わかります。
</p>
<p class="paragraph">
人狼が襲撃する前に襲撃対象が死亡していた場合、襲撃がキャンセルされ襲撃メッセージ（「～！ 今日がお前の命日だ！」）が表\示されなくなります。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">夜遊びしていた少女が恐怖死したとき、襲撃はどうなる？</a></h3>
<p class="paragraph">
少女を怯えさせた功労者は、襲撃希望が死体となるので襲撃に参加しません。ほかに人狼がいれば、彼等だけで襲撃を続行します。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">亡霊の事件があったとき、後追いなどの特殊処理は？</a></h3>
<p class="paragraph">
対象が人狼に変身するとき、襲撃者代\者が襲撃代表\者を殺した、と扱います。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">亡霊の事件があったとき、襲撃代表\になって死んでいった狼はどうなる？</a></h3>
<p class="paragraph">
その役職のまま墓にはいります。狼陣営勝利になれば、生き残りの仲間たちと勝利を分かち合うことができるでしょう。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">守護者が護衛成功した場合、手応えを感じますか？</a></h3>
<p class="paragraph">
感じます。
</p>
<p class="paragraph">
守護者は護衛に成功すると、「～を人狼の襲撃から守った」のような一文が能\力欄に追記されます。何も追記されていなければ、人狼は守護者が護衛していた人物を襲ってこなかったという事になります。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">預言者や風花妖精が死ぬのっていつ？</a></h3>
<p class="paragraph">
「生きた人狼の人数の二日後」とありますが、日付は夜に進んでいます。もし、二日目の議論をしている最中なら、三日目に死ぬかどうかを心配しましょう。人狼がその夜の処刑のあとで一名になったとしたら、それまでの命です。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">宿借妖精の\能\力で入れ替わると、なにもかも入れ替わるの？</a></h3>
<p class="paragraph">
精神がいれかわっても、人間関係や身体そのものは入れ替わりません。
笛吹きに踊らされていること、絆、恋は身体に準じ、入れ替わりの対象外になります。逆に、生死などは入れ替わりの対象になるので、ちょうど死んだ人物と入れ替わると、以前の自分の無残な死体が見つかります。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">何人も扇動者が死ぬと、３人以上処刑するの？</a></h3>
<p class="paragraph">
たとえ１００人の扇動者が一度に死んでも、翌日の投票先は２名になります。
扇動者の\能\力は、処刑対象をひとり増やす、ではなく、処刑対象をふたりにする、です。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">じゃあ仔狼は？</a></h3>
<p class="paragraph">
同様に、１００匹の仔を失った狼たちも、翌日の襲撃先は２名です。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">長老と人犬って、おなじ？</a></h3>
<p class="paragraph">
いいえ、人犬は襲撃を受けると負傷し、一日の後に死亡しますが、長老は負傷したまま生き続けます。また、二度の襲撃や一度の毒薬などで長老が死んでしまう場合、犯人は\能\力を失います。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">教祖はどこいったの？</a></h3>
<p class="paragraph">
教祖の\能\力は笛吹きが引き継ぎました。アルティメット人狼の教祖とミラーズホロー新月の笛吹きは\能\力が酷似しており、両方を掲載するほど違いがないと感じたためです。あと、笛吹きのほうがかわいいよね。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">笛吹き、強すぎない？</a></h3>
<p class="paragraph">
そこにシビれるあこがれるゥーーー！
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">占われるとどうなる？</a></h3>
<p class="paragraph">
人狼なら人狼判定を受け、妖精なら呪殺されてしまいます。<a href="sow.cgi?cmd=howto#rolerule">詳しい一覧\表\</a>はこちら。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">R-サイモン-6 みたいなのを見たんだけど？</a></h3>
<p class="paragraph">
市民、あなたはその情報に接するには、<a href="http://members.at.infoseek.co.jp/Paranoia_O/books/IrIntro.html">セキュリティ・クリアランスがたりない</a>ようです。<br>
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">発言をしたあと、確定する前にアクションを送信すると、アクションの方が先に確定しますか？</a></h3>
<p class="paragraph">
いいえ、発言の方が先に確定します。
</p>

<p class="paragraph">
人狼審問ではアクションが即時確定する仕様のため、短い間隔で発言→アクションと行うとアクションが前の発言を追い抜くという現象が発生しますが、本スクリプトではそのままの順序に確定します。<br$net>
確定するまでのあいだ発言は他の人には見えませんが、確定するとアクションの前に発言が急に割り込んだような形で表\示されます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">発言撤回するとどうなる？</a></h3>
<p class="paragraph">
_HTML_
	if ( $cfg->{'ENABLED_DELETED'} ) {
		print "発言は削除扱いになり、あなただけが見ることができます。エピローグになると全体に公開されます。" ;
	} else {
		print "発言は見えなくなり、エピローグになっても消えたままです。" ;
	}
	print <<"_HTML_";
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">墓下から、秘密の会話（囁きなど）は見える？</a></h3>
<p class="paragraph">
_HTML_
	if ( $cfg->{'ENABLED_PERMIT_DEAD'} ) {
		print "見えます。生き残った仲間を応援してあげましょう。" ;
	} else {
		print "見えません。" ;
	}
	print <<"_HTML_";
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">話の続きを促す表\現を、自由に変えたいな</a></h3>
<h3><a $atr_id="actionbeforesay">次のクローンを呼んじゃう表\現を、自由に変えたいな</a></h3>
<h3><a $atr_id="actionbeforesay">セキュリティ・クリアランスを上げ下げしちゃう表\現を、自由に変えたいな</a></h3>
<p class="paragraph">
やりたい行動を選んだあと、すぐ下の行に自由に入力してみましょう。入力したとおりのアクションをして、同等の結果がおこります。
</p>
<hr class="invisible_hr"$net>

</DIV>
_HTML_

}

1;
