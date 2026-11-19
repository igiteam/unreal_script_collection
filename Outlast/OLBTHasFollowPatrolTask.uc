/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTHasFollowPatrolTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.bPatrolToPlayer;
}

defaultproperties
{
}