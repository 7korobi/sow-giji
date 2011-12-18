package SWValidityStart;

#----------------------------------------
# 村手動開始時値チェック
#----------------------------------------
sub CheckValidityStart {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $pllist = $vil->getpllist();
	my $committablepl = $vil->getcommittablepl();
	my $errfrom = "[uid=$sow->{'uid'}, vid=$vil->{'vid'}, cmd=$query->{'cmd'}]";

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	$debug->raise($sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	$debug->raise($sow->{'APLOG_CAUTION'}, "人数が足りません。ダミーキャラを含め、最低 4 人必要です。", "need 4 persons.$errfrom") if (@$pllist < 4);
	$debug->raise($sow->{'APLOG_CAUTION'}, "人数が足りません。投票する陪審員が必要です。", "need juror.$errfrom") if (($committablepl < 1)&&($vil->{'mob'} eq 'juror');

	$debug->raise($sow->{'APLOG_CAUTION'}, "村を開始するには村建て人権限か管理人権限が必要です。", "no permition.$errfrom") if (($sow->{'uid'} ne $vil->{'makeruid'}) && ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}));

	return;
}

1;