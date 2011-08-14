package SWHtmlScore;

#----------------------------------------
# �l�T���̏o��
#----------------------------------------
sub OutHTMLScore {
	my $sow = $_[0];
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	require "$cfg->{'DIR_LIB'}/score.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/dtd_plaintext.pl";

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���̃T�[�o�ł͐l�T���o�͖͂����ɂȂ��Ă��܂��B", "disabled output score") if ($cfg->{'ENABLED_SCORE'} == 0);

	# ���f�[�^�̓ǂݍ���
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�܂������I�����Ă��܂���B", "no winner.") if ($vil->{'turn'} < $vil->{'epilogue'});
	$vil->closevil();

	my $score = SWScore->new($sow, $vil, 0);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�l�T���f�[�^��������܂���B", "no score.") if (!defined($score->{'file'}));

	$sow->{'html'} = SWHtml->new($sow, 'plain'); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader(''); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	$score->output();
	$score->close();

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;
