
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Gunker_Death extends GSM_DeathAnimBase;


function bool PlayDeathAnimation(class<GearDamageType> DamageType, vector HitLoc)
{
	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	Super.SpecialMoveStarted(bForced,PrevMove);

	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		GunkerPawn.StartDeathSequence();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	DeathAnimBlendToMotors();
	Super.SpecialMoveEnded(PrevMove, NextMove);
	
	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		GunkerPawn.StopDeathSequence();
	}
}


defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
}
