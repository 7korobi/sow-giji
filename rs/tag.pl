package SWResource_TAG;

#----------------------------------------
# ƒLƒƒƒ‰ƒNƒ^[ƒ^ƒO
#----------------------------------------

sub GetTag {
  # ƒ^ƒO‚Ì–¼‘O
  my %tag_name = (
    'shoji' => '‚Ä‚â‚ñ‚Å‚¦',
    'travel' => '‹AŠÒÒ‹c–',
    'stratos' => '–¾Œã“ú‚Ö‚Ì“¹•W',
    'myth' => '‚Í‚¨‚¤‚Ì‚Ğ‚ë‚Î',
    'asia' => '‘å—¤‹c–',
    'marchen' => '‹¶‘›‹c–',
    'elegant' => '-•‘“¥‰ï-',
    'guild' => '-¤H‰ï-',
    'road' => '-‰^‰Í‰—ˆ-',
    'apartment' => '-©º‚Ì‘‹-',
    'farm' => '-X‚Ì”_ê-',
    'servant' => '-g—pl-',
    'medical' => '-{—Ã‰@-',
    'market' => '-Š½ŠyŠXE•\\-',
    'immoral' => '-Š½ŠyŠXE— -',
    'law' => '-–@‚Ìx”z-',
    'ecclesia' => '-Œö‹³‰ï-',
    'god' => '-‚©‚İ‚³‚Ü-',
    'all' => '‚·‚×‚Ä',
  );  

  my %tagset = (
    TAG_NAME       => \%tag_name,
  );

  return \%tagset;
}

1;
