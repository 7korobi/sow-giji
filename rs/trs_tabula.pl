package SWTextRS_tabula;

sub GetTextRS {
	# �v�����[�O�`����ڂ̊J�n�����b�Z�[�W
	my @announce_first = (
		'���Ԃ͐l�Ԃ̂ӂ�����āA��ɐ��̂������Ƃ����l�T�B<br>���̐l�T���A���̑��ɕ��ꍞ��ł���Ƃ����\���L�������B<br><br>���l�B�͔��M���^�Ȃ�����A���͂���̏h�ɏW�߂��邱�ƂɂȂ����B',
		'�����A����̎p�����ɉf���Ă݂悤�B<br>�����ɉf��̂͂����̑��l���A����Ƃ����ɋQ�����l�T���B<br><br>�Ⴆ�l�T�ł��A���l���ŗ����������Ε|���͂Ȃ��B<br>���́A���ꂪ�l�T�Ȃ̂��Ƃ��������B<br>�肢�t�̔\�͂����l�ԂȂ�΁A��������j��邾�낤�B',
		'���ɋ]���҂��o���B�l�T�͂��̑��l�B�̂Ȃ��ɂ���B<br>�������A��������������i�͂Ȃ��B<br><br>���l�B�́A�^�킵���҂�r�����邽�߁A���[���s�����ɂ����B<br>�����̋]���҂��o��̂���ނ����Ȃ��B�����S�ł�����́c�c�B<br><br>�Ō�܂Ŏc��̂͑��l���A����Ƃ��l�T���B',
	);

	# ��E�z���̂��m�点
	my @announce_role = (
		'�ǂ���炱�̒��ɂ́A_ROLE_����悤���B',
		'��',
		'��',
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
		'<b>_NAME_</b>�͑��l�B�̎�ɂ�菈�Y���ꂽ�B',
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
		'���̓��̒��A���l�B�͏W�܂�A�݂��̎p���m�F�����B',
		'�����͋]���҂����Ȃ��悤���B�l�T�͏P���Ɏ��s�����̂��낤���B',
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
		'���̓��̒��A�Z�l�S�Ă����R�Ǝp���������B',
		'�S�Ă̐l�T��ގ������c�c�B�l�T�ɋ�������X�͋������̂��I',
		'�����l�T�ɒ�R�ł���قǑ��l�͎c���Ă��Ȃ��c�c�B<br>�l�T�͎c�������l��S�ĐH�炢�A�ʂ̊l�������߂Ă��̑��������Ă������B',
		'���l�B�͋C�t���Ă��܂����B�����^�������K�v�Ȃ�ĂȂ����ƂɁB<br>�l���T���֌W�Ȃ��A�d���̐������n�܂�c',
		'�S�Ă̐l�T��ގ������c�c�B<br>�����A�����ɕ������l�X�́A�d���Ƃ����^�̏����҂ɁA�Ō�܂ŋC�t�����Ƃ͂Ȃ������c�c',
		'���̎��A�l�T�͏������m�M���A�����ď��߂ĉ߂��ɋC�Â����B<br>�������A�V�G����d���𓢂��R�炵���l�T�ɂ́A�ő��Ȃ����ׂ��Ȃ������c�c',
		'���l�B�́A�����Đl�T�B������̉߂��ɋC�t�����B<br>�ǓƂȈ�C�T�͍Ō�̐H�����ς܂���ƁA�V���ȋ]���҂����߂Ė��l�̑��𗧂������Ă������B',
		'���l���A�l�T���A�d���ł������A���l�����̑O�ł͖��͂ł����B<br>�K���Ō�Ɉ��͏��̂ł��B',
		'',
		'���̓��̒��A�Z�l�̎p�͂ЂƂ��c���Ă��Ȃ������B',
	);

	# ������
	my @caption_winner = (
		'',
		'���l�̏���',
		'�l�T�̏���',
		'�d���̏���',
		'�d���̏���',
		'�d���̏���',
		'',
		'',
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
		WIN_GURU     => '�J����',
		WIN_EVIL     => '���؂�̐w�c',
	);

    # �C�x���g��
    my @eventname = (
        '', ''    , '', '', '', '', '', '', '', '',
        '', ''    , '', '', '', '', '', '', '', ''            ,
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
      '���܂���',      '�Ȃ�',    '�r��',  '����',  '','���̗�', '', '', '', '',
      ''        ,'���I�i���h','���肢�t',      '',  '',      '', '', '', '', '',
   );

   # �A�C�e�����i�ȗ����j
   my @giftshortname = (
      '',   '', '', '', '', '', '', '', '', '',
      '', '��', '', '', '', '', '', '', '', '',
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
      '���܂���', '���l'      ,'������'     ,   '���L��'  , '����'  , '�肢�t'  , '����t'  , '�C��t'  , '����'    , '��l'    ,
      '��\��'  , '�M��\��', '���t'      ,   '�~���'  , '�Ǐ]��'  , '������'  , '�܋���'  , '�l��'    , '���q�l'  , '�T����'  ,
      '���ؐl'  , '���l'      , '�a����'    ,   '�a�l'    , '�B���p�t', '����'    , '����'    , '����'    , '���V'    , '�u�a�_'  ,
      ''        , '�ז��V��'  , '�h�ؔV��'  ,   '�O�g�V��', ''        , ''        , ''        , ''        , '���󋶐l', '���ꋶ�l',
      ''        , '���l'      , '���M��'    ,   '�l�`�g��', '�������l', '���T'    , ''        , '���_��'  , '���p�t'  , ''        ,
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',			'�l�T',		'���T',		'�q�T',		'���T',		'���T',		'�e�T',		'���T',		'�٘T',		'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',			'�n���X�^�[�l��',		'���c',		'�啗d��',	'���Y�d��',	'�ז��V��',	'�[�T�d��',	'�h�ؔV��',	'���ԗd��',	'',
		'',			'����',		'�A����',	'�_�b�}�j�A',	'�����l',	'��C�T',	'',	'',	'',
	);

	# ��E���i�ȗ����j
	my @roleshortname = (
		'',	'��',	'��',	'��',	'��',	'��',	'',		'',		'',		'��',
		'��',	'',	'',		'',		'',		'',		'',		'',		'',		'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',	'��',	'�M',	'',		'��',	'',		'',		'',		'',		'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',	'�T',	'',		'',		'',		'',		'',		'',		'',		'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',	'��',	'',		'',		'',		'',		'',		'',		'',		'',
		'',	'',		'',		'�_',		'',	'',		'',		'',		'',		'',
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
      '����','����',''    ,'����',''        ,'�P��'    ,''      ,'�U��'  ,'���˂�','',
   );

   # ����
   my $stat_kill   = '�E�Q���܂��B�������A�Ώۂ���q����Ă��邩�A�d���ł���΁A���͔͂������܂���B';
   my $stat_wolf   = '����A�l�T�S���ň�l�����A���l��'.$stat_kill.'<br>';
   my $stat_wisper = '�l�T�i�ƚ������l�j���m�ɂ����������Ȃ���b���\�ł��B<br>';
   my $stat_pixi   = '�l�T�ɎE����邱�Ƃ�����܂���B�������A�肢�̑ΏۂƂȂ�Ǝ��S���܂��B<br>�肢�t�A��\�҂ɂ͐l�ԂƂ��Ĕ��ʂ���܂����A���������ł͐l�Ԃɂ��l�T�ɂ��������܂���B<br>';
   my $stat_enemy  = '�l�Ԃł���Ȃ���A�l�O�ɋ��͂��闠�؂�҂ł��B���������ł͐l�Ԉ����ŏW�v����邽�߁A�ꍇ�ɂ���Ă͊����Ď��ʕK�v������܂��B';
   my $stat_fm     = '�����ȊO�̋��L�ҁE���҂��N���m���Ă��܂��B';
   my $act_seer    = '����A�ЂƂ��肢�A���̐l��';
   my $act_medium  = '���S�Ȏ��̂ɂ��Ĕ��f���邱�Ƃ͏o���܂���B���Y��ˑR���Ŏ��񂾎҂�';
   my $stat_seer   = '�܂��A�d����肤�Ǝ�E���邱�Ƃ��o���܂��B';
   my $know_seer   = '�l�Ԃ��l�T�����ʂł��܂��B';
   my $know_wisdom = '����E���킩��܂��B';
   my $stat_droop  = '���Ȃ��́A�������l�T�̐l���̓����ɁA���𗎂Ƃ��܂��B';

   my @explain_gift = (
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
'<p>���Ȃ��ɂ�<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Gift)GIFTID_DECIDE" TARGET="_blank">���I�i���h</A>�����Ă܂��B<br>���Ȃ��͒ǉ��[�𓊂��錠���������Â��܂��B�s�g���邱�ƂŁA���݂��������Ƃ��ł���ł��傤�B</p>',
'',
'',
'',
'',
'',
'',
'',
'',
   );

   my @explain_role = (
'<p>���Ȃ��͑��l�ł��B<br>����Ȕ\�͂����邩�ǂ������o���Ă��܂���B��͐ϋɓI�ɊO�o���āA�l�q��������܂��傤�B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">���l</A>�ł��B<br>����Ȕ\�͂͂����Ă��܂���B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_STIGMA" TARGET="_blank">_ROLESUBID_������</A>�ł��B<br>�Ɠ��̈�������߁A���Ȃ��̐��͔̂�r�I�M�p����₷���ł��傤�B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_FM" TARGET="_blank">���L��</A>�ł��B<br>���Ȃ���'.$stat_fm.'</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SYMPATHY" TARGET="_blank">����</A>�ł��B<br>���Ȃ���'.$stat_fm.'<br>�܂��A���ғ��m�ɂ����������Ȃ���b���\�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_SEER" TARGET="_blank">�肢�t</A>�ł��B<br>'.$act_seer.$know_seer.'<br>'.$stat_seer.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_GUARD" TARGET="_blank">��l</A>�ł��B<br>����A��l��T�̏P���A�������͕t���_���܋��҂̎肩���邱�Ƃ��o���܂��B<br>�������g����邱�Ƃ͏o���܂���B</p>',

'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_MEDIUM" TARGET="_blank">��\��</A>�ł��B<br>'.$act_medium.$know_seer.'</p>',
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
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_POSSESS" TARGET="_blank">���l</A>�ł��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_FANATIC" TARGET="_blank">���M��</A>�ł��B<br>�l�T�ɂ͂��Ȃ��̐��̂͂킩��܂��񂪁A���Ȃ��͐l�T���N���m���Ă��܂��B�܂��A�V���ɐl�T�ƂȂ������̂�m�邱�Ƃ��ł��܂��B<br>�ł����A���Ȃ��͘T������[�T�d�����l�T�ł���ƌ�F���Ă��܂��܂����A��C�T�̐��̂�m�邱�Ƃ͂ł��܂���B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_WISPER" TARGET="_blank">�������l</A>�ł��B<br>'.$stat_wisper.$stat_enemy.'���l���ɂȂ�Ə��s���m�肷��󋵂�����܂��A�ł������̏ꍇ�������ŏI�����邱�Ƃ͂���܂���B</p>',
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
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_WOLF" TARGET="_blank">�l�T</A>�ł��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
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
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_PIXI" TARGET="_blank">�n���X�^�[�l��</A>�ł��B<br>'.$stat_pixi.'</p>',
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
'<p>���Ȃ���<A href="http://crazy-crazy.sakura.ne.jp/giji/?(Role)ROLEID_LOVER" TARGET="_blank">�_�b�}�j�A</A>�ł��B<br>����ځA�D���Ȑl�����t���Ƃ��đI�сA�g�^�����J�h�����т��A��q���肵�܂��B���̒��A���Ȃ��͓��p������킵�A�J�̎t���Ɠ�����E�ɂȂ��Ă��܂��B<br>�g�^�����J�h�����񂾓�l�́A�Е������S����ƌ��ǂ��Ď��S���܂��B</p>',
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
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
   );

	# ��E��]
   my %explain = (
		prologue => '���Ȃ��� _SELROLE_ ����]���Ă��܂��B�������A��]�����ʂ�̔\�͎҂ɂȂ��Ƃ͌���܂���B',
		dead     => '���Ȃ��͎��S���Ă��܂��B',
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
	# �ӂ��̃��[�����x�肪���킢�����Ȃ̂ŁA�肢���ʂɓ��t�͓Y���Ȃ��B
	my @result_seer = (
		'<b>_NAME_</b>_RESULT_',
		'�� �l�� �̂悤���B',
		'�� �y�l�T�z�̂悤���B',
		'�� �y�\�͎҂ł͂Ȃ��z�悤���B�i���l�A�l�T�A���T�A�̂����ꂩ�j',
		'�� �\�͎� �̂悤���B',
		'�� ���N�������B',
		'�� �y�����Ă���z �悤�Ȃ̂ŁA���Â����B',
		'�� _ROLE_ �̂悤���B',
		'�𒲂ׂ邱�Ƃ��ł��Ȃ������B',
	);

	# �z���\����
	my %caption_roletable = (
		default  => '�W��',
		wbbs_c   => '�l�TBBS C��',
		wbbs_f   => '�l�TBBS F��',
		test1st  => '�l�T�R�� ������^',
		test2nd  => '�l�T�R�� ������^',
		custom   => '���R�ݒ�',
	);

	# �A�N�V����
	my @actions = (
		'�Ƀ^���C�𗎂Ƃ����B',
		'���n���Z���ŉ������B',
		'�ɑ��Â���ł����B',
		'���Ԃ߂��B',
		'���������B',
		'�Ɏ���X�����B',
		'�������ƌ��߂��B',
		'��M���̖ڂŌ����B',
		'�����b�����Ɍ����B',
		'��s�M�̖ڂŌ����B',
		'���w�������B',
		'���������B',
		'�ɋ������B',
		'�ɍ��f�����B',
		'�ɂ��낽�����B',
		'�ɋ������B',
		'�ɏƂꂽ�B',
		'�ɂ����V�������B',
		'�Ɏ��U�����B',
		'�ɔ��΂񂾁B',
		'�ɔ��肵���B',
		'���x�������B',
		'�ɕʂ���������B',
		'��������߂��B',
		'�����ꎞ�Ԗ₢�߂��B',
		'�ւ̑O����P�񂵂��B',
		'�Ɋ��ӂ����B',
	);

	my %textrs = (
		CAPTION => '�^�u���̐l�T',
		HELP    => '�J�[�h�Q�[���uLupus in Tabula�v���̖�E���y���߂܂��B�������A�u�a�_�A���ؐl�A��������A�ɂ͑Ή����Ă��܂���B',
		FORCE_DEFAULT => 'custom',

		# �_�~�[�L�����̎Q���\���i����������Ă��܂����j�̗L��
		NPCENTRYMES => 1,

		# ���J�A�i�E���X
		ANNOUNCE_EXTENSION  => '����ɒB���Ȃ��������߁A���̍X�V������24���ԉ�������܂����B',
		ENTRYMES            => '_NO_�l�ځA<b>_NAME_</b>������Ă��܂����B',
		EXITMES             => '<b>_NAME_</b>�������o�čs���܂����B',
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
		NOSELROLE       => '���̐ݒ肪<b>��E��]����</b>�̂��߁A�S�Ă̖�E��]����������܂��B',
		SETRANDOMROLE   => '<b>_NAME_</b>�̖�E��]��_SELROLE_�Ɏ������肳��܂����B',
		SETRANDOMTARGET => '<b>_NAME_</b>�̔\�́i_ABILITY_�j�̑Ώۂ�_TARGET_�Ɏ������肳��܂����B',
		CANCELTARGET    => '<b>_NAME_</b>�̔\�́i_ABILITY_�j�ɗL���ȑΏۂ�����܂���ł����B',
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

		STATE_SHEEPS    => '�x�苶�������ڂ낰�ȋL��������B',
		STATE_BONDS     => '���Ȃ���<b>_TARGET_</b>�Ɖ^�����J������ł��܂��B',
		STATE_BIND      => '���Ȃ��͂�������\�͂��g�����Ƃ��ł��܂���B',
		STATE_BIND_ROLE => '���Ȃ��͂�����E�\�͂��g�����Ƃ��ł��܂���B',
		STATE_BIND_GIFT => '���Ȃ��͂������b�\�͂��g�����Ƃ��ł��܂���B',

		WIN_HUMAN       => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_HUMAN" TARGET="_blank">���l�w�c</A></b><br>�l��(�d����l�O�̎҂�����)�̐����l�T�ȉ��ɂȂ�܂łɐl�T�Ɨd�����S�ł���Ώ����ł��B<br>�������A�T��S�ł��������_�ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_WOLF        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_WOLF" TARGET="_blank">�l�T�w�c</A></b><br>���[���u�^�u���̐l�T�v�u���񂾂畉���v�uTrouble��Aliens�v�ł͐l��(�d����l�O�̎҂�����)�̐���l�T�Ɠ����ȉ��܂Ō��点�΁A���[���u�~���[�Y�z���E�v�u�[�����̖�v�ł͖�E�u���l�v��S�ł�����Ώ����ł��B<br>�������A�Ō�܂ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_PIXI        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_PIXI" TARGET="_blank">�d���w�c</A></b><br>�l�T���S�ł��邩�A�l��(�d����l�O�̎҂�����)�̐����l�T�Ɠ����ȉ��܂Ō���܂Łu�����c��΁v�����ł��B<br>�������A���l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_EVIL        => '<b><A href="http://crazy-crazy.sakura.ne.jp/giji/?(Text)WIN_EVIL" TARGET="_blank">���؂�̐w�c</A></b><br>���l�E���l���s�k����Ώ����҂̈���ɉ����܂��B<br>���Ȃ��͔j�ł�]��ł���̂ł��B�l�T��d���₻��ȊO�̏����A�܂��́A�N�����Ȃ��Ȃ邱�Ƃ�ڎw���܂��傤�B',
		MARK_BONDS      => '�J',

		# �A�N�V�����֘A
		ACTIONS_ADDPT     => '�ɘb�̑����𑣂����B_REST_',
		ACTIONS_RESTADDPT => '(�c_POINT_��)',
		ACTIONS_BOOKMARK  => '�����܂œǂ񂾁B',

		# ���샍�O�֘A
		ANNOUNCE_SELROLE    => '<b>_NAME_</b>�� _SELROLE_ ����]���܂����i���̐l�ɂ͌����܂���j�B',
		ANNOUNCE_SETVOTE    => '<b>_NAME_</b>��<b>_TARGET_</b>�𓊕[��ɑI�т܂����B',
		ANNOUNCE_SETENTRUST => '���[���ϔC���܂��B<br><br><b>_NAME_</b>��<b>_TARGET_</b>�ɓ��[���ϔC���܂����B',
		ANNOUNCE_SETTARGET  => '<b>_NAME_</b>��<b>_TARGET_</b>��<b>_ABILITY_</b>�̑ΏۂɑI�т܂����B',

		# �{�^���̃��x��
		BUTTONLABEL_PC  => '_BUTTON_',
		BUTTONLABEL_MB  => '_BUTTON_',
		CAPTION_SAY_PC  => '����',
		CAPTION_SAY_MB  => '����',
		CAPTION_TSAY_PC => '�Ƃ茾',
		CAPTION_TSAY_MB => '�Ƃ茾',
		CAPTION_GSAY_PC => '���҂̂��߂�',
		CAPTION_GSAY_MB => '���߂�',
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