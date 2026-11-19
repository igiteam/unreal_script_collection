
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CorpserLarvaUnderground_Melee extends GSM_BasePlaySingleAnim;

// animations
var GearPawn.BodyStance BS_SingleClawAttack, BS_ThreeClawAttack;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	PawnOwner.Mesh.SetHidden(FALSE);
}

function PlayAnimation()
{
	// Select animation to play based on SpecialMoveFlags property
	BS_Animation = ((PawnOwner.SpecialMoveFlags == 0) ? BS_SingleClawAttack : BS_ThreeClawAttack);
	Super.PlayAnimation();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.Mesh.SetHidden(TRUE);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_SingleClawAttack=(Stance=((Slot=BS_FullBody,AnimName="single_claw_attack")))
	BS_ThreeClawAttack=(Stance=((Slot=BS_FullBody,AnimName="three_claw_attack")))
	BlendOutTime=0.33f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}
