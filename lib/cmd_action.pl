package SWCmdAction;

#----------------------------------------
# �A�N�V����
#----------------------------------------
sub CmdAction {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# �f�[�^����
	my ($vil, $checknosay) = &SetDataCmdAction($sow);

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		if ($checknosay > 0) {
			# �����O�\��
			require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_vlog.pl";
			&SWCmdVLog::OutHTMLCmdVLog($sow, $vil);
		} else {
			# �����[�h����
			require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
			require "$sow->{'cfg'}->{'DIR_HTML'}/html_formpl_mb.pl";
			&SWHtmlPlayerFormMb::OutHTMLPlayerFormMb ($sow, $vil);
		}
	} else {
		$sow->{'http'}->outheader();
		$sow->{'http'}->outfooter();
	}
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdAction {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# �A�N�V�����Ώێ҂ƁA���̖��O���擾
	my $mes    = '';
	my $target = '';
	my $action = '';
	my $targetpl;
	if (defined($query->{'target'}) && ($query->{'target'} >= 0)) {
		if ((!defined($query->{'actionno'})) || ($query->{'actionno'} != -2)) {
			$targetpl = $vil->getplbypno($query->{'target'});
			$debug->raise($sow->{'APLOG_CAUTION'}, "�Ώ۔ԍ����s���ł��B","invalid target.") if (!defined($targetpl->{'pno'}));
			$debug->raise($sow->{'APLOG_CAUTION'}, "�ΏۂɎ����͑I�ׂ܂���B","target is you.") if ($sow->{'curpl'}->{'pno'} == $targetpl->{'pno'});
			$debug->raise($sow->{'APLOG_CAUTION'}, "�A�N�V�����Ώۂ̐l�͎���ł��܂��B","target is dead.") if (($sow->{'curpl'}->{'live'} eq 'live')&&($targetpl->{'live'} ne 'live')&&($vil->isepilogue() == 0));
			$target = $targetpl->getchrname();
		}
	}

	# �����O�֘A��{���͒l�`�F�b�N
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	my $actions = $sow->{'textrs'}->{'ACTIONS'};
	if ( $query->{'actionno'} == -99 ) {
		$action = "";
	} else {
		# ��^�A�N�V����
		if ($query->{'actionno'} != -2) {
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�A�N�V�����̑Ώۂ����I���ł��B", "no target.$errfrom") if (!defined($targetpl->{'pno'}));
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�A�N�V�����ԍ����s���ł��B", "invalid action no.$errfrom") if (!defined($actions->[$query->{'actionno'}]));
		}

		if ($query->{'actionno'} == -1) {
			# �b�̑����𑣂�
			$debug->raise($sow->{'APLOG_CAUTION'}, "�����͂����g���؂��Ă��܂��B","not enough actaddpt.") if ($sow->{'curpl'}->{'actaddpt'} <= 0);
			my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
			$actions_addpt =~ s/_REST_//g;
			$action = $actions_addpt;
			$targetpl->addsaycount();
			$sow->{'curpl'}->{'actaddpt'}--;
		} elsif ($query->{'actionno'} == -2) {
			# ������
			$action = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
		} elsif ($query->{'actionno'} == -3) {
			# zap
			my $actions_zap = $sow->{'textrs'}->{'ACTIONS_ZAP'};
			$actions_zap =~ s/_COUNT_//g;
			$action = $actions_zap;
			$targetpl->zap();
			$sow->{'curpl'}->{'zapcount'}++;
		} elsif ($query->{'actionno'} == -4) {
			# ���i
			$action = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_UP'};
			if( $targetpl->{'clearance'} < 8 ){
				$targetpl->{'clearance'}++ ;
			}else{
				$action .= $sow->{'textrs'}->{'ACTIONS_CLEARANCE_NG'};
			}
		} elsif ($query->{'actionno'} == -5) {
			# �~�i
			$action = $sow->{'textrs'}->{'ACTIONS_CLEARANCE_DOWN'};
			if( 0 < $targetpl->{'clearance'} ){
				$targetpl->{'clearance'}-- ;
			}else{
				$action .= $sow->{'textrs'}->{'ACTIONS_CLEARANCE_NG'};
			}
		} else {
			# �b�̑����𑣂��ȊO�̒�^�A�N�V����
			$action = $actions->[$query->{'actionno'}];
		}
	}
	require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
	my $checkfreetext = &SWString::CheckNoSay($sow, $query->{'actiontext'});
	if ($checkfreetext > 0 ) {
		# ���R���̓A�N�V����
		require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";
		&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'actiontext'}, 'ACTION', 'actiontext', '�A�N�V�����̓��e', 1);
		$action = $query->{'actiontext'};
	}
	$mes = $target . $action;


	require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
	my $checknosay = &SWString::CheckNoSay($sow, $mes);
	if ($checknosay > 0) {
		# �A�N�V�����̏�������
		$query->{'mes'} = $mes;
		my $writepl = &SWBase::GetCurrentPl($sow, $vil);
		&SWWrite::ExecuteCmdWrite($sow, $vil, $writepl);

		$debug->writeaplog($sow->{'APLOG_POSTED'}, "WriteAction. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]");
	}
	$vil->closevil();

	return ($vil, $checknosay);
}

1;