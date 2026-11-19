/**
 * The main menu object linked to the main menu movie
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIWidget_MainMenu extends GFxObject
	Config(UI);

/** A specific choice on a menu page */
struct MenuElement
{
	var string Label;
	var EMainMenuOption Next;
	var string ImagePath;
	var bool bHaltProgression;
	var bool bIsDisabled;
	var string HeaderTypeOverride;
};

/** A menu page */
struct MenuList
{
	var array<MenuElement> List;
	var EMainMenuOption Identifier;
	var string Title;
	var string HeaderPicturePath;
	var EMainMenuScreenType ScreenType;
	var bool bUseSaveSlotScreen;
	var bool bUseStacker;
	var String StackerRenderer;
	var String HeaderType;
};

/** Reference to the movie player who owns this widget */
var UIScene_FrontEnd FrontEndMovie;

/** All of the options, as defined in the ini */
var config array<MenuList> AllOptions;

/** The dataprovider passed over to GFx */
var GFxObject MenuData;

/** The mutator screen's data provider */
var GFxObject MutatorData;

/* Array of Mutators in display order */
var config array<string> MutatorClassArray;


/** Reference to the ControllerMap MovieClip. Displays context for buttons. */
var GFxObject ControllerMap;
/** String to display in the controller map */
var String ButtonBarString;


/** Localized strings */
var localized string AcceptButtonStr;
var localized string BackButtonStr;
var localized string DLCButtonStr;
var localized string OptionsButtonStr;
var localized string StartGameButtonStr;
var localized string StartMatchmakingButtonStr;
var localized string CancelMatchmakingButtonStr;
var localized string LeavePartyStr;
var localized string MutatorButtonClearString;
var localized string MutatorButtonDoneString;
var localized string SlotString;
var localized string GuestLoginButtonStr;
var localized string PostGameStatsStr;

var localized array<string> DifficultyNames;

var localized string RegionPresenceStr;
var localized string WorldPresenceStr;

/** Act/chapter pic to use when player has not unlocked the act/chapter */
var string LockedPicPath;

/** Container struct that contains an array of the game settings we want to display for the various game types */
struct GameSettingInfo
{
	/** The settings ID for the custom game option.  See GearVersusGameSettings.uc for definition of most of these, or the specific game setting class for more choices */
	var array<int>  SettingID;
};

/** Struct that maps versus game settings to profile mappings */
struct GearSettingsMapping
{
	/** The context value in the game settings object */
	var int GameSettingContext;
	/** The SettingId in the profile */
	var int ProfileId;
	/** Current value set in the UI */
	var int CurrValue;
	/** Whether the property is ID mapped or not (for profile) */
	var bool bIsIDMapped;
};

/** An array containg the settings to display for the various game types, indexed by EGearMPTypes */
var array<GameSettingInfo>  CustomGameSettings;

/** Array of cached values for versus game options that is loaded from the profile */
var array<GearSettingsMapping> VersusMappings;

/** Whether or not to show the preview menus */
var config bool bHidePreviewMenus;

/** How fast to switch text on the ticker in milliseconds*/
var config float TickerUpdateTimeInterval_MSEC;

/************************************************************************************************
 * END VARIABLES
 ***********************************************************************************************/


/** Initialization function called right after this widget is created */
function Initialize()
{
	// Init the versus mapping array
	InitializeVersusGameSettingMappings();
}

/** Initializes the mapping array that handles profile to game setting mappings */
function InitializeVersusGameSettingMappings()
{
	VersusMappings[eGEARVERSUSSETTING_WingmanScore].ProfileId = `WingmanScore;
	VersusMappings[eGEARVERSUSSETTING_KOTHRoundScore].ProfileId = `KOTHRoundScore;
	VersusMappings[eGEARVERSUSSETTING_NoobRoundScore].ProfileId = `NewbieRoundScore;
	VersusMappings[eGEARVERSUSSETTING_EnemyDiff].ProfileId = `HordeEnemyDiff;
	VersusMappings[eGEARVERSUSSETTING_HordeWave].ProfileId = `HordeWave;
	VersusMappings[eGEARVERSUSSETTING_RoundsToWin].ProfileId = `MPRoundsToWin;
	VersusMappings[eGEARVERSUSSETTING_RoundTime].ProfileId = `MPRoundTime;
	VersusMappings[eGEARVERSUSSETTING_NumBots].ProfileId = `MPNumBots;
	VersusMappings[eGEARVERSUSSETTING_BotDiff].ProfileId = `MPBotDiff;
	VersusMappings[eGEARVERSUSSETTING_Bleedout].ProfileId = `MPBleedout;
	VersusMappings[eGEARVERSUSSETTING_FriendlyFire].ProfileId = `MPFriendlyFire;
	VersusMappings[eGEARVERSUSSETTING_MapSelection].ProfileId = `MAP_SELECTION_MODE;
	VersusMappings[eGEARVERSUSSETTING_WeaponSwap].ProfileId = `MPWeaponSwap;
	VersusMappings[eGEARVERSUSSETTING_SiegeEnemyDiff].ProfileId = `SiegeEnemyDiff;
	VersusMappings[eGEARVERSUSSETTING_SiegeWave].ProfileId = `SiegeWave;
}

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
	local bool bResult;
	`log("MainMenu WidgetInitialized: "$WidgetName,,'GearsUI');

	bResult = false;
	switch(WidgetName)
	{           
		case ('ControllerMap'):
			if (ControllerMap == none)
			{
				ControllerMap = Widget;
				UpdateButtonBar();
				bResult = true;
			}            
			break;

		//Mutator screen widgets
		case 'MutatorButtonClear':
			Widget.SetString("label",MutatorButtonClearString);
			break;
		case 'MutatorButtonDone':
			Widget.SetString("label",MutatorButtonDoneString);
			break;
		default:
			break;
	}

	return bResult;
}

/** Whether to display the button bar or not */
function bool ShouldDisplayButtonBar()
{
	return (FrontEndMovie.SystemLinkScene == None);
}

/** Updates the button bar that displays at the bottom of the front end */
function UpdateButtonBar()
{
	local String BuildString;
	local String Spacer;
	local bool bIsMatchmaking;

	if (ShouldDisplayButtonBar())
	{
		Spacer = "     ";

		// Determine if we're matchmaking
		if (FrontEndMovie.MatchmakingPanel != None &&
			FrontEndMovie.MatchmakingPanel.bPanelIsActive)
		{
			bIsMatchmaking = true;
		}

		// Client and server have different button bar strings
		if (FrontEndMovie != None &&
			FrontEndMovie.GetGRI().Role == ROLE_Authority)
		{
			// First figure out the A button (don't show while matchmaking)
			if (!bIsMatchmaking)
			{
				if (ShouldDisplayStartGame())
				{
					BuildString = StartGameButtonStr;
				}
				else if (ShouldDisplayStartMatchmaking())
				{
					BuildString = StartMatchmakingButtonStr;
				}
				else
				{
					BuildString = AcceptButtonStr;
				}
			}
			else
			{
				BuildString = CancelMatchmakingButtonStr;
			}

			// Back button (don't show it while matchmaking)
			if (!bIsMatchmaking)
			{
				BuildString $= Spacer $ BackButtonStr;
			}

			// Add the options menu
			BuildString $= Spacer $ OptionsButtonStr;

			// Add DLC button
			//BuildString $= Spacer $ DLCButtonStr;

			// Add the guest login button if needed
			if (FrontEndMovie.bAllowGuestLogin)
			{
				BuildString $= Spacer $ GuestLoginButtonStr;
			}
		}
		else
		{
			// Accept and back buttons (don't show while matchmaking)
			if (FrontEndMovie.MatchmakingPanel == None ||
				!FrontEndMovie.MatchmakingPanel.bPanelIsActive)
			{
				BuildString $= AcceptButtonStr $ Spacer $ LeavePartyStr;
			}

			// Add the options menu
			BuildString $= Spacer $ OptionsButtonStr;

			// Add DLC button
			//BuildString $= Spacer $ DLCButtonStr;
		}
	}

	if (FrontEndMovie.ConditionalOpenPostGameStats(false, true))
	{
		BuildString $= Spacer $ PostGameStatsStr;
	}

	// Only set the string if it is different
	if (ButtonBarString != BuildString)
	{
		ButtonBarString = BuildString;
		ControllerMap.GetObject("textField").SetString("htmlText", ButtonBarString);
	}
}

/** Whether we are currently in a place where we could start a game */
function bool ShouldDisplayStartGame()
{
	local byte CurrMenuOption;

	FrontEndMovie.GetCurrentScreenAndSelection(CurrMenuOption);
	switch (CurrMenuOption)
	{
		case MAINMENUOP_VS_CustomWarzone:
		case MAINMENUOP_VS_CustomExecution:
		case MAINMENUOP_Horde_Options:
		case MAINMENUOP_VS_CustomWingman:
		case MAINMENUOP_VS_CustomKOTH:
		case MAINMENUOP_VS_CustomCTL:
		case MAINMENUOP_VS_CustomNewbie:
		case MAINMENUOP_Siege_Options:
		case MAINMENUOP_VS_Training:
			return true;
	}
	return false;
}

/** Whether we are currently in a place where we could start matchmaking */
function bool ShouldDisplayStartMatchmaking()
{
	local byte CurrMenuOption;
	local int CurrSelection;

	FrontEndMovie.GetCurrentScreenAndSelection(CurrMenuOption, CurrSelection);
	switch (CurrMenuOption)
	{
		case MAINMENUOP_Horde:
		case MAINMENUOP_Siege:
			return (CurrSelection == 0);
		case MAINMENUOP_VS_Playlist1:
		case MAINMENUOP_VS_Playlist2:
		case MAINMENUOP_VS_Playlist3:
		case MAINMENUOP_VS_Playlist4:
		case MAINMENUOP_VS_Playlist5:
		case MAINMENUOP_VS_Playlist6:
		case MAINMENUOP_VS_Playlist7:
		case MAINMENUOP_VS_Playlist8:
			return (CurrSelection < 2);
	}
	return false;
}

/** Notification from the front end movie that the selection has changed in the menu */
function SelectedIndexChangedNotify()
{
	local byte CurrMenuOption;

	FrontEndMovie.GetCurrentScreenAndSelection(CurrMenuOption);
	if (CurrMenuOption == MAINMENUOP_Horde ||
		CurrMenuOption == MAINMENUOP_Siege)
	{
		UpdateButtonBar();
	}
}

/** Whether or not there is currently DLC available that the player */

/** 
 *  Initialization function called after all widgets have been initialized
 *  Constructs all of the menu data, sets the localization, and tells gfx to initialize itself off of that data
 */
function SubPostWidgetInit()
{
	local array<ASValue> args;
	local ASValue ASVal;
	local GearPC GPC;
	local byte x;
	
	/* 
	local array<String> TickerStrings;

	TickerStrings.AddItem("NEEDS");
	TickerStrings.AddItem("REAL");
	TickerStrings.AddItem("DATA");

	InitializeTicker(TickerStrings, TickerUpdateTimeInterval_MSEC);
	*/

	ConstructMainMenuData();

	//Main menu index
	ASVal.Type = AS_Number;
	ASVal.n = FrontEndMovie.StartScreen;
	args.AddItem(ASVal);

	//Client menu index
	ASVal.Type = AS_Number;
	x = MAINMENUOP_ClientMenu;
	ASVal.n = Float(x);
	args.AddItem(ASVal);

	//Base header value
	ASVal.Type = AS_String;
	//ASVal.s = Localize("MainMenu", "MainMenu", "GearGameUI");
	ASVal.s = "";
	args.AddItem(ASVal);

	//Host or not?
	GPC = GearPC(GetPC());
	ASVal.Type = AS_Boolean;
	ASVal.b = (GPC != None && GPC.Role == ROLE_Authority);
	args.AddItem(ASVal);

	//Whether or not to show the preview menus
	ASVal.b = bHidePreviewMenus;
	args.AddItem(ASVal);

	//Primary controller id
	ASVal.Type = AS_Number;
	ASVal.n = GetLP().ControllerId;
	args.AddItem(ASVal);

	Invoke("InitializeMenus", args);
}

/**
 * Function that initializes the ticker object in flash
 */
function InitializeTicker(array<String> TickerStrings, float TickerUpdateTime)
{
	local GFxObject TickerStringArray;
	local int Idx;

	//Set the ticker strings
	TickerStringArray = CreateArray();
	for (Idx = 0; Idx < TickerStrings.Length; Idx++)
	{
		TickerStringArray.SetElementString(Idx,TickerStrings[Idx]);
	}
	SetObject("TickerStrings",TickerStringArray);

	//Initialize the ticker update time interval
	SetFloat("TickerUpdateTimeInterval", TickerUpdateTime);
}

/** 
 *  Given a specific MenuList object, construct the corresponding gfx version of that object
 *  
 *  @param Option - The MenuList object to base the gfx object off of
 */
simulated function MakeMenuOption(MenuList Option)
{
	local GFxObject CurrentOption, CurrentList, OptionObject;
	local int i,j;

	OptionObject = MenuData.GetElementObject(Option.Identifier);
	CurrentList = OptionObject.GetObject("Options");
	if (CurrentList == none)
	{
		CurrentList = CreateArray();
		OptionObject.SetObject("Options",CurrentList);
	}
	
	//Since we may not add all options due to the IsOptionRemoved check, we need another index for inserting
	j = 0;
	for (i = 0; i < Option.List.Length; i++)
	{
		if (!FrontEndMovie.IsOptionRemoved(Option.Identifier,i))
		{
			CurrentOption = CreateObject("Object");
			CurrentOption.SetString("label",Caps(Localize("MainMenu", Option.List[i].Label, "GearGameUI")));
			CurrentOption.SetString("ToolTip",Localize("MainMenu","TOOLTIP_"$Option.List[i].Label, "GearGameUI"));
			CurrentOption.SetFloat("Next",Option.List[i].Next);
			CurrentOption.SetBool("bHaltProgression",Option.List[i].bHaltProgression);
			CurrentOption.SetBool("bIsDisabled",Option.List[i].bIsDisabled);
			CurrentOption.SetBool("bShowBang",false);
			CurrentOption.SetString("HeaderTypeOverride", Option.List[i].HeaderTypeOverride);
			if (Option.List[i].ImagePath != "")
			{
				CurrentOption.SetString("Picture", "img://"$Option.List[i].ImagePath);
			}	
			CurrentList.SetElementObject(j,CurrentOption);
			j++;
		}
	}

	OptionObject.SetString("Title",Caps(Localize("MainMenu",Option.Title,"GearGameUI")));
	if (Option.HeaderPicturePath != "")
	{
		OptionObject.SetString("HeaderPicturePath","img://"$Option.HeaderPicturePath);
	}
	OptionObject.SetString("HeaderType",Option.HeaderType);

	switch (Option.ScreenType)
	{
		case MMSCREENTYPE_Mutators:
			OptionObject.SetBool("bIsMutatorScreen",true);
			break;
		case MMSCREENTYPE_SaveSlot:
			//OptionObject.SetBool("bUseSaveSlots",true);
			OptionObject.SetBool("bUseStacker", true);
			OptionObject.SetString("StackerRenderer", Option.StackerRenderer);
			break;
		case MMSCREENTYPE_SingleStacker:
			OptionObject.SetBool("bUseStacker", true);
			OptionObject.SetString("StackerRenderer", Option.StackerRenderer);
			break;
	}
}

/**
 * Construct all of the custom options screens
 */
simulated function ConstructCustomOptions()
{
	local GearUIDataStore_GameResource GameResourceDS;
	local GearUIDataStore_GameSettings SettingsDS;
	local array<UIResourceDataProvider> Providers;
	local GearGameInfoSummary Provider;
	local EGearMPTypes MPType;
	local int i,j,k, StringIndex;
	local GFxObject List, CurrentOption, StepperList;
	local GearVersusGameSettings GameSettings;
	local array<IdToStringMapping> StringValues;
	local int NextValue;
	local GearProfileSettings ProfileSettings;
	local array<Name> MapSelectStringValues;

	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	SettingsDS = GearUIDataStore_GameSettings(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameSettings'.default.Tag, None));
	
	if ( GameResourceDS != None && SettingsDS != None)
	{
		// Grab the providers
		if ( GameResourceDS.GetResourceProviders('GameTypes', Providers) )
		{
			for (i = 0; i < Providers.Length; i++)
			{
				Provider = GearGameInfoSummary(Providers[i]);
				if (Provider != none)
				{
					//Figure out what screen corresponds to this provider, and get its list
					//It is computed by taking the enum value of the gametype and adding it to the MAINMENUOP_VS_CustomWarzone
					//This is why the custom game option screens must be contiguous after MAINMENUOP_VS_CustomWarzone and be in the order of the enum
					MPType = Provider.MPGameMode;
					GameSettings = GearVersusGameSettings(SettingsDS.GameSettingsCfgList[MPType].GameSettings);

					List = MenuData.GetElementObject(MAINMENUOP_VS_CustomWarzone+MPType);
					List = List.GetObject("Options");
					//Now we have the list that we need to populate
					for (j = 0; j < CustomGameSettings[MPType].SettingID.Length; j++)
					{
						// Create the objects
						CurrentOption = CreateObject("Object");
						StepperList = CreateArray();

						// Special case the map selection since it doesn't exist in the game settings objects
						if (CustomGameSettings[MPType].SettingID[j] == `MAP_SELECTION_MODE)
						{
							CurrentOption.SetString("label",Caps(Localize("GameSettingsOptions", "MapSelectionMode", "GearGame")));
							ProfileSettings = GearPC(GetPC()).ProfileSettings;
							ProfileSettings.GetProfileSettingValueId(CustomGameSettings[MPType].SettingID[j], StringIndex);

							MapSelectStringValues.Length = 0;
							ProfileSettings.GetProfileSettingValues(CustomGameSettings[MPType].SettingID[j], MapSelectStringValues);
							for (k=0; k < MapSelectStringValues.Length; k++)
							{
								StepperList.SetElementString(k, String(MapSelectStringValues[k]));
							}
						}
						else
						{
							CurrentOption.SetString("label",Caps(GameSettings.GetSettingOptionName(CustomGameSettings[MPType].SettingID[j])));
							GameSettings.GetStringSettingValue(CustomGameSettings[MPType].SettingID[j],StringIndex);
							
							StringValues.Length = 0;
							GameSettings.GetStringSettingValueNames(CustomGameSettings[MPType].SettingID[j], StringValues);
							for (k=0; k < StringValues.Length; k++)
							{
								StepperList.SetElementString(k, String(StringValues[k].Name));
							}
						}

						// Set the data to the newly created objects
						//If this is horde then it is possible that we will be going to mutator selection after this screen
						if (MPType == eGEARMP_Horde)
						{
							NextValue = MAINMENUOP_Horde_MutatorSelection;
							//It is also possible that we will NOT, so we need to halt.
							CurrentOption.SetBool("bHaltProgression",true);
						}
						else
						{
							NextValue = MAINMENUOP_None;
						}
						CurrentOption.SetFloat("OptionId",CustomGameSettings[MPType].SettingID[j]);
						CurrentOption.SetFloat("Next",NextValue);
						CurrentOption.SetObject("StepperDataProvider",StepperList);
						CurrentOption.SetFloat("StepperSelectedIndex", StringIndex );
/*
						`log("======================================================================");
						`log("GameType: "$MPType);
						`log("j: "$j);
						`log("k: "$j);
						`log("StringValues.Length: "$StringValues.Length);
						for (k = 0; k < StringValues.Length; k++)
						{
							`log("StringValue "$StringValues[k].Name);
						}
						`log("StringIndex: "$StringIndex);
						`log("StepperListLength: "$StepperList.GetFloat("length"));
						for (k = 0; k < StepperList.GetFloat("length"); k++)
						{
							`log("StringValue "$StepperList.GetElementString(k));
						}
						`log("======================================================================");
*/
						// Set the object to the list
						List.SetElementObject(j,CurrentOption);
					}
				}
			}
		}
	}
}

/** 
 *  Construct a gfx object representing a playlist page
 *  
 *  @param PageID - The byte index of the page to construct on
 */
simulated function ConstructPlaylists(byte PageID)
{
	local GFxObject CurrentOption, CurrentList, OptionsObject, NextOption, CustomOption;
	local int i,j,x;
	local UIDataStore_OnlinePlaylists PlaylistDS;
	local array<UIResourceDataProvider> ProviderList;
	local GearOnlinePlaylistProvider PlaylistProv;
	local GearUIDataStore_GameResource GameResourceDS;
	local int GameProviderIndex;
	local GearGamePlaylistGameTypeProvider GameTypeProvider;


	OptionsObject = MenuData.GetElementObject(PageID);
	CurrentList = CreateArray();
	OptionsObject.SetObject("Options",CurrentList);

	PlaylistDS = UIDataStore_OnlinePlaylists(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlinePlaylists'.default.Tag));
	PlaylistDS.GetResourceProviders( name(class'UIDataStore_OnlinePlaylists'.const.UNRANKEDPROVIDERTAG), ProviderList);
	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));

	if (GameResourceDS == None || PlaylistDS == None)
	{
		`log("Failure to get GameResourceDS and/or PlaylistDS");
		return;
	}

	j = 0;
	//We refuse to show more than 8 playlists
	for (i = ProviderList.Length - 1; i >= 0 && j < 8; i--)
	{
		PlaylistProv = GearOnlinePlaylistProvider(ProviderList[i]);
		if (PlaylistProv != none &&
			PlaylistProv.Name != 'Horde' &&
			PlaylistProv.Name != 'Siege' &&
			PlaylistProv.Name != 'HordeRanked' &&
			PlaylistProv.Name != 'SiegeRanked')
		{
			CurrentOption = CreateObject("Object");
			CurrentOption.SetString("label",Caps(PlaylistProv.DisplayName));
			CurrentOption.SetString("ToolTip",PlaylistProv.PlaylistDescription);
			CurrentOption.SetBool("bHaltProgression",true);
			//The next screen is determined by the order of the playlists
			x = MAINMENUOP_VS_Playlist1+j;
			CurrentOption.SetFloat("Next",float(x));

			//The title of the next screen is determined by the name of the playlist that leads to it
			NextOption = MenuData.GetElementObject(x);
			NextOption.SetString("Title", Caps(PlaylistProv.DisplayName));

			//if the length of gametype names is greater than 1 than this is a composite playlist and there can be no custom option
			if (PlaylistProv.PlaylistGameTypeNames.length > 1)
			{
				//Remove the custom option completely from the next screen
				//NextOption.GetObject("Options").SetElementObject(2,None);

				//Disable the custom option
				NextOption.GetObject("Options").SetElementMemberBool(2,"bIsDisabled",true);
			}
			else //It has a custom option
			{
				//First figure out what gametype this playlist is
				GameProviderIndex = GameResourceDS.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex( PlaylistProv, 0 );
				if (GameProviderIndex != INDEX_NONE)
				{
					GameTypeProvider = GameResourceDS.GetPlaylistGameTypeProvider( GameProviderIndex );
					if (GameTypeProvider != None)
					{
						//Determine what the next screen will be
						switch(GameTypeProvider.MPGameMode)
						{
							case eGEARMP_Warzone:
								x = MAINMENUOP_VS_CustomWarzone;
								break;
							case eGEARMP_Execution:
								x = MAINMENUOP_VS_CustomExecution;
								break;
							case eGEARMP_Wingman:
								x = MAINMENUOP_VS_CustomWingman;
								break;
							case eGEARMP_KOTH:
								x = MAINMENUOP_VS_CustomKOTH;
								break;
							case eGEARMP_CTL:
								x = MAINMENUOP_VS_CustomCTL;
								break;
							case eGEARMP_Newbie:
								x = MAINMENUOP_VS_CustomNewbie;
								break;
						}
						//Set it on the custom option
						CustomOption = NextOption.GetObject("Options").GetElementObject(2);
						CustomOption.SetFloat("Next",x);
					}
				}
			}

			CurrentOption.SetFloat("PlaylistID",PlaylistProv.PlaylistId);
			CurrentOption.SetFloat("RankedPlaylistID",PlaylistProv.RankedPlaylistId);
			CurrentList.SetElementObject(j,CurrentOption);
			j++;
		}
	}
}

/** 
 *  Construct a gfx object representing the act select page for campaign
 *  
 *  @param PageID - The byte index of the page to construct on
 */
simulated function ConstructActList(byte PageID)
{
	local GFxObject CurrentOption, CurrentList, OptionsObject;
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> ActProviders;
	local int ProviderIndex;
	local UIProviderScriptFieldValue Val;
	local int i,x;
	local int DifficultyLevel;
	local bool bIsActUnlocked;
	local GearCampaignActData ActData;

	OptionsObject = MenuData.GetElementObject(PageID);
	CurrentList = CreateArray();
	OptionsObject.SetObject("Options",CurrentList);

	// Show a picture on this screen
	OptionsObject.SetBool("bUseStacker", TRUE);
	OptionsObject.SetString("StackerRenderer", "CampaignItemRenderer");

	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	if ( GameResourceDS != None )
	{
		// Grab the act providers
		if ( GameResourceDS.GetResourceProviders('Acts', ActProviders) )
		{
			Val.PropertyTag = 'ActNum';
			Val.PropertyType = DATATYPE_Property;

			for (i = 0; i < ActProviders.Length; i++)
			{
				// Find the index to provider i
				Val.StringValue = string(i);
				ProviderIndex = GameResourceDS.FindProviderIndexByFieldValue('Acts', 'ActNum', Val);
				if ( ProviderIndex != INDEX_NONE )
				{
					ActData = GearCampaignActData(ActProviders[ProviderIndex]);
					CurrentOption = CreateObject("Object");
					CurrentOption.SetString("label",ActData.ListName);
					CurrentOption.SetBool("bWantCallback",false);
					x = MAINMENUOP_MAX+i; //Chapter select options are on the end, hack to allow for more chapters to be added in DLC
					CurrentOption.SetFloat("Next",float(x));

					//Use the LockedPicPath when the profile says the player has not yet unlocked this profile
					CurrentOption.SetString("Picture", "img://"$ActData.ScreenshotPathName);

					//Okay, now that we've made a link to this act's chapter select screen, we should really construct that chapter select screen
					bIsActUnlocked = ConstructChapterSelectData(i, ActData, DifficultyLevel, OptionsObject.GetString("HeaderPicturePath"));

					//And now that the chapter screen has constructed, we have been passed back data on what we need to do for this act
					CurrentOption.SetBool("disabled",!bIsActUnlocked);
					CurrentOption.SetFloat("Medal",DifficultyLevel);

					CurrentList.SetElementObject(i,CurrentOption);
				}			
			}
		}
	}
}

/** 
 *  Construct a gfx object representing a chapter select page for campaign
 *  
 *  @param  ActNum - The act number you wish to construct the chapter select page for
 *  @param  ActData - The data provider representing that act's data
 *  @param  ActDifficultyLevel - Out parameter for passing out the min difficulty level all chapters on this page were beaten at (if any)
 *  @param  HeaderPicturePath - The path of the header picture to be set for this chapter select page
 *  
 *  @return Whether or not the act that this page represents has any unlocked chapters in it
 */
simulated function bool ConstructChapterSelectData(int ActNum, const out GearCampaignActData ActData, out int ActDifficultyLevel, string HeaderPicturePath)
{
	local GFxObject CurrentOption, CurrentList, OptionsObject;
	local int i,x;
	local GearCampaignChapterData ChapterData;
	local GearUIManager UIManager;
	local int StorageIndex, StorageOffset;
	local int DifficultyLevel;
	local bool bIsChapterUnlocked;
	local bool bIsActUnlocked;

	bIsActUnlocked = false;
	ActDifficultyLevel = DL_Insane;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	OptionsObject = CreateObject("Object");
	CurrentList = CreateArray();
	OptionsObject.SetObject("Options",CurrentList);

	OptionsObject.SetBool("bIsDifficultyScreen",false);
	OptionsObject.SetString("Title",Caps(Localize("MainMenu","TITLE_SPChapterSelect","GearGameUI")));
	OptionsObject.SetString("HeaderPicturePath",HeaderPicturePath);
	
	// Show a picture on this screen
	OptionsObject.SetBool("bUseStacker", TRUE);
	OptionsObject.SetString("StackerRenderer", "CampaignItemRenderer");

	for (i = 0; i < ActData.ChapterProviders.length; i++)
	{
		ChapterData = ActData.ChapterProviders[i];

		CurrentOption = CreateObject("Object");
		CurrentOption.SetString("label",ChapterData.ListName);
		x = MAINMENUOP_SPDifficulty;
		CurrentOption.SetFloat("Next",x);

		//Based on stored data in uimanager
		StorageIndex = ChapterData.ChapterNum / 32;
		StorageOffset = ChapterData.ChapterNum % 32;
		bIsChapterUnlocked = class'GearAwardManager'.static.BitIsSet(UIManager.UnlockedChapters[StorageIndex], StorageOffset);

		CurrentOption.SetBool("disabled", !bIsChapterUnlocked);
		//-1=none, 0=casual, 1=normal, etc: Uses the EDifficultyLevel enum
		DifficultyLevel = INDEX_NONE;

		if (bIsChapterUnlocked)
		{
			bIsActUnlocked = true;
			//Check to see from most difficult to least difficulty what level we've beat this chapter at
			if (class'GearAwardManager'.static.BitIsSet(UIManager.CompletedChaptersInsane[StorageIndex], StorageOffset))
			{
				DifficultyLevel = DL_Insane;
			}
			else if (class'GearAwardManager'.static.BitIsSet(UIManager.CompletedChaptersHard[StorageIndex], StorageOffset))
			{
				DifficultyLevel = DL_Hardcore;
			}
			else if (class'GearAwardManager'.static.BitIsSet(UIManager.CompletedChaptersNormal[StorageIndex], StorageOffset))
			{
				DifficultyLevel = DL_Normal;
			}
			else if (class'GearAwardManager'.static.BitIsSet(UIManager.CompletedChaptersCasual[StorageIndex], StorageOffset))
			{
				DifficultyLevel = DL_Casual;
			}
		}
		CurrentOption.SetFloat("Medal", DifficultyLevel); //this is fake data, replace with profile data

		if (DifficultyLevel < ActDifficultyLevel)
		{
			ActDifficultyLevel = DifficultyLevel;
		}

		//Use the LockedPicPath when the profile says the player has not yet unlocked this profile
		CurrentOption.SetString("Picture", "img://"$ChapterData.ScreenshotPathName);

		CurrentList.SetElementObject(i,CurrentOption);
	}

	MenuData.SetElementObject(MAINMENUOP_MAX+ActNum,OptionsObject);

	return bIsActUnlocked;
}

/** 
 *  Construct a gfx object representing the mutator selection data
 */
simulated function ConstructMutatorList()
{
	local GFxObject CurrentOption;
	local int i;
	local class<GearMutator> MutatorClass;
	local bool bHasUnlockedMutator;

	MutatorData = CreateArray();
	SetObject("MutatorData",MutatorData);

	for(i =0; i < MutatorClassArray.Length; i++)
	{
		MutatorClass = none;
		if (MutatorClassArray[i] != "")
		{
			MutatorClass = class<GearMutator>(DynamicLoadObject(MutatorClassArray[i],class'Class'));
		}

		CurrentOption = CreateObject("Object");
		CurrentOption.SetBool("bIsEnabled",false);
		
		if (MutatorClass != none)
		{
			CurrentOption.SetBool("bExists",true);
			CurrentOption.SetString("MutatorName",MutatorClass.default.MutatorName);
			CurrentOption.SetString("MutatorInfo",MutatorClass.default.MutatorInfo);
			
			//Awards are unlocked by either having no unlock award required or by having the unlock award required
			bHasUnlockedMutator = (MutatorClass.default.UnlockAwardName == "") || (FrontEndMovie.GetGearPC().AwardManager.HasEarnedAwardByName(name(MutatorClass.default.UnlockAwardName)));
			CurrentOption.SetBool("bHasHostUnlocked", bHasUnlockedMutator );
			if (bHasUnlockedMutator)
			{
				CurrentOption.SetString("Image", "img://"$MutatorClass.default.IconPath);
			}
			else
			{
				//@todo - figure out your progress towards unlocking this mutator
				CurrentOption.SetFloat("ProgressCurrent", 5);
				CurrentOption.SetFloat("ProgressTotal", 10);

				//@todo - show whatever the locked pic should be
				CurrentOption.SetString("Image", "img://"$"DEFAULT LOCKED PIC GOES HERE");
			}
			CurrentOption.SetFloat("FriendsWithMutator", 0 );
			//@todo: Figure out whether or not this mutator should be pre-enabled
			//CurrentOption.SetBool("bIsEnabled",true);
		}
		else
		{
			CurrentOption.SetBool("bExists",false);
			CurrentOption.SetString("MutatorName","");
			CurrentOption.SetString("MutatorInfo","");
		}
		MutatorData.SetElementObject(i,CurrentOption);
	}
	FrontEndMovie.UpdateMutatorClientNumbers();
}


/** Construct all of the gfx representations for the main menu and sets them in gfx */
simulated function ConstructMainMenuData()
{
	local int i;
	local GFxObject OptionObject;

	`log("Constructing Main Menu Data",,'GearsUI');

	MenuData = CreateArray();

	//Construct everything based on AllOptions ini settings
	for (i = 0; i < AllOptions.Length; i++)
	{
		OptionObject = CreateObject("Object");
		MenuData.SetElementObject(AllOptions[i].Identifier,OptionObject);
		MakeMenuOption(AllOptions[i]);

		//If this is the clientmenu, also attach on the MatchmakingTitle loc...
		if (AllOptions[i].Identifier == MAINMENUOP_ClientMenu)
		{
			OptionObject.SetString("MatchmakingTitle",Caps(Localize("MainMenu","TITLE_Matchmaking","GearGameUI")));
		}
	}

	//Construct the playlists
	ConstructPlaylists(MAINMENUOP_VS_Playlists);
	//Construct the act select page (which will also construct the chapter select pages)
	ConstructActList(MAINMENUOP_SPActSelect);
	// Load the custom game options for versus
	LoadCustomGameSettingsFromProfile();
	//Construct the custom options gametype screens
	ConstructCustomOptions();

	//Construct all of the mutator data, and set it in flash
	ConstructMutatorList();

	//Update the save slots
	UpdateSaveSlotOptions();

	//Update menu with profile/persistent data information (bangs)
	UpdateMenuFromProfile();

	//Update the population numbers from the downloaded info
	UpdatePopulationNumbers();

	//Disable all options that should be disabled by party type
	DisableOptionsByPartyType(FrontEndMovie.GetGearPC().ProfileSettings.GetPartyType());

	//Have flash do the heavy lifting now
	SetObject("MenuData", MenuData);
}

/**
 * Function to disable or enable options based on the current party type
 * @param PartyType - the type of party
 */
simulated function DisableOptionsByPartyType( EGearVersusPartyType PartyType)
{
	local byte Index;
	local array<ASValue> args;
	local ASValue ASVal;

	if (FrontEndMovie.GetGearPC().ProfileSettings.GetPartyType() == eGVPT_SystemLink ||
		FrontEndMovie.GetGearPC().ProfileSettings.GetPartyType() == eGVPT_Local)
	{
		//Disable the social and ranked options for all playlists
		for(Index = MAINMENUOP_VS_Playlist1; Index <= MAINMENUOP_VS_Playlist8; Index++)
		{
			FrontEndMovie.SetOptionDisabled(Index,0,true);
			FrontEndMovie.SetOptionDisabled(Index,1,true);
		}

		//Also horde and siege
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Horde,0,true);
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Horde,1,true);
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Siege,0,true);
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Siege,1,true);

		//Campaign join online too
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Campaign,3,true);
	}
	else
	{
		//Enable the social and ranked options for all playlists
		for(Index = MAINMENUOP_VS_Playlist1; Index <= MAINMENUOP_VS_Playlist8; Index++)
		{
			FrontEndMovie.SetOptionDisabled(Index,0,false);
			FrontEndMovie.SetOptionDisabled(Index,1,false);
		}

		//Also horde and siege
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Horde,0,false);
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Horde,1,false);
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Siege,0,false);
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Siege,1,false);

		//Campaign join online too
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Campaign,3,false);
	}

	//If we've already constructed the menus, we need to update them if they are in use
	if (MenuData != none)
	{
		//Now tell AS about this, so they can update the main menu if it is visible atm
		//VS Playlists
		for(Index = MAINMENUOP_VS_Playlist1; Index <= MAINMENUOP_VS_Playlist8; Index++)
		{
			ASVal.n = Index;
			args[0] = ASVal;
			
			Invoke("UpdateListItem",args);
		}

		//Horde
		Index = MAINMENUOP_Horde;
		ASVal.n = Index;
		args[0] = ASVal;	
		Invoke("UpdateListItem",args);

		//Siege
		Index = MAINMENUOP_Siege;
		ASVal.n = Index;
		args[0] = ASVal;	
		Invoke("UpdateListItem",args);

		//Campaign
		Index = MAINMENUOP_Campaign;
		ASVal.n = Index;
		args[0] = ASVal;	
		Invoke("UpdateListItem",args);
	}
}

/**
 * Updates the menu with information from the profile and persistent data
 * (Used to update the bangs)
 * 
 * @param bForceMenuRefresh - if true, this will also force the menu to refresh its data right now
 */
simulated function UpdateMenuFromProfile( optional bool bForceMenuRefresh)
{
	local GFxObject OptionsList;
	local int i;
	local bool bShowJournalBang;
	local array<ASValue> args;
	local ASValue ASVal;
	local array<int> UpdatedScreens;

	bShowJournalBang = class'UIScene_WarJournal'.static.AnyPagesNeedViewed(FrontEndMovie.GetGearPC());

	//HostMenu
	OptionsList = MenuData.GetElementMemberObject(MAINMENUOP_MainMenu,"Options");	
	for (i=0; i < OptionsList.GetFloat("length"); i++)
	{
		//War Journal
		if (int(OptionsList.GetElementMemberFloat(i,"Next")) == MAINMENUOP_WarJournal)
		{
			//Only change it if it's not the same
			if (OptionsList.GetElementMemberBool(i,"bShowBang") != bShowJournalBang)
			{
				OptionsList.SetElementMemberBool(i,"bShowBang",bShowJournalBang);
				UpdatedScreens.AddItem(MAINMENUOP_MainMenu);
			}
		}
	}

	//ClientMenu
	OptionsList = MenuData.GetElementMemberObject(MAINMENUOP_ClientMenu,"Options");	
	for (i=0; i < OptionsList.GetFloat("length"); i++)
	{
		//War Journal
		if (OptionsList.GetElementMemberString(i,"label") == Caps(Localize("MainMenu", "Journal", "GearGameUI")))
		{
			//Only change it if it's not the same
			if (OptionsList.GetElementMemberBool(i,"bShowBang") != bShowJournalBang)
			{
				OptionsList.SetElementMemberBool(i,"bShowBang",bShowJournalBang);
				UpdatedScreens.AddItem(MAINMENUOP_ClientMenu);
			}
		}
	}

	if (bForceMenuRefresh)
	{
		ASVal.Type = AS_Number;
		args.AddItem(ASVal);
		for (i = 0; i < UpdatedScreens.Length; i++)
		{
			args[0].n = UpdatedScreens[i];
			Invoke("UpdateListItem",args);
		}
	}
}

/**
 * Function to update the population numbers in the UI header by injecting the numbers into the GFx objects
 */
simulated function UpdatePopulationNumbers()
{
	local OnlinePlaylistManager PlaylistMan;
	local OnlineSubsystem OnlineSub;
	local int Idx;
	local int Length;
	local int WorldNumRanked, RegionNumRanked;
	local int WorldNumSocial, RegionNumSocial;
	local GFxObject PlaylistPage, PlaylistOptions, PlaylistChoice;
	local GFxObject SpecificPlaylistPage, SpecificPlaylistOptions, SpecificPlaylistChoice;
	local GFxObject HordePage, HordeOptions, HordeChoice;
	local GFxObject SiegePage, SiegeOptions, SiegeChoice;
	local GFxObject CampaignPage, CampaignOptions, CampaignChoice;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != none)
	{
		PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
		if (PlaylistMan != none)
		{
			//VS Playlists
			PlaylistPage = MenuData.GetElementObject(MAINMENUOP_VS_Playlists);
			PlaylistOptions = PlaylistPage.GetObject("Options");

			Length = PlaylistOptions.GetFloat("length");
			for(Idx = 0; Idx < Length; Idx++)
			{
				PlaylistChoice = PlaylistOptions.GetElementObject(Idx);

				SpecificPlaylistPage = MenuData.GetElementObject(PlaylistChoice.GetFloat("Next"));
				SpecificPlaylistOptions = SpecificPlaylistPage.GetObject("Options");

				//Social
				PlaylistMan.GetPopulationInfoFromPlaylist(PlaylistChoice.GetFloat("PlaylistID"),WorldNumSocial, RegionNumSocial);
				SpecificPlaylistChoice = SpecificPlaylistOptions.GetElementObject(0);
				SpecificPlaylistChoice.SetString("RegionPresenceString",RegionNumSocial @ RegionPresenceStr);
				SpecificPlaylistChoice.SetString("WorldPresenceString",WorldNumSocial @ WorldPresenceStr);
				
				//Ranked
				PlaylistMan.GetPopulationInfoFromPlaylist(PlaylistChoice.GetFloat("RankedPlaylistID"),WorldNumRanked, RegionNumRanked);
				SpecificPlaylistChoice = SpecificPlaylistOptions.GetElementObject(1);
				SpecificPlaylistChoice.SetString("RegionPresenceString",RegionNumRanked @ RegionPresenceStr);
				SpecificPlaylistChoice.SetString("WorldPresenceString",WorldNumRanked @ WorldPresenceStr);

				//Total playlist numbers
				PlaylistChoice.SetString("RegionPresenceString",(RegionNumRanked+RegionNumSocial) @ RegionPresenceStr);
				PlaylistChoice.SetString("WorldPresenceString",(WorldNumRanked+WorldNumSocial) @ WorldPresenceStr);
			}

			//Horde
			HordePage = MenuData.GetElementObject(MAINMENUOP_Horde);
			HordeOptions = HordePage.GetObject("Options");

			PlaylistMan.GetPopulationInfoFromPlaylist(FrontEndMovie.GetPlaylistIdForGameType(eGEARMP_Horde,false),WorldNumSocial, RegionNumSocial);
			HordeChoice = HordeOptions.GetElementObject(0);
			HordeChoice.SetString("RegionPresenceString",RegionNumSocial @ RegionPresenceStr);
			HordeChoice.SetString("WorldPresenceString",WorldNumSocial @ WorldPresenceStr);

			PlaylistMan.GetPopulationInfoFromPlaylist(FrontEndMovie.GetPlaylistIdForGameType(eGEARMP_Horde,true),WorldNumRanked, RegionNumRanked);
			HordeChoice = HordeOptions.GetElementObject(1);
			HordeChoice.SetString("RegionPresenceString",RegionNumRanked @ RegionPresenceStr);
			HordeChoice.SetString("WorldPresenceString",WorldNumRanked @ WorldPresenceStr);

			//Siege
			SiegePage = MenuData.GetElementObject(MAINMENUOP_Siege);
			SiegeOptions = SiegePage.GetObject("Options");

			PlaylistMan.GetPopulationInfoFromPlaylist(FrontEndMovie.GetPlaylistIdForGameType(eGEARMP_Siege,false),WorldNumSocial, RegionNumSocial);
			SiegeChoice = SiegeOptions.GetElementObject(0);
			SiegeChoice.SetString("RegionPresenceString",RegionNumSocial @ RegionPresenceStr);
			SiegeChoice.SetString("WorldPresenceString",WorldNumSocial @ WorldPresenceStr);

			PlaylistMan.GetPopulationInfoFromPlaylist(FrontEndMovie.GetPlaylistIdForGameType(eGEARMP_Siege,true),WorldNumRanked, RegionNumRanked);
			SiegeChoice = SiegeOptions.GetElementObject(1);
			SiegeChoice.SetString("RegionPresenceString",RegionNumRanked @ RegionPresenceStr);
			SiegeChoice.SetString("WorldPresenceString",WorldNumRanked @ WorldPresenceStr);

			//CampaignOnline
			CampaignPage = MenuData.GetElementObject(MAINMENUOP_Campaign);
			CampaignOptions = CampaignPage.GetObject("Options");

			PlaylistMan.GetPopulationInfoFromPlaylist(0,WorldNumSocial, RegionNumSocial);

			//If JoinOnline is no longer guaranteed to be the last option in this screen, then this code will break, however atm there is no less fragile way of detecting the join online option.
			Length = CampaignOptions.GetFloat("length");
			CampaignChoice = CampaignOptions.GetElementObject(Length-1);
			CampaignChoice.SetString("RegionPresenceString",RegionNumSocial @ RegionPresenceStr);
			CampaignChoice.SetString("WorldPresenceString",WorldNumSocial @ WorldPresenceStr);
		}
	}	
}

/** ActionScript stub for opening and configuring the title screen. */
simulated function ASOpenTitleScreen()
{
	ActionScriptVoid("OpenTitleScreen");
}

/** ActionScript stub for opening and configuring the main menu with a transition from the title screen. */
simulated function ASOpenMainMenu(int PrimaryController)
{
	local array<ASValue> args;
	local ASValue ASVal;

	//Set the primary controller!
	ASVal.Type = AS_Number;
	ASVal.n = PrimaryController;
	args.AddItem(ASVal);

	Invoke("OpenMainMenu", args);
}

/** ActionScript stub for opening and configuring the main menu directly, skipping the title screen. */
simulated function ASOpenMainMenuDirect(int PrimaryController)
{
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_Number;
	ASVal.n = PrimaryController;
	args.AddItem(ASVal);

	Invoke("OpenMainMenuDirect", args);
}

/**
 * Updates the MenuData with info from the save slots for the currently loaded profile
 */
simulated function UpdateSaveSlotOptions()
{
	local GFxObject SaveSlot,OptionList, Option;
	local int i;
	local string LabelString;
	local GearCampaignChapterData ChapterData;
	local GearCampaignActData ActData;
	local bool bHasUsedSaveSlot;
	local GearUIManager UIManager;
	local array<ASValue> args;
	local ASValue ASVal;
	local int LatestSaveSlotIdx;
	local string ContinueActString, ContinueChapterString;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());

	LatestSaveSlotIdx = FrontEndMovie.GetLatestSaveSlotIndex();
	SaveSlot = MenuData.GetElementObject(MAINMENUOP_SaveSlots);
	OptionList = SaveSlot.GetObject("Options");
	for (i = 0; i < AllOptions[MAINMENUOP_SaveSlots].List.Length && i < `NUM_SAVE_SLOTS; i++)
	{
		Option = OptionList.GetElementObject(i);
		//Is the slot corrupted?
		if (UIManager.SaveSlotData[i].bIsCorrupted)
		{
			LabelString = Caps(Localize("MainMenu","CorruptSlot","GearGameUI"));
			Option.SetBool("bIsCorrupted", true);
			Option.SetBool("bIsEmpty", false);
			bHasUsedSaveSlot = true;
		}
		//Is the slot empty?
		else if (!UIManager.SaveSlotData[i].bContainsData)
		{
			LabelString = Caps(Localize("MainMenu","EmptySlot","GearGameUI"));
			Option.SetBool("bIsCorrupted", false);
			Option.SetBool("bIsEmpty", true);
		}
		//The slot contains data
		else
		{
			bHasUsedSaveSlot = true;
			Option.SetBool("bIsCorrupted", false);
			Option.SetBool("bIsEmpty", false);

			//Basic stuff
			Option.SetFloat("DifficultyNum", UIManager.SaveSlotData[i].Difficulty);
			Option.SetString("DifficultyName", DifficultyNames[UIManager.SaveSlotData[i].Difficulty]);
			Option.SetString("TimeString", GearGFxMoviePlayer(Outer).CreateTimeString(UIManager.SaveSlotData[i].SecondsSinceMidnight));
			Option.SetString("DateString", GearGFxMoviePlayer(Outer).GetNumericDateString(UIManager.SaveSlotData[i].Year,
																							UIManager.SaveSlotData[i].Month,
																							UIManager.SaveSlotData[i].Day));
						

			ChapterData = class'GearUIDataStore_GameResource'.static.GetChapterDataProvider(UIManager.SaveSlotData[i].ChapterNum);
			if ( ChapterData != None )
			{
				Option.SetFloat("ChapterNum", ChapterData.ChapterNum);
				Option.SetString("ChapterName", ChapterData.DisplayName);
				Option.SetString("ChapterImg", ChapterData.ScreenshotPathName);
				if (i == LatestSaveSlotIdx)
				{
					ContinueChapterString = ChapterData.DisplayName;
				}
			}
			else
			{
				Option.SetFloat("ChapterNum", 0);
				Option.SetString("ChapterName", "");
				Option.SetString("ChapterImg", "");
			}

			//Act
			ActData = class'GearUIDataStore_GameResource'.static.GetActDataProviderUsingChapterProvider( ChapterData );
			if ( ActData != None )
			{
				Option.SetString("ActName", ActData.DisplayName);
				if (i == LatestSaveSlotIdx)
				{
					ContinueActString = ActData.DisplayName;
				}
			}
			else
			{
				Option.SetString("ActName", "");
			}

			//Construct the label
			/*
			LabelString = Option.GetString("ActName") $ " : " $ 
						  Option.GetString("ChapterName") $ " - " $
						  Option.GetString("DifficultyName") $ " (" $
						  Option.GetString("DateString") @ Option.GetString("TimeString");
			*/
			LabelString = SlotString @ string(i);
		}
		
		
		Option.SetString("label",LabelString);
		Option.SetBool("bHaltProgression",AllOptions[MAINMENUOP_SaveSlots].List[i].bHaltProgression);
	}

	//You don't have a used save slot, so this must be your first time playing campaign
	//Thus, make the UI skip new game straight to gametype selection
	
	//And disable 'load'
	if (!bHasUsedSaveSlot)
	{
		//New -> Pick gametype
		FrontEndMovie.ModifyScreenFlow(MAINMENUOP_Campaign,1, MAINMENUOP_SPGametype);
		//Disable Load
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Campaign,2,true);
		//Load -> Nothing (so when you cursor over load, there is no preview)
		FrontEndMovie.ModifyScreenFlow(MAINMENUOP_Campaign,2, MAINMENUOP_None);
		//Remove Continue
		FrontEndMovie.SetOptionRemoved(MAINMENUOP_Campaign,0);
	}
	else
	{
		//Send the info for the continue slot to flash
		ASVal.Type = AS_String;
		//ACT
		ASVal.s = ContinueActString;
		args.AddItem(ASVal);
		//CHAPTER
		ASVal.s = ContinueChapterString;
		args.AddItem(ASVal);
		FrontEndMovie.Invoke("SetContinueHeaderInfo",args);

		//Put Continue back
		FrontEndMovie.SetOptionRemoved(MAINMENUOP_Campaign,0,true);
		//New -> Save Slots
		FrontEndMovie.ModifyScreenFlow(MAINMENUOP_Campaign,1, MAINMENUOP_SaveSlots);
		//Enable Load
		FrontEndMovie.SetOptionDisabled(MAINMENUOP_Campaign,2,false);
		//Load -> Save Slots
		FrontEndMovie.ModifyScreenFlow(MAINMENUOP_Campaign,2, MAINMENUOP_SaveSlots);
	}
}

/** Function called on the host to initialize the custom game settings from the profile and to propagate it to the GRI */
function LoadCustomGameSettingsFromProfile()
{
	// Load the GRI and the local setting cache with the values stored in the profile
	LoadCustomGameSettingsToGRI();
	// Update all of the game settings objects in the datastore from the local setting cache
	UpdateGameSettingsObjects();
}

/** Update all of the game settings objects in the datastore with the values that were cached from the host's profile */
function UpdateGameSettingsObjects()
{
	local GearUIDataStore_GameSettings SettingsDS;
	local int ObjectIdx;
	local int SettingIdx;
	local int CurrValue;

	// Get the datastore where the game settings live
	SettingsDS = GearUIDataStore_GameSettings(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameSettings'.default.Tag, None));
	// Make sure we have a valid datastore and profile
	if (SettingsDS != None)
	{
		// Iterate over all custom game settings objects
		for (ObjectIdx = 0; ObjectIdx < CustomGameSettings.Length; ObjectIdx++)
		{
			// Iterate over all the game settings this object cares about
			for (SettingIdx = 0; SettingIdx < CustomGameSettings[ObjectIdx].SettingID.Length; SettingIdx++)
			{
				// Get the current value of the setting
				CurrValue = GetCurrValueFromSettingContext(CustomGameSettings[ObjectIdx].SettingID[SettingIdx]);

				// Don't set the game settings objects if the value is invalid
				if (CurrValue != -1)
				{
					// Set the current value in the game settings object
					SettingsDS.GameSettingsCfgList[ObjectIdx].GameSettings.SetStringSettingValue(CustomGameSettings[ObjectIdx].SettingID[SettingIdx], CurrValue, false);
				}
			}
		}
	}
}

/** Load the GRI with all of the custom game settings from the profile of the host of the party */
function LoadCustomGameSettingsToGRI()
{
	local GearPartyGRI PartyGRI;
	local GearProfileSettings ProfileSettings;
	local int SettingValue;
	local int SettingIdx;

	// Grab the GRI and set the replicated game settings from the host's profile
	PartyGRI = GearPartyGRI(FrontEndMovie.GetGRI());
	if (PartyGRI != None && PartyGRI.Role == ROLE_Authority)
	{
		// Make sure we have a profile
		ProfileSettings = GearPC(GetPC()).ProfileSettings;
		if (ProfileSettings != None)
		{
			// Iterate across the cached setting array and fill it in using the profile settings
			for (SettingIdx = 0; SettingIdx < VersusMappings.Length; SettingIdx++)
			{
				// Make sure the profile ID is valid
				if (VersusMappings[SettingIdx].ProfileId != INDEX_NONE)
				{
					// See if this is ID mapped or not
					if (VersusMappings[SettingIdx].bIsIDMapped)
					{
						if (ProfileSettings.GetProfileSettingValueId(VersusMappings[SettingIdx].ProfileId, SettingValue))
						{
							// Was able to find the settings, set values and inform the UI
							OnCustomGameSettingChanged(SettingIdx, SettingValue, false);
						}
					}
					// Get the current value in the profile
					else if (ProfileSettings.GetProfileSettingValueInt(VersusMappings[SettingIdx].ProfileId, SettingValue))
					{
						// Was able to find the settings, set values and inform the UI
						OnCustomGameSettingChanged(SettingIdx, SettingValue, false);
					}
				}
			}
		}
	}
}

/**
 * Copies option values from the cached game's settings to the player's profile.
 *
 * @param	WriteProfileSettingsCompleteDelegate	the function to call when the profile save is complete.
 */
function bool SaveGameSettingsToProfile(optional delegate<OnlinePlayerInterface.OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate, optional bool bSaveProfile=true)
{
	local int SettingIdx;
	local GearProfileSettings ProfileSettings;
	local GearPartyGRI PartyGRI;
	local bool bResult;
	local GearPC OwnerPC;

	// Only save on the host
	PartyGRI = GearPartyGRI(FrontEndMovie.GetGRI());
	if (PartyGRI != None && PartyGRI.Role == ROLE_Authority)
	{
		// Make sure we have a profile
		OwnerPC = GearPC(GetPC());
		ProfileSettings = OwnerPC.ProfileSettings;
		if (ProfileSettings != None)
		{
			// Iterate across the cached setting array and fill it in using the profile settings
			for (SettingIdx = 0; SettingIdx < VersusMappings.Length; SettingIdx++)
			{
				// Make sure the profile ID is valid
				if (VersusMappings[SettingIdx].ProfileId != INDEX_NONE)
				{
					// See if this is ID mapped or not
					if (VersusMappings[SettingIdx].bIsIDMapped)
					{
						ProfileSettings.SetProfileSettingValueId(VersusMappings[SettingIdx].ProfileId, VersusMappings[SettingIdx].CurrValue);
					}
					else
					{
						ProfileSettings.SetProfileSettingValueInt(VersusMappings[SettingIdx].ProfileId, VersusMappings[SettingIdx].CurrValue);
					}
				}
			}

			// Save the profile if told to
			if (bSaveProfile)
			{
				bResult = FrontEndMovie.SaveProfile(WriteProfileSettingsCompleteDelegate);
			}
			else
			{
				bResult = true;
			}
		}
	}

	return bResult;
}

/**
 * Callback function for when an option stepper has been changed
 * @param OptionID - the identifier of the option that has been changed
 * @param OptionIndex - the new value that the option stepper has been changed to
 */
final function Callback_OptionStepperChange(float OptionID, float OptionIndex)
{
	local int SettingIdx;
	local GearPartyGRI PartyGRI;

	// Iterate through the cached values so we can set the new data
	for (SettingIdx = 0; SettingIdx < VersusMappings.Length; SettingIdx++)
	{
		// Found the matching context
		if (VersusMappings[SettingIdx].GameSettingContext == OptionID)
		{
			// Set the data
			OnCustomGameSettingChanged(SettingIdx, OptionIndex, false);

			// Refresh the game settings object in the datastore on the host
			PartyGRI = GearPartyGRI(FrontEndMovie.GetGRI());
			if (PartyGRI != None &&
				PartyGRI.Role == ROLE_Authority)
			{
				UpdateGameSettingsObjects();
			}
		}
	}
}

/**
 * A custom setting was changed, so figure out which one(s) and update them
 *
 * @param bForceUpdate - will force all custom settings to refresh the UI
 */
simulated function OnCustomGameSettingsChanged(optional bool bForceUpdate)
{
	local int SettingIdx;
	local int SettingValue;
	local GearPartyGRI PartyGRI;

	// Grab the GRI so we can loop through the settings
	PartyGRI = GearPartyGRI(FrontEndMovie.GetGRI());
	if (PartyGRI != None)
	{
		// Loop through all settings in the GRI
		for (SettingIdx = 0; SettingIdx < VersusMappings.Length; SettingIdx++)
		{
			// Get the setting from the GRI
			SettingValue = PartyGRI.GameSettingsValues[SettingIdx];
			// Make sure it's valid and differs from our current value
			if (bForceUpdate ||
				(SettingValue != 255 &&
				 SettingValue != VersusMappings[SettingIdx].CurrValue))
			{
				OnCustomGameSettingChanged(SettingIdx, SettingValue, true, bForceUpdate);
			}
		}

		// Refresh the game settings object in the datastore on the host
		if (PartyGRI.Role == ROLE_Authority)
		{
			UpdateGameSettingsObjects();
		}
	}
}

/**
 * Called when the value in the custom game settings has changed
 *
 * @param SettingIdx - the index into the cached values array
 * @param SettingValue - the value for the setting
 * @param bUpdateUI - whether the UI should refresh when the value changes
 * @param bForceUpdate - will force all custom settings to refresh the UI
 */
simulated function OnCustomGameSettingChanged(int SettingIdx, int SettingValue, bool bUpdateUI, optional bool bForceUpdate)
{
	local GearPartyGRI PartyGRI;
	local GearUIDataStore_GameSettings SettingsDS;
	local int Idx;

	// If there was a change
	if (bForceUpdate ||
		SettingValue != VersusMappings[SettingIdx].CurrValue)
	{
		// Set the local cached version of the value
		VersusMappings[SettingIdx].CurrValue = SettingValue;

		// Update the UI
		if (bUpdateUI || bForceUpdate)
		{
			FrontEndMovie.ChangeOptionStepperSelection(VersusMappings[SettingIdx].GameSettingContext, SettingValue);
		}

		// Propagate the settings across all settings objects
		SettingsDS = GearUIDataStore_GameSettings(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameSettings'.default.Tag, None));
		for (Idx = 0; Idx < SettingsDS.GameSettingsCfgList.Length; Idx++)
		{
			SettingsDS.GameSettingsCfgList[Idx].GameSettings.SetStringSettingValue(VersusMappings[SettingIdx].GameSettingContext, SettingValue, false);
		}
	}

	PartyGRI = GearPartyGRI(FrontEndMovie.GetGRI());
	// Set the value in the GRI so it can be replicated on the host
	if (PartyGRI != None && PartyGRI.Role == ROLE_Authority)
	{
		if (PartyGRI.GameSettingsValues[SettingIdx] != SettingValue)
		{
			PartyGRI.GameSettingsValues[SettingIdx] = SettingValue;
			PartyGRI.bForceNetUpdate = true;
			PartyGRI.bNetDirty = true;
		}
	}
}

/**
 * Helper function that returns the ProfileId of a give game setting context Id
 *
 * @param SettingContext - the online context value of the game setting in question
 *
 * @return - the profileid of the game settings getting searched for
 */
function int GetProfileIdFromSettingContext(int SettingContext)
{
	local int MapIdx;

	// Iterate across all mappings until we find a match
	for (MapIdx = 0; MapIdx < VersusMappings.Length; MapIdx++)
	{
		if (VersusMappings[MapIdx].GameSettingContext == SettingContext)
		{
			return VersusMappings[MapIdx].ProfileId;
		}
	}
}

/**
 * Helper function that returns the current value of a give game setting context Id
 *
 * @param SettingContext - the online context value of the game setting in question
 *
 * @return - the value of the game settings getting searched for
 */
function int GetCurrValueFromSettingContext(int SettingContext)
{
	local int MapIdx;

	// Iterate across all mappings until we find a match
	for (MapIdx = 0; MapIdx < VersusMappings.Length; MapIdx++)
	{
		if (VersusMappings[MapIdx].GameSettingContext == SettingContext)
		{
			return VersusMappings[MapIdx].CurrValue;
		}
	}
}


defaultproperties
{
	LockedPicPath="UI_Portraits.MP.UI_MP_RandomMark"

	VersusMappings(eGEARVERSUSSETTING_WingmanScore)=(GameSettingContext=CONTEXT_WINGMAN_SCOREGOAL,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_KOTHRoundScore)=(GameSettingContext=CONTEXT_ROUNDSCORE_KOTH,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_NoobRoundScore)=(GameSettingContext=CONTEXT_ROUNDSCORE_NEWB,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_EnemyDiff)=(GameSettingContext=CONTEXT_ENEMYDIFFICULTY,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_HordeWave)=(GameSettingContext=CONTEXT_HORDE_WAVE,CurrValue=-1,bIsIDMapped=true)
	VersusMappings(eGEARVERSUSSETTING_RoundsToWin)=(GameSettingContext=CONTEXT_ROUNDSTOWIN,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_RoundTime)=(GameSettingContext=CONTEXT_ROUNDTIME,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_NumBots)=(GameSettingContext=CONTEXT_NUMBOTS,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_BotDiff)=(GameSettingContext=CONTEXT_BOTDIFFICULTY,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_Bleedout)=(GameSettingContext=CONTEXT_BLEEDOUTTIME,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_FriendlyFire)=(GameSettingContext=CONTEXT_FRIENDLYFIRE,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_MapSelection)=(GameSettingContext=`MAP_SELECTION_MODE,CurrValue=-1,bIsIDMapped=true)
	VersusMappings(eGEARVERSUSSETTING_WeaponSwap)=(GameSettingContext=CONTEXT_WEAPONSWAP,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_SiegeEnemyDiff)=(GameSettingContext=CONTEXT_SIEGE_ENEMYDIFFICULTY,CurrValue=-1)
	VersusMappings(eGEARVERSUSSETTING_SiegeWave)=(GameSettingContext=CONTEXT_SIEGE_WAVE,CurrValue=-1,bIsIDMapped=true)

	CustomGameSettings(eGEARMP_Warzone)={(SettingID=(CONTEXT_ROUNDSTOWIN,
													CONTEXT_ROUNDTIME,
													CONTEXT_NUMBOTS,
													CONTEXT_BOTDIFFICULTY,
													CONTEXT_BLEEDOUTTIME,
													CONTEXT_FRIENDLYFIRE,
													`MAP_SELECTION_MODE,
													/*CONTEXT_WEAPONSWAP,*/))}
	CustomGameSettings(eGEARMP_Execution)={(SettingID=(CONTEXT_ROUNDSTOWIN,
														CONTEXT_ROUNDTIME,
														CONTEXT_NUMBOTS,
														CONTEXT_BOTDIFFICULTY,
														CONTEXT_BLEEDOUTTIME,
														CONTEXT_FRIENDLYFIRE,
														`MAP_SELECTION_MODE,
														/*CONTEXT_WEAPONSWAP,*/))}
	CustomGameSettings(eGEARMP_Horde)={(SettingID=(CONTEXT_ENEMYDIFFICULTY,
													CONTEXT_HORDE_WAVE,
													`MAP_SELECTION_MODE,))}
	CustomGameSettings(eGEARMP_Wingman)={(SettingID=(CONTEXT_WINGMAN_SCOREGOAL,
													CONTEXT_ROUNDTIME,
													CONTEXT_NUMBOTS,
													CONTEXT_BOTDIFFICULTY,
													CONTEXT_BLEEDOUTTIME,
													CONTEXT_FRIENDLYFIRE,
													`MAP_SELECTION_MODE,
													/*CONTEXT_WEAPONSWAP,*/))}
	CustomGameSettings(eGEARMP_KOTH)={(SettingID=(CONTEXT_ROUNDSCORE_KOTH,
												CONTEXT_ROUNDSTOWIN,
												CONTEXT_NUMBOTS,
												CONTEXT_BOTDIFFICULTY,
												CONTEXT_BLEEDOUTTIME,
												CONTEXT_FRIENDLYFIRE,
												`MAP_SELECTION_MODE,
												/*CONTEXT_WEAPONSWAP,*/))}
	CustomGameSettings(eGEARMP_CTL)={(SettingID=(CONTEXT_ROUNDSTOWIN,
												CONTEXT_NUMBOTS,
												CONTEXT_BOTDIFFICULTY,
												CONTEXT_BLEEDOUTTIME,
												CONTEXT_FRIENDLYFIRE,
												`MAP_SELECTION_MODE,
												/*CONTEXT_WEAPONSWAP,*/))}
	CustomGameSettings(eGEARMP_Newbie)={(SettingID=(CONTEXT_ROUNDSCORE_NEWB,
													CONTEXT_ROUNDSTOWIN,
													CONTEXT_NUMBOTS,
													CONTEXT_BOTDIFFICULTY,
													CONTEXT_BLEEDOUTTIME,
													CONTEXT_FRIENDLYFIRE,
													`MAP_SELECTION_MODE,
													/*CONTEXT_WEAPONSWAP,*/))}
	CustomGameSettings(eGEARMP_Siege)={(SettingID=(CONTEXT_SIEGE_ENEMYDIFFICULTY,
												   CONTEXT_SIEGE_WAVE,
												   `MAP_SELECTION_MODE,))}
}
