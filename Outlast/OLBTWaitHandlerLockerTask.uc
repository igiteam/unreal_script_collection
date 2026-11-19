/**
 * Copyright 2012 Red Barrels, Inc. All Rights Reserved.
 */
class OLBTWaitHandlerLockerTask extends OLBTWaitHandlerBaseTask
	native(AI);

var OLHidingSpot Locker;

cpptext
{
	virtual void OnInitialize();
	virtual void OnTerminate(EStatus status);

private:
	// Interface from WaitHandlerBase
	virtual void AddOwnerToObject();
	virtual void RemoveOwnerFromObject();

	virtual UBOOL IsObjectInUse();

	virtual UBOOL IsOwnerActive();
	virtual void SetOwnerAsActive();

	virtual AOLBot* GetBestBotForObject();

	virtual void RecalculateActiveBot();
	virtual void RecalculateAllBots();

	virtual void GrabWaitPointOnOwner();
	virtual void ReturnWaitPointOnOwner();
};

defaultproperties
{
}