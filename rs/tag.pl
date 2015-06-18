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
    'marchen' => '‹¶‘›‹c–',
    'kid' => '(™“¶)',
    'young' => '(áÒ)',
    'middle' => '(’†”N)',
    'elder' => '(˜Vl)',
    'river' => '-‰^‰Í-',
    'road' => '-‰—ˆ-',
    'immoral' => '-— “¹-',
    'guild' => '-¤H‰ï-',
    'elegant' => '-•‘“¥‰ï-',
    'ecclesia' => '-Œö‹³‰ï-',
    'medical' => '-{—Ã‰@-',
    'market' => '-‰ÌŒ€ğê-',
    'apartment' => '-©º‚Ì‘‹-',
    'servant' => '-g—pl-',
    'farm' => '-X‚Ì”_ê-',
    'government' => '-“¡Œö‹¤-',
    'god' => '-‚©‚İ‚³‚Ü-',
  );  

  my %tagset = (
    TAG_NAME       => \%tag_name,
  );

  return \%tagset;
}

1;
