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
    'fable' => '�������E',
    'marchen' => '�����c��',
    'G_a_k' => '���`��',
    'G_s_t' => '���`��',
    'G_n_h' => '�ȁ`��',
    'G_m_w' => '�܁`��',
    'T_a_k' => '���`��',
    'T_s_n' => '���`��',
    'T_h_w' => '�́`��',
    'kid' => '����',
    'young' => '���',
    'middle' => '���N',
    'elder' => '�V�l',
    'river' => '�^��',
    'immoral' => '����',
    'road' => '����',
    'servant' => '�g�p�l',
    'guild' => '���H��',
    'ecclesia' => '������',
    'office' => '������',
    'elegant' => '������',
    'medical' => '�{�É@',
    'farm' => '�X�̔_��',
    'market' => '�̌�����',
    'apartment' => '�����̑�',
    'government' => '��������',
    'commercism' => '���v',
    'explorism' => '����',
    'faith' => '�M��',
    'activitism' => '�]��',
    'militalism' => '����',
    'rulerism' => '�x�z',
    'anarchism' => '����',
    'artism' => '�\\��',
    'policism' => '�ۈ�',
    'god' => '���݂���',
  );  

  my %tagset = (
    TAG_NAME       => \%tag_name,
  );

  return \%tagset;
}

1;
