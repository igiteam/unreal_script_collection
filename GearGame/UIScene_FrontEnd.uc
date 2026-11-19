/**
 * The FrontEnd class that kicks off the main movie
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_FrontEnd extends GearGFxMoviePlayer
	dependson(Checkpoint)
	dependson(GearEngine)
	dependson(GearPersistentPartyBeaconHost)
	dependson(GearUIManager)
	Config(UI);

`include(GearOnlineConstants.uci)

//==============================================================
// Enums, consts, structs needed for this scene
//==============================================================

/** Enum of the different match modes you can select through the versus path */
enum EGearsMPMode
{
	eGVMM_Social,
	eGVMM_Ranked,
	eGVMM_Custom,
	eGVMM_Training,
};

/** Enum of the different campaign modes you can select through the campaign path */
enum EGearsCampMode
{
	eGCAMPMODE_Continue,
	eGCAMPMODE_New,
	eGCAMPMODE_Load,
	eGCAMPMODE_Join,
};

/** Enum of the different public matchmaking modes */
enum EGearsMatchmakingMode
{
	eGMATCHMAKINGMODE_Versus,
	eGMATCHMAKINGMODE_Coop,
};

//==============================================================
// Widget handles
//==============================================================

/** Reference to the main menu movie that initiates from this movie */
var UIWidget_MainMenu MainMenuMovie;

/** Reference to the small party panel */
var UIWidget_SmallPartyPanel SmallPartyPanel;

/** Reference to the matchmaking panel */
var UIWidget_MatchmakingControl MatchmakingPanel;

/** The reference to the options menu to bring up when "options" are selected */
var transient UIScene_Options   OptionsMenu;
/** Content class reference for the options menu */
var class<UIScene_Options>      OptionsMenuClass;

/** The reference to the MP preferences scene that's opened when the user chooses to configure their character */
var transient UIScene_MPPreferences MPPreferences;
/** Content class reference for the options menu */
var class<UIScene_MPPreferences>    MPPreferencesClass;

/** The reference to the what's up scene */
var transient UIScene_WhatsUp       WhatsUpScene;
var class<UIScene_WhatsUp>          WhatsUpSceneClass;

/** The reference to the system link browser */
var transient UIScene_SystemLink    SystemLinkScene;
var class<UIScene_SystemLink>       SystemLinkSceneClass;

/** The reference to the war journal scene */
var transient UIScene_WarJournal    WarJournalScene;
var class<UIScene_WarJournal>       WarJournalSceneClass;

/** The reference to the post game stats scene */
var transient UIScene_PostGameStats PostGameStatScene;
var class<UIScene_PostGameStats>    PostGameStatSceneClass;

/** The reference to the difficulty select scene */
var transient UIScene_Difficulty    DifficultyScene;
var class<UIScene_Difficulty>       DifficultySceneClass;

/** The reference to the personal stats scene */
var transient UIScene_PersonalStats PersonalStatsScene;
var class<UIScene_PersonalStats>    PersonalStatsSceneClass;

/** The reference to the video settings scene */
var transient UIScene_VideoOptions  VideoSettingsScene;
var class<UIScene_VideoOptions>     VideoSettingsSceneClass;

/** Reference to the calendar instance */
var transient UIWidget_Calendar Calendar;

/** The player options dialog popup widget */
var transient GFxObject PartyOptionsPanel;

//==============================================================
// Other misc. variables
//==============================================================

/** Flag to let us know if we are on the title screen or not */
var bool bOnTitleScreen;

/** Flag to let us know if we're in the options menu at the moment */
var transient bool bIsInOptionsMenu;

/** Flag to let us know if we're in the calendar */
var transient bool bCalendarIsOpen;

/** Current selected index we are on */
var byte CurrMenuSelection;

/** Flag that determines whether we should be starting a party session or not */
var bool bStartPartySession;

/** The match mode that was selected in the versus option (Versus mode selected in the UI) */
var EGearsMPMode SelectedMPMode;

/** The campaign mode that was selected in the campaign option (Campaign mode selected in the UI) */
var EGearsCampMode SelectedCampMode;

/** True if PostInit has been called */
var bool bReady;

/** The currently selected slot index to use for saving the game in campaign */
var int SelectedSaveSlot;

/** Whether the game should use the currently selected save game */
var bool bUseCheckpoint;

/** The chapter to start the campaign from */
var int SelectedChapter;

/** The act to start the campaign from */
var int SelectedAct;

/** Whether the campaign is going to be using the arcade mutator or not */
var bool bCampaignIsArcade;

/** Flag that determines whether we should restore the front end based on the history or not */
var bool bRestoreFromHistory;

/** The public matchmaking mode to be started */
var transient EGearsMatchmakingMode CurrMatchmakingMode;

/** Whether we're waiting for the matchmaking process to begin or not (this is a hack since there is an async wait from the
    time we click the button till the time matchmaking begins )*/
var transient bool bWaitingForMatchmakeToBegin;

/** Whether we're starting a game (only used for unofficial matches) */
var transient bool bGameStarting;

/** Currently selected playlist being used */
var transient int CurrPlaylistId;

/** Whether the party options popup panel is open or not */
var transient bool bPartyOptionsActive;

/** Current party type we are in */
var EGearVersusPartyType CurrPartyType;
/** Next pending party type we will be changing to */
var EGearVersusPartyType PendingPartyType;
/** Whether there is a party change pending right now */
var bool bPartyTypeChangeIsPending;
/** The time we opened the party options screen */
var float PartyOptionsOpenTime;
/** The minimum wait time before closing the party options after selecting */
var float PartyOptionsMinimumWaitTime;

/** Post process settings to blur the world when the flash menu is blurred */
var PostProcessSettings     BlurPostProcessSettings;
var PostProcessSettings     DesatBlurPostProcessSettings;

/** The starting menu screen */
var EMainMenuOption StartScreen;

/** Color lookup table for post process blur effect for the client menu */
var Texture2D ClientBlurColorLUT;

/** Whether or not we've prompted the user to configure their MP preferences this instance */
var transient bool bHasPromptedForMPPreferences;

/** Whether we should allow guest login to happen or not */
var transient bool bAllowGuestLogin;

/** The controllerID of the player that pressed start */
var transient int PressedStartControllerId;

/** Tracks when the save slots have been all read and parsed */
var transient int SaveGameReadsRemaining;
//==============================================================
// Localized strings
//==============================================================

var localized string MatchErrorNoGuestInPublic;
var localized string HostMutatorButtonBarString;
var localized string ClientMutatorButtonBarString;
var localized string PartyOptionsTitle;
var localized string AcceptPartyOptions;
var localized string CancelPartyOptions;
var localized string PartyOptionJoinable;
var localized string PartyOptionJoinableDesc;
var localized string PartyOptionInvite;
var localized string PartyOptionInviteDesc;
var localized string PartyOptionSystemLink;
var localized string PartyOptionSystemLinkDesc;
var localized string PartyOptionLocal;
var localized string PartyOptionLocalDesc;
var localized string LegalTextString;
var localized string ESRBTextString;

//==============================================================
// Widget Initialization / Handling
//==============================================================

/** 
 *  Initialization callback for widgets in the scene
 *  
 *  @param WidgetName - Name of the widget
 *  @param WidgetPath - Path of the widget
 *  @param Widget - The widget itself
 *  
 *  @return Whether or not this function has handled the callback
 */

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		case 'MainMenu':
			MainMenuMovie = UIWidget_MainMenu(Widget);
			MainMenuMovie.FrontEndMovie = self;
			SetWidgetPathBinding(MainMenuMovie, WidgetPath);
			MainMenuMovie.Initialize();
			break;
		case 'mc_SmallPPanelContainer':

			if( SmallPartyPanel != None )
			{
				// If we already have a small party panel, give it a chance to clean itself up
				SmallPartyPanel.CleanupPartyPanel();
			}

			SmallPartyPanel = UIWidget_SmallPartyPanel(Widget);
			SetWidgetPathBinding(SmallPartyPanel, WidgetPath);
			SmallPartyPanel.InitializePartyPanel(PPC_FrontEnd, self);
			break;
		case 'CalendarView':
			Calendar = UIWidget_Calendar(Widget);
			SetWidgetPathBinding(Calendar, WidgetPath);
			break;
		case 'mc_Matchmaking':
			MatchmakingPanel = UIWidget_MatchmakingControl(Widget);
			SetWidgetPathBinding(MatchmakingPanel, WidgetPath);
			MatchmakingPanel.Initialize(self);
			break;
		case 'PartyPopup':
			PartyOptionsPanel = Widget;
			break;
		case ('lbl_PressStart'):
			Widget.SetString("htmlText", localize("MainMenu", "PressStart", "GearGameUI"));
			break;
		//Legal labels
		case 'lblLegalText':
			Widget.SetString("htmlText",LegalTextString);
			break;
		case 'lblESRBText':
			Widget.SetString("htmlText",ESRBTextString);
			break;
		default:
			`log("Unhandled widget in UIScene_FrontEnd: " @ WidgetPath,, 'GearsUI');
			return false;
	}

	return true;
}

/**
 * Callback after all widgets have been initialized in a frame
 */
function PostWidgetInit()
{
	local string MutatorButtonBarString;
	if (!bReady)
	{
		PreMainMenuConstruct();

		//This is where InitializeMenus will be called
		MainMenuMovie.SubPostWidgetInit();

		if (GetPC().Role == ROLE_Authority)
		{
			MutatorButtonBarString = HostMutatorButtonBarString;
		}
		else
		{
			MutatorButtonBarString = ClientMutatorButtonBarString;
		}
		MainMenuMovie.GetObject("MutatorSelection").GetObject("Mutators").SetString("ControllerMapHtml",MutatorButtonBarString);

		bReady = true;
	}	
}

/** Overloaded to hook into chat tracking */
function Init(optional LocalPlayer LocPlay)
{
	local OnlineSubsystem OnlineSub;
	local GearUIManager UIManager;
	local GearMenuPC MenuPC;
	local GearPartyGRI PartyGRI;
	local GearUIInteraction UIController;
	local GearLocalPlayer GearLP;
	local GearLocalPlayer GearLocPlay;
	local GearPC GPC;


	/*******************************************
	 * PRE-MOVIE INIT (MainMenuMovie does not exist yet)
	 *******************************************/
	PartyGRI = GearPartyGRI(GetGRI());
	MenuPC = GearMenuPC(GetPC());

	//If you're the authority...
	if (MenuPC.Role == ROLE_Authority)
	{
		//Clear out the flow mods and the disabled items
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		if (UIManager != None)
		{
			UIManager.MainMenuFlowModLength = 0;
			UIManager.MainMenuDisabledLength = 0;
			UIManager.MainMenuRemovedLength = 0;
		}
		//Make profile-based modifications to the main menu
		MakeProfileModifications();

		//Update the persistent data cache so we can get war journal bangs correct
		MenuPC.AwardManager.CacheAwardDataByGroup();
	}
	else //Otherwise synch to any stored flow mods and disabled items from the server
	{
		SynchToStoredFlowMods();
		SynchToStoredDisabled();
		SynchToStoredRemoved();

		//Also open the difficulty screen if the server is telling you to

		if (PartyGRI != none && PartyGRI.bDifficultySelection)
		{
			PartyGRI.OnDifficultySelectionChanged();
		}
	}

	/**********************************
	 * INIT MOVIE
	 **********************************/
	Super.Init(LocPlay);

	// See if we need to prompt for MP preferences
	if (MenuPC != None &&
		MenuPC.Role < ROLE_Authority &&
		MenuPC.ProfileSettings != None &&
		!MenuPC.ProfileSettings.HasConfiguredMPPreferences())
	{
		CheckForMPPreferencesPrompt(true);
	}

	// Setup callback for when the LIVE blade opens and closes so we can handle
	// players coming and going
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		if (OnlineSub.SystemInterface != None)
		{
			// Handle controllers being added/removed
			OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerChange);
		}
		if (OnlineSub.PlayerInterface != None)
		{
			// We need to update guest sign in status based off of login change
			OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
		}
	}

	// Make sure the player count matches the login count
	UpdatePlayersAndControllers();

	// Turn chat tracking on (talk bubbles)
	TrackChat(true);

	// Hook up any delegates
	InitializeCallbacks();

	GearLocPlay = GearLocalPlayer(LocPlay);

	// If we are returning to main menu we need to skip the title screen
	if (!GearLocPlay.bIsFirstFrontEndLoad)
	{
		GPC = GearPC(class'Engine'.static.GetEngine().GamePlayers[0].Actor);
		// Tell ActionScript to skip ahead to the main menu
		if (MenuPC.Role == ROLE_Authority)
		{
			MainMenuMovie.ASOpenMainMenuDirect(class'Engine'.static.GetEngine().GamePlayers[0].ControllerId);
		}
		
		//If we have another player, set his info also
		if (class'Engine'.static.GetEngine().GamePlayers.Length > 1)
		{	
			GPC = GearPC(class'Engine'.static.GetEngine().GamePlayers[1].Actor);
			if (GPC != none)
			{
				SetSecondaryController(class'Engine'.static.GetEngine().GamePlayers[1].ControllerId);
			}
		}

		// If this is a client we need to tell them to update their custom game settings
		MainMenuMovie.OnCustomGameSettingsChanged();
		
		// Put background into normal state
		Background_PlayMainMenu();

		if (!InPartySession())
		{
			// Since we are going straight to the main menu we can automatically create
			// the party session since we don't need to determine who the primary player is
			bStartPartySession = true;

			// If you WERE in a party when you launched into a game, but now you aren't,
			// wipe the history so you end up on the main menu
			GearLP = GearLocalPlayer(GetLP());
			if (GearLP == None || GearLP.bWasPlayingWithParty)
			{
				//`log("Nuke history");
				SaveHistory(CreateArray(),0);
			}
		}
		// If we are starting the front end for the first time, or are pretending to, wipe the history
		else
		{
			SaveHistory(CreateArray(),0);
		}

		// Set the front end to restore its' history
		bRestoreFromHistory = true;

		// We've skipped the title screen
		bOnTitleScreen = false;

		// See if we need to open up the post game stats
		ConditionalOpenPostGameStats(true, false);

		//Skipping title screen, deactivate attract movie
		UIController = GearUIInteraction(class'UIRoot'.static.GetCurrentUIController());
		if ( UIController != None )
		{
			UIController.bAttractModeAllowed = false;
		}
	}
	else //Not skipping title screen, enable attract movie
	{
		UIController = GearUIInteraction(class'UIRoot'.static.GetCurrentUIController());
		if ( UIController != None )
		{
			UIController.bAttractModeAllowed = true;
		}
	}

	GearLocPlay.bIsFirstFrontEndLoad = false;
}

function SetPartyMemberPostProcessingEffect()
{
	`log("#### SETPARTYMEMBERPOSTPROCESSINGEFFECT");

	if (GetPC().Role != ROLE_Authority)
	{
		`log("#### Adding effect");
		GetPC().WorldInfo.DefaultPostProcessSettings.bEnableSceneEffect = true;
		GetPC().WorldInfo.DefaultPostProcessSettings.bOverride_Scene_ColorGradingLUT = TRUE;
		GetPC().WorldInfo.DefaultPostProcessSettings.ColorGrading_LookupTable = ClientBlurColorLUT;
		GetPC().WorldInfo.DefaultPostProcessSettings.bEnableDOF = true;
		GetPC().WorldInfo.DefaultPostProcessSettings.DOF_FocusInnerRadius = 0;
		GetPC().WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = 1.0;
		GetPC().WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = 1.0;
	}
}


/**
 * Function that makes modifications to the front end based on the profile data
 */
function MakeProfileModifications()
{
	local GearMenuPC GMPC, GMPCOwner;
	local int CompletedChaptersCasual[2], CompletedChaptersNormal[2], CompletedChaptersHard[2], CompletedChaptersInsane[2], UnlockedChapters[2];

	GMPCOwner = GearMenuPC(GetGearPC());

	//If you have not unlocked any chapters...
	if (GMPCOwner.ProfileSettings != none)
	{
		if (!GMPCOwner.ProfileSettings.HasUnlockedAnyChapters())
		{
			//Make gametype selection skip straight to difficulty for campaign
			//Pick gametype -> Pick difficulty
			ModifyScreenFlow(MAINMENUOP_SPGametype,0, MAINMENUOP_SPDifficulty);
			//Make arcade mutator selection skip straight to difficulty
			//Pick arcade mutator -> Pick difficulty
			ModifyScreenFlow(MAINMENUOP_Arcade_MutatorSelection,0, MAINMENUOP_SPDifficulty);
		}
		else //Put it back to normal
		{
			//Pick gametype -> Pick Act
			ModifyScreenFlow(MAINMENUOP_SPGametype,0, MAINMENUOP_SPActSelect);
			//Pick arcade mutator -> Pick Act
			ModifyScreenFlow(MAINMENUOP_Arcade_MutatorSelection,0, MAINMENUOP_SPActSelect);
		}
		//Also we're going to have to set the disableds
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersCasual1,CompletedChaptersCasual[0]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersCasual2,CompletedChaptersCasual[1]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersNormal1,CompletedChaptersNormal[0]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersNormal2,CompletedChaptersNormal[1]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersHard1,CompletedChaptersHard[0]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersHard2,CompletedChaptersHard[1]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersInsane1,CompletedChaptersInsane[0]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersInsane2,CompletedChaptersInsane[1]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`UnlockedChapterAccess1,UnlockedChapters[0]);
		GMPCOwner.ProfileSettings.GetProfileSettingValueInt(`UnlockedChapterAccess2,UnlockedChapters[1]);
		//For each player controller, tell them about the host's unlocked chapters
		foreach GMPCOwner.WorldInfo.AllControllers(class'GearMenuPC', GMPC)
		{
			GMPC.ClientMainMenuChapterChange(CompletedChaptersCasual,CompletedChaptersNormal,
									CompletedChaptersHard,CompletedChaptersInsane,UnlockedChapters);
		}
	}
}

/**
 * Function called to rectify the act and chapter select screens with the profile data stored in the
 * GearUIManager (as it may have come from a host)
 */
function UpdateActAndChapterSettings()
{
	local GFxObject ActList, ActObject, ChapterList, ChapterObject;
	local int ActIndex, ChapterIndex, NumTotalActs, NumTotalChapters;
	local bool bIsActUnlocked, bIsChapterUnlocked;
	local int ActCompletedDifficulty, ChapterCompletedDifficulty;
	local int StorageIndex, StorageOffset, ProviderIndex;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> ActProviders;
	local UIProviderScriptFieldValue Val;
	local GearCampaignChapterData ChapterData;
	local GearUIManager UIManager;
	local GearCampaignActData ActData;

	if (MainMenuMovie != none)
	{
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
		// Grab the act providers
		GameResourceDS.GetResourceProviders('Acts', ActProviders);
		Val.PropertyTag = 'ActNum';
		Val.PropertyType = DATATYPE_Property;

		ActList = MainMenuMovie.MenuData.GetElementObject(MAINMENUOP_SPActSelect).GetObject("Options");
		NumTotalActs = ActList.GetFloat("length");
		for (ActIndex = 0; ActIndex < NumTotalActs; ActIndex++)
		{
			bIsActUnlocked = false;
			ActCompletedDifficulty = DL_Insane;
			ActObject = ActList.GetElementObject(ActIndex);

			Val.StringValue = string(ActIndex);
			ProviderIndex = GameResourceDS.FindProviderIndexByFieldValue('Acts', 'ActNum', Val);
			ActData = GearCampaignActData(ActProviders[ProviderIndex]);

			ChapterList = MainMenuMovie.MenuData.GetElementObject(MAINMENUOP_MAX+ActIndex).GetObject("Options");
			NumTotalChapters = ChapterList.GetFloat("length");
			for (ChapterIndex = 0; ChapterIndex < NumTotalChapters; ChapterIndex++)
			{
				bIsChapterUnlocked = false;
				ChapterObject = ChapterList.GetElementObject(ChapterIndex);
				ChapterCompletedDifficulty = INDEX_NONE;

				ChapterData = ActData.ChapterProviders[ChapterIndex];

				StorageIndex = ChapterData.ChapterNum / 32;
				StorageOffset = ChapterData.ChapterNum % 32;

				bIsChapterUnlocked = class'GearAwardManager'.static.BitIsSet(UIManager.UnlockedChapters[StorageIndex], StorageOffset);

				if (bIsChapterUnlocked)
				{
					bIsActUnlocked = true;
					//Check to see what difficulty we've completed this act on.
					if (class'GearAwardManager'.static.BitIsSet(UIManager.CompletedChaptersInsane[StorageIndex], StorageOffset))
					{
						ChapterCompletedDifficulty = DL_Insane;
					}
					else if (class'GearAwardManager'.static.BitIsSet(UIManager.CompletedChaptersHard[StorageIndex], StorageOffset))
					{
						ChapterCompletedDifficulty = DL_Hardcore;
					}
					else if (class'GearAwardManager'.static.BitIsSet(UIManager.CompletedChaptersNormal[StorageIndex], StorageOffset))
					{
						ChapterCompletedDifficulty = DL_Normal;
					}
					else if (class'GearAwardManager'.static.BitIsSet(UIManager.CompletedChaptersCasual[StorageIndex], StorageOffset))
					{
						ChapterCompletedDifficulty = DL_Casual;
					}
				}
				
				if (ChapterCompletedDifficulty < ActCompletedDifficulty)
				{
					ActCompletedDifficulty = ChapterCompletedDifficulty;
				}

				ChapterObject.SetBool("disabled", !bIsChapterUnlocked);
				ChapterObject.SetFloat("Medal", ChapterCompletedDifficulty);	
			}

			ActObject.SetBool("disabled",!bIsActUnlocked);
			ActObject.SetFloat("Medal", ActCompletedDifficulty);	
		}
	}
}

function SetSecondaryController(int SecondaryController)
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_Number;
	ASVal.n = SecondaryController;
	args.AddItem(ASVal);

	MainMenuMovie.Invoke("SetSecondaryController", args);
}

/** Overloaded to turn off hook into chat tracking */
event OnClose()
{
	local OnlineSubsystem OnlineSub;
	local GearLocalPlayer GearLP;
	local GearPartyGame_Base PartyGame;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		if (OnlineSub.SystemInterface != None)
		{
			OnlineSub.SystemInterface.ClearControllerChangeDelegate(OnControllerChange);
		}
		if (OnlineSub.PlayerInterface != None)
		{
			OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
		}
		// Clear the save game cache
		if (OnlineSub.ContentInterface != None)
		{
			OnlineSub.ContentInterface.ClearSaveGames(LocalPlayerOwnerIndex);
		}
	}

	// Turn off chat tracking (talk bubbles)
	TrackChat(false);

	// Clear any hooks to callbacks
	ClearCallbacks();

	// Make sure there are no dangling delegates
	PartyGame = GetPartyGame();
	if (PartyGame != None)
	{
		PartyGame.ClearOnlineDelegates();
	}

	// Close the options menu
	if( OptionsMenu != None )
	{
		OptionsMenu.Close();
		OptionsMenu = None;
	}

	// Close the what's up screen
	if( WhatsUpScene != None )
	{
		WhatsUpScene.Close();
		WhatsUpScene = None;
	}

	// Close the war journal
	if( WarJournalScene != None )
	{
		WarJournalScene.Close();
		WarJournalScene = None;
	}

	if (DifficultyScene != none)
	{
		DifficultyScene.Close();
		DifficultyScene = none;
	}

	if (PersonalStatsScene != None)
	{
		PersonalStatsScene.Close();
		PersonalStatsScene = None;
	}

	if (SmallPartyPanel != None)
	{
		SmallPartyPanel.CleanupPartyPanel();
	}

	if (VideoSettingsScene != None)
	{
		VideoSettingsScene.Close(TRUE);
		VideoSettingsScene = None;
	}

	// Set whether the owner of the front end was in a party when launching a game
	GearLP = GearLocalPlayer(GetLP());
	if (GearLP != None)
	{
		GearLP.bWasPlayingWithParty = InPartySession();
	}

	Super.OnClose();
}

/** Hook up any delegates */
function InitializeCallbacks()
{
	local GearPartyGRI PartyGRI;
	local GearPartyGame_Base PartyGame;

	PartyGRI = GearPartyGRI(GetGRI());
	if (PartyGRI != None)
	{
		PartyGRI.OnMatchMakingStateChanged = OnMatchMakingStateChanged;
		PartyGRI.OnCustomGameSettingsChanged = OnCustomGameSettingsChanged;
		PartyGRI.OnMatchModeChanged = UpdateMatchMode;
		PartyGRI.OnVersusGameTypeChanged = UpdateVersusGameType;

		// We may be too late to receive the replicated event for match mode so force call the callback
		if (PartyGRI.MatchMode >= 0)
		{
			UpdateMatchMode(EGearVersusMatchType(PartyGRI.MatchMode));
		}

		// We may be too late to receive the replicated event for versus game type so force call the callback
		if (PartyGRI.VersusGameType >= 0)
		{
			UpdateVersusGameType(PartyGRI.VersusGameType);
		}
	}

	PartyGame = GetPartyGame();
	if (PartyGame != None)
	{
		// Setup the party update delegate
		PartyGame.PartySettingsUpdateFinished = PartySettingsUpdateFinished;
		// Setup the party created delegate
		PartyGame.PartySuccessfullyCreatedNotify = PartySuccessfullyCreatedNotify;
		PartyGame.PartyFailedCreationNotify = LocalPartyCreated;
	}
}

/** Clear any hooks to callbacks */
function ClearCallbacks()
{
	local GearPartyGRI PartyGRI;
	local GearPartyGame_Base PartyGame;

	PartyGRI = GearPartyGRI(GetGRI());
	if (PartyGRI != None)
	{
		PartyGRI.OnMatchMakingStateChanged = None;
		PartyGRI.OnCustomGameSettingsChanged = None;
		PartyGRI.OnMatchModeChanged = None;
		PartyGRI.OnVersusGameTypeChanged = None;
	}

	PartyGame = GetPartyGame();
	if (PartyGame != None)
	{
		// Clear the party update delegate
		PartyGame.PartySettingsUpdateFinished = None;
		// Clear the party created delegate
		PartyGame.PartySuccessfullyCreatedNotify = None;
		PartyGame.PartyFailedCreationNotify = None;
	}
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
	// See if the matchmaking panel should get control of the input
	if (MatchmakingPanel != None &&
		MatchmakingPanel.bPanelIsActive)
	{
		// Returns true if the matchmaking panel wants to eat this input
		if (MatchmakingPanel.FilterButtonInput(ControllerId, ButtonName, InputEvent))
		{
			return true;
		}
	}

	// Check for closing the party options
	if (bPartyOptionsActive)
	{
		if (InputEvent == IE_Pressed &&
			LocalPlayerOwnerIndex == ControllerId)
		{
			if (ButtonName == 'XboxTypeS_B')
			{
				HandlePartyTypeSelection(false);
				return true;
			}
			else if (ButtonName == 'XboxTypeS_A')
			{
				HandlePartyTypeSelection(true);
			}
		}
	}
	else if (ButtonName == 'XboxTypeS_Back' &&
			InputEvent == IE_Pressed &&
			LocalPlayerOwnerIndex == ControllerId)
	{
		OpenPartyOptions();
		return true;
	}

	if (ButtonName == 'XboxTypeS_X' &&
		InputEvent == IE_Pressed &&
		SmallPartyPanel != None)
	{
		WhatsUpScene = SmallPartyPanel.OpenWhatsUpScene(WhatsUpSceneClass, self, GetLPForControllerId(ControllerId), OnCloseWhatsUp);
		return true;
	}

	// Check to see if we need to close the calendar
	if ( bCalendarIsOpen )
	{
		// Close the calendar on a B keypress, but always gobble input if we're in the calendar
		if( ButtonName == 'XboxTypeS_B' && InputEvent == IE_Pressed )
		{
			CloseCalendar();
		}
		return true;
	}

	// Perform guest signin if applicable or signin
	if (ButtonName == 'XboxTypeS_Y' &&
		InputEvent == IE_Pressed)
	{
		// Show the login ui with the guest option
		ConditionalShowLoginUI(ControllerId,bAllowGuestLogin);
		return true;
	}

	//Open post game stats if applicable
	if (ButtonName == 'XboxTypeS_LeftShoulder' &&
		InputEvent == IE_Pressed )
	{
		ConditionalOpenPostGameStats(false);
		return true;
	}

	//Handle the start button
	if (ButtonName == 'XboxTypeS_Start' &&
		InputEvent == IE_Pressed)
	{
		NotifyGFxStartButtonPressed(ControllerId);
		return true;
	}

	return false;
}


/** Function used to notify flash that the start button has been pressed.
 *  This is used instead of flash input handling to centralize all start presses 
 *  and thus to avoid issues with the start screen vs the main menu
 *  
 *  @param ControllerId - the controller id that pressed start
 */
function NotifyGFxStartButtonPressed(int ControllerId)
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_Number;
	ASVal.n = ControllerId;
	args.AddItem(ASVal);

	if (MainMenuMovie != none)
	{
		MainMenuMovie.Invoke("StartButtonPressed", args);
	}
}

/** Returns whether we can open the party options panel or not */
final function bool CanOpenPartyOptions()
{
	local GearPC PC;

	PC = GearPC(GetPC());

	if (PartyOptionsPanel != None &&
		!bPartyOptionsActive &&
		SmallPartyPanel != None &&
		SmallPartyPanel.ContextType == PPC_FrontEnd &&
		(MatchmakingPanel == None || !MatchmakingPanel.bPanelIsActive) &&
		PC.Role == ROLE_Authority)
	{
		return true;
	}

	return false;
}

/** Opens the party options submenu */
final function OpenPartyOptions()
{
	local String BackButtonString;

	if (CanOpenPartyOptions())
	{
		// Set the header
		PartyOptionsPanel.SetString("HeaderHtml", PartyOptionsTitle);

		// Set the footer
		BackButtonString = AcceptPartyOptions $ "     " $ CancelPartyOptions;
		PartyOptionsPanel.SetString("FooterHtml", BackButtonString);

		// Build the party option list and send it to action script
		BuildPartyOptions();

		// Open the options panel
		ActionScript_OpenPartyOptions();

		// Mark the panel as active
		bPartyOptionsActive = true;
	}
}

/** Builds the screen for the party options */
final function BuildPartyOptions()
{
	local GFxObject DataProvider;
	local GFxObject DataObject;
	local int SelectedIdx;
	local GearPC MenuPC;
	local int ControllerId;
	local int PlayerCount;
	local OnlineSubsystem OnlineSub;
	local bool bNoLIVEFunctionality;

	// Set the current party type
	MenuPC = GearPC(GetPC());
	if (MenuPC != None && MenuPC.ProfileSettings != None)
	{
		CurrPartyType = MenuPC.ProfileSettings.GetPartyType();
	}

	ControllerId = GetLP().ControllerId;

	// Check for LIVE functionality
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (!class'UIInteraction'.static.IsLoggedIn(ControllerId, true) ||
		(OnlineSub != None &&
		 OnlineSub.PlayerInterface != None &&
		 OnlineSub.PlayerInterface.CanPlayOnline(ControllerId) == FPL_Disabled))
	{
		bNoLIVEFunctionality = true;
	}


	// Build the options...
	DataProvider = CreateArray();
	DataProvider.SetFloat("length", 3);

	// Joinable option
	DataObject = CreateObject("Object");
	DataObject.SetString("label", PartyOptionJoinable);
	DataObject.SetString("Desc", PartyOptionJoinableDesc);
	if (CurrPartyType == eGVPT_FriendsOnly)
	{
		SelectedIdx = 0;
		DataObject.SetBool("bIsSelected", true);
	}
	else
	{
		DataObject.SetBool("bIsSelected", false);
	}
	DataObject.SetBool("disabled", bNoLIVEFunctionality);
	DataProvider.SetElementObject(0, DataObject);

	// Invite-Only option
	DataObject = CreateObject("Object");
	DataObject.SetString("label", PartyOptionInvite);
	DataObject.SetString("Desc", PartyOptionInviteDesc);
	if (CurrPartyType == eGVPT_InviteRequired)
	{
		SelectedIdx = 1;
		DataObject.SetBool("bIsSelected", true);
	}
	else
	{
		DataObject.SetBool("bIsSelected", false);
	}
	DataObject.SetBool("disabled", bNoLIVEFunctionality);
	DataProvider.SetElementObject(1, DataObject);

	// System Link option
	DataObject = CreateObject("Object");
	DataObject.SetString("label", PartyOptionSystemLink);
	DataObject.SetString("Desc", PartyOptionSystemLinkDesc);
	if (CurrPartyType == eGVPT_SystemLink)
	{
		SelectedIdx = 2;
		DataObject.SetBool("bIsSelected", true);
	}
	else
	{
		DataObject.SetBool("bIsSelected", false);
	}

	PlayerCount = class'UIInteraction'.static.GetPlayerCount();
	if (class'UIInteraction'.static.GetLoggedInPlayerCount(false) == PlayerCount &&
		class'UIInteraction'.static.HasLinkConnection())
	{
		DataObject.SetBool("disabled", false);
	}
	else
	{
		DataObject.SetBool("disabled", true);
	}
	DataProvider.SetElementObject(2, DataObject);

	// Local option
	DataObject = CreateObject("Object");
	DataObject.SetString("label", PartyOptionLocal);
	DataObject.SetString("Desc", PartyOptionLocalDesc);
	if (CurrPartyType == eGVPT_Local)
	{
		SelectedIdx = 3;
		DataObject.SetBool("bIsSelected", true);
	}
	else
	{
		DataObject.SetBool("bIsSelected", false);
	}
	DataProvider.SetElementObject(3, DataObject);

	// Set the provider to the Action Script
	ActionScript_SetPartyOptionsProvider(DataProvider, SelectedIdx);
}

/** Closes the party options submenu */
final function ClosePartyOptions()
{
	if (bPartyOptionsActive)
	{
		bPartyOptionsActive = false;
		bPartyTypeChangeIsPending = false;
		PartyOptionsOpenTime = -1;
		ActionScript_ClosePartyOptions();
		// Let the party panel update it's title
		if (SmallPartyPanel != None)
		{
			SmallPartyPanel.UpdatePanelTitle();
		}
	}
}

/**
 * Handle selection in the party options submenu
 *
 * @return - whether they accepted the selected option or decided to cancel
 */
final function HandlePartyTypeSelection(bool bAcceptOption)
{
	if (bPartyOptionsActive)
	{
		if (bAcceptOption)
		{
			bPartyTypeChangeIsPending = true;
		}
		else
		{
			ClosePartyOptions();
		}
	}
}

/** Called from ActionScript when a player has selected an option from the party options panel */
function Callback_DialogItemPress(int Idx)
{
	local GearUIManager UIManager;
	local int ControllerId;
	local int PlayerCount;
	local OnlineSubsystem OnlineSub;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	ControllerId = GetLP().ControllerId;
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	// If they didn't accept the option, the pending flag will be false and we can just close shop
	if (!bPartyTypeChangeIsPending)
	{
		ClosePartyOptions();
	}
	// They accepted the change so need to decide how to handle it
	else
	{
		// Determine which party type was selected
		switch (Idx)
		{
			case 0:
				// Make sure they have a logged in live profile
				if (!class'UIInteraction'.static.IsLoggedIn(ControllerId, true))
				{
					UIManager.DisplayErrorMessage("NeedGoldTierFunctionality_Message", "NeedGoldTier_Title", "GenericContinue", GetLP());
					return;
				}
				// Make sure they have permissions
				else if (OnlineSub != None &&
						 OnlineSub.PlayerInterface != None &&
						 OnlineSub.PlayerInterface.CanPlayOnline(ControllerId) == FPL_Disabled)
				{
					UIManager.DisplayErrorMessage("NeedOnlinePermission_Message", "NeedOnlinePermission_Title", "GenericContinue", GetLP());
					return;
				}
				else
				{
					PendingPartyType = eGVPT_FriendsOnly;
				}
				break;
			case 1:
				// Make sure they have a logged in live profile
				if (!class'UIInteraction'.static.IsLoggedIn(ControllerId, true))
				{
					UIManager.DisplayErrorMessage("NeedGoldTierFunctionality_Message", "NeedGoldTier_Title", "GenericContinue", GetLP());
					return;
				}
				// Make sure they have permissions
				else if (OnlineSub != None &&
					OnlineSub.PlayerInterface != None &&
					OnlineSub.PlayerInterface.CanPlayOnline(ControllerId) == FPL_Disabled)
				{
					UIManager.DisplayErrorMessage("NeedOnlinePermission_Message", "NeedOnlinePermission_Title", "GenericContinue", GetLP());
					return;
				}
				else
				{
					PendingPartyType = eGVPT_InviteRequired;
				}
				break;
			case 2:
				PlayerCount = class'UIInteraction'.static.GetPlayerCount();

				// Make sure they have a network connection
				if (!class'UIInteraction'.static.HasLinkConnection())
				{
					class'GearUIManager'.static.DisplayErrorMessage("NoLinkConnection_Message", "NoLinkConnection_Title", "GenericContinue", GetLP());
					return;
				}
				// Make sure everyone is logged into a profile
				else if (class'UIInteraction'.static.GetLoggedInPlayerCount(false) != PlayerCount)
				{
					class'GearUIManager'.static.DisplayErrorMessage("AControllerNotLoggedIn_Message", "NotLoggedIn_Title", "GenericContinue", GetLP());
					return;
				}
				else
				{
					PendingPartyType = eGVPT_SystemLink;
				}
				break;
			case 3:
				PendingPartyType = eGVPT_Local;
				break;
		}

		// If the party type is the same
		if (PendingPartyType == CurrPartyType)
		{
			// Is currently in a system link party so open the browser in case they want to join someone else
			if (PendingPartyType == eGVPT_SystemLink)
			{
				OpenSystemLinkBrowser();
			}
			// Else just close the options and do nothing
			else
			{
				ClosePartyOptions();
			}
		}
		// Party type is different so handle it
		else
		{
			// If system link, start the code path to opening the browser
			if (PendingPartyType == eGVPT_SystemLink)
			{
				AttemptSystemLinkTransition();
			}
			// If local, we need to destroy any existing party
			else if (PendingPartyType == eGVPT_Local)
			{
				AttemptLocalTransition();
				CreateLocalParty();
			}
			// If the previous mode was system link or local we need to rebuild the party
			else if (CurrPartyType == eGVPT_SystemLink ||
					 CurrPartyType == eGVPT_Local)
			{
				AttemptLIVETransition();
			}
			// Else update the settings and start cog spinning
			else
			{
				UpdateLIVEPartySession();
			}
		}
	}
}

/** Checks for needing to kick non-local players and will transition to local if accepted */
function AttemptLocalTransition()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	if (PartyHasNonLocalPlayers())
	{
		ButtonAliases.AddItem('GenericAccept');
		ButtonAliases.AddItem('GenericCancel');
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.ShowUIMessage(
			'ConfirmNetworkedPlayersKicked',
			"<Strings:GearGameUI.MessageBoxStrings.NetworkPlayersKicked_Title>",
			"<Strings:GearGameUI.MessageBoxStrings.NetworkPlayersKicked_Desc>",
			ButtonAliases,
			OnKickNetworkedPlayersForLocalParty_Confirm,
			GetLP());
	}
	else
	{
		CreateLocalParty();
	}
}

/** Callback from asking the host if they really want to kick non-local players */
function bool OnKickNetworkedPlayersForLocalParty_Confirm(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'GenericAccept')
	{
		CreateLocalParty();
	}
	else
	{
		CancelLocalSelection();
	}

	return true;
}

/** Checks for needing to kick non-local players and will transition to a LIVE party if accepted */
function AttemptLIVETransition()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	if (PartyHasNonLocalPlayers())
	{
		ButtonAliases.AddItem('GenericAccept');
		ButtonAliases.AddItem('GenericCancel');
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.ShowUIMessage(
			'ConfirmNetworkedPlayersKicked',
			"<Strings:GearGameUI.MessageBoxStrings.NetworkPlayersKicked_Title>",
			"<Strings:GearGameUI.MessageBoxStrings.NetworkPlayersKicked_Desc>",
			ButtonAliases,
			OnKickNetworkedPlayersForLIVEParty_Confirm,
			GetLP());
	}
	else
	{
		TransitionToLIVEParty();
	}
}

/** Callback from asking the host if they really want to kick non-local players */
function bool OnKickNetworkedPlayersForLIVEParty_Confirm(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'GenericAccept')
	{
		TransitionToLIVEParty();
	}
	else
	{
		CancelLIVESelection();
	}

	return true;
}

/** Transitions to the LIVE party and prompt about kicking non-local players */
function TransitionToLIVEParty()
{
	local OnlineSubsystem OnlineSub;
	local OnlineGameSettings PartySettings;

	// Check for an existing party session that needs to be destroyed
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
	}

	// Send prompts and kick non-local players
	PromptAndKickNonLocalPlayers();

	// If the previous match mode was system link we have to destroy the party
	if (PartySettings != None)
	{
		DestroyPartyForLIVE();
	}
	else
	{
		// Set the wait time
		PartyOptionsMinimumWaitTime = class'UIScene_Busy'.default.MinWaitTime;
		PartyOptionsOpenTime = GetWorldInfo().TimeSeconds;
		bPartyTypeChangeIsPending = false;
		CreateLIVEParty();
	}
}

/** Initiates the creation of a LIVE party */
final function CreateLIVEParty()
{
	local GearPC PC;
	local GearProfileSettings Profile;

	PC = GearPC(GetPC());
	Profile = PC.ProfileSettings;
	if (Profile != None)
	{
		// Reset the party type to what it was previously
		Profile.bPartyTypeIsSystemLink = false;
		Profile.bPartyTypeIsLocal = false;
		CurrPartyType = Profile.GetPartyType();
		// Set the party session to recreate itself
		bStartPartySession = true;
	}
}

/** Destroys the current party */
function DestroyParty()
{
	local GearPartyGame_Base PartyGI;

	PartyGI = GetPartyGame();
	PartyGI.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyComplete);
	if (PartyGI.GameInterface.DestroyOnlineGame('Party'))
	{
		GearPartyGRI(GetGRI()).OpenUpdatingPartyScene();
	}
	// Destroy persistent party invite beacon
	PartyGI.DestroyPersistentParty();
}

/**
 * Delegate fired when destroying an online game has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnDestroyPartyComplete(name SessionName,bool bWasSuccessful)
{
	local GearPartyGame_Base PartyGI;

	PartyGI = GetPartyGame();
	PartyGI.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyComplete);
	PartyGI.PartySettings = None;
	GearPartyGRI(GetGRI()).CloseUpdatingPartyScene();
}

/** Destroys a party to transition to local */
function DestroyPartyForLocal()
{
	local GearPartyGame_Base PartyGI;

	PartyGI = GetPartyGame();
	PartyGI.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyForLocalComplete);
	if (PartyGI.GameInterface.DestroyOnlineGame('Party'))
	{
		GearPartyGRI(GetGRI()).OpenUpdatingPartyScene();
	}
	// Destroy persistent party invite beacon
	PartyGI.DestroyPersistentParty();
}

/**
 * Delegate fired when a destroying an online game has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnDestroyPartyForLocalComplete(name SessionName,bool bWasSuccessful)
{
	local GearPartyGame_Base PartyGI;

	PartyGI = GetPartyGame();
	PartyGI.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyForLocalComplete);
	PartyGI.PartySettings = None;
	GearPartyGRI(GetGRI()).CloseUpdatingPartyScene();

	// Close the party options panel
	ClosePartyOptions();
}

/** Destroys a party to transition to LIVE */
function DestroyPartyForLIVE()
{
	local GearPartyGame_Base PartyGI;

	PartyGI = GetPartyGame();
	PartyGI.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyForLIVEComplete);
	if (PartyGI.GameInterface.DestroyOnlineGame('Party'))
	{
		GearPartyGRI(GetGRI()).OpenUpdatingPartyScene();
	}
	// Destroy persistent party invite beacon
	PartyGI.DestroyPersistentParty();
}

/**
 * Delegate fired when a destroying an online game has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnDestroyPartyForLIVEComplete(name SessionName,bool bWasSuccessful)
{
	local GearPartyGame_Base PartyGI;

	PartyGI = GetPartyGame();
	PartyGI.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyForLIVEComplete);
	PartyGI.PartySettings = None;
	GearPartyGRI(GetGRI()).CloseUpdatingPartyScene();

	// Close the party options panel
	ClosePartyOptions();
	// Restart a LIVE party
	CreateLIVEParty();
}

/** Just does a party option update since we are only changing settings within the same session */
final function UpdateLIVEPartySession()
{
	local GearPartyGame_Base PartyGame;

	PartyGame = GetPartyGame();
	if (PartyGame != None)
	{
		// Change the settings
		PartyGame.ChangePartySettings(PartyGame.PartySettings, PendingPartyType);
		// Update the settings to LIVE
		PartyGame.UpdatePartySettings();
		// Set the wait time
		PartyOptionsMinimumWaitTime = class'UIScene_Busy'.default.MinWaitTime;
		PartyOptionsOpenTime = GetWorldInfo().TimeSeconds;
	}
}

/** Called when the party settings update is finished updating */
final function PartySettingsUpdateFinished(name SessionName, bool bWasSuccessful)
{
	local GearPartyGame_Base PartyGame;
	local GearPC PC;

	if (bPartyOptionsActive)
	{
		// No longer pending a change
		bPartyTypeChangeIsPending = false;

		// We have successfully updated the party settings so mark the current type
		if (bWasSuccessful)
		{
			// Set the current selection and save the profile
			CurrPartyType = PendingPartyType;
			PC = GearPC(GetPC());
			SetPartyType(CurrPartyType);
			PC.SaveProfile();

			// Update Rich Presence Strings
			PartyGame = GetPartyGame();
			if (PartyGame != None)
			{
				PartyGame.SetPresenceByPartyType();
			}

			// If we were successful, make sure the screen was open long enough that we know
			if (PartyOptionsOpenTime > 0 &&
				PartyOptionsOpenTime + PartyOptionsMinimumWaitTime < GetWorldInfo().TimeSeconds)
			{
				ClosePartyOptions();
			}
		}
		else
		{
			// Close the panel
			ClosePartyOptions();
		}
	}
}

/** Set the data provider on the player options screen and sets the focused item in the list */
function ActionScript_SetPartyOptionsProvider(GFxObject DataProvider, int SelectedIdx)
{
	if (PartyOptionsPanel != None)
	{
		PartyOptionsPanel.ActionScriptVoid("SetDataProvider");
	}
}

/** Opens the party options panel */
function ActionScript_OpenPartyOptions()
{
	if (PartyOptionsPanel != None)
	{
		PartyOptionsPanel.ActionScriptVoid("OpenDialog");
	}
}

/** Closes the party options panel */
function ActionScript_ClosePartyOptions()
{
	if (PartyOptionsPanel != None)
	{
		PartyOptionsPanel.ActionScriptVoid("CloseDialog");
	}
}

/** Checks to see if there are any non-local players and sends a warning, else makes the transition */
function AttemptSystemLinkTransition()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local int PlayerCount;

	// Check for signed in players
	PlayerCount = class'UIInteraction'.static.GetPlayerCount();
	if (class'UIInteraction'.static.GetLoggedInPlayerCount(false) != PlayerCount)
	{
		class'GearUIManager'.static.DisplayErrorMessage("AControllerNotLoggedIn_Message", "NotLoggedIn_Title", "GenericContinue", GetLP());
		CancelSystemLinkSelection();
		return;
	}

	// Check for a network connection first
	if (!class'UIInteraction'.static.HasLinkConnection())
	{
		class'GearUIManager'.static.DisplayErrorMessage("NoLinkConnection_Message", "NoLinkConnection_Title", "GenericContinue", GetLP());
		CancelSystemLinkSelection();
		return;
	}

	// Prompt a warning if there are non-local players as they will be kicked
	if (PartyHasNonLocalPlayers())
	{
		ButtonAliases.AddItem('GenericAccept');
		ButtonAliases.AddItem('GenericCancel');
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.ShowUIMessage(
			'ConfirmNetworkedPlayersKicked',
			"<Strings:GearGameUI.MessageBoxStrings.NetworkPlayersKicked_Title>",
			"<Strings:GearGameUI.MessageBoxStrings.NetworkPlayersKicked_Desc>",
			ButtonAliases,
			OnKickNetworkedPlayersForSystemLink_Confirm,
			GetLP());
	}
	// Else go ahead and make the transition
	else
	{
		TransitionToSystemLink();
	}
}

/** Make the setting go back to what it was before the host select one of the LIVE option */
function CancelLIVESelection()
{
	// Need code to fix UI (checkbox back where it goes with proper selection)
}

/** Make the setting go back to what it was before the host selected system link */
function CancelSystemLinkSelection()
{
	// Need code to fix UI (checkbox back where it goes with proper selection)
}

/** Make the setting go back to what it was before the host selected local */
function CancelLocalSelection()
{
	// Need code to fix UI (checkbox back where it goes with proper selection)
}

/** Kicks non-local players, tells the gameinfo to shut the party session down, switches the invite policy, opens the LAN scene */
function TransitionToSystemLink()
{
	PromptAndKickNonLocalPlayers();

	// Kill the party session
	DestroyPartyForSystemLink();
}

/** Destroys a party to transition to system link */
function DestroyPartyForSystemLink()
{
	local GearPartyGame_Base PartyGI;

	PartyGI = GetPartyGame();
	PartyGI.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyPartyForSystemLinkComplete);
	if (PartyGI.GameInterface.DestroyOnlineGame('Party'))
	{
		GearPartyGRI(GetGRI()).OpenUpdatingPartyScene();
	}
	// Destroy persistent party invite beacon
	PartyGI.DestroyPersistentParty();
}

/**
 * Delegate fired when a destroying an online game has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnDestroyPartyForSystemLinkComplete(name SessionName,bool bWasSuccessful)
{
	local GearPartyGame_Base PartyGI;

	PartyGI = GetPartyGame();
	PartyGI.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyForSystemLinkComplete);
	PartyGI.PartySettings = None;
	GearPartyGRI(GetGRI()).CloseUpdatingPartyScene();
	OpenSystemLinkBrowser();
}

/** Finds all non-local players, prompts them that they are being booted, and then boots them */
function PromptAndKickNonLocalPlayers(optional string TitleMarkup="<Strings:GearGameUI.MessageBoxStrings.KickedForPartyKill_Title>", optional string MessageMarkup="<Strings:GearGameUI.MessageBoxStrings.KickedForPartyKill_Desc>")
{
	local int PRIIdx;
	local GearPartyGRI PartyGRI;
	local PlayerReplicationInfo CurrPRI;
	local GearPC CurrController;

	PartyGRI = GearPartyGRI(GetGRI());

	// Kick non-local players
	if (PartyGRI != None)
	{
		for (PRIIdx = 0; PRIIdx < PartyGRI.PRIArray.length; PRIIdx++)
		{
			CurrPRI = PartyGRI.PRIArray[PRIIdx];
			if (CurrPRI != None && !CurrPRI.bIsInactive)
			{
				CurrController = GearPC(CurrPRI.Owner);
				if (CurrController != None && !CurrController.IsLocalPlayerController())
				{
					// Send a warning to the client
					CurrController.ClientSetProgressMessage(PMT_ConnectionFailure, MessageMarkup, TitleMarkup, true);
					// Kick the player
					CurrController.ClientReturnToMainMenu();
				}
			}
		}
	}
}

/** Whether there are any non-local players in the party */
function bool PartyHasNonLocalPlayers()
{
	local int PRIIdx;
	local GearPartyGRI PartyGRI;
	local PlayerReplicationInfo CurrPRI;
	local GearPC CurrController;

	PartyGRI = GearPartyGRI(GetGRI());
	if (PartyGRI != None)
	{
		for (PRIIdx = 0; PRIIdx < PartyGRI.PRIArray.length; PRIIdx++)
		{
			CurrPRI = PartyGRI.PRIArray[PRIIdx];
			if (CurrPRI != None && !CurrPRI.bIsInactive)
			{
				CurrController = GearPC(CurrPRI.Owner);
				if (CurrController != None && !CurrController.IsLocalPlayerController())
				{
					return true;
				}
			}
		}
	}

	return false;
}

/** Callback from asking the host if they really want to kick non-local players */
function bool OnKickNetworkedPlayersForSystemLink_Confirm(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'GenericAccept')
	{
		TransitionToSystemLink();
	}
	else
	{
		CancelSystemLinkSelection();
	}
	return true;
}

/** Handle the opening of the system link browser from the main menu */
function OpenSystemLinkBrowser()
{
	if (SystemLinkScene == None &&
		SystemLinkSceneClass != None)
	{
		SystemLinkScene = new(self) SystemLinkSceneClass;
		SystemLinkScene.Init(GetLP());
		SystemLinkScene.InitializeSystemLink(self);
		ClosePartyOptions();
		MainMenuMovie.UpdateButtonBar();
	}
}

/** Closes the system link browser */
function OnCloseSystemLinkBrowser()
{
	if (SystemLinkScene != None)
	{
		SystemLinkScene.Close();
		SystemLinkScene = None;
		MainMenuMovie.UpdateButtonBar();
	}
}

/** Creates a system link party and closes the party options */
function CreateSystemLinkParty()
{
	local GearPartyGame_Base PartyGame;
	local GameViewportClient VPClient;
	local GearUIManager UIManager;

	// Make sure we still have a network connection to create a system link party
	PartyGame = GetPartyGame();
	VPClient = PartyGame.GetPlayerOwnerViewportClient();
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (VPClient != None &&
		VPClient.UIController != None &&
		!VPClient.UIController.HasLinkConnection())
	{
		UIManager.DisplayErrorMessage("NoLinkConnection_Message", "NoLinkConnection_Title", "GenericContinue", GetLP());
		ClosePartyOptions();
		return;
	}

	CurrPartyType = PendingPartyType;
	SetPartyType(eGVPT_SystemLink);
	ClosePartyOptions();
	bStartPartySession = true;
}

/** Sets the party and closes the party options */
function CreateLocalParty()
{
	LocalPartyCreated();
	ClosePartyOptions();
}

/** Determines if we need to check for MP preferences first prompting */
function CheckForMPPreferencesPrompt(bool bForcePrompt)
{
	local array<name> ButtonAliases;
	local GearUIManager UIManager;
	local GearMenuPC MenuPC;

	MenuPC = GearMenuPC(GetPC());
	if (bForcePrompt ||
		(MenuPC != None &&
		 MenuPC.ProfileSettings != None &&
		 IsOnAVersusScreen() &&
		 !MenuPC.ProfileSettings.HasConfiguredMPPreferences() &&
		 !bHasPromptedForMPPreferences))
	{
		ButtonAliases.AddItem('GenericYes');
		ButtonAliases.AddItem('GenericNo');
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.ShowUIMessage('MPPrefsPrompt',
			"<Strings:GearGameUI.MessageBoxStrings.MPPrefsPrompt_Title>",
			"<Strings:GearGameUI.MessageBoxStrings.MPPrefsPrompt_Message>",
			ButtonAliases,
			OnPromptForMPPreferencesComplete);
	}
}

/** Opens the video configuration screen for the first time the player plays the game */
function OpenVideoSettingsPage()
{
	if( VideoSettingsSceneClass != None && VideoSettingsScene == None )
	{
		VideoSettingsScene = new(self) VideoSettingsSceneClass;
		VideoSettingsScene.Init(GetLP());
	}
}

/** Called to clean up the references to the video settings page, if opened for the player the first time they signed in (NOT via the options menu) */
function OnCloseVideoSettings()
{
	VideoSettingsScene.Close();
	VideoSettingsScene = None;
}

/** Return from the prompt asking if the player wanted to configure their MP preferences */
function bool OnPromptForMPPreferencesComplete(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	bHasPromptedForMPPreferences = TRUE;

	if (SelectedInputAlias == 'GenericYes')
	{
		OpenMPPreferences(GetLP());
	}
	return true;
}

/** Returns whether we are on a versus screen or not */
function bool IsOnAVersusScreen()
{
	local byte CurrMenuOption;

	if (GetCurrentScreenAndSelection(CurrMenuOption))
	{
		switch (CurrMenuOption)
		{
			case MAINMENUOP_VS_Playlists:
			case MAINMENUOP_VS_Playlist1:
			case MAINMENUOP_VS_Playlist2:
			case MAINMENUOP_VS_Playlist3:
			case MAINMENUOP_VS_Playlist4:
			case MAINMENUOP_VS_Playlist5:
			case MAINMENUOP_VS_Playlist6:
			case MAINMENUOP_VS_Playlist7:
			case MAINMENUOP_VS_Playlist8:
			case MAINMENUOP_VS_Training:
			case MAINMENUOP_Horde:
			case MAINMENUOP_Siege:
			case MAINMENUOP_VS_CustomWarzone:
			case MAINMENUOP_VS_CustomExecution:
			case MAINMENUOP_Horde_Options:
			case MAINMENUOP_VS_CustomWingman:
			case MAINMENUOP_VS_CustomKOTH:
			case MAINMENUOP_VS_CustomCTL:
			case MAINMENUOP_VS_CustomNewbie:
			case MAINMENUOP_Siege_Options:
				return true;
		}
	}

	return false;
}

/** Forward the callback to the widget */
simulated function OnCustomGameSettingsChanged()
{
	if (MainMenuMovie != None)
	{
		MainMenuMovie.OnCustomGameSettingsChanged();
	}
}

/** Called when the what's up panel is closed */
function OnCloseWhatsUp()
{
	WhatsUpScene = None;
}


/* Function to continue from a halted selection 
 * @param bAllowSelection - True if we should advance as if the halted object was truly selected, false if we should just allow the user to try another selection.
 */
function ContinueFromHaltedState(bool bAllowSelection)
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_Boolean;
	ASVal.b = bAllowSelection;
	args.AddItem(ASVal);

	MainMenuMovie.Invoke("ContinueFromHaltedState", args);

	if (bAllowSelection)
	{
		//NOW tell everyone about the change
		MenuOptionWasChanged(GetHistory(),0);
	}
}

/**
 * Called when the menu options in the main menu have changed
 * @param HistoryArray - GFx array that represents the history of choices made
 * @param SelectedIndex - the current selected index
 */
function MenuOptionWasChanged(GFxObject HistoryArray, int SelectedIndex)
{
	local PlayerController PlayerOwner;
	local byte CurrMenuOption;
	local GearMenuPC GMPC;
	local GearUIManager UIManager;

	//Save the history!
	SaveHistory(HistoryArray, SelectedIndex);

	// See if we need to prompt for MP preferences
	CheckForMPPreferencesPrompt(false);

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	//Send the historyarray from GetHistory() to the clients via RPC
	PlayerOwner = GetPC();
	if (UIManager != none && 
		PlayerOwner != None &&
		PlayerOwner.Role == ROLE_Authority)
	{
		//For each player controller
		foreach PlayerOwner.WorldInfo.AllControllers(class'GearMenuPC', GMPC)
		{
			//If that player controller is not local
			if ( !GMPC.IsLocalPlayerController())
			{
				GMPC.ClientMainMenuSceneChange(UIManager.MainMenuHistory, UIManager.MainMenuHistoryLength, SelectedIndex);
			}
		}
	}

	// Tell the small party panel that the screen changed
	if (SmallPartyPanel != None)
	{
		if (GetCurrentScreenAndSelection(CurrMenuOption,))
		{
			SmallPartyPanel.MainMenuScreenChangedCallback(CurrMenuOption);
		}
	}

	// Update the buttonbar every time the screen changes
	if (MainMenuMovie != None)
	{
		MainMenuMovie.UpdateButtonBar();
	}
}

/**
 * Callback function from Actionscript called when the selection has been changed
 * Used to inform the clients about what the host has selected via the GRI
 * 
 * @param NewSelection - the selected index in the current main menu screen
 */
function Callback_SelectedIndexChanged(float NewSelection)
{
	local PlayerController PC;
	local GearPartyGRI PartyGRI;
	local GearUIManager UIManager;

	//Don't send anything if it's before everything has initted...then it's just setup
	if (!bReady)
	{
		return;
	}

	PC = GetPC();

	if (PC != none && PC.Role == ROLE_Authority)
	{
		PartyGRI = GearPartyGRI(GetGRI());
		if (PartyGRI != None)
		{
			PartyGRI.CurrMenuSelection = NewSelection;
			UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
			UIManager.LastSelectedIndex = NewSelection;
		}

		// Let the main menu widget know that the selection changed
		if (MainMenuMovie != None)
		{
			MainMenuMovie.SelectedIndexChangedNotify();
		}
	}
}

/**
 * Callback for when a menu option has been selected
 * 
 * @param HistoryArray - A GFxObject representing all of the choices the player has made. Used to deduce what the player wants to do
 *                      HistoryArray is an array of GfxObjects, each object representing a choice.
 *                          Each choice has two variables:
 *                              Screen - Byte representing what screen the player was on when this choice was made
 *                              Choice - The index of the option from the list of choices the player chose
 *                          HistoryArray is in chronological order, so the choice at index 0 is the first choice the player made.
 *                      
 * @param bIsHalted - Whether or not this selection caused the ui to halt and await a continue response from US
 */
function Callback_MenuOptionWasSelected(GFxObject HistoryArray, Bool bIsHalted)
{
 	local int ArrLength;
	local byte ParentScreen;
	local byte CurrMenuOption;
	local int SelectedOption;
	local bool bSelectionHandled;
	local byte bWantToContinue;

	// Get history length
 	ArrLength = HistoryArray.GetFloat("length");
	// Get current menu screen
	ParentScreen = MAINMENUOP_None;
	if ( ArrLength > 0)
	{
		ParentScreen = byte(HistoryArray.GetElementObject(ArrLength-1).GetFloat("Screen"));
		SelectedOption = int(HistoryArray.GetElementObject(ArrLength-1).GetFloat("Choice"));
		//Extract it from the gfx data!
		CurrMenuOption = byte(MainMenuMovie.MenuData.GetElementObject(ParentScreen).GetObject("Options").GetElementObject(SelectedOption).GetFloat("Next"));
	}

	//if this isn't a dead end...
	if (CurrMenuOption != MAINMENUOP_None)
	{
		// Menu option was changed so notify objects that care
		if (!bIsHalted)
		{
			MenuOptionWasChanged(HistoryArray,0);
		}
		// Save the history, but don't tell anyone just yet...
		else 
		{
			SaveHistory(HistoryArray,0);
		}
	}

	// Handle the menu selection
	bSelectionHandled = HandleMenuSelection(ParentScreen, SelectedOption, false, bWantToContinue);

	// Handle any halted states
	if (bIsHalted && bWantToContinue != 0)
	{
		ContinueFromHaltedState(bSelectionHandled);
	}
}

/**
 * Handles a menu selection from the main menu
 *
 * @param ParentScreen - The screen we are leaving
 * @param SelectedOption - The choice made on ParentScreen
 * @param bIsSimulating - Whether we are calling this function as we are progressing through the front end or if we are simulating that behavior
 * @param bWantToContinue - Whether or not we even want to continue from a halted state
 *
 * @return Whether we were able to move on to the next screen or not
 */
function bool HandleMenuSelection(byte ParentScreen, int SelectedOption, bool bIsSimulating, out byte bWantToContinue)
{
	local bool bResult;
	local byte CurrentScreen;

	//Screen we are going to
	CurrentScreen = byte(MainMenuMovie.MenuData.GetElementObject(ParentScreen).GetObject("Options").GetElementObject(SelectedOption).GetFloat("Next"));

	if (CurrentScreen == MAINMENUOP_None)
	{
		bWantToContinue = 0;
	}
	else
	{
		bWantToContinue = 1;
	}

	bResult = true;

	switch (CurrentScreen)
	{
	case MAINMENUOP_Horde_MutatorSelection:
		RestoreMutators(false);
		break;
	case MAINMENUOP_Arcade_MutatorSelection:
		RestoreMutators(true);
		break;
	}

	// Handle selections that are not the campaign chapters
	if (ParentScreen < MAINMENUOP_MAX)
	{
		switch (ParentScreen)
		{
			// An option on the main menu was selected
			case MAINMENUOP_MainMenu:
				// Horde was selected on the main menu
				if (CurrentScreen == MAINMENUOP_Horde)
				{
					bResult = HandleHordeSelection();
				}
				// Siege was selected on the main menu
				else if	(CurrentScreen == MAINMENUOP_Siege)
				{
					bResult = HandleSiegeSelection();
				}
				// Campaign was selected
				else if (CurrentScreen == MAINMENUOP_Campaign)
				{
					bResult = HandleCampaignSelection();
					if (bResult == false)
					{
						bWantToContinue = 0;
					}
				}
				// War Journal was selected
				else if (CurrentScreen == MAINMENUOP_WarJournal)
				{
					bResult = HandleOpenWarJournal();
				}
				// Calendar was selected
				else if (CurrentScreen == MAINMENUOP_Calendar)
				{
					bResult = HandleOpenCalendar();
				}
				// DLC was selected
				else if (CurrentScreen == MAINMENUOP_DLC)
				{
					OpenMarketplaceBlade(GetLP().ControllerId);
					bResult=false;
				}
				break;
			// Campaign selection (continue, load, new, join)
			case MAINMENUOP_Campaign:
				bResult = HandleCampaignOptionSelection(SelectedOption);
				break;
			case MAINMENUOP_SaveSlots:
				bResult = HandleSaveSlotSelection(SelectedOption, bIsSimulating);
				break;
			case MAINMENUOP_SPGametype:
				bResult = HandleCampaignTypeSelection(SelectedOption);
				break;
			case MAINMENUOP_SPActSelect:
				bResult = HandleActSelection(SelectedOption);
				break;
			// The match mode for Horde was selected
			case MAINMENUOP_Horde:
				bResult = HandleHordeAndSiegeMatchModeSelection(SelectedOption,bIsSimulating);
				if (bResult)
				{
					bWantToContinue = 1;
				}
				else
				{
					bWantToContinue = 0;
				}
				break;
			// The match mode for Siege was selected
			case MAINMENUOP_Siege:
				bResult = HandleHordeAndSiegeMatchModeSelection(SelectedOption,bIsSimulating);
				if (bResult)
				{
					bWantToContinue = 1;
				}
				else
				{
					bWantToContinue = 0;
				}
				break;
			// The match mode was selected on a versus screen, handle it
			case MAINMENUOP_VS_Playlist1:
			case MAINMENUOP_VS_Playlist2:
			case MAINMENUOP_VS_Playlist3:
			case MAINMENUOP_VS_Playlist4:
			case MAINMENUOP_VS_Playlist5:
			case MAINMENUOP_VS_Playlist6:
			case MAINMENUOP_VS_Playlist7:
			case MAINMENUOP_VS_Playlist8:
				bResult = HandleVersusMatchModeSelection(SelectedOption,bIsSimulating);
				if (bResult)
				{
					bWantToContinue = 1;
				}
				else
				{
					bWantToContinue = 0;
				}
				break;
			// A playlist was chosen
			case MAINMENUOP_VS_Playlists:
				bResult = HandlePlaylistSelection(SelectedOption);
				break;
			// Handle training grounds game selection
			case MAINMENUOP_VS_Training:
				//bResult = HandleTrainingGroundsSelection(SelectedOption);
				break;
			// Handle the finishing of the selection of options
			case MAINMENUOP_VS_CustomWarzone:
			case MAINMENUOP_VS_CustomExecution:
			case MAINMENUOP_VS_CustomWingman:
			case MAINMENUOP_VS_CustomKOTH:
			case MAINMENUOP_VS_CustomCTL:
			case MAINMENUOP_VS_CustomNewbie:
			case MAINMENUOP_Siege_Options:
				bResult = HandleCustomOptionsSelection();
				break;
			case MAINMENUOP_Horde_Options:
				break;

			case MAINMENUOP_Arcade_MutatorSelection:
				if (CurrentScreen == MAINMENUOP_SPDifficulty)
				{
					OpenDifficultySelectionScreen();
					bResult = false;
				}
				else
				{
					bResult = true;
				}
				break;
			case MAINMENUOP_Horde_MutatorSelection:
				bResult = HandleCustomOptionsSelection();
				break;
			//CLIENT MENU!!!
			case MAINMENUOP_ClientMenu:
				`log("YOU SHOULD NOT BE HERE! Client menu input should be handled by Callback_ClientMenuOptionWasSelected");
				return false;
				break;
		}
	}
	// Handle the selection of the campaign chapters
	else
	{
		bResult = HandleChapterSelection(SelectedOption);
	}

	return bResult;
}

function Callback_ClientMenuOptionWasSelected(float SelectedOption)
{
	local int IntSelectedOption;

	IntSelectedOption = int(SelectedOption);

	switch (IntSelectedOption)
	{
	case 0:
		HandleOpenWarJournal();
		break;
	case 1:
		HandleOpenCalendar();
		break;
	case 2:
		Callback_StartButtonPressed(LocalPlayer(GetPC().Player).ControllerId);
		break;
	case 3:
		OpenMarketplaceBlade(GetLP().ControllerId);
		break;
	case 4:
		Callback_TransitionToTitle();
		break;
	}
}

/** Function to handle campaign being selected in the main menu */
function bool HandleCampaignSelection()
{
	local int DeviceID;

	// No storage device so ask if they want to select one
	if (!StorageDeviceIsReady(LocalPlayerOwnerIndex, DeviceID))
	{
		CheckForMemoryDevice(OnCampaignDeviceMemoryCheckComplete);
	}
	// Storage device is ready so initialize the save slot data
	else
	{
		ReadAllSaveSlots();
	}

	return false;
}

/** Prompts the player if they'd like to select a storage device for campaign */
function PromptForSelectStorageDeviceForCampaign()
{
	local array<name> ButtonAliases;
	local GearUIManager UIManager;

	ButtonAliases.AddItem('AcceptSelectDevice');
	ButtonAliases.AddItem('CancelContinueAnyway');
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('NoStorageDevice',
		"<Strings:GearGameUI.MessageBoxStrings.NoDeviceLoad_Title>",
		"<Strings:GearGameUI.MessageBoxStrings.NoDeviceLoad_Message>",
		ButtonAliases,
		OnNoDeviceCheckCampaignComplete);
}

/** Callback from prompting the player to select a storage device */
function bool OnNoDeviceCheckCampaignComplete(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	// If they choose to select their storage device
	if (SelectedInputAlias == 'AcceptSelectDevice')
	{
		CheckForMemoryDevice(OnCampaignDeviceMemoryCheckComplete);
	}
	// They are continuing w/o a storage device
	else
	{
		ContinueFromHaltedState(true);
	}

	return true;
}

/** Return from the device check that allows us to know if they do or do not have a valid save device selected */
function OnCampaignDeviceMemoryCheckComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local int DeviceId;

	// Unregister our callback
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerIntEx = OnlineSub.PlayerInterfaceEx;
		if (PlayerIntEx != None)
		{
			PlayerIntEx.ClearDeviceSelectionDoneDelegate(class'UIInteraction'.static.GetPlayerControllerId(0), OnCampaignDeviceMemoryCheckComplete);
		}
	}

	// They have a valid device so initialize the save slot data and continue to the campaign lobby scene
	if (bWasSuccessful &&
		StorageDeviceIsReady(LocalPlayerOwnerIndex,DeviceId))
	{
		ReadAllSaveSlots();
		ContinueFromHaltedState(true);
	}
	// No device so loop back to the prompt that asks them if they want to select a device
	else
	{
		PromptForSelectStorageDeviceForCampaign();
	}
}

/** Function to handle the selection made in the main campaign option list */
function bool HandleCampaignOptionSelection(int SelectedOption)
{
	local bool bResult;
	
	//If continue has been removed then we need to modify the selected option in order to get the correct campaign mode
	if (IsOptionRemoved(MAINMENUOP_Campaign,0))
	{
		SelectedOption++;
	}

	// Set the currently selected options
	SelectedCampMode = EGearsCampMode(SelectedOption);

	// Each selection handles campaign differently
	switch (SelectedCampMode)
	{
		// Continue: from last saved location was selected
		case eGCAMPMODE_Continue:
			bResult = HandleContinueCampaign();
			break;
		// New: Start a new game (checks for storage device and warns if not found)
		case eGCAMPMODE_New:
			bResult = HandleNewCampaign();
			break;
		// Load: Continue from a save slot (checks for storage device and warns if not found)
		case eGCAMPMODE_Load:
			bResult = HandleLoadCampaign();
			break;
		// Join: Selected to join an online match (LIVE or LAN)
		case eGCAMPMODE_Join:
			bResult = HandleJoinCampaign();
			break;
	}

	return bResult;
}

/** Continue a campaign from the most recent save slot available */
function bool HandleContinueCampaign()
{
	SelectedSaveSlot = GetLatestSaveSlotIndex();
	if (SelectedSaveSlot != INDEX_NONE)
	{
		// We are continuing, so use the checkpoint
		bUseCheckpoint = true;
		// Kick off the starting of the campaign
		StartCampaign();
	}

	return true;
}

/** Start a new campaign */
function bool HandleNewCampaign()
{
	return true;
}

/** Load a campaign from one of the saved slots */
function bool HandleLoadCampaign()
{
	local GearPC PC;

	PC = GetGearPC();
	// No storage device so they can't load
	return PC.IsStorageDeviceValid();
}

/** Join someone else's campaign or create your own that can be joined by others if we can't find one */
function bool HandleJoinCampaign()
{
	local GearPartyGame_Base PartyGame;
	local OnlineGameSettings PartySession;
	local bool bIsLIVEParty;
	local bool bIsLANParty;
	local bool bIsLocal;

	// Get some helper variable for determining party type
	PartySession = GetPartySession();
	if (PartySession != None)
	{
		bIsLANParty = PartySession.bIsLanMatch;
		bIsLIVEParty = !bIsLANParty;
	}
	// Else is a local party
	else
	{
		bIsLocal = true;
	}

	// Make sure we can actually join a networked game
	if (AttemptNetworkedMatchTransition(bIsLIVEParty, bIsLANParty, bIsLocal, true))
	{
		CurrMatchmakingMode = eGMATCHMAKINGMODE_Coop;
		PartyGame = GetPartyGame();
		PartyGame.ChangeCoopSettings(PartyGame.PartySettings,GearPC(GetPC()).ProfileSettings);
		bCampaignIsArcade = false;

		// All is good, go forward
		return true;
	}
	else
	{
		// Can't join a networked game so tell the UI to not go forward
		return false;
	}
}

/** Handle a save slot being selected */
function bool HandleSaveSlotSelection(int SelectedOption, bool bIsSimulating)
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	// Set the selected save slot index
	SelectedSaveSlot = SelectedOption;

	// Make sure the file is not corrupted
	if (UIManager.SaveSlotData[SelectedSaveSlot].bIsCorrupted)
	{
		`log("HandleSaveSlotSelection found a corrupted save game which shouldn't happen because it should've been detected earlier and made unavailable!");
	}
	// See if this save slot is valid and has data before starting the game
	else if (UIManager.SaveSlotData[SelectedSaveSlot].bContainsData)
	{
		// If load was selected
		if (SelectedCampMode == eGCAMPMODE_Load)
		{
			// We are continuing from a save slot, so use the checkpoint
			bUseCheckpoint = true;
			// Kick off the starting of the campaign
			StartCampaign();
		}
		// Else we are about to stomp a save game so confirm that they want to do that before continuing
		else
		{
			if (!bIsSimulating)
			{
				ButtonAliases.AddItem('GenericCancel');
				ButtonAliases.AddItem('AcceptOverwrite');

				UIManager.ShowUIMessage('NoStorageDevice',
												  "<Strings:GearGameUI.MessageBoxStrings.SaveOverwrite_Title>",
												  "<Strings:GearGameUI.MessageBoxStrings.SaveOverwriteGeneric_Message>",
												  ButtonAliases,
												  OnCheckpointOverwriteCheckComplete);
			}
		}
	}
	// The file either doesn't exist or doesn't have data but isn't corrupt
	else
	{
		// If a new campaign was selected we're good to move on
		if (SelectedCampMode == eGCAMPMODE_New)
		{
			// Not using a checkpoint because we are starting new
			SelectedChapter = 0;
			bUseCheckpoint = false;
			return true;
		}
	}

	// If we are continuing or loading, get the chapter from the save
	if (SelectedSaveSlot != INDEX_NONE &&
		(SelectedCampMode == eGCAMPMODE_Continue || SelectedCampMode == eGCAMPMODE_Load))
	{
		SelectedChapter = UIManager.SaveSlotData[SelectedSaveSlot].ChapterNum;
	}

	return true;
}

/** Return from the prompt asking if the player wanted to overwrite their saved campaign */
function bool OnCheckpointOverwriteCheckComplete(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'AcceptOverwrite')
	{
		// They chose to overwrite so continue on
		ContinueFromHaltedState(true);
	}
	else
	{
		// They chose to cancel so don't move forward
		ContinueFromHaltedState(false);
	}
	return true;
}

/** Called when the player selects the kind of campaign he wants to run (Cinematic or Arcade) */
function bool HandleCampaignTypeSelection(int SelectedOption)
{
	bCampaignIsArcade = (SelectedOption == 1);
	if ( MainMenuMovie.AllOptions[MAINMENUOP_SPGametype].List[SelectedOption].Next == MAINMENUOP_SPDifficulty)
	{
		OpenDifficultySelectionScreen();
		return true;
	}
	return true;
}

/** Called the the player selects which act to play */
function bool HandleActSelection(int SelectedOption)
{
	SelectedAct = SelectedOption;
	return true;
}

/** Handle the selection of the chapter by the front end */
function bool HandleChapterSelection(int SelectedOption)
{
	local GearUIDataStore_GameResource GameResourceDS;

	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	if (GameResourceDS != None)
	{
		// Get the selected chapter
		SelectedChapter = GameResourceDS.GetChapterNumFromNormalizedChapterInAct(SelectedAct, SelectedOption);
	}

	OpenDifficultySelectionScreen();
	return true;
}

/** Checks for corrupt saves and prompts for deletion */
function CheckForCorruptSaves()
{
	local int SlotIndex;
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	for (SlotIndex = 0; SlotIndex < `NUM_SAVE_SLOTS; SlotIndex++)
	{
		if (UIManager.SaveSlotData[SlotIndex].bIsCorrupted)
		{
			ButtonAliases.AddItem('AcceptOverwrite');
			ButtonAliases.AddItem('GenericCancel');

			// Prompt for deleting corrupted save slot
			UIManager.ShowUIMessage('NoStorageDevice',
				"<Strings:GearGameUI.MessageBoxErrorStrings.ErrorLoadingSaveGame_Title>",
				"<Strings:GearGameUI.MessageBoxErrorStrings.ErrorLoadingSaveGame_Message>",
				ButtonAliases,
				OnCheckpointCorrupted);
			break;
		}
	}
}

/** Return from the prompt asking if the player wanted to overwrite their saved campaign */
function bool OnCheckpointCorrupted(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	local GearPC PC;
	local LocalPlayer LP;

	PC = GetGearPC();
	LP = LocalPlayer(PC.Player);

	if (SelectedInputAlias == 'AcceptOverwrite' &&
		PC.OnlineSub != None &&
		LP != None)
	{
		if (PC.OnlineSub.ContentInterface != None)
		{
			// Delete the content package that contains all 3 checkpoints
			PC.OnlineSub.ContentInterface.DeleteSaveGame(LP.ControllerId,PC.GetDeviceId(),class'Checkpoint'.default.DisplayName,"GearsCheckpoint");
		}
	}
	return true;
}

/** Function called to start the process of starting a campaign session */
function bool StartCampaign()
{
	local int CurrSlot;
	local GearEngine Engine;
	local GearPC PC;
	local LocalPlayer LP;
	local string SaveFileName;
	local array<byte> SaveData;

	Engine = GearEngine(class'Engine'.static.GetEngine());
	PC = GetGearPC();
	LP = LocalPlayer(PC.Player);

	// Don't need to check for checkpoint in Join-Coop mode
	if (SelectedCampMode != eGCAMPMODE_Join)
	{
		// Prepare the checkpoint system for access
		if (PrepareCheckpointSystem())
		{
			// Retrieve the save slot being used
			CurrSlot = Max(0,SelectedSaveSlot);
			SaveFileName = "GearsCheckpoint" $ CurrSlot $ ".sav";
			if (PC.OnlineSub != None &&
				LP != None &&
				PC.OnlineSub.ContentInterface != None)
			{
				// Get the data for this save slot
				PC.OnlineSub.ContentInterface.GetSaveGameData(LP.ControllerId,
					PC.GetDeviceId(),
					class'Checkpoint'.default.DisplayName,
					"GearsCheckpoint",
					SaveFileName,
					SaveData);
				// Set the checkpoint to use
				Engine.SetCheckpoint(CurrSlot,SaveData);
			}
			// If the checkpoint is valid start the campaign
			if (Engine.CurrentCheckpoint != None &&
				!Engine.CurrentCheckpoint.CheckpointIsEmpty())
			{
				SaveProfileAndHostCampaign();
				return true;
			}
		}
		// Couldn't prepare the checkpoint system (no device set)
		else
		{
			// Not using the checkpoint
			bUseCheckpoint = false;
			// Set the flag in the Engine for whether we are currently saving checkpoints to disk
			Engine.bShouldWriteCheckpointToDisk = false;
		}
	}

	SaveProfileAndHostCampaign();
	return true;
}

/** Save the profile and start the campaign */
function SaveProfileAndHostCampaign()
{
	local GearPC GPC;

	// Save profile before creating the campaign
	GPC = GearPC(GetPC());
	if ( GPC != None )
	{
		GPC.ProfileSettings.SetProfileSettingValueInt(`LastGameType,eGLGT_Campaign);
		SaveProfile(StartCampaignAfterProfileWrite);
	}
}

/** Called when the profile is done writing - builds the URL and starts the match */
function StartCampaignAfterProfileWrite(byte LocalUserNum,bool bWasSuccessful)
{
	local GearPC GPC;
	local GearUIManager UIManager;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	//Reset the history
	UIManager.MainMenuHistoryLength = 1;
	UIManager.LastSelectedIndex = 0;

	GPC = GearPC(GetPC());
	GPC.ClearSaveProfileDelegate(StartCampaignAfterProfileWrite);

	// If we are attempting to join a public match
	if (SelectedCampMode == eGCAMPMODE_Join)
	{
		// Start searching for a coop game session
		PublicCoopSearchThenJoin(LocalUserNum);
	}
	// Else create one
	else
	{
		// Do the travel
		TravelToCampaign();
	}
}

/** 
 *  Function that stores any selected mutators into the GLP
 *  @param bIsArcadeMutators - whether or not the mutators should be stored for arcade or for horde
 *  @param bWipeMutators - if true, instead of saving the data from the PartyGRI, it will empty the GLP's data
 */
function SaveMutators(bool bIsArcadeMutators, optional bool bWipeMutators)
{
	local int i;
	local GearPartyGRI PartyGRI;
	local GearLocalPlayer GLP;

	PartyGRI = GearPartyGRI(GetGRI());
	GLP =GearLocalPlayer(GetLP());

	if (bIsArcadeMutators)
	{
		for (i = 0; i < GLP.NUM_SELECTED_MUTATORS; i++)
		{
			if (bWipeMutators)
			{
				GLP.ArcadeSelectedMutators[i] = PartyGRI.NO_MUTATOR;
			}
			else
			{
				GLP.ArcadeSelectedMutators[i] = PartyGRI.SelectedMutators[i];
			}
		}
	}
	else
	{
		for (i = 0; i < GLP.NUM_SELECTED_MUTATORS; i++)
		{
			if (bWipeMutators)
			{
				GLP.HordeSelectedMutators[i] = PartyGRI.NO_MUTATOR;
			}
			else
			{
				GLP.HordeSelectedMutators[i] = PartyGRI.SelectedMutators[i];
			}
		}
	}
}

/** 
 *  Function that restores selected mutators from the GLP
 *  @param bIsArcadeMutators - whether or not the mutators should be restored for arcade or for horde
 */
function RestoreMutators(bool bIsArcadeMutators)
{
	local int i;
	local GearPartyGRI PartyGRI;
	local GearLocalPlayer GLP;

	PartyGRI = GearPartyGRI(GetGRI());
	GLP =GearLocalPlayer(GetLP());

	if (bIsArcadeMutators)
	{
		for (i = 0; i < GLP.NUM_SELECTED_MUTATORS; i++)
		{
			PartyGRI.SelectedMutators[i] = GLP.ArcadeSelectedMutators[i];
		}
	}
	else
	{
		for (i = 0; i < GLP.NUM_SELECTED_MUTATORS; i++)
		{
			PartyGRI.SelectedMutators[i] = GLP.HordeSelectedMutators[i];
		}
	}
	//Now tell the UI to update them!
	UpdateMutatorSelection();
}

/** Actually prepares and does the game travel */
function TravelToCampaign()
{
	local GearPartyGame_Base PartyGame;
	local String URL;
	local GearLocalPlayer GLP;
	local GearUIManager UIManager;
	local int i;
	local bool bIsUsingMutators;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != none)
	{
		for (i = 0; i < UIManager.MainMenuHistoryLength; i++)
		{
			if (UIManager.MainMenuHistory[i].Screen == MAINMENUOP_Arcade_MutatorSelection )
			{
				bIsUsingMutators = true;
				break;
			}
		}
	}

	GLP = GearLocalPlayer(GetLP());
	PartyGame = GetPartyGame();
	if (PartyGame != None && GLP != None)
	{
		// Create the URL and launch the game
		URL = PartyGame.BuildCampaignURL(SelectedChapter, bUseCheckpoint, bCampaignIsArcade);

		if (bIsUsingMutators)
		{
			URL $= GLP.BuildMutatorURLSection(GLP.ArcadeSelectedMutators);
		}
		`Log("Launching campaign with URL '"$URL$"'");
		GetWorldInfo().ServerTravel(URL);
	}
}

/** Builds a coop search object and searches for a match */
function PublicCoopSearchThenJoin(byte LocalUserNum)
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	ButtonAliases.AddItem('GenericYes');
	ButtonAliases.AddItem('GenericNo');

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('LaunchRankedMatch',
		"<Strings:GearGameUI.MessageBoxStrings.StartMatchmaking_Title>",
		"<Strings:GearGameUI.MessageBoxStrings.StartMatchmaking_Message>",
		ButtonAliases,
		OnLaunchPublicCoopCheckComplete);
}

/** Return from the prompt asking if the player wanted to launch a ranked match */
function bool OnLaunchPublicCoopCheckComplete(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'GenericYes')
	{
		LaunchPublicCoopMatch();
	}
	return true;
}

/** Does the remaining checks needed to launch coop matchmaking */
function LaunchPublicCoopMatch()
{
	local bool bResult;
	local int NumPRIs;
	local GearPartyGame_Base PartyGame;
	local GearPartyGRI PartyGRI;
	local int PartyTeamSize;
	local string AlteredMsgString;
	local array<name> ButtonAliases;
	local GearUIManager UIManager;

	// Cancel matchmaking if already running
	if (!IsMatchmaking(true))
	{
		PartyGRI = GearPartyGRI(GetGRI());
		NumPRIs = GetNumValidPRIs();
		PartyGame = GetPartyGame();
		PartyTeamSize = PartyGame.GetPartyTeamSize();
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

		// Make sure this is the party leader
		if (IsPartyLeader())
		{
			// Don't allow clicking create/start/find while a player is joining
			if (PartyGRI.ConnectingPlayerCount <= 0 &&
				NumPRIs == PartyGRI.PRIArray.Length)
			{
				if (IsAllowedToCreateMatch())
				{
					// Send error message if there are too many players
					if (NumPRIs > PartyTeamSize)
					{
						AlteredMsgString = Localize("MessageBoxErrorStrings", "GameErrorTooManyPlayers_Msg", "GearGameUI");
						AlteredMsgString = Repl(AlteredMsgString, "\`NUMPLAYERS\`", string(NumPRIs-PartyTeamSize));
						ButtonAliases.AddItem('GenericContinue');
						UIManager.ShowUIMessage('NumPlayersError',
							"<Strings:GearGameUI.MessageBoxErrorStrings.GameErrorTooManyPlayers_Title>",
							AlteredMsgString,
							ButtonAliases,
							OnMatchmakingError_Confirmed);
						bResult = false;
					}
					
					`log("Creating match for player" @ LocalPlayerOwnerIndex);
					if (CreateMatch())
					{
						bResult = true;
					}
				}
				else if (IsAllowedToSearchForMatches())
				{
					if (PartyGRI != None && PartyGRI.bPartyLobbyErrorExists)
					{
						if (NumPRIs > PartyTeamSize)
						{
							AlteredMsgString = Localize("MessageBoxErrorStrings", "MatchErrorTooManyPlayers_Msg", "GearGameUI");
							AlteredMsgString = Repl(AlteredMsgString, "\`NUMPLAYERS\`", string(NumPRIs-PartyTeamSize));
							ButtonAliases.AddItem('GenericContinue');
							UIManager.ShowUIMessage('MatchmakeError',
								"<Strings:GearGameUI.MessageBoxErrorStrings.MatchErrorTooManyPlayers_Title>",
								AlteredMsgString,
								ButtonAliases,
								OnMatchmakingError_Confirmed);
						}
					}
					else
					{
						if (PartyGRI.MatchmakingState == MMS_NotMatchmaking)
						{
							`log("Starting match search for player" @ LocalPlayerOwnerIndex);
							if (FindMatch())
							{
								bResult = true;
							}
							else
							{
								`Log("Find match failed");
							}
						}
						else
						{
							`log("Matchmaking has already started" @ LocalPlayerOwnerIndex
								$" MatchmakingState="$PartyGRI.MatchmakingState);
						}
					}
				}
			}
			else
			{
				`Log("Failed the block while connecting check ConnectingPlayerCount("
					$PartyGRI.ConnectingPlayerCount$") NumPRIs("$NumPRIs$") PRIArray.Length("$PartyGRI.PRIArray.Length$")");
			}
		}
		else
		{
			`Log("Failed the IsPartyLeader() check");
		}
	}
	else
	{
		`log("Canceling match search for player" @ LocalPlayerOwnerIndex);
		if (CancelMatchmaking())
		{
			bResult = true;
		}
		else
		{
			`Log("Cancel matchmaking failed");
		}
	}
	

	if (!bResult)
	{
		`Log("Matchmaking failed to start");
	}

	// We hit an error and couldn't creat the match this will unblock the input
	ContinueFromHaltedState(false);
}

/** Tells the user that no matches were found and unblocks the UI upon closing */
function ShowNoMatchesFoundUI()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	ButtonAliases.AddItem('GenericAccept');

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('ConfirmNetworkedPlayersKicked',
		"<Strings:GearGameUI.MessageBoxStrings.NoCoopGamesFound_Title>",
		"<Strings:GearGameUI.MessageBoxStrings.NoCoopGamesFound_Desc>",
		ButtonAliases,
		OnNoMatchesFoundDismissed);
}

/** Unlocks the UI so they can change parameters for their searches */
function bool OnNoMatchesFoundDismissed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	return true;
}

/** Called when the error message closes for a player who isn't logged in */
function bool OnControllerNotLoggedIn_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	return true;
}

/**
 * Constructs an unrealscript version of the actionscript history and saves it to the player's GearLocalPlayer
 * @param HistoryArray - the GFx History Array object
 * @param LastSelectedIndex - the index into the currently selected item
 */
function SaveHistory(GFxObject HistoryArray, byte LastSelectedIndex)
{
	local GearUIManager UIManager;
	local GFxObject GFxItem;
	local int ArrLength, i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != none)
	{
		ArrLength = HistoryArray.GetFloat("length");
		if (ArrLength > `MAX_HISTORY_LENGTH)
		{
			`log("HISTORY ARRAY LENGTH IS TOO LONG!!");
		}
		else
		{
			UIManager.MainMenuHistoryLength = ArrLength;
			for (i = 0; i < ArrLength; i++)
			{
				GFxItem = HistoryArray.GetElementObject(i);
				UIManager.MainMenuHistory[i].Screen = byte(GFxItem.GetFloat("Screen"));
				UIManager.MainMenuHistory[i].SelectedOption = byte(GFxItem.GetFloat("Choice"));
			}

			UIManager.LastSelectedIndex = LastSelectedIndex;
		}
	}
}


/**
 * Function that will tell actionscript to match the history currently stored in the UIManager
 * @param CurrentSelection - the currently selected option in the menu
 */
function SynchMenuToStoredHistory(int CurrentSelection)
{
	local GFxObject HistoryArray;
	local byte CurrMenuOption;
	local GearUIManager UIManager;
	local MMHistoryItem HistItem;
	local byte bWantToContinue;
	local int i;

	//Okay if we are the server now we need to run each selection made by HandleMenuSelection to see if they're all valid
	//If they are not valid, we need to synch to the first point that is invalid
	if (GetPC().Role == ROLE_Authority)
	{
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		for (i = 0; i < UIManager.MainMenuHistoryLength; i++)
		{
			HistItem = UIManager.MainMenuHistory[i];
			if (!HandleMenuSelection(HistItem.Screen, HistItem.SelectedOption, true,bWantToContinue))
			{
				UIManager.MainMenuHistoryLength = i;
				CurrentSelection = HistItem.SelectedOption;
				break;
			}
		}
	}

	//If we were stopped before finishing going through the entire history, then shorten size of our history!
	UIManager.MainMenuHistoryLength = i;

	//Update the mutator selection page selections as well
	UpdateMutatorSelection();

	//Now synch the history over
	HistoryArray = GetHistory();
	SetMenuToHistory(HistoryArray, CurrentSelection, true);

	// Tell the small party panel that the screen changed
	if (SmallPartyPanel != None)
	{
		if (GetCurrentScreenAndSelection(CurrMenuOption,))
		{
			SmallPartyPanel.MainMenuScreenChangedCallback(CurrMenuOption);
		}
	}
}

/** 
 *  Constructs the GFx representation of the main menu history from the array kept in the UIUIManager
 *  @return The GFx representation of the main menu history
 */
function GFxObject GetHistory()
{
	local GearUIManager UIManager;
	local int i;
	local GFxObject HistoryArray, HistoryObject;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	HistoryArray = CreateArray(); 
	for (i = 0; i < UIManager.MainMenuHistoryLength; i++)
	{
		HistoryObject = CreateObject("Object");
		HistoryArray.SetElementObject(i,HistoryObject);
		HistoryObject.SetFloat("Screen",UIManager.MainMenuHistory[i].Screen);
		HistoryObject.SetFloat("Choice",UIManager.MainMenuHistory[i].SelectedOption);
	}

	return HistoryArray;
}

/**
 * Helper function the get the current screen and the current selection
 * @param CurrentScreen - The current screen
 * @param CurrentSelection - The current selection
 * 
 * @return TRUE if it was able to successfully get the information
 */
function bool GetCurrentScreenAndSelection(optional out byte CurrentScreen, optional out int CurrentSelection)
{
	local GearUIManager UIManager;
	local GearPartyGRI PartyGRI;
	local MMHistoryItem LastChoice;

	CurrentSelection = 0;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	PartyGRI = GearPartyGRI(GetGRI());
	if (UIManager == none || PartyGRI == none)
	{
		return false;
	}
	if (UIManager.MainMenuHistoryLength == 0)
	{
		CurrentScreen = StartScreen;
	}
	else
	{
		LastChoice = UIManager.MainMenuHistory[UIManager.MainMenuHistoryLength-1];
		if (MainMenuMovie.MenuData == none)
		{
			return false;
		}
		CurrentScreen = byte(MainMenuMovie.MenuData.GetElementObject(LastChoice.Screen).GetObject("Options").GetElementObject(LastChoice.SelectedOption).GetFloat("Next"));
	}

	//The host checks his scene client. The client trusts the PRI.
	if (GetPC().Role == ROLE_Authority)
	{
		CurrentSelection = UIManager.LastSelectedIndex;
		PartyGRI.CurrMenuSelection = CurrentSelection;
	}
	else
	{
		CurrentSelection = PartyGRI.CurrMenuSelection;
		UIManager.LastSelectedIndex = CurrentSelection;
	}

	return true;
}

/**
 * Helper function used to get the selection made on a given screen from the history
 * 
 * @param Screen - the enum value for the screen you want to get the selection for
 * @return The selection index the player chose for the given screen
 */
function int GetSelectionFromScreen(byte Screen)
{
	local int Selection;
	local int i, ActNum;
	local GearUIManager UIManager;

	Selection = INDEX_NONE;

	//Exception case for the chapter select hack
	//Note that MAINMENUOP_SPChapterSelect is not an actual screen that can be selected, it is a shortcut for 'whatever chapter select screen was used'
	//which is determined by which act was selected...so we first deduce what act was selected, and then use that to find the real chapter select screen.
	if (Screen == MAINMENUOP_SPChapterSelect)
	{
		ActNum = GetSelectionFromScreen(MAINMENUOP_SPActSelect);
		if (ActNum == INDEX_NONE)
		{
			return INDEX_NONE;
		}
		else
		{
			Screen = MAINMENUOP_MAX + ActNum;
		}
	}

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	if (UIManager != none)
	{
		for (i = 0; i < UIManager.MainMenuHistoryLength; i++)
		{
			if (UIManager.MainMenuHistory[i].Screen == Screen)
			{
				return UIManager.MainMenuHistory[i].SelectedOption;
			}
		}
	}

	return Selection;
}

/** 
 *  Sets the UI to the history array provided
 *  This should be used when we have received a new history from the host and want to match it.
 *  
 *  @param HistoryArray - the history array to jump to
 *  @param CurrentSelection - What the current selected index is
 *  @param bAnimate - TRUE to animate to it, FALSE to jump to it.
 *                      Note that if the history provided is too different from the current history, 
 *                      it will jump regardless of whether or not an animation was requested.
 */
simulated function SetMenuToHistory(GFxObject HistoryArray, int CurrentSelection, bool bAnimate)
{
	local array<ASValue> args;
	local ASValue ASVal;

	//Set the NewMenuHistory object to the HistoryArray so it can be accessed when we call into flash
	MainMenuMovie.SetObject("NewMenuHistory",HistoryArray);

	ASVal.Type = AS_Number;
	ASVal.n = CurrentSelection;
	args.AddItem(ASVal);

	ASVal.Type = AS_Boolean;
	ASVal.b = bAnimate;
	args.AddItem(ASVal);

	//Call into actionscript to let it know we want to do a transition to a stored history
	MainMenuMovie.Invoke("SetMenuToHistory",args);
}

/**
 * Function to change the selected item on the current screen
 * This should be used when we want to change selection but not switch screens
 * 
 * @param NewSelection - the index to change selection to
 */
simulated function SetMenuSelection(int NewSelection)
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_Number;
	ASVal.n = NewSelection;
	args.AddItem(ASVal);

	//Call into actionscript to let it know we want to do a transition to a stored history
	MainMenuMovie.Invoke("SetMenuSelection",args);
}


/**
 * Called when a match mode was selected for Horde or Siege
 *
 * @param SelectedOption - The index in the list to tell us which match mode was selected
 * @param bIsSimulating - Whether or not this is a simulated run (for synching to history) or if it is actually the player choosing this right now
 */
function bool HandleHordeAndSiegeMatchModeSelection(int SelectedOption, bool bIsSimulating)
{
	local EGearVersusMatchType NewMatchMode;
	local bool bIsLIVEParty;
	local bool bIsLANParty;
	local bool bIsLocal;
	local GearPartyGame_Base PartyGame;
	local OnlineGameSettings PartySession;
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local GearPartyGRI PartyGRI;

	// Set the match enum
	SelectedMPMode = (SelectedOption == 0) ? eGVMM_Social : eGVMM_Custom;
	CurrMatchmakingMode = eGMATCHMAKINGMODE_Versus;

	//If this is simulated and not custom, then the next screen is matchmaking, stop the simulation here
	if (bIsSimulating && SelectedMPMode != eGVMM_Custom )
	{
		return false;
	}

	// Get some helper variable for determining party type
	PartySession = GetPartySession();
	if (PartySession != None)
	{
		bIsLANParty = PartySession.bIsLanMatch;
		bIsLIVEParty = !bIsLANParty;
	}
	// Else is a local party
	else
	{
		bIsLocal = true;
	}

	PartyGame = GetPartyGame();
	PartyGRI = GearPartyGRI(PartyGame.GameReplicationInfo);

	// Get the playlist so we can get the proper team sizes
	CurrPlaylistId = GetPlaylistIdForGameType((PartyGRI.VersusGameType == CONTEXT_VERSUSMODES_HORDE) ? eGEARMP_Horde : eGEARMP_Siege);
	PartyGRI.SetPlaylist(CurrPlaylistId);

	// See if we can actually transition to the match mode
	if (AttemptNetworkedMatchTransition(bIsLIVEParty, bIsLANParty, bIsLocal))
	{
		// Determine which match mode the gameinfo needs to prepare
		NewMatchMode = DetermineMatchMode(bIsLIVEParty, bIsLANParty);
		// Set the match mode in the gameinfo
		PartyGame.SetCurrentMatchMode(NewMatchMode);

		// Update the GRI with the match mode so clients can replicate
		UpdateMatchMode(PartyGame.CurrMatchMode);

		// If they selected a social match, start it
		if (NewMatchMode == eGVMT_Player)
		{
			CurrPlaylistId = GetPlaylistIdForGameType((PartyGRI.VersusGameType == CONTEXT_VERSUSMODES_HORDE) ? eGEARMP_Horde : eGEARMP_Siege);
			PartyGRI.SetPlaylist(CurrPlaylistId);
			// Update the party game with the new match mode (Must happen after playlist is set)
			PartyGame.ChangeMatchModeSettings(PartyGame.PartySettings, PartyGame.CurrMatchMode, GearPC(GetPC()).ProfileSettings);

			ButtonAliases.AddItem('GenericYes');
			ButtonAliases.AddItem('GenericNo');

			UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
			UIManager.ShowUIMessage('LaunchRankedMatch',
				"<Strings:GearGameUI.MessageBoxStrings.StartMatchmaking_Title>",
				"<Strings:GearGameUI.MessageBoxStrings.StartMatchmaking_Message>",
				ButtonAliases,
				OnLaunchPlaylistMatchCheckComplete);

			//DONT let the ui go forwards until the messagebox returns. If the player cancels, the ui should not move
			return false;
		}
		else
		{
			// Update the party game with the new match mode
			PartyGame.ChangeMatchModeSettings(PartyGame.PartySettings, PartyGame.CurrMatchMode, GearPC(GetPC()).ProfileSettings);
		}

		return true;
	}
	else
	{
		// Need to tell UI to NOT go forward
		return false;
	}
}

/** 
 *  Returns the first playlist id of a given match type passed in 
 *  
 *  @param MPType - the game mode to search for
 *  @param bRanked - Whether or not to return the playlist id for the ranked version
 *  
 *  @return the playlist id of the first playlist that is of the given MP Game Mode 
 */
function int GetPlaylistIdForGameType(EGearMPTypes MPType, optional bool bRanked)
{
	local GearOnlinePlaylistProvider PlaylistProvider;
	local array<UIResourceDataProvider> PlaylistProviders;
	local int ProvIdx;
	local int GameIdx;
	local int ConvertedIdx;
	local GearGamePlaylistGameTypeProvider GameTypeProv;
	local UIDataStore_OnlinePlaylists PlaylistDS;

	// Get the playlist datastore
	PlaylistDS = UIDataStore_OnlinePlaylists(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlinePlaylists'.default.Tag));

	// Get the social providers out of the datastore
	if (PlaylistDS != None &&
		PlaylistDS.GetResourceProviders(name(class'UIDataStore_OnlinePlaylists'.const.UNRANKEDPROVIDERTAG), PlaylistProviders))
	{
		// Loop through the providers
		for (ProvIdx = 0; ProvIdx < PlaylistProviders.Length; ProvIdx++)
		{
			PlaylistProvider = GearOnlinePlaylistProvider(PlaylistProviders[ProvIdx]);
			if (PlaylistProvider != None)
			{
				// Loop through the games within the provider
				for (GameIdx = 0; GameIdx < PlaylistProvider.PlaylistGameTypeNames.Length; GameIdx++)
				{
					// Convert the gametype into a provider index into the gametyp providers of the gameresource datastore
					ConvertedIdx = class'GearUIDataStore_GameResource'.static.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex(PlaylistProvider, GameIdx);
					// Return the playlist id of the provider if we found a match
					GameTypeProv = class'GearUIDataStore_GameResource'.static.GetPlaylistGameTypeProvider(ConvertedIdx);
					if (GameTypeProv.MPGameMode == MPType)
					{
						if (bRanked)
						{
							return PlaylistProvider.RankedPlaylistId;
						}
						else
						{
							return PlaylistProvider.PlaylistId;
						}
					}
				}
			}
		}
	}
	return INDEX_NONE;
}

/** Called when Horde is selected from the main menu */
function bool HandleHordeSelection()
{
	// Update the GRI with the versus game type so clients can replicate
	UpdateVersusGameType(CONTEXT_VERSUSMODES_HORDE);
	return true;
}

/** Called when Siege is selected from the main menu */
function bool HandleSiegeSelection()
{
	// Update the GRI with the versus game type so clients can replicate
	UpdateVersusGameType(CONTEXT_VERSUSMODES_SIEGE);
	return true;
}

/** Determines the match mode based on the kind of party session created */
function EGearVersusMatchType DetermineMatchMode(bool bIsLIVEParty, bool bIsLANParty)
{
	// LIVE parties have 3 potential match modes, so figure out which one it is
	// based off the menu selection
	if (bIsLIVEParty)
	{
		if (SelectedMPMode == eGVMM_Ranked)
		{
			return eGVMT_Official;
		}
		else if (SelectedMPMode == eGVMM_Social)
		{
			return eGVMT_Player;
		}
		else
		{
			return eGVMT_Custom;
		}
	}
	// LAN party is a system link match mode
	else if (bIsLANParty)
	{
		return eGVMT_SystemLink;
	}

	// Local match mode
	return eGVMT_Local;
}

/**
 * Called when a match mode was selected in the versus screen
 *
 * @param SelectedOption - The index in the list to tell us which match mode was selected
 * @param bIsSimulating - Whether or not this is a simulated run (for synching to history) or if it is actually the player choosing this right now
 *
 * @return - Whether the match mode selection was successful and the front end can carry on
 */
function bool HandleVersusMatchModeSelection(int SelectedOption, bool bIsSimulating)
{
	local EGearVersusMatchType NewMatchMode;
	local bool bIsLIVEParty;
	local bool bIsLANParty;
	local bool bIsLocal;
	local GearPartyGame_Base PartyGame;
	local OnlineGameSettings PartySession;
	local GearPartyGRI PartyGRI;
	local GearUIDataStore_GameResource GameResourceDS;
	local UIDataStore_OnlinePlaylists PlaylistDS;
	local OnlinePlaylistProvider PlaylistProv;
	local int ProviderIndex;
	local GearGamePlaylistGameTypeProvider GameTypeProvider;
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local int PlaylistSelection;

	//If this is simulating and not custom, then matchmaking comes next, so stop the simulation!
	if (bIsSimulating && SelectedOption != eGVMM_Custom)
	{
		return false;
	}

	// Cast the menu option into the match enum
	SelectedMPMode = EGearsMPMode(SelectedOption);
	PlaylistSelection = GetSelectionFromScreen(MAINMENUOP_VS_Playlists);
	CurrMatchmakingMode = eGMATCHMAKINGMODE_Versus;

	// Get some helper variable for determining party type
	PartySession = GetPartySession();
	if (PartySession != None)
	{
		bIsLANParty = PartySession.bIsLanMatch;
		bIsLIVEParty = !bIsLANParty;
	}
	// Else is a local party
	else
	{
		bIsLocal = true;
	}

	// See if we can actually transition to the match mode
	if (AttemptNetworkedMatchTransition(bIsLIVEParty, bIsLANParty, bIsLocal))
	{
		// Determine which match mode the gameinfo needs to prepare
		NewMatchMode = DetermineMatchMode(bIsLIVEParty, bIsLANParty);

		// Set the match mode in the gameinfo
		PartyGame = GetPartyGame();
		PartyGame.SetCurrentMatchMode(NewMatchMode);
		// Update the GRI with the match mode so clients can replicate
		UpdateMatchMode(PartyGame.CurrMatchMode);

		// Set the initial playlist id so the UI can handle the party panel
		if (SelectedOption == eGVMM_Ranked || SelectedOption == eGVMM_Social)
		{
			PartyGRI = GearPartyGRI(GetGRI());
			if (SelectedOption == eGVMM_Ranked)
			{
				CurrPlaylistId = MainMenuMovie.MenuData.GetElementObject(MAINMENUOP_VS_Playlists).GetObject("Options").GetElementObject(PlaylistSelection).GetFloat("RankedPlaylistID");
			}
			else
			{
				CurrPlaylistId = MainMenuMovie.MenuData.GetElementObject(MAINMENUOP_VS_Playlists).GetObject("Options").GetElementObject(PlaylistSelection).GetFloat("PlaylistID");
			}
			PartyGRI.SetPlaylist(CurrPlaylistId);

			// Update the match mode settings now that we know which game settings object is being used (must happen after playlist id is set)
			PartyGame.ChangeMatchModeSettings(PartyGame.PartySettings, PartyGame.CurrMatchMode, GearPC(GetPC()).ProfileSettings);
			
			ButtonAliases.AddItem('GenericYes');
			ButtonAliases.AddItem('GenericNo');

			UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
			UIManager.ShowUIMessage('LaunchRankedMatch',
						"<Strings:GearGameUI.MessageBoxStrings.StartMatchmaking_Title>",
						"<Strings:GearGameUI.MessageBoxStrings.StartMatchmaking_Message>",
						ButtonAliases,
						OnLaunchPlaylistMatchCheckComplete);
			return false;
		}
		//If custom is chosen, need to update
		else if (SelectedOption == eGVMM_Custom)
		{
			CurrPlaylistId = MainMenuMovie.MenuData.GetElementObject(MAINMENUOP_VS_Playlists).GetObject("Options").GetElementObject(PlaylistSelection).GetFloat("PlaylistID");
			// Update the match mode settings now that we know which game settings object is being used (must happen after playlist id is set)
			PartyGame.ChangeMatchModeSettings(PartyGame.PartySettings, PartyGame.CurrMatchMode, GearPC(GetPC()).ProfileSettings);
			GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
			PlaylistDS = UIDataStore_OnlinePlaylists(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlinePlaylists'.default.Tag));
			if (GameResourceDS != None &&
				PlaylistDS != None)
			{
				PlaylistProv = PlaylistDS.GetOnlinePlaylistProvider(name(class'UIDataStore_OnlinePlaylists'.const.UNRANKEDPROVIDERTAG), CurrPlaylistId );
				if (PlaylistProv != none)
				{
					ProviderIndex = GameResourceDS.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex( PlaylistProv, 0 );
					if (ProviderIndex != INDEX_NONE)
					{
						GameTypeProvider = GameResourceDS.GetPlaylistGameTypeProvider( ProviderIndex );
						if (GameTypeProvider != None)
						{
							HandleCustomMatchSelection(GameTypeProvider.MPGameMode);
						}
					}
				}
			}
		}
		else
		{
			// Update the match mode settings now that we know which game settings object is being used
			PartyGame.ChangeMatchModeSettings(PartyGame.PartySettings, PartyGame.CurrMatchMode, GearPC(GetPC()).ProfileSettings);
		}

		// Need to tell UI that all is good
		return true;
	}
	else
	{
		// Need to tell UI to NOT go forward
		return false;
	}
}

/** Does the remaining checks needed to launch a ranked match */
function LaunchPlaylistMatch()
{
	local bool bResult;
	local int NumPRIs;
	local GearPartyGame_Base PartyGame;
	local GearPartyGRI PartyGRI;
	local int PartyTeamSize;
	local string AlteredMsgString;
	local array<name> ButtonAliases;
	local GearUIManager UIManager;

	// Make sure this is the party leader
	if (!IsMatchmaking(true))
	{
		PartyGRI = GearPartyGRI(GetGRI());
		NumPRIs = GetNumValidPRIs();
		PartyGame = GetPartyGame();
		PartyTeamSize = PartyGame.GetPartyTeamSize();
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

		if (IsPartyLeader())
		{
			// Display a message if a full horde party is hosted by a splitscreen host and they trying to start a public match
			if (PartyGRI.TeamCount == 1 &&
				(IsOfficialMatch() || IsPlayerMatch()) &&
				NumPRIs == PartyTeamSize &&
				PartyTeamSize > 2 &&
				GetNumLocalPlayers() > 1)
			{
				ButtonAliases.AddItem('GenericContinue');
				UIManager.ShowUIMessage('NotEnoughPlayers',
					"<Strings:GearGameUI.MessageBoxErrorStrings.NoSplitscreenFullPublicHorde_Title>",
					"<Strings:GearGameUI.MessageBoxErrorStrings.NoSplitscreenFullPublicHorde_Message>",
					ButtonAliases,
					OnMatchmakingError_Confirmed);
				bResult = false;
			}
			// Don't allow clicking create/start/find while a player is joining
			else if (PartyGRI.ConnectingPlayerCount <= 0 &&
					 NumPRIs == PartyGRI.PRIArray.Length)
			{
				if (IsAllowedToCreateMatch())
				{
					// Send error message if there are too many players
					if (NumPRIs > PartyTeamSize)
					{
						AlteredMsgString = Localize("MessageBoxErrorStrings", "GameErrorTooManyPlayers_Msg", "GearGameUI");
						AlteredMsgString = Repl(AlteredMsgString, "\`NUMPLAYERS\`", string(NumPRIs-PartyTeamSize));
						ButtonAliases.AddItem('GenericContinue');
						UIManager.ShowUIMessage('NumPlayersError',
							"<Strings:GearGameUI.MessageBoxErrorStrings.GameErrorTooManyPlayers_Title>",
							AlteredMsgString,
							ButtonAliases,
							OnMatchmakingError_Confirmed);
						bResult = false;
					}
					else if (IsOfficialMatch() && PartyMemberIsAGuest())
					{
						if (Len(MatchErrorNoGuestInPublic) > 0)
						{
							ButtonAliases.AddItem('GenericContinue');
							UIManager.ShowUIMessage('MatchmakeError',
								"<Strings:GearGameUI.MessageBoxErrorStrings.StartMPGameFailed_Title>",
								"<Strings:GearGameUI.MessageBoxErrorStrings.NoGuestInPublic_Msg>",
								ButtonAliases,
								OnMatchmakingError_Confirmed);
						}
						bResult = false;
					}
					else if (PartyGame.LobbyHasEnoughPlayers())
					{
						`log("Creating match for player" @ LocalPlayerOwnerIndex);
						if (CreateMatch())
						{
							bResult = true;
						}
						else
						{
							`Log("Failed to create match");
							bResult = false;
						}
					}
					else
					{
						ButtonAliases.AddItem('GenericContinue');
						UIManager.ShowUIMessage('NotEnoughPlayers',
							"<Strings:GearGameUI.MessageBoxErrorStrings.NotEnoughPlayers_Title>",
							"<Strings:GearGameUI.MessageBoxErrorStrings.NotEnoughPlayers_Message>",
							ButtonAliases,
							OnMatchmakingError_Confirmed);
						bResult = false;
					}
				}
				else if (IsAllowedToSearchForMatches())
				{
					if (PartyGRI != None && PartyGRI.bPartyLobbyErrorExists || PartyMemberLacksRequiredDLC(true))
					{
						if (NumPRIs > PartyTeamSize)
						{
							AlteredMsgString = Localize("MessageBoxErrorStrings", "MatchErrorTooManyPlayers_Msg", "GearGameUI");
							AlteredMsgString = Repl(AlteredMsgString, "\`NUMPLAYERS\`", string(NumPRIs-PartyTeamSize));
							ButtonAliases.AddItem('GenericContinue');
							UIManager.ShowUIMessage('MatchmakeError',
								"<Strings:GearGameUI.MessageBoxErrorStrings.MatchErrorTooManyPlayers_Title>",
								AlteredMsgString,
								ButtonAliases,
								OnMatchmakingError_Confirmed);
						}
						else if (IsOfficialMatch() && PartyMemberIsAGuest())
						{
							if (Len(MatchErrorNoGuestInPublic) > 0)
							{
								ButtonAliases.AddItem('GenericContinue');
								UIManager.ShowUIMessage('MatchmakeError',
									"<Strings:GearGameUI.MessageBoxErrorStrings.StartMPGameFailed_Title>",
									"<Strings:GearGameUI.MessageBoxErrorStrings.NoGuestInPublic_Msg>",
									ButtonAliases,
									OnMatchmakingError_Confirmed);
							}
							bResult = false;
						}
						else
						{
							ButtonAliases.AddItem('GenericContinue');
							UIManager.ShowUIMessage('MatchmakeError',
								"<Strings:GearGameUI.MessageBoxErrorStrings.MatchErrorMissingDLC_Title>",
								"<Strings:GearGameUI.MessageBoxErrorStrings.MatchErrorMissingDLC_Msg>",
								ButtonAliases,
								OnMatchmakingError_Confirmed);
						}
					}
					else
					{
						if (PartyGRI.MatchmakingState == MMS_NotMatchmaking)
						{
							`log("Starting match search for player" @ LocalPlayerOwnerIndex);
							if (FindMatch())
							{
								bResult = true;
							}
							else
							{
								`Log("Find match failed");
							}
						}
					}
				}
			}
			else
			{
				`Log("Failed the block while connecting check ConnectingPlayerCount("$PartyGRI.ConnectingPlayerCount$") NumPRIs("$NumPRIs$") PRIArray.Length("$PartyGRI.PRIArray.Length$")");
				// Play an error sound
				//PlayUISound( 'Error' );
			}

			// We are matchmaking, so disable the click handler
			// since we want B-presses to cancel and those are handled
			// by the scene.
			if (bResult)
			{
				//MatchmakeButton.OnClicked = None;
				if (!IsOfficialMatch() &&
					!IsPlayerMatch())
				{
					bGameStarting = TRUE;
					//Success!
					return;
				}
			}
			else
			{
				`Log("Matchmaking failed to start");
			}
		}
		else
		{
			`Log("Failed the IsPartyLeader() check");
		}
	}
	else
	{
		`log("Canceling match search for player" @ LocalPlayerOwnerIndex);
		if (CancelMatchmaking())
		{
			bResult = true;
			// Play the sound as if we had clicked on the button
			//PlayUISound( ClickedCue );
			return;
		}
		else
		{
			`Log("Cancel matchmaking failed");
			// Play an error sound
			//PlayUISound( 'Error' );
		}
	}
	// We hit an error and couldn't create the match this will unblock the input
	if (bResult == false)
	{
		ContinueFromHaltedState(false);
	}
}

/**
 * Notifies the online subsystem to begin searching for a match.
 */
function bool FindMatch()
{
	local GearPartyGame_Base PartyGame;
	local bool bResult;

	PartyGame = GetPartyGame();
	if (PartyGame != None)
	{
		if (IsReadyToSearchForMatches())
		{
			bWaitingForMatchmakeToBegin = true;
			MainMenuMovie.SaveGameSettingsToProfile(OnFindMatchProfileWriteComplete);
			bResult = true;
		}
	}
	else
	{
		`log("Couldn't search for match because current game isn't GearPartyGame");
	}

	return bResult;
}

/** Called when the profile is done writing */
function OnFindMatchProfileWriteComplete(byte LocalUserNum,bool bWasSuccessful)
{
	local LocalPlayer LP;
	local GearPC GearPO;
	local GearPartyGame_Base PartyGame;

	PartyGame = GetPartyGame();

	LP = PartyGame.GetPlayerOwner(Class'UIInteraction'.static.GetPlayerIndex(LocalUserNum));
	GearPO = GearPC(LP.Actor);
	GearPO.ClearSaveProfileDelegate(OnFindMatchProfileWriteComplete);

	if(CurrMatchmakingMode == eGMATCHMAKINGMODE_Coop)
	{
		if (!PartyGame.StartCoopMatchmaking(LP.ControllerId,SelectedChapter))
		{
			bWaitingForMatchmakeToBegin = false;
		}
	}
	else
	{
		if (!PartyGame.StartPartyMatchmaking(LP.ControllerId))
		{
			bWaitingForMatchmakeToBegin = false;
		}
	}
}

/** Notifies the online subsystem to begin canceling the matchmaking process */
function bool CancelMatchmaking()
{
	local GearPartyGame_Base PartyGame;
	local GearPartyGRI GRI;
	local GearPartyPC PC;
	local int NumPRIs;
	local int TotalPlayerCount;

	GRI = GearPartyGRI(GetGRI());
	
	if (GRI != None &&
		GRI.MatchmakingState > MMS_CancelingMatchmaking &&
		GRI.MatchmakingState != MMS_ConnectingToOpposingParty)
	{
		NumPRIs = GetNumValidPRIs();
		TotalPlayerCount = GRI.TeamSize * GRI.TeamCount;

		if (GRI.TeamCount == 1 && TotalPlayerCount == NumPRIs + GRI.PartySlotsFilled)
		{
			// Horde match that is full, so no canceling
			return false;
		}
		else
		{
			PartyGame = GetPartyGame();
			if (PartyGame != None)
			{
				PartyGame.CancelPartyMatchmaking();
			}
			else
			{
				PC = GearPartyPC(GetPC());
				if (PC != None)
				{
					PC.ServerCancelMatchmaking();
				}
				else
				{
					return false;
				}
			}
			return true;
		}
	}

	return false;
}

/**
 * Called when a playlist is selected
 *
 * @param SelectedOption - The index in the playlist list that was selected
 */
function bool HandlePlaylistSelection(int SelectedOption)
{
	local GearPartyGRI PartyGRI;

	PartyGRI = GearPartyGRI(GetGRI());
	CurrPlaylistId = MainMenuMovie.MenuData.GetElementObject(MAINMENUOP_VS_Playlists).GetObject("Options").GetElementObject(SelectedOption).GetFloat("PlaylistID");
	PartyGRI.SetPlaylist(CurrPlaylistId);

	return true;
}

/** Return from the prompt asking if the player wanted to launch a playlist match */
function bool OnLaunchPlaylistMatchCheckComplete(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'GenericYes')
	{
		LaunchPlaylistMatch();
	}
	else
	{
		ContinueFromHaltedState(false);
	}
	return true;
}

/**
 * Called when a custom match was selected
 *
 * @param SelectedGameMode - The game mode that was selected
 */
function bool HandleCustomMatchSelection(EGearMPTypes SelectedGameMode)
{
	local int GameContextId;
	local GearPartyGame_Base PartyGame;

	// Determine which game mode was selected and get the context id for the settings object
	switch (SelectedGameMode)
	{
		// Newbie
		case eGEARMP_Newbie:
			GameContextId = CONTEXT_VERSUSMODES_NEWBIE;
			break;
		// Warzone
		case eGEARMP_Warzone:
			GameContextId = CONTEXT_VERSUSMODES_WARZONE;
			break;
		// Execution
		case eGEARMP_Execution:
			GameContextId = CONTEXT_VERSUSMODES_EXECUTION;
			break;
		// Capture the Leader
		case eGEARMP_CTL:
			GameContextId = CONTEXT_VERSUSMODES_CTL;
			break;
		// King of the Hill
		case eGEARMP_KOTH:
			GameContextId = CONTEXT_VERSUSMODES_KOTH;
			break;
		// Wingman
		case eGEARMP_Wingman:
			GameContextId = CONTEXT_VERSUSMODES_WINGMAN;
			break;
	}

	// Update the GRI with the versus game type so clients can replicate
	UpdateVersusGameType(GameContextId);

	// Update the match mode settings now that we know which game settings object is being used
	PartyGame = GetPartyGame();
	PartyGame.ChangeMatchModeSettings(PartyGame.PartySettings, PartyGame.CurrMatchMode, GearPC(GetPC()).ProfileSettings);
	// Update the GRI with the match mode so clients can replicate
	UpdateMatchMode(PartyGame.CurrMatchMode);

	return true;
}

/**
 * Called when a training grounds game was selected
 *
 * @param SelectedGametype - The gametype that was selected
 */
function bool HandleTrainingGroundsSelection(EGearMPTypes SelectedGametype)
{
	local bool bResult;

	// Leverage the same code us the custom match
	bResult = HandleCustomMatchSelection(SelectedGametype);

	// If we were able to handle the gametype
	if (bResult)
	{
		bResult = HandleCustomOptionsSelection(true);
	}

	return bResult;
}

/** Update the GRI with the match mode so clients can replicate */
simulated function UpdateMatchMode(EGearVersusMatchType MatchMode)
{
	local GearPartyGRI PartyGRI;
	local int SettingsIdx;
	local GearUIDataStore_GameSettings SettingsDS;
	local GearPC PC;

	PC = GearPC(GetPC());
	PartyGRI = GearPartyGRI(GetGRI());
	if (PartyGRI != None)
	{
		// Server sets the GRI
		if (PartyGRI.Role == ROLE_Authority)
		{
			PartyGRI.MatchMode = MatchMode;
			PartyGRI.bForceNetUpdate = true;
			PartyGRI.bNetDirty = true;
		}

		// Get the datastore where the game settings live
		SettingsDS = GearUIDataStore_GameSettings(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameSettings'.default.Tag, None));
		// Make sure we have a valid datastore and profile
		if (SettingsDS != None)
		{
			// Iterate over all custom game settings objects
			for (SettingsIdx = 0; SettingsIdx < SettingsDS.GameSettingsCfgList.Length; SettingsIdx++)
			{
				SettingsDS.GameSettingsCfgList[SettingsIdx].GameSettings.SetStringSettingValue(`VERSUS_MATCH_MODE, MatchMode, false);
			}
		}
		// Set match mode on client's profile
		if (PC != None && 
			PC.ProfileSettings != None)
		{
			PC.ProfileSettings.SetProfileSettingValueId(`VERSUS_MATCH_MODE,MatchMode);
		}
	}
}

/** Update the GRI with the versus game type so clients can replicate */
simulated function UpdateVersusGameType(int GameContextId)
{
	local GearPartyGRI PartyGRI;

	PartyGRI = GearPartyGRI(GetGRI());
	if (PartyGRI != None)
	{
		// Server sets the GRI
		if (PartyGRI.Role == ROLE_Authority)
		{
			PartyGRI.VersusGameType = GameContextId;
			PartyGRI.bForceNetUpdate = true;
			PartyGRI.bNetDirty = true;
		}
	}

	// Set the current game settings using the context from above
	class'GearUIManager'.static.GetGameSettingsDataStore().SetCurrentByContextId(GameContextId);
}

/**
 * Called when custom options have been finished getting selected and we're about to start a match
 *
 * @param bIsTrainingGrounds - Whether we are creating a custom match for training grounds or not
 */
function bool HandleCustomOptionsSelection(optional bool bIsTrainingGrounds)
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local GearPartyGame_Base PartyGame;

	// First, let the game object know whether this is for training grounds or not
	PartyGame = GetPartyGame();
	PartyGame.bIsTrainingGrounds = bIsTrainingGrounds;

	// Make sure they want to launch the game
	ButtonAliases.AddItem('GenericYes');
	ButtonAliases.AddItem('GenericNo');

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('LaunchCustomMatch',
		"<Strings:GearGameUI.MessageBoxStrings.StartMatch_Title>",
		"<Strings:GearGameUI.MessageBoxStrings.StartMatch_Message>",
		ButtonAliases,
		OnLaunchMatchCheckComplete);

	return false;
}

/** Return from the prompt asking if the player wanted to launch a custom match */
function bool OnLaunchMatchCheckComplete(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'GenericYes')
	{
		LaunchCustomMatch();
	}
	return true;
}

/** Does the remaining checks needed to launch a custom match and creates that match if possible */
function LaunchCustomMatch()
{
	local int NumPRIs;
	local int PartyTeamSize;
	local GearPartyGame_Base PartyGame;

	// Make sure this is the party leader
	if (IsPartyLeader())
	{
		PartyGame = GetPartyGame();

		// Don't do anything if players are in the middle of joining
		if (!PartyGame.PlayersAreJoining())
		{
			// Make sure we're able to create the match
			if (IsAllowedToCreateMatch())
			{
				NumPRIs = PartyGame.GetNumValidPRIs();
				PartyTeamSize = PartyGame.GetPartyTeamSize();

				// Error check - too many players
				if (NumPRIs > PartyTeamSize)
				{
					SendTooManyPlayersError(NumPRIs - PartyTeamSize);
				}
				// Error check - not enough players
				else if (!PartyGame.LobbyHasEnoughPlayers())
				{
					SendNotEnoughPlayersError();
				}
				// Passed all checks so start the match
				else
				{
					// If the match is successful in creating, we need to return so that
					// ContinueFromHaltedState() is not called (this will block input while preparing for level transition)
					if (CreateMatch())
					{
						`log("Starting Custom match");
						return;
					}
					else
					{
						`log("Failed to create match");
					}
				}
			}
		}
	}

	// We hit an error and couldn't creat the match this will unblock the input
	ContinueFromHaltedState(false);
}

/** Checks to see if a network enabled match is possible by doing various checks depending on the party type */
function bool AttemptNetworkedMatchTransition(bool bIsLIVEParty, bool bIsLANParty, bool bIsLocal, optional bool bIsCampaign)
{
	local GearPartyGame_Base PartyGame;
	local GearUIManager UIManager;
	local GameViewportClient VPClient;
	local int PlayerCount;
	local bool bIsPublicCampaign;
	local int NumPRIs;
	local int MaxPartySize;

	PartyGame = GetPartyGame();
	VPClient = PartyGame.GetPlayerOwnerViewportClient();
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	bIsPublicCampaign = bIsCampaign && SelectedCampMode == eGCAMPMODE_Join;

	// Return if we can't get a GameViewportClient, a scene client, or UI Controller
	if (VPClient == None || VPClient.UIController == None || UIManager == None)
	{
		return false;
	}

	// Make sure non-LIVE parties don't try to access Ranked or Social match modes (Covers Local and LAN parties trying to access LIVE mode)
	if (!bIsLIVEParty && !bIsCampaign)
	{
		if (SelectedMPMode == eGVMM_Ranked || SelectedMPMode == eGVMM_Social)
		{
			UIManager.DisplayErrorMessage("NeedGoldTier_Message", "NeedGoldTier_Title", "GenericContinue", GetLP(), OnMainMenuError_Confirmed);
			return false;
		}
	}

	// Make sure non-LIVE parties don't try to access Public coop matchmaking (Covers Local and LAN parties trying to access LIVE mode)
	if (!bIsLIVEParty && bIsPublicCampaign)
	{
		UIManager.DisplayErrorMessage("NeedGoldTier_Message", "NeedGoldTier_Title", "GenericContinue", GetLP(), OnMainMenuError_Confirmed);
		return false;
	}

	// Check for a network connection first (only needs to happen if they are in a party session - network match)
	if (bIsLIVEParty || bIsLANParty)
	{
		if (!VPClient.UIController.HasLinkConnection())
		{
			UIManager.DisplayErrorMessage("NoLinkConnection_Message", "NoLinkConnection_Title", "GenericContinue", GetLP(), OnMainMenuError_Confirmed);
			return false;
		}
	}

	// Check for LIVE logins for all local players (LIVE party)
	if (bIsLIVEParty)
	{
		if (VPClient.UIController.GetLowestLoginStatusOfControllers() != LS_LoggedIn)
		{
			UIManager.DisplayErrorMessage("NeedGoldTier_Message", "NeedGoldTier_Title", "GenericContinue", GetLP(), OnMainMenuError_Confirmed);
			return false;
		}
	}
	// Check for logins for all local players (LAN party)
	else if (bIsLANParty)
	{
		// Check for signed in players
		PlayerCount = class'UIInteraction'.static.GetPlayerCount();
		if (class'UIInteraction'.static.GetLoggedInPlayerCount(false) != PlayerCount && class'WorldInfo'.static.IsConsoleBuild())
		{
			UIManager.DisplayErrorMessage("AControllerNotLoggedIn_Message", "NotLoggedIn_Title", "GenericContinue", GetLP(), OnMainMenuError_Confirmed);
			return false;
		}
	}

	// Check for guest accounts if they're attempting a public match
	if (bIsLIVEParty && !bIsCampaign)
	{
		if (SelectedMPMode == eGVMM_Ranked &&
			VPClient.UIController.GetNumGuestsLoggedIn() > 0)
		{
			UIManager.DisplayErrorMessage("IllegalGuestAction_Message", "IllegalGuestAction_Title", "GenericContinue", GetLP(), OnMainMenuError_Confirmed);
			return false;
		}
	}

	// Check for whether all local players can play online (only needs to happen if they are in a party session - network match)
	if (bIsLIVEParty)
	{
		if (!GetPC().CanAllPlayersPlayOnline())
		{
			UIManager.DisplayErrorMessage("NeedOnlinePermission_Message", "NeedOnlinePermission_Title", "GenericContinue", GetLP(), OnMainMenuError_Confirmed);
			return false;
		}
		// Don't allow more players than the playlist allows
		NumPRIs = PartyGame.GameReplicationInfo.PRIArray.Length;
		MaxPartySize = PartyGame.GetMaxPartySize();
		if (NumPRIs > MaxPartySize)
		{
			SendTooManyPlayersError(NumPRIs - MaxPartySize);
			return false;
		}
	}

	return true;
}

/** Called when the error message closes for matchmaking */
function bool OnMatchmakingError_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	UnblockInput();
	return true;
}

/** Called when a main menu error message has occurred */
function bool OnMainMenuError_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	ContinueFromHaltedState(false);
	return true;
}

/**
 * Show message box that there were too many players
 *
 * @param NumPlayersOverLimite - The number of players we've exceeded
 */
function SendTooManyPlayersError(int NumPlayersOverLimite)
{
	local array<name> ButtonAliases;
	local string AlteredMsgString;
	local GearUIManager UIManager;

	AlteredMsgString = Localize("MessageBoxErrorStrings", "GameErrorTooManyPlayers_Msg", "GearGameUI");
	AlteredMsgString = Repl( AlteredMsgString, "\`NUMPLAYERS\`", string(NumPlayersOverLimite));

	ButtonAliases.AddItem('GenericContinue');

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('NumPlayersError',
		"<Strings:GearGameUI.MessageBoxErrorStrings.GameErrorTooManyPlayers_Title>",
		AlteredMsgString,
		ButtonAliases,
		OnMatchmakingError_Confirmed);
}

/** Show message box that there were not enough players */
function SendNotEnoughPlayersError()
{
	local array<name> ButtonAliases;
	local GearUIManager UIManager;

	ButtonAliases.AddItem('GenericContinue');
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('NotEnoughPlayers',
		"<Strings:GearGameUI.MessageBoxErrorStrings.NotEnoughPlayers_Title>",
		"<Strings:GearGameUI.MessageBoxErrorStrings.NotEnoughPlayers_Message>",
		ButtonAliases,
		OnMatchmakingError_Confirmed);
}

/** Notifies the online subsystem to begin creating a new match */
function bool CreateMatch()
{
	local GearPartyGame_Base PartyGame;
	local int ControllerId;
	local bool bResult;

	PartyGame = GetPartyGame();
	if (PartyGame != None)
	{
		ControllerId = GetLP().ControllerId;
		if (ControllerId != 255)
		{
			MainMenuMovie.SaveGameSettingsToProfile(OnCreateMatchProfileWriteComplete);
			bResult = true;
		}
	}
	else
	{
		`log("Couldn't create match because current game isn't GearPartyGame:" @ GetWorldInfo().Game);
	}

	return bResult;
}

/** Called when the profile is done writing so we can create the match */
function OnCreateMatchProfileWriteComplete(byte ControllerId, bool bWasSuccessful)
{
	local GearPC GearPO;
	local GearPartyGame_Base PartyGame;	

	GearPO = GearPC(GetPC());
	GearPO.ClearSaveProfileDelegate(OnCreateMatchProfileWriteComplete);
	PartyGame = GetPartyGame();

	if(CurrMatchmakingMode == eGMATCHMAKINGMODE_Coop)
	{
		if (PartyGame.StartCoopMatchmaking(ControllerId,SelectedChapter))
		{
			class'GearUIManager'.static.ShowLoadingMovie(true);
		}
	}
	else
	{
		if (PartyGame.StartPartyMatchmaking(ControllerId))
		{
			class'GearUIManager'.static.ShowLoadingMovie(true);
		}
	}
}

/**
 * Callback for when a menu option has popped (moved back a screen)
 * 
 * @param HistoryArray - A GFxObject representing all of the choices the player has made. Used to deduce what the player wants to do
 *                      HistoryArray is an array of GfxObjects, each object representing a choice.
 *                          Each choice has two variables:
 *                              Screen - Byte representing what screen the player was on when this choice was made
 *                              Choice - The index of the option from the list of choices the player chose
 *                          HistoryArray is in chronological order, so the choice at index 0 is the first choice the player made.
 *                      
 * @param SelectionIndex - the current selection index
 */
function Callback_MenuOptionWasPopped(GFxObject HistoryArray, float SelectionIndex)
{
	MenuOptionWasChanged(HistoryArray,SelectionIndex);
}

/**
 * Main update function for the party panel
 * 
 * @param DeltaTime - Time since the last update
 */
final function UpdateFrontEnd(float DeltaTime)
{
	local GearPC PlayerOwner;
	local int Selection;

	PlayerOwner = GearPC(GetPC());

	// See if we need to start the party session
	if (bStartPartySession)
	{
		ConditionalCreatePartySession();
	}

	// Restore the history
	if (bRestoreFromHistory)
	{
		if (MainMenuMovie != None &&
			MainMenuMovie.MenuData != None)
		{
			// Jump to the spot in the front end history where we left off (or the host's history for clients)
			GetCurrentScreenAndSelection(,Selection);
			SynchMenuToStoredHistory(Selection);
			bRestoreFromHistory = false;
		}
	}

	// Let the party panel update
	if (SmallPartyPanel != None)
	{
		SmallPartyPanel.UpdatePartyPanel(DeltaTime);
	}

	// Let the matchmaking panel update
	if (MatchmakingPanel != None &&
		MatchmakingPanel.bPanelIsActive)
	{
		MatchmakingPanel.UpdateMatchmakingPanel();
	}

	// See if we need to close the party options panel
	if (bPartyOptionsActive &&
		!bPartyTypeChangeIsPending &&
		PartyOptionsOpenTime > 0 &&
		PartyOptionsOpenTime + PartyOptionsMinimumWaitTime < GetWorldInfo().TimeSeconds)
	{
		ClosePartyOptions();
	}

	// Allow clients to replicate the state
	if (PlayerOwner != None &&
		PlayerOwner.Role != ROLE_Authority)
	{
		UpdateClientView();
	}
}

/** Checks to see if we are currently in the correct screen and puts you there if not */
final function UpdateClientView()
{
	local GearPartyGRI PartyGRI;
	local byte CurScreen;
	local int CurSelection;

	if (bReady)
	{
		PartyGRI = GearPartyGRI(GetGRI());
		if (PartyGRI != None &&
			PartyGRI.CurrMenuSelection != CurrMenuSelection)
		{
			CurrMenuSelection = PartyGRI.CurrMenuSelection;
			GetCurrentScreenAndSelection( CurScreen, CurSelection);
			SetMenuSelection(CurrMenuSelection);
		}
	}
}

/** Returns the party session we are currently in */
final function OnlineGameSettings GetPartySession()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		return OnlineSub.GameInterface.GetGameSettings('Party');
	}
	return None;
}

/** Whether we are currently in a party session or not */
final function bool InPartySession()
{
	return (GetPartySession() != None);
}

/** Creates the party session if possible */
final function ConditionalCreatePartySession()
{
	local GearPartyGame_Base PartyGame;
	local GearMenuPC PlayerOwner;
	local UniqueNetId ZeroId;

	// Make sure the PlayerOwner is actually the primary player in case the above function failed
	PlayerOwner = GearMenuPC(GetPC());
	if (PlayerOwner != None &&
		PlayerOwner.IsPrimaryPlayer() &&
		PlayerOwner.PlayerReplicationInfo != None &&
		(PlayerOwner.bSignedIn || bOnTitleScreen || CurrPartyType == eGVPT_SystemLink) &&
		!InPartySession())
	{
		// Make sure they have a net id
		if (PlayerOwner.PlayerReplicationInfo.UniqueId != ZeroId)
		{
			PartyGame = GearPartyGame_Base(PlayerOwner.WorldInfo.Game);
			if (PartyGame != None)
			{
				// If all players can play online or we are starting a system link game, try to create a party
				if (PlayerOwner.CanAllPlayersPlayOnline() ||
					PlayerOwner.ProfileSettings.bPartyTypeIsSystemLink)
				{
					PartyGame.CreateParty(PlayerOwner.GetUIController().GetPlayerControllerId(0), PlayerOwner.ProfileSettings.bPartyTypeIsSystemLink);
					CurrPartyType = PlayerOwner.ProfileSettings.GetPartyType();
				}
				// Else setup things locally
				else
				{
					LocalPartyCreated();
				}
			}
		}
		// Else start things locally
		else
		{
			LocalPartyCreated();
		}

		bStartPartySession = false;
	}
}

/** Notification from the gameinfo that the party has been created */
function PartySuccessfullyCreatedNotify()
{
	// Let the party panel update it's title
	if (SmallPartyPanel != None)
	{
		SmallPartyPanel.UpdatePanelTitle();
	}
}

/** Notification from the gameinfo that a local party has been used */
function LocalPartyCreated()
{
	CurrPartyType = eGVPT_Local;
	SetPartyType(CurrPartyType);

	// Destroy the party session if one exists
	if (InPartySession())
	{
		DestroyPartyForLocal();
	}

	// Let the party panel update it's title
	if (SmallPartyPanel != None)
	{
		SmallPartyPanel.UpdatePanelTitle();
	}

	// Update Rich Presence Strings
	GetPartyGame().SetPresenceByPartyType();
}

/** Callback that we are in the title screen */
final function Callback_OnTitleScreen()
{
	local GearUIInteraction UIController;

	bOnTitleScreen = true;
	bHasPromptedForMPPreferences = false;

	//Turn on attract mode
	UIController = GearUIInteraction(class'UIRoot'.static.GetCurrentUIController());
	if ( UIController != None )
	{
		UIController.bAttractModeAllowed = true;
	}
}

/** Callback that the start button was pressed while we were in the title screen 
 *  @param ControllerIdx - The controller ID that pressed start
 */
final function Callback_TransitionFromStart(float ControllerIdx)
{
	local int PlayerIndex;
	local GameViewportClient VPClient;
	local Engine Eng;
	local GearUIInteraction UIController;

	//Turn off attract mode
	UIController = GearUIInteraction(class'UIRoot'.static.GetCurrentUIController());
	if ( UIController != None )
	{
		UIController.bAttractModeAllowed = false;
	}

	PressedStartControllerId = int(ControllerIdx);
	
	Eng = class'Engine'.static.GetEngine();
	for (PlayerIndex =0; PlayerIndex < Eng.GamePlayers.Length; PlayerIndex++)
	{
		if (Eng.GamePlayers[PlayerIndex].ControllerId == PressedStartControllerId)
		{
			//This is our playerindex
			break;
		}
	}

	if (PlayerIndex == Eng.GamePlayers.Length)
	{
		`warn("Received input from a controller that does not have a localplayer. Defaulting to localplayer 0.");
		PlayerIndex = 0;
	}

	// Force the player who pressed the start button to be the primary player
	VPClient = Eng.GamePlayers[PlayerIndex].ViewportClient;
	if (VPClient != None)
	{
		VPClient.BecomePrimaryPlayer(PlayerIndex);
	}

	// Verify the player is signed in and if not show the login ui
	if (!ConditionalShowLoginUI(PressedStartControllerId))
	{
		AdvanceFromStartScreen();
	}
}

/**
 * Verify the player is signed in and if not show the login ui
 *
 * @param ControllerId the player that needs to sign in if not already signed in
 * @param bAllowGuest optional parameter to enable guest signin
 * 
 * @return True if the login ui will be shown, false otherwise
 */
function bool ConditionalShowLoginUI(int ControllerId,optional bool bAllowGuest)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		// Show the login ui if they are not logged in
		if (OnlineSub.PlayerInterface.GetLoginStatus(ControllerId) == LS_NotLoggedIn)
		{
			OnlineSub.PlayerInterface.ShowLoginUI(bAllowGuest);
			return true;
		}
		else
		{
			return false;
		}
	}
}

/*
 * Tell the frontend movie to advance past the front end if it is allowed
 */
function AdvanceFromStartScreen()
{
	local array<ASValue> args;
	local ASValue ASVal;
	local GearPC GPC;

	if (PressedStartControllerId != INDEX_NONE)
	{
		//Let it go forward
		ASVal.Type = AS_Number;
		ASVal.n = PressedStartControllerId;
		args.AddItem(ASVal);
		MainMenuMovie.Invoke("OpenMainMenu",args);

		// If the player is not signed in, all the code below won't work
		GPC = GearPC(class'Engine'.static.GetEngine().GamePlayers[0].Actor);
		if (GPC != none)
		{
			// reset match mode to custom whenever transitioning back through start screen
			GPC.ProfileSettings.SetProfileSettingValueId(`VERSUS_MATCH_MODE,eGVMT_Custom);

			// Prompt the player to configure the video settings if they haven't already
			if( !GPC.ProfileSettings.HasConfiguredVideoSettings() )
			{
				OpenVideoSettingsPage();
			}
		}

		//If we have another player, set his info also
		if (class'Engine'.static.GetEngine().GamePlayers.Length > 1)
		{	
			GPC = GearPC(class'Engine'.static.GetEngine().GamePlayers[1].Actor);
			if (GPC != none)
			{
				SetSecondaryController(class'Engine'.static.GetEngine().GamePlayers[1].ControllerId);
			}
		}

		// Download the playlists here if we haven't already
		GetPartyGame().DownloadPlaylists(true);

		// Create the party session
		ConditionalCreatePartySession();

		// No longer in title screen
		bOnTitleScreen = false;	
		Background_PlayTransition();

		// Reload the custom settings in case we inited when not having a profile
		if (MainMenuMovie != None)
		{
			MainMenuMovie.LoadCustomGameSettingsFromProfile();
			MainMenuMovie.OnCustomGameSettingsChanged(true);
		}

		PressedStartControllerId = INDEX_NONE;
	}
}

/** Lets AS know to unblock input. Since AS sometimes blocks input in order to keep users from advancing while US has time to process, 
 *  US needs to call this function when it has decided to allow the user to continue
 *  Currently it is used when a player tries to back out of the menus input is blocked and US is notified. 
 *  If US decides to not let the player out of the menus, US needs to tell AS to unblock input
 */
function UnblockInput()
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_Boolean;
	ASVal.b = false;
	args.AddItem(ASVal);

	MainMenuMovie.Invoke("SetDenyInput",args);
}

/** Common code for returning to the main menu */
function ReturnToTitleScreen()
{
	// Tell ActionScript to go back to the title screen
	MainMenuMovie.ASOpenTitleScreen();
	Background_PlayAttract();
	GetGearPC().SetRichPresenceString(class'GearGame'.const.CONTEXT_PRESENCE_MENUPRESENCE);
}

/** Callback that the Back button was pressed from the main menu to go back to the title screen */
final function Callback_TransitionToTitle()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	// If host is trying to go back to the title screen
	if (GetPC().Role == ROLE_Authority)
	{
		// If they are in a party session
		if (InPartySession())
		{
			// If there is at least 1 client, ask if they are willing to leave the party session
			if (GetPartyGame().GetNumConsumedPartyReservations() > 1)
			{
				UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

				ButtonAliases.AddItem('GenericAccept');
				ButtonAliases.AddItem('GenericCancel');

				UIManager.ShowUIMessage('ExitPartyToTitle',
					Localize("MessageBoxStrings","LeavePartyLobby_Title","GearGameUI"),
					Localize("MessageBoxStrings","LeavePartyLobby_LeaderMessage","GearGameUI"),
					ButtonAliases, Callback_ExitParty, GetLP());

				// Return from here so we don't go to title screen yet
				return;
			}
			else
			{
				// Destroy the party session
				GearPartyGame_Base(GetPC().WorldInfo.WorldInfo.Game).DestroyParty();
			}
		}
	}
	// Else handle the client trying to leave the party
	else
	{
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

		ButtonAliases.AddItem('GenericAccept');
		ButtonAliases.AddItem('GenericCancel');

		UIManager.ShowUIMessage('ExitPartyToTitle',
			Localize("MessageBoxStrings","LeavePartyLobby_Title","GearGameUI"),
			Localize("MessageBoxStrings","LeavePartyLobby_MemberMessage","GearGameUI"),
			ButtonAliases, Callback_ClientExitParty, GetLP());

		// Return from here so we don't go to title screen yet
		return;
	}

	// Go back to title screen
	ReturnToTitleScreen();
}

/** Callback function called when the host is trying to go back to the title screen and wants to exit the party. 
 *  @param Sender - The messagebox that prompted this callback
 *  @param SelectedInputAlias - What input alias the player selected on the messagebox
 *  @param PlayerIndex - The player index of the player who responded to the messagebox
 *  
 *  @return Whether or not to close the messagebox
 **/
function bool Callback_ExitParty(UIScene_MessageBox Sender, Name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'GenericAccept')
	{
		// If the host is in a party session
		if (InPartySession())
		{
			// Destroy the party session
			GearPartyGame_Base(GetPC().WorldInfo.WorldInfo.Game).DestroyParty();
		}

		// Go back to title screen
		ReturnToTitleScreen();
	}
	else
	{
		UnblockInput();
	}

	return true;
}

/** Callback function called when a client hits b, and wants to exit the party. 
 *  
 *  @param Sender - The messagebox that prompted this callback
 *  @param SelectedInputAlias - What input alias the player selected on the messagebox
 *  @param PlayerIndex - The player index of the player who responded to the messagebox
 *  
 *  @return Whether or not to close the messagebox
 **/
function bool Callback_ClientExitParty(UIScene_MessageBox Sender, Name SelectedInputAlias, int PlayerIndex)
{
	if (SelectedInputAlias == 'GenericAccept')
	{
		GearPC(GetPC()).ReturnToMainMenu(false);
	}
	else
	{
		UnblockInput();
	}

	return true;
}

/** Callback function called when a client hits start, used to open the options menu
 *  NOTE - this does NOT handle the initial press of start that closes the title screen, that is handled in actionscript!
 *  
 *  @param ControllerIdx - the controller id of the player who hit the start button
 **/
final function Callback_StartButtonPressed(int ControllerIdx)
{
	local LocalPlayer OpeningPlayer;

	if( OptionsMenuClass != None )
	{
		// Find which player opened the options menu
		OpeningPlayer = GetLP().ViewportClient.FindPlayerByControllerId(ControllerIdx);

		if( OpeningPlayer != None )
		{
			// Spawn an instance of the options menu, which will be owned by whichever player hit start
			OptionsMenu = new(self) OptionsMenuClass;
			OptionsMenu.SetupMPPreferencesCallback(OpenMPPreferences);
			OptionsMenu.Init(OpeningPlayer);
			OptionsMenu.OnOptionsMenuClose = OptionsMenuClosed;

			bIsInOptionsMenu = TRUE;
		}	
	}
}

/** Callback that occurs when the options menu is closed */
final function OptionsMenuClosed()
{
	OptionsMenu = None;
	bIsInOptionsMenu = FALSE;
}

/** Opens the MP Preferences scene for the specified local player */
final function OpenMPPreferences( LocalPlayer LocPlayer )
{
	if( MPPreferencesClass != None )
	{
		MPPreferences = new(self) MPPreferencesClass;
		MPPreferences.Init(LocPlayer);

		// Blur self if the options menu isn't up
		if( OptionsMenu == None )
		{
			BlurMainMenu();
		}
	}
}

/** Sets the visibility of the MP preferences background, so it can be toggled on/off depending on context */
final function SetMPPreferencesBackgroundVisibility(bool bNewVisible)
{
	if( MPPreferences != None )
	{
		MPPreferences.SetBackgroundVisibility(bNewVisible);
	}
}

/** Called when the MP preferences scene is closed */
final function MPPreferencesClosed()
{
	MPPreferences = None;

	// If there's an options menu, reset it to its normal configuration
	if( OptionsMenu != None )
	{
		OptionsMenu.NotifyMPPrefsClosed();
	}
	else
	{
		UnblurMainMenu();
	}
}

/**
 * Callback function for when an option stepper has been changed
 * @param OptionID - the identifier of the option that has been changed
 * @param OptionIndex - the new value that the option stepper has been changed to
 */
final function Callback_OptionStepperChange(float OptionID, float OptionIndex)
{
	// Forward the callback to the main menu widget
	if (MainMenuMovie != None)
	{
		MainMenuMovie.Callback_OptionStepperChange(OptionID, OptionIndex);
	}
}

/**
 * Function that tells the UI to update all option steppers with the specified ID to the specified selected index
 * @param OptionID - the identifier of the option
 * @param OptionIndex - the new value that the option stepper has been changed to
 */
simulated final function ChangeOptionStepperSelection(int OptionId, int OptionIndex)
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_Number;
	ASVal.n = OptionId;
	args.AddItem(ASVal);

	ASVal.Type = AS_Number;
	ASVal.n = OptionIndex;
	args.AddItem(ASVal);

	MainMenuMovie.Invoke("SetCustomOptionSelection",args);
}

/** Called by the options menu if the storage location changes */
function NotifyStorageDeviceChanged()
{
	//@todo:  Make this refresh the storage location data when that gets implemented!!!
	`warn("IMPLEMENT UISCENE_FRONTEND::NOTIFYSTORAGEDEVICECHANGED()!!!!");
}

/** Function that determines which save slot is the latest save, if one exists */
function int GetLatestSaveSlotIndex()
{
	local int SlotIdx;
	local int CurrLatestIdx;
	local GearUIManager UIManager;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	CurrLatestIdx = INDEX_NONE;

	// Loop through all slots and see which one is the newest
	for (SlotIdx = 0; SlotIdx < `NUM_SAVE_SLOTS; SlotIdx++)
	{
		// Make sure the slot has a file the exists and is not corrupt
		if (UIManager.SaveSlotData[SlotIdx].bContainsData &&
			!UIManager.SaveSlotData[SlotIdx].bIsCorrupted)
		{
			// If there is currently no other valid slot, it wins
			if (CurrLatestIdx == INDEX_NONE)
			{
				CurrLatestIdx = SlotIdx;
			}
			// If this slot's year is newer than current, it wins
			else if (UIManager.SaveSlotData[SlotIdx].Year > UIManager.SaveSlotData[CurrLatestIdx].Year)
			{
				CurrLatestIdx = SlotIdx;
			}
			// If this slot's year is the same, we must look at month
			else if (UIManager.SaveSlotData[SlotIdx].Year == UIManager.SaveSlotData[CurrLatestIdx].Year)
			{
				// If this slot's month is newer than current, it wins
				if (UIManager.SaveSlotData[SlotIdx].Month > UIManager.SaveSlotData[CurrLatestIdx].Month)
				{
					CurrLatestIdx = SlotIdx;
				}
				// If this slot's month is the same, we must look at day
				else if (UIManager.SaveSlotData[SlotIdx].Month == UIManager.SaveSlotData[CurrLatestIdx].Month)
				{
					// If this slot's day is newer than current, it wins
					if (UIManager.SaveSlotData[SlotIdx].Day > UIManager.SaveSlotData[CurrLatestIdx].Day)
					{
						CurrLatestIdx = SlotIdx;
					}
					// If this slot's day is the same, we must look at time
					else if (UIManager.SaveSlotData[SlotIdx].Day == UIManager.SaveSlotData[CurrLatestIdx].Day)
					{
						// If this slot's time is newer than current, it wins
						if (UIManager.SaveSlotData[SlotIdx].SecondsSinceMidnight > UIManager.SaveSlotData[CurrLatestIdx].SecondsSinceMidnight)
						{
							CurrLatestIdx = SlotIdx;
						}
					}
				}
			}
		}
	}

	return CurrLatestIdx;
}

/**
 * Reads the save game data for all slots
 */
function ReadAllSaveSlots()
{
	local GearPC PC;
	local LocalPlayer LP;

	PC = GetGearPC();
	LP = LocalPlayer(PC.Player);

	if (PC.OnlineSub != None &&
		LP != None)
	{
		if (PC.OnlineSub.ContentInterface != None)
		{
			// Add our read delegate
			PC.OnlineSub.ContentInterface.AddReadSaveGameDataComplete(LP.ControllerId,OnReadSaveGameDataComplete);
			SaveGameReadsRemaining = 3;
			// Read all 3 files at once
			PC.OnlineSub.ContentInterface.ReadSaveGameData(LP.ControllerId,
				PC.GetDeviceId(),
				class'Checkpoint'.default.DisplayName,
					"GearsCheckpoint",
					"GearsCheckpoint0.sav");
			PC.OnlineSub.ContentInterface.ReadSaveGameData(LP.ControllerId,
				PC.GetDeviceId(),
				class'Checkpoint'.default.DisplayName,
					"GearsCheckpoint",
					"GearsCheckpoint1.sav");
			PC.OnlineSub.ContentInterface.ReadSaveGameData(LP.ControllerId,
				PC.GetDeviceId(),
				class'Checkpoint'.default.DisplayName,
					"GearsCheckpoint",
					"GearsCheckpoint2.sav");
		}
	}
}

/**
 * Delegate used when the content read request has completed. Pushes the data into engine for save slot parsing
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 * @param LocalUserNum the user that was initiating the data read
 * @param DeviceId the device that the read was on
 * @param FriendlyName the friendly name of the save game that was returned by enumeration
 * @param FileName the file to read from inside of the content package
 * @param SaveFileName the file name of the save game inside the content package
 */
function OnReadSaveGameDataComplete(bool bWasSuccessful,byte LocalUserNum,int DeviceId,string FriendlyName,string FileName,string SaveFileName)
{
	local GearEngine Engine;
	local GearUIManager UIManager;
	local int SaveSlotIndex;
	local array<byte> SaveData;
	local MMSaveSlotData EmptySaveSlot;
	local int CheckpointChapter;
	local EDifficultyLevel CheckpointDifficulty;
	local CheckpointTime CheckpointTimestamp;
	local GearPC PC;
	local GearMenuPC GMPC;

	SaveGameReadsRemaining--;

	switch (SaveFileName)
	{
		case "GearsCheckpoint0.sav":
			SaveSlotIndex = 0;
			break;
		case "GearsCheckpoint1.sav":
			SaveSlotIndex = 1;
			break;
		case "GearsCheckpoint2.sav":
			SaveSlotIndex = 2;
			break;
	}

	PC = GetGearPC();
	Engine = GearEngine(class'Engine'.static.GetEngine());
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (Engine != None &&
		UIManager != None &&
		PC != None)
	{
		// Empty the save slot by default and fill back in once parsed
		UIManager.SaveSlotData[SaveSlotIndex] = EmptySaveSlot;
		if (bWasSuccessful)
		{
			// Get the data from the save game
			PC.OnlineSub.ContentInterface.GetSaveGameData(LocalUserNum,DeviceId,FriendlyName,FileName,SaveFileName,SaveData);
			if (SaveData.Length > 0)
			{
				// Use the engine to parse the data
				if (Engine.ParseCheckpointData(SaveData,SaveSlotIndex,CheckpointChapter,CheckpointDifficulty,CheckpointTimestamp))
				{
					UIManager.SaveSlotData[SaveSlotIndex].bContainsData = true;
					UIManager.SaveSlotData[SaveSlotIndex].ChapterNum = CheckpointChapter;
					UIManager.SaveSlotData[SaveSlotIndex].Difficulty = CheckpointDifficulty;
					UIManager.SaveSlotData[SaveSlotIndex].SecondsSinceMidnight = CheckpointTimestamp.SecondsSinceMidnight;
					UIManager.SaveSlotData[SaveSlotIndex].Day = CheckpointTimestamp.Day;
					UIManager.SaveSlotData[SaveSlotIndex].Month = CheckpointTimestamp.Month;
					UIManager.SaveSlotData[SaveSlotIndex].Year = CheckpointTimestamp.Year;
				}
				else
				{
					// If it fails to parse it's corrupt
					UIManager.SaveSlotData[SaveSlotIndex].bIsCorrupted = true;
				}
			}
		}
		// Notify all non local player controllers of the save game data
		foreach PC.WorldInfo.AllControllers(class'GearMenuPC',GMPC)
		{  
			if (!GMPC.IsLocalPlayerController())
			{
				GMPC.ClientMainMenuSaveSlotChange(UIManager.SaveSlotData);
			}
		}
	}
	// Have the main menu widget prepare itself with the save slot data
	if (SaveGameReadsRemaining == 0 &&
		MainMenuMovie != None)
	{
		MainMenuMovie.UpdateSaveSlotOptions();
		// Clear our read delegate now that all files are done
		PC.OnlineSub.ContentInterface.ClearReadSaveGameDataComplete(LocalUserNum,OnReadSaveGameDataComplete);
		// Unblock progress now that the data has been parsed
		ContinueFromHaltedState(true);
		// Show corrupt UI if any file is corrupt
		CheckForCorruptSaves();
	}
}

/**
 * Helper function to encapsulate the preparing of the checkpoint system for getting checkpoints
 *
 * @return - whether the checkpoint system was able to be prepared for access or not
 */
final function bool PrepareCheckpointSystem()
{
	local GearEngine Engine;
	local GearPC PC;
	local LocalPlayer LP;

	PC = GetGearPC();
	LP = LocalPlayer(PC.Player);
	Engine = GearEngine(class'Engine'.static.GetEngine());
	if (LP != None &&
		Engine != None)
	{
		// See if the storage device is ready
		if (PC.IsStorageDeviceValid())
		{
			// Set the checkpoint system to look at the proper player and device
			Engine.CurrentUserID = LP.ControllerId;
			Engine.SetCurrentDeviceID(PC.GetDeviceId());
			return true;
		}
		else
		{
			return false;
		}
	}

	// Must be PC
	return true;
}

/**
 * Checks the number of plugged in controllers and makes sure there is a player for each
 */
function UpdatePlayersAndControllers()
{
	local int ControllerIndex;
	local int NumLogins;
	local GearMenuPC PC;
	local OnlineSubsystem OnlineSub;
	local bool bDidCreateRemovePlayer;
	local bool bWasControllerFound;
	local GearUIManager UIManager;
	local string Ignored;
	local WorldInfo WI;
	local LocalPlayer LP;
	local int LocalPlayerCount;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	WI = class'Engine'.static.GetCurrentWorldInfo();
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (UIManager != None &&
		OnlineSub != None &&
		OnlineSub.SystemInterface != None &&
		OnlineSub.PlayerInterface != None)
	{
		NumLogins = OnlineSub.GetNumSupportedLogins();
		// Go through each possible controller checking for being signed in
		for (ControllerIndex = 0; ControllerIndex < NumLogins; ControllerIndex++)
		{
			bWasControllerFound = false;
			// See if it is connected to the machine
			if (OnlineSub.SystemInterface.IsControllerConnected(ControllerIndex) ||
				// Or if a player is logged into this controller even if it's not present
				OnlineSub.PlayerInterface.GetLoginStatus(ControllerIndex) > LS_NotLoggedIn)
			{
				// See if this controller is already out there
				foreach WI.LocalPlayerControllers(class'GearMenuPC',PC)
				{
					LP = LocalPlayer(PC.Player);
					if (LP != None &&
						LP.ControllerId == ControllerIndex)
					{
						bWasControllerFound = true;
						break;
					}
				}
				if (!bWasControllerFound)
				{
					// Controller doesn't have a corresponding player so add
					UIManager.Outer.Outer.CreatePlayer(ControllerIndex,Ignored,true);
					bDidCreateRemovePlayer = true;
				}
			}
			else
			{
				// If the controller wasn't logged in, remove that player
				// Don't remove the last player if they sign out
				if (WI.GRI.PRIArray.Length > 1 &&
					OnlineSub.PlayerInterface.GetLoginStatus(ControllerIndex) == LS_NotLoggedIn)
				{
					// Find the player controller and remove it
					foreach WI.LocalPlayerControllers(class'GearMenuPC',PC)
					{
						LP = LocalPlayer(PC.Player);
						if (LP != None &&
							LP.ControllerId == ControllerIndex)
						{
							UIManager.Outer.Outer.RemovePlayer(LP);
							bDidCreateRemovePlayer = true;
							break;
						}
					}
				}
			}
		}
	}
	// Check for guests being able to sign in
	UpdateGuestStatus();
	// Return to the start screen if we can't change player counts
	if (bDidCreateRemovePlayer &&
		!IsAllowedToCreatePlayers())
	{
		foreach WI.LocalPlayerControllers(class'GearMenuPC',PC)
		{
			PC.RestartFrontEnd();
			break;
		}
	}
	// Figure out how many local players there are now
	foreach WI.LocalPlayerControllers(class'GearMenuPC',PC)
	{
		LocalPlayerCount++;
	}
	// Show a different message for too many profiles
	if (GetLoggedInPlayerCount() > 2)
	{
		// Show an error message
		class'GearUIManager'.static.DisplayErrorMessage("TwoPlayersOnly_Message",
			"TwoPlayersOnly_Title",
			"GenericAccept",
			None,
			OnTooManyProfilesErrorAccepted);
	}
	// Gears only allows for 2 players on a local box
	else if (LocalPlayerCount > 2)
	{
		// Show an error message
		class'GearUIManager'.static.DisplayErrorMessage("TooManyControllersConnected_Message",
			"TooManyControllersConnected_Title",
			"GenericAccept",
			None,
			OnTooManyControllersErrorAccepted);
	}
}

/**
 * Updates whether we can allow guest logins or not
 */
function UpdateGuestStatus()
{
	local int ControllerIndex;
	local int NumLogins;
	local OnlineSubsystem OnlineSub;
	local WorldInfo WI;

	bAllowGuestLogin = false;
	WI = class'Engine'.static.GetCurrentWorldInfo();
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		// Can only support guests when more than one controller is present
		if (WI.GRI.PRIArray.Length > 1)
		{
			NumLogins = OnlineSub.GetNumSupportedLogins();
			// Go through each possible controller checking for being signed in
			for (ControllerIndex = 0; ControllerIndex < NumLogins; ControllerIndex++)
			{
				// If the player is fully signed in, can play online, and isn't a guest
				// Then they can bring guests in
				if (OnlineSub.PlayerInterface.GetLoginStatus(ControllerIndex) == LS_LoggedIn &&
					OnlineSub.PlayerInterface.CanPlayOnline(ControllerIndex) == FPL_Enabled &&
					!OnlineSub.PlayerInterface.IsGuestLogin(ControllerIndex))
				{
					bAllowGuestLogin = true;
					break;
				}
			}
		}
	}
	// Make sure to update the button bar to match our current state
	if (MainMenuMovie != None)
	{
		MainMenuMovie.UpdateButtonBar();
	}
}

/**
 * Updates the guest login status when a login changes
 *
 * @param Ignored
 */
function OnLoginChange(byte Ignored)
{
	UpdateGuestStatus();
}

/** Returns whether we can currently allow a new player to be created in our front end */
function bool IsAllowedToCreatePlayers()
{
	// Can't create players if we are a client
	if (GetPC().Role == ROLE_Authority)
	{
		// Only allow players to be created on some screens
		switch (CurrMenuSelection)
		{
			case MAINMENUOP_None:
			case MAINMENUOP_MainMenu:
			case MAINMENUOP_Campaign:
			case MAINMENUOP_SaveSlots:
			case MAINMENUOP_SPGametype:
			case MAINMENUOP_SPActSelect:
			case MAINMENUOP_VS_Playlists:
			case MAINMENUOP_Horde:
			case MAINMENUOP_Siege:
				return true;
		}
	}
	return false;
}

/** Callback for when there are too many profiles loaded. Only close if the error is handled */
function bool OnTooManyControllersErrorAccepted( UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex )
{
	local OnlineSubsystem OnlineSub;
	local int NumLogins;
	local int NumControllersConnected;
	local int ControllerIndex;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.SystemInterface != None)
	{
		NumLogins = OnlineSub.GetNumSupportedLogins();
		// Go through each possible controller checking for being signed in
		for (ControllerIndex = 0; ControllerIndex < NumLogins; ControllerIndex++)
		{
			// See if it is connected to the machine
			NumControllersConnected += int(OnlineSub.SystemInterface.IsControllerConnected(ControllerIndex));
		}
	}
	return NumControllersConnected <= 2;
}

/** Callback for when there are too many profiles loaded. Only close if the error is handled */
function bool OnTooManyProfilesErrorAccepted( UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex )
{
	return GetLoggedInPlayerCount() <= 2;
}

/** ActionScript stub for playing the background "transition" animation between the title and the main menu. */
function Background_PlayTransition()
{
	local GearMenuHUD MenuHUD;

	MenuHUD = GearMenuHUD(Outer);
	if( (MenuHUD != None) && (MenuHUD.BackgroundMovie != None) )
	{
		MenuHUD.BackgroundMovie.TransitionToMenu();
	}
}

/** Tells the background to go to the attract / title screen mode */
function Background_PlayAttract()
{
	local GearMenuHUD MenuHUD;

	MenuHUD = GearMenuHUD(Outer);
	if( (MenuHUD != None) && (MenuHUD.BackgroundMovie != None) )
	{
		MenuHUD.BackgroundMovie.TransitionToAttract();
	}
}

/** Tells the background to go transition to the main menu */
function Background_PlayMainMenu()
{
	local GearMenuHUD MenuHUD;

	MenuHUD = GearMenuHUD(Outer);
	if( (MenuHUD != None) && (MenuHUD.BackgroundMovie != None) )
	{
		MenuHUD.BackgroundMovie.JumpToMenu();
	}
}

/**
 * Function to call to set a menu option disabled or undisabled
 * @param Screen - the screen the option is on to disable
 * @param SelectedIndex - the index of the option that should be disabled
 * @param bIsDisabled - Whether or not to set the option disabled or undisabled
 */
function SetOptionDisabled(byte Screen, byte SelectedIndex, bool bIsDisabled)
{
	local array<ASValue> args;
	local ASValue ASVal;
	local GearUIManager UIManager;
	local int i, NumPrevRemovedItems;
	local bool bIsNotNew;
	local GearMenuPC GMPCOwner, GMPC;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	if (UIManager != None && MainMenuMovie.AllOptions[Screen].List[SelectedIndex].bIsDisabled != bIsDisabled)
	{
		MainMenuMovie.AllOptions[Screen].List[SelectedIndex].bIsDisabled = bIsDisabled;

		if (MainMenuMovie.MenuData != none)
		{
			NumPrevRemovedItems = 0;
			//If we already removed something from in front of this one, then we need to update the index
			for ( i = 0; i < SelectedIndex; i++)
			{
				if (IsOptionRemoved(Screen, i))
				{
					NumPrevRemovedItems++;
				}
			}

			ASVal.Type = AS_Number;
			ASVal.n = Screen;
			args.AddItem(ASVal);

			MainMenuMovie.MenuData.GetElementObject(Screen).GetObject("Options").GetElementObject(SelectedIndex-NumPrevRemovedItems).SetBool("bIsDisabled", bIsDisabled);
			MainMenuMovie.Invoke("UpdateListItem",args);
		}

		GMPCOwner = GearMenuPC(GetPC());
		//Also, if we are the server, we need to tell all the clients that stuff has just changed
		if (GMPCOwner != None &&
			GMPCOwner.Role == ROLE_Authority)
		{
			//First look to see if you are undoing a previous disabling or undisabling
			for (i = 0; i < UIManager.MainMenuDisabledLength; i++)
			{
				if (UIManager.MainMenuDisabled[i].Screen == Screen &&
					UIManager.MainMenuDisabled[i].SelectionIdx == SelectedIndex)
				{
					UIManager.MainMenuDisabled[i].bIsDisabled = bIsDisabled;
					bIsNotNew = true;
					break;
				}
			}
			//Otherwise add it
			if (!bIsNotNew)
			{
				UIManager.MainMenuDisabledLength++;
				UIManager.MainMenuDisabled[UIManager.MainMenuDisabledLength-1].Screen = Screen;
				UIManager.MainMenuDisabled[UIManager.MainMenuDisabledLength-1].SelectionIdx = SelectedIndex;
				UIManager.MainMenuDisabled[UIManager.MainMenuDisabledLength-1].bIsDisabled = bIsDisabled;
			}

			//For each player controller
			foreach GMPCOwner.WorldInfo.AllControllers(class'GearMenuPC', GMPC)
			{
				//If that player controller is not local
				if ( !GMPC.IsLocalPlayerController())
				{
					GMPC.ClientMainMenuDisabledChange(UIManager.MainMenuDisabled,UIManager.MainMenuDisabledLength);
				}
			}
		}
	}
}

/**
 * Function to call to determine if a menu option is disabled or undisabled
 * @param Screen - the screen the option is on to be queried
 * @param SelectedIndex - the index of the option that is being queried
 * @return Whether or not the designated option is disabled
 */
function bool GetOptionDisabled(byte Screen, byte SelectedIndex)
{
	return MainMenuMovie.AllOptions[Screen].List[SelectedIndex].bIsDisabled;
}


/**
 * Function to call to set a menu option removed
 * @param Screen - the screen the option is on to disable
 * @param SelectedIndex - the index of the option that should be disabled
 * @param bUndoRemove - true if this is to undo a previous remove, false otherwise
 */
function SetOptionRemoved(byte Screen, byte SelectedIndex, optional bool bUndoRemove)
{
	local array<ASValue> args;
	local ASValue ASVal;
	local GearUIManager UIManager;
	local int i, ListLength;
	local GearMenuPC GMPCOwner, GMPC;
	local GFxObject OptionList;
	local bool bAlreadyHadEntry;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	bAlreadyHadEntry = false;

	if (UIManager != None)
	{
		//Is the option not already removed and this is a remove request?
		//or is the option removed and this is an undo request?
		if ((!IsOptionRemoved(Screen,SelectedIndex) && bUndoRemove == false) ||
			(IsOptionRemoved(Screen,SelectedIndex) && bUndoRemove == true) )
		{
			GMPCOwner = GearMenuPC(GetPC());
			//If we are the server, we need to tell all the clients that stuff has just changed
			if (GMPCOwner != None &&
				GMPCOwner.Role == ROLE_Authority)
			{
				for (i = 0; i < UIManager.MainMenuRemovedLength; i++)
				{
					if (UIManager.MainMenuRemoved[i].Screen == Screen &&
						UIManager.MainMenuRemoved[i].SelectionIdx == SelectedIndex)
					{
						UIManager.MainMenuRemoved[i].bIsUndone = bUndoRemove;
						bAlreadyHadEntry = true;
						break;
					}
				}

				if (!bAlreadyHadEntry)
				{
					UIManager.MainMenuRemovedLength++;
					UIManager.MainMenuRemoved[UIManager.MainMenuRemovedLength-1].Screen = Screen;
					UIManager.MainMenuRemoved[UIManager.MainMenuRemovedLength-1].SelectionIdx = SelectedIndex;
					UIManager.MainMenuRemoved[UIManager.MainMenuRemovedLength-1].bIsUndone = bUndoRemove;
				}

				//For each player controller
				foreach GMPCOwner.WorldInfo.AllControllers(class'GearMenuPC', GMPC)
				{
					//If that player controller is not local
					if ( !GMPC.IsLocalPlayerController())
					{
						GMPC.ClientMainMenuRemovedChange(UIManager.MainMenuRemoved,UIManager.MainMenuRemovedLength);
					}
				}
			}

			if (MainMenuMovie.MenuData != none)
			{
				//This is an undo of a remove
				//NOTE - THIS WILL ONLY WORK ON THE MOST BASIC OF MENU OPTIONS, THINGS THAT ARE FULLY DEFINED IN THE INI.
				//ANY SPECIALLY CONSTRUCTED THINGS WILL BE UNABLE TO BE RECONSTRUCTED
				if (bUndoRemove)
				{
					//Reconstruct the options for this screen
					for (i = 0; i < MainMenuMovie.AllOptions.Length; i++)
					{
						if (MainMenuMovie.AllOptions[i].Identifier == Screen)
						{
							MainMenuMovie.MakeMenuOption(MainMenuMovie.AllOptions[i]);
							break;
						}
					}
				}
				else //this is a remove
				{
					//If the movie data has already been constructed then we need to go in to it and move shit around.
					OptionList = MainMenuMovie.MenuData.GetElementObject(Screen).GetObject("Options");
					ListLength = OptionList.GetFloat("length");

					for(i = SelectedIndex; i < ListLength; i++)
					{
						//Shift down, if possible
						if (i < ListLength - 1)
						{
							OptionList.SetElementObject(i, OptionList.GetElementObject(i+1));
						}
						else // otherwise just empty out
						{
							OptionList.SetElementObject(i, None);
						}
					}
					OptionList.SetFloat("length",ListLength-1);
				}

				//Either way we have to update
				ASVal.Type = AS_Number;
				ASVal.n = Screen;
				args.AddItem(ASVal);

				MainMenuMovie.Invoke("UpdateListItem",args);
			}
		}
	}
}

/**
 * Function to call to determine if a menu option is removed
 * @param Screen - the screen the option is on to be queried
 * @param SelectedIndex - the index of the option that is being queried
 * @return Whether or not the designated option is removed
 */
function bool IsOptionRemoved(byte Screen, byte SelectedIndex)
{
	local GearUIManager UIManager;
	local int i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	for (i = 0; i < UIManager.MainMenuRemovedLength; i++)
	{
		if (UIManager.MainMenuRemoved[i].Screen == Screen &&
			UIManager.MainMenuRemoved[i].SelectionIdx == SelectedIndex &&
			UIManager.MainMenuRemoved[i].bIsUndone == false)
		{
			return true;
		}
	}

	return false;
}


/**
 * Function called prior to the construction of the MenuData object.
 * This is the last chance to modify the AllOptions array before it is translated into it's GFx format
 */
function PreMainMenuConstruct()
{
}

/**
 * Function that modifies the next screen to go to for a given screen's menu option
 * @param BaseScreen - The screent that contains the menu option that you wish to modify
 * @param SelectionIdx - The selection index of the selection in the BaseScreen that you wish to modify
 * @param NewNextScreen - The new Next value that you wish to set for the selection SelectionIdx in screen BaseScreen
 */
function ModifyScreenFlow(byte BaseScreen, byte SelectionIdx, byte NewNextScreen)
{
	local array<ASValue> args;
	local ASValue ASVal;
	local GearMenuPC GMPCOwner, GMPC;
	local GearUIManager UIManager;
	local int i, NumPrevRemovedItems;
	local bool bAlreadyModded;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	if (UIManager != None && UIManager.MainMenuFlowModLength < `MAX_FLOWMOD_LENGTH)
	{
		//if we have not yet already implemented this change in the mainmenumovie, do it there now
		if (MainMenuMovie != none && MainMenuMovie.AllOptions[BaseScreen].List[SelectionIdx].Next != NewNextScreen)
		{
			//Set it in all options
			MainMenuMovie.AllOptions[BaseScreen].List[SelectionIdx].Next = EMainMenuOption(NewNextScreen);

			//If we have already constructed MenuData, set it there too
			if (MainMenuMovie.MenuData != none)
			{
				NumPrevRemovedItems = 0;
				//If we already removed something from in front of this one, then we need to update the index
				for ( i = 0; i < SelectionIdx; i++)
				{
					if (IsOptionRemoved(BaseScreen, i))
					{
						NumPrevRemovedItems++;
					}
				}

				MainMenuMovie.MenuData.GetElementObject(BaseScreen).GetObject("Options").GetElementObject(SelectionIdx-NumPrevRemovedItems).SetFloat("Next",NewNextScreen);
				//And then inform the movieplayer that we will need to refresh the base scene
				ASVal.Type = AS_Number;
				ASVal.n = BaseScreen;
				args.AddItem(ASVal);

				MainMenuMovie.Invoke("UpdateListItem",args);
			}
		}

		GMPCOwner = GearMenuPC(GetPC());

		//Also, if we are the server, we need to tell all the clients that stuff has just changed
		if (GMPCOwner != None &&
			GMPCOwner.Role == ROLE_Authority)
		{
			//Have we already modified this one?
			for (i = 0; i < UIManager.MainMenuFlowModLength; i++)
			{
				if (UIManager.MainMenuFlowMods[i].BaseScreen == BaseScreen &&
					UIManager.MainMenuFlowMods[i].SelectionIdx == SelectionIdx)
				{

					//Is this the same mod?!?
					if (UIManager.MainMenuFlowMods[i].ModifiedNext == NewNextScreen)
					{
						//If so, just return. We don't need to change anything or tell the clients
						return;
					}
					//Otherwise just change that mod
					UIManager.MainMenuFlowMods[i].ModifiedNext = NewNextScreen;
					bAlreadyModded = true;
					break;
				}
			}

			//Otherwise we need a new mod
			if (!bAlreadyModded)
			{
				UIManager.MainMenuFlowModLength++;
				UIManager.MainMenuFlowMods[UIManager.MainMenuFlowModLength-1].BaseScreen = BaseScreen;
				UIManager.MainMenuFlowMods[UIManager.MainMenuFlowModLength-1].SelectionIdx = SelectionIdx;
				UIManager.MainMenuFlowMods[UIManager.MainMenuFlowModLength-1].ModifiedNext = NewNextScreen; 
			}

			//For each player controller
			foreach GMPCOwner.WorldInfo.AllControllers(class'GearMenuPC', GMPC)
			{
				//If that player controller is not local
				if ( !GMPC.IsLocalPlayerController())
				{
					GMPC.ClientMainMenuFlowChange(UIManager.MainMenuFlowMods, UIManager.MainMenuFlowModLength);
				}
			}
		}
	}
}

/**
 * Function that synchs the frontend to the flow modifications stored in the GearUIManager
 */
function SynchToStoredFlowMods()
{
	local GearUIManager UIManager;
	local int i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	if (UIManager != None)
	{
		for (i = 0; i < UIManager.MainMenuFlowModLength; i++)
		{
			ModifyScreenFlow(UIManager.MainMenuFlowMods[i].BaseScreen, UIManager.MainMenuFlowMods[i].SelectionIdx, UIManager.MainMenuFlowMods[i].ModifiedNext);
		}
	}
}

/**
 * Function that synchs the frontend to the disabled items stored in the GearUIManager
 * NOTE: This will only disable things, not undisable them!
 */
function SynchToStoredDisabled()
{
	local GearUIManager UIManager;
	local int i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	if (UIManager != None)
	{
		for (i = 0; i < UIManager.MainMenuDisabledLength; i++)
		{
			SetOptionDisabled(UIManager.MainMenuDisabled[i].Screen, UIManager.MainMenuDisabled[i].SelectionIdx, UIManager.MainMenuDisabled[i].bIsDisabled);
		}
	}
}

/**
 * Function that synchs the frontend to the removed items stored in the GearUIManager
 */
function SynchToStoredRemoved()
{
	local GearUIManager UIManager;
	local int i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	if (UIManager != None)
	{
		for (i = 0; i < UIManager.MainMenuRemovedLength; i++)
		{
			SetOptionRemoved(UIManager.MainMenuRemoved[i].Screen, UIManager.MainMenuRemoved[i].SelectionIdx);
		}
	}
}

/**
 * Opens the xbox live marketplace blade for gears
 *
 * @param ControllerId - the controller id of the player who is to open the blade
 *
 */
function OpenMarketplaceBlade(int ControllerId)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerIntEx;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerIntEx = OnlineSub.PlayerInterfaceEx;
		if (PlayerIntEx != None)
		{
			PlayerIntEx.ShowContentMarketplaceUI(ControllerId);
		}
	}
}

/**
 * Determines whether the specified player is allowed to initiate an online search for a match.
 *
 * @param bShouldSkipPartyLeaderCheck whether to check is party leader
 */
function bool IsMatchmaking(optional bool bShouldSkipPartyLeaderCheck)
{
	local GearPartyGRI PartyGRI;

	PartyGRI = GearPartyGRI(GetGRI());

	// Explicitly check our matchmaking state
	if (PartyGRI != None && 
		PartyGRI.MatchmakingState != MMS_NotMatchmaking)
	{
		return bShouldSkipPartyLeaderCheck || IsPartyLeader();
	}

	return false;
}

/** @return number of local players */
final function int GetNumLocalPlayers()
{
	local GearPC PC;
	local int Count;
	local GearPC PlayerOwner;

	PlayerOwner = GetGearPC();

	foreach PlayerOwner.LocalPlayerControllers(class'GearPC', PC)
	{
		Count++;
	}

	return Count;
}

/** Iterates the PRI array and returns true if any players are guests of another player */
function bool PartyMemberIsAGuest()
{
	local int Index;
	local GearPartyGRI GRI;

	GRI = GearPartyGRI(GetGRI());
	if (GRI != None)
	{
		// Loop through all players checking for guest status
		for (Index = 0; Index < GRI.PRIArray.Length; Index++)
		{
			if (GearPartyPRI(GRI.PRIArray[Index]).bIsGuest)
			{
				return true;
			}
		}
	}
	return false;
}

/**
 * Determines whether the specified player is allowed to initiate an online search for a match.
 */
function bool IsAllowedToSearchForMatches()
{
	if (IsPartyLeader())
	{
		return IsOfficialMatch() || IsPlayerMatch();
	}
	return false;
}

/**
 * Returns whether anyone in the party does not have the DLC required for the currently selected playlist
 * @param bUseStrictCheck - used when proper replication has not taken place yet
 *		(this is useful for when you MUST know if the player has DLC, for normal user feedback we won't care about
 *		 this but for a button click that will require a proper check, we must use it)
 */
function bool PartyMemberLacksRequiredDLC( optional bool bUseStrictCheck )
{
	local int Idx;
	local GearPartyGRI GRI;

	GRI = GearPartyGRI(GetGRI());
	if (GRI != None)
	{
		// Loop through all players
		for (Idx = 0; Idx < GRI.PRIArray.length; Idx++)
		{
			// If one of the player doesn't have the required DLC return true
			if (!PlayerHasRequiredDLC(GearPRI(GRI.PRIArray[Idx]), bUseStrictCheck))
			{
				return true;
			}
		}
	}
	return false;
}

/**
 * Whether the player has the required DLCs needed for this playlist or not
 * @param bUseStrictCheck - used when proper replication has not taken place yet
 *		(this is useful for when you MUST know if the player has DLC, for normal user feedback we won't care about
 *		 this but for a button click that will require a proper check, we must use it)
 */
function bool PlayerHasRequiredDLC(GearPRI PlayerPRI, optional bool bUseStrictCheck)
{
	local int DLCIdx;
	local GearGRI GRI;
	local OnlinePlaylistManager PlaylistMan;
	local OnlineSubsystem OnlineSub;
	local array<int> ContentIds;
	local bool bResult;

	bResult = true;

	GRI = GetGRI();
	if (GRI != None)
	{
		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if (OnlineSub != None)
		{
			PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
			if (PlaylistMan != None)
			{
				// Get the content ids required for this playlist
				PlaylistMan.GetContentIdsFromPlaylist(GRI.PlaylistId, ContentIds);
				// If the content id list is empty then this playlist only uses shipped maps,
				// so we only need to do the content check if this list is > 0 in length
				if (ContentIds.length > 0)
				{
					// Make sure this is a valid PRI
					if (PlayerPRI != None && !PlayerPRI.bIsInactive)
					{
						// If they haven't replicated their DLC flag yet, return based on the strict check
						if (PlayerPRI.DLCFlag == -1)
						{
							bResult = !bUseStrictCheck;
						}
						// They've replicated so do the check
						else
						{
							// Loop through all the content ids and break out and return false if one fails
							for (DLCIdx = 0; DLCIdx < ContentIds.length; DLCIdx++)
							{
								if (ContentIds[DLCIdx] != 0 &&
									((PlayerPRI.DLCFlag & (1<<ContentIds[DLCIdx])) == 0))
								{
									bResult = false;
									break;
								}
							}
						}
					}
				}
			}
		}
	}
	else
	{
		bResult = !bUseStrictCheck;
	}

	return bResult;
}

/**
 * Determines whether all conditions required to begin searching for a match have been met.
 */
function bool IsReadyToSearchForMatches()
{
	local GearPartyGame_Base PartyGame;
	local bool bResult;

	if (IsAllowedToSearchForMatches())
	{
		// if we have the correct number of players for the selected gametype and match type, we're ready to start
		PartyGame = GetPartyGame();
		if (PartyGame != None)
		{
			bResult = !PartyGame.ArePlayersNeeded();
		}

		if (IsOfficialMatch() || IsPlayerMatch())
		{
			// don't allow searching until the playlist manager has been loaded
			if (!IsPlaylistManagerLoaded())
			{
				`Log("(GearUISceneFELobby_Party.IsReadyToSearchForMatches): Playlist manager hasn't been loaded.");
				bResult = false;
			}
		}
	}

	return bResult;
}

/**
 * Determine if the playlist manager is loaded by seeing if
 * any game settings objects for the current playlist type exist.
 *
 * @return TRUE if playlist manager game settings are loaded
 */
function bool IsPlaylistManagerLoaded()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlaylistManager PlaylistManager;
	local bool bResult;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlaylistManager = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
		if (PlaylistManager != None)
		{
			if (PlaylistManager.HasAnyGameSettings(CurrPlaylistId))
			{
				bResult = true;
			}
		}
	}

	return bResult;
}

/** Returns the number of valid PRIs in the GRI's PRIArray */
function int GetNumValidPRIs()
{
	local GearGRI GRI;
	local int Idx, Count;
	local UniqueNetId ZeroId;
	local GearPRI PRI;

	Count = 0;
	GRI = GetGRI();

	if ( GRI != None )
	{
		for ( Idx = 0; Idx < GRI.PRIArray.length; Idx++ )
		{
			PRI = GearPRI(GRI.PRIArray[Idx]);
			if ( PRI != None &&
				!PRI.bIsInactive &&
				// This means that have't fully replicated
				(PRI.UniqueId != ZeroId || IsLocalMatch()) &&
				PRI.DLCFlag != -1)
			{
				Count++;
			}
		}
	}

	return Count;
}

/** Called when the matchmaking state in the GRI changes */
function OnMatchMakingStateChanged()
{
	if (MatchmakingPanel != None)
	{
		MatchmakingPanel.OnMatchMakingStateChanged();
	}
}

/** Notification from the front end that the matchmaking screen has opened */
function MatchMakingPanelOpenedNotify()
{
	local array<ASValue> args;

	if (SmallPartyPanel != None)
	{
		// Tell the small party panel that it needs to display matchmaking players
		SmallPartyPanel.StartMatchmaking();
	}

	if (MainMenuMovie != None)
	{
		// Update the buttonbar when the matchmaking panel opens
		MainMenuMovie.UpdateButtonBar();

		
		if (GetPC().Role == ROLE_Authority)
		{
			//Tell flash to back up one menu if this is the host
			//Also transition main menu to the matchmaking empty menu
			ContinueFromHaltedState(true);
		}
		else
		{
			//If client, just tell it that matchmaking has started so it can move the client menu out of the way
			args.Length = 0;
			MainMenuMovie.Invoke("ClientMatchmakingStarted",args);
		}
	}
}

/** Notification from the front end that the matchmaking screen is closing */
function MatchMakingPanelClosedNotify()
{
	local array<ASValue> args;

	// Tell the small party panel that it needs to stop displaying matchmaking players
	if (SmallPartyPanel != None)
	{
		SmallPartyPanel.StopMatchmaking();
	}

	if (MainMenuMovie != None)
	{
		// Update the buttonbar when the matchmaking panel closes
		MainMenuMovie.UpdateButtonBar();

		args.Length = 0;
		if (GetPC().Role == ROLE_Authority)
		{
			//Tell flash to back up one menu if this is the host
			MainMenuMovie.Invoke("HostBackwards",args);
		}
		else
		{
			//If client, just tell it that matchmaking has ended so it can move the client menu back 
			MainMenuMovie.Invoke("ClientMatchmakingEnded",args);
		}
	}
}

/** Function called when we want to disallow any input from the main menu */
function LockMainMenuInput()
{
	MainMenuMovie.SetBool("bDenyInput", true);
}

/**
 * Handle opening the War Journal from the main menu
 * 
 * @param   PlayerToOpen    If specified, this is the local player that should be controlling the war journal.  Otherwise, the default player is used
 * 
 * @return FALSE always, since we don't need to advance the main menu
 */
function bool HandleOpenWarJournal(optional LocalPlayer PlayerToOpen)
{
	if( (WarJournalScene == None) && (WarJournalSceneClass != None) )
	{
		WarJournalScene = new(self) WarJournalSceneClass;
		WarJournalScene.Init( (PlayerToOpen != None) ? PlayerToOpen : GetLP() );
	}

	return FALSE;
}

/**
 * Closes the War Journal
 */
function OnWarJournalClosed()
{
	if( WarJournalScene != None )
	{
		MainMenuMovie.UpdateMenuFromProfile(true);
		WarJournalScene.Close();
		WarJournalScene = None;
	}
}

/**
 * Opens up the personal stats view, and sets it up for either a local player, post game stats, or leaderboard context.  Context is determined
 * by which parameter is specified, with a priority of local player > post game > leaderboard
 * 
 * @param   PlayerToOpen    Player owner for the personal stats screen, if this is a local player stats context
 * @param   Id              Net Id of the player to open the info for, if either RecentPlayers or Leaderboard is specified
 * @param   RecentPlayers   Recent players list, if this is a postgame stats details page.
 * @param   Leaderboard     Leaderboard with the player's all-time data, if this is a leaderboard context
 * @param   LocalPlayerStatType If this is a local player stat type (i.e. PlayerToOpen was specified, this governs the type of stats to display
 */
function OpenPersonalStats(LocalPlayer PlayerToOpen, UniqueNetId Id, GearRecentPlayersList RecentPlayers, GearLeaderboardBase Leaderboard, optional EGearMPTypes LocalPlayerStatType = eGEARMP_Warzone)
{
	if( (PersonalStatsSceneClass != None) && (PersonalStatsScene == None) )
	{
		PersonalStatsScene = new(self) PersonalStatsSceneClass;

		// Set the context, depending on where we were called from
		if( PlayerToOpen != None )
		{
			PersonalStatsScene.InitializePlayer_LocalPlayer( GearPC(PlayerToOpen.Actor), LocalPlayerStatType );
		}
		else if( RecentPlayers != None )
		{
			PersonalStatsScene.InitializePlayer_Postgame(Id, RecentPlayers);
		}
		else if( Leaderboard != None )
		{
			PersonalStatsScene.InitializePlayer_Leaderboards(Id, Leaderboard);
		}

		// Initialize the scene
		PersonalStatsScene.Init( (PlayerToOpen != None) ? PlayerToOpen : GetLP() );
	}
}

/**
 * Closes the personal stats screen
 */
function ClosePersonalStats()
{
	if( PersonalStatsScene != None )
	{
		PersonalStatsScene.Close(TRUE);
		PersonalStatsScene = None;
	}
}

/**
 * Handle opening the calendar from the main menu
 * 
 * @return TRUE always, since we don't need to block the main menu
 */
function bool HandleOpenCalendar()
{
	local OnlineSubsystem OnlineSub;

	if (Calendar != None)
	{
	 	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if (OnlineSub != None &&
			// Only open the calendar if there is a valid signed in, owning player
			OnlineSub.PlayerInterface.GetLoginStatus(LocalPlayerOwnerIndex) == LS_LoggedIn)
		{
			Calendar.OpenCalendarView();
			bCalendarIsOpen = true;
		}
		else
		{
			// Tell the user why they can't view the calendar
			class'GearUIManager'.static.DisplayErrorMessage("NeedLiveForCalendar_Message",
				"NeedGoldTier_Title",
				"GenericContinue",
				GetLP());
		}
	}

	return false;
}

/**
 * Closes the calendar view
 */
function CloseCalendar()
{
	if( (Calendar != None) && bCalendarIsOpen && (!Calendar.IsBusyAnimating()) )
	{
		Calendar.CloseCalendarView();
	}
}

/**
 * Callback from ActionScript when the calendar movie is finished animating out
 */
function Callback_CalendarClosed()
{
	bCalendarIsOpen = FALSE;
}

/**
 * Potentially opens the post game stats, depending on whether or not we have them
 * 
 * @param bIsAutomaticallyOpening - true if we are trying to open the screen automatically when the front end is first initialized.
 * @param bDontActuallyOpen - true if you don't want to really open post game stats, just want to know if it can be opened. False to actually open it
 * 
 * @return Returns true if the post game stats scene will open, false otherwise
 */
function bool ConditionalOpenPostGameStats(bool bIsAutomaticallyOpening, optional bool bDontActuallyOpen)
{
	local GearRecentPlayersList PlayersList;
	local GearMatchData MatchResults;
	local OnlineSubsystem OnlineSub;
	local GearLocalPlayer GLP;

 	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Get the recent player data for the last match stats
		PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
		if (PlayersList != None)
		{
			// Only open the post game stats if there is a valid owning player
			if (OnlineSub.PlayerInterface.GetLoginStatus(LocalPlayerOwnerIndex) > LS_NotLoggedIn)
			{
				// Make sure we have valid data and that if we are trying to automatically open
				// the screen that it is supposed
				GLP = GearLocalPlayer(GetLP());
				MatchResults = PlayersList.GetLastMatchResults();
				if (MatchResults != None &&
					MatchResults.LastMatchResults != None &&
					MatchResults.AllTimeMatchResults != None &&
					(!bIsAutomaticallyOpening ||
					 (GLP != None && GLP.bAutoDisplayPostGameStats)))
				{
					if (!bDontActuallyOpen)
					{
						OpenPostGameStats();
						// Clear the flag that tells us to automatically open the postgame stats
						GLP.bAutoDisplayPostGameStats = false;
					}
					return true;
				}
			}
		}
	}
	return false;
}

/**
 * Opens up the post-game stats scene
 */
function OpenPostGameStats()
{
	if( PostGameStatSceneClass != None && PostGameStatScene == None)
	{
		PostGameStatScene = new(self) PostGameStatSceneClass;
		PostGameStatScene.Init(GetLP());
	}
}

/**
 * Closes the post-game stats scene
 */
function ClosePostGameStats()
{
	if( PostGameStatScene != None )
	{
		PostGameStatScene.Close(TRUE);
		PostGameStatScene = None;
	}
}

/**
 * Callback function from Actionscript called when the selection has been changed in the mutator window
 * Used to inform the clients about what the host has selected via the GRI
 * 
 * @param NewSelection - the selected index in the current main menu screen
 */
function Callback_MutatorSelectedIndexChanged(float NewSelection)
{
	Callback_SelectedIndexChanged(NewSelection);
}

/**
 * Callback function from Actionscript called when a mutator has been toggled
 * 
 * @param MutatorIndex - the index into the MutatorClassArray of the mutator that has been toggled
 * @param bIsEnabled - Whether or not the mutator has been toggled to enabled or disabled
 */
function Callback_MutatorToggled(float MutatorIndex, bool bIsEnabled)
{
	local GearPartyGRI PartyGRI;
	local int i;
	local byte CurrentScreen;

	PartyGRI = GearPartyGRI(GetGRI());
	if (PartyGRI != none)
	{
		//Turn it on
		if (bIsEnabled)
		{
			//Find the first blank SelectedMutators slot and put the index in there
			for(i = 0; i < PartyGRI.NUM_SELECTED_MUTATORS; i++)
			{
				if (PartyGRI.SelectedMutators[i] == PartyGRI.NO_MUTATOR)
				{
					PartyGRI.SelectedMutators[i] = MutatorIndex;
					PartyGRI.bNetDirty = true;
					PartyGRI.bForceNetUpdate = true;
					break;
				}
				if (i == PartyGRI.NUM_SELECTED_MUTATORS)
				{
					`log("SELECTED A MUTATOR EVEN THOUGH ALL MUTATOR SLOTS ARE FILLED!!!");
				}
			}
		}
		else //turn it off
		{
			//Find the mutator slot that contains this index, and set it to NO_MUTATOR
			for(i = 0; i < PartyGRI.NUM_SELECTED_MUTATORS; i++)
			{
				if (PartyGRI.SelectedMutators[i] == MutatorIndex)
				{
					PartyGRI.SelectedMutators[i] = PartyGRI.NO_MUTATOR;
					PartyGRI.bNetDirty = true;
					PartyGRI.bForceNetUpdate = true;
					break;
				}
				if (i == PartyGRI.NUM_SELECTED_MUTATORS)
				{
					`log("UNSELECTED A MUTATOR EVEN THOUGH IT WAS NOT SELECTED IN THE FIRST PLACE!!!");
				}
			}
		}
	
		GetCurrentScreenAndSelection(CurrentScreen);
		SaveMutators(CurrentScreen == MAINMENUOP_Arcade_MutatorSelection);	
	}
}

/**
 * Callback function from Actionscript called when all mutators have been cleared out
 */
function Callback_ClearAllMutators()
{
	local GearPartyGRI PartyGRI;
	local int i;
	local byte CurrentScreen;

	PartyGRI = GearPartyGRI(GetGRI());
	if (PartyGRI != none)
	{
		for(i = 0; i < PartyGRI.NUM_SELECTED_MUTATORS; i++)
		{
			PartyGRI.SelectedMutators[i] = PartyGRI.NO_MUTATOR;
		}
		PartyGRI.bNetDirty = true;
		PartyGRI.bForceNetUpdate = true;

		GetCurrentScreenAndSelection(CurrentScreen);
		SaveMutators(CurrentScreen == MAINMENUOP_Arcade_MutatorSelection);	
	}
}

/**
 * Function that updates the mutators selected based on the SelectedMutators array in the GearPartyGRI
 */
function UpdateMutatorSelection()
{
	local GearPartyGRI PartyGRI;
	local array<ASValue> args;
	local ASValue ASVal;

	PartyGRI = GearPartyGRI(GetGRI());
	if (PartyGRI != none)
	{
		ASVal.Type = AS_Number;
		ASVal.n = PartyGRI.SelectedMutators[0];
		args.AddItem(ASVal);

		ASVal.n = PartyGRI.SelectedMutators[1];
		args.AddItem(ASVal);

		ASVal.n = PartyGRI.SelectedMutators[2];
		args.AddItem(ASVal);

		MainMenuMovie.GetObject("MutatorSelection").GetObject("Mutators").Invoke("UpdateMutatorSelection",args);
	}
}


/** 
 *  Function that updates the client unlocked numbers on the mutator selection screen based on the NumClientsUnlockedMutators array in the GearPartyGRI
 */
function UpdateMutatorClientNumbers()
{
	local GearPartyGRI PartyGRI;
	local int i;

	PartyGRI = GearPartyGRI(GetGRI());

	if (PartyGRI != None && MainMenuMovie != none && MainMenuMovie.MutatorData != none)
	{
		for (i = 0; i < MainMenuMovie.MutatorClassArray.Length; i++)
		{
			MainMenuMovie.MutatorData.GetElementObject(i).SetFloat("FriendsWithMutator", PartyGRI.NumClientsUnlockedMutators[i]);
		}
	}
}

/**
 * Called to blur out the main menu and party panelwhen a popup appears
 * 
 * @param   bool    bDesatAndBlur   TRUE if we want to use the desaturate and blur effect, FALSE for just the blur
 */
function BlurMainMenu(optional bool bDesatAndBlur)
{
	// Blur out the main menu movie
	BlurMovie(MainMenuMovie, 8.f, 8.f, 4.f, 0.25f);
	BlurMovie(SmallPartyPanel, 8.f, 8.f, 4.f, 0.25f);

	if( MatchmakingPanel != None )
	{
		BlurMovie(MatchmakingPanel, 8.f, 8.f, 4.f, 0.25f);
	}

	// Blur out the world
	if (GetPC().Role == ROLE_Authority)
	{
		GetGearPC().SetMenuPostProcessSettings(bDesatAndBlur ? DesatBlurPostProcessSettings : BlurPostProcessSettings, TRUE);
	}
}

/**
 * Called to unblur main menu and party panel when a popup appears
 */
function UnblurMainMenu()
{
	// Blur out the main menu movie
	BlurMovie(MainMenuMovie, 0.f, 0.f, 4.f, 0.25f);
	BlurMovie(SmallPartyPanel, 0.f, 0.f, 4.f, 0.25f);

	if( MatchmakingPanel != None )
	{
		BlurMovie(MatchmakingPanel, 0.f, 0.f, 4.f, 0.25f);
	}

	// Blur out the world
	if (GetPC().Role == ROLE_Authority)
	{
		GetGearPC().StopPostProcessOverride(eGPP_Menu, 0.35f);
	}
}

/**
 * Updates the UI with the option to sign a guest in or not
 *
 * @param ControllerId the controller that was inserted/removed
 * @param bIsConnected whether the controller is connected or not
 */
function OnControllerChange(int ControllerId,bool bIsConnected)
{
	UpdatePlayersAndControllers();
}


/**
 * Opens the difficulty selection screen if it is not already open
 */
function OpenDifficultySelectionScreen()
{
	local GearPartyGRI PartyGRI;

	if (DifficultySceneClass != none)
	{
		if (DifficultyScene != None)
		{
			DifficultyScene.Close();
		}

		DifficultyScene = new(self) DifficultySceneClass;
		DifficultyScene.FrontEndReference = self;
		DifficultyScene.Init(GetLP());
		if (GetPC().Role == ROLE_Authority)
		{
			PartyGRI = GearPartyGRI(GetGRI());
			if (PartyGRI != none)
			{
				PartyGRI.bDifficultySelection = true;
				PartyGRI.bForceNetUpdate = true;
			}
		}
	}
}

/**
 * Function called when the player has returned from the difficulty screen by aborting (pressing b)
 */
function ReturnFromDifficulty()
{
	local array<ASValue> args;
	
	args.Length = 0;
	MainMenuMovie.Invoke("ForceBackwardsUnstack",args);
}

/**
 * Function to set the party type
 * Use this instead of setting the profile settings directly so that we can determine if we need to enable/disable main menu
 * options based on party type changes
 * 
 * @param PartyType - The type of party to change to
 */
function SetPartyType(EGearVersusPartyType PartyType)
{
	GetGearPC().ProfileSettings.SetPartyType(PartyType);

	if (MainMenuMovie != none)
	{
		MainMenuMovie.DisableOptionsByPartyType(PartyType);
	}
}

defaultproperties
{
	StartScreen=MAINMENUOP_MainMenu
	PressedStartControllerId=INDEX_NONE

	WidgetBindings.Add((WidgetName="MainMenu",WidgetClass=class'UIWidget_MainMenu'))
	WidgetBindings.Add((WidgetName="mc_SmallPPanelContainer",WidgetClass=class'UIWidget_SmallPartyPanel'))
	WidgetBindings.Add((WidgetName="CalendarView",WidgetClass=class'UIWidget_Calendar'))
	WidgetBindings.Add((WidgetName="mc_Matchmaking",WidgetClass=class'UIWidget_MatchmakingControl'))

	OnPostAdvance=UpdateFrontEnd

	CurrPartyType=eGVPT_MAX

	//Don't capture input otherwise the attract movie won't get it and thus won't stop playing when that input is received
	CaptureKeys.Empty()

	BlurPostProcessSettings={(  bEnableBloom=FALSE,
								bEnableDOF=TRUE,
								bEnableMotionBlur=FALSE,
								bEnableSceneEffect=FALSE,

								DOF_InterpolationDuration=0.35f,
								DOF_FocusInnerRadius=0.f,
								DOF_MaxNearBlurAmount=1.f,
								DOF_MaxFarBlurAmount=1.f, 
				
								bOverride_EnableBloom=FALSE,
								bOverride_EnableDOF=TRUE,
								bOverride_EnableMotionBlur=FALSE,
								bOverride_EnableSceneEffect=FALSE,
								bOverride_AllowAmbientOcclusion=FALSE,
								bOverride_OverrideRimShaderColor=FALSE,

								bOverride_Bloom_Scale=FALSE,
								bOverride_Bloom_Threshold=FALSE,
								bOverride_Bloom_Tint=FALSE,
								bOverride_Bloom_ScreenBlendThreshold=FALSE,
								bOverride_Bloom_InterpolationDuration=FALSE,

								bOverride_DOF_FalloffExponent=FALSE,
								bOverride_DOF_BlurKernelSize=FALSE,
								bOverride_DOF_BlurBloomKernelSize=FALSE,
								bOverride_DOF_MaxNearBlurAmount=TRUE,
								bOverride_DOF_MaxFarBlurAmount=TRUE,
								bOverride_DOF_ModulateBlurColor=FALSE,
								bOverride_DOF_FocusType=FALSE,
								bOverride_DOF_FocusInnerRadius=TRUE,
								bOverride_DOF_FocusDistance=FALSE,
								bOverride_DOF_FocusPosition=FALSE,
								bOverride_DOF_InterpolationDuration=TRUE)}

	DesatBlurPostProcessSettings={(  bEnableBloom=FALSE,
								bEnableDOF=TRUE,
								bEnableMotionBlur=FALSE,
								bEnableSceneEffect=TRUE,

								DOF_InterpolationDuration=0.35f,
								DOF_FocusInnerRadius=0.f,
								DOF_MaxNearBlurAmount=1.f,
								DOF_MaxFarBlurAmount=1.f,

								Scene_Desaturation=1.f,
								Scene_InterpolationDuration=0.35f,
								ColorGrading_LookupTable=None,
				
								bOverride_EnableBloom=FALSE,
								bOverride_EnableDOF=TRUE,
								bOverride_EnableMotionBlur=FALSE,
								bOverride_EnableSceneEffect=FALSE,
								bOverride_AllowAmbientOcclusion=FALSE,
								bOverride_OverrideRimShaderColor=FALSE,
								bOverride_Scene_ColorGradingLUT=FALSE,

								bOverride_Scene_Desaturation = TRUE,
								bOverride_Scene_TonemapperScale = FALSE,
								bOverride_Scene_ImageGrainScale = FALSE,
								bOverride_Scene_HighLights = FALSE,
								bOverride_Scene_MidTones = FALSE,
								bOverride_Scene_Shadows = FALSE,
								bOverride_Scene_InterpolationDuration = TRUE,

								bOverride_Bloom_Scale=FALSE,
								bOverride_Bloom_Threshold=FALSE,
								bOverride_Bloom_Tint=FALSE,
								bOverride_Bloom_ScreenBlendThreshold=FALSE,
								bOverride_Bloom_InterpolationDuration=FALSE,

								bOverride_DOF_FalloffExponent=FALSE,
								bOverride_DOF_BlurKernelSize=FALSE,
								bOverride_DOF_BlurBloomKernelSize=FALSE,
								bOverride_DOF_MaxNearBlurAmount=TRUE,
								bOverride_DOF_MaxFarBlurAmount=TRUE,
								bOverride_DOF_ModulateBlurColor=FALSE,
								bOverride_DOF_FocusType=FALSE,
								bOverride_DOF_FocusInnerRadius=TRUE,
								bOverride_DOF_FocusDistance=FALSE,
								bOverride_DOF_FocusPosition=FALSE,
								bOverride_DOF_InterpolationDuration=TRUE)}
}
