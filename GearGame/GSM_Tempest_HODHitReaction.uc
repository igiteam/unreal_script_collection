
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_HODHitReaction extends GearSpecialMove;

/** HitReaction anim stance **/
var GearPawn.BodyStance BS_HitReaction;

/** Cached variable to tempest **/
var GearPawn_LocustTempestBase Tempest;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Tempest = GearPawn_LocustTempestBase(PawnOwner);		

	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.BS_Play(BS_HitReaction, 1.0, 0.2, 0.2, true);
}

/**
 * Can the special move be chained after the current one finishes?
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return NextMove == SM_Tempest_Thrash;
}

function bool CanOverrideMoveWith( ESpecialMove NewMove )
{
	if (NewMove == SM_Tempest_TakeOff || NewMove == SM_Tempest_Thrash)
	{
		return TRUE;
	}
	return Super.CanOverrideMoveWith(NewMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	bDisableAI=true
	bLockPawnRotation=true
	BS_HitReaction=(Stance=((Slot=BS_FullBody,AnimName="HitReaction_HOD")))
}