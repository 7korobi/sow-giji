package SWSnakeMemoIndex;

#----------------------------------------
# SW-Snake Memo Index Driver
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
		version  => ' 1.2',
		startpos => 0,
	};
	bless($self, $class);

	# ���O�C���f�b�N�X�t�@�C���̐V�K�쐬�^�J��
	my $fnamememoindex = $self->getfnamememoindex();
	my @memoindexdatalabel = $self->getmemoindexdatalabel();
	$self->{'file'} = SWHashList->new(
		$sow,
		$fnamememoindex,
		\*MEMOINDEX,
		'memoindex',
		\@memoindexdatalabel,
		'�����C���f�b�N�X�f�[�^',
		"[vid=$self->{'vil'}->{'vid'}/turn=$self->{'turn'}]",
		$mode,
		$self->{'version'},
	);
	$self->{'file'}->read() if ($mode == 0);

	return $self;
}

#----------------------------------------
# �����C���f�b�N�X�f�[�^���Z�b�g����
#----------------------------------------
sub set {
	my ($self, $log) = @_;

	my %memoidx = (
		logid    => $log->{'logid'},
		mestype  => $log->{'mestype'},
		logsubid => $log->{'logsubid'},
		maskedid => $log->{'maskedid'},
		uid      => $log->{'uid'},
		pos      => $log->{'pos'},
		csid     => $log->{'csid'},
		cid      => $log->{'cid'},
		date     => $log->{'date'},
	);
	return \%memoidx;
}

#----------------------------------------
# �����C���f�b�N�X�f�[�^�t�@�C�����̎擾
#----------------------------------------
sub getfnamememoindex {
	my $self = shift;
	my $datafile;
	if ($self->{'vil'}->{'dir'} == 1) {
		$datafile = sprintf(
			"%s/%04d/%04d_%02d%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'vil'}->{'vid'},
			$self->{'turn'},
			$self->{'sow'}->{'cfg'}->{'FILE_MEMOINDEX'},
		);
	} else {
		$datafile = sprintf(
			"%s/%04d_%02d%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'turn'},
			$self->{'sow'}->{'cfg'}->{'FILE_MEMOINDEX'},
		);
	}
	return $datafile;
}

#----------------------------------------
# �����C���f�b�N�X�f�[�^���x��
#----------------------------------------
sub getmemoindexdatalabel {
	my $self = shift;
	my @datalabel;

	# Version 1.1
	@datalabel = (
		'logid',
		'mestype',
		'uid',
		'pos',
		'csid',
		'cid',
		'date',
	);

	return @datalabel;		
}

1;