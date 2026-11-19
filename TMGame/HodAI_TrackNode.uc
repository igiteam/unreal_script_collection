class HodAI_TrackNode extends CoreTask within HodAI;

// local
var vector lOldPosition;

state main
{
Begin:
	endon ('killanimscript');

	lOldPosition = origin;
	while (true)
	{
		//if (!node_isdefined(animscripts_utility.GetClaimedNode()))
		//{
		//	node.set(none);
		//	break;
		//}
		if (!node_isdefined(node))
			break;
		if (KeepClaimedNodeInGoal)
			lOldPosition = origin;
		else if (distanceSquared(lOldPosition, origin) > 4)
			break;

		wait (0.05);
	}

	node.set(none);
}
