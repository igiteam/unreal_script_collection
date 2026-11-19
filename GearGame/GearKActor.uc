/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearKActor extends KActor
	native;

enum EKActorNetworkType
{
	/** figure it out based on size */
	NT_Auto,
	/** client side only (not gameplay relevant) */
	NT_ClientSide,
	/** server side and replicated (gameplay relevant) */
	NT_Replicated,
};
/** type of networking to use */
var() EKActorNetworkType NetworkType;

/** This actor is a throwable target for the berserker */
var() bool bThrowable;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}

/** @return AABB Extent of our static mesh as its internal bounds are not script accessible */
native final function vector GetMeshExtent();

simulated event PreBeginPlay()
{
	local bool bClientSide;
	local vector Extent;

	// set network role based on type setting
	switch (NetworkType)
	{
		case NT_Auto:
			Extent = GetMeshExtent();
			bClientSide = (Extent.X < 32.0f || Extent.Y < 32.0f || Extent.Z < 32.0f);
			break;
		case NT_ClientSide:
			bClientSide = true;
			break;
		case NT_Replicated:
			bClientSide = false;
			break;
		default:
			`warn("Invalid NetworkType for" @ PathName(self));
			bClientSide = true;
			break;
	}

	if (WorldInfo.NetMode == NM_Client)
	{
		// on the client, set role to Authority if we're a clientside only KActor
		Role = bClientSide ? ROLE_Authority : ROLE_SimulatedProxy;
	}
	else
	{
		// on the server, set role to SimulatedProxy (i.e. replicate it) only if not clientside
		RemoteRole = bClientSide ? ROLE_None : ROLE_SimulatedProxy;
	}
	if (bClientSide)
	{
		SetCollision(, false);
	}

	Super.PreBeginPlay();
}

defaultproperties
{
	RemoteRole=ROLE_None
	bThrowable=false // not throwable by default because that requires network replication
}
