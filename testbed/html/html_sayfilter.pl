package SWHtmlSayFilter;

#----------------------------------------
# �����t�B���^�̕\��
#----------------------------------------

sub OutHTMLHeader {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net    = $sow->{'html'}->{'net'};
	my $icon   = $cfg->{'DIR_IMG'} . '/icon';

	my $class_sayfilter = 'sayfilter';
	my $style_button_mvfilterleft = $style_inline;
	my $style_button_mvfilterbottom = '';
	my $style_button_fixfilter = '';
	my $style_button_unfixfilter = '';
	if ($sow->{'filter'}->{'layoutfilter'} eq '1') {
		$class_sayfilter = 'sayfilterleft';
		$style_button_mvfilterleft = '';
		$style_button_mvfilterbottom = $style_inline;

		if ($sow->{'filter'}->{'fixfilter'} eq '1') {
			$style_button_unfixfilter = $style_inline;
		} else {
			$style_button_fixfilter = $style_inline;
		}
	}
	print <<"_HTML_";
<div id="sayfilter" class="$class_sayfilter">
  <img id="button_mvfilterleft"   class="sayfilter_button"$style_button_mvfilterleft   src="$icon/mvfilter_left.png"   width="16" height="16" alt="��" title="�t�B���^�����ɔz�u"   $net>
  <img id="button_mvfilterbottom" class="sayfilter_button"$style_button_mvfilterbottom src="$icon/mvfilter_bottom.png" width="16" height="16" alt="��" title="�t�B���^�����ɔz�u"   $net>
  <img id="button_fixfilter"      class="sayfilter_button"$style_button_fixfilter      src="$icon/mvfilter_fix.png"    width="16" height="16" alt="��" title="�t�B���^���Œ�"       $net>
  <img id="button_unfixfilter"    class="sayfilter_button"$style_button_unfixfilter    src="$icon/mvfilter_unfix.png"  width="16" height="16" alt="��" title="�t�B���^�̌Œ������" $net>
_HTML_

	return;
}

sub OutHTMLFooter {
	my ($sow, $vil) = @_;
	print <<"_HTML_";
</div><!-- sayfilter footer -->
_HTML_

	return;
}

sub OutHTMLSayFilter {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net    = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $pllist = $vil->getpllist();

	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $pno = $reqvals->{'pno'};
	$reqvals->{'pno'} = '';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	my $i;

	my $style_inline = ' style="display: inline;"';
	print <<"_HTML_";

<h3 id="filter_header" class="sayfilter_heading">
�t�B���^</h3>

<div id="insayfilter" class="insayfilter">
<div class="paragraph">

_HTML_

	&OutHTMLSayFilterPlayers($sow, $vil, 'live');
	&OutHTMLSayFilterPlayers($sow, $vil, 'victim');
	&OutHTMLSayFilterPlayers($sow, $vil, 'executed');
	&OutHTMLSayFilterPlayers($sow, $vil, 'suddendead');
	&OutHTMLSayFilterPlayers($sow, $vil, 'mob');

	print <<"_HTML_";

<td class="types">

<h4 id="mestypefiltercaption" title="������ʗ��̕\\���^��\\��" >���</h4>
<div id="mestypefilter" class="sayfilter_content">
_HTML_

	my @logmestype = (0, 1, 2, 3, 4, 5);
	my @logmestypetext = &logmestypetexts($sow,$vil);
	my @logmestypeicon = &logmestypeicons($sow,$vil);
	for ($i = 0; $i < @logmestype; $i++) {
		# ���ڒ��́A���ڑΏۂ����t�B���^�ɏo��B
		next if (($i != -$pno)&&($pno < 0));

		print "<div class=\"sayfilter_button_mestype\">";
		print "<div id=\"typefilter_$logmestype[$i]\">";
		print "$logmestypeicon[$i]";
		print "</div>\n";
		if ($i){
			# �|�C���g����ƁA���ڃA���J�[���o��B
			my $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalue&move=page&pageno=1&pno=".(-$i);
			print "<i><div class=\"sayfilter_content_enable sayfilter_incontent calc\"><a href=\"".$link."\" target=\"_blank\">����</a></div></i>";
		}
		print "</div>\n";
	}

	print <<"_HTML_";
</div>

<h4 id="lumpfiltercaption" title="�ꊇ���엓�̕\\���^��\\��">�ꊇ</h4>
<div id="lumpfilter">
  <div id="sayfilter_button_lump_0"  class="sayfilter_button_lump">�S��</div>
  <div id="sayfilter_button_lump_1"  class="sayfilter_button_lump">�S�f</div>
  <div id="sayfilter_button_lump_2"  class="sayfilter_button_lump">���]</div>
</div> 

</tbody></table>

</div>
</div><!-- insayfilter footer -->
_HTML_

	return;
}

sub OutHTMLTools {
	print <<"_HTML_";
<h3 id="notepad_header" class="sayfilter_heading">
�c�[��</h3>
<div id="notepad" class="insayfilter">
<div class="paragraph">
<h4 id="textnotepadcaption" title="�N���b�v�{�[�h�̕\\���^��\\��">�N���b�v�{�[�h</h4>
<div id="textnotepad">
<textarea id="clipboard" name="clipboard" rows="6" style="width: 100%;">
</textarea>

</div>

<h4 id="itempickercaption" title="�s�b�N�A�b�v�̕\\���^��\\��">�s�b�N�A�b�v</h4>
<div id="itempicker">
<div id="checklist" class="sayfilter_content">
<span class="sayfilter_incontent" id="clipbm">�x</span><span class="sayfilter_incontent" id="clipanchor">&gt;&gt;</span><span class="sayfilter_incontent" id="clipseer">��</span><span class="sayfilter_incontent" id="clipexecute">��</span><span class="sayfilter_incontent" id="clipagenda">��</span><span class="sayfilter_incontent" id="cliptopix">�y�z</span><input id="cliptext" name="cliptext" type="text" size=5></div>
<div id="itemlist" class="sayfilter_content">
</div>
</div>
</div>

</div><!-- insayfilter footer -->
_HTML_

	return;
}

#----------------------------------------
# �����t�B���^�̐l�����̕\��
#----------------------------------------
sub OutHTMLSayFilterPlayers {
	my ($sow, $vil, $livetype) = @_;
	my $cfg    = $sow->{'cfg'};
	my $net    = $sow->{'html'}->{'net'};
	my $amp    = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $icon   = $cfg->{'DIR_IMG'} . '/icon';
	my ($saycnt,$cost,$unit) = $vil->getsayptcosts();

	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $pno = $reqvals->{'pno'};
	$reqvals->{'pno'} = '';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	my $turn = $vil->{'turn'};

	my @logmestypetext = &logmestypetexts($sow,$vil);
	my $pllist = $vil->getallpllist();

	# �V���擾�@�\
	# ���ڂ���߂�@�\
	if ('live' eq $livetype){
		if ($sow->{'user'}->logined() > 0) {
			print <<"_HTML_";
<h4 id="newinfo" class="newinfo sayfilter_caption_enable">
<img src="$icon/ajax-loader.gif" style="display: none;">
<a href="$linkvalue#newsay" onclick="getNewLog(this);return false;"></a>
</h4>
_HTML_
		}
		if ($pno == 0){
		} else {
			my $target;
			if($pno < 0){
				$target = $logmestypetext[-$pno];
			} else {
				$target = $vil->getplbypno($pno)->getshortchrname();
			}
			my $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalue&move=page&pageno=1";
			print '<h4 class="sayfilter_caption_enable">���ځF'.$target.' <a href="'.$link.'">��������</a></h4>';
		}
		print <<"_HTML_";
<table><tbody> 
<tr> 
<td class="users"> 
 
_HTML_
	}

	my @filterlist;
	my $persuades = 0;
	foreach (@$pllist) {
		push(@filterlist, $_) if  ($_->{'live'} eq $livetype);
		push(@filterlist, $_) if (($_->{'live'} eq 'cursed')  && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'droop')   && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'suicide') && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'feared')  && ($livetype eq 'victim'));
	}
	foreach (@$pllist) {
		next if ($_->{'live'} ne $livetype);
		next if ($_->{'uid'}  eq $sow->{'cfg'}->{'USERID_NPC'});
		$persuades += $_->{'actaddpt'};
	}

	# �l���ڒ��́A���ڑΏۂ����t�B���^�ɏo��B
	my $pnovisible = 0;
	foreach (@filterlist) {
		$pnovisible++ if (($_->{'pno'} == $pno));
	}
	return if(($pno > 0)&&(! $pnovisible));
	
	my %livetypetext = (
		'live'       => '������<br>',
		'mob'        => $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'} . '��',
		'victim'     => '�]����',
		'executed'   => '���Y��',
		'suddendead' => '�ˑR��',
	);
	my %livetypeno = (
		'live'       => 0,
		'victim'     => 1,
		'executed'   => 2,
		'suddendead' => 3,
		'mob'        => 4,
	);
	my $filtercnt = @filterlist;

	my $enable = 'enable';
	my $display = '';
	if ($sow->{'filter'}->{'livetypes'}->[$livetypeno{$livetype}] eq '1') {
		$enable = 'disenable';
		$display = ' style="display: none;"';
	}
		print "<h4 class=\"sayfilter_caption_$enable\" ";
		print "id=\"livetypecaption_$livetypeno{$livetype}\" ";
		print "title=\"$livetypetext{$livetype}����" . '�\���^��\��" ';
		print ">";
		print "$livetypetext{$livetype} <sub>($filtercnt�l $persuades��)</sub>" if ('live' eq $livetype);
		print "$livetypetext{$livetype} <sub>($filtercnt�l)</sub>"                  if ('live' ne $livetype);
		print "</h4>\n";

	if (($filtercnt > 0 )||($livetype eq 'mob')){
		print "<div id=\"livetype$livetypeno{$livetype}\" class=\"sayfilter_content\"$display>\n";
	}
	my $i = 0;
	$display = '';
	@filterlist = sort {$a->{'deathday'} <=> $b->{'deathday'} ? $a->{'deathday'} <=> $b->{'deathday'} : $a->{'pno'} <=> $b->{'pno'}} @filterlist if ($livetype ne 'live');
	foreach (@filterlist) {
		# �l���ڒ��́A���ڑΏۂ����t�B���^�ɏo��B
		next if (($_->{'pno'} != $pno)&&($pno > 0));

		my $enable = 'enable';
		my $checked = " $sow->{'html'}->{'checked'}";
		if ($sow->{'filter'}->{'pnofilter'}->[$_->{'pno'}] eq '1') {
			$enable = 'disenable';
			$checked = '';
		}

		my $shortchrname = $_->getshortchrname();
		print "<div class=\"sayfilter_incontent\">";
		print "<div id=\"livetype$livetypeno{$livetype}_$i\"$display>";
		print "<div id=\"pnofilter_$_->{'pno'}\" class=\"sayfilter_content_$enable\">$shortchrname</div></div>";
		print "<i><div class=\"sayfilter_content_enable\" style=\"text-align: right;\">";
		my $live = 'live';
		$live = $sow->{'curpl'}->{'live'} if (defined($sow->{'curpl'}->{'live'}));
		my $viewall = 0;
		$viewall = $vil->ispublic($_);
		$viewall = 1 if ($live ne 'live');
		# ���I
		$viewall = 0 if ($vil->iseclipse($vil->{'turn'}));
		if ($viewall != 0) {
			my $restsay = "�c".&SWBase::GetSayCountText($sow, $vil, $_)  if ($cost ne 'none');
			print "$_->{'saidcount'}�� $restsay";
			print "($_->{'deathday'}d) " if (($livetype ne 'live')&&($livetype ne 'mob'));
		} else {
			print "($_->{'deathday'}d) " if (($livetype ne 'live')&&($livetype ne 'mob'));
		}
		# �|�C���g����ƁA���ڃA���J�[���o��B
		if (($_->{'pno'})&&($turn)){
			my $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalue&move=page&pageno=1&pno=".$_->{'pno'};
			print "<a href=\"".$link."\" target=\"_blank\">����</a>";
		}
		print "</div></i></div>\n";
		$i++;
	}
	if ($livetype eq'mob' ){
		my $enable = 'enable';
		my $checked = " $sow->{'html'}->{'checked'}";
		print <<_HTML_;
<div class="sayfilter_incontent"><div id="livetype4_-1"><div id="pnofilter_-1" class="sayfilter_content_$enable">�����o���l�B</div></div></div> 
</div> 
_HTML_
	}

	print "</div>\n" if (($filtercnt > 0 )||($livetype eq 'mob'));
	print "\n";

	return;
}

sub logmestypeicons {
	my ($sow,$vil) = @_;
	my @logmestypetext = (
		'�ʏ�',
		'����',
		'����',
		'����',
		$sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'},
		'�w�i',
	);
	return @logmestypetext;
}

sub logmestypetexts {
	my ($sow,$vil) = @_;
	my @logmestypetext = (
		'�ʏ픭��',
		'�Ƃ茾/�����b',
		'����/����/�O�b',
		'���҂̂��߂�',
		$sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'},
		'�w�i',
	);
	return @logmestypetext;
}

1;
