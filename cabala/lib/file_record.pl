package SWUserRecord;

#----------------------------------------
# ��уf�[�^�L�^
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow, $uid, $append) = @_;
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_hashlist.pl";

	my $self = {
		sow      => $sow,
		version  => ' 1.0',
		uid      => $uid,
		startpos => 0,
	};
	bless($self, $class);

	# ��уf�[�^�t�@�C���̐V�K�쐬�^�J��
	my $fnameuserrecord = $self->getfnameuserrecord();
	my $mode = 1; # �V�K�쐬
	$mode = 0 if (-e $fnameuserrecord); # �ǉ��^�X�V
	$append = 0 if (!defined($append));
	my @userrecorddatalabel = $self->getuserrecorddatalabel();
	$self->{'file'} = SWHashList->new(
		$sow,
		$fnameuserrecord,
		\*MEMOINDEX,
		'userrecord',
		\@userrecorddatalabel,
		'��уf�[�^',
		"",
		$mode,
		$self->{'version'},
	);
	$self->{'file'}->read() if (($mode == 0) && ($append == 0));
	$self->{'file'}->writelabel() if ($mode == 1);

	return $self;
}

#----------------------------------------
# ��уf�[�^���Z�b�g
#----------------------------------------
sub set {
	my ($self, $vil, $plsingle) = @_;
	my $sow = $self->{'sow'};

	my $liveday = $vil->{'turn'};
	$liveday = $vil->{'epilogue'} if ($vil->{'turn'} > $vil->{'epilogue'});
	$liveday = $plsingle->{'deathday'} - 1 if ($plsingle->{'deathday'} > 0);

	# ������
	my @otherpl;
	my $pllist = $vil->getpllist();
	my $draw = 0;
	foreach (@$pllist) {
		$draw = 1 if ($_->{'live'} eq 'live');
	}
	$draw = 0 if ($vil->{'winner'} != 0);
	my $win = $plsingle->iswin();
	$win = -1 if ($draw > 0);

	foreach (@$pllist) {
		next if ($_->{'uid'} eq $plsingle->{'uid'});
		my $otherplwin = 0;
		$otherplwin = $win if ($win != $_->iswin());
		$otherplwin = -1 if (($_->{'live'} eq 'suddendead') || ($draw > 0));
		push(@otherpl, "$_->{'uid'}:" . $otherplwin);
	}

	# �J
	my $bondpl = $self->getbonduidlist($vil, $plsingle, 'bonds');
	my $bonds = '/';
	$bonds = join('/', @$bondpl) if (@$bondpl > 0);

	# ���l
	my $loverpl = $self->getbonduidlist($vil, $plsingle, 'lovers');
	my $lovers = '/';
	$lovers = join('/', @$loverpl) if (@$loverpl > 0);

	my %userrecord = (
#		vid       => $vil->{'vid'},
#		vname     => $vil->{'vname'},
#		csid      => $plsingle->{'csid'},
#		cid       => $plsingle->{'cid'},
#		chrname   => $plsingle->getchrname(),
#		win       => $win,
#		role      => $plsingle->{'role'},
#		rolesubid => $plsingle->{'rolesubid'},
#		liveday   => $liveday,
#		live      => $plsingle->{'live'},
#		otherpl   => join('/', @otherpl),
#		bonds     => $bonds,
#		lovers    => $lovers,
	);

	return \%userrecord;
}

#----------------------------------------
# ��уf�[�^��ǉ�
#----------------------------------------
sub add {
	my ($self, $vil, $plsingle) = @_;
#	my $userrecord = $self->set($vil, $plsingle);
#	$self->{'file'}->add($userrecord);

	return;
}

#----------------------------------------
# ��уf�[�^��ǋL
#----------------------------------------
sub append {
	my ($self, $vil, $plsingle) = @_;
#	my $userrecord = $self->set($vil, $plsingle);
#	$self->{'file'}->append($userrecord);

	return;
}

#----------------------------------------
# ��уf�[�^���X�V
#----------------------------------------
sub update {
	my ($self, $vil, $plsingle, $indexno) = @_;
#	my $userrecord = $self->set($vil, $plsingle);
#	$self->{'file'}->update($userrecord, $indexno);

	return;
}

#----------------------------------------
# �J�^���l�v���C���[��uid���X�g���擾
#----------------------------------------
sub getbonduidlist {
	my ($self, $vil, $plsingle, $key) = @_;
	my $sow = $self->{'sow'};

	my @bondpl;
	if ($plsingle->{$key} ne '') {
		my @bonds = split('/', $plsingle->{$key} . '/');
		foreach (@bonds) {
			my $bondpl = $vil->getplbypno($_);
			push(@bondpl, "$bondpl->{'uid'}:" . $bondpl->getlongchrname());
		}
	}

	return \@bondpl;
}

#----------------------------------------
# ��уf�[�^�t�@�C�����̎擾
#----------------------------------------
sub getfnameuserrecord {
	my $self = shift;

	my $encodename = &SWBase::EncodeURL($self->{'uid'});
	my $datafile = sprintf(
		"%s/%s.cgi",
		$self->{'sow'}->{'cfg'}->{'DIR_RECORD'},
		$encodename,
	);
	return $datafile;
}

#----------------------------------------
# ��уf�[�^���x��
#----------------------------------------
sub getuserrecorddatalabel {
	my $self = shift;
	my @datalabel;

	# Version 1.0
	@datalabel = (
		'vid',
		'vname',
		'csid',
		'cid',
		'chrname',
		'win',
		'role',
		'rolesubid',
		'liveday',
		'live',
		'otherpl',
		'bonds',
		'lovers',
	);

	return @datalabel;		
}

#----------------------------------------
# ��уf�[�^�t�@�C�������
#----------------------------------------
sub close {
	my $self = shift;
	$self->{'file'}->close();
	return;
}

1;