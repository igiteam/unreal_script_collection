/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTHasPatrolTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.PatrolRoute != None || Owner.bPatrolToPlayer;
}

defaultproperties
{
}