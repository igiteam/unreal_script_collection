class cover_right_main extends CoreTask within animscripts_cover_right;

state main
{
Begin:
	trackScriptState('Cover Right Main', "code");
	endon('killanimscript');
	animscripts_utility.initialize('cover_right');

	corner_think('right');
}
