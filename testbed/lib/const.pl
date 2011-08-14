package SWConst;

#----------------------------------------
# SWBBS�̒萔
#----------------------------------------
sub InitConst {
	# �������X�g�iNaN/Inf�`�F�b�N�p�j
	# ���l�f�[�^��0�A�������1�A���s�������������2
	my %queryinvalid = (
		ua      => 1, # ���[�U�G�[�W�F���g
		css     => 1, # CSS�w��i�I�v�V�����j
		uid     => 1, # ���[�UID
		u       => 1, # ���[�UID�i�Z�k�`�j
		pwd     => 1, # �p�X���[�h
		p       => 1, # �p�X���[�h�i�Z�k�`�j
		cmd     => 1, # �������e
		c       => 1, # �������e�i�Z�k�`�j
		move    => 1, # �y�[�W�ړ�����
#		mv      => 1, # �y�[�W�ړ������i�Z�k�`�j
		pageno  => 0, # �y�[�W�ԍ�
		cmdfrom => 1, # �Ăяo�����������e
		br      => 1, # ���s�����̃e�X�g�p����

		vid    => 0, # ���ԍ�
		v      => 0, # ���ԍ��i�Z�k�`�j
		turn   => 0, # ������
		t      => 0, # �����ځi�Z�k�`�j
		mode   => 1, # �I����̎��_�؂�ւ�
		m      => 1, # �I����̎��_�؂�ւ��i�Z�k�`�j
		order  => 1, # �����O�̕\�����i�����^�~���j
		o      => 1, # �����O�̕\�����Z�k�`�i�����^�~���j
		row    => 0, # �����O�̕\���s��
		r      => 0, # �����O�̕\���s���i�Z�k�`�j
		rowall => 1, # �S�\���X�C�b�`
		logid  => 1, # �����O�\�����̊���OID
		l      => 1, # �����O�\�����̊���OID�i�Z�k�`�j
		pno    => 0, # �v���C���[�ԍ��i�i�荞�ݗp�j

		status       => 1, # �p�������@�\
		vname        => 1, # ���̖��O
		vcomment     => 2, # ���̐���
		hour         => 0, # �X�V���ԁi���j
		minite       => 0, # �X�V���ԁi���j
		vplcnt       => 0, # ���
		vplcntstart  => 0, # �Œ�l���i�J�n�ɕK�v�Ȑl���j
		updinterval  => 0, # �X�V�Ԋu
		csid         => 1, # �L�����N�^�Z�b�g
		saycnttype   => 1, # �����������
		entrylimit   => 1, # �Q������
		entrypwd     => 1, # �Q���p�X���[�h
		rating       => 1, # �{������
		roletable    => 1, # ��E�z��
		votetype     => 1, # ���[���@
		starttype    => 1, # �J�n���@
		ruleid       => 1, # �����񃊃\�[�X�Z�b�g
		roleid       => 1, # �����񃊃\�[�X�Z�b�g
		giftid       => 1, # �����񃊃\�[�X�Z�b�g
		trsid        => 1, # �����񃊃\�[�X�Z�b�g
		randomtarget => 1, # �����_���Ώ�
		noselrole    => 1, # ��E��]����
		undead       => 1, # �H�E�g�[�N
		showid       => 1, # ID���J
		mob          => 1, # �����l�^�C�v
		game         => 1, # �Q�[�����[��
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

		cid        => 1, # �L�����N�^ID
		csid_cid   => 1, # �L�����N�^�Z�b�g/�L�����N�^ID
		role       => 0, # ��E��]
		gift       => 0, # ��E��]
		queid      => 1, # �L���[ID�i�����폜�p�j
		mes        => 2, # �������e
		think      => 1, # �Ƃ茾�X�C�b�`
		wolf       => 1, # �����X�C�b�`
		maker      => 1, # �����Đl�����X�C�b�`
		admin      => 1, # �Ǘ��l�����X�C�b�`
		anonymous  => 1, # ���������X�C�b�`
		sympathy   => 1, # ���X�C�b�`
		pixi       => 1, # �O�b�X�C�b�`
		muppet     => 1, # �O�b�X�C�b�`
		monospace  => 1, # �ϔC�X�C�b�`
		safety     => 1, # �딚�h�~�`�F�b�N
		entrust    => 1, # �ϔC�X�C�b�`
		expression => 0, # �\��ID
		commit     => 0, # �R�~�b�g
		jobname    => 1, # ������

		target     => 0, # ���[�^�\�͑ΏێҔԍ�
		target2    => 0, # �\�͑ΏێҔԍ��Q
		selectact  => 1, # �A�N�V�������
		actiontext => 1, # �A�N�V��������
		actionno   => 0, # �A�N�V�����ԍ�

		prof       => 1, # �v���t�B�[����\�����郆�[�U�[��ID
		handlename => 1, # ���[�U�[�̃n���h����
		url        => 1, # ���[�U�[��URL
		intro      => 2, # ���[�U�[�̎��ȏЉ�

		vidstart   => 0, # ���ԍ��͈͎w��i�J�n�j
		vidend     => 0, # ���ԍ��͈͎w��i�I���j
		vidmove    => 1, # ���f�[�^�̈ړ���

		emulatedays  => 0, # ���t

		# TypeKey
		email => 1,
		name  => 1,
		nick  => 1,
		ts    => 1,
		sig   => 1,
	);

	# �����Z�k�`
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

	# ���OID�������
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

	# �X�V���Ǘ��p
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

	# ������ʃt�B���^�ϊ��p�z��
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

	# �A���J�[�w��p�̋L��
	# �����󂢂Ăˁ[YO!!
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

	# ��E�z���\���X�g
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
		'custom',   # ���R�ݒ�
	);

	# �����X�C�b�`
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

	# ������ID
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

	# ��EID���X�g
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

	# �ǉ�������ID
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
	# �ǉ�������ID
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

	# �ǉ�ID���X�g
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

	# �C�x���gID���X�g
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
		NAME_AUTHOR => '����/asbntby',
		MAIL_AUTHOR => 'asbntby@yahoo.co.jp',
		COPY_AUTHOR => '����/asbntby',
		URL_AUTHOR  => 'http://asbntby.sakura.ne.jp/',
		SITE_AUTHOR => '�����J����',
		VERSION_SW  => 'SWBBS V2.00 Beta 8',

		QUERY_INVALID    => \%queryinvalid,
		QUERY_SHORT2FULL => \%query_short2full,

		# MESTYPE�i���O��ʁj
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
		MAXWIDTH_TURN     => 3,     # ���t�̌���
		MAXWIDTH_LOGCOUNT => 5,     # ���O�ԍ��̌���
		LOGMESTYPE        => \@logmestype,
		MESTYPE2TYPEID    => \@mestype2typeid,
		MARK_LOGANCHOR    => \%loganchormark,
		MODIFIED_MESTYPE  => \@modifiedmestype,

		LOGCOUNT_SUBID   => \%logcountsubid,

		# �i���z��
		GIFTSAYSWITCH    => \@giftsayswitch,
		GIFTSAYCOUNTID   => \@giftsaycountid,
		GIFTID           => \@giftid,

		# ��E�z��
		ROLESAYSWITCH    => \@rolesayswitch,
		ROLESAYCOUNTID   => \@saycountid,
		ROLEID           => \@roleid,

		# �C�x���g�z��
		EVENTID          => \@eventid,

		# �C�x���g�ԍ�
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

		# �i���ԍ�
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

		# ��E�ԍ�
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

		ROLESTATE_DEFAULT    =>  0b011111111,  # �ʏ�
		ROLESTATE_ABI_LIVE   =>  0b011111110,  # �g�� �h����
		ROLESTATE_ABI_KILL   =>  0b011111101,  # �g�� �Ŗ�
		ROLESTATE_ABI_NOROLE =>  0b011111100,  # �\�͂��g���ʂ�����
		ROLESTATE_ABI_NOGIFT =>  0b011111011,  # ���b���g���ʂ�����
		ROLESTATE_ABI_NONE   =>  0b011110000,  # �\�́A���b�A���[���g���ʂ������i�܋��҂������ʑO�A�ꎞ�I�ɔ����j
		ROLESTATE_CURSED     =>  0b011111000,  # ���ꂽ��ԁi�\�́A���b���Ȃ��j
		ROLESTATE_HURT       =>  0b011011111,  # �蕉���ɂȂ�
		ROLESTATE_ZOMBIE     =>  0b010111000,  # ��������i�\�́A���b���Ȃ��j
		MASKSTATE_ABI_LIVE   =>  0b000000001,  # �g �h����
		MASKSTATE_ABI_KILL   =>  0b000000010,  # �g �Ŗ�
		MASKSTATE_ABI_ROLE   =>  0b000000011,  # �g �\��
		MASKSTATE_ABI_GIFT   =>  0b000000100,  # �g ���b
		MASKSTATE_ABILITY    =>  0b000000111,  # �g �\�͑S�́i���[�����́A�P�ɗ\��g�j
		MASKSTATE_HURT       =>  0b000100000,  # �g �P������
		MASKSTATE_ZOMBIE     =>  0b001000000,  # �g ����
		MASKSTATE_MEDIC      =>  0b001000000,  # �g ��҂ɂ���
		MASKSTATE_HEAL       =>  0b000100000,  # �g ���S���h�����̉�

#		�������ɂɊւ���
#		�����F�񕜂���B�l���̕����҂Ȃǂ��l������ƁA���l��肩�キ�Ȃ邽�ߖ�E�R���Z�v�g���O���B
#		�����F�񕜂��Ȃ��B�����҂͐w�c��ύX���Ă���̂ŁB
#		�􂢁F�񕜂��Ȃ��B�􂢂�����B�񕜂���悤�ɕύX�͗v���������A����������Ղ��􂢂�^����
#			�@���Ƃ���A�h���҂͂����\�͂𔭊����Ȃ��Ƃ����������ɓ��ꊴ����������ׂ��B

#		ROLESTATE_ABI_NOVOTE =>  0b011110111,  # ���[���g���ʂ�����
#		MASKSTATE_ABI_VOTE   =>  0b000001000,  # �g ���[
#		ROLESTATE_INTERDICT  =>  0b011101111,  # ���Y�����~��
#		MASKSTATE_INTERDICT  =>  0b000010000,  # �g ���Y�K�[�h

		TARGETID_TRUST     => -1, # ���܂���
		TARGETID_RANDOM    => -2, # �����_��

		VSTATUSID_PRO      => 0, # �Q���ҕ�W���^�J�n�O
		VSTATUSID_PLAY     => 1, # �i�s��
		VSTATUSID_EP       => 2, # ���s�������܂���
		VSTATUSID_END      => 3, # �I��
		VSTATUSID_SCRAP    => 4, # �p���i�G�s���j
		VSTATUSID_SCRAPEND => 5, # �p���I��


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
		CHRNAME_INFO  => '[���]',
		MIKUJI        => \@mikuji,

		# �A�v���P�[�V�������O�o�͗p
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
