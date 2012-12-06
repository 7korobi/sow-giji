package SWDocRoleList;

#----------------------------------------
# ��E�ꗗ��ʂ̃^�C�g��
#----------------------------------------
#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => '��E�ƃC���^�[�t�F�C�X', # �^�C�g��
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
# ��E�ꗗHTML�o��
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
<h2>��E�\\�͑����\\</h2>
_HTML_

	# �_�~�[�f�[�^�̐���
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
#	$vil->{'grudge'}    = 2;  # �l�T�̕��Q
#	$vil->{'riot'}      = 2;  # ���l�̖\��
#	$vil->{'riot'}      = 3;  # ���l�̖\��
#	$vil->{'scapegoat'} = 4;  # �X�P�[�v�S�[�g�̎w��
	$sow->{'turn'} = $vil->{'turn'};

	$sow->{'savedraft'} = '';

	# ���\�[�X�̓ǂݍ���
	my %csidlist = ();
	$csidlist{$vil->{'csid'}} = 1;
	$sow->{'csidlist'} = \%csidlist;
	&SWBase::LoadVilRS($sow, $vil);
	my $order = $sow->{'charsets'}->{'csid'}->{$vil->{'csid'}}->{'ORDER'};

	my @pllist;

	# �_�~�[�L����
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
	$vil->addpl($dummypl);   # ���֒ǉ�
	$dummypl->setsaycount(); # ������������
	$dummypl->{'title'}     = '�]����';
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

			# ��q�A�����A�h�؂������ЂƂ�
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
				$mobpl->{'title'}     = $rolename->[$plsingle->{'role'}]."�i�\\�͎g�p��j";

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

			# �����������ЂƂ�
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
				$mobpl->{'title'}     = $giftname->[$plsingle->{'gift'}]."�i�\\�͎g�p��j";

				$no++;
				push( @plstack2, $mobpl );
				push( @pllist, $mobpl );
			}

		}
	}


	# �\�͂�����
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
		$mobpl->{'title'}     = '�\�͂����������';

		$no++;
		push( @plstack1, $mobpl );
		push( @pllist, $mobpl );
	}

	# �����l
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
	$vil->addpl($mobpl);   # ���֒ǉ�
	$mobpl->setsaycount(); # ������������
	$mobpl->{'title'}     = '�����l';
	$mobpl->{'role'} = $sow->{'ROLEID_MOB'} ;
	$mobpl->{'gift'} = $sow->{'GIFTID_NOT_HAVE'} ;
	$mobpl->{'live'} = 'mob' ;

	push( @pllist, $mobpl );

	print <<"_HTML_";
<div class="paragraph">
<p>�\\�͂̍s�g���ʂ̓����_���Ő������Ă��܂��B�ς��ȂƎv������A�����[�h���Ă݂܂��傤�B</p>
<p><a href="sow.cgi?cmd=roleaspect&$docid#rolerule">��E�ƃ��[���ׂ̍����_�͂�����B</a></p>
<p>��������E�́F<select ng-model="search.title" ng-options="f.title as f.title group by f.win for f in forms"></select></p>
</div>
<hr class="invisible_hr"$net>
<h2>�C���^�[�t�F�C�X</h2>
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
	# ���O�E�����f�[�^�t�@�C���̍쐬
	require "$cfg->{'DIR_LIB'}/log.pl";
	require "$cfg->{'DIR_LIB'}/file_log.pl";
	my $logfile = SWBoa->new($sow, $vil, -1, 1);
	$vil->{'debug'} = 1;
	my $result  = 0;

	foreach $plsingle ( @plstack2 ){
		next unless defined( $plsingle );
		$vil->addpl($plsingle);   # ���֒ǉ�
		$plsingle->setsaycount(); # ������������
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
				$vil->addpl($plsingle);   # ���֒ǉ�
				$plsingle->setsaycount(); # ������������
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
 $vil->{'wincnt_human'}���̐l�Ԃ��܂�����<br>
 $vil->{'wincnt_wolf' }���̐l�T���܂������A $vil->{'wincnt_lonewolf'}�������̂����́u��C�T�v<br>
 $vil->{'wincnt_pixi' }���̗d�����܂�����<br>
 $vil->{'wincnt_dish' }���̐����V���P�����ꂽ<br>
 $vil->{'wincnt_bond' }�����J���������A�܂�����<br>
 $vil->{'wincnt_love' }�����������A�܂�����<br>
 $vil->{'wincnt_hate' }�����׋C�ɘf���A�܂�����<br>
 $vil->{'wincnt_sheep'}�����x�薾�����A�܂�����<br>
 $vil->{'wincnt_villager'  }���̑��l���܂�����<br>
 $vil->{'wincnt_live'      }������������<br>
 $vil->{'wincnt_zombie'    }������������<br>
 $vil->{'wincnt_suddendead'}�����ˑR�Ɏ���<br>
 $vil->{'wincnt_executed'  }�������Y���ꂽ<br>
 $vil->{'wincnt_victim'    }�����P�����ꂽ<br>
 $vil->{'wincnt_feared'    }�������|�̂��܂葧�₦��<br>
 $vil->{'wincnt_suicide'   }�����J�������A�����������<br>
 $vil->{'wincnt_cursed'    }��������Ď���<br>
 $vil->{'wincnt_droop'     }���͐l�T�̐l�������A�Â��ɑ�������������B<br>
 $vil->{'score'}
</p>
_HTML_
	}

}


1;
