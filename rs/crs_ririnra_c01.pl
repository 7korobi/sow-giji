package SWResource_ririnra_c01;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # �\\����
  my @all = ('c49', 'c38', 'c77', 'c35', 'c53', 'c74', 'c50', 'c36', 'c26', 'c09', 'c55', 'c29', 'c12', 'c34', 'c44', 'c11', 'c10', 'c70', 'c56', 'c07', 'c41', 'c47', 'c58', 'c17', 'c39', 'c40', 'c65', 'c59', 'c57', 'c04', 'c46', 'c14', 'c42', 'c37', 'c75', 'c32', 'c33', 'c02', 'c66', 'c24', 'c79', 'c61', 'c23', 'c28', 'c68', 'c30', 'c21', 'c52', 'c51', 'c01', 'c69', 'c63', 'c05', 'c22', 'c62', 'c13', 'c18', 'c27', 'c08', 'c19', 'c71', 'c03', 'c43', 'c15', 'c54', 'c25', 'c20', 'c72', 'c105', 'c80', 'c96', 'c104', 'c106', 'c95', 'c108', 'c110', 'c97', 'c98', 'c100', 'c101', 'c112', 'c114', 'c115', 'c116', 'c117', 'c120', 'c123', 'c124', 'c125', 'c90', 'c88', 'c126', 'c127', 'c128', 'c129', 'c130', 'c131', 'c132', 'c133', 'c134', 'c135', 'c136', 'c137', 'c138', 'c139', 'c140', 'c141', 'c142', 'c143', 'c144', 'c145', 'c146', 'c16', 'c89', 'c84', 'c85', 'c91', 'c92', 'c93', 'c82', 'c78', 'c102', 'c121', 'c111', 'c94', 'c109', 'c64', 'c81', 'c73', 'c60', 'c67', 'c76', 'c107', 'c119', 'c87', 'c45', 'c122', 'c48', 'c118', 'c113', 'c86', 'c103', 'c83', 'c31', 'c99');
  my @giji = ('c49', 'c38', 'c77', 'c35', 'c53', 'c74', 'c50', 'c36', 'c26', 'c09', 'c55', 'c29', 'c12', 'c34', 'c44', 'c11', 'c10', 'c70', 'c56', 'c07', 'c41', 'c47', 'c58', 'c17', 'c39', 'c40', 'c65', 'c59', 'c57', 'c04', 'c46', 'c14', 'c42', 'c37', 'c75', 'c32', 'c33', 'c02', 'c66', 'c24', 'c79', 'c61', 'c23', 'c28', 'c68', 'c30', 'c21', 'c52', 'c51', 'c01', 'c69', 'c63', 'c05', 'c22', 'c62', 'c13', 'c18', 'c27', 'c08', 'c19', 'c71', 'c03', 'c43', 'c15', 'c54', 'c25', 'c20', 'c72', 'c105', 'c80', 'c96', 'c104', 'c106', 'c95', 'c108', 'c110', 'c97', 'c98', 'c100', 'c101', 'c112', 'c114', 'c115', 'c116', 'c117', 'c120', 'c123', 'c124', 'c125', 'c90', 'c88', 'c126', 'c127', 'c128', 'c129', 'c130', 'c131', 'c132', 'c133', 'c134', 'c135', 'c136', 'c137', 'c138', 'c139', 'c140', 'c141', 'c142', 'c143', 'c144', 'c145', 'c146', 'c16', 'c89', 'c84', 'c85', 'c91', 'c92', 'c93', 'c82', 'c78', 'c102', 'c121', 'c111', 'c94', 'c109', 'c64', 'c81', 'c73', 'c60', 'c67', 'c76', 'c107', 'c119', 'c87', 'c45', 'c122', 'c48', 'c118', 'c113', 'c86', 'c103', 'c83', 'c31', 'c99');
  my @G_a_k = ('c83', 'c140', 'c02', 'c29', 'c107', 'c142', 'c15', 'c102', 'c18', 'c87', 'c32', 'c98', 'c119', 'c89', 'c11', 'c43', 'c05', 'c77', 'c69', 'c52', 'c101', 'c66', 'c133', 'c131', 'c100', 'c20', 'c28', 'c90', 'c46', 'c38', 'c72', 'c62');
  my @G_s_t = ('c99', 'c81', 'c54', 'c127', 'c39', 'c105', 'c97', 'c113', 'c130', 'c76', 'c03', 'c111', 'c134', 'c65', 'c124', 'c37', 'c92', 'c53', 'c67', 'c10', 'c19', 'c35', 'c94', 'c23', 'c57', 'c07', 'c80', 'c50', 'c137', 'c34');
  my @G_n_h = ('c24', 'c103', 'c112', 'c21', 'c61', 'c129', 'c78', 'c31', 'c120', 'c71', 'c04', 'c85', 'c40', 'c12', 'c70', 'c55', 'c104', 'c09', 'c48', 'c75', 'c88', 'c125', 'c63', 'c144', 'c30', 'c123', 'c74', 'c122', 'c121', 'c58', 'c84', 'c108', 'c45', 'c146', 'c64', 'c135', 'c93', 'c08', 'c128', 'c47', 'c33', 'c86');
  my @G_m_w = ('c16', 'c115', 'c79', 'c36', 'c59', 'c01', 'c145', 'c116', 'c26', 'c95', 'c114', 'c41', 'c17', 'c141', 'c118', 'c68', 'c139', 'c51', 'c109', 'c42', 'c27', 'c110', 'c132', 'c117', 'c25', 'c96', 'c138', 'c14', 'c136', 'c126', 'c82', 'c13', 'c73', 'c22', 'c106');
  my %chrorder = (
    'all' => \@all,
    'giji' => \@giji,
    'G_a_k' => \@G_a_k,
    'G_s_t' => \@G_s_t,
    'G_n_h' => \@G_n_h,
    'G_m_w' => \@G_m_w,
  );

  my @tag_order = ('giji', 'G_a_k', 'G_s_t', 'G_n_h', 'G_m_w');
  my @order = ('c49', 'c38', 'c77', 'c35', 'c53', 'c74', 'c50', 'c36', 'c26', 'c09', 'c55', 'c29', 'c12', 'c34', 'c44', 'c11', 'c10', 'c70', 'c56', 'c07', 'c41', 'c47', 'c58', 'c17', 'c39', 'c40', 'c65', 'c59', 'c57', 'c04', 'c46', 'c14', 'c42', 'c37', 'c75', 'c32', 'c33', 'c02', 'c66', 'c24', 'c79', 'c61', 'c23', 'c28', 'c68', 'c30', 'c21', 'c52', 'c51', 'c01', 'c69', 'c63', 'c05', 'c22', 'c62', 'c13', 'c18', 'c27', 'c08', 'c19', 'c71', 'c03', 'c43', 'c15', 'c54', 'c25', 'c20', 'c72', 'c105', 'c80', 'c96', 'c104', 'c106', 'c95', 'c108', 'c110', 'c97', 'c98', 'c100', 'c101', 'c112', 'c114', 'c115', 'c116', 'c117', 'c120', 'c123', 'c124', 'c125', 'c90', 'c88', 'c126', 'c127', 'c128', 'c129', 'c130', 'c131', 'c132', 'c133', 'c134', 'c135', 'c136', 'c137', 'c138', 'c139', 'c140', 'c141', 'c142', 'c143', 'c144', 'c145', 'c146', 'c16', 'c89', 'c84', 'c85', 'c91', 'c92', 'c93', 'c82', 'c78', 'c102', 'c121', 'c111', 'c94', 'c109', 'c64', 'c81', 'c73', 'c60', 'c67', 'c76', 'c107', 'c119', 'c87', 'c45', 'c122', 'c48', 'c118', 'c113', 'c86', 'c103', 'c83', 'c31', 'c99');


  # �L�����̌�����
  my %chrjob = (
    'c01' => '�Ԕ���',
    'c02' => '����',
    'c03' => '���K����t',
    'c04' => '����',
    'c05' => '�a�l',
    'c07' => '�G�݉�',
    'c08' => '�{��',
    'c09' => '�h�q',
    'c10' => '����',
    'c100' => '�k��',
    'c101' => '��`��',
    'c102' => '�w����',
    'c103' => '�}����',
    'c104' => '������',
    'c105' => '�����q',
    'c106' => '����',
    'c107' => '����',
    'c108' => '�̏W�l',
    'c109' => '����',
    'c11' => '���m',
    'c110' => '�낭�łȂ�',
    'c111' => '���l',
    'c112' => '����',
    'c113' => '�R',
    'c114' => '�v����',
    'c115' => '�p�i���',
    'c116' => '���S��',
    'c117' => '�h��',
    'c118' => '�n���D',
    'c119' => '�M�k',
    'c12' => '���',
    'c120' => '��t',
    'c121' => '�_��',
    'c122' => '�r�[���z��',
    'c123' => '�X�C�E�l',
    'c124' => '���ؐl',
    'c125' => '������',
    'c126' => '�o��',
    'c127' => '��s��',
    'c128' => '�����H',
    'c129' => '�z��^��',
    'c13' => '�x�e������t',
    'c130' => '�ٖ���',
    'c131' => '�R�t',
    'c132' => '����H',
    'c133' => '���Œc',
    'c134' => '����',
    'c135' => '�����l',
    'c136' => '���эH',
    'c137' => '�b��',
    'c138' => '�㎷�M',
    'c139' => '�D����',
    'c14' => '���̑���',
    'c140' => '������',
    'c141' => '�D�Y�̂�',
    'c142' => '�͐�w�k',
    'c143' => '�ƒ닳�t',
    'c144' => '���O�ϑ�',
    'c145' => '���Y�w',
    'c146' => '�ٖ{��',
    'c15' => '�X�։�',
    'c16' => '�H������V',
    'c17' => '���l',
    'c18' => '�x�e�����Ō�w',
    'c19' => '������',
    'c20' => '�ǉƂ̖�',
    'c21' => '����',
    'c22' => '�S��',
    'c23' => '�`���t',
    'c24' => '���V',
    'c25' => '�ǉƂ̑��q',
    'c26' => '�y��E�l',
    'c27' => '�q�l',
    'c28' => '�Ǐ���',
    'c29' => '�L��',
    'c30' => '���g��',
    'c31' => '���b���',
    'c32' => '�o����',
    'c33' => '�o����',
    'c34' => '�C����',
    'c35' => '�e��',
    'c36' => '����E',
    'c37' => '�t��',
    'c38' => '�̂���',
    'c39' => '�d���ĉ�',
    'c40' => '����',
    'c41' => '�����炢�l',
    'c42' => '�|���v',
    'c43' => '�X��',
    'c44' => '�����}',
    'c45' => '���k',
    'c46' => '����',
    'c47' => '���Q��',
    'c48' => '��Ύ��W��',
    'c49' => '�΍H',
    'c50' => '��v�m',
    'c51' => '���',
    'c52' => '��x',
    'c53' => '��n��',
    'c54' => '�����t',
    'c55' => '�Ǖw',
    'c56' => '����',
    'c57' => '�C����',
    'c58' => '�i��',
    'c59' => '�C���m',
    'c60' => '�ǉƂ̖���',
    'c61' => '�ނ�t',
    'c62' => '�����V',
    'c63' => '�Y���H',
    'c64' => '��r�炵',
    'c65' => '�n����',
    'c66' => '�g����',
    'c67' => '�X��',
    'c68' => '�q��̎�',
    'c69' => '���p��',
    'c70' => '�q���',
    'c71' => '���ē�',
    'c72' => '�����^���E�l',
    'c73' => '������',
    'c74' => '�x���',
    'c75' => '�t��',
    'c76' => '�����',
    'c77' => '�n����',
    'c78' => '�����t',
    'c79' => '���V�̑�',
    'c80' => '���',
    'c81' => '��',
    'c82' => '�������K��',
    'c83' => '��t',
    'c84' => '��',
    'c85' => '���g��',
    'c86' => '������',
    'c87' => '�a�l',
    'c88' => '�����l',
    'c89' => '�V��',
    'c90' => '���Ђ�',
    'c91' => '����w',
    'c92' => '����w',
    'c93' => '����w',
    'c94' => '����l',
    'c95' => '�V���z�B',
    'c96' => '�w��',
    'c97' => '�{����',
    'c98' => '�T��',
    'c99' => '�}����',
    $maker => '�V�̂�����',
    $admin => '�ł̙ꂫ',
  );

  # �L�����̖��O
  my %chrname = (
    'c01' => '���A���[',
    'c02' => '�A���t���b�h',
    'c03' => '�X�e�B�[�u��',
    'c04' => '�m�[���[��',
    'c05' => '�L���T����',
    'c07' => '�e�B���V�[',
    'c08' => '�x�l�b�g',
    'c09' => '�q���V',
    'c10' => '�]�[�C',
    'c100' => '�O���b�O',
    'c101' => '�N�����b�T',
    'c102' => '�E�H�[����',
    'c103' => '�i���V�[',
    'c104' => '�q���[',
    'c105' => '�V���I��',
    'c106' => '�����_',
    'c107' => '�C���H��',
    'c108' => '�u���[����',
    'c109' => '���f�B�X�����@',
    'c11' => '�J�����B��',
    'c110' => '���[',
    'c111' => '�X�[�W�[',
    'c112' => '�j�R���X',
    'c113' => '�W�F���~�[',
    'c114' => '�����h',
    'c115' => '�}���I',
    'c116' => '������',
    'c117' => '���p�[�g',
    'c118' => '���[�W��',
    'c119' => '�I�[�����A',
    'c12' => '�o�[�i�o�X',
    'c120' => '�m�A',
    'c121' => '�u�b�J',
    'c122' => '�t���[��',
    'c123' => '�t�F���[',
    'c124' => '�Z�C���Y',
    'c125' => '�s�X�e�B�I',
    'c126' => '���C�G',
    'c127' => '�U�[�S',
    'c128' => '�y�g��',
    'c129' => '�k���B��',
    'c13' => '���~�I',
    'c130' => '�W���[�f�B��',
    'c131' => '�O�X�^�t',
    'c132' => '���C��',
    'c133' => '�N���X�e�t',
    'c134' => '�Y�b�e��',
    'c135' => '�w�U�[',
    'c136' => '���i�[�^',
    'c137' => '�f���N�\\��',
    'c138' => '���b�N�X',
    'c139' => '�����b�N',
    'c14' => '���e�B�[�V��',
    'c140' => '�A���T���[��',
    'c141' => '�����J�[',
    'c142' => '�E�B����',
    'c143' => '�{�C�h',
    'c144' => '�s��',
    'c145' => '�����b�T',
    'c146' => '�w�C',
    'c15' => '�E�F�[�Y���[',
    'c16' => '�}���A���k',
    'c17' => '�����V�[�Y',
    'c18' => '�G�}',
    'c19' => '�^�o�T',
    'c20' => '�O�����A',
    'c21' => '�j�[��',
    'c22' => '���b�g',
    'c23' => '�`���[���Y',
    'c24' => '�i�^���A',
    'c25' => '���[�J�X',
    'c26' => '���j�J',
    'c27' => '�����_',
    'c28' => '�P�C�g',
    'c29' => '�C�A��',
    'c30' => '�t�B���b�v',
    'c31' => '�l��',
    'c32' => '�I�X�J�[',
    'c33' => '�z���[',
    'c34' => '�g�j�[',
    'c35' => '�_��',
    'c36' => '�~�b�V�F��',
    'c37' => '�Z�V��',
    'c38' => '�R���[��',
    'c39' => '�V�r��',
    'c40' => '�n���[�h',
    'c41' => '���j�N',
    'c42' => '�����t',
    'c43' => '�K�X�g��',
    'c44' => '�h�i���h',
    'c45' => '�v���V��',
    'c46' => '�Q�C��',
    'c47' => '�y���W�[',
    'c48' => '�r�A���J',
    'c49' => '�{���X',
    'c50' => '�f�B�[��',
    'c51' => '���[�����_',
    'c52' => '�M���A��',
    'c53' => '�[���_',
    'c54' => '�U�b�N',
    'c55' => '�p�s����',
    'c56' => '�S�h�E�B��',
    'c57' => '�c�F�c�B�[����',
    'c58' => '�u���[�m',
    'c59' => '���p���s�X',
    'c60' => '�|�[�`�����J',
    'c61' => '�k�}�^���E',
    'c62' => '���F��',
    'c63' => '�s�b�p',
    'c64' => '�w�N�^�[',
    'c65' => '�Y���G��',
    'c66' => '�N���X�g�t�@�[',
    'c67' => '�\\�t�B�A',
    'c68' => '���A�q��',
    'c69' => '�M�l�X',
    'c70' => '�p�e�B',
    'c71' => '�m�b�N�X',
    'c72' => '���F�X�p�^�C��',
    'c73' => '���[�Y�}���[',
    'c74' => '�t�����V�X�J',
    'c75' => '�r���[',
    'c76' => '�W���[�W',
    'c77' => '�L�������C�i',
    'c78' => '�l�C�T��',
    'c79' => '�}�[�S',
    'c80' => '�e�b�h',
    'c81' => '�T�C���X',
    'c82' => '���r��',
    'c83' => '�A�C���X',
    'c84' => '�u�����_',
    'c85' => '�n�i',
    'c86' => '�z���[�V���[',
    'c87' => '�G���A�X',
    'c88' => '�s�G�[��',
    'c89' => '�J�g���[�i',
    'c90' => '�P���B��',
    'c91' => '�h���V�[',
    'c92' => '�Z���X�g',
    'c93' => '�x�b�L�[',
    'c94' => '�_�[��',
    'c95' => '�����X',
    'c96' => '���I�i���h',
    'c97' => '�W�F�t',
    'c98' => '�I�Y�����h',
    'c99' => '�T�C����',
    $maker    => '�i�����Đl�j',
    $admin    => '�i�Ǘ��l�j',
  );

  # �_�~�[�L�����̔���
  my @npcsay =(
    "���̓��ɊG�{��������Ă���A���q�l�Ƃ̈����𖲌��Ă͏������߂Ă����B<br>���i�[�^���߂܂��������l���܂��܂�������ǁA�������̉��q�l�͂����Ɠ����̂ɂ����ЂƁB<br><br>�[���j�E�������h���M�Ōq���āB�����͉ԏ��莝���Ă������I",
    "���߂�ˁA�{���̗����������Ȃ���������B<br><br>�ӂ��肾���̋L�O���ɑ҂����킹<br>���j���̗[�Ă��ɖj����߂Č��ߍ���<br>�̌�����̖��D���A�N�Ɛ����Ă����������̂��グ������Ȃ��Y�ق�<br><br>�ԏ���Ƀc�c�W��Y���āA�����͊�蓹���Ă����́B",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => '�l�T�c���i���A���[�j',
    NPCID          => 'c01',
    TAG_ORDER      => \@tag_order,
    CHRORDER       => \%chrorder,
    CHRNAME        => \%chrname,
    CHRJOB         => \%chrjob,
    ORDER          => \@order,
    NPCSAY         => \@npcsay,
    IMGFACEW       => 90,
    IMGFACEH       => 130,
    IMGBODYW       => 90,
    IMGBODYH       => 130,
    DIR            => "$sow->{'cfg'}->{'DIR_IMG'}/portrate",
    EXT            => '.jpg',
    BODY           => '',
    FACE           => '',
    GRAVE          => '',
    EXPRESSION     => \@expression,
    LAYOUT_NAME    => 'right',
  );

  return \%charset;
}

1;