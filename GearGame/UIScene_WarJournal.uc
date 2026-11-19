/**
 * UIScene_WarJournal:
 * Implementation of the Unreal-side of the War Journal
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIScene_WarJournal extends GearGFxMoviePlayer
	config(UI);

`include(GearLeaderboardConstants.uci)

// --- Widget References ---------------------------------------
/** View which controls and serves as the interface to the WJ */
var private transient GFxObject WJView;

/** References to pages within the WJ */
var private transient GFxObject SummaryPage;
var private transient GFxObject AchievementsPage;
var private transient GFxObject ChallengesPage;
var private transient GFxObject CollectiblesPage;
var private transient GFxObject HordePage;
var private transient GFxObject MedalsPage;
var private transient GFxObject LeaderboardsPage;

// --- Localized Strings ---------------------------------------
var localized string    WarJournalTitle;
var localized string    SummaryHeader;
var localized string    ChallengesRecentHeader;
var localized string    CollectiblesRecentHeader;

// --- Localization for the achievements ------------------------
var localized string    GamerPointsLabel;

// --- Localization for the challenges -------------------------
var localized string    RequireString;
var localized string    ProgressRequireString;

// --- Localization for the Horde ------------------------------
var localized string    HordeLevelString;
var localized string    HordeLevelStringShort;

// --- Localization for the Leaderboards -----------------------
var localized string        LeaderboardLoadingString;
var localized string        LeaderboardVersusGroupString;
var localized string        LeaderboardHordeGroupString;
var localized string        LeaderboardSiegeGroupString;
var localized string        LeaderboardArcadeGroupString;
var localized array<string> LeaderboardCategoryStrings;
var localized string        Leaderboards_Matches;
var localized string        Leaderboards_Games;
var localized string        Leaderboards_Chapters;

var localized string        Leaderboard_RankDescription;
var localized string        Leaderboard_GamertagDescription;
var localized string        Leaderboard_ScoreDescription;

var localized string        FilterButton_LeftTrigger;
var localized string        FilterButton_RightTrigger;
var localized string        FilterButton_Arrows;

// --- Localization for the Summary ----------------------------
var localized string NewStuff;
var localized string NoNewStuff;

/** WJ menu operations */
var localized string    Controller_Back;
var localized string    Controller_Close;
var localized string    Controller_ViewCollectible;
var localized string    Controller_ViewStats;
var localized string    Controller_ViewSection_Challenges;
var localized string    Controller_ViewSection_Collectibles;
var localized string    Controller_ViewLeaderboardInfo;
var localized string    Controller_ViewLeaderboards;
var string              Controller_Spacer;

// --- Page Symbols --------------------------------------------
/** Enum defining the tabs / pages of the war journal.  Changing the order here will change the order of the tabs */
enum EWJPages
{
	WJ_Summary,
	WJ_Achievements,
	WJ_Challenges,
	WJ_Collectibles,
	WJ_Horde,
	WJ_Medals,
	WJ_Leaderboards
};

/** Structure to store the data needed to handle each tab in the war journal */
struct WJTabData
{
	/** Symbol name for the tabs */
	var config name WJTabSymbol;
	/** Tab name for the page */
	var localized string WJTabTitle;
};

/** List of WJ tab data */
var config array<WJTabData> TabData;

/** The current page of the WJ that we're on */
var transient EWJPages  CurrentPage;

// --- Summary start -----------------------------------------------

/** List of stat names that will get displayed in the summary page (Order is handled from left to right, row by row) */
var config array<Name> SummaryStatNames;

/** Stuct containing stat context information for the summary page buttons */
struct SummaryPageStatInfo
{
	/** MP type to bring stats up for */
	var EGearMPTypes        MPType;

	/** Localized string to be displayed in the button */
	var localized string    StatDescription;
};

/** Array of buttons to include on the summary stat page */
var config array<SummaryPageStatInfo>   SummaryStats;

// --- Summary end -----------------------------------------------

// --- Collectibles start -----------------------------------------------

/** Structure to store whether a discoverable was found and/or needs viewed */
struct WJDiscoverData
{
	/** The discoverable this is dealing with */
	var EGearDiscoverableType Type;
	/** Whether they player has unlocked it */
	var bool bFound;
	/** Whether the player still needs to view it */
	var bool bNeedsViewed;
	/** The act this discoverable was found in */
	var int ActIdx;
};

/** List of discoverable data to let us know if things were found or need viewed */
var transient array<WJDiscoverData> DiscoverData;
/** The act index that we are currently displaying the page of */
var transient int CurrActIdx;

// --- Collectibles end -----------------------------------------------

// --- Challenges start -----------------------------------------------

/** Data needed to describe the challenge groupings */
struct WJChallengeGroupData
{
	/** The award type of this group */
	var config EAwardType GroupType;
	/** The localized name of this group */
	var localized string GroupDisplayName;
	/** The localized string that describes this award as being earned */
	var localized string EarnedSentence;
};

/** List of the data for the challenge groups and the order they are handled */
var config array<WJChallengeGroupData> ChallengeGroups;

// --- Challenges end -----------------------------------------------

// --- Horde start -----------------------------------------------

/** Enum of the different horde fortification groups that can be unlocked */
enum EWJHordeGroup
{
	WJHORDE_Wall,
	WJHORDE_Decoy,
	WJHORDE_Sentry,
	WJHORDE_Turret,
	WJHORDE_Silverback,
	WJHORDE_CommandCenter,
	WJHORDE_Flag,
};

/** Structure of storing the data required for displaying horde fortification unlocks */
struct WJHordeFortData
{
	/** The enum of the horde group this is describing */
	var config EWJHordeGroup FortType;
	/** The name of the award that allows this group to be unlocked (empty means unlocked by default) */
	var config Name UnlockAwardName;
	/** List of award names of the awards that this fortification unlocks */
	var config array<Name> AwardNames;
	/** Whether this horde unlock should be displayed or not */
	var config bool bActive;
	/** Localized string of the title of this group */
	var localized string FortTitle;
};

/** List of horde grouping data */
var config array<WJHordeFortData> HordeGroupData;

// --- Horde end -----------------------------------------------

// --- Leaderboards start --------------------------------------

/** Whether or not we're reading leaderboards, and should block input */
var transient bool bReadingLeaderboards;

/** Whether the friends list was read or not */
var transient bool bHasReadFriends;

/** Caches the leaderboard datastore so we can refresh or manipulate the filter */
var transient	GearLeaderboardsDataStoreBase			LeaderboardsDataStore;

/** The type of leaderboard being displayed */
enum ELeaderboardType
{
	LBT_Public,
	LBT_Player,
	LBT_Private,
	LBT_Horde,
	LBT_Siege,
	LBT_Arcade
};

/** The type of leaderboard being displayed so we can bind to different datastores */
var	transient ELeaderboardType LeaderboardType;

// --- Leaderboards end ----------------------------------------


//==============================================================
// Movie Player Functions
//==============================================================

/** 
 *  This should be called when a new GearGFxMoviePlayer is initialized.
 *  Handles the setting up of the LocalPlayerIndex, as well as automatically starting / advancing the movie if desired 
 *  
 *  @param LocPlay  Local player that is the owner of this scene
 */
function Init(optional LocalPlayer LocPlay)
{
	Super.Init(LocPlay);

	// Blur out the front end
	TryBlurFrontEnd();
}

/** Overloaded to save our persistent data */
event OnClose()
{
	GetGearPC().ClientSaveAllPlayerData();
	Super.OnClose();
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
	switch( WidgetName )
	{
		case 'mc_WarJournal':
			WJView = Widget;
			InitializeWarJournal();
			break;
		case TabData[WJ_Summary].WJTabSymbol:
			SummaryPage = Widget;
			CurrentPage = WJ_Summary;
			InitializePage_Summary();
			break;
		case TabData[WJ_Achievements].WJTabSymbol:
			AchievementsPage = Widget;
			CurrentPage = WJ_Achievements;
			InitializePage_Achievements();
			break;
		case TabData[WJ_Challenges].WJTabSymbol:
			ChallengesPage = Widget;
			CurrentPage = WJ_Challenges;
			InitializePage_Challenges_Page1();
			break;
		case TabData[WJ_Collectibles].WJTabSymbol:
			CollectiblesPage = Widget;
			CurrentPage = WJ_Collectibles;
			InitializePage_Collectibles_Page1();
			break;
		case TabData[WJ_Horde].WJTabSymbol:
			HordePage = Widget;
			CurrentPage = WJ_Horde;
			InitializePage_Horde();
			break;
		case TabData[WJ_Medals].WJTabSymbol:
			MedalsPage = Widget;
			CurrentPage = WJ_Medals;
			InitializePage_Medals();
			break;
		case TabData[WJ_Leaderboards].WJTabSymbol:
			LeaderboardsPage = Widget;
			CurrentPage = WJ_Leaderboards;
			InitializePage_Leaderboards();
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

/** 
 * Can be overridden to filter input to this movie.  Return TRUE to trap the input, FALSE to let it pass through to Gfx
 *
 * @param   ControllerId    The Id of the controller that the input came from
 * @param   ButtonName      The name of the button that was hit
 * @param   InputEvent      What type of input event was this (e.g. pressed, released)
 * 
 * @return  TRUE if the input should be trapped and not passed on, FALSE to pass it on to GFx for handling
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	// If we're reading leaderboards, block ALL input
	if( bReadingLeaderboards )
	{
		return TRUE;
	}

	return FALSE;
}

//==============================================================
// War Journal Control and Flow
//==============================================================

/**
 * Handles initialization and setup or War Journal
 */
function InitializeWarJournal()
{
	local GFxObject DataProvider, TabObject;
	local int i;
	local GearAwardManager AwardMgr;

	// Need the award manager to cache how many awards need viewed
	AwardMgr = GetGearPC().AwardManager;
	if (AwardMgr != None)
	{
		AwardMgr.CacheAwardDataByGroup();
	}

	// Cache war journal data
	CacheDiscoverableData();

	// Create a data provider, which we'll fill with tabs to populate the War Journal with
	DataProvider = CreateArray();
	for( i = 0; i < EWJPages.EnumCount; i++ )
	{
		TabObject = CreateObject("Object");

		// Give the tab a symbol name, a title, and set whether or not we need a (!) bing
		TabObject.SetString("Symbol", string(TabData[i].WJTabSymbol));
		TabObject.SetString("Title", TabData[i].WJTabTitle);
		TabObject.SetBool("bShowNewIcon", PageNeedsViewed(EWJPages(i), GetGearPC()));

		// Add it to the list
		DataProvider.SetElementObject(i, TabObject);
	}

	// Send the tab list to ActionScript
	ActionScript_WarJournal_SetDataProvider(DataProvider);

	// Set the title of the war journal
	WJView.SetString("WarJournalTitle", WarJournalTitle);

	// Initialize the player name
	WJView.SetString("PlayerNameHtml", GetPC().PlayerReplicationInfo.PlayerName @ GetControllerIcon(GetLP().ControllerId));

	// Initialize the tab trigger indicators
	WJView.GetObject("lbl_NextTabButton").SetString("htmlText", Localize("ControllerFont", "Controller_RightBumper", "GearGameUI"));
	WJView.GetObject("lbl_PrevTabButton").SetString("htmlText", Localize("ControllerFont", "Controller_LeftBumper", "GearGameUI"));
}

/**
 * Returns whether any war journal page should be displaying the "needs viewed" icon in the summary screen
 * Used by the main menu to determine if the main menu object should be marked with a bang
 * 
 *  @param GPC - GearPC whose profile we are looking into
 *  @return Whether or not any of the pages need to be viewed
 */
static final function bool AnyPagesNeedViewed(GearPC GPC)
{
	local int i;

	for (i=0; i < WJ_MAX; i++)
	{
		if (PageNeedsViewed(EWJPages(i), GPC))
		{
			return true;
		}
	}
	return false;
}

/**
 * Returns whether a war journal page should be displaying the "needs viewed" icon in the summary screen
 *
 * @param PageType - the tab/page of the summary screen we are inquiring about
 */
static final function bool PageNeedsViewed(EWJPages PageType, GearPC GPC)
{
	local GearAwardManager AwardMgr;

	AwardMgr = GPC.AwardManager;
	if (AwardMgr != None)
	{
		switch (PageType)
		{
			case WJ_Summary:
				return false;
			case WJ_Achievements:
				return (GPC.ProfileSettings.GetNumUnviewedAchievements() > 0);
				return false;
			case WJ_Challenges:
				return (AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Ribbon) > 0 ||
						AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_WeaponSkin) > 0 ||
						AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Mutator) > 0 ||
						AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Execution) > 0 ||
						AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_AvatarItem) > 0);
			case WJ_Collectibles:
				return (GPC.ProfileSettings.AreAnyDiscoverablesUnviewed());
			case WJ_Horde:
				return (AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Fortification) > 0);
			case WJ_Medals:
				return (AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Medal) > 0);
		}
	}

	return false;
}

/**
 * Returns the number of items that "need viewed" for the summary screen
 *
 * @param PageType - the tab/page of the summary screen we are inquiring about
 */
final function int NumPagesNeedingViewed(EWJPages PageType)
{
	local GearAwardManager AwardMgr;

	AwardMgr = GetGearPC().AwardManager;
	if (AwardMgr != None)
	{
		switch (PageType)
		{
			case WJ_Summary:
				return 0;
			case WJ_Achievements:
				return GetGearPC().ProfileSettings.GetNumUnviewedAchievements();
			case WJ_Challenges:
				return (AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Ribbon) +
						AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_WeaponSkin) +
						AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Mutator) +
						AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Execution) +
						AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_AvatarItem));
			case WJ_Collectibles:
				return NumDiscoverablesNeedingViewed();
			case WJ_Horde:
				return AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Fortification);
			case WJ_Medals:
				return AwardMgr.GetNumAwardsNeedingViewedByType(GEARAWARDTYPE_Medal);
		}
	}

	return 0;
}

/**
 * Updates current tab based on whether or not it needs to display a (!) notification
 */
function UpdateCurrentTabBing()
{
	ActionScript_ToggleUpdatedIconForTab(CurrentPage, PageNeedsViewed(CurrentPage,GetGearPC()));
}

/**
 * Initializes the summary page of the WJ
 * 
 * Data Provider Summary:
 * -------------------------------------------
 * ControllerMap            - Button mapping string representing what the player can do on this screen
 * PlayerName               - Name of the player
 * PlayerRank               - Rank of the player
 * PlayerTitle              - The player's selected title
 * PortraitMarkup           - Path to the portrait of their last played character (e.g. "img://MyPackage.MyTexture")
 * MedalMarkup              - Path to the image for the player's selected medal (e.g. "img://MyPackage.MyTexture")
 * CurrentProgress          - How far the player is towards gaining their next level
 * TotalProgress            - XP needed for the 
 * ListLeftHeader           - The header for the left hand column (localized string for "Recent Accomplishments")
 * ListRightHeader          - The header for the right hand column (localized string for "# of new unlocks")
 * ListDataProvider         - List that contains information for the summary for the player's recent accomplishments
 *     Label1                   - Short summary of the category (e.g. "15 Collectibles found", "Hamster mutator unlocked")
 *     bShowUpdatedIcon         - TRUE if we want to show the (!) icon next to the summary icon
 * StatDataProvider         - Quick summary of the player's stats
 *     Label                    - Short description of the stat
 *     Value                    - Stat value
 */
function InitializePage_Summary()
{
	local GFxObject DataProvider, SubProvider, SummaryObject, TmpObj;
	local GearPC GPC;
	local GearPRI PRI;
	local GearAward Award;
	local int i, CurrentXP, LastLevelXP, NextLevelXP, CurrentLevel;
	local GearStat CurrStat;
	local GearGameCharacterSummary CharacterSummary;

	// Get the PRI for the player, so we can grab their name, level, etc.
	GPC = GetGearPC();
	PRI = GearPRI(GetPC().PlayerReplicationInfo);

	DataProvider = CreateObject("Object");

	// Set the controller options for this menu
	DataProvider.SetString("ControllerMap", Controller_Close $ Controller_Spacer $ Controller_ViewStats);

	// Populate the provider with the data required by the screen
	DataProvider.SetString("PlayerName", PRI.PlayerName);

	CharacterSummary = class'GearUIDataStore_GameResource'.static.GetCharacterProvider(PRI.PreferredCOGIndex, 'COGs');
	DataProvider.SetString("PortraitMarkup", "img://" $ CharacterSummary.CharacterPortraitLarge);
		
	// Populate the static fields
	DataProvider.SetString("ListLeftHeader", SummaryHeader);

	// Populate the award based fields
	if( GPC.AwardManager != None )
	{
		if (PRI.MedalID != INDEX_NONE)
		{
			Award = GPC.AwardManager.FindAwardByPersistentDataID(PRI.MedalID);
		}
		
		if( Award != None )
		{
			// Set up the medal and title, if available
			DataProvider.SetString("PlayerTitle", Award.GetTitleString(Award.AwardName));
			DataProvider.SetString("MedalMarkup", "img://" $ Award.IconPath);
			DataProvider.SetFloat("MedalRank", Award.MedalRank);
		}
		else
		{
			// No award is available, just add blank text
			DataProvider.SetString("PlayerTitle", Caps(Localize("AwardTitleStrings", "Default", "GearAwards")));
			DataProvider.SetString("MedalMarkup", "img://" $ "UI_Medals.T_Medals_Default");
		}
	}

	// Populate the level progress fields
	CurrentXP = GPC.StatManager.GetStatValueByName('XP');
	CurrentLevel = GPC.StatManager.DetermineLevel(CurrentXP, LastLevelXP, NextLevelXP);
	DataProvider.SetFloat("PlayerRank", CurrentLevel);
 	DataProvider.SetFloat("CurrentProgress", CurrentXP - LastLevelXP);
 	DataProvider.SetFloat("TotalProgress", NextLevelXP - LastLevelXP);

	// Populate the stats for the player
	SubProvider = CreateArray();
	for (i = 0; i < SummaryStatNames.Length; i++)
	{
		CurrStat = GPC.StatManager.GetStatByName(SummaryStatNames[i]);
		if (CurrStat != None)
		{
			SummaryObject = CreateObject("Object");

			// Add the stat info to the object
			SummaryObject.SetString("Label", CurrStat.GetNameString(CurrStat.StatName) $ ":");
			SummaryObject.SetFloat("Value", CurrStat.StatDataByPeriod[GEARPERIOD_Persistent]);

			// Add the object to the data provider
			SubProvider.SetElementObject(i, SummaryObject);
		}
	}
	// Add the stats provider to the master provider
	DataProvider.SetObject("StatDataProvider", SubProvider);

	// Populate the data provider for the summary feed
	SubProvider = CreateArray();
	for (i = 0; i < SummaryStats.Length; i++)
	{
		TmpObj = CreateObject("Object");

		// Set the label of the summary object
		TmpObj.SetString("Label1", SummaryStats[i].StatDescription);
		TmpObj.SetFloat("StatIndex", SummaryStats[i].MPType);

		// Add the summary object to the provider
		SubProvider.SetElementObject(i, TmpObj);
	}
	// Add the summary data provider to the master provider
	DataProvider.SetObject("ListDataProvider", SubProvider);

	// Send the master provider to ActionScript
	ActionScript_Summary_SetDataProvider(DataProvider);
}

/**
 * Called when the player selects a stat type on the summary page.  Opens the appropriate personal stats page
 * 
 * @param   StatIndex   EGearMPType to open the stats for
 */
function Callback_OpenPersonalStats(int StatIndex)
{
	local UIScene_FrontEnd FrontEnd;

	FrontEnd = UIScene_FrontEnd(Outer);
	if( FrontEnd != None )
	{
		FrontEnd.OpenPersonalStats(GetLP(), GetGearPC().PlayerReplicationInfo.UniqueId, None, None, EGearMPTypes(StatIndex));
	}
}

/**
 * Initializes the achievements page of the WJ
 * 
 * Data Provider Summary:
 * -------------------------------------------
 * CurrentProgress          - Number of achievements unlocked so far
 * TotalProgress            - Total number of achievements
 * ControllerMap            - String telling the player what buttons they can use on this menu
 * ListDataProvider         - List of achievements
 *     Name                    - Name of the achievement
 *     Image                   - Path to image for the achievement (e.g. "img://MyPackage.MyTexture")
 *     Info                    - Summary of the achievement
 *     ProgressCurrent         - Number representing the number of steps completed towards earning this achievement
 *     ProgressTotal           - Number representing the total number of steps to earn this achievement
 *     ProgressDataProvider    - Data provider containing details about each step needed towards completing the achievement
 *        label                   - Label for the step (e.g. execution name, weapon name, etc)
 *        bIsComplete             - TRUE if this is completed, and should have a checkmark
 *        bIsLocked               - TRUE if this step has not been performed, and should be grayed out
 *     bIsLocked               - TRUE if this achievement has NOT been unlocked yet
 *     bShowUpdatedIcon        - TRUE if this should have the (!) marker indicating there's something new
 *     bTerminalLeaf           - TRUE, since we want a callback after we've hovered over the items
 */
function InitializePage_Achievements()
{
	local int i, CompletedAchievements;
	local EGearAchievement AchievementId;
	local float CurrentProgress, MaxProgress;
	local array<AchievementDetails> Details;
	local bool bHasCompleted;
	local GearPC GPC;
	local OnlineSubsystem OnlineSub;
	local GFxObject DataProvider, AchievementDP, AchievementObj;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.PlayerInterface.GetAchievements(GetLP().ControllerId, Details, 0);

	GPC = GetGearPC();
	
	// Crete the list provider for all the achievements
	AchievementDP = CreateArray();
	for( i = 0; i < Details.Length; i++ )
	{
		AchievementId = EGearAchievement(Details[i].Id);

		// Create the achievement object
		AchievementObj = CreateObject("Object");

		AchievementObj.SetFloat("Id", AchievementId);
		AchievementObj.SetString("Name", Details[i].AchievementName);
		AchievementObj.SetString("Image", "img://" $ GPC.OnlinePlayerData.AchievementsProvider.GetAchievementIconPathName(AchievementId));
		AchievementObj.SetString("Info", Details[i].Description);
		
		// If this achievement has progress, indicate it here
		if( GPC.GetAchievementProgression(AchievementId, CurrentProgress, MaxProgress) )
		{
			AchievementObj.SetFloat("ProgressCurrent", CurrentProgress);
			AchievementObj.SetFloat("ProgressTotal", MaxProgress);
		}

		// The "progress description" field is now the points label
		AchievementObj.SetString("ProgressDesc", Details[i].GamerPoints @ GamerPointsLabel);
		
		bHasCompleted = Details[i].bWasAchievedOnline || Details[i].bWasAchievedOffline;
		// Keep track of how many achievements have been completed
		if( bHasCompleted )
		{
			CompletedAchievements++;
		}
		AchievementObj.SetBool("bIsLocked", !bHasCompleted);
		AchievementObj.SetBool("bShowUpdatedIcon", GPC.ProfileSettings.IsAchievementMarkedForAttract(AchievementId));
		AchievementObj.SetBool("bTerminalLeaf", TRUE);

		// Add the achievement to the list provider
		AchievementDP.SetElementObject(i, AchievementObj);
	}

	// Create the master data provider
	DataProvider = CreateObject("Object");
	DataProvider.SetObject("ListDataProvider", AchievementDP);
	DataProvider.SetFloat("CurrentProgress", CompletedAchievements);
	DataProvider.SetFloat("TotalProgress", Details.Length);

	// Set the controller options for this menu
	DataProvider.SetString("ControllerMap", Controller_Close);

	// Send the data provider to the screen
	ActionScript_Achievements_SetDataProvider(DataProvider);
}

/**
 * Initializes the first pageof the WJ.  By providing the main data provider encapsulated in Page1DataProvider, the
 * WJ will open up the primary page.  To get back to the secondary page, Initialize_Challenges_Page2 must be called,
 * and encapsulate its data provider in Page2DataProvider
 * 
 * Data Provider Summary:
 * ------------------------------------------- 
 * Page1DataProvider        - Data provider for the first page
 *     CurrentProgress          - Number of challenges completed so far
 *     TotalProgress            - Total number of challenges
 *     ControllerMap            - String that shows the controller button mappings
 *     BottomLeftHeader         - Localized string that should say "Recent"
 *     TopListDataProvider      - Data provider for the challenges categories data provider
 *         Label1                  - Name of the challenge category
 *         Label3                  - String representation of the progress (e.g. "12/25")
 *         bShowUpdatedIcon        - TRUE if we want to show a (!) bing, FALSE if not
 *         CurrentProgress         - Number of completed challenges in this category
 *         TotalProgress           - Total number of challenges in this category
 *     BottomListDataProvider   - Data provider for the recent accomplishments and progress on specific challenges
 *         Label1                  - Label for the line (e.g. "EXECUTION - FLAMETHROWER")
 *         bIsComplete             - TRUE if the label should display as completed, FALSE otherwise
 */
function InitializePage_Challenges_Page1()
{
	local GFxObject PageProvider, ChallengesProvider, ListProvider, ListItem;
	local int GroupIdx;
	local int CurrentProgress;
	local int AllProgress;
	local int CurrentTotal;
	local int AllTotal;
	local GearAwardManager  AwardManager;
	local int PersistentDataId;
	local GearProfileSettings Profile;
	local int RecentIdx;
	local GearAward RecentAward;
	local string RecentString;

	// Get the award manager and profile
	AwardManager = GetGearPC().AwardManager;
	Profile = GetGearPC().ProfileSettings;

	if (AwardManager != None && Profile != None)
	{
		// Create a master provider to store everything in
		ChallengesProvider = CreateObject("Object");

		// Create the data provider for the top list
		ListProvider = CreateArray();
		for (GroupIdx = 0; GroupIdx < ChallengeGroups.Length; GroupIdx++)
		{
			// Create an item for this category
			ListItem = CreateObject("Object");

			CurrentProgress = AwardManager.GetNumAwardsEarnedByType(ChallengeGroups[GroupIdx].GroupType);
			AllProgress += CurrentProgress;
			CurrentTotal = AwardManager.GetNumTotalAwardsByType(ChallengeGroups[GroupIdx].GroupType);
			AllTotal += CurrentTotal;

			ListItem.SetString("Label1", ChallengeGroups[GroupIdx].GroupDisplayName);
			ListItem.SetString("Label3", CurrentProgress $ "/" $ CurrentTotal);
			ListItem.SetFloat("CurrentProgress", CurrentProgress);
			ListItem.SetFloat("TotalProgress", CurrentTotal);
			ListItem.SetBool("bShowUpdatedIcon", (AwardManager.GetNumAwardsNeedingViewedByType(ChallengeGroups[GroupIdx].GroupType) > 0) ? true : false);

			// Add the item to the list provider
			ListProvider.SetElementObject(GroupIdx, ListItem);
		}
		// Add the top list provider to the master provider
		ChallengesProvider.SetObject("TopListDataProvider", ListProvider);

		// Create the data provider for the bottom list (recent activity)
		ListProvider = CreateArray();
		for (RecentIdx = 0; RecentIdx < 5; RecentIdx++)
		{
			PersistentDataId = Profile.GetRecentlyEarnedChallenge(RecentIdx);
			// Zero is invalid
			if (PersistentDataId > 0)
			{
				RecentAward = AwardManager.FindAwardByPersistentDataID(PersistentDataId);
				if (RecentAward != None)
				{
					// Find the corresponding group in the challenge list
					GroupIdx = ChallengeGroups.Find('GroupType', RecentAward.AwardType);
					if (GroupIdx != INDEX_NONE)
					{
						// Create an item for the entry
						ListItem = CreateObject("Object");
						RecentString = Repl(ChallengeGroups[GroupIdx].EarnedSentence, "`AWARDNAME`", RecentAward.GetNameString(RecentAward.AwardName));
						ListItem.SetString("Label1", RecentString);
						ListItem.SetBool("bIsComplete", true);
						ListProvider.SetElementObject(GroupIdx, ListItem);
					}
				}
			}
		}
		// Add the bottom list provider to the master provider
		ChallengesProvider.SetObject("BottomListDataProvider", ListProvider);

		// Fill out the remaining info for the challenges provider
		ChallengesProvider.SetFloat("CurrentProgress", AllProgress);
		ChallengesProvider.SetFloat("TotalProgress", AllTotal);
		ChallengesProvider.SetString("BottomLeftHeader", ChallengesRecentHeader);

		// Set the controller options for this menu
		ChallengesProvider.SetString("ControllerMap", Controller_Close $ Controller_Spacer $ Controller_ViewSection_Challenges);

		// Add the challenges provider to the page provider
		PageProvider = CreateObject("Object");
		PageProvider.SetObject("Page1DataProvider", ChallengesProvider);

		// Send the data over to ActionScript
		ActionScript_Challenges_SetDataProvider(PageProvider);
	}
}

/**
 * Initialized the subpage of the challenges page of the War Journal, which is category specific.  Note
 * That the data provider is encapsulated in Page2DataProvider, which will tell the WJ to open up the 
 * subpage.  To get back to the main page, InitializePage_Challenges_Page1() should be called.
 * 
 * Data Provider Summary:
 * -------------------------------------------
 * Page2DataProvider
 *     TopLeftTitle             - Name of the challenge category this page is showing info for
 *     CurrentProgress          - Number of challenges in this category completed so far
 *     TotalProgress            - Total number of challenges in this category
 *     ControllerMap            - String that shows the controller button mappings
 *     TopListDataProvider      - List of challenges in this category
 *         Label1                   - Name of the specific challenge
 *         Label3                   - String representing percent completion for this challenge (e.g. "3/10")
 *         Desc                     - Description of this challenge
 *         SubList                  - Sublist of the requirements for this challenge
 *             label                    - Description of the requirement for this challenge (e.g. "CURB STOMP" for an Executions challenge)
 *             bIsComplete              - TRUE if this component of the challenge has been completed and should show a checkmark, FALSE otherwise
 *             bIsLocked                - TRUE if this challenge component is locked, FALSE if not
 *         bShowUpdatedIcon         - TRUE if this item should show and updated (!) bing, FALSE if not
 *         bTerminalLeaf            - TRUE, since we want a callback when you hover over a challenge on this page
 *         CurrentProgress          - Number of steps towards completing this specific challenge that have been completed
 *         TotalProgress            - Number of total steps in this challenge
 *         RibbonImage              - Path to a ribbon image for this item (e.g. "img://MyPackage.MyTexture").  CurrentProgress / TotalProgress must be undefined for this to have an effect
 *     
 * @param   ChallengeItemIndex  Index of the category to display detailed information for
 */
function InitializePage_Challenges_Page2(int ChallengeItemIndex)
{
	local GFxObject ChallengesProvider, ListProvider, ListItem, SublistProvider, SublistItem;
	local int CurrentProgress, AllProgress;
	local bool bEarned, bIsComplete, bNeedsSorting;
	local GearAwardManager  AwardManager;
	local int ChallengeIdx, GroupIdx;
	local GearAward CurrAward;
	local int NumAwards, NumRequirements, RequireIdx;
	local int Numerator, Denominator;
	local int EarnCount, i;
	local string RequirementString;
	local GearStat CurrStat;
	local array<int> SortedKeys;
	local array<GFxObject> SortedObjects;

	AwardManager = GetGearPC().AwardManager;
	if (AwardManager != None &&
		ChallengeItemIndex >= 0 && ChallengeItemIndex < ChallengeGroups.Length)
	{
		// Create a master provider to put everything in
		ChallengesProvider = CreateObject("Object");
		// Create a challenges provider that we can fill out
		ListProvider = CreateArray();

		// Iterate over all awards of this type
		GroupIdx = ChallengeGroups[ChallengeItemIndex].GroupType;
		NumAwards = AwardManager.CachedGroupData[GroupIdx].AwardIndexes.Length;
		bNeedsSorting = (GroupIdx == GEARAWARDTYPE_Ribbon); // Only ribbons need sorting
		for (ChallengeIdx = 0; ChallengeIdx < NumAwards; ChallengeIdx++)
		{
			// Create an entry for this challenge
			ListItem = CreateObject("Object");

			// Set the data for this award
			CurrAward = AwardManager.Awards[AwardManager.CachedGroupData[GroupIdx].AwardIndexes[ChallengeIdx]];
			ListItem.SetString("Label1", CurrAward.GetNameString(CurrAward.AwardName));
			ListItem.SetString("Desc", CurrAward.GetDescString(CurrAward.AwardName));
			ListItem.SetBool("bShowUpdatedIcon", AwardManager.AwardNeedsViewed(CurrAward.PersistentDataID));
			ListItem.SetBool("bTerminalLeaf", TRUE);

			// See if we've earned this award
			bEarned = (CurrAward.GetNumTimesEarned() > 0) ? true : false;
			if (bEarned)
			{
				// Count the total earned awards
				AllProgress++;
			}

			// Special Case:  Ribbons
			// Ribbons don't have sub-requirements, just a single condition, so we can treat them differently
			if( GroupIdx == GEARAWARDTYPE_Ribbon )
			{
				EarnCount = CurrAward.GetNumTimesEarned();

				// Ribbons are a special case, show the ribbon where the progress bar would be, and change the label to the earned count
				ListItem.SetString("RibbonImage", "img://" $ CurrAward.IconPath);
				ListItem.SetString("Label3", "X" @ EarnCount);

				// Add a null array as a placeholder to keep AS happy
				ListItem.SetObject("SubList", CreateArray());

				// Figure out where this ribbon belongs
				for(i = 0; i < SortedKeys.Length; i++)
				{
					if( EarnCount > SortedKeys[i] )
					{
						// We've found where we belong!
						break;
					}
				}

				// Insert the object into the sorted array
				SortedKeys.InsertItem(i, EarnCount);
				SortedObjects.InsertItem(i, ListItem);
			}
			// Normal Case:  Get the sub-requirements
			else
			{
				// Create a list of requirements for this challenges
				CurrentProgress = 0;
				NumRequirements = CurrAward.StatsToMonitor.Length;
				SublistProvider = CreateArray();

				for (RequireIdx = 0; RequireIdx < NumRequirements; RequireIdx++)
				{
 					bIsComplete = CurrAward.GetStatProgress(RequireIdx, Numerator, Denominator, true);
					SublistItem = CreateObject("Object");
					// If complete, make sure to make the numerator equal the denominator in case of repeating stats
					if (bIsComplete)
					{
						Numerator = Denominator;
					}

					// Build the requirement string
					CurrStat = CurrAward.StatsToMonitor[RequireIdx].Stat;
					if (CurrStat != None)
					{
						RequirementString = ProgressRequireString;
						RequirementString = Repl(RequirementString, "`STAT`", CurrStat.GetNameString(CurrStat.StatName));
						RequirementString = Repl(RequirementString, "`NUM`", string(Numerator));
						RequirementString = Repl(RequirementString, "`DEN`", string(Denominator));
						//RequirementString = Repl(RequireString, "`STAT`", CurrStat.GetNameString(CurrStat.StatName));
					}

					SublistItem.SetString("label", RequirementString);
					SublistItem.SetBool("bIsComplete", bIsComplete);
					SublistItem.SetBool("bIsLocked", !bIsComplete);
					if (bIsComplete)
					{
						CurrentProgress++;
					}

					SublistProvider.SetElementObject(RequireIdx, SublistItem);
				}

				ListItem.SetObject("SubList", SublistProvider);
			
				// Fill out progress for the challenge
				ListItem.SetFloat("CurrentProgress", CurrentProgress);
				ListItem.SetFloat("TotalProgress", NumRequirements);
				ListItem.SetString("Label3", CurrentProgress $ "/" $ NumRequirements);
			}

			
			// Add the element to the list, if it didn't need to be sorted
			if( !bNeedsSorting )
			{
				ListProvider.SetElementObject(ChallengeIdx, ListItem);
			}
		}

		// If we did sorting, add the elements to the data provider now
		if( bNeedsSorting )
		{
			for( i = 0; i < SortedObjects.Length; i++ )
			{
				ListProvider.SetElementObject(i, SortedObjects[i]);
			}
		}

		// Add the list to the main provider
		ChallengesProvider.SetObject("TopListDataProvider", ListProvider);

		// Fill out the remaining info for the challenges provider
		ChallengesProvider.SetFloat("CurrentProgress", AllProgress);
		ChallengesProvider.SetFloat("TotalProgress", NumAwards);

		// Set the title of the challenges category this page represents
		ChallengesProvider.SetString("TopLeftTitle", ChallengeGroups[ChallengeItemIndex].GroupDisplayName);
		
		// Set the controller options for this menu
		ChallengesProvider.SetString("ControllerMap", Controller_Back);

		// If this is the ribbons page, tell the war journal to use the alternate page, with the longer list
		ChallengesProvider.SetBool("bUseAlternatePage", GroupIdx == GEARAWARDTYPE_Ribbon);

		// Send the data provider to actionscript, which will flip the page
		ActionScript_Challenges_SetDataForPage2(ChallengesProvider);
	}
}

/**
 * Initializes the Collectibles page of the WJ.  By providing the main data provider encapsulated in Page1DataProvider,
 * the WJ will open up the primary page.  To get back to the secondary page, Initialize_Collectibles_Page2 must be called,
 * and encapsulate its data provider in Page2DataProvider
 * 
 * Data Provider Summary:
 * -------------------------------------------
 * Page1DataProvider        - Data provider that contains the data for the first page.
 *     CurrentProgress          - Number of challenges in this category completed so far
 *     TotalProgress            - Total number of challenges in this category
 *     ControllerMap            - String that shows the controller button mappings
 *     BottomLeftHeader         - Localized string to title the second list with (i.e. "RECENT")
 *     TopListDataProvider      - Data provider for the act categories for collectibles (e.g. "ACT I: ACT NAME")
 *         Label1                   - The name of the act
 *         Label3                   - String representing how many collectibles have been found in this act (e.g. "25/50")
 *         CurrentProgress          - Number of collectibles found in this act
 *         TotalProgress            - Number of total collectibles in this act
 *         bShowUpdatedIcon         - TRUE if we should show a (!) bing, FALSE if not
 *     BottomListDataProvider   - Data provider for the list of the most recent collectibles found
 *         Label1                   - Name of the recently found collectible
 *         bIsComplete              - TRUE if we should show a checkmark, which we always should, in this case
 * 
 */
function InitializePage_Collectibles_Page1()
{
	local GFxObject PageProvider, CollectiblesProvider, ListProvider, ListItem;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> ActProviders;
	local GearCampaignActData ActData;
	local int ActIdx;
	local int DiscIdx;
	local GearProfileSettings Profile;
	local int NumFoundInAct;
	local int NumInAct;
	local int NumFoundTotal;
	local int TotalCount;
	local EGearDiscoverableType DiscType;
	local String DiscName;
	local String DiscDetails;
	local byte ShowBang;

	// Create a provider for the collectibles
	CollectiblesProvider = CreateObject("Object");

	// Get the act providers
	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	GameResourceDS.GetResourceProviders('Acts', ActProviders);
	// Get the profile of this player
	Profile = GetGearPC().ProfileSettings;

	// Create a list of acts
	ListProvider = CreateArray();
	for (ActIdx = 0; ActIdx < ActProviders.Length; ActIdx++)
	{
		// Get this act provider
		ActData = GearCampaignActData(ActProviders[ActIdx]);
		// Get the cached data
		GetDiscoverableData(ActIdx, NumFoundInAct, NumInAct, ShowBang);
		// Add to the total
		NumFoundTotal += NumFoundInAct;
		TotalCount += NumInAct;

		// Create an entry for this act
		ListItem = CreateObject("Object");
		ListItem.SetString("Label1", ActData.DisplayName);
		ListItem.SetString("Label3", NumFoundInAct $ "/" $ NumInAct);
		ListItem.SetFloat("CurrentProgress", NumFoundInAct);
		ListItem.SetFloat("TotalProgress", NumInAct);
		ListItem.SetBool("bShowUpdatedIcon", (ShowBang == 1) ? true : false);
		// Add the act to the list
		ListProvider.SetElementObject(ActIdx, ListItem);
	}
	CollectiblesProvider.SetObject("TopListDataProvider", ListProvider);

	// Create a list of recently found collectibles
	ListProvider = CreateArray();
	for (DiscIdx = 0; DiscIdx < 5; DiscIdx++)
	{
		DiscType = Profile.GetRecentlyFoundDiscoverable(DiscIdx);
		if (DiscType != InvalidDiscoverable)
		{
			GameResourceDS.GetDiscoverableDisplayStrings(DiscType, DiscName, DiscDetails);
			ListItem = CreateObject("Object");
			ListItem.SetString("Label1", DiscName);
			ListItem.SetBool("bIsComplete", TRUE);
			ListProvider.SetElementObject(DiscIdx, ListItem);
		}
	}
	CollectiblesProvider.SetObject("BottomListDataProvider", ListProvider);

	// Set up the remaining fields of the data provider
	CollectiblesProvider.SetString("BottomLeftHeader", CollectiblesRecentHeader);
	CollectiblesProvider.SetFloat("CurrentProgress", NumFoundTotal);
	CollectiblesProvider.SetFloat("TotalProgress", TotalCount);

	// Set the controller options for this menu
	CollectiblesProvider.SetString("ControllerMap", Controller_Close $ Controller_Spacer $ Controller_ViewSection_Collectibles);

	// Create a master provider for page 1
	PageProvider = CreateObject("Object");
	PageProvider.SetObject("Page1DataProvider", CollectiblesProvider);

	// Send the page data provider to actionscript
	ActionScript_Collectibles_SetDataProvider(PageProvider);
}

/** Runs through all of the discoverables and marks whether they've been found and should have bangs */
function CacheDiscoverableData()
{
	local int DiscIdx;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> ActProviders;
	local GearCampaignActData ActData;
	local GearProfileSettings Profile;
	local int ActIdx;
	local WJDiscoverData DiscData;

	// Get the act providers
	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	GameResourceDS.GetResourceProviders('Acts', ActProviders);

	// Wipe our cached data
	DiscoverData.Length = 0;

	// Get the profile of this player
	Profile = GetGearPC().ProfileSettings;
	if (Profile != None)
	{
		for (ActIdx = 0; ActIdx < ActProviders.Length; ActIdx++)
		{
			// Get this act provider
			ActData = GearCampaignActData(ActProviders[ActIdx]);

			// Loop through the discoverables and set the data for the cached list
			for (DiscIdx = 0; DiscIdx < ActData.Collectables.Length; DiscIdx++)
			{
				DiscData.ActIdx = ActIdx;
				DiscData.Type = ActData.Collectables[DiscIdx].CollectableId;
				DiscData.bFound = Profile.HasDiscoverableBeenFound(DiscData.Type);
				if (DiscData.bFound)
				{
					DiscData.bNeedsViewed = Profile.IsDiscoverableMarkedForAttract(DiscData.Type);
				}
				else
				{
					DiscData.bNeedsViewed = false;
				}

				DiscoverData.AddItem(DiscData);
			}
		}
	}
}

/**
 * Returns the total number of discoverable found in a given act and whether it needs viewed
 *
 * @param ActIdx - The act we care about
 * @out param NumFound - how many we've found
 * @out param NumTotal - total number for this act
 * @out param bNeedViewed - whether a bang should be displayed for this act
 */
function GetDiscoverableData(int ActIdx, out int NumFound, out int NumTotal, out byte NeedsViewed)
{
	local int DiscIdx;

	NumFound = 0;
	NumTotal = 0;
	NeedsViewed = 0;

	for (DiscIdx = 0; DiscIdx < DiscoverData.Length; DiscIdx++)
	{
		if (DiscoverData[DiscIdx].ActIdx == ActIdx)
		{
			NumTotal++;

			if (DiscoverData[DiscIdx].bFound)
			{
				NumFound++;
			}

			if (DiscoverData[DiscIdx].bNeedsViewed)
			{
				NeedsViewed = 1;
			}
		}
	}
}

/** Returns the number of discoverables needing viewed */
function int NumDiscoverablesNeedingViewed()
{
	local int DiscIdx;
	local int Count;

	for (DiscIdx = 0; DiscIdx < DiscoverData.Length; DiscIdx++)
	{
		if (DiscoverData[DiscIdx].bNeedsViewed)
		{
			Count++;
		}
	}
	return Count;
}

/** Handles a discoverable that no longer needs to be viewed */
function HandleDiscoverableViewed(int ItemIdx)
{
	local int Idx;
	local int Count;
	local GearProfileSettings Profile;

	Profile = GetGearPC().ProfileSettings;

	if (Profile != None)
	{
		for (Idx = 0; Idx < DiscoverData.Length; Idx++)
		{
			if (DiscoverData[Idx].ActIdx == CurrActIdx)
			{
				if (ItemIdx == Count)
				{
					DiscoverData[Idx].bNeedsViewed = false;
					Profile.MarkDiscoverableAsViewed(DiscoverData[Idx].Type);
					return;
				}
				Count++;
			}
		}
	}
}

/*
 * Initialized the act subpage of the collectibles page of the War Journal, which is category specific.  Note
 * That the data provider is encapsulated in Page2DataProvider, which will tell the WJ to open up the 
 * subpage.  To get back to the main page, InitializePage_Collectibles_Page1() should be called.
 * 
 * Page2DataProvider        - Data provider that contains the data for the second page.
 *     ControllerMap             - String that shows the controller button mappings
 *     TopLeftHeader             - Name of the act that this is a list of collectibles for
 *     ListDataProvider          - List containing all the collectibles for this act
 *         Name                      - Name of the collectible
 *         Image                     - Path to the image for a collectible (e.g. "img://MyPackage.MyTexture")
 *         Info                      - Info string for the collectible (e.g. type, short desc, whatever)
 *         Desc                      - Description or story of the collectible
 *         bIsLocked                 - TRUE if this collectible is locked (unfound), FALSE otherwise
 *         bShowUpdatedIcon          - TRUE if this collectible hasn't been viewed in the WJ, and should have a (!) bing, FALSE otherwise
 *         bTerminalLeaf             - TRUE since we want a callback when the player hovers over the collectible item
 */ 
function InitializePage_Collectibles_Page2(int ActIdx)
{
	local GFxObject PageProvider, CollectiblesProvider, ListProvider, ListItem;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> ActProviders;
	local GearCampaignActData ActData;
	local int Idx;
	local int DataIdx;

	// Get the act providers
	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	GameResourceDS.GetResourceProviders('Acts', ActProviders);
	ActData = GearCampaignActData(ActProviders[ActIdx]);

	if (ActData != None)
	{
		// Set the current act index so we know which act to look at when a collectible is selected
		CurrActIdx = ActIdx;
		// Create a collectibles data provider
		CollectiblesProvider = CreateObject("Object");
		// Create and populate the list of collectibles for this act
		ListProvider = CreateArray();

		// Loop through all the collectibles in the act list
		for (Idx = 0; Idx < ActData.Collectables.Length; Idx++)
		{
			DataIdx = DiscoverData.Find('Type', ActData.Collectables[Idx].CollectableId);
			if (DataIdx != INDEX_NONE)
			{
				// Create a collectible item to add to the provider list
				ListItem = CreateObject("Object");

				ListItem.SetString("Name", ActData.Collectables[Idx].CollectableName);
				ListItem.SetString("Image", "img://" $ ActData.Collectables[Idx].UnlockedIcon_Markup);
				ListItem.SetString("Info", ActData.Collectables[Idx].ContainingChapterProvider.DisplayName);
				ListItem.SetString("Desc", ActData.Collectables[Idx].CollectableDetails);
				ListItem.SetBool("bIsLocked", !DiscoverData[DataIdx].bFound);
				ListItem.SetBool("bShowUpdatedIcon", DiscoverData[DataIdx].bNeedsViewed);
				ListItem.SetBool("bTerminalLeaf", TRUE);

				// Add the collectible to the list
				ListProvider.SetElementObject(Idx, ListItem);
			}
		}
		CollectiblesProvider.SetObject("ListDataProvider", ListProvider);

		// Fill in the rest of the data for the page
		CollectiblesProvider.SetString("TopLeftHeader", ActData.DisplayName);

		// Set the controller options for this menu
		CollectiblesProvider.SetString("ControllerMap", Controller_Back $ Controller_Spacer $ Controller_ViewCollectible);

		// Create a page data provider
		PageProvider = CreateObject("Object");
		PageProvider.SetObject("Page2DataProvider", CollectiblesProvider);

		// Send the data provider to ActionScript
		ActionScript_Collectibles_SetDataProvider(PageProvider);
	}
}

/**
 * Initializes the horde summary page of the WJ
 * 
 * Data Provider Summary:
 * -------------------------------------------
 * CurrentProgress          - Number of medals earned so far
 * TotalProgress            - Total number of medals
 * ControllerMap            - String that shows the controller button mappings
 * TopListDataProvider      - List of categories for the top list of the Horde page
 *     Label1                  - Category name
 *     Label2                  - Current level of the player in this category
 *     Label3                  - Progress towards the next level
 *     Info                    - More detailed description of progress towards the next level (e.g. "4/8 arm rips completed")
 *     CurrentProgress         - Current number of steps completed towards the next level
 *     TotalProgress           - Total number of steps that need to be completed to get the next level
 *     bShowUpdatedIcon        - TRUE if we should show a (!) bing, FALSE otherwise
 *     bIsLocked               - TRUE if this category is locked and should be inaccessable, FALSE if otherwise
 *     SubList                 - List that provides the details for the bottom list's level progression view.  Should have one entry for each level
 *         Name                   - Name of the level
 *         Image                  - Path to an image icon for this level (e.g. "img://MyPackage.MyTexture")
 *         Info                   - More specific info about this level
 *         Label                  - Label for the icon (e.g. "Lvl 2")
 *         Desc                   - Description of the challenge to meet this level
 *         ProgressCurrent        - Number of steps toward the next level completed
 *         ProgressTotal          - Total number of steps toward the next level
 *         bIsLocked              - TRUE if the level is locked, FALSE otherwise
 *         bShowUpdatedIcon       - TRUE if we should show the updated (!) bing, FALSE otherwise
 *         bTerminalLeaf          - TRUE, since we want a callback when the player hovers over a level
 */
function InitializePage_Horde()
{
	local GFxObject HordeDP, TopListDP, TopListItem, SublistDP, SublistItem;
	local int DataIdx;
	local int ProvIdx;
	local int LevelIdx;
	local GearAwardManager AwardMgr;
	local GearAward CurrAward;
	local int Numerator;
	local int Denominator;
	local byte NeedsViewed;
	local byte SectionLocked;
	local int NumLevels;
	local int CurrLevel;
	local GearStat Stat;
	local bool bFoundFirstLockedStage;

	// Create an element to send over the 
	TopListDP = CreateArray();
	ProvIdx = 0;
	AwardMgr = GetGearPC().AwardManager;

	for (DataIdx = 0; DataIdx < HordeGroupData.Length; DataIdx++)
	{
		NeedsViewed = 0;
		SectionLocked = 0;
		CurrLevel = INDEX_NONE;

		if (HordeGroupData[DataIdx].bActive)
		{
			// Returns whether this section is locked or not
			GetHordeSectionAccessData(EWJHordeGroup(DataIdx), SectionLocked, NeedsViewed);

			// Create a new list item element
			TopListItem = CreateObject("Object");

			// Create the level info data provider
			SublistDP = CreateArray();

			NumLevels = HordeGroupData[DataIdx].AwardNames.Length;

			bFoundFirstLockedStage = FALSE;
			for (LevelIdx = 0; LevelIdx < NumLevels; LevelIdx++)
			{
				CurrAward = AwardMgr.GetAwardByName(HordeGroupData[DataIdx].AwardNames[LevelIdx]);
				if (CurrAward != None)
				{
					// Create a new Horde level info
					SublistItem = CreateObject("Object");

					if (CurrAward.GetStatProgress(0, Numerator, Denominator))
					{
						// Determine if this is the currently worked on level
						if (LevelIdx == NumLevels - 1)
						{
							CurrLevel = LevelIdx;
						}
					}
					else
					{
						// Determine if this is the currently worked on level
						if (CurrLevel == INDEX_NONE)
						{
							CurrLevel = LevelIdx;
						}
					}

					if (AwardMgr.AwardNeedsViewed(CurrAward.PersistentDataID))
					{
						NeedsViewed = 1;
						SublistItem.SetBool("bShowUpdatedIcon", true);
					}
					else
					{
						SublistItem.SetBool("bShowUpdatedIcon", false);
					}

					SublistItem.SetString("Name", CurrAward.GetNameString(CurrAward.AwardName));
					SublistItem.SetString("Image", "img://" $ CurrAward.IconPath);
					if (Denominator > 0)
					{
						Stat = CurrAward.StatsToMonitor[0].Stat;
						SublistItem.SetString("Info", Numerator $ "/" $ Denominator @ Stat.GetDescString(Stat.StatName));
					}
					else
					{
						SublistItem.SetString("Info", "");
					}
					SublistItem.SetString("Label", HordeLevelStringShort @ string(LevelIdx + 1));
					SublistItem.SetString("Desc", CurrAward.GetDescString(CurrAward.AwardName));

					// If this is the first stage that should be locked, send progress bar data
					if( !bFoundFirstLockedStage && (Numerator < Denominator) )
					{
						SublistItem.SetFloat("ProgressCurrent", Numerator);
						SublistItem.SetFloat("ProgressTotal", Denominator);
						bFoundFirstLockedStage = TRUE;
					}
					
					SublistItem.SetBool("bIsLocked", Numerator < Denominator);
					SublistItem.SetBool("bTerminalLeaf", TRUE);

					// Add the level to the data provider
					SublistDP.SetElementObject(LevelIdx, SublistItem);
				}
			}

			TopListItem.SetString("Label1", HordeGroupData[DataIdx].FortTitle);
			TopListItem.SetBool("bShowUpdatedIcon", (NeedsViewed == 1) ? true : false);
			TopListItem.SetBool("bIsLocked", (SectionLocked == 1) ? true : false);

			TopListItem.SetObject("SubList", SublistDP);

			// Add the category to the list provider
			TopListDP.SetElementObject(ProvIdx, TopListItem);

			// Increment the current index in the data provider
			ProvIdx++;
		}
	}

	// Create the master data provider, and fill it out
	HordeDP = CreateObject("Object");
	HordeDP.SetObject("TopListDataProvider", TopListDP);

	// Set the controller options for this menu
	HordeDP.SetString("ControllerMap", Controller_Close);

	// Send the data provider over to ActionScript to create the page
	ActionScript_Horde_SetDataProvider(HordeDP);
}

/**
 * Returns whether a section of the horde screen is locked and if it needs viewed
 * @param GroupType - the section of the horde section we want know about
 * @out param bIsLocked - whether this horde group is locked or not
 * @out param bNeedsViewed - whether this 
 */
final function GetHordeSectionAccessData(EWJHordeGroup GroupType, out byte IsLocked, out byte NeedsViewed)
{
	local GearAward Award;
	local GearAwardManager AwardMgr;
	local int Numerator;
	local int Denominator;
	local Name UnlockName;

	AwardMgr = GetGearPC().AwardManager;
	UnlockName = HordeGroupData[GroupType].UnlockAwardName;

	// Unlocked by default if the unlock name is none
	if (UnlockName == '')
	{
		IsLocked = 0;
		return;
	}

	Award = AwardMgr.GetAwardByName(UnlockName);
	if (Award != None)
	{
		IsLocked = (!Award.GetStatProgress(0, Numerator, Denominator, true)) ? 1 : 0;
		NeedsViewed = AwardMgr.AwardNeedsViewed(Award.PersistentDataID) ? 1 : 0;
	}
}

/**
 * Initializes the medals page of the WJ
 * 
 * Data Provider Summary:
 * -------------------------------------------
 * CurrentProgress          - Number of medals earned so far
 * TotalProgress            - Total number of medals
 * ControllerMap            - String that shows the controller button mappings
 * ListDataProvider         - List of medals
 *     Name                    - Name of the medal
 *     Image                   - Path to the image for the medal (e.g. "img://MyPackage.MyTexture")
 *     Title                   - Title associated with this medal
 *     Desc                    - Detailed description of the medal
 *     ProgressCurrent         - Progress towards the medal
 *     ProgressTotal           - Number representing the total number of steps to earn this achievement
 *     MedalCount              - Number of times this medal has been earned
 *     StarsCurrent            - Number of stars to display for this medal
 *     bIsLocked               - TRUE if this medal is locked, FALSE otherwise
 *     bShowUpdatedIcon        - TRUE if we want to show a new (!) bang for this, FALSE otherwise
 *     bTerminalLeaf           - Always TRUE since we if we want to receive a callback when a medal is viewed, so we cam mark it in the profile
 */
function InitializePage_Medals()
{
	local GFxObject DataProvider, MedalsDP, MedalObj;
	local int i, CurrentProgress, TotalProgress, AwardProgress, AwardProgressTotal;

	local GearAwardManager  AwardManager;
	local GearAward CurrentAward;
	local name BestAwardName;
	local bool bShouldBeShown;
	local bool bNeedsViewed;
	local int NameIdx;
	local int PrestigeValue;
	local int LevelValue;

	// Get the award manager, so we can iterate over all awards
	AwardManager = GetGearPC().AwardManager;
	if( AwardManager != None )
	{
		// Create the list provider for all the medals
		MedalsDP = CreateArray();

		// Iterate over all the medals, and populate the list
		for( i = 0; i < AwardManager.MedalDisplayOrder.Length; i++ )
		{
			// Determine if any of the medals in this display order need to show the "needs viewed" icon
			bNeedsViewed = false;
			for (NameIdx = 0; NameIdx < AwardManager.MedalDisplayOrder[i].AwardNames.Length; NameIdx++)
			{
				CurrentAward = AwardManager.GetAwardByName(AwardManager.MedalDisplayOrder[i].AwardNames[NameIdx]);
				if (AwardManager.AwardNeedsViewed(CurrentAward.PersistentDataID))
				{
					bNeedsViewed = true;
					break;
				}
			}

			// Get the best award for the display order category
			BestAwardName = '';
			bShouldBeShown = AwardManager.GetBestMedalForPosition(i, BestAwardName);
			CurrentAward = AwardManager.GetAwardByName(BestAwardName);

			// We only care about medals
			if( CurrentAward != None )
			{
				// Only increment the current progress if we've earned the medal
				if( bShouldBeShown )
				{
					CurrentProgress++;
				}

				MedalObj = CreateObject("Object");

				// Populate the data for this award
				MedalObj.SetFloat("Id", CurrentAward.PersistentDataID);
				MedalObj.SetString("Name", Caps(CurrentAward.GetNameString(CurrentAward.AwardName)));
				MedalObj.SetString("Image", "img://" $ CurrentAward.IconPath);
				MedalObj.SetFloat("MedalRank", CurrentAward.MedalRank);
				MedalObj.SetString("Title", Caps(CurrentAward.GetTitleString(CurrentAward.AwardName)));
				MedalObj.SetString("Desc", CurrentAward.GetLongDescString(CurrentAward.AwardName));

				// If progress is defined for this award, then tell the data provider
				AwardManager.GetProgressTowardsNextLevel(i, AwardProgress, AwardProgressTotal);
				if (AwardProgressTotal > 0)
				{
					MedalObj.SetFloat("ProgressCurrent", AwardProgress);
					MedalObj.SetFloat("ProgressTotal", AwardProgressTotal);
				}

				// Set the prestige and medal level if it's been unlocked
				if (bShouldBeShown)
				{
					GetMedalPrestigeValues(i, BestAwardName, PrestigeValue, LevelValue);
					// We only want to show prestige if we have gone through twice
					if (PrestigeValue <= 1)
					{
						PrestigeValue = 0;
					}
				}
				else
				{
					PrestigeValue = 0;
					LevelValue = 0;
				}

				MedalObj.SetFloat("MedalCount", PrestigeValue);
				MedalObj.SetFloat("StarsCurrent", LevelValue);
				MedalObj.SetBool("bIsLocked", !bShouldBeShown);
				MedalObj.SetBool("bShowUpdatedIcon", bNeedsViewed);
				MedalObj.SetBool("bTerminalLeaf", TRUE);  // Medals are always terminal leafs, since you can't drill in for more info

				// Add this medal to the data provider, and increment the total progress, which acts as our counter
				MedalsDP.SetElementObject(TotalProgress++, MedalObj);
			}
		}
	}
	
	// Create the data provider for the page
	DataProvider = CreateObject("Object");
	DataProvider.SetFloat("CurrentProgress", CurrentProgress);
	DataProvider.SetFloat("TotalProgress", TotalProgress);
	DataProvider.SetObject("ListDataProvider", MedalsDP);

	// Set the controller options for this menu
	DataProvider.SetString("ControllerMap", Controller_Close);

	// Send it to ActionScript to populate the page
	ActionScript_Medals_SetDataProvider(DataProvider);
}

/**
 * Function that determines prestige level and medal color (bronze, silver, gold, epic) of a given medal
 *
 * @param MedalIdx - the index into the MedalDisplayOrder array of the AwardManager
 * @param BestAwardName - the name of the highest award earned for this grouping
 * @out param PrestigeValue - number of times the player prestiged this award
 * @out param LevelValue - the color/level of this award (bronze, silver, gold, epic)
 *
 * @return - whether this is a medal that can be prestiged or leveled
 */
final function bool GetMedalPrestigeValues(int MedalIdx, Name BestAwardName, out int PrestigeValue, out int LevelValue)
{
	local GearAwardManager AwardManager;
	local int NameIdx;

	// Wipe the out params just in case
	LevelValue = 0;
	PrestigeValue = 0;

	AwardManager = GetGearPC().AwardManager;
	if (AwardManager != None)
	{
		if (AwardManager.MedalDisplayOrder[MedalIdx].AwardNames.Length > 1)
		{
			// Determine what level we have earned (bronze, silver, gold or epic)
			for (NameIdx = 0; NameIdx < AwardManager.MedalDisplayOrder[MedalIdx].AwardNames.Length; NameIdx++)
			{
				if (BestAwardName == AwardManager.MedalDisplayOrder[MedalIdx].AwardNames[NameIdx])
				{
					break;
				}
			}

			// If this is the first award in the list we can determine from it which prestige level we are currently at
			if (NameIdx == 0)
			{
				PrestigeValue = AwardManager.GetAwardEarnedCountByName(BestAwardName);
				LevelValue = AwardManager.MedalDisplayOrder[MedalIdx].AwardNames.Length;
			}
			else
			{
				// Since the awards are in order of importance we can just subtract the index from the total
				// to determine the level value.
				LevelValue = AwardManager.MedalDisplayOrder[MedalIdx].AwardNames.Length - NameIdx;
			}

			return true;
		}
	}

	return false;
}

/**
 * Initializes the category selection page of leaderboards
 * 
 * Data Provider Summary:
 * -------------------------------------------
 * VersusTitle              - Category title for versus leaderboards
 * VersusMatchCount         - String indicating the number of matches played for versus
 * HordeTitle               - Category title for horde leaderboards
 * HordeMatchCount          - String indicating the number of matches played for horde
 * SiegeTitle               - Category title for siege leaderboards
 * SiegeMatchCount          - String indicating the number of matches played for siege
 * ArcadeTitle              - Category title for the arcade leaderboards
 * ArcadeMatchCount         - String indicating the number of chapters played for arcade
 * ListDataProvider         - Data provider that contains an object entry for each category in the leaderboards
 *     Label1                   - Localized string 
 * ControllerMap            - String that shows the controller button mappings
 */
function InitializePage_Leaderboards()
{
	local GFxObject DataProvider, LeaderboardCategories, TmpObj;
	local GearStatManager StatManager;
	local int i;

	DataProvider = CreateObject("Object");

	// Set up the loading screen text
	DataProvider.SetString("LoadingText", LeaderboardLoadingString);

	// Set up the category titles
	DataProvider.SetString("VersusTitle", LeaderboardVersusGroupString);
	DataProvider.SetString("HordeTitle", LeaderboardHordeGroupString);
	DataProvider.SetString("SiegeTitle", LeaderboardSiegeGroupString);
	DataProvider.SetString("ArcadeTitle", LeaderboardArcadeGroupString);

	// Set up the match counts
	StatManager = GetGearPC().StatManager;
	DataProvider.SetString("VersusMatchCount", StatManager.GetStatValueByName('GamesPlayedMP') @ Leaderboards_Matches);
	DataProvider.SetString("HordeMatchCount", StatManager.GetStatValueByName('HordePlayed') @ Leaderboards_Games);
	DataProvider.SetString("SiegeMatchCount", StatManager.GetStatValueByName('SiegePlayed') @ Leaderboards_Games);
	DataProvider.SetString("ArcadeMatchCount", "???" @ Leaderboards_Chapters);


	// Iterate over the leaderboard categories, and add them to the data provider
	LeaderboardCategories = CreateArray();
	for( i = 0; i < LBT_MAX; i++ )
	{
		TmpObj = CreateObject("Object");
		TmpObj.SetString("Label1", LeaderboardCategoryStrings[i]);
		LeaderboardCategories.SetElementObject(i, TmpObj);
	}
	DataProvider.SetObject("ListDataProvider", LeaderboardCategories);
	DataProvider.SetString("ControllerMap", Controller_Close $ Controller_Spacer $ Controller_ViewLeaderboards);

	// Send the leaderboards to actionscript
	ActionScript_Leaderboards_SetDataProvider_Page1( DataProvider );
}

/**
 * Called when a player on the leaderboard is selected
 * 
 * @param   Index   Index into the LeaderboardsDataStore.StatsRead.Rows array of the player that was selected (same as the list order)
 */
function Callback_OnLeaderboardItemPress(int Index)
{
	local UIScene_FrontEnd  FrontEndScene;

	FrontEndScene = UIScene_FrontEnd(Outer);
	if( FrontEndScene != None )
	{
		FrontEndScene.OpenPersonalStats(None, LeaderboardsDataStore.StatsRead.Rows[Index].PlayerId, None, GearLeaderboardBase(LeaderboardsDataStore.StatsRead));
	}
}

/**
 * Called when a leaderboard category has been selected on the category selection leaderboard page
 * 
 * @param   Category    The index of the category which was selected
 */
function Callback_OnLeaderboardCategorySelected(int Category)
{
	local name LeaderboardDSName;
	local array<name> ButtonAliases;

	LeaderboardType = ELeaderboardType(Category);

	// Set up the bindings based upon leaderboard type
	switch (LeaderboardType)
	{
		case LBT_Public:
			LeaderboardDSName = 'GearLeaderboardsPublic';
			break;
		case LBT_Player:
			LeaderboardDSName = 'GearLeaderboardsPlayer';
			break;
		case LBT_Private:
			LeaderboardDSName = 'GearLeaderboardsPrivate';
			break;
		case LBT_Horde:
			LeaderboardDSName = 'GearLeaderboardsHorde';
			break;
		case LBT_Siege:
			LeaderboardDSName = 'GearLeaderboardsSiege';
			break;
		case LBT_Arcade:
			LeaderboardDSName = 'GearLeaderboardsArcade';
			break;
	}

	// Grab a reference to our leaderboard data store
	LeaderboardsDataStore = GearLeaderboardsDataStoreBase(StaticResolveDataStore(LeaderboardDSName, GetLP()));

 	if( LeaderboardsDataStore != None )
 	{
		// Make sure the player is logged in, and warn them if not
 		if ( !class'UIInteraction'.static.IsLoggedIn(GetLP().ControllerId,true) )
 		{
 			ButtonAliases.AddItem('GenericAccept');
 			class'GearUIManager'.static.ShowUIMessage('ConfirmNetworkLost',
 				Localize("MessageBoxErrorStrings", "NeedGoldTier_Title", "GearGameUI"),
 				Localize("MessageBoxErrorStrings", "NeedGoldTierLeaderboard_Message", "GearGameUI"),
 				ButtonAliases,
 				OnConfirm_NeedsGoldTier,
 				GetLP());
 		}
 		else
 		{
 			Leaderboard_RefreshStats();
 		}
 	}
}

/**
 *  Called when the player confirms they need to upgrade to gold tier to use the leaderboards
 *  
 *  @param  Sender              The message box that called this callback
 *  @param  SelectedInputAlias  The alias that was selected from the message box
 *  @param  PlayerIndex         The PlayerIndex that pressed the button in the message box
 *  
 *  @return                     TRUE if the case was handled, FALSE if not
 */
final function bool OnConfirm_NeedsGoldTier(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	return TRUE;
}

//==============================================================
// War Journal Callbacks
//==============================================================

/**
 * Called when the war journal would like to close
 */
function Callback_CloseWarJournal()
{
	ActionScript_CloseView();

	// Unblur the main menu here, so it unblurs as we animate out
	TryUnblurFrontEnd();
}

/**
 * Called whenever a new tab is visited
 * 
 * @param   TabIndex    Index of the tab that was visited.  Corresponds to the EWJPages enum
 */
function Callback_WarJournalPageVisited(int TabIndex);

/**
 * Called whenever any terminal node that can have an unread (!) bing on it is viewed, and should be cleared.
 * 
 * @param   ItemIndex   The index into the data provider of the item that was viewed
 */
function Callback_ItemViewed(int ItemIndex)
{
	switch (CurrentPage)
	{
		case WJ_Achievements:
			HandleAchievementViewed(ItemIndex);
			break;
		case WJ_Challenges:
			HandleChallengeViewed(ItemIndex);
			break;
		case WJ_Collectibles:
			HandleDiscoverableViewed(ItemIndex);
			break;
		case WJ_Horde:
			HandleHordeViewed(ItemIndex);
			break;
		case WJ_Medals:
			HandleMedalViewed(ItemIndex);
			break;
	}

	// Update the tab to see if we need to clear a bing
	UpdateCurrentTabBing();
}

/**
 * Handles the clearing of the "needs viewed" flag for the achievements
 */
function HandleAchievementViewed(int AchievementIdx)
{
	local GearProfileSettings ProfileSettings;
	local EGearAchievement Achievement;

	ProfileSettings = GetGearPC().ProfileSettings;
	if( ProfileSettings != None )
	{
		Achievement = EGearAchievement(AchievementIdx);
		ProfileSettings.MarkAchievementAsViewed(Achievement);
	}
}

/**
 * Handles the clearing of the "needs viewed" flag for the challenges section
 * 
 * @param   ChallengeIdx    Index of the challenge that has just been viewed
 */
function HandleChallengeViewed(int ChallengeIdx)
{
	local GearAwardManager AwardManager;
	local GearAward Award;
	local int GroupIdx;

	AwardManager = GetGearPC().AwardManager;
	if( AwardManager != None )
	{
		// Get the group of challenges we're currently Viewing
		GroupIdx = ActionScript_GetCurrentlySelectedCategory();
		Award = AwardManager.Awards[AwardManager.CachedGroupData[GroupIdx].AwardIndexes[ChallengeIdx]];

		// Clear the award for viewing
		GetGearPC().AwardManager.ClearAwardForViewing(Award);
	}
}


/**
 * Handles the clearing of the "needs viewed" flag for the horde section
 *
 * @param LevelIdx - The level of the currently selected horde group that was just looked at
 */
function HandleHordeViewed(int LevelIdx)
{
	local int GroupIdx;
	local int DataIdx;
	local int Count;
	local GearAward Award;
	local GearAwardManager AwardManager;

	// Get the index of the list we are looking at
	GroupIdx = ActionScript_GetCurrentlySelectedCategory();
	// Figure out which element of the group data we are dealing with
	for (DataIdx = 0; DataIdx < HordeGroupData.Length; DataIdx++)
	{
		if (HordeGroupData[DataIdx].bActive)
		{
			if (Count == GroupIdx)
			{
				break;
			}
			else
			{
				Count++;
			}
		}
	}

	// Make sure the group index is valid
	if (GroupIdx < HordeGroupData.Length)
	{
		// Make sure the level index is valid
		if (LevelIdx >= 0 && LevelIdx < HordeGroupData[GroupIdx].AwardNames.Length)
		{
			AwardManager = GetGearPC().AwardManager;
			Award = AwardManager.GetAwardByName(HordeGroupData[GroupIdx].AwardNames[LevelIdx]);
			GetGearPC().AwardManager.ClearAwardForViewing(Award);
		}
	}
}


/**
 * Handles the clearing of the "needs viewed" flag for a medal
 *
 * @param MedalIdx - The index in the MedalDisplayOrder of the GearAwardManager
 */
final function HandleMedalViewed(int MedalIdx)
{
	local GearAwardManager  AwardManager;
	local GearAward CurrentAward;

	// Get the award manager, so we can iterate over all awards
	AwardManager = GetGearPC().AwardManager;
	if( AwardManager != None )
	{
		CurrentAward = AwardManager.FindAwardByPersistentDataID(MedalIdx);
		if (CurrentAward != None)
		{
			// Clear the flag
			AwardManager.ClearAwardForViewing(CurrentAward);
		}
	}
}

/**
 * Called when the leaderboard filter change buttons have been pressed on the leaderboard list view page.  See gears.controls.WJ_LeaderboardsPage_List's handleInput() for details
 * 
 * @param   ButtonPressed   String from GFx navEquivalents that was pressed
 */
function Callback_OnLeaderboardFilterChange(string ButtonPressed)
{
	switch(ButtonPressed)
	{
		case "gamepad_L2":
			ChangeFilterOption(LF_PlayerFilterType);
			break;
		case "gamepad_R2":
			// Horde, siege, and arcade don't have time period adjustments
			if( LeaderboardType != LBT_Horde && LeaderboardType != LBT_Siege && LeaderboardType != LBT_Arcade )
			{
				ChangeFilterOption(LF_TimePeriod);
			}
			break;
		case "left":
			if( LeaderboardType == LBT_Horde || LeaderboardType == LBT_Siege || LeaderboardType == LBT_Arcade )
			{
				ChangeFilterOption(LF_MapType, -1);
			}
			else
			{
				ChangeFilterOption(LF_GameMode, -1);
			}
			break;
		case "right":
			if( LeaderboardType == LBT_Horde || LeaderboardType == LBT_Siege || LeaderboardType == LBT_Arcade )
			{
				ChangeFilterOption(LF_MapType, 1);
			}
			else
			{
				ChangeFilterOption(LF_GameMode, 1);
			}
			break;
		default:
			break;
	}
}

/**
 * Called when the main challenges pages is brought up.  The WJ will then wait to transition to the subpage until ActionScript_Challenges_SetDataForPage1() is called
 * 
 * @param   ChallengeIndex  Index of the challenge that was selected (UNUSED)
 */
function Callback_RequestDataForPage1_WJChallenges(int ChallengeIndex)
{
	InitializePage_Challenges_Page1();
}

/**
 * Called when a subpage is requested in the challenges page.  The WJ will then wait to transition to the subpage until ActionScript_Challenges_SetDataForPage2() is called
 * 
 * @param   ChallengeIndex  Index of the challenge that was selected
 */
function Callback_RequestDataForPage2_WJChallenges(int ChallengeIndex)
{
	InitializePage_Challenges_Page2(ChallengeIndex);
}

/**
 * Called when the main Collectibles pages is brought up.  The WJ will then wait to transition to the subpage until ActionScript_Collectibles_SetDataForPage1() is called
 * 
 * @param   CollectibleIndex  Index of the Collectible that was selected (UNUSED)
 */
function Callback_RequestDataForPage1_WJCollectibles(int CollectibleIndex)
{
	InitializePage_Collectibles_Page1();
}

/**
 * Called when a subpage is requested in the challenges page.  The WJ will then wait to transition to the subpage until ActionScript_Collectibles_SetDataForPage2() is called
 * 
 * @param   CollectibleIndex  Index of the Collectible that was selected
 */
function Callback_RequestDataForPage2_WJCollectibles(int CollectibleIndex)
{
	InitializePage_Collectibles_Page2(CollectibleIndex);
}

/**
 * Called when the main leaderboard category pages is brought up
 * 
 * @param   LeaderboardIndex  Index of the Collectible that was selected (UNUSED)
 */
function Callback_RequestDataForPage1_WJLeaderboards(int LeaderboardIndex)
{
	InitializePage_Leaderboards();
}


//==============================================================
// Leaderboard support
//==============================================================
/** 
 * Refreshes the stats and opens a scene while it's updating
 */
function Leaderboard_RefreshStats()
{
	local OnlineSubsystem OnlineSub;
	local GearPC PC;
	local int ControllerId;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Start blocking input!
		bReadingLeaderboards = TRUE;
		ActionScript_Leaderboards_OpenLeaderboardLoadingState();

		ControllerId = GetLP().ControllerId;
		if (bHasReadFriends)
		{
			// Safe to read the stats
 			OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(OnStatsReadComplete);
 			LeaderboardsDataStore.RefreshStats(ControllerId);
		}
		else
		{
			// Need to read the friends list first
			PC = GetGearPC();
			if (PC != None)
			{
				OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(ControllerId,OnRefreshFriendsComplete);
				PC.OnlinePlayerData.FriendsProvider.FriendsList.Length = 0;
				PC.OnlinePlayerData.FriendsProvider.NotifyPropertyChanged();
				PC.OnlinePlayerData.FriendsProvider.RefreshFriendsList();
			}
		}
	}
}

/**
 * Delegate used when the friends read request has completed. Triggers the stats read
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnRefreshFriendsComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(GetLP().ControllerId, OnRefreshFriendsComplete);
	}
	// So we don't read friends again while the UI is up
	bHasReadFriends = true;
	Leaderboard_RefreshStats();
}

/**
 * Called once the stats read has completed
 *
 * @param bWasSuccessful whether the call completed ok or not
 */
function OnStatsReadComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local GFxObject DataProvider, LeaderboardList, LeaderboardObj;
	local string Text;
	local int i, SortColumnIdx;
	local GearPRI LocalPRI1, LocalPRI2;

	// Cache the local PRI's for name formatting
	GetLocalPRIs(LocalPRI1, LocalPRI2);

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
 	if (OnlineSub != None)
 	{
 		OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnStatsReadComplete);
 	}

	DataProvider = CreateObject("Object");

	// Set up the current headers
	LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValue(LF_GameMode, i);
	Text = Caps(LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValueName(LF_GameMode, i));
	DataProvider.SetString("GameDesc", Text);

	LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValue(LF_PlayerFilterType, i);
	Text = Caps(LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValueName(LF_PlayerFilterType, i));
	DataProvider.SetString("PlayerType", Text);

	LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValue(LF_TimePeriod, i);
	Text = Caps(LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValueName(LF_TimePeriod, i));
	DataProvider.SetString("Time", Text);

	// Set up the button filters
	if( LeaderboardType == LBT_Horde || LeaderboardType == LBT_Siege || LeaderboardType == LBT_Arcade )
	{
		DataProvider.SetString("MapButton", FilterButton_Arrows);

		// These types also need the map filter value set
		LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValue(LF_MapType, i);
		Text = Caps(LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValueName(LF_MapType, i));
		DataProvider.SetString("MapName", Text);
	}
	else
	{
		DataProvider.SetString("GameButton", FilterButton_Arrows);
		DataProvider.SetString("TimeButton", FilterButton_RightTrigger);
	}
 	DataProvider.SetString("PlayerTypeButton", FilterButton_LeftTrigger);

	// Set up the column descriptors
	DataProvider.SetString("RankingDesc", Leaderboard_RankDescription);
	DataProvider.SetString("GamertagDesc", Leaderboard_GamertagDescription);
	DataProvider.SetString("ScoreDesc", Leaderboard_ScoreDescription);

	// Get the column index to return for the score
	SortColumnIdx = INDEX_NONE;
	for( i = 0; i < LeaderboardsDataStore.StatsRead.ColumnIds.Length; i++ )
	{
		if( LeaderboardsDataStore.StatsRead.ColumnIds[i] == LeaderboardsDataStore.StatsRead.SortColumnId )
		{
			SortColumnIdx = i;
			break;
		}
	}
	if( SortColumnIdx == INDEX_NONE )
	{
		`log("WARNING:  No sorting column found for leaderboards!");
	}

	// Populate the list with the array
	LeaderboardList = CreateArray();
	for( i = 0; i < LeaderboardsDataStore.StatsRead.Rows.Length; i++ )
	{
		LeaderboardObj = CreateObject("Object");

		// Convert the player's rank
		LeaderboardObj.SetString("Label1", LeaderboardsDataStore.GetPlayerRankForRow(i));

		// Record the player's name
		LeaderboardObj.SetString("Label2", GetFormattedPlayerStringFromNetId(LeaderboardsDataStore.StatsRead.Rows[i].NickName, LeaderboardsDataStore.StatsRead.Rows[i].PlayerId, LocalPRI1, LocalPRI2) );

		// Convert the player's score
		LeaderboardObj.SetString("Label3", LeaderboardsDataStore.GetColumnValueForRow(i, SortColumnIdx));

		LeaderboardList.SetElementObject(i, LeaderboardObj);
	}
	DataProvider.SetObject("ListDataProvider", LeaderboardList);

	DataProvider.SetString("ControllerMap", Controller_Back $ Controller_Spacer $ Controller_ViewLeaderboardInfo);

	ActionScript_Leaderboards_CloseLeaderboardLoadingState();
	ActionScript_Leaderboards_SetDataProvider_Page2(DataProvider);

	// Stop blocking input!
	bReadingLeaderboards = FALSE;
}

/**
 * Increments the specified option and wraps if it goes out of bounds
 *
 * @param FilterType the filter option to change
 * @param Direction the direction to move the selection (1 forward, -1 backward)
 */
function ChangeFilterOption(int FilterType,optional int Direction = 1)
{
	if ( LeaderboardsDataStore != None )
	{
		if ( LeaderboardsDataStore.LeaderboardSettings != None)
		{
			// Increment/decrement the selected item
			LeaderboardsDataStore.LeaderboardSettings.IncrementStringSettingValue(FilterType,Direction,true);
			Leaderboard_RefreshStats();
			UpdateFilterOptionText(FilterType);
		}
		else
		{
			`warn(`location @ "Leaderboards data store has NULL value for LeaderboardSettings!");
		}
	}
	else
	{
		`warn(`location @ "no Leaderboards data store found!");
	}
}

/**
 * Sets the text to the currently selected option in the specified filter type
 *
 * @param FilterType the filter type to query for the current value
 */
function UpdateFilterOptionText(int FilterType)
{
	local int Value;
	local string Text;

	if ( LeaderboardsDataStore != None )
	{
		if ( LeaderboardsDataStore.LeaderboardSettings != None)
		{
			LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValue(FilterType,Value);
			Text = Caps( LeaderboardsDataStore.LeaderboardSettings.GetStringSettingValueName(FilterType,Value) );
			
			switch(FilterType)
			{
				case LF_TimePeriod:
					ActionScript_Leaderboards_SetFilterText_Time(Text);
					break;
				case LF_GameMode:
					ActionScript_Leaderboards_SetFilterText_GameMode(Text);
					break;
				case LF_PlayerFilterType:
					ActionScript_Leaderboards_SetFilterText_Player(Text);
					break;
				case LF_MapType:
					ActionScript_Leaderboards_SetFilterText_Map(Text);
					break;
				default:
					break;
			}
		}
		else
		{
			`warn(`location @ "Leaderboards data store has NULL value for LeaderboardSettings!");
		}
	}
	else
	{
		`warn(`location @ "no Leaderboards data store found!");
	}
}

//==============================================================
// ActionScript Stubs
//==============================================================

function ActionScript_OpenView()
{
	WJView.ActionScriptVoid("OpenView");
}

function ActionScript_CloseView()
{
	WJView.ActionScriptVoid("CloseView");
}

function ActionScript_SetPrimaryController( int ControllerIndex )
{
	WJView.ActionScriptVoid("SetPrimaryController");
}

function ActionScript_ToggleUpdatedIconForTab( int PageIndex, bool bToggleOn )
{
	WJView.ActionScriptVoid("ToggleUpdatedIconForTab");
}

// --- Page Data Provider Setter Functions ----------------------
function ActionScript_WarJournal_SetDataProvider(GFxObject DataProvider, optional int TabToOpen)
{
	WJView.ActionScriptVoid("SetDataProvider");
}

function ActionScript_Summary_SetDataProvider(GFxObject DataProvider)
{
	SummaryPage.ActionScriptVoid("SetDataProvider");
}

function ActionScript_Achievements_SetDataProvider(GFxObject DataProvider)
{
	AchievementsPage.ActionScriptVoid("SetDataProvider");
}

function ActionScript_Medals_SetDataProvider(GFxObject DataProvider)
{
	MedalsPage.ActionScriptVoid("SetDataProvider");
}

function ActionScript_Horde_SetDataProvider(GFxObject DataProvider)
{
	HordePage.ActionScriptVoid("SetDataProvider");
}

function ActionScript_Challenges_SetDataProvider(GFxObject DataProvider)
{
	ChallengesPage.ActionScriptVoid("SetDataProvider");
}

function ActionScript_Challenges_SetDataForPage2(GFxObject DataProvider)
{
	ChallengesPage.ActionScriptVoid("SetDataForPage2");
}

function ActionScript_Collectibles_SetDataProvider(GFxObject DataProvider)
{
	CollectiblesPage.ActionScriptVoid("SetDataProvider");
}

function float ActionScript_GetCurrentlySelectedCategory()
{
	return HordePage.ActionScriptFloat("GetSelectedCategory");
}

function ActionScript_Horde_SetIndexBang(int Index, bool bShowUpdatedIcon)
{
	HordePage.ActionScriptVoid("SetList1IndexIsUpdated");
}

function ActionScript_Leaderboards_SetDataProvider_Page1(GFxObject DataProvider)
{
	LeaderboardsPage.ActionScriptVoid("SetDataProvider");
}

function ActionScript_Leaderboards_SetDataProvider_Page2(GFxObject DataProvider)
{
	LeaderboardsPage.ActionScriptVoid("SetDataForPage2");
}

function ActionScript_Leaderboards_OpenLeaderboardSelection()
{
	LeaderboardsPage.ActionScriptVoid("OpenLeaderboardSelection");
}

function ActionScript_Leaderboards_OpenLeaderboardList()
{
	LeaderboardsPage.ActionScriptVoid("OpenLeaderboardList");
}

function ActionScript_Leaderboards_OpenLeaderboardLoadingState()
{
	LeaderboardsPage.ActionScriptVoid("OpenLeaderboardLoadingState");
}

function ActionScript_Leaderboards_CloseLeaderboardLoadingState()
{
	LeaderboardsPage.ActionScriptVoid("CloseLeaderboardLoadingState");
}

function ActionScript_Leaderboards_SetFilterText_Time(string NewText)
{
	LeaderboardsPage.ActionScriptVoid("SetTimeFilterText");
}

function ActionScript_Leaderboards_SetFilterText_GameMode(string NewText)
{
	LeaderboardsPage.ActionScriptVoid("SetGameModeFilterText");
}

function ActionScript_Leaderboards_SetFilterText_Player(string NewText)
{
	LeaderboardsPage.ActionScriptVoid("SetPlayerFilterText");
}

function ActionScript_Leaderboards_SetFilterText_Map(string NewText)
{
	LeaderboardsPage.ActionScriptVoid("SetMapTypeFilterText");
}

//==============================================================
// ActionScript Callbacks
//==============================================================

function Callback_CloseComplete()
{
	local UIScene_FrontEnd  FEScene;

	FEScene = UIScene_FrontEnd(Outer);
	if( FEScene != None )
	{
		// If we have a frontend scene that opened us, let it take care of calling close and 
		FEScene.OnWarJournalClosed();
	}
	else
	{
		// Otherwise, just close!
		Close();
	}
}

defaultproperties
{
	bCaptureInput=TRUE
	bOnlyOwnerFocusable=TRUE

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

	Controller_Spacer="   "
}
