package SWBoaRandomAccess;

#----------------------------------------
# SWBBS Boa Random Access Driver
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow, $filename, $filehandle, $fileid, $datalabel, $mesname, $mesop, $mode, $version) = @_;
	my $self = {
		sow        => $sow,
		datalabel  => $datalabel,
		version    => $version,
		startpos   => 0,
	};
	bless($self, $class);

	my $modeid = '+<';
	$modeid = '>' if ($mode > 0);

	my $file = SWFile->new(
		$self->{'sow'},
		$fileid,
		$filehandle,
		$filename,
		$self,
	);
	$file->openfile(
		$modeid,
		$mesname,
		$mesop,
	);
	$self->{'file'} = $file;

	if ($mode > 0) {
		$self->create($version);
	} else {
		$self->open();
	}
	$self->{'startpos'} = tell($filehandle);

	return $self;
}

#----------------------------------------
# データファイルの作成
#----------------------------------------
sub create {
	my ($self, $version) = @_;
	my $fh = $self->{'file'}->{'filehandle'};

	print $fh "version<>\n";
	print $fh "$version<>\n";
	print $fh join("<>", @{$self->{'datalabel'}}). "<>\n";
	return;
}

#----------------------------------------
# データファイルを開く
#----------------------------------------
sub open {
	my $self = shift;
	my $fh = $self->{'file'}->{'filehandle'};

	seek($fh, 0, 0);
	$versionlabeltext = <$fh>;
	if (defined($versionlabeltext)) {
		my @versionlabel = split(/<>/, $versionlabeltext);
		my %versions;
		@versions{@versionlabel} = split(/<>/, <$fh>);
		$self->{'version'} = $versions{'version'};
	}

	my $datalabeltext = <$fh>;
	if (defined($datalabeltext)) {
		chomp($datalabeltext);
		if ($datalabeltext ne '') {
			my @datalabel = split(/<>/, $datalabeltext);
			$self->{'datalabel'} = \@datalabel;
		}
	}

	return;
}

#----------------------------------------
# IDからデータレコードを取得する
#----------------------------------------
sub read {
	my ($self, $pos) = @_;

	my $fh = $self->{'file'}->{'filehandle'};
	seek($fh, $pos, 0);
	my %data;
	my $srcdata = <$fh>;
	if (defined($srcdata)) {
		chomp($srcdata);
		@data{@{$self->{'datalabel'}}} = split(/<>/, $srcdata);
	}
	$data{'pos'}     = $pos;
	$data{'nextpos'} = tell($fh);

	return \%data;
}

#----------------------------------------
# データレコードを追加する
#----------------------------------------
sub add {
	my ($self, $data) = @_;

	my $fh = $self->{'file'}->{'filehandle'};
	seek($fh, 0, 2);
	$data->{'pos'} = tell($fh);
	$self->update($data);
}

#----------------------------------------
# データレコードを書き込む
#----------------------------------------
sub update {
	my ($self, $data) = @_;

	# 書き込み位置へ移動
	my $fh  = $self->{'file'}->{'filehandle'};
	seek($fh, $data->{'pos'}, 0);

	# 書き込み
	print $fh join("<>", map{$data->{$_}}@{$self->{'datalabel'}}). "<>\n";

	# 次の書き込み位置を保存
	$self->{'prevpos'} = $data->{'pos'};
	my $nextpos = tell($fh);
	$data->{'nextpos'} = $nextpos;

	return $pos;
}

#----------------------------------------
# データレコードを削除する
#----------------------------------------
sub delete {
	# 未実装
}

#----------------------------------------
# データファイルを閉じる
#----------------------------------------
sub close {
	my $self = shift;
	$self->{'file'}->closefile();
}

1;