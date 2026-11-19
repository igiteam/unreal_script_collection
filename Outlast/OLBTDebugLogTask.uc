/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTDebugLogTask extends OLBTTask
	native(AI);

cpptext
{
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );
}

defaultproperties
{
}