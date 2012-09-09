package SWHtmlPC;

#----------------------------------------
# PC���[�h�p��HTML�o��
#----------------------------------------

#----------------------------------------
# HTML�w�b�_�̏o��
#----------------------------------------
sub OutHTMLHeaderPC {
  my ($sow, $title) = @_;
  my $net = $sow->{'html'}->{'net'};
  my $cfg = $sow->{'cfg'};

  $title = $title . ' - ' if ($title ne '');

  my $css = $sow->{'cfg'}->{'CSS'};
  my @csskey = keys(%$css);
  my $alternate = '';
  my $cssid = 'default';
  $cssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
  $cssid = 'default' if (!defined($css->{$cssid}));

  print "<head>\n";

  # Content-Type / Content-Style-Type �̏o��
  # �ʏ��HTTP�ɏo�͂���̂ŕs�v
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
  <meta name="viewport" content="width=device-width, user-scalable=yes">
  <link rel="shortcut icon" href="$cfg->{'BASEDIR_DOC'}/$cfg->{'FILE_FAVICON'}"$net>
_HTML_

  # �X�^�C���V�[�g�̏o��
  foreach (@csskey) {
    next if ($_ ne $cssid); # alternate�͎�肠������~��
    $alternate = 'alternate ';
    $alternate = '' if ($_ eq $cssid);
    print "  <link rel=\"" . $alternate . "stylesheet\" type=\"text/css\" href=\"{{css}}\"$net>\n";
  }

  # RSS�̏o��
  if (($sow->{'html'}->{'rss'} ne '') && ($cfg->{'ENABLED_RSS'} > 0)) {
    print "  <link rel=\"Alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"$sow->{'html'}->{'rss'}\"$net>\n";
  }

  # �i�r�Q�[�V�����̏o��
  my $url_home = $cfg->{'URL_SW'} . '/sow.cgi';
  print <<"_HTML_";
  <link rev="Made" href="mailto:$sow->{'MAIL_AUTHOR'}"$net>
  <link rel="Start" href="$url_home" title="$cfg->{'NAME_HOME'}"$net>
_HTML_

  # link�v�f�̏o��
  foreach (@{$sow->{'html'}->{'links'}}) {
    print "  <link rel=\"$_->{'rel'}\" href=\"$_->{'url'}\" title=\"$_->{'title'}\"$net>\n";
  }

  # JavaScript�̏o��
  if (defined($sow->{'html'}->{'file_js'})) {
    my $file_js = $sow->{'html'}->{'file_js'};
    foreach (@$file_js) {
      print "  <script type=\"text/javascript\" src=\"$cfg->{'DIR_JS'}/$_\"></script>\n";
    }
  }

  # �^�C�g���̏o��
  print <<"_HTML_";
<title>$title$cfg->{'NAME_HOME'}</title>
</head>
_HTML_

  # body�v�f�J�n�^�O�̏o��
  print "<body";
  my $bodyjs = $sow->{'html'}->{'bodyjs'};
  my @bodyjskeys = keys(%$bodyjs);
  foreach (@bodyjskeys) {
    print " $_=\"$bodyjs->{$_}\"";
  }
  print ">\n";

  # �O�g
  my $classoutframe = 'outframe';
  if (($sow->{'query'}->{'cmd'} eq '') && (defined($sow->{'query'}->{'vid'})) && ($sow->{'query'}->{'logid'} eq '') && ($sow->{'filter'}->{'layoutfilter'} eq '1')) {
    $classoutframe = 'outframe_navimode';
  }
  print <<"_HTML_";

<div id="outframe" class="$classoutframe">
_HTML_

}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�w�b�_�̕\��
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
<div id="contentframe">
<h1>$titlestart<img ng-src="{{h1.path}}" ng-cloak $net>$titleend</h1>

<div class="inframe">
_HTML_

}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�t�b�^�̕\��
#----------------------------------------
sub OutHTMLContentFrameFooter {
  my $sow = $_[0];

  print <<"_HTML_";
</div><!-- inframe footer -->
</div><!-- contentframe footer -->

_HTML_

}

#----------------------------------------
# HTML�t�b�^�̏o��
#----------------------------------------
sub OutHTMLFooterPC {
  my $sow = $_[0];
  my $cput = int($_[1] * 1000) / 1000;

  my $net = $sow->{'html'}->{'net'};
  my $atr_id = $sow->{'html'}->{'atr_id'};

  print <<"_HTML_";
<div class="inframe">
<address>
($cput CPUs)<br$net>
<a $atr_id="bottom">$sow->{'VERSION_SW'}</a> <a href="$sow->{'URL_AUTHOR'}">$sow->{'COPY_AUTHOR'}</a><br$net>
_HTML_

  my $copyrights = $sow->{'cfg'}->{'COPYRIGHTS'};
  foreach (@$copyrights) {
    print "$_<br$net>\n";
  }

  print <<"_HTML_";
</address>
</div>

</div>
</body>
</html>
_HTML_
}

#----------------------------------------
# ���O�C����HTML�o��
#----------------------------------------
sub OutHTMLLogin {
  my $sow = $_[0];
  my $query = $sow->{'query'};
  my $cfg   = $sow->{'cfg'};
  my $net   = $sow->{'html'}->{'net'};

  my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
  my $reqvals = &SWBase::GetRequestValues($sow);
  my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');
  if ($sow->{'user'}->logined() <= 0) {
    # �����O�C��
    my $disabled = '';
    $disabled = " $sow->{'html'}->{'disabled'}" if (($query->{'prof'} ne '') || ($query->{'cmd'} eq 'editprofform') || ($query->{'cmd'} eq 'editprof'));
    if ($cfg->{'ENABLED_TYPEKEY'} <= 0) {
      # �ʏ�̃��O�C���t�H�[��
      print <<"_HTML_";
<form action="$urlsow" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="form-inline">
<p>
  <input type="hidden" name="cmd" value="login"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
  <label>user id: <input class="input-small" type="text" size="10" name="uid" value="$sow->{'uid'}"$net></label>
  <label>password: <input class="input-small" type="password" size="10" name="pwd" value=""$net></label>
  <input type="submit" value="���O�C��"$disabled$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
    } else {
      # TypeKey���O�C���t�H�[��
      $reqvals->{'cmd'} = 'login';
      my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
      print <<"_HTML_";
<form action="https://www.typekey.com/t/typekey/login" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="form-inline">
<p>
  <input type="hidden" name="t" value="$sow->{'cfg'}->{'TOKEN_TYPEKEY'}"$net>
  <input type="hidden" name="need_email" value="0"$net>
  <input type="hidden" name="_return" value="$sow->{'cfg'}->{'URL_SW'}/$sow->{'cfg'}->{'FILE_SOW'}?$linkvalue"$net>
  <input type="hidden" name="v" value="1.1"$net>
  <input type="submit" value="���O�C��"$disabled$net>
  (<a href="http://www.sixapart.jp/typekey/">TypeKey</a>)
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
    }
  } else {
    # ���O�C���ς�
    my %link = (
      'user' => $sow  ->{'uid'},
      'css'  => $query->{'css'},
    );
    my $urluser = $cfg->{'URL_USER'}.'?'.&SWBase::GetLinkValues($sow, \%link);
    my $uidtext = $sow->{'uid'};
    $uidtext =~ s/ /&nbsp\;/g;

    my $disabled = '';
    $disabled = " $sow->{'html'}->{'disabled'}" if (($query->{'cmd'} eq 'entrypr') || ($query->{'cmd'} eq 'writepr') || ($query->{'prof'} ne '') || ($query->{'cmd'} eq 'editprofform') || ($query->{'cmd'} eq 'editprof'));

    $reqvals->{'prof'} = '';
    $reqvals->{'cmd'} = 'admin';
    $link = &SWBase::GetLinkValues($sow, $reqvals);
    my $linkadmin = '';
    $linkadmin = "\n  [<a href=\"$urlsow?$link\">�Ǘ����</a>] / " if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});

    if ($sow->{'cfg'}->{'ENABLED_TYPEKEY'} <= 0) {
      # �ʏ�̃��O�A�E�g�t�H�[��
      print <<"_HTML_";
<form action="$urlsow" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="form-inline">
<p>
  <input type="hidden" name="cmd" value="logout"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden$linkadmin
  <span class="mes_date">���O�C������$sow->{'cookie_expires'}�܂ŗL���ł��B</span>
  <input type="submit" value="$uidtext �����O�A�E�g"$disabled$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
    } else {
      # TypeKey���O�A�E�g�t�H�[��
      $reqvals->{'cmd'} = 'logout';
      my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
      print <<"_HTML_";
<form action="https://www.typekey.com/t/typekey/logout" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="form-inline">
<p>
  <input type="hidden" name="_return" value="$sow->{'cfg'}->{'URL_SW'}/$sow->{'cfg'}->{'FILE_SOW'}?$linkvalue"$net>$linkadmin
  user id: $uidtext
  <input type="submit" value="���O�A�E�g"$disabled$net>
  (<a href="http://www.sixapart.jp/typekey/">TypeKey</a>)
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
    }
  }
}

#----------------------------------------
# �u�g�b�v�y�[�W�ɖ߂�vHTML�o��
#----------------------------------------
sub OutHTMLReturnPC {
  my $sow = $_[0];
  my $cfg = $sow->{'cfg'};
  my $net = $sow->{'html'}->{'net'};

  my $reqvals = &SWBase::GetRequestValues($sow);
  $reqvals->{'cmd'} = '';
  $reqvals->{'vid'} = '';
  $reqvals->{'turn'} = '';
  $reqvals->{'mode'} = ''; # ���}���u
  my $link = &SWBase::GetLinkValues($sow, $reqvals);

  print <<"_HTML_";
<p class="return">
<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">�g�b�v�y�[�W�ɖ߂�</a>
</p>
<hr class="invisible_hr"$net>

_HTML_
}

#----------------------------------------
# �L�����摜�A�h���X�̎擾
#----------------------------------------
sub GetImgUrl {
  my ($sow, $imgpl, $imgparts, $expression) = @_;

  my $charset = $sow->{'charsets'}->{'csid'}->{$imgpl->{'csid'}};

  $imgparts = '' if ($charset->{'BODY'} eq '');
  my $imgid = $imgpl->{'cid'};

  if (@{$charset->{'EXPRESSION'}} == 0) {
    $expression = '';
  } else {
    if (defined($expression)) {
      $expression = "_$expression";
    } else {
      $expression = "_0";
    }
  }

  $imgid = $charset->{'GRAVE'} if (($imgpl->{'deathday'} <= $sow->{'turn'}) && ($imgpl->{'deathday'} >= 0) && ($charset->{'GRAVE'} ne '')); # ��Ε\��
  my $img = "$charset->{'DIR'}/$imgid$imgparts$expression$charset->{'EXT'}";

  return $img;
}

#----------------------------------------
# �N���X�����o��
#----------------------------------------
sub OutHTMLMesStyle {
  my ($sow, $vil, $log) = @_;

  my @messtyle_table = (
    'mes_undef',    # MESTYPE_UNDEF
    'infosp',       # MESTYPE_INFOSP
    'mes_deladmin', # MESTYPE_DELETEDADMIN
    'mes_undef',    # MESTYPE_CAST
    'mes_maker',    # MESTYPE_MAKER
    'mes_admin',    # MESTYPE_ADMIN
    'mes_queue',    # MESTYPE_QUEUE
    'info',         # MESTYPE_INFONOM
    'mes_del',      # MESTYPE_DELETED
    'mes_nom',      # MESTYPE_SAY
    'mes_think',    # MESTYPE_TSAY
    'mes_wolf',     # MESTYPE_WSAY
    'mes_grave',    # MESTYPE_GSAY
    'mes_sympa',    # MESTYPE_SPSAY
    'mes_pixi',     # MESTYPE_XSAY
    'mes_mob',      # MESTYPE_VSAY
    'mes_nom',      # MESTYPE_MSAY
    'mes_sympa',    # MESTYPE_AIM
    'mes_anonymous',# MESTYPE_ANONYMOUS
    'infowolf',     # MESTYPE_INFOSP
  );

  my $messtyle = $messtyle_table[$log->{'mestype'}];
  if($log->{'mestype'} == $sow->{'MESTYPE_VSAY'}){
    $messtyle = 'mes_mob';
    $messtyle = 'mes_grave' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'grave'  ));
    $messtyle = 'mes_sympa' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'visiter'));
    $messtyle = 'mes_sympa' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'juror'  ));
  }

  return $messtyle;
}

#----------------------------------------
# ������textarea�v�f�̏o��
#----------------------------------------
sub OutHTMLSayTextAreaPC {
  my ($sow, $cmd, $htmlsay) = @_;
  my $net = $sow->{'html'}->{'net'};

  my $reqvals = &SWBase::GetRequestValues($sow);
  my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');
  my $text = '';
  $text = $htmlsay->{'text'} if (defined($htmlsay->{'text'}));

  my $disabled = '';
  $disabled = " $sow->{'html'}->{'disabled'}" if ($htmlsay->{'disabled'} > 0);

  print <<"_HTML_";
      <textarea name="mes" cols="30" rows="5">$text</textarea><br$net>
      <input type="hidden" name="cmd" value="$cmd"$net>$hidden
      <input type="submit" value="$htmlsay->{'buttonlabel'}"$disabled$net>$htmlsay->{'saycnttext'}
_HTML_

  return;
}

1;
