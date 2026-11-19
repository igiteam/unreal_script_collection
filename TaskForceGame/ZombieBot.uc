class ZombieBot extends ScriptedController
	native;

//
// Bot constants
//
const MAX_GRENADE_DISTANCE      = 1500;
const MIN_GRENADE_DISTANCE      = 600;
const RETREAT_HEALTH            = 50;        //health at which the AI will run from the player
const NUM_SOUND_SET             = 3;         //number of sound sets
const NUM_SOUND_CAT             = 8;         //number of sound categories
const SOUND_ARRAY_SIZE          = 24;        //NUM_SOUND_SET * NUM_SOUND_CAT;
const DELAY_ALERT_TIME          = 4;
const MP_FIRERATE_MULTIPLIER    = 0.2;
const CIRCLE_STRAFE_ARC         = 8192;      //45 degrees in unreal units
const CIRCLE_STRAFE_MIN_ARC     = 2731;      //30 degree starting rotation
const I_LEAVE_STATE             = 1;
const NEAR_EPSILON              = 60;
const STRAFE_SCALE              = 1.1;
const MIN_BURST_SIZE            = 2;
const BURST_VARIANCE            = 3;

// 
// Bot Enumerations
//
enum BotFireType
{
	BFT_Spray,            // (Accuracy is poor and the rate of fire is maxed with the weapon)
	BFT_Controlled,       // (Accuracy is better and the rate of fire is small bursts)
	BFT_Aimed,            // (Accuracy is good and it's single shot every .75 to 1.5 seconds);
	BFT_Snipe             // (Accuracy is the best and the shots are once ever 2-3.5
};

//// Focus Type - mostly procedural aiming
//enum ESetFocusType
//{
//	SFT_None,  // Not valid
//	SFT_Head,  // Look with head
//	SFT_Aim,   // Look with upper body
//	SFT_Full   // Look with whole body
//};

//
// Bot Variables
//

// AI manager information
var name             AIManagerTag;          // Tag of the AIManager that this bot will belong to
var ZombieAIManager  AIManager;             // Actual AIManager actor - set from tag lookup
var name             SeeEvent;               // Name of the event to fire when this AI sees the player

var ZombieBipedPawn  MyPawn;                // Quick access to avoid type casting

var Pawn             StartEnemy;            // Enemy to start with if you start alert or kamikaze

// Bot ability allowments
var bool             bCanPatrol;            // True if this AI is allowed to patrol an area
var float            WorstAccuracy;         // low end accuracy rating
var float            BestAccuracy;          // high end accuracy rating

// information about stuff that was and is no longer
var Pawn             LastSeenEnemy;         // Last seen enemy - for picking cover or investigating
var name             MyLastState;           // Last known state - just in case we want to go back to our previous state from current states

// Firing Information
var float            EnemySeenTime;         // Time in seconds that I first saw my enemy
var int              LastWeaponIndex;
var int              ShotsRemaining;        // Total number of shots that the bot wants to fire ( decremented each time the weapon fires )
var Vector           GrenadeTarget;         // Set this before throwing a grenade - this is where you want the grenade to end up
var BotFireType      CurrFireType;          // the current fire type this bot is set too.
var int              BulletsToFire;         // number of bullets to fire
var int              BurstsToFire;          // number of burst sets to fire

// Moving Data
var float            NodeArrivalTime;       // time of reaching current node
var float            LastFocusCheck,        // time of last moving shooting check
                     LastCoverCheck,        // time of last cover check
                     LastSeePlayerCheck;    // time of last see player check

var int              numMoveAttempts;       // number of attempts made to find a new place to run to.

var bool             bFireWhileMoving;      // Allowed to fire while moving
var bool             bFaceDestination;      // Forced pawn rotation while moving (faces destination)
var bool             bInvestigateNoise;     // True when the bot is investigating noise
var bool             bFindNewDest;          // True when bot should find a new destination while in CloseQuarterCombat
var bool             bLeanLeft;             // true when the bot wants to lean left otherwise false

var bool             bTriggeredEvent;       // True when this AI has already triggered its event
var bool             bSleeping;             // Waiting to continue latent execution

var bool             bFiring;               // Bot is currently trying to fire weapon
var bool             bOpenDoors;            // if false this AI will not open doors

var bool             bScripting;            // set true when the AI is running a script

var bool             bStartAlert;           // Set to true when the AI should start alerted to the player
var bool             bStartKamikaze;        // Set to true when the AI should start out pursuing the player
var bool             bInitialized;          // Only used for start alert and start kamikaze bots

var bool             bRetreated;            // used to determine whether the AI has yelled retreat or not

//Civilian data
var bool             bCivilian;             // is this bot a civilian?

var PathNode         CurrentDest;           // Current destination PathNode
var ZombieAINode     DestAINode,            // AINode that I'm currently moving towards
                     CurrentAINode,         // AINode that I'm currently using
                     LastPatrolNode;        // AINode that I last patrolled to

// Cover Data
var bool             bRightOfCover;         // Current target is to the right of cover
var bool             bProvidingCover;       // AI is currently providing cover for another
var ZombieBot        CoveringBot;           // Bot I am providing cover for

// Patrol Data
var int              CurrLookIndex;         // Helper variable for UsePatrol state

// Attacked Stuff
var Pawn             Attacker;              // Last person to attack
var float            AttackTime;            // Time of attack

// Hearing Stuff
var	float            CurrentNoiseLoudness;  // Loudness of current noise
var float            CurrentNoiseTime;      // Time of current noise
var Vector           CurrentNoiseLocation;  // Location of current noise

// sensory values
var float            IdleSightRadius,       // sight radius when idle
                     AlertSightRadius,      // sight radius when alert
                     IdleHearingRadius,     // hearing radius when idle
                     AlertHearingRadius,    // hearing radius when alert
                     IdlePeripheralVision,  // view angle when idle
                     AlertPeripheralVision; // view angle when alert

// time delay for yelling alert sounds
var float            LastAlertTime;

var bool             bPlayResponse;
var float            AlertTime;
var float            ResponseTime;

// storing grenade for kicking
var DelayedProjectile NearbyForeignGrenade;        // store the grenade so the AI can kick it
var DelayedProjectile NearbyFlyingGrenade;         // store the grenade to play sounds

var Vector            destinationPoint;            // vector used for circle strafing combat
var Vector            lastCombatLoc;               // last position in combat

native final function BreakFire( );

//latent fire functions for AI behavior
native(560) final latent function FireWhileInCover( );
native(562) final latent function FireMoveTo( vector NewDestination, optional Actor ViewFocus, optional bool bShouldWalk, optional bool bShoot);
native(564) final latent function FireMoveToward( actor NewTarget, optional Actor ViewFocus, optional float DestinationOffset, optional bool bUseStrafing, optional bool bShouldWalk, optional bool bShoot);

// for weapon to get the correct firing direction
native function rotator GetViewRotation ( );
// for MP
native function GetTeamSizes ( out int NumSF, out int NumTR );
//check see player
native function ZombieSeePlayer( Pawn SeenPlayer );
//rotate a vector in a circle around the enemy
native function FindNewCirclePoint( float strafeAngle, out Vector circleVec );
//check to see if two points are near each other
native function bool IsNear( Vector Point1, Vector Point2, float NEAR_EPSILON );

simulated function DisplayDebug( Canvas Canvas, out float YL, out float YPos )
{
	Canvas.CurX = 0;
	Canvas.DrawText ( "ZombieBot:"$Name );
	Canvas.CurX = 0;
	Canvas.CurY += Canvas.TextHeight;
	Canvas.DrawText ( "CurrentState:"@GetStateName()@"- LastState:"@MyLastState );
	Canvas.CurX = 0;
	Canvas.CurY += Canvas.TextHeight;
	Canvas.DrawText ( "MoveTarget:"@MoveTarget@"- Destination:"@Destination@"- CurrentDest:"@CurrentDest );
	Canvas.CurX = 0;
	Canvas.CurY += Canvas.TextHeight;
	Canvas.DrawText ( "MyLocation:"@Pawn.Location );
	Canvas.CurX = 0;
	Canvas.CurY += Canvas.TextHeight;
	Canvas.DrawText ( "Focus:"@Focus );
	Canvas.CurX = 0;
	Canvas.CurY += Canvas.TextHeight;
	Canvas.DrawText ( "Enemy:"@Enemy );
	Canvas.CurX = 0;
	Canvas.CurY += Canvas.TextHeight;
}

// stubs
function Timer();

function SetIdle( )
{
	MyPawn.SightRadius = IdleSightRadius;
	MyPawn.HearingThreshold = IdleHearingRadius;
	MyPawn.PeripheralVision = IdlePeripheralVision;
}

event SetAlert( )
{
	MyPawn.SightRadius = AlertSightRadius;
	MyPawn.HearingThreshold = AlertHearingRadius;
	MyPawn.PeripheralVision = AlertPeripheralVision;
}

// Function that acts sort of like a constructor, allowing us to initialize
// variables in this class.
function PostBeginPlay()
{
	Super.PostBeginPlay();
	LastCoverCheck = 0.0;
	LastFocusCheck = 0.0;
}

function Possess( Pawn aPawn )
{
	Super.Possess( aPawn );

	MyPawn = ZombieBipedPawn( aPawn );
	if( MyPawn == None )
	{
		// CRASH THE GAME
	}
	else
	{
		MyPawn.bIsAI = true;
	}
	// goto inactive
	ZBotGotoState( 'inactive' );
}

event HearNoise ( float Loudness, Actor NoiseMaker )
{
	local Pawn		NoisyPawn;
	local float		ActualLoudness;

	if ( Pawn == None )
	{
		return;
	}
	//return;

	//log ( "HearNoise - Loudness:"@Loudness@"- NoiseMaker:"@NoiseMaker );

	// try to store the noise maker as the noisy pawn
	NoisyPawn = Pawn ( NoiseMaker );

	// not a pawn?  see if it's instigator is
	if ( NoisyPawn == None )
		NoisyPawn = NoiseMaker.Instigator;

	// still not a pawn?  see if it's owner is
	if ( NoisyPawn == None )
		NoisyPawn = Pawn ( NoiseMaker.Owner );

//	log ( "HearNoise - NoisyPawn:"@NoisyPawn );

	// noise maker is not a pawn - or it's an enemy
	if ( ValidEnemy ( NoisyPawn ) )
	{
		// compute actual loudness based on distance of noise and max hearing distance
		ActualLoudness = Loudness * ( 1.0 - ( VSize ( NoiseMaker.Location - MyPawn.Location ) / MyPawn.HearingThreshold ) );
		//log( "HearNoise - ActualLoudness      :"@ActualLoudness );
		//log( "HearNoise - Loudness            :"@Loudness );
		//log( "HearNoise - CurrentNoiseLoudness:"@CurrentNoiseLoudness );
		//log( "---------------------------------------------------------------" );
		// new noise is louder than current - or - current is older than 5 seconds
		if ( ActualLoudness >= CurrentNoiseLoudness || Level.TimeSeconds - CurrentNoiseTime > 5.0 )
		{
			// unset the flag
			bInvestigateNoise = false;

//			log ( "HearNoise - Storing new noise" );
			CurrentNoiseLoudness = ActualLoudness;
			CurrentNoiseLocation = NoiseMaker.Location;
			CurrentNoiseTime = Level.TimeSeconds;
			SetAlert();
		}
	}
}

event SeePlayer ( Pawn SeenPlayer )
{
	if ( Pawn == None )
	{
		return;
	}
	//log( "Global SeePlayer Called" );
	ZombieSeePlayer( SeenPlayer );
}

// Called when MyPawn takes damage
event NotifyTakeHit ( Pawn InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum )
{
	if( IdleSightRadius == 0 )
		return;

	if( !MyPawn.IsMP( ) )
	{
		MyPawn.PlaySoundCategory( MyPawn.ESoundCat.SC_Hit );
	}

	// make sure it's not already our enemy... and that it's a valid enemy
	if ( Enemy != InstigatedBy && ValidEnemy ( InstigatedBy ) )
	{
		Attacker = InstigatedBy;
		AttackTime = Level.TimeSeconds;
		SetAlert();
		//log( "SeePlayer called by NotifyTakeHit" );
		SeePlayer( InstigatedBy );
	}
}

// When the enemy has been set, this function is called much like SeePlayer but opposite.
// As long as the enemy is not visible, this is called every tick.
function EnemyNotVisible ( )
{
	if ( Pawn == None )
	{
		Enemy = None;
		return;
	}

	// don't track through walls
	//if ( MyPawn.LookAtActor == Enemy )
	//{
	//	SetViewFocus( None );
	//}

	// time to forget?
	if( (MyPawn.IsMP( ) && Level.TimeSeconds - LastSeenTime > 2.0) ||
	    (Level.TimeSeconds - LastSeenTime > 40.0 && !bStartAlert && !bStartKamikaze) )
	{
		SetIdle();
		// focus is the enemy 
		if ( Focus == Enemy )
		{
			// clear the focus
			Focus = None;
			FocalPoint = LastSeenPos;
		}
		// store as last seen enemy
		LastSeenEnemy = Enemy;
		// clear the enemy
		Enemy = None;
		LastFocusCheck = 0.0;
		// not aiming!
		MyPawn.bAimMode = false;
	}
}

//when an ally sees an enemy run to the ally to help him fight
function SupportAlly( Pawn Ally, Pawn NewEnemy )
{
	local int             i;
	local NavigationPoint NavPoint;
	local PathNode        ActualNode;
	local bool            bBreakOut;
	local Pawn            TargetPawn;
	//log( "Got In" );
	if( Ally == None || MyPawn == None || NewEnemy == None || bScripting || IdleSightRadius == 0 )
		return;

	//log( "Supporting Ally" );
	bBreakOut = false;
	//if we don't already have someone to fight then support our ally
	if( Enemy == None )
	{
		bPlayResponse = true;
		AlertTime = Level.TimeSeconds;
		Responsetime = frand() * 1.5 + 1;
		Enemy = NewEnemy;
		SetViewFocus( Enemy, SFT_FULL );
		LastSeenTime = Level.TimeSeconds;

		//if we can find a path to the enemy move to them otherwise move to our ally
		if( FindPathToward( NewEnemy ) != None )
			TargetPawn = NewEnemy;
		else
			TargetPawn = Ally;

		for( i = 100; i <= 400; i += 100 )
		{
			//find a node to go to
			foreach RadiusNavPoints( NavPoint, i, TargetPawn.Location )
			{
				ActualNode = PathNode( NavPoint );
				//log ( "SupportAlly - ActualNode:"@ActualNode );
				if( ActualNode != None && FindPathToward ( ActualNode ) != None && !IsNear( TargetPawn.Location, ActualNode.Location, NEAR_EPSILON-50 ) )
				{
					//log ( "SupportAlly - MoveToNode ActualNode:"@ActualNode );
					MyPawn.bIsWalking = false;
					bBreakout = true;
					MoveToNode( ActualNode, false, false );
					break;
				}
			}
			if( bBreakout == true )
				break;
		}
	}
}

function WasKilledBy ( Controller Other )
{
	// Cover fire failed cause now I'm dead, thanks a bunch
	if ( AIManager != None )
	{
		AIManager.NotifyDoneMoving( Self );
	}
	if ( !MyPawn.IsMP ( ) )
	{
		MyPawn.PlaySoundCategory( MyPawn.ESoundCat.SC_Die );
	}

	bOpenDoors = false;

	// died - release any used things
	if ( DestAINode != None )
	{
		DestAINode.ReleaseNode ( Self );
	}
	if ( CurrentAINode != None )
	{
		if( CurrentAINode.bIsCoverNode )
		{
			CurrentAINode.DisableTimeOnDeath = Level.TimeSeconds + CurrentAINode.DeathDisableTime;
		}
		CurrentAINode.ReleaseNode ( Self );
	}
	// remove me from the 'team'
	if ( AIManager != None )
	{
		AIManager.RemoveBot ( Self );
	}

	// MUHAA!
	if ( NavigationPoint ( MoveTarget ) != None && InLatentExecution ( LATENT_MOVETOWARD ) )
	{
		// experimental
		NavigationPoint ( MoveTarget ).AddExtraCost ( 0 );
	}

	// free up this guy
	Unpossess ( );
	if ( MyPawn != None )
	{
		MyPawn.Controller = None;
		MyPawn.SetOwner ( None );
	}

	// cut off any states
	ZBotGotoState ( 'Dead' );
}

function ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir);

function ArmedProjectileFlyingNearby ( DelayedProjectile gp )
{
	if( !gp.bIncomingHeard )
	{
		gp.bIncomingHeard = true;
		if( !MyPawn.IsMP( ) )
		{
			MyPawn.PlaySoundCategory( MyPawn.ESoundCat.SC_Incoming );
		}
	}
}

function ArmedProjectileLandedNearby ( DelayedProjectile gp )
{
	if( !gp.bBeingHandled )
	{
		if( ValidEnemy( Pawn( gp.Owner ) ) )
		{
			gp.SetOwner( Self );
			gp.bBeingHandled = true;

			if( gp.IsA( 'C4Projectile' ) )
				return;


			NearbyForeignGrenade = gp;
			CancelMovement();
			// stop leaning
			MyPawn.SetLean ( false, 0.0, 0.0 );
			// stand up and run
			MyPawn.ShouldCrouch ( false );
			MyPawn.bIsWalking = false;

			if( CurrentAINode != None )
				CurrentAINode.ReleaseNode( Self );
			if( IdleSightRadius != 0 )
				ZBotGotoState( 'KickGrenadeState' );
		}
	}
}

event PlayAlert( )
{
	if( !MyPawn.IsMP( ) )
	{
		MyPawn.PlaySoundCategory( MyPawn.ESoundCat.SC_Alert );
	}
}

event PlayResponse( )
{
	if( !MyPawn.IsMP( ) )
	{
		MyPawn.PlaySoundCategory( MyPawn.ESoundCat.SC_Response );
	}
}

function NotifyReloading( )
{
	BreakSleep();
	BreakFire();
	//log( "Reloaded" );
}

event MayFall ( )
{
	Super.MayFall ( );
}

event NotifyStartFalling ( )
{
	if ( Pawn != None )
	{
		MoveTarget = Pawn;
		Destination = Pawn.Location;
		
		ZBotGotoState ( 'ZBotWaitForLanding' );
	}
}

//send the grenade that is stored flying
function KickGrenade( )
{
	local rotator kickRotation;

	//log( "Launch it" );
	if( NearbyForeignGrenade != None )
	{
		kickRotation = MyPawn.rotation;
		kickRotation.pitch += 4096;
		NearbyForeignGrenade.ProjectileLaunch( kickRotation, 0.9 );
	}
}

///////////////////////
//  Weapon handling  //
///////////////////////

// quick function to see if weapon could hit a specified location
event bool WeaponCouldHit ( Vector TestLocation )
{
	// don't have a weapon?
	if ( MyPawn.MyWeapon == None )
		return false;

	// hacK! using a knife?
	if ( MyPawn.MyWeapon.TraceDist < 500 )
	{
		// not in weapon range?
		if ( VSize ( TestLocation - MyPawn.Location ) > 2 * MyPawn.MyWeapon.TraceDist )
			return false;
	}
	// normal way
	else
	{
		// not in weapon range?
		if ( VSize ( TestLocation - MyPawn.Location ) > MyPawn.MyWeapon.TraceDist )
			return false;

		// not within 20 degrees of aiming location?
		if ( (Normal( MyPawn.AimingDirection ) Dot Normal( TestLocation - MyPawn.Location )) < 0.985 )
		{
			//log( "Failed on 10 degree check" );
			return false;
		}
	}

	// could hit
	return true;
}

//see if I can shoot without peeking from cover
event bool CanShoot( Pawn Enemy )
{
	local Actor  hitActor;
	local Vector dummy;
	local Vector dummy2;

	if( Enemy != None )
	{
		hitActor = Trace( dummy, dummy2, Enemy.Location, Pawn.Location );
		//log( "hitActor"@hitActor );
		//log( "Enemy"@Enemy );
		//log( "Pawn( hitActor )"@Pawn( hitActor ) );
		if( hitActor == None )
		{
			//log( "shoot em" );
			return true;
		}
	}
	return false;
}

// Called to see if it's time to shoot again
event bool ShouldFireWeapon ( )
{
	local float NextFireTime;

	// no weapon?
	if ( MyPawn.MyWeapon == None || MyPawn.GetStateName ( ) == 'ChangingWeapon' )
	{
		//log( "I have no weapon or I am changing weapons" );
		return false;
	}

	// calculate next fire time based on if it's multiplayer
	if ( MyPawn.IsMP ( ) )
	{
		NextFireTime = MyPawn.MyWeapon.StopFiringTime + ( MP_FIRERATE_MULTIPLIER * MyPawn.MyWeapon.BotTimeBetweenBursts );
	}
	else
	{	
		NextFireTime = MyPawn.MyWeapon.StopFiringTime + MyPawn.MyWeapon.BotTimeBetweenBursts;
	}

	// make sure it's time to shoot again
	if ( Level.TimeSeconds > NextFireTime )
	{
		// shooting randomly - or - could hit enemy
		if ( Enemy == None || WeaponCouldHit ( Enemy.Location ) )
		{
			//log( "SHOOT!" );
			return true;
		}
	}
	//log( "It is not time to shoot again" );
	// can't shoot
	return false;
}

// Called to see if I think I'm firing
event bool IsFiring ( )
{
	//log ( "ZombieBot:IsFiring" );
	if ( ShotsRemaining > 0 )
	{
		return true;
	}
	return false;
}

function bool CheckUsefulCover( ZombieAINode Node )
{
	// have an enemy?
	if( Enemy != None && AIManager != None && Node != None )
	{
		if( (Normal( Node.Location - Enemy.Location ) Dot Normal( MyPawn.Location - Enemy.Location )) > 0.94 &&
		     VSIZE( Node.Location - Enemy.Location ) > 100 &&
		     VSIZE( Node.Location - MyPawn.Location ) < 700 )
		{
			//log( "(Normal( Node.Location - Enemy.Location ) Dot Normal( MyPawn.Location - Enemy.Location ))"@(Normal( Node.Location - Enemy.Location ) Dot Normal( MyPawn.Location - Enemy.Location )) );
			return true;
		}
	}
	//log( "Cover I tried to go to was not useful." );
	//log( "Dot"@(Normal( Node.Location - Enemy.Location ) Dot Normal( MyPawn.Location - Enemy.Location )) > 0.94 );
	//log( "NodeToEnemy"@VSIZE( Node.Location - Enemy.Location ) > 100 );
	//log( "NodeToMe"@VSIZE( Node.Location - MyPawn.Location ) < 700 );
	return false;
}
// Called by the pawn's weapon when a shot has been fired
function bool WeaponFireAgain ( float RefireRate, bool bFinishedFire )
{
	bFiring = false;
	if( MyPawn.GetStateName( ) == 'ChangingWeapon' )
		BreakFire( );
	StopFiring( );
	return Super.WeaponFireAgain( RefireRate, bFinishedFire );
}

// called when firing is complete - finishes the firing cycle (also useful for ending the fire cycle early)
function StopFiring ( )
{
	Super.StopFiring ( );
	if ( MyPawn.MyWeapon != None )
	{
		MyPawn.MyWeapon.StopFiringTime = Level.TimeSeconds;
	}
}

// called from current weapon when it is empty
exec function SwitchToBestWeapon ( )
{
	//log ( "ZombieBot:SwitchToBestWeapon" );
	// primary?
	if ( MyPawn.Weapons [ MyPawn.WEAPSLOT_Primary ] != None && MyPawn.Weapons [ MyPawn.WEAPSLOT_Primary ].HasAmmo ( ) )
	{
		MyPawn.EquipWeapon ( MyPawn.WEAPSLOT_Primary );
	}
	// pistol?
	else if ( MyPawn.Weapons [ MyPawn.WEAPSLOT_Pistol ] != None && MyPawn.Weapons [ MyPawn.WEAPSLOT_Pistol ].HasAmmo ( ) )
	{
		MyPawn.EquipWeapon ( MyPawn.WEAPSLOT_Pistol );
	}
	// must go to knife
	else if ( MyPawn.Weapons [ MyPawn.WEAPSLOT_Knife ] != None )
	{
		MyPawn.EquipWeapon ( MyPawn.WEAPSLOT_Knife );
	}
}

// called to see if throwing a grenade is reasonable
function bool ShouldThrowGrenade ( )
{
	local Pawn            MyEnemy;
	local ZombieWeapon    MyGrenade;
	local float           EnemyDistance;

	// store MyGrenade and MyEnemy for quick access
	MyGrenade = MyPawn.Weapons [ MyPawn.WEAPSLOT_Grenade ];
	MyEnemy = Enemy;
	
	// possibly can't see the enemy anymore - so it would be store in LastSeenEnemy
	if ( MyEnemy == None )
	{
		MyEnemy = LastSeenEnemy;
	}

	// have an enemy, current node allows for grenades, have grenades
	if ( MyEnemy != None && CurrentAINode != None && CurrentAINode.bUsingAsCover && CurrentAINode.bCanThrowGrenades && MyGrenade != None && MyGrenade.HasAmmo ( ) )
	{
		// close enough but not too close
		EnemyDistance = VSize ( MyPawn.Location - MyEnemy.Location );
		if ( EnemyDistance <= MAX_GRENADE_DISTANCE && EnemyDistance > MIN_GRENADE_DISTANCE )
		{
			// yeah, it would be ok to throw grenades
			return true;
		}
	}
	// not a good idea to throw a grenade - or unable to do so
	return false;
}

// called when pawn needs to create and launch a grenade ( based on the third person anim )
function ThrowGrenadeAt ( )
{
	local ZombieWeapon  MyGrenadeWeapon;
	local Projectile    MyGrenadeProjectile;
	local Vector        GrenadeSpawnLocation,
	                    GrenadeFireDir;
	local float         Distance, SpeedScale;

	MyGrenadeWeapon = MyPawn.Weapons[MyPawn.WEAPSLOT_Grenade];
	if( MyGrenadeWeapon == None || !MyGrenadeWeapon.HasAmmo( ))
	{
		return;
	}

	// figure out the location to spawn
	GrenadeSpawnLocation = MyPawn.GetBoneCoords( MyPawn.GetWeaponBoneFor( None ) ).Origin;

	// Vector from start to target
	GrenadeFireDir = GrenadeTarget - GrenadeSpawnLocation;
	// get the throwing distance
	Distance = VSize( GrenadeFireDir );

	// determine the required speed to throw
	SpeedScale = FClamp( Distance / MAX_GRENADE_DISTANCE, 0.f, 1.f );

	// modify the fire dir to aim more upward
	GrenadeFireDir = Normal( GrenadeFireDir );
	GrenadeFireDir.Z += 0.707107;
	//GrenadeFireDir = Normal ( GrenadeFireDir );

	// spawn the nade
	MyGrenadeProjectile = Spawn( MyGrenadeWeapon.AmmoName.default.ProjectileClass, MyPawn,, GrenadeSpawnLocation, rotator( GrenadeFireDir ) );
	if( MyGrenadeProjectile != None )
	{
		// decrement the amount of nades remaining
		MyGrenadeWeapon.ReloadCount--;
		// set the speed
		MyGrenadeProjectile.Speed = SpeedScale * MyGrenadeProjectile.default.Speed;
		if( GrenadeProjectile( MyGrenadeProjectile ) != None )
		{
			// set the lifetime
			GrenadeProjectile( MyGrenadeProjectile ).DPLifeSpan = 3;
		}
	}
}

// General pawn control functions

// set focus
event SetViewFocus ( Actor Other, optional ESetFocusType FocusType )
{
	//log( "I set view focus to:"@FocusType );
	if ( Other == None )
	{
		MyPawn.StopLookAt ( true, true, true );
		return;
	}

	// handle the type
	if ( FocusType == SFT_Head )
	{
		// look with head
		MyPawn.SetLookAtActor ( Other, true, true, false );
	}
	else if ( FocusType == SFT_Aim )
	{
		// look with head & torso
		MyPawn.SetLookAtActor ( Other, true, true, true );
	}
	else if ( FocusType == SFT_Full )
	{
		// look with head & torso
		MyPawn.SetLookAtActor ( Other, true, true, true );
		// turn rest of body, too
		Focus = Other;
	}
}

event SetViewFocusPoint ( Vector ViewLocation, optional ESetFocusType FocusType )
{
	// handle the type
	if ( FocusType == SFT_Head )
	{
		// look with head
		MyPawn.SetLookAtPoint ( ViewLocation, true, true, false );
	}
	else if ( FocusType == SFT_Aim )
	{
		// look with head & torso
		MyPawn.SetLookAtPoint ( ViewLocation, true, true, true );
	}
	else if ( FocusType == SFT_Full )
	{
		// look with head & torso
		MyPawn.SetLookAtPoint ( ViewLocation, true, true, true );
		// turn rest of body, too
		Focus = None;
		FocalPoint = ViewLocation;
	}
}

//
//	Bot Helpers
//

// enhanced goto state function
event ZBotGotoState ( name NewState, optional name StateSection )
{
	// if new state not same as current
	if ( NewState != GetStateName ( ) )
	{
		// store current as last
		MyLastState = GetStateName ( );
	}
	// failsafe
	if ( MyLastState == 'None' )
	{
		MyLastState = 'Idle';
	}

	// goto new
	GotoState ( NewState, StateSection );
}

event bool ValidEnemy ( Pawn Other )
{
	local ZombiePawn CheckPawn;
	CheckPawn = ZombiePawn ( Other );
	if ( CheckPawn == None )
		return false;

	//log ( "ValidEnemy - Valid Pawn" );

	// dead?
	if ( CheckPawn.Health <= 0 )
		return false;

	//log ( "ValidEnemy - Living" );

	// buddy?
	if ( CheckPawn.Faction == MyPawn.Faction )
		return false;

	//log ( "ValidEnemy - Not a buddy" );

	// civilian
	if ( CheckPawn.Faction == FACTION_Civilian )
		return false;

	//log ( "ValidEnemy - Not a civilian" );

	// must be an enemy
	return true;
}

// check if an actor is within 60 degrees of the view direction
event bool ActorInFront ( Actor Other )
{
	if ( Other != None )
	{
		return PointInFront ( Other.Location );
	}
	else
	{
		return false;
	}
}

// check if a point is within 60 degrees of the view direction
event bool PointInFront ( Vector Point )
{
	local Vector MeToPoint;
	local Vector MeDir;

	local float DotProduct;

	MeToPoint = normal ( Point - MyPawn.Location );
	MeDir = normal ( Vector ( MyPawn.Rotation ) );
	DotProduct = MeToPoint Dot MeDir;

	// 60 degrees
	if ( DotProduct > 0.5 )
	{
		return true;
	}
	return false;
}

// helper function to get current enemy location
function Vector GetEnemyLocation ( )
{
	// current visible enemy?
	if ( Enemy != None )
	{
		return Enemy.Location;
	}
	// current hidden enemy?
	if ( LastSeenEnemy != None )
	{
		return LastSeenEnemy.Location;
	}
	// failsafe
	return LastSeenPos;
}

//
//	States and related functions
//

//
// Inactive
// Bot will come here initially and later if something goes wrong
auto state inactive
{
Begin:

	if( bCivilian )
	{
		IdleSightRadius = 0;
		AlertSightRadius = 0;
		IdleHearingRadius = 0;
		AlertHearingRadius = 0;
		IdlePeripheralVision = 0;
		AlertPeripheralVision = 0;
	}

	if( IdleSightRadius == 0 )
	{
		if( MyPawn != None )
		{
			MyPawn.Faction = FACTION_Civilian;
		}
		SetViewFocus( None );
		Sleep( 100.0 );
		Goto( 'Begin' );
	}

	// kill any movement
	MoveTarget = MyPawn;
	if( MyPawn != None )
	{
		Destination = MyPawn.Location;
		MyPawn.Velocity = vect( 0, 0, 0 );
		MyPawn.Acceleration = MyPawn.Velocity;
	}

	// if I am an alert bot start off with an enemy
	if( bStartAlert && !bInitialized )
	{
		bInitialized = true;
		foreach DynamicActors( class'Pawn', StartEnemy )
		{
			if( ValidEnemy( StartEnemy ) )
				Enemy = StartEnemy;
		}
		ZBotGotoState( 'Idle' );
	}
	if( bStartKamikaze && !bInitialized )
	{
		bInitialized = true;
		foreach DynamicActors( class'Pawn', StartEnemy )
		{
			if( ValidEnemy( StartEnemy ) )
				Enemy = StartEnemy;
		}
		ZBotGotoState( 'PursueEnemy' );
	}

	// we were in the process of moving
	if( CurrentDest != None )
	{
		// this can happen when takeover scripts fire off
		ZBotGotoState( 'MovingToNode' );
	}
	else
	{
		// goto main thinking hub
		ZBotGotoState( 'Idle' );
	}
}

//
// Idle
// Bot will be in this state when idle
// Spends most time sleeping, waiting for something to happen
state Idle
{
	event SeePlayer ( Pawn SeenPlayer )
	{
		//log( "See Player Called in Idle" );
		Global.SeePlayer ( SeenPlayer );
		// have an enemy?
		if ( Enemy == SeenPlayer )
		{
			// stop sleeping and react
			BreakSleep();
		}
	}

	function HearNoise ( float Loudness, Actor NoiseMaker )
	{
		Global.HearNoise ( Loudness, NoiseMaker );
		// actually heard something dangerous?
		if ( CurrentNoiseLoudness > 0 )
		{
			// stop sleeping and react
			BreakSleep();
		}
	}

	event NotifyTakeHit ( Pawn InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum )
	{
		Global.NotifyTakeHit ( InstigatedBy, HitLocation, Damage, DamageType, Momentum );
		// person who hit me was or now is my attacker?
		if ( Attacker == InstigatedBy )
		{
			// stop sleeping and react
			BreakSleep ( );
		}
	}

Begin:

	do
	{
		// decide what to do next
		MakeDecision ( );

		// yes it's long, but it will be broken if something happens
		Sleep( 30.0 );
	}
	until( I_LEAVE_STATE != 1 )
}

// Called fron state Idle - checks AI data and makes decision based on findings
event MakeDecision( )
{
	local ZombieAINode Node;

	// have an enemy? -or- I've been attacked -or- heard a noise in the last 5 seconds?
	if( Enemy != None || Attacker != None || ( CurrentNoiseLoudness > 0.0 && ( Level.TimeSeconds - CurrentNoiseTime < 5.0 ) ) )
	{
		ZBotGotoState( 'React' );
	}
	// can patrol?
	else if( bCanPatrol && AIManager != None )
	{
		// try to find a patrol node that isn't the last one
		Node = AIManager.GetPatrolNodeFor ( MyPawn.Location, LastPatrolNode );
		if( Node != None )
		{
			// walking
			MyPawn.bIsWalking = true;
			// take this node
			Node.UseAsPatrol( Self );
			// move to it - no shoot - face direction
			MoveToNode( Node, false, true );
		}
	}
}

//
// React
// Bot is in this state when reacting to seeing, hearing, or being shot by an enemy
// Should only enter this state from Idle
state React
{
	//ignores EnemyNotVisible;

	event SeePlayer ( Pawn SeenPlayer )
	{
		//log( "See Player Called in React" );
		Global.SeePlayer ( SeenPlayer );
		// have an enemy?
		if ( Enemy == SeenPlayer )
		{
			// stop rotating and react
			StopRotation ( );
			FocalPoint = MyPawn.Location + ( 1000 * Vector ( MyPawn.Rotation ) );
		}
	}

	function SetReactFocus ( )
	{
		// turn off any procedural aiming
		SetViewFocus ( None );
		Focus = None;
		FocalPoint = MyPawn.Location + ( 1000 * Vector ( MyPawn.Rotation ) );

		// have an enemy?
		if ( Enemy != None )
		{
			// if he's not in front of me
			if ( !ActorInFront ( Enemy ) )
			{
				// turn whole body and aim
				Focus = Enemy;
			}
			// aim at him
			SetViewFocus ( Enemy, SFT_Aim );
		}
		// was attacked?
		else if ( Attacker != None )
		{
			// if he's not in front of me
			if ( !ActorInFront ( Attacker ) )
			{
				// face attacker
				Focus = Attacker;
			}
			// aim at him
			SetViewFocus ( Attacker, SFT_Aim );
		}
		// otherwise - we must be reacting to a sound
		else
		{
			// if it's not in front of me
			if ( !PointInFront ( CurrentNoiseLocation ) )
			{
				// need to turn
				FocalPoint = CurrentNoiseLocation;
			}
			// aim at the point
			SetViewFocusPoint ( CurrentNoiseLocation, SFT_Aim );
		}
	}

Begin:

	// set our focus accordingly
	SetReactFocus ( );

	// wait for rotation
	FinishRotation ( );

	// reaction time
	Sleep ( 0.15 );

	// do we have an enemy?
	if ( Enemy != None )
	{
		MoveToCover( );
		//log( "I went to CloseCombat from React" );
		ZBotGotoState( 'CloseCombat' );
	}
	// hear something within the last 5 seconds?
	else if ( CurrentNoiseLoudness > 0 && ( Level.TimeSeconds - CurrentNoiseTime ) < 5.0 )
	{
		//log( "Moving to noise" );
		// move to the noise
		MoveToNoise ( );
	}

	Sleep ( 0.01 );

	// turn off any procedural aiming
	SetViewFocus ( None );
	ZBotGotoState ( 'Idle' );
}

// figures out best way to get to noise location and then moves toward it
function MoveToNoise ( )
{
	local NavigationPoint NavPoint;
	local PathNode        ActualNode;
	local int             i;
	// actually have a noise
	if ( CurrentNoiseLoudness > 0 )
	{
		for( i = 50; i <=200; i+=50 )
		{
			foreach RadiusNavPoints ( NavPoint, i, CurrentNoiseLocation )
			{
				ActualNode = PathNode ( NavPoint );
				//log ( "MoveToNoise - ActualNode:"@ActualNode );
				if ( ActualNode != None && FindPathToward ( ActualNode ) != None )
				{
					bInvestigateNoise = true;
					//log ( "MoveToNode - MoveToNode ActualNode:"@ActualNode );
					MyPawn.bIsWalking = true;
					MoveToNode ( ActualNode, false, true );
				}
			}
		}
	}
}

// finds cover for current enemy and moves toward it
function MoveToCover ( )
{
	local ZombieAINode Node;

	// have an enemy?
	if( Enemy != None && AIManager != None )
	{
		// try to find cover
		Node = AIManager.GetClosestCover( MyPawn.Location, Enemy.Location );
		if( Node != None && CheckUsefulCover( Node ) )
		{
//			log( "MoveToCover, GetClosestCover" );
			// running
			MyPawn.bIsWalking = false;
			// take this node
			Node.UseAsCover( Self );

			//notify other bots that this botis going to move to a new node
			AIManager.NotifyStartMoving( Self );

			if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
			{
				// move to it and shoot
				MoveToNode( Node, true, true );
			}
			else
			{
				// move to it without shooting
				MoveToNode( Node, false, true );
			}
		}
	}
}

//function stubs
function ProvideCoverFire ( ZombieBot MovingBot );
function EndCoverFire ( ZombieBot MovingBot );

//
// UseCover
// Bot is in this state when using a ZombieAINode as cover
state UseCover 
{
	event SeePlayer ( Pawn SeenPlayer )
	{
		//log( "See Player Called in UseCover" );
		Global.SeePlayer( SeenPlayer );
		if ( Level.TimeSeconds - LastCoverCheck > 0.25 && SeenPlayer == Enemy && !CurrentAINode.IsGoodCoverFor( Enemy.Location ) )
		{
			//log ( "UseCover:SeePlayer - Try to find new cover" );
			// store
			LastCoverCheck = Level.TimeSeconds;
			// stop leaning
			MyPawn.SetLean( false, 0.0, 0.0 );
			// stand up and run
			MyPawn.ShouldCrouch( false );
			MyPawn.bIsWalking = false;

			// change weapon back
			if( LastWeaponIndex != -1 )
				MyPawn.EquipWeapon( LastWeaponIndex );

			// Cancel movement on the bot
			CancelMovement();
			//if the enemy is still fairly far away just find new cover
			if( VSize( Pawn.Location - Enemy.Location ) > 500 )
			{
				// find new cover
				FindNewCoverNode();
			}
			//otherwise engage the enemy in closecombat
			else
			{
				//log( "I went to CloseCombat from UseCover" );
				ZBotGotoState( 'CloseCombat' );
			}
		}
	}

	//called when the bot is hit
	event NotifyTakeHit ( Pawn InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum )
	{
		Global.NotifyTakeHit ( InstigatedBy, HitLocation, Damage, DamageType, Momentum );

		//log( "UseCover: My life is: "@MyPawn.Health );
		if( MyPawn.Health < RETREAT_HEALTH && frand( ) > 0.8 )
		{
			// stop leaning
			MyPawn.SetLean ( false, 0.0, 0.0 );
			// stand up and run
			MyPawn.ShouldCrouch ( false );
			MyPawn.bIsWalking = false;

			if( !MyPawn.IsMP( ) && !bRetreated )
			{
				MyPawn.PlaySoundCategory( MyPawn.ESoundCat.SC_Retreat );
				bRetreated = true;
			}
			FindRetreatCoverNode( );
		}

		// person who hit me was or now is my attacker?
		if ( Attacker == InstigatedBy )
		{
			// stop covering for other bots and start using cover again
			bProvidingCover = false;
		}
	}

	// Find a new cover node
	function FindNewCoverNode( )
	{
		local ZombieAINode	Node;
		// find the closest valid cover spot for my enemy
		Node = AIManager.GetClosestCover ( MyPawn.Location, GetEnemyLocation ( ), CurrentAINode );
		if ( Node != None && CheckUsefulCover( Node ) )
		{
			//log( "FindNewCover Node, GetClosestCover" );
			// stop leaning
			MyPawn.SetLean ( false, 0.0, 0.0 );
			// stand up and run
			MyPawn.ShouldCrouch ( false );
			MyPawn.bIsWalking = false;
			// free up current
			CurrentAINode.ReleaseNode ( Self );
			CurrentAINode = None;
			// take new node
			Node.UseAsCover ( Self );

			//notify other bots that this botis going to move to a new node
			AIManager.NotifyStartMoving( Self );

			// move to it - can fire
			MoveToNode ( Node, true, true );
		}
	}

	// Find a cover node closer to the enemy
	function FindCloserCoverNode ( )
	{
		local ZombieAINode	Node;

		//log( "Try get closer" );
		// get a node that isn't my current and is closer to my enemy that my current node
		Node = AIManager.GetCloserCover ( MyPawn.Location, GetEnemyLocation ( ), CurrentAINode );
		if ( Node != None && CheckUsefulCover( Node ) )
		{
			//log( "FindCloserCover Node, GetCloserCover" );
			// stand up and run
			MyPawn.ShouldCrouch ( false );
			MyPawn.bIsWalking = false;
			// free up current
			CurrentAINode.ReleaseNode ( Self );
			CurrentAINode = None;
			// take new node
			Node.UseAsCover ( Self );

			//notify other bots that this botis going to move to a new node
			AIManager.NotifyStartMoving( Self );

			// move to it - can fire
			MoveToNode ( Node, true );
		}
		else
		{
			//log( "CoverWasn't useful" );
		}
	}

	// Find a cover node far away from the enemy
	function FindRetreatCoverNode ( )
	{
		local ZombieAINode	Node;
		// find the farthest node away from my enemy that is valid cover
		Node = AIManager.GetRetreatCover ( MyPawn.Location, GetEnemyLocation ( ), CurrentAINode );
		if ( Node != None )
		{
			//log( "FindRetreatCover Node, GetRetreatCover" );
			// stand up and run
			MyPawn.ShouldCrouch ( false );
			MyPawn.bIsWalking = false;
			// free up current
			CurrentAINode.ReleaseNode ( Self );
			CurrentAINode = None;
			// take new node
			Node.UseAsCover ( Self );

			//notify other bots that this botis going to move to a new node
			AIManager.NotifyStartMoving( Self );

			// move to it - can fire
			MoveToNode ( Node, true, true );
		}
	}

	// returns a point to move to based on CurrentAINode
	function Vector GetLeanPos ( bool bRight )
	{
		local rotator	HelperRot;
		local Vector	Helper;
		local float		SideDistance;

		// initialize the rotation to point in the direction of the cover
		HelperRot = rot ( 0, 0, 0 );
		HelperRot.Yaw = CurrentAINode.Rotation.Yaw;

		// calculate the distance to move ( left or right )
		SideDistance = float ( CurrentAINode.CoverDist ) * tan ( CurrentAINode.YawArcRadians );
		SideDistance -= MyPawn.CollisionRadius;

		// spin the helper the correct direction
		if ( bRight )
		{
			HelperRot.Yaw += 16384;
		}
		else
		{
			HelperRot.Yaw -= 16384;
		}

		// calculate the actual position
		Helper = CurrentAINode.Location + SideDistance * Vector ( HelperRot );

		// return it
		return Helper;
	}

	// called when AI is reloading their weapon
	function NotifyReloading ( )
	{
		// end any current attack and go back to cover
		Global.NotifyReloading( );
	}

	// cause an AI in cover to provide cover for an AI that is moving to new cover
	function ProvideCoverFire ( ZombieBot MovingBot )
	{
		CoveringBot = MovingBot;
		bProvidingCover = true;
		BreakSleep();
		BreakFire();
	}

	// cause this AI to end its coverfire if it was covering the moving bot
	function EndCoverFire ( ZombieBot MovingBot )
	{
		if( CoveringBot == MovingBot )
		{
			bProvidingCover = false;
			BreakFire();
		}
	}

Begin:

	//log ( "UseCover:Begin" );
	// shouldn't happen unless someone is using the system incorrectly - or they broke it
	if ( CurrentAINode == None )
	{
		// goto main thinking hub
		ZBotGotoState ( 'Idle' );
	}

	// crouch
	MyPawn.ShouldCrouch ( CurrentAINode.bShouldCrouch );
	// face the last seen position of the enemy
	Focus = None;
	FocalPoint = CurrentAINode.Location + ( 1000 * Vector ( CurrentAINode.Rotation ) );
	// no procedural
	SetViewFocus( None );
	FinishRotation();

	// hide for a bit
	Sleep( frand() * 0.5 + 0.5 );

CoverDecision:

//	if( !bProvidingCover )
//	{
		//log( "Enemy Distance"@VSize( MyPawn.Location - Enemy.Location ) );
		if( Enemy != None && MyPawn.MyWeapon == MyPawn.Weapons[MyPawn.WEAPSLOT_Knife] && VSize( MyPawn.Location - Enemy.Location ) < 1000 )
		{
			// stand up and run
			MyPawn.ShouldCrouch( false );
			MyPawn.bIsWalking = false;

			ZBotGotoState( 'KnifeRush' );
		}
		//log ( "UseCover:CoverDecision - LastSeenTime:"@LastSeenTime@"Level.TimeSeconds:"@Level.TimeSeconds );
		//if the bot has been at this cover node long enough see if there is a cover node closer to the enemy
		if( CurrentAINode.BotArrivalTime + CurrentAINode.MoveDisableTime < Level.TimeSeconds )//&& MyPawn.Health > RETREAT_HEALTH )
		{
			//log( "I want to find closer cover" );
			FindCloserCoverNode( );
		}

		//log( "UseCover: My life is: "@MyPawn.Health );
		//if( MyPawn.Health < RETREAT_HEALTH )
		//{
		//	FindRetreatCoverNode( );
		//}
//	}

CoverAttack:

	// figure out if our enemy is right of our cover
	bRightOfCover = CurrentAINode.RightOfCover ( GetEnemyLocation ( ) );

	//if we can see our enemy and could hit them but are not doing anything then shoot at them
	if( CanShoot( Enemy ) && CanSee( Enemy ) )
	{
		CurrFireType = BotFireType( Rand( 4 ) );
		BurstsToFire = Rand( 2 ) + 1;
		Sleep( 0.2 );
		if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
			FireWhileInCover( );
		else
			Sleep( 0.1 );
		
		Sleep( 0.3 );
		Goto( 'Begin' );
	}

	// throw a grenade
	if ( CurrentAINode.bCanThrowGrenades && frand() > 0.8 && ShouldThrowGrenade ( ) && !bProvidingCover )
	{
		Goto ( 'ThrowGrenade' );
	}
	// should lean right?
	else if ( bRightOfCover && CurrentAINode.bRightCorner && frand() > 0.66667 )
	{
		bLeanLeft = false;
		Goto( 'Lean' );
	}
	// should lean left
	else if ( !bRightOfCover && CurrentAINode.bLeftCorner && frand() > 0.66667 )
	{
		bLeanLeft = true;
		Goto( 'Lean' );
	}
	// should stand up?
	else if ( CurrentAINode.bCanFireOver && frand() > 0.66667 )
	{
		Goto ( 'StandUp' );
	}	
	// FAIL SAFES
	else if ( bRightOfCover && CurrentAINode.bRightCorner )
	{
		bLeanLeft = false;
		Goto( 'Lean' );
	}
	else if ( !bRightOfCover && CurrentAINode.bLeftCorner )
	{
		bLeanLeft = true;
		Goto( 'Lean' );
	}
	else if ( CurrentAINode.bCanFireOver ) 
	{
		Goto ( 'StandUp' );
	}
	else if ( CurrentAINode.bRightCorner )
	{
		bLeanLeft = false;
		Goto( 'Lean' );
	}
	else if ( CurrentAINode.bLeftCorner )
	{
		bLeanLeft = true;
		Goto( 'Lean' );
	}
	//if we can see our enemy and could hit them but are not doing anything then shoot at them
	if( CanSee( Enemy ) )
	{
		CurrFireType = BotFireType( Rand( 4 ) );
		BurstsToFire = Rand( 2 ) + 1;
		Sleep( 0.2 );
		if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
			FireWhileInCover( );
		else
			Sleep( 0.1 );
		
		Sleep( 0.3 );
		Goto( 'Begin' );
	}
	// so we don't lock the game
	Sleep ( 0.01 );
	Goto ( 'Begin' );

Lean:

	// face the enemy
	if ( Enemy == None )
	{
		Focus = LastSeenEnemy;
	}
	else
	{
		Focus = Enemy;
	}

	// finish rotating
	FinishRotation();

	// move to lean pos - face enemy
	MyPawn.bIsWalking = true;

	FireMoveTo( GetLeanPos( !bLeanLeft ), Focus, true, false );


	// set up pawn for lean
	if( bLeanLeft )
		MyPawn.SetLean( true, 1.0, 0.0 );
	else
		MyPawn.SetLean( true, -1.0, 0.0 );

	CurrFireType = BotFireType( Rand( 4 ) );
	BurstsToFire = Rand( 2 ) + 1;
	Sleep( 0.5 );
	if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
	{
		//fire weapon
		FireWhileInCover();
	}
	else
	{
		Sleep( 1 );
	}

	Sleep( 0.5 );
	// turn off lean
	MyPawn.SetLean ( false, 0.0, 0.0 );
	//sleep ( 1.0 );

	// fix pawn back
	MyPawn.bIsWalking = false;

	// face the last seen position of the enemy
	Focus = None;
	FocalPoint = LastSeenPos;
	// no procedural

	//SetViewFocus( None );
	// finish rotating
	FinishRotation();

	// move back to the cover node
	Goto( 'MoveBack' );

StandUp:

	//log ( "UseCover:CoverDecision:StandUp" );
	MyPawn.ShouldCrouch ( false );
	Sleep( 0.5 );
	CurrFireType = BotFireType( Rand( 4 ) );
	BurstsToFire = Rand( 2 ) + 1;

	if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
	{
		FireWhileInCover();
	}
	else
	{
		Sleep( 1 );
	}
	Sleep( 0.5 );
	// go back to beginning
	Goto( 'Begin' );

ThrowGrenade:

	if( !MyPawn.IsMP( ) )
	{
		MyPawn.PlaySoundCategory( MyPawn.ESoundCat.SC_Grenade );
	}

	// change weapon to grenade
	LastWeaponIndex = MyPawn.GetCurrentWeaponIndex ( );
	MyPawn.EquipWeapon ( MyPawn.WEAPSLOT_Grenade );
	Sleep ( 0.15 );

	// wait for weapon change
	while ( MyPawn.GetStateName ( ) == 'ChangingWeapon' )
	{
		//log ( "Changing to Nades" );
		Sleep ( 0.1 );
	}

	// stand up if needed
	MyPawn.ShouldCrouch ( false );
	Sleep ( 0.15 );

	// gotta know where to throw the nade
	if ( Enemy != None )
		GrenadeTarget = Enemy.Location;
	else if ( LastSeenEnemy != None )
		GrenadeTarget = LastSeenEnemy.Location;
	else
		GrenadeTarget = LastSeenPos;

	// play and wait for animation to finish
	MyPawn.ThrowGrenade ( );
	Sleep ( 0.15 );
	
	// wait for grenade to be thrown
	while ( MyPawn.GetStateName ( ) == 'ThrowingGrenade' )
	{
		//log ( "Throwing Nade" );
		Sleep ( 0.1 );
	}

	// crouch if needed
	MyPawn.ShouldCrouch ( CurrentAINode.bShouldCrouch );
	
	// change weapon back
	MyPawn.EquipWeapon ( LastWeaponIndex );
	LastWeaponIndex = -1;
	Sleep ( 0.15 );

	// wait for weapon change
	while ( MyPawn.GetStateName ( ) == 'ChangingWeapon' )
	{
		//log ( "Changing back!" );
		Sleep ( 0.1 );
	}

	// loop back up
	Goto ( 'Begin' );

MoveBack:

	FireMoveToward ( CurrentAINode, CurrentAINode, 0.0, false, false, false );
	Goto ( 'Begin' );
}

//
// UsePatrol
// Bot is in this state when using CurrentAINode as a Patrol Node
state UsePatrol
{
	event SeePlayer ( Pawn SeenPlayer )
	{
		//log( "See Player Called in UsePatrol" );
		Global.SeePlayer ( SeenPlayer );
		// have an enemy now?
		if ( Enemy != None )
		{
			// stop sleeping/rotating and react
			BreakSleep ( );
		}
	}

	function HearNoise ( float Loudness, Actor NoiseMaker )
	{
		Global.HearNoise ( Loudness, NoiseMaker );
		// actually heard something dangerous?
		if ( CurrentNoiseLoudness > 0 )
		{
			// stop sleeping/rotating and react
			BreakSleep ( );
		}
	}

	event NotifyTakeHit ( Pawn InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum )
	{
		Global.NotifyTakeHit ( InstigatedBy, HitLocation, Damage, DamageType, Momentum );
		// person who hit me was or now is my attacker?
		if ( Attacker == InstigatedBy )
		{
			// stop sleeping/rotating and react
			BreakSleep ( );
		}
	}

	function SetNewFocus ( )
	{
		// call helper
		SetSpecificFocus ( CurrentAINode.GetPatrolLookPoint ( ) );
	}

	function SetSpecificFocus ( LookTarget NewFocus )
	{
		// valid?
		if ( NewFocus != None )
		{
			// in front?
			if ( ActorInFront ( NewFocus ) )
			{
				// aim
				SetViewFocus ( NewFocus, SFT_Aim );
			}
			else
			{
				// turn & aim
				SetViewFocus ( NewFocus, SFT_Full );
			}
		}
		else
		{
			// clear
			SetViewFocus ( None );
		}
	}

Begin:

	// no look targets?
	if ( CurrentAINode.LookTargets.Length == 0 )
	{
		// turn off any procedural aiming
		SetViewFocus ( None );
		Focus = None;
		
		// face in direction of node
		FocalPoint = MyPawn.Location + 1000 * Vector ( CurrentAINode.Rotation );

		// wait
		Sleep ( CurrentAINode.WaitTimeMin + ( frand( ) * ( CurrentAINode.WaitTimeMax - CurrentAINode.WaitTimeMin ) ) );
	}
	// random method?
	else if( CurrentAINode.bRandomLook )
	{
		// look at 3 random looktargets
		for( CurrLookIndex = 0; CurrLookIndex < 3; CurrLookIndex++ )
		{
			// look at something...
			SetNewFocus ( );
			// wait
			Sleep( 0.3333 * ( CurrentAINode.WaitTimeMin + ( frand ( ) * ( CurrentAINode.WaitTimeMax - CurrentAINode.WaitTimeMin ) ) ) );

			// interupted?
			if( Enemy != None || Attacker != None || ( CurrentNoiseLoudness > 0.0 && ( Level.TimeSeconds - CurrentNoiseTime < 5.0 ) ) )
			{
				Goto( 'Done' );
			}
		}
	}
	// look at focal points in sequence
	else
	{
		// loop over all LookTargets in sequence and wait for a time dependant on the total 
		for ( CurrLookIndex = 0; CurrLookIndex < CurrentAINode.LookTargets.Length; CurrLookIndex++ )
		{
			// look at current focus point
			SetSpecificFocus ( CurrentAINode.LookTargets[CurrLookIndex] );

			// wait
			Sleep ( ( 1 / CurrentAINode.LookTargets.Length ) * ( CurrentAINode.WaitTimeMin + ( frand ( ) * ( CurrentAINode.WaitTimeMax - CurrentAINode.WaitTimeMin ) ) ) );

			// interupted?
			if ( Enemy != None || Attacker != None || ( CurrentNoiseLoudness > 0.0 && ( Level.TimeSeconds - CurrentNoiseTime < 5.0 ) ) )
			{
				Goto ( 'Done' );
			}
		}
	}

	// clear procedural aiming
	SetViewFocus ( None );

Done:

	// free up this node and go back to idle where I'll pick a new patrol node
	CurrentAINode.ReleaseNode ( Self );
	CurrentAINode = None;	
	ZBotGotoState ( 'Idle' );
}

//////////////////////////////////////////////////////////
//	Movement - Functions & States specific to movement  //
//////////////////////////////////////////////////////////

// Movement access function - all moves should go through this function
event MoveToNode ( PathNode DestNode, optional bool bCanMoveShoot, optional bool bFaceTarget )
{
	// bad data?
	if ( DestNode == None )
	{
		return;
	}

	// store data
	bFaceDestination = bFaceTarget;
	bFireWhileMoving = bCanMoveShoot;
	CurrentDest = DestNode;
	// will be none if not a ZombieAINode
	DestAINode = ZombieAINode ( CurrentDest );
	
	// goto moving state
	ZBotGotoState ( 'MovingToNode' );
}

// called when MovingToNode is finished
function ReachedNode ( )
{
	// unset the flag
	if ( bInvestigateNoise )
	{
		CurrentNoiseLoudness = 0.0;
		bInvestigateNoise = false;
		// no more procedural
		SetViewFocus ( None );
	}

	// clean current destination
	CurrentDest = None;

	// moving to AINode?
	if ( DestAINode != None )
	{
		//log ( "ReachedNode - DestAINode:"@DestAINode@"UsingAsCover:"@DestAINode.bUsingAsCover@"UsingAsPatrol:"@DestAINode.bUsingAsPatrol );
		// store as current
		CurrentAINode = DestAINode;
		DestAINode = None;
		// moving to cover?
		if ( CurrentAINode.bUsingAsCover )
		{
			CurrentAINode.BotArrivalTime = Level.TimeSeconds;

			//notify other bots that this botis finished moving
			AIManager.NotifyDoneMoving( Self );

			// use the cover
			ZBotGotoState ( 'UseCover' );
			return;
		}
		// move to patrol?
		else if ( CurrentAINode.bUsingAsPatrol )
		{
			// use the patrol node
			ZBotGotoState ( 'UsePatrol' );
			return;
		}
	}

	// goto idle
	ZBotGotoState ( 'Idle' );
}

// called whenever you want to stop the bot's current movement
function CancelMovement ( )
{
	// unset the flag
	if ( bInvestigateNoise )
	{
		CurrentNoiseLoudness = 0.0;
		bInvestigateNoise = false;
	}

	//log ( "CancelMovement" );
	if ( DestAINode != None )
	{
		// release the node
		DestAINode.ReleaseNode ( Self );
	}
	// clear data
	CurrentDest = None;
	DestAINode = None;
	// stop moving
	if ( NavigationPoint ( MoveTarget ) != None )
	{
		NavigationPoint ( MoveTarget ).AddExtraCost ( 0 );
	}
	MoveTarget = MyPawn;
	Destination = MyPawn.Location;
	MyPawn.Velocity = vect ( 0, 0, 0 );
	MyPawn.Acceleration = MyPawn.Velocity;
}

// stubby
function TryCancelMovement ( );

//
// MovingToNode
// The bot is in this state when it is moving to a node.
// He can fire while moving if flags are set.
// He will face his destination when no enemy or if forced to
state MovingToNode
{
	function TryCancelMovement( )
	{
		local bool bCancel;
		bCancel = false;

		if( MyPawn.IsMP( ) )
		{
			//if( Enemy != None )
			//{
			//	ZBotGotoState( 'CloseCombat' );
			//	CancelMovement( );
			//}
			return;
		}

		// not moving to an AI Node?
		if( DestAINode == None )
			bCancel = true;	// cancel allowed

		// moving to an ai node, but not using it as cover or patrol
		if( !bCancel && !DestAINode.bUsingAsPatrol && !DestAINode.bUsingAsCover )
			bCancel = true;	// cancel allowed

		// moving to an ai node, and using it as patrol
		if( !bCancel && DestAINode.bUsingAsPatrol )
			bCancel = true;	// cancel allowed

		// moving to an ai node, and using as cover, but no longer valid cover for my enemy
		if( !bCancel && ( DestAINode.bUsingAsCover && Enemy != None && !DestAINode.IsGoodCoverFor( Enemy.Location ) ) )
			bCancel = true;	// cancel allowed

		// not moving to an AI node - or - using node as patrol - or - want to use as cover and is not valid for this enemy
		if( bCancel )
		{
			BreakSleep();
			// when moving back to crouching cover after leaning.. this could happen
			if( DestAINode != None && DestAINode.bShouldCrouch && MyPawn.bIsCrouched )
			{
				// ... and he sometimes gets stuck crouching
				MyPawn.ShouldCrouch ( false );
			}

			// cancel movement and goto state idle
			CancelMovement( );
			ZBotGotoState( 'Idle' );
		}
	}

	event SeePlayer( Pawn SeenPlayer )
	{
		//log( "See Player Called in MovingToNode" );
		Global.SeePlayer( SeenPlayer );
		// try to cancel movement - won't cancel if moving to cover that is valid for 
		if( SeenPlayer == Enemy )
		{
			//log ( "TryCancelMovement - SeePlayer" );
			TryCancelMovement( );
		}
	}

	event NotifyTakeHit( Pawn InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum )
	{
		Global.NotifyTakeHit( InstigatedBy, HitLocation, Damage, DamageType, Momentum );
		// person who hit me is now my attacker?
		if( Attacker == InstigatedBy )
		{
			//log ( "TryCancelMovement - NotifyTakeHit" );
			TryCancelMovement( );
		}
	}

	event HearNoise( float Loudness, Actor NoiseMaker )
	{
		Global.HearNoise( Loudness, NoiseMaker );
		// actually heard something dangerous?
		if( CurrentNoiseLoudness > 0 && !bInvestigateNoise )
		{
			//log ( "TryCancelMovement - HearNoise" );
			TryCancelMovement( );
		}
	}

	//function BeginState( )
	//{
	//	SetViewFocus( None );
	//}

Begin:

	// nowhere to go?
	if( CurrentDest == None || Pawn == None )
	{
		//log( "Nowhere to go" );
		Sleep( 0.1 );
		ZBotGotoState( 'Idle' );
	}

Moving:

	Sleep( 0.01 );
	// find a way to it
	MoveTarget = FindPathToward( CurrentDest );

	// can't get to this node
	if( MoveTarget == None )
	{
		Sleep( 0.1 );
		//Goto( 'Begin' );
		ZBotGotoState( 'Idle' );
	}

	// make sure
	if( bFaceDestination || Enemy == None )
	{
		Focus = MoveTarget;
	}

	// experimental - try to keep others away
	if( NavigationPoint( MoveTarget ) != None )
	{
		NavigationPoint( MoveTarget ).AddExtraCost( 500 );
	}

	// move to it
	if( Enemy != None && bFireWhileMoving && WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
	{
		//log( "MovingToNode should be fireing" );
		FireMoveToward( MoveTarget, Focus, 0.0, false, MyPawn.bIsWalking, true);
	}
	else
	{
		//log( "MovingToNode should not be fireing" );
		FireMoveToward( MoveTarget, Focus, 0.0, false, MyPawn.bIsWalking, false);
	}

	//Sleep( 0.1 );
	// experimental - fix it back
	if( NavigationPoint( MoveTarget ) != None )
	{
		NavigationPoint( MoveTarget ).AddExtraCost( 0 );
	}

	// are we there yet?
	if( !Pawn.ReachedDestination( CurrentDest ) )
	{
		Goto( 'Moving' );
	}

Done:

	if( bInvestigateNoise )
	{
		Sleep( 4 );
		//Sleep( 0.1 );
		SetIdle( );
	}
	// done
	ReachedNode( );

	//Sleep ( 10.0 );
	Sleep( 0.1 );

	if( CurrentDest == None )
	{
		log( "MovingToNode - Stuck!!! CurrentDest is none!" );
	}
	else
	{
		log( "MovingToNode - Stuck!!! Unhandled node of class"@CurrentDest.Class );
	}

	Goto( 'Done' );
}

//
// ZBotWaitForLanding
// Bot is in this state when waiting for landing to complete.
state ZBotWaitForLanding
{
	// TODO - Might be able to shoot while falling which would require not 
	// ignoring some things
	ignores NotifyStartFalling;

	function Vector MoveCorrection( )
	{
		local Vector move;

		move.x = frand();
		move.y = frand();
		move.z = 0;

		move = Normal( move );
		return move;
	}

Begin:

	// Clear focus
	SetViewFocus ( None );
	Focus = None;
	FocalPoint = Pawn.Location + 1000 * Vector ( MyPawn.Rotation );

	// wait for landing to complete
	WaitForLanding ( );

	// move the ai a little
	//FallingMoveTarget = FindPathTo( MoveCorrection( ) )
	//if( FallingMoveTarget != None )
	//{
	//	FireMoveTo( FallingMoveTarget, Enemy, false, false );
	//}

	// Goto previous state
	ZBotGotoState ( MyLastState );
}

// Bot goes to this state when the enemy is too close for cover to be effective
state CloseCombat
{
	event SeePlayer( Pawn SeenPlayer )
	{
		//log( "See Player Called in closequarter" );
		Global.SeePlayer( SeenPlayer );
		// have an enemy now?
		if( Enemy == SeenPlayer )
		{
			//TODO::do something, maybe, well probably not
		}
	}

	event EnemyNotVisible( )
	{
		Global.EnemyNotVisible( );

		//if we have not seen our enemy for a couple seconds them go after them
		if( Level.TimeSeconds - LastSeenTime > 1.0 )
		{
			//log( "Left CloseCombat for PursueEnemy" );
			ZBotGotoState( 'PursueEnemy' );
		}
	}

	function Vector GetMovePoint( bool bMoveBack, bool bCircle )
	{
		local Vector toPointOnCircle;
		local Vector dummy;
		local Vector dummy2;
		local Vector newDest2;
		local Vector testDest;
		local float  strafeAngle, scale;
		local Actor  hitActor;
		local int    i;

		if( bCircle )
		{
			//get the vector from the enemy to the AI 
			toPointOnCircle = MyPawn.Location - Enemy.Location;
		}
		else
		{
			//get the vector for the direction the AI is facing
			toPointOnCircle = Pawn.GetBoneCoords ( 'blink' ).Origin - Pawn.GetBoneCoords ( 'Head' ).Origin;
		}
		for( i = 0; i < 3; i++ )
		{
			if( !bCircle )
			{
				if( i == 0 )
					scale = 15;
				else if( i == 1 )
					scale = 10;
				else if( i == 2 )
					scale = 5;

				toPointOnCircle.X *= scale;
				toPointOnCircle.Y *= scale;
				toPointOnCircle.Z  =  0;
			}
			if( bCircle )
			{
				toPointOnCircle.X *= STRAFE_SCALE;
				toPointOnCircle.Y *= STRAFE_SCALE;
				toPointOnCircle.Z = 0;//STRAFE_SCALE;

				//find an angle between CIRCLE_STRAFE_MIN_ARC and CIRCLE_STRAFE_MIN_ARC + CIRCLE_STRAFE_ARC
				strafeAngle = FRand() * CIRCLE_STRAFE_ARC + CIRCLE_STRAFE_MIN_ARC;
				if( i == 1 )
					strafeAngle /= 2.0;
				else if( i == 2 )
					strafeAngle /= 3.0;
				//randomly mirror this angle
				if( Rand( 2 ) == 0 )
					strafeAngle = -strafeAngle;
			}
			else if( bMoveBack )
			{
				//find an angle between CIRCLE_STRAFE_MIN_ARC and CIRCLE_STRAFE_MIN_ARC + CIRCLE_STRAFE_ARC
				strafeAngle = FRand() * 23666 + 18204;
			}
			else
			{
				//find an angle between CIRCLE_STRAFE_MIN_ARC and CIRCLE_STRAFE_MIN_ARC + CIRCLE_STRAFE_ARC
				strafeAngle = FRand() * 16384 - 8192;
			}

			//find the new point we want to move too
			FindNewCirclePoint( strafeAngle, toPointOnCircle );
			
			newDest2 = Pawn.Location + toPointOnCircle;
			newDest = newDest2;

			testDest = newDest2 + Normal( newDest2 - Pawn.Location ) * 10;
			//make sure the AI does not have to path around objects to circle around player
			hitActor = Trace( dummy, dummy2, testDest, Pawn.Location );
			if( hitActor != None )
				newDest2 = Pawn.Location;
			else
				break;
		}
		return newDest2;
	}
Begin:
	if( !MyPawn.IsMP( ) )
		SetViewFocus( Enemy, SFT_Aim );
	do
	{
		if( MyPawn == None || MyPawn.Weapon == None )
		{
			Sleep( 10.0 );
			continue;
		}
		Sleep( frand() * 0.5 + 0.2 );
		//log( "Enemy"@Enemy );
		if( Enemy != None )
		{
			lastCombatLoc = Pawn.Location;
			if( MyPawn.MyWeapon == MyPawn.Weapons[MyPawn.WEAPSLOT_Knife] )
			{
				// stand up and run
				MyPawn.ShouldCrouch( false );
				MyPawn.bIsWalking = false;

				//log( "Left CloseCombat for KnifeRush" );
				ZBotGotoState( 'KnifeRush' );
			}

			//log( "Pawn.Location"@Pawn.Location );
			if( bFindNewDest )
			{
				if( MyPawn.IsMP( ) )
					destinationPoint = GetMovePoint( false, true );
				else if( VSIZE( MyPawn.Location - Enemy.Location ) < 150 )
					destinationPoint = GetMovePoint( true, false );
				else if( VSIZE( MyPawn.Location - Enemy.Location ) > 500 )
					destinationPoint = GetMovePoint( false, false );
				else
					destinationPoint = GetMovePoint( false, true );

				if( destinationPoint != Pawn.Location )
				{
					bFindNewDest = false;
				}
				else
				{
					//if we can see our enemy but are not doing anything then shoot at them
					if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
					{
						CurrFireType = BotFireType( Rand( 4 ) );
						BurstsToFire = Rand( 2 ) + 1;
						FireWhileInCover();
					}
				}
			}

			//log( "destinationPoint"@destinationPoint );
			if( !PointReachable( destinationPoint ) )
			{
				//log( "Trying to find a Path To." );
				MoveTarget = FindPathTo( destinationPoint );
				if( MoveTarget == None )
				{
					bFindNewDest = true;
					//if we can see our enemy but are not doing anything then shoot at them
					if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
					{
						CurrFireType = BotFireType( Rand( 4 ) );
						BurstsToFire = Rand( 2 ) + 1;
						FireWhileInCover();
					}
					//Sleep ( 0.1 );
					continue;
				}
				if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
				{
					//log( "Tried MoveToward" );
					FireMoveToward( MoveTarget, Enemy, 0.0, true, false, true );
				}
				else
				{
					FireMoveToward( MoveTarget, Enemy, 0.0, true, false, false );
				}
			}
			else
			{
				if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
				{
					//log( "Tried MoveTo" );
					FireMoveTo( destinationPoint, Enemy, false, true );
				}
				else
				{
					FireMoveTo( destinationPoint, Enemy, false, false );
				}
				CancelMovement();
				if( IsNear( Pawn.Location, destinationPoint, NEAR_EPSILON ) )
				{
					bFindNewDest = true;
				}
			}
			bFindNewDest = true;
		}
		else
		{
			Sleep( 0.01 );
			bFindNewDest = true;
			if( MyPawn.IsMP( ) )
			{
				ZBotGotoState( 'DeathmatchIdle' );
			}
			else
			{
				//log( "Left CloseCombat for Idle" );
				ZBotGotoState( 'Idle' );
			}
		}
	}
	until( I_LEAVE_STATE != 1 )
}

// Bot goes to this state when they are engaged with the enemy but the bot has lost sight of the enemy
state PursueEnemy
{
	ignores EnemyNotvisible;
	event SeePlayer( Pawn SeenPlayer )
	{
		Global.SeePlayer( SeenPlayer );

		//if we see our enemy then go back to close engagement
		if( Enemy == SeenPlayer )
		{
			CancelMovement( );
			//log( "I went to CloseCombat from PursueEnemy" );
			ZBotGotoState( 'CloseCombat' );
		}
	}

Begin:
	do
	{
		if( Enemy == None )
			ZBotGotoState( 'Idle' );
		//if we can just go to the enemy don't use find path
		if( !ActorReachable( Enemy ) )
		{
			// find a way to the enemy
			MoveTarget = FindPathToward( Enemy );

			// can't get to this node
			if ( MoveTarget == None )
			{
				Sleep( 0.1 );
				ZBotGotoState( 'Idle' );
			}
		}
		else
		{
			MoveTarget = Enemy;
		}

		if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
		{
			// move toward the enemy
			FireMoveToward( MoveTarget, Enemy, 0.0, false, false, true );
		}
		else
		{
			FireMoveToward( MoveTarget, Enemy, 0.0, false, false, false );
		}
	}
	until( I_LEAVE_STATE != 1 )
}

// Bot goes to this state when he has only a knife to fight with
// the bot just tries to get close to enemy
state KnifeRush
{
	event SeePlayer( Pawn SeenPlayer )
	{
		Global.SeePlayer( SeenPlayer );
		// have an enemy now?
		if( Enemy == SeenPlayer )
		{
			//if we are too close to this enemy then stop all movement
			if( VSize( Enemy.Location - MyPawn.Location ) < 110 )
			{
				CancelMovement( );
			}
			// stop sleeping/rotating and react
			BreakSleep( );
		}
	}
Begin:

	//if we have an enemy
	if( Enemy != None )
	{
		//if we are close enough don't try to get closer
		if( VSize( Enemy.Location - MyPawn.Location ) < 110 )
		{
			Sleep( 0.5 );
			CurrFireType = BFT_Snipe;
			BurstsToFire = 1;
			FireWhileInCover();
			Goto( 'Begin' );
		}

		//if we can just go to the enemy don't use find path
		if( !ActorReachable( Enemy ) )
		{
			// find a way to the enemy
			MoveTarget = FindPathToward( Enemy );

			// can't get to this node
			if ( MoveTarget == None )
			{
				Sleep( 0.1 );
				ZBotGotoState( 'Idle' );
			}
		}
		else
		{
			MoveTarget = Enemy;
		}

		if( WeaponCouldHit( Enemy.Location ) && CanSee( Enemy ) )
		{
			// move toward the enemy
			FireMoveToward( MoveTarget, Enemy, 0.0, false, false, true );
		}
		else
		{
			FireMoveToward( MoveTarget, Enemy, 0.0, false, false, false );
		}
		Goto( 'Begin' );
	}
	else
	{
		//CancelMovement( );
		ZBotGotoState( 'Idle' );
	}
}

State KickGrenadeState
{

Begin:
	//if the grenade is still valid
	if( NearbyForeignGrenade != None )
	{
		//if we are close enough don't try to get closer
		if( VSize( NearbyForeignGrenade.Location - MyPawn.Location ) < 110 )
		{
			Sleep( 0.15 );
			MyPawn.AnimBlendParams ( MyPawn.CHANNEL_WeaponHandling, 1.0, 0.25, 0.25, MyPawn.RootBone, true );
			MyPawn.PlayAnim ( 'Grenade_Kick', 1.0, 0.0, MyPawn.CHANNEL_WeaponHandling );
			FinishAnim ( MyPawn.CHANNEL_WeaponHandling );

			ZBotGotoState( 'Idle' );
		}

		//if we can just go to the Grenade don't use find path
		if( !ActorReachable( NearbyForeignGrenade ) )
		{
			// find a way to the grenade
			MoveTarget = FindPathToward( NearbyForeignGrenade );

			// can't get to this node
			if ( MoveTarget == None )
			{
				Sleep ( 0.1 );
				ZBotGotoState ( 'Idle' );
			}
		}
		else
		{
			MoveTarget = NearbyForeignGrenade;
		}

		// move toward the grenade
		FireMoveToward ( MoveTarget, NearbyForeignGrenade, 0.0, false, false, false );
		Goto( 'Begin' );
	}
	else
	{
		//CancelMovement( );
		ZBotGotoState( 'Idle' );
	}
}

// Dead
// Bot is in this state when waiting for pawn to be destroyed
// He is DEAD
state Dead
{
	ignores SeePlayer, EnemyNotVisible, HearNoise, NotifyTakeHit, NotifyStartFalling;

	event PawnDied ( Pawn P );

Begin:

	Sleep ( 1.0 );
	Destroy ( );
	Goto ( 'Begin' );
}

//
// Scripting
// The bot is in this state when it is being controlled by a script.
state Scripting
{
	ignores HearNoise, SeePlayer, ReceiveWarning, NotifyAddInventory, EnemyNotVisible, SeeMonster;

	event NotifyTakeHit ( Pawn InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum );

	function Tick ( float DeltaTime );

	simulated function DisplayDebug ( Canvas Canvas, out float YL, out float YPos )
	{
		Global.DisplayDebug ( Canvas, YL, YPos );
	}

	function NotifyStartFalling ( )
	{
		// kill movement
		MoveTarget = MyPawn;
		if ( MyPawn != None )
		{
			Destination = MyPawn.Location;
			MyPawn.Acceleration = vect ( 0, 0, 0 );
			MyPawn.Velocity = MyPawn.Acceleration;
		}
	}

	function MayFall ( )
	{
		if ( Pawn.bCanJump )
		{
			Pawn.DoJump ( false );
		}
	}

	function AnimEnd ( int Channel )
	{
		if ( CurrentAction.CompleteOnAnim ( Channel ) )
		{
			CompleteAction ( );
		}
	}

	function LeaveScripting ( )
	{
		ZBotGotoState ( 'inactive' );
	}

	function Trigger ( actor Other, pawn EventInstigator )
	{
		if ( CurrentAction.CompleteWhenTriggered ( ) )
		{
			CompleteAction ( );
		}
	}

	function Timer ( )
	{
		if ( CurrentAction.WaitForPlayer ( ) && CheckIfNearPlayer ( CurrentAction.GetDistance ( ) ) )
		{
			CompleteAction ( );
		}
		else if ( CurrentAction.CompleteWhenTimer ( ) )
		{
			CompleteAction();
		}
	}

	function CompleteAction ( )
	{
		ActionNum++;
		ZBotGotoState ( 'Scripting', 'Begin' );
	}

	function SetMoveTarget()
	{
		local Actor NextMoveTarget;

		Focus = ScriptedFocus;
		NextMoveTarget = CurrentAction.GetMoveTargetFor ( self );
		if ( NextMoveTarget == None )
		{
			ZBotGotoState ( 'Broken' );
			return;
		}
		if ( Focus == None )
			Focus = NextMoveTarget;
		MoveTarget = NextMoveTarget;
		if ( !ActorReachable ( MoveTarget ) )
		{
			MoveTarget = FindPathToward ( MoveTarget );
			if ( MoveTarget == None )
			{
				AbortScript();
				return;
			}
			if ( Focus == NextMoveTarget )
				Focus = MoveTarget;
		}
	}

	function AbortScript()
	{
		LeaveScripting();
	}

	function BeginState ( )
	{
		// turn off any procedural aiming
		SetViewFocus ( None );
		bScripting = true;
	}
	
	function EndState ( )
	{
		bScripting = false;
	}

Begin:
	
	InitforNextAction();

	if ( bBroken )
	{
		ZBotGotoState ( 'Broken' );
	}

	if ( CurrentAction.MoveToGoal ( ) )
	{
		Pawn.SetMovementPhysics ( );

KeepMoving:

		WaitForLanding ( );

		SetMoveTarget ( );

		FireMoveToward ( MoveTarget, Focus, , Pawn.bCanStrafe, Pawn.bIsWalking, false );
		if ( ( MoveTarget != CurrentAction.GetMoveTargetFor ( self ) )
			|| !Pawn.ReachedDestination ( CurrentAction.GetMoveTargetFor ( self ) ) )
		{
			Goto('KeepMoving');
		}
		
		Focus = None;
		CompleteAction();
	}
	else if ( CurrentAction.TurnToGoal ( ) )
	{
		Pawn.SetMovementPhysics();
		WaitForLanding();
		Focus = CurrentAction.GetMoveTargetFor ( self );
		if ( Focus == None )
		{
			FocalPoint = Pawn.Location + 1000 * Vector ( SequenceScript.Rotation );
		}
		FinishRotation ( );
		CompleteAction ( );
	}
	else if ( CurrentAction.CompleteOnShootingEnd ( ) )
	{
		CompleteAction ( );
	}
	else
	{
		WaitForLanding ( );
		Pawn.Acceleration = vect(0,0,0);
		Focus = ScriptedFocus;
		FinishRotation ( );
	}
}

// Broken scripted sequence - for debugging
State Broken
{
Begin:

	warn ( MyPawn@Self@"BROKEN! Scripted Sequence:"@SequenceScript@"Action:"@CurrentAction@"LastState:"@MyLastState );
Wheee:	

	Sleep ( 100 );
	Goto ( 'Wheee' );
}


// Decompiled with UE Explorer.
defaultproperties
{
    LastWeaponIndex=-1
    bFindNewDest=true
    bOpenDoors=true
    AlertTime=10000000.0000000
    ResponseTime=10000000.0000000
    bIsPlayer=true
    bUseBoxCheck=true
    IsZController=true
}