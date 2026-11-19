
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_RaiseShieldOverHead extends GearSpecialMove
	native(SpecialMoves)
	config(Pawn);

var()	GearPawn.BodyStance	BS_ShieldCoverHeadLoop;

/** This is how long a pawn will spend covering their head when doing this SpecialMove **/
var() config float TimeSpentCoveringHead;

cpptext
{
	virtual FLOAT GetSpeedModifier();
}

protected function bool InternalCanDoSpecialMove()
{
	if( !Super.InternalCanDoSpecialMove() || PawnOwner.SpecialMove != SM_None )
	{
		return FALSE;
	}

	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Play intro animation
	PawnOwner.BS_Play(BS_ShieldCoverHeadLoop, SpeedModifier, 0.33f/SpeedModifier, -1.f, TRUE, TRUE);
	if( PawnOwner.EquippedShield != None )
	{
		PawnOwner.EquippedShield.Expand();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Stop all animations.
	PawnOwner.BS_Stop(BS_ShieldCoverHeadLoop, 0.33f/SpeedModifier);
	if( PawnOwner.EquippedShield != None )
	{
		PawnOwner.EquippedShield.Retract();
	}
}

defaultproperties
{
	BS_ShieldCoverHeadLoop=(Stance=((Slot=BS_Std_Up,AnimName="BS_Hail_Cover"),(Slot=BS_Std_Idle_Lower,AnimName="BS_Hail_Cover")))

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bBreakFromCover=FALSE
	bDisableMovement=FALSE
	bLockPawnRotation=FALSE
}
