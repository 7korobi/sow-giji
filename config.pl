package SWConfig;

#----------------------------------------
# 設定ファイル
#----------------------------------------
sub GetConfig {
	# PCモードの表示件数一覧
	my @row_pc = (10, 20, 30, 50, 100, 200, 300, 500);

	# 携帯モードの表示件数一覧
	my @row_mb = (5, 10, 20, 30, 50, 100, 200, 300, 500);

	# キャラクターセットID
	my @csidlist = (
		'ririnra',
		'ririnra_c05',
		'ririnra_c08',
		'ririnra_c19',
		'ririnra_c67',
		'ririnra_c68',
		'ririnra_c72',
		'ririnra_c51',
		'ririnra_c20',
		'ririnra_c32',
		'all',
		'mad',
		'time',
		'ger',
		'animal',
		'school',
		'changed',
		'changed_m05',
		'SF',
		'SF_sf10',
		'wa',
		'wa_w23',
	);

	# 文字列リソースセットID
	my @trsidlist = (
		'all',
		'star',
		'regend',
		'heavy',
		'complexx',
		'secret',
	);

	# 採用するゲームルール
	my @gamelist = (
		'TABULA',
		'LIVE_TABULA',
		'MILLERHOLLOW',
		'LIVE_MILLERHOLLOW',
		'TROUBLE',
		'MISTERY',
		'SECRET',
	);

	my @saycnt_order = (
		'weak',
		'juna',
		'vulcan',
		'infinity',
	);

    my %saycnt_weak = (
      CAPTION     => 'むりせず',
      HELP        => '（24h回復）（メモは20pt） 600pt++100pt/15act',
      COST_SAY    => 'point', # バイト勘定
      COST_MEMO   => 'point', # 20pt勘定
      COST_ACT    => 'count', # 回数勘定
      RECOVERY    =>    1, # 発言復活
      MAX_SAY     =>  600, # 発言/憑依pt数
      MAX_TSAY    =>  600, # 独り言発言pt数
      MAX_SPSAY   =>  600, # 共鳴発言pt数
      MAX_WSAY    => 1000, # 囁き/念話発言pt数
      MAX_GSAY    => 1000, # うめき発言pt数
      MAX_PSAY    => 1200, # プロローグ発言pt数
      MAX_ESAY    => 9999, # エピローグ発言pt数
      MAX_SAY_ACT =>   15, # アクション回数
      ADD_SAY     =>  100, # 促しで増える発言pt数
      MAX_ADDSAY  =>    2, # 促しの回数
      MAX_MESCNT  =>  600, # 一発言の最大文字数
      MAX_MESLINE =>   15, # 一発言の最大行数
    );

    my %saycnt_juna = (
      CAPTION     => 'しんもん',
      HELP        => '（24h回復） 800pt++200pt/24act',
      COST_SAY    => 'point', # バイト勘定
      COST_MEMO   => 'count', # 回数勘定
      COST_ACT    => 'count', # 回数勘定
      RECOVERY    =>    1, # 発言復活
      MAX_SAY     =>  800, # 発言/憑依pt数
      MAX_TSAY    =>  700, # 独り言発言pt数
      MAX_SPSAY   =>  700, # 共鳴発言pt数
      MAX_WSAY    => 3000, # 囁き/念話発言pt数
      MAX_GSAY    => 2000, # うめき発言pt数
      MAX_PSAY    => 2000, # プロローグ発言pt数
      MAX_ESAY    => 9999, # エピローグ発言pt数
      MAX_SAY_ACT =>   24, # アクション回数
      ADD_SAY     =>  200, # 促しで増える発言pt数
      MAX_ADDSAY  =>    2, # 促しの回数
      MAX_MESCNT  => 1000, # 一発言の最大文字バイト数
      MAX_MESLINE =>   20, # 一発言の最大行数
    );

    my %saycnt_vulcan = (
      CAPTION     => 'いっぱい',
      HELP        => '（24h回復） 1000pt+++300pt/36act',
      COST_SAY    => 'point', # バイト勘定
      COST_MEMO   => 'count', # 回数勘定
      COST_ACT    => 'count', # 回数勘定
      RECOVERY    =>    1, # 発言復活
      MAX_SAY     => 1000, # 通常発言pt数
      MAX_TSAY    => 1000, # 独り言発言pt数
      MAX_SPSAY   => 1500, # 共鳴発言pt数
      MAX_WSAY    => 4000, # 囁き発言pt数
      MAX_GSAY    => 3000, # うめき発言pt数
      MAX_PSAY    => 3000, # プロローグ発言pt数
      MAX_ESAY    => 9999, # エピローグ発言pt数
      MAX_SAY_ACT =>   36, # アクションpt数
      ADD_SAY     =>  300, # 促しで増える発言pt数
      MAX_ADDSAY  =>    3, # 促しのpt数
      MAX_MESCNT  => 1000, # 一発言の最大文字バイト数
      MAX_MESLINE =>   20, # 一発言の最大行数
    );

    my %saycnt_infinity = (
      CAPTION     => 'むげん',
      HELP        => '∞pt/∞act',
      COST_SAY    => 'none', # バイト勘定
      COST_MEMO   => 'none', # 回数勘定
      COST_ACT    => 'none', # 回数勘定
      RECOVERY    =>    1, # 発言復活
      MAX_SAY     => 9999, # 発言/憑依回数
      MAX_TSAY    => 9999, # 独り言発言回数
      MAX_SPSAY   => 9999, # 共鳴発言回数
      MAX_WSAY    => 9999, # 囁き/念話発言回数
      MAX_GSAY    => 9999, # うめき発言回数
      MAX_PSAY    => 9999, # プロローグ発言回数
      MAX_ESAY    => 9999, # エピローグ発言回数
      MAX_SAY_ACT =>   99, # アクション回数
      ADD_SAY     => 9999, # 促しで増える発言回数
      MAX_ADDSAY  =>    0, # 促しの回数
      MAX_MESCNT  => 1000, # 一発言の最大文字数
      MAX_MESLINE =>   20, # 一発言の最大行数
    );


	my %saycnt = (
		ORDER    => \@saycnt_order,
		weak     => \%saycnt_weak ,
		juna     => \%saycnt_juna ,
		vulcan   => \%saycnt_vulcan ,
		infinity => \%saycnt_infinity ,
	);


	# 画像の作者等の表示用
	my @copyrights = (
		'あっぱれ、うっかりアイコン by 小由流',
		'人狼議事キャラセット by りりんら',
		'管理<code> sol・la</code><code><a href="mailto:7korobi@gmail.com">ななころび</a></code>',
		'<code style="display:inline-block;">人狼議事で使っているキャラチップは原則として、　　<br />他所での利用を許諾しておりません。ご了承ください。</code>',
	);

	my %css_star480 = (
		TITLE => '水の☆に愛を込めて',
		FILE  => 'star480.css',
		WIDTH => 480,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title458r.jpg',
		FILE_TOPBANNER_N => 'banner/title458c.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_star800 = (
		TITLE => '月は無慈悲な夜の女王',
		FILE  => 'star800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580r.jpg',
		FILE_TOPBANNER_N => 'banner/title580c.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_night480 = (
		TITLE => '青EM-ONE',
		FILE  => 'night480.css',
		WIDTH => 480,
		ROOM  => 10,
		FILE_TOPBANNER_D => 'banner/title458b.jpg',
		FILE_TOPBANNER_N => 'banner/title458w.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_night800 = (
		TITLE => '青い月',
		FILE  => 'night800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580b.jpg',
		FILE_TOPBANNER_N => 'banner/title580w.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_cinema480 = (
		TITLE => 'EM-ONE',
		FILE  => 'cinema480.css',
		WIDTH => 480,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title458r.jpg',
		FILE_TOPBANNER_N => 'banner/title458c.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_cinema800 = (
		TITLE => 'シネマ',
		FILE  => 'cinema800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580r.jpg',
		FILE_TOPBANNER_N => 'banner/title580c.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_village_t = (
		TITLE => '北欧の村',
		FILE  => 'village480.css',
		WIDTH => 480,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title458r.jpg',
		FILE_TOPBANNER_N => 'banner/title458c.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_village_w = (
		TITLE => '北欧の村',
		FILE  => 'village800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580r.jpg',
		FILE_TOPBANNER_N => 'banner/title580c.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_wa480 = (
		TITLE => '大和EM-ONE',
		FILE  => 'wa480.css',
		WIDTH => 480,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title458b.jpg',
		FILE_TOPBANNER_N => 'banner/title458w.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_wa800 = (
		TITLE => '大和',
		FILE  => 'wa800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580b.jpg',
		FILE_TOPBANNER_N => 'banner/title580w.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_ririnra = (
		TITLE => '漆黒',
		FILE  => 'ririnra.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580r.jpg',
		FILE_TOPBANNER_N => 'banner/title580b.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);


	my %csslist = (
		star800    => \%css_star800,
		star480    => \%css_star480,
		night800   => \%css_night800,
		night480   => \%css_night480,
		cinema800  => \%css_cinema800,
		cinema480  => \%css_cinema480,
		village_w => \%css_village_w,
		village_t => \%css_village_t,
		wa800      => \%css_wa800,
		wa480      => \%css_wa480,
		ririnra   => \%css_ririnra,
		default   => \%css_cinema800,
	);

	# ロボット検索用の設定
	my @robots = (
		'noindex,nofollow',
	);

	# おみくじ
	# 個数は固定なので変えない事
	my @mikuji = (
		'現人神',   #  3
		'一等賞',   #  4
		'大大吉',   #  5
		'大吉',     #  6
		'中吉',     #  7
		'小吉',     #  8
		'吉',       #  9
		'半吉',     # 10
		'末吉',     # 11
		'末小吉',   # 12
		'凶',       # 13
		'小凶',     # 14
		'半凶',     # 15
		'末凶',     # 16
		'大凶',     # 17
		'回答拒否', # 18
	);

	# 閲覧制限表示
	my %cd_default = (
		FILE    => 'cd_default.png',
		CAPTION => 'とくになし',
		ALT     => '演',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_love = (
		FILE    => 'cd_love.png',
		CAPTION => '[愛] 恋愛を重視',
		ALT     => '愛',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_sexy = (
		FILE    => 'cd_sexy.png',
		CAPTION => '[性] 性表\現あり',
		ALT     => '性',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_sexylove = (
		FILE    => 'cd_sexylove.png',
		CAPTION => '[性愛] 大人の恋愛',
		ALT     => '性愛',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_violence = (
		FILE    => 'cd_violence.png',
		CAPTION => '[暴\] 暴\力、グロ',
		ALT     => '暴\',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_sexyviolence = (
		FILE    => 'cd_sexyviolence.png',
		CAPTION => '[性暴\] えろぐろ',
		ALT     => '性暴\',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_teller = (
		FILE    => 'cd_teller.png',
		CAPTION => '[怖] 恐怖を煽る',
		ALT     => '怖',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_drunk = (
		FILE    => 'cd_drunk.png',
		CAPTION => '[楽] 享楽に耽る',
		ALT     => '楽',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_gamble = (
		FILE    => 'cd_gamble.png',
		CAPTION => '[賭] 賭博に耽る',
		ALT     => '賭',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_crime = (
		FILE    => 'cd_crime.png',
		CAPTION => '[罪] 犯罪描写あり',
		ALT     => '罪',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_drug = (
		FILE    => 'cd_drug.png',
		CAPTION => '[薬] 薬物表\現あり',
		ALT     => '薬',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_word = (
		FILE    => 'cd_word.png',
		CAPTION => '[言] 殺伐、暴\言あり',
		ALT     => '言',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_fireplace = (
		FILE    => 'cd_fireplace.png',
		CAPTION => '[暢] のんびり雑談',
		ALT     => '暢',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_appare = (
		FILE    => 'cd_appare.png',
		CAPTION => '[遖] あっぱれネタ風味',
		ALT     => '遖',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_ukkari = (
		FILE    => 'cd_ukkari.png',
		CAPTION => '[張] うっかりハリセン',
		ALT     => '張',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_child = (
		FILE    => 'cd_child.png',
		CAPTION => '[全] 大人も子供も初心者も、みんな安心',
		ALT     => '全',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_biohazard = (
		FILE    => 'cd_biohazard.png',
		CAPTION => '[危] 無茶ぶり上等',
		ALT     => '危',
		WIDTH   => 20,
		HEIGHT  => 16,
	);



	my @rating_order = ("default", "love", "sexy", "sexylove", "violence", "sexyviolence", "teller", "drunk", "gamble", "crime", "drug", "word", "fireplace", "appare", "ukkari", "child", "biohazard");
	my %rating = (
		ORDER     => \@rating_order,
		default => \%cd_default,
		love => \%cd_love,
		sexy => \%cd_sexy,
		sexylove => \%cd_sexylove,
		violence => \%cd_violence,
		sexyviolence => \%cd_sexyviolence,
		teller => \%cd_teller,
		drunk => \%cd_drunk,
		gamble => \%cd_gamble,
		crime => \%cd_crime,
		drug => \%cd_drug,
		word => \%cd_word,
		fireplace => \%cd_fireplace,
		appare => \%cd_appare,
		ukkari => \%cd_ukkari,
		child => \%cd_child,
		biohazard => \%cd_biohazard,
	);

	my @file_css = (
		'assets-master/application.css',
	);

	my @file_js = (
		'assets-master/base.js',
		'assets-master/const.js',
		'assets-master/sow.js',
	);
	my @file_js_vil = (
		'assets-master/base.js',
		'assets-master/const.js',
		'assets-master/sow.js',
	);

	my %cfg = (
		THEME => 'giji',

		# 1:動作停止（アップデート用）
		ENABLED_HALT => 0,

		USERID_NPC     => "master",
		USERID_ADMIN   => "admin",
		ENABLED_VMAKE  => 1,
		URL_SW         => "http://localhost/master",
		NAME_HOME      => "人狼議事 鯖の味噌煮",
		RULE           => "BRAID",
		MAX_VILLAGES   => 2,
		TIMEOUT_SCRAP  => 5,
		TIMEOUT_ENTRY  => 2,
		TOPPAGE_INFO   => "./_info.pl",
		BASEDIR_CGIERR => "http://localhost/master//",
		BASEDIR_CGI    => ".",
		BASEDIR_DAT    => "./data",
		BASEDIR_DOC    => "http://localhost",

		ENABLED_DELETED      => 1, # 削除発言を表示するかどうか
		ENABLED_WINNER_LABEL => 0, # 1:勝利者表示をする。
		ENABLED_MAX_ESAY     => 0, # エピローグを発言制限対象に 0:しない、1:する
		ENABLED_RANDOMTARGET => 1, # 1:投票・能力先に「ランダム」を含める
		ENABLED_SUDDENDEATH  => 0, # 1:突然死あり
		ENABLED_BITTY        => 0, # 少女や交霊者ののぞきみがひらがなのみ。
		ENABLED_PERMIT_DEAD  => 1, # 墓下の人狼/共鳴者/コウモリ人間が囁きを見られるかどうか
		ENABLED_UNDEAD       => 1, # 1:幽界トーク村を設定可能
		ENABLED_AIMING       => 1, # 1:対象を指定した発言（内緒話）を含める
		ENABLED_MOB_AIMING   => 1, # 1:見物人が内緒話を使える。
		ENABLED_AMBIDEXTER   => 0, # 1:狂人の裏切りを認める（狂人は、人狼陣営ではなく裏切りの陣営＝村が負ければよい）
		ENABLED_SUICIDE_VOTE => 1, # 1:自殺投票
		DEFAULT_VOTETYPE     => "anonymity", # 標準の投票方法(sign: 記名、anonymity:無記名)
		ENABLED_POPUP        => 0, # アンカーのポップアップ

		MESFIXTIME     =>  25, # 保留時間
		MAX_ROW        =>  30, # 標準表示時の行数
		MAX_ROW_MB     =>  20, # 標準表示時の行数（モバイル）
		MAX_PAGEROW_PC => 100, # ページ表示時の行数(未使用)
		MAX_PAGES_MB   =>   5, # ページリンクの表示数
		ROW_ACTION     =>   0, # 行数計算にアクションを含むかどうか

		NAME_SW    => '人狼議事',       # 名前
		DESC_SW    => 'ウェブ版人狼クローン。',
		URL_USER   => 'http://giji.check.jp/users',  # 戦跡ビュアーのURL
		URL_CONST  => 'http://crazy-crazy.sakura.ne.jp/giji/?',                # サポートwikiのURL
		URL_ROLE   => 'http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_',   # サポートwikiのURL
		URL_GIFT   => 'http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_',   # サポートwikiのURL
		URL_WIN    => 'http://crazy-crazy.sakura.ne.jp/giji/?(Text)',          # サポートwikiのURL
		URL_CONFIG => 'http://crazy-crazy.sakura.ne.jp/giji/?(What)State#l4',  # サポートwikiのURL

		# ファイルロック機能
		ENABLED_GLOCK => 1, # 0: none, 1: flock, 2: rename
		TIMEOUT_GLOCK => 1 * 60, # rename方式の時の時間切れ

		# 標準のバナー画像
		FILE_TOPBANNER   => 'banner/mwtitle.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 151,

		#----------------------------------------
		# 入力値の制限値
		#----------------------------------------
		MAXSIZE_USERID => 32, # ユーザIDの最大バイト数
		MINSIZE_USERID =>  2, # ユーザIDの最小バイト数
		MAXSIZE_PASSWD => 20, # パスワードの最大バイト数
		MINSIZE_PASSWD =>  3, # パスワードの最小バイト数

		MAXSIZE_ACTION   => 120,
		MAXSIZE_MEMOCNT  => 2000,
		MAXSIZE_MEMOLINE => 25,
		MINSIZE_MES      =>   4, # 発言の最小バイト数
		MINSIZE_ACTION   =>   4, # アクションの最大バイト数
		MINSIZE_MEMOCNT  =>   4, # メモの最小バイト数

		MAXSIZE_VNAME    =>  40,  # 村の名前の最大バイト数
		MINSIZE_VNAME    =>   6,  # 村の名前の最小バイト数
		MAXSIZE_VCOMMENT =>4000,  # 村の説明の最大バイト数
		MINSIZE_VCOMMENT =>  16,  # 村の説明の最小バイト数
		MAXSIZE_VPLCNT   =>  50,  # 定員の最大数
		MINSIZE_VPLCNT   =>   4,  # 定員の最小数

		MAXSIZE_HANDLENAME =>  64, # ハンドル名の最大バイト数
		MAXSIZE_URL        => 128, # URLの最大バイト数
		MAXSIZE_INTRO      => 600, # 自己紹介の最大バイト数

		MAXCOUNT_STIGMA => 5, # 聖痕者の最大数

		#----------------------------------------
		# オプション機能
		#----------------------------------------

		# TypeKey認証（未実装）
		ENABLED_TYPEKEY => 0, # 1:TypeKey認証を用いる
		TOKEN_TYPEKEY => '',

		# QRコード
		# ※要QRcode Perl CGI & PHP scripts
		# http://www.swetake.com/qr/qr_cgi.html
		ENABLED_QR => 0, # 1:QRコード出力機能を使用する
		# URL_QR => 'http://testserver/qr/perl/qr_img.cgi',

		# gzip転送機能
#		FILE_GZIP => '/bin/gzip',
		FILE_GZIP => '/usr/bin/gzip',

		DEFAULT_CSID   => 'ririnra', # デフォルトのキャラセット
		DEFAULT_TEXTRS => 'all',    # デフォルトの文字列リソース

		DEFAULT_UA => 'html401', # デフォルトの出力形式
		ENABLED_PLLOG  => 0, # 1:プレイヤーの操作ログを記録
		ENABLED_SCORE  => 0, # 人狼譜の出力

		# RSS出力
		ENABLED_RSS => 1,
		MAXSIZE_RSSDESC => 400, # RSS の description要素の最大バイト数
		RSS_ENCODING_UTF8  => 1, # 1:RSSを UTF-8 で出力する（要Jcode.pm）

		# ランダム表示機能
		ENABLED_RANDOMTEXT => 1,
		RANDOMTEXT_DICE    => '([0-9]{1,2})d([0-9]{1,6})',
		RANDOMTEXT_1D6     => '1d6',
		RANDOMTEXT_1D10    => '1d10',
		RANDOMTEXT_1D20    => '1d20',
		RANDOMTEXT_FORTUNE => 'fortune',
		RANDOMTEXT_LIVES   => 'who',
		RANDOMTEXT_MIKUJI  => 'omikuji',
		RANDOMTEXT_ROLE    => 'role',
		RANDOMTEXT_GIFT    => 'gift',
		RANDOMTEXT_EVENT   => 'event',
		RANDOMTEXT_PL_WHO   => 'vil who',
		RANDOMTEXT_PL_ROLE  => 'vil role',
		RANDOMTEXT_PL_GIFT  => 'vil gift',
		RANDOMTEXT_PL_EVENT => 'vil event',

		# アプリケーションログ
		ENABLED_APLOG   => 0,
		LEVEL_APLOG     => 5,
		MAXSIZE_APLOG   => 65536,
		MAXNO_APLOG     => 9,
		ENABLED_HTTPLOG => 0, # HTTPログ出力

		OUTPUT_HTTP_EQUIV  => 1, # HTMLに http-equiv を出力する時は 1 に。
		ENABLED_HTTP_CACHE => 0, # 1:キャッシュ制御を有効にする（非推奨）

		# form要素の method属性値
		# うまく動作しない時は get に設定してみてください。
		METHOD_FORM => 'post',

		# form要素の method属性値（携帯モード）
		# 大昔の携帯には post を受け付けない物があるらしい。
		# 最近のならまず大丈夫っぽいけど。
		METHOD_FORM_MB => 'post',

		MAXSIZE_QUERY => 65536,

		# 時差
		TIMEZONE => 9, # JST

		# クッキーの生存期間
		TIMEOUT_COOKIE => 60 * 60 * 20,

		CID_MAKER   => 'maker', # 村建て人用の便宜上のキャラID
		CID_ADMIN   => 'admin', # 管理人用の便宜上のキャラID

		FILE_WRITE     => "sow.cgi",
		FILE_SOW       => "sow.cgi",
		FILE_VIL       => "vil.cgi",
		FILE_LOG       => "log.cgi",
		FILE_LOGINDEX  => "logidx.cgi",
		FILE_LOGCNT    => "logcnt.cgi",
		FILE_QUE       => "que.cgi",
		FILE_MEMO      => "memo.cgi",
		FILE_MEMOINDEX => "memoidx.cgi",
		FILE_SCORE     => "score.cgi",

		FILE_CSS       => \@file_css,
		FILE_JS        => \@file_js,
		FILE_JS_VIL    => \@file_js_vil,
		FILE_FAVICON   => "favicon.ico",

		PERMITION_MKDIR => 0777, # 未使用（おい）

		MIKUJI           => \@mikuji,
		COPYRIGHTS       => \@copyrights,
		COUNTS_SAY       => \%saycnt,
		CSIDLIST         => \@csidlist,
		TRSIDLIST        => \@trsidlist,
		GAMELIST         => \@gamelist,
		ROW_MB           => \@row_mb,
		ROW_PC           => \@row_pc,
		CSS              => \%csslist,
		RATING           => \%rating,
		MOB              => \%mob,
		ROBOTS           => \@robots,
	);

	my $cfglocalfile = "./_config_local.pl";
	if (-r $cfglocalfile) {
		require $cfglocalfile;
		&SWLocalConfig::GetLocalBaseDirConfig(\%cfg);
	}

	$cfg{'DIR_LIB'}        = "./lib";
	$cfg{'DIR_HTML'}       = "./html";
	$cfg{'DIR_RS'}         = "./rs";
	$cfg{'DIR_VIL'}        = "./data/vil";
	$cfg{'DIR_USER'}       = "./data/user";
	$cfg{'DIR_IMG'}        = "$cfg{'BASEDIR_DOC'}/images";
	$cfg{'DIR_LOG'}        = "$cfg{'BASEDIR_DAT'}/log";
	$cfg{'FILE_LOCK'}      = "$cfg{'BASEDIR_DAT'}/lock";
	$cfg{'DIR_RECORD'}     = "$cfg{'BASEDIR_DAT'}/record";
	$cfg{'FILE_VINDEX'}    = "$cfg{'BASEDIR_DAT'}/vindex.cgi";
	$cfg{'FILE_SOWGROBAL'} = "$cfg{'BASEDIR_DAT'}/sowgrobal.cgi";
	$cfg{'FILE_JCODE'}     = "$cfg{'DIR_LIB'}/jcode.pl";
	$cfg{'FILE_APLOG'}     = "$cfg{'DIR_LOG'}/aplog.cgi";
	$cfg{'FILE_ERRLOG'}    = "$cfg{'DIR_LOG'}/errlog.cgi";

	if (-r $cfglocalfile) {
		require $cfglocalfile;
		&SWLocalConfig::GetLocalConfig(\%cfg);
	}

	return \%cfg;
}

1;
