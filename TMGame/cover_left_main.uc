class cover_left_main extends CoreTask within animscripts_cover_left;

state main
{
Begin:
    trackScriptState('Cover Left Main', "code");
	endon('killanimscript');
    animscripts_utility.initialize('cover_left');

	corner_think('left');
}
