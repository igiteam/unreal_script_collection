/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTWaitForReactionTask extends OLBTBasicTask
	native(AI);

cpptext
{
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );

	virtual UBOOL IsLatentTask() { return TRUE; }
}

defaultproperties
{
}