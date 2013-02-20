package SWResource_ger;

#----------------------------------------
# キャラセット
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};

  # キャラの表示順
  my @order = (
    'g01',  # g01  三元道士 露蝶 中国女性名
    'g02',  # g02  白鶴拳 晋鈺 台湾男性名 越南の名前も探したかったが、見つからぬ…
    'g03',  # g03  吹牛方士 芙蓉 里帰り
    'gc61',  # gc61  釣り師 沼太郎 里帰り
  );

  # キャラの肩書き
  my %chrjob = (
    'g01' => '三元道士',  # g01  三元道士 露蝶 中国女性名
    'g02' => '白鶴拳',  # g02  白鶴拳 晋鈺 台湾男性名 越南の名前も探したかったが、見つからぬ…
    'g03' => '吹牛方士',  # g03  吹牛方士 芙蓉 里帰り
    'gc61' => '釣り師',  # gc61  釣り師 沼太郎 里帰り
    $maker => '馬頭琴の調',
    $admin => '闇の呟き',
  );

  # キャラの名前
  my %chrname = (
    'g01' => '露蝶',   # g01  三元道士 露蝶 中国女性名
    'g02' => '晋鈺',   # g02  白鶴拳 晋鈺 台湾男性名 越南の名前も探したかったが、見つからぬ…
    'g03' => '芙蓉',   # g03  吹牛方士 芙蓉 里帰り
    'gc61' => '沼太郎',   # gc61  釣り師 沼太郎 里帰り
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
