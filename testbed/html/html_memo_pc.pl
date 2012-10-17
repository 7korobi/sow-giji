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

	$reqvals->{'cmd'} = '';
	$reqvals->{'row'} = '';
	$reqvals->{'rowall'} = '';
	my $news_link = &SWBase::GetLinkValues($sow, $reqvals);
	$news_link   = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $news_link;

	my $memo_link_text;
    if ('memo' eq $query->{'cmd'}){
		$reqvals->{'cmd'} = 'hist';
		$memo_link_text = "����";
	} else {
		$reqvals->{'cmd'} = 'memo';
		$memo_link_text = "�ŐV";
	}
	$reqvals->{'rowall'} = 'on';
	my $memo_link = &SWBase::GetLinkValues($sow, $reqvals);
	$memo_link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?" . $memo_link;

	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	# ���O�C��HTML
	$sow->{'html'}->outcontentheader();
	&SWHtmlPC::OutHTMLLogin($sow);

	# ���o���i������RSS�j
	my $linkrss = " <a href=\"$link$amp". "cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);

    &SWHtmlPC::OutHTMLChangeCSS($sow);

	print <<"_HTML_";
<h2>$query->{'vid'} $vil->{'vname'} $linkrss</h2>
<div class="pagenavi" template="navi/page_navi" class="form-inline">
<a class="btn" href="$memo_link">$memo_link_text</a>
<a class="btn" href="$news_link">�ŐV�̔���</a>
</div>
_HTML_

	# �����\��
	my $title = '';
	$title = '����' if ($query->{'cmd'} eq 'hist');
	print <<"_HTML_";
<h3><a name="MEMO">����$title</a></h3>
<div id="messages" template="navi/messages"></div>
<div class="pagenavi" template="navi/page_navi" class="form-inline">
<a class="btn" href="$memo_link">$memo_link_text</a>
<a class="btn" href="$news_link">�ŐV�̔���</a>
</div>
<hr class="invisible_hr" />
_HTML_

	my $writepl = &SWBase::GetCurrentPl($sow, $vil);
	if (($query->{'cmd'} eq 'memo')
	  &&($sow->{'turn'} == $vil->{'turn'})
	  &&($vil->{'turn'} <= $vil->{'epilogue'})
	  ){
		if ($vil->checkentried() >= 0) {
			&OutHTMLMemoFormPC($sow, $vil, $memofile, $logs, \%anchor);
		}
		if ($vil->{'makeruid'} eq $sow->{'uid'}) {
			&OutHTMLVilMakerPC($sow, $vil, 'maker');
		}
		if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'}) {
			&OutHTMLVilMakerPC($sow, $vil, 'admin');
		}
		if ($query->{'anonymous'}  eq 'on' ){
			&OutHTMLVilMakerPC($sow, $vil, 'anonymous');
		}
	}

	print <<"_HTML_";
<hr class="invisible_hr"$net>
_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow);

	$sow->{'html'}->outcontentfooter();

	print <<"_HTML_";
<div id="tab" ng-cloak="ng-cloak" ng-init="mode = 'memo'">

<div class="sayfilter" id="sayfilter">
<h4 class="sayfilter_heading" ng-show="! navi.show.blank">{{story.name}}</h4>
<div class="insayfilter" ng-show="navi.show.link"><div class="paragraph">
<h4 class="sayfilter_caption_enable">���̏�ʂ�</h4>
<div class="sayfilter_content">
<nav class="form-inline" template="navi/paginate" ng-hide="event.is_news"></nav>
<a class="btn" href="$memo_link">$memo_link_text</a>
<a class="btn" href="$news_link">�ŐV�̔���</a>
<br />
</div>
_HTML_
#	&SWHtmlSayFilter::OutHTMLHeader   ($sow, $vil);
 	&SWHtmlSayFilter::OutHTMLTurnLink ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLSayFilter($sow, $vil) if ($modesingle == 0);
	&SWHtmlSayFilter::OutHTMLTools    ($sow, $vil);
	&SWHtmlSayFilter::OutHTMLFooter   ($sow, $vil);
	print <<"_HTML_";
<script>
window.gon = {};
_HTML_
	$vil->gon_story();
	$vil->gon_event();
	$vil->gon_potofs();

	# �S�\�������N
	my $is_news = 0 + ('memo' eq $query->{'cmd'});

	if (@$logs > 0) {
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
	} else {
		print <<"_HTML_";
var mes = {
	"subid":  "I",
	"logid":  "IX00000",
	"mestype":  "CAUTION",
	"style":    "head",
	"log":   "�����͂���܂���B",
	"date":  new Date
};
_HTML_
		print <<"_HTML_";
gon.event.messages.push(mes);
_HTML_
	}

	print <<"_HTML_";
gon.event.is_news = (0 != $is_news);
gon.event.is_deny_messages = true;
</script>
_HTML_

	return;
}

#----------------------------------------
# ����������HTML�\���i��s���j
#----------------------------------------
sub OutHTMLMemoSinglePC {
	my ($sow, $vil, $memofile, $memoidx, $anchor) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	my $log = $memofile->read($memoidx->{'pos'},$memoidx->{'logpermit'});
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
		}
	}
	if ($log->{'log'} eq '') {
		$log->{'log'} = '�i�������͂������j' ;
	}

	# ID���J
	my $showid = '';
	$showid = $log->{'uid'} if  ($vil->{'showid'} > 0);
	$showid = $log->{'uid'} if  ($vil->{'epilogue'} <= $sow->{'turn'});
	$showid = ''            if (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'}));

	my $name = $log->{'chrname'};

	print <<"_HTML_";
var mes = {
	"subid":  "M",
	"logid":  "MM$log->{'logid'}",
	"csid":     "$log->{'csid'}",
	"face_id":  "$log->{'cid'}",
	"mesicon":  SOW_RECORD.CABALA.mestypeicons[$log->{'mestype'}],
	"mestype":  SOW_RECORD.CABALA.mestypes[$log->{'mestype'}],
	"style":    SOW_RECORD.CABALA.monospace[$log->{'monospace'}],
	"name":  "$name",
	"to":    "$to",
	"log":   "$log->{'log'}",
	"date":  Date.create(1000 * $log->{'date'})
};
_HTML_
	if ($vil->{'showid'}) {
		print <<"_HTML_"
mes.sow_auth_id = "$showid";
_HTML_
	}
	print <<"_HTML_";
gon.event.messages.push(mes);
_HTML_
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
<img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net>

_HTML_

	# ���O��ID
	my $uidtext = $sow->{'uid'};
	$uidtext =~ s/ /&nbsp\;/g;
	$uidtext = '<a class="sow-id">'.$uidtext.'</a>';
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
<select name="monospace" class="input-small">
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
<img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net>

_HTML_

	# ���O��ID
	my $chrname = $sow->{'charsets'}->getchrname($imgpl{'csid'}, $imgpl{'cid'});
	my $uidtext = $sow->{'uid'};
	$uidtext = '<a class="sow-id">'.$uidtext.'</a>';
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
<select name="monospace" class="input-small">
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
