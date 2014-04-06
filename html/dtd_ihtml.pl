package SWiHtml;

#----------------------------------------
# iHTML DTD
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
	$html->{'option'}    = '';
	$html->{'amp'}       = '&';
	$html->{'target'}    = '';

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

	print "<html>\n";
	&SWHtmlMb::OutHTMLHeaderMb($self->{'sow'}, $title);
}

#----------------------------------------
# XHTMLフッタの出力
#----------------------------------------
sub outfooter {
	my ($self, $t) = @_;
	&SWHtmlMb::OutHTMLFooterMb($self->{'sow'}, $t);
	return;
}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）の表示
#----------------------------------------
sub outcontentheader {
	return;
}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）の表示
#----------------------------------------
sub outcontentfooter {
	return;
}

1;