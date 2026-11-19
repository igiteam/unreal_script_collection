class corner_StandIdleThread extends CoreTask within animscripts_corner;

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
