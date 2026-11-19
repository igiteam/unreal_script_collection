/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTMoveToTask extends OLBTBasicTask
	abstract
	native(AI);

var bool bStartedAtDestination;

cpptext
{
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );

	virtual UBOOL IsLatentTask() { return TRUE; }
}

defaultproperties
{
}