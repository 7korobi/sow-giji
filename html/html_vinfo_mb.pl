package SWHtmlVilInfoMb;

#----------------------------------------
# ������ʂ�HTML�o�́i���o�C���j
#----------------------------------------
sub OutHTMLVilInfoMb {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $i;

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

	# ���f�[�^�̓ǂݍ���
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader("���̏�� / $sow->{'query'}->{'vid'} $vil->{'vname'}"); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	my $vplcntstart = '';
	$vplcntstart = $vil->{'vplcntstart'} if ($vil->{'vplcntstart'} > 0);

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	# �����y�у����N�\��
	print "<a $atr_id=\"top\">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>\n";

	# �L�������\��
	if (defined($sow->{'curpl'}->{'uid'})) {
		my $chrname = $sow->{'curpl'}->getlongchrname();
		my $rolename = $sow->{'curpl'}->getrolename();
		print "$chrname$rolename<br$net>\n";
	}

	# ���t�ʃ��O�ւ̃����N
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0);

	my $pllist = $vil->getpllist();
	my $lastcnt = $vil->{'vplcnt'} - @$pllist;
	if (($vil->{'turn'} == 0) && ($lastcnt > 0)) {
		print <<"_HTML_";
���� $lastcnt �l�Q���ł��܂��B
<hr$net>
_HTML_
	}

	# $vil->{'vcomment'} =~ s/(s?https?:\/\/[^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/<a href=\"$&\">&lt;$1&gt;<\/a>/g;

	require "$cfg->{'DIR_RS'}/doc_rule.pl";
	my $doc = SWDocRule->new($sow);
	my $nrule = $doc->{'n_rule'};

	my $ncomment = "�����̃��[��";

	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		$ncomment .= "<br$net>".($i+1).".$name";
	}

	print <<"_HTML_";
�����̖��O<br$net>$vil->{'vname'}
<hr$net>

_HTML_

	my $rating = 'default';
	$rating = $vil->{'rating'} if ($vil->{'rating'} ne '');
	print <<"_HTML_";
���������F<br$net>$sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'}
<hr$net>

_HTML_

	print <<"_HTML_";
�����̐���<br$net>$vil->{'vcomment'}<br$net>$ncomment<br$net><br$net>
<hr$net>
_HTML_

	my $updatedt = sprintf("%02d��%02d��", $vil->{'updhour'}, $vil->{'updminite'});
	print <<"_HTML_";
���X�V����<br$net>$updatedt
<hr$net>
_HTML_

	my $interval   = sprintf('%02d����', $vil->{'updinterval'} * 24);
	my $saycnttype = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	print <<"_HTML_";
���X�V�Ԋu<br$net>$interval
<hr$net>
�����������F<br$net>$saycnttype->{'CAPTION'} $saycnttype->{'HELP'}
<hr$net>
_HTML_

	my $plcnt;
	if ($vil->{'turn'} == 0) {
		$plcnt = $vil->{'vplcnt'};
		print <<"_HTML_";
������i�_�~�[���݁j<br$net>$plcnt�l
<hr$net>
_HTML_
	} else {
		$plcnt = @$pllist;
		print <<"_HTML_";
���l���i�_�~�[���݁j<br$net>$plcnt�l
<hr$net>
_HTML_
	}

	if (($vil->{'starttype'} eq 'wbbs') && ($vil->{'turn'} == 0)) {
		print <<"_HTML_";
���Œ�l��<br$net>$vplcntstart�l
<hr$net>
_HTML_
	}

	my $secret = $vil->isepilogue();
	$secret = 1 if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});
	my $maker = ($sow->{'uid'} eq $vil->{'makeruid'});

	if ($secret||$maker||($vil->{'mob'} ne 'gamemaster')) {
		my $roleid = $sow->{'ROLEID'};
		my $giftid = $sow->{'GIFTID'};
		my $eventid = $sow->{'EVENTID'};
		my $roletabletext;

		print <<"_HTML_";
����E�z���F<br$net>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}
_HTML_
		# ��E�z���\��
		require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
		my ( $rolematrix, $giftmatrix, $eventmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $plcnt);
		$roletabletext = '';
		for ($i = 1; $i < @$roleid; $i++) {
			my $roleplcnt = $rolematrix->[$i];
			$roleplcnt++ if ($i == $sow->{'ROLEID_VILLAGER'}); # �_�~�[�L�����̕��P���₷
			if ($roleplcnt > 0) {
				$roletabletext .= "$sow->{'textrs'}->{'ROLENAME'}->[$i]x$roleplcnt ";
			}
		}
		for ($i = 2; $i < @$giftid; $i++) {
			my $giftplcnt = $giftmatrix->[$i];
			if ($giftplcnt > 0) {
				$roletabletext .= "$sow->{'textrs'}->{'GIFTNAME'}->[$i]x$giftplcnt ";
			}
		}
		for ($i = 1; $i < @$eventid; $i++) {
			my $eventplcnt = $eventmatrix->[$i];
			if ($eventplcnt > 0) {
				$roletabletext .= "$sow->{'textrs'}->{'EVENTNAME'}->[$i]x$eventplcnt�� ";
			}
		}
		print "�i$roletabletext�j<br$net>\n"
	} else {
		print <<"_HTML_";
����E�z���F�i����J�j
_HTML_
	}
	print "<hr$net>\n";


	my $mob = 'visiter';
	if ($vil->{'mob'} ne ''){
		$mob = $vil->{'mob'};
		print <<"_HTML_";
�������l�F<br$net>$sow->{'basictrs'}->{'MOB'}->{$mob}->{'CAPTION'}�� $vil->{'cntmob'}�l�܂� �i$sow->{'basictrs'}->{'MOB'}->{$mob}->{'HELP'}�j</p>
<hr$net>

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
�����[���@<br$net>$votetype
<hr$net>
_HTML_

	if ($vil->{'turn'} == 0) {
		my $scraplimit = $sow->{'dt'}->cvtdtmb($vil->{'scraplimitdt'});
		$scraplimit = '�����p���Ȃ�' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
���p�������F<br$net>$scraplimit
<hr$net>

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
���o��l��<br$net>$csidcaptions
<hr$net>
���J�n���@�F<br$net>$sow->{'basictrs'}->{'STARTTYPE'}->{$vil->{'starttype'}}
<hr$net>
�����͌n�F<br$net>
$sow->{'textrs'}->{'CAPTION'}<br$net>
$sow->{'textrs'}->{'HELP'}
<hr$net>
�����[���F<br$net>
$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'CAPTION'}<br$net>
$sow->{'basictrs'}->{'GAME'}->{$vil->{'game'}}->{'HELP'}
<hr$net>
_HTML_

	if ($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) {
		my $randomtarget = '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂Ȃ�';
		$randomtarget = '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂�' if ($vil->{'randomtarget'} > 0);
		print <<"_HTML_";
�������_���F<br$net>$randomtarget
<hr$net>
_HTML_
	}

	my $showid = '���J���Ȃ�';
	$showid = '���J����' if ($vil->{'showid'} > 0);
	print <<"_HTML_";
��ID���J�F<br$net>$showid
<hr$net>
_HTML_

	if ($cfg->{'ENABLED_UNDEAD'} == 1){
		my $undead = '���Ȃ�';
		$undead = '����' if ($vil->{'undead'} > 0);
		print <<"_HTML_";
���H�E�g�[�N�F<br$net>$undead
<hr$net>
_HTML_
	}

	my $noselrole = '��E��]�L��';
	$noselrole = '��E��]����' if ($vil->{'noselrole'} > 0);
	print <<"_HTML_";
����E��]�F<br$net>$noselrole
<hr$net>

_HTML_

	}

	if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0)) {
		# �R�~�b�g��
		my $textrs = $sow->{'textrs'};
		my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);
		my $nextcommitdt = '';
		if ($totalcommit == 3) {
			$nextcommitdt = $sow->{'dt'}->cvtdtmb($vil->{'nextcommitdt'});
			$nextcommitdt = "<br$net>(" . $nextcommitdt . '�X�V�\��)' . "<br$net>";
		}

		print <<"_HTML_";
���R�~�b�g�󋵁F<br$net>$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[$totalcommit]
$nextcommitdt<hr$net>

_HTML_
	}

	print <<"_HTML_";
���i�荞�݁F<br$net>
_HTML_
	print "(�v�����[�O�͑ΏۊO)<br$net>
\n" if ($vil->{'turn'} == 0);

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'pno'} = '';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	&OutHTMLSayFilterPlayersMb($sow, $vil, 'live'      ,'������');
	&OutHTMLSayFilterPlayersMb($sow, $vil, 'victim'    ,'�]����');
	&OutHTMLSayFilterPlayersMb($sow, $vil, 'executed'  ,'���Y��');
	&OutHTMLSayFilterPlayersMb($sow, $vil, 'suddendead','�ˑR����');
	&OutHTMLSayFilterPlayersMb($sow, $vil, 'mob'       ,$sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'});

	print "<a href=\"$urlsow?$linkvalue\">����</a><br$net>\n" if ($vil->{'turn'} != 0);

	print <<"_HTML_";
<hr$net>

_HTML_

	# ���t�ʃ��O�ւ̃����N
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# �l�t�B���^�̐l�����̕\��
#----------------------------------------
sub OutHTMLSayFilterPlayersMb {
	my ($sow, $vil, $livetype, $header) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};


	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'pno'} = '';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	my $pllist = $vil->getallpllist();
	my @filterlist;
	foreach (@$pllist) {
		push(@filterlist, $_) if ($_->{'live'} eq $livetype);
		push(@filterlist, $_) if (($_->{'live'} eq 'cursed')  && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'droop')   && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'suicide') && ($livetype eq 'victim'));
		push(@filterlist, $_) if (($_->{'live'} eq 'feared')  && ($livetype eq 'victim'));
	}
	my $persuades = 0;
	foreach (@$pllist) {
		next if ($_->{'live'} ne $livetype);
		next if ($_->{'uid'}  eq $cfg->{'USERID_NPC'});
		$persuades += $_->{'actaddpt'}
	}

	@filterlist = sort {$a->{'deathday'} <=> $b->{'deathday'} ? $a->{'deathday'} <=> $b->{'deathday'} : $a->{'pno'} <=> $b->{'pno'}} @filterlist if ($livetype ne 'live');
	my $filtercnt = @filterlist;

	print "��$header ($filtercnt�l $persuades��)<br$net>\n" if($livetype eq 'live');
	print "��$header ($filtercnt�l)<br$net>\n"              if($livetype ne 'live');


	foreach (@filterlist) {
		my $chrname = $_->getlongchrname();
		my $unit = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COST_SAY'}}->{'UNIT_SAY'};
		my $restsay = $_->{'say'};
		$restsay = $_->{'gsay'} if ($_->{'live'} ne 'live');

		if ($vil->{'turn'} == 0) {
			print "$chrname";
		} else {
			print "<a href=\"$urlsow?$linkvalue$amp" . "pno=$_->{'pno'}\">$chrname</a>";
		}
		print "($_->{'deathday'}d)" if (($livetype ne 'live')&&($livetype ne 'mob'));
		my $live = 'live';
		$live = $sow->{'curpl'}->{'live'} if (defined($sow->{'curpl'}->{'live'}));
		my $viewall = 0;
		$viewall = $vil->ispublic($_);
		$viewall = 1 if ($live ne 'live');
		# ���I
		$viewall = 0 if ($vil->iseclipse($vil->{'turn'}));
		if ($viewall != 0) {
			my $restsay = &SWBase::GetSayCountText($sow, $vil, $_);
			print " �c$restsay<br$net>\n";
		} else {
			print "<br$net>\n";
		}
	}

	return;
}

1;
