/**
 * UIScene_Scoreboard:
 * In-game scoreboard for all MP game types
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_Scoreboard extends GearGFxMoviePlayer
	dependson(UIWidget_TeamScoreboard);

/** --- Scene Widgets --------------------------------- */
/** Title and description of the current game */
var transient protected GFxObject   lbl_GameTitle;

/** Goal for this round */
var transient protected GFxObject   lbl_Trophy;

/** Time label for this round */
var transient protected GFxObject   lbl_RoundTime;

/** Labels for the stat column headers */
var transient protected GFxObject   lbl_ColumnHeader0;
var transient protected GFxObject   lbl_ColumnHeader1;
var transient protected GFxObject   lbl_ColumnHeader2;
var transient protected GFxObject   lbl_ColumnHeader3;

/** Label showing the "press B to view map" tip */
var transient protected GFxObject   lbl_OpenMap;

/** Reference to the button bar at the bottom of the menu */
var transient protected GFxObject   ButtonBar;

/** Reference to the MovieClip which contains the in/out animations for the Scoreboard. */
var transient protected GFxObject	ScoreboardControl;

/** Number of total team scoreboards present in the movie (not all need to be active in all configurations) */
const NUM_SCOREBOARDS = 5;

/** The containers for the team scoreboards, indexed by team */
var transient protected UIWidget_TeamScoreboard     TeamScoreboards[NUM_SCOREBOARDS];

/** The container for the spectator list for players waiting to join */
var transient protected UIWidget_ScoreboardSpectators   SpectatorList;

/** Cached references to the local PRIs, update every frame to detect coming and going */
var transient GearPRI   CachedLocalPRI1, CachedLocalPRI2;

/** --- Stats Management ------------------------------ */
/** Enum of stat types for the scoreboard */
enum GearScoreboardStatType
{
	eGSStat_Deaths,
	eGSStat_Downs,
	eGSStat_Kills,
	eGSStat_Revives,
	eGSStat_Assists,
	eGSStat_AnnexCap,
	eGSStat_AnnexBreak,
	eGSStat_LeaderCap,
	eGSStat_LeaderRelease,
};

/** Struct to store game-type specific variables, delegates, etc. */
struct GearScoreboardGameTypeSpecificData
{
	/** Variable name in the localization file for the name of this game-type */
	var transient const string GameNameVariableString;

	/** Stat order */
	var transient const array<GearScoreboardStatType> StatOrder;
};

/**
 * List of data that allows for game-specific customization of the scoreboard
 * This list must match the EGearMPTypes in GearTypes.uc
 */
var transient array<GearScoreboardGameTypeSpecificData> GameSpecificData;


/** --- Scene Variables ------------------------------- */
/** Whether the scoreboard has had its initial values set yet (happens after GRI becomes valid) */
var transient bool      bInitialized;

/** Whether or not this scene is currently being rendered */
var transient bool      bIsVisible;

/** Whether or not we enabled post process effects due to the match having not started */
var transient bool      bPregamePPEnabled;

/** Current GRI for the game being played */
var transient GearGRI       MyGRI;

/** Current game type being played */
var transient EGearMPTypes  CurrentGameType;

/** Last game time that we sent to the scoreboard for display */
var transient int           LastGameTimeUpdate;

/** --- Localized Strings ----------------------------- */
/** Localized string for telling the players how to open up the map */
var localized string        OpenMapViewString;

/** Localized stat name for the column headers in the scoreboard, indexed by GearScoreboardStatType */
var localized string        ColumnHeaderStrings[GearScoreboardStatType.EnumCount];


//==============================================================
// Widget Initialization / Handling
//==============================================================

/**
 * Called when the movie player is first initted.  Overloaded here to play the intro animation to the scoreboard
 * 
 * @param   Player  LocalPlayer that owns this instance of the movie
 */
function Init(optional LocalPlayer Player)
{
	Super.Init(Player);

	OpenScoreboard();
}

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
	case 'ScoreboardControl':
		ScoreboardControl = Widget;
		break;
	case 'lbl_GameTitle':
		lbl_GameTitle = Widget;
		break;
	case 'lbl_Trophy':
		lbl_Trophy = Widget;
		break;
	case 'lbl_RoundTime':
		lbl_RoundTime = Widget;
		break;
	case 'lblOpenMap':
		lbl_OpenMap = Widget;
		lbl_OpenMap.SetString("htmlText", OpenMapViewString);
		break;
	case 'Stat0':
		lbl_ColumnHeader0 = Widget;
		break;
	case 'Stat1':
		lbl_ColumnHeader1 = Widget;
		break;
	case 'Stat2':
		lbl_ColumnHeader2 = Widget;
		break;
	case 'Stat3':
		lbl_ColumnHeader3 = Widget;
		break;
	case 'ButtonBar':
		ButtonBar = Widget;
		break;
	case 'Team0_Scoreboard':
		TeamScoreboards[0] = UIWidget_TeamScoreboard(Widget);
		SetWidgetPathBinding(TeamScoreboards[0], WidgetPath);
		break;
	case 'Team1_Scoreboard':
		TeamScoreboards[1] = UIWidget_TeamScoreboard(Widget);
		SetWidgetPathBinding(TeamScoreboards[1], WidgetPath);
		break;
	case 'Team2_Scoreboard':
		TeamScoreboards[2] = UIWidget_TeamScoreboard(Widget);
		SetWidgetPathBinding(TeamScoreboards[2], WidgetPath);
		break;
	case 'Team3_Scoreboard':
		TeamScoreboards[3] = UIWidget_TeamScoreboard(Widget);
		SetWidgetPathBinding(TeamScoreboards[3], WidgetPath);
		break;
	case 'Team4_Scoreboard':
		TeamScoreboards[4] = UIWidget_TeamScoreboard(Widget);
		SetWidgetPathBinding(TeamScoreboards[4], WidgetPath);
		break;
	case 'JoinInProgress':
		SpectatorList = UIWidget_ScoreboardSpectators(Widget);
		SetWidgetPathBinding(SpectatorList, WidgetPath);
		break;
	default:
		`log("Unhandled widget in UIScene_Scoreboard: " @ WidgetPath,, 'GearsUI');
		return FALSE;
	}

	return TRUE;
}

/** Overloaded to turn off hook into chat tracking */
event OnClose()
{
	// Turn off chat tracking (talk bubbles)
	TrackChat(false);

	Super.OnClose();

	// Stop the post process when we close, if we overrode it based on gamestate
	if( GetGearPC().CurrentPPType == eGPP_Menu )
	{
		GetGearPC().StopPostProcessOverride(eGPP_Menu, 0.f);
	}
}

//==============================================================
// Opening and Closing functions / Callbacks
//==============================================================

/** Opens the scoreboard movie from the beginning fade in */
function OpenScoreboard()
{
	local GFxObject RootMovie;
	local ASDisplayInfo DI;
	local GearGRI GRI;

	if( !bIsVisible )
	{
		SetPause(FALSE);

		bIsVisible = TRUE;

		RootMovie = GetVariableObject("_root");
		DI = RootMovie.GetDisplayInfo();
		DI.Alpha = 100;
		RootMovie.SetDisplayInfo(DI);
		
		if (ScoreboardControl != NONE)
		{
			ScoreboardControl.GotoAndPlay("in");
		}		

		// Turn on post process if we want it, or if the round is not in progress
		GRI = GearGRI(GetPC().WorldInfo.GRI);
		if( bEnableMenuPostProcess || (GRI == None || GRI.GameStatus != GS_RoundInProgress) )
		{
			GetGearPC().SetMenuPostProcessSettings(MenuPostProcessSettings, bPostProcessForAllLocalPlayers);
			bPregamePPEnabled = TRUE;
		}

		// Turn chat tracking on (talk bubbles)
		TrackChat(true);
	}
}

/** Fades out the scoreboard, but does not close it */
function HideScoreboard()
{
	local int Idx;

	if( bIsVisible )
	{
		bIsVisible = FALSE;

		if (ScoreboardControl != NONE)
		{
			ScoreboardControl.GotoAndPlay("out");
		}

		// Turn off post process if we want it, or if the round is in progress
		if( bEnableMenuPostProcess || bPregamePPEnabled )
		{
			GetGearPC().StopPostProcessOverride(eGPP_Menu, 0.f);
			bPregamePPEnabled = FALSE;
		}

		// Turn chat tracking on (talk bubbles)
		TrackChat(false);
		// Turn off the chat bubbles for all players
		for (Idx = 0; Idx < NUM_SCOREBOARDS; Idx++)
		{
			if (TeamScoreboards[Idx] != None)
			{
				TeamScoreboards[Idx].ClearChatBubbles();
			}
		}
	}
}

/** Called from ActionScript after the scoreboard completes its fade out, handles pausing so the scoreboard isn't updated when not visible */
function Callback_FadeOutComplete()
{
	local GFxObject RootMovie;
	local ASDisplayInfo DI;

	RootMovie = GetVariableObject("_root");
	DI = RootMovie.GetDisplayInfo();
	DI.Alpha = 0;
	RootMovie.SetDisplayInfo(DI);

	SetPause(TRUE);
}

//==============================================================
// Updating loop
//==============================================================

/**
 * Main update function for the scoreboard
 * 
 * @param   DeltaTime   Time since the last update
 */
final function UpdateScoreboard(float DeltaTime)
{
	local bool bInvalidRoundTime;
	local UIWidget_TeamScoreboard CurrentScoreboard;
	local int i, CurrentTeamIndex;
	
	// See if the GRI has become valid
	if( MyGRI == None )
	{
		MyGRI = GetGRI();
		CurrentGameType = GetGearMPGameType(MyGRI);
	}

	if( MyGRI != None )
	{
		// If we haven't been initialized yet, set all the header and static widgets to their initial values
		if( !bInitialized )
		{
			// Set the header labels and titles
			lbl_GameTitle.SetBool("html", TRUE);
			lbl_GameTitle.SetString( "htmlText", GetGameTitleAndDescription() );
			lbl_Trophy.SetText( GetGameGoalString() );

			lbl_ColumnHeader0.SetString("htmlText", GetColumnHeaderForIndex(0));
			lbl_ColumnHeader1.SetString("htmlText", GetColumnHeaderForIndex(1));
			lbl_ColumnHeader2.SetString("htmlText", GetColumnHeaderForIndex(2));
			lbl_ColumnHeader3.SetString("htmlText", GetColumnHeaderForIndex(3));

			InitializeScoreboards();

			bInitialized = TRUE;
		}

		// Update the time label, if needed.  We only change it when the time has changed to save the update cost of sending strings over the border to GFx
		bInvalidRoundTime = (MyGRI.GameStatus == GS_WaitingForHost || MyGRI.GameStatus == GS_Loading);
		if( bInvalidRoundTime )
		{
			// Check to see if the invalid round time is new, and only update if it is
			if( LastGameTimeUpdate != -1 )
			{
				// Invalid time, set the label to blank, and the round time to -1 so we can track it
				lbl_RoundTime.SetText("");
				LastGameTimeUpdate = -1;
			}
		}
		else if( LastGameTimeUpdate != MyGRI.RoundTime )
		{
			// Time has been changed, update the label
			LastGameTimeUpdate = MyGRI.RoundTime;
			lbl_RoundTime.SetText( FormatTime(MyGRI.RoundTime) );
		}

		// Update the local PRIs
		GetLocalPRIs(CachedLocalPRI1, CachedLocalPRI2);

		// Update team scores
		for(i = 0; i < NUM_SCOREBOARDS; i++)
		{
			CurrentScoreboard = TeamScoreboards[i];

			if( CurrentScoreboard != None )
			{
				CurrentTeamIndex = CurrentScoreboard.GetTeamIndex();
				CurrentScoreboard.UpdateTeamScore( GetTeamScore(CurrentTeamIndex) );
				CurrentScoreboard.UpdatePlayerScores( MyGRI, GetPlayerStats_Normal );
			}
		}

		// Update the spectator spots
		SpectatorList.UpdateSpectatorList(MyGRI);
	}
}

/** Initialized the scoreboards with the proper team associations and stats headers for this game type */
function InitializeScoreboards()
{
	local int i, RequiredScoreboards, MaxPlayersOnTeam;

	// Figure out how many scoreboards we need for the current game mode
	if( (CurrentGameType == eGEARMP_Horde) || (CurrentGameType == eGEARMP_Siege) )
	{
		RequiredScoreboards = 1;
		MaxPlayersOnTeam = 5;
	}
	else if( CurrentGameType == eGEARMP_Wingman )
	{
		RequiredScoreboards = 5;
		MaxPlayersOnTeam = 2;
	}
	else
	{
		RequiredScoreboards = 2;
		MaxPlayersOnTeam = 5;
	}

	// Loop over the scoreboards, and activate as necessary
	for( i = 0; i < NUM_SCOREBOARDS; i++ )
	{
		// If there isn't a valid scoreboard in this slot, break out, as the content SWF loaded doesn't support any more
		if( TeamScoreboards[i] == None )
		{
			break;
		}

		if( i < RequiredScoreboards )
		{
			// This scoreboard is active, associate it with a team and set the headers
			TeamScoreboards[i].SetTeamIndex(i);
			TeamScoreboards[i].SetMaxPlayers(MaxPlayersOnTeam);
			TeamScoreboards[i].UpdateTeamScore(-1);
		}
		else
		{
			// Don't need this scoreboard for this mode, deactivate it so it won't be updated
			TeamScoreboards[i].DeactivateScoreboard();
		}
	}

	// Special Case:  Siege mode needs the primary scoreboard associated with team 1, not team 0
	if( CurrentGameType == eGEARMP_Siege )
	{
		TeamScoreboards[0].SetTeamIndex(1);
	}
}

//==============================================================
// Scoring Helper Functions
//==============================================================

/**
 * Returns the game name, difficulty descriptor, and map name for the current match
 * 
 * @return  String filled out with the game name, description, and map name
 */
function string GetGameTitleAndDescription()
{
	local string LabelString;

	// Update the gamemode/mapname label
	if ( MyGRI != None )
	{
		LabelString = GetGameModeString(CurrentGameType);
		// Begin alternate color
		LabelString $= "<font color='#999999'>";
		if( CurrentGameType == eGEARMP_Horde || CurrentGameType == eGEARMP_Siege )
		{
			LabelString = LabelString @ "(" $ GearGRI_Horde(MyGRI).EnemyDifficulty.default.DifficultyName $ ")";
		}
		LabelString = LabelString @ GameToMapConjunction @ GetMapNameString(MyGRI.GetURLMap()) $ "</font>";	
	}

	return Caps(LabelString);
}

/** 
 *  Returns the goal string (e.g. How many points the match is, etc)
 *  
 *  @return String containing the scoring goal for this round
 */
final function string GetGameGoalString()
{
	local int GoalScore;

	if ( CurrentGameType == eGEARMP_Horde )
	{
		// Horde goal is the max waves, times the number of extended waves
		GoalScore = class'GearGameHorde_Base'.default.MaxWaves * (class'GearGameHorde_Base'.default.ExtendedWaveList.Length + 1);
	}
	else if( CurrentGameType == eGEARMP_Siege )
	{
		// Beast goal is the length of the waves specified
		GoalScore = class'GearGameSiege_Base'.default.Waves.Length;
	}
	else if( CurrentGameType == eGEARMP_KOTH )
	{
		GoalScore = GearGRI_Annex(MyGRI).AnnexResourceGoal;
	}
	else
	{
		GoalScore = MyGRI.GoalScore;
	}

	return string(GoalScore);
}

/**
 * Returns the score for the specified team
 *
 * @param   TeamIdx     Index into the GRI's team's array to get the score for
 * 
 * @return  The score for the specified team
 */
final function int GetTeamScore(int TeamIdx)
{
	local GearGRI_Horde HordeGRI;

	// In horde and siege, the scoreboard should show the wave the player is on, not the score
	if ( CurrentGameType == eGEARMP_Horde || CurrentGameType == eGEARMP_Siege)
	{
		HordeGRI = GearGRI_Horde(MyGRI);
		if( CurrentGameType == eGEARMP_Horde )
		{
			return (class'GearGameHorde_Base'.default.MaxWaves * HordeGRI.ExtendedRestartCount) + HordeGRI.InvasionCurrentWaveIndex;
		}
		else
		{
			return HordeGRI.InvasionCurrentWaveIndex;
		}

	}
	else if( TeamIdx < MyGRI.Teams.Length )
	{
		// For all other game types, try to grab the team score out of the team's info
		return int(MyGRI.Teams[TeamIdx].Score);
	}
	else
	{
		// Team is invalid at the moment
		return -1;
	}
}

/**
 * Gets the text to put in the header for the column at the specified index
 * 
 * @param   Index   The index of the column to get the header for, 0-indexed
 */
function string GetColumnHeaderForIndex(int Index)
{
	return ColumnHeaderStrings[GameSpecificData[CurrentGameType].StatOrder[Index]];
}

/**
 * The default accessor for getting scoreboard data for the specified player.  For each of the four slots available in the scoreboard, it looks up
 * the game-specific stat (specified in the GameSpecificData array) for that position, and returns the data to the caller
 *
 * @param   PlayerPRI   PRI of the player that stats should be filled out for
 * @param   PlayerName  Formatted string for the player name
 * @param   Stat1       Stat for the first position in the scoreboard
 * @param   Stat2       Stat for the second position in the scoreboard
 * @param   Stat3       Stat for the third position in the scoreboard
 * @param   Stat4       Stat for the fourth position in the scoreboard
 * @param   Score       Total score for this player
 */
final function GetPlayerStats_Normal(GearPRI PlayerPRI, out string PlayerName, out float Stat1, out float Stat2, out float Stat3, out float Stat4, out float Score)
{
	if( PlayerPRI != None )
	{
		PlayerName = GetFormattedPlayerName(PlayerPRI, CachedLocalPRI1, CachedLocalPRI2);

		Stat1 = GetGameSpecificPlayerStat(PlayerPRI, 0);
		Stat2 = GetGameSpecificPlayerStat(PlayerPRI, 1);
		Stat3 = GetGameSpecificPlayerStat(PlayerPRI, 2);
		Stat4 = GetGameSpecificPlayerStat(PlayerPRI, 3);
		Score = PlayerPRI.GetScore();
	}
}

/** 
 * Returns the game specific stat at the specified index into the GameSpecificData's StatOrder array for a given PRI
 *
 * @param   PlayerPRI   PRI of the player that the stat should be collected for
 * @param   StatIdx     Index into the GameSpecificData's stat array to return the stat for
 * 
 * @return  The value of the game-specific stat at the specified index in the StatOrder array for the player
 */
final function float GetGameSpecificPlayerStat( GearPRI PlayerPRI, int StatIdx )
{
	if ( (PlayerPRI != None) && (StatIdx < GameSpecificData[CurrentGameType].StatOrder.length) )
	{
		switch ( GameSpecificData[CurrentGameType].StatOrder[StatIdx] )
		{
			case eGSStat_Deaths:			return PlayerPRI.GetDeaths();
			case eGSStat_Downs:				return PlayerPRI.GetTakeDowns();
			case eGSStat_Kills:				return PlayerPRI.GetKills();
			case eGSStat_Revives:			return PlayerPRI.GetRevives();
			case eGSStat_Assists:           return PlayerPRI.GetAssists();
			case eGSStat_AnnexCap:			return PlayerPRI.GetGameScore1();
			case eGSStat_AnnexBreak:		return PlayerPRI.GetGameScore2();
			case eGSStat_LeaderCap:         return PlayerPRI.GetGameScore3();
			case eGSStat_LeaderRelease:     return PlayerPRI.GetGameScore4();
		}
	}

	return -1.f;
}

defaultproperties
{
	bAutoPlay=TRUE
	bAllowInput=FALSE
	bAllowFocus=FALSE

	Priority=GEAR_SCENE_PRIORITY_MPSCENE

	OnPostAdvance=UpdateScoreboard

	WidgetBindings(0)=(WidgetName=Team0_Scoreboard,WidgetClass=class'GearGame.UIWidget_TeamScoreboard')
	WidgetBindings(1)=(WidgetName=Team1_Scoreboard,WidgetClass=class'GearGame.UIWidget_TeamScoreboard')
	WidgetBindings(2)=(WidgetName=Team2_Scoreboard,WidgetClass=class'GearGame.UIWidget_TeamScoreboard')
	WidgetBindings(3)=(WidgetName=Team3_Scoreboard,WidgetClass=class'GearGame.UIWidget_TeamScoreboard')
	WidgetBindings(4)=(WidgetName=Team4_Scoreboard,WidgetClass=class'GearGame.UIWidget_TeamScoreboard')
	WidgetBindings(5)=(WidgetName=JoinInProgress,WidgetClass=class'UIWidget_ScoreboardSpectators')

	GameSpecificData(eGEARMP_Warzone)=(GameNameVariableString="Warzone",StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
	GameSpecificData(eGEARMP_Execution)=(GameNameVariableString="Execution",StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
	GameSpecificData(eGEARMP_Horde)=(GameNameVariableString="CT",StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
	GameSpecificData(eGEARMP_Siege)=(GameNameVariableString="Siege",StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
	GameSpecificData(eGEARMP_Wingman)=(GameNameVariableString="Wingman",StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
	GameSpecificData(eGEARMP_KOTH)=(GameNameVariableString="KOTH",StatOrder=(eGSStat_AnnexCap,eGSStat_AnnexBreak,eGSStat_Kills,eGSStat_Downs))
	GameSpecificData(eGEARMP_CTL)=(GameNameVariableString="CTL",StatOrder=(eGSStat_LeaderCap,eGSStat_LeaderRelease,eGSStat_Kills,eGSStat_Downs))
	GameSpecificData(eGEARMP_Newbie)=(GameNameVariableString="Newbie",StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
}
