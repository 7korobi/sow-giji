package SWHtmlNoReady;

#----------------------------------------
# ��������HTML�o��
#----------------------------------------
sub OutHTMLNoReady {
	my ($sow, $noregist) = @_;
	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_HTML'}/html.pl";

	my $noregistname = "�Ǘ��l�pID";
	$noregistname = "�_�~�[�L�����pID" if ($noregist == 2);
	my $noregistid = "$noregistname�i$sow->{'cfg'}->{'USERID_ADMIN'}�j";
	$noregistid = "$noregistname�i$sow->{'cfg'}->{'USERID_NPC'}�j" if ($noregist == 2);

	# HTTP/HTML�̏o��
	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader('������'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��
	my $net = $sow->{'html'}->{'net'}; # Null End Tag

	print <<"_HTML_";
<h2>$noregistname���܂��o�^����Ă��܂���</h2>
<p class="paragraph">
$noregistid�����o�^�ł��B<br$net>
�E��̃��O�C�����ŐV�K�쐬���ĉ������B
</p>
<hr class="invisible_hr"$net>

_HTML_

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;
