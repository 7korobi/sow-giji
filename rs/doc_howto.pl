package SWDocHowTo;

#----------------------------------------
# 遊び方
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => '遊び方', # タイトル
	};

	return bless($self, $class);
}

#---------------------------------------------
# 遊び方の表示
#---------------------------------------------
sub outhtml {
	my $self   = shift;
	my $sow    = $self->{'sow'};
	my $cfg    = $sow->{'cfg'};
	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $query  = $sow->{'query'};
	my $docid = "css=$query->{'css'}&trsid=$query->{'trsid'}";

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, 0);
	$vil->createdummyvil();
	$vil->{'csid'}  = $sow->{'cfg'}->{'DEFAULT_CSID'};
	$vil->{'trsid'} = $sow->{'query'}->{'trsid'};
	$vil->{'saycnttype'} = 'juna';
	$vil->{'turn'} = 1;
	$vil->{'winner'} = 0;
	$vil->{'randomtarget'} = 1;
	$vil->{'makeruid'} = $sow->{'cfg'}->{'USERID_ADMIN'};

	my $enemy = "WIN_WOLF";
	$enemy    = "WIN_EVIL" if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );

	&SWBase::LoadTextRS($sow, $vil);

	print <<"_HTML_";
<script>
gon.items = [
{ _id: "howto-paragraph--20",
  log: '村には、様々な特殊能\力を持つ者（または持たない者）がいます。\\
その多くは村側の能\力者、いくらかは人狼側の能\力者、もしかしたら、それ以外の陣営の者もいるかもしれません。\\
<a class="btn edge" href="sow.cgi?cmd=roleaspect&$docid">能\力、恩恵ごとの、細かい特徴</a>を参考にしましょう。\\
また、\\
<a class="btn edge" href="sow.cgi?cmd=rolelist&$docid">役職とインターフェース</a>\\
で、ゲーム中の操作盤や結果表\示をみることができます。'
},
{ _id: "howto-head-h3-31",
  object: "winners find $enemy name_human"
},
{ _id: "howto-paragraph--32",
  log: '村には善良な村人達の他に、人間でありながら敵に回る裏切り者達もいます。夜はあなたたちの時間です。'
},
{ _id: "howto-paragraph--33",
  object: "winners find $enemy HELP"
}
];

</script>

<div class="message_filter" id="item-howto"></div>
_HTML_

}

1;
