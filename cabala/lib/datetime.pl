package SWDateTime;

#----------------------------------------
# 日付関連ライブラリ
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow => $sow,
	};

	return bless($self, $class);
}

#----------------------------------------
# 基準日時の取得
#----------------------------------------
sub getlocaldt {
	my ($self, $dt) = @_;

	my $gmt = $dt + $self->{'sow'}->{'cfg'}->{'TIMEZONE'} * 60 * 60;
	return gmtime($gmt);
}

#----------------------------------------
# 日時の変換
#----------------------------------------
sub cvtdt {
	my ($self, $dt) = @_;
	my $t = time - $dt;
	if( 1 < $t && $t < 30*60 ){
		my $span = "%d秒以上経過";
		my $diff = $t;
		if(       60 < $t ){ $span = "%d分以上経過"  ; $diff=$diff/60; }
		if(    10*60 < $t ){ $span = "%d0分以上経過" ; $diff=$diff/10; }
		if(    60*60 < $t ){ $span = "%d時間以上経過"; $diff=$diff/ 6; }
		if( 24*60*60 < $t ){ $span = "%d日以上経過"  ; $diff=$diff/24; }
		my $result = sprintf($span,$diff);
		return $result;
	} else {
		my ($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = $self->getlocaldt( $dt + 900 );
		my $result = sprintf("%4d/%02d/%02d(%s) %02d時%s頃",  #:%02d:%02d
 $year + 1900, ++$mon, $day, ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat')[$week], $hour, ('','半')[$min/30], $sec);
		return $result;
	}
}

#----------------------------------------
# 日時の変換（モバイル向け短縮形）
#----------------------------------------
sub cvtdtmb {
	my ($self, $dt) = @_;
	my $t = time - $dt;
	if( 1 < $t && $t < 30*60 ){
		my $span = "%d秒以上経過";
		my $diff = $t;
		if(       60 < $t ){ $span = "%d分以上経過"  ; $diff=$diff/60; }
		if(    10*60 < $t ){ $span = "%d0分以上経過" ; $diff=$diff/10; }
		if(    60*60 < $t ){ $span = "%d時間以上経過"; $diff=$diff/ 6; }
		if( 24*60*60 < $t ){ $span = "%d日以上経過"  ; $diff=$diff/24; }
		my $result = sprintf($span,$diff);
		return $result;
	} else {
		my ($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = $self->getlocaldt($dt + 900 );
		my $result = sprintf("%02d/%02d %02d時%s頃",
++$mon, $day, $hour, ('','半')[$min/30]);
		return $result;
	}


	return $result;
}

#----------------------------------------
# 次回更新日時の取得
#----------------------------------------
sub getnextupdatedt {
	my ($self, $vil, $basedt, $updinterval, $commit) = @_;

	my $result = 0;
	if (($vil->{'updhour'} < 0) || ($vil->{'updminite'} < 0)) {
		# nn分更新
		$result = $basedt + $vil->{'updinterval'} * 60;
	} else {
		# 24h単位更新
		my $basedt_sec;
		($result, $basedt_sec) = $self->getlastupdatedt($vil, $basedt);
		if ($commit > 0) {
			$result += 60 * 60 * 24 if ($result != $basedt_sec);
		}
		$result += $updinterval * 60 * 60 * 24;
	}

	return $result;
}

#----------------------------------------
# 直前に更新した日時の取得
#----------------------------------------
sub getlastupdatedt {
	my ($self, $vil, $basedt) = @_;

	my($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = $self->getlocaldt($basedt);
	$basedt -= $sec;
	my $result = $basedt - ($hour * 60 + $min) * 60;
	$result += ($vil->{'updhour'} * 60 + $vil->{'updminite'}) * 60;
	$result -= 60 * 60 * 24 if ($result > $basedt);

	return ($result, $basedt);
}

#----------------------------------------
# 時間を進める日時の取得
#----------------------------------------
sub getcommitdt {
	my ($self, $basedt) = @_;

	my($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = $self->getlocaldt($basedt);
	$basedt -= ($sec + ($min % 30) * 60);
	my $result = $basedt + 60 * 30;

	return $result;
}

#----------------------------------------
# クッキーの期限日付取得
#----------------------------------------
sub getcookiedt {
	my ($self, $dt) = @_;

	my($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = gmtime($dt);
	my $expire = sprintf("%s, %02d-%s-%04d %02d:%02d:%02d GMT",
			('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat')[$week],
			$day, 
			('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun' , 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')[$mon],
			$year + 1900, $hour, $min, $sec
	);

	return $expire;
}

#----------------------------------------
# HTTP-Date(RFC822/RFC1123)形式の日付取得
#----------------------------------------
sub gethttpdt {
	my ($self, $dt) = @_;

	my($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = gmtime($dt);
	my $expire = sprintf("%s, %02d %s %04d %02d:%02d:%02d GMT",
			('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat')[$week],
			$day, 
			('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun' , 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')[$mon],
			$year + 1900, $hour, $min, $sec
	);

	return $expire;
}

#----------------------------------------
# 日時の変換（W3CDTF）
#----------------------------------------
sub cvtw3cdtf {
	my ($self, $dt) = @_;

	my($sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer) = $self->getlocaldt($dt);
	my $result = sprintf("%4d-%02d-%02dT%02d:%02d:%02d+09:00",
$year + 1900, ++$mon, $day, $hour, $min, $sec);

	return $result;
}

1;
