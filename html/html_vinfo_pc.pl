package SWHtmlVilInfo;

#----------------------------------------
# 村情報画面のHTML出力
#----------------------------------------
sub OutHTMLVilInfo {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_sayfilter.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_formpl_pc.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# JavaScriptの設定
	$sow->{'html'}->{'file_js'} = $sow->{'cfg'}->{'FILE_JS_VIL'};

	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader("村の情報 / $sow->{'query'}->{'vid'} $vil->{'vname'}"); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログインボタン表示
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	# 村データの読み込み
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();
	my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);

	my $vid = $vil->{'turn'};
	$vid = $vil->{'epilogue'} if ($vid > $vil->{'epilogue'});
	my $logfile = SWBoa->new($sow, $vil, $vid, 0);
	$logfile->close();

	print <<"_HTML_";
<h2>{{story.vid}} {{story.name}} $linkrss</h2>
<h3>{{subtitle}}</h3>
<div template="navi/messages" id="messages"></div>
_HTML_
	&OutHTMLVilInfoInner($sow,$vil);

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る
	$sow->{'html'}->outcontentfooter();

	&SWHtmlPC::OutHTMLGonInit($sow); # ログイン欄の出力
	$vil->gon_story();
	$vil->gon_event();
	$vil->gon_potofs();
	# 村建て人フォーム／管理人フォーム表示
	if ($sow->{'user'}->logined() > 0) {
		if ($vil->{'makeruid'} eq $sow->{'uid'}) {
			&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
		}
		if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}) {
			&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
			&SWHtmlPlayerFormPC::OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
		}
	}

	print <<"_HTML_";
var mes = {
	"template": "sow/village_info",
	"logid": "vilinfo00001"
	"date": 1
};
gon.event.messages.push(mes);
</script>
_HTML_

	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
}


sub OutHTMLVilInfoInner {
	my ($sow,$vil) = @_;
	# 村建て人フォーム／管理人フォーム表示
	if ($sow->{'user'}->logined() > 0) {
		my $showbtn = 0;
		$showbtn = 1 if ($sow->{'uid'} eq $vil->{'makeruid'});
		$showbtn = 1 if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'});
		if ($showbtn){
			print <<"_HTML_";
<div template="navi/forms" id="forms"></div>
_HTML_
		}
	}

	return;
}

1;
