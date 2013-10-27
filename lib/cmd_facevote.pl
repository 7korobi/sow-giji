package SWCmdFaceVote;

#----------------------------------------
# ユーザー情報表示
#----------------------------------------
sub CmdFaceVote {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# 村編集処理
	&SetDataCmdFaceVote($sow);

	$query->{'cmd'}  = 'chrlist';
	my $link = &SWBase::GetLinkValues($sow, $query)."&csid=".$query->{'csid'};
	$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link";

	$sow->{'http'}->{'location'} = "$link";
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'http'}->outfooter();
}

#----------------------------------------
# ユーザー情報編集処理
#----------------------------------------
sub SetDataCmdFaceVote {
	my $sow  = shift;
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$debug->raise($sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0); # 通常起きない

	# ユーザー情報の更新
	my $user = SWUser->new($sow);
	$user->{'uid'} = $sow->{'uid'};
	$user->openuser(1);
	if ($query->{'cid'} ne ''){
		if ($query->{'sex'} eq 'F' ){
			$user->{'faceF3'} = $user->{'faceF2'};
			$user->{'faceF2'} = $user->{'faceF1'};
			$user->{'faceF1'} = $query->{'cid'};
			$user->{'faceM3'} = '' if ( $user->{'faceM3'} eq $query->{'cid'} );
			$user->{'faceM2'} = '' if ( $user->{'faceM2'} eq $query->{'cid'} );
			$user->{'faceM1'} = '' if ( $user->{'faceM1'} eq $query->{'cid'} );
		} else {
			$user->{'faceM3'} = $user->{'faceM2'};
			$user->{'faceM2'} = $user->{'faceM1'};
			$user->{'faceM1'} = $query->{'cid'};
			$user->{'faceF3'} = '' if ( $user->{'faceF3'} eq $query->{'cid'} );
			$user->{'faceF2'} = '' if ( $user->{'faceF2'} eq $query->{'cid'} );
			$user->{'faceF1'} = '' if ( $user->{'faceF1'} eq $query->{'cid'} );
		}
		if ( $user->{'faceF1'} eq '' ) {$user->{'faceF1'} = $user->{'faceF2'}; $user->{'faceF2'} = ''; }
		if ( $user->{'faceF2'} eq '' ) {$user->{'faceF2'} = $user->{'faceF3'}; $user->{'faceF3'} = ''; }
		if ( $user->{'faceM1'} eq '' ) {$user->{'faceM1'} = $user->{'faceM2'}; $user->{'faceM2'} = ''; }
		if ( $user->{'faceM2'} eq '' ) {$user->{'faceM2'} = $user->{'faceM3'}; $user->{'faceM3'} = ''; }
		$user->writeuser();
	}
	$user->closeuser();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Edit Profile. [uid=$sow->{'uid'}]");

	return;
}

1;