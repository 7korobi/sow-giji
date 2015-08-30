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

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	print "<DIV class=toppage>";
	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��
	&SWHtmlPC::OutHTMLChangeCSS($sow);
	&SWHtmlPC::OutHTMLGonInit($sow); # ���O�C�����̏o��

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

	my $imgrating = '';
	my $rating = $cfg->{'RATING'};
	my $ratingorder = $rating->{'ORDER'};
	foreach (@$ratingorder) {
		$imgrating .= "<img src=\"$cfg->{'DIR_IMG'}/$rating->{$_}->{'FILE'}\" width=\"$rating->{$_}->{'WIDTH'}\" height=\"$rating->{$_}->{'HEIGHT'}\" alt=\"[$rating->{$_}->{'ALT'}]\" title=\"$rating->{$_}->{'CAPTION'}\"$net> " if ($rating->{$_}->{'FILE'} ne '');
	}

	my $linkrss = " <a tabindex=\"-1\" href=\"$urlsow?cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);


	my $linkvmake = '<input type="submit"  class="btn edge" value="���̍쐬">';
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
var hello;
var now = new Date() - 0;
if (now % (24*3600000) - 9 * 3600000 < 0) {
  hello = "����ɂ���";
}else{
  hello = "����΂��";
}

gon.items = [
{ _id: "title-head-h2-1",
  log: "$cfg->{'NAME_HOME'}",
updated_at: now },

{ _id: "title-talk-TSAY-3",
  name:'����� �W���[�W',
  log:'���̉�����B����<a class="btn edge" href="$urlsow?cmd=oldlog">�I��������</a>�̋L�^�������Ă���B\\
�Â��ɁA�Ђ�����ƂˁB',
updated_at: now,face_id:"c76"},

{ _id: "title-talk-SAY-99",
  name:'�Ԕ��� ���A���[',
  log: hello + '�B�������Ȃ����A�ǂ����Ől�T�Q�[����V�񂾎�������Ȃ�A<a class="btn edge" href="$urlwiki$linkspec">���̐l�T�Q�[���Ƃ̈Ⴂ</a>���ǂ����B<br>\\
����Ƃ����ו��H�������炨�D���Ȉ�ւ��B<br><br>\\
<ul class="text">\\
<li><a class="btn edge" href="$urlsow?cmd=roleaspect&trsid=all">��E�Ɣ\\�͂̈ꗗ\�\\</a>�𒲂ׂ�B\\
<li><a class="btn edge" href="$urlsow?cmd=rolelist">��E���Ƃ̃C���^�[�t�F�[�X</a>�𒲂ׂ�B\\
</ul>',
updated_at: now,face_id:"c01"},

{ _id: "play-talk-WSAY-14",
  name:'�V���z�B �����X', to:'�H',
  log:'<a class="btn edge" href="$link_state_page">���킵������</a>�͂������B�킩�邩�H�c�܂��ȁB<br>\\
<ul class="text">\\
<li>�p��������$cfg->{'TIMEOUT_SCRAP'}����\\
<li>�����b�̑���$enabled_aiming\\
<li>���l��$enabled_ambidexter\\
<li>�H�E�g�[�N����$enabled_undead\\
<li>�G�s���[�O�ŏ��s��$enabled_winner_label\\
<li>���񂾂��ƒ��Ԃ̚�����$enabled_permit_dead\\
<li>������~��҂ɕ�������̂�$enabled_bitty\\
<li>���H�Ō�����͉̂�b���e�̂�\\
</ul>',
updated_at: now,face_id:"c95"},

{ _id: "play-action-WSAY-15",
  name:'�V���z�B �����X',
  log:'�l�ڂ�����ċ����Ă������c�B',
updated_at: now},

{ _id: "play-head-h3-16",
  log: '��W���^�J�n�҂�$linkrss',
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

<div class="message_filter" id="item-title"></div>
<div class="message_filter" id="item-play"></div>

<div class="chrlist">
<div template="navi/chr_list">
</div></div>
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
<div class="message_filter" id="item-create"></div>

<div class="VSAY action">
_HTML_
	if ( $sow->{'cfg'}->{'ENABLED_VMAKE'} > 0 ) {
		if ('CHEAT' eq $cfg->{'TYPE'}){
			print <<"_HTML_";
<p class="text">
�֗���<a class="btn edge" href="{{link.plan}}">��摺�\\��\\</a>�͂��������H���Ă����ɐl���W�܂肻�����ǂ����A\�\\�z�ł��邩������Ȃ���B<br>
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
<p class="text">��{�ݒ�i���j��I�сu���̍쐬�v���������B</p>
</div>
_HTML_
	}
	print <<"_HTML_";
</div>
<dl class="TSAY paragraph">
<dt><a class="btn edge" href="http://crazy-crazy.sakura.ne.jp/giji_lobby/lobby/sow.cgi?vid=11#mode=talk_all_open&navi=info">�����đ��k��</a>
<dd>�V�т������̑��k������ꏊ�B���������э��ނƂ����B

<dt><a class="btn edge" href="$linkmake">�����ă}�j���A��</a>
<dd>�����ő������Ă�菇��l�����̉���B

<dt><a class="btn edge" href="$urlsow?$linkrolematrix">��E�z���ꗗ</a>
<dd>��E�z�����V�X�e���C���ɂ���Ƃ��̎Q�l�ɁB

<dt><a class="btn edge" href="$linksaycnt">����pt�ʂ̈ꗗ</a>
<dd>���Ŏg������pt�̐ݒ���e�ɂ��āA�ڂ����ꗗ�\\

<dt>�Q�[�����ł̕���
<dd>
�Q�[�����Ō���镶�͂̈ꗗ�����邱�Ƃ��ł��܂��B�Q�l�ɂǂ����B
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
<input type="submit"  class="btn edge" value="���͂�����">
</form>

</dl>

<div class="message_filter" id="item-tech"></div>
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
