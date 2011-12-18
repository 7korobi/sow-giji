package SWCmdModify;

#----------------------------------------
# �����̏C��
#----------------------------------------
sub CmdModify {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# ������������
	my $writepl = &SWBase::GetCurrentPl($sow, $vil);
	&SWWrite::ExecuteCmdWrite($sow, $vil, $writepl);
	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "WriteSay. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");
	}
	$vil->closevil();

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

	$sow->{'http'}->{'location'} = "$link";
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'http'}->outfooter();
}

1;