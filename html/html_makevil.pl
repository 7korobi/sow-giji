package SWHtmlMakeVil;

#----------------------------------------
# ���쐬������ʂ�HTML�o��
#----------------------------------------
sub OutHTMLMakeVil {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_vinfo_pc.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_formpl_pc.pl";

	my $vmode = '�쐬';
	my $infotext = '���쐬';
	if ($sow->{'query'}->{'cmd'} eq 'editvil') {
		$vmode = '�ҏW';
		$infotext = '�̐ݒ��ύX';
	}

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader("$vmode����"); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C���{�^���\��
    &SWHtmlPC::OutHTMLChangeCSS($sow);

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = $query->{'vid'};
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	&SWHtmlPC::OutHTMLGonInit($sow); # ���O�C�����̏o��
	$vil->gon_story();
	$vil->gon_event();
	$vil->gon_potofs();
	# �����Đl�t�H�[���^�Ǘ��l�t�H�[���\��
	if ($sow->{'user'}->logined() > 0) {
		if ($vil->{'makeruid'} eq $sow->{'uid'}) {
			&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
		}
		if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}) {
			&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
			&SWHtmlPlayerFormPC::OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
		}
	}
	print <<"_HTML_";
</script>
<h2>$vmode����</h2>

<p class="info"><a href="$urlsow?$linkvalue">$query->{'vid'} $query->{'vname'}</a>$infotext���܂����B</p>

_HTML_

	# ���f�[�^�̓ǂݍ���
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();

	&SWHtmlVilInfo::OutHTMLVilInfoInner($sow,$vil);

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�


	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;