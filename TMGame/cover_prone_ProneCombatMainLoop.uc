class cover_prone_ProneCombatMainLoop extends CoreTask within animscripts_cover_prone;

// parameter

// output

// local
var float lNextShootTime;
var bool lDesynched;
var float lDistSqToShootPos;
var bool lProneReload;


function OnReturn(CoreTask task)
{
	if (task.isa('combat_utility_Reload'))
		lProneReload = true;
}

state main
{
Begin:
	endon ('killanimscript');
	endon ('melee');
	
	animscripts_shared.trackShootEntOrPos(true);
	
////	self thread ReacquireWhenNecessary();
	
	animscripts_shoot_behavior.decideWhatAndHowToShoot('normal', true);

	lNextShootTime = 0;
	
////	self resetGiveUpOnEnemyTime();
	
	lDesynched = (gettime() > 2500);

	//prof_begin('prone_combat');
	
	while (true)
	{
		animscripts_utility.IsInCombat(); // reset our in-combat state
		
		UpdateProneWrapper(0.05);
		
		if (!lDesynched)
		{
			wait (0.05 + randomfloat(1.5));
			lDesynched = true;
			continue;
		}
		
		if (!vec_isdefined(shootPos))
		{
			assert(!obj_isdefined(shootEnt));
			if (considerThrowGrenade())
				continue;
			
			wait(0.05);
			continue;
		}
		
		assert(vec_isdefined(shootPos)); // we can use self.shootPos after this point.
////		self resetGiveUpOnEnemyTime();
		
		// if we're too close to our enemy, stand up
		// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
		lDistSqToShootPos = lengthsquared(origin - shootPos);

		if (a.pose != 'crouch' && isStanceAllowed('crouch') && lDistSqToShootPos < squared(400))
		{
			if (lDistSqToShootPos < squared(285*FInch))
			{
				transitionTo('crouch');
				animscripts_combat.main(true);
				_return();
			}
		}

		if (considerThrowGrenade()) // TODO: make considerThrowGrenade work with shootPos rather than only self.enemy
			continue;
		
		lProneReload = false;
		proneReload(0);
		if (lProneReload)
			continue;

		if (animscripts_combat_utility.aimedAtShootEntOrPos() && gettime() >= lNextShootTime)
		{
			animscripts_combat_utility.shootUntilShootBehaviorChange();
			clearAnim('add_fire', 0.2);
			continue;
		}
		
		// idleThread() is running, so just waiting a bit will cause us to idle
		wait(0.05);
	}
	
	//prof_end('prone_combat');
}
