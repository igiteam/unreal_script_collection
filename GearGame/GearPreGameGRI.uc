/**
 * Specialized game replication info class for the pre-game lobby.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPreGameGRI extends GearGRI;

/************************************************************************/
/* Constants, structures, enums, etc.									*/
/************************************************************************/

/** Enum of the different states in the pre-game lobby */
enum EGearPGLState
{
	eGPGLSTATE_None,
	eGPGLSTATE_Initialize,
	eGPGLSTATE_PreGameSelection,
	eGPGLSTATE_GameSelection,
	eGPGLSTATE_PreCharacterSelect,
	eGPGLSTATE_CharacterSelect,
	eGPGLSTATE_PostCharacterSelect,
	eGPGLSTATE_StartingMatch,
};


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** ----- GAMETYPE SECTION VARIABLES ----- */

/** the number of seconds remaining for clients to vote for a game */
var	byte RemainingGameVoteSeconds;

/** indicates whether game voting is enabled */
var bool bGameVoteEnabled;

/** the indexes for the games the server chose randomly for game voting */
var	byte FirstGameIndex, SecondGameIndex, ThirdGameIndex, RandomGameIndex;

/**
 * if this is a gamemode vote this index is a provider index into the "PlaylistGameTypes" provider list
 * else this is a provider index into the "GameTypes" provider list
 */
var byte WinningGameIndex;

/** the number of votes for each game */
var	repnotify byte FirstGameVoteCount, SecondGameVoteCount, ThirdGameVoteCount;

/** the voters for each game */
var	array<PlayerReplicationInfo> FirstGameVoters, SecondGameVoters, ThirdGameVoters;


/** ----- MAP SECTION VARIABLES ----- */

/** the mapnames for the maps the server chose randomly for map voting */
var	string FirstMapName, SecondMapName, ThirdMapName, RandomMapName;
var string WinningMapName;
var string PlayerMatchMapName;

/** Mapname of the currently selected map in a custom match */
var repnotify string SelectedMapName;

/** The localized map name (for localized map ordering) */
var transient array<string> LocMapNames;

/** The matching map file name */
var transient array<string> MapFileNames;

/** The matching map screenshot paths */
var transient array<string> MapScreenshotPaths;

/** ----- CHARACTER/WEAPON SECTION VARIABLES ----- */

/** the number of seconds remaining for clients to choose their character and weapon */
var	byte RemainingSecondsForLoadoutSelection;

/** Indicates whether the host has pressed start to begin the game brief game countdown */
var repnotify transient bool bHostTriggeredGameStart;

/** ----- OTHER VARIABLES ----- */

/** State of the Pre-game lobby scene */
var	repnotify EGearPGLState PreGameLobbyState;

/** Countdown value */
var int CountdownTime;

/** whether to suspend the countdown during map selection due to a player not having a map during custom game map selection */
var bool bSuspendMapSelection;

/**
 * Whether it is safe to start displaying player information in the playerlist slots
 * NOTE: until this is set to true the UI will display "LOADING" in the player slots
 */
var bool bAllPlayerArePresentForDisplay;

/** Time the GRI initialization was finished initing */
var float TimeOfGRIInitializationForSelections;

/** The number of supported maps for this playlist or the total number of map that everyone in the lobby can play */
var int NumSupportedMaps;

replication
{
	if ( Role == ROLE_Authority && bNetDirty )
		RemainingGameVoteSeconds, FirstGameVoteCount, SecondGameVoteCount, ThirdGameVoteCount,
		RemainingSecondsForLoadoutSelection, PreGameLobbyState,
		FirstGameIndex, SecondGameIndex, ThirdGameIndex, WinningGameIndex, bGameVoteEnabled,
		FirstMapName, SecondMapName, ThirdMapName, WinningMapName, PlayerMatchMapName,
		bAllPlayerArePresentForDisplay, SelectedMapName, bSuspendMapSelection, bHostTriggeredGameStart, NumSupportedMaps;
}

/** Called when any change in the vote count for a game is changed */
delegate OnGameVoteSubmitted();

/** Called when an updated value is received for SelectedMapName */
delegate OnHostSelectedMapChanged();

/** Called when the pre-game lobby state changes */
delegate OnLobbyStateChanged( EGearPGLState NewLobbyState );

/** Called when any of the 3 selection countdowns are changed */
delegate OnSelectionCountdownTick();

/** Called when a host presses start to begin the pregame countdown in an unofficial game */
delegate OnHostStartedPregameCountdown();

/** Called when the GRI wants the lobby to update it's map selection UI */
delegate OnMapSelectionUpdate(bool bMapSelectSuspended);

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

simulated function InitializePreGameSettings()
{
	if ( Role == ROLE_Authority )
	{
		SetLobbyState( eGPGLSTATE_Initialize );
		SetTimer( 2.0f, false, nameof(PlayersConnectingCheck) );
		ResetCountdown();
	}

	bSuspendMapSelection = false;
	bAllPlayerArePresentForDisplay = false;
	FirstGameVoteCount = 0;
	SecondGameVoteCount = 0;
	ThirdGameVoteCount = 0;
	FirstGameVoters.length = 0;
	SecondGameVoters.length = 0;
	ThirdGameVoters.length = 0;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	InitializePreGameSettings();
}

/**
 * Checks to see if the lobby is done initializing the players or not
 */
function PlayersConnectingCheck()
{
	local GearPreGameLobbyGame_Base PreGame;
	if ( Role == ROLE_Authority )
	{
		PreGame = GearPreGameLobbyGame_Base(WorldInfo.Game);
		if ( PreGame.ArePlayersReady() && !PreGame.ArePlayersNeeded() )
		{
			bAllPlayerArePresentForDisplay = true;
		}
		else
		{
			bAllPlayerArePresentForDisplay = false;
			SetTimer( 2.0f, false, nameof(PlayersConnectingCheck) );
		}
	}
}

/** Whether there is a splitscreen player present */
simulated function bool HasSplitscreenPlayer()
{
	return class'UIInteraction'.static.GetPlayerCount() > 1;
}

/** Initializes the GRI */
function InitializeGRI()
{
	if (Role == ROLE_Authority)
	{
		class'GearGameWingman_Base'.static.InitializeWingmanCharacterIndexes(self);
	}
}

`if(`notdefined(FINAL_RELEASE))
/** Loops through all maps returns the first valid and supported map */
static function int GetMapNameFromCommandline(string MapName)
{
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> MapProviders;
	local GearGameMapSummary MapData;
	local int MapIdx;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if (GameResourceDS != None)
	{
		if (GameResourceDS.GetResourceProviders('Maps', MapProviders))
		{
			// Loop through all maps
			for (MapIdx = 0; MapIdx < MapProviders.length; MapIdx++)
			{
				// Get the map provider for this provider index
				MapData = GearGameMapSummary(MapProviders[MapIdx]);
				if (MapData != none && MapData.MapName ~= MapName)
				{
					return MapIdx;
				}
			}
		}
	}
	return INDEX_NONE;
}
`endif

/**
 * Figures out the game(s) to initially select for the match
 */
function InitializeGameSelection( GearMenuPC HostPC )
{
	local int CurrentPlaylistId;
	local int MatchModeIdx;
	local OnlineGameSettings CurrentSettings;
	local int MapSelectModeIdx;

	// Grab the match mode (ranked, social, custom, etc) and force a local match if one can't be found
	CurrentSettings = GearPreGameLobbyGame_Base(WorldInfo.Game).GetPreGameGameSettings();
	if (CurrentSettings == None ||
		!CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx))
	{
		MatchModeIdx = 0;
	}

	// Grab the playlist id from the gamesettings
	if (CurrentSettings == None ||
		!CurrentSettings.GetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTID, CurrentPlaylistId))
	{
		CurrentPlaylistId = 0;
	}

	// See if we are map selecting or map voting
	if (CurrentSettings == None ||
		!CurrentSettings.GetStringSettingValue(`MAP_SELECTION_MODE, MapSelectModeIdx))
	{
		MapSelectModeIdx = 0;
	}

	// Force the vote for ranked and social matches
	if (MatchModeIdx == eGVMT_Official || MatchModeIdx == eGVMT_Player)
	{
		bGameVoteEnabled = true;
	}
	// Determine if we are doing a vote or not using the map selection property from the game settings
	else
	{
		bGameVoteEnabled = (MapSelectModeIdx == eGEARMAPSELECT_VOTE);
	}

	// Determine what we're voting or selecting on
	InitializeGameSelectionInternal(CurrentPlaylistId, MatchModeIdx);
	InitializeMapSelectionInternal(MatchModeIdx);
}

/** Handles figuring out which games to vote on */
function InitializeGameSelectionInternal(int CurrPlaylistId, int MatchModeIdx)
{
	local int GameCount, GameTypeIdx;
    local name ProviderTag;
	local OnlineSubsystem OnlineSub;
	local OnlineGameSettings GameSettings;
	local OnlinePlaylistProvider PlaylistProvider;
	local bool bGameTypeDetermined;

	// Grab the game settings to be used for this match
	GameSettings = GearPreGameLobbyGame_Base(WorldInfo.Game).GetPreGameGameSettings();

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

	// Support local PC non-LIVE match (HACK to allow testing on PC w/o GFWLIVE)
	if (OnlineSub == None || OnlineSub.GameInterface == None)
	{
		MatchModeIdx = eGVMT_Local;
	}

	if (Role == ROLE_Authority &&
		GameSettings != None)
	{
		// Game vote is enabled so we must find the game indexes to vote on,
		// including the game to select if the vote is tied
		if (bGameVoteEnabled)
		{
			// Set the PlaylistId on the GRI
			PlaylistId = CurrPlaylistId;

			// Handle game modes that use playlists (Ranked and Social)
			if (MatchModeIdx == eGVMT_Official || MatchModeIdx == eGVMT_Player)
			{
				// Game type selection handled
				bGameTypeDetermined = true;

				// Grab the playlist providers
				ProviderTag = (MatchModeIdx == eGVMT_Official) ? name(class'UIDataStore_OnlinePlaylists'.const.RANKEDPROVIDERTAG) : name(class'UIDataStore_OnlinePlaylists'.const.UNRANKEDPROVIDERTAG);
				PlaylistProvider = class'UIDataStore_OnlinePlaylists'.static.GetOnlinePlaylistProvider(ProviderTag, CurrPlaylistId);
				if (PlaylistProvider != None)
				{
					// Get the game count
					GameCount = PlaylistProvider.PlaylistGameTypeNames.length;
					if (GameCount > 0)
					{
						// Set first game to the first random number
						FirstGameIndex = Rand(GameCount);

						// Set the second to the next random number
						do
						{
							SecondGameIndex = Rand(GameCount);
						}
						until(SecondGameIndex != FirstGameIndex ||
							  GameCount == 1);


						// Now lets set the third gametype choice
						do
						{
							ThirdGameIndex = Rand(GameCount);
						}
						until((ThirdGameIndex != FirstGameIndex && ThirdGameIndex != SecondGameIndex) ||
							  GameCount <= 2);

						// Now lets set the random gametype choice
						do
						{
							RandomGameIndex = Rand(GameCount);
						}
						until((RandomGameIndex != FirstGameIndex && RandomGameIndex != SecondGameIndex && RandomGameIndex != ThirdGameIndex) ||
							  GameCount <= 3);
					}
					else
					{
						`LogOnline("Game count was 0 for playlist"@CurrPlaylistId);
					}

					// Convert all the name indexes into provider indexes in the "PlaylistGameTypes" provider list
					FirstGameIndex = class'GearUIDataStore_GameResource'.static.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex(PlaylistProvider, FirstGameIndex);
					SecondGameIndex = class'GearUIDataStore_GameResource'.static.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex(PlaylistProvider, SecondGameIndex);
					ThirdGameIndex = class'GearUIDataStore_GameResource'.static.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex(PlaylistProvider, ThirdGameIndex);
					RandomGameIndex = class'GearUIDataStore_GameResource'.static.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex(PlaylistProvider, RandomGameIndex);

					`LogOnline("Game being voted on: First:"$FirstGameIndex@"Second:"$SecondGameIndex@"Third:"$ThirdGameIndex@"Random:"$RandomGameIndex);
				}
			}
		}

		// No map vote so just set the currently selected map
		if (!bGameTypeDetermined)
		{
			if (GameSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES, GameTypeIdx))
			{
				// Convert the Game enum into a provider index
				GameTypeIdx = class'GearUIDataStore_GameResource'.static.GetGameTypeProviderIndex( EGearMPTypes(GameTypeIdx) );
				if (GameTypeIdx != INDEX_NONE)
				{
					FirstGameIndex = GameTypeIdx;
					SecondGameIndex = GameTypeIdx;
					ThirdGameIndex = GameTypeIdx;
					RandomGameIndex = GameTypeIdx;
				}
			}
			else
			{
				`LogOnline("Gametype was not to be voted and wasn't ranked or social, and failed looking in the game settings object!");
			}
		}
	}
}

/** Figures out the map(s) to initially select for the match */
function InitializeMapSelectionInternal(int MatchModeIdx)
{
	local GearUIDataStore_GameResource GameResourceDS;
	local int CurrPlaylistId;
	local OnlineGameSettings GameSettings;
	local OnlineSubsystem OnlineSub;
	local int FirstMapIndex, SecondMapIndex, ThirdMapIndex, RandomMapIndex;
	local int NumTotalMaps;
`if(`notdefined(FINAL_RELEASE))
	local string MapName;
`endif

// Grab the game settings to be used for this match
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		GameSettings = GearPreGameLobbyGame_Base(WorldInfo.Game).GetPreGameGameSettings();
	}
	// Support local PC non-LIVE match (HACK to allow testing on PC w/o GFWLIVE)
	else if (!class'WorldInfo'.static.IsConsoleBuild())
	{
		GameSettings = GearPreGameLobbyGame_Base(WorldInfo.Game).GetPreGameGameSettings();
	}

	if (GameSettings != None)
	{
		GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
		if (GameResourceDS != None)
		{
			// Sort the maps by name
			RefreshAlphabeticalMapNames();

			// Map vote is enabled so we must find the map indexes to vote on,
			// including the map to select if the vote is tied
			if (bGameVoteEnabled)
			{
				// Get the CurrPlaylistId for the game, -1 will mean that we are not using a playlist
				CurrPlaylistId = (MatchModeIdx != eGVMT_Official && MatchModeIdx != eGVMT_Player) ? -1 : PlaylistId;

				// Get the number of supported maps for this playlist
				NumSupportedMaps = GetNumberOfSupportedMapsForPlaylist(CurrPlaylistId);

				// Get the total number of maps the host has
				NumTotalMaps = GameResourceDS.GetProviderCount('Maps');

				// Set first map to the first random number that is valid
				do
				{
					FirstMapIndex = CheckMapAgainstPlaylist(Rand(NumTotalMaps), CurrPlaylistId);
				}
				until(FirstMapIndex != INDEX_NONE ||
					  NumSupportedMaps <= 0);
				// If we were unsuccessful, just grab the first one
				if (FirstMapIndex == INDEX_NONE)
				{
					FirstMapIndex = GetFirstSupportedMapsForPlaylist(CurrPlaylistId);
				}

				// Set the second to the next valid random number
				do
				{
					SecondMapIndex = CheckMapAgainstPlaylist(Rand(NumTotalMaps), CurrPlaylistId);
				}
				until((SecondMapIndex != INDEX_NONE && SecondMapIndex != FirstMapIndex) ||
					  NumSupportedMaps <= 1);
				// If we were unsuccessful, just grab the first one
				if (SecondMapIndex == INDEX_NONE)
				{
					SecondMapIndex = GetFirstSupportedMapsForPlaylist(CurrPlaylistId);
				}

				// Now lets set the third map choice
				do
				{
					ThirdMapIndex = CheckMapAgainstPlaylist(Rand(NumTotalMaps), CurrPlaylistId);
				}
				until((ThirdMapIndex != INDEX_NONE && ThirdMapIndex != FirstMapIndex && ThirdMapIndex != SecondMapIndex) ||
					NumSupportedMaps <= 2);
				// If we were unsuccessful, just grab the first one
				if (ThirdMapIndex == INDEX_NONE)
				{
					ThirdMapIndex = GetFirstSupportedMapsForPlaylist(CurrPlaylistId);
				}

				// Now lets set the random map choice
				do
				{
					RandomMapIndex = CheckMapAgainstPlaylist(Rand(NumTotalMaps), CurrPlaylistId);
				}
				until((RandomMapIndex != INDEX_NONE && RandomMapIndex != FirstMapIndex && RandomMapIndex != SecondMapIndex && RandomMapIndex != ThirdMapIndex) ||
					  NumSupportedMaps <= 3);
				// If we were unsuccessful, just grab the first one
				if (RandomMapIndex == INDEX_NONE)
				{
					RandomMapIndex = GetFirstSupportedMapsForPlaylist(CurrPlaylistId);
				}

				// Grab the map names
				FirstMapName = GameResourceDS.GetMapNameUsingProviderIndex(FirstMapIndex);
				SecondMapName = GameResourceDS.GetMapNameUsingProviderIndex(SecondMapIndex);
				ThirdMapName = GameResourceDS.GetMapNameUsingProviderIndex(ThirdMapIndex);
				RandomMapName = GameResourceDS.GetMapNameUsingProviderIndex(RandomMapIndex);

				// Force the game and map in social matches
				if (MatchModeIdx == eGVMT_Player)
				{
					switch (Rand(3))
					{
						case 0:
							WinningGameIndex = FirstGameIndex;
							SelectedMapName = FirstMapName;
							break;
						case 1:
							WinningGameIndex = SecondGameIndex;
							SelectedMapName = SecondMapName;
							break;
						case 2:
							WinningGameIndex = ThirdGameIndex;
							SelectedMapName = ThirdMapName;
							break;
					}

					bGameVoteEnabled = false;
				}
			}
			// No map vote so just set the currently selected map
			else
			{
				SelectedMapName = MapNameFromAlphabeticalIndex(0);
			}
		}
	}

`if(`notdefined(FINAL_RELEASE))
	//Allow QA to override the map played
	if (GearGame(WorldInfo.Game) != None &&
		GearGame(WorldInfo.Game).GetMapNameOverride(MapName) &&
		GetMapNameFromCommandline(MapName) != INDEX_NONE)
	{
		FirstMapName = MapName;
		SecondMapName = MapName;
		ThirdMapName = MapName;
		RandomMapName = MapName;

		if (!GearGame(WorldInfo.Game).bUsingArbitration)
		{
			SelectedMapName = MapName;
		}

		`LogOnline("QA Map Override to"@MapName);
	}
`endif

	bForceNetUpdate = TRUE;
}

/** In host select mode the host has chosen a map */
function SubmitHostFinishedMapSelection()
{
	if (PreGameLobbyState == eGPGLSTATE_GameSelection)
	{
		if (Role == ROLE_Authority && !bGameVoteEnabled)
		{
			CalculateGameWinner();
			SetLobbyState( EGearPGLState(PreGameLobbyState + 1) );
		}
	}
}

/**
 * Sets a new selected map by name instead of moving the index
 *
 * @param MapName Name of the map to set as the new selected map
 */
function bool SubmitMapSelectionByName(string MapName)
{
	if( MapName != SelectedMapName )
	{
		// Map has changed, so updated it, and call appropriate functions
		SelectedMapName = MapName;
		bSuspendMapSelection = PlayersLackRequiredDLC( SelectedMapName, true );
		OnHostSelectedMapChanged();
		ResetCountdown();
		return true;
	}

	return FALSE;
}

/** Will attempt to change the player's team, and will mark him as wanting to change teams if not possible */
function RequestChangeTeam( GearPreGameLobbyPRI PlayerPRI, int NumPlayersPerTeam )
{
	local int TeamIdx, TeamIndexToCheck, PRIIdx, NewPlayerTeam, NewOtherTeam;
	local GearPreGameLobbyPRI CurrPRI;
	local GearPreGameLobbyGame_Base PreGame;
	local GearMenuPC GMPC;

	if ( PlayerPRI.bRequestedTeamChange || bHostTriggeredGameStart )
	{
		PlayerPRI.bRequestedTeamChange = false;
	}
	else
	{
		PreGame = GearPreGameLobbyGame_Base(WorldInfo.Game);

		// First see if someone else is requesting a change from another team
		for ( PRIIdx = 0; PRIIdx < PRIArray.length; PRIIdx++ )
		{
			CurrPRI = GearPreGameLobbyPRI(PRIArray[PRIIdx]);
			if ( CurrPRI != None &&
				 CurrPRI != PlayerPRI &&
				 !CurrPRI.bIsInactive &&
				 CurrPRI.bRequestedTeamChange &&
				 CurrPRI.GetTeamNum() != PlayerPRI.GetTeamNum() )
			{
				NewPlayerTeam = CurrPRI.GetTeamNum();
				NewOtherTeam = PlayerPRI.GetTeamNum();
				if ( NewPlayerTeam != 255 && NewOtherTeam != 255 )
				{
					// Swap teams
					if ( PreGame.ChangeTeam( Controller(PlayerPRI.Owner), NewPlayerTeam, true ) &&
						 PreGame.ChangeTeam( Controller(CurrPRI.Owner), NewOtherTeam, true ) )
					{
						CurrPRI.bRequestedTeamChange = false;
						PlayerPRI.bRequestedTeamChange = false;
						foreach WorldInfo.AllControllers(class'GearMenuPC', GMPC)
						{
							GMPC.ClientTeamChangeOccuredCallback(CurrPRI, PlayerPRI);
						}
						return;
					}
				}
			}
		}

		// Next see if we can just move to a team with an empty slot
		TeamIndexToCheck = PlayerPRI.GetTeamNum();
		TeamIndexToCheck = (TeamIndexToCheck + 1) % Teams.length;
		for ( TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++ )
		{
			if ( (TeamIndexToCheck != PlayerPRI.GetTeamNum()) && (Teams[TeamIndexToCheck].Size < NumPlayersPerTeam) )
			{
				PreGame.ChangeTeam( Controller(PlayerPRI.Owner), TeamIndexToCheck, true );

				foreach WorldInfo.AllControllers(class'GearMenuPC', GMPC)
				{
					GMPC.ClientTeamChangeOccuredCallback(PlayerPRI, None);
				}
				return;
			}
			else
			{
				TeamIndexToCheck = (TeamIndexToCheck + 1) % Teams.length;
			}
		}

		// Didn't find a team to change to so mark him as wanting to change
		PlayerPRI.bRequestedTeamChange = true;
	}
}

/**
 * Submits the player's vote for a game.
 *
 * @param	PRI		the PRI for the player submitting the vote
 * @param	GameIndex	0 to vote for the first game, 1 to vote for the second game.
 *
 * @return	TRUE if the vote was successfully submitted.
 */
function bool SubmitGameVote(PlayerReplicationInfo PRI, int GameIndex)
{
	local GearPreGameLobbyPRI PGPRI;
	local bool bSuccess;

	// If we are still voting on the game
	PGPRI = GearPreGameLobbyPRI(PRI);
	if (PGPRI != None &&
		PreGameLobbyState == eGPGLSTATE_GameSelection)
	{
		// See if this PRI has already voted
		if (FirstGameVoters.Find(PGPRI) == INDEX_NONE &&
			SecondGameVoters.Find(PGPRI) == INDEX_NONE &&
			ThirdGameVoters.Find(PGPRI) == INDEX_NONE)
		{
			switch (GameIndex)
			{
				// Voted for first game
				case 0:
					FirstGameVoters.AddItem(PGPRI);
					FirstGameVoteCount = FirstGameVoters.Length;
					OnGameVoteSubmitted();
					bSuccess = true;
					break;
				// Voted for second game
				case 1:
					SecondGameVoters.AddItem(PGPRI);
					SecondGameVoteCount = SecondGameVoters.Length;
					OnGameVoteSubmitted();
					bSuccess = true;
					break;
				// Voted for third game
				case 2:
					ThirdGameVoters.AddItem(PGPRI);
					ThirdGameVoteCount = ThirdGameVoters.Length;
					OnGameVoteSubmitted();
					bSuccess = true;
					break;
			}
		}

		// See if the submitted game vote should end the voting (host only)
		if (Role == ROLE_Authority && bGameVoteEnabled)
		{
			CheckForGameVoteStop();
		}
	}

	return bSuccess;
}

/**
 * Removes a player's vote for a game.
 *
 * @param	PRI		the PRI for the player that removed the vote.
 *
 * @return	TRUE if the vote was removed.
 */
simulated function bool RemoveGameVote( PlayerReplicationInfo PRI )
{
	if(PreGameLobbyState == eGPGLSTATE_GameSelection)
	{
		// Remove the PRI from the list of voters
		FirstGameVoters.RemoveItem(PRI);
		SecondGameVoters.RemoveItem(PRI);
		ThirdGameVoters.RemoveItem(PRI);

		// Reset the vote counts
		FirstGameVoteCount = FirstGameVoters.Length;
		SecondGameVoteCount = SecondGameVoters.Length;
		ThirdGameVoteCount = SecondGameVoters.Length;

		// Check for vote stoppage and submit delegate if this is the host
		if (Role == ROLE_Authority && bGameVoteEnabled)
		{
			OnGameVoteSubmitted();
			// See if the removal of a game vote should end the voting
			CheckForGameVoteStop();
		}

		return true;
	}

	return false;
}

// See if the submitted game vote should end the voting
function CheckForGameVoteStop()
{
	local int PRIIdx, PRICount;
	local PlayerReplicationInfo CurrPRI;
	local int RemainingVotes;

	// Count up the PRIs
	for (PRIIdx = 0; PRIIdx < PRIArray.length; PRIIdx++)
	{
		CurrPRI = PRIArray[PRIIdx];
		if (CurrPRI != None && !CurrPRI.bIsInactive && !CurrPRI.bBot)
		{
			PRICount++;
		}
	}

	// See if we have a winner yet
	RemainingVotes = PRICount - (FirstGameVoteCount + SecondGameVoteCount + ThirdGameVoteCount);
	if (RemainingVotes <= 0 ||
		(FirstGameVoteCount > SecondGameVoteCount + RemainingVotes &&
		 FirstGameVoteCount > ThirdGameVoteCount + RemainingVotes) ||
		(SecondGameVoteCount > FirstGameVoteCount + RemainingVotes &&
		 SecondGameVoteCount > ThirdGameVoteCount + RemainingVotes) ||
		(ThirdGameVoteCount > FirstGameVoteCount + RemainingVotes &&
		 ThirdGameVoteCount > SecondGameVoteCount + RemainingVotes))
	{
		CalculateGameWinner();
		SetLobbyState( EGearPGLState(PreGameLobbyState+1) );
	}
}


/** Select game vote winner */
function CalculateGameWinner()
{
	// Was a game vote scenario
	if (bGameVoteEnabled)
	{
		// See if first game won
		if (FirstGameVoteCount > SecondGameVoteCount &&
			FirstGameVoteCount > ThirdGameVoteCount)
		{
			WinningGameIndex = FirstGameIndex;
			WinningMapName = FirstMapName;
		}
		// See if second game won
		else if (SecondGameVoteCount > FirstGameVoteCount &&
				 SecondGameVoteCount > ThirdGameVoteCount)
		{
			WinningGameIndex = SecondGameIndex;
			WinningMapName = SecondMapName;
		}
		// See if third game won
		else if (ThirdGameVoteCount > FirstGameVoteCount &&
				 ThirdGameVoteCount > SecondGameVoteCount)
		{
			WinningGameIndex = ThirdGameIndex;
			WinningMapName = ThirdMapName;
		}
		// No game won, so go to a random game
		else
		{
			WinningGameIndex = RandomGameIndex;
			WinningMapName = RandomMapName;
		}
	}
	// No voting so choose the first game and the selected map
	else
	{
		WinningGameIndex = FirstGameIndex;
		WinningMapName = SelectedMapName;
	}
}

/**
 * Determines whether all players have successfully connected and opened their lobby scene.
 *
 * @return	TRUE if all players have their lobby scene open.
 */
function bool LobbyIsFinishedInitializing()
{
	local GearPreGameLobbyGame_Base LobbyGame;
	local bool bResult;
	local int MatchModeIdx;
	local OnlineGameSettings CurrentSettings;

	LobbyGame = GearPreGameLobbyGame_Base(WorldInfo.Game);
	if (LobbyGame != None)
	{
		bResult = LobbyGame.CanStartMatch();
		// Initialize the GRI data if we are ready to start
		if (bResult && TimeOfGRIInitializationForSelections < 0)
		{
			if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				InitializeGRI();
				TimeOfGRIInitializationForSelections = WorldInfo.TimeSeconds;
			}
			else
			{
				// Grab the match mode (ranked, social, custom, etc) and force a local match if one can't be found
				CurrentSettings = GearPreGameLobbyGame_Base(WorldInfo.Game).GetPreGameGameSettings();
				if (CurrentSettings == None ||
					!CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx))
				{
					MatchModeIdx = 0;
				}
				// Set variables appropriate for the dedicated server to force map vote and to have the correct match mode
				bGameVoteEnabled = true;
				InitializeGameSelectionInternal(PlaylistId, MatchModeIdx);
				InitializeMapSelectionInternal(MatchModeIdx);
				class'GearGameWingman_Base'.static.InitializeWingmanCharacterIndexes(self);
				TimeOfGRIInitializationForSelections = WorldInfo.TimeSeconds;
			}
		}
	}

	return bResult;
}

/** Returns whether this is a local player in a local match or not */
simulated function bool IsLocalPlayerInLocalMatch()
{
	local OnlineGameSettings CurrentSettings;
	local int MatchMode;

	if (Role == ROLE_Authority)
	{
		CurrentSettings = GearPreGameLobbyGame_Base(WorldInfo.Game).GetPreGameGameSettings();
		if (CurrentSettings != None &&
			CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchMode) &&
			MatchMode == eGVMT_Local)
		{
			return true;
		}
	}
	return false;
}

/** Takes a snapshot of players as soon as they've been replicated */
function RecordPlayersForDrops()
{
	local GearPreGameLobbyGame_Base LobbyGame;

	LobbyGame = GearPreGameLobbyGame_Base(WorldInfo.Game);
	if (LobbyGame != None)
	{
		// Tell all players about each other for drop detection
		LobbyGame.InitLastMatchResults();
	}
}

/** Reset countdown function */
function ResetCountdown()
{
	switch (PreGameLobbyState)
	{
		case eGPGLSTATE_Initialize:
		case eGPGLSTATE_PreGameSelection:
		case eGPGLSTATE_PreCharacterSelect:
		case eGPGLSTATE_PostCharacterSelect:
			CountdownTime = 1;
			break;
		case eGPGLSTATE_GameSelection:
			CountdownTime = default.RemainingGameVoteSeconds;
			RemainingGameVoteSeconds = default.RemainingGameVoteSeconds;
			break;
		case eGPGLSTATE_CharacterSelect:
			CountdownTime = default.RemainingSecondsForLoadoutSelection;
			RemainingSecondsForLoadoutSelection = default.RemainingSecondsForLoadoutSelection;
			break;
	}

	SetTimer(1.0f, true, nameof(UpdateCountdowns));
}

/** Decrement the remaining seconds */
function UpdateCountdowns()
{
	local EGearPGLState NextState;
	local int MatchModeIdx;
	local OnlineGameSettings CurrentSettings;

	if (Role == ROLE_Authority)
	{
		NextState = eGPGLSTATE_None;
		// If the countdown has been suspended (host map selection), reset the countdown
		if (!bSuspendMapSelection && bAllPlayerArePresentForDisplay)
		{
			CountdownTime--;
		}

		// Determine if it's time to move to the next lobby state
		switch (PreGameLobbyState)
		{
			// Initialization state
			case eGPGLSTATE_Initialize:
				if (CountdownTime <= 0)
				{
					// See if it's time to move past initialization
					if (LobbyIsFinishedInitializing() &&
						WorldInfo.TimeSeconds - TimeOfGRIInitializationForSelections > 1.f)
					{
						// If this is a social match we skip to character selection
						CurrentSettings = GearPreGameLobbyGame_Base(WorldInfo.Game).PreGameGameSettings;
						if (CurrentSettings != None &&
							CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx) &&
							MatchModeIdx == eGVMT_Player)
						{
							// Replicate selected information to clients
							PlayerMatchMapName = SelectedMapName;
							NextState = eGPGLSTATE_CharacterSelect;
						}
						// Else move to game selection
						else
						{
							NextState = eGPGLSTATE_GameSelection;
						}
						// Cache players for drop detection
						RecordPlayersForDrops();
						// Start arbitration handshaking on the game
						StartArbitration();
					}
					else
					{
						ResetCountdown();
					}
				}
				break;

			// Handle game selection
			case eGPGLSTATE_GameSelection:
				// Decrement game vote counter
				RemainingGameVoteSeconds = max(0, RemainingGameVoteSeconds-1);

				// Suspend the countdown if a player doesn't have the selected map
				if (PlayersLackRequiredDLC(SelectedMapName, true))
				{
					if (!bSuspendMapSelection)
					{
						bSuspendMapSelection = true;
						OnMapSelectionUpdate(true);
					}
				}
				// Yeah, players have the map
				else
				{
					// No voting so reset the countdown
					if (!bGameVoteEnabled)
					{
						ResetCountdown();
					}

					// We are no longer suspending the countdown (host must've switched map to one everyone has)
					if (bSuspendMapSelection)
					{
						bSuspendMapSelection = false;
						OnMapSelectionUpdate(false);
					}
				}

				// Give clients an extra couple seconds when voting/selecting since they'll be a second or two behind the server
				if (CountdownTime <= -2)
				{
					CalculateGameWinner();
					NextState = EGearPGLState(PreGameLobbyState + 1);
				}
				break;

			// Transition state between game/map selection and character selection
			case eGPGLSTATE_PreCharacterSelect:
				if (CountdownTime <= 0)
				{
					NextState = EGearPGLState(PreGameLobbyState + 1);
				}
				break;

			// Handle character selection
			case eGPGLSTATE_CharacterSelect:
				// Decrement countdown for selection character prefs
				RemainingSecondsForLoadoutSelection = max(0, RemainingSecondsForLoadoutSelection-1);

				// Give clients an extra couple seconds when voting/selecting since they'll be a second or two behind the server
				if (CountdownTime <= -2)
				{
					NextState = EGearPGLState(PreGameLobbyState + 1);
				}

				// Only advance if this is a public match, host must press START to advance non-public matches
				if (!bGameVoteEnabled && !bHostTriggeredGameStart)
				{
					ResetCountdown();
				}

				break;

			// Transition states to put some space between states
			case eGPGLSTATE_PreGameSelection:
			case eGPGLSTATE_PostCharacterSelect:
				if (CountdownTime <= 0)
				{
					NextState = EGearPGLState(PreGameLobbyState + 1);
				}
				break;
		}

		// Have host set the new state
		if (Role == ROLE_Authority && NextState != eGPGLSTATE_None)
		{
			SetLobbyState(NextState);
		}

		bForceNetUpdate = true;
	}
}

/** Set the lobby state and reset the counter */
function SetLobbyState( EGearPGLState NewState )
{
	// Check to see if we're in an invalid state for any of the gametypes.  Since you can't select a character in Siege, just skip these states
	if( (NewState >= eGPGLSTATE_PreCharacterSelect) && (NewState <= eGPGLSTATE_PostCharacterSelect) )
	{
		// If this is siege, skip directly to the game!
		if( class'GearGFxMoviePlayer'.static.IsSiegeGametype(self) )
		{
			NewState = eGPGLSTATE_StartingMatch;
		}
	}

	PreGameLobbyState = NewState;
	OnLobbyStateChanged( NewState );
	ResetCountdown();

	if (Role == ROLE_Authority)
	{
		if (PreGameLobbyState == eGPGLSTATE_StartingMatch)
		{
			GearPreGameLobbyGame_Base(WorldInfo.Game).BeginMatch();
		}
	}
}

/**
 * Whether any players do not have the required DLCs needed for the selected map or not
 *
 * @param MapName - the name of the map we are checking for content on
 * @param bUseStrictCheck - used when proper replication has not taken place yet
 *		(this is useful for when you MUST know if the player has DLC, for normal user feedback we won't care about
 *		 this but for a button click that will require a proper check, we must use it)
 */
function bool PlayersLackRequiredDLC( string MapName, optional bool bUseStrictCheck )
{
	local int DLCTest, PRIIdx;
	local GearGameMapSummary MapData;
	local GearPRI PlayerPRI;


	// Testing against both vote enabled flags lets us know that this is a custom match where the host selects the map
	if (!bGameVoteEnabled)
	{
		MapData = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName( MapName );
		if ( MapData != None )
		{
			if ( MapData.DLCId > 0 )
			{
				for ( PRIIdx = 0; PRIIdx < PRIArray.length; PRIIdx++ )
				{
					PlayerPRI = GearPRI(PRIArray[PRIIdx]);
					if ( PlayerPRI != None && !PlayerPRI.bIsInactive )
					{
						if ( bUseStrictCheck && PlayerPRI.DLCFlag == -1 )
						{
							return true;
						}
						else
						{
							DLCTest = PlayerPRI.DLCFlag >> MapData.DLCId;
							if ( DLCTest % 2 != 1 )
							{
								return true;
							}
						}
					}
				}
			}
		}
	}

	return false;
}

/**
 * Called when a player joins the game.  Resets the countdown timers to give everyone a chance to vote.
 */
simulated function AddPRI(PlayerReplicationInfo PRI)
{
	Super.AddPRI(PRI);

	// Determine whether it should go in the active or inactive list
	if (Role == ROLE_Authority && !PRI.bIsInactive)
	{
		ResetCountdown();
	}
}

/**
 * Called when a player leaves the game.  Removes that player's vote, if applicable.
 *
 * @param	PRI		the player that left.
 */
simulated function RemovePRI( PlayerReplicationInfo PRI )
{
	Super.RemovePRI(PRI);

	RemoveGameVote(PRI);
}

/**
 * Called when a variable is replicated that has the 'repnotify' keyword.
 *
 * @param	VarName		the name of the variable that was replicated.
 */
simulated event ReplicatedEvent( name VarName )
{
	switch (VarName)
	{
		case nameof(PreGameLobbyState):
			OnLobbyStateChanged(PreGameLobbyState);
			break;
		case nameof(SelectedMapName):
			OnHostSelectedMapChanged();
			break;
		case nameof(bHostTriggeredGameStart):
			OnHostStartedPregameCountdown();
			break;
		case nameof(FirstGameVoteCount):
		case nameof(SecondGameVoteCount):
		case nameof(ThirdGameVoteCount):
			OnGameVoteSubmitted();
			break;
		default:
			Super.ReplicatedEvent(VarName);
			break;
	}
}

/**
 * Called once the game has decided that it is time to start voting (all players present)
 */
function StartArbitration()
{
	local GearPreGameLobbyGame_Base LobbyGame;

	LobbyGame = GearPreGameLobbyGame_Base(WorldInfo.Game);
	if (LobbyGame != None)
	{
		// Tells all of the players to register for arbitration
		LobbyGame.StartArbitrationRegistration();
	}
}

/**
 * Update the cached map names from the datastore.
 *
 */
function RefreshAlphabeticalMapNames()
{
	local GearUIDataStore_GameResource GameResourceDS;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if ( GameResourceDS != None )
	{
		BuildSortedMapList(GameResourceDS, LocMapNames, MapFileNames, MapScreenshotPaths);
	}
}

/**
 * Build an alphabetically sorted list of map names with an associated list of real map names (e.g. localized: BloodBank vs. MP_BloodBank)
 *
 * @param GameResourceDS	Resource DataStore which contains the map information
 * @param out_LocMapNames	Names of maps available to player in alphabetical order
 * @param out_MapFileNames	Corresponding list of map filenames
 * @param out_MapScreenshots    List of paths to the screenshots for each map
 */
private function BuildSortedMapList( GearUIDataStore_GameResource GameResourceDS, out array<string> out_LocMapNames, out array<string> out_MapFileNames, out array<string> out_MapScreenshots )
{
	local UIProviderScriptFieldValue GameResourceData;
	local array<UIResourceDataProvider> MapProviders;
	local string TempMapName;
	local int MapIdx;
	local int MapIdx2;

	// Empty the output; by default we find no maps
	out_LocMapNames.Length = 0;
	out_MapFileNames.Length = 0;
	out_MapScreenshots.Length = 0;

	GameResourceDS.GetResourceProviders('Maps', MapProviders);

	if (MapProviders.Length > 0)
	{
		// Get the maps
		for ( MapIdx = 0; MapIdx < MapProviders.Length; ++MapIdx )
		{
			if ( GameResourceDS.GetProviderFieldValue('Maps', 'DisplayName', MapIdx, GameResourceData) )
			{
				out_LocMapNames.AddItem( GameResourceData.StringValue );
				out_MapFileNames.AddItem( GearGameMapSummary(MapProviders[MapIdx]).MapName );
				out_MapScreenshots.AddItem( GearGameMapSummary(MapProviders[MapIdx]).ScreenshotPathName );
			}
		}

		// Sort the maps... with bubblesort :(
		for ( MapIdx = 0; MapIdx < MapProviders.Length; ++MapIdx )
		{
			for ( MapIdx2 = 0; MapIdx2 < MapProviders.Length; ++MapIdx2 )
			{
				if (out_LocMapNames[MapIdx] < out_LocMapNames[MapIdx2])
				{
					TempMapName = out_LocMapNames[MapIdx2];
					out_LocMapNames[MapIdx2] = out_LocMapNames[MapIdx];
					out_LocMapNames[MapIdx] = TempMapName;

					TempMapName = out_MapFileNames[MapIdx2];
					out_MapFileNames[MapIdx2] = out_MapFileNames[MapIdx];
					out_MapFileNames[MapIdx] = TempMapName;

					TempMapName = out_MapScreenshots[MapIdx2];
					out_MapScreenshots[MapIdx2] = out_MapScreenshots[MapIdx];
					out_MapScreenshots[MapIdx] = TempMapName;
				}
			}
		}
	}
}

/**
 * Get map name based on map index
 *
 * @param MapName	The name of the map (real name; e.g. MP_BloodSomething)
 *
 * @return Index of map in the list
 */
function int AlphabeticalIndexFromMapName(string MapName)
{
	return MapFileNames.Find(MapName);
}

/**
 * Get map name based on map index
 *
 * @param MapIndex	The index of the map in the list
 *
 * @return Map Name
 */
function string MapNameFromAlphabeticalIndex(int MapIndex)
{
	if (MapIndex >= 0 && MapIndex < MapFileNames.Length && MapFileNames.Length > 0)
	{
		return MapFileNames[MapIndex];
	}
	else
	{
		return "";
	}
}

/** Called once arbitration completes and starts the match. Just ignores the call */
simulated function StartMatch()
{
	// Eats the call intentionally
}

DefaultProperties
{
	RemainingSecondsForLoadoutSelection=10
	RemainingGameVoteSeconds=15
	TimeOfGRIInitializationForSelections=-1

	FirstGameIndex=255
	SecondGameIndex=255
	WinningGameIndex=255

	bGameVoteEnabled=true
}

