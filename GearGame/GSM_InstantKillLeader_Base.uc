 /* base class of special moves whose result is Leader killing Follower
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_InstantKillLeader_Base extends GSM_InteractionPawnLeader_Base
	native(SpecialMoves)
	abstract;

/** bonus XP given for execution (multiplied by AnimLength) */
var config int XPBonusPerSec;
/** whether to show the center of HUD XP bonus immediately when it is awarded (otherwise wait until the execution ends) */
var bool bImmediateXPDisplay;
/** total points the killer was awarded for this instance of the execution (some can have modified durations/looping segments) */
var int XPAwarded;

function AwardBonusXP(float InAnimLength)
{
	local int XPBonus;

	if ( PawnOwner.Role == ROLE_Authority && PawnOwner.IsHumanControlled() &&
		PawnOwner.WorldInfo.GRI.IsMultiplayerGame() && !PawnOwner.WorldInfo.GRI.IsCoopMultiplayerGame() )
	{
		XPBonus = XPBonusPerSec * InAnimLength;
		GearPRI(PawnOwner.PlayerReplicationInfo).ExpBuckets[eEXP_Executions] += XPBonus;
		if (bImmediateXPDisplay && PCOwner != None)
		{
			PCOwner.ClientAddKillPoints(XPBonus);
		}

		XPAwarded += XPBonus;
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	XPAwarded = 0;

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	if (XPAwarded > 0 && PCOwner != None)
	{
		if (!bImmediateXPDisplay)
		{
			PCOwner.ClientAddKillPoints(XPAwarded);
		}
		PCOwner.ClientExecutionXPMessage(XPAwarded);
	}
}
