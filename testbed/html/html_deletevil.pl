package SWHtmlDeleteVil;

#----------------------------------------
# ���f�[�^�폜��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLDeleteVil {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'deletevil';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'vidstart'} > 0) {
		my $vidtext = "$query->{'vidstart'}��";
		$vidtext .= "�`$query->{'vidend'}��" if ($query->{'vidstart'} != $query->{'vidend'});
		print "<p class=\"info\">\n$vidtext�̑��f�[�^���폜���܂����B\n</p>\n\n";
	}

	print <<"_HTML_";
<h2>���f�[�^�̍폜</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <label>���ԍ��F<input type="text" name="vidstart" value="" size="4"$net></label> <label>�` <input type="text" name="vidend" value="" size="4"$net></label>
  <input type="submit" value="�폜"$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	return;
}

1;
