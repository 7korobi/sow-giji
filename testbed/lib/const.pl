package SWConst;

#----------------------------------------
# SWBBSの定数
#----------------------------------------
sub InitConst {
	# 引数リスト（NaN/Infチェック用）
	# 数値データは0、文字列は1、改行を許す文字列は2
	my %queryinvalid = (
		ua      => 1, # ユーザエージェント
		css     => 1, # CSS指定（オプション）
		uid     => 1, # ユーザID
		u       => 1, # ユーザID（短縮形）
		pwd     => 1, # パスワード
		p       => 1, # パスワード（短縮形）
		cmd     => 1, # 処理内容
		c       => 1, # 処理内容（短縮形）
		move    => 1, # ページ移動方向
#		mv      => 1, # ページ移動方向（短縮形）
		pageno  => 0, # ページ番号
		cmdfrom => 1, # 呼び出し元処理内容
		br      => 1, # 改行文字のテスト用引数

		vid    => 0, # 村番号
		v      => 0, # 村番号（短縮形）
		turn   => 0, # ｎ日目
		t      => 0, # ｎ日目（短縮形）
		mode   => 1, # 終了後の視点切り替え
		m      => 1, # 終了後の視点切り替え（短縮形）
		order  => 1, # 村ログの表示順（昇順／降順）
		o      => 1, # 村ログの表示順短縮形（昇順／降順）
		row    => 0, # 村ログの表示行数
		r      => 0, # 村ログの表示行数（短縮形）
		rowall => 1, # 全表示スイッチ
		logid  => 1, # 村ログ表示時の基準ログID
		l      => 1, # 村ログ表示時の基準ログID（短縮形）
		pno    => 0, # プレイヤー番号（絞り込み用）

		status       => 1, # 廃村復活機能
		vname        => 1, # 村の名前
		vcomment     => 2, # 村の説明
		hour         => 0, # 更新時間（時）
		minite       => 0, # 更新時間（分）
		vplcnt       => 0, # 定員
		vplcntstart  => 0, # 最低人数（開始に必要な人数）
		updinterval  => 0, # 更新間隔
		csid         => 1, # キャラクタセット
		saycnttype   => 1, # 発言制限種別
		entrylimit   => 1, # 参加制限
		entrypwd     => 1, # 参加パスワード
		rating       => 1, # 閲覧制限
		roletable    => 1, # 役職配分
		votetype     => 1, # 投票方法
		starttype    => 1, # 開始方法
		ruleid       => 1, # 文字列リソースセット
		roleid       => 1, # 文字列リソースセット
		giftid       => 1, # 文字列リソースセット
		trsid        => 1, # 文字列リソースセット
		randomtarget => 1, # ランダム対象
		noselrole    => 1, # 役職希望無視
		undead       => 1, # 幽界トーク
		showid       => 1, # ID公開
		mob          => 1, # 見物人タイプ
		game         => 1, # ゲームルール
		sex          => 1,

		cntvillager     => 0,
		cntstigma       => 0,
		cntfm           => 0,
		cntsympathy     => 0,
		cntseer         => 0,
		cntseerwin      => 0,
		cntseeronce     => 0,
		cntaura         => 0,
		cntseerrole     => 0,
		cntguard        => 0,
		cntmedium       => 0,
		cntmediumwin    => 0,
		cntmediumrole   => 0,
		cntnecromancer  => 0,
		cntfollow       => 0,
		cntfan          => 0,
		cnthunter       => 0,
		cntweredog      => 0,
		cntprince       => 0,
		cntrightwolf    => 0,
		cntdoctor       => 0,
		cntcurse        => 0,
		cntdying        => 0,
		cntinvalid      => 0,
		cntalchemist    => 0,
		cntwitch        => 0,
		cntgirl         => 0,
		cntscapegoat    => 0,
		cntelder        => 0,
		cntpossess      => 0,
		cntfanatic      => 0,
		cntmuppeting    => 0,
		cntwisper       => 0,
		cntsemiwolf     => 0,
		cntdyingpossess => 0,
		cntoracle       => 0,
		cntsorcerer     => 0,
		cntwolf         => 0,
		cntaurawolf     => 0,
		cntintwolf      => 0,
		cntcursewolf    => 0,
		cntwhitewolf    => 0,
		cntchildwolf    => 0,
		cntdyingwolf    => 0,
		cntsilentwolf   => 0,
		cntheadless     => 0,
		cnthamster      => 0,
		cntguru         => 0,
		cntbat          => 0,
		cnttrickster    => 0,
		cntjammer       => 0,
		cntmimicry      => 0,
		cntsnatch       => 0,
		cnttelepathy    => 0,
		cntdyingpixi    => 0,
		cntrobber       => 0,
		cntlover        => 0,
		cntlonewolf     => 0,
		cntloveangel    => 0,
		cnthatedevil    => 0,
		cntpassion      => 0,
		cntdish         => 0,
		cntbitch        => 0,
		cntdecide       => 0,
		cntshield       => 0,
		cntglass        => 0,
		cntfink         => 0,
		cntogre         => 0,
		cntfairy        => 0,
		cntmob          => 0,
		cntnothing      => 0,
		cntaprilfool    => 0,
		cntturnfink     => 0,
		cntturnfairy    => 0,
		cnteclipse      => 0,
		cntcointoss     => 0,
		cntforce        => 0,
		cntmiracle      => 0,
		cntprophecy     => 0,
		cntclamor       => 0,
		cntfire         => 0,
		cntnightmare    => 0,
		cntghost        => 0,
		cntescape       => 0,
		cntseance       => 0,
		cntdipsy        => 0,

		cid        => 1, # キャラクタID
		csid_cid   => 1, # キャラクタセット/キャラクタID
		role       => 0, # 役職希望
		gift       => 0, # 役職希望
		queid      => 1, # キューID（発言削除用）
		mes        => 2, # 発言内容
		think      => 1, # 独り言スイッチ
		wolf       => 1, # 囁きスイッチ
		maker      => 1, # 村建て人発言スイッチ
		admin      => 1, # 管理人発言スイッチ
		anonymous  => 1, # 匿名発言スイッチ
		sympathy   => 1, # 共鳴スイッチ
		pixi       => 1, # 念話スイッチ
		muppet     => 1, # 念話スイッチ
		monospace  => 1, # 委任スイッチ
		safety     => 1, # 誤爆防止チェック
		entrust    => 1, # 委任スイッチ
		expression => 0, # 表情ID
		commit     => 0, # コミット
		jobname    => 1, # 肩書き

		target     => 0, # 投票／能力対象者番号
		target2    => 0, # 能力対象者番号２
		selectact  => 1, # アクション種別
		actiontext => 1, # アクション文章
		actionno   => 0, # アクション番号

		prof       => 1, # プロフィールを表示するユーザーのID
		handlename => 1, # ユーザーのハンドル名
		url        => 1, # ユーザーのURL
		intro      => 2, # ユーザーの自己紹介

		vidstart   => 0, # 村番号範囲指定（開始）
		vidend     => 0, # 村番号範囲指定（終了）
		vidmove    => 1, # 村データの移動先

		emulatedays  => 0, # 日付

		# TypeKey
		email => 1,
		name  => 1,
		nick  => 1,
		ts    => 1,
		sig   => 1,
	);

	# 引数短縮形
	my %query_short2full = (
		c => 'cmd',
		l => 'logid',
		m => 'mode',
		o => 'order',
		p => 'pwd',
		r => 'row',
		t => 'turn',
		u => 'uid',
		v => 'vid',
	);

	# ログID発言種別
	my @logmestype = (
		'-', # MESTYPE_UNDEF
		'i', # MESTYPE_INFOSP
		'd', # MESTYPE_DELETEDADMIN
		'c', # MESTYPE_CAST
		'm', # MESTYPE_MAKER
		'a', # MESTYPE_ADMIN
		'q', # MESTYPE_QUEUE
		'I', # MESTYPE_INFONOM
		'D', # MESTYPE_DELETED
		'S', # MESTYPE_SAY
		'T', # MESTYPE_TSAY
		'W', # MESTYPE_WSAY
		'G', # MESTYPE_GSAY
		'P', # MESTYPE_SPSAY
		'X', # MESTYPE_XSAY
		'V', # MESTYPE_VSAY
		'S', # MESTYPE_MSAY
		'T', # MESTYPE_AIM
		'A', # MESTYPE_ANONYMOUS
		'w', # MESTYPE_INFOWOLF
	);

	# 更新情報管理用
	my @modifiedmestype = (
		'',              # MESTYPE_UNDEF
		'',              # MESTYPE_INFOSP
		'',              # MESTYPE_DELETEDADMIN
		'modifiedsay',   # MESTYPE_CAST
		'modifiedsay',   # MESTYPE_MAKER
		'modifiedsay',   # MESTYPE_ADMIN
		'',              # MESTYPE_QUEUE
		'modifiedsay',   # MESTYPE_INFONOM
		'',              # MESTYPE_DELETED
		'modifiedsay',   # MESTYPE_SAY
		'',              # MESTYPE_TSAY
		'modifiedwsay',  # MESTYPE_WSAY
		'modifiedgsay',  # MESTYPE_GSAY
		'modifiedspsay', # MESTYPE_SPSAY
		'modifiedxsay',  # MESTYPE_XSAY
		'modifiedvsay',  # MESTYPE_VSAY
		'modifiedsay',   # MESTYPE_MSAY
		'',              # MESTYPE_AIM
		'modifiedsay',   # MESTYPE_ANONYMOUS
		'',              # MESTYPE_INFOWOLF
	);

	# 発言種別フィルタ変換用配列
	my @mestype2typeid = (
		 5, # MESTYPE_UNDEF
		 5, # MESTYPE_INFOSP
		 5, # MESTYPE_DELETEDADMIN
		 6, # MESTYPE_CAST
		 5, # MESTYPE_MAKER
		 5, # MESTYPE_ADMIN
		 0, # MESTYPE_QUEUE
		 6, # MESTYPE_INFONOM
		 5, # MESTYPE_DELETED
		 0, # MESTYPE_SAY
		 1, # MESTYPE_TSAY
		 2, # MESTYPE_WSAY
		 3, # MESTYPE_GSAY
		 2, # MESTYPE_SPSAY
		 2, # MESTYPE_XSAY
		 4, # MESTYPE_VSAY
		 0, # MESTYPE_MSAY
		 1, # MESTYPE_AIM
		 0, # MESTYPE_ANONYMOUS
		 2, # MESTYPE_INFOWOLF
	);

	my %logcountsubid = (
		X => '',    # LOGSUBID_UNDEF
		S => '',    # LOGSUBID_SAY
		A => 'act', # LOGSUBID_ACTION
	);

	# アンカー指定用の記号
	# もう空いてねーYO!!
	my %loganchormark = (
		m => '#', # MESTYPE_MAKER
		a => '%', # MESTYPE_ADMIN
		S => '',  # MESTYPE_SAY
		          # MESTYPE_MSAY
		T => '-', # MESTYPE_TSAY
		          # MESTYPE_AIM
		W => '*', # MESTYPE_WSAY
		G => '+', # MESTYPE_GSAY
		P => '=', # MESTYPE_SPSAY
		X => '!', # MESTYPE_XSAY
		V => '@', # MESTYPE_VSAY
		A => '----'  ,  # MESTYPE_ANONYMOUS
		c => '-CAST-',  # MESTYPE_CAST
		D => '----'  ,  # MESTYPE_DELETED
		d => '----'  ,  # MESTYPE_DELETEDADMIN
		q => '----'  ,  # MESTYPE_QUEUE
		i => '----'  ,  # MESTYPE_INFOSP
		I => '----'  ,  # MESTYPE_INFONOM
		w => '----'  ,  # MESTYPE_INFOWOLF
	);

	# 役職配分表リスト
	my @order_roletable = (
		'default',  
		'mistery',  
		'wbbs_c', 
		'wbbs_f', 
		'wbbs_g', 
		'test1st', 
		'test2nd', 
		'starwars', 
		'ocarina', 
		'lover', 
		'hater', 
		'custom',   # 自由設定
	);

	# 発言スイッチ
	my @rolesayswitch = (
		'',		#  0
		'',
		'',
		'',
		'sympathy',
		'',
		'',
		'',
		'',
		'',
		'',		# 10
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 20
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 30
		'pixi',
		'pixi',
		'pixi',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 40
		'',
		'',
		'muppet',
		'wolf',
		'',
		'',
		'',
		'',
		'',
		'',		# 50
		'wolf',
		'wolf',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 60
		'wolf',
		'wolf',
		'wolf',
		'wolf',
		'wolf',
		'wolf',
		'wolf',
		'',
		'',
		'',		# 70
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 80
		'',
		'',
		'pixi',
		'',
		'',
		'wolf',
		'',
		'',
		'',
		'',		# 90
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 100
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
	);

	# 発言数ID
	my @saycountid = (
		'',		#  0
		'',
		'',
		'',
		'spsay',
		'',
		'',
		'',
		'',
		'',
		'',		# 10
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 20
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 30
		'wsay',
		'wsay',
		'wsay',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 40
		'',
		'',
		'say',
		'wsay',
		'',
		'',
		'',
		'',
		'',
		'',		# 50
		'wsay',
		'wsay',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 60
		'wsay',
		'wsay',
		'wsay',
		'wsay',
		'wsay',
		'wsay',
		'wsay',
		'',
		'',
		'',		# 70
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 80
		'',
		'',
		'wsay',
		'',
		'',
		'wsay',
		'',
		'',
		'',
		'',		# 90
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',		# 100
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
	);

	# 役職IDリスト
	my @roleid = (
		'undef',
		'villager',
		'stigma',
		'fm',
		'sympathy',
		'seer',
		'seerwin',
		'aura',
		'seerrole',
		'guard',
		'medium',
		'mediumwin',
		'mediumrole',
		'necromancer',
		'follow',
		'fan',
		'hunter',
		'weredog',
		'prince',
		'rightwolf',
		'doctor',
		'curse',
		'dying',
		'invalid',
		'alchemist',
		'witch',
		'girl',
		'scapegoat',
		'elder',
		'29th',
		'30th',
		'jammer',
		'snatch',
		'bat',
		'34th',
		'35th',
		'36th',
		'37th',
		'38th',
		'39th',
		'40th',
		'possess',
		'fanatic',
		'muppeting',
		'wisper',
		'semiwolf',
		'dyingpossess',
		'oracle',
		'sorcerer',
		'49th',
		'50th',
		'51th',
		'headless',
		'53th',
		'54th',
		'55th',
		'56th',
		'57th',
		'58th',
		'59th',
		'60th',
		'wolf',
		'aurawolf',
		'intwolf',
		'cursewolf',
		'whitewolf',
		'childwolf',
		'dyingwolf',
		'silentwolf',
		'69th',
		'70th',
		'71th',
		'72th',
		'73th',
		'74th',
		'75th',
		'76th',
		'77th',
		'78th',
		'79th',
		'80th',
		'hamster',
		'82th',
		'83th',
		'84th',
		'85th',
		'mimicry',
		'87th',
		'dyingpixi',
		'trickster',
		'hatedevil',
		'loveangel',
		'passion',
		'lover',
		'robber',
		'95th',
		'lonewolf',
		'guru',
		'dish',
		'99th',
		'100th',
		'bitch',
		'102th',
		'103th',
		'104th',
		'105th',
		'106th',
		'107th',
		'108th',
		'109th',
	);

	# 追加発言数ID
	my @giftsayswitch = (
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'wolf',
		'',
		'',

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
	);
	# 追加発言数ID
	my @giftsaycountid = (
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'wsay',
		'',
		'',

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
	);

	# 追加IDリスト
	my @giftid = (
		'undef',
		'none',
		'lost',
		'bind',
		'',
		'shield',
		'glass',
		'ogre',
		'fairy',
		'fink',

		'',
		'decide',
		'seeronce',
		'dipsy',
		'',
		'',
		'',
		'',
		'',
		'',
	);

	# イベントIDリスト
	my @eventid = (
		'undef',
		'nothing',
		'aprilfool',
		'turnfink',
		'turnfairy',
		'eclipse',
		'cointoss',
		'force',
		'miracle',
		'prophecy',
		'10th',
		'clamor',
		'fire',
		'nightmare',
		'ghost',
		'escape',
		'seance',
		'17th',
		'18th',
		'19th',
	);

	my %sow = (
		NAME_AUTHOR => 'あず/asbntby',
		MAIL_AUTHOR => 'asbntby@yahoo.co.jp',
		COPY_AUTHOR => 'あず/asbntby',
		URL_AUTHOR  => 'http://asbntby.sakura.ne.jp/',
		SITE_AUTHOR => 'あず開発室',
		VERSION_SW  => 'SWBBS V2.00 Beta 8',

		QUERY_INVALID    => \%queryinvalid,
		QUERY_SHORT2FULL => \%query_short2full,

		# MESTYPE（ログ種別）
		MESTYPE_UNDEF        =>  0,
		MESTYPE_INFOSP       =>  1,
		MESTYPE_DELETEDADMIN =>  2,
		MESTYPE_CAST         =>  3,
		MESTYPE_MAKER        =>  4,
		MESTYPE_ADMIN        =>  5,
		MESTYPE_QUEUE        =>  6,
		MESTYPE_INFONOM      =>  7,
		MESTYPE_DELETED      =>  8,
		MESTYPE_SAY          =>  9,
		MESTYPE_TSAY         => 10,
		MESTYPE_WSAY         => 11,
		MESTYPE_GSAY         => 12,
		MESTYPE_SPSAY        => 13,
		MESTYPE_XSAY         => 14,
		MESTYPE_VSAY         => 15,
		MESTYPE_MSAY         => 16,
		MESTYPE_AIM          => 17,
		MESTYPE_ANONYMOUS    => 18,
		MESTYPE_INFOWOLF     => 19,
		MESTYPE_LAST         => 19,

		LOGSUBID_UNDEF    => 'X',
		LOGSUBID_INFO     => 'I',
		LOGSUBID_SAY      => 'S',
		LOGSUBID_ACTION   => 'A',

		LOGCOUNT_UNDEF    => 99999,
		MAXWIDTH_TURN     => 3,     # 日付の桁数
		MAXWIDTH_LOGCOUNT => 5,     # ログ番号の桁数
		LOGMESTYPE        => \@logmestype,
		MESTYPE2TYPEID    => \@mestype2typeid,
		MARK_LOGANCHOR    => \%loganchormark,
		MODIFIED_MESTYPE  => \@modifiedmestype,

		LOGCOUNT_SUBID   => \%logcountsubid,

		# 品物配列
		GIFTSAYSWITCH    => \@giftsayswitch,
		GIFTSAYCOUNTID   => \@giftsaycountid,
		GIFTID           => \@giftid,

		# 役職配列
		ROLESAYSWITCH    => \@rolesayswitch,
		ROLESAYCOUNTID   => \@saycountid,
		ROLEID           => \@roleid,

		# イベント配列
		EVENTID          => \@eventid,

		# イベント番号
		EVENTID_UNDEF        =>  0,
		EVENTID_NOTHING      =>  1,
		EVENTID_APRIL_FOOL   =>  2,
		EVENTID_TURN_FINK    =>  3,
		EVENTID_TURN_FAIRY   =>  4,
		EVENTID_ECLIPSE      =>  5,
		EVENTID_COINTOSS     =>  6,
		EVENTID_FORCE        =>  7,
		EVENTID_MIRACLE      =>  8,
		EVENTID_PROPHECY     =>  9,
		EVENTID_CLAMOR       =>  11,
		EVENTID_FIRE         =>  12,
		EVENTID_NIGHTMARE    =>  13,
		EVENTID_GHOST        =>  14,
		EVENTID_ESCAPE       =>  15,
		EVENTID_SEANCE       =>  16,

		# 品物番号
		GIFTID_UNDEF         =>  0,
		GIFTID_NOT_HAVE      =>  1,
		GIFTID_LOST          =>  2,

		SIDEST_DEAL          =>  5,
		GIFTID_SHIELD        =>  5,
		GIFTID_GLASS         =>  6,
		GIFTID_OGRE          =>  7,
		GIFTID_FAIRY         =>  8,
		GIFTID_FINK          =>  9,
		GIFTID_DECIDE        => 11,
		GIFTID_SEERONCE      => 12,
		GIFTID_DIPSY         => 13,

		# 役職番号
		ROLEID_UNDEF         =>  0,
		SIDEST_HUMANSIDE     =>  1,
		
		ROLEID_VILLAGER      =>  1,
		ROLEID_STIGMA        =>  2,
		ROLEID_FM            =>  3,
		ROLEID_SYMPATHY      =>  4,
		ROLEID_SEER          =>  5,
		ROLEID_SEERWIN       =>  6,
		ROLEID_AURA          =>  7,
		ROLEID_SEERROLE      =>  8,
		ROLEID_GUARD         =>  9,
		ROLEID_MEDIUM        => 10,
		ROLEID_MEDIUMWIN     => 11,
		ROLEID_MEDIUMROLE    => 12,
		ROLEID_NECROMANCER   => 13,
		ROLEID_FOLLOW        => 14,
		ROLEID_FAN           => 15,
		ROLEID_HUNTER        => 16,
		ROLEID_WEREDOG       => 17,
		ROLEID_PRINCE        => 18,
		ROLEID_RIGHTWOLF     => 19,
		ROLEID_DOCTOR        => 20,
		ROLEID_CURSE         => 21,
		ROLEID_DYING         => 22,
		ROLEID_INVALID       => 23,
		ROLEID_ALCHEMIST     => 24,
		ROLEID_WITCH         => 25,
		ROLEID_GIRL          => 26,
		ROLEID_SCAPEGOAT     => 27,
		ROLEID_ELDER         => 28,
		
		SIDEED_HUMANSIDE     => 30,
		SIDEST_ENEMY         => 30,

		ROLEID_JAMMER        => 31,
		ROLEID_SNATCH        => 32,
		ROLEID_BAT           => 33,
		ROLEID_POSSESS       => 41,
		ROLEID_FANATIC       => 42,
		ROLEID_MUPPETING     => 43,
		ROLEID_WISPER        => 44,
		ROLEID_SEMIWOLF      => 45,
		ROLEID_DYINGPOSSESS  => 46,
		ROLEID_ORACLE        => 47,
		ROLEID_SORCERER      => 48,
		
		SIDEED_ENEMY         => 50,
		SIDEST_WOLFSIDE      => 50,
		
		ROLEID_HEADLESS      => 52,
		ROLEID_WOLF          => 61,
		ROLEID_AURAWOLF      => 62,
		ROLEID_INTWOLF       => 63,
		ROLEID_CURSEWOLF     => 64,
		ROLEID_WHITEWOLF     => 65,
		ROLEID_CHILDWOLF     => 66,
		ROLEID_DYINGWOLF     => 67,
		ROLEID_SILENTWOLF    => 68,
		
		SIDEED_WOLFSIDE      => 70,
		SIDEST_PIXISIDE      => 70,
		
		ROLEID_HAMSTER       => 81,
		ROLEID_MIMICRY       => 86,
		ROLEID_DYINGPIXI     => 88,
		ROLEID_TRICKSTER     => 89,
		
		SIDEED_PIXISIDE      => 90,
		SIDEST_OTHER         => 90,

		ROLEID_HATEDEVIL     => 90,
		ROLEID_LOVEANGEL     => 91,
		ROLEID_PASSION       => 92,
		ROLEID_LOVER         => 93,
		ROLEID_ROBBER        => 94,
		ROLEID_LONEWOLF      => 96,
		ROLEID_GURU          => 97,
		ROLEID_DISH          => 98,
		ROLEID_BITCH         => 101,
		SIDEED_OTHER         => 110,
		ROLEID_MOB           => 999,

		COUNT_ROLE       => scalar(@roleid),
		COUNT_GIFT       => scalar(@giftid),
		COUNT_EVENT      => scalar(@eventid),
		ORDER_ROLETABLE  => \@order_roletable,

		ROLESTATE_DEFAULT    =>  0b011111111,  # 通常
		ROLESTATE_ABI_LIVE   =>  0b011111110,  # 使う 蘇生薬
		ROLESTATE_ABI_KILL   =>  0b011111101,  # 使う 毒薬
		ROLESTATE_ABI_NOROLE =>  0b011111100,  # 能力を使い果たした
		ROLESTATE_ABI_NOGIFT =>  0b011111011,  # 恩恵を使い果たした
		ROLESTATE_ABI_NONE   =>  0b011110000,  # 能力、恩恵、投票を使い果たした（賞金稼ぎが死ぬ前、一時的に発生）
		ROLESTATE_CURSED     =>  0b011111000,  # 呪われた状態（能力、恩恵がない）
		ROLESTATE_HURT       =>  0b011011111,  # 手負いになる
		ROLESTATE_ZOMBIE     =>  0b010111000,  # 感染する（能力、恩恵がない）
		MASKSTATE_ABI_LIVE   =>  0b000000001,  # 枠 蘇生薬
		MASKSTATE_ABI_KILL   =>  0b000000010,  # 枠 毒薬
		MASKSTATE_ABI_ROLE   =>  0b000000011,  # 枠 能力
		MASKSTATE_ABI_GIFT   =>  0b000000100,  # 枠 恩恵
		MASKSTATE_ABILITY    =>  0b000000111,  # 枠 能力全体（投票無効は、単に予約枠）
		MASKSTATE_HURT       =>  0b000100000,  # 枠 襲撃負傷
		MASKSTATE_ZOMBIE     =>  0b001000000,  # 枠 感染
		MASKSTATE_MEDIC      =>  0b001000000,  # 枠 医者による回復
		MASKSTATE_HEAL       =>  0b000100000,  # 枠 死亡＆蘇生時の回復

#		生き死にに関わる回復
#		負傷：回復する。人犬の負傷者などを考慮すると、村人よりか弱くなるため役職コンセプトを外れる。
#		感染：回復しない。感染者は陣営を変更しているので。
#		呪い：回復しない。呪いだから。回復するように変更は要改造だが、そもそも奇跡が呪いを与える
#			　ことから、蘇生者はもう能力を発揮しないという方向性に統一感をもたせるべき。

#		ROLESTATE_ABI_NOVOTE =>  0b011110111,  # 投票を使い果たした
#		MASKSTATE_ABI_VOTE   =>  0b000001000,  # 枠 投票
#		ROLESTATE_INTERDICT  =>  0b011101111,  # 処刑差し止め
#		MASKSTATE_INTERDICT  =>  0b000010000,  # 枠 処刑ガード

		TARGETID_TRUST     => -1, # おまかせ
		TARGETID_RANDOM    => -2, # ランダム

		VSTATUSID_PRO      => 0, # 参加者募集中／開始前
		VSTATUSID_PLAY     => 1, # 進行中
		VSTATUSID_EP       => 2, # 勝敗が決しました
		VSTATUSID_END      => 3, # 終了
		VSTATUSID_SCRAP    => 4, # 廃村（エピ中）
		VSTATUSID_SCRAPEND => 5, # 廃村終了


		WINNER_HUMAN     => 1,
		WINNER_WOLF      => 2,
		WINNER_GURU      => 3,
		WINNER_PIXI_H    => 4,
		WINNER_PIXI_W    => 5,
		WINNER_LONEWOLF  => 6,
		WINNER_LOVER     => 7,
		WINNER_HATER     => 8,
		WINNER_NONE      => 9,

		DATATEXT_NONE => '_none_',
		CHRNAME_INFO  => '[情報]',
		MIKUJI        => \@mikuji,

		# アプリケーションログ出力用
		APLOG_WARNING => 'W',
		APLOG_CAUTION => 'C',
		APLOG_NOTICE  => 'n',
		APLOG_POSTED  => 'p',
		APLOG_OTHERS  => 'o',

		time => time(),
		lock => '',
	);

	return \%sow;
}

1;
