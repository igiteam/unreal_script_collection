
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GSM_Ticker_Melee extends GearSpecialMove;

/** animation */
var() array<Name> AttackAnimations;
var() GearPawn.BodyStance BS_Animation;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustNakedTickerBase Ticker;

	Super.SpecialMoveStarted(bForced,PrevMove);

	Ticker = GearPawn_LocustNakedTickerBase(PawnOwner);

	if (AttackAnimations.length > 0)
	{
		BS_Animation.Stance.Length = 1; // Array of struct needs to be pre-sized.
		BS_Animation.Stance[0].Slot = BS_FullBody;
		BS_Animation.Stance[0].AnimName = AttackAnimations[rand(AttackAnimations.length)];
		PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);
	}
	else
	{
		PawnOwner.SetTimer(0.5, false, 'EndSpecialMove', PawnOwner);
		Ticker.SetTimer(0.1, false, 'ANIM_NOTIFY_DoMeleeDamage');
	}

	// player-controlled tickers get melee adhesion
	if (PCOwner != None)
	{
		PCOwner.AttemptMeleeAdhesion();
	}

	PawnOwner.PlaySound(Ticker.MeleeSound, TRUE);
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	if (PCOwner != None)
	{
		PCOwner.StopMeleeAdhesion();
	}
}

defaultproperties
{
	AttackAnimations(0)="low_attack"

	bLockPawnRotation=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=TRUE
}
