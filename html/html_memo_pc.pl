package SWHtmlMemoPC;

#----------------------------------------
# �����\���iPC���[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLMemoPC {
	my ($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows) = @_;

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	# ���O�C��HTML
	$sow->{'html'}->outcontentheader();
	&SWHtmlPC::OutHTMLLogin($sow);

	# ����
	my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
	my $extend = '����' . $vil->{'extend'} . '��܂ŁB' if $vil->{'extend'};
	my $titleupdate = " ($date �ɍX�V�B $extend)";

	# ���o���i������RSS�j
	my $titleupdate = &SWHtmlPC::GetTitleNextUpdate($sow, $vil);
	my $linkrss = " <a href=\"$link$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);
	print "<h2>$query->{'vid'} $vil->{'vname'}";
	print " $linkrss<br$net>$titleupdate" if ($vil->{'epilogue'} >= $vil->{'turn'});
	print "</h2>\n\n";

	# ���t�ʃ��O�ւ̃����N
	my $list = $logfile->getlist();
	my @dummy;
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil, \@dummy, $list);

	# �����\��
	my $title = '';
	$title = '����' if ($query->{'cmd'} eq 'hist');
	print <<"_HTML_";
<div class="message_filter"> 
<h3><a name="MEMO">����$title</a></h3>
_HTML_

	if (@$logs > 0) {
		print <<"_HTML_";
<table border="1" class="memo" summary="����$title">
<tbody>
_HTML_
	} else {
		print <<"_HTML_";
<p class="paragraph">
�����͂���܂���B
</p>
_HTML_
	}

	my %logkeys;
	my %anchor = (
		logfile => $logfile,
		logkeys => \%logkeys,
		rowover => 1,
		reqvals => $reqvals,
	);

	my $order = 'desc';
	$order = 'asc' if ($query->{'cmd'} eq 'hist');
	$order = $query->{'order'} if ($query->{'order'} ne '');
	if (($order eq 'desc') || ($order eq 'd')) {
		my $i;
		for ($i = $#$logs; $i >= 0; $i--) {
			&OutHTMLMemoSinglePC($sow, $vil, $memofile, $logs->[$i], \%anchor);
		}
	} else {
		foreach (@$logs) {
			&OutHTMLMemoSinglePC($sow, $vil, $memofile, $_, \%anchor);
		}
	}

	if (@$logs > 0) {
		print <<"_HTML_";
</tbody>
</table>
_HTML_
	}

	print <<"_HTML_";
</div> 
<hr class="invisible_hr" />

_HTML_

	my $writepl = &SWBase::GetCurrentPl($sow, $vil);
	if (($query->{'cmd'} eq 'memo') 
	  &&($sow->{'turn'} == $vil->{'turn'}) 
	  &&($vil->{'turn'} <= $vil->{'epilogue'})
	  ){
		if     ($query->{'admin'}  eq 'on' ){
			&OutHTMLVilMakerPC($sow, $vil, 'admin');
		}elsif ($query->{'maker'}  eq 'on' ){
			&OutHTMLVilMakerPC($sow, $vil, 'maker');
		}elsif ($query->{'anonymous'}  eq 'on' ){
			&OutHTMLVilMakerPC($sow, $vil, 'anonymous');
		}elsif ($vil->checkentried() >= 0) {
			&OutHTMLMemoFormPC($sow, $vil, $memofile, $logs, \%anchor);
		}
	}
	# ���t�ʃ��O�ւ̃����N
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil, \@dummy, $list) if ($query->{'cmd'} eq 'hist');

	&SWHtmlPC::OutHTMLReturnPC($sow);

	$sow->{'html'}->outcontentfooter();

	return;
}

#----------------------------------------
# ����������HTML�\���i��s���j
#----------------------------------------
sub OutHTMLMemoSinglePC {
	my ($sow, $vil, $memofile, $memoidx, $anchor) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	my $memo = $memofile->read($memoidx->{'pos'},$memoidx->{'logpermit'});
	my $chrname = $memo->{'chrname'};
	my $append  = "<br>(�����o�܂���)";
	my $curpl = $vil->getplbyface($memoidx->{'csid'},$memoidx->{'cid'});
	if ((defined($curpl->{'entrieddt'})) && ($curpl->{'entrieddt'} < $memoidx->{'date'})){
		if( 0 == ($sow->{'turn'} ) ){
			$append = "";
		} elsif ($memo->{'mestype'} == $sow->{'MESTYPE_ANONYMOUS'}){
			$chrname = "" if ( 0 == $vil->isepilogue() );
			$append  = "�i�����j";
		} elsif ($memo->{'mestype'} == $sow->{'MESTYPE_INFOSP'}){
			$append = "";
		} else {
			my $reqvals = &SWBase::GetRequestValues($sow);
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link&move=page&pageno=1&pno=$curpl->{'pno'}";
			$append = "<br><a href=\"".$link."\">����</a>";
		}
	}
	my $mes = $memo->{'log'};
	$mes = '�i�������͂������j' if ($memo->{'log'} eq '');
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$mes, $anchor);
	&SWHtml::ConvertNET($sow, \$mes);
	my $mestext = "mes_text";
	$mestext = 'mes_text_monospace' if ((defined($memo->{'monospace'})) && ($memo->{'monospace'} == 1));
	$mestext = 'mes_text_report'    if ((defined($memo->{'monospace'})) && ($memo->{'monospace'} == 2));
	my $date = $sow->{'dt'}->cvtdt($memo->{'date'});
	my $memodate = '';
	$memodate = "<div class=\"mes_date\">$date</div>\n" if ($sow->{'query'}->{'cmd'} eq 'hist');

	# ID���J
	my $showid = '';
	$showid = "<br$net>($memoidx->{'uid'})" if ($vil->{'showid'} > 0);

	# �N���X��
	my $messtyle = &SWHtmlPC::OutHTMLMesStyle($sow,$vil,$memo);

	if (($memo->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($memo->{'mestype'} == $sow->{'MESTYPE_ADMIN'})) {
		print <<"_HTML_";
<tr>
<td colspan=2 class="$messtyle">
<div class="guide">
<h3 class="mesname">$chrname</h3>
<p class="$mestext">$mes</p>
<p class="mes_date">$memodate</p>
</div>
_HTML_
	} else {
		print <<"_HTML_";
<tr class="$messtyle">
<th class="memoleft">$chrname $append $showid
<td class="memoright"><p class="$mestext">$mes</p>$memodate

_HTML_
	}
}

#----------------------------------------
# ����������HTML�\��
#----------------------------------------
sub OutHTMLMemoFormPC {
	my ($sow, $vil, $memofile, $logs, $anchor) = @_;
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};

	my $curpl = $sow->{'curpl'};
	my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

	my $memo = $memofile->getnewmemo($curpl);
	my $mes = $memo->{'log'};
	$mes = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $mes, $anchor);
	$mes =~ s/<br( \/)?>/&#13\;/ig;

	# �L�����摜�A�h���X�̎擾
	my $img = &SWHtmlPC::GetImgUrl($sow, $curpl, $charset->{'BODY'});

	# �L�����摜
	print <<"_HTML_";
<table class="formpl_common">
<tr class="say">
<td class="img">
<img src="$img" width="$charset->{'IMGBODYW'}" alt=""$net>

_HTML_

	# ���O��ID
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'prof'} = $sow->{'uid'};
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	my $uidtext = $sow->{'uid'};
	$uidtext =~ s/ /&nbsp\;/g;
	$uidtext = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">$uidtext</a>";
	my $chrname = $curpl->getlongchrname();
	print <<"_HTML_";
<td class="field"><div class="msg">
<div class="formpl_content">$chrname ($uidtext)</div>

_HTML_

	# �e�L�X�g�{�b�N�X�Ɣ����{�^������
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_content">
_HTML_

	# ������textarea�v�f�̏o��
	my ($saycnt,$cost,$unitaction) = $vil->getmemoptcosts();
	my $memocost = '�������ɓ\��t�����';
	$memocost    = '�g���ƃA�N�V�����񐔂����' if( $cost eq 'count' );
	$memocost    = '�g���Ɣ�����20pt���'       if( $cost eq 'point' );
	my %htmlsay = (
		saycnttext  => "",
		buttonlabel => '������\��',
		text        => $mes,
		disabled    => 0,
	);
	$htmlsay{'saycnttext'} = "����".$curpl->{'say_act'}.$unitaction                       if( $cost eq 'count' );
	$htmlsay{'saycnttext'} = "����".&SWBase::GetSayCountText($sow, $vil, $sow->{'curpl'}) if( $cost eq 'point' );
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'wrmemo', \%htmlsay);

	print <<"_HTML_";
<select name="monospace">
<option value="">(�ʏ�)
<option value="monospace">����
<option value="report">���o��
</select>
      <p>��������$memocost�܂��B</p>
    </div>
    </form>
</div>
</table>
<div class="clearboth">
<hr class="invisible_hr"$net>
</div>
</div>

_HTML_

}

#----------------------------------------
# ����������HTML�\��
#----------------------------------------
sub OutHTMLVilMakerPC {
	my ($sow, $vil, $writemode) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $amp = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $curpl = $sow->{'curpl'};
	my $csidlist = $sow->{'csidlist'};
	my @keys = keys(%$csidlist);
	my %imgpl = (
		cid      => $writemode,
		csid     => $keys[0],
		deathday => -1,
	);
	if ($writemode eq 'anonymous'){
		$imgpl{'csid'} = $curpl->{'csid'} ;
		$imgpl{'cid'}  = $curpl->{'cid'} ;
	}
	$imgpl{'deathday'} = $curpl->{'deathday'} if (defined($curpl->{'deathday'}));
	my $charset = $sow->{'charsets'}->{'csid'}->{$imgpl{'csid'}};

	# �L�����摜�A�h���X�̎擾
	my $img = &SWHtmlPC::GetImgUrl($sow, \%imgpl, $charset->{'BODY'});

	# �L�����摜
	print <<"_HTML_";
<table class="formpl_common">
<tr class="say">
<td class="img">
<img src="$img" width="$charset->{'IMGBODYW'}" alt=""$net>

_HTML_

	# ���O��ID
	my $chrname = $sow->{'charsets'}->getchrname($imgpl{'csid'}, $imgpl{'cid'});
	my $uidtext = $sow->{'uid'};
	print <<"_HTML_";
<td class="field"><div class="msg">
<div class="formpl_content">$chrname ($uidtext)</div>

_HTML_

	# �e�L�X�g�{�b�N�X�Ɣ����{�^������
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_WRITE'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_content">
_HTML_

	# ������textarea�v�f�̏o��
	my %htmlsay = (
	buttonlabel => '������\��',
		text        => $mes,
		disabled    => 0,
	);
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'wrmemo', \%htmlsay);

	print <<"_HTML_";
<select name="monospace">
<option value="">(�ʏ�)
<option value="monospace">����
<option value="report">���o��
</select>
    <input type="hidden" name="$writemode" value="on"$net>
    </div>
    </form>
</div>
</table>

_HTML_

	return;
}



1;
