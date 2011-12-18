package SWSnakeMemoIndex;

#----------------------------------------
# SW-Snake Memo Index Driver
#----------------------------------------

#----------------------------------------
# コンストラクタ
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

	# ログインデックスファイルの新規作成／開く
	my $fnamememoindex = $self->getfnamememoindex();
	my @memoindexdatalabel = $self->getmemoindexdatalabel();
	$self->{'file'} = SWHashList->new(
		$sow,
		$fnamememoindex,
		\*MEMOINDEX,
		'memoindex',
		\@memoindexdatalabel,
		'メモインデックスデータ',
		"[vid=$self->{'vil'}->{'vid'}/turn=$self->{'turn'}]",
		$mode,
		$self->{'version'},
	);
	$self->{'file'}->read() if ($mode == 0);

	return $self;
}

#----------------------------------------
# メモインデックスデータをセットする
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
# メモインデックスデータファイル名の取得
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
# メモインデックスデータラベル
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