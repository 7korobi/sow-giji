package SWBoaLogCount;

#----------------------------------------
# SW-Boa Log Count Driver
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $turn, $mode) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_hash.pl";

	my $self = {
		sow      => $sow,
		vil      => $vil,
		turn     => $turn,
		version  => ' 2.0',
		startpos => 0,
	};
	bless($self, $class);

	# ログカウントファイルの新規作成／開く
	my $fnamelogcnt = $self->getfnamelogcnt();
	my @logcntdatalabel = $self->getlogcntdatalabel();
	$self->{'file'} = SWFileHash->new(
		$sow,
		$fnamelogcnt,
		\*LOGCNT,
		'logcnt',
		\@logcntdatalabel,
		'ログカウントデータ',
		"[vid=$self->{'vil'}->{'vid'}]",
		$mode,
		$self->{'version'},
	);
	$self->{'file'}->read() if ($mode == 0);

	return $self;
}

#----------------------------------------
# ログインデックスデータファイル名の取得
#----------------------------------------
sub getfnamelogcnt {
	my $self = shift;
	if ($self->{'vil'}->{'dir'} == 1) {
		$datafile = sprintf(
			"%s/%04d/%04d_%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'vil'}->{'vid'},
			$self->{'sow'}->{'cfg'}->{'FILE_LOGCNT'},
		);
	} else {
		$datafile = sprintf(
			"%s/%04d_%s",
			$self->{'sow'}->{'cfg'}->{'DIR_VIL'},
			$self->{'vil'}->{'vid'},
			$self->{'sow'}->{'cfg'}->{'FILE_LOGCNT'},
		);
	}
	return $datafile;
}

#----------------------------------------
# ログカウントデータラベル
#----------------------------------------
sub getlogcntdatalabel {
	my $self = shift;
	my @datalabel;

	# Version 2.0
	@datalabel = (
		'-S', # MESTYPE_UNDEF
		'iI', # MESTYPE_INFOSP
		'dS', # MESTYPE_DELETEDADMIN
		'cS', # MESTYPE_CAST
		'mS', # MESTYPE_MAKER
		'mA', # MESTYPE_MAKER
		'aS', # MESTYPE_ADMIN
		'aA', # MESTYPE_ADMIN
		'AA', # MESTYPE_ANONYMOUS
		'qS', # MESTYPE_QUEUE
		'II', # MESTYPE_INFONOM
		'DS', # MESTYPE_DELETED
		'SA', # MESTYPE_SAY
		'SB', # MESTYPE_SAY
		'SS', # MESTYPE_SAY
		      # MESTYPE_MSAY
		'TA', # MESTYPE_TSAY
		'TS', # MESTYPE_TSAY
		      # MESTYPE_AIM
		'WS', # MESTYPE_WSAY
		'GA', # MESTYPE_GSAY
		'GB', # MESTYPE_GSAY
		'GS', # MESTYPE_GSAY
		'PS', # MESTYPE_SPSAY
		'XS', # MESTYPE_XSAY
		'VA', # MESTYPE_VSAY
		'VB', # MESTYPE_VSAY
		'VS', # MESTYPE_VSAY
		'wI', # MESTYPE_INFOWOLF
	);

	return @datalabel;		
}

1;