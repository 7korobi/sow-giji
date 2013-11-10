#!/usr/bin/perl
# ���T�[�o�̐ݒ�ɍ��킹�ĉ������B

#-------------------------------------------------
# �l�T���� / The Stories of Werewolves
# 2006-2007 ����/asbntby
# mail: asbntby@yahoo.co.jp
# url:  http://asbntby.sakura.ne,jp/
#-------------------------------------------------

# �C���X�g�[���`�F�b�N������Ȃ� 1 �ɂ���B
my $ENABLED_INSTALLCHECK = 1;

# ���Ԃ̌v���p�i����܂�Ӗ��͂Ȃ��j
my @t = times();
$t[0] = $t[0] + $t[1];

use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);

srand; # �����l�̏�����

# %ENV�̃G�~�����[�g�i�f�o�b�O�p�j
if (!defined($ENV{'GATEWAY_INTERFACE'})) {
	my $fname = 'env.pl';
	$fname = "env_$ARGV[0].pl" if (defined($ARGV[0]));
	require "./env/$fname";
	&EmulateENV();
}

# �C���X�g�[���`�F�b�N
&InstallCheck(0) if (($ENABLED_INSTALLCHECK > 0) && ($ENV{'QUERY_STRING'} eq 'check'));
#&InstallCheck(1) if (($ENABLED_INSTALLCHECK > 0) && ($ENV{'QUERY_STRING'} eq 'inst'));

# ������
my $sow = &Init($t[0]);

# ���O�C�����̎擾
$sow->{'user'}->logined();
$sow->{'uid'} = $sow->{'user'}->{'uid'};

# �X�V���\��
$sow->{'debug'}->raise($sow->{'APLOG_OTHERS'}, '�������ܐF�X�ƍX�V���ɂ��A���΂炭���҂��������B', 'swbbs is halting.') if ($sow->{'cfg'}->{'ENABLED_HALT'} > 0);

# ���͒l���A�v���P�[�V�������O�֏o��
$sow->{'debug'}->writequerylog() if ($sow->{'cfg'}->{'LEVEL_APLOG'} == 5);

# �e�����̎��s
&TaskBranch($sow);

# cookie�o�͒l���A�v���P�[�V�������O�֏o��
$sow->{'debug'}->writecookielog() if ($sow->{'cfg'}->{'LEVEL_APLOG'} == 5);

# ���ĂȂ��t�@�C�������i����܂�Ӗ��͂Ȃ��j
my @files = keys(%{$sow->{'file'}});
foreach (@files) {
	$sow->{'file'}->{$_}->closefile();
}

# �t�@�C�����b�N�����i�������̏ꍇ�j
$sow->{'lock'}->gunlock();


#----------------------------------------
# ������
#----------------------------------------
sub Init {
	my $t = $_[0];

	# �J�����g�f�B���N�g���̕ύX
	$ENV{'SCRIPT_FILENAME'} =~ /\/[^\/]*\z/;
	chdir($`) if ($& ne '');

	# �ݒ�f�[�^�̓ǂݍ���
	require "./config.pl";
	my $cfg = &SWConfig::GetConfig();

	# ��{���C�u�����ƒ萔�f�[�^�̓ǂݍ���
	require "$cfg->{'DIR_LIB'}/base.pl";
	my $sow = &SWBase::InitSW($cfg);

	# ���Ԃ̌v���p�i����܂�Ӗ��͂Ȃ��j
	$sow->{'starttime'} = $t;

	return $sow;
}

#----------------------------------------
# �e�����̎��s
#----------------------------------------
sub TaskBranch {
	my $sow = $_[0];
	my $dirlib  = $sow->{'cfg'}->{'DIR_LIB'};
	my $dirhtml = $sow->{'cfg'}->{'DIR_HTML'};
	my $cmd = $sow->{'query'}->{'cmd'};
	my $noregist = &AdminIDCheck($sow);
	if ($cmd eq 'login') {
		# ���O�C��
		require "$dirlib/cmd_login.pl";
		&SWCmdLogin::CmdLogin($sow);
	} elsif ($cmd eq 'logout') {
		# ���O�A�E�g
		require "$dirlib/cmd_logout.pl";
		&SWCmdLogout::CmdLogout($sow);
	} elsif ($noregist > 0) {
		# ID���o�^
		require "$dirhtml/html_noready.pl";
		&SWHtmlNoReady::OutHTMLNoReady($sow, $noregist);
	} elsif ($cmd eq 'editprofform') {
		# ���[�U�[���ҏW���
		require "$dirhtml/html_editprofform.pl";
		&SWHtmlEditProfileForm::OutHTMLEditProfileForm($sow);
	} elsif ($cmd eq 'editprof') {
		# ���[�U�[���ҏW
		require "$dirlib/cmd_editprof.pl";
		&SWCmdEditProfile::CmdEditProfile($sow);
	} elsif ($sow->{'query'}->{'prof'} ne '') {
		# ���[�U�[���\��
		require "$dirlib/cmd_profile.pl";
		&SWCmdProfile::CmdProfile($sow);
	} elsif ($cmd eq 'makevilpr') {
		# ���쐬
		require "$dirlib/cmd_makevil.pl";
		&SWCmdMakeVil::CmdMakeVilPr($sow);
	} elsif ($cmd eq 'makevil') {
		# ���쐬
		require "$dirlib/cmd_makevil.pl";
		&SWCmdMakeVil::CmdMakeVil($sow);
	} elsif ($cmd eq 'editvil') {
		# ���ҏW
		require "$dirlib/cmd_editvil.pl";
		&SWCmdEditVil::CmdEditVil($sow);
	} elsif ($cmd eq 'editepivil') {
		# �{�������ύX
		require "$dirlib/cmd_editepivil.pl";
		&SWCmdEpilogueEditVil::CmdEpilogueEditVil($sow);
	} elsif ($cmd eq 'makevilform') {
		# ���쐬��ʕ\��
		require "$dirlib/cmd_makevilform.pl";
		&SWCmdMakeVilForm::CmdMakeVilForm($sow);
	} elsif ($cmd eq 'editvilform') {
		# ���ҏW��ʕ\��
		require "$dirlib/cmd_editvilform.pl";
		&SWCmdEditVilForm::CmdEditVilForm($sow);
	} elsif (($cmd eq 'vinfo') && ($sow->{'outmode'} eq 'mb')) {
		# ������ʕ\���i���o�C���j
		require "$dirhtml/html_vinfo_mb.pl";
		&SWHtmlVilInfoMb::OutHTMLVilInfoMb($sow);
	} elsif ($cmd eq 'vinfo') {
		# ������ʕ\��
		require "$dirhtml/html_vinfo_pc.pl";
		&SWHtmlVilInfo::OutHTMLVilInfo($sow);
	} elsif ((($cmd eq 'vindex') || ($cmd eq 'oldlog')) && ($sow->{'outmode'} eq 'mb')) {
		# ���ꗗ�\���i���o�C���j
		require "$dirhtml/html_vindex_mb.pl";
		&SWHtmlVIndexMb::OutHTMLVIndexMb($sow);
	} elsif ($cmd eq 'enformmb') {
		# �G���g���[��ʁi���o�C���j
		require "$dirlib/cmd_enformmb.pl";
		&SWCmdEntryFormMb::CmbEntryFormMb($sow);
	} elsif ($cmd eq 'entrypr') {
		# �G���g���[�����v���r���[�\��
		require "$dirlib/cmd_entrypr.pl";
		&SWCmdEntryPreview::CmdEntryPreview($sow);
	} elsif ($cmd eq 'entry') {
		# �G���g���[
		require "$dirlib/cmd_entry.pl";
		&SWCmdEntry::CmdEntry($sow);
	} elsif ($cmd eq 'cfg') {
		# ���o�C���p�ݒ���
		require "$dirhtml/html_loginform_mb.pl";
		&SWHtmlLoginFormMb::OutHTMLLoginMb($sow);
	} elsif ($cmd eq 'exit') {
		# ������o��
		require "$dirlib/cmd_exit.pl";
		&SWCmdExit::CmdExit($sow);
	} elsif ($cmd eq 'kick') {
		# ������ދ�
		require "$dirlib/cmd_exit.pl";
		&SWCmdExit::CmdKick($sow);
	} elsif ($cmd eq 'maker') {
		# �����Č���������B
		require "$dirlib/cmd_maker.pl";
		&SWCmdMaker::CmdMaker($sow);
	} elsif ($cmd eq 'muster') {
		# ����_�Ă��܂��B
		require "$dirlib/cmd_muster.pl";
		&SWCmdMuster::CmdMuster($sow);
	} elsif ($cmd eq 'gamemaster') {
		# ��ԕύX
		require "$dirlib/cmd_gamemaster.pl";
		&SWCmdGameMaster::CmdGameMaster($sow);
	} elsif ($cmd eq 'writepr') {
		# �����v���r���[�\��
		require "$dirlib/cmd_writepr.pl";
		&SWCmdWritePreview::CmdWritePreview($sow);
	} elsif ($cmd eq 'wrformmb') {
		# �����t�H�[���\���i���o�C���j
		require "$dirlib/cmd_wrformmb.pl";
		&SWCmdWriteFormMb::CmbWriteFormMb($sow);
	} elsif ($cmd eq 'wrmemoformmb') {
		# �����������݃t�H�[���i���o�C���j
		require "$dirlib/cmd_memoformmb.pl";
		&SWCmdWriteMemoFormMb::CmbWriteMemoFormMb($sow);
	} elsif ($cmd eq 'write') {
		# ����
		require "$dirlib/cmd_write.pl";
		&SWCmdWrite::CmdWrite($sow);
	} elsif ($cmd eq 'cancel') {
		# �����P��
		require "$dirlib/cmd_cancel.pl";
		&SWCmdCancel::CmdCancel($sow);
	} elsif ($cmd eq 'action') {
		# �A�N�V����
		require "$dirlib/cmd_action.pl";
		&SWCmdAction::CmdAction($sow);
	} elsif ($cmd eq 'wrmemo') {
		# ������������
		require "$dirlib/cmd_wrmemo.pl";
		&SWCmdWriteMemo::CmdWriteMemo($sow);
	} elsif ($cmd eq 'editjob') {
		# �������ύX
		require "$dirlib/cmd_editjob.pl";
		&SWCmdEditJobName::CmdEditJobName($sow);
	} elsif ($cmd eq 'start') {
		# ���J�n
		&CheckValidityStart($sow);
		require "$dirlib/cmd_start.pl";
		&SWCmdStartSession::CmdStartSession($sow);
	} elsif (($cmd eq 'entrust') || ($cmd eq 'vote') || ($cmd eq 'role') || ($cmd eq 'gift')){
		# ���[�^�\�͑Ώېݒ�
		require "$dirlib/cmd_vote.pl";
		&SWCmdVote::CmdVote($sow);
	} elsif ($cmd eq 'commit') {
		# ���Ԃ�i�߂�
		require "$dirlib/cmd_commit.pl";
		&SWCmdCommit::CmdCommit($sow);
	} elsif ($cmd eq 'debugvil') {
		# ���f�[�^�̕\���i�f�o�b�O�p�j
		require "$dirhtml/html_debugvil.pl";
		&SWHtmlDebugVillage::OutHTMLDebugVillage($sow);
	} elsif ($cmd eq 'scrapvil') {
		# �p���i�蓮�A�f�o�b�O�p�j
		&CheckValidityUpdate($sow);
		require "$dirlib/cmd_update.pl";
		&SWCmdUpdateSession::CmdUpdateSession($sow);
	} elsif ($cmd eq 'update') {
		# �X�V�i�蓮�A�f�o�b�O�p�j
		&CheckValidityUpdate($sow);
		require "$dirlib/cmd_update.pl";
		&SWCmdUpdateSession::CmdUpdateSession($sow);
	} elsif ($cmd eq 'extend') {
		# �P������
		require "$dirlib/cmd_extend.pl";
		&SWCmdExtend::CmdExtend($sow);
	} elsif ($cmd eq 'admin') {
		# �Ǘ����
		require "$dirhtml/html_admin.pl";
		&SWHtmlAdminManager::OutHTMLAdminManager ($sow);
	} elsif ($cmd eq 'restrec') {
		# ��эč\�z
		require "$dirlib/cmd_restrec.pl";
		&SWCmdRestRecord::CmdRestRecord($sow);
	} elsif (($cmd eq 'restviform') || ($cmd eq 'restvi')) {
		# ���ꗗ�č\�z
		require "$dirlib/cmd_restvi.pl";
		&SWCmdRestVIndex::CmdRestVIndex($sow);
	} elsif ($cmd eq 'deletevil') {
		# ���f�[�^�폜
		require "$dirlib/cmd_deletevil.pl";
		&SWCmdDeleteVil::CmdDeleteVil($sow);
	} elsif ($cmd eq 'movevil') {
		# ���f�[�^�ړ�
		require "$dirlib/cmd_movevil.pl";
		&SWCmdMoveVil::CmdMoveVil($sow);
	} elsif (($cmd eq 'editpform') || ($cmd eq 'editpenalty')) {
		# �y�i���e�B�ݒ�E����
		require "$dirlib/cmd_editpenalty.pl";
		&SWCmdEditPenalty::CmdEditPenalty($sow);
	} elsif ($cmd eq 'rss') {
		# RSS�o��
		require "$dirlib/cmd_rss.pl";
		&SWCmdRSS::CmdRSS($sow);
	} elsif ($cmd eq 'summary') {
		# ���ꗗ���o��
		require "$dirlib/cmd_rss.pl";
		&SWCmdRSS::CmdRSS($sow);
	} elsif ($cmd eq 'chrlist') {
		# �L�����ꗗ�̕\��
		require "$dirlib/cmd_chrlist.pl";
		&SWCmdChrList::CmdChrList($sow);
	} elsif ($cmd eq 'score') {
		# �l�T���̏o�́i�b��j
		require "$dirhtml/html_score.pl";
		&SWHtmlScore::OutHTMLScore($sow);
	} elsif ($cmd eq 'oldlog') {
		# �I���ς݂̑��\��
		require "$dirhtml/html_oldlog.pl";
		&SWHtmlOldLog::OutHTMLOldLog($sow);
	} elsif (($cmd eq 'memo') || ($cmd eq 'hist')) {
		# �����\��
		require "$dirlib/cmd_memo.pl";
		&SWCmdMemo::CmdMemo($sow);
	} elsif ($cmd eq 'restmemo') {
		# �����C���f�b�N�X�č\�z
		require "$dirlib/cmd_restmemo.pl";
		&SWCmdRestMemoIndex::CmdRestMemoIndex($sow);
	} elsif (($cmd eq 'exitpr')) {
		# �m�F��ʁi�X�V�j
		require "$dirhtml/html_dialog.pl";
		&SWHtmlDialog::OutHTMLDialog($sow);
	} elsif (($cmd eq 'exitpr')
	       ||($cmd eq 'kickpr')
	       ||($cmd eq 'makerpr')
	       ||($cmd eq 'musterpr')
	       ||($cmd eq 'startpr')
	       ||($cmd eq 'scrapvilpr')
	       ||($cmd eq 'updatepr')
	       ||($cmd eq 'extendpr')
	       ){
		# �m�F��ʁi�X�V�j
		&CheckValidityUpdate($sow);
		require "$dirhtml/html_dialog.pl";
		&SWHtmlDialog::OutHTMLDialog($sow);
	} elsif (($cmd eq 'spec')
	       ||($cmd eq 'changelog')
	       ||($cmd eq 'howto')
	       ||($cmd eq 'operate')
	       ||($cmd eq 'prohibit')
	       ||($cmd eq 'rule')
	       ||($cmd eq 'about')
	       ||($cmd eq 'rolematrix')
	       ||($cmd eq 'rolelist')
	       ||($cmd eq 'roleaspect')
	       ||($cmd eq 'trsdiff')
	       ||($cmd eq 'trslist')
	       ){
		# �V�ѕ��^���[���^�T���̕\��
		require "$dirhtml/html_doc.pl";
		&SWHtmlDocument::OutHTMLDocument($sow);
	} elsif (defined($sow->{'query'}->{'vid'})) {
		# �����O�\��
		require "$dirlib/cmd_vlog.pl";
		&SWCmdVLog::CmdVLog($sow);
	} else {
		if ($sow->{'outmode'} eq 'mb') {
			# ���o�C���p���O�C�����
			require "$dirhtml/html_loginform_mb.pl";
			&SWHtmlLoginFormMb::OutHTMLLoginMb($sow);
		} else {
			# �g�b�v�y�[�W�\��
			require "$dirhtml/html_index.pl";
			&SWHtmlIndex::OutHTMLIndex($sow);
		}
	}

	return;
}

#----------------------------------------
# ���蓮�J�n���l�`�F�b�N
#----------------------------------------
sub CheckValidityStart {
	my $sow = $_[0];
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	my $pllist = $vil->getpllist();
	$vil->closevil();

	my $errfrom = "[uid=$sow->{'uid'}, vid=$vil->{'vid'}, cmd=$query->{'cmd'}]";

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�����J�n����ɂ͑����Đl�������Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if (($sow->{'uid'} ne $vil->{'makeruid'}) && ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}));

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�l��������܂���B�_�~�[�L�������܂߁A�Œ� 4 �l�K�v�ł��B", "need 4 persons.$errfrom") if (@$pllist < 4);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���ݎQ�����Ă���l���ƒ��������������܂���B", "invalid vplcnt or total plcnt.$errfrom") if ((@$pllist != $vil->{'vplcnt'}) && ($vil->{'roletable'} eq 'custom'));

	return;
}

#----------------------------------------
# ���蓮�X�V���l�`�F�b�N
#----------------------------------------
sub CheckValidityUpdate {
	my $sow = $_[0];
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	my $pllist = $vil->getpllist();
	$vil->closevil();

	my $errfrom = "[uid=$sow->{'uid'}, vid=$vil->{'vid'}, cmd=$query->{'cmd'}]";

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}) {
		if ($sow->{'query'}->{'cmd'} eq 'scrapvil') {
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�p������ɂ͊Ǘ��l�������K�v�ł��B", "no permition.$errfrom");
		} else {
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "�����X�V����ɂ͑����Đl�������Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if ($sow->{'uid'} ne $vil->{'makeruid'});
		}
	}

	return;
}

#----------------------------------------
# �C���X�g�[���`�F�b�N
#----------------------------------------
sub InstallCheck {
	my $inst = shift;

	print <<"_HTML_";
Content-Type: text/html; charset=Shift_JIS
Content-Style-Type: text/css

<!doctype html>
<html lang="ja" ng-controller="CGI">
<head>
  <meta name="robots" content="noindex,nofollow">
  <meta name="robots" content="noarchive">
  <title>�C���X�g�[���`�F�b�N</title>
  <style type="text/css">
<!--
strong {
  color: #f00;
  background: #fff;
}
-->
  </style>
</head>

<body>

<h2>�C���X�g�[���`�F�b�N</h2>

<ul>
  <li>Perl: [OK]</li>
_HTML_

	# �ݒ�f�[�^�t�@�C���̃`�F�b�N
	&EndInstallCheck() if (&FileCheck('', "./config.pl", 0, 0, 0) == 0);
	&FileCheck('', "./_config_local.pl", 0, 0, 0);

	require "./config.pl";
	my $cfg = &SWConfig::GetConfig();

	&FileCheck($cfg, "./_info.pl", 0, 0, 0);

	&EndInstallCheck() if (&FileCheck($cfg, $cfg->{'DIR_LIB'}, 0, 1, 0) == 0);
	&EndInstallCheck() if (&FileCheck($cfg, $cfg->{'DIR_RS'}, 0, 1, 0) == 0);
	&EndInstallCheck() if (&FileCheck($cfg, $cfg->{'DIR_HTML'}, 0, 1, 0) == 0);
	&EndInstallCheck() if (&FileCheck($cfg, $cfg->{'BASEDIR_DAT'}, 1, 1, 0) == 0);
	&EndInstallCheck() if (&FileCheck($cfg, $cfg->{'FILE_LOCK'}, 1, 0, $inst * 1) == 0);
	&FileCheck($cfg, $cfg->{'FILE_SOWGROBAL'}, 1, 0, $inst * 1);
	&FileCheck($cfg, $cfg->{'FILE_VINDEX'}, 1, 0, $inst * 1);
	&EndInstallCheck() if (&FileCheck($cfg, $cfg->{'DIR_USER'}, 1, 1, $inst * 2) == 0);
	&EndInstallCheck() if (&FileCheck($cfg, $cfg->{'DIR_VIL'}, 1, 1, $inst * 2) == 0);
	&EndInstallCheck() if (&FileCheck($cfg, $cfg->{'DIR_LOG'}, 1, 1, $inst * 2) == 0);

	print "<li>favicon: <img src=\"$cfg->{'BASEDIR_DOC'}/$cfg->{'FILE_FAVICON'}\"></li>\n";
	print "<li>title: <img src=\"$cfg->{'DIR_IMG'}/mwtitle.jpg\"></li>\n";

	&EndInstallCheck();
	exit();
}

#----------------------------------------
# �C���X�g�[���`�F�b�N�̏I��
#----------------------------------------
sub EndInstallCheck {
	print <<"_HTML_";
</ul>

<p>
Check is completed.
</p>

</body>
</html>

_HTML_
	exit();

}

#----------------------------------------
# �t�@�C���`�F�b�N
#----------------------------------------
sub FileCheck {
	my ($cfg, $file, $w, $x, $make) = @_;
	my $result = 1;

	print "<li>$file: ";
	if (-e $file) {
		print "[OK]";
		if (-r $file) {
			print " / �Ǎ� [OK]";
		} else {
			print " / �Ǎ� <strong>[NG]</strong>";
			$result = 0;
		}
		if ($w > 0) {
			if (-w $file) {
				print " / ���� [OK]";
			} else {
				print " / ���� <strong>[NG]</strong>";
				$result = 0;
			}
		}
		if ($x > 0) {
			if (-x $file) {
				print " / ���s [OK]";
			} else {
				print " / ���s <strong>[NG]</strong>";
				$result = 0;
			}
		}
		print "</li>\n";
	} else {
		if ($make == 1) {
			if (!open(FILE, ">$file")) {
				print "<strong>[NG]</strong></li>\n";
				$result = 0;
			} else {
				print "[Create]</li>";
				close(FILE);
			}
		} elsif ($make == 2) {
			if (!mkdir("$file", $cfg->{'PERMITION_MKDIR'})) {
				print "<strong>[NG]</strong></li>\n";
				$result = 0;
			} else {
				print "[Create]</li>";
			}
		} else {
			print "<strong>[NG]</strong></li>\n";
			$result = 0;
		}
	}
	return $result;
}

#----------------------------------------
# �_�~�[�L�����E�Ǘ��l�pID�̃`�F�b�N
#----------------------------------------
sub AdminIDCheck {
	my $sow = shift;
	my $cfg = $sow->{'cfg'};
	my $user = $sow->{'user'};

	$user->{'uid'} = $cfg->{'USERID_ADMIN'};
	my $fnameadmin = $user->GetFNameUser();
	return 1 unless (-e $fnameadmin);

	$user->{'uid'} = $cfg->{'USERID_NPC'};
	my $fnamenpc = $user->GetFNameUser();
	return 2 unless (-e $fnamenpc);

	return 0;
}

1;
