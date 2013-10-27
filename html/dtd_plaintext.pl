package SWPlainText;

#----------------------------------------
# Plain Text
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
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
# HTML�w�b�_�̏o��
#----------------------------------------
sub outheader {
	my ($self, $title) = @_;
	return if ($self->{'outheader'} eq 'output');
	$self->{'outheader'} = 'output';

	return;
}

#----------------------------------------
# HTML�t�b�^�̏o��
#----------------------------------------
sub outfooter {
	my ($self, $t) = @_;

	return;
}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�̕\��
#----------------------------------------
sub outcontentheader {
	my $self = $_[0];

	return;
}

#----------------------------------------
# �{�R���e���c���i�񔭌��t�B���^�j�̕\��
#----------------------------------------
sub outcontentfooter {
	my $self = $_[0];

	return;
}

1;