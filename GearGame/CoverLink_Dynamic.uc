
/*
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class CoverLink_Dynamic extends CoverLink
	native;

var() bool bSkipPathUpdate;

cpptext
{
	void FindBase()
	{
		// only update the base if it's null, to prevent clobbering attachment
		if (Base == NULL)
		{
			Super::FindBase();
		}
	}

	virtual void BeginDestroy();

	virtual UBOOL HasFireLinkTo( INT SlotIdx, const FCoverInfo &ChkCover, UBOOL bAllowFallbackLinks = FALSE );

	virtual void PostBeginPlay();

	void UnLinkFromNavigationMesh();

	// broadcast the fact that we are reffing polygons that we are linked to, so they can get cleared etc
	virtual void GetActorReferences(TArray<FActorReference*> &ActorRefs, UBOOL bIsRemovingLevel);

	// overidden to clear refs to polys on delete
	virtual void PostScriptDestroyed();

	// overidden to not do anything during path generation (allt he magic happens at runtime for these guys)
	virtual UBOOL LinkCoverSlotToNavigationMesh(INT SlotIdx, UNavigationMeshBase* Mesh=NULL);


}

/** Last known stable location, where pathing was checked, etc */
var Vector LastStableLocation;

/** Should this be added to the path network even after moving?  Will still move in the octree, but will not attempt any reach tests. */
var() bool bAddToPathNetwork;
/** Should remove paths when updating */
var() bool bClearPaths;

// list of polygons which are currently linked to this coverlink's slot(s)
var const native array<PolyReference>	LinkedNavMeshPolygons;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( !bSkipPathUpdate )
	{
		SetTimer( 0.1f, FALSE, nameof(CheckCoverUpdate) );
	}
}

native simulated function UpdateCoverLink();
native simulated function UpdateCoverSlot(INT SlotIndex, bool bUpdateOctree=false,optional scout InScout);

function OnModifyCover( SeqAct_ModifyCover Action )
{
	Super.OnModifyCover(Action);
	UpdateCoverLink();
}

final simulated function CheckCoverUpdate()
{
	if (!bSkipPathUpdate)
	{
		if (!bDisabled && VSize(LastStableLocation - Location) > InvalidateDistance)
		{
			UpdateCoverLink();
		}
		// set slightly random timer to offset multiple links all updating at once
		SetTimer(1.0 + RandRange(0.1, 0.3), false, nameof(CheckCoverUpdate));
	}
}

function OnToggle(SeqAct_Toggle inAction)
{
	Super.OnToggle(inAction);
	if (!bDisabled)
	{
		LastStableLocation = Location + vect(1,1,1) * InvalidateDistance;
		SetTimer(0.1 ,false, nameof(CheckCoverUpdate));
	}
}

// called after a slot's index is changed to notify claimants, as well as fix indices
simulated event SlotIndexUpdated(int NewIndex,int OldIndex)
{
	local GearPawn GP;
	local int Delta;

	// notify the owner if any, of the index change
	if(Slots[NewIndex].SlotOwner != None)
	{
		GP = GearPawn(Slots[NewIndex].SlotOwner);
		if(GP != none)
		{
			// if the index just moved a lot, bail
			if(abs(newIndex - OldIndex) > 1)
			{
				NotifySlotOwnerCoverDisabled( NewIndex );
			}
			else if(GP.CurrentSlotIdx != -1)
			{
				Delta = NewIndex - OldIndex;
				//`log("Setting cover info on :"@GP@"NewIdx:"@NewIndex@"CurrentIdx:"@GP.CurrentSlotIdx@"Delta:"@Delta@WorldInfo.TimeSeconds);
				GP.SetCoverInfo(self,NewIndex,Clamp(GP.LeftSlotIdx+Delta,0,Slots.length-1),Clamp(GP.RightSlotIdx+Delta,0,Slots.length-1),GP.CurrentSlotPct);
			}
		}
	}
}

simulated event string GetDebugAbbrev()
{
	return "DynCL";
}

defaultproperties
{
	bStatic=false
	bMovable=true
	bDynamicCover=true
	bClearPaths=true

	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true
}
