/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTWaitHandlerBaseTask extends OLBTCompositeTask
	abstract
	native(AI);

cpptext
{
	virtual void OnInitialize();
	virtual void OnTerminate(EStatus status);

	virtual EStatus Update( FLOAT DeltaSeconds, TArray<FBehaviorState>* RootState = NULL, TArray<FBehaviorState>* CurrentState = NULL );

private:

	// Interface for Children
	virtual void AddOwnerToObject() {}
	virtual void RemoveOwnerFromObject() {}

	virtual UBOOL IsObjectInUse() { return FALSE; }

	virtual UBOOL IsOwnerActive() { return FALSE; }
	virtual void SetOwnerAsActive() {}

	virtual AOLBot* GetBestBotForObject() { return NULL; }

	virtual void RecalculateActiveBot() {}
	virtual void RecalculateAllBots() {}

	virtual void GrabWaitPointOnOwner() {}
	virtual void ReturnWaitPointOnOwner() {}
}

defaultproperties
{
}