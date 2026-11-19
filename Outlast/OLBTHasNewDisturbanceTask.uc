/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTHasNewDisturbanceTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.bNewDisturbance && Owner.IgnoreDisturbanceTimer <= 0.f;
}

defaultproperties
{
}