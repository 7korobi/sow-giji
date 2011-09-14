package SWFile;

#----------------------------------------
# ファイルアクセス用基本ライブラリ
#----------------------------------------

#----------------------------------------
# コンストラクタ
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
# ファイルを開く
#----------------------------------------
sub openfile {
	my ($self, $rw, $mesname, $mesop) = @_;
	my $sow = $self->{'sow'};

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "$mesname が見つかりません。", "$self->{'fileid'} not found.$mesop") if (!(-e $self->{'filename'}) && (index($rw, '<') >= 0)); # 読み込みモードでファイルが見つからない時

	my $mesexemode1 = 'が開けません';
	my $mesexemode2 = 'could not open.';
	if (index($rw, '>') >= 0) {
		$mesexemode1 = 'が作成できません';
		$mesexemode2 = 'could not create.';
	}

	# ファイルを開く
	my $fh = $self->{'filehandle'};
	open ($fh, "$rw$self->{'filename'}") || $sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, "$mesname $mesexemode1", "$self->{'fileid'} $mesexemode2 $mesop");

	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "opened. [$self->{'fileid'}]");

	$self->{'open'} = 'open';
	$self->{'size'} = -s $self->{'filename'};
	$sow->{'file'}->{$self->{'fileid'}} = $self;

	return;
}

#----------------------------------------
# ファイルを閉じる
#----------------------------------------
sub closefile {
	my $self = shift;
	my $sow = $self->{'sow'};

	if ($self->{'open'} eq 'open') {
		# ファイルを閉じる
		close($self->{'filehandle'});
		$self->{'open'} = 'close';

		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "closed. [$self->{'fileid'}]");
	}
}

1;