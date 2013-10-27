package SWHtmlVIndexMb;

#----------------------------------------
# 村一覧のHTML出力（モバイル）
#----------------------------------------
sub OutHTMLVIndexMb {
	my $sow = $_[0];
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	require "$cfg->{'DIR_LIB'}/file_vindex.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_vindex.pl";

	# 村一覧データ読み込み
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();

	my $linkvalue;
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	# HTTP/HTMLの出力
	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader('村一覧'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $vilist = $vindex->getvilist();

#	my @imgratings = '';
#	my $rating = $cfg->{'RATING'};
#	my $ratingorder = $rating->{'ORDER'};
#	foreach (@$ratingorder) {
#		push(@imgratings, "[$rating->{$_}->{'ALT'}]") if ($rating->{$_}->{'FILE'} ne '');
#	}
#	my $imgrating = join(' ', @imgratings);

	if ($sow->{'query'}->{'cmd'} eq 'vindex') {
		print <<"_HTML_";
■募集中／開始待ち<br$net>
_HTML_

		# 募集中／開始待ち村の表示
		my $vicount = 0;
		foreach (@$vilist) {
			next if ($_->{'vstatus'} ne $sow->{'VSTATUSID_PRO'});
			$vicount += &OutHTMLVIndexSingleMb($sow, $_);
		}
		if ($vicount == 0) {
			print "なし。<br$net>";
		}

		print <<"_HTML_";
<hr$net>

■進行中／決着<br$net>
_HTML_

		# 進行中／決着済みの村の表示
		$vicount = 0;
		foreach (@$vilist) {
			next if (($_->{'vstatus'} ne $sow->{'VSTATUSID_PLAY'}) && ($_->{'vstatus'} ne $sow->{'VSTATUSID_EP'}) && ($_->{'vstatus'} ne $sow->{'VSTATUSID_SCRAP'}));
			$vicount += &OutHTMLVIndexSingleMb($sow, $_);
		}
		if ($vicount == 0) {
			print "なし。<br$net>";
		}

		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'} = 'oldlog';
		my $link = &SWBase::GetLinkValues($sow, $reqvals);

		print <<"_HTML_";
<hr$net>

<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">終了済み</a>
<hr$net>

_HTML_
	} else {
		print <<"_HTML_";
■終了済み<br$net>
_HTML_

		my $maxrow = $sow->{'cfg'}->{'MAX_ROW_MB'}; # 標準行数
		$maxrow = $query->{'row'} if (defined($query->{'row'}) && ($query->{'row'} ne '')); # 引数による行数指定
		$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne '')); # 引数による全表示指定

		my $pageno = 0;
		$pageno = $query->{'pageno'} if (defined($query->{'pageno'}));

		# 終了済みの村の表示
		my $vicount = 0;
		my $virow = -1;
		foreach (@$vilist) {
			next if (($_->{'vstatus'} ne $sow->{'VSTATUSID_END'}) && ($_->{'vstatus'} ne $sow->{'VSTATUSID_SCRAPEND'}));
			$virow++;
			if ($maxrow > 0) {
				next if ($virow < $pageno * $maxrow);
				next if ($virow >= ($pageno + 1) * $maxrow);
			}
			$vicount += &OutHTMLVIndexSingleMb($sow, $_);
		}
		if ($vicount == 0) {
			print "なし。<br$net>";
		}

		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'} = $query->{'cmd'};

		my $prev = '前';
		if (($pageno > 0) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno - 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			$prev = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">前</a>";
		}

		my $next = '次';
		if ((($pageno + 1) * $maxrow <= $virow) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno + 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			$next = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">次</a>";
		}

		$reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'} = 'vindex';
		my $link = &SWBase::GetLinkValues($sow, $reqvals);

		print <<"_HTML_";
<hr$net>

$prev/$next/<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">村一覧</a>
<hr$net>

_HTML_
	}

	# サポート掲示板へのリンク
	my $urlbbs = $sow->{'cfg'}->{'URL_BBS_MB'};
	my $namebbs = $sow->{'cfg'}->{'NAME_BBS_MB'};
	if ($sow->{'cfg'}->{'URL_BBS_MB'} eq '') {
		$urlbbs  = $sow->{'cfg'}->{'URL_BBS'};
		$namebbs = $sow->{'cfg'}->{'NAME_BBS'};
	}
	if ($urlbbs ne '') {
		print <<"_HTML_";
<a href="$urlbbs">$namebbs</a>
_HTML_
	}
	print "\n";

	$vindex->closevindex();
	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# 村データのHTML出力（一行分）
#----------------------------------------
sub OutHTMLVIndexSingleMb {
	my ($sow, $vindexsingle) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	my $vil = SWFileVil->new($sow, $_->{'vid'});
	$vil->readvil();
	my $pllist = $vil->getpllist();
	$vil->closevil();

	if (!defined($vil->{'trsid'})) {
		print <<"_HTML_";
$vil->{'vid'}村のデータが取得できません。<br$net>
_HTML_
		return 0;
	}

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = $vindexsingle->{'vid'};
	$reqvals->{'c'}   = 'vinfo';
	my $link = &SWBase::GetLinkValues($sow, $reqvals);

	my $imgpwdkey = '';
	if (defined($vil->{'entrylimit'})) {
		$imgpwdkey = "[鍵] " if ($vil->{'entrylimit'} eq 'password');
	}

	my $imgrating = '';
	if ((defined($vil->{'rating'})) && ($vil->{'rating'} ne '')) {
		if (defined($sow->{'cfg'}->{'RATING'}->{$vil->{'rating'}}->{'FILE'})) {
			my $rating = $sow->{'cfg'}->{'RATING'}->{$vil->{'rating'}};
			$imgrating = "[$rating->{'ALT'}] " if ($rating->{'FILE'} ne '');
		}
	}

	print <<"_HTML_";
$imgpwdkey$imgrating<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">$_->{'vid'} $vil->{'vname'}</a><br$net>
_HTML_

	return 1;
}

1;
