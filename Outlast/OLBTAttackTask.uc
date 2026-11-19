/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTAttackTask extends OLBTTask
	native(AI);

var bool AttackSucceeded;

cpptext
{
	virtual void OnInitialize();
	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );

	virtual UBOOL IsLatentTask() { return TRUE; }
}

defaultproperties
{
}