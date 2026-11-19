class arrival_StartCornerApproach extends CoreTask within animscripts_cover_arrival;

// parameter
var name iApproachType;
var vector iApproachPoint;
var float iApproachNodeYaw;
var float iApproachFinalYaw;
var vector iApproach_dir;

// output

// local
var int lMaxDirections;
var int lExcludeDir;
var int lApproachNumber;
var int lApproachNumberTemp;
var bool lTryNormalApproach;
var float lRequiredYaw;

state main
{
Begin:
	endon('killanimscript');
	endon('corner_approach');

	assert(isdefined(iApproachType));

	if (iApproachType == 'stand' || iApproachType == 'crouch')
	{
		assert(node_isdefined(node));
		if (AbsAngleClamp180(vectorToAngles(iApproach_dir).yaw - node.angles.yaw + 180) < 60)
		{
			_return();
		}
	}

	getMaxDirectionsAndExcludeDirFromApproachType(iApproachType, lMaxDirections, lExcludeDir);

	lApproachNumber = -1;

	if (iApproachType == 'exposed')
	{
		lApproachNumberTemp = CheckArrivalEnterPositions(iApproachPoint, iApproachFinalYaw, iApproachType, iApproach_dir, lMaxDirections, lExcludeDir);
		if (lApproachNumberTemp < 0)
			_return();
		lApproachNumber = lApproachNumberTemp;
	}
	else
	{
		// approaching a node.
		// try arrival directions into exposed
		lTryNormalApproach = true;
		// TODO: try approach to exposed
		/*if (self shouldApproachToExposed())
		{
			approachdata = getExposedApproachData();
			// use approachdata.point, approachdata.yaw

			// be careful not to set these if we're going to try a normal approach:
			iApproachFinalYaw = approachdata.yaw;
			iApproachType = 'exposed';
			lApproachNumber = result.approachNumber;
			iApproachPoint = ...

		}*/
		if (lTryNormalApproach)
		{
			// try arrival directions into node itself
			lApproachNumberTemp = CheckArrivalEnterPositions(iApproachPoint, iApproachFinalYaw, iApproachType, iApproach_dir, lMaxDirections, lExcludeDir);
			if (lApproachNumberTemp < 0)
				_return();
			lApproachNumber = lApproachNumberTemp;
		}
	}

	setRunToPos(coverEnterPos);

	waittill('runto_arrived');

	if (disableArrivals)
		_return();

	/*if (self isCQBWalking())
	{
		/#
		debug_arrival('approach aborted at last minute: self.cqbwalking is true');
		#/
		return;
	}*/

	// so we don't make guys turn around when they're (smartly) facing their enemy as they walk away
	if (abs(getMotionAngle()) > 45 && obj_isdefined(enemy) && vectorDot(anglesToForward(angles), vectorNormalize(enemy.origin - origin)) > 0.8)
		_return();

	if (a.pose != 'stand' || (a.movement != 'run' && !animscripts_utility.isCQBWalking()))
		_return();

	lRequiredYaw = iApproachFinalYaw - anim.coverTransAngles[TransTypeID(iApproachType)].data[lApproachNumber];

	if (AbsAngleClamp180(lRequiredYaw - angles.yaw) > 30)
	{
		// don't do an approach away from an enemy that we would otherwise face as we moved away from them
		if (animscripts_utility.IsValidEnemy(enemy) && canSee(enemy) && distanceSquared(origin, enemy.origin) < 256 * 256*FInchSq)
		{
			// check if enemy is in frontish of us
			if (vectorDot(anglesToForward(angles), enemy.origin - origin) > 0)
				_return();
		}
	}

	// make sure the path is still clear
	if (!checkCoverEnterPos(iApproachPoint, iApproachFinalYaw, iApproachType, lApproachNumber))
		_return();

	approachNumber = lApproachNumber;	// used in cover_arrival::main()
	approachType = iApproachType;
//	self.doMiniArrival = undefined;
	startcoverarrival(coverEnterPos, lRequiredYaw);
}
