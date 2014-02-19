package SWXHtml11;

#----------------------------------------
# XHTML1.1 DTD
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $html) = @_;
	$html->{'net'}       = ' /'; # Null End Tag
	$html->{'atr_id'}    = 'id';
	$html->{'checked'}   = 'checked="checked"';
	$html->{'selected'}  = 'selected="selected"';
	$html->{'disabled'}  = 'disabled="disabled"';
	$html->{'option'}    = '</option>';
	$html->{'amp'}       = '&amp;';
	$html->{'target'}    = '';

	my $http = $html->{'sow'}->{'http'};
	$http->{'contenttype'} = 'xhtml';
	$http->{'styletype'}   = 'text/css';
	$http->{'scripttype'}  = 'text/javascript';

	my $self = {
		sow       => $html->{'sow'},
		outheader => '',
	};
	return bless($self, $class);
}

#----------------------------------------
# HTML�w�b�_�̏o��
#----------------------------------------
sub outheader {
	my ($self, $title) = @_;
	return if ($self->{'outheader'} eq 'output');
	$self->{'outheader'} = 'output';

	print <<"_HTML_";
<?xml version="1.0" encoding="Shift_JIS"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">
_HTML_

	&SWHtmlPC::OutHTMLHeaderPC($self->{'sow'}, $title);
}

#----------------------------------------
# XHTML�t�b�^�̏o��
#----------------------------------------
sub outfooter {
	my ($self, $t) = @_;
	&SWHtmlPC::OutHTMLFooterPC($self->{'sow'}, $t);
	return;
}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�̕\��
#----------------------------------------
sub outcontentheader {
	my $self = $_[0];
	&SWHtmlPC::OutHTMLContentFrameHeader($self->{'sow'});
	return;
}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�̕\��
#----------------------------------------
sub outcontentfooter {
	my $self = $_[0];
	&SWHtmlPC::OutHTMLContentFrameFooter($self->{'sow'});
	return;
}

1;