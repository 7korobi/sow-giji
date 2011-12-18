package SWHtmlLoginFormMb;

#----------------------------------------
# ���O�C���t�H�[���^�ݒ���HTML�̕\��
#----------------------------------------
sub OutHTMLLoginMb {
	my $sow = $_[0];
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML�o�͗p���C�u�����̓ǂݍ���
	require "$cfg->{'DIR_HTML'}/html.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�


	my $title = '���O�C��';
	my $buttuncaption = '���O�C��';
	if ($query->{'cmd'} eq 'cfg') {
		$title = '�ݒ�';
		$buttuncaption = '�ύX';
	}

	$sow->{'html'}->outheader($title); # HTML�w�b�_�̏o��
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $option = $sow->{'html'}->{'option'};

	print <<"_HTML_";
$cfg->{'NAME_SW'}<br$net>

_HTML_

	my $vid = '';
	$vid = $query->{'vid'} if (defined($query->{'vid'}));
	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

	if (0) {
		print <<"_HTML_";
<input type="text" name="vid" value="$vid" size="5" istyle="4"$net> ���ԍ�<br$net>
_HTML_
	}

	if ($query->{'cmd'} ne 'cfg')	{
		print <<"_HTML_";
<input type="text" name="uid" value="" size="8" istyle="3"$net> ���[�U�[ID<br$net>
<input type="text" name="pwd" value="" size="8" istyle="3"$net> �p�X���[�h<br$net>
_HTML_
	}

	print "<select name=\"row\">\n";

	my $row_mb = $sow->{'cfg'}->{'ROW_MB'};
	my $row = $sow->{'cfg'}->{'MAX_ROW_MB'};
	$row = $query->{'row'} if (defined($query->{'row'}));
	foreach (@$row_mb) {
		my $selected = '';
		$selected = " $sow->{'html'}->{'selected'}" if ($_ == $row);
		print "<option value=\"$_\"$selected>$_$option\n";
	}

	my $desc = " $sow->{'html'}->{'selected'}";
	my $asc = '';
	if (($query->{'order'} eq 'a') || ($query->{'order'} eq 'asc')) {
		$desc = '';
		$asc = " $sow->{'html'}->{'selected'}";
	}
	print <<"_HTML_";
</select> �\\������<br$net>
<select name="order">
<option value="d"$desc>�������$option
<option value="a"$asc>�ォ�牺$option
</select> ���я�<br$net>
_HTML_

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'vindex';
	$reqvals->{'vid'} = '';
	$reqvals->{'row'} = '';
	$reqvals->{'order'} = '';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	print <<"_HTML_";
$hidden
<input type="submit" value="$buttuncaption"$net>
</form>
_HTML_

	my $urlbbs = $sow->{'cfg'}->{'URL_BBS_MB'};
	my $namebbs = $sow->{'cfg'}->{'NAME_BBS_MB'};
	if ($sow->{'cfg'}->{'URL_BBS_MB'} eq '') {
		$urlbbs  = $sow->{'cfg'}->{'URL_BBS'} if (defined($sow->{'cfg'}->{'URL_BBS'}));
		$namebbs = $sow->{'cfg'}->{'NAME_BBS'} if (defined($sow->{'cfg'}->{'NAME_BBS'}));
	}
	if ($urlbbs ne '') {
		print <<"_HTML_";
<hr$net>

<a href="$urlbbs">$namebbs</a>
_HTML_
	}
	print "\n";

	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;