/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMDeathmatch extends TMGame
	config(game);

function bool WantsPickups(TMBot B)
{
	return true;
}

/** return a value based on how much this pawn needs help */
function int GetHandicapNeed(Pawn Other)
{
	local float ScoreDiff;

	if ( Other.PlayerReplicationInfo == None )
	{
		return 0;
	}

	// base handicap on how far pawn is behind top scorer
	TMGameReplicationInfo(GameReplicationInfo).SortPRIArray();
	ScoreDiff = GameReplicationInfo.PriArray[0].Score - Other.PlayerReplicationInfo.Score;

	if ( ScoreDiff < 3 )
	{
		// ahead or close
		return 0;
	}
	return ScoreDiff/3;
}

/**
 * Writes out the stats for the game type
 */
function WriteOnlineStats()
{
	local TMLeaderboardWriteDM Stats;
	local TMPlayerController PC;
	local TMPlayerReplicationInfo PRI;
	local UniqueNetId ZeroUniqueId;
	local int NumInactives;
	local bool bIsPureGame;
	local int i;
	local float TimeInGame;

	if ((SinglePlayerMissionID > INDEX_None) || (WorldInfo.NetMode == NM_Standalone))
	{
		//We don't record single player stats
		return;
	}
	
	// Only calc this if the subsystem can write stats
	if (OnlineSub != None && OnlineSub.StatsInterface != None)
	{
		//Epic content + No bots => Pure
		bIsPureGame = IsPureGame() && !bPlayersVsBots;

		// Iterate through the playercontroller list updating the stats
		foreach WorldInfo.AllControllers(class'TMPlayerController',PC)
		{
			PRI = TMPlayerReplicationInfo(PC.PlayerReplicationInfo);

			// Don't record stats for bots (bots have a zero unique net id)
			// don't record for spectators either (@warning: assumes active players can't become spectators)
			if (PRI != None && !PRI.bOnlySpectator && (PRI.UniqueId != ZeroUniqueId))
			{
				TimeInGame = float(WorldInfo.GRI.ElapsedTime - PRI.StartTime);
				//Game has lasted more than 10 seconds, you've been in at least 30 secs of it or 90% of the elapsed time
				if (WorldInfo.GRI.ElapsedTime > 10 && (TimeInGame >= Min(30.0f, float(WorldInfo.GRI.ElapsedTime) * 0.9f)))
			{
					//`log("Writing out stats for player"@PRI.PlayerName);
				//Write out all relevant stats
					Stats = TMLeaderboardWriteDM(new OnlineStatsWriteClass);
				Stats.CopyAndWriteAllStats(PC.PlayerReplicationInfo.UniqueId, PRI, bIsPureGame, OnlineSub.StatsInterface);
			}
			}
            else
            {
                ;
            } 
		}

		//Write out stats of players who left the game
		NumInactives = InactivePRIArray.length;
		for (i=0; i<NumInactives; i++)
		{
			PRI = TMPlayerReplicationInfo(InactivePRIArray[i]);
		    if (PRI != None && (PRI.UniqueId != ZeroUniqueId))
			{
				;
				//Write out all relevant stats
				Stats = TMLeaderboardWriteDM(new OnlineStatsWriteClass);
				Stats.CopyAndWriteAllStats(PRI.UniqueId, PRI, bIsPureGame, OnlineSub.StatsInterface);
			}
            else
            {
                ;
            } 
		}
	}
}

