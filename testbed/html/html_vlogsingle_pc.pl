package SWHtmlVlogSinglePC;

#----------------------------------------
# ログHTMLの表示（キャラの発言）
#----------------------------------------
sub OutHTMLSingleLogSayPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	# 日時とキャラクター名
	my $logpl = &GetLogPL($sow, $vil, $log);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	$sow->{'charsets'}->loadchrrs($logpl->{'csid'});
	my $charset = $sow->{'charsets'}->{'csid'}->{$logpl->{'csid'}};
	my $chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);

	# クラス名
	my $messtyle = &SWHtmlPC::OutHTMLMesStyle($sow,$vil,$log);

	# キャラ画像アドレスの取得
	my $img = &SWHtmlPC::GetImgUrl($sow, $logpl, $charset->{'FACE'}, $log->{'expression'});

	# キャラ画像部とその他部の横幅を取得
	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');

	# ログ番号
	my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);
	my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);

	# 発言種別
	my @logmestypetexts = (
		'',               # MESTYPE_UNDEF
		'',               # MESTYPE_INFOSP
		'【管理人削除】', # MESTYPE_DELETEDADMIN
		'',               # MESTYPE_CAST
		'',               # MESTYPE_MAKER
		'',               # MESTYPE_ADMIN
		'【未確】',       # MESTYPE_QUEUE
		'',               # MESTYPE_INFONOM
		'【削除】',       # MESTYPE_DELETED
		'【人】',         # MESTYPE_SAY
		'【独】',         # MESTYPE_TSAY
		'【赤】',         # MESTYPE_WSAY
		'【墓】',         # MESTYPE_GSAY
		'【鳴】',         # MESTYPE_SPSAY
		'【念】',         # MESTYPE_XSAY
		'【見】',         # MESTYPE_VSAY
		'【憑】',         # MESTYPE_MSAY
		'【秘】',         # MESTYPE_AIM
	);
	my $logmestypetext = '';
	$logmestypetext  = "$logmestypetexts[$log->{'mestype'}]" if ($logmestypetexts[$log->{'mestype'}] ne '');

	# 発言中のアンカー等を整形
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	# 等幅処理
	my $mes_text = 'mes_text';
	$mes_text = 'mes_text_monospace' if ((defined($log->{'monospace'})) && ($log->{'monospace'} == 1));
	$mes_text = 'mes_text_report'    if ((defined($log->{'monospace'})) && ($log->{'monospace'} == 2));

	# ID公開
	my $showid = '';
	$showid = " $log->{'uid'} " if (($vil->{'showid'} > 0)||($vil->{'epilogue'} <= $sow->{'turn'})||($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}));

	# ログのHTML出力
	&OutHTMLFilterDivHeader($sow, $vil, $log, $no, $logpl, $modesingle);
	# 顔画像の表示
	print <<"_HTML_";
<table class="$messtyle">
<tbody>
<tr class="say">
<td class="img"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt=""$net>
<td class="field"><DIV class="msg">
_HTML_

	# 名前表示（上配置）
	print "  <h3 class=\"mesname\">$logmestypetext <a $atr_id=\"$log->{'logid'}\">$chrname</a></h3>\n\n" if ($charset->{'LAYOUT_NAME'} eq 'top');

	# 名前表示（右配置）
	print "    <h3 class=\"mesname\">$logmestypetext <a $atr_id=\"$log->{'logid'}\">$chrname</a></h3>\n" if ($charset->{'LAYOUT_NAME'} ne 'top');

	# 発言の表示
	print "<p class=\"$mes_text\">$log->{'log'}</p>\n";

	# 発言の削除ボタン
	if ($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_QUEUE'}]) {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

		print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
<span class="saycancelframe">
<input type="hidden" name="cmd" value="cancel"$net>
<input type="hidden" name="queid" value="$log->{'logid'}"$net>$hidden
<input type="submit" value="この発言を削除($sow->{'cfg'}->{'MESFIXTIME'}秒以内)" class="saycancelbutton"$net>
</span>
</form>
<p class="mes_date">$date</p>
_HTML_
	} else {
		print "<p class=\"mes_date\" turn=\"$sow->{'turn'}\">$loganchor$showid $date</p>\n";
	}

	# 回り込みの解除
	print <<"_HTML_";
</DIV></td>
</tr></table>
</div></div>
_HTML_

}



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
<table border="1" class="vindex" summary="配役一覧">
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
		my %link = (
			'user' => $_    ->{'uid'},
			'css'  => $query->{'css'},
		);
		my $urluser = $cfg->{'URL_USER'}.'?'.&SWBase::GetLinkValues($sow, \%link);
		my $uidtext = '<a href="'.$urluser.'">'.$_->{'uid'}.'</a>';
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

	# ID公開
	my $showid = '';
	$showid = $log->{'uid'} if  ($vil->{'showid'} > 0);
	$showid = $log->{'uid'} if  ($vil->{'epilogue'} <= $sow->{'turn'});
	$showid = ''            if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}));

	my $to   = "";
	my $name = $log->{'chrname'};
	if ($log->{'mestype'} == $sow->{'MESTYPE_AIM'}) {
		($name, $to) = split(' → ', $log->{'chrname'});

	}

	print <<"_HTML_";
var mes = {
	"subid":  "$log->{'logsubid'}",
	"logid":  "$log->{'logid'}",
	"csid":     "$log->{'csid'}",
	"face_id":  "$log->{'cid'}",
	"mesicon":  SOW_RECORD.CABALA.mestypeicons[$log->{'mestype'}],
	"mestype":  SOW_RECORD.CABALA.mestypes[$log->{'mestype'}],
	"style":    SOW_RECORD.CABALA.monospace[$log->{'monospace'}],
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
# フィルタ用div開始タグの出力
#----------------------------------------
sub OutHTMLFilterDivHeader {
	my ($sow, $vil, $log, $no, $logpl, $modesingle) = @_;
	my $filter = $sow->{'filter'};

	my $logpno = '-1';
	# 個人フィルタ処理
	if (($logpl->{'pno'} >= 0) && ($logpl->{'entrieddt'} <= $log->{'date'})) {
		# 村を抜けていない人はフィルタの対象
		$logpno = $logpl->{'pno'};
	}

	# 発言種別フィルタ処理
	my $mestype = $sow->{'MESTYPE2TYPEID'}->[$log->{'mestype'}];

	# プレビューの時はフィルタを無効
	$modesingle = 1 if (($sow->{'query'}->{'cmd'} eq 'entrypr') || ($sow->{'query'}->{'cmd'} eq 'writepr'));

	if ($modesingle == 0) {
		my $filterid = $no."_".$logpno."_".$mestype;
		my $filterstyle = '';
		$filterstyle = $pnofilterstyle  if('' ne $pnofilterstyle );
		$filterstyle = $typefilterstyle if('' ne $typefilterstyle);
		print "<div>";
		print "<div class=\"message_filter\" id=\"$filterid\"$filterstyle>";
	} else {
		print "<div><div class=\"message_filter\">\n";
	}
	return;
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
