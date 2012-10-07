package SWHtmlVIndex;

#----------------------------------------
# 村の一覧HTML出力
#----------------------------------------
sub OutHTMLVIndex {
	my ($sow, $vindex, $vmode) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query  = $sow->{'query'};
	my $cookie = $sow->{'cookie'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};
	my $note_start =  '<span class="note" ng-show="stories_is_small">';
	my $note_end   =  '</span>';

	my $maxrow = $sow->{'cfg'}->{'MAX_ROW'}; # 標準行数
	$maxrow = $cookie->{'row'} if (defined($cookie->{'row'}) && ($cookie->{'row'} ne '')); # 引数による行数指定
	$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne '')); # 引数による全表示指定

	my $pageno = 0;
	$pageno = $query->{'pageno'} if (defined($query->{'pageno'}));

	print <<"_HTML_";
<table border="1" class="vindex" summary="村の一覧">
<thead>
  <tr>
    <th scope="col"><code ng-click="stories_is_small = ! stories_is_small">スタイル</code></th>
_HTML_

	if ($vmode eq 'oldlog') {
		print "    <th id=\"days_$vmode\">日数</th>\n";
	} else {
		print "    <th id=\"vstatus_$vmode\">進行</th>\n";
	}

	print <<"_HTML_";
    <th scope="col">ルール</th>
  </tr>
</thead>

<tbody>
_HTML_

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = '';
	$reqvals->{'vid'} = '';

	my $vilist = $vindex->getvilist();
	my $vicount = 0;
	my $virow = -1;
	foreach (@$vilist) {
		my $date = sprintf("%02d:%02d", $_->{'updhour'}, $_->{'updminite'});

		my $vstatusno = 'playing';
		$vstatusno = 'prologue' if ($_->{'vstatus'} == $sow->{'VSTATUSID_PRO'}); # プロローグ
		$vstatusno = 'oldlog'   if ($_->{'vstatus'} == $sow->{'VSTATUSID_END'});
		$vstatusno = 'dispose'  if ($_->{'vstatus'} == $sow->{'VSTATUSID_SCRAPEND'});

		next if ($vstatusno ne $vmode); # 指定していない村は除外
		my $vil = SWFileVil->new($sow, $_->{'vid'});
		$vil->readvil();
		$sow->{'charsets'}->loadchrrs($vil->{'csid'});
		my $csidcaption = $sow->{'charsets'}->{'csid'}->{$vil->{'csid'}}->{'CAPTION'};
		my $pllist = $vil->getpllist();
		my $allpllist = $vil->getallpllist();
		$vil->closevil();

		if (!defined($vil->{'trsid'})) {
			# 村データがぶっ飛んだ場合に一応被害を食い止める
			print <<"_HTML_";
  <tr>
    <td colspan="4"><span class="cautiontext">$_->{'vid'}村のデータが取得できません。</span></td>
  </tr>

_HTML_
			next;
		}

		$virow++;
		if ($maxrow > 0) {
			next if ($virow < $pageno * $maxrow);
			next if ($virow >= ($pageno + 1) * $maxrow);
		}

		$vicount++;
		&SWBase::LoadTextRS($sow, $vil);
		my $csname = '複数';
		if (index($vil->{'csid'}, '/') < 0) {
			$sow->{'charsets'}->loadchrrs($vil->{'csid'});
			my $charset = $sow->{'charsets'}->{'csid'}->{$vil->{'csid'}};
			$csname = $charset->{'CAPTION'};
			$csname =~ s/ /<br>/ig;
		}

		my $plcnt = sprintf("%02d",scalar(@$pllist));
		if ($vmode eq 'prologue') {
			$plcnt .= "/".sprintf("%02d",$vil->{'vplcnt'});
		} else {
			$plcnt .= '人';
		}
		my $countmob = (scalar(@$allpllist) - scalar(@$pllist));
		$plcnt .= "+".$countmob."人" if ($countmob);

		my $updintervalday = $vil->{'updinterval'} * 24;
		$updintervalday .= 'h毎';
		my $vstatus = "$vil->{'turn'}日目";
		if ($vil->{'winner'} != 0) {
			$vstatus = '決着';
			$plcnt .= "$note_start<br>".$sow->{'textrs'}->{'CAPTION_WINNER'}->[$vil->{'winner'}]."$note_end";
		} elsif ($vil->isepilogue() > 0) {
			$vid = '&vid='.$_->{'vid'};
			$cssid = '';
			$cssid = '&css='.$sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
			$vstatus = '廃村';
			$vstatus = '<a href="sow.cgi?cmd=editvilform&status=dispose'.$vid.$cssid.'">やり直す</a>' if(($sow->{'uid'} ne '')&&($sow->{'uid'} ne $vil->{'makeruid'}));
		}
		if ($vmode eq 'oldlog') {
			my $numdays = $vil->{'turn'} - 2;
			$vstatus = sprintf("%02d日",$numdays);
		} else {
			$vstatus = "$vstatus";
		}
		if ($vil->{'turn'} == 0) {
			if ($vil->{'vplcnt'} > @$pllist) {
				$vstatus = '募集中';
			} else {
				$vstatus = '開始前';
			}
		}

		my $countssay = $sow->{'cfg'}->{'COUNTS_SAY'};
		my $imgpwdkey = '';
		if (defined($vil->{'entrylimit'})) {
			$imgpwdkey = "<img src=\"$cfg->{'DIR_IMG'}/icon/key.png\" width=\"16\" height=\"16\" alt=\"[鍵]\"$net> " if ($vil->{'entrylimit'} eq 'password');
		}

		my $imgrating = '';
		if ((defined($vil->{'rating'})) && ($vil->{'rating'} ne '')) {
			if (defined($sow->{'cfg'}->{'RATING'}->{$vil->{'rating'}}->{'FILE'})) {
				my $rating = $sow->{'cfg'}->{'RATING'}->{$vil->{'rating'}};
				$imgrating = "<img src=\"$cfg->{'DIR_IMG'}/icon/$rating->{'FILE'}\" width=\"$rating->{'WIDTH'}\" height=\"$rating->{'HEIGHT'}\" alt=\"[$rating->{'ALT'}]\" title=\"$rating->{'CAPTION'}\"$net> " if ($rating->{'FILE'} ne '');
			}
		}

		$reqvals->{'cmd'} = '';
		$reqvals->{'vid'} = $_->{'vid'};
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?".$link."#newsay";

		$reqvals->{'cmd'} = 'vinfo';
		my $linkvinfo = &SWBase::GetLinkValues($sow, $reqvals);
		$linkvinfo = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?".$linkvinfo;

		$reqvals->{'cmd'} = 'howto';
		$reqvals->{'trsid'} = $vil->{'trsid'};
		$reqvals->{'game'}  = $vil->{'game'};
		my $linkhowto = &SWBase::GetLinkValues($sow, $reqvals) . "#rolerule";

		$reqvals->{'cmd'} = 'rolematrix';
		my $linkrolematrix = &SWBase::GetLinkValues($sow, $reqvals);

		my $rtname = "$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}";
		my $saycnttype = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
		my $scname = $saycnttype->{'CAPTION'};

		my $schelp = '';
		if(($vmode eq 'prologue')){
			$schelp = $saycnttype->{'HELP'};
		}

		my $game = $sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'CAPTION'};
		my $vid_fmt = "%01d";
		$vid_fmt = "%02d" if (10   <= @$vilist);
		$vid_fmt = "%03d" if (100  <= @$vilist);
		$vid_fmt = "%04d" if (1000 <= @$vilist);
		my $vid  = sprintf($vid_fmt,$_->{'vid'});
		print <<"_HTML_";
<tr>
<td>$vid <a href="$linkvinfo">$vil->{'vname'}</a>
$note_start<br>〈<a href="$link">最新</a>〉
$imgpwdkey$note_end$imgrating$note_start
<br>　　人物 ： $csidcaption
<br>　　更新 ： $date $updintervalday
<br>　 $schelp
$note_end
</td>
<td class="small">
$plcnt
$note_start<br>$note_end
$vstatus
</td>
<td>
$note_start$scname<br>$note_end
$game$note_start
<br><a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkhowto">$sow->{'textrs'}->{'CAPTION'}</a>
<br><a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkrolematrix">$rtname</a>
$note_end
</td>
</tr>

_HTML_

	}

	if ($vicount == 0) {
		my $vmodetext;
		if ($vmode eq 'prologue') {
			$vmodetext = '募集中／開始待ち';
		} elsif ($vmode eq 'oldlog') {
			$vmodetext = '終了済み';
		} elsif ($vmode eq 'dispose') {
			$vmodetext = '廃村';
		} else {
			$vmodetext = '進行中';
		}

		print <<"_HTML_";
  <tr>
    <td colspan="6">現在$vmodetextの村はありません。</td>
  </tr>

_HTML_
	}

	print <<"_HTML_";
</tbody>
</table>

_HTML_

	if ($vmode eq 'oldlog') {
		print "<p class=\"pagenavi\">\n";
		$reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'} = $query->{'cmd'};

		if (($pageno > 0) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno - 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">前のページ</a> \n";
		} else {
			print "前のページ \n";
		}

		if ((($pageno + 1) * $maxrow <= $virow) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno + 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">次のページ</a> \n";
		} else {
			print "次のページ \n";
		}

		if (($virow + 1) != $vicount) {
			$reqvals->{'rowall'} = 'on';
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">全表\示</a>\n";
		} else {
			print "全表\示\n";
		}
		print "</p>\n";
	}
}

1;
