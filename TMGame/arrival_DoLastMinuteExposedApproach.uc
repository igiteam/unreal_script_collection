class arrival_DoLastMinuteExposedApproach extends CoreTask within animscripts_cover_arrival;

// parameter

// output

// local
var float maxSpeed;
var float allowedError;
var float dist;
var name nApproachType;
var int nApproachTypeID;
var vector approachDir;
var float desiredFacingYaw;
var Angle likelyEnemyDir;
var NodeTransitionAngle angleDataObj;
var int i;
var int best;
var name approachAnim;
var float requiredDistSq;
var float facingYaw;
var vector delta;
var float yawToMakeDeltaMatchUp;
var float requiredYaw;
var float closerDist;
var vector idealStartPos;
var float waittime;
var float animDist;

state main
{
Begin:
	endon('goal_changed');

	if (getnegotiationstartnode() != none)
		_return();

	maxSpeed = 300*FInch; // units/sec

	allowedError = 6*FInch;

	// wait until we get to the point where we have to decide what approach animation to play
	while (true)
	{
		if (pathGoalPos == invalid_vector)
			waitForPathGoalPos();

		dist = distance(origin, pathGoalPos);

		if (dist <= anim.longestExposedApproachDist + allowedError)
			break;

		// underestimate how long to wait so we don't miss the crucial point
		waittime = (dist - anim.longestExposedApproachDist) / maxSpeed - 0.1;
		if (waittime < 0.05)
			waittime = 0.05;

		///#self thread animscripts\shared::showNoteTrack('wait ' + waittime);#/
		wait (waittime);
	}

//	if (isdefined(self.grenade) && isdefined(self.grenade.activator) && self.grenade.activator == self)
//		return;

	// only do an arrival if we have a clear path
	if (!maymovetopoint(pathGoalPos))
		_return();

	nApproachType = 'exposed';

	if (node_isdefined(node) && (pathGoalPos != invalid_vector) && distanceSquared(pathGoalPos, node.origin) < 1 * FInchSq)
	{
		determineNodeApproachType(node);
		if (node.approachtype != '' && (node.approachtype == 'exposed' || node.approachtype == 'exposed_crouch'))
		{
			nApproachType = node.approachtype;
		}
		alignToNodeAngles(true); // we'll cancel this if our arrival succeeds
	}

	approachDir = VectorNormalize(pathGoalPos - origin);

	// by default, want to face forward
	desiredFacingYaw = vectorToAngles(approachDir).yaw;
	if (ArrivalFocusTarget != none)
	{
		desiredFacingYaw = vectorToAngles(ArrivalFocusTarget.Location - pathGoalPos).yaw;
	}
	else if (animscripts_utility.isValidEnemy(enemy) && sightTracePassed(enemy.getShootAtPos(), pathGoalPos + vect(0,0,60)*FInch, false, none))
	{
		desiredFacingYaw = vectorToAngles(enemy.origin - pathGoalPos).yaw;
	}
	else if (node_isdefined(node) && (node.type == 'Guard') && node.origin == pathGoalPos)
	{
		desiredFacingYaw = node.angles.yaw;
	}
	else
	{
		if (getAnglesToLikelyEnemyPath(likelyEnemyDir))
			desiredFacingYaw = likelyEnemyDir.yaw;
	}
	//desiredFacingYaw = RandomFloat(360);

//	angleDataObj = spawnstruct();
	calculateNodeTransitionAngles(angleDataObj, nApproachType, true, desiredFacingYaw, approachDir, 9, -1);

	// take best animation
	best = 1;
	for (i = 2; i < 9; i++)
	{
		if (angleDataObj.transitions[i] > angleDataObj.transitions[best])
			best = i;
	}
	approachNumber = angleDataObj.transIndex[best];
	approachType = nApproachType;

	nApproachTypeID = TransTypeID(nApproachType);

	approachAnim = anim.coverTrans[nApproachTypeID].data[approachNumber];

	animDist = length(anim.coverTransDist[nApproachTypeID].data[approachNumber]);

	requiredDistSq = animDist + allowedError;
	requiredDistSq = requiredDistSq * requiredDistSq;

	// we should already be close
	while (pathGoalPos != invalid_vector && distanceSquared(origin, pathGoalPos) > requiredDistSq)
		wait (0.05);

	if (pathGoalPos == invalid_vector)
		_return();

	if (node_isdefined(node) && distanceSquared(pathGoalPos, node.origin) < 1 * FInchSq)
	{
		if (node.type != 'Guard' && node.type != 'Path' && node.type != 'Cover Prone' && node.type != 'Conceal Prone')
			_return();
	}

	if (disableArrivals)
		_return();

//	if (self isCQBWalking() && (!isdefined(self.node) || self.node.type == 'Path'))
//		return;

	if (a.pose != 'stand' || a.movement != 'run')
		_return();

	dist = distance(origin, pathGoalPos);
	if (abs(dist - animDist) > allowedError)
		_return();

	facingYaw = vectorToAngles(pathGoalPos - origin).yaw;

	delta = anim.coverTransDist[nApproachTypeID].data[approachNumber];
	assert(delta.x != 0);
	yawToMakeDeltaMatchUp = atan(delta.y / delta.x);

	requiredYaw = facingYaw - yawToMakeDeltaMatchUp;
	if (AbsAngleClamp180(requiredYaw - angles.yaw) > 30)
		_return();

	closerDist = dist - animDist;
	idealStartPos = origin + VectorScale(vectorNormalize(pathGoalPos - origin), closerDist);

	notify('dont_align_to_node_angles');

	startcoverarrival(idealStartPos, requiredYaw);
}
