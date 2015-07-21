package SWResource_mad;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # �\\����
  my @all = ('mad03', 'c103', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08', 'mad09', 'mad10', 'mad11');
  my @marchen = ('mad03', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08', 'mad09', 'mad10', 'mad11');
  my %chrorder = (
    'all' => \@all,
    'marchen' => \@marchen,
  );

  my @tag_order = ('marchen');
  my @order = ('mad03', 'c103', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08', 'mad09', 'mad10', 'mad11');


  # �L�����̌�����
  my %chrjob = (
    'c103' => '�}����',
    'c83' => '���ǂ�',
    'mad01' => '����',
    'mad02' => '�a�˕���',
    'mad03' => '�I�X����',
    'mad04' => '�_���T��',
    'mad05' => '�V���J��',
    'mad06' => '�B���V',
    'mad07' => '�������t',
    'mad08' => '�ώ��̐���',
    'mad09' => '�אȍ���',
    'mad10' => '�ǉ��T��',
    'mad11' => '���s�C',
    $maker => '�V��̒���',
    $admin => '�ł̙ꂫ',
  );

  # �L�����̖��O
  my %chrname = (
    'c103' => '�i���V�[',
    'c83' => '�A�C���X',
    'mad01' => '�f���e��',
    'mad02' => '�G���S�b�g',
    'mad03' => '�V�[�V��',
    'mad04' => '�h���x��',
    'mad05' => '���w�C',
    'mad06' => '�A�����X�J',
    'mad07' => '�_�C�~',
    'mad08' => '�G�t�F�h��',
    'mad09' => '�J�i�r�X',
    'mad10' => '���O��',
    'mad11' => '�I���M�A',
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
