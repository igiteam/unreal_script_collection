
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MomCorpser_Stab extends GearSpecialMove;

var() GearPawn_LocustMomCorpserBase Corpser;
var() GearAI_MomCorpser             CorpserAI;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	Corpser = GearPawn_LocustMomCorpserBase(PawnOwner);
	CorpserAI = GearAI_MomCorpser(PawnOwner.Controller);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Corpser.ResetEncroachers();
	Corpser.FullBodyNode.StopCustomAnim( 0.5f );

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

function EndSpecialMove()
{
	PawnOwner.EndSpecialMove();
}

function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	Corpser.UpdateStabPattern( CorpserAI.Enemy );
	if( !Corpser.AnyLegAttacking() )
	{
		EndSpecialMove();
	}
}


defaultproperties
{
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=TRUE
}