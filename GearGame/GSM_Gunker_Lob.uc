
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Gunker_Lob extends GearSpecialMove;


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
		GunkerPawn.StartGunkLobChargingEffect();
		// Play body stance animation
		GunkerPawn.AnimSeq_Lob.SetAnim('Gunker_Attack_LtArm_LongFwd');
		GunkerPawn.AnimSeq_Lob.PlayAnim();
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
