package SWHtmlRestVIndex;

#----------------------------------------
# 村一覧再構築画面のHTML出力
#----------------------------------------
sub OutHTMLRestVIndex {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'restvi';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'cmd'} eq 'restvi') {
		print "<p class=\"info\">\n村一覧ファイルを再構\築しました。\n</p>\n\n";
	}

	print <<"_HTML_";
<h2>村一覧の再構\築</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <input type="submit" value="再構\築"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
なんらかの理由で村一覧ファイルが破損した場合に修復する事ができます。
</p>

<p class="paragraph">
多数の村が存在する時に村一覧の再構\築を行うと<strong class="cautiontext">それなりに負荷がかかります</strong>ので、注意して下さい。
</p>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	return;
}

1;
