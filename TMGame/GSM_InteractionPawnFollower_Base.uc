
/**
 * GSM_InteractionPawnFollower_Base
 * Base class for Pawn to Pawn Interactions.
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_InteractionPawnFollower_Base extends TGSpecialMove;

/** Pointer to Leader */
var TGPawn Leader;
/** Keep track of special move leader is doing during this interaction. */
var protected ESpecialMove LeaderInteractionSpecialMove;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// Keep a simple reference to our Leader.
	Leader = PawnOwner.InteractionPawn;
	// Clear leader interaction special move
	LeaderInteractionSpecialMove = SM_None;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// If Leader is still around, let him know that follower is leaving his special move
	if( Leader != None && Leader.IsGameplayRelevant() && Leader.IsDoingSpecialMove(LeaderInteractionSpecialMove) )
	{
		// Let our leader know that we're now ready to be detached from him.
		if( !Leader.SpecialMoveMessageEvent('FollowerLeavingSpecialMove', PawnOwner) )
		{
			;
		}
	}

	// Clear reference to our leader.
	Leader = None;
	LeaderInteractionSpecialMove = SM_None;

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/** Messages sent to this special move */
function bool MessageEvent(Name EventName, Object Sender)
{
	if( EventName == 'InteractionStarted' )
	{
		InteractionStarted();
		return TRUE;
	}

	return Super.MessageEvent(EventName, Sender);
}

function InteractionStarted()
{
	// Keep track of what special move the leader is doing.
	LeaderInteractionSpecialMove = Leader.SpecialMove;
}

