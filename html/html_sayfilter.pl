package SWHtmlSayFilter;

#----------------------------------------
# �����t�B���^�̕\��
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
<div id="tab" template="sow/navi"></div>
_HTML_
  OutHTMLTurnLink($sow, $vil);
  return;
}

sub OutHTMLTurnLink {
  my ($sow, $vil) = @_;
	return;
}

sub OutHTMLFooter {
	my ($sow, $vil) = @_;
	return;
}

sub OutHTMLSayFilter {
	my ($sow, $vil) = @_;
	return;
}

sub OutHTMLTools {
	my ($sow, $vil) = @_;
	return;
}
1;
