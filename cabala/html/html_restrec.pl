package SWHtmlRestRecord;

#----------------------------------------
# ��эč\�z��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLRestRecord {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'restrec';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'vidstart'} > 0) {
		my $vidtext = "$query->{'vidstart'}��";
		$vidtext .= "�`$query->{'vidend'}��" if ($query->{'vidstart'} != $query->{'vidend'});
		print "<p class=\"info\">\n$vidtext�̐�уf�[�^���č\\�z���܂����B\n</p>\n\n";
	}

	print <<"_HTML_";
<h2>��т̍č\\�z</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <label>���ԍ��F<input type="text" name="vidstart" value="" size="4"$net></label> <label>�` <input type="text" name="vidend" value="" size="4"$net></label>
  <input type="submit" value="�č\\�z"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
��уf�[�^���č\\�z���鎖���ł��܂��B
</p>

<p class="paragraph">
���ԍ����͉E�����󗓂ɂ���ƁA�����̗��Ŏw�肵�����ԍ��̑��̐�т݂̂��č\\�z���܂��B�E���ɐ��l������ƁA�Q�̗��Ŏw�肵���͈͂̑��̐�уf�[�^���ꊇ�������鎖���ł��܂��B<br$net>
���ԍ��̉E���̗��� 0 ����͂���ƁA�ŐV�̑��ԍ��Ƃ��Ĉ����܂��B
</p>

<p class="paragraph">
�����̑��̐�уf�[�^���ꊇ���������<strong class="cautiontext">����Ȃ�ɕ��ׂ�������܂�</strong>�̂ŁA���ӂ��ĉ������B
</p>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	return;
}

1;
