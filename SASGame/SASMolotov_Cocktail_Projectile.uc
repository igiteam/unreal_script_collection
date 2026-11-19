
//=============================================================================
// SASMolotov_Cocktail_Projectile.uc
// 
//=============================================================================

class SASMolotov_Cocktail_Projectile extends SASGrenadeProjectile
	native			
	placeable;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Contants

const NUM_BURST_EFFECTS = 2;

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var(Molotov) class<SASFireArea>				mPoolOfFireClass;
var(Molotov) class<SASExpandingProjector>	mFuelBurstEffectClass;
var(Molotov) class<SASExpandingProjector>	mFlameBurstEffectClass;
var(Molotov) Range							mScatterRange;

var transient Vector						mImpactVelocity;
var transient Actor							mImpactActor;
var transient SASExpandingProjector			mBurstProjectors[NUM_BURST_EFFECTS];
var transient SASFireArea					mFireArea;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
// 
event PostBeginPlay()
{
	local int i;

	for ( i = 0; i < NUM_BURST_EFFECTS; ++i )
	{
		mBurstProjectors[i] = None;
	}
}


///////////////////////////////////////////////////////////////////////////////
// TriggerHitWall
// 
// ICHACK - allow molotov's to trigger in the editor
event TriggerHitWall(
	Vector	aHitNormal,
	Vector	aIncidentTrajectory )
{
	Velocity = aIncidentTrajectory;
	Explode( Location, aHitNormal );
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
	// Store hit actor for flame spawning.
	mImpactActor = aWall;

	Super.HitWall( aHitNormal, aWall );
}


///////////////////////////////////////////////////////////////////////////////
// Explode
//
simulated function Explode(
	Vector		aHitLocation,
	Vector		aHitNormal )
{
	mImpactVelocity = Velocity;
	SetPhysics( PHYS_None );
	
	Super.Explode( aHitLocation, aHitNormal );

	// Start a fire
	CreatePoolOfFire( Location, aHitNormal );	

	// Create expanding circle of fire.
	//CreateBurstEffect(Location,mImpactVelocity);	// using trajectory as projector direction
	CreateBurstEffect(Location,-aHitNormal);	// using surface normal as projector direction
}


///////////////////////////////////////////////////////////////////////////////
// CreatePoolOfFire
//
function CreatePoolOfFire(
	vector		aHitLocation,
	vector		aHitNormal )
{
	local float radius;

	// calc area of effect - ictodo -> scale radius angle of incidence
	//CalcAreaOfEffect(aHitLocation, radius);
	radius = RandRange( mScatterRange.Min, mScatterRange.Max );

	// Start a fire.
	if ( mPoolOfFireClass != None )
	{
		mFireArea = Spawn( mPoolOfFireClass,,, aHitLocation, rotator( aHitNormal ) );
		mFireArea.StartFire( mImpactActor, radius, aHitNormal, mImpactVelocity );
	}
}


///////////////////////////////////////////////////////////////////////////////
// CreateBurstEffect
//
function CreateBurstEffect(
	vector	aHitLocation,
	vector	projDir )
{
	local Rotator R;

	R = rotator( projDir );

	if ( mFuelBurstEffectClass != None )
	{
		mBurstProjectors[0] = Spawn( mFuelBurstEffectClass,,, aHitLocation, R );//rot(-16384,0,0));
	}
	if ( mFlameBurstEffectClass != None )
	{
		mBurstProjectors[1] = Spawn( mFlameBurstEffectClass,,, aHitLocation, R );//rot(-16384,0,0));
	}
}


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mBounceDamping=1.0000000
    mTimeToExplode=0.0000000
    mbExplodeOnImpact=true
    Mesh=SkeletalMesh'WpAn.Grenade_Projectile'
    bBounce=false
}