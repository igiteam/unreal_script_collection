/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/** Class that manages the recent players/match results */
class GearMatchData extends Object
	dependson(GearRecentPlayersList)
	dependson(GearTypes);

/** The last matches' stats object holding everyone's stats */
var GearLeaderboardBase LastMatchResults;

/** The alltime stats for the participants in the last match */
var GearLeaderboardBase AllTimeMatchResults;

/** The last stats write class that we used */
var class<OnlineStatsWrite> LastStatsWriteClass;

/** The last MP map that was played */
var string LastMpMapName;

/** The type of match that was played */
var EGearMPTypes LastMpGameType;

/** The duration of the last match, updated at the end of each round */
var int LastMatchTime;

/** The player's previous high score before they started this round (only valid in certain gametypes) */
var int PreviousHighScore;

/** The player's previous highest wave completed before they started this round (only valid in certain gametypes) */
var int PreviousHighWave;

/** Holds the list of recent players and the extra info the UI needs in the party */
var array<GearRecentPlayerEndMatch> LastMatchPlayers;

/** Holds the list of bots from the last match and the extra info the UI needs in the party */
var array<GearRecentPlayerEndMatch> LastMatchBots;

/* TRUE if this data is incomplete (left midmatch, etc) */
var bool bIncomplete;


/**
 * Sets the previous high score for this game mode
 *
 * @param   HighScore   The previous high score of the player going into this round
 */
function SetPreviousHighScore(int HighScore)
{
	PreviousHighScore = HighScore;
}

/**
 * Sets the previous max wave reached, for horde / beast gametypes
 * 
 * @param   HighWave    The previous high score of the player for this wave
 */
function SetPreviousHighWave(int HighWave)
{
	PreviousHighWave = HighWave;
}

/**
 * Updates the match duration
 * 
 * @param   MatchDuration   New match duration
 */
function UpdateMatchTime(int MatchDuration)
{
	LastMatchTime = MatchDuration;
}

/*
 * Copies relevant data out of the PRI and into the LastMatchData struct
 * @PlayerIndex - index into the last match data for this player
 * @PRI - PRI to copy data from
 */
function CopyPlayerData(int PlayerIndex, GearPRI PRI)
{
	// Copy the information needed by the UI
	LastMatchPlayers[PlayerIndex].Name = PRI.PlayerName;
	if (PRI.PawnClass != None)
	{
		LastMatchPlayers[PlayerIndex].PawnClassName = string(PRI.PawnClass.Name);
		LastMatchPlayers[PlayerIndex].TeamName = PRI.PawnClass.default.CharacterName;
	}

	LastMatchPlayers[PlayerIndex].Skill = PRI.PlayerSkill;
	LastMatchPlayers[PlayerIndex].Level = PRI.PlayerLevel;
	if (PRI.Team != None)
	{
		LastMatchPlayers[PlayerIndex].TeamNum = PRI.GetTeamNum();
		LastMatchPlayers[PlayerIndex].TeamScore = PRI.Team.Score;
	}
}

/**
 * Adds the specified player to the recent match data
 *
 * @param PRI the player replication info to add
 */
function AddPlayer(GearPRI PRI)
{
	local int AddIndex;

	AddIndex = LastMatchPlayers.Length;
	LastMatchPlayers.Length = AddIndex + 1;
	LastMatchPlayers[AddIndex].NetId = PRI.UniqueId;
	CopyPlayerData(AddIndex, PRI);
}

/**
 * Updates the specified player with the final recent match data
 *
 * @param PRI the player replication info to update
 */
function UpdatePlayer(GearPRI PRI)
{
	local int UpdateIndex;

	if (LastMatchResults != None)
	{
	  	LastMatchResults.UpdateFromPRI(PRI);
	}

	UpdateIndex = LastMatchPlayers.Find('NetId',PRI.UniqueId);
	if (UpdateIndex != INDEX_NONE)
	{
		// Mark them as completing and then set their scores
		LastMatchPlayers[UpdateIndex].bDidComplete = true;
		CopyPlayerData(UpdateIndex, PRI);
	}
}

/**
 * Adds the specified bot to the recent match data
 *
 * @param PRI the player replication info to add
 */
function AddBot(GearPRI PRI)
{
	local int AddIndex;

	AddIndex = LastMatchBots.Length;
	LastMatchBots.Length = AddIndex + 1;
	// Copy the information needed by the UI
	LastMatchBots[AddIndex].Name = PRI.PlayerName;
	if (PRI.PawnClass != None)
	{
		LastMatchBots[AddIndex].PawnClassName = string(PRI.PawnClass.Name);
		LastMatchBots[AddIndex].TeamName = PRI.PawnClass.default.CharacterName;
	}

	if (PRI.Team != None)
	{
		LastMatchBots[AddIndex].TeamNum = PRI.GetTeamNum();
		LastMatchBots[AddIndex].TeamScore = PRI.Team.Score;
	}
}

/**
 * Builds a single list of players from the last match array
 *
 * @param Players the array getting the data copied into it
 */
function GetPlayersForStatsRead(out array<UniqueNetId> Players)
{
	local int PlayerIndex;

	Players.Length = 0;
	// Look at each registered party and add them for showing
	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		Players.AddItem(LastMatchPlayers[PlayerIndex].NetId);
	}
}

/**
 * Finds the player indicated and returns their skill rating
 *
 * @param Player the player to search for
 *
 * @return the skill for the specified player
 */
function int GetSkillForPlayer(UniqueNetId Player)
{
	local int PlayerIndex;

	// Search for the specified player and return their skill
	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].NetId == Player)
		{
			return LastMatchPlayers[PlayerIndex].Skill;
		}
	}
	return 0;
}

/**
 * Finds the player indicated and returns their level
 *
 * @param Player the player to search for
 *
 * @return the level for the specified player
 */
function int GetLevelForPlayer(UniqueNetId Player)
{
	local int PlayerIndex;

	// Search for the specified player and return their level
	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].NetId == Player)
		{
			return LastMatchPlayers[PlayerIndex].Level;
		}
	}
	return 0;
}

/**
 * Finds the player indicated and returns their name
 *
 * @param Player the player to search for
 *
 * @return the name for the player
 */
function string GetNameForPlayer(UniqueNetId Player)
{
	local int PlayerIndex;

	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].NetId == Player)
		{
			return LastMatchPlayers[PlayerIndex].Name;
		}
	}
	return "";
}

/**
 * Finds the player indicated and returns their team index
 *
 * @param Player the player to search for
 *
 * @return the name for the player's pawn class
 */
function int GetTeamIndexForPlayer(UniqueNetId Player)
{
	local int PlayerIndex;

	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].NetId == Player)
		{
			return LastMatchPlayers[PlayerIndex].TeamNum;
		}
	}
	return 255;
}

/**
 * Finds the player indicated and returns whether they finished the game or not
 *
 * @param Player the player to search for
 *
 * @return whether the player finished the game or not
 */
function bool PlayerFinishedGame(UniqueNetId Player)
{
	local int PlayerIndex;

	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].NetId == Player)
		{
			return LastMatchPlayers[PlayerIndex].bDidComplete;
		}
	}
	return false;
}

/**
 * Finds the player indicated and returns their pawn class name
 *
 * @param Player the player to search for
 *
 * @return the name for the player's pawn class
 */
function string GetPawnClassNameForPlayer(UniqueNetId Player)
{
	local int PlayerIndex;

	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].NetId == Player)
		{
			return LastMatchPlayers[PlayerIndex].PawnClassName;
		}
	}
	return "";
}

/**
 * Finds the player indicated and returns their team pawn class name
 *
 * @param Player the player to search for
 *
 * @return the name for the player's pawn class
 */
function string GetTeamNameForPlayer(UniqueNetId Player)
{
	local int PlayerIndex;

	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].NetId == Player)
		{
			return LastMatchPlayers[PlayerIndex].TeamName;
		}
	}
	return "";
}

/**
 * Finds the team and returns their score
 *
 * @param TeamNum the team to search for
 *
 * @return the score for the team
 */
function int GetScoreForTeam(int TeamNum)
{
	local int PlayerIndex;

	// First try players
	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].TeamNum == TeamNum)
		{
			return LastMatchPlayers[PlayerIndex].TeamScore;
		}
	}
	// Now try bots
	for (PlayerIndex = 0; PlayerIndex < LastMatchBots.Length; PlayerIndex++)
	{
		if (LastMatchBots[PlayerIndex].TeamNum == TeamNum)
		{
			return LastMatchBots[PlayerIndex].TeamScore;
		}
	}
	return 0;
}

/**
 * Finds the team and returns their localized team name
 *
 * @param TeamNum the team to search for
 *
 * @return localized team name
 */
function string GetTeamName(int TeamNum)
{
	local int PlayerIndex;

	// First try players
	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].TeamNum == TeamNum)
		{
			return LastMatchPlayers[PlayerIndex].TeamName;
		}
	}
	// Now try bots
	for (PlayerIndex = 0; PlayerIndex < LastMatchBots.Length; PlayerIndex++)
	{
		if (LastMatchBots[PlayerIndex].TeamNum == TeamNum)
		{
			return LastMatchBots[PlayerIndex].TeamName;
		}
	}
	return "";
}

/**
 * Builds a single list of players from the last match array for a specific team
 *
 * @param TeamNum the team that we are reading the players for
 * @param Players the array getting the data copied into it
 */
function GetPlayersForTeam(int TeamNum,out array<UniqueNetId> Players)
{
	local int PlayerIndex;

	Players.Length = 0;
	// Look at each registered party and add them for showing
	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].TeamNum == TeamNum)
		{
			Players.AddItem(LastMatchPlayers[PlayerIndex].NetId);
		}
	}
}

/**
 * Builds a single list of bots from the last match array for a specific team
 *
 * @param TeamNum the team that we are reading the bots for
 * @param Bots the array holding the indexes in the LastMatchBots for the bots on this team
 */
function GetBotsForTeam(int TeamNum,out array<int> Bots)
{
	local int PlayerIndex;

	Bots.Length = 0;
	// Look at each registered party and add them for showing
	for (PlayerIndex = 0; PlayerIndex < LastMatchBots.Length; PlayerIndex++)
	{
		if (LastMatchBots[PlayerIndex].TeamNum == TeamNum)
		{
			Bots.AddItem(PlayerIndex);
		}
	}
}

/**
 * Builds a single list of players from the last match array for a specific team
 *
 * @param TeamNum the team that we are reading the players for
 * @param Players the array getting the data copied into it
 */
function GetPlayersNotOnTeam(int TeamNum,out array<UniqueNetId> Players)
{
	local int PlayerIndex;

	Players.Length = 0;
	// Look at each registered party and add them for showing
	for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
	{
		if (LastMatchPlayers[PlayerIndex].TeamNum != TeamNum)
		{
			Players.AddItem(LastMatchPlayers[PlayerIndex].NetId);
		}
	}
}

/** 
 * Orders the players list by their corresponding overall rank
 *
 * @param   SortedPlayers   Out param that will contain a sorted list of NetIds pertaining to the players
 */
function SortPlayersByRank(out array<UniqueNetId> SortedPlayers)
{
	local array<int> SortedRank;
	local int PlayerIndex;
	local int SearchIndex;
	local bool bWasInserted;
	local UniqueNetId NetId;
	local int Rank;

	if (AllTimeMatchResults != None)
	{
		SortedRank.Length = 0;
		// Look at each registered player and sort them into the new array
		for (PlayerIndex = 0; PlayerIndex < LastMatchPlayers.Length; PlayerIndex++)
		{
			bWasInserted = false;
			// Get the id for the next player
			NetId = LastMatchPlayers[PlayerIndex].NetId;
			// Search for the overall rank from the leaderboard
			Rank = AllTimeMatchResults.GetRankForPlayer(NetId);
			// Force unranked players to the bottom
			if (Rank == 0)
			{
				Rank = 1000000000;
			}
			// Search the set of ranks to find where to insert
			for (SearchIndex = 0; SearchIndex < SortedRank.Length; SearchIndex++)
			{
				// See if their rank is better
				if (Rank < SortedRank[SearchIndex])
				{
					SortedPlayers.InsertItem(SearchIndex,LastMatchPlayers[PlayerIndex].NetId);
					SortedRank.InsertItem(SearchIndex,Rank);
					bWasInserted = true;
					break;
				}
			}
			if (!bWasInserted)
			{
				SortedPlayers.AddItem(LastMatchPlayers[PlayerIndex].NetId);
				SortedRank.AddItem(Rank);
			}
		}
	}
}


/** Erases all of the data that was set on the object */
function ClearResults()
{
	LastMatchPlayers.Length = 0;
	LastMatchBots.Length = 0;
	LastMatchResults = None;
	AllTimeMatchResults = None;
}

/**
 * Determines whether the player completed the match or not
 *
 * @param Player the player in question
 *
 * @return true if they finished the match, false otherwise
 */
function bool DidPlayerCompleteMatch(UniqueNetId Player)
{
	local int FoundIndex;

	FoundIndex = LastMatchPlayers.Find('NetId',Player);
	if (FoundIndex != INDEX_NONE)
	{
		return LastMatchPlayers[FoundIndex].bDidComplete;
	}
	return false;
}
