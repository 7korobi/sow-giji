package SWBasicTextRS;

sub SWBasicTextRS {
	my $sow = $_[0];

	my @starttypeorder = ('manual', 'wbbs');
	my %starttypetext = (
		ORDER  => \@starttypeorder,
		manual => '�蓮�J�n�i�J�n�{�^������������J�n�j',
		wbbs   => '�l�TBBS�^�i�X�V���Ԃ�������J�n�j',
	);

	my %saytext_count = (
		UNIT_SAY     => '��',
		UNIT_CAUTION => '����',
		UNIT_ACTION  => '��',
	);

	my %saytext_point = (
		UNIT_SAY     => 'pt',
		UNIT_CAUTION => '�o�C�g',
		UNIT_ACTION  => '��',
	);

	my %saytext_point25 = (
		UNIT_SAY     => 'pt',
		UNIT_CAUTION => '�o�C�g',
		UNIT_ACTION  => '��',
	);

	my %saytext = (
		count   => \%saytext_count,
		point   => \%saytext_point,
		point25 => \%saytext_point25,
	);

	my %mob_juror = (
		CAPTION => '���R',
		HELP    => '�i�s����b�͔��R���m�̂݁B���R�i������ҁj���������[����B',
	);
	my %mob_visiter = (
		CAPTION => '�q��',
		HELP    => '�i�s����b�͋q�ȓ��m�̂�',
	);
	my %mob_grave = (
		CAPTION => '����',
		HELP    => '�i�s����b�͕扺��',
	);
	my %mob_alive = (
		CAPTION => '����',
		HELP    => '�i�s����b�͒n��A�扺�A������',
	);

	my @mob_order = ('alive', 'grave', 'visiter', 'juror');
	my %mob = (
		ORDER     => \@mob_order,
		juror     => \%mob_juror,
		visiter   => \%mob_visiter,
		grave     => \%mob_grave,
		alive     => \%mob_alive,
	);

	my %game_tabula = (
		CAPTION => '�^�u���̐l�T',
		HELP    => '<li>�����[�̏��Y��₪���������ꍇ�A�����_���ɏ��Y����B<li>�T��S�ł�����ƁA�������B<li>�l���T�A�܂�l�ԂƐl�T���P�΂P�ɂ����Ƃ��A�l�Ԃ��]�v�ɂ��Ȃ��Ȃ�����A�T�����B</li>',
	);

	my %game_millerhollow = (
		CAPTION => '�~���[�Y�z���E',
		HELP    => '<li>�����[�̏��Y��₪���������ꍇ�A���Y���Ƃ��߂�B<li>�T��S�ł�����ƁA�������B<li>�u���l�v��S�ł�����ƁA�T�����B��E���������̐����c��́A�����ɒ��ڂ͊�^���Ȃ��B<li>���ׂĂ̎��҂͖�E�����J�����B</li>',
	);

	my %game_live_tabula = (
		CAPTION => '���񂾂畉��',
		HELP    => '<li>�����[�̏��Y��₪���������ꍇ�A�����_���ɏ��Y����B<li>�T��S�ł�����ƁA�����̐����҂������B<li>�l���T�A�܂�l�ԂƐl�T���P�΂P�ɂ����Ƃ��A�l�Ԃ��]�v�ɂ��Ȃ��Ȃ�����A�T�����B<li>�������A���Ԃ��������Ă��Ă��A����ł��܂����҂͔s�k�ł���B</li>',
	);

	my %game_live_millerhollow = (
		CAPTION => '���񂾂畉��(�~���[�Y�z���E)',
		HELP    => '<li>�����[�̏��Y��₪���������ꍇ�A���Y���Ƃ��߂�B<li>�T��S�ł�����ƁA�����̐����҂������B<li>�u���l�v��S�ł�����ƁA�T�����B��E���������̐����c��́A�����ɒ��ڂ͊�^���Ȃ��B<li>�������A���Ԃ��������Ă��Ă��A����ł��܂����҂͔s�k�ł���B</li>',
	);

	my %game_trouble = (
		CAPTION => 'Trouble��Aliens',
		HELP    => '<li>�����[�̏��Y��₪���������ꍇ�A�����_���ɏ��Y����B<li>�T��S�ł�����ƁA�����̐����҂������i���l�͎��񂾂畉����j�B<li>�l���T�A�܂�l�ԂƐl�T���P�΂P�ɂ����Ƃ��A�l�Ԃ��]�v�ɂ��Ȃ��Ȃ�����A�T�Ɗ����҂̏����B<li>�l�T�͉�b�ł��Ȃ��B�P����⃊�X�g�Ŕ��f�ł��Ȃ��B<li>�P����͗����A�]�����Ɛl�T�ɊJ�������B</li><li>���҂́A����l���̐l�T����͎�肫�邱�Ƃ��ł����A�g����Ɋ�������B</li><li>�P�l�̐l�T���P������Ɗ����A�����̐l�T���C�T�A�܋��҂����P������Ǝ��S����B</li>',
	);

	my %game_mistery = (
		CAPTION => '�[�����̖�',
		HELP    => '<li>�����[�̏��Y��₪���������ꍇ�A�����_���ɏ��Y����B<li>�T��S�ł�����ƁA�������B<li>��E�u���l�v��S�ł�����ƁA�T�����B</li><li>��E���������̐����c��́A�����ɒ��ڂ͊�^���Ȃ��B</li><li>�����͎����̖�E�����o���Ȃ��B</li><li>�����́A�\�͂̌��ʕs�R�҂��������邱�Ƃ�����B</li><li>�l�T�̍s���ΏۂɑI�΂��ƁA�s�R�҂���������B</li>',
	);

	my %game_vov = (
		CAPTION => '�����a�̒J',
		HELP    => '<li>�����[�̏��Y��₪���������ꍇ�A�����_���ɏ��Y����B<li>�T��S�ł�����ƁA�������B<li>�l���T�A�܂�l�ԂƐl�T���P�΂P�ɂ����Ƃ��A�l�Ԃ��]�v�ɂ��Ȃ��Ȃ�����A�T�����B</li><li>�P�l�̐l�T���P������Ɗ����A�����̐l�T���C�T�A�܋��҂����P������Ǝ��S����B</li>',
	);

	my %game = (
		TABULA            => \%game_tabula,
		MILLERHOLLOW      => \%game_millerhollow,
		LIVE_TABULA       => \%game_live_tabula,
		LIVE_MILLERHOLLOW => \%game_live_millerhollow,
		TROUBLE           => \%game_trouble,
		VOV               => \%game_vov,
		MISTERY           => \%game_mistery,
	);


	my %basictrs = (
		NONE_TEXT       => '�Ȃ�',
		SAYTEXT         => \%saytext,
		ORDER_STARTTYPE => \@starttypeorder,
		STARTTYPE       => \%starttypetext,
		BUTTONLABEL_PC  => '_BUTTON_',
		BUTTONLABEL_MB  => '_BUTTON_',
		MOB             => \%mob,
		GAME            => \%game,
	);

	return \%basictrs;
}

1;
