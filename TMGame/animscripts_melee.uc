// ===========================================================
//     AI vs Player melee
// ===========================================================
class animscripts_melee extends Object within HodAI;

function MeleeCombat(optional bool newThread = false)
{
	run (new(self) class'melee_MeleeCombat', newThread);
}

function ResetGiveUpTime()
{
	if (distanceSquared(origin, enemy.origin) > anim.chargeRangeSq)
		giveUpOnMeleeTime = gettime() + randomintrange(2700, 3300);
	else
		giveUpOnMeleeTime = gettime() + randomintrange(1700, 2300);
}

//MeleeDebugPrint(text)
//{
//	return;
//	self.meleedebugprint = text;
//	self thread meleeDebugPrintThreadWrapper();
//}
//
//meleeDebugPrintThreadWrapper()
//{
//	if (!isdefined(self.meleedebugthread))
//	{
//		self.meleedebugthread = true;
//		self meleeDebugPrintThread();
//		self.meleedebugthread = undefined;
//	}
//}
//
//meleeDebugPrintThread()
//{
//	self endon('death');
//	self endon('killanimscript');
//	self endon('stop_melee_debug_print');
//	
//	while(1)
//	{
//		print3d(self.origin + (0,0,60), self.meleedebugprint, (1,1,1), 1, .1);
//		wait .05;
//	}
//}

function name GetEnemyPose()
{
	if (isplayer(enemy))
		return enemy.getStance();
	else
		return enemy.a.pose;
}

function bool CanContinueToMelee()
{
	return CanMeleeInternal('already started');
}

function bool CanMeleeAnyRange()
{
	return CanMeleeInternal('any range');
}

function bool CanMeleeDesperate()
{
	return CanMeleeInternal('long range');
}

function bool CanMelee()
{
	return CanMeleeInternal('normal');
}

function bool CanMeleeInternal(name lState)
{
	local name lEnemyPose;
	local float lYaw;
	local vector lEnemyPoint;
	local vector lVecToEnemy;
	local float nearest_enemy_sqrd_dist;
	local bool doingAIMelee;
	local float lChargeRangeSq;

	// no meleeing virtual targets
	if (!isSentient(enemy))
		return false;

	// or dead ones
	if (!isAlive(enemy))
		return false;
	
	if (disableMelee)
		return false;
	
	// Can't charge if we're not standing
	if (a.pose != 'stand')
		return false;
	
	lEnemyPose = getEnemyPose();
	if (lEnemyPose != 'stand' && lEnemyPose != 'crouch')
		return false;
	
	// if we're not at least partially facing the guy, wait until we are
	lYaw = abs(animscripts_utility.GetYawToEnemy());
	if ((lYaw > 60 && lState != 'already started') || lYaw > 110)
		return false;
	
	lEnemyPoint = enemy.GetOrigin();
	lVecToEnemy = lEnemyPoint - origin;
	enemyDistanceSq = lengthSquared(lVecToEnemy);

	// so we don't melee charge a guy who has gained ignoreme in the past frame
	nearest_enemy_sqrd_dist = GetClosestEnemySqDist();
	if (nearest_enemy_sqrd_dist > enemyDistanceSq)
		return false;
	
	// AI vs AI melee disabled for now.
	//doingAIMelee = (isAI(self.enemy) && self.enemy.type == 'human');
	doingAIMelee = false;
	
	if (doingAIMelee)
	{
//		// temp disabled.
//		//if (self.enemyDistanceSq > anim.aiVsAiMeleeRangeSq)
//		//	return false;
//		
//		// check if someone else is already meleeing my enemy.
//		if (!animscripts\utility::okToMelee(self.enemy))
//			return false;
//		
//		if (isDefined(self.magic_bullet_shield) && self.magic_bullet_shield && isdefined(self.enemy.magic_bullet_shield) && self.enemy.magic_bullet_shield)
//			return false;
//
//		if (!isMeleePathClear(lVecToEnemy, lEnemyPoint))
//			return false;
	}
	else
	{
//		// this check can be removed when AI vs AI melee is working.
//		if (isdefined(self.enemy.magic_bullet_shield) && self.enemy.magic_bullet_shield)
//			return false;
	
		if (enemyDistanceSq <= anim.meleeRangeSq)
		{
			if (!isMeleePathClear(lVecToEnemy, lEnemyPoint))
				return false;
			
			// Enemy is already close enough to melee.
			return true;
		}
		if (lState != 'any range')
		{
			lChargeRangeSq = anim.chargeRangeSq;
			if (lState == 'long range')
				lChargeRangeSq = anim.chargeLongRangeSq;
			if (enemyDistanceSq > lChargeRangeSq)
			{
				// Enemy isn't even close enough to charge.
				return false;
			}
		}
		
		if (lState == 'already started') // if we already started, we're checking to see if we can melee *without* charging.
			return false;
		
		// at this point, we can melee iff we can charge.
	
		// don't charge if we recently missed someone
		if (time_isdefined(lastMeleeGiveUpTime) && gettime() - lastMeleeGiveUpTime < 3000)
			return false;
		
		// check if someone else is already meleeing my enemy.
		if (!animscripts_utility.okToMelee(enemy))
			return false;

		if (!isMeleePathClear(lVecToEnemy, lEnemyPoint))
			return false;
	}
	
	return true;
}

function bool IsMeleePathClear(vector iVecToEnemy, vector iEnemyPoint)
{
	local vector lDirToEnemy;
	local vector lMeleePoint;

	iVecToEnemy.z = 0;
	lDirToEnemy = vectorNormalize(iVecToEnemy) * 32 * FInch;
	lDirToEnemy.z = 0;
	lMeleePoint = iEnemyPoint - lDirToEnemy;
	
	if (!isInGoal(lMeleePoint))
		return false;
	
	return maymovetopoint(lMeleePoint);
}

// this function makes the guy run towards his enemy, and start raising his gun if he's close enough to melee.
// it will return false if he gives up, or true if he's ready to start a melee animation.
function PrepareToMelee(optional bool newThread = false)
{
	run (new(self) class'melee_PrepareToMelee', newThread);
}

//PlayMeleeSound()
//{
//	if (!isdefined (self.a.nextMeleeChargeSound))
//		 self.a.nextMeleeChargeSound = 0;
//	if (gettime() > self.a.nextMeleeChargeSound)
//	{
//		self animscripts\face::SayGenericDialogue('meleecharge');
//		self.a.nextMeleeChargeSound = gettime() + 8000;
//	}
//}
//
//
//
//
//// ===========================================================
////     AI vs AI synced melee
//// ===========================================================
//
//AiVsAiMeleeCombat()
//{
//	self endon('killanimscript');
//	self notify('melee');
//	
//	self OrientMode('face enemy');
//	
//	self ClearAnim(%root, 0.3);
//	
//	IWin = (randomint(10) < 8);
//	if (isDefined(self.magic_bullet_shield) && self.magic_bullet_shield)
//		IWin = true;
//	if (isDefined(self.enemy.magic_bullet_shield) && self.enemy.magic_bullet_shield)
//		IWin = false;
//	
//	// TODO: more anims
//	winAnim = %bog_melee_R_attack;
//	loseAnim = %bog_melee_R_defend;
//	
//	if (IWin)
//	{
//		myAnim = winAnim;
//		theirAnim = loseAnim;
//	}
//	else
//	{
//		myAnim = loseAnim;
//		theirAnim = winAnim;
//	}
//	
//	// TODO: associate this with the anim
//	desiredDistSqrd = 72 * 72;
//	
//	self PlayMeleeSound();
//	
//	// charge into correct distance
//	AiVsAiMeleeCharge(desiredDistSqrd);
//	
//	if (distanceSquared(self.origin, self.enemy.origin) > desiredDistSqrd)
//		return false;
//	
//	// TODO: if too close, teleport backwards?
//	
//	// TODO: disable pushing?
//	
//	// TODO: need a tag_sync to linkto, like is done with dogs
//	
//	// start animation, start enemy on animation
//	self.meleePartner = self.enemy;
//	self.enemy.meleePartner = self;
//	
//	//self thread meleeLink();
//	
//	self.enemy.meleeAnim = theirAnim;
//	self.enemy animcustom(::AiVsAiAnimCustom);
//	
//	self.meleeAnim = myAnim;
//	self animcustom(::AiVsAiAnimCustom); // TODO: we should try to avoid using animcustom on ourselves
//}
//
//AiVsAiMeleeCharge(desiredDistSqrd)
//{
//	giveUpTime = gettime() + 2500;
//	self setAnimKnobAll(%run_lowready_F, %body, 1, 0.2);
//	
//	while (distanceSquared(self.origin, self.enemy.origin) > desiredDistSqrd && gettime() < giveUpTime)
//	{
//		// play run forward anim
//		wait .05;
//	}
//}
//
//AiVsAiAnimCustom()
//{
//	self endon('killanimscript');
//	self AiVsAiMeleeAnim(self.meleeAnim);
//}
//
//AiVsAiMeleeAnim(myAnim)
//{
//	self endon('end_melee');
//	self thread endMeleeOnKillanimscript();
//	
//	partnerDir = self.meleePartner.origin - self.origin;
//	self orientMode('face angle', vectorToAngles(partnerDir)[1]);
//	self animMode('zonly_physics');
//
//	self setFlaggedAnimKnobAllRestart('meleeAnim', myAnim, %body, 1, 0.2);
//	self animscripts\shared::DoNoteTracks('meleeAnim');
//	
//	self notify('end_melee');
//}
//
//endMeleeOnKillanimscript()
//{
//	self endon('end_melee');
//	self waittill('killanimscript');
//	self.meleePartner notify('end_melee');
//}
//
//meleeLink()
//{
//	self linkto(self.meleePartner);
//	
//	self waittill('end_melee');
//	
//	self unlink();
//}
