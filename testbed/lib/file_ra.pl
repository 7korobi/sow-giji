package SWBoaRandomAccess;

#----------------------------------------
# SWBBS Boa Random Access Driver
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
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
# �f�[�^�t�@�C���̍쐬
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
# �f�[�^�t�@�C�����J��
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
# ID����f�[�^���R�[�h���擾����
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
# �f�[�^���R�[�h��ǉ�����
#----------------------------------------
sub add {
	my ($self, $data) = @_;

	my $fh = $self->{'file'}->{'filehandle'};
	seek($fh, 0, 2);
	$data->{'pos'} = tell($fh);
	$self->update($data);
}

#----------------------------------------
# �f�[�^���R�[�h����������
#----------------------------------------
sub update {
	my ($self, $data) = @_;

	# �������݈ʒu�ֈړ�
	my $fh  = $self->{'file'}->{'filehandle'};
	seek($fh, $data->{'pos'}, 0);

	# ��������
	print $fh join("<>", map{$data->{$_}}@{$self->{'datalabel'}}). "<>\n";

	# ���̏������݈ʒu��ۑ�
	$self->{'prevpos'} = $data->{'pos'};
	my $nextpos = tell($fh);
	$data->{'nextpos'} = $nextpos;

	return $pos;
}

#----------------------------------------
# �f�[�^���R�[�h���폜����
#----------------------------------------
sub delete {
	# ������
}

#----------------------------------------
# �f�[�^�t�@�C�������
#----------------------------------------
sub close {
	my $self = shift;
	$self->{'file'}->closefile();
}

1;