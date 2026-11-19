
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CorpserLarva_EmergeFromEHole extends GSM_BasePlaySingleAnim;

var() protected vector IdealCamOriginWorldOffset;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustCorpserLarvaUndergroundBase Corpser;

	// Call Super first
	Super.SpecialMoveStarted(bForced, PrevMove);

	Corpser = GearPawn_LocustCorpserLarvaUndergroundBase(PawnOwner);
	if( Corpser != None )
	{
		Corpser.SetTimer(0.67f, FALSE, 'StartPushAwayPlayers', Corpser);
		// Setup our pawn for Above ground...
		Corpser.SetupForAboveGround();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_LocustCorpserLarvaUndergroundBase Corpser;

	Corpser = GearPawn_LocustCorpserLarvaUndergroundBase(PawnOwner);
	if( Corpser != None )
	{
		Corpser.StopPushAwayPlayers();

		Corpser.TriggerEventClass(class'SeqEvt_MiniCorpserSurface', Corpser, 0);
	}

	PawnOwner.ClearTimer('StartPushAwayPlayers', PawnOwner);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

simulated function vector GetIdealCameraOrigin()
{
	return PawnOwner.Mesh.GetBoneLocation('Upper_Spine_2') + IdealCamOriginWorldOffset;
}


defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="ehole_emerge")))
	BlendInTime=0.f
	BlendOutTime=0.67f

	bLockPawnRotation=TRUE
	bDisableMovement=TRUE
	
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bDisableAI=TRUE

	bOverrideCameraOrigin=true
	IdealCamOriginWorldOffset=(Z=50)
}
