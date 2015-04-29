package SWResource_ger;

#----------------------------------------
# キャラセット
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # 表\示順
  my @asia = ('g05', 'g02', 'g01', 'g03', 'gc61', 'g04', 'g06', 'g07', 'g08');
  my %chrorder = (
    'asia' => \@asia,
  );

  my @tag_order = ('asia');
  my @order = ('g05', 'g02', 'g01', 'g03', 'gc61', 'g04', 'g06', 'g07', 'g08');


  # キャラの肩書き
  my %chrjob = (
    'g01' => '三元道士',
    'g02' => '白鶴拳',
    'g03' => '吹牛方士',
    'g04' => '心意六合拳',
    'g05' => '本草方士',
    'g06' => '宝飾交易',
    'g07' => 'お針子',
    'g08' => '馬鹿',
    'gc61' => '釣り師',
    $maker => '馬頭琴の調',
    $admin => '闇の呟き',
  );

  # キャラの名前
  my %chrname = (
    'g01' => '露蝶',
    'g02' => '志偉',
    'g03' => '芙蓉',
    'g04' => '攻芸',
    'g05' => '麻雀',
    'g06' => '黍炉',
    'g07' => 'ジリヤ',
    'g08' => 'イワン',
    'gc61' => '沼太郎',
    $maker    => '（村建て人）',
    $admin    => '（管理人）',
  );

  # ダミーキャラの発言
  my @npcsay =(
    "まさか……これは……？<br><br>真相が分かったわ！<br>日が出たらすぐ、麓の皆に知らせないと！",
    "飛車が…壊れてる……<br>葛橋が…焼けてる……<br><br>！　なんだ、猫か……。おどかさないでよ。<br>ん？",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => 'エクスパンション・セット「大陸議事」',
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
