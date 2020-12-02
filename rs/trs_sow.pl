package SWTextRS_sow;

sub GetTextRS {
	# プロローグ～二日目の開始時メッセージ
	my @announce_first = (
		'この村にも恐るべき“人狼”の噂が流れてきた。ひそかに人間と入れ替わり、夜になると人間を襲うという魔物。不安に駆られた村人たちは、集会所へと集まるのだった……。',
		'きみは自らの正体を知った。さあ、村人なら敵である人狼を退治しよう。人狼なら……狡猾に振る舞って人間たちを確実に仕留めていくのだ。',
		'噂は現実だった。血塗られた定めに従う魔物“人狼”は、確かにこの中にいるのだ。<br><br>非力な人間が人狼に対抗するため、村人たちは一つのルールを定めた。投票により怪しい者を処刑していこうと。罪のない者を処刑してしまう事もあるだろうが、それも村のためにはやむを得ないと……。',
	);

	# 役職配分のお知らせ
	my @announce_role = (
		'どうやらこの中には、_ROLE_いるようだ。',
		'が',
		'人',
		'、',
	);

	# 生存者のお知らせ
	my @announce_lives = (
		'現在の生存者は、',
		'、',
		'の_LIVES_名。',
	);

	# 処刑時のお知らせ
	my @announce_vote =(
		'<b>_NAME_</b>は<b>_TARGET_</b>に投票した。_RANDOM_',
		'<b>_NAME_</b>に<b>_COUNT_人</b>が投票した。',
		'<b>_NAME_</b>は村人の手により処刑された。',
		'<b>_NAME_</b>を処刑するには畏れ多かったので、取りやめた。',
		'<b>_NAME_</b>は村人の手により処刑された。最後に<b>_TARGET_</b>を指差して……。',
	);

	# 襲撃時のお知らせ
	my @announce_selectkill =(
		'',
		'<b>_NAME_</b>に<b>_COUNT_人</b>が牙を向けた。',
		'<b>_NAME_</b>は襲撃された。',
		'',
		'',
	);

	# 優勢側をアナウンス
	my @announce_lead =(
		'村人と人狼の人数が等しく、勢力は拮抗しているようです。',
		'村人が多く、村人陣営が優勢のようです。',
		'人狼が多く、人狼陣営が優勢のようです。',
	);

	# 委任投票のお知らせ
	my @announce_entrust = (
		'<b>_NAME_</b>は投票を委任しています。_RANDOM_',
		'<b>_NAME_</b>は投票を委任しようとしましたが、解決不能でした。_RANDOM_',
	);

	# コミット
	my @announce_commit = (
		'<b>_NAME_</b>が「時間を進める」を取り消しました。',
		'<b>_NAME_</b>が「時間を進める」を選択しました。',
	);

	# コミット状況
	my @announce_totalcommit = (
		'「時間を進める」を選択している人は、まだ少ないようです。', # 0～1/3の時
		'「時間を進める」を選択している人が増えてきているようです。', # 1/3～2/3の時
		'多数の人が「時間を進める」を選択していますが、全員ではないようです。', # 2/3～n-1の時
		'全員が「時間を進める」を選択しています。', # 全員コミット済み
	);

	# 襲撃結果メッセージ
	my @announce_kill = (
		'次の日の朝、村人達は集まり、互いの姿を確認した。',
		'今日は犠牲者がいないようだ。人狼は襲撃に失敗したのだろうか。',
		'<b>_TARGET_</b>が無残な姿で発見された。',
	);
	
	my %status_live = (
		live       =>  '生存者',
		executed   =>  '処刑死',
		victim     =>  '襲撃死',
		cursed     =>  '呪詛死',
		droop      =>  '衰退死',
		suicide    =>  '後追死',
		feared     =>  '恐怖死',
		suddendead =>  '突然死',
	);

	# 勝敗メッセージ
	my @announce_winner = (
		'新たな日が昇った。だが、照らされた大地は静かなままだ。<br>この村に、もう人影はない……。',
		'暗雲が去り、まぶしい光が降り注ぐ。――全ての人狼を退治したのだ！',
		'闇が村を覆い、村人達は自らの過ちに気付いた。人狼達は最後の食事を済ませると、新たな犠牲者を求めて無人の村を立ち去っていった。',
		'村人達は気付いてしまった。もう疑いあう必要なんてないことに。<br>人も狼も関係ない、あらたな生活が始まる…',
		'つむじ風が舞い、村人達は凱歌を挙げた。<br>しかし、彼らは真の勝利者に気付いていなかった……。',
		'つむじ風が舞い、村中に人狼達の雄叫びが響き渡った。しかし、彼らは真の勝利者に気付いていなかった……。',
		'',
		'村人も、人狼も、妖精でさえも、恋人たちの前では無力でした。<br>必ず最後に愛は勝つのです。',
		'',
		'新たな日が昇った。だが、照らされた大地は静かなままだ。<br>この村に、もう人影はない……。',
	);

	# 勝利者
	my @caption_winner = (
		'',
		'村人の勝利',
		'人狼の勝利',
		'小動物の勝利',
		'小動物の勝利',
		'小動物の勝利',
		'一匹狼の勝利',
		'恋人達の勝利',
		'',
		'勝利者なし',
	);

	my %role_win = (
		WIN_NONE     => '--',
		WIN_DISH     => '据え膳',
		WIN_LOVER    => '恋人陣営',
		WIN_HATER    => '邪気陣営',
		WIN_LONEWOLF => '一匹狼',
		WIN_HUMAN    => '村人陣営',
		WIN_WOLF     => '人狼陣営',
		WIN_PIXI     => '妖精',
		WIN_GURU     => '笛吹き',
		WIN_EVIL     => '裏切りの陣営',
	);

	 # イベント名
	 my @eventname = (
		  '', ''    , '', '', '', '', '', '', '', '',
		  '', ''    , '', '', '', '', '', '', '', ''            ,
	 );

	my @explain_event = (
'未定義のイベントです。',
'今日は、特別なことのない一日のようだ。さあ普段通り、誰かを処刑台にかけよう。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_APRIL_FOOL" TARGET="_blank">四月馬鹿</A></b><br>大変、大変、大変なことになった。きみの役職は変化しているかもしれない。もしも誰かと絆を結んでいるなら、急に相手が憎くなってしまい、絆の相手だけにしか投票できない。そして悟ってしまった。今夜だけは、相方の後を追うことはないと……。<br><table><tr><th colspan=3>役職の変貌<th rowspan=4>※一日で元に戻る<tr><td>賢者<td>←→<td>魔女<tr><td>守護者<td>←→<td>長老<tr><td>賞金稼<td>←→<td>少女</table>',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_TURN_FINK" TARGET="_blank">二重スパイ</A></b><br>なんということだろう！一人が村側を裏切り、狼に与する半端者になってしまった。明日以降も、彼は村人を裏切り続けるだろう……。<br>決定者や光の輪の持ち主なら、このときにその力を手放してしまう。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_TURN_FAIRY" TARGET="_blank">妖精の輪</A></b><br>なんということだろう！一人が森に立ち入り、妖精の養子になってしまった。明日以降も、彼は村人を裏切り続けるだろう……。<br>決定者や光の輪の持ち主なら、このときにその力を手放してしまう。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_ECLIPSE" TARGET="_blank">日蝕</A></b><br>暗い日蝕が村中を覆い、お互い顔も名前も解らない。この闇夜は丸一日続くだろう。他人になりすまし、議論を混乱させることもできてしまうかもしれない。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_COINTOSS" TARGET="_blank">Sir Cointoss</A></b><br>お控えなさい。お控えなさい。コイントス卿はこの村の投票結果に意見があるようでございます。卿の御意向によっては、投票結果に基づいた処刑を取り止めにすることもあります。五分五分くらいかな。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_FORCE" TARGET="_blank">影響力</A></b><br>今日の投票箱は無色透明だ。だれかが投票した瞬間にその内容はハッキリと見えるから、投票をセットするときは気を付けて！',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_MIRACLE" TARGET="_blank">奇跡</A></b><br>帰ってきた！黄泉の国から、今日の襲撃で死んだ犠牲者がかえってきた！能力を失ったかもしれないけれど、それは些細なことだよ！ね！<br>人狼、一匹狼、賞金稼ぎなどに襲われた死者は生き返る。ただし、その能力は失われる。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_PROPHECY" TARGET="_blank">聖者のお告げ</A></b><br>聖者は民の夢枕に告げられました。今の任より、<b>決定者</A></b>にふさわしい人物がいると。旧き任務は解かれ、あたらしい<b>決定者</A></b>は皆に喝采で迎え入れられるだろう。',

'未定義のイベントです。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_CLAMOR" TARGET="_blank">不満</A></b><br>村には不満が鬱屈している。今夜の投票でまた人間を処刑してしまったら……悪夢が始まる。はじけた不満に背中を押され、話し合いもなしに、さらに一人の首を必要とするだろう。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_FIRE" TARGET="_blank">熱意</A></b><br>村には期待に満ちた熱意が渦巻いている。今夜の投票がひとならぬものを処刑できたなら……悪夢が始まるのだ。はじけた熱意に背中を押され、話し合いもなしに、さらに一人の首を必要とするだろう。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_NIGHTMARE" TARGET="_blank">悪夢</A></b><br>恐ろしい一日が始まる。今日は投票だけができる。発言も、能力も使えない。そして、突然死は発生しない。<br>さあ投票して、こんな日が早く過ぎ去ってしまうよう、ひとり祈りを捧げよう。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_GHOST" TARGET="_blank">亡霊</A></b><br>今夜、人狼に殺された人は人狼になる。また、襲撃を実行した人狼は命を落としてしまうだろう。人狼となった者は報復行動を行わない。ただし、命拾いをしたならば人狼にはならない。<br>一匹狼は亡霊を作らない。',
'<b>逃亡</b><br>せめて一人だけでも、なんとかして逃がそう。今夜の投票で逃亡者を一人決め、夜中の処刑のかわりに密かに逃がすのだ。<br>しかし逃亡者は一日のあいだ逃亡生活を続け、ついに村へと帰還してしまう。帰還者の票は通常の三倍尊重されるだろう。実装がめんどうだから、このまま未定義にしておこうかな。',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_SEANSE" TARGET="_blank">降霊会</A></b><br>こっくりさん、こっくりさん……<br>秘密の儀式で、墓場の霊魂がかえってきた。今日に限り、生者も姿の見えぬ死者も屋根を共にし、議論するだろう。',
'未定義のイベントです。',
'未定義のイベントです。',
'未定義のイベントです。',
);

	# アイテム名
	my @giftname = (
		'おまかせ',  'なし',    '喪失',  '感染',  '','光の輪', '', '悪鬼', '妖精の子', '半端者',
		''        ,'決定者','夢占い師',      '',  '',      '', '',     '',         '',       '',
	);

	# アイテム名（省略時）
	my @giftshortname = (
		'',   '', '喪', '', '', '光',   '','鬼','妖', '端',
		'', '決', '夢', '', '',   '',   '',  '',  '',   '',
	);

	# アイテム用特殊発言欄のラベル
	my @caption_giftsay = (
		'', '', '', '', '', '', '', '囁き', '', '',
		'', '', '', '', '', '', '',     '', '', '',
	);

	# アイテム能力名
	my @abi_gift = (
		'',     '',     '', '', '', '渡す', '', '襲う', '', '',
		'', '投票', '占う', '', '',     '', '',     '', '', '',
	);

	# 役職名
	my @rolename = (
		'おまかせ', '村人'          ,   '聖痕者'      ,   '共有者'      , '共鳴者'  , '占い師'  , '夢占師'      , '気占師'      , '賢者'    , '狩人'       ,
		'霊能者'  , '信仰霊能者'    ,   '導師'        ,   '降霊者'      , '追従者'  , '煽動者'  , '賞金稼'      , '人犬'        , '王子様'  , '憑かれた人' ,
		''        , '呪人'          ,   '預言者'      ,   '病人'        , '錬金術師', '魔女'    , '少女'        , ''            , ''        , ''           ,
		''        , ''              ,   'ヤドカリ人間',   'コウモリ人間', ''        , ''        , ''            , ''            , ''        , ''           ,   
		''        , '狂人'          ,   '狂信者'      ,   '人形使い'    , 'Ｃ国狂人', '半狼'    , ''            , '魔神官'      , '魔術師'  , ''           ,
		''        , ''              ,   '首なし騎士'  ,   ''            , ''        , ''        , ''            , ''            , ''        , ''           ,   
		''        , '人狼'          ,   ''            ,   '智狼'        , '呪狼'    , '白狼'    , '仔狼'        , '衰狼'        , '黙狼'    , ''           ,
		''        , ''              ,   ''            ,   ''            , ''        , ''        , ''            , ''            , ''        , ''           ,   
		''        , 'ハムスター人間',   '教祖'        ,   ''            , ''        , '邪魔之民', '擬狼妖精'    , ''            , '風花妖精', 'ピクシー'   ,
		''        , 'キューピッド'  ,   'アル中'      ,   '神話マニア'  , ''        , '一匹狼'  , ''            , ''            , ''        , ''           ,
	);

	# 役職名（省略時）
	my @roleshortname = (
		'',   '村', '聖', '共', '鳴', '占', ''  , '', '風占', '狩',
	 '霊',   ''  , ''  , '降', ''  , ''  , ''  , '', ''    , '憑',
		'',   ''  , ''  , ''  , '錬', ''  , ''  , '', ''    , ''  ,   
		'',   ''  , '宿', '傘', ''  , ''  , ''  , '', ''    , ''  ,   
		'',   '狂', '信', '形', 'Ｃ', ''  , ''  , '', ''    , ''  ,
		'',   ''  , '騎', ''  , ''  , ''  , ''  , '', ''    , ''  ,   
		'',   '狼', ''  , '智', '呪', ''  , ''  , '', ''    , ''  ,   
		'',   ''  , ''  , ''  , ''  , ''  , ''  , '', ''    , ''  ,   
		'',   'ハ', ''  , ''  , ''  , ''  , ''  , '', ''    , 'Ｐ',   
		'',   'Ｑ', ''  , '神', ''  , ''  , ''  , '', ''    , ''  ,   
	);

	# 能力者用特殊発言欄のラベル
	my @caption_rolesay = (
		'',''    ,''    ,''    ,'共鳴',''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'','念話','念話','念話',''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,'憑依','囁き',''    ,''    ,''    ,'','',
		'',''    ,'囁き',''    ,''    ,''    ,''    ,''    ,'','',
		'','囁き','囁き','囁き','囁き','囁き','囁き','囁き','','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,'囁き',''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
	);

	# 能力名
	my @abi_role = (
		'外出',''    ,''    ,''    ,''        ,'占う'    ,'占う'  ,'占う'  ,'占う'  ,'守る',   
		''    ,''    ,''    ,''    ,''        ,''        ,'狙う'  ,''      ,''      ,'',   
		''    ,''    ,''    ,''    ,'飲薬する','投薬する','夜遊び','疑う'  ,''      ,'',   
		''    ,'隠す','換る',''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,'占う'  ,'',   
		''    ,''    ,'襲う',''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,'襲う','襲う','襲う','襲う'    ,'襲う'    ,'襲う'  ,'襲う'  ,'襲う'  ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'結ぶ',   
		'結ぶ','結ぶ',''    ,'入門',''        ,'襲う'    ,''      ,'誘う'  ,'跳ねる','',
	);

	# 説明
	my $stat_kill   = '殺害します。ただし、対象が護衛されているか、妖精であれば、効力は発揮しません。';
	my $stat_wolf   = '毎夜、人狼全員で一人だけ、村人を'.$stat_kill.'<br>';
	my $stat_wisper = '人狼（とＣ国狂人）同士にしか聞こえない会話が可能です。<br>';
	my $stat_pixi   = '人狼に殺されることがありません。ただし、占いの対象となると死亡します。<br>占い師、霊能者には人間として判別されますが、勝利判定では人間にも人狼にも数えられません。<br>';
	my $stat_enemy  = '人間でありながら、人外に協力する裏切り者です。勝利判定では人間扱いで集計されるため、場合によっては敢えて死ぬ必要があります。';
	my $stat_fm     = '自分以外の共有者・共鳴者が誰か知っています。';
	my $act_seer    = '毎夜、ひとりを占い、その人が';
	my $act_medium  = '無惨な死体について判断することは出来ません。処刑や突然死で死んだ者が';
	my $stat_seer   = 'また、妖精を占うと呪殺することが出来ます。ただし、呪狼を占ってしまうと、呪殺されてしまいます。';
	my $know_seer   = '人間か人狼か判別できます。';
	my $know_wisdom = '持つ役職がわかります。恩恵は、役職とは違います。このため半端者、悪鬼を直接見分けることはできません。';
	my $stat_droop  = 'あなたは、生きた人狼の人数の二日後に、命を落とします。';
	my $stat_angel  = '１日目、好きな二人に“運命の絆”を結びつける事ができます。“運命の絆”を結んだ人は、片方が死亡すると後を追って死亡します。';

	my @explain_gift = (
'',
'',
'<p>あなたは贈り物を<A //dais.kokage.cc/guide/ne.jp/giji/?(Gift)GIFTID_LOST" TARGET="_blank">喪失</A>しました。<br>もう二度と手にすることはないでしょう。もしまたあなたの手に贈り物があっても、消え去ってしまいます。そして、あなたがそれに気付くことはないでしょう。</p>',
'',
'',
'<p>あなたを<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_SHIELD" TARGET="_blank">光の輪</A>が取り巻きます。<br>あなたはもし昨夜、襲撃されていたとしても守られました。<br>光の輪はひとりを一度しか守りません。もし光の輪が'.$stat_gift.'次に光りに守られるべき良き友を選びましょう。</p>',
'<p>あなたを<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_GLASS" TARGET="_blank">魔鏡</A>が照らします。<br>あなたは、魔鏡を渡す相手が'.$know_seer.'<br>'.$stat_seer.'<br>魔鏡はひとりを一度しか照らしません。もし魔鏡'.$stat_gift.'次に正体を暴くべき怪しいやつを選びましょう。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_OGRE" TARGET="_blank">悪鬼</A>です。<br>表向きは他の役目を帯びていますが、あなたは人を襲う悪い鬼なのです。<br>'.$stat_wolf.'また、'.$stat_wisper.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_FAIRY" TARGET="_blank">妖精から生まれた子</A>です。<br>表向きは他の役目を帯びていますが、あなたは人ならぬ存在なのです。<br>狼の襲撃や賞金稼の手により殺されることはありません。ただし占いの対象となると死亡します。<br>占い師、霊能者にどう判別されるかは、もともとの役職によります。勝利判定では人間にも人狼にも数えられません。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_FINK" TARGET="_blank">半端者</A>です。<br>表向きは他の役目を帯びていますが、あなたは人ともつかぬ、人狼ともつかぬ、半端な正体を隠しています。<br>'.$stat_enemy.'</p>',

'',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_DECIDE" TARGET="_blank">決定者</A>です。<br>あなたは追加票を投じる権利を持ちつづけます。行使することで、健在を示すこともできるでしょう。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_SEERONCE" TARGET="_blank">夢占師</A>です。<br>占い師の力を持ちますが、その能力はたった一度しか使うことができません。<br>ひとりを占い、その人が'.$know_seer.'<br>'.$stat_seer.'</p>',
'',
'',
'',
'',
'',
'',
'',
	);

	my @explain_role = (
'<p>あなたは村人です。<br>特殊な能力があるかどうか自覚していません。夜は積極的に外出して、様子をさぐりましょう。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">村人</A>です。<br>特殊な能力はもっていません。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_STIGMA" TARGET="_blank">_ROLESUBID_聖痕者</A>です。<br>独特の印を持つため、あなたの正体は比較的信用されやすいでしょう。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_FM" TARGET="_blank">共有者</A>です。<br>あなたは'.$stat_fm.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SYMPATHY" TARGET="_blank">共鳴者</A>です。<br>あなたは'.$stat_fm.'<br>また、共鳴者同士にしか聞こえない会話が可能です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SEER" TARGET="_blank">占い師</A>です。<br>'.$act_seer.$know_seer.'<br>'.$stat_seer.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SEERWIN" TARGET="_blank">信仰占師</A>です。<br>'.$act_seer.$know_win.'<br>'.$stat_seer.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SEERROLE" TARGET="_blank">賢者</A>です。<br>'.$act_seer.$know_wisdom.'<br>'.$stat_seer.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_GUARD" TARGET="_blank">狩人</A>です。<br>毎夜、一人を狼の襲撃、もしくは付け狙う賞金稼の手から守ることが出来ます。<br>自分自身を守ることは出来ません。</p>',

'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_MEDIUM" TARGET="_blank">霊能者</A>です。<br>'.$act_medium.$know_seer.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_NECROMANCER" TARGET="_blank">降霊者</A>です。<br>'.$act_medium.$know_seer.'<br>また、顔や名前はわかりませんが、あなたの耳には死者の声が届いちゃうことでしょう。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">村人</A>です。<br>特殊な能力はもっていません。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_ALCHEMIST" TARGET="_blank">錬金術師</A>です。<br>あなたは一度だけ、薬を飲むことが出来ます。もし薬を飲んだ日に処刑以外の要因で命を落とした場合、その犯人を道連れにします。人狼の襲撃の場合、襲撃実行者が対象となります。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SNATCH" TARGET="_blank">ヤドカリ人間</A>です。<br>好きな人物の顔と名前を奪い、自身のそれと入れ替えることができます。この能力は非常に露顕しやすいので、行使には注意が必要です。<br>もしも夜の間に屍体になった人を対象に選んだなら、旧いあなたは命を落とし、あなたとなったその屍体は息を吹き返すでしょう。また、結ばれた絆や、笛吹きに誘われたことは姿とともにあり、姿を移し替えたときに引き継ぐことがあります。一度移し替えた姿は、永遠にあなたのものです。二度と元には戻りません。<br>また、念波星でしか聞こえない会話が可能です。<br>'.$stat_enemy.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_BAT" TARGET="_blank">コウモリ人間</A>です。<br>念波星でしか聞こえない会話が可能です。<br>'.$stat_enemy.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_POSSESS" TARGET="_blank">狂人</A>です。<br>'.$stat_enemy.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_FANATIC" TARGET="_blank">狂信者</A>です。<br>人狼にはあなたの正体はわかりませんが、あなたは人狼が誰か知っています。また、新たに人狼となったものを知ることもできます。<br>ですが、あなたは狼血族や擬狼妖精も人狼であると誤認してしまいますし、一匹狼の正体を知ることはできません。<br>'.$stat_enemy.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_MUPPETER" TARGET="_blank">人形使い</A>です。<br>あなたは_NPC_の口を借り、好きな言葉を伝えることができます。<br>'.$stat_enemy.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WISPER" TARGET="_blank">Ｃ国狂人</A>です。<br>'.$stat_wisper.$stat_enemy.'少人数になると勝敗が確定する状況もあります、ですがこの場合も自動で終了することはありません。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_HEADLESS" TARGET="_blank">首のない騎士</A>です。<br>'.$stat_wolf.'そして、あなたは人狼仲間を斬り捨てることも厭いません。<br>また、'.$stat_wisper.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WOLF" TARGET="_blank">人狼</A>です。<br>'.$stat_wolf.'また、'.$stat_wisper.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_INTWOLF" TARGET="_blank">智狼</A>です。特殊な能力を持つ人狼です。<br>仲間や自分が殺害した村人が'.$know_wisdom.$stat_wolf.'また、'.$stat_wisper.'</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_CURSEWOLF" TARGET="_blank">呪狼</A>です。特殊な能力を持つ人狼です。<br>あなたを占ってしまった占い師は死亡します。<br>'.$stat_wolf.'また、'.$stat_wisper.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_PIXI" TARGET="_blank">ハムスター人間</A>です。<br>'.$stat_pixi.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_TRICKSTER" TARGET="_blank">ピクシー</A>です。<br>ピクシーは'.$stat_pixi.$stat_angel.'結ばれた彼らにとっては、単なるはた迷惑な悪戯にすぎません。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_LOVEANGEL" TARGET="_blank">キューピッド</A>です。<br>キューピッドは'.$stat_angel.'<br>結びつけた二人が生き延びれば、あなたの勝利となります。あなたにその絆が結ばれていない限り、あなた自身の死は勝敗には直接関係しません。<br>また、'.$stat_other.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_LOVER" TARGET="_blank">神話マニア</A>です。<br>一日目、好きな人物を師匠として選び、“運命の絆”を結びつけ、弟子入りします。次の朝、あなたは頭角をあらわし、絆の師匠と同じ役職になっています。<br>“運命の絆”を結んだ二人は、片方が死亡すると後を追って死亡します。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
	);

	# 役職希望
	my %explain = (
		prologue => 'あなたは _SELROLE_ を希望しています。ただし、希望した通りの能力者になれるとは限りません。',
		dead     => 'あなたは死亡しています。',
		mob      => 'あなたは<b>_ROLE_の<A h//dais.kokage.cc/guide/e.jp/giji/?(Role)ROLEID_MOB" TARGET="_blank">見物人</A></b>です。いかなる陣営の人数にも含まれません。',
		epilogue => 'あなたは<b>_ROLE_</b>でした（_SELROLE_を希望）。',
		explain_role  => \@explain_role,
		explain_gift  => \@explain_gift,
	);

	# 投票欄表示
	my @votelabels = (
		'投票',
		'委任',
	);


	# 聖痕者の色
	# 五人揃っている所を見てみたい（おい
	my @stigma_subid = (
		'赤の',
		'青の',
		'黄の',
		'緑の',
		'桃の',
		'白の',
		'銀の',
	);

	# 占い結果
	# ふつうのルールで騙りがかわいそうなので、占い結果に日付は添えない。
	my @result_seer = (
		'<b>_NAME_</b>_RESULT_',
		'は<b>人間</b>のようだ。',
		'は【<b>人狼</b>】のようだ。',
		'は【<b>能力者ではない</b>】ようだ。（村人、人狼、白狼、のいずれか）',
		'は<b>能力者</b>のようだ。',
		'は<b>健康</b>そうだ。',
		'は【<b>感染している</b>】ようなので、治療した。',
		'は<b>_ROLE_</b>のようだ。',
		'を調べることができなかった。',
	);

	# 配分表名称
	my %caption_roletable = (
		default  => '標準',
		wbbs_c   => '人狼BBS C国',
		wbbs_f   => '人狼BBS F国',
		test1st  => '人狼審問 試験壱型',
		test2nd  => '人狼審問 試験弐型',
		custom   => '自由設定',
	);

	# アクション
	my @actions = (
		'をハリセンで殴った。',
		'にタライを落とした。',
		'を慰めた。',
		'に手を振った。',		
		'に相づちを打った。',
		'に頷いた。',
		'に首を傾げた。',
		'をじっと見つめた。',
		'を怪訝そうに見た。',
		'をつんつんつついた。',
		'に驚いた。',
		'に照れた。',
		'にお辞儀をした。',
		'に微笑んだ。',
		'を抱きしめた。',
		'を小一時間問いつめた。',
		'が仲間だと感じた。',
		'に感謝した。',
	);

	my %textrs = (
		CAPTION => '人狼物語',
		HELP    => 'ウェブゲーム「人狼物語」風の役職を楽しめます。ただし、細かい動作に違いがあります。',
		FORCE_DEFAULT => 'custom',
		
		# ダミーキャラの参加表示（○○がやってきました）の有無
		NPCENTRYMES => 1,
		
		# 公開アナウンス
		ANNOUNCE_EXTENSION  => '定員に達しなかったため、村の更新日時が24時間延長されました。',
		ENTRYMES            => '_NO_人目、<b>_NAME_</b> がやってきました。',
		EXITMES             => '<b>_NAME_</b>が村を出て行きました。',
		SUDDENDEATH         => '<b>_NAME_</b>は突然死した。',
		SUICIDEBONDS        => '<b>_NAME_</b>は絆に引きずられるように_TARGET_の後を追った。',
		SUICIDELOVERS       => '<b>_NAME_</b>は哀しみに暮れて_TARGET_の後を追った。',
		ANNOUNCE_RANDOMVOTE => '(ランダム投票)',
		ANNOUNCE_VICTORY    => '_VICTORY_です！<br>',
		ANNOUNCE_EPILOGUE   => '_AVICTORY_全てのログとユーザー名を公開します。_DATE_ まで自由に書き込めますので、今回の感想などをどうぞ。',

		RANDOMENTRUST => '(ランダム委任)',

		# 能力関連
		UNDEFTARGET     => '（パス）',
		RANDOMTARGET    => 'ランダム',
		RANDOMROLE      => 'ランダム', # 役職ランダム希望
		NOSELROLE       => '村の設定が「役職希望無視」のため、全ての役職希望が無視されます。',
		SETRANDOMROLE   => '<b>_NAME_</b>の役職希望が _SELROLE_ に自動決定されました。',
		SETRANDOMTARGET => '<b>_NAME_</b>の<b>_ABILITY_</b>の対象が_TARGET_に自動決定されました。',
		CANCELTARGET    => '<b>_NAME_</b>の<b>_ABILITY_</b>に有効な対象がありませんでした。',
		EXECUTESEER     => '<b>_NAME_</b>は<b>_TARGET_</b>を占った。',
		EXECUTEKILL     => '<b>_TARGET_</b>！ 今日がお前の命日だ！',
		EXECUTEALCHEMIST=> '<b>_NAME_</b>は秘薬を飲み下した。',
		EXECUTEKILLWITCH=> '<b>_NAME_</b>は<b>_TARGET_</b>を殺害した。',
		EXECUTELIVEWITCH=> '<b>_NAME_</b>は<b>_TARGET_</b>を蘇生させた。',
		EXECUTEGUARD    => '<b>_NAME_</b>は<b>_TARGET_</b>を守っている。',
		EXECUTEJAMM     => '<b>_NAME_</b>は<b>_TARGET_</b>を隠している。',
		EXECUTETRICKSTER=> '<b>_NAME_</b>は<b>_TARGET1_</b>と<b>_TARGET2_</b>の間に運命の絆を結んだ。',
		EXECUTELOVER    => '<b>_NAME_</b>は<b>_TARGET_</b>との間に運命の絆を結んだ。',
		EXECUTEGURU     => '<b>_NAME_</b>は<b>_TARGET_</b>を誘い込んだ。',
		EXECUTESNATCH   => '<b>_NAME_</b>は<b>_TARGET_</b>の姿を奪った。', 

		EXECUTEFAN      => '<b>_NAME_</b>が遺した扇り文句は、村中を異様な雰囲気に包んだ。', 
		EXECUTECHILDWOLF=> '<b>_NAME_</b>はか細く鳴き、こときれた。', 
		EXECUTEGIRL     => '<b>_NAME_</b>がこっそりお散歩したようだ。',
		EXECUTETHROW    => '<b>_NAME_</b>は<b>_TARGET_</b>に<b>_GIFT_</b>を差し出した。',
		EXECUTELOST     => '<b>_NAME_</b>には<b>_GIFT_</b>は届かなかった…',
		RESULT_RIGHTWOLF=> '<A href="http://dais.kokage.cc/guide/?(Role)ROLEID_RIGHTWOLF" TARGET="_blank">人狼の血族</A>だったようだ。<br>（狼血族のあなたは、占い師、霊能者に人狼と判定されます。ですが、あなたは村人で、勝利条件も変わりません。勝利を目指して頑張りましょう。）',
		RESULT_MEMBER   => '<b>_NAME_</b>から<b>_RESULT_</b>の気配を感じた。',
		RESULT_FANATIC  => '<b>_NAME_</b>から<b>人狼</b>の気配を感じた。',
		RESULT_BAT      => '<b>_NAME_</b>から<b>妖精</b>の気配を感じた。',
		RESULT_GUARD    => '<b>_DATE_日目</b>の夜、<b>_TARGET_</b>を襲撃から守った。',
		RESULT_JAMM     => '<b>_DATE_日目</b>の夜、<b>_TARGET_</b>の正体を占い師から隠した。',
		RESULT_TRICKSTER=> '<b>_DATE_日目</b>の夜、<b>_TARGET1_</b>と<b>_TARGET2_</b>の間に運命の絆を結んだ。',
		RESULT_ZOMBIE   => '<b>_DATE_日目</b>の夜、<b>_TARGET_</b>を<b>感染</b>させた。',
		RESULT_KILL     => '<b>_DATE_日目</b>の夜、<b>_TARGET_</b>を<b>殺害</b>した。',
		RESULT_LIVE     => '<b>_DATE_日目</b>の夜、<b>_TARGET_</b>を<b>蘇生</b>した。',
		RESULT_ALCHEMIST=> '<b>_DATE_日目</b>の夜、秘薬を飲み下した。',
		RESULT_ELDER    => '<b>_DATE_日目</b>の夜、傷を負った。', 
		RESULT_WEREDOG  => '<b>_DATE_日目</b>の夜、傷を負った。あと１日の命だ。', 
		RESULT_SEMIWOLF => '<b>_DATE_日目</b>の夜、人狼に変身した。',
		RESULT_LOVER    => '<b>_DATE_日目</b>の夜、<b>あなた</b>は<b>_TARGET_</b>と運命を分かち合いました。',
		RESULT_LOVEE    => '<b>_DATE_日目</b>の夜、<b>_NAME_</b>が<b>あなた</b>と運命を分かち合いました。',
		RESULT_ROBBER   => 'あなたは盗賊だ。<br>_ROLE_、から選び仮面を纏う。',
		RESULT_DYING    => 'あなたは、もし人狼が<b>_NUMBER_名</b>なら今夜命を落とす。',
		RESULT_GURU     => '<b>_DATE_日目</b>の夜、_TARGET_を誘い込んだ。',
		RESULT_THROW    => '<b>_DATE_日目</b>の夜、<b>_TARGET_</b>に<b>_GIFT_</b>を差し出した。',
		RESULT_ENCOUNT  => '<b>_DATE_日目</b>の夜、不審な姿を見かけた。',

		STATE_BONDS     => 'あなたは<b>_TARGET_</b>と運命の絆を結んでいます。',

		WIN_HUMAN       => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_HUMAN" TARGET="_blank">村人陣営</A></b><br>人間(妖精や人外の者を除く)の数が人狼以下になるまでに人狼と妖精が全滅すれば勝利です。<br>ただし、狼を全滅させた時点で妖精、もしくは恋人が生き残っていると敗北になり、他にも横から勝利を掻っ攫うもの達が存在します。',
		WIN_WOLF        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_WOLF" TARGET="_blank">人狼陣営</A></b><br>ルール「タブラの人狼」「死んだら負け」「Trouble☆Aliens」では人間(妖精や人外の者を除く)の数を人狼と同数以下まで減らせば、ルール「ミラーズホロウ」「深い霧の夜」では役職「村人」を全滅させれば勝利です。<br>ただし、最後まで妖精、もしくは恋人が生き残っていると敗北になり、他にも横から勝利を掻っ攫うもの達が存在します。',
		WIN_LONEWOLF    => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_LONEWOLF" TARGET="_blank">一匹狼陣営</A></b><br>ルール「タブラの人狼」「死んだら負け」「Trouble☆Aliens」では人間(妖精や人外の者を除く)の数を一匹狼と同数以下まで減らせば、ルール「ミラーズホロウ」「深い霧の夜」では役職「村人」を全滅させ、かつ、人狼陣営の狼が生きていなければ勝利です。<br>ただし、最後まで妖精、もしくは恋人が生き残っていると敗北になり、他にも勝利を掻っ攫うもの達が存在します。',
		WIN_PIXI        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_PIXI" TARGET="_blank">妖精陣営</A></b><br>人狼が全滅するか、人間(妖精や人外の者を除く)の数が人狼と同数以下まで減るまで「生き残れば」勝利です。<br>ただし、恋人が生き残っていると敗北になり、他にも横から勝利を掻っ攫うもの達が存在します。',
		WIN_LOVER       => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_LOVER" TARGET="_blank">恋人陣営</A></b><br>恋人達だけが生き残る、もしくはいずこかの陣営が勝利を手にしたとき、絆の恋人達が生存していれば勝利です。ただし、ひとりだけ蘇生したなどの不幸で、恋を成就できない恋人は、勝利しません。',
		WIN_EVIL        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_EVIL" TARGET="_blank">裏切りの陣営</A></b><br>村人・恋人が敗北すれば勝利者の一員に加わります。<br>あなたは破滅を望んでいるのです。人狼や妖精やそれ以外の勝利、または、誰もいなくなることを目指しましょう。',
		MARK_BONDS      => '絆',

		# アクション関連
		ACTIONS_ADDPT          => 'に話の続きを促した。_REST_',
		ACTIONS_RESTADDPT      => '(残_POINT_回)',
		ACTIONS_BOOKMARK       => 'ここまで読んだ。',
		
		# 操作ログ関連
		ANNOUNCE_SELROLE    => '<b>_NAME_</b>は _SELROLE_ を希望しました（他の人には見えません）。',
		ANNOUNCE_SETVOTE    => '<b>_NAME_</b>は<b>_TARGET_</b>を投票先に選びました。',
		ANNOUNCE_SETENTRUST => '投票を委任します。<br><br><b>_NAME_</b>は<b>_TARGET_</b>に投票を委任しました。',
		ANNOUNCE_SETTARGET  => '<b>_NAME_</b>は<b>_TARGET_</b>を<b>_ABILITY_</b>の対象に選びました。',

		# ボタンのラベル
		BUTTONLABEL_PC  => '_BUTTON_ / 更新',
		BUTTONLABEL_MB  => '_BUTTON_',
		CAPTION_SAY_PC  => '発言',
		CAPTION_SAY_MB  => '発言',
		CAPTION_TSAY_PC => '独り言',
		CAPTION_TSAY_MB => '独り言',
		CAPTION_GSAY_PC => '死者のうめき',
		CAPTION_GSAY_MB => 'うめき',
		CAPTION_ROLESAY => \@caption_rolesay,
		CAPTION_GIFTSAY => \@caption_giftsay,
		
		ANNOUNCE_WINNER      => \@announce_winner,
		ANNOUNCE_FIRST       => \@announce_first,
		ANNOUNCE_ROLE        => \@announce_role,
		ANNOUNCE_LIVES       => \@announce_lives,
		ANNOUNCE_VOTE        => \@announce_vote,
		ANNOUNCE_SELECTKILL  => \@announce_selectkill,
		ANNOUNCE_COMMIT      => \@announce_commit,
		ANNOUNCE_TOTALCOMMIT => \@announce_totalcommit,
		ANNOUNCE_ENTRUST     => \@announce_entrust,
		ANNOUNCE_KILL        => \@announce_kill,
		ANNOUNCE_LEAD        => \@announce_lead,
		STATUS_LIVE          => \%status_live,
		CAPTION_WINNER       => \@caption_winner,
		ROLEWIN              => \%role_win,
		ROLENAME             => \@rolename,
		ROLESHORTNAME        => \@roleshortname,
		GIFTNAME             => \@giftname,
		GIFTSHORTNAME        => \@giftshortname,
		ABI_ROLE             => \@abi_role,
		ABI_GIFT             => \@abi_gift,
		EXPLAIN              => \%explain,
		STIGMA_SUBID         => \@stigma_subid,
		RESULT_SEER          => \@result_seer,
		CAPTION_ROLETABLE    => \%caption_roletable,
		VOTELABELS           => \@votelabels,
		ACTIONS              => \@actions,
	);
	return \%textrs;
}

1;
