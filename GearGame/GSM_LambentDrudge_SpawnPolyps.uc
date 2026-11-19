
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentDrudge_SpawnPolyps extends GSM_BasePlaySingleAnim;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	GearPawn_LambentDroneMutatable(PawnOwner).TrunkOpened();
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Drudge_polyp_emerge")))
	bLockPawnRotation=TRUE

	bCanFireWeapon = FALSE;
}