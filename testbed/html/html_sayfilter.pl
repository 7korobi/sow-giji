package SWHtmlSayFilter;

#----------------------------------------
# 発言フィルタの表示
#----------------------------------------

sub OutHTMLTurnNavi {
  my ($sow, $vil, $logs, $list, $rows, $position) = @_;
  my $cfg   = $sow->{'cfg'};
  my $query = $sow->{'query'};
  my $amp   = $sow->{'html'}->{'amp'};
  my $net   = $sow->{'html'}->{'net'};

  $position = 0 if (!defined($position));

  my $reqvals = &SWBase::GetRequestValues($sow);

  $reqvals->{'turn'} = $sow->{'turn'};
  my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);

  $reqvals->{'mode'} = '';
  my $linkmodes = &SWBase::GetLinkValues($sow, $reqvals);

  $reqvals->{'turn'} = '';
  my $linkturns = &SWBase::GetLinkValues($sow, $reqvals);

  $reqvals->{'turn'} = $sow->{'turn'};
  $reqvals->{'pno'} = '';
  my $linkmemo = &SWBase::GetLinkValues($sow, $reqvals);

  $reqvals->{'turn'} = '';
  $reqvals->{'pno'} = '';
  my $linknew = &SWBase::GetLinkValues($sow, $reqvals);
  my $linkprologue = $linknew;

  my $anklog = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues\">ログ</a>";
  my $ankmemo = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=memo\">メモ</a>";
  my $ankmemohist = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=hist\">メモ履歴</a>";
# $ankmemo .= " <a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=memo&anonymous=on\">匿名メモ</a>";
  $ankmemo .= " <a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=memo&admin=on\">管理メモ</a>"  if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});
  $ankmemo .= " <a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=memo&maker=on\">村建メモ</a>" if ($sow->{'uid'} eq $vil->{'makeruid'});
  $ankmemohist = 'メモ履歴' if (($query->{'cmd'} eq 'hist') || ($query->{'cmd'} eq 'vinfo') || ($sow->{'turn'} > $vil->{'epilogue'}));
  $anklog = 'ログ' if (($query->{'cmd'} eq '') || ($query->{'cmd'} eq 'vinfo'));
  my $ankform = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew#newsay\">発言欄へ</a>";
  $ankform = '発言欄へ' if ($vil->{'turn'} > $vil->{'epilogue'});

  if (($position > 0) && ($sow->{'turn'} <= $vil->{'epilogue'}) && ($query->{'cmd'} ne 'vinfo')) {
    print "<p class=\"pagenavi\">\n";
    &OutHTMLPageNaviPC($sow, $vil, $logs, $list, $rows);
    print "[$ankmemo/$ankmemohist] / $ankform\n";
    print "</p>\n\n";
  }

  # 視点切り替えモードの取得
  my ($mode, $modes, $modename) = &SWHtml::GetViewMode($sow);

  my $postmode = '';
  $postmode = $amp . "mode=$mode" if ($vil->{'epilogue'} < $vil->{'turn'});

  print "<p class=\"turnnavi\" id=\"$sow->{'turn'}\">\n";
  if ($query->{'cmd'} eq 'vinfo') {
    print "情報\n";
  } else {
    print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew$amp" . "cmd=vinfo\">情報</a>\n";
  }


  if (($position == 0) && ($sow->{'turn'} <= $vil->{'epilogue'}) && ($query->{'cmd'} ne 'vinfo')) {
    print "<p class=\"pagenavi\">\n";
    &OutHTMLPageNaviPC($sow, $vil, $logs, $list, $rows);
    print "[$ankmemo/$ankmemohist] / $ankform\n";
    print "</p>\n\n";
  }

  # 視点切り替え
  if ($vil->{'epilogue'} < $vil->{'turn'}) {
    print "<p class=\"turnnavi\">\n視点：\n";
    my $postturn = $amp . "turn=$sow->{'turn'}";
    my $i;
    for ($i = 0; $i < @$modes; $i++) {
      if ($mode eq $modes->[$i]) {
        print "$modename->[$i]\n";
      } else {
        print "<a href=\"$sow->{'cfg'}->{'FILE_SOW'}?$linkmodes$postturn$amp"."mode=$modes->[$i]\">$modename->[$i]</a>\n";
      }
    }
  print "</p>\n\n";
  }
  return;
}

sub OutHTMLHeader {
	my ($sow, $vil) = @_;
  my $cfg = $sow->{'cfg'};
	my $amp = $sow->{'html'}->{'amp'};
  my $cfg = $sow->{'cfg'};

  my $reqvals = &SWBase::GetRequestValues($sow);

  $reqvals->{'row'} = '';
  $reqvals->{'rowall'} = 'on';
  my $rowall_link = &SWBase::GetLinkValues($sow, $reqvals);
  $rowall_link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $rowall_link;

	print <<"_HTML_";
<div id="tab" ng-cloak="ng-cloak">

<div class="sayfilter" id="sayfilter">
<h4 class="sayfilter_heading" ng-show="! navi.show.blank">{{story.name}}</h4>

<div class="insayfilter" ng-show="navi.show.link"><div class="paragraph">
<h4 class="sayfilter_caption_enable">他の場面へ</h4>
<div class="sayfilter_content">
<nav ng-show="event.is_news"><a class="btn" href="$rowall_link">全て表\示</a></nav>
<nav class="form-inline" template="navi/paginate" ng-hide="event.is_news"></nav>
<nav template="navi/page_filter"></nav>
<br />
</div>
_HTML_
  OutHTMLTurnLink($sow, $vil);
  return;
}

sub OutHTMLTurnLink {
  my ($sow, $vil) = @_;
  my $cfg = $sow->{'cfg'};
  my $amp = $sow->{'html'}->{'amp'};
  my $cfg = $sow->{'cfg'};

  print <<"_HTML_";
<h4 class="sayfilter_caption_enable">他の章へ</h4>

<div class="sayfilter_content" template="navi/events"></div>
</div></div>
_HTML_
	return;
}

sub OutHTMLFooter {
	my ($sow, $vil) = @_;
	print <<"_HTML_";
</div>

<div id="buttons"><nav><div ng-repeat="o in navi.select">
<a class="btn" ng-class="o.class" ng-click="navi.move(o.val)">{{o.name}}</a>
</div></nav></div>

</div>
_HTML_
	return;
}

sub OutHTMLSayFilter {
	my ($sow, $vil) = @_;
	print <<"_HTML_";
<div class="insayfilter" ng-show="navi.show.info"><div class="paragraph" ng-show="potofs">
<div class="sayfilter_content" template="navi/potofs"></div>
</div></div>
_HTML_
	return;
}

sub OutHTMLTools {
	my ($sow, $vil) = @_;
  my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);

	print <<"_HTML_";
<div class="insayfilter" ng-show="navi.show.calc"><div class="paragraph">
<h4 class="sayfilter_caption_enable">村の進行状況</h4>
<div class="sayfilter_content">
<ul>
<li>あと {{story.timer.extend}}回、更新を延長できる。</li>
<li class="small">{{story.timer.nextupdatedt.relative('ja')}}に更新</li>
<li class="small">{{story.timer.nextchargedt.relative('ja')}}に補充</li>
_HTML_

  print "<li class=\"small\">{{story.timer.nextcommitdt.relative('ja')}}にcommit</li>" if ($totalcommit == 3);
  print "<li class=\"small\">{{story.timer.scraplimitdt.relative('ja')}}に廃村</li>" if (0 == $vil->{'turn'});
  print <<"_HTML_";
</ul>
</div>
</div></div>
_HTML_
	return;
}
1;
