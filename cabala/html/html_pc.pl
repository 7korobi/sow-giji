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
    print "  <link rel=\"" . $alternate . "stylesheet\" type=\"text/css\" href=\"$cfg->{'DIR_CSS'}/$css->{$_}->{'FILE'}\" title=\"$css->{$_}->{'TITLE'}\"$net>\n";
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

  print <<"_HTML_";
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript">   google.load("jquery", "1");</script>
_HTML_
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

  my $classcontentframe = 'contentframe';
  if (($sow->{'query'}->{'cmd'} eq '') && (defined($sow->{'query'}->{'vid'})) && ($sow->{'query'}->{'logid'} eq '') && ($sow->{'filter'}->{'layoutfilter'} eq '1')) {
    $classcontentframe = 'contentframe_navileft';
  }

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

  my $cssid = 'default';
  $cssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
  $cssid = 'default' if (!defined($cfg->{'CSS'}->{$cssid}));
  my $css = $cfg->{'CSS'}->{$cssid};
  my %topbanner = (
    file   => $cfg->{'FILE_TOPBANNER'},
    width  => $cfg->{'TOPBANNER_WIDTH'},
    height => $cfg->{'TOPBANNER_HEIGHT'},
  );
  my $file_topbanner = ($css->{'FILE_TOPBANNER_N'},$css->{'FILE_TOPBANNER_D'})[((time-9*60*60)/(12*60*60))%2];
  $topbanner{'file'}   = $file_topbanner            if (defined($file_topbanner));
  $topbanner{'width'}  = $css->{'TOPBANNER_WIDTH'}  if (defined($css->{'TOPBANNER_WIDTH'}));
  $topbanner{'height'} = $css->{'TOPBANNER_HEIGHT'} if (defined($css->{'TOPBANNER_HEIGHT'}));

  print <<"_HTML_";
<div id="contentframe" class="$classcontentframe">

<h1>$titlestart<img src="$cfg->{'DIR_IMG'}/$topbanner{'file'}" width="$topbanner{'width'}" height="$topbanner{'height'}" alt="$cfg->{'NAME_SW'}"$net>$titleend</h1>

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
<form action="$urlsow" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="login">
<p>
  <input type="hidden" name="cmd" value="login"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
  <label>user id: <input type="text" size="10" name="uid" value="$sow->{'uid'}"$net></label>
  <label>password: <input type="password" size="10" name="pwd" value=""$net></label>
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
<form action="https://www.typekey.com/t/typekey/login" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="login">
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
    $uidtext = "<a href=\"$urluser\">$uidtext</a>";

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
<form action="$urlsow" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="login">
<p>
  <input type="hidden" name="cmd" value="logout"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden$linkadmin
  <span class="mes_date">���O�C������$sow->{'cookie_expires'}�܂ŗL���ł��B</span>
  user id: $uidtext
  <input type="submit" value="���O�A�E�g"$disabled$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
    } else {
      # TypeKey���O�A�E�g�t�H�[��
      $reqvals->{'cmd'} = 'logout';
      my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
      print <<"_HTML_";
<form action="https://www.typekey.com/t/typekey/logout" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="login">
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

#----------------------------------------
# ���t�A���J�[HTML�o��
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

  my $linktop = $amp."move=page".$amp."pageno=1";

  my $anklog = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues\">���O</a>";
  my $ankmemo = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=memo\">����</a>";
  my $ankmemohist = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=hist\">��������</a>";
# $ankmemo .= " <a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=memo&anonymous=on\">��������</a>";
  $ankmemo .= " <a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=memo&admin=on\">�Ǘ�����</a>"  if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});
  $ankmemo .= " <a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkmemo$amp" . "cmd=memo&maker=on\">��������</a>" if ($sow->{'uid'} eq $vil->{'makeruid'});
  $ankmemohist = '��������' if (($query->{'cmd'} eq 'hist') || ($query->{'cmd'} eq 'vinfo') || ($sow->{'turn'} > $vil->{'epilogue'}));
  $anklog = '���O' if (($query->{'cmd'} eq '') || ($query->{'cmd'} eq 'vinfo'));
  my $ankform = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew#newsay\">��������</a>";
  $ankform = '��������' if ($vil->{'turn'} > $vil->{'epilogue'});

  if (($position > 0) && ($sow->{'turn'} <= $vil->{'epilogue'}) && ($query->{'cmd'} ne 'vinfo')) {
    print "<p class=\"pagenavi\">\n";
    &OutHTMLPageNaviPC($sow, $vil, $logs, $list, $rows);
    print "[$ankmemo/$ankmemohist] / $ankform\n";
    print "</p>\n\n";
  }

  # ���_�؂�ւ����[�h�̎擾
  my ($mode, $modes, $modename) = &SWHtml::GetViewMode($sow);

  my $postmode = '';
  $postmode = $amp . "mode=$mode" if ($vil->{'epilogue'} < $vil->{'turn'});

  print "<p class=\"turnnavi\" id=\"$sow->{'turn'}\">\n";
  if ($query->{'cmd'} eq 'vinfo') {
    print "���\n";
  } else {
    print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew$amp" . "cmd=vinfo\">���</a>\n";
  }

  my $cmdlog = 0;
  $cmdlog = 1 if (($query->{'cmd'} eq '') || ($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist'));
  my $i;
  for ($i = 0; $i <= $vil->{'turn'}; $i++) {
    my $postturn = "";
    $postturn = $amp . "turn=$i" if ($i != $vil->{'turn'});
    my $turnname = "$i����";
    $turnname = "�v�����[�O" if ($i == 0);
    $turnname = "�G�s���[�O" if ($i == $vil->{'epilogue'});
    $turnname = "�I��" if ($i > $vil->{'epilogue'});

    if (($i == $sow->{'turn'}) && ($cmdlog > 0) && ($query->{'logid'} eq '')) {
        print "$turnname\n";
    } else {
      if ( $i == 0 ){
        print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkprologue$postturn$postmode".$linktop."\">$turnname</a>\n";
      } else {
        print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkturns$postturn$postmode".$linktop."\">$turnname</a>\n";
      }
    }
  }

  print <<"_HTML_";
/ <a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew#newsay">�ŐV</a>
</p>

_HTML_

  if (($position == 0) && ($sow->{'turn'} <= $vil->{'epilogue'}) && ($query->{'cmd'} ne 'vinfo')) {
    print "<p class=\"pagenavi\">\n";
    &OutHTMLPageNaviPC($sow, $vil, $logs, $list, $rows);
    print "[$ankmemo/$ankmemohist] / $ankform\n";
    print "</p>\n\n";
  }

  # ���_�؂�ւ�
  if ($vil->{'epilogue'} < $vil->{'turn'}) {
    print "<p class=\"turnnavi\">\n���_�F\n";
    my $postturn = $amp . "turn=$sow->{'turn'}";
    my $i;
    for ($i = 0; $i < @$modes; $i++) {
      if ($mode eq $modes->[$i]) {
        print "$modename->[$i]\n";
      } else {
        print "<a href=\"$sow->{'cfg'}->{'FILE_SOW'}?$linkmodes$postturn$amp"."$linktop$amp". "mode=$modes->[$i]\">$modename->[$i]</a>\n";
      }
    }
  print "</p>\n\n";
  }
  return;
}

#----------------------------------------
# �y�[�W�����NHTML�o��
#----------------------------------------
sub OutHTMLPageNaviPC {
  my ($sow, $vil, $logs, $list, $rows) = @_;
  my $cfg   = $sow->{'cfg'};
  my $query = $sow->{'query'};
  my $net   = $sow->{'html'}->{'net'};
  my $amp   = $sow->{'html'}->{'amp'};

  if (!defined($logs)) {
    my @logs;
    $logs = \@logs;
  }
  if (!defined($rows)) {
    $rows = {
      start => 0,
      end   => 0,
    };
  }


  my $reqvals = &SWBase::GetRequestValues($sow);
  $reqvals->{'cmd'} = '';
  my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
  my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues";

  # �����O�̃J�E���g
  my ($pages, $indexno) = &SWHtml::GetPagesPermit($sow, $logs, $list);

  # �s���̎擾
  my $row = $cfg->{'MAX_ROW'};
  $row = $query->{'row'} if (defined($query->{'row'}));
  $row = $cfg->{'MAX_ROW'} if ($row <= 0);

  my $maxpage = int((@$pages + $row - 1) / $row); # �ő�y�[�W
  my $maxrow = $maxpage;

  # �ŏ��ɕ\������y�[�W�����N�ԍ�
  my $firstpage = 0;

  my $i;
  my $endpage = int($indexno / $row);
  $endpage = $query->{'pageno'} - 1 if (defined($query->{'pageno'}));
  $endpage = $firstpage + $maxrow - 1 if (($rows->{'end'} != 0) || (!defined($logs->[$#$logs])));
  $endpage = -1 if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist') || ($query->{'rowall'} ne ''));
  for ($i = $firstpage; $i < $firstpage + $maxrow; $i++) {
    my $pageno = $i + 1;
    if (($i == $endpage) || ($query->{'cmd'} eq 'vinfo')) {
      print " $pageno ";
    } else {
      my $log = $pages->[$i * $row];
      my $logid = $log->{'logid'};
      $logid = $log->{'maskedid'} if (($vil->isepilogue() == 0) && (defined($log->{'maskedid'})) && (($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) || ($log->{'mestype'} == $sow->{'MESTYPE_TSAY'})));
      print " <a href=\"$urlsow$amp" . "move=page$amp" . "pageno=$pageno\">$pageno</a> ";
    }
    if ($i < $firstpage + $maxrow - 1) {
      print "\n";
    } else {
      print "\n";
    }
  }
}

#----------------------------------------
# �^�C�g���̊J�n�^�X�V�\�莞��
#----------------------------------------
sub GetTitleNextUpdate {
  my ($sow, $vil) = @_;

  my $title = '';
   if (($vil->{'starttype'} eq 'wbbs') || ($vil->{'turn'} > 0)) {
    my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
    my $extend = '����' . $vil->{'extend'} . '��܂ŁB' if $vil->{'extend'};
    $title = " ($date �ɍX�V�B $extend)";
  } else {
    $title = ' (' . sprintf("%02d:%02d", $vil->{'updhour'}, $vil->{'updminite'}) . '�X�V)';
  }

  return $title;
}

1;
