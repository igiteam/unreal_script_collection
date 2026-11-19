/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTMoveToWaypointTask extends OLBTMoveToTask
	native(AI);

var transient Route PatrolRoute;
var transient int PatrolRouteIndex;

cpptext
{
	virtual void OnInitialize();

	virtual UBOOL CompareTaskState(const UOLBTTask* Other);
}

defaultproperties
{
}