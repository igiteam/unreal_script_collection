/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMGame extends HDBaseGame
	config(Game)
	dependson(TMCharInfo)
	native;





 





























	
	








































































































































































































#linenumber 42;


#linenumber 12;


/** if set, when this class is compiled, a menu entry for it will be automatically added/updated in its package.ini file
 * (abstract classes are skipped even if this flag is set)
 */
var bool bExportMenuData;

var bool				bWeaponStay;              // Whether or not weapons stay when picked up.
var bool				bTeamScoreRounds;
var bool				bSoaking;
var bool				bPlayersVsBots;
var bool				bCustomBots;

var string Acronym;
var localized string Description;

var globalconfig	int		ServerSkillLevel;	// The Server Skill Level ( 0 - 2, Beginner/Experienced/Expert )
var globalconfig	float	EndTimeDelay;
var globalconfig	float	BotRatio;			// only used when bPlayersVsBots is true
var config			int 	NetWait;       // time to wait for players in netgames w/ bWaitForNetPlayers (typically team games)
/** how long we wait for clients to perform initial processing at the start of the game (TMPlayerController::bInitialProcessingComplete) */
var config int ClientProcessingTimeout;
var globalconfig	int		MinNetPlayers; // how many players must join before net game will start
var globalconfig	int		RestartWait;

var					bool	bAutoNumBots;			// Match bots to map's recommended bot count
var globalconfig	bool	bPlayersMustBeReady;	// players must confirm ready for game to start
var globalconfig	bool	bForceRespawn;			/** Force dead players to respawn immediately if true (configurable) */
var					bool	bTempForceRespawn;		/** Temporary (used in game) version of bForceRespawn */
var globalconfig	bool    bWaitForNetPlayers;     // wait until more than MinNetPlayers players have joined before starting match
var					bool	bShouldWaitForNetPlayers;	// True if bWaitForNetPlayers and net game.

var config bool bWarmupRound;			// If true, this match will have a warmup round
var config int WarmupTime;				// How long is the warmup round (In Seconds)
var					int		WarmupRemaining;		// How much time left in the Warmup Round

var bool	bFirstBlood;
var bool	bQuickStart;
var bool	bSkipPlaySound;		// override "play!" sound
var bool	bStartedCountDown;
var bool	bFinalStartup;
var bool	bOverTimeBroadcast;
var bool bMustHaveMultiplePlayers;
var bool bPlayerBecameActive;
var bool    bMustJoinBeforeStart;   // players can only spectate if they join after the game starts
var bool	bDemoMode;				// turn off HUD, etc.
/** whether not yet driven vehicles can take damage */
var bool bUndrivenVehicleDamage;

var byte StartupStage;              // what startup message to display
var int DesiredPlayerCount;			// bots will fill in to reach this value as needed

var float		SpawnProtectionTime;
var int			DefaultMaxLives;
var config int			LateEntryLives;	// defines how many lives in a player can still join

var int PendingMatchElapsedTime;
var int CountDown;
var float AdjustedDifficulty;
var int PlayerKills, PlayerDeaths;

var NavigationPoint LastPlayerStartSpot;    // last place current player looking for start spot started from
var NavigationPoint LastStartSpot;          // last place any player started from

var float EndTime;
var int             EndMessageWait;         // wait before playing which team won the match
var transient int   EndMessageCounter;      // end message counter

var   string			      RulesMenuType;			// Type of rules menu to display.
var   string				  GameUMenuType;			// Type of Game dropdown to display.

var actor EndGameFocus;

var() int                     ResetCountDown;
var() config int              ResetTimeDelay;           // time (seconds) before restarting teams

var TMVehicle VehicleList;

var TMTeamInfo EnemyRoster;
var string EnemyRosterName;

// hoverboard
var			bool	bAllowHoverboard;

var class<TMVictoryMessage>	VictoryMessageClass;
// struct native GameTypePrefix
// {
// 	/** map prefix, e.g. "DM" */
// 	var string Prefix;
// 	/** gametype used if none specified on the URL */
// 	var string GameType;
// 	/** additional gametypes supported by this map prefix via the URL (used for cooking) */
// 	var array<string> AdditionalGameTypes;
// };
//var array<GameTypePrefix> DefaultMapPrefixes; /** Used for loading appropriate game type if non-specified in URL */
//var globalconfig array<GameTypePrefix> CustomMapPrefixes; /** Used for loading appropriate game type if non-specified in URL */
var array<string> MapPrefixes; /** Prefix characters for names of maps for this game type */

// console server
var bool bConsoleServer;

/** PlayerController class to use on consoles */
var class<PlayerController> ConsolePlayerControllerClass;

/**
 * This being false implies that only gamepads are valid for input type.
 * This is not 100% precise as you could have a keyboard + gamepad which could be valid if we wanted to allow typing but no movement.
 **/
var bool bAllowKeyboardAndMouse;

/** Used by the single player game */
var int SinglePlayerMissionID;

/** prefix of filename to record a demo to - a number is added on to get a unique filename (empty string means don't record) */
var string DemoPrefix;

/** class used for AI bots */
var class<TMBot> BotClass;

// These variables are set by the UI on the default object and should be read using the default object of class'TMGame'.

/** Game Map Cycles, there is a map cycle per game mode */
struct native GameMapCycle
{
	var name GameClassName;
	var array<string> Maps;
};
var globalconfig array<GameMapCycle> GameSpecificMapCycles;
/** index of current map in the cycle */
var globalconfig int MapCycleIndex;

/** Array of active bot names. */
struct native ActiveBotInfo
{
	/** name of character */
	var string BotName;
	/** whether the bot is currently in the game */
	var bool bInUse;
};
var globalconfig array<ActiveBotInfo> ActiveBots;

/** forces the spawn location for the next player spawned */
var NavigationPoint ScriptedStartSpot;

//var TMUIScene MidGameMenuTemplate;

var localized string EndOfMatchRulesTemplateStr_Scoring;
var localized string EndOfMatchRulesTemplateStr_ScoringSingle;
var localized string EndOfMatchRulesTemplateStr_Time;

/** object containing speech recognition data to use for this gametype */
var SpeechRecognition SpeechRecognitionData;

/** weapon specific Taunt management (keep them from being used multiple times per round) */
var byte	WeaponTauntUsed[20];

/** Last time bot yelled encouragement to player */
var float LastEncouragementTime;

/** Last time bot yelled mandown to player */
var float LastManDownTime;

/** Current sniper */
var Pawn Sniper;

/** Whether scoring is based on enemy deaths */
var bool bScoreDeaths;

/** Flag whether "X kills remain" has been played yet */
var bool bPlayedTenKills;
var bool bPlayedFiveKills;
var bool bPlayedOneKill;

var name MidgameScorePanelTag;
var bool bMidGameHasMap;

var config bool bForceMidGameMenuAtStart;

/** Used during the campaign to keep player team from using necris vehicles (until they get the magic key) */
var bool bNecrisLocked;

/** Used during the campaign to give player team a health bonuse */
var bool bExtraHealth;

/** Used during the campaign to give player team an armor bonus */
var bool bHeavyArmor;

/** @debug: used to draw HUD message so it's easy to tell when bots are set up incorrectly in SP missions */
var bool bBadSinglePlayerBotNames;

/** When enabled, allows players on different teams to voice chat with each other.  (Used for Duel games)  Note
  * that spectators still won't be able to talk to players and vice-versa, though. */
var bool bIgnoreTeamForVoiceChat;

/** Voice channels used by these game types */
enum EVoiceChannel
{
	VC_Spectators,
	VC_Team1,
	VC_Team2
};

/** for single player when "Tactical Diversion" card is used - skip adding this many Kismet spawned bots */
var int NumDivertedOpponents;

/** "Classic TM" mode is enabled */
var bool bIsClassicTM;

/** Gameplay statistics logging */
var config string GameplayEventsWriterClassName;
var transient GameplayEventsWriter GameplayEventsWriter;
var config bool bLogGameplayEvents;

/** Whether to give physics gun to human players in this game type (meant for testing only) */
//var bool bGivePhysicsGun;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function PostBeginPlay()
{
	local class<GameplayEventsWriter> GameplayEventsWriterClass;

	Super.PostBeginPlay();

	if ( bPlayersVsBots )
		TMGameReplicationInfo(GameReplicationInfo).BotDifficulty = GameDifficulty;

	//Optionally setup the gameplay event logger
	if (bLogGameplayEvents && GameplayEventsWriterClassName != "")
	{
		GameplayEventsWriterClass = class<TMGameplayEventsWriter>(FindObject(GameplayEventsWriterClassName, class'Class'));
		if ( GameplayEventsWriterClass != None )
		{
			//`log("Recording game events with"@GameplayEventsWriterClass);
			GameplayEventsWriter = new(self) GameplayEventsWriterClass;
		}
		else
		{
			;
		}
	}
}

final static native function bool IsLowGoreVersion();

/**
  * returns whether this game should be considered "pure"
  */
final native function bool IsPureGame();

// Returns whether a mutator should be allowed with this gametype
static function bool AllowMutator( string MutatorClassName )
{
	if ( !Default.bTeamGame && (MutatorClassName ~= "TMGame.TMMutator_FriendlyFire") )
	{
		// Friendly fire only valid in team games
		return false;
	}
	if (!default.bWeaponStay && MutatorClassName ~= "TMGame.TMMutator_WeaponsRespawn")
	{
		// weapon stay already off
		return false;
	}
	if ( MutatorClassName ~= "TMGame.TMMutator_Survival")
	{
		// survival mutator only for Duel
		return false;
	}
	if (MutatorClassName ~= "TMGame.TMMutator_NoOrbs")
	{
		// No Orbs mutator only for Warfare
		return false;
	}
	return Super.AllowMutator(MutatorClassName);
}

/**
  * Allows overriding of which gameinfo class to use.
  * Called on the DefaultGameType from the ini, or the one specified on the command line (?game=xxx)
  */
//static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
//{
//	local string ThisMapPrefix;
//	local int i,pos;
//	local class<GameInfo> NewGameType;
//	local string GameOption;
//
//
//	if (Left(MapName, 9) ~= "EnvyEntry" || Left(MapName, 10) ~= "TMFrontEnd")
//	{
//		return class'TMEntryGame';
//	}
//
//	// allow commandline to override game type setting
//	GameOption = ParseOption( Options, "Game");
//	if ( GameOption != "" )
//	{
//		return Default.class;
//	}
//
//	// strip the UEDPIE_ from the filename, if it exists (meaning this is a Play in Editor game)
//	if (Left(MapName, 6) ~= "UEDPIE")
//	{
//		MapName = Right(MapName, Len(MapName) - 6);
//	}
//	else if ( Left(MapName, 5) ~= "UEDPC" )
//	{
//		MapName = Right(MapName, Len(MapName) - 5);
//	}
//	else if (Left(MapName, 6) ~= "UEDPS3")
//	{
//		MapName = Right(MapName, Len(MapName) - 6);
//	}
//	else if (Left(MapName, 6) ~= "UED360")
//	{
//		MapName = Right(MapName, Len(MapName) - 6);
//	}
//
//	// replace self with appropriate gametype if no game specified
//	pos = InStr(MapName,"-");
//	ThisMapPrefix = left(MapName,pos);
//	for (i = 0; i < default.MapPrefixes.length; i++)
//	{
//		if (default.MapPrefixes[i] ~= ThisMapPrefix)
//		{
//			return Default.class;
//		}
//	}
//
//	// change game type
//	for ( i=0; i<Default.DefaultMapPrefixes.Length; i++ )
//	{
//		if ( Default.DefaultMapPrefixes[i].Prefix ~= ThisMapPrefix )
//		{
//			NewGameType = class<GameInfo>(DynamicLoadObject(Default.DefaultMapPrefixes[i].GameType,class'Class'));
//			if ( NewGameType != None )
//			{
//				return NewGameType;
//			}
//		}
//	}
//	for ( i=0; i<Default.CustomMapPrefixes.Length; i++ )
//	{
//		if ( Default.CustomMapPrefixes[i].Prefix ~= ThisMapPrefix )
//		{
//			NewGameType = class<GameInfo>(DynamicLoadObject(Default.CustomMapPrefixes[i].GameType,class'Class'));
//			if ( NewGameType != None )
//			{
//				return NewGameType;
//			}
//		}
//	}
//
//    return class'TMGame';
//}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
	local TMPlayerReplicationInfo TMPRI;
	local TMVehicleBase TMV;

	if ( BaseMutator != None )
		BaseMutator.DriverEnteredVehicle(V, P);

	TMPRI = (V != None) ? TMPlayerReplicationInfo(V.PlayerReplicationInfo) : None;
	if ( TMPRI != None )
	{
		TMV = TMVehicleBase(V);
		if (TMV == None)
		{
			TMV = TMVehicleBase(V.GetVehicleBase());
		}
		if (TMV != None)
		{
			if(GameplayEventsWriter != None && GameplayEventsWriter.CurrentSessionInfo.bGameplaySessionInProgress){TMGameplayEventsWriter(GameplayEventsWriter).LogPlayerIntEvent(class'TMGameplayEventsWriter'.const.GAMEEVENT_PLAYER_ENTERED_VEHICLE,V.Controller,0);};
			TMPRI.StartDrivingStat(TMV.GetVehicleDrivingStatName());
		}
	}
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
	local TMPlayerReplicationInfo TMPRI;

	if ( BaseMutator != None )
		BaseMutator.DriverLeftVehicle(V, P);

	TMPRI = TMPlayerReplicationInfo(P.PlayerReplicationInfo);
	if ( TMPRI != None && TMVehicleBase(V) != None )
	{
		if(GameplayEventsWriter != None && GameplayEventsWriter.CurrentSessionInfo.bGameplaySessionInProgress){TMGameplayEventsWriter(GameplayEventsWriter).LogPlayerIntEvent(class'TMGameplayEventsWriter'.const.GAMEEVENT_PLAYER_EXITED_VEHICLE,P.Controller,0);};
		TMPRI.StopDrivingStat(TMVehicleBase(V).GetVehicleDrivingStatName());
	}
}

function bool BecomeSpectator(PlayerController P)
{
	if ( (P.PlayerReplicationInfo == None) || !GameReplicationInfo.bMatchHasBegun
	     || (NumSpectators >= MaxSpectators) || P.IsInState('RoundEnded') )
	{
		P.ReceiveLocalizedMessage(GameMessageClass, 12);
		return false;
	}

	P.PlayerReplicationInfo.bOnlySpectator = true;
	NumSpectators++;
	NumPlayers--;

	return true;
}

function bool AllowBecomeActivePlayer(PlayerController P)
{
	if ( (P.PlayerReplicationInfo == None) || !GameReplicationInfo.bMatchHasBegun || bMustJoinBeforeStart
	     || (NumPlayers >= MaxPlayers) || (MaxLives > 0) || P.IsInState('RoundEnded') )
	{
		P.ReceiveLocalizedMessage(GameMessageClass, 13);
		return false;
	}
	return true;
}

/** Reset() - reset actor to initial state - used when restarting level without reloading. */
function Reset()
{
	local Controller C;
	local int i;

	Super.Reset();

	bOverTimeBroadcast = false;

	// update AI
	FindNewObjectives(None);

	//now respawn all the players
	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (C.PlayerReplicationInfo != None && !C.PlayerReplicationInfo.bOnlySpectator)
		{
			RestartPlayer(C);
		}
	}

	//reset timelimit
	GameReplicationInfo.RemainingTime = 60 * TimeLimit;
	// if the round lasted less than one minute, we won't be actually changing RemainingMinute
	// which will prevent it from being replicated, so in that case
	// reduce the time limit by one second to ensure that it is unique
	if ( GameReplicationInfo.RemainingTime == GameReplicationInfo.RemainingMinute )
	{
		GameReplicationInfo.RemainingTime--;
	}
	GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;

	// reset weapon taunts
	for ( i=0; i<20; i++ )
	{
		WeaponTauntUsed[i] = 0;
	}
}

function ObjectiveDisabled( TMGameObjective DisabledObjective );
/** re-evaluate objectives for players because the specified one has been changed/completed */
function FindNewObjectives(TMGameObjective DisabledObjective);

function bool CanDisableObjective( TMGameObjective GO )
{
	return true;
}

function NotifyNavigationChanged(NavigationPoint N)
{
	local TMBot B;

	// if a point becomes unblocked, force bots to repath in case it's faster than their current one
	if (!N.bBlocked)
	{
		foreach WorldInfo.AllControllers(class'TMBot', B)
		{
			B.bForceRefreshRoute = true;
		}
	}
}

function bool SkipPlaySound()
{
	return bQuickStart || bSkipPlaySound;
}

//
// Set gameplay speed.
//
//function SetGameSpeed( float T )
//{
//	local float TMTimeDilation;
//
//	TMTimeDilation = bConsoleServer ? 0.95 : 1.05;
//	GameSpeed = FMax(T, 0.1);
//	WorldInfo.TimeDilation = TMTimeDilation * GameSpeed;
//	SetTimer(WorldInfo.TimeDilation, true);
//}

function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> DamageType)
{
	local TMBot B;

	if ( (Killer == Other) || (Killer == None) )
	{
		BroadcastLocalized(self,DeathMessageClass, 1, None, Other.PlayerReplicationInfo, DamageType);
	}
	else
	{
		BroadcastLocalized(self,DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, damageType);
		if ( PlayerController(Other) != None )
		{
			// maybe taunt him
			if ( ((TMPlayerController(Killer) == None) || TMPlayerController(Killer).bAutoTaunt)
				&& (Other.PlayerReplicationInfo != None)
				&& (TMPlayerReplicationInfo(Killer.PlayerReplicationInfo) != None)
				&& (TMPlayerReplicationInfo(Killer.PlayerReplicationInfo).VoiceClass != None) )
			{
					Killer.SendMessage(Other.PlayerReplicationInfo, 'TAUNT', 10, DamageType);
			}
		}
		else if ( bTeamGame && (NumBots > 0) )
		{
			if ( TMPlayerController(Killer) != None )
			{
				if ( (Other.PlayerReplicationInfo != None)
					&& (Killer.PlayerReplicationInfo != None) && (Killer.PlayerReplicationInfo.Team != None)
					&& (WorldInfo.TimeSeconds - LastEncouragementTime > 20)
					&& (FRand() < 0.6) )
				{
					// maybe get encouragement from teammate
					ForEach WorldInfo.AllControllers(class'TMBot', B)
					{
						if ( (B.PlayerReplicationInfo != None) && (B.PlayerReplicationInfo.Team == Killer.PlayerReplicationInfo.Team) && (FRand() < 0.33) )
						{
							B.SendMessage(Other.PlayerReplicationInfo, 'ENCOURAGEMENT', 0, DamageType);
							break;
						}
					}
				}
			}
			else
			{
				B = TMBot(Other);
				if ( (B != None) && (FRand() < 0.2)
					&& (Other.PlayerReplicationInfo != None) && (Other.PlayerReplicationInfo.Team != None) )
				{
					// maybe tell human players I was killed
					B.SendMessage(None, 'MANDOWN', 20, DamageType);
				}
			}
		}
	}
}

function ScoreKill(Controller Killer, Controller Other)
{
	local PlayerReplicationInfo OtherPRI;
	local TMPawn KillerPawn;
	local TMGameReplicationInfo GRI;

	OtherPRI = Other.PlayerReplicationInfo;
    if ( OtherPRI != None )
    {
		OtherPRI.NumLives++;
		if ( (MaxLives > 0) && (OtherPRI.NumLives >=MaxLives) )
			OtherPRI.bOutOfLives = true;
    }

	Super.ScoreKill(Killer,Other);

    if ( (killer == None) || (Other == None) )
		return;

	// adjust bot skills to match player - only for DM, not team games
	GRI = TMGameReplicationInfo(GameReplicationInfo);
	if ( GRI.bStoryMode && !bTeamGame && (killer.IsA('PlayerController') || Other.IsA('PlayerController')) )
    {
		if ( killer.IsA('AIController') )
			AdjustSkill(AIController(killer), PlayerController(Other), false);
		if ( Other.IsA('AIController') )
			AdjustSkill(AIController(Other), PlayerController(Killer), true);
    }

	KillerPawn = TMPawn(Killer.Pawn);
	if ( (KillerPawn != None) && KillerPawn.bKillsAffectHead )
	{
		KillerPawn.SetBigHead();
	}
}

function AdjustSkill(AIController B, PlayerController P, bool bWinner)
{
	local float AdjustmentFactor;

	AdjustmentFactor = FClamp(0.5/FMax(1.0,PlayerKills+PlayerDeaths), 0.1, 0.25);
    if ( bWinner )
    {
		PlayerKills += 1;
		AdjustedDifficulty = FMin(7.0,AdjustedDifficulty + AdjustmentFactor);
    }
    else
    {
		PlayerDeaths += 1;
		AdjustedDifficulty = FMax(0, AdjustedDifficulty - AdjustmentFactor);
    }
	AdjustedDifficulty = FClamp(AdjustedDifficulty, GameDifficulty - 1.25, GameDifficulty + 1.25);
	if ( bWinner == (B.Skill < AdjustedDifficulty) )
	{
		B.Skill = AdjustedDifficulty;
		TMBot(B).ResetSkill();
	}
}

// Monitor killed messages for fraglimit
function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
{
	local bool		bEnemyKill;
	local TMPlayerReplicationInfo KillerPRI, KilledPRI;
	local TMVehicle V;

	if ( TMBot(KilledPlayer) != None )
		TMBot(KilledPlayer).WasKilledBy(Killer);

	if ( Killer != None )
		KillerPRI = TMPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( KilledPlayer != None )
		KilledPRI = TMPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);

	bEnemyKill = ( ( ( KillerPRI != None )
					&& ( KillerPRI != KilledPRI )
					&& ( KilledPRI != None))
					&& ( !bTeamGame || ( KillerPRI.Team != KilledPRI.Team ) ) );

	if ( (KillerPRI != None) && TMVehicle(KilledPawn) != None )
	{
		KillerPRI.IncrementVehicleKillStat(TMVehicle(KilledPawn).GetVehicleKillStatName());
	}

	if ( KilledPRI != None )
	{
		if(GameplayEventsWriter != None && GameplayEventsWriter.CurrentSessionInfo.bGameplaySessionInProgress){TMGameplayEventsWriter(GameplayEventsWriter).LogPlayerKillDeath(class'TMGameplayEventsWriter'.const.GAMEEVENT_PLAYER_KILL,class'TMGameplayEventsWriter'.const.GAMEEVENT_PLAYER_KILL_NORMAL,Killer,damageType,KilledPlayer);};

		KilledPRI.LastKillerPRI = KillerPRI;

		if ( class<TMDamageType>(DamageType) != None )
		{
			class<TMDamageType>(DamageType).static.ScoreKill(KillerPRI, KilledPRI, KilledPawn);
		}
		else
		{
			// assume it's some kind of environmental damage
			if ( (KillerPRI == KilledPRI) || (KillerPRI == None) )
			{
				KilledPRI.IncrementSuicideStat('SUICIDES_ENVIRONMENT');
			}
			else
			{
				KillerPRI.IncrementKillStat('KILLS_ENVIRONMENT');
				KilledPRI.IncrementDeathStat('DEATHS_ENVIRONMENT');
			}
		}

		if ( KilledPRI.Spree > 4 )
		{
			EndSpree(KillerPRI, KilledPRI);
		}
		else
		{
			KilledPRI.Spree = 0;
		}

		if ( KillerPRI != None )
		{
			KillerPRI.IncrementKills(bEnemyKill);

			if ( bEnemyKill )
			{
				V = TMVehicle(KilledPawn);

				if ( !bFirstBlood )
				{
					bFirstBlood = True;
					BroadcastLocalizedMessage( class'TMFirstBloodMessage', 0, KillerPRI );
					KillerPRI.IncrementEventStat('EVENT_FIRSTBLOOD');
				}
			}
		}
	}

    super.Killed(Killer, KilledPlayer, KilledPawn, damageType);


    if ( ((WorldInfo.NetMode == NM_Standalone) || (SinglePlayerMissionID != INDEX_NONE)) && (PlayerController(KilledPlayer) != None) )
    {
		// clear telling bots not to get into nearby vehicles
		for ( V=VehicleList; V!=None; V=V.NextVehicle )
			if ( WorldInfo.GRI.OnSameTeam(KilledPlayer,V) )
				V.PlayerStartTime = 0;
	}
}

/** ForceRespawn()
returns true if dead players should respawn immediately
*/
function bool ForceRespawn()
{
	return ( bForceRespawn || bTempForceRespawn || (MaxLives > 0) || (DefaultMaxLives > 0) );
}

// Parse options for this game...
event InitGame( string Options, out string ErrorMessage )
{
	local string InOpt;
	local int i;

	// reset map cycle if we're just starting up
	if (WorldInfo.TimeSeconds == 0.0)
	{
		MapCycleIndex = INDEX_NONE;
		SaveConfig();
	}

	// make sure no bots got saved in the .ini as in use
	for (i = 0; i < ActiveBots.length; i++)
	{
		ActiveBots[i].bInUse = false;
	}

	Super.InitGame(Options, ErrorMessage);

	InOpt = ParseOption(Options, "ForceRespawn");
	if (InOpt != "")
	{
		bForceRespawn = bool(InOpt);
	}

	SetGameSpeed(GameSpeed);
	MaxLives = Max(0,GetIntOption( Options, "MaxLives", MaxLives ));
	if ( MaxLives > 0 )
	{
		bTempForceRespawn = true;
	}
	else if ( DefaultMaxLives > 0 )
	{
		bTempForceRespawn = true;
		MaxLives = DefaultMaxLives;
	}
	if( DefaultMaxLives > 0 )
	{
		TimeLimit = 0;
	}

	//[TJJ DELETE: Use value in configuration files only.]
	// Set goal score to end match... If automated testing, no score limit (end by timelimit only)
	// GoalScore = (!IsAutomatedPerfTesting()) ? Max(0,GetIntOption( Options, "GoalScore", GoalScore )) : 0;

	InOpt = ParseOption( Options, "Console");
	if ( (InOpt != "") || WorldInfo.IsConsoleBuild() )
	{
		;
		WorldInfo.bUseConsoleInput = true;
		bConsoleServer = true;
		PlayerControllerClass = ConsolePlayerControllerClass;
	}

	if( WorldInfo.IsConsoleBuild() )
	{
		bAllowKeyboardAndMouse = ( ParseOption( Options, "AllowKeyboard" ) ~= "1" );
		if( bAllowKeyboardAndMouse )
		{
			;
		}
	}

	InOpt = ParseOption( Options, "DemoMode");
	if ( InOpt != "" )
	{
		bDemoMode = bool(InOpt);
	}

	bAutoNumBots = (WorldInfo.NetMode == NM_Standalone);
	InOpt = ParseOption( Options, "bAutoNumBots");
	if ( InOpt != "" )
	{
		bAutoNumBots = bool(InOpt);
	}

    if ( bTeamGame && (WorldInfo.NetMode != NM_Standalone) )
    {
		InOpt = ParseOption( Options, "VsBots");
		if ( InOpt != "" )
		{
			BotRatio = float(InOpt);
			bPlayersVsBots = (BotRatio > 0);
		}
		if ( bPlayersVsBots )
		{
			bAutoNumBots = false;
		}
	}

	if ( HasOption(Options, "NumPlay") )
		bAutoNumBots = false;

	DesiredPlayerCount = bAutoNumBots ? LevelRecommendedPlayers() : Clamp(GetIntOption( Options, "NumPlay", 1 ),1,32);

	InOpt = ParseOption( Options, "PlayersMustBeReady");
	if ( InOpt != "" )
	{
		bPlayersMustBeReady = bool(InOpt);
	}

	InOpt = ParseOption( Options, "MinNetPlayers");
	if (InOpt != "")
	{
		MinNetPlayers = int(InOpt);
	}

	bShouldWaitForNetPlayers = bWaitForNetPlayers && (WorldInfo.NetMode != NM_StandAlone);

	InOpt = ParseOption(Options,"QuickStart");
	if ( InOpt != "" )
	{
		bQuickStart = true;
	}
	// Quick start the match if passed in as option or automated testing
	bQuickStart = bQuickStart || IsAutomatedPerfTesting();

	AdjustedDifficulty = GameDifficulty;

	if (WorldInfo.NetMode != NM_StandAlone)
	{
		InOpt = ParseOption( Options, "WarmupTime");
		if (InOpt != "")
		{
			WarmupTime = int(InOpt);
			WarmupRemaining = WarmupTime;
			bWarmupRound = (WarmupTime > 0);
		}
	}
	else
	{
		bWarmupRound = false;
	}

	InOpt = ParseOption(Options,"SPI");
	if ( InOpt != "" )
	{
		bPauseable = true;
		bAllowKeyboardAndMouse = true;
		SinglePlayerMissionID = int(InOpt);

		InOpt = ParseOption(Options,"NecrisLocked");
		if ( InOpt != "" )
		{
			bNecrisLocked = bool(InOpt);
		}
		InOpt = ParseOption(Options,"CoolSpawn");
		if ( InOpt != "" )
		{
			bExtraHealth = bool(InOpt);
		}
		InOpt = ParseOption(Options,"HeavyArmor");
		if ( InOpt != "" )
		{
			bHeavyArmor = bool(InOpt);
		}
		NumDivertedOpponents = GetIntOption(Options, "diverted", 0);
	}
	else
	{
		SinglePlayerMissionID = INDEX_None;
	}

	DemoPrefix = ParseOption(Options,"demo");
}

/**
 * Only allow local players to pause
 */
function bool SetPause(PlayerController PC, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
	if ( !PC.IsLocalPlayerController() )
	{
		return false;
	}

	return Super.SetPause(PC, CanUnpauseDelegate);
}

function int LevelRecommendedPlayers()
{
	local TMMapInfo MapInfo;

	MapInfo = TMMapInfo(WorldInfo.GetMapInfo());
	return (MapInfo != None) ? Min(12, (MapInfo.RecommendedPlayersMax + MapInfo.RecommendedPlayersMin) / 2) : 1;
}

event PlayerController Login(string Portal, string Options, const UniqueNetID UniqueID, out string ErrorMessage)
//event PlayerController Login(string Portal, string Options, out string ErrorMessage)
{
	local PlayerController NewPlayer;
	local Controller C;
	local bool bDedicatedServerSpectator;

	// if this is the first player, and he has the dedicated server option, mark him as such and force to be spectator
	if (NumPlayers == 0 && WorldInfo.NetMode != NM_DedicatedServer && HasOption(Options, "dedicated"))
	{
		bDedicatedServerSpectator = true;
		Options $= "?SpectatorOnly=1";
	}

	if ( MaxLives > 0 )
	{
		// check that game isn't too far along
		foreach WorldInfo.AllControllers(class'Controller', C)
		{
			if ( (C.PlayerReplicationInfo != None) && (C.PlayerReplicationInfo.NumLives > LateEntryLives) )
			{
				Options = "?SpectatorOnly=1"$Options;
				break;
			}
		}
	}

	NewPlayer = Super.Login(Portal, Options, UniqueID, ErrorMessage);

	if ( TMPlayerController(NewPlayer) != None )
	{
		if ( bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun )
		{
			TMPlayerController(NewPlayer).bLatecomer = true;
		}
		if (bDedicatedServerSpectator)
		{
			TMPlayerController(NewPlayer).bDedicatedServerSpectator = true;
		}
	}

	return NewPlayer;
}

function bool ShouldRespawn(PickupFactory Other)
{
	return true;
}

function bool WantFastSpawnFor(AIController B)
{
	return ( NumBots < 4 );
}

function float SpawnWait(AIController B)
{
	if ( B.PlayerReplicationInfo.bOutOfLives )
		return 999;
	if ( (WorldInfo.NetMode == NM_Standalone) || (SinglePlayerMissionID != INDEX_NONE) )
	{
		if ( WantFastSpawnFor(B) )
			return 0;

		return (FMax(2,NumBots-4) * FRand());
	}
	return bPlayersVsBots ? 0.5 : FRand();
}

/**
 * Look at the current game rules and determine if there are too many bots.  In a single player
 * game, this function will always return false since the teams are preset and changes are not allowed.
 *
 * @Param BotToRemove		The Bot to remove
 */

function bool TooManyBots(Controller botToRemove)
{
	// We only auto-manage bots if we are not in single player mode.
	if ( SinglePlayerMissionID == INDEX_NONE )
	{
		if ( (WorldInfo.NetMode != NM_Standalone) && bPlayersVsBots )
			return ( NumBots > Min(16,BotRatio*NumPlayers) );
		if ( bPlayerBecameActive )
		{
			bPlayerBecameActive = false;
			return true;
		}
		return ( NumBots + NumPlayers > DesiredPlayerCount );
	}
	return false;
}

function RestartGame()
{
	if ( bGameRestarted )
		return;

	if ( EndTime > WorldInfo.TimeSeconds ) // still showing end screen
		return;

	Super.RestartGame();
}


function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Controller P;
	local bool bLastMan;

	if ( bOverTime )
	{
		if ( Numbots + NumPlayers == 0 )
			return true;
		bLastMan = true;
		foreach WorldInfo.AllControllers(class'Controller', P)
		{
			if ( (P.PlayerReplicationInfo != None) && !P.PlayerReplicationInfo.bOutOfLives )
			{
				bLastMan = false;
				break;
			}
		}
		if ( bLastMan )
		{
			return true;
		}
	}

	bLastMan = ( Reason ~= "LastMan" );

	if ( !bLastMan && CheckModifiedEndGame(Winner, Reason) )
		return false;

	if ( Winner == None )
	{
		// find winner
		foreach WorldInfo.AllControllers(class'Controller', P)
		{
			if ( P.bIsPlayer && !P.PlayerReplicationInfo.bOutOfLives
				&& ((Winner == None) || (P.PlayerReplicationInfo.Score >= Winner.Score)) )
			{
				Winner = P.PlayerReplicationInfo;
			}
		}
	}

	// check for tie
	if ( !bLastMan )
	{
		foreach WorldInfo.AllControllers(class'Controller', P)
		{
			if ( P.bIsPlayer &&
				(Winner != P.PlayerReplicationInfo) &&
				(P.PlayerReplicationInfo.Score == Winner.Score)
				&& !P.PlayerReplicationInfo.bOutOfLives )
			{
				if ( !bOverTimeBroadcast )
				{
					StartupStage = 7;
					PlayStartupMessage();
					bOverTimeBroadcast = true;
				}
				return false;
			}
		}
	}

	EndTime = WorldInfo.TimeSeconds + EndTimeDelay;
	GameReplicationInfo.Winner = Winner;

	SetEndGameFocus(Winner);
	return true;
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
	local Controller P;
	local Vehicle V;

	EndGameFocus = Controller(Winner.Owner).Pawn;
	if ( (EndGameFocus == None) && (Controller(Winner.Owner) != None) )
	{
		RestartPlayer(Controller(Winner.Owner));
		EndGameFocus = Controller(Winner.Owner).Pawn;
	}

	// redirect to owner if using remote controlled vehicle (e.g. Redeemer)
	V = Vehicle(EndGameFocus);
	if (V != None && !V.bAttachDriver && V.Driver != None)
	{
		EndGameFocus = V.Driver;
	}

	if ( EndGameFocus != None )
	{
		EndGameFocus.bAlwaysRelevant = true;
	}
	foreach WorldInfo.AllControllers(class'Controller', P)
	{
		P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo == Winner) );
	}
}

function bool AtCapacity(bool bSpectator)
{
	local Controller C;
	local bool bForcedSpectator;

    if ( WorldInfo.NetMode == NM_Standalone )
		return false;

	if ( bPlayersVsBots )
		MaxPlayers = Min(MaxPlayers,16);

    if ( MaxLives <= 0 )
		return Super.AtCapacity(bSpectator);

	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if ( (C.PlayerReplicationInfo != None) && (C.PlayerReplicationInfo.NumLives > LateEntryLives) )
		{
			bForcedSpectator = true;
			break;
		}
	}
	if ( !bForcedSpectator )
		return Super.AtCapacity(bSpectator);

	return ( GetNumPlayers() + NumSpectators >= MaxPlayers + MaxSpectators );
}

event PostLogin( playercontroller NewPlayer )
{
	local TMPlayerController PC;
	local TMGameReplicationInfo GRI;

	Super.PostLogin(NewPlayer);

	PC = TMPlayerController(NewPlayer);
	if (PC != None)
	{
		PC.PlayStartUpMessage(StartupStage);
		PC.ClientSetSpeechRecognitionObject(SpeechRecognitionData);

		GRI = TMGameReplicationInfo(GameReplicationInfo);
		if ( bForceMidGameMenuAtStart && !GRI.bStoryMode && !GRI.bMatchHasBegun && (NetWait - PendingMatchElapsedTime > 5) )
		{
			TMPlayerReplicationInfo(PC.PlayerReplicationInfo).ShowMidGameMenu(true);
		}

		if ( NumPlayers > 1 && SinglePlayerMissionID != INDEX_None )
		{
			SkipCinematics(PC);
		}
	}

	//@hack: unfortunately the character construction process requires game tick so we can't be paused while
	// clients are doing it or they will appear to hang on the loading screen
	Pausers.length = 0;
	WorldInfo.Pauser = None;
}

/**
 * Updates the online subsystem's information for player counts so that
 * LAN matches can show the correct player counts
 */
function UpdateGameSettingsCounts()
{
	local int TotalOpenConnections, TotalConnections;
	local OnlineGameSettings GameSettings;

	if (GameInterface != None)
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
	}

	if (GameSettings != None && GameInterface != None)
	{
		// Make sure that we don't exceed our max allowing player counts for this game type!  Usually this is 32.
		//GameSettings.NumPublicConnections = Clamp( GameSettings.NumPublicConnections, 0, MaxPlayers );
		//GameSettings.NumPrivateConnections = Clamp( GameSettings.NumPrivateConnections, 0, MaxPlayers - GameSettings.NumPublicConnections );

		// Update the number of open slots available
		GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - GetNumPlayers();
		if (GameSettings.NumOpenPublicConnections < 0)
		{
			GameSettings.NumOpenPublicConnections = 0;
		}

		TotalOpenConnections = GameSettings.NumOpenPublicConnections + GameSettings.NumOpenPrivateConnections;
		TotalConnections = GameSettings.NumPublicConnections + GameSettings.NumPrivateConnections;

		GameSettings.SetStringSettingValue(class'TMGameSearchCommon'.const.CONTEXT_FULLSERVER,
			TotalOpenConnections == 0 ? class'TMGameSearchCommon'.const.CONTEXT_FULLSERVER_YES : class'TMGameSearchCommon'.const.CONTEXT_FULLSERVER_NO, false);
		GameSettings.SetStringSettingValue(class'TMGameSearchCommon'.const.CONTEXT_EMPTYSERVER,
			TotalOpenConnections == TotalConnections ? class'TMGameSearchCommon'.const.CONTEXT_EMPTYSERVER_YES : class'TMGameSearchCommon'.const.CONTEXT_EMPTYSERVER_NO, false);

		GameSettings.NumRedTeamOpenConnection = GameReplicationInfo.Teams[0].Size;
		GameSettings.NumBlueTeamOpenConnection = GameReplicationInfo.Teams[1].Size;

		GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName,GameSettings);
	}
}

function AssignHoverboard(TMPawn P)
{
	if ( P != None )
		P.bHasHoverboard = bAllowHoverboard;
}

/** return a value based on how much this pawn needs help */
function int GetHandicapNeed(Pawn Other)
{
	return 0;
}

function RestartPlayer(Controller aPlayer)
{
	local TMVehicle V, Best;
	local vector ViewDir;
	local float BestDist, Dist;
	local TMPlayerController PC;
	local HDPawn HDP;

	PC = TMPlayerController(aPlayer);
	if (PC != None)
	{
		// can't respawn if you have to join before the game starts and this player didn't
		if (bMustJoinBeforeStart && PC != None && PC.bLatecomer)
		{
			return;
		}
	}

	// can't respawn if out of lives
	if ( aPlayer.PlayerReplicationInfo.bOutOfLives )
	{
		return;
	}

	if ( TMBot(aPlayer) != None )
	{
		if ( TooManyBots(aPlayer) )
		{
			aPlayer.Destroy();
			return;
		}
		else if ( TMGameReplicationInfo(GameReplicationInfo).bStoryMode )
		{
			CampaignSkillAdjust(TMBot(aPlayer));
		}
	}

	Super.RestartPlayer(aPlayer);

	if ( aPlayer.Pawn == None )
	{
		// pawn spawn failed
		return;
	}

//	if ( bExtraHealth
//		&& (aPlayer.PlayerReplicationInfo.Team != None) && (aPlayer.PlayerReplicationInfo.Team.TeamIndex == 0) )
//	{
//		aPlayer.Pawn.Health = 140;
//	}

	HDP = HDPawn(aPlayer.Pawn);
	HDP.Health = Min(HDP.DefaultHealth, HDP.HealthMax);

	AssignHoverboard(TMPawn(aPlayer.Pawn));

	if ( ((WorldInfo.NetMode == NM_Standalone) || (SinglePlayerMissionID != INDEX_NONE)) && (PlayerController(aPlayer) != None) )
	{
		// tell bots not to get into nearby vehicles for a little while
		BestDist = 2000;
		ViewDir = vector(aPlayer.Pawn.Rotation);
		for ( V=VehicleList; V!=None; V=V.NextVehicle )
		{
			if ( !bTeamGame && V.bTeamLocked )
			{
				V.bTeamLocked = false;
			}
			if ( V.bTeamLocked && WorldInfo.GRI.OnSameTeam(aPlayer,V) )
			{
				Dist = VSize(V.Location - aPlayer.Pawn.Location);
				if ( (ViewDir Dot (V.Location - aPlayer.Pawn.Location)) < 0 )
					Dist *= 2;
				if ( Dist < BestDist )
				{
					Best = V;
					BestDist = Dist;
				}
			}
		}
		if ( Best != None )
			Best.PlayerStartTime = WorldInfo.TimeSeconds + 8;
	}


	// Make sure VOIP state for this player is updated.  They may have just entered the game after spectating
	// for awhile post-connection.
	if( PC != None )
	{
		SetupPlayerMuteList( PC, false );		// Force spectator channel?
	}

	HDP.PlayRespawnEffect( 2.0, SpawnProtectionTime );
}

/**
  * Called to adjust skill when bot respawns
  */
function CampaignSkillAdjust(TMBot aBot)
{
	aBot.Skill = AdjustedDifficulty;
}


function bool CanSpectate( PlayerController Viewer, PlayerReplicationInfo ViewTarget )
{
    return ( ( ViewTarget != None )
		&& ( ( WorldInfo.NetMode == NM_Standalone )
			|| Viewer.PlayerReplicationInfo.bOnlySpectator ) );
}

function ChangeName(Controller Other, string S, bool bNameChange)
{
    //local Controller APlayer;

    if ( Other.PlayerReplicationInfo.playername~=S )
    {
		return;
	}

    // Cap player name's at 15 characters...
	if( Len(s) > 15 )
	{
		s = Left(S,15);
	}

	if( Len(s) <= 1 )
	{
		s = s $ DefaultPlayerName;
	}

//	foreach WorldInfo.AllControllers(class'Controller', APlayer)
//	{
//		if (APlayer.bIsPlayer && APlayer.PlayerReplicationInfo.playername ~= S)
//		{
//			if ( PlayerController(Other) != None )
//			{
//				PlayerController(Other).ReceiveLocalizedMessage( GameMessageClass, 8 );
//				if ( Other.PlayerReplicationInfo.PlayerName ~= DefaultPlayerName )
//				{
//					Other.PlayerReplicationInfo.SetPlayerName(DefaultPlayerName$Other.PlayerReplicationInfo.PlayerID);
//				}
//				return;
//			}
//		}
//	}

    Other.PlayerReplicationInfo.SetPlayerName(S);
}

function DiscardInventory( Pawn Other, optional controller Killer )
{
	if (TMPlayerReplicationInfo(Other.PlayerReplicationInfo) != None && TMPlayerReplicationInfo(Other.PlayerReplicationInfo).bHasFlag)
	{
		TMPlayerReplicationInfo(Other.PlayerReplicationInfo).GetFlag().Drop(Killer);
	}
	else if ( Other.DrivenVehicle != None && TMPlayerReplicationInfo(Other.DrivenVehicle.PlayerReplicationInfo) != None
		&& TMPlayerReplicationInfo(Other.DrivenVehicle.PlayerReplicationInfo).bHasFlag )
	{
		TMPlayerReplicationInfo(Other.DrivenVehicle.PlayerReplicationInfo).GetFlag().Drop(Killer);
	}

	Super.DiscardInventory(Other);
}

function Logout(controller Exiting)
{
	local int i, CharIndex;
	local TMPlayerReplicationInfo PRI;
	local byte TeamNum;
	local TMPlayerController ExitingPC;

	PRI = TMPlayerReplicationInfo(Exiting.PlayerReplicationInfo);
	if ( PRI.bHasFlag )
	{
		PRI.GetFlag().Drop();
	}

	CharIndex = PRI.SinglePlayerCharacterIndex;
	TeamNum = PRI.GetTeamNum();


	// Remove from all mute lists so they can rejoin properly
	ExitingPC = TMPlayerController( Exiting );
	if( ExitingPC != None )
	{
		RemovePlayerFromMuteLists( ExitingPC );
	}


	Super.Logout(Exiting);

	if (Exiting.IsA('TMBot') && !TMBot(Exiting).bSpawnedByKismet)
	{
		i = ActiveBots.Find('BotName', Exiting.PlayerReplicationInfo.PlayerName);
		if (i != INDEX_NONE)
		{
			ActiveBots[i].bInUse = false;
		}
		NumBots--;
	}

	if (SinglePlayerMissionID != INDEX_NONE)
	{
		if (CharIndex != INDEX_NONE && !Exiting.IsA('TMBot'))
		{
			AddBot(TMGameReplicationInfo(GameReplicationInfo).SinglePlayerBotNames[CharIndex], TeamNum != 255, TeamNum);
		}
	}
	else if ( NeedPlayers() )
	{
		AddBot();
	}

	if (MaxLives > 0)
	{
		CheckMaxLives(None);
	}
}

exec function KillBots()
{
	local TMBot B;

	DesiredPlayerCount = NumPlayers;
	bPlayersVsBots = false;

	foreach WorldInfo.AllControllers(class'TMBot', B)
	{
		KillBot(B);
	}
}

exec function KillOthers()
{
	local TMBot B, ViewedBot;
	local PlayerController PC;

	DesiredPlayerCount = NumPlayers;
	bPlayersVsBots = false;

	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		if ( Pawn(PC.ViewTarget) != None )
		{
			ViewedBot = TMBot(Pawn(PC.ViewTarget).Controller);
DesiredPlayerCount = NumPlayers + 1;
			break;
		}
	}

	foreach WorldInfo.AllControllers(class'TMBot', B)
	{
		if ( B != ViewedBot )
			KillBot(B);
	}
}

exec function KillThis()
{
	local PlayerController PC;
	local TMBot ViewedBot;

	foreach LocalPlayerControllers(class'PlayerController', PC)
	{
		if ( Pawn(PC.ViewTarget) != None )
		{
			ViewedBot = TMBot(Pawn(PC.ViewTarget).Controller);
			if ( ViewedBot != None )
				KillBot(ViewedBot);
			break;
		}
	}
}
function KillBot(TMBot B)
{
	if ( B == None )
		return;

	if ( (Vehicle(B.Pawn) != None) && (Vehicle(B.Pawn).Driver != None) )
		Vehicle(B.Pawn).Driver.KilledBy(Vehicle(B.Pawn).Driver);
	else if (B.Pawn != None)
	B.Pawn.KilledBy( B.Pawn );
	if (B != None)
		B.Destroy();
}

function bool NeedPlayers()
{
	if ( bMustJoinBeforeStart )
	{
		return false;
	}
	else if ( bPlayersVsBots )
	{
		return (NumBots < Min(16, BotRatio * NumPlayers));
	}
	else if (SinglePlayerMissionID != INDEX_NONE)
	{
		return (GetNumPlayers() + NumBots < DesiredPlayerCount);
	}
	else
	{
		return (NumPlayers + NumBots < DesiredPlayerCount);
	}
}

exec function AddBots(int Num)
{
	local int AddCount;

	DesiredPlayerCount = Clamp(Max(DesiredPlayerCount, NumPlayers+NumBots)+Num, 1, 32);

	// add up to 8 immediately, then the rest automatically via game timer.
	while ( (NumPlayers + NumBots < DesiredPlayerCount) && (AddBot() != none) && (AddCount < 8) )
	{
		;
		AddCount++;
	}
}

exec function TMBot AddNamedBot(string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
	DesiredPlayerCount = Clamp(Max(DesiredPlayerCount, NumPlayers + NumBots) + 1, 1, 32);
	return AddBot(BotName, bUseTeamIndex, TeamIndex);
}

function TMBot AddBot(optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
	local TMBot NewBot;
	local int i;

	if (BotName == "")
	{
		i = ActiveBots.Find('bInUse', false);
		if (i != INDEX_NONE)
		{
			BotName = ActiveBots[i].BotName;
			ActiveBots[i].bInUse = true;
		}
	}
	else
	{
		i = ActiveBots.Find('BotName', BotName);
		if (i != INDEX_NONE)
		{
			ActiveBots[i].bInUse = true;
		}
	}

	NewBot = SpawnBot(BotName, bUseTeamIndex, TeamIndex);
	if ( NewBot == None )
	{
		;
		return none;
	}
	NewBot.PlayerReplicationInfo.PlayerID = GetNextPlayerID();
	NumBots++;
	if ( WorldInfo.NetMode == NM_Standalone )
	{
		RestartPlayer(NewBot);
	}
	else
	{
		NewBot.GotoState('Dead','MPStart');
	}

    return NewBot;
}

/* Spawn and initialize a bot
*/
function TMBot SpawnBot(optional string botName,optional bool bUseTeamIndex, optional int TeamIndex)
{
	local TMBot NewBot;
	local TMTeamInfo BotTeam;
	local CharacterInfo BotInfo;

	BotTeam = GetBotTeam(,bUseTeamIndex,TeamIndex);
	BotInfo = BotTeam.GetBotInfo(botName);

	NewBot = Spawn(BotClass);

	if ( NewBot != None )
	{
		if (SinglePlayerMissionID != INDEX_NONE && BotName != "" && BotName != BotInfo.CharName)
		{
			;
			bBadSinglePlayerBotNames = true;
		}
		InitializeBot(NewBot, BotTeam, BotInfo);

		if (BaseMutator != None)
		{
			BaseMutator.NotifyLogin(NewBot);
		}
	}

	return NewBot;
}

/* Initialize bot
*/
function InitializeBot(TMBot NewBot, TMTeamInfo BotTeam, const out CharacterInfo BotInfo)
{
	NewBot.Initialize(AdjustedDifficulty, BotInfo);
	BotTeam.AddToTeam(NewBot);
	ChangeName(NewBot, BotInfo.CharName, false);
	BotTeam.SetBotOrders(NewBot);
}

function TMTeamInfo GetBotTeam(optional int TeamBots,optional bool bUseTeamIndex,optional int TeamIndex)
{
	local class<TMTeamInfo> RosterClass;

	if ( EnemyRoster != None )
	{
		return EnemyRoster;
	}
	if ( EnemyRosterName != "" )
	{
		RosterClass = class<TMTeamInfo>(DynamicLoadObject(EnemyRosterName,class'Class'));
		if ( RosterClass != None)
			EnemyRoster = spawn(RosterClass);
	}
	if ( EnemyRoster == None )
	{
		EnemyRoster = spawn(class'TMGame.TMDMRoster');
	}
	EnemyRoster.Initialize(TeamIndex);
	return EnemyRoster;
}

function InitGameReplicationInfo()
{
	local TMGameReplicationInfo GRI;
	local TMMutator M;

	Super.InitGameReplicationInfo();

	GRI = TMGameReplicationInfo(GameReplicationInfo);
	GRI.GoalScore = GoalScore;
	GRI.TimeLimit = TimeLimit;
	GRI.RemainingTime = 60 * TimeLimit;
	GRI.MinNetPlayers = MinNetPlayers;
	GRI.bConsoleServer = (WorldInfo.bUseConsoleInput || WorldInfo.IsConsoleBuild());
	GRI.bAllowKeyboardAndMouse = bAllowKeyboardAndMouse;
	GRI.RespawnTime = RespawnTime;

	GRI.bRequireReady = bPlayersMustBeReady;
	if ( !bForceRespawn && !GRI.bStoryMode )
	{
		GRI.bSHowMOTD = true;
	}

	// Create the list of mutators.

	M = GetBaseTMMutator();
	while (M != none )
	{
		GRI.MutatorList $= GRI.MutatorList == "" ? Pathname(M.Class) : ("?"$Pathname(M.Class));
		M = M.GetNextTMMutator();
	}

	GRI.RulesString = "";
	GRI.AddGameRule(GetMapTypeRule());
	GRI.AddGameRule(GetEndGameConditionRule());
	GRI.AddGameRule(" ");
}

function string GetMapTypeRule()
{
	return GameName@" - "@WorldInfo.GetMapName();
}


function string GetEndGameConditionRule()
{
	return GetEndOfMatchRules(GoalScore, TimeLimit);
}

function ReduceDamage(out int Damage, pawn injured, Controller instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local float InstigatorSkill;
	local TMVehicle V;
	local class<TMDamageType> TMDamage;

	if ( InstigatedBy != None )
	{
		TMDamage = class<TMDamageType>(DamageType);
		if ( InstigatedBy != Injured.Controller )
		{
			if (WorldInfo.TimeSeconds - injured.SpawnTime < SpawnProtectionTime && !DamageType.default.bCausedByWorld)
			{
				Damage = 0;
				return;
			}

			V = TMVehicle(Injured);
			if (V != None && !V.bHasBeenDriven && !bUndrivenVehicleDamage)
			{
				Damage = 0;
				Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
				return;
			}
		}
		else if (TMDamage != None && TMDamage.default.bDontHurtInstigator)
		{
			Damage = 0;
			return;
		}
	}

	Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);

	if ( instigatedBy == None )
		return;

	if ( WorldInfo.Game.GameDifficulty < 4.5 )
	{
		if ( (WorldInfo.Game.GameDifficulty < 4) && injured.IsPlayerPawn() && (injured.Controller == instigatedby) && ((WorldInfo.NetMode == NM_Standalone) || (SinglePlayerMissionID != INDEX_NONE)) )
			Damage *= 0.5;

		//skill level modification
		if ( (AIController(instigatedBy) != None) && ((WorldInfo.NetMode == NM_Standalone) || (SinglePlayerMissionID != INDEX_NONE)) )
		{
			InstigatorSkill = AIController(instigatedBy).Skill;
			if ( (InstigatorSkill < 4.5) && injured.IsHumanControlled() )
				{
					if ( ((instigatedBy.Pawn != None) && (instigatedBy.Pawn.Weapon != None) && instigatedBy.Pawn.Weapon.bMeleeWeapon)
						|| ((injured.Weapon != None) && injured.Weapon.bMeleeWeapon && (VSize(injured.location - instigatedBy.Pawn.Location) < 600)) )
							Damage = Damage * (0.64 + 0.08 * InstigatorSkill);
					else
							Damage = Damage * (0.2 + 0.15 * InstigatorSkill);
			}
		}
	}
	if ( InstigatedBy.Pawn != None )
	{
		Damage = Damage * instigatedBy.Pawn.GetDamageScaling();
	}
}

function NotifySpree(TMPlayerReplicationInfo Other, int num)
{
	local PlayerController PC;
	local TMPlayerController TMP;

	if (num % 5 != 0 || num == 0 || num > 30)
	{
		return;
	}

	num = ( num / 5 ) - 1;

	Other.IncrementEventStat(class'TMLeaderboardWriteDM'.Default.SPREE[num]);

	TMP = TMPlayerController(Other.Owner);
	if( TMP != none )
	{
		TMP.BeginFocusEffect();
	}

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.ReceiveLocalizedMessage( class'TMKillingSpreeMessage', Num, Other );
	}

	if( ( TMPlayerController(Other.Owner) == None )
	|| TMPlayerController(Other.Owner).bAutoTaunt )
	{
		Controller(Other.Owner).SendMessage(None, 'TAUNT', 10, None);
	}
}

function EndSpree(TMPlayerReplicationInfo Killer, TMPlayerReplicationInfo Other)
{
	local PlayerController PC;

	if ( Other == None )
		return;

	Other.Spree = 0;
	if ( Killer != None )
	{
		Killer.IncrementEventStat('EVENT_ENDSPREE');
	}

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		if ( (Killer == Other) || (Killer == None) )
		{
			PC.ReceiveLocalizedMessage( class'TMKillingSpreeMessage', 1, None, Other );
		}
		else
		{
			PC.ReceiveLocalizedMessage( class'TMKillingSpreeMessage', 0, Other, Killer );
		}
	}
}


//------------------------------------------------------------------------------
// Game States


/**
 * This is called once the client has sent the server their unique net id.
 * It is now possible to set up their mute list.
 *
 * @param PC the playercontroller that is ready for updates
 */
function UpdateGameplayMuteList( PlayerController PC )
{
	local TMPlayerController TMPC;

	TMPC = TMPlayerController( PC );
	if( TMPC != None )
	{
		SetupPlayerMuteList( TMPC, false );  // Force spectator channel?
	}

	Super.UpdateGameplayMuteList(PC);
}



/**
 * Sets up the voice mute list based upon this player's team/spectator state. Opponents are
 * added the specified player's mute list and vice versa.
 *
 * @param PC the player controller to initialize muting for
 */
function SetupPlayerMuteList( TMPlayerController PC, bool bForceSpectatorChannel )
{
	local TeamInfo MyTeam;
	local int MyVoiceChannel;
	local TeamInfo OtherTeam;
	local TMPlayerController OtherPC;
	local int OtherVoiceChannel;
	local UniqueNetId ZeroUniqueNetId;

	// Make sure we have a valid unique online ID.  If we don't, then one of the following is true:
	//    * Player isn't signed into an online profile (we don't support voice chat unless you're signed in online.)
	//    * Player doesn't have a unique online ID (maybe it's an AI or something?)
	//    * Player's unique online ID isn't available to the server yet
	if (PC.PlayerReplicationInfo != None && PC.PlayerReplicationInfo.UniqueId != ZeroUniqueNetId)
	{
		// `log( "VOIP| SetupPlayerMuteList:  For player [" @ PC.PlayerReplicationInfo.PlayerName @ " : " @ PC.PlayerReplicationInfo.UniqueId.Uid[0]@PC.PlayerReplicationInfo.UniqueId.Uid[1]@PC.PlayerReplicationInfo.UniqueId.Uid[2]@PC.PlayerReplicationInfo.UniqueId.Uid[3]@PC.PlayerReplicationInfo.UniqueId.Uid[4]@PC.PlayerReplicationInfo.UniqueId.Uid[5]@PC.PlayerReplicationInfo.UniqueId.Uid[6]@PC.PlayerReplicationInfo.UniqueId.Uid[7] @ "]  Force spectator [" @ bForceSpectatorChannel @ "]" );

		// Start off in the spectator channel
		MyTeam = PC.PlayerReplicationInfo.Team;
		MyVoiceChannel = VC_Spectators;
		if( !bForceSpectatorChannel && !PC.PlayerReplicationInfo.bIsSpectator )
		{
			// OK, we're not a spectator and we were not asked to be forced into that channel
			MyVoiceChannel = VC_Team1;
			if (!bIgnoreTeamForVoiceChat && MyTeam != None && MyTeam.TeamIndex > 0)
			{
				// We're on team 2 and we were asked to respect the team settings
				MyVoiceChannel = VC_Team2;
			}
		}

		// `log( "VOIP|                           My voice channel [" @ MyVoiceChannel @ "]  Spectator [" @ PC.PlayerReplicationInfo.bIsSpectator @ "]" );

		// Check all players
		foreach WorldInfo.AllControllers( class'TMPlayerController', OtherPC )
		{
			if (OtherPC != PC && OtherPC.PlayerReplicationInfo != None)
			{
				// Make sure the other player has a valid online ID.
				if( OtherPC.PlayerReplicationInfo.UniqueId != ZeroUniqueNetId )
				{
					// Start the other player off in the spectator channel
					OtherVoiceChannel = VC_Spectators;
					if( !bForceSpectatorChannel && !OtherPC.PlayerReplicationInfo.bIsSpectator )
					{
						// Other player isn't a spectator, so assume team 1 first
						OtherVoiceChannel = VC_Team1;
						OtherTeam = OtherPC.PlayerReplicationInfo.Team;
						if (!bIgnoreTeamForVoiceChat && OtherTeam != None && OtherTeam.TeamIndex > 0)
						{
							// Other player is on a team and it's team 2, and we were asked to respect that
							OtherVoiceChannel = VC_Team2;
						}
					}

					// If not on the same team and not in the list already, mute
					if( OtherVoiceChannel != MyVoiceChannel )
					{
						// `log( "VOIP|                           Cannot hear [" @ OtherPC.PlayerReplicationInfo.PlayerName @ " : " @ OtherPC.PlayerReplicationInfo.UniqueId.Uid[0]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[1]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[2]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[3]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[4]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[5]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[6]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[7] @ "]  Voice channel [" @ OtherVoiceChannel @ "]  Spectator [" @ OtherPC.PlayerReplicationInfo.bIsSpectator @ "]" );

						PC.GameplayMutePlayer( OtherPC.PlayerReplicationInfo.UniqueId );
						OtherPC.GameplayMutePlayer( PC.PlayerReplicationInfo.UniqueId );
					}
					else
					{
						// `log( "VOIP|                           Can hear [" @ OtherPC.PlayerReplicationInfo.PlayerName @ " : " @ OtherPC.PlayerReplicationInfo.UniqueId.Uid[0]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[1]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[2]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[3]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[4]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[5]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[6]@OtherPC.PlayerReplicationInfo.UniqueId.Uid[7] @ "]  Voice channel [" @ OtherVoiceChannel @ "]  Spectator [" @ OtherPC.PlayerReplicationInfo.bIsSpectator @ "]" );

						PC.GameplayUnmutePlayer( OtherPC.PlayerReplicationInfo.UniqueId );
						OtherPC.GameplayUnmutePlayer( PC.PlayerReplicationInfo.UniqueId );
					}
				}
				else
				{
					// `log( "VOIP|                           Skipping [" @ OtherPC.PlayerReplicationInfo.PlayerName @ "], player doesn't have a UniqueNetId." );
				}
			}
		}
	}
	else
	{
		// `log( "VOIP| SetupPlayerMuteList:  Player [" @ PC.PlayerReplicationInfo.PlayerName @ "] doesn't have a UniqueNetId.  Nothing to do." );
	}
}



/**
 * Removes the specified player from all other player's mute lists
 *
 * @param PC Player controller to remove from other mute lists
 */
function RemovePlayerFromMuteLists( TMPlayerController PC )
{
	local TMPlayerController CurPC;

	if( PC != None )
	{
		foreach WorldInfo.AllControllers( class'TMPlayerController', CurPC )
		{
			if( CurPC != PC )
			{
				CurPC.GameplayUnmutePlayer( PC.PlayerReplicationInfo.UniqueId );
			}
		}
	}
}


/**
 * Reset everyone's channel to the same thing and then rebuild the gameplay
 * mute lists for each player
 */
function ResetAllPlayerMuteListsToSpectatorChannel()
{
	local TMPlayerController PC;

	// Allow everyone to hear each other
	foreach WorldInfo.AllControllers( class'TMPlayerController', PC )
	{
		// Clear the gameplay mute list so everyone can talk to each other while traveling
		SetupPlayerMuteList( PC, true );	// Force spectator channel?
	}
}

function StartMatch()
{
	local bool bTemp;
	local TMPlayerController PC;

	if (GameplayEventsWriter != None && !GameplayEventsWriter.IsSessionInProgress() && !class'WorldInfo'.static.IsMenuLevel())
	{
		// @STATS - begin tracking events for this session (class,mapname,url)
		GameplayEventsWriter.StartLogging(0.5f);

		foreach WorldInfo.AllControllers(class'TMPlayerController',PC)
		{
			// @STATS - log all the players who have already joined
			if(GameplayEventsWriter != None && GameplayEventsWriter.CurrentSessionInfo.bGameplaySessionInProgress){TMGameplayEventsWriter(GameplayEventsWriter).LogPlayerLoginChange(class'TMGameplayEventsWriter'.const.GAMEEVENT_PLAYER_LOGIN,PC,PC.PlayerReplicationInfo.PlayerName,PC.PlayerReplicationInfo.UniqueId,PC.IsSplitscreenPlayer());};
		}
	}

	if ( CheckForSentinelRun() )
	{
		return;
	}

    GotoState('MatchInProgress');

    GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
    Super.StartMatch();

	bTemp = bMustJoinBeforeStart;
    bMustJoinBeforeStart = false;

	AddInitialBots();

    bMustJoinBeforeStart = bTemp;

	;


	// Setup team VOIP mute lists
	foreach WorldInfo.AllControllers( class'TMPlayerController', PC )
	{
		SetupPlayerMuteList( PC, false );	// Force spectator channel?
	}


	// we had to wait for the constructioning and the commandline causeevent for the flythrough was lost
	// so we need to fire off another one once we know that we are in the match and meshes have been constructioned!
	if( CauseEventCommand != "" )
	{
		foreach WorldInfo.AllControllers(class'TMPlayerController', PC)
		{
			PC.ConsoleCommand( "ce " $ CauseEventCommand );
			break;
		}
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

function EndGame(PlayerReplicationInfo Winner, string Reason )
{
	local Sequence GameSequence;
	local array<SequenceObject> Events;
	local int i;

	if ( (Reason ~= "triggered") ||
	 (Reason ~= "LastMan")   ||
	 (Reason ~= "TimeLimit") ||
	 (Reason ~= "FragLimit") ||
	 (Reason ~= "TeamScoreLimit") )
	{
		Super.EndGame(Winner,Reason);
		if ( bGameEnded )
		{
			// trigger any Kismet "Game Ended" events
			GameSequence = WorldInfo.GetGameSequence();
			if (GameSequence != None)
			{
				GameSequence.FindSeqObjectsByClass(class'TMSeqEvent_GameEnded', true, Events);
				for (i = 0; i < Events.length; i++)
				{
					TMSeqEvent_GameEnded(Events[i]).CheckActivate(self, None);
				}
			}

			GotoState('MatchOver');
		}
	}
}

function EndLogging(string Reason)
{
	if (GameplayEventsWriter != None)
	{
		GameplayEventsWriter.EndLogging();
	}

	Super.EndLogging(Reason);
}

/** FindPlayerStart()
* Return the 'best' player start for this player to start from.  PlayerStarts are rated by RatePlayerStart().
* @param Player is the controller for whom we are choosing a playerstart
* @param InTeam specifies the Player's team (if the player hasn't joined a team yet)
* @param IncomingName specifies the tag of a teleporter to use as the Playerstart
* @returns NavigationPoint chosen as player start (usually a PlayerStart)
 */
function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local NavigationPoint Best;

	if (ScriptedStartSpot != None)
	{
		Best = ScriptedStartSpot;
		ScriptedStartSpot = None;
	}
	else
	{
		// Save LastPlayerStartSpot for use in RatePlayerStart()
		if ( (Player != None) && (Player.StartSpot != None) )
		{
			LastPlayerStartSpot = Player.StartSpot;
		}

		Best = Super.FindPlayerStart(Player, InTeam, incomingName );

		// Save LastStartSpot for use in RatePlayerStart()
		if ( Best != None )
		{
			LastStartSpot = Best;
		}
	}

	return Best;
}

function bool DominatingVictory()
{
	return ( (PlayerReplicationInfo(GameReplicationInfo.Winner).Deaths == 0)
		&& (PlayerReplicationInfo(GameReplicationInfo.Winner).Score >= 5) );
}

function bool IsAWinner(PlayerController C)
{
	if ( C.PlayerReplicationInfo == None )
	{
		return false;
	}
	return ( C.PlayerReplicationInfo.bOnlySpectator || (C.PlayerReplicationInfo == GameReplicationInfo.Winner) );
}

function PlayEndOfMatchMessage()
{
	local TMPlayerController PC;

	if ( DominatingVictory() )
	{
		foreach WorldInfo.AllControllers(class'TMPlayerController', PC)
		{
			if (IsAWinner(PC))
			{
				PC.ClientPlayAnnouncement(VictoryMessageClass, 0);
			}
			else
			{
				PC.ClientPlayAnnouncement(VictoryMessageClass, 1);
			}
		}
	}
	else
		PlayRegularEndOfMatchMessage();
}

function PlayRegularEndOfMatchMessage()
{
	local TMPlayerController PC;

	foreach WorldInfo.AllControllers(class'TMPlayerController', PC)
	{
		if ( (PC.PlayerReplicationInfo != None) && !PC.PlayerReplicationInfo.bOnlySpectator )
		{
			if (IsAWinner(PC))
			{
				PC.ClientPlayAnnouncement(VictoryMessageClass, 2);
			}
			else
			{
				PC.ClientPlayAnnouncement(VictoryMessageClass, 3);
			}
		}
	}
}

function PlayStartupMessage()
{
	local TMPlayerController P;

	// keep message displayed for waiting players
	foreach WorldInfo.AllControllers(class'TMPlayerController', P)
	{
		P.PlayStartUpMessage(StartupStage);
	}
}

function bool JustStarted(float MaxElapsedTime)
{
	return GameReplicationInfo.ElapsedTime < MaxElapsedTime;
}

/** ends the current round; sends the game into state RoundOver and sets the ViewTarget for all players to be the given actor */
function EndRound(Actor EndRoundFocus)
{
	local Controller C;

	//round has ended
	if ( !bGameEnded )
	{
		foreach WorldInfo.AllControllers(class'Controller', C)
		{
			C.RoundHasEnded(EndRoundFocus);
		}
	}
	GotoState('RoundOver');
}

function bool MatchIsInProgress()
{
	return false;
}

function AddInitialBots()
{
	local int AddCount;

	// add any bots immediately
	while (NeedPlayers() && AddBot() != None && AddCount < 16)
	{
		AddCount++;
	}
}

function TMBot SinglePlayerAddBot(optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
	local int i, CharIndex;
	local TMGameReplicationInfo GRI;
	local TMPlayerReplicationInfo PRI;
	if ( BotName != "" )
	{
		GRI = TMGameReplicationInfo(GameReplicationInfo);
		if ( GRI != none )
		{
			CharIndex = INDEX_None;
			for (i=0;i<4;i++)
			{
				if ( GRI.SinglePlayerBotNames[i] ~= BotName )
				{
					CharIndex = i;
					break;
				}
			}

			// Try to add one of the player bots.  See if that player is on the server
			// and if so, ignore the bot.
			if ( CharIndex != INDEX_None )
			{
				for (i=0;i<GRI.PRIArray.Length;i++)
				{
					PRI = TMPlayerReplicationInfo(GRI.PRIArray[i]);
					if ( PRI.SinglePlayerCharacterIndex == CharIndex )	// Player existing playing this character so don't add this bot.
					{
						return None;
					}
				}
			}
		}
	}

	return AddBot(BotName, bUseTeamIndex, TeamIndex);
}

function int CalculatedNetSpeed()
{
	local int ModifiedNetBandwidth;

	ModifiedNetBandwidth = TotalNetBandwidth;
	if ( IsConsoleDedicatedServer() )
	{
		ModifiedNetBandwidth *= 2;
	}

	return Clamp(ModifiedNetBandwidth/Max(NumPlayers,1), MinDynamicBandwidth, MaxDynamicBandwidth);
}

/** @return whether we are running a console "fake" dedicated server (listen server with rendering turned off) */
function bool IsConsoleDedicatedServer()
{
	local TMPlayerController PC;

	foreach LocalPlayerControllers(class'TMPlayerController', PC)
	{
		if (PC.bDedicatedServerSpectator)
		{
			return true;
		}
	}

	return false;
}

auto State PendingMatch
{

	function RestartPlayer(Controller aPlayer)
	{
		if (TMGameReplicationInfo(GameReplicationInfo).bWarmupRound)
		{
			Global.RestartPlayer(aPlayer);
		}
	}

	// Override these 4 functions so that if we are in a warmup round, they get ignored.

	function CheckLives();
	function bool CheckScore(PlayerReplicationInfo Scorer);
	function ScoreKill(Controller Killer, Controller Other);
	function ScoreFlag(Controller Scorer, TMCTFFlag theFlag);

	function Timer()
	{
		local PlayerController P;
		local bool bReady;
		local TMBot B;

		Global.Timer();

		// first check if there are enough net players, and enough time has elapsed to give people
		// a chance to join
		if ( NumPlayers == 0 )
		{
			bShouldWaitForNetPlayers = bWaitForNetPlayers && (WorldInfo.NetMode != NM_Standalone);

			if (bWarmupRound)
			{
				WarmupRemaining = WarmupTime;
				GameReplicationInfo.RemainingTime = WarmupRemaining;
			}
		}
		else
		{
			foreach WorldInfo.AllControllers(class'TMBot', B)
			{
				if (TooManyBots(B))
				{
					B.Destroy();
				}
			}

			AddInitialBots();

			if (bWarmupRound)
			{
				if (WarmupRemaining > 0)
				{
					WarmupRemaining--;
					GameReplicationInfo.RemainingTime = WarmupRemaining;
					if (WarmupRemaining % 60 == 0)
					{
						GameReplicationInfo.RemainingMinute = WarmupRemaining;
					}
			   		return;
				}
				else if (WarmupRemaining == 0)
				{
					WarmupRemaining = -1;
					TMGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
			   		ResetLevel();
				}
			}
		}

		if ( bShouldWaitForNetPlayers )
		{
			if ( (NumPlayers >= MinNetPlayers) && (NumPlayers > 0) )
				PendingMatchElapsedTime++;
			else
				PendingMatchElapsedTime = 0;
			if ( (NumPlayers == MaxPlayers) || (PendingMatchElapsedTime > NetWait) )
			{
				// wait until players finish clientside processing (or it times out)
				bShouldWaitForNetPlayers = false;
				CountDown = Default.CountDown;
			}
			else
			{
				PlayStartupMessage();
				return;
			}
		}

		// check if players are ready
		bReady = true;

		StartupStage = 1;
		if ( !bStartedCountDown && (bPlayersMustBeReady || (WorldInfo.NetMode == NM_Standalone)) )
		{
			foreach WorldInfo.AllControllers(class'PlayerController', P)
			{
				if ( P.PlayerReplicationInfo != None && P.bIsPlayer && P.PlayerReplicationInfo.bWaitingPlayer
					&& !P.PlayerReplicationInfo.bReadyToPlay )
				{
					bReady = false;
				}
			}
		}
		if ( bReady && SinglePlayerMissionID == INDEX_None )
		{

			if (!bStartedCountDown)
			{
				if (DemoPrefix != "")
				{
					ConsoleCommand("demorec" @ DemoPrefix $ "-%td");
				}
				bStartedCountDown = true;
			}
			CountDown--;
			if ( CountDown <= 0 )
				StartMatch();
			else
				StartupStage = 5 - CountDown;
		}
		PlayStartupMessage();
	}

	function BeginState(Name PreviousStateName)
	{
		if (bWarmupRound)
		{
			GameReplicationInfo.RemainingTime = WarmupRemaining;
			GameReplicationInfo.RemainingMinute = WarmupRemaining;
		}
		bWaitingToStartMatch = true;
		TMGameReplicationInfo(GameReplicationInfo).bWarmupRound = bWarmupRound;
		StartupStage = 0;
	}

	function EndState(Name NextStateName)
	{
		TMGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
	}


Begin:
	if (WorldInfo.NetMode == NM_Standalone || (WorldInfo.NetMode == NM_ListenServer && !IsConsoleDedicatedServer()))
	{
		Sleep(0.0); //@hack - so local player has time to get friendly faction from profile
		AddInitialBots();
	}

	// quickstart for solo loading of a map
	if (DesiredPlayerCount <= 1 && WorldInfo.NetMode == NM_StandAlone && SinglePlayerMissionID == INDEX_NONE)
	{
		bQuickStart = true;
	}

	if ( bQuickStart )
	{
		if (DemoPrefix != "")
		{
			ConsoleCommand("demorec" @ DemoPrefix $ "-%td");
		}

		StartMatch();
	}
}

state MatchInProgress
{
	function bool MatchIsInProgress()
	{
		return true;
	}

	function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
	{
		local bool bSuccess;
		local TMPlayerController TMPC;

		// Call parent implementation
		bSuccess = Global.ChangeTeam(Other, Num, bNewTeam);

		// OK, we changed teams while mid-game.  Update our voice muting state.
		TMPC = TMPlayerController( Other );
		if( TMPC != None )
		{
			SetupPlayerMuteList( TMPC, false );		// Force spectator channel?
		}

		return bSuccess;
	}

	function Timer()
	{
//		local PlayerController P;

		Global.Timer();
		if ( !bFinalStartup )
		{
			bFinalStartup = true;
			PlayStartupMessage();
		}
		// force respawn failsafe
//		if( ForceRespawn() )
//		{
//			foreach WorldInfo.AllControllers(class'PlayerController', P)
//			{
//				if( P.Pawn == None
//				&& !P.PlayerReplicationInfo.bOnlySpectator
//				&& !P.IsTimerActive('DoForcedRespawn') )
//				{
//					P.ServerReStartPlayer();
//				}
//			}
//		}

		if ( NeedPlayers() )
		{
			AddBot();
		}

		if ( bOverTime )
		{
			EndGame(None,"TimeLimit");
		}
		else if ( TimeLimit > 0 )
		{
			GameReplicationInfo.bStopCountDown = false;
			if ( GameReplicationInfo.RemainingTime <= 0 )
			{
				EndGame(None,"TimeLimit");
			}
		}
		else if ( (MaxLives > 0) && (NumPlayers + NumBots != 1) )
		{
			CheckMaxLives(none);
		}
	}

	function BeginState(Name PreviousStateName)
	{
		local PlayerReplicationInfo PRI;

		if (PreviousStateName != 'RoundOver')
		{
			foreach DynamicActors(class'PlayerReplicationInfo', PRI)
			{
				PRI.StartTime = 0;
			}
			GameReplicationInfo.ElapsedTime = 0;
			bWaitingToStartMatch = false;
			StartupStage = 5;
			PlayStartupMessage();
			StartupStage = 6;
		}
	}
}

State MatchOver
{
	function RestartPlayer(Controller aPlayer) {}
	function ScoreKill(Controller Killer, Controller Other) {}

	function ReduceDamage(out int Damage, pawn injured, Controller instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
	{
		Damage = 0;
		Momentum = vect(0,0,0);
	}

	function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
	{
		// we don't want newly joining players to get stuck as a spectator for the next match,
		// mark them as out of the game and pretend we succeeded
		Other.PlayerReplicationInfo.bOutOfLives = true;
		return true;
	}

	event PostLogin(PlayerController NewPlayer)
	{
		Global.PostLogin(NewPlayer);

		NewPlayer.GameHasEnded(EndGameFocus);
	}

	function Timer()
	{
		local PlayerController PC;
		local Sequence GameSequence;
		local array<SequenceObject> AllInterpActions;
		local SeqAct_Interp InterpAction;
		local int i, j;
		local bool bIsInCinematic;

		Global.Timer();

		if ( !bGameRestarted && (WorldInfo.TimeSeconds > EndTime + RestartWait) )
		{
			RestartGame();
		}

		if ( EndGameFocus != None )
		{
			EndGameFocus.bAlwaysRelevant = true;

			// if we're not in a cinematic (matinee controlled camera), force all players' ViewTarget to the EndGameFocus
			GameSequence = WorldInfo.GetGameSequence();
			if (GameSequence != None)
			{
				// find any matinee actions that exist
				GameSequence.FindSeqObjectsByClass(class'SeqAct_Interp', true, AllInterpActions);
				for (i = 0; i < AllInterpActions.length && !bIsInCinematic; i++)
				{
					InterpAction = SeqAct_Interp(AllInterpActions[i]);
					if (InterpAction.InterpData != None && InterpAction.GroupInst.length > 0)
					{
						for (j = 0; j < InterpAction.InterpData.InterpGroups.length; j++)
						{
							if (InterpGroupDirector(InterpAction.InterpData.InterpGroups[j]) != None)
							{
								bIsInCinematic = true;
								break;
							}
						}
					}
				}
			}
			if (!bIsInCinematic)
			{
				foreach WorldInfo.AllControllers(class'PlayerController', PC)
				{
					PC.ClientSetViewtarget(EndGameFocus);
				}
			}
		}

		// play end-of-match message for winner/losers (for single and muli-player)
		EndMessageCounter++;
		if ( EndMessageCounter == EndMessageWait )
		{
			PlayEndOfMatchMessage();
		}
	}

	function bool NeedPlayers()
	{
		return false;
	}

	function BeginState(Name PreviousStateName)
	{
		local Pawn P;

		// Reset VOIP muting so everyone can talk to each other
		ResetAllPlayerMuteListsToSpectatorChannel();

		GameReplicationInfo.bStopCountDown = true;
		foreach WorldInfo.AllPawns(class'Pawn', P)
		{
			P.TurnOff();
		}
	}

	function ResetLevel()
	{
		RestartGame();
	}
}

state RoundOver extends MatchOver
{
	event BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		ResetCountDown = Max(2, ResetTimeDelay);
	}

	function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
	{
		return Global.ChangeTeam(Other, Num, bNewTeam);
	}

	function ResetLevel()
	{
		// note that we need to change the state BEFORE calling ResetLevel() so that we don't unintentionally override
		// functions that ResetLevel() may call
		GotoState('');
		Global.ResetLevel();
		GotoState('MatchInProgress');
		ResetCountDown = 0;
	}

	event Timer()
	{
		Global.Timer();

		ResetCountdown--;
		if (ResetCountdown == 1)
		{
			ResetLevel();
		}
	}
}

/** ChoosePlayerStart()
* Return the 'best' player start for this player to start from.  PlayerStarts are rated by RatePlayerStart().
* @param Player is the controller for whom we are choosing a playerstart
* @param InTeam specifies the Player's team (if the player hasn't joined a team yet)
* @returns NavigationPoint chosen as player start (usually a PlayerStart)
 */
function PlayerStart ChoosePlayerStart( Controller Player, optional byte InTeam )
{
	local PlayerStart P, BestStart;
	local float BestRating, NewRating;
	local array<playerstart> PlayerStarts;
	local int i, RandStart;
	local byte Team;

	// use InTeam if player doesn't have a team yet
	Team = ( (Player != None) && (Player.PlayerReplicationInfo != None) && (Player.PlayerReplicationInfo.Team != None) )
			? byte(Player.PlayerReplicationInfo.Team.TeamIndex)
			: InTeam;

	// make array of enabled playerstarts
	foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P)
	{
		if ( P.bEnabled )
			PlayerStarts[PlayerStarts.Length] = P;
	}

	// Avoid randomness for profiling.
	if( bFixedPlayerStart )
	{
		RandStart = 0;
	}
	// start at random point to randomize finding "good enough" playerstart
	else
	{
		RandStart = Rand(PlayerStarts.Length);
	}

	for ( i=RandStart; i<PlayerStarts.Length; i++ )
	{
		P = PlayerStarts[i];
		NewRating = RatePlayerStart(P,Team,Player);
		if ( NewRating >= 30 )
		{
			// this PlayerStart is good enough
			return P;
		}
		if ( NewRating > BestRating )
		{
			BestRating = NewRating;
			BestStart = P;
		}
	}
	for ( i=0; i<RandStart; i++ )
	{
		P = PlayerStarts[i];
		NewRating = RatePlayerStart(P,Team,Player);
		if ( NewRating >= 30 )
		{
			// this PlayerStart is good enough
			return P;
		}
		if ( NewRating > BestRating )
		{
			BestRating = NewRating;
			BestStart = P;
		}
	}
	return BestStart;
}

/** RatePlayerStart()
* Return a score representing how desireable a playerstart is.
* @param P is the playerstart being rated
* @param Team is the team of the player choosing the playerstart
* @param Player is the controller choosing the playerstart
* @returns playerstart score
*/
function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	local float Score, NextDist;
	local Controller OtherPlayer;
	local bool bTwoPlayerGame;

	// Primary starts are more desireable
	Score = P.bPrimaryStart ? 30 : 20;

	if ( (P == LastStartSpot) || (P == LastPlayerStartSpot) )
	{
		// avoid re-using starts
		Score -= 15.0;
	}

	bTwoPlayerGame = ( NumPlayers + NumBots == 2 );

	if (Player != None)
	{
		ForEach WorldInfo.AllControllers(class'Controller', OtherPlayer)
		{
			if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) )
			{
				// check if playerstart overlaps this pawn
				if ( (Abs(P.Location.Z - OtherPlayer.Pawn.Location.Z) < P.CylinderComponent.CollisionHeight + OtherPlayer.Pawn.CylinderComponent.CollisionHeight)
					&& (VSize2D(P.Location - OtherPlayer.Pawn.Location) < P.CylinderComponent.CollisionRadius + OtherPlayer.Pawn.CylinderComponent.CollisionRadius) )
				{
					// overlapping - would telefrag
					return -10;
				}

				NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
				if ( (NextDist < 3000) && !WorldInfo.GRI.OnSameTeam(Player,OtherPlayer) && FastTrace(P.Location, OtherPlayer.Pawn.Location+vect(0,0,1)*OtherPlayer.Pawn.CylinderComponent.CollisionHeight) )
				{
					// avoid starts close to visible enemy
					if ( (OtherPlayer.PlayerReplicationInfo != None) && (TMPlayerReplicationInfo(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo) )
					{
						// really avoid guy that killed me last
						Score -= 7;
					}
					Score -= (5 - 0.001*NextDist);
				}
				else if ( (NextDist < 1500) && (OtherPlayer.PlayerReplicationInfo != None) && (TMPlayerReplicationInfo(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo) )
				{
					// really avoid guy that killed me last
					Score -= 7;
				}
				else if ( bTwoPlayerGame )
				{
					// in 2 player game, look for any visibility
					Score += FMin(2,0.001*NextDist);
					if ( FastTrace(P.Location, OtherPlayer.Pawn.Location) )
						Score -= 5;
				}
			}
		}
	}
	return FMax(Score, 0.2);
}

// check if all other players are out
function bool CheckMaxLives(PlayerReplicationInfo Scorer)
{
	local Controller C;
	local PlayerReplicationInfo Living;
	local bool bNoneLeft;

	if ( MaxLives > 0 )
	{
		if ( (Scorer != None) && !Scorer.bOutOfLives )
			Living = Scorer;
		bNoneLeft = true;
		foreach WorldInfo.AllControllers(class'Controller', C)
		{
			if ( (C.PlayerReplicationInfo != None) && C.bIsPlayer
				&& !C.PlayerReplicationInfo.bOutOfLives
				&& !C.PlayerReplicationInfo.bOnlySpectator )
			{
				if ( Living == None )
				{
					Living = C.PlayerReplicationInfo;
				}
				else if (C.PlayerReplicationInfo != Living)
				{
					bNoneLeft = false;
				    break;
				}
			}
		}
		if ( bNoneLeft )
		{
			if ( Living != None )
			{
				EndGame(Living,"LastMan");
			}
			else
			{
				EndGame(Scorer,"LastMan");
			}
			return true;
		}
	}
	return false;
}

/* CheckScore()
see if this score means the game ends
*/
function bool CheckScore(PlayerReplicationInfo Scorer)
{
	local controller C;

	if ( CheckMaxLives(Scorer) )
	{
		return false;
	}

	if ( Scorer != None )
	{
		if ( bScoreDeaths && (GoalScore > 0) )
		{
			if ( Scorer.Score == GoalScore - 10 )
			{
				if ( !bPlayedTenKills && (GoalScore > 19) )
				{
					TMGameReplicationInfo(GameReplicationInfo).SortPRIArray();
					if ( Scorer == GameReplicationInfo.PRIArray[0] )
					{
						bPlayedTenKills = true;
						BroadcastLocalized(self,class'TMKillsRemainingMessage', 0);
					}
				}
			}
			else if ( Scorer.Score == GoalScore - 5 )
			{
				if ( !bPlayedFiveKills && (GoalScore > 9) )
				{
					TMGameReplicationInfo(GameReplicationInfo).SortPRIArray();
					if ( Scorer == GameReplicationInfo.PRIArray[0] )
					{
						bPlayedFiveKills = true;
						BroadcastLocalized(self,class'TMKillsRemainingMessage', 1);
					}
				}
			}
			else if ( (Scorer.Score == GoalScore - 1) && !bPlayedOneKill )
			{
				TMGameReplicationInfo(GameReplicationInfo).SortPRIArray();
				if ( Scorer == GameReplicationInfo.PRIArray[0] )
				{
					bPlayedOneKill = true;
					BroadcastLocalized(self,class'TMKillsRemainingMessage', 2);
				}
			}
		}
		if ( (GoalScore > 0) && (Scorer.Score >= GoalScore) )
		{
			EndGame(Scorer,"fraglimit");
		}
		else if ( bOverTime )
		{
			// end game only if scorer has highest score
			foreach WorldInfo.AllControllers(class'Controller', C)
			{
				if ( (C.PlayerReplicationInfo != None)
					&& (C.PlayerReplicationInfo != Scorer)
					&& (C.PlayerReplicationInfo.Score >= Scorer.Score) )
				{
					return false;
				}
			}
			EndGame(Scorer,"fraglimit");
		}
	}
	return true;
}

function RegisterVehicle(TMVehicle V)
{
	// add to AI vehicle list
	V.NextVehicle = VehicleList;
	VehicleList = V;
}

/**
ActivateVehicleFactory()
Called by TMVehicleFactory in its PostBeginPlay()
*/
function ActivateVehicleFactory(TMVehicleFactory VF)
{
	local TMGameObjective O, Best;
	local float BestDist, NewDist;

	if ( !bTeamGame )
		VF.bStartNeutral = true;
	if ( VF.bStartNeutral )
	{
		VF.Activate(255);
	}
	else
	{
		ForEach WorldInfo.AllNavigationPoints(class'TMGameObjective',O)
		{
			NewDist = VSize(VF.Location - O.Location);
			if ( (Best == None) || (NewDist < BestDist) )
			{
				Best = O;
				BestDist = NewDist;
			}
		}

		if ( Best != None )
			VF.Activate(Best.DefenderTeamIndex);
		else
			VF.Activate(255);
	}
}


static function int OrderToIndex(int Order)
{
	return Order;
}

function ViewObjective(PlayerController PC)
{
	local int i,Index,Score;
	local Controller C;

	if (WorldInfo.GRI.PRIArray.Length==0)
	{
		return;
	}

	// Prime the score
	Score = -1;
	Index = -1;
	for ( i=0; i<WorldInfo.GRI.PRIArray.Length; i++ )
	{
		if (WorldInfo.GRI.PRIArray[i].Score > Score)
		{
			C = Controller(WorldInfo.GRI.PRIArray[i].Owner);
			if (C!=none && C.Pawn != none)
			{
				Score = WorldInfo.GRI.PRIArray[i].Score;
				Index = i;
			}
		}
	}

	if (Index == -1)
	{
		return;
	}

	if ( Index>=0 && Index<WorldInfo.GRI.PRIArray.Length )
	{
		PC.SetViewTarget( Controller(WorldInfo.GRI.PRIArray[Index].Owner).Pawn );
	}
}

function bool PickupQuery(Pawn Other, class<Inventory> ItemClass, Actor Pickup)
{
	//if (bDemoMode)
	//{
	//	if (ItemClass!=class'TMGame.TMWeap_ShockRifle' || ItemClass!=class'TMGame.TMWeap_RocketLauncher')
	//		return false;
	//}

	return Super.PickupQuery(Other, ItemClass, Pickup);
}

function string DecodeEvent(name EventType, int TeamNo, string InstigatorName, string AdditionalName, class<object> AdditionalObj)
{
	local string s;
	if (EventType == 'TeamDeathWhileTyping')
	{
		return AdditionalName@"killed his teammate"@InstigatorName@"while he was typing! ("$AdditionalObj$")";
	}
	else if (EventType == 'DeathWhileTyping')
	{
		return AdditionalName@"killed"@InstigatorName@"while he was typing! ("$AdditionalObj$")";
	}
	else if (EventType == 'TeamDeath')
	{
		return AdditionalName@"killed his teammate"@InstigatorName$" ("$AdditionalObj$")";
	}
	else if (EventType == 'TeamDeath')
	{
		return AdditionalName@"killed"@InstigatorName$" ("$AdditionalObj$")";
	}
	else if (EventType == 'VehicleKill')
	{
		return InstigatorName$"blew up a"@AdditionalObj;
	}
	else if (EventType == 'Connect')
	{
		return InstigatorName$"has joined the game!";
	}
	else if (EventType == 'Reconnect')
	{
		return InstigatorName$"has returned to the game!";
	}
	else if (EventType == 'Disconnect')
	{
		return InstigatorName$"has left the game!";
	}
	else if (EventType == 'MatchBegins')
	{
		return "... The match begins ...";
	}
	else if (EventType == 'NewRound')
	{
		return "... Next Round ...";
	}
	else if (Left(""$EventType,10) ~= "MatchEnded")
	{
		s = ""$EventType;
		return "... Match Ended ("$Right(s,len(s)-10)$") ...";
	}
	else
		return "";
}

function AddMutator(string mutname, optional bool bUserAdded)
{
	if ( InStr(MutName,".")<0 )
	{
		MutName = "TMGame."$MutName;
	}

	Super.AddMutator(mutname, bUserAdded);
}

/**
 * This function allows the server to override any requested teleport attempts from a client
 *
 * @returns 	returns true if the teleport is allowed
 */
function bool AllowClientToTeleport(TMPlayerReplicationInfo ClientPRI, Actor DestinationActor)
{
	return true;
}

/** displays the path to the given base for the given player */
function ShowPathTo(PlayerController P, int TeamNum);

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	local int i;
	local TMBot B;
	local TMPlayerReplicationInfo PRI;

	// clear some class references on persistent actors to make sure unnecessary content doesn't stay in memory
	for (i = 0; i < GameReplicationInfo.PRIArray.length; i++)
	{
		PRI = TMPlayerReplicationInfo(GameReplicationInfo.PRIArray[i]);
		if (PRI != None)
		{
			PRI.HUDPawnClass = None;
		}
	}
	foreach WorldInfo.AllControllers(class'TMBot', B)
	{
		B.KilledVehicleClass = None;
	}

	Super.GetSeamlessTravelActorList(bToEntry, ActorList);
}

event PostSeamlessTravel()
{
	local int i;
	local TMPlayerReplicationInfo PRI;

	Super.PostSeamlessTravel();

	//@hack: workaround for PRIs getting left around in Campaign for some reason
	if (TMGameReplicationInfo(WorldInfo.GRI) != None && TMGameReplicationInfo(WorldInfo.GRI).bStoryMode)
	{
		for (i = 0; i < WorldInfo.GRI.PRIArray.length; i++)
		{
			PRI = TMPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]);
			if (PRI != None && PRI.Owner == None)
			{
				PRI.Destroy();
			}
		}
	}
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	local TMBot B;
	local TMPlayerController PC;
	local string BotName;
	local int BotTeamIndex;

	B = TMBot(C);
	if (B != None && B.Class != BotClass)
	{
		// re-create bot
		BotName = B.PlayerReplicationInfo.PlayerName;
		BotTeamIndex = B.GetTeamNum();
		B.Destroy();
		C = AddBot(BotName, (BotTeamIndex != 255), BotTeamIndex);
	}
	else
	{
		Super.HandleSeamlessTravelPlayer(C);

		// make sure bots get a new squad
		if (B != None && B.Squad == None)
		{
			GetBotTeam().AddToTeam(B);
		}

		PC = TMPlayerController(C);
		if (PC != None)
		{
			PC.ClientSetSpeechRecognitionObject(SpeechRecognitionData);
		}
	}

}

/** @return an objective that should be recommended to the given player based on their auto objective settings and the current game state */
function Actor GetAutoObjectiveFor(TMPlayerController PC);

/** @return the first mutator in the mutator list that's a TMMutator */
function TMMutator GetBaseTMMutator()
{
	local Mutator M;
	local TMMutator TMMut;

	for (M = BaseMutator; M != None; M = M.NextMutator)
	{
		TMMut = TMMutator(M);
		if (TMMut != None)
		{
			return TMMut;
		}
	}

	return None;
}

/** parses the given player's recognized speech into bot orders, etc */
function ProcessSpeechRecognition(TMPlayerController Speaker, const out array<SpeechRecognizedWord> Words)
{
	local TMMutator TMMut;

	TMMut = GetBaseTMMutator();
	if (TMMut != None)
	{
		TMMut.ProcessSpeechRecognition(Speaker, Words);
	}
}

/**
 * Write player scores used in skill calculations
 */
function WriteOnlinePlayerScores()
{
	local int Index;
	local int Count;
	local PlayerReplicationInfo PRI;
	local array<OnlinePlayerScore> PlayerScores;
	local UniqueNetId ZeroId;

	if (SinglePlayerMissionID > INDEX_None)
	{
		//We don't record single player stats
		return;
	}

	if (OnlineSub != None && OnlineSub.StatsInterface != None)
	{
		// Iterate through the players building their score data
		for (Index = 0; Index < GameReplicationInfo.PRIArray.Length; Index++)
		{
			// Ignore bots (bots have a zero unique net id)
			PRI = GameReplicationInfo.PRIArray[Index];
			if (PRI != None && PRI.UniqueId != ZeroId)
			{
				// Build the skill data for this player
				Count++;
				PlayerScores.Length = Count;
				PlayerScores[Count-1].PlayerId = PRI.UniqueId;
				PlayerScores[Count-1].Score = PRI.Score;
				// Each player is on their own team (rated as individuals)
				PlayerScores[Count-1].TeamId = 255;
			}
		}

		if (PlayerScores.Length > 0)
		{
			// Now write out the scores
			OnlineSub.StatsInterface.WriteOnlinePlayerScores('Game',
				bUsingArbitration ? ArbitratedLeaderboardId : LeaderboardId,
				PlayerScores);
		}
		else
		{
			;
		}
	}
}

/**
 * Sorts the scores and assigns relative positions to the players
 *
 * @param PlayerScores the raw scores before sorting and relative position setting
 */
native function SortPlayerScores(out array<OnlinePlayerScore> PlayerScores);

/** @return the index of the current map in the given list (used when starting up a server to start counting at the current map) */
function int GetCurrentMapCycleIndex(const out array<string> MapList)
{
	return MapList.Find(string(WorldInfo.GetPackageName()));
}

/**
 * Returns the next map to play.  If we are in story mode, we need to go back to the map selection menu
 */
function string GetNextMap()
{
	local bool SPResult;
	local int GameIndex;
	local array<string> MapList;

	if ( SinglePlayerMissionID > INDEX_NONE)
	{
		// TODO Add code to determine a win or loss

		SPResult = GetSinglePlayerResult();
		return "TMM-MissionSelection?SPI="$SinglePlayerMissionID$"?SPResult="$int(SPResult)$"?Difficulty="$GameDifficulty;
	}
	else
	{
		GameIndex = class'TMGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name);
		if (GameIndex != INDEX_NONE)
		{
			if (MapCycleIndex == INDEX_NONE)
			{
				//@FIXME: use temporary because compiler's "can't pass array elements by reference" restriction
				//	doesn't understand that 'const out' is safe
				MapList = class'TMGame'.default.GameSpecificMapCycles[GameIndex].Maps;
				MapCycleIndex = GetCurrentMapCycleIndex(MapList);
				if (MapCycleIndex == INDEX_NONE)
				{
					// assume current map is actually zero
					MapCycleIndex = 0;
				}
			}
			MapCycleIndex = (MapCycleIndex + 1 < class'TMGame'.default.GameSpecificMapCycles[GameIndex].Maps.length) ? (MapCycleIndex + 1) : 0;
			class'TMGame'.default.MapCycleIndex = MapCycleIndex;
			class'TMGame'.static.StaticSaveConfig();

			return class'TMGame'.default.GameSpecificMapCycles[GameIndex].Maps[MapCycleIndex];
		}
	}

	return "";
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	local Controller C;

	if (!IsInState('MatchOver'))
	{
		foreach WorldInfo.AllControllers(class'Controller', C)
		{
			C.GameHasEnded();
		}
		GotoState('MatchOver');
	}

	Super.ProcessServerTravel(URL, bAbsolute);

	// on dedicated servers, add a delay to the travel process to give clients a little more time to construct any meshes
	// since that process will get cut off when the server completely finishes travelling
	if (WorldInfo.NetMode == NM_DedicatedServer && WorldInfo.IsInSeamlessTravel())
	{
		WorldInfo.SetSeamlessTravelMidpointPause(true);
		SetTimer(7.0, false, 'ContinueSeamlessTravel');
	}
}

function ContinueSeamlessTravel()
{
	WorldInfo.SetSeamlessTravelMidpointPause(false);
}

/**
 * @Retuns the results of the match.
 */
function bool GetSinglePlayerResult()
{
	local TMPlayerController PC;
	foreach WorldInfo.AllControllers(class'TMPlayerController', PC)
	{
		if ( PC != none && LocalPlayer(PC.Player) != none )
		{
			return IsAWinner(PC);
		}
	}

	// Default to a winner
	return true;
}

/**
 * @Returns a string that describes how to win the match
 *
 */
static function string GetEndOfMatchRules(int InGoalScore, int InTimeLimit)
{
	local string Work;
	if ( InGoalScore > 0 )
	{
		Work = (InGoalScore == 1) ? default.EndOfMatchRulesTemplateStr_ScoringSingle : default.EndOfMatchRulesTemplateStr_Scoring;
	}
	else
	{
		Work = default.EndOfMatchRulesTemplateStr_Time;
	}

	Work = Repl(Work,"\`g",string(InGoalScore));
	Work = Repl(Work,"\`t",string(InTimeLimit));

	return Work;
}

/**
 * Returns through outparameters what location message to play
 * Returns true if it returned message information
 */
function bool GetLocationFor(Pawn StatusPawn, out Actor LocationObject, out int MessageIndex, int LocationSpeechOffset)
{
	local TMPickupFactory F;
	local TMGameObjective Best, O;
	local float NewDistSq, BestDistSq;
	local TMBot B;

	// see if it's a bot heading for an objective or a power up
	B = TMBot(StatusPawn.Controller);
	if ( B != None )
	{
		O = (B.Squad != None) ? B.Squad.SquadObjective : TMGameObjective(B.SquadRouteGoal);
		if ( O == None )
		{
			O = TMGameObjective(B.RouteGoal);
		}
		if ( O != None )
		{
			if ( O.bHasLocationSpeech )
			{
				MessageIndex = O.GetLocationMessageIndex(B, StatusPawn);
				LocationObject = O;
				return true;
			}
		}
		else
		{
			F = TMPickupFactory(StatusPawn.Controller.RouteGoal);
			if ( (F != None) && F.bHasLocationSpeech )
			{
				MessageIndex = 0;
				LocationObject = F;
				return true;
			}
		}
	}

	// try to find nearby objective
	ForEach WorldInfo.AllNavigationPoints(class'TMGameObjective', O)
	{
		if ( O.bHasLocationSpeech )
		{
			if ( LocationSpeechOffset >= O.LocationSpeech.Length )
			{
				return false;
			}
			NewDistSq = VSizeSq(StatusPawn.Location - O.Location);
			if ( (Best == None) || (NewDistSq < BestDistSq) )
			{
				Best = O;
				BestDistSq = NewDistSq;
			}
		}
	}
	if ( Best != None )
	{
		MessageIndex = Best.GetLocationMessageIndex(B, StatusPawn);
		LocationObject = Best;
		return true;
	}

	MessageIndex = 10;
	return true;
}

function bool GetTravelType()
{
	return SinglePlayerMissionID > INDEX_NONE;
}

/**
 * AllowCheats - Allow cheating in single player games and coop games.
 */
function bool AllowCheats(PlayerController P)
{
	return ( (WorldInfo.NetMode == NM_Standalone) || ((SinglePlayerMissionID != INDEX_NONE) && (WorldInfo.NetMode == NM_ListenServer)) );
}

function SkipCinematics(PlayerController PC)
{
	local Sequence GameSequence;
	local array<SequenceObject> SkipEvents;
	local int i;

	;

	// on host, check if should skip tutorial
	if ( Role == ROLE_Authority && WorldInfo.GRI.bMatchHasBegun && SinglePlayerMissionID != INDEX_NONE )
	{
		GameSequence = WorldInfo.GetGameSequence();
		if (GameSequence != None)
		{
			GameSequence.FindSeqObjectsByClass(class'TMSeqEvent_SkipCinematic', true, SkipEvents);
			for (i = 0; i < SkipEvents.length; i++)
			{
				if ( TMSeqEvent_SkipCinematic(SkipEvents[i]).bEnabled &&
					TMSeqEvent_SkipCinematic(SkipEvents[i]).CheckActivate(self, self) )
				{
					return;
				}
			}
		}
	}
}

static function RemoveOption( out string Options, string InKey )
{
	local int Start;
	local string LeftString, RightString, CapOptions;

	InKey = caps(InKey);
	CapOptions= caps(Options);
	Start = InStr(CapOptions, InKey);
	if ( Start > 0 )
	{
		LeftString = Left(Options,Start-1);
		RightString = Right(Options, Len(Options)- Start - Len(InKey) - 1);
		Start = InStr(RightString, "?");
		if ( Start > 0 )
		{
			RightString = Right(RightString, Len(RightString) - Start);
		}
		else
		{
			RightString = "";
		}
		Options = LeftString$RightString;
	}
	;
}

/**
 * Used to update any changes in game settings that need to be published to
 * players that are searching for games
 */
function UpdateGameSettings()
{
	local string MapName;
	local string GameTypeName;
	local OnlineGameSettings GameSettings;

	if (GameInterface != None)
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
	}

	if (GameSettings != None && GameInterface != None)
	{
		MapName = WorldInfo.GetMapName(true);
		GameTypeName = PathName(WorldInfo.GetGameClass());

		GameSettings.SetPropertyFromStringByName('CustomMapName',MapName);
		GameSettings.SetPropertyFromStringByName('CustomGameMode',GameTypeName);

		// Is this game still pure?
		GameSettings.SetStringSettingValue(class'TMGameSearchCommon'.const.CONTEXT_PURESERVER,
			IsPureGame() ? class'TMGameSearchCommon'.const.CONTEXT_PURESERVER_YES : class'TMGameSearchCommon'.const.CONTEXT_PURESERVER_NO,
			false);

		// make sure we advertise that we're locked if a password is required to login
		GameSettings.SetStringSettingValue(class'TMGameSearchCommon'.const.CONTEXT_LOCKEDSERVER,
			RequiresPassword() ? class'TMGameSearchCommon'.const.CONTEXT_LOCKEDSERVER_YES : class'TMGameSearchCommon'.const.CONTEXT_LOCKEDSERVER_NO,
			false);

		GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName,GameSettings);
	}
}

static function bool UseLowGore(WorldInfo WI)
{
	return (Default.GoreLevel > 0) && (WI.NetMode != NM_DedicatedServer);
}

// `k = Owner's PlayerName (Killer)
// `o = Other's PlayerName (Victim)
static function string ParseKillMessage( string KillerName, string VictimName, string DeathMessage )
{
	return Repl(Repl(DeathMessage,"\`k",KillerName),"\`o",VictimName);
}

