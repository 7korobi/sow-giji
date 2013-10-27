package SWHtmlDebugVillage;

#----------------------------------------
# ���f�[�^��HTML�o��
#----------------------------------------
sub OutHTMLDebugVillage {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();

	require "$cfg->{'DIR_HTML'}/html.pl";
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader("$vil->{'vid'}���̃f�[�^"); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	print <<"_HTML_";
<h2>$vil->{'vid'}���̃f�[�^</h2>

<ul>
_HTML_

	my @villabel = &SWFileVil::GetVilDataLabel();
	foreach (@villabel) {
		print "<li>$_: $vil->{$_}</li>\n";
	}

	print <<"_HTML_";
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
