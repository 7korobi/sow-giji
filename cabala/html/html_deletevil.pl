package SWHtmlDeleteVil;

#----------------------------------------
# 村データ削除画面のHTML出力
#----------------------------------------
sub OutHTMLDeleteVil {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'deletevil';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'vidstart'} > 0) {
		my $vidtext = "$query->{'vidstart'}村";
		$vidtext .= "～$query->{'vidend'}村" if ($query->{'vidstart'} != $query->{'vidend'});
		print "<p class=\"info\">\n$vidtextの村データを削除しました。\n</p>\n\n";
	}

	print <<"_HTML_";
<h2>村データの削除</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <label>村番号：<input type="text" name="vidstart" value="" size="4"$net></label> <label>～ <input type="text" name="vidend" value="" size="4"$net></label>
  <input type="submit" value="削除"$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	return;
}

1;
