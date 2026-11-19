
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_ChainsawDuel_Follower extends GSM_InteractionPawnFollower_Base;

var ESpecialMove PrevSpecialMove;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	PrevSpecialMove = PrevMove;

	Super.SpecialMoveStarted(bForced, PrevMove);

	//if( PCOwner != None && PCOwner.MyGearHUD != None )
	//{
	//	PCOwner.MyGearHUD.SetActionInfo(AT_SpecialMove, Action, PawnOwner.bIsMirrored);
	//}
}

function SpecialMoveEnded( ESpecialMove PrevMove, ESpecialMove NextMove )
{
	if( PawnOwner != None )
	{
		PawnOwner.ClearTimer( 'ShowHUDAction', self );
	}

	Super.SpecialMoveEnded( PrevMove, NextMove );
}

