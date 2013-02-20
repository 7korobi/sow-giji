package SWResource_mad;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};

  # �L�����̕\����
  my @order = (
    'mad01',  # mad01  ���� �f���e�� ���ЌA���炫�܂���
    'mad02',  # mad02  �a�˕��� �G���S�b�g ���ЌA���炫�܂���
    'mad03',  # mad03  �I�X���� �V�[�V�� ���ЌA���炫�܂���
    'mad04',  # mad04  �_���T�� �h���x�� ���ЌA���炫�܂���
    'mad05',  # mad05  �V���J�� ���w�C ���ЌA���炫�܂���
    'mad06',  # mad06  �B���V �A�����X�J ���ЌA���炫�܂���
    'c83',  # c83  ���ǂ� �A�C���X 
    'c103',  # c103  �}���� �i���V�[ �N���J�E���g�_�E����
  );

  # �L�����̌�����
  my %chrjob = (
    'c103' => '�}����',  # c103  �}���� �i���V�[ �N���J�E���g�_�E����
    'c83' => '���ǂ�',  # c83  ���ǂ� �A�C���X 
    'mad01' => '����',  # mad01  ���� �f���e�� ���ЌA���炫�܂���
    'mad02' => '�a�˕���',  # mad02  �a�˕��� �G���S�b�g ���ЌA���炫�܂���
    'mad03' => '�I�X����',  # mad03  �I�X���� �V�[�V�� ���ЌA���炫�܂���
    'mad04' => '�_���T��',  # mad04  �_���T�� �h���x�� ���ЌA���炫�܂���
    'mad05' => '�V���J��',  # mad05  �V���J�� ���w�C ���ЌA���炫�܂���
    'mad06' => '�B���V',  # mad06  �B���V �A�����X�J ���ЌA���炫�܂���
    $maker => '�V��̒���',
    $admin => '�ł̙ꂫ',
  );

  # �L�����̖��O
  my %chrname = (
    'c103' => '�i���V�[',   # c103  �}���� �i���V�[ �N���J�E���g�_�E����
    'c83' => '�A�C���X',   # c83  ���ǂ� �A�C���X 
    'mad01' => '�f���e��',   # mad01  ���� �f���e�� ���ЌA���炫�܂���
    'mad02' => '�G���S�b�g',   # mad02  �a�˕��� �G���S�b�g ���ЌA���炫�܂���
    'mad03' => '�V�[�V��',   # mad03  �I�X���� �V�[�V�� ���ЌA���炫�܂���
    'mad04' => '�h���x��',   # mad04  �_���T�� �h���x�� ���ЌA���炫�܂���
    'mad05' => '���w�C',   # mad05  �V���J�� ���w�C ���ЌA���炫�܂���
    'mad06' => '�A�����X�J',   # mad06  �B���V �A�����X�J ���ЌA���炫�܂���
    $maker    => '�i�����Đl�j',
    $admin    => '�i�Ǘ��l�j',
  );

  # �_�~�[�L�����̔���
  my @npcsay =(
    "�ǂ����A�E������݂�ȁB�c�݂��<br><br><br>/* ���˂΂����̂� */",
    "�P�l�ɂȂ�̂쎄�΂����B�ǂ����̓����I��ł��A<br>����\\���ł��B�������҂��ĂĂˁB���肢������A<br>����čs���Ȃ��ŁH<br>���܂ł��A<br>�Ȃ�Ŏ��΂���<br><br><b>���L�͂����œr�؂�A���������܂őł��̂Ă��Ă����B</b>",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => '�G�N�X�p���V�����E�Z�b�g�u�����c���v',
    NPCID          => 'c83',
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
