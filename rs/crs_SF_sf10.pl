package SWResource_SF_sf10;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # �\\����
  my @all = ('sf01', 'sf02', 'sf03', 'sf04', 'sf05', 'sf06', 'sf025', 'sf07', 'sf08', 'sf09', 'sf10', 'sf11', 'sf12', 'sf13', 'sf18', 'sf19', 'sf14', 'sf15', 'sf16', 'sf17', 'sf20', 'sf021', 'sf023', 'sf024', 'sf026', 'sf022', 'sf027', 'sf032', 'sf028', 'sf029', 'sf030', 'sf031');
  my @stratos = ('sf01', 'sf02', 'sf03', 'sf04', 'sf05', 'sf06', 'sf025', 'sf07', 'sf08', 'sf09', 'sf10', 'sf11', 'sf12', 'sf13', 'sf18', 'sf19', 'sf14', 'sf15', 'sf16', 'sf17', 'sf20', 'sf021', 'sf023', 'sf024', 'sf026', 'sf022', 'sf027', 'sf032', 'sf028', 'sf029', 'sf030', 'sf031');
  my %chrorder = (
    'all' => \@all,
    'stratos' => \@stratos,
  );

  my @tag_order = ('stratos');
  my @order = ('sf01', 'sf02', 'sf03', 'sf04', 'sf05', 'sf06', 'sf025', 'sf07', 'sf08', 'sf09', 'sf10', 'sf11', 'sf12', 'sf13', 'sf18', 'sf19', 'sf14', 'sf15', 'sf16', 'sf17', 'sf20', 'sf021', 'sf023', 'sf024', 'sf026', 'sf022', 'sf027', 'sf032', 'sf028', 'sf029', 'sf030', 'sf031');


  # �L�����̌�����
  my %chrjob = (
    'sf01' => '�ʐM�m',
    'sf02' => '�N�w��',
    'sf021' => '���Ԕ���',
    'sf022' => '�z��n��',
    'sf023' => '�n���O��',
    'sf024' => '���ʊy�c',
    'sf025' => '�~����',
    'sf026' => '����ē�',
    'sf027' => '�z��c��',
    'sf028' => '�n�ڋZ�t',
    'sf029' => '�@�I�E�R',
    'sf03' => '���ē�',
    'sf030' => '���Ǘ�',
    'sf031' => '�ӏ����`',
    'sf032' => '�z��n��',
    'sf04' => '���U������',
    'sf05' => '�V���i',
    'sf06' => '�m��',
    'sf07' => '�V�j��',
    'sf08' => '������',
    'sf09' => '���C��',
    'sf10' => '�ۈ��Z�t',
    'sf11' => '����',
    'sf12' => '�p�_',
    'sf13' => '���h����',
    'sf14' => '�Ζʔ̔�',
    'sf15' => '�E�ґ�',
    'sf16' => '�ی�����',
    'sf17' => '�H��',
    'sf18' => '�����q',
    'sf19' => '�����q',
    'sf20' => '���ʎm',
    $maker => '�d�ˍ����L�̃��j�^���ϊ�',
    $admin => '���̕��˂̃G���F���b�g����',
  );

  # �L�����̖��O
  my %chrname = (
    'sf01' => '���b�V�[�h',
    'sf02' => '�G�X�y�����g',
    'sf021' => '�A���^���X',
    'sf022' => '�`�F�r�C',
    'sf023' => '�G�t',
    'sf024' => '�A�C���C�g',
    'sf025' => '�A�}���e�A',
    'sf026' => '�|�[��',
    'sf027' => '���X�L�[�g',
    'sf028' => '�R�[�^',
    'sf029' => '�~�c�{�V',
    'sf03' => '�s�[�g',
    'sf030' => '�N���p�X�L���[��',
    'sf031' => '�V���N',
    'sf032' => '���N���o',
    'sf04' => '�A�V���t',
    'sf05' => '���i���U',
    'sf06' => '�������`�i',
    'sf07' => '�����t�@',
    'sf08' => '�o�i',
    'sf09' => '�L���V�}',
    'sf10' => '�i���^',
    'sf11' => '�C���m�t',
    'sf12' => '�����V�t�F����',
    'sf13' => '�g���h���B��',
    'sf14' => '�N���X�}�X',
    'sf15' => '�W�F�[���X',
    'sf16' => '���C�W',
    'sf17' => '�W���b�N',
    'sf18' => '��x',
    'sf19' => '�Q�x',
    'sf20' => '�e�B�\\',
    $maker    => '�i�����Đl�j',
    $admin    => '�i�Ǘ��l�j',
  );

  # �_�~�[�L�����̔���
  my @npcsay =(
    "f*ck�I�܂��`�I�`�������Ɠ�_���Y�f���������I<br>�G�A�R�����R���^�~�邵�X�^�O�邵f*ck'n�I�[�����̋G�߂����A�K���^�C�g���T�N���_�C�g��f*ck'n�������[���c<br><br><b>���� ��������<br>�@����_���B�������Ɍ��N�ɉe���͂Ȃ����A�C�ߍ��c</b>",
    "��[f*ck'n���܂���B<br>�}�W�����B�G���@���Ăł����P�O�~�L�Y�������B�N�����H<br>�}�W�{��ˁ[����肥����<br><br><b>�Ղ�</b><br><br>���ƁB�u������c�Bf*ck�B<br>������ƊO�̗l�q���Ă���B���̃v�����c���Ƃ��Ă����B<br>",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => '������ւ̓��W�i�i���^�j',
    NPCID          => 'sf10',
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
