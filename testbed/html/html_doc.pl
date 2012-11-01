package SWHtmlDocument;

#----------------------------------------
# ドキュメント画面のHTML出力
#----------------------------------------
sub OutHTMLDocument {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};

	require "$cfg->{'DIR_HTML'}/html.pl";
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	my $cmd = $sow->{'query'}->{'cmd'};
	my $doc;

	if ($cmd eq 'howto') {
		require "$cfg->{'DIR_RS'}/doc_howto.pl";
		$doc = SWDocHowTo->new($sow);
	} elsif ($cmd eq 'rule') {
		require "$cfg->{'DIR_RS'}/doc_rule.pl";
		$doc = SWDocRule->new($sow);
	} elsif ($cmd eq 'about') {
		require "$cfg->{'DIR_RS'}/doc_about.pl";
		$doc = SWDocAbout->new($sow);
	} elsif ($cmd eq 'operate') {
		require "$cfg->{'DIR_RS'}/doc_operate.pl";
		$doc = SWDocOperate->new($sow);
	} elsif ($cmd eq 'spec') {
		require "$cfg->{'DIR_RS'}/doc_spec.pl";
		$doc = SWDocSpec->new($sow);
	} elsif ($cmd eq 'rolematrix') {
		require "$cfg->{'DIR_RS'}/doc_rolematrix.pl";
		$doc = SWDocRoleMatrix->new($sow);
	} elsif ($cmd eq 'rolelist') {
		require "$cfg->{'DIR_RS'}/doc_rolelist.pl";
		$doc = SWDocRoleList->new($sow);
	} elsif ($cmd eq 'roleaspect') {
		require "$cfg->{'DIR_RS'}/doc_roleaspect.pl";
		$doc = SWDocRoleAspect->new($sow);
	} elsif ($cmd eq 'trsdiff') {
		require "$cfg->{'DIR_RS'}/doc_trsdiff.pl";
		$doc = SWDocTrsDiff->new($sow);
	} elsif ($cmd eq 'trslist') {
		require "$cfg->{'DIR_RS'}/doc_trslist.pl";
		$doc = SWDocTrsList->new($sow);
	} else {
		require "$cfg->{'DIR_RS'}/doc_changelog.pl";
		$doc = SWDocChangeLog->new($sow);
	}

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag

	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader($doc->{'title'}); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	$sow->{'query'}->{'trsid'} = $sow->{'cfg'}->{'DEFAULT_TEXTRS'} if ( "" eq $sow->{'query'}->{'trsid'});
	print <<"_HTML_";
<div class="choice">
<p style="text-align:right; font-size: 100%;" theme="giji">
<p class="paragraph">
<form action="$urlsow" method="get" class="form-inline">
<input type="hidden" name="cmd" value="$sow->{'query'}->{'cmd'}">
<input type="hidden" name="css" value="$sow->{'query'}->{'css'}">
<label for="trsid">基本設定</label>
<select id="trsid" name="trsid" class="input-small">
_HTML_
	my $trsidlist = $sow->{'cfg'}->{'TRSIDLIST'};
	foreach (@$trsidlist) {
		my $selected = "";
		$selected = " selected" if ($_ eq $sow->{'query'}->{'trsid'});
		my %dummyvil = (
			trsid => $_,
		);
		&SWBase::LoadTextRS($sow, \%dummyvil);
		print "      <option value=\"$_\"$selected>$sow->{'textrs'}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
	}

	print <<"_HTML_";
</select>
<label for="game">ゲームルール</label>
<select id="game" name="game" class="input-small">
_HTML_

	my $game     = $sow->{'basictrs'}->{'GAME'};
	my $gamelist = $sow->{'cfg'}->{'GAMELIST'};
	foreach (@$gamelist) {
		my $selected = '';
		$selected = " $sow->{'html'}->{'selected'}" if ($sow->{'query'}->{'game'} eq $_);
		print "<option value=\"$_\"$selected>$game->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
	}

	# 見物人種類
	print <<"_HTML_";
</select>
<input type="submit" value="編成を見る">
</form>
</p>
</div>

_HTML_
	$doc->outhtml(); # 本文出力
	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
