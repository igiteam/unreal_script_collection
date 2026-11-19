/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTWaitTask extends OLBTTask
	native(AI);

var float WaitTimer;

cpptext
{
	virtual void OnInitialize();
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );

	virtual UBOOL IsLatentTask() { return TRUE; }
}

defaultproperties
{
	WaitTimer = 0.f
}