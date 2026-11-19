/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTSawPlayerInBedTask extends OLBTIfCustomTask;

event bool Condition()
{
	return (Owner.Group != None) ? Owner.Group.DidAnyoneSeePlayerinBed() : Owner.SightComponent.bSawPlayerEnterBed;
}

defaultproperties
{
}