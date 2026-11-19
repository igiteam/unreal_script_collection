/**
 * This is our base class for MP games.  It has a bunch of functions that are used
 * through out all of our MP game types.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameMP_Base extends GearGame
	native
	abstract
	config(Game);

`define GAMEINFO(dummy)
`include(GearGame\GearStats.uci);
`undefine(GAMEINFO)
`include(GearPlayerPersistentDataConstants.uci)

/** Class reference to a class containing shared content needed for a gametype (some cases it's just so content is cooked) */
var class<GearMPResources_Base> MPResourceClass;

/** Game Replication Information reference so we don't have to call a function every time we want to use it */
var GearGRI_MP GearGRI;

/** How long before the game to wait for players entering.  If this is a listen server, this value is ignored and
the host starts the match */
var config int AutoStartDelay;

/** How long to delay after the host begins the match */
var config int HostStartDelay;

/** How long is a single round */
var config int RoundDuration;

/** How long to wait after a round before the next one begins */
var config int EndOfRoundDelay;

/** Delay before transitioning to next game */
var config int EndOfGameDelay;

/**
 * Delay to initialize the last match results so that map cycling followed by quitting will
 * still display the last complete results when viewing in the post game stats
 * NOTE: Only used in first round of non-ranked matches
 * NOTE: This delay is added to the HostStartDelay so that we can correctly determine that this
 * value is relative to when the match actually begins
 */
var config int ClearLastMatchResultsDelay;

/** How long is the bleed out */
var config int InitialRevivalTime;

/** Is the dedicated server ready? */
var bool bIsServerReady;

/** This is the first round so we want to wait some extra time to allow everyone to join **/
var() bool bFirstRound;

/** Time when the first player joined */
var float FirstPlayerJoinTime;

/** Player got the first kill of the round */
var Controller FirstKill;
/** Stores off the controller of the last killer **/
var Controller LastKiller;
/** Stores off the controller of the last victim */
var Controller LastVictim;
/** Stores execution of the last victim */
var bool bWasLastVictimExecution;

/** Whether or not a player will auto revive on bleed out or if they will die **/
var config bool bAutoReviveOnBleedOut;

/** Whether or not a player can been shot and killed while down but not out **/
var config bool bCanBeShotFromAfarAndKilledWhileDownButNotOut;

/** Whether to allow dead people to talk to living */
var config bool bDeadCanTalkToLiving;

/** the GearTeamPlayerStart TeamIndex that each team is using for this round */
var array<int> TeamPlayerStartIndex;
/** max GearTeamPlayerStart index */
var int MaxPlayerStartTeamIndex;
/** The class of the GearTeamPlayerStart that this game type uses */
var class<GearTeamPlayerStart> GearPlayerStartClass;

/** value to assign 'MaxDownCount' for GearPawns, -1 means don't override */
var config int MaxDownCountOverride;

/** [AI] for AI names */
var localized string AIPostfix;
/** Drone_ for AI names */
var localized string AIPrefix;

/** Whether to spawn any pawns from GearPawnFactory in the level or not */
var config bool bUsePawnFactories;

/** Voice channels used by these game types */
enum EVoiceChannel
{
	VC_SpectatorsDead,
	VC_Team1,
	VC_Team2,
	VC_Team3,
	VC_Team4,
	VC_Team5
};

/** whether we are in system link, so don't clamp client update rate, etc */
var bool bIsSystemLink;

/** Whether to use weapon swapping in this game or not */
var bool bUsingWeaponSwap;
/** Whether to cycle weapons or not */
var bool bUsingWeaponCycle;

/** Final kill has happened - don't score any kills between now and end of round */
var bool bLastKillerSet;

/** Number of bots requested to play the game */
var int RequestedBots;

/** Is the player in tourist mode? */
var bool bTourist;

/** Is the game in developper mode? Options for easy testing/debugging */
var bool	bInDevMode;

/** Size of radius to do radius check against same drop type with generic weapons - 0 means they don't check */
var config float WeaponDropRadiusCheckGeneric;
/** Size of radius to do radius check against same drop type with special weapons - 0 means they don't check */
var config float WeaponDropRadiusCheckSpecial;

/** whether we should start the game immediately without waiting for the host to press Start */
var bool bQuickStart;

/** Whether this game type is playing by execution rules or not */
var bool bExecutionRules;
/** ini-driven override to force execution */
var config bool bConfigForceExecution;

/** whether teams score a point for winning a round */
var bool bScoreRoundWin;

/** this is used to give bots unique names */
var int BotIndex;
/** if set, bots always go on team 1 and players on team 0 - @note: ONLY WORKS IN GAMETYPES WITH TWO TEAMS! */
var bool bPlayersVsBots;

/** last time a player was killed or knocked DBNO */
var float LastDownOrKillTime;

/** Whether this gametype supports sudden death or not */
var config bool bSupportsSuddenDeath;
/** Whether this gametype is in sudden death or not */
var bool bIsInSuddenDeath;
/** Amount of time for sudden death */
var config int SuddenDeathTime;
/** Whether this round can go sudden death or not */
var bool bCanGoSuddenDeathThisRound;

/** string displayed to players when going to overtime (explain rules changes, etc) */
var localized string OvertimeTitle, OvertimeDesc;

/** Whether we are in training grounds or not */
var bool bIsTrainingGrounds;

/** Training Grounds scenario ID (if this is -1 we are not in training) */
var int TrainingGroundsID;
/** if training grounds is enabled, whether bots have been deactivated so the player can roam around freely */
var protected bool bTGBotsActive;

/** maximum squad size for bots (bots on a team are split up into squads of this size or less) */
var int MaxSquadSize;

/** Parsed from the URL so we know which game type won */
var int GameSettingsId;

/** Last weapon index used for weapon swapping to prevent repeat selections */
var int PreviousPreferredWeaponIdx;

/** Should planted grenades be eliminated between rounds? */
var bool bEliminatePlantedGrenades;

/** The time we started waiting for players */
var float WaitForTravelingPlayersStart;

/** The maximum amount of time a dedicated server will wait for first player to login (social only) */
var config float MaxWaitForFirstPlayer;
/** The maximum amount of time to wait for players */
var config float MaxWaitForTravelingPlayers;

/** whether we're allowed to swap in a bot when a human leaves and vice-versa */
var bool bCanSwapBotsAndPlayers;
/** number of players in the game at startup time */
var int InitialPlayers;

/** simple maps-only .ini driven map cycle for local/LAN/private matches */
var config array<name> MapCycle;

/** Cached locations of GearPawnFactory */
var array<GearPawnFactory> GearPawnFactoryList;

/** Used to create a per gametype scaling value for experience that is assigned via player score */
var config float XPScale;
/** The per gametype bonus experience to be given for winning */
var config int MatchWinXPBonus;
/** Consecutive match played bonus */
var config int ConsecutiveMatchBonus;
/** The number of matches played consecutively to reach the max bonus */
var config int NumConsecutiveMatchesNeeded;
/** Scale used to modify based upon ranked, social, or custom */
var config float RankedXPScale;
/** Scale used to modify based upon ranked, social, or custom */
var config float SocialXPScale;
/** Scale used to modify based upon ranked, social, or custom */
var config float CustomXPScale;
/** Scale used to modify based upon ranked, social, or custom */
var config float RankedMatchWinScale;
/** Scale used to modify based upon ranked, social, or custom */
var config float SocialMatchWinScale;
/** Scale used to modify based upon ranked, social, or custom */
var config float CustomMatchWinScale;
/** Scale used to modify based upon ranked, social, or custom */
var config float RankedRibbonXPScale;
/** Scale used to modify based upon ranked, social, or custom */
var config float SocialRibbonXPScale;
/** Scale used to modify based upon ranked, social, or custom */
var config float CustomRibbonXPScale;

/** postfix to .ini files to pass to LoadGameTypeConfigs() for this gametype */
var string GameTypeConfigName;

/** whether to use the Gears 1 combat movement speed */
var config bool bUseOldCombatMovementSpeed;

/** Team size based on the current game settings (only valid in Ranked/Social modes) */
var int PlaylistTeamSize;
/** Number of teams based on the current game settings (only valid in Ranked/Social modes) */
var int PlaylistTeamCount;
/** Host beacon used to make reservations in the current game session. Used for join in progress of Player matches */
var GearPlayerMatchBeaconHost HostPlayerMatchBeacon;

/** Class sent to clients to use to create and hold their stats for player matches */
var class<OnlineStatsWrite> OnlineStatsWriteClassPlayer;

/**
 * Delay dedicated server so that clients have a chance to catch up during seamless travel loading
 * This is needed so that clients have a chance to load GearStart before being told to load the next map by the server.
 */
var config float DedicatedServerMapCycleDelay;
/** last time team player starts were cycled */
var float LastTeamPlayerStartCycleTime;
/** maximum amount of time between team start cycles in gametypes that support it at all */
var config float MaxTeamStartCycleInterval;
/** if an enemy is within this distance of a team's player start, it is "encroaching" it (try to cycle spawns to avoid spawning team near enemies) */
var config float PlayerStartEncroachmentRadius;

/** Used to override weapon pickups via the URL for testing purposes */
var class<Inventory> WeaponSwapClass;

/** The number of demerits to issue for a host Rx standby */
var config int HostRxDemerits;
/** The number of demerits issued for crappy net connection/cheating */
var config int BadPingDemerits;

/** Whether to skip round start GUDs */
var bool bSkipRoundStartGUDs;

/** The match type being played */
var EGearVersusMatchType MatchType;

/** broadcast this sound to players when the enemy team is respawning */
var array<SoundCue> EnemyRespawningSound;

/** grenade type given in AddDefaultInventory() */
var class<GearWeap_GrenadeBase> DefaultGrenadeClass;

/** If this object is non-null, then we are performing host migration */
var GearGameHostMigrationManager GameHostMigrationManager;
/** MP character loader and referencer */
var GearMPCharacterStore CharacterStore;

/** The playlist being played or -1 if no playlist is being played */
var int PlaylistId;

/** The playlist manager to use when looking up playlist information */
var OnlinePlaylistManager PlaylistMan;

/** Global set of weapon swaps */
var config array<WeaponClassToWeaponClassMapping> GlobalWeaponSwaps;
/** Per level set of weapon swaps */
var config array<LevelSpecificWeaponSwapping> MapWeaponsSwaps;

/** How many times you must be killed by the same person before they become your nemesis */
var const config int NemesisThreshold;

/** whether we ever allow the newbie gameplay help */
var config bool bAllowNewbHelp;

event PreBeginPlay()
{
	Super.PreBeginPlay();

	class'GearEngine'.static.LoadGameTypeConfigs(GameTypeConfigName);

	CharacterStore = new(self) class'GearMPCharacterStore';
	CharacterStore.LoadComplete = PawnClassLoaded;
}

final function SetTrainingGroundBotsActive(bool bNowActive)
{
	local GearAI_TDM AI;
	local GearPC_MP PC;

	if (bIsTrainingGrounds)
	{
		bTGBotsActive = bNowActive;

		if (bTGBotsActive)
		{
			foreach WorldInfo.AllControllers(class'GearAI_TDM', AI)
			{
				AI.GotoState('Action_Idle');
			}
		}
		else
		{
			foreach WorldInfo.AllControllers(class'GearAI_TDM', AI)
			{
				if (AI.Pawn != None)
				{
					while (AI.CommandList != None)
					{
						AI.AbortCommand(None, class'AICommand');
					}
					AI.GotoState('Inactive');
				}
			}
		}

		foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
		{
			PC.ClientTGBotsActive(bTGBotsActive);
		}
	}
}

/** @return whether bots are active or should just sit there and do nothing (for training grounds) */
final function bool AreBotsActive()
{
	return (!bIsTrainingGrounds || bTGBotsActive);
}

/**
 * Determines the game settings object to use for the game rules based off the playlist and
 * the game type that was voted in
 */
function GearVersusGameSettings GetGameSettingsObject()
{
	local int MatchMode;
	local int MaxPartySize;
	local GearVersusGameSettings VsSettings;
	local GearVersusGameSettings PlaylistSettings;

	if (GameInterface != None)
	{
		// Read the playlist from the game settings
		VsSettings = GearVersusGameSettings(GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName));

		// If this is a ranked or player online match, get the playlist specific game settings
 		if ( VsSettings != None &&
 			 VsSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchMode) &&
 			(MatchMode == eGVMT_Official || MatchMode == eGVMT_Player) )
		{
			if (PlaylistMan != None)
			{
				PlaylistSettings = GearVersusGameSettings(PlaylistMan.GetGameSettings(PlaylistId,GameSettingsId));
				// If the playlist game settings haven't been initialized yet, then just use the defaults
				if (PlaylistSettings == None)
				{
					PlaylistSettings = VsSettings;
				}
				if (VsSettings.bUsesArbitration)
				{
					//No bots allowed
					PlaylistSettings.SetStringSettingValue(class'GearVersusGameSettings'.const.CONTEXT_NUMBOTS, CONTEXT_NUMBOTS_0);
				}
				else
				{
					//Bots fill out the game
					PlaylistMan.GetTeamInfoFromPlaylist(PlaylistId,PlaylistTeamSize,PlaylistTeamCount,MaxPartySize);
					PlaylistSettings.SetStringSettingValue(class'GearVersusGameSettings'.const.CONTEXT_NUMBOTS, Max(0,PlaylistTeamSize*PlaylistTeamCount-1));
				}
				return PlaylistSettings;
			}
		}
	}

	// If the settings are null and this is a local match use the current settings from the datastore
	if ( VsSettings == None )
	{
		VsSettings = GearVersusGameSettings(GetCurrentGameSettings(true));
		if ( VsSettings != None &&
			 VsSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchMode) &&
			 (MatchMode == eGVMT_Local || MatchMode == eGVMT_SystemLink) )
		{
			return VsSettings;
		}
		else
		{
			return None;
		}
	}

	// Return whatever happens to be there
	return VsSettings;
}

/** Game options in use recorded by stats */
function SetGameOptionsForStats()
{
	local int IntValue;
	local GearVersusGameSettings MyGameSettings;

	MyGameSettings = GetGameSettingsObject();

	// @STATS - Playlist ID
	`RecordGameIntStat(PLAYLISTID, PlaylistId);

	// @STATS - Friendly Fire
	`RecordGameIntStat(FRIENDLY_FIRE, bAllowFriendlyFire ? 1 : 0);

	// @STATS - Round Time
	`RecordGameIntStat(ROUND_TIME, RoundDuration);

	// @STATS - Bleedout Time
	`RecordGameIntStat(BLEEDOUTTIME, InitialRevivalTime);

	// @STATS - Rounds to Win
	`RecordGameIntStat(ROUNDSTOWIN, GoalScore);

	// @STATS - NumBots
	`RecordGameIntStat(NUMBOTS, RequestedBots);

	// @STATS - Execution Rules
	`RecordGameIntStat(EXECUTIONRULES, bExecutionRules ? 1 : 0);

	if ( MyGameSettings != None )
	{
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_WEAPONSWAP, IntValue) )
		{
			// @STATS - WeaponSwap
			`RecordGameIntStat(WEAPONSWAP_MODE, IntValue);
		}

		if (MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_BOTDIFFICULTY, IntValue))
		{
			// @STATS - Bot Difficulty
			`RecordGameIntStat(BOTDIFFICULTY, IntValue);
		}
	}
}

/**
 * Set the game rules via the online game settings
 * @return - whether the game was able to set the rules via the gamesettings object
 */
function bool SetGameRules()
{
	local int IntValue;
	local GearVersusGameSettings MyGameSettings;

	MyGameSettings = GetGameSettingsObject();

	if ( MyGameSettings != None )
	{
		// System Link
		bIsSystemLink = MyGameSettings.bIsLanMatch;

		// Friendly Fire
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_FRIENDLYFIRE, IntValue) )
		{
			bAllowFriendlyFire = (IntValue == MyGameSettings.const.CONTEXT_FRIENDLYFIRE_YES) ? TRUE : FALSE;
		}

		// Round Duration
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_ROUNDTIME, IntValue) )
		{
			RoundDuration = (IntValue + 1) * 60;
		}

		// Bleedout Duration
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_BLEEDOUTTIME, IntValue) )
		{
			switch ( IntValue )
			{
				case MyGameSettings.const.CONTEXT_BLEEDOUTTIME_FIVE:
					InitialRevivalTime = 5;
					break;
				case MyGameSettings.const.CONTEXT_BLEEDOUTTIME_TEN:
					InitialRevivalTime = 10;
					break;
				case MyGameSettings.const.CONTEXT_BLEEDOUTTIME_FIFTEEN:
					InitialRevivalTime = 15;
					break;
				case MyGameSettings.const.CONTEXT_BLEEDOUTTIME_TWENTY:
					InitialRevivalTime = 20;
					break;
				case MyGameSettings.const.CONTEXT_BLEEDOUTTIME_THIRTY:
					InitialRevivalTime = 30;
					break;
				case MyGameSettings.const.CONTEXT_BLEEDOUTTIME_SIXTY:
					InitialRevivalTime = 60;
					break;
			}
		}

		// Weapon Swap
		bUsingWeaponSwap = false;
		bUsingWeaponCycle = false;
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_WEAPONSWAP, IntValue) )
		{
			// Customized weapon swapping
			if ( IntValue == MyGameSettings.const.CONTEXT_WEAPONSWAP_CUSTOM )
			{
				bUsingWeaponSwap = true;
			}
			// Weapon cycling
			else if ( IntValue == MyGameSettings.const.CONTEXT_WEAPONSWAP_CYCLE )
			{
				bUsingWeaponCycle = true;
			}
		}

		// Goal Score to win match
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_ROUNDSTOWIN, IntValue) )
		{
			GoalScore = IntValue + 1;
		}

		// Number of bots
		SetNumBots();

		return TRUE;
	}

	return FALSE;
}

/** Set the number of bots for the game */
function SetNumBots()
{
	local int IntValue;
	local GearVersusGameSettings MyGameSettings;

	MyGameSettings = GetGameSettingsObject();

	if ( MyGameSettings != None && MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_NUMBOTS, IntValue) )
	{
		RequestedBots = IntValue;
	}
}

/**
 * Destroy the JIP host reservation beacon
 */
function DestroyHostBeacon()
{
	// Cleanup the host beacon so socket doesn't leak
	if (HostPlayerMatchBeacon != None)
	{
		HostPlayerMatchBeacon.DestroyBeacon();
		HostPlayerMatchBeacon = None;
	}
}

/**
 * Called when the object is garbage collected
 */
event GameEnding()
{
	// Cleanup dedicated server delegates
	ClearServerDelegates();

	// Cleanup the host beacon
	DestroyHostBeacon();

	Super.GameEnding();
}

/** @STATS - Setup the game stats logger for writing */
function StartLogging()
{
	local OnlineGameSettings GameSettings;
	local int MatchModeIdx;
	local bool bShouldLog;

 	if (GameInterface != None)
 	{
 		GameSettings = GameInterface.GetGameSettings('Game');

		// Only record stats in LIVE enabled sessions
		if (GameSettings != None &&
			GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx) &&
			MatchModeIdx != eGVMT_SystemLink && MatchModeIdx != eGVMT_Local)
		{
			bShouldLog = true;
		}
	}

	// Broken out for easy debugging
	if (bShouldLog)
	{
		Super.StartLogging();
		if (bLogGameplayEvents && GameplayEventsWriter != None && GameplayEventsWriter.IsSessionInProgress())
		{
			`RecordGameIntStat(MATCHMODE, MatchModeIdx);
			if (GameHostMigrationManager != None)
			{
				// @STATS - This is a host migrated session
				`RecordGameIntStat(HOSTMIGRATION, 1);
			}
		}
	}
}

event InitGame(string Options, out string ErrorMessage)
{
	local int MatchModeIdx, RecentPartyIdx;
	local int MaxPartySize;
	local OnlineGameSettings GameSettings;
	local GearRecentPlayersList RecentPlayersList;
	local string WeaponClassName;

	if (bTestingDedicated)
	{
		Options $= "?MaxSpectators=10";
		MaxSpectatorsAllowed = 32;
	}

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// See if we are now the host of a game from host migration
		GameHostMigrationManager = GearGameHostMigrationManager(OnlineSub.GetNamedInterface('GameHostMigrationManager'));
		// Clear it so that we don't use stale data
		OnlineSub.SetNamedInterface('GameHostMigrationManager',None);

		GameInterface = OnlineSub.GameInterface;
	}

	if (GameInterface != None)
	{
		GameSettings = GameInterface.GetGameSettings('Game');
 		if (GameHostMigrationManager != None &&
 			GameSettings != None)
 		{
 			// Update game settings from host migration data
 			GameHostMigrationManager.UpdateGameSettings(GameSettings);
 		}
		if (GameSettings != None &&
			GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx) &&
			GameSettings.GetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTID,PlaylistId))
		{
			MatchType = EGearVersusMatchType(MatchModeIdx);
			// Find out how big the teams are and how many for the selected playlist id
			PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
			if (PlaylistMan != None &&
				(MatchModeIdx == eGVMT_Official || MatchModeIdx == eGVMT_Player))
			{
				PlaylistMan.GetTeamInfoFromPlaylist(PlaylistId,PlaylistTeamSize,PlaylistTeamCount,MaxPartySize);
				MaxPlayers = PlaylistTeamSize * PlaylistTeamCount;
				// Append any URL options that the playlist may want
				Options $= PlaylistMan.GetUrlFromPlaylist(PlaylistId);
				// Use a custom map cycle for this playlist if present
				if (MatchModeIdx == eGVMT_Player)
				{
					PlaylistMan.GetMapCycleFromPlaylist(PlaylistId,MapCycle);
				}
				// Set the load balanced game mode based on current playlist id
				GameSettings.SetStringSettingValue(CONTEXT_GAME_MODE,class'GearPartySlotGameSettings'.static.GetGameModeFromPlaylistId(PlaylistMan,PlaylistId));
				// Set skill leaderboard to write to at end of match based on load balanced game mode
				if (PlaylistMan.IsPlaylistArbitrated(PlaylistId))
				{
					ArbitratedLeaderboardId = class'GearLeaderboardVersusSkill'.static.GetLeaderboardIdFromPlaylistId(PlaylistMan,PlaylistId);
				}
				else
				{
					LeaderboardId = class'GearLeaderboardVersusSkill'.static.GetLeaderboardIdFromPlaylistId(PlaylistMan,PlaylistId);
				}
			}

			// Player match host beacon
			if (MatchModeIdx == eGVMT_Player)
			{
				// Player match should never be pause-able
				bPauseable = false;

				// create a host beacon for accepting join in progress members
				HostPlayerMatchBeacon = new class'GearPlayerMatchBeaconHost';
				HostPlayerMatchBeacon.BeaconName = 'GearPlayerMatchHost';
				HostPlayerMatchBeacon.OnReservationChange = OnHostBeaconReservationChange;

				// Initialize the beacon and start listening for client reservation requests
				HostPlayerMatchBeacon.InitHostBeacon(PlaylistTeamCount,PlaylistTeamSize,PlaylistTeamCount * PlaylistTeamSize,'Game', (GearGameSiege_Base(self) != None) ? 1 : 0);

				// Add the initial reservation for members of the host party
				// The host party is stored in GearRecentPlayersList during the party lobby
				// The GearRecentPlayersList also persists prior beacon party reservations during map cycles
				RecentPlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
				if (RecentPlayersList != None)
				{
`if(`notdefined(FINAL_RELEASE))
					RecentPlayersList.DumpGearParties();
`endif
					// Populate host beacon with existing party reservation entries that have persisted
					for (RecentPartyIdx=0; RecentPartyIdx < RecentPlayersList.LastGearParties.Length; RecentPartyIdx++)
					{
						HostPlayerMatchBeacon.AddGearPartyReservation(
							RecentPlayersList.LastGearParties[RecentPartyIdx].PartyLeader,
							RecentPlayersList.LastGearParties[RecentPartyIdx].PartyMembers,
							GameSettings.OwningPlayerId == RecentPlayersList.LastGearParties[RecentPartyIdx].PartyLeader);
					}
				}

				// Reopen the available connections once the match starts
				GameSettings.NumPublicConnections = PlaylistTeamCount * PlaylistTeamSize;
				// Actual transmitted update will occur on first person logging in
				SetGameSettingNeedsSize('Game',0,false);
				GameInterface.UpdateOnlineGame('Game', GameSettings, false);

				// Change the stats writer to the player variety
				OnlineStatsWriteClass = default.OnlineStatsWriteClassPlayer;
			}
			else if (MatchModeIdx == eGVMT_Official)
			{
				// Change the stats writer to the ranked variety
				OnlineStatsWriteClass = default.OnlineStatsWriteClass;

				// Allow JIP for non arbitrated matches (includes ranked horde)
				if (!GameSettings.bUsesArbitration)
				{
					GameSettings.bAllowJoinInProgress = true;
					GameInterface.UpdateOnlineGame('Game', GameSettings, true);
				}
			}
		}
		else
		{
			// Determine the match type from whether we have a networking or not
			MatchType = WorldInfo.NetMode != NM_Standalone ? eGVMT_SystemLink : eGVMT_Local;
		}
	}

	// Moved to after online init so that the playlist manager may apply additional URL options
	Super.InitGame(Options, ErrorMessage);

	GameSettingsId = GetIntOption(Options, "GameSettingsId", 0);

	// Determine if this is training grounds or not
	bIsTrainingGrounds = HasOption(Options, "bIsTraining");
	if (bIsTrainingGrounds)
	{
		RequestedBots = 9;
	}

	// Training Grounds ID
// 	TrainingGroundsID = GetIntOption(Options, "Training", TrainingGroundsID);

	// Let the game settings set the game rules, unless we're doing training grounds
	if ( TrainingGroundsID < 0 )
	{
		if ( !SetGameRules() )
		{
			// Handle system link
			bIsSystemLink = HasOption(Options, "bIsLanMatch");

			// Handle friendly fire
			bAllowFriendlyFire = (ParseOption( Options, "FriendlyFire") != "");

			// Number of Bots
			RequestedBots = Max( 0, GetIntOption(Options,"Bots",RequestedBots) );

			// Goal Score
			if ( HasOption(Options, "GoalScore") )
			{
				GoalScore = Clamp( GetIntOption(Options, "GoalScore", GoalScore), 1, 19 );
			}
		}
	}
	else
	{
		// Number of Bots
		RequestedBots = Max(0, GetIntOption(Options, "Bots", RequestedBots));

		// Goal Score
		if (HasOption(Options, "GoalScore"))
		{
			GoalScore = Clamp(GetIntOption(Options, "GoalScore", GoalScore), 1, 19);
		}
	}

	CheckForExecutionRules(Options);

	// Handle Bleedout Time
	if ( HasOption(Options, "BleedOutTime") )
	{
		InitialRevivalTime = Clamp( GetIntOption(Options, "BleedOutTime", InitialRevivalTime), 0, 500 );
	}

	// Tourist
	if ( WorldInfo.IsPlayInEditor() || HasOption(Options, "bTourist") )
	{
		bTourist = TRUE;
	}

	if (HasOption(Options, "bUsePawnFactories"))
	{
		bUsePawnFactories = TRUE;
	}

	// Check for DevMode option.
	bInDevMode = HasOption(Options, "DevMode");
	// Quick start
	bQuickStart = HasOption(Options, "QuickStart");
	// Players versus AI option
	bPlayersVsBots = HasOption(Options, "VsBots");
	// start delay
	AutoStartDelay = GetIntOption(Options, "StartDelay", AutoStartDelay);
	HostStartDelay = GetIntOption(Options, "StartDelay", HostStartDelay);

	// Don't use arbitration for system link or local
	if (GameInterface == None ||
		GameInterface.GetGameSettings('Game') == None ||
		!GameInterface.GetGameSettings('Game').bUsesArbitration ||
		GameInterface.GetGameSettings('Game').bIsLanMatch)
	{
		bUsingArbitration = false;
	}

	// Check for weapon swaps on the URL to aid testing
	WeaponClassName = ParseOption(Options,"Weapon");
	if (WeaponClassName != "")
	{
		// Turn the class name into a class object
		WeaponSwapClass = class<Inventory>(DynamicLoadObject(WeaponClassName,class'class'));
		bUsingWeaponSwap = WeaponSwapClass != None;
	}

	bCanSwapBotsAndPlayers = bCanSwapBotsAndPlayers && (RequestedBots > 0 || bUsingArbitration);

	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		// Setup delegates to detect connectivity issues
		RegisterServerDelegates();
	}
	// We only want standby checking for Ranked or Social for player hosted matches
	bIsStandbyCheckingEnabled = bIsStandbyCheckingEnabled &&
		(MatchType == eGVMT_Official || MatchType == eGVMT_Player) &&
		WorldInfo.NetMode == NM_ListenServer;
}

/**
 * Overridden to alter the tutorial type for training grounds
 *
 * @param	PC	the player that should initialize the tutorial system.
 */
function InitializeTutorialSystem( GearPC PC )
{
	local EGearAutoInitTutorialTypes TutType;

	if ( PC != None && bAllowTutorials )
	{
		TutType = AutoTutorialType;

		switch (TrainingGroundsID)
		{
			case eGEARTRAIN_Basic:
				TutType = eGAIT_Train1;
				break;
			case eGEARTRAIN_Execution:
				TutType = eGAIT_Train2;
				break;
			case eGEARTRAIN_Respawn:
				TutType = eGAIT_Train3;
				break;
			case eGEARTRAIN_Objective:
				TutType = eGAIT_Train4;
				break;
		}
		// Create the Tutorial Manager
		PC.ClientInitializeTutorialSystem( TutType, true );
	}
}

/** Checks to see if execution rules should be applied to the game or not and sets it if it should */
function CheckForExecutionRules( string Options )
{
	// Must set special variables if in execution mode
	if (bConfigForceExecution || HasOption(Options, "bIsExecution"))
	{
		SetExecutionRules();
		bExecutionRules = true;
	}
}

/** Set the game for execution rules */
final function SetExecutionRules()
{
	bAutoReviveOnBleedOut = true;
	InitialRevivalTime = Max( InitialRevivalTime, 1 );
	bCanBeShotFromAfarAndKilledWhileDownButNotOut = false;
}

/** Whether a weapon is a generic drop or a special one */
function EGearDroppedPickupType GetWeaponDropType(Inventory Weap)
{
	if ( Weap.IsA('GearWeap_Shotgun') || Weap.IsA('GearWeap_AssaultRifle') || Weap.IsA('GearWeap_GrenadeBase') ||
		Weap.IsA('GearWeap_LocustAssaultRifle') || Weap.IsA('GearWeap_PistolBase') )
	{
		return eGEARDROP_Generic;
	}
	else
	{
		return eGEARDROP_Special;
	}
}

/** Allow Gametype to prevent weapon drops */
function bool CanDropWeapon(Inventory W, vector DropLocation)
{
	return ((GearWeap_HeavyBase(W) != None && W.IsPlayerOwned()) || CanDropWeaponAtLocation(W, DropLocation));
}

/** Whether we can drop a weapon at a specific location, based on whether there is a weapon of the same type within a range */
function bool CanDropWeaponAtLocation(Inventory W, vector DropLocation)
{
	local float RadiusCheck;
	local GearDroppedPickup GearDrop;

	RadiusCheck = (GetWeaponDropType(W) == eGEARDROP_Generic) ? WeaponDropRadiusCheckGeneric : WeaponDropRadiusCheckSpecial;

	if (RadiusCheck > 0.0)
	{
		foreach VisibleActors(class'GearDroppedPickup', GearDrop, RadiusCheck, DropLocation)
		{
			if (GearDrop.InventoryClass == W.Class && GearDrop.ClaimedBy == None)
			{
				return false;
			}
		}
	}

	return true;
}

/** @return whether the server can pause this game when played online */
function bool AllowNetworkPause()
{
	return (GameInterface == None || GameInterface.GetGameSettings('Game') == None || GameInterface.GetGameSettings('Game').NumPublicConnections <= 1);
}

function GenericPlayerInitialization(Controller C)
{
	local GearPC_MP PC;
	local int i;

	if (WorldInfo.NetMode == NM_DedicatedServer && NumPlayers <= 1)
	{
		// The first player to login starts the start match timer
		WaitForTravelingPlayersStart = WorldInfo.TimeSeconds;
	}

	PC = GearPC_MP(C);
	if (PC != None && LocalPlayer(PC.Player) == None)
	{
		PC.ClientLoadGametypeConfigs(GameTypeConfigName);
	}

	Super.GenericPlayerInitialization(C);

	if (PC != None)
	{
		// tell player of any character classes it needs to load
		if (NetConnection(PC.Player) != None && ChildConnection(PC.Player) == None)
		{
			for (i = 0; i < CharacterStore.LoadedClasses.length; i++)
			{
				PC.ClientLoadCharacter(PathName(CharacterStore.LoadedClasses[i]));
			}
			for (i = 0; i < CharacterStore.PendingClasses.length; i++)
			{
				PC.ClientLoadCharacter(CharacterStore.PendingClasses[i]);
			}
		}

		// update player class for travelling players as we can potentially load their desired class now
		if (PC.PlayerReplicationInfo.Team != None)
		{
			SetPlayerClass(PC, PC.GetTeamNum());
		}

		if (MatchType == eGVMT_Player)
		{
			// Toggle invites based on if the player's team is full or not
			UpdatePlayerMatchInvites(PC);

			// NOTE: Need to update the context/properties of the game session AFTER
			// updating the party session since it will override the advertised values
			UpdatePlayerMatchNeedWantsStatus();
		}
		else
		{
			//Ranked / private update invites
			AllowJIPForParty();
		}
		// Setup rich presence for new client
		SetVersusRichPresenceString(PC);
		// Have the client tell us how many disconnects they currently have (adding +1 clientside for the current match)
		if (MatchType == eGVMT_Official)
		{
			PC.ClientAdjustDisconnectCount(1, true);
		}

		// Have the client tell us how many matches they've played
		PC.ClientUpdateConsecutiveMatchesPlayed();
	}
}

function PostLogin(PlayerController NewPlayer)
{
	local int TeamIndex;
	local OnlineGameSettings GameSettings;
	local GearPRI PRI;

	Super.PostLogin(NewPlayer);

`if(`notdefined(dev_build))
	// disable pausing once a nonlocal player joins
	if (LocalPlayer(NewPlayer.Player) == None && !AllowNetworkPause())
	{
		bPauseable = false;
		ClearPause();
	}
`endif

	if (GameHostMigrationManager == None)
	{
		// force them to a team for testing
		TeamIndex = 255;
	}
	else
	{
		PRI = GearPRI(NewPlayer.PlayerReplicationInfo);
		if (PRI != None)
		{
			// Update the saved off stats
			GameHostMigrationManager.UpdatePRI(PRI);
			// Try to update their team based upon their last known team
			TeamIndex = GameHostMigrationManager.GetTeamId(PRI);
		}
	}

	// All players are placed on the spectating team until respawn or next round starts
	// Player matches will assign players to their team by reservation
	// Private matches will assign players randomly (favor team balance, then human balance)
	ChangeTeam(NewPlayer,255,false);

	if (GearGRI.GameStatus == GS_RoundInProgress)
	{
		if (ShouldRespawnPC(TeamIndex,NewPlayer))
		{
			GearPC_MP(NewPlayer).WaitForRespawn();
		}
		GearPC_MP(NewPlayer).TransitionToSpectate();
		GearPRI(NewPlayer.PlayerReplicationInfo).bIsDead = TRUE;
		GearPRI(NewPlayer.PlayerReplicationInfo).PlayerStatus = WPS_Spectating;
	}

	// Tell JIP players to start their online game session
	if (NewPlayer != None && GameInterface != None)
	{
		GameSettings = GameInterface.GetGameSettings('Game');
		if (GameSettings != None &&
		   (GameSettings.GameState == OGS_InProgress ||
			GameSettings.GameState == OGS_Starting))
		{
			NewPlayer.ClientStartOnlineGame();
		}

		// Initializing the last match results for JIP situation by checking
		// if the game status has progressed beyond the start of the game
		if (GearGRI.GameStatus > GS_PreMatch)
		{
			if (!bUsingArbitration)
			{
				GearPC_MP(NewPlayer).ClientInitLastMatchResults(OnlineStatsWriteClass, bUsingArbitration);
				GearPC_MP(NewPlayer).ClientClearLastMatchResults();
			}
		}
	}

	GearPC_MP(NewPlayer).ClientSetPreferredMPOptions();
}

/**
 * Calculate the smallest teams in the game
 * @param SmallestTeams - array of team indices that are deemed smallest
 * @return Number of teams that are considered smallest
 */
function int GetSmallestTeams(out array<int> SmallestTeams)
{
	local int Idx, SmallestTeam;

	SmallestTeam = 0;
	SmallestTeams.length = 1;
	SmallestTeams[0] = SmallestTeam;
	for ( Idx = 1; Idx < NumTeams; Idx++ )
	{
		if ( Teams[Idx].Size < Teams[SmallestTeam].Size )
		{
			//Reset smallest team list
			SmallestTeam = Idx;
			SmallestTeams.length = 1;
			SmallestTeams[0] = SmallestTeam;
		}
		else if ( Teams[Idx].Size == Teams[SmallestTeam].Size )
		{
			//Add to list of smallest teams
			SmallestTeams.length = SmallestTeams.length + 1;
			SmallestTeams[SmallestTeams.length-1] = Idx;
		}
	}

	//Return the number of teams that are smallest
	return SmallestTeams.length;
}

/**
 * Places the new player onto a randomly selected smallest team
 * Doesn't replace/remove bots
 * @param NewPlayer Player to place on a team
 */
function PlacePlayerOnSmallestTeam( PlayerController NewPlayer )
{
	local array<int> SmallestTeams;
	local int SmallestTeamCount, TeamChoice;
	SmallestTeamCount = GetSmallestTeams(SmallestTeams);

	TeamChoice = Rand(SmallestTeamCount);
	ChangeTeam( NewPlayer, SmallestTeams[TeamChoice], false );
}

function bool ShouldRespawnPC(int TeamIdx, Controller PCToRespawn)
{
	return !bLastKillerSet && Super.ShouldRespawnPC(TeamIdx, PCToRespawn);
}

function RandomizeWeaponPickupFactories()
{
	local GearWeaponPickupFactory WF;
	local int Idx, PreferredIdx, HighestIdx, PickupIdx;
	local class<Inventory> RemappedClass;
	local DroppedPickup Pickup;
	local array<GearWeaponPickupFactory> PickupList;

	//`log(WorldInfo.TimeSeconds@GetFuncName());

	// destroy untaken pickups that were spawned by factories (Inventory == None)
	foreach DynamicActors(class'DroppedPickup', Pickup)
	{
		if (Pickup.Inventory == None && !Pickup.IsA('GearPinataCandy') && !Pickup.IsA('GearHordeAirDrop'))
		{
			Pickup.Destroy();
		}
	}

	// figure out the biggest list
	HighestIdx = 0;
	foreach WorldInfo.AllNavigationPoints(class'GearWeaponPickupFactory', WF)
	{
		HighestIdx = Max(HighestIdx,WF.MPWeaponPickupList.Length);
		PickupList.AddItem(WF);
	}

	// don't bother switching if there are no weapon switches in this map
	if (HighestIdx == 0)
	{
		return;
	}

	if (HighestIdx == 1)
	{
		PreferredIdx = 0;
	}
	else
	{
		// attempt to use the same idx across as many pickups as possible
		PreferredIdx = Rand(HighestIdx);
		while (PreferredIdx == PreviousPreferredWeaponIdx)
		{
			PreferredIdx = Rand(HighestIdx);
		}
	}
	PreviousPreferredWeaponIdx = PreferredIdx;
	//`log(`showvar(PreferredIdx)@`showvar(HighestIdx));
	for (PickupIdx = 0; PickupIdx < PickupList.length; PickupIdx++)
	{
		WF = PickupList[PickupIdx];

		// A player is holding the counterpart to this weapon, don't change the class it has.
		if (WF.CoopWeaponSyncActor != None && !WF.CoopWeaponSyncActor.HasWeaponPickupFactoryCounterpart(WF))
		{
			continue;
		}

		// If we are not using weapon cycling just set the index to 0
		Idx = bUsingWeaponCycle ? PreferredIdx : 0;
		if (WF.MPWeaponPickupList.Length > 0)
		{
			//`log("- inspecting"@WF);
			// try to share the same selection between all factories
			if (Idx == -1 || Idx >= WF.MPWeaponPickupList.Length)
			{
				Idx = Rand(WF.MPWeaponPickupList.Length);
				//`log("-> index:"@Idx);
			}

			// Allow the host's profile to remap the weapon class
			RemappedClass = RemapWeaponPickupClass(WF.MPWeaponPickupList[Idx]);
		}
		else
		{
			// check for swap on the base pickup class
			RemappedClass = RemapWeaponPickupClass(WF.WeaponPickupClass);
		}
		if (RemappedClass != WF.WeaponPickupClass)
		{
			// @STATS - WeaponSwap
			`RecordGameStringStat(WEAPONSWAP, WF.WeaponPickupClass$"=>"$RemappedClass);

			WF.WeaponPickupClass = class<GearWeapon>(RemappedClass);
			WF.PlaceholderClass = None;
			// if it's not a GearWeapon, spawn a dropped pickup containing the item instead
			if (WF.WeaponPickupClass == None && RemappedClass != None)
			{
				Pickup = Spawn(RemappedClass.default.DroppedPickupClass,,, WF.Location, WF.Rotation);
				if (Pickup != None)
				{
					Pickup.InventoryClass = RemappedClass;
					Pickup.SetPickupMesh(RemappedClass.default.DroppedPickupMesh);
					Pickup.SetPhysics(PHYS_None);
				}
				// mark the placeholder class so that other code can still figure out what pickup this factory presents
				WF.PlaceholderClass = RemappedClass;
			}
			WF.PickupClassChanged();
			WF.bForceNetUpdate = TRUE;
		}
	}
}

/**
 * Used for us to override a weapon pickup if we decide that a weapon needs to be globally swapped
 *
 * @param WeapClassToSet the weapon class to determine if it needs swapping
 *
 * @return the weapon class to use instead if different
 */
function class<Inventory> GlobalRemapWeaponPickupClass(class<Inventory> WeapClassToSet)
{
	local int SwapIndex;

	SwapIndex = GlobalWeaponSwaps.Find('WeapClass',WeapClassToSet.Name);
	if (SwapIndex != INDEX_NONE)
	{
		return class<Inventory>(DynamicLoadObject(GlobalWeaponSwaps[SwapIndex].SwapWeapClass,class'class'));
	}

	return WeapClassToSet;
}

/**
 * Used for us to override a weapon pickup if we decide that a weapon is not good for a given map
 *
 * @param WeapClassToSet the weapon class to determine if it needs swapping
 *
 * @return the weapon class to use instead if different
 */
function class<Inventory> PerMapRemapWeaponPickupClass(class<Inventory> WeapClassToSet)
{
	local int MapIndex;
	local int SwapIndex;

	// Find the map we are in
	MapIndex = MapWeaponsSwaps.Find('MapName',name(WorldInfo.GetMapName(true)));
	if (MapIndex != INDEX_NONE)
	{
		// See if there is a weapon swap for this map
		SwapIndex = MapWeaponsSwaps[MapIndex].MapWeaponSwaps.Find('WeapClass',WeapClassToSet.Name);
		if (SwapIndex != INDEX_NONE)
		{
			return class<Inventory>(DynamicLoadObject(MapWeaponsSwaps[MapIndex].MapWeaponSwaps[SwapIndex].SwapWeapClass,class'class'));
		}
	}

	return WeapClassToSet;
}

/**
 * Allows a player to override a weapon pickup based upon their profile preferences
 *
 * @param WeapClassToSet the weapon class to determine if it needs swapping
 *
 * @return the weapon class to use instead if different
 */
function class<Inventory> PlayerRemapWeaponPickupClass(class<Inventory> WeapClassToSet)
{
	local GearPC_MP PC;
	local GearProfileSettings HostProfile;
	local int WeaponClassIndex;
	local int ProfileId;
	local int ProfileValue;
	local int SwapIndex;

	// Get the host's profile
	foreach LocalPlayerControllers(class'GearPC_MP', PC)
	{
		HostProfile = PC.ProfileSettings;
		break;
	}

	// If there's a valid profile
	if (HostProfile != None)
	{
		// See if the specified class is in the table
		WeaponClassIndex = MPResourceClass.default.WeaponLookupTable.Find('WeapClass',WeapClassToSet);
		if (WeaponClassIndex != INDEX_NONE)
		{
			ProfileId = MPResourceClass.default.WeaponLookupTable[WeaponClassIndex].ProfileId;
			if (ProfileId != INDEX_NONE)
			{
				// Now see what the profile has set
				if (HostProfile.GetProfileSettingValueId(ProfileId,ProfileValue))
				{
					// If the weapon is to be disabled just return none
					if (ProfileValue == eGEARWEAP_Disabled)
					{
						return None;
					}
					else
					{
						// Find what the class is being swapped to
						SwapIndex = MPResourceClass.default.WeaponLookupTable.Find('WeapSwapType',EGearWeaponType(ProfileValue));
						if (SwapIndex != INDEX_NONE)
						{
							return MPResourceClass.default.WeaponLookupTable[SwapIndex].WeapClass;
						}
					}
				}
			}
		}
	}

	return WeapClassToSet;
}

/** Returns the weapon that was swapped for WeapClassToSet */
function class<Inventory> RemapWeaponPickupClass( class<Inventory> WeapClassToSet )
{
	// If there is an URL override, return that
	if (WeaponSwapClass != None)
	{
		return WeaponSwapClass;
	}

	if (WeapClassToSet != None)
	{
		// Check for global remapping of weapons
		WeapClassToSet = GlobalRemapWeaponPickupClass(WeapClassToSet);
		if (WeapClassToSet != None)
		{
			// Check for per map remapping of a weapon
			WeapClassToSet = PerMapRemapWeaponPickupClass(WeapClassToSet);
			if (WeapClassToSet != None)
			{
				// Check for per playlist override of a weapon
				if (PlaylistId != -1)
				{
					WeapClassToSet = PlaylistMan.GetInventorySwapFromPlaylist(PlaylistId,WeapClassToSet);
				}
				// Is the weapon swap feature turned on?
				else if (bUsingWeaponSwap)
				{
					WeapClassToSet = PlayerRemapWeaponPickupClass(WeapClassToSet);
				}
			}
		}
	}
	return WeapClassToSet;
}

/** Seed all the MP vars to the GRI */
function InitGameReplicationInfo()
{
	local GearGRI_MP WGRI;
	local OnlineGameSettings GameSettings;
	local int Value;

	Super.InitGameReplicationInfo();

	WGRI = GearGRI_MP(GetGRI());
	if ( WGRI != None )
	{
		GearGRI = WGRI;		// Precache it

		WGRI.HostStartDelay		= bQuickStart ? 0 : HostStartDelay;
		WGRI.AutoStartDelay 	= AutoStartDelay;
		WGRI.EndOfRoundDelay 	= EndOfRoundDelay;
		WGRI.RoundDuration 		= RoundDuration;
		WGRI.EndOfGameDelay 	= EndOfGameDelay;
		WGRI.InitialRevivalTime = InitialRevivalTime;
		WGRI.bAllowFriendlyFire = bAllowFriendlyFire;

		WGRI.GoalScore = GoalScore;
		WGRI.TimeLimit = TimeLimit;

		WGRI.bGameIsExecutionRules = bExecutionRules;
		WGRI.bAutoReviveOnBleedOut = bAutoReviveOnBleedOut;
		WGRI.bIsTrainingGrounds = bIsTrainingGrounds;
		WGRI.TrainingGroundsID = TrainingGroundsID;

		if (OnlineSub != None &&
			OnlineSub.GameInterface != None)
		{
			// Copy playlist id from game settings if available
			GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
			if (GameSettings != None)
			{
				GameSettings.GetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTID,Value);
				WGRI.SetPlaylist(Value);
				GameSettings.GetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTMANAGERVERSION,WGRI.PlaylistManagerVer);
			}
		}

		if (GameHostMigrationManager != None)
		{
			// Set up the game options
			GameHostMigrationManager.UpdateGRI(GearGRI(GameReplicationInfo));
			GoalScore = GearGRI.GoalScore;
		}
	}
}

event PostBeginPlay()
{
	Super.PostBeginPlay();

	MaxPlayerStartTeamIndex = NumTeams - 1;
}

/**
 * Called on the first tick of the PendingMatch state so that we can initialized data only once,
 * but after the Sequence is initialized. This is handy for initialization code that requires
 * the kismet system to be ready (such as finding all events of type x)
 */
function InitializeGameOnFirstTick()
{
	local GearPawnFactory Factory;

	// reset the visibility manager
	AIVisman.Reset();

	// Loop through each GearPawnFactory
	foreach WorldInfo.AllNavigationPoints(class'GearPawnFactory', Factory)
	{
		GearPawnFactoryList.AddItem(Factory);
	}
}

/** will randomize which team will spawn at a playerstart */
function ShuffleTeamPlayerStarts()
{
	local int RandomNumber, TeamIdx;

	// Clear the array
	TeamPlayerStartIndex.length = 0;

	// Calculate new indexes for all the teams.
	for ( TeamIdx = 0; TeamIdx < NumTeams; TeamIdx++ )
	{
		RandomNumber = Rand( NumTeams );
		while ( TeamPlayerStartIndex.Find(RandomNumber) != INDEX_NONE )
		{
			RandomNumber = (RandomNumber + 1) % NumTeams;
		}
		TeamPlayerStartIndex[TeamIdx] = RandomNumber;
	}
}

/** Initialized TeamInfo and other related team data */
function InitializeTeams()
{
	local int Idx;

	Super.InitializeTeams();

	// Initialize player start indexes for determining spawn points
	for (Idx = 0; Idx < NumTeams; Idx++)
	{
		TeamPlayerStartIndex[Idx] = Idx % (MaxPlayerStartTeamIndex + 1);
	}
}

/** Call as soon as a new round is queued up. */
function NewRound()
{
	local GearPC_MP PC;
	local int Index;
	local bool bEncouragedLocalPC;

	// Send an encouragement sound cue.
	Index = Rand(255);
	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		if ( LocalPlayer(PC.Player) != none  )
		{
			if (!bEncouragedLocalPC )
			{
				GearPRI(PC.PlayerReplicationInfo).EndOfRoundEncouragement(Index);
				bEncouragedLocalPC = true;
			}
		}
		else
		{
			GearPRI(PC.PlayerReplicationInfo).EndOfRoundEncouragement(Index);
		}
		// Log everything out for MGS test automation
		PC.ClientLogMPTestAutomationData(WorldInfo.NetMode,false,MatchType);
	}

	// reset any dangling gameplay
	if ( GearGRI.HODBeamManager != None )
	{
		GearGRI.HODBeamManager.ResetAll();
	}
}

/** A game has ended, tell all clients */
function GameEnded()
{
	local int WinningTeamIndex;
	local Controller C;
	local GearPC_MP GPC;
	local int HighScore;
	local bool bIsComplete, bIsWinner, bIsFirst;

	HighScore = -99999999;

	WinningTeamIndex = -1;
	if (GameReplicationInfo.Winner != None)
	{
		WinningTeamIndex = TeamInfo(GameReplicationInfo.Winner).TeamIndex;
		bIsComplete = true;
	}

	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (HighScore < C.PlayerReplicationInfo.Score)
		{
			HighScore = C.PlayerReplicationInfo.Score;
		}
	}

	foreach WorldInfo.AllControllers(class'GearPC_MP', GPC)
	{
		bIsFirst = false;
		bIsWinner = false;
		if (GPC != None)
		{
			if (GPC.PlayerReplicationInfo.Score == HighScore)
			{
				bIsFirst = true;
			}

			if (GPC.PlayerReplicationInfo.Team != None &&
				GPC.PlayerReplicationInfo.Team.TeamIndex == WinningTeamIndex)
			{
				bIsWinner = true;
			}

			GPC.ClientStatGameEnded(bIsComplete, bIsWinner, bIsFirst);
		}
	}
}

/** Call as soon as the match has ended.  Forward the event to the clients. */
function EndMatch()
{
	local GearPC_MP PC;
	local int EncIndex;
	local bool bEncouragedLocalPC;

	// Send an encouragement sound cue.
	EncIndex = Rand(255);
	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		if ( LocalPlayer(PC.Player) != none  )
		{
			if (!bEncouragedLocalPC )
			{
				GearPRI(PC.PlayerReplicationInfo).EndOfGameEncouragement(EncIndex);
				bEncouragedLocalPC = true;
			}
		}
		else
		{
			GearPRI(PC.PlayerReplicationInfo).EndOfGameEncouragement(EncIndex);
		}
		// Log everything out for MGS test automation
		PC.ClientLogMPTestAutomationData(WorldInfo.NetMode,false,MatchType);
	}

	// Allow everyone to talk during map travel
	ResetGameplayMuting();

	GameEnded();
	// Turn off standby cheat detection so we don't get false positives due to leaving
	EnableStandbyCheatDetection(false);
}

/** Lets the scoreboard know who was dead at the end of the round */
function PreparePostRoundScoreboardData()
{
	local Controller CurrController;
	local GearPawn GP;
	foreach WorldInfo.AllControllers( class'Controller', CurrController )
	{
		// Allows us to know who died during the match for UI
		GP = GearPawn(CurrController.Pawn);
		if ( GP != None && !GP.bTearOff && !GP.IsInState('Dying'))
		{
			GearPRI(CurrController.PlayerReplicationInfo).EndOfRoundPlayerStatus = WPS_Alive;
		}
		else
		{
			GearPRI(CurrController.PlayerReplicationInfo).EndOfRoundPlayerStatus = WPS_Dead;
		}
	}
}

/** Kill anyone left alive in the match */
function KillRemainingPlayers()
{
	local Controller Player;
	local Pawn OldPawn;
	local GearPRI MyGearPRI;

	// kill any players currently alive
	foreach WorldInfo.AllControllers(class'Controller', Player)
	{
		if(!Player.bIsPlayer)
		{
			continue;
		}

		if (Player.Pawn != None)
		{
			OldPawn = Player.Pawn;

			// stop any weapons fire
			Player.Pawn.StopFiring();
			// detach the pawn from the controller so that they don't stay around until the next match
			Player.UnPossess();

			if ( GearPawn(OldPawn) != None )
			{
				OldPawn.Destroy();
			}
		}

		Player.PlayerReplicationInfo.bReadyToPlay = false;
		MyGearPRI = GearPRI(Player.PlayerReplicationInfo);
		MyGearPRI.ClearDeathVariables();
	}
}


/** Rate whether player should choose this NavigationPoint as its start */
function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	local float Score, NextDist;
	local Controller OtherPlayer;
	local GearTeamPlayerStart GearP;

	if (P == None || !P.bEnabled || P.PhysicsVolume.bWaterVolume || (P.Class != GearPlayerStartClass))
	{
		return -10000000;
	}

	if (Team < TeamPlayerStartIndex.length)
	{
		GearP = GearTeamPlayerStart(P);
		if (GearP != None && GearP.TeamIndex != TeamPlayerStartIndex[Team])
		{
			return -1000000;
		}
	}

	//assess candidate
	if (P.bPrimaryStart)
	{
		Score = 10000000;
	}
	else
	{
		Score = 5000000;
	}

	if (bFixedPlayerStart)
	{
		return Score;
	}

	foreach WorldInfo.AllControllers(class'Controller', OtherPlayer)
	{
		if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) )
		{
			NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
			if ( VSize2D(OtherPlayer.Pawn.Location - P.Location) < 2.0 * OtherPlayer.Pawn.CylinderComponent.CollisionRadius &&
				Abs(OtherPlayer.Pawn.Location.Z - P.Location.Z) < 2.0 * OtherPlayer.Pawn.CylinderComponent.CollisionHeight )
			{
				Score -= (1000000.0 - NextDist);
			}
			else if (NextDist < 3000.0 && OtherPlayer.GetTeamNum() != Team && FastTrace(P.Location, OtherPlayer.Pawn.Location))
			{
				Score -= (10000.0 - NextDist);
			}
		}
	}
	return FMax(Score, 5);
}

/**
 * This is called once the client has sent the server their unique net id.
 * It is now possible to set up their mute list.
 *
 * @param PC the playercontroller that is ready for updates
 */
function UpdateGameplayMuteList(PlayerController PC)
{
	local GearPC_MP WPC;

	WPC = GearPC_MP(PC);
	if (WPC != None)
	{
		// Party chat means we always use team lists in game
		InitTeamMuteList(WPC);
	}

	Super.UpdateGameplayMuteList(PC);
}

/** Make this player only talk to other spectators. */
function InitSpectateMuteList(GearPC_MP PC)
{
	local GearPC_MP OtherPC;

	PC.VoiceChannel = VC_SpectatorsDead;

	foreach WorldInfo.AllControllers(class'GearPC_MP',OtherPC)
	{
		if (OtherPC != PC && OtherPC.PlayerReplicationInfo != None)
		{
			// spectators can't talk to non-spectating/living players
			if (OtherPC.VoiceChannel != PC.VoiceChannel)
			{
				PC.GameplayMutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
				OtherPC.GameplayMutePlayer(PC.PlayerReplicationInfo.UniqueId);
			}
			else
			{
				PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
				OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
			}
		}
	}
}

/**
 * Reset everyone's channel to the same thing and then rebuild the gameplay
 * mute lists for each player
 */
function ResetGameplayMuting()
{
	local GearPC_MP PC;

	// Do a pass through resetting everyones voice channels
	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		PC.VoiceChannel = VC_SpectatorsDead;
	}
	// Do a second pass through rebuilding the mute list
	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		// Clear the gameplay mute list so everyone can talk to each other while traveling
		InitSpectateMuteList(PC);
	}
}

/**
 * Sets up the voice mute list based upon this player's team. Opponents are
 * added the specified player's mute list and vice versa.
 *
 * @param PC the player controller to initialize muting for
 */
function InitTeamMuteList(GearPC_MP PC)
{
	local TeamInfo Team;
	local GearPC_MP OtherPC;

	Team = PC.PlayerReplicationInfo.Team;
	// Spectators are channel 0, so use TeamIndex + 1 to select a unique voice channel
	PC.VoiceChannel = (Team != None && Team.TeamIndex != 255) ? Team.TeamIndex + 1 : 0;
	// Check all players
	foreach WorldInfo.AllControllers(class'GearPC_MP',OtherPC)
	{
		if (OtherPC != PC)
		{
			// Do the same channel calculation for the other PC
			Team = OtherPC.PlayerReplicationInfo.Team;
			OtherPC.VoiceChannel = (Team != None && Team.TeamIndex != 255) ? Team.TeamIndex + 1 : 0;
			// If not on the same team and not in the list already, mute
			if (OtherPC.VoiceChannel != PC.VoiceChannel)
			{
				PC.GameplayMutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
				OtherPC.GameplayMutePlayer(PC.PlayerReplicationInfo.UniqueId);
			}
			else
			{
				PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
				OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
			}
		}
	}
}

/** Called when someone is killed */
function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
	LastDownOrKillTime = WorldInfo.TimeSeconds;

	Super.NotifyKilled( Killer, Killed, KilledPawn, damageType );

	if ( ClassIsChildOf(damageType, class'GDT_Execution_Base')  )
	{
		bWasLastVictimExecution = true;
	}
	else
	{
		bWasLastVictimExecution = false;
	}
}

function NotifyDBNO(Controller InstigatedBy, Controller Victim, Pawn DownedPawn)
{
	LastDownOrKillTime = WorldInfo.TimeSeconds;
}

/** Returns the index of the team that should receive the next available player */
function int GetForcedTeam(Controller Other, int Team)
{
	local int Idx, TeamIdx;
	local UniqueNetId ZeroId;

	// If neutral, just leave them there. 255 *REALLY* means we want no team
	if ( Team == 255 )
	{
		return 255;
	}

	// verify team assignment matches host beacon team setup
	if (MatchType == eGVMT_Player &&
		GearPC_MP(Other) != None &&
		Other.PlayerReplicationInfo != None &&
		Other.PlayerReplicationInfo.UniqueId != ZeroId)
	{
		// check the expected team assignment from the host beacon for this player
		Team = HostPlayerMatchBeacon.GetTeamForCurrentPlayer(Other.PlayerReplicationInfo.UniqueId);
		// override team request with the team specified by the host beacon
		if (Team < 0)
		{
			`LogBeacon("Warning no team assignment found for "
				$OnlineSub.static.UniqueNetIdToString(Other.PlayerReplicationInfo.UniqueId));

			// force to observer if no team found from host beacon
			Team = 255;
		}
		return Team;
	}

	// Force team balancing for players vs bots
	if (Other.IsA('PlayerController') || Other.IsA('GearAI_TDM'))
	{
		if (bPlayersVsBots)
		{
			return (Other.IsA('PlayerController') ? 0 : 1);
		}

		if (Other.IsA('GearAI_TDM'))
		{
			TeamIdx = 0;
			for ( Idx = 1; Idx < NumTeams; Idx++ )
			{
				if ( Teams[TeamIdx].TeamMembers.Length > Teams[Idx].TeamMembers.Length )
				{
					TeamIdx = Idx;
				}
			}
			return TeamIdx;
		}
	}
	return Team;
}

/** cycles the PlayerStarts each team uses for the next round */
function CycleTeamPlayerStarts()
{
	local int i;

	for (i = 0; i < TeamPlayerStartIndex.length; i++)
	{
		TeamPlayerStartIndex[i] = (TeamPlayerStartIndex[i] + 1) % (MaxPlayerStartTeamIndex + 1);
	}
	LastTeamPlayerStartCycleTime = WorldInfo.TimeSeconds;
}

/**
 * tests for spawn point encroachment/camping
 * @param bTestCycle - true to test if the spawn points would be encroached if we cycled them (false to test on current spawn points)
 * @return whether a team's spawn point(s) are being encroached upon by the enemy
 */
function bool SpawnPointsAreEncroached(bool bTestCycle)
{
	local int i;
	local bool bResult;
	local NavigationPoint TeamStart;
	local Pawn P;
	local array<int> SavedPlayerStartIndex;

	if (bTestCycle)
	{
		SavedPlayerStartIndex = TeamPlayerStartIndex;
		for (i = 0; i < TeamPlayerStartIndex.length; i++)
		{
			TeamPlayerStartIndex[i] = (TeamPlayerStartIndex[i] + 1) % (MaxPlayerStartTeamIndex + 1);
		}
	}
	for (i = 0; i < Teams.length && !bResult; i++)
	{
		TeamStart = FindPlayerStart(None, i);
		if (TeamStart != None)
		{
			foreach WorldInfo.AllPawns(class'Pawn', P, TeamStart.Location, PlayerStartEncroachmentRadius)
			{
				if (P.Controller != None && P.GetTeamNum() != i && (GearPawn(P) == None || !GearPawn(P).IsAHostage()))
				{
					bResult = true;
					break;
				}
			}
		}
	}
	if (bTestCycle)
	{
		TeamPlayerStartIndex = SavedPlayerStartIndex;
	}

	return bResult;
}

/** divides up the players on each team into squads, mostly for AI purposes */
function CreateTeamSquads(optional int TeamNum = INDEX_NONE)
{
	local int i;

	if (TeamNum == INDEX_NONE)
	{
		for (i = 0; i < Teams.length; i++)
		{
			Teams[i].CreateMPSquads();
		}
	}
	else
	{
		Teams[TeamNum].CreateMPSquads();
	}
}

function bool ShouldReset(Actor ActorToReset)
{
	return ( ActorToReset.IsA('Pawn') || ActorToReset.IsA('GearDestructibleObject') || ActorToReset.IsA('GearDynamicDestructibleObject') ||
		(!bFirstRound && ActorToReset.IsA('DroppedPickup')) || ActorToReset.IsA('PickupFactory') || ActorToReset.IsA('GearProjectile') );
}

/**
 * Determine which players never made it into the match and remove them from the current game session.
 * Called when match is ready and all players are assumed to have connected.
 */
function RemoveMissingPlayersFromSession(name SessionName)
{
	local array<UniqueNetId> RegisteredPlayers;
	local UniqueNetId ZeroId;
	local int PRIIdx,PlayerIdx;

	if (OnlineSubsystemCommonImpl(OnlineSub) != None &&
		OnlineSub.GameInterface != None)
	{
		// list of players currently registered on the game session
		OnlineSubsystemCommonImpl(OnlineSub).GetRegisteredPlayers(SessionName,RegisteredPlayers);
		// Remove entries for players that have made it into the match with valid PRIs
		for (PRIIdx=0; PRIIdx < WorldInfo.GRI.PRIArray.Length; PRIIdx++)
		{
			for (PlayerIdx=0; PlayerIdx < RegisteredPlayers.Length; PlayerIdx++)
			{
				if (RegisteredPlayers[PlayerIdx] == WorldInfo.GRI.PRIArray[PRIIdx].UniqueId)
				{
					RegisteredPlayers.Remove(PlayerIdx,1);
					PlayerIdx--;
				}
			}
		}
		// Anything left over in the RegisteredPlayers list should now be removed from the game session
		for (PlayerIdx=0; PlayerIdx < RegisteredPlayers.Length; PlayerIdx++)
		{
			if (RegisteredPlayers[PlayerIdx] != ZeroId)
			{
				OnlineSub.GameInterface.UnregisterPlayer(SessionName,RegisteredPlayers[PlayerIdx]);
			}
		}
	}
}

/** Called when a match is started */
function StartMatch()
{
	local int i;
	local GearPC_MP PC;
	local Actor A;
	local GearGRI_MP GGRI;
	local GearAI_TDM Bot;
	local GearDedicatedServerInterface MasterServerInterface;
`if(`notdefined(FINAL_RELEASE))
	local bool bTeamAssignmentMade;
`endif

	// Clear data for the new round (winner / firstkill)
	GameReplicationInfo.Winner = None;
	FirstKill = None;

	// Turn on cheat detection for ranked or player matches (not private)
	if (bIsStandbyCheckingEnabled &&
		!bHasStandbyCheatTriggered)
	{
		// Turn on standby cheat detection
		EnableStandbyCheatDetection(true);
	}

	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		if (ProfilingFrequency > 0)
		{
			SetTimer(ProfilingFrequency, true, nameof(StartProfiling));
		}

		if (!bTestingDedicated && NumPlayers == 0)
		{
			// Restart the dedicated server because nobody made it into the game
			SetTimer(1.f, false, nameof(DedicatedServerRestart));
		}
		else if (OnlineSub != None)
		{
			MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
			if (MasterServerInterface != None)
			{
				MasterServerInterface.SetStatus(STATUS_RUNNING);
			}
		}
	}

	if (bFirstRound)
	{
		// allow missing players to remain in game session for arbitrated matches
		if (!bUsingArbitration)
		{
			// After all players have transitioned and are ready to start the initial round,
			// clear out anyone from the game session that never made it
			RemoveMissingPlayersFromSession('Game');
			RemoveMissingPlayersFromSession('Party');
		}

		// @STATS - MPBase Match Started
		`RecordGameIntStat(MATCH_STARTED, GameReplicationInfo.TimeLimit);
	}

	// if we didn't get the initial player count yet, do that now (happens when not using seamless travel)
	if (InitialPlayers == 0)
	{
		InitialPlayers = Clamp(GetNumPlayers() + RequestedBots, 0, MaxPlayers);
	}

	KillRemainingPlayers();

	foreach WorldInfo.AllControllers(class'GearAI_TDM', Bot)
	{
		if (Bot.Pawn != None)
		{
			Bot.PawnDied(Bot.Pawn);
		}
	}

	// reset stuff
	foreach DynamicActors(class'Actor', A)
	{
		if (ShouldReset(A))
		{
			A.Reset();
		}
	}

	if (!bFirstRound)
	{
		RandomizeWeaponPickupFactories();
	}

	bFirstRound = FALSE;

	// Right before starting match go ahead and collect garbage
	WorldInfo.ForceGarbageCollection();

	CycleTeamPlayerStarts();

`if(`notdefined(FINAL_RELEASE))
	PrintTeamAssignments("Start Match");
`endif
	// sanity check the team assignments for all current players
	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		//Non-spectators with no team or invalid team
		if (!PC.PlayerReplicationInfo.bOnlySpectator && (PC.PlayerReplicationInfo.Team == None || PC.PlayerReplicationInfo.Team.TeamIndex >= Teams.Length))
		{
			`log("Player with invalid team!"@PC.PlayerReplicationInfo.Team == None ? "No team info" : string(PC.PlayerReplicationInfo.Team.TeamIndex));
`if(`notdefined(FINAL_RELEASE))
			bTeamAssignmentMade = true;
`endif
			if (MatchType == eGVMT_Player)
			{
				// match up with host beacon team assignments
				PlacePlayerOnAssignedTeam(PC);
			}
			else
			{
				PlacePlayerOnSmallestTeam(PC);
			}
		}
	}

`if(`notdefined(FINAL_RELEASE))
	if (bTeamAssignmentMade)
	{
		PrintTeamAssignments("After Start Match Adjustments");
	}
`endif

	CreateTeamSquads();

	Super.StartMatch();

	// Iterate through and set up the team specific mute lists now that
	// people are no longer spectators
	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		InitTeamMuteList(PC);
		// Log everything out for MGS test automation
		PC.ClientLogMPTestAutomationData(WorldInfo.NetMode,true,MatchType);
	}

	// Check for the last man standing array in case a team has only 1 guy
	GGRI = GearGRI_MP(WorldInfo.GRI);
	for (i = 0; i < Teams.length; i++)
	{
		GGRI.LastStandingOnTeamName[i] = "";
		GGRI.TeamIndexLossOrder[i] = 0;
	}

	CheckForLastMenStanding();
}

/**
 * called for MP games.
 *
 * @see GearPawn:  state Reviving
 **/
function bool AutoReviveOnBleedOut( Pawn TestPawn )
{
	return bAutoReviveOnBleedOut;
}

/**
* called for MP games.
*
* @see WarPawn:  state Reviving
**/
function bool CanBeShotFromAfarAndKilledWhileDownButNotOut( Pawn TestPawn, Pawn InstPawn, class<GearDamageType> TheDamageType )
{
	return ((TheDamageType != None && TheDamageType.static.ShouldIgnoreExecutionRules(TestPawn,InstPawn)) || bCanBeShotFromAfarAndKilledWhileDownButNotOut);
}

/** Returns true if Viewer is allowed to spectate ViewTarget */
function bool CanSpectate( PlayerController Viewer, PlayerReplicationInfo ViewTarget )
{
	local UniqueNetId ZeroId;
	local int TeamIndex, TargetTeamIndex;

	if ( (ViewTarget == None) || ViewTarget.bOnlySpectator )
	{
		return false;
	}

	// Spectating player's team
	TeamIndex = 255;
	if (Viewer.PlayerReplicationInfo != None)
	{
		if (Viewer.PlayerReplicationInfo.Team != None)
		{
			TeamIndex = Viewer.PlayerReplicationInfo.GetTeamNum();
		}
		else if (MatchType == eGVMT_Player && Viewer.PlayerReplicationInfo.UniqueId != ZeroId)
		{
			// Get the team the player will be on so they can spectate early
			TeamIndex = HostPlayerMatchBeacon.GetTeamForCurrentPlayer(Viewer.PlayerReplicationInfo.UniqueId);
		}
	}

	// Target's team
	TargetTeamIndex = ViewTarget.GetTeamNum();

	return ( Viewer.PlayerReplicationInfo.bOnlySpectator || (TargetTeamIndex == TeamIndex) );
}


/** Whether this player is alive or not */
function bool PlayerIsAlive(Controller Player, Controller Killed)
{
	if( Player == Killed )
	{
		return FALSE;
	}

	if ( Player != None && !Player.bDeleteMe &&
		(!Player.IsDead() || Player.IsInState('Reviving')) &&
		!Player.IsSpectating() &&
		(Player.PlayerReplicationInfo.Team.TeamIndex >= 0 && Player.PlayerReplicationInfo.Team.TeamIndex < Teams.Length) &&
		// if last hitdamage is suicide they are dead
		(Player.Pawn == None || Player.Pawn.HitDamageType != class'GDT_Suicide') &&
		// special case bayonet draws to count both players as dead immediately
		(GearPawn(Player.Pawn) == None || (!GearPawn(Player.Pawn).IsDoingSpecialMove(SM_BayonetDraw_Leader) && !GearPawn(Player.Pawn).IsDoingSpecialMove(SM_BayonetDraw_Follower))) )
	{
		return TRUE;
	}

	return FALSE;
}

/** @return the number of players alive on Team 0 (the good guys) */
final function int GetNumPlayersAlive(int TeamIdx)
{
	local int i, Num;

	if ( (TeamIdx >= 0) && (TeamIdx < Teams.length) )
	{
		for (i = 0; i < Teams[TeamIdx].TeamMembers.length; i++)
		{
			if (PlayerIsAlive(Teams[TeamIdx].TeamMembers[i], None))
			{
				Num++;
			}
		}
	}

	return Num;
}

/** @return number of players amongs all teams that are respawning */
final function int GetTotalRespawningPlayers()
{
	local GearTeamInfo T;
	local Controller C;
	local int Num;

	foreach Teams(T)
	{
		foreach T.TeamMembers(C)
		{
			if (GearPRI(C.PlayerReplicationInfo).PlayerStatus == WPS_Respawning)
			{
				Num++;
			}
		}
	}

	return Num;
}

/** Record the names of the last man standing on each team */
function CheckForLastMenStanding(optional Controller LastKilled = none)
{
	local int TeamIdx, PlayerIdx, HighestLossCount;
	local array<String> AlivePlayerNames;
	local GearGRI_MP GGRI;

	GGRI = GearGRI_MP(WorldInfo.GRI);
	// Note we're only recording max one player per team
	AlivePlayerNames.length = Teams.length;

	// go through each team
	for ( TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++ )
	{
		GGRI.NumPlayersAliveOnTeam[TeamIdx] = 0;
		if ( Teams[TeamIdx] != None )
		{
			// go through each player
			for ( PlayerIdx = 0; PlayerIdx < Teams[TeamIdx].TeamMembers.Length; PlayerIdx++ )
			{
				// see if they are alive and have a pawn
				if ( PlayerIsAlive(Teams[TeamIdx].TeamMembers[PlayerIdx], LastKilled ) && (Teams[TeamIdx].TeamMembers[PlayerIdx].Pawn != None) )
				{
					// count them and record the name
					GGRI.NumPlayersAliveOnTeam[TeamIdx]++;
					AlivePlayerNames[TeamIdx] = Teams[TeamIdx].TeamMembers[PlayerIdx].Pawn.PlayerReplicationInfo.PlayerName;
				}
			}

			// Record the highest loss count so we can set the next team to lose all of it's players to the next value
			if ( HighestLossCount < GGRI.TeamIndexLossOrder[TeamIdx] )
			{
				HighestLossCount = GGRI.TeamIndexLossOrder[TeamIdx];
			}
		}
	}

	// go through teams again
	for ( TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++ )
	{
		if ( Teams[TeamIdx].TeamMembers.length <= 0 )
		{
			continue;
		}

		// if there's only one guy left, record his name
		if ( GGRI.NumPlayersAliveOnTeam[TeamIdx] == 1 )
		{
			GGRI.LastStandingOnTeamName[TeamIdx] = AlivePlayerNames[TeamIdx];
		}

		// if there's no guys left and we don't have a record for the team having been killed off, record it
		if ( (GGRI.NumPlayersAliveOnTeam[TeamIdx] <= 0) && (GGRI.TeamIndexLossOrder[TeamIdx] == 0) )
		{
			GGRI.TeamIndexLossOrder[TeamIdx] = HighestLossCount + 1;
		}
	}
}

/** Initiate bots */
function StartBots()
{
	local GearAI_TDM AI;
	foreach WorldInfo.AllControllers(class'GearAI_TDM', AI)
	{
		`log("starting AI:"@AI);
		RestartPlayer(AI);
		`log("- ai pawn:"@AI.Pawn@AI.GetStateName());
	}
}

/** Adds a bot to whatever team is TeamIdx - will default to non-COG team */
exec function GearAI_TDM AddBot(optional int TeamIdx = -1)
{
	local GearAI_TDM Bot;
	local GearVersusGameSettings MyGameSettings;
	local int IntValue;

	// check to see if we need to initialize teams
	if (Teams.Length < NumTeams)
	{
		InitializeTeams();
	}

	Bot = Spawn(class'GearAI_TDM');
	// auto balance if no team specified
	if (TeamIdx == -1)
	{
		TeamIdx = GetForcedTeam(Bot, 0);
	}
	// Bot Difficulty
	if (TrainingGroundsID >= 0 && TeamIdx == 0)
	{
		// in training grounds, we make the bots on the human team smarter (Normal instead of Casual)
		GearPRI(Bot.PlayerReplicationInfo).Difficulty = DifficultyLevels[1];
	}
	else if (bUsingArbitration || MatchType == eGVMT_Player)
	{
		// force Insane for arbitrated/ranked matches and for player matches
		GearPRI(Bot.PlayerReplicationInfo).Difficulty = DifficultyLevels[DifficultyLevels.length - 1];
	}
	else
	{
		MyGameSettings = GetGameSettingsObject();
		if (MyGameSettings != None &&  MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_BOTDIFFICULTY, IntValue))
		{
			GearPRI(Bot.PlayerReplicationInfo).Difficulty = DifficultyLevels[IntValue];
		}
		else
		{
			GearPRI(Bot.PlayerReplicationInfo).Difficulty = class'DifficultySettings'.static.GetLowestPlayerDifficultyLevel(WorldInfo);
		}
	}

	Bot.PlayerReplicationInfo.PlayerName = AIPrefix $ BotIndex;

	BotIndex++;
	bSkipForcedTeamCallHack = true;
	Bot.SetTeam(TeamIdx);
	bSkipForcedTeamCallHack = false;
	SetPlayerClass(Bot, Bot.GetTeamNum());
	Bot.GotoState('Dead');
	NumBots++;

	return Bot;
}

/**
 *  given player is logging out while in control of a Pawn, see if we should give a bot control of it
 */
function CheckReplaceWithBot(GearPC PC)
{
	local GearPawn GP;
	local GearPRI GPRI;
	local GearAI_TDM NewBot;
	local int TeamIdx, PCTeamIdx, NumTeamMembers;

	// Only care about multiplayer
	if (GearPC_MP(PC) == None)
	{
		return;
	}

	// Only if the player is on a team will he need replacing (he may be spectating or just joined)
	PCTeamIdx = PC.GetTeamNum();
	if (bCanSwapBotsAndPlayers && (PCTeamIdx >= 0 && PCTeamIdx < 255))
	{
		// Total active players (bots + humans)
		for (TeamIdx = 0; TeamIdx < NumTeams; TeamIdx++)
		{
			NumTeamMembers += Teams[TeamIdx].Size;
		}

		// Player hasn't been removed from his team yet
		if (bUsingArbitration || (NumTeamMembers - 1) < InitialPlayers)
		{
			NewBot = AddBot(PCTeamIdx);

			GP = GearPawn(PC.Pawn);
			if (GP != None && GP.Health > 0)
			{
				if (GP.IsDoingASpecialMove() && !GP.IsAKidnapper())
				{
					GP.EndSpecialMove();
				}
				// make sure that didn't kill it
				if (!GP.bDeleteMe && !GP.bTearOff && GP.Health > 0)
				{
					PC.Unpossess();
					NewBot.Possess(GP, false);
					GPRI = GearPRI(NewBot.PlayerReplicationInfo);
					ChangeName(NewBot, GPRI.PawnClass.default.CharacterName, false);
					GearPRI(NewBot.PlayerReplicationInfo).SetPlayerStatus(WPS_Alive);
					// Copy leader status
					GPRI.bIsLeader = GearPRI(PC.PlayerReplicationInfo).bIsLeader;
					// @STATS - Bot replacement spawn
					`RecordPlayerSpawn(NewBot,NewBot.Pawn.Class,NewBot.GetTeamNum());
				}
			}
		}
	}
}

/**
 * Notify clients to capture the PRI for stats reporting
 */
function WriteStatsForDroppedPlayer(GearPRI PRI, PlayerController PC)
{
	local GearPC OtherPC;
	local OnlineGameSettings GameSettings;

	// Only calc this if the subsystem can write stats
	if (OnlineSub != None &&
		OnlineSub.StatsInterface != None &&
		OnlineSub.GameInterface != None &&
		OnlineStatsWriteClass != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings(PRI.SessionName);
		if (GameSettings != None &&
			GameSettings.GameState == OGS_InProgress)
		{
			// Tell all clients to write out stats for this PRI now
			foreach WorldInfo.AllControllers(class'GearPC', OtherPC)
			{
				if (OtherPC != PC)
				{
					OtherPC.ClientWriteStatsForDroppedPlayer(OnlineStatsWriteClass, PRI);
				}
			}
		}
	}
}

function Logout(Controller Exiting)
{
	local UniqueNetId ZeroId;
	local GearPC PC;

	// This person has left during an arbitrated match
	// Called here before the PRI is destroyed and the player is Unregistered from the session
	if (bUsingArbitration && PlayerController(Exiting) != None)
	{
		WriteStatsForDroppedPlayer(GearPRI(Exiting.PlayerReplicationInfo), PlayerController(Exiting));
	}

	Super.Logout(Exiting);
	if (GearAI_TDM(Exiting) != None)
	{
		NumBots--;
	}

	// Cast just once
	PC = GearPC(Exiting);

	if (MatchType == eGVMT_Player &&
		PC != None &&
		PC.PlayerReplicationInfo != None &&
		PC.PlayerReplicationInfo.UniqueId != ZeroId)
	{
		// Update host beacon reservation slots when a player leaves
		// maintain party even when party leader leaves
		HostPlayerMatchBeacon.HandlePlayerLogout(PC.PlayerReplicationInfo.UniqueId,true);
	}

	if (PC != None &&
		MatchType != eGVMT_Player)
	{
		//Ranked / private horde update invites
		AllowJIPForParty();
	}
}

/**
 * Call the Multiplayer version of adding inventory.
 * @see RestartPlayer
 * @see AddDefaultInventory
 * @see SetPlayerDefaults
 */
function AddDefaultInventory(Pawn P)
{
	local GearWeapon W;

	GearPawn(P).AddDefaultInventoryTDM();
	P.CreateInventory(DefaultGrenadeClass, true);

	// don't allow them to respawn
	P.Controller.PlayerReplicationInfo.bOutOfLives = true;

	if (TrainingGroundsID >= 0 && P.IsHumanControlled())
	{
		foreach P.InvManager.InventoryActors(class'GearWeapon', W)
		{
			if (!W.IsA('GearWeap_GrenadeBase'))
			{
				W.SetInfiniteSpareAmmo();
			}
		}
	}
}

/** By default, everyone who comes in gets assigned to team 255 (spectator). */
function byte PickTeam(byte Current, Controller C)
{
	if ( bIsDedicatedListenServer || GearGRI.bMatchHasBegun )
	{
		if (bPlayersVsBots)
		{
			if (PlayerController(C) != None)
			{
				return 0;
			}
			else if (GearAI_TDM(C) != None)
			{
				return 1;
			}
		}
		return Super.PickTeam(Current, C);
	}
	else // Always start as a spectator
	{
		return 255;
	}
}

/**
 * if we have too many players in the game, attempt to kick out bots to make room
 * **NOTE** Doesn't take into account that midmatch you may have spectating players
 *			that are waiting for bots to die before joining in
 */
function KickExtraBots()
{
	local GearAI_TDM Bot;

`if(`notdefined(FINAL_RELEASE))
	PrintTeamAssignments("KickExtraBots BEFORE");
`endif

	if (NumPlayers + NumBots > MaxPlayers && NumBots > 0)
	{
		foreach WorldInfo.AllControllers(class'GearAI_TDM', Bot)
		{
			KillBot(Bot);
			if (NumPlayers + NumBots <= MaxPlayers || NumBots == 0)
			{
				break;
			}
		}
	}

`if(`notdefined(FINAL_RELEASE))
	PrintTeamAssignments("KickExtraBots AFTER");
`endif
}

/** Only show the lobby if we are waiting for the host */
function bool ShowLobby(GearPC LobbyTarget)
{
	return ( !LobbyTarget.bDedicatedServerSpectator && GearGRI.GameStatus == GS_WaitingForHost );
}

/** Returns the default player class for this player */
function class<Pawn> GetDefaultPlayerClass( Controller C )
{
	local GearPRI PRI;

	PRI = GearPRI(C.PlayerReplicationInfo);
	if (PRI != none)
	{
		if (PRI.PawnClass == None)
		{
			// fallback to make sure we got a valid class
			SetPlayerClass(C, C.GetTeamNum());
		}
		return PRI.PawnClass;
	}
	else
	{
		return Super.GetDefaultPlayerClass(c);
	}
}

/** called via delegate from the CharacterStore when it finishes loading a class */
function PawnClassLoaded(class<GearPawn> PawnClass)
{
	local GearPRI PRI;
	local int i;
	local byte CharIndex;
	local bool bFound;
	local GearPC_MP PC;
	local string PawnClassPath;

	// find any PRIs that want the loaded character and set it
	for (i = 0; i < GameReplicationInfo.PRIArray.length; i++)
	{
		PRI = GearPRI(GameReplicationInfo.PRIArray[i]);
		if (PRI != None && PRI.Team != None)
		{
			if (PRI.Team.TeamIndex == 0)
			{
				CharIndex = byte(PRI.PreferredCOGIndex);
			}
			else
			{
				CharIndex = byte(PRI.PreferredLocustIndex);
			}
			if (CharIndex != 255)
			{
				if (GetCharacterProviderClassName(PRI.Team.TeamIndex, CharIndex) ~= PathName(PawnClass))
				{
					PRI.PawnClass = PawnClass;
					// this class might need to be temporarily overridden with a gametype-specific class, so verify
					SetPlayerClass(Controller(PRI.Owner), PRI.Team.TeamIndex);

					bFound = true;
				}
			}
		}
	}


	if (bFound)
	{
		// prestream textures for this to-be-used class
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			PawnClass.default.Mesh.PrestreamTextures(5.0, false);
		}
	}
	else
	{
		// if no players were found to be using this class (whoever triggered the load has left) then discard it
		CharacterStore.LoadedClasses.RemoveItem(PawnClass);
		// tell clients
		PawnClassPath = PathName(PawnClass);
		foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
		{
			if (NetConnection(PC.Player) != None && ChildConnection(PC.Player) == None && PC.HasClientLoadedCurrentWorld())
			{
				PC.ClientUnloadCharacter(PawnClassPath);
			}
		}

		WorldInfo.ForceGarbageCollection();
	}
}

/**
 * Changes the character class for a player when the player chooses to switch characters.
 *
 * @param	WPRI				the PlayerReplicationInfo for the player changing character
 * @param	DesiredCharacterId	the id of the character to switch to; will be one of the values from either the ECogMPCharacter
 *								or ELocustMPCharacter enums, depending on the player's team.
 */
function SetPlayerClassFromPlayerSelection(GearPRI WPRI, byte DesiredCharacterId)
{
	local string DesiredClassPath;
	local class<GearPawn> DesiredClass;
	local GearPC_MP PC;
	local bool bReplicateLoad;

	if (WPRI.Team != None)
	{
		// get the class path for this ID
		DesiredClassPath = GetCharacterProviderClassName(WPRI.Team.TeamIndex, DesiredCharacterId);
		if (DesiredClassPath != "")
		{
			// try to find it in memory
			DesiredClass = class<GearPawn>(FindObject(DesiredClassPath, class'Class'));
			if (DesiredClass != None)
			{
				// need to make sure it's added to the list, since it's possible the class is loaded temporarily (Kismet reference, carried from previous level via PRI, etc)
				if (CharacterStore.LoadedClasses.Find(DesiredClass) == INDEX_NONE)
				{
					CharacterStore.LoadedClasses.AddItem(DesiredClass);
					// still tell clients since the same might not be true for them
					bReplicateLoad = true;
				}
				WPRI.SetPawnClass(DesiredClass);
			}
			// load it if we're in a state where that is allowed
			else if (IsInState('PendingMatch') && CharacterStore.PendingClasses.length + CharacterStore.LoadedClasses.length < 12)
			{
				CharacterStore.LoadPawnClass(DesiredClassPath);
				bReplicateLoad = true;
			}
			if (bReplicateLoad)
			{
				foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
				{
					if (NetConnection(PC.Player) != None && ChildConnection(PC.Player) == None && PC.HasClientLoadedCurrentWorld())
					{
						PC.ClientLoadCharacter(DesiredClassPath);
					}
				}
			}
		}
		else
		{
			`log("SetPlayerClassFromPlayerSelection failure:"@WPRI.PlayerName@"Team:"@WPRI.Team.TeamIndex@"CharProviderIdx"@DesiredCharacterId);
		}
	}
	else
	{
		`log("SetPlayerClassFromPlayerSelection failure:"@WPRI.PlayerName@"NO TEAM CharID"@DesiredCharacterId);
	}
}

function bool IsValidPawnClassChoice(int ClassIndex, int TeamNum)
{
	return true;
}

/**
 * Sets the player class for this player.  It first tries to assign a preferred class from the profile,
 * but will then attempt to find a class not used much.
 */
function SetPlayerClass(Controller Other, int N)
{
	local int i,j,l, PreferredIdx;
	local GearPRI PRI;
	local GearPC OtherPC;
	local array<int> ClassesCount;
	local array<string> ClassNamePieces;
	local string BotName;

	OtherPC = GearPC(Other);
	PRI = GearPRI(Other.PlayerReplicationInfo);

	// See if the player has a preferred class to use.
	if (OtherPC != None)
	{
		//@todo:  need to figure how to determine when we need to allow the preferred character instead of the
		// selected one (basically anytime the game forces the player to switch teams, but not when just traveling
		// between maps)
		PreferredIdx = (N == 0) ? PRI.PreferredCOGIndex : PRI.PreferredLocustIndex;
		if (PreferredIdx >= 0)
		{
			SetPlayerClassFromPlayerSelection(PRI, PreferredIdx);
		}
		// class might be invalid or async loading, set default as fallback
		if (PRI.PawnClass == None || PreferredIdx < 0)
		{
			PRI.SetPawnClass((N == 0) ? MPResourceClass.default.DefaultCOGClass : MPResourceClass.default.DefaultLocustClass);
		}
	}
	else
	{
		// use the AI's previous class, if any
		PreferredIdx = (N == 0) ? PRI.PreferredCOGIndex : PRI.PreferredLocustIndex;
		if (PreferredIdx >= 0)
		{
			SetPlayerClassFromPlayerSelection(PRI, PreferredIdx);
			// class might be invalid or async loading, set default as fallback
			if (PRI.PawnClass == None)
			{
				PRI.SetPawnClass((N == 0) ? MPResourceClass.default.DefaultCOGClass : MPResourceClass.default.DefaultLocustClass);
			}
		}
		if (PRI.PawnClass == None)
		{
			if (!bTourist)
			{
				// Generate Counts
				ClassesCount.length = (N == 0) ? MPResourceClass.default.COGClassPaths.length : MPResourceClass.default.LocustClassPaths.length;
				for (i = 0; i < GameReplicationInfo.PRIArray.length; i++)
				{
					PRI = GearPRI(GameReplicationInfo.PRIArray[i]);
					if (PRI != None)
					{
						PreferredIdx = (N == 0) ? PRI.PreferredCOGIndex : PRI.PreferredLocustIndex;
						if (PreferredIdx >= 0)
						{
							ClassesCount[PreferredIdx]++;
						}
					}
				}

				// Find the best Class
				j = Rand(ClassesCount.length);
				l = j;
				while (ClassesCount[j] > 0 || !IsValidPawnClassChoice(j, N))
				{
					j = (j + 1) % ClassesCount.Length;
					if (j == l)
					{
						break;
					}
				}
			}
			else
			{
				// @todo jm - can add some parsing to specify a specific character from the command line
				j = 0;
			}

			PRI = GearPRI(Other.PlayerReplicationInfo);
			SetPlayerClassFromPlayerSelection(PRI, j);
			// class might be invalid or async loading, set default as fallback
			if (PRI.PawnClass == None)
			{
				PRI.SetPawnClass((N == 0) ? MPResourceClass.default.DefaultCOGClass : MPResourceClass.default.DefaultLocustClass);
			}

			// save this class as the AI's preference so that if the game clobbers them (e.g. leader change) we can recover them
			if (N == 0)
			{
				PRI.PreferredCOGIndex = j;
			}
			else
			{
				PRI.PreferredLocustIndex = j;
			}
		}
		// make the AI's name match its character
		ParseStringIntoArray(GetCharacterProviderClassName(PRI.Team.TeamIndex, (N == 0) ? PRI.PreferredCOGIndex : PRI.PreferredLocustIndex), ClassNamePieces, ".", false);
		BotName = Localize(ClassNamePieces[1], "CharacterName", ClassNamePieces[0]);
		// make sure loc lookup was successful
		if (Left(BotName, 1) != "?")
		{
			ChangeName(Other, BotName @ AIPostfix, false);
		}
		else
		{
			`Warn("Failed to localize" @ ClassNamePieces[0] $ "." $ ClassNamePieces[1] $ "." $ ClassNamePieces[1] @ "for bot name");
		}
	}
}

/** Called when a player first enters the server */
event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
	local PlayerController PC;
	local GearPC_MP WPC;

	// All clients are spectators
	if (bTestingDedicated)
	{
		Options $= "?SpectatorOnly=1";
	}

	// First allow the super classes to do their thing, they will spawn a playercontroller
	// and take care of other fun stuff.
	PC = Super.Login(Portal, Options, UniqueId, ErrorMessage);

	// Set the newly created player to the neutral team position.
	WPC = GearPC_MP(PC);
	if ( WPC != none && WPC.bDedicatedServerSpectator )
	{
		ChangeTeam( WPC,255,false );
	}

	return PC;
}

/** Optional handling of ServerTravel for network games. Overwritten here so that we can set the game status. */
function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	local Pawn P;
	local GearPC_MP PCMP;

	// destroy all pawns before travelling
	foreach WorldInfo.AllPawns(class'Pawn',P)
	{
		P.Destroy();
	}

	if (UnscriptedDialogueManager != None)
	{
		// Explicitly kill the GUDS manager to tell clients to kill references
		UnscriptedDialogueManager.Destroy();
	}

	GearGRI.SetGameStatus( GS_Loading );

	// release ref to old battlecam path
	foreach WorldInfo.AllControllers(class'GearPC_MP', PCMP)
	{
		PCMP.BattleCamPath = None;
	}

	Super.ProcessServerTravel( URL, bAbsolute );

	// on dedicated servers, add a delay to the travel process to give clients a little more time to construct any meshes
	// since that process will get cut off when the server completely finishes traveling
	if (WorldInfo.NetMode == NM_DedicatedServer && WorldInfo.IsInSeamlessTravel())
	{
		WorldInfo.SetSeamlessTravelMidpointPause(true);
		SetTimer(FMax(DedicatedServerMapCycleDelay,20.0), false, 'ContinueSeamlessTravel');
	}
}

function ContinueSeamlessTravel()
{
	WorldInfo.SetSeamlessTravelMidpointPause(false);
}

event PostSeamlessTravel()
{
	Super.PostSeamlessTravel();

	InitialPlayers = Clamp(GetNumPlayers() + RequestedBots, 0, MaxPlayers);
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	local GearPC_MP PCMP;
	local GearPRI GPRI;
`if(`notdefined(dev_build))
	local PlayerController PC;
`endif

	if (C.IsA('GearAI'))
	{
		if (C.IsA('GearAI_TDM'))
		{
			NumBots++; // compensates for decrement in Logout()
		}

		// make sure to cleanup dangling team reference if only bots were on a team
		if (C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.Team != None && C.PlayerReplicationInfo.Team.Size <= 1)
		{
			`Log(`location @ "destroying"
				$" team="$C.PlayerReplicationInfo.Team);

			C.PlayerReplicationInfo.Team.Destroy();
		}

		C.Destroy();
	}
	else
	{
		`if(`notdefined(dev_build))
			// disable pausing once a nonlocal player joins
			PC = PlayerController(C);
		if (PC != None && LocalPlayer(PC.Player) == None && !AllowNetworkPause())
		{
			bPauseable = false;
			ClearPause();
		}
		`endif
			Super.HandleSeamlessTravelPlayer(C);

		GPRI = GearPRI(C.PlayerReplicationInfo);
		if ( GPRI != None && GPRI.PawnClass == None )
		{
			SetPlayerClass(C, C.GetTeamNum());
		}

		PCMP = GearPC_MP(C);
		if (PCMP != None)
		{
			// release ref to old path
			PCMP.BattleCamPath = None;
			// find path in new level
			PCMP.CacheBattleCamPath();
		}
	}
}

function SetSeamlessTravelViewTarget(PlayerController PC)
{
	// do nothing in this case since it's handled already
}

/** @return whether all players in the game have the specified map available to play (own any required DLC) */
final function bool IsMapAvailable(name MapName)
{
	local GearGameMapSummary MapSummary;
	local GearPC_MP PC;
	local GearPRI PRI;

	MapSummary = class'GearUIDataStore_GameResource'.static.GetMapSummaryFromMapName(string(MapName));
	if (MapSummary == None)
	{
		// server doesn't have the map
		return false;
	}
	else if (MapSummary.DLCId == 0)
	{
		// everyone should have this map as it shipped with the game
		return true;
	}
	else
	{
		foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
		{
			PRI = GearPRI(PC.PlayerReplicationInfo);
			if (PRI != None && (PRI.DLCFlag == -1 || (PRI.DLCFlag & (1 << MapSummary.DLCId)) == 0))
			{
				// this player doesn't have it
				return false;
			}
		}

		// everyone has the needed DLC
		return true;
	}
}

/** Returns the string name of the next map in the map cycle located in the player's profile. */
function string GetNextMap()
{
	local int Index, StartIndex;

`if(`notdefined(FINAL_RELEASE))
	local string MapName;
	//Allow QA to override the map played
	if (GetMapNameOverride(MapName) &&
		class'GearPreGameGRI'.static.GetMapNameFromCommandline(MapName) != INDEX_NONE)
	{
		`LogMatchmaking("QA Map Override to"@MapName);
		return MapName;
	}
`endif

	if (MapCycle.length == 0)
	{
		return "";
	}
	else
	{
		Index = MapCycle.Find(WorldInfo.GetPackageName());
		Index = (Index == INDEX_NONE) ? 0 : ((Index + 1) % MapCycle.length);
		StartIndex = Index;
		while (!IsMapAvailable(MapCycle[Index]))
		{
			`Log("Map cycle skipping" @ MapCycle[Index] @ "because not everyone has it");
			Index = (Index + 1) % MapCycle.length;
			if (Index == StartIndex)
			{
				`Warn("Failed to find a valid map to cycle to");
				return "";
			}
		}
		return string(MapCycle[Index]);
	}
}

/**
 * Called when the link status indicates the player has removed their network
 * connection. Used to mark them as losing.
 */
function SetHostTamperedWithMatch()
{
	bHostTamperedWithMatch = true;
}

/**
 * Tells each client to stream their teammates textures in for a number of seconds.
 */
function PrestreamTeamTextures()
{
	local GearPC_MP PC;

	foreach WorldInfo.AllControllers(class'GearPC_MP',PC)
	{
		PC.ClientPrestreamTeamSkins(GearGRI.RoundTime + 5.0);
	}
}

/** Trigger the SeqEvt_MPRoundStart event */
function TriggerRoundStartEvent( bool bIsCountdown )
{
	TriggerEventClass( class'SeqEvt_MPRoundStart', None, bIsCountdown?0:1 );
}

/** Trigger the SeqEvt_MPRoundEnd event */
function TriggerRoundEndEvent()
{
	TriggerEventClass( class'SeqEvt_MPRoundEnd', None );
}

/** Makes the host ready */
function ForceHostReady()
{
	local GearPC_MP PC;

	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
	  	bIsServerReady = TRUE;
	}
	else
	{
		foreach LocalPlayerControllers(class'GearPC_MP', PC)
		{
			if ( GearPRI(PC.PlayerReplicationInfo) != None )
			{
				GearPRI(PC.PlayerReplicationInfo).HostIsReady();
			}
		}
	}
}

/**
 * Wrapper for determining whether all required players are ready to play.
 */
function bool ArePlayersReady()
{
	local PlayerController PC;
	local GearPRI PRI;

	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		return bIsServerReady;
	}
	else
	{
		// look for the host ready flag
		foreach WorldInfo.AllControllers(class'PlayerController',PC)
		{
			PRI = GearPRI(PC.PlayerReplicationInfo);

			if (PRI != None && PRI.bHostIsReady)
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}

/** Check for minimum number of players */
function bool ArePlayersNeeded()
{
	// check for min players needed for a nonranked match
	return (!bTourist && NumPlayers + RequestedBots < MinPlayers);
}

/**
* Checks to see if the match is ready to be started, and starts it if so.  Here is what signals that the
* match is ready to start.
*/
function CheckStartMatch()
{
	if ( !ArePlayersNeeded() )
	{
		if (ArePlayersReady())
		{
			if (bTourist)
			{
				// skip the pre-round countdown in tourist mode
				StartMatch();
			}
			else
			{
				GotoState('PreRound');
			}
		}
		else
		{
			//`log("players aren't ready");
		}
	}
	else
	{
		//`log("need more players");
		// Since we don't have enough people to play, we keep resetting the Autostart clock
		GearGRI.ResetRoundClock(GearGRI.AutoStartDelay);
	}
}

function bool DestroyPickupOnReset(GearDroppedPickup DroppedPickup)
{
	// destroy pickups that were dropped by players
	// we can tell the difference because those dropped by factories (e.g. shields at initial spawn) have no Inventory
	return ( DroppedPickup.Inventory != None &&
		// Disallow removing coop weapons that are still hooked to a pickup that won't be removed
		(DroppedPickup.CoopWeaponSyncActor == None || DroppedPickup.CoopWeaponSyncActor.HasDroppedPickupCounterpart(DroppedPickup)) );
}

/** Called for each new round to clean up any actors that shouldn't persist for the entire match. */
function ResetLevelForNewRound()
{
	local GearGRI_MP GGRI;
	local GearMPPRI MPPRI;
	local DynamicSMActor_Spawnable SMActor_Spawnable;
	local GearProj_Grenade Grenade;
	local Actor Actor;
	local GearDroppedPickup DroppedPickup;
	local GearPC_MP PC;
	local Emit_StickyFire SF;
	local Emit_BouncyFire BF;
	local Pawn P;
	local int i;

	foreach DynamicActors(class'Actor', Actor)
	{
		// destroy any spawned static meshes
		SMActor_Spawnable = DynamicSMActor_Spawnable(Actor);
		if (SMActor_Spawnable != None)
		{
			SMActor_Spawnable.Destroy();
			continue;
		}
		// clean up prox grenades
		if (bEliminatePlantedGrenades)
		{
			Grenade = GearProj_Grenade(Actor);
			if (Grenade != None)
			{
				Grenade.Destroy();
				continue;
			}
		}
		// return functionality to any persistent Pawns (turrets, etc)
		P = Pawn(Actor);
		if (P != None)
		{
			P.bNoWeaponFiring = P.default.bNoWeaponFiring;
		}
		// if it's a pickup, maybe destroy it
		DroppedPickup = GearDroppedPickup(Actor);
		if (DroppedPickup != None)
		{
			if (DestroyPickupOnReset(DroppedPickup))
			{
				DroppedPickup.Destroy();
			}
			continue;
		}

		// clean up fire
		SF = Emit_StickyFire(Actor);
		if (SF != None)
		{
			SF.Destroy();
			continue;
		}
		BF = Emit_BouncyFire(Actor);
		if (BF != None)
		{
			BF.Destroy();
			continue;
		}
	}

	// Cleanup PRI variables for stat tracking
	GGRI = GearGRI_MP(WorldInfo.GRI);
	for (i=0;i<GGRI.PRIArray.Length;i++)
	{
		MPPRI = GearMPPRI(GGRI.PRIArray[i]);
		if (MPPRI != None)
		{
			MPPRI.CoverStartedTime = 0;
			MPPRI.NumSelfRevivesThisRound = 0;
			MPPRI.NumVulcanKillsThisRound = 0;
			MPPRI.NumSuddenDeathKillsThisRound = 0;
			MPPRI.LastKillerPRI = None;
		}
	}

	// ifdef out for ship
	// so if we are auto hording then start the killing in N seconds
	if (bDoAutomatedHordeTesting)
	{
		foreach WorldInfo.AllControllers( class'GearPC_MP', PC )
		{
			PC.ClearTimer( nameof(PC.Automation_KillAMob) );
			PC.SetTimer( 5.0f, FALSE, nameof(PC.Automation_KillMobs) );
		}
	}

	if( IsCheckingForMemLeaks() )
	{
		foreach WorldInfo.AllControllers( class'GearPC_MP', PC )
		{
			PC.Automation_MemoryChecking();
		}
	}
}

function bool ShouldRespawn(PickupFactory Other)
{
	return true;
}

function bool AllowHealthRecharge(GearPawn Pawn)
{
	local GearMutator GMut;

	// always allow recharge in MP, even for AI bots
	GMut = GetBaseGearMutator();
	return (GMut == None || GMut.AllowHealthRecharge(true, Pawn));
}

/** Put the game into sudden death if we have a 1 on 1 situation */
function CheckForSuddenDeath( array<Controller> AlivePlayers )
{
	if ( bCanGoSuddenDeathThisRound && !bIsInSuddenDeath )
	{
		if ( (AlivePlayers.length == 2) && (AlivePlayers[0].GetTeamNum() != AlivePlayers[1].GetTeamNum()) && (!bInfiniteRoundDuration && GetGRI().RoundTime > SuddenDeathTime) )
		{
			EnterSuddenDeath();
		}
	}
}

// See if this round can go sudden death
function CheckForSuddenDeathAvailability()
{
	bCanGoSuddenDeathThisRound = false;

	// Disable sudden death when in dev mode.
	if( bSupportsSuddenDeath && !bInDevMode )
	{
		if ( GetGRI().PRIArray.length > 2 )
		{
			bCanGoSuddenDeathThisRound = true;
		}
	}
}

/** Put the game into sudden death */
function EnterSuddenDeath()
{
	local GearPC_MP PC;

	bIsInSuddenDeath = true;
	GetGRI().RoundTime = SuddenDeathTime;

	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		PC.ClientStartSuddenDeathText();
	}
}

/** Clear the sudden death data */
function ClearSuddenDeath()
{
	bIsInSuddenDeath = false;
}

/** sends all players to the spectating state */
final function SendAllPlayersToSpectating()
{
	local Controller C;

	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (C.IsA('GearPC_MP') || C.IsA('GearAI_TDM'))
		{
			if (C.Pawn != None)
			{
				C.Pawn.bNoWeaponFiring = true;
			}
			C.SetTimer( class'GearHUDMP_Base'.default.TotalEndRoundTime, false, 'TransitionToSpectateFromEndOfRound' );
		}
	}
}

/** @return Actor the AI should move towards to complete game objectives (if any) */
function Actor GetObjectivePointForAI(GearAI AI);
/** @return whether the AI needs to stand on top of the objective point for it to count */
function bool MustStandOnObjective(GearAI AI);
/** sets the appropriate combat mood for the AI based on the current game state */
function SetAICombatMoodFor(GearAI AI);
/** adjust the AI's rating of the given enemy */
function AdjustEnemyRating(GearAI AI, out float out_Rating, Pawn EnemyPawn);


function bool ShouldUseBasePawnDefaults(GearPawn TestPawn)
{
	// use standardized defaults for everything player controlled except vehicles/ridables for competitive balance
	return ((PlayerController(TestPawn.Controller) != None || GearAI_TDM(TestPawn.Controller) != None) && GearPawnRidable_Base(TestPawn) == None);
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	local GearPawn GP;

	if(MaxDownCountOverride != -1)
	{
		GP = GearPawn(PlayerPawn);
		if ( GP != None )
		{
			GP.MaxDownCount = MaxDownCountOverride;
		}
	}
	Super.SetPlayerDefaults(PlayerPawn);

	// in the tutorial give the human more health
	if (TrainingGroundsID != INDEX_NONE && PlayerPawn.IsHumanControlled())
	{
		GP = GearPawn(PlayerPawn);
		if (GP != None)
		{
			GP.DefaultHealth *= 1.5;
			GP.HealthMax *= 1.5;
			GP.Health = GP.DefaultHealth;
		}
	}
}

/**
 * Changes the invite state of the Party session to allow for JIP.
 */
function AllowJIPForParty()
{
	local OnlineGameSettings GameSettings, PartySettings;
	local int MatchModeIdx;

	if (GameInterface != None)
	{
		GameSettings = GameInterface.GetGameSettings('Game');
		PartySettings = GameInterface.GetGameSettings('Party');
		if (GameSettings != None && PartySettings != None)
		{
			MatchModeIdx = eGVMT_Custom;
			GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchModeIdx);

			switch (MatchModeIdx)
			{
			case eGVMT_Official:
			case eGVMT_Custom:
				// JIP not allowed for ranked matches
				if (GameSettings.bUsesArbitration ||
				// JIP disabled via invite when already full
					NumPlayers >= PartySettings.NumPublicConnections)
				{
					TellClientsToSetPartyInviteFlags(false,false,false);
				}
				else
				{
					// Allow for JIP via invite for private matches
					TellClientsToSetPartyInviteFlags(true,false,false);
				}
				break;
			// case eGVMT_Player: see UpdatePlayerMatchInvites() for invite handling
			}
		}
	}
}

/**
 * Updates the given client's rich presence to include the current map and gametype
 * @param PC - the PlayerController to update
 */
function SetVersusRichPresenceString(GearPC PC)
{
	local GearGRI_MP GRI;
	local OnlineGameSettings GameSettings;
	local byte MapNameId;
	local byte MpType;
	local byte StringToUse;
	local int MatchModeIdx;
	local string MapName;

	if (OnlineSub != None)
	{
		GRI = GearGRI_MP(WorldInfo.GRI);

		// Current map
		MapName = WorldInfo.GetMapName();
		MapNameId = byte(class'GearLeaderboardSettings'.static.GetMapIdFromName(name(MapName)));

		// Current game mode
		MpType = class'GearUIManager'.static.GetMPGameTypeStatic(GRI);

		// Match Mode
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
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
			GameSettings = OnlineSub.GameInterface.GetGameSettings('Party');
			// Is this a system link match?
			if (GameSettings == None || GameSettings.bIsLanMatch)
			{
				StringToUse = CONTEXT_PRESENCE_SYSTEMLINKVERSUSPRESENCE;
			}
		}

		PC.ClientSetVersusRichPresenceString(StringToUse, MpType, MapNameId);
	}
}

/** Spawn pawns at their given factories */
function SpawnPawnsFromFactories()
{
	local int SpawnIdx;
	local GearPawn GP;
	local GearPawnFactory Factory;

	// Loop through each spawn point
	for (SpawnIdx = 0; SpawnIdx < GearPawnFactoryList.length; SpawnIdx++)
	{
		// Get a reference to the spawn point and see if it has a valid ridable type
		Factory = GearPawnFactoryList[SpawnIdx];
		if (Factory != none && Factory.PawnType != none)
		{
			// Spawn the pawn
			GP = Spawn(Factory.PawnType, self,, Factory.Location, Factory.Rotation);
			// Couldn't spawn the pawn so log an error
			if (GP != none)
			{
				SetPlayerDefaults(GP);
			}
			else
			{
				`log("Error: Unable to spawn a ridable pawn" @ Factory.PawnType @ Factory);
			}
		}
	}
}

/** A period has started, tell all clients that care
 *	@param RecordingPeriod The period that has just started
 */
function PeriodStarted(ERecordingPeriodType RecordingPeriod)
{
	local PlayerController PC;
	local GearPC GPC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		GPC = GearPC(PC);
		if (GPC != None)
		{
			GPC.ClientPeriodStarted(RecordingPeriod);
		}
	}
}

/** debug output for current team assignments */
exec function PrintTeamAssignments(string Label)
{
	local int TeamIdx, PlayerIdx;
	local GearPC_MP PC;
	local GearAI AIC;

	// Avoid log spam for now.
	return;

	`log("------------->"@Label@"<-----------------",,'Gear_General');

	`log("InitialPlayers "@InitialPlayers,,'Gear_General');
	`log("MaxPlayers     "@MaxPlayers,,'Gear_General');
	`log("NumPlayers     "@NumPlayers,,'Gear_General');
	`log("NumBots        "@NumBots,,'Gear_General');
	`log("NumTeams       "@NumTeams,,'Gear_General');
	for (TeamIdx=0;TeamIdx<NumTeams;TeamIdx++)
	{
		`log("---Team"@Teams[TeamIdx].TeamIndex@"---",,'Gear_General');
		`log("TeamSize: "@Teams[TeamIdx].Size,,'Gear_General');
		`log("Bots:     "@Teams[TeamIdx].GetBotCount(),,'Gear_General');
		`log("Humans:   "@Teams[TeamIdx].GetHumanCount(),,'Gear_General');
		for (PlayerIdx=0;PlayerIdx<Teams[TeamIdx].TeamMembers.length;PlayerIdx++)
		{
			`log("--"@Teams[TeamIdx].TeamMembers[PlayerIdx].PlayerReplicationInfo.PlayerName@(GearPRI(Teams[TeamIdx].TeamMembers[PlayerIdx].PlayerReplicationInfo).bIsLeader)?"Leader":"",,'Gear_General');
		}
	}

	foreach WorldInfo.AllControllers(class'GearAI', AIC)
	{
		if (AIC.PlayerReplicationInfo != None)
		{
			if (AIC.PlayerReplicationInfo.bOnlySpectator)
			{
				`log("Spectator"@AIC.PlayerReplicationInfo.PlayerName,,'Gear_General');
			}
			else if (AIC.PlayerReplicationInfo.Team == None)
			{
				`log("Unassigned Bot:"@AIC.PlayerReplicationInfo.PlayerName,,'Gear_General');
			}
		}
		else
		{
			`log("BOT No PRI"@AIC,,'Gear_General');
		}
	}

	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		if (PC.PlayerReplicationInfo != None)
		{
			if (PC.PlayerReplicationInfo.bOnlySpectator)
			{
				`log("Spectator"@PC.PlayerReplicationInfo.PlayerName@(GearPRI(PC.PlayerReplicationInfo).bIsLeader)?"Leader":"",,'Gear_General');
			}
			else if (PC.PlayerReplicationInfo.Team == None)
			{
				`log("Unassigned Player:"@PC.PlayerReplicationInfo.PlayerName@(GearPRI(PC.PlayerReplicationInfo).bIsLeader)?"Leader":"",,'Gear_General');
			}
		}
		else
		{
			`log("PC No PRI"@PC,,'Gear_General');
		}
	}
}

/**
 * Rebalance teams on the host beacon based on current player level.
 */
function PlayerMatchRebalanceTeams()
{
	local int PRIIdx;
	local GearPRI PRI;
	local GearPC_MP PC;
	local UniqueNetId ZeroId;

	if (HostPlayerMatchBeacon != None)
	{
`if(`notdefined(FINAL_RELEASE))
		`LogBeacon("BEFORE update skill");
		HostPlayerMatchBeacon.DumpReservations();
`endif

		// Update with new player XP levels in the host beacon
		for (PRIIdx=0; PRIIdx < GearGRI.PRIArray.Length; PRIIdx++)
		{
			PRI = GearPRI(GearGRI.PRIArray[PRIIdx]);
			if (PRI.UniqueId != ZeroId && PRI.PlayerSkill > 0)
			{
				HostPlayerMatchBeacon.UpdatePlayerReservationSkills(PRI.UniqueId,PRI.PlayerSkill,PRI.PlayerLevel);
			}
		}

		// rebalance teams based on players' XP level before traveling to the next map cycle
		HostPlayerMatchBeacon.RebalanceTeamAssignments();
		// place players on their new teams
		foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
		{
			if (!PC.PlayerReplicationInfo.bOnlySpectator)
			{
				PlacePlayerOnAssignedTeam(PC);
			}
		}

`if(`notdefined(FINAL_RELEASE))
		`LogBeacon("AFTER update skill");
		HostPlayerMatchBeacon.DumpReservations();
`endif
	}
}

/** @return whether we should allow the given player that has requested gameplay aid to receive it */
final function bool ShouldGiveNewbHelpTo(GearPC_MP TestPlayer)
{
	return (bAllowNewbHelp && TestPlayer.bRequestedNewbHelp && (MatchType == eGVMT_Official || MatchType == eGVMT_Player));
}

/************************************************************************
 *						PreRound State Begin
 * This is the State that the game will enter when between rounds.  It does nothing
 * but watch the RoundTime.  When it hits 0, the round begins via StartMatch()
================================================================================ */
state PreRound
{
	// Notify the GRI of the Game's status.  We make a distinction regarding round 0
	// just in case we need to utilize it elsewhere
	function BeginState(Name PreviousStateName)
	{
		bHasArbitratedHandshakeBegun = true;

		PrepareNextRound();

		// Balance new players (possibly removing bots)
		PreRoundTeamAssignment();

		// Tell all clients to prestream their team's textures
		PrestreamTeamTextures();

		if (IsInitialRound())
		{
			// Setup a timer to clear previous match stats always (JIP clears in PostLogin)
			SetTimer(HostStartDelay + ClearLastMatchResultsDelay, false, nameof(ClearLastMatchResults));
		}

		// Have players register with the object that tracks stats for the post game results, so we can track drops
		SetTimer(1.0, false, nameof(InitLastMatchResults));

		// Send an event to kismet that the countdown for the start of a round is beginning
		TriggerRoundStartEvent( true );

		// if we are playing a ranked (arbitrated) match, balance the teams with bots
		if (bUsingArbitration && bCanSwapBotsAndPlayers)
		{
			TeamBalanceForArbitration();
		}

		// If this is host migration and the first round, update last known team scores
		if (GameHostMigrationManager != None && IsInitialRound())
		{
			GameHostMigrationManager.UpdateTeamData(GearGRI);
		}
	}

	/** Assign teams to newly joined players (social/custom) */
	function PreRoundTeamAssignment()
	{
		local GearPC_MP PC;
		local GearAI_TDM Bot;
		local array<int> SmallestTeams;
		local array<GearAI_TDM> BotsToReplace;
		local int TeamIndex, TeamNum, SmallTeamIdx;

`if(`notdefined(FINAL_RELEASE))
		PrintTeamAssignments("PREROUND ASSIGNMENTS");
`endif

		// Place players on the correct team based on host beacon team assignments
		// When players join they default to team 255 while the match is in progress.
		if (MatchType == eGVMT_Player)
		{
			foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
			{
				if (!PC.PlayerReplicationInfo.bOnlySpectator)
				{
					PlacePlayerOnAssignedTeam(PC);
				}
			}
		}
		else
		{
			// Private Match
			if (bUsingArbitration == FALSE)
			{
				//Add any newcomers to a team by killing already existing bots on that team
				foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
				{
					// No team -> spectator (255)
					if (PC.PlayerReplicationInfo.Team == None && !PC.PlayerReplicationInfo.bOnlySpectator)
					{
						TeamNum = 255;

						// Update smallest team each go 'round
						GetSmallestTeams(SmallestTeams);

						// If there is only one smallest team, join it to even the teams
						if (SmallestTeams.length == 1)
						{
							TeamNum = SmallestTeams[0];
						}
						else if (SmallestTeams.length > 1)
						{
							// Multiple small teams
							if (NumBots == 0 || (Teams.length > SmallestTeams.length))
							{
								// No bots left, spawn now randomly   OR
								// There is some larger team, so spawn immediately on a random smallest team
								TeamNum = SmallestTeams[Rand(SmallestTeams.length)];
							}
							else
							{
								BotsToReplace.length = 0;
								// There must be bots left and teams are even, find a candidate bot
								foreach WorldInfo.AllControllers(class'GearAI_TDM', Bot)
								{
									TeamIndex = Bot.PlayerReplicationInfo.Team.TeamIndex;
									for (SmallTeamIdx=0; SmallTeamIdx<SmallestTeams.length; SmallTeamIdx++)
									{
										if (TeamIndex == SmallestTeams[SmallTeamIdx])
										{
											BotsToReplace.AddItem(Bot);
											break;
										}
									}
								}

								// Replacing a bot from the stack of bots on smallest teams
								if (BotsToReplace.length > 0)
								{
									Bot = BotsToReplace[Rand(BotsToReplace.length)];
									TeamNum = Bot.PlayerReplicationInfo.Team.TeamIndex;
									`log("-----------------> Swapping"@PC.PlayerReplicationInfo.PlayerName@"for bot"@Bot.PlayerReplicationInfo.PlayerName);
									KillBot(Bot);
								}
								// TeamNum == 255 here means there are no bots at the moment
							}
						}

						if (TeamNum != 255)
						{
							ChangeTeam( PC, TeamNum, false );
							break;
						}
					}
				}

				KickExtraBots();
			}
		}

`if(`notdefined(FINAL_RELEASE))
		PrintTeamAssignments("AFTER PREROUND ASSIGNMENTS");
`endif
	}

	function TeamBalanceForArbitration()
	{
		local int TeamIndex, TeamMemberIndex, MaxTeamSize, CurrTeamSize, BotDelta;

`if(`notdefined(FINAL_RELEASE))
		PrintTeamAssignments("PREROUND ARBITRATION FIXUP");
`endif

		if (ClassIsChildOf(Class, class'GearGameWingman_Base'))
		{
			// Wingman is always its original team size (2)
			MaxTeamSize = PlaylistTeamSize;
		}
		else
		{
			// Find the team with the most humans
			MaxTeamSize = Teams[0].GetHumanCount();
			for (TeamIndex=1; TeamIndex<Teams.length; TeamIndex++)
			{
				CurrTeamSize = Teams[TeamIndex].GetHumanCount();
				if (MaxTeamSize < CurrTeamSize)
				{
					MaxTeamSize = CurrTeamSize;
				}
			}
		}

		// For every team, add/kill bots until we are at the above threshold
		for (TeamIndex=0; TeamIndex<Teams.length; TeamIndex++)
		{
			BotDelta = Teams[TeamIndex].Size - MaxTeamSize;
			if (BotDelta > 0)
			{
				// Remove bots
				for (TeamMemberIndex=0; TeamMemberIndex<Teams[TeamIndex].Size && BotDelta > 0; TeamMemberIndex++)
				{
					if (GearAI_TDM(Teams[TeamIndex].TeamMembers[TeamMemberIndex]) != None)
					{
						Teams[TeamIndex].TeamMembers[TeamMemberIndex].Destroy();
						BotDelta--;
						TeamMemberIndex--;
					}
				}
			}
			else if (BotDelta < 0)
			{
				BotDelta = -BotDelta;
				// Add bots
				for (TeamMemberIndex=0;TeamMemberIndex<BotDelta;TeamMemberIndex++)
				{
					AddBot(Teams[TeamIndex].TeamIndex);
				}
			}
		}

`if(`notdefined(FINAL_RELEASE))
		PrintTeamAssignments("PREROUND ARBITRATION AFTER FIXUP");
`endif
	}

	/** Prepare for the next round */
	function PrepareNextRound()
	{
		if (IsInitialRound())
		{
			GearGRI.SetGameStatus(GS_PreMatch);
			RandomizeWeaponPickupFactories();
		}
		else
		{
			// set the game status
			GearGRI.SetGameStatus(GS_RoundOver);
			SendAllPlayersToSpectating();
			NewRound();
			`log("New round in:"@EndOfRoundDelay);
		}
	}

	/** See if the match should start yet */
	function CheckStartRound()
	{
		if ( GearGRI.RoundTime <= 0 )
		{
			// clean up any actors created in the last round
			ResetLevelForNewRound();
			// start the match
			StartMatch();
		}
	}

	//Overridden here to immediately place players on assigned team so they appear on the scoreboard
	function PostLogin(PlayerController NewPlayer)
	{
		local int TeamId;

		Global.PostLogin(NewPlayer);

		TeamId = 255;
		if (!bUsingArbitration)
		{
`if(`notdefined(FINAL_RELEASE))
			PrintTeamAssignments("PREROUND Post Login");
`endif
			// Check for host migration
			if (GameHostMigrationManager != None)
			{
				TeamId = GameHostMigrationManager.GetTeamId(GearPRI(NewPlayer.PlayerReplicationInfo));
			}
			if (TeamId != 255)
			{
				// Assign the team from the host migration data
				ChangeTeam(NewPlayer,TeamId,false);
			}
			else if (MatchType == eGVMT_Player)
			{
				// match up with host beacon team assignments
				PlacePlayerOnAssignedTeam(GearPC(NewPlayer));
			}
			else if (!NewPlayer.PlayerReplicationInfo.bOnlySpectator)
			{
				// Kick extra bots first
				KickExtraBots();
				// Put player on the newly smallest team
				PlacePlayerOnSmallestTeam(NewPlayer);
			}

			// make sure voice chat is properly setup
			InitTeamMuteList(GearPC_MP(NewPlayer));

`if(`notdefined(FINAL_RELEASE))
			PrintTeamAssignments("PREROUND Post Login AFTER");
`endif
		}
	}

Begin:
	Sleep(0.2f);
	CheckStartRound();
	Goto('Begin');
}
/************************************************************************
*						PreRound State End
************************************************************************/

/** @return Determines if this is the first round of the match or not */
function bool IsInitialRound()
{
	return GearGRI.RoundCount == 0 ||
		(GameHostMigrationManager != None && GearGRI.RoundCount == GameHostMigrationManager.GameData.RoundCount);
}

/************************************************************************
 *						PendingMatch State Begin
 *	This is the State that the game will be in before a match is ready to play.
 *	We will use this state to watch for either the time-out, Host/AllPlayers being
 *	ready and if it occurs, we will transition in to PreMatch.  The game will only
 *	enter this state once (the first time).  Each additional time the game will
 *	enter PreMatch.
 ************************************************************************/
auto state PendingMatch
{
	event BeginState(name PreviousStateName)
	{
		// @STATS - begin logging MP/Horde/Siege matches
		StartLogging();

		// don't allow the match to start yet
		if (GameReplicationInfo != None)
		{
			GameReplicationInfo.bMatchHasBegun = false;
		}

		bWaitingToStartMatch = true;

		AcquireSpectatorPoints();

		// Signal the GRI that we are in PendingMatch
		GearGRI.SetGameStatus(GS_WaitingForHost);

		if (!bUsingArbitration)
		{
			SetTimer((WorldInfo.NetMode == NM_Standalone) ? 0.1f : 10.0f, false, nameof(ForceHostReady));
		}

		PeriodStarted(GEARPERIOD_Game);
	}

	event EndState(name NextStateName)
	{
		PlayerMatchRebalanceTeams();
		while (RequestedBots > NumBots && NumPlayers + NumBots < MaxPlayers)
		{
			AddBot();
		}
	}

	/**
	 * After transitioning from the pregame lobby, it checks that all players have
	 * arrived, that their PRIs are set up properly, and that they have acked the
	 * server for the PC type transition
	 */
	function CheckStartMatch()
	{
		local bool bDedicatedWait;
		local int ReadyPlayers;
		local int StalePCCount;
		local int Index;
		local UniqueNetId ZeroId;
		local PlayerController PC;
		local GearPRI PRI;
		local OnlineRecentPlayersList RecentPlayersList;

		// Dedicated servers need to wait a little bit before moving on in social
		if (WorldInfo.NetMode == NM_DedicatedServer && MatchType == eGVMT_Player)
		{
			if (`TimeSince(WaitForTravelingPlayersStart) < MaxWaitForFirstPlayer)
			{
				bDedicatedWait = true;
			}
		}

		// When this is zero, everyone is in the game
		if (!bDedicatedWait && NumTravellingPlayers == 0)
		{
			RecentPlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
			// Iterate the controller list and tell them to register with arbitration
			foreach WorldInfo.AllControllers(class'PlayerController', PC)
			{
				// We need to wait until all stale PCs have been removed
				if (PC.class == class'GearPreGamePC')
				{
					StalePCCount++;
				}
			}
			// Don't bother checking as long as there are PCs from the previous level around
			if (StalePCCount == 0)
			{
				// Count the number of players that are ready (replicated IDs, etc.)
				for (Index = 0; Index < GameReplicationInfo.PRIArray.Length; Index++)
				{
					PRI = GearPRI(GameReplicationInfo.PRIArray[Index]);
					if (!PRI.bBot &&
						!PRI.bFromPreviousLevel &&
						 PRI.UniqueId != ZeroId &&
						 PRI.PreferredCOGIndex != -1 &&
						 PRI.PreferredLocustIndex != -1)
					{
						ReadyPlayers++;
					}
				}
			}
			// The number of public connections shrinks when players logout, so this is safe/correct to check
			if (RecentPlayersList != None && ReadyPlayers >= RecentPlayersList.GetCurrentPlayersListCount())
			{
				// Start if everyone has made it
				GotoState('PreRound');
			}
		}
		else
		{
			// Not everyone has travelled yet
			GearGRI.ResetRoundClock(GearGRI.AutoStartDelay);
		}
		// Always start if they haven't traveled in time (no deadlocks)
		if (NumPlayers > 0 && `TimeSince(WaitForTravelingPlayersStart) > MaxWaitForTravelingPlayers)
		{
			`Log("Starting match without waiting for players due to timeout");
			GotoState('PreRound');
		}
	}

	// Overridden here to immediately place players on assigned team so they appear on the scoreboard
	function PostLogin(PlayerController NewPlayer)
	{
		local int TeamId;

		Global.PostLogin(NewPlayer);

		if (!bUsingArbitration)
		{
`if(`notdefined(FINAL_RELEASE))
			PrintTeamAssignments("PENDINGMATCH Post Login");
`endif

			// Check for host migration
			TeamId = (GameHostMigrationManager != None) ? GameHostMigrationManager.GetTeamId(GearPRI(NewPlayer.PlayerReplicationInfo)) : 255;
			if (TeamId != 255)
			{
				// Assign the team from the host migration data
				ChangeTeam(NewPlayer, TeamId, false);
			}
			else if (MatchType == eGVMT_Player)
			{
				// match up with host beacon team assignments
				PlacePlayerOnAssignedTeam(GearPC(NewPlayer));
			}
			else if (!NewPlayer.PlayerReplicationInfo.bOnlySpectator)
			{
				// Kick extra bots first
				KickExtraBots();
				// Put player on the newly smallest team
				PlacePlayerOnSmallestTeam(NewPlayer);
			}

			// make sure voice chat is properly setup
			InitTeamMuteList(GearPC_MP(NewPlayer));

`if(`notdefined(FINAL_RELEASE))
			PrintTeamAssignments("PENDINGMATCH Post Login AFTER");
`endif
		}
	}

Begin:
	InitializeGameOnFirstTick();
	// Start tracking how long we've waited for players
	WaitForTravelingPlayersStart = WorldInfo.TimeSeconds;

BeginAgain:
	// check if we should start without waiting for input
	if (IsAutomatedPerfTesting() || bQuickStart)
	{
		GotoState('PreRound');
	}
	// Don't wait for remote players to fully transition if we are standalone or local only
	if (WorldInfo.NetMode == NM_Standalone || GameInterface == None || GameInterface.GetGameSettings('Game') == None)
	{
		Global.CheckStartMatch();
	}
	else
	{
		CheckStartMatch();
	}
	Sleep(0.5f);	// Up the frequency so it's more responsive since we aren't doing actual timing here
	Goto('BeginAgain');
}
/************************************************************************
 *						PendingMatch State End
 ************************************************************************/

function bool HandleTeamWin(int WinningTeamIdx);

/** A round has ended, tell all clients */
function RoundEnded()
{
	local int WinningTeamIndex;
	local Controller C;
	local GearPC_MP GPC;
	local int HighScore;
	local bool bIsWinner, bIsFirst, bIsDraw;

	HighScore = -99999999;

	WinningTeamIndex = -1;
	if (GameReplicationInfo.Winner != None)
	{
		WinningTeamIndex = TeamInfo(GameReplicationInfo.Winner).TeamIndex;
	}
	else
	{
		bIsDraw = true;
	}

	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (HighScore < C.PlayerReplicationInfo.Score)
		{
			HighScore = C.PlayerReplicationInfo.Score;
		}
	}

	foreach WorldInfo.AllControllers(class'GearPC_MP', GPC)
	{
		bIsFirst = false;
		bIsWinner = false;
		if (GPC != None)
		{
			if (GPC.PlayerReplicationInfo.Score == HighScore)
			{
				bIsFirst = true;
			}
			if (GPC.PlayerReplicationInfo.Team != None &&
				GPC.PlayerReplicationInfo.Team.TeamIndex == WinningTeamIndex)
			{
				bIsWinner = true;
			}
			GPC.ClientStatRoundEnded(bIsWinner, bIsDraw, bIsFirst);
		}
	}
}

/************************************************************************
 *						MatchInProgress State Begin
 *	This is the state the game will be in while the match is in
 *  progress. The game will remain in this state until the end of match
 *  condition is met.
 ************************************************************************/
state MatchInProgress
{
	/** Overridden to update the game status. */
	function BeginState(Name PreviousStateName)
	{
		local Controller C;
		local GearPC_MP PC;

		// @STATS - MPBase Round Started (1 based)
		`RecordGameIntStat(ROUND_STARTED,GearGRI.RoundCount + 1);

		Super.BeginState(PreviousStateName);

		GearGRI.SetGameStatus(GS_RoundInProgress);

		if ( RespawnTimeInterval > 0 )
		{
			GearGRI.RespawnTime = RespawnTimeInterval;
			SetTimer(1.0f, TRUE, nameof(RespawnTimerUpdate));
		}

		if (!bSkipRoundStartGUDs)
		{
			// beginning of round comments
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_VersusRoundBegunCOG, None,, 1.f);
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_VersusRoundBegunLocust, None,, 1.f);
		}

		// Send an event to kismet that the round is beginning
		TriggerRoundStartEvent( false );

		// See if this round can go sudden death
		CheckForSuddenDeathAvailability();

		bLastKillerSet = false;

		// Run any pawn factories
		if (bUsePawnFactories)
		{
			SpawnPawnsFromFactories();
		}

		//Reset the match history
		foreach WorldInfo.AllControllers(class'Controller', C)
		{
			PC = GearPC_MP(C);
			if ( PC != None )
			{
				PC.ClientResetMatchHistory();
			}
		}

		PeriodStarted(GEARPERIOD_Round);
	}

	/** Don't allow JIP to change teams until the current round is over
     * @param PC player to place on a team
     * @param BotToSwapOut bot to remove from the game once this player is added to the team
     */
	function PlacePlayerOnAssignedTeam(GearPC PC, optional GearAI_TDM BotToSwapOut = None)
	{
		// for Horde allow JIP at any time
		if (PlaylistTeamCount == 1)
		{
			Global.PlacePlayerOnAssignedTeam(PC);
		}
	}

	/** Overridden to update the game status. */
	function EndState(Name NextStateName)
	{
		local GearGRI GRI;
		GRI = GetGRI();

		Super.EndState(NextStateName);

		ClearTimer('CheckEndMatch');
		ClearTimer( 'RespawnTimerUpdate' );

		// Clear the sudden death data
		ClearSuddenDeath();

		bOverTime = false;

		// Send an event to kismet that the round ended
		TriggerRoundEndEvent();

		// Lets the scoreboard know who was dead at the end of the round
		PreparePostRoundScoreboardData();

		RoundEnded();

		// @STATS - MPBase Round Ended (1 based)
		`RecordGameIntStat(ROUND_ENDED,GRI.RoundCount + 1);

		GetGRI().RoundCount = (GetGRI().RoundCount + 1) % 100;
	}

	/** Called every RespawnTimeInterval to respawn dead players */
	function RespawnTimerUpdate()
	{
		// negative values for RespawnTime indicate a paused timer (e.g. because no one is in the queue)
		if (GearGRI.RespawnTime >= 0)
		{
			GearGRI.RespawnTime--;
			GearGRI.RespawnTimeUpdated();
			if (GearGRI.RespawnTime <= 0)
			{
				GearGRI.RespawnTime = RespawnTimeInterval;
				BroadcastRespawnMessage();
			}
		}
	}

	/**
	 * Tells players that they can respawn, possibly replacing bots with players that just logged in
	 * Logic is as follows:
	 * PlayerMatch - try to replace respawning bots with waiting players on same team, or spawn waiting players if no bots on that team
	 * PrivateMatch - balance teams if necessary, then try to replace respawning bots with waiting players, or spawn waiting players to random team if no bots at all
	 * RankedMatch - can't respawn newly logged in players (this should never even happen)
	 */
	function BroadcastRespawnMessage()
	{
		local GearPRI WaitingPRI;
		local GearPC_MP WaitingPC;
		local GearAI_TDM Bot;
		local array<int> SmallestTeams;
		local int TeamNum, SpawnIter, BotIter, PlayersToSpawnCount, BotsToSpawnCount;
		local array<GearPC_MP> PlayersToSpawn;
		local array<GearAI_TDM> BotsToSpawn;

		PlayersToSpawnCount = 0;
		BotsToSpawnCount = 0;

		//All player candidates to spawn
		foreach WorldInfo.AllControllers(class'GearPC_MP', WaitingPC)
		{
			if (WaitingPC != None)
			{
				WaitingPRI = WaitingPC.GetPRI();
				if (!WaitingPRI.bOnlySpectator)
				{
					if (WaitingPC.bWaitingToRespawn)
					{
						//Respawn players already in game immediately
						RestartPlayer(WaitingPC);
					}
					else if (!bUsingArbitration)
					{
						if (WaitingPRI.Team == None && WaitingPRI.PreferredCOGIndex != -1 && WaitingPRI.PlayerStatus == WPS_Spectating)
						{
							// These are new players that want in the game
							// Iterator starts with newest players, so add back to front to ensure FIFO
							PlayersToSpawn.InsertItem(0, WaitingPC);
							PlayersToSpawnCount++;
						}
					}
				}
			}
		}

		//All bot candidates to spawn
		foreach WorldInfo.AllControllers(class'GearAI_TDM', Bot)
		{
			if (Bot != None && Bot.IsDead())
			{
				WaitingPRI = GearPRI(Bot.PlayerReplicationInfo);
				if (WaitingPRI.PlayerStatus == WPS_Spectating && ShouldRespawnPC(Bot.GetTeamNum(), Bot))
				{
					StartRespawning(Bot);
				}
				if (WaitingPRI.PlayerStatus == WPS_Respawning)
				{
					// these are bots that want in the game
					BotsToSpawn.length = BotsToSpawnCount + 1;
					BotsToSpawn[BotsToSpawnCount] = Bot;
					BotsToSpawnCount++;
				}
			}
		}

`if(`notdefined(FINAL_RELEASE))
		if (PlayersToSpawnCount > 0 && BotsToSpawnCount > 0)
		{
			PrintTeamAssignments("Broadcast Respawn BEFORE");
		}
`endif

		//For each player that's spawning, remove a bot from his team if they exist
		if (!bUsingArbitration && PlayersToSpawnCount > 0)
		{
			//Find the smallest team for private match use
			for (SpawnIter=0; SpawnIter < PlayersToSpawnCount; SpawnIter++)
			{
				WaitingPC = PlayersToSpawn[SpawnIter];
				if (MatchType == eGVMT_Player)
				{
					//Player Match
					TeamNum = HostPlayerMatchBeacon.GetTeamForCurrentPlayer(WaitingPC.PlayerReplicationInfo.UniqueId);
					if (TeamNum >= 0 && TeamNum < 255)
					{
						Bot = None;
						for (BotIter=0; BotIter<BotsToSpawn.length; BotIter++)
						{
							//Find a bot teammate to replace
							if (BotsToSpawn[BotIter].PlayerReplicationInfo.Team.TeamIndex == TeamNum)
							{
								Bot = BotsToSpawn[BotIter];
								BotsToSpawn.Remove(BotIter, 1);
								break;
							}
						}

						//If there is a bot teammate to replace or there are no more bots on the assigned team, spawn
						if (Bot != None || Teams[TeamNum].GetBotCount() == 0)
						{
							Global.PlacePlayerOnAssignedTeam(WaitingPC, Bot);
							// make sure voice chat is properly setup
							InitTeamMuteList(WaitingPC);
							if (Bot != None || ShouldRespawnPC(TeamNum, WaitingPC))
							{
								if (Bot == None)
								{
									StartRespawning(WaitingPC);
								}
								RestartPlayer(WaitingPC);
							}
						}
					}
					else
					{
						`Log(`location @ ": No matching team found! Returning to main menu"
							$" UniqueId="$OnlineSub.static.UniqueNetIdToString(WaitingPC.PlayerReplicationInfo.UniqueId));

						// Must have a valid team assignment on the beacon otherwise you get kicked back to the main menu
						WaitingPC.ClientReturnToMainMenu();
					}
				}
				else
				{
					// Update smallest team each go 'round
					GetSmallestTeams(SmallestTeams);

					//Private Match
					TeamNum = 255;

					//If there is only one smallest team, join it to even the teams
					if (SmallestTeams.length == 1)
					{
						TeamNum = SmallestTeams[0];
					}
					else if (SmallestTeams.length > 1)
					{
						// Multiple small teams
						if (NumBots == 0 || (Teams.length > SmallestTeams.length))
						{
							// No bots left, spawn now randomly   OR
							// There is some larger team, so spawn immediately on a random smallest team
							TeamNum = SmallestTeams[Rand(SmallestTeams.length)];
						}
						else
						{
							// There must be bots left and teams are even

							// Replacing a bot from the stack of respawning bots
							if (BotsToSpawn.length > 0)
							{
								Bot = BotsToSpawn[0];
								BotsToSpawn.Remove(0, 1);
								TeamNum = Bot.PlayerReplicationInfo.Team.TeamIndex;
								KillBot(Bot);
							}
							// TeamNum == 255 here means there are no respawning bots at the moment
						}
					}

					if (TeamNum != 255)
					{
						ChangeTeam(WaitingPC, TeamNum, false);
						// make sure voice chat is properly setup
						InitTeamMuteList(WaitingPC);
						if (Bot != None || ShouldRespawnPC(TeamNum, WaitingPC))
						{
							if (Bot == None)
							{
								StartRespawning(WaitingPC);
							}
							RestartPlayer(WaitingPC);
						}
					}
				}
			}
		}

		//Spawn remaining bots
		for (SpawnIter=0; SpawnIter < BotsToSpawn.length; SpawnIter++)
		{
			RestartPlayer(BotsToSpawn[SpawnIter]);
		}

`if(`notdefined(FINAL_RELEASE))
		if (PlayersToSpawnCount > 0 && BotsToSpawnCount > 0)
		{
			PrintTeamAssignments("Broadcast Respawn AFTER");
		}
`endif
	}

	function CycleTeamPlayerStarts()
	{
		local PlayerController PC;

		Global.CycleTeamPlayerStarts();

		// play audio to notify players
  		foreach WorldInfo.AllControllers(class'PlayerController', PC)
  		{
			if (PC != None)
			{
				if (MPResourceClass.default.SpawnSwapSound != None)
				{
					PC.ClientPlaySound(MPResourceClass.default.SpawnSwapSound);
				}
				PC.ClientPlaySound(EnemyRespawningSound[PC.GetTeamNum()]);
			}
		}
	}

	/** See if the condition has been met to end the round */
	function bool MatchEndCondition( Controller Killed )
	{
		local int TeamIdx, Idx, NumTeamsAlive;
		local Controller Player;

		// for each team,
		for (TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++)
		{
			if( Teams[TeamIdx] == None )
			{
				continue;
			}
			// check for alive players
			for (Idx = 0; Idx < Teams[TeamIdx].TeamMembers.Length; Idx++)
			{
				Player = Teams[TeamIdx].TeamMembers[Idx];
				if ( PlayerIsAlive(Player, Killed) || TeamHasRespawn(Player.PlayerReplicationInfo.Team.TeamIndex) ||
					(GearPC_MP(Player) != None && GearPC_MP(Player).bWaitingToRespawn) )
				{
					NumTeamsAlive++;
					break;
				}
			}
		}

		return (NumTeamsAlive <= 1);
	}

	/** Checks to see if only one team is surviving.  And if so, do some end of match cleanup etc. */
	function bool CheckEndMatch( optional Controller Killed )
	{
		local int TeamIdx, Idx, NumTeamsAlive, WinningTeamIdx;
		local Controller Player;
		local array<Controller> AlivePlayers;
		local bool bTeamIsAlive;

		// don't allow match to end if we're changing levels (avoid incorrect awards as players get disconnected)
		if (bLevelChange || WorldInfo.NextURL != "")
		{
			return false;
		}

		// default to draw
		WinningTeamIdx = -1;

		// for each team,
		for (TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++)
		{
			if( Teams[TeamIdx] == None )
			{
				continue;
			}

			bTeamIsAlive = false;

			// check for alive players
			for (Idx = 0; Idx < Teams[TeamIdx].TeamMembers.Length; Idx++)
			{
				Player = Teams[TeamIdx].TeamMembers[Idx];
				//@FIXME: does the check for PCs need to be different?
				if ( PlayerIsAlive(Player, Killed) || TeamHasRespawn(Player.PlayerReplicationInfo.Team.TeamIndex) || (GearPC_MP(Player) != None && GearPC_MP(Player).bWaitingToRespawn) ||
					(GearAI_TDM(Player) != None && GearPRI(Player.PlayerReplicationInfo).PlayerStatus == WPS_Respawning) )
				{
					bTeamIsAlive = true;
					AlivePlayers.AddItem(Player);
				}
			}

			// Mark the team as being alive
			if ( bTeamIsAlive )
			{
				NumTeamsAlive++;
				WinningTeamIdx = TeamIdx;
			}
		}

		// if both teams are dead (e.g. A kills B and B managed to kill A with delayed explosion, then we need to make certain that the one who fired first gets credit)
		if ( NumTeamsAlive == 0 )
		{
			if ( LastKiller != None && LastKiller.PlayerReplicationInfo != None && LastKiller.PlayerReplicationInfo.Team != None &&
				// special case to stalemate on mutual retro charge kill
				(GearPawn(LastKiller.Pawn) == None || (!GearPawn(LastKiller.Pawn).IsDoingSpecialMove(SM_BayonetDraw_Leader) && !GearPawn(LastKiller.Pawn).IsDoingSpecialMove(SM_BayonetDraw_Follower))) )
			{
				WinningTeamIdx = LastKiller.PlayerReplicationInfo.Team.TeamIndex;
			}
		}

		if( NumTeamsAlive <= 1 )
		{
			if (bIsInSuddenDeath && NumPlayers > 2 && AlivePlayers.length == 1 && GearPC(AlivePlayers[0]) != None)
			{
				// @AWARD - Better Man
				GearPC(AlivePlayers[0]).NotifyEarnedAward('BetterMan');
			}

			return HandleTeamWin( WinningTeamIdx );
		}
		else
		{
			CheckForSuddenDeath( AlivePlayers );
		}

		// Check to see if the round is over
		if ( !bInfiniteRoundDuration )
		{
			// See if round is over
			if ( GearGRI.RoundTime <= 0 )
			{
				return HandleRoundTimerExpired();
			}
		}

		return false;
	}

	function bool HandleTeamWin( int WinningTeamIdx )
	{
		local GearGRI_MP GGRI;
		local int TeamIdx, WinningTeamIdxOverride, NumNonZeroScores;
		local Controller Player;
		local int MaxScore, MinDeaths, MaxDeaths, MaxAssists, MaxRevives, MaxTimeInCover, MaxExecutions, MaxLeaderSaves, MaxRingPoints;
		local float KDRatio, MaxKDRatio;
		local array<Controller> DeadWinners;
		local GearMPPRI MPPRI;
		local GearPC GPC;

		GGRI = GearGRI_MP(GameReplicationInfo);
		if (WinningTeamIdx == -1)
		{
			GameReplicationInfo.Winner = None;
			if (LastVictim != None)
			{
				GGRI.FinalVictim = LastVictim.PlayerReplicationInfo;
			}
		}
		else
		{
			GameReplicationInfo.Winner = Teams[WinningTeamIdx];
			if (LastVictim != None)
			{
				GGRI.FinalVictim = LastVictim.PlayerReplicationInfo;
			}
			if ( LastKiller != None )
			{
				GGRI.FinalKiller = LastKiller.PlayerReplicationInfo;
			}

			`log("Team"@WinningTeamIdx+1@"has won the round!");

			if (bScoreRoundWin)
			{
				// award the score to the winning team
				Teams[WinningTeamIdx].Score += 1;
			}

			// See if there is still a team to player.
			for ( TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++ )
			{
				if ( TeamIdx != WinningTeamIdx )
				{
					if ( Teams[TeamIdx].TeamMembers.Length > 0 )
					{
						// Found a non-winning team with players on it so we're good for next round.
						break;
					}
				}
			}

			// end the game if no one left on losing teams
			if ( TeamIdx >= Teams.Length )
			{
				// Award the game to another team if the host cheated.
				if ( bHostTamperedWithMatch )
				{
					Teams[WinningTeamIdx].Score = 0;
					// Swap the winning team with a losing team... grab the first loser.
					// @TODO: We need to base the winner off of the last loser alive.
					for ( TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++ )
					{
						if ( WinningTeamIdx != TeamIdx )
						{
							WinningTeamIdx = TeamIdx;
							break;
						}
					}
					GameReplicationInfo.Winner = Teams[WinningTeamIdx];
				}
				// Set the winning team to win all round since there is no more opponents.
				Teams[WinningTeamIdx].Score = GoalScore;
			}

			// Give the game type a chance to override who actually wins the game
			WinningTeamIdxOverride = HandleWinningTeamOverride( WinningTeamIdx );

			if ( (WinningTeamIdxOverride != -1) && (WinningTeamIdxOverride != WinningTeamIdx) )
			{
				WinningTeamIdx = WinningTeamIdxOverride;
				GameReplicationInfo.Winner = Teams[WinningTeamIdx];
			}
			// send a notification for certain gametypes to handle
			TeamHasWon(WinningTeamIdx);
		}

		if (WinningTeamIdx != -1  &&
			(WinningTeamIdxOverride != -1) &&
			(Teams[WinningTeamIdx].Score >= GoalScore) &&
			CheckEndGame(LastKiller != None ? LastKiller.PlayerReplicationInfo : None, "LastMan") )
		{
			// @STATS - MPBase Round Won
			`RecordTeamIntStat(ROUND_WON, Teams[WinningTeamIdx], 1);
			// @STATS - MPBase Match Won
			`RecordTeamIntStat(MATCH_WON, Teams[WinningTeamIdx], 1);

			// Check for a match skunk
			NumNonZeroScores = 0;
			for (TeamIdx=0; TeamIdx<Teams.length; TeamIdx++)
			{
				if (Teams[TeamIdx].Score > 0)
				{
					NumNonZeroScores++;
				}
			}

			MinDeaths = 999;

			// record stats for win/loss
			foreach WorldInfo.AllControllers(class'Controller',Player)
			{
				GPC = GearPC(Player);
				if (Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.Team == Teams[WinningTeamIdx])
				{
					if (GearMenuPC(Player) == None && GearDemoRecSpectator(Player) == None)
					{
						// @STATS - MPBase Match Won per player
						`RecordPlayerIntStat(MATCH_WON,Player,1);
						// @STATS - MPBase Round Won per player
						`RecordPlayerIntStat(ROUND_WON,Player,1);
					}

					if (GPC != None)
					{
						if (bIsTrainingGrounds)
						{
							// @ACHIEVEMENT - Back To Basic
							GPC.ClientUnlockAchievement(eGA_BACKTOBASIC);
						}

						if (NumPlayers > 1)
						{
							MPPRI = GearMPPRI(Player.PlayerReplicationInfo);
							if (NumNonZeroScores == 1 && Teams[WinningTeamIdx].Score > 1)
							{
								// @AWARD - Skunked (matches played with rounds greater than 1)
								GPC.NotifyEarnedAward('Skunked');
							}

							if (MPPRI.NumSuddenDeathKillsThisRound >= 3)
							{
								// @AWARD - Clutch
								GPC.NotifyEarnedAward('Clutch');
							}

							if (LastVictim != None &&
								GGRI.GameClass.Name != 'GearGameCTL' &&
								GGRI.GameClass.Name != 'GearGameKOTH')
							{
								if (LastKiller == Player)
								{
									// @AWARD - Final Word
									GPC.NotifyEarnedAward('LastKill');
								}

								if (bWasLastVictimExecution)
								{
									// @AWARD - End Big
									GPC.NotifyEarnedAward('EndBig');
								}
							}
						}
					}

					if (!PlayerIsAlive(Player, None))
					{
						DeadWinners.AddItem(Player);
					}
				}
				else if (Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.Team != None)
				{
					// @STATS - MPBase Match Lost per player
					`RecordPlayerIntStat(MATCH_WON,Player,0);
					// @STATS - MPBase Round Lost per player
					`RecordPlayerIntStat(ROUND_WON,Player,0);
				}

				// Only humans count in the ribbon giving even if bots are better
				if (NumPlayers > 1 && GPC != None && GPC.PlayerReplicationInfo != None && GPC.PlayerReplicationInfo.Team != None && GPC.PlayerReplicationInfo.Team.TeamIndex != 255)
				{
					MPPRI = GearMPPRI(Player.PlayerReplicationInfo);

					if (MPPRI.CoverStartedTime > 0)
					{
						// Round end update cover
						MPPRI.TotalTimeInCoverThisRound += `TimeSince(MPPRI.CoverStartedTime);
						MPPRI.TotalTimeInCover += `TimeSince(MPPRI.CoverStartedTime);
						MPPRI.CoverStartedTime = 0;
						MPPRI.bNetDirty = true;
					}

					if (MPPRI.NumFirstKills > 0 && MPPRI.NumFirstKills == Teams[WinningTeamIdx].Score)
					{
						// @AWARD - Aggressor
						GPC.NotifyEarnedAward('Aggressor');
					}

					if (MPPRI.NumLastKills > 0 && MPPRI.NumLastKills == Teams[WinningTeamIdx].Score)
					{
						// @AWARD - Cleaner
						GPC.NotifyEarnedAward('Cleaner');
					}

					if (MPPRI.NumExecutions > 0 && MPPRI.NumExecutions == MPPRI.Score_Kills)
					{
						// @AWARD - Methodical
						GPC.NotifyEarnedAward('Methodical');
					}

					// Highest Score
					if (MPPRI.Score > MaxScore)
					{
						MaxScore = MPPRI.Score;
					}

					if (MPPRI.Deaths > 0)
					{
						KDRatio = MPPRI.Score_Kills / MPPRI.Deaths;
					}
					else
					{
						if (GGRI.GameClass.Name == 'GearGameWingman')
						{
							// @AWARD - Rear Guard
							GPC.NotifyEarnedAward('RearGuard');
						}

						if (MPPRI.Score_Kills >= 10)
						{
							// @AWARD - Vigilant
							GPC.NotifyEarnedAward('Vigilant');
						}

						KDRatio = MPPRI.Score_Kills;
					}

					if (KDRatio >= 1)
					{
						// @AWARD - Solid
						GPC.NotifyEarnedAward('Solid');
					}

					// K/D
					if (KDRatio > MaxKDRatio)
					{
						MaxKDRatio = KDRatio;
					}

					// Least Deaths
					if (MPPRI.Deaths < MinDeaths)
					{
						MinDeaths = MPPRI.Deaths;
					}

					// Most Deaths
					if (MPPRI.Deaths > MaxDeaths)
					{
						MaxDeaths = MPPRI.Deaths;
					}

					// Most Executions
					if (MPPRI.NumExecutions > MaxExecutions)
					{
						MaxExecutions = MPPRI.NumExecutions;
					}

					// Most Assists
					if (MPPRI.Score_Assists > MaxAssists)
					{
						MaxAssists = MPPRI.Score_Assists;
					}

					// Most Revives
					if (MPPRI.Score_Revives > MaxRevives)
					{
						MaxRevives = MPPRI.Score_Revives;
					}

					// Most Time in Cover
					if (MPPRI.TotalTimeInCover > MaxTimeInCover)
					{
						MaxTimeInCover = MPPRI.TotalTimeInCover;
					}

					// Most leader saves
					if (GGRI.GameClass.Name == 'GearGameCTL')
					{
						if (MPPRI.Score_GameSpecific4 > MaxLeaderSaves)
						{
							MaxLeaderSaves = MPPRI.Score_GameSpecific4;
						}
					}

					// Most ring points
					if (GGRI.GameClass.Name == 'GearGameKOTH')
					{
						if (MPPRI.ExpBuckets[eEXP_Objectives] > MaxRingPoints)
						{
							MaxRingPoints = MPPRI.ExpBuckets[eEXP_Objectives];
						}
					}
				}
			}

			// Award "best of"
			if (NumPlayers > 1)
			{
				foreach WorldInfo.AllControllers(class'Controller',Player)
				{
					GPC = GearPC(Player);
					if (GPC != None && GPC.PlayerReplicationInfo != None && GPC.PlayerReplicationInfo.Team != None && GPC.PlayerReplicationInfo.Team.TeamIndex != 255)
					{
						MPPRI = GearMPPRI(Player.PlayerReplicationInfo);

						if (MaxScore > 0 && MPPRI.Score == MaxScore)
						{
							// @AWARD - MVP
							GPC.NotifyEarnedAward('MVP');
						}

						if (MPPRI.Deaths > 0)
						{
							KDRatio = MPPRI.Score_Kills / MPPRI.Deaths;
						}
						else
						{
							KDRatio = MPPRI.Score_Kills;
						}

						if (MaxKDRatio > 0 && KDRatio == MaxKDRatio)
						{
							// @AWARD - Smooth Operator
							GPC.NotifyEarnedAward('SmoothOperator');
						}

						if (MaxDeaths > 0)
						{
							if (MPPRI.Deaths == MinDeaths)
							{
								// @AWARD - Hard Target (Tough Guy)
								GPC.NotifyEarnedAward('HardTarget');
							}
							else if (MPPRI.Deaths == MaxDeaths)
							{
								// @AWARD - Bullet Magnet
								GPC.NotifyEarnedAward('BulletMagnet');
							}
						}

						if (MaxExecutions > 0 && MPPRI.NumExecutions == MaxExecutions)
						{
							// @AWARD - Executioner
							GPC.NotifyEarnedAward('Executioner');
						}

						if (MaxAssists > 0 && MPPRI.Score_Assists == MaxAssists)
						{
							// @AWARD - Team Player
							GPC.NotifyEarnedAward('TeamPlayer');
						}

						if (MaxRevives > 0 && MPPRI.Score_Revives == MaxRevives)
						{
							// @AWARD - Johnny On The Spot
							GPC.NotifyEarnedAward('JohnnyOnTheSpot');
						}

						if (MaxTimeInCover > 0 && MPPRI.TotalTimeInCover >= MaxTimeInCover)
						{
							// @AWARD - Buttoned Up
							GPC.NotifyEarnedAward('ButtonedUp');
						}

						if (MaxLeaderSaves > 0 && MPPRI.Score_GameSpecific4 == MaxLeaderSaves)
						{
							// @AWARD - Valiant
							GPC.NotifyEarnedAward('Valiant');
						}

						if (MaxRingPoints > 0 && MPPRI.ExpBuckets[eEXP_Objectives] == MaxRingPoints)
						{
							// @AWARD - Eye On The Prize
							GPC.NotifyEarnedAward('EyeOnThePrize');
						}
					}
				}

				if (RespawnTimeInterval == 0 && DeadWinners.Length == 1 && !DeadWinners[0].PlayerReplicationInfo.bBot)
				{
					// @AWARD - Unlucky Bastard(non-respawn gametypes)
					GearPC(DeadWinners[0]).NotifyEarnedAward('UnluckyBastard');
				}
			}

			GotoState('MatchOver');
			return true;
		}
		else
		{
			// Watch out for stalemates
			if (WinningTeamIdx != -1)
			{
				// @STATS - MPBase Round Won
				`RecordTeamIntStat(ROUND_WON, Teams[WinningTeamIdx], 1);
			}
			else
			{
				for (TeamIdx=0; TeamIdx<Teams.length; TeamIdx++)
				{
					// @STATS - MPBase Round Stalemate
					`RecordTeamIntStat(ROUND_STALEMATE, Teams[TeamIdx], 1);
				}
			}

			// record stats for win/loss
			foreach WorldInfo.AllControllers(class'Controller',Player)
			{
				MPPRI = GearMPPRI(Player.PlayerReplicationInfo);

				if (WinningTeamIdx != -1)
				{
					if (Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.Team == Teams[WinningTeamIdx])
					{
						if (GearMenuPC(Player) == None && GearDemoRecSpectator(Player) == None)
						{
							// @STATS - MPBase Round Won per player
							`RecordPlayerIntStat(ROUND_WON,Player,1);
						}

						if (NumPlayers > 1)
						{
							GPC = GearPC(Player);
							if (GPC != None)
							{
								if (MPPRI.NumSuddenDeathKillsThisRound >= 3)
								{
									// @AWARD - Clutch
									GPC.NotifyEarnedAward('Clutch');
								}

								if (LastVictim != None &&
									bWasLastVictimExecution &&
									GGRI.GameClass.Name != 'GearGameCTL' &&
									GGRI.GameClass.Name != 'GearGameKOTH')
								{
									// @AWARD - End Big
									GPC.NotifyEarnedAward('EndBig');
								}
							}

							if (!PlayerIsAlive(Player, None))
							{
								DeadWinners.AddItem(Player);
							}
						}
					}
					else if (Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.Team != None)
					{
						if (GearMenuPC(Player) == None && GearDemoRecSpectator(Player) == None)
						{
							// @STATS - MPBase Round Lost per player
							`RecordPlayerIntStat(ROUND_WON,Player,0);
						}
					}
				}
				else
				{		  						
					if (GearMenuPC(Player) == None && GearDemoRecSpectator(Player) == None)
					{
						// @STATS - MPBase Round Stalemate per player
						`RecordPlayerIntStat(ROUND_STALEMATE,Player,0);
					}
				}

				if (MPPRI.CoverStartedTime > 0)
				{
					// Round end update cover
					MPPRI.TotalTimeInCoverThisRound += `TimeSince(MPPRI.CoverStartedTime);
					MPPRI.TotalTimeInCover += `TimeSince(MPPRI.CoverStartedTime);
					MPPRI.CoverStartedTime = 0;
					MPPRI.bNetDirty = true;
				}
			}

			if (NumPlayers > 1)
			{
				if (RespawnTimeInterval == 0 && DeadWinners.Length == 1 && !DeadWinners[0].PlayerReplicationInfo.bBot)
				{
					// @AWARD - Unlucky Bastard(non-respawn gametypes)
					GearPC(DeadWinners[0]).NotifyEarnedAward('UnluckyBastard');
				}
			}

			GotoState('PreRound');
			return true;
		}
	}

	/** Gives a derived game type a chance to override which team actually won */
	function int HandleWinningTeamOverride( int WinningTeamIdx )
	{
		return WinningTeamIdx;
	}

	function bool HandleRoundTimerExpired()
	{
		local int TeamIdx, Idx, WinningTeamIdxOverride, NumTeamsAlive;
		local Controller Player;
		local GearPawn GP;

		if ( !AutoReviveOnBleedOut( None ) )
		{
			// don't end round yet if everyone is DBNO on one team
			for (TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++)
			{
				if( Teams[TeamIdx] == None || Teams[TeamIdx].TeamMembers.length <= 0 )
				{
					continue;
				}
				// check for alive players
				for (Idx = 0; Idx < Teams[TeamIdx].TeamMembers.Length; Idx++)
				{
					Player = Teams[TeamIdx].TeamMembers[Idx];
					GP = GearPawn(Player.Pawn);
					if (PlayerIsAlive(Player, None) && (GP == None || !GP.IsDBNO()))
					{
						NumTeamsAlive++;
						break;
					}
				}
			}

			if ( NumTeamsAlive <= 1 )
			{
				// Round is about to end because of bleedouts so don't allow the timer to run out
				return FALSE;
			}
		}

		// See if the game mode would like to override a stalemate for match over
		WinningTeamIdxOverride = HandleWinningTeamOverride(-1);

		if (WinningTeamIdxOverride != -1)
		{
			LastKiller = None;
			LastVictim = None;
			HandleTeamWin(WinningTeamIdxOverride);
		}
		else
		{
			GameReplicationInfo.Winner = None;
			GearGRI_MP(GameReplicationInfo).FinalKiller = None;
			GotoState('PreRound');
		}

		// Set the time ran out flag
		GearGRI_MP(GameReplicationInfo).bRoundTimeRanOut = true;

		return TRUE;
	}

	/** called to broadcast overtime info and set the flag (any rules changes handled in subclasses) */
	final function SendToOvertime()
	{
		local GearPC_MP PC;

		if (!bOverTime)
		{
			foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
			{
				PC.ClientStartOvertimeText();
			}
			bOverTime = true;
		}
	}

	/** Don't allow any spawns until a new round starts. */
	function RestartPlayer(Controller NewPlayer)
	{
	}

	/** Overridden to check end of match conditions. */
	function ScoreKill(Controller Killer, Controller Other)
	{
		local GearGRI_MP GGRI;
		local GearPawn GP;
		local GearMPPRI KillerMPPRI, SpotterMPPRI;
		local Actor AttachedActor;
		local int KillerTeamIndex, OtherTeamIndex, PlayerIdx;

		if ( bLastKillerSet )
		{
			return;
		}

		// Check for last men standing (calculates alive player count needed below)
		CheckForLastMenStanding(Other);

		if (Killer != None && Killer != Other && !WorldInfo.GRI.OnSameTeam(Killer, Other))
		{
			KillerMPPRI = GearMPPRI(Killer.PlayerReplicationInfo);
			GGRI = GearGRI_MP(WorldInfo.GRI);
			KillerTeamIndex = Killer.PlayerReplicationInfo.Team.TeamIndex;
			OtherTeamIndex = Other.PlayerReplicationInfo.Team.TeamIndex;
			if (FirstKill == None)
			{
				FirstKill = Killer;
				if (NumPlayers > 2)
				{
					if (!FirstKill.PlayerReplicationInfo.bBot)
					{
						GearMPPRI(FirstKill.PlayerReplicationInfo).NumFirstKills++;
						// @AWARD - First blood
						GearPC(Killer).NotifyEarnedAward('FirstBlood');
					}

					if (!Other.PlayerReplicationInfo.bBot)
					{
						// @AWARD - Expendable
						GearPC(Other).NotifyEarnedAward('Expendable');
					}
				}
			}

			// Tracking kills where its you alone vs the other team
			if (KillerMPPRI != None && 
				RespawnTimeInterval == 0 &&
				Teams[KillerTeamIndex] != None &&
				Teams[KillerTeamIndex].TeamMembers.length > 1 &&
				GGRI.NumPlayersAliveOnTeam[KillerTeamIndex] == 1)
			{
				KillerMPPRI.NumSuddenDeathKillsThisRound++;
			}

			// Award the last man standing on his team
			if (RespawnTimeInterval == 0 &&
				Teams[OtherTeamIndex] != None &&
				Teams[OtherTeamIndex].TeamMembers.length > 1 &&
				GGRI.NumPlayersAliveOnTeam[OtherTeamIndex] == 1)
			{
				if (GGRI.GameClass.Name != 'GearGameWingman' &&
					GGRI.GameClass.Name != 'GearGameHorde' &&
					GGRI.GameClass.Name != 'GearGameSiege')
				{
					// Find the solitary player on this team
					for (PlayerIdx = 0; PlayerIdx < Teams[OtherTeamIndex].TeamMembers.Length; PlayerIdx++)
					{
						// Alive and with Pawn
						if ((Teams[OtherTeamIndex].TeamMembers[PlayerIdx] != None) &&
							PlayerIsAlive(Teams[OtherTeamIndex].TeamMembers[PlayerIdx], Other ) &&
							(Teams[OtherTeamIndex].TeamMembers[PlayerIdx].Pawn != None) )
						{
							// @AWARD - Last Man Out
							GearPC(Teams[OtherTeamIndex].TeamMembers[PlayerIdx]).NotifyEarnedAward('LastManOut');
							break;
						}
					}
				}
			}

			// @AWARD - Forward Observer
			GP = GearPawn(Other.Pawn);
			if (GP != None)
			{
				if (`TimeSince(GP.SpottedTime[KillerTeamIndex]) <= 10.0)
				{
					SpotterMPPRI = GearMPPRI(GP.SpottedBy[KillerTeamIndex]);
					if (SpotterMPPRI != None && SpotterMPPRI != KillerMPPRI && !SpotterMPPRI.bBot)
					{
						SpotterMPPRI.NumSpottingKills++;
						if (GearPC(SpotterMPPRI.Owner) != None && SpotterMPPRI.NumSpottingKills >= 5)
						{
							GearPC(SpotterMPPRI.Owner).NotifyEarnedAward('ForwardObserver');
							SpotterMPPRI.NumSpottingKills = 0;
						}
					}
				}
			}

			foreach Killer.Pawn.Attached(AttachedActor)
			{
				if (GearProj_Grenade(AttachedActor) != None)
				{
					// @AWARD - Grenade Attach Kill
					GearPC(Killer).NotifyEarnedAward('GrenadeAttach');
				}
			}
		}

		LastKiller = Killer;
		LastVictim = Other;
		//`log(((Killer != None) ? Killer.PlayerReplicationInfo.PlayerName : "World") @ "killed" @ Other.PlayerReplicationInfo.PlayerName);

		// Send event for a player being killed (not meant to work for wingman as of now!)
		TriggerEventClass(class'SeqEvt_PlayerDied', Other, (Killer != None) ? Killer.GetTeamNum() : Other.GetTeamNum());

		// If last player on team killed, force an endmatch check and set a flag
		if ( MatchEndCondition(Other) )
		{
			bLastKillerSet = true;

			if (LastKiller != None && !LastKiller.PlayerReplicationInfo.bBot && GearPC(LastKiller) != None)
			{
				GearMPPRI(LastKiller.PlayerReplicationInfo).NumLastKills++;
			}

			// add a delay before ending the match so players can see the final kill
			//@warning: CheckEndMatch() MUST actually end the match here or the game might get into an endless state!
			SetTimer( 0.55f, FALSE, nameof(CheckEndMatch) );
		}
	}

	/**
	* Sends a message to all players when someone has picked up a weapon from a weapon spawner so that we can
	* communicate the event to everyone with things like a message at the bottom of the screen etc.
	*/
	function GearBroadcastWeaponTakenMessage( Controller WeaponTaker, class<DamageType> damageType )
	{
		local GearPC_MP PC;

		foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
		{
			PC.AddWeaponTakenMessage( WeaponTaker.PlayerReplicationInfo, damageType );
		}
	}

Begin:
	if (!bTourist)
	{
		// Just set a timer that will check for the end of the match every second.
		SetTimer( 1.f, TRUE, nameof(CheckEndMatch) );
	}

	if( (CauseEventCommand != "") && (MyAutoTestManager != None) )
	{
		MyAutoTestManager.GotoState('SentinelHandleCauseEventCommand');
	}
}

function TeamHasWon(int TeamIdx);


/************************************************************************
 *				        MatchInProgress State End
 ************************************************************************/

/** @return whether there are two or more teams with players on them */
final function bool HaveTwoOccupiedTeams()
{
	local int i, Count;

	for (i = 0; i < Teams.length; i++)
	{
		if (Teams[i].TeamMembers.length > 0)
		{
			Count++;
			if (Count == 2)
			{
				return true;
			}
		}
	}

	return false;
}

/************************************************************************
 *						MatchOver State Begin
 *	When the match is over, the player lingers here for a while.
 ************************************************************************/
state MatchOver
{
	function BeginState(Name PreviousStateName)
	{
		local int i;

		// @STATS - write out final aggregate stats
		for (i=0;i<GameReplicationInfo.PRIArray.Length;i++)
		{
			GearMPPRI(GameReplicationInfo.PRIArray[i]).RecordEndGameStats();
		}

		`log("MATCH OVER");
		bFirstRound = TRUE;
		GearGRI.SetGameStatus(GS_EndMatch);
		SendAllPlayersToSpectating();

		// Removed (Move back if this causes problems)
		//KillRemainingPlayers();

		// @STATS - MPBase Match Ended, EndGame does the close/logging
		ReportFinalScoreStat();
		`RecordGameIntStat(MATCH_ENDED,GameReplicationInfo.ElapsedTime);

		EndMatch();

		// Tell players how much XP they've earned
		WriteOnlinePlayerXP();
		EndGame( (LastKiller != None) ? LastKiller.PlayerReplicationInfo : None, "LastMan");

		// prepare for the end of game transition
		PreEndOfGameTransition();
	}

	//Overridden here to immediately place players on assigned team so they appear on the scoreboard
	function PostLogin(PlayerController NewPlayer)
	{
		Global.PostLogin(NewPlayer);
		if (!bUsingArbitration)
		{
`if(`notdefined(FINAL_RELEASE))
			PrintTeamAssignments("MATCHOVER Post Login");
`endif

			if (MatchType == eGVMT_Player)
			{
				// match up with host beacon team assignments
				PlacePlayerOnAssignedTeam(GearPC(NewPlayer));
			}
			else if (!NewPlayer.PlayerReplicationInfo.bOnlySpectator)
			{
				// Kick extra bots first
				KickExtraBots();
				// Put player on the newly smallest team
				PlacePlayerOnSmallestTeam(NewPlayer);
			}

			// make sure voice chat is properly setup
			InitTeamMuteList(GearPC_MP(NewPlayer));

`if(`notdefined(FINAL_RELEASE))
			PrintTeamAssignments("MATCHOVER Post Login AFTER");
`endif
		}
	}

	// Don't allow anymore spawns.
	function RestartPlayer(Controller NewPlayer)
	{
	}

	/**
	 * The match has ended and should be cycled to the next map
	 */
	function EndOfGameMapCycleTransition()
	{
		bUseSeamlessTravel = true;
		DestroyHostBeacon();
		RestartGame();
	}

	/**
	 * Called after the end of game delay is over to transition to the next phase, whatever that may be
	 */
	function EndOfGameTransition()
	{
		local GearDedicatedServerInterface MasterServerInterface;
		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			if (ProfilingFrequency > 0)
			{
				ConsoleCommand("PROFILEGAME STOP");
				ClearTimer(nameof(StartProfiling));
			}

			// Check to see if any shutdown requests have been made
			if (OnlineSub != None)
			{
				MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
				if (MasterServerInterface != None)
				{
					if (MasterServerInterface.ShouldShutdown())
					{
						`log("Master server requested shutdown");
						TellClientsToReturnToPartyHost();
						// Restart the dedicated server after delaying for RPC to clients
						SetTimer(1.f, false, nameof(DedicatedServerRestart));
						return;
					}
				}
			}
		}

		if ( TrainingGroundsID > -1 )
		{
// 			ReturnToTrainingGroundsScreen();
		}
		// in local, system link, private matches, or social matches, seamless travel to a new map
		else if (!bUsingArbitration && MapCycle.Length > 0 && (HaveTwoOccupiedTeams() || MatchType == eGVMT_Player))
		{
			EndOfGameMapCycleTransition();
		}
		else if (GameInterface.GetGameSettings('Party') == None && WorldInfo.NetMode != NM_DedicatedServer)
		{
			WorldInfo.ServerTravel("gearstart?game=GearGameContent.GearPartyGame");
		}
		else
		{
			TellClientsToReturnToPartyHost();

			if (WorldInfo.NetMode == NM_DedicatedServer)
			{
				// Restart the dedicated server after delaying for RPC to clients
				SetTimer(1.f, false, nameof(DedicatedServerRestart));
			}
		}
	}

		/**
	 * Called before the end of game dealy to prepare for the end game transition
	 */
	function PreEndOfGameTransition()
	{
		local array<GearRecentPlayer> GearPlayers;
		local GearRecentPlayer GearCurrentPlayer;
		local GearRecentPlayersList RecentPlayersList;
		local int PartyResIdx,PlayerResIdx;

		// Turn off standby cheat detection so we don't get false positives due to leaving
		EnableStandbyCheatDetection(false);

		if (MatchType == eGVMT_Player)
		{
			// Don't advertise the session during map cycle for matchmaking, this will get reset
			// to the correct available team size when the match restarts
			SetGameSettingNeedsSize('Game',0);

			// Keep track of the gear parties that had reservations in the host beacon
			// This allows us to persist the reservations during the map cycle travel completes
			RecentPlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
			if (RecentPlayersList != None)
			{
				RecentPlayersList.ClearAllGearParties();
				// Copy player entries out of the host beacon
				for (PartyResIdx=0; PartyResIdx < HostPlayerMatchBeacon.Reservations.Length; PartyResIdx++)
				{
					GearPlayers.Length=0;
					GearCurrentPlayer.TeamNum = HostPlayerMatchBeacon.Reservations[PartyResIdx].TeamNum;
					for (PlayerResIdx=0; PlayerResIdx < HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyMembers.Length; PlayerResIdx++)
					{
						GearCurrentPlayer.Skill = HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyMembers[PlayerResIdx].Skill;
						GearCurrentPlayer.NetId = HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyMembers[PlayerResIdx].NetId;
						GearCurrentPlayer.Level = HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyMembers[PlayerResIdx].XpLevel;
						GearPlayers.AddItem(GearCurrentPlayer);
					}
					RecentPlayersList.AddLastGearParty(HostPlayerMatchBeacon.Reservations[PartyResIdx].PartyLeader,GearPlayers);
				}
			}
			// Prevent accepting any new JIP invite connections by pausing reservation requests
			HostPlayerMatchBeacon.PauseReservationRequests(true);
		}
	}

Begin:
	Sleep(0.2f);
	if (GearGRI.RoundTime <= 0)
	{
		EndOfGameTransition();
	}
	else
	{
		Goto('Begin');
	}
}

/**
 * Iterates the player controllers and tells them to return to their party
 * Only for clients in remote parties
 */
function TellClientsToReturnToPartyHost()
{
	// Cleanup the host beacon which handles JIP requests
	DestroyHostBeacon();

	Super.TellClientsToReturnToPartyHost();
}

/************************************************************************
 *				        MatchOver State End
 ************************************************************************/


/**
 * Adds a stat event for the final score.  Broken out so that we can override it per gametype
 */
function ReportFinalScoreStat()
{
	if (GameReplicationInfo.Teams.Length > 1)
	{
		//@STATS - MPBase Record final team scores
		`RecordTeamIntStat(GAME_SCORE, GameReplicationInfo.Teams[0], int(GameReplicationInfo.Teams[0].Score));
		`RecordTeamIntStat(GAME_SCORE, GameReplicationInfo.Teams[1], int(GameReplicationInfo.Teams[1].Score));
	}
}


/**
 * Have players register with the object that tracks stats for the post game results, so we can track drops
 */
function InitLastMatchResults()
{
	local GearPC_MP PC;

	foreach WorldInfo.AllControllers(class'GearPC_MP',PC)
	{
		PC.ClientInitLastMatchResults(OnlineStatsWriteClass,bUsingArbitration);
	}
}

/**
 * Have players clear the last results from a mapcycle
 */
function ClearLastMatchResults()
{
	local GearPC_MP PC;

	foreach WorldInfo.AllControllers(class'GearPC_MP',PC)
	{
		PC.ClientClearLastMatchResults();
	}
}

/**
 *   Calculate and give XP to players participating in the match based on various measures
 */
function WriteOnlinePlayerXP()
{
	local GearPC_MP PC;
	local GearPRI PRI;
	local float LocXPScale, RibbonXPScale;
	local int LocWinBonus;
	local int XPIndex, TeamIndex;
	local int HighScore,WinningTeamIndex;

	// Update quit and standby demerits
	foreach WorldInfo.AllControllers(class'GearPC_MP',PC)
	{
		// Reduce any standby demerits by 1
		PC.ClientIncrementStandbyDemerits(-1);
		if (MatchType == eGVMT_Official)
		{
			// Decrement disconnect count on match completion
			PC.ClientAdjustDisconnectCount(-1);
			// Decrement quit count on match completion
			PC.ClientAdjustQuitCount(-1);
		}
	}

	WinningTeamIndex = -1;
	for (TeamIndex = 0; TeamIndex < GearGRI.Teams.Length; TeamIndex++)
	{
		// Find the team with the highest score
		if (GearGRI.Teams[TeamIndex].Score > HighScore)
		{
			HighScore = GearGRI.Teams[TeamIndex].Score;
			WinningTeamIndex = TeamIndex;
		}
	}

	// Scale the XP by the game type values
	switch (MatchType)
	{
	case eGVMT_Official:
		LocXPScale = XPScale * RankedXPScale;
		LocWinBonus = MatchWinXPBonus * RankedMatchWinScale;
		RibbonXPScale = RankedRibbonXPScale;
		break;
	case eGVMT_Player:
		LocXPScale = XPScale * SocialXPScale;
		LocWinBonus = MatchWinXPBonus * SocialMatchWinScale;
		RibbonXPScale = SocialRibbonXPScale;
		break;
	case eGVMT_Custom:
		LocXPScale = XPScale * CustomXPScale;
		LocWinBonus = MatchWinXPBonus * CustomMatchWinScale;
		RibbonXPScale = CustomRibbonXPScale;
		break;
	}

	// If this mode earns XP, apply it to each player
	if (LocXPScale > 0.0)
	{
		foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
		{
			if (PC.PlayerReplicationInfo != None)
			{
				PRI = GearPRI(PC.PlayerReplicationInfo);

				for (XPIndex = 0; XPIndex < ArrayCount(PRI.ExpBuckets); XPIndex++)
				{
					// Don't scale ribbons or quit penalties
					if (XPIndex != eEXP_Awards)
					{
						PRI.ExpBuckets[XPIndex] *= LocXPScale;
					}
					else
					{
						PRI.ExpBuckets[XPIndex] *= RibbonXPScale;
					}
				}
				if (PC.PlayerReplicationInfo.Team != None && PC.PlayerReplicationInfo.Team.TeamIndex == WinningTeamIndex)
				{
					// Intentionally ignores scaling
					PRI.ExpBuckets[eEXP_WinBonus] = LocWinBonus;
				}
				if (NumConsecutiveMatchesNeeded > 0 &&
					(MatchType == eGVMT_Official || MatchType == eGVMT_Player))
				{
					// Ignore XP scaling for the participation bonus
					PRI.ExpBuckets[eEXP_ParticipationBonus] = ConsecutiveMatchBonus * FClamp((float(PC.ConsecutiveMatchesPlayed) / float(NumConsecutiveMatchesNeeded)),0.0,1.0);
				}

				for (XPIndex = 0; XPIndex < ArrayCount(PRI.ExpBuckets); XPIndex++)
				{
					// @STATS - XP Tracking
					`RecordPlayerIntStatRaw(class'GearGameplayEventsWriter'.const.GAMEEVENT_PLAYER_XP_KILLS + XPIndex,PC,PRI.ExpBuckets[XPIndex]);
				}

				PC.ClientUpdateXP(PRI.ExpBuckets);
				// Manually increment the matches played rather than infer from XP so that you
				// don't reward mid match XP granting
				PC.ClientIncrementConsecutiveMatchesPlayed();
			}
		}
	}
}

/**
 * Updates what we have advertised for the session in terms of slots available for matchmaking.
 * Includes counts from remote parties that will fill in our game.
 * These player slots are updated whenever a player joins/leaves the current game.
 */
final private function UpdatePlayerMatchNeedWantsStatus()
{
	local int NeedSize;

	if (GameInterface != None &&
		// implies eGVMT_Player match mode
		MatchType == eGVMT_Player)
	{
		// Host beacon maintains the team assignments
		NeedSize = HostPlayerMatchBeacon.GetMaxAvailableTeamSize();
		// If the host cheated, make sure no new players can join
		if (bHasStandbyCheatTriggered)
		{
			NeedSize = 0;
		}
		// Update the game settings object with the new needs size
		SetGameSettingNeedsSize('Game',NeedSize);
	}
}

/**
 * Sync the current reservation state of the host beacon with what
 * is advertised for the game session searches.
 */
function OnHostBeaconReservationChange()
{
	local GearPC PCIter;

	if (MatchType == eGVMT_Player)
	{
		// update invite settings since players might have changed
		// to a team with enough space for an invite
		foreach WorldInfo.AllControllers(class'GearPC',PCIter)
		{
			// Toggle invites based on if the player's team is full or not
			UpdatePlayerMatchInvites(PCIter);
		}

		// Update party sizes we can handle
		// NOTE: Need to update the context/properties of the game session AFTER
		// updating the party session since it will override the advertised values
		UpdatePlayerMatchNeedWantsStatus();
		// Update skill since remote players were added/removed
		UpdateAggregateSessionSkill();

		// All players have left the game, so restart the dedicated server
		if (HostPlayerMatchBeacon.Reservations.length <= 0 && WorldInfo.NetMode == NM_DedicatedServer)
		{
			//Cleanup the beacon
			DestroyHostBeacon();
			SetTimer(1.f, false, nameof(DedicatedServerRestart));
		}
	}
}

/**
 * Recalculate the aggregate skill for the session based on current player reservations in the host vs beacon.
 */
function UpdateAggregateSessionSkill()
{
	local array<UniqueNetId> Players;

	// Local and remote parties should all have reservation entries in the beacon
	// This is the current list of known players
	if (HostPlayerMatchBeacon != None)
	{
		HostPlayerMatchBeacon.GetPlayers(Players);
	}

`if(`notdefined(FINAL_RELEASE))
	class'OnlineSubsystem'.static.DumpNetIds(Players,"UpdateAggregateSessionSkill Social");
`endif

	// Now update the skill for the session using the list of current players
	GameInterface.RecalculateSkillRating('Game',Players);
}

/** Wrapper to delay server restart after beacon destruction */
function DedicatedServerRestart()
{
	local GearDedicatedServerInterface MasterServerInterface;

	// Make sure this wasn't called as a result of LoadMap freeing player controllers
	if (!bLevelChange)
	{
		if (ProfilingFrequency > 0)
		{
			ConsoleCommand("PROFILEGAME STOP");
			ClearTimer(nameof(StartProfiling));
		}

		MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
		if (MasterServerInterface != None)
		{
			MasterServerInterface.SetStatus(STATUS_RESTARTING);
		}

		//Server travel back to pregame lobby for dedicated server
		bUseSeamlessTravel = false;
		bLevelChange = true;
		`LogOnline("Restarting Dedicated Server");
		ClearServerDelegates();
		ConsoleCommand("start gearstart?game=GearGameContent.GearPreGameLobbyGameDedicated");
	}
}

/**
 * Used to tell the game when the server login status has changed
 *
 * @param NewStatus status of login used to create dedicated server
 * @param NewId the new id to associate with the user
 */
function OnServerLoginStatusChange(ELoginStatus NewStatus,UniqueNetId NewId)
{
	// Detect profile sign-in at alternate location and kill this server
	if (NewStatus < LS_LoggedIn)
	{
		`DSLogError('DevOnlineGame', "Server login has been signed out, restarting...");
		DedicatedServerRestart();
	}
}

/**
 * Called when a system level connection change notification occurs.
 * @param ConnectionStatus current status
 */
function OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus)
{
	switch (ConnectionStatus)
	{
	case OSCS_ConnectionDropped:
	case OSCS_NoNetworkConnection:
	case OSCS_ServiceUnavailable:
	case OSCS_UpdateRequired:
	case OSCS_ServersTooBusy:
		`DSLogError('DevOnlineGame', "Connection has been interrupted, restarting..."@ConnectionStatus);
		DedicatedServerRestart();
		break;
    case OSCS_DuplicateLoginDetected:
		`DSLogError('DevOnlineGame', "Duplicate login detected, restarting...");
		DedicatedServerRestart();
		break;
	}
}

/**
 * Displays a message when the physical network is lost during a networked game
 * @param bIsConnected the new connection state
 */
function OnLinkStatusChange(bool bIsConnected)
{
	if (!bIsConnected)
	{
		`DSLogError('DevOnlineGame', "Lost connection to network...");
		DedicatedServerRestart();
	}
}

/**
 * Registers the server delegates once the login process has passed or failed
 */
function RegisterServerDelegates()
{
	if (OnlineSub != None)
	{
		// Connection status delegates
		if (OnlineSub.SystemInterface != None)
		{
			OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
			OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChange);
		}

		// Register login delegates
		if (OnlineSub.PlayerInterface != None)
		{
			OnlineSub.PlayerInterface.AddLoginStatusChangeDelegate(OnServerLoginStatusChange,0);
		}
	}
}

/**
 * Clears the server delegates once the login process has passed or failed
 */
function ClearServerDelegates()
{
	if (OnlineSub != None)
	{
		// Connection status delegates
		if (OnlineSub.SystemInterface != None)
		{
			OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
			OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChange);
		}

		// Login delegates
		if (OnlineSub.PlayerInterface != None)
		{
			OnlineSub.PlayerInterface.ClearLoginStatusChangeDelegate(OnServerLoginStatusChange,0);
		}
	}
}

/** Kills the specified bot */
function KillBot(GearAI_TDM BotToKill)
{
	if (BotToKill.Pawn != None)
	{
		BotToKill.Pawn.Suicide();
	}

	BotToKill.Destroy();
}

/**
 * Removes a number of bots from the specified team
 *
 * @param TeamIdx only bots matching this team are removed
 * @param NumBotsToRemove number of bots to remove from the team
 */
function RemoveBotsFromTeam(int TeamIdx,int NumBotsToRemove)
{
	local GearAI_TDM Bot;
	local TeamInfo BotTeam;

	if (TeamIdx >= 0 &&
		TeamIdx < Teams.Length)
	{
		BotTeam = Teams[TeamIdx];
		if (BotTeam != None)
		{
			foreach WorldInfo.AllControllers(class'GearAI_TDM', Bot)
			{
				if (NumBotsToRemove > 0)
				{
					// match the bot's team
					if (Bot.PlayerReplicationInfo.Team == BotTeam)
					{
						KillBot(Bot);
						NumBotsToRemove--;
					}
				}
				else
				{
					break;
				}
			}
		}

		if (NumBotsToRemove > 0)
		{
			`log("Unable to remove all the requested bots, still want to remove"@NumBotsToRemove@"but couldn't");
		}
	}
}

/**
 * If the player joined but no longer has a team assignment then try to obtain one
 * This can occur if load time was too long and the player timed out of the beacon during travel
 *
 * @param PC the controller that has joined the game
 * @param UniqueId the buffer that holds the unique id
 */
function int AttemptMissingPlayerReservation(GearPC PC)
{
	local UniqueNetId ZeroId;
	local array<PlayerReservation> PartyMembers;

	if (MatchType == eGVMT_Player)
	{
		PartyMembers.Length = 1;
		PartyMembers[0].NetId = PC.PlayerReplicationInfo.UniqueId;
		PartyMembers[0].Skill = GearPRI(PC.PlayerReplicationInfo).PlayerSkill;
		PartyMembers[0].XpLevel = GearPRI(PC.PlayerReplicationInfo).PlayerLevel;

		// First check to see if the player's party owner already has a reservation
		if (GearPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId != ZeroId &&
		// If the PartyOwnerUniqueId isn't replicated at this point then the player will be split from his party
			HostPlayerMatchBeacon.GetExistingReservation(GearPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId) != -1)
		{
			HostPlayerMatchBeacon.UpdatePartyReservationEntry(GearPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId,PartyMembers);
		}
		// If there isn't an existing party then add a new reservation entry
		else
		{
			HostPlayerMatchBeacon.AddPartyReservationEntry(GearPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId,PartyMembers,-1,false);
		}
		// Get new team assignment
		return HostPlayerMatchBeacon.GetTeamForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
	}
	return -1;
}

/**
 * Place the player on his team based on the host beacon team assignments.
 * Assumes that the UniqueId for the player has been replicated to the server in order
 * to find the team assignment. Also, mantains bots balanced on teams.
 *
 * @param PC player controller to be assigned a team
 * @param BotToSwapOut bot to destroy once this player is successfully added to a team
 */
function PlacePlayerOnAssignedTeam(GearPC PC, optional GearAI_TDM BotToSwapOut = None)
{
	local UniqueNetId ZeroId;
	local int TeamNum;

	if (MatchType == eGVMT_Player &&
		PC != None &&
		PC.PlayerReplicationInfo.UniqueId != ZeroId)
	{
		// Get the team assignment from the reservation in the host beacon
		TeamNum = HostPlayerMatchBeacon.GetTeamForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
		if (TeamNum < 0)
		{
			TeamNum = AttemptMissingPlayerReservation(PC);
		}
		if (TeamNum < 0)
		{
			`LogBeacon("No matching team found! Returning to main menu"
				$" UniqueId="$OnlineSub.static.UniqueNetIdToString(PC.PlayerReplicationInfo.UniqueId));

			// Must have a valid team assignment on the beacon otherwise you get kicked back to the main menu
			PC.ClientReturnToMainMenu();
			// default to no team if no team entry was found
			ChangeTeam(PC,255,false);
		}
		// check to see if the player needs to change teams if not already on the correct team
		else if (TeamNum < Teams.Length &&
				 Teams[TeamNum] != PC.PlayerReplicationInfo.Team)
		{
			// free up a bot slot so this player can join the team
			if (BotToSwapOut != None)
			{
				KillBot(BotToSwapOut);
			}
			else
			{
				RemoveBotsFromTeam(TeamNum,1);
			}

			// move to the correct team
			ChangeTeam(PC,TeamNum,false);
		}
	}
}

/**
 * Toggle invites based on if the player's team is full or not
 *
 * @param PC of client we want to set invites on
 */
function UpdatePlayerMatchInvites(GearPC PC)
{
	local UniqueNetId ZeroId;
	local int TeamIdx;
	local int CurrentTeamSize;

	CurrentTeamSize = PlaylistTeamSize;
	if (MatchType == eGVMT_Player &&
		PC != None &&
		PC.PlayerReplicationInfo != None &&
		PC.PlayerReplicationInfo.UniqueId != ZeroId)
	{
		// find the team assignment of the player based on his replicated net id
		TeamIdx = HostPlayerMatchBeacon.GetTeamForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
		if (TeamIdx >= 0)
		{
			// find the current occupied size of the team that this player is on
			CurrentTeamSize = HostPlayerMatchBeacon.GetOccupiedTeamSize(TeamIdx);
			if (CurrentTeamSize < PlaylistTeamSize)
			{
				// player's team has enough space to handle invites
				PC.ClientSetPartyInviteFlags(true,false,true);
			}
			else
			{
				// player's team is already full
				PC.ClientSetPartyInviteFlags(false,false,false);
			}
		}
	}
}

/**
 * Notifies the game code that a standby cheat was detected
 *
 * @param StandbyType the type of cheat detected
 */
event StandbyCheatDetected(EStandbyType StandbyType)
{
	local GearPC PC;
	local int HostDemerits;

	bHasStandbyCheatTriggered = true;
	`LogOnline("");
	`LogOnline("Standby cheat detected of type "$StandbyType);
	`LogOnline("");
	switch (StandbyType)
	{
		case STDBY_Rx:
		case STDBY_Tx:
			HostDemerits = HostRxDemerits;
			break;
		case STDBY_BadPing:
			HostDemerits = BadPingDemerits;
			break;
	}

	// Send all the host punishment and grab their team
	foreach LocalPlayerControllers(class'GearPC',PC)
	{
		PC.ClientIncrementStandbyDemerits(HostDemerits);
	}
}

defaultproperties
{
	StatGametypeSuffix="MP"

	GameReplicationInfoClass=class'GearGRI_MP'
	GameTypeConfigName="MP"

	MapPrefixes[0]="MP"

	PlayerControllerClass=class'GearPC_MP'

	bWaitingToStartMatch=TRUE
	bFirstRound=TRUE
	bTeamGame=TRUE
	bUseSeamlessTravel=false

	GearPlayerStartClass=class'GearTeamPlayerStart'

	TrainingGroundsID=-1

	LeaderboardId=0xFFFE0002
	ArbitratedLeaderboardId=0xFFFF0002

	// Needed because GearPRI is base for all PRI classes and specialization needs to happen here
	PlayerReplicationInfoClass=class'GearMPPRI'

	MaxSquadSize=3

	bEliminatePlantedGrenades=TRUE
	bUsingWeaponCycle=true
	bCanSwapBotsAndPlayers=true
	bScoreRoundWin=true

	DefaultGrenadeClass=class'GearWeap_SmokeGrenade'

	PlaylistId=-1
}
