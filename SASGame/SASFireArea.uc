//=============================================================================
// SASFireArea.uc
//
// An area of fire
//=============================================================================

class SASFireArea extends Actor
	native
	placeable;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const DAMAGE_TIMER_INTERVAL	 = 0.2;

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

var() float								mRadius;
var() class<SASFire>					mFireClass;
var() class<SASExpandingProjector>		mBurnMarkClass;
//var class<Emitter>					mSmokeClass;
//var class<Emitter>					mSparkClass;
var() float								mBlastSpacing;
var() range								mAngleIncrementRange;
var() int								mNumBlastRays;
var SASFire								mFireEmitter;

var() float								mHeatDamagePerSecond;
var() float								mFlameDamagePerSecond;
var() Range								mDamageDist;	// type of damage => [0-Min) = flame; [Min-Max] = heat
var float								mDamageTimer;

//-----------------------------------------------------------------------------
// Native Functions

native function ScatterFireInCircle(
	Actor	aHitActor,
	vector	aSurfaceNormal, 
	vector	aInitiatorTrajectory );


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
// 
// ICHACK - allow molotov's to trigger in the editor
event PreBeginPlay()
{
	// override Actor.PreBeginPlay -> otherwise class is Destroy()'d on construction in editor
}


///////////////////////////////////////////////////////////////////////////////
// StartFire
//
simulated function StartFire(
	Actor	aHitActor,
	float	aInitialRadius,
	vector	aSurfaceNormal,
	vector	aInitiatorTrajectory )
{
	mDamageTimer = DAMAGE_TIMER_INTERVAL;
	mRadius = aInitialRadius;

	// Init fire emitters
	ScatterFireInCircle( aHitActor, aSurfaceNormal, aInitiatorTrajectory );	// Fire emitters

	// Apply burn makr decal.
	if ( mBurnMarkClass != None )									// Burn mark
	{
		Spawn( mBurnMarkClass,,, Location, rotator(aSurfaceNormal) );//rot(-16384,0,0));
	}
}


//-----------------------------------------------------------------------------
// defaults


// Decompiled with UE Explorer.
defaultproperties
{
    mBlastSpacing=20.0000000
    mAngleIncrementRange=(Min=0.7853980,Max=0.7853980)
    mNumBlastRays=6
    LightBrightness=200.0000000
    LightRadius=40.0000000
    LightType=5
    LightHue=28
    LightPeriod=30
    bDynamicLight=true
}