/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_SP_Arcade extends GearGRI_SP
	config(Game);

/** score multiplier for the entire team */
var repnotify protectedwrite float TeamMultiplier;
/** for each point a player is awarded the multiplier increases by this amount */
var config float MultiplierGrowthRate;
/** Highest multiplier achieved */
var transient float HighestMultiplier;

replication
{
	if (bNetDirty)
		TeamMultiplier;
}

simulated event ReplicatedEvent(name VarName)
{
	local GearPC PC;
	if (VarName == 'TeamMultiplier')
	{
		HighestMultiplier = Max(TeamMultiplier, HighestMultiplier);
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			PC.ModifyStat('HighestMultiplierArcade', HighestMultiplier, GEARSTATMODTYPE_Maximum);
		}
	}

	Super.ReplicatedEvent(VarName);
}

/** notification that a player has gained the specified number of points */
final function NotifyPointsAwarded(float Score)
{
	ModifyMultiplier(Score * MultiplierGrowthRate);
}

/** increments or decrements the multiplier by the specified amount */
final function ModifyMultiplier(float Amount)
{
	local GearPC Player;
	local int NumPlayers;

	TeamMultiplier = FMax(TeamMultiplier + Amount, 1.0);
	HighestMultiplier = Max(TeamMultiplier, HighestMultiplier);

	if (GearGame(WorldInfo.Game) != None)
	{
		if (HighestMultiplier >= 20)
		{
			NumPlayers = GearGame(WorldInfo.Game).GetHumanPlayerCount();
			if (NumPlayers == 4)
			{
				foreach WorldInfo.AllControllers(class'GearPC', Player)
				{
					if (!Player.bPendingDelete)
					{
						// @ACHIEVEMENT - Don't You Die On Me
						Player.ClientUnlockAchievement(eGA_DONTYOUDIEONME);
					}
				}
			}
		}
	}
}

/** resets the multiplier to the default value */
final function ResetMultiplier()
{
	TeamMultiplier = default.TeamMultiplier;
	HighestMultiplier = TeamMultiplier;
}

defaultproperties
{
	TeamMultiplier=1.0
}
