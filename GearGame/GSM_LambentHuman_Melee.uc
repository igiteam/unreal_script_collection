
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GSM_LambentHuman_Melee extends GearSpecialMove
	config(Pawn);

/** Animation */
var() array<Name> AttackAnimations;
var() GearPawn.BodyStance BS_Animation;

/** Probabiltiy of exploding after completing this special move */
var() config float ExplosionChance;

/** Reference to lambent human PawnOwner */
var transient GearPawn_LambentHumanBase LambentHuman;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	LambentHuman = GearPawn_LambentHumanBase(PawnOwner);

	Super.SpecialMoveStarted(bForced,PrevMove);

	if( AttackAnimations.length > 0 )
	{
		BS_Animation.Stance.Length = 1; // Array of struct needs to be pre-sized.
		BS_Animation.Stance[0].Slot = BS_FullBody;
		BS_Animation.Stance[0].AnimName = AttackAnimations[rand(AttackAnimations.length)];
		PawnOwner.BS_Play(BS_Animation, SpeedModifier * LambentHuman.PawnSpeedModifier, 0.2f/(SpeedModifier*LambentHuman.PawnSpeedModifier), 0.2f/(SpeedModifier*LambentHuman.PawnSpeedModifier), FALSE, TRUE);

		// Enable end of animation notification. This is going to call SpecialMoveEnded()
		PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);
	}
	else
	{
		PawnOwner.SetTimer(0.5, false, 'EndSpecialMove', PawnOwner);
		GearPawn_LambentHumanBase(PawnOwner).SetTimer(0.1, false, 'ANIM_NOTIFY_DoMeleeDamage');
	}
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Disable end of animation notification. 
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	if( FRand() < ExplosionChance )
	{
		PawnOwner.Died(PawnOwner.Controller, class'GDT_Melee', PawnOwner.Location);
	}
}

/** Allow our melee to be interrupted by a stumble */
function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	return ( Super.CanOverrideMoveWith(NewMove) || NewMove == SM_StumbleFromMelee || NewMove == SM_StumbleFromMelee2 || NewMove == SM_StumbleFromMantleKick );
}

defaultproperties
{
	AttackAnimations(0)="attack_left"
	AttackAnimations(1)="attack_left_backhand"
	AttackAnimations(2)="attack_left_high"
	AttackAnimations(3)="attack_right"
	AttackAnimations(4)="attack_right_backhand"
	AttackAnimations(5)="attack_right_high"

	bLockPawnRotation=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
}
