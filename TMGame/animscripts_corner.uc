class animscripts_corner extends Object within HodAI;

function corner_think(name iDirection, optional bool newThread = false)
{
	local corner_think task;
	task = new(self) class'corner_think';
	task.iDirection = iDirection;
	run (task, newThread);
}

function mainLoopStart()
{
	run (new(self) class'corner_mainLoopStart', false);
}
//
//printYaws()
//{
//	wait(2);
//	for(;;)
//	{
//		println('coveryaw = ',self.coverNode GetYawToOrigin(getEnemyEyePos()));
//		printYawToEnemy();
//		wait(0.05);
//	}
//}

// used within canSeeEnemyFromExposed() (in utility.gsc)
function bool CanSeePointFromExposedAtCorner(vector point, HodNode iNode)
{
	local float yaw;

	yaw = iNode.GetYawToOrigin(point);
	if ((yaw > 60) || (yaw < -60))
		return false;

	if ((iNode.type == 'Cover Left' || iNode.type == 'Cover Left Wide') && yaw > 14)
		return false;
	if ((iNode.type == 'Cover Right' || iNode.type == 'Cover Right Wide') && yaw < -12)
		return false;

	return true;
}

function bool ShootPosOutsideLegalYawRange()
{
	local float lYaw;

	if (!vec_isdefined(shootPos))
		return false;

	lYaw = coverNode.GetYawToOrigin(shootPos);

	if (cornerDirection == 'left')
	{
		if (a.cornerMode == 'B')
		{
			return lYaw < 0-ABangleCutoff || lYaw > 14;
		}
		else if (a.cornerMode == 'A')
		{
			return lYaw > 0-ABangleCutoff;
		}
		else
		{
			assert(a.cornerMode == 'lean');
			return lYaw < -50 || lYaw > 8; // TODO
		}
	}
	else
	{
		assert(cornerDirection == 'right');
		if (a.cornerMode == 'B')
		{
			return lYaw > ABangleCutoff || lYaw < -12;
		}
		else if (a.cornerMode == 'A')
		{
			return lYaw < ABangleCutoff;
		}
		else
		{
			assert(a.cornerMode == 'lean');
			return lYaw > 50 || lYaw < -8; // TODO
		}
	}
}

// getCornerMode will return 'none' if no corner modes are acceptable.
function name getCornerMode(HodNode inode, optional vector ipoint = vec_undefined)
{
	local float lYaw;
	lYaw = 0;
	if (vec_isdefined(ipoint))
		lYaw = inode.GetYawToOrigin(ipoint);

	if (cornerDirection == 'left')
	{
		if (shouldLean())
		{
			if (lYaw >= -40 && lYaw <= 0)
				return 'lean';
		}

		if (lYaw > 14)
			return 'none';
		if (lYaw < 0-ABangleCutoff)
			return 'A';
	}
	else
	{
		assert(cornerDirection == 'right');

		if (shouldLean())
		{
			if (lYaw <= 40 && lYaw >= 0)
				return 'lean';
		}

		if (lYaw < -12)
			return 'none';
		if (lYaw > ABangleCutoff)
			return 'A';
	}
	return 'B';
}

// getBestStepOutPos never returns 'none'.
// it returns the best stepoutpos that we can get to from our current one.
function name getBestStepOutPos()
{
	local float lYaw;
	lYaw = 0;
	if (animscripts_utility.canSuppressEnemy())
		lYaw = coverNode.GetYawToOrigin(animscripts_utility.getEnemySightPos());

	if (a.cornerMode == 'lean')
		return 'lean';
	else if (a.cornerMode == 'B')
	{
		if(cornerDirection == 'left')
		{
			if(lYaw < 0-ABangleCutoff)
				return 'A';
		}
		else if(cornerDirection == 'right')
		{
			if(lYaw > ABangleCutoff)
				return 'A';
		}
		return 'B';
	}
	else if (a.cornerMode == 'A')
	{
		if(cornerDirection == 'left')
		{
			if(lYaw > 0-ABangleCutoff)
				return 'B';
		}
		else if(cornerDirection == 'right')
		{
			if(lYaw < ABangleCutoff)
				return 'B';
		}
		return 'A';
	}
}

function changeStepOutPos()
{
	run (new(self) class'corner_changeStepOutPos', false);
}

function bool ShouldLean()
{
	if (a.pose != 'stand')
		return false;

	if (team == 'allies')
		return true;
	if (animscripts_utility.isPartiallySuppressedWrapper())
		return true;
	return false;
}

function DoNoteTracksWithEndon(name iAnimName, optional bool newThread = false)
{
	local corner_DoNoteTracksWithEndon task;
	task = new(self) class'corner_DoNoteTracksWithEndon';
	task.iAnimName = iAnimName;
	run (task, newThread);
}

function StartAiming(name iSpot, bool iFullbody, float iTransTime, optional bool newThread = false)
{
	local corner_StartAiming task;
	task = new(self) class'corner_StartAiming';
	task.iSpot = iSpot;
	task.iFullbody = iFullbody;
	task.iTransTime = iTransTime;
	run (task, newThread);
}

function ChangeAiming(name iSpot, bool iFullbody, float iTransTime, optional bool newThread = false)
{
	local corner_ChangeAiming task;
	task = new(self) class'corner_ChangeAiming';
	task.iSpot = iSpot;
	task.iFullbody = iFullbody;
	task.iTransTime = iTransTime;
	run (task, newThread);
}

function StopAiming(float lTransTime)
{
	assert(cornerAiming);
	cornerAiming = false;

	// turn off shooting
	clearAnim('add_fire', lTransTime);
	// and turn off aiming
	animscripts_shared.setAnimAimWeight(0, lTransTime);
}

function SetAimingParams(name iSpot, bool ifullbody, float itransTime, bool ilean)
{
	//assert(isdefined(ifullbody));

	spot = iSpot; // undefined is ok

	setanimlimited('exposed_modern', 1, itransTime);
	setanimlimited('exposed_aiming', 1, itransTime);
	animscripts_shared.setAnimAimWeight(1, itransTime);

	if (ilean)
	{
		setAnimLimited(animscripts_utility.animArray('lean_aim_straight'), 1, itransTime);

		setAnimKnobLimited(animscripts_utility.animArray('lean_aim_left'), 1, itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('lean_aim_right'), 1, itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('lean_aim_up'), 1, itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('lean_aim_down'), 1, itransTime);
	}
	else if (ifullbody)
	{
		setAnimLimited(animscripts_utility.animarray('straight_level'), 1, itransTime);

		setAnimKnobLimited(animscripts_utility.animArray('add_aim_up'),1,itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('add_aim_down'),1,itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('add_aim_left'),1,itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('add_aim_right'),1,itransTime);
	}
	else
	{
		setAnimLimited(animscripts_utility.animarray('straight_level'), 0, itransTime);

		setAnimKnobLimited(animscripts_utility.animArray('add_turn_aim_up'),1,itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('add_turn_aim_down'),1,itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('add_turn_aim_left'),1,itransTime);
		setAnimKnobLimited(animscripts_utility.animArray('add_turn_aim_right'),1,itransTime);
	}
}

function StepOut(optional bool newThread = false) /* bool */
{
	run (new(self) class'corner_stepOut', newThread);
}

function StepOutAndShootEnemy()
{
	run (new(self) class'corner_StepOutAndShootEnemy', false);
}

//canDoRambo()
//{
//	return animArrayAnyExist('rambo') && self.team != 'allies';
//}
//
//haventRamboedWithinTime(time)
//{
//	if (!isdefined(self.lastRamboTime))
//		return true;
//	return gettime() - self.lastRamboTime > time * 1000;
//}
//
///*ramboStepOut()
//{
//	assert(animArrayAnyExist('rambo'));
//	ramboanim = animArrayPickRandom('rambo');
//
//	if (!isPathClear())
//		return false;
//
//	self.a.special = 'none';
//
//	self animMode ('zonly_physics');
//	self.keepClaimedNodeInGoal = true;
//
//	self setFlaggedAnimKnobAllRestart('rambo', ramboanim, %body, 1, 0);
//	self animscripts\shared::DoNoteTracks('rambo');
//
//	self.lastRamboTime = gettime();
//
//	self.keepClaimedNodeInGoal = false;
//
//	return true;
//}*/

function ShootAsTold(optional bool newThread = false)
{
	run (new(self) class'corner_ShootAsTold', newThread);
}

function ShootUntilShootBehaviorChangeForTime(float iTime, optional bool newThread = false)
{
	local corner_ShootUntilShootBehaviorChangeForTime task;
	task = new(self) class'corner_ShootUntilShootBehaviorChangeForTime';
	task.iTime = iTime;
	run (task, newThread);
}

function NotifyStopShootingAfterTime(float iTime, optional bool newThread = false)
{
	local corner_NotifyStopShootingAfterTime task;
	task = new(self) class'corner_NotifyStopShootingAfterTime';
	task.iTime = iTime;
	run (task, newThread);
}

function ShootUntilShootBehaviorChange_corner(bool iRunAngleRangeThread, optional bool newThread = false)
{
	local corner_ShootUntilShootBehaviorChange_corner task;
	task = new(self) class'corner_ShootUntilShootBehaviorChange_corner';
	task.iRunAngleRangeThread = iRunAngleRangeThread;
	run (task, newThread);
}

function StandIdleThread(optional bool newThread = false)
{
	run (new(self) class'corner_StandIdleThread', newThread);
}

function EndStandIdleThread()
{
	a.standIdleThread = false;
	notify('end_stand_idle_thread');
}

function StandIdleThreadInternal(optional bool newThread = false)
{
	run (new(self) class'corner_StandIdleThreadInternal', newThread);
}

function AngleRangeThread(optional bool newThread = false)
{
	run (new(self) class'corner_AngleRangeThread', newThread);
}

//showstate()
//{
//	self.enemy endon('death');
//	self endon('enemy');
//	self endon('stopshowstate');
//
//	while(1)
//	{
//		wait .05;
//		print3d(self.origin + (0,0,60), self.statetext);
//	}
//}

function bool CanReturnToCover(bool idoMidpointCheck)
{
	local vector lMidPoint;

	if (!anim.maymoveCheckEnabled)
		return true;

	if (idoMidpointCheck)
	{
		lMidPoint = getPredictedPathMidpoint();

		if (!mayMoveToPoint(lMidPoint))
			return false;

		return mayMoveFromPointToPoint(lMidPoint, coverNode.origin);
	}
	else
	{
		return mayMoveToPoint(coverNode.origin);
	}
}

function ReturnToCover(optional bool newThread = false)
{
	run (new(self) class'corner_ReturnToCover', newThread);
}

function ResetAnimSpecial(float iDelay, optional bool newThread = false)
{
	local corner_ResetAnimSpecial task;
	task = new(self) class'corner_ResetAnimSpecial';
	task.iDelay = iDelay;
	run (task, newThread);
}

function Blindfire()
{
	run (new(self) class'corner_BlindFire', false);
}

//linethread(a,b,col)
//{
//	if (!isdefined(col))
//		col = (1,1,1);
//	for (i = 0; i < 100; i++)
//	{
//		line(a,b,col);
//		wait .05;
//	}
//}

function TryThrowingGrenadeStayHidden(HodEntity iThrowAt)
{
	TryThrowingGrenade(iThrowAt, true);
}

function TryThrowingGrenade(HodEntity iThrowAt, bool iSafe)
{
	local corner_TryThrowingGrenade task;
	task = new(self) class'corner_TryThrowingGrenade';
	task.iThrowAt = iThrowAt;
	task.iSafe = iSafe;
	run (task, false);
}

//printYawToEnemy()
//{
//	println('yaw: ',self getYawToEnemy());
//}

function LookForEnemy(float iLookTime)
{
	local corner_LookForEnemy task;
	task = new(self) class'corner_LookForEnemy';
	task.iLookTime = iLookTime;
	run (task, false);
}


function PeekOut(optional bool newThread = false)
{
	run (new(self) class'corner_PeekOut', newThread);
}

function bool CanStopPeeking()
{
	return mayMoveToPoint(coverNode.origin);
}

function FastLook()
{
	run (new(self) class'corner_FastLook', false);
}

function CornerReload()
{
	run (new(self) class'corner_CornerReload', false);
}

function bool isPathClear(name istepoutanim, bool idoMidpointCheck)
{
	local vector iMidPoint;

	if (!anim.maymoveCheckEnabled)
		return true;

	if (idoMidpointCheck)
	{
		iMidPoint = getPredictedPathMidpoint();

		if (!maymovetopoint(iMidPoint))
			return false;

		return maymovefrompointtopoint(iMidPoint, animscripts_utility.getAnimEndPos(istepoutanim));
	}
	else
	{
		return maymovetopoint(animscripts_utility.getAnimEndPos(istepoutanim));
	}
}

function vector getPredictedPathMidpoint()
{
	local Angle lAngles;
	local vector lRight;

	lAngles = coverNode.angles;
	lRight = anglestoright(lAngles);
	switch (a.script)
	{
		case 'cover_left':
			lRight = vectorScale(lRight, -36.0*FInch);
		break;

		case 'cover_right':
			lRight = vectorScale(lRight, 36.0*FInch);
		break;

		default:
			assert (false);
//			assertEx(0, 'What kind of node is this????');
	}

	return coverNode.origin + lRight * vect(1, 1, 0);
}

function Idle()
{
	run (new(self) class'corner_idle', false);
}

function Flinch()
{
	run (new(self) class'corner_Flinch', false);
}

function playIdleAnimation(name iIdleAnim, bool iNeedsRestart, optional bool newThread = false)
{
	local corner_PlayIdleAnimation task;
	task = new(self) class'corner_PlayIdleAnimation';
	task.iIdleAnim = iIdleAnim;
	task.iNeedsRestart = iNeedsRestart;
	run (task, newThread);
}

function set_anim_array_hiding(name iStance);
function set_anim_array_exposed(name iStance)
{
	switch (iStance)
	{
	case 'stand':
		set_standing_animarray_aiming();
		break;

	case 'crouch':
		set_crouching_animarray_aiming();
		break;

	default:
		assert (false);
	}
}

function set_anim_array(name iStance)
{
	set_anim_array_hiding(iStance);
	set_anim_array_exposed(iStance);
}

function set_anim_array_aiming(name iStance)
{
	set_anim_array_exposed(iStance);
}

function transitionToStance(name iStance, optional bool newThread = false)
{
	local corner_transitionToStance task;
	task = new(self) class'corner_transitionToStance';
	task.iStance = iStance;
	run (task, newThread);
}

function GoToCover(name iCoverAnim, float iTransTime, float iPlayTime, optional bool newThread = false)
{
	local corner_GoToCover task;
	task = new(self) class'corner_GoToCover';
	task.iCoverAnim = iCoverAnim;
	task.iTransTime = iTransTime;
	task.iPlayTime = iPlayTime;
	run (task, newThread);
}

//drawoffset()
//{
//	self endon('killanimscript');
//	for(;;)
//	{
//		line(self.node.origin + (0,0,20),(0,0,20) + self.node.origin + vectorscale(anglestoright(self.node.angles + (0,0,0)),16));
//		wait(0.05);
//	}
//}


function set_standing_animarray_aiming()
{
	local name lLeanFire;

//	if(!isdefined(self.a.array))
//		assertmsg('set_standing_animarray_aiming_AandC::this function needs to be called after the initial corner set_ functions');

	SetAnimArrayE('add_aim_up', 'stand_aim_8');
	SetAnimArrayE('add_aim_down', 'stand_aim_2');
	SetAnimArrayE('add_aim_left', 'stand_aim_4');
	SetAnimArrayE('add_aim_right', 'stand_aim_6');
	SetAnimArrayE('add_turn_aim_up', 'stand_turn_aim_8');
	SetAnimArrayE('add_turn_aim_down', 'stand_turn_aim_2');
	SetAnimArrayE('add_turn_aim_left', 'stand_turn_aim_4');
	SetAnimArrayE('add_turn_aim_right', 'stand_turn_aim_6');
	SetAnimArrayE('straight_level', 'stand_aim');

	if (a.cornerMode == 'lean')
	{
		// use the lean animations set up in cover_left and cover_right.gsc
		lLeanFire = animscripts_utility.animArray('lean_fire');
		SetAnimArrayE('fire', lLeanFire);
		SetAnimArrayE('single', animscripts_utility.animArray('lean_single'));

		SetAnimArrayE('semi2', lLeanFire);
		SetAnimArrayE('semi3', lLeanFire);
		SetAnimArrayE('semi4', lLeanFire);
		SetAnimArrayE('semi5', lLeanFire);

		SetAnimArrayE('burst2', lLeanFire);
		SetAnimArrayE('burst3', lLeanFire);
		SetAnimArrayE('burst4', lLeanFire);
		SetAnimArrayE('burst5', lLeanFire);
		SetAnimArrayE('burst6', lLeanFire);
	}
	else
	{
		SetAnimArrayE('fire', 'stand_fire_auto');
		SetAnimArrayE('semi2', 'stand_fire_semi2');
		SetAnimArrayE('semi3', 'stand_fire_semi3');
		SetAnimArrayE('semi4', 'stand_fire_semi4');
		SetAnimArrayE('semi5', 'stand_fire_semi5');

//		if (self usingShotgun())
//			self.a.array['single'] = array(%shotgun_stand_fire_1A);
//		else
		SetAnimArrayE('single', 'stand_fire_single');

		SetAnimArrayE('burst2', 'stand_fire_burst3'); // (will be limited to 2 shots)
		SetAnimArrayE('burst3', 'stand_fire_burst3');
		SetAnimArrayE('burst4', 'stand_fire_burst4');
		SetAnimArrayE('burst5', 'stand_fire_burst5');
		SetAnimArrayE('burst6', 'stand_fire_burst6');
	}
	SetAnimArrayE('exposed_idle', 'stand_idle_v1');
	SetAnimArray('exposed_idle', 'stand_idle_v2');
	SetAnimArray('exposed_idle', 'stand_idle_v3');
}

function set_crouching_animarray_aiming()
{
//	if(!isdefined(self.a.array))
//		assertmsg('set_standing_animarray_aiming_AandC::this function needs to be called after the initial corner set_ functions');

	SetAnimArrayE('add_aim_up', 'crouch_aim_8');
	SetAnimArrayE('add_aim_down', 'crouch_aim_2');
	SetAnimArrayE('add_aim_left', 'crouch_aim_4');
	SetAnimArrayE('add_aim_right', 'crouch_aim_6');
	SetAnimArrayE('add_turn_aim_up', 'crouch_turn_aim_8');
	SetAnimArrayE('add_turn_aim_down', 'crouch_turn_aim_2');
	SetAnimArrayE('add_turn_aim_left', 'crouch_turn_aim_4');
	SetAnimArrayE('add_turn_aim_right', 'crouch_turn_aim_6');
	SetAnimArrayE('straight_level', 'crouch_aim');

	SetAnimArrayE('fire', 'crouch_fire_auto');
	SetAnimArrayE('semi2', 'crouch_fire_semi2');
	SetAnimArrayE('semi3', 'crouch_fire_semi3');
	SetAnimArrayE('semi4', 'crouch_fire_semi4');
	SetAnimArrayE('semi5', 'crouch_fire_semi5');
//
//	if (self usingShotgun())
//		self.a.array['single'] = array(%shotgun_crouch_fire);
//	else
	SetAnimArrayE('single', 'crouch_fire_single');

	SetAnimArrayE('burst2', 'crouch_fire_burst3'); // (will be limited to 2 shots)
	SetAnimArrayE('burst3', 'crouch_fire_burst3');
	SetAnimArrayE('burst4', 'crouch_fire_burst4');
	SetAnimArrayE('burst5', 'crouch_fire_burst5');
	SetAnimArrayE('burst6', 'crouch_fire_burst6');

	SetAnimArrayE('exposed_idle', 'crouch_idle_v1');
	SetAnimArray('exposed_idle', 'crouch_idle_v2');
	SetAnimArray('exposed_idle', 'crouch_idle_v3');
}

function set_aiming_limits()
{
	rightAimLimit = 45;
	leftAimLimit = -45;
	upAimLimit = 45;
	downAimLimit = -45;
}

//runCombat()
//{
//	self notify('killanimscript');
//	self thread animscripts\combat::main();
//}
