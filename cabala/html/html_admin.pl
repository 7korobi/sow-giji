package SWHtmlAdminManager;

#----------------------------------------
# �Ǘ���ʃ��j���[��HTML�o��
#----------------------------------------
sub OutHTMLAdminManager {
	my $sow   = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	require "$cfg->{'DIR_HTML'}/html.pl";
	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('�Ǘ����'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	$reqvals->{'cmd'} = 'restrec';
	my $linkrecord = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'restviform';
	my $linkvi = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'movevil';
	my $linkmovevil = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<h2>�Ǘ���ʃ��j���[</h2>
<ul class="paragraph">
  <li><a href="$urlsow?$linkrecord">��т̍č\\�z</a></li>
  <li><a href="$urlsow?$linkvi">���ꗗ�̍č\\�z</a></li>
</ul>

<ul class="paragraph">
  <li><a href="$urlsow?$linkmovevil">���f�[�^�̈ړ�</a></li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;
