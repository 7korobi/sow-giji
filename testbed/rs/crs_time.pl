package SWResource_time;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};

  # �L�����̕\����
  my @order = (
    'c10',  # c10  ���e���� �]�[�C 
    't01',  # t01  �F���g�� �`�A�L ���������鏭��
    't02',  # t02  �K�^�̉Ȋw ���b�L�B �Ăւ̔�
    't03',  # t03  FSM�c �~�i�J�^ �[�m�[
    't04',  # t04  �B���� �J�C�� �T���E�R�i�[�E�N���j�N���Y
    't05',  # t05  �J���I�s�� �W�F�j�t�@�[ �o�b�N�E�g�D�E�U�E�t���[�`���[
  );

  # �L�����̌�����
  my %chrjob = (
    'c10' => '���e����',  # c10  ���e���� �]�[�C 
    't01' => '�F���g��',  # t01  �F���g�� �`�A�L ���������鏭��
    't02' => '�K�^�̉Ȋw',  # t02  �K�^�̉Ȋw ���b�L�B �Ăւ̔�
    't03' => 'FSM�c',  # t03  FSM�c �~�i�J�^ �[�m�[
    't04' => '�B����',  # t04  �B���� �J�C�� �T���E�R�i�[�E�N���j�N���Y
    't05' => '�J���I�s��',  # t05  �J���I�s�� �W�F�j�t�@�[ �o�b�N�E�g�D�E�U�E�t���[�`���[
    $maker => '����X���R���s���[�^�[',
    $admin => '��l�̕ǂ̐[��',
  );

  # �L�����̖��O
  my %chrname = (
    'c10' => '�]�[�C',   # c10  ���e���� �]�[�C 
    't01' => '�`�A�L',   # t01  �F���g�� �`�A�L ���������鏭��
    't02' => '���b�L�B',   # t02  �K�^�̉Ȋw ���b�L�B �Ăւ̔�
    't03' => '�~�i�J�^',   # t03  FSM�c �~�i�J�^ �[�m�[
    't04' => '�J�C��',   # t04  �B���� �J�C�� �T���E�R�i�[�E�N���j�N���Y
    't05' => '�W�F�j�t�@�[',   # t05  �J���I�s�� �W�F�j�t�@�[ �o�b�N�E�g�D�E�U�E�t���[�`���[
    $maker    => '�i�����Đl�j',
    $admin    => '�i�Ǘ��l�j',
  );

  # �_�~�[�L�����̔���
  my @npcsay =(
    "M4���C�t���������Ă�������΁c�A�ȁ[��āA�v���ĂĂ����傤���Ȃ��ˁB�������Ƃ����B",
    "����ς��A�e���������P�l�����Ȃ��Ƃ��B<br><br>������Əo�����Ă���I�v�����H�ׂ���_������I",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => '�G�N�X�p���V�����E�Z�b�g�u�A�Ҏҋc���v',
    NPCID          => 'c10',
    CHRNAME        => \%chrname,
    CHRJOB         => \%chrjob,
    ORDER          => \@order,
    NPCSAY         => \@npcsay,
    IMGFACEW       => 90,
    IMGFACEH       => 130,
    IMGBODYW       => 90,
    IMGBODYH       => 130,
    DIR            => "$sow->{'cfg'}->{'DIR_IMG'}/portrate/",
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
