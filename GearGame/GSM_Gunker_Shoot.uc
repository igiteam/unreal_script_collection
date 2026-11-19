
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Gunker_Shoot extends GearSpecialMove;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustGunkerBase GunkerPawn;

	Super.SpecialMoveStarted(bForced,PrevMove);

	GunkerPawn = GearPawn_LocustGunkerBase(PawnOwner);
	if (GunkerPawn != None)
	{
		// Have the gunker pause his dripping effect
		GunkerPawn.PauseGunkDripEffect();
		// Have the gunker start the charging effect
		GunkerPawn.StartGunkShootChargingEffect();
		// Play body stance animation
		GunkerPawn.AnimSeq_Shoot.SetAnim('Gunker_Attack_LtArm_ShortFwd');
		GunkerPawn.AnimSeq_Shoot.PlayAnim();
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
}
