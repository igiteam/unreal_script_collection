
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_CorpserLarva_ChainsawVictim extends GSM_ChainsawVictim;

var BodyStance BS_ReactAnim;

function bool SetChainsawAnims(GearPawn GP, out GSM_ChainsawAttack.HeightAnims Anims, float BlendTime, EChainsawAnimType AnimType)
{
	PawnOwner.BS_Play(BS_ReactAnim, 0.5f, 0.33f, -1.f, TRUE);
	return FALSE; 
}

function SetMeleeAttackTime(float NewTime)
{
	local GearAI_CorpserLarvaUnderground CorpserAI;

	// Make sure there is a time delay before starting another melee attack, because we're really close to our enemy.
	CorpserAI = GearAI_CorpserLarvaUnderground(PawnOwner.Controller);
	if( CorpserAI != None )
	{
		CorpserAI.LastMeleeAttackTime = NewTime;
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Keep track of when we leave this special move.
	if( GearPawn_LocustCorpserLarvaUndergroundBase(PawnOwner) != None )
	{
		GearPawn_LocustCorpserLarvaUndergroundBase(PawnOwner).LastChainsawVictimTime = PawnOwner.WorldInfo.TimeSeconds;
	}

	SetMeleeAttackTime(PawnOwner.WorldInfo.TimeSeconds);
	
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_ReactAnim=(Stance=((Slot=BS_FullBody,AnimName="Chainsaw_react_front")))
}