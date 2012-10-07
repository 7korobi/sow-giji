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
  $reqvals->{'cmd'} = 'vinfo';
  my $linkvinfo = &SWBase::GetLinkValues($sow, $reqvals);
  $linkvinfo = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $linkvinfo;

  $reqvals->{'rowall'} = 'on';
  $reqvals->{'row'} = '';
  my $rowall_link = &SWBase::GetLinkValues($sow, $reqvals);
  $rowall_link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $rowall_link;


	print <<"_HTML_";
<div id="tab" ng-cloak="ng-cloak">

<div class="sayfilter" id="sayfilter">
<h3 class="sayfilter_heading" ng-show="! navi.blank">ページをめくる</h3>

<div class="insayfilter" ng-show="navi.link"><div class="paragraph">
<h4 class="sayfilter_caption_enable">他の場面へ</h4>
<div class="sayfilter_content">
<a class="btn" ng-show="event.is_news" href="$rowall_link">全て表\示</a>
<nav ng-hide="event.is_news"><span><a class="btn" ng-class="page.first" ng-click="page.paginate('first')">{{page._button.first}}</a></span><span><a class="btn" ng-class="page.second" ng-click="page.paginate('second')">{{page._button.second}}</a></span><span ng-class="page.prev_gap">…</span><span><a class="btn" ng-class="page.prev" ng-click="page.paginate('prev')">{{page._button.prev}}</a></span><span><a class="btn" ng-class="page.current" ng-click="page.paginate('current')">{{page._button.current}}</a></span><span><a class="btn" ng-class="page.next" ng-click="page.paginate('next')">{{page._button.next}}</a></span><span ng-class="page.next_gap">…</span><span><a class="btn" ng-class="page.penu" ng-click="page.paginate('penu')">{{page._button.penu}}</a></span><span><a class="btn" ng-class="page.last" ng-click="page.paginate('last')">{{page._button.last}}</a></span></nav>
<nav><span ng-repeat="key in mode._keys"><a class="btn" ng-class="mode[key]" ng-click="mode.move(key)">{{mode._button[key]}}</a></span></nav>
<br />
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="get" class="form-inline">
<p>
  <select name="order" class="input-medium" ng-model="order._value">
    <option ng-class="order.asc" value="asc">上から下へ
    <option ng-class="order.desc" value="desc">下から上へ
  </select>
  <select name="row" class="input-small" ng-model="row._value">
_HTML_

   my $row_pc = $sow->{'cfg'}->{'ROW_PC'};
   foreach (@$row_pc) {
     print "<option value=\"$_\" ng-class=\"row[$_]\">$_行\n";
   }

   print <<"_HTML_";
  </select>
</p>
</form>
</div>
<h4 class="sayfilter_caption_enable">他の章へ</h4>

<div class="sayfilter_content">
<ul>
<li><a href="$linkvinfo"> - 村の情報 - </a>
_HTML_

	my $reqvals = &SWBase::GetRequestValues($sow);

	$reqvals->{'turn'} = '';
	my $linkturns = &SWBase::GetLinkValues($sow, $reqvals);

	my $cmdlog = 0;
	$cmdlog = 1 if (($query->{'cmd'} eq '') || ($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist'));

	my $i;
	for ($i = 0; $i <= $vil->{'turn'}; $i++) {
    next if ($i > $vil->{'epilogue'});

		my $turnname = "$i日目";
		$turnname = "プロローグ" if ($i == 0);
		$turnname = "エピローグ" if ($i == $vil->{'epilogue'});

		my $postturn = "";
    if ($i == $vil->{'turn'}){
      $turnname .= " (最新)";
      $postturn = $amp."turn=$i";
    } else {
      $postturn = $amp."turn=$i".$amp."rowall=on";
    }

		my $link_to = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkturns$postturn";
		print <<"_HTML_";
<li><a href="$link_to">$turnname</a>
_HTML_
	}

	print <<"_HTML_";
</ul><br />
</div>
</div></div>
_HTML_
	return;
}

sub OutHTMLFooter {
	my ($sow, $vil) = @_;
	print <<"_HTML_";
</div>

<div id="buttons"><nav><div ng-repeat="key in navi._keys">
<a class="btn" ng-class="navi[key]" ng-click="navi.move(key)">{{navi._button[key]}}</a>
</div></nav></div>

</div>
_HTML_
	return;
}

sub OutHTMLSayFilter {
	my ($sow, $vil) = @_;
	print <<"_HTML_";
<div class="insayfilter" ng-show="navi.info"><div class="paragraph" ng-show="potofs">
<div class="sayfilter_content">
<table class="table table-condensed">
<thead>
<tr>
<th colspan="2" style="text-align:right"><code ng-click="potofs_is_small = ! potofs_is_small">スタイル</code>-<code href_eval="sort_potofs('deathday',0)">日程</code><code href_eval="sort_potofs('live','')">状態</code><code href_eval="sort_potofs('said_num',0)">発言</code>
<th colspan="2"><code href_eval="sort_potofs('win_name','')">陣営</code><code href_eval="sort_potofs('role_names','')">役割</code><code href_eval="sort_potofs('select_name','')">希望</code><code href_eval="sort_potofs('text','')">補足</code>
{{sum.actaddpt}}促
</thead>
<tbody ng-repeat="potof in potofs">
<tr>
<td>{{potof.name}}<div class="note" ng-show="potof.auth && potofs_is_small"><i class="icon-user"></i>{{potof.auth}}</div>
<td>{{potof.stat}}<div class="note" ng-show="potof.said && potofs_is_small"><i class="icon-comment"></i>{{potof.said}}</div>
<td>{{potof.win_name}}::{{potof.role_names.join('、')}}<div class="note" ng-show="potof.select_name && potofs_is_small">{{potof.select_name}}</div>
<td><span ng-bind-html-unsafe="potof.text.join(' ')"></span><div class="note" ng-show="potof.bond_names && potofs_is_small">{{potof.bond_names.join('、')}}</div>
</tbody>
</table>
</div>
</div></div>
_HTML_
	return;
}

sub OutHTMLTools {
	my ($sow, $vil) = @_;
	print <<"_HTML_";
<div class="insayfilter" ng-show="navi.calc"><div class="paragraph">
<h4 class="sayfilter_caption_enable">村の進行状況</h4>
<div class="sayfilter_content"><ul>
<li>あと {{story.timer.extend}}回、更新を延長できる。
<li>{{lax_time(story.timer.nextupdatedt)}}に更新。
<li>{{lax_time(story.timer.nextchargedt)}}に補充。
<li>{{lax_time(story.timer.nextcommitdt)}}にコミット。
<li>{{lax_time(story.timer.scraplimitdt)}}に廃村。
</ul><br>
</div>
</div></div>
_HTML_
	return;
}
1;
