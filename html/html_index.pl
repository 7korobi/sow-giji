package SWHtmlIndex;

#----------------------------------------
# �g�b�v�y�[�W��HTML�o��
#----------------------------------------
sub OutHTMLIndex {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_LIB'}/file_vindex.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_vindex.pl";

	# ���ꗗ�f�[�^�ǂݍ���
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

	$sow->{'http'}->setnotmodified(); # �ŏI�X�V����

	# HTTP/HTML�̏o��
	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->{'rss'} = "$urlsow?cmd=rss"; # ���̈ꗗ��RSS
	$sow->{'html'}->outheader('�g�b�v�y�[�W'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	print "<DIV class=toppage>";
	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��
	my $net = $sow->{'html'}->{'net'}; # Null End Tag

	# �Ǘ��l����̂��m�点
	if (-e $urlinfo) {
		require $urlinfo;
		&SWAdminInfo::OutHTMLAdminInfo($sow);
	}

	print <<"_HTML_";
<h2 style="font-size: xx-large;">$cfg->{'NAME_HOME'}</h2>
_HTML_

	# �B���Љ�
	if (-e $urlinfo) {
		require $urlinfo;
		&SWAdminInfo::OutHTMLStateInfo($sow);
	}

	my $topcss  = &SWBase::GetLinkValues($sow, $reqvals);
	# �V�ѕ��Ǝd�lFAQ
	$reqvals->{'cmd'} = 'howto';
	my $linkvalue   = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolematrix';
	my $linkrolematrix = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolelist';
	my $linkrolelist = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rule';
	my $linkrule    = &SWBase::GetLinkValues($sow, $reqvals);

	my $linkmake     = $urlwiki.'(Knowledge)Manual';
	my $linkscedure  = 'http://jsfun525.gamedb.info/wiki/?%B4%EB%B2%E8%C2%BC%CD%BD%C4%EA%C9%BD';
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

	my $link_state_page  = $cfg->{'URL_CONFIG'};
	my $enabled_bitty    = ($cfg->{'ENABLED_BITTY'}            )?('�Ђ炪�Ȃ̂�'):('��b���e�̂�');
	my $enabled_aiming    = ($cfg->{'ENABLED_AIMING'}          )?('����'):('�Ȃ�');
	my $enabled_undead     = ($cfg->{'ENABLED_UNDEAD'} eq 1    )?('�쐬�ł���'):('�쐬�ł��Ȃ�');
	my $enabled_ambidexter  = ($cfg->{'ENABLED_AMBIDEXTER'}    )?('���؂�̐w�c'):('�l�T�w�c');
	my $enabled_permit_dead  = ($cfg->{'ENABLED_PERMIT_DEAD'}  )?('������'):('�����Ȃ�');
	my $enabled_winner_label  = ($cfg->{'ENABLED_WINNER_LABEL'})?('������'):('�����Ȃ�');
	print <<"_HTML_";
<p class="paragraph">
���̏B�̐ݒ�́A�p������$cfg->{'TIMEOUT_SCRAP'}���A
�����b$enabled_aiming�A
���l��$enabled_ambidexter�A
�H�E�g�[�N����$enabled_undead�A
�G�s���[�O�ŏ��s��$enabled_winner_label�A
���񂾂��ƒ��Ԃ̚�����$enabled_permit_dead�B
������~��҂ɕ�������̂�$enabled_bitty�B���H�Ō�����͉̂�b���e�̂݁B
[<a href="$link_state_page">���̏B�̓����ڍ�</a>]
</p>
_HTML_

	print <<"_HTML_";
<h2><a name="welcome">$cfg->{'NAME_SW'}�ւ悤����</a></h2>
<p class="paragraph">
<ol type="1">
<li><a href="$urlsow?cmd=about">$cfg->{'NAME_SW'}�Ƃ́H</a>
<li><a href="$urlsow?$linkvalue">�V�ѕ�</a>�A<a href="$urlwiki$linkoperate">������@</a>�A<a href="http://giji-assets.s3-website-ap-northeast-1.amazonaws.com/assets-master/rule.html?scr=nation~~">���[��</a>�A<a href="http://giji-assets.s3-website-ap-northeast-1.amazonaws.com/assets-master/rule.html?scr=player~~">�S�\\��</a>���悭�ǂ����B�Ȃɂ�����V�яꂩ�킩������A�������ɑ�������B
<br>���̐l�T�N���[����V�񂾎��̂��邫�݂́A�܂�<a href="$urlwiki$linkspec">���̐l�T�Q�[���Ƃ̈Ⴂ</a>��ǂ����B�����̂��Ƃ������ɏ�����Ă���B
<li>�l�T�Q�[���̊�{�I�Ȓm���A�l�T�c���Ǝ��V�X�e���̐����́A�����܂Ƃ߃T�C�g�Œm�낤�B
<br><a href="http://crazy-crazy.sakura.ne.jp/giji/"><img src="$urlimg/banner/guide.png"></a>
</ol>
</p>

<hr class="invisible_hr"$net>

<h2><a name="deploy">�����đO</a></h2>
<dl class="paragraph">
<dt><strong>�V�т����I<a href="http://utage.sytes.net/WebRecord/lobby_markets">����]�W�v��</a></strong> - �����J
<dd>�����̂܂܁A�V�т������̊�]���o�����Ƃ��ł���B�N�����������ĂĂ���邩���H
</dl>
<dl class="paragraph">
<dt><strong><a href="http://jsfun525.gamedb.info/wiki/?%B4%EB%B2%E8%C2%BC%CD%BD%C4%EA%C9%BD">��摺\�\\��\�\\</a></strong>�iwiki�Fstin����Ǘ��j
<dd>���ꂩ��n�܂鑺�̗\\�肪����ł���B���[���v���C���[�K�������B
</dl>
<dl class="paragraph">
<dt><strong><a href="http://crazy-crazy.sakura.ne.jp/giji_lobby/lobby/sow.cgi?vid=11&game=MISTERY&trsid=all#mode=memo_all_open_last_player&width=480&font=normal&navi=link">�����đ��k��</a></strong>
<dd>�V�т������̑��k������ꏊ�B���������э��ނƂ����B
</dl>

<h2>���̈ꗗ</h2>

<p class="paragraph">
���O����
<img src="$cfg->{'DIR_IMG'}/icon/key.png">
�}�[�N�̕t�������͎Q�����ɎQ���p�X���[�h���K�v�ł��B<br$net>
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
�}�[�N�̕t�������́A<a href="$linkmake#mark">�������</a>�̂��鑺�ł��B�D�݂̕ʂ��ꍇ������܂��̂ŁA�܂����̏�񗓂��J���ē��e���m�F���܂��傤�B
</p>

<h3>��W���^�J�n�҂�$linkrss</h3>

_HTML_

	# ��W���^�J�n�҂����̕\��
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'prologue');

	print <<"_HTML_";
<h3>�i�s��</h3>

_HTML_

	# �i�s���̑��̕\��
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'playing');

	$reqvals->{'cmd'} = 'oldlog';
	$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	# ���΂炭�A�I���������̈ꗗ���B���B
	if (1) {
	print <<"_HTML_";
<h3>�I���ς�</h3>

<p class="paragraph">
<a href="$urlsow?$linkvalue">�I���ς݂̑�</a>
</p>
<hr class="invisible_hr"$net>

_HTML_
	}

	my $linkvmake = '<input type="submit" value="���̍쐬">';
	my $vcnt          = $sow->{'cfg'}->{'MAX_VILLAGES'} - $vindex->getactivevcnt() ;
	my $caution_vmake = ' <span class="infotext">����'.$vcnt.'�������Ă��܂��B</span>';

	$caution_vmake = ' <span class="infotext">�����쐬����ꍇ�̓��O�C�����ĉ������B</span>' if ($sow->{'user'}->logined() <= 0);
	if ($vcnt <= 0) {
		$linkvmake = '<input type="submit" value="���̍쐬" disabled>';
		$caution_vmake = ' <span class="infotext">���݉ғ����̑��̐�������ɒB���Ă���̂ŁA�����쐬�ł��܂���B</span>';
	}

	my $defaulttrsid = $sow->{'trsid'};
	my $defaulttextrs = $sow->{'textrs'};
	my $trsidlist = $sow->{'cfg'}->{'TRSIDLIST'};
	if ($sow->{'cfg'}->{'ENABLED_VMAKE'} > 0) {

		print <<"_HTML_";
<h2>���̌��ĕ�</h2>
<p class="paragraph">
�܂�<a href="$urlsow?$linkrule#make">�����Đl�̐S�\\��</a>�A<a href="$linkmake">�����ă}�j���A��</a>��ǂ�ł��瑺�����Ă悤�B<br>
���Q�l�F<a href="$urlsow?$linkrolematrix">��E�z���ꗗ</a>�b<a href="$linkroledeal">�Ґ�����</a>�b<a href="$linkscedure">��摺�\\��\\</a>�iwiki�Fstin����Ǘ��j<br>
<a href="sow.cgi?cmd=trsdiff">��{�ݒ�</a>��I��Łu���̍쐬�v�������ƁA�V�����Q�[�����쐬�ł���B
</p>
<script>
go_make = function(){
  return(0 < \$("#yes_i_read_it:checked").length);
}
</script>
<dl class="paragraph">
<dt> �֗���<a href="$linkscedure">��摺�\\��\\</a>�͂��������H���Ă����ɐl���W�܂肻�����ǂ����A\�\\�z�ł��邩������Ȃ���B
<dd> <input type="checkbox" id="yes_i_read_it"> ������I������A���𗧂Ă��I
</dl>

<div class="paragraph">
<form action="$urlsow" method="get" id="make_vil_form" onsubmit="return go_make()">
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
$linkvmake$caution_vmake<br$net>
</form>
</div>

_HTML_
		$sow->{'trsid'} = $defaulttrsid;
		$sow->{'textrs'} = $defaulttextrs;
	}
	print <<"_HTML_";
<hr class="invisible_hr"$net>

<h2>�L�����N�^�[�摜�ꗗ</h2>
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

<h2>�Q�[�����ł̕���</h2>
<p class="paragraph">
�@�Q�[�����Ō���镶�͂̈ꗗ�����邱�Ƃ��ł��܂��B�Q�l�ɂǂ����B
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
<input type="submit" value="���͂�����">
</form>
</p>

_HTML_

	print <<"_HTML_";

<h2>�ӎ�</h2>
<p class="paragraph">
����CGI���쐬����ɕӂ�A�ȉ��̃T�C�g���Q�l�ɂ����Ē����܂����B���肪�Ƃ��������܂��B
</p>

<ul>
  <li>�l�T�R�� - Neighbour Wolves - (�I��)</li>
  <li>The Village of Headless Knight (�ꎞ�x�~��)</li>
  <li>���Ƃ��̍��̐l�T�i���B <a href="http://euros.sakura.ne.jp/wolf/">�����܂�</a>�j</li>
  <li><!-- a href="http://werewolves.jp/" -->�l�T�̈��� (��)<!-- /a --></li>
  <li><a href="http://homepage2.nifty.com/ninjinia/">�l�TBBS</a></li>
  <li><a href="http://wolfbbs.jp/">�l�TBBS �܂Ƃ߃T�C�g</a></li>
  <li><a href="http://mshe.skr.jp/">�l�TBBQ �l��</a></li>
  <li><a href="http://shadow.s63.xrea.com/jinro2/index.cgi">���͐l�T�Ȃ��HShadow Gallery Ver 2.0</a></li>
  <li><a href="http://melon-cirrus.sakura.ne.jp/sow/">�l�T���� �Z�ȍ�</a></li>
  <li><a href="http://www3.marimo.or.jp/~fgmaster/cabala/sow.cgi">�l�T���� ������Ă��߂���</a></li>
  <li><a href="http://o8o8.o0o0.jp/wolf/sow.cgi">�l�T����Í���</a></li>
  <li><a href="http://tkingdom.dtdns.net/m_jinro/index.html">���r�E�X�l�T</a></li>
  <li><a href="http://straws.sakura.ne.jp/madb01/">MAD PEOPLE</a></li>
  <li><a href="http://members.at.infoseek.co.jp/Paranoia_O/">PARANOIA O</a></li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

	$vindex->closevindex();
	print "</DIV>";
	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# �G���e�B�e�B�^�O�̐���
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
