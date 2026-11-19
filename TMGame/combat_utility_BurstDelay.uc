class combat_utility_BurstDelay extends CoreTask within animscripts_combat_utility;

// parameter

// output

// local
var float lDelayTime;

state main
{
Begin:
	if (bulletsInClip > 0)
	{
		if (shootStyle == 'full' && !fastBurst)
		{
			if (a.lastShootTime == gettime())
				wait (0.05);
			_return();
		}

		lDelayTime = getRemainingBurstDelayTime();
		if (lDelayTime > 0)
			wait (lDelayTime);
	}
}
