package SWTextRS_star;

sub GetTextRS {
   my ($sow)=@_;
   require "$sow->{'cfg'}->{'DIR_RS'}/trs_all.pl";
   my $textrs = &SWTextRS_all::GetTextRS($sow);

   my @announce_first = (
      '��X���ɋ������j�ł̉��ɋN������A�s���ɋ��ꂽ��q�����͏W��ւƏW�܂����B�P���Ȓ��ڒʐM�̋@�\�����ʂ����Ȃ��Ȃ����g�т��g���āB',
      '���M�@�͍쓮���Ȃ��B�~���ɂ͉�����������B���ꂪ���_�������B<br>����̂Ȃ��w�͂�s���������ɁA�N�����������󋵂𗝉����A���݂͎���̎g���ɖڊo�߂��B�������A���m�̐����́g�l�T�h�́A�m���ɂ��̒��ɂ���̂��B<br>�����A�l�ԂȂ�G�ł���l�T��ގ����悤�B�l�T�Ȃ�c�c���ςɐU�镑���Đl�Ԃ������m���Ɏd���߂Ă����̂��B',
      '�������G�l���M�[������ꂽ���A�l�T�ɑ΍R���邽�߂ɏ�q�����͈�̃��[�����߂��B���[�ɂ��������҂������������o�����ƁB�F�����ЂƂł͖��̕ۏ؂��Ȃ����A�������ނ𓾂Ȃ��Ɓc�c�B',
   );

   # �P�����ʃ��b�Z�[�W
   my @announce_kill = (
      '���͗����B��q�B�͏W�܂�A�݂��̎p���m�F����B',
      '�]���҂͂��Ȃ��悤���B',
      '<b>_TARGET_</b>�̎p��������Ȃ��B',
   );

   # �����҂̂��m�点
   my @announce_lives = (
      '���݂̏�q�́A',
      '�A',
      '��<b>_LIVES_��</b>�B',
   );

   # ���Y���̂��m�点
   my @announce_vote =(
      '<b>_NAME_</b>��<b>_TARGET_</b>�ɓ��[�����B_RANDOM_',
      '<b>_NAME_</b>��<b>_COUNT_�l</b>�����[�����B',
      '<b>_NAME_</b>�͏�q�̎�ɂ�蓊�����ꂽ�B',
      '<b>_NAME_</b>�𓊊�����ɂ͈؂ꑽ�������̂ŁA����߂��B',
      '<b>_NAME_</b>�͏�q�̎�ɂ�蓊�����ꂽ�B�Ō��<b>_TARGET_</b>���w�����āc�c�B',
   );

   my @announce_winner = (
      '�S�Ă̐l�����������������A�����Ɏc��͈̂�̉��H<br>�₪�āA����ވ�؂��Ȃ������`�h�́A�l����̂��~�߂��B',
      '�S�Ă̐l�T��ގ������c�c�B�l�T�ɋ�������X�͋������̂��I���킳�����߂����C���t���͖ڊo�����X�s�[�h�ŕ����v���i�߂Ă����B�₪�ċ~���̒ʐM�������A�F������ɕ������낤�B',
      '��q�B�͎���̉߂��ɋC�t�����B<br>�l�T�B�͍Ō�̎d�����ς܂���ƏW������Ƃɂ����B�V���ȋ]���҂́A�������܂ŗ��Ă���B',

      '��q�B�͋C�t���Ă��܂����B�����^�������K�v�Ȃ�ĂȂ����ƂɁB<br>�l���T���֌W�Ȃ��A���̂悤�Ȑ������n�܂�B�c�₪�ĔR���d�r���s���ʂĂ�܂ŁA����͊m���ɍK���������̂��B',
      '�S�Ă̐l�T��ގ������c�c�B<br>�����A�����ɕ������l�X�́A�^�̏����ҁc�c�d���Ə̂���m���̂ɁA�Ō�܂ŋC�t�����Ƃ͂Ȃ������c�c�B�����āA',
      '���̎��A�l�T�͏������m�M���A�����ď��߂ĉ߂��ɋC�Â����B<br>�������A�d���Ə̂���m���̂𓢂��R�炵���l�T�ɂ́A�ő��Ȃ����ׂ��Ȃ������c�c�B�����āA',

      '��q�B�́A�����Đl�T�B������̉߂��ɋC�t�����B<br>�ǓƂȈ�C�T�͍Ō�̎d�����ς܂���ƏW������Ƃɂ����B�������܂ŗ��Ă���V���ȋ]���҂����߂āB',
      '���l���A�l�T���A�d���ł������A���l�����̑O�ł͖��͂ł����B<br>�K���Ō�Ɉ��͏��̂ł��B',
      '�^���͂������Ƃ肾����I�񂾁B���ׂĂ����߂����Ƃ���̂����A���E�́A�i���ɋ���ɐ����r��鑾�z���̉���ɒ���ł����c�c�B',

      '�S�Ă̐l�����������������A�����Ɏc��͈̂�̉��H<br>�₪�āA����ވ�؂��Ȃ������`�h�́A�l����̂��~�߂��B',
   );

   $textrs->{'CAPTION'}       = 'Orbital��Star';
   $textrs->{'HELP'}          = '���ׂĂ̖�E�A���b�A�������y���ނ��Ƃ��ł��܂��B�܂��A�i�s���ȊO�̓N���[���ɂ��ꂽ��A�Z�L�����e�B�E�N���A�����X���ς����肵�܂��B<br>�F������ɓ˓������u�S������v�̃Z�b�g�ł��B���������̂͌k�J�⍂���ł͂Ȃ��A���f���т�ږ��D�A�O���G���x�[�^�[�̓r���ɂ���ł��傤�B�������n�܂�܂ł́A�ƂĂ��[�������ߑ�I�ȃC���t���������Ă����̂ł����c�c';

   $textrs->{'EXPLAIN'}->{'dead'} = '���Ȃ��͓�������Ă��܂��܂����B';

   $textrs->{'ANNOUNCE_FIRST'}   = \@announce_first;
   $textrs->{'ANNOUNCE_KILL'}    = \@announce_kill;
   $textrs->{'ANNOUNCE_LIVES'}   = \@announce_lives;
   $textrs->{'ANNOUNCE_VOTE'}    = \@announce_vote;
   $textrs->{'ANNOUNCE_WINNER'}  = \@announce_winner;


   $textrs->{'EXECUTEKILL'}      = '<b>_TARGET_</b>�c�c�A������I�I';
   $textrs->{'EXECUTEKILLWITCH'} = '<b>_NAME_</b>�́A<b>_TARGET_</b>�𓊊������B';
   $textrs->{'EXECUTELIVEWITCH'} = '<b>_NAME_</b>�́A<b>_TARGET_</b>����������B';
   $textrs->{'RESULT_ZOMBIE'}    = '<b>_TARGET_</b>��<b>����</b>�ɂ����B';
   $textrs->{'RESULT_KILL'}      = '<b>_TARGET_</b>��<b>����</b>�����B';
   $textrs->{'RESULT_LIVE'}      = '<b>_TARGET_</b>��<b>���</b>�����B';
   $textrs->{'EXECUTEALCHEMIST'} = '<b>_NAME_</b> �́A����ȃJ�v�Z���ɉ���������B';
   $textrs->{'RESULT_ALCHEMIST'} = '���Ȃ��́A����ȃJ�v�Z���ɉ���������B';
   $textrs->{'RESULT_DYING'}     = '���Ȃ��́A�����l�T��<b>_NUMBER_��</b>�Ȃ獡��A��э~��Ȃ��Ă͂Ȃ�Ȃ��B';
   $textrs->{'RESULT_SCAPEGOAT'} = '�W���̑����ɂ�������炸�A<b>_TARGET_</b>�͊��Ă�ꂽ�B���̏�ɋ��Ȃ��҂��A�������߂͂��Ȃ������B';

   $textrs->{'ANNOUNCE_SELROLE'} = '<b>_NAME_</b>��_SELROLE_�ɂȂ��悤�A�R���s���[�^�[�ɘd�G��U�荞�񂾁B�i���̐l�ɂ͌����܂���j�B';


   return $textrs;
}

1;
