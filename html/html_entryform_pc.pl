
package SWHtmlEntryFormPC;

#----------------------------------------
# エントリーフォームの出力
#----------------------------------------
sub OutHTMLEntryFormPC {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};

	my $allpllist = $vil->getallpllist();
	my $pllist    = $vil->getpllist();
	my $mobs      = $vil->getrolepllist($sow->{'ROLEID_MOB'});
	my $isplok    = $vil->{'vplcnt'} - @$pllist;
	my $ismobok   = $vil->{'cntmob'} - @$mobs  ;

	# 発言欄textarea要素の出力
	my ($saycnt,$cost,$unit,$max_line,$max_size) = $vil->getsayptcosts();

    if ($isplok) {
		print <<"_HTML_"
gon.cautions.push("あと $isplok 人参加できます。");
_HTML_
    } else {
		print <<"_HTML_"
gon.cautions.push("既に定員に達しています。");
_HTML_
    }
	return unless (($isplok)||($ismobok));

	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";

	# キャラセットの読み込み
	my @csidkey = split('/', "$vil->{'csid'}/");
	foreach (@csidkey) {
		$sow->{'charsets'}->loadchrrs($_);
	}

	# 参加済みのキャラをチェック
	my %csid_cid;
	foreach (@$allpllist) {
		$csid_cid{"$_->{'csid'}/$_->{'cid'}"} = 1;
	}

	print <<"_HTML_";
gon.potof || (gon.potof = {
    sow_auth_id: "$sow->{'uid'}"
});
text_form = {
	cmd: "entry",
	jst: "entry",
	text: "",
	style: "",
	count: "",
	title: "この村に参加",
	caption: "",
	mestype: "SAY",
	longname: "",
	max: {
		unit: "$cost",
		line: $max_line,
		size: $max_size
	}
};

(function(){
var a = [];
var b = [];
var c = [];
_HTML_
	foreach $csid_val (@csidkey) {
		my $charset = $sow->{'charsets'}->{'csid'}->{$csid_val};
		my $tagorder = $charset->{'TAG_ORDER'};
		foreach (@$tagorder) {
			if (! $tag) { $tag = $_; }
			my $tagname = $sow->{'charsets'}->{'tag'}->{'TAG_NAME'}->{$_};
			my $selected = '';
			my $star = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($_ eq $tag);
			$star = "* " if ($_ eq $tag);
			print "a.push({val:\"$_\", name:\"$tagname\"});\n";
		}
	}
	# 希望する配役の表示
	my $csid_val;
	foreach $csid_val (@csidkey) {
		my $charset = $sow->{'charsets'}->{'csid'}->{$csid_val};
		my $chrorder = $charset->{'ORDER'};
		foreach (@$chrorder) {
			next if (defined($csid_cid{"$csid_val/$_"})); # 参加済みのキャラは除外
			my $chrname = $sow->{'charsets'}->getchrname($csid_val, $_);
			print "b.push({val:\"$csid_val/$_\", name:\"$chrname\"});\n";
		}
	}
	# 希望する能力の表示
	if ($isplok) {
		my $rolename = $sow->{'textrs'}->{'ROLENAME'};
		if ($vil->{'mob'} eq 'gamemaster'){
			print "c.push({val:0, name:\"$rolename->[0]\"});\n";
		} else {
			print "c.push({val:-1, name:\"$sow->{'textrs'}->{'RANDOMROLE'}\"});\n";

			my ( $rolematrix, $giftmatrix ) = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'});

			my $i;
			foreach ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
				my $output = $rolematrix->[$i];
				$output = 1 if ($i == 0); # おまかせは必ず表示
				print "c.push({val:$i, name:\"$rolename->[$i]\"});\n" if ($output > 0);
			}
		}
	}
	if ($ismobok){
		my $mob = $sow->{'basictrs'}->{'MOB'}->{$vil->{'mob'}}->{'CAPTION'};
		print "c.push({val:$sow->{'ROLEID_MOB'}, name:\"$mobで見物\"});\n";
	}
	print <<"_HTML_";
text_form.tags      = a;
text_form.csid_cids = b;
text_form.roles     = c;
})();

text_form.csid_cid = text_form.csid_cids[0].val;
text_form.role     = text_form.roles[0].val;
gon.form.texts.push(text_form);
_HTML_

}

1;
