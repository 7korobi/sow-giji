package SWiHtml;

#----------------------------------------
# iHTML DTD
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
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