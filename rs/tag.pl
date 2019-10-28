package SWResource_TAG;

#----------------------------------------
# ƒLƒƒƒ‰ƒNƒ^[ƒ^ƒO
#----------------------------------------

sub GetTag {
  # ƒ^ƒO‚Ì–¼‘O
  my %tag_name = (
    'all' => '‚·‚×‚Ä',
    'giji' => 'l˜T‹c–',
    'shoji' => '‚Ä‚â‚ñ‚Å‚¦',
    'travel' => '‹AŠÒÒ‹c–',
    'stratos' => '–¾Œã“ú‚Ö‚Ì“¹•W',
    'myth' => '‚Í‚¨‚¤‚Ì‚Ğ‚ë‚Î',
    'asia' => '‘å—¤‹c–',
    'fable' => 'Œ¶“ú¢ŠE',
    'marchen' => '‹¶‘›‹c–',
    'G_a_k' => '‚ `‚±',
    'G_s_t' => '‚³`‚Æ',
    'G_n_h' => '‚È`‚Ù',
    'G_m_w' => '‚Ü`‚ğ',
    'T_a_k' => '‚ `‚±',
    'T_s_n' => '‚³`‚Ì',
    'T_h_w' => '‚Í`‚ğ',
    'kid' => '™“¶',
    'young' => 'áÒ',
    'middle' => '’†”N',
    'elder' => '˜Vl',
    'river' => '‰^‰Í',
    'immoral' => '— “¹',
    'road' => '‰—ˆ',
    'servant' => 'g—pl',
    'guild' => '¤H‰ï',
    'ecclesia' => 'Œö‹³‰ï',
    'office' => '––±Š',
    'elegant' => '•‘“¥‰ï',
    'medical' => '{—Ã‰@',
    'farm' => 'X‚Ì”_ê',
    'market' => '‰ÌŒ€ğê',
    'apartment' => '©º‚Ì‘‹',
    'government' => '“¡Œö‹¤',
    'commercism' => 'û‰v',
    'explorism' => '‹“¹',
    'faith' => 'M‹Â',
    'activitism' => '—]‰É',
    'militalism' => '•—Í',
    'rulerism' => 'x”z',
    'anarchism' => '”½­',
    'artism' => '•\\Œ»',
    'policism' => '•ÛˆÀ',
    'god' => '‚©‚İ‚³‚Ü',
  );  

  my %tagset = (
    TAG_NAME       => \%tag_name,
  );

  return \%tagset;
}

1;
