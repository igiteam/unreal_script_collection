/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTSelectorTask extends OLBTCompositeTask
	native(AI);

cpptext
{
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );
}

defaultproperties
{
}