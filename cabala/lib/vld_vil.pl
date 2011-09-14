package SWValidityVil;

#----------------------------------------
# 村ログ関連基本入力値チェック
#----------------------------------------
sub CheckValidityVil {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$debug->raise($sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0); # 通常起きない
	$debug->raise($sow->{'APLOG_CAUTION'}, "あなたはこの村に参加していません。", "no entry.$errfrom") if (($vil->checkentried() < 0) && ($query->{'maker'} eq '') && ($query->{'admin'} eq '')); # 通常起きない
	$debug->raise($sow->{'APLOG_NOTICE'}, "この村は終了しました。", "It's ended.$errfrom") if ($vil->{'turn'} > $vil->{'epilogue'}); # 村が終了している時

	return;
}

1;