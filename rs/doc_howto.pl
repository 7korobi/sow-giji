package SWDocHowTo;

#----------------------------------------
# �V�ѕ�
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => '�V�ѕ�', # �^�C�g��
	};

	return bless($self, $class);
}

#---------------------------------------------
# �V�ѕ��̕\��
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
  log: '���ɂ́A�l�X�ȓ���\\�͂����ҁi�܂��͎����Ȃ��ҁj�����܂��B\\
���̑����͑����̔\\�͎ҁA�����炩�͐l�T���̔\\�͎ҁA������������A����ȊO�̐w�c�̎҂����邩������܂���B\\
<a class="btn edge" href="sow.cgi?cmd=roleaspect&$docid">�\\�́A���b���Ƃ́A�ׂ�������</a>���Q�l�ɂ��܂��傤�B\\
�܂��A\\
<a class="btn edge" href="sow.cgi?cmd=rolelist&$docid">��E�ƃC���^�[�t�F�[�X</a>\\
�ŁA�Q�[�����̑���Ղ⌋�ʕ\\�����݂邱�Ƃ��ł��܂��B'
},
{ _id: "howto-head-h3-31",
  object: "winners find $enemy name_human"
},
{ _id: "howto-paragraph--32",
  log: '���ɂ͑P�ǂȑ��l�B�̑��ɁA�l�Ԃł���Ȃ���G�ɉ�闠�؂�ҒB�����܂��B��͂��Ȃ������̎��Ԃł��B'
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
