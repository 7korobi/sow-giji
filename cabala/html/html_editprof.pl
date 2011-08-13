package SWHtmlEditProfile;

#----------------------------------------
# ユーザー情報編集完了画面のHTML出力
#----------------------------------------
sub OutHTMLEditProfile { 
	my $sow = shift;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader("ユーザー情報編集完了($sow->{'uid'})"); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'prof'} = $sow->{'uid'};
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	&SWHtmlPC::OutHTMLLogin($sow); # ログインボタン表示

	print <<"_HTML_";
<h2>ユーザー情報編集完了</h2>

<p class="info"><a href="$urlsow?$linkvalue">$sow->{'uid'}</a>さんのユーザー情報を更新しました。</p>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;