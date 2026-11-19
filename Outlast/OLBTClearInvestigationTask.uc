/**
 * Copyright 2013 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTClearInvestigationTask extends OLBTBasicTask
	native(AI);

cpptext
{
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );
}

defaultproperties
{
}