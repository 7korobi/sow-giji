package SWXmlRSS10;

#----------------------------------------
# RSS1.0
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $html) = @_;
	$html->{'net'}       = ' /'; # Null End Tag
	$html->{'atr_id'}    = 'id';
	$html->{'checked'}   = 'checked="checked"';
	$html->{'selected'}  = 'selected="selected"';
	$html->{'disabled'}  = 'disabled="disabled"';
	$html->{'option'}    = '';
	$html->{'amp'}       = '&amp;';
	$html->{'target'}    = '';

	my $http = $html->{'sow'}->{'http'};
	$http->{'contenttype'} = 'xml';
	$http->{'styletype'}   = '';
	$http->{'scripttype'}  = '';

	my $self = {
		sow       => $html->{'sow'},
		outheader => '',
	};
	return bless($self, $class);
}

#----------------------------------------
# RSSヘッダの出力
#----------------------------------------
sub outheader {
	my ($self, $title) = @_;
	return if ($self->{'outheader'} eq 'output');
	$self->{'outheader'} = 'output';

	my $sow = $self->{'sow'};
	my $encoding = 'Shift_JIS';
	$encoding = 'utf-8' if (($sow->{'jcode'} eq 'pm') && ($sow->{'cfg'}->{'RSS_ENCODING_UTF8'} > 0));
	print <<"_HTML_";
<?xml version="1.0" encoding="$encoding"?>
<rdf:RDF 
  xmlns="http://purl.org/rss/1.0/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:content="http://purl.org/rss/1.0/modules/content/"
  xml:lang="ja">

_HTML_

}

#----------------------------------------
# RSSフッタの出力
#----------------------------------------
sub outfooter {
	my ($self, $t) = @_;

	print  <<"_XML_";
</rdf:RDF>
_XML_

	return;
}

1;
