package SWBoaLogIndex;

#----------------------------------------
# SW-Boa Log Index Driver
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $turn, $mode) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_hashlist.pl";

	my $self = {
		sow      => $sow,
		vil      => $vil,
		turn     => $turn,
		version  => ' 2.1',
		startpos => 0,
	};
	bless($self, $class);

	# ���O�C���f�b�N�X�t�@�C���̐V�K�쐬�^�J��
	my $fnamelogindex = $self->getfnamelogindex($sow->{'cfg'}->{'FILE_LOGINDEX'});
	my @logindexdatalabel = $self->getlogindexdatalabel();
	$self->{'file'} = SWHashList->new(
		$sow,
		$fnamelogindex,
		\*LOGINDEX,
		'logindex',
		\@logindexdatalabel,
		'���O�C���f�b�N�X�f�[�^',
		"[vid=$self->{'vil'}->{'vid'}/turn=$self->{'turn'}]",
		$mode,
		$self->{'version'},
	);
	$self->{'file'}->read() if ($mode == 0);

	return $self;
}

#----------------------------------------
# ���O�C���f�b�N�X�f�[�^���Z�b�g����
#----------------------------------------
sub set {
	my ($self, $log) = @_;

	my %logidx = (
		logid    => $log->{'logid'},
		mestype  => $log->{'mestype'},
		logsubid => $log->{'logsubid'},
		maskedid => $log->{'maskedid'},
		date     => $log->{'date'},
		uid      => $log->{'uid'},
		target   => $log->{'target'},
		csid     => $log->{'csid'},
		cid      => $log->{'cid'},
		pos      => $log->{'pos'},
	);
	return \%logidx;
}

#----------------------------------------
# ���O�C���f�b�N�X�f�[�^�t�@�C�����̎擾
#----------------------------------------
sub getfnamelogindex {
	my ($self,$postfix) = @_;

	my $datafile;
	if ($self->{'vil'}->{'dir'} == 1) {
		$datafile = sprintf(
			"%s/%04d/%04d_%02d%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'vil'}->{'vid'},
			$self->{'turn'},
			$postfix,
		);
	} else {
		$datafile = sprintf(
			"%s/%04d_%02d%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'turn'},
			$postfix,
		);
	}

	return $datafile;
}

#----------------------------------------
# ���O�C���f�b�N�X�f�[�^���x��
#----------------------------------------
sub getlogindexdatalabel {
	my $self = shift;
	my @datalabel;

	# Version 2.0
	@datalabel = (
		'logid',
		'mestype',
		'logsubid',
		'maskedid',
		'date',
		'uid',
		'target',
		'csid',
		'cid',
		'pos',
	);

	return @datalabel;		
}

1;