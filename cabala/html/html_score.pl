package SWHtmlScore;

#----------------------------------------
# 人狼譜の出力
#----------------------------------------
sub OutHTMLScore {
	my $sow = $_[0];
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	require "$cfg->{'DIR_LIB'}/score.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/dtd_plaintext.pl";

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "このサーバでは人狼譜出力は無効になっています。", "disabled output score") if ($cfg->{'ENABLED_SCORE'} == 0);

	# 村データの読み込み
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "まだ村が終了していません。", "no winner.") if ($vil->{'turn'} < $vil->{'epilogue'});
	$vil->closevil();

	my $score = SWScore->new($sow, $vil, 0);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "人狼譜データが見つかりません。", "no score.") if (!defined($score->{'file'}));

	$sow->{'html'} = SWHtml->new($sow, 'plain'); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader(''); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	$score->output();
	$score->close();

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
