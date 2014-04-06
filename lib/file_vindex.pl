package SWFileVIndex;

#----------------------------------------
# 村一覧データファイル制御
#----------------------------------------

#----------------------------------------
# 村一覧データラベル
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
# 村一覧データファイルの更新日時を得る
#----------------------------------------
sub getupdatedt {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $filename = "$sow->{'cfg'}->{'FILE_VINDEX'}";

	return (stat($filename))[9];
}

#----------------------------------------
# 村一覧データファイルを開く
#----------------------------------------
sub openvindex {
	my ($self, $create) = @_;
	my $sow = $self->{'sow'};
	my $fh = \*VINDEX;
	my $filename = "$sow->{'cfg'}->{'FILE_VINDEX'}";

	# ファイルを開く
	my $file = SWFile->new($self->{'sow'}, 'vindex', $fh, $filename, $self);
	$create = 0 if (!defined($create));
	if ((!(-e $filename)) || ($create > 0)){
		$file->openfile('>', '村一覧', ''); # 新規作成
	}
	$file->openfile(
		'+<',
		'村一覧',
		'',
	);
	$self->{'file'} = $file;

	seek($fh, 0, 0);
	my @data = <$fh>;

	# データラベルの読み込み
	@data = ('<>') if (@data == 0);
	my $datalabel = shift(@data);
	my @datalabel = split(/<>/, $datalabel);
	@datalabel = $self->GetVIndexDataLabel() if (!defined($datalabel[0]));

	# データの読み込み
	my $i = 0;
	my $datacnt = @data;
	my @vilist;
	my %vi;
	while ($i < $datacnt) {
		my %vindexsingle;
		chomp($data[$i]);
		$vindexsingle{'delete'} = 0; # 削除用
		@vindexsingle{@datalabel} = split(/<>/, $data[$i]);

		# 配列にセット
		$vilist[$i] = \%vindexsingle;
		$vi{$vindexsingle{'vid'}} = \%vindexsingle;
		$i++;
	}
	$self->{'vilist'} = \@vilist;
	$self->{'vi'}     = \%vi;

	return \%vindex;
}

#----------------------------------------
# 村一覧データへ追加
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
# 村一覧データの配列を得る
#----------------------------------------
sub getvilist {
	my $self = shift;
	return $self->{'vilist'};
}

#----------------------------------------
# 現在募集中／進行中／エピローグ中の村の数を取得
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
# vidで指定した村一覧データを得る
#----------------------------------------
sub getvindex {
	my ($self, $vid) = @_;
	return $self->{'vi'}->{$vid};
}

#----------------------------------------
# 村一覧データの書き込み
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
		next if ($vindexsingle->{'delete'} > 0); # 削除
		print $fh join("<>", map{$vindexsingle->{$_}}@datalabel). "<>\n";
	}
}

#----------------------------------------
# 村一覧情報更新
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
# 村一覧データファイルを閉じる
#----------------------------------------
sub closevindex {
	my $self = shift;
	$self->{'file'}->closefile();
	return;
}

1;