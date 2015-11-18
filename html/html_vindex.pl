package SWHtmlVIndex;

#----------------------------------------
# 村の一覧HTML出力
#----------------------------------------
sub OutHTMLVIndex {
	my ($sow, $vindex, $vmode) = @_;
	my $vilist = $vindex->getvilist();

	foreach (@$vilist) {
		my $date = sprintf("%02d:%02d", $_->{'updhour'}, $_->{'updminite'});

		my $vstatusno = 'playing';
		$vstatusno = 'prologue' if ($_->{'vstatus'} == $sow->{'VSTATUSID_PRO'}); # プロローグ
		$vstatusno = 'oldlog'   if ($_->{'vstatus'} == $sow->{'VSTATUSID_END'});
		$vstatusno = 'dispose'  if ($_->{'vstatus'} == $sow->{'VSTATUSID_SCRAPEND'});

		next if ($vstatusno ne $vmode); # 指定していない村は除外

		my $vil = SWFileVil->new($sow, $_->{'vid'});
		$vil->readvil();
		my $pllist = $vil->getpllist();
		my $allpllist = $vil->getallpllist();
		$vil->closevil();

		if (!defined($vil->{'trsid'})) {
			# 村データがぶっ飛んだ場合に一応被害を食い止める
			print <<"_HTML_";
gon.stories.push({});
_HTML_
			next;
		}

		&SWBase::LoadTextRS($sow, $vil);
		my $plcnt = sprintf("%02d",scalar(@$pllist));
		if ($vmode eq 'prologue') {
			$plcnt .= "/".sprintf("%02d",$vil->{'vplcnt'});
		} else {
			$plcnt .= '人';
		}
		my $countmob = (scalar(@$allpllist) - scalar(@$pllist));
		$plcnt .= "+".$countmob."人" if ($countmob);

		my $vstatus = "$vil->{'turn'}日目";
		if ($vil->{'winner'} != 0) {
			$vstatus = '決着';
			$plcnt .= "$note_start<br>".$sow->{'textrs'}->{'CAPTION_WINNER'}->[$vil->{'winner'}]."$note_end";
		} elsif ($vil->isepilogue() > 0) {
			$vid = '&vid='.$_->{'vid'};
			$cssid = '';
			$cssid = '&css='.$sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
			$vstatus = '廃村';
			$vstatus = '<a href="sow.cgi?cmd=editvilform&status=dispose'.$vid.$cssid.'">やり直す</a>' if(($sow->{'uid'} ne '')&&($sow->{'uid'} ne $vil->{'makeruid'}));
		}
		if ($vmode eq 'oldlog') {
			my $numdays = $vil->{'turn'} - 2;
			$vstatus = sprintf("%02d日",$numdays);
		} else {
			$vstatus = "$vstatus";
		}
		if ($vil->{'turn'} == 0) {
			if ($vil->{'vplcnt'} > @$pllist) {
				$vstatus = '募集中';
			} else {
				$vstatus = '開始前';
			}
		}

		$reqvals->{'cmd'} = '';
		$reqvals->{'vid'} = $_->{'vid'};
		if ($vmode eq 'oldlog'){
			$reqvals->{'turn'} = 0;
			$reqvals->{'rowall'} = 'on';
		}
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?".$link;

		my $vid_fmt = "%01d";
		$vid_fmt = "%02d" if (10   <= @$vilist);
		$vid_fmt = "%03d" if (100  <= @$vilist);
		$vid_fmt = "%04d" if (1000 <= @$vilist);
		my $vid  = sprintf($vid_fmt,$_->{'vid'});

		print <<"_HTML_";
gon.stories.push({
	trs: "$sow->{'textrs'}->{'CAPTION'}",
	mode: "$vmode",
	status: "$vstatus",
	entry_limit: "$vil->{'entrylimit'}",
	player_count: "$plcnt",

	vid: "$vid",
	turn $vil->{'turn'},
	name: "$vil->{'vname'}",
	link: "$link",
	rating: "$vil->{'rating'}",
	sow_auth_id: "$vil->{'makeruid'}",
	vpl: [ $vil->{'vplcnt'}, $vil->{'vplcntstart'}],
	card: {
		config: [],
		event: [],
	},
	type: {
		roletable: "$vil->{'roletable'}",
		game: "$vil->{'csid'}",
		vote: "$vil->{'votetype'}",
		mob: "$vil->{'mob'}",
		say: "$vil->{'saycnttype'}"
	},
	upd: {
	  hour, $vil->{'updhour'},
		minute, $vil->{'updminute'},
		interval: $vil->{'updinterval'}
	}
});
_HTML_

	}
}

1;
