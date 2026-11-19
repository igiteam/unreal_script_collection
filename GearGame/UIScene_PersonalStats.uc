/**
 * Personal Stats screen
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_PersonalStats extends GearGFxMoviePlayer;

`include(GearLeaderboardConstants.uci)

// --- Widget References ------------------------------
/** Object that serves as our interface to the personal stats screen */
var transient GFxObject PersonalStatsView;

// --- State Tracking ---------------------------------
enum PersonalStatContext
{
	PSC_LocalPlayer,
	PSC_PreviousMatch,
	PSC_Leaderboard
};
var transient PersonalStatContext StatContext;

/** Type of game this page should display stats for.  Invalid until bContextSet == TRUE */
var transient eGearMPTypes CurrentGameType;

/** Whether or not we have invited this player to our party  */
var transient bool                bHasInvitedToParty;

// --- Stat Page --------------------------------------
struct StatPageInfo
{
	/** Symbol to load for this stat page, which will in turn call Callback_RequestDataForPage_<PageSymbolToLoad> to request data */
	var string  PageSymbolToLoad;

	/** If StatContext is PreviousMatch or Leaderboards, these column ids will be used to populate the rows. */
	var array<int>  StatIdsToDisplay;

	/** If StatContext is LocalPlayer, these stat names will be used to populate the rows */
	var array<name> StatNamesToDisplay;

	/** If StatContext is PreviousMatch, if this bool is TRUE, all-time stats will be used for this page.  If FALSE, previous match results will be used*/
	var bool    bUseAllTimeStats;
};

/** Index of the current page we're on */
var transient int       CurrentStatPageIndex;

/** Helper struct to contain a dynamic array of pages for a given gametype */
struct StatPageCollection
{
	/** List of pages to display for this gametype */
	var array<StatPageInfo> StatPages;
};
/** List of pages of stats to display, indexed by EGearMPTypes*/
var array<StatPageCollection> GameTypePages;

// --- Leaderboard Interface Vars ---------------------

/** Whether or not we've had the context set, and thus is safe to populate the screen */
var transient bool                  bContextSet;

/** GearPC, used for PSC_LocalPlayer */
var transient GearPC                TargetGPC;

/** NetId of the player to show stats for, for PSC_PreviousMatch / PSC_Leaderboards */
var transient UniqueNetId           CurrentPlayer;

/** Reference to the leaderboards and recent players list for PSC_PreviousMatch */
var transient GearRecentPlayersList RecentPlayerList;

/** Reference to the leaderboards for PSC_Leaderboards */
var transient GearLeaderboardBase   Leaderboard;

// --- Menu Option Handlers ---------------------------
enum PersonalStatsMenuOptions
{
	PSMO_InviteToParty,
	PSMO_Feedback,
	PSMO_MutePlayer,
	PSMO_AddPlayer,
	PSMO_ViewGamercard
};

/** Array of delegates that return whether or not we can perform the menu action, indexed by PersonalStatMenuOptions */
var array<delegate<CanDoPlayerOption> >     CanDoMenuOptionHandlers;

/** Array of delegates that perform the menu action, indexed by PersonalStatMenuOptions */
var array<delegate<DoPlayerOption> >        MenuOptionHandlers;

/** String descriptions for the menu items defined in PersonalStatsMenuOptions */
var localized array<string> MenuOptionStrings;

struct MenuOptionList
{
	/** Array containing the valid menu options for this stat context */
	var array<PersonalStatsMenuOptions>     MenuOptions;
};

/** Contains a list of valid menu options for the corresponding stat context, indexed by the PersonalStatContext */
var array<MenuOptionList>                   ContextMenuOptions;

// --- Localized Strings ------------------------------
/** Title for the page when in the personal stats context */
var localized string        PersonalStatsTitle;

/** Title for the page when in the previous match context */
var localized string        PreviousMatchStatsTitle;

/** Title for the page when in the leaderboard context */
var localized string        LeaderboardStatsTitle;

/** Misc. Strings */
var localized string        MatchesPlayedString;
var localized string        ControllerMap;
var localized string        LeftBumperIcon;
var localized string        RightBumperIcon;
var localized string        PageDescriptionString;
var localized string        PreviousPageString;
var localized string        NextPageString;
var localized string        StatSummaryTitle;

/** Player details localized strings */
var localized string        PlayerRankLabel;
var localized string        PlayerLevelLabel;
var localized string        KDRatioLabel;
var localized string        WLRatioLabel;
var localized string        WinsLabel;
var localized string        LossesLabel;
var localized string        GamesPlayedLabel;
var localized string        RoundsPlayedLabel;
var localized string        DisconnectsLabel;
var localized string        PointsPerMatchLabel;

// --- Misc. Variables --------------------------------


//=====================================================
// Movie Player Functions
//=====================================================

function Init(optional LocalPlayer LocPlay)
{
	Super.Init(LocPlay);

	if( !bContextSet )
	{
		`log("WARNING:  No context set for UIScene_PersonalStats!",,'GearsUI');
	}
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch( WidgetName )
	{
		case 'PlayerStatsMain':
			PersonalStatsView = Widget;
			InitializeView();
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

event OnClose()
{
	local UIScene_FrontEnd FrontEndScene;

	Super.OnClose();

	// Clean up any dangling references
	FrontEndScene = UIScene_FrontEnd(Outer);
	if( FrontEndScene != None )
	{
		FrontEndScene.PersonalStatsScene = None;
	}
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if( InputEvent == IE_Pressed )
	{
		switch(ButtonName)
		{
			case 'XboxTypeS_B':
				ActionScript_CloseView();
				return TRUE;
			case 'XboxTypeS_LeftShoulder':
				CycleStatPage(-1);
				return TRUE;
			case 'XboxTypeS_RightShoulder':
				CycleStatPage(1);
				return TRUE;

			default:
		}
	}

	return FALSE;
}

//=====================================================
// Personal Stat Functions
//=====================================================
										
/**
 * Function to initialize the common elements of the scene, such as the headers, footers, etc
 * 
 * Data Provider Layout:
 * ----------------------------------------------------
 * PageTitle            - Title of the page
 * TotalMatches         - Total matches that the player has played
 * MenuProvider         - Array of GFxObjects with one element for each entry in the menu
 * 	 label                  - Title of the menu option
 * ControllerMap        - String with the button options for this menu
 * LeftBumperLabel      - String with the left bumper from the controller font
 * RightBumperLabel     - String with the right bumper from the controller font
 * PageDescription      - Description stating the page that the player is currently viewing (e.g. Page 1 / 2)
 * NextLabel            - Localized string for "NEXT PAGE"
 * PreviousLabel        - Localized string for "PREVIOUS PAGE"
 * Gamertag             - Gamertag of the player these stats are for
 * MainBodySymbol       - Page symbol to load into the main body of the page
 * SummaryPageSymbol    - Page symbol to load into the player details section of the page
 * PlayerIcon           - (optional) Controller ring icon for local players
 * PlayerTitle          - (optional) Title of the player
 * MedalImg             - (optional) Path to the texture of the player's medal (e.g. img://MyPackage.MyTexture)
 * XPCurrent            - (optional) Current XP the player has earned towards the next level
 * XPTotal              - (optional) Required XP for the player to get to the next level
 */
function InitializeView()
{
	local GearPC GPC;
	local GearPRI PRI;
	local GearAward Award;
	local GFxObject DataProvider, MenuProvider, TmpObj;
	local PersonalStatsMenuOptions MenuOption;
	local int i, CurrentXP, LastLevelXP, NextLevelXP;

	// If we haven't set a context, bail early
	if( !bContextSet )
	{
		return;
	}

	DataProvider = CreateObject("Object");

	switch(StatContext)
	{
		case PSC_Leaderboard:
			DataProvider.SetString("PageTitle", LeaderboardStatsTitle);
			break;
		case PSC_PreviousMatch:
			DataProvider.SetString("PageTitle", PreviousMatchStatsTitle);
			break;
		case PSC_LocalPlayer:
		default:
			DataProvider.SetString("PageTitle", PersonalStatsTitle);
			break;
	}

	DataProvider.SetString("TotalMatches", GetMatchesPlayed() @ MatchesPlayedString);

	// Create the menu provider
	MenuProvider = CreateArray();
	for( i = 0; i < ContextMenuOptions[StatContext].MenuOptions.Length; i++ )
	{
		TmpObj = CreateObject("Object");
		// Set the localized string for the menu options specific to the current stat context
		MenuOption = ContextMenuOptions[StatContext].MenuOptions[i];
		TmpObj.SetString("label", MenuOptionStrings[MenuOption]);
		TmpObj.SetFloat("ButtonType", MenuOption);
		MenuProvider.SetElementObject(i, TmpObj);
	}
	DataProvider.SetObject("MenuProvider", MenuProvider);

	// Configure the static labels
	DataProvider.SetString("ControllerMap", ControllerMap);
	DataProvider.SetString("LeftBumperLabel", LeftBumperIcon);
	DataProvider.SetString("RightBumperLabel", RightBumperIcon);
	DataProvider.SetString("NextLabel", NextPageString);
	DataProvider.SetString("PreviousLabel", PreviousPageString);
	DataProvider.SetString("PageDescription", GetMainBodyPageDescription());
	
	// Configure the player's gamertag
	DataProvider.SetString("Gamertag", GetPlayerGamertag());

	if( StatContext == PSC_LocalPlayer )
	{
		GPC = GetGearPC();

		DataProvider.SetString("PlayerIcon", GetControllerIcon(GetLP().ControllerId));

		// Populate the award / title section
		if( GPC.AwardManager != None )
		{
			PRI = GearPRI(GPC.PlayerReplicationInfo);
			if( PRI.MedalID != INDEX_NONE )
			{
				Award = GPC.AwardManager.FindAwardByPersistentDataID(PRI.MedalID);
			}
			
			if( Award != None )
			{
				// Set up the medal and title, if available
				DataProvider.SetString("PlayerTitle", Award.GetTitleString(Award.AwardName));
				DataProvider.SetString("MedalImg", "img://" $ Award.IconPath);
				DataProvider.SetFloat("MedalRank", Award.MedalRank);
			}
			else
			{
				// No award is available, just add blank text
				DataProvider.SetString("PlayerTitle", Caps(Localize("AwardTitleStrings", "Default", "GearAwards")));
				DataProvider.SetString("MedalImg", "img://" $ "UI_Medals.T_Medals_Default");
			}
		}
		
		// Populate the level progress fields
		CurrentXP = GPC.StatManager.GetStatValueByName('XP');
		GPC.StatManager.DetermineLevel(CurrentXP, LastLevelXP, NextLevelXP);
		DataProvider.SetFloat("XPCurrent", CurrentXP - LastLevelXP);
		DataProvider.SetFloat("XPTotal", NextLevelXP - LastLevelXP);
	}

	// Set the pages to load for the player details and the main body
	DataProvider.SetString("MainBodySymbol", GetMainBodySymbol());
	DataProvider.SetString("SummaryPageSymbol", GetPlayerDetailsSymbol());

	// Send the data provider to actionscript
	ActionScript_SetDataProvider(DataProvider);
}

/**
 * Initializes the player stats for the context of a local player, where we have full access to stats
 * 
 * @param   TargetPlayer    Controller of the player to display stats for, NOT necessarily the PC owner of this scene
 * @param   StatType        Game type to display stats for
 */
function InitializePlayer_LocalPlayer(GearPC TargetPlayer, EGearMPTypes StatType)
{
	if( TargetPlayer != None )
	{
		StatContext = PSC_LocalPlayer;

		TargetGPC = TargetPlayer;

		CurrentGameType = StatType;

		bContextSet = TRUE;
	}
}

/**
 * Initializes the player stats for the context of a leaderboard player, where we have limited access to stats for one game type
 * 
 * @param   TargetPlayer        NetId within the leaderboard of the player to display stats for
 * @param   TargetLeaderboard   Leaderboard to grab the stats from
 */
function InitializePlayer_Leaderboards(UniqueNetId TargetPlayer, GearLeaderboardBase TargetLeaderboard)
{
	local UniqueNetId ZeroId;

	if( (TargetPlayer != ZeroId) && (TargetLeaderboard != None) )
	{
		StatContext = PSC_Leaderboard;

		CurrentPlayer = TargetPlayer;
		Leaderboard = TargetLeaderboard;

		CurrentGameType = GetStatGameType();

		bContextSet = TRUE;
	}
}

/**
 * Initializes the player stats for the context of a postgame stats player, where we have access to previous round results and all time results
 * 
 * @param   TargetPlayer        NetId within the GRPL's leaderboards of the player to display stats for
 * @param   TargetPlayerList    Recent players list, which contains match-only leaderboards and all-time leaderboards
 */
function InitializePlayer_Postgame(UniqueNetId TargetPlayer, GearRecentPlayersList TargetPlayerList)
{
	local UniqueNetId ZeroId;

	if( (TargetPlayer != ZeroId) && (TargetPlayerList != None) )
	{
		StatContext = PSC_PreviousMatch;

		CurrentPlayer = TargetPlayer;
		RecentPlayerList = TargetPlayerList;

		CurrentGameType = GetStatGameType();

		bContextSet = TRUE;
	}
}

/**
 * Returns the name of the symbol to load for the player details, depending on the context
 * 
 * @return String containing the name of the symbol to load into the player details section
 */
function string GetPlayerDetailsSymbol()
{
	switch(StatContext)
	{
		case PSC_Leaderboard:
			return "PlayerDetailsLeaderboards";
		case PSC_PreviousMatch:
		case PSC_LocalPlayer:
		default:
			return "PlayerDetailsMain";
	}
}

/**
 * Returns the name of the symbol to load for the main body of the page, depending on context
 * 
 * @return  String containing the name of the symbol to load into the main body section
 */
function string GetMainBodySymbol()
{
	return GameTypePages[CurrentGameType].StatPages[CurrentStatPageIndex].PageSymbolToLoad;
}

/**
 * Returns the total number of stats pages that are available to cycle through for this mode
 * 
 * @return  Number of pages available in this stats view
 */
function int GetTotalStatPages()
{
	return GameTypePages[CurrentGameType].StatPages.Length;
}

/**
 * Returns a string description of the current page
 */
function string GetMainBodyPageDescription()
{
	return PageDescriptionString @ (CurrentStatPageIndex+1) $ "/" $ GetTotalStatPages();
}

/**
 * Cycles the page number up or down by the specified index.  Wraps if necessary
 * 
 * @param   CycleDirection  Number of pages to cycle.  Positive numbers cycle up, negatives cycle down
 */
function CycleStatPage(int CycleDirection)
{
	local int TotalPages;

	CurrentStatPageIndex += CycleDirection;

	// Check the bounds, and wrap if necessary
	TotalPages = GetTotalStatPages();
	if( CurrentStatPageIndex >= TotalPages )
	{
		CurrentStatPageIndex = 0;
	}
	else if( CurrentStatPageIndex < 0 )
	{
		CurrentStatPageIndex = TotalPages - 1;
	}

	// Load a new page
	ActionScript_LoadNewStatsPage(GetMainBodySymbol(), GetMainBodyPageDescription());
}

//=====================================================
// Helper functions
//=====================================================
/**
 * Returns the game type that the screen is displaying stats for
 */
function EGearMPTypes GetStatGameType()
{
	local GearMatchData MatchResults;

	if( bContextSet )
	{
		// If the context has been set, then the current game type has been cached, and is valid
		return CurrentGameType;
	}
	else
	{
		// If context hasn't finished being set yet, determine the gametype
		switch(StatContext)
		{
			case PSC_PreviousMatch:
				MatchResults = RecentPlayerList.GetLastMatchResults();
				return MatchResults.LastMpGameType;
			case PSC_Leaderboard:
				if( Leaderboard.IsA('GearLeaderboardGuardianBase') )
				{
					return eGEARMP_CTL;
				}
				else if( Leaderboard.IsA('GearLeaderboardHorde') )
				{
					return eGEARMP_Horde;
				}
				else if( Leaderboard.IsA('GearLeaderboardReadKothBase') )
				{
					return eGEARMP_KOTH;
				}
				else if( Leaderboard.IsA('GearLeaderboardSiege') )
				{
					return eGEARMP_Siege;
				}
				else if( Leaderboard.IsA('GearLeaderboardTDMWeeklyPlayer') ||
						Leaderboard.IsA('GearLeaderboardTDMWeekly') ||
						Leaderboard.IsA('GearLeaderboardTDMMonthlyPlayer') ||
						Leaderboard.IsA('GearLeaderboardTDMMonthly') ||
						Leaderboard.IsA('GearLeaderboardTDMAllTimePri') ||
						Leaderboard.IsA('GearLeaderboardTDMAllTimePlayer') ||
						Leaderboard.IsA('GearLeaderboardTDMAllTime') )
				{
					return eGEARMP_Newbie;
				}
				else if( Leaderboard.IsA('GearLeaderboardExecutionWeeklyPlayer') ||
						Leaderboard.IsA('GearLeaderboardExecutionWeekly') ||
						Leaderboard.IsA('GearLeaderboardExecutionMonthlyPlayer') ||
						Leaderboard.IsA('GearLeaderboardExecutionMonthly') ||
						Leaderboard.IsA('GearLeaderboardExecutionAllTimePri') ||
						Leaderboard.IsA('GearLeaderboardExecutionAllTimePlayer') ||
						Leaderboard.IsA('GearLeaderboardExecutionAllTime') )
				{
					return eGEARMP_Execution;
				}
				else
				{
					return eGEARMP_Warzone;
				}
			case PSC_LocalPlayer:
				return CurrentGameType;
		}
	}
}

/**
 * Returns the gamertag of the player currently being displayed
 * 
 * @return Gamertag of the player
 */
function string GetPlayerGamertag()
{
	local int Idx;
	local GearMatchData MatchResults;

	switch(StatContext)
	{
		case PSC_PreviousMatch:
			MatchResults = RecentPlayerList.GetLastMatchResults();
			return MatchResults.GetNameForPlayer(CurrentPlayer);
		case PSC_Leaderboard:
			Idx = Leaderboard.Rows.Find('PlayerId', CurrentPlayer);
			return Leaderboard.Rows[Idx].NickName;
		case PSC_LocalPlayer:
		default:
			return TargetGPC.PlayerReplicationInfo.PlayerName;
	}
}

/**
 * Gets the number of matches played by the player
 * 
 * @return Number of matches played
 */
function int GetMatchesPlayed()
{
	local EGearMPTypes MPType;
	local GearMatchData MatchResults;
	local name TargetStat;
	local int StatValue;

	switch(StatContext)
	{
		case PSC_PreviousMatch:
			MatchResults = RecentPlayerList.GetLastMatchResults();
			MatchResults.AllTimeMatchResults.GetIntStatValueForPlayer(CurrentPlayer, `STATS_COLUMN_MATCHESPLAYED, StatValue);
			return StatValue;
		case PSC_Leaderboard:
			Leaderboard.GetIntStatValueForPlayer(CurrentPlayer, `STATS_COLUMN_MATCHESPLAYED, StatValue);
			return StatValue;
		case PSC_LocalPlayer:
			// Figure out which stat to get, based on game type
			MPType = GetStatGameType();
			switch(MPType)
			{
				case eGEARMP_Warzone:
					TargetStat = 'WarzonePlayed';
					break;
				case eGEARMP_Execution:
					TargetStat = 'ExecutionPlayed';
					break;
				case eGEARMP_Horde:
					TargetStat = 'HordePlayed';
					break;
				case eGEARMP_Wingman:
					TargetStat = 'WingmanPlayed';
					break;
				case eGEARMP_KOTH:
					TargetStat = 'KOTHPlayed';
					break;
				case eGEARMP_CTL:
					TargetStat = 'CTLPlayed';
					break;
				case eGEARMP_Newbie:
					TargetStat = 'TDMPlayed';
					break;
				case eGEARMP_Siege:
					TargetStat = 'SiegePlayed';
					break;
				case eGEARMP_MAX:
					// NEED STAT HERE FOR ARCADE
					TargetStat = '';
					break;
				default:
					break;
			}
			return TargetGPC.StatManager.GetStatValueByName(TargetStat);
	}
}

/**
 * Gets the formatted ratio of the two numbers specified
 * 
 * @param   Stat1   First statistic, numerator of the ratio
 * @param   Stat2   Second statistic, denominator of the ratio
 * @return  String formatted with the ratio, or "--" if DIV0
 */
function string GetStatRatio(float Stat1, float Stat2)
{
	if( Stat2 != 0.f )
	{
		return TrimFloat(string(Stat1 / Stat2));
	}

	return "--";
}

//=====================================================
// Menu Option Handlers
//=====================================================
/** Delegate used to determine if a player option is available or not */
delegate bool CanDoPlayerOption();

/** Delegate used to perform a player option */
delegate DoPlayerOption();

/**
 * Whether or not we have a valid player interface to do things like show gamercard, etc
 * 
 * @return TRUE if we have a valid interface, FALSE if not
 */
function bool HasValidPlayerInterface()
{
	local OnlineSubsystem OnlineSub;
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	return (OnlineSub != None) && (OnlineSub.PlayerInterfaceEx != None);
}

/**
 * Whether or not the current player has a valid NetId for performing Live actions on
 * 
 * @return TRUE if the player has a valid NetId, FALSE otherwise
 */
function bool HasValidNetId()
{
	local UniqueNetId   ZeroId;

	return (CurrentPlayer != ZeroId);
}

/**
 * Whether or not the current player is the local player, and can do things like add to the friends list
 * 
 * @return TRUE if the player is not the local player, FALSE if the current player is the local player
 */
function bool IsValidRemotePlayer()
{
	return (GetGearPC().PlayerReplicationInfo.UniqueId != CurrentPlayer);
}

/**
 * Invites the current player to the party
 */
function InviteToParty()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInt;
	local int ControllerId;
	
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerInt = OnlineSub.PlayerInterface;
		if (PlayerInt != None)
		{
			ControllerId = GetLP().ControllerId;
			PlayerInt.SendGameInviteToFriend(ControllerId, CurrentPlayer);

			// Only allow one invite per screen opening
			bHasInvitedToParty = TRUE;
		}
	}
}

/**
 * Whether or not we can invite this person to the party
 * 
 * @return TRUE if we can invite them to the party, FALSE if we can't.
 */
function bool CanInviteToParty()
{
	return !bHasInvitedToParty && (StatContext != PSC_LocalPlayer) && HasValidPlayerInterface() && HasValidNetId() && IsValidRemotePlayer();
}

/**
 * Opens Live feedback menu
 */
function GiveFeedback()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local int ControllerId;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerIntEx = OnlineSub.PlayerInterfaceEx;
		if (PlayerIntEx != None)
		{
			ControllerId = GetLP().ControllerId;
			PlayerIntEx.ShowFeedbackUI(ControllerId, CurrentPlayer);
		}
	}
}

/**
 * Whether or not we can give feedback
 */
function bool CanGiveFeedback()
{
	return (StatContext != PSC_LocalPlayer) && HasValidPlayerInterface() && HasValidNetId() && IsValidRemotePlayer();
}

/**
 * Ignores the current player
 */
function MutePlayer()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInt;
	local OnlineVoiceInterface VoiceInt;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		VoiceInt = OnlineSub.VoiceInterface;
		PlayerInt = OnlineSub.PlayerInterface;
		if ( (VoiceInt != None) && (PlayerInt != None) )
		{
			// Toggle the mute on the player
			if( PlayerInt.IsMuted(GetLP().ControllerId, CurrentPlayer) )
			{
				VoiceInt.UnmuteRemoteTalker(GetLP().ControllerId, CurrentPlayer, true);
			}
			else
			{
				VoiceInt.MuteRemoteTalker(GetLP().ControllerId, CurrentPlayer, true);
			}
		}
	}
}

/**
 * Whether or not we can ignore this player
 * 
 * @return TRUE if we can ignore them, FALSE if not
 */
function bool CanMutePlayer()
{
	return (StatContext != PSC_LocalPlayer) && HasValidPlayerInterface() && HasValidNetId() && IsValidRemotePlayer();
}

/**
 * Adds the player as a friend
 */
function AddPlayer()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local int ControllerId;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerIntEx = OnlineSub.PlayerInterfaceEx;
		if (PlayerIntEx != None)
		{
			ControllerId = GetLP().ControllerId;
			PlayerIntEx.ShowFriendsInviteUI(ControllerId, CurrentPlayer);
		}
	}
}

/**
 * Whether or not we can add this player as a friend
 * 
 * @return TRUE if we can add them as a friend, FALSE if not
 */
function bool CanAddPlayer()
{
	//todo:  See if they are already our friend
	return HasValidPlayerInterface() && HasValidNetId() && IsValidRemotePlayer();
}

/**
 * Views the player's gamercard
 */
function ViewGamercard()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local UniqueNetId PlayerId;
	local int ControllerId;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerIntEx = OnlineSub.PlayerInterfaceEx;
		if (PlayerIntEx != None)
		{
			ControllerId = GetLP().ControllerId;
			PlayerId = StatContext == PSC_LocalPlayer ? TargetGPC.PlayerReplicationInfo.UniqueId : CurrentPlayer;
			PlayerIntEx.ShowGamerCardUI(ControllerId, PlayerId);
		}
	}
}

/** 
 * Whether or not we can view this player's gamercard
 * 
 * @return TRUE if we can view this player's gamer card, FALSE if not
 */
function bool CanViewGamerCard()
{
	return HasValidPlayerInterface() && HasValidNetId();
}


//=====================================================
// ActionScript Calls
//=====================================================
function ActionScript_SetDataProvider(GFxObject DataProvider)
{
	PersonalStatsView.ActionScriptVoid("SetDataProvider");
}

function ActionScript_LoadNewStatsPage(string NewStatPageSymbol, string NewPageDescription)
{
	PersonalStatsView.ActionScriptVoid("LoadNewStatsPage");
}

function ActionScript_SetDataProvider_SummaryPage(GFxObject DataProvider, GFxObject TargetPage)
{
	PersonalStatsView.ActionScriptVoid("SetDataProvider_SummaryPage");
}

function ActionScript_SetDataProvider_MainPage(GFxObject DataProvider, GFxObject TargetPage)
{
	PersonalStatsView.ActionScriptVoid("SetDataProvider_MainPage");
}

function ActionScript_CloseView()
{
	PersonalStatsView.ActionScriptVoid("CloseView");
}

//=====================================================
// Callbacks
//=====================================================
function Callback_DoneFadingOut()
{
	Close(TRUE);
}

/**
 * Called when a menu item has been selected
 * 
 * @param   Index   The index that was selected
 */
function Callback_MenuItemSelected(int Index)
{
	local delegate<CanDoPlayerOption> CanDoHandler;
	local delegate<DoPlayerOption> Handler;

	if( Index < PSMO_MAX )
	{
		// See if we can perform this menu operation
		CanDoHandler = CanDoMenuOptionHandlers[Index];
		if( CanDoHandler() )
		{
			// If so, call the handler
			Handler = MenuOptionHandlers[Index];
			Handler();
		}
	}
}

/**
 * Page Handler Callbacks:
 * ----------------------------------------------------
 * Called when the page with the symbol name at the end is initialized, and needs a data provider.
 * Data providers are then fed back through the main view, to avoid having a different class for each page
 */
function Callback_RequestDataForPage_StatPageMain(GFxObject TargetPage)
{
	local GFxObject StatDataProvider, StatsArray, TmpObj;
	local GearLeaderboardBase TargetLeaderboard;
	local GearMatchData MatchResults;
	local bool bIsLeaderboardBased;
	local int i, TmpInt;
	local string ColumnName;
	local String TmpStr;

	StatDataProvider = CreateObject("Object");

	bIsLeaderboardBased = (StatContext == PSC_Leaderboard) || (StatContext == PSC_PreviousMatch);
	if( bIsLeaderboardBased )
	{
		MatchResults = RecentPlayerList.GetLastMatchResults(); 

		if( StatContext == PSC_PreviousMatch )
		{
			// If this is a previous match stats page, determine if we should use the previous match stats, or all time stats
			TargetLeaderboard = (GameTypePages[CurrentGameType].StatPages[CurrentStatPageIndex].bUseAllTimeStats ? MatchResults.AllTimeMatchResults : MatchResults.LastMatchResults);
		}
		else
		{
			TargetLeaderboard = Leaderboard;
		}
		
		// Set up the page title and header
		StatDataProvider.SetString("PageTitle", StatSummaryTitle);
		StatDataProvider.SetString("PageNumber", PageDescriptionString @ (CurrentStatPageIndex + 1));

		// Create the list array of stats
		StatsArray = CreateArray();
		for( i = 0; i < GameTypePages[CurrentGameType].StatPages[CurrentStatPageIndex].StatIdsToDisplay.Length; i++ )
		{
			TmpObj = CreateObject("Object");

			// Get the localized stat object
			TmpInt = TargetLeaderboard.ColumnMappings.Find('Id', GameTypePages[CurrentGameType].StatPages[CurrentStatPageIndex].StatIdsToDisplay[i]);
			ColumnName = TargetLeaderboard.ColumnMappings[TmpInt].ColumnName;
			if( Len(ColumnName) == 0 )
			{
				// If we failed to get a localized name, just use the column name
				ColumnName = string(TargetLeaderboard.ColumnMappings[TmpInt].Name);
			}
			TmpObj.SetString("StatName", ColumnName);

			TargetLeaderboard.GetStatValueForPlayerAsString(CurrentPlayer, GameTypePages[CurrentGameType].StatPages[CurrentStatPageIndex].StatIdsToDisplay[i], TmpStr);
			TmpStr = TrimFloat(TmpStr);
			TmpObj.SetString("StatValue", TmpStr);

			StatsArray.SetElementObject(i, TmpObj);
		}
		StatDataProvider.SetObject("StatsListDataProvider", StatsArray);
	}

	ActionScript_SetDataProvider_MainPage(StatDataProvider, TargetPage);
}
function Callback_RequestDataForPage_PlayerDetailsLeaderboards(GFxObject TargetPage)
{
	PlayerDetailsHelper(TargetPage);
}

function Callback_RequestDataForPage_PlayerDetailsMain(GFxObject TargetPage)
{
	PlayerDetailsHelper(TargetPage);
}

/** Helper function to trim floats to the right of the decimal point */
function string TrimFloat(string Str, optional int NumDigits = 2)
{
	local int DecimalIdx;

	DecimalIdx = InStr(Str, ".");
	if (DecimalIdx != INDEX_NONE)
	{
		Str = Left(Str, DecimalIdx + NumDigits + 1);
	}

	return Str;
}

/**
 * Populates the data for the player's details, and sends it to actionscript
 * 
 * @param   TargetPage  Page to set the data provider for
 */
function PlayerDetailsHelper(GFxObject TargetPage)
{
	local GFxObject DetailDataProvider;
	local GearLeaderboardBase TargetLeaderboard;
	local GearMatchData MatchResults;
	local GearGameCharacterSummary CharSummary;
	local GearStatManager StatManager;
	local bool bIsLeaderboardBased;
	local int Stat1, Stat2, Stat3;
	local float FloatStat;
	local string TmpString;

	// See if we'll have to be reading these stats out of a leaderboard
	bIsLeaderboardBased = (StatContext == PSC_Leaderboard) || (StatContext == PSC_PreviousMatch);
	
	DetailDataProvider = CreateObject("Object");

	DetailDataProvider.SetString("PlayerLevelLabel", (StatContext == PSC_Leaderboard) ? PlayerRankLabel : PlayerLevelLabel);
	DetailDataProvider.SetString("KDRatioLabel", KDRatioLabel);
	DetailDataProvider.SetString("WLRatioLabel", WLRatioLabel);
	DetailDataProvider.SetString("WinsLabel", WinsLabel);
	DetailDataProvider.SetString("LossesLabel", LossesLabel);
	DetailDataProvider.SetString("GamesPlayedLabel", GamesPlayedLabel);
	DetailDataProvider.SetString("RoundsPlayedLabel", RoundsPlayedLabel);
	DetailDataProvider.SetString("DisconnectsLabel", DisconnectsLabel);

	if( bIsLeaderboardBased )
	{
		MatchResults = RecentPlayerList.GetLastMatchResults();

		// Cache a reference to the appropriate leaderboard, so we can use the same code to grab out the stats
		TargetLeaderboard = (StatContext == PSC_Leaderboard) ? Leaderboard : MatchResults.AllTimeMatchResults;

		if( StatContext == PSC_PreviousMatch )
		{
			// If we have a reference to the pawn used, grab the character shot and send it to actionscript
			TmpString = "GearGameContent." $ MatchResults.GetPawnClassNameForPlayer(CurrentPlayer);
			CharSummary = class'GearUIDataStore_GameResource'.static.GetCharacterProviderUsingClassName(TmpString, (InStr(TmpString, "GearPawn_COG") != INDEX_NONE) ? 'COGs' : 'Locusts');
			DetailDataProvider.SetString("PlayerImage", "img://" $ CharSummary.CharacterPortraitLarge);

			// Set the player's level here, since we know that fron the recent player stats
			DetailDataProvider.SetString("PlayerLevel", string(MatchResults.GetLevelForPlayer(CurrentPlayer)));
		}
		else
		{
			// Leaderboards don't have level, so grab the player's ranking on the board
			DetailDataProvider.SetString("PlayerLevel", string(TargetLeaderboard.GetRankForPlayer(CurrentPlayer)));
		}

		TargetLeaderboard.GetFloatStatValueForPlayer(CurrentPlayer, `STATS_COLUMN_KILLDEATH_RATIO, FloatStat);
		TmpString = TrimFloat(string(FloatStat));
		DetailDataProvider.SetString("KDRatio", TmpString);

		TargetLeaderboard.GetIntStatValueForPlayer(CurrentPlayer, `STATS_COLUMN_MATCHESWON, Stat1);
		TargetLeaderboard.GetIntStatValueForPlayer(CurrentPlayer, `STATS_COLUMN_MATCHESLOST, Stat2);
		DetailDataProvider.SetString("WLRatio", GetStatRatio(Stat1, Stat2));
		DetailDataProvider.SetString("Wins", string(Stat1));
		DetailDataProvider.SetString("Losses", string(Stat2));

		TargetLeaderboard.GetIntStatValueForPlayer(CurrentPlayer, `STATS_COLUMN_MATCHESPLAYED, Stat1);
		DetailDataProvider.SetString("GamesPlayed", string(Stat1));

		TargetLeaderboard.GetIntStatValueForPlayer(CurrentPlayer, `STATS_COLUMN_ROUNDSPLAYED, Stat1);
		DetailDataProvider.SetString("RoundsPlayed", string(Stat1));

		TargetLeaderboard.GetIntStatValueForPlayer(CurrentPlayer, `STATS_COLUMN_DISCONNECTCOUNT, Stat1);
		DetailDataProvider.SetString("Disconnects", string(Stat1));
	}
	else
	{
		StatManager = TargetGPC.StatManager;
		CharSummary = class'GearUIDataStore_GameResource'.static.GetCharacterProvider(GearPRI(TargetGPC.PlayerReplicationInfo).PreferredCOGIndex, 'COGs');
 		DetailDataProvider.SetString("PlayerImage", "img://" $ CharSummary.CharacterPortraitLarge);
		DetailDataProvider.SetString("PlayerLevel", string(StatManager.GetStatValueByName('PlayerLevel')));

		switch( CurrentGameType )
		{
			case eGEARMP_Warzone:
			case eGEARMP_Execution:
			case eGEARMP_Wingman:
			case eGEARMP_KOTH:
			case eGEARMP_CTL:
			case eGEARMP_Newbie:
				Stat1 = StatManager.GetStatValueByName('KillsMP');
				Stat2 = StatManager.GetStatValueByName('DeathsMP');
				DetailDataProvider.SetString("KDRatio", GetStatRatio(Stat1, Stat2));

				Stat1 = StatManager.GetStatValueByName('GamesWonMP');
				Stat2 = StatManager.GetStatValueByName('GamesLostMP');
				DetailDataProvider.SetString("WLRatio", GetStatRatio(Stat1, Stat2));

				DetailDataProvider.SetString("Wins", string(Stat1));
		 		DetailDataProvider.SetString("Losses", string(Stat2));

				DetailDataProvider.SetString("GamesPlayed", string(StatManager.GetStatValueByName('GamesPlayedMP')));

				Stat1 = StatManager.GetStatValueByName('RoundsWonMP');
				Stat2 = StatManager.GetStatValueByName('RoundsLostMP');
				Stat3 = StatManager.GetStatValueByName('RoundsDrawnMP');
		 		DetailDataProvider.SetString("RoundsPlayed", string(Stat1 + Stat2 + Stat3));

				DetailDataProvider.SetString("Disconnects", string(TargetGPC.ProfileSettings.GetDisconnectCount()));
				break;
			case eGEARMP_Siege:
				Stat1 = StatManager.GetStatValueByName('KillsSiege');
				Stat2 = StatManager.GetStatValueByName('DeathsSiege');
				DetailDataProvider.SetString("KDRatio", GetStatRatio(Stat1, Stat2));

				//Stat1 = StatManager.GetStatValueByName('RoundsWonMP');
				//Stat2 = StatManager.GetStatValueByName('RoundsLostMP');
				//DetailDataProvider.SetString("WLRatio", GetStatRatio(Stat1, Stat2));

				//DetailDataProvider.SetString("Wins", Stat1);
		 		//DetailDataProvider.SetString("Losses", Stat2);

				//Stat1 = StatManager.GetStatValueByName('RoundsDrawMP');
		 		//DetailDataProvider.SetString("Draws", Stat1);

				//DetailDataProvider.SetString("GamesPlayed", StatManager.GetStatValueByName('SiegePlayed'));		
		 		//DetailDataProvider.SetString("RoundsPlayed", StatManager.GetStatValueByName('SiegeRoundsPlayed'));
		 		//DetailDataProvider.SetString("Disconnects", StatManager.GetStatValueByName('DisconnectsSiege'));
				break;
			case eGEARMP_Horde:
				Stat1 = StatManager.GetStatValueByName('KillsHorde');
				Stat2 = StatManager.GetStatValueByName('DeathsHorde');
				DetailDataProvider.SetString("KDRatio", GetStatRatio(Stat1, Stat2));

				//Stat1 = StatManager.GetStatValueByName('RoundsWonMP');
				//Stat2 = StatManager.GetStatValueByName('RoundsLostMP');
				//DetailDataProvider.SetString("WLRatio", GetStatRatio(Stat1, Stat2));

				//DetailDataProvider.SetString("Wins", Stat1);
		 		//DetailDataProvider.SetString("Losses", Stat2);

				//Stat1 = StatManager.GetStatValueByName('RoundsDrawMP');
		 		//DetailDataProvider.SetString("Draws", Stat1);

				//DetailDataProvider.SetString("GamesPlayed", StatManager.GetStatValueByName('SiegePlayed'));		
		 		//DetailDataProvider.SetString("RoundsPlayed", StatManager.GetStatValueByName('SiegeRoundsPlayed'));
		 		//DetailDataProvider.SetString("Disconnects", StatManager.GetStatValueByName('DisconnectsSiege'));
				break;
			case eGEARMP_MAX:
				Stat1 = StatManager.GetStatValueByName('KillsArcade');
				Stat2 = StatManager.GetStatValueByName('DeathsArcade');
				DetailDataProvider.SetString("KDRatio", GetStatRatio(Stat1, Stat2));

				//Stat1 = StatManager.GetStatValueByName('RoundsWonMP');
				//Stat2 = StatManager.GetStatValueByName('RoundsLostMP');
				//DetailDataProvider.SetString("WLRatio", GetStatRatio(Stat1, Stat2));

				//DetailDataProvider.SetString("Wins", Stat1);
		 		//DetailDataProvider.SetString("Losses", Stat2);

				//Stat1 = StatManager.GetStatValueByName('RoundsDrawMP');
		 		//DetailDataProvider.SetString("Draws", Stat1);

				//DetailDataProvider.SetString("GamesPlayed", StatManager.GetStatValueByName('SiegePlayed'));		
		 		//DetailDataProvider.SetString("RoundsPlayed", StatManager.GetStatValueByName('SiegeRoundsPlayed'));
		 		//DetailDataProvider.SetString("Disconnects", StatManager.GetStatValueByName('DisconnectsSiege'));
				break;
		}
	}

	ActionScript_SetDataProvider_SummaryPage(DetailDataProvider, TargetPage);
}

defaultproperties
{
	bCaptureInput=TRUE
	bOnlyOwnerFocusable=true

	Priority=GEAR_SCENE_PRIORITY_STATS

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

	ContextMenuOptions(PSC_LocalPlayer)={(MenuOptions=(PSMO_ViewGamercard))}
	ContextMenuOptions(PSC_PreviousMatch)={(MenuOptions=(PSMO_ViewGamercard, PSMO_InviteToParty, PSMO_AddPlayer, PSMO_Feedback, PSMO_MutePlayer))}
	ContextMenuOptions(PSC_Leaderboard)={(MenuOptions=(PSMO_AddPlayer, PSMO_ViewGamercard))}

	CanDoMenuOptionHandlers(PSMO_InviteToParty)=CanInviteToParty
	CanDoMenuOptionHandlers(PSMO_Feedback)=CanGiveFeedback
	CanDoMenuOptionHandlers(PSMO_MutePlayer)=CanMutePlayer
	CanDoMenuOptionHandlers(PSMO_AddPlayer)=CanAddPlayer
	CanDoMenuOptionHandlers(PSMO_ViewGamercard)=CanViewGamerCard

	MenuOptionHandlers(PSMO_InviteToParty)=InviteToParty
	MenuOptionHandlers(PSMO_Feedback)=GiveFeedback
	MenuOptionHandlers(PSMO_MutePlayer)=MutePlayer
	MenuOptionHandlers(PSMO_AddPlayer)=AddPlayer
	MenuOptionHandlers(PSMO_ViewGamercard)=ViewGamercard

	GameTypePages(eGEARMP_Warzone)= {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_KILLS,`STATS_COLUMN_DEATHS,`STATS_COLUMN_REVIVES,`STATS_COLUMN_TAKEDOWNS,`STATS_COLUMN_POINTS,`STATS_COLUMN_KILLDEATH_RATIO,`STATS_COLUMN_POINTSPERMATCH_RATIO,`STATS_COLUMN_POINTSPERROUND_RATIO,`STATS_COLUMN_MATCHESPLAYED,`STATS_COLUMN_MATCHESWON,`STATS_COLUMN_MATCHESLOST,`STATS_COLUMN_ROUNDSPLAYED,`STATS_COLUMN_ROUNDSWON,`STATS_COLUMN_ROUNDSLOST,`STATS_COLUMN_ROUNDSDRAW)))
									)}

	GameTypePages(eGEARMP_Execution)= {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_KILLS,`STATS_COLUMN_DEATHS,`STATS_COLUMN_REVIVES,`STATS_COLUMN_TAKEDOWNS,`STATS_COLUMN_POINTS,`STATS_COLUMN_KILLDEATH_RATIO,`STATS_COLUMN_POINTSPERMATCH_RATIO,`STATS_COLUMN_POINTSPERROUND_RATIO,`STATS_COLUMN_MATCHESPLAYED,`STATS_COLUMN_MATCHESWON,`STATS_COLUMN_MATCHESLOST,`STATS_COLUMN_ROUNDSPLAYED,`STATS_COLUMN_ROUNDSWON,`STATS_COLUMN_ROUNDSLOST,`STATS_COLUMN_ROUNDSDRAW)))
									)}

	GameTypePages(eGEARMP_Horde)=   {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_HORDE_WAVE,`STATS_COLUMN_HORDE_POINTS,`STATS_COLUMN_HORDE_CASHEARNED,`STATS_COLUMN_HORDE_CASHSPENT,`STATS_COLUMN_HORDE_FLAGSSPENT,`STATS_COLUMN_HORDE_WALLSSPENT,`STATS_COLUMN_HORDE_DECOYSSPENT,`STATS_COLUMN_HORDE_TURRETSSPENT,`STATS_COLUMN_HORDE_SENTRIESSPENT,`STATS_COLUMN_HORDE_SILVERBACKSSPENT,`STATS_COLUMN_HORDE_COMMANDCENTERSPENT)),
													 (PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_HORDE_CREATURE1KILLS,`STATS_COLUMN_HORDE_CREATURE2KILLS,`STATS_COLUMN_HORDE_CREATURE3KILLS,`STATS_COLUMN_HORDE_CREATURE4KILLS,`STATS_COLUMN_HORDE_CREATURE5KILLS,`STATS_COLUMN_HORDE_CREATURE6KILLS,`STATS_COLUMN_HORDE_CREATURE7KILLS,`STATS_COLUMN_HORDE_CREATURE8KILLS,`STATS_COLUMN_HORDE_CREATURE9KILLS,`STATS_COLUMN_HORDE_CREATURE10KILLS,`STATS_COLUMN_HORDE_CREATURE11KILLS,`STATS_COLUMN_HORDE_CREATURE12KILLS,`STATS_COLUMN_HORDE_CREATURE13KILLS,`STATS_COLUMN_HORDE_CREATURE14KILLS,`STATS_COLUMN_HORDE_CREATURE15KILLS,`STATS_COLUMN_HORDE_CREATURE16KILLS)),
													 (PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_HORDE_CREATURE17KILLS,`STATS_COLUMN_HORDE_CREATURE18KILLS,`STATS_COLUMN_HORDE_CREATURE19KILLS,`STATS_COLUMN_HORDE_CREATURE20KILLS,`STATS_COLUMN_HORDE_CREATURE21KILLS,`STATS_COLUMN_HORDE_CREATURE22KILLS,`STATS_COLUMN_HORDE_CREATURE23KILLS,`STATS_COLUMN_HORDE_CREATURE24KILLS,`STATS_COLUMN_HORDE_CREATURE25KILLS,`STATS_COLUMN_HORDE_CREATURE26KILLS,`STATS_COLUMN_HORDE_CREATURE27KILLS,`STATS_COLUMN_HORDE_CREATURE28KILLS,`STATS_COLUMN_HORDE_CREATURE29KILLS,`STATS_COLUMN_HORDE_CREATURE30KILLS)))
									)}
	
    GameTypePages(eGEARMP_Wingman)= {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_KILLS,`STATS_COLUMN_DEATHS,`STATS_COLUMN_REVIVES,`STATS_COLUMN_TAKEDOWNS,`STATS_COLUMN_POINTS,`STATS_COLUMN_KILLDEATH_RATIO,`STATS_COLUMN_POINTSPERMATCH_RATIO,`STATS_COLUMN_POINTSPERROUND_RATIO,`STATS_COLUMN_MATCHESPLAYED,`STATS_COLUMN_MATCHESWON,`STATS_COLUMN_MATCHESLOST,`STATS_COLUMN_ROUNDSPLAYED,`STATS_COLUMN_ROUNDSWON,`STATS_COLUMN_ROUNDSLOST,`STATS_COLUMN_ROUNDSDRAW)))														
									)}
	
	GameTypePages(eGEARMP_KOTH)=    {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_ANNEX_BREAKS,`STATS_COLUMN_KOTH_RINGPOINTS,`STATS_COLUMN_KILLS,`STATS_COLUMN_DEATHS,`STATS_COLUMN_REVIVES,`STATS_COLUMN_TAKEDOWNS,`STATS_COLUMN_POINTS,`STATS_COLUMN_MATCHESPLAYED,`STATS_COLUMN_MATCHESWON,`STATS_COLUMN_MATCHESLOST,`STATS_COLUMN_ROUNDSPLAYED,`STATS_COLUMN_ROUNDSWON,`STATS_COLUMN_ROUNDSLOST,`STATS_COLUMN_ROUNDSDRAW,`STATS_COLUMN_ANNEX_CAPTURES)))														
									)}

	GameTypePages(eGEARMP_CTL)=     {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_GUARDIAN_LEADERCAPTURES,`STATS_COLUMN_GUARDIAN_LEADERSAVES,`STATS_COLUMN_GUARDIAN_KILLSASLEADER,`STATS_COLUMN_KILLS,`STATS_COLUMN_DEATHS,`STATS_COLUMN_REVIVES,`STATS_COLUMN_TAKEDOWNS,`STATS_COLUMN_POINTS,`STATS_COLUMN_MATCHESPLAYED,`STATS_COLUMN_MATCHESWON,`STATS_COLUMN_MATCHESLOST,`STATS_COLUMN_ROUNDSPLAYED,`STATS_COLUMN_ROUNDSWON,`STATS_COLUMN_ROUNDSLOST,`STATS_COLUMN_ROUNDSDRAW)))														
									)}
     
	GameTypePages(eGEARMP_Newbie)=  {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_KILLS,`STATS_COLUMN_DEATHS,`STATS_COLUMN_REVIVES,`STATS_COLUMN_TAKEDOWNS,`STATS_COLUMN_POINTS,`STATS_COLUMN_KILLDEATH_RATIO,`STATS_COLUMN_POINTSPERMATCH_RATIO,`STATS_COLUMN_POINTSPERROUND_RATIO,`STATS_COLUMN_MATCHESPLAYED,`STATS_COLUMN_MATCHESWON,`STATS_COLUMN_MATCHESLOST,`STATS_COLUMN_ROUNDSPLAYED,`STATS_COLUMN_ROUNDSWON,`STATS_COLUMN_ROUNDSLOST,`STATS_COLUMN_ROUNDSDRAW)))														
									)}      

	GameTypePages(eGEARMP_Siege)=   {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_HORDE_WAVE,`STATS_COLUMN_HORDE_POINTS,`STATS_COLUMN_SIEGE_TOKENSEARNED,`STATS_COLUMN_SIEGE_TOKENSSPENT,`STATS_COLUMN_SIEGE_WALLSDESTROYED,`STATS_COLUMN_SIEGE_DECOYSDESTROYED,`STATS_COLUMN_SIEGE_TURRETSDESTROYED,`STATS_COLUMN_SIEGE_SENTRIESDESTROYED,`STATS_COLUMN_SIEGE_SILVERBACKDESTROYED,`STATS_COLUMN_SIEGE_COMMANDCENTERSDESTROYED)),
													 (PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_SIEGE_HERO1KILLS,`STATS_COLUMN_SIEGE_HERO2KILLS,`STATS_COLUMN_SIEGE_HERO3KILLS,`STATS_COLUMN_SIEGE_HERO4KILLS,`STATS_COLUMN_SIEGE_HERO5KILLS,`STATS_COLUMN_SIEGE_HERO6KILLS,`STATS_COLUMN_SIEGE_HERO7KILLS,`STATS_COLUMN_SIEGE_HERO8KILLS,`STATS_COLUMN_SIEGE_HERO9KILLS,`STATS_COLUMN_SIEGE_HERO10KILLS,`STATS_COLUMN_SIEGE_HERO11KILLS,`STATS_COLUMN_SIEGE_HERO12KILLS,`STATS_COLUMN_SIEGE_HERO13KILLS,`STATS_COLUMN_SIEGE_HERO14KILLS,`STATS_COLUMN_SIEGE_HERO15KILLS)),
													 (PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_SIEGE_BEAST1SPAWN,`STATS_COLUMN_SIEGE_BEAST1KILLS,`STATS_COLUMN_SIEGE_BEAST2SPAWN,`STATS_COLUMN_SIEGE_BEAST2KILLS,`STATS_COLUMN_SIEGE_BEAST3SPAWN,`STATS_COLUMN_SIEGE_BEAST3KILLS,`STATS_COLUMN_SIEGE_BEAST4SPAWN,`STATS_COLUMN_SIEGE_BEAST4KILLS,`STATS_COLUMN_SIEGE_BEAST5SPAWN,`STATS_COLUMN_SIEGE_BEAST5KILLS,`STATS_COLUMN_SIEGE_BEAST6SPAWN,`STATS_COLUMN_SIEGE_BEAST6KILLS,`STATS_COLUMN_SIEGE_BEAST7SPAWN,`STATS_COLUMN_SIEGE_BEAST7KILLS,`STATS_COLUMN_SIEGE_BEAST8SPAWN,`STATS_COLUMN_SIEGE_BEAST8KILLS)),
													 (PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_SIEGE_BEAST9SPAWN,`STATS_COLUMN_SIEGE_BEAST9KILLS,`STATS_COLUMN_SIEGE_BEAST10SPAWN,`STATS_COLUMN_SIEGE_BEAST10KILLS,`STATS_COLUMN_SIEGE_BEAST11SPAWN,`STATS_COLUMN_SIEGE_BEAST11KILLS,`STATS_COLUMN_SIEGE_BEAST12SPAWN,`STATS_COLUMN_SIEGE_BEAST12KILLS,`STATS_COLUMN_SIEGE_BEAST13SPAWN,`STATS_COLUMN_SIEGE_BEAST13KILLS,`STATS_COLUMN_SIEGE_BEAST14SPAWN,`STATS_COLUMN_SIEGE_BEAST14KILLS,`STATS_COLUMN_SIEGE_BEAST15SPAWN,`STATS_COLUMN_SIEGE_BEAST15KILLS,`STATS_COLUMN_SIEGE_BEAST16SPAWN,`STATS_COLUMN_SIEGE_BEAST16KILLS)))
									)}     
    
	// Arcade Stats are "eGEARMP_MAX"
	GameTypePages(eGEARMP_MAX)=     {(
										StatPages=  ((PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_KILLS,`STATS_COLUMN_REVIVES,`STATS_COLUMN_TAKEDOWNS,`STATS_COLUMN_HIGHSCORE,`STATS_COLUMN_HIGHESTMULTIPLIER,`STATS_COLUMN_ARCADE_HIGHESTONEKILLSCORE,`STATS_COLUMN_DIFFICULTY)),
													 (PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_ARCADE_CREATURE1KILLS,`STATS_COLUMN_ARCADE_CREATURE2KILLS,`STATS_COLUMN_ARCADE_CREATURE3KILLS,`STATS_COLUMN_ARCADE_CREATURE4KILLS,`STATS_COLUMN_ARCADE_CREATURE5KILLS,`STATS_COLUMN_ARCADE_CREATURE6KILLS,`STATS_COLUMN_ARCADE_CREATURE7KILLS,`STATS_COLUMN_ARCADE_CREATURE8KILLS,`STATS_COLUMN_ARCADE_CREATURE9KILLS,`STATS_COLUMN_ARCADE_CREATURE10KILLS,`STATS_COLUMN_ARCADE_CREATURE11KILLS,`STATS_COLUMN_ARCADE_CREATURE12KILLS,`STATS_COLUMN_ARCADE_CREATURE13KILLS,`STATS_COLUMN_ARCADE_CREATURE14KILLS,`STATS_COLUMN_ARCADE_CREATURE15KILLS,`STATS_COLUMN_ARCADE_CREATURE16KILLS)),
													 (PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_ARCADE_CREATURE17KILLS,`STATS_COLUMN_ARCADE_CREATURE18KILLS,`STATS_COLUMN_ARCADE_CREATURE19KILLS,`STATS_COLUMN_ARCADE_CREATURE20KILLS,`STATS_COLUMN_ARCADE_CREATURE21KILLS,`STATS_COLUMN_ARCADE_CREATURE22KILLS,`STATS_COLUMN_ARCADE_CREATURE23KILLS,`STATS_COLUMN_ARCADE_CREATURE24KILLS,`STATS_COLUMN_ARCADE_CREATURE25KILLS,`STATS_COLUMN_ARCADE_CREATURE26KILLS,`STATS_COLUMN_ARCADE_CREATURE27KILLS,`STATS_COLUMN_ARCADE_CREATURE28KILLS,`STATS_COLUMN_ARCADE_CREATURE29KILLS,`STATS_COLUMN_ARCADE_CREATURE30KILLS,`STATS_COLUMN_ARCADE_CREATURE31KILLS,`STATS_COLUMN_ARCADE_CREATURE32KILLS)),
													 (PageSymbolToLoad="StatPageMain",StatIdsToDisplay=(`STATS_COLUMN_ARCADE_CREATURE33KILLS,`STATS_COLUMN_ARCADE_CREATURE34KILLS,`STATS_COLUMN_ARCADE_CREATURE35KILLS,`STATS_COLUMN_ARCADE_CREATURE36KILLS,`STATS_COLUMN_ARCADE_CREATURE37KILLS,`STATS_COLUMN_ARCADE_CREATURE38KILLS,`STATS_COLUMN_ARCADE_CREATURE39KILLS,`STATS_COLUMN_ARCADE_CREATURE40KILLS)))										
									)}
}
