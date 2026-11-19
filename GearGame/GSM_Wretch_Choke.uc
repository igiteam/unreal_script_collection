/**
 * Wretch grab attack
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Wretch_Choke extends GSM_InteractionPawnFollower_Base;

/** Grab attack looping animation */
var()	GearPawn.BodyStance	BS_Animation;

/**
 * Play the grab attack animation
 * 
 * @param bForced - whether the special move was forced
 * 
 * @param PrevMove - the last special move before this one
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, TRUE, TRUE);
}

/**
 * Play the grab attack animation
 * 
 * @param PrevMove - the last special move before this one
 * 
 * @param NextMove - the special move after this one
 */
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.BS_Stop(BS_Animation);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="swipe")))

	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=TRUE
}