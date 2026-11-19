/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTSawPlayerInLockerTask extends OLBTIfCustomTask;

event bool Condition()
{
	return (Owner.Group != None) ? Owner.Group.DidAnyoneSeePlayerinLocker() : Owner.SightComponent.bSawPlayerEnterHidingSpot;
}

defaultproperties
{
}