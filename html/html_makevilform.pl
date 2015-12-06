package SWHtmlMakeVilForm;

#----------------------------------------
# ���쐬�^�ҏW��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLMakeVilForm {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};

	$sow->{'html'} = SWHtml->new($sow);
	$sow->{'http'}->outheader();
	$sow->{'html'}->outheader("���̍쐬");
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C���{�^��
  &SWHtmlPC::OutHTMLChangeCSS($sow);
	print <<"_HTML_";
<div id="make_vil"></div>
_HTML_

	# ���t�ʃ��O�ւ̃����N
	&SWHtmlPC::OutHTMLReturnPC($sow); # �g�b�v�y�[�W�֖߂�

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��


	&SWHtmlPC::OutHTMLGonInit($sow); # ���O�C�����̏o��
	$vil->gon_story(true);
	$vil->gon_event(true);
	my $fullmanage  = ( $vil->{'turn'} == 0 );

	print <<"_HTML_";
	e = [];
	f = [];
	g = [];
	i = [];

	a = [];
	b = [];
	c = [];
	d = {};

	gon.config = {
		roles: a,
		gifts: b,
		events: c,
		counts: d,
		roletables: i,
		votetypes: [
			{val:"anonymity",name:"���L�����["},
			{val:"sign",name:"�L�����["}
		],
		intervals: g,
		minutes: f,
		hours: e,
		trs: {
			caption:"$sow->{'textrs'}->{'CAPTION'}",
			help:"$sow->{'textrs'}->{'HELP'}"
		},
		trsid: "$vil->{'trsid'}"
	};
</script>
_HTML_
	$sow->{'http'}->outfooter();

	return;
}

1;
