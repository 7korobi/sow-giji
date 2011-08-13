package SWHashList;

#----------------------------------------
# �n�b�V�����X�g�t�@�C������
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
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
# �n�b�V�����X�g�̎擾
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
# �n�b�V�����X�g�̏�������
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
# �f�[�^���x���̏�������
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
# �n�b�V�����X�g�ւ̒ǋL
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
# �n�b�V�����X�g���擾
#----------------------------------------
sub getlist {
	my $self = shift;
	return $self->{'list'};
}

#----------------------------------------
# �n�b�V�����X�g�̒ǉ�
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
# �n�b�V�����X�g�̍X�V
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
# �n�b�V�����X�g�̍폜
#----------------------------------------
sub delete {
	my ($self, $indexno) = @_;

	$self->{'list'}->[$indexno]->{'delete'} = 1;
	$self->update();
}

#----------------------------------------
# �n�b�V�����X�g�z�����������
#----------------------------------------
sub clear {
	my $self = shift;
	my @list = ();
	$self->{'list'} = \@list;
}

#----------------------------------------
# �w�肵��id�̃��X�g�ԍ���ǂݍ���
#----------------------------------------
sub getbyid {
	my ($self, $id) = @_;
	my $indexno = -1;
	$indexno = $self->{'keys'}->{$id} if (defined($self->{'keys'}->{$id}));
	return $indexno;
}

#----------------------------------------
# �n�b�V�����X�g�t�@�C�������
#----------------------------------------
sub close {
	my $self = shift;
	$self->{'file'}->closefile();
}

1;
