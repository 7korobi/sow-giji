package SWHtmlProfile;

#----------------------------------------
# ユーザー情報のHTML出力
#----------------------------------------
sub OutHTMLProfile {
	my ($sow, $recordlist, $totalrecord, $camps, $roles) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $urlsow  = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $urluser = "$cfg->{'URL_USER'}?user=";

	undef($query->{'vid'});

	my $user = SWUser->new($sow);
	$user->{'uid'} = $query->{'prof'};
	$user->openuser(1);
	$user->closeuser();

	my $nospaceprof = $query->{'prof'};
	$nospaceprof =~ s/^ *//;
	$nospaceprof =~ s/ *$//;
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "ユーザーIDを指定して下さい。", "no prof.") if (length($nospaceprof) == 0);

	# テキストリソースの読込
	my %vil = (
		trsid        => $sow->{'cfg'}->{'DEFAULT_TEXTRS'},
	);
	&SWBase::LoadTextRS($sow, \%vil);

	# HTMLの出力
	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader("$query->{'prof'}さんのユーザー情報"); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'editprofform';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $linkedit  = '';
	$linkedit = " <a href=\"$urlsow?$linkvalue\">編集</a>" if ($sow->{'uid'} eq $query->{'prof'});

	my $linkuser = '';
	$linkuser = " <a href=\"$urluser$user->{'uid'}\">戦跡</a>" if ($sow->{'uid'} eq $query->{'prof'});

	my $handlename = '未登録';
	$handlename = $user->{'handlename'} if ($user->{'handlename'} ne '');

	my $url = '未登録';
	$url = $user->{'url'} if ($user->{'url'} ne '');
	$url = "<a href=\"$user->{'url'}\">$user->{'url'}</a>" if ((index($user->{'url'}, 'http://') == 0) || (index($user->{'url'}, 'https://') == 0));

	my $introduction = 'なし';
	$introduction = $user->{'introduction'} if ($user->{'introduction'} ne '');
	$introduction =~ s/(s?https?:\/\/[^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/<a href=\"$&\" $blank>$1...<\/a>/g;

	print <<"_HTML_";
<h2>$query->{'prof'}さんの情報$linkedit $linkuser</h2>

<p class="paragraph">
  <span class="multicolumn_label">ユーザーID：</span><span class="multicolumn_left">$query->{'prof'}</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">ハンドル名：</span><span class="multicolumn_left">$handlename</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">URL：</span><span class="multicolumn_left">$url</span>
  <br class="multicolumn_clear"$net>
_HTML_

	$reqvals->{'cmd'} = '';

	if (($sow->{'uid'} eq $query->{'prof'}) || ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})) {
		my $user = SWUser->new($sow);
		$user->{'uid'} = $query->{'prof'};
		$user->openuser(1);
		my $entriedvils = $user->getentriedvils();
		$user->closeuser();

		print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3>自己紹介</h3>
<p class="paragraph">
$introduction
</p>
<hr class="invisible_hr"$net>
_HTML_
	}

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter('');
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
