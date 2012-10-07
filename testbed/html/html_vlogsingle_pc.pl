package SWHtmlVlogSinglePC;

#----------------------------------------
# ���OHTML�̕\���i�L�����̔����j
#----------------------------------------
sub OutHTMLSingleLogSayPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	# �����ƃL�����N�^�[��
	my $logpl = &GetLogPL($sow, $vil, $log);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	$sow->{'charsets'}->loadchrrs($logpl->{'csid'});
	my $charset = $sow->{'charsets'}->{'csid'}->{$logpl->{'csid'}};
	my $chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);

	# �N���X��
	my $messtyle = &SWHtmlPC::OutHTMLMesStyle($sow,$vil,$log);

	# �L�����摜�A�h���X�̎擾
	my $img = &SWHtmlPC::GetImgUrl($sow, $logpl, $charset->{'FACE'}, $log->{'expression'});

	# �L�����摜���Ƃ��̑����̉������擾
	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');

	# ���O�ԍ�
	my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);
	my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);

	# �������
	my @logmestypetexts = (
		'',               # MESTYPE_UNDEF
		'',               # MESTYPE_INFOSP
		'�y�Ǘ��l�폜�z', # MESTYPE_DELETEDADMIN
		'',               # MESTYPE_CAST
		'',               # MESTYPE_MAKER
		'',               # MESTYPE_ADMIN
		'�y���m�z',       # MESTYPE_QUEUE
		'',               # MESTYPE_INFONOM
		'�y�폜�z',       # MESTYPE_DELETED
		'�y�l�z',         # MESTYPE_SAY
		'�y�Ɓz',         # MESTYPE_TSAY
		'�y�ԁz',         # MESTYPE_WSAY
		'�y��z',         # MESTYPE_GSAY
		'�y�z',         # MESTYPE_SPSAY
		'�y�O�z',         # MESTYPE_XSAY
		'�y���z',         # MESTYPE_VSAY
		'�y�߁z',         # MESTYPE_MSAY
		'�y��z',         # MESTYPE_AIM
	);
	my $logmestypetext = '';
	$logmestypetext  = "$logmestypetexts[$log->{'mestype'}]" if ($logmestypetexts[$log->{'mestype'}] ne '');

	# �������̃A���J�[���𐮌`
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	# ��������
	my $mes_text = 'mes_text';
	$mes_text = 'mes_text_monospace' if ((defined($log->{'monospace'})) && ($log->{'monospace'} == 1));
	$mes_text = 'mes_text_report'    if ((defined($log->{'monospace'})) && ($log->{'monospace'} == 2));

	# ID���J
	my $showid = '';
	$showid = " $log->{'uid'} " if (($vil->{'showid'} > 0)||($vil->{'epilogue'} <= $sow->{'turn'})||($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}));

	# ���O��HTML�o��
	&OutHTMLFilterDivHeader($sow, $vil, $log, $no, $logpl, $modesingle);
	# ��摜�̕\��
	print <<"_HTML_";
<table class="$messtyle">
<tbody>
<tr class="say">
<td class="img"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt=""$net>
<td class="field"><DIV class="msg">
_HTML_

	# ���O�\���i��z�u�j
	print "  <h3 class=\"mesname\">$logmestypetext <a $atr_id=\"$log->{'logid'}\">$chrname</a></h3>\n\n" if ($charset->{'LAYOUT_NAME'} eq 'top');

	# ���O�\���i�E�z�u�j
	print "    <h3 class=\"mesname\">$logmestypetext <a $atr_id=\"$log->{'logid'}\">$chrname</a></h3>\n" if ($charset->{'LAYOUT_NAME'} ne 'top');

	# �����̕\��
	print "<p class=\"$mes_text\">$log->{'log'}</p>\n";

	# �����̍폜�{�^��
	if ($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_QUEUE'}]) {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

		print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
<span class="saycancelframe">
<input type="hidden" name="cmd" value="cancel"$net>
<input type="hidden" name="queid" value="$log->{'logid'}"$net>$hidden
<input type="submit" value="���̔������폜($sow->{'cfg'}->{'MESFIXTIME'}�b�ȓ�)" class="saycancelbutton"$net>
</span>
</form>
<p class="mes_date">$date</p>
_HTML_
	} else {
		print "<p class=\"mes_date\" turn=\"$sow->{'turn'}\">$loganchor$showid $date</p>\n";
	}

	# ��荞�݂̉���
	print <<"_HTML_";
</DIV></td>
</tr></table>
</div></div>
_HTML_

}



#----------------------------------------
# ���OHTML�̕\���i�G�s���[�O�̔z���ꗗ�j
#----------------------------------------
sub OutHTMLSingleLogCastPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg   = $sow->{'cfg'};
	my $textrs = $sow->{'textrs'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);

	my $winlabel  = '���s';
	my $namelabel = '���O';
	$namelabel = "<a $atr_id=\"newsay\">$namelabel</a>" if ($newsay > 0);
	$winlabel  = '�Q��' if ($cfg->{'ENABLED_WINNER_LABEL'} != 1 );

	print <<"_HTML_";
<table border="1" class="vindex" summary="�z���ꗗ">
<thead>

<tr>
<th scope="col">$namelabel</th>
<th scope="col">ID</th>
<th scope="col">����</th>
<th scope="col">����</th>
<th scope="col">$winlabel</th>
<th scope="col">��E</th>
</tr>
</thead>

<tbody>
_HTML_

	my $giftname = $sow->{'textrs'}->{'GIFTNAME'};
	my $rolename = $sow->{'textrs'}->{'ROLENAME'};
	my $livename = $sow->{'textrs'}->{'STATUS_LIVE'};
	my $pllist   = $vil->getallpllist();
	foreach (@$pllist) {
		my %link = (
			'user' => $_    ->{'uid'},
			'css'  => $query->{'css'},
		);
		my $urluser = $cfg->{'URL_USER'}.'?'.&SWBase::GetLinkValues($sow, \%link);
		my $uidtext = '<a href="'.$urluser.'">'.$_->{'uid'}.'</a>';
		my $chrname = $_->getlongchrname();
		my $deathday = "";
		$deathday = $_->{'deathday'}."��" if (0 < $_->{'deathday'});
		my $livetext = $livename->{$_->{'live'}};
		my $wintext  = $_->winresult();
		$wintext = '�Q��' if (($cfg->{'ENABLED_WINNER_LABEL'} != 1 )&&('' ne $wintext));
		my $win_if = $textrs->{'ROLEWIN'}->{ $_->win_if() };
		my $selrolename = $textrs->{'RANDOMROLE'};
		$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
		my $roletext = $win_if."�F";
		$roletext .= $rolename->[$_->{'role'}];
		$roletext .= "�A".$giftname->[$_->{'gift'}] if ( $_->{'gift'} > $sow->{'GIFTID_NOT_HAVE'} );
		$roletext .= "�A���l" if ($_->{'love'} eq 'love');
		$roletext .= "�A�׋C" if ($_->{'love'} eq 'hate');
		$roletext .= "<i><br>�@�@".$selrolename."����]";
		$roletext = $selrolename."����]<i>" if ($_->{'role'} < 0);
		$roletext = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'}."�ɋ���<i>" if ($_->{'role'} == $sow->{'ROLEID_MOB'});

		my $appendex = "";
		$appendex .= "�@�@�\\�͂�r��<br>"  if ( $_->isDisableState('MASKSTATE_ABI_ROLE') );
		$appendex .= "�@�@���b��r��<br>"   if ( $_->isDisableState('MASKSTATE_ABI_GIFT') );
		$appendex .= "�@�@�P���ŕ���<br>"   if ( $_->isDisableState('MASKSTATE_HURT')     );
		$appendex .= "�@�@�P���Ɋ���<br>"   if ( $_->isDisableState('MASKSTATE_ZOMBIE')   );
		$appendex .= "�@�@�U��ꂽ<br>"   if ($_->{'sheep'} eq 'pixi');
		$appendex .= "�@�@���l������<br>" if ($_->{'love'}  eq 'love');
		$appendex .= "�@�@�׋C������<br>" if ($_->{'love'}  eq 'hate');
		if ($_->{'bonds'} ne '') {
			my @bonds = split('/', $_->{'bonds'} . '/');
			my $target;
			foreach $target (@bonds) {
				my $targetname = $vil->getplbypno($target)->getlongchrname();
				$appendex .= "�^�����J��$targetname<br$net>";
			}
		}
		my $history  = $_->{'history'};

		print <<"_HTML_";
<tr class="i_active">
<td>$chrname
<td>$uidtext
<td class="$_->{'live'} calc">$deathday
<td class="$_->{'live'}">$livetext
<th class="$_->{'live'}">$wintext
<td>$roletext
<br>$appendex</i>
</tr>

_HTML_
	}

	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

_HTML_
}

#----------------------------------------
# ���OHTML�̕\���i�P���O���j
#----------------------------------------
sub OutHTMLSingleLogPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;

	# ID���J
	my $showid = '';
	$showid = $log->{'uid'} if  ($vil->{'showid'} > 0);
	$showid = $log->{'uid'} if  ($vil->{'epilogue'} <= $sow->{'turn'});
	$showid = ''            if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}));

	my $to   = "";
	my $name = $log->{'chrname'};
	if ($log->{'mestype'} == $sow->{'MESTYPE_AIM'}) {
		($name, $to) = split(' �� ', $log->{'chrname'});

	}

	print <<"_HTML_";
var mes = {
	"subid":  "$log->{'logsubid'}",
	"logid":  "$log->{'logid'}",
	"csid":     "$log->{'csid'}",
	"face_id":  "$log->{'cid'}",
	"mesicon":  SOW_RECORD.CABALA.mestypeicons[$log->{'mestype'}],
	"mestype":  SOW_RECORD.CABALA.mestypes[$log->{'mestype'}],
	"style":    SOW_RECORD.CABALA.monospace[$log->{'monospace'}],
	"name":  "$name",
	"to":    "$to",
	"log":   "$log->{'log'}",
	"date":  Date.create(1000 * $log->{'date'})
};
_HTML_
	if ($vil->{'showid'}) {
		print <<"_HTML_"
mes.sow_auth_id = "$showid";
_HTML_
	}
	print <<"_HTML_";
gon.event.messages.push(mes);
_HTML_
}

#----------------------------------------
# �t�B���^�pdiv�J�n�^�O�̏o��
#----------------------------------------
sub OutHTMLFilterDivHeader {
	my ($sow, $vil, $log, $no, $logpl, $modesingle) = @_;
	my $filter = $sow->{'filter'};

	my $logpno = '-1';
	# �l�t�B���^����
	if (($logpl->{'pno'} >= 0) && ($logpl->{'entrieddt'} <= $log->{'date'})) {
		# ���𔲂��Ă��Ȃ��l�̓t�B���^�̑Ώ�
		$logpno = $logpl->{'pno'};
	}

	# ������ʃt�B���^����
	my $mestype = $sow->{'MESTYPE2TYPEID'}->[$log->{'mestype'}];

	# �v���r���[�̎��̓t�B���^�𖳌�
	$modesingle = 1 if (($sow->{'query'}->{'cmd'} eq 'entrypr') || ($sow->{'query'}->{'cmd'} eq 'writepr'));

	if ($modesingle == 0) {
		my $filterid = $no."_".$logpno."_".$mestype;
		my $filterstyle = '';
		$filterstyle = $pnofilterstyle  if('' ne $pnofilterstyle );
		$filterstyle = $typefilterstyle if('' ne $typefilterstyle);
		print "<div>";
		print "<div class=\"message_filter\" id=\"$filterid\"$filterstyle>";
	} else {
		print "<div><div class=\"message_filter\">\n";
	}
	return;
}

#----------------------------------------
# �w�肵�����O�̔����҃f�[�^�̎擾
#----------------------------------------
sub GetLogPL {
	my ($sow, $vil, $log) = @_;
	my $logpl;
	my $pl = $vil->getpl($log->{'uid'});

	if ((!defined($pl->{'cid'})) || ($pl->{'entrieddt'} > $log->{'date'})) {
		# ���𔲂��Ă���v���C���[
		my %logplsingle = (
			cid       => $log->{'cid'},
			csid      => $log->{'csid'},
			pno       => -1,
			deathday  => -1,
			entrieddt => -1,
		);
		$logpl = \%logplsingle;
	} else {
		# ���ɂ���v���C���[
		my $plface = $vil->getplbyface($log->{'csid'},$log->{'cid'});
		my %logplsingle = (
			cid       => $log->{'cid'},
			csid      => $log->{'csid'},
			pno       => $plface->{'pno'},
			deathday  => $plface->{'deathday'},
			entrieddt => $plface->{'entrieddt'},
		);
		$logpl = \%logplsingle;
	}

	return $logpl;
}

1;
