package SWPlainText;

#----------------------------------------
# Plain Text
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $html) = @_;

	$html->{'net'}       = ''; # Null End Tag
	$html->{'atr_id'}    = '';
	$html->{'checked'}   = '';
	$html->{'selected'}  = '';
	$html->{'disabled'}  = '';
	$html->{'option'}    = '';
	$html->{'amp'}       = '&';
	$html->{'target'}    = '';

	my $http = $html->{'sow'}->{'http'};
	$http->{'contenttype'} = 'plain';
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

	return;
}

#----------------------------------------
# HTMLフッタの出力
#----------------------------------------
sub outfooter {
	my ($self, $t) = @_;

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