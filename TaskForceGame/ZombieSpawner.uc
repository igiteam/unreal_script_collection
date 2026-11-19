class ZombieSpawner extends Actor
	hidecategories ( Actor, Advanced, Collision, Display, Lighting, LightColor, Karma, Force, Sound )
	placeable;


// spawner flags
var( ) bool bSpawnOnlyOnce;             // will destroy after successful spawning
var( ) bool bNoCollisionFail;           // uh.. dude will spawn inside walls when this is true

// AI flags to copy over
var( ) bool bCivilian;                  // is a civilian bot
var( ) bool bCivilianShouldSit;         // this civilian should sit
var( ) bool bCanPatrol;                 // is a patrol bot
var( ) bool bCanBeSearched;             // does he drop ammo
var( ) bool bStartAlert;                // Set to true when the AI should start alerted to the player
var( ) bool bStartKamikaze;             // Set to true when the AI should start out pursuing the player
var( ) float Aim_WorstAccuracy;         // low end accuracy rating
var( ) float Aim_BestAccuracy;          // high end accuracy rating
var( ) float SpawnDelay;                // time after trigger before spawning
var( ) name PawnTag;                    // tag of the pawn that will be created
var( ) name DeathEvent;                 // event to trigger when the pawn created has died
var( ) name AIScriptTag;                // tag of the AIScript to link with when spawned
var( ) name AIManagerTag;               // tag of the ZombieAIManager to link with when spawned
var( ) name SeeEvent;                   // Event that the spawned AI uses when it sees a player

var( ) class<ZombieWeapon> BotWeapon;
var( ) class<ZombieWeapon> BotPistol;
var( ) class<ZombieWeapon> BotGrenade;
var( ) class<ZombieWeapon> BotKnife;

// pawn type to spawn
var( ) EZombiePawnType PawnType;            // type of pawn

var( Sensory ) float IdleSightRadius;       // sight radius when idle
var( Sensory ) float AlertSightRadius;      // sight radius when alert
var( Sensory ) float IdleHearingRadius;     // hearing radius when idle
var( Sensory ) float AlertHearingRadius;    // hearing radius when alert
var( Sensory ) float IdlePeripheralVision;  // view angle when idle
var( Sensory ) float AlertPeripheralVision; // view angle when Alert

// array over takeover scripts to be notified when spawn is created
var array<ZombieTakeoverScript>	ImpendingTakeover;
// internal AIScript pointer to the AIScript who's tag matches AIScriptTag
var AIScript         MyScript;
var ZombieAIManager  AIManager;
var bool             bSpawned;

event PreBeginPlay()
{
	class'ZombieGame.ZombieBipedPawn'.static.SetUpPawn(PawnType, none);
	
	if (BotWeapon != none)
	{
		BotWeapon.static.PreCacheWeapAssets();
	}
	
	if (BotPistol != none)
	{
		BotPistol.static.PreCacheWeapAssets();
	}
	
	if (BotGrenade != none)
	{
		BotGrenade.static.PreCacheWeapAssets();
	}
	
	if (BotKnife != none)
	{
		BotKnife.static.PreCacheWeapAssets();
	}
}

event PostBeginPlay ( )
{
	Super.PostBeginPlay ( );

	// try to locate the AIScript if set
	if ( AIScriptTag != '' )
	{
		foreach AllActors ( class'AIScript', MyScript, AIScriptTag )
		{
			break;
		}
	}

	// try to location the AIManager if set 
	if ( AIManagerTag != '' )
	{
		foreach AllActors ( class'ZombieAIManager', AIManager, AIManagerTag )
		{
			break;
		}
	}
}

// called when this actor's tag is triggered
event Trigger ( Actor Other, Pawn EventInstigator )
{
	// goto state spawning
	GotoState ( 'Spawning' );
}

// creates the pawn and his brain
function DoSpawn( )
{
	local ZombieBipedPawn            newPawn;
	local ZombieBot                  newBotAI;
	local class<ZombieBipedPawn>     newPawnClass;
	local int                        Index;

	if( bSpawned ) return;

	newPawnClass = class'ZombieGame.ZombieBipedPawn';

	// create the pawn
	newPawn = Spawn( newPawnClass, , PawnTag, , Rotation, bNoCollisionFail );
	// check for error
	if( newPawn == None )
	{
		log( "DoSpawn - Spawning of"@newPawnClass@"type pawn failed - spawn failed" );
		bSpawned=true;
		return;
	}

	// configure mesh, skins, and attachments
	class'ZombieGame.ZombieBipedPawn'.static.SetUpPawn(PawnType, newPawn);

	// store the death event
	newPawn.Event = DeathEvent;

	// Add weapons
	newPawn.BotWeaponClass[0] = BotWeapon;
	newPawn.BotWeaponClass[1] = BotPistol;
	newPawn.BotWeaponClass[2] = BotGrenade;
	newPawn.BotWeaponClass[3] = BotKnife;
	
	newPawn.AddWeaponLoadout();

	newPawn.bCivilianShouldSit = bCivilianShouldSit;
	// Give him a brain
	newBotAI = ZombieBot( newPawn.Spawn ( newPawn.ControllerClass ) );

	// store the see event
	newBotAI.SeeEvent = SeeEvent;

	// check for error
	if( newBotAI == None )
	{
		log( "DoSpawn - Spawning of"@newPawn.ControllerClass@"for pawn"@newPawn@"failed - spawn failed." );
		newPawn.Destroy( );
		return;
	}

	// Initialize the Bot with settings from the spawner
	newBotAI.bCivilian = bCivilian;
	newBotAI.bCanPatrol = bCanPatrol;
	newBotAI.WorstAccuracy = Aim_WorstAccuracy;
	newBotAI.BestAccuracy = Aim_BestAccuracy;
	newBotAI.bStartAlert = bStartAlert;
	newBotAI.bStartKamikaze = bStartKamikaze;

	newPawn.beenSearched = (!bCanBeSearched);

	// Allow the brain to take control of the pawn
	newBotAI.Possess( newPawn );

	// add to list
	Level.Bots[Level.Bots.Length] = newBotAI;

	// link up
	newBotAI.AIManager = AIManager;
	
	// store sensory values
	newBotAI.IdleSightRadius = IdleSightRadius;
	newBotAI.AlertSightRadius = AlertSightRadius;
	newBotAI.IdleHearingRadius = IdleHearingRadius;
	newBotAI.AlertHearingRadius = AlertHearingRadius;
	newBotAI.IdlePeripheralVision = IdlePeripheralVision;
	newBotAI.AlertPeripheralVision = AlertPeripheralVision;

	// start idle
	newBotAI.SetIdle();
	// pick weapon
	newBotAI.SwitchToBestWeapon();

	// Notify Takeover scripts
	for( Index = 0; Index < ImpendingTakeover.Length; Index++ )
	{
		// make sure it's a valid takeover script
		if( ImpendingTakeover[Index] != None )
		{
			// store pawn as PawnToControl
			ImpendingTakeover[Index].InternalPawnToControl = newPawn;
		}
	}

	// if I have a script
	if( MyScript != None )
	{
		// use it
		MyScript.TakeOver( newPawn );
	}

	// Spawn only once?
	if( bSpawnOnlyOnce )
	{
		// we are done
		bSpawned=true;
		//Destroy ( );
	}
}

// spawning state
state Spawning
{

Begin:

	// if we should wait before spawning, do so
	if( SpawnDelay > 0.0 )
	{
		Sleep( SpawnDelay );
	}
	// now spawn the little guy
	DoSpawn();

	GotoState('');
}


// Decompiled with UE Explorer.
defaultproperties
{
    bSpawnOnlyOnce=true
    bCanBeSearched=true
    Aim_WorstAccuracy=0.7000000
    Aim_BestAccuracy=0.5000000
    IdleSightRadius=3000.0000000
    AlertSightRadius=5000.0000000
    IdleHearingRadius=4000.0000000
    AlertHearingRadius=6000.0000000
    IdlePeripheralVision=0.5000000
    AlertPeripheralVision=0.3400000
    DrawType=2
    bHidden=true
    Mesh=SkeletalMesh'CBA_Pawn.Spawn_Model'
    bDirectional=true
}