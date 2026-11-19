/**
 * Copyright 2013 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTLookAtDisturbanceTask extends OLBTBasicTask
	native(AI);

cpptext
{
	virtual void OnInitialize();
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );
}

defaultproperties
{
}