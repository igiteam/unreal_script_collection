/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTIfCustomNode extends OLBTIfNode
	native(AI);

var() class<OLBTIfCustomTask> IfTask;

cpptext
{
	virtual UOLBTTask* CreateTask();

	/* for editor use. */
	virtual FString GetNodeTitle();
}

defaultproperties
{
}