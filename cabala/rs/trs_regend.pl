package SWTextRS_regend;

sub GetTextRS {
   my ($sow)=@_;
   require "$sow->{'cfg'}->{'DIR_RS'}/trs_all.pl";
   my $textrs = &SWTextRS_all::GetTextRS($sow);

   # �A�N�V����
   my @actions = (
    '�ɑ��Â���ł����B',
    '�ɋ������B',
    '�ɋ������B',
    '�ɏƂꂽ�B',
    '���������B',
    '�ɍ��f�����B',
    '�Ɋ��ӂ����B',
    '�ɔ��΂񂾁B',
    '�ɔ��肵���B',
    '�Ɏ��U�����B',
    '�Ɏ���X�����B',
    '�ɂ����V�������B',
    '�ɂނ��イ�����B',
    '�ɕʂ���������B',
    '�ɂЂǂ����낽�����B',
    '�ɂ�������ׁ[�������B',
    '�ɃN���N�V������炵���B',
    '�ɋނ�Řd�G�������o�����B',
    '�Ƃɂ��Ɣ��΂݂������B',
    '�ւ̑O����P�񂵂��B',
    '���瓦���o�����I�������A��荞�܂�Ă��܂����I',
    '�������ƌ��߂��B',
    '��M���̖ڂŌ����B',
    '�����b�����Ɍ����B',
    '��s�M�̖ڂŌ����B',
    '���w�������B',
    '���������B',
    '���x�������B',
    '���Ԃ߂��B',
    '���Ԃ߂�U��������B',
    '�������Y���ɂ����B',
    '����̔ޕ��ɂԂ���΂����B',
    '��������߂��B',
    '�����ꎞ�Ԗ₢�߂��B',
    '�̓��𕏂ł��B',
    '�Ƀ^���C�𗎂Ƃ����B',
    '���n���Z���ŉ������B',
    '�̃`���R���[�g���ؗp�����B',
   );

   $textrs->{'CAPTION'}       = '�c�����`��';
   $textrs->{'HELP'}          = '���ׂĂ̖�E�A���b�A�������y���ނ��Ƃ��ł���A�u�S������v�̃Z�b�g�ł��B�A�N�V�������e�͉����ɂȂ�A�����I�ł��΂炵���N���[�������܂���B';

   $textrs->{'ACTIONS'}        = \@actions;
   delete $textrs->{'ACTIONS_CLEARANCE_UP'};
   delete $textrs->{'ACTIONS_CLEARANCE_DOWN'};
   delete $textrs->{'ACTIONS_CLEARANCE_NG'};
   delete $textrs->{'ACTIONS_ZAP'};
   delete $textrs->{'ACTIONS_ZAPCOUNT'};

   return $textrs;
}

1;
