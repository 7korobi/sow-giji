package SWHtmlMemoFormMb;

#----------------------------------------
# メモ書き込み画面（モバイルモード）のHTML出力
#----------------------------------------
sub OutHTMLMemoFormMb {
	my ($sow, $vil) = @_;
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};

	require "$cfg->{'DIR_LIB'}/file_memo.pl";
	require "$cfg->{'DIR_LIB'}/log.pl";

	# HTMLモードの初期化
	$sow->{'html'} = SWHtml->new($sow);

	# HTTPヘッダ・HTMLヘッダの出力
	my $outhttp = $sow->{'http'}->outheader();
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('メモ');

	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp    = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = $query->{'cmdfrom'};
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	print <<"_HTML_";
$sow->{'query'}->{'vid'} $vil->{'vname'}<br$net>
<a href="$link">戻る</a>
<hr$net>
_HTML_

	my $curpl = $sow->{'curpl'};
	my $chrname = $curpl->getlongchrname();
	print "■$chrname<br$net>\n";

	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

	# 発言欄textarea要素の出力
	my ($saycnt,$cost,$unitaction) = $vil->getmemoptcosts();
	my $memocost = '無制限に貼り付けられ';
	$memocost    = '使うとアクション回数を消費し' if( $cost eq 'count' );
	$memocost    = '使うと発言を20pt消費し'       if( $cost eq 'point' );
	$reqvals->{'cmd'} = '';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 0);
	my $logs = $memofile->{'memoindex'}->{'file'}->getlist();
	my $mes = '';
	my $i;
	for ($i = $#$logs; $i >= 0; $i--) {
		next if ($curpl->{'uid'} ne $logs->[$i]->{'uid'});
		my $memo = $memofile->read($logs->[$i]->{'pos'});
		$mes = $memo->{'log'};
		$mes = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $mes, $anchor);
		$mes =~ s/<br( \/)?>/&#13\;/ig;
		last;
	}
	my $saycnttext = "";
	$saycnttext = "あと".$curpl->{'say_act'}.$unitaction                       if( $cost eq 'count' );
	$saycnttext = "あと".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if( $cost eq 'point' );

	print <<"_HTML_";
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="cmd" value="wrmemo"$net>$hidden
<input type="submit" value="メモを貼\る"$net> $saycnttext
_HTML_

	print <<"_HTML_";
<select name="monospace">
<option value="">(通常)
<option value="monospace">等幅
<option value="report">見出し
</select>
※メモを$memocostます。
</form>
<hr$net>

_HTML_

	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
	return;
}

1;
