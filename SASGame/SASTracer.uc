//=============================================================================
// SASTracer.uc
//
// Tracer bullet effect.
//=============================================================================

class SASTracer extends Actor
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Variables

var float	mSpeed;				// Launch speed
var float	mMaxSpeed;			// Max speed
var float	mGravityScalar;		// Scalar appied to gravity acceleration value
var float	mHeadOffsetDist;	// Offset of front of tracer graphic from centre


//-----------------------------------------------------------------------------
// Replication Expressions

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity = mSpeed * Vector(Rotation);
	if ( Owner != None )
	{
		Velocity += Owner.Velocity;
	}
}

/*simulated function Fire(
	Vector	aStart,
	Vector	aEnd)
{
	local int		particleIdx;
	local Particle	tracerParticle;
	local float		lifetime;

	TriggerParticle();

	if ( Emitters[0].ParticleIndex > 0 )
	{
		particleIdx = Emitters[0].ParticleIndex - 1;
	}
	else
	{
		particleIdx = Emitters[0].MaxParticles - 1;
	}
	tracerParticle = Emitters[0].Particles[particleIdx];

	// Modify particle direction and lifetime

}*/


/*simulated function Fire(
	Vector	aStart,
	Vector	aEnd)
{
	local int		particleIdx;
	local Particle	tracerParticle;
	local float		lifetime;

	// Modify particle lifetime params

	// Modify particle velocity params

	TriggerParticle();
}*/


//-----------------------------------------------------------------------------
// Default Properties



// Decompiled with UE Explorer.
defaultproperties
{
    mSpeed=5000.0000000
    mMaxSpeed=5000.0000000
    mGravityScalar=0.5000000
    mHeadOffsetDist=32.0000000
    RelativeRotation=(Pitch=16384,Yaw=0,Roll=0)
    LightBrightness=255.0000000
    LightRadius=3.0000000
    LightType=1
    LightEffect=13
    LightHue=30
    LightSaturation=69
    Physics=2
    DrawType=8
    RemoteRole=0
    AmbientGlow=187
    Style=3
    bAlwaysRelevant=true
    bUnlit=true
    bFixedRotationDir=true
}