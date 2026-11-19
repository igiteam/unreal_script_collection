//
// DelayedProjectile.uc
//
// Projectile object that exploads after a certain amount of time, bouncing and moving 
// through the level.
//

class DelayedProjectile extends SFRMProjectile;


var bool bSilentlyDestroyingNow;
var bool bBeingHandled;
var bool bIncomingHeard;

// Sounds
var() Sound DPExplosionSound;
var() Sound DPBounceSound;
var(Sound)	sound ProjectileBounceSounds[EMATERIALTYPE_SIZE];

var float AlertRadius; //bots within this radius will be alerted every 10th of a second or so that there's an armed projectile nearby

var(ExtendedProps) float DelayTime; 

var float VelocityImpactCoeff;  // how much velocity remains after breaking a destructible


event Timer()
{
	//our superclass sets a 0.8 timer, so let's just hook into that
	Super.Timer();
	AlertBots();
}
simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	HitWall( Normal(HitLocation), Other );
}

simulated event Explode(vector HitLocation, vector HitNormal)
{
	PlaySound(DPExplosionSound,, 1,,5000.0, 0.5+FRand(),true);
	Super.Explode(HitLocation,HitNormal);
}

simulated function ProjectileLaunch(rotator r,optional float speedScale)
{
	Speed=default.speed;
	if (speedScale!=0) Speed*=speedScale;
	
	//log (self@"flying!"@Speed);
	if ( Pawn ( Owner ) != None )
	{
		Pawn ( Owner ).DetachFromBone(self);
	}

	//SetOwner(None);
	SetLocation(Location+vector(r)*80);
	SetRotation(r);
	SetPhysics(PHYS_Falling);
	GotoState('Flying');
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	local vector		TraceHitLocationOut;	// output for Trace
	local vector		TraceHitNormalOut;		// output for Trace
	local vector		TraceEnd;	// Furthest point the trace should go to
	local material		mHitting;   // Surface the grenade hit
	local byte			byteType; 	// Material type

	if ( HitWall == Instigator)
		return; 

	// Find the surface the grenade hit
	// (32.0 factor applied to HitNormal is just over 1 foot distance--just in case there
	// is a delay that causes this function to be called when the grenade is already 
	// slightly away from the wall).
	TraceEnd = Location - 32.0*HitNormal;
	Trace( TraceHitLocationOut, TraceHitNormalOut, TraceEnd,,,, mHitting );

	// Handle impact with destructible (may need to break the destructible and keep going)
	if( DestructibleMesh(HitWall) != None && VSize(Velocity) > MinDestructibleBreakSpeed )
	{
		HitWall.TakeDamage( ImpactDamage, instigator, TraceHitNormalOut, vect(0,0,0), class'DamageTypeProjectile', InstigatorController );

		// If victim (destructible) is being destroyed by the impact, then don't bounce 
		// (just slightly dampen velocity and let projectile pass through).
		if( DestructibleMesh(HitWall).HitPoints <= 0 )
		{
			Velocity *= VelocityImpactCoeff;
			return;
		}
	}

	Velocity = 0.10*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(1000);
	Speed = VSize(Velocity);

	
	if ( Velocity.Z > 400 )
	{
		Velocity.Z = 0.5 * (400 + Velocity.Z);
		Log("Playing sound ("$DPBounceSound$")"); 

		// Play appropriate bounce sound
		if( mHitting != None )
		{
			// If surface can be determined, find material type 
			byteType = mHitting.MaterialType;
		}
		else
		{
			// If cannot find what surface was hit, use default material type
			byteType = EMATERIALTYPE_NONE;
		}
		// PlaySound args: Sound, Slot, Volume, bNoOverride, Radius, Pitch, Attenuate
		PlaySound( ProjectileBounceSounds[int(byteType)],, 1.3,,500.0, 0.5+FRand(),true ); 
		//PlaySound(DPBounceSound,, 1,,5000.0, 0.5+FRand(),true);
	}
	else if ( Speed < 20 ) 
	{
		bBounce = False;
		SetPhysics(PHYS_None);
		WarnBots();
	}
}

//Alert Bots warns bots that self is flying nearby
simulated function AlertBots()
{
	local ZombieBipedPawn pawn;
	local ZombieBot zbot;
	// flying
	foreach DynamicActors( class'ZombieBipedPawn', pawn )
	{
		zbot = ZombieBot( pawn.Controller );
		if( zbot != None )
			zbot.ArmedProjectileFlyingNearby( Self );
	}

}

simulated function WarnBots()
{
	local ZombieBipedPawn pawn;
	local ZombieBot zbot;
		// landed
	foreach RadiusActors( class'ZombieBipedPawn', pawn, 200 )
	{
		zbot = ZombieBot( pawn.Controller );
		if( zbot != None )
			zbot.ArmedProjectileLandedNearby( Self );
	}
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal, None);
}

// have to overload this state because we don't want the LifeSpan getting set
// to Zero in a base class.  cookoff will set the lifespan on the projectile
auto State Flying
{
Begin:
	Velocity = Speed * vector(Rotation);
	RandSpin(1000);
	Speed = VSize(Velocity);
		
	if ( Velocity.Z > 400 )
	{
		Velocity.Z = 0.5 * (400 + Velocity.Z);
	}
	SetPhysics(PHYS_Falling); 
	bBounce = True;
	Sleep(Lifespan-0.1);
	Explode(Location,-Velocity);
}


// Decompiled with UE Explorer.
defaultproperties
{
    DPExplosionSound=Sound'CBW_DYN_weapons.explosions.Grenade_explosion1'
    DPBounceSound=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_stone1'
    ProjectileBounceSounds[0]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_stone1'
    ProjectileBounceSounds[1]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_gravel1'
    ProjectileBounceSounds[2]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_gravel1'
    ProjectileBounceSounds[3]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_stone1'
    ProjectileBounceSounds[4]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_stone1'
    ProjectileBounceSounds[5]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_water1'
    ProjectileBounceSounds[6]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_wood1'
    ProjectileBounceSounds[7]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_gravel1'
    ProjectileBounceSounds[8]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_wood1'
    ProjectileBounceSounds[9]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_water1'
    ProjectileBounceSounds[10]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_gravel1'
    ProjectileBounceSounds[11]=Sound'CBW_DYN_Foley.grenade_bounce.grenade_bounce_stone1'
    AlertRadius=400.0000000
    DelayTime=10.0000000
    VelocityImpactCoeff=0.9000000
    Speed=1300.0000000
    MaxSpeed=2600.0000000
    TossZ=300.0000000
    Damage=200.0000000
    DamageRadius=1000.0000000
    Physics=2
    DrawType=8
    StaticMesh=StaticMesh'CBS_DYN_Weapon.ThirdPerson.hh_hegrenade'
    LifeSpan=3.0000000
    bBounce=true
    bFixedRotationDir=false
    Mass=50.0000000
    ForceScale=50.0000000
}