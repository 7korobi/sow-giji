package SWHtmlVilInfo;

#----------------------------------------
# ������ʂ�HTML�o��
#----------------------------------------
sub OutHTMLVilInfo {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# JavaScript�̐ݒ�
	$sow->{'html'}->{'file_js'} = $sow->{'cfg'}->{'FILE_JS_VIL'};

	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader("���̏�� / $sow->{'query'}->{'vid'} $vil->{'vname'}"); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C���{�^���\��

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	# ���f�[�^�̓ǂݍ���
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $vid = $vil->{'turn'};
	$vid = $vil->{'epilogue'} if ($vid > $vil->{'epilogue'});
	my $logfile = SWBoa->new($sow, $vil, $vid, 0);
	$logfile->close();

	# ���t�ʃ��O�ւ̃����N
	my $list = $logfile->getlist();
	my @dummy;
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil, \@dummy, $list);

	my $score = '';
	$score =" (<a href=\"$urlsow?$linkvalue$amp" . "cmd=score\">�l�T��</a>)" if ($vil->{'turn'} >= $vil->{'epilogue'});

	print <<"_HTML_";
<h2>���̏��</h2>
_HTML_
	&OutHTMLVilInfoInner($sow,$vil);

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
}


sub OutHTMLVilInfoInner {
	my ($sow,$vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $i;

	my $docid = "css=$query->{'css'}&trsid=$vil->{'trsid'}&game=$vil->{'game'}";

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);


	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = $query->{'vid'};
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	my $vplcntstart = '';
	$vplcntstart = $vil->{'vplcntstart'} if ($vil->{'vplcntstart'} > 0);


	my $pllist = $vil->getpllist();
	my $lastcnt = $vil->{'vplcnt'} - @$pllist;
	if (($vil->{'turn'} == 0) && ($lastcnt > 0)) {
		print <<"_HTML_";
<p class="caution">
���� $lastcnt �l�Q���ł��܂��B
</p>
<hr class="invisible_hr"$net>

_HTML_
	}

	print <<"_HTML_";
<div class="mes_maker"><div class="guide">
<p class="multicolumn_label">���̖��O�F</p>
<p class="multicolumn_left">$vil->{'vname'}</p>
<br class="multicolumn_clear"$net>

_HTML_

	my $rating = 'default';
	$rating = $vil->{'rating'} if ($vil->{'rating'} ne '');
	print <<"_HTML_";

<p class="multicolumn_label">�������F</p>
<p class="multicolumn_left">$sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'}</p>
<br class="multicolumn_clear"$net>
_HTML_

	&SWHtml::ConvertNET($sow, \$vil->{'vcomment'});
	$vil->{'vcomment'} =~ s/(s?https?:\/\/[^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/<a href=\"$&\">$1...<\/a>/g;

	require "$cfg->{'DIR_RS'}/doc_rule.pl";
	my $doc = SWDocRule->new($sow);
	my $nrule = $doc->{'n_rule'};
	
	my $css      = $query->{'css'};
	my $ncomment = "��<a href=\"sow.cgi?cmd=rule&css=$css#rule\">���̃��[��</a>";

	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		$ncomment .= "<br$net>".($i+1).".$name";
	}

	print <<"_HTML_";
<dl class="mes_text_report">
<dd>$vil->{'vcomment'}<br$net>$ncomment<br$net>��<a href=\"sow.cgi?cmd=rule&css=$css#mind\">�S�\\��</a><br$net>
</dl>
</div></div>

<div class="mes_maker"><div class="guide">
<dl class="mes_text_report">
<dt>$sow->{'textrs'}->{'CAPTION'}
<dd>$sow->{'textrs'}->{'HELP'}
</dl>
<dl class="mes_text_report">
<dt>$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'CAPTION'}
<dd>$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'HELP'}
</dl>
_HTML_

	my $updatedt = sprintf("%02d��%02d��", $vil->{'updhour'}, $vil->{'updminite'});
	print <<"_HTML_";
<p class="multicolumn_label">�X�V���ԁF</p>
<p class="multicolumn_left">$updatedt</p>
<br class="multicolumn_clear"$net>

_HTML_
	my $saycnttype = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $recovery = ' �i�����̕�[�͂���܂���B�j';
	$recovery    = ' �i�����̕�[������܂��B�j' if (( 1 == $saycnttype->{'RECOVERY'} )&&( 1 < $vil->{'updinterval'} ));
	my $interval = sprintf('%02d����', $vil->{'updinterval'} * 24).$recovery;
	print <<"_HTML_";
<p class="multicolumn_label">�X�V�Ԋu�F</p>
<p class="multicolumn_left">$interval</p>
<br class="multicolumn_clear"$net>

<p class="multicolumn_label">���������F</p>
<p class="multicolumn_left">$saycnttype->{'CAPTION'} $saycnttype->{'HELP'}</p>
<br class="multicolumn_clear"$net>

_HTML_

	my $plcnt;
	if ($vil->{'turn'} == 0) {
		$plcnt = $vil->{'vplcnt'};
		print <<"_HTML_";
<p class="multicolumn_label">����F</p>
<p class="multicolumn_left">$vil->{'vplcnt'}�l �i�_�~�[�L�������܂ށj</p>
<br class="multicolumn_clear"$net>
_HTML_
	} else {
		$plcnt = @$pllist;
		print <<"_HTML_";
<p class="multicolumn_label">�l���F</p>
<p class="multicolumn_left">$plcnt�l �i�_�~�[�L�������܂ށj</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	if (($vil->{'starttype'} eq 'wbbs') && ($vil->{'turn'} == 0)) {
		print <<"_HTML_";
<p class="multicolumn_label">�Œ�l���F</p>
<p class="multicolumn_left">$vplcntstart�l</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	my $roleid  = $sow->{'ROLEID'};
	my $giftid  = $sow->{'GIFTID'};
	my $eventid = $sow->{'EVENTID'};
	my $roletabletext;

	print <<"_HTML_";
<dl class="mes_text_report">
<dt>
��E�z���F$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}
_HTML_

	if (1){
#	if (($vil->{'turn'} > 0)||($vil->{'roletable'} eq 'custom')) {
		# ��E�z���\��
		require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
		my ( $rolematrix, $giftmatrix, $eventmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $plcnt);
		$roletabletext = '';
		for ($i = 1; $i < @$roleid; $i++) {
			
			my $roleplcnt = $rolematrix->[$i];
			$roleplcnt++ if ($i == $sow->{'ROLEID_VILLAGER'}); # �_�~�[�L�����̕��P���₷
			if ($roleplcnt > 0) {
				my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
				$roletabletext .= "<a href=\"$url\">$sow->{'textrs'}->{'ROLENAME'}->[$i]</a>x$roleplcnt ";
			}
		}
		for ($i = 2; $i < @$giftid; $i++) {
			my $giftplcnt = $giftmatrix->[$i];
			if ($giftplcnt > 0) {
				my $url     = "sow.cgi?cmd=rolelist&$docid&giftid=GIFTID_".uc($sow->{'GIFTID'}->[$i]);
				$roletabletext .= "<a href=\"$url\">$sow->{'textrs'}->{'GIFTNAME'}->[$i]</a>x$giftplcnt ";
			}
		}
		for ($i = 1; $i < @$eventid; $i++) {
			my $eventplcnt = $eventmatrix->[$i];
			if ($eventplcnt > 0) {
				$roletabletext .= "$sow->{'textrs'}->{'EVENTNAME'}->[$i]x$eventplcnt�� ";
			}
		}
		print "<dd>$roletabletext</dd>\n"
	}


	print <<"_HTML_";
<br class="multicolumn_clear"$net>

_HTML_

	my $mob = 'visiter';
	if ($vil->{'mob'} ne ''){
		$mob = $vil->{'mob'};
		print <<"_HTML_";

<p class="multicolumn_label">�����l�F</p>
<p class="multicolumn_left">$sow->{'basictrs'}->{'MOB'}->{$mob}->{'CAPTION'}�� $vil->{'cntmob'}�l�܂� �i$sow->{'basictrs'}->{'MOB'}->{$mob}->{'HELP'}�j</p>
<br class="multicolumn_clear"$net>
_HTML_

	my %votecaption = (
		anonymity => '���L�����[',
		sign => '�L�����[',
	);
	my $votetype = '----';
	if (defined($vil->{'votetype'})) {
		$votetype = $votecaption{$vil->{'votetype'}} if (defined($votecaption{$vil->{'votetype'}}));
	}
	print <<"_HTML_";
<p class="multicolumn_label">���[���@�F</p>
<p class="multicolumn_left">$votetype</p>
<br class="multicolumn_clear"$net>

_HTML_

	if ($vil->{'turn'} == 0) {
		my $scraplimit = $sow->{'dt'}->cvtdt($vil->{'scraplimitdt'});
		$scraplimit = '�����p���Ȃ�' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
<p class="multicolumn_label">�p�������F</p>
<p class="multicolumn_left">$scraplimit</p>
<br class="multicolumn_clear"$net>

_HTML_
	}

	my @csidlist = split('/', "$vil->{'csid'}/");
	chomp(@csidlist);
	my $csidcaptions;
	foreach (@csidlist) {
		$sow->{'charsets'}->loadchrrs($_);
		$csidcaptions .= "$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} ";
	}

	print <<"_HTML_";
</div></div>

<div class="mes_maker"><div class="guide">
<p class="multicolumn_label">�o��l���F</p>
<p class="multicolumn_left">$csidcaptions</p>
<br class="multicolumn_clear"$net>

<p class="multicolumn_label">�J�n���@�F</p>
<p class="multicolumn_left">$sow->{'basictrs'}->{'STARTTYPE'}->{$vil->{'starttype'}}</p>
<br class="multicolumn_clear"$net>

_HTML_

	if ($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) {
		my $randomtarget = '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂Ȃ�';
		$randomtarget = '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂�' if ($vil->{'randomtarget'} > 0);
		print <<"_HTML_";

<p class="multicolumn_label">�����_���F</p>
<p class="multicolumn_left">$randomtarget</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	my $showid = '���J���Ȃ�';
	$showid = '���J����' if ($vil->{'showid'} > 0);
	print <<"_HTML_";

<p class="multicolumn_label">ID���J�F</p>
<p class="multicolumn_left">$showid</p>
<br class="multicolumn_clear"$net>
_HTML_

	if( $sow->{'cfg'}->{'ENABLED_UNDEAD'} == 1 ){
		my $undead = '���Ȃ�';
		$undead = '����' if ($vil->{'undead'} > 0);
		print <<"_HTML_";

<p class="multicolumn_label">�H�E�g�[�N�F</p>
<p class="multicolumn_left">$undead</p>
<br class="multicolumn_clear"$net>
_HTML_
	}
	my $noselrole = '��E��]�L��';
	$noselrole = '��E��]����' if ($vil->{'noselrole'} > 0);
	print <<"_HTML_";

<p class="multicolumn_label">��E��]�F</p>
<p class="multicolumn_left">$noselrole</p>
<br class="multicolumn_clear"$net>
_HTML_

	}

	print "</div>\n\n";

	if (($cfg->{'ENABLED_QR'} > 0) && ($sow->{'user'}->logined() > 0)) {
		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'}   = '';
		$reqvals->{'uid'}   = $sow->{'uid'};
		$reqvals->{'pwd'}   = $sow->{'cookie'}->{'pwd'}; # �b��
		$reqvals->{'order'} = 'd'; # �b��
		$reqvals->{'row'}   = 10; # �b��
		my $backupamp = $sow->{'html'}->{'amp'};
		$sow->{'html'}->{'amp'} = '&';
		my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
		$sow->{'html'}->{'amp'} = $backupamp;
		my $urlsow = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}";
		my $url = &SWBase::EncodeURL("$urlsow?$linkvalue");
		my $imgurl = "$cfg->{'URL_QR'}?s=3$amp" . "d=$url";
		print <<"_HTML_";
<div class="paragraph">
<p class="multicolumn_label">QR�R�[�h�F</p>
<p class="multicolumn_left">
<img src="$imgurl" alt="QR�R�[�h�摜"$net><br$net>
</p>
<br class="multicolumn_clear"$net>
</div></div>

_HTML_
	}

	if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0)) {
		# �R�~�b�g��
		my $textrs = $sow->{'textrs'};
		my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);
		my $nextcommitdt = '';
		if ($totalcommit == 3) {
			$nextcommitdt = $sow->{'dt'}->cvtdt($vil->{'nextcommitdt'});
			$nextcommitdt = '�i' . $nextcommitdt . '�X�V�\��j';
		}
		print <<"_HTML_";
<div class="paragraph">
<p class="multicolumn_label">�R�~�b�g�󋵁F</p>
<p class="multicolumn_left">
$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[$totalcommit]<br$net>
$nextcommitdt
</p>
<br class="multicolumn_clear"$net>
</div></div>

_HTML_
	}

	return;
}

1;
