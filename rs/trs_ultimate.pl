package SWTextRS_ultimate;

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
		'の<b>_LIVES_名</b>。',
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
		'<b>_NAME_</b>が時を進めることを諦めた。',
		'<b>_NAME_</b>は時が進むよう祈った。',
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
		'時は来た。村人達は集まり、互いの姿を確認する。',
		'犠牲者はいないようだ。殺戮の手は及ばなかったのだろうか？',
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
		'全ての人物が消え失せた時、其処に残るのは一体何？',
		'全ての人狼を退治した……。人狼に怯える日々は去ったのだ！',
		'村人達は自らの過ちに気付いた。<br>人狼達は最後の食事を済ませると、新たな犠牲者を求めて無人の村を立ち去っていった。',

		'村人達は気付いてしまった。もう疑いあう必要なんてないことに。<br>人も狼も関係ない、夢のような生活が始まる…',
		'全ての人狼を退治した……。<br>だが、勝利に沸き立つ人々は、妖精という真の勝利者に、最後まで気付くことはなかった……',
		'その時、人狼は勝利を確信し、そして初めて過ちに気づいた。<br>しかし、天敵たる妖精を討ち漏らした人狼には、最早なすすべがなかった……',

		'村人達は、そして人狼達も自らの過ちに気付いた。<br>孤独な一匹狼は最後の食事を済ませると、新たな犠牲者を求めて無人の村を立ち去っていった。',
		'村人も、人狼も、妖精でさえも、恋人たちの前では無力でした。<br>必ず最後に愛は勝つのです。',
		'',

		'全ての人物が消え失せた時、其処に残るのは一体何？',
   );

   # 勝利者
   my @caption_winner = (
		'',
		'村人の勝利',
		'人狼の勝利',
		'教祖の勝利',
		'妖精の勝利',
		'妖精の勝利',
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
		WIN_GURU     => '教祖',
		WIN_EVIL     => '裏切りの陣営',
	);

    # イベント名
    my @eventname = (
		  '', ''    , '', '', '', '', '', '', '', '',
		  '', ''    , '', '', '', '', '', '', '', '',
    );

   my @explain_event = (
'未定義のイベントです。',
'今日は、特別なことのない一日のようだ。さあ普段通り、誰かを処刑台にかけよう。',
'<b>四月馬鹿</b><br>大変、大変、大変なことになった。きみの役職は変化しているかもしれない。もしも誰かと絆を結んでいるなら、急に相手が憎くなってしまい、絆の相手にしか投票できない。そして今夜だけは、相方の後を追うことはないことを悟ってしまった……。',
'<b>二重スパイ</b><br>なんということだろう！一人が村側を裏切り、狼に与してしまった。明日以降も、彼は村人を裏切り続けるだろう……。',
'<b>妖精の輪</b><br>なんということだろう！一人が森に立ち入り、妖精の養子になってしまった。明日以降も、彼は村人を裏切り続けるだろう……。',
'<b>日蝕</b><br>暗い日蝕が村中を覆い、お互い顔も名前も解らない。この闇夜は、丸一日続くだろう。',
'<b>Sir Cointoss</b><br>コイントス卿はこの村の投票結果に意見があるようでございます。卿の御意向によっては、処刑を取り止めにすることもあります。五分五分くらいかな。',
'<b>影響力</b><br>今日の投票箱は無色透明だ。投票した瞬間にその中が見えるから、投票をセットするときは気を付けて！',
'<b>奇跡</b><br>帰ってきた！黄泉の国から人狼による犠牲者達がかえってきた！能力は失ったかもしれないけれど、それは些細なことだよ！ね！',
'<b>聖者のお告げ</b><br>聖者は民の夢枕に告げられました。今の任より、保安官にふさわしい人物がいると。あたらしい保安官は皆に喝采で迎え入れられるだろう。',

'未定義のイベントです。',
'<b>不満</b><br>村には不満が鬱屈している。今夜の投票でまた人間を処刑してしまったら……悪夢が始まるのだ。',
'<b>熱意</b><br>村には期待に満ちた熱意が渦巻いている。今夜の投票がひとならぬものを処刑できたなら……悪夢が始まるのだ。',
'<b>悪夢</b><br>恐ろしい一日が始まる。さあ投票して、こんな日が早く過ぎ去ってしまうよう、祈りを捧げよう。',
'<b>亡霊</b><br>今夜、人狼に襲われた人は人狼になる。また、今夜襲撃を実行した人狼は命を落としてしまうだろう。',
'<b>逃亡</b><br>せめて一人だけでも、なんとかして逃がそう。今夜の投票で逃亡者を一人決め、夜中の処刑のかわりに密かに逃がすのだ。<br>しかし逃亡者は一日のあいだ逃亡生活を続け、ついに村へと帰還してしまう。帰還者の票は通常の三倍尊重されるだろう。',
'<b>降霊会</b><br>こっくりさん、こっくりさん……',
'未定義のイベントです。',
'未定義のイベントです。',
'未定義のイベントです。',
);

   # アイテム名
   my @giftname = (
		'おまかせ',  'なし',    '喪失',  '感染',  '','光の輪', '', '', '', '',
		''        ,'決定者','夢占い師',      '',  '',      '', '', '', '', '',
   );

   # アイテム名（省略時）
   my @giftshortname = (
		'',   '', '喪', '', '', '光', '', '', '', '',
		'', '決',   '', '', '',   '', '', '', '', '',
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
		'おまかせ',	'村人',		'聖痕者',	'結社員',	'共鳴者',	'占い師',	'夢占師',	'気占師',	'賢者',		'守護者',
		'',			'',	'導師',	'決定者',	'追従者',	'煽動者',	'賞金稼',	'人犬',		'王子様',	'狼血族',
		'',			'呪人',		'預言者',	'病人',		'錬金術師',	'魔女',		'少女',		'スケープゴート','',			'',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',			'狂人',		'狂信者',	'憑依者',	'囁狂人',	'半狼',		'？？？',	'魔神官',	'魔術師',	'',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',			'人狼',		'判狼',		'智狼',		'呪狼',		'白狼',		'仔狼',		'衰狼',		'黙狼',		'首無騎士',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',			'妖精',		'',		'蝙蝠妖精',	'ピクシー',	'邪魔之民',	'擬狼妖精',	'宿借之民',	'風花妖精',	'',
		'',			'キューピッド',	'アル中',	'弟子',	'盗賊',	'',	'一匹狼',	'教祖',	'',
	);

	# 役職名（省略時）
	my @roleshortname = (
		'',	'村',	'',		'結',	'',		'占',	'',		'気',	'',		'守',
		'',	'',		'導',	'',		'追',	'煽',	'稼',	'犬',	'王',	'血',
		'',	'',		'預',	'病',	'',		'魔',	'少',	'贄',	'',		'',	
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'狂',	'',		'',		'',		'半',	'',		'',		'術',	'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'狼',	'',		'',		'',		'',		'仔',	'',		'',		'',	
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'妖',	'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'Ｑ',	'',		'',		'盗',	'',		'壱',	'教',	'',		'',	
	);


   # 能力者用特殊発言欄のラベル
   my @caption_rolesay = (
		'',''    ,''    ,''    ,'共鳴',''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'','念話','念話','念話',''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,'憑依','囁き',''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'','囁き','囁き','囁き','囁き','囁き','囁き','囁き','','囁き',
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
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,'襲う','襲う','襲う','襲う'    ,'襲う'    ,'襲う'  ,'襲う'  ,'襲う'  ,'襲う',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'結ぶ',   
		'結ぶ','結ぶ',''    ,'入門',''        ,''        ,'襲う'  ,'誘う'  ,'跳ねる','',
   );

   # 説明
   my $stat_kill   = '殺害します。ただし、対象が護衛されているか、光の輪を渡されているか、妖精であれば、効力は発揮しません。また、対象が半狼であれば人狼になります。対象が人犬の場合即死しませんが、彼はあと一日の命でしょう。';
   my $stat_wolf   = '毎夜、人狼全員で一人だけ、村人を'.$stat_kill.'<br>';
   my $stat_wisper = '人狼（と囁き狂人）同士にしか聞こえない会話が可能です。<br>';
   my $stat_pixi   = '人狼に殺されることがありません。ただし、占いの対象となると死亡します。<br>占い師、霊能者には人間として判別されますが、勝利条件では人間にも人狼にも数えられません。<br>';
   my $stat_enemy  = '人間でありながら、人外に協力する裏切り者です。終了条件では人間扱いで集計されるため、場合によっては敢えて死ぬ必要があります。';
   my $stat_fm     = '自分以外の結社員・共鳴者が誰か知っています。';
   my $act_seer    = '毎夜、ひとりを占い、その人が';
   my $act_medium  = '無惨な死体について判断することは出来ません。処刑や突然死で死んだ者が';
   my $stat_seer   = 'また、妖精を占うと呪殺することが出来ます。ただし、呪人、呪狼を占ってしまうと、呪殺されてしまいます。';
   my $know_seer   = '人間か人狼か判別できます。ただし狼血族は人狼と誤認し、白狼は人間と誤認してしまいます。';
   my $know_wisdom = '持つ役職がわかります。';
   my $stat_droop  = 'あなたは、生きた人狼の人数の二日後に、命を落とします。';
   my $stat_angel  = '１日目、好きな二人に“運命の絆”を結びつける事ができます。“運命の絆”を結んだ人は、片方が死亡すると後を追って死亡します。';
   my $stat_other  = 'あなたは、勝利条件では人間として数えられます。';
   my @explain_gift = (
'',
'',
'<p>あなたは贈り物を<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_LOST" TARGET="_blank">喪失</A>しました。<br>もう二度と手にすることはないでしょう。もしまたあなたの手に贈り物があっても、消え去ってしまいます。そして、あなたがそれに気付くことはないでしょう。</p>',
'',
'',
'<p>あなたを<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_SHIELD" TARGET="_blank">光の輪</A>が取り巻きます。<br>あなたはもし昨夜、襲撃されていたとしても守られました。<br>光の輪はひとりを一度しか守りません。もし渡した光の輪がふたたびあなたの手に渡ったら、光の輪は消え去ってしまいます。次に光りに守られるべき良き友を選びましょう。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_FINK" TARGET="_blank">半端者</A>です。<br>表向きは他の役目を帯びていますが、あなたは人ともつかぬ、人狼ともつかぬ、半端な正体を隠しています。<br>'.$stat_enemy.'</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_OGRE" TARGET="_blank">悪鬼</A>です。<br>表向きは他の役目を帯びていますが、あなたは人を襲う悪い鬼なのです。<br>'.$stat_wolf.'また、'.$stat_wisper.'</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_FAIRY" TARGET="_blank">妖精から生まれた子</A>です。<br>表向きは他の役目を帯びていますが、あなたは人ならぬ存在なのです。<br>狼の襲撃や賞金稼の手により殺されることはありません。ただし占いの対象となると死亡します。<br>占い師、霊能者にどう判別されるかは、もともとの役職によります。勝利条件では人間にも人狼にも数えられません。</p>',
'',

'',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_DECIDE" TARGET="_blank">決定者</A>です。<br>あなたは追加票を投じる権利を持ちつづけます。行使することで、健在を示すこともできるでしょう。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_SEERONCE" TARGET="_blank">夢占師</A>です。<br>占い師の力を持ちますが、その能力はたった一度しか使うことができません。<br>ひとりを占い、その人が'.$know_seer.'<br>'.$stat_seer.'</p>',
'',
'',
'',
'',
'',
'',
'',
   );

   my @explain_role = (
'<p>あなたは正体不明です。<br>特殊な能力があるかどうか自覚していません。夜は積極的に外出して、様子をさぐりましょう。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">村人</A>です。<br>特殊な能力はもっていません。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_FM" TARGET="_blank">結社員</A>です。<br>独自の人脈を持つ秘密結社の一員です。'.$stat_fm.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SEER" TARGET="_blank">占い師</A>です。<br>'.$act_seer.$know_seer.'<br>'.$stat_seer.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_AURA" TARGET="_blank">気（オーラ）占い師</A>です。<br>'.$act_seer.'能力を持つか判別出来ます。あなたにとって、村人、人狼、白狼は能力のオーラを持ちませんが、そうでない人物は能力のオーラを纏っていると感じられます。<br>'.$stat_seer.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_GUARD" TARGET="_blank">守護者</A>です。<br>毎夜、一人を狼の襲撃、もしくは付け狙う賞金稼の手から守ることが出来ます。<br>自分自身を守ることは出来ません。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_MEDIUMROLE" TARGET="_blank">導師</A>です。<br>'.$act_medium.$know_wisdom.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_FOLLOW" TARGET="_blank">追従者</A>です。<br>あなたは投票を委任することしかできません。だれかを信じ、委ねましょう。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_FAN" TARGET="_blank">煽動者</A>です。<br>あなたが'.$stat_cycle.'、翌日は、村人達が暴力的に二つの投票をおこない、二人を一度に処刑します。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_HUNTER" TARGET="_blank">賞金稼</A>です。<br>毎夜、一人を付け狙います。<br>あなたが、'.$stat_cycle.'、あなたは付け狙っていた人物を道連れに、'.$stat_kill.'</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_WEREDOG" TARGET="_blank">人犬</A>です。<br>あなたは狼の襲撃を受ける、もしくは賞金稼に道連れにされると傷を負うものの、一日だけ生き長らえます。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_PRINCE" TARGET="_blank">王子様</A>です。<br>あなたが処刑されることに決まると一度だけは、その処刑はとりやめになります。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">村人</A>です。<br>特殊な能力はもっていません。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_DYING" TARGET="_blank">預言者</A>です。<br>'.$stat_droop.'</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_INVALID" TARGET="_blank">病人</A>です。<br>あなたが命を落としたとき、ひとりの犯人が特定できるのであれば、犯人は病気に感染し、いっさいの能力を行使できなくなります。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_WITCH" TARGET="_blank">魔女</A>です。<br>あなたは二日目以降、生きている者に投薬して毒殺するか、死者に投薬して蘇生させます。ただし、毒殺（生者を選ぶ）、蘇生（死者を選ぶ）、はそれぞれ一度ずつだけおこなうことができ、それっきり薬は失われます。薬を使うにはあらかじめ準備するので、もしも投薬する夜に対象が死亡/蘇生したなら、薬は無駄に使われてしまうでしょう。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_GIRL" TARGET="_blank">少女</A>です。<br>あなたは二日目以降、夜に出歩くことができます。人狼の囁き、民の念話、共鳴者の共鳴を誰のものとも判別せず聞いちゃうので、朝になって昨日を振り返ると思い出せることでしょう。顔や名前はわかりませんが。<br>ただしこのとき、もしあなたが人狼の、誰かひとりにでも襲撃される矛先に含まれていると、恐怖のあまり、実際に襲われる犠牲者とは別に死んでしまいます。この死亡を護衛する方法はありません。また、息を引き取るあなたを尻目に、狼達は別の人物を襲撃するでしょう。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SCAPEGOAT" TARGET="_blank">スケープゴート</A>です。<br>もし投票数が同数になり処刑する相手が定まらないと、混乱した村人達に処刑されてしまいます。あなたが最後に指差した人は、後悔する村人達に翌日、処刑されるでしょう。皆、そうするより他にないのです。</p>',
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
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_POSSESS" TARGET="_blank">狂人</A>です。<br>'.$stat_enemy.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SEMIWOLF" TARGET="_blank">半狼</A>です。<br>あなたは狼の襲撃を受ける、もしくは賞金稼に道連れにされると、あなたは人狼になります。<br>'.$stat_enemy.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SORCERER" TARGET="_blank">魔術師</A>です。<br>'.$act_seer.$know_wisdom.'<br>'.$stat_seer.'<br>'.$stat_enemy.'</p>',
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
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_WOLF" TARGET="_blank">人狼</A>です。<br>'.$stat_wolf.'また、'.$stat_wisper.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_CHILDWOLF" TARGET="_blank">仔狼</A>です。特殊な能力を持つ人狼です。<br>あなたが命を落とした翌日、人狼は二つの襲撃をおこない、二人を一度に殺害します。<br>'.$stat_wolf.'また、'.$stat_wisper.'</p>',
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
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_PIXI" TARGET="_blank">妖精</A>です。<br>'.$stat_pixi.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',

'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_LOVEANGEL" TARGET="_blank">キューピッド</A>です。<br>キューピッドは'.$stat_angel.'<br>結びつけた二人が生き延びれば、あなたの勝利となります。あなたにその絆が結ばれていない限り、あなた自身の死は勝敗には直接関係しません。<br>また、'.$stat_other.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_ROBBER" TARGET="_blank">盗賊</A>です。<br>あなたは、誰もならなかった残り役職をすべて知ります。次の夜、その中から運命の導くままひとつの役職を選び、仮面の役職に成り代わるでしょう。運命は、あなたになにを課すでしょうか？</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_LONEWOLF" TARGET="_blank">一匹狼</A>です。<br>人狼ですが、他の人狼とは別個に'.$stat_kill.'<br>また、襲撃先はあなた以外であれば誰でもかまわず、あなた自身は、狼の襲撃や賞金稼の手により殺されることはありません。</p>',
'<p>あなたは<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_GURU" TARGET="_blank">教祖</A>です。<br>教祖は毎晩ふたりずつ、好きな人物をひそかに誘い込むことができます。自分自身を誘うことはできません。<br>誘い込まれた当人たちは信者となって夜な夜な宗教儀式に耽り、そのことを覚えています。しかし、彼らの能力や所属陣営などに変化はありません。<br>また、'.$stat_other.'</p>',
'<p>あなたは、未定義の役職です。</p>',
'<p>あなたは、未定義の役職です。</p>',
   );

   # 役職希望
   my %explain = (
		prologue => 'あなたは_SELROLE_を希望しています。ただし、希望した通りの能力者になれるとは限りません。',
		dead     => 'あなたは_ROLE_ですが、命を落としました。',
		mob      => 'あなたは<b>_ROLE_の<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_MOB" TARGET="_blank">見物人</A></b>です。いかなる陣営の人数にも含まれません。',
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
		custom   => '自由設定',
	);

	# アクション
	my @actions = (
		'と試用したR&Dの新装備に、Ａ評価をつけた。',
		'とにやりと微笑みあった。',
		'にスパム缶を押しつけた。',
		'に画期的なミッションを提案した。さあ、きみも参加しよう！',
		'にロケットシューズを差し出した。10、9、8、……',
		'に「Thiotimoline」と書かれた注射を投与した。',
		'にアスベストアーマーを謹んで進呈した。',
		'にゴシゴシボットをけしかけた。',
		'にあっかんべーをした。',
		'にむぎゅうした。',
		'にクラクションを鳴らした。',
		'にお辞儀をした。',
		'にひどくうろたえた。',
		'に謹んで賄賂を差し出した。',
		'を不信の目で見た。',
		'をつんつんつついた。',
		'を秘密警察(IntSec)に通報しますた。',
		'をじっと見つめた。',
		'を慰める振りをした。',
		'を巻き添えにした。',
		'を秘密結社に招待した。',
		'を「同志！」と呼んでみた。',
		'を空の彼方にぶっ飛ばした。',
		'をセラミックハリセンで殴った。',
		'を純白(Ultra-Violet)のハリセンで殴った。',
		'を自殺的ボランティアに推薦した。',
		'を電子レンジで乾かしてさしあげた。',
		'をプラズマキャノンの的にしてみた。',
		'をトンデモ理論で弁護した。',
		'を冷凍庫に放り込んだ。',
		'を医療ポッドに捧げた。',
		'から逃げ出した！しかし、回り込まれてしまった！',
		'の装備を取り上げて、じろじろ覗き込んだ。',
		'の足下を指さした。たいへん、地面がありませんよ。',
		'の頭を撫でた。',
		'の行いを、最新の「反逆っぽい行動リスト」から見つけ出した。',
		'の靴をほこりひとつないほどに舐め回した。',
		'のチョコレートを借用した。',
	);

	my %textrs = (
		CAPTION => 'アルティメット',
		HELP    => 'カードゲーム「アルティメット人狼」風の役職を楽しめます。ただし、ドワーフ、ドッペルゲンガー、アル中、愚か者、倫理学者には対応していません。',
		FORCE_DEFAULT => 'custom',

		# ダミーキャラの参加表示（○○がやってきました）の有無
		NPCENTRYMES => 0,

		# 公開アナウンス
		ANNOUNCE_EXTENSION  => '定員に達しなかったため、村の更新日時が24時間延長されました。',
		ENTRYMES            => '<b>_NAME_</b>が参加しました。',
		EXITMES             => '<b>_NAME_</b>がいたような気がしたが、気のせいだったようだ……(<b>_NAME_</b>は村を出ました)',
		SUDDENDEATH         => '<b>_NAME_</b>は突然死した。',
		SUICIDEBONDS        => '<b>_NAME_</b>は絆に引きずられるように<b>_TARGET_</b>の後を追った。',
		SUICIDELOVERS       => '<b>_NAME_</b>は哀しみに暮れて<b>_TARGET_</b>の後を追った。',
		ANNOUNCE_RANDOMVOTE => '(ランダム投票)',
		ANNOUNCE_VICTORY    => '<b>_VICTORY_</b>です！<br>',
		ANNOUNCE_EPILOGUE   => '<b>_AVICTORY_</b>全てのログとユーザー名を公開します。<b>_DATE_</b>まで自由に書き込めますので、今回の感想などをどうぞ。',

		RANDOMENTRUST => '(ランダム委任)',

		# 能力関連
		UNDEFTARGET     => '（パス）',
		RANDOMTARGET    => 'ランダム',
		RANDOMROLE      => 'ランダム', # 役職ランダム希望
		NOSELROLE       => '全ての<b>役職希望を無視</b>し、天命を与える。',
		SETRANDOMROLE   => '運命は<b>_NAME_</b>の役職希望を_SELROLE_に決めた。',
		SETRANDOMTARGET => '<b>_NAME_</b>は<b>_ABILITY_</b>の対象を神に任せ、<b>_TARGET_</b>に決まった。',
		CANCELTARGET    => '<b>_NAME_</b>は<b>_ABILITY_</b>をとりやめた。',
		EXECUTEGOTO     => '<b>_NAME_</b>は<b>_TARGET_</b>の処へ出掛けた。',
		EXECUTEALONE    => '<b>_NAME_</b>は<b>一人</b>になった。',
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
		EXECUTESCAPEGOAT=> '<b>_NAME_</b>は<b>_TARGET_</b>を最後に指さした', 
		EXECUTEFAN      => '<b>_NAME_</b>が遺した扇り文句は、村中を異様な雰囲気に包んだ。', 
		EXECUTECHILDWOLF=> '<b>_NAME_</b>はか細く鳴き、こときれた。', 
		EXECUTEGIRL     => '<b>_NAME_</b>がこっそりお散歩したようだ。',
		EXECUTEGIRLFEAR => '<b>_NAME_</b>は恐ろしいものを見てしまった！',
		EXECUTETHROW    => '<b>_NAME_</b>は<b>_TARGET_</b>に<b>_GIFT_</b>を差し出した。',
		EXECUTELOST     => '<b>_NAME_</b>には<b>_GIFT_</b>は届かなかった…',
		EXECUTESHIELDBRK=> '<b>_NAME_</b>に光の輪が渡され、人知れず破壊した。',
		EXECUTEJUMP     => '<b>_DATE_日目</b>の夜、魚の跳ねる瑞々しい音が聞こえた。',
		RESULT_RIGHTWOLF=> '<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_RIGHTWOLF" TARGET="_blank">人狼の血族</A>だったようだ。<br>（狼血族のあなたは、占い師、霊能者に人狼と判定されます。ですが、あなたは村人で、勝利条件も変わりません。勝利を目指して頑張りましょう。）',
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
		RESULT_SCAPEGOAT=> '処刑場の騒動にもかかわらず<b>_TARGET_</b>は息を引き取った。だれも死者を咎めはしなかった。',
		RESULT_ENCOUNT  => '<b>_DATE_日目</b>の夜、不審な姿を見かけた。',

		STATE_SHEEPS    => ' 踊り狂ったおぼろげな記憶がある。',
		STATE_BONDS     => 'あなたは<b>_TARGET_</b>と運命の絆を結んでいます。',
		STATE_BIND      => 'あなたはもう特殊能力を使うことができません。',
		STATE_BIND_ROLE => 'あなたはもう役職能力を使うことができません。',
		STATE_BIND_GIFT => 'あなたはもう恩恵能力を使うことができません。',

		WIN_HUMAN       => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_HUMAN" TARGET="_blank">村人陣営</A></b><br>人間(妖精や人外の者を除く)の数が人狼以下になるまでに人狼と妖精が全滅すれば勝利です。<br>ただし、狼を全滅させた時点で妖精、もしくは恋人が生き残っていると敗北になり、他にも横から勝利を掻っ攫うもの達が存在します。',
		WIN_WOLF        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_WOLF" TARGET="_blank">人狼陣営</A></b><br>ルール「タブラの人狼」「死んだら負け」「Trouble☆Aliens」では人間(妖精や人外の者を除く)の数を人狼と同数以下まで減らせば、ルール「ミラーズホロウ」「深い霧の夜」では役職「村人」を全滅させれば勝利です。<br>ただし、最後まで妖精、もしくは恋人が生き残っていると敗北になり、他にも横から勝利を掻っ攫うもの達が存在します。',
		WIN_LONEWOLF    => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_LONEWOLF" TARGET="_blank">一匹狼陣営</A></b><br>ルール「タブラの人狼」「死んだら負け」「Trouble☆Aliens」では人間(妖精や人外の者を除く)の数を一匹狼と同数以下まで減らせば、ルール「ミラーズホロウ」「深い霧の夜」では役職「村人」を全滅させ、かつ、人狼陣営の狼が生きていなければ勝利です。<br>ただし、最後まで妖精、もしくは恋人が生き残っていると敗北になり、他にも勝利を掻っ攫うもの達が存在します。',
		WIN_PIXI        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_PIXI" TARGET="_blank">妖精陣営</A></b><br>人狼が全滅するか、人間(妖精や人外の者を除く)の数が人狼と同数以下まで減るまで「生き残れば」勝利です。<br>ただし、恋人が生き残っていると敗北になり、他にも横から勝利を掻っ攫うもの達が存在します。',
		WIN_LOVER       => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_LOVER" TARGET="_blank">恋人陣営</A></b><br>恋人達だけが生き残る、もしくはいずこかの陣営が勝利を手にしたとき、絆の恋人達が生存していれば勝利です。ただし、ひとりだけ蘇生したなどの不幸で、恋を成就できない恋人は、勝利しません。',
		WIN_HATER       => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_HATER" TARGET="_blank">邪気陣営</A></b><br>いずこかの陣営が勝利を手にしたとき、運命に決着をつけていれば勝利します。決着とは、絆の天敵をすべて倒し、一人だけが生き残っていることです。殺し合いの絆を断ち切りましょう。絆の相手が死んでも、後を追うことはありません。<br>絆の天敵とは、たとえあなた自身には関係のなくとも、あらゆる絆を結んでいるもの全てを指します。',
		WIN_DISH        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_DISH" TARGET="_blank">据え膳</A></b><br>すべてに決着がついたとき、あなたが狼の襲撃、もしくは賞金稼の道連れにより死亡していれば、勝利者の一員に加わります。',
		WIN_EVIL        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_EVIL" TARGET="_blank">裏切りの陣営</A></b><br>村人・恋人が敗北すれば勝利者の一員に加わります。<br>あなたは破滅を望んでいるのです。人狼や妖精やそれ以外の勝利、または、誰もいなくなることを目指しましょう。',
		WIN_GURU        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_GURU" TARGET="_blank">教祖</A></b><br>教祖以外の生存者が信者だけになれば勝利となります。教祖自身は、最終的に生き残っていなくとも構いません。<br>ただし、横から勝利を掻っ攫うもの達が存在します。',
		MARK_BONDS      => '絆',

		# アクション関連
		ACTIONS_ADDPT          => 'に話の続きを促した。_REST_',
		ACTIONS_RESTADDPT      => '(残_POINT_回)',
		ACTIONS_BOOKMARK       => 'ここまで読んだ。',
		ACTIONS_CLEARANCE_UP   => 'のセキュリティ・クリアランスを引き上げた。',
		ACTIONS_CLEARANCE_DOWN => 'のセキュリティ・クリアランスを引き下ろした。',
		ACTIONS_CLEARANCE_NG   => 'しかし、認められなかった。',
		ACTIONS_ZAP            => 'に別れを告げた。次のクローンはもっとうまくやるだろう。_COUNT_',
		ACTIONS_ZAPCOUNT       => '(_POINT_回目)',

		# 操作ログ関連
		ANNOUNCE_SELROLE    => '<b>_NAME_</b>は _SELROLE_ になれるよう、天に祈った。（他の人には見えません）。',
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
		CAPTION_GSAY_PC => '呻き',
		CAPTION_GSAY_MB => '呻き',
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
