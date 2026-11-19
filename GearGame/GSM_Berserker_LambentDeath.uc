
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_LambentDeath extends GSM_DeathAnimBase;


function bool PlayDeathAnimation(class<GearDamageType> DamageType, vector HitLoc)
{
	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustBerserkerLambentBase BerserkerPawn;

	Super.SpecialMoveStarted(bForced,PrevMove);

	BerserkerPawn = GearPawn_LocustBerserkerLambentBase(PawnOwner);
	if (BerserkerPawn != None)
	{
		BerserkerPawn.StartDeathSequence();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_LocustBerserkerLambentBase BerserkerPawn;

	DeathAnimBlendToMotors();
	Super.SpecialMoveEnded(PrevMove, NextMove);
	
	BerserkerPawn = GearPawn_LocustBerserkerLambentBase(PawnOwner);
	if (BerserkerPawn != None)
	{
		BerserkerPawn.StopDeathSequence();
	}
}


defaultproperties
{
	bDisableAI=TRUE
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
}
