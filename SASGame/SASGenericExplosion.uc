//=============================================================================
// SASGenericExplosion.uc
//
// Abstract base class for explosions
//=============================================================================

class SASGenericExplosion extends SASEmitter
	abstract
	native;

//-----------------------------------------------------------------------------
// Constants

const STUNTYPE_None		= 0; 
const STUNTYPE_Flash	= 1;
const STUNTYPE_Bang		= 2;


//-----------------------------------------------------------------------------
// Structs

// stores attributes for types of damage that this explosion can do
// e.g. flash, blast etc
struct native DamageData
{
	// Damage attributes.
	var() float					mAmount;				// Amount of danage inflicted
	var() float					mRadius;				// Radius within damage occurs (linear falloff)
	var() float					mMomentumTransfer;		// Momentum magnitude imparted by explosion
	var() class<DamageType>		mMyDamageType;			// Type of damage inflicted
};

//-----------------------------------------------------------------------------
// Member Vars

var() array<DamageData>			mDamageDataList;		// damage that can be done by this explosion
var() array<Sound>				mExplosionSounds;		// Sounds made on explosion
var() float						mExplosionSoundVolume;	// Explosion sound volume
var() float						mExplosionSoundPitch;	// Explosion sound Pitch
var() float						mExplosionSoundRadius;	// Explosion sound Radius

var() float						mExplosionLoudness;		// Loudness level of firing (0 to 1)
var() bool						mbExplosionDecal;		// Explosion's blast effects
//var	float						mExploWallOut;		// Distance to move explosions out from wall
var() float						mFlashRadius;			// Distance over which pawns can be stunned by flash
var() float						mFlashIntensity;		// Measure of flash stun intensity (0.0 to 1.0)
var() float						mBangRadius;			// Distance over which pawns can be stunned by bang
var() float						mBangIntensity;			// Measure of bang stun intensity (0.0 to 1.0)


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
// Called after level has started and explosion has been spawned.
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	BlowUp();
	BlastEffects();
}


///////////////////////////////////////////////////////////////////////////////
// Reset
//
// Destroy on restarting level.
simulated function Reset()
{
	Destroy();
}


simulated final function GrenadeHurtRadius( 
	float				aDamageAmount, 
	float				aDamageRadius, 
	class<DamageType>	aDamageType, 
	float				aMomentum, 
	Vector				aHitLocation )
{
	local Actor					victims;
	local float					damageScale, 
								dist;
	local Vector				dir;
	local SASPawn				hitPawn;
	local SASPlayerController	PC;
	local Weapon				wpn;
	
	if( bHurtEntry )
	{
		return;
	}

	// Our owner is a projectile; its owner will be a weapon.
	if ( Owner != None && Owner.Owner != None )
	{
		wpn = Weapon( Owner.Owner );
	}

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', victims, aDamageRadius, aHitLocation, false, true )
	{
		// don't let blast damage affect fluid - VisibleCollidingActors doesn't really work for them - jag
		if (	( victims != self ) && 
				( victims.Role == ROLE_Authority ) && 
				( !victims.IsA ( 'FluidSurfaceInfo' )) )
		{
			dir = victims.Location - aHitLocation;
			dist = FMax( 1, VSize ( dir ) );
			dir = dir / dist; 
			damageScale = 1 - FMax( 0, ( dist - victims.CollisionRadius ) / aDamageRadius );
			if ( damageScale > 0 )
			{
				victims.TakeDamage(
					damageScale * aDamageAmount,
					Instigator, 
					victims.Location - 0.5 * ( victims.CollisionHeight + victims.CollisionRadius ) * dir,
					( damageScale * aMomentum * dir ),
					aDamageType,
					wpn );			
				
				hitPawn = SASPawn( victims );
				if (	hitPawn != None && 
						hitPawn.Controller != None &&
						hitPawn.Controller.mType == CONTROLLER_Player )
				{
					PC = SASPlayerController( hitPawn.Controller );
					if ( PC != None )
					{
						//* damageScale 
						PC.DecayMotionBlur( 255 - ( 255 * damageScale ) );
						PC.SetModgeActor( Self );
					}
				}
			}
		} 
	}
	bHurtEntry = false;
}


////////////////////////////////////////////////////////////////////////////////
// BlowUp 
//
// originally cut'n'paste in from Projectile
simulated function BlowUp ()
{
	local int	i;
	local Sound	exploSound;

	// process damage array
	for ( i = 0; i < mDamageDataList.Length; i++ )
	{
		GrenadeHurtRadius ( mDamageDataList[i].mAmount, mDamageDataList[i].mRadius, mDamageDataList[i].mMyDamageType, mDamageDataList[i].mMomentumTransfer, Location );
	}

	// initiate sound
	if ( mExplosionSounds.Length > 0 ) 
	{
		exploSound = mExplosionSounds[Rand(mExplosionSounds.Length)];
		if ( exploSound != None )
		{
			PlaySound ( exploSound,,mExplosionSoundVolume,,mExplosionSoundRadius,mExplosionSoundPitch);
			MakeNoise ( mExplosionLoudness, NOISE_Explosion );
		}
	}

	DoStun ();
}


///////////////////////////////////////////////////////////////////////////////
// DoStun
//
// Applies stun to pawns within stun radius of the explosion.
simulated function DoStun()
{
	local SASPawn	proximalPawn;
	local float		maxStunRadius,
					dist,
					stunScale;
	local Vector	pawnLoc;

	if (SASGameInfo(Level.Game) != None)
	{
		maxStunRadius = 0.0;
		if ( mFlashIntensity > 0.0 )
		{
			maxStunRadius = mFlashRadius;
		}
		if ( mBangIntensity > 0.0 )
		{
			maxStunRadius = Max( maxStunRadius, mBangRadius );
		}
		
		if ( maxStunRadius > 0.0 )
		{
			foreach SASGameInfo(Level.Game).RadiusSASPawns(class'SASPawn', proximalPawn, Location, maxStunRadius)
			{
				pawnLoc = proximalPawn.Location;
				pawnLoc.Z += (proximalPawn.CollisionHeight * 0.8);
				if ( FastTrace( pawnLoc, Location ) )
				{
					dist = VSize( proximalPawn.Location - Location );
					if ( (mFlashIntensity > 0.0) && (dist < mFlashRadius) )
					{
						stunScale = 1.0 - (dist / mFlashRadius);
						proximalPawn.Stun( mFlashIntensity * stunScale, STUNTYPE_Flash, self );
					}

					if ( (mBangIntensity > 0.0) && (dist < mBangRadius) )
					{
						stunScale = 1.0 - (dist / mBangRadius);
						proximalPawn.Stun ( mBangIntensity * stunScale, STUNTYPE_Bang, self );
					}
				}
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoBlastDecal
//
// project the blast decal on the wall/floor etc.
simulated function DoBlastDecal(vector startTrace, vector endTrace)
{
	local vector	traceHitLocation;
	local vector	traceHitNormal;
	local Actor		traceHitActor;
	local Material  hitMaterial;
	local vector	decalLocation;
	local rotator	decalOrientation;
	local SASGRI	gri;

	// trace this vector
	traceHitActor = Trace ( traceHitLocation, traceHitNormal, endTrace, startTrace, true,, hitMaterial );

	// anything within range?
	if ( traceHitActor != None )
	{
		// Blast has hit something
		if ( traceHitActor.bWorldGeometry || ( Mover ( traceHitActor ) != None ) )
		{
			// setup location and orientation
			decalLocation = traceHitLocation - traceHitNormal;
			decalOrientation = rotator(-traceHitNormal);

			gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

/* TODO: setup some kind of material damage decal here - these bullet holes won't do!
			// somewhat kludgy material id passing mechanism ???
			// used to set material type in 'SASProjectedDecal'
			gri.mCurrentMaterialHack = hitMaterial.mMaterialType;

			// bullet hole type decals
			Spawn(class'SASProjectedDecal', self,, decalLocation, decalOrientation);
*/
			// blast mark decals
			if ( gri.mLevelData.mBlastDecalsClass != None )
			{
				Spawn ( gri.mLevelData.mBlastDecalsClass, self,, decalLocation, decalOrientation );
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// SpawnExplosionEffects
//
simulated function BlastEffects()
{
	local float	traceDistance;
	local vector startLocation;

	// Try and add some blast decals...
	if ( !mbExplosionDecal )
	{
		return;
	}

	// distance from blast to look for collision
	traceDistance = 64.0f;

	// for x & y at ground level
	startLocation = Location;// - (Vect(0.0f,  0.0f, 0.5f) * 32.0f); // assumes that '32.0f' is height of object

	// x - front/back
	DoBlastDecal(	startLocation,
					startLocation + (Vect( 1.0f,  0.0f,  0.0f) * traceDistance));
	DoBlastDecal(	startLocation,
					startLocation + (Vect(-1.0f,  0.0f,  0.0f) * traceDistance));

	// y - left/right
	DoBlastDecal(	startLocation,
					startLocation + (Vect( 0.0f,  1.0f,  0.0f) * traceDistance));
	DoBlastDecal(	startLocation,
					startLocation + (Vect( 0.0f, -1.0f,  0.0f) * traceDistance));

	// z - up/down
	DoBlastDecal(	Location,
					Location + (Vect( 0.0f,  0.0f,  1.0f) * traceDistance));
	DoBlastDecal(	Location,
					Location + (Vect( 0.0f,  0.0f, -1.0f) * traceDistance));
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mExplosionSoundVolume=1.0000000
    mExplosionSoundPitch=1.0000000
    mExplosionSoundRadius=50.0000000
    mExplosionLoudness=1.0000000
    AutoDestroy=true
    bNoDelete=false
    bTrailerSameRotation=true
    bAlwaysRelevant=true
}