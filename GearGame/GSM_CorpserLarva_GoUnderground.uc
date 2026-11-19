
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CorpserLarva_GoUnderground extends GSM_BasePlaySingleAnim;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local float StartTime, TimeLeftChainsawVictim;

	// Skip super call so we can delay Play Animation
	Super(GearSpecialMove).SpecialMoveStarted(bForced, PrevMove);

	// Default delay before starting animations.
	StartTime = 0.5f;

	// if we've just been chainsawed, add an additional delay to prevent animation clipping.
	TimeLeftChainsawVictim = GearPawn_LocustCorpserLarvaUndergroundBase(PawnOwner).LastChainsawVictimTime;
	
	if( (PawnOwner.WorldInfo.TimeSeconds - TimeLeftChainsawVictim) < 1.f )
	{
		StartTime += 1.f;
	}

	PawnOwner.SetTimer(StartTime, FALSE, 'StartPushAwayPlayers', PawnOwner);
	PawnOwner.SetTimer(StartTime, FALSE, 'PlayAnimation', Self);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_LocustCorpserLarvaUndergroundBase Corpser;

	Corpser = GearPawn_LocustCorpserLarvaUndergroundBase(PawnOwner);
	if( Corpser != None )
	{
		Corpser.StopPushAwayPlayers();
		// Setup our pawn for the Underground...
		Corpser.SetupForUnderground();
	}

	PawnOwner.ClearTimer('StartPushAwayPlayers', PawnOwner);
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="retreat")))
	BlendInTime=0.67f
	BlendOutTime=0.f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE
}
