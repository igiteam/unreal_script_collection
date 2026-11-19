
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_SavageDrone_EmergeFromUnderground extends GSM_EmergeQuickJump;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);
	PawnOwner.SetTimer(0.5f, false, 'RestoreCollision', self);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Have Pawn try to Roar
	PawnOwner.SetTimer(4.f, TRUE, 'TryToRoar');

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	TakeoffVelocityHorizMin=100.0
	TakeoffVelocityHorizMax=200.0
	TakeoffVelocityVertMin=800.0
	TakeoffVelocityVertMax=1000.0
}
