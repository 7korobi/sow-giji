package SWHtmlEditProfileForm;

#----------------------------------------
# ���[�U�[���ҏW��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLEditProfileForm { 
	my ($sow, $vindex) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $urlwrite = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}";

	require "$cfg->{'DIR_HTML'}/html.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader("���[�U�[���ҏW($sow->{'uid'})"); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader('');

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	my $user = SWUser->new($sow);
	$user->{'uid'} = $sow->{'uid'};
	$user->openuser(1);
	$user->closeuser();

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'editprof';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	my $url = 'http://';
	$url = $user->{'url'} if ($user->{'url'} ne '');

	my $intro = $user->{'introduction'};
	$intro =~ s/<br( \/)?>/\n/ig;

	print <<"_HTML_";
<form action="$urlwrite" method="$cfg->{'METHOD_FORM'}">
<div class="form_vmake">
  <fieldset>
    <legend>���[�U�[���ҏW ($sow->{'uid'})</legend>
    <label for="handlename" class="multicolumn_label" >�n���h�����F</label>
    <input id="handlename" class="multicolumn_left" type="text" name="handlename" value="$user->{'handlename'}" size="30"$net>
    <br class="multicolumn_clear"$net>

    <label for="url" class="multicolumn_label" >URL�F</label>
    <input id="url" class="multicolumn_left" type="text" name="url" value="$url" size="30"$net>
    <br class="multicolumn_clear"$net>

    <label for="intro" class="multicolumn_label">���ȏЉ�F</label>
    <textarea id="intro" class="multicolumn_left" name="intro" cols="30" rows="3">$intro</textarea>
    <br class="multicolumn_clear"$net>
  </fieldset>

  <div class="exevmake">$hidden
    <input type="submit" value="�ύX"$net>
  </div>
</div>
</form>

<p class="paragraph">
���^�O�͎g�p�ł��܂���B
</p>
_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	$sow->{'html'}->outcontentfooter('');
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;
