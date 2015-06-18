package SWHtmlChrList;

#----------------------------------------
# キャラ一覧画面のタイトル
#----------------------------------------
sub GetHTMLChrListTitle { 
	return 'キャラクター一覧';
}

#----------------------------------------
# キャラ一覧HTML出力
#----------------------------------------
sub OutHTMLChrList { 
	my $sow = $_[0];
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $hidden  = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	# キャラセットの取得
	my $csid = '';
	if ($sow->{'query'}->{'csid'} ne '') {
		$csid = $sow->{'query'}->{'csid'};
	} else {
		$csid = $cfg->{'CSIDLIST'}->[0];
	}

	# リソースの読み込み
	$sow->{'charsets'}->loadchrrs($csid);
	my $charset = $sow->{'charsets'}->{'csid'}->{$csid};
	my $body = $charset->{'BODY'}; # 全身画像の有無

	my $cssid = 'default';
	$cssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
	$cssid = 'default' if (!defined($cfg->{'CSS'}->{$cssid}));
	my $csswidth = $cfg->{'CSS'}->{$cssid}->{'WIDTH'};
	my $imgwidth = $charset->{'IMGBODYW'} + 2;
	my $maxwidth = 460;
	$maxwidth = 460 if ( 480 <= $csswidth);
	$maxwidth = 560 if ( 800 <= $csswidth);
	my $width    = $maxwidth;
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	$sow->{'query'}->{'trsid'} = $sow->{'cfg'}->{'DEFAULT_TEXTRS'} if ( "" eq $sow->{'query'}->{'trsid'});

	my $tag = $query->{'tag'};
	print <<"_HTML_";
<p class="paragraph">
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}#newsay" method="$cfg->{'METHOD_FORM_MB'}">
<div class="formpl_content">
<label for="tag">分類タグから探す：</label>
<select name="tag">
_HTML_
	my $charset = $sow->{'charsets'}->{'csid'}->{$csid};
	my $tagorder = $charset->{'TAG_ORDER'};
	foreach (@$tagorder) {
		if (! $tag) { $tag = $_; }
		my $tagname = $sow->{'charsets'}->{'tag'}->{'TAG_NAME'}->{$_};
		my $selected = '';
		my $star = '';
		$selected = " $sow->{'html'}->{'selected'}" if ($_ eq $tag);
		$star = "* " if ($_ eq $tag);
		print "<option value=\"$_\"$selected>$star$tagname$sow->{'html'}->{'option'}\n";
	}
	print <<"_HTML_";
</select>
<input type="hidden" name="csid" value="$query->{'csid'}"$net>$hidden
<input type="hidden" name="cmd" value="$query->{'cmd'}"$net>$hidden
<input type="submit" value="探す"$net>
</div>
</form>
</p>

<h2>キャラクター一覧 [$charset->{'CAPTION'}セット]</h2>
<table class="chrlist">
<tbody>
_HTML_
	my $order = $charset->{'CHRORDER'}->{$tag};
	foreach (@$order) {
		$width -= $imgwidth;
		if ( $width < 0 ){
			print "<tr>";
			$width = $maxwidth - $imgwidth;
		}

		my $face = $_;

		my $background='"chrblank"';
		my $chrname = $charset->{'CHRNAME'}->{$_};
		my $chrjob  = $charset->{'CHRJOB' }->{$_};
		my $expression = '';
		$expression = '_0' if (@{$charset->{'EXPRESSION'}} > 0);
		print "<td><img src=\"$charset->{'DIR'}/" . $_ . "$body$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrnameの画像\"$net>\n";
		print "<br$net><img src=\"$charset->{'DIR'}/" . $_ . "_face$expression$charset->{'EXT'}\" width=\"$charset->{'IMGFACEW'}\" height=\"$charset->{'IMGFACEH'}\" alt=\"$chrnameの顔画像\"$net>\n" if ($body ne '');
		my $romanname = '';
		$romanname = "<br$net>$charset->{'CHRROMANNAME'}->{$_}" if (defined($charset->{'CHRROMANNAME'}));
		print "<div class=$background style=\"width:$charset->{'IMGBODYW'}px;\">$chrjob<br$net>$chrname$romanname</div>\n";
	}


	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');
	my $img = $charset->{'DIR'}. "/" . $charset->{'NPCID'} . "$expression$charset->{'EXT'}";
	my $chrname = $charset->{'CHRNAME'}->{$charset->{'NPCID'}};
	my $chrjob  = $charset->{'CHRJOB' }->{$charset->{'NPCID'}};

	print <<"_HTML_";
</tbody>
</table>

<h3>～最初の犠牲者～</h3>

<table class="mes_nom">
<tr class="say">
<td class="img"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt="$chrnameの顔画像"$net>
<td class="field"><DIV class="msg">
  <h3 class="mesname"> <a name="SS00001">$chrjob $chrname</a></h3>
  <p class="mes_text">$charset->{'NPCSAY'}->[0]</p>
  <p class="mes_date">～プロローグ～</p>
</DIV>
</table>
<table class="mes_nom">
<tr class="say">
<td class="img"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt="$chrnameの顔画像"$net>
<td class="field"><DIV class="msg">
  <h3 class="mesname"> <a name="SS00002">$chrjob $chrname</a></h3>
  <p class="mes_text">$charset->{'NPCSAY'}->[1]</p>
  <p class="mes_date">～1日目～</p>
</DIV>
</table>

_HTML_

	return;
}

1;