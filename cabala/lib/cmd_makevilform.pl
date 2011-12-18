package SWCmdMakeVilForm;

#----------------------------------------
# ‘ºì¬•\Ž¦
#----------------------------------------
sub CmdMakeVilForm {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevilform.pl";
	
	%vil = (
		vname => '',
		vcomment => '',
		vplcnt => 8,
		vplcntstart => 8,
		csid => '',
		trsid => $sow->{'cfg'}->{'DEFAULT_TEXTRS'},
		roletable => '',
		updhour => 0,
		updminite => 0,
		updinterval => 1,
		entrylimit => '',
		entrypwd => '',
		rating => 'default',
		saycnttype => $sow->{'cfg'}->{'CSIDLIST'}->[0],
		votetype => $sow->{'cfg'}->{'DEFAULT_VOTETYPE'},
		starttype => 'manual',
		randomtarget => 0,
		showid => 0,
		undead => 0,
		noselrole => 0,
	);

	$vil{"cntmob"} = 0;
	my $roleid = $sow->{'ROLEID'};
	for ($i = 1; $i < @$roleid; $i++) {
		$vil{"cnt$roleid->[$i]"} = 0;
	}
	my $giftid = $sow->{'GIFTID'};
	for ($i = 1; $i < @$giftid; $i++) {
		$vil{"cnt$giftid->[$i]"} = 0;
	}
	my $eventid = $sow->{'EVENTID'};
	for ($i = 1; $i < @$eventid; $i++) {
		$vil{"cnt$eventid->[$i]"} = 0;
	}

	&SWHtmlMakeVilForm::OutHTMLMakeVilForm($sow, \%vil);
}

1;