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

{ _id: "title-talk-SAY-9",
  name:'�Ԕ��� ���A���[',
  log: hello + '�B�������Ȃ����A�ǂ����Ől�T�Q�[����V�񂾎�������Ȃ�A<a class="btn edge" href="$urlwiki$linkspec">���̐l�T�Q�[���Ƃ̈Ⴂ</a>���ǂ����B<br>\\
����Ƃ����ו��H�������炨�D���Ȉ�ւ��B<br><br>\\
<ul class="text">\\
<li><a class="btn edge" href="$urlsow?cmd=roleaspect&trsid=all">��E�Ɣ\\�͂̈ꗗ\�\\</a>�𒲂ׂ�B\\
<li><a class="btn edge" href="$urlsow?cmd=rolelist">��E���Ƃ̃C���^�[�t�F�[�X</a>�𒲂ׂ�B\\
</ul>',
updated_at: now,face_id:"c01"},

{ _id: "title-talk-WSAY-17",
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

{ _id: "title-head-h3-19",
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
	print <<"_HTML_";
</script>
<div class="message_filter" id="item-title"></div>
_HTML_

	# ��W���^�J�n�҂����̕\��
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'prologue');
	# �i�s���̑��̕\��
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'playing');

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
