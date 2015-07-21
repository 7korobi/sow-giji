package SWResource_mad;

#----------------------------------------
# キャラセット
#----------------------------------------

sub GetRSChr {
  my $sow = $_[0];

  my $maker = $sow->{'cfg'}->{'CID_MAKER'};
  my $admin = $sow->{'cfg'}->{'CID_ADMIN'};


  # 表\示順
  my @all = ('mad03', 'c103', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08', 'mad09', 'mad10', 'mad11');
  my @marchen = ('mad03', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08', 'mad09', 'mad10', 'mad11');
  my %chrorder = (
    'all' => \@all,
    'marchen' => \@marchen,
  );

  my @tag_order = ('marchen');
  my @order = ('mad03', 'c103', 'mad06', 'c83', 'mad02', 'mad05', 'mad01', 'mad04', 'mad07', 'mad08', 'mad09', 'mad10', 'mad11');


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
    $maker    => '（村建て人）',
    $admin    => '（管理人）',
  );

  # ダミーキャラの発言
  my @npcsay =(
    "どうせ、殺されるわみんな。…みんな<br><br><br>/* 死ねばいいのに */",
    "１人になるのゎ私ばっか。どっちの道ぉ選んでも、<br>私ゎ十\分です。明日も待っててね。お願いだから、<br>離れて行かないで？<br>いつまでも、<br>なんで私ばっか<br><br><b>日記はそこで途切れ、発見されるまで打ち捨てられていた。</b>",
  );

  my @expression = (
  );

  my %charset = (
    CAPTION        => 'エクスパンション・セット「狂騒議事」',
    NPCID          => 'c83',
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
