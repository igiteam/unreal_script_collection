class melee_PrepareToMelee extends CoreTask within animscripts_melee;

// parameter

// output

// local
var vector lPrevEnemyPos;
var float lSampleTime;
var float lRaiseGunAnimTravelDist;
var float lMeleeAnimTravelDist;
var float lShouldRaiseGunDist;
var float lShouldRaiseGunDistSq;
var float lShouldMeleeDist;
var float lShouldMeleeDistSq;
var float lRaiseGunFullDuration;
var float lRaiseGunFinishDuration;
var float lRaiseGunPredictDuration;
var float lRaiseGunStartTime;
var float lPredictedEnemyDistSqAfterRaiseGun;
var name lRunAnim;
var bool lRaisingGun;
var float lTime;
var bool lWillBeWithinRangeWhenGunIsRaised;
var bool lWithinRangeNow;
var vector lEnemyVel;
var vector lPredictedEnemyPosAfterRaiseGun;

state main
{
Begin:
	if (!CanMeleeAnyRange())
		_return();
	
	if (enemyDistanceSq <= anim.meleeRangeSq)
	{
		// just play a melee-from-standing transition
		SetFlaggedAnimKnobAll('readyanim', SetCustomAnim(misc_modern, 'stand_2_melee', 1.5), 'body', 1, 0.3, 1);
		animscripts_shared.DoNoteTracks('readyanim');
		_return(true);
	}

//	self PlayMeleeSound();
	
	lPrevEnemyPos = enemy.origin;
	
	lSampleTime = 0.1;

	SetCustomAnim(animscripts_init.trans_anim, 'run_2_melee', 1.5);
	lRaiseGunAnimTravelDist = length(getmovedelta(animscripts_init.trans_anim[0].NodeName, 0, 1));
	lMeleeAnimTravelDist = 32*FInch;
	lShouldRaiseGunDist = anim.meleeRange * 0.75 + lMeleeAnimTravelDist + lRaiseGunAnimTravelDist;
	lShouldRaiseGunDistSq = lShouldRaiseGunDist * lShouldRaiseGunDist;
	
	lShouldMeleeDist = anim.meleeRange + lMeleeAnimTravelDist;
	lShouldMeleeDistSq = lShouldMeleeDist * lShouldMeleeDist;
	
	lRaiseGunFullDuration = getanimlength(animscripts_init.trans_anim[0].NodeName) * 1000;
	lRaiseGunFinishDuration = lRaiseGunFullDuration - 100;
	lRaiseGunPredictDuration = lRaiseGunFullDuration - 200;
	lRaiseGunStartTime = 0;

	lPredictedEnemyDistSqAfterRaiseGun = -1;
	
	lRunAnim = SetCustomAnim(combatrun_forward, 'stand_run_F', 1.0, true);
	
	SetFlaggedAnimKnobAll('chargeanim', lRunAnim, 'body', 1, 0.3, 1);
	lRaisingGun = false;
	
	while (true)
	{
//		MeleeDebugPrint('PrepareToMelee loop' + randomint(100));
		
		lTime = gettime();
		
		lWillBeWithinRangeWhenGunIsRaised = ((lPredictedEnemyDistSqAfterRaiseGun >= 0) && lPredictedEnemyDistSqAfterRaiseGun <= lShouldRaiseGunDistSq);
		
		if (!lRaisingGun)
		{
			if (lWillBeWithinRangeWhenGunIsRaised)
			{
				SetFlaggedAnimKnobAllRestart('chargeanim', SetCustomAnim(misc_modern, 'run_2_melee', 1.5), 'body', 1, 0.2, 1);
				lRaiseGunStartTime = lTime;
				lRaisingGun = true;
			}
		}
		else
		{
			// if we *are* raising our gun, don't stop unless we're hopelessly out of range,
			// or if we hit the end of the raise gun animation and didn't melee yet
			lWithinRangeNow = enemyDistanceSq <= lShouldRaiseGunDistSq;
			if (lTime - lRaiseGunStartTime >= lRaiseGunFinishDuration || (!lWillBeWithinRangeWhenGunIsRaised && !lWithinRangeNow))
			{
				SetFlaggedAnimKnobAll('chargeanim', lRunAnim, 'body', 1, 0.3, 1);
				lRaisingGun = false;
			}
		}
		animscripts_shared.DoNoteTracksForTime(lSampleTime, 'chargeanim');
		
		// it's possible something happened in the meantime that makes meleeing impossible.
		if (!CanMeleeAnyRange())
			_return();
//		assert(isdefined(self.enemyDistanceSq)); // should be defined in CanMelee

		lEnemyVel = vectorScale(enemy.origin - lPrevEnemyPos, 1.0 / (gettime() - lTime)); // units/msec
		lPrevEnemyPos = enemy.origin;
		
		// figure out where the player will be when we hit them if we (a) start meleeing now, or (b) start raising our gun now
		lPredictedEnemyPosAfterRaiseGun = enemy.origin + vectorScale(lEnemyVel, lRaiseGunPredictDuration);
		lPredictedEnemyDistSqAfterRaiseGun = distanceSquared(origin, lPredictedEnemyPosAfterRaiseGun);
		
		// if we're done raising our gun, and starting a melee now will hit the guy, our preparation is finished
		if (lRaisingGun && enemyDistanceSq <= lShouldMeleeDistSq && gettime() - lRaiseGunStartTime >= lRaiseGunFinishDuration)
			break;

		// don't keep charging if we've been doing this for too long.
		if (!lRaisingGun && gettime() >= giveUpOnMeleeTime)
			_return();
	}
	_return(true);
}
