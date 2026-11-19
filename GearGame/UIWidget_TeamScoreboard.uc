/**
 * UIWidget_TeamScoreboard:
 * Widget class to handle interfacing with the scoreboard for a team in 
 * multiplayer.  Includes the player list, the team score, and the header
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIWidget_TeamScoreboard extends GFxObject;

/** Reference to the team info movie clip */
var transient GFxObject mc_TeamInfo;

/** Reference to the team's player name */
var transient GFxObject lbl_PlayerName;

/** Reference to the team score widget */
var transient GFxObject lbl_TeamScore;

/** Reference to the actual scoreboard list for this team */
var transient GFxObject ScoreboardList;

/** Stored reference to the array used as the dataprovider, so that we don't have to create it each time */
var transient GFxObject ListDataProvider;

/** Last team score that we sent to the UI */
var transient int LastTeamScore;

/** Index into the GRI's TeamInfo array for this scoreboard */
var private transient int TeamIndex;

/** The maximum number of players that this scoreboard can potentially have for this game mode */
var private transient int MaxPlayers;

/** If TRUE, this scoreboard is deactivated, and invisible */
var private transient bool bIsDeactivated;

/** If TRUE, the last time we checked this scoreboard had players in it */
var private transient bool bHadPlayers;

/** If TRUE, we've initialized the scoreboard's opacity and skinning */
var private transient bool bIsInitialized;

/** Cached bool that is TRUE if this is siege, FALSE otherwise so we can filter the PRIs */
var transient bool bIsSiegeGame;

struct PlayerInfoCache
{
	/** Name of the player */
	var string      PlayerName;
	/** Rank of the player */
	var int			PlayerRank;

	/** Game specific scores */
	var float       GameScore1;
	var float       GameScore2;
	var float       GameScore3;
	var float       GameScore4;
	var float       GameTotalScore;

	/** TRUE if the player is using VOIP, FALSE if not */
	var bool        bIsVOIPing;
	/** TRUE if the player is a DBNO, FALSE if not */
	var bool        bIsDBNO;
	/** TRUE if the player is dead, FALSE if not */
	var bool        bIsDead;
	/** TRUE if the player is the leader, FALSE if not */
	var bool        bIsLeader;
	/** TRUE if the player is a local player's nemesis, FALSE if not */
	var bool        bIsNemesis;

	/** TRUE if this element needs a refresh, FALSE if not */
	var bool        bNeedsRefresh;

	/** Reference to the ActionScript object corresponding to this player's entry in the scoreboard's dataprovider */
	var GFxObject   InfoObject;

	/** TRUE if there is a player associated with this entry, FALSE if not */
	var bool        bHasPlayer;
};
var transient array<PlayerInfoCache>    PlayerInfo;

/**
 * Called whenever a new widget is initialized in the movie
 * 
 * @param   WidgetName      Flash instance name of the widget being initialized
 * @param   WidgetPath      Full path of the widget in the movie
 * @param   Widget          Reference to the widget that was initialized.  If this widget is bound via WidgetBindings, it will be of the appropriate subclass
 * 
 * @return  Whether or not this widget was handled
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
	case 'lbl_TeamScore':
		lbl_TeamScore = Widget;
		// Blank out the team score until it gets set for real by game code
		lbl_TeamScore.SetText("");
		break;
	case 'lbl_PlayerName':
		lbl_PlayerName = Widget;
		lbl_PlayerName.SetText("");
		break;
	case 'mc_PlayerList':
		ScoreboardList = Widget;
		break;
	default:
		return FALSE;
	}

	return TRUE;
}

/** Hides this scoreboard, and sets the bIsDeactivated flag to prevent updates */
function DeactivateScoreboard()
{
	local ASDisplayInfo DI;

	DI = GetDisplayInfo();
	DI.Alpha = 0;
	SetDisplayInfo(DI);

	bIsDeactivated = TRUE;
}

/**
 * Sets the new maximum number of players this scoreboard can potentially have.  Updated based on gametype
 * 
 * @param   NewMaxPlayers   Number of players that can potentially join this team
 */

function SetMaxPlayers(int NewMaxPlayers)
{
	if( NewMaxPlayers != MaxPlayers )
	{
		// Update the player count
		MaxPlayers = NewMaxPlayers;

		// Reallocate enough room in the data provider to set the number of players
		if( ListDataProvider != None )
		{
			ListDataProvider.SetFloat("length", MaxPlayers);
		}
	}
}

/**
 * Sets the team index for this team, which corresponds to the index into the Teams array in GearGRI.  Handles updating the background and style appropriately
 * 
 * @param   NewTeamIndex    The team index that this TeamScoreboard corresponds to, as an index into the Teams array in GearGRI
 */
function SetTeamIndex(int NewTeamIndex)
{
	TeamIndex = NewTeamIndex;

	SetScoreboardTeamTheme( (TeamIndex%2) == 0, "" );

	// Cache whether or not this is a siege game
	bIsSiegeGame = class'GearGFxMoviePlayer'.static.IsSiegeGametype( GearGFxMoviePlayer(Outer).GetGRI() );

}

/**
 * Returns the team index that this scoreboard is associated with
 * 
 * @return The associated team index for this scoreboard
 */
function int GetTeamIndex()
{
	return TeamIndex;
}

/**
 * Sets the visual theme of this scoreboard to be either the Cog or Locust theme
 * 
 * @param   bIsCOG      TRUE if this should have the blue COG theme, FALSE if it should have the red Locust theme
 * @param   TeamName    If non-empty, this string will replace the "Player:" header on the scoreboard
 */
function SetScoreboardTeamTheme(bool bIsCOG, string TeamName)
{
	ActionScriptVoid("SetTeam");
}

/**
 * Updates the team score label for this scoreboard ONLY if the score is different than the one currently being displayed
 * 
 * @param   NewTeamScore    The new score for this team
 */
function UpdateTeamScore(int NewTeamScore)
{
	// Only update the team score if the score has changed
	if( NewTeamScore != LastTeamScore )
	{
		LastTeamScore = NewTeamScore;

		lbl_TeamScore.SetText(NewTeamScore);
	}
}

/** 
 * Delegate used to grab stats for the players on this team
 * 
 * @param   PlayerPRI   PRI of the player to gather the stats for
 * @param   PlayerName  String containing the formatted (local, non-local) player name
 * @param   Stat1       First game-specific stat for this player
 * @param   Stat2       Second game-specific stat for this player
 * @param   Stat3       Third game-specific stat for this player
 * @param   Stat4       Fourth game-specific stat for this player
 * @param   Score       Total score for this player
 */
delegate GetPlayerStats(GearPRI PlayerPRI, out string PlayerName, out float Stat1, out float Stat2, out float Stat3, out float Stat4, out float Score );

/**
 * Handles the creation of the list provider, and initializes the PlayerInfo cache
 */
function InitializePlayerInfoCache()
{
	local GFxObject Element;
	local int i;

	// Create the dataProvider array, and set the length to avoid allocation pains
	ListDataProvider = CreateArray();
	ListDataProvider.SetFloat("length", MaxPlayers);

	// Initialize the PlayerInfo cache with enough elements
	PlayerInfo.Length = MaxPlayers;

	// Create an object for each player, set it to the dataStore entry, and store it in the PlayerInfo array
	for( i = 0; i < MaxPlayers; ++i )
	{
		Element = CreateObject("Object");
		ListDataProvider.SetElementObject(i, Element);

		// Initialize the object to the PlayerInfo, which will define all the variables in ActionScript which we later use
		PlayerInfo[i].InfoObject = Element;

		Element.SetString("PlayerName", PlayerInfo[i].PlayerName);
		Element.SetString("PlayerLevel", (PlayerInfo[i].PlayerRank > 0) ? String(PlayerInfo[i].PlayerRank) : "");
		Element.SetBool("bHasPlayer", PlayerInfo[i].bHasPlayer);
		Element.SetBool("bIsTalking", PlayerInfo[i].bIsVOIPing);
		Element.SetBool("bIsDBNO", PlayerInfo[i].bIsDBNO);
		Element.SetBool("bIsDead", PlayerInfo[i].bIsDead);
		Element.SetBool("bIsLeader", PlayerInfo[i].bIsLeader);
		Element.SetBool("bIsNemesis", PlayerInfo[i].bIsNemesis);
		Element.SetString("Stat0", GetFormattedStatString(PlayerInfo[i].GameScore1));
		Element.SetString("Stat1", GetFormattedStatString(PlayerInfo[i].GameScore2));
		Element.SetString("Stat2", GetFormattedStatString(PlayerInfo[i].GameScore3));
		Element.SetString("Stat3", GetFormattedStatString(PlayerInfo[i].GameScore4));
		Element.SetString("ScoreTotal", GetFormattedStatString(PlayerInfo[i].GameTotalScore));
	}

	ScoreboardList.SetObject("dataProvider", ListDataProvider);
}

/**
 * Checks whether or not the information for the index in the scoreboard has changed, and if so, updates the UI and the cached PlayerInfo 
 * 
 * @param   Index           Index into the scoreboard to update
 * @param   PlayerPRI       PRI of the player that is associated with this slot
 * @param   PlayerStatGetter    Delegate that will be used to grab the game-specific stats for the players associated with this scoreboard
 */
function UpdateCacheForElement(int Index, GearPRI PlayerPRI, delegate<GetPlayerStats> PlayerStatGetter)
{
	local GFxObject DataObject;
	local bool bNeedsRefresh, TmpBool;
	local PlayerInfoCache CurrentCache;
	local string FormattedPlayerName;
	local float GameScore1, GameScore2, GameScore3, GameScore4, GameTotalScore;
	local WorldInfo WI;

	// Grab a reference to the worldinfo
	WI = class'WorldInfo'.static.GetWorldInfo();

	// Store off the current cache to avoid dynamic array load hits
	CurrentCache = PlayerInfo[Index];
	DataObject = CurrentCache.InfoObject;

	// Update whether or not we have a player
	if( CurrentCache.bHasPlayer != (PlayerPRI != None) )
	{
		CurrentCache.bHasPlayer = !CurrentCache.bHasPlayer;
		DataObject.SetBool("bHasPlayer", CurrentCache.bHasPlayer);

		bNeedsRefresh = TRUE;
	}

	// The following fields are only valid if we have a PRI, so update them ONLY if we have one
	if( PlayerPRI != None )
	{
		// Gather the stats for this player
		PlayerStatGetter(PlayerPRI, FormattedPlayerName, GameScore1, GameScore2, GameScore3, GameScore4, GameTotalScore);

		// --- Player Name ---------------------------------------
		if( FormattedPlayerName != CurrentCache.PlayerName )
		{
			CurrentCache.PlayerName = FormattedPlayerName;
			DataObject.SetString("PlayerName", FormattedPlayerName);

			bNeedsRefresh = TRUE;
		}

		// --- Player Rank ---------------------------------------
		if( PlayerPRI.PlayerLevel != CurrentCache.PlayerRank )
		{
			CurrentCache.PlayerRank = PlayerPRI.PlayerLevel;
			// Don't set 0 as a level
			DataObject.SetString("PlayerLevel", (CurrentCache.PlayerRank > 0) ? String(CurrentCache.PlayerRank) : "");

			bNeedsRefresh = TRUE;
		}

		// --- Player State --------------------------------------
		if( (PlayerPRI.PlayerStatus == WPS_Down) != CurrentCache.bIsDBNO )
		{
			CurrentCache.bIsDBNO = (PlayerPRI.PlayerStatus == WPS_Down);
			DataObject.SetBool("bIsDBNO", CurrentCache.bIsDBNO);
			
			bNeedsRefresh = TRUE;
		}

		if( PlayerPRI.bIsDead != CurrentCache.bIsDead )
		{
			CurrentCache.bIsDead = PlayerPRI.bIsDead;
			DataObject.SetBool("bIsDead", PlayerPRI.bIsDead);

			bNeedsRefresh = TRUE;
		}

		if( PlayerPRI.bIsTalking != CurrentCache.bIsVOIPing &&
			(PlayerPRI.bIsTalking || (WI.RealTimeSeconds - PlayerPRI.LastTalkTime > 0.25f)) )
		{
			CurrentCache.bIsVOIPing = PlayerPRI.bIsTalking;
			SetSpeakerIcon(Index, CurrentCache.bIsVOIPing ? "on" : "off");
		}

		if( PlayerPRI.bIsLeader != CurrentCache.bIsLeader )
		{
			CurrentCache.bIsLeader = PlayerPRI.bIsLeader;
			DataObject.SetBool("bIsLeader", PlayerPRI.bIsLeader);

			bNeedsRefresh = TRUE;
		}

		TmpBool = GearPRI(GetPC().PlayerReplicationInfo).IsNemesis(PlayerPRI);
		if( TmpBool != CurrentCache.bIsNemesis )
		{
			CurrentCache.bIsNemesis = TmpBool;
			DataObject.SetBool("bIsNemesis", TmpBool);

			bNeedsRefresh = TRUE;
		}

		// --- Player Score --------------------------------------
		if( GameScore1 != CurrentCache.GameScore1 )
		{
			CurrentCache.GameScore1 = GameScore1;
			DataObject.SetString("Stat0", GetFormattedStatString(GameScore1));
			
			bNeedsRefresh = TRUE;
		}

		if( GameScore2 != CurrentCache.GameScore2 )
		{
			CurrentCache.GameScore2 = GameScore2;
			DataObject.SetString("Stat1", GetFormattedStatString(GameScore2));

			bNeedsRefresh = TRUE;
		}

		if( GameScore3 != CurrentCache.GameScore3 )
		{
			CurrentCache.GameScore3 = GameScore3;
			DataObject.SetString("Stat2", GetFormattedStatString(GameScore3));
			
			bNeedsRefresh = TRUE;
		}

		if( GameScore4 != CurrentCache.GameScore4 )
		{
			CurrentCache.GameScore4 = GameScore4;
			DataObject.SetString("Stat3", GetFormattedStatString(GameScore4));
			
			bNeedsRefresh = TRUE;
		}

		if( GameTotalScore != CurrentCache.GameTotalScore )
		{
			CurrentCache.GameTotalScore = GameTotalScore;
			DataObject.SetString("ScoreTotal", GetFormattedStatString(GameTotalScore));
			
			bNeedsRefresh = TRUE;
		}
	}

	// Cache the data
	PlayerInfo[Index] = CurrentCache;

	// If the board needs to be refreshed, invalidate the LIR now for this element
	if( bNeedsRefresh )
	{
		RefreshScoreboardIndex(Index);
	}
}

/**
 * Handles grabbing a list of players associated with this scoreboard, sorts them, and then calls the specified delegate to get scoring information for each player
 * 
 * @param   MyGRI               Game replication info to use to gather players from
 * @param   PlayerStatGetter    Delegate that will be used to grab the game-specific stats for the players associated with this scoreboard
 */
function UpdatePlayerScores(GearGRI MyGRI, delegate<GetPlayerStats> PlayerStatGetter )
{
	local bool bShouldShowScoreboard;

	// Sorting variables
 	local GearPRI CurrGearPRI;
	local int PRIArrayIdx, PRIListIdx, i;
	local array<GearPRI> PRIList;

	if( !bIsDeactivated )
	{
		// Find valid PRI's for our team, sort them, and 
		for ( PRIArrayIdx = 0; PRIArrayIdx < MyGRI.PRIArray.length; PRIArrayIdx++ )
		{
			// Get the PRI
			if ( MyGRI.PRIArray[PRIArrayIdx] != None )
			{
				CurrGearPRI = GearPRI(MyGRI.PRIArray[PRIArrayIdx]);
			}

			// Make sure it's valid and on a team
			if ( IsValidPRI(CurrGearPRI) && IsPRIOnMyTeam(CurrGearPRI) && (CurrGearPRI.SquadName != 'Fortification') && (!bIsSiegeGame || !CurrGearPRI.bBot) )
			{
				// Insert the PRI in the proper place in the list - lower index is higher PRI value
				for ( PRIListIdx = 0; PRIListIdx < PRIList.length; PRIListIdx++ )
				{
					if ( IsGreaterThanPRI(CurrGearPRI, PRIList[PRIListIdx]) )
					{
						break;
					}
				}
				PRIList.InsertItem(PRIListIdx, CurrGearPRI);
			}
		}

		if( PRIList.Length > 0 )
		{
			bShouldShowScoreboard = TRUE;

			// If the ListDataProvider is None, then create it, and populate it with the data
			if( ListDataProvider == None )
			{
				InitializePlayerInfoCache();
			}

			for( i = 0; i < MaxPlayers; ++i )
			{
				CurrGearPRI = (i < PRIList.Length) ? PRIList[i] : None;

				// Update the cache for this element, which will refresh it if anything has changed
				UpdateCacheForElement(i, CurrGearPRI, PlayerStatGetter);
			}
		}
		else
		{
			// No players to display, don't show the scoreboard
			bShouldShowScoreboard = FALSE;
		}

		// If there's been a change in whether this scoreboard should be displayed...
		if( (bHadPlayers != bShouldShowScoreboard) || !bIsInitialized )
		{
			bHadPlayers = bShouldShowScoreboard;

			// Update the name and style of this scoreboard if we're newly showing it
			if( bShouldShowScoreboard )
			{
				// If this is wingman, also set the team scoreboard and theme header appropriately
				if( class'GearGFxMoviePlayer'.static.GetGearMPGameType(MyGRI) == eGEARMP_Wingman )
				{
					// Set the team name and theme according to the first player in it
					SetScoreboardTeamTheme(class'GearGFxMoviePlayer'.static.GetRaceUsingPRIOnly(PRIList[0]) == eGEARRACE_COG, Caps(PRIList[0].PawnClass.default.CharacterName));
				}
			}

			if( !bIsInitialized )
			{
				bIsInitialized = TRUE;
			}
		}
	}
}

/** 
 * Checks to see if this is a valid (active, non-spectator) player 
 *
 * @param   PlayerPRI   The PRI to check validity on
 * 
 * @return  TRUE if this is a valid, active PRI, FALSE if not
 */
final function bool IsValidPRI( GearPRI PlayerPRI )
{
    // Spectators don't count on scoreboards, etc.
	if ( PlayerPRI != None && !PlayerPRI.bIsInactive && !PlayerPRI.bOnlySpectator )
	{
		return TRUE;
	}

	return FALSE;
}

/** 
 * Checks to see whether the PRI specified is on the team associated with this scoreboard
 * 
 * @param   PlayerPRI   PRI to check
 * 
 * @return  TRUE if the player is on this team's scoreboard, FALSE if not
 */
final function bool IsPRIOnMyTeam( GearPRI PlayerPRI )
{
	if ( (PlayerPRI.Team != None) && (PlayerPRI.Team.TeamIndex == TeamIndex) )
	{
		return TRUE;
	}

	return FALSE;
}

/** 
 * Sorting helper function for the PRI's in the scoreboard
 * 
 * @param   FirstPRI    The first PRI to test
 * @param   SecondPRI   The second PRI to test
 * 
 * @return  TRUE if the first PRI should be higher on the list, FALSE if it should be lower
 */
final function bool IsGreaterThanPRI( GearPRI FirstPRI, GearPRI SecondPRI )
{
	if ( FirstPRI.GetScore() > SecondPRI.GetScore() )
	{
		return true;
	}

	return false;
}

/** 
 * Forces a refresh of the specified scoreboard element after data has been updated
 *
 * @param Index Index of the data provider to refresh
 */
function RefreshScoreboardIndex(int Index)
{
	ScoreboardList.ActionScriptVoid("RefreshIndex");
}

/** Function that updates the data provider in action script of the speaker icon */
function SetSpeakerIcon(int Idx, String StateString)
{
	ScoreboardList.ActionScriptVoid("SetSpeakerIcon");
}

/** Iterates across all players and turns their chat bubbles off */
function ClearChatBubbles()
{
	local int Idx;
	local int PRIIdx;
	local GearGRI MyGRI;
	local GearPRI CurrPRI;

	// First force all PRIs from this team to shut up
	MyGRI = GearGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	if (MyGRI != None)
	{
		for (PRIIdx = 0; PRIIdx < MyGRI.PRIArray.Length; PRIIdx++)
		{
			CurrPRI = GearPRI(MyGRI.PRIArray[PRIIdx]);
			if (CurrPRI != None && CurrPRI.GetTeamNum() == TeamIndex)
			{
				CurrPRI.bIsTalking = false;
			}
		}
	}

	// Iterate across all player slots to clear the talking cache and update the UI
	for(Idx = 0; Idx < MaxPlayers; Idx++)
	{
		// If the player is still talking
		if (PlayerInfo[Idx].bIsVOIPing)
		{
			PlayerInfo[Idx].bIsVOIPing = false;
			SetSpeakerIcon(Idx, "alreadyOff");
		}
	}
}

/**
 * Returns a formatted stat string.  If the stat is 0, it will return "--".  Otherwise, it will return the stat as a string
 * 
 * @param   Stat    The value of the stat
 * @return  If the stat is 0, it will return "--".  Otherwise, it will return the stat as a string
 */
function string GetFormattedStatString(int Stat)
{
	return (Stat != 0.f) ? string(Stat) : "--";
}

defaultproperties
{
}
