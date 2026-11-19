/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearSpawner_LambentLeviathan_Tentacle extends GearSpawner_SpecialSpawnPoint;

event HandleSpawn( GearPawn NewSpawn, int SlotIdx )
{
	local GearAI AI;

	SpawnSlots[SlotIdx].SpawningPawn = NewSpawn;

	NewSpawn.bCollideWorld = FALSE;
	NewSpawn.SetCollision( TRUE, FALSE, FALSE );
	NewSpawn.SetPhysics( PHYS_None );
	if( Base != None )
	{
		NewSpawn.SetBase( Base,, BaseSkelComponent, BaseBoneName );
		NewSpawn.SetRelativeLocation( RelativeLocation );
		NewSpawn.SetRelativeRotation( RelativeRotation );
	}

	AI = GearAI(NewSpawn.Controller);
	if( AI != None )
	{
		AI.bAllowCombatTransitions = FALSE;
	}
}

function OnLevianthanTentackle_Release( SeqAct_LevianthanTentackle_Release inAction )
{
	local GearPawn GP;
	local GearSpawnerDestination SpawnDest;
	local Vector SpawnDir;
	local float SpeedResult;
	local int Idx;
	local GearAI AI;

	GP = SpawnSlots[0].SpawningPawn;
	if( GP == None )
	{
		return;
	}

	GP.SetBase( None );
	
	AI = GearAI(GP.Controller);
	if( AI != None )
	{
		AI.DoEmerge(SM_Emerge_Type2);
		AI.bAllowCombatTransitions = TRUE;
	}
 
	for( Idx = 0; Idx < inAction.Destinations.Length; Idx++ )
	{
		SpawnDest = GearSpawnerDestination(inAction.Destinations[Idx]);
		if( SpawnDest != None )
		{
			break;
		}
	}

	// If we found a destination
	if( SpawnDest != None)
	{
		// Determine the speed to toss the pawn
		SpeedResult = FRand() * (SpawnDest.MaxSpeed - SpawnDest.MinSpeed) + SpawnDest.MinSpeed;
		// Make sure the speed is valid
		if( SpeedResult > 0 )
		{
			GP.SetPhysics(PHYS_Falling);
			// Determine the direction to toss the pawn
			SpawnDir = Normal(SpawnDest.Location-GP.Location);
			// Set the pawn to launch
			GP.Velocity = SpawnDir * SpeedResult;
		}
	}
	else
	{
		GP.SetPhysics(PHYS_Falling);
	}
	GP.bCollideWorld = TRUE;

	SpawnSlots[0].SpawningPawn = None;
}

defaultproperties
{
	bAutoDeActivate=false
	bNoDelete=false
	bStatic=FALSE
	bMovable=TRUE
}
