
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Serapede_Cringe extends GearSpecialMove;
	 
/** animation */
var()	GearPawn.BodyStance	BS_Animation;

var transient GearPawn_LocustSerapedeBase Serapede;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);
	PlayAnimation();

	Serapede = GearPawn_LocustSerapedeBase(PawnOwner);
	Serapede.SetRearUp(TRUE);
	PawnOwner.SetTimer(GearPawn_LocustSerapedeBase(PawnOwner).FaceShotHitReactionTime, FALSE, nameOf(EndSpecialMove), self);
}

function PlayAnimation()
{
	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation,SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, TRUE);
}

function EndSpecialMove()
{
	PawnOwner.EndSpecialMove();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Serapede.SetRearUp(FALSE);

	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.BS_Stop(BS_Animation, 0.2f/SpeedModifier);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="ADD_SP_Head_Roar")))
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE

	bDisableMovement=TRUE
}