package SWResource_TAG;

#----------------------------------------
# �L�����N�^�[�^�O
#----------------------------------------

sub GetTag {
  # �^�O�̖��O
  my %tag_name = (
    'all' => '���ׂ�',
    'giji' => '�l�T�c��',
    'shoji' => '�Ă��ł�',
    'travel' => '�A�Ҏҋc��',
    'stratos' => '������ւ̓��W',
    'myth' => '�͂����̂Ђ��',
    'asia' => '�嗤�c��',
    'marchen' => '�����c��',
    'kid' => '(����)',
    'young' => '(���)',
    'middle' => '(���N)',
    'elder' => '(�V�l)',
    'river' => '-�^��-',
    'road' => '-����-',
    'immoral' => '-����-',
    'guild' => '-���H��-',
    'elegant' => '-������-',
    'ecclesia' => '-������-',
    'medical' => '-�{�É@-',
    'market' => '-�̌�����-',
    'apartment' => '-�����̑�-',
    'servant' => '-�g�p�l-',
    'farm' => '-�X�̔_��-',
    'government' => '-��������-',
    'god' => '-���݂���-',
  );  

  my %tagset = (
    TAG_NAME       => \%tag_name,
  );

  return \%tagset;
}

1;
