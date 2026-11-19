/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTPerformWaypointActionTask extends OLBTBasicTask
	native(AI);

var float WaitTimer;
var bool bPlayingAnim;
var bool bLoopingAnim;

cpptext
{
	virtual void OnInitialize();
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );

	virtual UBOOL IsLatentTask() { return TRUE; }
}

defaultproperties
{
}