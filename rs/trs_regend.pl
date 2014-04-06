package SWTextRS_regend;

sub GetTextRS {
   my ($sow)=@_;
   require "$sow->{'cfg'}->{'DIR_RS'}/trs_all.pl";
   my $textrs = &SWTextRS_all::GetTextRS($sow);

   # アクション
   my @actions = (
    'に相づちを打った。',
    'に怯えた。',
    'に驚いた。',
    'に照れた。',
    'に頷いた。',
    'に困惑した。',
    'に感謝した。',
    'に微笑んだ。',
    'に拍手した。',
    'に手を振った。',
    'に首を傾げた。',
    'にお辞儀をした。',
    'にむぎゅうした。',
    'に別れを告げた。',
    'にひどくうろたえた。',
    'にあっかんべーをした。',
    'にクラクションを鳴らした。',
    'に謹んで賄賂を差し出した。',
    'とにやりと微笑みあった。',
    'への前言を撤回した。',
    'から逃げ出した！しかし、回り込まれてしまった！',
    'をじっと見つめた。',
    'を信頼の目で見た。',
    'を怪訝そうに見た。',
    'を不信の目で見た。',
    'を指さした。',
    'をつんつんつついた。',
    'を支持した。',
    'を慰めた。',
    'を慰める振りをした。',
    'を巻き添えにした。',
    'を空の彼方にぶっ飛ばした。',
    'を抱きしめた。',
    'を小一時間問いつめた。',
    'の頭を撫でた。',
    'にタライを落とした。',
    'をハリセンで殴った。',
    'のチョコレートを借用した。',
   );

   $textrs->{'CAPTION'}       = '議事☆伝承';
   $textrs->{'HELP'}          = 'すべての役職、恩恵、事件を楽しむことができる、「全部入り」のセットです。アクション内容は穏当になり、未来的ですばらしいクローンも居ません。';

   $textrs->{'ACTIONS'}        = \@actions;
   delete $textrs->{'ACTIONS_CLEARANCE_UP'};
   delete $textrs->{'ACTIONS_CLEARANCE_DOWN'};
   delete $textrs->{'ACTIONS_CLEARANCE_NG'};
   delete $textrs->{'ACTIONS_ZAP'};
   delete $textrs->{'ACTIONS_ZAPCOUNT'};

   return $textrs;
}

1;
