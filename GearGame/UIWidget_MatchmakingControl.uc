/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MatchmakingControl.uc
 * 
 * Supporting class for the displaying the matchmaking panel
 */
class UIWidget_MatchmakingControl extends GFxObject;


//==============================================================
// Structs, enums, consts, etc.
//==============================================================

/** Enum of the different matchmaking modes that this panel will handle */
enum EGearMatchmakingType
{
	eGMT_None,
	eGMT_RankedVersus,
	eGMT_SocialVersus,
	eGMT_PublicCampaign,
};

/** Enum of all the matchmaking phases */
enum EGearMatchmakingPhase
{
	eGMP_None,
	eGMP_Cancel,
	eGMP_CancelClient,
	eGMP_ReadingSkills,
	eGMP_FindingPlayers,
	eGMP_ConnectOpposingParty,
	eGMP_Finished,
};

/** Enum of the state of a phase */
enum EGearPhaseState
{
	eGPS_None,
	eGPS_Pending,
	eGPS_Active,
	eGPS_Finished,
};

/** Structure that maps matchmaking phases to the matchmaking states they care about */
struct GearMatchmakingPhaseMap
{
	/** List of matchmaking states this phase cares about */
	var array<EMatchmakingState> MatchmakingStates;
};

/** Struct to maintain the state of each phase of matchmaking */
struct GearMatchMakingPhaseData
{
	/** The phase identifier */
	var EGearMatchmakingPhase PhaseType;

	/** The phase title */
	var String PhaseTitleString;

	/** The phase description */
	var String PhaseDescString;

	/** The phase description after it's been altered by filling in things like `NUMPLAYERS` */
	var String AlteredPhaseDescString;

	/** The current state of the phase */
	var EGearPhaseState PhaseState;
};

/** List of mappings from phases to GRI states */
var array<GearMatchmakingPhaseMap> PhaseToStateMap;

/** List of phases Ranked matches will use when matchmaking */
var const array<EGearMatchmakingPhase> RankedPhases;

/** List of phases Social matches will use when matchmaking */
var const array<EGearMatchmakingPhase> SocialPhases;

/** List of phases Social Campaign matches will use when matchmaking */
var const array<EGearMatchmakingPhase> CampaignPhases;

//==============================================================
// Widget handles
//==============================================================

/** The button bar label to draw the button string */
var transient GFxObject ButtonBarLabel;

/** The description text the describes the currently selected matchmaking phase */
var transient GFxObject PhaseDescription;

/** The bag that contains the PhaseDescriptoin object */
var transient GFxObject PhaseDescriptionBag;

/** The current phase description string being displayed */
var transient String CurrDescriptionString;

/** The phase description string being displayed prior to getting things like 'NUMPLAYERS' filled in */
var transient String UnalteredDescriptionString;

/** The list of matchmaking phases that will be displayed while matchmaking */
var transient GFxObject PhaseDisplayList;

/** The label that displays the title of this panel "MATCHMAKING" */
var transient GFxObject TitleLabel;

/** The label that display the sub title of this panel "SOCIAL - WARZONE" */
var transient GFxObject SubtitleLabel;

//==============================================================
// Localization
//==============================================================

/** The canceling button bar string */
var localized String ButtonBarString;

/** The main title of this panel */
var localized String MatchmakingString;

/** Phase titles and descriptions */
var localized String PhaseCancelTitle;
var localized String PhaseCancelDescLocal;
var localized String PhaseCancelDescRemote;
var localized String PhaseReadSkillsTitle;
var localized String PhaseReadSkillsDesc;
var localized String PhaseFindPlayersTitle;
var localized String PhaseFindPlayersDescBest;
var localized String PhaseFindPlayersDescAny;
var localized String PhaseFindOpponentTitle;
var localized String PhaseFindOpponentDesc;
var localized String PhaseFinishTitle;
var localized String PhaseFinishDesc;

//==============================================================
// Member Variables
//==============================================================

/** Whether the panel is currently active or not */
var transient bool bPanelIsActive;

/** The type of matchmaking panel this is */
var transient EGearMatchmakingType MatchmakingType;

/** The current phase of matchmaking we are in */
var transient EGearMatchmakingPhase CurrPhase;

/** The current phase list we are using for the panel */
var transient array<EGearMatchmakingPhase> CurrPhaseTypeList;

/** Cache of the last matchmaking state we've handled */
var transient EMatchmakingState CurrMatchMakingState;

/** Cached GRI */
var transient GearPartyGRI PartyGRI;

/** Reference back to the front end */
var transient UIScene_FrontEnd FrontEndMovie;

/** List of phases for this panel and the data that drives them */
var transient array<GearMatchMakingPhaseData> PhaseList;


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
	switch (WidgetName)
	{
		case 'mc_CurrentTitle':
			TitleLabel = Widget;
			break;
		case 'mc_LastTitle':
			SubtitleLabel = Widget;
			break;
		case 'ControllerMap':
			ButtonBarLabel = Widget;
			break;
		case 'MatchmakingInfo':
			PhaseDescription = Widget;
			break;
		case 'mc_MatchmakingInfo':
			PhaseDescriptionBag = Widget;
			break;
		case 'MatchmakingList':
			PhaseDisplayList = Widget;
			break;
		default:
			`log("Unhandled widget in UIWidget_MatchmakingControl: " @ WidgetPath,, 'GearsUI');
			return false;
	}

	return true;
}

/** Initializes the matchmaking panel */
function Initialize(UIScene_FrontEnd FEMovie)
{
	FrontEndMovie = FEMovie;
}

/** 
 * Overridden so we can eat input we don't want the front end to get
 *
 * @param   ControllerId    The Id of the controller that the input came from
 * @param   ButtonName      The name of the button that was hit
 * @param   InputEvent      What type of input event was this (e.g. pressed, released)
 * 
 * @return  TRUE if the input should be trapped and not passed on, FALSE to pass it on to GFx for handling
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	// Trap the b button
	if (ButtonName == 'XboxTypeS_B')
	{
		if (InputEvent == IE_Pressed &&
			LocalPlayerOwnerIndex == ControllerId &&
			(CurrPhase != eGMP_Cancel && CurrPhase != eGMP_CancelClient))
		{
			// Cancel the matchmaking process
			CancelMatchmaking();
		}
		return true;
	}
	// Eat any input that isn't X, Y or START
	else if (ButtonName != 'XboxTypeS_X' &&
			 ButtonName != 'XboxTypeS_Y' &&
			 ButtonName != 'XboxTypeS_Start')
	{
		return true;
	}

	return false;
}

/** Opens this panel in the front end */
function OpenMatchmakingPanel()
{
	bPanelIsActive = true;

	// Reset the phase
	CurrPhase = eGMP_None;
	// Sets the type of panel this will be
	SetMatchmakingType();
	// Set the title of the panel
	SetMatchmakingTitle();
	// Update the button bar text
	UpdateButtonBar();
	// Build the list of phases we will be using
	BuildPhaseList();
	// Open the panel
	GotoAndPlay("open");
	// Set the current phase and get the party started
	RefreshCurrentPhase();
	// Tell the front end that we are opening the matchmaking panel
	if (FrontEndMovie != None)
	{
		FrontEndMovie.MatchMakingPanelOpenedNotify();
	}
}

/** Closes this panel in the front end */
function CloseMatchmakingPanel()
{
	// Close the panel
	GotoAndPlay("close");

	CurrMatchMakingState = MMS_NotMatchmaking;
	bPanelIsActive = false;

	// Tell the front end that we are closing the matchmaking panel
	if (FrontEndMovie != None)
	{
		FrontEndMovie.MatchMakingPanelClosedNotify();
	}
}

/** Called when the matchmaking state in the GRI changes */
function OnMatchMakingStateChanged()
{
	// Early out if we are not currently configuring a game mode that is matchmaking
	if (FrontEndMovie == None ||
		(!FrontEndMovie.IsOfficialMatch() && !FrontEndMovie.IsPlayerMatch()))
	{
		return;
	}

	// Cache the GRI
	PartyGRI = GearPartyGRI(FrontEndMovie.GetGRI());

	if (PartyGRI != None &&
		CurrMatchMakingState != PartyGRI.MatchmakingState)
	{
		switch (PartyGRI.MatchmakingState)
		{
			// Need to close the panel
			case MMS_NotMatchmaking:
				CloseMatchmakingPanel();
				break;
			// Rebuild the panel so we can display canceling
			case MMS_CancelingMatchmaking:
			case MMS_HostCancelingMatchmaking:
				RebuildPanelForCancel();
				break;
			default:
				// Need to open the panel
				if (CurrMatchMakingState == MMS_NotMatchmaking)
				{
					OpenMatchmakingPanel();
				}
				// State changed so we need to refresh the selected phase
				else
				{
					RefreshCurrentPhase();
				}
				break;
		}

		CurrMatchMakingState = PartyGRI.MatchmakingState;
	}
}

/** Cancels matchmaking and rebuilds the screen to reflect it */
function CancelMatchmaking()
{
	// Tell game to cancel matchmaking
	FrontEndMovie.LaunchPlaylistMatch();
}

/** Matchmaking was canceled so we need to reflect it in the panel */
function RebuildPanelForCancel()
{
	// Prepare list for cancel
	BuildCancelPhaseList();
	// Set the current phase and get the party started
	RefreshCurrentPhase();
	// Update the button bar text
	UpdateButtonBar();
	// Tell the party panel to rebuild
	if (FrontEndMovie != None &&
		FrontEndMovie.SmallPartyPanel != None)
	{
		FrontEndMovie.SmallPartyPanel.bRebuildPartyPanel = true;
	}
}

/** Sets the matchmaking type and sets up any additional variables and functionality needed by that type */
function SetMatchmakingType()
{
	local byte CurrentScreen;
	local int CurrentSelection;

	// Set the type and the phase list that that type should be using
	if (FrontEndMovie.GetCurrentScreenAndSelection(CurrentScreen,CurrentSelection))
	{
		switch (CurrentScreen)
		{
			case MAINMENUOP_VS_Playlist1:
			case MAINMENUOP_VS_Playlist2:
			case MAINMENUOP_VS_Playlist3:
			case MAINMENUOP_VS_Playlist4:
			case MAINMENUOP_VS_Playlist5:
			case MAINMENUOP_VS_Playlist6:
			case MAINMENUOP_VS_Playlist7:
			case MAINMENUOP_VS_Playlist8:
				if (CurrentSelection == 0)
				{
					MatchmakingType = eGMT_SocialVersus;
					CurrPhaseTypeList = SocialPhases;
				}
				else if (CurrentSelection == 1)
				{
					MatchmakingType = eGMT_RankedVersus;
					CurrPhaseTypeList = RankedPhases;
				}
				break;
			case MAINMENUOP_Horde:
			case MAINMENUOP_Siege:
				MatchmakingType = eGMT_SocialVersus;
				CurrPhaseTypeList = SocialPhases;
				break;
			//If you're not vs or horde or siege, you're campaign!
			default:
				MatchmakingType = eGMT_PublicCampaign;
				CurrPhaseTypeList = CampaignPhases;
				return;
		}
	}
}

/** Sets the title of the matchmaking panel */
function SetMatchmakingTitle()
{
	local String SubTitle;
	local UIDataStore_OnlinePlaylists PlaylistDS;
	local array<UIResourceDataProvider> ProviderList;
	local OnlinePlaylistProvider PlaylistProv;
	local int ProvIdx;
	local String PlaylistName;
	local Name ProviderTag;

	// Find the correct provider based on the playlist id and get the display name
	if (MatchmakingType != eGMT_PublicCampaign)
	{
		PlaylistDS = UIDataStore_OnlinePlaylists(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlinePlaylists'.default.Tag));
		// Determine the correct provider tag
		if (MatchmakingType == eGMT_SocialVersus)
		{
			ProviderTag = name(class'UIDataStore_OnlinePlaylists'.const.UNRANKEDPROVIDERTAG);
		}
		else
		{
			ProviderTag = name(class'UIDataStore_OnlinePlaylists'.const.RANKEDPROVIDERTAG);
		}
		// Get the provider list
		PlaylistDS.GetResourceProviders(ProviderTag, ProviderList);
		// Find the name by matching up the playlist id
		for (ProvIdx = 0; ProvIdx < ProviderList.Length; ProvIdx++)
		{
			PlaylistProv = OnlinePlaylistProvider(ProviderList[ProvIdx]);
			if (PlaylistProv != None &&
				PlaylistProv.PlaylistId == PartyGRI.PlaylistId)
			{
				PlaylistName = PlaylistProv.DisplayName;
				break;
			}
		}
	}

	// First build the subtitle
	switch (MatchmakingType)
	{
		case eGMT_SocialVersus:
			SubTitle = "<font color='#e51300'>" $ Caps(Localize("MainMenu", "Social", "GearGameUI") $ " - " $ PlaylistName) $ "</font>";
			break;
		case eGMT_RankedVersus:
			SubTitle = "<font color='#e51300'>" $ Caps(Localize("MainMenu", "Ranked", "GearGameUI") $ " - " $ PlaylistName) $ "</font>";
			break;
		case eGMT_PublicCampaign:
			SubTitle = Caps(Localize("MainMenu", "Social", "GearGameUI") $ " - " $ Localize("MainMenu", "Campaign", "GearGameUI"));
			break;
	}
	
	// Set the labels
	// These are from the old matchmaking screen, so they may not exist anymore
	if (TitleLabel != none)
	{
		TitleLabel.GetObject("lbl_Title").SetString("htmlText", MatchmakingString);
	}
	if (SubtitleLabel != none)
	{
 		SubtitleLabel.GetObject("lbl_Title").SetString("htmlText", SubTitle);
	}
}

/** Updates the button bar string */
function UpdateButtonBar()
{
	local String BBString;
	if (ButtonBarLabel != None)
	{
		if (CurrPhase == eGMP_Cancel ||
			CurrPhase == eGMP_CancelClient)
		{
			BBString = " ";
		}
		else
		{
			BBString = ButtonBarString;
		}

		ButtonBarLabel.GetObject("textField").SetString("htmlText", BBString);
	}
}

/** Update the string that displays the description of the current matchmaking phase */
function UpdatePhaseDescription()
{
	local int PhaseIdx;

	PhaseIdx = PhaseList.Find('PhaseType', CurrPhase);
	if (PhaseIdx != INDEX_NONE)
	{
		// Get the string to display
		PhaseList[PhaseIdx].AlteredPhaseDescString = GetAlteredString(PhaseIdx);

		// Only update if the string is different
		if (CurrDescriptionString != PhaseList[PhaseIdx].AlteredPhaseDescString)
		{
			CurrDescriptionString = PhaseList[PhaseIdx].AlteredPhaseDescString;
			PhaseDescription.GetObject("textField").SetString("htmlText", CurrDescriptionString);

			// See if we need to fade in the string (context change)
			if (UnalteredDescriptionString != PhaseList[PhaseIdx].PhaseDescString)
			{
				UnalteredDescriptionString = PhaseList[PhaseIdx].PhaseDescString;
				PhaseDescriptionBag.GotoAndPlay("on");
			}
		}
	}
}

/** Figures out what the display string is based on the phase and what's happening with matchmaking at this time */
function String GetAlteredString(int PhaseIdx)
{
	local String ReturnString;
	local int NumPRIs;

	ReturnString = PhaseList[PhaseIdx].PhaseDescString;

	// Finding players is dynamic
	if (PhaseList[PhaseIdx].PhaseType == eGMP_FindingPlayers)
	{
		// Get number of PRIs for string replacement
		NumPRIs = FrontEndMovie.GetNumValidPRIs();

		// Alter the "find any" string
		if (PartyGRI.MatchmakingState == MMS_FindingAnyParty ||
			PartyGRI.MatchmakingState == MMS_FindingAnyDedicated)
		{
			ReturnString = PhaseFindPlayersDescBest;
			ReturnString = Repl(ReturnString, "\`NUMPLAYERS\`", string(NumPRIs));
		}
		// Alter the "find best" string
		else
		{
			ReturnString = PhaseFindPlayersDescAny;
			ReturnString = Repl(ReturnString, "\`NUMPLAYERS\`", string(NumPRIs + PartyGRI.PartySlotsFilled));
		}
	}

	return ReturnString;
}

/** Handles the initial building of the matchmaking phase list */
function BuildPhaseList()
{
	local int PhaseIdx;
	local GearMatchMakingPhaseData PhaseData;
	local GFxObject DataProvider;
	local GFxObject DataObject;

	// Wipe the list
	PhaseList.Length = 0;

	// Build the phase list
	for (PhaseIdx = 0; PhaseIdx < CurrPhaseTypeList.Length; PhaseIdx++)
	{
		PhaseData.PhaseType = CurrPhaseTypeList[PhaseIdx];
		PhaseData.PhaseState = eGPS_Pending;
		GetPhaseStrings(MatchmakingType, PhaseData.PhaseType, PhaseData.PhaseTitleString, PhaseData.PhaseDescString);
		PhaseList.AddItem(PhaseData);
	}

	// Build the dataprovider
	DataProvider = CreateArray();
	for (PhaseIdx = 0; PhaseIdx < PhaseList.Length; PhaseIdx++)
	{
		DataObject = CreateObject("Object");
		DataObject.SetString("state", "normal");
		DataObject.SetString("listNumber", String(PhaseIdx + 1));
		DataObject.SetString("phaseTitle", PhaseList[PhaseIdx].PhaseTitleString);
		DataProvider.SetElementObject(PhaseIdx, DataObject);
		SetDataProviderAndRefresh(DataProvider);
	}
}

/** Handles the building of the cancel version of our phase list */
function BuildCancelPhaseList()
{
	local GearMatchMakingPhaseData PhaseData;
	local GFxObject DataProvider;
	local GFxObject DataObject;
	local int PhaseIdx;

	// Wipe the list
	PhaseList.Length = 0;

	// Build the phase list
	PhaseData.PhaseType = GetCurrentMatchmakingPhase();
	PhaseData.PhaseState = eGPS_Pending;
	GetPhaseStrings(MatchmakingType, PhaseData.PhaseType, PhaseData.PhaseTitleString, PhaseData.PhaseDescString);
	PhaseList.AddItem(PhaseData);

	// Build the dataprovider
	DataProvider = CreateArray();
	for (PhaseIdx = 0; PhaseIdx < PhaseList.Length; PhaseIdx++)
	{
		DataObject = CreateObject("Object");
		DataObject.SetString("state", "normal");
		DataObject.SetString("listNumber", String(PhaseIdx + 1));
		DataObject.SetString("phaseTitle", PhaseList[PhaseIdx].PhaseTitleString);
		DataProvider.SetElementObject(PhaseIdx, DataObject);
		SetDataProviderAndRefresh(DataProvider);
	}
}

/** Function which will return what the current phase should be based on the matchmaking state in the GRI */
function EGearMatchmakingPhase GetCurrentMatchmakingPhase()
{
	local int PhaseIdx;
	local int MapIdx;

	for (PhaseIdx = 0; PhaseIdx < eGMP_MAX; PhaseIdx++)
	{
		for (MapIdx = 0; MapIdx < PhaseToStateMap[PhaseIdx].MatchmakingStates.Length; MapIdx++)
		{
			if (PhaseToStateMap[PhaseIdx].MatchmakingStates[MapIdx] == PartyGRI.MatchmakingState)
			{
				return EGearMatchmakingPhase(PhaseIdx);
			}
		}
	}

	return eGMP_None;
}

/** Determines if we need to switch phases since the matchmode state changed in the GRI */
function RefreshCurrentPhase()
{
	local int PhaseIdx;
	local int CurrPhaseIdx;
	local EGearMatchmakingPhase NewPhase;

	// See which phase cares about the current GRI state
	NewPhase = GetCurrentMatchmakingPhase();

	// If the phase has changed and is valid
	if (CurrPhase != NewPhase)
	{
		// Set the new phase
		CurrPhase = NewPhase;
		// Determine the index of the phase we are going to
		CurrPhaseIdx = PhaseList.Find('PhaseType', CurrPhase);

		// Update the phases
		if (CurrPhaseIdx != INDEX_NONE)
		{
			for (PhaseIdx = 0; PhaseIdx < PhaseList.Length; PhaseIdx++)
			{
				// Make sure all phases before this one are in the finished state
				if (PhaseIdx < CurrPhaseIdx)
				{
					SetPhaseToFinished(PhaseIdx);
				}
				// Make this phase be in the active state
				else if (PhaseIdx == CurrPhaseIdx)
				{
					SetPhaseToActive(PhaseIdx);
				}
				// Make sure all future states are in the pending state
				else
				{
					SetPhaseToPending(PhaseIdx);
				}
			}
		}
	}
}

/** Set the phase to be in the finished state (check box) */
function SetPhaseToFinished(int PhaseIdx)
{
	if (PhaseList[PhaseIdx].PhaseState != eGPS_Finished)
	{
		PhaseList[PhaseIdx].PhaseState = eGPS_Finished;
		ActionScript_SetMatchmakingState(PhaseIdx, "check");
	}
}

/** Set the phase to be in the active state (cog spin) */
function SetPhaseToActive(int PhaseIdx)
{
	if (PhaseList[PhaseIdx].PhaseState != eGPS_Active)
	{
		PhaseList[PhaseIdx].PhaseState = eGPS_Active;
		ActionScript_SetMatchmakingState(PhaseIdx, "load");
	}
}

/** Set the pahse to be in the pending state */
function SetPhaseToPending(int PhaseIdx)
{
	if (PhaseList[PhaseIdx].PhaseState != eGPS_Pending)
	{
		PhaseList[PhaseIdx].PhaseState = eGPS_Pending;
		ActionScript_SetMatchmakingState(PhaseIdx, "normal");
	}
}

/** Updates the matchmaking panel every tick */
function UpdateMatchmakingPanel()
{
	// Update the phase description
	UpdatePhaseDescription();
}

/**
 * Function that determines and returns the title and descriptions strings for a given phase given the matchmode and phasetype
 *
 * @param MatchType - The context of this matchmaking (social, ranked, campaign)
 * @param PhaseType - The phase this data is supposed to describe
 * @outparam PhaseTitle - The string to display as the title of this phase
 * @outparam PhaseDesc - The string to display as the descriptoin of this phase when it is active
 */
function GetPhaseStrings(EGearMatchmakingType MatchType, EGearMatchmakingPhase PhaseType, out String PhaseTitle, out String PhaseDesc)
{
	switch (MatchType)
	{
		// Ranked matches
		case eGMT_RankedVersus:
			switch (PhaseType)
			{
				case eGMP_Cancel:
					PhaseTitle = PhaseCancelTitle;
					PhaseDesc = PhaseCancelDescLocal;
					break;
				case eGMP_CancelClient:
					PhaseTitle = PhaseCancelTitle;
					PhaseDesc = PhaseCancelDescRemote;
					break;
				case eGMP_ReadingSkills:
					PhaseTitle = PhaseReadSkillsTitle;
					PhaseDesc = PhaseReadSkillsDesc;
					break;
				case eGMP_FindingPlayers:
					PhaseTitle = PhaseFindPlayersTitle;
					PhaseDesc = PhaseFindPlayersDescBest;
					break;
				case eGMP_ConnectOpposingParty:
					PhaseTitle = PhaseFindOpponentTitle;
					PhaseDesc = PhaseFindOpponentDesc;
					break;
				case eGMP_Finished:
					PhaseTitle = PhaseFinishTitle;
					PhaseDesc = PhaseFinishDesc;
					break;
			}
			break;
		// Social matches
		case eGMT_SocialVersus:
			switch (PhaseType)
			{
				case eGMP_Cancel:
					PhaseTitle = PhaseCancelTitle;
					PhaseDesc = PhaseCancelDescLocal;
					break;
				case eGMP_CancelClient:
					PhaseTitle = PhaseCancelTitle;
					PhaseDesc = PhaseCancelDescRemote;
					break;
				case eGMP_ReadingSkills:
					PhaseTitle = PhaseReadSkillsTitle;
					PhaseDesc = PhaseReadSkillsDesc;
					break;
				case eGMP_FindingPlayers:
					PhaseTitle = PhaseFindPlayersTitle;
					PhaseDesc = PhaseFindPlayersDescBest;
					break;
				case eGMP_Finished:
					PhaseTitle = PhaseFinishTitle;
					PhaseDesc = PhaseFinishDesc;
					break;
			}
			break;
		// Social campaign game
		case eGMT_PublicCampaign:
			switch (PhaseType)
			{
				case eGMP_Cancel:
					PhaseTitle = PhaseCancelTitle;
					PhaseDesc = PhaseCancelDescLocal;
					break;
				case eGMP_CancelClient:
					PhaseTitle = PhaseCancelTitle;
					PhaseDesc = PhaseCancelDescRemote;
					break;
				case eGMP_ReadingSkills:
					PhaseTitle = PhaseReadSkillsTitle;
					PhaseDesc = PhaseReadSkillsDesc;
					break;
				case eGMP_FindingPlayers:
					PhaseTitle = PhaseFindPlayersTitle;
					PhaseDesc = PhaseFindPlayersDescBest;
					break;
				case eGMP_Finished:
					PhaseTitle = PhaseFinishTitle;
					PhaseDesc = PhaseFinishDesc;
					break;
			}
			break;
	}
}

/** Set the data provider and tells it to refresh */
function SetDataProviderAndRefresh(GFxObject DataProv)
{
	PhaseDisplayList.ActionScriptVoid("SetDataProviderAndRefresh");
}

/** Stub for calling the ActionScript function to set the title string of a phase */
private function ActionScript_SetPhaseTitleText(int ListIdx, String NewTitle)
{
	PhaseDisplayList.ActionScriptVoid("SetPhaseTitleText");
}

/** Stub for calling the ActionScript function to set the state of a phase */
private function ActionScript_SetMatchmakingState(int ListIdx, String NewState)
{
	PhaseDisplayList.ActionScriptVoid("SetMatchmakingState");
}

defaultproperties
{
	CurrMatchMakingState=MMS_NotMatchmaking

	RankedPhases(0)=eGMP_ReadingSkills
	RankedPhases(1)=eGMP_FindingPlayers
// 	RankedPhases(2)=eGMP_ConnectOpposingParty
	RankedPhases(2)=eGMP_Finished

	SocialPhases(0)=eGMP_ReadingSkills
	SocialPhases(1)=eGMP_FindingPlayers
	SocialPhases(2)=eGMP_Finished

	CampaignPhases(0)=eGMP_ReadingSkills
	CampaignPhases(1)=eGMP_FindingPlayers
	CampaignPhases(2)=eGMP_Finished

	PhaseToStateMap(eGMP_Cancel)=(MatchmakingStates=(MMS_HostCancelingMatchmaking))
	PhaseToStateMap(eGMP_CancelClient)=(MatchmakingStates=(MMS_CancelingMatchmaking))
	PhaseToStateMap(eGMP_ReadingSkills)=(MatchmakingStates=(MMS_ReadingSkills))
	PhaseToStateMap(eGMP_FindingPlayers)=(MatchmakingStates=(MMS_FindingBestDedicated,MMS_FindingAnyDedicated,MMS_FindingEmptyDedicated,MMS_FindingBestParty,MMS_FindingAnyParty))
// 	PhaseToStateMap(eGMP_ConnectOpposingParty)=(MatchmakingStates=(MMS_ConnectingToOpposingParty))
	PhaseToStateMap(eGMP_Finished)=(MatchmakingStates=(MMS_ConnectingToOpposingParty))
}
