/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_Gunker_CloseQuarters extends AICmd_Base_Gunker
	within GearAI_GunkerCloseQuarters;

/** Range to rest after doing a chop attack */
var vector2D ChopWaitingRange;
/** The selected waiting period out of ChopWaitingRange */
var float ChopWaitingPeriod;
/** When the last chop attack occurred */
var float LastChopTime;

/** Range to rest after doing a Lob attack */
var vector2D LobWaitingRange;
/** The selected waiting period out of LobWaitingRange */
var float LobWaitingPeriod;
/** When the last Lob attack occurred */
var float LastLobTime;


auto state InCombat
{	
	/**
	 * Never shoot attack 
	 */
	function bool CanShootAttack(Actor TargetToAttack, bool bIgnoreRange, bool bIgnoreTrace)
	{
		return FALSE;
	}

	function bool CanLobAttack( Actor TargetToAttack, bool bUseTimePause)
	{
		if (`TimeSince(LastLobTime) < LobWaitingPeriod)
		{
			return FALSE;
		}

		return Super.CanLobAttack(TargetToAttack, bUseTimePause);
	}

	/**
	 * Save the initial location of the enemy being lobbed and set up the lob time limiter
	 * @param TargetToAttack - the enemy being lobbed
	 */
	function NotifyLobAttack(Actor TargetToAttack)
	{
		LastLobTime = WorldInfo.TimeSeconds;
		LobWaitingPeriod = RandRange(LobWaitingRange.X, LobWaitingRange.Y);
		Super.NotifyLobAttack(TargetToAttack);
	}


	/**
	 * Save off the initial enemy location that we're chopping
	 * @param TargetToAttack - the pawn that is going to get chopped
	 * @return TRUE if we can chop the pawn
	 */
	function bool CanChopAttack(Actor TargetToAttack)
	{
		if (`TimeSince(LastChopTime) < ChopWaitingPeriod)
		{
			return FALSE;
		}

		return Super.CanChopAttack(TargetToAttack);
	}

	/**
	 * Save the initial location of the enemy being chopped and set up the chop time limiter
	 * @param TargetToAttack - the enemy being chopped
	 */
	function NotifyChopAttack(Actor TargetToAttack)
	{
		LastChopTime = WorldInfo.TimeSeconds;
		ChopWaitingPeriod = RandRange(ChopWaitingRange.X, ChopWaitingRange.Y);

		Outer.FarMeleeLocation = TargetToAttack.Location;

		Super.NotifyChopAttack(TargetToAttack);
	}
}

defaultproperties
{
	ChopWaitingRange=(X=1,Y=4)
	LobWaitingRange=(X=1,Y=4)
}