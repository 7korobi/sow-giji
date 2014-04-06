package SWHtmlPreviewMb;

#----------------------------------------
# �����v���r���[�i���o�C���jHTML�̕\��
#----------------------------------------
sub OutHTMLPreviewMb {
	my ($sow, $vil, $log, $preview) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html_vlog_mb.pl";

	# �X�V���Ԃ̎擾
	my $date = sprintf("%02d:%02d", $vil->{'updhour'}, $vil->{'updminite'});

	# �͂ݏo�������̏���
	my $srcmes = $log->{'log'}; # �폜�O�̔���
	$srcmes =~ s/(<br( \/)?>)*$//ig;

	my $trimedlog = &SWString::GetTrimString($sow, $vil, $srcmes);
	my $len = length($trimedlog);
	$log->{'log'} = substr($srcmes, 0, $len);
	my $deletedmes = substr($srcmes, $len);
	$log->{'log'} .= "<font color=\"gray\">$deletedmes</font>";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('�v���r���['); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	print <<"_HTML_";
$query->{'vid'} $vil->{'vname'}<br$net>
<hr$net>
�����̃v���r���[<br$net>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

	# �딚����
	my $curpl = &SWBase::GetCurrentPl($sow, $vil);
	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);
	if ((&SWBase::CheckWriteSafetyRole($sow, $vil) > 0) && ($que > 0) && ($vil->isepilogue() == 0)) {
		print <<"_HTML_";
���̔����͒ʏ픭���ł��B�����~�X�ɒ��ӁI<br$net>
<input type="checkbox" name="safety" value="on"$net>�ʏ픭���ŊԈႢ�Ȃ���΃`�F�b�N<br$net>
_HTML_
	}

	# ���������̕\��
	my %logids = (
		rowover => 1,
	);
	&SWHtmlVlogMb::OutHTMLSingleLogMb($sow, $vil, $log, \%logids, -1, 0);

	# �����l����
#	$query->{'mes'} =~ s/<br( \/)?>/&#13\;/ig;
	$query->{'mes'} =~ s/<br( \/)?>/\[\[br\]\]/ig;
	my @reqkeys = (
		'csid_cid', 
		'role', 
		'mes', 
		'think', 
		'wolf', 
		'maker', 
		'muppet', 
		'admin', 
		'sympathy', 
		'pixi', 
		'monospace', 
		'expression', 
		'target'
	);

	# �p�X���[�h�����ł́A������p�X���[�h�𒆌p����B
	push(@reqkeys, 'entrypwd') if ($vil->{'entrylimit'} eq 'password');

	my $reqvals = &SWBase::GetRequestValues($sow, \@reqkeys);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	# �s���̎擾
	my @lineslog = split('<br>', $srcmes);
	my $lineslogcount = @lineslog;

	# �������̎擾
	my $countsrc = &SWString::GetCountStr($sow, $vil, $srcmes);
	my $countmes = &SWString::GetCountStr($sow, $vil, $trimedlog);

	# �s���^�����������x��
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	if ($lineslogcount > $saycnt->{'MAX_MESLINE'}) {
		print "�s�����������܂��i$lineslogcount�s�j�B$saycnt->{'MAX_MESLINE'}�s�ȓ��Ɏ��߂Ȃ��Ɛ������������܂�܂���B<hr$net>\n";
	} elsif ($countsrc > $saycnt->{'MAX_MESCNT'}) {
		my $unitcaution = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COST_SAY'}}->{'UNIT_CAUTION'};
		print "�������������܂��i$countsrc$unitcaution�j�B$countmes$unitcaution�ȓ��Ɏ��߂Ȃ��Ɛ������������܂�܂���B<hr$net>\n";
	}

	# �����ɂ���ď�����pt���̕\��
#	my $point = &SWBase::GetSayPoint($sow, $vil, $log->{'log'});
	my $point = &SWBase::GetSayPoint($sow, $vil, $trimedlog);
	my ($mestype, $saytype, $pttype, $modified, $que, $writepl, $targetpl, $chrname, $cost) = $curpl->GetMesType($sow, $vil);
	my $unitsay = $sow->{'basictrs'}->{'SAYTEXT'}->{$cost}->{'UNIT_SAY'};
	my $pointtext = '';
	if (($cost eq 'point') && ($sow->{'query'}->{'cmd'} ne 'entrypr') && (defined($sow->{'curpl'}->{$saytype}))) {
		$pointtext = "�i$point$unitsay���� / ����$sow->{'curpl'}->{$saytype}$unitsay�j";
	}

	# �����{�^���̕\��
	print <<"_HTML_";
������������݂܂����H$pointtext<br$net>
<input type="hidden" name="cmd" value="$preview->{'cmd'}"$net>
<input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
<input type="submit" value="��������"$net>
</form>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM_MB'}">
<input type="hidden" name="cmd" value="$preview->{'cmdfrom'}"$net>
<input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
<input type="submit" value="�߂�"$net>
</form>
_HTML_

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;
