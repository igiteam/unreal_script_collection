class combat_utility_ShootUntilShootBehaviorChange extends CoreTask within animscripts_combat_utility;

// paramter

// output

// local
var int lNumShots;

state main
{
Begin:
	endon('shoot_behavior_change');
	endon('stopShooting');
	
	if (animscripts_utility.weaponAnims() == 'rocketlauncher' || isSniper())
	{
		//if (obj_isDefined(enemy) && enemy != level.player && isSentient(enemy) && distanceSquared(level.player.origin, enemy.origin) < 384*384*FInchSq)
		//	enemy animscripts\battlechatter_ai::addThreatEvent('infantry', self, 1.0);
			
		if (animscripts_utility.weaponAnims() == 'rocketlauncher' && isSentient(enemy))
			wait (randomFloat(2.0));
	}
	
	while (true)
	{
		burstDelay(); // waits only if necessary
		
		if (shootStyle == 'full')
		{
			FireUntilOutOfAmmo(animscripts_utility.animArray('fire'), false, animscripts_shared.decideNumShotsForFull());
		}
		else if (shootStyle == 'burst' || shootStyle == 'single' || shootStyle == 'semi')
		{
			lNumShots = animscripts_shared.DefaultNumShots();
			if (shootStyle == 'burst' || shootStyle == 'semi')
				lNumShots = animscripts_shared.decideNumShotsForBurst();	
				
			if (lNumShots > 1 && shootStyle == 'single')
				shootStyle = 'burst';
			if (lNumShots == 1)
				FireUntilOutOfAmmo(animscripts_utility.animArrayPickRandom('single'), true, lNumShots);
			else
				FireUntilOutOfAmmo(animscripts_utility.animArray(name(shootStyle $ lNumShots)), true, lNumShots);
		}
		else
		{
			assert(shootStyle == 'none');
			waittill('hell freezes over'); // waits for the endons to happen
		}

		if (bulletsInClip == 0)
			break;
	}
}
