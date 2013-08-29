package SWDocRoleAspect;

#----------------------------------------
# �V�ѕ�
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => '�\�͂ƃ��[���ׂ̍�������', # �^�C�g��
	};

	return bless($self, $class);
}

sub outhtml {
	my $self   = shift;
	my $sow    = $self->{'sow'};
	my $cfg    = $sow->{'cfg'};
	my $net    = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $mob    = $sow->{'basictrs'}->{'MOB'};
	my $mobodr = $mob->{'ORDER'};
	my $query  = $sow->{'query'};
	my $docid = "css=$query->{'css'}&trsid=$query->{'trsid'}";

	print <<"_HTML_";
<DIV class=toppage>
_HTML_
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, 0);
	$vil->createdummyvil();
	$vil->{'csid'}  = $sow->{'cfg'}->{'DEFAULT_CSID'};
	$vil->{'trsid'} = $sow->{'query'}->{'trsid'};
	$vil->{'game'}  = $sow->{'query'}->{'game'};
	$vil->{'saycnttype'} = 'juna';
	$vil->{'turn'} = 1;
	$vil->{'winner'} = 0;
	$vil->{'randomtarget'} = 1;
	$vil->{'makeruid'} = $sow->{'cfg'}->{'USERID_ADMIN'};

	&SWBase::LoadTextRS($sow, $vil);
	print <<"_HTML_";
<h2><a $atr_id="rolerule">�\\�͂ƃ��[���ׂ̍�������</a></h2>
<p class="paragraph">
�\\�́A���b���Ƃ́A�ׂ������[���͉��̕\\�̂悤�ɂȂ�܂��B�Q�l�ɂ��܂��傤�B
</p>
<ul>
  <li>�P���ˑI���H�@�@�u�I�v�̐U��ꂽ��E�́A�P���̑ΏۂɑI�΂�܂��B</li>
  <li>�P���ˌ��ʁ@�@�������̖�E�ŏP�������Ƃǂ��Ȃ邩�B</li>
  <li>��E��\�\\�́ˍ�p�@�@���ꂽ�Ƃ��ɓ��ʂȂ��Ƃ������邩�A�Ȃɂ������邩�B</li>
  <li>��E��\�\\�́ː�/�I�[��/��E�@�@�肢����/�I�[���肢����/��E�肢���ʂ��ǂ��Ȃ邩�B</li>
  <li>�C�z�@�@���̖�E�ɂȂ����Ƃ��A���͂ɔ�����C�z�B</li>
  <li>�����Ɋւ��T�l���@�@�����҂��������ɂ��Ă͂܂邩���A�\\��\�҂╗���d���̎��������߂�B</li>
  <li>�����l���J�E���g�@�@�l�Ԉ�l�A�Ɛ�����̂��A�l�T�ЂƂ�A�Ɛ�����̂��A�ǂ���ɂ������Ȃ��̂��B</li>
  <li>���������@�@�ǂ̏����ŏI�������Ƃ��A��������̂�</li>
</ul>
<table class=vindex>
<thead>
<tr><td rowspan=3><td rowspan=3>���O<td colspan=2>�P��<td rowspan=2 colspan=4>��E��\\�͔��茋��<td rowspan=3>�C�z<td colspan=3 class=sayfilter_incontent>�����Ɋւ��T�l��
<tr class=small><td colspan=2>�I���H<td><td colspan=2>�����l���J�E���g
<tr class=small><td><td>����<td>��p<td>��<td>�I�[��<td>��E<td><td><td>��������
</thead>
<tbody class=small>
_HTML_

	my $rolename = $sow->{'textrs'}->{'ROLENAME'};
	my $giftname = $sow->{'textrs'}->{'GIFTNAME'};

	# �����l
	my $mobpl = SWPlayer->new($sow);
	$mobpl->createpl('a98');
	$mobpl->{'pno'}       = 98;
	$mobpl->{'csid'}      = $vil->{'csid'};
	$mobpl->{'cid'}       = $order->[-2];
	$mobpl->{'selrole'}   = $sow->{'ROLEID_MOB'};
	$mobpl->{'gift'}      = 1;
	$mobpl->{'role'}      = $sow->{'ROLEID_MOB'};
	$mobpl->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};
	$mobpl->{'live'}      = 'live' ;
	$mobpl->{'deathday'}  =  -1;
	$vil->addpl($mobpl);   # ���֒ǉ�
	$mobpl->setsaycount(); # ������������
	$mobpl->{'title'}     = '�����l';

	my %sayswitch = (
		sympathy => '����',
		wolf     => '�l�T',
		pixi     => '�O�b',
		muppet   => '�߈�',
	);

	for ($j = 1; $j <= @$giftname; $j++) {
		for ($i = 1; $i <= @$rolename; $i++) {

			$mobpl->{'role'}      = $i;
			$mobpl->{'gift'}      = $j;
			$mobpl->{'rolestate'} = $sow->{'ROLESTATE_DEFAULT'};

			next if  ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
			next if (( '' eq $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$j] )&&($j != $sow->{'GIFTID_NOT_HAVE'}));
			next if ($j == $sow->{'GIFTID_DECIDE'});
			next if (($j < $sow->{'SIDEST_DEAL'})&&($j != $sow->{'GIFTID_NOT_HAVE'}));
			next if (($l==1)&&( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$sow->{'ROLEID_LOVEANGEL'}] ));
#			next if (($j == $sow->{'GIFTID_SHIELD'})&&( $mobpl->ispixi()));
#			next if (($j == $sow->{'GIFTID_SHIELD'})&&( $mobpl->isenemy()));
#			next if (($j == $sow->{'GIFTID_SHIELD'})&&( $mobpl->iswolf()));

			my $saylogrole = $sayswitch{$sow->{'ROLESAYSWITCH'}->[$i]};
			my $sayloggift = $sayswitch{$sow->{'GIFTSAYSWITCH'}->[$j]};
			my $saylog     = join(" ",($saylogrole,$sayloggift));
			my $winlnk = $cfg->{'URL_WIN'}.uc($mobpl->win_if());
			my $win    = '<a href="'.$winlnk.'">'.$sow->{'textrs'}->{'ROLEWIN'}->{$mobpl->win_if()}.'</a>';

			my $count='';
			if      ($mobpl->ishuman() > 0) {
				$count = '�l';
			} elsif ($mobpl->ispixi()  > 0) {
				$count = '';
			} elsif ($mobpl->iswolf()  > 0) {
				$count = '�T';
			} else {
				$count = '�l';
			}

			my $droop='';
			$droop   = '��'   if ( $mobpl->iswolf());

			my $kill='���S';
			$kill = '����'   if ($mobpl->{'role'} == $sow->{'ROLEID_ELDER'});
			$kill = '����'   if ($mobpl->{'role'} == $sow->{'ROLEID_WEREDOG'});
			$kill = '�l�T��' if ($mobpl->{'role'} == $sow->{'ROLEID_SEMIWOLF'});
			$kill = '����'   if ($mobpl->{'role'} == $sow->{'ROLEID_LONEWOLF'});
			$kill = '����'   if ($mobpl->iscursed('role')+$mobpl->iscursed('gift') );
			$kill = '����'   if ($mobpl->{'gift'} == $sow->{'GIFTID_SHIELD'});

			my $killtarget = '�I';
			$killtarget = '' if ($mobpl->iskiller('role')+$mobpl->iskiller('gift') );
			$killtarget = '' if ( $mobpl->{'role'} == $sow->{'ROLEID_MIMICRY'}     );

			my $sense='';
			$sense = $rolename->[$i] if( $mobpl->{'role'} == $sow->{'ROLEID_FM'} );
			$sense = $rolename->[$i] if( $mobpl->{'role'} == $sow->{'ROLEID_SYMPATHY'} );
			$sense .= ' �d��'      if(   $mobpl->iscursed('role')+$mobpl->iscursed('gift') );
			$sense .= ' �l�T'      if( ( $mobpl->iskiller('role')+$mobpl->iskiller('gift') )
			                         ||( $mobpl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'}    )
			                         ||( $mobpl->{'role'} == $sow->{'ROLEID_MIMICRY'}      ) );

			my $result = '';
			$result .= '���S' if( $mobpl->iscursed('role')+$mobpl->iscursed('gift') );
			$result .= ' ����' if ($mobpl->{'role'} == $sow->{'ROLEID_CURSE'});
			$result .= ' ����' if ($mobpl->{'role'} == $sow->{'ROLEID_CURSEWOLF'});

			my $role = $rolename->[$i];

			my $aura='�\�͎�';
			$aura = '�Ȃ�'  if ($mobpl->{'role'} == $sow->{'ROLEID_VILLAGER'});
			$aura = '�Ȃ�'  if ($mobpl->{'role'} == $sow->{'ROLEID_WOLF'});
			$aura = '�Ȃ�' if  ($mobpl->iscanrole(  $sow->{'ROLEID_WHITEWOLF'}));

			my $seer_result = 1;
			# �l�T����B��E���l�T�A���b���l�T�A��C�T�A�T�����B�]���r�B�܂��A���T�͐l�Ԕ���B
			$seer_result = 2 if  ($targetpl->iskiller('role')); # �l�T����
			$seer_result = 2 if  ($targetpl->iskiller('gift')); # �l�T����
			$seer_result = 2 if  ($targetpl->isDisableState('MASKSTATE_ZOMBIE')); # �]���r�ɂ���܂����B
			$seer_result = 2 if  ($targetpl->{'role'} == $sow->{'ROLEID_LONEWOLF'}  );
			$seer_result = 2 if  ($targetpl->{'role'} == $sow->{'ROLEID_RIGHTWOLF'} );
			$seer_result = 1 if  ($targetpl->iscanrole(  $sow->{'ROLEID_WHITEWOLF'}));
			my $seer=('','�l','�T')[$seer_result];

			my $rolelnk  =  $cfg->{'URL_ROLE'}.uc($sow->{'ROLEID'}->[$i]);
			my $giftlnk  =  $cfg->{'URL_GIFT'}.uc($sow->{'GIFTID'}->[$j]);

			my $head = '<a href="'.$rolelnk.'">'.$rolename->[$i].'</a>';
			$head .= "�A".'<a href="'.$giftlnk.'">'.$giftname->[$j].'</a>' if ( '' ne $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$j] );

			print "<tr><td>$head<td>$saylog<td>$killtarget<td>$kill<td>$result<td>$seer<td>$aura<td>$role<td>$sense<td>$droop<td>$count<td>$win\n";
			if ( $mobpl->{'role'} == $sow->{'ROLEID_WHITEWOLF'} ){
				$head = '�@���\�͂Ȃ�';
				$seer = '�T';
				print "<tr><td>$head<td>$saylog<td>$killtarget<td>$kill<td>$result<td>$seer<td>$aura<td>$role<td>$sense<td>$droop<td>$count<td>$win\n";
			}
			if ( $mobpl->{'role'} == $sow->{'ROLEID_GIRL'} ){
				$head = '�@����V�ђ�';
				$kill = '���|��';
				print "<tr><td>$head<td>$saylog<td>$killtarget<td>$kill<td>$result<td>$seer<td>$aura<td>$role<td>$sense<td>$droop<td>$count<td>$win\n";
			}
		}
	}

	print '<tr><td>�׋C�ɂȂ���<td colspan=10>�׋C�ɂȂ�ȑO�Ɠ���<td><a href="'.$cfg->{'URL_WIN'}.'WIN_HATER">'.$sow->{'textrs'}->{'ROLEWIN'}->{'WIN_HATER'}.'</a>' if ( '' ne $sow->{'textrs'}->{'ROLESHORTNAME'}->[$sow->{'ROLEID_HATEDEVIL'}] );
	print '<tr><td>���l�ɂȂ���<td colspan=10>���l�ɂȂ�ȑO�Ɠ���<td><a href="'.$cfg->{'URL_WIN'}.'WIN_LOVER">'.$sow->{'textrs'}->{'ROLEWIN'}->{'WIN_LOVER'}.'</a>' if ( '' ne $sow->{'textrs'}->{'ROLESHORTNAME'}->[$sow->{'ROLEID_LOVEANGEL'}] );
	print <<"_HTML_";
</tbody>
</table>

<h3><a $atr_id="ending">���s�̌���</a></h3>
<p class="paragraph">
���l�����l�T��S�ł����邩�A�l�Ԃ̐l�����l�T�̐l���Ɠ����܂��͂���ȉ��ɂ܂Ō��邩�A���̂ǂ��炩�̏����𖞂����Ə������I���܂��B�l�Ԃɐ������E�A�l�T�ɐ������E�ɂ��Ă�<a href="#rolerule">����������܂��傤</a>�B<br$net>
</p>

<p class="paragraph">
�������I���ƁA�����c��̐l����A����̖��������Ă��邩�A�ǂ̂悤�Ɏ��񂾂̂��ɂ���āA���s�����肵�܂��B���ʂɂ���ď����錾���Ȃ���A�S����ID�Ɗ��蓖�Ă�ꂽ�\\�͂����J����܂��B�܂��A�Ƃ茾�⚑���ȂǁA�����̍Œ��ɂ͑��l�Ɍ����Ȃ��悤�ɂȂ��Ă������������J����܂��B
</p>

<table class=vindex>
<thead>
<tr>
<th scope="col">���s</th>
<th scope="col">�����錾</th>
</tr>
</thead>
<tbody class=sayfilter_incontent>
_HTML_
	
	my $announce_winner = $sow->{'textrs'}->{'ANNOUNCE_WINNER'};
	for( $i=1; $i< @$announce_winner; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'CAPTION_WINNER'}->[$i] );
		my $name    = $sow->{'textrs'}->{'CAPTION_WINNER'}->[$i];
		my $explain = $sow->{'textrs'}->{'ANNOUNCE_WINNER'}->[$i];
		$name = "�݂�ȗx����<br>�@".$name if ( $i == $sow->{'WINNER_PIXI'}   );
		$name = "���l�̉A��<br>�@".$name  if ( $i == $sow->{'WINNER_PIXI_H'} );
		$name = "�l�T�̉A��<br>�@".$name if ( $i == $sow->{'WINNER_PIXI_W'} );
		$name = "�����҂Ȃ�" if ( $i == $sow->{'WINNER_NONE'} );
	print <<"_HTML_";
<tr>
<td nowrap>$name</td>
<td>$explain</td>
</tr>
_HTML_
	}
	
	print <<"_HTML_";
<tr>
<td><td>
</tr>
<tr>
<td nowrap>+�����V������</td>
<td>$sow->{'textrs'}->{'ANNOUNCE_WINNER_DISH'}</td>
</tr>
</tbody>
</table>

<p class="paragraph">
��������̓G�s���[�O�̎��Ԃł��B�������ꂽ�S�Ă̔����Ȃǂ�b�̎�ɂ��āA�݂�ȂŐF�X�΂�����Q�����肵�܂��傤�B�y�����ĕʂ��Ȃ�A�����Đl����͍X�V���������Ă������ł��傤�B�����l�ł����B
</p>
<hr class="invisible_hr"$net>
</DIV>
_HTML_

}

1;
