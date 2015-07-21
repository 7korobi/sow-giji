package SWConfig;

#----------------------------------------
# �ݒ�t�@�C��
#----------------------------------------
sub GetConfig {
	# PC���[�h�̕\�������ꗗ
	my @row_pc = (10, 20, 30, 50, 100, 200, 300, 500);

	# �g�у��[�h�̕\�������ꗗ
	my @row_mb = (5, 10, 20, 30, 50, 100, 200, 300, 500);

	# �L�����N�^�[�Z�b�gID
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

	# �����񃊃\�[�X�Z�b�gID
	my @trsidlist = (
		'all',
		'star',
		'regend',
		'heavy',
		'complexx',
		'secret',
	);

	# �̗p����Q�[�����[��
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
      CAPTION     => '�ނ肹��',
      HELP        => '�i24h�񕜁j�i������20pt�j 600pt++100pt/15act',
      COST_SAY    => 'point', # �o�C�g����
      COST_MEMO   => 'point', # 20pt����
      COST_ACT    => 'count', # �񐔊���
      RECOVERY    =>    1, # ��������
      MAX_SAY     =>  600, # ����/�߈�pt��
      MAX_TSAY    =>  600, # �Ƃ茾����pt��
      MAX_SPSAY   =>  600, # ������pt��
      MAX_WSAY    => 1000, # ����/�O�b����pt��
      MAX_GSAY    => 1000, # ���߂�����pt��
      MAX_PSAY    => 1200, # �v�����[�O����pt��
      MAX_ESAY    => 9999, # �G�s���[�O����pt��
      MAX_SAY_ACT =>   15, # �A�N�V������
      ADD_SAY     =>  100, # �����ő����锭��pt��
      MAX_ADDSAY  =>    2, # �����̉�
      MAX_MESCNT  =>  600, # �ꔭ���̍ő啶����
      MAX_MESLINE =>   15, # �ꔭ���̍ő�s��
    );

    my %saycnt_juna = (
      CAPTION     => '�������',
      HELP        => '�i24h�񕜁j 800pt++200pt/24act',
      COST_SAY    => 'point', # �o�C�g����
      COST_MEMO   => 'count', # �񐔊���
      COST_ACT    => 'count', # �񐔊���
      RECOVERY    =>    1, # ��������
      MAX_SAY     =>  800, # ����/�߈�pt��
      MAX_TSAY    =>  700, # �Ƃ茾����pt��
      MAX_SPSAY   =>  700, # ������pt��
      MAX_WSAY    => 3000, # ����/�O�b����pt��
      MAX_GSAY    => 2000, # ���߂�����pt��
      MAX_PSAY    => 2000, # �v�����[�O����pt��
      MAX_ESAY    => 9999, # �G�s���[�O����pt��
      MAX_SAY_ACT =>   24, # �A�N�V������
      ADD_SAY     =>  200, # �����ő����锭��pt��
      MAX_ADDSAY  =>    2, # �����̉�
      MAX_MESCNT  => 1000, # �ꔭ���̍ő啶���o�C�g��
      MAX_MESLINE =>   20, # �ꔭ���̍ő�s��
    );

    my %saycnt_vulcan = (
      CAPTION     => '�����ς�',
      HELP        => '�i24h�񕜁j 1000pt+++300pt/36act',
      COST_SAY    => 'point', # �o�C�g����
      COST_MEMO   => 'count', # �񐔊���
      COST_ACT    => 'count', # �񐔊���
      RECOVERY    =>    1, # ��������
      MAX_SAY     => 1000, # �ʏ픭��pt��
      MAX_TSAY    => 1000, # �Ƃ茾����pt��
      MAX_SPSAY   => 1500, # ������pt��
      MAX_WSAY    => 4000, # ��������pt��
      MAX_GSAY    => 3000, # ���߂�����pt��
      MAX_PSAY    => 3000, # �v�����[�O����pt��
      MAX_ESAY    => 9999, # �G�s���[�O����pt��
      MAX_SAY_ACT =>   36, # �A�N�V����pt��
      ADD_SAY     =>  300, # �����ő����锭��pt��
      MAX_ADDSAY  =>    3, # ������pt��
      MAX_MESCNT  => 1000, # �ꔭ���̍ő啶���o�C�g��
      MAX_MESLINE =>   20, # �ꔭ���̍ő�s��
    );

    my %saycnt_infinity = (
      CAPTION     => '�ނ���',
      HELP        => '��pt/��act',
      COST_SAY    => 'none', # �o�C�g����
      COST_MEMO   => 'none', # �񐔊���
      COST_ACT    => 'none', # �񐔊���
      RECOVERY    =>    1, # ��������
      MAX_SAY     => 9999, # ����/�߈ˉ�
      MAX_TSAY    => 9999, # �Ƃ茾������
      MAX_SPSAY   => 9999, # ��������
      MAX_WSAY    => 9999, # ����/�O�b������
      MAX_GSAY    => 9999, # ���߂�������
      MAX_PSAY    => 9999, # �v�����[�O������
      MAX_ESAY    => 9999, # �G�s���[�O������
      MAX_SAY_ACT =>   99, # �A�N�V������
      ADD_SAY     => 9999, # �����ő����锭����
      MAX_ADDSAY  =>    0, # �����̉�
      MAX_MESCNT  => 1000, # �ꔭ���̍ő啶����
      MAX_MESLINE =>   20, # �ꔭ���̍ő�s��
    );


	my %saycnt = (
		ORDER    => \@saycnt_order,
		weak     => \%saycnt_weak ,
		juna     => \%saycnt_juna ,
		vulcan   => \%saycnt_vulcan ,
		infinity => \%saycnt_infinity ,
	);


	# �摜�̍�ғ��̕\���p
	my @copyrights = (
		'�����ς�A��������A�C�R�� by ���R��',
		'�l�T�c���L�����Z�b�g by �����',
		'�Ǘ�<code> sol�Ela</code><code><a href="mailto:7korobi@gmail.com">�ȂȂ����</a></code>',
		'<code style="display:inline-block;">�l�T�c���Ŏg���Ă���L�����`�b�v�͌����Ƃ��āA�@�@<br />�����ł̗��p���������Ă���܂���B���������������B</code>',
	);

	my %css_star480 = (
		TITLE => '���́��Ɉ������߂�',
		FILE  => 'star480.css',
		WIDTH => 480,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title458r.jpg',
		FILE_TOPBANNER_N => 'banner/title458c.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_star800 = (
		TITLE => '���͖����߂Ȗ�̏���',
		FILE  => 'star800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580r.jpg',
		FILE_TOPBANNER_N => 'banner/title580c.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_night480 = (
		TITLE => '��EM-ONE',
		FILE  => 'night480.css',
		WIDTH => 480,
		ROOM  => 10,
		FILE_TOPBANNER_D => 'banner/title458b.jpg',
		FILE_TOPBANNER_N => 'banner/title458w.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_night800 = (
		TITLE => '����',
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
		TITLE => '�V�l�}',
		FILE  => 'cinema800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580r.jpg',
		FILE_TOPBANNER_N => 'banner/title580c.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_village_t = (
		TITLE => '�k���̑�',
		FILE  => 'village480.css',
		WIDTH => 480,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title458r.jpg',
		FILE_TOPBANNER_N => 'banner/title458c.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_village_w = (
		TITLE => '�k���̑�',
		FILE  => 'village800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580r.jpg',
		FILE_TOPBANNER_N => 'banner/title580c.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_wa480 = (
		TITLE => '��aEM-ONE',
		FILE  => 'wa480.css',
		WIDTH => 480,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title458b.jpg',
		FILE_TOPBANNER_N => 'banner/title458w.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 112,
	);

	my %css_wa800 = (
		TITLE => '��a',
		FILE  => 'wa800.css',
		WIDTH => 800,
		ROOM  => 20,
		FILE_TOPBANNER_D => 'banner/title580b.jpg',
		FILE_TOPBANNER_N => 'banner/title580w.jpg',
		TOPBANNER_WIDTH  => 580,
		TOPBANNER_HEIGHT => 161,
	);

	my %css_ririnra = (
		TITLE => '����',
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

	# ���{�b�g�����p�̐ݒ�
	my @robots = (
		'noindex,nofollow',
	);

	# ���݂���
	# ���͌Œ�Ȃ̂ŕς��Ȃ���
	my @mikuji = (
		'���l�_',   #  3
		'�ꓙ��',   #  4
		'���g',   #  5
		'��g',     #  6
		'���g',     #  7
		'���g',     #  8
		'�g',       #  9
		'���g',     # 10
		'���g',     # 11
		'�����g',   # 12
		'��',       # 13
		'����',     # 14
		'����',     # 15
		'����',     # 16
		'�勥',     # 17
		'�񓚋���', # 18
	);

	# �{�������\��
	my %cd_default = (
		FILE    => 'cd_default.png',
		CAPTION => '�Ƃ��ɂȂ�',
		ALT     => '��',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_love = (
		FILE    => 'cd_love.png',
		CAPTION => '[��] �������d��',
		ALT     => '��',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_sexy = (
		FILE    => 'cd_sexy.png',
		CAPTION => '[��] ���\\������',
		ALT     => '��',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_sexylove = (
		FILE    => 'cd_sexylove.png',
		CAPTION => '[����] ��l�̗���',
		ALT     => '����',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_violence = (
		FILE    => 'cd_violence.png',
		CAPTION => '[�\\] �\\�́A�O��',
		ALT     => '�\\',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_sexyviolence = (
		FILE    => 'cd_sexyviolence.png',
		CAPTION => '[���\\] ���낮��',
		ALT     => '���\\',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_teller = (
		FILE    => 'cd_teller.png',
		CAPTION => '[�|] ���|�����',
		ALT     => '�|',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_drunk = (
		FILE    => 'cd_drunk.png',
		CAPTION => '[�y] ���y�ɒ^��',
		ALT     => '�y',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_gamble = (
		FILE    => 'cd_gamble.png',
		CAPTION => '[�q] �q���ɒ^��',
		ALT     => '�q',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_crime = (
		FILE    => 'cd_crime.png',
		CAPTION => '[��] �ƍߕ`�ʂ���',
		ALT     => '��',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_drug = (
		FILE    => 'cd_drug.png',
		CAPTION => '[��] �򕨕\\������',
		ALT     => '��',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_word = (
		FILE    => 'cd_word.png',
		CAPTION => '[��] �E���A�\\������',
		ALT     => '��',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_fireplace = (
		FILE    => 'cd_fireplace.png',
		CAPTION => '[��] �̂�т�G�k',
		ALT     => '��',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_appare = (
		FILE    => 'cd_appare.png',
		CAPTION => '[�] �����ς�l�^����',
		ALT     => '�',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_ukkari = (
		FILE    => 'cd_ukkari.png',
		CAPTION => '[��] ��������n���Z��',
		ALT     => '��',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_child = (
		FILE    => 'cd_child.png',
		CAPTION => '[�S] ��l���q�������S�҂��A�݂�Ȉ��S',
		ALT     => '�S',
		WIDTH   => 20,
		HEIGHT  => 16,
	);

	my %cd_biohazard = (
		FILE    => 'cd_biohazard.png',
		CAPTION => '[��] �����Ԃ�㓙',
		ALT     => '��',
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

		# 1:�����~�i�A�b�v�f�[�g�p�j
		ENABLED_HALT => 0,

		USERID_NPC     => "master",
		USERID_ADMIN   => "admin",
		ENABLED_VMAKE  => 1,
		URL_SW         => "http://localhost/master",
		NAME_HOME      => "�l�T�c�� �I�̖��X��",
		RULE           => "BRAID",
		MAX_VILLAGES   => 2,
		TIMEOUT_SCRAP  => 5,
		TIMEOUT_ENTRY  => 2,
		TOPPAGE_INFO   => "./_info.pl",
		BASEDIR_CGIERR => "http://localhost/master//",
		BASEDIR_CGI    => ".",
		BASEDIR_DAT    => "./data",
		BASEDIR_DOC    => "http://localhost",

		ENABLED_DELETED      => 1, # �폜������\�����邩�ǂ���
		ENABLED_WINNER_LABEL => 0, # 1:�����ҕ\��������B
		ENABLED_MAX_ESAY     => 0, # �G�s���[�O�𔭌������Ώۂ� 0:���Ȃ��A1:����
		ENABLED_RANDOMTARGET => 1, # 1:���[�E�\�͐�Ɂu�����_���v���܂߂�
		ENABLED_SUDDENDEATH  => 0, # 1:�ˑR������
		ENABLED_BITTY        => 0, # ��������҂̂̂����݂��Ђ炪�Ȃ̂݁B
		ENABLED_PERMIT_DEAD  => 1, # �扺�̐l�T/����/�R�E�����l�Ԃ������������邩�ǂ���
		ENABLED_UNDEAD       => 1, # 1:�H�E�g�[�N����ݒ�\
		ENABLED_AIMING       => 1, # 1:�Ώۂ��w�肵�������i�����b�j���܂߂�
		ENABLED_MOB_AIMING   => 1, # 1:�����l�������b���g����B
		ENABLED_AMBIDEXTER   => 0, # 1:���l�̗��؂��F�߂�i���l�́A�l�T�w�c�ł͂Ȃ����؂�̐w�c������������΂悢�j
		ENABLED_SUICIDE_VOTE => 1, # 1:���E���[
		DEFAULT_VOTETYPE     => "anonymity", # �W���̓��[���@(sign: �L���Aanonymity:���L��)
		ENABLED_POPUP        => 0, # �A���J�[�̃|�b�v�A�b�v

		MESFIXTIME     =>  25, # �ۗ�����
		MAX_ROW        =>  30, # �W���\�����̍s��
		MAX_ROW_MB     =>  20, # �W���\�����̍s���i���o�C���j
		MAX_PAGEROW_PC => 100, # �y�[�W�\�����̍s��(���g�p)
		MAX_PAGES_MB   =>   5, # �y�[�W�����N�̕\����
		ROW_ACTION     =>   0, # �s���v�Z�ɃA�N�V�������܂ނ��ǂ���

		NAME_SW    => '�l�T�c��',       # ���O
		DESC_SW    => '�E�F�u�Ől�T�N���[���B',
		URL_USER   => 'http://giji.check.jp/users',  # ��Ճr���A�[��URL
		URL_CONST  => 'http://crazy-crazy.sakura.ne.jp/giji/?',                # �T�|�[�gwiki��URL
		URL_ROLE   => 'http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_',   # �T�|�[�gwiki��URL
		URL_GIFT   => 'http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_',   # �T�|�[�gwiki��URL
		URL_WIN    => 'http://crazy-crazy.sakura.ne.jp/giji/?(Text)',          # �T�|�[�gwiki��URL
		URL_CONFIG => 'http://crazy-crazy.sakura.ne.jp/giji/?(What)State#l4',  # �T�|�[�gwiki��URL

		# �t�@�C�����b�N�@�\
		ENABLED_GLOCK => 1, # 0: none, 1: flock, 2: rename
		TIMEOUT_GLOCK => 1 * 60, # rename�����̎��̎��Ԑ؂�

		# �W���̃o�i�[�摜
		FILE_TOPBANNER   => 'banner/mwtitle.jpg',
		TOPBANNER_WIDTH  => 458,
		TOPBANNER_HEIGHT => 151,

		#----------------------------------------
		# ���͒l�̐����l
		#----------------------------------------
		MAXSIZE_USERID => 32, # ���[�UID�̍ő�o�C�g��
		MINSIZE_USERID =>  2, # ���[�UID�̍ŏ��o�C�g��
		MAXSIZE_PASSWD => 20, # �p�X���[�h�̍ő�o�C�g��
		MINSIZE_PASSWD =>  3, # �p�X���[�h�̍ŏ��o�C�g��

		MAXSIZE_ACTION   => 120,
		MAXSIZE_MEMOCNT  => 2000,
		MAXSIZE_MEMOLINE => 25,
		MINSIZE_MES      =>   4, # �����̍ŏ��o�C�g��
		MINSIZE_ACTION   =>   4, # �A�N�V�����̍ő�o�C�g��
		MINSIZE_MEMOCNT  =>   4, # �����̍ŏ��o�C�g��

		MAXSIZE_VNAME    =>  40,  # ���̖��O�̍ő�o�C�g��
		MINSIZE_VNAME    =>   6,  # ���̖��O�̍ŏ��o�C�g��
		MAXSIZE_VCOMMENT =>4000,  # ���̐����̍ő�o�C�g��
		MINSIZE_VCOMMENT =>  16,  # ���̐����̍ŏ��o�C�g��
		MAXSIZE_VPLCNT   =>  50,  # ����̍ő吔
		MINSIZE_VPLCNT   =>   4,  # ����̍ŏ���

		MAXSIZE_HANDLENAME =>  64, # �n���h�����̍ő�o�C�g��
		MAXSIZE_URL        => 128, # URL�̍ő�o�C�g��
		MAXSIZE_INTRO      => 600, # ���ȏЉ�̍ő�o�C�g��

		MAXCOUNT_STIGMA => 5, # �����҂̍ő吔

		#----------------------------------------
		# �I�v�V�����@�\
		#----------------------------------------

		# TypeKey�F�؁i�������j
		ENABLED_TYPEKEY => 0, # 1:TypeKey�F�؂�p����
		TOKEN_TYPEKEY => '',

		# QR�R�[�h
		# ���vQRcode Perl CGI & PHP scripts
		# http://www.swetake.com/qr/qr_cgi.html
		ENABLED_QR => 0, # 1:QR�R�[�h�o�͋@�\���g�p����
		# URL_QR => 'http://testserver/qr/perl/qr_img.cgi',

		# gzip�]���@�\
#		FILE_GZIP => '/bin/gzip',
		FILE_GZIP => '/usr/bin/gzip',

		DEFAULT_CSID   => 'ririnra', # �f�t�H���g�̃L�����Z�b�g
		DEFAULT_TEXTRS => 'all',    # �f�t�H���g�̕����񃊃\�[�X

		DEFAULT_UA => 'html401', # �f�t�H���g�̏o�͌`��
		ENABLED_PLLOG  => 0, # 1:�v���C���[�̑��샍�O���L�^
		ENABLED_SCORE  => 0, # �l�T���̏o��

		# RSS�o��
		ENABLED_RSS => 1,
		MAXSIZE_RSSDESC => 400, # RSS �� description�v�f�̍ő�o�C�g��
		RSS_ENCODING_UTF8  => 1, # 1:RSS�� UTF-8 �ŏo�͂���i�vJcode.pm�j

		# �����_���\���@�\
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

		# �A�v���P�[�V�������O
		ENABLED_APLOG   => 0,
		LEVEL_APLOG     => 5,
		MAXSIZE_APLOG   => 65536,
		MAXNO_APLOG     => 9,
		ENABLED_HTTPLOG => 0, # HTTP���O�o��

		OUTPUT_HTTP_EQUIV  => 1, # HTML�� http-equiv ���o�͂��鎞�� 1 �ɁB
		ENABLED_HTTP_CACHE => 0, # 1:�L���b�V�������L���ɂ���i�񐄏��j

		# form�v�f�� method�����l
		# ���܂����삵�Ȃ����� get �ɐݒ肵�Ă݂Ă��������B
		METHOD_FORM => 'post',

		# form�v�f�� method�����l�i�g�у��[�h�j
		# ��̂̌g�тɂ� post ���󂯕t���Ȃ���������炵���B
		# �ŋ߂̂Ȃ�܂����v���ۂ����ǁB
		METHOD_FORM_MB => 'post',

		MAXSIZE_QUERY => 65536,

		# ����
		TIMEZONE => 9, # JST

		# �N�b�L�[�̐�������
		TIMEOUT_COOKIE => 60 * 60 * 20,

		CID_MAKER   => 'maker', # �����Đl�p�̕֋X��̃L����ID
		CID_ADMIN   => 'admin', # �Ǘ��l�p�̕֋X��̃L����ID

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

		PERMITION_MKDIR => 0777, # ���g�p�i�����j

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
