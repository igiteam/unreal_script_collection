//=============================================================================
// SASGrenadeProjectile.uc
//
// Abstract base class for projectiles launched from SAS grenade weapons. 
//=============================================================================

class SASGrenadeProjectile extends Projectile
	native
	abstract;

//-----------------------------------------------------------------------------
// Contants
//
const GRENADE_NEAR_RESTING_SPEED_THRESHOLD = 240.0;

//-----------------------------------------------------------------------------
// Member Vars
//
var EGrenadeCategory	mCategory;
var bool				mbIsHarmless;				// Set to true when grenade no longer has any effect.
var const int			mVisibility;				// Measure of probability of being seen by a pawn  (0->128, where 0 is invisible)
var const float			mBounceDamping;				// Velocity damping factor applied upon collisions
var const float			mTimeToExplode;				// Time to explode after pin pulled
var Range				mThrowElevationRange;		// Range of elevations can be released at by throwing NPCs
var Range				mLaunchSpeedRange;			// Range of speeds can be released at by throwing NPCs
var bool				mbExplodeOnImpact;			// If true then explodes on impact
var float				mMaxImpactLoudness;			// MakeNoise() loudness level on bounce at maximum speed. Applied value scaled with speed.

var class<SASGenericExplosion>	mExplosionClass;	// Generic xxplosion class
var int					mNumExplosions;				// Num explosions to fire off
var Range				mTimeBetweenExplosions;		// Min/max time between explosions
var bool				mbAttachExplosions;			// Flag to indicate explosion objects should be attached to us
var float				mLifetimeAfterExplosions;	// Lifetime of object after explosions have been spawned
	
var float				mTimeThrown;
var float				mSpeed2D;					// Current speed in XY plane.
var float				mApproxRestingRange2D;		// Aprroximate 2d range that grenade is likely to come to rest within.
var bool				mbNearResting;	
var bool				mbCanHitOwner;				// Does it collide with instigator?
var bool				mbHitWater;					// Fallen into water?
var Vector				mLastShoutLocation;			// Last position of this grenade when a pawn shouted an alert about it.

var int					mExplosionsTriggered;		// Num explosions triggered

var(Sound) array<Sound>	mImpactSounds;
var(Sound) array<Sound> mImpactSoundsSoft;


//-----------------------------------------------------------------------------
// Native Functions
//

///////////////////////////////////////////////////////////////////////////////
// InitDamageRadius
//
native final function InitDamageRadius();

///////////////////////////////////////////////////////////////////////////////
// FinishedExploding
//
// Informs relevant AI controllers that the grenade has finshed exploding.
native function FinishedExploding();

///////////////////////////////////////////////////////////////////////////////
// CalcAILaunchVelocity
//
native function Vector CalcAILaunchVelocity();


//-----------------------------------------------------------------------------
// Functions
//

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
// Called after level has started and grenade has been spawned.
//simulated event PostBeginPlay()
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	Speed = Default.Speed;
	SetCollision( false, false, false );
	SetPhysics( PHYS_None );
	SetBase( None );

	// Check time between explosions has sensible values
	if ( mNumExplosions > 1 )
	{
		if ( mTimeBetweenExplosions.Min <= 0.0 )
		{
			mTimeBetweenExplosions.Min = 0.05;
		}
		mTimeBetweenExplosions.Max = FMax( mTimeBetweenExplosions.Min, mTimeBetweenExplosions.Max );
	}

	// Init the projectiles damage radius - this equals the maximum damage radius of it's 
	// explosions/gas effect etc.
	InitDamageRadius();
}


///////////////////////////////////////////////////////////////////////////////
// Destroyed
//
simulated event Destroyed()
{
	Super.Destroyed();

	// Make sure AI know we're no longer going to explode.
	FinishedExploding();
}


///////////////////////////////////////////////////////////////////////////////
// GetSpecialDamageRadius
//
// Used in calculating the grenades damage radius. Normally thisa will be 
// equal to our explosion classes max damage radius but in the case of things
// like gas grenades/flashbangs this equals the gas/flash radius.
event float GetSpecialDamageRadius()
{
	return -1.0;
}


///////////////////////////////////////////////////////////////////////////////
// Throw
//
// Initialise grenade motion on being released from hand.
simulated function Throw ()
{
	mTimeThrown		= Level.TimeSeconds;
	mbCanHitOwner	= false;
	mbHitWater		= false;
	bHidden			= false;

	SetCollision( true );
	SetPhysics( PHYS_Falling );
	//bBounce = true;

	SetTimer( mTimeToExplode, false );

	if ( Role == ROLE_Authority )
	{
		Velocity = vect(0,0,0);

		if ( !Instigator.IsHumanControlled() )
		{
			Velocity = CalcAILaunchVelocity();
		}

		if ( Velocity == vect(0,0,0) )
		{
			Velocity = GetTossVelocity( Instigator, Instigator.GetViewRotation() );
		}

		RandSpin( 50000 );	
		
		if ( Instigator.HeadVolume.bWaterVolume )
		{
			mbHitWater = true;
			Velocity = 0.6 * Velocity;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// Drop
//
// Drop grenade from hand (when holder dies).
simulated function Drop(
	bool	abPinPulled )
{
	mTimeThrown		= Level.TimeSeconds;
	mbCanHitOwner	= false;
	mbHitWater		= false;
	bHidden			= false;

	SetCollision( true );
	SetPhysics( PHYS_Falling );
	//bBounce = true;

	// If pin hasnt been pulled then just allow the grenade to fall and then destroy it 
	// shortly after. Otherwise prepare it to explode.
	if ( !abPinPulled )
	{
		SetTimer( 0.0, false );
 		LifeSpan = Max( mLifetimeAfterExplosions, 5.0 );
	}
	else
	{
		SetTimer( mTimeToExplode, false );
	}

	if ( Role == ROLE_Authority )
	{
		Velocity = vect(0,0,0);
		RandSpin( 10000 );	
		
		if ( Instigator.HeadVolume.bWaterVolume )
		{
			mbHitWater = true;
			Velocity = 0.6 * Velocity;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// PhysicsVolumeChange
//
// Check if grenade has entered water
simulated event PhysicsVolumeChange(
	PhysicsVolume	aNewVolume )
{
	if ( !aNewVolume.bWaterVolume || mbHitWater ) 
	{
		return;
	}

	mbHitWater = true;
	//Spawn(class'WaterRing',,,,rot(16384,0,0));
	Velocity = 0.6 * Velocity;
}

///////////////////////////////////////////////////////////////////////////////
// Timer
//
// Called when time to explosion has expired.
simulated event Timer()
{
	Explode( Location + (Vect(0,0,1) * 16), vect(0,0,1) );
}

///////////////////////////////////////////////////////////////////////////////
// Landed
//
// Event called when collided floor. Treat as wall collision.
simulated event Landed(
	Vector	aHitNormal )			// Normal of surface collided with
{
	HitWall( aHitNormal, None );
}

///////////////////////////////////////////////////////////////////////////////
// ProcessTouch
//
// Called on colliding with actor (not level static geometry). 
// Bounce grenade off actor.
simulated function ProcessTouch(
	actor	aHitActor,				// Collidee actor
	Vector	aHitLocation )			// Collision location
{
	// Need to mod ProcessTouch to pass in hit normal so grenades will bounce
	// off actors.
	// For now just hack normal
	local Vector	hitNormal;
	local SASPawn	hitPawn;

	if ( !bBounce )
	{
		// Reactivate bouncing if hit by a mover.
		if ( Mover( aHitActor ) != None )
		{
			bBounce = true;
			SetPhysics( PHYS_Falling );
			
			// Impart a fake velocity to get us moving again.
			Velocity = Normal( aHitLocation - Location ) * RandRange( 100.0, 130.0 );
		}
	}

	// Ignore collision against throwing actor unless such a collision is 
	// flagged as allowable.
	if ( mbCanHitOwner || (aHitActor != Instigator) )
	{
		hitNormal.X = -Velocity.X;
		hitNormal.Y = -Velocity.Y;
		hitNormal.Z = 0.0;
		hitNormal = Normal( hitNormal );
	
		HitWall( hitNormal, None );

		hitPawn = SASPawn( aHitActor );
		if (	hitPawn != None && 
				hitPawn.Controller != None &&
				hitPawn.Controller.mType != CONTROLLER_Player )
		{
			SASAIController( hitPawn.Controller ).NotifyHitByGrenade( self );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// HitWall
//
// Called on colliding with wall (and floors, other collidable actors). 
// Rebound off wall with damping.
simulated event HitWall(
	Vector	aHitNormal,			// Collision normal
	Actor	aWall )				// Collidee actor
{
	local float				speed;
	local float				loudnessScale;
	//local int				groundType;
	local Sound				impactSound;
	local SASDamageableMesh	window;

	mbCanHitOwner = true;
	
	//Speed = VSize(Velocity);

	if ( mbExplodeOnImpact )
	{
		Explode( Location, aHitNormal );
	}
	else
	{
		// how loud a sound is it?
		speed = VSize( Velocity );
		loudnessScale = speed /  mLaunchSpeedRange.Max ;
		loudnessScale = FClamp( loudnessScale, 0.0, 1.0 );

		if ( Level.NetMode != NM_DedicatedServer )
		{
			/*if (groundMaterial == None)
				groundType = 0;
			else
				groundType = groundMaterial.mMaterialType;
				
			if (groundType >= mImpactSounds.Length)
				groundType = 0;*/

			if ( mImpactSounds.Length > 0 )
			{
				impactSound = mImpactSounds[Rand(mImpactSounds.Length)];
				if ( impactSound != None )
				{
					PlaySound(impactSound, SLOT_Misc, loudnessScale,,150,,true);
				}
			}
		}

		if ( loudnessScale > 0.0 )
		{
			MakeNoise( loudnessScale * mMaxImpactLoudness, NOISE_Ricochet );
		}
	}

	if ( bBounce )
	{
		// If hitting a window, either break it and maintain current direction with a speed drop
		// or bounce off depending on speed of impact in direction opposite window normal.
		// First need to see if its a window. Windows are destroyable static mesh actors which are 
		// marked as transparent meshes and have light bullet penetration setting.
		if (	SASDamageableMesh( aWall ) != None &&
				SASDamageableMesh( aWall ).IsAWindow() )
		{
			window = SASDamageableMesh( aWall );

			// Only do this if window not in final damage stage.
			if ( window.mCurrentStage < window.mDamageStages.Length )
			{
				// Determine if we are hitting window with enough force to break it.
				speed = -(Velocity Dot aHitNormal);
				if ( speed > 500.0 )
				{
					if ( speed > 800.0 || FRand() > 0.2 ) // 1 in 5 chance of not breaking window unless really moving.
					{
						window.TakeDamage(
								window.Health+1,
								Instigator,
								Location, 
								vect(0,0,0),
								None,
								SASWeapon( Owner ) );

						// Move projectile back very slightly incase point at which we hit still has 
						// window geometry to collide against in final damage stage (i.e. broken shards).
						SetLocation( Location - (Normal( Velocity ) * 2.0) );

						// Now reduce projectile speed.
						speed = VSize( Velocity );
						Velocity = Normal( Velocity ) * Max( (speed - 350.0), 100.0 );
						return;
					}
					else
					{
						// If there is an intermediate damage stage we can go to then switch to that.
						if ( window.mCurrentStage < window.mDamageStages.Length-1 )
						{
							// Give just enough damage to switch 1 stage.
							window.TakeDamage(
								(window.Health-window.mDamageStages[window.mCurrentStage].Health) + 1,
								Instigator,
								Location, 
								vect(0,0,0),
								None,
								SASWeapon( Owner ) );
						}
					}
				}
			}
		}

		// Relect off wall with damping.
		Velocity = mBounceDamping * ((Velocity Dot aHitNormal) * aHitNormal * (-2.0) + Velocity);
		RandSpin( 100000 );

		if ( Velocity.Z > 400.0 )
		{
			Velocity.Z = 0.5 * (400.0 + Velocity.Z);
		}
		else if ( VSizeSq( Velocity ) < Square( 20 ) && Mover( aWall ) == None ) 
		{
			// Come to rest if hit normal if near horizontal.
			if ( aHitNormal.Z > 0.6 )
			{
				bBounce		= false;
				SetPhysics( PHYS_None );
			}
		}
	}
	else
	{
		Velocity = vect(0,0,0);
		SetPhysics( PHYS_None );
	}
}

///////////////////////////////////////////////////////////////////////////////
// drawDebug
//
simulated function drawDebug (
			HUD aHUD)
{
	// do nothing
} // drawDebug

///////////////////////////////////////////////////////////////////////////////
// Explode
//
simulated function Explode(
	Vector		aHitLocation,
	Vector		aHitNormal )
{
	local SASGenericExplosion	myExplosion;
	local SASGameInfo			gi;

	// spawn the explosion effects, sound and damage
	if ( mExplosionClass != None )
	{
		myExplosion = Spawn( mExplosionClass, self,, aHitLocation, rot(16384,0,0) );
		mExplosionsTriggered++;

		// Attach explosion to self if required
		if ( mbAttachExplosions )
		{
			myExplosion.SetBase( self );
		}

		// Inform the squad manager that we've gone off.
		gi = SASGameInfo( Level.Game );
		if ( gi != None && gi.mSquadManager != None )
		{
			gi.mSquadManager.grenadeStartedExploding( self );
		}

		// Self destruct if all explosions have been triggered
		if ( mExplosionsTriggered >= mNumExplosions )
		{
			if ( mLifetimeAfterExplosions > 0.0 )
			{
 				LifeSpan = mLifetimeAfterExplosions;
			}
			else
			{
				Destroy();
			}

			FinishedExploding();
		}
		else
		{
			SetTimer( RandRange( mTimeBetweenExplosions.Min, mTimeBetweenExplosions.Max ), false );
		}
	}
	else
	{
		// Init self destruction
		if ( mLifetimeAfterExplosions > 0.0 )
		{
 			LifeSpan = mLifetimeAfterExplosions;
		}
		else
		{
			Destroy();
		}

		FinishedExploding();
	}
}

//-----------------------------------------------------------------------------
// Default Properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=5
    mVisibility=64
    mBounceDamping=0.6800000
    mTimeToExplode=3.0000000
    mThrowElevationRange=(Min=3000.0000000,Max=10000.0000000)
    mLaunchSpeedRange=(Min=0.0000000,Max=1400.0000000)
    mMaxImpactLoudness=0.2000000
    mNumExplosions=1
    mTimeBetweenExplosions=(Min=0.3000000,Max=0.3000000)
    Speed=600.0000000
    MaxSpeed=1000.0000000
    LifeSpan=0.0000000
    bNetTemporary=false
    bAlwaysRelevant=true
    bUpdateSimulatedPosition=true
    bBounce=true
    bFixedRotationDir=true
}