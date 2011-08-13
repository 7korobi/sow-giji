package SWHtmlDialog;

#----------------------------------------
# 確認画面のHTML出力
#----------------------------------------
sub OutHTMLDialog {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

	# 村データの読み込み
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	my %dialog = (
		cmd => 'none',
	);
	if ($query->{'cmd'} eq 'exitpr') {
		%dialog = (
			cmd => 'exit',
			text => '村から出ますか？',
			buttoncaption => '村から出る',
		);
	} elsif ($query->{'cmd'} eq 'kickpr') {
		$target     = $vil->getplbypno($query->{'target'});
		$targetname = $target->getchrname();
		%dialog = (
			cmd => 'kick',
			text => $targetname.' に、退去いただきますか？',
			buttoncaption => '村から退去いただく',
		);
	} elsif ($query->{'cmd'} eq 'makerpr') {
		$target     = $vil->getplbypno($query->{'target'});
		$targetname = $target->getchrname();
		%dialog = (
			cmd => 'maker',
			text => $targetname.' に、村建て権限を譲りますか？あなたは村建ての権限をすべて失います。',
			buttoncaption => '村建て権を譲る',
		);
	} elsif ($query->{'cmd'} eq 'musterpr') {
		my $upddatetime = sprintf('%02d:%02d',$vil->{'updhour'},$vil->{'updminite'});
		%dialog = (
			cmd => 'muster',
			text => '点呼を開始しますか？点呼を開始すると、いちど全員の発言した回数をゼロにします。<br>発言がゼロのまま、更新時刻('.$upddatetime.')を迎えた参加者は、村から退去します。',
			buttoncaption => '村人を点呼する',
		);
	} elsif ($query->{'cmd'} eq 'startpr') {
		%dialog = (
			cmd => 'start',
			text => '村を開始しますか？',
			buttoncaption => '開始',
		);
	} elsif ($query->{'cmd'} eq 'updatepr') {
		%dialog = (
			cmd => 'update',
			text => '村を更新しますか？',
			buttoncaption => '更新',
		);
	} elsif ($query->{'cmd'} eq 'extendpr') {
		%dialog = (
			cmd => 'extend',
			text => '村の更新日時を、一日延長しますか？（あと'.$vil->{'extend'}.'回）',
			buttoncaption => '延長',
		);
	} elsif ($query->{'cmd'} eq 'scrapvilpr') {
		%dialog = (
			cmd => 'scrapvil',
			text => '廃村しますか？',
			buttoncaption => '廃村',
		);
	}

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "未定義の行動です。","invalid cmd.") if ($dialog{'cmd'} eq 'none');

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader('村の情報'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();
	my $net = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow) if ($sow->{'outmode'} ne 'mb');

	# 日付別ログへのリンク
	if ($sow->{'outmode'} eq 'mb') {
		print "$sow->{'query'}->{'vid'} $vil->{'vname'}<br$net>\n";
		&SWHtmlMb::OutHTMLReturnVilMb($sow, $vil, 0);
		print "<hr$net>\n";
	} else {
		&SWHtmlPC::OutHTMLTurnNavi($sow, $vil);
	}

	my @reqkeys = ('csid_cid', 'role', 'mes', 'think', 'wolf', 'maker', 'admin', 'target');
	my $reqvals = &SWBase::GetRequestValues($sow, \@reqkeys);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	if ($sow->{'outmode'} eq 'mb') {
		print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
<p>$dialog{'text'}<br$net></p>

<p>
<input type="hidden" name="cmd" value="$dialog{'cmd'}"$net>$hidden
<input type="submit" value="$dialog{'buttoncaption'}"$net>
</p>
</form>
_HTML_
	} else {
		print <<"_HTML_";
<h2>行動確認</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$dialog{'text'}</p>

<p class="paragraph">
  <input type="hidden" name="cmd" value="$dialog{'cmd'}"$net>$hidden
  <input type="submit" value="$dialog{'buttoncaption'}"$net>
</p>
</form>
_HTML_
	}

	if ($sow->{'outmode'} eq 'mb') {
		print "<hr$net>\n";
		&SWHtmlMb::OutHTMLReturnVilMb($sow, $vil, 1);
	} else {
		&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る
	}

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;