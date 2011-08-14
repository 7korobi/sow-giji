package SWDocRoleMatrix;

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => "��E�z���ꗗ�\\ ", # �^�C�g��
	};

	return bless($self, $class);
}

#----------------------------------------
# ��E�z���\��HTML�o��
#----------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};

	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	require "$cfg->{'DIR_LIB'}/setrole.pl";

	print <<"_HTML_";
<hr class="invisible_hr"$net>
<h2>��E�z���ꗗ�\\</h2>

_HTML_

	my %vil = (
		trsid => $query->{'trsid'},
	);
	&SWBase::LoadTextRS($sow, \%vil);

	my $i;
	my $minpno = $cfg->{'MINSIZE_VPLCNT'};
	my $maxpno = 20;
	my $order_roletable = $sow->{'ORDER_ROLETABLE'};
	foreach (@$order_roletable) {
		my $caption = $sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_};
		next if ($_ eq 'custom');
		next if ($caption eq '');
		my ( $maxroles, $maxgifts ) = &SWSetRole::GetSetRoleTable($sow, $vil, $_, $minpno);
		my @roles;
		my @gifts;
		for ($i = $minpno; $i <= $maxpno; $i++) {
			( $roles->[$i], $gifts->[$i] ) = &SWSetRole::GetSetRoleTable($sow, $vil, $_, $i);
			for ($j = 1; $j < $sow->{'COUNT_ROLE'}; $j++) {
				$maxroles->[$j] = $roles->[$i]->[$j] if ($roles->[$i]->[$j] > $maxroles->[$j]);
			}
			for ($j = 1; $j < $sow->{'COUNT_GIFT'}; $j++) {
				$maxgifts->[$j] = $gifts->[$i]->[$j] if ($gifts->[$i]->[$j] > $maxgifts->[$j]);
			}
		}
		print <<"_HTML_";
<h3>$caption</h3>

<div class="paragraph">
<table class="vindex" summary="$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_}�z���\\">
<thead>
<tr>
<th scope="col">�l��
<th scope="col">�@
<th scope="col" colspan=2>�l�ԁi�����A���؂�ҁj
<th scope="col">�l�T
<th scope="col">�d��
<th scope="col">���̑�
<th scope="col">���b
</thead>

<tbody>
_HTML_

		my $roleshortname = $sow->{'textrs'}->{ 'ROLESHORTNAME'};
		my $giftshortname = $sow->{'textrs'}->{ 'GIFTSHORTNAME'};

		for ($i = $minpno; $i <= $maxpno; $i++) {
			my $rolestrhuman = "";
			my $rolestrseer  = "";
			my $rolestrenemy = "";
			my $rolestrwolf  = "";
			my $rolestrpixi  = "";
			my $rolestrother = "";
			my $giftstr      = "";
			for ($j = 1; $j < $sow->{'COUNT_ROLE'}; $j++) {
				if ( $roles->[$i]->[$j] == 0 ) {
				} else {
					my $count = " ";
					$count = sprintf("x%d  ",$roles->[$i]->[$j]) if (1 < $roles->[$i]->[$j]);
					if (0 < $maxroles->[$j]){
						my $rolestr = $roleshortname->[$j] . $count;
						if (($j == $sow->{'ROLEID_SEER'})
						  ||($j == $sow->{'ROLEID_SEERWIN'})
						  ||($j == $sow->{'ROLEID_SEERROLE'})
						  ||($j == $sow->{'ROLEID_AURA'})
						  ||($j == $sow->{'ROLEID_GIRL'})
						  ||($j == $sow->{'ROLEID_DOCTOR'})
						  ||($j == $sow->{'ROLEID_MEDIUM'})
						  ||($j == $sow->{'ROLEID_MEDIUMWIN'})
						  ||($j == $sow->{'ROLEID_MEDIUMROLE'})
						  ||($j == $sow->{'ROLEID_NECROMANCER'})){
							$rolestrseer .= $rolestr;
						} elsif ( $j < $sow->{'SIDEED_HUMANSIDE'}){
							$rolestrhuman .= $rolestr;
						} elsif ( $j < $sow->{'SIDEED_ENEMY'    }){
							$rolestrenemy .= $rolestr;
						} elsif ( $j < $sow->{'SIDEED_WOLFSIDE' }){
							$rolestrwolf  .= $rolestr;
						} elsif ( $j < $sow->{'SIDEED_PIXISIDE' }){
							$rolestrpixi  .= $rolestr;
						} else  {
							$rolestrother .= $rolestr;
						}
					}
				}
			}
			for ($j = 1; $j < $sow->{'COUNT_GIFT'}; $j++) {
				if ( $gifts->[$i]->[$j] == 0 ) {
				} else {
					my $count = " ";
					$count = sprintf("x%d  ",$gifts->[$i]->[$j]) if (1 < $gifts->[$i]->[$j]);
					$giftstr .= $giftshortname->[$j] . $count    if (0 < $maxgifts->[$j]);
				}
			}
			print <<"_HTML_"
<tr>
<td class=calc>$i �l
<td>
<td>$rolestrhuman �@ $rolestrseer
<td>$rolestrenemy
<td>$rolestrwolf
<td>$rolestrpixi
<td>$rolestrother
<td>$giftstr
_HTML_
		}

		print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

_HTML_
	}
}

1;
