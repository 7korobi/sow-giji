package SWHtmlOldLog;

#----------------------------------------
# �I���ς݂̑��ꗗ��HTML�o��
#----------------------------------------
sub OutHTMLOldLog {
	my $sow = $_[0];

	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_LIB'}/file_vindex.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_vindex.pl";


	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('�I���ς݂̑��̈ꗗ'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();
	print "<DIV class=toppage>";
	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��
	&SWHtmlPC::OutHTMLChangeCSS($sow);
	&SWHtmlPC::OutHTMLGonInit($sow); # ���O�C�����̏o��

	# ���ꗗ�f�[�^�ǂݍ���
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'oldlog'); # �I���ςݑ��̕\��
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'dispose'); # �I���ςݑ��̕\��
	$vindex->closevindex();

	print <<"_HTML_";
</script>
<h2>�I���ς݂̑��̈ꗗ</h2>
<div id="oldlog"></div>
<h2>�p���̈ꗗ</h2>
<div id="dispose"></div>
_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�
	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;
