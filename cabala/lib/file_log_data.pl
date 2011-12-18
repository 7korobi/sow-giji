package SWBoaLog;

#----------------------------------------
# SW-Boa Log Driver
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $turn, $mode) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_ra.pl";

	my $self = {
		sow      => $sow,
		vil      => $vil,
		turn     => $turn,
		version  => ' 2.1',
		startpos => 0,
	};
	bless($self, $class);

	# ログファイルの新規作成／開く
	my $filename = $self->getfnamelog();
	my @datalabel = $self->getlogdatalabel();
	$self->{'file'} = SWBoaRandomAccess->new(
		$sow,
		$filename,
		\*LOG,
		'log',
		\@datalabel,
		'ログデータ',
		"[vid=$self->{'vil'}->{'vid'}/turn=$self->{'turn'}]",
		$mode,
		$self->{'version'},
	);

	return $self;
}

#----------------------------------------
# ログデータファイル名の取得
#----------------------------------------
sub getfnamelog {
	my $self = shift;
	my $datafile;
	if ($self->{'vil'}->{'dir'} == 1) {
		$datafile = sprintf(
			"%s/%04d/%04d_%02d%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'vil'}->{'vid'},
			$self->{'turn'},
			$self->{'sow'}->{'cfg'}->{'FILE_LOG'},
		);
	} else {
		$datafile = sprintf(
			"%s/%04d_%02d%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'turn'},
			$self->{'sow'}->{'cfg'}->{'FILE_LOG'},
		);
	}
	return $datafile;
}

#----------------------------------------
# ログデータラベル
#----------------------------------------
sub getlogdatalabel {
	my $self = shift;
	my @datalabel;

	# Version 2.1
	@datalabel = (
		'logid',
		'mestype',
		'logsubid',
		'maskedid',
		'uid',
		'target',
		'cid',
		'csid',
		'chrname',
		'expression',
		'date',
		'log',
		'monospace',
		'memoid',
		'remoteaddr',
		'fowardedfor',
		'agent',
	);

	return @datalabel;		
}

1;