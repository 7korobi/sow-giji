package SWHtmlVlogMb;

#----------------------------------------
# 村ログ表示（携帯モード）のHTML出力
#----------------------------------------
sub OutHTMLVlogMb {
	my ($sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows) = @_;

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg = $sow->{'cfg'};

	# 二重書き込み注意
	if ($sow->{'query'}->{'cmd'} ne '') {
		print <<"_HTML_";
<font color="red">★二重書き込み注意★</font><br$net>
リロードする場合は「新」を使って下さい。
<hr$net>
_HTML_
	}

	# 村名及びリンク表示
	# 見出し（村名とRSS）
	my $titleupdate = &SWHtmlMb::GetTitleNextUpdate($sow, $vil);
	my $reqvals     = &SWBase::GetRequestValues($sow);
	my $linkvalues  = &SWBase::GetLinkValues($sow, $reqvals);
	my $linkrss = " <a href=\"?$linkvalues$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);
	print "<a $atr_id=\"top\">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>\n";
	print "$titleupdate $linkrss<br>" if ($vil->{'epilogue'} >= $vil->{'turn'});

	# キャラ名表示
	if (defined($sow->{'curpl'}->{'uid'})) {
		my $chrname = $sow->{'curpl'}->getlongchrname();
		my $rolename = $sow->{'curpl'}->getrolename();

		my $curpl = $sow->{'curpl'};
		my $markbonds = '';
		$markbonds = " ★$sow->{'textrs'}->{'MARK_BONDS'}" if ($curpl->isvisiblebonds($vil));
		print "$chrname$rolename$markbonds<br$net>\n";
	}

	my $list = $logfile->getlist();
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0, $logs, $list, $rows);

	if (defined($sow->{'curpl'}->{'uid'})) {
		if (($vil->{'turn'} == 0) && ($sow->{'curpl'}->{'limitentrydt'} > 0)) {
			my $limitdate = $sow->{'dt'}->cvtdt($sow->{'curpl'}->{'limitentrydt'});
			print <<"_HTML_";
<font color="red">$limitdateまでに一度も発言せず村も開始されなかった場合、あなたは自動的に村から追い出されます。</font>
<hr$net>
_HTML_
		}
	}

	if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'})) {
		# 終了表示
		print "<p>終了しました。</p>\n\n";

	} else {
		# 村ログ表示
		my $order = $sow->{'query'}->{'order'};
		my %anchor = (
			logfile => $logfile,
			logkeys => $logkeys,
			rowover => $rows->{'rowover'},
		);

		if (($order eq 'desc') || ($order eq 'd')){
			# 降順
			my $i;
			for ($i = $#$logs; $i >= 0; $i--) {
				next if (!defined($logs->[$i]->{'pos'}));
				my $log = $logfile->read($logs->[$i]->{'pos'},$logs->[$i]->{'logpermit'});
				&OutHTMLSingleLogMb($sow, $vil, $log, \%anchor);
			}
		} else {
			# 昇順
			foreach (@$logs) {
				next if (!defined($_->{'pos'}));
				my $log = $logfile->read($_->{'pos'},$_->{'logpermit'});
				&OutHTMLSingleLogMb($sow, $vil, $log, \%anchor);
			}
		}

		if ($sow->{'turn'} == $vil->{'turn'}) {
			# 最新日表示時

			# 未参加／未ログイン時アナウンス
			if (($vil->{'turn'} == 0) && ($sow->{'user'}->logined() <= 0)){
				print <<"_HTML_";
<p>
演じたいキャラクターを選び、発言してください。<br$net>
</p>

<p>
ルールをよく理解した上でご参加下さい。<br$net>
※希望能\力についての発言は控えてください。
</p>

_HTML_
			}

			my $nosaytext = &SWHtmlVlog::GetNoSayListText($sow, $vil, $pl, $plid);
			if (($vil->isepilogue() == 0) && ($nosaytext ne '')) {
				# 未発言者リストの表示
				print "<p>$nosaytext</p>\n<hr$net>\n\n";
			}
		}
	}

	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1, $logs, $list, $rows);

	return;
}

#----------------------------------------
# ログHTMLの表示（１ログ分）
#----------------------------------------
sub OutHTMLSingleLogMb {
	my ($sow, $vil, $log, $logkeys) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $textrs = $sow->{'textrs'};

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

	if ($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'}) {
		# インフォメーション
		print <<"_HTML_";
<font color="maroon">$log->{'log'}</font>
<hr$net>
_HTML_
	} elsif ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) {
		# 注意表示
		print <<"_HTML_";
<font color="gray">$log->{'log'}</font>
<hr$net>
_HTML_
	} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_UNDEF'}) {
		my $date = $sow->{'dt'}->cvtdtmb($log->{'date'})."<br$net>";
		if (($log->{'logsubid'} eq $sow->{'LOGSUBID_ACTION'})) {
			# アクション
			# 発言中のアンカーを整形
			my $mes = &SWLog::ReplaceAnchorHTMLMb($sow, $vil, $log->{'log'}, $logkeys);
			&SWHtml::ConvertNET($sow, \$mes);
			my $actcolorbegin = '';
			my $actcolorend   = '';
			if ($log->{'mestype'} eq $sow->{'MESTYPE_TSAY'}) {
				$actcolorbegin = '<font color="maroon">';
				$actcolorend   = '</font>';
				$date          = '';
			}

			print <<"_HTML_";
$actcolorbegin$logmestypetexts[$log->{'mestype'}]$log->{'chrname'}は、$mes$actcolorend
$date
_HTML_
		} elsif ($log->{'mestype'} == $sow->{'MESTYPE_CAST'}) {
			# 配役一覧
			my $giftname = $sow->{'textrs'}->{'GIFTNAME'};
			my $rolename = $sow->{'textrs'}->{'ROLENAME'};
			my $livename = $sow->{'textrs'}->{'STATUS_LIVE'};
			my $pllist = $vil->getallpllist();
			foreach (@$pllist) {
				my $chrname = $_->getlongchrname();
				my $wintext  = $_->winresult();
				$wintext = '参加' if (($cfg->{'ENABLED_WINNER_LABEL'} != 1 )&&('' ne $wintext));
				my $livetext = "$livename->{$_->{'live'}}";
				$livetext = $_->{'deathday'}."d".$livename->{$_->{'live'}} unless (('mob' eq $_->{'live'})||('live' eq $_->{'live'}));
				my $selrolename = $textrs->{'RANDOMROLE'};
				$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
				my $gifttext = "";
				$gifttext = "、".($giftname->[$_->{'gift'}]) if ( $_->{'gift'} > $sow->{'GIFTID_NOT_HAVE'} );
				$gifttext .= "、恋人" if ($_->{'love'} eq 'love');
				$gifttext .= "、邪気" if ($_->{'love'} eq 'hate');
				my $roletext = "$rolename->[$_->{'role'}]$gifttextだった($selrolenameを希望)。";
				$roletext = "$sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'}に居た" if ($_->{'role'} == $sow->{'ROLEID_MOB'});
				$roletext = "$selrolenameを希望していた。" if ($_->{'role'} < 0);
				my $appendex = "";
				$appendex .= " ☆恩恵喪失"   if ( $_->isDisableState('MASKSTATE_ABI_GIFT') );
				$appendex .= " ☆能\力喪失"  if ( $_->isDisableState('MASKSTATE_ABI_ROLE') );
				$appendex .= " ☆負傷" if ( $_->isDisableState('MASKSTATE_HURT')     );
				$appendex .= " ☆勧誘" if ($_->{'sheep'} eq 'pixi');
				$appendex .= " ★$sow->{'textrs'}->{'MARK_BONDS'}" if ($_->{'bonds'} ne '');
				$appendex .= " ★感染" if ( $_->isDisableState('MASKSTATE_ZOMBIE')   );
				$appendex .= " ★邪気" if ($_->{'love'}  eq 'hate');
				$appendex .= " ★恋人" if ($_->{'love'}  eq 'love');
				print <<"_HTML_";
<font color="maroon">$chrname ($_->{'uid'})、$wintext、$livetext。$roletext $appendex</font><br$net>
_HTML_
			}
		} else {
			# 発言色
			my @logcolor = (
				'',               # MESTYPE_UNDEF
				'',               # MESTYPE_INFOSP
				'gray',           # MESTYPE_DELETEDADMIN
				'',               # MESTYPE_CAST
				'',               # MESTYPE_MAKER
				'',               # MESTYPE_ADMIN
				'',               # MESTYPE_QUEUE
				'',               # MESTYPE_INFONOM
				'gray',           # MESTYPE_DELETED
				'',               # MESTYPE_SAY
				'gray',           # MESTYPE_TSAY
				'red',            # MESTYPE_WSAY
				'teal',           # MESTYPE_GSAY
				'blue',           # MESTYPE_SPSAY
				'green',          # MESTYPE_XSAY
				'maroon',         # MESTYPE_VSAY
				'',               # MESTYPE_MSAY
				'purple',         # MESTYPE_AIM
			);
			my $logmestypetext = $logmestypetexts[$log->{'mestype'}];

			my $messtyle = $logcolor[$log->{'mestype'}];
			if($log->{'mestype'} == $sow->{'MESTYPE_VSAY'}){
				$messtyle = '';
				$messtyle = 'blue' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'grave'));
				$messtyle = 'gray' if((0 < $sow->{'turn'})&&($sow->{'turn'} < $vil->{'epilogue'})&&($vil->{'mob'} eq 'think'));
			}

			# 発言中のアンカーを整形
			my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);
			my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);
			my $mes = &SWLog::ReplaceAnchorHTMLMb($sow, $vil, $log->{'log'}, $logkeys);
			&SWHtml::ConvertNET($sow, \$mes);

			my $colorstart = '';
			my $colorend = '';
			if ($messtyle ne '') {
				$colorstart = "<font color=\"$messtyle\">\n";
				$colorend = "\n</font>";
			}

			my $showid = '';
			$showid = " ($log->{'uid'})" if ($vil->{'showid'} > 0);

			print <<"_HTML_";
$colorstart$logmestypetext<a $atr_id="$log->{'logid'}">$log->{'chrname'}</a>$showid $date$loganchor<br$net>
$mes<br$net>$colorend
_HTML_

			if ($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_QUEUE'}]) {
				# 発言撤回ボタンの表示
				$sow->{'query'}->{'cmd'} = 'cancel';
				my $reqvals = &SWBase::GetRequestValues($sow);
				my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

				print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<input type="hidden" name="cmd" value="cancel">
<input type="hidden" name="queid" value="$log->{'logid'}">$hidden
<input type="submit" value="削除($sow->{'cfg'}->{'MESFIXTIME'}秒以内)">
</form>
_HTML_
			}
		}
		print "<hr$net>\n";
	}
}

1;
