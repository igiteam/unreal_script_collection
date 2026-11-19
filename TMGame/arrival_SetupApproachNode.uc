class arrival_SetupApproachNode extends CoreTask within animscripts_cover_arrival;

// parameter
var bool firstTime;

// output

// local
var vector approach_dir;
var name nApproachType;
var vector approachPoint;
var float approachNodeYaw;
var float approachFinalYaw;

function OnNotify(name note, CoreNotify data)
{
	switch (note)
	{
	case 'corner_approach':
		approach_dir = HodNotify_CornerApproach(data).approach_dir;
		break;

	default: break;
	}
}

state main
{
Begin:
	endon('killanimscript');

	// this lets code know that script is expecting the 'corner_approach' notify
	if (firstTime)
		requestArrivalNotify = true;

	a.arrivalType = '';
	doLastMinuteExposedApproachWrapper(true);

	// 'corner_approach' actually means 'cover_approach'.
	//waittill('corner_approach', approach_dir);
	waittill('corner_approach');

	// if we're going to do a negotiation, we want to wait until it's over and move.gsc is called again
	if (getnegotiationstartnode() != none)
		_return();

	if (disableArrivals)
		_return();

//	/*if (self isCQBWalking())
//	{
//		/#
//		debug_arrival('Not doing approach: self.cqbwalking is true');
//		#/
//		return;
//	}*/

	setupApproachNode(false, true);	// wait again

	nApproachType = 'exposed';
	approachPoint = pathGoalPos;
	approachNodeYaw = vectorToAngles(approach_dir).yaw;
	approachFinalYaw = approachNodeYaw;
	if (node_isdefined(node))
	{
		determineNodeApproachType(node);
		if (isdefined(node.approachtype) && node.approachtype != 'exposed')
		{
			nApproachType = node.approachtype;

//			if (nApproachType == 'stand_saw')
//			{
//				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
//				forward = anglesToForward((0,self.node.turretInfo.angles[1],0));
//				right = anglesToRight((0,self.node.turretInfo.angles[1],0));
//				approachPoint = approachPoint + vectorScale(forward, -32.545) - vectorScale(right, 6.899);
//			}
//			else if (nApproachType == 'crouch_saw')
//			{
//				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
//				forward = anglesToForward((0,self.node.turretInfo.angles[1],0));
//				right = anglesToRight((0,self.node.turretInfo.angles[1],0));
//				approachPoint = approachPoint + vectorScale(forward, -32.545) - vectorScale(right, 6.899);
//			}
//			else if (nApproachType == 'prone_saw')
//			{
//				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
//				forward = anglesToForward((0,self.node.turretInfo.angles[1],0));
//				right = anglesToRight((0,self.node.turretInfo.angles[1],0));
//				approachPoint = approachPoint + vectorScale(forward, -37.36) - vectorScale(right, 13.279);
//			}
//			else
//			{
				approachPoint = node.origin;
//			}

			approachNodeYaw = node.angles.yaw;
			approachFinalYaw = approachNodeYaw + getNodeStanceYawOffset(nApproachType);
		}
	}

//	//if (nApproachType == 'exposed' && !isdefined(self.pathGoalPos))
//	//	return;

	// we're doing default exposed approaches in doLastMinuteExposedApproach now
	if (nApproachType == 'exposed')
		_return();

	startCornerApproach(nApproachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir);
}
