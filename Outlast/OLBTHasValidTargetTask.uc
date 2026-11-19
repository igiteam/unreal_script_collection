/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTHasValidTargetTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.TargetPlayer != None && !Owner.TargetPlayer.bDeleteMe && Owner.TargetPlayer.PreciseHealth > 0.f;
}

defaultproperties
{
}