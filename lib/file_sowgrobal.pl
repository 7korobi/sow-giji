package SWFileSWGrobal;

#----------------------------------------
# SWBBS�S�̊Ǘ��p�f�[�^�t�@�C������
#----------------------------------------

#----------------------------------------
# SWBBS�S�̊Ǘ��p�f�[�^���x��
#----------------------------------------
sub GetSWGrobalDataLabel {
	my @datalabel = (
		'vlastid',
	);
	return @datalabel;
}

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
	};

	return bless($self, $class);
}

#----------------------------------------
# SWBBS�S�̊Ǘ��p�f�[�^�t�@�C�����J��
#----------------------------------------
sub openmw {
	my $self = shift;
	my $fh = \*SWGROBAL;
	my $filename = "$self->{'sow'}->{'cfg'}->{'FILE_SOWGROBAL'}";

	# �t�@�C�����J��
	my $file = SWFile->new($self->{'sow'}, 'sowgrobal', $fh, $filename, $self);
	if (!(-e $filename)) {
		$file->openfile('>', '���ꗗ', ''); # �V�K�쐬
	}
	$file->openfile(
		'+<',
		'�Ǘ��f�[�^',
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
# SWBBS�S�̊Ǘ��p�̏�������
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
# SWBBS�S�̊Ǘ��p�f�[�^�t�@�C�������
#----------------------------------------
sub closemw {
	my $self = shift;
	$self->{'file'}->closefile();
	return;
}

1;