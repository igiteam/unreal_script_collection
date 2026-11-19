/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTCanAttackTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.InAttackRange && (Owner.PerformAttackCheck() || Owner.PerformGrabCheck() || Owner.TargetPlayer.CanBeGrabbedUnder() || Owner.TargetPlayer.CanGrabFromSqueeze());
}

defaultproperties
{
}