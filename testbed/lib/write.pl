package SWWrite;

#----------------------------------------
# 発言書き込み処理
#----------------------------------------
sub ExecuteCmdWrite {
	my ($sow, $vil, $writepl, $memoid, $mes_postfix) = @_;
	my $query  = $sow->{'query'};
	require "$sow->{'cfg'}->{'DIR_LIB'}/string.pl";

	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $writepl->GetMesType($sow, $vil);
	my $logsubid = $sow->{'LOGSUBID_SAY'};
	$logsubid    = $sow->{'LOGSUBID_ACTION'} if (($query->{'cmd'} eq 'action')||($query->{'cmd'} eq 'wrmemo'));

	$sow->{'saytype'} = $saytype;

	my $mes = &SWString::GetTrimString($sow, $vil, $query->{'mes'});
	my  $saypoint = 0;
	if      ( $cost eq 'none' ){
		$saypoint = 0;
	} elsif ( $cost eq 'count' ) {
		$saypoint = 1;
	} elsif ( $cost eq 'point' ) {
		$saypoint = &SWBase::GetSayPoint($sow, $vil, $mes);
	}
	if ( $saypoint > 0 ){
		# 発言数がない（仮）
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "発言数が足りません。","not enough saypoint.[$pttype: $writepl->{$pttype} / $saypoint]") if ((!defined($writepl->{$pttype})) || (($writepl->{$pttype} - $saypoint) < 0));
	}

	# 発言
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);

	if (($pttype ne 'none')&&($logsubid eq $sow->{'LOGSUBID_SAY'})&&($writepl->{'lastwritepos'} >= 0)) {
		# 二重発言防止
		my $target     = $targetpl->{'uid'};
		my $log = $logfile->read($writepl->{'lastwritepos'});
		my $logtarget  = $log->{'target'};
		my $logmestype = $log->{'mestype'};
		my $logmes     = $log->{'log'};
		$logmes = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $logmes);
		my $same = 1;
		$same = 0 if ($logmes     ne $mes);
		$same = 0 if ($logmestype != $mestype);
		$same = 0 if ($logtarget  ne $target);
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "直前の発言と同じ内容の発言をしようとしています。","same last mes.") if ($same);
	}

	# アクションの等幅は隠し機能という事で（ぉ
	my $monospace = 0 + $query->{'monospace'};

	my $expression = 0;
	$expression = $query->{'expression'} if (defined($query->{'expression'}));

	my %say = (
		mestype    => $mestype,
		logsubid   => $logsubid,
		uid        => $writepl->{'uid'},
		target     => $targetpl->{'uid'},
		csid       => $writepl->{'csid'},
		cid        => $writepl->{'cid'},
		chrname    => $chrname,
		que        => $que,
		expression => $expression,
		mes        => &SWLog::CvtRandomText($sow, $vil, $mes) . $mes_postfix,
		memoid     => $memoid,
		undef      => 0,
		monospace  => $monospace,
	);

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "before_executesay. [uid=$writepl->{'uid'}, vid=$vil->{'vid'}]");
	my $lastwritepos = $logfile->executesay(\%say);
	$logfile->close();

	if ($cost ne 'none'){
		# 発言数消費
		$writepl->{$pttype} -= $saypoint;
		if (($logsubid == $sow->{'LOGSUBID_SAY'})) {
			# 発言済み回数／pt
			$writepl->{'saidpoint'} += $saypoint if (($mestype == $sow->{'MESTYPE_SAY'}) || ($mestype == $sow->{'MESTYPE_VSAY'}) || ($mestype == $sow->{'MESTYPE_GSAY'}));
		}
	}
	if ($pttype ne 'none'){
		$writepl->{'limitentrydt'} = $sow->{'time'} + $sow->{'cfg'}->{'TIMEOUT_ENTRY'} * 24 * 60 * 60 if ($writepl->{'limitentrydt'} > 0);
		$writepl->{'lastwritepos'} = $lastwritepos;

		$vil->writevil();
	}
}

1;
