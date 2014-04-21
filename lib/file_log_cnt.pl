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
		'dS', # MESTYPE_DELETEDADMIN
		'DS', # MESTYPE_DELETED
		'cS', # MESTYPE_CAST
		'qS', # MESTYPE_QUEUE

		'iI', # MESTYPE_INFOSP
		'II', # MESTYPE_INFONOM
		'wI', # MESTYPE_INFOWOLF

		'AA', # MESTYPE_ANONYMOUS

		'mA', # MESTYPE_MAKER
		'mS', # MESTYPE_MAKER
		'aA', # MESTYPE_ADMIN
		'aS', # MESTYPE_ADMIN

		'SA', # MESTYPE_SAY
		'SB', # MESTYPE_SAY
		'SS', # MESTYPE_SAY
		      # MESTYPE_MSAY
		'TA', # MESTYPE_TSAY
		'TS', # MESTYPE_TSAY
		      # MESTYPE_AIM
		'WA', # MESTYPE_WSAY
		'WS', # MESTYPE_WSAY
		'GA', # MESTYPE_GSAY
		'GB', # MESTYPE_GSAY
		'GS', # MESTYPE_GSAY
		'PA', # MESTYPE_SPSAY
		'PS', # MESTYPE_SPSAY
		'XA', # MESTYPE_XSAY
		'XS', # MESTYPE_XSAY
		'VA', # MESTYPE_VSAY
		'VB', # MESTYPE_VSAY
		'VS', # MESTYPE_VSAY
	);

	return @datalabel;
}

1;
