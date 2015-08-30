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
  log: '���ɂ́A�l�X�ȓ���\�͂����ҁi�܂��͎����Ȃ��ҁj�����܂��B\\
���̑����͑����̔\�͎ҁA�����炩�͐l�T���̔\�͎ҁA������������A����ȊO�̐w�c�̎҂����邩������܂���B\\
<a class="btn edge" href="sow.cgi?cmd=roleaspect&$docid">�\�́A���b���Ƃ́A�ׂ�������</a>���Q�l�ɂ��܂��傤�B\\
�܂��A\\
<a class="btn edge" href="sow.cgi?cmd=rolelist&$docid">��E�ƃC���^�[�t�F�[�X</a>\\
�ŁA�Q�[�����̑���Ղ⌋�ʕ\�����݂邱�Ƃ��ł��܂��B'
},
{ _id: "howto-head-h3-31",
  log: 'RAILS.winner.$enemy.CAPTION-HUMAN'
},
{ _id: "howto-paragraph--32",
  log: '���ɂ͑P�ǂȑ��l�B�̑��ɁA�l�Ԃł���Ȃ���G�ɉ�闠�؂�ҒB�����܂��B��͂��Ȃ������̎��Ԃł��B'
},
{ _id: "howto-paragraph--33",
  log: 'RAILS.winner.$enemy.HELP'
}
];

</script>

<div class="message_filter" id="item-howto"></div>

<div id="filter_role">
<table border="1" class="table" summary="�\\�͎҈ꗗ�i�����j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_HUMANSIDE'}; $i<$sow->{'SIDEED_HUMANSIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain .= '<br><b>�i�����ƁA���̂����o���\���������܂��j</b><br>'.$sow->{'textrs'}->{'RESULT_RIGHTWOLF'} if ($sow->{'ROLEID_RIGHTWOLF'} == $i);
		$explain =~ s/_ROLESUBID_/�F�̂���/g if ($sow->{'ROLEID_STIGMA'}    == $i);

	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}

	print <<"_HTML_";
</tbody>
</table>
</div>
</div>
<hr class="invisible_hr"$net>

<div id="filter_roleenemy">
<table border="1" class="table" summary="�\\�͎҈ꗗ�i$enemy�j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_ENEMY'}; $i<$sow->{'SIDEED_ENEMY'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain =~ s/_NPC_/��������̋]����/g if ($sow->{'ROLEID_MUPPETING'} == $i);

	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
</div>
<hr class="invisible_hr"$net>

<div id="filter_rolewolf">
<table border="1" class="table" summary="�\\�͎҈ꗗ�i�l�T���j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_WOLFSIDE'}; $i<$sow->{'SIDEED_WOLFSIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain =~ s/_NPC_/��������̋]����/g if ($sow->{'ROLEID_MUPPETING'} == $i);

	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<div id="filter_rolepixi">
<table border="1" class="table" summary="�\\�͎҈ꗗ�i��O���́j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_PIXISIDE'}; $i<$sow->{'SIDEED_PIXISIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<div id="filter_roleother">
<table border="1" class="table" summary="�\\�͎҈ꗗ�i���̑��j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_OTHER'}; $i<$sow->{'SIDEED_OTHER'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain .= '<br><b>�i��������̑��̒��ӓ_�j</b><br>���������鑺��V�Ԃɂ́A�l����葽�߂̗ʂ̖�E���w�肵�܂��B�Ⴆ�΁A10�l�̑���13�l�̖�E���w�肵�Ă���΁A3�l���̖�E���A�u�N���Ȃ�Ȃ������c���E�v�ł��B' if ($sow->{'ROLEID_ROBBER'} == $i);
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<div id="filter_rolegift">
<table border="1" class="table" summary="���b�ꗗ">
<thead>
  <tr>
    <th scope="col">���b</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'GIFTID_DEAL'}; $i<$sow->{'COUNT_GIFT'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&giftid=GIFTID_".uc($sow->{'GIFTID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'GIFTNAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_gift'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<div id="filter_event">
<table border="1" class="table" summary="�����ꗗ">
<thead>
  <tr>
    <th scope="col">����</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	# �_�~�[�f�[�^�̐���
	for( $i=1; $i<$sow->{'COUNT_EVENT'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'EVENTNAME'}->[$i] );
		my $name    = $sow->{'textrs'}->{'EVENTNAME'}->[$i];
		my $explain = $sow->{'textrs'}->{'EXPLAIN_EVENT'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<table class=table>
<thead>
<tr>
<th scope="col">���s</th>
<th scope="col">�����錾</th>
</tr>
</thead>
<tbody class=sayfilter_incontent>
_HTML_

	my $announce_winner = $sow->{'textrs'}->{'ANNOUNCE_WINNER'};
	for( $i=1; $i< @$announce_winner; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'CAPTION_WINNER'}->[$i] );
		my $name    = $sow->{'textrs'}->{'CAPTION_WINNER'}->[$i];
		my $explain = $sow->{'textrs'}->{'ANNOUNCE_WINNER'}->[$i];
		$name = "�݂�ȗx����<br>�@".$name if ( $i == $sow->{'WINNER_PIXI'}   );
		$name = "���l�̉A��<br>�@".$name  if ( $i == $sow->{'WINNER_PIXI_H'} );
		$name = "�l�T�̉A��<br>�@".$name if ( $i == $sow->{'WINNER_PIXI_W'} );
		$name = "�����҂Ȃ�" if ( $i == $sow->{'WINNER_NONE'} );
	print <<"_HTML_";
<tr>
<td nowrap>$name</td>
<td>$explain</td>
</tr>
_HTML_
	}

	print <<"_HTML_";
<tr>
<td><td>
</tr>
<tr>
<td nowrap>+�����V������</td>
<td>$sow->{'textrs'}->{'ANNOUNCE_WINNER_DISH'}</td>
</tr>
</tbody>
</table>

<p class="paragraph">
��������̓G�s���[�O�̎��Ԃł��B�������ꂽ�S�Ă̔����Ȃǂ�b�̎�ɂ��āA�݂�ȂŐF�X�΂�����Q�����肵�܂��傤�B�y�����ĕʂ��Ȃ�A�����Đl����͍X�V���������Ă������ł��傤�B�����l�ł����B
</p>
</div>
<hr class="invisible_hr"$net>
</div>
</DIV>
_HTML_

}

1;
