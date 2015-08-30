package SWHtmlIndex;

#----------------------------------------
# トップページのHTML出力
#----------------------------------------
sub OutHTMLIndex {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_LIB'}/file_vindex.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_vindex.pl";

	# 村一覧データ読み込み
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();

	my $linkvalue;
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $urlsow  = $cfg->{'BASEDIR_CGI'}.'/'.$cfg->{'FILE_SOW'};
	my $urlwiki = $cfg->{'URL_CONST'};
	my $urlinfo = $cfg->{'TOPPAGE_INFO'};
	my $urlimg  = $cfg->{'DIR_IMG'};

	my $infodt = 0;
	$infodt = (stat($urlinfo))[9] if (-e $urlinfo);
	my $changelogdt = (stat("./$cfg->{'DIR_RS'}/doc_changelog.pl"))[9];
	$infodt = $changelogdt if ($changelogdt > $infodt);
	&SetHTTPUpdateIndex($sow, $infodt, $vindex->getupdatedt());

	$sow->{'http'}->setnotmodified(); # 最終更新日時

	# HTTP/HTMLの出力
	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->{'rss'} = "$urlsow?cmd=rss"; # 村の一覧のRSS
	$sow->{'html'}->outheader('トップページ'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	print "<DIV class=toppage>";
	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力
	&SWHtmlPC::OutHTMLChangeCSS($sow);
	&SWHtmlPC::OutHTMLGonInit($sow); # ログイン欄の出力

	# 州を紹介
	if (-e $urlinfo) {
		require $urlinfo;
		&SWAdminInfo::OutHTMLStateInfo($sow);
	}

	my $topcss  = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolematrix';
	my $linkrolematrix = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolelist';
	my $linkrolelist = &SWBase::GetLinkValues($sow, $reqvals);

	my $linkmake    = $urlwiki.'(Knowledge)Manual';
	my $linkoperate = $urlwiki.'(Knowledge)Operation';
	my $linkspec    = $urlwiki.'(What)Other';
	my $linksaycnt  = $urlwiki.'(List)SayCnt';

	my $imgrating = '';
	my $rating = $cfg->{'RATING'};
	my $ratingorder = $rating->{'ORDER'};
	foreach (@$ratingorder) {
		$imgrating .= "<img src=\"$cfg->{'DIR_IMG'}/$rating->{$_}->{'FILE'}\" width=\"$rating->{$_}->{'WIDTH'}\" height=\"$rating->{$_}->{'HEIGHT'}\" alt=\"[$rating->{$_}->{'ALT'}]\" title=\"$rating->{$_}->{'CAPTION'}\"$net> " if ($rating->{$_}->{'FILE'} ne '');
	}

	my $linkrss = " <a tabindex=\"-1\" href=\"$urlsow?cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);


	my $linkvmake = '<input type="submit"  class="btn edge" value="村の作成">';
	my $vcnt          = $sow->{'cfg'}->{'MAX_VILLAGES'} - $vindex->getactivevcnt() ;
	my $caution_vmake = 'あと'.$vcnt.'村が建てられます。';

	$caution_vmake = '村を作成する場合はログインして下さい。' if ($sow->{'user'}->logined() <= 0);
	if ($vcnt <= 0) {
		$linkvmake = '<input type="submit"  class="btn" value="村の作成" disabled>';
		$caution_vmake = '現在稼働中の村の数が上限に達しているので、村を作成できません。';
	}

	my $defaulttrsid = $sow->{'trsid'};
	my $defaulttextrs = $sow->{'textrs'};
	my $trsidlist = $sow->{'cfg'}->{'TRSIDLIST'};


	my $license = 'https://github.com/7korobi/sow-giji/blob/master/cabala/license.txt';

	my $link_state_page  = $cfg->{'URL_CONFIG'};
	my $enabled_bitty    = ($cfg->{'ENABLED_BITTY'}            )?('ひらがなのみ'):('会話内容のみ');
	my $enabled_aiming    = ($cfg->{'ENABLED_AIMING'} eq 1     )?('作成できる'):('作成できない');
	my $enabled_undead     = ($cfg->{'ENABLED_UNDEAD'} eq 1    )?('作成できる'):('作成できない');
	my $enabled_ambidexter  = ($cfg->{'ENABLED_AMBIDEXTER'}    )?('裏切りの陣営'):('人狼陣営');
	my $enabled_permit_dead  = ($cfg->{'ENABLED_PERMIT_DEAD'}  )?('見える'):('見えない');
	my $enabled_winner_label  = ($cfg->{'ENABLED_WINNER_LABEL'})?('見える'):('見えない');

	print <<"_HTML_";
var hello;
var now = new Date() - 0;
if (now % (24*3600000) - 9 * 3600000 < 0) {
  hello = "こんにちわ";
}else{
  hello = "こんばんわ";
}

gon.items = [
{ _id: "title-head-h2-1",
  log: "$cfg->{'NAME_HOME'}",
updated_at: now },

{ _id: "title-talk-TSAY-3",
  name:'留守番 ジョージ',
  log:'この奥だよ。もう<a class="btn edge" href="$urlsow?cmd=oldlog">終了した村</a>の記録が眠っている。\\
静かに、ひっそりとね。',
updated_at: now,face_id:"c76"},

{ _id: "title-talk-SAY-99",
  name:'花売り メアリー',
  log: hello + '。もしあなたが、どこかで人狼ゲームを遊んだ事があるなら、<a class="btn edge" href="$urlwiki$linkspec">他の人狼ゲームとの違い</a>をどうぞ。<br>\\
それとも調べ物？だったらお好きな一輪を。<br><br>\\
<ul class="text">\\
<li><a class="btn edge" href="$urlsow?cmd=roleaspect&trsid=all">役職と能\力の一覧\表\</a>を調べる。\\
<li><a class="btn edge" href="$urlsow?cmd=rolelist">役職ごとのインターフェース</a>を調べる。\\
</ul>',
updated_at: now,face_id:"c01"},

{ _id: "play-talk-WSAY-14",
  name:'新聞配達 モリス', to:'？',
  log:'<a class="btn edge" href="$link_state_page">くわしい特徴</a>はこうだ。わかるか？…またな。<br>\\
<ul class="text">\\
<li>廃村期限は$cfg->{'TIMEOUT_SCRAP'}日間\\
<li>内緒話の村を$enabled_aiming\\
<li>狂人は$enabled_ambidexter\\
<li>幽界トーク村を$enabled_undead\\
<li>エピローグで勝敗が$enabled_winner_label\\
<li>死んだあと仲間の囁きが$enabled_permit_dead\\
<li>少女や降霊者に聞こえるのは$enabled_bitty\\
<li>日食で見えるのは会話内容のみ\\
</ul>',
updated_at: now,face_id:"c95"},

{ _id: "play-action-WSAY-15",
  name:'新聞配達 モリス',
  log:'人目を避けて去っていった…。',
updated_at: now},

{ _id: "play-head-h3-16",
  log: '募集中／開始待ち$linkrss',
updated_at: now }
];


gon.chrs = [];
_HTML_
	my $csidlist = $cfg->{'CSIDLIST'};
	foreach (@$csidlist) {
		next if (index($_, '/') >= 0);

		$sow->{'charsets'}->loadchrrs($_);
		my $charset = $sow->{'charsets'}->{'csid'}->{$_};
		my $csidname = $sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'};
		$csidname =~ s/ /<br>/g;
		$csidname =~ s/（/<br>/g;
		$csidname =~ s/・セット「/<br>/g;
		$csidname =~ s/）//g;
		$csidname =~ s/」//g;

		$reqvals->{'cmd'}  = 'chrlist';
		$reqvals->{'csid'} = $_;
		$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
		my $csidimg = $charset->{'DIR'}. "/" . $charset->{'NPCID'} . "$expression$charset->{'EXT'}";
		my $csidtext = "<a href=\"$urlsow?$linkvalue\">$csidname</a>";
		print <<"_HTML_";
gon.chrs.push({
	"img": '$csidimg',
 	"text": '$csidtext'
});
_HTML_
	}
	$sow->{'trsid'} = $defaulttrsid;
	$sow->{'textrs'} = $defaulttextrs;

	print <<"_HTML_";
</script>

<div class="message_filter" id="item-title"></div>
<div class="message_filter" id="item-play"></div>

<div class="chrlist">
<div template="navi/chr_list">
</div></div>
_HTML_

	# 募集中／開始待ち村の表示
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'prologue');

	print <<"_HTML_";
<h3>進行中</h3>

_HTML_
	# 進行中の村の表示
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'playing');

	$reqvals->{'cmd'} = 'oldlog';
	$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<div class="message_filter" id="item-create"></div>

<div class="VSAY action">
_HTML_
	if ( $sow->{'cfg'}->{'ENABLED_VMAKE'} > 0 ) {
		if ('CHEAT' eq $cfg->{'TYPE'}){
			print <<"_HTML_";
<p class="text">
便利な<a class="btn edge" href="{{link.plan}}">企画村予\定表\</a>はもう見た？建てた村に人が集まりそうかどうか、\予\想できるかもしれないよ。<br>
</p>
<h6><input type="checkbox" ng-model="yes_i_read_it"> 見たよ！今から、村を立てるよ！</h6>
<h6>$caution_vmake</h6>
_HTML_
		} else {
			print <<"_HTML_";
<h6 ng-init="yes_i_read_it = true">$caution_vmake</h6>
_HTML_
		}
		print <<"_HTML_";
<div class="mark ng-binding"></div>
<div class="controls controls-row formpl_content" ng-show="yes_i_read_it">
<form class="form-inline" action="$urlsow" method="get" ng-show="yes_i_read_it">
<input type="hidden" name="cmd" value="makevilform">
<input type="hidden" name="css" value="$sow->{'query'}->{'css'}">
<select class="form-control input-large" id="trsid" name="trsid">
_HTML_
		foreach (@$trsidlist) {
			my %dummyvil = (
				trsid => $_,
			);
			&SWBase::LoadTextRS($sow, \%dummyvil);
			print "      <option value=\"$_\">$sow->{'textrs'}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
		}


		print <<"_HTML_";
</select>
$linkvmake
</form>
<p class="text">基本設定（↑）を選び「村の作成」を押そう。</p>
</div>
_HTML_
	}
	print <<"_HTML_";
</div>
<dl class="TSAY paragraph">
<dt><a class="btn edge" href="http://crazy-crazy.sakura.ne.jp/giji_lobby/lobby/sow.cgi?vid=11#mode=talk_all_open&navi=info">村建て相談所</a>
<dd>遊びたい村の相談をする場所。迷ったら飛び込むといい。

<dt><a class="btn edge" href="$linkmake">村建てマニュアル</a>
<dd>自分で村を建てる手順や考え方の解説。

<dt><a class="btn edge" href="$urlsow?$linkrolematrix">役職配分一覧</a>
<dd>役職配分をシステム任せにするときの参考に。

<dt><a class="btn edge" href="$linksaycnt">発言pt量の一覧</a>
<dd>村で使う発言ptの設定内容について、詳しい一覧表\

<dt>ゲーム内での文章
<dd>
ゲーム内で現れる文章の一覧を見ることができます。参考にどうぞ。
<form class="form-inline" action="$urlsow" method="get" >
<input type="hidden" name="cmd" value="trslist">
<input type="hidden" name="css" value="$sow->{'query'}->{'css'}">
<select class="form-control input-large" id="trsid" name="trsid">
_HTML_
	foreach (@$trsidlist) {
		my %dummyvil = (
			trsid => $_,
		);
		&SWBase::LoadTextRS($sow, \%dummyvil);
		print "      <option value=\"$_\">$sow->{'textrs'}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
	}
	$sow->{'trsid'} = $defaulttrsid;
	$sow->{'textrs'} = $defaulttextrs;


	print <<"_HTML_";
</select>
<input type="submit"  class="btn edge" value="文章を見る">
</form>

</dl>

<div class="message_filter" id="item-tech"></div>
_HTML_

	$vindex->closevindex();
	print "</DIV>";
	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力

	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# エンティティタグの生成
#----------------------------------------
sub SetHTTPUpdateIndex {
	my ($sow, $infodt, $vindexdt) = @_;

	my $etag = '';
	my $user = $sow->{'user'};
	if ($user->logined() > 0) {
		my $uid = &SWBase::EncodeURL($sow->{'uid'});
		$etag .= sprintf("%s-", $uid);
	}
	$etag .= sprintf("index-%x-%x", $infodt, $vindexdt);

	$sow->{'http'}->{'etag'} = $etag;
	$sow->{'http'}->{'lastmodified'} = $vindexdt;
	$sow->{'http'}->{'lastmodified'} = $infodt if ($infodt > $vindexdt);

	return;
}

1;
