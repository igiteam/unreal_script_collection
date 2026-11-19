class animscripts_run extends Object within HodAI
	dependson(animscripts_utility)
	dependson(general_human);

function MoveRun(bool iFirst, optional bool newThread = false)
{
	local run_MoveRun task;
	task = new(self) class'run_MoveRun';
	task.iFirst = iFirst;
	run(task, newThread);
}

function name GetRunAnim()
{
	if (a.combatRunAnim != '')
		return a.combatRunAnim;
	
	return 'stand_run_F';
}

function name GetCrouchRunAnim()
{
	if (isdefined(a.crouchRunAnim))
		return a.crouchRunAnim;
	
	return 'crouch_walk_F';
}


//ProneCrawl()
//{
//}


function DoNoteTracksNoShootStandCombat(name animName)
{
	animscripts_shared.DoNoteTracksForTime(0.2, animName);	
}

function RunShootWhileMovingThreads(optional bool newThread = false)
{
	run (new(self) class'run_RunShootWhileMovingThreads', newThread);
}

function StopShootWhileMovingThreads(optional bool newThread = false) // we don't stop them if we shoot while moving again
{
	run (new(self) class'run_StopShootWhileMovingThreads', newThread);
}


function RunDecideWhatAndHowToShoot(optional bool newThread = false)
{
	run (new(self) class'run_RunDecideWhatAndHowToShoot', newThread);
}

function RunShootWhileMoving(optional bool newThread = false)
{
	run (new(self) class'run_RunShootWhileMoving', newThread);
}

//aimedSomewhatAtEnemy()
//{
//	weaponAngles = self gettagangles("tag_weapon");
//	anglesToShootPos = vectorToAngles(self.enemy getShootAtPos() - self gettagorigin("tag_weapon"));
//	
//	if (AbsAngleClamp180(weaponAngles[1] - anglesToShootPos[1]) > 15)
//		return false;
//	
//	return AbsAngleClamp180(weaponAngles[0] - anglesToShootPos[0]) <= 20;
//}

function bool CanShootWhileRunningForward()
{
	local float enemyyaw;

	if (abs(getMotionAngle()) > 60)
		return false;
	
	enemyyaw = GetPredictedYawToEnemy(0.2);
	if (abs(enemyyaw) > 75)
		return false;
	
	return true;
}

function bool CanShootWhileRunningBackward()
{
	if (180 - abs(getMotionAngle()) >= 45)
		return false;
	
	if (abs(GetPredictedYawToEnemy(0.2)) > 30)
		return false;
	
	return true;
}

//CanShootWhileRunning()
//{
//	return animscripts\move::MayShootWhileMoving() && isValidEnemy(self.enemy) && (CanShootWhileRunningForward() || CanShootWhileRunningBackward());
//}

function float GetPredictedYawToEnemy(float lookAheadTime)
{
	local vector selfPredictedPos;
	local float moveAngle;
	local vector v;
	local float yaw;

	assert(animscripts_utility.isValidEnemy(enemy));
	
	selfPredictedPos = origin;
	moveAngle = angles.yaw + getMotionAngle();
	v.x = cos(moveAngle);
	v.y = sin(moveAngle);
	v.z = 0;
	selfPredictedPos += v * 200.0*FInch * lookAheadTime;
	
	yaw = angles.yaw - VectorToAngles(enemy.origin - selfPredictedPos).yaw;
	yaw = AngleClamp180(yaw);
	return yaw;
}

//MoveCrouchRunOverride()
//{
//}
//
//MoveCrouchRunNormal()
//{
//}
//
//ReloadStandRun()
//{
//	reloadIfEmpty = isdefined(self.a.allowedPartialReloadOnTheRunTime) && self.a.allowedPartialReloadOnTheRunTime > gettime();
//	reloadIfEmpty = reloadIfEmpty || (isdefined(self.enemy) && distanceSquared(self.origin, self.enemy.origin) < 256 * 256);
//	if (reloadIfEmpty)
//	{
//		if (!self NeedToReload(0))
//			return false;
//	}
//	else
//	{
//		if (!self NeedToReload(.5))
//			return false;
//	}
//	
//	if (self CanShootWhileRunning() && !self NeedToReload(0))
//		return false;
//	
//	if (!isdefined(self.pathGoalPos) || distanceSquared(self.origin, self.pathGoalPos) < 256*256)
//		return false;
//	
//	motionAngle = AngleClamp180(self getMotionAngle());
//	
//	// want to be running forward; otherwise we won't see the animation play!
//	if (abs(motionAngle) > 25)
//		return false;
//	
//	if (self animscripts_utility.WeaponAnims() != "rifle")
//		return false;
//	
//	// need to restart the run cycle because the reload animation has to be played from start to finish!
//	// the goal is to play it only when we're near the end of the run cycle.
//	if (!runLoopIsNearBeginning())
//		return false;
//	
//	// call in a separate function so we can cleanup if we get an endon
//	ReloadStandRunInternal();
//	
//	self notify("stopRunning");
//	// notify "abort_reload" in case the reload didn't finish, maybe due to "movemode" notify. works with handleDropClip() in shared.gsc
//	self notify("abort_reload");
//	
//	return true;
//}
//
//ReloadStandRunInternal()
//{
//	self endon("movemode");
//	
//	flagName = "reload_" + getUniqueFlagNameIndex();
//	
//	self setFlaggedAnimKnobAllRestart(flagName, %run_lowready_reload, %body, 1, 0.25);
//	
//	self thread UpdateRunWeightsBiasForward(
//		"stopRunning",
//		%combatrun_forward,
//		%run_lowready_B,
//		%run_lowready_L,
//		%run_lowready_R
//	);
//	animscripts\shared::DoNoteTracks(flagName);
//}
//
//runLoopIsNearBeginning()
//{
//	// there are actually 3 loops (left foot, right foot) in one animation loop.
//
//	animfraction = self getAnimTime(%walk_and_run_loops);
//	loopLength = getAnimLength(%run_lowready_F) / 3.0;
//	animfraction *= 3.0;
//	if (animfraction > 3)
//		animfraction -= 2.0;
//	else if (animfraction > 2)
//		animfraction -= 1.0;
//	
//	if (animfraction < .15 / loopLength)
//		return true;
//	if (animfraction > 1 - .3 / loopLength)
//		return true;
//	
//	return false;
//}


function UpdateRunWeights(name notifyString, name frontAnim, name backAnim, name leftAnim, name rightAnim, optional bool newThread = false)
{
	local run_UpdateRunWeights task;
	task = new(self) class'run_UpdateRunWeights';
	task.notifyString = notifyString;
	task.frontAnim = frontAnim;
	task.backAnim = backAnim;
	task.leftAnim = leftAnim;
	task.rightAnim = rightAnim;
	run(task, newThread);
}

function UpdateRunWeightsOnce(name frontAnim, name backAnim, name leftAnim, name rightAnim)
{
	local QuadrantAnimWeight animWeights;
	animWeights = animscripts_utility.QuadrantAnimWeights(getMotionAngle());
	SetAnim(frontAnim, animWeights.front, 0.2, 1);
	SetAnim(backAnim,  animWeights.back , 0.2, 1);
	SetAnim(leftAnim,  animWeights.left , 0.2, 1);
	SetAnim(rightAnim, animWeights.right, 0.2, 1);
}

//// same as UpdateRunWeights but never lets the forward animation go below a weight of .2.
//// good for "flagged" animations.
//UpdateRunWeightsBiasForward(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
//{
//	self endon("killanimscript");
//	self endon(notifyString);
//
//	for (;;)
//	{
//		animWeights = animscripts\utility::QuadrantAnimWeights(self getMotionAngle());
//		
//		if (animWeights["front"] < .2)
//			animWeights["front"] = .2;
//		
//		self setanim(frontAnim, animWeights["front"], 0.2, 1);
//		self setanim(backAnim,  0.0                 , 0.2, 1);
//		self setanim(leftAnim,  animWeights["left"] , 0.2, 1);
//		self setanim(rightAnim, animWeights["right"], 0.2, 1);
//		wait 0.2;
//	}
//}
//
//// TODO Make this use the notetrack from the run animation playing.
//MakeRunSounds (notifyString)
//{
//	self endon("killanimscript");
//	self endon(notifyString);
//	for (;;)
//	{
//		wait .5;
//		self playsound ("misc_step1");
//		wait .5;
//		self playsound ("misc_step2");
//	}
//}
//
//// change our weapon while running if we want to and can
//changeWeaponStandRun()
//{
//	// right now this only handles shotguns, but it could do other things too
//	wantShotgun = (isdefined(self.wantShotgun) && self.wantShotgun);
//	usingShotgun = (weaponclass(self.weapon) == "spread");
//	if (wantShotgun == usingShotgun)
//		return false;
//	
//	if (!isdefined(self.pathGoalPos) || distanceSquared(self.origin, self.pathGoalPos) < 256*256)
//		return false;
//
//	if (usingSidearm())
//		return false;
//	assert(self.weapon == self.primaryweapon || self.weapon == self.secondaryweapon);
//	
//	if (self.weapon == self.primaryweapon)
//	{
//		if (!wantShotgun)
//			return false;
//		if (weaponclass(self.secondaryweapon) != "spread")
//			return false;
//	}
//	else
//	{
//		assert(self.weapon == self.secondaryweapon);
//		
//		if (wantShotgun)
//			return false;
//		if (weaponclass(self.primaryweapon) == "spread")
//			return false;
//	}
//	
//	// want to be running forward; otherwise we won't see the animation play!
//	motionAngle = AngleClamp180(self getMotionAngle());
//	if (abs(motionAngle) > 25)
//		return false;
//
//	if (!runLoopIsNearBeginning())
//		return false;
//	
//	if (wantShotgun)
//		shotgunSwitchStandRunInternal("shotgunPullout", %shotgun_CQBrun_pullout, "gun_2_chest", "none", self.secondaryweapon, "shotgun_pickup");
//	else
//		shotgunSwitchStandRunInternal("shotgunPutaway", %shotgun_CQBrun_putaway, "gun_2_back", "back", self.primaryweapon, "shotgun_pickup");
//	
//	self notify("switchEnded");
//	
//	return true;
//}
//
//shotgunSwitchStandRunInternal(flagName, switchAnim, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack)
//{
//	self endon("movemode");
//	
//	self setFlaggedAnimKnobAllRestart(flagName, switchAnim, %body, 1, 0.25);
//	
//	self thread animscripts\run::UpdateRunWeightsBiasForward(
//		"switchEnded",
//		%combatrun_forward,
//		%run_lowready_B,
//		%run_lowready_L,
//		%run_lowready_R
//	);
//	
//	self thread watchShotgunSwitchNotetracks(flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack);
//	
//	animscripts\shared::DoNoteTracksForTimeIntercept(getAnimLength(switchAnim) - 0.25, flagName, ::interceptNotetracksForWeaponSwitch);
//}
//
//interceptNotetracksForWeaponSwitch(notetrack)
//{
//	if (notetrack == "gun_2_chest" || notetrack == "gun_2_back")
//		return true; // "don't do the default behavior for this notetrack"
//}
//
//watchShotgunSwitchNotetracks(flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack)
//{
//	self endon("killanimscript");
//	self endon("movemode");
//	self endon("switchEnded");
//	
//	self waittillmatch(flagName, dropGunNotetrack);
//	
//	animscripts\shared::placeWeaponOn(self.weapon, putGunOnTag);
//	self thread shotgunSwitchFinish(newGun);
//	
//	self waittillmatch(flagName, pickupNewGunNotetrack);
//	self notify("complete_weapon_switch");
//}
//
//shotgunSwitchFinish(newGun)
//{
//	self endon("death");
//	
//	self waittill_any("killanimscript", "movemode", "switchEnded", "complete_weapon_switch");
//	
//	self.lastweapon = self.weapon;
//	
//	animscripts\shared::placeWeaponOn(newGun, "right");
//	assert(self.weapon == newGun); // placeWeaponOn should have handled this
//	
//	// reset ammo (assume fully loaded weapon)
//	self.bulletsInClip = weaponClipSize(self.weapon);
//}
