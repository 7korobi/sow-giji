package SWDocSpec;

#----------------------------------------
# �d�lFAQ
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => "���̐l�T�N���[���Ƃ̈Ⴂ�i�d�lFAQ�j", # �^�C�g��
	};

	return bless($self, $class);
}

#----------------------------------------
# �d�lFAQ�̕\��
#----------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg = $sow->{'cfg'};

	print <<"_HTML_";
<DIV class=toppage>
<h2>���̐l�T�N���[���Ƃ̈Ⴂ�i�d�lFAQ�j</h2>
<p class="paragraph">
�������ł͐l�T�N���[���ɂ���Ė��O�̈قȂ��E�ɂ��āA�ȉ��̂悤�ɕ\\�L���܂��B
</p>
<ul>
  <li>��l�^���� �� ����</li>
  <li>���L�ҁ^���Ј� �� ���L��</li>
  <li>�n���X�^�[�l�ԁ^�d���^�d�� �� �d��</li>
</ul>
<hr class="invisible_hr"$net>

<h3>�ڎ�</h3>
<ul>
  <li><a href="#diff_wbbs">�l�TBBS�Ƃ̑�܂��ȈႢ</a></li>
  <li><a href="#diff_juna">�l�T�R��Ƃ̑�܂��ȈႢ</a></li>
  <li><a href="#update">���Y��肢�Ȃǂ̏������͂ǂ��Ȃ��Ă��܂����H</a></li>
  <li><a href="#curseandkillseer">���̑��̋^��</a></li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="diff_wbbs">�l�TBBS�Ƃ̑�܂��ȈႢ</a></h3>
<ul>
  <li>�A�N�V�����E�����@�\\���g���܂��B</li>
  <li>���p�ɕ֗��ȃA���J�[�i>>0:0 �Ƃ��j���g���܂��B</li>
  <li>�X�V�̑O�|���i�u���Ԃ�i�߂�v�A�R�~�b�g�Ƃ������j���g���܂��B</li>
  <li>���������Ő�������܂���B�v���C���[�������ŗV�т��������쐬���Ă��������B</li>
  <li>�^�u���̐l�T�A�ȊO�̊y���ݕ���I�Ԃ��Ƃ��ł��܂��B</li>
  <li>���[�����Ƃ��Ė��L�����[����������܂��i���[CO���ł��Ȃ��Ȃ�܂��j�B</li>
  <li>�N���ɓ��[����ϔC���邱�Ƃ��ł��܂��B</li>
  <li>�����t�B���^��g�у��[�h������܂��B</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="diff_juna">�l�T�R��Ƃ̑�܂��ȈႢ</a></h3>
<ul>
  <li>���������Ő�������܂���B�J�X�^�����݂̂ł��B</li>
  <li>�^�u���̐l�T�A�ȊO�̊y���ݕ���I�Ԃ��Ƃ��ł��܂��B</li>
  <li>�ˑR���ʒm�@�\\������܂���B</li>
  <li>�ˑR���D�揈�Y�@�\\������܂���B</li>
  <li>�Q�����@�������ɈႢ�܂��B�E��Łu���O�C���v������A���̃y�[�W��\\������ƎQ�������\\������܂��B</li>
  <li>����ɂ̓_�~�[�L�����i�l�T�R��ł����A�[���@�C���j�̐l�����܂݂܂��i�l�T�R���15�l����$sow->{'cfg'}->{'NAME_SW'}�ł�16�l���j�B</li>
  <li>�A�N�V�����̑ΏۂɃ_�~�[�L�������܂܂�܂��B</li>
  <li>�肢��Ə��Y�悪�����������ꍇ�ł��肤�����ł��܂��B</li>
  <li>�肢�E��\\�Ȃǂ̔��茋�ʂ̓��O�̏㕔�ł͂Ȃ��\\�͎җ��i�������͗��̉��j�ɕ\\������܂��B</li>
  <li>���l�̑����ӎu�ɂ��p���͂ł��܂���B</li>
  <li>�u�p�X�v�ɂ��Ӑ}�I�s�P���A�Ӑ}�I��\�\\�͂̕s�s�g���ł��܂��B</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="update">���Y��肢�Ȃǂ̏������͂ǂ��Ȃ��Ă��܂����H</a></h3>
<p class="paragraph">
���L�̒ʂ�ł��B
</p>

<ol><li>��̏���</li>
    <ol><li>��������������B</li>
    </ol>
    <li>�ˑR���̏���</li>
    <li>�i�u�����_���v���w�肵��\�\\�͂̈�������j</li>
    <li>���Y</li>
    <ol><li>�J�[�A�ϔC�A����҂̒ǉ��[</li>
        <li>Sir Cointoss �ɂ��̔�</li>
        <li>�������A���т����Y</li>
    </ol>
    <li>������</li>
    <ol><li>�����̏���</li>
        <li>�_�b�}�j�A�̏���</li>
        <li>�����̏���</li>
        <li>�l���̏���</li>
        <li>�J�����̏���</li>
        <li>�L���[�s�b�h�̏���</li>
        <li>���̗ւ̏���</li>
    </ol>
    <li>��qor�ז��Ώی���</li>
    <li>�锼</li>
    <ol><li>��\\�҂̏���</li>
        <li>�肢�t�̏���</li>
        <li>�����̏���</li>
        <li>�B���p�t�̏���</li>
    </ol>
    <li>�P��</li>
    <ol><li>�P���挈��</li>
        <li>�l�T�B�ɂ��P��</li>
        <li>��C�T�ɂ��P��</li>
    </ol>
    <li>�t��</li>
    <ol><li>�\\�����ꂽ���̏���</li>
        <li>�h�ؗd���̏���</li>
    </ol>
    <li>�閾��</li>
    <ol><li>�؋��l�����˂�</li>
        <li>��ǂ��A���A�ꏈ��</li>
        <li>�e�T�̎��𔭌�</li>
        <li>��Ƃ̎��𔭌�</li>
    </ol>
    <li>��������</li>
    <li>�����̊J�n</li>
    <ol><li>�ȑO�̎����̎���</li>
        <li><a href="sow.cgi?cmd=howto#event">����</a>�̔���</li>
        <li>�������[��̐ݒ�</li>
    </ol>
    
</ol>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">�肢�t���d����肢��ɂ�����ԂŏP�����ꂽ�ꍇ�A�d������E�ł��܂����H</a></h3>
<p class="paragraph">
�ł��܂��B
</p>
<p class="paragraph">
<a href="#update">�X�V���̏�����</a>�ɂ���ʂ�A�P������������E����̕�����ɏ��������̂ŁA�肢�t���P���Ŏ��S����O�ɗd������E�ɂ�莀�S���܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">�肢�t�́A���Y���肦�܂����H</a></h3>
<p class="paragraph">
�ł��܂��B
</p>
<p class="paragraph">
�肢�́A�Ώۂ̐����ɂ�����炸���{���܂��B���[�ɂ���Ċ��ɏ��Y���ꂽ�Ώۂ�A�ʂ̐肢�t�ɐ�ɐ���Ď�E���ꂽ�d�������Ă��A���Ȃ��肢���ʂ𓾂��܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">�b�����đ�������Ȃ���ˁH</a></h3>
<p class="paragraph">
�������A�����Ő����Ă��܂��B
�������l���b�����l�A�́A�l�T�Ƒ��k�ł��܂��B����������Ȃ��̂ŁA�����T�̂Ƃ��Ȃǂ͊m���ɘT�����ɂȂ�A�l�T�a�a�r�ł͂���𗝗R�ɁA���̎��_�ŃG�s���[�O�ɓ˓����Ă��܂��B���̓`���͑嗐���ł́A�d��������Ƃ��A��������������Đ����c���Ă���Ƃ��A�܋��҂�������Ƃ��A�ȂǁA�����̃p�^�[���Ő��藧���Ȃ����̂Ȃ̂ŁA�p�~���Ă��܂��B
�Ȃ��A�l�T�c���̑c��ł��镨��n�ł́A�b�����l�̓���͂a�a�r�݊��ł��B�������A��O���͂�����Ƃ��͐l�Ԃƈ����܂��B
</p>

<h3><a $atr_id="curseandkillseer">���̗ւ𑺑��ȊO�������Ƃ͂���܂����H</a></h3>
<p class="paragraph">
����܂���B�l�T�⋶�l��d���́A���̗ւ��ŏ��ɔz�z���ꂽ�Ƃ��ƁA���̗ւ�n���ꂽ�Ƃ��ɔj�󂵂܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">�����͂��܂ŗL���Ȃ́H</a></h3>
<p class="paragraph">
���������������ƁA���̌�̖邪������܂łł��B�c���^�̕ω��Ȃǂ͓����̂��̂��A\�\\�͂̍s�g�Ȃǂ͗����̂��̂��e�����ɂ���܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">\�\\�͂������Ƃǂ��Ȃ�́H</a></h3>
<p class="paragraph">
����������g���ʂ����A�l�T�̑�\\���a�l�Ⓑ�V���P���A��Ղ̂������Ő����Ԃ�A�Ȃǂ̗��R��\�\\�͂��������Ƃ�����܂��B
���Ƃ��Η�\\�҂̈��S���a�l���P���ƁA���Y�Ώۂ̔�������邱�Ƃ��ł����A�P���ɎQ�����邱�Ƃ��ł��܂���B�������A�����Ȃǂ̓��ꔭ���͂̂���܂��B
�V�ƒn�Ɍ�������A�l�Ƙb��\�\\�͈ȊO�����グ���Ă��܂��̂ł��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">\�\\�͂������Ă��A��g��\�\\�͎͂c���ˁH</a></h3>
<p class="paragraph">
�c�O�B��\�\\�͂Ȃǂ͑Ώۂ��w������\�\\�͂ł͂���܂��񂪁A\�\\�͂��������l���ɂ͂����^�����܂���B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">�T�������āA�{���ɐ��ꂽ�̂�����́H</a></h3>
<p class="paragraph">
���ꂽ�Ƃ������o��V�X�e�����b�Z�[�W�ŁA���ꂽ���A�肤�ƌ����Đ���Ȃ�������������܂��B�����肢�悪���ꂳ��Ă��Ȃ��Ɓc�c�B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">�����̏������ĂȂɁH</a></h3>
<p class="paragraph">
�����͖�ɂȂ�O�ɑh���򂩓Ŗ���������܂��B���̌㏈�Y�A�P���A��E�Ȃǂ̎���őΏۂ�����ł��܂��ƁA���͂⏀�����Ă��܂�����𖳑ʂɂ��Ă��܂����ƂɂȂ�܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">�J�̂���Ǐ]�҂́A�l���n���̂Ƃ��ɂǂ��Ȃ�́H</a></h3>
<p class="paragraph">
�������ł��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">���Ⴀ�A���т����ꂩ���w�����Ă�Ƃ��̒Ǐ]�҂́H</a></h3>
<p class="paragraph">
�������ł��B/:-�j
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="atkhamster">�d�����P���ΏۂƂȂ����ꍇ�A�d���͎������P�����ꂽ�����킩��܂����H</a></h3>
<p class="paragraph">
�킩��܂���B<br$net>
�d�����P������Ă��A�d���ɂ͎������P��ꂽ���͂킩��܂��񂵁A�d���P���Ǝ��҂̌�q�����Ƃ̌��������t���܂���B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">�������ϐg���āA�G�s���[�O�ɂȂ���������肵�āc�c</a></h3>
<p class="paragraph">
�����́A���������Ă��܂���E������āA�ϐg���I�т܂��B�Ƃ͂����A�ǂ��I��ł��I�����Ă��܂��ꍇ�͂�����߂đ��ɂƂǂ߂��h���܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">��q���肵���悪��q��������ł�����ǁA�ǂ��Ȃ�́H</a></h3>
<p class="paragraph">
���Ȃ��̎t��������ɒ�q���肷�邩�ɂ��܂��B���Ȃ��͑���q�Ƃ��āA�t���̎t���Ɠ�����E�ɂȂ�A�t�����J�����т܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">��������̌��̗ւ��A�ЂƂ�ɏW�߂�ƁH</a></h3>
<p class="paragraph">
���̗ւ͂ЂƂɓZ�܂�A���ɒN���ɓn���Ƃ����ЂƂ̂܂܂ł��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">�l�T�����҂��P���Ώۂɂ��Ă����ꍇ�A�l�T�ɂ͏P�����ɂ��̐l��������ł��������킩��܂����H</a></h3>
<p class="paragraph">
�킩��܂��B
</p>
<p class="paragraph">
�l�T���P������O�ɏP���Ώۂ����S���Ă����ꍇ�A�P�����L�����Z������P�����b�Z�[�W�i�u�`�I ���������O�̖������I�v�j���\\������Ȃ��Ȃ�܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">��V�т��Ă������������|�������Ƃ��A�P���͂ǂ��Ȃ�H</a></h3>
<p class="paragraph">
�������������������J�҂́A�P����]�����̂ƂȂ�̂ŏP���ɎQ�����܂���B�ق��ɐl�T������΁A�ޓ������ŏP���𑱍s���܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">�S��̎������������Ƃ��A��ǂ��Ȃǂ̓��ꏈ���́H</a></h3>
<p class="paragraph">
�Ώۂ��l�T�ɕϐg����Ƃ��A�P���ґ�\�҂��P����\\�҂��E�����A�ƈ����܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">�S��̎������������Ƃ��A�P����\\�ɂȂ��Ď���ł������T�͂ǂ��Ȃ�H</a></h3>
<p class="paragraph">
���̖�E�̂܂ܕ�ɂ͂���܂��B�T�w�c�����ɂȂ�΁A�����c��̒��Ԃ����Ə����𕪂����������Ƃ��ł���ł��傤�B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">���҂���q���������ꍇ�A�艞���������܂����H</a></h3>
<p class="paragraph">
�����܂��B
</p>
<p class="paragraph">
���҂͌�q�ɐ�������ƁA�u�`��l�T�̏P�����������v�̂悤�Ȉꕶ���\\�͗��ɒǋL����܂��B�����ǋL����Ă��Ȃ���΁A�l�T�͎��҂���q���Ă����l�����P���Ă��Ȃ������Ƃ������ɂȂ�܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">�a���҂╗�ԗd�������ʂ̂��Ă��H</a></h3>
<p class="paragraph">
�u�������l�T�̐l���̓����v�Ƃ���܂����A���t�͖�ɐi��ł��܂��B�����A����ڂ̋c�_�����Ă���Œ��Ȃ�A�O���ڂɎ��ʂ��ǂ�����S�z���܂��傤�B�l�T�����̖�̏��Y�̂��Ƃňꖼ�ɂȂ����Ƃ�����A����܂ł̖��ł��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">�h�ؗd����\�\\�͂œ���ւ��ƁA�Ȃɂ���������ւ��́H</a></h3>
<p class="paragraph">
���_�����ꂩ����Ă��A�l�Ԋ֌W��g�̂��̂��͓̂���ւ��܂���B
�J�����ɗx�炳��Ă��邱�ƁA�J�A���͐g�̂ɏ����A����ւ��̑ΏۊO�ɂȂ�܂��B�t�ɁA�����Ȃǂ͓���ւ��̑ΏۂɂȂ�̂ŁA���傤�ǎ��񂾐l���Ɠ���ւ��ƁA�ȑO�̎����̖��c�Ȏ��̂�������܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">���l����҂����ʂƁA�R�l�ȏ㏈�Y����́H</a></h3>
<p class="paragraph">
���Ƃ��P�O�O�l�̐�҂���x�Ɏ���ł��A�����̓��[��͂Q���ɂȂ�܂��B
��҂�\�\\�͂́A���Y�Ώۂ��ЂƂ葝�₷�A�ł͂Ȃ��A���Y�Ώۂ��ӂ���ɂ���A�ł��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">���Ⴀ�e�T�́H</a></h3>
<p class="paragraph">
���l�ɁA�P�O�O�C�̎e���������T�������A�����̏P����͂Q���ł��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">���V�Ɛl�����āA���Ȃ��H</a></h3>
<p class="paragraph">
�������A�l���͏P�����󂯂�ƕ������A����̌�Ɏ��S���܂����A���V�͕��������܂ܐ��������܂��B�܂��A��x�̏P�����x�̓Ŗ�ȂǂŒ��V������ł��܂��ꍇ�A�Ɛl��\�\\�͂������܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">���c�͂ǂ��������́H</a></h3>
<p class="paragraph">
���c��\�\\�͓͂J�����������p���܂����B�A���e�B���b�g�l�T�̋��c�ƃ~���[�Y�z���[�V���̓J������\�\\�͂��������Ă���A�������f�ڂ���قǈႢ���Ȃ��Ɗ��������߂ł��B���ƁA�J�����̂ق������킢����ˁB
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">�J�����A�������Ȃ��H</a></h3>
<p class="paragraph">
�����ɃV�r��邠�������D�[�[�[�I
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">�����Ƃǂ��Ȃ�H</a></h3>
<p class="paragraph">
�l�T�Ȃ�l�T������󂯁A�d���Ȃ��E����Ă��܂��܂��B<a href="sow.cgi?cmd=howto#rolerule">�ڂ����ꗗ\�\\</a>�͂�����B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">R-�T�C����-6 �݂����Ȃ̂������񂾂��ǁH</a></h3>
<p class="paragraph">
�s���A���Ȃ��͂��̏��ɐڂ���ɂ́A<a href="http://members.at.infoseek.co.jp/Paranoia_O/books/IrIntro.html">�Z�L�����e�B�E�N���A�����X������Ȃ�</a>�悤�ł��B<br>
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">�������������ƁA�m�肷��O�ɃA�N�V�����𑗐M����ƁA�A�N�V�����̕�����Ɋm�肵�܂����H</a></h3>
<p class="paragraph">
�������A�����̕�����Ɋm�肵�܂��B
</p>

<p class="paragraph">
�l�T�R��ł̓A�N�V�����������m�肷��d�l�̂��߁A�Z���Ԋu�Ŕ������A�N�V�����ƍs���ƃA�N�V�������O�̔�����ǂ������Ƃ������ۂ��������܂����A�{�X�N���v�g�ł͂��̂܂܂̏����Ɋm�肵�܂��B<br$net>
�m�肷��܂ł̂����������͑��̐l�ɂ͌����܂��񂪁A�m�肷��ƃA�N�V�����̑O�ɔ������}�Ɋ��荞�񂾂悤�Ȍ`�ŕ\\������܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">�����P�񂷂�Ƃǂ��Ȃ�H</a></h3>
<p class="paragraph">
_HTML_
	if ( $cfg->{'ENABLED_DELETED'} ) {
		print "�����͍폜�����ɂȂ�A���Ȃ����������邱�Ƃ��ł��܂��B�G�s���[�O�ɂȂ�ƑS�̂Ɍ��J����܂��B" ;
	} else {
		print "�����͌����Ȃ��Ȃ�A�G�s���[�O�ɂȂ��Ă��������܂܂ł��B" ;
	}
	print <<"_HTML_";
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">�扺����A�閧�̉�b�i�����Ȃǁj�͌�����H</a></h3>
<p class="paragraph">
_HTML_
	if ( $cfg->{'ENABLED_PERMIT_DEAD'} ) {
		print "�����܂��B�����c�������Ԃ��������Ă����܂��傤�B" ;
	} else {
		print "�����܂���B" ;
	}
	print <<"_HTML_";
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">�b�̑����𑣂��\\�����A���R�ɕς�������</a></h3>
<h3><a $atr_id="actionbeforesay">���̃N���[�����Ă񂶂Ⴄ�\\�����A���R�ɕς�������</a></h3>
<h3><a $atr_id="actionbeforesay">�Z�L�����e�B�E�N���A�����X���グ���������Ⴄ�\\�����A���R�ɕς�������</a></h3>
<p class="paragraph">
��肽���s����I�񂾂��ƁA�������̍s�Ɏ��R�ɓ��͂��Ă݂܂��傤�B���͂����Ƃ���̃A�N�V���������āA�����̌��ʂ�������܂��B
</p>
<hr class="invisible_hr"$net>

</DIV>
_HTML_

}

1;
