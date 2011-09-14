package SWFileSWGrobal;

#----------------------------------------
# SWBBS全体管理用データファイル制御
#----------------------------------------

#----------------------------------------
# SWBBS全体管理用データラベル
#----------------------------------------
sub GetSWGrobalDataLabel {
	my @datalabel = (
		'vlastid',
	);
	return @datalabel;
}

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
	};

	return bless($self, $class);
}

#----------------------------------------
# SWBBS全体管理用データファイルを開く
#----------------------------------------
sub openmw {
	my $self = shift;
	my $fh = \*SWGROBAL;
	my $filename = "$self->{'sow'}->{'cfg'}->{'FILE_SOWGROBAL'}";

	# ファイルを開く
	my $file = SWFile->new($self->{'sow'}, 'sowgrobal', $fh, $filename, $self);
	if (!(-e $filename)) {
		$file->openfile('>', '村一覧', ''); # 新規作成
	}
	$file->openfile(
		'+<',
		'管理データ',
		''
	);
	$self->{'file'} = $file;

	seek($fh, 0, 0);
	my @data = <$fh>;

	@data = ('<>', '<>') if (@data == 0);
	my $datalabel = shift(@data);
	my @datalabel = split(/<>/, $datalabel);
	@datalabel = &GetSWGrobalDataLabel() if (!defined($datalabel[0]));
	@$self{@datalabel} = split(/<>/, shift(@data));

	return;
}

#----------------------------------------
# SWBBS全体管理用の書き込み
#----------------------------------------
sub writemw {
	my $self = shift;

	my $fh = $self->{'file'}->{'filehandle'};
	truncate($fh, 0);
	seek($fh, 0, 0);

	@datalabel = &GetSWGrobalDataLabel();
	print $fh join("<>", @datalabel). "<>\n";
	print $fh join("<>", map{$self->{$_}}@datalabel). "<>\n";

	return;
}

#----------------------------------------
# SWBBS全体管理用データファイルを閉じる
#----------------------------------------
sub closemw {
	my $self = shift;
	$self->{'file'}->closefile();
	return;
}

1;