package SWCmdChrList;

#----------------------------------------
# �L�����ꗗ�\��
#----------------------------------------
sub CmdChrList {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_chrlist.pl";
	my $title = &SWHtmlChrList::GetHTMLChrListTitle();

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader($title); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C���{�^��

	# �L�����ꗗ��ʂ�HTML�o��
	&SWHtmlChrList::OutHTMLChrList($sow);

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	$sow->{'html'}->outcontentfooter('');
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

}

1;