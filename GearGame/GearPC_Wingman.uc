/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPC_Wingman extends GearPC_MP;

/** 
 * Calculate win/loss scores for the game from the GRI
 * @param PRI - player of interest
 * @param RoundCount - number of rounds
 * @param RoundsWon - number of rounds won
 * @param RoundsLost - number of rounds lost
 */
simulated function CalcWinLoss(GearPRI PRI, int RoundCount, out int RoundsWon, out int RoundsLost)
{
	local GearGRI GRI;
	local int TeamIndex;
	local bool bDidWin;

	// Get the GRI so we can iterate players
	GRI = GearGRI(WorldInfo.GRI);

	bDidWin = true;
	// Search through all teams and see if we had the highest score or not
	for (TeamIndex = 0; TeamIndex < GRI.Teams.Length; TeamIndex++)
	{
		if (PRI.Team.TeamIndex != GRI.Teams[TeamIndex].TeamIndex)
		{
			// See if we lost this match
			if (PRI.Team.Score < GRI.Teams[TeamIndex].Score)
			{
				bDidWin = false;
				break;
			}
		}
	}

	if (bDidWin)
	{
		RoundsWon = 1;
		RoundsLost = 0;
	}
	else
	{
		RoundsWon = 0;
		RoundsLost = 1;
	}
}
