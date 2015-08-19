package SWCmdLogout;

#----------------------------------------
# ���O�A�E�g
#----------------------------------------
sub CmdLogout {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# ���C�u�����̓ǂݍ���
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_pc.pl";

	# �f�[�^����
	&SetDataCmdLogout($sow);
	$sow->{'uid'} = "";

	# HTML���[�h�̏�����
	$sow->{'html'} = SWHtml->new($sow, "javascript");
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# HTTP�w�b�_�EHTML�w�b�_�̏o��
	my $outhttp = $sow->{'http'}->outheader();
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('js');

	&SWHtmlPC::OutHTMLGonInit($sow);
	print "\n</script>\n";

	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
	return;
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdLogout {
	my $sow = $_[0];
	my $query  = $sow->{'query'};

	if ($sow->{'user'}->logined() > 0) {
		# ���O�C�����Ă���΃��O�A�E�g����
		$sow->{'user'}->resetcookie($sow->{'setcookie'});
		$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Logout. [$sow->{'uid'}]");
	}

	return;
}

1;
