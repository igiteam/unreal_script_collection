class cover_wall_StandIdleThread extends CoreTask within animscripts_cover_wall;

state main
{
Begin:
	endon('killanimscript');

	if (a.standIdleThread)
		_return();
	a.standIdleThread = true;
	
	setAnim('add_idle', 1, 0.2);
	standIdleThreadInternal();
	clearAnim('add_idle', 0.2);
}
