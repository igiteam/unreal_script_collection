/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTMoveToDisturbanceTask extends OLBTMoveToTask
	native(AI);

cpptext
{
	virtual void OnInitialize();

	virtual UBOOL CompareTaskState(const UOLBTTask* Other);
}

defaultproperties
{
}