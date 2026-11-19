/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Defines the quick emergence hole spawner.
 */
class GearSpawner_DrudgeStalk extends GearSpawner;

/** Cache the drudge pawn */
var transient GearPawn_LambentDroneMutatable DrudgePawn;

/**
 * Overridden to start the activation if it was not already started, and to reject spawns if this spawner is used up
 *	@param out_SpawnSlotIdx - spawn slot to be used, or overridden with spawn slot that will be used
 *	@param out_SpawnLocation - location where the spawn will occur
 *	@param out_SpawnRotation - rotation for the spawn
 *	@return True if the entrance is willing to accept the spawn, False otherwise.
 */
event bool GetSpawnSlot(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation)
{
	// If DrudgePawn doesn't exist, or is dead, disable spawner
	if( DrudgePawn == None || DrudgePawn.bDeleteMe || DrudgePawn.Health <= 0 )
	{
		bActive = FALSE;
		DeActivated();
		return FALSE;
	}
	// If stalk is closed, begin opening
	else if( DrudgePawn.StalkState == ESS_Closed || DrudgePawn.StalkState == ESS_Closing )
	{
		DrudgePawn.OpenTrunk();
		return FALSE;
	}
	else if( DrudgePawn.StalkState != ESS_Open )
	{
		return FALSE;
	}

	DrudgePawn.SetTimer(1.f, false, 'CloseTrunk');
	return Super.GetSpawnSlot(out_SpawnSlotIdx, out_SpawnLocation, out_SpawnRotation);
}

/**
 * Called when a new pawn is spawned using this spawner,
 * use to handle any special behaviors, such as playing
 * an animation, etc.
 *	@param NewSpawn - The pawn that was just spawned
 *	@param SlotIdx - The spawn slot index that was used to spawn this pawn
 */
event HandleSpawn(GearPawn NewSpawn, int SlotIdx)
{
	local GearAI AI;

	AI = GearAI(NewSpawn.Controller);
	if (AI != None)
	{
		AI.DoEmerge(SM_Emerge_Type3);
		DrudgePawn.PolypSpawnEffects();
	}
}

defaultproperties
{
	bAutoDeActivate=false
	bNoDelete=false
}
