/**
 * TMKillZVolume
 * Kills pawns using KillZ interface
 *
 *
* Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMKillZVolume extends PhysicsVolume
    placeable;

var() class<DamageType> KillZDamageType;

event ActorEnteredVolume(Actor Other)
{
	if (!Other.bStatic)
	{
		KillActor(Other);
	}
}

event PawnEnteredVolume(Pawn Other)
{
	KillActor(Other);
}

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if (!Other.bStatic)
	{
		KillActor(Other);
	}
}

simulated event KillActor(Actor Other)
{
	if ( !Other.bScriptInitialized )
	{
		// warn if actor was spawned in killz volume (bad)
		;
	}
	Other.FellOutOfWorld(KillZDamageType);
	if ( TMPawn(Other) != None )
	{
		TMPawn(Other).bStopDeathCamera = true;
	}
	else if ( TMVehicle(Other) != None )
	{
		TMVehicle(Other).bStopDeathCamera = true;
	}
}

