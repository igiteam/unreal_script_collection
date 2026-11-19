/**
 * This class is the game info for the pre-game lobby. It treats its session as
 * if it is the game and not the party lobby.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPreGameLobbyGame_Base extends GearPartyGame_Base;

`include(Engine/Classes/UIDev.uci)

/** The recent players list used to keep track of who has been seen recently */
var OnlineRecentPlayersList RecentPlayersList;

/** Used to auto start rather than waiting for someone to never arrive */
var bool bWaitForPlayersTimedOut;

/** Game settings object use in the pregame game */
var OnlineGameSettings PreGameGameSettings;

/** Whether to ignore logouts or not */
var bool bIsClosing;

event PreBeginPlay()
{
	local OnlineGameSettings GameSettings;
	local int NumberTeams, NumPlayerPerTeam, PlaylistId;

	Super.PreBeginPlay();

	if (GameInterface != None)
	{
		GameSettings = GetPreGameGameSettings();
		RecentPlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	}

	MaxPlayers = GameSettings != None ? GameSettings.NumPublicConnections : 10;

	if (GameSettings.bUsesArbitration ||
		GearPlayerVersusGameSettings(GameSettings) != None)
	{
		if ( OnlineSub != None )
		{
			if ( PlaylistMan != None )
			{
				GameSettings.GetIntProperty(PROPERTY_PLAYLISTID, PlaylistId);
				PlaylistMan.GetTeamInfoFromPlaylist( PlaylistId, NumPlayerPerTeam, NumberTeams, MaxPartySize );
				NumTeams = NumberTeams;
			}
		}
	}
	else
	{
		if ( IsWingmanGametype() )
		{
			NumTeams = 4;
		}
	}
	// Every time a player joins restart the timer
	SetTimer(10.0,false,nameof(OnWaitForPlayerTimerExpired));
}

/**
 * Accept or reject a player on the server.  Fails login if you set the Error to a non-empty string.
 *
 * @param	Options		the URL used to join the match
 * @param	Address		the IP address of the joining player
 * @param	ErrorMessage	if login fails, a message explaining why should be assigned to this variable.
 */
event PreLogin(string Options, string Address, out string ErrorMessage)
{
	Super.PreLogin(Options, Address, ErrorMessage);

	// Every time a player joins restart the timer
	SetTimer(10.0,false,nameof(OnWaitForPlayerTimerExpired));

	if ( ErrorMessage == "" )
	{
		GearPreGameGRI(GameReplicationInfo).ResetCountdown();
	}

	// Can't be invited into the a pre-game lobby
	if (HasOption(Options,"bIsFromInvite"))
	{
		ErrorMessage = GameMessageClass.Default.ArbitrationMessage;
		return;
	}
}

/** Whether this is a local game or not */
function bool IsLocalMatch()
{
	local OnlineGameSettings CurrentSettings;
	local int MatchMode;

	// If this is a local game put the player on team 0
	CurrentSettings = GetPreGameGameSettings();
	if ( CurrentSettings != None &&
		 CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchMode) &&
		 MatchMode == eGVMT_Local )
	{
		return true;
	}
	return false;
}

/**
 * Called after a successful login. This is the first place it is safe to call replicated functions on the PlayerController.
 *
 * @param	NewPlayer	the PlayerController that just successfully connected and logged in.
 */
event PostLogin( PlayerController NewPlayer )
{
	local GearMenuPC MenuPC;
	local GearMenuPC NewMenuPC;

	// Have the game use the recent players list to update this PC with skill/team
	UpdateTeamAndSkillData(GearPreGamePC(NewPlayer));

	Super.PostLogin(NewPlayer);

	// Grab the PC
	NewMenuPC = GearMenuPC(NewPlayer);

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		// Make sure that only the first logged in player sets the GRI game data
		foreach LocalPlayerControllers(class'GearMenuPC', MenuPC)
		{
			if (MenuPC == NewMenuPC)
			{
				GearPreGameGRI(WorldInfo.GRI).InitializeGameSelection(MenuPC);
			}
			break;
		}
	}
}

/**
 * Handles a player leaving the session. If there are only local players left,
 * then return to the party lobby
 *
 * @param Exiting the player leaving the session
 */
function Logout(Controller Exiting)
{
	local int RemotePlayerCount,GameSettingsNumBots;
	local GearPC PC;
	local UniqueNetId RequestingPlayerId;

	if (PreGameGameSettings != None)
	{
		// Get number of bots in current settings and allow matches to continue even if everyone drops
		PreGameGameSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_NUMBOTS, GameSettingsNumBots);
	}

	PC = GearPC(Exiting);
	if (PC != None && !bIsClosing && (GameSettingsNumBots < 1))
	{
		// If a local player leaves, we need to return to main menu
		if (!PC.IsLocalPlayerController())
		{
			// Count how many remote players there are
			foreach WorldInfo.AllControllers(class'GearPC',PC)
			{
				if (!PC.IsLocalPlayerController() && PC != Exiting)
				{
					RemotePlayerCount++;
				}
			}

			// If there are no players left, return to the party lobby
			if (RemotePlayerCount == 0)
			{
				foreach LocalPlayerControllers(class'GearPC', PC)
				{
					if (PC.PlayerReplicationInfo != None)
					{
						RequestingPlayerId = PC.PlayerReplicationInfo.UniqueId;
					}
					PC.ClientReturnToParty(RequestingPlayerId);
					break;
				}
			}
		}
		else
		{
			bIsClosing = true;
		}
	}
}

/**
 * Initializes the party system object for manipulation by the lobby
 */
event InitGame(string Options, out string ErrorMessage)
{
	Super.InitGame(Options, ErrorMessage);

	// Determine if this is training grounds or not
	bIsTrainingGrounds = HasOption(Options, "bIsTraining");

	InitializePreGameGameSettings();
}

/**
 * Used when creating a local match
 */
function InitializePreGameGameSettings()
{
	local OnlineGameSettings CurrentSettings;
	local int MatchModeIdx;

	// If we are in a local match we have to create the game settings object from the CurrentGameSettings and return.
	CurrentSettings = GetCurrentGameSettings(true);
	if ( CurrentSettings != None )
	{
		if ( CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx) )
		{
			// Set the current match mode
			CurrMatchMode = EGearVersusMatchType(MatchModeIdx);

			if (MatchModeIdx == eGVMT_Local ||
				MatchModeIdx == eGVMT_SystemLink)
			{
				PreGameGameSettings = new class'GearVersusGameSettings'(CurrentSettings);
				PreGameGameSettings.bUsesArbitration = false;
				return;
			}
		}
	}

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if ( OnlineSub != None && OnlineSub.GameInterface != None )
	{
		PreGameGameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		if (PreGameGameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx))
		{
			// force number of bot slots to 9 for Player match
			if (MatchModeIdx == eGVMT_Player)
			{
				PreGameGameSettings.SetStringSettingValue(class'GearGame'.const.CONTEXT_NUMBOTS, 9);
			}
		}
	}
}

/** Returns the game settings object used while in the pregame */
function OnlineGameSettings GetPreGameGameSettings()
{
	return PreGameGameSettings;
}

function UpdateGameSettings()
{
	Super(GearMenuGame).UpdateGameSettings();
}

/*========================================================================================================================================*/
/**
 * Determines whether the PRI should be considered when determining whether to start the loadout countdown.
 *
 * @return	TRUE if this PRI should be checked when waiting for everyone to load the pre-game lobby.
 */
function bool IsValidPRI( PlayerReplicationInfo PRI )
{
	return	PRI != None			&& !PRI.bIsInactive
		&&	PRI.Owner != None	&& !PRI.bOnlySpectator
		&&	!GearPC(PRI.Owner).bDedicatedServerSpectator;
}

/**
 * Determines whether the PRI has received all information required for team balancing/changing from the client.
 *
 * @return	TRUE if the PRI has opened its lobby scene (meaning that the client has received GRI, PRI, and its PC & PRI are linked), and the
 *			server has received both the client's UniqueNetId and that of the party leader.
 */
function bool IsPRIInitialized( PlayerReplicationInfo PRI )
{
	local UniqueNetId ZeroId;
	local GearPreGameLobbyPRI LobbyPRI;

	LobbyPRI = GearPreGameLobbyPRI(PRI);
	return	LobbyPRI != None
		&&	LobbyPRI.bLobbySceneOpened
		&&	LobbyPRI.UniqueId != ZeroId;
}

/**
 * Wrapper for checking whether the currently selected gametype is wingman.  This version checks the OnlineGameSettings object for the
 * currently selected gametype so that the result is also valid on clients (only the match host's profile would have the current gametype set)
 */
function bool IsWingmanGametype()
{
	local int GametypeContextId;
	local OnlineGameSettings GameSettings;

	if (GameInterface != None)
	{
		GameSettings = GetPreGameGameSettings();
	}

	return GameSettings != None &&
		GameSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES, GametypeContextId)
		&& GametypeContextId == eGEARMP_Wingman;
}

/** @return true if the match is private, false otherwise */
function bool IsPrivateMatch()
{
	local OnlineGameSettings GameSettings;

	if (GameInterface != None)
	{
		GameSettings = GetPreGameGameSettings();
	}
	return GameSettings == None || (GameSettings.bUsesArbitration == false && GearPlayerVersusGameSettings(GameSettings) == None);
}

/**
 * Wrapper for determining whether the match can be started.  This version returns true once all players have opened their pre-game
 * lobby scenes and determines when the GRI can begin the loadout selection countdown.
 *
 * @return	TRUE if all requirements for beginning the match have been met.
 */
function bool CanStartMatch()
{
	local GearPreGameGRI PGGRI;

	PGGRI = GearPreGameGRI(WorldInfo.GRI);

	if ( PGGRI != None &&
		 PGGRI.bAllPlayerArePresentForDisplay &&
		 ArePlayersReady() &&
		 !ArePlayersNeeded() )
	{
		return true;
	}
	return false;
}

/**
 * Starts the match if all conditions for starting the match have been met.  Initiates
 * the travel for all clients.
 */
function BeginMatch()
{
	local GearUIDataStore_GameResource GameResourceDS;
	local string MapName, LaunchURL;
	local GearPreGameGRI PGGRI;
	local GearGameInfoSummary MatchGameTypeProvider;
	local GearGamePlaylistGameTypeProvider GameTypeProvider;
	local GearLocalPlayer GLP;

	PGGRI = GearPreGameGRI(WorldInfo.GRI);
	GameResourceDS = GetGameResourceDataStore();

	if ( GameResourceDS != None )
	{
		MatchGameTypeProvider = GetMatchGameTypeDataProvider();

		if ( MatchGameTypeProvider != None )
		{
			GameTypeProvider = GetWinningPlaylistGameTypeProvider();

			SetClientsVersusRichPresenceStrings();

			// Pick the right mapname
			MapName = PGGRI.WinningMapName;
			if (PGGRI.PlayerMatchMapName != "")
			{
			   MapName = PGGRI.PlayerMatchMapName;
			}

			// generate the URL for the travel
			LaunchURL = MapName $ "?Game=" $ MatchGameTypeProvider.ClassName $
				"?GameSettingsId=" $ GameTypeProvider.GameTypeId;

			// Add the training grounds url if needed
			if (bIsTrainingGrounds)
			{
				LaunchURL $= "?bIsTraining";
			}

			//If this is a horde game, we need to get the mutators from the host and append them
			if (MatchGameTypeProvider.MPGameMode == eGEARMP_Horde)
			{
				GLP = GearLocalPlayer(class'Engine'.static.GetEngine().GamePlayers[0]);
				LaunchURL $= GLP.BuildMutatorURLSection(GLP.HordeSelectedMutators);
			}
			WorldInfo.ServerTravel(LaunchURL);
		}
	}
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	GearGRI(GameReplicationInfo).SetGameStatus(GS_Loading);

	Super.ProcessServerTravel(URL, bAbsolute);
}

/** Determines whether this was a custom match or a voting playlist match and returns the proper GameType provider */
function GearGameInfoSummary GetMatchGameTypeDataProvider()
{
	if (IsOfficialMatch() || IsPlayerMatch())
	{
		return GetGameTypeProviderOfWinningPlaylistGameType();
	}
	else
	{
		return GetGameTypeProviderForCustomMatch();
	}
}

/** Returns the provider for the playlist gamemode that won the vote */
function GearGamePlaylistGameTypeProvider GetWinningPlaylistGameTypeProvider()
{
	local GearPreGameGRI PGGRI;

	PGGRI = GearPreGameGRI(WorldInfo.GRI);

	return class'GearUIDataStore_GameResource'.static.GetPlaylistGameTypeProvider(PGGRI.WinningGameIndex);
}

/** Returns the GameType provider for the playlist gamemode that won the vote */
function GearGameInfoSummary GetGameTypeProviderOfWinningPlaylistGameType()
{
	local GearGamePlaylistGameTypeProvider WinningPlaylistGameTypeProvider;
	local GearPreGameGRI PGGRI;

	PGGRI = GearPreGameGRI(WorldInfo.GRI);
	WinningPlaylistGameTypeProvider = class'GearUIDataStore_GameResource'.static.GetPlaylistGameTypeProvider(PGGRI.WinningGameIndex);

	return class'GearUIDataStore_GameResource'.static.GetGameTypeProvider(WinningPlaylistGameTypeProvider.MPGameMode);
}

/** Returns the GameType provider for a custom match */
function GearGameInfoSummary GetGameTypeProviderForCustomMatch()
{
	local GearPreGameGRI PGGRI;

	PGGRI = GearPreGameGRI(WorldInfo.GRI);

	return class'GearUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(PGGRI.WinningGameIndex);
}

/**
 * Wrapper for determining whether all required players are ready to begin the countdown.
 *
 * @return	TRUE if all players are ready to begin the match.
 */
function bool ArePlayersReady()
{
	local int Idx;
	local GearPreGameLobbyPRI LobbyPRI;
	local UniqueNetId ZeroID;

	if (GameReplicationInfo.PRIArray.Length > 0)
	{
		for ( Idx = 0; Idx < GameReplicationInfo.PRIArray.Length; Idx++ )
		{
			LobbyPRI = GearPreGameLobbyPRI(GameReplicationInfo.PRIArray[Idx]);
			if ( IsValidPRI(LobbyPRI) )
			{
				if (!LobbyPRI.bLobbySceneOpened || ((LobbyPRI.UniqueId == ZeroId || LobbyPRI.DLCFlag == -1) && !IsLocalMatch()))
				{
					return false;
				}
			}
		}

		return true;
	}

	//There are no players
	return false;
}

/**
 * If this timer fires, not all players joined fast enough, so start without them
 */
function OnWaitForPlayerTimerExpired()
{
	bWaitForPlayersTimedOut = true;
}

/**
 * Compares the number of connected clients with the number of expected clients
 *
 * @return true if more players are needed to start the match, false otherwise
 */
function bool ArePlayersNeeded()
{
	if (!bWaitForPlayersTimedOut)
	{
		return (GameReplicationInfo.PRIArray.Length == 0) || (GameReplicationInfo.PRIArray.Length < RecentPlayersList.GetCurrentPlayersListCount());
	}
	return false;
}

/*========================================================================================================================================*/
/**
 * Wrapper for getting the maximum team size for the currently selected gametype.
 */
function int GetMaxTeamSize()
{
	// each team can only be as large as the party
	return PartySettings.NumPublicConnections;
}

/*
 * Return whether a team change is allowed.
 */
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	// skip over the partygame version, as it always returns true
	return Super(GearGame).ChangeTeam(Other, N, bNewTeam);
}

function string itos( const out UniqueNetId NetId )
{
	return class'OnlineSubsystem'.static.UniqueNetIdToString(NetId);
}

/**
 * Always returns what is passed in since it assumes teams are already assigned
 *
 * @param Other the controller being assigned a team
 * @param Team the team requested
 */
function int GetForcedTeam(Controller Other, int Team)
{
	return Team;
}

/**
 * Uses the recent players list data to update this player's skill and team
 *
 * @param PC the player needing to be updated
 */
function UpdateTeamAndSkillData(GearPreGamePC PC)
{
	local int TeamNum;
	local int PlayerSkill;
	local UniqueNetId ZeroId;

	if (PC.PlayerReplicationInfo.UniqueId != ZeroId)
	{
		// Get the team the beacon assigned and use that
		TeamNum = RecentPlayersList.GetTeamForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
		ChangeTeam(PC,TeamNum,true);

		// Set the cached skill information so it flows to all clients
		PlayerSkill = RecentPlayersList.GetSkillForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
		GearPRI(PC.PlayerReplicationInfo).PlayerSkill = PlayerSkill;
	}
	else
	{
		// No profile so dump him on team 0
		ChangeTeam(PC,0,true);
	}
}


auto state PendingMatch
{
	/**
	 * Skips arbitration registration if this match isn't arbitrated
	 */
	function StartArbitrationRegistration()
	{
		local OnlineGameSettings GameSettings;

		GameSettings = GameInterface.GetGameSettings('Game');
		if (GameSettings != None)
		{
			// Are we a public match?
			if (GameSettings.bUsesArbitration)
			{
				Super.StartArbitrationRegistration();
			}
			else
			{
				StartOnlineGame();
			}
		}
	}

	/**
	 * Called once the arbitration handshaking is complete. It starts the online
	 * session which shrinks the session to the current arbitrated registrants
	 */
	function StartArbitratedMatch()
	{
		bNeedsEndGameHandshake = true;
		// Start the online game and once started travel to preround
		Super(GameInfo).StartOnlineGame();
	}
}

/**
 * Using the voted for map and game type, updates all clients' rich presence
 */
function SetClientsVersusRichPresenceStrings()
{
	local GearPreGamePC PC;
	local GearUIDataStore_GameResource GameResourceDS;
	local GearPreGameGRI PGGRI;
	local GearGameInfoSummary MatchGameTypeProvider;
	local byte MapNameId;
	local byte MpType;
	local byte StringToUse;
	local OnlineGameSettings GameSettings;
	local int MatchModeIdx;
	local string MapName;

	PGGRI = GearPreGameGRI(WorldInfo.GRI);

	// Pick the right mapname
	MapName = PGGRI.WinningMapName;
	if (PGGRI.PlayerMatchMapName != "")
	{
		MapName = PGGRI.PlayerMatchMapName;
	}

	MapNameId = byte(class'GearLeaderboardSettings'.static.GetMapIdFromName(name(MapName)));

	GameResourceDS = GetGameResourceDataStore();
	if (GameResourceDS != None)
	{
		MatchGameTypeProvider = GetMatchGameTypeDataProvider();

		if (MatchGameTypeProvider != None)
		{
			MpType = MatchGameTypeProvider.MPGameMode;
		}
	}

	GameSettings = GameInterface.GetGameSettings('Game');
	if (GameSettings != None)
	{
		// Default to private match
		StringToUse = CONTEXT_PRESENCE_PRIVATEVERSUSPRESENCE;
		if (GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx))
		{
			// Both ranked and player matches show as public
			if (MatchModeIdx == eGVMT_Official)
			{
				StringToUse = CONTEXT_PRESENCE_VERSUSPRESENCE;
			}
			else if (MatchModeIdx == eGVMT_Player)
			{
				StringToUse = CONTEXT_PRESENCE_PLAYERVERSUSPRESENCE;
			}
		}
	}
	else
	{
		GameSettings = GameInterface.GetGameSettings('Party');
		// Is this a system link match?
		if (GameSettings == None || GameSettings.bIsLanMatch)
		{
			StringToUse = CONTEXT_PRESENCE_SYSTEMLINKVERSUSPRESENCE;
		}
	}

	// Tell each client the presence to use
	foreach WorldInfo.AllControllers(class'GearPreGamePC',PC)
	{
		PC.ClientSetVersusRichPresenceString(StringToUse,MpType,MapNameId);
	}
}

/**
 * Have players register with the object that tracks stats for the post game results, so we can track drops
 */
function InitLastMatchResults()
{
	local GearPC PC;
	local OnlineGameSettings GameSettings;
	local int MatchModeIndex;

	GameSettings = GameInterface.GetGameSettings('Game');

	if (GameSettings != None &&
		GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE,MatchModeIndex))
	{
		foreach WorldInfo.AllControllers(class'GearPC',PC)
		{
			// Clear any players
			PC.ClientInitLastMatchResults(None,bUsingArbitration);
			// Only care about quiting in public matches
			if (GameSettings.bUsesArbitration && MatchModeIndex == eGVMT_Official)
			{
				// Give them one quit and decrement it on match completion
				PC.ClientAdjustQuitCount(1);
			}
		}
	}
}

defaultproperties
{
	// This PRI registers as part of the game session not party one
	PlayerReplicationInfoClass=class'GearGame.GearPreGameLobbyPRI'

	// Specify the standard game PC so voice and recent player's list to work as part of the game session
	PlayerControllerClass=class'GearGame.GearPreGamePC'

	// Need to use a special GRI class to handle the mapvote and loadout counters
	GameReplicationInfoClass=class'GearGame.GearPreGameGRI'

`if(`isdefined(dev_build))
	// allow pausing during development
	bPauseable=true
`endif

	// Pre-game to game uses seamless travel
	bUseSeamlessTravel=true
}
