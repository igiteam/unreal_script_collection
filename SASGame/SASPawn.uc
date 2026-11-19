//=============================================================================
// SASPawn.uc
//
// Base pawn class for all players and NPCs
//=============================================================================

class SASPawn extends Pawn
	abstract
	native
	nativereplication;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const DESIRED_AIM_MIN			= 0;
const DESIRED_AIM_NONE			= 127;
const DESIRED_AIM_MAX			= 255;
const MAX_AIM_PITCH				= 4000.0;
const MAX_AIM_RATE				= 20000.0;

const MAX_PAWNS_SEEN_ME_DEAD	= 16;

const PUNCH_MAX_ANGLE			= 3640;		// ~20deg
const PUNCH_MAX_DIST			= 75.0f;	// ~1.25m

//-----------------------------------------------------------------------------
// Enums

enum EStunAnimType
{
	STUNANIM_Blinded,
	//STUNANIM_Dazed,
	STUNANIM_SprayingFire,
	STUNANIM_NumTypes,
};

enum eLimbDisableEffect
{
	LDE_DAMAGE_CAPPED,				// Once limb is disabled, further damage has no effect
	LDE_KILL_PAWN					// If this limb is disabled then the actor is killed
};


// List of hit animation types
enum EHitAnimType
{
	HITANIM_Torso,
	HITANIM_LeftArm,
	HITANIM_RightArm,
	HITANIM_LeftLeg,
	HITANIM_RightLeg,
};


//-----------------------------------------------------------------------------
// Structs

struct native SASInjuryEffect
{
	var float mHealth;								// Health below which to apply this modifier
	var eLimbDisableEffect mDisableEffect;			// What happens when this limb is disabled ?
	var float mStrength;							// Proportion of strength represented by this limb (-1 = no effect)
	var float mDexterity;							// Proportion of dexterity represented by this limb (-1 = no effect)
	var float mSpeedMult;							// Proportion of speed represented by this limb (-1 = no effect)
	var float mIncapacitation;						// Health level for incapacitation
};

// Struct used to replicate data for an action anim.
struct native ActionAnimRep
{
	var name	AnimName;
	var int		PackedData;
};

struct SASSpeechArray
{
	var int mNumEntries;							// Number of speech entries in this array
	var Name mEntries [8];							// Speech names
};

struct native DirectionDeathAnim
{
	var array<name> Anim;
};

//-----------------------------------------------------------------------------
// New limb collision system
enum eLimbCollisionCylinders
{
	LCC_HEAD,
	LCC_TORSO,
	LCC_LUPPERARM,
	LCC_LFOREARM,
	LCC_LHAND,
	LCC_RUPPERARM,
	LCC_RFOREARM,
	LCC_RHAND,
	LCC_LTHIGH,
	LCC_LCALF,
	LCC_LFOOT,
	LCC_RTHIGH,
	LCC_RCALF,
	LCC_ROOT,
};


//-----------------------------------------------------------------------------
// Member Vars

var const SASPawn		mNextPawn;					// Singly linked list of SASPawns in the level
var() ESASSide			mSide;						// Pawn's side - see SIDE_xxx constants
var bool				mbCanMoveCrouched;			// Flag to indicate if pawn can move while in crouched stance.
var int					mFiringPose;				// Current pose when firing
var float				mFiringPoseChangeTime;		// Time when firing pose changed - used for firing anim blending.
var int					mInitialHealth;				// Initial health value
var float				mDefaultSightRadius;		// Cache of initial sight radius
var float				mDefaultHearingThreshold;	// Cache of initial hearing threshold
var ShadowProjector		mShadow;					// Our shadow projector
var SASWeapon			mPrevWeapon;				// Cache of previous weapon held
var bool				mbCanHoldWeaponAndGrenade;	// Flags if this pawn can hold its weapon and grenade at same time
var bool				mbInstantWeaponDrop;
var bool				mbSprayFiring;
var float				mFriendlyFireCheckAngle;
var bool				mbAiming;					// Flag if should be aiming at target.
var int					mAimPitch;
var int					mDesiredAimPitch;			// Desired aiming pitch angle - stored as byte for replication optimisation - range 0 == min pitch, 255= max pitch.
var byte				mRepAimPitch;				// Replicated aim pitch (compressed version of mDesiredAimPitch)
var byte				mLastRepAimPitch;			// Last recieved value of mRepAimPitch
var transient bool		mbTouchingKActor;			// True if currently touching a KActor object -used for karma object pushing.
var ActionAnimRep		mRepActionAnim;
var byte				mLastRepActionAnimID;
var float				mCurrentLeanTilt;			// Simulated lean angle.
var SASPawn				mPunchTarget;
var float				mIncapacitationTime;		// Time at which became incapacitated.
var float				mLastGroundMaterialUpdateTime;

// Weapon inventory - old mDefaultInventoryNames now obsolete
//var	array<String>	mDefaultInventoryNames;		// Array of inventory items added at start of level
var String				mInventoryWeapons [4];			// Primary, secondary, special, hand weapon
var	array<String>		mInventoryGrenades;				// Array of grenades
var Texture				mHandSkin;						// Skin to use on first person hands
var E3PAnimSet			mWeaponAnimSet;					// The type of wpn anims to use (MP5/pistol/shotgun etc).
var SASWeaponAttachment	mThirdPersonWeapon;				// Ptr to current third person weapon held - used for anim selection.

// these days, if he were a ragdoll, and then we killed the karma after a while for performance reasons,
// we've got no real way of detecting this when we next want to wake it up again.
// So let's just remember.
var bool				mWasRagdoll;

// Flags indicating state of pawn.
var() bool				mbHasGasMask;						// TRUE if the user is wearing a gas mask
var() float				mGasGrenadeIgnoreChance;			// 0->1 chance to ignore a gas grenade sighting.
var bool				mMasterLightswitch;					// Flag which toggles whether the pawn is in a "light-on" mode or not (weapon-dependent as to whether the lights are actually on)
var bool				mTorchShouldBeOn;					// We don't set torches directly, we set this bool and then check for it elsewhere
															// used to cover up setting it twice / never / whatever.
var bool				mLaserShouldBeOn;					// We don't set torches directly, we set this bool and then check for it elsewhere
															// used to cover up setting it twice / never / whatever.
var bool				mbCuffingStarted;					// In process of being cuffed.
var bool				mbCaptured;							// Is pawn secured?
var bool				mbIsIncapacitated;					// Is pawn incapacitated?
var bool				mbIsCombatCapable;					// Is pawn able to fight? (False when incapacitated/dead/feigning death etc).
var bool				mbIncapCanBeCuffed;
var bool				mbGassed;							// True if currently under the influence of CS gas
var bool				mbStunned;							// In stunned state
var bool				mbHeadlessChicken;

var (DamageShakeDontUse) 	float	HitShakeTime;
var (DamageShakeDontUse) 	float	HitRollMag;
var (DamageShake) 	vector	StandardHitShake;
var (DamageShake) 	vector	ScaledHitShake;
var (DamageShakeDontUse) 	vector	HitOffsetRate;

// Assault volume data
var private const SASAssaultVolume	mCachedAssaultVolume;		// Assault volume the pawn was in last time calculated
var private const vector			mAssaultVolCheckLocation;	// Location when cached assault volume was last updated
																// (Used to check if update is required).
// Combat model characteristics
var(Combat) float		mStrength;							// Used by weapon inertia as measure of weapon centering force
var(Combat) float		mDexterity;							// Modifier on rate of re-centering weapon rise effect

var(Combat) int			mShooterSpreadAngleNormal;			// Base weapon acccuracy modifier for pawn - added to weapon's base accuracy.
var(Combat)	float		mShooterSpreadAnglePenaltyDecayMod;	// Mod for how well this character can steady the weapon.

var(Combat) int			mShooterNoHitZoneBase;
var(Combat) float		mShooterNoHitZoneDecay;
var(Combat) float		mShooterNoHitZoneTimeout;

var(Combat) float		mUncenteredStabilityMod;			// Modifier on weapon stability when moving

var(Combat) float		mBaseWeaponSpeedMod;				// Modifier to ground speed due to weapon weight of 1.0 units
var(Combat) float		mBaseWeaponRotnMod;					// Modifier to rotation rate due to weapon weight of 1.0 units
var(Combat) float		mWeaponAimedSpeedMod;				// Modifier to ground speed when weapon is in aimed mode

var(Combat) float		mHeartRateBase;						// Min resting heart rate
var(Combat) float		mHeartRateWalking;					// Base walking heart rate
var(Combat) float		mHeartRateRunning;					// Base running heart rate
var(Combat) float		mHeartRateStressed;					// Heart rate while stressed. e.g. while disarming a booby trap
var(Combat) float		mHeartRateMax;						// Max heart rate
var(Combat) float		mHeartRateIncreaseRate;				// Rate of increase in heart rate
var(Combat) float		mHeartRateDecreaseRate;				// Rate of decrease in heart rate
var(Combat) float		mHeartRateShotSpreadAngleScalars[4];// Firing accuracy scalars for 4 heart rate zones 

// In-game (non-edittable) combat model vars.
var float				mLastFiredTime;
var float				mHeartRateQuarterRange;						// Quarter of size of heart rate range - used in accuracy mod
var float				mHeartRate;									// Current heart rate
var float				mWeaponSpeedMod;							// Current speed modifier due to weapon weight
var float				mShotSpreadAnglePenaltyForMovementCurrent;	// Current amount of accuracy loss for movement
var float				mShotSpreadAnglePenaltyForRotationCurrent;	// Current amount of accuracy loss for rotation

var float				mShooterNoHitZoneCurrrent;

// Weapon-pointing notify
var const float			mWeaponPointNotifyTimer;			// If default value is non-zero then pawn will send WeaponPointedAt notifiers.

// Bone-based limb collision system
var array<name>			mHitTorsoAnims;						// Array of hit middle anims
var array<name>			mHitLeftArmAnims;					// Array of hit left arm anims
var array<name>			mHitRightArmAnims;					// Array of hit right arm anims
var array<name>			mHitLeftLegAnims;					// Array of hit left leg anims
var array<name>			mHitRightLegAnims;					// Array of hit left leg anims
var float				mPlayHitAnimChance;					// Chance of playing a hit anim.
var name				mLastHitAnim;						// Last hit animation played

// Explosion stun parameters
var(Stun) bool			mbFearsStunGrenades;				// Does pawn fear (retreat from) stun grenades?
var(Stun) float			mFlashMaxSightMod;					// Max sight radius modification factor due to stun.
var(Stun) float			mFlashSightRecoveryTime;			// Time to fully recover sight from mximum stun.
var(Stun) float			mFlashBehindMeMod;					// Modifier to flash stun amount when explosion behind.
var(Stun) float			mBangMaxHearingMod;					// Max hearing modification due to stun.
var(Stun) float			mBangHearingRecoveryTime;			// Time to fully recover hearing from mximum stun.
var(Stun) float			mStunMaxHeartRateInc;				// Max increase in heart rate due to stun.
var(Stun) float			mStunDisorientThreshold;			// Min stun intensity received that results in pawn becoming disoriented.
var(Stun) float			mStunDisorientThresholdAlert;		// Min stun intensity received that results in pawn becoming disoriented when pawn is alert.
var(Stun) float			mStunDisorientThresholdIncPerStun;	// Increase in disorient threshold per time stunned.
var(Stun) float			mStunDisorientThresholdDecay;		// Decay in disorient threshold (per second).
var(Stun) Range			mStunDisorientTime;					// Time range in which pawn can be disoriented for

var float				mStunnedSightMod;
var float				mStunnedHearingMod;
var EStunAnimType		meStunnedAnimType;

// Cache of other pawns which have detected this pawn when it is dead.
var const Pawn			mPawnsSeenMeDead[MAX_PAWNS_SEEN_ME_DEAD];
var const int			mNumPawnsSeenMeDead;

// Script data
var(Script) export editinline array<SASScriptTrigger>	mScriptTriggers;	// Script triggers
var bool mbNotifyScriptsOfDamage;

// Karma properties
var string				mRagdollOverride;

var(Karma) float		mRagdollLifeSpan;				// MAXIMUM time the ragdoll will be around. De-res's early if it comes to rest.


/////////////////////////////////////////////////////
// rag death

var(KarmaDeath) float	mRagImpactPointVelScale;
var(KarmaDeath) float	mRagWholeBodyVelScale;

var(KarmaDeath) float	mRagWholeBodySpinScale;			// how much the whole body spins when dying
var(KarmaDeath) float	mRagExtraHorizontalWholeBodySpinScale;	// Increase propensity to spin around Z (up).

var(KarmaDeath) float	mRagDeathUpKick;				// Amount of upwards kick ragdolls get when they die

// rag death
/////////////////////////////////////////////////////


var(Karma) array<Sound>	mRagImpactSounds;
var(Karma) float		mRagImpactSoundInterval;
var(Karma) float		mRagImpactVolume;
var(Karma) float		mRagImpactSoundRadius;
var transient float		mRagLastSoundTime;
var bool				mbCanFreezeRagdoll;

var() array<Mesh>		mAlternativeMeshes;

var(Movement) array<SASRandomSpawnPoint> mSpawnPointList;

var	Vector				mOldLocation;					// Location actor was in on the last tick
var float				mStillTime;						// How long the actor has been still for
var float				mBloodDecalSpawnRate;			// Time between checking for movement when adding blood stains
var float				mBloodPoolStartTime;			// Time between checking for movement when adding blood stains
//var SASBloodPool		mBloodPool;						// Have we had a pool of blood yet? This is it if so.
var SASExpandingProjector	mBloodPool;						// Have we had a pool of blood yet? This is it if so.
var() float				mBloodDragChance;				// chance of leaving bloody drag marks

var bool				mInhibitHeadMovement;			// Set if you DON'T want random head movement
var Actor				mInterestItem;					// Current item we're looking at
var Float				mInterestAngle;					// Current offset angle we're looking in
var Rotator				mLookRotation;
var Rotator				mCurrentLookRotation;
var float 				mTimeSinceLastLook;
var float				mLimbHealths[NUM_BODY_PARTS];
//var float				mDefLimbHealths[NUM_BODY_PARTS];
var Name				mLastBoneHit;
var SASInjuryEffect		mInjuryEffects[NUM_BODY_PARTS];
var float				mDamageSpeedMod;
var float				mDamageSpeedModDifficultyLevScalar;
var float				mIncapacitationLevel;		// Damage overall health must drop to to cause incapacitation
var float				mLastTakeHitTime;			// Last time we played hit speech

// Neck twisting system
var native float		mNeckTwistCurrent;		// Actual neck twist value

// fire system
var bool				mbOnFire;
var float				mHeatDamagePerSecond;
var float				mHeatDamageAccumulator;			// Pawn.health is an int. damage taken in fractions during tick
var() class<SASFire_on_mesh>mFireOnMeshClass;
var SASFire_on_mesh		mMeshFire;
var	float				mFlamingCorpseTimer;

// Debug HUD info'
var string				mDebugMessageHUD;

struct native ShotDebugInfo
{
	var vector	Start;
	var vector	End;
	var float	CreationTime;
};
var ShotDebugInfo		mShotDebugInfo[20];
var int					mShotDebugInfoNextIdx;
var Color				mShotDebugColour;


// Sound
// Array of footstep sounds.
// Default sounds are boots, and have 10 variations of each.. May want to change that
// This structure provides an array of footstep varients, these will
// randomly be selected from to play a footstep sample.
// Currently a simple random selection will be used, this could be
// Changed to allow more weighting to some sounds if required.
// I am going to allow for running, walking & crouching,
// although crouching will currently have no sounds
// A script tag in the anim  will call the pawn methods
// AnimNotifyFootstepRun, AnimNotifyFootstepWalk, or AnimNotifyFootstepCrouch
//
// This was split into 3 arrays rather than an array of 3 elements in a structure
// as the line in the def props was too long
struct native SASFootstepSelection
{
	var() array<Sound>			mSound;
};


// Footstep sounds.
var(Sound) array<SASFootstepSelection>	mFootstepsRun;
var(Sound) array<SASFootstepSelection>	mFootstepsWalk;
// JS we just use quieter versions of the walk sounds now: var(Sound) array<SASFootstepSelection>	mFootstepsCrouch;
var(Sound) float mFootstepVolumeRun;
var(Sound) float mFootstepVolumeCrouch;
var(Sound) float mFootstepVolumeWalk;
var(Sound) float mFootstepSoundRadius;
var(AI)	float mFootstepLoudnessRun;
var(AI) float mFootstepLoudnessWalk;
var(AI) float mFootstepLoudnessCrouch;
var Sound mLastFootstepSound;


// Movement sounds (equipment clinks, clothing ruffles. etc.)
//
// Sorry these aren't packaged up in a struct...  I wanted to but the
// Script compiler wouldn't let me.  Well, it did, but then the initialization
// became hideously ugly.

// Crouching params.
var(Sound)	array<Sound>	mMovementSoundsCrouch;
var(Sound)	float			mMovementSoundVolumeCrouch;
var(AI)		float			mMovementSoundAILoudnessCrouch;
var(Sound)	float			mMovementSoundsIntervalBaseCrouch;
var(Sound)	float			mMovementSoundsIntervalRangeCrouch;
// Walking params.
var(Sound)	array<Sound>	mMovementSoundsWalk;
var(Sound)	float			mMovementSoundVolumeWalk;
var(AI)		float			mMovementSoundAILoudnessWalk;
var(Sound)	float			mMovementSoundsIntervalBaseWalk;
var(Sound)	float			mMovementSoundsIntervalRangeWalk;
// Running params.
var(Sound)	array<Sound>	mMovementSoundsRun;
var(Sound)	float			mMovementSoundVolumeRun;
var(AI)		float			mMovementSoundAILoudnessRun;
var(Sound)	float			mMovementSoundsIntervalBaseRun;
var(Sound)	float			mMovementSoundsIntervalRangeRun;
// Non-editable run time internals. 
var float 					mTimeSinceLastMovementSound;
var float 					mTimeUntillNextMovementSound;

//------------------

var Vector								mSpecialLocation;
var Rotator								mSpecialRotation;

var int			Spree;
var byte		LoadOut;
var int			mSquadIdx;

// Generic Speech
var () class<SASPawnVoice>				mVoiceClass;
var transient SASPawnVoice				mVoice;
var (SpeechControl) float				mMinIncapTimer;
var (SpeechControl) float				mMaxIncapTimer;

// DEBUG VARS
var bool mInfiniteAmmoCheat;

var int aimScale;

// anim replication
var int		mAnimLoop;
var float	mAnimRate;
var float	mAnimBlendTime;
//var int		mAnimChannel;

// Major turn animations
var name	mTurnLeft90Anim;		// CCW 90 degrees
var name	mTurnRight90Anim;		// CW 90 degrees
var name	mTurnLeft180Anim;		// CCW 180 degrees
var name	mTurnRight180Anim;		// CW 180 degrees

// Death anims
const NUM_DEATH_ANIM_DIRECTIONS = 4;
var DirectionDeathAnim	mDirectionalDeathAnimsStanding[NUM_DEATH_ANIM_DIRECTIONS];
var DirectionDeathAnim	mDirectionalDeathAnimsCrouching[NUM_DEATH_ANIM_DIRECTIONS];
var DirectionDeathAnim	mDirectionalDeathAnimsProne[NUM_DEATH_ANIM_DIRECTIONS];

/*
*/
// KW debug stuff ...
var Array<String>		mNetModeLabels;
var Array<String>		mRoleLabels;


//	Eye blinking


var float		BlinkTime;

////////////////////////////////////////////////////////////////////////////////
// replication
//
replication
{
	// Variables initialised by the server and sent to clients.
	reliable if ( bNetInitial && ( Role == ROLE_Authority ) )
		mInitialHealth,
		mDefaultSightRadius,
		mDefaultHearingThreshold,
		mWeaponSpeedMod,
		mStunnedSightMod,
		mStunnedHearingMod,
		mStunDisorientThresholdAlert,
		mDamageSpeedMod,
		mDamageSpeedModDifficultyLevScalar;

	// Variables sent from server to clients.
	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
		mWeaponAnimSet,
		mThirdPersonWeapon,
		mLaserShouldBeOn,
		mMasterLightswitch,
		mTorchShouldBeOn, 
		mAnimLoop,
		mAnimRate,
		mAnimBlendTime,
//		mAnimChannel,
		mbIsIncapacitated,
		mbIncapCanBeCuffed,
		mbGassed,	
		mbStunned,
		mbHeadlessChicken,
		mbIsCombatCapable,
		mSquadIdx,
		mbCaptured,
		mbCuffingStarted,
		mHeartRate,				// GP: Can probably simulate this.
		mRepAimPitch,			// TODO: Can simulate this for AI controlled pawns.
		mRepActionAnim,
		mFiringPose;

	// Functions server should call on owned client.
	reliable if ( Role == ROLE_Authority )
		ClientTakeDamageEffects,
		ClientSetNonZeroExtentTraces;

	// Functions clients call on server.
	reliable if ( Role < ROLE_Authority )
		ServerOpenCloseDoor,
		ServerSetLean; 
}

/*
simulated function String GetPlayerName ()
{
	return self.PlayerReplicationInfo.PlayerName;
}
*/



//-----------------------------------------------------------------------------
// Native Functions

///////////////////////////////////////////////////////////////////////////////
native function MemTick ();


///////////////////////////////////////////////////////////////////////////////
// GetAssaultVolume
//
// Get the SASAssaultVolume which the pawn currently resides in.
native(680) final function SASAssaultVolume GetAssaultVolume();


///////////////////////////////////////////////////////////////////////////////
// PawnWithinViewLimits
//
// Returns true if pawn aOther lies within our view radius and
// peripheral vision angle.
native(681) final function bool PawnWithinViewLimits(
	Pawn aOther );

//-----------------------------------------------------------------------------
// Returns TRUE if we have line of sight to the supplied pawn. 
// Not super-accurate, runs a fast trace from eye-position to eye-position
native(682) final function bool PawnIsVisible( Pawn P );

//-----------------------------------------------------------------------------
// Returns TRUE if we have line of sight to the supplied actor.
// Not super-accurate, runs a fast trace from eye-position to actor location.
native(683) final function bool ActorIsVisible( Actor A );

native(684) final function SetStandCollision ();
native(685) final function SetCrouchedCollision ();
native(686) final function SetProneCollision ();

native(687) final function ToggleMaterialSequences ( bool aPause );

native(688) final function float GetPathCost(
	Actor	aStart,
	Actor	aEnd );

///////////////////////////////////////////////////////////////////////////////
//
// Returns true if other pawn encroaches our collision cylinder. Used to 
// test if a prone pawn can get up without collision problems.
native(689) final function bool IsEncroachedByOtherPawn();

///////////////////////////////////////////////////////////////////////////////
//
// returns TRUE if the supplied ray intersects the pawn's collision cylinder
native(690) final function bool CylinderCollisionTest (Vector rayStart, Vector rayEnd, optional eSASStance stance);


///////////////////////////////////////////////////////////////////////////////
//
// Does a ray trace to get the ground material directly below the pawn. Fills
// in the GroundMaterial member var.
native(691) final function GetGroundMaterial();

///////////////////////////////////////////////////////////////////////////////
// 
native(692) final function bool IsAThreat( 
	Actor	aOther );

///////////////////////////////////////////////////////////////////////////////
//
native(693) final function bool IsFriendly(
	Actor	aOther );

///////////////////////////////////////////////////////////////////////////////
//
native(694) final function CheckAiming();


///////////////////////////////////////////////////////////////////////////////
// StopAiming
//
native(695) final function StopAiming();


///////////////////////////////////////////////////////////////////////////////
// SetReplicatedActionAnim
//
native(696) final function SetReplicatedActionAnim(
	name	aAnim,
	float	aRate,
	float	aBlendTime,
	bool	abChannelInstantBlend,
	bool	abUpperBodyOnly,
	bool	abRootMotion );


///////////////////////////////////////////////////////////////////////////////
// IsStationary
//
native(697) simulated final function bool IsStationary();

native final function name ChooseDirectionDeathAnim( vector	aHitLocation );


//-----------------------------------------------------------------------------
// Exec Functions

exec function SetWalkPct(
	float aNewWalkPct)
{
	WalkingPct = aNewWalkPct;
}

exec function SetCollisionHeight(
	float	aNewHeight )
{
	SetCollisionSize( CollisionRadius, aNewHeight );
}

exec function SetCollisionRadius(
	float	aNewRadius )
{
	SetCollisionSize( aNewRadius, CollisionHeight );
}

exec function resetCollisionRadius ()
{
	SetCollisionSize( default.CollisionRadius, CollisionHeight );
} // resetCollisionRadius

exec function TestInaccuracy()
{
	mShooterNoHitZoneCurrrent = mShooterNoHitZoneBase;
}

exec function SetInaccuracy(
	int		aNewBaseMod,
	float	aNewDecayRate )
{
	mShooterNoHitZoneBase = aNewBaseMod;
	mShooterNoHitZoneDecay = aNewDecayRate;
}

//-----------------------------------------------------------------------------
// Functions

event ServerSetLean(
	ELeanDirection	aNewLeanDir )
{
	if ( Role == ROLE_Authority )
	{
		mLeanDir = aNewLeanDir;
	}
}

function SetNonZeroExtentTraces ( bool aState )
{
	bBlockNonZeroExtentTraces = aState;

	if ( Role == ROLE_Authority )
	{
		ClientSetNonZeroExtentTraces ( aState );
	}
}

simulated function ClientSetNonZeroExtentTraces ( bool aState )
{
	bBlockNonZeroExtentTraces = aState;
}


event AddShotDebug(
	Vector	aStart,
	Vector	aEnd )
{
	mShotDebugInfo[mShotDebugInfoNextIdx].Start = aStart;
	mShotDebugInfo[mShotDebugInfoNextIdx].End = aEnd;
	mShotDebugInfo[mShotDebugInfoNextIdx].CreationTime = Level.TimeSeconds;

	mShotDebugInfoNextIdx = (mShotDebugInfoNextIdx+1) % 20;
}

function DrawShotDebug(
	Hud aHud)
{
	local int	i;

	for ( i = 0; i < 10; ++i )
	{
		if (	(mShotDebugInfo[i].CreationTime > 0.0) &&
				(Level.TimeSeconds < (mShotDebugInfo[i].CreationTime + 20.0)) )
		{
			aHUD.Draw3DLine(
				mShotDebugInfo[i].Start,
				mShotDebugInfo[i].End,
				mShotDebugColour );
		}
	}
}

simulated event PostNetBeginPlay ()
{
	Super.PostNetBeginPlay();
	
	if ( bActorShadows )
	{
		// Initialise shadow projector
		mShadow = Spawn ( class'ShadowProjector', None, '', Location );
		mShadow.ShadowActor = self;
		mShadow.LightDirection = Normal ( vect ( 1, 1, 3) );
		mShadow.LightDistance = 380;
		mShadow.MaxTraceDistance = 350;

		mShadow.InitShadow ();
		mShadow.UpdateShadow ();
	}

	// Build limb collision data
}

simulated event Destroyed ()
{
	// Tidy shadow projector
	if ( mShadow != None )
	{
		mShadow.Destroy ();
	}

	Super.Destroyed ();
}


event EncroachedBy( 
	Actor	aOther )
{
	local Pawn		otherPawn;
	local Vector	realVel;

	otherPawn = SASPawn( aOther );
	if ( otherPawn == None )
	{
		Super.EncroachedBy( aOther );
		return;
	}

	// Only player pawns encroached by other players are affected by encroachment.
	if ( (Controller != None) && (Controller.mType == CONTROLLER_Player) )
	{
		if (	(otherPawn.Controller != None) &&
				(otherPawn.Controller.mType == CONTROLLER_Player) )
		{
			Super.EncroachedBy( aOther );
		}
	}	

	// If either or both encroaching pawns are AI controllers then try to make them 
	// do a bump avoidance move.
	if ( (Controller != None) && (Controller.mType != CONTROLLER_Player) )
	{
		realVel = otherPawn.Velocity;
		otherPawn.Velocity = Vect(100000,0,0);
		SASAIController( Controller ).NotifyBump( otherPawn );
		otherPawn.Velocity = realVel;
	}
	if ( (otherPawn.Controller != None) && (otherPawn.Controller.mType != CONTROLLER_Player) )
	{
		realVel = Velocity;
		Velocity = Vect(100000,0,0);
		SASAIController( otherPawn.Controller ).NotifyBump( self );
		Velocity = realVel;
	}
}


// Check if other is a KActor and threfore need to do KActor kicking.
event Touch(
	Actor	aOther )
{
	if ( KActor( aOther ) != None )
	{
		mbTouchingKActor = true;
	}

	Super.Touch( aOther );
}

// Check if we are still touching a karma actor (and therefore need to do KActor kicking)
event Untouch(
	Actor	aOther )
{
	local bool		bStillTouchingKarma;
	local KActor	touchingKActor;	

	if ( KActor( aOther ) != None )
	{
		// Are we still touching any KActors?
		foreach TouchingActors( class'KActor', touchingKActor ) 
		{
			if ( touchingKActor != aOther )
			{
				bStillTouchingKarma = true;
				break;
			}
		}
	}

	mbTouchingKActor = bStillTouchingKarma;

	Super.Untouch( aOther );
}

//-----------------------------------------------------------------------------
// DisplayDebug
//
simulated function DisplayDebug(
	Canvas		aCanvas,
	out float	aYL,
	out float	aYPos )
{
	local name	anim;
	local float	frame, rate;

	Super.DisplayDebug( aCanvas, aYL, aYPos );

	aCanvas.SetDrawColor( 255, 255, 255 );

	aCanvas.DrawText( "Cached Assault Vol: "$mCachedAssaultVolume$", Vol Check Location: "$mAssaultVolCheckLocation );
	aYPos += aYL;
	aCanvas.SetPos ( 4, aYPos );

	aCanvas.DrawText( "Sight radius: "$SightRadius$", Hearing threshold: "$HearingThreshold );
	aYPos += aYL;
	aCanvas.SetPos ( 4, aYPos );

	GetAnimParams( ANIMCHANNEL_FIRING, anim, frame, rate);
	aCanvas.DrawText( "Firing anim: "$anim$", frame="$frame$", rate="$rate);
	aYPos += aYL;
	aCanvas.SetPos ( 4, aYPos );

	GetAnimParams( ANIMCHANNEL_AIMING, anim, frame, rate);
	aCanvas.DrawText( "Aiming anim: "$anim$", frame="$frame$", rate="$rate);
	aYPos += aYL;
	aCanvas.SetPos ( 4, aYPos );

	GetAnimParams( ANIMCHANNEL_ACTION, anim, frame, rate);
	aCanvas.DrawText( "Action anim: "$anim$", frame="$frame$", rate="$rate);
	aYPos += aYL;
	aCanvas.SetPos ( 4, aYPos );
}


//-----------------------------------------------------------------------------
// DrawCollisionCylinder
//
// Displays the pawn's collision cylinder. SLOW
simulated function DrawCollisionCylinder (
	HUD				aHUD,			// HUD object which handles the drawing
	Color			aDrawColour,	// Line colour
	bool			drawAvoid,		// also draw avoidance cylider
	optional int	aNumSides )		// Number of sides to cylinder

{
	local int		i;
	local float		angleDelta;
	local vector	vert, lastVert;
	local vector	up;
	local vector	X, Y, Z;
	local vector	loc2;

	if ( aNumSides == 0 )
	{
		aNumSides = 16;
	}

	GetAxes( Rotation, X, Y, Z );

	up = Z * CollisionHeight;

	angleDelta = 2.0 * PI / aNumSides;
	lastVert = Location + (X * CollisionRadius);

	if ( !IsFirstPerson () )
	{
		for ( i = 0; i < aNumSides; i++ )
		{
			vert = Location + (((X * Cos (angleDelta * (i+1))) + (Y * Sin (angleDelta * (i+1)))) * CollisionRadius);

			aHUD.Draw3DLine( lastVert - up, vert - up, aDrawColour );
			aHUD.Draw3DLine( lastVert, vert, aDrawColour );
			aHUD.Draw3DLine( lastVert + up, vert + up, aDrawColour );
			aHUD.Draw3DLine( lastVert - up, lastVert + up, aDrawColour );

			lastVert = vert;
		}
	}

	if( drawAvoid )
	{
		// draw secondary 'avoidance' cylinder
		//
		// const int PAWNHEIGHT = 95;
		// const int PAWNCOLCYLRAD = PAWNHEIGHT / 4;
		// const int PROJDIST = PAWNHEIGHT / 2;

		loc2 = Location + (X * (95/2));
		lastVert = loc2 + (X * (95/4));

		for ( i = 0; i < aNumSides; i++ )
		{
			vert = loc2 + (((X * Cos (angleDelta * (i+1))) + (Y * Sin (angleDelta * (i+1)))) * (95/4));

			aHUD.Draw3DLine( lastVert - up, vert - up, aDrawColour * 0.75 );
			aHUD.Draw3DLine( lastVert, vert, aDrawColour * 0.75 );
			aHUD.Draw3DLine( lastVert + up, vert + up, aDrawColour * 0.75 );
			aHUD.Draw3DLine( lastVert - up, lastVert + up, aDrawColour * 0.75 );

			lastVert = vert;
		}
	}
}

//-----------------------------------------------------------------------------

function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum)
{
	Super.PlayHit(Damage,InstigatedBy, hitLocation, damageType, Momentum);

	if (SASPlayerController(Owner) != None)
	{
		SASPlayerController(Owner).ShakeView(HitShakeTime, HitRollMag, ScaledHitShake * damage + StandardHitShake, 120000, HitOffsetRate, 2);
	}
}

//-----------------------------------------------------------------------------
// DrawLimbCollision
//
simulated function DrawLimbCollision (
	HUD				aHUD,			// HUD object which handles the drawing
	Color			aDrawColour,	// Line colour
	bool			drawAvoid,		// Also draw avoidance cylider
	optional int	aNumSides )		// Number of sides to cylinder
{
	local int i;
	local Vector A, B, C, D;
	local Color hilite;
	local SASGRI			gri;

	// Don't draw player cylinders
//	if ( PlayerController ( Controller ) == Level.GetLocalPlayerController () )
	if ( IsFirstPerson () )
	{
		return;
	} // if

	gri = SASGRI( Level.Game.GameReplicationInfo );
	hilite = class'Canvas'.Static.MakeColor (255, 255, 0, 255);
	for (i = 0; i < mLimbCylinders.Length; i++)
	{
		A = GetBoneLocation (mLimbCylinders [i].mBoneA);
		B = GetBoneLocation (mLimbCylinders [i].mBoneB);
		D = (A + B) / 2;		// Centre point
		C = normal (A - B);

		if (i == mLastCylinderDamageHit && (mLastCylinderHitTime + 5) > gri.GetLevelTimer(0))
		{
			aHUD.Draw3DCylinder (D, C, mLimbCylinders [i].mRadius, VSize (B - A), aNumSides, hilite);
		} // if
		else
		{
			aHUD.Draw3DCylinder (D, C, mLimbCylinders [i].mRadius, VSize (B - A), aNumSides, aDrawColour);
		} // else
	} // for
} // DrawLimbCollision

//-----------------------------------------------------------------------------
// DrawLimbCollisionOverlay
//
simulated function DrawLimbCollisionOverlay (
	SASHUD			aHUD,
	Canvas			aCanvas)
{
	local int i;
	local Vector D;

	// Don't draw player cylinders
	if ( IsFirstPerson () )
	{
		return;
	} // if

	aCanvas.SetDrawColor (100, 100, 255);
	for (i = 0; i < mLimbCylinders.Length; i++)
	{
		D = (GetBoneLocation (mLimbCylinders [i].mBoneA) + GetBoneLocation (mLimbCylinders [i].mBoneB)) / 2;		// Centre point

		switch (eLimbCollisionCylinders (i))
		{
			case LCC_HEAD :
				aHUD.draw3DText (aCanvas, "H: " $mLimbHealths [0]$ "/" $default.mLimbHealths [0], D);
				break;

			case LCC_TORSO :
				aHUD.draw3DText (aCanvas, "H: " $mLimbHealths [1]$ "/" $default.mLimbHealths [1], D);
				break;

			case LCC_LUPPERARM :
				aHUD.draw3DText (aCanvas, "H: " $mLimbHealths [2]$ "/" $default.mLimbHealths [2], D);
				break;

			case LCC_RUPPERARM :
				aHUD.draw3DText (aCanvas, "H: " $mLimbHealths [3]$ "/" $default.mLimbHealths [3], D);
				break;

			case LCC_LTHIGH :
				aHUD.draw3DText (aCanvas, "H: " $mLimbHealths [4]$ "/" $default.mLimbHealths [4], D);
				break;

			case LCC_RTHIGH :
				aHUD.draw3DText (aCanvas, "H: " $mLimbHealths [5]$ "/" $default.mLimbHealths [5], D);
				break;
		} // switch
	} // for
	aCanvas.SetDrawColor (0, 255, 255);
	aHUD.draw3DText (aCanvas, "H: " $Health$ "/" $mInitialHealth, Location);
} // DrawLimbCollision

//-----------------------------------------------------------------------------
// PreBeginPlay
//
event PreBeginPlay ()
{
	local int			i;
	local SASGameInfo	gi;
	local SASGRI		gri;
	local float			r,g,b,tot;

	Super.PreBeginPlay();

	// Set shot debug line colour
	i = RandRange( 190, 255 );
	r = FRand();
	g = FRand();
	b = FRand();
	tot = r+g+b;
	if ( tot > 0.0 )
	{
		r /= tot;
		g /= tot;
		b /= tot;
	}
	else
	{
		r = 1.0;
		g = 1.0;
		b = 1.0;
	}
	r *= i;
	g *= i;
	b *= i;
	mShotDebugColour = class'Canvas'.Static.MakeColor( r, g, b );

	// Cache default sight/hearing parameters
	mDefaultSightRadius = SightRadius;
	mDefaultHearingThreshold = HearingThreshold;

	// Cache initiial health.
	mInitialHealth = Default.Health;

	mWeaponSpeedMod		= 1.0f;
	mStunnedSightMod	= 1.0f;
	mStunnedHearingMod	= 1.0f;

	// Ensure editable vars have sensible values.
	mStunDisorientThresholdAlert = FMax( mStunDisorientThresholdAlert, mStunDisorientThreshold );

	// Init heart rate params
	mHeartRate = mHeartRateBase;
	mHeartRateQuarterRange = (mHeartRateMax - mHeartRateBase) / 4;

	// Heart rate accuracy scalars must not improve accuracy (scaling values must be >= 1.0)
	for ( i = 0; i < 4; i++ )
	{
		mHeartRateShotSpreadAngleScalars[i] = FMax( mHeartRateShotSpreadAngleScalars[i], 1.0 );
	}

//	for (i=0; i<NUM_BODY_PARTS; i++)
//	{
//		mLimbHealths[i] = mDefLimbHealths[i];
//	}

	// Get my voice for speech.
	gi = SASGameInfo ( Level.Game );
	if ( ( mVoiceClass != None ) && ( gi != None ) )
	{
		mVoice = gi.GetPawnVoice( mVoiceClass );
	}
	else
	{
		if ( mPawnType != PAWN_Scripted )
		{
			LogHuman ( "Pawn <"$self$"> does not have a voice class specified." );
		}
	}
	KSetImpactThreshold( 110 );

	// Get difficulty level dependant damage speed mod scalar.
	gri = SASGRI( Level.Game.GameReplicationInfo );
	if ( gri != None )
	{
		mDamageSpeedModDifficultyLevScalar = gri.mDifficultySetting.PawnDamageSpeedScalar;
	}
}

//-----------------------------------------------------------------------------
// PostBeginPlay
//
event PostBeginPlay()
{
	// Hack to make sure Pawn is not posessed by an Unreal AIScript
	if ( AIScriptTag != 'None' )
	{
		LogHuman( "SASPawn has AIScriptTag defined. Not used in SAS." );
		AIScriptTag = 'None';
	}

	Super.PostBeginPlay();
	if ( bDeleteMe )
	{
		return;
	}

	// Make pawn fall to ground at start.
	if ( Physics != PHYS_KarmaRagdoll )
	{
		DropToGround();
	}

	// Init starting inventory
	if ( Level.bStartup )
	{
		AddDefaultInventory ();

		//if ( !SelectBestWeapon () )
		//{
		//	Warn ( "Pawn" @self @"has no weapon to select!" );
		//}
	}

	// Init script trigger conditions
	InitScripts ();

	//mInterestItem = Level.GetLocalPlayerController().Pawn;
} // PostBeginPlay


//-----------------------------------------------------------------------------
// Activated
//
// This gets called on pawns which start the level inactive when they get activated.
event Activated();


//------------------------------------------------------------------------------
// InitScripts
//
function InitScripts ()
{
	local int i;

	for ( i = 0; i < mScriptTriggers.Length; ++i )
	{
		if ( mScriptTriggers[i] != None )
		{
			if ( mScriptTriggers[i].mScript != None )
			{
				mScriptTriggers[i].Init();
			}
			else
			{
				LogHuman( "Script trigger "$mScriptTriggers[i]$" on pawn "$self$" not associated with a script. Deleting trigger." );
				mScriptTriggers.Remove( i, 1 );
				i--;
			}
		}
	}
}

//------------------------------------------------------------------------------
// InitPawnScripts
//
// init scripting for single player game
function InitPawnScripts ( array<SASScriptTrigger> aScriptTriggers )
{
	local int i;

	// dynamic array resizes when I do this:
	mScriptTriggers.Length = aScriptTriggers.Length;

	// now copy over script triggers ...
	for ( i = 0; i < aScriptTriggers.Length; ++i )
	{
		// must 'new' this as it's not derived from Actor
		mScriptTriggers[i] = new class'SASGame.SASScriptTrigger';

		// copy over all the stuff if success
		if ( mScriptTriggers[i] != None )
		{
/*
			mScriptTriggers[i].mPriority		= aScriptTriggers[i].mPriority;
			mScriptTriggers[i].mbCanUntrigger	= aScriptTriggers[i].mbCanUntrigger;
			mScriptTriggers[i].mActivationDelay	= aScriptTriggers[i].mActivationDelay;
			mScriptTriggers[i].mCondition		= aScriptTriggers[i].mCondition;
			mScriptTriggers[i].mScript			= aScriptTriggers[i].mScript;
*/
			// hmm! this appears to work too!
			mScriptTriggers[i] = aScriptTriggers[i];
		}
		else
		{
			warn ( "Unable to get SASScriptTrigger object in InitPawnScripts!" );
		}
	}

	// do pawn-side script init
	InitScripts ();
}

//-----------------------------------------------------------------------------
// GetGame
//
// Return the current levels GameInfo object cast to an SASGameInfo.
// careful: in MP, clients calling this will return 'None' every time!
function SASGameInfo GetGame ()
{
	local SASGameInfo	gi;

	gi = SASGameInfo ( Level.Game );
	if ( gi == None )
	{
		Warn( "SASPawn.GetGame (): Object is not an SASGameInfo!" );
		return None;
	}
	return gi;
}

//------------------------------------------------------------------------------
// GetGRI
//
// return game replication info
// modified to return local GRI in MP
function SASGRI GetGRI ()
{
	local SASGRI	gri;

//	gri = SASGRI ( Level.Game.GameReplicationInfo );
	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( gri == None )
	{
		Warn( "SASPawn.GetGRI (): Object is not an SASGRI!" );
		return None;
	}
	return gri;
}


//-----------------------------------------------------------------------------
// GetMaxPace
//
function ESASPace GetMaxPace()
{
	return PACE_Charging;
}


//-----------------------------------------------------------------------------
// IsInSameAssaultVolume
//
// Returns true if aOther is in same assault volume as this pawn.
// If this pawn not in assault volume, returns false.
//::function bool IsInSameAssaultVolume(
//::	SASPawn	aOther )
//::{
//::	local SASAssaultVolume	myAV;
//::
//::	myAV = GetAssaultVolume();
//::	if ( (myAV != None) && (myAV == aOther.GetAssaultVolume()) )
//::	{
//::		return true;
//::	}
//::
//::	return false;
//::}

////////////////////////////////////////////////////////////////////////////////
// isPointingWeaponAt
//
// Returns TRUE if I'm pointing my weapon at 'target'
function bool isPointingWeaponAt (SASPawn target)
{
	return SASWeapon (weapon).isPointingAt (target);
} // if

////////////////////////////////////////////////////////////////////////////////
// AddInventory
//
// Add Item to this pawn's inventory.
// Returns true if successfully added, false if not.
function bool AddInventory ( Inventory NewItem )
{
	local Inventory		Inv;
	local Actor			Last;
	local Actor			Prev;
	local Inventory		Next;
	local SASWeapon		newWpn;
	local SASWeapon		thisWpn;

	// The item should not have been destroyed if we get here.
	if ( NewItem == None )
	{
		Warn ( "tried to add none inventory to "$self );
		return false;
	}

	// Skip if already in the inventory.
	Last = self;
	for ( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{
		if ( Inv == NewItem )
		{
			return false;
		}
		Last = Inv;
	}

	// we want this, make it ours
	NewItem.SetOwner ( Self );

	if ( ( SASAmmo ( NewItem ) != None )
		|| ( self.Inventory == None ) )
	{
		// Add ammo to back of inventory chain (so minimizes net
		// replication effect).
		NewItem.Inventory = None;
		Last.Inventory = NewItem;
	}
	else
	{
		newWpn = SASWeapon ( NewItem );
		if ( newWpn == None )
		{
			Warn ( "trying to add non SAS weapon to inventory list:" @NewItem );
			return false;
		}

		// find insertion point in ordered list
		for ( Prev = self; Prev.Inventory != None; Prev = Prev.Inventory )
		{
			Next = Prev.Inventory;

			thisWpn = SASWeapon ( Prev.Inventory );
			if ( ( thisWpn == None )	// i.e. SASAmmo ...
				|| ( thisWpn.mCategory + thisWpn.mGrenadeCategory ) > ( newWpn.mCategory + newWpn.mGrenadeCategory ) )
			{
				break;
			}
		}

		// insert!
		Prev.Inventory = NewItem;
		NewItem.Inventory = Next;
	}

	if ( Controller != None )
	{
		Controller.NotifyAddInventory ( NewItem );
	}

	return true;
}

//-----------------------------------------------------------------------------
// addInventoryItem
//
function SASWeapon addInventoryItem ( String item )
{
	local Inventory			tInv;
	local class<Inventory>	tInvClass;

	// No mutators on a client
	if ( Level.NetMode != NM_Client )
	{
		if (item != "")
		{
			tInvClass = Level.Game.BaseMutator.GetInventoryClass (item);
		}
		else
		{
			tInvClass = None;
		}
	}

	if ( (tInvClass != None) && ( FindInventoryType( tInvClass ) == None) )
	{
		tInv = Spawn( tInvClass, self );
		if ( tInv != None )
		{
			tInv.GroupOffset = 0;
			tInv.GiveTo( self );
			tInv.PickupFunction( self );
		}
		else
		{
			Log ("Unable to spawn weapon from inventory class " $tInvClass$ " in pawn " $self);
		} 
	}

	return SASWeapon ( tInv );
} // addInventoryItem

//-----------------------------------------------------------------------------
// AddDefaultInventory
//
// Adds default inventory items at start of level
// presently, called from SASGameInfo via GameInfo for PlayerControllers and
// SASPawn for AIs
function AddDefaultInventory ()
{
	local SASWeapon tInv;
	local int i;

	for ( i = 0; i < mInventoryGrenades.Length; ++i )
	{
		if ( mInventoryGrenades[i] != "" )
		{
			tInv = addInventoryItem ( mInventoryGrenades [i] );
		}
	}

	for ( i = 3; i >= 0; --i )
	{
		if ( mInventoryWeapons[i] != "" )
		{
			tInv = addInventoryItem ( mInventoryWeapons [i] );
		}
	} 
}


///////////////////////////////////////////////////////////////////////////////
// applyLimbDamageEffects
//
// Applies strength / dexterity / speed effects of limb damage
function applyLimbDamageEffects (
	ESASBodyParts		limb,
	float				appliedDamage, 
	Pawn				aInstigator,
	Vector				aHitLocation,
	Vector				aMomentum,
	class<DamageType>	aDamageType,
	Weapon				aWpn )
{
	local float	 damageFraction;
	local SASTerroristController TC;
	local Vector TossVel;
	local int i;

	// Recalculate damage effects per limb as I don't trust the cumulative method

	//mStrength = Default.mStrength;
	//mDexterity = Default.mDexterity;
	mDamageSpeedMod = 1.0;

	for (i = 0; i < NUM_BODY_PARTS - 1; i++)
	{
		damageFraction = mLimbHealths [i] / Default.mLimbHealths [i];
		/*if (mInjuryEffects [i].mStrength > 0)
		{
			mStrength -= damageFraction * mInjuryEffects [i].mStrength;
		} // if

		if (mInjuryEffects [i].mDexterity > 0)
		{
			mDexterity -= damageFraction * mInjuryEffects [i].mDexterity;
		} // if
		*/
		if (mInjuryEffects [i].mSpeedMult > 0)
		{
			mDamageSpeedMod -= damageFraction * mInjuryEffects [i].mSpeedMult;
		} // if
	} // for

	//mStrength = FClamp( mStrength, 0.0, 1.0 );
	//mDexterity = FClamp( mDexterity, 0.0, 1.0 );
	mDamageSpeedMod = FClamp( mDamageSpeedMod * mDamageSpeedModDifficultyLevScalar, 0.75, 1.0 );

	// If right arm is disabled, drop weapon. This causes terrorists to surrender
	if (mLimbHealths [limb] <= 0)
	{
		if (limb == BODYPART_RARM)
		{
			// Make terrorists drop their weapon.
			if ( mPawnType == PAWN_Terrorist )
			{
				if ( Controller != None && Controller.mType == CONTROLLER_AiTerrorist )
				{
					TC = SASTerroristController (Controller);
					if ( TC != None && TC.CanSurrender() )
					{
						// Only drop weapon (and hence surrender) if we are in a suitable location
						// for going prone. Else a following ordered down/captured anim will look bad. 
						if ( TC.FindDirectionToGoProne() )
						{
							if (Weapon != None)
							{
								if ( Controller != None )
								{
									Controller.LastPawnWeapon = Weapon.Class;
								} // if
								Weapon.HolderDied();
								TossVel = Vector(GetViewRotation());
								TossVel = TossVel * ((Velocity Dot TossVel) + 500) + Vect(0,0,200);
								TossWeapon(TossVel);
							} // if

							// Surrender
							TC.DoSurrender ();
						}
						else
						{
							if ( (appliedDamage > 0) && !InGodMode() )
							{
								Super.TakeDamage (appliedDamage, aInstigator, aHitlocation, aMomentum, aDamageType, aWpn );
							}
						}
					}
				}
			} // if
		} // if
	} // if
} // applyLimbDamageEffects

//------------------------------------------------------------------------------
// PointDamage
//
// apply damage from bullets etc.
function TakeDamagePoint (
  	int					aDamage,
	Pawn				aInstigatedBy,
	Vector				aHitlocation,
	Vector				aMomentum,
	class<DamageType>	aDamageType,
	Weapon				wpn)
{
	local bool				bGodMode;
	local int				limbDamage,
							bodyDamage;
	local Name				tBoneName;
	local int				tHitPart;
	local float				maxBodyDamage;
	local ESASBodyParts		tType;
	local SASGRI			gri;

	// Can't shoot ourselves (if we do it's probably a bug !)
	if (aInstigatedBy == self)
	{
		return;
	} // if

	gri = SASGRI( Level.Game.GameReplicationInfo );
	bGodMode = InGodMode();
		
	tBoneName = GetClosestBoneTo(aHitLocation);
	mLastBoneHit = tBoneName;
	mLastCylinderDamageHit = mLastBoneCylinderHit;
	mLastCylinderHitTime = gri.GetLevelTime();

	// ... so we use the mLastBoneCylinderHit variable originally used for debugging the hits.
	tHitPart = mLimbCylinders [mLastBoneCylinderHit].mBodyPart;
	tType = ESASBodyParts (tHitPart);
	
	// New, shiny damage mechanism
	if (mInjuryEffects [tType].mDisableEffect == LDE_DAMAGE_CAPPED)
	{
		// GP: Now we are capping the damage to the pawn's overall incap value if the limb health is <= 0.
		limbDamage = aDamage;
		bodyDamage = aDamage;
		if ( limbDamage > mLimbHealths[tType] )
		{
			limbDamage = mLimbHealths[tType];

			// Limb is now dead, only reduce the overall health to the incapacitation level. 
			// But not on hostages which don't become incapacitated.
			if ( mPawnType != PAWN_Hostage )
			{
				maxBodyDamage = (Health - (mInitialHealth * mIncapacitationLevel))+1;
				if ( bodyDamage > maxBodyDamage )
				{
					bodyDamage = Max( maxBodyDamage, 0 );
				}
			}
		}

		// Apply limb damage.
		if ( limbDamage > 0 )
		{
			if ( !bGodMode )
			{
				mLimbHealths [tType] -= limbDamage;
				if ( mLimbHealths[tType] < 0 )
				{
					mLimbHealths[tType] = 0;
				}
				applyLimbDamageEffects (tType, limbDamage, aInstigatedBy, aHitLocation, aMomentum, aDamageType, wpn );
			}
		}

		// Apply full body damage.
		if ( bodyDamage > 0 )
		{
			if ( !bGodMode )
			{
				Super.TakeDamage( bodyDamage, aInstigatedBy, aHitlocation, aMomentum, aDamageType, wpn);
			}
		}
		else
		{
			// Still play the hit anim when disabled
			PlayTakeHit( aHitlocation, 0, aDamageType );
		}
	} // if
	else
	{
		mLimbHealths [tType] -= aDamage;

		// This limb is dead so we die - sending ourselves our default health as the damage value guarantees that we die (unless
		// our health has somehow increased from the start - which should never happen)
		if (mLimbHealths [tType] <= 0)
		{
			if ( !bGodMode )
			{
				// AI troopers are so accurate that they rarely incapacitate targets. So... want to randomly
				// incapacitate some of them when they would be about ot die.
				if (	(mPawnType == PAWN_Terrorist) &&
						(aInstigatedBy.mPawnType == PAWN_Soldier) && 
						(aInstigatedBy.Controller.mType != CONTROLLER_Player) &&
						(aDamage >= Health) &&
						(tType == BODYPART_BODY) &&
						!mbIsIncapacitated &&
						(mIncapacitationLevel > 0.0) &&
						(SASTerrorist( self ).mActDeadChance > 0.0) &&
						(FRand() < 0.25) )
				{
					// Set health to just below incapacitation level to become incapacitated.
					Health = Min( INT(mInitialHealth * mIncapacitationLevel) - 1, Health );
					if ( Health > 0 ) 
					{
						return;
					}
				}

				Super.TakeDamage (Health+1, aInstigatedBy, aHitlocation, aMomentum, aDamageType, wpn);
			} // if
		} // if

		// Otherwise apply damage as normal
		else
		{
			if ( !bGodMode )
			{
				Super.TakeDamage (aDamage, aInstigatedBy, aHitlocation, aMomentum, aDamageType, wpn);
				applyLimbDamageEffects( tType, 0, aInstigatedBy, aHitLocation, aMomentum, aDamageType, wpn );
			} // if
		} // else
	} // else
}

//------------------------------------------------------------------------------
//
//
function TakeDamageIncapacitation (
	int					aDamageAmount,
	Pawn				aInstigator,
	Vector				aHitLocation,
	Vector				aMomentum, 
	class<DamageType>	aDamageType, 
	SASWeapon			aWpn )
{
	local int				i, limbCount;
	local bool				incapacitated;

	// Don't bother checking if we're already dead or in god mode or prone (due to difference in incap and other prone anim positions)
	if (Health < 0 || InGodMode () || (meStance == STANCE_Prone) )
	{
		return;
	} // if

	// Incapacitation check on level of main health
	incapacitated = false;
	if (Health < (mInitialHealth * mIncapacitationLevel))
	{
		incapacitated = true;
	} // if

	// Check limbs. KILL_PAWN limbs (head & torso) can incapacitate on their own if badly damaged, otherwise
	// count disabled legs and arms
	else
	{
		limbCount = 0;
//		for (i = 0; i < BODYPART_UNKNOWN; i++)		// For some reason this won't compile !
		for (i = 0; i < NUM_BODY_PARTS - 1; i++)
		{
			if (mInjuryEffects [i].mDisableEffect == LDE_KILL_PAWN)
			{
				if (mLimbHealths [i] < default.mLimbHealths [i] * mInjuryEffects [i].mIncapacitation)
				{
					incapacitated = true;
					break;
				} // if
			} // if
			else
			{
				if (mLimbHealths [i] <= 0)
				{
					limbCount++;
				} // if
			} // else
		} // for

		if (limbCount >= 2)
		{
			incapacitated = true;
		} // if
	} // else

	if (incapacitated)
	{
		// Only go incapacitated if have flat ground to fall on.
		if ( (Controller != None) && (Controller.mType != CONTROLLER_Player) )
		{
			if ( SASAIController(Controller).FindDirectionToGoProne( -4550 ) )
			{
				SASAIController (Controller).DoIncapacitated( aInstigator );
			}
			else
			{
				// Damage has incapacitated us but we can't go prone so just die.
				Super.TakeDamage( Health, aInstigator, aHitlocation, aMomentum, aDamageType, aWpn );			
			}
		} // if
	} // if
}

//------------------------------------------------------------------------------
// AreaDamage
//
// apply damage from explosions etc. with devastating affect
// Damage is applied proportionately to the Pawn's default damage levels on each body part
function TakeDamageArea (
  	int					aDamage,
	Pawn				aInstigatedBy,
	Vector				aHitlocation,
	Vector				aMomentum,
	class<DamageType>	aDamageType,
	Weapon				wpn)
{
	local int			i;
	local int			totalStrength;
	local int			limbDamage;

	// Work out the proportions that each limb takes
	totalStrength = 0;
	for (i = 0; i < NUM_BODY_PARTS - 1; i++)
	{
		totalStrength += default.mLimbHealths [i];
	} // for

	if ( ( aDamage > 0 ) && !InGodMode () )
	{
		for ( i = 0; i < NUM_BODY_PARTS - 1; i++ )
		{
			limbDamage = (aDamage * default.mLimbHealths [i]) / totalStrength;
			if (limbDamage >= mLimbHealths [i])
			{
				mLimbHealths [i] = 0;
			}
			else
			{
				mLimbHealths [i] -= limbDamage;
			}
		}

		Super.TakeDamage ( aDamage, aInstigatedBy, aHitlocation, aMomentum, aDamageType, wpn);
	}
}


////////////////////////////////////////////////////////////////////////////////
// TakeDamageEffects
//
function TakeDamageEffects (
	vector	aHitLocation )
{
	ClientTakeDamageEffects ( aHitLocation );
}

////////////////////////////////////////////////////////////////////////////////
// ClientTakeDamageEffects
//
simulated function ClientTakeDamageEffects (
	vector	aHitLocation )
{
	local SASPlayerController	tPC;
	local Vector				tTemp;
	local float					blurAlpha;
	local Vector				tTemper;
	
	if ( ( Controller != None ) && ( Controller.mType == CONTROLLER_Player ) )
	{
		tPC = SASPlayerController ( Controller );
		
		tTemp = aHitLocation - Location;
		tTemper = tTemp;
		tTemper.Z = 0;
		tTemper = Normal( tTemp );
		tTemp = Normal ( tTemp << Rotation );

		//We the man! - show damage on the hud
		SASHUD ( tPC.myHUD ).DisplayTakeDamage ( tTemp,tTemper,true );

		blurAlpha = tPC.mMotionBlurEffect.BlurAlpha - 2;
		if ( blurAlpha > 10 )
		{
			tPC.DecayMotionBlur ( blurAlpha );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyShotSomeone
//
// Feedback message that we hit someone with a non-grenade weapon.
function NotifyShotSomeone(
	SASPawn	aDamaged );


///////////////////////////////////////////////////////////////////////////////
// TakeDamage
//
function TakeDamage(
	int					aDamage,
	Pawn				aInstigatedBy,
	Vector				aHitlocation,
	Vector				aMomentum,
	class<DamageType>	aDamageType,
	optional Weapon		wpn)
{
	local bool			bMustPlaySpeech,
						wasDead,
						isNowDead,
						wasIncapacitated,
						isNowIncapacitated,
						bOldMissionComplete;
	local SASPRI		pri;
	local SASGRI		gri;
	local SASTerroristController tc;
	local SASWeapon		SASwpn;

	// Bail out if this is a friendly fire incident and friendly fire is disabled.
	if (GetGame() != None && !GetGame().bAllowFriendlyFire)
	{
		if (aInstigatedBy != None && aInstigatedBy.Controller.PlayerReplicationInfo.Team == Controller.PlayerReplicationInfo.Team)
		{
			return;
		}
	}
	
	if (aInstigatedBy != None && wpn == None)
	{
		SASwpn = SASWeapon ( aInstigatedBy.Weapon );
	} // if
	else
	{
		SASwpn = SASWeapon (wpn);
	} // else

	// Get terrorist controller now since if we're killed, it goes :-/
	if ( Controller != None && Controller.mType == CONTROLLER_AITerrorist )
	{
		tc = SASTerroristController (Controller);
	}

	wasDead = IsDead();
	wasIncapacitated = mbIsIncapacitated;

	// If this pawn has been flagged as being monitored by scripts for damage then pass event
	// onto script manager.
	if ( mbNotifyScriptsOfDamage )
	{
		GetGame().PawnDamaged( self );
	}

	// if it's not a weapon (it could be a script action that's doing the damage), or it's a grenade,
	// just do general damage to the dude
	if ( SASWpn == None || SASwpn.mCategory == WPNCAT_Grenade ) //GRENADECAT_Explosive )
	{
		// Grenades thrown by scripted AI don't damage other scripted AI
		if (	aInstigatedBy != None && 
				aInstigatedBy.Controller.mType == CONTROLLER_AIScripted &&
				Controller.mType == CONTROLLER_AIScripted )
		{
			return;
		}

		TakeDamageArea ( aDamage, aInstigatedBy, aHitlocation, aMomentum, aDamageType, SASwpn );
		StackTrace ();
	}
	else
	{
		if ( aInstigatedBy != None )
		{
			// Feedback hit to the instigator.
			SASPawn( aInstigatedBy ).NotifyShotSomeone( self );
		}

		TakeDamagePoint ( aDamage, aInstigatedBy, aHitlocation, aMomentum, aDamageType, SASwpn );
	}

	if ( mPawnType == PAWN_Terrorist )
	{
		gri = SASGRI ( Level.GetLocalPlayerController().GameReplicationInfo );
		bOldMissionComplete = gri.mbRoundComplete;
	}

	if ( mPawnType != PAWN_Hostage )
	{
		TakeDamageIncapacitation ( aDamage, aInstigatedBy, aHitLocation, aMomentum, aDamageType, SASWpn );
	}
	
	// If this incapacitation results in mission ending and its a terrorist then 
	// force him to be killed he ragdolls (for bullet cam).
	if ( mPawnType == PAWN_Terrorist && mbIsIncapacitated )
	{
		if ( !bOldMissionComplete && gri.mbRoundComplete )
		{
			// Set health to zero to force death and call Pawn.TakeDamage to kill.
			Health = 1;
			Super.TakeDamage( 10, aInstigatedBy, aHitLocation, aMomentum, aDamageType, SASWpn );

			wasIncapacitated = true;
		}
	}

	TakeDamageEffects ( aHitLocation );

	isNowDead = IsDead();
	isNowIncapacitated = mbIsIncapacitated;

	// Play a hit sound.
	bMustPlaySpeech = (mLastTakeHitTime < (Level.TimeSeconds - 1.0));
	mLastTakeHitTime = Level.TimeSeconds;
	// Don't play if dead or if just become incapacitated.
	if ( !isNowDead && (!wasIncapacitated || isNowIncapacitated) )
	{
		if ( !PlaySpeech( SPEECH_GenHit, bMustPlaySpeech ) )
		{
			// If not playing speech, still want to make noise to alert nearby AI.
			MakeNoise( mVoice.mShoutAILoudness );
		}
	}

	// Record player frags and stats - terrorist kills only
	if (	(aInstigatedBy != None) && 
			(aInstigatedBy.Controller.mType == CONTROLLER_Player) && 
			(mPawnType == PAWN_Terrorist) )
	{
		pri = SASPRI (SASPlayerController (aInstigatedBy.Controller).PlayerReplicationInfo);

		// Started OK but have been incapacitated by this hit.
		// GP: Now updating incap count in SASAIController.DoIncapacitated() - this stops
		// us recording this stat when the terrorist is really acting dead.
		//if ( !isNowDead && !wasIncapacitated && isNowIncapacitated SASTerrorist )
		//{
		//	pri.mPlayerEnemiesIncapacitated++;
		//} // if

		if ( !wasDead && isNowDead )
		{
			// If we were incapacitated before this, decrement the player incap count
			if ( wasIncapacitated )
			{
				pri.mPlayerEnemiesIncapacitated--;

				// If incapacitated time was long enough ago then count this as an execution.
				if ( Level.TimeSeconds - mIncapacitationTime > 1.0 )
				{
					pri.mPlayerRuthlessKiller = true;
				}
			} // if

			pri.mPlayerKills++;

			if ( SASwpn != None )
			{
				switch ( SASWpn.mCategory )
				{
				case WPNCAT_Knife:
					pri.mPlayerKnifeKills++;
					break;

				case WPNCAT_Grenade:
					pri.KilledEnemyWithGrenade();
					break;

				default:
					// Headshot?
					if (mLimbCylinders [mLastBoneCylinderHit].mBodyPart == 0)
					{
						pri.mPlayerHeadShotKills++;
					} // if
					break;
				}
			} // if

			// Terrorist killed without firing a shot
			if (tc != None)
			{
				if (tc.mbHasFired == false)
				{
					pri.mPlayerNinjaCount++;
				} // if
			} // if
		} // if
	} // if
}


//-----------------------------------------------------------------------------
// ServerDoPunchedByPlayer
//
// Called on server by clients to punch AI terrorists/hostages. Won't actually 
// be punched unless server thinks AI can be.
function ServerDoPunchedByPlayer( 
	SASPawn	aHitBy )
{
	if (	Role == ROLE_Authority && 
			Controller != None &&
			Controller.mType != CONTROLLER_Player )
	{
		SASAIController( Controller ).ServerDoPunchedByPlayer( aHitBy );
	}
}


///////////////////////////////////////////////////////////////////////////////
// HitPunchTarget
//
simulated function HitPunchTarget()
{
	local SASPlayerController	PC;
	local Vector				ofs;

	if ( mPunchTarget != None && Controller != None && Controller.mType == CONTROLLER_Player )
	{
		PC = SASPlayerController( Controller );

		if ( mPunchTarget.CanBePunched() )
		{
			ofs = mPunchTarget.Location - Location;
			if ( VSizeSq(ofs) < Square( PUNCH_MAX_DIST ) )
			{
				ofs.Z = 0.0;
				ofs = Normal(ofs);
				if ( (ofs Dot YawDirection()) > Cos( PUNCH_MAX_ANGLE ) )
				{
					pc.ServerPunchPawn( mPunchTarget );
				}
			}
		}

		mPunchTarget = None;
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyStartedCuffing
//
function NotifyStartedCuffing()
{
	// Only allowed on server.
	if ( Role != ROLE_Authority )
	{
		return;
	}

	// Can only do this on AI controlled pawns.
	if ( Controller == None || Controller.mType == CONTROLLER_Player )
	{
		return;
	}

	SASAIController( Controller ).NotifyStartedCuffing();
}


///////////////////////////////////////////////////////////////////////////////
// NotifyStoppedCuffing
//
function NotifyStoppedCuffing()
{
	// Only allowed on server.
	if ( Role != ROLE_Authority )
	{
		return;
	}

	// Can only do this on AI controlled pawns.
	if ( Controller == None || Controller.mType == CONTROLLER_Player )
	{
		return;
	}

	SASAIController( Controller ).NotifyStoppedCuffing();	
}


///////////////////////////////////////////////////////////////////////////////
// MakeCaptive
//
function MakeCaptive(
	SASPlayerController	aInstigatingPlayer )
{
	switch( mPawnType )
	{
	case PAWN_Terrorist:
	case PAWN_Hostage:
		Captured( aInstigatingPlayer );
		break;

	default:
		Warn( "SASPawn.MakeCaptive called on pawn <"$self$"> with invalid pawn type <"$mPawnType$">" );
	}
}


///////////////////////////////////////////////////////////////////////////////
// Captured
//
function Captured(
	SASPlayerController	aInstigatingPlayer )
{
	local SASGRI		gri;
	local SASPRI		pri;
	local SASGameInfo	gi;

	if ( !mbCaptured )
	{
		mbCaptured			= true;
		SetCombatCapable( false );

		if ( (Controller != None) && (Controller.mType != CONTROLLER_Player) )
		{
			SASAIController( Controller ).NotifyCaptured();
		}

		ChangeAnimation();

		gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );
		if ( gri != None )
		{
			gri.PawnCaptured ( self );
		}

		// Update stat in PRI
		if ( aInstigatingPlayer != None )
		{
			pri = SASPRI( aInstigatingPlayer.PlayerReplicationInfo );
			if ( pri != None )
			{
				pri.mPlayerArrests++;
			}
		}

		// Inform scripts of capture event.
		gi = SASGameInfo ( Level.Game );
		if ( gi != None )
		{
			gi.PawnCaptured ( self );
		}
	}
}


////////////////////////////////////////////////////////////////////////////////
// SetCombatCapable
//
function SetCombatCapable( 
	bool bNewCombatCapable )
{
	local Controller C;

	// When becoming non-combat capable, notify other controllers.
	if ( mbIsCombatCapable && !bNewCombatCapable )
	{
		for ( C = Level.ControllerList; C != None; C = C.nextController )
		{
			C.NotifyPawnNotCombatCapable( self );
		}
	}

	mbIsCombatCapable = bNewCombatCapable;
}

////////////////////////////////////////////////////////////////////////////////
// ServerOpenCloseDoor
//
// server-side toggle open-close door
function ServerOpenCloseDoor (Mover aDoor)
{
	if ( aDoor != None )
	{
		if ( aDoor.KeyNum == 0 || aDoor.KeyNum < aDoor.PrevKeyNum )
		{
			aDoor.Trigger( Controller, self );
		}
		else
		{
			aDoor.Untrigger( Controller, self );
		}
	}
}

//------------------------------------------------------------------------------
//
//
function Evacuated ()
{
	local SASGRI	gri;
	local SASGameInfo	gi;

	gi = SASGameInfo ( Level.Game );
	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( gri != None )
	{
		gri.PawnEvacuated ( self );
	}

	// Inform scripts of evacuation event
	if ( gi != None )
	{
		gi.PawnEvacuated ( self );
	}
}


//------------------------------------------------------------------------------
//
//
function Died ( Controller Killer, class<DamageType> damageType, vector HitLocation )
{
	local SASGRI				gri;
	local SASPRI				pri;
	local SASGameInfo			gi;
	local SASPlayerController	pc;
	local SASPawn				killerPawn;

	gi = SASGameInfo ( Level.Game );
	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );
	pc = SASPlayerController ( Controller );

	if ( ( pc != None ) && ( pc.mSquadManager != None ) )
	{
		pc.mSquadManager.PlayerDied ( SASSoldier ( self ) );
	}

	// Clear any pending speech
	if ( mVoice != None )
	{
		mVoice.ClearDelayedSpeechFor( self );
	}

	// Make sure we haven't already told the game controllers that we're dead
	if (Killer != None)
	{
		killerPawn = SASPawn (Killer.Pawn);
	} // if

	// Flag in player stats if player killed a captured terrorist.
	if ( (pc != None) && (mPawnType == PAWN_Terrorist) && mbCaptured )
	{
		pri = SASPRI( pc.PlayerReplicationInfo );
		if ( pri != None )
		{
			++pri.mPlayerKilledCaptive;
		}
	}
	
	if ( gri != None )
	{
		gri.PawnKilled ( self, killerPawn );
	}
	if ( gi != None )
	{
		gi.PawnKilled ( self, killerPawn);
	}

	Super.Died ( Killer, damageType, HitLocation );
}

//-----------------------------------------------------------------------------
// Stun
//
function Stun(
	float					aStunAmount,
	int						aStunType,
	SASGenericExplosion		aExplosion )
{
	local float				scale;
	local float				time;
	local float				dp, facing;
	local vector			dirToExplosion;
	local SASAIController	myAIController;

	// No effect on the dead or dying
	if (IsDead () || mbIsIncapacitated)
	{
		return;
	} // if

	if ( aStunType == aExplosion.STUNTYPE_Flash )
	{
		// Scale down flash amount depending on how face on pawn is.
		if ( mFlashBehindMeMod < 1.0 )
		{
			// How face on is pawn to flash? (range 0 to 1)
			dirToExplosion = Normal( Location - aExplosion.Location );
			dp = dirToExplosion Dot Vector( GetViewRotation() );
			facing = (dp + 1.0) * 0.5;
			facing = FClamp( facing, 0.0, 1.0 );

			aStunAmount = aStunAmount * Lerp( facing, mFlashBehindMeMod, 1.0 );
		}

		// Modify sight ability due to flash
		scale = mFlashMaxSightMod * aStunAmount;
		mStunnedSightMod = FMin( mStunnedSightMod, scale );
	}
	else if ( aStunType == aExplosion.STUNTYPE_Bang )
	{
		// Modify hearing ability due to bang
		scale = mBangMaxHearingMod * aStunAmount;
		mStunnedHearingMod = FMin( mStunnedHearingMod, scale );
	}

	// Apply jump in heart rate
	mHeartRate += ( mStunMaxHeartRateInc * aStunAmount );
	mHeartRate = Min( mHeartRate, mHeartRateMax );

	// Controller deals with disorientation due to stun
	if ( Controller != None )
	{
		myAIController = SASAIController(Controller);
		if ( myAIController != None )
		{
			if ( aStunAmount > myAIController.mStunnedThreshold )
			{
				// Calculate disorientation time. Scale applied stun time linearly by stun amount.
				scale = (aStunAmount - myAIController.mStunnedThreshold) / (1.0 - mStunDisorientThreshold);
				scale = Min( scale, 1.0 );
				time = Lerp( scale, mStunDisorientTime.Min, mStunDisorientTime.Max );

				if ( time > 0.0 )
				{
					myAIController.DoStunned( time );

					// Apply surprised accuracy modifier.
					Surprised();
				}
			}

			// Increment threshold for successive disorientation.
			myAIController.mStunnedThreshold += mStunDisorientThresholdIncPerStun;

			// Now we've been stunned, the min threshold is the alerted threshold.
			myAIController.SetAlert( true );
			myAIController.mStunnedThreshold = FMax( myAIController.mStunnedThreshold, mStunDisorientThresholdAlert );
		}
		else if ( SASPlayerController(Controller) != None )
		{
			if ( aStunType == aExplosion.STUNTYPE_Flash )
			{
				//SASPlayerController(Controller).DoScreenWhiteOut( aStunAmount );
				// replaced by SASHud.FlashBangWhiteOut
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// DoGassed
//
// Event called when pawn is in CS gas
function DoGassed (
	float duration)				// Time to be gassed for
{
	if (mbHasGasMask)
	{
		// Gas mask ? no effect then
		return;
	} // if
	else
	{
		// Pass message through to AI controller
		if ( Controller != None )
		{
			if ( (Controller.mType != CONTROLLER_Player) && (Controller.mType != CONTROLLER_AIScripted) )
			{
				SASAIController (Controller).DoGassed (duration);
			}
			else
			{
				//Warn ("!!Player found without gas mask !!");
			}
		}
	} // else
} // DoGassed


///////////////////////////////////////////////////////////////////////////////
// BulletHitNearby
//
// Event called when a bullet hits close to the pawn.
function BulletHitNearby(
	SASAmmo		aBullet,
	vector		aHitLocation );


//-----------------------------------------------------------------------------
// IsAlive
//
// can be called on client's version of replicated pawn
simulated function bool IsAlive()
{
	return (Health > 0);
}


///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
// SetFiringPose
//
simulated function SetFiringPose(
	int	aNewFiringPose )
{
	if ( aNewFiringPose != mFiringPose )
	{
		mFiringPoseChangeTime = Level.TimeSeconds;
	}
	mFiringPose = aNewFiringPose;

	// Don't play aim animations when not firing normally.
	if ( mFiringPose != FIRINGPOSE_Normal )
	{
		StopAiming();
	}
}

//-----------------------------------------------------------------------------
// CalcDrawOffset
//
simulated function vector CalcDrawOffset (
	Inventory	aInv)
{
	local vector	drawOffset;

	// Use default offset calculation if item is not an SASWeapon
	if (SASWeapon(aInv) == None)
	{
		return Super.CalcDrawOffset (aInv);
	}

	if (Controller == None)
	{
		return (aInv.PlayerViewOffset >> Rotation) + BaseEyeHeight * vect(0,0,1);
	}

	//drawOffset = ((0.9/Weapon.DisplayFOV * 100 * ModifiedPlayerViewOffset (aInv)) >> aInv.Rotation);
//	drawOffset = ModifiedPlayerViewOffset (aInv) >> aInv.Rotation;
	drawOffset = aInv.PlayerViewOffset >> aInv.Rotation;

	if (!IsLocallyControlled())
	{
		drawOffset.Z += BaseEyeHeight;
	}
	else
	{
		drawOffset.Z += EyeHeight;
        if (bWeaponBob)
		{
			drawOffset += WeaponBob (aInv.BobDamping);
		}
	}

	return drawOffset;
}


//-----------------------------------------------------------------------------
// WeaponBob
//
function vector WeaponBob (
	float	aBobDamping)
{
	local vector	WBob;

	if (SASWeapon(Weapon) != None)
	{
		return (WalkBob + SASWeapon(Weapon).GetInertialBobOffset ()) * aBobDamping;
	}
	else
	{
		WBob = aBobDamping * WalkBob;
		WBob.Z = (0.45 + 0.55 * aBobDamping) * WalkBob.Z;
		return WBob;
	}
}


//-----------------------------------------------------------------------------
// CheckBob
//
// Called by player controller when moving.
// Plays footstep sounds and adds camera bob
function CheckBob (
	float	deltaTime,	// Change in bobTime (see Pawn.CheckBob)
	vector	Y)			// Bob direction
{
	local float oldBobTime;

	oldBobTime = BobTime;
	Super.CheckBob (deltaTime, Y);

	// Only play footsteps if not walking or crouching and pawn's controller is a player controller
	// and in 1st person mode.
	if ((Physics != PHYS_Walking)
//		|| (mePace == PACE_Walking)
		|| meStance == STANCE_Crouched
//		|| (VSizeSq (Velocity) < Square(10.0))
		|| (VSize (Velocity) < 10.0)
		|| ((PlayerController(Controller) != None) && PlayerController(Controller).bBehindView))
	{
		return;
	}
}


//-----------------------------------------------------------------------------
// WeaponAfter
//
// Search inventory for weapon after aPreceedingWeapon in list.
function Weapon WeaponAfter(
	Weapon aPreceedingWpn)
{
	local Inventory	inv;
	local Weapon	invWpn;

	// Search for next weapon in inventory after aPreceedingWpn
	for (inv = aPreceedingWpn.Inventory; inv != None; inv = inv.Inventory)
	{
		invWpn = Weapon(inv);
		if (invWpn != None && invWpn.HasAmmo())
		{
			return invWpn;
		}
	}

	// Weapon not found after aPreceedingWpn in inventory list, search
	// from start of list upto aPreceedingWpn
	for (inv = Inventory; (inv != None) && (inv != aPreceedingWpn); inv = inv.Inventory)
	{
		invWpn = Weapon(inv);
		if (invWpn != None && invWpn.HasAmmo())
		{
			return invWpn;
		}
	}

	// No other weapons found in inventory
	return None;
}


//-----------------------------------------------------------------------------
// WeaponBefore
//
// Search inventory for weapon before aProceedingWeapon in list.
function Weapon WeaponBefore(
	Weapon aProceedingWpn)
{
	local Inventory	inv;
	local Weapon	invWpn;
	local Weapon	curChoice;

	// Search for prev weapon in inventory before aProceedingWpn
	for (inv =Inventory; (inv != None) && (inv !=  aProceedingWpn); inv = inv.Inventory)
	{
		invWpn = Weapon(inv);
		if (invWpn != None && invWpn.HasAmmo())
		{
			curChoice = invWpn;
		}
	}

	if (curChoice == None)
	{
		// Weapon not found before aProceedingWpn in inventory list, search
		// though inventory items after aProceedingWpn to end of list.
		for (inv = aProceedingWpn.Inventory; inv != None; inv = inv.Inventory)
		{
			invWpn = Weapon(inv);
			if (invWpn != None && invWpn.HasAmmo())
			{
				curChoice = invWpn;
			}
		}
	}

	return curChoice;
}


//-----------------------------------------------------------------------------
// SelectWeapon
//
function bool SelectWeapon(
	EWeaponCategory				aWeapCategory,
	optional EGrenadeCategory	aSubCategory )
{
	local Inventory	inv;
	local SASWeapon	wpn;

	if ( aWeapCategory == WPNCAT_Grenade )
	{
		return SelectGrenadeWeapon( aSubCategory );
	}

	// Check if already selected
	wpn = SASWeapon ( Weapon );
	if (wpn != None && wpn.HasAmmo() )
	{
		if (wpn.mCategory == aWeapCategory)
		{
			// If we have a pending weapon, need to make current weapon the pending weapon
			// and bring up.
			if ( PendingWeapon != None )
			{
				PendingWeapon = wpn;
				ChangedWeapon();
			}
			return true;
		}
	}

	// Search for weapon type in inventory chain
	for ( inv = Inventory; inv != None; inv = inv.Inventory )
	{
		wpn = SASWeapon( inv );
		if ( (wpn != None)
			&& (wpn.mCategory == aWeapCategory)
			&& wpn.HasAmmo() )
		{
			PendingWeapon = wpn;

			if ( Weapon == None )
			{
				ChangedWeapon ();
			}
			else
			{
				Weapon.PutDown ();
			}

			return true;
		}
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////
// SelectPrimaryWeapon
//
function bool SelectPrimaryWeapon ()
{
	return SelectWeapon ( WPNCAT_Primary );
}

////////////////////////////////////////////////////////////////////////////////
// SelectBestWeapon
//
// run through all categories of weapon until best one is found.
// the order searched should probably change.
function bool SelectBestWeapon ()
{
	if ( !SelectWeapon ( WPNCAT_Primary ) )
	{
		if ( !SelectWeapon ( WPNCAT_Secondary ) )
		{
			if ( !SelectWeapon ( WPNCAT_Special ) )
			{
				if ( !SelectGrenadeWeapon ( GRENADECAT_Explosive ) )
				{
					if ( !SelectGrenadeWeapon ( GRENADECAT_Molotov ) )
					{
						if ( !SelectGrenadeWeapon ( GRENADECAT_Stun ) )
						{
							if ( !SelectGrenadeWeapon ( GRENADECAT_Gas ) )
							{
								if ( !SelectGrenadeWeapon ( GRENADECAT_Smoke ) )
								{
									if ( !SelectWeapon ( WPNCAT_Knife ) )
									{
										return false;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return true;
}

////////////////////////////////////////////////////////////////////////////////
// SelectGrenadeWeapon
//
function bool SelectGrenadeWeapon(
	EGrenadeCategory	aGrenadeCategory )
{
	local Inventory			tInv;
	local SASGrenadeWeapon	tGrenadeWpn;

	// Check if already selected
	if ( Weapon != None )
	{
		tGrenadeWpn = SASGrenadeWeapon( Weapon );
		if ( (tGrenadeWpn != None) && (tGrenadeWpn.mGrenadeCategory == aGrenadeCategory) )
		{
			// If we have a pending weapon, need to make current weapon the pending weapon
			// and bring up.
			if ( PendingWeapon != None )
			{
				PendingWeapon = tGrenadeWpn;
				ChangedWeapon();
			}
			return true;
		}
	}

	// Search for grenade type in inventory chain
	for ( tInv = Inventory; tInv != None; tInv = tInv.Inventory )
	{
		tGrenadeWpn = SASGrenadeWeapon( tInv );
		if ( (tGrenadeWpn != None)
			&& (tGrenadeWpn.mGrenadeCategory == aGrenadeCategory)
			&& tGrenadeWpn.HasAmmo() )
		{
			PendingWeapon = tGrenadeWpn;

			if ( Weapon == None )
			{
				ChangedWeapon();
			}
			else
			{
				Weapon.PutDown();
			}

			return true;
		}
	}

	return false;
}


//-----------------------------------------------------------------------------
// CycleGrenadeWeapon
//
function bool CycleGrenadeWeapon()
{
	local Inventory			inv;
	local SASGrenadeWeapon	curSelectedGrenade;
	local SASGrenadeWeapon	nextGrenade;

	PendingWeapon = None;

	if (Weapon != None)
	{
		curSelectedGrenade = SASGrenadeWeapon(Weapon);
	}

	if (curSelectedGrenade != None)
	{
		// Search forward in inventory chain for next grenade after
		// currently selected grenade.
		for (inv = curSelectedGrenade.Inventory; inv != None; inv = inv.Inventory)
		{
			if ((SASGrenadeWeapon(inv) != None) && SASGrenadeWeapon(inv).HasAmmo())
			{
				nextGrenade = SASGrenadeWeapon(inv);
				break;
			}
		}
	}

	if (nextGrenade == None)
	{
		// Search from start of inventory chain for first instance
		// of a grenade weapon.
		for (inv = Inventory; (inv != None) && (inv != curSelectedGrenade); inv = inv.Inventory)
		{
			if ((SASGrenadeWeapon(inv) != None) && SASGrenadeWeapon(inv).HasAmmo())
			{
				nextGrenade = SASGrenadeWeapon(inv);
				break;
			}
		}
	}

	if (nextGrenade != None)
	{
		PendingWeapon = nextGrenade;

		if (Weapon == None)
		{
			ChangedWeapon();
		}
		else
		{
			Weapon.PutDown();
		}

		return true;
	}

	return false;
}


//-----------------------------------------------------------------------------
// HasAGrenade
//
// Returns true if pawn has a grenade of any type with ammo available.
simulated function bool HasAGrenade()
{
	local Inventory		inv;
	local SASWeapon		invWpn;

	for ( inv = Inventory; inv != None; inv = inv.Inventory )
	{
		invWpn = SASWeapon( inv );

		if (	(invWpn != None) && 
				(invWpn.mCategory == WPNCAT_Grenade) &&
				invWpn.HasAmmo() )
		{
			return true;
		}
	}

	return false;
}


//-----------------------------------------------------------------------------
// GetWeaponOfCategory
//
// Returns weapon of specified category (and specified sub-category for grenades)
// if one exists in the pawn's inventory.
event SASWeapon GetWeaponOfCategory(
	EWeaponCategory				aMatchingCategory,
	optional EGrenadeCategory	aMatchingSubCategory )
{
	local Inventory			inv;
	local SASWeapon			invWpn;
	local SASGrenadeWeapon	invGrenadeWpn;

	for ( inv = Inventory; inv != None; inv = inv.Inventory )
	{
		invWpn = SASWeapon( inv );

		if ( (invWpn != None) && (invWpn.mCategory == aMatchingCategory) )
		{
			invGrenadeWpn = SASGrenadeWeapon( invWpn );
			if ( invGrenadeWpn != None )
			{
				// For grenades, need to check that grenade sub-category matches.
				if ( invGrenadeWpn.mGrenadeCategory == aMatchingSubCategory )
				{
					return invWpn;
				}
			}
			else
			{
				return invWpn;
			}
		}
	}

	return None;
}


//-----------------------------------------------------------------------------
// GetWeaponOfMatchingCategory
//
// Returns weapon of category matching that of a specified weapon class if
// one exists in the pawn's inventory.
function SASWeapon GetWeaponOfMatchingCategory(
	class<SASWeapon>	aMatchingClass )
{
	local EWeaponCategory	wpnCat;
	local EGrenadeCategory	wpnSubCat;

	wpnCat = aMatchingClass.Default.mCategory;

	if ( class<SASGrenadeWeapon>(aMatchingClass) != None )
	{
		wpnSubCat = class<SASGrenadeWeapon>( aMatchingClass ).Default.mGrenadeCategory;
	}

	return GetWeaponOfCategory( wpnCat, wpnSubCat );
}


//-----------------------------------------------------------------------------
// ChangedWeapon
//
// Called as pawn just changed to PendingWeapon.
function ChangedWeapon ()
{
	// Cache current weapon before changing
	mPrevWeapon = SASWeapon( Weapon );

	Super.ChangedWeapon();

	// Update rotation rate, speed modifiers for held weapon
	AdjustMotionParamsForWeapon();
}


//-----------------------------------------------------------------------------
// AdjustMotionParamsForWeapon
//
// Called when a new weapon is selected.
// Update rotation and speed parameters due to weight of weapon.
simulated function AdjustMotionParamsForWeapon ()
{
	local float	rotnScale;

	if (SASWeapon(weapon) != None)
	{
		// Speed scalar
		mWeaponSpeedMod = 1.0 - (mBaseWeaponSpeedMod * SASWeapon(Weapon).mWeight);
		mWeaponSpeedMod = FClamp(mWeaponSpeedMod, 0.0, 1.0);

		// Rotation rate scalar
		rotnScale = 1.0 - (mBaseWeaponRotnMod * SASWeapon(Weapon).mWeight);
		rotnScale = FClamp(rotnScale, 0.0, 1.0);
	}
	else
	{
		mWeaponSpeedMod = 1.0;
		rotnScale = 1.0;
	}

	// Apply rotation rate scalar to pawn and controller rotation values
	RotationRate		= Default.RotationRate * rotnScale;
	AcquisitionYawRate	= Default.AcquisitionYawRate * rotnScale;
	if (Controller != None)
	{
		Controller.RotationRate	= Controller.Default.RotationRate * rotnScale;
	}

	// Speed scalar applied in ModifyVelocity(), called per tick
}


//-----------------------------------------------------------------------------
// AcquiredNewTarget
//
simulated function AcquiredNewTarget ()
{
	if ( (Controller.mType == CONTROLLER_AiSoldier) || (Controller.mType == CONTROLLER_AiTerrorist) )
	{
		//mTargettingSpreadAngleMod	= mShooterSpreadAngleNewTargetMod;
	}
}


///////////////////////////////////////////////////////////////////////////////
// NotifyPreWeaponFire
//
// Event recieved from weapon to indicate that shot is about to be fired.
// Used to update the mShooterNoHitZoneCurrrent param before the shot accuracy is
// calculated.
function NotifyPreWeaponFire()
{
	if ( (Controller.mType == CONTROLLER_AiSoldier) || (Controller.mType == CONTROLLER_AiTerrorist) )
	{
		if ( (mLastFiredTime == 0.0)
			|| (Level.TimeSeconds > (mLastFiredTime + mShooterNoHitZoneTimeout)) )
		{
			mShooterNoHitZoneCurrrent = mShooterNoHitZoneBase;
		}
	}

	mLastFiredTime = Level.TimeSeconds;
}


///////////////////////////////////////////////////////////////////////////////
// Surprised
//
simulated function Surprised();


///////////////////////////////////////////////////////////////////////////////
// CheckWeaponPointing
//
event CheckWeaponPointing()
{
	Warn( "CheckWeaponPointing recieved for pawn <"$self$"> which does not handle this event." );
}


//-----------------------------------------------------------------------------
// AnimEnd
//
// Event notifying end of animation (whether looping or not) on any channel.
simulated event AnimEnd(
	int		aChannel )
{
	local bool bNoBlend;

	switch ( aChannel )
	{
	case 0:
		if ( (Controller == None) || !Controller.bControlAnimations )
		{
			if ( meStance == STANCE_Prone || mbIsIncapacitated )
			{
				bNoBlend = true;
			}
			PlayWaiting(bNoBlend);
		}
		break;

	case ANIMCHANNEL_FIRING:
		if ( (Controller == None) || (Controller.bFire == 0) )
		{
			AnimBlendToAlpha( aChannel, 0, 0.2 );
		}
		break;

	case ANIMCHANNEL_AIMING:
		if ( (Controller == None) || !mbAiming )
		{
			AnimBlendToAlpha( aChannel, 0, 0.2 );
		}
		break;

	case ANIMCHANNEL_ACTION:
		
		// If client and root motion is locked then unlock it.
		if ( Level.NetMode != NM_Standalone && Role < ROLE_Authority )
		{
			LockRootMotion( 0 );
		}

		// Special cases where we need to loop this channel until further notice.
		if ( Health > 0 && !bTearOff )
		{
			if ( mbStunned )
			{
				AnimateStunned();
				return;
			}
			else if ( mbGassed )
 			{
				AnimateGassed();
				return;
			}
			else
			{
				AnimBlendToAlpha( aChannel, 0, 0.0 );
			}
		}
		else
		{
			AnimBlendToAlpha( aChannel, 0, 0.0 );
		}	
		break;

	case ANIMCHANNEL_HIT:
		AnimBlendToAlpha( aChannel, 0, 0.1 );
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimNotifyDropWeapon
//
simulated event AnimNotifyDropWeapon()
{
	DropWeapon();
}


///////////////////////////////////////////////////////////////////////////////
// DropWeapon
//
simulated function DropWeapon()
{
	if ( Weapon != None )
	{
		mbInstantWeaponDrop = true;
		TossWeapon( Velocity );
		mbInstantWeaponDrop = false;
		Weapon = None;
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimNotifySetWeapon
// 
simulated event AnimNotifySetWeapon()
{
	Controller.AnimNotifySetWeapon();
}


//-----------------------------------------------------------------------------
// Debug message functions
//::function setHUDMessage (string mesg)
//::{
//::	mDebugMessageHUD = mesg;
//::} // setHUDMessage

//::function clearHUDMessage ()
//::{
//::	// 32 spaces in this to completely blank the message
//::	setHUDMessage ("                                ");
//::} // clearHUDMessage


//------------------------------------------------------------------------------
// BroadcastShowMessage
//
/*
function BroadcastShowMessage(
	EShoutType	aeShoutType );
*/

///////////////////////////////////////////////////////////////////////////////
// PlayActionAnim
//
// Play animation on the 'action' channel. This channel is higher than idle, firing
// and movement anim channels so will get played over the top of them.
simulated event PlayActionAnim(
	name			aAnim,
	optional float	aRate,
	optional float	aBlendTime,
	optional bool	abChannelInstantBlend,		
	optional bool	abUpperBodyOnly,
	optional bool	abRootMotion,
	optional bool	abPlayLocallyOnly )
{
	local float	channelBlendTime;
	local name	blendBone;

	if ( aAnim == 'None' )
	{
		return;
	}

	if ( abUpperBodyOnly )
	{
		blendBone = SPINE_BONE;
	}

	AnimBlendParams( ANIMCHANNEL_Action, 1.0, 0.0, 0, blendBone, true );

	if ( aRate == 0.0 )
	{
		aRate = 1.0;
	}

	if ( abChannelInstantBlend )
	{
		channelBlendTime = 0.0;
	}
	else
	{
		channelBlendTime = 0.15;
	}

	PlayAnim( aAnim, aRate, aBlendTime, ANIMCHANNEL_ACTION );
	AnimBlendToAlpha( ANIMCHANNEL_ACTION, 1.0, channelBlendTime );

	if ( Level.NetMode == NM_Standalone || Role == ROLE_Authority )
	{
		// Server/single player - turn on/off root motion as required.
		if ( abRootMotion )
		{
			StartRootMotion( true );
		}
		else if ( Physics == PHYS_RootMotion )
		{
			SetPhysics( PHYS_Walking );
		}
	}
	else if ( !IsLocallyControlled() )
	{
		// Client - lock root motion if root motion anim.
		if ( abRootMotion )
		{
			LockRootMotion( 1 );
		}
		else
		{
			LockRootMotion( 0 );
		}
	}

	// Make server replicate this to clients.
	if ( !abPlayLocallyOnly && Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		SetReplicatedActionAnim( 
			aAnim,
			aRate,
			aBlendTime,
			abChannelInstantBlend,
			abUpperBodyOnly,
			abRootMotion );
	}
}


///////////////////////////////////////////////////////////////////////////////
// EndPlayActionAnim
//
simulated event EndPlayActionAnim(
	optional float	aBlendOutTime )
{
	AnimBlendToAlpha( ANIMCHANNEL_ACTION, 0.0, aBlendOutTime );

	// Make server replicate this to clients.
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		SetReplicatedActionAnim( 
			'',
			0.0,
			aBlendOutTime,
			false,
			false,
			false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// LoopIfNeeded
//
simulated function LoopIfNeeded(
	name			aAnimName,
	float			aAnimRate,
	float			aBlendTime,
	optional int	aChannel )
{
	local name	curAnimName;
	local float frame, curAnimRate;

	GetAnimParams( aChannel, curAnimName, frame, curAnimRate );

	if ( !IsAnimLooping( aChannel )
		|| !IsAnimating( aChannel )
		|| (aAnimName != curAnimName)
		|| (aAnimRate != curAnimRate) )
	{
		LoopAnim( aAnimName, aAnimRate, aBlendTime, aChannel );
	}
}


///////////////////////////////////////////////////////////////////////////////
// LoopSplitBodyAnimIfNeeded
//
simulated function LoopSplitBodyAnimIfNeeded(
	name			aUpperBodyAnim,
	name			aLowerBodyAnim,
	float			aAnimRate,
	float			aBlendTime,
	optional int	aChannel )
{
	local name	curAnimName;
	local float frame, curAnimRate;

	GetAnimParams( aChannel, curAnimName, frame, curAnimRate );

	if ( !IsAnimLooping( aChannel )	||
		 !IsAnimating( aChannel ) ||
		 (aLowerBodyAnim != curAnimName) ||
		 (aUpperBodyAnim != GetUpperBodyAnim( aChannel )) ||
		 (aAnimRate != curAnimRate) )
	{
		LoopSplitBodyAnim( aUpperBodyAnim, aLowerBodyAnim, aAnimRate, aBlendTime, aChannel );
	}
}

///////////////////////////////////////////////////////////////////////////////
// UpdateWeaponPose
//
simulated function UpdateWeaponPose();

///////////////////////////////////////////////////////////////////////////////
// PlayWaiting
//
// Called whenever pawn is idle or has just finished an animation.
simulated function PlayWaiting(
	bool bNoBlend )
{
	UpdateWeaponPose();

	switch ( meStance )
	{
	case STANCE_Standing:
		AnimateStanding( bNoBlend );
		break;

	case STANCE_Crouched:
		AnimateCrouching( bNoBlend );
		break;

	case STANCE_Prone:
		AnimateProne( bNoBlend );
		break;

	default:
		Warn( "Unrecognise stance <"$meStance$"> in PlayWaiting. Defaulting to standing animations." );
		AnimateStanding( bNoBlend );
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateStanding
//
simulated function AnimateStanding(
	bool bNoBlend )
{
	Warn( "SASPawn.AnimateStanding called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateCrouching
//
simulated function AnimateCrouching(
	bool bNoBlend )
{
	Warn( "SASPawn.AnimateCrouching called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateProne
//
simulated function AnimateProne(
	bool bNoBlend )
{
	Warn( "SASPawn.AnimateProne called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateStandToCrouch
//
simulated function AnimateStandToCrouch(
	optional float	aRate )
{
	Warn( "SASPawn.AnimateStandToCrouch called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateCrouchToStand
//
simulated function AnimateCrouchToStand()
{
	Warn( "SASPawn.AnimateCrouchToStand called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateStandToProne
//
simulated function AnimateStandToProne(
	optional float aRate )
{
	Warn( "SASPawn.AnimateStandToProne called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateProneToStand
//
simulated function AnimateProneToStand()
{
	Warn( "SASPawn.AnimateProneToStand called - should be using derived class function override." );
}



///////////////////////////////////////////////////////////////////////////////
// AnimateCrouchToProne
//
simulated function AnimateCrouchToProne(
	optional float	aRate )
{
	Warn( "SASPawn.AnimateCrouchToProne called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// PlayMoving
//
// Called when changing between stationary/walking/running/crouching etc.
// Triggers playing of the appropriate animation.
simulated function PlayMoving ()
{
	if ((Physics == PHYS_None) ||
		((Controller != None) && Controller.bPreparingMove))
	{
		// Bot is preparing move - not really moving
		PlayWaiting (false);
		return;
	}

	switch ( meStance )
	{
	case STANCE_Standing:
		switch ( mePace )
		{
		case PACE_Walking:
			AnimateWalking();
			break;

		case PACE_Running:
			AnimateRunning();
			break;

		case PACE_Charging:
			AnimateCharging();
			break;
		}
		break;

	case STANCE_Crouched:
		AnimateCrouchWalking();
		break;

	case STANCE_Prone:
		// Make sure turn anims are nulled.
		SetupTurnAnims();

		// Kill all movement animation blend alphas immediately.
		ZeroMovementChannelBlendAlpha();
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetupTurnAnims
//
simulated function SetupTurnAnims();


///////////////////////////////////////////////////////////////////////////////
// AnimateWalking
//
simulated function AnimateWalking()
{
	Warn( "SASPawn.AnimateWalking called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateCrouchWalking
//
simulated function AnimateCrouchWalking();


///////////////////////////////////////////////////////////////////////////////
// AnimateRunning
//
simulated function AnimateRunning()
{
	Warn( "SASPawn.AnimateRunning called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateCharging
//
simulated function AnimateCharging()
{
	Warn( "SASPawn.AnimateCharging called - should be using derived class function override." );
}


//-----------------------------------------------------------------------------
// PlayJump
//
// Plays the jump animation
simulated event PlayJump()
{
	/*if ((Acceleration.X != 0) || (Acceleration.Y != 0))
	{
		PlayAnim('Jump_run');
	}
	else
	{
		PlayAnim('Jump_stand');
	}*/
}


///////////////////////////////////////////////////////////////////////////////
// PlayClimbing
//
simulated function bool PlayClimbing(
	SASClimbPoint.EClimbType	aeClimbType )
{
	local name	anim;

	// Determine which climb anim to play.
	switch( aeClimbType )
	{
	case CLIMB_UpSmall:
		anim = 'Climb_40UU_MP5';
		break;

	case CLIMB_UpLarge:
		if ( (Controller != None) && (Controller.mType == CONTROLLER_Player) )
		{
			anim = 'Climb_NoStep_64UU';
		}
		else
		{
			anim = 'Climb_64UU';
		}
		break;

	case CLIMB_OverWall:
		anim = 'Climb_Vault64UU_mp5';
		break;

	case CLIMB_ThruWindow:
		anim = 'Climb_Vault64UU_mp5';	// TEMP
		break;

	default:
		Warn( "PlayClimbing() called with invalid climb type "$aeClimbType$" for pawn "$self );
		break;
	}

	if ( anim != 'None' )
	{
		PlayActionAnim( anim, 1.0, 0.0, true, false, true );
		SetAnimFrame( 0.0, ANIMCHANNEL_Action );

		// Turn off world geometry collision during climb animation.
		bCollideWorld = false;

		// AI controlled pawns don't collide with other pawns when climbing.
		if ( Controller.mType != CONTROLLER_Player )
		{
			bIgnorePawnCollision = true;
		}
	
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// EndPlayClimbing
//
simulated function EndPlayClimbing()
{
	if ( Physics == PHYS_RootMotion )
	{
		SetPhysics( PHYS_Walking );
	}

	// Re-enable collision with world geometry.
	bCollideWorld = true;
	
	// Restore pawn collision for AI controlled pawns.
	if ( Controller.mType != CONTROLLER_Player )
	{
		bIgnorePawnCollision = false;
	}

	EndPlayRootMotionAnim( 'Stand_Sighted_AK47' );
	ChangeAnimation();
}


///////////////////////////////////////////////////////////////////////////////
// EndPlayRootMotionAnim
//
simulated function EndPlayRootMotionAnim(
	name			aBlendOutAnim,
	optional int	aRotationIncrement )
{
	local Rotator	newRot;
	local Coords	C;

	PlayActionAnim( aBlendOutAnim, 1.0, 0.0, true );
	EndPlayActionAnim( 0.2 );

	if ( aRotationIncrement != 0 )
	{
		newRot.Yaw = (Rotation.Yaw + aRotationIncrement) & 65535;
		SetRotation( newRot );
	}

	// Force immediate animation update.
	SetAnimFrame( 0.0, ANIMCHANNEL_Action );
	C = GetBoneCoords( SPINE_BONE, true );
}


///////////////////////////////////////////////////////////////////////////////
// PlayFlinch
//
simulated function bool PlayFlinch()
{
	Warn( "SASPawn.PlayFlinch called - should be using derived class function override." );
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// PlayTakeHit
//
simulated function PlayTakeHit(
	Vector				aHitLocation,
	int					aDamage,
	class<DamageType>	aDamageType )
{
	local name			hitAnim,
						startBone;
	local ESASBodyParts hitBodyPart;

	Super.PlayTakeHit( aHitLocation, aDamage, aDamageType );

	// Randomly play?
	if ( (mPlayHitAnimChance < 1.0) && (FRand() > mPlayHitAnimChance) )
	{
		return;
	}

	// Don't play hit anims if any of:
	// 1) while in root motion physics
	// 2) incapacitated
	// 3) not in standing or crouched stance
	// 4) controller is in animation transition state
	if (	(Physics == PHYS_RootMotion) ||
			mbIsIncapacitated ||
			((meStance != STANCE_Standing) && (meStance != STANCE_Crouched)) ||
			((Controller != None) && (Controller.GetStateName() == 'Transition')) )
	{
		return;
	}

	hitBodyPart = ESASBodyParts( mLimbCylinders[mTakeHitAnimBoneCylinder].mBodyPart );

	// Do full body/partial body anim depending on whether moving or not.
	if ( IsStationary() )
	{
		// Play full body anim if standing else just on upper body.
		if ( meStance != STANCE_Standing )
		{
			// Only play on upper body...

			// No point in playing lower body hit anims on upper body only!
			switch ( hitBodyPart )
			{
			case BODYPART_LLEG:
			case BODYPART_RLEG:
				return;
			}

			startBone = SPINE_BONE;
		}
	}
	else
	{
		// If not stationary, don't play hit anims on legs.
		switch ( hitBodyPart )
		{
		case BODYPART_LLEG:
		case BODYPART_RLEG:
			return;
		}

		// Only play on upper body.
		startBone = SPINE_BONE;
	}

	switch( hitBodyPart )
	{
	case BODYPART_HEAD:
		hitAnim = ChooseHitAnim( HITANIM_Torso );
		break;

	case BODYPART_LARM:
		hitAnim = ChooseHitAnim( HITANIM_LeftArm );
		break;

	case BODYPART_RARM:
		hitAnim = ChooseHitAnim( HITANIM_RightArm );
		break;

	case BODYPART_LLEG:
		hitAnim = ChooseHitAnim( HITANIM_LeftLeg );
		break;

	case BODYPART_RLEG:
		hitAnim = ChooseHitAnim( HITANIM_RightLeg );
		break;

	default:
		hitAnim = ChooseHitAnim( HITANIM_Torso );
		break;
	}

	if ( hitAnim != 'None' )
	{
		mLastHitAnim = hitAnim;

		AnimBlendParams( ANIMCHANNEL_HIT, 1.0, 0.0, 0.0, startBone, true );
		PlayAnim( hitAnim, 1.0, 0.1, ANIMCHANNEL_HIT );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ChooseHitAnim
//
simulated function name ChooseHitAnim(
	EHitAnimType	aHitAnimType )
{
	local name	hitAnim;
	local int	randIdx;

	switch ( aHitAnimType )
	{
	case HITANIM_Torso:
		if ( mHitTorsoAnims.Length > 0 )
		{
			randIdx = Rand( mHitTorsoAnims.Length );
			hitAnim = mHitTorsoAnims[randIdx];
			if ( (hitAnim == mLastHitAnim) && (mHitTorsoAnims.Length > 1) )
			{
				hitAnim = mHitTorsoAnims[(randIdx+1) % mHitTorsoAnims.Length];
			}
		}
		break;

	case HITANIM_LeftArm:
		if ( mHitLeftArmAnims.Length > 0 )
		{
			randIdx = Rand( mHitLeftArmAnims.Length );
			hitAnim = mHitLeftArmAnims[randIdx];
			if ( (hitAnim == mLastHitAnim) && (mHitLeftArmAnims.Length > 1) )
			{
				hitAnim = mHitLeftArmAnims[(randIdx+1) % mHitLeftArmAnims.Length];
			}
		}
		break;

	case HITANIM_RightArm:
		if ( mHitRightArmAnims.Length > 0 )
		{
			randIdx = Rand( mHitRightArmAnims.Length );
			hitAnim = mHitRightArmAnims[randIdx];
			if ( (hitAnim == mLastHitAnim) && (mHitRightArmAnims.Length > 1) )
			{
				hitAnim = mHitRightArmAnims[(randIdx+1) % mHitRightArmAnims.Length];
			}
		}
		break;

	case HITANIM_LeftLeg:
		if ( mHitLeftLegAnims.Length > 0 )
		{
			randIdx = Rand( mHitLeftLegAnims.Length );
			hitAnim = mHitLeftLegAnims[randIdx];
			if ( (hitAnim == mLastHitAnim) && (mHitLeftLegAnims.Length > 1) )
			{
				hitAnim = mHitLeftLegAnims[(randIdx+1) % mHitLeftLegAnims.Length];
			}
		}
		break;

	case HITANIM_RightLeg:
		if ( mHitRightLegAnims.Length > 0 )
		{
			randIdx = Rand( mHitRightLegAnims.Length );
			hitAnim = mHitRightLegAnims[randIdx];
			if ( (hitAnim == mLastHitAnim) && (mHitRightLegAnims.Length > 1) )
			{
				hitAnim = mHitRightLegAnims[(randIdx+1) % mHitRightLegAnims.Length];
			}
		}
		break;

	default:
		Warn( "SASPawn.ChooseHitAnim called with invalid hit anim type <"$aHitAnimType$">" );
		break;
	}

	return hitAnim;
}


///////////////////////////////////////////////////////////////////////////////
// PlayFiring
//
simulated function PlayFiring(
	float		aRate,					// Animation playback rate
	name		aFiringMode )			// Weapon firing mode
{
	Warn( "SASPawn.PlayFiring called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// StopPlayFiring
//
// Called by weapon at end of firing. Blends out of firing animation
simulated event StopPlayFiring()
{
	//if ( bSteadyFiring )
	//{
		// FIXME - smooth blend out firing
		bSteadyFiring = false;
		AnimBlendToAlpha( ANIMCHANNEL_FIRING, 0.0, 0.15 );
		AnimBlendToAlpha( ANIMCHANNEL_AIMING, 0.0, 0.15 );
		ChangeAnimation();
	//}
}


///////////////////////////////////////////////////////////////////////////////
// PlaySprayFiring
//
simulated function PlaySprayFiring(
	float	aYawAlpha,
	float	aPitchAlpha,
	float	aAnimRate )
{
	Warn( "SASPawn.PlaySprayFiring called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// PlayAimWeapon
//
/*event PlayAimWeapon()
{
	Warn( "SASPawn.PlayAimWeapon called - should be using derived class function override." );
}*/


///////////////////////////////////////////////////////////////////////////////
// PlayReloading
//
simulated function PlayReloading()
{
	Warn( "SASPawn.PlayReloading called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// PlayShotgunReloadSingleShell
//
simulated function PlayShotgunReloadSingleShell()
{
	Warn( "SASPawn.PlayShotgunReloadSingleShell called - should be using derived class function override." );
}

///////////////////////////////////////////////////////////////////////////////
// PlayShotgunReloadEnd
//
simulated function PlayShotgunReloadEnd()
{
	Warn( "SASPawn.PlayShotgunReloadEnd called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// PlaySelectWeapon
//
simulated function PlaySelectWeapon()
{
	Warn( "SASPawn.PlaySelectWeapon called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// PlayDeselectWeapon
//
simulated function PlayDeselectWeapon()
{
	Warn( "SASPawn.PlayDeselectWeapon called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// PlayPullPinGrenade
//
simulated function PlayPullPinGrenade()
{
	Warn( "SASPawn.PlayPullPinGrenade called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// PlayThrowGrenade
//
simulated function PlayThrowGrenade()
{
	Warn( "SASPawn.PlayThrowGrenade called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// IsPlayingGrenadeThrow
//
// Returns true if currently playing a grenade throw animation.
//::simulated function bool IsPlayingGrenadeThrow()
//::{
//::	local name	anim;
//::	local float	frame, rate;
//::
//::	if ( IsAnimating( ANIMCHANNEL_FIRING ) )
//::	{
//::		GetAnimParams( ANIMCHANNEL_FIRING, anim, frame, rate );
//::		if ( anim == 'Stand_Throw_Grenade' )
//::		{
//::			return true;
//::		}
//::	}
//::
//::	return false;
//::}


///////////////////////////////////////////////////////////////////////////////
// AnimNotifyShowGrenade
//
simulated event AnimNotifyShowGrenade()
{
	if ( (Weapon != None)
		&& (SASGrenadeWeapon( Weapon ) != None)
		&& (Weapon.ThirdPersonActor != None) )
	{
		Weapon.ThirdPersonActor.bHidden = false;
	}
}


///////////////////////////////////////////////////////////////////////////////
// ChooseStunnedAnim
//
// Select a random stunned anim. Does not play the anim, just sets up the
// mStunnedAnim param which is used in future calls to AnimateStunned().
simulated function ChooseStunnedAnim()
{
	meStunnedAnimType = STUNANIM_Blinded;
}


///////////////////////////////////////////////////////////////////////////////
// AnimateToStunned
//
simulated function AnimateToStunned()
{
	Warn( "SASPawn.AnimateToStunned called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateFromStunned
//
simulated function AnimateFromStunned()
{
	Warn( "SASPawn.AnimateFromStunned called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// GetTranisitionFromStunnedAnim
//
simulated function name GetTranisitionFromStunnedAnim()
{
	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// AnimateStunned
//
simulated function AnimateStunned()
{
	Warn( "SASPawn.AnimateStunned called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// EndPlayStunned
//
//::simulated function EndPlayStunned()
//::{
//::	if ( Physics == PHYS_RootMotion )
//::	{
//::		SetPhysics( PHYS_Walking );
//::		EndPlayRootMotionAnim( 'Stand_Sighted_AK47' );
//::	}
//::	else
//::	{
//::		EndPlayActionAnim( 0.2 );
//::	}
//::}


///////////////////////////////////////////////////////////////////////////////
// ChooseGassedAnim
//
simulated function name ChooseGassedAnim()
{
	Warn( "SASPawn.ChooseGassedAnim called - should be using derived class function override." );
	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// AnimateToGassed
//
simulated function AnimateToGassed()
{
	Warn( "SASPawn.AnimateToGassed called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateFromGassed
//
simulated function AnimateFromGassed()
{
	Warn( "SASPawn.AnimateFromGassed called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// GetTranisitionFromGassedAnim
//
simulated function name GetTranisitionFromGassedAnim()
{
	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// AnimateGassed
//
simulated function AnimateGassed()
{
	local name	anim;

	anim = ChooseGassedAnim();
	if ( anim != 'None' )
	{
		PlayActionAnim( anim, RandRange( 0.9, 1.1 ), 0.0, true, mbHeadlessChicken );
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimNotifyCough
//
simulated event AnimNotifyCough()
{
	PlaySpeech( SPEECH_GenCough );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateToActingDead
//
//::simulated function AnimateToActingDead()
//::{
//::	Warn( "SASPawn.AnimateToActingDead called - should be using derived class function override." );
//::}


///////////////////////////////////////////////////////////////////////////////
// AnimateActingDead
//
//::simulated function AnimateActingDead()
//::{
//::	Warn( "SASPawn.AnimateActingDead called - should be using derived class function override." );
//::}


///////////////////////////////////////////////////////////////////////////////
// AnimateFromActingDead
//
simulated function AnimateFromActingDead()
{
	Warn( "SASPawn.AnimateFromActingDeadPhase1 called - should be using derived class function override." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateToIncapacitated
//
simulated function bool AnimateToIncapacitated()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// AnimateIncapacitated
//
/*simulated function AnimateIncapacitated(
	bool abInstant )
{
	Warn( "SASPawn.AnimateIncapacitated called - should be using derived class function override." );
}*/


///////////////////////////////////////////////////////////////////////////////
// GetStanceTransitionAnimName
//
// Returns the name of the (weapon specific) transition animation name to move
// between 2 specified stances.
simulated function name GetStanceTransitionAnimName(
	ESASStance	aeFromStance,
	ESASStance	aeToStance )
{
	Warn( "SASPawn.GetStanceTranitionAnimName called - should be using derived class function override." );
	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// PlayStanceTransitionAnim
//
// Stance transitions on AI pawns are usually carried out via the Transition
// state. This function is used as an alternate method when it is not viable to
// leave the current state to do the transition.
// Returns true if an anim was played.
simulated function bool PlayStanceTransitionAnim(
	ESASStance		aeToStance,
	optional bool	abFastTransition )
{
	local name	anim;
	local float	animRate;

	if ( meStance == aeToStance )
	{
		return false;
	}

	anim = GetStanceTransitionAnimName( meStance, aeToStance );
	if ( anim != 'None' )
	{
		if ( abFastTransition )
		{
			animRate = 1.6;
		}
		else
		{
			animRate = 1.0;
		}

		// Blend out hit animation while playing transitions.
		AnimBlendToAlpha( ANIMCHANNEL_Hit, 0.0, 0.1 );

		PlayActionAnim( anim, animRate, 0.15, false );
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// CanBePunched
//
// Check if pawn can be puched using action menu. 
// NOTE: Fn is overwritten in inherited classes for dealing with class specific behaviours.
simulated event bool CanBePunched()
{
	// Criteria for all pawn types to be non-punchable:
	// 1) Prone
	// 2) Captured
	// 3) Being cuffed
	// 4) Pawn is a scripted pawn type
	// 5) Pawn is player controlled
	if (	(meStance == STANCE_Prone) ||
			mbCaptured ||
			mbCuffingStarted ||
			(mPawnType == PAWN_Scripted) ||
			Health <= 0 ||
			mbIsIncapacitated )
	{
		return false;
	}

	return true;
}

simulated function PlayPunch(
	SASPawn	aNewPunchTarget );


///////////////////////////////////////////////////////////////////////////////
// PlayPunchedAnim
//
simulated function bool PlayPunchedAnim()
{
	local name anim;

	anim = GetPunchedAnim();
	if ( anim != 'None' )
	{
		PlayActionAnim( anim, 1.0, 0.0, true );
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// GetPunchedAnim
//
// Select appropriate animation for standing / kneeling.
simulated function name GetPunchedAnim()
{
	Warn( "SASPawn.GetPunchedAnim called - should be using derived class function override." );
	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// ShouldUseIncapAnims
//
simulated function bool ShouldUseIncapAnims()
{
	return mbIsIncapacitated;
}


///////////////////////////////////////////////////////////////////////////////
// PlayCuffingAnim
//
simulated function PlayCuffingAnim()
{
	local name	curAnim,
				cuffingAnim,
				uncuffingAnim;
	local float	frame,
				rate,
				blend;

	// Cuffing anims to use depend on whether pawn is incapacitated or not.
	if ( ShouldUseIncapAnims() )
	{
		cuffingAnim = 'Incap_to_CuffedIncap';
		uncuffingAnim = 'CuffedIncap_to_Incap';
	}
	else
	{
		cuffingAnim = 'Prone_Captive_toCuffed';
		uncuffingAnim = 'Cuffed_to_ProneCaptive';
	}

	// If current anim on the action channel is the un-cuffing anim then need to
	// play the cuffing anim at the right point to match the arm positions.
	GetAnimParams( ANIMCHANNEL_Action, curAnim, frame, rate );
	if ( (curAnim == uncuffingAnim) && IsAnimating( ANIMCHANNEL_Action ) )
	{
		frame = 1.0 - frame;
		if ( frame < 0.0 )
		{
			frame = 0.0;
		}

		blend = 0.0;
	}
	else
	{
		// Play anim from start.
		frame = 0.0;
		blend = 0.2;
	}

	PlayActionAnim( cuffingAnim, 1.0, blend, false );
	SetAnimFrame( frame, ANIMCHANNEL_Action );
}


///////////////////////////////////////////////////////////////////////////////
// PlayCuffingStopped
//
simulated function PlayCuffingStopped()
{
	local name	curAnim,
				cuffingAnim,
				uncuffingAnim;
	local float	frame,
				rate,
				blend;

	// Cuffing anims to use depend on whether pawn is incapacitated or not.
	if ( ShouldUseIncapAnims() )
	{
		cuffingAnim = 'Incap_to_CuffedIncap';
		uncuffingAnim = 'CuffedIncap_to_Incap';
	}
	else
	{
		cuffingAnim = 'Prone_Captive_toCuffed';
		uncuffingAnim = 'Cuffed_to_ProneCaptive';
	}

	// If current anim on the action channel is the cuffing anim then need to
	// play the un-cuffing anim at the right point to match the arm positions.
	GetAnimParams( ANIMCHANNEL_Action, curAnim, frame, rate );
	if ( (curAnim == cuffingAnim) && IsAnimating( ANIMCHANNEL_Action ) )
	{
		frame = 1.0 - frame;
		if ( frame < 0.0 )
		{
			frame = 0.0;
		}

		blend = 0.0;
	}
	else
	{
		// Play anim from start.
		frame = 0.0;
		blend = 0.2;
	}

	PlayActionAnim( uncuffingAnim, 1.0, blend, false );
	SetAnimFrame( frame, ANIMCHANNEL_Action );
}



///////////////////////////////////////////////////////////////////////////////
// PlayDying
//
// Setup ragdoll death and switch to dying state
simulated event PlayDying(
	class<DamageType>	aDamageType,
	vector				aHitLoc )
{
	local vector			shotDir;
	local vector			hitLocRel;
	local vector			deathAngVel;
	local KarmaParamsSkel	skelParams;

	EyeState=EYESTATE_Dead;

	AmbientSound		= None;
	bCanTeleport		= false;
    bReplicateMovement	= false;
    bTearOff			= true;
    bPlayedDeath		= true;

	HitDamageType = aDamageType; // these are replicated to other clients
    LastHitTakenLocation = aHitLoc;

    AnimBlendParams( 1, 0.0 );
	LifeSpan = mRagdollLifeSpan;

	GotoState( 'Dying' );

	if ( Level.NetMode != NM_DedicatedServer )
	{
		// In low physics detail, if we were not just controlling this pawn,
		// and it has not been rendered in 3 seconds, just destroy it.

		if ( (Level.PhysicsDetailLevel == PDL_Low) && (Level.TimeSeconds - LastRenderTime > 3) )
		{
			Destroy();
			return;
		}

		// We have to set up the ragdoll params BEFORE we go to ragdoll, so it gets the impulse from the bullet
		skelParams = KarmaParamsSkel( KParams );

		if ( skelParams != None)
		{
			// JS I'm trying to streamline and clear up all this death momentum impulse etc stuff

			// So.
			// The pawn gets kicked upwards by death.

			// This only depends on the pawn - mRagDeathUpKick.

			// Set the dude moving in direction he was shot in general
			shotDir = Normal( TearOffAcceleration );

			// pick a strength based on the ammo from the weapon, which will hopefully
			// have wriggled its way into the TearOffAcceleration stuff.

			// Calculate angular velocity to impart, based on shot location.
			hitLocRel = aHitLoc - Location;

			// We scale the hit location out sideways a bit, to get more spin around Z.
			hitLocRel.X *= mRagExtraHorizontalWholeBodySpinScale;
			hitLocRel.Y *= mRagExtraHorizontalWholeBodySpinScale;

			// If the tear off momentum was very small for some reason, forget it
			if ( VSize( TearOffAcceleration ) < 0.01 )
			{
				deathAngVel.X = 0;
				deathAngVel.Y = 0;
				deathAngVel.Z = 0;
			}
			else
			{
				deathAngVel = mRagWholeBodySpinScale * (hitLocRel Cross TearOffAcceleration);
			}

    		// Set initial angular and linear velocity for ragdoll.
			// Scale horizontal velocity for characters - they run really fast!
    		skelParams.KStartLinVel = TearOffAcceleration * (mRagWholeBodyVelScale + aDamageType.Default.mRagWholeBodyVelScale);

			// If not moving downwards - give extra upward kick
			if ( Velocity.Z > -10 )
			{
				skelParams.KStartLinVel.Z += mRagDeathUpKick + aDamageType.Default.mRagDeathUpKick;
			}

    		skelParams.KStartAngVel = deathAngVel;

			// JS we have to set up these parameters before we init the ragdoll otherwise it won't have any
			// initial impulse from the shot impact
    		skelParams.KShotStart = aHitLoc - (1 * shotDir);
    		skelParams.KShotEnd = aHitLoc + (2 * Max( CollisionRadius, CollisionHeight ) * shotDir);
    		skelParams.KShotStrength = (mRagImpactPointVelScale + aDamageType.Default.mRagImpactPointVelScale) * VSize(TearOffAcceleration);
   		}

		InitRagdoll(true);

		if ( Physics == PHYS_KarmaRagdoll )
		{
			// we've managed to turn into a rag doll, avoid doing the non-ragdoll stuff below
			return;
		}
	}

	// Mon-ragdoll death fallback
	//Velocity += TearOffAcceleration;
    BaseEyeHeight = Default.BaseEyeHeight;
    
	PlayDyingAnim( aHitLoc );
	
    //PlayDirectionalDeath(HitLoc);
    SetPhysics( PHYS_Falling );
}

simulated function PlayDyingAnim( vector aHitLocation )
{
	local name	anim;

	anim = ChooseDirectionDeathAnim( aHitLocation );
	if ( anim == '' )
	{
		StopAnimating( false );
	}
	else
	{
		StopAnimating( true );
		PlayAnim( anim, 1.0, 0.2 );
	}
}


///////////////////////////////////////////////////////////////////////////////
// InitRagdoll
//
// Try to initialise a ragdoll for this pawn and switch to ragdoll physics.
// Returns true on success.

// JS - converted to native, mostly for the fun of the experiment

// if dontresetparams, it assumes you've set up the karma params yourself.
cleannative function bool InitRagdoll(optional bool dontresetparams);


// Used for simulating ragdoll hits on multiplayer clients.
simulated event TakeHitNoDamage(
	vector	hitImpulse,
	vector	hitLocation )
{
	if ( bTearOff && bPlayedDeath )
	{
		ApplyRagdollImpulse( hitImpulse, hitLocation );
	}
}

simulated function ApplyRagdollImpulse(
	vector	hitImpulse,
	vector	hitLocation )
{
	// No ragdoll after being killed in german version.
	if ( bPlayedDeath && !IsGermanBuild() )
	{
		// Were we a ragdoll? Because we go to sleep after a while if we were.
		if ( mWasRagdoll )
		{
			// We might have to wake me up again
			KUnfreezeRagdoll();
			SetPhysics(PHYS_KarmaRagdoll);
		}
		else if ( Physics != PHYS_KarmaRagdoll )
		{
			InitRagdoll(false);
		}
		
		if (Physics == PHYS_KarmaRagdoll)
		{
			// we are an active ragdoll (perhaps just rewoken), let's just receive an impulse
			KAddImpulse( hitImpulse, hitLocation );
			mRagLastActivationTime = Level.TimeSeconds;
			Level.mLastImportantKarmaTime = Level.TimeSeconds;
		}
		else
		{
			// do nothing.
		}
	}
}



native final function ChooseSpawnPoint();


//-----------------------------------------------------------------------------
// AvoidBoobyTrap
//
// called on entering a booby trap trigger volume
simulated function AvoidBoobyTrap(vector aLocation)
{
	// TODO: goto disarm booby trap state etc.
}

//-----------------------------------------------------------------------------
// BoobyTrapAvoided
//
// called on leaving a booby trap trigger volume
simulated function BoobyTrapAvoided()
{
}

simulated function StartSpecialView ()
{
	mSpecialLocation = Location + Vect ( 0.5, 0.0, 1.0 ) * EyeHeight;
	mSpecialRotation = SASPlayerController(Controller).Rotation;
}

simulated event bool SpecialCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	CameraLocation = mSpecialLocation;
	CameraRotation = mSpecialRotation;

	return true;
}

//-----------------------------------------------------------------------------
// fire system
// for now just take damage whilst on fire
// todo : move into separate state, and implement some on fire activity
simulated event OnFireTick(float AlightDeltaTime)
{
	local float damage;
	local int floorDamage;

	if ( Health <= 0 )
	{
		Warn(self$" normal OnFireTick called and Health <= 0");
		mbOnFire = false;
		mFlamingCorpseTimer = 10;
		return;
	}

	damage = mHeatDamagePerSecond*AlightDeltaTime;
	mHeatDamageAccumulator += damage;
	floorDamage = mHeatDamageAccumulator;
	if(floorDamage!=0)
	{
		Super.TakeDamage( floorDamage, None, Location, vect(0,0,0), class'SASBurned' );
		mHeatDamageAccumulator -= floorDamage;
	}
}

//-----------------------------------------------------------------------------
simulated event SetFire(
	float aFlameDamagePerSecond )
{
	local int	i,
				numEmtrs;

	if ( !mbOnFire )
	{
		mbOnFire = true;

		mHeatDamagePerSecond = aFlameDamagePerSecond;

		// Spawn fire emitters on mesh
		if ( mFireOnMeshClass != None )
		{
			mMeshFire = Spawn( mFireOnMeshClass, self ,, Location );
			if ( mMeshFire != None )
			{
				// Attach emitter to pawn
				mMeshFire.SetLocation( Location );
				mMeshFire.SetBase( self );

				// fixup emitter mesh pointers
				numEmtrs = mMeshFire.Emitters.Length;
				for ( i = 0; i < numEmtrs; i++ )
				{
					mMeshFire.Emitters[i].SkeletalMeshActor		= self;
					mMeshFire.Emitters[i].CoordinateSystem		= PTCS_Relative;
					mMeshFire.Emitters[i].UseSkeletalLocationAs = PTSU_Location;
				}
			}
		}
	}
}


//-----------------------------------------------------------------------------
// TakeHeatDamage
//
// Just for taking damage, not to catch alight
simulated event TakeHeatDamage(
	float aDamageAmount )
{
	local int floorDamage;

	if ( Health <= 0 )
	{
		return;
	}

	mHeatDamageAccumulator += aDamageAmount;
	floorDamage = int(mHeatDamageAccumulator);
	if ( floorDamage != 0 )
	{
		Super.TakeDamage(
			floorDamage,
			None,
			Location,
			vect(0,0,0),
			class'SASBurned' );

		mHeatDamageAccumulator -= floorDamage;
	}
}

//-----------------------------------------------------------------------------
// AnimNotifyFootstep
//
// Combined code for callback from animation to instigate footstep.

//js currently I've just hacked it to always think it's touching the ground
simulated function AnimNotifyFootstep()
{
	local int			randomChoice;
	local int			numSounds;
	local int			groundType;
	local float			pitch;
	local array<SASFootstepSelection> footstepSounds;
	local float			loudness;
	local float			volume;
	local Sound			footstepSound;

	// let's work out if we're walking running or crouching here.
	if (meStance == STANCE_Crouched)
	{
		loudness = mFootstepLoudnessCrouch;
		volume = mFootstepVolumeCrouch;
		footstepSounds = mFootstepsWalk;
	}
	else
	if (mePace == PACE_Charging) // slight mis-naming convention here.
	{
		loudness = mFootstepLoudnessRun;
		volume = mFootstepVolumeRun;
		footstepSounds = mFootstepsRun;
	}
	else
	{
		loudness = mFootstepLoudnessWalk;
		volume = mFootstepVolumeWalk;
		footstepSounds = mFootstepsWalk;
	}

	// what kind of ground are we on?
	GetGroundMaterial();
	if (groundMaterial == None)
		groundType = 0;
	else
	{
		groundType = groundMaterial.mMaterialType;
		if ( groundType > footstepSounds.Length-1 )
		{
			groundType = 0;
		}
	}

	numSounds = footstepSounds[groundType].mSound.Length;

	// if this material doesn't work...
	if(numSounds==0)
	{
		groundType=1;
		numSounds = footstepSounds[groundType].mSound.Length;
	}

	// Pick one of the sounds.
	randomChoice = Rand(numSounds);
	footstepSound = footstepSounds[groundType].mSound[randomChoice];
	
	// Try to not repeat the last sound.
	if ( footstepSound == mLastFootstepSound )
	{
		if ( numSounds > 1 )
		{
			if ( randomChoice == numSounds-1 )
			{
				randomChoice = 0;
			}
			else
			{
				randomChoice++;
			}
			footstepSound = footstepSounds[groundType].mSound[randomChoice];
		}
	}
	mLastFootstepSound = footstepSound;

	// pitch bend it a bit
	pitch = ((frand()*0.2)+0.9);
	volume *= ((frand()*0.2)+0.8);
	PlaySound(footstepSound, SLOT_None,volume,,mFootstepSoundRadius,pitch);

	MakeNoise( loudness, NOISE_Footstep );
}


//-----------------------------------------------------------------------------
// AnimNotifyFootsteps all go through the same code now, and then just decide what
// sound to use based on the pawn's stance etc.

simulated event AnimNotifyFootstepCrouch()
{
	AnimNotifyFootstep();
}

simulated event AnimNotifyFootstepWalk()
{
	AnimNotifyFootstep();
}

simulated event AnimNotifyFootstepRun()
{
	AnimNotifyFootstep();
}

simulated event PlayMovementSound(
	Sound	aSound,
	float	aVolume,
	float	aPitch )
{
	PlaySound( aSound, SLOT_None, aVolume,, mFootstepSoundRadius, aPitch, true );
}

//-----------------------------------------------------------------------------

// this happens on the server
function SetGunLight(bool onoff)
{
	// Instead the only broadcasting we can do is variables
	mTorchShouldBeOn = onoff;
}

// this happens on the server
function SetGunLaser(bool onoff)
{
	// Instead the only broadcasting we can do is variables
	mLaserShouldBeOn = onoff;
}

//-----------------------------------------------------------------------------
// updateSpineTwist
//
// Called from 'Tick'
// Updates the current spine rotation - inertialess system (no acceleration / deceleration)
//::function updateSpineTwist (float deltaTime)
//::{
//::	local float dist;
//::	local Rotator r;
//::
//::	if (mSpineTwistTarget == mSpineTwistCurrent)
//::	{
//::		return;
//::	} // if
//::
//::	dist = mMaxSpineTwistRate * deltaTime;
//::
//::	if (Abs (mSpineTwistTarget - mSpineTwistCurrent) < dist)
//::	{
//::		mSpineTwistCurrent = mSpineTwistTarget;
//::	} // if
//::	else
//::	{
//::		if (mSpineTwistTarget > mSpineTwistCurrent)
//::		{
//::			mSpineTwistCurrent += dist;
//::		} // if
//::		else
//::		{
//::			mSpineTwistCurrent -= dist;
//::		} // else
//::	} // else
//::
//::	r.Roll = -mSpineTwistCurrent;
//::	r.Pitch = 0;
//::	r.Yaw = 0;
//::
//::	// JS I've changed this to SetBoneDirection, because the other one didn't survive when
//::	// there was actually an animation other than the standing one.
//::	SetBoneDirection(SPINE_BONE, r, , 1.0, 3);
//::	// JS was: SetBoneRotation ('Bip01 Spine1', r, 2, 1.0);
//::} // updateSpineTwist

function bool DrawCollision ()
{
	return false;
} // DrawCollision


event bool PlaySpeech(
	ePawnSpeech		aeSpeechType,
	optional bool	abAlwaysPlay,
	optional int	aSampleIdx )	// Used to force playing a specific sample. Note index should range from 1 to num samples (0 means don't care which one to play)
{
	if ( mVoice != None )
	{
		aSampleIdx--;
		return mVoice.PlaySpeech( self, aeSpeechType, abAlwaysPlay, aSampleIdx );
	}

	return false;
}


event bool PlayDelayedSpeech(
	EPawnSpeech		aeSpeechType,
	bool			abAlwaysPlay )
{
	if ( mVoice != None )
	{
		return mVoice.PlayDelayedSpeech( self, aeSpeechType, abAlwaysPlay );
	}

	return false;
}



//-----------------------------------------------------------------------------
// States

///////////////////////////////////////////////////////////////////////////////
// Dying
//
State Dying
{
	ignores AnimEnd,
			Trigger,
			Bump,
			HitWall,
			HeadVolumeChange,
			PhysicsVolumeChange,
			Falling,
			BreathTimer;

//	event Timer()
	simulated function Timer ()
	{
		local Vector						tTemp;
		local Vector						tTemp2;
		local Rotator						tTempRotn;
		local SASGRI						gri;
		local class<SASProjectedDecal>		tDecalClass;
		local class<SASExpandingProjector>	bloodPoolEffect;
		local int							idx;

		tTemp.x = 0;
		tTemp.y = 0;
		tTemp.z = 10;

		gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

		if ( VSizeSq ( Location - mOldLocation ) > ( 8 * 8 ) )
		{
			tTemp2.x = ( FRand () * 20 ) - 10;
			tTemp2.y = 0;
			tTemp2.z = ( FRand () * 20 ) - 10;

			// we've moved so stop leaking here ...
			if ( mBloodPool != None && !mBloodPool.mDone )
			{
				mBloodPool.Stop ();
				mBloodPool = None;
			}

			// No blood drag in german build.
			if ( !IsGermanBuild() )
			{
				if ( ( FRand () >= mBloodDragChance ) )
				{
					// do damage decal
					tDecalClass = gri.mLevelData.mDecalList[ eMaterialType.EMATERIAL_TYPE_FLESHDRAG ].mDecalClass;
					if ( tDecalClass != None )
					{
						tTempRotn = Rotator ( -tTemp );
						tTemp = Normal ( Location - mOldLocation );
						tTempRotn.yaw = ( asin ( tTemp.x ) * 32768 );

						Spawn ( tDecalClass,,, Location + tTemp2, tTempRotn );
					}
				}
				else
				{
					// do damage decal
					tDecalClass = gri.mLevelData.mDecalList[ eMaterialType.EMATERIAL_TYPE_FLESHDRAG ].mDecalClass;
					if ( tDecalClass != None )
					{
						Spawn ( tDecalClass,,, Location + tTemp2, Rotator ( -tTemp ) );
					}
				}
			}

			mOldLocation = Location;
			mStillTime = 0;
		}
		else
		{
			mStillTime += mBloodDecalSpawnRate;
		}

		if ( mStillTime > mBloodPoolStartTime )
		{
			if ( mBloodPool == None )
			{
				tTemp2.x = ( FRand () * 30 ) - 15;
				tTemp2.y = ( FRand () * 30 ) - 15;
				tTemp2.z = 0.0;

				idx = Rand ( gri.mLevelData.mBloodPoolEffects.Length );
				bloodPoolEffect = class<SASExpandingProjector>( gri.mLevelData.mBloodPoolEffects [ idx ] );

				mBloodPool = Spawn ( bloodPoolEffect,,, Location + tTemp2, Rotator ( -tTemp ) );

				// Smaller blood pools in german build.
				if ( IsGermanBuild() )
				{
					mBloodPool.mEndScale *= 0.3;
				}
				// this is already set as defaultproperty in SASBloodPool ...
				//mBloodPool.mGrowRate = 0.05;
			}
		}


		// HACK: Freeze ragdolls after a certain length of time has passed
		if ( bPlayedDeath
			&& mbCanFreezeRagdoll
			&& (Physics == PHYS_KarmaRagdoll)
			&& ( Level.TimeSeconds > (mRagLastActivationTime + 10.0) ) )
		{
			KFreezeRagdoll();
			SetPhysics(PHYS_None);
			mWasRagdoll = true;
		}
	}

	simulated function BeginState()
	{
		SetCollision ( true,false,false );

		// Play a Death sound (always play if already in a non combat capabel state).
		PlaySpeech( SPEECH_GenDeath, !mbIsCombatCapable );

		SetTimer(mBloodDecalSpawnRate,true);
		mOldLocation = Location;

        if ( bTearOff && (Level.NetMode == NM_DedicatedServer) )
		{
			LifeSpan = 1.0;
		}
		else
		{
			//SetTimer(2.0, false);
		}

        SetPhysics( PHYS_Falling );
		bInvulnerableBody = true;

		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
			{
				Controller.PawnDied( self );
			}
			else
			{
				Controller.Destroy();
			}
		}
	}

	simulated function Landed(
		vector	aHitNormal )
	{
		LandBob = FMin( 50, 0.055 * Velocity.Z );

		if ( Level.NetMode == NM_DedicatedServer )
		{
			return;
		}

		if ( Shadow != None )
		{
			Shadow.Destroy();
		}
	}

	singular function BaseChange()
	{
		Super.BaseChange();
		// fixme - wake up karma
	}

	// If a ragdoll, add an impulse when shot
    simulated function TakeDamage(
		int					aDamage,
		Pawn				aInstigatedBy,
		vector				aHitlocation,
		vector				aMomentum,
		class<DamageType>	damageType,
		optional Weapon		wpn)
    {
        local vector pushLinVel;
		local KarmaParamsSkel	skelParams;

		if ( bPlayedDeath )
		{
			// we a ragdoll, maybe active, maybe not. Let's just receive an impulse
			pushLinVel = aMomentum / Mass * (mRagImpactPointVelScale + DamageType.Default.mRagImpactPointVelScale);
			ApplyRagdollImpulse( pushLinVel, aHitLocation );
		}
	}


	simulated function TakeHeatDamage(float damage)
	{
		Warn(self$" TakeHeatDamage in Dying state");
	}

	event OnFireTick(float AlightDeltaTime)
	{
		Warn(self$" OnFireTick in Dying state");
	}
}


// event called when Karmic actor hits with impact velocity over KImpactThreshold

event KImpact(actor other, vector pos, vector impactVel, vector impactNorm)
{
	local int numSounds, soundNum;

	// If its time for another impact.
	if(Level.TimeSeconds > mRagLastSoundTime + mRagImpactSoundInterval)
	{
		// If we have some sounds, play a random one.
		numSounds = mRagImpactSounds.Length;
		if(numSounds > 0)
		{
			soundNum = Rand(numSounds);
			PlaySound(mRagImpactSounds[soundNum], SLOT_None, mRagImpactVolume,, mRagImpactSoundRadius);
		}
		mRagLastSoundTime = Level.TimeSeconds;
	}
}






//-----------------------------------------------------------------------------
// Default properties







// Decompiled with UE Explorer.
defaultproperties
{
    mbCanMoveCrouched=true
    mFriendlyFireCheckAngle=1820.0000000
    mbIsCombatCapable=true
    HitShakeTime=0.1000000
    HitRollMag=300.0000000
    HitOffsetRate=(X=10000.0000000,Y=10000.0000000,Z=10000.0000000)
    mStrength=1.0000000
    mShooterSpreadAnglePenaltyDecayMod=1.0000000
    mWeaponAimedSpeedMod=1.0000000
    mHeartRateBase=60.0000000
    mHeartRateWalking=70.0000000
    mHeartRateRunning=120.0000000
    mHeartRateStressed=100.0000000
    mHeartRateMax=160.0000000
    mHeartRateIncreaseRate=6.0000000
    mHeartRateDecreaseRate=2.0000000
    mHeartRateShotSpreadAngleScalars[0]=1.0000000
    mHeartRateShotSpreadAngleScalars[1]=1.1000000
    mHeartRateShotSpreadAngleScalars[2]=1.3000000
    mHeartRateShotSpreadAngleScalars[3]=1.5000000
    mPlayHitAnimChance=1.0000000
    mFlashMaxSightMod=1.0000000
    mFlashBehindMeMod=1.0000000
    mBangMaxHearingMod=1.0000000
    mStunDisorientThreshold=1.0000000
    mStunDisorientThresholdAlert=1.0000000
    mRagdollOverride="SASSoldier"
    mRagImpactSounds[0]=Sound'MM_Impacts.Sounds.WD_body_hit_floor_01'
    mRagImpactSounds[1]=Sound'MM_Impacts.Sounds.WD_body_hit_floor_02'
    mRagImpactSounds[2]=Sound'MM_Impacts.Sounds.WD_body_hit_floor_03'
    mRagImpactSounds[3]=Sound'MM_Impacts.Sounds.WD_body_hit_floor_04'
    mRagImpactSoundInterval=1.0000000
    mRagImpactVolume=0.3500000
    mRagImpactSoundRadius=40.0000000
    mbCanFreezeRagdoll=true
    mAlternativeMeshes[0]=SkeletalMesh'CSas.CS01'
    mAlternativeMeshes[1]=SkeletalMesh'CCiv.CC01'
    mAlternativeMeshes[2]=SkeletalMesh'CSas.CT02'
    mBloodDecalSpawnRate=0.0500000
    mBloodPoolStartTime=1.5000000
    mBloodDragChance=0.5000000
    mLimbHealths[0]=80.0000000
    mLimbHealths[1]=190.0000000
    mLimbHealths[2]=100.0000000
    mLimbHealths[3]=100.0000000
    mLimbHealths[4]=100.0000000
    mLimbHealths[5]=100.0000000
    mInjuryEffects[0]=(mHealth=40.0000000,mDisableEffect=1,mStrength=-1.0000000,mDexterity=0.1000000,mSpeedMult=0.0000000,mIncapacitation=0.2000000)
    mInjuryEffects[1]=(mHealth=110.0000000,mDisableEffect=1,mStrength=0.2000000,mDexterity=0.1000000,mSpeedMult=0.0000000,mIncapacitation=0.2000000)
    mInjuryEffects[2]=(mHealth=40.0000000,mDisableEffect=0,mStrength=0.4000000,mDexterity=0.1000000,mSpeedMult=0.0000000,mIncapacitation=0.0000000)
    mInjuryEffects[3]=(mHealth=40.0000000,mDisableEffect=0,mStrength=0.4000000,mDexterity=0.1000000,mSpeedMult=0.0000000,mIncapacitation=0.0000000)
    mInjuryEffects[4]=(mHealth=40.0000000,mDisableEffect=0,mStrength=-1.0000000,mDexterity=0.1000000,mSpeedMult=0.5000000,mIncapacitation=0.0000000)
    mInjuryEffects[5]=(mHealth=40.0000000,mDisableEffect=0,mStrength=-1.0000000,mDexterity=0.1000000,mSpeedMult=0.5000000,mIncapacitation=0.0000000)
    mDamageSpeedMod=1.0000000
    mDamageSpeedModDifficultyLevScalar=1.0000000
    mIncapacitationLevel=0.2000000
    mFireOnMeshClass=Class'SASFire_on_mesh'
    mFootstepsRun[0]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_08'
    mSound[8]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_09'
    mSound[9]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_10')
    mFootstepsRun[1]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_stone_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_stone_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_stone_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_stone_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_stone_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_stone_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_stone_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_stone_08'
    mSound[8]=Sound'MM_Footsteps.Sounds.WD_walk_stone_09'
    mSound[9]=Sound'MM_Footsteps.Sounds.WD_walk_stone_10')
    mFootstepsRun[2]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_wood_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_wood_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_wood_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_wood_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_wood_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_wood_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_wood_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_wood_08'
    mSound[8]=Sound'MM_Footsteps.Sounds.WD_walk_wood_09'
    mSound[9]=Sound'MM_Footsteps.Sounds.WD_walk_wood_10')
    mFootstepsRun[3]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_metal_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_metal_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_metal_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_metal_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_metal_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_metal_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_metal_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_metal_08')
    mFootstepsRun[4]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_08'
    mSound[8]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_09'
    mSound[9]=Sound'MM_Footsteps.Sounds.WD_footstep_glass_10')
    mFootstepsRun[5]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_08')
    mFootstepsRun[6]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_08'
    mSound[8]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_09'
    mSound[9]=Sound'MM_Footsteps.Sounds.WD_walk_wooden_stair_10')
    mFootstepsRun[7]=(mSound=mSound[0]=Sound'SASSounds.FS.WaterBtR01'
    mSound[1]=Sound'SASSounds.FS.WaterBtR02'
    mSound[2]=Sound'SASSounds.FS.WaterBtR03'
    mSound[3]=Sound'SASSounds.FS.WaterBtR04'
    mSound[4]=Sound'SASSounds.FS.WaterBtR05'
    mSound[5]=Sound'SASSounds.FS.WaterBtR06'
    mSound[6]=Sound'SASSounds.FS.WaterBtR07'
    mSound[7]=Sound'SASSounds.FS.WaterBtR08'
    mSound[8]=Sound'SASSounds.FS.WaterBtR09'
    mSound[9]=Sound'SASSounds.FS.WaterBtR10')
    mFootstepsRun[8]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_08'
    mSound[8]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_09'
    mSound[9]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_10'
    mSound[10]=Sound'MM_Footsteps.Sounds.WD_walk_gravel_11')
    mFootstepsRun[9]=(mSound=none)
    mFootstepsRun[10]=(mSound=none)
    mFootstepsRun[11]=(mSound=none)
    mFootstepsRun[12]=(mSound=none)
    mFootstepsRun[13]=(mSound=none)
    mFootstepsRun[14]=(mSound=none)
    mFootstepsRun[15]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_08'
    mSound[8]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_09'
    mSound[9]=Sound'MM_Footsteps.Sounds.WD_walk_carpet_10')
    mFootstepsRun[16]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_leather_sofa_08')
    mFootstepsRun[17]=(mSound=none)
    mFootstepsRun[18]=(mSound=none)
    mFootstepsRun[19]=(mSound=none)
    mFootstepsRun[20]=(mSound=none)
    mFootstepsRun[21]=(mSound=mSound[0]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_01'
    mSound[1]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_02'
    mSound[2]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_03'
    mSound[3]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_04'
    mSound[4]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_05'
    mSound[5]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_06'
    mSound[6]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_07'
    mSound[7]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_08'
    mSound[8]=Sound'MM_Footsteps.Sounds.WD_walk_foliage_09')
}