package SWHtmlVIndex;

#----------------------------------------
# ���̈ꗗHTML�o��
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

	my $maxrow = $sow->{'cfg'}->{'MAX_ROW'}; # �W���s��
	$maxrow = $cookie->{'row'} if (defined($cookie->{'row'}) && ($cookie->{'row'} ne '')); # �����ɂ��s���w��
	$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne '')); # �����ɂ��S�\���w��

	my $pageno = 0;
	$pageno = $query->{'pageno'} if (defined($query->{'pageno'}));

	print <<"_HTML_";
<table border="1" class="vindex" summary="���̈ꗗ">
<thead>
  <tr>
    <th scope="col"><code ng-click="stories_is_small = ! stories_is_small">�X�^�C��</code></th>
_HTML_

	if ($vmode eq 'oldlog') {
		print "    <th id=\"days_$vmode\">����</th>\n";
	} else {
		print "    <th id=\"vstatus_$vmode\">�i�s</th>\n";
	}

	print <<"_HTML_";
    <th scope="col">���[��</th>
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
		$vstatusno = 'prologue' if ($_->{'vstatus'} == $sow->{'VSTATUSID_PRO'}); # �v�����[�O
		$vstatusno = 'oldlog'   if ($_->{'vstatus'} == $sow->{'VSTATUSID_END'});
		$vstatusno = 'dispose'  if ($_->{'vstatus'} == $sow->{'VSTATUSID_SCRAPEND'});

		next if ($vstatusno ne $vmode); # �w�肵�Ă��Ȃ����͏��O
		my $vil = SWFileVil->new($sow, $_->{'vid'});
		$vil->readvil();
		$sow->{'charsets'}->loadchrrs($vil->{'csid'});
		my $csidcaption = $sow->{'charsets'}->{'csid'}->{$vil->{'csid'}}->{'CAPTION'};
		my $pllist = $vil->getpllist();
		my $allpllist = $vil->getallpllist();
		$vil->closevil();

		if (!defined($vil->{'trsid'})) {
			# ���f�[�^���Ԃ���񂾏ꍇ�Ɉꉞ��Q��H���~�߂�
			print <<"_HTML_";
  <tr>
    <td colspan="4"><span class="cautiontext">$_->{'vid'}���̃f�[�^���擾�ł��܂���B</span></td>
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
		my $csname = '����';
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
			$plcnt .= '�l';
		}
		my $countmob = (scalar(@$allpllist) - scalar(@$pllist));
		$plcnt .= "+".$countmob."�l" if ($countmob);

		my $updintervalday = $vil->{'updinterval'} * 24;
		$updintervalday .= 'h��';
		my $vstatus = "$vil->{'turn'}����";
		if ($vil->{'winner'} != 0) {
			$vstatus = '����';
			$plcnt .= "$note_start<br>".$sow->{'textrs'}->{'CAPTION_WINNER'}->[$vil->{'winner'}]."$note_end";
		} elsif ($vil->isepilogue() > 0) {
			$vid = '&vid='.$_->{'vid'};
			$cssid = '';
			$cssid = '&css='.$sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
			$vstatus = '�p��';
			$vstatus = '<a href="sow.cgi?cmd=editvilform&status=dispose'.$vid.$cssid.'">��蒼��</a>' if(($sow->{'uid'} ne '')&&($sow->{'uid'} ne $vil->{'makeruid'}));
		}
		if ($vmode eq 'oldlog') {
			my $numdays = $vil->{'turn'} - 2;
			$vstatus = sprintf("%02d��",$numdays);
		} else {
			$vstatus = "$vstatus";
		}
		if ($vil->{'turn'} == 0) {
			if ($vil->{'vplcnt'} > @$pllist) {
				$vstatus = '��W��';
			} else {
				$vstatus = '�J�n�O';
			}
		}

		my $countssay = $sow->{'cfg'}->{'COUNTS_SAY'};
		my $imgpwdkey = '';
		if (defined($vil->{'entrylimit'})) {
			$imgpwdkey = "<img src=\"$cfg->{'DIR_IMG'}/icon/key.png\" width=\"16\" height=\"16\" alt=\"[��]\"$net> " if ($vil->{'entrylimit'} eq 'password');
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
$note_start<br>�q<a href="$link">�ŐV</a>�r
$imgpwdkey$note_end$imgrating$note_start
<br>�@�@�l�� �F $csidcaption
<br>�@�@�X�V �F $date $updintervalday
<br>�@ $schelp
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
			$vmodetext = '��W���^�J�n�҂�';
		} elsif ($vmode eq 'oldlog') {
			$vmodetext = '�I���ς�';
		} elsif ($vmode eq 'dispose') {
			$vmodetext = '�p��';
		} else {
			$vmodetext = '�i�s��';
		}

		print <<"_HTML_";
  <tr>
    <td colspan="6">����$vmodetext�̑��͂���܂���B</td>
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
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">�O�̃y�[�W</a> \n";
		} else {
			print "�O�̃y�[�W \n";
		}

		if ((($pageno + 1) * $maxrow <= $virow) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno + 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">���̃y�[�W</a> \n";
		} else {
			print "���̃y�[�W \n";
		}

		if (($virow + 1) != $vicount) {
			$reqvals->{'rowall'} = 'on';
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">�S�\\��</a>\n";
		} else {
			print "�S�\\��\n";
		}
		print "</p>\n";
	}
}

1;
