package SWHtmlPC;

#----------------------------------------
# PCモード用のHTML出力
#----------------------------------------

#----------------------------------------
# HTMLヘッダの出力
#----------------------------------------
sub OutHTMLHeaderPC {
  my ($sow, $title) = @_;
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
    print "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=Shift_JIS\">\n" if ($sow->{'http'}->{'contenttype'} eq 'html');
    print "  <meta http-equiv=\"Content-Style-Type\" content=\"$sow->{'http'}->{'styletype'}\">\n" if ($sow->{'http'}->{'styletype'} ne '');
    print "  <meta http-equiv=\"Content-Script-Type\" content=\"$sow->{'http'}->{'scripttype'}\">\n" if ($sow->{'http'}->{'scripttype'} ne '');
  }

  my $robots = $sow->{'cfg'}->{'ROBOTS'};
  foreach (@$robots) {
    print "  <meta name=\"robots\" content=\"$_\">\n";
  }

  print <<"_HTML_";
  <meta name="Author" content="$sow->{'NAME_AUTHOR'}">
  <meta content="yes" name="apple-mobile-web-app-capable" />
  <meta content="black-translucent" name="apple-mobile-web-app-status-bar-style" />
  <meta content="telephone=no" name="format-detection" />
  <meta content="initial-scale=1.0" name="viewport" />

  <link rel="shortcut icon" href="$cfg->{'BASEDIR_DOC'}/$cfg->{'FILE_FAVICON'}">
_HTML_

  # スタイルシートの出力
  if (defined($sow->{'html'}->{'file_css'})) {
    my $file_css = $sow->{'html'}->{'file_css'};
    foreach (@$file_css) {
      print "  <link href=\"$cfg->{'BASEDIR_DOC'}/$_\" rel=\"stylesheet\" type=\"text/css\">\n";
    }
  }

  # RSSの出力
  if (($sow->{'html'}->{'rss'} ne '') && ($cfg->{'ENABLED_RSS'} > 0)) {
    print "  <link rel=\"Alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"$sow->{'html'}->{'rss'}\">\n";
  }

  # ナビゲーションの出力
  my $url_home = $cfg->{'URL_SW'} . '/sow.cgi';
  print <<"_HTML_";
  <link rev="Made" href="mailto:$sow->{'MAIL_AUTHOR'}">
  <link rel="Start" href="$url_home" title="$cfg->{'NAME_HOME'}">
_HTML_

  # link要素の出力
  foreach (@{$sow->{'html'}->{'links'}}) {
    print "  <link rel=\"$_->{'rel'}\" href=\"$_->{'url'}\" title=\"$_->{'title'}\">\n";
  }

  # タイトルの出力
  print <<"_HTML_";
<title>$title$cfg->{'NAME_HOME'}</title>
</head>
<body>
<div id="outframe" class="outframe">
_HTML_

}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）ヘッダの表示
#----------------------------------------
sub OutHTMLContentFrameHeader {
  my $sow = shift;
  my $cfg   = $sow->{'cfg'};
  my $query = $sow->{'query'};
  my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

  my $reqvals = &SWBase::GetRequestValues($sow);
  $reqvals->{'vid'} = '';
  $reqvals->{'turn'} = '';
  my $link = &SWBase::GetLinkValues($sow, $reqvals);

  my $titlestart = "<a tabindex=\"-1\" href=\"$urlsow?$link\">";
  my $titleend = '</a>';
  if (($query->{'cmd'} eq 'entrypr') || ($query->{'cmd'} eq 'writepr')) {
    $titlestart = '';
    $titleend = '';
  }

  print <<"_HTML_";
<div id="contentframe" class="contentframe">
<h1 id="to_root"></h1>
<div class="inframe">
_HTML_

}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）フッタの表示
#----------------------------------------
sub OutHTMLContentFrameFooter {
  my $sow = $_[0];
  my $atr_id = $sow->{'html'}->{'atr_id'};

  print <<"_HTML_";
<address>
<a tabindex="-1" $atr_id="bottom">$sow->{'VERSION_SW'}</a> <a tabindex="-1" href="$sow->{'URL_AUTHOR'}">$sow->{'COPY_AUTHOR'}</a><br>
_HTML_

  my $copyrights = $sow->{'cfg'}->{'COPYRIGHTS'};
  foreach (@$copyrights) {
    print "$_<br>\n";
  }

  print <<"_HTML_";
</address>
</div><!-- inframe footer -->
</div><!-- contentframe footer -->
<div id="footer"></div>
<div id="tab">
  <div id="topviewer"></div>
  <div id="sayfilter"></div>
  <div id="buttons"></div>
</div>
_HTML_

}

#----------------------------------------
# HTMLフッタの出力
#----------------------------------------
sub OutHTMLFooterPC {
  my $sow = $_[0];
  my $cput = int($_[1] * 1000) / 1000;

  print <<"_HTML_";
($cput CPUs)
</div>
</body>
_HTML_

  # JavaScriptの出力
  if (defined($sow->{'html'}->{'file_js'})) {
    my $file_js = $sow->{'html'}->{'file_js'};
    foreach (@$file_js) {
      print "  <script type=\"text/javascript\" src=\"$cfg->{'BASEDIR_DOC'}/$_\" charset=\"UTF-8\"></script>\n";
    }
  }
  print <<"_HTML_";
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

  my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
  my $reqvals = &SWBase::GetRequestValues($sow);
  my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

  print <<"_HTML_";
<div class="login" id="headline"></div>
<div class="paragraph" id="sow_auth"></div>
<div id="css_changer"></div>
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
window.gon = {
  form: {
    texts: [],
    secrets: [],
		commands: {}
  },
  cautions: [],
  url: "$path"
}

window.gon.sow_auth = {
  cmd: "login",
  cmdfrom: "$cmdfrom",
  uid: "$uid",
  is_login: $logined,
  is_admin: $is_admin,
  admin_uri: "$admin_uri",
  expired: new Date(1000 * $expired)
};
_HTML_
}



#----------------------------------------
# 「トップページに戻る」HTML出力
#----------------------------------------
sub OutHTMLReturnPC {
  my $sow = $_[0];
  my $cfg = $sow->{'cfg'};

  my $reqvals = &SWBase::GetRequestValues($sow);
  $reqvals->{'cmd'} = '';
  $reqvals->{'vid'} = '';
  $reqvals->{'turn'} = '';
  $reqvals->{'mode'} = ''; # 応急処置
  my $link = &SWBase::GetLinkValues($sow, $reqvals);

  print <<"_HTML_";
<p class="btn edge">
<a tabindex="-1" href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">トップページに戻る</a>
</p>
<hr class="black">

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
<div class="choice css_changer"></div>
_HTML_
}

1;
