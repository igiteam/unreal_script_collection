
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Player Covering Head, Pushed/Sliding away from an Actor.
 */

class GSM_CoverHeadPushed extends GearSpecialMove
	native(SpecialMoves)
	config(Pawn);

/** Animations */
var() GearPawn.BodyStance BS_Start, BS_Loop, BS_End;
/** Rotation Speed (ROTATOR Units) */
var() const FLOAT RotationSpeed;

cpptext
{
	void PrePerformPhysics(FLOAT DeltaTime);
}

protected function bool InternalCanDoSpecialMove()
{
	// don't cover head if in cover
	return (PawnOwner.DrivenVehicle == None && PawnOwner.CoverType == CT_None && Super.InternalCanDoSpecialMove());
}

function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return (InMove == PawnOwner.SpecialMove && PawnOwner.CanCoverHead());
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// Play intro animation
	PawnOwner.BS_Play(BS_Start, SpeedModifier, 0.2f/SpeedModifier, -1.f, FALSE, TRUE);
	// Get notification when animation stopped playing.
	PawnOwner.BS_SetAnimEndNotify(BS_Start, TRUE);
}

/** AnimEnd notification */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local FLOAT OriginalRate;
	
	// Find play rate of animation that just ended.
	OriginalRate = PawnOwner.BS_GetPlayRate(BS_Start);

	// Play Looping Animation.
	PawnOwner.BS_Play(BS_Loop, SpeedModifier, 0.f, 0.f, TRUE);
	// Position the animation for seamless transition.
	PawnOwner.BS_SetPosition(BS_Loop, ExcessTime * OriginalRate);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// End notification
	PawnOwner.BS_SetAnimEndNotify(BS_Start, FALSE);

	// Stop cringe anims, play the end cringe animation.
	PawnOwner.BS_Stop(BS_Start, 0.33f/SpeedModifier);
	PawnOwner.BS_Stop(BS_Loop, 0.33f/SpeedModifier);

	// Play outro animation
	PawnOwner.BS_Play(BS_End, SpeedModifier, 0.33f/SpeedModifier, 0.33f, FALSE, TRUE);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	RotationSpeed=8.f

	BS_Start=(Stance=((Slot=BS_FullBody,AnimName="ar_injured_headcover1_start")))
	BS_Loop=(Stance=((Slot=BS_FullBody,AnimName="ar_injured_headcover1_idle")))
	BS_End=(Stance=((Slot=BS_FullBody,AnimName="ar_injured_headcover1_end")))

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE

	bBreakFromCover=TRUE
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
}
