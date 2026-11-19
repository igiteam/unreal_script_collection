
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_IthycusAttack extends GearSpecialMove;


/** The stance to play the anim on */
var GearPawn.BodyStance BS_Animation;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustIthycusBase FishPawn;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	// Tell the fish to play it's attack sound
	FishPawn = GearPawn_LocustIthycusBase(PawnOwner);
	if (FishPawn != None)
	{
		FishPawn.PlayAttackSound();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Disable end of animation notification. 
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);
}


defaultproperties
{
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Idle")))
}
