package SWCmdProfile;

#----------------------------------------
# ユーザー情報表示
#----------------------------------------
sub CmdProfile {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};

	# 戦績集計処理
	my ($recordlist, $totalrecord, $camps, $roles) = &SumUserRecord($sow);

	# ユーザー情報のHTML出力
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_profile.pl";
	&SWHtmlProfile::OutHTMLProfile($sow, $recordlist, $totalrecord, $camps, $roles);
}

#----------------------------------------
# 戦績集計処理
#----------------------------------------
sub SumUserRecord {
	my $sow  = shift;
	my $query  = $sow->{'query'};
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_record.pl";

	my @camps;
	my $campcount;
	for ($campcount = 0; $campcount <= $sow->{'COUNT_CAMP'}; $campcount++) {
		push (@camps, &NewRecordHash());
	}

	my @roles;
	my $rolecount;
	for ($rolecount = 0; $rolecount < $sow->{'COUNT_ROLE'}; $rolecount++) {
		push (@roles, &NewRecordHash());
	}

	my $record;
	my @recordlist;
	my $recordlist = \@recordlist;
	my $totalrecord = &NewRecordHash();

	if (-w $sow->{'cfg'}->{'DIR_RECORD'}) {
		$record = SWUserRecord->new($sow, $query->{'prof'});
		$record->close();

		$recordlist = $record->{'file'}->getlist();
		foreach (@$recordlist) {
			next if ($_->{'win'} <= 0);
			next if ($_->{'live'} eq 'suddendead'); # 突然死は集計対象外

			# 総合戦績集計
			&AddRecordSingle($totalrecord, $_);

			# 陣営別戦績集計
			&AddRecordSingle($camps[$sow->{'ROLECAMP'}[$_->{'role'}]], $_);

			# 役職別戦績集計
			&AddRecordSingle($roles[$_->{'role'}], $_);
		}
	}

	return ($recordlist, $totalrecord, \@camps, \@roles);
}

#----------------------------------------
# 戦績集計用ハッシュの取得
#----------------------------------------
sub NewRecordHash {
	my %recordhash = (
		win       => 0,
		lose      => 0,
		draw      => 0,
		total     => 0,
		livecount => 0,
		liveday   => 0,
	);
	return \%recordhash;
}

#----------------------------------------
# 戦績集計（陣営別／役職別）
#----------------------------------------
sub AddRecordSingle {
	my ($data, $record) = @_;

	$data->{'total'}++;
	$data->{'win'}++   if ($record->{'win'} == 1);
	$data->{'lose'}++  if ($record->{'win'} == 2);
	$data->{'draw'}++  if ($record->{'win'} == 0);
	$data->{'livecount'}++ if ($record->{'live'} eq 'live');
	$data->{'liveday'} += $record->{'liveday'};
}

1;