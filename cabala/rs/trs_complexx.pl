package SWTextRS_complexx;

sub GetTextRS {
   my ($sow)=@_;
   require "$sow->{'cfg'}->{'DIR_RS'}/trs_all.pl";
   my $textrs = &SWTextRS_all::GetTextRS($sow);

   my @announce_first = (
      '_HOUR_���̃j���[�X�ł��B<br>��F�̑g�D���e���Ȃ�R���s���[�^�[�E_NPC_��j�󂷂邽����݂������Ă���ƁA�����ق�<ruby>IntSec<rt>�Ђ݂�������</ruby>�����炩�ɂ��܂����B<ruby>�P��<rt>����؂�</ruby>�Ȏs���͂��݂₩�ɏ���ً̋}���ꏊ�֏W�܂�܂��傤�B<br><br>��ςȎ��Ԃł��ˁB�閧���ЂƂ����ƁA���O���U��������A<ruby>Power<rt>���񂵂�傭</ruby>�����ۂ���Ƃ�������s���m���Ă��܂����c�c',
      '_HOUR_���̃j���[�X�ł��B<br><ruby>R&D<rt>���񂫂イ����</ruby>�́A���Б΍R�[�u�̈�Ƃ��ĐV�������J�����܂����B<br><ruby>�P��<rt>����؂�</ruby>�Ȏs����<ruby>PLC<rt>�͂����イ����</ruby>���瑕������́A<ruby>�t�B�[���h�e�X�g��<rt>���߂��ɂ����Ă݂�</ruby>�A���Ђ𔭌����܂��傤�B<br><br>�x���i�̋@����<ruby>�P��<rt>����؂�</ruby>�ɊǗ�����Ă���̂ŁA�������点�Ȃ����Ƃł��ˁB���̃j���[�X�B<ruby>�S�V�S�V�{�b�g<rt>squeeze bot</ruby>�ʎY�H��ŁA��ʂ̃`���R���[�g���c�c',
      '_HOUR_���̃j���[�X�ł��B<br>��関���A<ruby>�|�{��<rt>�ق�������</ruby>���P�����󂯂܂����B_NPC_���j�󂳂�A�N���[���ƋL���̔��~�͎����܂����B<br>���̃N���[���͂ȂɂЂƂ��܂���邱�Ƃ��ł��Ȃ��̂ŁA��������́�zap����<sub>�u�c��</sub><br><b>�i���ׂẴj���[�X�E�`�����l���͒��ق��A�V��͐^���Âɏ��������B�j</b><br><br>�����ĐÎ�̒��A�N���������o���܂��B��������́A��zap���͈���ЂƂ�ɐ������悤�B���������������A�䖝����񂾁B',
   );

   # ���Y���̂��m�点
   my @announce_vote =(
      '<b>_NAME_</b>��<b>_TARGET_</b>�Ƀ��[�U�[�E�K�����������B_RANDOM_',
      '<b>_NAME_</b>��<b>_COUNT_�l</b>�����[�U�[�E�K�����������B',
      '<b>_NAME_</b>�͎s���̎�ɂ��<b>��zap��</b>���ꂽ�B',
      '<b>_NAME_</b>��<b>��zap��</b>����ɂ͈؂ꑽ�������̂ŁA����߂��B',
      '<b>_NAME_</b>�͎s���̎�ɂ��<b>��zap��</b>���ꂽ�B�Ō��<b>_TARGET_</b>���w�����āc�c�B',
   );
   # �ϔC���[�̂��m�点
   my @announce_entrust = (
      '<b>_NAME_</b>��<b>��zap��</b>���ϔC���Ă��܂��B_RANDOM_',
      '<b>_NAME_</b>��<b>��zap��</b>���ϔC���悤�Ƃ��܂������A�����s�\�ł����B_RANDOM_',
   );

   # �R�~�b�g
   my @announce_commit = (
      '<b>_NAME_</b>������i�߂邱�Ƃ���߂��B',
      '<b>_NAME_</b>�͎����i�ނ悤�A�V��𑀍삵���B',
   );
   my %status_live = (
      live       =>  '������',
      executed   =>  '<b>��zap��</b>',
      victim     =>  '�P����',
      cursed     =>  '���f��',
      droop      =>  '���Ԃ���',
      suicide    =>  '��ǂ�',
      feared     =>  '���|��',
      suddendead =>  '�ˑR��',
   );
   my @announce_winner = (
      '�S�Ă̐l�������������A����ވ�؂��Ȃ������`�h�͂₪�āA�l����̂��~�߂��B',
      '��F�̑g�D�͑S�ł����c�c�B�u�l�T�v�ɋ�������X�͋������̂��I���킳�����߂����Љ�C���t���́A�ڊo�����X�s�[�h�ŕ����v���i�߂Ă����B����Complex�͂��܂����ł��傤�B',
      '�s���B�͎���̉߂��ɋC�t�����B<br>���Ђ̎c�}�͍Ō�̔j�󊈓����ς܂���ƁA�Ԃ̍L������݂����̂��B�n���V���[�I���u�I',
      '�s���B�͋C�t���Ă��܂����B�����^�������K�v�Ȃ�ĂȂ����ƂɁB<br>�y�ɍ������낵�A���Ƌ��ɐ����悤�B��Ƌ��ɓ~���z���A���Ƌ��ɏt�����������B�c�₪�ēd�r���s���ʂĂ�܂ŁB',
      '�S�Ă̌��Ј���ގ������c�c�B<br>�����A���󂵂��R���v���b�N�X�͖߂�Ȃ��B<br>�y�ɍ������낵�A���Ƌ��ɐ����悤�B��Ƌ��ɓ~���z���A���Ƌ��ɏt�����������B�c�₪�ēd�r���s���ʂĂ�܂ŁB',
      '���̎��A�u�l�T�v�͏������m�M���A�����ď��߂ĉ߂��ɋC�Â����B�������񂾑������܂��A�����Ďg�����ɂȂ�Ȃ����ƂɁB<br>�y�ɍ������낵�A���Ƌ��ɐ����悤�B��Ƌ��ɓ~���z���A���Ƌ��ɏt�����������B�c�₪�ēd�r���s���ʂĂ�܂ŁB',
      '�s���B�́A�����āu�l�T�v������̉߂��ɋC�t�����B�}�͂���Ȃ钳����𑗂荞��ł����̂��B<br>�������ЂƂ�́u�l�T�v�͍Ō�̔j�󊈓����ς܂���ƁA�Ԃ̍L������݂����B�̂���҂���Ȃ��A�W�R�ƋP���L����B',
      '�s�����A�u�l�T�v���A�~���[�^���g�ł������A���l�����̑O�ł͖��͂ł����B<br>�K���Ō�Ɉ��͏��̂ł��B�Ƃ���ň����Ĉ��������H',
      '�^���͂������Ƃ肾����I�񂾁B���ׂĂ����߂����Ƃ���̂����A���E�́A�i���ɋ���ɐ����r��镗��́A����ɒ���ł����c�c�B',
      '�S�Ă̐l�������������A����ވ�؂��Ȃ������`�h�͂₪�āA�l����̂��~�߂��B',
   );

   # ���[���\��
   my @votelabels = (
      '<b>��zap��</b>',
      '�ς˂�',
   );

   $textrs->{'CAPTION'}       = 'ParanoiA';
   $textrs->{'HELP'}          = '�R���s���[�^�[���K���̂����ɓ�������u�S������v�̃Z�b�g�ł��B���ׂĂ̖�E�A���b�A�������y���ނ��Ƃ��ł��܂��B<br><br>�悤�����A�g���u���V���[�^�[�B�s���B�͐i�s���ȊO�̓N���[���ɂ��ꂽ��A�Z�L�����e�B�E�N���A�����X���ς����肵�܂��B<br>�I���ӁI�@��������̎s���̓N���[���ł͂���܂���B�������ɕʂ�������Ă����܂��傤�B�@�I���ӁI';

   $textrs->{'ANNOUNCE_COMMIT'}  = \@announce_commit;
   $textrs->{'ANNOUNCE_ENTRUST'} = \@announce_entrust;
   $textrs->{'ANNOUNCE_FIRST'}   = \@announce_first;
   $textrs->{'ANNOUNCE_SELROLE'} = '<b>_NAME_</b>�� _SELROLE_ �ɂȂ��悤�A�R���s���[�^�[�ɘd�G��U�荞�񂾁B�i���̐l�ɂ͌����܂���j�B';
   $textrs->{'ANNOUNCE_VOTE'}    = \@announce_vote;
   $textrs->{'ANNOUNCE_WINNER'}  = \@announce_winner;
   $textrs->{'VOTELABELS'}       = \@votelabels;


   return $textrs;
}

1;
