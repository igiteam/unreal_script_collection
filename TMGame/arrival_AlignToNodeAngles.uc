class arrival_AlignToNodeAngles extends CoreTask within animscripts_cover_arrival;

// parameter

// output

// local
var float maxdist;
var float startYaw;
var float targetYaw;
var float dist;
var float distfrac;
var float currentYaw;
var float startdist;

state main
{
Begin:
	endon('killanimscript');
	endon('goal_changed');
	endon('dont_align_to_node_angles');
	endon('doing_last_minute_exposed_approach');

	wait (0);
//	waittillframeend;

	// this is a last ditch fake approach.
	// we gradually turn to face the direction we want to face at the node
	// as we get there.

	maxdist = 80 * FInch;

	while (true)
	{
		if (!node_isdefined(node) || node.type == 'Path' || node.type == 'Guard' || pathGoalPos != invalid_vector || distanceSquared(node.origin, pathGoalPos) > 1 * FInchSq)
			_return();

		// don't do this if we're too far away.
		if (distanceSquared(origin, node.origin) > maxdist * maxdist)
		{
			wait (0.05);
			continue;
		}

		// don't do this if we're going to do an approach.
		if (coverEnterPos != invalid_vector && pathGoalPos != invalid_vector && distanceSquared(coverEnterPos, pathGoalPos) < 1 * FInchSq)
		{
			wait (0.1);
			continue;
		}

		break;
	}

	if (disableArrivals)
		_return();

	startdist = distance(origin, node.origin);

	if (startdist <= 0)
		_return();

	determineNodeApproachType(node);

	startYaw = angles.yaw;
	targetYaw = node.angles.yaw;
	if (isdefined(node.approachtype))
		targetYaw += getNodeStanceYawOffset(node.approachtype);
	targetYaw = startYaw + AngleClamp180(targetYaw - startYaw);

	resetOrientModeOnGoalChange(true);

	while (true)
	{
		if (!node_isdefined(node))
		{
			orientMode('face default');
			_return();
		}

//		if (self ShouldDoMiniArrival())
//		{
//			self StartMiniArrival();
//			return;
//		}

		dist = distance(origin, node.origin);

		if (dist > startdist * 1.1) // failsafe
		{
			orientMode('face default');
			_return();
		}

		distfrac = 1.0 - (dist / startdist);

		currentYaw = startYaw + distfrac * (targetYaw - startYaw);

		orientMode('face angle', currentYaw);

		wait (0.05);
	}
}
