/**
 * GearGame
 * Gear Game Info
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearGame extends GameInfo
	config(Game)
	native
	abstract
	dependson(GearDroppedPickup,GearPersistentPartyBeaconHost);

`include(GearOnlineConstants.uci)

// include the stats definition w/ a GAME_INFO define so that we can avoid the extra GearGame(WorldInfo.Game) context
`define GAMEINFO(dummy)
`include(GearGame\GearStats.uci);
`undefine(GAMEINFO)


/** Prefix characters for names of maps for this game type */
var array<string> MapPrefixes;

/** Only to be used by combat zones in Campaign & Invasion since we don't know how many teams there
 * actually are in Versus.
 */
const COG_TEAM_INDEX	= 0;
const LOCUST_TEAM_INDEX = 1;
const LAMBENT_TEAM_INDEX = 2;

/** Min players needed to start a match */
var() config int MinPlayers;

`if(`notdefined(FINAL_RELEASE))
/** Min players needed to start a ranked match */
var() int MinRankedPlayers;
`else
/** Min players needed to start a ranked match */
var() config int MinRankedPlayers;
`endif

/** Total number of teams to create */
var config byte			NumTeams;

/** List of currently active teams */
var array<GearTeamInfo>	Teams;

/** manager object for GUDS */
var GUDManager			UnscriptedDialogueManager;

/** True to permit friendly fire, false to ignore it */
var	config bool			bAllowFriendlyFire;

/** Cheat to test DBNO. Forces the player to stay DBNO and not auto revive/die. */
var bool				bDBNOForeverCheat;

/** Cheat to globally disable flocking */
var bool                bDisallowFlocking;

/** True if players are currently in co-op split section */
var bool				bInCoopSplit;
/** set when doing a solo split where going DBNO means game over */
var transient bool bInSoloSplit;
/** Set when seperate squads are unable to reach/revive eachother */
var transient bool bGapSquadSplit;

/** If true, this is a fake dedicated server */
var bool				bIsDedicatedListenServer;

/** Are we testing dedicated performance (force all clients to spectator) */
var transient config bool bTestingDedicated;
/** Profiling frequency */
var transient config int ProfilingFrequency;
/** Profiling duration */
var transient config int ProfilingDuration;

/** A generic remote speaker we can use for random stuff */
var RemoteSpeaker_Generic		GenericRemoteSpeaker;

/** gamewide monitor object for battle status */
var BattleStatusMonitor			BattleMonitor;

/** True if the host purposefully disconnected their cable, false otherwise */
var bool						bHostTamperedWithMatch;

/** Whether a round should have a time limit or not */
var() config bool				bInfiniteRoundDuration;

/** Whether or not this game type should create and allow tutorials or not */
var() config bool				bAllowTutorials;

/** Type of tutorials this game supports */
var() config EGearAutoInitTutorialTypes AutoTutorialType;

/** This will auto skip all matinees.  This is going to be used for external testing (so they do not see the entire story) **/
var config bool bSkipAllMatinees;

/** Whether this game mode should enable taccom viewing of weapons */
var bool bShouldDisplayWeaponPickupsViaTaccom;
/** Whether this game mode should enable taccom viewing of tagged grenades */
var bool bShouldDisplayTaggedGrenadesViaTaccom;
/** Whether this game mode should enable taccom viewing of allies' bodies (not just the locators)*/
var bool bShouldDisplayAlliesViaTaccom;

/** whether players are allowed to voluntarily drop non-heavy weapons */
var bool bCanDropBasicWeapons;

/** Whether the game should do the LocScreenShotTest */
var bool bDoLocScreenShotTest;
/** Whether or not to do automated Horde testing which will just kill mobs over and over and then do a memleackcheck at the start of each match **/
var bool bDoAutomatedHordeTesting;

/** Spectator Camera Points */
var transient protected array<GearSpectatorPoint> SpectatorPoints;

/** The time interval that respawns will occur */
var() config int RespawnTimeInterval;
/** Time the respawned player has of invincibility */
var() config float RespawnInvincibilityTimer;

/** Generic weapons disappear after x secs - 0 means they don't disappear */
var() config float WeaponFadeTimeGeneric;
/** Special weapons disappear after x secs - 0 means they don't disappear */
var() config float WeaponFadeTimeSpecial;

/** point values for various actions against a player, used to initialize the values in GearPRI (which are the ones used for the actual scoring) */
var config float PointsFor_TakeDowns, PointsFor_Executions, PointsFor_InstantKills, PointsFor_Revives, PointsFor_DamagePct, PointsFor_SpottedKill;

/** How long a spot should last */
var config float SpotLength;

/** How long before a spot can be overridden. 0 means it cannot be overridden */
var config float SpotChangeDelay;

/** mutators automatically added when playing this gametype */
var array<name> AutoMutators;

/** Manager which handles asynchronous sight checks for AI **/
var instanced AIVisibilityManager AIVisMan;

/** Global sight radius limits set by Kismet */
var float MaxSightRadius_COG;
var float MaxSightRadius_Locust;
/** Global hearing radius limits set by Kismet */
var float MaxHearingRadius_COG;
var float MaxHearingRadius_Locust;

/** Gameplay statistics logging */
var config string GameplayEventsWriterClassName;
var transient GameplayEventsWriter GameplayEventsWriter;
var config bool bLogGameplayEvents;

/** How frequent to poll events in the gameplay stats logging */
var config float GameplayEventsPollingInterval;

/** list of deployed shields for AI checks */
var array<GearDroppedPickup_Shield> DeployedShields;

/** difficulty level classes */
var array< class<DifficultySettings> > DifficultyLevels;

/** debug flag to force stats in non-arbitrated games so it's easier to test the stats server */
var bool bForceStats;

/** set if the difficulty came from the URL and the profile value should be ignored */
var bool bURLDifficultyOverride;

/**
 * SUPER HACK to ship the game! This bool is set when adding a bot who is replacing a human so
 * we can avoid the GetForcedTeam() functon when calling ChangeTeam
 */
var bool bSkipForcedTeamCallHack;

/** Set of efects to use when a gib comes off */
struct native GearGoreEffectInfo
{
	/** Effect to attach to falling gib  */
	var()	ParticleSystem	GibEffect;
	/** Effect to attach to creature where gib left */
	var()	ParticleSystem	HoleEfect;
	/** How much to scale up gib effect */
	var()	float			EffectScale;
	/** Sound to play when gib comes off */
	var()	SoundCue		LoseGibSound;

	structdefaultproperties
	{
		EffectScale=1.0
	}
};

/** Path constraint pool */
const NUM_CONSTAINT_CLASSES = 15; // this should be the number of path constraint sub classes
const MAX_PATHCONST_INSTANCES_PER_CLASS = 5; // currently can't have more than 3 of the same path constraint at once
struct native PathConstraintCacheDatum
{
	var int ListIdx;
	var PathConstraint List[MAX_PATHCONST_INSTANCES_PER_CLASS];
};
var array<PathConstraintCacheDatum> PathConstraintCache;


/** Path Goal evaluator pool */
// NOTE: you can't currently have more than once instance of the same goal evaluator class at once!!
const MAX_GOALEVALUATORS = 10; // this should be the number of goal evaluate constraint sub classes
var array<PathGoalEvaluator> PathGoalEvaluatorCache;

/** Host beacon to handle reservation requests for party members that have been invited to this party host */
var GearPersistentPartyBeaconHost HostPersistentPartyBeacon;

//The suffix appended to stats for this gametype. Ex: SP for single player and MP for multiplayer
var String StatGametypeSuffix;

/** Whether would like to enable death cam or not */
var() config bool bEnableDeathCam;
/** If the killer is further than this distance, use death cam **/
var() config float MinDeathCamActiveDistance;

cpptext
{
	virtual UBOOL Tick( FLOAT DeltaSeconds, ELevelTick TickType );
}

/**
 * @return	a reference to the gear-specific online game settings data store.
 */
static final function GearUIDataStore_GameSettings GetGameSettingsDataStore()
{
	return class'GearUIManager'.static.GetGameSettingsDataStore();
}

/** @return if we are expecting remote clients, either through the beacon or a live NetConnection in the pending state */
native final function bool HavePendingConnections();

/**
 * Wrapper for getting the OnlineGameSettings object associated with the currently selected gametype.
 *
 * @param	bCreateIfNecessary	TRUE to indicate that the OnlineGameSettings object associated with the current game
 *								should be created if it doesn't yet exist.
 *
 * @return	the OnlineGameSettings object that contains the settings for the currently selected gametype.
 */
function OnlineGameSettings GetCurrentGameSettings( optional bool bCreateIfNecessary )
{
	local GearUIDataStore_GameSettings SettingsDS;
	local OnlineGameSettings Result;

	// find the settings for the current match
	SettingsDS = GetGameSettingsDataStore();
	if ( SettingsDS != None )
	{
		Result = SettingsDS.GetCurrentGameSettings();
	}

	if ( Result == None && bCreateIfNecessary )
	{
		Result = new class'GearWarzoneSettings';
	}

	return Result;
}

event PreBeginPlay()
{
	local GearGRI OldGRI;
	local int Idx;

	Super.PreBeginPlay();

	foreach DynamicActors(class'GearGRI', OldGRI)
	{
		if (OldGRI != WorldInfo.GRI)
		{
			for ( Idx = 0; Idx < 5; Idx++ )
			{
				GearGRI(WorldInfo.GRI).WingmanClassIndexes[Idx] = OldGRI.WingmanClassIndexes[Idx];
			}
			OldGRI.Destroy();
			break;
		}
	}
}

event PostBeginPlay()
{
	if (!IsA('GearMenuGame'))
	{
		UnscriptedDialogueManager = Spawn( class'GUDManager' );
		GenericRemoteSpeaker = Spawn( class'RemoteSpeaker_Generic' );
		BattleMonitor = Spawn( class'BattleStatusMonitor' );
	}

	super.PostBeginPlay();
}

/** Set the game to profile */
function StartProfiling()
{
	ConsoleCommand("PROFILEGAME"@ProfilingDuration);
}

/** Was -smoketest passed on the command line (dedicated server) */
native function bool IsSmokeTest();
/** Returns a mapname specified on the command line (dedicated server) */
native function bool GetMapNameOverride(out string Mapname);
/** Returns the mapname specified in the URL */
native function string GetMapFilename();

final function GearGRI GetGRI()
{
	return GearGRI(GameReplicationInfo);
}

/**
 * Transition back to pre-match state.
 */
function Reset()
{
	super.Reset();
	GotoState('PendingMatch');
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
	local PlayerController PC;
	local GearPC WPC;
	local bool bDedicated;
	local GearPRI PRI;

	// if this is the first player, and he has the dedicated server option, mark him as such and force to be spectator
	if (HasOption(Options, "dedicated"))
	{
		bDedicated = true;
		Options $= "?SpectatorOnly=1";
	}

	PC = Super.Login(Portal, Options, UniqueId, ErrorMessage);
	WPC = GearPC(PC);

	if (bDedicated)
	{
		bIsDedicatedListenServer = true;
		if (WPC != None)
		{
			WPC.bDedicatedServerSpectator = true;
			WPC.PlayerReplicationInfo.bIsSpectator = true;
		}
	}

	// check for a difficulty setting specified on the commandline
	if (PC != None)
	{
		PRI = GearPRI(PC.PlayerReplicationInfo);
		if (PRI != None)
		{
			if (HasOption(Options,"Casual"))
			{
				PRI.Difficulty = class'DifficultySettings_Casual';
				bURLDifficultyOverride = true;
			}
			else if (HasOption(Options,"Normal"))
			{
				PRI.Difficulty = class'DifficultySettings_Normal';
				bURLDifficultyOverride = true;
			}
			else if (HasOption(Options,"Hardcore"))
			{
				PRI.Difficulty = class'DifficultySettings_Hardcore';
				bURLDifficultyOverride = true;
			}
			else if (HasOption(Options,"Insane"))
			{
				PRI.Difficulty = class'DifficultySettings_Insane';
				bURLDifficultyOverride = true;
			}
			else if (WorldInfo.IsPlayInEditor())
			{
				// ignore profile in PIE
				bURLDifficultyOverride = true;
			}
			`log("Difficulty setting for"@PC@"is:"@PRI.Difficulty);

			// @STATS - Record player difficulty setting
			`RecordPlayerIntStat(DIFFICULTY,PC,PRI.Difficulty.default.DifficultyLevel);
		}
	}
	return PC;
}

function GenericPlayerInitialization(Controller C)
{
	local GearPC PC;

	PC = GearPC(C);
	if (PC != None)
	{
		// Register all clients with each others' parties
		PC.ClientRegisterWithParty();
	}

	Super.GenericPlayerInitialization(C);

	if (PC != None)
	{
		InitializeTutorialSystem(PC);
		// The player has just joined, so ask for their saved skill
		PC.ClientGetPlayerSkill();
		PC.ClientGetPlayerLevel();
	}
}

function PostLogin(PlayerController NewPlayer)
{
	local PlayerController HostPlayer;
	local GearPC NewPC, OtherPC;

	// @STATS - log join-in-progess players, moved to PostLogin from Login since we need a Player to determine if splitscreen is in use.
	`RecordLoginChange(LOGIN,NewPlayer,NewPlayer.PlayerReplicationInfo.PlayerName,NewPlayer.PlayerReplicationInfo.UniqueId,NewPlayer.IsSplitScreenPlayer());

	// for mp games force all players to share the host difficulty
	if (GameReplicationInfo.IsMultiplayerGame() && LocalPlayer(NewPlayer.Player) == None)
	{
		foreach WorldInfo.LocalPlayerControllers(class'PlayerController',HostPlayer)
		{
			`log("Forcing player"@NewPlayer@"difficulty to"@GearPRI(HostPlayer.PlayerReplicationInfo).Difficulty);
			GearPRI(NewPlayer.PlayerReplicationInfo).Difficulty = GearPRI(HostPlayer.PlayerReplicationInfo).Difficulty;

			// @STATS - Record player difficulty forced
			`RecordPlayerIntStat(DIFFICULTY,NewPlayer,GearPRI(NewPlayer.PlayerReplicationInfo).Difficulty.default.DifficultyLevel);
			break;
		}
	}

	NewPC = GearPC(NewPlayer);
	if (NewPC != None && LocalPlayer(NewPlayer.Player) != None)
	{
		NewPC.UpdateLocalPlayersDLCValues();
	}

	Super.PostLogin(NewPlayer);

	if (UnscriptedDialogueManager != None && NewPC != None)
	{
		UnscriptedDialogueManager.ReplicateLoadedGUDBanks(NewPC);
	}

	// tell client to display the "host has paused" menu if host has paused in a co-op game
	if ( WorldInfo.Pauser != None && LocalPlayer(NewPlayer.Player) == None &&
		(!WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame()) )
	{
		foreach LocalPlayerControllers(class'GearPC', OtherPC)
		{
			if ( OtherPC.MyGearHud.UI_PauseSceneInstance != None )
			{
				NewPC.ClientUpdateHostPause(true);
				break;
			}
		}
	}

	//Setup the stat and award managers
	if (NewPC != None)
	{
		NewPC.CreateStatAndAwardManager();
	}

	if (NewPC != None)
	{
		// Let the persistent party host know about the login event
		NewPC.ClientLoginPersistentParty();
	}
}

/**
 * Calls a replicated function on the player to initialize their tutorial manager
 *
 * @param	PC	the player that should initialize the tutorial system.
 */
function InitializeTutorialSystem( GearPC PC )
{
	if ( PC != None && bAllowTutorials )
	{
		// Create the Tutorial Manager
		PC.ClientInitializeTutorialSystem( AutoTutorialType );
	}
}

/** @return whether the specified GearPawn should use the health/speed/etc defaults of class'GearPawn'
 * instead of whatever is defined for its specific class in the .ini file
 */
function bool ShouldUseBasePawnDefaults(GearPawn TestPawn);

function SetPlayerDefaults(Pawn PlayerPawn)
{
	local GearPawn WP;
	local GearPRI PRI;

	Super.SetPlayerDefaults(PlayerPawn);

	WP = GearPawn(PlayerPawn);
	if (WP != None)
	{
		if (ShouldUseBasePawnDefaults(WP))
		{
			WP.DefaultHealth = class'GearPawn'.default.DefaultHealth;
			WP.Health = WP.DefaultHealth;
			WP.HealthMax = WP.DefaultHealth;
			WP.GroundSpeed = class'GearPawn'.default.DefaultGroundSpeed;
			WP.HealthRechargeDelay = class'GearPawn'.default.HealthRechargeDelay;
			WP.HealthRechargePercentPerSecond = class'GearPawn'.default.HealthRechargePercentPerSecond;
			WP.bCanSwatTurn = class'GearPawn'.default.bCanSwatTurn;
			WP.bCanBlindFire = class'GearPawn'.default.bCanBlindFire;
			WP.bCanRoadieRun = class'GearPawn'.default.bCanRoadieRun;
		}
		else
		{
			WP.Health = WP.DefaultHealth;
			WP.HealthMax = WP.DefaultHealth;
			WP.GroundSpeed = WP.DefaultGroundSpeed;
		}
		if (!AllowHealthRecharge(WP))
		{
			WP.HealthRechargeDelay = 0.f;
			WP.HealthRechargePercentPerSecond = 0.f;
		}
	}
	if (PlayerPawn.Controller != None)
	{
		PRI = GearPRI(PlayerPawn.PlayerReplicationInfo);
		if (PRI != None)
		{
			// apply the difficulty settings for the player
			PRI.Difficulty.static.ApplyDifficultySettings(PlayerPawn.Controller);
		}
	}
}

/**
 * Handles creating the default teams.
 */
function InitializeTeams()
{
	local int Idx;

	// initialize all the teams
	for (Idx = 0; Idx < NumTeams; Idx++)
	{
		Teams[Idx] = Spawn(class'GearTeamInfo',self);
		Teams[Idx].TeamIndex = Idx;
		GameReplicationInfo.SetTeam(Idx, Teams[Idx]);
		`RecordTeamIntStat(CREATED, Teams[Idx], 1);
	}
}

/**
 * Allows games to force the team for specific players.
 */
function int GetForcedTeam(Controller Other, int Team)
{
	// default to whatever was already specified
	return Team;
}


/** Handles switching to Team 255 (Undecided) */
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local Actor A;

	// check to see if we need to initialize teams
	if (Teams.Length < NumTeams)
	{
		InitializeTeams();
	}

	if (Other != None)
	{
		if (!bSkipForcedTeamCallHack)
		{
			N = GetForcedTeam(Other,N);
		}
		// if not already on that team
		if (N == 255 || Other.PlayerReplicationInfo.Team == None || Other.PlayerReplicationInfo.Team != Teams[N])
		{
			// remove from their current team
			if (Other.PlayerReplicationInfo.Team != None)
			{
				Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
			}

			if (N < 255)
			{
				// and attempt to add them to their new team
				if ( Teams[N].AddToTeam(Other) )
				{
					// add bots to a default squad
					if (Other.IsA('GearAI_TDM'))
					{
						Teams[N].JoinSquad('Alpha', Other);
					}
					SetPlayerClass(Other,N);

					// notify actors of team change for team-based effects
					if (PlayerController(Other) != None && LocalPlayer(PlayerController(Other).Player) != None)
					{
						foreach AllActors(class'Actor', A)
						{
							A.NotifyLocalPlayerTeamReceived();
						}
					}

					//@STATS - Record player team change
					`RecordPlayerIntStat(TEAMCHANGE,Other,N);
					return true;
				}
				return  false;
			}
			else
			{
				if ( Other.PlayerReplicationInfo.Team != None )
				{
					Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
				}

				Other.PlayerReplicationInfo.Team = none;
				GearPRI(Other.PlayerReplicationInfo).PawnClass=none;
				GearPRI(Other.PlayerReplicationInfo).bIsLeader=false;

				//@STATS - Record player team change
				`RecordPlayerIntStat(TEAMCHANGE,Other,255);
				return true;
			}
		}
		else
		{
			return true;
		}
	}
	return false;
}

/**
 * Overridden to prevent friendly fire damage.
 */
function ReduceDamage(out int Damage, Pawn injured, Controller instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local int			Idx;
	local Controller	injuredController;
	local GearPawn		InjuredGearPawn;
	local class<GearDamageType> GDT;

	InjuredGearPawn = GearPawn(Injured);
	GDT = class<GearDamageType>(DamageType);

	// Allows a DBNO player to not take damage unless finished off (Execution Rules)
	if (InjuredGearPawn != None && InjuredGearPawn.IsDBNO(,true) && instigatedBy != None && instigatedBy.Pawn != None && !CanBeShotFromAfarAndKilledWhileDownButNotOut(injured, instigatedBy.Pawn, GDT))
	{
		if (!InjuredGearPawn.IsAHostage() && VSize(instigatedBy.Pawn.Location - injured.Location) > 256.0)
		{
			Damage = 0;
			if (PlayerController(InstigatedBy) != None && !GDT.default.bEnvironmentalDamage)
			{
				PlayerController(InstigatedBy).ClientPlaySound(SoundCue'Interface_Audio.Interface.BurstDamageWarning01Cue');
			}
			// no need to process further since we've eliminated the damage
			return;
		}
	}

	// grab the injured controller
	if (injured != None)
	{
		// special case if we're driving a vehicle
		if (injured.DrivenVehicle != None)
		{
			injuredController = injured.DrivenVehicle.Controller;
		}
		if (injuredController == None)
		{
			injuredController = injured.Controller;
		}
	}

	// always disallow team damage for fortifications, including self damage
	if (GearFortification(DamageCauser) != None)
	{
		// use fortification team for unowned fortifications (spawned by Kismet, gametype, etc)
		if (InjuredGearPawn != None && InjuredGearPawn.IsAHostage())
		{
			if (WorldInfo.GRI.OnSameTeam(InjuredGearPawn.InteractionPawn, DamageCauser))
			{
				Damage = 0;
			}
		}
		else if (WorldInfo.GRI.OnSameTeam(Injured, DamageCauser))
		{
			Damage = 0;
		}
	}
	// Prevent friendly fire (but players can damage themselves)
	// always allow team damage for berserk enemies
	else if ( (GDT == none || !GDT.default.bAlwaysDamageFriendlies) && !bAllowFriendlyFire && injured != None && instigatedBy != None &&
		(GearAI(InstigatedBy) == None || !GearAI(InstigatedBy).bBerzerk) &&
		( injuredController == None || injuredController != instigatedBy ||
			(!injured.IsHumanControlled() && (InjuredGearPawn == None || !InjuredGearPawn.IsDBNO()) && GearAI_TDM(injuredController) == None) ) )
	{
		// If preventing friendly fire, then revert rules for hostages.
		// They are now treated as a shield for the kidnapper.
		// So only friends of the kidnapper (enemies of the hostage), cannot damage him.
		// Allow the kidnapper to damage the hostage for instances like grenade tagging prior to kidnapping
		if (InjuredGearPawn != None && InjuredGearPawn.IsAHostage() && instigatedBy.Pawn != InjuredGearPawn.InteractionPawn)
		{
			// Disable damage only for people in the same team as the kidnapper.
			if (WorldInfo.GRI.OnSameTeam(InjuredGearPawn.InteractionPawn, instigatedBy))
			{
				Damage = 0;
			}
		}
		// If not hostage, then ignore damage if on same team (unless it's environmental/scripted)
		else if (!GDT.default.bEnvironmentalDamage)
		{
			if (WorldInfo.GRI.OnSameTeam(injured, instigatedBy))
			{
				Damage = 0;
			}
		}
	}

	if (Damage > 0)
	{
		// notify teams of the damage
		for (Idx = 0; Idx < Teams.Length; Idx++)
		{
			Teams[Idx].NotifyTakeDamage(injured.Controller,instigatedBy);
		}
		Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
	}
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
	// kidnapper move calls us with GDT_Hostage twice; once when starting to score the kill,
	// once when exiting to kill the hostage
	if (ClassIsChildOf(DamageType, class'GDT_Hostage') && (GearPawn(Killer.Pawn) == None || GearPawn(Killer.Pawn).SpecialMove == SM_None))
	{
		return;
	}

	Super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);

	if (Killer == None || Killer == KilledPlayer)
	{
		// @STATS - Record suicide
		`RecordDeathEvent(SUICIDE,KilledPlayer,DamageType,KilledPlayer);
	}
	else
	{
		// @STATS - Record normal death
		`RecordDeathEvent(NORMAL,Killer,DamageType,KilledPlayer);
	}
}

/**
 * Overridden to notify teams of the death for the purposes of morale tracking.
 */
function NotifyKilled(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
{
	local int Idx;

	for (Idx = 0; Idx < Teams.Length; Idx++)
	{
		if (Teams[Idx] != None)
		{
			Teams[Idx].NotifyKilled(Killer,KilledPlayer,KilledPawn,damageType);
		}
	}

	// store killer for pawn
	if (GearPawn(KilledPawn) != None)
	{
		GearPawn(KilledPawn).NotifyKilled(Killer);
	}

	Super.NotifyKilled(Killer, KilledPlayer, KilledPawn, damageType);
}


/**
 * Overridden to not do anything
 * @see GearBroadcastDeathMessage
 **/
function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> damageType);

/**
 * Send out a weapon has been taken message to all players.
 **/
function GearBroadcastWeaponTakenMessage( Controller WeaponTaker, class<DamageType> damageType );

/** Allow Gametype to prevent weapon drops */
function bool CanDropWeapon(Inventory W, vector DropLocation)
{
	return TRUE;
}

/** Whether a dropped pickup is a generic drop or a special one */
function EGearDroppedPickupType GetDropType(GearDroppedPickup DroppedPickupObj)
{
	// Is not a weapon so it's generic
	if (DroppedPickupObj == None || !DroppedPickupObj.Inventory.IsA('GearWeapon'))
	{
		return eGEARDROP_Generic;
	}
	// Is a weapon so we need to see if this game type thinks it's a generic drop
	else
	{
		return GetWeaponDropType(GearWeapon(DroppedPickupObj.Inventory));
	}
}

/** Whether a weapon is a generic drop or a special one */
function EGearDroppedPickupType GetWeaponDropType(Inventory Weap)
{
	return eGEARDROP_Generic;
}

/**
 * Wrapper for determining whether the match can be started.
 *
 * @return	TRUE if all requirements for beginning the match have been met.
 */
function bool CanStartMatch()
{
	return ArePlayersReady() && !ArePlayersNeeded();
}

/**
 * Wrapper for determining whether all required players are ready to play.
 *
 * @return	TRUE if all players are ready to begin the match.
 *
 * @todo - one of the gameplay guys, please implement this method for GearGame with the correct logic
 */
function bool ArePlayersReady();

/**
 * Wrapper for determining whether the minimum number of players are connected.
 *
 * @return	TRUE if more players are needed to start the match.
 *
 * @todo - one of the gameplay guys, please implement this method for GearGame with the correct logic
 */
function bool ArePlayersNeeded();

/** @STATS - Allow game types to record various game settings */
function SetGameOptionsForStats();

/** @STATS - Setup the game stats logger for writing */
function StartLogging()
{
	local Controller C;
	local GearPC PC;
	local GearDemoRecSpectator DemoRec;
	local GearMenuPC MenuPC;
	local GearTeamInfo TeamInfo;
	local class<GameplayEventsWriter> GameplayEventsWriterClass;

`if(`notdefined(FINAL_RELEASE))
	if (WorldInfo.IsPlayInEditor())
	{
		`log("Gameplay events not recorded in PIE.");
		bLogGameplayEvents = false;
		return;
	}
`endif

	if (GameplayEventsWriter != None && GameplayEventsWriter.IsSessionInProgress())
	{
		`log("Gameplay events recording already in progress.");
		return;
	}

	//Optionally setup the gameplay event logger
	if (bLogGameplayEvents && !class'WorldInfo'.static.IsMenuLevel() && GameplayEventsWriterClassName != "")
	{
		if (GameplayEventsWriter == None)
		{
			GameplayEventsWriterClass = class<GameplayEventsWriter>(FindObject(GameplayEventsWriterClassName, class'Class'));
			if ( GameplayEventsWriterClass != None )
			{
				`log("Recording game events with"@GameplayEventsWriterClass);
				GameplayEventsWriter = new(self) GameplayEventsWriterClass;
				GameplayEventsWriter.StartLogging(GameplayEventsPollingInterval);
			}
			else
			{
				`log("Unable to record game events with"@GameplayEventsWriterClassName);
			}
		}
		else
		{
			// Already created once before, so reuse what we have (keeps SessionID)
			`Log("Resetting game events logging...");
			GameplayEventsWriter.ResetLogging(GameplayEventsPollingInterval);
		}

		// Always add this information at the start of a session
		if (GameplayEventsWriter != None && GameplayEventsWriter.IsSessionInProgress())
		{
			// @STATS - begin tracking events for this session (class,mapname,url)
			`RecordGameStringStat(GAME_CLASS,string(Class.name));
			`RecordGameStringStat(GAME_MAPNAME,GetURLMap());
			SetGameOptionsForStats();

			foreach Teams(TeamInfo)
			{
				// @STATS - log all the teams in existence at this point
			   `RecordTeamIntStat(CREATED, TeamInfo, 1);
			}

			foreach WorldInfo.AllControllers(class'Controller',C)
			{
				PC = GearPC(C);
				DemoRec = GearDemoRecSpectator(C);
				MenuPC = GearMenuPC(C);
				if (DemoRec == None && MenuPC == None)
				{
					if (PC != None)
					{
						// @STATS - log all the players who have already joined
						`RecordLoginChange(LOGIN,PC,PC.PlayerReplicationInfo.PlayerName,PC.PlayerReplicationInfo.UniqueId,PC.IsSplitScreenPlayer());
					}

					// @STATS - record team for all pawns
					`RecordPlayerIntStat(TEAMCHANGE,C,C.GetTeamNum());
				}
			}
		}
	}
	else
	{
		`log("Gameplay events will not be recorded.");
	}
}

/** Called when we want to stop logging and upload to MCP */
function EndLogging(string Reason)
{
	local WorldInfo WI;

	// Upload previous stats and start anew (handles everything but chapter complete/start)
	if (bLogGameplayEvents && GameplayEventsWriter != None && GameplayEventsWriter.IsSessionInProgress())
	{
		// End logging
		GameplayEventsWriter.EndLogging();
		WI = class'WorldInfo'.static.GetWorldInfo();
		if (OnlineSub != None && (WI.NetMode == NM_DedicatedServer || WI.NetMode == NM_ListenServer))
		{
			// Parse data and upload to MCP
			UploadGameplayStats();
		}
		else
		{
			`Log("Stats upload skipped. OnlineSub:"@OnlineSub@"NetMode:"@WI.NetMode);
		}
	}
	else
	{
		`Log("End logging skipped for stats. bLog:"@bLogGameplayEvents@"Writer:"@GameplayEventsWriter@"InProgress:"@GameplayEventsWriter != None ? string(GameplayEventsWriter.IsSessionInProgress()) : "False");
	}

	Super.EndLogging(Reason);
}

`if(`notdefined(FINAL_RELEASE))
exec function ResetLogging()
{
	EndLogging("RESET");
	StartLogging();
}
`endif

/**
 * Sends the gameplay stats to the configured services
 */
function UploadGameplayStats()
{
	local GearGameplayEventsMCPUploader MCPUploader;
 	local OnlineEventsInterface MCPInterface;

 	if (bLogGameplayEvents && GameplayEventsWriter != None && OnlineSub != None)
 	{
 		// Ask for the interface by name and cast to our well known type
 		MCPInterface = OnlineEventsInterface(OnlineSub.GetNamedInterface('McpUpload'));

 		// Submit to our LSP
 		if (MCPInterface != None)
 		{
			MCPUploader = new class'GearGameplayEventsMCPUploader';
			MCPUploader.Init();
 			MCPUploader.UploadGameplayStats(MCPInterface, GameplayEventsWriter);
 		}
		else
		{
			`Log("Upload skipped for stats. No MCPInterface.");
		}
 	}
	else
	{
		`Log("Upload skipped for stats. bLog:"@bLogGameplayEvents@"Writer:"@GameplayEventsWriter@"InProgress:"@GameplayEventsWriter.IsSessionInProgress());
	}
}

/** This is our overridden StartMatch() function **/
function StartMatch()
{
	if ( CheckForSentinelRun() )
	{
		return;
	}

	`log("Starting match...");
	Super.StartMatch();

	// transition to the new in progress state
	GotoState('MatchInProgress');


    // BugIt functionality
	// need to delay here as in MP maps there is a delay in starting the match even with QuickStart on
	SetTimer( 5.0f, FALSE, nameof(CheckForBugItCommand) );
}

function ScoreKill(Controller Killer, Controller Other)
{
}

/** called to award any score bonuses for a DBNO (beyond the basic DBNO points assigned by GearPRI::ScoreKnockdown() */
function ScoreDBNO(GearPawn DBNOPawn, Controller DBNOController, Controller InstigatedBy);

/** called to award the appropriate score for a revive */
function ScoreRevive(GearPawn Reviver, GearPawn Saved)
{
	GearPRI(Reviver.PlayerReplicationInfo).ScoreRevive(GearPRI(Saved.PlayerReplicationInfo));
}

function DelayedDiscardInventory(GearPawn Other)
{
	Super.DiscardInventory(Other);
}

function DiscardInventory(Pawn Other, optional Controller Killer)
{
	// for GearPawns we delay slightly to give the CSHD a chance to work for clients to get simultaneous kills
	if (GearPawn(Other) != None)
	{
		Other.SetTimer(0.3, false, nameof(GearPawn(Other).DelayedDeathDiscardInventory));
	}
	else
	{
		Super.DiscardInventory(Other, Killer);
	}
}

function DiscardInventoryWithoutDelay(Pawn Other, optional Controller Killer)
{
	Super.DiscardInventory(Other, Killer);
}

/** @return whether the passed in Pawn is spawn protected */
function bool IsRespawnInvincible(GearPawn TestPawn)
{
	return (WorldInfo.TimeSeconds - TestPawn.CreationTime <= RespawnInvincibilityTimer);
}

/** This will check to see if there is a BugIt command active and then call the BugItGo function **/
function CheckForBugItCommand()
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		break;
	}

	if( BugLocString != "" || BugRotString != "" )
	{
		if( PC.CheatManager != none )
		{
			//`log( "BugLocString:" @ BugLocString );
			//`log( "BugRotString:" @ BugRotString );
			PC.BugItGoString( BugLocString, BugRotString );
		}
	}
}


/** We wait a few seconds to let the level load **/
function DoMemStartupStats()
{
	SetTimer( 3.0f, FALSE, nameof(DelayedExit) );
}


function DelayedExit()
{
	`log( "doing Sentinel_Memory!" );
	ConsoleCommand( "Sentinel_Memory" );
	ConsoleCommand( "exit" );
}

function Logout(Controller Exiting)
{
	local GearPC PC;
	if (GearPC(Exiting) != None)
	{
		foreach WorldInfo.AllControllers(class'GearPC',PC)
		{
			if (PC != Exiting)
			{
				PC.ReceiveLocalizedMessage( class'GearGameMessage', 4, Exiting.PlayerReplicationInfo);

				// Notify all remote clients that their party host is exiting/disconnecting
				// This only occurs for remote party hosts since we are not handling traveling remote parties back to lobby
				// or migrating an existing party client to be a new party host.
				if (!PC.IsLocalPlayerController() &&
					// only do this when logging out of the game and not pregame lobby
					GearMPPRI(PC.PlayerReplicationInfo) != None &&
					GearMPPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId == Exiting.PlayerReplicationInfo.UniqueId)
				{
					`LogOnline("Remote party host is logging out for:"
						$" PartyOwnerUniqueId="$class'OnlineSubsystem'.static.UniqueNetIdToString(GearPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId)
						$" UniqueId="$class'OnlineSubsystem'.static.UniqueNetIdToString(Exiting.PlayerReplicationInfo.UniqueId));

					PC.ClientLogoutPartyHost(Exiting.PlayerReplicationInfo.UniqueId);
				}
			}
		}
		// Let the persistent party host know about the logout event
		GearPC(Exiting).ClientLogoutPersistentParty();

		// @STATS - Record logout event
		PC = GearPC(Exiting);
		if (PC != None && GearMenuPC(PC) == None && GearDemoRecSpectator(PC) == None)
		{
			`RecordLoginChange(LOGOUT,PC,PC.PlayerReplicationInfo.PlayerName,PC.PlayerReplicationInfo.UniqueId,PC.IsSplitScreenPlayer());
		}
	}
	Super.LogOut(Exiting);
}

event PreExit()
{
	local GearPC PC;
	foreach WorldInfo.AllControllers(class'GearPC',PC)
	{
		if (GearMenuPC(PC) == None && GearDemoRecSpectator(PC) == None)
		{
			// @STATS - Record logout event
			`RecordLoginChange(LOGOUT,PC,PC.PlayerReplicationInfo.PlayerName,PC.PlayerReplicationInfo.UniqueId,PC.IsSplitScreenPlayer());
		}
	}

	// @STATS - Write out our stats to file, Vince, etc.
	EndLogging("PreExit");
	Super.PreExit();
}

auto State PendingMatch
{
	function CheckStartMatch()
	{
		// start the match immediately
		StartMatch();
	}

Begin:
	CheckStartMatch();
	Sleep(1.f);
	Goto('Begin');
}

state MatchInProgress
{
	function BeginState(Name PreviousStateName)
	{
		GetGRI().GameStatus = GS_RoundInProgress;
		Super.BeginState(PreviousStateName);
	}


Begin:
	if( (CauseEventCommand != "") && (MyAutoTestManager != None) )
	{
		MyAutoTestManager.GotoState('SentinelHandleCauseEventCommand');
	}
}

event TriggerGUDEvent(EGUDEventID ID, Pawn InstigatedBy, optional Pawn Recipient, optional float Delay)
{
	UnscriptedDialogueManager.TriggerGUDEvent(ID, InstigatedBy, Recipient, Delay);
}

exec function FF()
{
	local PlayerController PC;
	local GearGRI GRI;

	bAllowFriendlyFire = !bAllowFriendlyFire;
	GRI = GearGRI(GameReplicationInfo);
	if( GRI != None )
	{
		GRI.bAllowFriendlyFire = bAllowFriendlyFire;
	}

	// Get the first local player controller
	foreach LocalPlayerControllers(class'PlayerController', PC) { break; }
	PC.ClientMessage("bAllowFriendlyFire is"@bAllowFriendlyFire);
}

/**
 * Does this game type allow pawns to recharge health?
 */
function bool AllowHealthRecharge(GearPawn Pawn)
{
	local GearMutator GMut;
	local bool bResult;

	// allow players and friendly ai to recharge
	GMut = GetBaseGearMutator();
	bResult = (Pawn.IsPlayerOwned() || Pawn.bCanRechargeHealth);
	return (GMut == None) ? bResult : GMut.AllowHealthRecharge(bResult, Pawn);
}

function bool AutoReviveOnBleedOut( Pawn TestPawn );
function bool CanBeShotFromAfarAndKilledWhileDownButNotOut(Pawn TestPawn, Pawn InstPawn, class<GearDamageType> TheDamageType);

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	local int i;

	Super.GetSeamlessTravelActorList(bToEntry, ActorList);

	for (i = 0; i < Teams.length; i++)
	{
		if (Teams[i] != None && (bToEntry || Teams[i].Size > 0))
		{
			ActorList[ActorList.length] = Teams[i];
		}
	}

	// add GRI even when going to destination so we can copy some stuff
	if (!bToEntry)
	{
		ActorList[ActorList.length] = WorldInfo.GRI;
	}
}

event PostSeamlessTravel()
{
	InitializeTeams();

	Super.PostSeamlessTravel();
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	local TeamInfo NewTeam;

	if ( C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.Team != None && C.PlayerReplicationInfo.Team.TeamIndex < Teams.length &&
		Teams[C.PlayerReplicationInfo.Team.TeamIndex] != C.PlayerReplicationInfo.Team )
	{
		// move this player to the new team object with the same team index
		NewTeam = Teams[C.PlayerReplicationInfo.Team.TeamIndex];
		// if the old team would now be empty, we don't need it anymore, so destroy it
		if (C.PlayerReplicationInfo.Team.Size <= 1)
		{
			C.PlayerReplicationInfo.Team.Destroy();
		}
		else
		{
			C.PlayerReplicationInfo.Team.RemoveFromTeam(C);
		}
		NewTeam.AddToTeam(C);
	}

	Super.HandleSeamlessTravelPlayer(C);
}

/**
 * Overridden so we can have our pawn just be reset nicely as there is all kinds of logic
 * that shorts circuits the call to ClientRestart
 **/
function RestartPlayer(Controller NewPlayer)
{
	Super.RestartPlayer(NewPlayer);

	if (NewPlayer.Pawn != None)
	{
		//@STATS - Record player spawn in
		`RecordPlayerSpawn(NewPlayer,NewPlayer.Pawn.Class,NewPlayer.GetTeamNum());

		GearPRI(NewPlayer.PlayerReplicationInfo).ClearDeathVariables();

		NewPlayer.Pawn.ClientRestart();
	}
}

/**
 * @Returns true if we should show a lobby on login
 */
function bool ShowLobby(GearPC LobbyTarget)
{
	return false;
}

function InitGameReplicationInfo()
{
	local GearGRI WGRI;

	Super.InitGameReplicationInfo();

	WGRI = GetGRI();
	if (WGRI!=none)
	{
		WGRI.bIsDedicatedListenServer = bIsDedicatedListenServer;
	}
}


/**
 * Returns the total number of human players currently in the game.
 */
final function int GetHumanPlayerCount()
{
	local PlayerController Player;
	local int Count;

	foreach WorldInfo.AllControllers(class'PlayerController', Player)
	{
		if (!Player.bPendingDelete)
		{
			Count++;
		}
	}

	return Count;
}

function SetPlayerClass(Controller Other,int N);

/**
 * Converts a character type enum value string into its byte value.
 *
 * @param	TeamIndex			determines which enum is used for converting the string value.
 * @param	EnumValueString		a string representing a value from either the ECogMPCharacter or the ELocustMPCharacter
 *								enums, depending on the specified TeamIndex.
 *
 * @return	the actual byte value of the specified enum value string
 */
static final function byte ConvertCharacterValueStringToByte( int TeamIndex, string EnumValueString )
{
	local int i, MaxCharacters;
	local byte Result;

	MaxCharacters = (TeamIndex % 2) == 0 ? CMPC_MAX : LMPC_MAX;
	for ( i = 0; i < MaxCharacters; i++ )
	{
		if ( EnumValueString == string(GetEnum(class'GearUIDataStore_GameResource'.static.GetTeamCharacterProviderIdType(TeamIndex),i)) )
		{
			Result = i;
			break;
		}
	}

	return Result;
}

/**
 * Retrieves the ProfileId value for a GearGameCharacterSummary data provider.
 *
 * @param	CharacterProviderIndex	the index [into the GameResource data store's list of character data providers; the owning player's
 *									current team will determine which of the data store's lists of character providers will be used.
 *
 * @return	the value of the specified character data provider's ProfileId; will be one of the values of either the
 *			ECogMPCharacter or ELocustMPCharacter enums, depending on the player's team.
 */
static final function byte GetCharacterIdFromProviderIndex(int TeamIndex, int CharacterProviderIndex)
{
	local GearUIDataStore_GameResource GameResourceDS;
	local UIProviderScriptFieldValue CharacterValue;
	local byte Result;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if (GameResourceDS != None)
	{
		if (GameResourceDS.GetProviderFieldValue(GameResourceDS.GetTeamCharacterProviderTag(TeamIndex), 'ProfileId', CharacterProviderIndex, CharacterValue))
		{
			Result = ConvertCharacterValueStringToByte(TeamIndex, CharacterValue.StringValue);
		}
		else
		{
			Result = 255;
		}
	}

	return Result;
}

static final function int FindCharacterProviderIndex(int TeamIndex, byte ProfileId)
{
	local GearUIDataStore_GameResource GameResourceDS;
	local UIProviderScriptFieldValue CharacterValue;
	local int Result;
	local name TeamName;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	if ( GameResourceDS != None )
	{
		CharacterValue.PropertyTag = 'ProfileId';
		CharacterValue.PropertyType = DATATYPE_Property;
		CharacterValue.StringValue = string(GetEnum(GameResourceDS.GetTeamCharacterProviderIdType(TeamIndex), ProfileId));
		CharacterValue.ArrayValue.AddItem(ProfileId);

		TeamName = GameResourceDS.GetTeamCharacterProviderTag(TeamIndex);

		Result = GameResourceDS.FindProviderIndexByFieldValue(TeamName, 'ProfileId', CharacterValue);
	}

	return Result;
}

static final function string GetCharacterProviderClassName(int TeamIndex, int ProfileId)
{
	local GearUIDataStore_GameResource GameResourceDS;
	local UIProviderScriptFieldValue CharacterValue;
	local string Result;
	local name TeamName;
	local int ProviderIndex;

	ProviderIndex = FindCharacterProviderIndex(TeamIndex, ProfileId);
	if (ProviderIndex != INDEX_NONE)
	{
		GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
		if (GameResourceDS != None)
		{
			TeamName = GameResourceDS.GetTeamCharacterProviderTag(TeamIndex);
			if (GameResourceDS.GetProviderFieldValue(TeamName, 'ClassPathName', ProviderIndex, CharacterValue))
			{
				Result = CharacterValue.StringValue;
			}
		}
	}

	return Result;
}

/**
 * Called when the link status indicates the player has removed their network
 * connection. Used to mark them as losing.
 */
function SetHostTamperedWithMatch();
/** Called from AI factories when a spawn is killed */
event SpawnFromAIFactoryHasDied(Pawn KilledSpawn, SeqAct_AIFactory AIFactory);

/** Called from AI factories when a spawner had been disabled */
event AIFactoryDisabled( int NumUnspawnedPawns, SeqAct_AIFactory AIFactory );

/** Let's the game decide whether the PC should respawn or not */
function bool ShouldRespawnPC( int TeamIdx, Controller PCToRespawn )
{
	return TeamHasRespawn(TeamIdx);
}

/** Whether the team has a respawn left */
function bool TeamHasRespawn(int TeamIdx);

/** adds the specified player to the respawn queue */
function StartRespawning(Controller C)
{
	GearPRI(C.PlayerReplicationInfo).PlayerStatus = WPS_Respawning;
}

/** Send a sound to all player controllers */
function BroadcastSound( SoundCue ASound )
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers( class'PlayerController', PC )
	{
		PC.ClientPlaySound( ASound );
	}
}

// ---
// Spectator point functionality
// --

/** Finds all of the spectator cameras in the map and puts them into a list to be used when in spectator mode */
protected function AcquireSpectatorPoints()
{
	local GearSpectatorPoint SpecPoint;
	local int Idx;

	// make sure the list is empty
	SpectatorPoints.length = 0;

	// Find and sort the spectator camera points
	foreach DynamicActors( class'GearSpectatorPoint', SpecPoint )
	{
		for ( Idx = 0; Idx < SpectatorPoints.length; Idx++ )
		{
			if ( SpectatorPoints[Idx].OrderIndex > SpecPoint.OrderIndex )
			{
				SpectatorPoints.Insert( Idx, 1 );
				SpectatorPoints[Idx] = SpecPoint;
				break;
			}
		}

		if ( Idx == SpectatorPoints.length )
		{
			SpectatorPoints[Idx] = SpecPoint;
		}
	}
}


/** Returns the first spectator camera if there is one available */
function GearSpectatorPoint GetFirstSpectatorPoint()
{
	if (SpectatorPoints.length == 0)
	{
		AcquireSpectatorPoints();
	}

	if ( SpectatorPoints.length > 0 )
	{
		return SpectatorPoints[0];
	}

	return None;
}

/** Returns the next spectator camera based on the one currently being viewed */
function GearSpectatorPoint GetNextSpectatorPoint( GearSpectatorPoint CurrPoint )
{
	local int Idx;
	local GearSpectatorPoint NextPoint;

	NextPoint = CurrPoint;

	if ( SpectatorPoints.length > 1 )
	{
		Idx = SpectatorPoints.Find( CurrPoint );
		if ( Idx != -1 )
		{
			NextPoint = SpectatorPoints[ ++Idx % SpectatorPoints.length ];
		}
	}

	return NextPoint;
}

/** Returns the previous spectator camera based on the one currently being viewed */
function GearSpectatorPoint GetPrevSpectatorPoint( GearSpectatorPoint CurrPoint )
{
	local int Idx;
	local GearSpectatorPoint PrevPoint;

	PrevPoint = CurrPoint;

	if ( SpectatorPoints.length > 1 )
	{
		Idx = SpectatorPoints.Find( CurrPoint );
		if ( Idx != -1 )
		{
			PrevPoint = (Idx == 0) ? SpectatorPoints[ SpectatorPoints.length-1 ] : SpectatorPoints[ Idx-1 ];
		}
	}

	return PrevPoint;
}

/** called when a pawn goes DBNO */
function NotifyDBNO(Controller InstigatedBy, Controller Victim, Pawn DownedPawn);

/** Function called when someone becomes kidnapped */
function KidnappingStarted( GearPawn Hostage, GearPawn Kidnapper )
{
	// @STATS - Hostage taken (go through PRI to get Controller, its not on the pawn)
	`RecordPlayerPlayerEvent(HOSTAGE_TAKEN, Kidnapper.Controller, Controller(Hostage.PlayerReplicationInfo.Owner));
}
/** Function called when someone is released from kidnapping */
function KidnappingStopped( GearPawn Hostage, GearPawn Kidnapper );

/**
 * Initializes the gameplay stats upload object
 */
event InitGame(string Options, out string ErrorMessage)
{
	local int i;

	Super.InitGame(Options, ErrorMessage);

	for (i = 0; i < AutoMutators.length; i++)
	{
		AddMutator("GearGame." $ AutoMutators[i], false);
	}

	bDoLocScreenShotTest = ( ParseOption( Options, "DoLocScreenShotTest" ) ~= "1" );

	bDoAutomatedHordeTesting = ( ParseOption( Options, "AutomatedHorde" ) ~= "1" );

	// so if either of two skip ways are true AND the "secret" enabling way is NOT true then we want to skip matinees
	bSkipAllMatinees = ( bSkipAllMatinees || ( ( (ParseOption( Options, "SkipAllMatinees") ~= "1") ) || (ParseOption( Options, "gSAM") ~= "1") )  )
		&& (ParseOption( Options, "WatchAllMatinees") != "31337");

`if(`notdefined(FINAL_RELEASE))
	bForceStats = HasOption(Options, "forcestats");
`endif

	// Allow each game type to override where that is set
	SetNetworkNotificationLocation();

	// @STATS - Record game settings
	`RecordGameStringStat(GAME_CLASS,string(Class));
	`RecordGameStringStat(GAME_MAPNAME,GetURLMap());
	`RecordGameStringStat(GAME_OPTION_URL,Options);
}

/**
 * Cleanup any references
 */
function DestroyPersistentParty()
{
	if (OnlineSub != None)
	{
		HostPersistentPartyBeacon = GearPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
		if (HostPersistentPartyBeacon != None)
		{
			`LogBeacon("Destroying the GearPersistentPartyBeaconHost "$self);

			HostPersistentPartyBeacon.DestroyBeacon();
			HostPersistentPartyBeacon = None;
		}
		OnlineSub.SetNamedInterface('PersistentPartyHostBeacon',None);
	}
}

/**
 * Clear references at end of game
 */
function GameEnding()
{
	if (HostPersistentPartyBeacon != None)
	{
		HostPersistentPartyBeacon.OnReservationChange = None;
		HostPersistentPartyBeacon.OnReservationsFull = None;
		HostPersistentPartyBeacon.OnClientCancellationReceived = None;
		HostPersistentPartyBeacon = None;
	}

	Super.GameEnding();
}

/** Returns the persistent party beacon from the host */
function int GetNumConsumedPartyReservations()
{
	local GearPersistentPartyBeaconHost HostBeacon;

	HostBeacon = GearPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
	return (HostBeacon != None) ? HostBeacon.NumConsumedReservations : 0;
}

/**
 * Allow each game type to override where that is set. The default is lower right
 */
function SetNetworkNotificationLocation()
{
	if (OnlineSub != None &&
		OnlineSub.SystemInterface != None)
	{
		OnlineSub.SystemInterface.SetNetworkNotificationPosition(NNP_BottomRight);
	}
}

/**
 * Skip this step as we don't want this
 */
function RegisterServer()
{
	// joeg - purposefully left blank
}

/**
 * Skips skill updates since the party system manages all skills for sessions
 */
function RecalculateSkillRating()
{
	// joeg - purposefully left blank
}

/**
 * Iterates all clients updating their rich presence string
 * NOTE: This does not set any parameters so only set non-parameterized strings
 *
 * @param StringId the string to set as their presence text
 */
function SetClientsRichPresenceStrings(int StringId)
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC',PC)
	{
		PC.ClientSetRichPresenceString(StringId);
	}
}

function NotifyNavigationChanged( NavigationPoint N )
{
	local GearAI AI;
	local int	 Idx;

	if( N.bBlocked )
	{
		foreach WorldInfo.AllControllers( class'GearAI', AI )
		{
			if( !AI.bMovingToGoal )
				continue;

			Idx = AI.RouteCache.Find( N );
			if( Idx >= 0 )
			{
				AI.bReevaluatePath = TRUE;
				AI.MoveTimer = -1.f;
			}
		}
	}
}

/** @return whether all living players are DBNO, used for co-op/Horde failure conditions */
final function bool AllPlayersAreDBNO()
{
	local Controller C;
	local GearPawn P;

	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (C.IsPlayerOwned())
		{
			P = GearPawn(C.Pawn);
			if (P != None && !P.IsDBNO())
			{
				return FALSE;
			}
			// turrets are people too!
			if (Vehicle(C.Pawn) != None)
			{
				return FALSE;
			}
		}
	}

	return TRUE;
}

final function bool TeamHasAnyChanceOfSurvival(int TeamIdx, optional GearPawn DBNOPawn)
{
	local Controller C;
	local GearPC PC;
	local GearAI AI;
	local GearPawn GP;
	local bool bFoundReviver;

	// if we are in co-op then you lose if all human players go down no matter what
	if (NumPlayers > 1 && AllPlayersAreDBNO())
	{
		`log("All players are DBNO in coop!");
		return FALSE;
	}
	// search for a DBNO player if one wasn't specified
	if (DBNOPawn == None)
	{
		foreach WorldInfo.AllPawns(class'GearPawn',GP)
		{
			if (GP.IsDBNO() && GP.IsPlayerOwned() && GP.GetTeamNum() == TeamIdx)
			{
				DBNOPawn = GP;
				break;
			}
		}
	}
	//`log(WorldInfo.TimeSeconds@"Looking for team survival"@`showvar(TeamIdx)@`showvar(DBNOPawn)@`showvar(bInCoopSplit)@`showvar(bInSoloSplit)@`showvar(bGapSquadSplit));
	// if nobody is DBNO then survival is good :)
	if (DBNOPawn == None)
	{
		return TRUE;
	}
	if (bInSoloSplit)
	{
		`Log("Solo split, no one to perform revive");
		return false;
	}
	// look for someone to revive the DBNO pawn
	bFoundReviver = FALSE;
	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (C.GetTeamNum() == TeamIdx && C != DBNOPawn.Controller)
		{
			GP = GearPawn(C.Pawn);
			if (GP == None && GearTurret(C.Pawn) != None)
			{
				GP = GearPawn(GearTurret(C.Pawn).Driver);
			}
			if (GP == None || GP.Health <= 0 || GP.IsDBNO())
			{
				continue;
			}
			AI = GearAI(C);
			if (AI != None && AI.CanRevivePawn(DBNOPawn,TRUE))
			{
				if( !bInCoopSplit || !bGapSquadSplit || AI.GetSquadName() == GearPRI(DBNOPawn.PlayerReplicationInfo).SquadName)
				{
					`log("AI:"@AI.PlayerReplicationInfo.PlayerName@"can revive:"@DBNOPawn.PlayerReplicationInfo.PlayerName);
					bFoundReviver = TRUE;
					break;
				}
			}
			else
			{
				PC = GearPC(C);
				if (PC != None && (!bInCoopSplit || !bGapSquadSplit || (GearPRI(PC.PlayerReplicationInfo).SquadName == GearPRI(DBNOPawn.PlayerReplicationInfo).SquadName && !PC.IsInState('Reviving'))))
				{
					//`log("PC:"@PC.PlayerReplicationInfo.PlayerName@"can revive:"@DBNOPawn.PlayerReplicationInfo.PlayerName);
					bFoundReviver = TRUE;
					break;
				}
			}
	    }
	}
	return bFoundReviver;
}

/**
 * Tells clients to set their invite settings to the specified values
 *
 * @param bAllowInvites whether invites are allowed or not
 * @param bAllowJoinViaPresence whether join via presence is allowed or not
 * @param bAllowJoinViaPresenceFriendsOnly whether friends only join via presence is allowed or not
 */
function TellClientsToSetPartyInviteFlags(bool bAllowInvites,bool bAllowJoinViaPresence,bool bAllowJoinViaPresenceFriendsOnly)
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC',PC)
	{
		PC.ClientSetPartyInviteFlags(bAllowInvites,bAllowJoinViaPresence,bAllowJoinViaPresenceFriendsOnly);
	}
}

/** @return the first mutator in the mutator list that's a GearMutator */
final function GearMutator GetBaseGearMutator()
{
	local Mutator M;
	local GearMutator GMut;

	for (M = BaseMutator; M != None; M = M.NextMutator)
	{
		GMut = GearMutator(M);
		if (GMut != None)
		{
			return GMut;
		}
	}

	return None;
}

/** This allows us to have a generic interface which GameReplicationInfo can call when receiving the GameClass to set and performance settings per game type **/
static simulated function DoGameSpecificPerformanceSettings(WorldInfo TheWorldInfo);

/** ==== PATH CONSTRAINT/GOAL EVALUATOR POOLING ==== */

final function CreatePathConstraintCache()
{
	PathConstraintCache.length = NUM_CONSTAINT_CLASSES;
	PathGoalEvaluatorCache.length = MAX_GOALEVALUATORS;
}

final function PathConstraint GetPathConstraintFromCache(class<PathConstraint> ConstraintClass, Pawn Requestor)
{
	local int CacheIdx;
	local PathConstraintCacheDatum PDC;
	local PathConstraint ChosenConstraint;

	if( PathConstraintCache.length == 0 )
	{
		CreatePathConstraintCache();
	}


	CacheIdx = ConstraintClass.default.CacheIdx;
	if(CacheIdx < 0 || CacheIdx > NUM_CONSTAINT_CLASSES)
	{
		`if(`notdefined(FINAL_RELEASE))
			`log("OH NOES! Couldn't get path constraint from pool for "$Requestor$"!! Class was "$ConstraintClass$"CacheIdx:"@CacheIdx@"Numclasses:"@NUM_CONSTAINT_CLASSES);
			ScriptTrace();
		`endif
		return new ConstraintClass;
	}

	PDC = PathConstraintCache[CacheIdx];
	if(++PathConstraintCache[CacheIdx].ListIdx >= MAX_PATHCONST_INSTANCES_PER_CLASS)
	{
		PathConstraintCache[CacheIdx].ListIdx=0;
	}

	ChosenConstraint = PDC.List[PDC.ListIdx];
	if(ChosenConstraint == none || ChosenConstraint.IsPendingKill())
	{
		//`log(Requestor@"Pool entry was empty for class"@ConstraintClass@CacheIdx@" newing a new constraint..."@PathConstraintCache[CacheIdx].ListIdx);
		ChosenConstraint = new ConstraintClass;
		PDC.List[PDC.ListIdx] = ChosenConstraint;
	}
	else
	{
		//`log(Requestor@"Using"@PathConstraintCache[CacheIdx].List[PathConstraintCache[CacheIdx].ListIdx]@"from pool.. requestedclass:"@ConstraintClass@CacheIdx@PathConstraintCache[CacheIdx].ListIdx);
	}

	ChosenConstraint.Recycle();
	return ChosenConstraint;
}

final function PathGoalEvaluator GetPathGoalEvaluatorFromCache(class<PathGoalEvaluator> GoalEvalClass, Pawn Requestor)
{
	local int CacheIdx;
	local PathGoalEvaluator ChosenEval;

	if( PathGoalEvaluatorCache.length == 0 )
	{
		CreatePathConstraintCache();
	}


	CacheIdx = GoalEvalClass.default.CacheIdx;
	if(CacheIdx < 0 || CacheIdx > MAX_GOALEVALUATORS)
	{
		`if(`notdefined(FINAL_RELEASE))
			`log("OH NOES! Couldn't get path goal evaluator from pool for "$Requestor$"!! Class was "$GoalEvalClass$"CacheIdx:"@CacheIdx@"MaxGoalEvals:"@MAX_GOALEVALUATORS);
			ScriptTrace();
		`endif
		return new GoalEvalClass;
	}

	ChosenEval = PathGoalEvaluatorCache[CacheIdx];
	if(ChosenEval == none || ChosenEval.IsPendingKill())
	{
		//`log(Requestor@"Pool was empty for class"@GoalEvalClass@CacheIdx@" newing a new goal evaluator...");
		ChosenEval = new GoalEvalClass;
		PathGoalEvaluatorCache[CacheIdx] = ChosenEval;
	}
	else
	{
		//`log(Requestor@"Using"@PathGoalEvaluatorCache[CacheIdx]@"from pool.. requestedclass:"@GoalEvalClass@CacheIdx);
	}

	ChosenEval.Recycle();
	return ChosenEval;
}

/**
 * @param GameSettings online game settings with the party slot context entries
 * @return max need size of the game settings
 */
final function int GetGameSettingsNeedsSize(OnlineGameSettings GameSettings)
{
	local int CurrentNeedSize,PartySlotVal;

	CurrentNeedSize = -1;
	if (GameSettings != None)
	{
		if (GameSettings.GetStringSettingValue(CONTEXT_PARTYSLOT_5,PartySlotVal) &&
			PartySlotVal == CONTEXT_PARTYSLOT_NEEDS)
		{
			CurrentNeedSize = 5;
		}
		else if (GameSettings.GetStringSettingValue(CONTEXT_PARTYSLOT_4,PartySlotVal) &&
			PartySlotVal == CONTEXT_PARTYSLOT_NEEDS)
		{
			CurrentNeedSize = 4;
		}
		else if (GameSettings.GetStringSettingValue(CONTEXT_PARTYSLOT_3,PartySlotVal) &&
			PartySlotVal == CONTEXT_PARTYSLOT_NEEDS)
		{
			CurrentNeedSize = 3;
		}
		else if (GameSettings.GetStringSettingValue(CONTEXT_PARTYSLOT_2,PartySlotVal) &&
			PartySlotVal == CONTEXT_PARTYSLOT_NEEDS)
		{
			CurrentNeedSize = 2;
		}
		else if (GameSettings.GetStringSettingValue(CONTEXT_PARTYSLOT_1,PartySlotVal) &&
			PartySlotVal == CONTEXT_PARTYSLOT_NEEDS)
		{
			CurrentNeedSize = 1;
		}
		else if (GameSettings.GetStringSettingValue(CONTEXT_PARTYSLOT_1,PartySlotVal) &&
			PartySlotVal == CONTEXT_PARTYSLOT_BLOCKED)
		{
			CurrentNeedSize = 0;
		}
	}

	return CurrentNeedSize;
}

/**
 * Delegate fired when a update request has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
delegate OnUpdateOnlineGameComplete(name SessionName,bool bWasSuccessful);

/**
 * Update the advertised slots that our current session can handle using the game settings object.
 * Party slot entry == to NeedSize is set to CONTEXT_PARTYSLOT_NEEDS
 * Party slot entries < NeedSize are set to CONTEXT_PARTYSLOT_WANTS
 * Party slot entries > NeedSize are set to CONTEXT_PARTYSLOT_BLOCKED
 *
 * @param SessionName name of online game session that will be updated
 * @param NeedSize updated party size that we can accommodate in the current session
 * @param bUpdateSession if true then the session is updated with the new settings
 * @param UpdateOnlineGameCompleteDelegate delegate to call when update complete occurs
 */
final function SetGameSettingNeedsSize(name SessionName, int NeedSize, optional bool bUpdateSession=true, optional delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate=None)
{
	local OnlineGameSettings GameSettings;

	if (GameInterface != None)
	{
		GameSettings = GameInterface.GetGameSettings(SessionName);
		if (GameSettings != None)
		{
			`LogOnline("Updating session needs/wants"
				$" NeedSize="$NeedSize
				$" SessionName="$SessionName);

			if (GetGameSettingsNeedsSize(GameSettings) != NeedSize)
			{
				// Set these to not joinable
				GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_1,CONTEXT_PARTYSLOT_BLOCKED);
				GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_2,CONTEXT_PARTYSLOT_BLOCKED);
				GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_3,CONTEXT_PARTYSLOT_BLOCKED);
				GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_4,CONTEXT_PARTYSLOT_BLOCKED);
				GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_5,CONTEXT_PARTYSLOT_BLOCKED);

				// Set the size for our optimal and acceptable partial parties
				switch (NeedSize)
				{
				case 5:
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_5,CONTEXT_PARTYSLOT_NEEDS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_4,CONTEXT_PARTYSLOT_WANTS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_3,CONTEXT_PARTYSLOT_WANTS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_2,CONTEXT_PARTYSLOT_WANTS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_1,CONTEXT_PARTYSLOT_WANTS);
					break;
				case 4:
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_4,CONTEXT_PARTYSLOT_NEEDS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_3,CONTEXT_PARTYSLOT_WANTS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_2,CONTEXT_PARTYSLOT_WANTS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_1,CONTEXT_PARTYSLOT_WANTS);
					break;
				case 3:
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_3,CONTEXT_PARTYSLOT_NEEDS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_2,CONTEXT_PARTYSLOT_WANTS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_1,CONTEXT_PARTYSLOT_WANTS);
					break;
				case 2:
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_2,CONTEXT_PARTYSLOT_NEEDS);
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_1,CONTEXT_PARTYSLOT_WANTS);
					break;
				case 1:
					GameSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_1,CONTEXT_PARTYSLOT_NEEDS);
					break;
				case 0:
					break;
				default:
					`LogOnline("Invalid NeedSize.");
				}

				if (bUpdateSession && UpdateOnlineGameCompleteDelegate != None)
				{
					// Setup the delegate if we're async
					GameInterface.AddUpdateOnlineGameCompleteDelegate(UpdateOnlineGameCompleteDelegate);
				}

				// Now update the settings so that players can find them
				GameInterface.UpdateOnlineGame(SessionName,GameSettings,bUpdateSession);
			}
			else
			{
				`LogOnline("NeedSize already at "$NeedSize);
				if (bUpdateSession && UpdateOnlineGameCompleteDelegate != None)
				{
					// Fire the delegate as though it completed successfully
					UpdateOnlineGameCompleteDelegate(SessionName,true);
				}
			}
		}
	}
}

function bool AllowCheats(PlayerController P)
{
`if(`notdefined(FINAL_RELEASE))
	return true;
`else
	return false;
`endif
}

defaultproperties
{
	MaxPlayersAllowed=10

	PlayerReplicationInfoClass=class'GearGame.GearPRI'
	PlayerControllerClass=class'GearGame.GearPC'
	DefaultPawnClass=class'GearGame.GearPawn_COGMarcus'
	GameReplicationInfoClass=class'GearGame.GearGRI'
	bRestartLevel=FALSE
	bDelayedStart=TRUE
	bShouldDisplayAlliesViaTaccom=true
	bShouldDisplayWeaponPickupsViaTaccom=true
	bShouldDisplayTaggedGrenadesViaTaccom=true
	bCanDropBasicWeapons=true

`if(`notdefined(FINAL_RELEASE))
	// For testing purposes make this only require 2
	MinRankedPlayers=2
`endif

	Begin Object Class=AIVisibilitymanager Name=VisMan0
	End Object
	AIVisMan=VisMan0

	MaxSightRadius_COG=-1.0
	MaxSightRadius_Locust=-1.0
	MaxHearingRadius_COG=-1.0
	MaxHearingRadius_Locust=-1.0

	DifficultyLevels[DL_Casual]=class'DifficultySettings_Casual'
	DifficultyLevels[DL_Normal]=class'DifficultySettings_Normal'
	DifficultyLevels[DL_Hardcore]=class'DifficultySettings_Hardcore'
	DifficultyLevels[DL_Insane]=class'DifficultySettings_Insane'
}
