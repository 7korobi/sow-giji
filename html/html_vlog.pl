package SWHtmlVlog;

#----------------------------------------
# 村ログ表示のタイトル
#----------------------------------------
sub GetHTMLVlogTitle {
	my ($sow, $vil) = @_;
	my $daytitle = "$sow->{'turn'}日目";
	$daytitle = 'プロローグ' if ($sow->{'turn'} == 0);
	$daytitle = 'エピローグ' if ($sow->{'turn'} == $vil->{'epilogue'});
	$daytitle = '終了' if ($sow->{'turn'} > $vil->{'epilogue'});
	return "$daytitle / $sow->{'query'}->{'vid'} $vil->{'vname'}";
}

#----------------------------------------
# 未発言者リストの取得
#----------------------------------------
sub GetNoSayListText {
	my ($sow, $vil) = @_;

	return '' if ($vil->{'event'} == $sow->{'EVENTID_NIGHTMARE'});

	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $pllist = $vil->getpllist();

	my @nosay;
	foreach (@$pllist) {
		if (($_->{'live'} eq 'live') && ($_->{'saidcount'} == 0)) {
			push(@nosay, $_);
		}
	}

	my $result = '';
	my $nosaycnt = @nosay;
	$result .= "本日まだ発言していない者は、";
	foreach (@nosay) {
		my $chrname = $_->getlongchrname();
		$result .= "$chrname、";
	}
	$result .= "以上 $nosaycnt 名。<br>";
	$result = '' if ($nosaycnt == 0);

	if (($sow->{'curpl'}->{'live'} eq 'live')) {
		my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);
		if( $sow->{'curpl'}->{'commit'} > 0 ){
			$result .= "あなたは時間を進めています。";
		}elsif( $totalcommit == 2 ){
			$result .= "<b>あなたは時間を進めていません。</b>";
		}
	}

	return $result;
}

1;
