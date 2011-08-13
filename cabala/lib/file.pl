package SWFile;

#----------------------------------------
# �t�@�C���A�N�Z�X�p��{���C�u����
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow, $fileid, $fh, $fname, $parent) = @_;
	my $self = {
		sow      => $sow,
		parent     => $parent,
		fileid     => $fileid,
		filehandle => $fh,
		filename   => $fname,
		open       => 'close',
		size       => 0,
	};

	return bless($self, $class);
}

#----------------------------------------
# �t�@�C�����J��
#----------------------------------------
sub openfile {
	my ($self, $rw, $mesname, $mesop) = @_;
	my $sow = $self->{'sow'};

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "$mesname ��������܂���B", "$self->{'fileid'} not found.$mesop") if (!(-e $self->{'filename'}) && (index($rw, '<') >= 0)); # �ǂݍ��݃��[�h�Ńt�@�C����������Ȃ���

	my $mesexemode1 = '���J���܂���';
	my $mesexemode2 = 'could not open.';
	if (index($rw, '>') >= 0) {
		$mesexemode1 = '���쐬�ł��܂���';
		$mesexemode2 = 'could not create.';
	}

	# �t�@�C�����J��
	my $fh = $self->{'filehandle'};
	open ($fh, "$rw$self->{'filename'}") || $sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, "$mesname $mesexemode1", "$self->{'fileid'} $mesexemode2 $mesop");

	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "opened. [$self->{'fileid'}]");

	$self->{'open'} = 'open';
	$self->{'size'} = -s $self->{'filename'};
	$sow->{'file'}->{$self->{'fileid'}} = $self;

	return;
}

#----------------------------------------
# �t�@�C�������
#----------------------------------------
sub closefile {
	my $self = shift;
	my $sow = $self->{'sow'};

	if ($self->{'open'} eq 'open') {
		# �t�@�C�������
		close($self->{'filehandle'});
		$self->{'open'} = 'close';

		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "closed. [$self->{'fileid'}]");
	}
}

1;