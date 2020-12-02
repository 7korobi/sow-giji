package SWTextRS_millerhollow;

sub GetTextRS {
	# �v�����[�O�`����ڂ̊J�n�����b�Z�[�W
	my @announce_first = (
		'���Ԃ͐l�Ԃ̂ӂ�����āA��ɐ��̂������Ƃ����l�T�B<br>���̐l�T���A���̑��ɕ��ꍞ��ł���Ƃ����\���L�������B<br><br>���l�B�͔��M���^�Ȃ�����A���͂���̏h�ɏW�߂��邱�ƂɂȂ����B',
		'�����A����̎p�����ɉf���Ă݂悤�B<br>�����ɉf��̂͂����̑��l���A����Ƃ����ɋQ�����l�T���B<br><br>�Ⴆ�l�T�ł��A���l���ŗ����������Ε|���͂Ȃ��B<br>���́A���ꂪ�l�T�Ȃ̂��Ƃ��������B<br>�\���҂̔\�͂����l�ԂȂ�΁A��������j��邾�낤�B',
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
		'<b>_NAME_</b> �͏P�����ꂽ�B',
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
		'���l�B�͋C�t���Ă��܂����B�����^�������K�v�Ȃ�ĂȂ����ƂɁB<br>�l���T���֌W�Ȃ��A���̂悤�Ȑ������n�܂�c',
		'�S�Ă̐l�T��ގ������c�c�B<br>�����A�����ɕ������l�X�́A�d���Ƃ����^�̏����҂ɁA�Ō�܂ŋC�t�����Ƃ͂Ȃ������c�c',
		'���̎��A�l�T�͏������m�M���A�����ď��߂ĉ߂��ɋC�Â����B<br>�������A�V�G����d���𓢂��R�炵���l�T�ɂ́A�ő��Ȃ����ׂ��Ȃ������c�c',
		'',
		'���l���A�l�T���A�d���ł������A���l�����̑O�ł͖��͂ł����B<br>�K���Ō�Ɉ��͏��̂ł��B',
		'',
		'���̓��̒��A�Z�l�̎p�͂ЂƂ��c���Ă��Ȃ������B',
	);

	# ������
	my @caption_winner = (
		'',
		'���l�̏���',
		'�l�T�̏���',
		'�J��������',
		'',
		'',
		'',
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
		WIN_GURU     => '�J����',
		WIN_EVIL     => '���؂�̐w�c',
	);

    # �C�x���g��
    my @eventname = (
        '', '���ʂ̓�', '�l���n��', '��d�X�p�C', ''    , '���I', 'Sir Cointoss', '�e����', '���', '���҂̂�����',
        '', '�s��'    , '�M��'    , '����'      , '�S��', '���S�i�������j', '�~���'      , ''      , ''    , ''            ,
    );

   my @explain_event = (
'����`�̃C�x���g�ł��B',
'�����́A���ʂȂ��Ƃ̂Ȃ�����̂悤���B�������i�ʂ�A�N�������Y��ɂ����悤�B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_APRIL_FOOL" TARGET="_blank">�l���n��</A></b><br>��ρA��ρA��ςȂ��ƂɂȂ����B���݂̖�E�͕ω����Ă��邩������Ȃ��B�������N�����J������ł���Ȃ�A�}�ɑ��肪�����Ȃ��Ă��܂��A�J�̑��肾���ɂ������[�ł��Ȃ��B�����Č���Ă��܂����B���邾���́A�����̌��ǂ����Ƃ͂Ȃ��Ɓc�c�B<br><table><tr><th colspan=3>��E�̕ϖe<th rowspan=4>������Ō��ɖ߂�<tr><td>�a����<td>����<td>����<tr><td>����<td>����<td>���V<tr><td>��l<td>����<td>����</table>',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_TURN_FINK" TARGET="_blank">��d�X�p�C</A></b><br>�Ȃ�Ƃ������Ƃ��낤�I��l�������𗠐؂�A�T�ɗ^���锼�[�҂ɂȂ��Ă��܂����B�����ȍ~���A�ނ͑��l�𗠐؂葱���邾�낤�c�c�B<br>�ۈ�������̗ւ̎�����Ȃ�A���̂Ƃ��ɂ��̗͂�������Ă��܂��B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_TURN_FAIRY" TARGET="_blank">�d���̗�</A></b><br>�Ȃ�Ƃ������Ƃ��낤�I��l���X�ɗ�������A�d���̗{�q�ɂȂ��Ă��܂����B�����ȍ~���A�ނ͑��l�𗠐؂葱���邾�낤�c�c�B<br>�ۈ�������̗ւ̎�����Ȃ�A���̂Ƃ��ɂ��̗͂�������Ă��܂��B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_ECLIPSE" TARGET="_blank">���I</A></b><br>�Â����I�������𕢂��A���݂�������O������Ȃ��B���̈Ŗ�͊ۈ���������낤�B���l�ɂȂ肷�܂��A�c�_�����������邱�Ƃ��ł��Ă��܂���������Ȃ��B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_COINTOSS" TARGET="_blank">Sir Cointoss</A></b><br>���T���Ȃ����B���T���Ȃ����B�R�C���g�X���͂��̑��̓��[���ʂɈӌ�������悤�ł������܂��B���̌�ӌ��ɂ���ẮA���[���ʂɊ�Â������Y�����~�߂ɂ��邱�Ƃ�����܂��B�ܕ��ܕ����炢���ȁB',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_FORCE" TARGET="_blank">�e����</A></b><br>�����̓��[���͖��F�������B���ꂩ�����[�����u�Ԃɂ��̓��e�̓n�b�L���ƌ����邩��A���[���Z�b�g����Ƃ��͋C��t���āI',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_MIRACLE" TARGET="_blank">���</A></b><br>�A���Ă����I����̍�����P���ɂ��]���ҒB���������Ă����I�\�͂���������������Ȃ�����ǁA����͍��ׂȂ��Ƃ���I�ˁI<br>�l�T�A��C�T�A�܋��҂��ȂǂɏP��ꂽ���҂͐����Ԃ�B�������A�����҂����l�w�c�Ȃ�A���̔\�͎͂�����B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_PROPHECY" TARGET="_blank">���҂̂�����</A></b><br>���҂͖��̖����ɍ������܂����B���̔C���A<b>�ۈ���</A></b>�ɂӂ��킵���l��������ƁB�����C���͉�����A�����炵��<b>�ۈ���</A></b>�͊F�Ɋ��тŌ}��������邾�낤�B',

'����`�̃C�x���g�ł��B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_CLAMOR" TARGET="_blank">�s��</A></b><br>���ɂ͕s�����T�����Ă���B����̓��[�ł܂��l�Ԃ����Y���Ă��܂�����c�c�������n�܂�B�͂������s���ɔw����������A�b���������Ȃ��ɁA����Ɉ�l�̎��K�v�Ƃ��邾�낤�B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_FIRE" TARGET="_blank">�M��</A></b><br>���ɂ͊��҂ɖ������M�ӂ��Q�����Ă���B����̓��[���ЂƂȂ�ʂ��̂����Y�ł����Ȃ�c�c�������n�܂�̂��B�͂������M�ӂɔw����������A�b���������Ȃ��ɁA����Ɉ�l�̎��K�v�Ƃ��邾�낤�B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_NIGHTMARE" TARGET="_blank">����</A></b><br>���낵��������n�܂�B�����͓��[�������ł���B�������A�\�͂��g���Ȃ��B�����āA�ˑR���͔������Ȃ��B<br>�������[���āA����ȓ��������߂������Ă��܂��悤�A�ЂƂ�F�������悤�B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_GHOST" TARGET="_blank">�S��</A></b><br>����A�l�T�ɎE���ꂽ�l�͐l�T�ɂȂ�B�܂��A�P�������s�����l�T�͖��𗎂Ƃ��Ă��܂����낤�B�l�T�ƂȂ����҂͕񕜍s�����s��Ȃ��B�������A���E���������Ȃ�ΐl�T�ɂ͂Ȃ�Ȃ��B<br>��C�T�͖S������Ȃ��B',
'<b>���S</b><br>���߂Ĉ�l�����ł��A�Ȃ�Ƃ����ē��������B����̓��[�œ��S�҂���l���߁A�钆�̏��Y�̂����ɖ����ɓ������̂��B<br>���������S�҂͈���̂��������S�����𑱂��A���ɑ��ւƋA�҂��Ă��܂��B�A�Ҏ҂̕[�͒ʏ�̎O�{���d����邾�낤�B�������߂�ǂ�������A���̂܂ܖ���`�ɂ��Ă��������ȁB',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_SEANSE" TARGET="_blank">�~���</A></b><br>�������肳��A�������肳��c�c<br>�閧�̋V���ŁA���̗썰���������Ă����B�����Ɍ���A���҂��p�̌����ʎ��҂����������ɂ��A�c�_���邾�낤�B',

'����`�̃C�x���g�ł��B',
'����`�̃C�x���g�ł��B',
'����`�̃C�x���g�ł��B',
);

   # �A�C�e����
   my @giftname = (
      '���܂���',  '�Ȃ�',    '�r��',  '����',  '','���̗�', '���[��', '���S', '�d���̎q', '',
      ''        ,'�ۈ���','���肢�t',      '',  '',      '',       '',     '',         '', '',
   );

   # �A�C�e�����i�ȗ����j
   my @giftshortname = (
      '',   '',   '', '', '', '', '', '�S', '', '',
      '', '��',   '', '', '', '', '',   '', '', '',
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
		'���܂���',	'���l',			'',			'',		'',		'',		'',		'',					'�a����',	'����',
		'',			'',				'',			'',		'',		'',		'��l',	'',					'',			'',
		'',			'',				'',			'',		'',		'����',	'����',	'�X�P�[�v�S�[�g',	'���V',		'',
		'',			'',				'',			'',		'',		'',		'',		'',					'',			'',
		'',			'',				'',			'',		'',		'',		'',		'',					'',			'',
		'',			'',				'',			'',		'',		'',		'',		'',					'',			'',
		'',			'�l�T',			'',			'�l�T',	'',		'',		'',		'',					'',			'',
		'',			'',				'',			'',		'',		'',		'',		'',					'',			'',
		'',			'',				'',			'',		'',		'',		'',		'',					'',			'',
		'',			'�L���[�s�b�h',	'',			'',		'����',	'',		'',		'�J����',			'',			'',
	);

	# ��E���i�ȗ����j
	my @roleshortname = (
		'',	'��',	'',		'',		'',		'',		'',		'',		'�a',	'��',
		'',	'',		'',		'',		'',		'',		'�� ',	'',		'',		'',
		'',	'',		'',		'',		'',		'��',	'��',	'��',	'�V',	'',	
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',	'',		'',		'�T',	'',		'',		'',		'',		'',		'',	
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',
		'',	'',		'',		'',		'',		'',		'',		'',		'',		'',	
		'',	'�p',	'',		'',		'����',	'',		'',		'�J',	'',		'',	
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
      ''    ,''    ,''    ,''    ,''        ,'�肤'    ,'�肤'  ,'�肤'  ,'�肤'  ,'���',   
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
   my $stat_kill   = '�E�Q���܂��B�������A�Ώۂ���q����Ă��邩�A�d���ł���΁A���͔͂������܂���B�܂��A�Ώۂ������̒��V�̏ꍇ�́A�����͂��܂��񂪏��𕉂킹�邱�Ƃ��ł��܂��B';
   my $stat_wolf   = '����A�l�T�S���ň�l�����A���l��'.$stat_kill.'<br>';
   my $stat_wisper = '�l�T���m�ɂ����������Ȃ���b���\�ł��B<br>';
   my $stat_pixi   = '�l�T�ɎE����邱�Ƃ�����܂���B�������A�肢�̑ΏۂƂȂ�Ǝ��S���܂��B<br>�肢�t�A��\�҂ɂ͐l�ԂƂ��Ĕ��ʂ���܂����A���������ł͐l�Ԃɂ��l�T�ɂ��������܂���B<br>';
   my $stat_enemy  = '�l�Ԃł���Ȃ���A�l�O�ɋ��͂��闠�؂�҂ł��B���������ł͐l�Ԉ����ŏW�v����邽�߁A�ꍇ�ɂ���Ă͊����Ď��ʕK�v������܂��B';
   my $stat_fm     = '�����ȊO�̌��Ј��E���҂��N���m���Ă��܂��B';
   my $act_seer    = '����A�ЂƂ��肢�A���̐l��';
   my $act_medium  = '���S�Ȏ��̂ɂ��Ĕ��f���邱�Ƃ͏o���܂���B���Y��ˑR���Ŏ��񂾎҂�';
   my $stat_seer   = '�܂��A�d����肤�Ǝ�E���邱�Ƃ��o���܂��B';
   my $know_seer   = '�l�Ԃ��l�T�����ʂł��܂��B';
   my $know_wisdom = '����E���킩��܂��B';
   my $stat_droop  = '���Ȃ��́A�������l�T�̐l���̓����ɁA���𗎂Ƃ��܂��B';
   my $stat_angel  = '����ځA�D���ȓ�l�Ɂg�^�����J�h�����т��鎖���ł��܂��B�g�^�����J�h�����񂾐l�́A�Е������S����ƌ��ǂ��Ď��S���܂��B';
   my $stat_other  = '���Ȃ��́A���������ł͐l�ԂƂ��Đ������܂��B';
	
   my @explain_gift = (
'',
'',
'<p>���Ȃ��͌��̗ւ�<A h//dais.kokage.cc/guide/e.jp/giji/?(Gift)GIFTID_LOST" TARGET="_blank">�r��</A>���܂����B<br>������x�Ǝ�ɂ��邱�Ƃ͂Ȃ��ł��傤�B�������̗ւ����Ȃ��̎�ɓn������A���̗ւ͏��������Ă��܂��܂��B�����āA���Ȃ�������ɋC�t�����Ƃ͂Ȃ��ł��傤�B</p>',
'<p>���b�͖���`�ł��B</p>',
'<p>���b�͖���`�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_SHIELD" TARGET="_blank">���̗�</A>����芪���܂��B<br>���Ȃ��͂������A�P������Ă����Ƃ��Ă�����܂����B<br>���̗ւ͂ЂƂ����x�������܂���B�����n�������̗ւ��ӂ����т��Ȃ��̎�ɓn������A���̗ւ͏��������Ă��܂��܂��B���Ɍ���Ɏ����ׂ��ǂ��F��I�т܂��傤�B<br>�������A���̗ւ�n�����悪�l�O�̎҂ł���΁A�ނ͌����󂵂Ă��܂��܂��B</p>',
'<p>���b�͖���`�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_OGRE" TARGET="_blank">���S</A>�ł��B<br>�\�����͑��̖�ڂ�ттĂ��܂����A���Ȃ��͐l���P�������S�Ȃ̂ł��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p>���b�͖���`�ł��B</p>',
'<p>���b�͖���`�ł��B</p>',
'<p>���b�͖���`�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_DECIDE" TARGET="_blank">�ۈ���</A>�ł��B<br>���Ȃ��͒ǉ��[�𓊂��錠���������Â��܂��B�s�g���邱�ƂŁA���݂��������Ƃ��ł���ł��傤�B<br>�������̗ւ����Ȃ��̎�ɓn������A�ǉ��[�𓊂��錠���͑~�������Ă��܂��܂��B</p>',
   );

   my @explain_role = (
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">���l</A>�ł��B<br>����Ȕ\�͂͂����Ă��܂���B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SEERROLE" TARGET="_blank">�a����</A>�ł��B<br>'.$act_seer.$know_wisdom.'<br>'.$stat_seer.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_GUARD" TARGET="_blank">����</A>�ł��B<br>����A��l��T�̏P���A�������͕t���_����l�̎肩���邱�Ƃ��o���܂��B<br>�������g����邱�Ƃ͏o���܂���B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_HUNTER" TARGET="_blank">��l</A>�ł��B<br>����A��l��t���_���܂��B<br>���Ȃ����ǂ�ȗ��R�ł��ꖽ�𗎂Ƃ��ƁA���Ȃ��͕t���_���Ă����l���𓹘A��ɁA'.$stat_kill.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WITCH" TARGET="_blank">����</A>�ł��B<br>���Ȃ��͓���ڈȍ~�A�����Ă���҂ɓ��򂵂ēŎE���邩�A���҂ɓ��򂵂đh�������܂��B�������A�ŎE�i���҂�I�ԁj�A�h���i���҂�I�ԁj�A�͂��ꂼ���x�����������Ȃ����Ƃ��ł��A����������͎����܂��B����g���ɂ͂��炩���ߏ�������̂ŁA���������򂷂��ɑΏۂ����S/�h�������Ȃ�A��͖��ʂɎg���Ă��܂��ł��傤�B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_GIRL" TARGET="_blank">����</A>�ł��B<br>���Ȃ��͓���ڈȍ~�A��ɏo�������Ƃ��ł��܂��B�l�T�̚�����N�̂��̂Ƃ����ʂ����������Ⴄ�̂ŁA���ɂȂ��č����U��Ԃ�Ǝv���o���邱�Ƃł��傤�B��▼�O�͂킩��܂��񂪁B<br>���������̂Ƃ��A�������Ȃ����l�T�́A�N���ЂƂ�ɂł��P������閵��Ɋ܂܂�Ă���ƁA���|�̂��܂�A���ۂɏP����]���҂Ƃ͕ʂɎ���ł��܂��܂��B���̎��S����q������@�͂���܂���B�܂��A����������邠�Ȃ���K�ڂɁA�T�B�͕ʂ̐l�����P������ł��傤�B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SCAPEGOAT" TARGET="_blank">�X�P�[�v�S�[�g</A>�ł��B<br>�������[���������ɂȂ菈�Y���鑊�肪��܂�Ȃ��ƁA�����������l�B�ɏ��Y����Ă��܂��܂��B���Ȃ����Ō�Ɏw�������l�́A������鑺�l�B�ɗ����A���Y�����ł��傤�B�F�A���������葼�ɂȂ��̂ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_ELDER" TARGET="_blank">���V</A>�ł��B<br>���Ȃ��͏P������Ă��A��x�����͖���������܂��B��������ɁA����ł����𗎂Ƃ�����A���Ȃ��̍��݂͔Ɛl���P���܂��B�ЂƂ�̔Ɛl������ł���̂ł���΁A�Ɛl�͓���\�͂������܂��B</p>',
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
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WOLF" TARGET="_blank">�l�T</A>�ł��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_INTWOLF" TARGET="_blank">�l�T</A>�ł��B<br>�E�Q�������l��'.$know_wisdom.'<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
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
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_LOVEANGEL" TARGET="_blank">�L���[�s�b�h</A>�ł��B<br>�L���[�s�b�h��'.$stat_angel.'<br>���т����ӂ��肪�������т�΁A���Ȃ��̏����ƂȂ�܂��B���Ȃ��ɂ����J�����΂�Ă��Ȃ�����A���Ȃ����g�̎��͏��s�ɂ͒��ڊ֌W���܂���B<br>�܂��A'.$stat_other.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_ROBBER" TARGET="_blank">����</A>�ł��B<br>���Ȃ��́A�N���Ȃ�Ȃ������c���E�����ׂĒm��܂��B���̖�A���̒�����^���̓����܂܂ЂƂ̖�E��I�сA���ʂ̖�E�ɐ������ł��傤�B�^���́A���Ȃ��ɂȂɂ��ۂ��ł��傤���H</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_GURU" TARGET="_blank">�J����</A>�ł��B<br>�J�����͖��ӂӂ��肸�A�D���Ȑl�����Ђ����ɗU�����ނ��Ƃ��ł��܂��B�������g��U�����Ƃ͂ł��܂���B<br>�U�����܂ꂽ���l�����͖�Ȗ�ȗx�薾�����A���̂��Ƃ��o���Ă��܂��B�������A�ނ�̔\�͂⏊���w�c�Ȃǂɕω��͂���܂���B<br>�܂��A'.$stat_other.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
   );

	# ��E��]
   my %explain = (
		prologue => '���Ȃ���_SELROLE_����]���Ă��܂��B�������A��]�����ʂ�̔\�͎҂ɂȂ��Ƃ͌���܂���B',
		dead     => '���Ȃ��͎��S���Ă��܂��B',
		mob      => '���Ȃ���<b>_ROLE_��<A h//dais.kokage.cc/guide/e.jp/giji/?(Role)ROLEID_MOB" TARGET="_blank">�����l</A></b>�ł��B�����Ȃ�w�c�̐l���ɂ��܂܂�܂���B',
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
		millers  => '�W��',
		custom   => '���R�ݒ�',
	);

	# �A�N�V����
	my @actions = (
		'�ɑ��Â���ł����B',
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
		'���Ԃ߂��B',
		'�ɕʂ���������B',
		'��������߂��B',
		'�����ꎞ�Ԗ₢�߂��B',
		'���n���Z���ŉ������B',
		'�Ƀ^���C�𗎂Ƃ����B',
		'�ւ̑O����P�񂵂��B',
		'�Ɋ��ӂ����B',
	);

	my %textrs = (
		CAPTION => '�~���[�Y�z���E',
		HELP    => '�J�[�h�Q�[���uThe Werewolves of Millers Hollow + New Moon�v���̖�E���y���߂܂��B�������A�����҂ɂ͑Ή����Ă��܂���B���ҁA�J�����ɂ������Ⴂ������܂��B',
		FORCE_DEFAULT => 'custom',

		# �_�~�[�L�����̎Q���\���i����������Ă��܂����j�̗L��
		NPCENTRYMES => 1,

		# ���J�A�i�E���X
		ANNOUNCE_EXTENSION  => '����ɒB���Ȃ��������߁A���̍X�V������24���ԉ�������܂����B',
		ENTRYMES            => '_NO_�l�ځA<b>_NAME_</b> ������Ă��܂����B',
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
		NOSELROLE       => '���̐ݒ肪�u��E��]�����v�̂��߁A�S�Ă̖�E��]����������܂��B',
		SETRANDOMROLE   => '<b>_NAME_</b>�̖�E��]�� _SELROLE_ �Ɏ������肳��܂����B',
		SETRANDOMTARGET => '<b>_NAME_</b>��<b>_ABILITY_</b>�̑Ώۂ� <b>_TARGET_</b> �Ɏ������肳��܂����B',
		CANCELTARGET    => '<b>_NAME_</b>��<b>_ABILITY_</b>�ɗL���ȑΏۂ�����܂���ł����B',
		EXECUTESEER     => '<b>_NAME_</b>�́A<b>_TARGET_</b>�������B',
		EXECUTEKILL     => '<b>_TARGET_</b>�I ���������O�̖������I',
		EXECUTEKILLWITCH=> '<b>_NAME_</b>��<b>_TARGET_</b>���E�Q�����B',
		EXECUTELIVEWITCH=> '<b>_NAME_</b>��<b>_TARGET_</b>��h���������B',
		EXECUTEGUARD    => '<b>_NAME_</b>��<b>_TARGET_</b>������Ă���B',
		EXECUTEJAMM     => '<b>_NAME_</b>��<b>_TARGET_</b>���B���Ă���B',
		EXECUTETRICKSTER=> '<b>_NAME_</b>��<b>_TARGET1_</b>��<b>_TARGET2_</b>�̊Ԃɉ^�����J�����񂾁B',
		EXECUTELOVER    => '<b>_NAME_</b>��<b>_TARGET_</b>�Ƃ̊Ԃɉ^�����J�����񂾁B',
		EXECUTEGURU     => '<b>_NAME_</b>��<b>_TARGET_</b>��U�����񂾁B',
		EXECUTESNATCH   => '<b>_NAME_</b>��<b>_TARGET_</b>�̎p��D�����B', 
		EXECUTEFAN      => '<b>_NAME_</b>���₵�����t�́A�������ٗl�ȕ��͋C�ɕ�񂾁B', 
		EXECUTECHILDWOLF=> '<b>_NAME_</b>�͂��ׂ����A���Ƃ��ꂽ�B', 
		EXECUTEGIRL     => '<b>_NAME_</b>����������V��ł���悤�ł��B',
		EXECUTEGIRLFEAR => '<b>_NAME_</b>�͋��낵�����̂����Ă��܂����I',
		EXECUTETHROW    => '<b>_NAME_</b>��<b>_TARGET_</b> �� <b>_GIFT_</b> �������o�����B',
		EXECUTELOST     => '<b>_NAME_</b>�ɂ́A<b>_GIFT_</b> �͓͂��Ȃ������c',
		EXECUTESHIELDBRK=> '<b>_NAME_</b>�Ɍ��̗ւ��n����A�l�m�ꂸ�j�󂵂��B',
		RESULT_RIGHTWOLF=> '<A href="http://dais.kokage.cc/guide/?(Role)ROLEID_RIGHTWOLF" TARGET="_blank">�l�T�̌���</A>�������悤���B<br>�i�T�����̂��Ȃ��́A�肢�t�A��\�҂ɐl�T�Ɣ��肳��܂��B�ł����A���Ȃ��͑��l�ŁA�����������ς��܂���B������ڎw���Ċ撣��܂��傤�B�j',
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

		STATE_SHEEPS   => ' �x�苶�������ڂ낰�ȋL��������B',
		STATE_BONDS    => '���Ȃ���<b>_TARGET_</b>�Ɖ^�����J������ł��܂��B',
		STATE_BIND      => '���Ȃ��͂�������\�͂��g�����Ƃ��ł��܂���B',
		STATE_BIND_ROLE => '���Ȃ��͂�����E�\�͂��g�����Ƃ��ł��܂���B',
		STATE_BIND_GIFT => '���Ȃ��͂������b�\�͂��g�����Ƃ��ł��܂���B',

		WIN_HUMAN       => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_HUMAN" TARGET="_blank">���l�w�c</A></b><br>���l�̐����l�T�ȉ��ɂȂ�܂łɐl�T�Ɨd�����S�ł���Ώ����ł��B<br>�������A�Ō�܂ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�܂��B',
		WIN_WOLF        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_WOLF" TARGET="_blank">�l�T�w�c</A></b><br>���l(�d��������)�̐���l�T�Ɠ����ȉ��܂Ō��点�Ώ����ł��B<br>�������A�Ō�܂ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�܂��B<br>���̗ւ��n�����ƁA�m���ʂ悤�ɔj�󂵂܂��B',
		WIN_LONEWOLF    => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_LONEWOLF" TARGET="_blank">��C�T�w�c</A></b><br>�l�T�w�c�̘T�������Ă��炸�A���l(�d��������)�̐�����C�T�Ɠ����ȉ��܂Ō��点�Ώ����ł��B<br>�������A�Ō�܂ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�܂��B<br>���̗ւ��n�����ƁA�m���ʂ悤�ɔj�󂵂܂��B',
		WIN_PIXI        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_PIXI" TARGET="_blank">�d���w�c</A></b><br>�l�T���S�ł��邩�A���l(�d��������)�̐����l�T�Ɠ����ȉ��܂Ō���܂Łu�����c��΁v�����ł��B�܂��́A�����҂��J�����ɗU��ꂽ�҂����ɂȂ�Ώ����ł��B<br>�������A�Ō�܂ŗ��l�������c���Ă���Ɣs�k�ɂȂ�܂��B<br>���̗ւ��n�����ƁA�m���ʂ悤�ɔj�󂵂܂��B',
		WIN_LOVER       => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_LOVER" TARGET="_blank">���l�w�c</A></b><br>���������̐w�c����������ɂ����Ƃ��A���l�B���������Ă���Ώ����ł��B�������A�ЂƂ肾���h�������Ȃǂ̕s�K�ŁA���𐬏A�ł��Ȃ����l�́A�������܂���B',
		WIN_EVIL        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_EVIL TARGET="_blank">���؂�̐w�c</A></b><br>���l���s�k����Ώ����ł��B<br>�������A���l�����������ꍇ�͔s�k���܂��B���Ȃ��Ə������Ƃ��ɂ���w�c�́A�ЂƂ����ł͂Ȃ���������܂���B',
		WIN_GURU        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_GURU" TARGET="_blank">�J����</A></b><br>�J�����ȊO�̐����҂����U���ꂽ�҂����ɂȂ�Ώ����ƂȂ�܂��B�J�������g�́A�ŏI�I�ɐ����c���Ă��Ȃ��Ƃ��\���܂���B<br>�������A�����珟����~���������̒B�����݂��܂��B',
		MARK_BONDS      => '�J',

		# �A�N�V�����֘A
		ACTIONS_ADDPT     => '�ɘb�̑����𑣂����B_REST_',
		ACTIONS_RESTADDPT => '(�c_POINT_��)',
		ACTIONS_BOOKMARK  => '�����܂œǂ񂾁B',

		# ���샍�O�֘A
		ANNOUNCE_SELROLE    => '<b>_NAME_</b>��_SELROLE_ ����]���܂����i���̐l�ɂ͌����܂���j�B',
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
		EVENTNAME            => \@eventname,
		EXPLAIN_EVENT        => \@explain_event,
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
