package SWLock;

#----------------------------------------
# ファイルロック用基本ライブラリ
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow      => $sow,
		lock     => '',
		filename => '',
		vid      => sprintf("%04d", $sow->{'query'}->{'vid'}) ,
	};
	my $lockname = $sow->{'cfg'}->{'FILE_LOCK'} . $self->{'vid'};

	if (-e $lockname){
		# $sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, 'ファイルロックに失敗しました。', 'lockfile not found.'); # ファイルがない
	} else {
		open (LOCK, ">$lockname");
		close(LOCK);
	}

	return bless($self, $class);
}

#----------------------------------------
# ファイルのロック
#----------------------------------------
sub glock {
	my $self = shift;
	my $sow = $self->{'sow'};

	my @sig = ('INT', 'HUP', 'QUIT', 'TERM', 'PIPE', 'DIE');

	foreach (@sig) {
		if (defined($SIG{$_})) {
			$SIG{$_} = \&gunlock($self);
		}
	}
	$SIG{ALRM} = sub {
		$self->gunlock();
		$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "30秒待ってやり直してください。同村者の処理に長く時間がかかっています。", "too long lock. anyone process more than 30 sec.");
		die "timeout";
	};

	alarm(5);  # 先行プロセスを待つ時間（5sec）

	if ($sow->{'cfg'}->{'ENABLED_GLOCK'} == 0) {
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, 'no lock.[Lock]');
		return;
	} elsif ($sow->{'cfg'}->{'ENABLED_GLOCK'} == 1) {
		$self->gflock();
	} else {
		$self->glockr();
	}

	alarm(30); # 自分自身の制限時間（30sec）
}

#----------------------------------------
# ファイルロック解除
#----------------------------------------
sub gunlock {
	my $self = shift;
	my $sow = $self->{'sow'};

	if ($sow->{'cfg'}->{'ENABLED_GLOCK'} == 0) {
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, 'no lock.[Unlock]');
		return;
	} elsif ($sow->{'cfg'}->{'ENABLED_GLOCK'} == 1) {
		$self->gunflock();
	} else {
		$self->gunlockr();
	}
	alarm(0); # 無事済んだのでリセット
}

#----------------------------------------
# ファイルのロック（flock）
#----------------------------------------
sub gflock {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $lockname = $sow->{'cfg'}->{'FILE_LOCK'} . $self->{'vid'};

	open (LOCK, "+<$lockname") || $sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, 'ファイルロックに失敗しました。', 'lockfile could not open.');
	flock(LOCK, 2);

	$self->{'lock'} = 'lock';
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, 'locked.[flock]');
}

#----------------------------------------
# ファイルロック解除（flock）
#----------------------------------------
sub gunflock {
	my $self = shift;
	my $sow = $self->{'sow'};

	if ($self->{'lock'} eq 'lock') {
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, 'unlock.[flock]');
		close(LOCK);
		$self->{'lock'} = '';
	}
}

#----------------------------------------
# ファイルのロック（rename）
#----------------------------------------
sub glockr {
	my $self = shift;
	my $sow = $self->{'sow'};

	my $result = $self->gunlockrtimeout(); # 古いロックの解除

	my $lockname = $sow->{'cfg'}->{'FILE_LOCK'};
	my $fname = "$lockname$ENV{'REMOTE_PORT'}-$$";

	my $i;
	for ($i = 0; $i < 10; $i++) {
		rename($lockname, $fname);
		last if (-e $fname);
		select(undef, undef, undef, 0.1);
	}
	if ($i == 10) {
		$sow->{'debug'}->raise($sow->{'APLOG_OTHERS'}, 'アクセスが混み合っています。しばらくしてからもう一度おためし下さい。', 'file is locking.');
	}

	open(LOCK, ">$fname");
	truncate(LOCK, 0);
	seek(LOCK, 0, 0);
	print LOCK "$sow->{'time'}\n";
	close(LOCK);

	$self->{'lock'} = 'lock';
	$self->{'filename'} = $fname;

	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, 'unlock.[rename, timeout: "$result"]') if ($result ne '');
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, 'locked.[rename]');
}

#----------------------------------------
# ファイルのロック解除（rename）
#----------------------------------------
sub gunlockr {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $lockname = $sow->{'cfg'}->{'FILE_LOCK'};

	if ($self->{'lock'} eq 'lock') {
		$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, 'unlock.[rename]');
		my $fname = $self->{'filename'};
		rename($fname, $lockname);
		$self->{'lock'} = '';
	}
}

#----------------------------------------
# 古いロックの解除（rename）
#----------------------------------------
sub gunlockrtimeout {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $lockname = $sow->{'cfg'}->{'FILE_LOCK'};

	return "" if (-e $lockname);

	$sow->{'cfg'}->{'FILE_LOCK'} =~ /\/[^\/]*\z/;
	my $fname = substr($&, 1);
	my $dir = $`;
	opendir(LOCKDIR, $dir);
	my @files = readdir(LOCKDIR);
	closedir(LOCKDIR);

	my $result = '';
	foreach (@files) {
		next if (index($_, $fname) < 0);

		my $timeout = (stat("$dir/$_"))[9] + $sow->{'cfg'}->{'TIMEOUT_GLOCK'};
		if ($sow->{'time'} > $timeout) {
			rename ("$dir/$_", $lockname);
			$result = "$dir/$_";
		}
	}

	return $result;
}

1;
