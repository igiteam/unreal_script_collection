class cover_behavior_EndIdleAtFrameEnd extends CoreTask within animscripts_cover_behavior;

state main
{
Begin:
	endon('killanimscript');
	endon('dont_end_idle');
	wait (0);
	notify('end_idle');
	a.idlingAtCover = false;
}
