/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Sentry_Kamikaze extends GearSpecialMove;

/** Eating animation */
var()	GearPawn.BodyStance	BS_Loop;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Loop, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, TRUE, TRUE);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
	PawnOwner.BS_Stop(BS_Loop, 0.2f/SpeedModifier);
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	BS_Loop=(Stance=((Slot=BS_FullBody,AnimName="Spin_Loop")))
	bDisableCollision=FALSE
}
