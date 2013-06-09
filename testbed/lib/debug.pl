package SWDebug;

#----------------------------------------
# デバッグ用関連
#----------------------------------------
# APLOG_WARNING: 保険としてエラーが出るコードは書いているが、本来発生しないはずのエラー（未定義や設定ミスが原因のもの）
# APLOG_CAUTION: 不正操作が原因と思われるエラー
# APLOG_NOTICE: 操作ミスによるエラー
# APLOG_POSTED: 操作ログ
# APLOG_OTHERS: わりとどうでもいい報告

# LEVEL_APLOG
# 0: アプリケーションログを吐かない
# 1: APLOG_WARNING と APLOG_CAUTION のみ出力
# 2: 1に加え APLOG_NOTICE も出力
# 3: 2に加え APLOG_POSTED も出力
# 4: 全て出力
# 5: sow.cgiへの全てのアクセスに対して QUERY_STRING と cookie を出力

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow => $sow,
		check => 'check',
		checklogin => 0,
		error => 0,
	};

	return bless($self, $class);
}

#----------------------------------------
# エラー発生
#----------------------------------------
sub raise {
	my ($self, $level, $mes1, $mes2, $mes3, $mes4) = @_;
	my $sow = $self->{'sow'};

	$self->writeaplog($level, $mes2);
	$sow->{'lock'}->gunlock();
	$sow->{'user'}->resetcookie($sow->{'setcookie'}) if ($self->{'checklogin'} > 0);
	$self->OutHTMLError($mes1, $mes2, $mes3, $mes4);
}

#----------------------------------------
# アプリケーションログ書き込み
#----------------------------------------
sub writeaplog {
	my ($self, $type, $mes) = @_;
	my $sow = $self->{'sow'};

	return if ($sow->{'cfg'}->{'ENABLED_APLOG'} == 0);

	my $level = $sow->{'cfg'}->{'LEVEL_APLOG'};
	return if ($level == 0);
	return if (($level < 2) && ($type eq $sow->{'APLOG_NOTICE'}));
	return if (($level < 3) && ($type eq $sow->{'APLOG_POSTED'}));
	return if (($level < 4) && ($type eq $sow->{'APLOG_OTHERS'}));

	my $datafile = $sow->{'cfg'}->{'FILE_ERRLOG'};
	$datafile = $sow->{'cfg'}->{'FILE_APLOG'} if (($type eq $sow->{'APLOG_POSTED'}) || ($type eq $sow->{'APLOG_OTHERS'}));
	$datafile = "$sow->{'cfg'}->{'DIR_LOG'}/$sow->{'cfg'}->{'FILE_304LOG'}" if (($type eq 'http') && (defined($sow->{'cfg'}->{'FILE_304LOG'}))); # デバッグ用

	my ($pkg, $fname, $line) = caller;

	# ファイルロックできていない時は die する
#	die "[$type] $mes [from $pkg $fname line $line]" if ($sow->{'lock'}->{'lock'} ne 'lock');

	# ファイルロックできていない時は return する
#	return if ($sow->{'lock'}->{'lock'} ne 'lock');

	# ログのローテーション
	&FileRotation($sow, $datafile);

	# 書き込み
	open (APLOG, ">>$datafile") || die "aplog could not create.[from $pkg $fname line $line]";
	my $t = $sow->{'dt'}->cvtdt($sow->{'time'});
	print APLOG "($type) [$t] $mes";

	# WARNING と CAUTION の場合はエラーレベルに関係なく cookie と 入力値を出力
	if (($type eq $sow->{'APLOG_WARNING'}) || ($type eq $sow->{'APLOG_CAUTION'})) {
		my $querystring = $sow->{'QUERY_STRING'} . ';';
		$querystring =~ s/pwd=.*?[&;]/pwd=xxxxxxxx&/g;
		print APLOG " / $querystring";

		if (defined($ENV{'HTTP_COOKIE'})) {
			my $cookies = $ENV{'HTTP_COOKIE'} . ';';
			$cookies =~ s/pwd=.*?;/pwd=xxxxxxxx;/g;
			print APLOG " / $cookies";
		}
	}
	print APLOG "\n";
	close(APLOG);
	return;
}

#----------------------------------------
# 入力値をアプリケーションログへ出力
#----------------------------------------
sub writequerylog {
	my ($self, $type, $mes) = @_;
	my $sow = $self->{'sow'};

	my $querystring = $sow->{'QUERY_STRING'} . ';';
	$querystring =~ s/pwd=.*?[&;]/pwd=xxxxxxxx&/g;
	$querystring =~ s/p=.*?[&;]/p=xxxxxxxx&/g;
	$self->writeaplog($sow->{'APLOG_OTHERS'}, "QUERY_STRING: $querystring");

	if (defined($ENV{'HTTP_COOKIE'})) {
		my $cookies = $ENV{'HTTP_COOKIE'} . ';';
		$cookies =~ s/pwd=.*?;/pwd=xxxxxxxx;/g;
		$self->writeaplog($sow->{'APLOG_OTHERS'}, "COOKIES: $cookies");
	}
}

#----------------------------------------
# cookie出力値をアプリケーションログへ出力
#----------------------------------------
sub writecookielog {
	my ($self, $type, $mes) = @_;
	my $sow = $self->{'sow'};

	if (defined($sow->{'setcookie'})) {
		my $setcookie = $sow->{'setcookie'};
		my @keys = keys(%$setcookie);
		$self->writeaplog($sow->{'APLOG_OTHERS'}, "SET-COOKIES: @keys");
	}
}

#----------------------------------------
# ファイルローテーション
#----------------------------------------
sub FileRotation {
	my ($sow, $datafile) = @_;

	return unless (-e $datafile);
	my $size = (-s $datafile);
	if ($size >= $sow->{'cfg'}->{'MAXSIZE_APLOG'}) {
		for ($i = $sow->{'cfg'}->{'MAXNO_APLOG'}; $i > 0; $i--) {
			my $fileid = '.' . ($i - 1);
			my $fileidnext = ".$i";
			$fileid = '' if ($i == 1);
			rename("$datafile$fileid", "$datafile$fileidnext") if (-e "$datafile$fileid");
		}
	}
}

#----------------------------------------
# エラー表示
#----------------------------------------
sub OutHTMLError {
	my ($self, $mes1, $mes2, $mes3, $mes4) = @_;
	my $sow = $self->{'sow'};
	my $cfg = $sow->{'cfg'};

	# 万が一永久ループに入っていたら die する（本来あり得ない）。
	die "$mes1 $mes2\n" if ($self->{'error'} == 1);
	$self->{'error'} = 1;

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	$sow->{'html'} = SWHtml->new($sow) if (!defined($sow->{'html'}->{'sow'}));;
	$sow->{'http'}->outheader();
	$sow->{'html'}->outheader($mes1);
	$sow->{'html'}->outcontentheader();

	if ($sow->{'outmode'} eq 'mb') {
		$self->OutHTMLErrorMb($mes1, $mes2, $mes3, $mes4);
	} else {
		$self->OutHTMLErrorPC($mes1, $mes2, $mes3, $mes4);
	}

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter();
	$sow->{'http'}->outfooter();
	exit();
}

#----------------------------------------
# エラー表示（PCモード）
#----------------------------------------
sub OutHTMLErrorPC {
	my ($self, $mes1, $mes2, $mes3, $mes4) = @_;
	my $sow = $self->{'sow'};
	my $cfg = $sow->{'cfg'};
	my $cmd = $sow->{'query'}->{'cmd'};

	print <<"_HTML_";
<script>
var errors = [];
errors.push("$mes1");
errors.push("$mes2");
gon = {
	"errors": {
		"$cmd": errors
	}
};
</script>
<div class="paragraph">
<p>$mes1</p>
<p>$mes2</p>
</div>

_HTML_

	if (defined($mes3)) {
		print <<"_HTML_";
<blockquote>
$mes3<span class="infotext">$mes4</span>
</blockquote>

_HTML_
	}

	print <<"_HTML_";
<p class="return">
<a href="$cfg->{'BASEDIR_CGIERR'}/$cfg->{'FILE_SOW'}">必死にトップページに戻る</a>
</p>

_HTML_

}

#----------------------------------------
# エラー表示（モバイルモード）
#----------------------------------------
sub OutHTMLErrorMb {
	my ($self, $mes1, $mes2, $mes3, $mes4) = @_;
	my $sow = $self->{'sow'};
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	if (defined($sow->{'file'}->{'vil'})) {
		my $vil = $sow->{'file'}->{'vil'}->{'parent'};
		&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0);
	}

	print <<"_HTML_";
<p>$mes1</p>
<p>$mes2</p>
<hr$net>

_HTML_

	if (defined($sow->{'file'}->{'vil'})) {
		my $vil = $sow->{'file'}->{'vil'}->{'parent'};
		&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'uid'} = '';
		$reqvals->{'pwd'} = '';
		$reqvals->{'vid'} = '';
		my $urlsow = &SWBase::GetLinkValues($sow, $reqvals);
		print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$urlsow\">戻る</a>\n";
	}
}

1;
