package SWTextRS_sow;

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
		'��_LIVES_���B',
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
		'<b>_NAME_</b>���u���Ԃ�i�߂�v���������܂����B',
		'<b>_NAME_</b>���u���Ԃ�i�߂�v��I�����܂����B',
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
		'�V���ȓ����������B�����A�Ƃ炳�ꂽ��n�͐Â��Ȃ܂܂��B<br>���̑��ɁA�����l�e�͂Ȃ��c�c�B',
		'�É_������A�܂Ԃ��������~�蒍���B�\�\�S�Ă̐l�T��ގ������̂��I',
		'�ł����𕢂��A���l�B�͎���̉߂��ɋC�t�����B�l�T�B�͍Ō�̐H�����ς܂���ƁA�V���ȋ]���҂����߂Ė��l�̑��𗧂������Ă������B',
		'���l�B�͋C�t���Ă��܂����B�����^�������K�v�Ȃ�ĂȂ����ƂɁB<br>�l���T���֌W�Ȃ��A���炽�Ȑ������n�܂�c',
		'�ނ����������A���l�B�͊M�̂��������B<br>�������A�ނ�͐^�̏����҂ɋC�t���Ă��Ȃ������c�c�B',
		'�ނ����������A�����ɐl�T�B�̗Y���т������n�����B�������A�ނ�͐^�̏����҂ɋC�t���Ă��Ȃ������c�c�B',
		'',
		'���l���A�l�T���A�d���ł������A���l�����̑O�ł͖��͂ł����B<br>�K���Ō�Ɉ��͏��̂ł��B',
		'',
		'�V���ȓ����������B�����A�Ƃ炳�ꂽ��n�͐Â��Ȃ܂܂��B<br>���̑��ɁA�����l�e�͂Ȃ��c�c�B',
	);

	# ������
	my @caption_winner = (
		'',
		'���l�̏���',
		'�l�T�̏���',
		'�������̏���',
		'�������̏���',
		'�������̏���',
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
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_APRIL_FOOL" TARGET="_blank">�l���n��</A></b><br>��ρA��ρA��ςȂ��ƂɂȂ����B���݂̖�E�͕ω����Ă��邩������Ȃ��B�������N�����J������ł���Ȃ�A�}�ɑ��肪�����Ȃ��Ă��܂��A�J�̑��肾���ɂ������[�ł��Ȃ��B�����Č���Ă��܂����B���邾���́A�����̌��ǂ����Ƃ͂Ȃ��Ɓc�c�B<br><table><tr><th colspan=3>��E�̕ϖe<th rowspan=4>������Ō��ɖ߂�<tr><td>����<td>����<td>����<tr><td>����<td>����<td>���V<tr><td>�܋���<td>����<td>����</table>',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_TURN_FINK" TARGET="_blank">��d�X�p�C</A></b><br>�Ȃ�Ƃ������Ƃ��낤�I��l�������𗠐؂�A�T�ɗ^���锼�[�҂ɂȂ��Ă��܂����B�����ȍ~���A�ނ͑��l�𗠐؂葱���邾�낤�c�c�B<br>����҂���̗ւ̎�����Ȃ�A���̂Ƃ��ɂ��̗͂�������Ă��܂��B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_TURN_FAIRY" TARGET="_blank">�d���̗�</A></b><br>�Ȃ�Ƃ������Ƃ��낤�I��l���X�ɗ�������A�d���̗{�q�ɂȂ��Ă��܂����B�����ȍ~���A�ނ͑��l�𗠐؂葱���邾�낤�c�c�B<br>����҂���̗ւ̎�����Ȃ�A���̂Ƃ��ɂ��̗͂�������Ă��܂��B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_ECLIPSE" TARGET="_blank">���I</A></b><br>�Â����I�������𕢂��A���݂�������O������Ȃ��B���̈Ŗ�͊ۈ���������낤�B���l�ɂȂ肷�܂��A�c�_�����������邱�Ƃ��ł��Ă��܂���������Ȃ��B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_COINTOSS" TARGET="_blank">Sir Cointoss</A></b><br>���T���Ȃ����B���T���Ȃ����B�R�C���g�X���͂��̑��̓��[���ʂɈӌ�������悤�ł������܂��B���̌�ӌ��ɂ���ẮA���[���ʂɊ�Â������Y�����~�߂ɂ��邱�Ƃ�����܂��B�ܕ��ܕ����炢���ȁB',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_FORCE" TARGET="_blank">�e����</A></b><br>�����̓��[���͖��F�������B���ꂩ�����[�����u�Ԃɂ��̓��e�̓n�b�L���ƌ����邩��A���[���Z�b�g����Ƃ��͋C��t���āI',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_MIRACLE" TARGET="_blank">���</A></b><br>�A���Ă����I����̍�����A�����̏P���Ŏ��񂾋]���҂��������Ă����I�\�͂���������������Ȃ�����ǁA����͍��ׂȂ��Ƃ���I�ˁI<br>�l�T�A��C�T�A�܋��҂��ȂǂɏP��ꂽ���҂͐����Ԃ�B�������A���̔\�͎͂�����B',
'<b><A href="http://dais.kokage.cc/guide/?(Event)EVENTID_PROPHECY" TARGET="_blank">���҂̂�����</A></b><br>���҂͖��̖����ɍ������܂����B���̔C���A<b>�����</A></b>�ɂӂ��킵���l��������ƁB�����C���͉�����A�����炵��<b>�����</A></b>�͊F�Ɋ��тŌ}��������邾�낤�B',

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
		'���܂���',  '�Ȃ�',    '�r��',  '����',  '','���̗�', '', '���S', '�d���̎q', '���[��',
		''        ,'�����','���肢�t',      '',  '',      '', '',     '',         '',       '',
	);

	# �A�C�e�����i�ȗ����j
	my @giftshortname = (
		'',   '', '�r', '', '', '��',   '','�S','�d', '�[',
		'', '��', '��', '', '',   '',   '',  '',  '',   '',
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
		'���܂���', '���l'          ,   '������'      ,   '���L��'      , '����'  , '�肢�t'  , '����t'      , '�C��t'      , '����'    , '��l'       ,
		'��\��'  , '�M��\��'    ,   '���t'        ,   '�~���'      , '�Ǐ]��'  , '������'  , '�܋���'      , '�l��'        , '���q�l'  , '�߂��ꂽ�l' ,
		''        , '���l'          ,   '�a����'      ,   '�a�l'        , '�B���p�t', '����'    , '����'        , ''            , ''        , ''           ,
		''        , ''              ,   '���h�J���l��',   '�R�E�����l��', ''        , ''        , ''            , ''            , ''        , ''           ,   
		''        , '���l'          ,   '���M��'      ,   '�l�`�g��'    , '�b�����l', '���T'    , ''            , '���_��'      , '���p�t'  , ''           ,
		''        , ''              ,   '��Ȃ��R�m'  ,   ''            , ''        , ''        , ''            , ''            , ''        , ''           ,   
		''        , '�l�T'          ,   ''            ,   '�q�T'        , '���T'    , '���T'    , '�e�T'        , '���T'        , '�٘T'    , ''           ,
		''        , ''              ,   ''            ,   ''            , ''        , ''        , ''            , ''            , ''        , ''           ,   
		''        , '�n���X�^�[�l��',   '���c'        ,   ''            , ''        , '�ז��V��', '�[�T�d��'    , ''            , '���ԗd��', '�s�N�V�['   ,
		''        , '�L���[�s�b�h'  ,   '�A����'      ,   '�_�b�}�j�A'  , ''        , '��C�T'  , ''            , ''            , ''        , ''           ,
	);

	# ��E���i�ȗ����j
	my @roleshortname = (
		'',   '��', '��', '��', '��', '��', ''  , '', '����', '��',
	 '��',   ''  , ''  , '�~', ''  , ''  , ''  , '', ''    , '��',
		'',   ''  , ''  , ''  , '�B', ''  , ''  , '', ''    , ''  ,   
		'',   ''  , '�h', '�P', ''  , ''  , ''  , '', ''    , ''  ,   
		'',   '��', '�M', '�`', '�b', ''  , ''  , '', ''    , ''  ,
		'',   ''  , '�R', ''  , ''  , ''  , ''  , '', ''    , ''  ,   
		'',   '�T', ''  , '�q', '��', ''  , ''  , '', ''    , ''  ,   
		'',   ''  , ''  , ''  , ''  , ''  , ''  , '', ''    , ''  ,   
		'',   '�n', ''  , ''  , ''  , ''  , ''  , '', ''    , '�o',   
		'',   '�p', ''  , '�_', ''  , ''  , ''  , '', ''    , ''  ,   
	);

	# �\�͎җp���ꔭ�����̃��x��
	my @caption_rolesay = (
		'',''    ,''    ,''    ,'����',''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,''    ,''    ,''    ,''    ,''    ,'','',
		'','�O�b','�O�b','�O�b',''    ,''    ,''    ,''    ,'','',
		'',''    ,''    ,'�߈�','����',''    ,''    ,''    ,'','',
		'',''    ,'����',''    ,''    ,''    ,''    ,''    ,'','',
		'','����','����','����','����','����','����','����','','',
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
		''    ,''    ,'�P��',''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,'�P��','�P��','�P��','�P��'    ,'�P��'    ,'�P��'  ,'�P��'  ,'�P��'  ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'',   
		''    ,''    ,''    ,''    ,''        ,''        ,''      ,''      ,''      ,'����',   
		'����','����',''    ,'����',''        ,'�P��'    ,''      ,'�U��'  ,'���˂�','',
	);

	# ����
	my $stat_kill   = '�E�Q���܂��B�������A�Ώۂ���q����Ă��邩�A�d���ł���΁A���͔͂������܂���B';
	my $stat_wolf   = '����A�l�T�S���ň�l�����A���l��'.$stat_kill.'<br>';
	my $stat_wisper = '�l�T�i�Ƃb�����l�j���m�ɂ����������Ȃ���b���\�ł��B<br>';
	my $stat_pixi   = '�l�T�ɎE����邱�Ƃ�����܂���B�������A�肢�̑ΏۂƂȂ�Ǝ��S���܂��B<br>�肢�t�A��\�҂ɂ͐l�ԂƂ��Ĕ��ʂ���܂����A��������ł͐l�Ԃɂ��l�T�ɂ��������܂���B<br>';
	my $stat_enemy  = '�l�Ԃł���Ȃ���A�l�O�ɋ��͂��闠�؂�҂ł��B��������ł͐l�Ԉ����ŏW�v����邽�߁A�ꍇ�ɂ���Ă͊����Ď��ʕK�v������܂��B';
	my $stat_fm     = '�����ȊO�̋��L�ҁE���҂��N���m���Ă��܂��B';
	my $act_seer    = '����A�ЂƂ��肢�A���̐l��';
	my $act_medium  = '���S�Ȏ��̂ɂ��Ĕ��f���邱�Ƃ͏o���܂���B���Y��ˑR���Ŏ��񂾎҂�';
	my $stat_seer   = '�܂��A�d����肤�Ǝ�E���邱�Ƃ��o���܂��B�������A���T�����Ă��܂��ƁA��E����Ă��܂��܂��B';
	my $know_seer   = '�l�Ԃ��l�T�����ʂł��܂��B';
	my $know_wisdom = '����E���킩��܂��B���b�́A��E�Ƃ͈Ⴂ�܂��B���̂��ߔ��[�ҁA���S�𒼐ڌ������邱�Ƃ͂ł��܂���B';
	my $stat_droop  = '���Ȃ��́A�������l�T�̐l���̓����ɁA���𗎂Ƃ��܂��B';
	my $stat_angel  = '�P���ځA�D���ȓ�l�Ɂg�^�����J�h�����т��鎖���ł��܂��B�g�^�����J�h�����񂾐l�́A�Е������S����ƌ��ǂ��Ď��S���܂��B';

	my @explain_gift = (
'',
'',
'<p>���Ȃ��͑��蕨��<A //dais.kokage.cc/guide/ne.jp/giji/?(Gift)GIFTID_LOST" TARGET="_blank">�r��</A>���܂����B<br>������x�Ǝ�ɂ��邱�Ƃ͂Ȃ��ł��傤�B�����܂����Ȃ��̎�ɑ��蕨�������Ă��A���������Ă��܂��܂��B�����āA���Ȃ�������ɋC�t�����Ƃ͂Ȃ��ł��傤�B</p>',
'',
'',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_SHIELD" TARGET="_blank">���̗�</A>����芪���܂��B<br>���Ȃ��͂������A�P������Ă����Ƃ��Ă�����܂����B<br>���̗ւ͂ЂƂ����x�������܂���B�������̗ւ�'.$stat_gift.'���Ɍ���Ɏ����ׂ��ǂ��F��I�т܂��傤�B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_GLASS" TARGET="_blank">����</A>���Ƃ炵�܂��B<br>���Ȃ��́A������n�����肪'.$know_seer.'<br>'.$stat_seer.'<br>�����͂ЂƂ����x�����Ƃ炵�܂���B��������'.$stat_gift.'���ɐ��̂�\���ׂ����������I�т܂��傤�B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_OGRE" TARGET="_blank">���S</A>�ł��B<br>�\�����͑��̖�ڂ�ттĂ��܂����A���Ȃ��͐l���P�������S�Ȃ̂ł��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_FAIRY" TARGET="_blank">�d�����琶�܂ꂽ�q</A>�ł��B<br>�\�����͑��̖�ڂ�ттĂ��܂����A���Ȃ��͐l�Ȃ�ʑ��݂Ȃ̂ł��B<br>�T�̏P����܋��҂̎�ɂ��E����邱�Ƃ͂���܂���B�������肢�̑ΏۂƂȂ�Ǝ��S���܂��B<br>�肢�t�A��\�҂ɂǂ����ʂ���邩�́A���Ƃ��Ƃ̖�E�ɂ��܂��B��������ł͐l�Ԃɂ��l�T�ɂ��������܂���B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_FINK" TARGET="_blank">���[��</A>�ł��B<br>�\�����͑��̖�ڂ�ттĂ��܂����A���Ȃ��͐l�Ƃ����ʁA�l�T�Ƃ����ʁA���[�Ȑ��̂��B���Ă��܂��B<br>'.$stat_enemy.'</p>',

'',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_DECIDE" TARGET="_blank">�����</A>�ł��B<br>���Ȃ��͒ǉ��[�𓊂��錠���������Â��܂��B�s�g���邱�ƂŁA���݂��������Ƃ��ł���ł��傤�B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_SEERONCE" TARGET="_blank">����t</A>�ł��B<br>�肢�t�̗͂������܂����A���̔\�͂͂�������x�����g�����Ƃ��ł��܂���B<br>�ЂƂ��肢�A���̐l��'.$know_seer.'<br>'.$stat_seer.'</p>',
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
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">���l</A>�ł��B<br>����Ȕ\�͂͂����Ă��܂���B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_STIGMA" TARGET="_blank">_ROLESUBID_������</A>�ł��B<br>�Ɠ��̈�������߁A���Ȃ��̐��͔̂�r�I�M�p����₷���ł��傤�B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_FM" TARGET="_blank">���L��</A>�ł��B<br>���Ȃ���'.$stat_fm.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SYMPATHY" TARGET="_blank">����</A>�ł��B<br>���Ȃ���'.$stat_fm.'<br>�܂��A���ғ��m�ɂ����������Ȃ���b���\�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SEER" TARGET="_blank">�肢�t</A>�ł��B<br>'.$act_seer.$know_seer.'<br>'.$stat_seer.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SEERWIN" TARGET="_blank">�M��t</A>�ł��B<br>'.$act_seer.$know_win.'<br>'.$stat_seer.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SEERROLE" TARGET="_blank">����</A>�ł��B<br>'.$act_seer.$know_wisdom.'<br>'.$stat_seer.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_GUARD" TARGET="_blank">��l</A>�ł��B<br>����A��l��T�̏P���A�������͕t���_���܋��҂̎肩���邱�Ƃ��o���܂��B<br>�������g����邱�Ƃ͏o���܂���B</p>',

'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_MEDIUM" TARGET="_blank">��\��</A>�ł��B<br>'.$act_medium.$know_seer.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_NECROMANCER" TARGET="_blank">�~���</A>�ł��B<br>'.$act_medium.$know_seer.'<br>�܂��A��▼�O�͂킩��܂��񂪁A���Ȃ��̎��ɂ͎��҂̐����͂����Ⴄ���Ƃł��傤�B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">���l</A>�ł��B<br>����Ȕ\�͂͂����Ă��܂���B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_ALCHEMIST" TARGET="_blank">�B���p�t</A>�ł��B<br>���Ȃ��͈�x�����A������ނ��Ƃ��o���܂��B����������񂾓��ɏ��Y�ȊO�̗v���Ŗ��𗎂Ƃ����ꍇ�A���̔Ɛl�𓹘A��ɂ��܂��B�l�T�̏P���̏ꍇ�A�P�����s�҂��ΏۂƂȂ�܂��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SNATCH" TARGET="_blank">���h�J���l��</A>�ł��B<br>�D���Ȑl���̊�Ɩ��O��D���A���g�̂���Ɠ���ւ��邱�Ƃ��ł��܂��B���̔\�͔͂��ɘI�����₷���̂ŁA�s�g�ɂ͒��ӂ��K�v�ł��B<br>��������̊ԂɎr�̂ɂȂ����l��ΏۂɑI�񂾂Ȃ�A�������Ȃ��͖��𗎂Ƃ��A���Ȃ��ƂȂ������̎r�̂͑��𐁂��Ԃ��ł��傤�B�܂��A���΂ꂽ�J��A�J�����ɗU��ꂽ���Ƃ͎p�ƂƂ��ɂ���A�p���ڂ��ւ����Ƃ��Ɉ����p�����Ƃ�����܂��B��x�ڂ��ւ����p�́A�i���ɂ��Ȃ��̂��̂ł��B��x�ƌ��ɂ͖߂�܂���B<br>�܂��A�O�g���ł����������Ȃ���b���\�ł��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_BAT" TARGET="_blank">�R�E�����l��</A>�ł��B<br>�O�g���ł����������Ȃ���b���\�ł��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_POSSESS" TARGET="_blank">���l</A>�ł��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_FANATIC" TARGET="_blank">���M��</A>�ł��B<br>�l�T�ɂ͂��Ȃ��̐��̂͂킩��܂��񂪁A���Ȃ��͐l�T���N���m���Ă��܂��B�܂��A�V���ɐl�T�ƂȂ������̂�m�邱�Ƃ��ł��܂��B<br>�ł����A���Ȃ��͘T������[�T�d�����l�T�ł���ƌ�F���Ă��܂��܂����A��C�T�̐��̂�m�邱�Ƃ͂ł��܂���B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_MUPPETER" TARGET="_blank">�l�`�g��</A>�ł��B<br>���Ȃ���_NPC_�̌����؂�A�D���Ȍ��t��`���邱�Ƃ��ł��܂��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WISPER" TARGET="_blank">�b�����l</A>�ł��B<br>'.$stat_wisper.$stat_enemy.'���l���ɂȂ�Ə��s���m�肷��󋵂�����܂��A�ł������̏ꍇ�������ŏI�����邱�Ƃ͂���܂���B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_HEADLESS" TARGET="_blank">��̂Ȃ��R�m</A>�ł��B<br>'.$stat_wolf.'�����āA���Ȃ��͐l�T���Ԃ��a��̂Ă邱�Ƃ��}���܂���B<br>�܂��A'.$stat_wisper.'</p>',
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
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_INTWOLF" TARGET="_blank">�q�T</A>�ł��B����Ȕ\�͂����l�T�ł��B<br>���Ԃ⎩�����E�Q�������l��'.$know_wisdom.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_CURSEWOLF" TARGET="_blank">���T</A>�ł��B����Ȕ\�͂����l�T�ł��B<br>���Ȃ������Ă��܂����肢�t�͎��S���܂��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
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
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_PIXI" TARGET="_blank">�n���X�^�[�l��</A>�ł��B<br>'.$stat_pixi.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_TRICKSTER" TARGET="_blank">�s�N�V�[</A>�ł��B<br>�s�N�V�[��'.$stat_pixi.$stat_angel.'���΂ꂽ�ނ�ɂƂ��ẮA�P�Ȃ�͂����f�Ȉ��Y�ɂ����܂���B</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_LOVEANGEL" TARGET="_blank">�L���[�s�b�h</A>�ł��B<br>�L���[�s�b�h��'.$stat_angel.'<br>���т�����l���������т�΁A���Ȃ��̏����ƂȂ�܂��B���Ȃ��ɂ����J�����΂�Ă��Ȃ�����A���Ȃ����g�̎��͏��s�ɂ͒��ڊ֌W���܂���B<br>�܂��A'.$stat_other.'</p>',
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_LOVER" TARGET="_blank">�_�b�}�j�A</A>�ł��B<br>����ځA�D���Ȑl�����t���Ƃ��đI�сA�g�^�����J�h�����т��A��q���肵�܂��B���̒��A���Ȃ��͓��p������킵�A�J�̎t���Ɠ�����E�ɂȂ��Ă��܂��B<br>�g�^�����J�h�����񂾓�l�́A�Е������S����ƌ��ǂ��Ď��S���܂��B</p>',
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
		default  => '�W��',
		wbbs_c   => '�l�TBBS C��',
		wbbs_f   => '�l�TBBS F��',
		test1st  => '�l�T�R�� ������^',
		test2nd  => '�l�T�R�� ������^',
		custom   => '���R�ݒ�',
	);

	# �A�N�V����
	my @actions = (
		'���n���Z���ŉ������B',
		'�Ƀ^���C�𗎂Ƃ����B',
		'���Ԃ߂��B',
		'�Ɏ��U�����B',		
		'�ɑ��Â���ł����B',
		'���������B',
		'�Ɏ���X�����B',
		'�������ƌ��߂��B',
		'�����b�����Ɍ����B',
		'���������B',
		'�ɋ������B',
		'�ɏƂꂽ�B',
		'�ɂ����V�������B',
		'�ɔ��΂񂾁B',
		'��������߂��B',
		'�����ꎞ�Ԗ₢�߂��B',
		'�����Ԃ��Ɗ������B',
		'�Ɋ��ӂ����B',
	);

	my %textrs = (
		CAPTION => '�l�T����',
		HELP    => '�E�F�u�Q�[���u�l�T����v���̖�E���y���߂܂��B�������A�ׂ�������ɈႢ������܂��B',
		FORCE_DEFAULT => 'custom',
		
		# �_�~�[�L�����̎Q���\���i����������Ă��܂����j�̗L��
		NPCENTRYMES => 1,
		
		# ���J�A�i�E���X
		ANNOUNCE_EXTENSION  => '����ɒB���Ȃ��������߁A���̍X�V������24���ԉ�������܂����B',
		ENTRYMES            => '_NO_�l�ځA<b>_NAME_</b> ������Ă��܂����B',
		EXITMES             => '<b>_NAME_</b>�������o�čs���܂����B',
		SUDDENDEATH         => '<b>_NAME_</b>�͓ˑR�������B',
		SUICIDEBONDS        => '<b>_NAME_</b>���J�Ɉ���������悤��_TARGET_�̌��ǂ����B',
		SUICIDELOVERS       => '<b>_NAME_</b>�͈����݂ɕ���_TARGET_�̌��ǂ����B',
		ANNOUNCE_RANDOMVOTE => '(�����_�����[)',
		ANNOUNCE_VICTORY    => '_VICTORY_�ł��I<br>',
		ANNOUNCE_EPILOGUE   => '_AVICTORY_�S�Ẵ��O�ƃ��[�U�[�������J���܂��B_DATE_ �܂Ŏ��R�ɏ������߂܂��̂ŁA����̊��z�Ȃǂ��ǂ����B',

		RANDOMENTRUST => '(�����_���ϔC)',

		# �\�͊֘A
		UNDEFTARGET     => '�i�p�X�j',
		RANDOMTARGET    => '�����_��',
		RANDOMROLE      => '�����_��', # ��E�����_����]
		NOSELROLE       => '���̐ݒ肪�u��E��]�����v�̂��߁A�S�Ă̖�E��]����������܂��B',
		SETRANDOMROLE   => '<b>_NAME_</b>�̖�E��]�� _SELROLE_ �Ɏ������肳��܂����B',
		SETRANDOMTARGET => '<b>_NAME_</b>��<b>_ABILITY_</b>�̑Ώۂ�_TARGET_�Ɏ������肳��܂����B',
		CANCELTARGET    => '<b>_NAME_</b>��<b>_ABILITY_</b>�ɗL���ȑΏۂ�����܂���ł����B',
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

		EXECUTEFAN      => '<b>_NAME_</b>���₵����蕶��́A�������ٗl�ȕ��͋C�ɕ�񂾁B', 
		EXECUTECHILDWOLF=> '<b>_NAME_</b>�͂��ׂ����A���Ƃ��ꂽ�B', 
		EXECUTEGIRL     => '<b>_NAME_</b>���������肨�U�������悤���B',
		EXECUTETHROW    => '<b>_NAME_</b>��<b>_TARGET_</b>��<b>_GIFT_</b>�������o�����B',
		EXECUTELOST     => '<b>_NAME_</b>�ɂ�<b>_GIFT_</b>�͓͂��Ȃ������c',
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
		RESULT_ENCOUNT  => '<b>_DATE_����</b>�̖�A�s�R�Ȏp�����������B',

		STATE_BONDS     => '���Ȃ���<b>_TARGET_</b>�Ɖ^�����J������ł��܂��B',

		WIN_HUMAN       => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_HUMAN" TARGET="_blank">���l�w�c</A></b><br>�l��(�d����l�O�̎҂�����)�̐����l�T�ȉ��ɂȂ�܂łɐl�T�Ɨd�����S�ł���Ώ����ł��B<br>�������A�T��S�ł��������_�ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_WOLF        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_WOLF" TARGET="_blank">�l�T�w�c</A></b><br>���[���u�^�u���̐l�T�v�u���񂾂畉���v�uTrouble��Aliens�v�ł͐l��(�d����l�O�̎҂�����)�̐���l�T�Ɠ����ȉ��܂Ō��点�΁A���[���u�~���[�Y�z���E�v�u�[�����̖�v�ł͖�E�u���l�v��S�ł�����Ώ����ł��B<br>�������A�Ō�܂ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_LONEWOLF    => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_LONEWOLF" TARGET="_blank">��C�T�w�c</A></b><br>���[���u�^�u���̐l�T�v�u���񂾂畉���v�uTrouble��Aliens�v�ł͐l��(�d����l�O�̎҂�����)�̐�����C�T�Ɠ����ȉ��܂Ō��点�΁A���[���u�~���[�Y�z���E�v�u�[�����̖�v�ł͖�E�u���l�v��S�ł����A���A�l�T�w�c�̘T�������Ă��Ȃ���Ώ����ł��B<br>�������A�Ō�܂ŗd���A�������͗��l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ�������~���������̒B�����݂��܂��B',
		WIN_PIXI        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_PIXI" TARGET="_blank">�d���w�c</A></b><br>�l�T���S�ł��邩�A�l��(�d����l�O�̎҂�����)�̐����l�T�Ɠ����ȉ��܂Ō���܂Łu�����c��΁v�����ł��B<br>�������A���l�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
		WIN_LOVER       => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_LOVER" TARGET="_blank">���l�w�c</A></b><br>���l�B�����������c��A�������͂��������̐w�c����������ɂ����Ƃ��A�J�̗��l�B���������Ă���Ώ����ł��B�������A�ЂƂ肾���h�������Ȃǂ̕s�K�ŁA���𐬏A�ł��Ȃ����l�́A�������܂���B',
		WIN_EVIL        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_EVIL" TARGET="_blank">���؂�̐w�c</A></b><br>���l�E���l���s�k����Ώ����҂̈���ɉ����܂��B<br>���Ȃ��͔j�ł�]��ł���̂ł��B�l�T��d���₻��ȊO�̏����A�܂��́A�N�����Ȃ��Ȃ邱�Ƃ�ڎw���܂��傤�B',
		MARK_BONDS      => '�J',

		# �A�N�V�����֘A
		ACTIONS_ADDPT          => '�ɘb�̑����𑣂����B_REST_',
		ACTIONS_RESTADDPT      => '(�c_POINT_��)',
		ACTIONS_BOOKMARK       => '�����܂œǂ񂾁B',
		
		# ���샍�O�֘A
		ANNOUNCE_SELROLE    => '<b>_NAME_</b>�� _SELROLE_ ����]���܂����i���̐l�ɂ͌����܂���j�B',
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
