//=============================================================================
// SASWeapon.uc
//
// Abstract base class of all weapons in SAS
//=============================================================================

class SASWeapon extends Weapon
	native
	abstract;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

// Mesh attachement bones
const ATTACHBONE_HandsToGun		= 'weapon_parent';
const ATTACHBONE_HandsToGrenade	= 'grenade_parent';

// Muzzle flash bone name
const MUZZLE_BONE				= 'Muzzle';
const SHELL_BONE				= 'Shell';
const WEAPONNODE_BONE			= 'weapNode';

// Fire Modes
										// 'mAllowedFireModes' flags equivalent (1<<const value):
const FIREMODE_None				= -1;	// n/a
const FIREMODE_Single			= 0;	// 0x1
const FIREMODE_Burst			= 1;	// 0x2
const FIREMODE_Auto				= 2;	// 0x4
const FIREMODE_Count			= 3;// Number of fire modes

// Fire mode names
const FIREMODENAME_Single		= 'FIREMODE_Single';
const FIREMODENAME_Burst		= 'FIREMODE_Burst';
const FIREMODENAME_Auto			= 'FIREMODE_Auto';

// Aim/unaim weapon anim rate
const AIMANIM_RATE				= 1.7;
const UNAIMANIM_RATE_FAST		= 2.5;

// Non-editable anim names.
const ANIMNAME_ToSighted			= '1st_Port2Sight';
const ANIMNAME_FromSighted			= '1st_Sight2Port';
const ANIMNAME_Select				= '1st_PickWeapon';
const ANIMNAME_Deselect				= '1st_DropWeapon';
const ANIMNAME_SightedEmpty			= '1st_Empty_Sighted';
const ANIMNAME_UnsightedEmpty		= '1st_Empty_Ported';
const ANIMNAME_AltFire				= '1st_AltFire1';
const ANIMNAME_SightedEndFire		= '1st_EndFire';
const ANIMNAME_UnsightedEndFire		= '1st_EndFire_Ported';
const ANIMNAME_Reload				= '1st_Reload';
const ANIMNAME_SightedTorchToggle	= '1st_Sight_TorchOnOff';
const ANIMNAME_UnsightedTorchToggle	= '1st_TorchOnOff';
const ANIMNAME_SightedIdle			= '1st_Sight';
const ANIMNAME_PullPin				= '1st_PullPin';
const ANIMNAME_ThrowGrenade			= '1st_Throw';
const ANIMNAME_Punch				= '1st_Punch';
const ANIMNAME_ShotGunReloadLoop	= '1st_Reload_Middle';
const ANIMNAME_ShotGunReloadEnd		= '1st_Reload_End';

// threat ranges
const THREATENRANGE_Knife			= 40;
const THREATENRANGE_Primary			= 250;
const THREATENRANGE_Secondary		= 150;
const THREATENRANGE_Grenade			= 2000;

const WPNWISPSMOKE_DarkeningFactor	= 0.1;

//-----------------------------------------------------------------------------
// Enums

// List of anim types playable on SAS weapons.
enum EWeaponAnim
{
	WPNANIM_Idle,
	WPNANIM_Select,
	WPNANIM_Deselect,
	WPNANIM_SightedIdle,
	WPNANIM_MoveToSighted,
	WPNANIM_MoveFromSighted,
	WPNANIM_SightedFire,
	WPNANIM_UnsightedFire,
	WPNANIM_SightedEmpty,
	WPNANIM_UnsightedEmpty,
	WPNANIM_AltFire,
	WPNANIM_SightedEndFire,
	WPNANIM_UnsightedEndFire,
	WPNANIM_Reload,
	WPNANIM_SightedTorchToggle,
	WPNANIM_UnsightedTorchToggle,
	WPNANIM_SightedLaserToggle,
	WPNANIM_UnsightedLaserToggle,
	WPNANIM_PullPin,
	WPNANIM_ThrowGrenade,
	WPNANIM_Punch,
	WPNANIM_ShotGunReloadLoop,
	WPNANIM_ShotGunReloadEnd,
};


//-----------------------------------------------------------------------------
// Member variables

var EWeaponCategory			mCategory;						// Category of weapon corresponding to WPNCAT_xxx values
var const EGrenadeCategory	mGrenadeCategory;

var E3PAnimSet				me3PAnimSet;					// 3rd person anim set to use for this weapon.
var name					mSpecial3PReloadAnim;			// Overriding reload anim to use on third person.

// 1st person hand anims/gun mesh.
var MeshAnimation				mHandAnims;					// Animation set for hands when using this weapon.
var class<SASFPWeaponMeshActor>	mFPWeaponMeshClass;			// Class of 1st person weapon mesh to attach to hands.
var SASFPWeaponMeshActor		mFPWeaponMeshActor;			// 1st person weapon mesh actor to attach to hands.

var() float					mCollisionPushBackMaxUnsighted;
var() float					mCollisionPushBackMaxSighted;
var() float					mCollisionPushBackMaxReloading;
var array<Vector>			mSceneryCollisionTestPointsUnsighted;
var array<Vector>			mSceneryCollisionTestPointsSighted;
var float					mCollisionPushBackCurDist;
var float					mCollisionPushBackTargetDist;
var bool					mbIsReloading;

// General weapon properties.
var	int						mMagSize;						// Magazine capacity
var	int						mNumInMag;						// Number of bullets currently in mag
var	int						mFireMode;						// Current fire mode (single/auto etc)
var	int						mAllowedFireModes;				// Bitfield of allowed fire modes corresponding to FIREMODE_xxx values
var int						mDiscardMagThreshold;
var int						mBurstEmptyThreshold;
var float					mFireLoudness;					// Loudness level of firing (0 to 1)
var Vector					mFireOffsetSide;
var Vector					mFireOffsetOverhead;
var bool					mbCanCutoutFiringEarly;
var float					mRepeatFireAnimStartFrame;
var float					mRepeatFireAnimInterruptMax;
var float					mFireAnimStartFrame;
var (Special) bool			mBreachingWeapon;				// TRUE for weapons used to take down doors
var bool					mbMoveOutOfView;
var bool					mbPlayedClipEmptyAnim;

// because there's a bit of animation confusion as we come out of sighted, I've bodged a delay into certain events
var float					mTimeWasLastSighted;

// the knife doesn't.
var const bool				UsesAmmo;

// when we're near the end of a mag in burst fire, we have to count how many bullet fire sounds we'll
// actually make
var bool					mBurstFireSampleUsed;


// Sighted mode parameters.
var bool					mbToggleSighted;				// Flag as to whether gun has sighted/unsighted positions
var bool					mbSighted;						// Flag to indicate if weapon is in sighted position
var float					mSightedFovAdjust;				// FoV adjust when sighted (in degrees)
var float					mMoveToSightedSwitchFrame;		// Anim frame in move to sighted anim to do fov change.
var vector					mSightedBobDamping;				// Bob damping scalar used in WeaponBob function when weapon in sighted pos

// Weapon characteristics.
var const float				mWeight;						// Weight of the weapon used in inertia lag
var float					mBaseStability;					// Time taken to return to centred after one shot
var float					mBaseCrouchStability;			// Time taken to return to centred after one shot while crouching

// Auto lock
var	float					mAutoLockAngleMin;				// The minimum cone angle for the auto lock shot assist.
var float					mAutoLockAngleMax;				// The minimum cone angle for the auto lock shot assist.


// Accuracy
var	float					mShotSpreadAngleNormal;				// Base accuracy of weapon (unreal unit angle)
var float					mShotSpreadAngleCrouch;				// Base accuracy while crouching
var	float					mShotSpreadAngleBurst;				// Base accuracy while doing burst fire
var float					mShotSpreadAngleModForSighted;		// Scaling factor to base accuracy when in sighted mode.
var int						mShotSpreadAnglePenaltyForMovement;	// Firing accuracy modifier when moving
var float					mShotSpreadAnglePenaltyModForRotation;// Firing accuracy modifier when rotating
var float					mShotSpreadAnglePenaltyDecay;		// How quickly the accuracy returns per second
var float					mShotSpreadAngleMax;				// Maximum (in)accuracy angle of a shot.
var float					mShotSpreadAngleMaxModForSprinting;	// Scalar to max accuracy when pawn is charging.

//Texture variable for lineart
var Texture					mLineartWeapon;
// DEBUG!! -AC
// Store this so we can display it for debugging purposes.
var float					mShotSpreadAngleMaxCurrent;			// Computed current maximum (in)accuracy angle of a shot.
// END DEBUG!!
var float					mShotSpreadAngleCurrent;			// Computed current (in)accuracy angle of a shot.

// Recoil
var	(Recoil) float			mAimedShotRiseMin;				// Min Amount of rise (pitch) per shot when you're aimed
var	(Recoil) float			mAimedShotRiseMax;				// Max Amount of rise (pitch) per shot when you're aimed
var (Recoil) float			mAimedShotYawMin;				// Min Amount of yaw per shot when you're aimed
var (Recoil) float			mAimedShotYawMax;				// Max Amount of yaw per shot when you're aimed

var	(Recoil) float			mNormalShotRiseMin;				// Min Amount of rise (pitch) per shot
var	(Recoil) float			mNormalShotRiseMax;				// Max Amount of rise (pitch) per shot
var (Recoil) float			mNormalShotYawMin;				// Min Amount of yaw per shot
var (Recoil) float			mNormalShotYawMax;				// Max Amount of yaw per shot

var	(Recoil) float			mBurstShotRiseMin;				// Min Amount of rise (pitch) in burst fire
var	(Recoil) float			mBurstShotRiseMax;				// Max Amount of rise (pitch) in burst fire
var (Recoil) float			mBurstShotYawMin;				// Min Amount of yaw in burst mode
var (Recoil) float			mBurstShotYawMax;				// Max Amount of yaw in burst mode

var (Recoil) float			mRiseTime;						// How long it takes to rise

// KW deprecated: var (Recoil) Rotator		CameraShakeMin;					// a range of angles for the camera to shake when you fire
// KW deprecated: var (Recoil) Rotator		CameraShakeMax;

var(Recoil) float			ShakeRate;						// how fast to roll view
var(Recoil) float			ShakeIterations;				// ticks translation shake
var(Recoil) vector			ShakeVert;						// translation shake
var(Recoil) vector			ShakeSpeed;						// shake rate

var	vector					mDebugTraceStart;
var	vector					mDebugTraceEnd  ;

var float					mRoundsPerMinute;				// Firing rate on auto fire mode
var float					mBurstsPerMinuteBurstMode;		// same, but for burst fire, and it's not a round, it's a burst of 3

var bool					mbCentred;

// JS now the rise is on the camera so there's no need to store it (I think): var float mRise;
// JS now the accuracy doesn't change as the weapon rises (I think) var float mRiseSpreadAngleMod;

// Inertia vars
var float					mInertiaMaxRotOfs;				// Maximum weapon rotation offset due to inertia lag
var float					mInertiaRotDampCoeff;			// Damping coeff in inertial rotation lag restitution (defines 'spring' strength)
var rotator					mOwnerLastRotation;				// Cache of Instigator's rotation from prev frame
var rotator					mInertiaRotOfs;					// Inertia lag rotation offset (unreal angles)
var vector					mInertiaRotVel;					// Inertia lag rotational velocity (rad/s)
var float					mInertiaBobDampCoeff;
var vector					mOwnerLastBobOfs;
var vector					mInertiaBobOfs;
var vector					mInertiaBobVel;
var rotator					mInertiaBobRot;

// Fire animation data
var	name					mSightedFireAnim;				// Firing anim when in sighted mode.
var name					mUnsightedFireAnim;
var name					mBurstAutoSightedFireAnim;
var name					mBurstAutoFireAnim;
var name					mAltFireAnim;

var	array<name>				mIdleAnims;
var array<float>			mIdleAnimTimes; // how many seconds between playing the anims

var	int						mNextIdleAnim; // the code must choose the anim when deciding on the delay you see

//var	float					mSingleFireAnimRate;			// Playback rate for single fire
//var	float					mBurstFireAnimRate;				// Playback rate for burst fire
//var	float					mAutoFireAnimRate;				// Playback rate for full-auto fire

// 1st person muzzle flash
var class<SASEmitter>		mMuzzleFlashClass;				// Class of muzzle flash emitter
var SASEmitter				mMuzzleFlashEmitter;			// Muzzle-flash emitter object
var float					mMuzzleFlashScale;				// Muzzle-flash particle scale

var vector					mMFRelLocation3rdPerson;		// Relative location of muzzle flash from attachment bone

// 1st person shell eject emitter
var class<SASEmitter>		mShellEmitterClass;				// Shell eject emitter class
var SASEmitter				mShellEjectEmitter;				// Shell eject emitter object
var float					mShellEjectScale;				// Shell eject particle scale
var vector					mShellEjectRelLocation;			// Relative location of shell eject emitter from attachment bone

// Tracer properties
var Class<SASTracer>		mTracerClass;					// Class of tracer projectile
var Range					mTracerSpacing;					// Spacing between firing a tracer as opposed to normal ammo.
var int						mTracerCounter;					// Counter for spawning tracers

// Torch properties
var bool					mbHasTorch;
var SASTorchBeam			mTorchBeam;						// The torch beam attached to the gun
var SASTorchBeamProjector	mTorchProjector;				// The torch projector that projects onto objects
var SASTorchBeamCorona		mTorchCorona;					// The torch corona attached to the gun

// Laser properties
var bool					mbHasLaser;
var SASLaserBeam			mLaserBeam;						// The laser beam attached to the gun
var SASLaserBeamProjector	mLaserProjector;				// The laser projector that projects onto objects
var SASLaserBeamCorona		mLaserCorona;					// The laser corona attached to the gun

var Actor					mCameraActor;

// Attachments
var() class<SASWeaponScope>	mScopeClass;
var SASWeaponScope			mScope;
var SASWeaponTacticalLight	mTacticalLight;
var() class<SASWeaponLaserSight> mLaserClass;
var SASWeaponLaserSight		mLaserSight;
var Rotator					mFPLaserRelativeRotSighted;
var Rotator					mFPLaserRelativeRotUnsighted;

// This is a Matt Hack so I can actually get through the level - not to be used for Scopes!
var bool					mbZoomed;
var float					mZoomFact;

// for telling pawns to get out of way
//
var Pawn					mPointedAtPawn;
var float					mPointedAtStartTime;
var int						mPointedAtStep;

// Sounds
var(Sound) float			FireVolumeMin;
var(Sound) float			FireVolumeMax;
var(Sound) float			FirePitchMin;
var(Sound) float			FirePitchMax;
var(Sound) array<Sound>		mFireSounds;

var(Sound) float			BurstFireVolumeMin;
var(Sound) float			BurstFireVolumeMax;
var(Sound) float			BurstFirePitchMin;
var(Sound) float			BurstFirePitchMax;
var(Sound) array<Sound>		mBurstFireSounds;

var(Sound) array<Sound>		mEjectClipSounds;
var(Sound) array<Sound>		mReplaceClipSounds;
var(Sound) float			mAudibleRadius;

var(Sound) array<Sound>		mPickupImpactSounds;

var Rotator					mPrevInstigatorRot;

var(AI)	int					mReloadLevel;					// Number of rounds remaining that AI will cause soldier AI to reload
var float					mLast3PActorForcedUpdateTime;
//var Vector					mLast3PActorForcedUpdateOffset;
//var Vector					mLast3PActorForcedUpdateDir;

var name					mWeaponName;			// Overriding reload anim to use on third person.
//-----------------------------------------------------------------------------
// Replication Exressions
//
replication
{
	// Variables replicated from server on initialisation
	reliable if ( bNetInitial && ( Role == ROLE_Authority ) )
		mWeight;

	// Variables the server should send to the client.
	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
		mShotSpreadAngleCurrent,	// REP_REMOVE? - should be simulated?
		mbSighted,					// REP_REMOVE? - should be simulated?
		mNumInMag,					
		mFireMode,					
		mbZoomed;					// REP_REMOVE? - should be simualted?

	// Functions server replicates to client
	reliable if ( Role == ROLE_Authority )
		NextWeaponFunction,
		PrevWeaponFunction,
		SetFireMode;

	// Functions client can call on server
	reliable if ( Role < ROLE_Authority )
		ServerNextWeaponFunction,
		ServerPrevWeaponFunction,
		ServerSetFireMode;
}


//-----------------------------------------------------------------------------
// Native Functions

native(660) final function RecalcInertia();

native(661) final function Recentre();

native(662) final function SetWeight(
	float aNewWeight);

native(663) final function vector GetInertialBobOffset();

native(664) simulated final final function bool IsGunLightOn();
native(665) simulated final final function bool IsGunLaserOn();

native(666) simulated final function Vector GetThirdPersonFireStart();

native(667) simulated final function Rotator GetDesiredFiringRotation(
	bool abRetainWeaponYaw );

native(668) simulated final function InitSceneryCollisionPoints();

native(669) simulated final function SetHandSkin();


//-----------------------------------------------------------------------------
// Exec Functions

// Set draw scale
exec function SetWeapScale (
	float	aNewScale)
{
	SetDrawScale (aNewScale);
	if ( mFPWeaponMeshActor != None )
	{
		mFPWeaponMeshActor.SetDrawScale (aNewScale);
	}
}

// Output weapon scale to log
exec function ShowWeapScale ()
{
	log("#### DrawScale: "$DrawScale);
}

// Set weapon view offset x component
exec function SetWeapX (
	float	aX)
{
	PlayerViewOffset.X = aX;
}

// Set weapon view offset y component
exec function SetWeapY (
	float	aY)
{
	PlayerViewOffset.Y = aY;
}

// Set weapon view offset z component
exec function SetWeapZ(
	float	aZ)
{
	PlayerViewOffset.Z = aZ;
}

// Output weapon view offset to log
exec function ShowWeapXYZ ()
{
	if (Pawn(Owner).Weapon != self)
	{
		return;
	}

	log("#### ViewOffset: "$PlayerViewOffset);
}

// Set muzzleflash offset x component relative to attachment bone
exec function SetMuzzleX (
	float	aX)
{
    //mMFRelLocation.X = aX;
}

// Set muzzleflash offset y component relative to attachment bone
exec function SetMuzzleY (
	float	aY)
{
    //mMFRelLocation.Y = aY;
}

// Set muzzleflash offset y component relative to attachment bone
exec function SetMuzzleZ (
	float	aZ)
{
	//mMFRelLocation.Z = aZ;
}

// Output muzzle flash relative offset to log
exec function ShowMuzzleXYZ ()
{
	//log("#### Muzzle Offset: "$mMFRelLocation);
}

// Set muzzle flash particle scale
exec function SetMuzzleScale (
	float	aScale)
{
	//mMuzzleFlashScale = aScale;
}

// Output muzzleflash particle scale to log
exec function ShowMuzzleScale ()
{
	//log("#### Muzzle Scale: "$mMuzzleFlashScale);
}

// Set weapon's display FoV
exec function SetDisplayFOV (
	float	aFOV)
{
	DisplayFOV = aFOV;
	log( "warning: Should not be using overridden weapon FoV." );
}

// Set weapon's weight
exec function SetWeapWeight (
	float	aNewWeight)
{
	if (aNewWeight < 0.0)
	{
		log("#### Can't set weapon weight below 0");
		return;
	}
	SetWeight (aNewWeight);
}

// Set stability
exec function SetWeapStability (
	int	aNewStability)
{
	if (aNewStability < 0)
	{
		log("#### Can't set weapon stability below 0");
		return;
	}

	mBaseStability = aNewStability;
}

// Set ambient glow
exec function SetWeapAmbient(
	int aNewGlow )
{
	AmbientGlow = aNewGlow;
	if ( mFPWeaponMeshActor != None )
	{
		mFPWeaponMeshActor.AmbientGlow = aNewGlow;
	}
}


exec function SetWeapPBSighted( float amount )
{
	mCollisionPushBackMaxSighted = amount;
}
exec function SetWeapPBPorted( float amount )
{
	mCollisionPushBackMaxUnsighted = amount;
}
exec function SetWeapPBReload( float amount )
{
	mCollisionPushBackMaxReloading = amount;
}

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DisplayDebug
//
simulated function DisplayDebug(
	Canvas		aCanvas,
	out float	aYL,
	out float	aYPos )
{
	local string fireModeText;

	Super.DisplayDebug( aCanvas, aYL, aYPos );

	aCanvas.SetDrawColor( 0, 255, 255 );

	aCanvas.DrawText( "SASWeapon:" );
	aYPos += aYL;
	aCanvas.SetPos( 32, aYPos );

	switch ( mFireMode )
	{
	case FIREMODE_Single:
		fireModeText = "Single";
		break;

	case FIREMODE_Burst:
		fireModeText = "Burst";
		break;

	case FIREMODE_Auto:
		fireModeText = "Auto";
		break;

	default:
		fireModeText = "None";
		break;
	}

	aCanvas.DrawText( "Clip: "$mNumInMag$", Fire mode: "$fireModeText );
	aYPos += aYL;
	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText( "Loc: "$Location$", Rot: "$Rotation );
	aYPos += aYL;
	aCanvas.SetPos( 32, aYPos );

	aCanvas.DrawText("Attachments:");
	aYPos += aYL;
	aCanvas.SetPos( 32,aYPos );

	if ( (mScope == None) && (mTacticalLight == None) && (mLaserSight == None) )
	{
		aCanvas.DrawText("No attachments");
		aYPos += aYL;
		aCanvas.SetPos( 32,aYPos );
	}
	else
	{
		if ( mScope != None )
		{
			mScope.DisplayDebug( aCanvas, aYL, aYPos );
		}
		if ( mTacticalLight != None )
		{
			mTacticalLight.DisplayDebug( aCanvas, aYL, aYPos );
		}
		if ( mLaserSight != None )
		{
			mLaserSight.DisplayDebug( aCanvas, aYL, aYPos );
		}
	}

	aCanvas.DrawText( "Third person actor - location: "$ThirdPersonActor.Location$", rotation: "$ThirdPersonActor.Rotation );
	aYPos += aYL;
	aCanvas.SetPos( 32,aYPos );

	aCanvas.SetPos( 4, aYPos );
}

///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
//
simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	mNumInMag = mMagSize;

	CheckIdleAnims();

	// Spawn 1st person muzzle flash emitter - don't attach it yet as the
	// FP gun mesh to attach to hasn't been spawned.
	CreateMuzzleFlash();

	// Spawn 1st person shell case emitter - don't attach it yet as the
	// FP gun mesh to attach to hasn't been spawned.
	CreateShellEmitter();

	// Init attached modules
	InitAttachedModules();

	CheckComponentMeshes();

	CalcIdleMuzzleOffset();

	// This inits inertia lag parameters
	SetWeight( mWeight );

	// Init fire anim playback rate
	//InitFireRate();

	// Init fire count before next tracer fired
	mTracerCounter = int( RandRange( mTracerSpacing.Min, mTracerSpacing.Max ) );
}

/*
///////////////////////////////////////////////////////////////////////////////
// PostNetBeginPlay
//
simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	if ( (Role < ROLE_Authority)
		&& (Instigator != None) && (Instigator.Weapon == None) && (Instigator.PendingWeapon == None)
		&& (mCategory == WPNCAT_Primary) )
	{
		ClientWeaponSet( true );
	}
}
*/


///////////////////////////////////////////////////////////////////////////////
// InitAttachedModules
//
simulated function InitAttachedModules()
{
	local class<SASWeaponScope>				scopeClass;
	local class<SASWeaponTacticalLight>		tacLightClass;
	local class<SASWeaponLaserSight>		laserSightClass;

	scopeClass = GetScopeClass();
	if ( scopeClass != None )
	{
		mScope = Spawn( scopeClass, self );
		mScope.InitFor( self );
	}

	tacLightClass = GetTacticalLightClass();
	if ( tacLightClass != None )
	{
		mTacticalLight = Spawn( tacLightClass );
		mTacticalLight.InitFor( self );
	}

	laserSightClass = GetLaserSightClass();
	if ( laserSightClass != None )
	{
		mLaserSight = Spawn( laserSightClass );
		mLaserSight.InitFor( self );
	}
	
	InitLaserSight();
}


///////////////////////////////////////////////////////////////////////////////
// InitLaserSight
//
simulated function InitLaserSight()
{
	local Vector	dir;

	SetRotation( rot(0,0,0) );

	// Make sure correct anim set is loaded.
	SwapSkelAnim( mHandAnims );

	// Set anim to unsighted idle.
	PlayAnim( mUnsightedFireAnim, 1.0, 0.0 );

	SetAnimFrame( 0.0 );
	dir = GetBoneCoords( ATTACHBONE_HandsToGun, true ).XAxis;
	mFPLaserRelativeRotUnsighted = Rotator( dir );

	// Set anim to idle.
	PlayAnim( ANIMNAME_SightedIdle, 1.0, 0.0 );
	SetAnimFrame( 0.0 );
	dir = GetBoneCoords( ATTACHBONE_HandsToGun, true ).XAxis;
	mFPLaserRelativeRotSighted = Rotator( dir );

	// Leave anim in unsighted idle.
	TweenAnim( mUnsightedFireAnim, 0.0 );
}


///////////////////////////////////////////////////////////////////////////////
// GetScopeClass
//
simulated function class<SASWeaponScope> GetScopeClass()
{
	return mScopeClass;
}


///////////////////////////////////////////////////////////////////////////////
// GetTacticalLightClass
//
simulated function class<SASWeaponTacticalLight> GetTacticalLightClass()
{
	return None;
}


///////////////////////////////////////////////////////////////////////////////
// GetLaserSightClass
//
simulated function class<SASWeaponLaserSight> GetLaserSightClass()
{
	return mLaserClass;
}

///////////////////////////////////////////////////////////////////////////////
// CreateMuzzleFlash
//
// Create the muzzle flash emitter. Emitter is attached to weapon muzzle bone
// elsewhere.
simulated function CreateMuzzleFlash()
{
	local int	numEmtrs;

	if ( (mMuzzleFlashEmitter == None) && (mMuzzleFlashClass != None) )
	{
		mMuzzleFlashEmitter = Spawn( mMuzzleFlashClass, self );
		//AttachToBone( mMuzzleFlashEmitter, MUZZLE_BONE );

		// Init muzzle flash emitters.
		numEmtrs = mMuzzleFlashEmitter.Emitters.Length;
		while ( --numEmtrs >= 0 )
		{
			mMuzzleFlashEmitter.Emitters[numEmtrs].StartSizeRange.X.Min *= mMuzzleFlashScale;
			mMuzzleFlashEmitter.Emitters[numEmtrs].StartSizeRange.X.Max *= mMuzzleFlashScale;
//			mMuzzleFlashEmitter.Emitters[numEmtrs].StartLocationOffset = vect(0,0,0);
//			mMuzzleFlashEmitter.Emitters[numEmtrs].InitialParticlesPerSecond = 0;
//			mMuzzleFlashEmitter.Emitters[numEmtrs].ParticlesPerSecond = 0;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// CreateShellEmitter
//
simulated function CreateShellEmitter()
{
	if ( (mShellEjectEmitter == None) && (mShellEmitterClass != None) )
	{
		mShellEjectEmitter = Spawn( mShellEmitterClass, self );
		//AttachToBone( mShellEjectEmitter, SHELL_BONE );

		mShellEjectEmitter.Emitters[0].StartSizeRange.X.Min *= mShellEjectScale;
		mShellEjectEmitter.Emitters[0].StartSizeRange.X.Max *= mShellEjectScale;
		mShellEjectEmitter.Emitters[0].StartSizeRange.Y.Min *= mShellEjectScale;
		mShellEjectEmitter.Emitters[0].StartSizeRange.Y.Max *= mShellEjectScale;
		mShellEjectEmitter.Emitters[0].StartSizeRange.Z.Min *= mShellEjectScale;
		mShellEjectEmitter.Emitters[0].StartSizeRange.Z.Max *= mShellEjectScale;

		mShellEjectEmitter.Emitters[0].StartLocationOffset = mShellEjectRelLocation;
	}
}

///////////////////////////////////////////////////////////////////////////////
// CheckIdleAnims
//
simulated function CheckIdleAnims()
{
	local int i;

	if ( mHandAnims != None )
	{
		// Ensure correct hand anims loaded
		SwapSkelAnim( mHandAnims );

		// Remove any idle anims which don't exist.
		for ( i = 0; i < mIdleAnims.Length; ++i )
		{
			if ( !HasAnim( mIdleAnims[i] ) )
			{
				mIdleAnims    .Remove( i, 1 );
				mIdleAnimTimes.Remove( i, 1 );
			}
		}
	}
	else
	{
		// No hand anims specified!
		mIdleAnims.Length = 0;
	}
}


///////////////////////////////////////////////////////////////////////////////
// CalcIdleMuzzleOffset
//
simulated function CalcIdleMuzzleOffset()
{
	
}	


simulated function float SwitchPriority ()
{
	// Priority related to weapon type.
	switch ( default.mCategory )
	{
	case WPNCAT_Primary:
		return 5.0;
	case WPNCAT_Secondary:
		return 4.0;
	case WPNCAT_Knife:
		return 1.0;
	case WPNCAT_Special:
		return 3.0;
	case WPNCAT_Grenade:
		return 2.0;
	}

	return 0;
}

// bit of a fudge here:
// ensure that weapons of the same category get swapped over when picked up
// otherwise, if different category, don't do the swap
simulated function ClientWeaponSet(bool bOptionalSet)
{
	local SASWeapon W;

	Instigator = Pawn(Owner); //weapon's instigator isn't replicated to client
	if ( Instigator == None )
	{
		GotoState('PendingClientWeaponSet');
		return;
	}
	else if ( IsInState('PendingClientWeaponSet') )
	{
		GotoState('');
	}
	if ( Instigator.Weapon == self )
	{
		return;
	}

	if ( Instigator.Weapon == None )
	{
		Instigator.PendingWeapon = self;
		Instigator.ChangedWeapon();
		return;
	}
	if ( bOptionalSet && (Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup) )
	{
		return;
	}

	if ( Instigator.PendingWeapon != None )
	{
		W = SASWeapon( Instigator.PendingWeapon );
	}
	else
	{
		W = SASWeapon( Instigator.Weapon );
	}

	if (	(W.default.mCategory == default.mCategory) ||
			(W.SwitchPriority() < SwitchPriority()) )
	{
		W = SASWeapon( Instigator.PendingWeapon );
		Instigator.PendingWeapon = self;

		if ( !Instigator.Weapon.PutDown() )
		{
			Instigator.PendingWeapon = W;
		}
	}
	GotoState('');
}

///////////////////////////////////////////////////////////////////////////////
// CheckComponentMeshes
//
simulated function CheckComponentMeshes()
{
	local name	componentAttachBone;

	// only do this once for each weapon
	if ( mFPWeaponMeshActor != None )
	{
		return;
	}

	// Only need to create component meshes for weapons that will be viewed
	// in first person.
	// *** Knife fp mesh always needs creating on server side for human players as it is used
	// to determine blade position in collision tests.
	if (	Instigator != None && 
			(!Instigator.IsHumanControlled() || (!Instigator.IsLocallyControlled() && (mCategory != WPNCAT_Knife))) )
	{
		return;
	}

	// Create clip mesh actor if needed.
	if ( mFPWeaponMeshClass != None )
	{
		mFPWeaponMeshActor = Spawn( mFPWeaponMeshClass, self );
		if ( mFPWeaponMeshActor == None )
		{
			Warn( "Failed to spawn first person weapon mesh actor" );
			return;	// disaster! no weapon in 1st person view.
		}
		else
		{
			mFPWeaponMeshActor.FixupAnims( self );
			mFPWeaponMeshActor.TweenToIdle( 0.0 );
		}
	}

	// Now FP component gun mesh has been created, attach the muzzle flash and shell emitters.
	if ( mMuzzleFlashEmitter != None )
	{
		mFPWeaponMeshActor.AttachToBone( mMuzzleFlashEmitter, MUZZLE_BONE );
	}
	if ( mShellEjectEmitter != None )
	{
		mFPWeaponMeshActor.AttachToBone( mShellEjectEmitter, SHELL_BONE );
	}

	// Attach weapon to hands.
	if ( IsA( 'SASGrenadeWeapon' ) )
	{
		componentAttachBone = ATTACHBONE_HandsToGrenade;
	}
	else
	{
		componentAttachBone = ATTACHBONE_HandsToGun;
	}

	mFPWeaponMeshActor.AmbientGlow = AmbientGlow;

	mFPWeaponMeshActor.bHardAttach = true;
	AttachToBone( mFPWeaponMeshActor, componentAttachBone );
}

///////////////////////////////////////////////////////////////////////////////
// AttachToPawn
//
// Called each time the weapon is selected.
//simulated function AttachToPawn(
function AttachToPawn(
	Pawn aHolder )
{
	Super.AttachToPawn( aHolder );

	ServerSetThirdPersonFireMode( GetFireModeName() );
}


///////////////////////////////////////////////////////////////////////////////
// MoveOutOfView
//
// Put weapon down without changing weapon (waits in OutOfView state until 
// MoveIntoView is called.
simulated function MoveOutOfView()
{
	mbMoveOutOfView = true;
}


///////////////////////////////////////////////////////////////////////////////
// MoveIntoView
//
simulated function MoveIntoView()
{
	mbMoveOutOfView = false;
}


// JS don't call this directly any more - Pawn.SetGunLight is what you want
simulated event SwitchTorchOn(bool on)
{
	if ( on )
	{
		if (mTorchBeam == None)
		{
			mTorchBeam = Spawn(Class'SASTorchBeam');
			if (!AttachToBone( mTorchBeam, MUZZLE_BONE ))
			{
				// Cope with no muzzle bone
				mTorchBeam.Destroy();
				mTorchBeam = None;
			}
		}
		if (mTorchProjector == None)
		{
			mTorchProjector = Spawn(Class'SASTorchBeamProjector');
			mTorchProjector.SetDrawScale(0.05);

			// We used to attach the torch to "self" but now "self" is a pair of hands and the
			// weapon mesh is hanging off us in mFPWeaponMeshActor.
			//mTorchProjector.SetAttachBone(mFPWeaponMeshActor, MUZZLE_BONE);
		}
		if (mTorchCorona == None)
		{
			mTorchCorona = Spawn(Class'SASTorchBeamCorona');
			mTorchCorona.SetSkin(Texture'SFXTx.lights.FxL_glow_white', 0);
			mTorchCorona.SetAttachBone(self, MUZZLE_BONE, vect(0,0,0));
		}
	}
	else // off
	{
		if (mTorchBeam != None)
		{
			DetachFromBone( mTorchBeam );
			mTorchBeam.Destroy();
			mTorchBeam = None;
		}
		if (mTorchProjector != None)
		{
			mTorchProjector.UnsetAttachBone();
			mTorchProjector.Destroy();
			mTorchProjector = None;
		}
		if (mTorchCorona != None)
		{
			mTorchCorona.UnsetAttachBone();

			// ROBHACK - They made me do it.  :-(
			// Hide the corona rather than destroy it
			//mTorchCorona.Destroy();
			mTorchCorona.bCorona = False;
			mTorchCorona.bHidden = True;

			mTorchCorona = None;
		}
	}

	PlayTorchToggleAnim();
}


// JS don't call this directly any more - Pawn.SetGunLaser is what you want
simulated event _Switch1stPersonLaserOn(bool on)
{
	local PlayerController P;
	local Actor act;
	local vector camLoc;
	local rotator camRot;
	
	P = Level.GetLocalPlayerController();
	
	P.PlayerCalcView( act, camLoc, camRot );
	if ( on )
	{
		if (mLaserBeam == None)
		{
			/*mLaserBeam = Spawn(Class'SASLaserBeam');
			if (!AttachToBone( mLaserBeam, MUZZLE_BONE ))
			{
				// Cope with no muzzle bone
				mLaserBeam.Destroy();
				mLaserBeam = None;
			}*/
		}
		if (mLaserProjector == None)
		{
			mLaserProjector = Spawn(Class'SASLaserBeamProjector');
			mLaserProjector.SetDrawScale(0.05);

			// We used to attach the laser to "self" but now "self" is a pair of hands and the
			// weapon mesh is hanging off us in mFPWeaponMeshActor.
			mLaserProjector.SetAttachBone(mFPWeaponMeshActor, MUZZLE_BONE);
		}
		if (mLaserCorona == None)
		{
			mLaserCorona = Spawn(Class'SASLaserBeamCorona');
			mLaserCorona.SetSkin(Texture'SFXTx.lights.FxL_glow_white', 0);
			mLaserCorona.SetAttachBone(self, MUZZLE_BONE, vect(0,0,0));
		}
	}
	else // off
	{
		if (mLaserBeam != None)
		{
			/*DetachFromBone( mLaserBeam );
			mLaserBeam.Destroy();
			mLaserBeam = None;*/
		}
		if (mLaserProjector != None)
		{
			mLaserProjector.UnsetAttachBone();
			mLaserProjector.Destroy();
			mLaserProjector = None;
		}
		if (mLaserCorona != None)
		{
			mLaserCorona.UnsetAttachBone();
			// ROBHACK - They made me do it.  :-(
			// Hide the corona rather than destroy it
			//mLaserCorona.Destroy();
			mLaserCorona.bCorona = False;
			mLaserCorona.bHidden = True;
			mLaserCorona = None;
		}
	}
	PlayLaserToggleAnim();
}
///////////////////////////////////////////////////////////////////////////////
// PlayTorchToggleAnim
//
// Gloable version does nothing. Torch anim only allowed in Idle state.
simulated function PlayTorchToggleAnim();
///////////////////////////////////////////////////////////////////////////////
// PlayLaserToggleAnim
//
// Gloable version does nothing. Laser anim only allowed in Idle state.
simulated function PlayLaserToggleAnim();



///////////////////////////////////////////////////////////////////////////////
// Switch torch on and off
//

// JS don't call this directly any more - Pawn.SetGunLight is what you want
simulated event _Switch3rdPersonTorchOn(bool on)
{
	local SASWeaponAttachment tWpnAtt;

	tWpnAtt = SASWeaponAttachment(ThirdPersonActor);
	if(tWpnAtt != None)
	{
		tWpnAtt.SwitchTorchOn(on);
	}
}
///////////////////////////////////////////////////////////////////////////////
// Switch Laser on and off
//
// JS don't call this directly any more - Pawn.SetGunLight is what you want
simulated event _Switch3rdPersonLaserOn(bool on)
{
	local SASWeaponAttachment tWpnAtt;
	tWpnAtt = SASWeaponAttachment(ThirdPersonActor);
	if(tWpnAtt != None)
	{
		tWpnAtt.SwitchLaserOn(on);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Destroyed (tidy up)
//
// 'simulated' so that clients clean up too ... mainly for 'mFPWeaponMeshActor'
simulated event Destroyed()
{
	if (mTorchBeam != None)
	{
		mTorchBeam.Destroy();
		mTorchBeam = None;
	}
	if (mTorchProjector != None)
	{
		mTorchProjector.Destroy();
		mTorchProjector = None;
	}
	if (mTorchCorona != None)
	{
		// ROBHACK - They made me do it.  :-(
		// Hide the corona rather than destroy it
		//mTorchCorona.Destroy();
		mTorchCorona.bCorona = False;
		mTorchCorona.bHidden = True;

		mTorchCorona = None;
	}
	if (mLaserBeam != None)
	{
		mLaserBeam.Destroy();
		mLaserBeam = None;
	}
	if (mLaserProjector != None)
	{
		mLaserProjector.Destroy();
		mLaserProjector = None;
	}
	if (mLaserCorona != None)
	{
		// ROBHACK - They made me do it.  :-(
		// Hide the corona rather than destroy it
		//mLaserCorona.Destroy();
		mLaserCorona.bCorona = False;
		mLaserCorona.bHidden = True;
		mLaserCorona = None;
	}

	// Destroy 1st person weapon component mesh.
	if ( mFPWeaponMeshActor != None )
	{
		mFPWeaponMeshActor.Destroy();
		mFPWeaponMeshActor = None;
	}

	Super.Destroyed();
}

///////////////////////////////////////////////////////////////////////////////
// GiveAmmo
//
// Called when weapon is added to inventory. Creates associated ammo type
// if not already held in inventory.
function GiveAmmo(
	Pawn	aOwnerPawn )		// Owner of this weapon
{
	if ( AmmoName == None )
	{
		return;
	}

	AmmoType = Ammunition ( aOwnerPawn.FindInventoryType ( AmmoName ) );
	if ( AmmoType != None )
	{
		AmmoType.AddAmmo ( PickUpAmmoCount );
	} // if
	else
	{
		AmmoType = Spawn ( AmmoName );				// Create ammo type required
		if ( aOwnerPawn != None )
		{
			aOwnerPawn.AddInventory ( AmmoType );	// and add to player's inventory
		}
		AmmoType.AmmoAmount = PickUpAmmoCount;
	}

	if ( AmmoType.AmmoAmount < mNumInMag )
	{
		mNumInMag = AmmoType.AmmoAmount;
	} // if
}


///////////////////////////////////////////////////////////////////////////////
// DecrementAmmo
//
simulated function DecrementAmmo( 
	int aAmount )
{
	if ( AmmoType == None )
	{
		return;
	}

	if ( Instigator.IsHumanControlled() && !SASPawn( Instigator ).mInfiniteAmmoCheat )
	{
		AmmoType.AmmoAmount -= aAmount;
		AmmoType.AmmoAmount = Max( 0, AmmoType.AmmoAmount );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GiveNewMagazine
//
// Give weapon full magazine
simulated function GiveNewMagazine()
{
	if ( AmmoType == None )
	{
		return;
	}

	// Remove ammo currently held in mag. (but not for AI who have infinite ammo).
	if ( Instigator.IsHumanControlled() && !SASPawn( Instigator ).mInfiniteAmmoCheat )
	{
		if ( Role == ROLE_Authority )
		{
			DecrementAmmo( mNumInMag );
		}
		AmmoType.AmmoAmount = Max( 0, AmmoType.AmmoAmount );
	}

	// Add new mag
	mNumInMag = Min( mMagSize, AmmoType.AmmoAmount );
}

///////////////////////////////////////////////////////////////////////
// HasAmmo
//
simulated event bool HasAmmo()
{
	if ( AmmoType == None )
	{
		return false;
	}

	return AmmoType.HasAmmo();
}

///////////////////////////////////////////////////////////////////////////////
// HasFullMagazine
//
simulated function bool HasFullMagazine ()
{
	if (mMagSize == mNumInMag)
	{
		return true;
	} // if

	return false;
} // HasFullMagazine

///////////////////////////////////////////////////////////////////////////////
// HasFireMode
//
simulated function bool HasFireMode(
	int		aFireMode )
{
	if ( (mAllowedFireModes & (1<<aFireMode)) != 0 )
	{
		return true;
	}

	return false;
}

///////////////////////////////////////////////////////////////////////////////
// GetFireModeFromName
//
// Return FIREMODE_xxx equivalent to provided name arg. This function
// is required as non-SASWeapon classes cannot access the FIREMODE_xxx
// constants so to set the firemode they call the SetWeaponFireMode function
// with the name of the mode which is then converted here.
static function int GetFireModeFromName(
	name	aFireModeName )
{
	switch ( aFireModeName )
	{
	case FIREMODENAME_Single:
		return FIREMODE_Single;

	case FIREMODENAME_Burst:
		return FIREMODE_Burst;

	case FIREMODENAME_Auto:
		return FIREMODE_Auto;
	}

	Warn( "SASWeapon.GetFireModeFromName: Unrecognised name "$aFireModeName );
	return FIREMODE_None;
}

///////////////////////////////////////////////////////////////////////////////
// GetFireModeName
//
// Return name equivalent of current firemode
simulated function name GetFireModeName()
{
	switch ( mFireMode )
	{
	case FIREMODE_Single:
		return FIREMODENAME_Single;

	case FIREMODE_Burst:
		return FIREMODENAME_Burst;

	case FIREMODE_Auto:
		return FIREMODENAME_Auto;

	default:
		return 'None';
	}
}

///////////////////////////////////////////////////////////////////////////////
// NeedsToReload
//
// Returns true if mag empty or forced reload has been instigated.
simulated event bool NeedsToReload()
{
	if ( bForceReload )
	{
		return true;
	}

	return ( mNumInMag == 0 && UsesAmmo );
}

///////////////////////////////////////////////////////////////////////////////
// StopReloading
//
simulated function StopReloading();

///////////////////////////////////////////////////////////////////////////////
// IsZoomed
//
// Returns true if using weapon scope.
simulated function bool IsZoomed()
{
	if ( mScope == None )
	{
		return false;
	}

	return mScope.mbActive;
}


///////////////////////////////////////////////////////////////////////////////
// BringUp
//
simulated function BringUp(
	optional Weapon		aPrevWeapon )
{
	local PlayerController		PC;
	local bool					bHasFPWpnMesh;				

	if ( mFPWeaponMeshActor != None )
	{
		bHasFPWpnMesh = true;
	}
	CheckComponentMeshes();
	if ( !bHasFPWpnMesh )
	{
		InitSceneryCollisionPoints();
	}

	// Set hand animations for this weapon.
	if ( mHandAnims != None )
	{
		SwapSkelAnim( mHandAnims );
	}

	// Set hand skin for multiplayer (SAS or terrorist).
	SetHandSkin();

	Super.BringUp( aPrevWeapon );

	// Not sighted when first brought up.
	mbSighted = false;
	mPointedAtStartTime = 0.0;
	mbPlayedClipEmptyAnim = false;

	// Make sure weapon starts in unaimed view
	SetUnaimedView();

	if ( Instigator != None )
	{
		// Reset inertial lag effects
		Recentre();
		SetRotation(Instigator.GetViewRotation());

		SASPawn( Instigator ).mWeaponAnimSet = me3PAnimSet;
		Instigator.ChangeAnimation();

		// Make sure FoV is at default
		PC = PlayerController( Instigator.Controller );
		if ( PC != None )
		{
			PC.ResetFOV();
		}

		// Make sure light turned off.
		SASPawn( Instigator ).SetGunLight( false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ToggleMode
//
// Switch between aimed and unaimed weapon pose.
simulated function ToggleMode()
{
	if ( !mbToggleSighted )
	{
		return;
	}

	if ( mbSighted )
	{
		GotoState( 'MoveToUnaimed' );
	}
	else
	{
		GotoState( 'MoveToAimed' );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DropFrom
//
// Spawn a weapon pickup and drop it from weapon location.
function DropFrom(
	vector aFromLocation )
{
	local SASPickup	pickup;
	local bool		abInstantDrop;
	local vector	dropLocation;

	// might not be currently visible weapon, so create the mesh
	// this code ripped from Inventory: AttachToPawn
	if ( ThirdPersonActor == None )
	{
		ThirdPersonActor = Spawn ( AttachmentClass, Instigator );
		InventoryAttachment ( ThirdPersonActor ).InitFor ( self );

		ThirdPersonActor.SetLocation ( Instigator.Location );
		ThirdPersonActor.SetBase ( Instigator );

		ThirdPersonActor.SetRelativeLocation ( ThirdPersonActor.Default.RelativeLocation );
		ThirdPersonActor.SetRelativeRotation ( ThirdPersonActor.Default.RelativeRotation );
	}

	if ( Instigator != None && SASGrenadeWeapon( self ) == None && SASKnifeWeapon(self) == None )
	{
		SASPawn( Instigator ).SetGunLight( false );
		SwitchTorchOn( false ); 
		if ( ThirdPersonActor != None )
		{
			SASWeaponAttachment( ThirdPersonActor ).SwitchTorchOn( false );
		}

		if ( // ( Instigator.Controller != None ) &&
			( SASPlayerController ( Instigator.Controller ) != None ) &&
			( Instigator.Health > 0 ) )
		{
			abInstantDrop = true;

			//if ( SASPlayerController( Instigator.Controller ).bBehindView )
			//{
			//	dropLocation = ThirdPersonActor.Location;
			//}
			//else
			//{
			//	dropLocation = Location;
			//}

			dropLocation = aFromLocation;
		}
		else
		{
			abInstantDrop = false;
			dropLocation = ThirdPersonActor.Location;
		}

		pickup = Spawn( class'SASPickup',,, dropLocation, ThirdPersonActor.Rotation );
		pickup.InitDroppedPickupFor( self, abInstantDrop );

		// Release instantly if pawn does not want delayed release.
		if ( SASPawn(Instigator).mbInstantWeaponDrop )
		{
			pickup.mReleaseTimer = 0.1;
		}
	}

	// Rest of code in this function is modified version of superclass DropFrom code

	// Modified Weapon.DropFrom code
	AIRating = Default.AIRating;
	bMuzzleFlash = false;
	if ( AmmoType != None )
	{
/*		OLD SYSTEM
		// Leave ammo in clip, stored in PickupAmmoCount.
		PickupAmmoCount = mNumInMag;
*/
		// New system - pickup gets _all_ carried ammo
		PickupAmmoCount = AmmoType.AmmoAmount;

		// Remove ammo left in clip from instigators inventory store.
		AmmoType.AmmoAmount -= PickupAmmoCount;
		AmmoType = None;
	}
	else
	{
		PickupAmmoCount = 0;
	}

	// Modified Inventory.DropFrom code
	if ( Instigator != None )
	{
		if ( Instigator.Weapon == self )
		{
			Instigator.StopPlayFiring();
		}
		DetachFromPawn( Instigator );
		Instigator.DeleteInventory( self );
	}
	SetDefaultDisplayProperties();
	Instigator = None;
	StopAnimating();
	GotoState( '' );

	// Turn off any effects attached to this weapon
	if ( mLaserSight != None && mLaserSight.mbActive )
	{
		mLaserSight.Deactivate();
	}
	
	// Disable scope view
	DeactivateScope();

	_Switch1stPersonLaserOn( false );
	_Switch3rdPersonLaserOn( false );
}

///////////////////////////////////////////////////////////////////////////////
// StripAmmo
//
// Remove spare ammo from this weapon and transfer it to the supplied weapon
function StripAmmo(
	SASWeapon aOtherWeapon )
{
	local int	spareAmmo,
				maxAmmoToAddToOther,
				amountToStrip,
				tmp;

	// Must be same weapon type
	if ( Class != aOtherWeapon.Class )
	{
		return;
	}

	// Get ammo from this weapon not including what's left in the clip.
	if ( mMagSize == 1 )
	{
		spareAmmo = PickUpAmmoCount; 
	}
	else
	{
		spareAmmo = PickUpAmmoCount - mNumInMag;
	}

	// How much more ammo can other weapon take? It can take upto how much empty space
	// it has minus one clip (the current one).
	maxAmmoToAddToOther = aOtherWeapon.AmmoType.MaxAmmo - 
							(aOtherWeapon.AmmoType.AmmoAmount + (aOtherWeapon.mMagSize - aOtherWeapon.mNumInMag));
	if ( maxAmmoToAddToOther > 0 )
	{
		// Strip as much ammo as possible up to max the other weapon can take.
		amountToStrip = Min( spareAmmo, maxAmmoToAddToOther );
		
		// Round down amount so that only add full mags to other weapon.
		amountToStrip = (amountToStrip / aOtherWeapon.mMagSize) * aOtherWeapon.mMagSize;
		if ( amountToStrip > 0 )
		{
			// Take all spare ammo and put in our ammo cache
			aOtherWeapon.AmmoType.AmmoAmount += amountToStrip;
			PickUpAmmoCount -= amountToStrip;
		}
	}

	// If this gun has more ammo than ours, swap amount in mags
	if ( mNumInMag > aOtherWeapon.mNumInMag )
	{
		aOtherWeapon.AmmoType.AmmoAmount += (mNumInMag - aOtherWeapon.mNumInMag);
		tmp = mNumInMag;
		mNumInMag = aOtherWeapon.mNumInMag;
		PickUpAmmoCount -= (tmp - aOtherWeapon.mNumInMag);
		aOtherWeapon.mNumInMag = tmp;
	}
}

///////////////////////////////////////////////////////////////////////////////
// NextWeaponFunction
//
// Cycle forward through weapon modes
simulated function NextWeaponFunction()
{
	ServerNextWeaponFunction();
}


///////////////////////////////////////////////////////////////////////////////
// ServerNextWeaponFunction
//
// Cycle forward through weapon modes
function ServerNextWeaponFunction()
{
	local int	nextFireMode;

	// Cycle forward through firemodes until one is found which is
	// allowed by this weapon or the loop returns to the current fire mode.
	nextFireMode = mFireMode + 1;
	while ( nextFireMode != mFireMode )
	{
		if ( nextFireMode == FIREMODE_Count )
		{
			nextFireMode = 0;
		}

		// Check this firemode against allowed mode flags
		if ( (mAllowedFireModes & (1<<nextFireMode)) != 0 )
		{
			mFireMode = nextFireMode;
			break;
		}

		nextFireMode++;
	}

	ServerSetThirdPersonFireMode( GetFireModeName() );
}


///////////////////////////////////////////////////////////////////////////////
// PrevWeaponFunction
//
// Cycle backward through weapon modes
simulated function PrevWeaponFunction()
{
	ServerPrevWeaponFunction();
}


///////////////////////////////////////////////////////////////////////////////
// ServerPrevWeaponFunction
//
// Cycle backward through weapon modes
function ServerPrevWeaponFunction()
{
	local int	prevFireMode;

	// Cycle backwards through firemodes until one is found which is
	// allowed by this weapon or the loop returns to the current fire mode.
	prevFireMode = mFireMode - 1;
	while ( prevFireMode != mFireMode )
	{
		if ( prevFireMode == -1 )
		{
			prevFireMode = FIREMODE_Count-1;
		}

		// Check this firemode against allowed mode flags
		if ( (mAllowedFireModes & (1<<prevFireMode)) != 0 )
		{
			mFireMode = prevFireMode;
			break;
		}

		prevFireMode--;
	}

	ServerSetThirdPersonFireMode( GetFireModeName() );
}


///////////////////////////////////////////////////////////////////////////////
// SetFireMode
//
simulated function SetFireMode(
	name	aFireModeName )
{
	ServerSetFireMode( aFireModeName );
}


///////////////////////////////////////////////////////////////////////////////
// ServerSetFireMode
//
// Set weapon mode by name
function ServerSetFireMode(
	name	aFireModeName )
{
	local int fireModeVal;

	fireModeVal = GetFireModeFromName( aFireModeName );
	if ( fireModeVal == FIREMODE_None )
	{
		return;
	}

	if ( HasFireMode( fireModeVal ) )
	{
		mFireMode = fireModeVal;

		ServerSetThirdPersonFireMode( aFireModeName );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerSetThirdPersonFireMode
//
function ServerSetThirdPersonFireMode(
	name	aFireModeName )
{
	if ( (ThirdPersonActor != None) && (aFireModeName != 'None') )
	{
		WeaponAttachment( ThirdPersonActor ).FiringMode = aFireModeName;
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayerCanAutoReload
//
// Returns true if current difficulty setting allows auto reloading.
simulated function bool PlayerCanAutoReload()
{
	local SASGRI gri;
	
	gri = SASGRI( PlayerController( Instigator.Controller ).GameReplicationInfo );
	if ( (gri == None) || (gri.mDifficultySetting.AutoReload == 1) )
	{
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// Fire
//
// Called on pressing of fire button (not called again while button held).
// Function is overridden in some weapon states to bypass firing (eg while reloading).
simulated function Fire(
	float	aValue )			// Unused
{
	// Can't fire if out of ammo
	// TODO - play empty mag sound
	//if ( !HasAmmo() )
	//{
	//	return;
	//}

	if ( NeedsToReload() )
	{
		if ( !Instigator.IsHumanControlled() )
		{
			SASAIController( Instigator.Controller ).NotifyClipEmpty();
			return;
		}
		else
		{
			// Humans will auto reload if difficulty setting allows it.
			if ( HasAmmo() && PlayerCanAutoReload() )
			{
				GotoState( 'Reloading' );
				return;
			}
			// else fall through to instigate firing which will deal with empty firing.
		}
	}

	// Server side firing (change to firing state)
	ServerFire();

	if ( Role < ROLE_Authority )
	{
		GotoState( 'ClientFiring' );
		SetCutoutTimerRate ();
		LocalFire();
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerFire
//
// Called on the server side each time the weapon is to fire (on pressing
// fire button, NOT while button held). Calls fn LocalFire to instigate firing
// animations/effect on clients.
function ServerFire()
{
	GotoState( 'NormalFire' );
	SetCutoutTimerRate ();
	LocalFire();
}


///////////////////////////////////////////////////////////////////////////////
// LocalFire
//
// Called on client side each time weapon is to fire in order to instigate
// firing animations/effect.
simulated function LocalFire ()
{
	local PlayerController P;
	local float rise, yaw;

	bPointing = true;

	if ( Affector != None )
	{
		Affector.FireEffect ();
	}

	if ( PlayFiring() )
	{
		// only shake / precess the view if a bullet has actually been fired.
		if ( ( Instigator != None ) && Instigator.IsLocallyControlled () )
		{
			P = PlayerController ( Instigator.Controller );
			if ( P != None )
			{
				// create a random shake direction
//				P.RandomShakeView ( ShakeTime, ShakeMag, CameraShakeMin, CameraShakeMax, 120000, ShakeSpeed, 2 );
				P.ShakeView ( ShakeTime, ShakeMag, ShakeVert, ShakeRate, ShakeSpeed, ShakeIterations );

				//Ste Hax - replaced the random factor with a range between min + max for the three fire modes.

				if ( mFireMode == FIREMODE_Burst )
				{
					rise = Frand()*(mBurstShotRiseMax-mBurstShotRiseMin)+mBurstShotRiseMin;
					yaw = Frand()*(mBurstShotYawMax-mBurstShotYawMin)+mBurstShotYawMin;
				} // if
				else if (mbSighted)
				{
					rise = Frand()*(mAimedShotRiseMax-mAimedShotRiseMin)+mAimedShotRiseMin;
					yaw = Frand()*(mAimedShotYawMax-mAimedShotYawMin)+mAimedShotYawMin;
				}
				else
				{
					rise = Frand()*(mNormalShotRiseMax-mNormalShotRiseMin)+mNormalShotRiseMin;
					yaw = Frand()*(mNormalShotYawMax-mNormalShotYawMin)+mNormalShotYawMin;
				}

				P.RotateView(mRiseTime, yaw, rise);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// AltFire
//
// Called on pressing of alt. fire button (not called again while button held).
// Function is overridden in some weapon states to bypass firing (eg while reloading).
simulated function AltFire(
	float	aValue )
{
	if ( !HasAmmo() )
	{
		return;
	}

	ServerAltFire();

	if ( Role < ROLE_Authority )
	{
		LocalAltFire();
		GotoState ( 'ClientFiring' );
		SetCutoutTimerRate ();
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerAltFire
//
// Called on the server side each time the weapon is to alt. fire (on pressing
// alt. fire button, NOT while button held). Calls fn LocalFire to instigate
// firing animations/effect on clients.
/*
function ServerAltFire()
{
	Super.ServerAltFire();

	if ( mLaserSight != None )
	{
		if ( mLaserSight.mbActive )
		{
			mLaserSight.Deactivate();
		}
		else
		{
			mLaserSight.Activate();
		}
	}
	else if ( mTacticalLight != None )
	{
		if ( mTacticalLight.mbActive )
		{
			mTacticalLight.Deactivate();
		}
		else
		{
			mTacticalLight.Activate();
		}
	}
	else if ( mScope != None )
	{
		GotoState( 'Zooming' );
	}
	//else if (HasAmmo ())
	//{
	//	GotoState ('NormalFire');
	//	LocalAltFire ();
	//}
	//else
	//{
	//	log ("WARNING "$self$" HAS NO AMMO!!!");
	//}
}
*/

///////////////////////////////////////////////////////////////////////////////
// LocalAltFire
//
// Called on client side each time weapon is to alt. fire in order to instigate
// firing animations/effect.
simulated function LocalAltFire()
{
	/*if (mScope != None)
	{
		// Do nothing?
	}
	else
	{
		bPointing = true;

		PlayAltFiring ();
	}*/
}


///////////////////////////////////////////////////////////////////////////////
// ClientFinish
//
simulated function ClientFinish()
{
	// Do nothing if we dont have an instigator/controller.
	if ( (Instigator == None) || (Instigator.Controller == None) )
	{
		GotoState( '' );
		return;
	}

	if ( NeedsToReload() )
	{
		if ( HasAmmo() && (!Instigator.PressingFire() || (mFireMode == FIREMODE_Single)) )
		{
			// Now only if difficulty setting allows auto reload.
			if ( bForceReload || PlayerCanAutoReload() )
			{
				if ( mbSighted )
				{
					GotoState( 'MoveToUnaimed' );
				}
				else
				{
					GotoState('Reloading');
				}
				return;
			}
		}
	}

	if ( !HasAmmo() && PlayerCanAutoReload() )
	{
		Instigator.Controller.SwitchToBestWeapon();
		if ( !bChangeWeapon )
		{
			PlayIdleAnim();
			GotoState( 'Idle' );
			return;
		}
	}

	if ( mbMoveOutOfView )
	{
		GotoState( 'MovingOutOfView' );
		return;
	}

	if ( bChangeWeapon )
	{
		if ( mbSighted )
		{
			GotoState( 'MoveToUnaimed' );
		}
		else
		{
			GotoState( 'DownWeapon' );
		}
	}
	else if ( (mFireMode == FIREMODE_Auto) && Instigator.PressingFire() )
	{
		Global.Fire( 0 );
	}
	else
	{
		if ( Instigator.PressingAltFire() )
		{
			Global.AltFire( 0 );
		}
		else
		{
			PlayIdleAnim();
			GotoState( 'Idle' );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// Finish
//
// Called whenever a sequence (e.g. single fire instance, reloading, weapon up)
// is completed to determine next state to move to.
// Occurs on server side only.
function Finish()
{
	local bool				bForce, 
							bForceAlt;
	local SASAIController	AI;	

	// Do nothing if we have no instigator/controller
	if ( (Instigator == None) || (Instigator.Controller == None) )
	{
		GotoState( '' );
		return;
	}

	if ( mbMoveOutOfView )
	{
		GotoState( 'MovingOutOfView' );
		return;
	}

	// If change weapon requested then deselect this weapon.
	if ( bChangeWeapon )
	{
		if ( mbSighted )
		{
			GotoState( 'MoveToUnaimed' );
		}
		else
		{
			GotoState( 'DownWeapon' );
		}
		return;
	}

	if ( Instigator.Controller.mType != CONTROLLER_Player )
	{
		AI = SASAIController( Instigator.Controller );
	}

	// Check for empty clip.
	if ( NeedsToReload() )
	{
		if ( AI == None )
		{
			// Human player weapons auto-reload when clip is empty and not holding
			// down fire button during auto-fire. 
			if ( HasAmmo() && (!Instigator.PressingFire() || (mFireMode == FIREMODE_Single)) )
			{
				// Now only if difficulty setting allows auto reload.
				if ( bForceReload || PlayerCanAutoReload() )
				{
					// If in sighted mode, first go to ported view.
					if ( mbSighted )
					{
						GotoState( 'MoveToUnaimed' );
					}
					else
					{
						GotoState( 'Reloading' );
					}
					return;
				}
			}

			// Don't need to worry about running out of ammo for human players, just allow firing empty.
		}
		else
		{
			// AI allowed to fire empty rounds?
			if ( AI.mbCanFireEmpty )
			{
				// If emptry round timer hasn't been set then do it.
				if ( AI.mFireEmptyEndTime == 0.0 )
				{
					AI.InitEmptyFiringTimer();
				}
			}

			// Only notify AI of empty clip if it's not allowed to fire empty rounds.
			if ( !AI.mbCanFireEmpty || (AI.mFireEmptyEndTime <= Level.TimeSeconds) )
			{
				// Must put weapon in idle state so that any responses instagated by calling
				// NotifyClipEmpty are guaranteed to occur.
				GotoState( 'Idle' );
				
				// Let AI controller choose what to do next (may reload, select other weapon etc).
				AI.NotifyClipEmpty();
				return;
			}
		}
	}

	bForce			= bForceFire;
	bForceAlt		= bForceAltFire;
	bForceFire		= false;
	bForceAltFire	= false;

	// If change weapon requested then deselect this weapon.
	if ( bChangeWeapon )
	{
		if ( mbSighted )
		{
			GotoState( 'MoveToUnaimed' );
		}
		else
		{
			GotoState( 'DownWeapon' );
		}
		return;
	}

	// What to do for AI controlled weapons...
	if ( AI != None )
	{
		// AI controlled weapons must have ammo if reached this point as weapon
		// has passed the NeedsToReload() check above.
		if ( !HasAmmo() && !AI.mbCanFireEmpty )
		{
			Warn( "SASWeapon.Finish(): Error: Weapon has no ammo but thinks clip is not empty!" );
		}

		// If in auto fire mode try to fire again, else switch to idle state.
		if ( mFireMode == FIREMODE_Auto )
		{
			if ( !AI.WeaponFireAgain( 1.0, true ) )
			{
				// Hmm, not sure why bChangeWeapon would have been set. Need to
				// look into this as it should only get set if clip is empty which
				// is checked for earlier on.
				if ( bChangeWeapon )
				{
					if ( mbSighted )
					{
						GotoState( 'MoveToUnaimed' );
					}
					else
					{
						GotoState( 'DownWeapon' );
					}
				}
				else
				{
					GotoState( 'Idle' );
				}
			}
		}
		else
		{
			GotoState( 'Idle' );
		}
	}
	else
	{
		// Must be human controlled then...

		if ( Instigator.Weapon != self )
		{
			GotoState( 'Idle' );
		}
		else if ( bForce || ((mFireMode == FIREMODE_Auto) && Instigator.PressingFire()) )
		{
			Global.ServerFire();
		}
		else if ( bForceAlt || Instigator.PressingAltFire() )
		{
			Global.ServerAltFire ();
		}
		else
		{
			GotoState( 'Idle' );
		}
	}
}

// burst fire and normal fire call this, but do their own sound playing
simulated function FireABulletNoSound()
{
	local SASPlayerController	instigatorPC;
	local int					i;
	local bool					bCheckDoubleTap;
	
	if ( AmmoType == None )
	{
		return;
	}

	if ( mNumInMag < 1 )
	{
		// Do nothing if firing with empty clip.
		return;
	}

	// Now burst fire calls this more than once, we're back to one bullet per fire
	// Don't decrement shotgun ammo if an AI soldier - this is to stop problems with door
	// breach procedure.
	if ( Instigator.Controller.mType != CONTROLLER_AISoldier || SASShotgun( self ) == None )
	{
		mNumInMag--;
	}
	
	// JS The ammo reduction happened in fireray too.
	// I've moved it here because shotgun calls fireray multiple times per bullet.
	
	DecrementAmmo( 1 );

	if ( Instigator != None && Instigator.Controller != None )
	{
		instigatorPC = SASPlayerController( Instigator.Controller );
		if ( instigatorPC != None )
		{
			// Only consider checking&recording a double tap if firing primary or secondary
			// and not in burst fire mode.
			if (	(mCategory == WPNCAT_Primary || mCategory == WPNCAT_Secondary) && 
					(mFireMode != FIREMODE_Burst) )
			{
				bCheckDoubleTap = true;
			}

			// Now burst fire calls this more than once, we're back to one bullet per fire
			if ( instigatorPC.PlayerReplicationinfo != None )
			{
				SASPRI( instigatorPC.PlayerReplicationinfo ).BulletFired( bCheckDoubleTap );
			}
			
		} 
	}
	
	if ( Role == ROLE_Authority )
	{
		for (i = 0; i < mRoundsPerShot; i++)
		{
			if ( AmmoType.bInstantHit )
			{
				// Now burst fire calls this more than once, we're back to one bullet per fire
				// Actually, that's not quite true, the shotgun does more than one bullet
				FireProjectileRay();
			}
			else
			{
				FireProjectileSlow();
			}
		}
	}

	DoShotEffects();

	if (	(Instigator != None) && 
			(Instigator.Controller != None) &&
			(Instigator.Controller.mType != CONTROLLER_Player) )
	{
		SASAIController( Instigator.Controller ).NotifyWeaponFired();
	}
}

simulated function SingleBulletFireSound()
{
	if ( mFireSounds.Length > 0 )
	{
		if ( mFireSounds.Length > 0 )
		{
			PlayOwnedSound ( mFireSounds[ Rand ( mFireSounds.Length ) ],
							SLOT_None,
							RandRange(FireVolumeMin, FireVolumeMax),
							false,
							mAudibleRadius,
							RandRange(FirePitchMin, FirePitchMax),
							true );
		}
		else
			LogHuman("No single bullet fire sound for "$self);
	}
}

simulated event AnimNotifyFireInternal ()
{
	FireABulletNoSound();
	
	// This notify is either the first bullet of a burst of bullets, or it's a single-shot bullet.
	// So either way we play a sound now.
	
	// Are we in burst mode and do we have enough bullets for a whole burst sample?
	if (mFireMode == FIREMODE_Burst && mNumInMag >= 3)
	{
		if ( mBurstFireSounds.Length > 0 )
		{
			PlayOwnedSound ( mBurstFireSounds[ Rand ( mBurstFireSounds.Length ) ],
							 SLOT_None,
							 RandRange(BurstFireVolumeMin, BurstFireVolumeMax),
							 false,
							 mAudibleRadius,
							 RandRange(BurstFirePitchMin, BurstFirePitchMax),
							 true );
		}
		else
			LogHuman("No burst fire sound for "$self);
			
		mBurstFireSampleUsed = true;
	}
	else
	{
		// let's just play one bullet sound at a time
		SingleBulletFireSound();
		
		mBurstFireSampleUsed = false;
	}	
}

///////////////////////////////////////////////////////////////////////////////
// AnimNotifyFire
//
// Callback from animation to instigate actual firing.

// Only used in burst mode. In single and auto, we just go from when PlayFire happens.
simulated event AnimNotifyFire ()
{
	if (mFireMode == FIREMODE_Burst)
	{
		AnimNotifyFireInternal();
	}
}

// for burst fire, more notifies happen
simulated event AnimNotifyBurstFire ()
{
	if (mFireMode == FIREMODE_Burst)
	{
		// fire another bullet
		if (mNumInMag > 0)
		{
			FireABulletNoSound();
			
			// Did we play our 3-shot sound?
			if (!mBurstFireSampleUsed)
			{
				// nope, let's play some more one-shots.
				SingleBulletFireSound();
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// AnimNotifyEjectClip
//
// Callback from animation to instigate The First Part of a reload.
simulated event AnimNotifyEjectClip()
{
	local SASPlayerController	instigatorPC;
	local int	random;

	instigatorPC = SASPlayerController( Pawn( Owner ).Controller );

	if ( AmmoType == None )
	{
		return;
	}

	// Only play reload sounds for Player
	if ( instigatorPC != None )
	{
		random = rand(mEjectClipSounds.Length);
		PlaySound( mEjectClipSounds[random], SLOT_None, 1 );
	}
}

///////////////////////////////////////////////////////////////////////////////
// AnimNotifyReplaceClip
//
// Callback from animation to instigate The Second Part of a reload.
simulated event AnimNotifyReplaceClip()
{
	local SASPlayerController	instigatorPC;
	local int	random;

	instigatorPC = SASPlayerController( Pawn( Owner ).Controller );

	if ( AmmoType == None )
	{
		return;
	}

	// Only play reload sounds for Player
	if ( instigatorPC != None )
	{
		random = rand(mReplaceClipSounds.Length);
		PlaySound( mReplaceClipSounds[random], SLOT_None, 1 );
	}
}


////////////////////////////////////////////////////////////////////////////////
// AnimNotifyScopeOn 
//
// Callback from animation to activate scope
simulated event AnimNotifyScopeOn ()
{
	if ( mScope != None )
	{
		mScope.Activate();
	}
}

////////////////////////////////////////////////////////////////////////////////
// AnimNotifyScopeOff 
//
// Callback from animation to deactivate scope
simulated event AnimNotifyScopeOff ()
{
	if ( mScope != None )
	{
		mScope.Deactivate();
	}
}

///////////////////////////////////////////////////////////////////////////////
// FireProjectileSlow
//
function FireProjectileSlow()
{
	local vector	start;

	start = GetFireStart();
	AdjustedAim = Instigator.AdjustAim( AmmoType, start, mShotAutoTargettingSpread );
	mShotAutoTargetLockedOn =
		( AdjustedAim != GetDesiredFiringRotation( true ) );
	AmmoType.SpawnProjectile(start, AdjustedAim );

	// DEBUG: Don't decrement ammo amount if infinte ammo cheat is active for
	// instigator.
	DecrementAmmo( 1 );
}


///////////////////////////////////////////////////////////////////////////////
// FireProjectileRay
//
function FireProjectileRay()
{
	local vector	startTrace,
					endTrace,
					traceDir;
	local rotator	rotn,
					desiredFiringRotation;
	local int		noHitZoneCurrent;
	local bool		bFiredByAI;
	local Actor		target;

	// Determine what the start point for the projectile should be which
	// depends on wheter the weapon firer is an AI or player controlled.
	bFiredByAI = (	(Instigator.Controller != None) && 
					(Instigator.Controller.mType != CONTROLLER_Player) );	
	if ( bFiredByAI && (ThirdPersonActor != None) )
	{
		startTrace = GetThirdPersonFireStart();
	}
	else
	{
		startTrace = GetFireStart();
	}

	
	if ( bFiredByAI )
	{
		desiredFiringRotation = GetDesiredFiringRotation( true );
		target = Instigator.Controller.Target;
	}
	else	// player firing
	{
		// Apply any auto lock on to the aiming direction (in world space) to
		// use for the weapon.
		desiredFiringRotation =
			Instigator.AdjustAim( AmmoType, startTrace, mShotAutoTargettingSpread );	
		mShotAutoTargetLockedOn =
			( desiredFiringRotation != GetDesiredFiringRotation( true ) );
	}

	// Calculate a random firing angle deviation within the local 
	// space of the weapon.  The devaition value should be based on
	// the current shot spread of the player/weapon.
	noHitZoneCurrent = 0;
	if ( SASPawn( Instigator ) != None )
	{
		noHitZoneCurrent = SASPawn( Instigator ).mShooterNoHitZoneCurrrent;
	}
	traceDir = vect( 1, 0, 0 );
	rotn.Pitch	= 0;
	rotn.Yaw	= int ( RandRange ( noHitZoneCurrent, mShotSpreadAngleCurrent ) );
	rotn.Roll	= 0;
	traceDir = traceDir >> rotn;
	rotn.Pitch	= 0;
	rotn.Yaw	= 0;
	rotn.Roll	= int ( float ( 65535 ) * FRand () );
	traceDir = traceDir >> rotn;

	// Rotate the firing angle into world space (via the aiming direction).
	traceDir = traceDir >> desiredFiringRotation;
	endTrace = startTrace + (traceDir * TraceDist);
	
	// Store the start and end point for debugging purposes.
	mDebugTraceStart = startTrace;
	mDebugTraceEnd   = endTrace;
		
	// Fire the damage causing element of the projectile.
	if ( SASAmmo( AmmoType ) != None )
	{
		SASAmmo( AmmoType ).FireRayThroughObjects( self, bFiredByAI, startTrace, TraceDist, traceDir, target );
	}
	else
	{
		Warn( "Ammo Type isn't an SASAmmo Type!!!" );
	}

	// Fire the visual element of the projectile (a tracer) intermitently.
	if ( mTracerClass != None )
	{
		if ( --mTracerCounter < 0 )
		{
			Spawn(
				mTracerClass,
				Owner,,
				startTrace,
				Rotator(endTrace - startTrace) );

			mTracerCounter = int( RandRange( mTracerSpacing.Min, mTracerSpacing.Max ) );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoShotEffects
//
// Spawn effects (muzzle flash, shell eject etc) for single shot
simulated function DoShotEffects()
{
	local SASPlayerController	ownerPlayerController;

	// If weapon owner is a human player then do first person effects
	if ( Instigator != None )
	{
		if ( Instigator.IsFirstPerson() && Instigator.IsLocallyControlled() )
		{
			ownerPlayerController = SASPlayerController( Instigator.Controller );
			/*if (ownerPlayerController != None)
			{
				ApplyKick ();

				ownerPlayerController.WeaponShake (
					mRecoilShakePosMax,
					mRecoilShakePosRate,
					mRecoilShakePosTime,
					mRecoilShakeRotMax,
					mRecoilShakeRotRate,
					mRecoilShakeRotTime);
			}*/

			DoFirstPersonMuzzleFlash();
			EjectShellCase();
		}
//		SetWispSmokeCountdown();
	}

	if ( mFireLoudness > 0.0 )
	{
		Instigator.MakeNoise( mFireLoudness, NOISE_Gunfire );
	}
}

/*
///////////////////////////////////////////////////////////////////////////////
simulated function SetWispSmokeCountdown()
{
	// make smoke darker, if bullets fired before we've had a chance to emit the smoke wisp
	if(mWispSmokeCountdownTimer > 0)
	{
		mWispSmokeDarkenFactor += WPNWISPSMOKE_DarkeningFactor;
		mWispSmokeDarkenFactor = FClamp( mWispSmokeDarkenFactor, 0.0, 1.0 );
	}
    mWispSmokeCountdownTimer = WispSmokeEmitDelay;
}
*/

///////////////////////////////////////////////////////////////////////////////
// DoFirstPersonMuzzleFlash
//
// Trigger single muzzle flash particle
simulated function DoFirstPersonMuzzleFlash()
{
	local int numEmtr;

	if ( mMuzzleFlashEmitter != None )
	{
		for ( numEmtr = 0; numEmtr < mMuzzleFlashEmitter.Emitters.Length; numEmtr++ )
		{
			mMuzzleFlashEmitter.Emitters[numEmtr].SpawnParticle ( mMuzzleFlashEmitter.Emitters[numEmtr].ParticlesPerShot );
			mMuzzleFlashEmitter.Emitters[numEmtr].AllParticlesDead = false;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// EjectShellCase
//
simulated function EjectShellCase()
{
	if ( mShellEjectEmitter != None )
	{
		if(Owner!=None)
		{
			if(Owner.GroundMaterial!=None)
			{
				mShellEjectEmitter.Emitters[0].DeathSoundIndex.Min=Owner.GroundMaterial.mMaterialType;
				mShellEjectEmitter.Emitters[0].DeathSoundIndex.Max=Owner.GroundMaterial.mMaterialType;
			}
		}
		mShellEjectEmitter.Emitters[0].StartVelocityRange.X.Min = 70.0;
		mShellEjectEmitter.Emitters[0].StartVelocityRange.X.Max = 100.0;
		mShellEjectEmitter.Emitters[0].StartVelocityRange.Y.Min = 0.0;
		mShellEjectEmitter.Emitters[0].StartVelocityRange.Y.Max = 0.0;
		mShellEjectEmitter.Emitters[0].StartVelocityRange.Z.Min = 70.0;
		mShellEjectEmitter.Emitters[0].StartVelocityRange.Z.Max = 100.0;
		mShellEjectEmitter.TriggerParticle ();
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayWeaponAnim
//
// Play weapon animation type on hands mesh. Also plays the matching anim on the
// 1st person gun/clip meshes if the meshes/anims exist.
simulated function PlayWeaponAnim(
	EWeaponAnim		aeWpnAnim,
	optional float	aRate,
	optional float	aBlendTime,
	optional float	aStartFrame )
{
	local name	anim;

	if ( aRate == 0.0 )
	{
		aRate = 1.0;
	}

	switch ( aeWpnAnim )
	{
	case WPNANIM_SightedIdle:
		anim = ANIMNAME_SightedIdle;
		break;

	case WPNANIM_Select:
		anim = ANIMNAME_Select;
		// Apply additional rate scaling.
		if ( ThirdPersonActor != None )
		{
			aRate *= SASWeaponAttachment( ThirdPersonActor ).mWeaponUpAnimRateScalar;
		}
		break;

	case WPNANIM_Deselect:
		anim = ANIMNAME_Deselect;
		// Apply additional rate scaling.
		if ( ThirdPersonActor != None )
		{
			aRate *= SASWeaponAttachment( ThirdPersonActor ).mWeaponDownAnimRateScalar;
		}
		break;

	case WPNANIM_MoveToSighted:
		anim = ANIMNAME_ToSighted;
		break;

	case WPNANIM_MoveFromSighted:
		anim = ANIMNAME_FromSighted;
		break;

	case WPNANIM_SightedFire:
		if ((mFireMode == FIREMODE_Auto || mFireMode == FIREMODE_Burst) && mBurstAutoSightedFireAnim != '')
			anim = mBurstAutoSightedFireAnim;
		else
			anim = mSightedFireAnim;
		break;

	case WPNANIM_UnsightedFire:
		if ((mFireMode == FIREMODE_Auto || mFireMode == FIREMODE_Burst) && mBurstAutoFireAnim != '')
			anim = mBurstAutoFireAnim;
		else
			anim = mUnsightedFireAnim;
		break;

	case WPNANIM_SightedEmpty:
		anim = ANIMNAME_SightedEmpty;
		break;

	case WPNANIM_UnsightedEmpty:
		anim = ANIMNAME_UnsightedEmpty;
		break;

	case WPNANIM_AltFire:
		anim = ANIMNAME_AltFire;
		break;

	case WPNANIM_SightedEndFire:
		anim = ANIMNAME_SightedEndFire;
		break;

	case WPNANIM_UnsightedEndFire:
		if ( HasAnim( ANIMNAME_UnsightedEndFire ) )
		{
			anim = ANIMNAME_UnsightedEndFire;
		}
		else
		{
			anim = ANIMNAME_SightedEndFire;
		}
		break;

	case WPNANIM_Reload:
		anim = ANIMNAME_Reload;
		break;

	case WPNANIM_SightedTorchToggle:
		anim = ANIMNAME_SightedTorchToggle;
		break;

	case WPNANIM_UnsightedTorchToggle:
		anim = ANIMNAME_UnsightedTorchToggle;
		break;

	// TODO: Change anims if there are different ones
	case WPNANIM_SightedLaserToggle:
		anim = ANIMNAME_SightedTorchToggle;
		break;
	case WPNANIM_UnsightedLaserToggle:
		anim = ANIMNAME_UnsightedTorchToggle;
		break;
	case WPNANIM_PullPin:
		anim = ANIMNAME_PullPin;
		break;

	case WPNANIM_ThrowGrenade:
		anim = ANIMNAME_ThrowGrenade;
		break;

	case WPNANIM_Punch:
		anim = ANIMNAME_Punch;
		break;

	case WPNANIM_ShotGunReloadLoop:
		anim = ANIMNAME_ShotGunReloadLoop;
		break;

	case WPNANIM_ShotGunReloadEnd:
		anim = ANIMNAME_ShotGunReloadEnd;
		break;

	default:
		Warn( "Invalid weapon anim type "$aeWpnAnim$" passed to PlayWeaponAnim()." );
		return;
	}

	if ( anim != 'None' )
	{
		PlayAnim( anim, aRate, aBlendTime );

		if ( aStartFrame > 0.0 )
		{
			SetAnimFrame( aStartFrame );
		}
	}

	// Play the anim on the gun mesh if mesh/anim exists.
	if ( mFPWeaponMeshActor != None )
	{
		mFPWeaponMeshActor.PlayWeaponAnim( aeWpnAnim, aRate, aBlendTime, aStartFrame );
	}
}


///////////////////////////////////////////////////////////////////////////////
// TweenWeaponAnim
//
// Tween to weapon animation type on hands mesh. Also tween to the matching
// anim on the 1st person gun/clip meshes if the meshes/anims exist.
simulated function TweenWeaponAnim(
	EWeaponAnim		aeWpnAnim,
	optional float	aBlendTime )
{
	local name anim;

	switch ( aeWpnAnim )
	{
		// Sighted idle.
	case WPNANIM_SightedIdle:
		anim = ANIMNAME_SightedIdle;
		break;

		// Used for unsighted idle.
	case WPNANIM_UnsightedFire:
		anim = mUnsightedFireAnim;
		break;

	default:
		Warn( "Invalid anim type "$aeWpnAnim$" passed to TweenWeaponAnim()" );
		break;
	}

	if ( anim != 'None' )
	{
		TweenAnim( anim, aBlendTime );
	}

	if ( mFPWeaponMeshActor != None )
	{
		mFPWeaponMeshActor.TweenToIdle( aBlendTime );
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlaySelect
//
// Play weapon select animation and sound
simulated function PlaySelect()
{
	bForceFire		= false;
	bForceAltFire	= false;

	PlayWeaponAnim( WPNANIM_Select );
	SASPawn( Instigator ).PlaySelectWeapon();

	//Owner.PlaySound( SelectSound, SLOT_Misc, 1.0 );
}


///////////////////////////////////////////////////////////////////////////////
// TweenDown
//
// Called when changing weapon to animate weapon down
simulated function TweenDown()
{
	local name	anim;
	local float	frame,
				rate,
				blendTime;

	// If playing 'move into view' anim then try to belnd between them.
	GetAnimParams( 0, anim, frame, rate );
	if ( anim == ANIMNAME_Select )
	{
		frame = 1.0 - frame;
		frame = FMin( frame, 1.0 );
		blendTime = 0.2;
	}
	else
	{
		frame = 0.0;
		blendTime = 0.05;
	}

	PlayWeaponAnim( WPNANIM_Deselect, 1.0, blendTime );
	if ( frame > 0.0 )
	{
		SetAnimFrame( frame );
	}

	//PlayOwnedSound( HolsterSound );

	SASPawn( Instigator ).PlayDeselectWeapon();
}


///////////////////////////////////////////////////////////////////////////////
// PlayMoveIntoView
//
simulated function PlayMoveIntoView()
{
	local name	anim;
	local float	frame,
				rate,
				blendTime;

	bForceFire		= false;
	bForceAltFire	= false;

	// If playing 'move out of view' anim then try to belnd between them.
	GetAnimParams( 0, anim, frame, rate );
	if ( anim == ANIMNAME_Deselect )
	{
		frame = 1.0 - frame;
		frame = FMin( frame, 1.0 );
		blendTime = 0.2;
	}
	else
	{
		frame = 0.0;
		blendTime = 0.0;
	}
	PlayWeaponAnim( WPNANIM_Select, 1.0, blendTime );
	if ( frame > 0.0 )
	{
		SetAnimFrame( frame );
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayMoveIntoView
//
simulated function PlayMoveOutOfView()
{
	local name	anim;
	local float	frame,
				rate,
				blendTime;

	// If playing 'move into view' anim then try to belnd between them.
	GetAnimParams( 0, anim, frame, rate );
	if ( anim == ANIMNAME_Select )
	{
		frame = 1.0 - frame;
		frame = FMin( frame, 1.0 );
		blendTime = 0.2;
	}
	else if ( mbSighted )
	{
		// When sighted just do a long tween down to the first frame of the 'select' anim. 
		TweenAnim( ANIMNAME_Select, 0.75 );
		return;
	}
	else
	{
		frame = 0.0;
		blendTime = 0.05;
	}

	PlayWeaponAnim( WPNANIM_Deselect, rate, blendTime );
	if ( frame > 0.0 )
	{
		SetAnimFrame( frame );
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayFiring
//
// Play firing animation and sound
simulated function bool PlayFiring()
{
	local EWeaponAnim	eAnim;
	local bool			bFiring;
	local float			startFrame;
	local float			blendTime;

	bFiring = false;

	if ( Instigator.IsHumanControlled() )
	{
		// Don't do anything if clip is empty and already played empty anim.
		if ( mNumInMag < 1 && UsesAmmo && mbPlayedClipEmptyAnim )
		{
			SASPlayIdleAnim( 0.05 );
			return false;
		}

		// If currently playing a timeout idle anim, give a little bit of
		// time to belnd out to reduce snapping.
		if ( IsPlayingTimeoutIdleAnim() )
		{
			blendTime = 0.1;
		}
	}
	mbPlayedClipEmptyAnim = false;

	if ( mbToggleSighted && mbSighted )
	{
		if ( mNumInMag < 1 && UsesAmmo)
		{	
			eAnim = WPNANIM_SightedEmpty;
			mbPlayedClipEmptyAnim = true;
		}
		else
		{
			eAnim		= WPNANIM_SightedFire;
			startFrame	= mFireAnimStartFrame;
			bFiring		= true;
		}
	}
	else
	{
		if ( mNumInMag < 1 && UsesAmmo)
		{
			eAnim = WPNANIM_UnsightedEmpty;
			mbPlayedClipEmptyAnim = true;
		}
		else
		{
			eAnim		= WPNANIM_UnsightedFire;
			startFrame	= mFireAnimStartFrame;
			bFiring		= true;
		}
	}

	PlayWeaponAnim( eAnim, 1.0, blendTime, startFrame );

	// In everything apart from burst mode, we simple fire when the mouse is pressed.
	if ( bFiring && (mFireMode != FIREMODE_Burst) && UsesAmmo )
	{
		AnimNotifyFireInternal();
	}

	// Trigger 3rd person effects/anims
	if ( mNumInMag > 0 )
	{
		IncrementFlashCount();
	}
	else
	{
		IncrementEmptyFireCount();
	}

	return bFiring;
}


///////////////////////////////////////////////////////////////////////////////
// PlayEndFiring
//
//::simulated function PlayEndFiring()
//::{
//::	local EWeaponAnim	eAnim;
//::
//::	if ( mbToggleSighted && mbSighted )
//::	{
//::		eAnim = WPNANIM_SightedEndFire;
//::	}
//::	else
//::	{
//::		eAnim = WPNANIM_UnsightedEndFire;
//::	}
//::
//::	PlayWeaponAnim( eAnim, 1.0 );
//::}


///////////////////////////////////////////////////////////////////////////////
// PlayAltFiring
//
// Play alt firing animation and sound
//::simulated function PlayAltFiring()
//::{
//::	PlayWeaponAnim( WPNANIM_AltFire, 1.0 );
//::}


///////////////////////////////////////////////////////////////////////////////
// PlayReloading
//
// Play reloading animation and sound
simulated function PlayReloading()
{
	local float blendTime;

	// If currently playing a timeout idle anim, give a little bit of
	// time to blend out to reduce snapping.
	if ( Instigator.IsHumanControlled() && IsPlayingTimeoutIdleAnim() )
	{
		blendTime = 0.15;
	}
	else
	{
		blendTime = 0.05;
	}

	PlayWeaponAnim( WPNANIM_Reload, 1.0, blendTime );
	//PlayOwnedSound( ReloadSound );
}


///////////////////////////////////////////////////////////////////////////////
// DoPunch
//
simulated function bool DoPunch()
{
	if ( !CanPunch() )
	{
		return false;
	}

	GotoState( 'Punching' );
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// CanPunch
//
simulated event bool CanPunch()
{
	return IsIdle();
}


///////////////////////////////////////////////////////////////////////////////
// AnimNotifyPunch
//
simulated event AnimNotifyPunch()
{
	// Only do this on client owner.
	if ( Instigator.IsLocallyControlled() )
	{
		SASPawn( Instigator ).HitPunchTarget();
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayIdleAnim
//
// Tween to weapon idle anim
simulated function PlayIdleAnim()
{
	SASPlayIdleAnim( 0.05 );
}

///////////////////////////////////////////////////////////////////////////////
// SASPlayIdleAnim
//
// Tween to weapon idle anim
simulated function SASPlayIdleAnim(
	float aBlendTime )
{
	if ( Instigator == None )
	{
		return;
	}

	if ( mbToggleSighted && mbSighted )
	{
		PlayWeaponAnim( WPNANIM_SightedIdle, 1.0, aBlendTime );
		//TweenWeaponAnim( WPNANIM_SightedIdle, 0.05 );
	}
	else
	{
		TweenWeaponAnim( WPNANIM_UnsightedFire, aBlendTime );
	}
}


///////////////////////////////////////////////////////////////////////////////
// TweenToAimed
//
simulated function TweenToAimed()
{
	local name	anim;
	local float	frame, rate;
	local float blendTime;

	GetAnimParams( 0, anim, frame, rate );

	if ( IsAnimating() && (anim == ANIMNAME_FromSighted) )
	{
		frame = 1.0 - frame;
	}
	else
	{
		frame = 0.0;
	}

	// If currently playing a timeout idle anim, give a little bit of
	// time to blend out to reduce snapping.
	if ( Instigator.IsHumanControlled() && IsPlayingTimeoutIdleAnim() )
	{
		blendTime = 0.1;
	}

	PlayWeaponAnim( WPNANIM_MoveToSighted, AIMANIM_RATE, blendTime, frame );
}


///////////////////////////////////////////////////////////////////////////////
// TweenToUnaimed
//
simulated function TweenToUnaimed()
{
	local name	anim;
	local float	frame, rate;

	GetAnimParams( 0, anim, frame, rate );

	if ( IsAnimating() && (anim == ANIMNAME_ToSighted) )
	{
		frame = 1.0 - frame;
	}
	else
	{
		frame = 0.0;
	}

	if ( bChangeWeapon )
	{
		rate = UNAIMANIM_RATE_FAST;
	}
	else
	{
		rate = AIMANIM_RATE;
	}

	PlayWeaponAnim( WPNANIM_MoveFromSighted, rate, 0.0, frame );
}


///////////////////////////////////////////////////////////////////////////////
// SetPlayerFOVToUnaimed
//
simulated function SetPlayerFOVToUnaimed()
{
	local PlayerController PC;

	PC = PlayerController( Instigator.Controller );
	if ( PC != None )
	{
		PC.SetFOV( PC.Default.FovAngleDegs );
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetPlayerFOVToAimed
//
simulated function SetPlayerFOVToAimed()
{
	local PlayerController PC;

	PC = PlayerController( Instigator.Controller );
	if ( PC != None )
	{
		PC.SetFOV( PC.Default.FovAngleDegs + mSightedFovAdjust );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAimedViewTransition
//
simulated function DoAimedViewTransition(
	bool abToAimed )
{
	local PlayerController	PC;
	local name				anim;
	local float				frame, rate;
	local float				FOVAlpha;

	PC = PlayerController( Instigator.Controller );
	if ( PC != None )
	{
		GetAnimParams( 0, anim, frame, rate );
		frame = FClamp( frame, 0.0, 1.0 );
		if ( !abToAimed )
		{
			frame = 1.0 - frame;
		}

		if ( frame >= mMoveToSightedSwitchFrame )
		{
			if ( mMoveToSightedSwitchFrame < 1.0 )
			{
				FOVAlpha = (frame - mMoveToSightedSwitchFrame) / (1.0 - mMoveToSightedSwitchFrame);
			}
			else
			{
				FOVAlpha = 1.0;
			}

			SetAimedView( FOVAlpha );
		}
		else
		{
			SetUnaimedView();
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetUnaimedView
//
simulated function SetUnaimedView()
{
	local PlayerController	PC;

	if ( Instigator.Controller == None )
	{
		return;
	}

	// Only switch mesh/change FoV for players
	PC = PlayerController( Instigator.Controller );
	if ( PC == None )
	{
		return;
	}

	PC.SetFOV( PC.Default.FovAngleDegs );

	DeactivateScope();
}


///////////////////////////////////////////////////////////////////////////////
// SetAimedView
//
simulated function SetAimedView(
	float	aTransitionAlpha )
{
	local PlayerController	PC;

	if ( Instigator.Controller == None )
	{
		return;
	}

	// Only switch mesh/change FoV for players
	PC = PlayerController( Instigator.Controller );
	if ( PC == None )
	{
		return;
	}

	PC.SetFOV( PC.Default.FovAngleDegs + (aTransitionAlpha * mSightedFovAdjust) );
}

///////////////////////////////////////////////////////////////////////////////
// Render2DOverlays
//
// Render HUD elements for this weapon (e.g. scope view).
simulated event Render2DOverlays(
	Canvas	aCanvas )
{
	if ( IsZoomed() )
	{
		// Draw scope view
		mScope.RenderOverlays( aCanvas );
	}
}


///////////////////////////////////////////////////////////////////////////////
// RenderOverlays
//
// Draw first person view of weapon. Called every frame when in first person
// view.
// Also updates the location of the first person weapon.
// Note - the weapon rotation is updated in the native tick function.
simulated event RenderOverlays(
	Canvas	aCanvas )
{
	local float					drawFOV;
	local SASPlayerController	PC;
	local Vector				ofs;

	local Vector				cameraloc;
	local Rotator				camerarot;

	local Actor					camera;

	PC = SASPlayerController( Level.GetLocalPlayerController() );
	PC.PlayerCalcView(camera, cameraloc, camerarot);
	
	mCameraActor = camera;
	if (mLaserProjector != None)
	{
		mLaserProjector.SetAttachBone(mCameraActor, 'self');
		mLaserProjector.mAttachActor = mCameraActor;
		mLaserProjector.mRelativeLocation = cameraloc;
		mLaserProjector.mRelativeRotation = camerarot;
	}
	
	if ( Instigator == None )
	{
		return;
	}

	// Update draw position

	if ( IsZoomed() )
	{
		// JS I've moved this in here because there's a setlocation in the other one anyway.

		// TODO: Move this to native tick
		ofs = Instigator.Location + Instigator.CalcDrawOffset( self );
		SetLocation ( ofs );

		// If gun light is active then draw the weapon ( but with a FOV of 0 so it
		// doesnt actually render - this forces the torch projector to update too.
		if ( IsGunLightOn() )
		{
			aCanvas.DrawActor( self, false, true, 0 );
		}
		if ( IsGunLaserOn() )
		{
			aCanvas.DrawActor( self, false, true, 0 );
		}		
	}
	else
	{
		// Draw non-scope view
		if ( PC != None )
		{
			if ( DisplayFOV > 0 )
			{
				drawFOV = PC.FovAngleDegs + (DisplayFOV - PC.DefaultFOV);
			}
			else
			{
				drawFOV = PC.FovAngleDegs;
			}

			// GP: reapply weapon view offset.
			cameraloc += (PlayerViewOffset >> Rotation);

			// JS: let's do the weapon bob right here for simplicity (and, sadly, duplication of code)
			cameraloc += GetInertialBobOffset() * BobDamping;

			// Add collision push back.
			cameraLoc -= Vector(cameraRot) * mCollisionPushBackCurDist;

			SetLocation(cameraloc);
			//SetRotation(camerarot);

			// JS can switch off the gun for Steve's debug purposes
			if (PC.Show1stPersonGun)
				aCanvas.DrawActor( self, false, true, drawFOV );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// DrawCenteredCrossHair
//
/*simulated function DrawCenteredCrossHair(
	Canvas	aCanvas )
{
	local float XLength;

	if ( CrossHair == None )
	{
		return;
	}

	XLength = 32.0;
	aCanvas.bNoSmooth = false;
	aCanvas.SetPos( 0.503 * (aCanvas.ClipX - XLength), 0.504 * (aCanvas.ClipY - XLength) );
	aCanvas.Style = ERenderStyle.STY_Translucent;
	aCanvas.SetDrawColor( 255, 255, 255 );
	aCanvas.DrawTile( CrossHair, XLength, XLength, 0, 0, 128, 128 );
	aCanvas.bNoSmooth = true;
	aCanvas.Style = Style;
}
*/

///////////////////////////////////////////////////////////////////////////////
// DrawProjectedCrossHair
//
/*simulated function DrawProjectedCrossHair(
	Canvas	aCanvas )
{
	local float				XLength;
	local PlayerController	PC;
	local vector			worldPos;
	local vector			screenPos;

	if ( CrossHair == None )
	{
		return;
	}

	PC = PlayerController( Instigator.Controller );
	if ( PC == None )
	{
		return;
	}

	worldPos =
		Instigator.Location +
		Instigator.CalcDrawOffset( self ) +
		(Vector( Rotation ) * 1000.0);

	screenPos = PC.Player.Console.WorldToScreen(worldPos );

	XLength = 32.0;
	aCanvas.bNoSmooth = false;
	aCanvas.SetPos( screenPos.X - (0.503 * XLength), screenPos.Y - (0.504 * XLength) );
	aCanvas.Style = ERenderStyle.STY_Translucent;
	aCanvas.SetDrawColor( 255, 0, 0 );
	aCanvas.DrawTile( CrossHair, XLength, XLength, 0, 0, 32, 32 );
	aCanvas.bNoSmooth = true;
	aCanvas.Style = Style;
}
*/


///////////////////////////////////////////////////////////////////////////////
//
// returns TRUE if this weapon is pointing at the specified target
function bool isPointingAt (SASPawn target)
{
	local vector traceStart;
	local vector traceEnd;

	traceStart = Location;

	switch (mCategory)
	{
		case WPNCAT_Knife:
			traceEnd = traceStart + (Vector (Rotation) * THREATENRANGE_Knife);
			break;

		case WPNCAT_Grenade:
			traceEnd = traceStart + (Vector (Rotation) * THREATENRANGE_Grenade);
			break;

		case WPNCAT_Primary:
		case WPNCAT_Special:
			traceEnd = traceStart + (Vector (Rotation) * THREATENRANGE_Primary);
			break;

		case WPNCAT_Secondary:
			traceEnd = traceStart + (Vector (Rotation) * THREATENRANGE_Secondary);
			break;

		case WPNCAT_None:
		default:
			return false;
	}

	return target.CylinderCollisionTest (traceStart, traceEnd, STANCE_Standing);
} // isPointingAt

///////////////////////////////////////////////////////////////////////////////
// getThreatenedPawn
//
// Is this weapon threatening a pawn?
//
// Check for pointing gun at other pawns and return first hit
function Pawn GetThreatenedPawn (
	int		aRelevantPawnTypes )
{
	local Pawn			hitPawn;
	local vector		hitLocation;
	local vector		traceStart;
	local vector		traceEnd;

	traceStart = Location;

	switch ( mCategory )
	{
		case WPNCAT_Knife:
			traceEnd = traceStart + (Vector(Rotation) * THREATENRANGE_Knife);
			break;

		case WPNCAT_Grenade:
			traceEnd = traceStart + (Vector(Rotation) * THREATENRANGE_Grenade);
			break;

		case WPNCAT_Primary:
		case WPNCAT_Special:
			traceEnd = traceStart + (Vector(Rotation) * THREATENRANGE_Primary);
			break;

		case WPNCAT_Secondary:
			traceEnd = traceStart + (Vector(Rotation) * THREATENRANGE_Secondary);
			break;

		case WPNCAT_None:
		default:
			return None;
	}

	// Seek first pawn hit by trace.
	hitPawn = PawnTrace(
		aRelevantPawnTypes,
		hitLocation,
		traceEnd,
		traceStart,
		true,
		TIB_Yes,
		true );

	return hitPawn;
} // getThreatenedPawn

///////////////////////////////////////////////////////////////////////////////
// CheckPawnThreatened
//
// Is this weapon threatening a pawn?
//
// Check for pointing gun at hostages and send a message to hostage
// if in line of fire.
function CheckPawnThreatened(
	int		aRelevantPawnTypes )
{
	local Pawn			hitPawn;
	local float			duration;

	hitPawn = getThreatenedPawn (aRelevantPawnTypes);

	if ( hitPawn != None )
	{
		switch ( hitPawn.mPawnType )
		{
		case PAWN_Soldier:
			// Soldiers tell other soldiers to get out of the way.
			if ( Instigator.mPawnType == PAWN_Soldier )
			{
				if ( (hitPawn == mPointedAtPawn) && (mPointedAtStartTime != 0.0) )
				{
					duration = Level.TimeSeconds - mPointedAtStartTime;

					// pointing at same actor for a while now
					//
					if ( (duration > 0.2f) && (mPointedAtStep == 0) )
					{
						// player feedback
						//
						// 'fscking get out of the way'
						mPointedAtStep ++;
					}
					else if ( (duration > 0.4f) && (mPointedAtStep == 1) )
					{
						// 2nd shout
						//
						if ( (hitPawn.Controller != None)
							&& (hitPawn.Controller.mType == CONTROLLER_AiSoldier) )
						{
							SASSoldierController( hitPawn.Controller ).WeaponPointedAt( Instigator );
						}

						mPointedAtStep++;
					}
				}
			}
			break;
		}
	}

	if( hitPawn != mPointedAtPawn )
	{
		// new/no gagdy threatened. make a note!
		//
		mPointedAtStartTime = Level.TimeSeconds;
		mPointedAtStep		= 0;
	}
	mPointedAtPawn = hitPawn;
}


///////////////////////////////////////////////////////////////////////////////
// IsPlayingTimeoutIdleAnim
//
// Returns true if currently playing anim is a timout idle.
simulated function bool IsPlayingTimeoutIdleAnim()
{
	local int	i, numTimeouts;
	local name	anim;
	local float	frame, time;

	numTimeouts = mIdleAnims.Length;
	if ( (numTimeouts > 0) && IsAnimating( 0 ) )
	{
		GetAnimParams( 0, anim, frame, time );

		if ( anim != '' )
		{
			for ( i = 0; i < numTimeouts; ++i )
			{
				if ( anim == mIdleAnims[i] )
				{
					return true;
				}
			}
		}
	}

	return false;
}

//::simulated function ActivateScope()
//::{
//::	if ( mScope != None )
//::	{
//::		mScope.Activate ();
//::	}
//::}

simulated function DeactivateScope ()
{
	// end scope when reloading/changing weapon
	if ( mScope != None )
	{
		mScope.Deactivate ();
	}
}

simulated function PlayTimeoutIdleAnim();
simulated function ResetTimeoutIdle();


//-----------------------------------------------------------------------------
// States

///////////////////////////////////////////////////////////////////////////////
// STATE Idle
//
state Idle
{
	///////////////////////////////////////////////////////////////////////////////
	// BeginState
	//
	simulated event BeginState()
	{
		mFireAnimStartFrame = 0.0;
		mbPlayedClipEmptyAnim = false;
		SetTimer( 0.0, false );

		if ( Instigator.IsHumanControlled() && (!mbToggleSighted || !mbSighted) )
		{
			// Enable tick to check for player moving or not - needed for
			// timing of playing spot idles.
			mPrevInstigatorRot = Instigator.GetViewRotation();
			Enable( 'Tick' );
		}
		else
		{
			Disable('Tick');
		}

		// If have scope, make sure it's in the right state.
		if ( mScope != None )
		{
			if ( mbSighted != IsZoomed() )
			{
				if ( mbSighted )
				{
					mScope.Activate();
				}
				else
				{
					mScope.Deactivate();
				}
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// EndState
	//
	simulated event EndState()
	{
		SetTimer( 0.0, false );
		Disable('Tick');
	}


	///////////////////////////////////////////////////////////////////////////////
	// IsIdle
	//
	simulated event bool IsIdle()
	{
		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// ForceReload
	//
	simulated function ForceReload()
	{
		ServerForceReload();
	}


	///////////////////////////////////////////////////////////////////////////////
	// ServerForceReload
	//
	function ServerForceReload()
	{
		if ( AmmoType.HasAmmo() )
		{
			GotoState('Reloading');
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// AnimEnd
	//
	simulated event AnimEnd(
		int aChannel )
	{
		if ( Instigator.IsHumanControlled() && IsPlayingTimeoutIdleAnim() )
		{
			// Set time before playing next timeout idle anim.
			ResetTimeoutIdle();
		}

		// Play looping idle animation
		SASPlayIdleAnim( 0.0 );
	}


	///////////////////////////////////////////////////////////////////////////////
	// PlayTorchToggleAnim
	//
	simulated function PlayTorchToggleAnim()
	{
		ResetTimeoutIdle();

		if ( mbSighted )
		{
			if ( HasAnim( ANIMNAME_SightedTorchToggle ) )
			{
				PlayWeaponAnim( WPNANIM_SightedTorchToggle, 1.0, 0.1 );
			}
		}
		else
		{
			if ( HasAnim( ANIMNAME_UnsightedTorchToggle ) )
			{
				PlayWeaponAnim( WPNANIM_UnsightedTorchToggle, 1.0, 0.1 );
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// PlayLaserToggleAnim
	//
	simulated function PlayLaserToggleAnim()
	{
		ResetTimeoutIdle();
		if ( mbSighted )
		{
			if ( HasAnim( ANIMNAME_SightedTorchToggle ) )
			{
				PlayWeaponAnim( WPNANIM_SightedLaserToggle, 1.0, 0.1 );
			}
		}
		else
		{
			if ( HasAnim( ANIMNAME_UnsightedTorchToggle ) )
			{
				PlayWeaponAnim( WPNANIM_UnsightedLaserToggle, 1.0, 0.1 );
			}
		}
	}
	///////////////////////////////////////////////////////////////////////////////
	// PutDown
	//
	simulated function bool PutDown()
	{
		if ( mbSighted )
		{
			bChangeWeapon = true;
			GotoState( 'MoveToUnaimed' );
		}
		else
		{
			GotoState( 'DownWeapon' );
		}
		return true;
	}


	///////////////////////////////////////////////////////////////////////////////
	// MoveOutOfView
	//
	// Put weapon down without changing weapon (waits in OutOfView state until 
	// MoveIntoView is called.
	simulated function MoveOutOfView()
	{
		GotoState( 'MovingOutOfView' );
	}


	///////////////////////////////////////////////////////////////////////////////
	// PlayTimeoutIdleAnim
	//
	simulated function PlayTimeoutIdleAnim()
	{
		// play the next spot idle anim as decided when we decided to wait
		PlayAnim( mIdleAnims[mNextIdleAnim], 1.0, 0.2 );
	}


	///////////////////////////////////////////////////////////////////////////////
	// ResetTimeoutIdle
	//
	simulated function ResetTimeoutIdle()
	{
		// Reset time before playing timeout idle anim. (only on player owned weapons
		// and not in sighted mode).
		if (	Instigator != None && 
				Instigator.IsHumanControlled() && 
				(!mbToggleSighted || !mbSighted) )
		{
			// pick an anim
			mNextIdleAnim = rand(mIdleAnims.Length);
			SetTimer( mIdleAnimTimes[mNextIdleAnim] * RandRange( 0.8, 1.2 ), false );
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Tick
	//
	// Should only be occuring on player owned weapons - used for checking if player
	// is moving or not (so we know if to do timout idle anims or not).
	simulated event Tick(
		float	aDeltaSeconds )
	{
		local Rotator	viewRot, rotDiff;

		if ( Instigator == None )
		{
			return;
		}

		viewRot = Instigator.GetViewRotation();
		if ( viewRot.Yaw > 32767 )
		{
			viewRot.Yaw = 65535 - viewRot.Yaw;
		}
		if ( viewRot.Pitch > 32767 )
		{
			viewRot.Pitch = 65535 - viewRot.Pitch;
		}
		rotDiff = viewRot - mPrevInstigatorRot;
		mPrevInstigatorRot = viewRot;

		if ( !SASPawn( Instigator ).IsStationary()
			|| ((Square( rotDiff.Yaw ) + Square( rotDiff.Pitch )) > Square( 8000.0 * aDeltaSeconds )) )
		{
			// Turn off timeout anim timer while moving.
			SetTimer( 0.0, false );

			// If currently playing a timeout idle, do slow blend out.
			if ( IsPlayingTimeoutIdleAnim() )
			{
				SASPlayIdleAnim( 0.35 );
			}
		}
		else
		{
			// Reset timer before playing timeout idle.
			if ( TimerRate == 0.0 )
			{
				ResetTimeoutIdle();
			}
		}
	}


	///////////////////////////////////////////////////////////////////////////////
	// Timer
	//
	simulated event Timer()
	{
		// Fire off timeout idle anim.
		if (	Instigator != None && 
				SASPawn( Instigator ).IsStationary() &&
				mCollisionPushBackCurDist < 4.0 )
		{
			PlayTimeoutIdleAnim();
		}
		else
		{
			ResetTimeoutIdle();
		}
	}


Begin:

	bPointing = false;

	// Clip empty?
	if ( NeedsToReload() && AmmoType.HasAmmo() )
	{
		// AI controlled pawns are notified of empty clip to instigate correct 
		// behavioral response, players just auto-reload.
		if ( !Instigator.IsHumanControlled() )//&&
			// !SASAIController( Instigator.Controller ).mbCanFireEmpty )
		{
			SASAIController( Instigator.Controller ).NotifyClipEmpty();
		}
		else
		{
			if ( PlayerCanAutoReload() )
			{
				GotoState( 'Reloading' );
			}
		}
	}

	// If out of ammo then switch to best weapon with ammo.
	if (	!AmmoType.HasAmmo() && 
			(!Instigator.IsHumanControlled() || PlayerCanAutoReload() || IsA( 'SASGrenadeWeapon' ) ) )
	{
		Instigator.Controller.SwitchToBestWeapon();
	}

	if ( Instigator.PressingFire() )
	{
		Fire( 0.0 );
	}
	if ( Instigator.PressingAltFire() )
	{
		AltFire( 0.0 );
	}

	if ( mNumInMag > 0 )
	{
		// Tell the AI that weapon is ready to fire.
		Instigator.Controller.WeaponReadyToFire();
	}

	PlayIdleAnim();
}


////////////////////////////////////////////////////////////////////////////////
// SetCutoutTimerRate
//
// used in ClientFiring & NormalFiring states
simulated function SetCutoutTimerRate ()
{
	mbCanCutoutFiringEarly = false;

	// Finish state after fire rate time if clip not empty.
	if ( mNumInMag > 0 || !UsesAmmo)
	{
		if (mFireMode == FIREMODE_Burst)
			SetTimer( 60.0 / mBurstsPerMinuteBurstMode, false );
		else
			SetTimer( 60.0 / mRoundsPerMinute, false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetNextFireAnimStartFrame
//
simulated function SetNextFireAnimStartFrame()
{
	local name	anim;
	local float	frame, rate;

	if ( Instigator.IsHumanControlled() )
	{
		GetAnimParams( 0, anim, frame, rate );
		if ( (frame < mRepeatFireAnimStartFrame) || (frame > mRepeatFireAnimInterruptMax) )
		{
			mFireAnimStartFrame = 0.0;
		}
		else
		{
			mFireAnimStartFrame = mRepeatFireAnimStartFrame;
		}
	}
	else
	{
		mFireAnimStartFrame = 0.0;
	}
}

///////////////////////////////////////////////////////////////////////////////
// STATE NormalFire
//
// State entered when firing begins.
state NormalFire
{
	event BeginState()
	{
		mbCanCutoutFiringEarly	= false;
		Disable( 'Tick' );
	}

	event EndState()
	{
		StopFiringTime = Level.TimeSeconds;
		if ( Instigator != None )
		{
			Instigator.Controller.StopFiring();
		}
		Disable( 'Tick' );
	}

	function Fire(
		float aValue )
	{
		if ( mbCanCutoutFiringEarly )
		{
			SetNextFireAnimStartFrame();

			// AI pawns switch to reloading when clip empty.
			Global.Fire( aValue );
		}
	}

	event bool IsInFiringState()
	{
		return true;
	}

	simulated event bool IsIdle()
	{
		if ( mbCanCutoutFiringEarly && !NeedsToReload() )
		{
			return true;
		}

		return false;
	}

	function AltFire(
		float aValue );


	simulated function ToggleMode()
	{
		if ( mbCanCutoutFiringEarly )
		{
			Global.ToggleMode();
		}
	}

	event Tick(
		float	aDeltaTime )
	{
		// If human controlled and have empty clip then should monitor fire button being 
		// released to allow instant exit from state.
		if ( (Instigator.Controller.mType == CONTROLLER_Player) && (mNumInMag < 1) && UsesAmmo )
		{
			if ( !Instigator.PressingFire() )
			{
				Finish();
			}
		}
	}

	event Timer()
	{
		if ( (mFireMode == FIREMODE_Auto) && Instigator.PressingFire() )
		{
			SetNextFireAnimStartFrame();

			Finish();
			CheckAnimating();
		}
		else
		{
			mbCanCutoutFiringEarly = true;
			if ( Instigator != None )
			{
				Instigator.Controller.StopFiring();
			}
		}
	}

	simulated function ForceReload()
	{
		ServerForceReload();
	}

	function ServerForceReload()
	{
		if ( mbCanCutoutFiringEarly && AmmoType.HasAmmo() )
		{
			GotoState('Reloading');
		}
	}

	function AnimEnd(
		int aChannel )
	{
		mFireAnimStartFrame = 0.0;
		Finish();
		CheckAnimating();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
		{
			Warn( self$" stuck in NormalFire and not animating!" );
		}
	}

	// GP: Overriding serverfire/alfire - not sure what will happen to multiplayer!

	function ServerFire()
	{
		Global.ServerFire();
		//bForceFire = true;
	}

	function ServerAltFire()
	{
		Global.ServerAltFire();
		//bForceAltFire = true;
	}

Begin:
	mFireAnimStartFrame		= 0.0;

	if ( Instigator != None )
	{
		SASPawn(Instigator).NotifyPreWeaponFire();

		// If human controlled and have empty clip then should monitor fire button being 
		// released to allow instant exit from state.
		if ( (Instigator.Controller.mType == CONTROLLER_Player) && (mNumInMag < 1) && UsesAmmo )
		{
			Enable( 'Tick' );
		}
	}
}

////////////////////////////////////////////////////////////////////////////////
// STATE ClientFiring
//
state ClientFiring
{
	simulated event BeginState()
	{
		mbCanCutoutFiringEarly	= false;
		Disable( 'Tick' );
	}

	simulated event EndState()
	{
		StopFiringTime = Level.TimeSeconds;
		if ( Instigator != None && Instigator.Controller != None )
		{
			Instigator.Controller.StopFiring();
		}
		Disable( 'Tick' );
	}

	simulated function Fire(
		float aValue )
	{
		if ( mbCanCutoutFiringEarly )
		{
			SetNextFireAnimStartFrame();

			// AI pawns switch to reloading when clip empty.
			Global.Fire( aValue );
		}
	}

	simulated function ToggleMode()
	{
		if ( mbCanCutoutFiringEarly )
		{
			Global.ToggleMode();
		}
	}

	

	event Tick(
		float	aDeltaTime )
	{
		// If human controlled and have empty clip then should monitor fire button being 
		// released to allow instant exit from state.
		if ( (Instigator.Controller.mType == CONTROLLER_Player) && (mNumInMag < 1) && UsesAmmo )
		{
			if ( !Instigator.PressingFire() )
			{
				ClientFinish();
			}
		}
	}

	simulated event Timer()
	{
		if ( (mFireMode == FIREMODE_Auto) && Instigator.PressingFire() )
		{
			SetNextFireAnimStartFrame();
			ClientFinish();
			CheckAnimating();
		}
		else
		{
			mbCanCutoutFiringEarly = true;
			if ( Instigator != None )
			{
				Instigator.Controller.StopFiring();
			}
		}
	}

	simulated function AnimEnd(
		int aChannel )
	{
		mFireAnimStartFrame = 0.0;
		ClientFinish();
		CheckAnimating();
	}

Begin:
	mFireAnimStartFrame		= 0.0;

	if ( Instigator != None )
	{
		// If human controlled and have empty clip then should monitor fire button being 
		// released to allow instant exit from state.
		if ( (Instigator.Controller.mType == CONTROLLER_Player) && (mNumInMag < 1) && UsesAmmo )
		{
			Enable( 'Tick' );
		}
	}
}


/*state EndFiring
{
	simulated event BeginState()
	{
		PlayEndFiring();
	}

	function AnimEnd(
		int aChannel )
	{
		Finish();
		CheckAnimating();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
		{
			Warn( self$" stuck in EndFiring and not animating!" );
		}
	}

Begin:
}
*/

///////////////////////////////////////////////////////////////////////////////
// STATE Active
//
// Bring newly active weapon up.
// The weapon will remain in this state while its selection animation is being played
// (as well as any postselect animation).
// While in this state, the weapon cannot be fired.
state Active
{
	ignores ToggleMode;

	simulated event BeginState()
	{
		Super.BeginState();

		// Re-evaluate inertia spring coefficients due to pawn strength
		if ( SASPawn( Instigator ) != None )
		{
			RecalcInertia();
		}

		// Reset burst firing timer when new weapon brought up.
		if ( Instigator.Controller.mType != CONTROLLER_Player )
		{
			SASAIController( Instigator.Controller ).InitBurstFiringParams(); 
		}

		// If weapon will be colliding with something when brought up then 
		// move straight into MoveOutOfView state.
	}

	///////////////////////////////////////////////////////////////////////////////
	// MoveOutOfView 
	//
	// Put weapon down without changing weapon (waits in OutOfView state until 
	// MoveIntoView is called.
	simulated function MoveOutOfView()
	{
		GotoState( 'MovingOutOfView' );
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE DownWeapon
//
// Putting down weapon in favour of a new one. No firing in this state
state DownWeapon
{
	ignores ToggleMode;

	simulated event BeginState()
	{
		local name	anim;
		local float	frame,
					rate;

		OldWeapon = None;
		bChangeWeapon = false;
		bMuzzleFlash = false;

		// If already playing down anim then either leave it if its still running or end state
		// if its stopped.
		GetAnimParams( 0, anim, frame, rate );
		if ( anim == ANIMNAME_Deselect )
		{
			if ( !IsAnimating() )
			{
				AnimEnd( 0 );
			}
		}
		else
		{
			// Play down anim.
			TweenDown();
		}

		if ( mbToggleSighted && mbSighted && (PlayerController( Instigator.Controller ) != None) )
		{
			Enable( 'Tick' );
		}
		else
		{
			Disable( 'Tick' );
		}

		mbSighted = false;

		DeactivateScope ();

		// Turn off torch.
		if ( mbHasTorch )
		{
			SASPawn( Instigator ).SetGunLight( false );
		}
		// Turn off laser.
		if ( mbHasLaser )
		{
			SASPawn( Instigator ).SetGunLaser( false );
		}
	}

	simulated event EndState()
	{
		Disable( 'Tick' );
	}

	///////////////////////////////////////////////////////////////////////////////
	// MoveOutOfView 
	//
	// Put weapon down without changing weapon (waits in OutOfView state until 
	// MoveIntoView is called.
	simulated function MoveOutOfView()
	{
		Instigator.PendingWeapon = None;
		GotoState( 'MovingOutOfView' );
	}

	simulated event AnimEnd(
		int aChannel )
	{
		Pawn( Owner ).ChangedWeapon();

		SetPlayerFOVToUnaimed();

		Disable( 'Tick' );
	}

	simulated event Tick(
		float aDeltaTime )
	{
		DoAimedViewTransition( false );
	}
}

simulated function bool IsMovedOutOfView()
{
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// STATE MovingOutOfView
//
// Like DownWeapon state but doesnt switch to new weapon on completion - instead
// waits for MoveIntoView function call.
state MovingOutOfView
{
	ignores ServerForceReload,
			ClientForceReload,
			Fire,
			AltFire,
			ToggleMode,
			Reload,
			MoveOutOfView;

	simulated function bool IsMovedOutOfView()
	{
		return true;
	}

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event BeginState()
	{
		Super.BeginState();

		mbMoveOutOfView = false;
	
		if ( mbSighted && (PlayerController( Instigator.Controller ) != None) )
		{
			SetUnaimedView();
		}
		mbSighted = false;

		// Turn off scope.
		if ( mScope != None && mScope.mbActive )
		{
			mScope.Deactivate();
		}

		PlayMoveOutOfView();
	}

	simulated event MoveIntoView()
	{
		bWeaponUp = false;
		PlayMoveIntoView();
		GotoState( 'Active' );
	}

	simulated event AnimEnd(
		int aChannel )
	{
		SetPlayerFOVToUnaimed();
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE Reloading
//
// Carries out reload animation and prevents other weapon actions occuring
// during reloading. Exits when reload animation ends.
state Reloading
{
	ignores ServerForceReload,
			ClientForceReload,
			Fire,
			AltFire,
			ToggleMode,
			Reload;

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event BeginState()
	{
		mbIsReloading = true;

		if ( !bForceReload )
		{
			if ( Role < ROLE_Authority )
			{
				ServerForceReload();
			}
			else
			{
				ClientForceReload();
			}
		}

		DeactivateScope ();

		// Remove ammo from clip immediately. This is required so that AI calls to 
		// NeedsToReload return true when in process of reloading.
		if ( Role == ROLE_Authority )
		{
			DecrementAmmo(mNumInMag);
		}
		mNumInMag = 0;

		SetUnaimedView();
		mbSighted = false;

		bForceReload = false;
		PlayReloading();

		SASPawn( Instigator ).PlayReloading();

		// Squad play 'mag change' speech. For players this speech is delayed incase 
		// player chooses to change weapon instead of carrying out reload.
		SetTimer( 0.0, false );
		if (	(Instigator.mPawnType == PAWN_Soldier) &&
				(Instigator.Controller != None) )
		{
			// Only play for primary and secondary weapons.
			switch ( mCategory )
			{
			case WPNCAT_Primary:
			case WPNCAT_Secondary:
				if ( Instigator.Controller.mType == CONTROLLER_Player )
				{
					// For players, set timer to play speech after 1 second.
					SetTimer( 1.0, false );
				}
				else
				{
					// AI play immediately.
					SASPawn( Instigator ).PlaySpeech( SPEECH_SquadMagChange );
				}
				break;
			}
		}

		// Reset burst firing timer when reloading weapon.
		if ( Instigator.Controller.mType != CONTROLLER_Player )
		{
			SASAIController( Instigator.Controller ).InitBurstFiringParams(); 
		}
	}

	simulated event EndState()
	{
		mbIsReloading = false;

		if ( mbToggleSighted && mbSighted )
		{
			// Snap into aimed view
			SetAimedView( 1.0 );
		}

		SetTimer( 0.0, false );
	}


	// Timer used for delayed player 'mag change' speech.
	simulated event Timer()
	{
		// Only players should play this speech and only if there are other squad members alive.
		if (	(Instigator.mPawnType == PAWN_Soldier) && 
				(Instigator.Controller != None) &&
				(Instigator.Controller.mType == CONTROLLER_Player) &&
				(SASPlayerController( Instigator.Controller ).mSquadManager.GetNumLiveSquadMembers() > 1) )
		{
			SASPawn( Instigator ).PlaySpeech( SPEECH_SquadMagChange );
		}
		SetTimer( 0.0, false );
	}


	simulated function bool PutDown()
	{
		GotoState( 'DownWeapon' );
		return true;
	}

	simulated event bool CanPunch()
	{
		return true;
	}

	///////////////////////////////////////////////////////////////////////////////
	// MoveOutOfView 
	//
	// Put weapon down without changing weapon (waits in OutOfView state until 
	// MoveIntoView is called.
	simulated function MoveOutOfView()
	{
		GotoState( 'MovingOutOfView' );
	}

	simulated function AnimEnd(
		int aChannel )
	{
		GiveNewMagazine();

		if ( Role < ROLE_Authority )
		{
			ClientFinish();
		}
		else
		{
			Finish();
		}
		CheckAnimating();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
		{
			Warn( self$" stuck in Reloading and not animating!" );
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// StopReloading
	//
	simulated function StopReloading()
	{
		if ( Role < ROLE_Authority )
		{
			ClientFinish();
		}
		else
		{
			Finish();
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE MoveToAimed
//
// State during moving weapon from unaimed to aimed position.
state MoveToAimed
{
	function ServerForceReload() {}
	simulated function ClientForceReload() {}

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event BeginState()
	{
		mbSighted = true;
		TweenToAimed();

		Enable( 'Tick' );
	}

	simulated event EndState()
	{
		// Ensure we end in fully aimed view
		SetAimedView( 1.0 );

		// Ensure scope is on if have one.
		if ( mScope != None )
		{
			mScope.Activate();
		}

		Disable( 'Tick' );
	}

	simulated function bool PutDown()
	{
		bChangeWeapon = true;
		return true;
	}

	simulated event Tick(
		float aDeltaSeconds )
	{
		DoAimedViewTransition( true );
	}

	simulated event AnimEnd(
		int	aChannel )
	{
		if ( Role < ROLE_Authority )
		{
			ClientFinish();
		}
		else
		{
			Finish();
		}

		SetPlayerFOVToAimed();

		CheckAnimating();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
		{
			Warn( self$" stuck in MoveToAimed and not animating!" );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// STATE MoveToUnaimed
//
// State during moving weapon from aimed to unaimed position.
state MoveToUnaimed
{
	function ServerForceReload() {}
	simulated function ClientForceReload() {}
	simulated function AltFire( float Value ) {}

	simulated function Fire(
		float	aValue )
	{
		if ( NeedsToReload() && HasAmmo() )
		{
			return;
		}
		
		GotoState( 'MoveToAimed' );
	}

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event BeginState()
	{
		mbSighted = false;
		TweenToUnaimed();

		Enable( 'Tick' );
	}

	simulated event EndState()
	{
		// Ensure we end in unaimed view
		SetUnaimedView();

		Disable( 'Tick' );
	}

	simulated event Tick(
		float aDeltaSeconds )
	{
		DoAimedViewTransition( false );
	}

	simulated function bool PutDown()
	{
		bChangeWeapon = true;
		return true;
	}

	simulated event AnimEnd(
		int	aChannel )
	{
		if ( Role < ROLE_Authority )
		{
			ClientFinish();
		}
		else
		{
			Finish();
		}

		SetPlayerFOVToUnaimed();

		CheckAnimating();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
		{
			Warn( self$" stuck in MoveToUnimed and not animating!" );
		}
	}
}


state Punching
{
	function ServerForceReload() {}
	simulated function ClientForceReload() {}
	simulated function AltFire( float Value ) {}

	simulated function Fire(
		float	aValue );

	function ServerFire()
	{
		bForceFire = true;
	}

	function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated event BeginState()
	{
		mbSighted = false;
		SetUnaimedView();
		DeactivateScope();

		PlayWeaponAnim( WPNANIM_Punch, 1.0 );
	}

	simulated function bool PutDown()
	{
		bChangeWeapon = true;
		return true;
	}

	simulated event AnimEnd(
		int	aChannel )
	{
		if ( Role < ROLE_Authority )
		{
			ClientFinish();
		}
		else
		{
			Finish();
		}

		CheckAnimating();
	}

	function CheckAnimating()
	{
		if ( !IsAnimating() )
		{
			Warn( self$" stuck in Punching and not animating!" );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// STATE Zooming
//
// Zoom/Unzoom state for scoped weapons.
/*
state Zooming
{
	simulated function Fire(
		float aValue );

	simulated function AltFire(
		float aValue );

	simulated function ServerAltFire()
	{
		bForceAltFire = true;
	}

	simulated function ForceReload();
	simulated function NextWeaponFunction();
	simulated function PrevWeaponFunction();

	simulated event BeginState()
	{
		if ( mScope.mbActive )
		{
			PlayerController( Instigator.Controller ).ResetFOV();
			PlayerController( Instigator.Controller ).ClientAdjustGlow( 0, vect(0,0,0) );
			//PlayAnim('scopedown2');
			//PlayOwnedSound(sound'WeaponSounds.COGassault_scopezoomout');
			mScope.Deactivate();
		}
		else
		{
			//PlayAnim('scopeup2');
			//PlayOwnedSound(sound'WeaponSounds.COGassault_scopezoomin');
			mScope.Activate();
		}

		SetTimer( 0.5,false );
	}

	event Timer()
	{
		AnimEnd( 0 );
	}

	simulated function bool IsZoomed()
	{
		return false;
	}

	simulated function bool PutDown()
	{
		bChangeWeapon = true;
		return true;
	}

	simulated function AnimEnd(
		int aChannel )
	{
		// Switch to close up FOV
		if ( mScope.mbActive )
		{
			PlayerController( Instigator.Controller ).SetFOV( mScope.mZoomedFoV );
			PlayerController( Instigator.Controller ).ClientAdjustGlow( 0.5, vect(0,255,0) );
		}

		if ( Role == ROLE_Authority )
		{
			Finish();
		}
		else
		{
			ClientFinish();
		}
	}
}
*/

////////////////////////////////////////////////////////////////////////////////
// drawDebug
//
simulated function drawDebug (
		HUD aHUD)			// HUD object which handles the drawing
{
	/*local Color wpnColour;
	local Vector dir;
	local Vector X,Y,Z, muzzleRelative;

	dir = vect (0, 0, 1);

	if (SASPlayerController (Instigator.Controller) != None)
	{
		return;
	}

	// Attempt to draw muzzle position
	if (SASWeaponAttachment (ThirdPersonActor) != None)
	{
		GetAxes (ThirdPersonActor.Rotation, X, Y, Z);
		muzzleRelative = SASWeaponAttachment (ThirdPersonActor).mMuzzleRelativeLocation;
		X = ThirdPersonActor.Location + muzzleRelative.X * X + muzzleRelative.Y * Y + muzzleRelative.Z * Z;
		wpnColour = class'Canvas'.Static.MakeColor (0, 255, 255);
		aHUD.Draw3DCylinder (X, dir, 5, 10, 12, wpnColour);

		GetAxes (GetDesiredFiringRotation (true), X, Y, Z);
		muzzleRelative = GetThirdPersonFireStart (X, Y, Z);
		wpnColour = class'Canvas'.Static.MakeColor (0, 255, 0);
		aHUD.Draw3DCylinder (muzzleRelative, dir, 5, 10, 12, wpnColour);
	} // if
	
	aHud.Draw3DLine(mDebugTraceStart, mDebugTraceEnd, class'Canvas'.Static.MakeColor ( 255, 255,   0, 255 ));
	*/
} // drawDebug

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mCategory=5
    mCollisionPushBackMaxUnsighted=32.0000000
    mCollisionPushBackMaxSighted=20.0000000
    mCollisionPushBackMaxReloading=32.0000000
    mFireLoudness=1.0000000
    mFireOffsetSide=(X=20.0000000,Y=15.0000000,Z=-5.0000000)
    mFireOffsetOverhead=(X=20.0000000,Y=2.6000000,Z=20.0000000)
    mRepeatFireAnimStartFrame=0.2000000
    mRepeatFireAnimInterruptMax=1.0000000
    UsesAmmo=true
    mSightedFovAdjust=-15.0000000
    mMoveToSightedSwitchFrame=0.8000000
    mSightedBobDamping=(X=0.1000000,Y=0.1000000,Z=0.0100000)
    mWeight=0.2000000
    mBaseStability=0.1000000
    mBaseCrouchStability=0.0800000
    mAutoLockAngleMin=600.0000000
    mAutoLockAngleMax=2500.0000000
    mShotSpreadAngleNormal=500.0000000
    mShotSpreadAngleCrouch=300.0000000
    mShotSpreadAngleModForSighted=0.6600000
    mShotSpreadAnglePenaltyForMovement=4000
    mShotSpreadAnglePenaltyModForRotation=0.0352000
    mShotSpreadAnglePenaltyDecay=1300.0000000
    mShotSpreadAngleMax=10923.0000000
    mShotSpreadAngleMaxModForSprinting=1.0000000
    mAimedShotRiseMin=50.0000000
    mAimedShotRiseMax=100.0000000
    mNormalShotRiseMin=500.0000000
    mNormalShotRiseMax=600.0000000
    mRiseTime=0.1000000
    mBurstsPerMinuteBurstMode=30.0000000
    mInertiaMaxRotOfs=0.7850000
    mSightedFireAnim="1st_Fire1"
    mUnsightedFireAnim="1st_Fire1_Ported"
    mAltFireAnim="1st_AltFire1"
    mIdleAnims[0]="1st_Idle1"
    mIdleAnims[1]="1st_Idle2"
    mIdleAnimTimes[0]=20.0000000
    mIdleAnimTimes[1]=25.0000000
    mMuzzleFlashScale=1.0000000
    mShellEjectScale=1.0000000
    mZoomFact=0.5000000
    FireVolumeMin=0.9000000
    FireVolumeMax=1.0000000
    FirePitchMin=1.0000000
    FirePitchMax=1.0000000
    mFireSounds[0]=Sound'Weapons.Base.MP5Shot01'
    BurstFireVolumeMin=0.9000000
    BurstFireVolumeMax=1.0000000
    BurstFirePitchMin=1.0000000
    BurstFirePitchMax=1.0000000
    mBurstFireSounds[0]=Sound'MM_Weapons.FINALVERSIONS.WD_MP5_BURST_01'
    mBurstFireSounds[1]=Sound'MM_Weapons.FINALVERSIONS.WD_MP5_BURST_02'
    mBurstFireSounds[2]=Sound'MM_Weapons.FINALVERSIONS.WD_MP5_BURST_03'
    mEjectClipSounds[0]=Sound'Weapons.Base.MP5RemoveClip'
    mReplaceClipSounds[0]=Sound'Weapons.Base.MP5ReplaceClip'
    mAudibleRadius=150.0000000
    DisplayFOV=0.0000000
    PlayerViewOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    AttachmentClass=none
    Mesh=SkeletalMesh'WpAn.Hands'
}