package SWHtmlVlogJS;

#----------------------------------------
# �����O�\���iPC���[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLVlogJS {
	my ($sow, $vil, $maxrow, $logfile, $logs, $logkeys, $logrows, $memofile, $memos, $memokeys, $memorows) = @_;
	my $cfg   = $sow->{'cfg'};

	&OutHTMLGonInit($sow); # ���O�C�����̏o��
	# �A�i�E���X�^���́E�Q���t�H�[���\��
	if (($modesingle == 0) && ($sow->{'turn'} == $vil->{'turn'}) && ($logrows->{'end'} > 0)) {
		&OutHTMLVlogFormArea($sow, $vil, $memofile)
	}

	$vil->gon_story();
	$vil->gon_event();
	$vil->gon_potofs();

	print <<"_HTML_";
var mes = {
	"template": "sow/status_info",
	"logid": "status",
	"date": 0
};
gon.event.messages.push(mes);

var mes = {
	"template": "message/cast",
	"logid": "potofs",
	"date": 1
};
gon.event.messages.push(mes);

var mes = {
	"template": "sow/village_info",
	"logid": "vilinfo",
	"date": 2
};
gon.event.messages.push(mes);

_HTML_

	# �����O�\��
	require "$cfg->{'DIR_HTML'}/html_vlogsingle_pc.pl";
    my $last = "";
	my $has_all_messages = 0 + (($maxrow < 1)&&($sow->{'turn'} != $vil->{'turn'}));

	if (@$memos > 0) {
		my %memokeys;
		my %anchor = (
			logfile => $logfile,
			logkeys => \%memokeys,
			rowover => 1,
			reqvals => $reqvals,
		);
		foreach (@$memos) {
			&SWHtmlVlogSinglePC::OutHTMLMemoSinglePC($sow, $vil, $memofile, $_, \%anchor);
		}
	} else {
		print <<"_HTML_";
gon.cautions.push("�����͂���܂���B");
_HTML_
	}

	if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'})) {
		print <<"_HTML_";
gon.cautions.push("�����͂���܂���B");
_HTML_
	} else {
		my %anchor = (
			logfile => $logfile,
			logkeys => $logkeys,
			rowover => $rowover,
			reqvals => $reqvals,
		);

		my $i;
		for ($i = 0; $i < @$logs; $i++) {
			my $newsay = 0;
			$newsay = 1 if ($i == $#$logs);
			my $log = $logfile->read($logs->[$i]->{'pos'},$logs->[$i]->{'logpermit'});
			&SWHtmlVlogSinglePC::OutHTMLSingleLogPC($sow, $vil, $log, $i, $newsay, \%anchor, $modesingle);
		}
	}

	print <<"_HTML_";
gon.event.is_news = (0 == $has_all_messages);
gon.event.has_all_messages = (0 != $has_all_messages);

var mes = {
	"template": "sow/log_last",
	"logid":  "IX99999",
	"date":  new Date
};
gon.event.messages.push(mes);
</script>
_HTML_

	return;
}

#----------------------------------------
# �A�i�E���X�^���́E�Q���t�H�[���\��
#----------------------------------------
sub OutHTMLVlogFormArea {
	my ($sow, $vil, $memofile) = @_;
	my $cfg = $sow->{'cfg'};

	my $pllist = $vil->getpllist();
	my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});

	if (($vil->{'turn'} == 0) && ($vil->checkentried() < 0) && ($vil->{'vplcnt'} > @$pllist)) {
		# �v�����[�O���Q���^�����O�C�����A�i�E���X
		my $scraplimit = "{{lax_time(story.timer.scraplimitdt)}}�܂łɊJ�n���Ȃ������ꍇ�A���̑��͔p���ƂȂ�܂��B";
		$scraplimit = '' if ($vil->{'scraplimitdt'} == 0);
		print <<"_HTML_";
gon.cautions.push("���������L�����N�^�[��I�сA�������Ă��������B");
gon.cautions.push("���[�����悭����������ł��Q���������B");
gon.cautions.push("����]�\\�͂ɂ��Ă̔����͍T���Ă��������B");
gon.cautions.push("$scraplimit");
_HTML_
	} elsif ($vil->isepilogue() > 0) {
		# �G�s���[�O�p�A�i�E���X
		my $caption_winner = $sow->{'textrs'}->{'CAPTION_WINNER'};
		my $victorytext = $sow->{'textrs'}->{'ANNOUNCE_VICTORY'};
		my $caption = $caption_winner->[$vil->{'winner'}];
		$victorytext =~ s/_VICTORY_/$caption/g;
		$victorytext = '' if ($vil->{'winner'} == 0);
		my $epiloguetext = $sow->{'textrs'}->{'ANNOUNCE_EPILOGUE'};
		$epiloguetext =~ s/_AVICTORY_/$victorytext/g;
		$epiloguetext =~ s/_DATE_/$date/g;
		&SWHtml::ConvertNET($sow, \$epiloguetext);

		print <<"_HTML_";
gon.cautions.push("$epiloguetext");
_HTML_
	}

	# �������҃��X�g�̕\��
	my $nosaytext = &SWHtmlVlog::GetNoSayListText($sow, $vil);
	if (($vil->isepilogue() == 0) && ($nosaytext ne '')) {
		print <<"_HTML_";
gon.cautions.push("$nosaytext");
_HTML_
	}

	# �������^�G���g���[�t�H�[��
	if ($vil->{'turn'} == 0) {
		# �v�����[�O
		if ($sow->{'user'}->logined() > 0) {
			# ���O�C���ς�
			if ($vil->checkentried() >= 0) {
				print <<"_HTML_";
gon.cautions.push("{{potof.timer.entry_limit()}}�܂łɈ�x���������������J�n����Ȃ������ꍇ�A���Ȃ��͎����I�ɑ�����ǂ��o����܂��B");
gon.cautions.push("����������Ɗ�������������܂��B");
_HTML_

				# �������̕\��
				require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
				&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil, $memofile);
			} else {
				# �G���g���[�t�H�[���̕\��
				require "$cfg->{'DIR_HTML'}/html_entryform_pc.pl";
				&SWHtmlEntryFormPC::OutHTMLEntryFormPC($sow, $vil);
				&OutHTMLVilMakerInFormPlPC($sow, $vil);
			}
		} else {
			# �����O�C��
			if ($vil->{'vplcnt'} > @$pllist) {
				print <<"_HTML_";
gon.cautions.push("�Q�[���Q���Ҋ�]�҂̓��O�C�����ĉ������B");
_HTML_
			} else {
				print <<"_HTML_";
gon.cautions.push("���łɒ���ɒB���Ă��܂��B");
_HTML_
			}
		}
	} else {
		# �i�s��
		if ($sow->{'user'}->logined() > 0) {
			# ���O�C���ς�
			if ($vil->checkentried() >= 0){
				# �������̕\��
				require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
				&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil, $memofile);
			} else {
				# �����Đl�^�Ǘ��l�����t�H�[���̕\��
				&OutHTMLVilMakerInFormPlPC($sow, $vil);
			}
		} elsif ($vil->isepilogue() == 0) {
			print <<"_HTML_";
gon.cautions.push("�Q���҂̓��O�C�����Ă��������B");
_HTML_
		}
	}
	return;
}

sub OutHTMLGonInit {
  my $sow = $_[0];
  my $cfg = $sow->{'cfg'};
  my $uid = $sow->{'uid'};
  my $path = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
  my $cmdfrom = $query->{'cmd'};
  my $logined = $sow->{'user'}->logined() + 0;
  my $expired = $sow->{'time'} + $cfg->{'TIMEOUT_COOKIE'};
  my $is_admin = ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'}) + 0;
  my $admin_uri = $path."?cmd=admin" if ($is_admin);

  print <<"_HTML_";
<script>
window.gon = \$.extend(true, {}, OPTION.gon);
gon.form.login = {
  "cmd": "login",
  "admin_uri": "$admin_uri",
  "is_admin": $is_admin,
  "cmdfrom": "$cmdfrom",
  "expired": new Date(1000 * $expired),
  "uidtext": "$uid".replace(" ","&nbsp;"),
  "uid": "$uid"
}
gon.form.uri = "$path";
_HTML_
}

#----------------------------------------
# �����Đl�t�H�[���^�Ǘ��l�t�H�[���̕\��
# �i�����Đl�^�Ǘ��l���Q�����Ă��Ȃ����j
#----------------------------------------
sub OutHTMLVilMakerInFormPlPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};

	if ($vil->{'makeruid'} eq $sow->{'uid'}) {
		require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
		&SWHtmlPlayerFormPC::OutHTMLVilMakerPC($sow, $vil, 'maker');
		&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
	}

	if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'}) {
		require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
		&SWHtmlPlayerFormPC::OutHTMLVilMakerPC($sow, $vil, 'admin');
		&SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC($sow, $vil);
		&SWHtmlPlayerFormPC::OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
	}

	return;
}

1;
