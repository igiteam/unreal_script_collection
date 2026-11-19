class combat_ReacquireWhenNecessary extends CoreTask within animscripts_combat;

state main
{
Begin:
	endon('killanimscript');
	endon('melee');
	
	a.exposedReloading = false;
	// don't look for a cover node right away. stand and fight.
	a.lookForNewCoverTime = gettime() + randomintrange(800, 1500);
	
	if (fixedNode)
		_return();
	
	while (true)
	{
		wait (0.05);
		
		if (fixedNode)
			_return();
		
		TryExposedReacquire();
	}
}
