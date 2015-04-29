package SWCharsets;

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow => $sow,
	};

	return bless($self, $class);
}

#----------------------------------------
# �L�����Z�b�g�̓ǂݍ���
#----------------------------------------
sub loadchrrs {
	my ($self, $csid) = @_;
	my $sow = $self->{'sow'};

	# �ǂݍ��ݍς݂Ȃ牽�����Ȃ�
	return if (defined($self->{'csid'}->{$csid}->{'CAPTION'}));

	my $fname = "$sow->{'cfg'}->{'DIR_RS'}/crs_$csid.pl";
	$sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, "�L�����N�^�Z�b�g $csid ��������܂���B", "csid not found.[$csid]") if (!(-e $fname));

	require "$fname";
	my $sub = '::SWResource_' . $csid . '::GetRSChr';
	my $charset = &$sub($sow);
	$self->{'csid'}->{$csid} = $charset;

	# �ǂݍ��ݍς݂Ȃ牽�����Ȃ�
	return if (defined($self->{'tag'}));

	require "$sow->{'cfg'}->{'DIR_RS'}/tag.pl"; 
	my $tagset = &SWResource_TAG::GetTag($sow);
	$self->{'tag'} = $tagset;
	return;
}

#----------------------------------------
# �L�������̎擾
# getchrname($csid, $cid)
#----------------------------------------
sub getchrname {
	my ($self, $csid, $cid, $newjobname, $middlename, $postfix) = @_;

	$self->loadchrrs($csid) if (!defined($self->{'csid'}->{$csid}->{'CHRNAME'}));
	my $jobname = $self->{'csid'}->{$csid}->{'CHRJOB'}->{$cid};
	$jobname = $newjobname if ((defined($newjobname)) && ($newjobname ne ''));
	return "$jobname $middlename$self->{'csid'}->{$csid}->{'CHRNAME'}->{$cid}$postfix";
}

#----------------------------------------
# �Z�k�L�������̎擾
# getshortchrname($csid, $cid)
#----------------------------------------
sub getshortchrname {
	my ($self, $csid, $cid, $middlename, $postfix) = @_;

	$self->loadchrrs($csid) if (!defined($self->{'csid'}->{$csid}->{'CHRNAME'}));
	return "$middlename$self->{'csid'}->{$csid}->{'CHRNAME'}->{$cid}$postfix";
}


1;