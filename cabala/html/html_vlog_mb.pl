package SWHtmlVlogMb;

#----------------------------------------
# �����O�\���i�g�у��[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLVlogMb {
	my ($sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows) = @_;

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg = $sow->{'cfg'};

	# ��d�������ݒ���
	if ($sow->{'query'}->{'cmd'} ne '') {
		print <<"_HTML_";
<font color="red">����d�������ݒ��Ӂ�</font><br$net>
�����[�h����ꍇ�́u�V�v���g���ĉ������B
<hr$net>
_HTML_
	}

	# �����y�у����N�\��
	# ���o���i������RSS�j
	my $titleupdate = &SWHtmlMb::GetTitleNextUpdate($sow, $vil);
	my $reqvals     = &SWBase::GetRequestValues($sow);
	my $linkvalues  = &SWBase::GetLinkValues($sow, $reqvals);
	my $linkrss = " <a href=\"?$linkvalues$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);
	print "<a $atr_id=\"top\">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>\n";
	print "$titleupdate $linkrss<br>" if ($vil->{'epilogue'} >= $vil->{'turn'});

	# �L�������\��
	if (defined($sow->{'curpl'}->{'uid'})) {
		my $chrname = $sow->{'curpl'}->getlongchrname();
		my $rolename = $sow->{'curpl'}->getrolename();

		my $curpl = $sow->{'curpl'};
		my $markbonds = '';
		$markbonds = " ��$sow->{'textrs'}->{'MARK_BONDS'}" if ($curpl->isvisiblebonds($vil));
		print "$chrname$rolename$markbonds<br$net>\n";
	}

	my $list = $logfile->getlist();
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0, $logs, $list, $rows);

	if (defined($sow->{'curpl'}->{'uid'})) {
		if (($vil->{'turn'} == 0) && ($sow->{'curpl'}->{'limitentrydt'} > 0)) {
			my $limitdate = $sow->{'dt'}->cvtdt($sow->{'curpl'}->{'limitentrydt'});
			print <<"_HTML_";
<font color="red">$limitdate�܂łɈ�x���������������J�n����Ȃ������ꍇ�A���Ȃ��͎����I�ɑ�����ǂ��o����܂��B</font>
<hr$net>
_HTML_
		}
	}

	if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'})) {
		# �I���\��
		print "<p>�I�����܂����B</p>\n\n";

	} else {
		# �����O�\��
		my $order = $sow->{'query'}->{'order'};
		my %anchor = (
			logfile => $logfile,
			logkeys => $logkeys,
			rowover => $rows->{'rowover'},
		);

		if (($order eq 'desc') || ($order eq 'd')){
			# �~��
			my $i;
			for ($i = $#$logs; $i >= 0; $i--) {
				next if (!defined($logs->[$i]->{'pos'}));
				my $log = $logfile->read($logs->[$i]->{'pos'},$logs->[$i]->{'logpermit'});
				&OutHTMLSingleLogMb($sow, $vil, $log, \%anchor);
			}
		} else {
			# ����
			foreach (@$logs) {
				next if (!defined($_->{'pos'}));
				my $log = $logfile->read($_->{'pos'},$_->{'logpermit'});
				&OutHTMLSingleLogMb($sow, $vil, $log, \%anchor);
			}
		}

		if ($sow->{'turn'} == $vil->{'turn'}) {
			# �ŐV���\����

			# ���Q���^�����O�C�����A�i�E���X
			if (($vil->{'turn'} == 0) && ($sow->{'user'}->logined() <= 0)){
				print <<"_HTML_";
<p>
���������L�����N�^�[��I�сA�������Ă��������B<br$net>
</p>

<p>
���[�����悭����������ł��Q���������B<br$net>
����]�\\�͂ɂ��Ă̔����͍T���Ă��������B
</p>

_HTML_
			}

			my $nosaytext = &SWHtmlVlog::GetNoSayListText($sow, $vil, $pl, $plid);
			if (($vil->isepilogue() == 0) && ($nosaytext ne '')) {
				# �������҃��X�g�̕\��
				print "<p>$nosaytext</p>\n<hr$net>\n\n";
			}
		}
	}

	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1, $logs, $list, $rows);

	return;
}

#----------------------------------------
# ���OHTML�̕\���i�P���O���j
#----------------------------------------
sub OutHTMLSingleLogMb {
	my ($sow, $vil, $log, $logkeys) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $textrs = $sow->{'textrs'};

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

	if ($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'}) {
		# �C���t�H���[�V����
		print <<"_HTML_";
<font color="maroon">$log->{'log'}</font>
<hr$net>
_HTML_
	} elsif ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) {
		# ���ӕ\��
		print <<"_HTML_";
<font color="gray">$log->{'log'}</font>
<hr$net>
_HTML_
	} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_UNDEF'}) {
		my $date = $sow->{'dt'}->cvtdtmb($log->{'date'})."<br$net>";
		if (($log->{'logsubid'} eq $sow->{'LOGSUBID_ACTION'})) {
			# �A�N�V����
			# �������̃A���J�[�𐮌`
			my $mes = &SWLog::ReplaceAnchorHTMLMb($sow, $vil, $log->{'log'}, $logkeys);
			&SWHtml::ConvertNET($sow, \$mes);
			my $actcolorbegin = '';
			my $actcolorend   = '';
			if ($log->{'mestype'} eq $sow->{'MESTYPE_TSAY'}) {
				$actcolorbegin = '<font color="maroon">';
				$actcolorend   = '</font>';
				$date          = '';
			}

			print <<"_HTML_";
$actcolorbegin$logmestypetexts[$log->{'mestype'}]$log->{'chrname'}�́A$mes$actcolorend
$date
_HTML_
		} elsif ($log->{'mestype'} == $sow->{'MESTYPE_CAST'}) {
			# �z���ꗗ
			my $giftname = $sow->{'textrs'}->{'GIFTNAME'};
			my $rolename = $sow->{'textrs'}->{'ROLENAME'};
			my $livename = $sow->{'textrs'}->{'STATUS_LIVE'};
			my $pllist = $vil->getallpllist();
			foreach (@$pllist) {
				my $chrname = $_->getlongchrname();
				my $wintext  = $_->winresult();
				$wintext = '�Q��' if (($cfg->{'ENABLED_WINNER_LABEL'} != 1 )&&('' ne $wintext));
				my $livetext = "$livename->{$_->{'live'}}";
				$livetext = $_->{'deathday'}."d".$livename->{$_->{'live'}} unless (('mob' eq $_->{'live'})||('live' eq $_->{'live'}));
				my $selrolename = $textrs->{'RANDOMROLE'};
				$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
				my $gifttext = "";
				$gifttext = "�A".($giftname->[$_->{'gift'}]) if ( $_->{'gift'} > $sow->{'GIFTID_NOT_HAVE'} );
				$gifttext .= "�A���l" if ($_->{'love'} eq 'love');
				$gifttext .= "�A�׋C" if ($_->{'love'} eq 'hate');
				my $roletext = "$rolename->[$_->{'role'}]$gifttext������($selrolename����])�B";
				$roletext = "$sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'}�ɋ���" if ($_->{'role'} == $sow->{'ROLEID_MOB'});
				$roletext = "$selrolename����]���Ă����B" if ($_->{'role'} < 0);
				my $appendex = "";
				$appendex .= " �����b�r��"   if ( $_->isDisableState('MASKSTATE_ABI_GIFT') );
				$appendex .= " ���\\�͑r��"  if ( $_->isDisableState('MASKSTATE_ABI_ROLE') );
				$appendex .= " ������" if ( $_->isDisableState('MASKSTATE_HURT')     );
				$appendex .= " �����U" if ($_->{'sheep'} eq 'pixi');
				$appendex .= " ��$sow->{'textrs'}->{'MARK_BONDS'}" if ($_->{'bonds'} ne '');
				$appendex .= " ������" if ( $_->isDisableState('MASKSTATE_ZOMBIE')   );
				$appendex .= " ���׋C" if ($_->{'love'}  eq 'hate');
				$appendex .= " �����l" if ($_->{'love'}  eq 'love');
				print <<"_HTML_";
<font color="maroon">$chrname ($_->{'uid'})�A$wintext�A$livetext�B$roletext $appendex</font><br$net>
_HTML_
			}
		} else {
			# �����F
			my @logcolor = (
				'',               # MESTYPE_UNDEF
				'',               # MESTYPE_INFOSP
				'gray',           # MESTYPE_DELETEDADMIN
				'',               # MESTYPE_CAST
				'',               # MESTYPE_MAKER
				'',               # MESTYPE_ADMIN
				'',               # MESTYPE_QUEUE
				'',               # MESTYPE_INFONOM
				'gray',           # MESTYPE_DELETED
				'',               # MESTYPE_SAY
				'gray',           # MESTYPE_TSAY
				'red',            # MESTYPE_WSAY
				'teal',           # MESTYPE_GSAY
				'blue',           # MESTYPE_SPSAY
				'green',          # MESTYPE_XSAY
				'maroon',         # MESTYPE_VSAY
				'',               # MESTYPE_MSAY
				'purple',         # MESTYPE_AIM
			);
			my $logmestypetext = $logmestypetexts[$log->{'mestype'}];

			my $messtyle = $logcolor[$log->{'mestype'}];
			if($log->{'mestype'} == $sow->{'MESTYPE_VSAY'}){
				$messtyle = '';
				$messtyle = 'blue' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'grave'));
				$messtyle = 'gray' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'think'));
			}

			# �������̃A���J�[�𐮌`
			my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);
			my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);
			my $mes = &SWLog::ReplaceAnchorHTMLMb($sow, $vil, $log->{'log'}, $logkeys);
			&SWHtml::ConvertNET($sow, \$mes);

			my $colorstart = '';
			my $colorend = '';
			if ($messtyle ne '') {
				$colorstart = "<font color=\"$messtyle\">\n";
				$colorend = "\n</font>";
			}

			my $showid = '';
			$showid = " ($log->{'uid'})" if ($vil->{'showid'} > 0);

			print <<"_HTML_";
$colorstart$logmestypetext<a $atr_id="$log->{'logid'}">$log->{'chrname'}</a>$showid $date$loganchor<br$net>
$mes<br$net>$colorend
_HTML_

			if ($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_QUEUE'}]) {
				# �����P��{�^���̕\��
				$sow->{'query'}->{'cmd'} = 'cancel';
				my $reqvals = &SWBase::GetRequestValues($sow);
				my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

				print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<input type="hidden" name="cmd" value="cancel">
<input type="hidden" name="queid" value="$log->{'logid'}">$hidden
<input type="submit" value="�폜($sow->{'cfg'}->{'MESFIXTIME'}�b�ȓ�)">
</form>
_HTML_
			}
		}
		print "<hr$net>\n";
	}
}

1;
