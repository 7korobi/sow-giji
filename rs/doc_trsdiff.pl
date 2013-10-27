package SWDocTrsDiff;

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => "��{�ݒ�ɂ��Ⴂ", # �^�C�g��
	};

	return bless($self, $class);
}

#----------------------------------------
# ��E�z���\��HTML�o��
#----------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	require "$cfg->{'DIR_LIB'}/setrole.pl";

	print <<"_HTML_";
<hr class="invisible_hr"$net>
<h2>���������ꗗ</h2>
<div class="accordion">
_HTML_

	my $ltrsid   = $cfg->{'TRSIDLIST'};
	my $cnttrsid = scalar(@$ltrsid);
	my %itextrs;
	my $ltextrs = \%itextrs;
	foreach (@$ltrsid){
		my %vil = (
			trsid => $_,
		);
		&SWBase::LoadTextRS($sow, \%vil);
		$ltextrs->{$_} = $sow->{'textrs'};
	}
	
	my %sayswitch = (
		sympathy => '�����O',
		wolf     => '�l�T���O',
		pixi     => '���l���O',
		muppet   => '�߈˃��O',
	);
	
	print <<"_HTML_";
<h3><a $atr_id="ending">������</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="�����w�c\�\\���ꗗ">
<thead>
<tr>
_HTML_
	foreach (@$ltrsid){
		print "<th scope=\"col\">$ltextrs->{$_}->{'CAPTION'}</th>";
	}
	print <<"_HTML_";
</thead>
<tbody>
_HTML_
	my $announce_winner = $sow->{'textrs'}->{'ANNOUNCE_WINNER'};
	for( $i=1; $i< @$announce_winner; $i++ ){
		my $bufline = "";
		my $cntline = 0;
		next if ($i == $sow->{'WINNER_PIXI_H'});
		next if ($i == $sow->{'WINNER_PIXI_W'});
		foreach (@$ltrsid){
			if ( '' eq $ltextrs->{$_}->{'CAPTION_WINNER'}->[$i] ){
				$bufline .= "<td >\n";
			} else {
				$cntline++;
				my $name  = $ltextrs->{$_}->{'CAPTION_WINNER'}->[$i];
				my $style = "";
				$style = "style=\"font-weight: bold;\"" if ($_ eq $query->{'trsid'});
				$bufline .= "<td $style><a>$name</a>\n";
			}
		}
		print "<tr>$bufline" if ($cntline);
	}
	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

<h3><a $atr_id="role">�����̔\\�͎ҁi��E�j</a></h3>
<table style="font-size: smaller;" border="1" class="vindex" summary="�\\�͎҈ꗗ�i�����j">
<thead>
<tr>
_HTML_
	print "<th scope=\"col\"></th>";
	foreach (@$ltrsid){
		print "<th scope=\"col\">$ltextrs->{$_}->{'CAPTION'}</th>";
	}
	print <<"_HTML_";
</thead>
<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_HUMANSIDE'}; $i<$sow->{'SIDEED_HUMANSIDE'}; $i++ ){
		my $rolelnk  =  uc($sow->{'ROLEID'}->[$i]);
		my $bufline = '<td><a href="'.$cfg->{'URL_ROLE'}.$rolelnk.'">'.$rolelnk.'</a>';
		my $cntline = 0;
		foreach (@$ltrsid){
			if ( '' eq $ltextrs->{$_}->{'ROLESHORTNAME'}->[$i] ){
				$bufline .= "<td >\n";
			} else {
				$cntline++;
				my $url   = "sow.cgi?cmd=rolelist&css=$query->{'css'}&trsid=$_&roleid=ROLEID_".$rolelnk;
				my $name  = $ltextrs->{$_}->{'ROLENAME'}->[$i];
				my $style = "";
				$style = "style=\"font-weight: bold;\"" if ($_ eq $query->{'trsid'});
				$bufline .= "<td $style><a href=\"$url\">$name</a>\n";
			}
		}
		print "<tr>$bufline" if ($cntline);
	}
	
	my $enemy = "�T��";
	$enemy    = "�j�ő�" if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );
	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

<h3><a $atr_id="role">$enemy�̔\\�͎ҁi��E�j</a></h3>
<table style="font-size: smaller;" border="1" class="vindex" summary="�\\�͎҈ꗗ�i�����j">
<thead>
<tr>
_HTML_
	print "<th scope=\"col\"></th>";
	foreach (@$ltrsid){
		print "<th scope=\"col\">$ltextrs->{$_}->{'CAPTION'}</th>";
	}
	print <<"_HTML_";
</thead>
<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_ENEMY'}; $i<$sow->{'SIDEED_ENEMY'}; $i++ ){
		my $rolelnk  =  uc($sow->{'ROLEID'}->[$i]);
		my $bufline = '<td><a href="'.$cfg->{'URL_ROLE'}.$rolelnk.'">'.$rolelnk.'</a>';
		my $cntline = 0;
		foreach (@$ltrsid){
			if ( '' eq $ltextrs->{$_}->{'ROLESHORTNAME'}->[$i] ){
				$bufline .= "<td >\n";
			} else {
				$cntline++;
				my $url   = "sow.cgi?cmd=rolelist&css=$query->{'css'}&trsid=$_&roleid=ROLEID_".$rolelnk;
				my $name  = $ltextrs->{$_}->{'ROLENAME'}->[$i];
				my $style = "";
				$style = "style=\"font-weight: bold;\"" if ($_ eq $query->{'trsid'});
				$bufline .= "<td $style><a href=\"$url\">$name</a>\n";
			}
		}
		print "<tr>$bufline" if ($cntline);
	}
	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolewolf">�l�T���̔\\�͎ҁi��E�j</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="�\\�͎҈ꗗ�i�l�T���j">
<thead>
<tr>
_HTML_
	print "<th scope=\"col\"></th>";
	foreach (@$ltrsid){
		print "<th scope=\"col\">$ltextrs->{$_}->{'CAPTION'}</th>";
	}
	print <<"_HTML_";
</thead>
<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_WOLFSIDE'}; $i<$sow->{'SIDEED_WOLFSIDE'}; $i++ ){
		my $rolelnk  =  uc($sow->{'ROLEID'}->[$i]);
		my $bufline = '<td><a href="'.$cfg->{'URL_ROLE'}.$rolelnk.'">'.$rolelnk.'</a>';
		my $cntline = 0;
		foreach (@$ltrsid){
			if ( '' eq $ltextrs->{$_}->{'ROLESHORTNAME'}->[$i] ){
				$bufline .= "<td >\n";
			} else {
				$cntline++;
				my $url   = "sow.cgi?cmd=rolelist&css=$query->{'css'}&trsid=$_&roleid=ROLEID_".$rolelnk;
				my $name  = $ltextrs->{$_}->{'ROLENAME'}->[$i];
				my $style = "";
				$style = "style=\"font-weight: bold;\"" if ($_ eq $query->{'trsid'});
				$bufline .= "<td $style><a href=\"$url\">$name</a>\n";
			}
		}
		print "<tr>$bufline" if ($cntline);
	}
	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolepixi">��O���͂̔\\�͎ҁi��E�j</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="�\\�͎҈ꗗ�i��O���́j">
<thead>
<tr>
_HTML_
	print "<th scope=\"col\"></th>";
	foreach (@$ltrsid){
		print "<th scope=\"col\">$ltextrs->{$_}->{'CAPTION'}</th>";
	}
	print <<"_HTML_";
</thead>
<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_PIXISIDE'}; $i<$sow->{'SIDEED_PIXISIDE'}; $i++ ){
		my $rolelnk  =  uc($sow->{'ROLEID'}->[$i]);
		my $bufline = '<td><a href="'.$cfg->{'URL_ROLE'}.$rolelnk.'">'.$rolelnk.'</a>';
		my $cntline = 0;
		foreach (@$ltrsid){
			if ( '' eq $ltextrs->{$_}->{'ROLESHORTNAME'}->[$i] ){
				$bufline .= "<td >\n";
			} else {
				$cntline++;
				my $url   = "sow.cgi?cmd=rolelist&css=$query->{'css'}&trsid=$_&roleid=ROLEID_".$rolelnk;
				my $name  = $ltextrs->{$_}->{'ROLENAME'}->[$i];
				my $style = "";
				$style = "style=\"font-weight: bold;\"" if ($_ eq $query->{'trsid'});
				$bufline .= "<td $style><a href=\"$url\">$name</a>\n";
			}
		}
		print "<tr>$bufline\n" if ($cntline);
	}
	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

<h3><a $atr_id="roleother">����ȊO�̔\\�͎ҁi��E�j</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="�\\�͎҈ꗗ�i���̑��j">
<thead>
<tr>
_HTML_
	print "<th scope=\"col\"></th>";
	foreach (@$ltrsid){
		print "<th scope=\"col\">$ltextrs->{$_}->{'CAPTION'}</th>";
	}
	print <<"_HTML_";
</thead>
<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_OTHER'}; $i<$sow->{'SIDEED_OTHER'}; $i++ ){
		my $rolelnk  =  uc($sow->{'ROLEID'}->[$i]);
		my $bufline = '<td><a href="'.$cfg->{'URL_ROLE'}.$rolelnk.'">'.$rolelnk.'</a>';
		my $cntline = 0;
		foreach (@$ltrsid){
			if ( '' eq $ltextrs->{$_}->{'ROLESHORTNAME'}->[$i] ){
				$bufline .= "<td >\n";
			} else {
				$cntline++;
				my $url   = "sow.cgi?cmd=rolelist&css=$query->{'css'}&trsid=$_&roleid=ROLEID_".$rolelnk;
				my $name  = $ltextrs->{$_}->{'ROLENAME'}->[$i];
				my $style = "";
				$style = "style=\"font-weight: bold;\"" if ($_ eq $query->{'trsid'});
				$bufline .= "<td $style><a href=\"$url\">$name</a>\n";
			}
		}
		print "<tr>$bufline" if ($cntline);
	}
	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolegift">��E�ȊO�̔\\�́i���b�j</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="�\\�͎҈ꗗ�i���b�j">
<thead>
<tr>
_HTML_
	print "<th scope=\"col\"></th>";
	foreach (@$ltrsid){
		print "<th scope=\"col\">$ltextrs->{$_}->{'CAPTION'}</th>";
	}
	print <<"_HTML_";
</thead>
<tbody>
_HTML_
	for( $i=$sow->{'GIFTID_DEAL'}; $i<$sow->{'COUNT_GIFT'}; $i++ ){
		my $giftlnk  = uc($sow->{'GIFTID'}->[$i]);
		my $bufline = '<td><a href="'.$cfg->{'URL_GIFT'}.$giftlnk.'">'.$giftlnk.'</a>';
		my $cntline = 0;
		foreach (@$ltrsid){
			if ( '' eq $ltextrs->{$_}->{'GIFTSHORTNAME'}->[$i] ){
				$bufline .= "<td >\n";
			} else {
				$cntline++;
				my $url   = "sow.cgi?cmd=rolelist&css=$query->{'css'}&trsid=$_&giftid=GIFTID_".$giftlnk;
				my $name  = $ltextrs->{$_}->{'GIFTNAME'}->[$i];
				my $style = "";
				$style = "style=\"font-weight: bold;\"" if ($_ eq $query->{'trsid'});
				$bufline .= "<td $style><a href=\"$url\">$name</a>\n";
			}
		}
		print "<tr>$bufline" if ($cntline);
	}
	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

<h3><a $atr_id="event">����</a></h3>
<div>
<p class="paragraph">
<a href="sow.cgi?cmd=howto&trsid=$query->{'trsid'}#event">�����̐���</a>�́A�V�ѕ��̃y�[�W�ɂ���B
</p>
<table style="font-size: smaller;;" border="1" class="vindex" summary="�����ꗗ">
<thead>
<tr>
_HTML_
	foreach (@$ltrsid){
		print "<th scope=\"col\">$ltextrs->{$_}->{'CAPTION'}</th>";
	}
	print <<"_HTML_";
</thead>
<tbody>
_HTML_
	for( $i=1; $i<$sow->{'COUNT_EVENT'}; $i++ ){
		my $bufline = "";
		my $cntline = 0;
		foreach (@$ltrsid){
			if ( '' eq $ltextrs->{$_}->{'EVENTNAME'}->[$i] ){
				$bufline .= "<td >\n";
			} else {
				$cntline++;
				my $name  = $ltextrs->{$_}->{'EVENTNAME'}->[$i];
				my $style = "";
				$style = "style=\"font-weight: bold;\"" if ($_ eq $query->{'trsid'});
				$bufline .= "<td $style><a>$name</a>\n";
			}
		}
		print "<tr>$bufline" if ($cntline);
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>
</div>
_HTML_

}

1;
