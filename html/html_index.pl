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

	print "<DIV class=toppage>";
	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $net = $sow->{'html'}->{'net'}; # Null End Tag

	print <<"_HTML_";
<div class="login" template="navi/headline"></div>
_HTML_
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	&SWHtmlPC::OutHTMLGonInit($sow); # ログイン欄の出力
	print <<"_HTML_";
</script>
<h2 style="font-size: xx-large;">$cfg->{'NAME_HOME'}</h2>
_HTML_

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

	require "$cfg->{'DIR_RS'}/doc_rule.pl";
	my $docprohibit = SWDocRule->new($sow);
	$docprohibit->outhtmlsimple();


	my $imgrating = '';
	my $rating = $cfg->{'RATING'};
	my $ratingorder = $rating->{'ORDER'};
	foreach (@$ratingorder) {
		$imgrating .= "<img src=\"$cfg->{'DIR_IMG'}/$rating->{$_}->{'FILE'}\" width=\"$rating->{$_}->{'WIDTH'}\" height=\"$rating->{$_}->{'HEIGHT'}\" alt=\"[$rating->{$_}->{'ALT'}]\" title=\"$rating->{$_}->{'CAPTION'}\"$net> " if ($rating->{$_}->{'FILE'} ne '');
	}

	my $linkrss = " <a href=\"$urlsow?cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);


	my $linkvmake = '<input type="submit"  class="btn" value="村の作成">';
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
<script>
var hello;
if (new Date % (24*3600000) - 9 * 3600000 < 0) {
  hello = "こんにちわ";
}else{
  hello = "こんばんわ";
}

gon.oldlog = [
{ mesicon:'',
  name:'留守番 ジョージ',
  text:'この奥だよ。もう<a class="mark" href="$urlsow?cmd=oldlog">終了した村</a>の記録が眠っている。\\
静かに、ひっそりとね。',
updated_at: new Date(1389008975000),template:"message/say",mestype:"TSAY",csid:"all",face_id:"c76"},
];

gon.guide = [
{ name:'ティモシー',
  text:'（↓）をそっと畳み、営業を再開した。<br><a href="http://crazy-crazy.sakura.ne.jp/giji/"><img src="$urlimg/banner/guide.png"></a>',
updated_at: new Date(1389008975000),template:"message/action",mestype:"SAY"},
{ mesicon:'',
  name:'雑貨屋 ティモシー',
  text: 'いらっしゃい。$cfg->{'NAME_SW'}のことを知りたいんだね。それなら、人狼議事公式ガイドブックを開いてごらん。<br>\\
あるいは、ほかのリンク先をお求めかな。<br>\\
<br>\\
<ul>\\
<li><a class="mark" href="$urlsow?cmd=about">ご紹介</a>そもそも、どういうものなんだろう\\
<li><a class="mark" href="$urlsow?cmd=howto">遊び方</a>参加から終了までの流れが知りたい\\
<li><a class="mark" href="$urlwiki$linkoperate">操作方法</a>プレイ中の詳しい操作を知りたい\\
</ul>',
updated_at: new Date(1389008975000),template:"message/say",mestype:"SAY",csid:"all",face_id:"c07"},
{ mesicon:'',
  name:'花売り メアリー',
  text: hello + '。もしあなたが、どこかで人狼ゲームを遊んだ事があるなら、<a class="mark" href="$urlwiki$linkspec">他の人狼ゲームとの違い</a>をどうぞ。<br>\\
それとも調べ物？だったらお好きな一輪を。<br><br>\\
<ul>\\
<li><a class="mark" href="$urlsow?cmd=roleaspect&trsid=all">役職と能\力の一覧\表\</a>を調べる。\\
<li><a class="mark" href="$urlsow?cmd=rolelist">役職ごとのインターフェース</a>を調べる。\\
</ul>',
updated_at: new Date(1389008975000),template:"message/say",mestype:"SAY",csid:"all",face_id:"c01"},
];

gon.rule = [
{ mesicon:'',
  name:'学者 レオナルド',
  text:'<a href="sow.cgi?cmd=rule" class="mark">ルールと心構\え</a>を守って、楽しく、強く遊ぼう。<br>\\
ここでは、みんなに守ってほしいルールや、吟味してほしい心構\えを紹介するよ。<br>\\
では、リンク先の１ページ目から\―\―\― ',
updated_at: new Date(1389008975000),template:"message/say",mestype:"SAY",csid:"all",face_id:"c96",style:"head"},
];

gon.setting = [
{ mesicon:'【赤】',
  name:'新聞配達 モリス', to:'？',
  text:'<a class="mark" href="$link_state_page">くわしい特徴</a>はこうだ。わかるか？…またな。<br>\\
<ul>\\
<li>廃村期限は$cfg->{'TIMEOUT_SCRAP'}日間\\
<li>内緒話の村を$enabled_aiming\\
<li>狂人は$enabled_ambidexter\\
<li>幽界トーク村を$enabled_undead\\
<li>エピローグで勝敗が$enabled_winner_label\\
<li>死んだあと仲間の囁きが$enabled_permit_dead\\
<li>少女や降霊者に聞こえるのは$enabled_bitty\\
<li>日食で見えるのは会話内容のみ\\
</ul>',
updated_at: new Date(1370662886000),template:"message/aim",mestype:"WSAY",csid:"all",face_id:"c95"},
{ name:'新聞配達 モリス',
  text:'人目を避けて去っていった…。',
updated_at: new Date(1370662886000),template:"message/action",mestype:"WSAY"}
];

gon.browsers = [
{ mesicon:'【人】',
  name:'店番 ソ\フィア',
  text:'これらのブラウザで動作確認済みです。\\
<br><ul>\\
<li>Internet Explorer : 9 以降\\
<li>Firefox : 20.0 以降\\
<li>Opera 12.15 以降\\
<li>Safari : 6.0.3 以降\\
<li>iOS : 5.1.1 以降\\
<li>Chrome : 26.0 以降\\
<li>Android : 2.2.1 以降\\
</ul>',
updated_at: new Date(1370662886000),template:"message/say",style:"head",mestype:"SAY",csid:"all",face_id:"c67"}
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

<dl class="accordion">
<dt> <span class="mark"> &#x2718; </span>

<dt>終了した村
<dd class="plain">
<div class="message_filter" ng-repeat="message in oldlog" log="message"></div>

<dt>プレイガイド
<dd class="plain">
<div class="message_filter" ng-repeat="message in guide" log="message"></div>

</dl>

<h2>村を選ぶ</h2>
<div class="message_filter" ng-repeat="message in rule" log="message"></div>


<dl class="accordion">
<dt> <span class="mark"> &#x2718; </span>

<dt>キャラクター画像一覧
<dd class="plain">
<div class="chrlist">
<p>キャラクターを選ぶ参考に、<a class="mark" href="http://giji.check.jp/map_reduce/faces">人気度集計</a>をチェックしてもいいかもね。</p>
<div style="font-size:80%; line-height:120%;" template="navi/chr_list">
</div></div>
<dt>この州の設定
<dd class="plain">
<div class="message_filter" ng-repeat="message in setting" log="message"></div>
</dl>

<h3>募集中／開始待ち$linkrss</h3>
<div class="paragraph">
<img src="$cfg->{'DIR_IMG'}/icon/key.png">
マークの付いた村は、参加にパスワードが必要です。<br$net>
<img src="$cfg->{'DIR_IMG'}/icon/cd_love.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_sexy.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_violence.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_teller.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_drunk.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_gamble.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_crime.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_drug.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_word.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_fireplace.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_appare.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_ukkari.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_child.png">
<img src="$cfg->{'DIR_IMG'}/icon/cd_biohazard.png">
マークは、<a href="$linkmake#mark">こだわり</a>のある村についています。まず村の情報をよく読んで、好みのあう村を選びましょう。
</div>
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

<h3>別のサイトから探す</h3>

<dl class="paragraph">

<dt><a class="mark" href="http://giji.check.jp/">人狼議事総合トップ</a>
<dd>人狼議事全体の過去ログ、募集中の村の一覧など。

<dt><a class="mark" href="{{link.plan}}">企画村\予\定\表\</a>（wiki：stinさん管理）
<dd>これから始まる村の予\定が並んでいる。好みの村があるかもね。

<dt><a class="mark" href="http://melon-cirrus.sakura.ne.jp/wiki/?%A5%B5%A1%BC%A5%D0%A1%BC%A5%EA%A5%B9%A5%C8">人狼物語Server一覧</a>
<dd>「人狼物語」シリーズのサイトについてまとめてある。

<dt><a class="mark" href="http://melon-cirrus.sakura.ne.jp/wiki/">人狼物語専用wiki</a>（wiki：melonkoさん管理）
<dd>「人狼物語」スクリプトを利用して運営されている国のための総合wiki。

</dl>

<h3>自分で村をつくる</h3>
<div class="ng-scope ng-binding"><div class="VSAY"><div class="action">
_HTML_
	if ( $sow->{'cfg'}->{'ENABLED_VMAKE'} > 0 ) {
		if ('CIEL' eq $cfg->{'RULE'}){
			print <<"_HTML_";
<p class="text">
便利な<a class="mark" href="{{link.plan}}">企画村予\定表\</a>はもう見た？建てた村に人が集まりそうかどうか、\予\想できるかもしれないよ。<br>
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
<form action="$urlsow" method="get" ng-show="yes_i_read_it">
<input type="hidden" name="cmd" value="makevilform">
<input type="hidden" name="css" value="$sow->{'query'}->{'css'}">
<select id="trsid" name="trsid">
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
</div></div></div>
<dl class="paragraph">
<dt><a class="mark" href="http://crazy-crazy.sakura.ne.jp/giji_lobby/lobby/sow.cgi?vid=11#mode=talk_all_open&navi=info">村建て相談所</a>
<dd>遊びたい村の相談をする場所。迷ったら飛び込むといい。

<dt><a class="mark" href="$linkmake">村建てマニュアル</a>
<dd>自分で村を建てる手順や考え方の解説。

<dt><a class="mark" href="$urlsow?$linkrolematrix">役職配分一覧</a>
<dd>役職配分をシステム任せにするときの参考に。

<dt><a class="mark" href="$linksaycnt">発言pt量の一覧</a>
<dd>村で使う発言ptの設定内容について、詳しい一覧表

<dt>ゲーム内での文章
<dd>
ゲーム内で現れる文章の一覧を見ることができます。参考にどうぞ。
<form action="$urlsow" method="get" >
<input type="hidden" name="cmd" value="trslist">
<input type="hidden" name="css" value="$sow->{'query'}->{'css'}">
<select id="trsid" name="trsid">
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
<input type="submit"  class="btn" value="文章を見る">
</form>

</dl>


<h2>技術情報</h2>

<dl class="accordion">
<dt> <span class="mark"> &#x2718; </span>
<dt> 対応ブラウザ
<dd class="plain">
<div class="message_filter" ng-repeat="message in browsers" log="message"></div>
<dt> プログラム
<dd>
<ul>
<li><a href="https://github.com/7korobi/sow-giji/tree/angular">最新版　人狼議事サイト プログラム</a>
<li><a href="https://github.com/7korobi/sow-giji/releases">ダウンロード ページ</a>
<li><a href="https://github.com/7korobi/giji_rails/tree/renewal">人狼議事 総合トップ、javascript、stylesheet</a>
<li>ライセンスは<a href="$license">修正済みBSDライセンス</a>となっています。永遠にバグ取り中。
</ul>
<dt> 謝辞
<dd>
<p> 
作成にあたり、こちらのサイトを参考にさせていただきました。<br>
ありがとうございます。
</p>
<ul>
  <li>人狼審問 - Neighbour Wolves - (終了)</li>
  <li>The Village of Headless Knight (一時休止中)</li>
  <li>おとぎの国の人狼（欧州 おしまい）</li>
  <li>人狼の悪夢 (閉鎖)</li>
  <li>汝は人狼なりや？Shadow Gallery Ver 2.0（終了）</li>
  <li>MAD PEOPLE（終了）</li>
  <li><a href="http://ninjinix.com/">人狼BBS</a></li>
  <li><a href="http://wolfbbs.jp/">人狼BBS まとめサイト</a></li>
  <li><a href="http://mshe.skr.jp/">人狼BBQ 四国</a></li>
  <li><a href="http://melon-cirrus.sakura.ne.jp/sow/">人狼物語 瓜科国</a></li>
  <li><a href="http://www3.marimo.or.jp/~fgmaster/cabala/sow.cgi">人狼物語 ぐたるてぃめっと</a></li>
  <li><a href="http://o8o8.o0o0.jp/wolf/sow.cgi">人狼物語暗黒編</a></li>
  <li><a href="http://tkido.com/m_jinro/index.html">メビウス人狼</a></li>
  <li><a href="http://trpg.scenecritique.com/Paranoia_O/">PARANOIA O</a></li>
  <li><a href="http://scpjapan.wiki.fc2.com">The SCP Foundation</a></li>
</ul>
</dl>
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
