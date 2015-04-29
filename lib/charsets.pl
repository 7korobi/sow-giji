package SWCharsets;

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow => $sow,
	};

	return bless($self, $class);
}

#----------------------------------------
# キャラセットの読み込み
#----------------------------------------
sub loadchrrs {
	my ($self, $csid) = @_;
	my $sow = $self->{'sow'};

	# 読み込み済みなら何もしない
	return if (defined($self->{'csid'}->{$csid}->{'CAPTION'}));

	my $fname = "$sow->{'cfg'}->{'DIR_RS'}/crs_$csid.pl";
	$sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, "キャラクタセット $csid が見つかりません。", "csid not found.[$csid]") if (!(-e $fname));

	require "$fname";
	my $sub = '::SWResource_' . $csid . '::GetRSChr';
	my $charset = &$sub($sow);
	$self->{'csid'}->{$csid} = $charset;

	# 読み込み済みなら何もしない
	return if (defined($self->{'tag'}));

	require "$sow->{'cfg'}->{'DIR_RS'}/tag.pl"; 
	my $tagset = &SWResource_TAG::GetTag($sow);
	$self->{'tag'} = $tagset;
	return;
}

#----------------------------------------
# キャラ名の取得
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
# 短縮キャラ名の取得
# getshortchrname($csid, $cid)
#----------------------------------------
sub getshortchrname {
	my ($self, $csid, $cid, $middlename, $postfix) = @_;

	$self->loadchrrs($csid) if (!defined($self->{'csid'}->{$csid}->{'CHRNAME'}));
	return "$middlename$self->{'csid'}->{$csid}->{'CHRNAME'}->{$cid}$postfix";
}


1;