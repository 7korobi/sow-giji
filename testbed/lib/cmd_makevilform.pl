package SWCmdMakeVilForm;

#----------------------------------------
# 村作成表示
#----------------------------------------
sub CmdMakeVilForm {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevilform.pl";

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, 0);
	$vil->createbasevil();
	$vil->{'vplcnt'} = 8;
	$vil->{'vplcntstart'} = 8;
	$vil->{'trsid'} = $sow->{'cfg'}->{'DEFAULT_TEXTRS'};
	$vil->{'updhour'} = 0;
	$vil->{'updminite'} = 0;
	$vil->{'updinterval'} = 1;
	$vil->{'rating'} = 'default';
	$vil->{'saycnttype'} = $sow->{'cfg'}->{'CSIDLIST'}->[0];
	$vil->{'votetype'} = $sow->{'cfg'}->{'DEFAULT_VOTETYPE'};
	$vil->{'randomtarget'} = 0;
	$vil->{'showid'} = 0;
	$vil->{'undead'} = 0;
	$vil->{'noselrole'} = 0;

	$vil->{"cntmob"} = 0;
	my $roleid = $sow->{'ROLEID'};
	for ($i = 1; $i < @$roleid; $i++) {
		$vil->{"cnt$roleid->[$i]"} = 0;
	}
	my $giftid = $sow->{'GIFTID'};
	for ($i = 1; $i < @$giftid; $i++) {
		$vil->{"cnt$giftid->[$i]"} = 0;
	}
	$vil->{"eventcard"} = "";

	&SWHtmlMakeVilForm::OutHTMLMakeVilForm($sow, $vil);
}

1;
