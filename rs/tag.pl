package SWResource_TAG;

#----------------------------------------
# �L�����N�^�[�^�O
#----------------------------------------

sub GetTag {
  # �^�O�̖��O
  my %tag_name = (
    'shoji' => '�Ă��ł�',
    'travel' => '�A�Ҏҋc��',
    'stratos' => '������ւ̓��W',
    'myth' => '�͂����̂Ђ��',
    'asia' => '�嗤�c��',
    'marchen' => '�����c��',
    'elegant' => '-������-',
    'guild' => '-���H��-',
    'road' => '-�^�͉���-',
    'apartment' => '-�����̑�-',
    'farm' => '-�X�̔_��-',
    'servant' => '-�g�p�l-',
    'medical' => '-�{�É@-',
    'market' => '-���y�X�E�\\-',
    'immoral' => '-���y�X�E��-',
    'law' => '-�@�̎x�z-',
    'ecclesia' => '-������-',
    'god' => '-���݂���-',
    'all' => '���ׂ�',
  );  

  my %tagset = (
    TAG_NAME       => \%tag_name,
  );

  return \%tagset;
}

1;
