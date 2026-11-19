
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CorpserLarva_Melee extends GSM_BasePlaySingleAnim;

var() GearPawn_LocustCorpserLarvaUndergroundBase Corpser;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	Corpser = GearPawn_LocustCorpserLarvaUndergroundBase(PawnOwner);
	Corpser.ResetEncroachers();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Corpser.ResetEncroachers();

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Melee")))
	BlendOutTime=0.33f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}
