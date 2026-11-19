/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTSawPlayerInSqueezeTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.SightComponent.bSawPlayerInSqueeze;
}

defaultproperties
{
}