package SWHtmlMakeVilForm;

#----------------------------------------
# 村作成／編集画面のHTML出力
#----------------------------------------
sub OutHTMLMakeVilForm {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};

	$sow->{'html'} = SWHtml->new($sow);
	$sow->{'http'}->outheader();
	$sow->{'html'}->outheader("村の作成");
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログインボタン
  &SWHtmlPC::OutHTMLChangeCSS($sow);
	print <<"_HTML_";
<div id="make_vil"></div>
_HTML_

	# 日付別ログへのリンク
	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力


	&SWHtmlPC::OutHTMLGonInit($sow); # ログイン欄の出力
	$vil->gon_story(true);
	$vil->gon_event(true);
	my $fullmanage  = ( $vil->{'turn'} == 0 );

	print <<"_HTML_";
	e = [];
	f = [];
	g = [];
	i = [];

	a = [];
	b = [];
	c = [];
	d = {};

	gon.config = {
		roles: a,
		gifts: b,
		events: c,
		counts: d,
		roletables: i,
		votetypes: [
			{val:"anonymity",name:"無記名投票"},
			{val:"sign",name:"記名投票"}
		],
		intervals: g,
		minutes: f,
		hours: e,
		trs: {
			caption:"$sow->{'textrs'}->{'CAPTION'}",
			help:"$sow->{'textrs'}->{'HELP'}"
		},
		trsid: "$vil->{'trsid'}"
	};
</script>
_HTML_
	$sow->{'http'}->outfooter();

	return;
}

1;
