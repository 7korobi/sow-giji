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
\$(function(){\$('.finished_log').hide()});
</script>
<h2 style="font-size: xx-large;">$cfg->{'NAME_HOME'}</h2>
_HTML_

	# 州を紹介
	if (-e $urlinfo) {
		require $urlinfo;
		&SWAdminInfo::OutHTMLStateInfo($sow);
	}

	my $topcss  = &SWBase::GetLinkValues($sow, $reqvals);
	# 遊び方と仕様FAQ
	$reqvals->{'cmd'} = 'howto';
	my $linkvalue   = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolematrix';
	my $linkrolematrix = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolelist';
	my $linkrolelist = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rule';
	my $linkrule    = &SWBase::GetLinkValues($sow, $reqvals);

	my $linkmake     = $urlwiki.'(Knowledge)Manual';
    my $linkroledeal = 'http://utage.sytes.net/WebRecord/dat_role_deals/'.$cfg->{'RULE'}.'/web';
	my $linkoperate = '(Knowledge)Operation';
	my $linkspec    = '(What)Other';

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

	$caution_vmake = ' <span class="infotext">村を作成する場合はログインして下さい。</span>' if ($sow->{'user'}->logined() <= 0);
	if ($vcnt <= 0) {
		$linkvmake = '<input type="submit"  class="btn" value="村の作成" disabled>';
		$caution_vmake = ' <span class="infotext">現在稼働中の村の数が上限に達しているので、村を作成できません。</span>';
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
<dl class="accordion">
<dt>この州の設定</dt>
<dd>
この州では、廃村期限$cfg->{'TIMEOUT_SCRAP'}日、
内緒話の村を$enabled_aiming、
狂人は$enabled_ambidexter、
幽界トーク村を$enabled_undead、
エピローグで勝敗が$enabled_winner_label、
死んだあと仲間の囁きが$enabled_permit_dead。
少女や降霊者に聞こえるのは$enabled_bitty。
日食で見えるのは会話内容のみ。<br>
[<a href="$link_state_page">くわしい特徴</a>]

<dt> 対応ブラウザ
<dd>
<p>これらのブラウザで動作確認済みです。</p>
<ul>
<li>Internet Explorer : 9 以降 
<br>（スクロールだけ重い、という症状が出るようです）
<li>Firefox : 20.0 以降
<li>Chrome : 26.0 以降
<li>Safari : 6.0.3 以降
<li>iOS : 5.1.1 以降
<li>Android : 2.2.1 以降
</ul>

</dl>

<hr class="invisible_hr"$net>

<h2><a name="welcome">$cfg->{'NAME_SW'}へようこそ</a></h2>
<div class="paragraph">
<ol type="1">
<li><a href="$urlsow?cmd=about">$cfg->{'NAME_SW'}とは？</a>
<li><a href="$urlsow?$linkvalue">遊び方</a>、<a href="$urlwiki$linkoperate">操作方法</a>、<a href="$urlsow?$linkrule">ルールと心構\え</a>をよく読もう。
<li><a href="http://crazy-crazy.sakura.ne.jp/giji/"><img src="$urlimg/banner/guide.png"></a>
<br>人狼ゲームの基本的な知識、人狼議事独自システムの説明は、公式まとめサイトで知ろう。
<li>他の人狼クローンを遊んだ事のあるきみは、まず<a href="$urlwiki$linkspec">他の人狼ゲームとの違い</a>を読もう。多くのことがここに書かれている。
<li>他、細かい調整について知りたいときは、<a href="http://crazy-crazy.sakura.ne.jp/giji/">仕様変更</a>を参考にしよう。
<li>なにをする遊び場かわかった？そうしたら、すぐ下に村がある。
</ol>
</div>

<hr class="invisible_hr"$net>

<h2><a name="deploy">村建て前</a></h2>
<dl class="paragraph">
<dt><strong><a href="{{link.plan}}">企画村\予\定\表\</a></strong>（wiki：stinさん管理）
<dd>これから始まる村の予\定が並んでいる。ロールプレイヤー必見かも。
</dl>
<dl class="paragraph">
<dt><strong><a href="http://crazy-crazy.sakura.ne.jp/giji_lobby/lobby/sow.cgi?vid=11#mode=talk_all_open&navi=link">村建て相談所</a></strong>
<dd>遊びたい村の相談をする場所。迷ったら飛び込むといい。
</dl>

<dl class="accordion">
<dt> 村建てツール
<dd>

まず<a href="$urlsow?$linkrule#make">村建て人の心構\え</a>、<a href="$linkmake">村建てマニュアル</a>を読んでから村を建てよう。<br>

<ul>
<li>参考：<a href="$urlsow?$linkrolematrix">役職配分一覧</a>
<li>参考：<a href="http://crazy-crazy.sakura.ne.jp/giji/?(List)SayCnt">発言pt量</a>の一覧<br>
<li>$caution_vmake
</ul>
_HTML_
	if ($sow->{'cfg'}->{'ENABLED_VMAKE'} > 0) {
		print <<"_HTML_";
<p>
<a href="sow.cgi?cmd=trsdiff">基本設定</a>を選んで「村の作成」を押すと、新しくゲームを作成できる。
</p>
<form action="$urlsow" method="get">
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
$linkvmake<br$net>
</form>
_HTML_
	}
	print <<"_HTML_";
<dt> 参加者ツール
<dd>

<p class="mark">ゲーム内での文章</p>
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

<hr class="invisible_hr"$net>

<p class="mark">キャラクター画像一覧</p>
<ul>
_HTML_
	my $csidlist = $cfg->{'CSIDLIST'};
	foreach (@$csidlist) {
		next if (index($_, '/') >= 0);
		$reqvals->{'cmd'}  = 'chrlist';
		$reqvals->{'csid'} = $_;
		$sow->{'charsets'}->loadchrrs($_);
		$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
		print "<li><a href=\"$urlsow?$linkvalue\">$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'}</a></li>\n";
	}
	print <<"_HTML_";
</ul>
</dl>
_HTML_
	$sow->{'trsid'} = $defaulttrsid;
	$sow->{'textrs'} = $defaulttextrs;

	print <<"_HTML_";
<h2>村の一覧</h2>
<div class="paragraph">
名前欄に
<img src="$cfg->{'DIR_IMG'}/icon/key.png">
マークの付いた村は参加時に参加パスワードが必要です。<br$net>
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
マークの付いた村は、<a href="$linkmake#mark">こだわり</a>のある村です。好みの別れる場合もありますので、まず村の情報欄を開いて内容を確認しましょう。

<dl>
<dt><a href="sow.cgi?cmd=rule">ルールと心構\え</a>を守って、楽しく、強く遊ぼう。
<dd><a href="sow.cgi?cmd=rule">参加者のルール</a>と心構\え、そして、<a href="sow.cgi?cmd=rule#make">村立て人の心構\え</a>はここにある。
</dl>
</div>

<h3>募集中／開始待ち$linkrss</h3>
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
<h3>終了済み</h3>

<div class="paragraph">
<a href="$urlsow?$linkvalue">終了済みの村</a>
</div>
<hr class="invisible_hr"$net>

<hr class="invisible_hr"$net>

<h2>技術情報</h2>

<dl class="accordion">
<dt> プログラム
<dd>
<ul>
<li><a href="https://github.com/7korobi/sow-giji">最新版　人狼議事サイトプログラム</a>
<li><a href="https://github.com/7korobi/giji_rails">過去ログ閲覧サイトプログラム</a>
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
