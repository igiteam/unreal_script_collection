/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTTargetNotMovingTask extends OLBTIfCustomTask;

var float MovingThreshold;

event bool Condition()
{
	return Owner.TargetPlayer != None && (VSizeSq(Owner.TargetPlayer.Velocity) < MovingThreshold * MovingThreshold);
}

defaultproperties
{
	MovingThreshold=10.0f
}