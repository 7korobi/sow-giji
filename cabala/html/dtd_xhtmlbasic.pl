package SWXHtmlBasic;

#----------------------------------------
# XHTMLBasic DTD
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
	$http->{'styletype'}   = '';
	$http->{'scripttype'}  = '';

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

	print "<html>\n";
	&SWHtmlMb::OutHTMLHeaderMb($self->{'sow'}, $title);
}

#----------------------------------------
# XHTML�t�b�^�̏o��
#----------------------------------------
sub outfooter {
	my ($self, $t) = @_;
	&SWHtmlMb::OutHTMLFooterMb($self->{'sow'}, $t);
	return;
}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�̕\��
#----------------------------------------
sub outcontentheader {
	return;
}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�̕\��
#----------------------------------------
sub outcontentfooter {
	return;
}

1;