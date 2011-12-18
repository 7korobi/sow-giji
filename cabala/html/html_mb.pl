package SWHtmlMb;

#----------------------------------------
# HTML�w�b�_�̏o��
#----------------------------------------
sub OutHTMLHeaderMb {
	my ($sow, $title) = @_;
	my $net = $sow->{'html'}->{'net'};
	$title = $title . ' - ' if ($title ne '');

	print <<"_HTML_";
<head>
  <title>$title$sow->{'cfg'}->{'NAME_HOME'}</title>
</head>

<body>

_HTML_
}

#----------------------------------------
# HTML�t�b�^�̏o��
#----------------------------------------
sub OutHTMLFooterMb {

	print <<"_HTML_";
</body>
</html>
_HTML_
}

#----------------------------------------
# �u�g�b�v�y�[�W�ɖ߂�vHTML�o��
#----------------------------------------
sub OutHTMLReturnMb {
	my $sow = shift;
	my $cfg = $sow->{'cfg'};

	print <<"_HTML_";
<p><a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}">�߂�</a></p>
_HTML_
}

#----------------------------------------
# �����O�֖߂�HTML�o��
#----------------------------------------
sub OutHTMLReturnVilMb {
	my ($sow, $vil, $position) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = $query->{'cmdfrom'} if ($query->{'cmdfrom'} ne '');
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');
	my $accesskey = '';
	$accesskey = ' accesskey="4"' if ($position == 0);

	print "<a href=\"$link\"$accesskey>�߂�</a><br$net>\n";
}

#----------------------------------------
# ���t�A���J�[HTML�o��
#----------------------------------------
sub OutHTMLTurnNaviMb {
	my ($sow, $vil, $position, $logs, $list, $rows) = @_;
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};
	my $net    = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $amp    = $sow->{'html'}->{'amp'};

	my $urlsow     = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals    = &SWBase::GetRequestValues($sow);
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $urldefault = "$urlsow?$linkvalues";

	if (!defined($logs)) {
		my @logs;
		$logs = \@logs;
	}

	if (!defined($rows)) {
		$rows = {
			start => 0,
			end   => 0,
		}
	}

	# ���_�؂�ւ����[�h�̎擾
	my ($mode, $modes, $modename) = &SWHtml::GetViewMode($sow);

	# ���̏��ւ̃����N
	$reqvals->{'turn'} = '';
	$linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	if ($query->{'cmd'} eq 'vinfo') {
		print "���/\n";
	} else {
		print "<a href=\"$urlsow?$linkvalues$amp" . "c=vinfo\" accesskey=\"9\">���</a>/\n";
	}

	# ���t�����N
	&OutHTMLDayNaviMb($sow, $vil);

	# ���O�^�����؂�ւ������N
	my $linklog = "<a href=\"$urldefault\">���O</a>";
	$linklog = "<a href=\"$urldefault\" accesskey=\"*\">���O</a>" if ($position == 0);
	my $linkmemo = "<a href=\"$urldefault$amp" . "c=memo\">����</a>";
	$linkmemo = "<a href=\"$urldefault$amp" . "c=memo\" accesskey=\"0\">����</a>" if ($position == 0);
#	$linkmemo .= "<a href=\"$urldefault$amp" . "c=memo$amp" . "anonymous=on\" accesskey=\"0\">��</a>" if ($position == 0);
	my $linkmemohist = "<a href=\"$urldefault$amp" . "cmd=hist\">����</a>";
	$linkmemohist = "<a href=\"$urldefault$amp" . "cmd=hist\" accesskey=\"#\">����</a>" if ($position == 0);
	my $linkvindex = "<a href=\"$urlsow?$linkvalues$amp" . "cmd=vindex\">���ꗗ</a>";
	$linkmemo = '����' if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'vinfo') || ($sow->{'turn'} > $vil->{'epilogue'}));
	$linkmemohist = '��������' if (($query->{'cmd'} eq 'hist') || ($query->{'cmd'} eq 'vinfo') || ($sow->{'turn'} > $vil->{'epilogue'}));
	$linklog = '���O' if (($query->{'cmd'} eq '') || ($query->{'cmd'} eq 'vinfo'));
	print "$linklog/$linkmemo/$linkmemohist/$linkvindex<br$net>\n";

	# ���_�؂�ւ������N
	&OutHTMLViewModeNaviMb($sow, $vil, $mode, $modes, $modename);

	# �y�[�W�����N�\��
	&OutHTMLPageNaviMb($sow, $vil, $logs, $list, $rows) if ((defined($list)) && ($sow->{'turn'} <= $vil->{'epilogue'}));

	# �O�ֈړ��̃����N
	my $prev = &GetPrevLink($sow, $vil, $position, $logs, $rows);
	# ���ֈړ��̃����N
	my $next = &GetNextLink($sow, $vil, $position, $logs, $rows);

	# �ŐV�ւ̃����N����
	$reqvals->{'turn'} = '';
	my $urlnew = "$urlsow?" . &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'turn'} = $sow->{'turn'};
	$reqvals->{'cmd'} = $query->{'cmd'} if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist'));
	my $urlfirst = "$urlsow?" . &SWBase::GetLinkValues($sow, $reqvals);

	my $first = '��';
	my $last = '��';
	$first = "<a href=\"$urlfirst$amp" . "move=first\" accesskey=\"1\">��</a>" if ($rows->{'start'} == 0);
	$last = "<a href=\"$urlfirst$amp" . "move=last\">��</a>" if ($rows->{'end'} == 0);

	my $isplok    = $vil->{'vplcnt'} - @$pllist;
	my $ismobok   = $vil->{'cntmob'} - @$mobs  ;
	my $wrformmbt = '��';
	my $wrformmbb = '��';
	my $cmdwrite = 'c=wrformmb';
	$cmdwrite = "c=wrmemoformmb$amp" . "cmdfrom=$query->{'cmd'}" if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist'));
	if (($vil->{'turn'} <= $vil->{'epilogue'}) && ($vil->checkentried() >= 0)) {
		$wrformmbt = "<a href=\"$urlnew$amp" . "$cmdwrite\" accesskey=\"7\">��</a>";
		$wrformmbb = "<a href=\"$urlnew$amp" . "$cmdwrite\">��</a>";
	} elsif (($vil->{'turn'} == 0) && ($vil->checkentried() < 0)) {
		$wrformmbt = '�Q';
		$wrformmbb = '�Q';
		my $pllist = $vil->getpllist();
		if ($sow->{'user'}->logined() > 0){
			if (($ismobok)||($isplok)) {
				$wrformmbt = "<a href=\"$urlnew$amp" . "cmd=enformmb\" accesskey=\"7\">�Q</a>";
				$wrformmbb = "<a href=\"$urlnew$amp" . "cmd=enformmb\">�Q</a>";
			}
		}
	}
	my $cfgform = "$urlnew$amp" . "c=cfg";

	if ($position == 0) {
		print <<"_HTML_";
$prev/<a href="$urlnew" accesskey="5">�V</a>/$first/$last/$wrformmbt/<a href="$cfgform">��</a>/<a href="#bottom" accesskey="8">��</a>/$next<br$net>
<hr$net>
_HTML_
	} else {
		print <<"_HTML_";
$prev<a $atr_id="bottom">/</a><a href="$urlnew">�V</a>/$first/$last/$wrformmbb/<a href="$cfgform">��</a>/<a href="#top" accesskey="2">��</a>/$next<br$net>
_HTML_
	}

	return;
}

#----------------------------------------
# �y�[�W�����NHTML�o��
#----------------------------------------
sub OutHTMLPageNaviMb {
	my ($sow, $vil, $logs, $list, $rows) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'};
	my $amp   = $sow->{'html'}->{'amp'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = $query->{'cmd'} if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist'));
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues";

	# �����O�̃J�E���g
	my ($pages, $indexno) = &SWHtml::GetPagesPermit($sow, $logs, $list);

	# �s���̎擾
	my $row = $cfg->{'MAX_ROW_MB'};
	$row = $query->{'row'} if (defined($query->{'row'}));
	$row = $cfg->{'MAX_ROW_MB'} if ($row <= 0);

	my $maxpage = int((@$pages + $row - 1) / $row); # �ő�y�[�W
	my $maxrow = $cfg->{'MAX_PAGES_MB'};
	$maxrow = $maxpage if ($maxrow > $maxpage); # �ő�y�[�W�����N��

	# �ŏ��ɕ\������y�[�W�����N�ԍ�
	$firstpage = int($indexno / $row) - int(($cfg->{'MAX_PAGES_MB'} - 1) / 2);
	$firstpage = 0 if ($firstpage < 0);
	$firstpage = $maxpage - $maxrow if ($firstpage + $maxrow > $maxpage);

	# ���ݕ\�����̓��t�ԍ������l
	my $turn = '';
	$turn = "t=$query->{'turn'}$amp" if (defined($query->{'turn'}));

	my $i;
	my $endpage = int($indexno / $row);
	$endpage = $firstpage + $maxrow - 1 if (($rows->{'end'} != 0) || (!defined($logs->[$#$logs])));
	for ($i = $firstpage; $i < $firstpage + $maxrow; $i++) {
		my $pageno = $i + 1;
		if ($i == $endpage) {
			print "P$pageno";
		} else {
			my $log = $pages->[$i * $row];
			my $logid = $log->{'logid'};
			$logid = $log->{'maskedid'} if (($vil->isepilogue() == 0) && (defined($log->{'maskedid'})) && (($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) || ($log->{'mestype'} == $sow->{'MESTYPE_TSAY'})));
			print "<a href=\"$urlsow$amp" . $turn . "move=page$amp" . "logid=$logid\">P$pageno</a>";
		}
		if ($i < $firstpage + $maxrow - 1) {
			print "/";
		} else {
			print "\n";
		}
	}
	print "[�S$maxpage". "P]<br$net>\n";

}

#----------------------------------------
# ���t�����NHTML�o��
#----------------------------------------
sub OutHTMLDayNaviMb {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'};
	my $amp   = $sow->{'html'}->{'amp'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'turn'} = '';
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues";

	my $i;
	for ($i = 0; $i <= $vil->{'turn'}; $i++) {
		my $turn = "";
		$turn = $amp . "t=$i" if ($i != $vil->{'turn'});
		my $turnname = "$i��";
		$turnname = "�v��" if ($i == 0);
		$turnname = "�v�����[�O" if (($i == 0) && ($vil->{'turn'} == 0));
		$turnname = "�G�s" if ($i == $vil->{'epilogue'});
		$turnname = "�I��" if ($i > $vil->{'epilogue'});

		if (($i == $sow->{'turn'}) && ($query->{'cmd'} ne 'editvilform') && ($query->{'cmd'} ne 'vinfo')) {
				print "$turnname";
		} else {
			print "<a href=\"$urlsow$turn\">$turnname</a>";
		}
		print "/" if ($i < $vil->{'turn'});
	}
	print "<br$net>\n";
}

#----------------------------------------
# ���_�؂�ւ�HTML�o��
#----------------------------------------
sub OutHTMLViewModeNaviMb {
	my ($sow, $vil, $mode, $modes, $modename) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $amp = $sow->{'html'}->{'amp'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'mode'} = '';
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues";

	if ($vil->{'epilogue'} < $vil->{'turn'}) {
		print "���_�F";
		my $i;
		for ($i = 0; $i < @$modes; $i++) {
			if ($mode eq $modes->[$i]) {
				print "$modename->[$i] ";
			} else {
				print "<a href=\"$urlsow$amp" . "m=$modes->[$i]\">$modename->[$i]</a> ";
			}
		}
		print "<br$net>\n";
	}
}

#----------------------------------------
# �O�ֈړ��̃����N
#----------------------------------------
sub GetPrevLink {
	my ($sow, $vil, $position, $logs, $rows) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $amp   = $sow->{'html'}->{'amp'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = $query->{'cmd'} if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist'));
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues";

	my $prev = '��';
	if (($rows->{'start'} == 0) && (defined($logs->[0]->{'mestype'}))) {
		my $startlog = $logs->[0];
		$startlog->{'mestype'} = $sow->{'MESTYPE_SAY'} if (!defined($startlog->{'mestype'}));
		if (($vil->isepilogue() == 0) && (defined($startlog->{'maskedid'})) && (($startlog->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) || ($startlog->{'mestype'} == $sow->{'MESTYPE_TSAY'}))) {
			$prev = "<a href=\"$urlsow$amp" . "move=prev$amp" . "logid=$startlog->{'maskedid'}\"";
		} else {
			$prev = "<a href=\"$urlsow$amp" . "move=prev$amp" . "logid=$startlog->{'logid'}\"";
		}
		if ($position == 0) {
			$prev = "$prev accesskey=\"4\">��</a>";
		} else {
			$prev = "$prev>��</a>";
		}
	}

	return $prev;
}

#----------------------------------------
# ���ֈړ��̃����N
#----------------------------------------
sub GetNextLink {
	my ($sow, $vil, $position, $logs, $rows) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $amp   = $sow->{'html'}->{'amp'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = $query->{'cmd'} if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist'));
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues";

	my $next = '��';
	if (($rows->{'end'} == 0) && (@$logs > 0) && (defined($logs->[$#$logs]->{'mestype'}))) {
		my $endlog   = $logs->[$#$logs];
		$endlog->{'mestype'} = $sow->{'MESTYPE_SAY'} if (!defined($endlog->{'mestype'}));
		if (($vil->isepilogue() == 0) && (defined($endlog->{'maskedid'})) && (($endlog->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) || ($endlog->{'mestype'} == $sow->{'MESTYPE_TSAY'}))) {
			$next = "<a href=\"$urlsow$amp" . "move=next$amp" . "logid=$endlog->{'maskedid'}\"";
		} else {
			$next = "<a href=\"$urlsow$amp" . "move=next$amp" . "logid=$endlog->{'logid'}\"";
		}
		if ($position == 0) {
			$next = "$next accesskey=\"6\">��</a>";
		} else {
			$next = "$next>��</a>";
		}
	}

	return $next;
}

#----------------------------------------
# �^�C�g���̊J�n�^�X�V�\�莞��
#----------------------------------------
sub GetTitleNextUpdate {
	my ($sow, $vil) = @_;

	my $title = '';
	 if (($vil->{'starttype'} eq 'wbbs') || ($vil->{'turn'} > 0)) {
		my $date   = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
		my $extend = '����' . $vil->{'extend'} . '��܂ŁB' if $vil->{'extend'};
		$title = " ($date �ɍX�V�B $extend)";
	} else {
		$title = ' (' . sprintf("%02d:%02d", $vil->{'updhour'}, $vil->{'updminite'}) . '�X�V)';
	}

	return $title;
}

1;
