package SWHtmlProfile;

#----------------------------------------
# ���[�U�[����HTML�o��
#----------------------------------------
sub OutHTMLProfile {
	my ($sow, $recordlist, $totalrecord, $camps, $roles) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $urlsow  = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $urluser = "$cfg->{'URL_USER'}?user=";

	undef($query->{'vid'});

	my $user = SWUser->new($sow);
	$user->{'uid'} = $query->{'prof'};
	$user->openuser(1);
	$user->closeuser();

	my $nospaceprof = $query->{'prof'};
	$nospaceprof =~ s/^ *//;
	$nospaceprof =~ s/ *$//;
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���[�U�[ID���w�肵�ĉ������B", "no prof.") if (length($nospaceprof) == 0);

	# �e�L�X�g���\�[�X�̓Ǎ�
	my %vil = (
		trsid        => $sow->{'cfg'}->{'DEFAULT_TEXTRS'},
	);
	&SWBase::LoadTextRS($sow, \%vil);

	# HTML�̏o��
	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	$sow->{'html'}->outheader("$query->{'prof'}����̃��[�U�[���"); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'editprofform';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $linkedit  = '';
	$linkedit = " <a href=\"$urlsow?$linkvalue\">�ҏW</a>" if ($sow->{'uid'} eq $query->{'prof'});

	my $linkuser = '';
	$linkuser = " <a href=\"$urluser$user->{'uid'}\">���</a>" if ($sow->{'uid'} eq $query->{'prof'});

	my $handlename = '���o�^';
	$handlename = $user->{'handlename'} if ($user->{'handlename'} ne '');

	my $url = '���o�^';
	$url = $user->{'url'} if ($user->{'url'} ne '');
	$url = "<a href=\"$user->{'url'}\">$user->{'url'}</a>" if ((index($user->{'url'}, 'http://') == 0) || (index($user->{'url'}, 'https://') == 0));

	my $introduction = '�Ȃ�';
	$introduction = $user->{'introduction'} if ($user->{'introduction'} ne '');
	$introduction =~ s/(s?https?:\/\/[^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/<a href=\"$&\" $blank>$1...<\/a>/g;

	print <<"_HTML_";
<h2>$query->{'prof'}����̏��$linkedit $linkuser</h2>

<p class="paragraph">
  <span class="multicolumn_label">���[�U�[ID�F</span><span class="multicolumn_left">$query->{'prof'}</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">�n���h�����F</span><span class="multicolumn_left">$handlename</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">URL�F</span><span class="multicolumn_left">$url</span>
  <br class="multicolumn_clear"$net>
_HTML_

	$reqvals->{'cmd'} = '';

	if (($sow->{'uid'} eq $query->{'prof'}) || ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'})) {
		my $user = SWUser->new($sow);
		$user->{'uid'} = $query->{'prof'};
		$user->openuser(1);
		my $entriedvils = $user->getentriedvils();
		$user->closeuser();

		print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3>���ȏЉ�</h3>
<p class="paragraph">
$introduction
</p>
<hr class="invisible_hr"$net>
_HTML_
	}

	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	$sow->{'html'}->outcontentfooter('');
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

1;
