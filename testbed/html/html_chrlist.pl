package SWHtmlChrList;

#----------------------------------------
# �L�����ꗗ��ʂ̃^�C�g��
#----------------------------------------
sub GetHTMLChrListTitle { 
	return '�L�����l�C���[�A��W���I';
}

#----------------------------------------
# �L�����ꗗHTML�o��
#----------------------------------------
sub OutHTMLChrList { 
	my $sow = $_[0];
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};



	# �L�����Z�b�g�̎擾
	my $csid = '';
	if ($sow->{'query'}->{'csid'} ne '') {
		$csid = $sow->{'query'}->{'csid'};
	} else {
		$csid = $cfg->{'CSIDLIST'}->[0];
	}

	$query->{'csid'} = $csid;
	$query->{'cmd'}  = 'facevote';

	# ���\�[�X�̓ǂݍ���
	$sow->{'charsets'}->loadchrrs($csid);
	my $charset = $sow->{'charsets'}->{'csid'}->{$csid};
	my $body = $charset->{'BODY'}; # �S�g�摜�̗L��

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
<h2>�L�����N�^�[�ꗗ [$charset->{'CAPTION'}�Z�b�g]</h2>
<table class="chrlist">
<tbody>
_HTML_
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
		print "<td><img src=\"$charset->{'DIR'}/" . $_ . "$body$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrname�̉摜\"$net>\n";
		print "<br$net><img src=\"$charset->{'DIR'}/" . $_ . "_face$expression$charset->{'EXT'}\" width=\"$charset->{'IMGFACEW'}\" height=\"$charset->{'IMGFACEH'}\" alt=\"$chrname�̊�摜\"$net>\n" if ($body ne '');
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

<h3>�`�ŏ��̋]���ҁ`</h3>

<table class="mes_nom">
<tr class="say">
<td class="img"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt="$chrname�̊�摜"$net>
<td class="field"><DIV class="msg">
  <h3 class="mesname"> <a name="SS00001">$chrjob $chrname</a></h3>
  <p class="mes_text">$charset->{'NPCSAY'}->[0]</p>
  <p class="mes_date">�`�v�����[�O�`</p>
</DIV>
</table>
<table class="mes_nom">
<tr class="say">
<td class="img"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt="$chrname�̊�摜"$net>
<td class="field"><DIV class="msg">
  <h3 class="mesname"> <a name="SS00002">$chrjob $chrname</a></h3>
  <p class="mes_text">$charset->{'NPCSAY'}->[1]</p>
  <p class="mes_date">�`1���ځ`</p>
</DIV>
</table>

_HTML_

	return;
}

1;