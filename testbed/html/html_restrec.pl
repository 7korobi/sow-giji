package SWHtmlRestRecord;

#----------------------------------------
# 戦績再構築画面のHTML出力
#----------------------------------------
sub OutHTMLRestRecord {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'restrec';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'vidstart'} > 0) {
		my $vidtext = "$query->{'vidstart'}村";
		$vidtext .= "～$query->{'vidend'}村" if ($query->{'vidstart'} != $query->{'vidend'});
		print "<p class=\"info\">\n$vidtextの戦績データを再構\築しました。\n</p>\n\n";
	}

	print <<"_HTML_";
<h2>戦績の再構\築</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <label>村番号：<input type="text" name="vidstart" value="" size="4"$net></label> <label>～ <input type="text" name="vidend" value="" size="4"$net></label>
  <input type="submit" value="再構\築"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
戦績データを再構\築する事ができます。
</p>

<p class="paragraph">
村番号欄は右側を空欄にすると、左側の欄で指定した村番号の村の戦績のみを再構\築します。右側に数値を入れると、２つの欄で指定した範囲の村の戦績データを一括処理する事ができます。<br$net>
村番号の右側の欄に 0 を入力すると、最新の村番号として扱われます。
</p>

<p class="paragraph">
多数の村の戦績データを一括処理すると<strong class="cautiontext">それなりに負荷がかかります</strong>ので、注意して下さい。
</p>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	return;
}

1;
