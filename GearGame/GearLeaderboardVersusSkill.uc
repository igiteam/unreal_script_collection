/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Reads the skill for a player
 */
class GearLeaderboardVersusSkill extends OnlineStatsRead
	native(Online);

`include(GearOnlineConstants.uci)

/**
 * Copies the results of the stats read to the search object
 *
 * @param Search the search object to populate with skill data
 */
native function CopySkillDataToSearch(OnlineGameSearch Search);

/**
 * Gets the skill value for the player specified
 *
 * @param PlayerId the unique id of the player to look up
 *
 * @return the skill value for that player
 */
native function int GetSkillForPlayer(UniqueNetId PlayerId);

/**
 * Populates the player reservation structure with the skill data contained herein
 *
 * @param PlayerId the player to read the skill data for
 * @param PlayerRes the reservation that is populated with the skill data
 */
native function FillPlayerResevation(UniqueNetId PlayerId,out PlayerReservation PlayerRes);

/**
 * Determine the leaderboard id for the load balanced versus game mode based on a playlist id
 *
 * @param PlaylistMan playlist manager that can map from playlist id to load balance id
 * @param PlaylistId playlist id to convert to game mode
 *
 * @return leaderboard id for load balanced versus game mode
 */
static function int GetLeaderboardIdFromPlaylistId(OnlinePlaylistManager PlaylistMan,int PlaylistId)
{
	local int LoadBalanceId;

	if (PlaylistMan != None)
	{
		PlaylistMan.GetLoadBalanceIdFromPlaylist(PlaylistId,LoadBalanceId);

		if (PlaylistMan.IsPlaylistArbitrated(PlaylistId))
		{
			switch (LoadBalanceId)
			{
			case 1:
				return STATS_VIEW_SKILL_RANKED_VERSUS_LOADBALANCE1;
			case 2:
				return STATS_VIEW_SKILL_RANKED_VERSUS_LOADBALANCE2;
			case 3:
				return STATS_VIEW_SKILL_RANKED_VERSUS_LOADBALANCE3;
			case 4:
				return STATS_VIEW_SKILL_RANKED_VERSUS_LOADBALANCE4;
			case 5:
				return STATS_VIEW_SKILL_RANKED_VERSUS_LOADBALANCE5;
			case 6:
				return STATS_VIEW_SKILL_RANKED_VERSUS_LOADBALANCE6;
			case 7:
				return STATS_VIEW_SKILL_RANKED_VERSUS_LOADBALANCE7;
			case 8:
				return STATS_VIEW_SKILL_RANKED_VERSUS_LOADBALANCE8;
			default:
				return STATS_VIEW_SKILL_RANKED_VERSUS;
			}
		}
		else
		{
			switch (LoadBalanceId)
			{
			case 1:
				return STATS_VIEW_SKILL_STANDARD_VERSUS_LOADBALANCE1;
			case 2:
				return STATS_VIEW_SKILL_STANDARD_VERSUS_LOADBALANCE2;
			case 3:
				return STATS_VIEW_SKILL_STANDARD_VERSUS_LOADBALANCE3;
			case 4:
				return STATS_VIEW_SKILL_STANDARD_VERSUS_LOADBALANCE4;
			case 5:
				return STATS_VIEW_SKILL_STANDARD_VERSUS_LOADBALANCE5;
			case 6:
				return STATS_VIEW_SKILL_STANDARD_VERSUS_LOADBALANCE6;
			case 7:
				return STATS_VIEW_SKILL_STANDARD_VERSUS_LOADBALANCE7;
			case 8:
				return STATS_VIEW_SKILL_STANDARD_VERSUS_LOADBALANCE8;
			default:
				return STATS_VIEW_SKILL_STANDARD_VERSUS;
			}
		}
	}
	return STATS_VIEW_SKILL_RANKED_VERSUS;
}

defaultproperties
{
	ViewId=STATS_VIEW_SKILL_RANKED_VERSUS

	ColumnIds=(STATS_COLUMN_SKILL,STATS_COLUMN_GAMESPLAYED,STATS_COLUMN_MU,STATS_COLUMN_SIGMA)

	// The metadata for the columns
	ColumnMappings(0)=(Id=STATS_COLUMN_SKILL,Name="Skill")
	ColumnMappings(1)=(Id=STATS_COLUMN_GAMESPLAYED,Name="GamesPlayed")
	ColumnMappings(2)=(Id=STATS_COLUMN_MU,Name="Mu")
	ColumnMappings(3)=(Id=STATS_COLUMN_SIGMA,Name="Sigma")
}
