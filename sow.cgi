#!/usr/bin/perl
# ↑サーバの設定に合わせて下さい。

#-------------------------------------------------
# 人狼物語 / The Stories of Werewolves
# 2006-2007 あず/asbntby
# mail: asbntby@yahoo.co.jp
# url:  http://asbntby.sakura.ne,jp/
#-------------------------------------------------

# インストールチェックをするなら 1 にする。
my $ENABLED_INSTALLCHECK = 1;

# 時間の計測用（あんまり意味はない）
my @t = times();
$t[0] = $t[0] + $t[1];

use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);

srand; # 乱数値の初期化

# %ENVのエミュレート（デバッグ用）
if (!defined($ENV{'GATEWAY_INTERFACE'})) {
	my $fname = 'env.pl';
	$fname = "env_$ARGV[0].pl" if (defined($ARGV[0]));
	require "./env/$fname";
	&EmulateENV();
}

# インストールチェック
&InstallCheck(0) if (($ENABLED_INSTALLCHECK > 0) && ($ENV{'QUERY_STRING'} eq 'check'));
#&InstallCheck(1) if (($ENABLED_INSTALLCHECK > 0) && ($ENV{'QUERY_STRING'} eq 'inst'));

# 初期化
my $sow = &Init($t[0]);

# ログイン情報の取得
$sow->{'user'}->logined();
$sow->{'uid'} = $sow->{'user'}->{'uid'};

# 更新中表示
$sow->{'debug'}->raise($sow->{'APLOG_OTHERS'}, 'ただいま色々と更新中につき、しばらくお待ち下さい。', 'swbbs is halting.') if ($sow->{'cfg'}->{'ENABLED_HALT'} > 0);

# 入力値をアプリケーションログへ出力
$sow->{'debug'}->writequerylog() if ($sow->{'cfg'}->{'LEVEL_APLOG'} == 5);

# 各処理の実行
&TaskBranch($sow);

# cookie出力値をアプリケーションログへ出力
$sow->{'debug'}->writecookielog() if ($sow->{'cfg'}->{'LEVEL_APLOG'} == 5);

# 閉じてないファイルを閉じる（あんまり意味はない）
my @files = keys(%{$sow->{'file'}});
foreach (@files) {
	$sow->{'file'}->{$_}->closefile();
}

# ファイルロック解除（未解除の場合）
$sow->{'lock'}->gunlock();


#----------------------------------------
# 初期化
#----------------------------------------
sub Init {
	my $t = $_[0];

	# カレントディレクトリの変更
	$ENV{'SCRIPT_FILENAME'} =~ /\/[^\/]*\z/;
	chdir($`) if ($& ne '');

	# 設定データの読み込み
	require "./config.pl";
	my $cfg = &SWConfig::GetConfig();

	# 基本ライブラリと定数データの読み込み
	require "$cfg->{'DIR_LIB'}/base.pl";
	my $sow = &SWBase::InitSW($cfg);

	# 時間の計測用（あんまり意味はない）
	$sow->{'starttime'} = $t;

	return $sow;
}

#----------------------------------------
# 各処理の実行
#----------------------------------------
sub TaskBranch {
	my $sow = $_[0];
	my $dirlib  = $sow->{'cfg'}->{'DIR_LIB'};
	my $dirhtml = $sow->{'cfg'}->{'DIR_HTML'};
	my $cmd = $sow->{'query'}->{'cmd'};
	my $noregist = &AdminIDCheck($sow);
	if ($cmd eq 'login') {
		# ログイン
		require "$dirlib/cmd_login.pl";
		&SWCmdLogin::CmdLogin($sow);
	} elsif ($cmd eq 'logout') {
		# ログアウト
		require "$dirlib/cmd_logout.pl";
		&SWCmdLogout::CmdLogout($sow);
	} elsif ($noregist > 0) {
		# ID未登録
		require "$dirhtml/html_noready.pl";
		&SWHtmlNoReady::OutHTMLNoReady($sow, $noregist);
	} elsif ($cmd eq 'editprofform') {
		# ユーザー情報編集画面
		require "$dirhtml/html_editprofform.pl";
		&SWHtmlEditProfileForm::OutHTMLEditProfileForm($sow);
	} elsif ($cmd eq 'editprof') {
		# ユーザー情報編集
		require "$dirlib/cmd_editprof.pl";
		&SWCmdEditProfile::CmdEditProfile($sow);
	} elsif ($sow->{'query'}->{'prof'} ne '') {
		# ユーザー情報表示
		require "$dirlib/cmd_profile.pl";
		&SWCmdProfile::CmdProfile($sow);
	} elsif ($cmd eq 'makevilpr') {
		# 村作成
		require "$dirlib/cmd_makevil.pl";
		&SWCmdMakeVil::CmdMakeVilPr($sow);
	} elsif ($cmd eq 'makevil') {
		# 村作成
		require "$dirlib/cmd_makevil.pl";
		&SWCmdMakeVil::CmdMakeVil($sow);
	} elsif ($cmd eq 'editvil') {
		# 村編集
		require "$dirlib/cmd_editvil.pl";
		&SWCmdEditVil::CmdEditVil($sow);
	} elsif ($cmd eq 'editepivil') {
		# 閲覧制限変更
		require "$dirlib/cmd_editepivil.pl";
		&SWCmdEpilogueEditVil::CmdEpilogueEditVil($sow);
	} elsif ($cmd eq 'makevilform') {
		# 村作成画面表示
		require "$dirlib/cmd_makevilform.pl";
		&SWCmdMakeVilForm::CmdMakeVilForm($sow);
	} elsif ($cmd eq 'editvilform') {
		# 村編集画面表示
		require "$dirlib/cmd_editvilform.pl";
		&SWCmdEditVilForm::CmdEditVilForm($sow);
	} elsif (($cmd eq 'vinfo') && ($sow->{'outmode'} eq 'mb')) {
		# 村情報画面表示（モバイル）
		require "$dirhtml/html_vinfo_mb.pl";
		&SWHtmlVilInfoMb::OutHTMLVilInfoMb($sow);
	} elsif ($cmd eq 'vinfo') {
		# 村情報画面表示
		require "$dirhtml/html_vinfo_pc.pl";
		&SWHtmlVilInfo::OutHTMLVilInfo($sow);
	} elsif ((($cmd eq 'vindex') || ($cmd eq 'oldlog')) && ($sow->{'outmode'} eq 'mb')) {
		# 村一覧表示（モバイル）
		require "$dirhtml/html_vindex_mb.pl";
		&SWHtmlVIndexMb::OutHTMLVIndexMb($sow);
	} elsif ($cmd eq 'enformmb') {
		# エントリー画面（モバイル）
		require "$dirlib/cmd_enformmb.pl";
		&SWCmdEntryFormMb::CmbEntryFormMb($sow);
	} elsif ($cmd eq 'entrypr') {
		# エントリー発言プレビュー表示
		require "$dirlib/cmd_entrypr.pl";
		&SWCmdEntryPreview::CmdEntryPreview($sow);
	} elsif ($cmd eq 'entry') {
		# エントリー
		require "$dirlib/cmd_entry.pl";
		&SWCmdEntry::CmdEntry($sow);
	} elsif ($cmd eq 'cfg') {
		# モバイル用設定画面
		require "$dirhtml/html_loginform_mb.pl";
		&SWHtmlLoginFormMb::OutHTMLLoginMb($sow);
	} elsif ($cmd eq 'exit') {
		# 村から出る
		require "$dirlib/cmd_exit.pl";
		&SWCmdExit::CmdExit($sow);
	} elsif ($cmd eq 'kick') {
		# 村から退去
		require "$dirlib/cmd_exit.pl";
		&SWCmdExit::CmdKick($sow);
	} elsif ($cmd eq 'maker') {
		# 村建て権限を譲る。
		require "$dirlib/cmd_maker.pl";
		&SWCmdMaker::CmdMaker($sow);
	} elsif ($cmd eq 'muster') {
		# 村を点呼します。
		require "$dirlib/cmd_muster.pl";
		&SWCmdMuster::CmdMuster($sow);
	} elsif ($cmd eq 'gamemaster') {
		# 状態変更
		require "$dirlib/cmd_gamemaster.pl";
		&SWCmdGameMaster::CmdGameMaster($sow);
	} elsif ($cmd eq 'writepr') {
		# 発言プレビュー表示
		require "$dirlib/cmd_writepr.pl";
		&SWCmdWritePreview::CmdWritePreview($sow);
	} elsif ($cmd eq 'wrformmb') {
		# 発言フォーム表示（モバイル）
		require "$dirlib/cmd_wrformmb.pl";
		&SWCmdWriteFormMb::CmbWriteFormMb($sow);
	} elsif ($cmd eq 'wrmemoformmb') {
		# メモ書き込みフォーム（モバイル）
		require "$dirlib/cmd_memoformmb.pl";
		&SWCmdWriteMemoFormMb::CmbWriteMemoFormMb($sow);
	} elsif ($cmd eq 'write') {
		# 発言
		require "$dirlib/cmd_write.pl";
		&SWCmdWrite::CmdWrite($sow);
	} elsif ($cmd eq 'cancel') {
		# 発言撤回
		require "$dirlib/cmd_cancel.pl";
		&SWCmdCancel::CmdCancel($sow);
	} elsif ($cmd eq 'action') {
		# アクション
		require "$dirlib/cmd_action.pl";
		&SWCmdAction::CmdAction($sow);
	} elsif ($cmd eq 'wrmemo') {
		# メモ書き込み
		require "$dirlib/cmd_wrmemo.pl";
		&SWCmdWriteMemo::CmdWriteMemo($sow);
	} elsif ($cmd eq 'editjob') {
		# 肩書き変更
		require "$dirlib/cmd_editjob.pl";
		&SWCmdEditJobName::CmdEditJobName($sow);
	} elsif ($cmd eq 'start') {
		# 村開始
		&CheckValidityStart($sow);
		require "$dirlib/cmd_start.pl";
		&SWCmdStartSession::CmdStartSession($sow);
	} elsif (($cmd eq 'entrust') || ($cmd eq 'vote') || ($cmd eq 'role') || ($cmd eq 'gift')){
		# 投票／能力対象設定
		require "$dirlib/cmd_vote.pl";
		&SWCmdVote::CmdVote($sow);
	} elsif ($cmd eq 'commit') {
		# 時間を進める
		require "$dirlib/cmd_commit.pl";
		&SWCmdCommit::CmdCommit($sow);
	} elsif ($cmd eq 'debugvil') {
		# 村データの表示（デバッグ用）
		require "$dirhtml/html_debugvil.pl";
		&SWHtmlDebugVillage::OutHTMLDebugVillage($sow);
	} elsif ($cmd eq 'scrapvil') {
		# 廃村（手動、デバッグ用）
		&CheckValidityUpdate($sow);
		require "$dirlib/cmd_update.pl";
		&SWCmdUpdateSession::CmdUpdateSession($sow);
	} elsif ($cmd eq 'update') {
		# 更新（手動、デバッグ用）
		&CheckValidityUpdate($sow);
		require "$dirlib/cmd_update.pl";
		&SWCmdUpdateSession::CmdUpdateSession($sow);
	} elsif ($cmd eq 'extend') {
		# １日延長
		require "$dirlib/cmd_extend.pl";
		&SWCmdExtend::CmdExtend($sow);
	} elsif ($cmd eq 'admin') {
		# 管理画面
		require "$dirhtml/html_admin.pl";
		&SWHtmlAdminManager::OutHTMLAdminManager ($sow);
	} elsif ($cmd eq 'restrec') {
		# 戦績再構築
		require "$dirlib/cmd_restrec.pl";
		&SWCmdRestRecord::CmdRestRecord($sow);
	} elsif (($cmd eq 'restviform') || ($cmd eq 'restvi')) {
		# 村一覧再構築
		require "$dirlib/cmd_restvi.pl";
		&SWCmdRestVIndex::CmdRestVIndex($sow);
	} elsif ($cmd eq 'deletevil') {
		# 村データ削除
		require "$dirlib/cmd_deletevil.pl";
		&SWCmdDeleteVil::CmdDeleteVil($sow);
	} elsif ($cmd eq 'movevil') {
		# 村データ移動
		require "$dirlib/cmd_movevil.pl";
		&SWCmdMoveVil::CmdMoveVil($sow);
	} elsif (($cmd eq 'editpform') || ($cmd eq 'editpenalty')) {
		# ペナルティ設定・解除
		require "$dirlib/cmd_editpenalty.pl";
		&SWCmdEditPenalty::CmdEditPenalty($sow);
	} elsif ($cmd eq 'rss') {
		# RSS出力
		require "$dirlib/cmd_rss.pl";
		&SWCmdRSS::CmdRSS($sow);
	} elsif ($cmd eq 'summary') {
		# 村一覧情報出力
		require "$dirlib/cmd_rss.pl";
		&SWCmdRSS::CmdRSS($sow);
	} elsif ($cmd eq 'chrlist') {
		# キャラ一覧の表示
		require "$dirlib/cmd_chrlist.pl";
		&SWCmdChrList::CmdChrList($sow);
	} elsif ($cmd eq 'score') {
		# 人狼譜の出力（暫定）
		require "$dirhtml/html_score.pl";
		&SWHtmlScore::OutHTMLScore($sow);
	} elsif ($cmd eq 'oldlog') {
		# 終了済みの村表示
		require "$dirhtml/html_oldlog.pl";
		&SWHtmlOldLog::OutHTMLOldLog($sow);
	} elsif (($cmd eq 'memo') || ($cmd eq 'hist')) {
		# メモ表示
		require "$dirlib/cmd_memo.pl";
		&SWCmdMemo::CmdMemo($sow);
	} elsif ($cmd eq 'restmemo') {
		# メモインデックス再構築
		require "$dirlib/cmd_restmemo.pl";
		&SWCmdRestMemoIndex::CmdRestMemoIndex($sow);
	} elsif (($cmd eq 'exitpr')) {
		# 確認画面（更新）
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
		# 確認画面（更新）
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
		# 遊び方／ルール／概略の表示
		require "$dirhtml/html_doc.pl";
		&SWHtmlDocument::OutHTMLDocument($sow);
	} elsif (defined($sow->{'query'}->{'vid'})) {
		# 村ログ表示
		require "$dirlib/cmd_vlog.pl";
		&SWCmdVLog::CmdVLog($sow);
	} else {
		if ($sow->{'outmode'} eq 'mb') {
			# モバイル用ログイン画面
			require "$dirhtml/html_loginform_mb.pl";
			&SWHtmlLoginFormMb::OutHTMLLoginMb($sow);
		} else {
			# トップページ表示
			require "$dirhtml/html_index.pl";
			&SWHtmlIndex::OutHTMLIndex($sow);
		}
	}

	return;
}

#----------------------------------------
# 村手動開始時値チェック
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

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "村を開始するには村建て人権限か管理人権限が必要です。", "no permition.$errfrom") if (($sow->{'uid'} ne $vil->{'makeruid'}) && ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}));

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "人数が足りません。ダミーキャラを含め、最低 4 人必要です。", "need 4 persons.$errfrom") if (@$pllist < 4);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "現在参加している人数と定員が等しくありません。", "invalid vplcnt or total plcnt.$errfrom") if ((@$pllist != $vil->{'vplcnt'}) && ($vil->{'roletable'} eq 'custom'));

	return;
}

#----------------------------------------
# 村手動更新時値チェック
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

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}) {
		if ($sow->{'query'}->{'cmd'} eq 'scrapvil') {
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "廃村するには管理人権限が必要です。", "no permition.$errfrom");
		} else {
			$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "村を更新するには村建て人権限か管理人権限が必要です。", "no permition.$errfrom") if ($sow->{'uid'} ne $vil->{'makeruid'});
		}
	}

	return;
}

#----------------------------------------
# インストールチェック
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
  <title>インストールチェック</title>
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

<h2>インストールチェック</h2>

<ul>
  <li>Perl: [OK]</li>
_HTML_

	# 設定データファイルのチェック
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
# インストールチェックの終了
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
# ファイルチェック
#----------------------------------------
sub FileCheck {
	my ($cfg, $file, $w, $x, $make) = @_;
	my $result = 1;

	print "<li>$file: ";
	if (-e $file) {
		print "[OK]";
		if (-r $file) {
			print " / 読込 [OK]";
		} else {
			print " / 読込 <strong>[NG]</strong>";
			$result = 0;
		}
		if ($w > 0) {
			if (-w $file) {
				print " / 書込 [OK]";
			} else {
				print " / 書込 <strong>[NG]</strong>";
				$result = 0;
			}
		}
		if ($x > 0) {
			if (-x $file) {
				print " / 実行 [OK]";
			} else {
				print " / 実行 <strong>[NG]</strong>";
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
# ダミーキャラ・管理人用IDのチェック
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
