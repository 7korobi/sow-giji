package SWHtmlPreviewMb;

#----------------------------------------
# 発言プレビュー（モバイル）HTMLの表示
#----------------------------------------
sub OutHTMLPreviewMb {
	my ($sow, $vil, $log, $preview) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html_vlog_mb.pl";

	# 更新時間の取得
	my $date = sprintf("%02d:%02d", $vil->{'updhour'}, $vil->{'updminite'});

	# はみ出す文字の処理
	my $srcmes = $log->{'log'}; # 削除前の発言
	$srcmes =~ s/(<br( \/)?>)*$//ig;

	my $trimedlog = &SWString::GetTrimString($sow, $vil, $srcmes);
	my $len = length($trimedlog);
	$log->{'log'} = substr($srcmes, 0, $len);
	my $deletedmes = substr($srcmes, $len);
	$log->{'log'} .= "<font color=\"gray\">$deletedmes</font>";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('プレビュー'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	print <<"_HTML_";
$query->{'vid'} $vil->{'vname'}<br$net>
<hr$net>
発言のプレビュー<br$net>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

	# 誤爆注意
	my $curpl = &SWBase::GetCurrentPl($sow, $vil);
	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);
	if ((&SWBase::CheckWriteSafetyRole($sow, $vil) > 0) && ($que > 0) && ($vil->isepilogue() == 0)) {
		print <<"_HTML_";
この発言は通常発言です。発言ミスに注意！<br$net>
<input type="checkbox" name="safety" value="on"$net>通常発言で間違いなければチェック<br$net>
_HTML_
	}

	# 発言部分の表示
	my %logids = (
		rowover => 1,
	);
	&SWHtmlVlogMb::OutHTMLSingleLogMb($sow, $vil, $log, \%logids, -1, 0);

	# 属性値生成
#	$query->{'mes'} =~ s/<br( \/)?>/&#13\;/ig;
	$query->{'mes'} =~ s/<br( \/)?>/\[\[br\]\]/ig;
	my @reqkeys = (
		'csid_cid', 
		'role', 
		'mes', 
		'think', 
		'wolf', 
		'maker', 
		'muppet', 
		'admin', 
		'sympathy', 
		'pixi', 
		'monospace', 
		'expression', 
		'target'
	);

	# パスワードつき村では、村入りパスワードを中継する。
	push(@reqkeys, 'entrypwd') if ($vil->{'entrylimit'} eq 'password');

	my $reqvals = &SWBase::GetRequestValues($sow, \@reqkeys);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	# 行数の取得
	my @lineslog = split('<br>', $srcmes);
	my $lineslogcount = @lineslog;

	# 文字数の取得
	my $countsrc = &SWString::GetCountStr($sow, $vil, $srcmes);
	my $countmes = &SWString::GetCountStr($sow, $vil, $trimedlog);

	# 行数／文字数制限警告
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	if ($lineslogcount > $saycnt->{'MAX_MESLINE'}) {
		print "行数が多すぎます（$lineslogcount行）。$saycnt->{'MAX_MESLINE'}行以内に収めないと正しく書き込まれません。<hr$net>\n";
	} elsif ($countsrc > $saycnt->{'MAX_MESCNT'}) {
		my $unitcaution = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COST_SAY'}}->{'UNIT_CAUTION'};
		print "文字が多すぎます（$countsrc$unitcaution）。$countmes$unitcaution以内に収めないと正しく書き込まれません。<hr$net>\n";
	}

	# 発言によって消費されるpt数の表示
#	my $point = &SWBase::GetSayPoint($sow, $vil, $log->{'log'});
	my $point = &SWBase::GetSayPoint($sow, $vil, $trimedlog);
	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);
	my $unitsay = $sow->{'basictrs'}->{'SAYTEXT'}->{$cost}->{'UNIT_SAY'};
	my $pointtext = '';
	if (($cost eq 'point') && ($sow->{'query'}->{'cmd'} ne 'entrypr') && (defined($sow->{'curpl'}->{$saytype}))) {
		$pointtext = "（$point$unitsay消費 / 現在$sow->{'curpl'}->{$saytype}$unitsay）";
	}

	# 発言ボタンの表示
	print <<"_HTML_";
これを書き込みますか？$pointtext<br$net>
<input type="hidden" name="cmd" value="$preview->{'cmd'}"$net>
<input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
<input type="submit" value="書き込む"$net>
</form>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM_MB'}">
<input type="hidden" name="cmd" value="$preview->{'cmdfrom'}"$net>
<input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
<input type="submit" value="戻る"$net>
</form>
_HTML_

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
