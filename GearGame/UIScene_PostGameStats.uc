/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_PostGameStats extends GearGFxMoviePlayer
	dependson(UIScene_Scoreboard);

`include(GearLeaderboardConstants.uci)

/** Widget that serves as our interface to the screen */
var private transient GFxObject PostGameView;

/** Reference to the controller button legend at the bottom */
var private transient GFxObject ControllerBar;

/** Reference to the online subsystem that we're grabbing stats from */
var private transient OnlineSubsystem OnlineSub;

/** The list of players from the last game that we played, valid after InitializePostGameStats() */
var private transient GearRecentPlayersList PlayersList;

/** Whether or not we've already sent a mass invite to our former teammates */
var private transient bool bAlreadyInvitedTeam;

// --- Game state mappings -------------------------------------

/** Enum for setting the state of the post game stats layout, mirrored in Flash/ActionScript/gears/views/PostGameStatsView.as */
enum EPostGameStatLayout
{
	PGSS_VSMP,
	PGSS_Wingman,
	PGSS_Horde,
	PGSS_Beast,
	PGSS_Arcade
};

// --- Game Mode Stats Info ------------------------------------
/** Struct to store game-type specific variables, delegates, etc. */
struct GearGameTypeSpecificStatData
{
	/** Stat order */
	var transient const array<GearScoreboardStatType> StatOrder;
};

/**
 * List of data that allows for game-specific customization of the scoreboard
 * This list must match the EGearMPTypes in GearTypes.uc
 */
var transient array<GearGameTypeSpecificStatData> GameSpecificData;

/** Constants that map a stat to the data in the leaderboard/recentplayerlist */
var const array<int> StatConstants;

// --- Localized Strings ---------------------------------------
var localized string    PageTitle;
var localized string    MatchTimeLabel;
var localized string    GametypeMapConnector;
var localized string    WonMatchLabel;
var localized string    LostMatchLabel;
var localized string	IncompleteMatchLabel;
var localized string    PreviousBestLabel;
var localized string    WavesCompletedLabel;
var localized string    WaveTotalScoreLabel;
var localized string    NewRecordLabel;
var localized string    MVPLabel;
var localized string    LeaderboardViewTitle;
var localized string    ControllerString;
var localized string    ViewAsLeaderboardString;
var localized string    ViewPostGameStatsString;
var localized string    InviteTeamBodyText;


/** Loc'd string for the title of each stat in the game, indexed by GearScoreboardStatType */
var localized array<string> StatHeaderTitles;

//==============================================================
// MoviePlayer functions
//==============================================================
function Init(optional LocalPlayer Player)
{
	Super.Init(Player);

	// Begin grabbing stats data for the recent players as we open up the scene
	InitializePostGameStats();

	// Blur the frontend
	UIScene_FrontEnd(Outer).BlurMainMenu(TRUE);
}

event OnClose()
{
	Super.OnClose();
}

/** 
 *  Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch (WidgetName)
	{
		case 'PostGameStatsView':
			PostGameView = Widget;
			break;
		case 'lblButtonBar':
			ControllerBar = Widget;
			ControllerBar.SetString("htmlText", Repl(ControllerString, "`VIEWBUTTON`", ViewAsLeaderboardString));
			break;
		default:
			return Super.WidgetInitialized(WidgetName, WidgetPath, Widget);
	}

	return TRUE;
}

/**
 * Allows us to filter button input
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if( InputEvent == IE_Pressed )
	{
		if(ButtonName == 'XboxTypeS_B')
		{
			CloseView();
			return TRUE;
		}
		else if(ButtonName == 'XboxTypeS_RightShoulder')
		{
			ToggleLeaderboardView();
			return TRUE;
		}
		else if(ButtonName == 'XboxTypeS_Y')
		{
			InviteTeamToParty();
		}
	}
	
	return FALSE;
}

/** 
 * Toggles between the postgame stats view, and the leaderboard view
 */
function ToggleLeaderboardView()
{
	if( PostGameView != None )
	{
		if( PostGameView.GetBool("bInLeaderboardView") )
		{
			ActionScript_OpenPostGameStatsView();
			ControllerBar.SetString("htmlText", Repl(ControllerString, "`VIEWBUTTON`", ViewAsLeaderboardString));
		}
		else
		{
			ActionScript_OpenLeaderboardView();
			ControllerBar.SetString("htmlText", Repl(ControllerString, "`VIEWBUTTON`", ViewPostGameStatsString));
		}
	}
}

/**
 * Invites your last team to your party, if there is enough room
 */
function InviteTeamToParty()
{
	local GearGRI  GRI;
	local int AvailableSlots, ControllerId, i, j;
	local bool bFoundMatch;
	local array<UniqueNetId> IdsToInvite;
	local GearMatchData MatchResults;
	local OnlinePlayerInterface PlayerInt;
	local GearUIManager UIManager;

	// Stop now if we've already invited the team
	if( bAlreadyInvitedTeam )
	{
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.DisplayErrorMessage("AlreadyInvitedTeam_Msg", "AlreadyInvitedTeam_Title", "GenericContinue", GetLP());

		return;
	}

	GRI = GetGRI();

	// Figure out how many potential invite slots we have (game size - members already in party)
	AvailableSlots = 10 - GetNumPlayersInParty();

	// Get a team list for the player's last team
	MatchResults = PlayersList.GetLastMatchResults();
	i = MatchResults.GetTeamIndexForPlayer(GetPC().PlayerReplicationInfo.UniqueId);
	MatchResults.GetPlayersForTeam(i, IdsToInvite);

	// Iterate over the potential invitee list
	i = 0;
	while( i < IdsToInvite.Length )
	{
		// If they're already in our party, remove them from the potential list
		bFoundMatch = FALSE;
		for(j = 0; j < GRI.PRIArray.Length; j++)
		{
			if( GearPRI(GRI.PRIArray[j]).UniqueId == IdsToInvite[i] )
			{
				IdsToInvite.Remove(i, 1);
				bFoundMatch = TRUE;
				break;
			}
		}

		// Increment the counter
		if( !bFoundMatch )
		{
			++i;
		}
	}

	// If we have room, send the invite
	if( IdsToInvite.Length == 0 )
	{
		// Alert the player that we couldn't open the storage device selection UI
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.DisplayErrorMessage("NoPlayersToInvite_Msg", "NoPlayersToInvite_Title", "GenericContinue", GetLP());
	}
	else if( IdsToInvite.Length <= AvailableSlots )
	{
		PlayerInt = GetOnlinePlayerInterface();
		if( PlayerInt != None )
		{
			ControllerId = GetLP().ControllerId;
			// Send invite
			for(i = 0; i < IdsToInvite.Length; i++)
			{
				PlayerInt.SendGameInviteToFriend(ControllerId, IdsToInvite[i]);
			}

			// Alert the player that they've invited the team
			GearPC(GetPC()).GetAlertManager().Alert(eALERT_Friend, Localize("AlertStrings", "InviteSentTitle", "GearGameUI"), InviteTeamBodyText);

			bAlreadyInvitedTeam = TRUE;
		}
	}
	// Not enough room, warn the player
	else
	{
		// Alert the player that we couldn't open the storage device selection UI
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.DisplayErrorMessage("NotEnoughSlotsForTeam_Msg", "NotEnoughSlotsForTeam_Title", "GenericContinue", GetLP());
	}
}

/**
 * Closes the view, and unblurs the main menu
 */
function CloseView()
{
	UIScene_FrontEnd(Outer).UnblurMainMenu();
	ActionScript_CloseView();
}

//==============================================================
// Stat Gathering functions
//==============================================================

/**
 * Gets a list of players from a recent match, and requests their all-time stats from the online subsystem
 */
function InitializePostGameStats()
{
	local array<UniqueNetId> Players;
	local GearMatchData MatchResults;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if( OnlineSub != None )
	{
		// Get the recent player data for the last match stats
		PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
		if( PlayersList != None )
		{
			MatchResults = PlayersList.GetLastMatchResults();
			// Prepare a list of players to get all-time stats for, and start a read
			MatchResults.GetPlayersForStatsRead(Players);
			OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(OnAllTimeReadComplete);
			if( OnlineSub.StatsInterface.ReadOnlineStats(Players, MatchResults.AllTimeMatchResults))
			{
				// If we're actively reading, do the COG spin
				class'GearUIManager'.static.OpenUpdatingScene("DLStatsTitle", "DLStatsDesc", false);
			}
		}
	}

	// Finish up initializing the rest of the data
	//InitializePostGameData();
}

/**
 * Called once the all-time stats read has completed
 * 
 * @param   bWasSuccessful  Whether or not the call was completed successfully
 */
function OnAllTimeReadComplete(bool bWasSuccessful)
{
	OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnAllTimeReadComplete);

	// Kill the COG spin
	class'GearUIManager'.static.CloseUpdatingScene(false);

	InitializePostGameData();
}

/**
 * Initializes the generic aspects of the post-game stats, headers, layouts, teams, etc
 */
function InitializePostGameData()
{
	local GFxObject DataProvider, TeamInfoProvider, PlayerInfoProvider, TmpTeamObj, TmpPlayerObj;
	local GearGameMapSummary MapSummary;
	local GearMatchData MatchResults;
	local UniqueNetId PlayerID, MVPId, ZeroId;
	local array<UniqueNetId> PlayersOnTeam;
	local array<int> BotsOnTeam;
	local array<int> SortedPlayerScores;
	local array<GFxObject> SortedPlayerObjs;
	local EPostGameStatLayout CurrentLayout;
	local GearPRI LocalPRI1, LocalPRI2;
	local int NumTeams, NumStats, WinningTeamIdx, LocalPlayerTeamIdx, TeamScore, i, j, Idx, PlayerIdx, BestScore, PlayerScore;
	local bool bIsPlayerTeam;
	local string HeadshotPath, WinOrLoseLabelText;

	// Cache off the local players
	GetLocalPRIs(LocalPRI1, LocalPRI2);

	// Get the info for the last map played on
	MatchResults = PlayersList.GetLastMatchResults();
	MapSummary = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName(MatchResults.LastMpMapName);

	// Get the number of teams for the last gametype
	switch( MatchResults.LastMpGameType )
	{
		case eGEARMP_Wingman:
			NumTeams = 4;
			CurrentLayout = PGSS_Wingman;
			break;
		case eGEARMP_Horde:
			NumTeams = 1;
			CurrentLayout = PGSS_Horde;
			break;
		case eGEARMP_Siege:
			NumTeams = 1;
			CurrentLayout = PGSS_Beast;
			break;
		default:
			NumTeams = 2;
			CurrentLayout = PGSS_VSMP;
	}

	DataProvider = CreateObject("Object");

	// Set the game type, which will set up the page with the proper widgets
	DataProvider.SetFloat("GameMode", CurrentLayout);

	// Set the general page data
	DataProvider.SetString("PageTitle", PageTitle);
	DataProvider.SetString("MatchTime", MatchTimeLabel @ FormatTime(MatchResults.LastMatchTime));
	DataProvider.SetString("GameTitle", Caps(GetGameModeString(MatchResults.LastMpGameType)));
	DataProvider.SetString("MapImagePath", "img://" $ MapSummary.ScreenshotPathName);
	DataProvider.SetString("MapName", Caps(MapSummary.DisplayName));

	// Game specific header strings
	if( CurrentLayout == PGSS_VSMP )
	{
		DataProvider.SetString("MVPLabel", MVPLabel);
	}
	else if( CurrentLayout == PGSS_Wingman )
	{
		// todo:  add stats
	}
	else if( CurrentLayout == PGSS_Horde || CurrentLayout == PGSS_Beast )
	{
			DataProvider.SetString("PreviousBestScore", PreviousBestLabel @ MatchResults.PreviousHighScore);
  			DataProvider.SetBool("bNewRecordScore", MatchResults.GetScoreForTeam(CurrentLayout == PGSS_Horde ? 0 : 1) > MatchResults.PreviousHighScore);
			DataProvider.SetString("NewRecordLabel", NewRecordLabel);

			// See which wave they got to
			MatchResults.LastMatchResults.GetIntStatValueForPlayer(GetPC().PlayerReplicationInfo.UniqueId, `STATS_COLUMN_HORDE_WAVE, i);
			DataProvider.SetString("WavesCompleted", string(i));

  			DataProvider.SetString("WavesCompletedTitle", WavesCompletedLabel);
	  		DataProvider.SetString("PreviousBestWaves", PreviousBestLabel @ (MatchResults.PreviousHighWave));
	  		DataProvider.SetBool("bNewRecordWave", (i > MatchResults.PreviousHighWave));
	  		DataProvider.SetString("WaveDifficultyIconPath", " ");

			DataProvider.SetString("ColumnTitle1", WaveTotalScoreLabel);
	}

	// Get the titles for the various columns
	NumStats = GameSpecificData[MatchResults.LastMpGameType].StatOrder.Length;
	for( i = 0; i < NumStats; i++ )
	{
		DataProvider.SetString("ColumnTitle" $ i, StatHeaderTitles[ GameSpecificData[MatchResults.LastMpGameType].StatOrder[i] ]);
	}

	// Initialize team info
	WinningTeamIdx = INDEX_NONE;
	LocalPlayerTeamIdx = INDEX_NONE;

	TeamInfoProvider = CreateArray();
	// Prepare the data for each team
	for( Idx = 0; Idx < NumTeams; Idx++ )
	{
 		if( CurrentLayout == PGSS_Beast )
 		{
 			// For beast, autoincrement the team to be team 1, since team 0 doesn't matter to us.
 			Idx = 1;
 		}

		// Create a data provider for the team
		TmpTeamObj = CreateObject("Object");

		// Check if this team is COG
		TmpTeamObj.SetBool("bIsCOG", Idx % 2 == 0);

		// Handle the team score
		TeamScore = MatchResults.GetScoreForTeam(Idx);
		TmpTeamObj.SetFloat("TeamScore", TeamScore);

		// See if this is the winning team
		if( WinningTeamIdx == INDEX_NONE || (TeamScore > MatchResults.GetScoreForTeam(WinningTeamIdx)) )
		{
			WinningTeamIdx = Idx;
		}

		// Handle looping over the players for this team
		bIsPlayerTeam = FALSE;
		SortedPlayerScores.Length = 0;
		SortedPlayerObjs.Length = 0;
		MVPId = ZeroId;
		PlayerIdx = 0;
		MatchResults.GetPlayersForTeam(Idx, PlayersOnTeam);
		PlayerInfoProvider = CreateArray();
		for( i = 0; i < PlayersOnTeam.Length; i++ )
		{
			PlayerID = PlayersOnTeam[i];

			// Check to see if this is the local player's team
			if( (PlayerID == LocalPRI1.UniqueId) || (PlayerID == LocalPRI2.UniqueId) )
			{
				bIsPlayerTeam = TRUE;
				LocalPlayerTeamIdx = Idx;
			}

			// Create an entry for this player
			TmpPlayerObj = CreateObject("Object");
			
			TmpPlayerObj.SetFloat("ID", MatchResults.LastMatchPlayers.Find('NetID', PlayerID));
			TmpPlayerObj.SetString("PlayerName", GetFormattedPlayerStringFromNetId(MatchResults.GetNameForPlayer(PlayerId), PlayerId, LocalPRI1, LocalPRI2));
			TmpPlayerObj.SetString("PlayerLevel", string(MatchResults.GetLevelForPlayer(PlayerId)));
			for( j = 0; j < NumStats; j++ )
			{
				TmpPlayerObj.SetString("Stat" $ j, GetPlayerStatStringFromNetId(PlayerId, StatConstants[ GameSpecificData[MatchResults.LastMpGameType].StatOrder[j] ]));
			}

			// If the player disconnected, set bDisconnected, which will change the background to orange for that player
			if( !MatchResults.DidPlayerCompleteMatch(PlayerId) )
			{
				TmpPlayerObj.SetBool("bDisconnected", TRUE);
			}

			PlayerScore = GetPlayerStatFromNetId(PlayerId, `STATS_COLUMN_POINTS);
			// MVP if:  This is the first / highest score so far, OR the score is tied for best, and you're the local player
			if( (MVPId == ZeroId) || (PlayerScore > BestScore) || ((PlayerScore == BestScore) && (PlayerID == GetPC().PlayerReplicationInfo.UniqueId)) )
			{
				MVPId = PlayerId;
				BestScore = PlayerScore;
			}

			TmpPlayerObj.SetString("ScoreTotal", string(PlayerScore));

			// Find a sorted index to insert this player into
			for( j = 0; j < SortedPlayerScores.Length; j++ )
			{
				if( PlayerScore > SortedPlayerScores[j] )
				{
					break;
				}
			}
			SortedPlayerScores.Insert(j, 1);
			SortedPlayerObjs.Insert(j, 1);
			SortedPlayerObjs[j] = TmpPlayerObj;
			SortedPlayerScores[j] = PlayerScore;

			// Increment the player index for the next iteration
			PlayerIdx++;
		}

		// Push the sorted list to the data provider
		for( j = 0; j < PlayerIdx; j++ )
		{
			PlayerInfoProvider.SetElementObject(j, SortedPlayerObjs[j]);
		}

		
		// Handle looping over the bot info
		MatchResults.GetBotsForTeam(Idx, BotsOnTeam);
		for( i = 0; i < BotsOnTeam.Length; i++ )
		{
			TmpPlayerObj = CreateObject("Object");

			TmpPlayerObj.SetFloat("ID", PlayerIdx);
			TmpPlayerObj.SetString("PlayerName", MatchResults.LastMatchBots[BotsOnTeam[PlayerIdx]].Name);

			PlayerInfoProvider.SetElementObject(PlayerIdx, TmpPlayerObj);

			PlayerIdx++;
		}

		TmpTeamObj.SetObject("PlayerInfo", PlayerInfoProvider);

		if( CurrentLayout == PGSS_VSMP )
		{
			TmpTeamObj.SetString("MVPName", (MVPId != ZeroId ? GetFormattedPlayerStringFromNetId(MatchResults.GetNameForPlayer(MVPId), MVPId, LocalPRI1, LocalPRI2) : " "));
		}

		// Fill in the parts we needed local player info for
		TmpTeamObj.SetBool("bIsPlayerTeam", bIsPlayerTeam);

		if( CurrentLayout == PGSS_Wingman )
		{
			// If we have an MVP from the team, use them to try and find the pawn class
			if( MVPId != ZeroId )
			{
				HeadshotPath = GetHeadshotForPawnClass(MatchResults.GetPawnClassNameForPlayer(MVPId), Idx);
			}
			// Otherwise, grab it from a bot
			else
			{
				HeadshotPath = GetHeadshotForPawnClass(MatchResults.LastMatchBots[BotsOnTeam[0]].PawnClassName, Idx);
			}
			TmpTeamObj.SetString("HeadShotPath", "img://" $ HeadshotPath );
		}

		if( CurrentLayout == PGSS_Beast )
 		{
 			// For beast, decrement the team index back to 0, so that its the first entry
 			Idx = 0;
 		}
		TeamInfoProvider.SetElementObject(Idx, TmpTeamObj);
	}
	DataProvider.SetObject("TeamInfo", TeamInfoProvider);

	// Fill in the parts that we needed to process the team info for (winning team, etc)
	WinOrLoseLabelText =  MatchResults.bIncomplete ? IncompleteMatchLabel : (LocalPlayerTeamIdx == WinningTeamIdx ? WonMatchLabel : LostMatchLabel);
	DataProvider.SetString("WinOrLoseLabel", WinOrLoseLabelText);

	// Calculate the leaderboard view data provider
	MatchResults.SortPlayersByRank(PlayersOnTeam);
	PlayerInfoProvider = CreateArray();
	for( Idx = 0; Idx < PlayersOnTeam.Length; Idx++ )
	{
		// Cache off the player id, and their index into the LastMatchPlayer array
		PlayerID = PlayersOnTeam[Idx];
		j = MatchResults.LastMatchPlayers.Find('NetID', PlayerID);

		// Create an entry for this player
		TmpPlayerObj = CreateObject("Object");

		TmpPlayerObj.SetString("PlayerName", GetFormattedPlayerStringFromNetId(MatchResults.GetNameForPlayer(PlayerId), PlayerId, LocalPRI1, LocalPRI2));
		TmpPlayerObj.SetFloat("ID", j);
		TmpPlayerObj.SetString("PlayerLevel", string(MatchResults.AllTimeMatchResults.GetRankForPlayer(PlayerID)));
		TmpPlayerObj.SetString("ScoreTotal", string(GetPlayerStatFromNetId(PlayerId, `STATS_COLUMN_POINTS)));
		TmpPlayerObj.SetBool("bIsCOG", (MatchResults.LastMatchPlayers[j].TeamNum % 2 == 0));

		PlayerInfoProvider.SetElementObject(Idx, TmpPlayerObj);
	}
	DataProvider.SetObject("LeaderboardData", PlayerInfoProvider);
	DataProvider.SetString("LeaderboardViewTitle", LeaderboardViewTitle);

	// Send it to ActionScript!
	ActionScript_SetDataProvider(DataProvider);

}

//==============================================================
// Stat helper functions
//==============================================================

/**
 * Returns the numerical value of the stat, using the netId as a key
 *
 * @param PlayerNetId - UniqueNetId of the player we're getting the stat for
 * @param StatId - const value from GearOnlineConstants for this stat "STAT_COLUMN_"
 */
final function int GetPlayerStatFromNetId(UniqueNetId PlayerNetId, int StatId)
{
	local int Value;
	local GearMatchData MatchResults;

	Value = 0;
	if (PlayersList != None)
	{
		MatchResults = PlayersList.GetLastMatchResults();
		if (MatchResults.LastMatchResults != None)
		{
			// Get the stat column from the stats code
			MatchResults.LastMatchResults.GetIntStatValueForPlayer(PlayerNetId,StatId,Value);
		}
	}

	return Value;
}


/**
 * Returns the string of the stat, using the netId as a key
 *
 * @param PlayerNetId - UniqueNetId of the player we're getting the stat for
 * @param StatId - const value from GearOnlineConstants for this stat "STAT_COLUMN_"
 */
final function String GetPlayerStatStringFromNetId(UniqueNetId PlayerNetId, int StatId)
{
	local int Value;
	local GearMatchData MatchResults;

	Value = 0;
	if (PlayersList != None)
	{
		MatchResults = PlayersList.GetLastMatchResults();
		if (MatchResults != None)
		{
			// Get the stat column from the stats code
			MatchResults.LastMatchResults.GetIntStatValueForPlayer(PlayerNetId,StatId,Value);
		}
	}

	// Replace 0's with -'s for readability
	if( Value != 0 )
	{
		return string(Value);
	}
	else
	{
		return "<font color='#666666'>--</font>";
	}
}

/**
 * Returns the UI headshot image path to use for a specified pawn class
 * 
 * @param   PawnClass   Class of the pawn
 * @return  Path to the headshot to use for that character
 */
function string GetHeadshotForPawnClass(string PawnClass, int TeamIdx)
{
	local GearGameCharacterSummary CharSummary;

	// Prepend the content package name so we can find the class
	PawnClass = "GearGameContent." $ PawnClass;
	CharSummary = class'GearUIDataStore_GameResource'.static.GetCharacterProviderUsingClassName(PawnClass, (TeamIdx % 2 == 0) ? 'COGs' : 'Locusts');

	return CharSummary.CharacterPortraitSmall;
}


//==============================================================
// ActionScript interface functions
//==============================================================
function ActionScript_OpenView()
{
	PostGameView.ActionScriptVoid("OpenView");
}

function ActionScript_CloseView()
{
	PostGameView.ActionScriptVoid("CloseView");
}

function ActionScript_OpenLeaderboardView()
{
	PostGameView.ActionScriptVoid("OpenLeaderboardView");
}

function ActionScript_OpenPostGameStatsView()
{
	PostGameView.ActionScriptVoid("OpenPostGameStatsView");
}

function ActionScript_SetDataProvider(GFxObject NewData)
{
	PostGameView.ActionScriptVoid("SetDataProvider");
}

/**
 * Called when a player is selected to view more info on
 * 
 * @param   Index   Index into the PlayersList's LastMatchPlayers array for the player selected
 */
function Callback_PlayerSelected(int Index)
{
	local UIScene_FrontEnd FrontEndScene;
	local GearMatchData MatchResults;

	FrontEndScene = UIScene_FrontEnd(Outer);
	if( FrontEndScene != None )
	{
		MatchResults = PlayersList.GetLastMatchResults();
		FrontEndScene.OpenPersonalStats(None, MatchResults.LastMatchPlayers[Index].NetId, PlayersList, None);
	}
}

/**
 * Called when the scene is done fading out, and is ready to close the movie
 */
function Callback_DoneFadingOut()
{
	UIScene_FrontEnd(Outer).ClosePostGameStats();
}

defaultproperties
{
	bCaptureInput=TRUE
	bOnlyOwnerFocusable=TRUE

	Priority=GEAR_SCENE_PRIORITY_POSTGAME

	CaptureKeys.Empty()
	CaptureKeys(0)=XboxTypeS_Start
	CaptureKeys(1)=XboxTypeS_A
	CaptureKeys(2)=XboxTypeS_B
	CaptureKeys(3)=XboxTypeS_X
	CaptureKeys(4)=XboxTypeS_Y
	CaptureKeys(5)=XboxTypeS_LeftShoulder
	CaptureKeys(6)=XboxTypeS_RightShoulder
	CaptureKeys(7)=XboxTypeS_LeftTrigger
	CaptureKeys(8)=XboxTypeS_RightTrigger
	CaptureKeys(9)=XboxTypeS_DPad_Up
	CaptureKeys(10)=XboxTypeS_DPad_Down
	CaptureKeys(11)=XboxTypeS_DPad_Right
	CaptureKeys(12)=XboxTypeS_DPad_Left
	CaptureKeys(13)=Gamepad_LeftStick_Up
	CaptureKeys(14)=Gamepad_LeftStick_Down
	CaptureKeys(15)=Gamepad_LeftStick_Right

	GameSpecificData(eGEARMP_Warzone)=(StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
	GameSpecificData(eGEARMP_Execution)=(StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
	GameSpecificData(eGEARMP_Horde)=(StatOrder=(eGSStat_Kills))
	GameSpecificData(eGEARMP_Siege)=(StatOrder=(eGSStat_Kills))
	GameSpecificData(eGEARMP_Wingman)=(StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))
	GameSpecificData(eGEARMP_KOTH)=(StatOrder=(eGSStat_AnnexCap,eGSStat_AnnexBreak,eGSStat_Kills,eGSStat_Downs))
	GameSpecificData(eGEARMP_CTL)=(StatOrder=(eGSStat_LeaderCap,eGSStat_LeaderRelease,eGSStat_Kills,eGSStat_Downs))
	GameSpecificData(eGEARMP_Newbie)=(StatOrder=(eGSStat_Kills,eGSStat_Downs,eGSStat_Revives,eGSStat_Deaths))

	StatConstants(eGSStat_Deaths)=`STATS_COLUMN_DEATHS
	StatConstants(eGSStat_Downs)=`STATS_COLUMN_TAKEDOWNS
	StatConstants(eGSStat_Kills)=`STATS_COLUMN_KILLS
	StatConstants(eGSStat_Revives)=`STATS_COLUMN_REVIVES
	StatConstants(eGSStat_AnnexCap)=`STATS_COLUMN_ANNEX_CAPTURES
	StatConstants(eGSStat_AnnexBreak)=`STATS_COLUMN_ANNEX_BREAKS
	StatConstants(eGSStat_LeaderCap)=`STATS_COLUMN_GUARDIAN_LEADERGRABS
	StatConstants(eGSStat_LeaderRelease)=`STATS_COLUMN_GUARDIAN_LEADERSAVES

}
