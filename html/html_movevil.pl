package SWHtmlMoveVil;

#----------------------------------------
# 村データ移動画面のHTML出力
#----------------------------------------
sub OutHTMLMoveVil {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'movevil';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'vidstart'} > 0) {
		my $vidtext = "$query->{'vidstart'}村";
		$vidtext .= "～$query->{'vidend'}村" if ($query->{'vidstart'} != $query->{'vidend'});
		print "<p class=\"info\">\n$vidtextの村データを移動しました。\n</p>\n\n";
	}
	my $option = $sow->{'html'}->{'option'};

	print <<"_HTML_";
<h2>村データの移動</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <label>村番号：<input type="text" name="vidstart" value="" size="4"$net></label> <label>～ <input type="text" name="vidend" value="" size="4"$net></label>
  <select name="vidmove">
    <option value="file2dir">村全体 → 村番号別$option
    <option value="dir2file">村番号別 → 村全体$option
  </select>
  <input type="submit" value="移動"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
村データを１村単位で村番号別ディレクトリ（$sow->{'cfg'}->{'DIR_VIL'}/xxxx）へ移動させたり、逆に村全体データディレクトリ（$sow->{'cfg'}->{'DIR_VIL'}）へ移動させたりできます。<br$net>
</p>

<p class="paragraph">
村番号欄は右側を空欄にすると、左側の欄で指定した村番号の村のみを移動します。右側に数値を入れると、２つの欄で指定した範囲の村を一括移動させる事ができます。<br$net>
村番号の右側の欄に 0 を入力すると、最新の村番号として扱われます。
</p>

<p class="paragraph">
多数の村を一括移動させると<strong class="cautiontext">それなりに負荷がかかります</strong>ので、注意して下さい。
</p>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	return;
}

1;
