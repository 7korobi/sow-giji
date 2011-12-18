package SWTextRS_ultimate;

sub GetTextRS {
	# �v�����[�O�`����ڂ̊J�n�����b�Z�[�W
	my @announce_first = (
		'���̑��ɂ�����ׂ��g�l�T�h�̉\������Ă����B�Ђ����ɐl�ԂƓ���ւ��A��ɂȂ�Ɛl�Ԃ��P���Ƃ��������B�s���ɋ��ꂽ���l�����́A�W��ւƏW�܂�̂������c�c�B',
		'���݂͎���̐��̂�m�����B�����A���l�Ȃ�G�ł���l�T��ގ����悤�B�l�T�Ȃ�c�c���ςɐU�镑���Đl�Ԃ������m���Ɏd���߂Ă����̂��B',
		'�\�͌����������B���h��ꂽ��߂ɏ]�������g�l�T�h�́A�m���ɂ��̒��ɂ���̂��B<br><br>��͂Ȑl�Ԃ��l�T�ɑ΍R���邽�߁A���l�����͈�̃��[�����߂��B���[�ɂ��������҂����Y���Ă������ƁB�߂̂Ȃ��҂����Y���Ă��܂��������邾�낤���A��������̂��߂ɂ͂�ނ𓾂Ȃ��Ɓc�c�B',
	);

	# ��E�z���̂��m�点
	my @announce_role = (
		'�ǂ���炱�̒��ɂ́A_ROLE_����悤���B',
		'��',
		'�l',
		'�A',
	);

	# �����҂̂��m�点
	my @announce_lives = (
		'���݂̐����҂́A',
		'�A',
		'��<b>_LIVES_��</b>�B',
	);

	# ���Y���̂��m�点
	my @announce_vote =(
		'<b>_NAME_</b>��<b>_TARGET_</b>�ɓ��[�����B_RANDOM_',
		'<b>_NAME_</b>��<b>_COUNT_�l</b>�����[�����B',
		'<b>_NAME_</b>�͑��l�̎�ɂ�菈�Y���ꂽ�B',
		'<b>_NAME_</b>�����Y����ɂ͈؂ꑽ�������̂ŁA����߂��B',
		'<b>_NAME_</b>�͑��l�̎�ɂ�菈�Y���ꂽ�B�Ō��<b>_TARGET_</b>���w�����āc�c�B',
	);

   # �P�����̂��m�点
   my @announce_selectkill =(
		'',
		'<b>_NAME_</b>��<b>_COUNT_�l</b>������������B',
		'<b>_NAME_</b>�͏P�����ꂽ�B',
		'',
		'',
   );

	# �D�������A�i�E���X
	my @announce_lead =(
		'���l�Ɛl�T�̐l�����������A���͂͝h�R���Ă���悤�ł��B',
		'���l�������A���l�w�c���D���̂悤�ł��B',
		'�l�T�������A�l�T�w�c���D���̂悤�ł��B',
	);

	# �ϔC���[�̂��m�点
	my @announce_entrust = (
		'<b>_NAME_</b>�͓��[���ϔC���Ă��܂��B_RANDOM_',
		'<b>_NAME_</b>�͓��[���ϔC���悤�Ƃ��܂������A�����s�\�ł����B_RANDOM_',
	);

	# �R�~�b�g
	my @announce_commit = (
		'<b>_NAME_</b>������i�߂邱�Ƃ���߂��B',
		'<b>_NAME_</b>�͎����i�ނ悤�F�����B',
	);

	# �R�~�b�g��
	my @announce_totalcommit = (
		'�u���Ԃ�i�߂�v��I�����Ă���l�́A�܂����Ȃ��悤�ł��B', # 0�`1/3�̎�
		'�u���Ԃ�i�߂�v��I�����Ă���l�������Ă��Ă���悤�ł��B', # 1/3�`2/3�̎�
		'�����̐l���u���Ԃ�i�߂�v��I�����Ă��܂����A�S���ł͂Ȃ��悤�ł��B', # 2/3�`n-1�̎�
		'�S�����u���Ԃ�i�߂�v��I�����Ă��܂��B', # �S���R�~�b�g�ς�
	);

   # �P�����ʃ��b�Z�[�W
   my @announce_kill = (
		'���͗����B���l�B�͏W�܂�A�݂��̎p���m�F����B',
		'�]���҂͂��Ȃ��悤���B�E�C�̎�͋y�΂Ȃ������̂��낤���H',
		'<b>_TARGET_</b>�����c�Ȏp�Ŕ������ꂽ�B',
   );
	
	my %status_live = (
		live       =>  '������',
		executed   =>  '���Y��',
		victim     =>  '�P����',
		cursed     =>  '���f��',
		droop      =>  '���ގ�',
		suicide    =>  '��ǎ�',
		feared     =>  '���|��',
		suddendead =>  '�ˑR��',
	);

   # ���s���b�Z�[�W
   my @announce_winner = (
		'�S�Ă̐l�����������������A�����Ɏc��͈̂�̉��H',
		'�S�Ă̐l�T��ގ������c�c�B�l�T�ɋ�������X�͋������̂��I',
		'���l�B�͎���̉߂��ɋC�t�����B<br>�l�T�B�͍Ō�̐H�����ς܂���ƁA�V���ȋ]���҂����߂Ė��l�̑��𗧂������Ă������B',

		'���l�B�͋C�t���Ă��܂����B�����^�������K�v�Ȃ�ĂȂ����ƂɁB<br>�l���T���֌W�Ȃ��A���̂悤�Ȑ������n�܂�c',
		'�S�Ă̐l�T��ގ������c�c�B<br>�����A�����ɕ������l�X�́A�d���Ƃ����^�̏����҂ɁA�Ō�܂ŋC�t�����Ƃ͂Ȃ������c�c',
		'���̎��A�l�T�͏������m�M���A�����ď��߂ĉ߂��ɋC�Â����B<br>�������A�V�G����d���𓢂��R�炵���l�T�ɂ́A�ő��Ȃ����ׂ��Ȃ������c�c',

		'���l�B�́A�����Đl�T�B������̉߂��ɋC�t�����B<br>�ǓƂȈ�C�T�͍Ō�̐H�����ς܂���ƁA�V���ȋ]���҂����߂Ė��l�̑��𗧂������Ă������B',
		'���l���A�l�T���A�d���ł������A���l�����̑O�ł͖��͂ł����B<br>�K���Ō�Ɉ��͏��̂ł��B',
		'',

		'�S�Ă̐l�����������������A�����Ɏc��͈̂�̉��H',
   );

   # ������
   my @caption_winner = (
		'',
		'���l�̏���',
		'�l�T�̏���',
		'���c�̏���',
		'�d���̏���',
		'�d���̏���',
		'��C�T�̏���',
		'���l�B�̏���',
		'',
		'�����҂Ȃ�',
   );

	my %role_win = (
		WIN_NONE     => '--',
		WIN_DISH     => '�����V',
		WIN_LOVER    => '���l�w�c',
		WIN_HATER    => '�׋C�w�c',
		WIN_LONEWOLF => '��C�T',
		WIN_HUMAN    => '���l�w�c',
		WIN_WOLF     => '�l�T�w�c',
		WIN_PIXI     => '�d��',
		WIN_GURU     => '���c',
		WIN_EVIL     => '���؂�̐w�c',
	);

    # �C�x���g��
    my @eventname = (
		  '', ''    , '', '', '', '', '', '', '', '',
		  '', ''    , '', '', '', '', '', '', '', '',
    );

   my @explain_event = (
'����`�̃C�x���g�ł��B',
'�����́A���ʂȂ��Ƃ̂Ȃ�����̂悤���B�������i�ʂ�A�N�������Y��ɂ����悤�B',
'<b>�l���n��</b><br>��ρA��ρA��ςȂ��ƂɂȂ����B���݂̖�E�͕ω����Ă��邩������Ȃ��B�������N�����J������ł���Ȃ�A�}�ɑ��肪�����Ȃ��Ă��܂��A�J�̑���ɂ������[�ł��Ȃ��B�����č��邾���́A�����̌��ǂ����Ƃ͂Ȃ����Ƃ�����Ă��܂����c�c�B',
'<b>��d�X�p�C</b><br>�Ȃ�Ƃ������Ƃ��낤�I��l�������𗠐؂�A�T�ɗ^���Ă��܂����B�����ȍ~���A�ނ͑��l�𗠐؂葱���邾�낤�c�c�B',
'<b>�d���̗�</b><br>�Ȃ�Ƃ������Ƃ��낤�I��l���X�ɗ�������A�d���̗{�q�ɂȂ��Ă��܂����B�����ȍ~���A�ނ͑��l�𗠐؂葱���邾�낤�c�c�B',
'<b>���I</b><br>�Â����I�������𕢂��A���݂�������O������Ȃ��B���̈Ŗ�́A�ۈ���������낤�B',
'<b>Sir Cointoss</b><br>�R�C���g�X���͂��̑��̓��[���ʂɈӌ�������悤�ł������܂��B���̌�ӌ��ɂ���ẮA���Y�����~�߂ɂ��邱�Ƃ�����܂��B�ܕ��ܕ����炢���ȁB',
'<b>�e����</b><br>�����̓��[���͖��F�������B���[�����u�Ԃɂ��̒��������邩��A���[���Z�b�g����Ƃ��͋C��t���āI',
'<b>���</b><br>�A���Ă����I����̍�����l�T�ɂ��]���ҒB���������Ă����I�\�͎͂�������������Ȃ�����ǁA����͍��ׂȂ��Ƃ���I�ˁI',
'<b>���҂̂�����</b><br>���҂͖��̖����ɍ������܂����B���̔C���A�ۈ����ɂӂ��킵���l��������ƁB�����炵���ۈ����͊F�Ɋ��тŌ}��������邾�낤�B',

'����`�̃C�x���g�ł��B',
'<b>�s��</b><br>���ɂ͕s�����T�����Ă���B����̓��[�ł܂��l�Ԃ����Y���Ă��܂�����c�c�������n�܂�̂��B',
'<b>�M��</b><br>���ɂ͊��҂ɖ������M�ӂ��Q�����Ă���B����̓��[���ЂƂȂ�ʂ��̂����Y�ł����Ȃ�c�c�������n�܂�̂��B',
'<b>����</b><br>���낵��������n�܂�B�������[���āA����ȓ��������߂������Ă��܂��悤�A�F�������悤�B',
'<b>�S��</b><br>����A�l�T�ɏP��ꂽ�l�͐l�T�ɂȂ�B�܂��A����P�������s�����l�T�͖��𗎂Ƃ��Ă��܂����낤�B',
'<b>���S</b><br>���߂Ĉ�l�����ł��A�Ȃ�Ƃ����ē��������B����̓��[�œ��S�҂���l���߁A�钆�̏��Y�̂����ɖ����ɓ������̂��B<br>���������S�҂͈���̂��������S�����𑱂��A���ɑ��ւƋA�҂��Ă��܂��B�A�Ҏ҂̕[�͒ʏ�̎O�{���d����邾�낤�B',
'<b>�~���</b><br>�������肳��A�������肳��c�c',
'����`�̃C�x���g�ł��B',
'����`�̃C�x���g�ł��B',
'����`�̃C�x���g�ł��B',
);

   # �A�C�e����
   my @giftname = (
		'���܂���',  '�Ȃ�',    '�r��',  '����',  '','���̗�', '', '', '', '',
		''        ,'�����','���肢�t',      '',  '',      '', '', '', '', '',
   );

   # �A�C�e�����i�ȗ����j
   my @giftshortname = (
		'',   '', '�r', '', '', '��', '', '', '', '',
		'', '��',   '', '', '',   '', '', '', '', '',
   );

   # �A�C�e���p���ꔭ�����̃��x��
   my @caption_giftsay = (
		'', '', '', '', '', '', '', '����', '', '',
		'', '', '', '', '', '', '',     '', '', '',
   );

   # �A�C�e���\�͖�
   my @abi_gift = (
		'',     '',     '', '', '', '�n��', '', '�P��', '', '',
		'', '���[', '�肤', '', '',     '', '',     '', '', '',
   );

	# ��E��
	my @rolename = (
		'���܂���',	'���l',		'������',	'���Ј�',	'����',	'�肢�t',	'����t',	'�C��t',	'����',		'����',
		'',			'',	'���t',	'�����',	'�Ǐ]��',	'������',	'�܋���',	'�l��',		'���q�l',	'�T����',
		'',			'���l',		'�a����',	'�a�l',		'�B���p�t',	'����',		'����',		'�X�P�[�v�S�[�g','',			'',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',			'���l',		'���M��',	'�߈ˎ�',	'�����l',	'���T',		'�H�H�H',	'���_��',	'���p�t',	'',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',			'�l�T',		'���T',		'�q�T',		'���T',		'���T',		'�e�T',		'���T',		'�٘T',		'�񖳋R�m',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',			'�d��',		'',		'�啗d��',	'�s�N�V�[',	'�ז��V��',	'�[�T�d��',	'�h�ؔV��',	'���ԗd��',	'',
		'',			'�L���[�s�b�h',	'�A����',	'��q',	'����',	'',	'��C�T',	'���c',	'',
	);

	# ��E���i�ȗ����j
	my @roleshortname = (
		'',	'��',	'',		'��',	'',		'��',	'',		'�C',	'',		'��',
		'',	'',		'��',	'',		'��',	'��',	'��',	'��',	'��',	'��',
		'',	'',		'�a',	'�a',	'',		'��',	'��',	'��',	'',		'',	
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'��',	'',		'',		'',		'��',	'',		'',		'�p',	'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'�T',	'',		'',		'',		'',		'�e',	'',		'',		'',	
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'�d',	'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'�p',	'',		'',		'��',	'',		'��',	'��',	'',		'',	
	);


   # �\�͎җp���ꔭ�����̃��x��
   my @caption_rolesay = (
		'',''    ,''    ,''    ,'����',''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'','�O�b','�O�b','�O�b',''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,'�߈�','����',''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'','����','����','����','����','����','����','����','','����',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,'����',''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
   );

   # �\�͖�
   my @abi_role = (
		'�O�o',''    ,''    ,''    ,''        ,'�肤'    ,'�肤'  ,'�肤'  ,'�肤'  ,'���',   
		''    ,''    ,''    ,''    ,''        ,''        ,'�_��'  ,''      ,''      ,'',   
		''    ,''    ,''    ,''    ,'���򂷂�','���򂷂�','��V��','�^��'  ,''      ,'',   
		''    ,'�B��','����',''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,'�肤'  ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,'�P��','�P��','�P��','�P��'    ,'�P��'    ,'�P��'  ,'�P��'  ,'�P��'  ,'�P��',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'����',   
		'����','����',''    ,'����',''        ,''        ,'�P��'  ,'�U��'  ,'���˂�','',
   );

   # ����
   my $stat_kill   = '�E�Q���܂��B�������A�Ώۂ���q����Ă��邩�A���̗ւ�n����Ă��邩�A�d���ł���΁A���͔͂������܂���B�܂��A�Ώۂ����T�ł���ΐl�T�ɂȂ�܂��B�Ώۂ��l���̏ꍇ�������܂��񂪁A�ނ͂��ƈ���̖��ł��傤�B';
   my $stat_wolf   = '����A�l�T�S���ň�l�����A���l��'.$stat_kill.'<br>';
   my $stat_wisper = '�l�T�i�ƚ������l�j���m�ɂ����������Ȃ���b���\�ł��B<br>';
   my $stat_pixi   = '�l�T�ɎE����邱�Ƃ�����܂���B�������A�肢�̑ΏۂƂȂ�Ǝ��S���܂��B<br>�肢�t�A��\�҂ɂ͐l�ԂƂ��Ĕ��ʂ���܂����A���������ł͐l�Ԃɂ��l�T�ɂ��������܂���B<br>';
   my $stat_enemy  = '�l�Ԃł���Ȃ���A�l�O�ɋ��͂��闠�؂�҂ł��B�I�������ł͐l�Ԉ����ŏW�v����邽�߁A�ꍇ�ɂ���Ă͊����Ď��ʕK�v������܂��B';
   my $stat_fm     = '�����ȊO�̌��Ј��E���҂��N���m���Ă��܂��B';
   my $act_seer    = '����A�ЂƂ��肢�A���̐l��';
   my $act_medium  = '���S�Ȏ��̂ɂ��Ĕ��f���邱�Ƃ͏o���܂���B���Y��ˑR���Ŏ��񂾎҂�';
   my $stat_seer   = '�܂��A�d����肤�Ǝ�E���邱�Ƃ��o���܂��B�������A���l�A���T�����Ă��܂��ƁA��E����Ă��܂��܂��B';
   my $know_seer   = '�l�Ԃ��l�T�����ʂł��܂��B�������T�����͐l�T�ƌ�F���A���T�͐l�Ԃƌ�F���Ă��܂��܂��B';
   my $know_wisdom = '����E���킩��܂��B';
   my $stat_droop  = '���Ȃ��́A�������l�T�̐l���̓����ɁA���𗎂Ƃ��܂��B';
   my $stat_angel  = '�P���ځA�D���ȓ�l�Ɂg�^�����J�h�����т��鎖���ł��܂��B�g�^�����J�h�����񂾐l�́A�Е������S����ƌ��ǂ��Ď��S���܂��B';
   my $stat_other  = '���Ȃ��́A���������ł͐l�ԂƂ��Đ������܂��B';
   my @explain_gift = (
'',
'',
'<p>���Ȃ��͑��蕨��<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_LOST" TARGET="_blank">�r��</A>���܂����B<br>������x�Ǝ�ɂ��邱�Ƃ͂Ȃ��ł��傤�B�����܂����Ȃ��̎�ɑ��蕨�������Ă��A���������Ă��܂��܂��B�����āA���Ȃ�������ɋC�t�����Ƃ͂Ȃ��ł��傤�B</p>',
'',
'',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_SHIELD" TARGET="_blank">���̗�</A>����芪���܂��B<br>���Ȃ��͂������A�P������Ă����Ƃ��Ă�����܂����B<br>���̗ւ͂ЂƂ����x�������܂���B�����n�������̗ւ��ӂ����т��Ȃ��̎�ɓn������A���̗ւ͏��������Ă��܂��܂��B���Ɍ���Ɏ����ׂ��ǂ��F��I�т܂��傤�B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_FINK" TARGET="_blank">���[��</A>�ł��B<br>�\�����͑��̖�ڂ�ттĂ��܂����A���Ȃ��͐l�Ƃ����ʁA�l�T�Ƃ����ʁA���[�Ȑ��̂��B���Ă��܂��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_OGRE" TARGET="_blank">���S</A>�ł��B<br>�\�����͑��̖�ڂ�ттĂ��܂����A���Ȃ��͐l���P�������S�Ȃ̂ł��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_FAIRY" TARGET="_blank">�d�����琶�܂ꂽ�q</A>�ł��B<br>�\�����͑��̖�ڂ�ттĂ��܂����A���Ȃ��͐l�Ȃ�ʑ��݂Ȃ̂ł��B<br>�T�̏P����܋��҂̎�ɂ��E����邱�Ƃ͂���܂���B�������肢�̑ΏۂƂȂ�Ǝ��S���܂��B<br>�肢�t�A��\�҂ɂǂ����ʂ���邩�́A���Ƃ��Ƃ̖�E�ɂ��܂��B���������ł͐l�Ԃɂ��l�T�ɂ��������܂���B</p>',
'',

'',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_DECIDE" TARGET="_blank">�����</A>�ł��B<br>���Ȃ��͒ǉ��[�𓊂��錠���������Â��܂��B�s�g���邱�ƂŁA���݂��������Ƃ��ł���ł��傤�B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_SEERONCE" TARGET="_blank">����t</A>�ł��B<br>�肢�t�̗͂������܂����A���̔\�͂͂�������x�����g�����Ƃ��ł��܂���B<br>�ЂƂ��肢�A���̐l��'.$know_seer.'<br>'.$stat_seer.'</p>',
'',
'',
'',
'',
'',
'',
'',
   );

   my @explain_role = (
'<p>���Ȃ��͐��̕s���ł��B<br>����Ȕ\�͂����邩�ǂ������o���Ă��܂���B��͐ϋɓI�ɊO�o���āA�l�q��������܂��傤�B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">���l</A>�ł��B<br>����Ȕ\�͂͂����Ă��܂���B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_FM" TARGET="_blank">���Ј�</A>�ł��B<br>�Ǝ��̐l�������閧���Ђ̈���ł��B'.$stat_fm.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SEER" TARGET="_blank">�肢�t</A>�ł��B<br>'.$act_seer.$know_seer.'<br>'.$stat_seer.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_AURA" TARGET="_blank">�C�i�I�[���j�肢�t</A>�ł��B<br>'.$act_seer.'�\�͂��������ʏo���܂��B���Ȃ��ɂƂ��āA���l�A�l�T�A���T�͔\�͂̃I�[���������܂��񂪁A�����łȂ��l���͔\�͂̃I�[����Z���Ă���Ɗ������܂��B<br>'.$stat_seer.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_GUARD" TARGET="_blank">����</A>�ł��B<br>����A��l��T�̏P���A�������͕t���_���܋��҂̎肩���邱�Ƃ��o���܂��B<br>�������g����邱�Ƃ͏o���܂���B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_MEDIUMROLE" TARGET="_blank">���t</A>�ł��B<br>'.$act_medium.$know_wisdom.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_FOLLOW" TARGET="_blank">�Ǐ]��</A>�ł��B<br>���Ȃ��͓��[���ϔC���邱�Ƃ����ł��܂���B���ꂩ��M���A�ς˂܂��傤�B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_FAN" TARGET="_blank">������</A>�ł��B<br>���Ȃ���'.$stat_cycle.'�A�����́A���l�B���\�͓I�ɓ�̓��[�������Ȃ��A��l����x�ɏ��Y���܂��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_HUNTER" TARGET="_blank">�܋���</A>�ł��B<br>����A��l��t���_���܂��B<br>���Ȃ����A'.$stat_cycle.'�A���Ȃ��͕t���_���Ă����l���𓹘A��ɁA'.$stat_kill.'</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_WEREDOG" TARGET="_blank">�l��</A>�ł��B<br>���Ȃ��͘T�̏P�����󂯂�A�������͏܋��҂ɓ��A��ɂ����Ə��𕉂����̂́A��������������炦�܂��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_PRINCE" TARGET="_blank">���q�l</A>�ł��B<br>���Ȃ������Y����邱�ƂɌ��܂�ƈ�x�����́A���̏��Y�͂Ƃ��߂ɂȂ�܂��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">���l</A>�ł��B<br>����Ȕ\�͂͂����Ă��܂���B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_DYING" TARGET="_blank">�a����</A>�ł��B<br>'.$stat_droop.'</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_INVALID" TARGET="_blank">�a�l</A>�ł��B<br>���Ȃ������𗎂Ƃ����Ƃ��A�ЂƂ�̔Ɛl������ł���̂ł���΁A�Ɛl�͕a�C�Ɋ������A���������̔\�͂��s�g�ł��Ȃ��Ȃ�܂��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_WITCH" TARGET="_blank">����</A>�ł��B<br>���Ȃ��͓���ڈȍ~�A�����Ă���҂ɓ��򂵂ēŎE���邩�A���҂ɓ��򂵂đh�������܂��B�������A�ŎE�i���҂�I�ԁj�A�h���i���҂�I�ԁj�A�͂��ꂼ���x�����������Ȃ����Ƃ��ł��A����������͎����܂��B����g���ɂ͂��炩���ߏ�������̂ŁA���������򂷂��ɑΏۂ����S/�h�������Ȃ�A��͖��ʂɎg���Ă��܂��ł��傤�B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_GIRL" TARGET="_blank">����</A>�ł��B<br>���Ȃ��͓���ڈȍ~�A��ɏo�������Ƃ��ł��܂��B�l�T�̚����A���̔O�b�A���҂̋���N�̂��̂Ƃ����ʂ����������Ⴄ�̂ŁA���ɂȂ��č����U��Ԃ�Ǝv���o���邱�Ƃł��傤�B��▼�O�͂킩��܂��񂪁B<br>���������̂Ƃ��A�������Ȃ����l�T�́A�N���ЂƂ�ɂł��P������閵��Ɋ܂܂�Ă���ƁA���|�̂��܂�A���ۂɏP����]���҂Ƃ͕ʂɎ���ł��܂��܂��B���̎��S����q������@�͂���܂���B�܂��A����������邠�Ȃ���K�ڂɁA�T�B�͕ʂ̐l�����P������ł��傤�B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SCAPEGOAT" TARGET="_blank">�X�P�[�v�S�[�g</A>�ł��B<br>�������[���������ɂȂ菈�Y���鑊�肪��܂�Ȃ��ƁA�����������l�B�ɏ��Y����Ă��܂��܂��B���Ȃ����Ō�Ɏw�������l�́A������鑺�l�B�ɗ����A���Y�����ł��傤�B�F�A���������葼�ɂȂ��̂ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_POSSESS" TARGET="_blank">���l</A>�ł��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SEMIWOLF" TARGET="_blank">���T</A>�ł��B<br>���Ȃ��͘T�̏P�����󂯂�A�������͏܋��҂ɓ��A��ɂ����ƁA���Ȃ��͐l�T�ɂȂ�܂��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SORCERER" TARGET="_blank">���p�t</A>�ł��B<br>'.$act_seer.$know_wisdom.'<br>'.$stat_seer.'<br>'.$stat_enemy.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_WOLF" TARGET="_blank">�l�T</A>�ł��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_CHILDWOLF" TARGET="_blank">�e�T</A>�ł��B����Ȕ\�͂����l�T�ł��B<br>���Ȃ������𗎂Ƃ��������A�l�T�͓�̏P���������Ȃ��A��l����x�ɎE�Q���܂��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_PIXI" TARGET="_blank">�d��</A>�ł��B<br>'.$stat_pixi.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_LOVEANGEL" TARGET="_blank">�L���[�s�b�h</A>�ł��B<br>�L���[�s�b�h��'.$stat_angel.'<br>���т�����l���������т�΁A���Ȃ��̏����ƂȂ�܂��B���Ȃ��ɂ����J�����΂�Ă��Ȃ�����A���Ȃ����g�̎��͏��s�ɂ͒��ڊ֌W���܂���B<br>�܂��A'.$stat_other.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_ROBBER" TARGET="_blank">����</A>�ł��B<br>���Ȃ��́A�N���Ȃ�Ȃ������c���E�����ׂĒm��܂��B���̖�A���̒�����^���̓����܂܂ЂƂ̖�E��I�сA���ʂ̖�E�ɐ������ł��傤�B�^���́A���Ȃ��ɂȂɂ��ۂ��ł��傤���H</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_LONEWOLF" TARGET="_blank">��C�T</A>�ł��B<br>�l�T�ł����A���̐l�T�Ƃ͕ʌ�'.$stat_kill.'<br>�܂��A�P����͂��Ȃ��ȊO�ł���ΒN�ł����܂킸�A���Ȃ����g�́A�T�̏P����܋��҂̎�ɂ��E����邱�Ƃ͂���܂���B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_GURU" TARGET="_blank">���c</A>�ł��B<br>���c�͖��ӂӂ��肸�A�D���Ȑl�����Ђ����ɗU�����ނ��Ƃ��ł��܂��B�������g��U�����Ƃ͂ł��܂���B<br>�U�����܂ꂽ���l�����͐M�҂ƂȂ��Ė�Ȗ�ȏ@���V���ɒ^��A���̂��Ƃ��o���Ă��܂��B�������A�ނ�̔\�͂⏊���w�c�Ȃǂɕω��͂���܂���B<br>�܂��A'.$stat_other.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
   );

   # ��E��]
   my %explain = (
		prologue => '���Ȃ���_SELROLE_����]���Ă��܂��B�������A��]�����ʂ�̔\�͎҂ɂȂ��Ƃ͌���܂���B',
		dead     => '���Ȃ���_ROLE_�ł����A���𗎂Ƃ��܂����B',
		mob      => '���Ȃ���<b>_ROLE_��<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_MOB" TARGET="_blank">�����l</A></b>�ł��B�����Ȃ�w�c�̐l���ɂ��܂܂�܂���B',
		epilogue => '���Ȃ���<b>_ROLE_</b>�ł����i_SELROLE_����]�j�B',
		explain_role  => \@explain_role,
		explain_gift  => \@explain_gift,
   );

   # ���[���\��
   my @votelabels = (
		'���[',
		'�ϔC',
	);


	# �����҂̐F
	# �ܐl�����Ă��鏊�����Ă݂����i����
	my @stigma_subid = (
		'�Ԃ�',
		'��',
		'����',
		'�΂�',
		'����',
		'����',
		'���',
	);

	# �肢����
	my @result_seer = (
		'<b>_NAME_</b>_RESULT_',
		'��<b>�l��</b>�̂悤���B',
		'�́y<b>�l�T</b>�z�̂悤���B',
		'�́y<b>�\�͎҂ł͂Ȃ�</b>�z�悤���B�i���l�A�l�T�A���T�A�̂����ꂩ�j',
		'��<b>�\�͎�</b>�̂悤���B',
		'��<b>���N</b>�������B',
		'�́y<b>�������Ă���</b>�z�悤�Ȃ̂ŁA���Â����B',
		'��<b>_ROLE_</b>�̂悤���B',
		'�𒲂ׂ邱�Ƃ��ł��Ȃ������B',
	);

	# �z���\����
	my %caption_roletable = (
		custom   => '���R�ݒ�',
	);

	# �A�N�V����
	my @actions = (
		'�Ǝ��p����R&D�̐V�����ɁA�`�]���������B',
		'�Ƃɂ��Ɣ��΂݂������B',
		'�ɃX�p���ʂ����������B',
		'�ɉ���I�ȃ~�b�V�������Ă����B�����A���݂��Q�����悤�I',
		'�Ƀ��P�b�g�V���[�Y�������o�����B10�A9�A8�A�c�c',
		'�ɁuThiotimoline�v�Ə����ꂽ���˂𓊗^�����B',
		'�ɃA�X�x�X�g�A�[�}�[���ނ�Ői�悵���B',
		'�ɃS�V�S�V�{�b�g�������������B',
		'�ɂ�������ׁ[�������B',
		'�ɂނ��イ�����B',
		'�ɃN���N�V������炵���B',
		'�ɂ����V�������B',
		'�ɂЂǂ����낽�����B',
		'�ɋނ�Řd�G�������o�����B',
		'��s�M�̖ڂŌ����B',
		'���������B',
		'��閧�x�@(IntSec)�ɒʕ񂵂܂����B',
		'�������ƌ��߂��B',
		'���Ԃ߂�U��������B',
		'�������Y���ɂ����B',
		'��閧���Ђɏ��҂����B',
		'���u���u�I�v�ƌĂ�ł݂��B',
		'����̔ޕ��ɂԂ���΂����B',
		'���Z���~�b�N�n���Z���ŉ������B',
		'������(Ultra-Violet)�̃n���Z���ŉ������B',
		'�����E�I�{�����e�B�A�ɐ��E�����B',
		'��d�q�����W�Ŋ������Ă����������B',
		'���v���Y�}�L���m���̓I�ɂ��Ă݂��B',
		'���g���f�����_�ŕٌ삵���B',
		'��Ⓚ�ɂɕ��荞�񂾁B',
		'����Ã|�b�h�ɕ������B',
		'���瓦���o�����I�������A��荞�܂�Ă��܂����I',
		'�̑��������グ�āA���낶��`�����񂾁B',
		'�̑������w�������B�����ւ�A�n�ʂ�����܂����B',
		'�̓��𕏂ł��B',
		'�̍s�����A�ŐV�́u���t���ۂ��s�����X�g�v���猩���o�����B',
		'�̌C���ق���ЂƂȂ��قǂ��r�߉񂵂��B',
		'�̃`���R���[�g���ؗp�����B',
	);

	my %textrs = (
		CAPTION => '�A���e�B���b�g',
		HELP    => '�J�[�h�Q�[���u�A���e�B���b�g�l�T�v���̖�E���y���߂܂��B�������A�h���[�t�A�h�b�y���Q���K�[�A�A�����A�����ҁA�ϗ��w�҂ɂ͑Ή����Ă��܂���B',
		FORCE_DEFAULT => 'custom',

		# �_�~�[�L�����̎Q���\���i����������Ă��܂����j�̗L��
		NPCENTRYMES => 0,

		# ���J�A�i�E���X
		ANNOUNCE_EXTENSION  => '����ɒB���Ȃ��������߁A���̍X�V������24���ԉ�������܂����B',
		ENTRYMES            => '<b>_NAME_</b>���Q�����܂����B',
		EXITMES             => '<b>_NAME_</b>�������悤�ȋC���������A�C�̂����������悤���c�c(<b>_NAME_</b>�͑����o�܂���)',
		SUDDENDEATH         => '<b>_NAME_</b>�͓ˑR�������B',
		SUICIDEBONDS        => '<b>_NAME_</b>���J�Ɉ���������悤��<b>_TARGET_</b>�̌��ǂ����B',
		SUICIDELOVERS       => '<b>_NAME_</b>�͈����݂ɕ���<b>_TARGET_</b>�̌��ǂ����B',
		ANNOUNCE_RANDOMVOTE => '(�����_�����[)',
		ANNOUNCE_VICTORY    => '<b>_VICTORY_</b>�ł��I<br>',
		ANNOUNCE_EPILOGUE   => '<b>_AVICTORY_</b>�S�Ẵ��O�ƃ��[�U�[�������J���܂��B<b>_DATE_</b>�܂Ŏ��R�ɏ������߂܂��̂ŁA����̊��z�Ȃǂ��ǂ����B',

		RANDOMENTRUST => '(�����_���ϔC)',

		# �\�͊֘A
		UNDEFTARGET     => '�i�p�X�j',
		RANDOMTARGET    => '�����_��',
		RANDOMROLE      => '�����_��', # ��E�����_����]
		NOSELROLE       => '�S�Ă�<b>��E��]�𖳎�</b>���A�V����^����B',
		SETRANDOMROLE   => '�^����<b>_NAME_</b>�̖�E��]��_SELROLE_�Ɍ��߂��B',
		SETRANDOMTARGET => '<b>_NAME_</b>��<b>_ABILITY_</b>�̑Ώۂ�_�ɔC���A<b>_TARGET_</b>�Ɍ��܂����B',
		CANCELTARGET    => '<b>_NAME_</b>��<b>_ABILITY_</b>���Ƃ��߂��B',
		EXECUTEGOTO     => '<b>_NAME_</b>��<b>_TARGET_</b>�̏��֏o�|�����B',
		EXECUTEALONE    => '<b>_NAME_</b>��<b>��l</b>�ɂȂ����B',
		EXECUTESEER     => '<b>_NAME_</b>��<b>_TARGET_</b>�������B',
		EXECUTEKILL     => '<b>_TARGET_</b>�I ���������O�̖������I',
		EXECUTEALCHEMIST=> '<b>_NAME_</b>�͔������݉������B',
		EXECUTEKILLWITCH=> '<b>_NAME_</b>��<b>_TARGET_</b>���E�Q�����B',
		EXECUTELIVEWITCH=> '<b>_NAME_</b>��<b>_TARGET_</b>��h���������B',
		EXECUTEGUARD    => '<b>_NAME_</b>��<b>_TARGET_</b>������Ă���B',
		EXECUTEJAMM     => '<b>_NAME_</b>��<b>_TARGET_</b>���B���Ă���B',
		EXECUTETRICKSTER=> '<b>_NAME_</b>��<b>_TARGET1_</b>��<b>_TARGET2_</b>�̊Ԃɉ^�����J�����񂾁B',
		EXECUTELOVER    => '<b>_NAME_</b>��<b>_TARGET_</b>�Ƃ̊Ԃɉ^�����J�����񂾁B',
		EXECUTEGURU     => '<b>_NAME_</b>��<b>_TARGET_</b>��U�����񂾁B',
		EXECUTESNATCH   => '<b>_NAME_</b>��<b>_TARGET_</b>�̎p��D�����B', 
		EXECUTESCAPEGOAT=> '<b>_NAME_</b>��<b>_TARGET_</b>���Ō�Ɏw������', 
		EXECUTEFAN      => '<b>_NAME_</b>���₵����蕶��́A�������ٗl�ȕ��͋C�ɕ�񂾁B', 
		EXECUTECHILDWOLF=> '<b>_NAME_</b>�͂��ׂ����A���Ƃ��ꂽ�B', 
		EXECUTEGIRL     => '<b>_NAME_</b>���������肨�U�������悤���B',
		EXECUTEGIRLFEAR => '<b>_NAME_</b>�͋��낵�����̂����Ă��܂����I',
		EXECUTETHROW    => '<b>_NAME_</b>��<b>_TARGET_</b>��<b>_GIFT_</b>�������o�����B',
		EXECUTELOST     => '<b>_NAME_</b>�ɂ�<b>_GIFT_</b>�͓͂��Ȃ������c',
		EXECUTESHIELDBRK=> '<b>_NAME_</b>�Ɍ��̗ւ��n����A�l�m�ꂸ�j�󂵂��B',
		EXECUTEJUMP     => '<b>_DATE_����</b>�̖�A���̒��˂鐐�X�����������������B',
		RESULT_RIGHTWOLF=> '<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_RIGHTWOLF" TARGET="_blank">�l�T�̌���</A>�������悤���B<br>�i�T�����̂��Ȃ��́A�肢�t�A��\�҂ɐl�T�Ɣ��肳��܂��B�ł����A���Ȃ��͑��l�ŁA�����������ς��܂���B������ڎw���Ċ撣��܂��傤�B�j',
		RESULT_MEMBER   => '<b>_NAME_</b>����<b>_RESULT_</b>�̋C�z���������B',
		RESULT_FANATIC  => '<b>_NAME_</b>����<b>�l�T</b>�̋C�z���������B',
		RESULT_BAT      => '<b>_NAME_</b>����<b>�d��</b>�̋C�z���������B',
		RESULT_GUARD    => '<b>_DATE_����</b>�̖�A<b>_TARGET_</b>���P�����������B',
		RESULT_JAMM     => '<b>_DATE_����</b>�̖�A<b>_TARGET_</b>�̐��̂�肢�t����B�����B',
		RESULT_TRICKSTER=> '<b>_DATE_����</b>�̖�A<b>_TARGET1_</b>��<b>_TARGET2_</b>�̊Ԃɉ^�����J�����񂾁B',
		RESULT_ZOMBIE   => '<b>_DATE_����</b>�̖�A<b>_TARGET_</b>��<b>����</b>�������B',
		RESULT_KILL     => '<b>_DATE_����</b>�̖�A<b>_TARGET_</b>��<b>�E�Q</b>�����B',
		RESULT_LIVE     => '<b>_DATE_����</b>�̖�A<b>_TARGET_</b>��<b>�h��</b>�����B',
		RESULT_ALCHEMIST=> '<b>_DATE_����</b>�̖�A�������݉������B',
		RESULT_ELDER    => '<b>_DATE_����</b>�̖�A���𕉂����B', 
		RESULT_WEREDOG  => '<b>_DATE_����</b>�̖�A���𕉂����B���ƂP���̖����B', 
		RESULT_SEMIWOLF => '<b>_DATE_����</b>�̖�A�l�T�ɕϐg�����B',
		RESULT_LOVER    => '<b>_DATE_����</b>�̖�A<b>���Ȃ�</b>��<b>_TARGET_</b>�Ɖ^���𕪂��������܂����B',
		RESULT_LOVEE    => '<b>_DATE_����</b>�̖�A<b>_NAME_</b>��<b>���Ȃ�</b>�Ɖ^���𕪂��������܂����B',
		RESULT_ROBBER   => '���Ȃ��͓������B<br>_ROLE_�A����I�щ��ʂ�Z���B',
		RESULT_DYING    => '���Ȃ��́A�����l�T��<b>_NUMBER_��</b>�Ȃ獡�閽�𗎂Ƃ��B',
		RESULT_GURU     => '<b>_DATE_����</b>�̖�A_TARGET_��U�����񂾁B',
		RESULT_THROW    => '<b>_DATE_����</b>�̖�A<b>_TARGET_</b>��<b>_GIFT_</b>�������o�����B',
		RESULT_SCAPEGOAT=> '���Y��̑����ɂ�������炸<b>_TARGET_</b>�͑�������������B��������҂��߂͂��Ȃ������B',
		RESULT_ENCOUNT  => '<b>_DATE_����</b>�̖�A�s�R�Ȏp�����������B',

		STATE_SHEEPS    => ' �x�苶�������ڂ낰�ȋL��������B',
		STATE_BONDS     => '���Ȃ���<b>_TARGET_</b>�Ɖ^�����J������ł��܂��B',
		STATE_BIND      => '���Ȃ��͂�������\�͂��g�����Ƃ��ł��܂���B',
		STATE_BIND_ROLE => '���Ȃ��͂�����E�\�͂��g�����Ƃ��ł��܂���B',
		STATE_BIND_GIFT => '���Ȃ��͂������b�\�͂��g�����Ƃ��ł��܂���B',

		WIN_HUMAN       => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_HUMAN" TARGET="_blank">���l�w�c</A></b><br>�l��(�d����l�O�̎҂�����)�̐����l�T�ȉ��ɂȂ�܂łɐl�T�Ɨd�����S�ł���Ώ����ł��B<br>�������A�T��S�ł��������_�ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_WOLF        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_WOLF" TARGET="_blank">�l�T�w�c</A></b><br>���[���u�^�u���̐l�T�v�u���񂾂畉���v�uTrouble��Aliens�v�ł͐l��(�d����l�O�̎҂�����)�̐���l�T�Ɠ����ȉ��܂Ō��点�΁A���[���u�~���[�Y�z���E�v�u�[�����̖�v�ł͖�E�u���l�v��S�ł�����Ώ����ł��B<br>�������A�Ō�܂ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_LONEWOLF    => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_LONEWOLF" TARGET="_blank">��C�T�w�c</A></b><br>���[���u�^�u���̐l�T�v�u���񂾂畉���v�uTrouble��Aliens�v�ł͐l��(�d����l�O�̎҂�����)�̐�����C�T�Ɠ����ȉ��܂Ō��点�΁A���[���u�~���[�Y�z���E�v�u�[�����̖�v�ł͖�E�u���l�v��S�ł����A���A�l�T�w�c�̘T�������Ă��Ȃ���Ώ����ł��B<br>�������A�Ō�܂ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ�������~���������̒B�����݂��܂��B',
		WIN_PIXI        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_PIXI" TARGET="_blank">�d���w�c</A></b><br>�l�T���S�ł��邩�A�l��(�d����l�O�̎҂�����)�̐����l�T�Ɠ����ȉ��܂Ō���܂Łu�����c��΁v�����ł��B<br>�������A���l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_LOVER       => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_LOVER" TARGET="_blank">���l�w�c</A></b><br>���l�B�����������c��A�������͂��������̐w�c����������ɂ����Ƃ��A�J�̗��l�B���������Ă���Ώ����ł��B�������A�ЂƂ肾���h�������Ȃǂ̕s�K�ŁA���𐬏A�ł��Ȃ����l�́A�������܂���B',
		WIN_HATER       => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_HATER" TARGET="_blank">�׋C�w�c</A></b><br>���������̐w�c����������ɂ����Ƃ��A�^���Ɍ��������Ă���Ώ������܂��B�����Ƃ́A�J�̓V�G�����ׂē|���A��l�����������c���Ă��邱�Ƃł��B�E���������J��f���؂�܂��傤�B�J�̑��肪����ł��A���ǂ����Ƃ͂���܂���B<br>�J�̓V�G�Ƃ́A���Ƃ����Ȃ����g�ɂ͊֌W�̂Ȃ��Ƃ��A�������J������ł�����̑S�Ă��w���܂��B',
		WIN_DISH        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_DISH" TARGET="_blank">�����V</A></b><br>���ׂĂɌ����������Ƃ��A���Ȃ����T�̏P���A�������͏܋��҂̓��A��ɂ�莀�S���Ă���΁A�����҂̈���ɉ����܂��B',
		WIN_EVIL        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_EVIL" TARGET="_blank">���؂�̐w�c</A></b><br>���l�E���l���s�k����Ώ����҂̈���ɉ����܂��B<br>���Ȃ��͔j�ł�]��ł���̂ł��B�l�T��d���₻��ȊO�̏����A�܂��́A�N�����Ȃ��Ȃ邱�Ƃ�ڎw���܂��傤�B',
		WIN_GURU        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_GURU" TARGET="_blank">���c</A></b><br>���c�ȊO�̐����҂��M�҂����ɂȂ�Ώ����ƂȂ�܂��B���c���g�́A�ŏI�I�ɐ����c���Ă��Ȃ��Ƃ��\���܂���B<br>�������A�����珟����~���������̒B�����݂��܂��B',
		MARK_BONDS      => '�J',

		# �A�N�V�����֘A
		ACTIONS_ADDPT          => '�ɘb�̑����𑣂����B_REST_',
		ACTIONS_RESTADDPT      => '(�c_POINT_��)',
		ACTIONS_BOOKMARK       => '�����܂œǂ񂾁B',
		ACTIONS_CLEARANCE_UP   => '�̃Z�L�����e�B�E�N���A�����X�������グ���B',
		ACTIONS_CLEARANCE_DOWN => '�̃Z�L�����e�B�E�N���A�����X���������낵���B',
		ACTIONS_CLEARANCE_NG   => '�������A�F�߂��Ȃ������B',
		ACTIONS_ZAP            => '�ɕʂ���������B���̃N���[���͂����Ƃ��܂���邾�낤�B_COUNT_',
		ACTIONS_ZAPCOUNT       => '(_POINT_���)',

		# ���샍�O�֘A
		ANNOUNCE_SELROLE    => '<b>_NAME_</b>�� _SELROLE_ �ɂȂ��悤�A�V�ɋF�����B�i���̐l�ɂ͌����܂���j�B',
		ANNOUNCE_SETVOTE    => '<b>_NAME_</b>��<b>_TARGET_</b>�𓊕[��ɑI�т܂����B',
		ANNOUNCE_SETENTRUST => '���[���ϔC���܂��B<br><br><b>_NAME_</b>��<b>_TARGET_</b>�ɓ��[���ϔC���܂����B',
		ANNOUNCE_SETTARGET  => '<b>_NAME_</b>��<b>_TARGET_</b>��<b>_ABILITY_</b>�̑ΏۂɑI�т܂����B',

		# �{�^���̃��x��
		BUTTONLABEL_PC  => '_BUTTON_ / �X�V',
		BUTTONLABEL_MB  => '_BUTTON_',
		CAPTION_SAY_PC  => '����',
		CAPTION_SAY_MB  => '����',
		CAPTION_TSAY_PC => '�Ƃ茾',
		CAPTION_TSAY_MB => '�Ƃ茾',
		CAPTION_GSAY_PC => '�',
		CAPTION_GSAY_MB => '�',
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
