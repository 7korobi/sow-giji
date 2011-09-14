package SWHtml401;

#----------------------------------------
# HTML4.01 Transitional DTD
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
	$http->{'styletype'}   = 'text/css';
	$http->{'scripttype'}  = 'text/javascript';

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
<!doctype html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
_HTML_

	&SWHtmlPC::OutHTMLHeaderPC($self->{'sow'}, $title);
	return;
}

#----------------------------------------
# HTMLフッタの出力
#----------------------------------------
sub outfooter {
	my ($self, $t) = @_;
	&SWHtmlPC::OutHTMLFooterPC($self->{'sow'}, $t);
	return;
}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）の表示
#----------------------------------------
sub outcontentheader {
	my $self = $_[0];
	&SWHtmlPC::OutHTMLContentFrameHeader($self->{'sow'});
	return;
}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）の表示
#----------------------------------------
sub outcontentfooter {
	my $self = $_[0];
	&SWHtmlPC::OutHTMLContentFrameFooter($self->{'sow'});
	return;
}

1;