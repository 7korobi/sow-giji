package SWTextRS_complex;

sub GetTextRS {
   # �v�����[�O�`����ڂ̊J�n�����b�Z�[�W
   my @announce_first = (
      '<b>�i�~�b�V�����A���[�g�j</b><br>��F�̑g�D���A�e���Ȃ�R���s���[�^�[�E_NPC_��j�󂷂邽����݂������Ă��܂��B�����āA�����ɏW�܂����s���ɂ́c�c�A�A���̈ꖡ���܂܂�Ă��܂��B',
      'R&D�i�����݌v����j�́A�s���B�̂��߂ɑ������J�����܂����B<br>�o�k�b����z�z���󂯁A�t�B�[���h�e�X�g�����A���Ђ𔭌����Ȃ����B�x���i�̋@���͕ۂ���Ă��܂��B',
      '<b>�i���ׂẴA���[�g�͒��ق��A�V��͐^���Âɏ��������B�j<br>_NPC_���j�󂳂�A�N���[���������܂����B</b><br>��������́A��zap���͐T�d�ɍs��Ȃ��Ă͂Ȃ�܂���B���̃N���[���͂ȂɂЂƂA���܂���邱�Ƃ��ł��Ȃ��̂ł��B<br>�Î�̒��A�N���������o���܂��B��������́A��zap���͈���ЂƂ�ɐ������悤�B',
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
      '_NAME_ �� _TARGET_ �Ƀ��[�U�[�E�K�����������B_RANDOM_',
      '_NAME_ �� _COUNT_�l�����[�U�[�E�K�����������B',
      '_NAME_ �͎s���̎�ɂ�聥zap�����ꂽ�B',
      '_NAME_ ����zap������ɂ͈؂ꑽ�������̂ŁA����߂��B',
   );

   # �P�����̂��m�点
   my @announce_selectkill =(
      '',
      '_NAME_ �� _COUNT_�l�����[�U�[�E�K�����������B',
      '_NAME_ �͏P�����ꂽ�B',
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
      '_NAME_�́�zap�����ϔC���Ă��܂��B_RANDOM_',
      '_NAME_�́�zap�����ϔC���悤�Ƃ��܂������A�����s�\�ł����B_RANDOM_',
   );

   # �R�~�b�g
   my @announce_commit = (
      '_NAME_������i�߂邱�Ƃ���߂��B',
      '_NAME_�͎����i�ނ悤�A�V��𑀍삵���B',
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
      '_TARGET_ �����c�Ȏp�Ŕ������ꂽ�B',
   );
   
   my %status_live = (
      live       =>  '��������',
      executed   =>  '��zap��',
      victim     =>  '�P��ꂽ',
      cursed     =>  '�Ռ�������',
      droop      =>  '���Ԑ؂�',
      suicide    =>  '��ǂ���',
      feared     =>  '�m���Ă��܂�����',
      suddendead =>  '�ˑR��',
   );

   # ���s���b�Z�[�W
   my @announce_winner = (
      '�S�Ă̐l���������������B���l�̃R���v���b�N�X�͂₪�ċ����ʂĂ�̂��낤�B',
      '��F�̑g�D�͑S�ł����c�c�B���Ђɋ�������X�͋������̂��I',
      '�s���B�͎���̉߂��ɋC�t�����B<br>���Ђ̎c�}�͍Ō�̔j�󊈓����ς܂���ƁA�Ԃ̍L������݂����̂��B�n���V���[�I���u�I',
      '�s���B�͋C�t���Ă��܂����B�����^�������K�v�Ȃ�ĂȂ����ƂɁB<br>�y�ɍ������낵�A���Ƌ��ɐ����悤�B��Ƌ��ɓ~���z���A���Ƌ��ɏt�����������B',
      '�S�Ă̌��Ј���ގ������c�c�B<br>�����A���󂵂��R���v���b�N�X�͖߂�Ȃ��B<br>�y�ɍ������낵�A���Ƌ��ɐ����悤�B��Ƌ��ɓ~���z���A���Ƌ��ɏt�����������B�ǂ�Ȃɋ��낵������������Ă��A��������̂��킢�����Ȏs���𑀂��Ă��B�y���痣��ẮA�������Ȃ��B',
      '���̎��A���Ј��͏������m�M���A�����ď��߂ĉ߂��ɋC�Â����B�������񂾑������܂��A�����Ďg�����ɂȂ�Ȃ����ƂɁB<br>�y�ɍ������낵�A���Ƌ��ɐ����悤�B��Ƌ��ɓ~���z���A���Ƌ��ɏt�����������B�ǂ�Ȃɋ��낵������������Ă��A��������̂��킢�����Ȏs���𑀂��Ă��B�y���痣��ẮA�������Ȃ��B',
      '�s���B�́A�����Č��Ј�������̉߂��ɋC�t�����B�}�͂���Ȃ钳����𑗂荞��ł����ƁB<br>�������ЂƂ�̌��Ј��͍Ō�̔j�󊈓����ς܂���ƁA�Ԃ̍L������݂����̂��B�̂���҂���Ȃ��L����B',
      '�s�����A�u�l�T�v���A�~���[�^���g�ł������A���l�����̑O�ł͖��͂ł����B<br>�K���Ō�Ɉ��͏��̂ł��B�Ƃ���ň����Ĉ��������H',
      '',
      '�S�Ă̐l���������������B���l�̃R���v���b�N�X�͂₪�ċ����ʂĂ�̂��낤�B',
   );

   # ������
   my @caption_winner = (
      '',
      '�s���̏���',
      '���Ђ̏���',
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
		WIN_GURU     => '�O���E�̋��c',
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
      '���܂���',          '�Ȃ�',  '�r��',  '����',  '','���̗�', '����', '���Ђ̃X�p�C', '�V�l�~���[�^���g', '���Ђ̂�����',
      ''        ,'�`�[�����[�_�[','����t',      '',  '',      '',     '',             '',                 '',             '',
   );

   # �A�C�e�����i�ȗ����j
   my @giftshortname = (
      '',   '', '�r', '', '', '��',   '','��',  '', '',
      '', 'TL',   '', '', '',   '',   '',  '',  '', '',
   );

   # �A�C�e���p���ꔭ�����̃��x��
   my @caption_giftsay = (
      '', '', '', '', '', '', '', '����', '', '',
      '', '', '', '', '', '', '',     '', '', '',
   );

   # �A�C�e���\�͖�
   my @abi_gift = (
      '',        '',     '', '', '', '�n��', '�n��', '�P��', '', '',
      '', '��zap��', '�肤', '', '',     '',     '',     '', '', '',
   );

   # ��E��
   my @rolename = (
      '���܂���','���A�����x��',''              ,''            ,'�M�����x��'  ,''                ,''                ,''              , ''           ,''              ,
      ''        ,''            ,''              ,''            ,''            ,'�������I�t�B�T�[','�z�d�q�C�x��'    ,'�ΖȊZ�x��'    ,'���E�тt�u�l',''              ,
      ''        ,''            ,'�������e�x��'  ,''            ,''            ,'���`�d�c�x��'    ,'�w���X�R�[�v�x��','�X�P�[�v�S�[�g',''            ,''              ,
      ''        ,''            ,'�苾�x��'      ,'�e���p��'    ,''            ,''                ,''                ,''              ,''            ,''              ,
      ''        ,''            ,''              ,'�����W���b�N','���Ж���'    ,'���Г���'        ,''                ,''              ,''            ,''              ,
      ''        ,''            ,''              ,''            ,''            ,''                ,''                ,''              ,''            ,''              ,
      ''        ,'���Ј�'      ,''              ,'���Ј�'      ,''            ,''                ,'���ЃA�C�h��'    ,''              ,''            ,''              ,
      ''        ,''            ,''              ,''            ,''            ,''                ,''                ,''              ,''            ,''              ,
      ''        ,''            ,''              ,''            ,''            ,''                ,''                ,''              ,''            ,'���Y�d��'      ,
      ''        ,''            ,''              ,'��q'        ,'����'        ,''                ,'��C�T'          ,'�O���E���c'    ,''            ,''              ,
   );

   # ��E���i�ȗ����j
   my @roleshortname = (
      '',   '�A', ''  , ''  , '�M', ''   , ''  , ''  , ''  , ''  ,
      '',   ''  , ''  , ''  , ''  , '�u' , '��', '��', 'UV', ''  ,
      '',   ''  , '��', ''  , ''  , 'AED', '�w', '��', ''  , ''  ,   
      '',   ''  , '��', '�O', ''  , ''   , ''  , ''  , ''  , ''  ,
      '',   ''  , ''  , '��', '��', '��' , ''  , ''  , ''  , ''  ,
      '',   ''  , ''  , ''  , ''  , ''   , ''  , ''  , ''  , ''  ,
      '',   ''  , ''  , '��', ''  , ''   , '��', ''  , ''  , ''  ,   
      '',   ''  , ''  , ''  , ''  , ''   , ''  , ''  , ''  , ''  ,
      '',   ''  , ''  , ''  , ''  , ''   , ''  , ''  , ''  , '�Y',   
      '',   ''  , ''  , '��', '��', ''   , '��', '��', ''  , ''  ,   
   );

   # �\�͎җp���ꔭ�����̃��x��
   my @caption_rolesay = (
      '',''    ,''    ,''        ,'����',''    ,''    ,''    ,'',''    ,
      '',''    ,''    ,''        ,''    ,''    ,''    ,''    ,'',''    ,
      '',''    ,''    ,''        ,''    ,''    ,''    ,''    ,'',''    ,
      '','�O�b','�O�b','�O�b'    ,''    ,''    ,''    ,''    ,'',''    ,
      '',''    ,''    ,'����'    ,'����',''    ,''    ,''    ,'',''    ,
      '','����',''    ,''        ,''    ,''    ,''    ,''    ,'',''    ,
      '','����','����','����'    ,'����','����','����','����','',''    ,
      '',''    ,''    ,''        ,''    ,''    ,''    ,''    ,'',''    ,
      '',''    ,''    ,''        ,''    ,''    ,'����',''    ,'',''    ,
      '',''    ,''    ,''        ,''    ,''    ,''    ,''    ,'',''    ,
   );

   # �\�͖�
   my @abi_role = (
      '',''    ,''    ,''    ,''    ,''        ,''    ,'�T�m','','',   
      '',''    ,''    ,''    ,''    ,''        ,'�_��',''    ,'','',   
      '',''    ,''    ,''    ,''    ,'�V���b�N','�`��','�^��','','',   
      '','�B��','����',''    ,''    ,''        ,''    ,''    ,'','',   
      '',''    ,''    ,''    ,''    ,''        ,''    ,''    ,'','',   
      '','�P��',''    ,''    ,''    ,''        ,''    ,''    ,'','',   
      '','�P��','�P��','�P��','�P��','�P��'    ,'�P��',''    ,'','',   
      '',''    ,''    ,''    ,''    ,''        ,''    ,''    ,'','',   
      '',''    ,''    ,''    ,'����',''        ,''    ,''    ,'','',   
      '',''    ,''    ,'����',''    ,''        ,'�P��','�U��','','',
   );

   # ����
   # ����
   my $stat_kill   = '�E�Q���܂��B�������A�Ώۂ���q����Ă��邩�A���̗ւ�n����Ă��邩�A�d���A�������͈�C�T�ł���΁A���͔͂������܂���B�܂��A�Ώۂ����Г���҂ł���Ό��Ј��ɂȂ�܂��B�Ώۂ��A�X�x�X�g�A�[�}�[�𒅍���ł���ꍇ�������܂��񂪁A�ނ͂��ƈ���̖��ł��傤�B';
   my $stat_wolf   = '����A���БS���ň�l�����A�s����'.$stat_kill.'<br>';
   my $stat_wisper = '���Ёi�ƁA���Ж����������Ă��܂����s���j���m�ɂ����������Ȃ���b���\�ł��B<br>';
   my $stat_pixi   = '���ЂɎE����邱�Ƃ�����܂���B���������ł͎s���ɂ����Ђɂ��������܂���B<br>�s���͖ܘ_�m��܂��񂪁A�O���E�ɂ͔�������A�ΖL���ȐX�A���ݐ؂����΂��L����A�����āA��R�̃~���[�^���g���Z��ł��܂��B<br>';
   my $stat_enemy  = '�s���ł���Ȃ���A���Ђɋ��͂��闠�؂�҂ł��B���������ł͎s�������ŏW�v����邽�߁A�ꍇ�ɂ���Ă͊����Ď��ʕK�v������܂��B';
   my $stat_fm     = '�����ȊO�ɐM�������x�����ꂽ�̂͒N���A�m���Ă��܂��B';
   my $act_seer    = '';
   my $act_medium  = '';
   my $stat_seer   = '';
   my $know_seer   = '';
   my $know_wisdom = '����E���킩��܂��B���b�́A��E�Ƃ͈Ⴂ�܂��B���̂��ߌ��Ђ̂����ԁA���Ђ̃X�p�C�A�V�l�~���[�^���g�𒼐ڌ������邱�Ƃ͂ł��܂���B';
   my $stat_droop  = '���Ȃ��ɌŒ肳�ꂽ���e�́A���������Ј��̐l���̓����ɋN�����܂��B�얳�B';
   my $stat_other  = '���Ȃ��́A���������ł͎s���Ƃ��Đ������܂��B';

   my @explain_gift = (
'',
'',
'<p>���Ȃ��͌��̗ւ�<A h//dais.kokage.cc/guide/e.jp/giji/?(Gift)GIFTID_LOST" TARGET="_blank">�r��</A>���܂����B<br>������ɂ��邱�Ƃ͂Ȃ��ł��傤�B�����A���̗ւ����Ȃ��̎�ɓn������A���̗ւ͏��������Ă��܂��܂��B�����āA���Ȃ�������ɋC�t�����Ƃ͂Ȃ��ł��傤�B</p>',
'<p></p>',
'',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_SHIELD" TARGET="_blank">���̗�</A>����芪���܂��B<br>���Ȃ��͂������A�P������Ă����Ƃ��Ă�����܂����B<br>���̗ւ͂ЂƂ����x�������܂���B�����n�������̗ւ��ӂ����т��Ȃ��̎�ɓn������A���̗ւ͏��������Ă��܂��܂��B���Ɍ���Ɏ����ׂ��ǂ��F��I�т܂��傤�B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_FINK" TARGET="_blank">���Ђ̂�����</A>�ł��B<br>���Ȃ��ɂ͎s���̑������^�����܂������A���Ȃ��͌��Ђ̖��@���܂����B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_OGRE" TARGET="_blank">���Ђ̃X�p�C</A>�ł��B<br>���Ȃ��ɂ͎s���̑������^�����܂������A���Ȃ��͌��Ђ̖��@���܂����B<br>'.$stat_wolf.'�܂��A'.$stat_wisper,'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_FAIRY" TARGET="_blank">�V�l�~���[�^���g</A>�ł��B<br>���Ȃ��ɂ͎s���̑������^�����܂������A�~���[�^���g�ł��������̂ł��I'.$stat_pixi.'</p>',
'',

'',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Gift)GIFTID_DECIDE" TARGET="_blank">�`�[�����[�_�[</A>�ł��B<br>���Ȃ��͒ǉ��[�𓊂��錠���������Â��܂��B�s�g���邱�ƂŁA���݂��������Ƃ��ł���ł��傤�B</p>',
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
'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ��ɂ�<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_VILLAGER" TARGET="_blank">���A����</A>���x������܂����ł��B<br>����Ȕ\�͂͂����Ă��܂���B�y�����ȁI</p>',
'<p></p>',
'<p></p>',
'<p>���Ȃ��ɂ�<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SYMPATHY" TARGET="_blank">�M����</A>���x������܂����B<br>'.$stat_fm.'<br>�����āA���Ȃ��͑��̎x���҂ƐM�����Œʘb���邱�Ƃ��ł��܂��B</p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_FAN" TARGET="_blank">�������I�t�B�T�[</A>�ł��B<br>���Ȃ������𗎂Ƃ��������A�s���B�͖\�͓I�ɂӂ������zap������ł��傤�B</p>',
'<p>���Ȃ��ɂ�<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_HUNTER" TARGET="_blank">�v���Y�}�E�L���m��</A>���x������܂����B<br>����A��l��t���_���܂��B<br>���Ȃ������𗎂Ƃ���ɁA���Ȃ��͂��Ɉ������������_�����l����'.$stat_kill.'</p>',
'<p>���Ȃ��ɂ�<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WEREDOG" TARGET="_blank">�A�X�x�X�g�E�A�[�}�[</A>���x������܂����B<br>���Ȃ��͏P�������Ə��𕉂����̂́A��������������炦�܂��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_PRINCE" TARGET="_blank">���E�тt�u�l</A>�ł��B<br>���Ȃ�����zap������邱�ƂɌ��܂�ƈ�x�����A���́�zap���͂Ƃ��߂ɂȂ�܂��B</p>',
'<p></p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p></p>',
'<p>���Ȃ��ɂ�<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_DYING" TARGET="_blank">�������e</A>���x������܂����B<br>'.$stat_droop.'</p>',
'<p></p>',
'<p></p>',
'<p>���Ȃ��ɂ�<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WITCH" TARGET="_blank">���`�d�c</A>���x������܂����B<br>���Ȃ��͓���ڈȍ~�A�����Ă���҂ɃV���b�N��^���ĎE�Q���邩�A���҂ɃV���b�N��^���đh�������܂��B�������A�E�Q�i���҂�I�ԁj�A�h���i���҂�I�ԁj�A�͂��ꂼ���x�����������Ȃ����Ƃ��ł��A��������葕�u�͉��Ă��܂��܂��B���u���g���ɂ͂��炩���ߏ�������̂ŁA�������V���b�L���O�Ȗ�ɑΏۂ̐������ω����Ă��A���\���ω��������ʂɎg���Ă��܂��ł��傤�B</p>',
'<p>���Ȃ��ɂ�<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_GIRL" TARGET="_blank">�w���X�R�[�v</A>���x������܂����B<br>���Ȃ��͓���ڈȍ~�A��ɏo�������Ƃ��ł��܂��B��▼�O�͂��Ȃ��ɂ͔���܂��񂪁A���Ђ̚����A���l�̔O�b�A�M�����̒ʘb�𕷂����Ⴄ���Ƃł��傤�B���������̂Ƃ��A�������Ȃ����A���Ђ́A�N���ЂƂ�ɂł��P������閵��Ɋ܂܂�Ă���ƁA���ۂɏP����]���҂Ƃ͕ʂɎ���ł��܂��܂��B���̎��S����q������@�͂���܂���B�܂��A����������邠�Ȃ���K�ڂɁA���Ј��B�͕ʂ̐l�����P������ł��傤�B</p>',
'<p>���Ȃ��͔߂���<A h//dais.kokage.cc/guide/e.jp/giji/?(Role)ROLEID_ELDER" TARGET="_blank">�X�P�[�v�S�[�g</A>�ł��B���C����������ݐs�����Ă��܂��܂����B<br>�������Y�̓��[���������ɂȂ�A���̂����̈�l�����Ȃ��ł������Ƃ��A���������s���B�ɏ��Y����Ă��܂��܂��B���Ȃ����Ō�Ɏw�������l�́A�������s���B�ɗ����A���Y�����ł��傤�B</p>',
'<p></p>',
'<p></p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p></p>',
'<p>���Ȃ��ɂ�<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SNATCH" TARGET="_blank">�����ȃR���p�N�g</A>���x������܂����B<br>�D���Ȑl���̊�Ɩ��O��D���A���g�̂���Ɠ���ւ��邱�Ƃ��ł��܂��B���̔\�͔͂��ɘI�����₷���̂ŁA�s�g�ɂ͒��ӂ��K�v�ł��B<br>��������̊ԂɎr�̂ɂȂ����l��ΏۂɑI�񂾂Ȃ�A�������Ȃ��͖��𗎂Ƃ��A���Ȃ��ł��邻�̎r�̂͑��𐁂��Ԃ��ł��傤�B�܂��A�J��A�M�҂ɂȂ������Ƃ͎p�ƂƂ��ɂ���A�p���ڂ��ւ����Ƃ��Ɉ����p�����Ƃ�����܂��B<br>���ꂩ��A������b���\�ł��B�ł���񂾂��āB<br>'.$stat_enemy.'</p>',
'<p>���Ȃ��͔O�g���l�̖���ł��B<br>������b���\�ł��B�ł���񂾂��āB<br>'.$stat_enemy.'</p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p></p>',
'<p></p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_MUPPETER" TARGET="_blank">�����V�X�e��</A>��D���܂����B<br>���Ȃ���_NPC_�̌����؂�A���t��`���邱�Ƃ��ł��܂��B<br>'.$stat_enemy.'</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WISPER" TARGET="_blank">���Ж���</A>���Ȃ��������Ă��܂��B<br>'.$stat_wisper.$stat_enemy.'���l���ɂȂ�Ə��s���m�肷��󋵂�����܂��A�ł������̏ꍇ�������ŏI�����邱�Ƃ͂���܂���B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_SEMIWOLF" TARGET="_blank">���Ђɓ���</A>���܂����B<br>���Ȃ����P�������ƃn�N�����A���Ȃ��͐���Č��ЂɌ}��������܂��B<br>'.$stat_enemy.'</p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_WOLF" TARGET="_blank">��F�̌���</A>�ɏ������Ă��܂��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p></p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_INTWOLF" TARGET="_blank">��F�̌���</A>�ɏ������Ă��܂��B<br>���Ԃ⎩������zap�������s����'.$know_wisdom.'<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'</p>',
'<p></p>',
'<p></p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_CHILDWOLF" TARGET="_blank">���Ј��̃A�C�h��</A>�ł��B<br>'.$stat_wolf.'�܂��A'.$stat_wisper.'���Ȃ������𗎂Ƃ��������A���Ђ͓�̏P���������Ȃ��A��l����x�ɎE�Q���܂��B</p>',
'<p></p>',
'<p></p>',
'<p></p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p></p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_TRICKSTER" TARGET="_blank">���Y�d��</A>(�~���[�^���g)�ł��B<br>���Y�d���͈���ځA�D���ȓ�l�Ɂg�^�����J�h�����т��鎖���ł��܂��B�g�^�����J�h�����񂾐l�́A�Е������S����ƌ��ǂ��Ď��S���܂��B���΂ꂽ�ނ�ɂƂ��ẮA�P�Ȃ�͂����f�Ȉ��Y�ɂ����܂���B<br>'.$stat_pixi.'</p>',

'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
'<p></p>',
'<p></p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_LOVER" TARGET="_blank">��q</A>�ł��B<br>����ځA�D���Ȑl�����t���Ƃ��đI�сA�g�^�����J�h�����т��A��q���肵�܂��B���̒��A���Ȃ����J�̎t���Ɠ�����E�ɂȂ��Ă���ł��傤�B�g�^�����J�h�����񂾓�l�́A�Е������S����ƌ��ǂ��Ď��S���܂��B<br></p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_ROBBER" TARGET="_blank">����</A>�ł��B<br>���Ȃ��́A�N���Ȃ�Ȃ������c���E�����ׂĒm��܂��B���̖�A���̒�����^���̓����܂܂ЂƂ̖�E��I�сA���ʂ̖�E�ɐ������ł��傤�B�^���́A���Ȃ��ɂȂɂ��ۂ��ł��傤���H</p>',
'<p></p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_LONEWOLF" TARGET="_blank">��C�T</A>�ł��B<br>���Ј��ł����A���̌��Ј��Ƃ͕ʌɏP�����A�s���⌋�Ј����E�Q���܂��B'.$stat_kill.'<br>����ɁA�P����͑��̌��Ј��ł����܂킸�A���Ȃ����g�́A���Ј��̏P����܋��҂̎�ɂ��E����邱�Ƃ͂���܂���B</p>',
'<p>���Ȃ���<A hr//dais.kokage.cc/guide/.jp/giji/?(Role)ROLEID_GURU" TARGET="_blank">�O���E�̋��c</A>�ł��B<br>���c�͖��ӂӂ��肸�A�D���Ȑl�����Ђ����ɗU�����ނ��Ƃ��ł��܂��B�������g��U�����Ƃ͂ł��܂���B<br>�U�����܂ꂽ���l�����͐M�҂ƂȂ��Ė�Ȗ�ȏ@���V���ɒ^��A���̂��Ƃ��o���Ă��܂��B�������A�ނ�̔\�͂⏊���w�c�Ȃǂɕω��͂���܂���B<br>�܂��A'.$stat_other.'</p>','<p></p>',
'<p></p>',
   );

   # ��E��]
   my %explain = (
      prologue => '���Ȃ���_SELROLE_����]���Ă��܂��B�������A��]�����ʂ�̔\�͎҂ɂȂ��Ƃ͌���܂���B',
      dead     => '���Ȃ���_ROLE_�ł����A���𗎂Ƃ��܂����B',
      mob      => '���Ȃ���<b>_ROLE_��<A h//dais.kokage.cc/guide/e.jp/giji/?(Role)ROLEID_MOB" TARGET="_blank">�����l</A></b>�ł��B���Ȃ��͏��s�Ɋ֗^�����A�����Ȃ�w�c�̐l���ɂ��܂܂�܂���B',
      epilogue => '���Ȃ���_ROLE_�ł����i_SELROLE_����]�j�B',
      explain_role  => \@explain_role,
      explain_gift  => \@explain_gift,
   );

   # ���[���\��
   my @votelabels = (
      '��zap��',
      '�ς˂�',
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
      '_NAME__RESULT_',
      '�� �l�� �̂悤���B',
      '�� �y���Ј��z�̂悤���B',
      '�� �y�\�͎҂ł͂Ȃ��z�悤���B',
      '�� �\�͎҂̂悤���B',
      '�� _ROLE_ �̂悤���B',
      '�𒲂ׂ邱�Ƃ��ł��Ȃ������B',
   );

   # �z���\����
   my %caption_roletable = (
      custom   => '���R�ݒ�',
   );

   # �A�N�V����
   my @actions = (
      '�ɂ������܂ꂽ�B',
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
      '�̑��������グ�āA���낶��`�����񂾁B',
      '�̑������w�������B�����ւ�A�n�ʂ�����܂����B',
      '�̓��𕏂ł��B',
      '�̍s�����A�ŐV�́u���t���ۂ��s�����X�g�v���猩���o�����B',
      '�̌C���ق���ЂƂȂ��قǂ��r�߉񂵂��B',
      '�̃`���R���[�g���ؗp�����B',
      '�Ǝ��p����R&D�̐V�����ɁA�`�]���������B',
      '�Ƃɂ��Ɣ��΂݂������B',
      '���瓦���o�����I�������A��荞�܂�Ă��܂����I',
   );

   my %textrs = (
      CAPTION => 'PARANOIA',
      HELP    => '�悤�����A�g���u���V���[�^�[�B�s���B�͐i�s���ȊO�̓N���[���ɂ��ꂽ��A�Z�L�����e�B�E�N���A�����X���ς����肵�܂��B<br>�I���ӁI�@��������̎s���̓N���[���ł͂���܂���B�������ɕʂ�������Ă����܂��傤�B�@�I���ӁI',
      FORCE_DEFAULT => 'custom',

      # �_�~�[�L�����̎Q���\���i����������Ă��܂����j�̗L��
      NPCENTRYMES => 0,

      # ���J�A�i�E���X
      ANNOUNCE_EXTENSION  => '����ɒB���Ȃ��������߁A���̍X�V������24���ԉ�������܂����B',
      ENTRYMES            => '_NAME_ ���Q�����܂����B',
      EXITMES             => '_NAME_�������悤�ȋC���������A�C�̂����������悤���c�c(_NAME_�͑����o�܂���)',
      SUDDENDEATH         => '_NAME_ �́A�ˑR�������B',
      SUICIDEBONDS        => '_NAME_ ���J�Ɉ���������悤�� _TARGET_ �̌��ǂ����B',
      SUICIDELOVERS       => '_NAME_ �͈����݂ɕ��� _TARGET_ �̌��ǂ����B',
      ANNOUNCE_RANDOMVOTE => '(�����_�����[)',
      ANNOUNCE_VICTORY    => '_VICTORY_�ł��I<br>',
      ANNOUNCE_EPILOGUE   => '_AVICTORY_�S�Ẵ��O�ƃ��[�U�[�������J���܂��B_DATE_ �܂Ŏ��R�ɏ������߂܂��̂ŁA����̊��z�Ȃǂ��ǂ����B',

      RANDOMENTRUST => '(�����_���ϔC)',

      # �\�͊֘A
      UNDEFTARGET     => '�i�p�X�j',
      RANDOMTARGET    => '�����_��',
      RANDOMROLE      => '�����_��', # ��E�����_����]
      NOSELROLE       => '�S�Ă̊�]�𖳎����A������^����B',
      SETRANDOMROLE   => 'COMPUTER�� _NAME_ �̖�E��]�� _SELROLE_ �Ɍ��߂��B',
      SETRANDOMTARGET => '_NAME_ �� _ABILITY_ �̑Ώۂ�_�ɔC�����B�_�� _TARGET_ �Ɍ��߂��B',
      CANCELTARGET    => '_NAME_ �� _ABILITY_ ���Ƃ��߂��B',
      EXECUTESEER     => '_NAME_ �́A_TARGET_ �������B',
      EXECUTEKILL     => '_TARGET_�I ���������O�̖������I',
      EXECUTEALCHEMIST=> '_NAME_ �́A�������݉������B',
      EXECUTEKILLWITCH=> '_NAME_ �́A_TARGET_ ���E�Q�����B',
      EXECUTELIVEWITCH=> '_NAME_ �́A_TARGET_ ��h���������B',
      EXECUTEGUARD    => '_NAME_ �́A_TARGET_ ������Ă���B',
      EXECUTEJAMM     => '_NAME_ �́A_TARGET_ ���B���Ă���B',
      EXECUTETRICKSTER=> '_NAME_ �́A_TARGET1_ �� _TARGET2_ �Ƃ̊Ԃɉ^�����J�����񂾁B',
      EXECUTELOVER    => '_NAME_ �́A_TARGET_ �Ƃ̊Ԃɉ^�����J�����񂾁B',
      EXECUTEGURU     => '_NAME_ �́A_TARGET_ ��U�����񂾁B',
      EXECUTESNATCH   => '_NAME_ �́A_TARGET_ �̎p��D�����B', 
      EXECUTEFAN      => '_NAME_ ���₵����蕶��́A�������ٗl�ȕ��͋C�ɕ�񂾁B', 
      EXECUTECHILDWOLF=> '_NAME_ �́A���ׂ����A���Ƃ��ꂽ�B', 
      EXECUTEGIRL     => '_NAME_ ���A�������肨�U�������悤���B',
      EXECUTEGIRLFEAR => '_NAME_ �́A���낵�����̂����Ă��܂����I',
      EXECUTETHROW    => '_NAME_ �́A_TARGET_ ��_GIFT_�������o�����B',
      EXECUTELOST     => '_NAME_ �ɂ́A_GIFT_�͓͂��Ȃ������c',
      EXECUTESHIELDBRK=> '_NAME_ �Ɍ��̗ւ��n����A�l�m�ꂸ�j�󂵂��B',
      RESULT_RIGHTWOLF=> '�l�T�̌����������悤���B<br>�i�T�����̂��Ȃ��́A�肢�t�ɐl�T�Ɣ��肳��܂��B�ł����A���Ȃ��͑��l�ŁA�����������ς��܂���B������ڎw���Ċ撣��܂��傤�B�j',
      RESULT_MEMBER   => '_NAME_ ����A _RESULT_ �̋C�z���������B',
      RESULT_FANATIC  => '_NAME_ ����A���Ј��̋C�z���������B',
      RESULT_BAT      => '_NAME_ ����A�d���̋C�z���������B',
      RESULT_GUARD    => '_TARGET_ ���P�����������B',
      RESULT_JAMM     => '_TARGET_ �̐��̂�肢�t����B�����B',
      RESULT_TRICKSTER=> '_TARGET1_ �� _TARGET2_ �Ƃ̊Ԃɉ^�����J�����񂾁B',
      RESULT_KILL     => '_TARGET_ ���E�Q�����B',
      RESULT_LIVE     => '_TARGET_ ��h�������B',
      RESULT_ALCHEMIST=> '���Ȃ��́A�������݉������B',
      RESULT_ELDER    => '���𕉂����B', 
      RESULT_WEREDOG  => '���𕉂����B���ƈ���̖����B', 
      RESULT_SEMIWOLF => '���Ј��Ɍ}����ꂽ�B',
      RESULT_LOVER    => '���Ȃ��� _TARGET_ �Ɖ^���𕪂��������܂����B',
      RESULT_LOVEE    => '_NAME_ ���A���Ȃ��Ɖ^���𕪂��������܂����B',
      RESULT_ROBBER   => '���Ȃ��͓������B<br>_ROLE_�A����I�сA���ʂ�Z���B',
      RESULT_DYING    => '���Ȃ��́A�������Ј���_NUMBER_���Ȃ獡��A���𗎂Ƃ��B',
      RESULT_GURU     => '_TARGET_ ��U�����񂾁B',
      RESULT_THROW    => '_TARGET_ ��_GIFT_�������o�����B',
      STATE_SHEEPS   => ' �x�苶�����A���ڂ낰�ȋL��������B',
      STATE_BONDS    => '���Ȃ��� _TARGET_ �Ɖ^�����J������ł��܂��B',
      STATE_BIND      => '���Ȃ��͂����A����\�͂��g�����Ƃ��ł��܂���B',
      STATE_BIND_ROLE => '���Ȃ��͂�����E�\�͂��g�����Ƃ��ł��܂���B',
      STATE_BIND_GIFT => '���Ȃ��͂������b�\�͂��g�����Ƃ��ł��܂���B',

      WIN_HUMAN       => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_HUMAN" TARGET="_blank">�s���w�c</A></b><br>�s���̐������Ђ̐��ȉ��ɂȂ�܂łɌ��Ђƃ~���[�^���g�i�d���j���S�ł���Ώ����ł��B<br>�������A���Ђ�S�ł��������_�Ń~���[�^���g�i�d���j�������c���Ă���Ɣs�k�ɂȂ�܂��B',
      WIN_WOLF        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_WOLF" TARGET="_blank">���Аw�c</A></b><br>���[���u�^�u���̐l�T�v�u���񂾂畉���v�uTrouble��Aliens�v�ł͐l��(�d����l�O�̎҂�����)�̐������ЂƓ����ȉ��܂Ō��点�΁A���[���u�~���[�Y�z���E�v�u�[�����̖�v�ł͔��A�������x�����ꂽ�s����S�ł�����Ώ����ł��B<br>�������A�Ō�܂Ń~���[�^���g�i�d���j�������c���Ă���Ɣs�k�ɂȂ�A���ɂ������珟����~���������̒B�����݂��܂��B',
      WIN_LONEWOLF    => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_LONEWOLF" TARGET="_blank">��C�T�w�c</A></b><br>���[���u�^�u���̐l�T�v�u���񂾂畉���v�uTrouble��Aliens�v�ł͎s��(�~���[�^���g������)�̐�����C�T�Ɠ����ȉ��܂Ō��点�΁A���[���u�~���[�Y�z���E�v�u�[�����̖�v�ł͔��A�������x�����ꂽ�s����S�ł����A���A���Аw�c�̌��Ј��������Ă��Ȃ���Ώ����ł��B<br>',
      WIN_PIXI        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_PIXI" TARGET="_blank">�d���w�c</A></b><br>���Ђ��S�ł��邩�A�s��(�~���[�^���g������)�̐������ЂƓ����ȉ��܂Ō���܂Łu�����c��΁v�����ł��B�������A�����珟����~���������̒B�����݂��܂��B',
      WIN_GURU        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_GURU" TARGET="_blank">���c</A></b><br>���c�ȊO�̐����҂��M�҂����ɂȂ�Ώ����ƂȂ�܂��B���c���g�́A�ŏI�I�ɐ����c���Ă��Ȃ��Ƃ��\���܂���B<br>�������A�����珟����~���������̒B�����݂��܂��B',
      WIN_EVIL        => '<b><A href="http://dais.kokage.cc/guide/?(Text)WIN_EVIL" TARGET="_blank">���؂�̐w�c</A></b><br>�s�����s�k����Ώ����ł��B�������A���l�����������ꍇ�͔s�k���܂��B<br>���Ȃ��Ə������Ƃ��ɂ���w�c�́A�ЂƂ����ł͂Ȃ���������܂���B',
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
      ANNOUNCE_SELROLE    => '_NAME_ �� _SELROLE_ �ɂȂ��悤�ACOMPUTER�ɋF�����B�i���̐l�ɂ͌����܂���j�B',
      ANNOUNCE_SETVOTE    => '_NAME_�́A_TARGET_ ����zap����ɑI�т܂����B',
      ANNOUNCE_SETENTRUST => '_NAME_�́A_TARGET_ �Ɂ�zap�����ϔC���܂����B',
      ANNOUNCE_SETTARGET  => '_NAME_�́A_TARGET_ ��\�́i_ABILITY_�j�̑ΏۂɑI�т܂����B',

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

      ANNOUNCE_WINNER_DISH => '�����āA�V�ɏ����ꂽ�������͂ƂĂ��ƂĂ��A�K�������ł����Ƃ��B',
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
