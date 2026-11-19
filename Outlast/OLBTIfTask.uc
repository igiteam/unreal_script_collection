/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTIfTask extends OLBTCompositeTask
	abstract
	native(AI);

cpptext
{
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );
}

event bool Condition();

defaultproperties
{
}