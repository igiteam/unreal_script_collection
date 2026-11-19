/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTHasInvestigationPointTask extends OLBTIfCustomTask;

event bool Condition()
{
	return Owner.bInvestigationPointValid;
}

defaultproperties
{
}