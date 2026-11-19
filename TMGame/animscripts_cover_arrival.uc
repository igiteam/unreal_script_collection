class animscripts_cover_arrival extends Object within HodAI
	dependson(HodAI)
	dependson(animscripts_utility)
	dependson(general_human);

var Actor ArrivalFocusTarget;

struct NodeTransitionAngle
{
	var float transitions[10];
	var int transIndex[10];
};

function main(optional bool newThread = false)
{
	run (new(self) class'arrival_main', newThread);
}

function float GetNodeStanceYawOffset(name iapproachtype)
{
	// returns the base stance's yaw offset when hiding at a node, based off the approach type

	if (iapproachtype == 'left' || iapproachtype == 'left_crouch')
		return -90.0;
	else if (iapproachtype == 'right' || iapproachtype == 'right_crouch')
		return 90.0;

	return 0;
}


//canUseSawApproach(node)
//{
//	if (self.weapon != "saw" && self.weapon != "rpd")
//		return false;
//
//	if (!isDefined(node.turretInfo))
//		return false;
//
//	if (node.type != "Cover Stand" && node.type != "Cover Prone" && node.type!= "Cover Crouch")
//		return false;
//
//	if (isDefined(self.enemy) && distanceSquared(self.enemy.origin, node.origin) < 256*256)
//		return false;
//
//	if (GetNodeYawToEnemy() > 40 || GetNodeYawToEnemy() < -40)
//		return false;
//
//	return true;
//}

function DetermineNodeApproachType(HodNode inode)
{
	local int typeId;
	local int stance;

	//if (canUseSawApproach(inode))
	//{
	//	if (inode.type == "Cover Stand")
	//		inode.approachtype = "stand_saw";
	//	if (inode.type == "Cover Crouch")
	//		inode.approachtype = "crouch_saw";
	//	else if (inode.type == "Cover Prone")
	//		inode.approachtype = "prone_saw";
	//	assert(isdefined(inode.approachtype));
	//	return;
	//}

	typeId = NodeTypeID(inode.type);
	if (typeId < 0)
		return;

	stance = int(inode.isNodeDontStand() && !inode.isNodeDontCrouch());

	inode.approachtype = anim.approach_types[typeId].data[stance];
}

function GetMaxDirectionsAndExcludeDirFromApproachType(name iapproachtype, out int maxDirections, out int excludeDir)
{
	if (iapproachtype == 'left' || iapproachtype == 'left_crouch')
	{
		maxDirections = 9;
		excludeDir = 9;
	}
	else if (iapproachtype == 'right' || iapproachtype == 'right_crouch')
	{
		maxDirections = 9;
		excludeDir = 7;
	}
	else if (iapproachtype == 'stand' || iapproachtype == 'crouch' || iapproachtype == 'stand_saw' || iapproachType == 'crouch_saw')
	{
		maxDirections = 6;
		excludeDir = -1;
	}
	else if (iapproachtype == 'exposed' || iapproachtype == 'exposed_crouch')
	{
		maxDirections = 9;
		excludeDir = -1;
	}
	else if (iapproachtype == 'prone_saw')
	{
		maxDirections = 3;
		excludeDir = -1;
	}
	else
	{
		assert (false);
	}
}

//shouldApproachToExposed()
//{
//	// decide whether it's a good idea to go directly into the exposed position as we approach this node.
//
//	if (!isValidEnemy(self.enemy))
//		return false; // nothing to shoot!
//
//	if (self NeedToReload(0.5))
//		return false;
//
//	if (self animscripts_utility.isSuppressedWrapper())
//		return false; // too dangerous, we need cover
//
//	// path nodes have no special "exposed" position
//	if (self.node.approachtype == "exposed" || self.node.approachtype == "exposed_crouch")
//		return false;
//
//	// no arrival animations into exposed for left/right crouch
//	if (self.node.approachtype == "left_crouch" || self.node.approachtype == "right_crouch")
//		return false;
//
//	return canSeePointFromExposedAtNode(self.enemy getShootAtPos(), self.node);
//}
//
//// gets the point and angle to approach in order to arrive in exposed
//getExposedApproachData()
//{
//	returnobj = spawnstruct();
//
//	if (self.node.approachtype == "stand")
//	{
//		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta(self.node.angles, getMoveDelta(%coverstand_hide_2_aim));
//		returnobj.yaw = self.node.angles[1];
//	}
//	else if (self.node.approachtype == "crouch")
//	{
//		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta(self.node.angles, getMoveDelta(%covercrouch_hide_2_stand));
//		returnobj.yaw = self.node.angles[1];
//	}
//	else if (self.node.approachtype == "left" || self.node.approachtype == "left_crouch")
//	{
//		cornerMode = animscripts\corner::getCornerMode(self.node, self.enemy getShootAtPos());
//		assert(cornerMode != "none"); // we should have caught this case within canSeePointFromExposedAtNode() from inside shouldApproachToExposed()
//
//		hide_to_exposed_anim = undefined;
//		if (self.node.approachtype == "left")
//		{
//			if (cornerMode == "A")
//				hide_to_exposed_anim = %cornerL_stand_trans_hide_2_A;
//			else
//				hide_to_exposed_anim = %cornerL_stand_trans_hide_2_B;
//		}
//		else
//		{
//			assert(self.node.approachtype == "left_crouch");
//			if (cornerMode == "A")
//				hide_to_exposed_anim = %cornerL_crouch_trans_hide_2_A;
//			else
//				hide_to_exposed_anim = %cornerL_crouch_trans_hide_2_B;
//		}
//
//		baseAngles = self.node.angles;
//		baseAngles = (baseAngles[0], baseAngles[1] + getNodeStanceYawOffset(self.node.approachtype), baseAngles[2]);
//
//		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta(baseAngles, getMoveDelta(hide_to_exposed_anim));
//		returnobj.yaw = baseAngles[1] + getAngleDelta(hide_to_exposed_anim)[1];
//	}
//	else if (self.node.approachtype == "right" || self.node.approachtype == "right_crouch")
//	{
//		cornerMode = animscripts\corner::getCornerMode(self.node, self.enemy getShootAtPos());
//		assert(cornerMode != "none"); // we should have caught this case within canSeePointFromExposedAtNode() from inside shouldApproachToExposed()
//
//		hide_to_exposed_anim = undefined;
//		if (self.node.approachtype == "right")
//		{
//			if (cornerMode == "A")
//				hide_to_exposed_anim = %cornerR_stand_trans_hide_2_A;
//			else
//				hide_to_exposed_anim = %cornerR_stand_trans_hide_2_B;
//		}
//		else
//		{
//			assert(self.node.approachtype == "right_crouch");
//			if (cornerMode == "A")
//				hide_to_exposed_anim = %cornerR_crouch_trans_hide_2_A;
//			else
//				hide_to_exposed_anim = %cornerR_crouch_trans_hide_2_B;
//		}
//
//		baseAngles = self.node.angles;
//		baseAngles = (baseAngles[0], baseAngles[1] + getNodeStanceYawOffset(self.node.approachtype), baseAngles[2]);
//
//		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta(baseAngles, getMoveDelta(hide_to_exposed_anim));
//		returnobj.yaw = baseAngles[1] + getAngleDelta(hide_to_exposed_anim)[1];
//	}
//	else
//	{
//		assertmsg("bad node approach type: " + self.node.approachtype);
//	}
//
//	return returnobj;
//}
//
//calculateNodeOffsetFromAnimationDelta(nodeAngles, delta)
//{
//	// in the animation, forward = +x and right = -y
//	right = anglestoright(nodeAngles);
//	forward = anglestoforward(nodeAngles);
//
//	return vectorScale(forward, delta[0]) + vectorScale(right, 0-delta[1]);
//}

function SetupApproachNode(bool firstTime, optional bool newThread = false)
{
	local arrival_SetupApproachNode task;
	task = new(self) class'arrival_SetupApproachNode';
	task.firstTime = firstTime;
	run (task, newThread);
}

function StartCornerApproach(name iApproachType, vector iApproachPoint, float iApproachNodeYaw, float iApproachFinalYaw, vector iApproach_dir, optional bool newThread = false)
{
	local arrival_StartCornerApproach task;
	task = new(self) class'arrival_StartCornerApproach';
	task.iApproachType = iApproachType;
	task.iApproachPoint = iApproachPoint;
	task.iApproachNodeYaw = iApproachNodeYaw;
	task.iApproachFinalYaw = iApproachFinalYaw;
	task.iApproach_dir = iApproach_dir;

	run (task, newThread);
}

function int CheckArrivalEnterPositions(vector iApproachpoint, float iApproachYaw, name iApproachtype, vector iApproach_dir, int maxDirections, int excludeDir)
{
	local NodeTransitionAngle angleDataObj;
	local int lNumAttempts;
	local int i;
	local float lDistToApproachPoint;
	local float lDistToAnimStart;
	local vector lSelfToAnimStart;
	local vector lAnimStartToNode;
	local float lCosAngle;

	local int oApproachNumber;

	calculateNodeTransitionAngles(angleDataObj, iApproachtype, true, iApproachYaw, iApproach_dir, maxDirections, excludeDir);
	sortNodeTransitionAngles(angleDataObj, maxDirections);

	oApproachNumber = -1;

	lNumAttempts = 2;
	if (iApproachtype == 'exposed')
		lNumAttempts = 1;

	for (i = 1; i <= lNumAttempts; i++)
	{
		assert(angleDataObj.transIndex[i] != excludeDir); // shouldn't hit excludeDir unless lNumAttempts is too big

		oApproachNumber = angleDataObj.transIndex[i];
		if (!checkCoverEnterPos(iApproachpoint, iApproachYaw, iApproachtype, oApproachNumber))
			continue;

		break;
	}

	if (i > lNumAttempts)
		return -1;

	// if AI is closer to node than coverEnterPos is, don't do arrival
	lDistToApproachPoint = distanceSquared(iApproachpoint, origin);
	lDistToAnimStart = distanceSquared(iApproachpoint, coverEnterPos);
	if (lDistToApproachPoint < lDistToAnimStart * 2 * 2)
	{
		if (lDistToApproachPoint < lDistToAnimStart)
			return -1;

		// if AI is less than twice the distance from the node than the beginning of the approach animation,
		// make sure the angle we'll turn when we start the animation is small.
		lSelfToAnimStart = vectorNormalize(coverEnterPos - origin);
		lAnimStartToNode = vectorNormalize(iApproachpoint - coverEnterPos);
		lCosAngle = vectorDot(lSelfToAnimStart, lAnimStartToNode);

		if (lCosAngle < 0.819) // 0.819 == cos(35)
			return -1;
	}

	return oApproachNumber;
}

function DoLastMinuteExposedApproachWrapper(optional bool newThread = false)
{
	run (new(self) class'arrival_DoLastMinuteExposedApproachWrapper', newThread);
}

function WatchGoalChanged(optional bool newThread = false)
{
	run (new(self) class'arrival_WatchGoalChanged', newThread);
}

function DoLastMinuteExposedApproach(optional bool newThread = false)
{
	run (new(self) class'arrival_DoLastMinuteExposedApproach', newThread);
}

function WaitForPathGoalPos()
{
	run (new(self) class'arrival_WaitForPathGoalPos', false);
}

function AlignToNodeAngles(optional bool newThread = false)
{
	run (new(self) class'arrival_AlignToNodeAngles', newThread);
}

function ResetOrientModeOnGoalChange(optional bool newThread = false)
{
	run (new(self) class'arrival_ResetOrientModeOnGoalChange', newThread);
}

function StartMoveTransition(optional bool newThread = false)
{
	run(new(self) class'arrival_StartMoveTransition', newThread);
}

//str(val)
//{
//	if (!isdefined(val))
//		return "{undefined}";
//	return val;
//}

function DoCoverExitAnimation(name iexittype, int iapproachNumber)
{
	local arrival_DoCoverExitAnimation task;
	task = new(self) class'arrival_DoCoverExitAnimation';
	task.iexittype = iexittype;
	task.iapproachNumber = iapproachNumber;
	run(task, false);
}

function FaceEnemyOrMotionAfterABit(optional bool newThread = false)
{
	run(new(self) class'arrival_FaceEnemyOrMotionAfterABit', newThread);
}

function DoNoteTracksForExit(name animname, bool hasExitAlign, optional bool newThread = false)
{
	local arrival_DoNoteTracksForExit task;
	task = new(self) class'arrival_DoNoteTracksForExit';
	task.animname = animname;
	task.hasExitAlign = hasExitAlign;
	run (task, newThread);
}

///*RestartAllMoveAnims(timeUntilTheyWrap)
//{
//	// rely on loopsynch to reset the time of all movement animations
//	fractionalTimeUntilTheyWrap = timeUntilTheyWrap / getAnimLength(%run_lowready_F);
//	// this doesn't work unless the anim has a goal weight > 0
//	self setanim(%run_lowready_F, .01, 1000);
//	self setanim(%precombatrun1, .01, 1000);
//	self setAnimTime(%run_lowready_F, 1 - fractionalTimeUntilTheyWrap);
//	self setAnimTime(%precombatrun1, 1 - fractionalTimeUntilTheyWrap);
//}*/
//
//
//drawVec(start, end, duration, color)
//{
//	for(i = 0; i < duration * 100; i++)
//	{
//		line(start + (0,0,30), end + (0,0,30), color);
//		wait 0.05;
//	}
//}
//
//drawApproachVec(approach_dir)
//{
//	self endon("killanimscript");
//	for(;;)
//	{
//		if(!isdefined(self.node))
//			break;
//		line(self.node.origin + (0,0,20), (self.node.origin - vectorscale(approach_dir,64)) + (0,0,20));
//		wait(0.05);
//	}
//}

function CalculateNodeTransitionAngles
(out NodeTransitionAngle angleDataObj
 , name iapproachtype
 , bool isarrival
 , float arrivalYaw
 , vector approach_dir
 , int maxDirections
 , int excludeDir)
{
	local TransAngle anglearray;
	local int sign;
	local float offset;
	local int approachTypeId;
	local int i;
	local Angle langle;
	local vector dir;

	sign = 1;
	offset = 0;

	approachTypeId = TransTypeID(iapproachtype);
	if (isarrival)
	{
		anglearray = anim.coverTransAngles[approachTypeId];
		sign = -1;
		offset = 0;
	}
	else
	{
		anglearray = anim.coverExitAngles[approachTypeId];
		sign = 1;
		offset = 180;
	}

	for (i = 1; i <= maxDirections; i++)
	{
		angleDataObj.transIndex[i] = i;

		if (i == 5 || i == excludeDir || anglearray.data[i] == invalid_float)
		{
			angleDataObj.transitions[i] = -1.0003;	// cos180 - epsilon
			continue;
		}

		langle.pitch = 0;
		langle.yaw = arrivalYaw + sign * anglearray.data[i] + offset;
		langle.roll = 0;

		dir = vectornormalize(anglestoforward(langle));
		angleDataObj.transitions[i] = vectordot(approach_dir, dir);
	}
}

///#
//printdebug(pos, offset, text, color, linecolor)
//{
//	for (i = 0; i < 20*5; i++)
//	{
//		line(pos, pos+offset, linecolor);
//		print3d(pos + offset, text, (color,color,color));
//		wait .05;
//	}
//}
//#/


// TODO: probably better done in code
// (actually, for an array of 8 elements, insertion sort should be fine)
function sortNodeTransitionAngles(out NodeTransitionAngle angleDataObj, int maxDirections)
{
	local int i, j;
	local float currentValue;
	local int currentIndex;

	for (i = 2; i <= maxDirections; i++)
	{
		currentValue = angleDataObj.transitions[ angleDataObj.transIndex[i] ];
		currentIndex = angleDataObj.transIndex[i];

		for (j = i-1; j >= 1; j--)
		{
			if (currentValue < angleDataObj.transitions[ angleDataObj.transIndex[j] ])
				break;

			angleDataObj.transIndex[j + 1]  = angleDataObj.transIndex[j];
		}

		angleDataObj.transIndex[j + 1] = currentIndex;
	}
}

function bool CheckCoverExitPos(vector exitpoint, float exityaw, name exittype, int iapproachNumber)
{
	local Angle langle;
	local vector forwardDir;
	local vector rightDir;
	local int exittypeid;
	local vector forward;
	local vector right;
	local vector exitPos;
	local bool isExposedApproach;
	local vector finalExitPos;

	langle.pitch = 0;
	langle.yaw = exityaw;
	langle.roll = 0;

	forwardDir = anglestoforward(langle);
	rightDir = anglestoright(langle);

	exittypeid = TransTypeID(exittype);

	forward = vectorscale(forwardDir, anim.coverExitDist[exittypeid].data[iapproachNumber].x);
	right   = vectorscale(rightDir, anim.coverExitDist[exittypeid].data[iapproachNumber].y);

	exitPos = exitpoint + forward - right;
	coverExitPos = exitPos;

	isExposedApproach = (exittype == 'exposed' || exittype == 'exposed_crouch');

	if (!isExposedApproach && !checkCoverExitPosWithPath(exitPos))
		return false;

	if (!maymovefrompointtopoint(origin, exitPos))
		return false;

	if (iapproachNumber <= 6 || isExposedApproach)
		return true;

	assert(exittype == 'left' || exittype == 'left_crouch' || exittype == 'right' || exittype == 'right_crouch');

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the first part, from node to corner, now doing from corner to end of exit anim)
	forward = vectorscale(forwardDir, anim.coverExitPostDist[exittypeid].data[iapproachNumber].x);
	right   = vectorscale(rightDir, anim.coverExitPostDist[exittypeid].data[iapproachNumber].y);

	finalExitPos = exitPos + forward - right;
	coverExitPos = finalExitPos;

	return maymovefrompointtopoint(exitPos, finalExitPos);
}

function bool CheckCoverEnterPos(vector iArrivalpoint, float iArrivalYaw, name iApproachType, int iApproachNumber)
{
	local int iApproachTypeID;
	local Angle lAngle;
	local vector lForwardDir;
	local vector lRightDir;
	local vector lForward;
	local vector lRight;
	local vector lEnterPos;
	local vector lOriginalEnterPos;

	iApproachTypeID = TransTypeID(iApproachType);

	lAngle.yaw = iArrivalYaw - anim.coverTransAngles[iApproachTypeID].data[iApproachNumber];

	lForwardDir = anglestoforward(lAngle);
	lRightDir = anglestoright(lAngle);

	lForward = vectorscale(lForwardDir, anim.coverTransDist[iApproachTypeID].data[iApproachNumber].x);
	lRight   = vectorscale(lRightDir, anim.coverTransDist[iApproachTypeID].data[iApproachNumber].y);

	lEnterPos = iArrivalpoint - lForward - lRight;
	coverEnterPos = lEnterPos;

	if (!(maymovefrompointtopoint(lEnterPos, iArrivalpoint)))
		return false;

	if (iApproachNumber <= 6 || iApproachType== 'exposed' || iApproachType== 'exposed_crouch')
		return true;

	assert(iApproachType == 'left' || iApproachType == 'left_crouch' || iApproachType == 'right' || iApproachType == 'right_crouch');

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the second part, from corner to node, now doing from start of enter anim to corner)

	lForward = vectorscale(lForwardDir, anim.coverTransPreDist[iApproachTypeID].data[iApproachNumber].x);
	lRight   = vectorscale(lRightDir, anim.coverTransPreDist[iApproachTypeID].data[iApproachNumber].y);

	lOriginalEnterPos = lEnterPos - lForward - lRight;
	coverEnterPos = lOriginalEnterPos;

	return maymovefrompointtopoint(lOriginalEnterPos, lEnterPos);
}


//ShouldDoMiniArrival()
//{
//	node = self.node;
//	assert(isdefined(node));
//
//	if (getdvar("scr_miniarrivals") != "1" && getdvar("scr_miniarrivals") != "on")
//		return false;
//
//	if (distanceSquared(self.origin, node.origin) > 40 * 40)
//		return false;
//
//	determineNodeApproachType(node);
//
//	// only cover stand for now
//	if (!isdefined(node.approachtype) || node.approachtype != "stand")
//		return false;
//
//	if (!self mayMoveToPoint(node.origin))
//		return false;
//
//	return true;
//}
//
//StartMiniArrival()
//{
//	self.doMiniArrival = true;
//	assert(isdefined(self.node));
//	self.miniArrivalNode = self.node;
//	self startcoverarrival(self.origin, self.angles[1]);
//}
//
//DoMiniArrival(node)
//{
//	arrivalanim = decideMiniArrivalAnim(node, self.origin);
//
//	animtime = getAnimLength(arrivalanim);
//
//	transTime = 0.2;
//	if (self.a.movement != "stop")
//		transTime = animtime * 0.65;
//
//	self setAnimKnobAllRestart(arrivalAnim, %body, 1, transTime);
//
//	totalAnimDist = length(getMoveDelta(arrivalAnim, 0, 1));
//	if (totalAnimDist <= 0)
//		totalAnimDist = 0.5;
//
//	numFrames = floor(animtime * 20);
//
//	startPos = self.origin;
//	targetPos = node.origin;
//	startYaw = self.angles[1];
//	targetYaw = node.angles[1];
//	if (isdefined(node.approachtype))
//		targetYaw += getNodeStanceYawOffset(node.approachtype);
//	targetYaw = startYaw + AngleClamp180(targetYaw - startYaw);
//
//	for (i = 0; i < numFrames; i++)
//	{
//		timefrac = (i + 1) / numFrames;
//		frac = length(getMoveDelta(arrivalAnim, 0, timefrac)) / totalAnimDist;
//
//		currentYaw = startYaw + frac * (targetYaw - startYaw);
//		currentPos = startPos + frac * (targetPos - startPos);
//
//		self orientMode("face angle", currentYaw);
//		self teleport(currentPos);
//
//		wait .05;
//	}
//
//	return true;
//}
//
//decideMiniArrivalAnim(node, pos)
//{
//	dirToNode = pos - node.origin;
//	angle = AngleClamp180(vectorToAngles(dirToNode)[1] - node.angles[1]);
//
//	dir = -1;
//	if (angle < -180 + 22.5)
//		dir = 2;
//	else if (angle < -180 + 67.5)
//		dir = 3;
//	else if (angle < 0)
//		dir = 6;
//	else if (angle < 180 - 67.5)
//		dir = 4;
//	else if (angle < 180 - 22.5)
//		dir = 1;
//	else
//		dir = 2;
//
//	// for now, assume cover stand
//	anims = [];
//	anims[1] = %coverstand_mini_approach_1;
//	anims[2] = %coverstand_mini_approach_2;
//	anims[3] = %coverstand_mini_approach_3;
//	anims[4] = %coverstand_mini_approach_4;
//	anims[6] = %coverstand_mini_approach_6;
//
//	assertex(isdefined(anims[ dir ]), dir);
//
//	return anims[ dir ];
//}
//
//
//debug_arrivals_on_actor()
//{
//	/#
//	dvar = getdebugdvar("debug_arrivals");
//	if (dvar == "off")
//		return false;
//
//	if (dvar == "on")
//		return true;
//
//	if (int(dvar) == self getentnum())
//		return true;
//	#/
//
//	return false;
//}
//
//
//debug_arrival(msg)
//{
//	if (!debug_arrivals_on_actor())
//		return;
//	println(msg);
//}
