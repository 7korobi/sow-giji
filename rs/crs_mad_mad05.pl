package SWResource_mad_mad05;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # �\\����
  my @all = ('mad03', 'c103', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08');
  my @marchen = ('mad03', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08');
  my %chrorder = (
    'all' => \@all,
    'marchen' => \@marchen,
  );

  my @tag_order = ('marchen');
  my @order = ('mad03', 'c103', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08');


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
    $maker    => '�i�����Đl�j',
    $admin    => '�i�Ǘ��l�j',
  );

  # �_�~�[�L�����̔���
  my @npcsay =(
    "�c����B�����ȁA�����Ԃ܂����B<br>�؉ƏZ�܂��ł��A�V�������āA�J���Ă��邩����荞��ł݂��񂾁B<br><br>���\\�L���Ă��B���ցA���ցA�����i��ł��疾���肪�؂�Ă��B<br>�����E�������킩��Ȃ����Ă����c�B�K���ɖ\\�ꂽ��A���邢�Ƃ��ɏo���B<br><br>�m��Ȃ��X�������B",
    "�c����B��������B<br>�܂��A���̊X����o���Ȃ��񂾁B���܂������āA�����Ȃ񂾂낤�H<br><br>���[�A�������B����A�����������H<br>�������̐�͂܂���J���ĂȂ���������˂���H<br>�E�P�b�A�E�P�b�A�E�P�R�b�A�E�R�P�A�E�R�P�A�E�q���z�A�R�P�R�P�R�P�I",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => '�G�N�X�p���V�����E�Z�b�g�u�����c���v�i���w�C�j',
    NPCID          => 'mad05',
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
