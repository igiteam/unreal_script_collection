
class TPSinglePlayerGameInfo extends TPGameInfo
	native
	config(Game);

//***********************************************************************
// Struct Declarations
//***********************************************************************

/** Contains information on what teams to spawn **/
struct native TeamSpawnInfo
{
	/** TeamInfo class to spawn **/
	var class<TPTeamInfo> teamClass;
};

/** Single Player team indices - note this must be in-sync with m_teamSpawnInfo in the default section **/
enum ETPSinglePlayerTeam
{
	TPTEAM_UNKNOWN,		// = 0
	TPTEAM_ALLY,		// = 1
	TPTEAM_ENEMY,		// = 2
	TPTEAM_NEUTRAL,		// = 3
	//***ADD NEW TEAMS HERE
	//***ALSO UPDATE teamNames in SeqVar_SpTeam***

	TPTEAM_MAXIMUS		//
};


//***********************************************************************
// Variable Declarations
//***********************************************************************

var array<TeamSpawnInfo> m_teamSpawnInfo;	/** List of teams to spawn */
var array<TPTeamInfo> m_teams;	/** List of currently active teams */

var SeqAct_BarphFactory ActiveBarph;
var SeqAct_NinjaFactory ActiveNinjaFactory;
//var TPDProcessManager ActiveTPDProcessManager;
var SPDProcessManager ActiveSPDProcessManager; // problem? should be ActiveSPDProcessManager
//var TPBloodTickManager ActiveTPBloodTickManager;
//var TPFireManager ActiveFireManager;
//var TPFoodManager ActiveFoodManager;
//var TPTuneManager ActiveTuneManager;
//var TPMiniGameManager ActiveMiniGameManager;
//var DamageMatrix  ActiveDamageManager;
//var const float HitUnitsPerVelocityUnit;
//var transient TPVolumePathNodeDestructibleSpawner	TPVolumePathNodeDestructibleSpawnerList;
var const float HitUnitsPerVelocityUnit;

//***********************************************************************
// CPP Text
//***********************************************************************

//***********************************************************************
// Native Function Declarations
//***********************************************************************

//***********************************************************************
// Functions/States
//***********************************************************************


//-----------------------------------------------------------------------
// Function:
// Description:	Handles creating the default teams.
//-----------------------------------------------------------------------
final function InitializeTeams()
{
	local int idx;
	local ETPSinglePlayerTeam maxIdx;

	maxIdx = TPTEAM_MAXIMUS;
	if (m_teamSpawnInfo.Length != maxIdx)
	{
		;
	}

	// initialize all the teams
	for (idx = 0; idx < m_teamSpawnInfo.Length; idx++)
	{
		m_teams[idx] = Spawn(m_teamSpawnInfo[idx].teamClass,self);
		m_teams[idx].TeamIndex = idx;
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Handles moving players from one team to another, or for the initial
//				team assignment.
//
//				@return true if the team change was successful
//-----------------------------------------------------------------------
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	local int squadNameIdx;
	local TPPawn spPawn;
	local TPPlayerReplicationInfo spPRI;
	local ETPSinglePlayerTeam teamIdx;


	// check to see if we need to initialize teams
	if (m_teams.Length < m_teamSpawnInfo.Length)
	{
		InitializeTeams();
	}

	if (Other != None)
	{
		teamIdx = TPTEAM_UNKNOWN;
		spPawn = TPPawn(Other.Pawn);
		if (Other.Pawn != None)
		{
			if (spPawn != None)
			{
				if( bNewTeam )
					teamIdx = ETPSinglePlayerTeam(N);
				else
					teamIdx = spPawn.TeamAssignment;
			}

			//if (teamIdx == TPTEAM_UNKNOWN)
			//{
			//	`log("***ERROR TPSinglePlayerGameInfo:: Unable to determine team for "@Other.Pawn.GetDebugName()@" pawn!!!");
			//}
		}
		else if (Other.IsA('TPPlayerController'))
		{
             //Hack: Players are automatically allies!
             teamIdx = TPTEAM_ALLY;
        }

		//if (teamIdx==TPTEAM_UNKNOWN)
		//{
		//	`log("***ERROR TPSinglePlayerGameInfo:: Unable to determine team for "@Other.GetDebugName()@" controller!!!");
		//}



		// if not already on that team
		if (Other.PlayerReplicationInfo.Team == None ||
			Other.PlayerReplicationInfo.Team != m_teams[teamIdx])
		{
			// remove from their current team
			if (Other.PlayerReplicationInfo.Team != None)
			{
				Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
			}

			spPRI = TPPlayerReplicationInfo(Other.PlayerReplicationInfo);
			if (spPRI != None)
			{
				if (spPawn != None)
				{
					squadNameIdx = spPawn.GetSquadNameIndex();
					spPRI.SquadNameAssignment = m_teams[teamIdx].GetPreDefinedSquadName(squadNameIdx);
				}
				//spPRI.SquadNameAssignment = spPawn.SquadNameAssignment;
			}
			// and attempt to add them to their new team
			return m_teams[teamIdx].AddToTeam(Other);
		}
		else
		{
			return true;
		}
	}
	return false;
}

function Controller GetController(Pawn Target)
{
	if (Target == None)
		return None;
	if (Target.Controller != None)
		return Target.Controller;
	else if (Target.DrivenVehicle != None)
		return Target.DrivenVehicle.Controller;
	else
		return None;
}

//-----------------------------------------------------------------------
// Function:
// Description:	Overridden to prevent friendly fire damage.
//-----------------------------------------------------------------------
// TO C++
function ReduceDamage( out int Damage, pawn injured, Controller instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local int idx;
	local bool doNoDamage;
	local TPPawn sp;
	local Controller injuredController;
	local TPAIController spc;

	doNoDamage=false;
	sp = TPPawn(injured);
	injuredController = GetController(injured);
	if (sp != None && TPAIController(injuredController) != None)
	{
		spc = TPAIController(injuredController);

		// don't do damage if it is friendly fire or the injured guy isn't targettable
		doNoDamage = spc.IsFriendly(instigatedBy);
		if (!doNoDamage && TPAIController(instigatedBy) != None)
		{
			doNoDamage = !TPAIController(instigatedBy).IsTargettable(spc);
		}
	}


	if (injured != None &&
		instigatedBy != None &&
		instigatedBy.Pawn  != None && 
		(doNoDamage || ( WorldInfo.GRI.OnSameTeam(injured.Controller,instigatedBy) && (injured != instigatedBy.Pawn ) ) ) )
	{
		//`log(" ChadAI - " @ Self @ " Single Player ReduceDamage doNoDamage: " @ doNoDamage @ " Same Team : "@ WorldInfo.GRI.OnSameTeam(injured.Controller,instigatedBy) @" *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		Damage = 0;
	}
	else
	{
		for (idx = 0; idx < m_teams.Length; idx++)
		{
			m_teams[idx].NotifyTakeDamage(injured.Controller,instigatedBy);
		}
		Super.ReduceDamage(Damage,injured,instigatedBy,HitLocation,Momentum,damageType);
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:	Overridden to notify teams of the death for the purposes of morale tracking.
//-----------------------------------------------------------------------
function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn )
{
	local int idx;
	for (idx = 0; idx < m_teams.Length; idx++)
	{
		if (m_teams[idx] != None)
		{
			m_teams[idx].NotifyKilled(Killer,Killed,KilledPawn);
		}
	}
	Super.NotifyKilled(Killer,Killed,KilledPawn);
}

//-----------------------------------------------------------------------
// State:
// Description:
//-----------------------------------------------------------------------
event class<DamageType>	GetRigidBodyDamageType()
{
	return class'TPDamageTypeRigidBody';
}

function Pawn SpawnDefaultPawnAt(Controller NewPlayer, Vector StartLoc, Rotator StartRot)
{
	local class<Pawn> DefaultPlayerClass;
	local Rotator StartRotation;
	local Pawn ResultPawn;

	DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);

	// don't allow pawn to be spawned with any pitch or roll
	StartRotation.Yaw = StartRot.Yaw;

	ResultPawn = Spawn(DefaultPlayerClass,,,StartLoc,StartRotation);
	if ( ResultPawn == None )
	{
		;
	}
	return ResultPawn;
}

//
// Restart a player - lifted from GameInfo.uc so we can respawn in single player games.
//
function RestartPlayer(Controller NewPlayer)
{
	local NavigationPoint startSpot;
	local int TeamNum, Idx;
	local array<SequenceObject> Events;
	local SeqEvent_PlayerSpawned SpawnedEvent;
	
	local TPPlayerController TPPC;
	local TPCheckpointManager TPCM;

	;
	// figure out the team number and find the start spot
	TeamNum = ((NewPlayer.PlayerReplicationInfo == None) || (NewPlayer.PlayerReplicationInfo.Team == None)) ? 255 : NewPlayer.PlayerReplicationInfo.Team.TeamIndex;
	StartSpot = FindPlayerStart(NewPlayer, TeamNum);
	TPPC = TPPlayerController(NewPlayer);
	if (TPPC != None)
		TPPC.m_bPendingTransition = TRUE;

	// if a start spot wasn't found,
	if (startSpot == None)
	{
		// Try grabbing the location from the current checkpoint (if any)...
		if (TPPC != None)
		{
			TPCM = TPPC.TPCM;
			if (TPCM != None)
			{
				if (TPCM.CurrCheckpoint != None)
				{		
					//`Log("I'm using the checkpoint!");
					NewPlayer.Pawn = SpawnDefaultPawnAt(NewPlayer, TPCM.CurrCheckpoint.Location,
						TPCM.CurrCheckpoint.Rotation);
				}
			}
		}

		if (NewPlayer.Pawn == None)
		{
			// check for a previously assigned spot
			if (NewPlayer.StartSpot != None)
			{
				StartSpot = NewPlayer.StartSpot;
				;
			}
			else
			{
				// otherwise abort
				;
				return;
			}
		}
	}
	// try to create a pawn to use of the default class for this player
	if (NewPlayer.Pawn == None)
	{
		NewPlayer.Pawn = SpawnDefaultPawnFor(NewPlayer, StartSpot);
	}
	if (NewPlayer.Pawn == None)
	{
		;
		NewPlayer.GotoState('Dead');
		if ( PlayerController(NewPlayer) != None )
		{
			PlayerController(NewPlayer).ClientGotoState('Dead','Begin');
		}
	}
	else
	{
		if ( PlayerController(NewPlayer) != None )
		{
			PlayerController(NewPlayer).TimeMargin = -0.1;
		}
		// initialize and start it up
		NewPlayer.Pawn.SetAnchor(startSpot);
		NewPlayer.Pawn.LastStartSpot = PlayerStart(startSpot);
		NewPlayer.Pawn.LastStartTime = WorldInfo.TimeSeconds;
		NewPlayer.Possess(NewPlayer.Pawn, false);
		NewPlayer.Pawn.PlayTeleportEffect(true, true);
		NewPlayer.ClientSetRotation(NewPlayer.Pawn.Rotation);

		if (!WorldInfo.bNoDefaultInventoryForPlayer)
		{
			AddDefaultInventory(NewPlayer.Pawn);
		}
		SetPlayerDefaults(NewPlayer.Pawn);

		// activate spawned events
		if (WorldInfo.GetGameSequence() != None)
		{
			WorldInfo.GetGameSequence().FindSeqObjectsByClass(class'SeqEvent_PlayerSpawned',TRUE,Events);
			for (Idx = 0; Idx < Events.Length; Idx++)
			{
				SpawnedEvent = SeqEvent_PlayerSpawned(Events[Idx]);
				if (SpawnedEvent != None &&
					SpawnedEvent.CheckActivate(NewPlayer,NewPlayer))
				{
					SpawnedEvent.SpawnPoint = startSpot;
					SpawnedEvent.PopulateLinkedVariableValues();
				}
			}
		}
	}
}

// Shut off Active BarphFactory before unloading map
function DeactivateBARPH()
{
	if(ActiveBarph != none)
	{
        ;
        ActiveBarph.bIsSpawning = FALSE;
        ActiveBarph = none;
	}
	
}

//***********************************************************************
// Default Properties
//***********************************************************************
