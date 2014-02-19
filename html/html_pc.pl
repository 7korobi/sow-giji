package SWHtmlPC;

#----------------------------------------
# PCモード用のHTML出力
#----------------------------------------

#----------------------------------------
# HTMLヘッダの出力
#----------------------------------------
sub OutHTMLHeaderPC {
  my ($sow, $title) = @_;
  my $net = $sow->{'html'}->{'net'};
  my $cfg = $sow->{'cfg'};
  my $cookie = $sow->{'cookie'};

  $title = $title . ' - ' if ($title ne '');

  my $css = $sow->{'cfg'}->{'CSS'};
  my @csskey = keys(%$css);
  my $alternate = '';
  my $cssid = 'default';
  $cssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
  $cssid = 'default' if (!defined($css->{$cssid}));

  print "<head>\n";

  # Content-Type / Content-Style-Type の出力
  # 通常はHTTPに出力するので不要
  if ($sow->{'cfg'}->{'OUTPUT_HTTP_EQUIV'} > 0) {
    print "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=Shift_JIS\"$net>\n" if ($sow->{'http'}->{'contenttype'} eq 'html');
    print "  <meta http-equiv=\"Content-Style-Type\" content=\"$sow->{'http'}->{'styletype'}\"$net>\n" if ($sow->{'http'}->{'styletype'} ne '');
    print "  <meta http-equiv=\"Content-Script-Type\" content=\"$sow->{'http'}->{'scripttype'}\"$net>\n" if ($sow->{'http'}->{'scripttype'} ne '');
  }

  my $robots = $sow->{'cfg'}->{'ROBOTS'};
  foreach (@$robots) {
    print "  <meta name=\"robots\" content=\"$_\"$net>\n";
  }

  print <<"_HTML_";
  <meta name="Author" content="$sow->{'NAME_AUTHOR'}"$net>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

<!--[if lt IE 9]>
  <script src="$cfg->{'BASEDIR_DOC'}//javascripts/json3.min.js"></script>
  <script src="$cfg->{'BASEDIR_DOC'}//javascripts/jquery-1.10.2.min.js"></script>
<![endif]-->
<!--[if (gte IE 9)|!(IE)]><!-->
  <script src="$cfg->{'BASEDIR_DOC'}/javascripts/jquery-2.0.3.min.js"></script>
<!--<![endif]-->

  <link rel="shortcut icon" href="$cfg->{'BASEDIR_DOC'}/$cfg->{'FILE_FAVICON'}"$net>
_HTML_

  # スタイルシートの出力
  my $css   = $cookie->{'theme'} . $cookie->{'width'};
  my $css ||= "cinema800";
  print "  <link id=\"giji_css\"      href=\"$sow->{'cfg'}->{'DIR_CSS'}/$css.css\" rel=\"stylesheet\" type=\"text/css\">\n";
  print "  <link id=\"giji_css_font\" href=\"$sow->{'cfg'}->{'DIR_CSS'}/font/normal.css\" rel=\"stylesheet\" type=\"text/css\">\n";

  # RSSの出力
  if (($sow->{'html'}->{'rss'} ne '') && ($cfg->{'ENABLED_RSS'} > 0)) {
    print "  <link rel=\"Alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"$sow->{'html'}->{'rss'}\"$net>\n";
  }

  # ナビゲーションの出力
  my $url_home = $cfg->{'URL_SW'} . '/sow.cgi';
  print <<"_HTML_";
  <link rev="Made" href="mailto:$sow->{'MAIL_AUTHOR'}"$net>
  <link rel="Start" href="$url_home" title="$cfg->{'NAME_HOME'}"$net>
_HTML_

  # link要素の出力
  foreach (@{$sow->{'html'}->{'links'}}) {
    print "  <link rel=\"$_->{'rel'}\" href=\"$_->{'url'}\" title=\"$_->{'title'}\"$net>\n";
  }

  # JavaScriptの出力
  if (defined($sow->{'html'}->{'file_js'})) {
    my $file_js = $sow->{'html'}->{'file_js'};
    foreach (@$file_js) {
      print "  <script type=\"text/javascript\" src=\"$cfg->{'BASEDIR_DOC'}/$_\" charset=\"UTF-8\"></script>\n";
    }
  }

  # タイトルの出力
  print <<"_HTML_";
<title>$title$cfg->{'NAME_HOME'}</title>
</head>
_HTML_

  # body要素開始タグの出力
  print "<body";
  my $bodyjs = $sow->{'html'}->{'bodyjs'};
  my @bodyjskeys = keys(%$bodyjs);
  foreach (@bodyjskeys) {
    print " $_=\"$bodyjs->{$_}\"";
  }
  print ">\n";

  # 外枠
  print <<"_HTML_";

<div id="outframe" class="outframe">
_HTML_

}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）ヘッダの表示
#----------------------------------------
sub OutHTMLContentFrameHeader {
  my $sow = shift;
  my $net   = $sow->{'html'}->{'net'};
  my $cfg   = $sow->{'cfg'};
  my $query = $sow->{'query'};
  my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

  my $reqvals = &SWBase::GetRequestValues($sow);
  $reqvals->{'vid'} = '';
  $reqvals->{'turn'} = '';
  my $link = &SWBase::GetLinkValues($sow, $reqvals);

  my $titlestart = "<a href=\"$urlsow?$link\">";
  my $titleend = '</a>';
  if (($query->{'cmd'} eq 'entrypr') || ($query->{'cmd'} eq 'writepr')) {
    $titlestart = '';
    $titleend = '';
  }

  print <<"_HTML_";
<div id="contentframe" class="contentframe">
<h1>$titlestart<img ng-src="{{h1.path}}" ng-cloak $net>$titleend</h1>

<div class="inframe">
_HTML_

}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）フッタの表示
#----------------------------------------
sub OutHTMLContentFrameFooter {
  my $sow = $_[0];
  my $net = $sow->{'html'}->{'net'};
  my $atr_id = $sow->{'html'}->{'atr_id'};

  print <<"_HTML_";
<address>
<a $atr_id="bottom">$sow->{'VERSION_SW'}</a> <a href="$sow->{'URL_AUTHOR'}">$sow->{'COPY_AUTHOR'}</a><br$net>
_HTML_

  my $copyrights = $sow->{'cfg'}->{'COPYRIGHTS'};
  foreach (@$copyrights) {
    print "$_<br$net>\n";
  }

  print <<"_HTML_";
</address>
</div><!-- inframe footer -->
</div><!-- contentframe footer -->
_HTML_

}

#----------------------------------------
# HTMLフッタの出力
#----------------------------------------
sub OutHTMLFooterPC {
  my $sow = $_[0];
  my $cput = int($_[1] * 1000) / 1000;
  my $net = $sow->{'html'}->{'net'};

  print <<"_HTML_";
($cput CPUs)
</div>
</body>
<script>
\$(function(){\$('.finished_log').hide()});
</script>
</html>
_HTML_
}

#----------------------------------------
# ログイン欄HTML出力
#----------------------------------------
sub OutHTMLLogin {
  my $sow = $_[0];
  my $query = $sow->{'query'};
  my $cfg   = $sow->{'cfg'};
  my $net   = $sow->{'html'}->{'net'};

  my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
  my $reqvals = &SWBase::GetRequestValues($sow);
  my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

  print <<"_HTML_";
<div template="sow/login" ng-show="form.login"></div>
<hr class="invisible_hr"$net>
_HTML_
}

sub OutHTMLGonInit {
  my $sow = $_[0];
  my $cfg = $sow->{'cfg'};
  my $uid = $sow->{'uid'};
  my $path = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
  my $cmdfrom = $query->{'cmd'};
  my $logined = $sow->{'user'}->logined() + 0;
  my $expired = $sow->{'time'} + $cfg->{'TIMEOUT_COOKIE'};
  my $is_admin = ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'}) + 0;
  my $admin_uri = $path."?cmd=admin" if ($is_admin);

  print <<"_HTML_";
<script>
window.gon = \$.extend(true, {}, OPTION.gon);
gon.form.login = {
  "cmd": "login",
  "admin_uri": "$admin_uri",
  "is_admin": $is_admin,
  "cmdfrom": "$cmdfrom",
  "expired": new Date(1000 * $expired),
  "uidtext": "$uid".replace(" ","&nbsp;"),
  "uid": "$uid"
}
gon.form.uri = "$path";
_HTML_
}

#----------------------------------------
# 「トップページに戻る」HTML出力
#----------------------------------------
sub OutHTMLReturnPC {
  my $sow = $_[0];
  my $cfg = $sow->{'cfg'};
  my $net = $sow->{'html'}->{'net'};

  my $reqvals = &SWBase::GetRequestValues($sow);
  $reqvals->{'cmd'} = '';
  $reqvals->{'vid'} = '';
  $reqvals->{'turn'} = '';
  $reqvals->{'mode'} = ''; # 応急処置
  my $link = &SWBase::GetLinkValues($sow, $reqvals);

  print <<"_HTML_";
<p class="return">
<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">トップページに戻る</a>
</p>
<hr class="invisible_hr"$net>

_HTML_
}

#----------------------------------------
# スタイル変更
#----------------------------------------
sub OutHTMLChangeCSS {
  my $sow = $_[0];
  my $cfg = $sow->{'cfg'};
  my $theme = $cfg->{'THEME'};

  print <<"_HTML_";
<div class="choice">
<p style="text-align:right; font-size: 100%;" theme="$theme">
<span><a href="sow.cgi?ua=mb">携帯</a></span>
｜

</p>
</div>
_HTML_
}

1;
