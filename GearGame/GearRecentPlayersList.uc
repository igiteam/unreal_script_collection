/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/** Class that manages the recent players/match results */
class GearRecentPlayersList extends OnlineRecentPlayersList
	dependson(GearTypes);


/** Holds the gear specific information for a recent player */
struct GearRecentPlayer extends CurrentPlayerMet
{
	/** The player's level based on XP */
	var int Level;
};

/** Holds the additional information that the post game scoreboard needs. Filled in at the end of a match */
struct GearRecentPlayerEndMatch extends GearRecentPlayer
{
	/** The name of the player that was met */
	var string Name;
	/** The pawn class that they chose */
	var string PawnClassName;
	/** The team name that they had */
	var string TeamName;
	/** The score for the team the player was on */
	var int TeamScore;
	/** Whether the player completed the match or not (dropped) */
	var bool bDidComplete;	
};

/** Players that recently formed a party */
struct GearRecentParty
{
	/** The player that was the party leader */
	var UniqueNetid PartyLeader;
	/** The list of players that comprise the party (should include the leader) */
	var array<GearRecentPlayer> PartyMembers;
};
/** Currently active party that was last formed */
var array<GearRecentParty> LastGearParties;

/** Current working set of match data */
var GearMatchData CurrentMatchData;

/** Last match information (used during mapcycle only) */
var GearMatchData LastMatchData;

/**
 * Add an active party
 *
 * @param PartyLeader the player that owns the party
 * @param PartyMembers the members of the party
 */
function AddLastGearParty(UniqueNetId PartyLeader,const out array<GearRecentPlayer> PartyMembers)
{
	local int FoundIdx;
	local UniqueNetId ZeroId;

	if (PartyLeader != ZeroId)
	{
		// Look for an existing entry based on matching party leader
		FoundIdx = FindLastGearPartyIndex(PartyLeader);
		// If not found then add one
		if (FoundIdx == -1)
		{
			FoundIdx = LastGearParties.Length;
			LastGearParties.Length = FoundIdx+1;
		}
		// Update party leader
		LastGearParties[FoundIdx].PartyLeader = PartyLeader;
		// Update party members
		LastGearParties[FoundIdx].PartyMembers = PartyMembers;
	}
}

/**
 * Update a party member and add party entry if needed
 *
 * @param PartyLeader the player that owns the party
 * @param PartyMembers the member of the party
 */
function AddLastGearPartyPlayer(UniqueNetId PartyLeader,const out GearRecentPlayer PartyMember)
{
	local int Idx,FoundIdx,PlayerIdx;
	local UniqueNetId ZeroId;

	if (PartyLeader != ZeroId)
	{
		// Look for an existing entry based on matching party leader
		FoundIdx = FindLastGearPartyIndex(PartyLeader);
		// If not found then add one
		if (FoundIdx == -1)
		{
			FoundIdx = LastGearParties.Length;
			LastGearParties.Length = FoundIdx+1;
		}
		// Update party leader
		LastGearParties[FoundIdx].PartyLeader = PartyLeader;

		// Find existing party member
		PlayerIdx = -1;
		for (Idx=0; Idx < LastGearParties[FoundIdx].PartyMembers.Length; Idx++)
		{
			if (LastGearParties[FoundIdx].PartyMembers[Idx].NetId == PartyMember.NetId)
			{
				PlayerIdx = Idx;
				break;
			}
		}
		// If not found then add one
		if (PlayerIdx == -1)
		{
			PlayerIdx = LastGearParties[FoundIdx].PartyMembers.Length;
			LastGearParties[FoundIdx].PartyMembers.Length = PlayerIdx+1;
		}
		// Update party member
		LastGearParties[FoundIdx].PartyMembers[PlayerIdx] = PartyMember;
	}
}

/**
 * Get index into LastGearParties for the given party leader
 *
 * @param PartyLeader the player that owns the party
 */
function int FindLastGearPartyIndex(UniqueNetId PartyLeader)
{
	local int Idx,FoundIdx;

	// Look for an existing entry based on matching party leader
	FoundIdx = -1;
	for (Idx=0; Idx < LastGearParties.Length; Idx++)
	{
		if (LastGearParties[Idx].PartyLeader == PartyLeader)
		{
			FoundIdx = Idx;
			break;
		}
	}
	return FoundIdx;
}

/**
 * Clear the list of last gear parties
 */
function ClearAllGearParties()
{
	LastGearParties.Length = 0;
}

/**
 * Creates the last & all time leaderboard objects based off of the specified game type
 *
 * @param OnlineStatsWriteClass the game type to create the leaderboard objects for
 * @param MapName the name of the map that was just played
 * @param bUsesArbitration whether to use the public or private stats
 */
function InitRecentMatchResults(class<OnlineStatsWrite> OnlineStatsWriteClass, string MapName, bool bUsesArbitration)
{
	local class<GearLeaderboardBase> LeaderboardClass;

	// Create a new instance of the match data
	CurrentMatchData = new class'GearMatchData';
	CurrentMatchData.LastMpMapName = MapName;

	CurrentMatchData.LastStatsWriteClass = OnlineStatsWriteClass;
	switch (OnlineStatsWriteClass)
	{
		case class'GearLeaderboardWriteExecution':
			CurrentMatchData.LastMpGameType = eGEARMP_Execution;
			LeaderboardClass = bUsesArbitration ? class'GearLeaderboardExecutionAllTime' : class'GearLeaderboardExecutionAllTimePri';
			break;
		case class'GearLeaderboardWriteExecutionPlayer':
			CurrentMatchData.LastMpGameType = eGEARMP_Execution;
			LeaderboardClass = class'GearLeaderboardExecutionAllTimePlayer';
			break;
		case class'GearLeaderboardHordeWrite':
			CurrentMatchData.LastMpGameType = eGEARMP_Horde;
			LeaderboardClass = class'GearLeaderboardHorde';
			break;
		case class'GearLeaderboardWriteSiege':
			CurrentMatchData.LastMpGameType = eGEARMP_Siege;
			LeaderboardClass = class'GearLeaderboardSiege';
			break;
		case class'GearLeaderboardWriteWingman':
			CurrentMatchData.LastMpGameType = eGEARMP_Wingman;
			LeaderboardClass = bUsesArbitration ? class'GearLeaderboardWingmanAllTime' : class'GearLeaderboardWingmanAllTimePri';
			break;
		case class'GearLeaderboardWriteWingmanPlayer':
			CurrentMatchData.LastMpGameType = eGEARMP_Wingman;
			LeaderboardClass = class'GearLeaderboardWingmanAllTimePlayer';
			break;
		case class'GearLeaderboardWriteKoth':
			CurrentMatchData.LastMpGameType = eGEARMP_KOTH;
			LeaderboardClass = bUsesArbitration ? class'GearLeaderboardKothAllTime' : class'GearLeaderboardKothAllTimePri';
			break;
		case class'GearLeaderboardWriteKothPlayer':
			CurrentMatchData.LastMpGameType = eGEARMP_KOTH;
			LeaderboardClass = class'GearLeaderboardKothAllTimePlayer';
			break;
		case class'GearLeaderboardWriteGuardian':
			CurrentMatchData.LastMpGameType = eGEARMP_CTL;
			LeaderboardClass = bUsesArbitration ? class'GearLeaderboardGuardianAllTime' : class'GearLeaderboardGuardianAllTimePri';
			break;
		case class'GearLeaderboardWriteGuardianPlayer':
			CurrentMatchData.LastMpGameType = eGEARMP_CTL;
			LeaderboardClass = class'GearLeaderboardKothAllTimePlayer';
			break;
		case class'GearLeaderboardWriteTDM':
			CurrentMatchData.LastMpGameType = eGEARMP_Newbie;
			LeaderboardClass = bUsesArbitration ? class'GearLeaderboardTDMAllTime' : class'GearLeaderboardTDMAllTimePri';
			break;
		case class'GearLeaderboardWriteTDMPlayer':
			CurrentMatchData.LastMpGameType = eGEARMP_Newbie;
			LeaderboardClass = class'GearLeaderboardTDMAllTimePlayer';
			break;
		case class'GearLeaderboardWarzoneWritePlayer':
			CurrentMatchData.LastMpGameType = eGEARMP_Warzone;
			LeaderboardClass = class'GearLeaderboardWarzoneAllTimePlayer';
			break;
		case class'GearLeaderboardWarzoneWrite':
		default:
			CurrentMatchData.LastMpGameType = eGEARMP_Warzone;
			LeaderboardClass = bUsesArbitration ? class'GearLeaderboardWarzoneAllTime' : class'GearLeaderboardWarzoneAllTimePri';
			break;
	}

	CurrentMatchData.LastMatchResults = new LeaderboardClass;
	CurrentMatchData.AllTimeMatchResults = new LeaderboardClass;
}

/** Return the match data from the current session (valid from PreRound->MatchOver) */
function GearMatchData GetCurrentMatchResults()
{
	return CurrentMatchData;
}

/** Return the match data from the previous session (only non-None PreRound->N secs after MatchInProgress in custom/social) */
function GearMatchData GetLastMatchResults()
{
	if (LastMatchData != None)
	{
		return LastMatchData;
	}

	return CurrentMatchData;
}

/** Erases all of the data that was set on the object */
function ClearRecentMatchResults()
{
	if (CurrentMatchData != None)
	{
		CurrentMatchData.ClearResults();
	}
}

/** Remove the backup copy of last match results */
function ClearLastMatchResults()
{
	LastMatchData = None;
}

`if(`notdefined(FINAL_RELEASE))
/** Log list of players for debugging */
function DumpGearParties()
{
	local int PartyIdx,PlayerIdx;
	local UniqueNetId NetId;

	`LogOnline("DumpGearParties: ");
	for (PartyIdx=0; PartyIdx < LastGearParties.Length; PartyIdx++)
	{
		NetId = LastGearParties[PartyIdx].PartyLeader;
		`LogOnline(" PartyLeader="$class'OnlineSubsystem'.static.UniqueNetIdToString(NetId));
		`LogOnline(" party members: ");
		for (PlayerIdx=0; PlayerIdx < LastGearParties[PartyIdx].PartyMembers.Length; PlayerIdx++)
		{
			NetId = LastGearParties[PartyIdx].PartyMembers[PlayerIdx].NetId;
			`LogOnline("   NetId="$class'OnlineSubsystem'.static.UniqueNetIdToString(NetId)
				$"   Team="$LastGearParties[PartyIdx].PartyMembers[PlayerIdx].TeamNum
				$"   Skill="$LastGearParties[PartyIdx].PartyMembers[PlayerIdx].Skill
				$"   Level="$LastGearParties[PartyIdx].PartyMembers[PlayerIdx].Level);
		}
	}
}
`endif
