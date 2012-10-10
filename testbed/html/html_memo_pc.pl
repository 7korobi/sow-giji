package SWHtmlMemoPC;

#----------------------------------------
# メモ表示（PCモード）のHTML出力
#----------------------------------------
sub OutHTMLMemoPC {
	my ($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows) = @_;

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $reqvals = &SWBase::GetRequestValues($sow);

	$reqvals->{'cmd'} = '';
	$reqvals->{'row'} = '';
	$reqvals->{'rowall'} = '';
	my $news_link = &SWBase::GetLinkValues($sow, $reqvals);
	$news_link   = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $news_link;

	my $memo_link_text;
    if ('memo' eq $query->{'cmd'}){
		$reqvals->{'cmd'} = 'hist';
		$memo_link_text = "履歴";
	} else {
		$reqvals->{'cmd'} = 'memo';
		$memo_link_text = "最新";
	}
	$reqvals->{'rowall'} = 'on';
	my $memo_link = &SWBase::GetLinkValues($sow, $reqvals);
	$memo_link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $memo_link;

	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	# ログインHTML
	$sow->{'html'}->outcontentheader();
	&SWHtmlPC::OutHTMLLogin($sow);

	# 見出し（村名とRSS）
	my $linkrss = " <a href=\"$link$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);
	print <<"_HTML_";
<h2>$query->{'vid'} $vil->{'vname'} $linkrss</h2>
<div class="pagenavi">
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="get" class="form-inline">
<p>
  <a class="btn" href="$memo_link">$memo_link_text</a>
  <a class="btn" href="$news_link">ニュース</a>
</p>
</form>
</div>
_HTML_

	# メモ表示
	my $title = '';
	$title = '履歴' if ($query->{'cmd'} eq 'hist');
	print <<"_HTML_";
<div class="message_filter">
<h3><a name="MEMO">メモ$title</a></h3>
_HTML_

	if (@$logs > 0) {
		print <<"_HTML_";
<table border="1" class="memo" summary="メモ$title">
<tbody>
_HTML_
	} else {
		print <<"_HTML_";
<p class="paragraph">
メモはありません。
</p>
_HTML_
	}

	my %logkeys;
	my %anchor = (
		logfile => $logfile,
		logkeys => \%logkeys,
		rowover => 1,
		reqvals => $reqvals,
	);

	my $order = 'desc';
	$order = 'asc' if ($query->{'cmd'} eq 'hist');
	$order = $query->{'order'} if ($query->{'order'} ne '');
	if (($order eq 'desc') || ($order eq 'd')) {
		my $i;
		for ($i = $#$logs; $i >= 0; $i--) {
			&OutHTMLMemoSinglePC($sow, $vil, $memofile, $logs->[$i], \%anchor);
		}
	} else {
		foreach (@$logs) {
			&OutHTMLMemoSinglePC($sow, $vil, $memofile, $_, \%anchor);
		}
	}

	if (@$logs > 0) {
		print <<"_HTML_";
</tbody>
</table>
_HTML_
	}

	print <<"_HTML_";
</div>
<hr class="invisible_hr" />
_HTML_

	my $writepl = &SWBase::GetCurrentPl($sow, $vil);
	if (($query->{'cmd'} eq 'memo')
	  &&($sow->{'turn'} == $vil->{'turn'})
	  &&($vil->{'turn'} <= $vil->{'epilogue'})
	  ){
		if     ($query->{'admin'}  eq 'on' ){
			&OutHTMLVilMakerPC($sow, $vil, 'admin');
		}elsif ($query->{'maker'}  eq 'on' ){
			&OutHTMLVilMakerPC($sow, $vil, 'maker');
		}elsif ($query->{'anonymous'}  eq 'on' ){
			&OutHTMLVilMakerPC($sow, $vil, 'anonymous');
		}elsif ($vil->checkentried() >= 0) {
			&OutHTMLMemoFormPC($sow, $vil, $memofile, $logs, \%anchor);
		}
	}

	print <<"_HTML_";
<hr class="invisible_hr"$net>
_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow);

	$sow->{'html'}->outcontentfooter();

	print <<"_HTML_";
<div id="tab" ng-cloak="ng-cloak">

<div class="sayfilter" id="sayfilter">
<h3 class="sayfilter_heading" ng-show="! navi.show.blank">ページをめくる</h3>
_HTML_
#	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLSayFilter($sow, $vil) if ($modesingle == 0);
	&SWHtmlSayFilter::OutHTMLTools    ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLFooter   ($sow, $vil);

	my $secret_show = $vil->isepilogue();
	print <<"_HTML_";
<script>
window.gon = {};
_HTML_
	$vil->gon_story($secret_show);
	$vil->gon_event($secret_show);
	$vil->gon_potofs($secret_show);

	# 全表示リンク
	my $is_news = 0 + (0 < $maxrow);

	print <<"_HTML_";
gon.event.is_news    = (0 != $is_news);
</script>
_HTML_

	return;
}

#----------------------------------------
# メモ発言欄HTML表示（一行分）
#----------------------------------------
sub OutHTMLMemoSinglePC {
	my ($sow, $vil, $memofile, $memoidx, $anchor) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	my $memo = $memofile->read($memoidx->{'pos'},$memoidx->{'logpermit'});
	my $chrname = $memo->{'chrname'};
	my $append  = "<br>(村を出ました)";
	my $curpl = $vil->getplbyface($memoidx->{'csid'},$memoidx->{'cid'});
	if ((defined($curpl->{'entrieddt'})) && ($curpl->{'entrieddt'} < $memoidx->{'date'})){
		if( 0 == ($sow->{'turn'} ) ){
			$append = "";
		} elsif ($memo->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'}){
			$chrname = "" if ( 0 == $vil->isepilogue() );
			$append  = "（匿名）";
		} elsif ($memo->{'mestype'} == $sow->{'MESTYPE_INFOSP'}){
			$append = "";
		} else {
			my $reqvals = &SWBase::GetRequestValues($sow);
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link&move=page&pageno=1&pno=$curpl->{'pno'}";
			$append = "<br><a href=\"".$link."\">注目</a>";
		}
	}
	my $mes = $memo->{'log'};
	$mes = '（メモをはがした）' if ($memo->{'log'} eq '');
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$mes, $anchor);
	&SWHtml::ConvertNET($sow, \$mes);
	my $mestext = "mes_text";
	$mestext = 'mes_text_monospace' if ((defined($memo->{'monospace'})) && ($memo->{'monospace'} == 1));
	$mestext = 'mes_text_report'    if ((defined($memo->{'monospace'})) && ($memo->{'monospace'} == 2));
	my $date = $sow->{'dt'}->cvtdt($memo->{'date'});
	my $memodate = '';
	$memodate = "<div class=\"mes_date\">$date</div>\n" if ($sow->{'query'}->{'cmd'} eq 'hist');

	# ID公開
	my $showid = '';
	$showid = "<br$net>($memoidx->{'uid'})" if ($vil->{'showid'} > 0);

	# クラス名
	my $messtyle = &SWHtmlPC::OutHTMLMesStyle($sow,$vil,$memo);

	if (($memo->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($memo->{'mestype'} == $sow->{'MESTYPE_ADMIN'})) {
		print <<"_HTML_";
<tr>
<td colspan=2 class="$messtyle">
<div class="guide">
<h3 class="mesname">$chrname</h3>
<p class="$mestext">$mes</p>
<p class="mes_date">$memodate</p>
</div>
_HTML_
	} else {
		print <<"_HTML_";
<tr class="$messtyle">
<th class="memoleft">$chrname $append $showid
<td class="memoright"><p class="$mestext">$mes</p>$memodate

_HTML_
	}
}

#----------------------------------------
# メモ発言欄HTML表示
#----------------------------------------
sub OutHTMLMemoFormPC {
	my ($sow, $vil, $memofile, $logs, $anchor) = @_;
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};

	my $curpl = $sow->{'curpl'};
	my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

	my $memo = $memofile->getnewmemo($curpl);
	my $mes = $memo->{'log'};
	$mes = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $mes, $anchor);
	$mes =~ s/<br( \/)?>/&#13\;/ig;

	# キャラ画像アドレスの取得
	my $img = &SWHtmlPC::GetImgUrl($sow, $curpl, $charset->{'BODY'});

	# キャラ画像
	print <<"_HTML_";
<table class="formpl_common">
<tr class="say">
<td class="img">
<img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net>

_HTML_

	# 名前とID
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'prof'} = $sow->{'uid'};
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	my $uidtext = $sow->{'uid'};
	$uidtext =~ s/ /&nbsp\;/g;
	$uidtext = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">$uidtext</a>";
	my $chrname = $curpl->getlongchrname();
	print <<"_HTML_";
<td class="field"><div class="msg">
<div class="formpl_content">$chrname ($uidtext)</div>

_HTML_

	# テキストボックスと発言ボタン初め
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_content">
_HTML_

	# 発言欄textarea要素の出力
	my ($saycnt,$cost,$unitaction) = $vil->getmemoptcosts();
	my $memocost = '無制限に貼り付けられ';
	$memocost    = '使うとアクション回数を消費し' if( $cost eq 'count' );
	$memocost    = '使うと発言を20pt消費し'       if( $cost eq 'point' );
	my %htmlsay = (
		saycnttext  => "",
		buttonlabel => 'メモを貼る',
		text        => $mes,
		disabled    => 0,
	);
	$htmlsay{'saycnttext'} = "あと".$curpl->{'say_act'}.$unitaction                       if( $cost eq 'count' );
	$htmlsay{'saycnttext'} = "あと".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if( $cost eq 'point' );
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'wrmemo', \%htmlsay);

	print <<"_HTML_";
<select name="monospace">
<option value="">(通常)
<option value="monospace">等幅
<option value="report">見出し
</select>
      <p>※メモを$memocostます。</p>
    </div>
    </form>
</div>
</table>
<div class="clearboth">
<hr class="invisible_hr"$net>
</div>
</div>

_HTML_

}

#----------------------------------------
# メモ発言欄HTML表示
#----------------------------------------
sub OutHTMLVilMakerPC {
	my ($sow, $vil, $writemode) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $amp = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $curpl = $sow->{'curpl'};
	my $csidlist = $sow->{'csidlist'};
	my @keys = keys(%$csidlist);
	my %imgpl = (
		cid      => $writemode,
		csid     => $keys[0],
		deathday => -1,
	);
	if ($writemode eq 'anonymous'){
		$imgpl{'csid'} = $curpl->{'csid'} ;
		$imgpl{'cid'}  = $curpl->{'cid'} ;
	}
	$imgpl{'deathday'} = $curpl->{'deathday'} if (defined($curpl->{'deathday'}));
	my $charset = $sow->{'charsets'}->{'csid'}->{$imgpl{'csid'}};

	# キャラ画像アドレスの取得
	my $img = &SWHtmlPC::GetImgUrl($sow, \%imgpl, $charset->{'BODY'});

	# キャラ画像
	print <<"_HTML_";
<table class="formpl_common">
<tr class="say">
<td class="img">
<img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net>

_HTML_

	# 名前とID
	my $chrname = $sow->{'charsets'}->getchrname($imgpl{'csid'}, $imgpl{'cid'});
	my $uidtext = $sow->{'uid'};
	print <<"_HTML_";
<td class="field"><div class="msg">
<div class="formpl_content">$chrname ($uidtext)</div>

_HTML_

	# テキストボックスと発言ボタン初め
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_content">
_HTML_

	# 発言欄textarea要素の出力
	my %htmlsay = (
	buttonlabel => 'メモを貼る',
		text        => $mes,
		disabled    => 0,
	);
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'wrmemo', \%htmlsay);

	print <<"_HTML_";
<select name="monospace">
<option value="">(通常)
<option value="monospace">等幅
<option value="report">見出し
</select>
    <input type="hidden" name="$writemode" value="on"$net>
    </div>
    </form>
</div>
</table>

_HTML_

	return;
}



1;
