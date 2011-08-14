#!/usr/bin/perl

my $cmd  = $ENV{'QUERY_STRING'};
my $link = 'http://utage.sytes.net/wolf/';
my $ultimate = 'http://www5.atpages.jp/conference/ultimate/sow.cgi?cmd=rolelist&css=&trsid=all';
my $cabala   = 'http://party.ps.land.to/kitchen/sow.cgi?cmd=rolelist&css=&trsid=all';
my $lobby    = 'http://crazy-crazy.sakura.ne.jp/giji_lobby/lobby/sow.cgi?';
my $manual_event = 'http://crazy-crazy.sakura.ne.jp/giji/?(Event)';
my $manual_gift  = 'http://crazy-crazy.sakura.ne.jp/giji/?(Gift)';
my $manual_role  = 'http://crazy-crazy.sakura.ne.jp/giji/?(Role)';

if(      $cmd =~ m/^OFFPARTY/){
	$cmd  =~ s/^OFFPARTY&?//;
#	$link = 'http://utage.sytes.net/WebRecord/vil/OFFPARTY/6/info';
	$link = 'http://party.ps.land.to/kitchen/sow.cgi?vid=7#newsay';
} elsif( $cmd =~ m/^ALERT/){
	$cmd  =~ s/^ALERT&?//;
	$link = $lobby . $cmd;
} elsif( $cmd =~ m/^LOBBY_VMAKE/){
	$cmd  =~ s/^LOBBY_VMAKE//;
	$link = $lobby . 'vid=6&cmd=vinfo' . $cmd;
} elsif( $cmd =~ m/^LOBBY/){
	$cmd  =~ s/^LOBBY&?//;
	$link = $lobby . $cmd;
} elsif( $cmd =~ m/^EVENTID_/){
	$link = $manual_event . $cmd
} elsif( $cmd =~ m/^GIFTID_/){
	$link = $manual_gift  . $cmd
} elsif( $cmd =~ m/^ROLEID_/){
	$link = $manual_role  . $cmd
} elsif( $cmd =~ m/^ULTIMATE&/){
	$cmd  =~ s/^ULTIMATE//;
	$link = $ultimate . $cmd;
} elsif( $cmd =~ m/^CABALA&/){
	$cmd  =~ s/^CABALA//;
	$link = $cabala . $cmd;
} else {
	$link = $cmd;
}

print "Refresh: 0; URL=".$link."\n\n";
print "Location: ".$link."\n\n";
