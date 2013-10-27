package SWHtmlChrList;

#----------------------------------------
# キャラ一覧画面のタイトル
#----------------------------------------
sub GetHTMLChrListTitle { 
	return 'キャラ人気投票、募集中！';
}

#----------------------------------------
# キャラ一覧HTML出力
#----------------------------------------
sub OutHTMLChrList { 
	my $sow = $_[0];
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};



	# キャラセットの取得
	my $csid = '';
	if ($sow->{'query'}->{'csid'} ne '') {
		$csid = $sow->{'query'}->{'csid'};
	} else {
		$csid = $cfg->{'CSIDLIST'}->[0];
	}

	$query->{'csid'} = $csid;
	$query->{'cmd'}  = 'facevote';

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
	my $order = $charset->{'ORDER'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	print <<"_HTML_";
<h2>$charset->{'CAPTION'}</h2>
<div class="chrlist" template="navi/chr_list">
<p class="mark">キャラクター一覧</p>
</div>
<script>
gon={
	chrs:[]
};
_HTML_
	foreach (@$order) {
		my $face = $_;
		my $chrimg  = $charset->{'DIR'}. "/" . $_ . $body . $expression . $charset->{'EXT'};
		my $chrname = $charset->{'CHRNAME'}->{$_};
		my $chrjob  = $charset->{'CHRJOB' }->{$_};
		my $expression = '';
		$expression = '_0' if (@{$charset->{'EXPRESSION'}} > 0);
		my $romanname = '';
		$romanname = "<br$net>$charset->{'CHRROMANNAME'}->{$_}" if (defined($charset->{'CHRROMANNAME'}));

		print <<"_HTML_";
gon.chrs.push({
	"img": "$chrimg",
 	"text": "$chrjob<br>$chrname$romanname"
});
_HTML_
	}


	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');
	my $img = $charset->{'DIR'}. "/" . $charset->{'NPCID'} . "$expression$charset->{'EXT'}";
	my $chrname = $charset->{'CHRNAME'}->{$charset->{'NPCID'}};
	my $chrjob  = $charset->{'CHRJOB' }->{$charset->{'NPCID'}};

	print <<"_HTML_";
</script>

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