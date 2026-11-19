class arrival_StartMoveTransition extends CoreTask within animscripts_cover_arrival;

// parameter

// output

// local
var vector exitpos;
var float exityaw;
var name exittype;
var HodNode exitnode;
var float distancesq;
var float anglediff;
var vector leaveDir;
var int maxDirections;
var int excludeDir;
var int lapproachnumber;
var int numAttempts;
var float allowedDistSq;
var NodeTransitionAngle angleDataObj;
var int i;

state main
{
Begin:
	endon('killanimscript');
	
	exitingCover = false;
	
	// if we don't know where we're going, we can't check if it's a good idea to do the exit animation
	// (and it's probably not)
	if (pathGoalPos == invalid_vector)
		_return();
	
	if (a.pose == 'prone')
		_return();
	
	if (disableExits)
		_return();

	if (moveMode != 'run')
		_return();
	
	if (!IsStanceAllowed('stand'))
		_return();
	
	// assume an exit from exposed.
	exitpos = origin;
	exityaw = angles.yaw;
	exittype = 'exposed';
	
	exitNode = none;
	if (node_isdefined(node) && (distanceSquared(origin, node.origin) < 225*FInchSq))
		exitNode = node;
	else if (node_isdefined(prevNode))
		exitNode = prevNode;
	
	// if we're at a node, try to do an exit from the node.
	if (exitNode != none)
	{
		determineNodeApproachType(exitNode);

		if (exitNode.approachtype != '' && exitNode.approachtype != 'exposed' && exitNode.approachtype != 'stand_saw' && exitNode.approachType != 'crouch_saw')
		{
			// if far from cover node, or angle is wrong, don't do exit behavior for the node.
			
			distancesq = distancesquared(exitNode.origin, origin);
			anglediff = AbsAngleClamp180(angles.yaw - exitNode.angles.yaw - getNodeStanceYawOffset(exitNode.approachtype));
			if (distancesq < 225*FInchSq && anglediff < 5) // (225 = 15 * 15)
			{
				// do exit behavior for the node.
				exitpos = exitNode.origin;
				exityaw = exitNode.angles.yaw;
				exittype = exitNode.approachtype;
			}
		}
	}
	
	if (exittype == '')
		_return();
	
	// since we transition directly into a standing run anyway,
	// we might as well just use the standing exits when crouching too
	if (exittype == 'exposed')
	{
		if (a.pose != 'stand' && a.pose != 'crouch')
			_return();

		if (a.movement != 'stop')
			_return();

		if (a.pose == 'crouch')
			exittype = 'exposed_crouch';
	}
	
	/*if (exittype == "crouch" || exittype == "stand")
	{
		if (AbsAngleClamp180(vectorToAngles(self.lookaheaddir)[1] - exityaw) < 60)
		{
			/#
			debug_arrival("aborting exit: lookaheaddir is too far forward for node type " + exittype);
			#/
			_return();
		}
	}*/
	
	// need fixed
	// don't do an exit away from an enemy that we would otherwise face as we moved away from them
	if (animscripts_utility.isValidEnemy(enemy) && vectorDot(lookaheaddir, enemy.origin - origin) < 0)
	{
		if (animscripts_utility.canSeeEnemyFromExposed() && distanceSquared(origin, enemy.origin) < 300 * 300 * FInchSq)
			_return();
	}
	
	// since we're leaving, take the opposite direction of lookahead
	leaveDir.x = -lookaheaddir.x;
	leaveDir.y = -lookaheaddir.y;
	leaveDir.z = 0;
	
	GetMaxDirectionsAndExcludeDirFromApproachType(exittype, maxDirections, excludeDir);
	
	exityaw = exityaw + getNodeStanceYawOffset(exittype);
	
//	angleDataObj = spawnstruct();
	
	calculateNodeTransitionAngles(angleDataObj, exittype, false, exityaw, leaveDir, maxDirections, excludeDir);
	sortNodeTransitionAngles(angleDataObj, maxDirections);
	
	lapproachnumber = -1;
	numAttempts = 3;
	if (exittype == 'exposed' || exittype == 'exposed_crouch')
		numAttempts = 1;
	
	for (i = 1; i <= numAttempts; i++)
	{
		assert(angleDataObj.transIndex[i] != excludeDir); // shouldn't hit excludeDir unless numAttempts is too big
	
		lapproachNumber = angleDataObj.transIndex[i];
		if (checkCoverExitPos(exitpos, exityaw, exittype, lapproachNumber))
			break;
	}
	
	if (i > numAttempts)
		_return();

	// if AI is closer to destination than arrivalPos is, don't do exit
	allowedDistSq = distanceSquared(origin, coverExitPos) * 1.25*1.25;
	if (distanceSquared(origin, pathgoalpos) < allowedDistSq)
		_return();

	doCoverExitAnimation(exittype, lapproachNumber);
}
