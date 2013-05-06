package SWHtmlVlogSinglePC;

#----------------------------------------
# ���OHTML�̕\���i�G�s���[�O�̔z���ꗗ�j
#----------------------------------------
sub OutHTMLSingleLogCastPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg   = $sow->{'cfg'};
	my $textrs = $sow->{'textrs'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);

	my $winlabel  = '���s';
	my $namelabel = '���O';
	$namelabel = "<a $atr_id=\"newsay\">$namelabel</a>" if ($newsay > 0);
	$winlabel  = '�Q��' if ($cfg->{'ENABLED_WINNER_LABEL'} != 1 );

	print <<"_HTML_";
<table border="1" class="vindex" summary="�z���ꗗ">
<thead>

<tr>
<th scope="col">$namelabel</th>
<th scope="col">ID</th>
<th scope="col">����</th>
<th scope="col">����</th>
<th scope="col">$winlabel</th>
<th scope="col">��E</th>
</tr>
</thead>

<tbody>
_HTML_

	my $giftname = $sow->{'textrs'}->{'GIFTNAME'};
	my $rolename = $sow->{'textrs'}->{'ROLENAME'};
	my $livename = $sow->{'textrs'}->{'STATUS_LIVE'};
	my $pllist   = $vil->getallpllist();
	foreach (@$pllist) {
		my $uidtext = '<a class="sow-id">'.$_->{'uid'}.'</a>';
		my $chrname = $_->getlongchrname();
		my $deathday = "";
		$deathday = $_->{'deathday'}."��" if (0 < $_->{'deathday'});
		my $livetext = $livename->{$_->{'live'}};
		my $wintext  = $_->winresult();
		$wintext = '�Q��' if (($cfg->{'ENABLED_WINNER_LABEL'} != 1 )&&('' ne $wintext));
		my $win_if = $textrs->{'ROLEWIN'}->{ $_->win_if() };
		my $selrolename = $textrs->{'RANDOMROLE'};
		$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
		my $roletext = $win_if."�F";
		$roletext .= $rolename->[$_->{'role'}];
		$roletext .= "�A".$giftname->[$_->{'gift'}] if ( $_->{'gift'} > $sow->{'GIFTID_NOT_HAVE'} );
		$roletext .= "�A���l" if ($_->{'love'} eq 'love');
		$roletext .= "�A�׋C" if ($_->{'love'} eq 'hate');
		$roletext .= "<i><br>�@�@".$selrolename."����]";
		$roletext = $selrolename."����]<i>" if ($_->{'role'} < 0);
		$roletext = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'}."�ɋ���<i>" if ($_->{'role'} == $sow->{'ROLEID_MOB'});

		my $appendex = "";
		$appendex .= "�@�@�\\�͂�r��<br>"  if ( $_->isDisableState('MASKSTATE_ABI_ROLE') );
		$appendex .= "�@�@���b��r��<br>"   if ( $_->isDisableState('MASKSTATE_ABI_GIFT') );
		$appendex .= "�@�@�P���ŕ���<br>"   if ( $_->isDisableState('MASKSTATE_HURT')     );
		$appendex .= "�@�@�P���Ɋ���<br>"   if ( $_->isDisableState('MASKSTATE_ZOMBIE')   );
		$appendex .= "�@�@�U��ꂽ<br>"   if ($_->{'sheep'} eq 'pixi');
		$appendex .= "�@�@���l������<br>" if ($_->{'love'}  eq 'love');
		$appendex .= "�@�@�׋C������<br>" if ($_->{'love'}  eq 'hate');
		if ($_->{'bonds'} ne '') {
			my @bonds = split('/', $_->{'bonds'} . '/');
			my $target;
			foreach $target (@bonds) {
				my $targetname = $vil->getplbypno($target)->getlongchrname();
				$appendex .= "�^�����J��$targetname<br$net>";
			}
		}
		my $history  = $_->{'history'};

		print <<"_HTML_";
<tr class="i_active">
<td>$chrname
<td>$uidtext
<td class="$_->{'live'} calc">$deathday
<td class="$_->{'live'}">$livetext
<th class="$_->{'live'}">$wintext
<td>$roletext
<br>$appendex</i>
</tr>

_HTML_
	}

	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

_HTML_
}

#----------------------------------------
# ���OHTML�̕\���i�P���O���j
#----------------------------------------
sub OutHTMLSingleLogPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;

	my $logmestype = substr($log->{'logid'}, 0, 1);

	# ID���J
	my $showid = '';
	$showid = $log->{'uid'} if  ($vil->{'showid'} > 0);
	$showid = $log->{'uid'} if  ($vil->{'epilogue'} <= $sow->{'turn'});
	$showid = ''            if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}));

	my $to   = "";
	my $name = $log->{'chrname'};

	my $style = "";
	$style = "mono" if (1 eq $log->{'monospace'});
	$style = "head" if (2 eq $log->{'monospace'});

	if ($log->{'mestype'} == $sow->{'MESTYPE_AIM'}) {
		($name, $to) = split(' �� ', $log->{'chrname'});

	}
	&SWHtml::ConvertJSONbyUser(\$log->{'log'});

	print <<"_HTML_";
var mes = {
	"subid":  "$log->{'logsubid'}",
	"logid":  "$log->{'logid'}",
	"csid":     "$log->{'csid'}",
	"face_id":  "$log->{'cid'}",
	"mesicon":  SOW_RECORD.CABALA.mestypeicons[$log->{'mestype'}],
	"mestype":  SOW_RECORD.CABALA.mestypes[$log->{'mestype'}],
	"style":    "$style",
	"name":  "$name",
	"to":    "$to",
	"log":   "$log->{'log'}",
	"date":  Date.create(1000 * $log->{'date'})
};
_HTML_
	if ($vil->{'showid'}) {
		print <<"_HTML_"
mes.sow_auth_id = "$showid";
_HTML_
	}
	if ($logmestype eq 'q') {
		print <<"_HTML_"
mes.is_delete = true;
_HTML_
	}
	print <<"_HTML_";
gon.event.messages.push(mes);
_HTML_
}

#----------------------------------------
# ����������HTML�\���i��s���j
#----------------------------------------
sub OutHTMLMemoSinglePC {
	my ($sow, $vil, $memofile, $memoidx, $anchor) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	my $log = $memofile->read($memoidx->{'pos'},$memoidx->{'logpermit'});
	my $append  = "<br>(�����o�܂���)";

	my $curpl = $vil->getplbyface($memoidx->{'csid'},$memoidx->{'cid'});
	if ((defined($curpl->{'entrieddt'})) && ($curpl->{'entrieddt'} < $memoidx->{'date'})){
		if( 0 == ($sow->{'turn'} ) ){
			$append = "";
		} elsif ($memo->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'}){
			$chrname = "" if ( 0 == $vil->isepilogue() );
			$append  = "�i�����j";
		} elsif ($memo->{'mestype'} == $sow->{'MESTYPE_INFOSP'}){
			$append = "";
		}
	}
	if ($log->{'log'} eq '') {
		$log->{'log'} = '�i�������͂������j' ;
	}

	# ID���J
	my $showid = '';
	$showid = $log->{'uid'} if  ($vil->{'showid'} > 0);
	$showid = $log->{'uid'} if  ($vil->{'epilogue'} <= $sow->{'turn'});
	$showid = ''            if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}));

	my $style = "";
	$style = "mono" if (1 eq $log->{'monospace'});
	$style = "head" if (2 eq $log->{'monospace'});

	my $name = $log->{'chrname'};
	&SWHtml::ConvertJSONbyUser(\$log->{'log'});

	print <<"_HTML_";
var mes = {
	"subid":  "M",
	"logid":  "MM$log->{'logid'}",
	"csid":     "$log->{'csid'}",
	"face_id":  "$log->{'cid'}",
	"mesicon":  SOW_RECORD.CABALA.mestypeicons[$log->{'mestype'}],
	"mestype":  SOW_RECORD.CABALA.mestypes[$log->{'mestype'}],
	"style":    "$style",
	"name":  "$name",
	"to":    "$to",
	"log":   "$log->{'log'}",
	"date":  Date.create(1000 * $log->{'date'})
};
_HTML_
	if ($vil->{'showid'}) {
		print <<"_HTML_"
mes.sow_auth_id = "$showid";
_HTML_
	}
	print <<"_HTML_";
gon.event.messages.push(mes);
_HTML_
}

#----------------------------------------
# �w�肵�����O�̔����҃f�[�^�̎擾
#----------------------------------------
sub GetLogPL {
	my ($sow, $vil, $log) = @_;
	my $logpl;
	my $pl = $vil->getpl($log->{'uid'});

	if ((!defined($pl->{'cid'})) || ($pl->{'entrieddt'} > $log->{'date'})) {
		# ���𔲂��Ă���v���C���[
		my %logplsingle = (
			cid       => $log->{'cid'},
			csid      => $log->{'csid'},
			pno       => -1,
			deathday  => -1,
			entrieddt => -1,
		);
		$logpl = \%logplsingle;
	} else {
		# ���ɂ���v���C���[
		my $plface = $vil->getplbyface($log->{'csid'},$log->{'cid'});
		my %logplsingle = (
			cid       => $log->{'cid'},
			csid      => $log->{'csid'},
			pno       => $plface->{'pno'},
			deathday  => $plface->{'deathday'},
			entrieddt => $plface->{'entrieddt'},
		);
		$logpl = \%logplsingle;
	}

	return $logpl;
}

1;
