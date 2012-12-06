package SWDocRoleList;

#----------------------------------------
# 役職一覧画面のタイトル
#----------------------------------------
#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => '役職とインターフェイス', # タイトル
	};

	return bless($self, $class);
}

sub getTurn {
	my ($self,$pl) = @_;
	my $sow = $self->{'sow'};

	my $turn = 3;
	$turn = 1 if( $sow->{'GIFTID_GLASS'}     == $pl->{'gift'} );
	$turn = 1 if( $sow->{'ROLEID_SNATCH'}    == $pl->{'role'} );
	$turn = 1 if( $sow->{'ROLEID_BITCH'}     == $pl->{'role'} );
	$turn = 1 if( $sow->{'ROLEID_TRICKSTER'} == $pl->{'role'} );
	$turn = 1 if( $sow->{'ROLEID_LOVEANGEL'} == $pl->{'role'} );
	$turn = 1 if( $sow->{'ROLEID_HATEDEVIL'} == $pl->{'role'} );
	$turn = 1 if( $sow->{'ROLEID_LOVER'}     == $pl->{'role'} );
	$turn = 2 if( $sow->{'ROLEID_LONEWOLF'}  == $pl->{'role'} );
	$turn = 2 if( $pl->iswolf() > 0 );
	return $turn;
}

#----------------------------------------
# 役職一覧HTML出力
#----------------------------------------
sub outhtml {
	my $self  = shift;
	my $sow   = $self->{'sow'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $emulatedays = 2;
	$emulatedays = 1 if (($query->{'roleid'} ne '')&&($sow->{$query->{'roleid'}} eq $sow->{'ROLEID_SNATCH'}));
	$emulatedays = 1 if (($query->{'roleid'} ne '')&&($sow->{$query->{'roleid'}} eq $sow->{'ROLEID_LOVER'}));
	$emulatedays = 1 if (($query->{'roleid'} ne '')&&($sow->{$query->{'roleid'}} eq $sow->{'ROLEID_ROBBER'}));
	$emulatedays = 1 if (($query->{'giftid'} ne '')&&($sow->{$query->{'giftid'}} eq $sow->{'GIFTID_SEERONCE'}));
	$emulatedays = $query->{'emulatedays'} if (defined($sow->{'query'}->{'emulatedays'}));
	$sow->{'cfg'}->{'ENABLED_SUDDENDEATH'} = 0;
	$sow->{'cfg'}->{'ENABLED_SCORE'}       = 0;
	my $docid = "css=$sow->{'query'}->{'css'}&trsid=$sow->{'query'}->{'trsid'}";

	require "$cfg->{'DIR_LIB'}/file_vil.pl";

	print <<"_HTML_";
<hr class="invisible_hr"$net>
<h2>役職能\力早見表\</h2>
_HTML_

	# ダミーデータの生成
	my $vil = SWFileVil->new($sow, 0);
	$vil->createdummyvil();
	$vil->{'csid'}  = $sow->{'cfg'}->{'DEFAULT_CSID'};
	$vil->{'trsid'} = $sow->{'query'}->{'trsid'};
	$vil->{'game'}  = $sow->{'query'}->{'game'};
	$vil->{'saycnttype'} = 'infinity';
	$vil->{'mob'} = 'alive';
	$vil->{'turn'} = 1;
	$vil->{'winner'} = 0;
	$vil->{'randomtarget'} = 1;
	$vil->{'makeruid'} = $sow->{'cfg'}->{'USERID_ADMIN'};
	$vil->{'eventcard'} = '8/8/8/8/8/8/8/8/8';
#	$vil->{'event'} = '14';
	$vil->{'rolediscard'} = '41/31/11';
	$vil->{'rolediscard'} = '63/27/91' if ($vil->{'trsid'} eq 'millerhollow');
#	$vil->{'grudge'}    = 2;  # 人狼の復讐
#	$vil->{'riot'}      = 2;  # 村人の暴動
#	$vil->{'riot'}      = 3;  # 村人の暴動
#	$vil->{'scapegoat'} = 4;  # スケープゴートの指示
	$sow->{'turn'} = $vil->{'turn'};

	$sow->{'savedraft'} = '';

	# リソースの読み込み
	my %csidlist = ();
	$csidlist{$vil->{'csid'}} = 1;
	$sow->{'csidlist'} = \%csidlist;
	&SWBase::LoadVilRS($sow, $vil);
	my $order = $sow->{'charsets'}->{'csid'}->{$vil->{'csid'}}->{'ORDER'};

	my @pllist;

	# ダミーキャラ
	my $dummypl = SWPlayer->new($sow);
	$dummypl->createpl($sow->{'cfg'}->{'USERID_NPC'});
	$dummypl->{'pno'}       = 0;
	$dummypl->{'csid'}      = $vil->{'csid'};
	$dummypl->{'cid'}       = $order->[-1];
	$dummypl->{'selrole'}   = -1;
	$dummypl->{'gift'}      = 1;
	$dummypl->{'role'}      = 1;
	$dummypl->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
	$dummypl->{'live'}      = 'victim' if ($emulatedays == 1);
	$dummypl->{'deathday'}  =  1       if ($emulatedays == 1);
	$vil->addpl($dummypl);   # 村へ追加
	$dummypl->setsaycount(); # 発言数初期化
	$dummypl->{'title'}     = '犠牲者';
	push( @pllist, $dummypl );

	my $rolename = $sow->{'textrs'}->{'ROLENAME'};
	my $giftname = $sow->{'textrs'}->{'GIFTNAME'};
	my $no = 0;

	my @plstack1 = ();
	my @plstack2 = ();
	my @plstack3 = ();
	for ($i = 1; $i <= @$rolename; $i++) {
		if ( '' ne $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] ){
			my $plsingle = SWPlayer->new($sow);
			$plsingle->createpl("a$no");
			$plsingle->{'pno'}       = $no;
			$plsingle->{'csid'}      = $vil->{'csid'};
			$plsingle->{'cid'}       = $order->[$no];
			$plsingle->{'selrole'}   = $i;
			$plsingle->{'gift'}      = 1;
			$plsingle->{'role'}      = $i;
			$plsingle->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
			$plsingle->{'live'}      = 'live' ;
			$plsingle->{'live'}      = 'executed' if ( $i == $sow->{'ROLEID_WALPURGIS'});
			$plsingle->{'deathday'}  = -1;
			$plsingle->{'title'}     = $rolename->[$plsingle->{'role'}];
			$plsingle->{'lock'}      = $i if ((93==$i)||(94==$i));
			$plsingle->{'actaddpt'}  = 0;

			$no++;
			push( @plstack1, $plsingle ) if ( 1 == $self->getTurn($plsingle) );
			push( @plstack2, $plsingle ) if ( 1 <  $self->getTurn($plsingle) );
			push( @pllist, $plsingle );

			# 弟子、盗賊、宿借をもうひとり
			my $istwice = 0;
			$istwice = 1 if ( $i == $sow->{'ROLEID_LOVER'}  );
			$istwice = 1 if ( $i == $sow->{'ROLEID_ROBBER'} );
#			$istwice = 1 if ( $i == $sow->{'ROLEID_SNATCH'} );
			if ( $istwice ){
				my $mobpl = SWPlayer->new($sow);
				$mobpl->createpl("a$no");
				$mobpl->{'pno'}       = $no;
				$mobpl->{'csid'}      = $vil->{'csid'};
				$mobpl->{'cid'}       = $order->[$no];
				$mobpl->{'selrole'}   = $i;
				$mobpl->{'gift'}      = 1;
				$mobpl->{'role'}      = $i;
				$mobpl->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
				$mobpl->{'live'}      = 'live' ;
				$mobpl->{'deathday'}  =  -1;
				$mobpl->{'actaddpt'}  = 0;
				$mobpl->{'title'}     = $rolename->[$plsingle->{'role'}]."（能\力使用後）";

				$no++;
				push( @plstack2, $mobpl );
				push( @pllist, $mobpl );
			}

		}
	}
	for ($i = 1; $i <= @$giftname; $i+= 1 ) {
		if ( '' ne $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$i] ){
			my $plsingle = SWPlayer->new($sow);
			$plsingle->createpl("a$no");
			$plsingle->{'pno'}       = $no;
			$plsingle->{'csid'}      = $vil->{'csid'};
			$plsingle->{'cid'}       = $order->[$no];
			$plsingle->{'selrole'}   = -1;
			$plsingle->{'gift'}      = int($i);
			$plsingle->{'role'}      = 41;
			$plsingle->{'role'}      = 63 if ($vil->{'trsid'} eq 'millerhollow');
			$plsingle->{'role'}      =  1 if ( int($i) == $sow->{'GIFTID_FINK'} );
			$plsingle->{'role'}      =  9 if ( int($i) == $sow->{'GIFTID_SEERONCE'} );
			$plsingle->{'role'}      =  1 if ( int($i) == $sow->{'GIFTID_SHIELD'} );
			$plsingle->{'role'}      =  1 if ( int($i) == $sow->{'GIFTID_DIPSY'} );
			$plsingle->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
			$plsingle->{'live'}      = 'live' ;
			$plsingle->{'deathday'}  = -1;
			$plsingle->{'actaddpt'}  = 0;
			$plsingle->{'title'}     = $giftname->[$plsingle->{'gift'}];

			$no++;
			push( @plstack1, $plsingle ) if ( 1 == $self->getTurn($plsingle) );
			push( @plstack2, $plsingle ) if ( 1 <  $self->getTurn($plsingle) );
			push( @pllist, $plsingle );

			# 魔鏡をもうひとり
			my $istwice = 0;
			$istwice = 1 if ( $i == $sow->{'GIFTID_GLASS'} );
			if ( $istwice ){
				my $mobpl = SWPlayer->new($sow);
				$mobpl->createpl("a$no");
				$mobpl->{'pno'}       = $no;
				$mobpl->{'csid'}      = $vil->{'csid'};
				$mobpl->{'cid'}       = $order->[$no];
				$mobpl->{'selrole'}   = -1;
				$mobpl->{'gift'}      = int($i);
				$mobpl->{'role'}      = 41;
				$mobpl->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
				$mobpl->{'live'}      = 'live' ;
				$mobpl->{'deathday'}  =  -1;
				$mobpl->{'actaddpt'}  = 0;
				$mobpl->{'title'}     = $giftname->[$plsingle->{'gift'}]."（能\力使用後）";

				$no++;
				push( @plstack2, $mobpl );
				push( @pllist, $mobpl );
			}

		}
	}


	# 能力を失う
	if (defined($sow->{'textrs'}->{'STATE_BIND'})) {
		my $mobpl = SWPlayer->new($sow);
		$mobpl->createpl('a98');
		$mobpl->{'pno'}       = 98;
		$mobpl->{'csid'}      = $vil->{'csid'};
		$mobpl->{'cid'}       = $order->[-3];
		$mobpl->{'selrole'}   = $sow->{'ROLEID_WOLF'};
		$mobpl->{'gift'}      = $sow->{'GIFTID_OGRE'};
		$mobpl->{'role'}      = $sow->{'ROLEID_WOLF'};
		$mobpl->{'rolestate'} = $sow->{'ROLESTATE_CURSED'};
		$mobpl->{'live'}      = 'live' ;
		$mobpl->{'deathday'}  =  -1;
		$mobpl->{'actaddpt'}  = 0;
		$mobpl->{'title'}     = '能力を失った状態';

		$no++;
		push( @plstack1, $mobpl );
		push( @pllist, $mobpl );
	}

	# 見物人
	my $mobpl = SWPlayer->new($sow);
	$mobpl->createpl('a99');
	$mobpl->{'pno'}       = 99;
	$mobpl->{'csid'}      = $vil->{'csid'};
	$mobpl->{'cid'}       = $order->[-2];
	$mobpl->{'selrole'}   = $sow->{'ROLEID_MOB'};
	$mobpl->{'role'}      = $sow->{'ROLEID_MOB'};
	$mobpl->{'gift'}      = $sow->{'GIFTID_NOT_HAVE'} ;
	$mobpl->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
	$mobpl->{'live'}      = 'mob' ;
	$mobpl->{'deathday'}  =  -1;
	$vil->addpl($mobpl);   # 村へ追加
	$mobpl->setsaycount(); # 発言数初期化
	$mobpl->{'title'}     = '見物人';
	$mobpl->{'role'} = $sow->{'ROLEID_MOB'} ;
	$mobpl->{'gift'} = $sow->{'GIFTID_NOT_HAVE'} ;
	$mobpl->{'live'} = 'mob' ;

	push( @pllist, $mobpl );

	print <<"_HTML_";
<div class="paragraph">
<p>能\力の行使結果はランダムで生成しています。変だなと思ったら、リロードしてみましょう。</p>
<p><a href="sow.cgi?cmd=roleaspect&$docid#rolerule">役職とルールの細かい点はこちら。</a></p>
<p>見たい役職は：<select ng-model="search.title" ng-options="f.title as f.title group by f.win for f in forms"></select></p>
</div>
<hr class="invisible_hr"$net>
<h2>インターフェイス</h2>
<div ng-repeat="form in forms | filter:search | limitTo: 1">
<h3>{{form.title}}</h3>
<div template="navi/forms"></div>
</div>
<script>
window.gon = {};
gon.form_show = {
	find: function(o){return true;}
};
gon.forms = [];
_HTML_
	$vil->gon_potofs();

	require "$cfg->{'DIR_LIB'}/commit.pl";
	# ログ・メモデータファイルの作成
	require "$cfg->{'DIR_LIB'}/log.pl";
	require "$cfg->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, -1, 1);
	$vil->{'debug'} = 1;
	my $result  = 0;

	foreach $plsingle ( @plstack2 ){
		next unless defined( $plsingle );
		$vil->addpl($plsingle);   # 村へ追加
		$plsingle->setsaycount(); # 発言数初期化
	}

	for ($i = 1; $i <= $emulatedays; $i++) {
		$vil->{'turn'} = $i;
		my $limit = $emulatedays - $i;
		if( $i == 1 ){
			&SWCommit::StartGM($sow,$vil);
		} else {
			&SWCommit::UpdateGM($sow,$vil,$logfile);
			$result = &SWCommit::WinnerCheckGM($sow,$vil);
			last if ( $result > 0 );
			&SWCommit::EventGM ($sow,$vil,$logfile);
		}
		my @plstacknow;
		@plstacknow = @plstack1 if ( 0 == $limit );
		if( @plstacknow ){
			foreach $plsingle ( @plstacknow ){
				next unless defined( $plsingle );
				$vil->addpl($plsingle);   # 村へ追加
				$plsingle->setsaycount(); # 発言数初期化
			}
		}
		&SWCommit::SetInitVoteTarget($sow, $vil, $logfile);
	}
	require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
	foreach $pl (@pllist){
		print <<"_HTML_";

gon.form = OPTION.gon.form.clone(true).merge({
		title: "$pl->{'title'}",
		uri: "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}",
});
_HTML_

		$pl->{'role'} = $pl->{'lock'} if( 0 < $pl->{'lock'}  );
		next if (($query->{'roleid'} ne '')&&($sow->{$query->{'roleid'}} ne $pl->{'selrole'}));
		next if (($query->{'giftid'} ne '')&&($sow->{$query->{'giftid'}} ne $pl->{'gift'}));
		$vil->{'turn'} = $self->getTurn( $pl );
		if( $sow->{'ROLEID_ROBBER'} == $pl->{'pno'} ){
			$pl->{'role'} = $pl->{'pno'};
		}
		$sow->{'curpl'} = $pl;
		$sow->{'uid'}   = $sow->{'curpl'}->{'uid'};

		&SWHtmlPlayerFormPC::OutHTMLPlayerFormPC($sow, $vil);
		print <<"_HTML_";
gon.forms.push(gon.form);
_HTML_
	}
	print <<"_HTML_";
</script>
_HTML_

	my $win_message = $sow->{'textrs'}->{'ANNOUNCE_WINNER'}->[$result];

	if (defined($sow->{'query'}->{'emulatedays'})){
		print <<"_HTML_";
<p class="info">

 $win_message<br>
 $vil->{'wincnt_human'}名の人間がまだ生存<br>
 $vil->{'wincnt_wolf' }名の人狼がまだ生存、 $vil->{'wincnt_lonewolf'}名がそのうちの「一匹狼」<br>
 $vil->{'wincnt_pixi' }名の妖精がまだ生存<br>
 $vil->{'wincnt_dish' }名の据え膳が襲撃された<br>
 $vil->{'wincnt_bond' }名が絆をかかえ、まだ生存<br>
 $vil->{'wincnt_love' }名が恋をし、まだ生存<br>
 $vil->{'wincnt_hate' }名が邪気に惑い、まだ生存<br>
 $vil->{'wincnt_sheep'}名が踊り明かし、まだ生存<br>
 $vil->{'wincnt_villager'  }名の村人がまだ生存<br>
 $vil->{'wincnt_live'      }名が生存した<br>
 $vil->{'wincnt_zombie'    }名が感染した<br>
 $vil->{'wincnt_suddendead'}名が突然に死んだ<br>
 $vil->{'wincnt_executed'  }名が処刑された<br>
 $vil->{'wincnt_victim'    }名が襲撃された<br>
 $vil->{'wincnt_feared'    }名が恐怖のあまり息絶えた<br>
 $vil->{'wincnt_suicide'   }名が絆を失い、命を手放した<br>
 $vil->{'wincnt_cursed'    }名が呪われて死んだ<br>
 $vil->{'wincnt_droop'     }名は人狼の人数を悟り、静かに息を引き取った。<br>
 $vil->{'score'}
</p>
_HTML_
	}

}


1;
