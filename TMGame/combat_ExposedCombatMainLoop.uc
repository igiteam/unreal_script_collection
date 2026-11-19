class combat_ExposedCombatMainLoop extends CoreTask within animscripts_combat;

// local
var int lNextShootTime;
var bool lJustWaited;
var float lDistSqToShootPos;
var float lPredictTime;
var float lYawToShootEntOrPos;

var bool lReturn;

function OnReturn(CoreTask task)
{
	local combat_TurnToFaceRelativeYaw TurnToFaceRelativeYawTask;
	TurnToFaceRelativeYawTask = combat_TurnToFaceRelativeYaw(task);
	if (TurnToFaceRelativeYawTask != none)
	{
		lReturn = TurnToFaceRelativeYawTask.oResult;
		return;
	}
}

state main
{
Begin:
	endon ('killanimscript');
	endon ('melee');
	
	//prof_begin('combat_init2');
	
	animscripts_shared.trackShootEntOrPos(true);
	
	ReacquireWhenNecessary(true);
	
	animscripts_shoot_behavior.decideWhatAndHowToShoot('normal', true);
	
	watchShootEntVelocity(true);
	
	animscripts_combat_utility.attackEnemyWhenFlashed(true);
	
	if (a.magicReloadWhenReachEnemy)
	{
		animscripts_weaponList.RefillClip();
		a.magicReloadWhenReachEnemy = false;
	}
	
	animMode('zonly_physics', false);
	
	// before, we oriented to enemy briefly and then changed to face current.
	// now we just face current immediately and rely on turning.
	OrientMode('face angle', angles.yaw);
	lNextShootTime = 0;
	
	resetGiveUpOnEnemyTime();
	
	// hesitate to crouch.
	// crouching too early can look stupid because we'll tend to stand right back up in a lot of cases.
	a.dontCrouchTime = gettime() + randomintrange(500, 1500);
	
	//prof_end('combat_init2');
	
	//prof_begin('combat');
	
	lJustWaited = false;
	
	while (true)
	{
		if (animscripts_utility.weaponAnims() == 'rocketlauncher')
			deathFunction = none;
		
		if (enemy != none && (enemy.health <= 0))
			enemy = none;
		animscripts_utility.IsInCombat(); // reset our in-combat state
		
		if (!lJustWaited)
		{
			//prof_begin('combat_setanimarray');
			if (a.pose == 'stand')
				set_animarray_standing();
			else if (a.pose == 'crouch')
				set_animarray_crouching();
			else
				set_animarray_prone();
				
			//prof_end('combat_setanimarray');
		}
		lJustWaited = false;
		
		//prof_begin('combat_partA');
		// it is important for this to be *after* the set_animarray calls!
		if (EnsureStanceIsAllowed())
			continue;
		
		if (TryMelee())
			_return();
		
		if (!vec_isdefined(shootPos))
		{
			assert(!obj_isdefined(shootEnt));
			cantSeeEnemyBehavior();
			continue;
		}
		
		assert(vec_isdefined(shootPos)); // we can use self.shootPos after this point.
		resetGiveUpOnEnemyTime();
		
		// if we're too close to our enemy, stand up
		// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
		lDistSqToShootPos = lengthsquared(origin - shootPos);

		if (kCombatMood == HCM_Ambush)
		{
			wait (0.05);
			continue;
		}


		// too close for RPG or out of ammo
		if (animscripts_utility.weaponAnims() == 'rocketlauncher' && (lDistSqToShootPos < squared(512) * FInchSq || a.rockets < 1))
		{
			if (a.pose != 'stand' && a.pose != 'crouch')
				transitionTo('crouch');
			
			if (a.pose == 'stand')
				animscripts_shared.throwDownWeapon('RPG_stand_throw');
			else
				animscripts_shared.throwDownWeapon('RPG_crouch_throw');
			
			continue;
		}

		if (a.pose != 'stand' && isStanceAllowed('stand'))
		{
			if (lDistSqToShootPos < squared(285) * FInchSq)
			{
				transitionTo('stand');
				continue;
			}
			if (standIfMakesEnemyVisible())
				continue;
		}

		if (needToTurn())
		{
			lPredictTime = 0.25;
			if (obj_isdefined(shootEnt) && !isSentient(shootEnt))
				lPredictTime = 1.5;
			lYawToShootEntOrPos = animscripts_shared.getPredictedAimYawToShootEntOrPos(lPredictTime); // yaw to where we think our enemy will be in x seconds
			TurnToFaceRelativeYaw(lYawToShootEntOrPos);
			if (lReturn)
				continue;
		}
		
//		if (considerThrowGrenade()) // TODO: make considerThrowGrenade work with shootPos rather than only self.enemy
//			continue;
		
		//prof_end('combat_partA');
		
		//prof_begin('combat_partB');
		
		if (forceSideArm && a.pose == 'stand' && !animscripts_utility.usingSidearm())
		{
			if (tryUsingSidearm())
				continue;
		}
		
		if (animscripts_combat_utility.NeedToReload(0))
		{
			// TODO: tweak prone exposed reloading to be considered safer
			// requiring self.weapon == self.primaryweapon because we dont want him to drop his shotgun and then, if wantshotgun = false, decide to pick up his rifle when he's done
			if (!animscripts_utility.usingSidearm() && animscripts_utility.weaponAnims() != 'rocketlauncher' && weapon == primaryweapon && lengthsquared(origin - shootPos) < squared(512) * FInchSq && isStanceAllowed('stand'))
			{
				// we need to be standing to switch weapons
				if (a.pose != 'stand')
				{
					transitionTo('stand');
					//prof_end('combat_partB');
					continue;
				}
			
				if (tryUsingSidearm())
				{
					//prof_end('combat_partB');
					continue;
				}
			}
			
			if (exposedReload(0))
			{
				//prof_end('combat_partB');
				continue;
			}
		}
		
		if (animscripts_utility.weaponAnims() == 'rocketlauncher' && a.pose != 'crouch' && randomFloat(1) > 0.65)
			deathFunction = DeathFunc_RPGDeath;

		if (animscripts_utility.usingSidearm() && a.pose == 'stand' && lengthsquared(origin - shootPos) > squared(512) * FInchSq)
			switchToLastWeapon('pistol_stand_switch');
		
		if (lDistSqToShootPos > squared(600)*FInchSq && a.pose != 'crouch' && isStanceAllowed('crouch') && !animscripts_utility.usingSidearm() && gettime() >= a.dontCrouchTime)
		{
			if (lengthSquared(shootEntVelocity) < 100*100*FInchSq)
			{
				if (!vec_isdefined(shootPos) || sightTracePassed(origin + vect(0,0,36)*FInch, shootPos, false, obj_undefined))
				{
					transitionTo('crouch');
					//prof_end('combat_partB');
					continue;
				}
			}
		}

		//prof_end('combat_partB');
		
		//prof_begin('combat_partC');

		if (animscripts_combat_utility.aimedAtShootEntOrPos() && gettime() >= lNextShootTime)
		{
			shootUntilNeedToTurn();
			if (!animscripts_utility.usingShotgun())
				clearAnim('add_fire', 0.2);

			//prof_end('combat_partC');
			continue;
		}
		
		//prof_end('combat_partC');

		// idleThread() is running, so just waiting a bit will cause us to idle
		exposedWait();
		lJustWaited = true;
	}
	
	//prof_end('combat');
}
