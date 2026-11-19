class combat_StopShortly extends CoreTask within animscripts_combat;

state main
{
Begin:
	endon('killanimscript');
	endon('melee');
	// we want to stop at about the time we blend out of whatever we were just doing.
	wait (0.2);
	a.movement = 'stop';
}
