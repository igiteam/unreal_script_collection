/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTBasicNode extends OLBTNode
	native(AI);

var() class<OLBTBasicTask> BasicTask;

cpptext
{
	virtual UOLBTTask* CreateTask();

	/* for editor use. */
	virtual FString GetNodeTitle();
}

defaultproperties
{
}