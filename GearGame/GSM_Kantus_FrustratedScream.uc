
/**
 * The frustrated scream special move for the Armored Kantus
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Kantus_FrustratedScream extends GSM_Kantus_KnockdownScream
	config(Pawn);

function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	return FALSE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustKantusBase Kantus;

	Kantus = GearPawn_LocustKantusBase(PawnOwner);
	if( Kantus != None )
	{
		Kantus.LastSuccessfulKnockdownTime = Kantus.WorldInfo.TimeSeconds;

		if( AIOwner != None )
		{
			AIOwner.Focus = Kantus.KnockDownInstigator;
		}
	}

	Super.SpecialMoveStarted(bForced,PrevMove);
}

defaultproperties
{
	BS_Scream=(Stance=((Slot=BS_Std_Up,AnimName="Kantus_Yell_Frustrated"),(Slot=BS_Std_Idle_Lower,AnimName="Kantus_Yell_Frustrated")))
	bLockPawnRotation=FALSE // Allow Pawn to rotate with his aim offset to track enemy
}