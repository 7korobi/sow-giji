package SWDocChangeLog;

#----------------------------------------
# �X�V���
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => "�X�V���", # �^�C�g��
	};

	return bless($self, $class);
}

#----------------------------------------
# �ŐV�̍X�V���̕\��
#----------------------------------------
sub outhtmlnew {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3 id="i1">Version 0.92 (2008/09/28)</h3> 
<ul class="list1" style="padding-left:16px;margin-left:16px;"> 
<li>�������̕s���A�킩��Â炢�\\����������܂����B</li> 
<ul class="list2" style="padding-left:16px;margin-left:16px;"> 
<li>�T�����͐����܂ŁA�{�l�ɂ����l�ƌ����������܂��񂪁A���ꂽ�Ƃ��̃��b�Z�[�W���}�j���A���ɉ����܂����B</li> 
<li>�������b�Z�[�W�̐�����V�ѕ��ɒǉ����܂����B</li> 
<li>�ׂ����\�����������������܂����B</li> 
</ul> 
<li>���b�L�[���X�^�[</li> 
�V���v�����A��ǋ����đ����ĉ�ʂ��������܂����B�ꕔ�̍��ڂ��f�t�H���g�l�Œ�ɂȂ��Ă��܂��B<br> 
<li>�����ĉ�ʂ̃f�U�C����ύX���A��{�ݒ�̊ȒP�Ȑ�����\������悤�ɂ��܂����B</li> 
<ul class="list2" style="padding-left:16px;margin-left:16px;"> 
<li>���������ꗗ�\\��V�݂��܂����B��{�ݒ�͕��͌n�ƂP�΂P�ɑΉ����A�p��▼�̂����ꂼ��قȂ�܂��B�����������m�F���A�������Ă�Q�l�ɂ��܂��傤�B</li> 
</ul> 
<li>_info.pl���B����Ɨ������A�ݒ�t�@�C�����e��Z�߁A�����ď����\\������悤�ɂ��܂����B</li> 
<li>���܂�������A�L�����N�^�[�������Ă��܂��B�������ɋN����܂��̂ŁA���y���݂ɁB</li> 
<li>�ׂ����s��A�o�O��������܂����B</li> 
</ul> 
<div style="text-align:RIGHT">(based on SWBBS V2.00 Beta 8 )<br></div> 
<hr class="invisible_hr"$net>
_HTML_

}

#----------------------------------------
# �X�V���̕\��
#----------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	print <<"_HTML_";
<h2><a $atr_id="changelog">�X�V���</a></h2>

_HTML_

	$self->outhtmlnew();

	print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3>Version 0.91 (based on SWBBS V2.00 Beta 8 ) (2008/06/14)</h3>
<ul>
  <li>�_�~�[�̈Ⴄ�L�����Z�b�g�𐔓_�p�ӂ��܂����B���ꂼ����I�ȑ䎌�������̂ŁA�L�����N�^�[�摜�ꗗ�Ō��Ă݂Ă��������B</li>
  <li>�~���[�Y�z���[<br>�������������܂����B</li>
  <li>�I�[�����X�^�[<br>�������������܂����B</li>
  <li>���b�L�[���X�^�[<br>���͌n��ǉ����܂����B�I�[���X�^�[�̖�E�̐��͑������āA�����Ă����G���Ǝv���܂��B����������J�̊ɘa��_���ɂ����Z�b�g�ŁA������������ł��B</li>
  <li>\�\\���X�^�C���u�����v��ǉ����܂����B</li>
  <li>�嗐���̔��������u�ނ肹���v�ł́A�����̓\\��\�t���Ŕ��������������悤�ɂȂ�܂����B</li>
  <li>�����_���\\���@�\\[[role]]��������悤�ɂȂ�܂����B</li>
  <li>�_�ċ@�\\��ǉ����܂����B�����Đl���_�Ă�����ƁA�Q���҂̔��������O�Ɏd�؂�Ȃ����܂��B�����̍X�V���Ԃ܂łɖ������̂܂܂̐l�́A�����Ǒ�����ދ������������ƂɂȂ�܂��B</li>
  <li>���܂�������A�L�����N�^�[�������Ă��܂��B�������ɋN����܂��̂ŁA���y���݂ɁB</li>
  <li>�ׂ����s��A�o�O��������܂����B</li>
</ul>
<div style="text-align:RIGHT">(based on SWBBS V2.00 Beta 8 )<br></div> 
<hr class="invisible_hr"$net>

<h3>Version 0.90 (based on SWBBS V2.00 Beta 8 ) (2008/03/25)</h3>
<ul>
  <li>���͌n���ƂɁA�ʁX�̖�E�Z�b�g��p�ӂ��܂����B</li>
<ul>
  <li>�~���[�Y�z���[<br>�a���ҁA��l�A�����A�����A�����A�L���[�s�b�h�A�ۈ�����ǉ����܂����B</li>
  <li>�^�u���̐l�T<br>�_�b�}�j�A��ǉ����܂����B�Ǝ��̎d�l�ɂȂ��Ă���̂ŁA�V�ѕ��A��E�ƃC���^�[�t�F�C�X�A���悭�m�F���Ă��������B�f�r���A���A�s�����m�ɂ͑Ή����Ă��܂���B</li>
  <li>�A���e�B���b�g<br>�C��t�A��}�t�A�Ǐ]�ҁA��ҁA�܋��ҁA�l���A���q�l�A�T�����A�a���ҁA�a�l�A�����A�����A���T�A���p�t�A�e�T�A���c�A�����A��C�T�A�L���[�s�b�h�A����ҁA���̗ւ�ǉ����܂����B�h���[�t�A�h�b�y���Q���K�[�A�A�����A�����ҁA�ϗ��w�҂ɂ͑Ή����Ă��܂���B</li>
  <li>�l�T����<br>���ҁA�~��ҁA�߂��ꂽ�l�A�B���p�t�A�l�`�g���A�񖳋R�m�A���h�J���l�ԁA�����A�_�b�}�j�A�A�L���[�s�b�h�A����ҁA���[�ҁA���S�A�d���̎q��ǉ����܂����B</li>
  <li>PARANOIA<br>�������I�t�B�T�[�A�v���Y�}�E�L���m���A�A�X�x�X�g�E�A�[�}�[�A���E�тt�u�l�A�������e�A���`�d�c�A�w���X�R�[�v�A�����W���b�N�A���Г���A���ЃA�C�h���A�O���E���c�A���Y�d���A�h�ؗd���A�����A��q�A��C�T�A�`�[�����[�_�[�A���̗ցA���Ђ̃X�p�C��ǉ����܂����B</li>
  <li>�I�[���X�^�[<br>����t�A�C��t�A���ҁA��}�t�A�~��ҁA�Ǐ]�ҁA�����ҁA�܋��ҁA�l���A���q�l�A�T�����A���l�A�a���ҁA�a�l�A�B���p�t�A�����A�����A�߈ˎҁA���T�A���_���A���p�t�A���T�A�e�T�A���T�A�٘T�A�񖳋R�m�A���c�A���Y�d���A�ז��d���A�[�T�d���A�h�ؗd���A���ԗd���A�����A��q�A��C�T�A���V�g�A����ҁA���̗ցA���[�ҁA���S�A�d���̎q��ǉ����܂����B</li>
</ul>
  <li>���������u���قւ̒���v�A�u�ߖ񁕊��сv�A�u���B�v�A�u�ނ肹���v�A�u�����ς��v��ǉ����܂����B</li>
  <li>�H�E�g�[�N��ǉ����܂����B�I������ƘT�A�d���́A���҂Ɖ�b���ł��܂��B</li>
  <li>�����l��ǉ����܂����B���s�ɂ������Ȃ��Q���҂ł��B�Q���x�������A�q�ȁA�����A����A����I�����đ������ĂĂ��������B</li>
  <li>�{��������P�p���A��������ǉ����܂����B���ŉ����������Ƃ����܂��Ă���A�������̂��鑺�ɂ��g�����������B</li>
  <li>���͂̏C���ɁA�u���o���v��ǉ����܂����B�����̈�s�ڂ����������̂ŁA�H�v���Ă��g�����������B</li>
  <li>�A�N�V�����̓��e�C���^�[�t�F�C�X��ύX���܂����B</li>
  <li>�\\�͍s�g�A�����C���^�[�t�F�C�X��ύX���܂����B</li>
  <li>�p�����畜���A�@�\\��ǉ����܂����B�������Ȃ��������́A�N�������T�C�N�����Ă���邩������܂���B</li>
  <li>�v�����[�O�ŁA�Q���҂ɑދ����������@�\\��ǉ����܂����B</li>
  <li>�i�s���A�Q�x�܂ł͍X�V����������x�点��I�����ł���@�\\��ǉ����܂����B</li>
  <li>�~ �����_���\\���@�\\�̂����A��E�������_���\\������[[role]]�͎g���܂���B���������������B</li>
  <li>�G�s���[�O�ŁA�����A���A�O�b�A�߈ˁA�Ƃ茾���g����悤�ɂȂ�܂����B</li>
  <li>�g�b�v�摜���A�����ŕω�����悤�ɂ��܂����B</li>
  <li>\�\\���X�^�C���u�����v�u����480�v�u����v�u����480�v��ǉ����܂����B</li>
  <li>�����ɂt�q�k���܂܂��ꍇ�A�����I�Ƀ����N�ɂ���@�\\��ǉ����܂����B</li>
  <li>���̈ꗗ�\\�����e�𐮗����Ȃ����܂����B</li>
  <li>���O�C���������Q�O���Ԃɂ��܂����B����ȏ󋵂Ń��O�C���s��\�\�ɂȂ��Ă��܂����ꍇ�A�Q�O���Ԃł��̏�Ԃ���������܂��B</li>
  <li>���܂�������A�L�����N�^�[�������Ă��܂��B�������ɋN����܂��̂ŁA���y���݂ɁB</li>
  <li>�ׂ����s��A�o�O��������܂����B</li>
</ul>
<div style="text-align:RIGHT">(based on SWBBS V2.00 Beta 8 )<br></div> 
<h3>Version 2.00 Beta 8 (2007/02/06)</h3>
<ul>
  <li>�I���ςݑ��ꗗ�Ƀy�[�W�ړ���ǉ����܂����i�������蔲���j�B</li>
  <li>����RSS���\\������Ȃ��Ȃ�o�O���C�����܂����B</li>
  <li>�g�у��[�h�̑��ꗗ�ւ̃����N�Ɉ��� turn ���󂯌p�����o�O���i�Ƃ肠�����j�C�����܂����B�ł��܂�������Ƃ͒����Ă��܂���B</li>
  <li>�S�������S����ƃG�s���[�O����u�ŏI����Ă��܂��o�O���C�����܂����B</li>
  <li>�V��E<del>�u�g���b�N�X�^�[�v</del>�s�N�V�[��ǉ����܂����B</li>
  <li>�����Đl��Ǘ��l���Q�����Ă����ہA�g�у��[�h�̌l�i�荞�݋@�\\�ő����Đl��Ǘ��l�̃L�������i�荞�ނƑ����Đl��Ǘ��l�������\\������Ă��܂��o�O���C�����܂����B</li>
  <li>�ꕔ�̌g�тŉ��s�R�[�h�����܂���������Ȃ��悤�Ȃ̂ŁA���s�R�[�h�̈�������ύX���܂����B���̕ύX�ɂ��A[[br]]�Ə����Ɖ��s�R�[�h�ɕϊ������悤�ɂȂ�܂��B</li>
  <li>�ꕔ��SoftBank�g�тŎ����F�������܂������Ȃ������C�����܂����i���Ԃ�j�B</li>
  <li>���[�E�\\�͂̑ΏۂɁu�����_���v���܂߂���ԂŁA�l�T���P����Ɂu���܂����v��I�Ԃƃ����_���Ƃ��ď��������o�O���C�����܂����B</li>
  <li>���쐬�^�ҏW�̍ہA�J�n���@���l�TBBS�^�Ŗ�E�z�����R�ݒ�̎��ɍŒ�l���ƒ�����قȂ�l���ɐݒ�ł��Ă��܂��o�O���C�����܂����i�G���[���o���܂��j�B</li>
  <li>�s���v�Z�ɃA�N�V�������܂ސݒ�̍ۂɁA�g�у��[�h�Ŏ��y�[�W�ړ��i���j������ƃ��O������ɕ\\������Ȃ��o�O���C�����܂����B</li>
  <li>���ݎQ�����̃v���C���[���I�����Ă��Ȃ��L�����Z�b�g���g�p�����L�����̔������A�\\�����鑺���O�Ɋ܂܂�Ă����ꍇ�ɃL�����摜���\\������Ȃ��Ȃ�o�O���C�����܂����B</li>
  <li>��E��]�Ɂu�����_���v��ǉ����܂����B</li>
  <li>���쐬�^�ҏW�Ɂu��E��]�𖳎�����v�Ƃ������ڂ�ǉ����܂����B</li>
  <li>���쐬�^�ҏW�Ɂu�{�������v�Ƃ������ڂ�ǉ����܂����B</li>
  <li>RSS �� UTF-8 �ŏo�͂ł���悤�ɂ��܂����i�vJcode.pm�j�B</li>
  <li>RSS�ւ̃����N�𒣂邩�ǂ�����ݒ�t�@�C���Ő؂�ւ�����悤�ɂ��܂����B</li>
  <li>�X�V�����ɏ����Y��Ă��܂������A�v�����[�O�ł̔������⋋�͊J�n���@�Ɋւ�炸�⋋����Ȃ��悤�ɕύX���Ă��܂��B</li>
  <li>�܂��u��E�v�Ɓu�����v�Ƃ����p�ꂪ���݂��Ă����̂Łi��΁j�A�u��E�v�ɓ��ꂵ�܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 7 (2007/01/21)</h3>
<ul>
  <li>���쐬�^�ҏW�ɁuID���J�v�̃I�v�V������ǉ����܂����B������ƃe�X�g���Ă��܂��񂪁B</li>
  <li>�����v���r���[����pt�v�Z�����낢��Ԉ���Ă����̂ŏC�����܂����i���Ԃ�j�B</li>
  <li>�����v���r���[���ɗ]�v�ȉ��s�����悤�ɂ��܂����B</li>
  <li>�v�����[�O���J�n���@���l�TBBS�^�ȊO�̎��A�����̉��ɍX�V�\\�莞�Ԃł͂Ȃ��X�V���Ԃ�\\������悤�ɂ��܂����B</li>
  <li>��L�C���������v���r���[�ɓK�p����Ă��Ȃ������̂ŁA�K�p���܂����B</li>
  <li>�����_���\\���@�\\��ǉ����܂����B</li>
  <li>���[�U�[���y�[�W��ǉ����܂����B��тȂǂ͂܂��L�^���Ă��܂���B</li>
  <li>���[�U�[���� URL ���� http�X�L�[���܂���https�X�L�[���ȊO�̃A�h���X����͂����ۂɃ����N�𒣂�Ȃ��悤�ɏC�����܂����B</li>
  <li>PC���[�h�ł́A�G�s���[�O�̔z���ꗗ�\\����ύX���܂����i���łɌ����^�I�����Ă��鑺�̕\\���͍X�V����܂���B</li>
  <li>�����p���@�\\��ǉ����܂����B</li>
  <li>�Ǘ��Ҍ����ɂ�鋭���p���@�\\��ǉ����܂����B</li>
  <li>�g�у��[�h���M���R�}���h�̕W���ݒ�� get ���� post �ɕύX���܂����B</li>
  <li>�Œ�l���ȏ�̐l�Ԃ��W�܂��Ă����ԂŁA���̊J�n���@��l�TBBS�����ȊO�ɂ�����ԂōX�V���Ԃ��߂��A���̌�ɐl�TBBS�����֕ύX����ƓˑR�����J�n���Ă��܂��o�O���C�����܂����B</li>
  <li>�g�у��[�h���܂��s���ȓ���������̂ňꉞ�C�����܂����i�����܂ňꉞ�j�B</li>
  <li>�G���g���[�����v���r���[����C���{�^���������܂����B</li>
  <li>�v�����[�O�ł̎����ǂ��o���@�\\��ǉ����܂����i�ǉ��O�ɑ��֎Q�������l�͑ΏۊO�ł��j�B</li>
  <li>�g�у��[�h�̑��̏��y�[�W�Ɋe�v���C���[�̎c�蔭������\\������悤�ɂ��܂����B</li>
  <li>��E�ƃC���^�[�t�F�C�X�̃y�[�W��ǉ����܂����i�܂��蔲���ł����j�B</li>
  <li>�\\�͌��ʕ\\����������Ǝ蒼�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 6 (2007/01/06)</h3>
<ul>
  <li>���[�U�[ID�ɋ󔒂݂̂�ID���g���Ȃ��悤�ɂ��܂����B</li>
  <li>�������ipt�j��[�̃^�C�~���O��ς��܂����B�蔲���ł����B</li>
  <li>���~�R���炢�蔲���ł����g�у��[�h�ɑ��ꗗ��ʂ�ǉ����܂����B</li>
  <li>�蔲���ł����g�у��[�h�Ɍl�i�荞�݋@�\\��t���܂����B�������v�����[�O�ł͌����܂���i���r���[�j�B</li>
  <li>�A�N�V�����ɂ�����@�\\��ǉ����܂����i�u�����܂œǂ񂾁v�j�B</li>
  <li>�_�~�[�L�����pID�E�Ǘ��l�pID���o�^����Ă��Ȃ��ƁA�x�����o���悤�ɂ��܂����B</li>
  <li>�����v���r���[�Ɂu�C���v�{�^����t���܂����i�����Đl�E�Ǘ��l�����͏����j�B</li>
  <li>�����v���r���[�ł͂ݏo�����������Ԃ����؂炸�ɊD�F�\\������悤�ύX���܂����B</li>
  <li>PC���[�h�ŃG�s���[�O���Ƀ������͗����\\������Ȃ��o�O���C�����܂����B</li>
  <li>�����ғ������̐����ݒ�l��V�K�ǉ����܂����B���������Ȏ����ł����i�܂���</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 5 (2006/12/26)</h3>
<ul>
  <li>�V��E�u���T�v�u�q�T�v��ǉ����܂����B</li>
  <li>����ɒB���Ă���̂ɎQ���ł��Ă��܂��o�O���C�����܂����B</li>
  <li>�g�у��[�h�ŏI�����ɖ����ȃy�[�W�����N���\\�������o�O���C�����܂����B</li>
  <li>��q�������A��q�������b�Z�[�W�Ɍ��������̖��O���\\������Ȃ��o�O���C�����܂����B</li>
  <li>���쐬�^�ҏW���ɍŒ�l���̃`�F�b�N�����Ă��Ȃ��o�O���C�����܂����B</li>
  <li>�ꔭ�����ɂR�ȏ�� &amp; ���܂܂�Ă���ƁA�R�ڈȍ~�� &amp; �������Q�ƂɃG�X�P�[�v����Ȃ��o�O���C�����܂����B</li>
  <li>�ŐV�̔����� RSS �Ȃǂ��烍�OID�w��\\���������ɁA�������̃A���J�[�����������Ȃ�o�O���C�����܂����B���Ԃ�B</li>
  <li>�����̉񐔐ݒ肪���������o�O���C�����܂����B</li>
  <li>�蔲���ł�����E�z���ꗗ�\\��ǉ����܂���</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 4 (2006/12/17)</h3>
<ul>
  <li>�����O�œ����ȊO�̓�����u�g�b�v�y�[�W�֖߂�v�̃����N���N���b�N����ƁA�i�s���̑��̈ꗗ�ɏI���ς݂̑����\\������Ă��܂��o�O���i�b��Ȃ���j�C�����܂����B</li>
  <li>�閧��b�i�����₫�E���E�O�b�j�p�������͗��ɓ����`�F�b�N���������Ă����̂��C�����܂����B</li>
  <li>�X�^�C���V�[�g���ꕔ�C�����܂����i�������t�̃t�H���g�T�C�Y���j�B</li>
  <li>�g�у��[�h�ł̕s���n�V�X�e�������i���[�ݒ�Ȃǁj�̕\\���F���D�F�ɕύX���܂����B</li>
  <li>Beta 3 �Œ������Ǝv���Ă����g�у��[�h�̃}�X�N������������ƒ����ĂȂ������̂ŁA�ďC�����܂����i��΁j�B</li>
  <li>�������v�Z�̍ۂɁu&lt;�v�u&gt;�v�u&amp;�v�u&quot;�v�̕����𕶎��Q�Ƃ̌`�Ő����Ă����o�O���C�����܂����B</li>
  <li>��L�C���̍ۂɃ|�C���g�v�Z���̏C��������̂�Y��Ă����̂ŁA�C�����܂����i��΁j�B</li>
  <li>�u&lt;�v���܂ޔ���������ƁA�u&lt;�v�ȍ~�̕��͂��Ȃ��Ȃ��Ă��܂��o�O���C�����܂����B</li>
  <li>�����Q�Ƃ��܂ޔ���������ƁARSS��description�v�f������ɏo�͂���Ȃ���������o�O���C�����܂����B</li>
  <li>PC���[�h�Ƀy�[�W�����\\���@�\\���b��I�ɒǉ����܂����B���A�\\�z�ʂ蓮�����s���ł��i����</li>
  <li>�I���������̏��y�[�W���\\���ł��Ȃ��o�O���C�����܂����B</li>
  <li>�ŐV���ɍŐV�y�[�W�ȊO�ł��������͗����\\������Ă��܂��o�O���C�����܂����B</li>
  <li>�P�������U�N���ɍ��킹��ƁA�u���܂����v�ɖ߂��Ȃ��Ȃ�o�O���C�����܂����B</li>
  <li>�����I�ɐ��l�����Q�Ƃ��g����悤�ɂ��Ă݂܂����B</li>
  <li>�g�у��[�h�ŕ\\���������u�ォ�牺�v�ɂ������ɁA�A���J�[�����ԂƃA���J�[�悪��ԉ��ɂȂ��Ă��܂��o�O���C�����܂����B</li>
  <li>���̏��y�[�W�Ɂu�J�n���@�v��\\������悤�ɂ��܂����B</li>
  <li>�t�B���^�Ɏ��S����\\������悤�ɂ��܂����B</li>
  <li>�t�B���^�̎��S�ҕ\\�������S���̏��ɕ��Ԃ悤�ɕύX���܂����B</li>
  <li>�n���X�^�[�l�Ԃ�R�E�����l�Ԃ��肢�Ŏ��S�������Ɏ��S�����������L�^����Ȃ��o�O���C�����܂����B</li>
  <li>�ʏ픭������閧��b�i�����₫�A���A�O�b�j�ւ̃A���J�[���łĂȂ��悤�ɂ��܂����B</li>
  <li>�扺�Ƃ茾����扺�����ւ̃A���J�[���łĂȂ��o�O���C�����܂����B</li>
  <li>�ݒ�l NAME_SW ��ǉ����܂����B�������L�q����ۂɗ��p���ĉ������B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 3 (2006/12/10)</h3>
<ul>
  <li>������\\���Ă��Ȃ���ԂŁA�������͗��ɃX�y�[�X����s����͂��āu������\\��v�������ƁA�������͂����Ă��܂��o�O���C�����܂����B</li>
  <li>�����̃L�����Z�b�g���g�p���Ă���ۂɁA�_�~�[�L�����w��ݒ�̃L�������i���̃L���������Q���ł���̂ɂ�������炸�j�Q����ʂőI�ׂȂ��o�O���C�����܂����B</li>
  <li>�g�у��[�h�ŁA�y�[�W�����N�ƑO�ړ������N�̈��� logid �ɑ΂���}�X�N�������s���Ȃ��o�O���C�����܂����B</li>
  <li>�g�у��[�h�Ń���������\\���������ɁA�����o���l�̖��O���Ɂu�����o�܂����v�ƕ\\������Ȃ��o�O���C�����܂����B</li>
  <li>�g�у��[�h�őS�pID���g�p�������Ƀ����N�悪���������Ȃ�o�O���C�����܂����B</li>
  <li>���O�C���^���O�A�E�g�{�^���̑��M��A�h���X��CGI�x�[�X�A�h���X�������Ă���o�O���C�����܂����B</li>
  <li>�g�у��[�h�̃A�N�Z�X�L�[�ݒ���ꕔ�C�����܂����B</li>
  <li>��E�z�����R�ݒ莞�ɁA����ɖ����Ȃ���Ԃő����J�n�ł��Ă��܂��o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 2 (2006/12/06)</h3>
<ul>
  <li>�o�[�W�����̕\\�L���uAlpha Beta 1�v�ɂȂ��Ă��܂����Borz</li>
  <li>�I������������͗����\\�������o�O���C�����܂����B</li>
  <li>�폜������������悤�ɂ��邩�ǂ����̐ݒ�l��ǉ����܂����B</li>
  <li>���ҏW���Ɋg���ݒ�́u���́v�������f����Ȃ��o�O���C�����܂����B</li>
  <li>�����̍ő�^�ŏ��T�C�Y�A�ő�s���ݒ��ǉ����܂����B</li>
  <li>IE�ŐR�╗�X�^�C����I�����Ă��鎞�ɁA�扺�����̘g�����ɏ����͂ݏo����������o�O���b��I�ɏC�����܂����B�ꓖ����C���Ȃ̂ł��̂����������܂��B</li>
  <li>�I�����������O��RSS���o�͂���Ȃ��o�O���C�����܂����B</li>
  <li>�����ORSS�̕\\���s������������ɊԈ���Ă��܂����i��΁j�B</li>
  <li>info.pl ���Ȃ��ƃG���[�ɂȂ�o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 1 (2006/12/05)</h3>
<ul>
  <li>�V�ѕ��i������@�j��ǉ����܂����B�܂��S�R����܂��񂪁A���������ǉ����Ă����Ƃ������ŁB</li>
  <li>�����A���J�[��łƍŐV�̔������i�Ƃ茾�ȂǁA�{�������Ȃ������ł����Ă��j�|�b�v�A�b�v���Ă��܂��o�O���C�����܂����B</li>
  <li>�����܂��̓���������\\�����Ă��鎞�̃��O�ւ̃����N���� #newsay ���O���܂����B</li>
  <li>�l�T���Ŕ����v���r���[��\\���������ɁA�딚�`�F�b�N��t�����ɏ������݂������čēx�����v���r���[��\\��������Ɣ����ԍ��i99999�j���\\������Ă��܂��o�O���C�����܂����B</li>
  <li>���̈ꗗ�̑��ւ̃����N�� #newsay �����܂����B</li>
  <li>�����O��RSS�őO���̔����ւ̃����N�Ɉ���turn ���܂܂�Ă��Ȃ��o�O���C�����܂����B</li>
  <li>�g�у��[�h�̎��ɕ扺����������ŕ\\������悤�ɂ��܂����B</li>
  <li>���҂������y�[�W���J���ƃ������͗����\\������Ă��܂��o�O���C�����܂����B</li>
  <li>�G�s���[�O�ŃA�N�V�����̑Ώۂ����҂�I�ׂȂ��o�O���C�����܂����B</li>
  <li>�����s���I�[�o�[�̂��ߕ\\������Ă��Ȃ������ւ̃A���J�[�ŁA�|�b�v�A�b�v�\\��������Ȃ��o�O���C�����܂����B</li>
  <li>�A���J�[����ʑ��\\�����������ɂ���A���J�[�������Ȃ��o�O���C�����܂����B</li>
  <li>�i�s�������O��RSS�ŁA�Ƃ茾�Ȃǂ̔������}�X�NID�ł͂Ȃ��{�������Ȃ��͂��̖{���OID�ŏo�͂����o�O���C�����܂����B</li>
  <li>�_�~�[�L�����������o�鎖���ł��Ă��܂��o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 39 (2006/12/02)</h3>
<ul>
  <li>�g�у��[�h�ő��̏��y�[�W������ɕ\\������Ȃ��o�O���C�����܂����B</li>
  <li>�����@�\\�ɕ����������E�s��������������Ȃ��o�O���C�����܂����B</li>
  <li>�����������|�C���g���̎��ɁA�����v���r���[�ɏ���|�C���g�����\\������Ȃ��o�O���C�����܂����B</li>
  <li>������\\�����ꍇ�ARSS������ɕ\\������Ȃ��Ȃ�o�O���C�����܂����B</li>
  <li>RSS�ł̃����ւ̃����N���Ԉ�����A�h���X�ɂȂ��Ă���o�O���C�����܂����B</li>
  <li>�t�B���^�����z�u�ɂ������ɁA�l���̍��̃`�F�b�N�{�b�N�X���\\������Ȃ��o�O���C�����܂����B</li>
  <li>�������̕����������E�s�������ɂ��g�����@�\\�������ɂȂ��Ă��܂����B�f�O���[�h�����Borz</li>
  <li>����������20�s�܂ł����\\������Ȃ��o�O���C�����܂����B</li>
  <li>�L���b�V�����䂪�܂��������������̂ŉ��}���u���{���܂����B</li>
  <li>�����v���r���[���ɂ̓g�b�v�o�i�[�̃����N�ƃ��O�A�E�g�{�^���������ɂȂ�悤�C�����܂����B</li>
  <li>�������Z�����鎞�ɃG���[���o���悤�ɂ��܂����B</li>
  <li>�ߋ��̃����ɏ������߂Ă��܂��o�O���C�����܂����B</li>
  <li>�ŐV���̃����E����������\\�����Ă��鎞�́A���O�ւ̃����N�� #newsay ��������悤�ɂ��܂����B</li>
  <li><del>�u�ŐV�v�����N��ǉ����Ă݂܂����B�C���ł܂�������������܂���i�����j�B</del></li>
  <li>�u�ŐV�v�����N���u�������ցv�����N�ɉ��߂܂����B</li>
  <li>�ꕔ�̌g�ѓd�b���甭������Ɖ��s�R�[�h��������������o�O���C�����܂����i���Ԃ�</li>
  <li>���𔲂����l���\\���Ă����������u�����v���ɕ\\�����Ȃ��悤�ɂ��܂����i���������ɂ͕\\������܂��j�B</li>
  <li>������\\�����l�����𔲂��Ă���ꍇ�A���������̖��O���Ɂu(�����o�܂���)�v�ƒ��ӏ������o��悤�ɂ��܂����B</li>
  <li>�g�у��[�h�̃A���J�[�̋������F�X�ƃ{���{���������̂ŏC�����܂����B</li>
  <li>HTTP �� Location �� &amp; ���o�͂��鎞�� &amp;amp; ���������Ă����o�O���C�����܂����B
  <ul>
    <li>���̏C���� RSS�o�͂�����ɓ����Ȃ��Ȃ�o�O���o���̂Œ����܂����i�n��</li>
  </ul>
  </li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 38 (2006/11/30)</h3>
<ul>
  <li>�g�у��[�h�Ƀy�[�W�����N��ǉ����܂����B</li>
  <li>�g�у��[�h�œƂ茾���D�F�A�����E���E�O�b��ԐF�ŕ\\������悤�ɂ��܂����B</li>
  <li>PC���[�h�ŁA���̓��ւ̃A���J�[�Ƀ}�E�X�|�C���^���ڂ���ƃ|�b�v�A�b�v�\\������@�\\��ǉ����܂����B</li>
  <li>PC���[�h�ŁA�A���J�[���N���b�N����ƕʃE�B���h�E�ł��̔����݂̂��J���悤�ɂ��܂����B</li>
  <li>�V�ѕ��ɕ����������������̂Œ����܂����B</li>
  <li>�L���b�V��������������܂����B</li>
  <li>�ʏ픭�������Ă��A�m�肵�Ȃ����薢�����҃��X�g��������Ȃ��悤�ɕύX���܂����B
  <ul>
    <li>���̕ύX�ɂ��A�����P����g���Ď��������Ȃ��̂܂܂̓ˑR���������Ƃ��������ł��Ȃ��Ȃ�܂����B</li>
    <li>���̕ύX�ɂ��A�������m�肵�Ȃ��Ԃ͎��Ԃ�i�߂鎖���ł��Ȃ��Ȃ�܂����B</li>
  </ul>
  </li>
  <li>�����@�\\��ǉ����܂����B</li>
  <li>�l�T���iver/mikari 0.2�x�[�X�A�镔���̂݁j���o�͂���@�\\���b��I�Ɏ������܂����Bcmd=score �������ɕt������ƕ\\������܂��B</li>
  <li>�e�L�X�g�x�[�X�X�L�����b��I�Ɏ������܂����B�A�h���X�� &amp;css=text �ƕt������ΗL���ɂȂ�܂��B</li>
  <li>����R��X�L�����b��I�Ɏ������܂����B�A�h���X�� &amp;css=juna �ƕt������ΗL���ɂȂ�܂��B</li>
  <li>�ŐV�̔����Ƀ}�E�X���ڂ���ƕ����̐F���ς��o�O���C�����܂����B</li>
  <li>�g�у��[�h�Ŏ��܃G���[���o��o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 37 (2006/11/03)</h3>
<ul>
  <li>���̏��̐l�����Ƀ_�~�[�L�������݂̐l���Ƃ������ӏ��������܂����B</li>
  <li>�����o���l�̔����̃t�B���^�����O���������ȓ��������o�O���C�����܂����i���Ԃ�j�i���Ԃ񂩁j�B</li>
  <li>�P�����b�Z�[�W���t�B���^�ɘA�����Ȃ��o�O���C�����܂����B</li>
  <li>���ƔO�b�𚑂��t�B���^�Ńt�B���^�����O�ł���悤�ɂ��܂����B����ɔ��������t�B���^���u�����^���^�O�b�v�t�B���^�ɕύX���܂����B</li>
  <li>���̏��̔z���\\�������R�ݒ�̎��ɓ�d�ɂȂ�o�O���C�����܂����B</li>
  <li>�܂�����ɒB���Ă��Ȃ��ꍇ�ɁA���̏��ւ��Ɖ��l�Q���ł��邩��\\������悤�ɂ��܂����B</li>
  <li>�_�~�[�L�����ɑ΂���t�B���^���삪�����Ȃ��o�O���C�����܂����B</li>
  <li>�����҂���l�ȏア��ꍇ�ɁA��l�ڈȍ~�̐����҂̐F���\\������Ȃ��o�O���C�����܂����B</li>
  <li>���҂̑������\\������Ȃ��o�O���C�����܂����B</li>
  <li>�b��I�ɓ�d�����`�F�b�N�̍ۂɔ�����ʂ��`�F�b�N����悤�ɂ��܂����c�c���A���[��A�������Ȃ���i���j�B</li>
  <li>�Q���p�X���[�h�@�\\��ǉ����܂����B</li>
  <li>��W���^�J�n�҂��̑���RSS�ɊJ�n�ς݁^�I���ς݂̑����o�͂����o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 36 (2006/10/26)</h3>
<ul>
  <li>�v�����[�O�Œ���ɒB�������_�ő����Đl�i�܂��͊Ǘ��l�j���Q�����Ă��Ȃ��ꍇ�A�����Đl�i�Ǘ��l�j�p�̔����t�H�[�����\\������Ȃ��o�O���C�����܂����B</li>
  <li>�R�E�����l�Ԃ̃n���X�^�[�l�ԓ����i�P������Ȃ��A�����Ǝ��S����j�̏����������Ă����̂Œǉ����܂����B</li>
  <li>�R�~�b�g�����ۂɂP�����ȏ�̎��Ԃ��m�ۂ���Ȃ��o�O���C�����܂����B</li>
  <li>�������Ȃ̂ɃR�~�b�g�o���Ă��܂��o�O���C�����܂����B</li>
  <li>���������ł���̂Ɂu�G���g���[�͎������܂���v�ƕ\\������Ă����o�O���C�����܂����B</li>
  <li>�b�����l�̎��ɕ���킵���̂ŁA�����̏ȗ��������y�T�z����y�ԁz�ɕύX���܂����B</li>
  <li>�����O�̃^�C�g���ɓ���������悤�ɂ��܂����B</li>
  <li>�扺�œƂ茾���ꂯ��悤�ɕύX���܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 35 (2006/10/18)</h3>
<ul>
  <li>���̃X�N���v�g�̖��̂��u�~�j�l�TBBS�i���j�v����u�l�T����v�ɕύX���܂����B</li>
  <li>�R�~�b�g�@�\\��ǉ����܂����B</li>
  <li>�����҂��S���ˑR������ƓˑR���\\���̌�ɓ��e�����̘g���\\�������o�O���C�����܂����B</li>
  <li>���J�n���@���u�l�TBBS�^�i�X�V���Ԃ�������J�n�j�v�ȊO�̎��ɂ�������ꃁ�b�Z�[�W���\\�������o�O���C�����܂����B</li>
  <li>�����������͂̎��ɑ��쐬���ł��Ă��܂��o�O���C�����܂����B</li>
  <li>�I����́u�l�v�u�T�v�u��v�u�S�v���_�؂�ւ��������Ȃ��o�O���C�����܂����B</li>
  <li>�L���b�V������̎d�l��ύX���܂����BIE�͑ΏۊO�ɂ��܂����i�܁j�B</li>
  <li>�g�у��[�h�̃A�N�V�������͂ɂ������^���ƒ��ړ��͂̐؂�ւ����A���W�I�{�^���ł͂Ȃ��R���{�{�b�N�X�ōs���悤�ɕύX���܂����B</li>
  <li>�g�у��[�h�Ń��O�C����ɃG���[���o���ꍇ�A���O�C����ʂ֖߂郊���N�����\\������Ȃ��̂��s�ւȂ̂ŁA�ʏ�̃i�r�Q�[�^���\\�������悤�ɏC�����܂����B</li>
  <li>Version 8.x �ȑO�� Opera �ŁA�����Ⓤ�[�Z�b�g��������Ɛ���Ƀ����[�h����Ȃ����Ɏb��Ή����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 34 (2006/08/04)</h3>
<ul>
  <li>�g�у��[�h�ɐݒ��ʂ�t���܂����i�b��j�B</li>
  <li>�b�����l�̎��Ɍg�у��[�h�Ś����Ȃ��o�O���C�����܂����B</li>
  <li>���ҁE�R�E�����l�Ԃ�ǉ����܂����B</li>
  <li>�X�V��ɑ��̓�������ƃ����[�h���������s���Ȃ���������o�O���C�����܂����B</li>
  <li>�g�у��[�h�Ŏ��X������ &amp;amp; ��������o�O���C�����܂����B</li>
  <li>�i�s�����Ҏ��_�ŁA�����t�B���^�̎��҂̔����񐔂Ǝc��pt�����������\\������Ȃ��o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 33 (2006/08/03)</h3>
<ul>
  <li>���s�R�[�h�̈����ő�{�P���Ă��܂����i��΁j�B</li>
  <li>�g�у��[�h�ŁA�����v���r���[�ł̌딚�`�F�b�N�������Ȃ��o�O���C�����܂����B</li>
  <li>�g�у��[�h�ōŐV���ȊO�̓���\\������ƁA�������ړ��p�̃A���J�[���ŐV���ւ̃A���J�[�ɂȂ��Ă��܂��o�O���C�����܂����B</li>
  <li>�g�у��[�h�ŃA�N�V�����̉񐔂̒P�ʂ��upt�v�ɂȂ��Ă����o�O���C�����܂����B</li>
  <li>�u���E�U�ɂ���Ĕ����t�B���^���N���b�N���Ă��F���ς��Ȃ��o�O���C�����܂����B</li>
  <li>�ꉞ��d�������悤�Ƃ������ɃG���[���o���悤�ɂ��܂����B�A�N�V�����͑ΏۊO�ł��B</li>
  <li>�J�n������̏��Ɂu����v���\\������Ă����̂ŁA�u�l���v�ɕύX���܂����B</li>
</ul>
<hr class="invisible_hr"$net>
  
<h3>Version 2.00 Alpha 32 (2006/08/01)</h3>
<ul>
  <li>PC���[�h�ŃA���J�[�������Ȃ��Ȃ��Ă����̂��C�����܂����BHAHAHAHAHAHA�c�c�B</li>
  <li>���̕ҏW���Ɂu���̐����v���̉��s��br�v�f�ɉ����Ă��܂��o�O���C�����܂����B</li>
  <li>���̕ҏW���ɁA�u���̊J�n�v�����������\\������Ȃ��o�O���C�����܂����B</li>
  <li>�A�N�V��������͂����ۂɃ����[�h�����܂���������Ȃ��o�O���C�����܂����B</li>
  <li>�g�у��[�h�̉��i���i�r�Q�[�^����i���̃i�r�Q�[�^�ɂȂ��Ă����o�O���C�����܂����B</li>
  <li>�b�̑����𑣂��@�\\�̎c��񐔂��`�F�b�N���Ă��Ȃ������o�O���C�����܂����B</li>
  <li>����������ƕ\\�������������Ȃ�o�O���C�����܂����B</li>
  <li>�S�ĕ\\���ɂ�����A���̂܂܃��O�C���^���O�A�E�g�����菑�����񂾂肷��ƑS�s�\\���ɂȂ��Ă��܂��o�O���C�����܂����B</li>
  <li>����������O�̃L�����̔��������֍ēx��������̃L�����̔����t�B���^�ɘA�����Ă��܂��o�O���C�����܂����B</li>
  <li>�ϔC���[�@�\\��ǉ������c�c��������܂���i�����H�j�B</li>
  <li>�����@�\\��ǉ������c�c��������܂���i�����H�j�B</li>
  <li>�����t�B���^�Ŏ����̔�������������ԂŔ����v���r���[��\\������Ɣ������\\������Ȃ��o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 31 (2006/07/31)</h3>
<ul>
  <li>�����Đl�܂��͊Ǘ��l������ID�ő��ɎQ�����Ă���ƁA�����Đl�^�Ǘ��l�������Q�����Ă���L�����N�^�[�̔����t�B���^�ɘA�����ē����Ă��܂��o�O���C�����܂����B</li>
  <li>���̈ꗗ�i��W���^�J�n�O�j��RSS��ǉ����܂����B�����V�K�쐬�����ƍX�V����܂��B</li>
  <li>�u��E�v�Ɓu�����v�����݂��Ă����̂ŁA�u��E�v�ɓ��ꂵ�܂����B</li>
  <li>�g�у��[�h�Ŕ��������s���ƕ\\���s���ݒ肪�f�t�H���g�ɖ߂��Ă��܂��o�O���C�����܂����B</li>
  <li>�g�у��[�h�ɓ��t�����N��ǉ����܂����B</li>
  <li>�g�у��[�h�̕\\���s������ all �������܂����B</li>
  <li>�g�у��[�h�ɂ���肠���������v���r���[�@�\\��t���Ă݂܂����i�b��j�B</li>
  <li>�g�ѓd�b�������F������悤�ɂ��܂����i���Ή��̋@�������ł��傤���j�B</li>
  <li>�X�V����ȂǂɑO�����̔�����RSS�ɔ��f����Ȃ��o�O���C�����܂����B</li>
  <li>���L�����[��ǉ����܂����B</li>
  <li>���̊J�n���@���O��ނ���I�ׂ�悤�ɂ��܂����B</li>
  <li>���̊J�n�{�^�����������ۂɊm�F��ʂ��o��悤�ɂ��܂����B</li>
  <li>�A���J�[�̏������Ԉ���Ă����̂��C�����܂����B</li>
  <li>�����Đl�����^�Ǘ��l�����ւ̃A���J�[�𒣂��悤�ɂ��܂����B</li>
  <li>�����o��{�^����ǉ����܂����B</li>
  <li>�����t�B���^�̑I����Ԃ��i���x�����jcookie �ɕۑ�����悤�ɂ��܂����B</li>
  <li>�����҂̔����񐔂Ǝc�蔭�����𔭌��t�B���^�ɕ\\������悤�ɂ��܂����B</li>
  <li>���̏��y�[�W��ǉ����܂����B</li>
  <li>QRcode Perl/CGI &amp; PHP scripts�iY.Swetake����j�ɑΉ����܂����i�b��j�B</li>
  <li>�u�b�̑����𑣂��v�@�\\��ǉ����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 30 (2006/07/09)</h3>
<ul>
  <li>�扺�̔������\\�������������Ȃ�o�O���C�����܂����B</li>
  <li>�l�T���P������u���܂����v�ɐݒ肵���ۂɕ\\�������B�����b�Z�[�W���u���܂����v�ɂȂ�Ȃ��o�O���C�����܂����B</li>
  <li>�v�����[�O�̓��ꔭ���i�Ƃ茾�^�����^�扺�j�ւ̃A���J�[�𒣂�Ȃ��悤�ɏC�����܂����B</li>
  <li>���̕ҏW���s���Ă��A�u���̈ꗗ�v�̑��̖��O�����X�V����Ȃ��o�O���ꉞ�C�����܂����B�b��ł����B</li>
  <li>�g�у��[�h�́u�݁v�i�ݒ�j�������܂����B�������Ȃ̂Ƀ����N��t�����܂܂������̂ŁB</li>
  <li>�g�у��[�h�Ŗ������ҕ\\�����\\������Ȃ��o�O���C�����܂����c�c���A���ꂢ��Ȃ����Ȃ��H</li>
  <li>�����҂�ǉ����܂����B����ɔ����A��E�z���Ɂu������^�v��ǉ����܂����B</li>
  <li>���M�҂�ǉ����܂����B����ɔ����A��E�z���Ɂu������^�v��ǉ����܂����B</li>
  <li>��E�z���̎��R�ݒ�@�\\��ǉ����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 29 (2006/07/07)</h3>
<ul>
  <li><del>�����t�B���^�̑I����Ԃ� cookie �ɕۑ�����悤�ɂ��܂����B</del>�Ђǂ����삾�����̂Œ�~���܂����B</li>
  <li>���̐ݒ��ύX���Ă��g�b�v�y�[�W�́u���̈ꗗ�v�ɔ��f����Ȃ��o�O���C�����܂����B</li>
  <li>�ʏ픭���ȊO�ł��������ł͂Ȃ��Ȃ�o�O���C�����܂����B</li>
  <li>�G�s���[�O�ő��l�ۗ̕��������������Ă��܂��o�O���C�����܂����B</li>
  <li>�_�u���N�H�[�e�[�V�������������̎Q�Ƃɕϊ�����Ȃ��o�O���C�����܂����B</li>
  <li>���̈ꗗ�̐l�������i�s���̎��ɐ������\\������Ȃ��o�O���C�����܂����B</li>
  <li>�����Đl�����ɎQ�����Ă��Ȃ��Ƒ��̕ҏW��J�n���ł��Ȃ��Ȃ�o�O���C�����܂����B</li>
  <li>�����Đl�����^�Ǘ��l�����@�\\��ǉ����܂����B</li>
  <li>�A�N�V�����ŃA���J�[���\\������Ȃ��o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 28 (2006/07/05)</h3>
<ul>
  <li>�Ƃ茾�̃A���J�[�p�ԍ����\\���ɂ������ŊԈႦ�đS�����̃A���J�[�p�ԍ����\\���ɂ��Ă��܂��Ă����o�O���C�����܂����B</li>
  <li>�X�V�����̍ۂɎ���X�V���������������Ȃ��ă����[�h���邽�тɍX�V���������Ă��܂�����o�O���C�����܂����B</li>
  <li>�ˑR����������������[�@�\\�ɑΉ����Ă��Ȃ��o�O���C�����܂����B</li>
  <li>favicon�����Ă݂܂����i���ʂȋ@�\\�ǉ��j�B</li>
  <li>�A���J�[�̎d�l�ύX�̂��߂�RSS�o�͂�����ɓ��삵�Ȃ��Ȃ��Ă����̂��C�����܂����B</li>
  <li>RSS�o�͂̏������A�ŐV�̔�������ԏ�ɗ���悤�ɂ��܂����B</li>
  <li>Internet Explorer �ő����O�̍ŉ��i��\\���������Ɣ����t�B���^�̔�\\���{�^���������ƕ\\�������������Ȃ�o�O���C�����܂����B</li>
  <li>�P�����₪�������鎞�̏P���挈����@�����������������̂������_���ɏC�����܂����B</li>
  <li>�i�s���i�G�s�˓��O�j�A�l�T���̃v���C���[���g�у��[�h�Œʏ픭�������悤�Ƃ���Ɣ����v���r���[���\\������Ă��܂��o�O���C�����܂����B</li>
  <li>�n���X�^�[�l�Ԃ�ǉ����܂����B</li>
  <li>���������������o�C�g�P�ʁi�l�T�R������j�̎��ɁA�s���̑������锭����؂�̂Ă��ɂ��̂܂܏�������ł��܂��o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 27 (2006/07/03)</h3>
<ul>
  <li>���̍쐬�^�ҏW��ʂɂ���u���̐����v����label�v�f�̏I���^�O���J�n�^�O�ɂȂ��Ă����̂ŏC�����܂����B</li>
  <li>PC���[�h�̚�������div�v�f����Ԉ���Ă����̂ŏC�����܂����B</li>
  <li>�g�у��[�h�Ń��X�A���J�[���S���\\������Ȃ������̂ŁA�������������Ƃ肠�����\\�������܂����B�܂������N�͒����܂���B</li>
  <li>�Ƃ������g�у��[�h�̓��삪���������ł��B�ł������C�͂����Ȃ��̂Łi����</li>
  <li>�Ƃ茾�̓��������ɖ�肪�������̂ŏC�����܂����B</li>
  <li>�b��ł��������t�B���^��g�ݍ��݂܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 26 (2006/07/02)</h3>
<ul>
  <li>���v�Ɋւ���T�u���[�`�����C���B</li>
  <li>�X�V�����̌v�Z�Ƀo�O���������̂��C���B</li>
  <li>�������񕜁i�`���[�W�j�@�\\�����܂����B��W���Ԃ��������ꂽ����A48h�^72h���ōX�V���ȊO�̍X�V�������}�������ɔ��������P�����ǉ�����܂��B</li>
  <li>48���ԍX�V���^72���ԍX�V���ɑΉ��i���Ԃ�j�B</li>
  <li>�A���J�[�p�̔ԍ����X�V����Ă��[���ɖ߂�Ȃ��o�O���C�����܂����B</li>
  <li>�c��̔��������[���ɂȂ�悤�Ȕ��������悤�Ƃ���Ɣ����ł����Ƀ����[�h���Ă��܂��o�O���C�����܂����B</li>
  <li>���X�A���J�[�𒣂��悤�ɂȂ�܂����B</li>
  <li>�v�����[�O�ł��Ƃ茾���g����悤�ɂȂ�܂����B</li>
  <li>�g�у��[�h���甭�����폜�ł��Ȃ��o�O���C�����܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 25 (2006/07/01)</h3>
<ul>
  <li>�G�s�Ō딚�h�~�`�F�b�N���o�Ȃ��悤�ɂ��܂����B</li>
  <li>�G�s�ł̎��l�̔����{�^���̃��x�����u���҂̂��߂��v����u�����v�ɕς��܂����B</li>
  <li>�G�s�Ŏ��҂��A�N�V�����̑Ώۂɏo�Ă��Ȃ��o�O���C�����܂����B</li>
  <li>�I���ς݂̑��ōX�V��������i�܂��͎蓮�R�~�b�g��������j�ƃG���[�\\�����o��o�O���C�����܂����B</li>
  <li>MWBBS�ɂ��G���[�\\���́u�g�b�v�y�[�W�ɖ߂�v���u�߂�v�ɕύX�BJavaScript�őO�̉�ʂɖ߂�܂��B</li>
  <li><del>�G���[</del>���O�o�͊֌W���������܂����B</li>
  <li>�X�V���Ƀ����_�����肳��鏉�����[��^�\\�͑ΏۂɁA���X�����⎀�l���I�΂�Ă��܂��o�O���C�����܂����B</li>
  <li>�G���g���[���ɑ����O�֖�E��]���������ނ悤�ɂȂ�܂����B�������G�s������܂Ŏ����ɂ����݂��܂���B</li>
  <li>���������[�^�\\�͑ΏەύX���ɑ����O�֏������ނ悤�ɂȂ�܂����B�������G�s������܂Ŏ����ɂ����݂��܂���B</li>
  <li>�G���g���[����ňӖ��s���ȃR�[�h�������Ă����̂Œ䓁�ł΂�����Ɨ��Ƃ��܂����i����j�B</li>
  <li>�����E���[����Ȃǂ��s������ɕ\\������ꏊ���ŉ��i����ŐV�����ɑւ��Ă݂܂����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 24 (2006/06/30)</h3>
<ul>
  <li>�t�@�C���h���C�o����̒n������������ƒ����܂����B</li>
  <li>��A�N�V�������o���Ȃ��悤�ɂ��܂����B</li>
  <li>�Ώۖ��I���̂ЂȌ`�����A�N�V�������o���Ȃ��悤�ɂ��܂����B</li>
  <li>��������A�N�V�������ւ��܂����i$sow->{'cfg'}->{'MAXSIZE_ACTION'}�o�C�g�ȓ��j</li>
  <li>RSS�o�͂�item�v�f��title�v�f�ɓ��������܂����B</li>
  <li>�X�V��񗓂�ǉ����܂����B</li>
  <li>���ƍׂ��������������ǖY�ꂽ�I�i�����j</li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

	return;
}

1;