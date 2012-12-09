package SWLog;

#----------------------------------------
# 発言関連ライブラリ
#----------------------------------------

#----------------------------------------
# ログIDの生成
#----------------------------------------
sub CreateLogID {
	my ($sow, $mestype, $logsubid, $logcnt) = @_;
	my $logid = sprintf(
		"%s%s%05d",
		$sow->{'LOGMESTYPE'}->[$mestype],
		$logsubid,
		$logcnt,
	);

	return $logid;
}

#----------------------------------------
# ログIDを配列に分割して返す
#----------------------------------------
sub GetLogIDArray {
	my $logmestype = substr($_[0]->{'logid'}, 0, 1);
	my $logsubid = substr($_[0]->{'logid'}, 1, 1);
	my $logcnt = substr($_[0]->{'logid'}, 2);

	return ($logmestype, $logsubid, $logcnt);
}

#----------------------------------------
# アンカー用のログ番号を取得
#----------------------------------------
sub GetAnchorlogID {
	my ($sow, $vil, $log) = @_;
	my ($logmestype, $logsubid, $logcnt) = &GetLogIDArray($log);

	$logcntnum = int($logcnt);
	my $loganchormark = $sow->{'MARK_LOGANCHOR'}->{$logmestype};
	my $loganchor = '';
	$loganchor = " ($loganchormark$logcntnum)" if ((defined($loganchormark))&&($loganchormark ne '----'));

	$loganchor = '' if ($logcntnum == $sow->{'LOGCOUNT_UNDEF'});
	$loganchor = '' if (($log->{'mestype'} == $sow->{'MESTYPE_TSAY'}) && ($vil->isepilogue() == 0));
	$loganchor = '' if (($log->{'mestype'} == $sow->{'MESTYPE_AIM'})  && ($vil->isepilogue() == 0));

	return $loganchor;
}

#----------------------------------------
# アンカーを内部データ形式に変換
#----------------------------------------
sub ReplaceAnchor {
	my ($sow, $vil, $say) = @_;
	my $mes     = $say->{'mes'};
	my $saypl   = $vil->getpl($say->{'uid'});
	my $sayturn = $sow->{'turn'};

	while ($mes =~ /&gt;&gt;[\+\-\*\#\%\=\!\@]?(\d{1,$sow->{'MAXWIDTH_TURN'}}:)?[\+\-\*\#\%\=\!\@]?\d{1,$sow->{'MAXWIDTH_LOGCOUNT'}}/) {
		my $anchortext = $&;
		my ($mestypestr, $mestypestr2, $turn, $logno);
		$anchortext =~ /(&gt;&gt;)([AS]?)([\+\-\*\#\%\=\!\@]?)(\d+:)?([\+\-\*\#\%\=\!\@]?)(\d+)/;
		my $mestypemark1 = $3;
		my $mestypemark2 = $5;
		$mestypestr = $3;
		$turn = $4;
		$mestypestr = $5 if ($mestypestr eq '');
		$logno = $6;

		if (defined($turn)) {
			chop($turn);
		} else {
			$turn = $sayturn;
		}

		# ログIDの生成
		$mestypestr = '' if (!defined($mestypestr));
		my $mestype = $sow->{'MESTYPE_SAY'};
		my $logmestype = $sow->{'LOGMESTYPE'};
		my $loganchormark = $sow->{'MARK_LOGANCHOR'};
		my $i;
		for ($i = 1; $i <= $sow->{'MESTYPE_LAST'}; $i++) {
			$mestype = $i if ($mestypestr eq $loganchormark->{$logmestype->[$i]});
		}

		my $logsubid = $sow->{'LOGSUBID_SAY'};
#		$logsubid = $sow->{'LOGSUBID_ACTION'} if (defined($2) && ($2 eq $sow->{'LOGSUBID_ACTION'})); # てへっ♪（ぉぃ
		my $logid = &CreateLogID($sow, $mestype, $logsubid, $logno);

		# 比較するとき。内緒話は独り言扱い、憑依は通常発言扱い。……泥臭い！
		$mestype = $sow->{'MESTYPE_TSAY'}  if (($mestype == $sow->{'MESTYPE_AIM'}));
		$mestype = $sow->{'MESTYPE_SAY'}   if (($mestype == $sow->{'MESTYPE_MSAY'}));

		# リンクの文字列用データ
		my $linktext = $anchortext;
		$linktext =~ s/&gt;&gt;//;

		my $mwtag = "<mw $logid,$turn,$linktext>";
		my $skipmwtag = $anchortext;
		$skipmwtag =~ s/&gt;&gt;/<mw>/;

		# 妥当性チェック
		my $saymestype = $say->{'mestype'};
		# 比較するとき。内緒話は独り言扱い、憑依は通常発言扱い。……泥臭い！
		$saymestype = $sow->{'MESTYPE_TSAY'} if (($saymestype == $sow->{'MESTYPE_AIM'}));
		$saymestype = $sow->{'MESTYPE_SAY'}  if (($saymestype == $sow->{'MESTYPE_MSAY'}));
		$saymestype = $sow->{'MESTYPE_SAY'}  if (($saymestype == $sow->{'MESTYPE_VSAY'})&&( 0 <  $sayturn )&&($vil->{'mob'} eq 'alive'));
		$saymestype = $sow->{'MESTYPE_SAY'}  if (($saymestype == $sow->{'MESTYPE_VSAY'})&&( 0 == $sayturn ));

		my $rolesay = $sow->{'textrs'}->{'CAPTION_ROLESAY'};
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "秘密会話へのアンカーを通常発言に打つ事はできません。","cannot anchor [$mestype].") if (($vil->isepilogue() == 0) && ($saymestype == $sow->{'MESTYPE_SAY'})  && (($mestype == $sow->{'MESTYPE_WSAY'}) || ($mestype == $sow->{'MESTYPE_SPSAY'}) || ($mestype == $sow->{'MESTYPE_XSAY'})));

		$mwtag = $skipmwtag if (($mestypemark1 ne '') && ($mestypemark2 ne '')); # 種別指定が２つある
		my $enableanc = 0;
		# 見物人＠プロローグ、通常発言、村建て人、管理人は常にアンカー可能。
		# 日蝕
		if (! $vil->iseclipse($turn)){
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_SAY'}));
		}
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_MAKER'}));
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_ADMIN'}));
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_VSAY'})&&( 0 == $turn ));
		if ($vil->isepilogue() == 1) {
				# エピローグから、進行中はすべてOK。
				$enableanc = 1 if                                        ( 0 != $turn );
				# プロローグ独り言を許可。（秘密発言は存在しないので、許可しない）
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_TSAY'})&&( 0 == $turn ));
		} else {
				# 進行中
				# 見物人（舞台）
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'alive'));
				# 同種の秘密発言同士の会話（独り言は除外している。）
				$enableanc = 1 if (($mestype == $saymestype)&&($mestype != $sow->{'MESTYPE_TSAY'}));
			# 生きていない条件での会話
			if ($saypl->{'live'} ne 'live'){
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_VSAY'})&&($saymestype == $sow->{'MESTYPE_GSAY'})&&($vil->{'mob'} eq 'grave'));
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_VSAY'})&&($saymestype == $sow->{'MESTYPE_TSAY'})&&($vil->{'mob'} eq 'grave'));
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_GSAY'})&&($saymestype == $sow->{'MESTYPE_VSAY'})&&($vil->{'mob'} eq 'grave'));
				$enableanc = 1 if (($mestype == $sow->{'MESTYPE_GSAY'})&&($saymestype == $sow->{'MESTYPE_TSAY'}));
			}
		}
#		$skipmwtag .= '('.$mestype.'_'.$saymestype.')';
		$mwtag = $skipmwtag if ($enableanc == 0);

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		# 変換
		$mes =~ s/$anchortext/$mwtag/;
	}
	$mes =~ s/<mw>/&gt;&gt;/g;

	return $mes;
}

#----------------------------------------
# 内部データ形式のアンカーをHTMLに整形
#----------------------------------------
sub ReplaceAnchorHTML {
	my ($sow, $vil, $mes, $anchor) = @_;
	my $cfg = $sow->{'cfg'};

#	my $reqvals = &SWBase::GetRequestValues($sow);
	my $reqvals = $anchor->{'reqvals'};
	my $blank = $sow->{'html'}->{'target'};

	$$mes =~ s/(s?https?:\/\/[^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/<a href=\"$&\" class=\"res_anchor\"$blank>$1...<\/a>/g;

	while ($$mes =~ /<mw ([a-zA-Z]+\d+),([^,]*),([^>]+)>/) {
		my $anchortext = $&;
		my $logid = $1;
		my $turn = $2;
		my $linktext = $3;

		$reqvals->{'pno'} = '';
		$reqvals->{'row'} = '';
		$reqvals->{'turn'} = '';
		$reqvals->{'logid'} = '';
		my $link = '';
		my $title = '';
		$anchor->{'logkeys'}->{$logid} = -1 if (!defined($anchor->{'logkeys'}->{$logid}));
		if ($turn == $sow->{'turn'}) {
#			if (($anchor->{'rowover'} == 0) || ($anchor->{'logkeys'}->{$logid} >= 0)) {
			if ($anchor->{'logkeys'}->{$logid} >= 0) {
				$reqvals->{'rowall'} = '';
				$link = "#$logid";
				$blank = '';
				$title = &GetPopupAnchor($sow, $vil, $logid, $anchor) if ($sow->{'cfg'}->{'ENABLED_POPUP'} > 0);
			} else {
				$reqvals->{'turn'} = $turn if ($turn != $vil->{'turn'});
				$reqvals->{'logid'} = $logid;
				$link = &SWBase::GetLinkValues($sow, $reqvals);
				$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
				$title = &GetPopupAnchor($sow, $vil, $logid, $anchor) if ($sow->{'cfg'}->{'ENABLED_POPUP'} > 0);
			}
		} else {
			$reqvals->{'turn'} = $turn if ($turn != $vil->{'turn'});
			$reqvals->{'logid'} = $logid;
			$link = &SWBase::GetLinkValues($sow, $reqvals);
			$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
		}

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		$title = " title=\"$title\"" if ($title ne '');
		$$mes =~ s/$anchortext/<a href=\"$link\" class=\"res_anchor\"$blank$title>&gt;&gt;$linktext<\/a>/;
	}

	return $mes;
}

#----------------------------------------
# ポップアップアンカー
#----------------------------------------
sub GetPopupAnchor {
	my ($sow, $vil, $logid, $anchor) = @_;
	my $title = '';

	my $logidxno = $anchor->{'logfile'}->{'logindex'}->{'file'}->getbyid($logid);
	if ($logidxno >= 0) {
		my $logidx = $anchor->{'logfile'}->{'logindex'}->{'file'}->getlist->[$logidxno];
		my $log = $anchor->{'logfile'}->read($logidx->{'pos'});
		my $chrname = $log->{'chrname'};
		my $targetmes = &ReplaceAnchorHTMLRSS($sow, $vil, $log->{'log'}, $anchor);
		$targetmes =~ s/<br( \/)?>/ /ig;
		$title = "$chrname：$targetmes";
	}

	return $title;
}

#----------------------------------------
# 内部データ形式のアンカーをHTMLに整形（モバイル用）
#----------------------------------------
sub ReplaceAnchorHTMLMb {
	my ($sow, $vil, $mes, $anchor) = @_;
	my $cfg = $sow->{'cfg'};
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $redirect = 'http://utage.sytes.net/wolf/redirect.cgi?';

	$mes =~ s/s?https?:\/\/([^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/ <a href=\"$redirect$&\">$1...<\/a>/g;

	while ($mes =~ /<mw ([a-zA-Z]+\d+),([^,]*),([^>]+)>/) {
		my $anchortext = $&;
		my $logid = $1;
		my $turn = $2;
		my $linktext = $3;

		$reqvals->{'turn'} = '';
		$reqvals->{'pno'} = '';
		my $link = '';
		$turn = $sow->{'query'}->{'turn'} if ($turn eq '');
		$anchor->{'logkeys'}->{$logid} = -1 if (!defined($anchor->{'logkeys'}->{$logid}));
		if (($turn == $sow->{'turn'}) && (($anchor->{'rowover'} == 0) || ($anchor->{'logkeys'}->{$logid} >= 0))) {
			$link = "#$logid";
		} else {
			$reqvals->{'turn'} = $turn if ($turn != $vil->{'turn'});
			$reqvals->{'logid'} = $logid;
			$link = &SWBase::GetLinkValues($sow, $reqvals);
			$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
		}

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		$mes =~ s/$anchortext/ <a href=\"$link\">&gt;&gt;$linktext<\/a>/;
#		$mes =~ s/$anchortext/ &gt;&gt;$linktext/;
	}

	return $mes;
}

#----------------------------------------
# 内部データ形式のアンカーをテキストに整形（RSS向け）
# ※引数の $anchor は未使用
#----------------------------------------
sub ReplaceAnchorHTMLRSS {
	my ($sow, $vil, $mes, $anchor) = @_;
	my $cfg = $sow->{'cfg'};


	while ($mes =~ /<mw ([a-zA-Z]+\d+),([^,]*),([^>]+)>/) {
		my $anchortext = $&;
		my $linktext = $3;

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		$mes =~ s/$anchortext/ &gt;&gt;$linktext/;
	}
	while ($mes =~ /<rand ([^,]+),([^>]+)>/) {
		my $randtext = $&;
		my $valtext = $1;

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$randtext);

		$mes =~ s/$randtext/ $valtext/;
	}
	$mes =~ s/<(\/)?strong>//g;

	return $mes;
}

#----------------------------------------
# 内部データ形式のアンカーをテキストに整形（メモ欄向け）
#----------------------------------------
sub ReplaceAnchorHTMLText {
	my ($sow, $vil, $mes, $anchor) = @_;
	$mes = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $mes, $anchor);
	$mes =~ s/<br( \/)?>/\\n/ig;
	$mes =~ s/&gt;/>/ig;
	$mes =~ s/&lt;/</ig;
	return $mes;
}


#----------------------------------------
# 正規表現での誤認識を防ぐため記号を変換
#----------------------------------------
sub BackQuoteAnchorMark {
	my $anchortext = shift;

	$$anchortext =~ s/\+/\\\+/g;
	$$anchortext =~ s/\*/\\\*/g;
	$$anchortext =~ s/\-/\\\-/g;
	$$anchortext =~ s/\#/\\\#/g;
	$$anchortext =~ s/\%/\\\%/g;
	$$anchortext =~ s/\!/\\\!/g;
	$$anchortext =~ s/\=/\\\=/g;
	$$anchortext =~ s/\@/\\\@/g;
	$$anchortext =~ s/\[/\\[/g;
	$$anchortext =~ s/\]/\\]/g;
	$$anchortext =~ s/\(/\\(/g;
	$$anchortext =~ s/\)/\\)/g;

	return $anchortext;
}

#----------------------------------------
# ランダム表示機能
#----------------------------------------
sub do_random_dice {
	my ($x,$base,$n) = @_;
	my $i=0;
	my $a=0;
	for(; $i < $x ; $i++ ){
		$a += int(rand($n))+$base;
	}
	return $a;
}

sub do_random_role {
	my ($sow,$list) = @_;
	my $rolename = $sow->{'textrs'}->{$list};
	my $roleno = 1;
	do {
		$roleno = int(rand(scalar(@$rolename)-1))+1;
	} while ("" eq $rolename->[$roleno]);
	return $rolename->[$roleno];
}

sub do_random_who {
	my ($vil) = @_;

	my $livepllist = $vil->getlivepllist();
	$livepllist = $vil->getallpllist() if (($vil->{'turn'} == 0)||($vil->{'turn'} >= $vil->{'epilogue'}));

	$who = int(rand(scalar(@$livepllist)));
	return $livepllist->[$who]->getchrname();
}

sub do_random_mikuji {
	my ($cfg) = @_;

	$mikuji = $cfg->{'MIKUJI'};
	$length = scalar(@$mikuji);
	$size   = 3;
	$index  = int(&do_random_dice($size,0,$length) / $size);
	return $mikuji->[$index];
}

sub trim_random_cap {
	my ($src) = @_;
	$src =~ s/\[//g;
	$src =~ s/\]//g;
	return $src;
}

sub CvtRandomText {
	my ($sow, $vil, $mes) = @_;
	my $cfg = $sow->{'cfg'};

	return $mes if ($cfg->{'ENABLED_RANDOMTEXT'} == 0);

	# xDn
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_DICE'}\]\]/{my $a = &do_random_dice($1,1,$2);my $b = &trim_random_cap($&);"<rand $a,$b = (1..$2)x$1>"}/eg;

	# fortune
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_FORTUNE'}\]\]/{my $a = &do_random_dice(1,0,100);my $b = &trim_random_cap($&);"<rand $a,$b = (0..100)>"}/eg;

	# who
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_LIVES'}\]\]/{my $a = &do_random_who($vil);my $b = &trim_random_cap($&);"<rand $a,$b>"}/eg;

	# omikuji
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_MIKUJI'}\]\]/{my $a = &do_random_mikuji($cfg);my $b = &trim_random_cap($&);"<rand $a,$b>"}/eg;

	# role
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_ROLE'}\]\]/{my $a = &do_random_role($sow,'ROLENAME');my $b = &trim_random_cap($&);"<rand $a,$b>"}/eg;

	return $mes;
}

1;
