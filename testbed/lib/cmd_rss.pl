package SWCmdRSS;

#----------------------------------------
# RSS�o��
#----------------------------------------
sub CmdRSS {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	require "$cfg->{'DIR_HTML'}/html.pl";
	if (defined($query->{'vid'})) {
		&OutRSSVLog($sow);
	} else {
		&OutRSSVIndex($sow);
	}
}

#----------------------------------------
# ���ꗗ��RSS�o��
#----------------------------------------
sub OutRSSVIndex {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $urlsow = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}";
	my @items = (
	);

	require "$cfg->{'DIR_LIB'}/file_vindex.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	$vindex->closevindex();

	my $vilist = $vindex->getvilist();
	foreach (@$vilist) {
		next if ($_->{'vstatus'} != $sow->{'VSTATUSID_PRO'});

		my $vil = SWFileVil->new($sow, $_->{'vid'});
		$vil->readvil();
		my %item = (
			title   => "$vil->{'vid'} $vil->{'vname'}",
#			name    => $vil->{'makeruid'},
			date    => $_->{'createdt'},
			link    => "$urlsow?vid=$_->{'vid'}",
			content => $vil->{'vcomment'},
		);
		unshift(@items, \%item);
		$vil->closevil();
	}

	# �X�V����
#	$sow->{'http'}->{'lastmodified'} = $vindex->getupdatedt();
#	$sow->{'http'}->setnotmodified();

	if ($query->{'cmd'} eq 'rss') {
		require "$cfg->{'DIR_LIB'}/rss.pl";
		&SWRSS::OutXMLRSS($sow, '��W�^�J�n�O�̑��̈ꗗ', '�V�K�쐬���ꂽ���̂����A�܂���W���܂��͊J�n�O�̑��̈ꗗ�ł��B', $urlsow, \@items);
	} else {
		require "$cfg->{'DIR_LIB'}/summary.pl";
		&SWSummary::OutSWSummary($sow, '��W�^�J�n�O�̑��̈ꗗ', '�V�K�쐬���ꂽ���̂����A�܂���W���܂��͊J�n�O�̑��̈ꗗ�ł��B', $urlsow, \@items);
	}

	return;
}

#----------------------------------------
# �����O��RSS�o��
#----------------------------------------
sub OutRSSVLog {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $urlsow = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}";
	my @items = (
	);

	# ���f�[�^�̓ǂݍ���
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $sow->{'query'}->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
	my $maxrow = $sow->{'cfg'}->{'MAX_ROW'};
	$maxrow = $query->{'row'} if (defined($query->{'row'}) && ($query->{'row'} ne ''));
	$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne ''));

	# ���O�̎擾
	my $logs;
	my $turn = $sow->{'turn'};
	$turn-- if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'}));
	my $loop = 1;
	while ($loop > 0) {
		$loop = 0;

		my $logfile = SWBoa->new($sow, $vil, $turn, 0);
		my $memofile = SWSnake->new($sow, $vil, $turn, 0);
		my $memoindex = $memofile->{'memoindex'}->{'file'};
		my ($logidx, $rows) = $logfile->getvlogs($maxrow);
		my @logsday;
		my $i;
		for ($i = $#$logidx; $i >= 0; $i--) {
			my $log = $logfile->read($logidx->[$i]->{'pos'},$logidx->[$i]->{'logpermit'});
			$log->{'logtype'} = 'log';
			if ($log->{'memoid'} ne $sow->{'DATATEXT_NONE'}) {
				my $indexno = $memoindex->getbyid($log->{'memoid'});
				my $memoidx = $memoindex->getlist->[$indexno];
				$log = $memofile->read($memoidx->{'pos'},$memoidx->{'logpermit'});
				$log->{'logtype'} = 'memo';
				$log->{'logsubid'} = $sow->{'LOGSUBID_UNDEF'};
			} else {
				$log->{'logid'} = $log->{'maskedid'} if ((($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) || ($log->{'mestype'} == $sow->{'MESTYPE_TSAY'})) && ($vil->isepilogue() == 0));
			}
			$log->{'turn'} = $turn;
			unshift(@$logs, $log);

			last if (@$logs >= $maxrow);
		}
		if ((@$logs < $maxrow) && ($turn > 0)) {
			$turn--;
			$loop = 1;
		}
		$logfile->close();
	}

	my $i;
	for ($i = $#$logs; $i >= 0; $i--) {
		my $chrname;
		my $log = $logs->[$i];
		if ($log->{'cid'} eq $sow->{'DATATEXT_NONE'}) {
			$chrname = '[���]';
		} else {
			$chrname = $log->{'chrname'};
			if ($log->{'logtype'} eq 'memo') {
				$chrname = "[����] $chrname" ;
				# ���I
				$chrname = '�H' if ($vil->iseclipse($sow->{'turn'}));
			}
		}
		my $turn = '';
		$turn = "&amp;turn=$log->{'turn'}" if ($log->{'turn'} != $sow->{'turn'});
		my $content = $log->{'log'};
		$content = "$chrname�́A$content" if ($log->{'logsubid'} eq $sow->{'LOGSUBID_ACTION'});
		$content = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $content);
		my $cmd = '';
		$cmd = "&amp;cmd=hist" if ($log->{'logtype'} eq 'memo');
		my %item = (
			title   => $chrname,
			name    => $chrname,
			date    => $log->{'date'},
			link    => "$urlsow?vid=$vil->{'vid'}$turn&amp;logid=$log->{'logid'}$cmd",
			content => $content,
		);
		unshift(@items, \%item);
	}

	require "$cfg->{'DIR_LIB'}/rss.pl";
	&SWRSS::OutXMLRSS($sow, "$vil->{'vid'} $vil->{'vname'}", "$vil->{'vid'} $vil->{'vname'} �̔����ł��B", $urlsow, \@items);
	return;

}

1;