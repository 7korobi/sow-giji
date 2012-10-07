package SWBoa;

#----------------------------------------
# SWBBS Log Driver Library 'SW-Boa'
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $turn, $mode) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log_data.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log_idx.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log_cnt.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log_que.pl";

	my $self = {
		sow    => $sow,
		vil      => $vil,
		turn     => $turn,
		version  => ' 2.1',
		startpos => 0,
	};
	bless($self, $class);

	if ($turn < 0) {
		$self->{'dummy'} = 1;
		return $self ;
	}
	# ���O�t�@�C���̐V�K�쐬�^�J��
	$self->{'logfile'} = SWBoaLog->new($sow, $vil, $turn, $mode);

	if ($sow->{'query'}->{'cmd'} eq 'restruct') {
		# �C���f�b�N�X�t�@�C���̍č\�z
		$self->{'logindex'} = SWBoaLogIndex->new($sow, $vil, $turn, 1);
		$self->restructure();
		$self->{'logindex'}->{'file'}->close();
#		$self->{'logindex'}->{'file_last'}->close();

#		$self->{'logcnt'} = SWBoaLogCount->new($sow, $vil, $turn, 1);
	}

	# ���O�C���f�b�N�X�t�@�C���̐V�K�쐬�^�J��
	$self->{'logindex'} = SWBoaLogIndex->new($sow, $vil, $turn, $mode);
	# ���O�J�E���g�t�@�C���̐V�K�쐬�^�J��
	$self->{'logcnt'} = SWBoaLogCount->new($sow, $vil, $turn, $mode);
	# �L���[�t�@�C���̐V�K�쐬�^�J��
	$self->{'que'} = SWBoaQue->new($sow, $vil, $turn, $mode);

	return $self;
}

#----------------------------------------
# �t�@�C�������
#----------------------------------------
sub close {
	my $self = shift;

	return if ($self->{'dummy'} ==  1);
	$self->{'logfile'}->{'file'}->close();
	$self->{'logindex'}->{'file'}->close();
#	$self->{'logindex'}->{'file_last'}->close();
	$self->{'logcnt'}->{'file'}->close();
	$self->{'que'}->{'file'}->close();
}

#----------------------------------------
# ���O�f�[�^�̓ǂݍ���
#----------------------------------------
sub read {
	my ($self, $pos, $logpermit) = @_;
	return if ($self->{'dummy'} ==  1);

	my $data = $self->{'logfile'}->{'file'}->read($pos);
	if( 7 <  $logpermit  ){
		my $sow = $self->{'sow'};
		$data->{'mestype'} = $sow->{'MESTYPE_INFOSP'};
		$data->{'chrname'} = '�H';
		$data->{'cid'} = '';
	}
	if( 9 == $logpermit  ){
# �̂����݌n���e�}�X�N
		my $log = '';
		my $exp = '';
		my $exp_sw = 0;
		while( $data->{'log'} =~ /(\x82[\x9F-\xF1])+|(<br>)|(\[.*?\])|(.)/g ) {
			if ( defined($4)|| defined($3) ){
				if ($exp_sw){
					$exp_sw = 0 ;
					$exp = '�c' ;
				} else {
					$exp = '' ;
				}
			} else {
				$exp = $& ;
				$exp_sw = 1;
			}
			$log .= $exp;
		}
		$data->{'log'} = $log;
	}

	return $data;
}

#----------------------------------------
# ���O�f�[�^�̒ǉ�
#----------------------------------------
sub add {
	my ($self, $log) = @_;
	return if ($self->{'dummy'} ==  1);

	$self->setip($log);
	$self->{'logfile'}->{'file'}->add($log);
	$self->addlogidx($log);
}

#----------------------------------------
# ���O�f�[�^�̍X�V
#----------------------------------------
sub update {
	my ($self, $log, $indexno) = @_;
	return if ($self->{'dummy'} ==  1);

	$self->{'logfile'}->{'file'}->update($log);
	my $logidx = $self->{'logindex'}->set($log);
	$self->{'logindex'}->{'file'}->update($logidx, $indexno);
#	$self->{'logindex'}->{'file_last'}->update($logidx, $indexno);
}

#----------------------------------------
# �C���f�b�N�X�f�[�^�̍č\�z
#----------------------------------------
sub restructure {
	my $self = shift;
	return if ($self->{'dummy'} ==  1);

	my $logfile = $self->{'logfile'}->{'file'};
	$self->{'logindex'}->{'file'}->clear();

	my $pos = $logfile->{'startpos'};
	my $log = $logfile->read($pos);
	while (defined($log->{'uid'})) {
		$self->addlogidx($log, 1);
		$pos = $log->{'nextpos'};
		$log = $logfile->read($pos);
	}
	$self->{'logindex'}->{'file'}->write();
}

#----------------------------------------
# �C���f�b�N�X�f�[�^�̒ǉ�
#----------------------------------------
sub addlogidx {
	my ($self, $log, $nowrite) = @_;
	return if ($self->{'dummy'} ==  1);

	my $logidx = $self->{'logindex'}->set($log);
	$self->{'logindex'}->{'file'}->add($logidx, $nowrite);
	return;
}

#----------------------------------------
# IP�A�h���X�̃Z�b�g
#----------------------------------------
sub setip {
	my ($self, $data) = @_;
	return if ($self->{'dummy'} ==  1);

	my $sow = $self->{'sow'};

	$data->{'remoteaddr'}  = '';
	$data->{'fowardedfor'} = '';
	$data->{'agent'}       = '';

	$data->{'remoteaddr'}  = $ENV{'REMOTE_ADDR'} if (defined($ENV{'REMOTE_ADDR'}));
	$data->{'fowardedfor'} = $ENV{'HTTP_X_FORWARDED_FOR'} if (defined($ENV{'HTTP_X_FORWARDED_FOR'}));
	$data->{'agent'}       = $ENV{'HTTP_USER_AGENT'} if (defined($ENV{'HTTP_USER_AGENT'}));

	$data->{'remoteaddr'}  = $sow->{'DATATEXT_NONE'} if ($data->{'remoteaddr'} eq '');
	$data->{'fowardedfor'} = $sow->{'DATATEXT_NONE'} if ($data->{'fowardedfor'} eq '');
	$data->{'agent'}       = $sow->{'DATATEXT_NONE'} if ($data->{'agent'} eq '');

	return;
}

#----------------------------------------
# ����
#----------------------------------------
sub executesay {
	my ($self, $say) = @_;
	return if ($self->{'dummy'} ==  1);

	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $logcnt = $self->{'logcnt'}->{'file'};
	my $saypl = $self->{'vil'}->getpl($say->{'uid'});

	# �B�����b�Z�[�W�^�Ƃ茾�p���OID����
	my $maskedid = '';
	my $cntmaskedid = '';
	if ((($say->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) || ($say->{'mestype'} == $sow->{'MESTYPE_TSAY'})) && ($self->{'vil'}->isepilogue() == 0)) {
		$cntmaskedid = "$sow->{'LOGMESTYPE'}->[$say->{'mestype'}]$sow->{'LOGSUBID_SAY'}";
		$maskedid = &SWLog::CreateLogID($sow, $say->{'mestype'}, $say->{'logsubid'}, $saypl->{$cntmaskedid});
	}

	my $mestype = $say->{'mestype'};
	$mestype = $sow->{'MESTYPE_QUEUE'} if ($say->{'que'} > 0);
	$mestype = $sow->{'MESTYPE_UNDEF'} if ($say->{'undef'} > 0);

	# ���OID�J�E���^�̃f�[�^���x���𐶐�
	my $logcntid = "$sow->{'LOGMESTYPE'}->[$mestype]$say->{'logsubid'}";
	if (!defined($logcnt->{$logcntid})) {
		# �J�E���^�p�f�[�^���Ȃ��Ȃ疢��`�Ƃ��Ĉ���
		if ($say->{'mestype'} != $sow->{'MESTYPE_CAST'}) {
			$say->{'mestype'}  = $sow->{'MESTYPE_UNDEF'};
			$say->{'logsubid'} = $sow->{'LOGSUBID_UNDEF'};
		}
		$logcntid = "$sow->{'LOGMESTYPE'}->[$say->{'mestype'}]$say->{'logsubid'}";
	}

	# ���OID����

	my $logid = &SWLog::CreateLogID($sow, $mestype, $say->{'logsubid'}, $logcnt->{$logcntid});
	$maskedid = $logid if ($maskedid eq '');

	# ���O�̎擾
	my $chrname = $sow->{'CHRNAME_INFO'};
	$chrname = $say->{'chrname'} if ($say->{'chrname'} ne '');

	# ���O�ւ̏�������
	my $mes = &SWLog::ReplaceAnchor($sow, $self->{'vil'}, $say);
	my $memoid = $sow->{'DATATEXT_NONE'};
	$memoid = $say->{'memoid'} if (defined($say->{'memoid'}));
	my %log = (
		logid      => $logid,
		mestype    => $say->{'mestype'},
		logsubid   => $say->{'logsubid'},
		maskedid   => $maskedid,
		chrname    => $chrname,
		uid        => $say->{'uid'},
		target     => $say->{'target'},
		cid        => $say->{'cid'},
		csid       => $say->{'csid'},
		expression => $say->{'expression'},
		date       => $sow->{'time'},
		log        => $mes,
		memoid     => $memoid,
		monospace  => $say->{'monospace'},
	);
	$self->add(\%log);

	# ���O�̍X�V���̍X�V
	my $label = $sow->{'MODIFIED_MESTYPE'}->[$say->{'mestype'}];
	$vil->{$label} = $sow->{'time'} if ($label ne '');

	my $pno = $vil->checkentried();
	if ($pno >= 0) {
		my $pl = $vil->getplbypno($pno);
		$pl->{'modified'} = $sow->{'time'};
	}

	if ($say->{'que'} == 1) {
		# �����L���[�ɐς�
		my %que = (
			queid   => $logid,
			pos     => $log{'pos'},
			fixtime => $sow->{'time'} + $sow->{'cfg'}->{'MESFIXTIME'},
		);
		$self->{'que'}->{'file'}->add(\%que);
	}
	$logcnt->{$logcntid}++;
	$saypl->{$cntmaskedid}++ if ($cntmaskedid ne '');
	$logcnt->write();
	$vil->writevil();

	return $log{'pos'};
}

#----------------------------------------
# �L�����N�^�̎Q��
#----------------------------------------
sub entrychara {
	my ($self, $entry) = @_;
	return if ($self->{'dummy'} ==  1);

	my $sow = $self->{'sow'};

	my $epl = $entry->{'pl'};
	my $chrname = $epl->getlongchrname();
	my $textrs = $sow->{'textrs'};
	my %say;

	if (($entry->{'npc'} == 0) || ($textrs->{'NPCENTRYMES'} != 0)) {
		# �G���g���[�\��
		my $pno = $epl->{'pno'} + 1;
		my $mes = $textrs->{'ENTRYMES'};
		$mes =~ s/_NO_/$pno/;
		$mes =~ s/_NAME_/$chrname/;

		%say = (
			mestype    => $sow->{'MESTYPE_INFONOM'},
			logsubid   => $sow->{'LOGSUBID_INFO'},
			uid        => $epl->{'uid'},
			target     => $epl->{'uid'},
			csid       => $epl->{'csid'},
			cid        => $epl->{'cid'},
			chrname    => $epl->getlongchrname(),
			expression => 0,
			mes        => $mes,
			undef      => 0,
			monospace  => 0,
			que        => 0,
		);
		$self->executesay(\%say);
	}

	# ��E��]
	if ($sow->{'cfg'}->{'ENABLED_PLLOG'} > 0) {
		my $selrolename = $textrs->{'ROLENAME'}->[$epl->{'selrole'}];
		$selrolename = $textrs->{'RANDOMROLE'} if ($epl->{'selrole'} < 0);
		$mes = $textrs->{'ANNOUNCE_SELROLE'};
		$mes =~ s/_NAME_/$chrname/;
		$mes =~ s/_SELROLE_/$selrolename/;
		%say = (
			mestype    => $sow->{'MESTYPE_INFOSP'},
			logsubid   => $sow->{'LOGSUBID_INFO'},
			uid        => $epl->{'uid'},
			target     => $epl->{'uid'},
			csid       => $epl->{'csid'},
			cid        => $epl->{'cid'},
			chrname    => $epl->getlongchrname(),
			expression => 0,
			mes        => $mes,
			undef      => 0,
			monospace  => 0,
			que        => 0,
		);
		$self->executesay(\%say);
	}


	my $que = 1;
	$que = 0 if ($entry->{'npc'} > 0); # NPC�Ȃ�ۗ��Ȃ�
	my $mestype = $sow->{'MESTYPE_SAY'}; # �R��� MESTYPE_SAY
	$mestype    = $sow->{'MESTYPE_VSAY'} if ($epl->{'role'} == $sow->{'ROLEID_MOB'});

	# �G���g���[����
	%say = (
		mestype    => $mestype,
		logsubid   => $sow->{'LOGSUBID_SAY'},
		uid        => $epl->{'uid'},
		target     => $epl->{'uid'},
		csid       => $epl->{'csid'},
		cid        => $epl->{'cid'},
		chrname    => $epl->getlongchrname(),
		expression => $entry->{'expression'},
		mes        => $entry->{'mes'},
		undef      => 0,
		monospace  => $entry->{'monospace'},
		que        => $que,
	);
	$epl->{'lastwritepos'} = $self->executesay(\%say);
}

#----------------------------------------
# �����L���[�̊m��
#----------------------------------------
sub fixque {
	my ($self, $force) = @_;
	return if ($self->{'dummy'} ==  1);

	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $logfile = $self->{'logfile'}->{'file'};
	my $logcnt  = $self->{'logcnt'}->{'file'};
	my $quelist = $self->{'que'}->{'file'}->getlist();

	foreach (@$quelist) {
		next if (($sow->{'time'} < $_->{'fixtime'}) && ($force == 0)); # �P��P�\���Ԓ��������m��łȂ����͊m�肳���Ȃ�
		my $log = $logfile->read($_->{'pos'});
		my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);
		if (($log->{'logid'} ne $_->{'queid'})) {
			# ���O�f�[�^�ɊY�����郍�O���Ȃ��B
			$sow->{'debug'}->writeaplog($sow->{'APLOG_NOTICE'}, "FixQue, [queid=$_->{'queid'}, logid=$log->{'logid'}]");
		} else {
			# �����m��
			my $indexno  = $self->{'logindex'}->{'file'}->getbyid($log->{'logid'});
			my $logcntid = "$sow->{'LOGMESTYPE'}->[$log->{'mestype'}]$log->{'logsubid'}";
			$log->{'logid'} = &SWLog::CreateLogID($sow, $log->{'mestype'}, $log->{'logsubid'}, $logcnt->{$logcntid});
			$logcnt->{$logcntid}++;
			$self->update($log, $indexno);

			# �L���[����폜
			$_->{'delete'} = 1;

			# �\�����Ȃ�A�����񐔂𑝂₷�B
			next if ( $log->{'mestype'} == $sow->{'MESTYPE_AIM'} );
			my $pl = $vil->getpl($log->{'uid'});
			$pl->{'modified'} = $sow->{'time'};
			$pl->{'saidcount'}++;
			$vil->{'modifiedsay'} = $sow->{'time'};

		}
	}
	$self->{'que'}->{'file'}->write();
	$logcnt->write();
	$vil->writevil();
}

#----------------------------------------
# �\���ł��郍�O�̎擾�i�C���f�b�N�X�z��j
#----------------------------------------
sub getlist {
	my $self = shift;

	my $list = $self->{'logindex'}->{'file'}->getlist();
	my @result;

	foreach (@$list) {
		push(@result, $_) if ($self->CheckLogPermition($_) > 0);
	}

	return \@result;
}

#----------------------------------------
# �\�����郍�O�̎擾�i�C���f�b�N�X�z��j
#----------------------------------------
sub getvlogs {
	my ($self, $maxrow) = @_;

	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	my %rows = (
		rowover => 0,
		start   => 0,
		end     => 0,
	);

	# �������[�h�̃Z�b�g
	my $mode = '';
	my $skip = 0;
	if ($query->{'logid'} ne '') {
		if ($query->{'move'} eq 'next') {
			$mode = 'next';
		} elsif ($query->{'move'} eq 'prev') {
			# �u�O�v�ړ��̏ꍇ�A����OID�܂ŃX�L�b�v
			$mode = 'prev';
			$skip = 1;
		} else {
			# ���ڎw��̏ꍇ�A����OID�܂ŃX�L�b�v
			$mode = 'logid';
			$skip = 1;
		}
	}

	# maskedid �̃`�F�b�N
	$masked = 0;
	if ($sow->{'query'}->{'logid'} ne '') {
		my ($logmestype, $logsubid, $logcnt) = &SWLog::GetLogIDArray($sow->{'query'});
		$masked = 1 if ((($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_INFOSP'}]) || ($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_TSAY'}])) && ($self->{'vil'}->isepilogue() == 0));
	}

	# ����
	my ($logs, $rowover, $firstlog, $lastlog);
	my $foward = 0;
	$foward = 1 if ($sow->{'query'}->{'move'} eq 'first');
	$foward = 1 if ($maxrow < 0);
	$foward = 1 if ($sow->{'query'}->{'move'} eq 'page');
	$foward = 1 if (($mode eq 'logid') && (($sow->{'query'}->{'order'} eq 'a') || ($sow->{'query'}->{'order'} eq 'asc') || ($sow->{'outmode'} eq 'pc')));
	if ($foward > 0) {
		# �������T��
		($logs, $logkeys, $rowover, $firstlog) = $self->GetVLogsForward($mode, $skip, $maxrow, $masked);
		if ($firstlog >= 0) {
			$rows{'start'} = 1 if ((defined($logs->[0])) && ($logs->[0]->{'indexno'} == $firstlog));
			$rows{'end'}   = 1 if ($rowover == 0);
		}
	} else {
		# �t�����T��
		($logs, $logkeys, $rowover, $lastlog) = $self->GetVLogsReverse($mode, $skip, $maxrow, $masked);
		if ($lastlog >= 0) {
			$rows{'start'} = 1 if ($rowover == 0);
			$rows{'end'}   = 1 if (($#$logs >= 0) && ($logs->[$#$logs]->{'indexno'} == $lastlog));
		}
	}
	$rows{'rowover'} = $rowover;

	return ($logs, $logkeys, \%rows);
}

#----------------------------------------
# ���O�̎擾�i�������T���j
#----------------------------------------
sub GetVLogsForward {
	my ($self, $mode, $skip, $maxrow, $masked) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $query  = $sow->{'query'};
	my $cookie = $sow->{'cookie'};
	my $i;
	my @logs;
	my %logkeys;
	my $rowcount = 0;
	my $rowover = 0;
	my $firstlog = -1;
	my $list = $self->{'logindex'}->{'file'}->getlist();

	my $pagecount = 0;
	my $pagefirst = -1;
	my $pageno = -1;
	$pageno = $query->{'pageno'} if (defined($query->{'pageno'}));
	if (($query->{'move'} eq 'page') && ($pageno >= 0)) {
		$pagefirst = ($pageno - 1) * $maxrow;
		$skip = 1;
	}

	for ($i = 0; $i < @$list; $i++) {
		my $logidx = $list->[$i];

		# maskedid �Ή�
		my $logid = $logidx->{'logid'};
		if ($masked > 0) {
			$logid = $logidx->{'maskedid'};
			my $curpl = $vil->getpl($logidx->{'uid'});
			if (defined($curpl->{'uid'})) {
				if ((!defined($curpl->{'entrieddt'})) || ((defined($logidx->{'date'})) && ($curpl->{'entrieddt'} > $logidx->{'date'}))) {
					$logid = 'xxnnnnn';
				}
			}
		}

		next if ($self->CheckLogPermition($logidx) == 0);

		# �擪�̉����O�ԍ�
		$firstlog = $logidx->{'indexno'} if ($firstlog < 0);
		if (($rowcount >= $maxrow) && ($maxrow > 0)) {
			# �w��s���𒴂����烋�[�v���甲����
			$rowover = 1;
			last;
		}

		if (($mode eq 'logid') && ($sow->{'outmode'} ne 'mb') && ($query->{'move'} ne 'page') && ($skip == 0)) {
			$rowover = 1;
			last;
		}

		if (($mode eq 'logid') && ($logid eq $query->{'logid'})) {
			$skip = 0;
		}

		$skip = 0 if ($pagecount == $pagefirst);

		if ($skip == 0) {
			# ���O�C���f�b�N�X��o�^
			push(@logs, $logidx);
			$logkeys{$logid} = $logidx->{'indexno'};
			$rowcount++ if (($logidx->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0)); # �A�N�V�����͍s���ɐ����Ȃ�
		}

		if (($rowcount > $maxrow) && ($maxrow > 0)) {
			# �s�����I�[�o�[�����ꍇ�͍��
			my $dellog;
			do {
				$dellog = shift(@logs);
				$logkeys{$dellog->{'logid'}} = -1;
			} until (($dellog->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0) || (@logs == 0));
			$rowcount = $maxrow;
		}

		$pagecount++ if (($logidx->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0)); # �A�N�V�����͍s���ɐ����Ȃ�
	}

	return (\@logs, \%logkeys, $rowover, $firstlog);
}

#----------------------------------------
# ���O�̎擾�i�t�����T���j
#----------------------------------------
sub GetVLogsReverse {
	my ($self, $mode, $skip, $maxrow, $masked) = @_;
	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	my $i;
	my @logs;
	my %logkeys;
	my $rowcount = 0;
	my $rowover = 0;
	my $lastlog = -1;
	my $list = $self->{'logindex'}->{'file'}->getlist();

	for ($i = $#$list; $i >= 0; $i--) {
		my $logidx = $list->[$i];

		# maskedid �Ή�
		my $logid = $logidx->{'logid'};
		my $uid = $logidx->{'uid'};
		if ($masked > 0) {
			$logid = $logidx->{'maskedid'};
			$uid = $sow->{'uid'};
		}

		if (($mode eq 'next') && ($logid eq $query->{'logid'}) && ($uid eq $logidx->{'uid'})) {
			# �u���v�ړ��̏ꍇ�͊���OID�ɒH�蒅�������_�Ń��[�v���甲����
			$rowover = 1;
			last;
		}

		next if ($self->CheckLogPermition($logidx) == 0);

		# �����̉����O�ԍ�
		$lastlog = $logidx->{'indexno'} if ($lastlog < 0);

		if (($rowcount >= $maxrow) && ($maxrow > 0) && ($mode ne 'next')) {
			# �w��s���𒴂����烋�[�v���甲����
			$rowover = 1;
			last;
		}

		if (($mode eq 'logid') && ($sow->{'outmode'} ne 'mb') && ($query->{'move'} ne 'page') && ($skip == 0)) {
			$rowover = 1;
			last;
		}

		if (($mode eq 'logid') && ($logid eq $query->{'logid'})) {
			# ���OID���ڎw�菈��
			$skip = 0;
		}

		if ($skip == 0) {
			# ���O�C���f�b�N�X��o�^
			unshift(@logs, $logidx);
			$logkeys{$logidx->{'logid'}} = $logidx->{'indexno'};
			$rowcount++ if (($logidx->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0)); # �A�N�V�����͍s���ɐ����Ȃ�
		}

		if (($rowcount > $maxrow) && ($maxrow > 0)) {
			# �s�����I�[�o�[�����ꍇ�͍��
			my $dellog;
			do {
				$dellog = pop(@logs);
				$logkeys{$dellog->{'logid'}} = -1;
			} until (($dellog->{'logsubid'} ne $sow->{'LOGSUBID_ACTION'}) || ($sow->{'cfg'}->{'ROW_ACTION'} > 0) || (@logs == 0));
			$rowcount = $maxrow;
		}

		if (($mode eq 'prev') && ($logid eq $query->{'logid'}) && ($uid eq $logidx->{'uid'})) {
			# �u�O�v�ړ��̏���
			$skip = 0;
		}
	}

	return (\@logs, \%logkeys, $rowover, $lastlog);
}

#----------------------------------------
# �����̓P��폜
#----------------------------------------
sub delete {
	my ($self, $del_queid) = @_;

	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $logfile = $self->{'logfile'}->{'file'};
	my $logcnt  = $self->{'logcnt'}->{'file'};
	my $quefile = $self->{'que'}->{'file'};

	my $queindexno = $quefile->getbyid($del_queid);
	if ($queindexno >= 0) {
		my $que = $quefile->getlist->[$queindexno];
		my $log = $logfile->read($que->{'pos'});

		my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);
		if (($log->{'logid'} ne $del_queid)) {
			# ���O�f�[�^�ɊY�����郍�O���Ȃ��i�{�����肦�Ȃ��j
			$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, "Cancel, [queid=$del_queid, logid=$log->{'logid'}]");
		} else {
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�폜���悤�Ƃ����ۗ����̔�����������܂���B", "cannot delete say.[cmd=cancel, vid=$self->{'vil'}->{'vid'}, del_queid=$del_queid]") if (($log->{'uid'} ne $sow->{'uid'})&&($log->{'uid'} ne $sow->{'cfg'}->{'USERID_NPC'})); # �����̂Ȃ����[�U����̓P��R�}���h�����ł����ꍇ�A�Z�L�����e�B�̂��߂��������x���ɂ���
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�폜���悤�Ƃ����ۗ����̔�����������܂���B", "cannot delete say.[cmd=cancel, vid=$self->{'vil'}->{'vid'}, del_queid=$del_queid]") if ($sow->{'time'} >= $que->{'fixtime'});

			# ���O����폜
			my $logindexno = $self->{'logindex'}->{'file'}->getbyid($log->{'logid'});
			$log->{'mestype'} = $sow->{'MESTYPE_DELETED'};
			$log->{'logid'} = &SWLog::CreateLogID($sow, $log->{'mestype'}, $log->{'logsubid'}, $logcount);
			$self->update($log, $logindexno);

			my $pl = $vil->getpl($log->{'uid'});
			$pl->{'modified'} = $sow->{'time'};
			$vil->writevil();

			# �L���[����폜
			$que->{'delete'} = 1;
			$quefile->write();
		}
	} else {
		# �L���[�ɊY������f�[�^���Ȃ��i���m�肵�Ă���j
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�폜���悤�Ƃ����ۗ����̔�����������܂���B", "cannot delete say.[cmd=cancel, vid=$self->{'vil'}->{'vid'}, del_queid=$del_queid]");
	}
}

#----------------------------------------
# �C���t�H���[�V�����i�ʁj�̏�������
#----------------------------------------
sub writeinfo {
	my ($self, $uid, $mestype, $mes) = @_;

	my $sow = $self->{'sow'};
	$uid = $sow->{'cfg'}->{'USERID_ADMIN'} if ($uid eq '');

	# ��������
	my %say = (
		uid        => $uid,
		target     => $uid,
		mestype    => $mestype,
		logsubid   => $sow->{'LOGSUBID_INFO'},
		csid       => $sow->{'DATATEXT_NONE'},
		cid        => $sow->{'DATATEXT_NONE'},
		chrname    => '',
		expression => 0,
		mes        => $mes,
		undef      => 0,
		monospace  => 0,
		que        => 0,
	);
	$self->executesay(\%say);
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, $mes);

	return;
}

#----------------------------------------
# ���O�̉{�����`�F�b�N
#----------------------------------------
sub CheckLogPermition {
	my ($self, $log) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};
	my $logined = $sow->{'user'}->logined();
	my ($logmestype, $logsubid, $logcount) = &SWLog::GetLogIDArray($log);
	my $logpermit = 0;
	my $isque = 0;
	my $overhear = (1 == $sow->{'cfg'}->{'ENABLED_BITTY'})?(9):(8);

	$logpermit = 1 if (($logined > 0) && ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})); # �Ǘ��҃��[�h
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'})); # �C���t�H�i�ʏ�j
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'})); # �����Đl����
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'})); # �Ǘ��l����
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_SAY'})&&($log->{'logsubid'} ne $sow->{'LOGSUBID_BOOKMARK'})); # �ʏ픭��
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_MSAY'}));  # �߈˔���
	# �����l
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'alive'));
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} ne 'alive')&&($vil->{'turn'} == 0));
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} ne 'alive')&&(defined($query->{'turn'}))&&($query->{'turn'} == 0));

	# ���I
	if ($vil->iseclipse($sow->{'turn'})){
		$logpermit = 8 if ($log->{'mestype'} == $sow->{'MESTYPE_SAY'});
	}

	# ���m�蔭���������Ȃ��B
	if ($logmestype eq $sow->{'LOGMESTYPE'}->[$sow->{'MESTYPE_QUEUE'}]){
		$isque = 1;
		$logpermit = 0;
	}

	if ($vil->{'epilogue'} < $vil->{'turn'}) {
		# �I����
		$logpermit = $overhear if (($log->{'mestype'} == $sow->{'MESTYPE_WSAY'})      && ($query->{'mode'} eq 'girl')); # �������_
		$logpermit = $overhear if (($log->{'mestype'} == $sow->{'MESTYPE_XSAY'})      && ($query->{'mode'} eq 'girl')); # �������_
		$logpermit = $overhear if (($log->{'mestype'} == $sow->{'MESTYPE_SPSAY'})     && ($query->{'mode'} eq 'girl')); # �������_
		$logpermit = $overhear if (($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})      && ($query->{'mode'} eq 'necro')); # �~��Ҏ��_
		$logpermit = 8 if (($log->{'mestype'} == $sow->{'MESTYPE_INFOWOLF'})  && ($query->{'mode'} eq 'girl')); # �������_
		$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_WSAY'})      && ($query->{'mode'} eq 'wolf')); # �T���_
		$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_GSAY'})      && ($query->{'mode'} eq 'grave')); # �掋�_
		$logpermit = 1 if ($query->{'mode'} eq 'all'); # �S���_
		$logpermit = 1 if ($query->{'mode'} eq ''); # �S���_
	} elsif (($vil->isepilogue() > 0) && ($isque != 1)) {
		# �G�s���[�O��
		$logpermit = 1;
	} elsif ((0 < $logined)) {
		# �i�s��
		$logpermit = $curpl->isLogPermition($sow, $vil, $log, $logpermit, $isque) if (defined($curpl->{'uid'}));
	}

	# �폜�ςݔ����͌����Ȃ�
	$logpermit = 0 if (($log->{'mestype'} == $sow->{'MESTYPE_DELETED'}) && ($sow->{'cfg'}->{'ENABLED_DELETED'} == 0));

	# �l�t�B���^
	# �B��n�̃��O�ɑ΂��Ă͓��삵�Ȃ��B
	if (($logpermit < 2)) {
		if      ($query->{'pno'} == 0) {
		} elsif ($query->{'pno'} <  0) {
			my $targetid = -$query->{'pno'};
			my $logtypeid    = $sow->{'MESTYPE2TYPEID'}->[$log->{'mestype'}];
			$logpermit = 0 if ($logpermit != 1);
			$logpermit = 0 if ($logtypeid != $targetid);
		} elsif ($sow->{'turn'} > 0) {
			my $targetpl = $vil->getplbypno($query->{'pno'});
			if (defined($targetpl->{'uid'})) {
				$logpermit = 0 if ($logpermit != 1);
# �����b�𔭂��Ă��鎞�ƁA�󂯂Ă���Ƃ��\������ꍇ�B
#				$logpermit = 0 if (($log->{'uid'}  ne $targetpl->{'uid'} )&&($log->{'target'} ne $targetpl->{'uid'} ));
# �����b�𔭂��Ă���Ƃ��̂ݕ\������ꍇ�B
				$logpermit = 0 if (($log->{'csid'} ne $targetpl->{'csid'})||($log->{'cid'} ne $targetpl->{'cid'}));
#				$logpermit = 0 if ($log->{'date'} < $targetpl->{'entrieddt'});
				$logpermit = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}); # �����Đl����
				$logpermit = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}); # �Ǘ��l����
			}
		}
	}

	$log->{'logpermit'} = $logpermit;
	return $logpermit;
}

1;
