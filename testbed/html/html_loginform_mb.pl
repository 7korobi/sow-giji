package SWHtmlLoginFormMb;

#----------------------------------------
# ログインフォーム／設定画面HTMLの表示
#----------------------------------------
sub OutHTMLLoginMb {
	my $sow = $_[0];
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML出力用ライブラリの読み込み
	require "$cfg->{'DIR_HTML'}/html.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ


	my $title = 'ログイン';
	my $buttuncaption = 'ログイン';
	if ($query->{'cmd'} eq 'cfg') {
		$title = '設定';
		$buttuncaption = '変更';
	}

	$sow->{'html'}->outheader($title); # HTMLヘッダの出力
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $option = $sow->{'html'}->{'option'};

	print <<"_HTML_";
$cfg->{'NAME_SW'}<br$net>

_HTML_

	my $vid = '';
	$vid = $query->{'vid'} if (defined($query->{'vid'}));
	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

	if (0) {
		print <<"_HTML_";
<input type="text" name="vid" value="$vid" size="5" istyle="4"$net> 村番号<br$net>
_HTML_
	}

	if ($query->{'cmd'} ne 'cfg')	{
		print <<"_HTML_";
<input type="text" name="uid" value="" size="8" istyle="3"$net> ユーザーID<br$net>
<input type="text" name="pwd" value="" size="8" istyle="3"$net> パスワード<br$net>
_HTML_
	}

	print "<select name=\"row\">\n";

	my $row_mb = $sow->{'cfg'}->{'ROW_MB'};
	my $row = $sow->{'cfg'}->{'MAX_ROW_MB'};
	$row = $query->{'row'} if (defined($query->{'row'}));
	foreach (@$row_mb) {
		my $selected = '';
		$selected = " $sow->{'html'}->{'selected'}" if ($_ == $row);
		print "<option value=\"$_\"$selected>$_$option\n";
	}

	my $desc = " $sow->{'html'}->{'selected'}";
	my $asc = '';
	if (($query->{'order'} eq 'a') || ($query->{'order'} eq 'asc')) {
		$desc = '';
		$asc = " $sow->{'html'}->{'selected'}";
	}
	print <<"_HTML_";
</select> 表\示件数<br$net>
<select name="order">
<option value="d"$desc>下から上$option
<option value="a"$asc>上から下$option
</select> 並び順<br$net>
_HTML_

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'vindex';
	$reqvals->{'vid'} = '';
	$reqvals->{'row'} = '';
	$reqvals->{'order'} = '';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	print <<"_HTML_";
$hidden
<input type="submit" value="$buttuncaption"$net>
</form>
_HTML_

	my $urlbbs = $sow->{'cfg'}->{'URL_BBS_MB'};
	my $namebbs = $sow->{'cfg'}->{'NAME_BBS_MB'};
	if ($sow->{'cfg'}->{'URL_BBS_MB'} eq '') {
		$urlbbs  = $sow->{'cfg'}->{'URL_BBS'} if (defined($sow->{'cfg'}->{'URL_BBS'}));
		$namebbs = $sow->{'cfg'}->{'NAME_BBS'} if (defined($sow->{'cfg'}->{'NAME_BBS'}));
	}
	if ($urlbbs ne '') {
		print <<"_HTML_";
<hr$net>

<a href="$urlbbs">$namebbs</a>
_HTML_
	}
	print "\n";

	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;