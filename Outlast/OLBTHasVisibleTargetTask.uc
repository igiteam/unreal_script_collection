/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTHasVisibleTargetTask extends OLBTIfCustomTask;

event bool Condition()
{
	return (Owner.Group != None) ? Owner.Group.CanAnyoneSeeTarget() : Owner.SightComponent.CanSeeTarget;
}

defaultproperties
{
}