package SWBasicTextRS;

sub SWBasicTextRS {
	my $sow = $_[0];

	my @starttypeorder = ('manual', 'wbbs');
	my %starttypetext = (
		ORDER  => \@starttypeorder,
		manual => '手動開始（開始ボタンを押したら開始）',
		wbbs   => '人狼BBS型（更新時間が来たら開始）',
	);

	my %saytext_count = (
		UNIT_SAY     => '回',
		UNIT_CAUTION => '文字',
		UNIT_ACTION  => '回',
	);

	my %saytext_point = (
		UNIT_SAY     => 'pt',
		UNIT_CAUTION => 'バイト',
		UNIT_ACTION  => '回',
	);

	my %saytext_point25 = (
		UNIT_SAY     => 'pt',
		UNIT_CAUTION => 'バイト',
		UNIT_ACTION  => '回',
	);

	my %saytext = (
		count   => \%saytext_count,
		point   => \%saytext_point,
		point25 => \%saytext_point25,
	);

	my %mob_juror = (
		CAPTION => '陪審',
		HELP    => '進行中会話は陪審同士のみ。陪審（＆決定者）だけが投票する。',
	);
	my %mob_visiter = (
		CAPTION => '客席',
		HELP    => '進行中会話は客席同士のみ',
	);
	my %mob_grave = (
		CAPTION => '裏方',
		HELP    => '進行中会話は墓下と',
	);
	my %mob_alive = (
		CAPTION => '舞台',
		HELP    => '進行中会話は地上、墓下、両方と',
	);

	my @mob_order = ('alive', 'grave', 'visiter', 'juror');
	my %mob = (
		ORDER     => \@mob_order,
		juror     => \%mob_juror,
		visiter   => \%mob_visiter,
		grave     => \%mob_grave,
		alive     => \%mob_alive,
	);

	my %game_tabula = (
		CAPTION => 'タブラの人狼',
		HELP    => '<li>同数票の処刑候補が複数いた場合、ランダムに処刑する。<li>狼を全滅させると、村勝利。<li>人≦狼、つまり人間と人狼を１対１にしたとき、人間が余計にいなくなったら、狼勝利。</li>',
	);

	my %game_millerhollow = (
		CAPTION => 'ミラーズホロウ',
		HELP    => '<li>同数票の処刑候補が複数いた場合、処刑をとりやめる。<li>狼を全滅させると、村勝利。<li>「村人」を全滅させると、狼勝利。役職を持つ村側の生き残りは、勝利に直接は寄与しない。<li>すべての死者は役職が公開される。</li>',
	);

	my %game_live_tabula = (
		CAPTION => '死んだら負け',
		HELP    => '<li>同数票の処刑候補が複数いた場合、ランダムに処刑する。<li>狼を全滅させると、村側の生存者が勝利。<li>人≦狼、つまり人間と人狼を１対１にしたとき、人間が余計にいなくなったら、狼勝利。<li>ただし、仲間が勝利していても、死んでしまった者は敗北である。</li>',
	);

	my %game_live_millerhollow = (
		CAPTION => '死んだら負け(ミラーズホロウ)',
		HELP    => '<li>同数票の処刑候補が複数いた場合、処刑をとりやめる。<li>狼を全滅させると、村側の生存者が勝利。<li>「村人」を全滅させると、狼勝利。役職を持つ村側の生き残りは、勝利に直接は寄与しない。<li>ただし、仲間が勝利していても、死んでしまった者は敗北である。</li>',
	);

	my %game_trouble = (
		CAPTION => 'Trouble☆Aliens',
		HELP    => '<li>同数票の処刑候補が複数いた場合、ランダムに処刑する。<li>狼を全滅させると、村側の生存者が勝利（村人は死んだら負ける）。<li>人≦狼、つまり人間と人狼を１対１にしたとき、人間が余計にいなくなったら、狼と感染者の勝利。<li>人狼は会話できない。襲撃候補リストで判断できない。<li>襲撃先は翌日、犠牲候補と人狼に開示される。</li><li>守護者は、より大人数の人狼からは守りきることができず、身代わりに感染する。</li><li>１人の人狼が襲撃すると感染、複数の人狼や一匹狼、賞金稼ぎが襲撃すると死亡する。</li>',
	);

	my %game_mistery = (
		CAPTION => '深い霧の夜',
		HELP    => '<li>同数票の処刑候補が複数いた場合、ランダムに処刑する。<li>狼を全滅させると、村勝利。<li>役職「村人」を全滅させると、狼勝利。</li><li>役職を持つ村側の生き残りは、勝利に直接は寄与しない。</li><li>村側は自分の役職を自覚しない。</li><li>村側は、能力の結果不審者を見かけることがある。</li><li>人狼の行動対象に選ばれると、不審者を見かける。</li>',
	);

	my %game_vov = (
		CAPTION => '狂犬病の谷',
		HELP    => '<li>同数票の処刑候補が複数いた場合、ランダムに処刑する。<li>狼を全滅させると、村勝利。<li>人≦狼、つまり人間と人狼を１対１にしたとき、人間が余計にいなくなったら、狼勝利。</li><li>１人の人狼が襲撃すると感染、複数の人狼や一匹狼、賞金稼ぎが襲撃すると死亡する。</li>',
	);

	my %game = (
		TABULA            => \%game_tabula,
		MILLERHOLLOW      => \%game_millerhollow,
		LIVE_TABULA       => \%game_live_tabula,
		LIVE_MILLERHOLLOW => \%game_live_millerhollow,
		TROUBLE           => \%game_trouble,
		VOV               => \%game_vov,
		MISTERY           => \%game_mistery,
	);


	my %basictrs = (
		NONE_TEXT       => 'なし',
		SAYTEXT         => \%saytext,
		ORDER_STARTTYPE => \@starttypeorder,
		STARTTYPE       => \%starttypetext,
		BUTTONLABEL_PC  => '_BUTTON_',
		BUTTONLABEL_MB  => '_BUTTON_',
		MOB             => \%mob,
		GAME            => \%game,
	);

	return \%basictrs;
}

1;
