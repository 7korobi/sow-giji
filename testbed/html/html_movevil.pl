package SWHtmlMoveVil;

#----------------------------------------
# ���f�[�^�ړ���ʂ�HTML�o��
#----------------------------------------
sub OutHTMLMoveVil {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'movevil';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'vidstart'} > 0) {
		my $vidtext = "$query->{'vidstart'}��";
		$vidtext .= "�`$query->{'vidend'}��" if ($query->{'vidstart'} != $query->{'vidend'});
		print "<p class=\"info\">\n$vidtext�̑��f�[�^���ړ����܂����B\n</p>\n\n";
	}
	my $option = $sow->{'html'}->{'option'};

	print <<"_HTML_";
<h2>���f�[�^�̈ړ�</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <label>���ԍ��F<input type="text" name="vidstart" value="" size="4"$net></label> <label>�` <input type="text" name="vidend" value="" size="4"$net></label>
  <select name="vidmove">
    <option value="file2dir">���S�� �� ���ԍ���$option
    <option value="dir2file">���ԍ��� �� ���S��$option
  </select>
  <input type="submit" value="�ړ�"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
���f�[�^���P���P�ʂő��ԍ��ʃf�B���N�g���i$sow->{'cfg'}->{'DIR_VIL'}/xxxx�j�ֈړ���������A�t�ɑ��S�̃f�[�^�f�B���N�g���i$sow->{'cfg'}->{'DIR_VIL'}�j�ֈړ���������ł��܂��B<br$net>
</p>

<p class="paragraph">
���ԍ����͉E�����󗓂ɂ���ƁA�����̗��Ŏw�肵�����ԍ��̑��݂̂��ړ����܂��B�E���ɐ��l������ƁA�Q�̗��Ŏw�肵���͈͂̑����ꊇ�ړ������鎖���ł��܂��B<br$net>
���ԍ��̉E���̗��� 0 ����͂���ƁA�ŐV�̑��ԍ��Ƃ��Ĉ����܂��B
</p>

<p class="paragraph">
�����̑����ꊇ�ړ��������<strong class="cautiontext">����Ȃ�ɕ��ׂ�������܂�</strong>�̂ŁA���ӂ��ĉ������B
</p>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	return;
}

1;
