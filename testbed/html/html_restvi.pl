package SWHtmlRestVIndex;

#----------------------------------------
# ���ꗗ�č\�z��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLRestVIndex {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'restvi';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'cmd'} eq 'restvi') {
		print "<p class=\"info\">\n���ꗗ�t�@�C�����č\\�z���܂����B\n</p>\n\n";
	}

	print <<"_HTML_";
<h2>���ꗗ�̍č\\�z</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <input type="submit" value="�č\\�z"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
�Ȃ�炩�̗��R�ő��ꗗ�t�@�C�����j�������ꍇ�ɏC�����鎖���ł��܂��B
</p>

<p class="paragraph">
�����̑������݂��鎞�ɑ��ꗗ�̍č\\�z���s����<strong class="cautiontext">����Ȃ�ɕ��ׂ�������܂�</strong>�̂ŁA���ӂ��ĉ������B
</p>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	return;
}

1;
