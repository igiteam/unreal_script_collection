
/*
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class CoverLink_Spawnable extends CoverLink_Dynamic
	native;

struct native ReplicatedCoverSlot
{
	var bool bLeanleft, bLeanRight;
	var bool bCanPopUp, bCanMantle;
	var ECoverType CoverType;
	var vector LocationOffset;
	var rotator RotationOffset;
	var bool bCanCoverSlip_Left, bCanCoverSlip_Right;
	var bool bCanSwatTurn_Left, bCanSwatTurn_Right;
};

/** The first cover slot to replicate */
var repnotify ReplicatedCoverSlot ReplicatedSlot0;

/** The second cover slot to replicate */
var repnotify ReplicatedCoverSlot ReplicatedSlot1;

replication
{
	if (bNetDirty)
		ReplicatedSlot0, ReplicatedSlot1;
}

/**
 * Copy the cover slot's values into the replicated cover slot
 * 
 * @param Slot - the cover slot to replicate the properties of
 */
function SetReplicatedSlot0(const out CoverSlot Slot)
{
	ReplicatedSlot0.bCanMantle = Slot.bCanMantle;
	ReplicatedSlot0.bLeanLeft = Slot.bLeanLeft;
	ReplicatedSlot0.bLeanRight = Slot.bLeanRight;
	ReplicatedSlot0.bCanPopUp = Slot.bCanPopUp;
	ReplicatedSlot0.bCanMantle = Slot.bCanMantle;
	ReplicatedSlot0.bCanCoverSlip_Left = Slot.bCanCoverSlip_Left;
	ReplicatedSlot0.bCanCoverSlip_Right = Slot.bCanCoverSlip_Right;
	ReplicatedSlot0.bCanSwatTurn_Left = Slot.bCanSwatTurn_Left;
	ReplicatedSlot0.bCanSwatTurn_Right = Slot.bCanSwatTurn_Right;
	ReplicatedSlot0.CoverType = Slot.CoverType;
	ReplicatedSlot0.LocationOffset = Slot.LocationOffset;
	ReplicatedSlot0.RotationOffset = Slot.RotationOffset;
	
	// force replication
	ForceNetRelevant();
}

/**
 * Copy the cover slot's values into the replicated cover slot
 * 
 * @param Slot - the cover slot to replicate the properties of
 */
function SetReplicatedSlot1(const out CoverSlot Slot)
{
	ReplicatedSlot1.bCanMantle = Slot.bCanMantle;
	ReplicatedSlot1.bLeanLeft = Slot.bLeanLeft;
	ReplicatedSlot1.bLeanRight = Slot.bLeanRight;
	ReplicatedSlot1.bCanPopUp = Slot.bCanPopUp;
	ReplicatedSlot1.bCanMantle = Slot.bCanMantle;
	ReplicatedSlot1.bCanCoverSlip_Left = Slot.bCanCoverSlip_Left;
	ReplicatedSlot1.bCanCoverSlip_Right = Slot.bCanCoverSlip_Right;
	ReplicatedSlot1.bCanSwatTurn_Left = Slot.bCanSwatTurn_Left;
	ReplicatedSlot1.bCanSwatTurn_Right = Slot.bCanSwatTurn_Right;
	ReplicatedSlot1.CoverType = Slot.CoverType;
	ReplicatedSlot1.LocationOffset = Slot.LocationOffset;
	ReplicatedSlot1.RotationOffset = Slot.RotationOffset;
	
	// force replication
	ForceNetRelevant();
}

/**
 * Watch for replicated cover slots
 * 
 * @param VarName - the name of the variable replicated
 */
simulated event ReplicatedEvent(Name VarName)
{
	if (VarName == nameof(ReplicatedSlot0))
	{
		if (Slots.Length < 1)
		{
			Slots.Length = 1;
		}

		// apply all of the slot information
		Slots[0].bCanMantle = ReplicatedSlot0.bCanMantle;
		Slots[0].bLeanLeft = ReplicatedSlot0.bLeanLeft;
		Slots[0].bLeanRight = ReplicatedSlot0.bLeanRight;
		Slots[0].bCanPopUp = ReplicatedSlot0.bCanPopUp;
		Slots[0].bCanMantle = ReplicatedSlot0.bCanMantle;
		Slots[0].bCanCoverSlip_Left = ReplicatedSlot0.bCanCoverSlip_Left;
		Slots[0].bCanCoverSlip_Right = ReplicatedSlot0.bCanCoverSlip_Right;
		Slots[0].bCanSwatTurn_Left = ReplicatedSlot0.bCanSwatTurn_Left;
		Slots[0].bCanSwatTurn_Right = ReplicatedSlot0.bCanSwatTurn_Right;
		Slots[0].CoverType = ReplicatedSlot0.CoverType;
		Slots[0].LocationOffset = ReplicatedSlot0.LocationOffset;
		Slots[0].RotationOffset = ReplicatedSlot0.RotationOffset;
	}
	else if (VarName == nameof(ReplicatedSlot1))
	{
		if (Slots.Length < 2)
		{
			Slots.Length = 2;
		}

		// apply all of the slot information
		Slots[1].bCanMantle = ReplicatedSlot1.bCanMantle;
		Slots[1].bLeanLeft = ReplicatedSlot1.bLeanLeft;
		Slots[1].bLeanRight = ReplicatedSlot1.bLeanRight;
		Slots[1].bCanPopUp = ReplicatedSlot1.bCanPopUp;
		Slots[1].bCanMantle = ReplicatedSlot1.bCanMantle;
		Slots[1].bCanCoverSlip_Left = ReplicatedSlot1.bCanCoverSlip_Left;
		Slots[1].bCanCoverSlip_Right = ReplicatedSlot1.bCanCoverSlip_Right;
		Slots[1].bCanSwatTurn_Left = ReplicatedSlot1.bCanSwatTurn_Left;
		Slots[1].bCanSwatTurn_Right = ReplicatedSlot1.bCanSwatTurn_Right;
		Slots[1].CoverType = ReplicatedSlot1.CoverType;
		Slots[1].LocationOffset = ReplicatedSlot1.LocationOffset;
		Slots[1].RotationOffset = ReplicatedSlot1.RotationOffset;
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** notification that a pawn is mantling over cover provided by this CoverLink */
delegate NotifyMantle(GearPawn Mantler);

defaultproperties
{
	// for spawnability
	bNoDelete=FALSE

	// for replication
	bAlwaysRelevant=TRUE
	RemoteRole=ROLE_SimulatedProxy
	bUpdateSimulatedPosition=true

	bSkipPathUpdate=FALSE
}
