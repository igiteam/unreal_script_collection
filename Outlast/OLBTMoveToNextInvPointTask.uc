/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTMoveToNextInvPointTask extends OLBTMoveToTask
	native(AI);

cpptext
{
	virtual void OnInitialize();
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );
}

defaultproperties
{
}