/**
 * This player controller class is used for the campaign lobby.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPC_SP extends GearPC
	native(PC);

/** Distance a player must be before a screen effect shows up for the tempest beam */
var config float TempestBeamDistanceForScreenEffect;

/**
 * Starts the online game using the session name in the PRI
 */
reliable client function ClientStartOnlineGame()
{
	local LocalPlayer LP;
	Super.ClientStartOnlineGame();
	if (WorldInfo.GRI.GameClass.Name == 'GearGameSP_Arcade_Content')
	{
		// Do the leaderboard stats read
		LP = LocalPlayer(Player);
		if (LP != None)
		{
			OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(LP.ControllerId,OnReadFriendsComplete);
			OnlineSub.PlayerInterface.ReadFriendsList(LP.ControllerId);
		}
	}
}

/** Setup the carrot ladder for arcade now that we have friends */
simulated function OnReadFriendsComplete(bool bWasSuccessful)
{
	local LocalPlayer LP;
	LP = LocalPlayer(Player);
	if (LP != None)
	{
		OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(LP.ControllerId,OnReadFriendsComplete);
		if (bWasSuccessful)
		{
			StatManager.SetupCarrotLadder("GearGame.GearCarrotLadder_Arcade");
		}
	}
}

/*
 * Called at SinglePlayer game over to do book keeping
 * overloaded here to handle arcade mode stats writes
 */
function ProcessGameOver()
{
	local GearPC PC;

	Super.ProcessGameOver();

	if (WorldInfo.GRI.GameClass.Name == 'GearGameSP_Arcade_Content')
	{
		foreach WorldInfo.AllControllers(class'GearPC', PC)
		{
			// Write out arcade leaderboard stats
			PC.ClientWriteLeaderboardStats(WorldInfo.Game.OnlineStatsWriteClass);
		}
	}

	// End session to flush stats
	WorldInfo.Game.EndOnlineGame();
}

/**
 * Tells the clients to write the stats using the specified stats object
 *
 * @param OnlineStatsWriteClass the stats class to write with
 * @param bIsIncomplete TRUE if the match wasn't finished at the time of the write
 */
reliable client function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass, optional bool bIsIncomplete=false)
{
	local GearGRI GRI;
	local GearPRI PRI;
	local UniqueNetId ZeroId;
	local int Index, OldHighScore, MaxHighScore, PlayerCount;

	Super.ClientWriteLeaderboardStats(OnlineStatsWriteClass, bIsIncomplete);

	if (WorldInfo.GRI.GameClass.Name == 'GearGameSP_Arcade_Content')
	{
		OldHighScore = StatManager.GetHighScore();
		if (OldHighScore > 0 && PRI.Score > OldHighScore)
		{
			// @ACHIEVEMENT - It's Called Progress
			ClientUnlockAchievement(eGA_ITSCALLEDPROGRESS);
		}

		if (ProfileSettings != None)
		{
			GRI = GearGRI(WorldInfo.GRI);
			if (GRI != None)
			{
				// Determine the highest score amongst N players
				for (Index = 0; Index < GRI.PRIArray.Length; Index++)
				{
					PRI = GearPRI(GRI.PRIArray[Index]);
					if (!PRI.bIsInactive &&
						PRI.UniqueId != ZeroId)
					{
						PlayerCount++;
						if (MaxHighScore < PRI.Score)
						{
							MaxHighScore = PRI.Score;
						}
					}
				}

				if (PlayerCount == 4 && MaxHighScore > 0 && PlayerReplicationInfo.Score >= MaxHighScore)
				{
					ProfileSettings.UpdateAchievementProgression(eGA_FIRSTAMONGEQUALS, self);
				}
			}
		}
	}
}

/**
 * Used when a host is telling a client to return to their party host from the
 * current session. It looks for the session named 'Party' and does a travel to
 * it. If it's not available, it just does a "disconnect"
 *
 * @param RequestingPlayer net id of the player that is requesting the travel
 */
reliable client function ClientReturnToParty(UniqueNetId RequestingPlayerId)
{
	local string URL;
	local UniqueNetId ZeroId;

	bIgnoreNetworkMessages = true;
	bIsReturningFromMatch = true;

`LogOnline("");
`LogOnline("");
`LogOnline("Client has been told to return to party by"
	$" RequestingPlayerId="$class'OnlineSubsystem'.static.UniqueNetIdToString(RequestingPlayerId));

	// make sure we're not paused
	if ( MyGearHUD != None && MyGearHUD.UI_PauseSceneInstance != None )
	{
		MyGearHUD.UnPauseGame();
	}
	else
	{
		SetPause(false);
	}

	// explicit call to show loading movie because this transition occurs via ServerTravel, which doesn't always call ClientTravel
	ClientShowLoadingMovie(true);
	// only do this for the first player in split-screen sessions.
	if (IsPrimaryPlayer())
	{
`LogOnline(self$" is the primary player");
		if (OnlineSub != None &&
			OnlineSub.GameInterface != None &&
			OnlineSub.PlayerInterface != None)
		{
			if (OnlineSub.GameInterface.GetGameSettings('Game') != None &&
				WorldInfo.NetMode == NM_Client)
			{
				OnlineSub.GameInterface.DestroyOnlineGame('Game');
			}
			// Find the party settings to verify that a party is registered
			if (OnlineSub.GameInterface.GetGameSettings('Party') != None)
			{
				// Now see if we are the party host or not
				if (IsPartyLeader())
				{
					UnregisterRemotePlayers();
					// We are the party host so create the session and listen for returning clients
					URL = GetPartyMapName() $ "?game=" $ GetPartyGameTypeName() $ "?listen";
`LogOnline(self$" is the party leader and is traveling with "$URL);
					// Server travel doesn't call PreClientTravel() so manually call it here
					PreClientTravel(URL,TRAVEL_Absolute,false);
					// Transition to being the party host without notifying clients and traveling absolute
					WorldInfo.ServerTravel(URL,true,true);
				}
				// party client initiated travel and should travel back to main menu on his own
				else if (RequestingPlayerId == ZeroId || RequestingPlayerId == PlayerReplicationInfo.UniqueId)
				{
`LogOnline(self$" is NOT the party leader and travel was NOT initiated by the party or game host...returning to main menu");
					OnlineSub.GameInterface.DestroyOnlineGame('Party');
					ConsoleCommand("disconnect");
				}
				else
				{
					// We are joining so grab the connect string to use
					if (OnlineSub.GameInterface.GetResolvedConnectString('Party',URL))
					{
`LogOnline(self$" is NOT the party leader and is traveling with "$URL);
						ClientTravel(URL, TRAVEL_Absolute);
					}
				}
			}
			// If we are splitscreen, then return to the lobby
			else if (GetSplitscreenPlayerCount() > 1)
			{
				URL = GetPartyMapName() $ "?game=" $ GetPartyGameTypeName();
				// Transition to being the party host without notifying clients and traveling absolute
				WorldInfo.ServerTravel(URL,true,true);
			}
			else
			{
				ConsoleCommand("disconnect");
			}
		}
		else
		{
			ConsoleCommand("disconnect");
		}
	}
}

/**
 * Replicated function to use when setting the rich presence string for coop
 *
 * @param PawnClass the pawn this player is playing as
 * @param Chapter the chapter point to convert to act/chapter information
 */
reliable client function ClientSetCoopRichPresence(class<Pawn> PawnClass,int Chapter)
{
	local int ActId;
	local int NormalizedChapter;
	local GearCampaignActData ActData;
	local LocalPlayer LP;
	local array<LocalizedStringSetting> StringSettings;
	local array<SettingsProperty> Properties;
	local SettingsProperty Prop;

	LP = LocalPlayer(Player);
	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		// Get the act this chapter is in
		ActData = class'GearUIDataStore_GameResource'.static.GetActDataProviderUsingChapter(Chapter);
		if (ActData != None)
		{
			ActId = ActData.ActNum + 1;
		}
		Prop.PropertyId = class'GearGame'.const.PROPERTY_ACTNUM;
		Prop.AdvertisementType = ODAT_OnlineService;
		class'Settings'.static.SetSettingsDataInt(Prop.Data,ActId);
		Properties.AddItem(Prop);
		// Now get the chapter number to display in rich presence
		NormalizedChapter = class'GearUIDataStore_GameResource'.static.GetActChapterProviderIndexFromChapterId(Chapter) + 1;
		Prop.PropertyId = class'GearGame'.const.PROPERTY_CHAPTERNUM;
		class'Settings'.static.SetSettingsDataInt(Prop.Data,NormalizedChapter);
		Properties.AddItem(Prop);
		// Finally set the person they are playing as
		StringSettings.Length = 1;
		StringSettings[0].AdvertisementType = ODAT_OnlineService;
		StringSettings[0].Id = class'GearGame'.const.CONTEXT_COOPCHARNAME;
		
		// Choose the right string based on pawn class
		if (ClassIsChildOf(PawnClass, class'GearPawn_COGMarcus'))
		{
		   StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_MARCUS;
		}
		else if (InStr(PawnClass.Name, "COGDom", false, true) != INDEX_NONE)
		{
			StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_DOM;
		}
		else if (InStr(PawnClass.Name, "COGAnya", false, true) != INDEX_NONE)
		{
			StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_ANYA;
		}
		else if (InStr(PawnClass.Name, "COGDizzy", false, true) != INDEX_NONE)
		{
			StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_DIZZY;
		}
		else if (InStr(PawnClass.Name, "COGGus", false, true) != INDEX_NONE)
		{
			StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_COLE;
		}
		else if (InStr(PawnClass.Name, "COGBaird", false, true) != INDEX_NONE)
		{
			StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_BAIRD;
		}
		else if (InStr(PawnClass.Name, "COGSam", false, true) != INDEX_NONE)
		{
			StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_SAM;
		}
		else if (InStr(PawnClass.Name, "COGBernie", false, true) != INDEX_NONE)
		{
			StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_BERNIE;
		}
		else
		{
			// Failsafe
			StringSettings[0].ValueIndex = class'GearGame'.const.CONTEXT_COOPCHARNAME_MARCUS;
		}

		OnlineSub.PlayerInterface.SetOnlineStatus(LP.ControllerId, class'GearGame'.const.CONTEXT_PRESENCE_COOPPRESENCE, StringSettings, Properties);
	}
}

/**
 * Login changes mean we must go back to the main menu
 *
 * @param LocalUserNum the user that just logged in
 */
function OnLoginChange(byte LocalUserNum)
{
	local UniqueNetId NetId;

	NetId = PlayerReplicationInfo.UniqueId;
	Super.OnLoginChange(LocalUserNum);
	// If we swapped profiles, throw away the saved state
	if (NetId != PlayerReplicationInfo.UniqueId &&
		!WorldInfo.IsMenuLevel())
	{
		ProfileSettings = None;
		PersistentData = None;
		StatManager = None;
	}
	ReturnToMainMenu(true);
}

/**
 * Delegate called when a player's status changes but doesn't change profiles
 *
 * @param NewStatus the new login status for the user
 * @param NewId the new id to associate with the user
 */
function OnLoginStatusChange(ELoginStatus NewStatus,UniqueNetId NewId)
{
	Super.OnLoginStatusChange(NewStatus,NewId);
	// We can continue to play SP if we are signed in locally
	if (NewStatus == LS_NotLoggedIn)
	{
		ReturnToMainMenu(true);
	}
}

/**
 * Displays a message when the physical network is lost during a networked game for a client
 *
 * @param bIsConnected the new connection state
 */
function OnLinkStatusChange(bool bIsConnected)
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	// Ignore the server losing their cable because they can still continue to play
	if (!bIsConnected && WorldInfo.NetMode == NM_Client)
	{
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		// We need to always bail in this case
		if (UIManager != None)
		{
			ButtonAliases.AddItem('GenericAccept');
			UIManager.ShowUIMessage('ConnectionError',
				Localize("MessageBoxErrorStrings","LostLink_Title","GearGameUI"),
				Localize("MessageBoxErrorStrings","LostLink_Message","GearGameUI"),
				ButtonAliases,
				None,
				LocalPlayer(Player),,,,,false);
		}
		ReturnToMainMenu(true);
	}
}


reliable client function AddScoreGameMessage(int Id, int Pts, optional GearPRI Victim)
{
	// no scoring in Campaign
	if (WorldInfo.GRI != None && ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSP_Arcade'))
	{
		Super.AddScoreGameMessage(Id, Pts, Victim);
	}
}

/** Function that gets called when a coop player joins a campaign game */
function CoopPlayerJoinedCampaign()
{
	ResetTaccomAIMoods();
}

/**
 * Marks the chapter as being completed at a particular difficulty
 *
 * @param CompletedChapter the chapter to mark as complete
 * @param Difficulty the difficulty level that was completed
 * @param bWasArcade - is this arcade mode
 * @param NumCoopPlayers - number of players at time of the call
 */
reliable client function ClientCompleteChapter(int CompletedChapter, EDifficultyLevel Difficulty, bool bWasArcade, int NumCoopPlayers)
{
	super.ClientCompleteChapter(CompletedChapter, Difficulty, bWasArcade, NumCoopPlayers);

	LogSinglePlayerChapterData(CompletedChapter,false);
}

/**
 * Displays the specified chapter information on the screen for the client
 *
 * @param DisplayChapter the chapter to display the information for
 */
final reliable client function ClientDisplayChapterTitle(int DisplayChapter)
{
	local GearCampaignActData ActData;
	local GearCampaignChapterData ChapterData;

	// Get the act and chapter data for display purposes
	ActData = class'GearUIDataStore_GameResource'.static.GetActDataProviderUsingChapter(DisplayChapter);
	ChapterData = class'GearUIDataStore_GameResource'.static.GetChapterDataProvider(DisplayChapter);

	if (MyGearHud != None)
	{
		MyGearHud.DisplayChapterCallout(ActData.DisplayName, ChapterData.DisplayName, ChapterData.ChapterTime, ChapterData.ChapterLocation);
	}
	if (PlayerReplicationInfo != None)
	{
		// Update rich presence with the same information
		ClientSetCoopRichPresence(GearPRI(PlayerReplicationInfo).PawnClass,DisplayChapter);
	}
	LogSinglePlayerChapterData(DisplayChapter,true);
}

/**
 * Advances the in-game credits
 */
final reliable client function ClientAdvanceCredits()
{
	if( MyGearHud != None )
	{
		MyGearHud.AdvanceCredits();
	}
}

/**
 * Logs out the information for MGS playtesting to gather data
 *
 * @param Chapter the chapter that was either started or completed
 * @param bIsStartOrEnd true if the start, false if the end
 */
function LogSinglePlayerChapterData(int Chapter,bool bIsStartOrEnd)
{
	local GearCampaignActData ActData;
	local GearCampaignChapterData ChapterData;

	// Get the act and chapter data for logging purposes
	ActData = class'GearUIDataStore_GameResource'.static.GetActDataProviderUsingChapter(Chapter);
	ChapterData = class'GearUIDataStore_GameResource'.static.GetChapterDataProvider(Chapter);
	// Call the internal version so we can always log even in final release script
	LogSinglePlayerChapterDataInternal(Chapter,bIsStartOrEnd,ActData.ActNum,ChapterData.ChapterNum);
}

/**
 * Logs out the information for MGS play testing to gather data. Does this natively to
 * bypass final release compiling out the `Log statements
 *
 * @param Chapter the chapter that was either started or completed
 * @param bIsStartOrEnd true if the start, false if the end
 * @param ActNum the id of the act
 * @param ChapterNum the id of the chapter
 */
native function LogSinglePlayerChapterDataInternal(int Chapter,bool bIsStartOrEnd,int ActNum,int ChapterNum);


/** Must run test to see if player needs this tag on the client */
final function bool TryToPickUpDiscoverable( GearDiscoverablesPickupFactoryBase Dicoverable )
{
	if ( Dicoverable.CanBePickedUpBy(MyGearPawn) && CanDoSpecialMove(SM_WeaponPickup) )
	{
		Dicoverable.GiveTo( MyGearPawn );
		return TRUE;
	}

	return FALSE;
}

/** See if any local controllers need to turn discoverables on/off */
final function CheckForDiscoverableVisibility()
{
	local GearDiscoverablesPickupFactoryBase Factory;

	// Loop through each factory
	foreach WorldInfo.AllNavigationPoints( class'GearDiscoverablesPickupFactoryBase', Factory )
	{
		Factory.CheckForDiscoverableVisibility();
	}
}

/** Whether or not a discoverable has already been discovered or not */
final simulated event bool HasFoundDiscoverable( EGearDiscoverableType DiscType )
{
	// If there is no online subsystem (no profile)
	if ( OnlineSub == None || ProfileSettings == None )
	{
		return FALSE;
	}

	return ProfileSettings.HasDiscoverableBeenFound( DiscType );
}

/** Function called by a discoverable to tell the PC that it picked it up */
final function PickedUpDiscoverable( GearDiscoverablesPickupFactoryBase Discoverable )
{
	// Perform the server-side actions that will only happen on the PC who picked up the discoverable
	ServerPickedUpDiscoverable( PlayerReplicationInfo, Discoverable.DISC_DiscoverableType, Discoverable.DISC_PickupType, Discoverable.Location, Discoverable.DISC_PickupSound );

	// Perform actions that will only happen on the PC who picked up the discoverable
	PerformActionsForDiscoverablePickup( Discoverable );
}

// Perform actions that will only happen on the PC who picked up the discoverable
final function PerformActionsForDiscoverablePickup( GearDiscoverablesPickupFactoryBase Discoverable )
{
	ClientPerformDiscoverableActions( Discoverable.DISC_DiscoverableType, true );
}

/** Perform client-side actions on all GearPCs so they get credit and display what they need to display */
reliable simulated client function ClientPerformDiscoverableActions( EGearDiscoverableType DiscType, bool bDisplayUI )
{
	local GearPC PC;

	DiscoverType = DiscType;
	// Mark as having been picked up by all local players
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		// Mark the pickup as found in the profile
		if (PC.ProfileSettings != None)
		{
			// Set and mark the profile
			PC.ProfileSettings.MarkDiscoverableAsFoundButNotViewed(DiscType,PC);
		}
	}

	// Call the check so the discoverable can be told to hide, but wait for some time so the anim can play
	SetTimer(0.5,FALSE,nameof(CheckForDiscoverableVisibility));

	// Don't open the scene for cogtags
	if (bDisplayUI &&
		InStr(string(DiscType),"_CogTag") == INDEX_NONE)
	{
		// Call the UI to get opened after some time
		SetTimer(1.0,FALSE,nameof(StartDiscoverableUI));
	}
}

/** Shows the discoverable UI parts */
final function StartDiscoverableUI()
{
	// Have the HUD open the discoverable scene
	if ( MyGearHud != None )
	{
		MyGearHud.OpenDiscoverableScene();
	}
}

/** Function called on the server when a discoverable is picked up */
reliable server function ServerPickedUpDiscoverable( PlayerReplicationInfo PickupPRI, EGearDiscoverableType DiscType, EGearDiscoverablePickupType DiscPUType, vector DiscLocation, SoundCue DiscSoundCue )
{
	local GearPC_SP CurrPC;

	// Send GUDs
	if ( WorldInfo.Game != None )
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_PickedUpCollectible, MyGearPawn, None, 0.5f);
	}

	// Trigger kismet event
	TriggerEventClass(class'SeqEvent_PickupStatusChange', MyGearPawn, 1);

	// Do wall grab special move
	if ( DiscPUType == eGDPT_Wall )
	{
		MyGearPawn.SpecialMoveLocation = DiscLocation;
		ServerDictateSpecialMove(SM_PushButton);
	}
	// Do pickup special move
	else
	{
		// make sure it doesn't think we're picking up some old other Actor
		GSM_Pickup(MyGearPawn.SpecialMoves[SM_WeaponPickup]).PickupActor = None;
		ServerDictateSpecialMove(SM_WeaponPickup);
	}

	// Play sound
	if ( DiscSoundCue != None )
	{
		PlaySound( DiscSoundCue, FALSE );
	}

	// If there are any networked players, perform the client-side actions
	// on the controllers who did not pick the discoverable up.
	// If this is splitscreen we will not do it.
	if (ShouldReplicateDiscoverable())
	{
		ForEach WorldInfo.AllControllers(class'GearPC_SP', CurrPC)
		{
			if (CurrPC.PlayerReplicationInfo != PickupPRI)
			{
				CurrPC.ClientPerformDiscoverableActions( DiscType, false );
			}
		}
	}
}

/** Whether we should replicate the discoverable UI to clients or not */
function bool ShouldReplicateDiscoverable()
{
	local GearPC_SP PC;

	// We will replicate to clients if there is a networked one (non-splitscreen)
	foreach WorldInfo.AllControllers(class'GearPC_SP', PC)
	{
		if (!PC.IsLocalPlayerController())
		{
			// Found a networked player!
			return true;
		}
	}
	return false;
}

/** Update the beam screen effect */
simulated function UpdateBeamScreenEffect(int DistFromBeam, GearPawn_LocustTempestBase Tempest)
{
	if (MyGearPawn != None &&
		DistFromBeam < TempestBeamDistanceForScreenEffect)
	{
		// Skip the cover checks done in GearPC
		Super(PlayerController).ClientSpawnCameraLensEffect(Tempest.BeamCameraEffectClass);
	}
}

/**
 * Copies profile settings from the datastore and stores them in local variables.
 */
exec function UpdateLocalCacheOfProfileSettings()
{
	Super.UpdateLocalCacheOfProfileSettings();

	// See if any discoverables need to be made visible
	CheckForDiscoverableVisibility();
}

/** Function called to see if there is any client-side-only pickups to grab */
function bool ClientUse()
{
	local Actor PickupActor;
	local GearDiscoverablesPickupFactoryBase Discoverable;

	if (!Super.ClientUse())
	{
		// check for discoverable
		if (MyGearPawn != None)
		{
			PickupActor = MyGearPawn.FindNearbyDiscoverables();
		}
		if (PickupActor != None)
		{
			Discoverable = GearDiscoverablesPickupFactoryBase(PickupActor);
			if (Discoverable != None)
			{
				return TryToPickUpDiscoverable(Discoverable);
			}
		}
		return false;
	}
	return true;
}

/**
 * Clears the discoverable timer if present
 *
 * @param NewPawn the new pawn for the restart
 */
reliable client function ClientRestart(Pawn NewPawn)
{
	Super.ClientRestart(NewPawn);

	ClearTimer(nameof(StartDiscoverableUI));
}

function TransitionFromDeadState()
{
	if (WorldInfo.GRI != None && ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSP_Arcade'))
	{
		TransitionToSpectate(DefaultSpectateType);
	}
}

// Remote call to tell clients to prepare for return to the frontend after beating the game
reliable client function ClientPrepareEndOfGameFrontEnd()
{
	local GearLocalPlayer LP;
	local GearPC PC;

	// Save the profile and persistent data for all local players
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		PC.SaveProfile();
		PC.SavePersistentData();
	}

	// Set a flag on the local player of this GearPC that the frontend can key off of for rolling credits
	// This function was called on the primary player so we don't need to check for that
	LP = GearLocalPlayer(Player);
	if (LP != None)
	{
		LP.bDisplayCredits = true;
	}
}


defaultproperties
{
	DefaultSpectateType=PlayerSpectating
}
