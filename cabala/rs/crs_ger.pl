package SWResource_ger;

#----------------------------------------
# �L�����Z�b�g
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};

  # �L�����̕\����
  my @order = (
    'g01',  # g01  �O�����m �I�� ����������
    'g02',  # g02  ���ߌ� �W�� ��p�j���� �z��̖��O���T�������������A������ʁc
    'g03',  # g03  �������m ���u ���A��
    'gc61',  # gc61  �ނ�t �����Y ���A��
  );

  # �L�����̌�����
  my %chrjob = (
    'g01' => '�O�����m',  # g01  �O�����m �I�� ����������
    'g02' => '���ߌ�',  # g02  ���ߌ� �W�� ��p�j���� �z��̖��O���T�������������A������ʁc
    'g03' => '�������m',  # g03  �������m ���u ���A��
    'gc61' => '�ނ�t',  # gc61  �ނ�t �����Y ���A��
    $maker => '�n���Ղ̒�',
    $admin => '�ł̙ꂫ',
  );

  # �L�����̖��O
  my %chrname = (
    'g01' => '�I��',   # g01  �O�����m �I�� ����������
    'g02' => '�W��',   # g02  ���ߌ� �W�� ��p�j���� �z��̖��O���T�������������A������ʁc
    'g03' => '���u',   # g03  �������m ���u ���A��
    'gc61' => '�����Y',   # gc61  �ނ�t �����Y ���A��
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