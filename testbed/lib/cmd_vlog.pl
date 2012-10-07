package SWCmdVLog;

#----------------------------------------
# �����O�\��
#----------------------------------------
sub CmdVLog {
	my $sow = $_[0];

	# �f�[�^����
	my $vil = &SetDataCmdVLog($sow);

	# HTML�o��
	&OutHTMLCmdVLog($sow, $vil);
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdVLog {
	my $sow = shift;
	my $query = $sow->{'query'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

	# �����m�菈��
	if ($vil->{'epilogue'} >= $vil->{'turn'}) {
		my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
		$logfile->fixque(0); # �ʏ�m��
		$logfile->close();
	}

	# �X�V����
	&CheckUpdateSession($sow, $vil);

	my $curpl = $sow->{'curpl'};
	$sow->{'savedraft'} = '';
	$sow->{'draftmestype'} = 0;
	$sow->{'draftmspace'} = 0;
	if ((defined($curpl->{'savedraft'})) && ($curpl->{'savedraft'} ne '')) {
		$sow->{'savedraft'}    = $curpl->{'savedraft'};
		$sow->{'draftmestype'} = $curpl->{'draftmestype'};
		$sow->{'draftmspace'}  = $curpl->{'draftmspace'};
		$curpl->{'savedraft'} = '';
		$curpl->{'modified'} = $sow->{'time'};
		$vil->writevil();
	}
	return $vil;
}

#----------------------------------------
# HTML�o��
#----------------------------------------
sub OutHTMLCmdVLog {
	my ($sow, $vil) = @_;
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};
	my $cookie = $sow->{'cookie'};
	my $ua     = $sow->{'outmode'};

	# HTML�o�͗p���C�u�����̓ǂݍ���
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_vlog.pl";

	my $turn = $sow->{'turn'};
	$turn = $vil->{'epilogue'} if ($sow->{'turn'} > $vil->{'epilogue'}); # �I�����Ă��鎞�͏I����

	# �����O�t�@�C�����J��
	my $logfile = SWBoa->new($sow, $vil, $turn, 0);

	$sow->{'cookie'}->{'modified'} = 'js' if (!defined($sow->{'cookie'}->{'modified'}));

	# �X�V���̐���
	my $updcookiedt = &SetHTTPUpdateVLog($sow, $vil, $logfile);
	if ((!defined($sow->{'cookie'}->{'modified'})) || ($sow->{'cookie'}->{'modified'} ne 'js')) {
		$sow->{'http'}->setnotmodified();
	}

	# �����t�B���^�p�N�b�L�[�f�[�^����
	my $pllist = $vil->getallpllist();
	my $setcookie = $sow->{'setcookie'};
	my $cookie = $sow->{'cookie'};
	$setcookie->{'lastmodified'} = sprintf("%x", $sow->{'time'}) if (($updcookiedt > 0) || ($cookie->{'modified'} ne 'cgi') || (!defined($cookie->{'lastmodified'})));
	$setcookie->{'modified'} = 'cgi';
	$setcookie->{'layoutfilter'} = 0 if (!defined($cookie->{'layoutfilter'}));
	$setcookie->{'fixedfilter'} = 0 if (!defined($cookie->{'fixedfilter'}));
	foreach (@$pllist) {
		$sow->{'filter'}->{'pnofilter'}->[$_->{'pno'}] = 0 if (!defined($sow->{'filter'}->{'pnofilter'}->[$_->{'pno'}]));
	}

	# �^�C�g���̎擾
	my $title = &SWHtmlVlog::GetHTMLVlogTitle($sow, $vil);

	# HTML���[�h�̏�����
	$sow->{'html'} = SWHtml->new($sow);
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	# link�v�f�o�͊֘A
	&SetLinkElements($sow, $vil);

	# JavaScript�̐ݒ�
	$sow->{'html'}->{'file_js'} = $sow->{'cfg'}->{'FILE_JS_VIL'};

	# HTTP�w�b�_�EHTML�w�b�_�̏o��
	my $outhttp = $sow->{'http'}->outheader();
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader($title);

	# �\���s���̐ݒ�
	my $maxrow = $sow->{'cfg'}->{'MAX_ROW'}; # �W���s��
	$maxrow = $cookie->{'row'} if (defined($cookie->{'row'}) && ($cookie->{'row'} ne '')); # �����ɂ��s���w��
	$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne '')); # �����ɂ��S�\���w��

	# ���O�̎擾
	my ($logs, $logkeys, $rows);
	if (($sow->{'turn'} != $vil->{'turn'}) || ($vil->{'epilogue'} >= $vil->{'turn'})) {
		($logs, $logkeys, $rows) = $logfile->getvlogs($maxrow);
	}
	$sow->{'lock'}->gunlock();

	# HTML�̏o��
	if ($ua eq 'mb') {
		require "$cfg->{'DIR_HTML'}/html_vlog_mb.pl";
		&SWHtmlVlogMb::OutHTMLVlogMb($sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows);
	} else {
		require "$cfg->{'DIR_HTML'}/html_vlog_pc.pl";
		require "$cfg->{'DIR_HTML'}/html_sayfilter.pl";
		&SWHtmlVlogPC::OutHTMLVlogPC($sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows);
	}
	$logfile->close();

	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
}

#----------------------------------------
# �X�V����
#----------------------------------------
sub CheckUpdateSession {
	my ($sow, $vil) = @_;
	my $pllist = $vil->getpllist();

	return if ($vil->{'epilogue'} < $vil->{'turn'}); #�I���ς�

	# �R�~�b�g�l���̃`�F�b�N
	my $committablepl = $vil->getcommittablepl();
	my $committedpl   = $vil->getcommittedpl();

	my $isupdate = 0;
	$isupdate = 1 if ( $vil->{'nextupdatedt'} <= $sow->{'time'}); # �X�V���Ԃ����Ă���
	$isupdate = 2 if (($vil->{'nextcommitdt'} <= $sow->{'time'}) && ($committablepl == $committedpl) && ($committablepl > 0)); # �S�������Ԃ�i�߂Ă���

	my $scrap = 0;
	$scrap = 1 if (($vil->{'scraplimitdt'} != 0) && ($sow->{'time'} >= $vil->{'scraplimitdt'}) && ($vil->{'turn'} == 0)); # �p���������߂��Ă���

	if ($vil->{'turn'} == 0) {
		# ��������������
		my @exitpl;
		my $allpllist = $vil->getallpllist();
		foreach (@$allpllist) {
			next if ($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
			next if ($_->{'limitentrydt'} <= 0);
			my $kick = 0;
			$kick=1 if ( $_->{'limitentrydt'} <  $sow->{'time'});
			$kick=1 if (($_->{'live'} eq 'live')&&($_->{'saidcount'}==0)&&($isupdate==1));
			push(@exitpl, $_) if ($kick);
#			&SWBase::ExitVillage($sow, $vil, $_, $logfile);
		}

		if (@exitpl > 0) {
			require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
			require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
			my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
			foreach(@exitpl) {
				&SWBase::ExitVillage($sow, $vil, $_, $logfile);
			}
			$logfile->close();
			$vil->writevil();
			$vil->readvil();
		}
	}

	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	if ($isupdate == 0) { # ���X�V
		if ($vil->{'nextchargedt'} < $sow->{'time'}) {
			# ��������
			$vil->chargesaycountall() if (($vil->{'turn'} > 0 )&&( $saycnt->{'RECOVERY'} > 0 ));

#			$vil->{'nextchargedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
			$vil->{'nextchargedt'} += 24 * 60 * 60;
			$vil->writevil();
		}
		# �X�V�����łȂ���΁A�����ŏ����I���
		return;
	}

	if ($vil->{'turn'} == 0) {
		if (($vil->{'starttype'} eq 'wbbs')&&($vil->isstartable())) {
			# ���J�n�i�l�TBBS�^�j
			my ($lastupdtime, $basedt) = $sow->{'dt'}->getlastupdatedt($vil, $sow->{'time'});
			my $savetime = $sow->{'time'};
			$sow->{'time'} = $lastupdtime;
			require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
			&SWCommit::StartSession($sow, $vil, 0);
			$sow->{'time'} = $savetime;
		} else {
			if ($scrap > 0) {
				# �p��
				my ($lastupdtime, $basedt) = $sow->{'dt'}->getlastupdatedt($vil, $sow->{'time'});
				my $savetime = $sow->{'time'};
				$sow->{'time'} = $lastupdtime;
				require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
				&SWCommit::UpdateSession($sow, $vil, 0, 1);
				$sow->{'time'} = $savetime;
			} else {
				# �X�V�\�莞�Ԃ̉���
				$vil->{'nextupdatedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
				$vil->writevil();

				# ������ꉄ���\��
				if ($vil->{'starttype'} eq 'wbbs') {
					require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
					require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
					my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
					$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $sow->{'textrs'}->{'ANNOUNCE_EXTENSION'});
					$logfile->close();
				}
			}
		}
	} else {
		# ���X�V
		my $savetime = $sow->{'time'};
		if ($isupdate == 1) {
			my ($lastupdtime, $basedt) = $sow->{'dt'}->getlastupdatedt($vil, $sow->{'time'});
			$sow->{'time'} = $lastupdtime;
		}

		require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
		&SWCommit::UpdateSession($sow, $vil, $isupdate - 1, 0);
		$sow->{'time'} = $savetime;
	}

	return;
}

#----------------------------------------
# �G���e�B�e�B�^�O�̐���
#----------------------------------------
sub SetHTTPUpdateVLog {
	my ($sow, $vil, $logfile) = @_;
	my $curpl = $sow->{'curpl'};

	my $cookiedt = '';
	my $updcookiedt = 1;
	if (($sow->{'cookie'}->{'modified'} eq 'cgi') && (defined($sow->{'cookie'}->{'lastmodified'}))) {
		my $etagcookiedt = 0;
		if (defined($ENV{'HTTP_IF_NONE_MATCH'})) {
			my $requestetag = $ENV{'HTTP_IF_NONE_MATCH'};
			$requestetag =~ s/^\"//;
			$requestetag =~ s/\"$//;
			my @etags = split(/-/, $requestetag . '-');
			$etagcookiedt = $etags[2] if ((defined($etags[2])) && ($etags[2] ne ''));
		}
		if (hex($sow->{'cookie'}->{'lastmodified'}) >= hex($etagcookiedt)) {
			$cookiedt = $sow->{'cookie'}->{'lastmodified'};
			$updcookiedt = 0;
		}
	}
	$cookiedt = sprintf("%x", $sow->{'time'}) if ($cookiedt eq '');

	my $wisperrole = '';
	my $wispergift = '';
	if(defined($curpl)){
		$wisperrole = $curpl->rolesayswitch($vil);
		$wispergift = $curpl->giftsayswitch($vil);
	}

	my $modified = $vil->{'modifiedsay'};
	if (defined($curpl)) {
		$modified = $vil->{'modifiedvsay'} if (($curpl->{'live'} eq 'mob')  && ($modified < $vil->{'modifiedgsay'})); # ���҂̂��߂�
		$modified = $vil->{'modifiedgsay'} if (($curpl->{'live'} ne 'live') && ($modified < $vil->{'modifiedgsay'})); # ���҂̂��߂�
		if (($curpl->{'live'} eq 'live') || ($sow->{'cfg'}->{'ENABLED_PERMIT_DEAD'} > 0)) {
			# �����₫
			$modified = $vil->{'modifiedwsay'}  if (($wisperrole eq 'wolf')     && ($modified < $vil->{'modifiedwsay'}));
			$modified = $vil->{'modifiedwsay'}  if (($wispergift eq 'wolf')     && ($modified < $vil->{'modifiedwsay'}));
			# ����
			$modified = $vil->{'modifiedspsay'} if (($wisperrole eq 'sympathy') && ($modified < $vil->{'modifiedspsay'}));
			$modified = $vil->{'modifiedspsay'} if (($wispergift eq 'sympathy') && ($modified < $vil->{'modifiedspsay'}));
			# �O�b
			$modified = $vil->{'modifiedxsay'}  if (($wisperrole eq 'pixi')     && ($modified < $vil->{'modifiedxsay'}));
			$modified = $vil->{'modifiedxsay'}  if (($wispergift eq 'pixi')     && ($modified < $vil->{'modifiedxsay'}));
		}

		$modified = $curpl->{'modified'} if ($modified < $curpl->{'modified'});
	}

	my $etag = '-';
	my $user = $sow->{'user'};
	if ($user->logined() > 0) {
		my $uid = &SWBase::EncodeURL($sow->{'uid'});
		$etag = sprintf("%s-", $uid);
	}
	$etag .= sprintf("vlog%d-%s", $vil->{'turn'}, $cookiedt);
	$sow->{'http'}->{'etag'} = $etag;

	$sow->{'http'}->{'lastmodified'} = $modified;
	return $updcookiedt;
}

#----------------------------------------
# link�v�f�o�͊֘A
#----------------------------------------
sub SetLinkElements {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $amp = $sow->{'html'}->{'amp'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
	my @links = ();

	# �O�̓��ւ̈ړ�
	my $prevday = $sow->{'turn'} - 1;
	if ($prevday >= 0) {
		my %prev = (
			rel   => 'Prev',
			title => '�O�̓�',
			url   => "$link$amp" . "turn=$prevday",
		);
		push(@links, \%prev);
	}

	# ���̓��ւ̈ړ�
	my $nextday = $sow->{'turn'} + 1;
	if ($nextday <= $vil->{'turn'}) {
		my %next = (
			rel   => 'Next',
			title => '���̓�',
			url   => "$link$amp" . "turn=$nextday",
		);
		push(@links, \%next);
	}

	$sow->{'html'}->{'links'} = \@links;
	$sow->{'html'}->{'rss'} = "$link$amp" . "cmd=rss";
}

1;
