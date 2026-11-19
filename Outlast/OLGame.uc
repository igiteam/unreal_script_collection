class OLGame extends UDKGame
	native;

enum EDifficultyMode
{
	EDM_Normal,
	EDM_Hard,
	EDM_Nightmare,
	EDM_Insane,
};

var EDifficultyMode DifficultyMode;

var config name DefaultMapName;
var config name DemoMapName;
var config name DLCInstalledMapName;

var name CurrentCheckpointName;

var config bool bIsDemo;
var config bool bForcePlayingDLC;
var bool bIsPlayingDLC;

var OLVoiceManager VoiceManager;

var name PendingCheckpointName;

var bool bSoundOnPause;

var const AKEvent SndPause;
var const AKEvent SndUnpause;
var const AKEvent SndPauseNoSound;
var const AKEvent SndUnpauseNoSound;

cpptext
{
	virtual void PostBeginPlay();
	virtual void BeginDestroy();
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return class'OLGame';
}

native static function bool IsDemo();
native static function bool IsPlayingDLC();
native static function bool IsDLCInstalled();

function bool AllowCheats(PlayerController P)
{
`if(`notdefined(FINAL_RELEASE))
	return true;
`else
	return false;
`endif
}

native function OLCheckpoint MatchCheckpoint(string PortalName);

function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string IncomingName )
{
	local OLCheckpoint Checkpoint;
	if (CurrentCheckpointName != '' && IncomingName == "")
	{
		return MatchCheckpoint(string(CurrentCheckpointName));
	}
	else
	{
		Checkpoint = MatchCheckpoint(IncomingName);
		if (Checkpoint != None)
		{
			CurrentCheckpointName = Checkpoint.CheckpointName;
			return Checkpoint;
		}
		else if (IncomingName != "")
		{
			PendingCheckpointName = name(IncomingName);
		}
		return Super.FindPlayerStart(Player, InTeam, IncomingName);
	}
}

event OnPlayerSpawned(Controller NewPlayer, NavigationPoint StartPoint)
{
	local OLCheckpoint Checkpoint;
	local OLEnemyPawn EnemyPawn;

	Checkpoint = OLCheckpoint(StartPoint);

	if (Checkpoint != None)
	{
		if (Checkpoint.bKillAllEnemies)
		{
			ForEach DynamicActors(class'OLEnemyPawn', EnemyPawn)				
			{
				if ( EnemyPawn.Controller != None )
				{
					EnemyPawn.Controller.Destroy();
				}
				EnemyPawn.Destroy();
			}
		}

		Checkpoint.OnPlayerSpawn();
	}
}

native function UpdateGameType();

function RestartPlayer(Controller NewPlayer)
{
	local int Idx;
	local array<SequenceObject> Events;
	local SeqEvent_PlayerSpawned SpawnedEvent;

	UpdateGameType();

	Super.RestartPlayer(NewPlayer);

	if (CurrentCheckpointName == '')
	{
		// Trigger PlayerSpawned events if we don't have a checkpoint (otherwise trigger them only on travel complete)
		if (WorldInfo.GetGameSequence() != None)
		{
			WorldInfo.GetGameSequence().FindSeqObjectsByClass(class'SeqEvent_PlayerSpawned',TRUE,Events);
			for (Idx = 0; Idx < Events.Length; Idx++)
			{
				SpawnedEvent = SeqEvent_PlayerSpawned(Events[Idx]);
				if (SpawnedEvent != None &&
					SpawnedEvent.CheckActivate(NewPlayer,NewPlayer))
				{
					SpawnedEvent.SpawnPoint = None;
					SpawnedEvent.PopulateLinkedVariableValues();
				}
			}
		}
	}
}

native function OnTravelToStartupMap();

event TravelToStartupMap()
{
	OnTravelToStartupMap();

	if (IsDemo())
	{
		ConsoleCommand("open " $ DemoMapName);
	}
	else if (IsDLCInstalled())
	{
		`log("### -- TravelToStartupMap: " $ DLCInstalledMapName);
		ConsoleCommand("open " $ DLCInstalledMapName);
	}
	else
	{
		`log("### -- TravelToStartupMap: " $ DefaultMapName);
		ConsoleCommand("open " $ DefaultMapName);
	}
}


function SetGameSpeed( Float T )
{
	GameSpeed = FMax(T, 0.00001);
	WorldInfo.TimeDilation = GameSpeed;
	SetTimer(WorldInfo.TimeDilation, true);
}

native function HandlePaused();
native function HandleUnpaused();

function bool SetPause(PlayerController PC, optional delegate<CanUnpause> CanUnpauseDelegate=CanUnpause)
{
	local bool bReturn;

	bReturn = Super.SetPause(PC, CanUnpause);

	if (bReturn)
	{
		HandlePaused();

		PC.ClientPauseRumble(true);
	}

	return bReturn;
}

event ClearPause()
{
	local PlayerController PC;

	Super.ClearPause();

	HandleUnpaused();

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.ClientPauseRumble(false);
	}
}

defaultproperties
{
	DefaultPawnClass = class 'OLGame.OLHero'
	PlayerControllerClass = class 'OLGame.OLPlayerController'
	PlayerReplicationInfoClass=class'OLGame.OLPlayerReplicationInfo'
	HUDType=class'OLGame.OLHUD'

	SndPause=AkEvent'Menu.PAUSE_On'
	SndUnpause=AkEvent'Menu.PAUSE_Off'
	SndPauseNoSound=AkEvent'Menu.PAUSE_On_TOTAL'
	SndUnpauseNoSound=AkEvent'Menu.PAUSE_Off_TOTAL'
}
