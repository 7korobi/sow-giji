package SWScore;

#----------------------------------------
# �l�T���o�͊֘A�i�b��j
#----------------------------------------

# http://wolfbbs.jp/%BF%CD%CF%B5BBS%C9%E8.html �Q�ƁB
# ver/mikari 0.2�i�����@�B�ǌ`���j�x�[�X�B
# ��������o�͂̂݁B
# �����L�����Z�b�g�ɂ͖��Ή��B

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow, $vil, $mode) = @_;
	my $vid = $vil->{'vid'};
	my %list;
	my $self = {
		sow   => $sow,
		vil   => $vil,
		vid   => $vid,
		list  => \%list,
	};
	bless($self, $class);
	$vil->{'score'} = "" if (!defined($vil->{'score'}));

	return $self if ($sow->{'cfg'}->{'ENABLED_SCORE'} == 0);

	my $filename = $self->getfnamescore();
	my $modeid = '+<';
	$modeid = '>' if ($mode > 0);

	my $fh = \*SCORE;
	if (($mode > 0) || (-e $filename)) {
		my $file = SWFile->new($self->{'sow'}, 'score', $fh, $filename, $self);
		$file->openfile(
			$modeid,
			'�l�T���f�[�^',
			"[vid=$vid]",
		);
		$self->{'file'} = $file;
	}

	return $self;
}

#----------------------------------------
# �l�T���̏o��
#----------------------------------------
sub output {
	my $self = shift;
	return if ($sow->{'cfg'}->{'ENABLED_SCORE'} == 0);
	my $sow = $self->{'sow'};
	my $vid = $self->{'vid'};

	my $fh = $self->{'file'}->{'filehandle'};
	seek($fh, 0, 0);

	print "//jinro_bbs_score: SOW$vid\n";
	foreach (<$fh>) {
		print $_;
	}
	print "//jinro_bbs_score_end;\n";

	return;
}

#----------------------------------------
# �l�T���f�[�^�����
#----------------------------------------
sub close {
	my $self = shift;
	return if ($sow->{'cfg'}->{'ENABLED_SCORE'} == 0);
	return if (!defined($self->{'file'}));

	$self->{'file'}->closefile();
}

#----------------------------------------
# �l�T���f�[�^�̏������݁i�J�n���j
#----------------------------------------
sub writestart {
	my $self = shift;
	return if ($sow->{'cfg'}->{'ENABLED_SCORE'} == 0);
	return if (!defined($self->{'file'}));

	my $fh = $self->{'file'}->{'filehandle'};
	seek($fh, 0, 2);
}

sub addresult{
	my ($self, $mark, $target) = @_;
	
	my $list = $self->{'list'};
	my @listvalue;
	$list->{$mark} = \@listvalue if (!defined($list->{$mark}));
	push( @{$list->{$mark}}, $target );
	
	my $sow = $self->{'sow'};
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "�y".$mark."�z".$target );
}

sub write {
	my ($self, $turn) = @_;
	
	my $vil  = $self->{'vil'};
	my $sow  = $self->{'sow'};
	my $list = $self->{'list'};

	my $line = "|" . $turn . "d| ";
	my @key = keys( %$list );
	foreach( @key ){
		my $val = $list->{$_};
		$line .= "�y".$_."�z".join(' ', @$val ) if (scalar(@$val) > 0);
	}
	$line .= "|\n";
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, $line);
	$vil->{'score'} .= "<br>".$line;

	return if ($sow->{'cfg'}->{'ENABLED_SCORE'} == 0);
	return if (!defined($self->{'file'}));

	my $fh = $self->{'file'}->{'filehandle'};
	seek($fh, 0, 2);

	print $fh $line;
}


#----------------------------------------
# �l�T���f�[�^�t�@�C�����̎擾
#----------------------------------------
sub getfnamescore {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $vid = $self->{'vid'};

	$vid = 0 if ($vid eq '');

	my $datafile;
	$datafile = sprintf(
		"%s/%04d_%s",
		$sow->{'cfg'}->{'DIR_VIL'},
		$vid,
		$sow->{'cfg'}->{'FILE_SCORE'},
	);
	return $datafile;
}


1;