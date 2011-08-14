package SWHtmlMemoFormMb;

#----------------------------------------
# �����������݉�ʁi���o�C�����[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLMemoFormMb {
	my ($sow, $vil) = @_;
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};

	require "$cfg->{'DIR_LIB'}/file_memo.pl";
	require "$cfg->{'DIR_LIB'}/log.pl";

	# HTML���[�h�̏�����
	$sow->{'html'} = SWHtml->new($sow);

	# HTTP�w�b�_�EHTML�w�b�_�̏o��
	my $outhttp = $sow->{'http'}->outheader();
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('����');

	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp    = $sow->{'html'}->{'amp'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = $query->{'cmdfrom'};
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	print <<"_HTML_";
$sow->{'query'}->{'vid'} $vil->{'vname'}<br$net>
<a href="$link">�߂�</a>
<hr$net>
_HTML_

	my $curpl = $sow->{'curpl'};
	my $chrname = $curpl->getlongchrname();
	print "��$chrname<br$net>\n";

	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

	# ������textarea�v�f�̏o��
	my ($saycnt,$cost,$unitaction) = $vil->getmemoptcosts();
	my $memocost = '�������ɓ\��t�����';
	$memocost    = '�g���ƃA�N�V�����񐔂����' if( $cost eq 'count' );
	$memocost    = '�g���Ɣ�����20pt���'       if( $cost eq 'point' );
	$reqvals->{'cmd'} = '';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

	my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 0);
	my $logs = $memofile->{'memoindex'}->{'file'}->getlist();
	my $mes = '';
	my $i;
	for ($i = $#$logs; $i >= 0; $i--) {
		next if ($curpl->{'uid'} ne $logs->[$i]->{'uid'});
		my $memo = $memofile->read($logs->[$i]->{'pos'});
		$mes = $memo->{'log'};
		$mes = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $mes, $anchor);
		$mes =~ s/<br( \/)?>/&#13\;/ig;
		last;
	}
	my $saycnttext = "";
	$saycnttext = "����".$curpl->{'say_act'}.$unitaction                       if( $cost eq 'count' );
	$saycnttext = "����".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if( $cost eq 'point' );

	print <<"_HTML_";
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="cmd" value="wrmemo"$net>$hidden
<input type="submit" value="������\\��"$net> $saycnttext
_HTML_

	print <<"_HTML_";
<select name="monospace">
<option value="">(�ʏ�)
<option value="monospace">����
<option value="report">���o��
</select>
��������$memocost�܂��B
</form>
<hr$net>

_HTML_

	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
	return;
}

1;
