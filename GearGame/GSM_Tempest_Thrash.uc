
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_Thrash extends GearSpecialMove;

var	GearPawn.BodyStance	BS_Thrash1;

/** Cached variable to tempest **/
var GearPawn_LocustTempestBase Tempest;

/** The currently selected body stance for the move */
var GearPawn.BodyStance BS_Current;

/** Set up animation depending on ground or air **/
function SetupAnimation()
{
	BS_Current = BS_Thrash1;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Tempest = GearPawn_LocustTempestBase(PawnOwner);		
	// 	PawnOwner.LockDesiredRotation(true);

	Super.SpecialMoveStarted(bForced,PrevMove);

	PlayNextAnimation();
}

function PlayNextAnimation()
{
	local float AnimTime;

	SetupAnimation();
	AnimTime = PawnOwner.BS_Play(BS_Current, 1.0, 0.2, 0.2);
	PawnOwner.SetTimer(AnimTime, false, nameof(PlayNextAnimation), self);
}

/**
 * Can the special move be chained after the current one finishes?
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return NextMove == SM_Tempest_TakeOff;
}

function bool CanOverrideMoveWith( ESpecialMove NewMove )
{
	if (NewMove == SM_Tempest_TakeOff)
	{
		return TRUE;
	}
	return Super.CanOverrideMoveWith(NewMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.ClearTimer(nameof(PlayNextAnimation), self);
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Thrash1=(Stance=((Slot=BS_FullBody,AnimName="Idle_Thrashing_1")))
	bDisableAI=true
	bLockPawnRotation=true
}