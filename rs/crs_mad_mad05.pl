package SWResource_mad_mad05;

#----------------------------------------
# キャラセット
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # 表\示順
  my @all = ('mad01', 'mad03', 'mad10', 'mad11', 'c103', 'mad12', 'mad06', 'c83', 'mad02', 'mad05', 'mad04', 'mad07', 'mad08', 'mad09');
  my @marchen = ('mad01', 'mad03', 'mad10', 'mad11', 'mad12', 'mad06', 'c83', 'mad02', 'mad05', 'mad04', 'mad07', 'mad08', 'mad09');
  my %chrorder = (
    'all' => \@all,
    'marchen' => \@marchen,
  );

  my @tag_order = ('marchen');
  my @order = ('mad01', 'mad03', 'mad10', 'mad11', 'c103', 'mad12', 'mad06', 'c83', 'mad02', 'mad05', 'mad04', 'mad07', 'mad08', 'mad09');


  # キャラの肩書き
  my %chrjob = (
    'c103' => '厭世家',
    'c83' => '虹追い',
    'mad01' => '青い鳥',
    'mad02' => '蟻塚崩し',
    'mad03' => '露店巡り',
    'mad04' => '酸味探し',
    'mad05' => '天井手繰り',
    'mad06' => '隠れん坊',
    'mad07' => '早口言葉',
    'mad08' => '妄執の誓い',
    'mad09' => '隣席座り',
    'mad10' => '追憶探り',
    'mad11' => '乱痴気',
    'mad12' => '自由滑落',
    $maker => '天上の調べ',
    $admin => '闇の呟き',
  );

  # キャラの名前
  my %chrname = (
    'c103' => 'ナンシー',
    'c83' => 'アイリス',
    'mad01' => 'デメテル',
    'mad02' => 'エルゴット',
    'mad03' => 'シーシャ',
    'mad04' => 'ドリベル',
    'mad05' => 'ヤヘイ',
    'mad06' => 'アヤワスカ',
    'mad07' => 'ダイミ',
    'mad08' => 'エフェドラ',
    'mad09' => 'カナビス',
    'mad10' => 'ルグレ',
    'mad11' => 'オルギア',
    'mad12' => 'パカロロ',
    $maker    => '（村建て人）',
    $admin    => '（管理人）',
  );

  # ダミーキャラの発言
  my @npcsay =(
    "…うん。もうな、だいぶまえだ。<br>借家住まいでさ、天井板がずれて、開いているから入り込んでみたんだ。<br><br>結構\広くてさ。奥へ、奥へ、這い進んでたら明かりが切れてさ。<br>もう右も左もわからなくってさあ…。<br><br>必死に暴\れたら、明るいとこに出た。<br>知らない街だった。",
    "…うん。そうだよ。<br>まだ、その街から出られないんだ。おまえだって、そうなんだろう？<br><br>あー、あっち。いや、こっちかも？<br>そっちの先はまだ手繰ってないかもしれねえよ？<br>ウケッ、ウケッ、ウケコッ、ウコケ、ウコケ、ウヒャホ、コケコケコケ！",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => 'エクスパンション・セット「狂騒議事」（ヤヘイ）',
    NPCID          => 'mad05',
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
