//  pacman:   draw min radius 
//                 confront icon
//                 red / blue flashing
//                 dudes inside it don't draw their circles
//                    outside do draw them!
//            don't update the location of the pacman if they enemy sees you inside the min radius
//



/**
 * So for the procedural enemy spawning we want to do the following:
 * 
 * -have an amorphous set of guys that are the set of things we "fight against" that is semi uniform around the world
 * 
 * -have a method for HOW the enemies are spawned into the world
 *     -springer, spawn location (police station), drop pod / one time jet packing, crowd member transform, spawn around corner out of sight
 *     
 * -have a way for the LD to "influence" what is spawned
 *     -there will be specific places in the map which will specify what types of enemies spawn 
 *       ->this helps add flavor to the world.  so you can say:  near the bullet proof vest factory we spawn more bullet proof guys, there 
 *         is a captain that is a real jerk over by the cafe, bull rams spawn more up near the robotics factory, etc.
 *         
 *         
 * -have encounters of guys ( 2 riot cops and a captain, bull ram contingent, etc. ) (things the player will recognize and go: "AHH!" )
 * 
 * -ability to know where a guy was spawned from so we can send events to kismet (e.g. all dead / all alive)
 * 
 * todo:
 *   -have an ability to lock certain things out per district (e.g. you destroy the robotics lab so no more bull rams)
 * 
 * 
 * 
 * director:  skinner's law of reinforcment
 * 
 * 
 * To Debug the "path finding":  set bool on navigationhandle 'bultraverbosepathdebugging' or just look at an AI and type 'verbosepathdebugging'
 * 
 * 
 * TODO:  we should be able to templatize our pathfinding constraints
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProceduralEnemySpawner extends NanoProceduralEnemySpawnerBase
    dependson( SeqAct_AIFactory, NanoProceduralEnemySpawnPoint )
	config(Game);



enum EEnemySpawnMethod
{
    ESM_SpawnAroundCornerOutOfSight, // keep as 0 so this is the default method
	ESM_CrowdMemberTransformation,
	ESM_DropInFromAir,
	ESM_SpecificSpawnLocation,
    ESM_Springer,
	ESM_FlyingCar,
	ESM_Rooftop,
	ESM_NanoDefensivePoint,
	ESM_Cloud,
};

/** Allows us to manage how many enemies are spawned at each tier **/
struct ChaosTierSpawnDatum
{
	/** This is the number of points available at this chaos tier for spawning cloud enemies **/
	var int NumCloudPointsAvail;

	/** 
	 *  We might have N points but this is the max number of enemies we should have out and about.
	 * This is both for performance reasons and also for general does it look ok to have 4 pacbots out?  
	 *  
	 **/
	var int MaxNumEnemies;

	/** This is the "ConfrontRadius" for this chaos level. **/
	var float HotZoneRadius;

	var() float Cloud_MinSpawnDistance;
	var() float Cloud_MaxSpawnDistance;

	var() float Cloud_MinSpawnDistance_Rooftops;
	var() float Cloud_MaxSpawnDistance_Rooftops;

	var() float Cloud_MinSpawnDistanceWhenEscaping;
	var() float Cloud_HardLimitOnPathDistance;
	var() float Cloud_PacManEpsilon;
	var() float Cloud_MinDistanceToAnotherAI;

	////

	/** Number of guys we should spawn right off the bat for the "alert" cloud spawning. **/
	var int BurstSpawnAmount;

	/** Once we are trickling in foes, this is how often we spawn them. **/
	var float TimeBetweenSpawnsInSeconds;

	/** Every time we kill a foe this is how long we add to the "until next foe spawns" **/
	var float PenaltyForEveryAIKilledInSeconds;

	/** 
	 * This is the max penalty that one can get for killing foes off.  Basically we want a foe guaranteed to spawn within this much time
	 * after doing a mass killing.
	 **/
	var float MaxSpawnDelayAllowed;

	/** Where 0 is no rooftop spawning and 1 makes them spawn on rooftops the same as they would at street level. Take the # of guys you are able to spawn and do this as a percentage. **/
	var float PercentOfMaxEnemiesAllowedToSpawnFromRooftops;

	/** This is the percent to do multiple DoCullFurthestCloudAI which will allow respawning of them **/
	var float PercentToDoAnAdditionalCullFurthestCloudAI;

	// some other meta infoz?
};

var const config array<ChaosTierSpawnDatum> ChaosTierSpawnData;



struct EnemySpawnDatum
{
	/** enemy type to spawn (All types in the game must be represented in a way we can access them in Kismet) **/
	var name EnemyType;

	/** When this enemy type will start showing up. **/
	var int MinChaosTier;
	/** When this enemy type will stop showing up. **/
	var int MaxChaosTier;

	/** Minimum amount of this enemy we should try to keep around. (e.g. there will always be one riot cop around) **/
	var int MinCount;
	/** Maximum amount of this enemy we can have around at once.  (e.g. we can only afford (perf) to have one of this type out, or only one of this type is fun at a time) **/
	var int MaxCount;

	/** Sometimes there is only 1 token avail and N classes that each take 1 token.  So this allows to make certain at least the highest priority gets spawned **/
	var int Priority;

	/** Cost of this enemy type **/
	var int Cost;

	/** This will make this enemy type forcibly spawn even if there are not enough resources.  (e.g. good for pacbots) **/
	var bool bForceSpawn;

	/** If this is not allowed to spawn at defensive points.  Example: cop cars or tattlers should not spawn as they are roving **/
	var bool bDoNotSpawnAtDefensivePoints;

	/** 
	 * Every chaos tier change we "roll" a die to figure out the current percentage.  Then we compare this against that to see
	 * if this is allowed to spawn that tier.  So that allows us to do:  hey every chaos tier 5 we have a 10% to spawn this crazy guy
	 **/
	var float PercentageToSpawn;

	/** Whether or not this entry is a rebel **/
	var bool bIsRebel;

	/** If we are a rebel this is the RebelMindShare we need to have to spawn **/
	var float PercentOfMaxRebelMindShareNeededToSpawn;

	/** Whether or not this entity can be spawned during normal game play or whether it must be only spawned during initial spawn **/
	var bool bSpawnOnlyDuringInitialSpawn;

	/** We need some way to only give us a bunch of rebels when we first get to a tier **/
	var transient float TestDelay;

	/** 
	 * So sometimes we get into a state where the AI can't spawn for some reason.  So when an AI that is high priority to spawn
	 * gets into this state then we stall everything.
	 **/
	var transient float DelayTime[EEnemySpawnMethod.EnumCount];
};

var config array<EnemySpawnDatum> EnemySpawnData;

/** The amount we are going to add when an AI can not spawn for some reason to allow the world state to change enough to spawn him (hopefully) **/
var float SpawnDelayTimeAmount;


/** A group of enemies defined in EnemyList that may spawn as a group **/
struct EnemySquadDatum
{
	/** Name of the squad **/
	var name SquadName;

	/** List of AITypes that are in this squad.  Makes it much easier to maintain. **/
	var array<name> Enemies;


	//// these are dynamically filled in via introspection on the Enemies list

	/** When this enemy type will start showing up. **/
	var transient int MinChaosTier;
	/** When this enemy type will stop showing up. **/
	var transient int MaxChaosTier;

	/** Total cost of this squad. (This is calculated in PostBeginPlay for all of these structs) **/
	var transient int Cost;

	
	/** 
	 * Every chaos tier change we "roll" a die to figure out the current percentage.  Then we compare this against that to see
	 * if this is allowed to spawn that tier.  So that allows us to do:  hey every chaos tier 5 we have a 10% to spawn this crazy guy
	 **/
	var float PercentageToSpawn;

};

var config array<EnemySquadDatum> EnemySquadData;


// the above vars are all of the data for the things we spawn

/** The procedural spawning gets turned on by a kismet action.  So we are not spawning all the time in every map. **/
var transient bool bActive;

/** Whether or not to do NPES logs **/
var config bool bNPESLogging;

/** Needed to allow the NPES to use the navmesh to pathfind **/
var transient NanoNavigationHandle MyNavigationHandle;


/** When to update so we are not constantly updating which will probably get expensive **/
var config float TimeBetweenEnemyManagementTicks;
var transient float TimeToDoEnemyManagement;

/** How long between crowd member spawns. **/
var config float TimeBetweenCrowdMemberSpawns;
var transient float TimeToDoCrowdMemberSpawns;

/** How long between spawn point spawns. **/
var config float TimeBetweenSpawnPointSpawns;
var transient float TimeToDoSpawnPointSpawns;

/** How long between squad spawns. **/
var config float TimeBetweenSquadSpawns;
var transient float TimeToDoSquadSpawns;

/** How often the cloud is allowed to spawn guys  **/
var transient float TimeToDoCloudManagement;



/** Cached version of what ChaosTier it is. **/
var transient int CurrChaosTier;

/** How many points we can spend at this level and how many points we have currently avail to spend **/
var transient int MaxPointsAvail;
var transient int CurrPointsSpent;

/** How many points / enemies avail **/
var transient int CloudBurstEnemies;
var transient int CloudBurstPoints;

/** How many enemies we can have out at this level and how many enemies we have currently avail spawn **/
var transient int MaxNumEnemies;
var transient int CurrNumEnemies;


/** How many enemies we have spawned at Defensive Points **/
var transient int CurrNumEnemiesAtDefensivePoints;



/** Struct that holds all of the data about an alive enemy **/
struct AliveEnemyDatum
{
	var name PawnClassName;
	var int NumAlive;
	var float LastSummonTime;
};

var transient array<AliveEnemyDatum> EnemiesAlive;


/** How far around the player location to search for spawn points **/
var config float RadiusToSearchAroundPlayerForSpawnPoints;

/** Tattlers are they eyes and ears of MetaCorp, so for things to spawn Tattlers need to be near lyrik and alert **/
var config float DistanceTattlersAreFromPlayerForSpawningToOccur;

/** If you ever get this far away form the AI in the level they will be killed off.  And then new AI will spawn **/
var config float KillAIOffDistance;

/** Duration to be outside of the red circle to reset chaos **/
var config float DurationOutsideOfHotZoneToResetChaos;

/** Radius To Find Crowd Members To Turn Into AI when chaos is triggered **/
var float RadiusToFindCrowdMembersToTurnIntoAI;

/** Whether or not the normal EnemyManagement needs to have a tattler seeing the player character do "bad things" **/
var() bool bDoEnemyManagementRequireTattlerSight;

/** Whether or not to try and spawn foes around the player **/
var() bool bDoEnemyManagement;

/** Whether or not to attempt to find defensive points to spawn foes at **/
var() bool bDoEnemyManagement_DefensivePoints;

/** Whether or not to spawn enemies on the rooftops. **/
var() bool bDoEnemyManagement_Rooftops;

/** Whether or not to do the enemy clean up (e.g. if distance > N OR not rendered in N )**/
var() bool bDoEnemyCleanUp;


/** Location of the pacman center **/
var transient vector Cloud_PacManCenter;
var transient HotZoneCenter TheHotZoneCenter;
/** The rotation / orientation of the pacman "clear tunnel" **/
var transient rotator Cloud_PacManOrientation;


var config float PoliceCar_SpawnDistance_Min;
var config float PoliceCar_SpawnDistance_Max;

/** If the AI is further than this then just add them to the cull list**/
var config float DoCullFurthestCloudAI_AutoAddToCullList;

/** if an AI is further away than this, cull them as they are never going to catch the Player **/
var config float DoCullFurthestCloudAI_AutoCullDist;


/** This is the current tier percentage which we will compare our indiv spawn types against to see if they can spawn. **/
var privatewrite transient float CurrTierPercentage;


var privatewrite transient bool bMobileUserRespondedWithHelp;

var privatewrite transient name MobileReponseType_Override;
var privatewrite transient string MobileReponseType_Color;


// Mobile Request Sounds
var SoundCue MobileRequest_Request_Normal;
var SoundCue MobileRequest_Confirm_Normal;

var SoundCue MobileRequest_Request_Urgent;
var SoundCue MobileRequest_Confirm_Urgent;

var SoundCue MobileRequest_RebelsAppearInWorld;



simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	//bActive = TRUE;

	`NPESLog( "ChaosTierSpawnData" @ `showvar(ChaosTierSpawnData.Length) );
	`NPESLog( "EnemySpawnData" @ `showvar(EnemySpawnData.Length) );
	`NPESLog( "EnemySquadData" @ `showvar(EnemySquadData.Length) );


	//`log( `showvar(ChaosTierSpawnData[0].MaxNumEnemies) );
	//`log( `showvar(ChaosTierSpawnData[1].MaxNumEnemies) );
	//`log( `showvar(ChaosTierSpawnData[2]) );


    MyNavigationHandle = new(self) class'NanoNavigationHandle';

	// update transient data in the various spawn lists
	InitSquadTransientData();
	InitEnemiesAlive();

	TimeToDoEnemyManagement = WorldInfo.TimeSeconds + TimeBetweenEnemyManagementTicks;
	TimeToDoCloudManagement = 0;
	NotifyChaosTierChange( 0 );

	TheHotZoneCenter = Spawn( class'HotZoneCenter', self,,,,, TRUE );

	// start up our polling the DB for values! ( maybe only do this when chaos is up)
	SetTimer( 1.0f, TRUE, nameof(PollForValueFromDB_MobileResponse) );

}


event Destroyed()
{
	Super.Destroyed();

	TheHotZoneCenter.Destroy();
}


function Tick( float DeltaTime )
{
	local int PreCurrPointsSpent;
	local int DeltaCurrPointsSpent;
	local int InifLoopLimiter;


	Super.Tick( DeltaTime );


	// hack for render thread stalling at start up in StreetCred_p
	if( WorldInfo.TimeSeconds < 10.0f )
	{
		return;
	}

	// only do this every N seconds
	if( ( bActive == TRUE )
		&& ( TimeToDoEnemyManagement < WorldInfo.TimeSeconds )
		)
	{

		DoTattlerSpawning();

		//`log( "OH " @ `showvar(TimeToDoCloudManagement) @ TimeToDoCloudManagement < WorldInfo.TimeSeconds @ `showvar(CloudBurstPoints) @ `showvar(WorldInfo.TimeSeconds) );

		if( ( bDoEnemyManagement == TRUE )
			&& ( (NanoGRI(WorldInfo.GRI).NPES.TimeToDoCloudManagement - WorldInfo.TimeSeconds) < 0.0f )
			&& ( AllowedToDoCloudSpawningWithNDPUnderAttack() == TRUE )
			)
		{
			DoCullFurthestCloudAI();
			// so on higher chaos tiers we will have a chance to do this more than once so you get 2 guys spawned near you
			if( FRand() > ChaosTierSpawnData[CurrChaosTier].PercentToDoAnAdditionalCullFurthestCloudAI )
			{
				DoCullFurthestCloudAI();
			}


			// need to do at least some here to get non bursties
			if( CloudBurstPoints == 0 )
			{
				DoEnemyManagement();
			}

			while( ( CloudBurstPoints > 0 ) && ( InifLoopLimiter++ < 10 ) )
			{
				//`log( "spending those" @ `showvar(CloudBurstPoints) );

				PreCurrPointsSpent = CurrPointsSpent;

				DoEnemyManagement();

				DeltaCurrPointsSpent = CurrPointsSpent - PreCurrPointsSpent;

				CloudBurstPoints -= DeltaCurrPointsSpent;
			}

			DetermineCloudPointsAvail();
		}


		// any riot trooper that can see you should turn into an AI and attack you
		// if you shoot a riot trooper guy then chaos goes up
		// 

		if( bDoEnemyManagement_DefensivePoints == TRUE )
		{
			DoEnemyManagement_DefensivePoints();
		}

		if( bDoEnemyManagement_Rooftops == TRUE )
		{
			DoEnemyManagement_Rooftops();
		}

		if( bDoEnemyCleanUp == TRUE )
		{
			DoEnemyCleanUp();
		}

		TimeToDoEnemyManagement = WorldInfo.TimeSeconds + TimeBetweenEnemyManagementTicks;
		//Debug_LogEnemiesAlive();
	}
}


function InitSquadTransientData()
{
    local int idx;
    //local EnemySquadDatum ESD;
	local name EnemyID;

	for( idx = 0; idx < EnemySquadData.Length; ++idx )
	//foreach EnemySquadData( ESD ) // this makes a copy and not a reference
	{
	    foreach EnemySquadData[idx].Enemies( EnemyID )
		{
			EnemySquadData[idx].Cost += GetEnemySpawnDatum(EnemyID).Cost;
			//`NPESLog( EnemySquadData[idx].SquadName @ EnemySquadData[idx].Cost @ GetEnemySpawnDatum(EnemyID).Cost );

			EnemySquadData[idx].MinChaosTier = Max( EnemySquadData[idx].MinChaosTier, GetEnemySpawnDatum(EnemyID).MinChaosTier );
			EnemySquadData[idx].MaxChaosTier = Max( EnemySquadData[idx].MaxChaosTier, GetEnemySpawnDatum(EnemyID).MaxChaosTier );
		}
	}

	//foreach EnemySquadData( ESD )
	//{
	//	`NPESLog( ESD.SquadName @ ESD.Cost );
	//}
}


function InitEnemiesAlive()
{
    local int idx;
    local EnemySpawnDatum ESD;
	//local AliveEnemyDatum ASD;

	EnemiesAlive.Length = EnemySpawnData.Length;

	foreach EnemySpawnData( ESD ) // this makes a copy and not a reference
	{
	    EnemiesAlive[idx].PawnClassName = ESD.EnemyType;

		idx++;
	}

	//foreach EnemiesAlive( ASD )
	//{
	//	`NPESLog( ASD.PawnClassName );
	//}
}



function AddCloudBurstPoints( int InNumPoints )
{
	`NPESLog( "AddCloudBurstPoints adding" @ InNumPoints );
	CloudBurstPoints += InNumPoints;
}


final function DetermineCloudPointsAvail()
{
//	if( ( ( CurrNumEnemies < MaxNumEnemies ) && ( CurrPointsSpent < MaxPointsAvail ) )
//		&& ( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
//		)
//	{
//		CloudBurstPoints += 1;
//	}
	
	// set the next time we get to cloud spawn
	TimeToDoCloudManagement = WorldInfo.TimeSeconds + ChaosTierSpawnData[CurrChaosTier].TimeBetweenSpawnsInSeconds;

}



/** debug function to help deal with the insanity of ints/enums/class names **/
function Debug_LogEnemiesAlive()
{
	local AliveEnemyDatum AED;

	`NPESLog( "Debug_LogEnemiesAlive" );

	foreach EnemiesAlive( AED )
	{
		`NPESLog( "  " @ AED.PawnClassName @ AED.NumAlive @ AED.LastSummonTime );
	}
}


/** When the chaos tier changes we need to update our pts totals and such.  And then over time we will adjust our enemies up/down to match that number. **/
function NotifyChaosTierChange( int NewChaosTier )
{
	`NPESLog( "NotifyChaosTierChange" @ NewChaosTier );
	CurrChaosTier = NewChaosTier;
    MaxPointsAvail = ChaosTierSpawnData[NewChaosTier].NumCloudPointsAvail;
    MaxNumEnemies = ChaosTierSpawnData[NewChaosTier].MaxNumEnemies;

	// on tier change reset the "I have killed a bunch of guys give me some breathing room" 
	TimeToDoCloudManagement = 0.0f;

	`Log( "NotifyChaosTierChange" @ NewChaosTier @ `showvar(MaxNumEnemies) );

	// so now since we have had a Chaos Tier Change we need to go and look for AliveEnemies and see if they are valid to be around
	// if they are not then we need to send them home
	PossiblySendAIsHomeDueChaosTierChange();

	CurrTierPercentage = FRand();
}


/** 
 *  So we need to be notified when an AI actually spawns and then we update our internal tracking structures.
 **/
function NotifyANewAIHasSpawned( const NanoAIBase InAI )
{
	local int AliveEnemiesIdx;
	local EnemySpawnDatum ESD;

	`NPESLog( "NotifyANewAIHasSpawned" @ InAI @ InAI.Pawn.Class.Name );

	AliveEnemiesIdx = GetSpawnInfoIndex( InAI.Pawn.Class.Name );

	if( AliveEnemiesIdx != INDEX_NONE )
	{
		EnemiesAlive[AliveEnemiesIdx].PawnClassName = InAI.Pawn.Class.Name;
		EnemiesAlive[AliveEnemiesIdx].NumAlive++;
		EnemiesAlive[AliveEnemiesIdx].LastSummonTime = WorldInfo.TimeSeconds;
	}
	else
	{
		`warn( "NPES is spawning an enemy type is unknown to it" @ `showvar(InAI) );
	}


	NanoGRI(WorldInfo.GRI).NPMM.NotifyANewAIHasSpawned( InAI );

	// we don't count SentryBots in our number of alive enemies
	if( NanoAI_SentryBot(InAI) != none )
	{
		return;
	}

	// only response cloud spawns should cost us points
	if( InAI.bSpawnedIntoTheResponseCloud == TRUE )
	{
		// modify points
		ESD = GetEnemySpawnDatum( InAI.Pawn.Class.Name );

		if( ESD.bIsRebel == FALSE )
		{
			CurrPointsSpent += ESD.Cost;
		}
	}


	CurrNumEnemies++;
	//ScriptTrace();
	//`log( `showvar(CurrNumEnemies) );

}


/** 
 *  So we need to be notified when an AI actually dies and then we update our internal tracking structures.
 **/
function NotifyANewAIHasDied( const NanoAIBase InAI, class<DamageType> DamageType )
{
	local int AliveEnemiesIdx;
	local EnemySpawnDatum ESD;
	local int SpawnModIdx;

	// something bad has occurred
	if( InAI == none )
	{
		return;
	}

	`NPESLog( "NotifyANewAIHasDied" @ InAI @ InAI.Pawn.Class.Name );


	if( InAI.bInitialSpawnOnRooftops == TRUE )
	{
		NanoGRI(WorldInfo.GRI).AIBlackboard.NumSpawnedFromRooftops--;
	}

	// only response cloud spawns should cost us points
	if( InAI.bSpawnedIntoTheResponseCloud == TRUE )
	{
		// modify points
		ESD = GetEnemySpawnDatum( InAI.Pawn.Class.Name );
		if( ESD.bIsRebel == FALSE )
		{
			CurrPointsSpent -= ESD.Cost;
		}

		// rebel has died
		if( ESD.bIsRebel == TRUE )
		{
			ESD.DelayTime[ESM_Cloud] = WorldInfo.TimeSeconds + 60.0f; // don't get to spawn for 60 seconds
		}
	}


	CurrNumEnemies--;

	AliveEnemiesIdx = GetSpawnInfoIndex( InAI.Pawn.Class.Name );

	`NPESLog( "  PRE" @ InAI @ `showvar(EnemiesAlive[AliveEnemiesIdx].NumAlive) );
    EnemiesAlive[AliveEnemiesIdx].NumAlive--;
	`NPESLog( "  POST" @ InAI @ `showvar(EnemiesAlive[AliveEnemiesIdx].NumAlive) );

	NanoGRI(WorldInfo.GRI).NPMM.NotifyANewAIHasDied( InAI, DamageType );

	if( class'NDT_KilledByProceduralSpawner' != DamageType )
	{
		// set the next time we get to cloud spawn
		TimeToDoCloudManagement += ChaosTierSpawnData[CurrChaosTier].PenaltyForEveryAIKilledInSeconds;

		TimeToDoCloudManagement = Clamp( TimeToDoCloudManagement, WorldInfo.TimeSeconds, WorldInfo.TimeSeconds+ChaosTierSpawnData[CurrChaosTier].MaxSpawnDelayAllowed );
	}


	if( ( ClassIsChildOf( class'NDT_KilledByProceduralSpawner', DamageType) == TRUE ) && ( InAI.bInitialSpawnOnDefensivePoint == TRUE ) )
	{
		`NPESLog( "AI has died. by NDT_KilledByProceduralSpawner We don't want to actually take away points from initial spawn" );
		`NPESLog( `showvar(InAI) @ `showvar(InAI.HACK_CurrNanoDefensivePoint) @ `showvar(InAI.bInitialSpawnOnDefensivePoint) );
		//ScriptTrace();

		InAI.HACK_CurrNanoDefensivePoint.NumPointsForInitialSpawn++;
		InAI.HACK_CurrNanoDefensivePoint.NumPointsToSpendToDefend++;  // look up the cost of this guy 

		// okie need to check here to see if we spawned from our NDEP list and update the spawn count
		for( SpawnModIdx = 0; SpawnModIdx < InAI.HACK_CurrNanoDefensivePoint.DenfensivePointSpawnModifiers.Length; ++SpawnModIdx )
		{
			`NPESLog( `showvar(InAI.Pawn.Class.Name) );

			if( InAI.HACK_CurrNanoDefensivePoint.DenfensivePointSpawnModifiers[SpawnModIdx].EnemyType.Name == InAI.Pawn.Class.Name )
			{
				//`NPESLog( "ZOOOOOOOOOP" );
				InAI.HACK_CurrNanoDefensivePoint.DenfensivePointSpawnModifiers[SpawnModIdx].NumberSpawned--;
				break;
			}
		}

		`NPESLog( `showvar(InAI) @ `showvar(InAI.HACK_CurrNanoDefensivePoint) @ `showvar(InAI.HACK_CurrNanoDefensivePoint.NumPointsForInitialSpawn) @ `showvar(InAI.HACK_CurrNanoDefensivePoint.NumPointsToSpendToDefend) );

	}
}





final function bool AllowedToDoCloudSpawningWithNDPUnderAttack()
{
//	local vector PlayerLocation;
	local NanoDefensivePoint Pt;

	//FIXMEMP:  Assumes there is only one player!
	// find player
//	PlayerLocation = NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location;

	// for all defensive points (YIKES)
	foreach AllActors( class'NanoDefensivePoint', Pt )
	{
		if( Pt.bIsActive == FALSE )
		{
			continue;
		}

		if( Pt.IsCloudSpawningAllowed() == FALSE )
		{
			`NPESLog( GetFuncName() @ `showvar(pt) @ "Disallowing Cloud spawning!" );
			return FALSE;
		}
	}


	// if no, allowed to cloud spawn
	return TRUE;
}

/** 
 * Will spawn an AI and penalize it if it can not be spawned
 **/
function NanoAI SpawnAIType( name InEnemyType, const EEnemySpawnMethod InSpawnMethod, optional bool bResponseCloud, optional vector InSpawnLocationOverride, optional NanoDefensivePoint NDP )
{
	local EEnemySpawnMethod SpawnMethod;
	local class<NanoPawnBase> NanoPawnClass;
	local NanoPawnBase NewEnemy;
	local NanoAI AI;
	local Vector SpawnLocation;
	local bool bRooftopSentinel;

	// we need to save off the original SpawnMethod as this is what was originally used to in IsValid<type> to look up the class
	// some of the specific classes (e.g. flying things) will choose a different spawn method
	// but that spawn method is not known to the original Do<Type>Spawning (e.g. DoRooftopSpawning so ModifyDelayTimeOnEnemySpawnData
	// needs to use the Original passed in SpawnMethod
	SpawnMethod = InSpawnMethod; 


	NanoPawnClass = CreateNanoPawnClass( InEnemyType );
    if( NanoPawnClass == none )
    {
		`NPESLog( "Could not create the NanoPawnClass:" @ InEnemyType );
		return None;
    }

	if( NanoPawnClass.default.bCanFly )
	{
		SpawnMethod = ESM_FlyingCar;
	}

	if( SpawnMethod == ESM_DropInFromAir )
	{
		SpawnDropPod( NanoPawnClass );
		return none;
	}

	if( VSize(InSpawnLocationOverride) == 0 )
	{
		if( NDP != none )
		{
			`NPESLog( "Trying to Spawn from NanoDefensivePoint" @ NanoPawnClass );
			SpawnLocation = GetEnemySpawnLocation( NanoPawnClass, ESM_NanoDefensivePoint, NDP );
		}
		else
		{
			`NPESLog( "Trying to Spawn:" @ NanoPawnClass @ "via" @ SpawnMethod );
			SpawnLocation = GetEnemySpawnLocation( NanoPawnClass, SpawnMethod );
	
			if( ( SpawnMethod == ESM_Rooftop )
				&& ( VSize(SpawnLocation) != 0.0f )
				)
			{
				bRooftopSentinel = TRUE;
			}
		}
	}
	else
	{
		SpawnLocation = InSpawnLocationOverride;
	}


	if( VSize(SpawnLocation) == 0.0f )
	{
		`NPESLog( "SpawnAIType: Unable to find valid SpawnAIType Spawning Spot" @ InEnemyType @ SpawnLocation );

		// so we were not able to spawn the specific AI for some reason.  Let's Delay trying to spawn him again to let the worldstate change some
		// to hopefully allow it to spawn
		ModifyDelayTimeOnEnemySpawnData( InEnemyType, InSpawnMethod );

		return none;
	}


	//DrawDebugCoordinateSystem( SpawnLocation, rot(0,0,0), 50.0f, TRUE );

    NewEnemy = Spawn( NanoPawnClass,,, SpawnLocation,,, TRUE );
	if( NewEnemy != None )
	{
		//`log( "Trying to create" @ `showvar(NanoPawnClass.default.ControllerClass.Name) );
		AI = Spawn( CreateNanoAIClass( NanoPawnClass.default.ControllerClass.Name ) );

		if( GetEnemySpawnDatum( InEnemyType ).bIsRebel == TRUE )
		{
			AI.SetTeam( 0 );

			NewEnemy.SetMaterialSkinColorFromMobile( MobileReponseType_Color );	
		}
		else
		{
			AI.SetTeam( 1 );
		}


		if( bResponseCloud == TRUE )
		{
			AI.bSpawnedIntoTheResponseCloud = TRUE;

			// hack
			if( NanoAI_PoliceCar(AI) == None )
			{
				AI.ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyTowardDueToCloud' );
			}
		}
	
		// if we are going to defend a defensive point
		if( NDP != None )
		{
			if( AI.bReplaceMyAIActionsFromDefensivePoint == TRUE )
			{
				// we want to remove all of the actions this AI can do and instead replace them with
				// "defensive point" actions which make the defensive point be "authoritative" over everything
				// instead of the AI trying to "think" for themselves.   This basically allows us to have 
				// custom AI and not have to special case if() checks everywhere

				AI.ListOfAIActionsThisAICanDo.Length = 0;

				AI.ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_Idle_WaitingForReinforcementWave' );
				AI.ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_Defensive_GuardDefensePoint' );
				AI.ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyTowardFromDefensivePoint' );

				if( NDP.bCanPatrolFromHere == TRUE )
				{
					AI.ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_Idle_PatrolARoute' );
				}
			}
		}

		AI.Possess( NewEnemy, FALSE );
		if( ( NanoAI_Trooper(AI) != None ) && ( bRooftopSentinel == TRUE ) )
		{
			NanoAI_Trooper(AI).SetConfrontationType( ECFT_RooftopSentinel );
			AI.bInitialSpawnOnRooftops = TRUE;;
			NanoGRI(WorldInfo.GRI).AIBlackboard.NumSpawnedFromRooftops++;
		}

		`NPESLog( "spawned: " @ NewEnemy @ AI );

		return AI;
	}

	// so we were not able to spawn the specific AI for some reason.  Let's Delay trying to spawn him again to let the worldstate change some
	// to hopefully allow it to spawn
	`NPESLog( "SpawnAIType: Unable to find spawn for some reason" @ InEnemyType );
	ModifyDelayTimeOnEnemySpawnData( InEnemyType, InSpawnMethod );

	return none;
}

/** Sometimes an AI will not be able to spawn so we need to just add some Hysteresis to stop the system just spam try to spawn that one AI type **/
function  ModifyDelayTimeOnEnemySpawnData( Name InAIType, EEnemySpawnMethod SpawnMethod )
{
	local int Idx;

	for( Idx = 0; Idx < EnemySpawnData.Length; ++Idx )
	{
		if( InAIType == EnemySpawnData[Idx].EnemyType )
		{
			EnemySpawnData[Idx].DelayTime[SpawnMethod] = WorldInfo.TimeSeconds + SpawnDelayTimeAmount;
			`NPESLog( GetFuncName() @ `showvar(InAIType) @ `showvar(SpawnMethod) @ `showvar(EnemySpawnData[Idx].DelayTime[SpawnMethod]) );
		}
	}
}



/** Kill off AIs that are far from you **/
function DoEnemyCleanUp()
{
	local vector PlayerLocation;
	local NanoAI AI;


	// hack here (we need to make certain the game has been running a for 20 seconds or so before doing this
	// otherwise we start killing off all kinds of guys before we are even spawned in
	if( WorldInfo.TimeSeconds < 20.0f )
	{
		return;
	}


	PlayerLocation = GetPlayerLocation();

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI.Pawn != None )
		{
			if( ( VSize(AI.Pawn.Location - PlayerLocation ) > KillAIOffDistance )
				)
			{
				`NPESLog( "DoEnemyCleanUp kill off" @ `showvar(AI) @ `showvar(VSize(AI.Pawn.Location - PlayerLocation)) );
				KillOffAIWithNDT_KilledByProceduralSpawner( AI );
			}
		}
	}
}


/** This is our helper function to kill off AIs and then destroy their bodies **/
final function KillOffAIWithNDT_KilledByProceduralSpawner( NanoAIBase InAI )
{
	if( NanoAI_SentryTurret(InAI) != None )
	{
		return;
	}

	InAI.Pawn.Died( None, class'NDT_KilledByProceduralSpawner', InAI.Pawn.Location );
	//InAI.Pawn.Destroy(); // since we killed it we now need to remove it from the world
}


function DoCullFurthestCloudAI()
{
	local vector PlayerLocation;
	local NanoAI AI;

	local float FurthestDistanceAway, TempDist;
	local NanoAI FurthestAIAway;

	local int NumRooftopAI;
	//local array<NanoAI> KillList;



	// hack here (we need to make certain the game has been running a for 20 seconds or so before doing this
	// otherwise we start killing off all kinds of guys before we are even spawned in
	if( WorldInfo.TimeSeconds < 20.0f )
	{
		return;
	}


	PlayerLocation = GetPlayerLocation();



	// check for errant police cars
	if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
	{
		// so here we just kill off any police cars that are far away as their can't path correctly
		// they should respawn due to the priority they have
		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			if( NanoAI_PoliceCar(AI) != None )
			{
				TempDist = VSize(AI.Pawn.Location - PlayerLocation );
				if( TempDist > KillAIOffDistance )
				{
					`NPESLog( "Police Car REALLY far away killing it off" @ `showvar(AI) @ `showvar(TempDist) );	
					KillOffAIWithNDT_KilledByProceduralSpawner( AI );
					return; // we killed off one so no more
				}
			}
		}
	}



	// so we are also going to "clean up" guys that are the furthest away from the player (IF they are escaping)
	// right now they player will bug out and then leave everyone in the dust.  We want to make it so
	// there are always guys coming after the player even if they are fleeing

	// we only want to do this if we have reached the max spawned guys for that tier as no more can spawn to intercept the player

	// need to check that we don't have points avail
	// need to kill off guys that are far away
	// need to kill off the "oldest" farthest away guy
	// need to also kill off guys that are falling behind lyrik in her fleeing
	if( NanoGRI(WorldInfo.GRI).NED.IsPlayerDoing( 'Escaping') == TRUE )
	{
		// so here we just kill off the furthest guy away (so he will get respawned)
		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			if( AI.Pawn != None )
			{
				// if the pawn is guarding, don't kill
				if( AI.FindCommandOfClass( class'NanoAIAction_DefensiveBase' ) != None )
				{
					continue;
				}

				// hack
				if( NanoAI_SentryTurret(AI) != None )
				{
					continue;
				}

				// don't cull police cars as they are always far away and are culled above
				if( NanoAI_PoliceCar(AI) != None )
				{
					continue;
				}


				TempDist = VSize(AI.Pawn.Location - PlayerLocation );
				if( ( TempDist > FurthestDistanceAway ) 
					|| ( TempDist > DoCullFurthestCloudAI_AutoAddToCullList ) // if we are quite a ways away
					)
				{
					// need to compare again :-\ as we want the furthest away guy and we might already have a 4000+ away AI
					if( TempDist > FurthestDistanceAway )
					{
						FurthestDistanceAway = TempDist;
						FurthestAIAway = AI;
					}
				}
			}
		}


		if( FurthestAIAway != None )
		{
			if( ( CurrPointsSpent >= MaxPointsAvail-1 )
				|| ( FurthestDistanceAway > DoCullFurthestCloudAI_AutoCullDist ) // if we are really far away then just kill it off as there is no way this guy is ever going to catch her
				)
			{
				`NPESLog( "DoEnemyCleanUp kill off" @ `showvar(FurthestAIAway) @ `showvar(TempDist) );
				KillOffAIWithNDT_KilledByProceduralSpawner( FurthestAIAway );
				return; // we killed off one so no more
			}
		}
	}
	


	// check to see if we are on the rooftop and that there are some bRooftopSentinel.  If we don't then we should kill off the furthest away
	if( NanoGRI(WorldInfo.GRI).GetNanoPC().IsOnRoofTop() == TRUE )
	{
		// so here we just kill off the furthest guy away (so he will get respawned)
		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			if( ( AI.Pawn != None ) && ( AI.ConfrontationType == ECFT_RooftopSentinel ) )
			{
				//`log( "oh found some rooftop ai!" @ `showvar(AI) @ `showvar(AI.Pawn.Location) @ `showvar(VSize(AI.Pawn.Location-NanoGRI(WorldInfo.GRI).GetPlayerPawn().Location)));
				NumRooftopAI++;
			}
		}


		if( ( NumRooftopAI < (MaxPointsAvail * ChaosTierSpawnData[CurrChaosTier].PercentOfMaxEnemiesAllowedToSpawnFromRooftops) )
			&& ( ( MaxPointsAvail - CurrPointsSpent ) == 0) // and there are no points to spawn on rooftop
			)
		{	
			// so here we just kill off the furthest guy away (so he will get respawned)
			foreach WorldInfo.AllControllers( class'NanoAI', AI )
			{
				if( AI.Pawn != None )
				{
					// if the pawn is guarding, don't kill
					if( AI.FindCommandOfClass( class'NanoAIAction_DefensiveBase' ) != None )
					{
						continue;
					}

					// don't kill off police cars
					if( NanoAI_PoliceCar(AI) != None )
					{
						continue;
					}

					if( NanoAI_SentryTurret(AI) != None )
					{
						continue;
					}


					TempDist = VSize(AI.Pawn.Location - PlayerLocation );
					if( TempDist > FurthestDistanceAway )
					{
						FurthestDistanceAway = TempDist;
						FurthestAIAway = AI;
					}
				}
			}


			if( FurthestAIAway != None )
			{
				`NPESLog( "DoEnemyCleanUp kill off due to not enough rooftop guys" @ `showvar(FurthestAIAway) @ `showvar(TempDist) @ `showvar(NumRooftopAI) @ `showvar(( MaxPointsAvail * ChaosTierSpawnData[CurrChaosTier].PercentOfMaxEnemiesAllowedToSpawnFromRooftops) ) );
				KillOffAIWithNDT_KilledByProceduralSpawner( FurthestAIAway );
				return; // we killed off one so no more
			}
		}
	}

}


function DoEnemyManagement()
{
	local array<name> PossibleEnemiesToSpawn;
	//local name EnemyID;
	local EEnemySpawnMethod ESM;
	local bool bDidSpawn;
	local NanoAI AI;

	`NPESLog( "DoEnemyManagement" );

	// check against how many guys we have left and how many pts we have left to spend
	if( CurrNumEnemies >= MaxNumEnemies )
	{
		`NPESLog( "Too many enemies" @ CurrNumEnemies @ MaxNumEnemies );
		return;
	}

	// TODO:  handle case where we have more points spent than we should.  Right now we just have the player killlll them off for us
	if( CurrPointsSpent >= MaxPointsAvail )
	{
		`NPESLog( "Too many points spent" @ `showvar(MaxPointsAvail) @ `showvar(CurrPointsSpent) @ `showvar(CloudBurstPoints)  );
		return;
	}

	// so we can spawn something!
	// so choose how we want to spawn things

	// choose EEnemySpawnMethod
	ESM = ESM_Cloud;


	// now we do the spawning.
	// spawn from the crowd system first
	// we look for spawn point that the LDs have placed first
	// then we try for squads 
	// then we fill in any indivs

    if( TimeToDoCrowdMemberSpawns < WorldInfo.TimeSeconds )
    {
		TimeToDoCrowdMemberSpawns = WorldInfo.TimeSeconds + TimeBetweenCrowdMemberSpawns;
    }

	// do spawn point spawns
    if( TimeToDoSpawnPointSpawns < WorldInfo.TimeSeconds )
    {
		`NPESLog( "DoSpawnPointSpawning" );
        bDidSpawn = DoSpawnPointSpawning( PossibleEnemiesToSpawn );
		if( bDidSpawn == TRUE )
		{
			TimeToDoSpawnPointSpawns = WorldInfo.TimeSeconds + TimeBetweenSpawnPointSpawns;
			return;
		}
    }


	// do squad spawns
// 	if( TimeToDoSquadSpawns < WorldInfo.TimeSeconds )
//     {
// 		GetSquadEnemiesToSpawn( PossibleEnemiesToSpawn );
// 		`NPESLog( "GetSquadEnemiesToSpawn choosing from a possible:" @ PossibleEnemiesToSpawn.Length );
// 		if( PossibleEnemiesToSpawn.Length > 0 )
// 		{
// 			foreach PossibleEnemiesToSpawn( EnemyID )
// 			{
// 	   	    	AI = SpawnAIType( EnemyID, ESM_DropInFromAir );
// 				if( AI != none )
// 			    {
// 					//FIXMEMP:  Assumes there is only one player!
//                     AI.MoveToActor( GetPlayerPawn() ); // here we need to send them after the player
// 			    }
// 			}
// 
// 			TimeToDoSquadSpawns = WorldInfo.TimeSeconds + TimeBetweenSquadSpawns;
//       	 	return;
// 		}
//     }


	// do indiv spawns
	GetIndividualEnemiesToSpawn( PossibleEnemiesToSpawn, ESM );

	`NPESLog( "GetIndividualEnemiesToSpawn choosing from a possible:" @ PossibleEnemiesToSpawn.Length );
	if( PossibleEnemiesToSpawn.Length > 0 )
	{
		AI = SpawnAIType( DetermineBestAIFromListToSpawn( PossibleEnemiesToSpawn ), ESM, TRUE );
		if( AI != none )
		{
			//FIXMEMP:  Assumes there is only one player!
			AI.MoveToActor( GetPlayerPawn() ); // here we need to send them after the player
		}
		return;
	}
}




function Name DetermineBestAIFromListToSpawn( const out array<name> InPossibleEnemiesToSpawn )
{
	local Name Retval;
	local name EnemyID;
	local EnemySpawnDatum ESD;
	local array<name> NewPossibleEnemiesToSpawn;
	local int HighestPriority;

	// look at all of the posssible AITypes and find the one with the highest priority
	foreach InPossibleEnemiesToSpawn( EnemyID )
	{
		ESD = GetEnemySpawnDatum( EnemyID );

		// check to see if this AI is higher priority than our current winner
		if( ESD.Priority >= HighestPriority )
		{
			HighestPriority = ESD.Priority;
		}
	}

	// now insert to our choice group the highest priority AITypes (there could be multiple)
	foreach InPossibleEnemiesToSpawn( EnemyID )
	{
		ESD = GetEnemySpawnDatum( EnemyID );

		if( ESD.Priority == HighestPriority )
		{
			//`log( "Adding" @ `showvar(EnemyID) @ `showvar(ESD.Priority) @ `showvar(HighestPriority) );
			NewPossibleEnemiesToSpawn.AddItem( ESD.EnemyType );
		}
	}

	// randomly choose from the set of "highest priority" AITypes
	Retval = NewPossibleEnemiesToSpawn[Rand( NewPossibleEnemiesToSpawn.Length )];

	
//	foreach NewPossibleEnemiesToSpawn( EnemyID )
//	{
//		`log( "NewPossibleEnemiesToSpawnNewPossibleEnemiesToSpawnNewPossibleEnemiesToSpawnNewPossibleEnemiesToSpawn" @ `showvar(EnemyID) );
//	}



	return Retval;
}




function DoTattlerSpawning()
{
	local NanoAI AI;

	//`log( "DoTattlerSpawning()" );

	if( bDoEnemyManagementRequireTattlerSight == TRUE )
	{
		// so here we need to see if the tattlers around to go ahead and spawn guys that are near us
		if( AreTattlersAlertAndCanSeeThePlayer() == FALSE )
		{
			`NPESLog( "AreTattlersAlertAndCanSeeThePlayer was FALSE" );
			// so if we can't see a player then we are going to spawn a tattler near them and it will move toward them
			// and then the enemies will start rolllllling in
			if( AreTattlersAbleToFindPlayer() == FALSE )
			{
				AI = SpawnAIType( 'NanoPawn_MetaCorp_SentryBot', ESM_SpawnAroundCornerOutOfSight, FALSE, FindSpawnLocation_Tattler() );
				if( AI != none )
				{
					//FIXMEMP:  Assumes there is only one player!
					AI.MoveToActor( GetPlayerPawn() ); // here we need to send them after the player
				}
			}

			return;
		}
	}

}



function DoEnemyManagement_DefensivePoints()
{	
	local EEnemySpawnMethod ESM;
	local array<name> PossibleEnemiesToSpawn;
	local NanoDefensivePoint Pt;
	local NanoAI AI;
	local int EnemyIdx;
	local vector PlayerLocation;
	local NanoAIBlackboard BlackBoard;
	local bool bAreAllGuardPointsManned;
	local int SpawnModIdx;

	`NPESLog( "==== DoEnemyManagement_DefensivePoints ==== ");
	

	ESM = ESM_SpawnAroundCornerOutOfSight;

	//FIXMEMP:  Assumes there is only one player!
	if( NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn != none )
	{
		PlayerLocation = NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location;
	}
	else
	{
		PlayerLocation = vect(0,0,0);
	}

	BlackBoard = NanoGRI(WorldInfo.GRI).AIBlackboard;


	// lil dirty but worth doing for metrics atm
	CurrNumEnemiesAtDefensivePoints = 0;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( AI != none )
		{
			if( ( AI.CurrNanoDefensivePoint != None ) )
			{
				CurrNumEnemiesAtDefensivePoints++;
			}
		}
	}


	
	foreach AllActors( class'NanoDefensivePoint', Pt )
	{

		//`NPESLog( Pt @ `showvar(Pt.bIsActive) );

		if( Pt.bIsActive == FALSE )
		{
			continue;
		}

		// so if we have not done the initial spawn let's do that and then skip the rest of the code.
		if( Pt.NumPointsForInitialSpawn > 0 )
		{
			`NPESLog( Pt @ "valid for initial spawn" @ `showvar(Pt.NumPointsForInitialSpawn) @ `showvar(Pt.NumAIWithinDefendRadius(FALSE)) );

			if( VSize(Pt.Location - PlayerLocation) < KillAIOffDistance )
			{
				GetIndividualEnemiesToSpawn( PossibleEnemiesToSpawn, ESM, Pt );

				`NPESLog( "    num enemies" @ `showvar(PossibleEnemiesToSpawn.Length) );
				if( PossibleEnemiesToSpawn.Length > 0 )
				{
					`NPESLog( "    DoEnemyManagement_DefensivePoints choosing from a possible Enemies for Initial spawn:" @ `showvar(Pt) @ PossibleEnemiesToSpawn.Length @ `showvar(Pt.NumPointsToSpendToDefend) );
					EnemyIdx = Rand( PossibleEnemiesToSpawn.Length );
					AI = SpawnAIType( PossibleEnemiesToSpawn[ EnemyIdx ], ESM, FALSE,, Pt );
					if( AI != none )
					{
						// okie need to check here to see if we spawned from our NDEP list and update the spawn count
						for( SpawnModIdx = 0; SpawnModIdx < Pt.DenfensivePointSpawnModifiers.Length; ++SpawnModIdx )
						{
							if( Pt.DenfensivePointSpawnModifiers[SpawnModIdx].EnemyType.Name == PossibleEnemiesToSpawn[ EnemyIdx ] )
							{
								Pt.DenfensivePointSpawnModifiers[SpawnModIdx].NumberSpawned++;
								break;
							}
						}

						AI.bInitialSpawnOnDefensivePoint = TRUE;

						`NPESLog( "    INITIAL PRE" @ `showvar(Pt) @ `showvar(Pt.NumPointsForInitialSpawn) );
						Pt.NumPointsToSpendToDefend -= GetEnemySpawnDatum( PossibleEnemiesToSpawn[ EnemyIdx ] ).Cost;
						Pt.NumPointsForInitialSpawn -= GetEnemySpawnDatum( PossibleEnemiesToSpawn[ EnemyIdx ] ).Cost;
						`NPESLog( "    INITIAL POST" @ `showvar(Pt) @ `showvar(Pt.NumPointsForInitialSpawn) );

						AI.CurrNanoDefensivePoint = Pt;
						AI.HACK_CurrNanoDefensivePoint = Pt;
					}
					return;  // don't overwhelm the gamethread with spawning lots of pawns for every possible Defensive Point after we have spawned one just return
				}
			}


			continue;
		}




		Pt.PossiblyResetReinforcementPoints();

		bAreAllGuardPointsManned = Pt.AreAllGuardPointsManned();

		`NPESLog( pt @ "AAAAAHHHHHHHH" @ `showvar(Pt.NumPointsForAWave) @ `showvar(BlackBoard.GetCurrWaveWaiting(Pt)) @ `showvar(Pt.NumAIWithinDefendRadius(FALSE)) );

		if( bAreAllGuardPointsManned == TRUE )
		{
			`NPESLog( "    all guard points are full!  Not spawning more!" @ `showvar(Pt) );
			continue;
		}
		else if( Pt.NumPointsLeftToSpendOnThisWave <= 0 )
		{
			`NPESLog( "    All points for this wave have been spent!" @ `showvar(Pt.NumPointsLeftToSpendOnThisWave) );
			continue;
		}
		// don't spawn any more dudes as a FULL wave is waiting already
		else if( ( ( Pt.bUseWaveSpawning == TRUE ) && ( Pt.NumPointsForAWave > 0 ) && ( BlackBoard.GetCurrWaveWaiting(Pt) == TRUE ) )
			)
		{
			`NPESLog( "    DoEnemyManagement_DefensivePoints:  Full wave waiting in the wings to attack!  Not spawning more!" @ `showvar(Pt) );
			continue;
		}
		else if( ( Pt.NumPointsForInitialSpawn == 0) && ( Pt.bUnderAttack == FALSE ) )
		{
			// not under attack
			`NPESLog( "    Not under attack" @ `showvar(Pt) );
			continue;
		}
		else
		{
			// go for spawning
			`NPESLog( "    GO FOR SPAWNING" @ `showvar(Pt) );
		}

		if( VSize(Pt.Location - PlayerLocation) <= 16384 )
		{
			GetIndividualEnemiesToSpawn( PossibleEnemiesToSpawn, ESM, Pt );

			if( PossibleEnemiesToSpawn.Length > 0 )
			{
				`NPESLog( "    DoEnemyManagement_DefensivePoints choosing from a possible Enemies to spawn:" @ `showvar(Pt) @ PossibleEnemiesToSpawn.Length @ `showvar(Pt.NumPointsToSpendToDefend) );
				EnemyIdx = Rand( PossibleEnemiesToSpawn.Length );
				AI = SpawnAIType( PossibleEnemiesToSpawn[ EnemyIdx ], ESM, FALSE,, Pt );
				if( AI != none )
				{
					// okie need to check here to see if we spawned from our NDEP list and update the spawn count
					for( SpawnModIdx = 0; SpawnModIdx < Pt.DenfensivePointSpawnModifiers.Length; ++SpawnModIdx )
					{
						if( Pt.DenfensivePointSpawnModifiers[SpawnModIdx].EnemyType.Name == PossibleEnemiesToSpawn[ EnemyIdx ] )
						{
							Pt.DenfensivePointSpawnModifiers[SpawnModIdx].NumberSpawned++;
							break;
						}
					}


					`NPESLog( "    DEFENSIVE PRE" @ `showvar(Pt) @ `showvar(Pt.NumPointsToSpendToDefend) );
					Pt.NumPointsToSpendToDefend -= GetEnemySpawnDatum( PossibleEnemiesToSpawn[ EnemyIdx ] ).Cost;
					Pt.NumPointsLeftToSpendOnThisWave -= GetEnemySpawnDatum( PossibleEnemiesToSpawn[ EnemyIdx ] ).Cost;
					`NPESLog( "    DEFENSIVE POST" @ `showvar(Pt) @ `showvar(Pt.NumPointsToSpendToDefend) );
		
					AI.CurrNanoDefensivePoint = Pt;
				}
				return;  // don't overwhelm the gamethread with spawning lots of pawns for every possible Defensive Point after we have spawned one just return
			}
			else
			{
				`NPESLog( "No enemies found to spawn for:" @ `showvar(Pt) );
			}
		}
	}
}


function bool CanEnemiesSpawnOnRooftopsDueToCurrentTierSettings()
{
	// check to see if already have spawned our max amount of guys allowed to be spawned from the rooftop
	if( NanoGRI(WorldInfo.GRI).AIBlackboard.NumSpawnedFromRooftops >= int( MaxPointsAvail * ChaosTierSpawnData[CurrChaosTier].PercentOfMaxEnemiesAllowedToSpawnFromRooftops) )
	{
		`NPESLog( "Too many alive AI originally spawned from rooftops" @ `showvar(NanoGRI(WorldInfo.GRI).AIBlackboard.NumSpawnedFromRooftops) @ `showvar(( MaxPointsAvail * ChaosTierSpawnData[CurrChaosTier].PercentOfMaxEnemiesAllowedToSpawnFromRooftops))  );
		return FALSE;
	}

	return TRUE;
}


function DoEnemyManagement_Rooftops()
{
	local EEnemySpawnMethod ESM;
	local array<name> PossibleEnemiesToSpawn;
	local NanoAI AI;

	`NPESLog( "DoEnemyManagement_Rooftops" );

	// check to see if the player is on the rooftops
	if( NanoGRI(WorldInfo.GRI).GetNanoPC().IsOnRoofTop() == FALSE )
	{
		return;
	}


	// check against how many guys we have left and how many pts we have left to spend
	if( CurrNumEnemies >= MaxNumEnemies )
	{
		`NPESLog( "Too many enemies" @ CurrNumEnemies @ MaxNumEnemies );
		return;
	}

	// TODO:  handle case where we have more points spent than we should.  Right now we just have the player killlll them off for us
	if( CurrPointsSpent >= MaxPointsAvail )
	{
		`NPESLog( "Too many points spent" @ `showvar(MaxPointsAvail) @ `showvar(CurrPointsSpent) @ `showvar(CloudBurstPoints)  );
		return;
	}

	if( CanEnemiesSpawnOnRooftopsDueToCurrentTierSettings() == FALSE )
	{
		return;
	}


	// choose EEnemySpawnMethod
	ESM = ESM_Rooftop;

	// do indiv spawns
	GetIndividualEnemiesToSpawn( PossibleEnemiesToSpawn, ESM );

	if( PossibleEnemiesToSpawn.Length > 0 )
	{
		`NPESLog( "DoEnemyManagement_Rooftops: choosing from a possible:" @ PossibleEnemiesToSpawn.Length );
		AI = SpawnAIType( DetermineBestAIFromListToSpawn( PossibleEnemiesToSpawn ), ESM );
		if( AI != none )
		{
			//FIXMEMP:  Assumes there is only one player!
			AI.MoveToActor( GetPlayerPawn() ); // here we need to send them after the player
		}
		return;
	}
}



function vector GetEnemySpawnLocation( const class<NanoPawnBase> InPawnClass, const EEnemySpawnMethod InESM, optional NanoDefensivePoint NDP  )
{
	switch( InESM )
	{
	    case ESM_SpawnAroundCornerOutOfSight: break;
		case ESM_CrowdMemberTransformation: break;
		case ESM_DropInFromAir: return FindSpawnLocation_DropPod( InPawnClass );
		case ESM_SpecificSpawnLocation: break;
		case ESM_Springer: break;
		case ESM_FlyingCar: return FindSpawnLocation_PoliceCar( InPawnClass );
		case ESM_Rooftop: return FindSpawnLocation_Rooftop( InPawnClass );
		case ESM_NanoDefensivePoint: return FindSpawnLocation_NanoDefensivePoint( InPawnClass, NDP );
		case ESM_Cloud: return FindSpawnLocation_Cloud( InPawnClass );
	}

	return FindSpawnLocation_PlayerCannotSee( InPawnClass );
}



/** 
 *  Checks to see if this is a valid enemy to spawn.
 *  
 *  Depends on:  point cost, chaos tier, how many of that pawn type exist already.
 *  
 *  
 **/
final function bool IsValidEnemy( EnemySpawnDatum InESD, EEnemySpawnMethod ESM, optional const NanoDefensivePoint NDP )
{
	local bool bNotAllowedToSpawnFromDefensivePoint;
	local bool bAllowedToSpawnDueToDelayTime;
	local bool bAllowedToSpawnInitialGuy;
	local RebelMindShareManager RMSM;
	local int RebelMindShareLevel;

	bNotAllowedToSpawnFromDefensivePoint = ( ( NDP != None ) && ( InESD.bDoNotSpawnAtDefensivePoints == TRUE ) );

	bAllowedToSpawnDueToDelayTime = InESD.DelayTime[ESM] < WorldInfo.TimeSeconds;


	bAllowedToSpawnInitialGuy = TRUE;  // assume we can spawn this this guy (e.g. if this is not one of these then we will not set this var to anything besides true)
	if( InESD.bSpawnOnlyDuringInitialSpawn == TRUE )
	{
		if( ( NDP != None ) && ( NDP.NumPointsForInitialSpawn >= InESD.Cost ) )
		{
			bAllowedToSpawnInitialGuy = TRUE;
		}
		else
		{
			bAllowedToSpawnInitialGuy = FALSE;
		}
	}



	// check for rebel here and use different rules
	if( InESD.bIsRebel == TRUE )
	{
		RMSM = NanoGRI(WorldInfo.GRI).GetCurrentRebelMindShareManager();
		if( RMSM != None )
		{
			RebelMindShareLevel = RMSM.GetRebelMindShareLevel();
		}
		
		// for now:  if we have the correct rebel mindshare amount spawn them!
		return( ( RebelMindShareLevel >= (InESD.PercentOfMaxRebelMindShareNeededToSpawn * class'RebelMindShareManager'.default.MaxAmountOfRebelMindShare) )
			&& ( bAllowedToSpawnDueToDelayTime == TRUE ) // but still use this also.  As when a rebel of a type dies we are going to set delay to be 60 seconds
			&& ( EnemiesAlive[GetSpawnInfoIndex(InESD.EnemyType)].NumAlive < InESD.MaxCount )
			&& ( ( ( InESD.MinChaosTier <= CurrChaosTier ) && ( CurrChaosTier <= InESD.MaxChaosTier ) ) || ((NDP!=None)&&(InESD.MinChaosTier==1)) )
			&& ( InESD.PercentageToSpawn >= CurrTierPercentage ) // if this percentage allows us to spawn for this tier
			&& ( bAllowedToSpawnInitialGuy == TRUE )
			)
			|| ( ( InESD.EnemyType == MobileReponseType_Override ) && ( EnemiesAlive[GetSpawnInfoIndex(InESD.EnemyType)].NumAlive < InESD.MaxCount ) )

			;
	}
	else
	{
		return ( (( CurrNumEnemies < MaxNumEnemies ) && ( CurrPointsSpent < MaxPointsAvail )) || ( InESD.bForceSpawn == TRUE ) || ( NDP != None ) ) // if we are NDP spawn then don't care about Point costs
			&& ( EnemiesAlive[GetSpawnInfoIndex(InESD.EnemyType)].NumAlive < InESD.MaxCount )
			&& ( ( InESD.Cost <= (MaxPointsAvail - CurrPointsSpent) ) || ( NDP != None )  )  // if we are NDP spawn then don't care about Point costs
			&& ( ( ( InESD.MinChaosTier <= CurrChaosTier ) && ( CurrChaosTier <= InESD.MaxChaosTier ) ) || ((NDP!=None)&&(InESD.MinChaosTier==1)) ) // the || case handles initial spawn when chase is not up.  When chaos is up we follow the rules for spawning
			&& ( ( NDP == None ) || ( NDP.NumPointsLeftToSpendOnThisWave >= InESD.Cost ) || ( NDP.NumPointsForInitialSpawn >= InESD.Cost ) )
			&& ( bNotAllowedToSpawnFromDefensivePoint == FALSE )
			&& ( InESD.PercentageToSpawn >= CurrTierPercentage ) // if this percentage allows us to spawn for this tier
			&& ( bAllowedToSpawnDueToDelayTime == TRUE )
			&& ( bAllowedToSpawnInitialGuy == TRUE )
			;
	}
}



final function IsValidEnemy_Log( EnemySpawnDatum InESD, EEnemySpawnMethod ESM, optional const NanoDefensivePoint NDP )
{
`if(`notdefined(FINAL_RELEASE))
	local bool bNotAllowedToSpawnFromDefensivePoint;
	local bool bAllowedToSpawnDueToDelayTime;
	local bool bAllowedToSpawnInitialGuy;

	bNotAllowedToSpawnFromDefensivePoint = ( ( NDP != None ) && ( InESD.bDoNotSpawnAtDefensivePoints == TRUE ) );

	bAllowedToSpawnDueToDelayTime = InESD.DelayTime[ESM] < WorldInfo.TimeSeconds;

	bAllowedToSpawnInitialGuy = TRUE;  // assume we can spawn this this guy (e.g. if this is not one of these then we will not set this var to anything besides true)
	if( InESD.bSpawnOnlyDuringInitialSpawn == TRUE )
	{
		if( ( NDP != None ) && ( NDP.NumPointsForInitialSpawn >= InESD.Cost ) )
		{
			bAllowedToSpawnInitialGuy = TRUE;
		}
		else
		{
			bAllowedToSpawnInitialGuy = FALSE;
		}
	}

	
	`endif

// MEGA LOGGING
return;

	`NPESLog( "==" @ `showvar(InESD.EnemyType) @ "==" );
	`NPESLog( "" );

	`NPESLog( (( CurrNumEnemies < MaxNumEnemies ) && ( CurrPointsSpent < MaxPointsAvail )) || ( InESD.bForceSpawn == TRUE ) || ( NDP != None ) );
	`NPESLog( "   " @ `showvar(CurrNumEnemies) @ `showvar(MaxNumEnemies) @ CurrNumEnemies < MaxNumEnemies );
	`NPESLog( "   " @ `showvar(CurrPointsSpent) @ `showvar(MaxPointsAvail) @ CurrPointsSpent < MaxPointsAvail );

	`NPESLog( ( EnemiesAlive[GetSpawnInfoIndex(InESD.EnemyType)].NumAlive < InESD.MaxCount ) );
	`NPESLog( "   " @ `showvar(EnemiesAlive[GetSpawnInfoIndex(InESD.EnemyType)].NumAlive) @ `showvar(InESD.MaxCount) );


	`NPESLog(  ( ( InESD.Cost <= (MaxPointsAvail - CurrPointsSpent) ) || ( NDP != None )  ) );
	`NPESLog( "   " @ `showvar(InESD.Cost) @ (MaxPointsAvail - CurrPointsSpent) );

	`NPESLog( ( ( ( InESD.MinChaosTier <= CurrChaosTier ) && ( CurrChaosTier <= InESD.MaxChaosTier ) ) || ((NDP!=None)&&(InESD.MinChaosTier==1)) ) );
	`NPESLog( "   " @ `showvar(CurrChaosTier) @ `showvar(InESD.MinChaosTier) @ `showvar(InESD.MaxChaosTier) );

	`NPESLog( ( ( NDP == None ) || ( NDP.NumPointsLeftToSpendOnThisWave >= InESD.Cost ) || ( NDP.NumPointsForInitialSpawn >= InESD.Cost )  ) );
	if( NDP != none )
	{
		`NPESLog( "   " @ `showvar(NDP) @ `showvar(( NDP.NumPointsToSpendToDefend >= InESD.Cost )) );
	}

	`NPESLog(  ( bNotAllowedToSpawnFromDefensivePoint == FALSE ) );
	`NPESLog( "   " @ `showvar(bNotAllowedToSpawnFromDefensivePoint)  );

	`NPESLog( ( InESD.PercentageToSpawn >= CurrTierPercentage ) );
	`NPESLog( "   " @ `showvar(InESD.PercentageToSpawn) @ `showvar(CurrTierPercentage)  );


	`NPESLog( bAllowedToSpawnDueToDelayTime == TRUE );
	`NPESLog( "   " @ `showvar(bAllowedToSpawnDueToDelayTime) @ " Time Til Spawn:" @ InESD.DelayTime[ESM] > 0.0f ? InESD.DelayTime[ESM]-WorldInfo.TimeSeconds : 0.0f );

	`NPESLog( bAllowedToSpawnInitialGuy == TRUE );
	`NPESLog( "   " @ `showvar(bAllowedToSpawnInitialGuy) @ `showvar(InESD.bSpawnOnlyDuringInitialSpawn) @ `showvar(NDP.NumPointsForInitialSpawn >= InESD.Cost) );

}
	


/** 
 *  Checks to see if this is a valid squad to spawn.
 *  
 *  Depends on:  point cost, chaos tier, how many of that pawn type exist already.
 *  
 *  
 **/
final function bool IsValidSquad( EnemySquadDatum InESD )
{
	local bool bPopulationIsOK;
	local name EnemyID;

	bPopulationIsOK = TRUE;

	foreach InESD.Enemies( EnemyID )
	{
		if( EnemiesAlive[GetSpawnInfoIndex(EnemyID)].NumAlive >= GetEnemySpawnDatum(EnemyID).MaxCount )
		{
			`NPESLog( "IsValidSquad too many of same type alive" @ EnemyID @ EnemiesAlive[GetSpawnInfoIndex(EnemyID)].PawnClassName );
			bPopulationIsOK = FALSE;
			break;
		}
	}

    bPopulationIsOK = bPopulationIsOK && ( CurrNumEnemies < MaxNumEnemies );


	return (bPopulationIsOK == TRUE )
		&& ( CurrPointsSpent < MaxPointsAvail )
		&& ( InESD.Cost < (MaxPointsAvail - CurrPointsSpent) )
		&& ( InESD.MinChaosTier <= CurrChaosTier ) && ( CurrChaosTier <= InESD.MaxChaosTier )
		;
}




/** Looks at all of the spawn point enemies and sees if they can be spawned based off the current conditions **/
function GetSpawnPointEnemiesToSpawn( NanoProceduralEnemySpawnPoint SpawnPoint, EEnemySpawnMethod ESM, out array<name> PossibleEnemiesToSpawn )
{
	local NanoProceduralEnemySpawnModifer SpawnModifier;

	// so look over each of the desired spawns and see if they make the cut
	foreach SpawnPoint.SpawnPointSpawns( SpawnModifier )
	{
		if( ( SpawnModifier.EnemyType != none ) 
		   && ( SpawnModifier.PercentageToSpawn > ( FRand() * 100.0f ) )
		   )
		{
			if( IsValidEnemy( GetEnemySpawnDatum(SpawnModifier.EnemyType.Name), ESM ) == TRUE )
			{
			    PossibleEnemiesToSpawn.AddItem( SpawnModifier.EnemyType.Name );
			}
		}
	}
}


/** Looks at all of the squad enemies and sees if they can be spawned based off the current conditions **/
final function GetSquadEnemiesToSpawn( out array<name> PossibleEnemiesToSpawn )
{
	local EnemySquadDatum ESD;
	local name EnemyID;

	foreach EnemySquadData( ESD )
	{
		if( IsValidSquad( ESD ) == TRUE )
		{
	        foreach ESD.Enemies( EnemyID )
	        {
                PossibleEnemiesToSpawn.AddItem( EnemyID );
	        }
		}
	}
}


/** Looks at all of the individual enemies and sees if they can be spawned based off the current conditions **/
final function GetIndividualEnemiesToSpawn( out array<name> PossibleEnemiesToSpawn, EEnemySpawnMethod ESM, optional const NanoDefensivePoint NDP )
{
	local EnemySpawnDatum ESD;
	local NanoDefensivePointModifier NDPM;
	local bool bAddedFromDenfensivePointSpawnModifiers;

	if( NDP != none )
	{
		// so if this NDP uses spawn modifiers those get precedent over normal NPES spawning
		if( NDP.bUseSpawnModifiers == TRUE )
		{
			// so now look on the NDP and see if it has any valid enemy types to spawn
			foreach NDP.DenfensivePointSpawnModifiers( NDPM )
			{
				`NPESLog( "  Specialized spawning" @ `showvar(NDPM.NumberSpawned) @ `showvar(NDPM.MaxNumberToSpawn) );
				if( NDPM.NumberSpawned < NDPM.MaxNumberToSpawn )
				{
					PossibleEnemiesToSpawn.AddItem( NDPM.EnemyType.name );
					bAddedFromDenfensivePointSpawnModifiers = TRUE;
				}
			}
		}
	}

	// if we added any spawns from the NDP then don't do the normal NPES spawn types
	if( bAddedFromDenfensivePointSpawnModifiers == TRUE )
	{
		`NPESLog( "  Specialized spawning" @ `showvar(bAddedFromDenfensivePointSpawnModifiers) );
		return;
	}


	foreach EnemySpawnData( ESD )
	{
		//`log( IsValidEnemy( ESD, NDP ) );
		if( IsValidEnemy( ESD, ESM, NDP ) == TRUE )
		{
			PossibleEnemiesToSpawn.AddItem( ESD.EnemyType );
			`NPESLog( " IsValidEnemy TRUE!!" @ `showvar(ESD.EnemyType) @ `showvar(ESM) );
		}
		else
		{
			// MEGA LOGGING
			//`NPESLog( "-----------------------------------------------------------" );
			//`NPESLog( "" );
			//`NPESLog( " IsValidEnemy FALSE!!" @ `showvar(ESD.EnemyType) @ `showvar(ESM) );
			IsValidEnemy_Log( ESD, ESM, NDP );
		}
	}

}


/** O(n) **/
final function EnemySpawnDatum GetEnemySpawnDatum( Name InAIType )
{
	local EnemySpawnDatum ESD;

	foreach EnemySpawnData( ESD )
	{
		if( InAIType == ESD.EnemyType )
		{
			break;
		}
	}

	return ESD;
}


/** O(n) **/
final function AliveEnemyDatum GetAliveEnemyDatum( Name InAIType )
{
	local AliveEnemyDatum ASD;

	foreach EnemiesAlive( ASD )
	{
		if( InAIType == ASD.PawnClassName )
		{
			break;
		}
	}

	return ASD;
}


/** O(n) **/
final function int GetSpawnInfoIndex( name InAIType )
{
	local int AliveEnemiesIdx;
	local AliveEnemyDatum ASD;
	local bool bFound;

	foreach EnemiesAlive( ASD )
	{
		if( ASD.PawnClassName == InAIType )
		{
			bFound = TRUE;
			break;
		}
		AliveEnemiesIdx++;
	}

	if( bFound == FALSE )
	{
		`warn( "GetSpawnInfoIndex did not find InAIType:" @ InAIType );
		AliveEnemiesIdx = INDEX_NONE;
	}

    return AliveEnemiesIdx;
}



/** Does all of the spawn point spawning of enemies.  Spawning dudes at the location of the spawn point **/
function bool DoSpawnPointSpawning( out array<name> PossibleEnemiesToSpawn )
{
	local bool bDidSpawn;
	local Vector PlayerLocation;
	local NanoProceduralEnemySpawnPoint SpawnPoint;
	local NanoAI AI;

	PlayerLocation = GetPlayerLocation();

	// BRING IT!
	foreach AllActors( class'NanoProceduralEnemySpawnPoint', SpawnPoint )
	{
		// if too far away
		if( ( SpawnPoint.bIsSpawnPointActive == FALSE )
			|| ( VSize( SpawnPoint.Location - PlayerLocation ) > RadiusToSearchAroundPlayerForSpawnPoints )
			)
		{
			continue;
		}

		GetSpawnPointEnemiesToSpawn( SpawnPoint, ESM_SpecificSpawnLocation, PossibleEnemiesToSpawn );
		//`NPESLog( "GetSpawnPointEnemiesToSpawn choosing from a possible:" @ PossibleEnemiesToSpawn.Length );

		if( PossibleEnemiesToSpawn.Length > 0 )
		{
		    AI = SpawnAIType( PossibleEnemiesToSpawn[Rand( PossibleEnemiesToSpawn.Length )], ESM_SpawnAroundCornerOutOfSight, FALSE, SpawnPoint.Location );
			if( AI != none )
			{
				//FIXMEMP:  Assumes there is only one player!
                AI.MoveToActor( GetPlayerPawn() ); // here we need to send them after the player
			}

			bDidSpawn = TRUE;
		}

		PossibleEnemiesToSpawn.Length = 0;
	}

	return bDidSpawn;
}



function bool IsValidDropPodLandingSpot( Vector PossibleLocation )
{
	local int Idx;
	local Vector DropLoc;
	local Vector HitLocation, HitNormal;
	local Actor HitActor;
	//local Rotator Rot;

	//Rot = rot(0,16384,0) * Rand(3);
	for( Idx = 0; Idx < 4; Idx++ )
	{
		DropLoc = PossibleLocation;

		HitActor = Trace( HitLocation, HitNormal, DropLoc + vect(0,0,4096), DropLoc, FALSE, vect(40,40,1) );
		if( HitActor == None )
		{
			return TRUE;
		}
	}
	return FALSE;
}


function SpawnDropPod( const class<NanoPawnBase> NanoPawnClass )
{
	local NanoProj_DropPod Pod;
	local Vector DropPodLandingSpot;

	DropPodLandingSpot = FindSpawnLocation_DropPod( NanoPawnClass );

	if( VSize(DropPodLandingSpot) == 0.0f )
	{
		`NPESLog( "Unable to find valid SpawnDropPod Landing Spot" );
		return;
	}


	if( IsValidDropPodLandingSpot( DropPodLandingSpot ) == FALSE )
	{
		return;
	}

	Pod = Spawn( class'NanoProj_DropPod',,, DropPodLandingSpot + vect(0,0,4096), Rotator(vect(0,0,-1)) );
	if( Pod != None )
	{
		Pod.SpawnClass = string(NanoPawnClass);
		Pod.SetPhysics( PHYS_Falling );
		Pod.SpawnDecalActor( DropPodLandingSpot );
	}
}


/** This will look at all of the active AI and see which should not be out and about at the current chaos level **/
final function PossiblySendAIsHomeDueChaosTierChange()
{
	local NanoPawn NP;
	local EnemySpawnDatum ESD;

	foreach AllActors( class'NanoPawn', NP )
	{
		if( NanoAI(NP.Controller) == none )
		{
			continue;
		}

		ESD = GetEnemySpawnDatum( NP.Class.Name );


		// this probably needs to change to be
		// check to see if tier 0 then send home
		// check to see if current tier is higher than max tier and send home
		// and don't worry about min tier as we can spawn guys from NDPs outside of tier ranges

		if( ( ESD.MinChaosTier <= CurrChaosTier ) && ( CurrChaosTier <= ESD.MaxChaosTier ) )
		{
			`NPESLog( "PossiblySendAIsHomeDueChaosTierChange SAFE:" @ NP @ NP.Class.Name );
		}
		else
		{
			// KILL HIM!
			`NPESLog( "PossiblySendAIsHomeDueChaosTierChange KILL:" @ NP @ NP.Class.Name  );
		//	NP.Destroy(); // just destroy for now we will make them walk back to a point and then despawn with a a NanoAICmd next
		}
	}
}


/** 
 *  So we want to have the pawns spawn only when there are tattlers near the player and they are alert.
 *  
 **/
function bool AreTattlersAlertAndCanSeeThePlayer()
{
    local NanoPawn_MetaCorp_SentryBotBase Tattler;

	foreach WorldInfo.AllPawns( class'NanoPawn_MetaCorp_SentryBotBase', Tattler )
	{
        //`log( Tattler @ "Focus:" @ NanoPawn_RebelsBase(Tattler.Controller.Focus) @ Tattler.Controller.GetStateName() @ VSize( Tattler.Location - Tattler.Controller.Focus.Location ) );
			// so no if we are moderately close to the player and alert
           if( 
			   ( NanoPawn_RebelsBase(Tattler.Controller.Focus) != none ) 
            && ( Tattler.Controller.IsInState( 'Alert' ) == TRUE )
			&& ( VSize( Tattler.Location - Tattler.Controller.Focus.Location ) < DistanceTattlersAreFromPlayerForSpawningToOccur )
			)
		{
            return TRUE;
		}
	}

	return FALSE;
}


function vector FindSpawnLocation_Rooftop( const class<NanoPawnBase> PawnClassToSpawn )
{
	local vector Retval;

	local float MaxDistance, MinDistance;
	//local float HardLimitOnPathDistance;
	local Vector CanNotSeeThisLocation;
	local Rotator PlayerRotation;
	local bool bFoundPath;
	local vector SearchForRooftopPylonsExtent;

	local NavMeshGoal_GenericFilterContainer GFC;


	//// Set Params for all of the Constraints/Goals

	MaxDistance = ChaosTierSpawnData[CurrChaosTier].Cloud_MaxSpawnDistance_Rooftops;
	//HardLimitOnPathDistance = 8192;
	MinDistance = ChaosTierSpawnData[CurrChaosTier].Cloud_MinSpawnDistance_Rooftops;
	CanNotSeeThisLocation = GetPlayerLocation();
	PlayerRotation = GetPlayerRotation();
	SearchForRooftopPylonsExtent = vect(8192.0f,8192.0f,8192.0f);

	// So here we need to update our self to fill in the data the Interface_NavigationHandle data desires
	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * PawnClassToSpawn.default.CylinderComponent.CollisionHeight
		;

	NavHandle_CurrSearchStart = CanNotSeeThisLocation;

	NavHandle_MaxDropHeight = 0.0f;

	//`log( "NavHandle_CurrEnemySearchExtent" @ NavHandle_CurrEnemySearchExtent );


	//MyNavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
    //MyNavigationHandle.bUltraVerbosePathDebugging = TRUE;


	`NPESLog( "FindSpawnLocation_Rooftop" );


	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)

	// spawn somewhere within this envelope
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, CanNotSeeThisLocation, MaxDistance, MinDistance, TRUE,, TRUE );

	// be in front so we don't get guys spawning behind us all the time
	class'NavMeshPath_InFrontOf'.static.InFrontOf( MyNavigationHandle, CanNotSeeThisLocation, PlayerRotation );


	//// NavMeshGoals determine if a path/point is considered valid/invalid


	// !!!NOTE: this has to be first as currently on the first Goal gets the SeedWorkingSet called on it
	class'NavMeshGoal_SeedOnRooftop'.static.SeedOnRooftop( MyNavigationHandle, CanNotSeeThisLocation, PlayerRotation, SearchForRooftopPylonsExtent, FALSE );



	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);

	// only ever allow points that are in front of the player
	class'NavMeshGoalFilter_InFrontOf'.static.InFrontOf( GFC, CanNotSeeThisLocation, PlayerRotation );

	// only allow spawn points which are not near other NanoPawns (ai)
	class'NavMeshGoalFilter_NotNearOtherAI'.static.NotNearOtherAI( GFC, 512.0f );

	class'NavMeshGoalFilter_PolyEncompassesAI'.static.MakeSureAIFits( GFC, NavHandle_CurrEnemySearchExtent );

	// only allow spawn points which we can not see from CanNotSeeThisLocation  (this does a line check to put it towards the end)
	class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, CanNotSeeThisLocation );


	// this will actually record the "best" poly for us, which is the closest poly that meets the above Goals
	class'NavMeshGoal_ClosestSurvivingPoly'.static.ClosestSurvivingPoly( MyNavigationHandle, CanNotSeeThisLocation, 768.0f, NavHandle_CurrEnemySearchExtent );



	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
	bFoundPath = MyNavigationHandle.FindPath();
	`NPESLog( "   " @ `showvar(bFoundPath) );

	if( bFoundPath == TRUE )
	{

		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.GetBestUnfinishedPathPoint();
		//Retval += vect(0,0,128);

		//DrawDebugCoordinateSystem( Retval, rot(0,0,0), 10.0f, TRUE );
		//DrawDebugLine( Retval, Retval+vect(0,0,4024), 128, 128, 0, TRUE );

	}
	else
	{
		Retval = MyNavigationHandle.GetBestUnfinishedPathPoint();
		`log( "   " @ GetFuncName() @ "did not find a good path!!" );
	}


	`log( "   " @  GetFuncName() @ `showvar(Retval) );

	return Retval;
}



function vector FindSpawnLocation_DropPod( const class<NanoPawnBase> PawnClassToSpawn )
{
	return FindSpawnLocation_PlayerCannotSee( PawnClassToSpawn );
}



/**
 * This will look at the NavMesh and find a spawn point that can not be seen from the player's location.
 * 
 */
function vector FindSpawnLocation_PlayerCannotSee( const class<NanoPawnBase> PawnClassToSpawn )
{
	local vector Retval;

	local float MaxDistance, HardLimitOnPathDistance, MinDistance;
	local Vector CanNotSeeThisLocation;
	local Rotator PlayerRotation;
	local vector DefensivePointLoction;
	local bool bFoundPath;

	local NavMeshGoal_GenericFilterContainer GFC;


	//// Set Params for all of the Constraints/Goals

	MaxDistance = ChaosTierSpawnData[CurrChaosTier].Cloud_MaxSpawnDistance;
	HardLimitOnPathDistance = ChaosTierSpawnData[CurrChaosTier].Cloud_HardLimitOnPathDistance;
	MinDistance = ChaosTierSpawnData[CurrChaosTier].Cloud_MinSpawnDistance;

	CanNotSeeThisLocation = GetPlayerLocation();
	PlayerRotation = GetPlayerRotation();

	DefensivePointLoction = CanNotSeeThisLocation;


	// So here we need to update our self to fill in the data the Interface_NavigationHandle data desires
	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * PawnClassToSpawn.default.CylinderComponent.CollisionHeight
		;

	//`log( "NavHandle_CurrEnemySearchExtent" @ NavHandle_CurrEnemySearchExtent );

	NavHandle_CurrSearchStart = CanNotSeeThisLocation;

	NavHandle_MaxDropHeight = 0.0f;



	`NPESLog( "FindSpawnLocation_PlayerCannotSee" );


	//MyNavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;

	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)

	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, DefensivePointLoction, MaxDistance, MinDistance, FALSE,, TRUE );

	// hard limit on how long the path from the player to the spawn point is
	class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist( MyNavigationHandle, HardLimitOnPathDistance, FALSE );

	// be in front so we don't get guys spawning behind us all the time
	class'NavMeshPath_InFrontOf'.static.InFrontOf( MyNavigationHandle, CanNotSeeThisLocation, PlayerRotation );


	//// NavMeshGoal determine if a path/point is considered valid/invalid

	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);

	class'NavMeshGoalFilter_MinDistance'.static.MinDistanceFromLoc( GFC, CanNotSeeThisLocation, MinDistance );


	// only ever allow points that are in front of the player
	//class'NavMeshGoal_InFrontOf'.static.InFrontOf( MyNavigationHandle, CanNotSeeThisLocation, PlayerRotation );

	// check out http://www.falstad.com/dotproduct/ for a an easy to use applet to get decent numbers to try
	class'NavMeshGoalFilter_OutSideOfDotProductWedge'.static.OutsideOfDotProductWedge( GFC, CanNotSeeThisLocation, Cloud_PacManOrientation, ChaosTierSpawnData[CurrChaosTier].Cloud_PacManEpsilon );

	// only allow spawn points which we can not see from CanNotSeeThisLocation
	class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, CanNotSeeThisLocation );


	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
	bFoundPath = MyNavigationHandle.FindPath();
	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.PathCache_GetGoalPoint();

		if( VSize(Retval) == 0 )
		{
			Retval = GFC.GetGoalPoint();
		}

		`NPESLog( "Found path to this location:" @ `showvar(Retval) );
	}


	return Retval;
}





/**
 * This will look at the NavMesh and find a spawn point that can not be seen from the player's location.
 * 
 *
 */
function vector FindSpawnLocation_Cloud( const class<NanoPawnBase> PawnClassToSpawn )
{
	local vector Retval;

	local float MaxDistance, MinDistance;
	//local float HardLimitOnPathDistance;
	local Vector CanNotSeeThisLocation;
	local vector DefensivePointLoction;
	local Rotator PlayerRotation;
	local bool bFoundPath;

	local NavMeshGoal_GenericFilterContainer GFC;


	//// Set Params for all of the Constraints/Goals


	//`log( "==========================================FindSpawnLocation_Cloud==================================================" );

	MaxDistance = ChaosTierSpawnData[CurrChaosTier].Cloud_MaxSpawnDistance;
	//HardLimitOnPathDistance = Cloud_HardLimitOnPathDistance;

	if( NanoGRI(WorldInfo.GRI).NED.IsPlayerDoing( 'Escaping') == TRUE )
	{
		MinDistance = ChaosTierSpawnData[CurrChaosTier].Cloud_MinSpawnDistanceWhenEscaping;
	}
	else
	{
		MinDistance = ChaosTierSpawnData[CurrChaosTier].Cloud_MinSpawnDistance;
	}

	CanNotSeeThisLocation = GetPlayerLocation();
	PlayerRotation = GetPlayerRotation();

	DefensivePointLoction = CanNotSeeThisLocation;


	// So here we need to update our self to fill in the data the Interface_NavigationHandle data desires
	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * PawnClassToSpawn.default.CylinderComponent.CollisionHeight
		;

	//`log( "NavHandle_CurrEnemySearchExtent" @ NavHandle_CurrEnemySearchExtent );

	NavHandle_CurrSearchStart = CanNotSeeThisLocation;

	NavHandle_MaxDropHeight = 0.0f;


	`NPESLog( "FindSpawnLocation_Cloud" );


	//MyNavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
	//MyNavigationHandle.bUltraVerbosePathDebugging = TRUE;

	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)

	// hard limit on how long the path from the player to the spawn point is
	//class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist( MyNavigationHandle, HardLimitOnPathDistance, FALSE );

	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, DefensivePointLoction, MaxDistance, MinDistance, FALSE,, TRUE );


	//// NavMeshGoal determine if a path/point is considered valid/invalid

	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);

	class'NavMeshGoalFilter_MinPathDistance'.static.MustBeLongerPathThan( GFC, MinDistance );

	// check out http://www.falstad.com/dotproduct/ for a an easy to use applet to get decent numbers to try
	class'NavMeshGoalFilter_OutSideOfDotProductWedge'.static.OutsideOfDotProductWedge( GFC, CanNotSeeThisLocation, PlayerRotation, ChaosTierSpawnData[CurrChaosTier].Cloud_PacManEpsilon );

	// only allow spawn points which are not near other NanoPawns (ai)  (meh this is broken due to the broken order of calling evalgoal and then determinefinalgoal being called
	class'NavMeshGoalFilter_NotNearOtherAI'.static.NotNearOtherAI( GFC, ChaosTierSpawnData[CurrChaosTier].Cloud_MinDistanceToAnotherAI );

	class'NavMeshGoalFilter_PolyEncompassesAI'.static.MakeSureAIFits( GFC, NavHandle_CurrEnemySearchExtent );

	// only allow spawn points which we can not see from CanNotSeeThisLocation
	class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, CanNotSeeThisLocation );

	if( CanEnemiesSpawnOnRooftopsDueToCurrentTierSettings() == FALSE )
	{
		class'NavMeshGoalFilter_OnStreet'.static.MustBeOnStreet( GFC );
	}

	
	//// update our NavHandle temp data

	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
	bFoundPath = MyNavigationHandle.FindPath();
	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.PathCache_GetGoalPoint();

		if( VSize(Retval) == 0 )
		{
			Retval = GFC.GetGoalPoint();
		}

		`NPESLog( "Found path to this location:" @ `showvar(GFC) @ `showvar(bFoundPath) @ `showvar(Retval) @ `showvar(MyNavigationHandle.PathCache_GetGoalPoint()) @ `showvar(GFC.GetGoalPoint()) );

	}


	return Retval;
}



/**
 * This will look at the NavMesh and find a spawn point that can not be seen from the player's location.
 * 
 *
 */

// TODO  relook at this for using container
function vector FindSpawnLocation_NanoDefensivePoint( const class<NanoPawnBase> PawnClassToSpawn, NanoDefensivePoint NDP  )
{
	local vector Retval;

	local float MaxDistance, HardLimitOnPathDistance, MinDistance;
	local Vector CanNotSeeThisLocation;
	local vector DefensivePointLoction;
	//local Rotator PlayerRotation;
	local bool bFoundPath;
	local BiasedGoalActor BGA;
	local array<BiasedGoalActor> GoalList;
	local NanoReinforcementPoint RP;

	local NanoReinforcementPoint BestRP;
	local float BestRP_Distance;
	local float CurrRP_Distance;

	//local bool bAreAllGuardPointsManned;
	local bool bWaitingForTimeForAWave;

	local bool bWaveSpawningChecksPassed;

	local Actor ClosestRP;

	//// Set Params for all of the Constraints/Goals

	// use old values if we have an NDP
	MaxDistance = 15000;
	HardLimitOnPathDistance = 15000;
	MinDistance = 128;


	CanNotSeeThisLocation = GetPlayerLocation();
	//PlayerRotation = GetPlayerRotation();

	DefensivePointLoction = NDP.Location; 

	//// update our NavHandle temp data

	// So here we need to update our self to fill in the data the Interface_NavigationHandle data desires
	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * PawnClassToSpawn.default.CylinderComponent.CollisionHeight
		;

	//`log( "NavHandle_CurrEnemySearchExtent" @ NavHandle_CurrEnemySearchExtent );


	NavHandle_CurrSearchStart = DefensivePointLoction;


	NavHandle_MaxDropHeight = 0.0f;


	`NPESLog( "FindSpawnLocation_NanoDefensivePoint" );


	//MyNavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;

	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)

	// spawn somewhere within this envelope
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, DefensivePointLoction, MaxDistance, MinDistance, TRUE,, TRUE );

	// hard limit on how long the path from the player to the spawn point is
	class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist( MyNavigationHandle, HardLimitOnPathDistance, FALSE );


	//bAreAllGuardPointsManned = NDP.AreAllGuardPointsManned();

	foreach NDP.ReinforcementPoints( RP )
	{
		if( RP.bIsActive == TRUE )
		{
			bWaitingForTimeForAWave = ( `TimeSince(RP.LastWaveSentTime) > ( RP.MinTimeBetweenSendingWaves ) );

			bWaitingForTimeForAWave = bWaitingForTimeForAWave && ( WorldInfo.TimeSeconds > NDP.ActualTimeToSendReinforcements ) && ( NDP.ActualTimeToSendReinforcements > 0 );

			bWaveSpawningChecksPassed = ( (( NDP.bUseWaveSpawning == TRUE ) 
				&& ( bWaitingForTimeForAWave == TRUE )
				&& ( RP.NumAISpawnFrom <= NDP.NumPointsForAWave ) 
				&& ( ( RP.NumAISpawnFrom < RP.MaxAIPerWave ) || ( RP.MaxAIPerWave == 0 ) ) 
				&& ( NDP.bUnderAttack == TRUE ) )
				|| ( NDP.NumPointsForInitialSpawn > 0 )
				);

			//  				`Log( "    look at" @ RP
			// 					@ `showvar(bWaveSpawningChecksPassed)
			// 					@ ( NDP.bUseWaveSpawning == TRUE ) 
			// 					@ ( bWaitingForTimeForAWave == TRUE )
			// 					@ ( RP.NumAISpawnFrom <= NDP.NumPointsForAWave ) 
			// 					@ ( ( RP.NumAISpawnFrom < RP.MaxAIPerWave ) || ( RP.MaxAIPerWave == 0 ) ) 
			// 					@ ( `showvar(RP.NumAISpawnFrom) )
			// 					@ ( `showvar(RP.MaxAIPerWave) )
			// 					@ ( NDP.bUnderAttack == TRUE )
			// 					@ ( NDP.NumPointsForInitialSpawn > 0 )
			// 					//@ `showvar(bAreAllGuardPointsManned)
			// 					@ `showvar(bWaitingForTimeForAWave)
			// 					@ ( RP.NumAISpawnFrom <= NDP.NumPointsForAWave )
			// 					@ ( RP.NumAISpawnFrom < RP.MaxAIPerWave )
			// 					@ `showvar(RP.LastWaveSentTime)
			// 					@ `TimeSince(RP.LastWaveSentTime)
			// 					@ `showvar(RP.MinTimeBetweenSendingWaves)
			// 					@ `showvar(NDP.bUnderAttack)
			// 					@ `showvar(NDP.NumPointsForInitialSpawn)
			// 					);
			// if we have no waves and we have not spawned from this point
			// OR we have waves and there are still points for this RP
			if( ( NDP.bUseWaveSpawning == FALSE ) 
				|| ( bWaveSpawningChecksPassed == TRUE )
				//|| ( bAreAllGuardPointsManned == FALSE ) // we need to spawn more guys as the guard points are not all manned
				)
			{	
				if( ( bWaveSpawningChecksPassed == TRUE ) || ( NDP.bUseWaveSpawning == FALSE ) )
				{
					`NPESLog( " adding" @ `showvar(RP) );
					BGA.Goal = RP;
					BGA.ExtraCost = 0;
					GoalList.AddItem( BGA );
				}
			}
		}
	}

	// only ever allow points that are in front of the player
	//class'NavMeshGoal_InFrontOf'.static.InFrontOf( MyNavigationHandle, CanNotSeeThisLocation, PlayerRotation );

	// so if there are no ReinforcementPoints listed we want to spawn out of sight
	if( GoalList.Length > 0 )
	{
		class'NavMeshPath_Toward'.static.TowardPoint( MyNavigationHandle, CanNotSeeThisLocation );
		class'NavMeshGoal_ClosestActorInList'.static.ClosestActorInList( MyNavigationHandle, GoalList  );
	}
	else
	{
		// only allow spawn points which we can not see from CanNotSeeThisLocation
		// this is broken with ClosetActorInList 
		class'NavMeshGoal_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( MyNavigationHandle, CanNotSeeThisLocation );
	}




	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
	bFoundPath = MyNavigationHandle.FindPath( ClosestRP );
	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy

		if( NanoReinforcementPoint(ClosestRP) != none )
		{
			Retval = ClosestRP.Location;

			// hack for now for initial spawn
			if( NDP.NumPointsForInitialSpawn == 0 )
			{
				NanoReinforcementPoint(ClosestRP).NumAISpawnFrom++;
			}

			NanoReinforcementPoint(ClosestRP).LastWaveSentTime = WorldInfo.TimeSeconds;

			`NPESLog( "  SSSSSSSSSSSSSSSSSSSSSSSSSSSS  setting" @ NanoReinforcementPoint(ClosestRP) @ "to have an AI spawned from it" @ NanoReinforcementPoint(ClosestRP).NumAISpawnFrom );

		}
		else if( NDP.ReinforcementPoints.Length == 0 )
		{
			`NPESLog( "( NDP == None ) || ( NDP.ReinforcementPoints.Length == 0 )  CASE" );
			Retval = MyNavigationHandle.PathCache_GetGoalPoint();
		}
		// just randomly choose a RP because something just died??
		else
		{
			`NPESLog( "WTF!!?!?!?" @ `showvar(ClosestRP) );
			Retval = NDP.ReinforcementPoints[ Rand(NDP.ReinforcementPoints.Length) ].Location;
		}

		`NPESLog( "Found path to this location:" @ `showvar(Retval) );
	}
	else
	{
		// so for some reason we did not find a valid RP probably due to NavMeshGoal_ClosestActorInList being a lil insane

		`NPESLog( "--> !!!!!!!!!!!!! Doing Fallback ReinforcementPoints method as the PathFind failed." );

		BestRP_Distance = 9999999.0f;
		foreach NDP.ReinforcementPoints( RP )
		{
			if( RP.bIsActive == TRUE )
			{
				bWaitingForTimeForAWave = ( `TimeSince(RP.LastWaveSentTime) > ( RP.MinTimeBetweenSendingWaves ) );

				bWaitingForTimeForAWave = bWaitingForTimeForAWave && ( WorldInfo.TimeSeconds > NDP.ActualTimeToSendReinforcements );

				bWaveSpawningChecksPassed = ( ( NDP.bUseWaveSpawning == TRUE ) 
					&& ( bWaitingForTimeForAWave == TRUE )
					&& ( RP.NumAISpawnFrom <= NDP.NumPointsForAWave ) 
					&& ( ( RP.NumAISpawnFrom < RP.MaxAIPerWave ) || ( RP.MaxAIPerWave == 0 ) ) 
					&& ( NDP.bUnderAttack == TRUE )
					|| ( NDP.NumPointsForInitialSpawn > 0 )
					);

				if( ( NDP.bUseWaveSpawning == FALSE )
					|| ( bWaveSpawningChecksPassed == TRUE )
					)
				{	
					CurrRP_Distance = VSize(RP.Location - DefensivePointLoction);

					if( CurrRP_Distance < BestRP_Distance )
					{
						BestRP_Distance = CurrRP_Distance;
						BestRP = RP;

						`NPESLog( "  New Best RP" @ BestRP @ BestRP_Distance );
					}
				}
			}
		}

		if( BestRP != none )
		{
			// hack for now for initial spawn
			if( NDP.NumPointsForInitialSpawn == 0 )
			{
				BestRP.NumAISpawnFrom++;
			}

			BestRP.LastWaveSentTime = WorldInfo.TimeSeconds;

			Retval = BestRP.Location;
			`NPESLog( "  SSSSSSSSSSSSSSSSSSSSSSSSSSSS FALLBACK setting" @ BestRP @ "to have an AI spawned from it" @ BestRP.NumAISpawnFrom );
		}

	}

	return Retval;
}



/**
 * So the player can get to places where the tattlers are currently unable to get to (e.g. roofs, or other crazy places)
 * This will test whether or not any tattlers can get to the player.
 * 
 **/
function bool AreTattlersAbleToFindPlayer()
{
	local bool Retval;
	local NanoPawn_MetaCorp_SentryBotBase Tattler;
	local BiasedGoalActor BGA;
	local array<BiasedGoalActor> GoalList;
	local int NumAlert;
	local int TotalTattlers;

	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)
	
	class'NavMeshPath_Toward'.static.TowardPoint( MyNavigationHandle, GetPlayerLocation() );


	//// NavMeshGoal determine if a path/point is considered valid/invalid

	// find all of the tattlers and then add them to our list
	foreach WorldInfo.AllPawns( class'NanoPawn_MetaCorp_SentryBotBase', Tattler )
	{
		if( Tattler.bDeleteMe == FALSE )
		{
			TotalTattlers++;
			BGA.Goal = Tattler;
			BGA.ExtraCost = 0;
			GoalList.AddItem( BGA );
		}

		if( Tattler.Controller.GetStateName() == 'Alert' )
		{
			NumAlert++;
		}
	}

    class'NavMeshGoal_ClosestActorInList'.static.ClosestActorInList( MyNavigationHandle, GoalList );

	//// update our NavHandle temp data

	// So here we need to update our self to fill in the data the Interface_NavigationHandle data desires
    NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * class'NanoPawn_MetaCorp_SentryBotBase'.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * class'NanoPawn_MetaCorp_SentryBotBase'.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * class'NanoPawn_MetaCorp_SentryBotBase'.default.CylinderComponent.CollisionHeight
		;

	//`log( "NavHandle_CurrEnemySearchExtent" @ NavHandle_CurrEnemySearchExtent );

    NavHandle_CurrSearchStart = GetPlayerLocation();

    NavHandle_MaxDropHeight = 0.0f;


	Retval = MyNavigationHandle.FindPath() || ( ( NumAlert == 0 ) && ( TotalTattlers > 0 ) ); // tricky.  If there are no tattlers in alert then we return true so we don't say: false! spawn some tattlers

	//`NPESLog( "AreTattlersAbleToFindPlayer:" @ Retval @ NumAlert );


	return Retval;
}


/** This will get a location that the player can no see.  That can be pathed from to the player **/
function vector FindSpawnLocation_Tattler()
{
	local vector Retval;

	local float MaxDistance, HardLimitOnPathDistance, MinDistance;
	local Vector CanNotSeeThisLocation;
	local bool bFoundPath;

	local NavMeshGoal_GenericFilterContainer GFC;

	//// Set Params for all of the Constraints/Goals

	MaxDistance = 8192;
	HardLimitOnPathDistance = 8192;
	MinDistance = 1024;
	CanNotSeeThisLocation = GetPlayerLocation();


	// So here we need to update our self to fill in the data the Interface_NavigationHandle data desires
	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * class'NanoPawn_MetaCorp_SentryBotBase'.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * class'NanoPawn_MetaCorp_SentryBotBase'.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * class'NanoPawn_MetaCorp_SentryBotBase'.default.CylinderComponent.CollisionHeight
		;

	//`log( "NavHandle_CurrEnemySearchExtent" @ NavHandle_CurrEnemySearchExtent );

	NavHandle_CurrSearchStart = CanNotSeeThisLocation;

	NavHandle_MaxDropHeight = 0.0f;



	`NPESLog( "FindSpawnLocation_Rooftop" );


	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)

	// spawn somewhere within this envelope
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, CanNotSeeThisLocation, MaxDistance, MinDistance, TRUE,, TRUE );

	// hard limit on how long the path from the player to the spawn point is
	class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist( MyNavigationHandle, HardLimitOnPathDistance, FALSE );
		

	//// NavMeshGoal determine if a path/point is considered valid/invalid

	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);


	// only allow spawn points which we can not see from CanNotSeeThisLocation
	class'NavMeshGoalFilter_MinDistance'.static.MinDistanceFromLoc( GFC, CanNotSeeThisLocation, MinDistance );

	// only allow spawn points which we can not see from CanNotSeeThisLocation
	class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, CanNotSeeThisLocation );



	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
    bFoundPath = MyNavigationHandle.FindPath();
	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.PathCache_GetGoalPoint();
		
		if( VSize(Retval) == 0 )
		{
			Retval = GFC.GetGoalPoint();
		}

	}


	//`NPESLog( "Spawning a Tattler here:" @ Retval );

	//DrawDebugLine( CanNotSeeThisLocation, Retval, 255, 0, 0, TRUE );
	//DrawDebugCoordinateSystem( Retval, rot(0,0,0), 50.0f, TRUE );


	return Retval;
}

/** This will get a location that the player can not see.  That can be pathed from to the player **/
function vector FindSpawnLocation_PoliceCar(  const class<NanoPawnBase> PawnClassToSpawn )
{
	local vector Retval;

	local float MaxDistance, MinDistance;
	//local float HardLimitOnPathDistance;
	local Vector PlayerLocation;
	//local rotator PlayerRotation;
	local bool bFoundPath;

	local NavMeshGoal_GenericFilterContainer GFC;


	//// Set Params for all of the Constraints/Goals


	MaxDistance = PoliceCar_SpawnDistance_Max;
	//HardLimitOnPathDistance = Cloud_HardLimitOnPathDistance;
	MinDistance = PoliceCar_SpawnDistance_Min;
	PlayerLocation = GetPlayerLocation();
	//PlayerRotation = GetPlayerRotation();

	// So here we need to update our self to fill in the data the Interface_NavigationHandle data desires
	NavHandle_CurrEnemySearchExtent =
		vect(1,0,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * PawnClassToSpawn.default.CylinderComponent.CollisionHeight
		;
	NavHandle_CurrSearchStart = PlayerLocation;
	NavHandle_MaxDropHeight = 0.0f;



	`NPESLog( "FindSpawnLocation_PoliceCar" );

	//MyNavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
	//MyNavigationHandle.bUltraVerbosePathDebugging = TRUE;
		

	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)


	// spawn somewhere within this envelope
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, PlayerLocation, MaxDistance, MinDistance, TRUE,, TRUE );

	class'NavMeshPath_NotNearOtherPoliceCars'.static.NotNearOtherPoliceCars( MyNavigationHandle, 2048 );



	//// NavMeshGoals determine if a path/point is considered valid/invalid

	// !!!NOTE: this has to be first as currently on the first Goal gets the SeedWorkingSet called on it
	// only ever allow points that are on the street
	//	class'NavMeshGoal_OnStreet'.static.MustBeOnStreet( MyNavigationHandle, PlayerLocation, PlayerRotation, vect(1.0f,1.0f,1.0f)*MaxDistance, FALSE );


	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);

	class'NavMeshGoalFilter_MinPathDistance'.static.MustBeLongerPathThan( GFC, MinDistance );
	class'NavMeshGoalFilter_MinDistance'.static.MinDistanceFromLoc( GFC, PlayerLocation, MinDistance );

	// check out http://www.falstad.com/dotproduct/ for a an easy to use applet to get decent numbers to try
	//class'NavMeshGoal_OutsideOfDotProductWedge'.static.OutsideOfDotProductWedge( MyNavigationHandle, PlayerLocation, PlayerRotation, ChaosTierSpawnData[CurrChaosTier].Cloud_PacManEpsilon );

	// only allow spawn points which are not near other NanoPawns (ai)
	class'NavMeshGoalFilter_NotNearOtherAI'.static.NotNearOtherAI( GFC, 2048 );

	class'NavMeshGoalFilter_PolyEncompassesAI'.static.MakeSureAIFits( GFC, NavHandle_CurrEnemySearchExtent);

	// only allow spawn points which we can not see from CanNotSeeThisLocation
	class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, PlayerLocation );


	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
    bFoundPath = MyNavigationHandle.FindPath();
	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.PathCache_GetGoalPoint();

		if( VSize(Retval) == 0 )
		{
			Retval = GFC.GetGoalPoint();
		}

		`NPESLog( "Found path to this location:" @ `showvar(Retval) );
	}
	else
	{
		Retval = MyNavigationHandle.GetBestUnfinishedPathPoint();
		`NPESLog( "    " @  "PoliceCar:  no path found for policecar spawning" @ `showvar(Retval) );
	}


	return Retval;
}


/**
 * This will look at the NavMesh and find a spawn point that can not be seen from the player's location.
 * 
 *
 * UGHHHHHHHHHHHH optional <param> lameness time for now :-(
 */
function vector FindSpawnLocation_Messenger( const class<NanoPawnBase> PawnClassToSpawn, const vector SpawnLocation, optional const vector AdditionalOutOfViewFromLocation, optional const Vector OverrideExtent )
{
	local vector Retval;
	local float MaxDistance, HardLimitOnPathDistance, MinDistance;
	local Vector PlayerLocation;
	//local Rotator PlayerRotation;
	local bool bFoundPath;

	local NavMeshGoal_GenericFilterContainer GFC;


	//// Set Params for all of the Constraints/Goals

    MaxDistance = 16384;
	HardLimitOnPathDistance = 16384;
	MinDistance = 1024;
	PlayerLocation = GetPlayerLocation();
	//PlayerRotation = GetPlayerRotation();

	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * PawnClassToSpawn.default.CylinderComponent.CollisionHeight
		;

	//`NPESLog( "NavHandle_CurrEnemySearchExtent" @ NavHandle_CurrEnemySearchExtent );

	NavHandle_CurrSearchStart = SpawnLocation;

	NavHandle_MaxDropHeight = 0.0f;

	//`NPESLog( "SpawnLocation 0" @ SpawnLocation @ NavHandle_CurrSearchStart @ Retval );


	`NPESLog( "FindSpawnLocation_Messenger" );


	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)

	// spawn somewhere within this envelope
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, SpawnLocation, MaxDistance, MinDistance, TRUE,, TRUE );

	// hard limit on how long the path from the player to the spawn point is
	class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist( MyNavigationHandle, HardLimitOnPathDistance, FALSE );
		

	//// NavMeshGoal determine if a path/point is considered valid/invalid

	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);

	// only allow spawn points which we can not see from CanNotSeeThisLocation
	class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, SpawnLocation );
    class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, PlayerLocation );

	if( VSize(AdditionalOutOfViewFromLocation) != 0 )
	{
        class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, AdditionalOutOfViewFromLocation );
	}

    if( VSize(OverrideExtent) != 0 )
	{
		class'NavMeshGoalFilter_PolyEncompassesAI'.static.MakeSureAIFits( GFC, OverrideExtent );
	}



	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
    bFoundPath = MyNavigationHandle.FindPath();
	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.PathCache_GetGoalPoint();

		if( VSize(Retval) == 0 )
		{
			Retval = GFC.GetGoalPoint();
		}
	}


    `NPESLog( "SpawnLocation 1" @ SpawnLocation @ NavHandle_CurrSearchStart @ Retval );

	return Retval;
}





/**
 * This will look at the NavMesh and find a spawn point that can not be seen from the player's location.
 * 
 *
 */
function vector FindLocation_MessengerDestination( const class<NanoPawnBase> PawnClassToSpawn, const vector SpawnLocation )
{
	local vector Retval;

	local float MaxDistance, HardLimitOnPathDistance, MinDistance;
	local Vector PlayerLocation;
	local Rotator PlayerRotation;
	local bool bFoundPath;

	local NavMeshGoal_GenericFilterContainer GFC;


	//// Set Params for all of the Constraints/Goals

	MaxDistance = 32768;
	HardLimitOnPathDistance = 32768;
	MinDistance = 8196;
	PlayerLocation = GetPlayerLocation();
	PlayerRotation = GetPlayerRotation();

	// So here we need to update our self to fill in the data the Interface_NavigationHandle data desires
	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,1,0) * PawnClassToSpawn.default.CylinderComponent.CollisionRadius +
		vect(0,0,1) * PawnClassToSpawn.default.CylinderComponent.CollisionHeight
		;

	//`NPESLog( "NavHandle_CurrEnemySearchExtent" @ NavHandle_CurrEnemySearchExtent );

	NavHandle_CurrSearchStart = SpawnLocation;

	NavHandle_MaxDropHeight = 0.0f;


	//`NPESLog( "SpawnLocation 0" @ SpawnLocation @ NavHandle_CurrSearchStart );


	`NPESLog( "FindLocation_MessengerDestination" );




	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)

	// spawn somewhere within this envelope
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, SpawnLocation, MaxDistance, MinDistance, TRUE,, TRUE );

	// hard limit on how long the path from the player to the spawn point is
	class'NavMeshPath_WithinTraversalDist'.static.DontExceedMaxDist( MyNavigationHandle, HardLimitOnPathDistance, FALSE );
		

	// be in front so we don't get guys spawning behind us all the time
	class'NavMeshPath_InFrontOf'.static.InFrontOf( MyNavigationHandle, PlayerLocation, PlayerRotation );



	//// NavMeshGoal determine if a path/point is considered valid/invalid
	
	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);

	// only allow spawn points which we can not see from CanNotSeeThisLocation
    class'NavMeshGoalFilter_MinPathDistance'.static.MustBeLongerPathThan( GFC, 10000 );

    class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, PlayerLocation );

	// only ever allow points that are in front of the player
	class'NavMeshGoalFilter_InFrontOf'.static.InFrontOf( GFC, PlayerLocation, PlayerRotation );



	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
    bFoundPath = MyNavigationHandle.FindPath();
	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.PathCache_GetGoalPoint();

		if( VSize(Retval) == 0 )
		{
			Retval = GFC.GetGoalPoint();
		}
	}
	else
	{
		`NPESLog( "find path failed" );
	}

	
	return Retval;
}


function SendAllAIToANonVisibleSpotToDespawn()
{
	local NanoAI AI;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		AI.Enemy = None;
		AI.Focus = None;

		// if the pawn is guarding and has not ever been hurt then we don't want to despawn him
		if( AI.FindCommandOfClass( class'NanoAIAction_DefensiveBase' ) != None )
		{
			// if we have not been damaged
			if( ( AI.Enemy == None ) && ( AI.GetHealthPercentage() == 1.0f ) )
			{
				continue;
			}
		}

		// hack
		if( NanoAI_SentryTurret(AI) != None )
		{
			continue;
		}

		if( NanoAI_PoliceCar(AI) != None )
		{
			continue;
		}

		// reset AI's AIActions which may have been modified (e.g. to say if you are holding a gun or what not)
		AI.ListOfAIActionsThisAICanDo.Length = 0;
		AI.ListOfAIActionsThisAICanDo = AI.Default.ListOfAIActionsThisAICanDo;

		// hack:  don't kill off police cars

		// if we have not been rendered in 2 seconds then just kill them off
		if( `TimeSince(AI.Pawn.LastRenderTime) > 2.0f )
		{
			`NPESLog( "SendAllAIToANonVisibleSpotToDespawn not rendered recently killing off" @ `showvar(AI) @ `showvar(AI.Pawn.LastRenderTime) );
			KillOffAIWithNDT_KilledByProceduralSpawner( AI );
		}

		// add the despawn action
		AI.ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_Idle_MoveToUnseenLocationAndDespawn' );

	}
}


function vector FindLocation_OutOfSightToDespawn( NanoPawn NP )
{
	local vector Retval;

	local float MaxDistance, MinDistance;
	local Vector CanNotSeeThisLocation;
	local bool bFoundPath;

	local NavMeshGoal_GenericFilterContainer GFC;



	//// Set Params for all of the Constraints/Goals

	MaxDistance = 20192;
	//HardLimitOnPathDistance = 8192;
	MinDistance = 4096;
	CanNotSeeThisLocation = GetPlayerLocation();

	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * NP.CylinderComponent.CollisionRadius +
		vect(0,1,0) * NP.CylinderComponent.CollisionRadius +
		vect(0,0,1) * NP.CylinderComponent.CollisionHeight
		;


	`NPESLog( "FindLocation_OutOfSightToDespawn" );


	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)


	// spawn somewhere within this envelope
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, CanNotSeeThisLocation, MaxDistance, MinDistance, TRUE,, TRUE );


	//// NavMeshGoals determine if a path/point is considered valid/invalid

	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);


	class'NavMeshGoalFilter_MinDistance'.static.MinDistanceFromLoc( GFC, CanNotSeeThisLocation, MinDistance );

	// only allow spawn points which we can not see from CanNotSeeThisLocation  (this does a line check to put it towards the end)
	class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, CanNotSeeThisLocation );



	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
	bFoundPath = MyNavigationHandle.FindPath();
	`NPESLog( "   " @ `showvar(bFoundPath) );

	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.PathCache_GetGoalPoint();

		if( VSize(Retval) == 0 )
		{
			Retval = GFC.GetGoalPoint();
		}
	}

	//`log( " " @ `showvar(Retval) );

	return Retval;
}



function vector FindLocation_OutOfSightFromPawn( NanoPawn NP )
{
	local vector Retval;

	local float MaxDistance, MinDistance;
	local Vector CanNotSeeThisLocation;
	local Rotator PlayerRotation;
	local bool bFoundPath;

	local NavMeshGoal_GenericFilterContainer GFC;


	//// Set Params for all of the Constraints/Goals

	MaxDistance = 8192;
	//HardLimitOnPathDistance = 8192;
	MinDistance = 1024;
	CanNotSeeThisLocation = GetPlayerLocation();
	PlayerRotation = GetPlayerRotation();

	NavHandle_CurrEnemySearchExtent = 
		vect(1,0,0) * NP.CylinderComponent.CollisionRadius +
		vect(0,1,0) * NP.CylinderComponent.CollisionRadius +
		vect(0,0,1) * NP.CylinderComponent.CollisionHeight
		;


	`NPESLog( "FindLocation_OutOfSightFromPawn" );


	//// NavMeshPaths "shape" how you want to traverse the navmesh from your starting point.  (e.g. a cone, radius, BFS, DFS) (They give you the set polys and edges to evaluate)

	// spawn somewhere within this envelope
	class'NavMeshPath_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc( MyNavigationHandle, CanNotSeeThisLocation, MaxDistance, MinDistance, TRUE,, TRUE );

	// be in front so we don't get guys spawning behind us all the time
	class'NavMeshPath_InFrontOf'.static.InFrontOf( MyNavigationHandle, CanNotSeeThisLocation, PlayerRotation );



	//// NavMeshGoals determine if a path/point is considered valid/invalid

	GFC = class'NavMeshGoal_GenericFilterContainer'.static.CreateAndAddFilterToNavHandle( MyNavigationHandle);


	class'NavMeshGoalFilter_MinDistance'.static.MinDistanceFromLoc( GFC, CanNotSeeThisLocation, MinDistance );

	// only allow spawn points which we can not see from CanNotSeeThisLocation  (this does a line check to put it towards the end)
	class'NavMeshGoalFilter_OutOfViewFrom'.static.MustBeHiddenFromThisPoint( GFC, CanNotSeeThisLocation );

	// this will actually record the "best" poly for us, which is the closest poly that meets the above Goals
	class'NavMeshGoal_ClosestSurvivingPoly'.static.ClosestSurvivingPoly( MyNavigationHandle, CanNotSeeThisLocation, 768.0f, NavHandle_CurrEnemySearchExtent );


	// so now that you have all of the path constraints and goals added to the NavHandle you MUST call FindPath
	// FindPath will clear all of the above objects which are attached to the NavHandle.
	bFoundPath = MyNavigationHandle.FindPath();
	`NPESLog( "   " @ `showvar(bFoundPath) );

	if( bFoundPath == TRUE )
	{
		// once FindPath has been called then the NavHandle has a bunch of internal data that we can query / copy / use
		// the "best path" has a GoalPoint which we can get here
		// this is where we want to spawn our guy
		Retval = MyNavigationHandle.GetBestUnfinishedPathPoint();
	}

	//`log( " " @ `showvar(Retval) );

	return Retval;

}


function FindAllNearbyMetaCorpCrowdMembersAndSpawnAI()
{
	local NanoCrowd_PedestrianBase Ped;
	local vector PlayerLocation;
	
	PlayerLocation = GetPlayerLocation();

	// we can't use VisibleCollidingActors as agents around corners will not be found
	foreach DynamicActors( class'NanoCrowd_PedestrianBase', Ped )
	{
		if( VSize(PlayerLocation-Ped.Location) < RadiusToFindCrowdMembersToTurnIntoAI )
		{
			Ped.PossiblySpawnAIFromCrowd();
		}
	}


	// okie since we turned everyone into a crowd so now kill off the crowd members that are far off
	foreach DynamicActors( class'NanoCrowd_PedestrianBase', Ped )
	{
		if( Ped.bShouldSpawnAnAIWhenShot == TRUE )
		{
			//`log( "Killing off" @ `showvar(Ped) );
			Ped.KillAgent();
		}
	}

}


final function float GetHotZoneRadius()
{
	return ChaosTierSpawnData[CurrChaosTier].HotZoneRadius;
}


/** Find a good patrol location  (eventually will bias it towards going past/near the player **/
function vector PickAPatrolLocation()
{
	local vector Retval;


	Retval = FindSpawnLocation_PoliceCar( CreateNanoPawnClass( 'NanoPawn_MetaCorp_PoliceCar' ) );

	return Retval;
}


/** This will update the hotzone location and pacman orientation **/
function UpdateHotZoneLocation()
{
	Cloud_PacManCenter = NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location;
	TheHotZoneCenter.SetLocation( Cloud_PacManCenter );

	Cloud_PacManOrientation = RotRand();
	Cloud_PacManOrientation.Pitch = 0;
}

function PollForValueFromDB_MobileResponse()
{
	local NanoGRI NGRI;
	local NanoMCP MCP;
	local string UserName;
	local String CurrValueString;
	local NanoHUD_Base TheHUD;
	local SoundCue RequestSoundType;
	local String RequestType;

	//`log( self @ GetFuncName() );

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	MCP = NGRI.MCP;
	UserName = class'NanoMCPKeys'.default.MobileUserID; // class'NanoMobileTypes'.static.GetLocalPlayerUserName();

	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.RespondedToCallForHelp_Type, CurrValueString );

	//`log( `showvar(CurrValueString) @ `showvar(bMobileUserRespondedWithHelp) @ `showvar(MobileReponseType_Override) );

	if( ( CurrValueString != "" )
		&& ( bMobileUserRespondedWithHelp == FALSE )
		)
	{
		
		MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.LyrikNeedsMobileHelp, RequestType );

		`log( `showvar(RequestType) );

		if( RequestType == "RequestUrgent" )
		{
			RequestSoundType = MobileRequest_Confirm_Urgent;
		}
		else
		{
			RequestSoundType = MobileRequest_Confirm_Normal;
		}


		TheHUD = NanoHUD_Base(NanoGRI(WorldInfo.GRI).GetNanoPC().myHUD);
		TheHUD.SlideTextMessage( "MOBILE HELP RECEIVED: " $ CurrValueString, 2.0f, class'Engine'.static.GetMediumFont(), RequestSoundType  );

		MobileReponseType_Override = name(CurrValueString);
		bMobileUserRespondedWithHelp = TRUE;

		MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.RespondedToCallForHelp_Color, CurrValueString );
		MobileReponseType_Color = CurrValueString;

		`log( " Received values from DB" @ `showvar(MobileReponseType_Override) @ `showvar(MobileReponseType_Color) );
		
		// reset the DB now
		MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.LyrikNeedsMobileHelp, "" );
		MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.RespondedToCallForHelp_Type, "" );
	}

}


function ResetMobileHelpVars()
{
	bMobileUserRespondedWithHelp = FALSE;

	MobileReponseType_Override = '';
}




defaultproperties
{
	bDoEnemyManagementRequireTattlerSight=FALSE
	bDoEnemyManagement=TRUE
	bDoEnemyManagement_DefensivePoints=TRUE
	bDoEnemyManagement_Rooftops=TRUE
	bDoEnemyCleanUp=TRUE
	RadiusToFindCrowdMembersToTurnIntoAI=4096.0f
	SpawnDelayTimeAmount=5.0f

	// Mobile Request Sounds
	MobileRequest_Request_Normal=SoundCue'Dialog_Temp.CallForBackup.Backup_RequestNormal_01_Cue'
	MobileRequest_Confirm_Normal=SoundCue'Dialog_Temp.CallForBackup.Backup_ConfirmNormal_01_Cue'

	MobileRequest_Request_Urgent=SoundCue'Dialog_Temp.CallForBackup.Backup_RequestUrgent_01_Cue'
	MobileRequest_Confirm_Urgent=SoundCue'Dialog_Temp.CallForBackup.Backup_ConfirmUrgent_01_Cue'

	MobileRequest_RebelsAppearInWorld=SoundCue'Dialog_Temp.CallForBackup.Backup_Crowd_Appears_Stereo_01_Cue'



}


// need to make a constraint to make it so we don't spawn dudes where guys previously have spawned.   

