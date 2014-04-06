package SWSnakeMemo;

#----------------------------------------
# SW-Snake Memo Driver
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $turn, $mode) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_ra.pl";

	my $self = {
		sow      => $sow,
		vil      => $vil,
		turn     => $turn,
		version  => ' 1.2',
		startpos => 0,
	};
	bless($self, $class);

	# �����t�@�C���̐V�K�쐬�^�J��
	my $filename = $self->getfnamememo();
	my @datalabel = $self->getmemodatalabel();
	$self->{'file'} = SWBoaRandomAccess->new(
		$sow,
		$filename,
		\*MEMO,
		'memo',
		\@datalabel,
		'�����f�[�^',
		"[vid=$self->{'vil'}->{'vid'}/turn=$self->{'turn'}]",
		$mode,
		$self->{'version'},
	);

	return $self;
}

#----------------------------------------
# �����f�[�^�t�@�C�����̎擾
#----------------------------------------
sub getfnamememo {
	my $self = shift;
	my $datafile;
	if ($self->{'vil'}->{'dir'} == 1) {
		$datafile = sprintf(
			"%s/%04d/%04d_%02d%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'vil'}->{'vid'},
			$self->{'turn'},
			$self->{'sow'}->{'cfg'}->{'FILE_MEMO'},
		);
	} else {
		$datafile = sprintf(
			"%s/%04d_%02d%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'turn'},
			$self->{'sow'}->{'cfg'}->{'FILE_MEMO'},
		);
	}
	return $datafile;
}

#----------------------------------------
# �����f�[�^���x��
#----------------------------------------
sub getmemodatalabel {
	my $self = shift;
	my @datalabel;

	# Version 1.0
	@datalabel = (
		'logid',
		'mestype',
		'uid',
		'cid',
		'csid',
		'chrname',
		'date',
		'log',
		'monospace',
		'remoteaddr',
		'fowardedfor',
		'agent',
	);

	return @datalabel;		
}

1;