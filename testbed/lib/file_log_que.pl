package SWBoaQue;

#----------------------------------------
# SW-Boa Que Driver
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
		version  => ' 2.0',
		startpos => 0,
	};
	bless($self, $class);

	# �L���[�t�@�C���̐V�K�쐬�^�J��
	my $fnameque = $self->getfnameque();
	my @quedatalabel = $self->getquedatalabel();
	$self->{'file'} = SWHashList->new(
		$sow,
		$fnameque,
		\*QUE,
		'que',
		\@quedatalabel,
		'�L���[�f�[�^',
		"[vid=$self->{'vil'}->{'vid'}]",
		$mode,
		$self->{'version'},
	);
	$self->{'file'}->read() if ($mode == 0);

	return $self;
}

#----------------------------------------
# �L���[�f�[�^�t�@�C�����̎擾
#----------------------------------------
sub getfnameque {
	my $self = shift;
	my $datafile;
	if ($self->{'vil'}->{'dir'} == 1) {
		$datafile = sprintf(
			"%s/%04d/%04d_%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'vil'}->{'vid'},
			$self->{'sow'}->{'cfg'}->{'FILE_QUE'},
		);
	} else {
		$datafile = sprintf(
			"%s/%04d_%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'sow'}->{'cfg'}->{'FILE_QUE'},
		);
	}
	return $datafile;
}

#----------------------------------------
# �L���[�f�[�^���x��
#----------------------------------------
sub getquedatalabel {
	my $self = shift;
	my @datalabel;

	# Version 2.0
	@datalabel = (
		'queid',
		'logid',
		'pos',
		'fixtime',
	);

	return @datalabel;		
}

1;