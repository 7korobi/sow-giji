package SWDocHowTo;

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
		title => '�V�ѕ�', # �^�C�g��
	};

	return bless($self, $class);
}

#---------------------------------------------
# �V�ѕ��̕\��
#---------------------------------------------
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

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, 0);
	$vil->createdummyvil();
	$vil->{'csid'}  = $sow->{'cfg'}->{'DEFAULT_CSID'};
	$vil->{'trsid'} = $sow->{'query'}->{'trsid'};
	$vil->{'saycnttype'} = 'juna';
	$vil->{'turn'} = 1;
	$vil->{'winner'} = 0;
	$vil->{'randomtarget'} = 1;
	$vil->{'makeruid'} = $sow->{'cfg'}->{'USERID_ADMIN'};

	&SWBase::LoadTextRS($sow, $vil);

	print <<"_HTML_";
<DIV class=toppage>
<p class="paragraph">
��{�ݒ�ŁA�Q�[���̏ڍׂȃ��[�������߂Ă��܂��B���[�����m�F��������{�ݒ��I��ł���A���̉���ǂ݂܂��傤�B
</p>
<h2>�V�ѕ�</h2>
<p class="paragraph">
$cfg->{'NAME_SW'}�́A���~���̍����Q�[���ł��B�V�ѕ����悭�ǂ݁A�X�Ɋ��ɏI���������̃��O���Q�`�R���قǓǂ�Ŋ��o��������x�͂�ł���A�Q������鎖�����E�߂��܂��B
</p>

<ul>
  <li><a href="#regist">���[�U�[�o�^�ƃ��O�C��</a></li>
  <li><a href="#entry">���ւ̎Q��</a></li>
  <li><a href="#exit">������o��</a></li>
  <li><a href="#muster">�_�Ă��Ƃ�</a></li>
  <li><a href="#rolerule">�\\�͎�</a></li>
<ul>
  <li><b><a href="sow.cgi?cmd=roleaspect&$docid">�\\�́A���b���Ƃ́A�ׂ�������</a></b></li>
  <li><b><a href="sow.cgi?cmd=rolelist&$docid">��E�ƃC���^�[�t�F�[�X</a></b></li>
</ul>
  <li><a href="#role">�����̔\\�͎ҁi��E�j</a></li>
  <li><a href="#rolewolf">�l�T���̔\\�͎ҁi��E�j</a></li>
  <li><a href="#rolepixi">�d���̔\\�͎ҁi��E�j</a></li>
  <li><a href="#roleother">���̑��̔\\�͎ҁi��E�j</a></li>
  <li><a href="#rolegift">�\\�͎҈ȊO�̗v�f�i���b�j</a></li>
  <li><a href="#rolerule">�\\�͂ƃ��[���ׂ̍����Ƃ���</a></li>
  <li><a href="#event">����|�M����^���i�����j</a></li>
  <li><a href="#start">�����n�܂�����</a></li>
  <li><a href="#die">���S</a></li>
  <li><a href="#suddendeath">�ˑR��</a></li>
  <li><a href="#ending">���s�̌���</a></li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="regist">���[�U�[�o�^�ƃ��O�C��</a></h3>
<p class="paragraph">
$cfg->{'NAME_SW'}�ŗV�Ԃ��߂ɂ́A�܂����[�U�[�o�^���K�v�ł��B���[�U�[�o�^������ɂ́A�E��ɂ���u���O�C���v�{�^���ōs���܂��i�u���O�C���v�{�^���̓��[�U�[�o�^�{�^�������˂Ă��܂��j�B
</p>

<p class="paragraph">
�D���ȃ��[�U�[ID�ƈ��p��h�����߂̃p�X���[�h�����߂���A�uuser id�v���Ƀ��[�UID�A�upassword:�v���Ƀp�X���[�h����͂��āu���O�C���v�{�^���������Ă��������B���̃��[�U�[ID��N�������Ɏg�p���Ă��Ȃ���΁Auser id:xxxxx [���O�A�E�g] �ƕ\\������܂��B���̕\\�����o��Γo�^�����ł��B
</p>

<p class="paragraph">
�Q�[��������ɂ́A���O�C�����Ȃ���΂Ȃ�܂���B���Ƀ��O�C�����Ă���Ȃ�u���O�A�E�g�v�{�^�����\\������Ă��܂����A�\\������Ă��Ȃ��Ȃ烍�O�C�����܂��傤�B<br$net>
���O�C���̂����ɂ́A���[�U�[�o�^�̂����Ɠ����ł��B�E��̓��͗��Ƀ��[�UID�ƃp�X���[�h����͂��āu���O�C���v�{�^���������Ă��������B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="entry">���ւ̎Q��</a></h3>
<p class="paragraph">
���ɁA�Q�������������g�b�v�y�[�W�́u���̈ꗗ�v����I�т܂��B���̈ꗗ�́u�i�s�v�Ƃ����������ĉ������B�������u��W���v�Ȃ�A���Ȃ��͂��̑��֎Q�����鎖���ł��܂��B<br$net>
�Q���������������߂���A���̖��O���N���b�N���Ă��������B���̑��̃v�����[�O���\\������A��ԉ��ɎQ���ғ��͗����\\������܂��B
</p>

<p class="paragraph">
�u��]����z���v�́A���Ȃ��̍D���Ȕz���i�L�����j��I�ԗ��ł��B�v���C���ɔ���������ƁA���̔����̔����Җ��������őI�񂾔z���̖��O�ƂȂ�܂��B<br$net>
$cfg->{'NAME_SW'}�͑��̏��s��������܂ł̊ԁA�N���Q�����Ă���̂��N�ɂ��킩��Ȃ��悤�ɂȂ��Ă��܂��B�u�z���v�Ƃ́A���Ȃ����N�Ȃ̂����킩��Ȃ��悤�ɂ��邽�߂̕ϖ��̂悤�Ȃ��̂ł��B���͋C�𐷂�グ�邽�߁A������x�z���ɂȂ肫���������y���߂�ł��傤�B<br$net>

</p>

<p class="paragraph">
�u��]����\\�́v�́A���Ȃ������l�ɂȂ肽�����l�T�ɂȂ肽�����̊�]���o�����ł��B��]���K���ʂ�Ƃ͌���܂���B��]�҂����������ꍇ�A���I�ŊO��Ċ�]���Ă��Ȃ��\\�͎҂ɂȂ��Ă��܂���������܂��B<br$net>
$cfg->{'NAME_SW'}�ɂ́A�u���l�v�u�l�T�v�ȊO�ɂ��l�X�ȁu�\\�͎ҁv�����܂��B�ނ�͂��ꂼ����L�̓���\\�͂������Ă��܂��B<br$net>
</p>

<p class="paragraph">
���̂Ƃ��A���ɂ���Ắu��������v�I�������܂܂�Ă��邱�Ƃ�����܂��B�����l�͏��s�ɂ�����炸�A�������̍s���������͂��闧��ł��B�����ƂɌ����l�̗��ꂪ�ݒ肵�Ă���A��b�ł���͈͂��قȂ�܂��B
</p>
<ul>
_HTML_
	foreach (@$mobodr){
		my $caption = $mob->{$_}->{'CAPTION'};
		my $help    = $mob->{$_}->{'HELP'};
		print "<li>$caption �F $help</li>";
	}
	print <<"_HTML_";
</ul>
<p class="paragraph">
�u��]����z���v�u��]����\\�́v�u�Q�����鎞�̃Z���t�v��I���E���͂��I�������A�u���̑��ɎQ���v�{�^���������Ă��������B���Ȃ�����]�����z���̖��O�Łu�Q�����鎞�̃Z���t�v�����̉�ʂɕ\\������܂��B<br$net>
����ł��Ȃ��́A���̑��̎Q���҂ƂȂ�܂����B�Q�[�����J�n����܂ŁA���̑��l�����ƎG�k�ł����܂��傤�B
</p>

<p class="paragraph">
�Q���l��������܂ŒB���Ă��܂��ƁA���Ƃ������l�̐Ȃ��󂢂Ă��Ă��J�n�҂��ƂȂ�܂��B�����l�̕�W�͒��ߐ؂��܂��񂪁A���܂��ɊJ�n���邩������܂���B
</p>

<hr class="invisible_hr"$net>

<h3><a $atr_id="exit">������o��</a></h3>
<p class="paragraph">
��U�Q�����Ă��A�v�����[�O���ł���Α�����o�邱�Ƃ��\�ł��B<br$net>
�����t�H�[���̉��ɂ���u�����o��v��I�т܂��傤�B<br$net>
���Ȃ��̑���ȊO�ɁA�v�����[�O�Œ����Ԕ������Ȃ��Ƃ��A���Ȃ������ɋ���ׂ��łȂ��Ɣ��f���ꂽ�Ƃ��A���Ȃ��͑�����o�Ă��܂��B<br$net>
�����Đl�́A���̒��ɂ��Ă͂܂����A�Ɣ��f�����l��ދ�������@�\�������Ă��܂��B�u���̏��v���̗������󂢁A�Q���p���ɕs��������Ȃǂ̔��f�����ꂽ�ꍇ�A�����ނ��ƂȂ�܂��̂ŁA��������Ƒ��̏���ǂ�ŎQ�����A�S���Ŋy���߂�v���C��S�����܂��傤�B<br$net>
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="muster">�_�Ă��Ƃ�</a></h3>
<p class="paragraph">
���낻��J�n�A�Ƃ����Ƃ��ɁA�W�܂肪�����Ƃ����n�܂����Ƃ��ɂ������悭�͉�b�ł��܂���ˁB<br$net>
����͂܂�Ȃ��A�ƍl���鑺���Đl�̂��߂ɁA�_�Ă��Ƃ�@�\������܂��B�_�Ă��J�n����ƁA�����ǑS���̔��������񐔂��[���ɂ���̂ŁA���̏u�Ԉȍ~�Ŕ����̂Ȃ��l���͂�����킩��܂��B<br$net>
���̎��̍X�V���܂őҋ@����Ύ����I�ɖ����������ő����o�܂����A�蓮�X�V�̂���ł���Ȃ�A�X�V�̂P�O���O��������߂ǂɁA�����܂Ŗ������̂܂܂̐l�͎Q���ł��Ȃ�����ł����ƌ��Ȃ��܂��B�ȂǂƃA�i�E���X���Ă����ƁA�Q���ɕs���R�������Ȑl���͂����茩�����邱�Ƃ��ł��܂��B���ꂪ���߂Ă��������j�Ȃ�A�ދ����������̂������ł��傤<br$net>
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolerule">�\\��</a></h3>
<p class="paragraph">
���ɂ́A�l�X�ȓ���\\�͂����ҁi�܂��͎����Ȃ��ҁj�����܂��B���̑����͑����̔\\�͎ҁA�����炩�͐l�T���̔\\�͎ҁA������������A����ȊO�̐w�c�̎҂����邩������܂���B<a href="sow.cgi?cmd=roleaspect&$docid">�\\�́A���b���Ƃ́A�ׂ�������</a>���Q�l�ɂ��܂��傤�B�܂��A<a href="sow.cgi?cmd=rolelist&$docid">��E�ƃC���^�[�t�F�[�X</a>�ŁA�Q�[�����̑���Ղ⌋�ʕ\\�����݂邱�Ƃ��ł��܂��B
</p>



<h3 title="�����̔\\�͎�"><a $atr_id="role">�����̔\\�͎ҁi��E�j</a></h3> 
<p class="paragraph" onclick="\$('#filter_role').slideToggle('slow');">
�͂����킹�āA���ҒB�����ނ��܂��傤�B�ނ�͓��ʂȂ��Ƃ��Ȃ�����A���l�w�c�Ƃ��Ċ��􂵂܂��B<br>
$sow->{'textrs'}->{'WIN_HUMAN'}
</p>
<div id="filter_role"> 
<table border="1" class="vindex" summary="�\\�͎҈ꗗ�i�����j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_HUMANSIDE'}; $i<$sow->{'SIDEED_HUMANSIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain .= '<br><b>�i�����ƁA���̂����o���\���������܂��j</b><br>'.$sow->{'textrs'}->{'RESULT_RIGHTWOLF'} if ($sow->{'ROLEID_RIGHTWOLF'} == $i);
		$explain =~ s/_ROLESUBID_/�F�̂���/g if ($sow->{'ROLEID_STIGMA'}    == $i);
 
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	
	my $enemy = "�T��";
	$enemy    = "�j�ő�" if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );
	my $enemy_win = $sow->{'textrs'}->{'WIN_WOLF'};
	$enemy_win    = $sow->{'textrs'}->{'WIN_EVIL'} if( 1 == $cfg->{'ENABLED_AMBIDEXTER'} );
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<h3><a $atr_id="roleenemy">$enemy�̔\\�͎ҁi��E�j</a></h3>
<p class="paragraph" onclick="\$('#filter_roleenemy').slideToggle('slow');">
���ɂ͑P�ǂȑ��l�B�̑��ɁA�l�Ԃł���Ȃ���G�ɉ�闠�؂�ҒB�����܂��B��͂��Ȃ������̎��Ԃł��B<br>
$enemy_win
</p>
<div id="filter_roleenemy"> 
<table border="1" class="vindex" summary="�\\�͎҈ꗗ�i$enemy�j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_ENEMY'}; $i<$sow->{'SIDEED_ENEMY'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain =~ s/_NPC_/��������̋]����/g if ($sow->{'ROLEID_MUPPETING'} == $i);

	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolewolf">�l�T���̔\\�͎ҁi��E�j</a></h3>
<p class="paragraph" onclick="\$('#filter_rolewolf').slideToggle('slow');">
���ɂ͑P�ǂȑ��l�B�̑��ɁA�ނ�ɂȂ肷�܂��đ��l���P���l�T��A�l�Ԃł���Ȃ���l�T�ɋ��͂��闠�؂�ҒB�����܂��B��͂��Ȃ������̎��Ԃł��B<br>
$sow->{'textrs'}->{'WIN_WOLF'}
</p>
<div id="filter_rolewolf"> 
<table border="1" class="vindex" summary="�\\�͎҈ꗗ�i�l�T���j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_WOLFSIDE'}; $i<$sow->{'SIDEED_WOLFSIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain =~ s/_NPC_/��������̋]����/g if ($sow->{'ROLEID_MUPPETING'} == $i);

	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolepixi">��O���͂̔\\�͎ҁi��E�j</a></h3>
<p class="paragraph" onclick="\$('#filter_rolepixi').slideToggle('slow');">
���ɂ͑����ɂ��l�T���ɂ������Ȃ��ҒB�����܂��B���l�����l�T����������������𖞂��������A�ނ�͉����珟���🲂��Ă����܂��B<br>
$sow->{'textrs'}->{'WIN_PIXI'}
</p>
<div id="filter_rolepixi"> 
<table border="1" class="vindex" summary="�\\�͎҈ꗗ�i��O���́j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_PIXISIDE'}; $i<$sow->{'SIDEED_PIXISIDE'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<h3><a $atr_id="roleother">����ȊO�̔\\�͎ҁi��E�j</a></h3>
<p class="paragraph" onclick="\$('#filter_roleother').slideToggle('slow');">
��L�ɂ��Ă͂܂�Ȃ��A����Ȕ\\�͂̎�����ł��B�ǂ������珟�����邩�A�ǂ̂悤�Ȑ����̖�E���A�܂��܂��Ȃ̂ł悭�m�F���܂��傤�B
</p>

<div id="filter_roleother"> 
<table border="1" class="vindex" summary="�\\�͎҈ꗗ�i���̑��j">
<thead>
  <tr>
    <th scope="col">�\\��</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'SIDEST_OTHER'}; $i<$sow->{'SIDEED_OTHER'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'ROLESHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&roleid=ROLEID_".uc($sow->{'ROLEID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'ROLENAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_role'}->[$i];
		$explain .= '<br><b>�i��������̑��̒��ӓ_�j</b><br>���������鑺��V�Ԃɂ́A�l����葽�߂̗ʂ̖�E���w�肵�܂��B�Ⴆ�΁A10�l�̑���13�l�̖�E���w�肵�Ă���΁A3�l���̖�E���A�u�N���Ȃ�Ȃ������c���E�v�ł��B' if ($sow->{'ROLEID_ROBBER'} == $i);
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

<h3><a $atr_id="rolegift">��E�ȊO�̔\\�́i���b�j</a></h3>
<p class="paragraph" onclick="\$('#filter_rolegift').slideToggle('slow');">
�\\�͂Ƃ͓Ɨ����āA���ʂȃ��[��������邱�Ƃ�����܂��B�ǂ������珟�����邩�A�ǂ̂悤�Ȑ����̖�E���A�܂��܂��Ȃ̂ł悭�m�F���܂��傤�B
</p>

<div id="filter_rolegift"> 
<table border="1" class="vindex" summary="���b�ꗗ">
<thead>
  <tr>
    <th scope="col">���b</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	for( $i=$sow->{'GIFTID_DEAL'}; $i<$sow->{'COUNT_GIFT'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'GIFTSHORTNAME'}->[$i] );
		my $url     = "sow.cgi?cmd=rolelist&$docid&giftid=GIFTID_".uc($sow->{'GIFTID'}->[$i]);
		my $name    = "<a href=\"$url\">". $sow->{'textrs'}->{'GIFTNAME'}->[$i] ."</a>";
		my $explain = $sow->{'textrs'}->{'EXPLAIN'}->{'explain_gift'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>


<h3><a $atr_id="start">�����n�܂�����</a></h3>
<p class="paragraph">
�����n�܂�ƎQ���҂̊�]�ɉ����Ĕ\\�͎҂����肳��A�����Ăǂ�Ȕ\\�͎҂����l����̂��Ƃ������󂪕\\������܂��B<br$net>
�܂��͂��Ȃ����ǂ�Ȕ\\�͎҂ɂȂ��Ă���̂��m�F���܂��傤�B��]���ʂ��Ė]�ݒʂ�̔\\�͎҂ɂȂ��Ă��邩������܂��񂵁A�v�������Ȃ��\\�͎҂ɂȂ��Ă��܂��Ă��邩������܂���B
</p>

<p class="paragraph">
���Ȃ��̔\\�͂��m�F������A�������悢��Q�[���̎n�܂�ł��B<br$net>
���Ȃ������l���ł���΁A�l�T��T���n�߂܂��傤�B�l�T�͐l�ԂɂȂ肷�܂��Ă��܂��B�������A���S�ɐl�ԂɂȂ肷�܂��͓̂�����̂ł��B���������Ɗ������Ƃ��낪����΁A���̐l�̔������悭�������Ă݂܂��傤�B
</p>

<p class="paragraph">
���Ȃ����l�T�ł���΁A�����ƒ��Ԃ�����͂��ł��B�l�T��������������Ɖ�b�����킹��u�����v�ƌĂ΂�����Ȕ�����������͂��ł��B�܂��͂����ň��A�����Ă݂܂��傤�B�����āA�\\�ł͐l�Ԃ̐U������āA�u���͐l�T��T���Ă���̂��v�Ƃ����悤�ȃ|�[�Y�����A����̐l�ԒB��M�p�����܂��傤�B
</p>

<p class="paragraph">
�ŏ��͂ǂ���������΂����̂��킩��Ȃ���������܂���B���v�A�����ƒN�����u�c��v���o���Ă���܂��B�ŏ��͂��̋c��ɓ����Ă����΂����̂ł��B�c��ɓ����邤���A�N�������Ȃ��̉񓚂Ɏ�����Ԃ��ė���ł��傤�B���x�͂��̎���ɓ����Ă݂܂��傤�B��������Ă�����ɁA���Ȃ������񂾂񊵂�Ă���͂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="event">����</a></h3>
<p class="paragraph" onclick="\$('#filter_event').slideToggle('slow');">
����Ȏ�����������������܂��B���̓��A���͒񎦂��ꂽ���[���ɏ]���ł��傤�B
</p>

<div id="filter_event"> 
<table border="1" class="vindex" summary="�����ꗗ">
<thead>
  <tr>
    <th scope="col">����</th>
    <th scope="col">����</th>
  </tr>
</thead>

<tbody>
_HTML_
	# �_�~�[�f�[�^�̐���
	for( $i=1; $i<$sow->{'COUNT_EVENT'}; $i++ ){
		next if ( '' eq $sow->{'textrs'}->{'EVENTNAME'}->[$i] );
		my $name    = $sow->{'textrs'}->{'EVENTNAME'}->[$i];
		my $explain = $sow->{'textrs'}->{'EXPLAIN_EVENT'}->[$i];
	print <<"_HTML_";
  <tr>
    <td nowrap>$name</td>
    <td>$explain</td>
  </tr>
_HTML_
	}
	print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>


<h3><a $atr_id="die">���S</a></h3>
<p class="paragraph">
�Q�[����i�߂Ă��������A���Y���ꂽ��l�T�ɏP�����ꂽ�肵�āA���Ȃ������𗎂Ƃ����ɂȂ邩������܂���B<br$net>
���S����ƁA���Ȃ��͎��҂̐��E�֌������܂��B���҂̐��E�ł͎��ғ��m����b�����킷�����ł��܂��B�������A���ғ��m�̉�b�͐����҂ɂ͕������܂���B���҂��邠�Ȃ��͐����҂Ɖ�b�����킷�����ł��܂���B<br$net>
�u�H�E�g�[�N�v�̐ݒ肪����Ă��鑺�ł́A���S���Ă��Ă��������Ă���l�T�A�d���Ɖ�b�����킷���Ƃ��\\�ł��B
</p>

<p class="paragraph">
����ӂ��Ă����ĉ������B���Ȃ�����l����̌ǓƂȃn���X�^�[�l�ԂȂǂł͂Ȃ�����A���Ȃ��ɂ͒��Ԃ����܂��B<br$net>
���̃Q�[���͑��̃Q�[���ƈႢ�A���Ȃ������S���Ă��������Ȃ��̔s�k�ƂȂ�킯�ł͂���܂���B���Ȃ��̒��ԒB����������΁A���Ȃ������̃Q�[���ɏ������鎖�ɂȂ�܂��B���̃Q�[���̏��s�ɁA���Ȃ��l�̐����͒��ڊ֌W���܂���B<br$net>
�󋵂ɂ���ẮA���Ȃ��������󂯓���鎖�ŁA���Ȃ����g�̏����ڂ����߂鎖������ł��傤�B
</p>

<p class="paragraph">
�������A���S���Ă��܂������Ȃ��ɂ́A�������ڏ��s�Ɋւ�鎖�͂ł��܂���B�ł��̂ŁA���̎��҂����ƂƂ��ɂ܂������Ă��钇�Ԃ���������������A�����҂̂������Ȉӌ��Ƀc�b�R�~����ꂽ��A���邢�͒P�ɎG�k�����肵�āA���҂̐��E���y���݂܂��傤�B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="suddendeath">�ˑR��</a></h3>
<p class="paragraph">
���������Ȃ��܂܍X�V���}����ƁA�Q�[�������Ƃ݂Ȃ���Ď����I�Ɂu�ˑR���v���A�Q�[�����珜�O����܂��B<br$net>
���̓���͂Ƃ��ɗ��\�����A���̕��j�Ɠ���܂Ȃ����Ƃ�����ł��傤�B
</p>

<p class="paragraph">
�ˑR����h���ɂ́A�X�V�܂łɒʏ픭�����Œ��񂵂Ă��������B�A�N�V������Ƃ茾�A�l�T�̂����₫�ȂǂŔ������Ă��ˑR����h���܂���B<br$net>
�܂��A�ʏ픭�����s���Ă��m�肷��O�ɍ폜���Ă��܂����ꍇ�́u�ʏ픭���������v�Ƃ݂͂Ȃ���܂���B
</p>

<p class="paragraph">
���ɖ������҂�����ꍇ�A�������͗��̂�����Ɂu�{���܂��������Ă��Ȃ��҂́`�v�Ƃ����V�X�e�����b�Z�[�W���\\������܂��B�����Ɏ����̖��O���\\������Ă��Ȃ���΁A���Ȃ��͍X�V���}���Ă��ˑR�����܂���B
</p>
<hr class="invisible_hr"$net>

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
