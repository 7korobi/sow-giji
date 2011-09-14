package SWUser;

#----------------------------------------
# ユーザーファイル制御
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow => $sow,
	};

	return bless($self, $class);
}

#----------------------------------------
# ユーザーデータファイル名の取得
#----------------------------------------
sub GetFNameUser {
	my $self = shift;

	my $encodename = &SWBase::EncodeURL($self->{'uid'});
	my $filename = "$self->{'sow'}->{'cfg'}->{'DIR_USER'}/$encodename.cgi";
	return $filename;
}

#----------------------------------------
# ユーザーデータラベル
#----------------------------------------
sub GetUserDataLabel {
	my @datalabel = (
		'uid',
		'pwd',
		'handlename',
		'remoteaddr',
		'addr01',
		'addr02',
		'addr03',
		'addr04',
		'addr05',
		'url',
		'introduction',
	);
	return @datalabel;
}

#----------------------------------------
# ユーザーデータファイルを開く
#----------------------------------------
sub openuser {
	my ($self, $chklogin) = @_;

	my $filename = $self->GetFNameUser();
	my $fh = \*USER;
	if ($chklogin == 0) {
		# 後で新規作成するためエラーを出さない
		$self->{'uid'} = '';
		$self->{'pwd'} = '';
		return -1 if !(-e $filename); # ファイルがない
	}

	# ユーザーデータを開く
	my $file = SWFile->new($self->{'sow'}, 'user', $fh, $filename, $self);
	$file->openfile(
		'+<',
		'ユーザーデータ',
		"[uid=$self->{'uid'}]",
	);
	$self->{'file'} = $file;

	seek($fh, 0, 0);
	my @data = <$fh>;

	my $datalabel = shift(@data);
	my @datalabel = split(/<>/, $datalabel);
	@datalabel = $self->GetUserDataLabel() if ($datalabel[0] eq '');
	@$self{@datalabel} = split(/<>/, $data[0]);

	# 移行用コード
	my @strdata = ('url', 'introduction', 'handlename');
	foreach (@strdata) {
		$self->{$_} = '' if (!defined($self->{$_}));
	}
	my @labelnew = $self->GetUserDataLabel();
	foreach (@labelnew) {
		$self->{$_} = 0 if ((!defined($self->{$_})) || ($self->{$_} eq ''));
	}
	foreach (@strdata) {
		$self->{$_} = '' if ($self->{$_} eq $self->{'sow'}->{'DATATEXT_NONE'});
	}

	return 0;
}

#----------------------------------------
# ユーザーデータ書き込み
#----------------------------------------
sub writeuser {
	my $self = shift;
	$self->{'remoteaddr'}  = $ENV{'REMOTE_ADDR'} if (defined($ENV{'REMOTE_ADDR'}));

	my $sow = $self->{'sow'};
	my $fh = $self->{'file'}->{'filehandle'};

	my @strdata = ('url', 'introduction', 'handlename');
	foreach (@strdata) {
		$self->{$_} = $self->{'sow'}->{'DATATEXT_NONE'} if ($self->{$_} eq '');
	}

	truncate($fh, 0);
	seek($fh, 0, 0);
	my @datalabel = $self->GetUserDataLabel();
	print $fh join("<>", @datalabel). "<>\n";
	print $fh join("<>", map{$self->{$_}}@datalabel). "<>\n";

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Edit User. [$self->{'uid'}]");

	foreach (@strdata) {
		$self->{$_} = '' if ($self->{$_} eq $self->{'sow'}->{'DATATEXT_NONE'});
	}
}

#----------------------------------------
# ユーザーデータファイルを閉じる
#----------------------------------------
sub closeuser {
	my $self = shift;
	$self->{'file'}->closefile() if (defined($self->{'file'}));
	return;
}

#----------------------------------------
# 通常認証
#----------------------------------------
sub LoginSW {
	my ($self, $chklogin) = @_;
	my $sow = $self->{'sow'};

	my $src = $sow->{'cookie'}; # クッキーからユーザーIDを取得
	$src = $sow->{'query'} if ($sow->{'outmode'} eq 'mb'); # 携帯モードの時は引数から取得
	$src = $sow->{'query'} if ($chklogin == 0); # ログイン処理の時は引数から取得
	if (!defined($src->{'uid'})) {
		$src->{'uid'} = '';
		$src->{'pwd'} = '';
	}
	$src->{'uid'} =~ s/^ *//;
	$src->{'uid'} =~ s/ *$//;

	my $lengthuid = length($src->{'uid'});
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "ユーザIDは $sow->{'cfg'}->{'MAXSIZE_USERID'} バイト以内で入力して下さい（$lengthuid バイト）。", "uid too long.") if ($lengthuid > $sow->{'cfg'}->{'MAXSIZE_USERID'});
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "ユーザIDは $sow->{'cfg'}->{'MINSIZE_USERID'} バイト以上で入力して下さい（$lengthuid バイト）。", "uid too short.") if (($lengthuid < $sow->{'cfg'}->{'MINSIZE_USERID'}) && ($lengthuid != 0));

	my $lengthpwd = length($src->{'pwd'});
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "パスワードは $sow->{'cfg'}->{'MAXSIZE_PASSWD'} バイト以内で入力して下さい（$lengthpwd バイト）。", "pwd too long.") if ($lengthpwd > $sow->{'cfg'}->{'MAXSIZE_PASSWD'});
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "パスワードは $sow->{'cfg'}->{'MINSIZE_PASSWD'} バイト以上で入力して下さい（$lengthpwd バイト）。", "pwd too short.") if (($lengthpwd < $sow->{'cfg'}->{'MINSIZE_PASSWD'}) && ($lengthuid > 0));

	$self->{'uid'}  = $src->{'uid'};
	$self->{'qpwd'} = $src->{'pwd'};
	$self->{'logined'} = $self->match($chklogin);

	return;
}

#----------------------------------------
# TypeKey認証
#----------------------------------------
sub LoginTypeKey {
	my ($self, $chklogin) = @_;
	my $sow = $self->{'sow'};

	# TypeKey認証
	eval 'use Authen::TypeKey;';
	$sow->{'debug'}->raise($sow->{'APLOG_WARNING'}, "Authen::TypeKeyモジュールが見つかりません。", "Authen::TypeKey not found.") if ($@ ne '');
	my $src = $sow->{'cookie'};
	$src = $sow->{'query'} if ($chklogin == 0);
	if (!defined($src->{'sig'})) {
		$src->{'uid'} = '';
		$src->{'sig'} = '';
	}

	if ($src->{'sig'} eq '') {
		if ($chklogin == 0) {
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "認証データがありません。", "typekey sig not found.");
		} else {
			$self->{'logined'} = -1;
			return;
		}
	}

	my $typekey = new Authen::TypeKey;
	$typekey->token($sow->{'cfg'}->{'TOKEN_TYPEKEY'});
	my $result = $typekey->verify($src);
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "ユーザIDかパスワードが間違っています。", $typekey->errstr()) if ($result ne '');
	$self->{'uid'}  = $src->{'name'};
	$self->{'nick'} = $src->{'nick'};

	$self->{'logined'} = 1;
	return;
}

#----------------------------------------
# ログイン情報の取得
#----------------------------------------
sub logined {
	my $self = shift;

	if (!defined($self->{'logined'})) {
		if ($self->{'sow'}->{'cfg'}->{'ENABLED_TYPEKEY'} > 0) {
			$self->LoginTypeKey(1);
		} else {
			$self->LoginSW(1);
		}
	}
	return $self->{'logined'};
}

#----------------------------------------
# ログイン情報の取得
#----------------------------------------
sub login {
	my $self = shift;

	if ($self->{'sow'}->{'cfg'}->{'ENABLED_TYPEKEY'} > 0) {
		$self->LoginTypeKey(0);
	} else {
		$self->LoginSW(0);
	}
	return $self->{'logined'};
}

#----------------------------------------
# パスワード照合
# [返し値]
# -1：引数のuidが値なし/引数のpwdが値なし
#     /ユーザーデータのpwdが値なし
#   　/ユーザーデータなし（$chklogin=0の時）
#  0：パスワードが違う
#  1：照合成功
#----------------------------------------
sub match {
	my ($self, $chklogin) = @_;
	my $sow = $self->{'sow'};

	return -1 if ($self->{'uid'} eq '');
	return -1 if ($self->{'qpwd'} eq '');

	$self->openuser($chklogin);

	my $pwmatch = 0;
	if ($self->{'pwd'} eq '') {
		$pwmatch = -1;
	} elsif ($self->{'pwd'} eq crypt($self->{'qpwd'}, $self->{'pwd'})) {
		if ( $self->iseasypassword()){
			$pwmatch = 1;
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "パスワードが脆弱です。<a href=\"http://www4.atpages.jp/lobby/sow.cgi?vid=5#newsay\">派出所</a>で報告してください。", "password unsafety.[$self->{'uid'}]");
		} else {
			$pwmatch = 1;
		}
		if ((defined($ENV{'REMOTE_ADDR'}))&&($self->{'remoteaddr'} ne $ENV{'REMOTE_ADDR'} )){
			$self->{'addr05'} = $self->{'addr04'} ;
			$self->{'addr04'} = $self->{'addr03'} ;
			$self->{'addr03'} = $self->{'addr02'} ;
			$self->{'addr02'} = $self->{'addr01'} ;
			$self->{'addr01'} = $self->{'remoteaddr'} ;
			$self->writeuser();
		}
	} else {
		$pwmatch = 0;
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "ユーザーIDかパスワードが間違っています。", "no match pass.[$self->{'uid'}]");
	}

	$self->closeuser();

	return $pwmatch;
}

sub iseasypassword {
	my ( $self ) = @_;
	return 1 if ($self->{'pwd'} eq crypt($self->{'uid'},$self->{'pwd'}));
	return 0;
}

#----------------------------------------
# クッキーデータのセット
#----------------------------------------
sub setcookie {
	my ($self, $setcookie) = @_;
	my $sow = $self->{'sow'};
	my $query = $sow->{'query'};
	if ($sow->{'cfg'}->{'ENABLED_TYPEKEY'} > 0) {
		my $nick = $query->{'nick'};
		&SWBase::JcodeConvert($sow, \$nick, 'sjis', 'utf8');
		$setcookie->{'name'} = $query->{'name'};
		$setcookie->{'nick'} = $nick;
		$setcookie->{'sig'}  = $query->{'sig'};
	} else {
		$setcookie->{'uid'} = $query->{'uid'};
		$setcookie->{'pwd'} = $query->{'pwd'};
	}

	return;
}

#----------------------------------------
# クッキーデータのリセット
#----------------------------------------
sub resetcookie {
	my ($self, $setcookie) = @_;

	my $query = $self->{'sow'}->{'query'};
	if ($self->{'sow'}->{'cfg'}->{'ENABLED_TYPEKEY'} > 0) {
		$setcookie->{'name'} = '';
		$setcookie->{'nick'} = '';
		$setcookie->{'sig'}  = '';
	} else {
		$setcookie->{'uid'} = '';
		$setcookie->{'pwd'} = '';
	}

	return;
}

#----------------------------------------
# ユーザーデータ追加
#----------------------------------------
sub createuser {
	my ($self, $uid, $qpwd) = @_;
	my $sow = $self->{'sow'};
	$self->{'uid'}  = $uid;
	$self->{'qpwd'} = $qpwd;

	$self->{'handlename'} = '';
	$self->{'url'} = '';
	$self->{'introduction'} = '';
	$self->{'addr01'} = '';
	$self->{'addr02'} = '';
	$self->{'addr03'} = '';
	$self->{'addr04'} = '';
	$self->{'addr05'} = '';

	my $filename = $self->GetFNameUser();

	my $fh = \*USER;
	my $file = SWFile->new($self->{'sow'}, 'user', $fh, $filename, $self);
	$file->openfile(
		'>',
		'ユーザーデータ',
		"[uid=$self->{'uid'}]",
	);

	my @datalabel = $self->GetUserDataLabel();
	$self->{'pwd'} = &GetCrypt($self->{'qpwd'});

	print $fh join("<>", @datalabel). "<>\n";
	print $fh join("<>", map{$self->{$_}}@datalabel). "<>\n";

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Add User. [$self->{'uid'}]");

	return;
}

#----------------------------------------
# ユーザーデータファイルの更新日時を得る
#----------------------------------------
sub getupdatedt {
	my $self = shift;
	my $filename = $self->GetFNameUser();

	return (stat($filename))[9];
}

#----------------------------------------
# 参加中の村データの取得
#----------------------------------------
sub getentriedvils {
	my $self = shift;

	my @entriedvils;
	my @label = ('vid', 'vname', 'chrname', 'playing');
	my @data = split('/', "$self->{'entriedvils'}/");

	foreach (@data) {
		my %entriedvil;
		@entriedvil{@label} = split(':', "$_:");
		next if (!defined($entriedvil{'vid'}));
		push(@entriedvils, \%entriedvil) if ($entriedvil{'vid'} > 0);
	}

	return \@entriedvils;
}

#----------------------------------------
# 指定した参加中の村データを追加／更新
#----------------------------------------
sub setentriedvil {
	my ($self, $entriedvil) = @_;

	my $entriedvils = $self->getentriedvils();
	my $set = 0;
	my $i;
	for ($i = 0; $i < @$entriedvils; $i++) {
		next if ($entriedvils->[$i]->{'vid'} != $entriedvil->{'vid'});
		$entriedvils->[$i] = $entriedvil;
		$set++;
	}
	if ($set == 0) {
		push(@$entriedvils, $entriedvil);
	}

	$self->updateentriedvil($entriedvils);
}

#----------------------------------------
# 参加中の村データを更新
#----------------------------------------
sub updateentriedvil {
	my ($self, $entriedvils) = @_;

	my @label = ('vid', 'vname', 'chrname', 'playing');
	my ($entriedvil, @data);
	foreach $entriedvil (@$entriedvils) {
		next if ($entriedvil->{'vid'} == 0);
		next if ($entriedvil->{'playing'} < 0);
		push(@data, join(':', map{$entriedvil->{$_}}@label));
	}
	push(@data, '0:0:0') if (@data == 0); # ダミー
#	$self->{'entriedvils'} = join('/', @data);
	$self->{'entriedvils'} = '';
}

#----------------------------------------
# 参加中の村データを更新（データセットから書き込みまで）
#----------------------------------------
sub writeentriedvil {
	my ($self, $uid, $vid, $vname, $chrname, $playing, $nowrite) = @_;

	my %entriedvil = (
		vid     => $vid,
		vname   => $vname,
		chrname => $chrname,
		playing => $playing,
	);
	$self->{'uid'} = $uid;
	$self->openuser(1);
	$self->setentriedvil(\%entriedvil);
	if ((!defined($nowrite)) || ($nowrite == 0)) {
		$self->writeuser();
		$self->closeuser()
	}
}

#----------------------------------------
# 暗号文の取得（MD5/DES）
#----------------------------------------
sub GetCrypt {
	my $salt = &GetSalt();

	my $crypted = crypt($_[0], '$1$' . $salt . '$'); # MD5
	$crypted = crypt($_[0], $salt) if (substr($crypted, 0, 3) ne '$1$'); # 標準（たいていDES）

	return $crypted;
}

#----------------------------------------
# SALT の取得
#----------------------------------------
sub GetSalt {
	my @CHARSET_BASE64 = ('.', '/', '0'..'9', 'A'..'Z', 'a'..'z');
	my $salt;

	for ($i = 0; $i < 8; $i++) {
		$salt .= $CHARSET_BASE64[rand(@CHARSET_BASE64)];
	}
	return $salt;
}

1;
