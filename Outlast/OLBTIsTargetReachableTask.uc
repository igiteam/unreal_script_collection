/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTIsTargetReachableTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.TargetReachable();
}

defaultproperties
{
}