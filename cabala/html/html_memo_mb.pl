package SWHtmlMemoMb;

#----------------------------------------
# メモ表示（モバイルモード）のHTML出力
#----------------------------------------
sub OutHTMLMemoMb {
	my ($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows) = @_;

	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp    = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	$sow->{'html'}->outcontentheader();

	# 二重書き込み注意
	if ($sow->{'query'}->{'cmdfrom'} eq 'wrmemo') {
		print <<"_HTML_";
<font color="red">★二重書き込み注意★</font><br$net>
リロードする場合は「新」を使って下さい。
<hr$net>
_HTML_
	}

	# 村名
	my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
	my $extend = '延長' . $vil->{'extend'} . '回まで。' if $vil->{'extend'};
	my $titleupdate = " ($date に更新。 $extend)";

	# 見出し（村名とRSS）
	print "<a $atr_id=\"top\">$query->{'vid'} $vil->{'vname'}<br$net>\n";

	# キャラ名表示
	if (defined($sow->{'curpl'}->{'uid'})) {
		my $chrname = $sow->{'curpl'}->getlongchrname();
		my $rolename = $sow->{'curpl'}->getrolename();
		print "$chrname$rolename<br$net>\n";
	}

	# 日付別ログへのリンク
	my $list = $memofile->getmemolist();
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0, $logs, $list, $rows);

	if (defined($logs->[0]->{'pos'})) {
		if (($query->{'order'} eq 'desc') || ($query->{'order'} eq 'd')){
			# 降順
			my $i;
			for ($i = $#$logs; $i >= 0; $i--) {
				&OutHTMLMemoSingleMb($sow, $vil, $logfile, $memofile, $logs->[$i]);
			}
		} else {
			# 昇順
			foreach (@$logs) {
				&OutHTMLMemoSingleMb($sow, $vil, $logfile, $memofile, $_);
			}
		}
	} else {
		print <<"_HTML_";
メモはありません。
<hr$net>
_HTML_
	}

	# 日付別ログへのリンク
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1, $logs, $list, $rows);

	$sow->{'html'}->outcontentfooter();

	return;
}

#----------------------------------------
# メモ欄HTML表示（１メモ分）
#----------------------------------------
sub OutHTMLMemoSingleMb {
	my ($sow, $vil, $logfile, $memofile, $memoidx) = @_;
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'};

	my $memo = $memofile->read($memoidx->{'pos'},$memoidx->{'logpermit'});

	my $curpl = $vil->getpl($memo->{'uid'});
	my $chrname = $memo->{'chrname'};
	my $append  = "(村を出ました)";
	if ((defined($curpl->{'entrieddt'})) && ($curpl->{'entrieddt'} < $memo->{'date'})){
		$append = "";
	}
	my $mes = $memo->{'log'};
	$mes = '（メモをはがした）' if ($memo->{'log'} eq '');
	my %logkeys;
	my %anchor = (
		logfile => $logfile,
		logkeys => \%logkeys,
		rowover => 1,
	);
	$mes = &SWLog::ReplaceAnchorHTMLMb($sow, $vil, $mes, \%anchor);
	my $date = $sow->{'dt'}->cvtdtmb($memo->{'date'});
	my $memodate = '';
	$memodate = " $date" if ($query->{'cmd'} eq 'hist');

	# 発言色
	my @logcolor = (
		'',               # MESTYPE_UNDEF
		'',               # MESTYPE_INFOSP
		'gray',           # MESTYPE_DELETEDADMIN
		'',               # MESTYPE_CAST
		'',               # MESTYPE_MAKER
		'',               # MESTYPE_ADMIN
		'',               # MESTYPE_QUEUE
		'',               # MESTYPE_INFONOM
		'gray',           # MESTYPE_DELETED
		'',               # MESTYPE_SAY
		'gray',           # MESTYPE_TSAY
		'red',            # MESTYPE_WSAY
		'blue',           # MESTYPE_GSAY
		'purple',         # MESTYPE_SPSAY
		'green',          # MESTYPE_XSAY
		'maroon',         # MESTYPE_VSAY
		'',               # MESTYPE_MSAY
		'gray',           # MESTYPE_AIM
	);
	my $messtyle = $logcolor[$memoidx->{'mestype'}];
	if($memoidx->{'mestype'} == $sow->{'MESTYPE_VSAY'}){
		$messtyle = '';
		$messtyle = 'blue' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'grave'));
		$messtyle = 'gray' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'think'));
	}

	&SWHtml::ConvertNET($sow, \$mes);

	my $colorstart = '';
	my $colorend = '';
	if ($messtyle ne '') {
		$colorstart = "<font color=\"$messtyle\">\n";
		$colorend = "\n</font>";
	}

	if (($memo->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($memo->{'mestype'} == $sow->{'MESTYPE_ADMIN'})) {
		print <<"_HTML_";
$colorstart$chrname$memodate<br$net>
$mes$colorend
<hr$net>
_HTML_
	} else {
		print <<"_HTML_";
$colorstart$chrname$append$memodate<br$net>
$mes$colorend
<hr$net>
_HTML_
	}

}

1;
