package SWjavascript;

#----------------------------------------
# Plain Text
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $html) = @_;

	$html->{'net'}       = ''; # Null End Tag
	$html->{'atr_id'}    = 'name';
	$html->{'checked'}   = 'checked';
	$html->{'selected'}  = 'selected';
	$html->{'disabled'}  = 'disabled';
	$html->{'option'}    = '</option>';
	$html->{'amp'}       = '&amp;';
	$html->{'target'}    = ' target="_blank"';

	my $http = $html->{'sow'}->{'http'};
	$http->{'contenttype'} = 'html';
	$http->{'styletype'}   = '';
	$http->{'scripttype'}  = '';

	my $self = {
		sow       => $html->{'sow'},
		outheader => '',
	};
	return bless($self, $class);
}

#----------------------------------------
# HTMLヘッダの出力
#----------------------------------------
sub outheader {
	my ($self, $title) = @_;
	return if ($self->{'outheader'} eq 'output');
	$self->{'outheader'} = 'output';

	print <<"_HTML_";
<!doctype html>
<html lang="ja">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
</head>
<body>
_HTML_
	return;
}

#----------------------------------------
# HTMLフッタの出力
#----------------------------------------
sub outfooter {
	my ($self, $t) = @_;

	print <<"_HTML_";
</body>
</html>
_HTML_
	return;
}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）の表示
#----------------------------------------
sub outcontentheader {
	my $self = $_[0];

	return;
}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）の表示
#----------------------------------------
sub outcontentfooter {
	my $self = $_[0];

	return;
}

1;