package SWHtmlVlogPC;

#----------------------------------------
# �����O�\���iPC���[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLVlogPC {
	my ($sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows) = @_;
	my $pllist = $vil->getpllist();

	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	my $logfilelist = $logfile->getlist();

	# ���OID�w��\���X�C�b�`
	my $modesingle = 0;
	$modesingle = 1 if (($query->{'logid'} ne '') && ($query->{'move'} ne 'prev') && ($query->{'move'} ne 'next'));

	# ���O�C��HTML
	$sow->{'html'}->outcontentheader();
	&SWHtmlPC::OutHTMLLogin($sow) if ($modesingle == 0);


	# ���o���i������RSS�j
	my $linkrss = " <a href=\"$link$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);
	print "<h2>$query->{'vid'} $vil->{'vname'} $linkrss</h2>\n\n";

	# �I���\��
	if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'})) {
		print <<"_HTML_";
<p class="caution">
�I�����܂����B
</p>
_HTML_
		print <<"_HTML_";
<hr class="invisible_hr"$net>
_HTML_

		&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�
		$sow->{'html'}->outcontentfooter();
		&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);
		&SWHtmlSayFilter::OutHTMLSayFilter($sow, $vil) if ($modesingle == 0);
		&SWHtmlSayFilter::OutHTMLTools    ($sow, $vil);
		&SWHtmlSayFilter::OutHTMLFooter   ($sow, $vil);

		return;
	}

	# �S�\�������N
#	my $rowover = 0;
	my $rowover = $rows->{'rowover'};
	if ($modesingle == 0) {
		if (($maxrow != 0) && ($rows->{'rowover'} > 0)) {
			print "<p class=\"row_all\">\n<a href=\"$link$amp" . "rowall=on\">�S�ĕ\\��</a>\n</p>\n\n";
		}
	}

	# �����O�\��
	print "<hr class=\"invisible_hr\"$net>\n\n";
	require "$cfg->{'DIR_HTML'}/html_vlogsingle_pc.pl";
	my %anchor = (
		logfile => $logfile,
		logkeys => $logkeys,
		rowover => $rowover,
		reqvals => $reqvals,
	);

	if (($query->{'order'} eq 'desc') || ($query->{'order'} eq 'd')){
		# �~��
		my $i;
		for ($i = $#$logs; $i >= 0; $i--) {
			my $newsay = 0;
			$newsay = 1 if ($i == 0);
			my $log = $logfile->read($logs->[$i]->{'pos'},$logs->[$i]->{'logpermit'});
			&SWHtmlVlogSinglePC::OutHTMLSingleLogPC($sow, $vil, $log, $i, $newsay, \%anchor, $modesingle);
		}
	} else {
		# ����
		my $i;
		for ($i = 0; $i < @$logs; $i++) {
			my $newsay = 0;
			$newsay = 1 if ($i == $#$logs);
			my $log = $logfile->read($logs->[$i]->{'pos'},$logs->[$i]->{'logpermit'});
			&SWHtmlVlogSinglePC::OutHTMLSingleLogPC($sow, $vil, $log, $i, $newsay, \%anchor, $modesingle);
		}
	}

	# �A�i�E���X�^���́E�Q���t�H�[���\��
	if (($modesingle == 0) && ($sow->{'turn'} == $vil->{'turn'}) && ($rows->{'end'} > 0)) {
		&OutHTMLVlogFormArea($sow, $vil)
	}

	if ($modesingle == 0) {
		$reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'order'} = '';
		$reqvals->{'row'} = '';
		my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

		my $option = $sow->{'html'}->{'option'};
		my $desc = '';
		my $asc = " $sow->{'html'}->{'selected'}";
		my $star_desc = '';
		my $star_asc = ' *';
		if (($query->{'order'} eq 'd') || ($query->{'order'} eq 'desc')) {
			$desc = " $sow->{'html'}->{'selected'}";
			$asc = '';
			$star_desc = ' *';
			$star_asc = '';
		}

		print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="get" class="viewform">
<p>$hidden
  <label for="row">�\\���s��</label>
  <select id="row" name="row">
_HTML_

		my $row_pc = $sow->{'cfg'}->{'ROW_PC'};
		my $row = $sow->{'cfg'}->{'MAX_ROW'};
		$row = $query->{'row'} if (defined($query->{'row'}));
		foreach (@$row_pc) {
			my $selected = '';
			my $star = '';
			if ($_ == $row) {
				$selected = " $sow->{'html'}->{'selected'}";
				$star = ' *';
			}
			print "    <option value=\"$_\"$selected>$_$star$option\n";
		}

		print <<"_HTML_";
  </select>
  <select name="order">
    <option value="asc"$asc>�ォ�牺$star_asc$option
    <option value="desc"$desc>�������$star_desc$option
  </select>
  <input type="submit" value="�ύX"$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
	}

	# �g�b�v�y�[�W�֖߂�
	&SWHtmlPC::OutHTMLReturnPC($sow) if ($modesingle == 0);

	# �����t�B���^
	$sow->{'html'}->outcontentfooter();

	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);
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
	print <<"_HTML_";
</script>
_HTML_

	return;
}

#----------------------------------------
# �A�i�E���X�^���́E�Q���t�H�[���\��
#----------------------------------------
sub OutHTMLVlogFormArea {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $pllist = $vil->getpllist();
	my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});

	if (($vil->{'turn'} == 0) && ($vil->checkentried() < 0) && ($vil->{'vplcnt'} > @$pllist)) {
		# �v�����[�O���Q���^�����O�C�����A�i�E���X
		my $scraplimit = "\n\n<p class=\"caution\">\n" . $sow->{'dt'}->cvtdt($vil->{'scraplimitdt'}) . "�܂łɊJ�n���Ȃ������ꍇ�A���̑��͔p���ƂȂ�܂��B\n</p>";
		$scraplimit = '' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
<p class="caution">
���������L�����N�^�[��I�сA�������Ă��������B<br$net>
���[�����悭����������ł��Q���������B<br$net>
����]�\\�͂ɂ��Ă̔����͍T���Ă��������B
</p>$scraplimit
<hr class="invisible_hr"$net>

_HTML_
	} elsif ($vil->isepilogue() > 0) {
		# �G�s���[�O�p�A�i�E���X
		my $caption_winner = $sow->{'textrs'}->{'CAPTION_WINNER'};
		my $victorytext = $sow->{'textrs'}->{'ANNOUNCE_VICTORY'};
		my $caption = $caption_winner->[$vil->{'winner'}];
		$victorytext =~ s/_VICTORY_/$caption/g;
		$victorytext = '' if ($vil->{'winner'} == 0);
		my $epiloguetext = $sow->{'textrs'}->{'ANNOUNCE_EPILOGUE'};
		$epiloguetext =~ s/_AVICTORY_/$victorytext/g;
		$epiloguetext =~ s/_DATE_/$date/g;
		&SWHtml::ConvertNET($sow, \$epiloguetext);

		print <<"_HTML_";
<p class="caution">
$epiloguetext
</p>
<hr class="invisible_hr"$net>

_HTML_
	}

	# �������҃��X�g�̕\��
	my $nosaytext = &SWHtmlVlog::GetNoSayListText($sow, $vil);
	if (($vil->isepilogue() == 0) && ($nosaytext ne '')) {
		print "<p class=\"caution\">$nosaytext</p>\n";
		print "<hr class=\"invisible_hr\"$net>\n\n";
	}

	# �������^�G���g���[�t�H�[��
	if ($vil->{'turn'} == 0) {
		# �v�����[�O
		if ($sow->{'user'}->logined() > 0) {
			# ���O�C���ς�
			if ($vil->checkentried() >= 0) {
				if ($sow->{'curpl'}->{'limitentrydt'} > 0) {
					my $limitdate = $sow->{'dt'}->cvtdt($sow->{'curpl'}->{'limitentrydt'});
					print <<"_HTML_";
<p class="caution">
$limitdate�܂łɈ�x���������������J�n����Ȃ������ꍇ�A���Ȃ��͎����I�ɑ�����ǂ��o����܂��B<br$net>
����������Ɗ�������������܂��B
</p>
_HTML_
				}

				# �������̕\��
				require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
				&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil);
			} else {
				# �G���g���[�t�H�[���̕\��
				require "$cfg->{'DIR_HTML'}/html_entryform_pc.pl";
				&SWHtmlEntryFormPC::OutHTMLEntryFormPC($sow, $vil);
				&OutHTMLVilMakerInFormPlPC($sow, $vil);
			}
		} else {
			# �����O�C��
			if ($vil->{'vplcnt'} > @$pllist) {
				print "<p class=\"infonologin\">\n�Q�[���Q���Ҋ�]�҂̓��O�C�����ĉ������B\n</p>\n";
				print "<hr class=\"invisible_hr\"$net>\n\n";
			} else {
				print "<p class=\"caution\">\n���ɒ���ɒB���Ă��܂��B\n</p>\n";
				print "<hr class=\"invisible_hr\"$net>\n\n";
			}
		}
	} else {
		# �i�s��
		if ($sow->{'user'}->logined() > 0) {
			# ���O�C���ς�
			if ($vil->checkentried() >= 0){
				# �������̕\��
				require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
				&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil);
			} else {
				# �����Đl�^�Ǘ��l�����t�H�[���̕\��
				&OutHTMLVilMakerInFormPlPC($sow, $vil);
			}
		} elsif ($vil->isepilogue() == 0) {
			# �����O�C��
			print "<p class=\"infonologin\">\n�Q���҂̓��O�C�����ĉ������B\n</p>\n";
			print "<hr class=\"invisible_hr\"$net>\n\n";
		}
	}
	return;
}

#----------------------------------------
# �����Đl�t�H�[���^�Ǘ��l�t�H�[���̕\��
# �i�����Đl�^�Ǘ��l���Q�����Ă��Ȃ����j
#----------------------------------------
sub OutHTMLVilMakerInFormPlPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};

	if ($vil->{'makeruid'} eq $sow->{'uid'}) {
		require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
		print "<div class=\"formpl_frame\">\n";
		&SWHtmlPlayerFormPC::OutHTMLVilMakerPC($sow, $vil, 'maker');
		&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
		print "</div>\n";
	}

	if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'}) {
		require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
		print "<div class=\"formpl_frame\">\n";
		&SWHtmlPlayerFormPC::OutHTMLVilMakerPC($sow, $vil, 'admin');
		&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
		&SWHtmlPlayerFormPC::OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
		print "</div>\n";
	}

	return;
}

1;
