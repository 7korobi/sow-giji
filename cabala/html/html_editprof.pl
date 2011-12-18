package SWHtmlEditProfile;

#----------------------------------------
# ���[�U�[���ҏW������ʂ�HTML�o��
#----------------------------------------
sub OutHTMLEditProfile { 
	my $sow = shift;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader("���[�U�[���ҏW����($sow->{'uid'})"); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'prof'} = $sow->{'uid'};
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C���{�^���\��

	print <<"_HTML_";
<h2>���[�U�[���ҏW����</h2>

<p class="info"><a href="$urlsow?$linkvalue">$sow->{'uid'}</a>����̃��[�U�[�����X�V���܂����B</p>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;