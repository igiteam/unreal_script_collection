/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/** Class that manages the storing and retrieving the last match data for host migration */
class GearGameHostMigrationManager extends Object;

/** Used to hold a player's stats */
struct PlayerPRIData
{
	/** Player's name's */
	var string PlayerName;
	/** The player's net id for matching up on rejoin */
	var UniqueNetId UniqueId;
	/** Skill of the player. From replication */
	var int PlayerSkill;
	/** Xp based level of the player. From replication */
	var int PlayerLevel;
	/** The player's score */
	var float Score;
	/** Number of player's deaths. */
	var int Deaths;
	/** Kills by this player.Not replicated. */
	var int Kills;
	/** Number of players I have killed. */
	var int Score_Kills;
	/** Number of players I have knocked DBNO. */
	var int Score_Takedowns;
	/** Number of times I have revived teammates. */
	var int Score_Revives;
	/** Number of times I have assisted teammates. */
	var int Score_Assists;
	/** Game specific scoring properties. */
	var int Score_GameSpecific1;
	var int Score_GameSpecific2;
	var int Score_GameSpecific3;
	/** Net id of the owner for this player's party. If no party then ZeroId. */
	var UniqueNetId PartyOwnerUniqueId;
	/** The team this player was on */
	var int TeamId;
	/** The number of tokens you had earned in Beast */
	var int NumTokens;
};

/** Holds the list of players and their last known data */
var transient array<PlayerPRIData> Players;

/** The information for a team */
struct TeamData
{
	/** The id of the team this is data for */
	var int TeamId;
	/** The score for this team */
	var int TeamScore;
	/** The pawn class for this team (Wingman only) */
	var string PawnClassName;
};

/** The list of teams in the match */
var transient array<TeamData> Teams;

/** The data that needs to be kept for the game */
struct GRIData
{
	/** The score that a team needs to win */
	var int GoalScore;
	/** The number of rounds played including draws */
	var int RoundCount;
	/** The wave the match was on for Horde/Beast */
	var int WaveNum;
	/** The playlist id for public matches. This will get set on game settings as well */
	var int PlaylistId;
	/** The playlist manager version for public matches. This will get set on game settings as well */
	var int PlaylistManagerVer;
};

/** The game data we need for migration */
var GRIData GameData;

/**
 * Adds a PRI to the stored list and adds any team information if missing
 *
 * @param PRI the PRI being added
 */
function AddPlayerData(GearPRI PRI)
{
	local int Index;
	local GearPRI_Siege SiegePRI;

	// Match the entry by their unique id
	Index = Players.Find('UniqueId',PRI.UniqueId);

	// Add if they aren't in there
	if (Index == INDEX_NONE)
	{
		Index = Players.Length;
		Players.Length = Players.Length + 1;
		Players[Index].PlayerName = PRI.PlayerName;
		Players[Index].UniqueId = PRI.UniqueId;
		Players[Index].PlayerSkill = PRI.PlayerSkill;
		Players[Index].PlayerLevel = PRI.PlayerLevel;
		Players[Index].Score = PRI.Score;
		Players[Index].Deaths = PRI.Deaths;
		Players[Index].Kills = PRI.Kills;
		Players[Index].Score_Kills = PRI.Score_Kills;
		Players[Index].Score_Takedowns = PRI.Score_Takedowns;
		Players[Index].Score_Revives = PRI.Score_Revives;
		Players[Index].Score_Assists = PRI.Score_Assists;
		Players[Index].Score_GameSpecific1 = PRI.Score_GameSpecific1;
		Players[Index].Score_GameSpecific2 = PRI.Score_GameSpecific2;
		Players[Index].Score_GameSpecific3 = PRI.Score_GameSpecific3;
		Players[Index].PartyOwnerUniqueId = PRI.PartyOwnerUniqueId;
		// Add the team information if available
		if (PRI.Team != None)
		{
			Players[Index].TeamId = PRI.Team.TeamIndex;
			AddTeamData(PRI.Team);
		}
		else
		{
			Players[Index].TeamId = 255;
		}
		// Migrate Beast data if present
		SiegePRI = GearPRI_Siege(PRI);
		if (SiegePRI != None)
		{
			Players[Index].NumTokens = SiegePRI.WavePointsRemaining;
		}
	}
}

/**
 * Adds a team to the stored list
 *
 * @param Team the TeamInfo being added
 */
function AddTeamData(TeamInfo Team)
{
	local int Index;

	// Match the entry by their id
	Index = Teams.Find('TeamId',Team.TeamIndex);
	// Add the team if missing
	if (Index == INDEX_NONE)
	{
		Index = Teams.Length;
		Teams.Length = Teams.Length + 1;
		Teams[Index].TeamId = Team.TeamIndex;
		Teams[Index].TeamScore = Team.Score;
		// @todo joeg -- figure out how to get this data
		Teams[Index].PawnClassName = "";
	}
}

/**
 * Update the game state that is needed to continue the game
 *
 * @param GRI the GRI to copy data from
 */
function AddGameData(GearGRI GRI)
{
	local GearGRI_Horde HordeGRI;

	GameData.GoalScore = GRI.GoalScore;
	// Add in one extra round, because the current one is a draw
	GameData.RoundCount = GRI.RoundCount + 1;
	GameData.PlaylistId = GRI.PlaylistId;
	GameData.PlaylistManagerVer = GRI.PlaylistManagerVer;

	HordeGRI = GearGRI_Horde(GRI);
	if (HordeGRI != None)
	{
		GameData.WaveNum = HordeGRI.InvasionCurrentWaveIndex;
	}
}

/**
 * Updates a PRI from the stored list data
 *
 * @param PRI the PRI being added
 */
function bool UpdatePRI(GearPRI PRI)
{
	local int Index;
	local GearPRI_Siege SiegePRI;

	// Match the entry by their unique id
	Index = Players.Find('UniqueId',PRI.UniqueId);

	// Only update if the player is found
	if (Index != INDEX_NONE)
	{
		PRI.PlayerName = Players[Index].PlayerName;
		PRI.PlayerSkill = Players[Index].PlayerSkill;
		PRI.PlayerLevel = Players[Index].PlayerLevel;
		PRI.Score = Players[Index].Score;
		PRI.Deaths = Players[Index].Deaths;
		PRI.Kills = Players[Index].Kills;
		PRI.Score_Kills = Players[Index].Score_Kills;
		PRI.Score_Takedowns = Players[Index].Score_Takedowns;
		PRI.Score_Revives = Players[Index].Score_Revives;
		PRI.Score_Assists = Players[Index].Score_Assists;
		PRI.Score_GameSpecific1 = Players[Index].Score_GameSpecific1;
		PRI.Score_GameSpecific2 = Players[Index].Score_GameSpecific2;
		PRI.Score_GameSpecific3 = Players[Index].Score_GameSpecific3;
		PRI.PartyOwnerUniqueId = Players[Index].PartyOwnerUniqueId;
		// Migrate Beast data if present
		SiegePRI = GearPRI_Siege(PRI);
		if (SiegePRI != None)
		{
			SiegePRI.WavePointsRemaining = Players[Index].NumTokens;
		}
		return true;
	}
	return false;
}

/**
 * Determines the team for this player
 *
 * @param PRI the PRI we are searching for
 */
function int GetTeamId(GearPRI PRI)
{
	local int Index;

	// Match the entry by their unique id
	Index = Players.Find('UniqueId',PRI.UniqueId);
	// Only update if the player is found
	if (Index != INDEX_NONE)
	{
		return Players[Index].TeamId;
	}
	return 255;
}

/**
 * Returns the last known score for the team
 *
 * @param TeamId the id of the team to find
 *
 * @return the score of the team
 */
function int GetTeamScore(int TeamId)
{
	local int Index;

	// Match the entry by their id
	Index = Teams.Find('TeamId',TeamId);
	// Only update if the team is found
	if (Index != INDEX_NONE)
	{
		return Teams[Index].TeamScore;
	}
	return 0;
}

/**
 * Returns the last known score for the team
 *
 * @param TeamId the id of the team to find
 *
 * @return the pawn class name they used
 */
function string GetTeamPawnClassName(int TeamId)
{
	local int Index;

	// Match the entry by their id
	Index = Teams.Find('TeamId',TeamId);
	// Only update if the team is found
	if (Index != INDEX_NONE)
	{
		return Teams[Index].PawnClassName;
	}
	return "";
}

/**
 * Update the game state that is needed to continue the game
 *
 * @param GRI the GRI to copy data from
 */
function UpdateGRI(GearGRI GRI)
{
	local GearGRI_Horde HordeGRI;

	GRI.GoalScore = GameData.GoalScore;
	GRI.RoundCount = GameData.RoundCount;
	GRI.SetPlaylist(GameData.PlaylistId);
	GRI.PlaylistManagerVer = GameData.PlaylistManagerVer;

	// Read the horde/beast data from the game data if applicable
	HordeGRI = GearGRI_Horde(GRI);
	if (HordeGRI != None)
	{
		HordeGRI.InvasionCurrentWaveIndex = GameData.WaveNum;
	}
}

/**
 * Update the game settings state that is needed to continue the game
 *
 * @param GameSettings the game session settings to update
 */
function UpdateGameSettings(OnlineGameSettings GameSettings)
{
	if (GameSettings != None)
	{
		// Copy playlist id to game settings if available
		GameSettings.SetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTID,GameData.PlaylistId);
		GameSettings.SetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTMANAGERVERSION,GameData.PlaylistManagerVer);
	}
}

/**
 * Update the game state that is needed to continue the game
 *
 * @param GRI the GRI to copy data from
 */
function UpdateTeamData(GearGRI GRI)
{
	local int TeamIndex;

	// Update all of the team scores
	for (TeamIndex = 0; TeamIndex < GRI.Teams.Length; TeamIndex++)
	{
		GRI.Teams[TeamIndex].Score = GetTeamScore(TeamIndex);
	}
}
