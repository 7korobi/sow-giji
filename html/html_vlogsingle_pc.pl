package SWHtmlVlogSinglePC;

#----------------------------------------
# ログHTMLの表示（エピローグの配役一覧）
#----------------------------------------
sub OutHTMLSingleLogCastPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg   = $sow->{'cfg'};
	my $textrs = $sow->{'textrs'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);

	my $winlabel  = '勝敗';
	my $namelabel = '名前';
	$namelabel = "<a $atr_id=\"newsay\">$namelabel</a>" if ($newsay > 0);
	$winlabel  = '参加' if ($cfg->{'ENABLED_WINNER_LABEL'} != 1 );

	print <<"_HTML_";
<table border="1" class="table vindex" summary="配役一覧">
<thead>

<tr>
<th scope="col">$namelabel</th>
<th scope="col">ID</th>
<th scope="col">日程</th>
<th scope="col">生死</th>
<th scope="col">$winlabel</th>
<th scope="col">役職</th>
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
		$deathday = $_->{'deathday'}."日" if (0 < $_->{'deathday'});
		my $livetext = $livename->{$_->{'live'}};
		my $wintext  = $_->winresult();
		$wintext = '参加' if (($cfg->{'ENABLED_WINNER_LABEL'} != 1 )&&('' ne $wintext));
		my $win_if = $textrs->{'ROLEWIN'}->{ $_->win_if() };
		my $selrolename = $textrs->{'RANDOMROLE'};
		$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
		my $roletext = $win_if."：";
		$roletext .= $rolename->[$_->{'role'}];
		$roletext .= "、".$giftname->[$_->{'gift'}] if ( $_->{'gift'} > $sow->{'GIFTID_NOT_HAVE'} );
		$roletext .= "、恋人" if ($_->{'love'} eq 'love');
		$roletext .= "、邪気" if ($_->{'love'} eq 'hate');
		$roletext .= "<i><br>　　".$selrolename."を希望";
		$roletext = $selrolename."を希望<i>" if ($_->{'role'} < 0);
		$roletext = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'}."に居た<i>" if ($_->{'role'} == $sow->{'ROLEID_MOB'});

		my $appendex = "";
		$appendex .= "　　能\力を喪失<br>"  if ( $_->isDisableState('MASKSTATE_ABI_ROLE') );
		$appendex .= "　　恩恵を喪失<br>"   if ( $_->isDisableState('MASKSTATE_ABI_GIFT') );
		$appendex .= "　　襲撃で負傷<br>"   if ( $_->isDisableState('MASKSTATE_HURT')     );
		$appendex .= "　　襲撃に感染<br>"   if ( $_->isDisableState('MASKSTATE_ZOMBIE')   );
		$appendex .= "　　誘われた<br>"   if ($_->{'sheep'} eq 'pixi');
		$appendex .= "　　恋人だった<br>" if ($_->{'love'}  eq 'love');
		$appendex .= "　　邪気だった<br>" if ($_->{'love'}  eq 'hate');
		if ($_->{'bonds'} ne '') {
			my @bonds = split('/', $_->{'bonds'} . '/');
			my $target;
			foreach $target (@bonds) {
				my $targetname = $vil->getplbypno($target)->getlongchrname();
				$appendex .= "運命の絆★$targetname<br$net>";
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
# ログHTMLの表示（１ログ分）
#----------------------------------------
sub OutHTMLSingleLogPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;
	my $cfg = $sow->{'cfg'};

	my $logmestype = substr($log->{'logid'}, 0, 1);

	my $to   = "";
	my $name = $log->{'chrname'};

	my $secret = $vil->isepilogue();
	$secret = 1 if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});
	my $is_showid = $vil->{'showid'} || $secret;

	# ID公開
	my $showid = '';
	$showid = $log->{'uid'} if  ($is_showid);
	$showid = $log->{'uid'} if  ($vil->{'epilogue'} <= $sow->{'turn'});
	$showid = ''            if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}));

	my $style = "";
	$style = "mono" if (1 eq $log->{'monospace'});
	$style = "head" if (2 eq $log->{'monospace'});

	if ($log->{'mestype'} == $sow->{'MESTYPE_AIM'}) {
		($name, $to) = split(' → ', $log->{'chrname'});

	}
	&SWHtml::ConvertJSONbyUser(\$log->{'log'});

  my $vid = $vil->{'vid'};
  my $turn = $sow->{'turn'};
	my $logid = $log->{'logid'};

	print <<"_HTML_";
var mes_log = "$log->{'log'}";
var mes = {
	"_id": "SOW-$vid-$turn-$logid",
	"subid": "$log->{'logsubid'}",
	"logid": "$logid",
	"csid": "$log->{'csid'}",
	"face_id": "$log->{'cid'}",
	"style": "$style",
	"name": "$name",
	"to": "$to",
	"mesicon": giji.log.mesicon($log->{'mestype'}),
	"mestype": giji.log.mestype($log->{'mestype'}),
	"date": 1000 * $log->{'date'},
	"log": mes_log
};
_HTML_
	if ($is_showid) {
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
# メモ発言欄HTML表示（一行分）
#----------------------------------------
sub OutHTMLMemoSinglePC {
	my ($sow, $vil, $memofile, $memoidx, $anchor) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	my $log = $memofile->read($memoidx->{'pos'},$memoidx->{'logpermit'});
	my $append  = "<br>(村を出ました)";

	my $curpl = $vil->getplbyface($memoidx->{'csid'},$memoidx->{'cid'});
	if ((defined($curpl->{'entrieddt'})) && ($curpl->{'entrieddt'} < $memoidx->{'date'})){
		if( 0 == ($sow->{'turn'} ) ){
			$append = "";
		} elsif ($memo->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'}){
			$chrname = "" if ( 0 == $vil->isepilogue() );
			$append  = "（匿名）";
		} elsif ($memo->{'mestype'} == $sow->{'MESTYPE_INFOSP'}){
			$append = "";
		}
	}

	my $secret = $vil->isepilogue();
	$secret = 1 if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});
	my $is_showid = $vil->{'showid'} || $secret;

	# ID公開
	my $showid = '';
	$showid = $log->{'uid'} if  ($vil->{'showid'} > 0);
	$showid = $log->{'uid'} if  ($vil->{'epilogue'} <= $sow->{'turn'});
	$showid = ''            if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}));

	my $style = "";
	$style = "mono" if (1 eq $log->{'monospace'});
	$style = "head" if (2 eq $log->{'monospace'});

	my $name = $log->{'chrname'};
	&SWHtml::ConvertJSONbyUser(\$log->{'log'});

  my $vid = $vil->{'vid'};
  my $turn = $sow->{'turn'};
	my $logid = "MM".$log->{'logid'};

	print <<"_HTML_";
var mes_log = "$log->{'log'}";
var mes = {
	"_id": "SOW-$vid-$turn-$logid",
	"subid": "M",
	"logid": "$logid",
	"csid": "$log->{'csid'}",
	"face_id": "$log->{'cid'}",
	"style": "$style",
	"name": "$name",
	"to": "$to",
	"mesicon": giji.log.mesicon($log->{'mestype'}),
	"mestype": giji.log.mestype($log->{'mestype'}),
	"date": 1000 * $log->{'date'},
	"log": mes_log
};
_HTML_
	if ($is_showid) {
		print <<"_HTML_"
mes.sow_auth_id = "$showid";
_HTML_
	}
	print <<"_HTML_";
gon.event.messages.push(mes);
_HTML_
}

#----------------------------------------
# 指定したログの発言者データの取得
#----------------------------------------
sub GetLogPL {
	my ($sow, $vil, $log) = @_;
	my $logpl;
	my $pl = $vil->getpl($log->{'uid'});

	if ((!defined($pl->{'cid'})) || ($pl->{'entrieddt'} > $log->{'date'})) {
		# 村を抜けているプレイヤー
		my %logplsingle = (
			cid       => $log->{'cid'},
			csid      => $log->{'csid'},
			pno       => -1,
			deathday  => -1,
			entrieddt => -1,
		);
		$logpl = \%logplsingle;
	} else {
		# 村にいるプレイヤー
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
