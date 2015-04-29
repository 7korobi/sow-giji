package SWResource_ger;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # �\\����
  my @asia = ('g05', 'g02', 'g01', 'g03', 'gc61', 'g04', 'g06', 'g07', 'g08');
  my %chrorder = (
    'asia' => \@asia,
  );

  my @tag_order = ('asia');
  my @order = ('g05', 'g02', 'g01', 'g03', 'gc61', 'g04', 'g06', 'g07', 'g08');


  # �L�����̌�����
  my %chrjob = (
    'g01' => '�O�����m',
    'g02' => '���ߌ�',
    'g03' => '�������m',
    'g04' => '�S�ӘZ����',
    'g05' => '�{�����m',
    'g06' => '�������',
    'g07' => '���j�q',
    'g08' => '�n��',
    'gc61' => '�ނ�t',
    $maker => '�n���Ղ̒�',
    $admin => '�ł̙ꂫ',
  );

  # �L�����̖��O
  my %chrname = (
    'g01' => '�I��',
    'g02' => '�u��',
    'g03' => '���u',
    'g04' => '�U�|',
    'g05' => '����',
    'g06' => '�o�F',
    'g07' => '�W����',
    'g08' => '�C����',
    'gc61' => '�����Y',
    $maker    => '�i�����Đl�j',
    $admin    => '�i�Ǘ��l�j',
  );

  # �_�~�[�L�����̔���
  my @npcsay =(
    "�܂����c�c����́c�c�H<br><br>�^��������������I<br>�����o���炷���A�[�̊F�ɒm�点�Ȃ��ƁI",
    "��Ԃ��c���Ă�c�c<br>�������c�Ă��Ă�c�c<br><br>�I�@�Ȃ񂾁A�L���c�c�B���ǂ����Ȃ��ł�B<br>��H",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => '�G�N�X�p���V�����E�Z�b�g�u�嗤�c���v',
    NPCID          => 'g03',
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
