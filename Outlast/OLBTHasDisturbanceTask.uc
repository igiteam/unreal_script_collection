/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTHasDisturbanceTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.VisualDisturbance.TimeSinceUpdate != -1.0f || Owner.AudioDisturbance.TimeSinceUpdate != -1.0f;
}

defaultproperties
{
}