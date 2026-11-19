/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class WalkVolume extends PhysicsVolume
	native;

var() bool bActive;

/** whether this volume reduces movement speed or simply prevents special moves */
var() bool bReducesMovementSpeed;
/** Will force pawns to holster their weapons when they enter the volume */
var() bool bHolsterWeaponOnEnter;
/** Will force pawns to equip their weapons when they exit the volume */
var() bool bEquipWeaponOnExit;
/** Allows the player to do the normal jog when roadie running in the volume */
var() bool bCanRoadieJog;

replication
{
	if (bNetDirty)
		bActive;
}

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local GearPawn GP;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if (bActive && bHolsterWeaponOnEnter)
	{
		GP = GearPawn(Other);
		if (GP != None)
		{
			GP.HolsterWeapon();
		}
	}
}

simulated event UnTouch( Actor Other )
{
	local GearPawn GP;

	Super.UnTouch(Other);

	if (bEquipWeaponOnExit)
	{
		GP = GearPawn(Other);
		if (GP != None)
		{
			GP.UnHolsterWeapon();
		}
	}
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	local GearPawn Pawn;
	local bool bWasActive;

	// Need to know if this volume was active before the toggle
	bWasActive = bActive;

	if (Action.InputLinks[0].bHasImpulse)
	{
		bActive = true;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bActive = false;
	}
	else if (Action.InputLinks[2].bHasImpulse)
	{
		bActive = !bActive;
	}
	if (bActive)
	{
		// abort any active roadie runs
		foreach WorldInfo.AllPawns(class'GearPawn',Pawn)
		{
			if (Pawn.PhysicsVolume == self &&
				Pawn.IsDoingSpecialMove(SM_RoadieRun))
			{
				Pawn.EndSpecialMove(SM_RoadieRun);
			}
		}

		// If it was inactive, but now is
		if (!bWasActive)
		{
			// Tell all pawns in the volume to holster their weapon
			if (bHolsterWeaponOnEnter)
			{
				foreach WorldInfo.AllPawns(class'GearPawn',Pawn)
				{
					Pawn.HolsterWeapon();
				}
			}
		}
	}
	else
	{
		// If it was active but is no longer
		if (bWasActive)
		{
			if (bEquipWeaponOnExit)
			{
				foreach WorldInfo.AllPawns(class'GearPawn',Pawn)
				{
					Pawn.UnHolsterWeapon();
				}
			}
		}
	}
	SetForcedInitialReplicatedProperty(Property'GearGame.WalkVolume.bActive', true);
	bForceNetUpdate = true;
}

function bool ShouldSaveForCheckpoint()
{
	return true;
}

function CreateCheckpointRecord(out PhysicsVolume.CheckpointRecord Record)
{
	Super.CreateCheckpointRecord(Record);
	Record.bActive = bActive;
}

function ApplyCheckpointRecord(const out PhysicsVolume.CheckpointRecord Record)
{
	Super.ApplyCheckpointRecord(Record);
	bActive = Record.bActive;
	SetForcedInitialReplicatedProperty(Property'GearGame.WalkVolume.bActive', true);
}

defaultproperties
{
	bActive=true
	bReducesMovementSpeed=true
	RemoteRole=ROLE_SimulatedProxy
	NetUpdateFrequency=1.0
	bAlwaysRelevant=true
	bCanRoadieJog=true
}
