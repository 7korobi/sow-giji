package SWHtmlMemoMb;

#----------------------------------------
# �����\���i���o�C�����[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLMemoMb {
	my ($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows) = @_;

	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp    = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	$sow->{'html'}->outcontentheader();

	# ��d�������ݒ���
	if ($sow->{'query'}->{'cmdfrom'} eq 'wrmemo') {
		print <<"_HTML_";
<font color="red">����d�������ݒ��Ӂ�</font><br$net>
�����[�h����ꍇ�́u�V�v���g���ĉ������B
<hr$net>
_HTML_
	}

	# ����
	my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
	my $extend = '����' . $vil->{'extend'} . '��܂ŁB' if $vil->{'extend'};
	my $titleupdate = " ($date �ɍX�V�B $extend)";

	# ���o���i������RSS�j
	print "<a $atr_id=\"top\">$query->{'vid'} $vil->{'vname'}<br$net>\n";

	# �L�������\��
	if (defined($sow->{'curpl'}->{'uid'})) {
		my $chrname = $sow->{'curpl'}->getlongchrname();
		my $rolename = $sow->{'curpl'}->getrolename();
		print "$chrname$rolename<br$net>\n";
	}

	# ���t�ʃ��O�ւ̃����N
	my $list = $memofile->getmemolist();
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0, $logs, $list, $rows);

	if (defined($logs->[0]->{'pos'})) {
		if (($query->{'order'} eq 'desc') || ($query->{'order'} eq 'd')){
			# �~��
			my $i;
			for ($i = $#$logs; $i >= 0; $i--) {
				&OutHTMLMemoSingleMb($sow, $vil, $logfile, $memofile, $logs->[$i]);
			}
		} else {
			# ����
			foreach (@$logs) {
				&OutHTMLMemoSingleMb($sow, $vil, $logfile, $memofile, $_);
			}
		}
	} else {
		print <<"_HTML_";
�����͂���܂���B
<hr$net>
_HTML_
	}

	# ���t�ʃ��O�ւ̃����N
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1, $logs, $list, $rows);

	$sow->{'html'}->outcontentfooter();

	return;
}

#----------------------------------------
# ������HTML�\���i�P�������j
#----------------------------------------
sub OutHTMLMemoSingleMb {
	my ($sow, $vil, $logfile, $memofile, $memoidx) = @_;
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'};

	my $memo = $memofile->read($memoidx->{'pos'},$memoidx->{'logpermit'});

	my $curpl = $vil->getpl($memo->{'uid'});
	my $chrname = $memo->{'chrname'};
	my $append  = "(�����o�܂���)";
	if ((defined($curpl->{'entrieddt'})) && ($curpl->{'entrieddt'} < $memo->{'date'})){
		$append = "";
	}
	my $mes = $memo->{'log'};
	$mes = '�i�������͂������j' if ($memo->{'log'} eq '');
	my %logkeys;
	my %anchor = (
		logfile => $logfile,
		logkeys => \%logkeys,
		rowover => 1,
	);
	$mes = &SWLog::ReplaceAnchorHTMLMb($sow, $vil, $mes, \%anchor);
	my $date = $sow->{'dt'}->cvtdtmb($memo->{'date'});
	my $memodate = '';
	$memodate = " $date" if ($query->{'cmd'} eq 'hist');

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
		'blue',           # MESTYPE_GSAY
		'purple',         # MESTYPE_SPSAY
		'green',          # MESTYPE_XSAY
		'maroon',         # MESTYPE_VSAY
		'',               # MESTYPE_MSAY
		'gray',           # MESTYPE_AIM
	);
	my $messtyle = $logcolor[$memoidx->{'mestype'}];
	if($memoidx->{'mestype'} == $sow->{'MESTYPE_VSAY'}){
		$messtyle = '';
		$messtyle = 'blue' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'grave'));
		$messtyle = 'gray' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'think'));
	}

	&SWHtml::ConvertNET($sow, \$mes);

	my $colorstart = '';
	my $colorend = '';
	if ($messtyle ne '') {
		$colorstart = "<font color=\"$messtyle\">\n";
		$colorend = "\n</font>";
	}

	if (($memo->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($memo->{'mestype'} == $sow->{'MESTYPE_ADMIN'})) {
		print <<"_HTML_";
$colorstart$chrname$memodate<br$net>
$mes$colorend
<hr$net>
_HTML_
	} else {
		print <<"_HTML_";
$colorstart$chrname$append$memodate<br$net>
$mes$colorend
<hr$net>
_HTML_
	}

}

1;
