/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTIsInvestigatingTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.bIsInvestigating;
}

defaultproperties
{
}