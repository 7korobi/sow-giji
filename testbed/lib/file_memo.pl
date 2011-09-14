package SWSnake;

#----------------------------------------
# SWBBS Memo Driver Library 'SW-Snake'
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $turn, $mode) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo_data.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo_idx.pl";

	my $self = {
		sow    => $sow,
		vil      => $vil,
		turn     => $turn,
		version  => ' 1.0',
		startpos => 0,
	};
	bless($self, $class);

	# �����t�@�C���̐V�K�쐬�^�J��
	$self->{'memo'} = SWSnakeMemo->new($sow, $vil, $turn, $mode);
	if ($sow->{'query'}->{'cmd'} eq 'restmemo') {
		# �����C���f�b�N�X�t�@�C���̐V�K�쐬�^�J��
		$self->{'memoindex'} = SWSnakeMemoIndex->new($sow, $vil, $turn, 1);
	}

	# �����C���f�b�N�X�t�@�C���̐V�K�쐬�^�J��
	$self->{'memoindex'} = SWSnakeMemoIndex->new($sow, $vil, $turn, $mode);

	return $self;
}

#----------------------------------------
# �t�@�C�������
#----------------------------------------
sub close {
	my $self = shift;

	$self->{'memo'}->{'file'}->close();
	$self->{'memoindex'}->{'file'}->close();
}

#----------------------------------------
# �����f�[�^�̓ǂݍ���
#----------------------------------------
sub read {
	my ($self, $pos, $logpermit) = @_;
	my $data = $self->{'memo'}->{'file'}->read($pos);
	if( 7 <  $logpermit  ){
		my $sow = $self->{'sow'};
		$data->{'mestype'} = $sow->{'MESTYPE_INFOSP'};
		$data->{'chrname'} = '�H';
		$data->{'cid'} = '';
	}
	$data->{'log'} = '' if ($data->{'log'} eq $self->{'sow'}->{'DATATEXT_NONE'});
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
# �����f�[�^�̒ǉ�
#----------------------------------------
sub add {
	my ($self, $log) = @_;
	my $sow = $self->{'sow'};
	$log->{'log'} = $sow->{'DATATEXT_NONE'} if ($log->{'log'} eq '');

	$self->setip($log);
	$self->{'memo'}->{'file'}->add($log);
	$self->addmemoidx($log);

	$log->{'log'} = '' if ($log->{'log'} eq $sow->{'DATATEXT_NONE'});
}

#----------------------------------------
# �����f�[�^�̍X�V
#----------------------------------------
sub update {
	my ($self, $log, $indexno) = @_;
	my $sow = $self->{'sow'};
	$log->{'log'} = $sow->{'DATATEXT_NONE'} if ($log->{'log'} eq '');

	$self->{'memo'}->{'file'}->update($log);
	my $logidx = $self->{'memoindex'}->set($log);
	$self->{'memoindex'}->{'file'}->update($logidx, $indexno);
	$log->{'log'} = '' if ($log->{'log'} eq $sow->{'DATATEXT_NONE'});
}

#----------------------------------------
# �C���f�b�N�X�f�[�^�̒ǉ�
#----------------------------------------
sub addmemoidx {
	my ($self, $log) = @_;
	my $logidx = $self->{'memoindex'}->set($log);
	$self->{'memoindex'}->{'file'}->add($logidx);
	return;
}

#----------------------------------------
# IP�A�h���X�̃Z�b�g
#----------------------------------------
sub setip {
	my ($self, $data) = @_;
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
# �����S�̂̎擾�i�C���f�b�N�X�z��j
#----------------------------------------
sub getmemolist {
	my $self  = shift;
	my $sow   = $self->{'sow'};
	my $query = $sow->{'query'};

	my $list = $self->getlist();
	if ($query->{'cmd'} eq 'memo') {
		# �ŐV�̂��̂������o
		my @newlogs = ();
		my %uids = ();
		my $i;

		# �D��\���i�Ǘ��n�j
		for ($i = $#$list; $i >= 0; $i--) {
			my $log = $list->[$i];
			my $disable_mestype = 1;
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_MAKER'});
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'});
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'});
			next if (1 == $disable_mestype);
			next if (defined($uids{$log->{'mestype'}}));
			unshift(@newlogs, $log);
			$uids{$log->{'mestype'}} = 1;
		}

		# ����ȊO
		for ($i = $#$list; $i >= 0; $i--) {
			my $log = $list->[$i];
			my $disable_mestype = 1;
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_MAKER'});
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'});
			$disable_mestype = 0 if ($log->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'});
			next if (0 == $disable_mestype);
			my $plsingle = $self->{'vil'}->getpl($log->{'uid'});
			next if (!defined($plsingle->{'uid'}));
			next if (defined($uids{$log->{'uid'}}));
			next if (($plsingle->{'entrieddt'} > $log->{'date'}) && ($plsingle->{'entrieddt'} != 0));
			unshift(@newlogs, $log);
			$uids{$log->{'uid'}} = 1;
		}
		$list = \@newlogs;
	}

	return $list;
}

#----------------------------------------
# �C���f�b�N�X�f�[�^�̍č\�z
#----------------------------------------
sub restructure {
	my $self = shift;
	my $logfile = $self->{'memo'}->{'file'};
	$self->{'memoindex'}->{'file'}->clear();

	my $pos = $logfile->{'startpos'};
	my $log = $logfile->read($pos);
	while (defined($log->{'uid'})) {
		$self->addmemoidx($log);
		$pos = $log->{'nextpos'};
		$log = $logfile->read($pos);
	}
}

#----------------------------------------
# �\�����郁���̎擾�i�C���f�b�N�X�z��j
#----------------------------------------
sub getmemo {
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

	# ����
	my ($logs, $rowover, $firstlog, $lastlog);
	my $foward = 0;
	$foward = 1 if ($sow->{'query'}->{'move'} eq 'first');
	$foward = 1 if ($maxrow < 0);
	$foward = 1 if ($sow->{'query'}->{'move'} eq 'page');
	if ($foward > 0) {
		# �������T��
		($logs, $logkeys, $rowover, $firstlog) = $self->GetVLogsForward($mode, $skip, $maxrow);
		if ($firstlog >= 0) {
			$rows{'start'} = 1 if ((defined($logs->[0])) && ($logs->[0]->{'indexno'} == $firstlog));
			$rows{'end'}   = 1 if ($rowover == 0);
		}
	} else {
		# �t�����T��
		($logs, $logkeys, $rowover, $lastlog) = $self->GetVLogsReverse($mode, $skip, $maxrow);
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
	my ($self, $mode, $skip, $maxrow) = @_;
	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	my $i;
	my @logs;
	my %logkeys;
	my $rowcount = 0;
	my $rowover = 0;
	my $firstlog = -1;
	my $list = $self->getmemolist();

	for ($i = 0; $i < @$list; $i++) {
		my $logidx = $list->[$i];
		next if ($self->CheckMemoPermition($logidx) == 0);

		# �擪�̃����ԍ�
		$firstlog = $logidx->{'indexno'} if ($firstlog < 0);
		if (($rowcount >= $maxrow) && ($maxrow > 0)) {
			# �w��s���𒴂����烋�[�v���甲����
			$rowover = 1;
			last;
		}

		last if (($mode eq 'logid') && ($sow->{'outmode'} ne 'mb') && ($skip == 0));

		if (($mode eq 'logid') && ($logidx->{'logid'} eq $query->{'logid'})) {
			$skip = 0;
		}

		if ($skip == 0) {
			# ���O�C���f�b�N�X��o�^
			push(@logs, $logidx);
			$logkeys{$logidx->{'logid'}} = $logidx->{'indexno'};
			$rowcount++; # �A�N�V�����͍s���ɐ����Ȃ�
		}

		if (($rowcount > $maxrow) && ($maxrow > 0)) {
			# �s�����I�[�o�[�����ꍇ�͍��
			my $dellog = shift(@logs);
			$logkeys{$dellog->{'logid'}} = -1;
			$rowcount = $maxrow;
		}
	}

	return (\@logs, \%logkeys, $rowover, $firstlog);
}

#----------------------------------------
# ���O�̎擾�i�t�����T���j
#----------------------------------------
sub GetVLogsReverse {
	my ($self, $mode, $skip, $maxrow) = @_;
	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	my $i;
	my @logs;
	my %logkeys;
	my $rowcount = 0;
	my $rowover = 0;
	my $lastlog = -1;
	my $list = $self->getmemolist();

	for ($i = $#$list; $i >= 0; $i--) {
		my $logidx = $list->[$i];
		my $logid = $logidx->{'logid'};

		if (($mode eq 'next') && ($logid eq $query->{'logid'})) {
			# �u���v�ړ��̏ꍇ�͊���OID�ɒH�蒅�������_�Ń��[�v���甲����
			$rowover = 1;
			last;
		}
		next if ($self->CheckMemoPermition($logidx) == 0);

		# �����̃������O�ԍ�
		$lastlog = $logidx->{'indexno'} if ($lastlog < 0);

		if (($rowcount >= $maxrow) && ($maxrow > 0) && ($mode ne 'next')) {
			# �w��s���𒴂����烋�[�v���甲����
			$rowover = 1;
			last;
		}

		last if (($mode eq 'logid') && ($sow->{'outmode'} ne 'mb') && ($skip == 0));

		if (($mode eq 'logid') && ($logid eq $query->{'logid'})) {
			# ���OID���ڎw�菈��
			$skip = 0;
		}

		if ($skip == 0) {
			# ���O�C���f�b�N�X��o�^
			unshift(@logs, $logidx);
			$logkeys{$logidx->{'logid'}} = $logidx->{'indexno'};
			$rowcount++;
		}

		if (($rowcount > $maxrow) && ($maxrow > 0)) {
			# �s�����I�[�o�[�����ꍇ�͍��
			my $dellog = pop(@logs);
			$logkeys{$dellog->{'logid'}} = -1;
			$rowcount = $maxrow;
		}

		if (($mode eq 'prev') && ($logid eq $query->{'logid'})) {
			# �u�O�v�ړ��̏���
			$skip = 0;
		}
	}

	return (\@logs, \%logkeys, $rowover, $lastlog);
}

#----------------------------------------
# �w�肵���v���C���[�̍ŐV�������擾
#----------------------------------------
sub getnewmemo {
	my ($self, $curpl) = @_;
	my $logs = $self->getlist();
	my $i;
	my $log = {
		log => '',
	};
	for ($i = $#$logs; $i >= 0; $i--) {
		next if ($curpl->{'uid'} ne $logs->[$i]->{'uid'});
		next if ($curpl->{'csid'} ne $logs->[$i]->{'csid'});
		next if ($curpl->{'cid'} ne $logs->[$i]->{'cid'});
		next if (($curpl->{'entrieddt'} > $logs->[$i]->{'date'}) && ($curpl->{'entrieddt'} != 0));
		$log = $self->read($logs->[$i]->{'pos'});
		last;
	}

	return $log;
}

#----------------------------------------
# �\���ł��郁���̎擾�i�C���f�b�N�X�z��j
#----------------------------------------
sub getlist {
	my $self = shift;

	my $list = $self->{'memoindex'}->{'file'}->getlist();
	my @result;

	foreach (@$list) {
		push(@result, $_) if ($self->CheckMemoPermition($_) > 0);
	}

	return \@result;
}

#----------------------------------------
# ���O�̉{�����`�F�b�N
#----------------------------------------
sub CheckMemoPermition {
	my ($self, $log) = @_;
	my $sow = $self->{'sow'};
	my $vil = $self->{'vil'};
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};
	my $logined = $sow->{'user'}->logined();
	my $logpermit = 0;
	my $overhear = (1 == $sow->{'cfg'}->{'ENABLED_BITTY'})?(9):(8);

	$logpermit = 1 if (($logined > 0) && ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})); # �Ǘ��҃��[�h
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'})); # �C���t�H�i�ʏ�j
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'})); # �����Đl����
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'})); # �Ǘ��l����
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'})); # ��������
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_SAY'})); # �ʏ픭��
	# �����l
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'alive')); 
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} ne 'alive')&&($vil->{'turn'} == 0)); 
	$logpermit = 1 if (($log->{'mestype'} == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} ne 'alive')&&(defined($query->{'turn'}))&&($query->{'turn'} == 0)); 

	# ���I
	if ($vil->iseclipse($sow->{'turn'})){
		$logpermit = 8 if ($log->{'mestype'} == $sow->{'MESTYPE_SAY'});
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
	} elsif (($vil->isepilogue() > 0)) {
		# �G�s���[�O��
		$logpermit = 1;
	} elsif ((0 < $logined)) {
		# �i�s��
		$logpermit = $curpl->isLogPermition($sow, $vil, $log, $logpermit ) if (defined($curpl->{'uid'}));
	}

	# �폜�ςݔ����͌����Ȃ�
	$logpermit = 0 if (($log->{'mestype'} == $sow->{'MESTYPE_DELETED'}) && ($sow->{'cfg'}->{'ENABLED_DELETED'} == 0));	

	$log->{'logpermit'} = $logpermit;
	return $logpermit;
}

1;