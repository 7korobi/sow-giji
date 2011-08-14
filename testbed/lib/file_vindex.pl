package SWFileVIndex;

#----------------------------------------
# ���ꗗ�f�[�^�t�@�C������
#----------------------------------------

#----------------------------------------
# ���ꗗ�f�[�^���x��
#----------------------------------------
sub GetVIndexDataLabel {
	my @datalabel = (
		'vid',
		'vname',
		'vcomment',
		'makeruid',
		'updhour',
		'updminite',
		'vstatus',
		'createdt',
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
# ���ꗗ�f�[�^�t�@�C���̍X�V�����𓾂�
#----------------------------------------
sub getupdatedt {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $filename = "$sow->{'cfg'}->{'FILE_VINDEX'}";

	return (stat($filename))[9];
}

#----------------------------------------
# ���ꗗ�f�[�^�t�@�C�����J��
#----------------------------------------
sub openvindex {
	my ($self, $create) = @_;
	my $sow = $self->{'sow'};
	my $fh = \*VINDEX;
	my $filename = "$sow->{'cfg'}->{'FILE_VINDEX'}";

	# �t�@�C�����J��
	my $file = SWFile->new($self->{'sow'}, 'vindex', $fh, $filename, $self);
	$create = 0 if (!defined($create));
	if ((!(-e $filename)) || ($create > 0)){
		$file->openfile('>', '���ꗗ', ''); # �V�K�쐬
	}
	$file->openfile(
		'+<',
		'���ꗗ',
		'',
	);
	$self->{'file'} = $file;

	seek($fh, 0, 0);
	my @data = <$fh>;

	# �f�[�^���x���̓ǂݍ���
	@data = ('<>') if (@data == 0);
	my $datalabel = shift(@data);
	my @datalabel = split(/<>/, $datalabel);
	@datalabel = $self->GetVIndexDataLabel() if (!defined($datalabel[0]));

	# �f�[�^�̓ǂݍ���
	my $i = 0;
	my $datacnt = @data;
	my @vilist;
	my %vi;
	while ($i < $datacnt) {
		my %vindexsingle;
		chomp($data[$i]);
		$vindexsingle{'delete'} = 0; # �폜�p
		@vindexsingle{@datalabel} = split(/<>/, $data[$i]);

		# �z��ɃZ�b�g
		$vilist[$i] = \%vindexsingle;
		$vi{$vindexsingle{'vid'}} = \%vindexsingle;
		$i++;
	}
	$self->{'vilist'} = \@vilist;
	$self->{'vi'}     = \%vi;

	return \%vindex;
}

#----------------------------------------
# ���ꗗ�f�[�^�֒ǉ�
#----------------------------------------
sub addvindex {
	my ($self, $vil) = @_;

	my %vindexsingle = (
		vid       => $vil->{'vid'},
		vname     => $vil->{'vname'},
		makeruid  => $vil->{'makeruid'},
		createdt  => $self->{'sow'}->{'time'},
		updhour   => $vil->{'updhour'},
		updminite => $vil->{'updminite'},
		vstatus   => $vil->getvstatus(),
		delete    => 0,
	);

	my $vilist = $self->{'vilist'};
	unshift(@$vilist, \%vindexsingle);
	return;
}

#----------------------------------------
# ���ꗗ�f�[�^�̔z��𓾂�
#----------------------------------------
sub getvilist {
	my $self = shift;
	return $self->{'vilist'};
}

#----------------------------------------
# ���ݕ�W���^�i�s���^�G�s���[�O���̑��̐����擾
#----------------------------------------
sub getactivevcnt {
	my $self = shift;
	my $vcnt = 0;

	foreach (@{$self->{'vilist'}}) {
		$vcnt++ if (($_->{'vstatus'} != $self->{'sow'}->{'VSTATUSID_END'}) && ($_->{'vstatus'} != $self->{'sow'}->{'VSTATUSID_SCRAPEND'}));
	}

	return $vcnt;
}

#----------------------------------------
# vid�Ŏw�肵�����ꗗ�f�[�^�𓾂�
#----------------------------------------
sub getvindex {
	my ($self, $vid) = @_;
	return $self->{'vi'}->{$vid};
}

#----------------------------------------
# ���ꗗ�f�[�^�̏�������
#----------------------------------------
sub writevindex {
	my $self = shift;

	my $fh = $self->{'file'}->{'filehandle'};
	truncate($fh, 0);
	seek($fh, 0, 0);

	my @datalabel = $self->GetVIndexDataLabel();

	print $fh join("<>", @datalabel). "<>\n";

	my $vilist = $self->{'vilist'};
	my $vindexsingle = '';
	foreach $vindexsingle (@$vilist) {
		next if ($vindexsingle->{'delete'} > 0); # �폜
		print $fh join("<>", map{$vindexsingle->{$_}}@datalabel). "<>\n";
	}
}

#----------------------------------------
# ���ꗗ���X�V
#----------------------------------------
sub updatevindex {
	my ($self, $vil, $vstatus) = @_;

	my $vindexsingle = $self->getvindex($vil->{'vid'});
	$vindexsingle->{'vname'}     = $vil->{'vname'};
	$vindexsingle->{'updhour'}   = $vil->{'updhour'};
	$vindexsingle->{'updminite'} = $vil->{'updminite'};
	$vindexsingle->{'vstatus'}   = $vstatus;

	$self->writevindex();
	return;
}

#----------------------------------------
# ���ꗗ�f�[�^�t�@�C�������
#----------------------------------------
sub closevindex {
	my $self = shift;
	$self->{'file'}->closefile();
	return;
}

1;