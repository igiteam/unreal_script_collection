/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTGetNextInvestigationPointTask extends OLBTCompositeTask
	native(AI);

cpptext
{
	virtual void OnInitialize();
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );
}

defaultproperties
{
}
