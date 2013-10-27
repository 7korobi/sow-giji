package SWHashList;

#----------------------------------------
# ハッシュリストファイル制御
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow, $filename, $filehandle, $fileid, $datalabel, $mesname, $mesop, $mode) = @_;
	my $self = {
		sow        => $sow,
		datalabel  => $datalabel,
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
	my @list = ();
	$self->{'list'} = \@list;

	return $self;
}

#----------------------------------------
# ハッシュリストの取得
#----------------------------------------
sub read {
	my $self = shift;
	my $fh = $self->{'file'}->{'filehandle'};

	seek($fh, 0, 0);
	my @data = <$fh>;

	my $datalabel;
	my $datalabeltext = '';
	$datalabeltext = shift(@data) if (@data > 0);
	chomp($datalabeltext);
	if ($datalabeltext ne '') {
		my @datalabel = split(/<>/, $datalabeltext);
		$datalabel = \@datalabel;
	} else {
		$datalabel = $self->{'datalabel'};
	}

	my $i = 0;
	my $datacnt = @data;
	my @list = ();
	my %keys = ();
	while ($i < $datacnt) {
		chomp($data[$i]);
		if ($data[$i] ne '') {
			my %single;
			@single{@$datalabel} = split(/<>/, $data[$i]);
			$single{'indexno'} = $i;
			$single{'delete'}  = 0;
			push(@list, \%single);
			$keys{$single{$datalabel->[0]}} = $i;
			$i++;
		}
	}
	$self->{'list'} = \@list;
	$self->{'keys'} = \%keys;

	return \@list;
}

#----------------------------------------
# ハッシュリストの書き込み
#----------------------------------------
sub write {
	my $self = shift;

	my $fh = $self->{'file'}->{'filehandle'};
	$self->writelabel();

	my $single;
	my $datalabel = $self->{'datalabel'};
	my $startline = 0;
	if (defined( $self->{'sow'}->{'cfg'}->{'MAX_LOG'} )){
		$startline = scalar(@{$self->{'list'}}) - $self->{'sow'}->{'cfg'}->{'MAX_LOG'};
	}

	foreach $single (@{$self->{'list'}}) {
		next if ($single->{'delete'} > 0);
		next if ($single->{'indexno'}< $startline );
		print $fh join("<>", map{$single->{$_}}@$datalabel). "<>\n";
	}
}

#----------------------------------------
# データラベルの書き込み
#----------------------------------------
sub writelabel {
	my $self = shift;

	my $fh = $self->{'file'}->{'filehandle'};
	truncate($fh, 0);
	seek($fh, 0, 0);
	my $datalabel = $self->{'datalabel'};
	print $fh join("<>", @$datalabel). "<>\n";
}

#----------------------------------------
# ハッシュリストへの追記
#----------------------------------------
sub append {
	my ($self, $data) = @_;

	my $list = $self->{'list'};
	push(@$list, $data);
	$data->{'indexno'} = $#$list;
	$data->{'delete'}  = 0;
	$self->{'keys'}->{$data->{$self->{'datalabel'}->[0]}} = $data->{'indexno'};

	my $fh = $self->{'file'}->{'filehandle'};
	seek($fh, 0, 2);
	my $datalabel = $self->{'datalabel'};
	print $fh join("<>", map{$data->{$_}}@$datalabel). "<>\n";
}

#----------------------------------------
# ハッシュリストを取得
#----------------------------------------
sub getlist {
	my $self = shift;
	return $self->{'list'};
}

#----------------------------------------
# ハッシュリストの追加
#----------------------------------------
sub add {
	my ($self, $data, $nowrite) = @_;

	my $list = $self->{'list'};
	push(@$list, $data);
	$data->{'indexno'} = $#$list;
	$data->{'delete'}  = 0;
	$self->{'keys'}->{$data->{$self->{'datalabel'}->[0]}} = $data->{'indexno'};
	$self->write() if ((!defined($nowrite)) || ($nowrite == 0));
}

#----------------------------------------
# ハッシュリストの更新
#----------------------------------------
sub update {
	my ($self, $data, $indexno, $nowrite) = @_;
	$self->{'list'}->[$indexno] = $data;
	$data->{'indexno'} = $indexno;
	$self->{'keys'}->{$data->{$self->{'datalabel'}->[0]}} = $indexno;
	$data->{'delete'} = 0;
	$self->write() if ((!defined($nowrite)) || ($nowrite == 0));
}

#----------------------------------------
# ハッシュリストの削除
#----------------------------------------
sub delete {
	my ($self, $indexno) = @_;

	$self->{'list'}->[$indexno]->{'delete'} = 1;
	$self->update();
}

#----------------------------------------
# ハッシュリスト配列を消去する
#----------------------------------------
sub clear {
	my $self = shift;
	my @list = ();
	$self->{'list'} = \@list;
}

#----------------------------------------
# 指定したidのリスト番号を読み込む
#----------------------------------------
sub getbyid {
	my ($self, $id) = @_;
	my $indexno = -1;
	$indexno = $self->{'keys'}->{$id} if (defined($self->{'keys'}->{$id}));
	return $indexno;
}

#----------------------------------------
# ハッシュリストファイルを閉じる
#----------------------------------------
sub close {
	my $self = shift;
	$self->{'file'}->closefile();
}

1;
