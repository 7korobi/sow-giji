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
</script>
<h2 style="font-size: xx-large;">$cfg->{'NAME_HOME'}</h2>
_HTML_

	# �B���Љ�
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


	my $linkvmake = '<input type="submit"  class="btn" value="���̍쐬">';
	my $vcnt          = $sow->{'cfg'}->{'MAX_VILLAGES'} - $vindex->getactivevcnt() ;
	my $caution_vmake = '����'.$vcnt.'�������Ă��܂��B';

	$caution_vmake = '�����쐬����ꍇ�̓��O�C�����ĉ������B' if ($sow->{'user'}->logined() <= 0);
	if ($vcnt <= 0) {
		$linkvmake = '<input type="submit"  class="btn" value="���̍쐬" disabled>';
		$caution_vmake = '���݉ғ����̑��̐�������ɒB���Ă���̂ŁA�����쐬�ł��܂���B';
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
<script>
var hello;
if (new Date % (24*3600000) - 9 * 3600000 < 0) {
  hello = "����ɂ���";
}else{
  hello = "����΂��";
}

gon.oldlog = [
{ mesicon:'',
  name:'����� �W���[�W',
  text:'���̉�����B����<a class="mark" href="$urlsow?cmd=oldlog">�I��������</a>�̋L�^�������Ă���B\\
�Â��ɁA�Ђ�����ƂˁB',
updated_at: new Date(1389008975000),template:"message/say",mestype:"TSAY",csid:"all",face_id:"c76"},
];

gon.guide = [
{ name:'�e�B���V�[',
  text:'�i���j�������Ə�݁A�c�Ƃ��ĊJ�����B<br><a href="http://crazy-crazy.sakura.ne.jp/giji/"><img src="$urlimg/banner/guide.png"></a>',
updated_at: new Date(1389008975000),template:"message/action",mestype:"SAY"},
{ mesicon:'',
  name:'�G�݉� �e�B���V�[',
  text: '��������Ⴂ�B$cfg->{'NAME_SW'}�̂��Ƃ�m�肽���񂾂ˁB����Ȃ�A�l�T�c�������K�C�h�u�b�N���J���Ă����B<br>\\
���邢�́A�ق��̃����N��������߂��ȁB<br>\\
<br>\\
<ul>\\
<li><a class="mark" href="$urlsow?cmd=about">���Љ�</a>���������A�ǂ��������̂Ȃ񂾂낤\\
<li><a class="mark" href="$urlsow?cmd=howto">�V�ѕ�</a>�Q������I���܂ł̗��ꂪ�m�肽��\\
<li><a class="mark" href="$urlwiki$linkoperate">������@</a>�v���C���̏ڂ��������m�肽��\\
</ul>',
updated_at: new Date(1389008975000),template:"message/say",mestype:"SAY",csid:"all",face_id:"c07"},
{ mesicon:'',
  name:'�Ԕ��� ���A���[',
  text: hello + '�B�������Ȃ����A�ǂ����Ől�T�Q�[����V�񂾎�������Ȃ�A<a class="mark" href="$urlwiki$linkspec">���̐l�T�Q�[���Ƃ̈Ⴂ</a>���ǂ����B<br>\\
����Ƃ����ו��H�������炨�D���Ȉ�ւ��B<br><br>\\
<ul>\\
<li><a class="mark" href="$urlsow?cmd=roleaspect&trsid=all">��E�Ɣ\\�͂̈ꗗ\�\\</a>�𒲂ׂ�B\\
<li><a class="mark" href="$urlsow?cmd=rolelist">��E���Ƃ̃C���^�[�t�F�[�X</a>�𒲂ׂ�B\\
</ul>',
updated_at: new Date(1389008975000),template:"message/say",mestype:"SAY",csid:"all",face_id:"c01"},
];

gon.rule = [
{ mesicon:'',
  name:'�w�� ���I�i���h',
  text:'<a href="sow.cgi?cmd=rule" class="mark">���[���ƐS�\\��</a>������āA�y�����A�����V�ڂ��B<br>\\
�����ł́A�݂�ȂɎ���Ăق������[����A�ᖡ���Ăق����S�\\�����Љ���B<br>\\
�ł́A�����N��̂P�y�[�W�ڂ���\�\\�\\�\ ',
updated_at: new Date(1389008975000),template:"message/say",mestype:"SAY",csid:"all",face_id:"c96",style:"head"},
];

gon.setting = [
{ mesicon:'�y�ԁz',
  name:'�V���z�B �����X', to:'�H',
  text:'<a class="mark" href="$link_state_page">���킵������</a>�͂������B�킩�邩�H�c�܂��ȁB<br>\\
<ul>\\
<li>�p��������$cfg->{'TIMEOUT_SCRAP'}����\\
<li>�����b�̑���$enabled_aiming\\
<li>���l��$enabled_ambidexter\\
<li>�H�E�g�[�N����$enabled_undead\\
<li>�G�s���[�O�ŏ��s��$enabled_winner_label\\
<li>���񂾂��ƒ��Ԃ̚�����$enabled_permit_dead\\
<li>������~��҂ɕ�������̂�$enabled_bitty\\
<li>���H�Ō�����͉̂�b���e�̂�\\
</ul>',
updated_at: new Date(1370662886000),template:"message/aim",mestype:"WSAY",csid:"all",face_id:"c95"},
{ name:'�V���z�B �����X',
  text:'�l�ڂ�����ċ����Ă������c�B',
updated_at: new Date(1370662886000),template:"message/action",mestype:"WSAY"}
];

gon.browsers = [
{ mesicon:'�y�l�z',
  name:'�X�� �\\�t�B�A',
  text:'�����̃u���E�U�œ���m�F�ς݂ł��B\\
<br><ul>\\
<li>Internet Explorer : 9 �ȍ~\\
<li>Firefox : 20.0 �ȍ~\\
<li>Opera 12.15 �ȍ~\\
<li>Safari : 6.0.3 �ȍ~\\
<li>iOS : 5.1.1 �ȍ~\\
<li>Chrome : 26.0 �ȍ~\\
<li>Android : 2.2.1 �ȍ~\\
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
		$csidname =~ s/�i/<br>/g;
		$csidname =~ s/�E�Z�b�g�u/<br>/g;
		$csidname =~ s/�j//g;
		$csidname =~ s/�v//g;

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

<dt>�I��������
<dd class="plain">
<div class="message_filter" ng-repeat="message in oldlog" log="message"></div>

<dt>�v���C�K�C�h
<dd class="plain">
<div class="message_filter" ng-repeat="message in guide" log="message"></div>

</dl>

<h2>����I��</h2>
<div class="message_filter" ng-repeat="message in rule" log="message"></div>


<dl class="accordion">
<dt> <span class="mark"> &#x2718; </span>

<dt>�L�����N�^�[�摜�ꗗ
<dd class="plain">
<div class="chrlist">
<p>�L�����N�^�[��I�ԎQ�l�ɁA<a class="mark" href="http://giji.check.jp/map_reduce/faces">�l�C�x�W�v</a>���`�F�b�N���Ă����������ˁB</p>
<div style="font-size:80%; line-height:120%;" template="navi/chr_list">
</div></div>
<dt>���̏B�̐ݒ�
<dd class="plain">
<div class="message_filter" ng-repeat="message in setting" log="message"></div>
</dl>

<h3>��W���^�J�n�҂�$linkrss</h3>
<div class="paragraph">
<img src="$cfg->{'DIR_IMG'}/icon/key.png">
�}�[�N�̕t�������́A�Q���Ƀp�X���[�h���K�v�ł��B<br$net>
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
�}�[�N�́A<a href="$linkmake#mark">�������</a>�̂��鑺�ɂ��Ă��܂��B�܂����̏����悭�ǂ�ŁA�D�݂̂�������I�т܂��傤�B
</div>
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

<h3>�ʂ̃T�C�g����T��</h3>

<dl class="paragraph">

<dt><a class="mark" href="http://giji.check.jp/">�l�T�c�������g�b�v</a>
<dd>�l�T�c���S�̂̉ߋ����O�A��W���̑��̈ꗗ�ȂǁB

<dt><a class="mark" href="{{link.plan}}">��摺\�\\��\�\\</a>�iwiki�Fstin����Ǘ��j
<dd>���ꂩ��n�܂鑺�̗\\�肪����ł���B�D�݂̑������邩���ˁB

<dt><a class="mark" href="http://melon-cirrus.sakura.ne.jp/wiki/?%A5%B5%A1%BC%A5%D0%A1%BC%A5%EA%A5%B9%A5%C8">�l�T����Server�ꗗ</a>
<dd>�u�l�T����v�V���[�Y�̃T�C�g�ɂ��Ă܂Ƃ߂Ă���B

<dt><a class="mark" href="http://melon-cirrus.sakura.ne.jp/wiki/">�l�T�����pwiki</a>�iwiki�Fmelonko����Ǘ��j
<dd>�u�l�T����v�X�N���v�g�𗘗p���ĉ^�c����Ă��鍑�̂��߂̑���wiki�B

</dl>

<h3>�����ő�������</h3>
<div class="ng-scope ng-binding"><div class="VSAY"><div class="action">
_HTML_
	if ( $sow->{'cfg'}->{'ENABLED_VMAKE'} > 0 ) {
		if ('CIEL' eq $cfg->{'RULE'}){
			print <<"_HTML_";
<p class="text">
�֗���<a class="mark" href="{{link.plan}}">��摺�\\��\\</a>�͂��������H���Ă����ɐl���W�܂肻�����ǂ����A\�\\�z�ł��邩������Ȃ���B<br>
</p>
<h6><input type="checkbox" ng-model="yes_i_read_it"> ������I������A���𗧂Ă��I</h6>
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
<p class="text">��{�ݒ�i���j��I�сu���̍쐬�v���������B</p>
</div>
_HTML_
	}
	print <<"_HTML_";
</div></div></div>
<dl class="paragraph">
<dt><a class="mark" href="http://crazy-crazy.sakura.ne.jp/giji_lobby/lobby/sow.cgi?vid=11#mode=talk_all_open&navi=info">�����đ��k��</a>
<dd>�V�т������̑��k������ꏊ�B���������э��ނƂ����B

<dt><a class="mark" href="$linkmake">�����ă}�j���A��</a>
<dd>�����ő������Ă�菇��l�����̉���B

<dt><a class="mark" href="$urlsow?$linkrolematrix">��E�z���ꗗ</a>
<dd>��E�z�����V�X�e���C���ɂ���Ƃ��̎Q�l�ɁB

<dt><a class="mark" href="$linksaycnt">����pt�ʂ̈ꗗ</a>
<dd>���Ŏg������pt�̐ݒ���e�ɂ��āA�ڂ����ꗗ�\

<dt>�Q�[�����ł̕���
<dd>
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

</dl>


<h2>�Z�p���</h2>

<dl class="accordion">
<dt> <span class="mark"> &#x2718; </span>
<dt> �Ή��u���E�U
<dd class="plain">
<div class="message_filter" ng-repeat="message in browsers" log="message"></div>
<dt> �v���O����
<dd>
<ul>
<li><a href="https://github.com/7korobi/sow-giji/tree/angular">�ŐV�Ł@�l�T�c���T�C�g �v���O����</a>
<li><a href="https://github.com/7korobi/sow-giji/releases">�_�E�����[�h �y�[�W</a>
<li><a href="https://github.com/7korobi/giji_rails/tree/renewal">�l�T�c�� �����g�b�v�Ajavascript�Astylesheet</a>
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
  <li><a href="http://scpjapan.wiki.fc2.com">The SCP Foundation</a></li>
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
