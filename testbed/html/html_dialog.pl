package SWHtmlDialog;

#----------------------------------------
# �m�F��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLDialog {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

	# ���f�[�^�̓ǂݍ���
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	my %dialog = (
		cmd => 'none',
	);
	if ($query->{'cmd'} eq 'exitpr') {
		%dialog = (
			cmd => 'exit',
			text => '������o�܂����H',
			buttoncaption => '������o��',
		);
	} elsif ($query->{'cmd'} eq 'kickpr') {
		$target     = $vil->getplbypno($query->{'target'});
		$targetname = $target->getchrname();
		%dialog = (
			cmd => 'kick',
			text => $targetname.' �ɁA�ދ����������܂����H',
			buttoncaption => '������ދ���������',
		);
	} elsif ($query->{'cmd'} eq 'makerpr') {
		$target     = $vil->getplbypno($query->{'target'});
		$targetname = $target->getchrname();
		%dialog = (
			cmd => 'maker',
			text => $targetname.' �ɁA�����Č���������܂����H���Ȃ��͑����Ă̌��������ׂĎ����܂��B',
			buttoncaption => '�����Č�������',
		);
	} elsif ($query->{'cmd'} eq 'musterpr') {
		my $upddatetime = sprintf('%02d:%02d',$vil->{'updhour'},$vil->{'updminite'});
		%dialog = (
			cmd => 'muster',
			text => '�_�Ă��J�n���܂����H�_�Ă��J�n����ƁA�����ǑS���̔��������񐔂��[���ɂ��܂��B<br>�������[���̂܂܁A�X�V����('.$upddatetime.')���}�����Q���҂́A������ދ����܂��B',
			buttoncaption => '���l��_�Ă���',
		);
	} elsif ($query->{'cmd'} eq 'startpr') {
		%dialog = (
			cmd => 'start',
			text => '�����J�n���܂����H',
			buttoncaption => '�J�n',
		);
	} elsif ($query->{'cmd'} eq 'updatepr') {
		%dialog = (
			cmd => 'update',
			text => '�����X�V���܂����H',
			buttoncaption => '�X�V',
		);
	} elsif ($query->{'cmd'} eq 'extendpr') {
		%dialog = (
			cmd => 'extend',
			text => '���̍X�V�������A����������܂����H�i����'.$vil->{'extend'}.'��j',
			buttoncaption => '����',
		);
	} elsif ($query->{'cmd'} eq 'scrapvilpr') {
		%dialog = (
			cmd => 'scrapvil',
			text => '�p�����܂����H',
			buttoncaption => '�p��',
		);
	}

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "����`�̍s���ł��B","invalid cmd.") if ($dialog{'cmd'} eq 'none');

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader('���̏��'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();
	my $net = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow) if ($sow->{'outmode'} ne 'mb');

	# ���t�ʃ��O�ւ̃����N
	if ($sow->{'outmode'} eq 'mb') {
		print "$sow->{'query'}->{'vid'} $vil->{'vname'}<br$net>\n";
		&SWHtmlMb::OutHTMLReturnVilMb($sow, $vil, 0);
		print "<hr$net>\n";
	} else {
		&SWHtmlPC::OutHTMLTurnNavi($sow, $vil);
	}

	my @reqkeys = ('csid_cid', 'role', 'mes', 'think', 'wolf', 'maker', 'admin', 'target');
	my $reqvals = &SWBase::GetRequestValues($sow, \@reqkeys);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	if ($sow->{'outmode'} eq 'mb') {
		print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
<p>$dialog{'text'}<br$net></p>

<p>
<input type="hidden" name="cmd" value="$dialog{'cmd'}"$net>$hidden
<input type="submit" value="$dialog{'buttoncaption'}"$net>
</p>
</form>
_HTML_
	} else {
		print <<"_HTML_";
<h2>�s���m�F</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$dialog{'text'}</p>

<p class="paragraph">
  <input type="hidden" name="cmd" value="$dialog{'cmd'}"$net>$hidden
  <input type="submit" value="$dialog{'buttoncaption'}"$net>
</p>
</form>
_HTML_
	}

	if ($sow->{'outmode'} eq 'mb') {
		print "<hr$net>\n";
		&SWHtmlMb::OutHTMLReturnVilMb($sow, $vil, 1);
	} else {
		&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�
	}

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;