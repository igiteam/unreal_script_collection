/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*
*  Manages adding appropriate crowd vehicles to nearby and vista splines
*
*/
class NanoVehiclePopulationManager extends Actor
	config(Game)
	dependson(SeqAct_GameCrowdSpawner)
	native(Vehicle);

/** Controls whether we are actively spawning agents. */
var	bool	bSpawningActive;

/** How many agents per second will be spawned at the target actor(s).  */
var	float	SpawnRate;

/** The maximum number of agents alive at one time. If agents are destroyed, more will spawn to meet this number. */
var	int		SpawnNum;

/** Number of currently spawned crowd members. */
var int     AgentCount;

/** Distance after which splines will not be considered for spawning */
var float   MaxSplineSpawnDistance;

/** How much to reduce number by in splitscreen */
var	float	SplitScreenNumReduction;

/** Radius within which not to spawn vehicles if possible in front of the player */
var float   NoSpawningRadius;

/** Archetypes of agents spawned by this crowd spawner */
var() array<AgentArchetypeInfo>	AgentArchetypes;

/** Sum of all the AgentArchetype frequencies */
var transient float ArchetypeFrequencySum;

/** List of all NanoVehicleSplines that are PotentialSpawnPoints */
var transient array<NanoVehicleSpline> PotentialSpawnSplines;

/** List of all NanoVehicleSplines, in order of priority */
var transient array<NanoVehicleSpline> PrioritizedSpawnSplines;

/** How often the spline list will be sorted for priority */
var float           SpawnSplinePrioritySortTime;
/** The last time the spline list was sorted for priority */
var transient float LastPrioritySortTime;
/** Index used to amortize the spline distance checks to one per tick.  When this is set to INDEX_None upon completion of the amortized updated, then the splines will be sorted as soon as TimeSince(LastSpawnPrioritySortTime) > SpawnPrioritySortTime */
var transient int   SplineDistanceCheckIdx;

/** Max time (in ms) that will be spent calling UpdateDistanceFromPlayer on splines each frame  */
var float           ProcessSplineTimeslice;

/** How far ahead to compute predicted player position for spawn prioritization */
var float PlayerPositionPredictionTime;

/** Temp variables used in sorting splines by priority.  Contains the predicted location and rotation of the player */
var transient vector PredictionLocation;
var transient vector PredictionRotation;

/** Pool of old agents ready to be recycled into new locations */
var protected transient array<NanoVehicleAgent>     AgentPool;

/** Maximum size of the agent pool used for recycling */
var() int   MaxAgentPoolSize;

/** Lighting channels to put the agents in. */
var LightingChannelContainer	AgentLightingChannel;

/** Whether to enable the light environment on crowd members. */
var bool	bEnableCrowdLightEnvironment;

/** Whether agents from this spawner should cast shadows */
var   bool    bCastShadows;


/** Amount of time that must pass after a chaos event to allow crowd guys that can become AI to spawn again **/
var config float TimeToStartSpawningCopCarsAfterChaosOccurs;



function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( class'Engine'.static.IsSplitScreen() )
	{
		SpawnNum = SplitScreenNumReduction * float(SpawnNum);
	}

	// Start the amortized update of the splines!
	SplineDistanceCheckIdx = 0;
}

function AddPotentialSpawnSpline( NanoVehicleSpline NewSpline )
{
	local int i;

	if( (NewSpline != None) && NewSpline.bManageTraffic )
	{
		PotentialSpawnSplines.AddItem(NewSpline);

		// Add the spline into the sorted list immediately
		UpdateSplinePriority(NewSpline);
		for( i = 0; i < PrioritizedSpawnSplines.Length; ++i )
		{
			if ( PrioritizedSpawnSplines[i].SpawnerPriority < NewSpline.SpawnerPriority )
			{
				PrioritizedSpawnSplines.InsertItem(i, NewSpline);
				break;
			}
		}
	}
}

function RemovePotentialSpawnSpline( NanoVehicleSpline RemoveSpline )
{
	if( RemoveSpline != None )
	{
		PotentialSpawnSplines.RemoveItem(RemoveSpline);
		PrioritizedSpawnSplines.RemoveItem(RemoveSpline);
	}
}

native function IncrementalUpdateSplineDistances();

function Tick( float DeltaTime )
{
	local NanoPC NPC;
	local vector ViewLocation;
	local rotator ViewRotation;
	local int RemainingAgents, SpawnIdx, BestIdx;
	local NanoVehicleAgent NVA;

	Super.Tick(DeltaTime);

	// If there are no archetypes, don't bother ticking
	if( AgentArchetypes.Length == 0 )
	{
		return;
	}

	if( SplineDistanceCheckIdx != INDEX_NONE )
	{
		IncrementalUpdateSplineDistances();
	}
	// Check to see if we need to sort the splines for priority, if the SplineDistanceCheck has updated all splines
	else if( `TimeSince(LastPrioritySortTime) >= SpawnSplinePrioritySortTime )
	{
		//FIXMEMP:  Assumes there is only one player!
		// Record properties to be used in the sort
		foreach LocalPlayerControllers(class'NanoPC', NPC)
		{
			NPC.GetPlayerViewPoint(ViewLocation, ViewRotation);
			PredictionLocation = ViewLocation + PlayerPositionPredictionTime * NPC.ViewTarget.Velocity;
			PredictionRotation = vector(ViewRotation);
			break;
		}

		// Sort the splines according to the parameters for spawning priority
 		if( PotentialSpawnSplines.Length > 1 )
 		{
 			PrioritizeSpawnSplines();
 		}

		// Record the time we sorted, so we know when to do it next
		SpawnSplinePrioritySortTime = WorldInfo.TimeSeconds;

		// Start the amortized updating of the spline positions
		SplineDistanceCheckIdx = 0;
	}
	
	if(IsSpawningActive())
	{
		// Determine how many agents are left to spawn this tick
		RemainingAgents = FCeil(SpawnRate * DeltaTime);
		while( (RemainingAgents > 0) && (AgentCount < SpawnNum) )
		{
			BestIdx = INDEX_NONE;

			for( SpawnIdx = 0; SpawnIdx < PrioritizedSpawnSplines.Length; SpawnIdx++ )
			{
				if( PrioritizedSpawnSplines[SpawnIdx].CanAcceptNewSpawnedVehicles() )
				{
					BestIdx = SpawnIdx;
					break;
				}
			}

			// If we failed to find a spline that can accept our cars, break out.
			if( BestIdx == INDEX_NONE )
			{
				break;
			}
			else
			{
				NVA = SpawnAgent( PrioritizedSpawnSplines[BestIdx] );
				if( NVA != None )
				{
					RemainingAgents--;
				}
			}
		}
	}
}

function bool IsSpawningActive()
{
	// Spawn no new vehicle agents when chaos is raised to 2 or above
	//return (NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() < 2);
	return TRUE;
}

event NanoVehicleAgent SpawnAgent(NanoVehicleSpline SpawnSpline)
{
	local NanoVehicleAgent NVA, AgentTemplate;
	local float AgentPickValue, PickSum;
	local int i;
	local SplineComponent SplineComp;



	// Initialize the archetype frequency sum, if needed
	if( ArchetypeFrequencySum == 0.f )
	{
		for ( i=0; i<AgentArchetypes.length; i++ )
		{
			if ( NanoVehicleAgent(AgentArchetypes[i].AgentArchetype) != None )
			{
				ArchetypeFrequencySum = ArchetypeFrequencySum + FMax(0.0,AgentArchetypes[i].FrequencyModifier);
			}
		}
	}

	// Try and pick an agent archetype to spawn
	AgentPickValue = ArchetypeFrequencySum * FRand();
	for ( i=0; i < AgentArchetypes.Length; i++ )
	{
		AgentTemplate = NanoVehicleAgent(AgentArchetypes[i].AgentArchetype);
		if ( AgentTemplate != None )
		{
			PickSum = PickSum + FMax(0.0,AgentArchetypes[i].FrequencyModifier);
			if ( PickSum > AgentPickValue )
			{
				// Found our template based on the random number, break out
				break;
			}
			else
			{
				AgentTemplate = None;
			}
		}
		else
		{
			`log( "FAILED TO FIND AGENT TEMPLATE!" @ `showvar(AgentTemplate) );
		}
	}	

	if( AgentTemplate == None )
	{
		return None;
	}

	// so here we need to check to see if we are allowed to add this specific agent type to the world
	if( AreWeAllowedToSpawn( AgentTemplate ) == FALSE )
	{
		return None;
	}


	// Before spawning a vehicle, see if there's one in the pool we can use to avoid the spawning overhead
	if ( AgentPool.Length > 0 )
	{
		// check for useable agent with same archetype in pool
		for ( i=0; i<AgentPool.Length; i++ )
		{
			if ( AgentPool[i].MyArchetype == AgentTemplate )
			{
				NVA = AgentPool[i];
				AgentPool.Remove(i,1);
				break;
			}
		}

		if( NVA != None )
		{
			// Bring this vehicle back from the pool, will reinitialize values, etc
			NVA.ResetPooledAgent();
		}
	}
	
	// If we weren't able to find an agent already in the pool, spawn one
	if( NVA == None )
	{
		NVA = Spawn( AgentTemplate.Class,,,vect(0,0,0), rot(0,0,0), AgentTemplate);
		NVA.MyArchetype = AgentTemplate;
		NVA.SetLighting(bEnableCrowdLightEnvironment, AgentLightingChannel, bCastShadows);
	}

	if( NVA != None )
	{
		// Add the vehicle to the spline, and make sure it has somewhere to go
		SpawnSpline.AddVehicleToSpline(NVA, SpawnSpline.GetBestLaneForVehicle());

		NVA.FillOutTargetSplines();
		NVA.MyManager = self;

		NVA.bAccelToDesiredThisTick = TRUE;

		// Try to align the vehicle to the spline path on the first tick
		SplineComp = NVA.CurrentSpline.FindSplineComponentTo(NVA.TargetSpline);
		if( SplineComp != None )
		{
			NVA.SetRotation( rotator(SplineComp.GetTangentAtDistanceAlongSpline(NVA.CurrentSplinePos)) );
		}
	}

	AgentCount++;
	return NVA;
}


/** Check to see if we turn into an AI and if enough time since chaose has ended to be allowed to spawn **/
function bool AreWeAllowedToSpawn( NanoVehicleAgent InNVA )
{
	local ChaosPacifismManager CM;


	CM = NanoGRI(WorldInfo.GRI).GetCurrentChaosManager();

	if( CM != None )
	{
		if( InNVA.bShouldSpawnAnAIWhenShot == TRUE )
		{
			// we are allowed to add here
			if( `TimeSince(CM.GetTimeChaosLevelLastIncreased()) < TimeToStartSpawningCopCarsAfterChaosOccurs )
			{
				return FALSE;
			}
		}
	}


	return TRUE;
}


/** Native function to order PotentialSpawnSplines into PrioritizedSpawnSplines */
native function PrioritizeSpawnSplines();

/** Calculates and sets the priority of a spline based on PredictionLocation and Rotation of the pawn */
native function UpdateSplinePriority(NanoVehicleSpline TestSpline);

function AgentDestroyed(NanoVehicleAgent DestroyedAgent)
{
	if( AgentPool.Length > 0 && AgentPool.Find(DestroyedAgent) == INDEX_NONE )
	{
		AgentCount--;
	}
}

function bool AddToAgentPool(NanoVehicleAgent Agent)
{
	if ( AgentPool.Length >= MaxAgentPoolSize )
	{
		if ( MaxAgentPoolSize == 0 )
		{
			return false;
		}

		//remove oldest agent
		AgentPool[0].MyManager = None;
		AgentPool[0].LifeSpan = -0.1;
		AgentPool[0].TimeSinceLastTick = 1000.0;
		AgentPool.Remove(0, 1);
	}

	AgentPool[AgentPool.Length] = Agent;

	// Allow another agent to be placed in the world
	AgentCount--;
	return true;
}

function OnNanoVehiclePopulationManagerToggle( SeqAct_NanoVehiclePopulationManagerToggle inAction)
{
	local NanoVehicleAgent Agent;
	local int i;

	if( inAction.InputLinks[0].bHasImpulse )
	{
		bSpawningActive = TRUE;

		// if wanted, clear out current list of agent archetypes
		if ( inAction.bClearOldArchetypes )
		{
			AgentArchetypes.Length = 0;
		}

		if ( inAction.CrowdAgentList != None )
		{
			// get new agent archetypes to use from kismet action
			for (i=0; i<inAction.CrowdAgentList.ListOfAgents.Length; i++ )
			{
				AgentArchetypes[AgentArchetypes.Length] = inAction.CrowdAgentList.ListOfAgents[i];
			}
		}
	}
	else if( inAction.InputLinks[1].bHasImpulse )
	{
		bSpawningActive = FALSE;
		if ( inAction.bKillAgentsInstantly )
		{
			ForEach DynamicActors(class'NanoVehicleAgent', Agent)
			{
				if ( Agent.MyManager == self )
				{
					Agent.Destroy();
				}
			}
		}
	}

	// update the properties based on the action
	SpawnNum = inAction.SpawnNum;
	bCastShadows = inAction.bCastShadows;
	bEnableCrowdLightEnvironment = inAction.bEnableCrowdLightEnvironment;
	MaxSplineSpawnDistance = inAction.MaxSplineSpawnDistance;
	NoSpawningRadius = inAction.NoSpawningRadius;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas Canvas;
	local int ActualAgentCount, VisCount, VisPathCount, LOSCount, HiddenCount;
	local NanoVehicleAgent NVA;
	local vector ViewLocation, HitLocation, HitNormal;
	local rotator ViewRotation;
	local PlayerController PC;

	Canvas = HUD.Canvas;
	
	ForEach LocalPlayerControllers(class'PlayerController', PC )
	{
		// FIXME - doesn't handle predicting position for two local players (splitscreen)
		PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
		break;
	}

	foreach AllActors(class'NanoVehicleAgent', NVA)
	{
		if( NVA.MyManager == self && !NVA.bIsInSpawnPool )
		{
			ActualAgentCount++;

			if ( (`TimeSince(NVA.LastRenderTime) < 2.0) && (NVA.LastRenderTime != NVA.InitialLastRenderTime) )
			{
				VisCount++;
			}

			if( (NVA.CurrentSpline != None && NVA.CurrentSpline.bPlayerHasLineOfSight) || (NVA.TargetSpline != None && NVA.TargetSpline.bPlayerHasLineOfSight) )
			{
				VisPathCount++;
			}

			if( PC.Trace(HitLocation, HitNormal, NVA.Location, ViewLocation, false) == None )
			{
				LOSCount++;
			}

			if( NVA.CurrentSpline != None && NVA.TargetSpline != None && !NVA.CurrentSpline.bPlayerHasLineOfSight && !NVA.TargetSpline.bPlayerHasLineOfSight )
			{
				HiddenCount++;
			}
		}
	}

	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);
	Canvas.DrawText("SplineCheck: " $ SplineDistanceCheckIdx $ " of " $ PotentialSpawnSplines.Length);

	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);
	Canvas.DrawText("AgentCount: " $ AgentCount $ " of " $ SpawnNum $ " (Actual Count: " $ ActualAgentCount $ ")");

	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);
	Canvas.DrawText("On Visible Path: " $ LOSCount $ " (" $ FCeil(100.f * LOSCount / AgentCount) $ "%)");

	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);
	Canvas.DrawText("Potentially Visible: " $ VisPathCount $ " (" $ FCeil(100.f * VisPathCount / AgentCount) $ "%)");

	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);
	Canvas.DrawText("Visible: " $ VisCount $ " (" $ FCeil(100.f * VisCount / AgentCount) $ "%)");

	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);
	Canvas.DrawText("Wandering: " $ HiddenCount $ " (" $ FCeil(100.f * HiddenCount / AgentCount) $ "%)");

	out_YPos += out_YL;
	Canvas.SetPos(4,out_YPos);
	Canvas.DrawText("AgentPool: " $ AgentPool.length $ " / " $ MaxAgentPoolSize);
}

defaultproperties
{
	AgentLightingChannel=(Crowd=TRUE,bInitialized=TRUE)
	
	bSpawningActive=TRUE
	SpawnRate=30.f
	SpawnNum=250.f

	MaxAgentPoolSize=20

	SplitScreenNumReduction=0.5

	SpawnSplinePrioritySortTime=2.5f
	PlayerPositionPredictionTime=0.1f//5.0

	ProcessSplineTimeslice=1.0

	MaxSplineSpawnDistance=25000.f

	NoSpawningRadius=6000.f
}
