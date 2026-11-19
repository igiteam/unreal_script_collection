/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTRepeatTask extends OLBTCompositeTask
	native(AI);

var int CurrRepetition;

cpptext
{
	virtual void OnInitialize();
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );

	virtual UBOOL IsLatentTask() { return TRUE; }
}

defaultproperties
{
	CurrRepetition=0
}