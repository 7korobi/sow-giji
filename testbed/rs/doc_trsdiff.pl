package SWDocTrsDiff;

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => "基本設定による違い", # タイトル
	};

	return bless($self, $class);
}

#----------------------------------------
# 役職配分表のHTML出力
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
<h2>言い換え一覧</h2>
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
		sympathy => '共鳴ログ',
		wolf     => '人狼ログ',
		pixi     => '星人ログ',
		muppet   => '憑依ログ',
	);
	
	print <<"_HTML_";
<h3><a $atr_id="ending">勝利者</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="勝利陣営\表\示一覧">
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

<h3><a $atr_id="role">村側の能\力者（役職）</a></h3>
<table style="font-size: smaller;" border="1" class="vindex" summary="能\力者一覧（村側）">
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
	
	my $enemy = "狼側";
	$enemy    = "破滅側" if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );
	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

<h3><a $atr_id="role">$enemyの能\力者（役職）</a></h3>
<table style="font-size: smaller;" border="1" class="vindex" summary="能\力者一覧（村側）">
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

<h3><a $atr_id="rolewolf">人狼側の能\力者（役職）</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="能\力者一覧（人狼側）">
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

<h3><a $atr_id="rolepixi">第三勢力の能\力者（役職）</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="能\力者一覧（第三勢力）">
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

<h3><a $atr_id="roleother">それ以外の能\力者（役職）</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="能\力者一覧（その他）">
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

<h3><a $atr_id="rolegift">役職以外の能\力（恩恵）</a></h3>
<table style="font-size: smaller;;" border="1" class="vindex" summary="能\力者一覧（恩恵）">
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

<h3><a $atr_id="event">事件</a></h3>
<div>
<p class="paragraph">
<a href="sow.cgi?cmd=howto&trsid=$query->{'trsid'}#event">事件の説明</a>は、遊び方のページにある。
</p>
<table style="font-size: smaller;;" border="1" class="vindex" summary="事件一覧">
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
