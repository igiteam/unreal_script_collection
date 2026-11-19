/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTWaitHandlerNode extends OLBTCompositeNode
	native(AI);

var() class<OLBTWaitHandlerBaseTask> WaitHandlerTask;

enum EWaitHandlerState
{
	EWHS_Active,
	EWHS_Waiting,
};

cpptext
{
	virtual UOLBTTask* CreateTask();

	/* for editor use. */
	virtual FString GetNodeTitle();
}

defaultproperties
{
	Children(EWHS_Active)=(Name="Active")
	Children(EWHS_Waiting)=(Name="Waiting")
	bFixNumChildren=true
}
