
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_RaiseShieldOverHead extends TGSpecialMove
	native(TGSpecialMoves)
	config(TGPawn);

var()	TGPawn.BodyStance	BS_ShieldCoverHeadLoop;

/** This is how long a pawn will spend covering their head when doing this SpecialMove **/
var() config float TimeSpentCoveringHead;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

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

