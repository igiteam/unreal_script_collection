
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GSM_LambentPolyp_Melee extends GearSpecialMove;

/** animation */
var() array<Name> AttackAnimations;
var() GearPawn.BodyStance BS_Animation;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	if( AttackAnimations.length > 0 )
	{
		BS_Animation.Stance[0].AnimName = AttackAnimations[rand(AttackAnimations.length)];
		PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE);

		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);
	}
	else
	{
		PawnOwner.SetTimer(0.5, false, 'EndSpecialMove', PawnOwner);
		GearPawn_LambentPolypBase(PawnOwner).SetTimer(0.1, false, 'ANIM_NOTIFY_DoMeleeDamage');
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
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="low_attack")))
	AttackAnimations(0)="low_attack"
	AttackAnimations(1)="jump_attack"

	bLockPawnRotation=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
}
