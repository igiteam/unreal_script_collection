/**
 * Base class for all PlayerController classes used by the menus to enable special functionality.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMenuPC extends GearPC;

/** Flag that lets us know that we have signed into the profile with a unique net id and are ready to start sessions */
var bool bSignedIn;

/** Keeps track of how many achievement reads are in flight */
var transient int AchievementReadCount;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if( GearGame(WorldInfo.Game) != None && GearGame(WorldInfo.Game).bDoLocScreenShotTest == TRUE )
	{
		SetTimer( 30.0f, FALSE, nameof(Automation_PressStart) );
	}
}

simulated function Automation_PressStart()
{
	Sentinel_PressStartKeyAtStartMenu();

	SetTimer( 2.0f, FALSE, nameof(Sentinel_DoBugitWithLang) );
}

reliable client event ClientSetViewTarget( Actor A, optional ViewTargetTransitionParams TransitionParams )
{
	//@fixme - mini hack, ignore viewtarget changes for menu pc's since we do it locally
	if (CameraActor(ViewTarget) == None)
	{
		Super.ClientSetViewTarget(A,TransitionParams);
	}
}

function SetViewTarget( Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams  )
{
	//@fixme - mini hack, ignore viewtarget changes for menu pc's since we do it locally
	if (CameraActor(ViewTarget) == None)
	{
		Super.SetViewTarget(NewViewTarget,TransitionParams);
	}
}

reliable client function ClientPartyLobbyClosed()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local UIScene_MessageBox InstancedScene;

	ButtonAliases.AddItem('GenericAccept');

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('PartyLobbyClosed', 
		Localize("MessageBoxStrings","PartyDisbanded_Title","GearGameUI"),
		Localize("MessageBoxStrings","PartyDisbanded_Message","GearGameUI"),
		ButtonAliases, None, LocalPlayer(Player), InstancedScene);

	//InstancedScene.bCloseOnLevelChange = false;
	//InstancedScene.bExemptFromAutoClose = true;
	InstancedScene.SetPriority(class'GearGFxMoviePlayer'.const.GEAR_SCENE_PRIORITY_MESSAGEBOX+1);
	ReturnToMainMenu(false);
}

/**
 * Sets the rich presence to the default value (in the menu)
 */
reliable client function ClientSetOnlineStatus()
{
	SetRichPresenceString(class'GearGame'.const.CONTEXT_PRESENCE_MENUPRESENCE);
}

/* === GearPC interface === */

/** @return whether we want the spectator UI scene to be displayed */
function bool WantsSpectatorUI()
{
	// never show the spectator UI in the front end.
	return false;
}

/** Requests a team change from the server */
unreliable server function ServerRequestChangeTeam( int NumPlayers )
{
	local GearPreGameGRI PreGameGRI;
	local GearPreGameLobbyPRI PreGamePRI;

	PreGameGRI = GearPreGameGRI(WorldInfo.GRI);
	PreGamePRI = GearPreGameLobbyPRI(PlayerReplicationInfo);
	if ( PreGameGRI != None && PreGamePRI != None )
	{
		PreGameGRI.RequestChangeTeam( PreGamePRI, NumPlayers );
	}
}

/** Restarts the main menu */
function RestartFrontEnd()
{
	local GearMenuHUD GMH;
	local OnlineGameSettings PartySettings;
	local GearLocalPlayer LP;

	if (bIsReturningToMainMenu)
	{
		// If we're already in the process of returning to the main menu then prevent cleanup that occurs here
		// And force menu history to be cleared so we end up back at the start screen
		LP = GearLocalPlayer(Player);
		if (LP != None)
		{
			LP.bIsFirstFrontEndLoad = true;
			return;
		}
	}

	GMH = GearMenuHUD(myHUD);
	if (GMH != None)
	{
		// Only destroy party if we have one and we are in the front end (not pre-game lobby - PGL handles this differently)
		if (GMH.FrontEndMovie != None &&
			OnlineSub != None &&
			OnlineSub.GameInterface != None)
		{
			PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
			if (PartySettings != None)
			{
				// This also brings up the block input UI (COG spin)
				GMH.FrontEndMovie.DestroyParty();
			}
		}

		GMH.RestartFrontEnd();
	}
}

/**
 * Downloads the playlist if needed upon a signin change
 *
 * @param LocalUserNum the user that just logged in
 */
function OnLoginChange(byte LocalUserNum)
{
	local GearMenuGame MenuGame;
	local LocalPlayer LP;
	local GearMenuHUD GMH;

	LP = LocalPlayer(Player);
	if (LP != None &&
		LP.ControllerId == LocalUserNum)
	{
		// Only needs to be refreshed if someone signs in
		if (OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum) == LS_LoggedIn)
		{
			// Make sure the playlist is up to date on signin change
			MenuGame = GearMenuGame(WorldInfo.Game);
			if (MenuGame != None &&
				GearPreGameLobbyGame_Base(MenuGame) == None)
			{
				MenuGame.DownloadPlaylists(false);
				CheckForAchievementUnlocks();
			}
		}

		Super.OnLoginChange(LocalUserNum);

		// Must happen after the super call so that the uniqueId has a chance to get set before the Advance call below
		GMH = GearMenuHUD(myHUD);
		if (GMH != None)
		{
			if (!IsOnTitleScreen())
			{
				RestartFrontEnd();
			}
			else
			{
				//if we are on the title screen, try to advance. Will not advance if no one pressed start
				if (GMH.FrontEndMovie != None)
				{
					GMH.FrontEndMovie.AdvanceFromStartScreen();
				}
			}
		}
	}
}

/**
 * If we are in the front end, don't do anything. Otherwise, do normal processing
 */
function OnNewLogin()
{
	if (GearPreGameLobbyGame_Base(WorldInfo.Game) != None ||
		// Clients cannot login in the main menu since that needs to be done in their party before joining
		WorldInfo.NetMode == NM_Client)
	{
		Super.OnNewLogin();
	}
}

/**
 * Delegate called when a player's status changes but doesn't change profiles
 *
 * @param NewStatus the new login status for the user
 * @param NewId the new id to associate with the user
 */
function OnLoginStatusChange(ELoginStatus NewStatus,UniqueNetId NewId)
{
	Super.OnLoginStatusChange(NewStatus, NewId);

	// Set that we've signed in or not
	bSignedIn = NewStatus != LS_NotLoggedIn;

	// If we signed out, restart the UI
	if (NewStatus == LS_NotLoggedIn)
	{
		// Clients must go back to their party to start over
		if (WorldInfo.NetMode == NM_Client)
		{
			ShowLoginChangeError();
			ReturnToMainMenu(true);
		}
		else if (!IsOnTitleScreen())
		{
			RestartFrontEnd();
		}
	}
}

/**
 * Callback for when a player cancels their login
 */
function OnLoginCancelled()
{
	local GearMenuHUD GMH;

	super.OnLoginCancelled();

	GMH = GearMenuHUD(myHUD);
	if (GMH != None && GMH.FrontEndMovie != None)
	{
		GMH.FrontEndMovie.AdvanceFromStartScreen();
	}
}

/**
 * Overridden to handle recomputing mutators unlocked.
 */
event Destroyed()
{
	local GearPartyGRI PartyGRI;

	Super.Destroyed();

	PartyGRI = GearPartyGRI(WorldInfo.GRI);
	if (PartyGRI != None)
	{
		PartyGRI.RecomputeMutatorsUnlocked();
	}
}

/**
 * Function called by the server to inform clients of a change in the main menu scene's active screen
 * @param NewHistoryArray - the history of choices made in the main menu by the host
 * @param CurrentSelection - the currently selected host item
 */
reliable client function ClientMainMenuSceneChange(MMHistoryItem NewHistoryArray[`MAX_HISTORY_LENGTH], byte HistoryLength, byte CurrentSelection)
{
	local GearUIManager UIManager;
	local GearMenuHUD MenuHUD;
	local int i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != none)
	{
		for(i = 0; i < HistoryLength; i++)
		{
			UIManager.MainMenuHistory[i].Screen = NewHistoryArray[i].Screen;
			UIManager.MainMenuHistory[i].SelectedOption = NewHistoryArray[i].SelectedOption;
		}
		UIManager.MainMenuHistoryLength = HistoryLength;
		UIManager.LastSelectedIndex = CurrentSelection;
	}

	MenuHUD = GearMenuHUD(myHUD);
	if (MenuHUD != None)
	{
		//Let the clients that are waiting for a synch from the host know that they're ready to go
		MenuHUD.bCanUseFrontEndHistory = true;
		//If the client is already in the menu, then tell him to synch now!
		if (MenuHUD.FrontEndMovie != None)
		{
			MenuHUD.FrontEndMovie.SynchMenuToStoredHistory(CurrentSelection);
		}
	}
}

/**
 * Function that tells the client to modify the next screen to go to for a given screen's menu option
 * @param NewFlowModArray - Array of all flowmods in effect at the moment
 * @param FlowModLength - Length of the flow mod array
 */
reliable client function ClientMainMenuFlowChange(MMFlowModification NewFlowModArray[`MAX_FLOWMOD_LENGTH], byte FlowModLength)
{
	local GearMenuHUD MenuHUD;
	local GearUIManager UIManager;
	local int i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != none)
	{
		for(i = 0; i < FlowModLength; i++)
		{
			UIManager.MainMenuFlowMods[i].BaseScreen = NewFlowModArray[i].BaseScreen;
			UIManager.MainMenuFlowMods[i].SelectionIdx = NewFlowModArray[i].SelectionIdx;
			UIManager.MainMenuFlowMods[i].ModifiedNext = NewFlowModArray[i].ModifiedNext;
		}
		UIManager.MainMenuFlowModLength = FlowModLength;
	}
	MenuHUD = GearMenuHUD(myHUD);
	if (MenuHUD != None)
	{
		if (MenuHUD.FrontEndMovie != None)
		{
			MenuHUD.FrontEndMovie.SynchToStoredFlowMods();
		}
	}
}

/** Let the UI know that players have switched teams */
reliable client function ClientTeamChangeOccuredCallback(GearPRI PRI1, GearPRI PRI2)
{
	local GearMenuHUD MenuHUD;

	MenuHUD = GearMenuHUD(myHUD);
	if (MenuHUD != None &&
		MenuHUD.PregameLobbyMovie != None)
	{
		MenuHUD.PregameLobbyMovie.NotifyTeamChanged( PRI1, PRI2 );
	}
}

/**
 * Function that tells the client to modify what options are disabled
 * @param NewDisabledArray - Array of all disabled changes
 * @param DisabledLength - Length of the disabled array
 */
reliable client function ClientMainMenuDisabledChange(MMDisabledItem NewDisabledArray[`MAX_DISABLED_LENGTH], byte DisabledLength)
{
	local GearMenuHUD MenuHUD;
	local GearUIManager UIManager;
	local int i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != none)
	{
		for(i = 0; i < DisabledLength; i++)
		{
			UIManager.MainMenuDisabled[i].Screen = NewDisabledArray[i].Screen;
			UIManager.MainMenuDisabled[i].SelectionIdx = NewDisabledArray[i].SelectionIdx;
			UIManager.MainMenuDisabled[i].bIsDisabled = NewDisabledArray[i].bIsDisabled;
		}
		UIManager.MainMenuDisabledLength = DisabledLength;
	}
	MenuHUD = GearMenuHUD(myHUD);
	if (MenuHUD != None)
	{
		if (MenuHUD.FrontEndMovie != None)
		{
			MenuHUD.FrontEndMovie.SynchToStoredDisabled();
		}
	}
}

/**
 * Function that tells the client to remove the options specified
 * @param NewRemovedArray - Array of all disabled changes
 * @param RemovedLength - Length of the disabled array
 */
reliable client function ClientMainMenuRemovedChange(MMRemovedItem NewRemovedArray[`MAX_REMOVED_LENGTH], byte RemovedLength)
{
	local GearMenuHUD MenuHUD;
	local GearUIManager UIManager;
	local int i;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != none)
	{
		for(i = 0; i < RemovedLength; i++)
		{
			UIManager.MainMenuRemoved[i].Screen = NewRemovedArray[i].Screen;
			UIManager.MainMenuRemoved[i].SelectionIdx = NewRemovedArray[i].SelectionIdx;
			UIManager.MainMenuRemoved[i].bIsUndone = NewRemovedArray[i].bisUndone;
		}
		UIManager.MainMenuRemovedLength = RemovedLength;
	}
	MenuHUD = GearMenuHUD(myHUD);
	if (MenuHUD != None)
	{
		if (MenuHUD.FrontEndMovie != None)
		{
			MenuHUD.FrontEndMovie.SynchToStoredRemoved();
		}
	}
}

/**
 * Function that tells the client to update the chapter and act completion info for the UI
 * 
 * @param CompletedChaptersCasual - bitfield showing what chapters have been beaten in Casual difficulty
 * @param CompletedChaptersNormal - bitfield showing what chapters have been beaten in Normal difficulty
 * @param CompletedChaptersHard - bitfield showing what chapters have been beaten in Hardcore difficulty
 * @param CompletedChaptersInsane - bitfield showing what chapters have been beaten in Insane difficulty
 * @param UnlockedChapters - bitfield showing what chapters have been unlocked
 */
reliable client function ClientMainMenuChapterChange(int CompletedChaptersCasual[`NUM_CHAPTER_BITFIELD_INTS],
													int CompletedChaptersNormal[`NUM_CHAPTER_BITFIELD_INTS],
													int CompletedChaptersHard[`NUM_CHAPTER_BITFIELD_INTS],
													int CompletedChaptersInsane[`NUM_CHAPTER_BITFIELD_INTS],
													int UnlockedChapters[`NUM_CHAPTER_BITFIELD_INTS])
{
	local GearUIManager UIManager;
	local int i;
	local GearMenuHUD MenuHud;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != none)
	{
		for (i =0; i < `NUM_CHAPTER_BITFIELD_INTS; i++)
		{
			UIManager.CompletedChaptersCasual[i] = CompletedChaptersCasual[i];
			UIManager.CompletedChaptersNormal[i] = CompletedChaptersNormal[i];
			UIManager.CompletedChaptersHard[i] = CompletedChaptersHard[i];
			UIManager.CompletedChaptersInsane[i] = CompletedChaptersInsane[i];
			UIManager.UnlockedChapters[i] = UnlockedChapters[i];
		}
	}

	//Now update the ui if necessary
	MenuHud = GearMenuHUD(myHUD);
	if (IsPrimaryPlayer() && MenuHud != none && MenuHud.FrontEndMovie != None)
	{
		MenuHud.FrontEndMovie.UpdateActAndChapterSettings();
	}
}

/**
 * Function that tells the client to update the save slot info for the UI
 * 
 * @param SaveSlotData - array of MMSaveSlotData structs, representing the data in each saveslot
 */
reliable client function ClientMainMenuSaveSlotChange(MMSaveSlotData SaveSlotData[`NUM_SAVE_SLOTS])
{
	local GearUIManager UIManager;
	local int i;
	local GearMenuHUD MenuHud;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != none)
	{
		for (i =0; i < `NUM_SAVE_SLOTS; i++)
		{
			UIManager.SaveSlotData[i] = SaveSlotData[i];
		}
	}

	//Now update the ui if necessary
	MenuHud = GearMenuHUD(myHUD);
	if (IsPrimaryPlayer() && MenuHud != none && MenuHud.FrontEndMovie != None && MenuHud.FrontEndMovie.MainMenuMovie != None)
	{
		MenuHud.FrontEndMovie.MainMenuMovie.UpdateSaveSlotOptions();
	}
}

/**
 * Copies profile settings from the datastore and stores them in local variables.
 */
exec function UpdateLocalCacheOfProfileSettings()
{
	local GearMenuHUD MenuHUD;
	local int CompletedChaptersCasual[2], CompletedChaptersNormal[2], CompletedChaptersHard[2], CompletedChaptersInsane[2], UnlockedChapters[2];

	super.UpdateLocalCacheOfProfileSettings();

	MenuHUD = GearMenuHUD(myHUD);
	if (Role == ROLE_Authority && MenuHUD != none && MenuHUD.FrontEndMovie != none)
	{
		//Send the chapter info to all clients
		ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersCasual1,CompletedChaptersCasual[0]);
		ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersCasual2,CompletedChaptersCasual[1]);
		ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersNormal1,CompletedChaptersNormal[0]);
		ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersNormal2,CompletedChaptersNormal[1]);
		ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersHard1,CompletedChaptersHard[0]);
		ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersHard2,CompletedChaptersHard[1]);
		ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersInsane1,CompletedChaptersInsane[0]);
		ProfileSettings.GetProfileSettingValueInt(`CompletedChaptersInsane2,CompletedChaptersInsane[1]);
		ProfileSettings.GetProfileSettingValueInt(`UnlockedChapterAccess1,UnlockedChapters[0]);
		ProfileSettings.GetProfileSettingValueInt(`UnlockedChapterAccess2,UnlockedChapters[1]);
		ClientMainMenuChapterChange(CompletedChaptersCasual,CompletedChaptersNormal,
									CompletedChaptersHard,CompletedChaptersInsane,UnlockedChapters);
		MenuHUD.FrontEndMovie.MakeProfileModifications();
	}
}

/**
 * Kicks off the reading of the various achievement unlocks
 */
function ReadAchievementUnlocks()
{
	local int ControllerId;
	local LocalPlayer LP;

	// Don't try to do this for remote players
	LP = LocalPlayer(Player);
	if (LP != None)
	{
		ControllerId = LP.ControllerId;

		if (OnlineSub != None &&
			OnlineSub.PlayerInterface != None &&
			OnlineSub.PlayerInterface.GetLoginStatus(ControllerId) > LS_NotLoggedIn &&
			!ProfileSettings.HasReadAchievements())
		{
			// All of the achievement reading will go through this one delegate
			OnlineSub.PlayerInterface.AddReadAchievementsCompleteDelegate(ControllerId,OnReadAchievementsComplete);
			AchievementReadCount = 6;
			// Read all of the achievements at once
			OnlineSub.PlayerInterface.ReadAchievements(ControllerId,`Gears1TitleId,false,false);
			OnlineSub.PlayerInterface.ReadAchievements(ControllerId,`Gears2TitleId,false,false);
			OnlineSub.PlayerInterface.ReadAchievements(ControllerId,`GearsPCTitleId,false,false);
			OnlineSub.PlayerInterface.ReadAchievements(ControllerId,`UT3TitleId,false,false);
			OnlineSub.PlayerInterface.ReadAchievements(ControllerId,`ShadowComplexTitleId,false,false);
			OnlineSub.PlayerInterface.ReadAchievements(ControllerId,`BSTitleId,false,false);
		}
	}
}

/**
 * Called when the async achievements read has completed
 *
 * @param TitleId the title id that the read was for (0 means current title)
 */
function OnReadAchievementsComplete(int TitleId)
{
	local array<AchievementDetails> AchievementList;
	local int ControllerId;

	ControllerId = LocalPlayer(Player).ControllerId;

	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		ProfileSettings.MarkHasReadAchievements();
		// Get a copy of the achievements that we read
		OnlineSub.PlayerInterface.GetAchievements(ControllerId,AchievementList,TitleId);
		// Look at the achievements based upon title id
		switch (TitleId)
		{
			case `Gears1TitleId:
				AchievementReadCount--;
				CheckGears1Achievements(AchievementList);
				break;
			case `Gears2TitleId:
				AchievementReadCount--;
				CheckGears2Achievements(AchievementList);
				break;
			case `GearsPCTitleId:
				AchievementReadCount--;
				if (HasAnyAchievement(AchievementList))
				{
					ProfileSettings.SetProfileSettingValueInt(`HasGearsPCCheevo,1);
					NotifyEarnedAward('PlayedPC');
				}
				break;
			case `UT3TitleId:
				AchievementReadCount--;
				if (HasAnyAchievement(AchievementList))
				{
					ProfileSettings.SetProfileSettingValueInt(`HasUT3Cheevo,1);
					NotifyEarnedAward('PlayedUT');
				}
				break;
			case `ShadowComplexTitleId:
				AchievementReadCount--;
				if (HasAnyAchievement(AchievementList))
				{
					ProfileSettings.SetProfileSettingValueInt(`HasSCCheevo,1);
					NotifyEarnedAward('PlayedSC');
				}
				break;
			case `BSTitleId:
				AchievementReadCount--;
				if (HasAnyAchievement(AchievementList))
				{
					ProfileSettings.SetProfileSettingValueInt(`HasBSCheevo,1);
					NotifyEarnedAward('PlayedBS');
				}
				break;
		}
		if (AchievementReadCount == 0)
		{
			OnlineSub.PlayerInterface.ClearReadAchievementsCompleteDelegate(ControllerId,OnReadAchievementsComplete);
		}
	}
}

/**
 * Handles the specific achievement requirements for unlocks
 *
 * @param AchievementList the list of achievements to examine
 */
function CheckGears1Achievements(const out array<AchievementDetails> AchievementList)
{
	local int AchIndex;

	AchIndex = AchievementList.Find('Id',`Gears1CampId);
	if (AchIndex != INDEX_NONE)
	{
		if (AchievementList[AchIndex].bWasAchievedOnline || AchievementList[AchIndex].bWasAchievedOffline)
		{
			// Save whether they earned it
			ProfileSettings.SetProfileSettingValueInt(`HasGears1Camp,1);
		}
	}
}

/** Determines if all 3 games had their campaigns completed */
function CheckCampCompletionUnlock()
{
	local int HasG1;
	local int HasG2;
	local int HasG3;

	// See if we have all of the campaigns completed
	ProfileSettings.GetProfileSettingValueInt(`HasGears1Camp,HasG1);
	ProfileSettings.GetProfileSettingValueInt(`HasGears2Camp,HasG2);
	ProfileSettings.GetProfileSettingValueInt(`HasGears3Camp,HasG3);
	// Give them the award if they had all of the achievements
	if (HasG1 > 0 && HasG2 > 0 && HasG3 > 0)
	{
		NotifyEarnedAward('AllCamp');
	}
}

/**
 * Handles the specific achievement requirements for unlocks
 *
 * @param AchievementList the list of achievements to examine
 */
function CheckGears2Achievements(const out array<AchievementDetails> AchievementList)
{
	local int AchIndex;
	local bool bHasVeteranGear; 
	local bool bHasHoardTheHorde; 

	AchIndex = AchievementList.Find('Id',`RookieGearId);
	if (AchIndex != INDEX_NONE)
	{
		// Save whether they earned it
		ProfileSettings.SetRookieGear(AchievementList[AchIndex].bWasAchievedOnline);
	}
	AchIndex = AchievementList.Find('Id',`VeteranGearId);
	if (AchIndex != INDEX_NONE)
	{
		// Save whether they earned it online (offline was the cheat/exploit)
		bHasVeteranGear = AchievementList[AchIndex].bWasAchievedOnline;
		ProfileSettings.SetProfileSettingValueInt(`HasVeteranGear,int(bHasVeteranGear));
	}
	AchIndex = AchievementList.Find('Id',`HoardTheHordeId);
	if (AchIndex != INDEX_NONE)
	{
		// Save whether they earned it. Horde can be done offline
		bHasHoardTheHorde = AchievementList[AchIndex].bWasAchievedOnline || AchievementList[AchIndex].bWasAchievedOffline;
		ProfileSettings.SetProfileSettingValueInt(`HasHoardTheHorde,int(bHasHoardTheHorde));
	}
	// Give them the award if they had both achievements
	if (bHasVeteranGear)
	{
		NotifyEarnedAward('OldGuard');
	}
	AchIndex = AchievementList.Find('Id',`Gears2CampId);
	if (AchIndex != INDEX_NONE)
	{
		if (AchievementList[AchIndex].bWasAchievedOnline || AchievementList[AchIndex].bWasAchievedOffline)
		{
			ProfileSettings.SetProfileSettingValueInt(`HasGears2Camp,1);
		}
	}
}

/**
 * Looks through the achievements to see if any are unlocked
 *
 * @param AchievementList the list of achievements to examine
 */
final function bool HasAnyAchievement(const out array<AchievementDetails> AchievementList)
{
	local int Index;

	for (Index = 0; Index < AchievementList.Length; Index++)
	{
		// Accept either online or offline
		if (AchievementList[Index].bWasAchievedOnline || AchievementList[Index].bWasAchievedOffline)
		{
			return true;
		}
	}
	return false;
}

/** Prints out any achievement based unlock information */
exec function DumpAchievementBasedUnlocks()
{
	local int Value;

	ProfileSettings.GetProfileSettingValueInt(`HasGears1Camp,Value);
	`Log("HasGears1Camp = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasGears2Camp,Value);
	`Log("HasGears2Camp = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasGears3Camp,Value);
	`Log("HasGears3Camp = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasRookieGear,Value);
	`Log("HasRookieGear = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasVeteranGear,Value);
	`Log("HasVeteranGear = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasHoardTheHorde,Value);
	`Log("HasHoardTheHorde = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasUT3Cheevo,Value);
	`Log("HasUT3Cheevo = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasBSCheevo,Value);
	`Log("HasBSCheevo = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasSCCheevo,Value);
	`Log("HasSCCheevo = " $ bool(Value));
	ProfileSettings.GetProfileSettingValueInt(`HasGearsPCCheevo,Value);
	`Log("HasGearsPCCheevo = " $ bool(Value));
}

/**
 * Kicks off the reading of achievements and/or checks for progress unlock
 */
function CheckForAchievementUnlocks()
{
	// Read the achievements if they have not already been read
	ReadAchievementUnlocks();
	// Since this is a Gears3 one too always check
	CheckCampCompletionUnlock();
}