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

	print <<"_HTML_";
<div class="login" template="navi/headline"></div>
_HTML_
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	&SWHtmlPC::OutHTMLGonInit($sow); # ���O�C�����̏o��
	print <<"_HTML_";
\$(function(){\$('.finished_log').hide()});
</script>
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


	my $linkvmake = '<input type="submit"  class="btn" value="���̍쐬">';
	my $vcnt          = $sow->{'cfg'}->{'MAX_VILLAGES'} - $vindex->getactivevcnt() ;
	my $caution_vmake = '����'.$vcnt.'�������Ă��܂��B';

	$caution_vmake = ' <span class="infotext">�����쐬����ꍇ�̓��O�C�����ĉ������B</span>' if ($sow->{'user'}->logined() <= 0);
	if ($vcnt <= 0) {
		$linkvmake = '<input type="submit"  class="btn" value="���̍쐬" disabled>';
		$caution_vmake = ' <span class="infotext">���݉ғ����̑��̐�������ɒB���Ă���̂ŁA�����쐬�ł��܂���B</span>';
	}

	my $defaulttrsid = $sow->{'trsid'};
	my $defaulttextrs = $sow->{'textrs'};
	my $trsidlist = $sow->{'cfg'}->{'TRSIDLIST'};


	my $license = 'https://github.com/7korobi/sow-giji/blob/master/cabala/license.txt';

	my $link_state_page  = $cfg->{'URL_CONFIG'};
	my $enabled_bitty    = ($cfg->{'ENABLED_BITTY'}            )?('�Ђ炪�Ȃ̂�'):('��b���e�̂�');
	my $enabled_aiming    = ($cfg->{'ENABLED_AIMING'} eq 1     )?('�쐬�ł���'):('�쐬�ł��Ȃ�');
	my $enabled_undead     = ($cfg->{'ENABLED_UNDEAD'} eq 1    )?('�쐬�ł���'):('�쐬�ł��Ȃ�');
	my $enabled_ambidexter  = ($cfg->{'ENABLED_AMBIDEXTER'}    )?('���؂�̐w�c'):('�l�T�w�c');
	my $enabled_permit_dead  = ($cfg->{'ENABLED_PERMIT_DEAD'}  )?('������'):('�����Ȃ�');
	my $enabled_winner_label  = ($cfg->{'ENABLED_WINNER_LABEL'})?('������'):('�����Ȃ�');

	print <<"_HTML_";
<dl class="accordion">
<dt>���̏B�̐ݒ�</dt>
<dd>
���̏B�ł́A�p������$cfg->{'TIMEOUT_SCRAP'}���A
�����b�̑���$enabled_aiming�A
���l��$enabled_ambidexter�A
�H�E�g�[�N����$enabled_undead�A
�G�s���[�O�ŏ��s��$enabled_winner_label�A
���񂾂��ƒ��Ԃ̚�����$enabled_permit_dead�B
������~��҂ɕ�������̂�$enabled_bitty�B
���H�Ō�����͉̂�b���e�̂݁B<br>
[<a href="$link_state_page">���킵������</a>]

<dt> �Ή��u���E�U
<dd>
<p>�����̃u���E�U�œ���m�F�ς݂ł��B</p>
<ul>
<li>Internet Explorer : 9 �ȍ~ 
<br>�i�X�N���[�������d���A�Ƃ����Ǐ󂪏o��悤�ł��j
<li>Firefox : 20.0 �ȍ~
<li>Chrome : 26.0 �ȍ~
<li>Safari : 6.0.3 �ȍ~
<li>iOS : 5.1.1 �ȍ~
<li>Android : 2.2.1 �ȍ~
</ul>

</dl>

<hr class="invisible_hr"$net>

<h2><a name="welcome">$cfg->{'NAME_SW'}�ւ悤����</a></h2>
<div class="paragraph">
<ol type="1">
<li><a href="$urlsow?cmd=about">$cfg->{'NAME_SW'}�Ƃ́H</a>
<li><a href="$urlsow?$linkvalue">�V�ѕ�</a>�A<a href="$urlwiki$linkoperate">������@</a>�A<a href="$urlsow?$linkrule">���[���ƐS�\\��</a>���悭�ǂ����B
<li><a href="http://crazy-crazy.sakura.ne.jp/giji/"><img src="$urlimg/banner/guide.png"></a>
<br>�l�T�Q�[���̊�{�I�Ȓm���A�l�T�c���Ǝ��V�X�e���̐����́A�����܂Ƃ߃T�C�g�Œm�낤�B
<li>���̐l�T�N���[����V�񂾎��̂��邫�݂́A�܂�<a href="$urlwiki$linkspec">���̐l�T�Q�[���Ƃ̈Ⴂ</a>��ǂ����B�����̂��Ƃ������ɏ�����Ă���B
<li>���A�ׂ��������ɂ��Ēm�肽���Ƃ��́A<a href="http://crazy-crazy.sakura.ne.jp/giji/">�d�l�ύX</a>���Q�l�ɂ��悤�B
<li>�Ȃɂ�����V�яꂩ�킩�����H����������A�������ɑ�������B
</ol>
</div>

<hr class="invisible_hr"$net>

<h2><a name="deploy">�����đO</a></h2>
<dl class="paragraph">
<dt><strong><a href="{{link.plan}}">��摺\�\\��\�\\</a></strong>�iwiki�Fstin����Ǘ��j
<dd>���ꂩ��n�܂鑺�̗\\�肪����ł���B���[���v���C���[�K�������B
</dl>
<dl class="paragraph">
<dt><strong><a href="http://crazy-crazy.sakura.ne.jp/giji_lobby/lobby/sow.cgi?vid=11#mode=talk_all_open&navi=link">�����đ��k��</a></strong>
<dd>�V�т������̑��k������ꏊ�B���������э��ނƂ����B
</dl>

<dl class="accordion">
<dt> �����ăc�[��
<dd>

�܂�<a href="$urlsow?$linkrule#make">�����Đl�̐S�\\��</a>�A<a href="$linkmake">�����ă}�j���A��</a>��ǂ�ł��瑺�����Ă悤�B<br>

<ul>
<li>�Q�l�F<a href="$urlsow?$linkrolematrix">��E�z���ꗗ</a>
<li>�Q�l�F<a href="http://crazy-crazy.sakura.ne.jp/giji/?(List)SayCnt">����pt��</a>�̈ꗗ<br>
<li>$caution_vmake
</ul>
_HTML_
	if ($sow->{'cfg'}->{'ENABLED_VMAKE'} > 0) {
		print <<"_HTML_";
<p>
<a href="sow.cgi?cmd=trsdiff">��{�ݒ�</a>��I��Łu���̍쐬�v�������ƁA�V�����Q�[�����쐬�ł���B
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
<dt> �Q���҃c�[��
<dd>

<p class="mark">�Q�[�����ł̕���</p>
�Q�[�����Ō���镶�͂̈ꗗ�����邱�Ƃ��ł��܂��B�Q�l�ɂǂ����B
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
<input type="submit"  class="btn" value="���͂�����">
</form>

<hr class="invisible_hr"$net>

<p class="mark">�L�����N�^�[�摜�ꗗ</p>
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
<h2>���̈ꗗ</h2>
<div class="paragraph">
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
<img src="$cfg->{'DIR_IMG'}/icon/cd_biohazard.png">
�}�[�N�̕t�������́A<a href="$linkmake#mark">�������</a>�̂��鑺�ł��B�D�݂̕ʂ��ꍇ������܂��̂ŁA�܂����̏�񗓂��J���ē��e���m�F���܂��傤�B

<dl>
<dt><a href="sow.cgi?cmd=rule">���[���ƐS�\\��</a>������āA�y�����A�����V�ڂ��B
<dd><a href="sow.cgi?cmd=rule">�Q���҂̃��[��</a>�ƐS�\\���A�����āA<a href="sow.cgi?cmd=rule#make">�����Đl�̐S�\\��</a>�͂����ɂ���B
</dl>
</div>

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

	print <<"_HTML_";
<h3>�I���ς�</h3>

<div class="paragraph">
<a href="$urlsow?$linkvalue">�I���ς݂̑�</a>
</div>
<hr class="invisible_hr"$net>

<hr class="invisible_hr"$net>

<h2>�Z�p���</h2>

<dl class="accordion">
<dt> �v���O����
<dd>
<ul>
<li><a href="https://github.com/7korobi/sow-giji">�ŐV�Ł@�l�T�c���T�C�g�v���O����</a>
<li><a href="https://github.com/7korobi/giji_rails">�ߋ����O�{���T�C�g�v���O����</a>
<li>���C�Z���X��<a href="$license">�C���ς�BSD���C�Z���X</a>�ƂȂ��Ă��܂��B�i���Ƀo�O��蒆�B
</ul>
<dt> �ӎ�
<dd>
<p> 
�쐬�ɂ�����A������̃T�C�g���Q�l�ɂ����Ă��������܂����B<br>
���肪�Ƃ��������܂��B
</p>
<ul>
  <li>�l�T�R�� - Neighbour Wolves - (�I��)</li>
  <li>The Village of Headless Knight (�ꎞ�x�~��)</li>
  <li>���Ƃ��̍��̐l�T�i���B �����܂��j</li>
  <li>�l�T�̈��� (��)</li>
  <li>���͐l�T�Ȃ��HShadow Gallery Ver 2.0�i�I���j</li>
  <li>MAD PEOPLE�i�I���j</li>
  <li><a href="http://ninjinix.com/">�l�TBBS</a></li>
  <li><a href="http://wolfbbs.jp/">�l�TBBS �܂Ƃ߃T�C�g</a></li>
  <li><a href="http://mshe.skr.jp/">�l�TBBQ �l��</a></li>
  <li><a href="http://melon-cirrus.sakura.ne.jp/sow/">�l�T���� �Z�ȍ�</a></li>
  <li><a href="http://www3.marimo.or.jp/~fgmaster/cabala/sow.cgi">�l�T���� ������Ă��߂���</a></li>
  <li><a href="http://o8o8.o0o0.jp/wolf/sow.cgi">�l�T����Í���</a></li>
  <li><a href="http://tkido.com/m_jinro/index.html">���r�E�X�l�T</a></li>
  <li><a href="http://trpg.scenecritique.com/Paranoia_O/">PARANOIA O</a></li>
</ul>
</dl>
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
