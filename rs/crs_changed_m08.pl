package SWResource_changed;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # �\\����
  my @all = ('m99', 'm07', 'm13', 'm06', 'm03', 'm05', 'm15', 'r30', 'm01', 'm02', 'm04', 'b44', 'm08', 'b49', 'm09', 'm10', 'm11', 'm12', 'm14', 'm16', 'm18', 'm19', 'm20');
  my @myth = ('m99', 'm07', 'm13', 'm06', 'm03', 'm05', 'm15', 'r30', 'm01', 'm02', 'm04', 'b44', 'm08', 'b49', 'm09', 'm10', 'm11', 'm12', 'm14', 'm16', 'm18', 'm19', 'm20');
  my %chrorder = (
    'all' => \@all,
    'myth' => \@myth,
  );

  my @tag_order = ('myth');
  my @order = ('m99', 'm07', 'm13', 'm06', 'm03', 'm05', 'm15', 'r30', 'm01', 'm02', 'm04', 'b44', 'm08', 'b49', 'm09', 'm10', 'm11', 'm12', 'm14', 'm16', 'm18', 'm19', 'm20');


  # �L�����̌�����
  my %chrjob = (
    'b44' => '�������Ƃ�',
    'b49' => '������',
    'm01' => '�悤����',
    'm02' => '�悤����',
    'm03' => '���傤����',
    'm04' => '�����݂�',
    'm05' => '�͂���',
    'm06' => '���イ�Ă�����',
    'm07' => '���Ђ�',
    'm08' => '���ӂ���̂���',
    'm09' => '���[���[',
    'm10' => '����ۂ�����',
    'm11' => '�_���R�m',
    'm12' => '�Í��R�m',
    'm13' => '�����t',
    'm14' => '��Ղ̎q',
    'm15' => '�т���',
    'm16' => '��イ���ւ�',
    'm18' => '�L���̗d��',
    'm19' => '���Ђ߂���',
    'm20' => '���ڂ�',
    'm99' => '���݂���',
    'r30' => '�ЂƂÂ���',
    $maker => '�L��̂�����',
    $admin => '�ł̙ꂫ',
  );

  # �L�����̖��O
  my %chrname = (
    'b44' => '�h�i���h',
    'b49' => '�{���X',
    'm01' => '�P���V',
    'm02' => '�|�v��',
    'm03' => '�g�m�T�}',
    'm04' => '�A�I�C',
    'm05' => '�i�i�R��',
    'm06' => '��������',
    'm07' => '�A���X',
    'm08' => '�����ς�',
    'm09' => '�J�~�W���[',
    'm10' => '�A�`���|',
    'm11' => '���C�g�j���O',
    'm12' => '�g���j�g�X',
    'm13' => '�~�P',
    'm14' => '�J�����N�X',
    'm15' => '�~�\\�`��',
    'm16' => '�A�[�T�[',
    'm18' => '�~�[��',
    'm19' => '�^���g',
    'm20' => '�V���R��',
    'm99' => '�p���b�N',
    'r30' => '�g��',
    $maker    => '�i�����Đl�j',
    $admin    => '�i�Ǘ��l�j',
  );

  # �_�~�[�L�����̔���
  my @npcsay =(
    "����낤�H<br>����ȂȂ܂��̂��A����������c�c",
    "�����A�ڂ��₽����������Ⴂ�B���͂�̂������B",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => '�Ƃ̂��܍L��',
    NPCID          => 'm08',
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