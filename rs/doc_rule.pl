package SWDocRule;

#---------------------------------------------
# �֎~�s��
#---------------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;

   my @n_rule_name = (
		'�����͒����l�T�T�[�o�[���B�Z���͂ł��Ȃ��B',
		'���y�[�W�i�����j���n�ǂ���B',
		'���[�������A�˂ɐS�\���ɋC��z��B',
		'�i�s���́A�ǂ�ȉR�ł��n�j�B',
		'�������A�i�����Đl�j�A�i�Ǘ��l�j�̔����ł͉R�����Ȃ����ƁB',
		'�ˑR�������Ȃ��B',
   );
   @n_rule_name[5] = '' if ($sow->{'cfg'}->{'RULE'} eq 'RP');
   my @n_rule_text = (
		'�l�b�g��̐l�T�Q�[���̎�ނ́A<a href="http://crazy-crazy.sakura.ne.jp/giji/?(Knowledge)Guidance#l1">�����N����Q�l</a>�ɂ��悤�B�l�T�c���͒����l�T��V�ԏꏊ�Ȃ̂ŁA<a title=\"�P�O���Ƃ��A�T���Ƃ��B�c�c�Ђǂ��Ƃ��͂P�������B�N�[���I\">�Z���l�T</a>�ɂ͑Ή����Ă��Ȃ��B�A�N�Z�X���W������ƁA���̔����ĎE���i�ȁA���X���������������邩������Ȃ��񂾁B�Q�R���`�Q��(�Q�U��)�͈̔͂͗��p���W�����Ă���̂ŁA���ɂ��ԂȂ��B<br$net>���������V�т����ɂ́A�����Ƃӂ��킵��<a href="http://wolfbbs.jp/%BF%CD%CF%B5%A5%AF%A5%ED%A1%BC%A5%F3.html#content_1_18">�ʂ̏ꏊ</a>�����邩��A������Ŏv��������y���ނƂ����B',
		"�Q������������A�m��Ȃ������A�Y��Ă��A�̓i�V���B�����Ă���Ȃӂ��Ɍ����Ȃ��悤�A����₷�����[�������₷���ꏊ�ɋL�����B",
		"�����s���ȕ����A������������������A�����Ă��邱�Ƃ͂Ȃ��B�v�����[�O�̂����ɐϋɓI�ɖ₢�����Ė��炩�ɂ��Ă������B���[���ᔽ�Ŗ��f�������Ȃ�A�����Ȃ����悤�B�C�t���Ȃ������A�̓i�V���B",
		"",
		"�v�����[�O�I������G�s���[�O�J�n�܂ł��A�Q�[���̐i�s�����B���̊��Ԃ͑S���A�����̂��߂ɂ������i���u���Ă���B������A�����锭�����R��������Ȃ����A�R�Ǝ󂯎����\\��������񂾁B<br$net>�������v�����[�O�ƃG�s���[�O�����͓���ŁA���[�����̂��̂�����Ă�����ł���A���ׂĖ��炩�ɂȂ��Ă̔��ȉ�ł�����B�Ђ���Ƃ����烋�[���ᔽ�̎w�E�����邩������Ȃ��B������<a title=\"�z���g���߂�I�d�����I���Ȃ������񂾁I�Ƃ��A����������B\">�����߂Ǝv��ꂽ���Ȃ��咣</a>��{�C�ł������Ƃ��́A����̏��Ȃ��G�s���[�O�܂ő҂����m�����B<br$net>����̓Q�[�����y���ނ��߂̃��[��������ǁA�����Đl�ƁA�Ǘ��l�����͂���ł͍���񂾁B�ޓ�������ʂȔ�������������A�����ɉR��n�b�^���͊܂܂�Ă��Ȃ��B���s�����D�悷�邱�Ƃ𔭕\\������A�₢�������肷�邩��A�^�킸�ɕ����Ăق����B",
		"�ۈ���̂�������������؂��Ȃ��ƁA���̐l���͎���ł��܂��B���̂��Ƃ�ˑR���ƌĂ�ł���񂾁B<br$net>$sow->{'cfg'}->{'NAME_SW'}�͉�b���y���ރQ�[�������Ă��Ƃ��v���o���Ăق����B���ꂶ��A�Ȃ�̂��߂ɑ��ɎQ�������̂��A�킩��Ȃ���ˁB�����玀��ł��܂����Ƃɂ��Ă���B<br$net>��������ĂȂ��Ȃ�����Ȃ��Ƃ��A��������Q�[����D�悷��̂͂ƂĂ�������Ƃ��B������A�Q�[���̎��Ԃ��c��悤�ɁA�v�Z�������낢���ނƂ����B<br$net>�ˑR��������ƗL���ɂȂ�󋵂́A�悭�T���Ƃ��낲�낵�Ă�B����Ǒ_��Ȃ����ƁB����̓��[���ᔽ���B",
   );
   my @v_rule_name = (
		'���d���O�C�������Ȃ��B',
		'�V�X�e���̏o�͓��e���A���̂܂܏����ʂ��Ȃ��B',
		'�G�s���[�O�܂Ŕ閧�����B�Q�����̑��̓��e�͔閧���B',
		'�G�s���[�O�܂Ŕ閧�����B��]�����\�́A��ʂ����Ă��邫�݂����҂Ȃ̂��͔閧���B',
		'�G�s���[�O�܂ŏ�����ڎw���B',
   );
   @v_rule_name[4] = '' if ($sow->{'cfg'}->{'RULE'} eq 'RP');
   @v_rule_name[4] = '' if ($sow->{'cfg'}->{'RULE'} eq 'PRETENSE');
   @v_rule_name[4] = '' if ($sow->{'cfg'}->{'RULE'} eq 'PERJURY');
   my @v_rule_text = (
		"�܂�A�����l���������ɁA�����̃L�����N�^�[�ŎQ�����Ă͂����Ȃ��B����������A�ȒP�ɏ��Ă�`���������@�Ȃ񂾁B����Ȓ��x�̏���������܂�Ȃ�����H",
		"���݂Ȃ�̌��t�ŁA�`����ׂ����e���咣����񂾁B���̂ق����ʔ������A���݂̌��t��l�Ԃ̒Ԃ锭���Ƃ��ēǂ�ŖႦ��B�R���s���[�^�[�̃A�E�g�v�b�g�����I�N�e�b�g�X�g�����O�X�Ȃ񂩂ł͂Ȃ��ĂˁB<br$net>�����ēǂނƂ��ɂ��A�@�B���ۂ����m���ɗ���Ȃ����ƁB����ȍl���������������Ő�������������āA�N�̂����ɂ��ł��Ȃ��B",
		"���ݎ��g�̖�E�A�����̑��݁A����A�v�l���Ă��邱�ƂȂǁA���Ɋւ�邱�Ƃ𑺂̊O�Řb���Ă͂����Ȃ��B��O�����͂����A<a title=\"�v�����X�ƈ���āA�P�O�b�ȓ��ł��_���B\">�����O�Ő키</a>���ƁB",
		"�����̏��́A����I�ɗL���ɓ�������A�i�s���Ɏv�l��ώ��������肷��B�����m���Ă��邱�Ƃ͖Y��Ȃ��Ă��܂�Ȃ����A�ق��Ă邱�ƁB",
		"�N���ɋ}������������������낤�ƁA�N���ɒ��߂�ƍ�����悤�ƁA����ɑς��Ȃ����Ԋ��ꂪ���낤�ƁA���ݎ��g�ɏ����ڂ��܂������l���o���Ȃ��낤�ƁA���[�������A�����āA������ڎw�����ƁB����ȏ��s���[�������鑺�ł́A���̏�����ڎw���񂾁B<br$net>",
   );

   my @v_mind_name = (
		'���̃��[���́A�v�����[�O�I���܂łɎ�茈�߂悤�B',
		'�v�����[�O�ł́A���ɂӂ��킵���Ȃ��Ɗ������Q���҂�ǂ�������B',
		'�K�v�Ȃ�A�{���̍X�V��������̂΂���B',
		'���[���͑S�����������Ă�H�����łȂ��Ȃ�A�ǂ����悤�H',
		'���̑��̃������̒��x�ƕ������́H',
		'�L���Ȃǁi���A*�A[]�j�̈���������茈�߂�H���߂�Ȃ�ǂ����߂�H',
		'���������l�i����x�z������������j�̂��Љ�',
   );
   my @v_mind_text = (
		"�����ăt�H�[���ɂ͕W���I�ȃ��[�����ŏ�����L���Ă���B�^��������e�͂��̂܂܎c���A�s���Ȃ�M�������A�]���Ǝv�������[���͍폜���đ������Ă悤�B<br$net>�ꕔ�̍��ځi���̃��[���j�͕ҏW�ł��Ȃ��悤�ɂȂ��Ă�B����͕K�{�����ŁA�K�����Ȃ��Ă͂Ȃ�Ȃ�����Ȃ񂾁B���̃��[���ō��̃��[����ے肵�Ȃ����ƁB<br$net>�����Y��͂Ȃ����ȁH�P���ڂ��n�܂�ƎQ���҂ɖ�E�����A���\\�����čs�����n�߂�B�r���Ń��[���ɉ��M�E�C��������Ɨ\\������j�Z�ɂȂ�A����ł����ɂ��Ă��܂��������͌��ɖ߂�Ȃ��񂾁B",
		"�ł���Ȃ�΁A�ǂ��������_���ӂ��킵���Ȃ����������A���ȂƉ��P�𑣂����B�������C�������ʂ��āA�܂����Ƃ�������߂ĎQ�����Ȃ����ĖႦ��΍ō����B<br$net>����ȗ\\���������̂ɂ悭�l�����A���̂܂܊J�n����̂͂�߂Ă������B�����Ԃ��Ȃ��Ȃ��Ă���j�]���āA���l���܂ߊF���s�K���ɂȂ�B",
		"�ݐȍ���ȂЂƂɃ`�����X��^���A�S���ɍl���鎞�Ԃ������Ղ�^���邱�Ƃ��\\���B���̋@�\\�͂Q�x�܂Ŏg���邯��ǁA�R�����Ȃ��Ă����w�c�ɂƂ��ėL���ɓ����̂ŁA�T�d�Ɉ������ƁB�ŏ��ɗ\\�z���Ă����Q�[���o�����X�Ƃ́A����Ă��邾�낤�ˁB<br$net>�ǂ����������ԂɂȂ����炱�̋@�\\���g���̂��A�܂��A�@�\\�s�g�̃|���V�[��\\�ߕ\\�����Ă����邩�ǂ����A�l���Ă����Ƃ����B",
		"���[��������̂́A�����Ă�l���W�܂邩�炾�B���G�ȃ��[���������Ă��Ȃ��H�����݃i������\\���j�׃��e�@���i�ނ����������t�������ĂȂ��j�H���[���͌��₷���f�����Ă���H�^��ɂ������蓚�������Ă���H",
		"�u�������v�A�C�R���́A���������炩���߂�肽�����Ƃ�����΁A�����\\�����邽�߂ɂ���B<br$net>�����ǂ��݂̎v���̓A�C�R�������`��肫��Ȃ������ˁB�L�[�{�[�h�������Ǝg���āA���t�łƂ�������������ق������������I",
		"������ƈËL���Ă����ƕ֗��ȋL���̎g����������񂾁B�ڂ����l�ɕ����āA�C�ɓ�������g���Ă݂�Ƃ����B�������A��茈�߂ĂȂ��Ȃ�A�ق��Ă����Ȃ�g���Ă��������ĖႦ��Ƃ͎v��Ȃ����ƁB",
		"���������l�Ƃ����A���͂Ȗ���������񂾁B�ƂĂ����͂ȂS�̓���\\�͂�����B���[���ᔽ�ɂ��āA����������������s���Ƃ����������l������B�������A�ǂ̒��x�̔������ۂ��̂��\\�ߎ����Ă������B",
   );
   my @p_mind_name = (
		'����͉�b���y���ރQ�[�����B',
		'�L�����N�^�[��ʂ��Ĕ������悤�B',
		'������s���ɁA���܂��v���������߂�ꂽ�H',
		'������s���ɁA����ł��܂��c���ĂȂ��H',
		'�����������Ƃ������s�������H�����łȂ��Ȃ�A�Ȃ��H',
		'���݂ւ̘_�]�ɔ��_����H����Ƃ��󂯓����H����͂Ȃ�̂��߁H',
		'���̉R�A�ق�ƁH',
		'�Q�����Ԃ͂��D�݂ŁB',
		'���̑������ׂĂƂ����p�����т����B',
		'�\�͂ɂ͊��҂�������B�󂯎~�߂���邩�ȁH',
		'�����ɂ͊��҂�������B�󂯎~�߂���邩�ȁH',
		'�y�����Q���ł����H',
		'���������N�ł���ꂽ�H',
   );
   my @p_mind_text = (
		"���݂̉�b���e�͕]�������B��^����邱�Ƃ��A���]����邱�Ƃ����邾�낤�ˁB",
		"��������ʂ����Ă��邫�ݎ��g�����t��Ԃ肽���Ȃ����Ȃ�A������Ɨ��������Ă݂悤�B�ق�Ƃ��ɂ��̌��t�́A�L�����N�^�[�ł͌��ɂł��Ȃ����Ƃ��ȁH<br$net>�����āA���������čl���Ă����̌��t���K�v���Ɣ��f������A�����S�O��Ȃ��Ă����B",
		"���݈ȊO�̎Q���҂ɂ��A���d�����ׂ��l�i������B�ޓ��͌h�ӂ��󂯂�ׂ����B����͖����Ɍ��炸�A���̑��̃��C�o�������ɂ��������ˁB���݂̘r�O�̌����ǂ��낾�B<br$net>�����A�L�����N�^�[���L�����N�^�[�Ɍh�ӂ𕥂����A���d���邩�͂����R�ɁB",
		"�a�m�E�i���ł��悤�B���݂������ɂ���̂́A���͂Ɏh�X������ŋC���΂�܂����߂ł͂Ȃ������͂����B",
		"�X�V�܂ł̎��Ԃ┭���́A�ƂĂ������Ă���B�v����肪�s�\\����������A�h�X������ŋC���c���Ă��܂����Ƃ��Ă��A�����ɍl�����Ȃ��ނ𓾂Ȃ��B�������g�̖��n����F�߂Ĕ����{�^�����������B",
		"�����̕]�������݂Ɍ�������B�ǂ��Ή�����̂��ŁA���݂͖����ɂ��A�G�ɂ��A���������A��Ȃ��������邾�낤�ˁB�����̂��݂́A���͂���ǂ�������ƍD�s�����낤�B",
		"���t�͂ǂ���R��������Ȃ����A�{����������Ȃ��B�����Ă������t�������Ă��邩������Ȃ��B�ǂ�����Č��ɂ߂悤�H�ǂ����Č��ɂ߂���Ȃ��񂾂낤�H",
		"���݂��D�ގ��ԂɎQ���������̂Ɠ��l�ɁA���̓����҂��D�ގ��ԂɎQ���������B���āA�ǂ�����ė��������悤���H",
		"�������C���΂�Ă��܂��ƁA�߂������ƂɂȂ�B�F�������A���݂͐M�p�������B�������ǂ��ł���A�|�������ŕʑ��ɂ����A���̌�y�Ɍ��𔲂����Ă����A�ȂǂƔ��󂵂Ȃ����ƁB���Ƃ��������ǋy�ɂ����Ă��A�����؂�ق��������B<br$net>�ŏ����畂�C���Ȃ����@�́A�����ł�����_�łƂĂ����͂Ȗh�q��i�ɂȂ�B",
		"���[�A�肢�A�P���A���Aetc...�B�����̔\\�͂����Ăɂ��āA�F�����𗧂Ă��茈�f�������肷��B���ɓ��[��肢�ł́A�͂�����Ɨv�]����邱�Ƃ��������Ȃ��B�����̗v���ɁA���݂͉�������邾�낤���B�܂��A��������Ȃ��Ȃ�A�ǂ������炢�����낤�B",
		"�܂Ƃߖ��A��ECO�A�������Ȃ��D�Aetc...�B�����������������܂��Ă���ƁA�ǂ��U�镑�������҂���͂��߂�񂾁B�����c���ł��Ă��邩�ȁB�킩��Ȃ��Ȃ�A�ǂ�����Ēm���Ă������B�����āA���݂͊��҂ɉ�������邾�낤���B",
		"�y�������A�����A�f�G�ȂЂƂƂ����߂������낤���B�܂��A���l�Ɋy���݂����ƏW�܂��Ă��鑺�̗F�l�B�͊y���߂Ă��邾�낤���B�c�O�ɂ������łȂ��Ƃ�����A�ǂ�������y�����Ȃ邾�낤�B",
		"���N���ێ�����̂͂ƂĂ���ςȂ��Ƃ��B�����̂��݂͂�萋�������낤���B���̃Q�[�����y���ނ��Ƃ��������ɂȂ��āA���N���Q���Ă��܂��Ă͂܂�Ȃ��ˁB",
   );

   my %n_rule = (
   	name => \@n_rule_name,
   	text => \@n_rule_text,
   );
   my %v_rule = (
   	name => \@v_rule_name,
   	text => \@v_rule_text,
   );
   my %v_mind = (
   	name => \@v_mind_name,
   	text => \@v_mind_text,
   );
   my %p_mind = (
   	name => \@p_mind_name,
   	text => \@p_mind_text,
   );

	my $self = {
		sow   => $sow,
		title => '���[��', # �^�C�g��
		n_rule => \%n_rule,
		v_rule => \%v_rule,
		v_mind => \%v_mind,
		p_mind => \%p_mind,
	};

	return bless($self, $class);
}

#---------------------------------------------
# �֎~�s�ׁi�ȗ��j
# �^�c�҂��K�����������ĉ������B
#---------------------------------------------
sub outhtmlsimple {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $docid = "css=$sow->{'query'}->{'css'}&trsid=$sow->{'query'}->{'trsid'}";

	$reqvals->{'cmd'} = 'rule';
	$reqvals->{'css'} = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
	my $url_rule = &SWBase::GetLinkValues($sow, $reqvals);
	$url_rule = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$url_rule";
	my $url_mind = "$url_rule#mind";
	my $url_make = "$url_rule#make";
}

#---------------------------------------------
# ���[���ƐS�\���i�ڍׁj
# �^�c�҂��K�����������ĉ������B
#---------------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	my $nrule = $self->{'n_rule'};
	my $vrule = $self->{'v_rule'};
	my $vmind = $self->{'v_mind'};
	my $pmind = $self->{'p_mind'};
	print <<"_HTML_";
<script>
gon = {};
gon.welcome = [
{ mesicon:'',
  name:'�w�� ���I�i���h',
  text:'�悤�����B�����ɂ͂��̃T�C�g���y���ނ��߂̃��[����S�\\����Ԃ��Ă���B\\
�g�F�̂��΂��J���Ă��邩��A�������낵�ďn�ǂ��悤�B�y�����Q�[���͑S�����Γ��ŁA�S�����ǂ�ŗ������Ă��郋�[���������Đ��藧�񂾁B<br>\\
<br>\\
�������A��ނ𓾂��A���[���ᔽ�����邱�Ƃ����邾�낤�ˁB�ᔽ���Ă��܂��������͕���Ȃ�����ǁA���[����j�炴������Ȃ���������́A���������ĕ����Ă����悤�B\\
<a class="mark" href="http://www.nihonjiten.com/data/763.html">�߂𑞂�ŁA�l�𑞂܂��B</a>\\
����͘b������������Q�[���Ȃ񂾁B<br>\\
<br>\\
<a title="�@�Ă�A��Ƃ̎���K���ɏ]���K�v�͂Ȃ��B�t�炤�K�v���Ȃ��B����������݂̂��΂̏\\���l�̂��߂��v�����B">���̃T�C�g�͓��{���̖@���ɏ]���Ă���</a>�B\\
���ɂ����ŁA�Z�@�S���������ʂ��đދ��Ȏv�����������͂Ȃ�����ǁA�s���A�N�Z�X�֎~�@�A�l���ی�@�͊ւ�肪�[���͂����B<br>',
updated_at:new Date(1370662886000),template:"message/say",style:"",mestype:"GSAY",csid:"all",face_id:"c96"}
];
gon.recovery = [
{ mesicon:'',
  name:'�w�� ���I�i���h',
  text:'�����A���[���Ɉᔽ���Ă��܂����Ƃ�����H�ƂĂ��c�O�Ȃ��Ƃ�����ǁA�܂���]���Ȃ��Ă����B<br>\\
<br>\\
���݂ɂ͑S���Ɏߖ�����A�M�d�ȋ@��c����Ă���񂾁B�V�тɏW�܂����F���΂������ĉ��U���邽�߂ɁA�E�C�𕱂��ăG�s���[�O�Ɋ���o���Ă����B<br><br>\\
�^���Șb���������K�v�ȂƂ��́A���͂��Ă��̂��߂̎��Ԃ��Ȃ�Ƃ��P��o���Ăق����B\\
�ƂɋA��܂ł������Ȃ̂Ɠ����ŁA�G�s���[�O���ςނ܂ł����̑��Ȃ񂾁B',
updated_at:new Date(1370662886000),template:"message/say",style:"",mestype:"GSAY",csid:"all",face_id:"c96"},
{ mesicon:'',
  name:'���P������ �A�J��',
  text:'�ˑR���͈��I�����ł���ː搶�I',
updated_at:new Date(1370662886000),template:"message/say",mestype:"GSAY",csid:"all",face_id:"t07",style:"head"},
{ mesicon:'',
  name:'�w�� ���I�i���h',
  text:'�����A���̃��[�����ˁB<br>\\
<br>\\
�����A��ނ𓾂Ȃ�������邩������Ȃ��B�l�T�c���ł́A�P���Ԕ������Ȃ��ꍇ�ɂ͓ˑR���Ƃ���[�u�ƁA�Q�[���s�Q�������Ƃ���[�u���Ƃ��Ă���B���̔����ȏ�ɏd��Ȃ��Ƃ��ǂ����A��Âɍl���Ăق����B<br>\\
���̃��[���ᔽ�ł�����������ǁA�G�s���[�O�Ȃǂ������Ęb�𕷂��Ă݂�Ƃ悢�ˁB<br><br>\\
�G�s���[�O�ł͑S�����ꓯ�ɉ�A�扺�ƒn��ɂ킩��邱�ƂȂ��A�����߂̉R���Ȃ��A��藦���Șb���ł���B<br>\\
�l��͗V�тɗ��Ă���񂾁B�΂������ĉ��U�ł��邱�Ƃ�ڎw���A����΂��Ăق����B<br><br>\\
�ˑR���Ɍ��炸�A���[���ᔽ�S�ʂɌ����邱�Ƃ��ˁB',
updated_at:new Date(1370662886000),template:"message/say",style:"",mestype:"GSAY",csid:"all",face_id:"c96"},
];
gon.create = [
{ mesicon:'',
  name:'�c�����{ �g���C��',
  text:'�����ăt�H�[���ɂ́A���̃��[�������ɋL�����Ă���܂��B<br>\\
�^���ł�����e�͂��̂܂܎c���āA�s���Ȃ�M�������A�]���Ɣ��f���鎖���͍폜���đ������ĂĂ��������B<br>\\
<br>\\
�������Ă�Ƃ��C������Ɨǂ����Ƃ�S�\\���ɓZ�߂܂����B<br>\\
���Ђ������������B',
updated_at:new Date(1370662886000),template:"message/say",style:"",mestype:"GSAY",csid:"all",face_id:"t10"}
];
</script>
<h2>�����͂������ȁH</h2>
<div class="message_filter" ng-repeat="message in welcome" log="message"></div>
<DIV class=toppage>

<p class="paragraph">
<h2>���[��</h2>
<p class="paragraph">
���ɏ����Ă��������[���̏ڍׂ��m�肽����΁A�������牺��ǂ����B<br$net>
<br$net>
</p>
<h3><a name="nation">���̃��[��</a></h3>
<p class="paragraph">
<dl class="accordion">
_HTML_
	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		my $text = $nrule->{'text'}->[$i];
	print <<"_HTML_";
<dt><strong>$name</strong></dt>
<dd>$text</dd>
_HTML_
	}
	print <<"_HTML_";
</dl>
</p>
<hr class="invisible_hr"$net>
<h3><a name="village">���̃��[��</a></h3>
<p class="paragraph">
<dl class="accordion">
_HTML_
	$list = $vrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $vrule->{'name'}->[$i];
		my $text = $vrule->{'text'}->[$i];
	print <<"_HTML_";
<dt><strong>$name</strong></dt>
<dd>$text</dd>
_HTML_
	}
	print <<"_HTML_";
</dl>
</p>


<hr class="invisible_hr"$net>
<h2>���[���ᔽ����������H</h2>

<dl class="accordion">
<dt> <span class="mark"> &#x2718; </span>

<dt> <span class="mark"> �J�� </span>
<dd class="plain">
<div class="message_filter" ng-repeat="message in recovery" log="message"></div>
</dl>

<hr class="invisible_hr"$net>
<h2><a name="mind">�S�\\��</a></h2>
<p class="paragraph">
�S�\\��������āA�y�����A�����V�ڂ��B<br$net>
</p>
<p class="paragraph">
<dl class="accordion">
_HTML_
	$list = $pmind->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $pmind->{'name'}->[$i];
		my $text = $pmind->{'text'}->[$i];
	print <<"_HTML_";
<dt><strong>$name</strong></dt>
<dd>$text</dd>
_HTML_
	}
	print <<"_HTML_";
</dl>
</p>
<hr class="invisible_hr"$net>
<h2><a name="make">$sow->{'cfg'}->{'NAME_SW'}�̉^�c</a></h2>
<h3>�������Ă邩����</h3>
<div class="message_filter" ng-repeat="message in create" log="message"></div>
<hr class="invisible_hr"$net>
<h3>�����Đl�̐S�\\��</h3>
<p class="paragraph">
<dl class="accordion">
_HTML_
	$list = $vmind->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $vmind->{'name'}->[$i];
		my $text = $vmind->{'text'}->[$i];
	print <<"_HTML_";
<dt><strong>$name</strong></dt>
<dd>$text</dd>
_HTML_
	}
	print <<"_HTML_";
</dl>
</p>
</DIV>
_HTML_

}

#---------------------------------------------
# ���[���ƐS�\���i�ڍׁj
# �^�c�҂��K�����������ĉ������B
#---------------------------------------------
sub outhtmlmb {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	my $nrule = $self->{'n_rule'};
	my $vrule = $self->{'v_rule'};
	my $vmind = $self->{'v_mind'};
	my $pmind = $self->{'p_mind'};
	print <<"_HTML_";
<DIV class=toppage>
<h2>�����͂������ȁH</h2>
<p class="paragraph">
�悤�����B�����ɂ͂��̃T�C�g�Ŋy���ނ��߂̃��[����S�\\����Ԃ��Ă���B�g�F�̂��΂��J���Ă��邩��A�������낵�ďn�ǂ��悤�B�y�����Q�[���͑S�����Γ��ŁA�S�����ǂ�ŗ������Ă��郋�[���������Đ��藧�񂾁B<br$net>
<br$net></p>
<p class="paragraph">
�������A��ނ𓾂��A���[���ᔽ�����邱�Ƃ����邾�낤�ˁB�ᔽ���Ă��܂��������͕���Ȃ�����ǁA���[����j�炴������Ȃ���������́A���������ĕ����Ă����悤�B<a href="http://www.nihonjiten.com/data/763.html">�߂𑞂�ŁA�l�𑞂܂��B</a>����͘b������������Q�[���Ȃ񂾁B<br$net>
</p>
<p class="paragraph">
<a title="�@�Ă�A��Ƃ̎���K���ɏ]���K�v�͂Ȃ��B�t�炤�K�v���Ȃ��B����������݂̂��΂̏\\���l�̂��߂��v�����B">���̃T�C�g�͓��{���̖@���ɏ]���Ă���</a>�B���ɂ����ŁA�Z�@�S���������ʂ��đދ��Ȏv�����������͂Ȃ�����ǁA�s���A�N�Z�X�֎~�@�A�l���ی�@�͊ւ�肪�[���͂����B<br$net>
<br$net></p>
<p class="paragraph">
<h2>���[��</h2>
<p class="paragraph">
���ɏ����Ă��������[���̏ڍׂ��m�肽����΁A�������牺��ǂ����B<br$net>
<br$net>
</p>
<h3><a name="nation">���̃��[��</a></h3>
<p class="paragraph">
<dl class="accordion">
_HTML_
	$list = $nrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $nrule->{'name'}->[$i];
		my $text = $nrule->{'text'}->[$i];
	print <<"_HTML_";
<dt><strong>$name</strong></dt>
<dd>$text</dd>
_HTML_
	}
	print <<"_HTML_";
</dl>
</p>
<hr class="invisible_hr"$net>
<h3><a name="village">���̃��[��</a></h3>
<p class="paragraph">
<dl class="accordion">
_HTML_
	$list = $vrule->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $vrule->{'name'}->[$i];
		my $text = $vrule->{'text'}->[$i];
	print <<"_HTML_";
<dt><strong>$name</strong></dt>
<dd>$text</dd>
_HTML_
	}
	print <<"_HTML_";
</dl>
</p>
<hr class="invisible_hr"$net>
<h2>���[���ᔽ����������H</h2>
<p class="paragraph">
���������[���Ɉᔽ���Ă��܂����Ƃ�����H�ƂĂ��c�O�Ȃ��Ƃ�����ǁA�܂���]���Ȃ��Ă����B<br$net>
���݂ɂ͑S���Ɏߖ�����A�M�d�ȋ@��c����Ă���񂾁B�G�s���[�O�ł͑S�����ꓯ�ɉ�A�扺�ƒn��ɂ킩��邱�ƂȂ��A�����߂̉R���Ȃ��A��藦���Șb���ł���B<br$net>
�^���Șb���������K�v�ȂƂ��́A���͂��Ă��̂��߂̎��Ԃ��Ȃ�Ƃ��P��o���Ăق����B�ƂɋA��܂ł������Ȃ̂Ɠ����ŁA�G�s���[�O���ςނ܂ł����̑��Ȃ񂾁B<br$net>
<br$net>
</p>
<hr class="invisible_hr"$net>
<h2><a name="mind">�S�\\��</a></h2>
<p class="paragraph">
�S�\\��������āA�y�����A�����V�ڂ��B<br$net>
</p>
<p class="paragraph">
<dl class="accordion">
_HTML_
	$list = $pmind->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $pmind->{'name'}->[$i];
		my $text = $pmind->{'text'}->[$i];
	print <<"_HTML_";
<dt><strong>$name</strong></dt>
<dd>$text</dd>
_HTML_
	}
	print <<"_HTML_";
</dl>
</p>
<hr class="invisible_hr"$net>
<h2><a name="make">$sow->{'cfg'}->{'NAME_SW'}�̉^�c</a></h2>
<h3>�������Ă邩����</h3>
<p class="paragraph">
�����ăt�H�[���ɂ́A���̃��[�������ɋL�����Ă���܂��B�^���ł�����e�͂��̂܂܎c���āA�s���Ȃ�M�������A�]���Ɣ��f���鎖���͍폜���đ������ĂĂ��������B<br$net>
�������Ă�Ƃ��ɋC�����������ǂ����Ƃ��A�S�\\���ɓZ�߂܂����B���Ђ������������B<br$net>
<br$net>
</p>
<hr class="invisible_hr"$net>
<h3>�����Đl�̐S�\\��</h3>
<p class="paragraph">
<dl class="accordion">
_HTML_
	$list = $vmind->{'name'};
	for( $i=0; $i<@$list; $i++ ){
		next if ( '' eq $list->[$i] );
		my $name = $vmind->{'name'}->[$i];
		my $text = $vmind->{'text'}->[$i];
	print <<"_HTML_";
<dt><strong>$name</strong></dt>
<dd>$text</dd>
_HTML_
	}
	print <<"_HTML_";
</dl>
</p>
</DIV>
_HTML_

}

1;
