class animscripts_shoot_behavior extends CoreTask within HodAI;

// Ideally, this will be the only thread *anywhere* that decides what/where to shoot at
// and how to shoot at it.

// This thread keeps three variables updated, and notifies 'shoot_behavior_change' when any of them have changed.
// They are:
//  shootEnt - an entity. aim/shoot at this if it's defined.
//  shootPos - a vector. aim/shoot towards this if shootEnt isn't defined. if not defined, stop shooting entirely and return to cover if possible.
//		Whenever shootEnt is defined, shootPos will be defined as its getShootAtPos().
//  shootStyle - how to shoot.
//    'full' (unload on the target),
//    'burst' (occasional groups of shots),
//    'semi' (occasianal single shots),
//    'single' (occasional single shots),
//    'none' (don't shoot, just aim).
// This thread will also notify 'return_to_cover' and set self.shouldReturnToCover = true if it's a good idea to do so.
// Notify 'stop_deciding_how_to_shoot' to end this thread if no longer trying to shoot.

function DecideWhatAndHowToShoot(name objective, optional bool newThread = false)
{
	local shoot_DecideWhatAndHowToShoot task;
	task = new(self) class'shoot_DecideWhatAndHowToShoot';
	task.objective = objective;
	run (task, newThread);
}

function WaitABit()
{
	run (new(self) class'shoot_WaitABit', false);
}

function NoGunShoot()
{
	shootEnt = obj_undefined;
	shootPos = vec_undefined;
	shootStyle = 'none';
	shootObjective = 'normal';
}

function bool ShouldSuppress()
{
	return !animscripts_combat_utility.isSniper() && !animscripts_utility.weapon_spread();
}

function name RifleShoot()
{
	local Angle lLikelyEnemyDir;
	local vector lNewShootPos;
	local float lDist;

	if (shootObjective == 'normal')
	{
		if (!animscripts_utility.canSeeEnemy())
		{
			// enemy disappeared!
			if (animscripts_combat_utility.isSniper())
				resetSniperAim();

			if (!obj_isdefined(enemy))
			{
				haveNothingToShoot();
			}
			else
			{
				markEnemyPosInvisible();

				if ((provideCoveringFire || randomint(5) > 0) && shouldSuppress())
					shootObjective = 'suppress';
				else
					shootObjective = 'ambush';
				return 'retry';
			}
		}
		else
		{
			setShootEnt(enemy);
			setShootStyleForVisibleEnemy();
		}
	}
	else
	{
		if (animscripts_utility.canSeeEnemy()) // later, maybe we can be more realistic than just shooting at the enemy the instant he becomes visible
		{
			shootObjective = 'normal';
			ambushEndTime = invalid_time;
			return 'retry';
		}
		
		markEnemyPosInvisible();
		
		if (animscripts_combat_utility.isSniper())
			resetSniperAim();
		
		if (!animscripts_utility.canSuppressEnemy())
		{
			// no idea where the enemy is, so we can only ambush a valid enemy
			if (shootObjective == 'suppress' || (team == 'allies' && !animscripts_utility.isValidEnemy(enemy)))
			{
				haveNothingToShoot();
			}
			else
			{
				assert(shootObjective == 'ambush');
				
				shootStyle = 'none';
				
				if (!getAnglesToLikelyEnemyPath(lLikelyEnemyDir))
				{
					if (obj_isDefined(coverNode))
						lLikelyEnemyDir = coverNode.angles;
					else
						lLikelyEnemyDir = angles;
				}
				
				shootEnt = none;
				
				lDist = 1024 * FInch;
				if (obj_isdefined(enemy))
					lDist = distance(origin, enemy.origin);
				
				lNewShootPos = getEye() + anglesToForward(lLikelyEnemyDir) * lDist;
				if (!vec_isdefined(shootPos) || distanceSquared(lNewShootPos, shootPos) > 5*5*FInchSq) // avoid frequent 'shoot_behavior_change' notifies
					shootPos = lNewShootPos;
				
				if (shouldStopAmbushing())
				{
					ambushEndTime = time_undefined;
					notify('return_to_cover');
					shouldReturnToCover = true;
				}
			}
		}
		else
		{
			shootEnt = obj_undefined;
			shootPos = animscripts_utility.getEnemySightPos();
			
			if (shootObjective == 'suppress')
			{
				setShootStyleForSuppression();
			}
			else
			{
				assert(shootObjective == 'ambush');
				shootStyle = 'none';
				
				if (shouldStopAmbushing())
				{
					if (shouldSuppress())
						shootObjective = 'suppress';
					ambushEndTime = time_undefined;
					if (randomint(3) == 0)
					{
						notify('return_to_cover');
						shouldReturnToCover = true;
					}
					return 'retry';
				}
			}
		}
	}

	return '';
}

function bool ShouldStopAmbushing()
{
	if (!time_isdefined(ambushEndTime))
	{
		if (team == 'axis')
			ambushEndTime = gettime() + randomintrange(40000, 60000);
		else
			ambushEndTime = gettime() + randomintrange(4000, 10000);
	}
	return ambushEndTime < gettime();
}

function name RPGShoot()
{
	local float lDistSqToShootPos;

	if (!animscripts_utility.canSeeEnemy())
	{
		markEnemyPosInvisible();
		
		haveNothingToShoot();
		return '';
	}
	
	setShootEnt(enemy);
	shootStyle = 'single';

	lDistSqToShootPos = lengthsquared(origin - shootPos);
	// too close for RPG
	if (lDistSqToShootPos < squared(512) * FInchSq)
	{
		notify('return_to_cover');
		shouldReturnToCover = true;
		return '';
	}

	return '';
}


//shotgunShoot()
//{
//	if (!animscripts_utility.canSeeEnemy())
//	{
//		haveNothingToShoot();
//		return;
//	}
//	
//	setShootEnt(self.enemy);
//	self.shootStyle = 'single';	
//}

function name SniperShoot()
{
	if (!animscripts_utility.canSeeEnemy())
	{
		haveNothingToShoot();
		return '';
	}
	
	setShootEnt(enemy);
	shootStyle = 'single';	

	return '';
}

function name PistolShoot()
{
	if (shootObjective == 'normal')
	{
		if (!animscripts_utility.canSeeEnemy())
		{
			// enemy disappeared!
			if (!obj_isdefined(enemy))
			{
				haveNothingToShoot();
				return '';
			}
			else
			{
				markEnemyPosInvisible();
				
				shootObjective = 'ambush';
				return 'retry';
			}
		}
		else
		{
			setShootEnt(enemy);
			shootStyle = 'single';
		}
	}
	else
	{
		if (animscripts_utility.canSeeEnemy()) // later, maybe we can be more realistic than just shooting at the enemy the instant he becomes visible
		{
			shootObjective = 'normal';
			ambushEndTime = time_undefined;
			return 'retry';
		}
		
		markEnemyPosInvisible();
		
		if (animscripts_utility.canSuppressEnemy())
		{
			shootEnt = obj_undefined;
			shootPos = animscripts_utility.getEnemySightPos();
		}
		
		shootStyle = 'none';
		
		// stop ambushing after a while
		if (!time_isdefined(ambushEndTime))
			ambushEndTime = gettime() + randomintrange(4000, 8000);
			
		if (ambushEndTime < gettime())
		{
			shootObjective = 'normal';
			ambushEndTime = time_undefined;
			return 'retry';
		}
	}

	return '';
}

function MarkEnemyPosInvisible()
{
	local HodAI aiEnemy;

	if (obj_isdefined(enemy) && !changingCoverPos && a.script != 'combat')
	{
		aiEnemy = HodAI(enemy);
		// make sure they're not just hiding
		if (aiEnemy != none && isdefined(aiEnemy.a.script) && (aiEnemy.a.script == 'cover_stand' || aiEnemy.a.script == 'cover_crouch'))
		{
			if (isdefined(aiEnemy.a.coverMode) && aiEnemy.a.coverMode == 'hide')
				return;
		}
		
		couldntSeeEnemyPos = enemy.origin;
	}
}

function WatchForIncomingFire(optional bool newThread = false)
{
	run (new(self) class'shoot_WatchForIncomingFire', newThread);
}

function bool ReadyToReturnToCover()
{
	if (changingCoverPos)
		return false;
	
//	assert(isdefined(self.coverPosEstablishedTime));
	
	if (!animscripts_utility.isValidEnemy(enemy) || !canSee(enemy))
		return true;
	
	if (gettime() < coverPosEstablishedTime + 800)
	{
		// don't return to cover until we had time to fire a couple shots;
		// better to look daring than indecisive
		return false;
	}
	
	if (isPlayer(enemy) && enemy.health < enemy.maxHealth * 0.5)
	{
		// give ourselves some time to take them down
		if (gettime() < coverPosEstablishedTime + 3000)
			return false;
	}
	
	return true;
}

function RunOnShootBehaviorEnd(optional bool newThread = false)
{
	run (new(self) class'shoot_RunOnShootBehaviorEnd', newThread);
}

//checkChanged(prevval, newval)
//{
//	if (isdefined(prevval) != isdefined(newval))
//		return true;
//	if (!isdefined(newval))
//	{
//		assert(!isdefined(prevval));
//		return false;
//	}
//	return prevval != newval;
//}

function SetShootEnt(HodEntity ent)
{
	shootEnt = ent;
	shootPos = shootEnt.getShootAtPos();
}

function HaveNothingToShoot()
{
	shootEnt = none;
	shootPos = invalid_vector;
	shootStyle = 'none';
	
	if (!changingCoverPos)
	{
		notify('return_to_cover');
		shouldReturnToCover = true;
	}
}

function bool shouldBeAJerk()
{
	return level.gameskill == 3 && isPlayer(enemy);// && self shouldDoSemiForVariety();
}

function int SetShootStyleForVisibleEnemy()
{
	local float lDistanceSq;

	assert(vec_isdefined(shootPos));
	assert(obj_isdefined(shootEnt));
	
//	if (obj_isdefined(shootEnt.enemy) && isdefined(shootEnt.enemy.syncedMeleeTarget))
//		return setShootStyle('single', false);
	
	if (animscripts_combat_utility.isSniper() || animscripts_utility.weapon_spread())
		return setShootStyle('single', false);
	
	lDistanceSq = distanceSquared(getShootAtPos(), shootPos);
	
	if (weaponIsSemiAuto(weapon))
	{
		if (lDistanceSq < 1600*1600*FInchSq || shouldBeAJerk())
			return setShootStyle('semi', false);
		return setShootStyle('single', false);
	}
	
	if (weaponClass(weapon) == 'mg')
		return setShootStyle('full', false);
	
	if (lDistanceSq < 300*300*FInchSq)
	{
//		if (obj_isdefined(shootEnt) && isdefined(self.shootEnt.magic_bullet_shield))
//			return setShootStyle('single', false);
//		else
			return setShootStyle('full', false);
	}
	else if (lDistanceSq < 900*900*FInchSq || shouldBeAJerk())
	{
		return setShootStyle('burst', true);
	}
	if (provideCoveringFire || lDistanceSq < 1600*1600*FInchSq)
	{
		if (shouldDoSemiForVariety())
			return setShootStyle('semi', false);
		else
			return setShootStyle('burst', false);
	}

	return setShootStyle('single', false);
}

function int SetShootStyleForSuppression()
{
	local float lDistanceSq;

	assert(vec_isdefined(shootPos));
	
	lDistanceSq = distanceSquared(getShootAtPos(), shootPos);
	
	assert(!animscripts_combat_utility.isSniper()); // snipers shouldn't be suppressing!
	assert(!animscripts_utility.weapon_spread()); // shotgun users shouldn't be suppressing!
	
	if (weaponIsSemiAuto(weapon))
	{
		if (lDistanceSq < 1600*1600*FInchSq)
			return setShootStyle('semi', false);
		return setShootStyle('single', false);
	}
	
	if (weaponClass(weapon) == 'mg')
		return setShootStyle('full', false);
	
	if (provideCoveringFire || lDistanceSq < 1300*1300*FInchSq)
	{
		if (shouldDoSemiForVariety())
			return setShootStyle('semi', false);
		else
			return setShootStyle('burst', false);
	}

	return setShootStyle('single', false);
}

function int SetShootStyle(name inStyle, bool inFastBurst)
{
	shootStyle = inStyle;
	fastBurst = inFastBurst;
	return 0;
}

function bool ShouldDoSemiForVariety()
{
	local int changeFrequency;
	local int fakeTimeValue;

	if (weaponClass(weapon) != 'rifle')
		return false;
	
	if (team != 'allies')
		return false;

	// true randomness isn't safe, because that will cause frequent shoot_behavior_change notifies.
	// fake the randomness in a way that won't change frequently.
	changeFrequency = int(origin.y) % 10000 + 2000;
	fakeTimeValue = int(origin.x) + gettime();
	
	return fakeTimeValue % (2*changeFrequency) > changeFrequency;
}

function ResetSniperAim(optional bool considerMissing = false)
{
//	assert(self isSniper());
	sniperShotCount = 0;
	sniperHitCount = 0;
	
	if (considerMissing)
		lastMissedEnemy = none;
}
