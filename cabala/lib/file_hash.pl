package SWFileHash;

#----------------------------------------
# SWBBS 単純ハッシュデータファイル制御
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

	foreach (@$datalabel) {
		$self->{$_} = 0;
	}

	return $self;
}

#----------------------------------------
# 単純ハッシュデータの読み込み
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
	@$self{@$datalabel} = split(/<>/, shift(@data)) if (@data > 0);

	return;
}

#----------------------------------------
# 単純ハッシュデータの書き込み
#----------------------------------------
sub write {
	my $self = shift;

	my $fh = $self->{'file'}->{'filehandle'};
	truncate($fh, 0);
	seek($fh, 0, 0);

	my $datalabel = $self->{'datalabel'};
	print $fh join("<>", @$datalabel). "<>\n";
	print $fh join("<>", map{$self->{$_}}@$datalabel). "<>\n";
	return;
}

#----------------------------------------
# 単純ハッシュデータを閉じる
#----------------------------------------
sub close {
	my $self = shift;
	$self->{'file'}->closefile();
}

1;
