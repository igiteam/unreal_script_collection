/**
 * GearWeapon
 * Gear Weapon implementation
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeapon extends Weapon
	abstract
	config(Weapon)
	native(Weapon)
	nativereplication
	dependson(GearHUD_Base, GearPC, GearSkelCtrl_Recoil, GearTypes);

//The stat system name of the weapon. Used to figure out which stat it corresponds to.
var string WeaponStatName;

/** GoW global macros */

/** cached reference to GearAI controller */
var protectedwrite GearAI GearAIController;

/** If TRUE do not allow pickup factories to respawn if the weapon already exists in the level */
var config bool bUniqueSpawn;

/** Constant weapon ID, mainly used for FX lookup */
var const EWeaponClass WeaponID;
var const GearPerMapColorConfig GlobalDefaultColors;

/** Whether or not this weapon can be thrown  (e.g. GearWeap_Melee can't be thrown and that call chain is expensive 1+ ms expensive **/
var bool bCanThrowActiveWeapon;

/** This weapon must be within "long range" to fire */
var bool bMustBeInRangeToFire;

var const config float Range_Melee;
/** if this is non-zero we will roll the dice when inside this range and maybe charge our enemy and melee (useful for chainsaws! )*/
var const config float Range_MeleeCharge;
var const config float Range_Short;
var const config float Range_Medium;
var const config float Range_Long;

/** FOV to acquire melee targets */
var const config Vector2D MeleeAcquireDotFOV;

/** Damage scalar based on range.  We interpolate these multipliers for actual ranges that lie between the defined ranges above. */
var config float DamageMod_MeleeRange; // point blank
var config float DamageMod_ShortRange;
var config float DamageMod_MediumRange;
var config float DamageMod_LongRange;

/**
 * Player Accuracy modifiers.
 */
// Base Accuracy values
/** Accuracy: Standing */
var()	config float		Inaccuracy_Base_Standing;
/** Accuracy: Blind firing */
var()	config float		Inaccuracy_Base_BlindFire;
/** Accuracy modifier: targeting mode */
var()	config float		Inaccuracy_Base_Target;

// Accuracy modifiers
/** Accuracy modifier: moving */
var()	config float		Inaccuracy_Mod_Move;
/** Accuracy modifier: evading (added on top of moving) */
var()	config float		Inaccuracy_Mod_Evade;
/** Accuracy modifier: view turning */
var()	config float		Inaccuracy_Mod_ViewTurn;


// Base Interp value
/** Interp speed: default */
var()	config float		Inaccuracy_Interp_Base_Speed;

// Interp modifiers
/** Interp modifier: blind fire */
var()	config float		Inaccuracy_Interp_Mod_BlindFire;
/** Interp modifier: movement */
var()	config float		Inaccuracy_Interp_Mod_Move;
/** Interp modifier: evading (added on top of movement) */
var()	config float		Inaccuracy_Interp_Mod_Evade;
/** Interp scaler: view turning */
var()	config float		Inaccuracy_Interp_Mod_ViewTurn;
/** interp modifier: in cover and stationary */
var config float Inaccuracy_Interp_Mod_StationaryCover;

// Boundaries
/** Interp speed boundaries */
var()	config vector2d		Inaccuracy_InterpRange;

/** If TRUE, damage done by weapon is not modified by difficulty level (always use 'Normal' value) */
var	bool	bIgnoreDifficultyDamageScale;

/** additional aim error AI has when using this weapon beyond the AI-specific base value
 * @note: standard weapon spread is applied to AI shots; this property is not needed for that task
 */
var float AdditionalAimError;
var(AI) config	float	AI_RateOfFire_Scale;
/** AI burst fire counts */
var(AI) config Vector2D AI_BurstFireCount;
var(AI) config Vector2D AI_BurstFireDelay;
/** number of shots left in this burst **/
var transient int RemainingBurstFireCount;
/** number of bursts we should fire this volley -1 indicates fire until out of ammo **/
var transient int RemainingBurstsToFire;

/** AI targeted shot delay */
var(AI) config Vector2D AI_AimDelay;


/** temp enum to define anim set to use on character */
enum EWeaponAnimType
{
	EWAT_AssaultRifle,
	EWAT_Shotgun,
	EWAT_SniperRifle,
	EWAT_Pistol
};
var const EWeaponAnimType	WeaponAnimType;

//
// Cheats
//

var()	bool	bInfiniteSpareAmmo;


//
// General
//

/** Force pawn to walk when targeting? */
var() const bool			bForceWalkWhenTargeting;

/** True if this weapon cannot target, false otherwise. */
var() const protected	bool	bPreventTargeting;
/** TRUE if reloading weapon takes out of TargetingMode, TRUE for most weapons. */
var() const				bool	bReloadingWeaponPreventsTargeting;
/** If TRUE, this weapon will always start traces from the player camera and not the muzzle */
var() const             bool    bAlwaysTraceFromPlayerView;

/** FOV to use in while in targeting mode with this weapon.	 <= zero means the weapon will not modify the FOV */
var()	config	float	TargetingFOV;

/** Adjustment to apply to fov when player wields this weapon in an "aiming" pose */
var()	config	float	AimingFOVAdjustment;

/** Is this weapon a slave weapon (used by remote clients) */
var				bool	bSlaveWeapon;
/** Weapon actually has alt fire instead of targeting */
var				bool	bAltFireWeapon;

/** Can weapon be fired in blind fire mode? */
var const		bool	bBlindFirable;
/** Setting this to FALSE, will prevent default blind firing animations from being played. */
var	const		bool	bPlayDefaultBlindFireStance;
/** TRUE if supports 360 aiming in cover animations. (Back to wall aiming ang firing). */
var				bool	bSupports360AimingInCover;
/** TRUE if we can RoadieRun using this weapon. */
var				bool	bAllowsRoadieRunning;
/** Character is allowed to play idle stances. (non firing, rest pose) */
var				bool	bAllowIdleStance;
/** Character is allowed to play aiming stances. (Firing from hips) */
var				bool	bAllowAimingStance;
/** Character is allowed to play downsights animations. (targeting mode) */
var				bool	bAllowDownsightsStance;

/** if TRUE, animation transitions won't delay weapon firing. */
var				bool	bNoAnimDelayFiring;
/**
 * if TRUE, disables Left Hand IK controller locked to IK Bones on skeleton.
 * Weapons like pistol and grenade do not want that.
 */
var				bool	bDisableLeftHandIK;
/** If TRUE, Pawn will play IK Recoil. */
var				bool	bPlayIKRecoil;
/**	If TRUE, meleeing a FSM with this weapons will cause fracture. */
var				bool	bAllowMeleeToFracture;

/** Animation node used to play custom animations */
var	transient	GearAnim_Slot	CustomAnimNode;
/** Pointer to AnimTree RootNode. */
var	transient	AnimTree		AnimTreeRootNode;

/** Does this weapon require the heavy weapon skel control node to be active */
var bool bUseHeavySkelControl;

/** Does this weapon slow the ground speed and special move speeds */
var bool bUseHeavyWeaponSpeedMods;

/** Animation to play on weapon */
var() protected Name	WeaponFireAnim;
var() protected Name	WeaponReloadAnim;
var() protected Name	WeaponReloadAnimFail;
var() protected Name	WeaponReloadAnimSuccess;

/** Screen Shake to play when firing weapon */
var() editinline protected const GearCameraShake   FireCameraShake;
/** Scalar used to amplify/dampen firing CamShakes. */
var() protected float			        FireCameraShakeScale;

/** The controller vibration waveform for when firing this weapon **/
var ForceFeedbackWaveform WeaponFireWaveForm;

/** TRUE if camera needs to be super-steady during targeting */
var		bool	bSuperSteadyCamWhileTargeting;

/** Used by SpawnImpactDecal to determine min distance for spawning decals on skeletal meshes */
var config float DecalImpactRelevanceDistanceSkelMesh;

/** Shell case ejection particle system */
var()				ParticleSystemComponent		PSC_ShellEject;
/** After fire smoke effect */
var()				ParticleSystemComponent		PSC_ReloadBarrelSmoke;

// Fire modes

// Fire mode 0 is the default weapon firing.
const DEFAULT_FIREMODE			= 0;
/** arbitrary firemode for reloading */
const RELOAD_FIREMODE			= 1;
/** Firing mode used when doing a melee attack */
const MELEE_ATTACK_FIREMODE		= 2;
/** For weapons that have an alt fire instead of targeting */
const ALTFIRE_FIREMODE			= 3;
/** Shotgun Cock special fire mode */
const SHOTGUN_COCK_FIREMODE		= 4;
/** All purpose charging firing mode */
const FIREMODE_CHARGE			= 5;
/** All purpose failed firing mode */
const FIREMODE_FAILED			= 6;

/** Special Grenade fire modes */
const FIREMODE_GRENADESPIN = 7;
const FIREMODE_STOPGRENADESPIN = 8;

/** Active Reload fire modes */
const FIREMODE_FAILEDACTIVERELOAD		= 9;
const FIREMODE_ACTIVERELOADSUCCESS		= 10;
const FIREMODE_ACTIVERELOADSUPERSUCCESS	= 11;

/** Keep track of last firing mode used */
var	byte	PreviousFiringMode;

/** Weapon parameter definition */
struct native TWeaponParam
{
	var()	Array<float>	Value;
	var		Name			Name;
};

var() config float WeaponDamage, WeaponDamageAI;
var() config float					WeaponMagSize;
var() config float WeaponMaxSpareAmmo;
var() const config	float			WeaponRecoil;
var() const config	vector2d		WeaponAimError;
var() config float					WeaponRateOfFire;
/** as the Locust in Siege, regen ammo in this weapon every this many seconds */
var config float SiegeAmmoRegenFrequency;

/** Whether the out of ammo indicator should not be drawn for this weapon */
var bool bSkipOutOfAmmoIndicator;

/** When blindfiring over cover, limit player aiming when using this weapon inside UpdateMeshBoneControllersNative to this pitch */
var() const int			MinBlindFireUpAimPitch, MinBlindFireSideYaw;

/** cash cost to take this weapon from a factory in Horde */
var config int HordeCost;

//
// Weapon Recoil
//

/** Weapon Recoil Offset applied to player view. */
var				Rotator	WeaponRecoilOffset;
/** interpolation speed for weapon recoil. */
var()	config 	float	RecoilInterpSpeed;

/** Auto correcting weapon recoil applied to player view, diminishes over time */
var				Rotator	AutoCorrectWeaponRecoilOffset;
/** Percentage of recoil to auto correct */
var()	config	float	RecoilAutoCorrectPct;
/** Rotation units per second that auto correct recoil will converge on zero */
var()	config	float	RecoilAutoCorrectSpeed;
/** Delay after recoil is done to start auto correction */
var()	config	float	RecoilAutoCorrectDelay;
/** World time to start auto correction */
var				float	RecoilAutoCorrectTime;

//
// Ammo
//

/** Struct for storing ammo display */
struct native AmmoDrawData
{
	var int			DisplayCount;
	var CanvasIcon	AmmoIcon;
	var float		ULPerAmmo;
};
/** Ammo icon data */
var AmmoDrawData	HUDDrawData;
var AmmoDrawData	HUDDrawDataSuper;

/** Whether this weapon can be actively reloaded and thus can display a reload tutorial */
var bool bCanDisplayReloadTutorial;

/** This is the amount of ammo (min/max) in addition to the amount remaining in the clip that will be in the weapon if it is dropped from a foe**/
var config vector2d SpareAmmoFromDrop;
/** class that should be acquired when picking up this weapon after being dropped
 * used to make enemy-only weapon classes become their player-wieldable counterpart on drop
 * if None, this object's Class is used
 */
var class<GearWeapon> DroppedWeaponClass;

/** Ammo used from current magazine */
var	repnotify int		AmmoUsedCount;
/** When reaching this amount, ammo becomes critical (warnings, flashing, beeping, whatever..) - values less than zero are automatically set to the size of one clip */
var()	config		int		CriticalAmmoCount;
/** Spare ammo, contained in extra magazines (outside of what's currently in the weapon) */
var	repnotify		int		SpareAmmoCount;
/** Number of magazines to start with */
var() 		config	int		InitialMagazines;
/** TRUE if weapon can be reloaded */
var() 				bool	bWeaponCanBeReloaded;

/** duration in seconds of reload sequence */
var config float ReloadDuration;
/** rate to play reload anim */
var config float ReloadAnimRate;
/** Time this weapon last started a reload */
var 	transient	float	ReloadStartTime;


/** Muzzle Flash archetype */
var const GearMuzzleFlash MuzzleFlashArchetype;
var GearMuzzleFlash MuzzleFlash;

//
// Player animations
//

/**
 * Weapon Specific animation sets.
 * Animations in these will override the default assault rifle set.
 */
var()	Array<AnimSet>		CustomAnimSets;
/** Name of AimOffset profiles to use. Set in order. */
var	const Array<Name>		AimOffsetProfileNames;

var()	GearPawn.BodyStance	HolsterShoulderLeft;
var()	GearPawn.BodyStance	HolsterShoulderRight;
var()	GearPawn.BodyStance	EquipShoulderLeft;
var()	GearPawn.BodyStance	EquipShoulderRight;

var()	GearPawn.BodyStance	BS_PawnWeaponReload;
var()	GearPawn.BodyStance	BS_PawnWeaponReloadSuccess;
var()	GearPawn.BodyStance	BS_PawnWeaponReloadFail;

/** Blend Out Time for weapon reload animations */
var const FLOAT WeaponReloadBlendOutTime;

/** How much to speed up the reload animation when active reload has been hit */
var config const float ActiveReloadAnimationSpeedUp;

/** How much to speed up the reload animation when super active reload has been hit */
var config const float SuperActiveReloadAnimationSpeedUp;

//
// Sounds
//

/** Fire sound to use when this weapon is fired by a local player.  Stereo, non-spatialized. */
var	SoundCue	FireSound_Player;
/** Fire sound to use when this weapon is fired by a squad mate.  Mono and spatialized. */
var	SoundCue	FireSound_Squad;
/** Fire sound to use when this weapon is fired by everyone else.  Mono and spatialized. */
var	SoundCue	FireSound;

/** Sound to play when firing loop stops on owning player */
var SoundCue    StopFireSound_Player;
/** Sound to play when firing loop stops on squad member */
var SoundCue    StopFireSound_Squad;
/** Sound to play when firing loop stops */
var SoundCue    StopFireSound;

/** Weapon melee hit sound*/
var()			SoundCue	MeleeImpactSound;
/** Melee hit shield sound */
var()			SoundCue	MeleeShieldImpactSound;

/** Weapon fire sound to play when firing and this weapon has no ammo */
var() const		SoundCue	FireNoAmmoSound;
/** Time between FireNoAmmoSound instances if trigger is held.  0.f for no repeating sound. */
var() const protected float		NoAmmoFireSoundDelay;

/** Bullet whip configuration */
var const               GearBulletWhip  BulletWhipArchetype;

/** Sound played when reloading weapon */
var() const protected	SoundCue		WeaponReloadSound;

/** Sound played when the player equips the weapon. (e.g. pulling it from his back or holster) **/
var() const protected	SoundCue		WeaponEquipSound;

/** Sound played when the player equips this weapon.  (e.g. stowing it away on his back or in his holster) **/
var() const protected	SoundCue		WeaponDeEquipSound;

/** Sound played when the player drops this weapon. **/
var() const				SoundCue		WeaponDropSound;

//
// HUD
//

/** Scale that defines how much the crosshair expands when being inaccurate */
var()		float						CrosshairExpandStrength;


//
// Inventory
//

enum EWeaponType
{
	WT_Normal,			// Carried on Shoulders
	WT_Holster,			// Only fits in holster slot
	WT_Item,			// Only fits in Item slot
	WT_Heavy,			// Can be carried only in hands, cannot be holstered
	WT_AllButHeavy,     // Used by idle break animations. All weapon types but heavy weapons.
	WT_NWAllButHeavy,   // Used by idle break animations. All weapon types including no weapon/hostered, but heavy weapons.
};

/** Type of weapon, will affect how it is managed in the inventory */
var()	const EWeaponType		WeaponType;
/** Slot the weapon is attached to on the character */
var		GearPawn.EAttachSlot	CharacterSlot;

/** This is the ammo class that this weapon can get ammo from **/
var class<GearAmmoType> AmmoTypeClass;


//// Active Reload
var() const bool bCanActiveReload;

/** this is our "mutex" that says whether or not we have attempted an AR on this specific reload **/
var		bool   bActiveReloadAttempted;

/** time the reload was started **/
var		float	AR_TimeReloadButtonWasPressed;

/** When an active reload was attempted */
var float AR_TimeActiveReloadAttempted;

/** The time in which AR magic bullets will time out and become normal bullets again **/
var	config float	AR_MagicBulletsTimeoutDuration;

/**
 * Number of seconds AFTER hitting reload to start the active reload minigame
 * if -1 then we are just doing to use ReloadDuration / 2
 **/
var()	config float	AR_PossibleSuccessStartPoint;


/**
 * Duration after the AR_PossibleSuccessStartPoint and SuperSweetSpot
 * which the SuperSweetSpot is valid
 **/
var()	config float	AR_SweetSpotDuration;


/** Whether or not the visual tracer effects are active **/
var transient protected bool bActiveReloadVisualEffectsActive;

/** How many seconds after a successful active reload the bonus should last **/
//var() array<float> ActiveReload_BonusDurationTier;
/** Active reload damage percentage bonus for normal damage. X=Min bonus, Y=Max bonus */
var() config vector2d ActiveReload_DamageMultiplier;
/** Active reload damage multipler for explosive/radial damage.	X=Min bonus, Y=Max bonus */
var() config vector2d ActiveReload_ExploRadiusMultiplier;
/** Active reload rate-of-fire multipler. X=Min bonus, Y=Max bonus */
var() config vector2d ActiveReload_RateOfFireMultiplier;

/**
 * number of AR bullets you have in your gun currently
 **/
var repnotify int ActiveReload_NumBonusShots;

/** tmp var for how many shots this weapon has taken during a bonus active reload time period **/
var transient int ActiveReload_NumShotsTaken;

/** whether active reload shots are "free", i.e. don't consume ammo */
var bool bFreeARShots;
/** if true, all non-active reloads are failures (humans only) */
var bool bMustActiveReload;
/** whether active reloads happen automatically if the player doesn't press anything */
var bool bAutoActiveReload;

/** Whether being in cover should extend active reload duration */
var config bool bCoverDoesNotExtendActiveReloadDuration;

/**
 *  This holds the AR super sweet spot duration per tier for each weapon
 *  Duration after the AR_PossibleSuccessStartPoint which the SuperSweetSpot is valid
 **/
const ACTIVE_RELOAD_TIERS = 3;
var() protected const config TWeaponParam ActiveReload_SuperSweetSpotDurations;

/** How long after AR_PossibleSuccessStartPoint should the super sweet spot start */
var() protected const config float ActiveReload_SuperSweetSpotOffset;

/** Audio for Active Reloads. */
var() protected const SoundCue AR_FailSound;
var() protected const SoundCue AR_SuccessSound;
var() protected const SoundCue AR_SuperSuccessSound;


/** This is how much stronger the last bullet shot is in SP only.  Makes it so you run out of ammo and last bullet KILLS the guy!!!!**/
var config float LastBulletStrongerPercent;

/** Max distance allow for friction */
var() config float MaxFrictionDistance;
/** Peak distance for friction */
var() config float PeakFrictionDistance;
/** Min distance for friction */
var() config float MinFrictionDistance;
/** Min/Max friction multiplier applied when target acquired */
var() config Vector2d FrictionMultiplierRange;
/** Amount of additional radius/height given to target cylinder when at peak distance */
var() config float PeakFrictionRadiusScale;
var() config float PeakFrictionHeightScale;
/** Offset to apply to friction target location (aim for the chest, etc) */
var() config vector FrictionTargetOffset;
/** Max time to attempt adhesion to the friction target */
var() config float MaxAdhesionTime;
/** Max distance to allow adhesion to still kick in */
var() config float MaxAdhesionDistance;
/** Max distance from edge of cylinder for adhesion to be valid */
var() config float MaxAdhesionAimDistY;
var() config float MaxAdhesionAimDistZ;
/** Min/Max amount to scale for adhesive purposes */
var() config Vector2d AdhesionScaleRange;
/** Min amount to scale for adhesive purposes */
var() config float MinAdhesionScaleAmount;
/** Require the target to be moving for adhesion to kick in? */
var() config float MinAdhesionTargetVelocity;
/** Require the player to be moving for adhesion to kick in? */
var() config float MinAdhesionPlayerVelocity;

/** If TRUE, call GetWeaponDistanceForEnemyTrace function on the weapon to get distance to do trace. */
var bool bOverrideDistanceForEnemyTrace;

/** Should use timer instead of anim notifies for melee hits? */
var bool bUseMeleeHitTimer;
/** This is the time that must pass between melee attacks **/
var config float MeleeAttackCoolDownInSeconds;

/** This locks us from responding to anim notifies that come through when we should not be able to attack **/
var bool bMeleeImpactNotifySemaphore;

/** Time (after melee starts) before traces for impact start occuring */
var config float MeleeInitialImpactDelay;
/** Time (after impact checks start) to retry impacts */
var config float MeleeImpactRetryDuration;
/** World time to stop retrying traces for melee impact */
var		   float MeleeImpactCompleteTime;

/** Melee Attack body stance for this weapon */
var()	array<BodyStance>	BS_MeleeAttack;
/** Melee Kick body stance for this weapon */
var()	BodyStance	BS_MeleeKick;

/** Name of camera anim to play on melee attack, if one is desired */
var()	array<CameraBoneAnimation>	MeleeAttackCameraBoneAnims;

/** played when the melee attack hits world geometry */
var ParticleSystem MeleeWallImpactEffect;

/** For runtime decisions re whether to play melee attach camera anims. */
var transient bool					bSuppressMeleeAttackCameraBoneAnim;

/** The range at which this attack can be used **/
var config float MeleeAttackRange;

/** Extent to use when tracing melee attacks */
var vector MeleeTraceExtent;

/** The min amount of damage the melee attack does **/
var config float MeleeAttackDamageMin;

/** The max amount of damage the melee attack does **/
var config float MeleeAttackDamageMax;

/** True if this weapons melee attack should include some adhesion in the controller */
var() bool		bDoMeleeAdhesion;

/** This is the camera shake that we play when we hit a melee attack **/
var() protected const GearCameraShake MeleeImpactCamShake;

/** stores the wall being hit in a melee attack, so multiple sounds/effects aren't triggered.*/
var transient bool bHitWallThisAttack;

/** Whether we're kicking this melee attack */
var transient bool bKickThisAttack;
/** Whether we've already done the melee kick traces this attack */
var transient bool bCheckedKickThisAttack;

/** How much higher the player needs to be above the victim to kick instead of standard melee */
var config float MeleeKickZDiff;

/** damage types for nonstandard melee attacks */
var class<GearDamageType> ShieldBashDamageType, MeleeKickDamageType;

/**
 * This stores how many times we have attempted to attack with the melee attack.  We are doing a
 * a timed attack so you end up getting "Attacks" on the "return to idle" which is odd when you are
 * triggering a wall impact with it. so we will only trigger on the first k (3-4) and that will be the
 * down swing.
 **/
var transient int NumMeleeAttackAttempts;

/** The time stamp for when we started the melee special attack **/
var float TimeStartedSpecialMeleeAttack;

/** Weapon icon displayed on HUD */
var CanvasIcon	WeaponIcon;
var int			IconXOffset;
var int			IconYOffset;

/** Weapon icon displayed on HUD for Annex Command Point */
var CanvasIcon	AnnexWeaponIcon;

/** Crosshair icon */
var Texture2D CrosshairIcon;
/** if set, draw crosshair twice, on -X and then again inverted on +X */
var bool bCrosshairMirrored;

/** The base scale of the crosshair */
var const float BaseCrosshairScale;

/** Whether we use the expanding crosshair used by lancers */
var bool bCrosshairExpanding;

/** How long we've currently been firing */
var protected transient float CrosshairExpansionFiringTime;

/** How long til the gun reaches crosshair size */
var protected config float CrosshairExpansionTime;

/** The scale for the crosshair when at full accurate */
var protected config float CrosshairFullAccurateScale;

/** The scale for the crosshair when at full accurate */
var protected config float CrosshairFiringScale;

/** The scale for the crosshair when at full accurate and zoomed */
var protected config float CrosshairFullAccurateZoomedScale;

/** Speed up the crosshair growth due to movement */
var protected config float CrosshairAccuracyMultiplier;

/** If secondary crosshair should be drawn even if aiming at a friendly */
var const bool bDrawAdditionalCrosshairIfAimingAtFriendly;

/** should the AI treat this weapon as a suppressive weapon? */
var bool		bIsSuppressive;
/** is this a long range sniping weapon? */
var bool		bSniping;
/** if set AI never seeks out this weapon on the ground */
var bool bAIAvoidsTaking;
/** AI flag - can this weapon ignore (or completely destroy in one shot) a meat shield?
 * (used to know whether kidnapper can be engaged head on)
 */
var bool bCanNegateMeatShield;
/** AI flag indicating whether this weapon can kill DBNO pawns even when execution rules are enabled */
var bool bIgnoresExecutionRules;
/** AI flag indicating that it should aim this weapon to maximize the effect of splash damage (target nearby walls/floors) */
var bool bRecommendSplashDamage;
/** AI flag indicating that the AI should lead the target with this weapon (based on fire mode 0 projectile speed) */
var bool bLeadTarget;
/** is a hose type weapon - flame thrower, mulcher, etc */
var bool bHose;

/** true if instigator's bWeaponDebug_Accuracy is true (set when firing) */
var bool		bDebuggingShots;

/** Start location of the last shot I fired.  Used for debug displays in multiplayer */
var repnotify vector DebugShotStartLoc;
/** Aim direction of the last shot I fired.	 Used for debug displays in multiplayer */
var rotator			 DebugShotAimRot;

/** Per-weapon scale factor for amount of aim assistance to apply. */
var() float AimAssistScale;
/** Same as AimAssistScale, except this is used while in targeting/zoom mode. */
var() float AimAssistScaleWhileTargeting;

/** Determines which tracer type to use for this weapon **/
var const protected EWeaponTracerType TracerType;
/** determines which tracer type to use for this weapon when active reloaded */
var const protected EWeaponTracerType TracerTypeAR;
/** These are the Distances for when to show tracers **/
var const protected config float		ShowTracerDistance;
/** Controls size of the tracers for this weapon */
var() const protected vector			TracerScale;
/** Controls size of the tracers for this weapon */
var() const protected vector			TracerScaleAR;

/** Animation Physics Recoil */
var() GearSkelCtrl_Recoil.RecoilDef	Recoil_Hand;
var() GearSkelCtrl_Recoil.RecoilDef	Recoil_Spine;

/** Can this weapon be selected when it is out of ammo? */
var const bool bCanSelectWithoutAmmo;

/** When this Weapon runs out of ammo, attempt auto-switch to another weapon. */
var protected const bool bAutoSwitchWhenOutOfAmmo;


/** true if this weapon is being temporarily holstered, false otherwise */
var transient bool bTemporaryHolster;

/** Are we allowed to swap this weapon? */
var bool bSwappable;
/** Are we forbidden to interact with anything while holding this weapon? */
var bool bNoInteractionWhileEquipped;

/** Whether or not muzzle flashes CastDynamicShadows **/
var bool bDynamicMuzzleFlashes;

/** Sound to play when your current clip is nearly empty, as a subtle reminder. */
var protected const SoundCue	NeedReloadNotifySound;
/** Play notify sound when this many rounds remain in the clip */
var() protected int				NeedReloadNotifyThreshold;
/** sound to play when almost completely out of ammo */
var SoundCue AlmostOutOfAmmoSound;

/** true if this weapon supports zoomed-in targeting, false otherwise */
var() bool		bUseTargetingCamera;

/** Keep track of where the weapon is attached to. To prevent multiple attachments to the same socket. */
var transient	Name	SocketAttachedTo;

/** Magazine Mesh */
var	StaticMeshComponent	MagazineMesh;

/** TRUE to suppress muzzle flash effects */
var bool bSuppressMuzzleFlash;
/** TRUE to suppress tracers for this weapon */
var bool bSuppressTracers;
/** TRUE to suppress impact effects for this weapon */
var bool bSuppressImpactFX;
/** TRUE to suppress all weapon audio */
var bool bSuppressAudio;
/** TRUE to suppress damage */
var bool bSuppressDamage;

/** TRUE to spawn invisible projectile, meant for dummyfire use */
var bool bHideProjectile;
/** TRUE if this is a weapon meant for dummyfire use. */
var protected bool bDummyFireWeapon;
/** Actor this weapon is attached to, if it's a dummyfire weapon (ignored otherwise) */
var protected Actor DummyFireParent;
/** Location of dummyfire target */
var protected Vector DummyFireTargetLoc;
/** Actor that we were dummy firing at. */
var protected Actor DummyFireTargetActor;

/**
  * This is the MIC which will be the weapons's "material" once it is spawned.	We will then
  * be able to modify the colors on the fly!
 **/
var transient MaterialInstanceConstant MIC_WeaponSkin;

/**
 * This weapon's default emissive color.  The issue is that we can not have a struct of structs
 * and have the composed struct get the correct defaultproperties.	So we need to have some pain
 * here where we check for the uninited LinearColor and then init it the real defaults.
 * Find RonP or MartinS for the details on this.  We are going to fix thise post Gears as it
 * is a behavior affecting change.
**/
var LinearColor LC_EmisDefaultCOG;
var LinearColor LC_EmisDefaultLocust;

/** This controls how much force is applied to the weapons when they spin/flyout as they are dropped **/
var config float WeaponDropAngularVelocity;

/** this weapon aims using the camera direction as determined BEFORE modifiers, such as camera shake or bone motion */
var() bool bUsePreModCameraRotForAiming;

/** Can this weapon be equipped while holding a shield? */
var() const bool bCanEquipWithShield;

/** True to spawn tracers on each shot, false for no tracers. */
var() protected const bool bAllowTracers;

/** Never cull tracer smoke due to relevancy or performance (use for slow firing guns like sniper) */
var() const bool bAlwaysSpawnTracerSmoke;

/** Damage type to use when sending death/pickup messages in the UI */
var class<GearDamageType> DamageTypeClassForUI;

/** activates client side hit detection for instant hit fire */
var config bool bClientSideInstantHit;
/** multiplier to hitbox size of an actor the client said it hit that the shot must be within for the server to agree */
var config float ClientSideHitLeeway;
/** last time we performed the firing code, i.e. FireAmmunition() */
var float LastShotTime;
/** whether we have received a client hit notify to correspond with the most recent shot fired on the server
 * server only and only used when CSHD is enabled
 */
var bool bGotClientHit;
/** client side hit that happened early; if we start actually firing within a reasonable tolerance (around the user's ping) then the result is applied as valid */
struct native CSHDHitInfo
{
	var byte FiringMode;
	var byte HitType;
	var byte NumHits;
	var ImpactInfo Impact;
	var float Time;
};
var CSHDHitInfo QueuedCSHDInfo;

/** whether this weapon can parry melee attacks from other weapons' melee */
var bool bCanParryMelee;

// CQC Executions

struct native CQC_Long_Execution
{
	var name CQC_Long_KillerAnim, CQC_Long_KillerAnim_Loop, CQC_Long_KillerAnim_End;
	var name CQC_Long_VictimAnim, CQC_Long_VictimAnim_Loop, CQC_Long_VictimAnim_End;
	/** Animation to play in sync on the weapon */
	var name CQC_Long_KillerWeaponAnim;
	var array<CameraAnim> CQC_Long_CameraAnims, CQC_Long_CameraAnims_Loop, CQC_Long_CameraAnims_End;
	var bool CQC_Long_bHolsterWeapon;
	var float CQC_Long_VictimDeathTime;
	/** 0.f for instant */
	var float CQC_Long_VictimRotStartTime;
	/** 0.f for instant */
	var float CQC_Long_VictimRotInterpSpeed;
	var class<GearDamageType> CQC_Long_DamageType;
	var GearVoiceEffortID CQC_Long_EffortID;
	/** The award required to use this execution */
	var name AwardRequired;
	/** Relative offset for follower position from attacker root */
	var Vector MarkerRelOffset;
	/** If this is only for certain team : team index 0 - COG and team index 1 - Locust */
	var int TeamIndexRequired;
	/** gore execution, do not do it unless it has gore setup */
	var bool GoreExecution;
	/** weapon specific, prefer this over others */
	var bool WeaponSpecial;
	/** if this is gore execution, then you need to specify the back up execution index
	 *  So if client does not like to see, we need to go back to the nongore execution
	 *  If this is non loop, there is deafult one in the punchface gsm **/
	var INT NonGoreExecutionIndex;
	/** Whether death screams should be disabled */
	var bool bDisableDeathScreams;
	/** Lens Effect - if exists */
	var class<Emit_CameraLensEffectBase> CameraLensEffect;
	var class<Emit_CameraLensEffectBase> CameraLensEffect_Loop;
	var class<Emit_CameraLensEffectBase> CameraLensEffect_End;

	structdefaultproperties
	{
		MarkerRelOffset=(X=1,Y=2,Z=3) // default value, change to override default in special move class.
		TeamIndexRequired=-1
		WeaponSpecial=TRUE
		NonGoreExecutionIndex=-1
	}
};

var array<CQC_Long_Execution> LongExecutions;

// if this is on GetPhysicalFireStartLoc will return GetMuzzleLoc
var bool					bUseMuzzleLocForPhysicalFireStartLoc;

/** Whether GetProjectileFirePosition will skip correcting the projectile spawn position if the trace from muzzle to desired target fails */
var bool                    bForceProjectileSpawnFromMuzzle;
/** if true, enable the projectile spawn location/rotation correction for off-center weapons even if AI controlled */
var bool bEnableProjCorrectionForAI;

/** TRUE if this weapon should do the barrel-heat functionality. */
var protected const bool			bSupportsBarrelHeat;
/** How hot the barrel is, from 0 to 1. */
var protected transient float		CurrentBarrelHeat;
var protected transient float		LastBarrelHeat;
var protected transient float		GoalBarrelHeat;
var protected transient float		MaxBarrelHeat;
var() protected const float			BarrelHeatInterpSpeed;
var() protected const float			BarrelHeatPerShot;
/** Time it takes for barrel to cool down from heat=1 to heat=0. */
var() protected const float			BarrelHeatCooldownTime;
var protected const Name			BarrelHeatMaterialParameterName;
/** Color to use for HUD ammo when we are overheated */
var() const color OverheatHUDColor;

var protected transient MaterialInstanceConstant	ZoomHUDOverlayMIC;
var protected Material								ZoomHUDOverlayMaterial;

/** For coop weapons, the other end of the dynamic duo.  Can be a weapon, pickupfactory, or droppedpickup. */
var() const class<GearWeapon> CoopCounterpartClass;

/** Class of the coop sync actor we want to use */
var() const class<CoopMGSyncActor> CoopSyncActorClass;

var() config const float CoopCounterpartTetherDist;

/** How much ammo to put back into the gun for each coop reload */
var() config const float CoopReloadAmount;

//Whether or not this weapon should automatically melee when you encounter an enemy while roadie running
var bool bShouldRunMelee;

/** Sniper screen overlay colors */
var LinearColor CogZoomColor;
var LinearColor LocustZoomColor;

/** Experimental Ironsights code */
var() bool bCanDoIronSights;
var() bool bIronSightsCamera;
var() vector IronSightsCameraOffset;
var() rotator IronSightsCameraRotOffset;

/** The list of potential weapon skins a player can select to customize their weapon */
var const array<MaterialInstanceConstant> WeaponSkins;

/** Whether this is a scope weapon or not */
var const bool bIsScopeWeapon;

/** Scope for scope weapons */
var GearScope_Sniper Scope;

/** The class of scope to spawn if a scope weapon */
var class<GearScope_Sniper> ScopeClass;

/** Offset for FPS camera from player's location while not in cover */
var vector FPSOffset_NoCover;

/** Offset for FPS camera from player's location while leaning left in midlevel cover */
var vector FPSOffset_LeanLeft_MidLevel;

/** Offset for FPS camera from player's location while not in cover */
var vector FPSOffset_LeanLeft_Standing;

/** Offset for FPS camera from player's location while not in cover */
var vector FPSOffset_LeanRight_MidLevel;

/** Offset for FPS camera from player's location while not in cover */
var vector FPSOffset_LeanRight_Standing;

/** Offset for FPS camera from player's location while not in cover */
var vector FPSOffset_360Aim_MidLevel;

/** Offset for FPS camera from player's location while not in cover */
var vector FPSOffset_360Aim_Standing;

/** Offset for FPS camera from player's location while not in cover */
var vector FPSOffset_Popup_Mirrored;

/** Offset for FPS camera from player's location while not in cover */
var vector FPSOffset_Popup_NotMirrored;

/** When we last were targeting */
var transient float TimeSinceTargeting;

/** Zoom in sound **/
var protected const SoundCue ZoomActivatedSound;

/** Zoom out sound **/
var protected const SoundCue ZoomDeActivatedSound;

/** Skip any mirroring on this weapon */
var const bool bNeverMirrorThisWeapon;

/** Allowed view dot hit dir **/
var const float AllowedViewDotHitDir;

cpptext
{
	// Networking
	INT* GetOptimizedRepList( BYTE* InDefault, FPropertyRetirement* Retire, INT* Ptr, UPackageMap* Map, UActorChannel* Channel );
	virtual void TickSpecial( FLOAT DeltaSeconds );
	virtual UBOOL DisableAimOffset() { return FALSE; }
}

//
// Network replication
//

replication
{
	// Things the server should send to local player.
	if (bNetInitial)
		InitialMagazines, WeaponMagSize, WeaponMaxSpareAmmo, bMustActiveReload, bAutoActiveReload;

	if (bNetDirty)
		AmmoUsedCount, SpareAmmoCount, CharacterSlot,
		bInfiniteSpareAmmo, ActiveReload_NumBonusShots;

	if (bDebuggingShots)
		DebugShotStartLoc, DebugShotAimRot;
}


simulated native function GetMuzzleLocAndRot(out vector Loc, out rotator Rot);

simulated native event vector GetPhysicalFireStartLoc(optional vector AimDir);

/**
* This function returns the world location for spawning the visual effects.
* Network: ALL
*/
simulated native event Vector GetMuzzleLoc();


/** Check on various replicated data and act accordingly. */
simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent( VarName );

	Switch( VarName )
	{
		case 'SpareAmmoCount':
			AmmoUpdated();
			break;
		case 'AmmoUsedCount':
			AmmoUpdated();
			break;
		case nameof(ActiveReload_NumBonusShots):
			SetActiveReloadEffectsActive(ActiveReload_NumBonusShots > 0);
			break;
		case 'DebugShotStartLoc':
			DrawDebugShot(DebugShotStartLoc, DebugShotAimRot);
			break;
	}
}


/**
 * Called immediately before gameplay begins.
 */
simulated event PreBeginPlay()
{
	Super.PreBeginPlay();

	if (CriticalAmmoCount < 0)
	{
		CriticalAmmoCount = WeaponMagSize;
	}

	InitializeAmmo(); // setup starting ammo
}

simulated event PostBeginPlay()
{
	local GearPawn GP;

	Super.PostBeginPlay();

	SetupMuzzleFlash();

	// inherit cheats from the instigator
	GP = GearPawn(Instigator);
	if ( GP != None )
	{
		if( GP.bUnlimitedAmmo )
		{
			SetInfiniteMagazineSize();
			SetInfiniteSpareAmmo();
		}
		else if( GP.bUnlimitedClips )
		{
			SetInfiniteSpareAmmo();
		}
	}
}

/** Set special action
    Called by GearPC.UpdateHUDActions()
	@PARAM MyGearPC is the player owning this weapon
	@RETURN true if action was set
	*/
simulated function bool SetSpecialAction(GearPC MyGearPC)
{
	return false;
}

simulated function ToggleCharging(bool bNewCharging);

/**
 * Fires a projectile.
 * Spawns the projectile, but also increment the flash count for remote client effects.
 * Network: Local Player and Server
 */
simulated function Projectile ProjectileFire()
{
	local Vector		ProjLoc, ProjDir;
	local Projectile	SpawnedProjectile;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( WorldInfo.Netmode != NM_Client )
	{
		GetProjectileFirePosition(ProjLoc, ProjDir);

		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(), Self,, ProjLoc);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( ProjDir );
			GearProjectile(SpawnedProjectile).SuppressAudio(bSuppressAudio);
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}


/**
 * Get Projectile Spawn Location and Direction.
 */
simulated function GetProjectileFirePosition(out vector out_ProjLoc, out vector out_ProjDir, optional out float out_ProjSpeed )
{
	local vector StartTrace, EndTrace;
	local ImpactInfo TestImpact;

	// This is where we would start an instant trace. (what CalcWeaponFire uses)
	StartTrace = Instigator.GetWeaponStartTraceLocation();
	out_ProjDir = vector(GetAdjustedAim(StartTrace));

	// this is the location where the projectile is spawned.
	out_ProjLoc = GetPhysicalFireStartLoc(out_ProjDir);

	if (StartTrace != out_ProjLoc && Instigator != None && (bEnableProjCorrectionForAI || Instigator.IsHumanControlled(GetWeaponController())))
	{
		// if projectile is spawned at different location of crosshair,
		// then simulate an instant trace where crosshair is aiming at, Get hit info.
		EndTrace = StartTrace + out_ProjDir * GetTraceRange();
		TestImpact = CalcWeaponFire(StartTrace, EndTrace);

		// make sure that can hit what StartTrace hit
		if (!bForceProjectileSpawnFromMuzzle && !FastTrace(TestImpact.HitLocation, out_ProjLoc))
		{
			out_ProjLoc = StartTrace;
		}

		// Then we realign projectile aim direction to match where the crosshair did hit.
		out_ProjDir = Normal(TestImpact.HitLocation - out_ProjLoc);
	}
}

/** Allow the weapon to do any special tweaks to the trace start location. */
simulated function vector AdjustStartTraceLocation(vector StartLoc, vector AimDir)
{
	return StartLoc;
}

/**
 * This is to allow the weapon to handle (eat) button releases.
 **/
simulated function bool HandleButtonRelease( coerce Name ButtonName )
{
	return FALSE;
}

/** Whether the input passed in is asking for a zoom in or out */
simulated function bool InputCanZoom( coerce Name ButtonName )
{
	if ( ((ButtonName == 'ZoomIn') && !GearPawn(Instigator).bIsZoomed) ||
		 ((ButtonName == 'ZoomOut') && GearPawn(Instigator).bIsZoomed) ||
		 (ButtonName == 'R3') )
	{
		return true;
	}

	return false;
}

/** Weapons get a crack at handling controls */
simulated function bool HandleButtonPress( coerce Name ButtonName )
{
	local GearPC PC;
	local GearPawn InstigatorGP;

	if (bIsScopeWeapon && InputCanZoom(ButtonName))
	{
		PC = GearPC(GetWeaponController());
		InstigatorGP = GearPawn(Instigator);

		//@todo should be able to click on R3 and zoom in target instantly
		if (PC != None && InstigatorGP != None && PC.bIsTargeting && !IsInState('MeleeAttacking'))
		{
			SetZoomed(!InstigatorGP.bIsZoomed, TRUE);

			GearGameplayCamera(GearPlayerCamera(PC.PlayerCamera).CurrentCamera).ForceNextFrameLookatPoint(PC.LastCrosshairHitLocation, 0.3f);

			if (InstigatorGP.bIsZoomed)
			{
				GearWeaponPlaySoundLocal(ZoomActivatedSound,,, TRUE);
			}
			else
			{
				GearWeaponPlaySoundLocal(ZoomDeactivatedSound,,, TRUE);
			}

			return TRUE;
		}
	}

	return FALSE;
}

simulated function SetZoomed(bool bNewZoomed, optional bool bToggleOwnerNoSee)
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	if (GP == None)
	{
		return;
	}

	GP.bIsZoomed = bNewZoomed;
	if (bToggleOwnerNoSee)
	{
		SetOwnerNoSee(GP.bIsZoomed);
	}
	if (WorldInfo.NetMode == NM_Client)
	{
		ServerSetZoomed(bNewZoomed);
	}

	if (bCanDoIronSights)
	{
		bIronSightsCamera = bNewZoomed;

		// hide pawn mesh
		// @todo, also hide helmets, etc.  See GearWeapon.SetOwnerNoSee
		Instigator.Mesh.SetOwnerNoSee(bIronSightsCamera);

		// make gun mesh under camera
		if (bIronSightsCamera)
		{
			Mesh.SetAbsolute(true, true);
		}
		else
		{
			Mesh.SetAbsolute(false, false);
			Mesh.SetTranslation(vect(0,0,0));
			Mesh.SetRotation(rot(0,0,0));
		}
	}
}

final reliable server function ServerSetZoomed(bool bNewZoomed)
{
	GearPawn(Instigator).bIsZoomed = bNewZoomed;

	RemoteZoomLevelChanged(bNewZoomed);
}

/**
 * Hide or unhide the owner of this weapon
 * Pawn is hidden while rifle is zoomed
 */
simulated function SetOwnerNoSee(bool bNewOwnerSee)
{
	local GearPawn_Infantry HelmetedInstigator;
	local GearPawn GPInstigator;
	local int i;

	if ( Mesh != None )
	{
		Mesh.SetOwnerNoSee(bNewOwnerSee);
		if ( (Instigator != None) && (Instigator.Mesh != None) )
		{
			Instigator.Mesh.bCastHiddenShadow = bNewOwnerSee;
			Instigator.Mesh.SetOwnerNoSee(bNewOwnerSee);

			GPInstigator = GearPawn(Instigator);
			if (GPInstigator != None)
			{
				for (i = 0; i < EASlot_None; i++)
				{
					if (GPInstigator.AttachSlots[i].StaticMesh != None)
					{
						GPInstigator.AttachSlots[i].StaticMesh.SetOwnerNoSee(bNewOwnerSee);
					}

					if (GPInstigator.AttachSlots[i].SkeletalMesh != None)
					{
						GPInstigator.AttachSlots[i].SkeletalMesh.SetOwnerNoSee(bNewOwnerSee);
					}
				}
			}
		}

		HelmetedInstigator = GearPawn_Infantry(Instigator);
		if ( HelmetedInstigator != None )
		{
			if ( HelmetedInstigator.AttachmentMeshes[eATTACHTYPE_Helmet] != None )
			{
				HelmetedInstigator.AttachmentMeshes[eATTACHTYPE_Helmet].SetOwnerNoSee(bNewOwnerSee);
			}

			if( HelmetedInstigator.AttachmentMeshes[eATTACHTYPE_Face] != none )
			{
				HelmetedInstigator.AttachmentMeshes[eATTACHTYPE_Face].SetOwnerNoSee(bNewOwnerSee);
			}
		}
	}
}

/**
 * @returns true if Weapon would like a first person camera to be used
 */
simulated function bool UseFirstPersonCamera()
{
	if (bIsScopeWeapon)
	{
		return GearPawn(Instigator).bIsZoomed;
	}

	return false;
}

/**
 * Notification from pawn that it has been unpossessed.
 */
function NotifyUnpossessed();

/** Notification from pawn that it has been possessed */
function NotifyPossessed()
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	if (bIsScopeWeapon && GP != None)
	{
		if (ScopeClass != None && Scope == None && GP.IsLocallyControlled() && GP.IsHumanControlled())
		{
			Scope = Spawn(ScopeClass, Self);
			SetupScopeLighting();
		}
	}
}

/**
 * This function returns the damage for the current firing mode.
 * @note: to apply modifiers on base damage, prefer using ModifyDamage(). See below.
 */
simulated function float GetFireModeDamage( Vector HitLocation, optional Actor HitActor )
{
	local float ModifiedDamage;
	local GearAI AI;

	// Get base fire mode damage
	if (Instigator != None)
	{
		AI = GearAI(GetWeaponController());
	}
	if (AI != None && GearAI_TDM(AI) == None) // allow MP bots to use player rules
	{
		ModifiedDamage = WeaponDamageAI;
		// double damage for AI during coop splits
		if (GearGame(WorldInfo.Game).bInCoopSplit &&
			GearAI_COGGear(AI) != None &&
			AI.Squad != None &&
			PlayerController(AI.GetSquadLeader()) == None)
		{
			ModifiedDamage *= 2.f;
		}
	}
	else
	{
		ModifiedDamage = WeaponDamage;
	}

	// Apply modifiers
	ModifyDamage( ModifiedDamage, HitLocation, HitActor );
	return ModifiedDamage;
}


/**
 * Apply modifiers to current firemode damage.
 * it checks to see if it should modify the damage for a shot
 * based on whether or not the ActiveReload minigame was completed successfully.
 */
simulated function ModifyDamage( out float BaseDamage, Vector HitLocation, optional Actor HitActor )
{
	local float Range;
	local GearPawn GP;
	local Actor ActorIter;
	local GearPRI PRI;
	local Controller PawnController;

	GP = GearPawn(Instigator);

	// dummy fire weapons don't damage what they are attached to
	if ( (HitActor != None) && bDummyFireWeapon && (DummyFireParent != None) )
	{
		// search the attachment chain to see if we've hit something we should ignore
		ActorIter = DummyFireParent;
		do
		{
			if (ActorIter == HitActor)
			{
				BaseDamage = 0.f;
				return;
			}
			ActorIter = ActorIter.Base;
		} until (ActorIter == None);
	}

	if (Instigator != None)
	{
		Range = VSize(HitLocation - Instigator.Location);
	}
	else
	{
		// no instigator, measure shot from weapon itself
		Range = VSize(HitLocation - Location);
	}

	// Adjust damage for range.
	if( Range <= Range_Melee )
	{
		BaseDamage *= DamageMod_MeleeRange;
	}
	else if( Range <= Range_Short )
	{
		BaseDamage *= GetRangeValueByPct( vect2d(DamageMod_MeleeRange,DamageMod_ShortRange), ((Range-Range_Melee)/(Range_Short-Range_Melee)) );
	}
	else if( Range <= Range_Medium )
	{
		BaseDamage *= GetRangeValueByPct( vect2d(DamageMod_ShortRange,DamageMod_MediumRange),  ((Range-Range_Short)/(Range_Medium-Range_Short)) );
	}
	else if (Range <= Range_Long)
	{
		BaseDamage *= GetRangeValueByPct( vect2d(DamageMod_MediumRange,DamageMod_LongRange), ((Range-Range_Medium)/(Range_Long-Range_Medium)) );
	}
	else
	{
		BaseDamage *= DamageMod_LongRange;
	}

	if (Instigator != None)
	{
		// only humans get AR and last bullet bonus
		PawnController = GetWeaponController();
		if( Instigator.IsHumanControlled(PawnController) || GearAI_TDM(GetWeaponController()) != None)
		{
			BaseDamage *= GetActiveReloadDamageMultiplier();

			// if not a MP game
			if (!WorldInfo.GRI.IsMultiPlayerGame() || GearGRI(WorldInfo.GRI).IsCoopMultiplayerGame())
			{
				// check for last bullet bonus
				if ((WeaponMagSize - AmmoUsedCount) == 0 && Range <= 512.f)
				{
					BaseDamage *= (1.0f + LastBulletStrongerPercent);
				}
				// also check for difficulty scaling
				PRI = GearPRI(Instigator.PlayerReplicationInfo);
				if (PRI != None)
				{
					if(bIgnoreDifficultyDamageScale)
					{
						BaseDamage *= class'DifficultySettings_Normal'.default.PlayerDamageMod;
					}
					else if (GP != none)
					{
						BaseDamage *= GP.PlayerDamageMod;
					}
					else
					{
						BaseDamage *= PRI.Difficulty.default.PlayerDamageMod;
					}
				}
			}
		}
		// if we're a COG then use the friendly damage modifier
		else
		{
			PRI = GearPRI(Instigator.PlayerReplicationInfo);
			if (PRI != None && PRI.Team != None && PRI.Team.TeamIndex == 0)
			{
				if(bIgnoreDifficultyDamageScale)
				{
					BaseDamage *= class'DifficultySettings_Normal'.default.FriendDamageMod;
				}
				else
				{
					BaseDamage *= PRI.Difficulty.default.FriendDamageMod;
				}
			}
		}
	}

	// Multiply the super damage from the warpawn to the weapon.
	// This is initially done so that we can make AI buddies blow through levels on splits.
	if( GP != None )
	{
		BaseDamage *= GP.SuperDamageMultiplier;
	}
}


/**
 * Returns active-reload damage multiplier for this weapon.  Can be affected by active reload
 * (or anything else for that matter).
 **/
simulated function float GetActiveReloadDamageMultiplier()
{
	local float Retval;
	local GearPawn GP;

	GP = GearPawn(Instigator);

	// if we are in a AR bonus active state
	if( (GP != None) && GP.bActiveReloadBonusActive )
	{
		Retval = RandRange( ActiveReload_DamageMultiplier.X, ActiveReload_DamageMultiplier.Y );
	}
	else
	{
		Retval = 1.0f;
	}

	return Retval;
}

simulated function float GetExploRadiusMultiplier()
{
	local float Retval;
	local GearPawn GP;

	GP = GearPawn(Instigator);

	// if we are in a AR bonus active state
	if( (GP != None)  && GP.bActiveReloadBonusActive )
	{
		Retval = RandRange( ActiveReload_ExploRadiusMultiplier.X, ActiveReload_ExploRadiusMultiplier.Y );
	}
	else
	{
		Retval = 1.0f;
	}

	return Retval;

}

/** Sets unlimited magazine size (= disables reloads) */
simulated final function SetInfiniteMagazineSize()
{
	WeaponMagSize = 0;
}

/** Clears unlimited magazine size */
simulated final function ClearInfiniteMagazineSize()
{
	WeaponMagSize = default.WeaponMagSize;
}

/** Sets unlimited amount of spare ammo (= never runs out of ammo, but has to reload weapon */
simulated final function SetInfiniteSpareAmmo()
{
	bInfiniteSpareAmmo = true;
}

/** Clears unlimited amount of spare ammo */
simulated final function ClearInfiniteSpareAmmo()
{
	bInfiniteSpareAmmo = default.bInfiniteSpareAmmo;
}

/** @return whether our remaining ammo is low (so draw red on HUD, etc) */
simulated function bool IsCriticalAmmoCount()
{
	return (SpareAmmoCount + WeaponMagSize - AmmoUsedCount <= CriticalAmmoCount);
}

/** returns rate of fire of weapon*/
simulated function float GetRateOfFire()
{
	local float RetVal;
	local GearPawn GP;
	local Controller PawnController;

	RetVal = WeaponRateOfFire;

	if (Instigator != None)
	{
		PawnController = GetWeaponController();
		if (Instigator.IsHumanControlled(PawnController) || GearAI_TDM(GetWeaponController()) != None)
		{
			// check for active reload bonus (note AI doesn't get AR Bonuses)
			GP = GearPawn(Instigator);

			// if we are in a AR bonus active state
			if( (GP != None) && GP.bActiveReloadBonusActive )
			{
				RetVal *= RandRange( ActiveReload_RateOfFireMultiplier.X, ActiveReload_RateOfFireMultiplier.Y );
			}
		}
		else
		{
			// scale for AI
			RetVal *= AI_RateOfFire_Scale;
		}
	}

	return RetVal;
}

/** Set the rate of fire for the weapon */
simulated function SetRateOfFire(float NewRate)
{
	WeaponRateOfFire = NewRate;
}

/** Resets the rate of fire back to the default */
simulated function ResetRateOfFire()
{
	WeaponRateOfFire = default.WeaponRateOfFire;
}


/************************************************************************************
 * Aim / View
 ***********************************************************************************/

/**
 * Called before firing weapon to adjust Trace/Projectile aiming
 * State scoped function. Override in proper state
 * Network: Server
 *
 * @param	StartFireLoc,	world location of weapon start trace or projectile spawning
 */

simulated function rotator GetAdjustedAim(vector StartFireLoc)
{
	local rotator AimRot;
	local float AimError;

	AimRot	= Instigator.GetAdjustedAimFor(self, StartFireLoc);

	// modify Aim to add player aim error
	// and convert aim error from degrees to Unreal Units ( * 65536 / 360 )
	AimError = GetPlayerAimError() * 182.044;
	if (AimError > 0.0)
	{
		AimRot.Pitch += AimError * (0.5 - FRand());
		AimRot.Yaw += AimError * (0.5 - FRand());
	}

	return AimRot;
}


/** Returns player aim error */
simulated function float GetPlayerAimError()
{
	return Lerp(WeaponAimError.X, WeaponAimError.Y, GearInventoryManager(InvManager).Accuracy);
}

/**
 * Set Weapon Recoil effect, which modifies the player view rotation
 *
 * @param	PitchRecoil, Pitch offset added to player view rotation
 */
simulated protected function SetWeaponRecoil(int PitchRecoil)
{
	local int YawRecoil;
	local vector Dir, X, Y, Z;
	local float Dist;

	YawRecoil = (0.5f - FRand()) * PitchRecoil;

	if (GearAIController != None && GearPawn(Instigator) != None)
	{
		// apply directly to AI's targeting offset
		// could change rotation instead, but that will start correcting instantly
		// whereas changing the AI's target location won't result in an update until
		// the next time the AI re-evaluates its aiming error
		Dir = GearAIController.GetFocalPoint() - Instigator.Location;
		Dist = VSize(Dir);
		GetAxes(rotator(Dir), X, Y, Z);
		GearAIController.CurrentAimLocationOffset += Y * Tan(float(YawRecoil) * PI / 32768.0) * Dist;
		GearAIController.CurrentAimLocationOffset += Z * Tan(float(PitchRecoil) * PI / 32768.0) * Dist;
	}
	else
	{
		WeaponRecoilOffset.Pitch += PitchRecoil;
		WeaponRecoilOffset.Yaw += YawRecoil;
	}
}

simulated function int GetWeaponRecoil()
{
	return WeaponRecoil;
}

/** allows weapon opportunity to override AI aiming (for tossing falling projectiles, artillery, etc) */
function OverrideAIAimRotation(out rotator DesiredAimRot, vector StartFireLoc, vector AimLoc);

simulated function Rotator GetHumanAimRotationAdjustment();

/**
 * Called from PlayerController::UpdateRotation() -> PlayerController::ProcessViewRotation() ->
 * Pawn::ProcessViewRotation() -> GearInventoryManager::::ProcessViewRotation() to (pre)process player ViewRotation.
 * adds delta rot (player input), applies any limits and post-processing
 * returns the final ViewRotation set on PlayerController
 *
 * @param	DeltaTime, time since last frame
 * @param	ViewRotation, actual PlayerController view rotation
 * @input	out_DeltaRot, delta rotation to be applied on ViewRotation. Represents player's input.
 * @return	processed ViewRotation to be set on PlayerController.
 */

simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local Rotator	DeltaRecoil;
	local float		DeltaPitch, DeltaYaw;
	local GearPC	PC;

	// Add Weapon recoil offset to view rotation
	if( WeaponRecoilOffset != Rot(0,0,0) )
	{
		// add recoil offset smoothly
		DeltaRecoil.Pitch	= WeaponRecoilOffset.Pitch	- FInterpTo( WeaponRecoilOffset.Pitch,	0, DeltaTime, RecoilInterpSpeed );
		DeltaRecoil.Yaw		= WeaponRecoilOffset.Yaw	- FInterpTo( WeaponRecoilOffset.Yaw,	0, DeltaTime, RecoilInterpSpeed );

		WeaponRecoilOffset	-= DeltaRecoil;
		PC = GearPC(GetWeaponController());
		if( PC != None )
		{
			DeltaRecoil = Normalize(PC.LimitViewRotation( out_ViewRotation + DeltaRecoil, Instigator.ViewPitchMin, Instigator.ViewPitchMax ) - out_ViewRotation);
		}
		out_DeltaRot		+= DeltaRecoil;

		if( DeltaRecoil == rot(0,0,0) )
		{
			WeaponRecoilOffset = rot(0,0,0);
		}

		AutoCorrectWeaponRecoilOffset += DeltaRecoil;
		RecoilAutoCorrectTime = WorldInfo.TimeSeconds + RecoilAutoCorrectDelay;
	}
	else
	if( AutoCorrectWeaponRecoilOffset != rot(0,0,0) &&
		WorldInfo.TimeSeconds > RecoilAutoCorrectTime )
	{
		DeltaPitch	= AutoCorrectWeaponRecoilOffset.Pitch	- FInterpTo( AutoCorrectWeaponRecoilOffset.Pitch,	0, DeltaTime, RecoilAutoCorrectSpeed );
		DeltaYaw	= AutoCorrectWeaponRecoilOffset.Yaw		- FInterpTo( AutoCorrectWeaponRecoilOffset.Yaw,		0, DeltaTime, RecoilAutoCorrectSpeed );

		out_DeltaRot.Pitch -= DeltaPitch * RecoilAutoCorrectPct;
		out_DeltaRot.Yaw   -= DeltaYaw   * RecoilAutoCorrectPct;
		AutoCorrectWeaponRecoilOffset.Pitch -= DeltaPitch;
		AutoCorrectWeaponRecoilOffset.Yaw   -= DeltaYaw;

		//`log( "Delta Pitch:"@out_DeltaRot.Pitch@"Delta Yaw"@out_DeltaRot.Yaw@"Sub"@DeltaPitch@DeltaYaw );

		if( Abs(DeltaPitch) <= 1.f && Abs(DeltaYaw) <= 1.f )
		{
			AutoCorrectWeaponRecoilOffset = rot(0,0,0);
		}
	}
}


/**
 *	Should Targeting Mode trigger the Zoom camera mode?
 */
simulated function bool ShouldTargetingModeZoomCamera()
{
	local GearPawn P;

	P = GearPawn(Instigator);
	if( P == None )
	{
		return FALSE;
	}

	return (bUseTargetingCamera && !IsReloading() && P.bIsTargeting);
}


/** Notification that Targeting Mode has changed. */
simulated function TargetingModeChanged(GearPawn P)
{
	TimeSinceTargeting = WorldInfo.TimeSeconds;
}

/** Return TRUE to prevent targeting */
simulated function bool ShouldPreventTargeting()
{
	return bPreventTargeting;
}

/** Return TRUE to force targeting */
simulated function bool ShouldForceTargeting()
{
	return FALSE;
}

/** Notification called when Pawn.bDoing360Aiming flag changes. */
simulated function On360AimingChangeNotify();


/*********************************************************************************************
 * Ammunition
 *********************************************************************************************/


/**
 * Initializes ammo counts, when weapon is spawned.
 */
function InitializeAmmo()
{
	AddAmmo(InitialMagazines * WeaponMagSize);
}

/** called in Siege games every SiegeAmmoRegenFrequency seconds when not at max */
function RegenAmmo()
{
	if (SpareAmmoCount < WeaponMaxSpareAmmo && Pawn(Owner) != None)
	{
		if ( SpareAmmoCount == 0 && AmmoUsedCount == WeaponMagSize &&
			Instigator != None && PlayerController(Instigator.Controller) != None )
		{
			PlayerController(Instigator.Controller).ClientPlaySound(GearGameSiege_Base(WorldInfo.Game).AmmoRegenSound);
		}
		AddAmmo(Min(WeaponMagSize, WeaponMaxSpareAmmo - SpareAmmoCount));

		// if we're not full, set the timer to regenerate some more
		if (SpareAmmoCount < WeaponMaxSpareAmmo)
		{
			SetTimer(SiegeAmmoRegenFrequency, false, nameof(RegenAmmo));
		}
	}
}

/**
 * @see Weapon::ConsumeAmmo
 * function also made simulated to ammo consumption is done instantly on client, before waiting for replication.
 * this fixes auto reloads not working on a local machine, but lag could had induced other bugs.
 * ammo is still replicated, so if it gets out of synch, client would still be corrected.
 */
simulated function ConsumeAmmo( byte FireModeNum )
{
	local GearPawn GP;

	// Don't consume ammo if magazine size is 0 (infinite ammo with no reload) so that if we decide
	// to stop infinite ammo the ammo count is proper
	if (WeaponMagSize > 0)
	{
		if (WorldInfo.Netmode != NM_Client && (!bFreeARShots || ActiveReload_NumBonusShots <= 0))
		{
			AmmoUsedCount++;
		}

		if (ActiveReload_NumBonusShots <= 0)
		{
			// and disable the bonus if we've run out of magic bullets
			GP = GearPawn(Instigator);
			if (GP != None && GP.bActiveReloadBonusActive)
			{
				TurnOffActiveReloadBonus();
			}
		}
		else
		{
			// consume bonus shot
			--ActiveReload_NumBonusShots;
		}

		if ( WorldInfo.NetMode != NM_Client && SiegeAmmoRegenFrequency > 0.0 && !IsTimerActive(nameof(RegenAmmo)) &&
			GearGameSiege_Base(WorldInfo.Game) != None && Instigator != None && Instigator.GetTeamNum() == TEAM_LOCUST )
		{
			SetTimer(SiegeAmmoRegenFrequency, false, nameof(RegenAmmo));
		}
	}

	// This is the "you are about to run out of ammo" sound better reload! (clickclick)
	if (WeaponMagSize - AmmoUsedCount < NeedReloadNotifyThreshold && !bInfiniteSpareAmmo)
	{
		GearWeaponPlaySoundLocal(NeedReloadNotifySound,,, true);
	}
	else if (IsCriticalAmmoCount() && Instigator != None && Instigator.IsLocallyControlled())
	{
		GearWeaponPlaySoundLocal(AlmostOutOfAmmoSound,,, true);
	}
}

simulated function int GetDefaultAmmoAmount()
{
	return WeaponMagSize * (1 + default.InitialMagazines);
}

simulated function int GetPickupAmmoAmount()
{
	return (WeaponMagSize - AmmoUsedCount) + SpareAmmoCount;
}

simulated function int CopyAmmoAmountFromWeapon( GearWeapon InvWeapon )
{
	AmmoUsedCount	= InvWeapon.AmmoUsedCount;
	SpareAmmoCount	= Min(InvWeapon.SpareAmmoCount, WeaponMaxSpareAmmo);

	return SpareAmmoCount + (WeaponMagSize - AmmoUsedCount);
}

/**
 *	Checks if weapon has room to pickup ANY ammo
 *	@return		TRUE if ammo will be accepted, FALSE otherwise
 */
simulated function bool CanPickupAmmo()
{
	if( CharacterSlot != EASlot_None &&
		WeaponMaxSpareAmmo > 0 &&
		SpareAmmoCount < WeaponMaxSpareAmmo )
	{
		return TRUE;
	}

	return FALSE;
}

/**
 * Add ammo to weapon
 * @param	Amount to add.
 * @return	Amount actually added. (In case magazine is already full and some ammo is left
 */

function int AddAmmo( int Amount )
{
	local int	OldAmount, AmountAdded, MagazineSize, AmmoInCurrentMag, AmmoToReload;

	// If we can't accept spare ammo, then abort
	if( WeaponMaxSpareAmmo <= 0 )
	{
		return 0;
	}

	MagazineSize		= WeaponMagSize;
	AmmoInCurrentMag	= MagazineSize - AmmoUsedCount;
	AmmoToReload		= AmmoUsedCount;
	OldAmount			= AmmoInCurrentMag + SpareAmmoCount;
	SpareAmmoCount		= SpareAmmoCount + Amount;

	// Take into account ammo that will be reloaded, so we cap to MaxSpareAmmoSize + AmmoToReload
	SpareAmmoCount		= Min(SpareAmmoCount, WeaponMaxSpareAmmo + AmmoToReload);
	AmountAdded			= (SpareAmmoCount + AmmoInCurrentMag) - OldAmount;
	bForceNetUpdate		= TRUE;

	AmmoUpdated();

	return AmountAdded;
}

/**
 * Remove ammo from weapon
 *
 * @param	Amount to remove.
 *
 * @return	Amount actually removed.
 *
 */
function int RemoveAmmo(int Amount)
{
	local int AmmoInCurrentMag, AmmoRemovedFromMagazine, AmmoRemovedFromSpare;

	AmmoInCurrentMag = WeaponMagSize - AmmoUsedCount;
	AmmoRemovedFromSpare = Min(SpareAmmoCount, Amount);
	AmmoRemovedFromMagazine = Min(AmmoInCurrentMag, Amount - AmmoRemovedFromSpare);

	AmmoUsedCount += AmmoRemovedFromMagazine;
	SpareAmmoCount -= AmmoRemovedFromSpare;

	bForceNetUpdate	= TRUE;

	AmmoUpdated();

	return AmmoRemovedFromSpare + AmmoRemovedFromMagazine;
}

/** Notification called when ammo count has been updated. */
simulated function AmmoUpdated()
{
	// check to see if we should reload here as we may have had no ammo
	// in the active weapon and just picked up some ammo
	if( PendingFire(RELOAD_FIREMODE) || ShouldAutoReload() )
	{
		ForceReload();
	}
}

/** Send a message to the controller that ammo has been added */
final function AddAmmoMessage(int AmountAdded, optional bool bWasAmmoShare)
{
	local GearPawn GP;
	local GearPC PC;

	GP = GearPawn(Instigator);
	if (GP != None)
	{
		// tell the hud to draw the ammo addition
		PC = GearPC(GetWeaponController());
		if ( PC != None )
		{
			PC.ClientAddAmmoMessage(DamageTypeClassForUI, AmountAdded, bWasAmmoShare);
		}
	}
}


/** Returns true if spare ammo is available (outside of current magazine) */
simulated final function bool HasSpareAmmo()
{
	return ( bInfiniteSpareAmmo ||	// unlimited extra ammo
			SpareAmmoCount > 0 );		// spare ammo left
}


/** @see Weapon::HasAmmo */
simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	local float MagazineSize;

	// we can always reload our weapon or do a melee attack
	if( FireModeNum == RELOAD_FIREMODE || FireModeNum == MELEE_ATTACK_FIREMODE )
	{
		return TRUE;
	}

	// Assume we ask for at least 1 bullet to be there.
	if( Amount == 0 )
	{
		Amount = 1;
	}
	MagazineSize = WeaponMagSize;

	// If we have fired more than Magazine capacity, then we need to reload
	if( MagazineSize > 0 &&
		AmmoUsedCount + Amount > MagazineSize )
	{
		return FALSE;
	}

	return TRUE;
}


/** Has weapon any ammo left? Regardless of firing mode and spare magazines. */
simulated function bool HasAnyAmmo()
{
	// we have just a single fire mode. So just check for this one.
	return (HasSpareAmmo() || HasAmmo(0));
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	// always accept pickups. GearDroppedPickup is responsible for adding inventory, or giving ammo instead.
	return FALSE;
}

/** Deprecated, do not use this one, see below. */
simulated function PlayWeaponAnimation( Name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh);


/** Returns the AnimNodeSequence the weapon is using to play animations. */
simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
	//`DLog("CustomAnimNode:" @ CustomAnimNode);
	if( CustomAnimNode != None )
	{
		//`DLog("SeqNode:" @ CustomAnimNode.GetCustomAnimNodeSeq());
		return CustomAnimNode.GetCustomAnimNodeSeq();
	}

	return Super.GetWeaponAnimNodeSeq();
}


/**
 * Play an animation on the weapon mesh.
 *
 * @param	AnimName		Name of animation to play.
 * @param	Rate			Rate animation should be played at.
 * @param	BlendInTime		Blend duration to play anim.
 * @param	BlendOutTime	Time before animation ends (in seconds) to blend out.
 *							-1.f means no blend out.
 *							0.f = instant switch, no blend.
 *							otherwise it's starting to blend out at AnimDuration - BlendOutTime seconds.
 * @param	bLooping		Should the anim loop? (and play forever until told to stop)
 * @param	bOverride		play same animation over again only if bOverride is set to true.
 *
 * @return	PlayBack length of animation.
 */
simulated function float PlayWeaponAnim
(
				name	AnimName,
				float	Rate,
	optional	float	BlendInTime,
	optional	float	BlendOutTime,
	optional	bool	bLooping,
	optional	bool	bOverride
)
{
	local AnimNodeSequence	AnimNode;

	if( CustomAnimNode != None )
	{
		return CustomAnimNode.PlayCustomAnim(AnimName, Rate, BlendInTime, BlendOutTime, bLooping, bOverride);
	}
	else
	{
		AnimNode = GetWeaponAnimNodeSeq();

		// Check if we can play animation
		if( AnimNode == None )
		{
			if (WorldInfo.NetMode != NM_DedicatedServer)
			{
				`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "GearWeapon::PlayWeaponAnim - no animations :( Trying to play:" @ AnimName);
			}
			return 0.f;
		}

		// Set right animation sequence if needed
		if( AnimNode.AnimSeq == None || AnimNode.AnimSeq.SequenceName != AnimName )
		{
			AnimNode.SetAnim(AnimName);
		}

		if( AnimNode.AnimSeq == None )
		{
			`log("GearWeapon::PlayWeaponAnim - AnimSeq == None" @ Self @ "Instigator:" @ Instigator @ "trying to play:" @ AnimName );
			return 0.f;
		}

		// Play Animation
		AnimNode.PlayAnim(bLooping, Rate);
		return AnimNode.GetAnimPlaybackLength();
	}
}


/**
 * Play an animation on the weapon mesh.
 *
 * @param	AnimName		Name of animation to play.
 * @param	Duration		duration in seconds the animation should be played.
 * @param	BlendInTime		Blend duration to play anim.
 * @param	BlendOutTime	Time before animation ends (in seconds) to blend out.
 *							-1.f means no blend out.
 *							0.f = instant switch, no blend.
 *							otherwise it's starting to blend out at AnimDuration - BlendOutTime seconds.
 * @param	bLooping		Should the anim loop? (and play forever until told to stop)
 * @param	bOverride		play same animation over again only if bOverride is set to true.
 */
simulated function PlayWeaponAnimByDuration
(
				name	AnimName,
				float	Duration,
	optional	float	BlendInTime,
	optional	float	BlendOutTime,
	optional	bool	bLooping,
	optional	bool	bOverride
)
{
	local SkeletalMeshComponent	SkelMesh;
	local float					Rate;

	if( CustomAnimNode != None )
	{
		CustomAnimNode.PlayCustomAnimByDuration(AnimName, Duration, BlendInTime, BlendOutTime, bLooping, bOverride);
	}
	else
	{
		SkelMesh = SkeletalMeshComponent(Mesh);

		// Check if we can play animation
		if( SkelMesh == None || AnimName == '' )
		{
			return;
		}

		Rate = SkelMesh.GetAnimRateByDuration(AnimName, Duration);
		PlayWeaponAnim(AnimName, Rate, BlendInTime, BlendOutTime, bLooping, bOverride);
	}
}


/**
 * Returns TRUE if weapon is playing a given animation.
 * @param	AnimName		Animation sequence name to test.
 * @param	bMustBeLooping	if animation is not looping, then FALSE will be returned.
 */
simulated function bool IsPlayingAnim(Name AnimName, bool bMustBeLooping)
{
	local AnimNodeSequence		AnimNode;

	if( CustomAnimNode != None )
	{
		return CustomAnimNode.bIsPlayingCustomAnim;
	}
	else
	{
		AnimNode = GetWeaponAnimNodeSeq();

		// Check if we can play animation
		if( AnimNode == None )
		{
			//`log( GetFuncName() @ "no mesh or no animations :(");
			return FALSE;
		}

		// test if animation is considered playing
		if( !AnimNode.bPlaying ||
			AnimNode.AnimSeq.SequenceName != AnimName ||
			bMustBeLooping && !AnimNode.bLooping )
		{
			return FALSE;
		}

		return TRUE;
	}
}


/** freeze weapon animation. */
simulated function FreezeWeaponAnim()
{
	local AnimNodeSequence		AnimNode;

	AnimNode = GetWeaponAnimNodeSeq();

	// Check if we have access to anim...
	if( AnimNode == None )
	{
		//`log( GetFuncName() @ "no animations :(");
		return;
	}

	AnimNode.bPlaying = FALSE;
}


/** Scale weapon animation play rate */
simulated function ScaleWeaponAnimPlayRate(float Scale)
{
	local AnimNodeSequence		AnimNode;

	AnimNode = GetWeaponAnimNodeSeq();

	// if there is no anim node we can't do anything
	if( AnimNode != None )
	{
		AnimNode.Rate *= Scale;
	}
}

/** Stop a weapon animation, and rewinds it */
simulated function StopWeaponAnim(optional float BlendOutTime)
{
	local AnimNodeSequence		AnimSeq;

	if( CustomAnimNode != None )
	{
		CustomAnimNode.StopCustomAnim(BlendOutTime);
	}
	else
	{
		AnimSeq = GetWeaponAnimNodeSeq();

		// if there is no skel mesh we can't do anything
		if( AnimSeq != None )
		{
			AnimSeq.StopAnim();
			AnimSeq.SetPosition(0.f, FALSE);
		}
	}
}


/** Set a new animation, overwriting current one */
simulated final function SetWeaponAnim(Name AnimName)
{
	local AnimNodeSequence	AnimSeq;

	AnimSeq = GetWeaponAnimNodeSeq();

	if( AnimSeq != None )
	{
		AnimSeq.SetAnim(AnimName);
	}
	else
	{
		`DLog("No weapon anim node seq!!");
	}
}


/** Stop a weapon animation, and rewinds it */
simulated final function SetWeaponAnimPosition(float NewPosition)
{
	local AnimNodeSequence		AnimSeq;

	AnimSeq = GetWeaponAnimNodeSeq();

	if( AnimSeq != None )
	{
		AnimSeq.SetPosition(NewPosition, FALSE);
	}
	else
	{
		`DLog("No weapon anim node seq!!");
	}
}


/** @see Weapon::GetFireInterval */
simulated function float GetFireInterval( byte FireModeNum )
{
	return 60.f / GetRateOfFire();
}


/************************************************************************************
 * Firing / Effects
 ***********************************************************************************/


/**
 * Event called when Pawn.FiringMode has been changed.
 * bViaReplication indicates if this was the result of a replication call.
 */
simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	local bool		bPrevIsReload, bNewIsReload;
	local GearPawn	GPOwner;
	local GearPC	PCOwner;

	// If melee is finished, send weapon to neutral state (remote clients)
	// and fire up MeleeAttackEnded() notification.
	if( bViaReplication && PreviousFiringMode == MELEE_ATTACK_FIREMODE )
	{
		MeleeAttackEnded();
	}

	// Handle reload aborts here.
	// If previous firing mode is for a reload
	bPrevIsReload = PreviousFiringMode == RELOAD_FIREMODE ||
					PreviousFiringMode == FIREMODE_FAILEDACTIVERELOAD ||
					PreviousFiringMode == FIREMODE_ACTIVERELOADSUCCESS ||
					PreviousFiringMode == FIREMODE_ACTIVERELOADSUPERSUCCESS;

	// If new firing mode is for a reload
	bNewIsReload = FiringMode == RELOAD_FIREMODE ||
					FiringMode == FIREMODE_FAILEDACTIVERELOAD ||
					FiringMode == FIREMODE_ACTIVERELOADSUCCESS ||
					FiringMode == FIREMODE_ACTIVERELOADSUPERSUCCESS;

	if( bPrevIsReload && !bNewIsReload )
	{
		// If weapon reload was aborted, then abort it...
		if( IsTimerActive( nameof(EndOfReloadTimer) ) )
		{
			AbortWeaponReload();
		}

		// Update Heavy weapon mouting status if needed
		PCOwner = GearPC(GetWeaponController());
		if( PCOwner != None && PCOwner.IsLocalPlayerController() )
		{
			// First need to update Targeting status, to see if player is still targeting or not
			// This gets set to FALSE when reloading weapons
			PCOwner.UpdateTargetingStatus();

			// Then update heavy weapon status.
			GPOwner = GearPawn(Instigator);
			if( GPOwner != None )
			{
				GPOwner.CheckHeavyWeaponMounting();
			}
		}
	}

	// if we're reloading our weapon, play anim
	switch( FiringMode )
	{
		case RELOAD_FIREMODE					: PlayWeaponReloading();	break;
		case FIREMODE_FAILEDACTIVERELOAD		: PlayActiveReloadFailed(); break;
		case FIREMODE_ACTIVERELOADSUCCESS		: PlayActiveReloadSuccess(FALSE); break;
		case FIREMODE_ACTIVERELOADSUPERSUCCESS	: PlayActiveReloadSuccess(TRUE); break;
		case MELEE_ATTACK_FIREMODE				: // For remote clients, fire up melee started notification
													if( bViaReplication )
													{
														MeleeAttackStarted();
													}
													break;
	}

	// Keep track of last firing mode
	PreviousFiringMode = FiringMode;
}


/**
 * Called by Pawn when FlashCount has been updated.
 * FlashCount > 0 denotes that weapon has fired.
 * FlashCount == 0 denotes that weapon stopped firing.
 * Network: ALL
 */
simulated function FlashCountUpdated(byte FlashCount, byte FiringMode, bool bViaReplication)
{
	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ "FlashCount:" @ FlashCount @ "bViaReplication:" @ bViaReplication );
	if( FlashCount > 0 )
	{
		WeaponFired(FiringMode);
	}
	else
	{
		WeaponStoppedFiring(FiringMode);
	}
}


/**
 * The whole FlashLocation usage in warfare...
 * FlashLocation is used to denote the location of an instant hit impact (or max range if an impact didn't occur).
 * It is replicated to all clients, including the owner of the weapon.
 *
 * Local Player
 * FlashLocation is only used to replicate the exact impact location of the hit.
 * The Weapon fire animations are played locally when the player initiated the firing sequence locally.
 *
 * Remote Clients
 * FlashLocation is used to replicate the exact impact location, but also initiate the firing sequence for remote clients.
 */

/** overridden to allow on client when bClientSideInstantHit is set */
simulated function SetFlashLocation( vector HitLocation )
{
	if (Instigator != None && (Role == ROLE_Authority || bClientSideInstantHit))
	{
		Instigator.SetFlashLocation( Self, CurrentFireMode, HitLocation );
	}
}

/**
* @returns position of trace start for instantfire()
*/
simulated function vector InstantFireStartTrace()
{
	local vector CameraLoc;
	local rotator UnusedRot;

	// If a human player is zooming, the instant fire trace needs to start from the adjusted camera location to line up exactly with the crosshair
	if (UseFirstPersonCamera() && Instigator.Controller != None)
	{
		Instigator.Controller.GetPlayerViewPoint(CameraLoc, UnusedRot);

		return CameraLoc;
	}

	return Instigator.GetWeaponStartTraceLocation();
}

/**
* @returns end trace position for instantfire()
*/
simulated function vector InstantFireEndTrace(vector StartTrace)
{
	return StartTrace + vector(GetAdjustedAim(StartTrace)) * GetTraceRange();
}

/**
 * Changed this function for warfare's weapon system.
 * WeaponFired() is called instantly on local clients, so there is no delay playing weapon firing effects.
 * remote clients do everything when FlashLocation is replicated.
 *
 * Network: LocalPlayer and Server.
 */
simulated function InstantFire()
{
	local GearPawn	PawnOwner;
	local vector			StartTrace, EndTrace;
	local Array<ImpactInfo>	ImpactList;
	local int				Idx;
	local ImpactInfo		RealImpact;
	local Controller PawnController;

	PawnOwner = GearPawn(Instigator);

	if ( (Role == ROLE_Authority) && (PawnOwner != None) )
	{
		PawnOwner.CauseCrowdPanic();
	}

	// Servers proceed as normal
	PawnController = GetWeaponController();
	if (WorldInfo.Netmode != NM_Client || (bClientSideInstantHit && Instigator != None && Instigator.IsLocallyControlled(PawnController)))
	{
		// If InteractionPawn is Based on PawnOwner, then disable his collision when firing.
		// This is to prevent kidnapper from firing through the hostage
		if( PawnOwner != None && PawnOwner.InteractionPawn != None && PawnOwner.InteractionPawn.IsBasedOn(PawnOwner) )
		{
			PawnOwner.InteractionPawn.Mesh.SetTraceBlocking(FALSE, PawnOwner.InteractionPawn.Mesh.BlockNonZeroExtent);
		}

		// define range to use for CalcWeaponFire()
		StartTrace = InstantFireStartTrace();

		//`log(`showvar(StartTrace) @ GetAdjustedAim(StartTrace));
		//`log(`showvar(Instigator.Controller.Rotation));

//		DrawDebugBox(StartTrace, vect(5,5,5), 64, 255, 64, TRUE);
		EndTrace = InstantFireEndTrace(StartTrace);
//		DrawDebugBox(EndTrace, vect(25,25,25), 255, 255, 255, TRUE);
//		DrawDebugLine(StartTrace, EndTrace, 255, 255, 255, TRUE);
		// Perform shot
		RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);

		if (Role == ROLE_Authority || bClientSideInstantHit)
		{
			// Set flash location to trigger client side effects.
			// if HitActor == None, then HitLocation represents the end of the trace (maxrange)
			// Remote clients perform another trace to retrieve the remaining Hit Information (HitActor, HitNormal, HitInfo...)
			// Here, The final impact is replicated. More complex bullet physics (bounce, penetration...)
			// would probably have to run a full simulation on remote clients.
			SetFlashLocation(RealImpact.HitLocation);
		}

		// Process all Instant Hits on local player and server (gives damage, spawns any effects).
		for (Idx = 0; Idx < ImpactList.Length; Idx++)
		{
			ProcessInstantHit(CurrentFireMode, ImpactList[Idx]);
		}

		// Restore collision
		if( PawnOwner != None && PawnOwner.InteractionPawn != None && PawnOwner.InteractionPawn.IsBasedOn(PawnOwner) )
		{
			PawnOwner.InteractionPawn.Mesh.SetTraceBlocking(TRUE, PawnOwner.InteractionPawn.Mesh.BlockNonZeroExtent);
		}

`if(`notdefined(FINAL_RELEASE))
		if( PawnOwner != None )
		{
			bDebuggingShots = PawnOwner.bWeaponDebug_Accuracy;
			if( bDebuggingShots )
			{
				ClientFlushPersistentDebugLines();
				DebugShotStartLoc = StartTrace;
				DebugShotAimRot = rotator(EndTrace-StartTrace);
				DrawDebugShot(DebugShotStartLoc, DebugShotAimRot);

				DrawDebugLine( DebugShotStartLoc+vect(0,0,5), DebugShotStartLoc + vector(DebugShotAimRot) * Range_Melee, 255, 1, 1, true );
				DrawDebugLine( DebugShotStartLoc+vect(0,0,5), DebugShotStartLoc + vector(DebugShotAimRot) * Range_Short, 255, 255, 1, true );
				DrawDebugLine( DebugShotStartLoc+vect(0,0,10), DebugShotStartLoc + vector(DebugShotAimRot) * Range_Medium, 1, 255, 1, true );
				DrawDebugLine( DebugShotStartLoc+vect(0,0,15), DebugShotStartLoc + vector(DebugShotAimRot) * Range_Long, 1, 1, 255, true );
			}
		}
`endif
	}
	else if( Instigator != None && Instigator.IsLocallyControlled(PawnController) )
	{
		// local player simulates firing locally, to give instant response.
		// FlashLocation will only replicate the exact impact location, and play impact effects.
		WeaponFired( CurrentFireMode );
	}


}


/**
 * Changed this function for warfare's weapon system: It is now also called on LocalPlayer.
 * SetFlashLocation() is called only on servers, to replicate proper impact location.
 * However WeaponFired() is called instantly on local clients, so there is no delay playing weapon firing effects.
 * remote clients do everything when replicated.
 *
 * Network: LocalPlayer and Server.
 */

simulated function ClearFlashLocation()
{
	local Controller PawnController;

	if( Instigator != None )
	{
		PawnController = GetWeaponController();

		if( WorldInfo.Netmode != NM_Client )
		{
			Instigator.ClearFlashLocation( Self );
		}
		else if( Instigator.IsLocallyControlled(PawnController) )
		{
			WeaponStoppedFiring( CurrentFireMode );
		}
	}
}


/**
 * Notification called when FlashLocation is updated.
 *
 * @param	FiringMode		that triggered the update.
 * @param	FlashLocation	replication location vector (typically used for the impact location)
 * @param	bViaReplication	if update has been triggered as a result of a replication call.
 */

simulated function FlashLocationUpdated(byte FiringMode, vector FlashLocation, bool bViaReplication)
{
	local bool		bValidFiringUpdate;
	local Controller PawnController;

	PawnController = GetWeaponController();

	// ignore FlashLocation replication if using client side hit location
	//@FIXME: should change Pawn to not send it
	if (bViaReplication && bClientSideInstantHit && Instigator != None && Instigator.IsLocallyControlled(PawnController))
	{
		return;
	}

	// valid firing update (impact location) if FlashLocation is non zero.
	// Zero is used to denote a weapon stopping to fire.
	bValidFiringUpdate = !IsZero(FlashLocation);

	// we cannot post process any impact while reloading, FiringMode was lost.
	if( FiringMode == RELOAD_FIREMODE )
	{
		//`log( `location @ " FiringMode is same as reload firemode:" @ RELOAD_FIREMODE @ "Abort and don't trigger a firing update." @ self @ Instigator );
		bValidFiringUpdate = false;
	}

	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ "FlashLocation:" $ FlashLocation @ "bViaReplication:" $ bViaReplication @ "bValidFiringUpdate:" $ bValidFiringUpdate @ "bSlaveWeapon:" $ bSlaveWeapon );

	// for server or remote clients, a FlashLocation update, triggers a weapon fire.
	// on the local client, the update is triggered instantly, not through replication.
	if (WorldInfo.Netmode != NM_Client || bClientSideInstantHit || bSlaveWeapon || WorldInfo.IsPlayingDemo())
	{
		if( bValidFiringUpdate )
		{
			WeaponFired( FiringMode, FlashLocation );
		}
		else
		{
			WeaponStoppedFiring( CurrentFireMode );
		}
	}

	// if we've been replicated, then calculate remote impact effects.
	if( bValidFiringUpdate && bViaReplication )
	{
		CalcRemoteImpactEffects( FiringMode, FlashLocation, bViaReplication );
	}
}

/**
 * Called when the weapon has fired, to trigger any effects.
 * Network: ALL
 */
simulated event WeaponFired(byte FiringMode, optional vector HitLocation)
{
	local GearPawn GP;
	local GearPC PC;

	GP = GearPawn(Owner);

	if ( FiringMode != RELOAD_FIREMODE && FiringMode != FIREMODE_FAILEDACTIVERELOAD &&
		FiringMode != FIREMODE_ACTIVERELOADSUCCESS && FiringMode != FIREMODE_ACTIVERELOADSUPERSUCCESS )
	{
		PlayFireEffects(FiringMode, HitLocation);
	}

	//`log( `location @ `showvar(FiringMode) @ `showvar(HitLocation) );
	if (Instigator != None)
	{
		if (WorldInfo.NetMode != NM_Client)
		{
			//@STATS - Record fired weapon
			`RecordWeaponIntStat(WEAPON_FIRED,GetWeaponController(),Class,1);
		}

		Instigator.WeaponFired(Self, FALSE, HitLocation);
	}

	if( GP != None )
	{
		// mark the last time the weapon was fired for AI use
		GP.LastWeaponStartFireTime = WorldInfo.TimeSeconds;

		// indicate we should draw the weapon indicator
		PC = GearPC(GetWeaponController());
		if ( PC != None )
		{
			PC.SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
		}
	}
}


/**
 * Called when weapon stops firing.
 * @NOTE:	this is not a state scoped function (remote clients ignore the state the weapon is in)
 * Network: ALL
 *
 * @param	FireModeNum.
 */
simulated event WeaponStoppedFiring(byte FiringMode)
{
	if( Instigator != None )
	{
		Instigator.WeaponStoppedFiring(Self, FALSE);
	}

	StopFireEffects(FiringMode);

	// turn off shell eject particle system
	if( PSC_ShellEject != None )
	{
		PSC_ShellEject.DeActivateSystem();
		SetTimer( 1.0, FALSE, nameof(HidePSC_ShellEject) );
	}
}

/** @return time in seconds before and after an actual shot that a CSHD result should be accepted as being in the firing window */
final function float GetCSHDPingTolerance()
{
	return Min(Instigator.PlayerReplicationInfo.Ping * 4 * 1.5, 400) * 0.001 + 0.035;
}

/** this is used for client side hit detection */
reliable server function ServerNotifyHit(byte FiringMode, ImpactInfo Impact, byte HitType, byte NumHits)
{
	local GearPawn GP;
	local Box HitBox;
	local vector BoxExtent, BoxCenter;
	local float ViewDotHitDir;

	// RayDir passed in is multiplied to avoid side effect of compression; reverse that now
	Impact.RayDir = Normal(Impact.RayDir * 0.001);

	// if HitActor didn't replicate it, try to get it from the hit component
	// this most commonly happens when hitting StaticMeshCollectionActors, as they are created by the cooker and so don't replicate
	if (Impact.HitActor == None && Impact.HitInfo.HitComponent != None)
	{
		Impact.HitActor = Impact.HitInfo.HitComponent.Owner;
	}

	// validate the shot
	// check that we're actually using this fire mode
	// and we're facing in that general direction
	if (GearGameSP_Base(WorldInfo.Game) != None && GearPawn(Instigator) != None && Vehicle(Instigator.Base) != None)
	{
		//@hack: the scripted vehicle motion makes this check unreliable; the player could get turned very quickly very fast in between client and server shot
		ViewDotHitDir = 1.0;
	}
	else
	{
		ViewDotHitDir = vector(Instigator.GetViewRotation()) dot Normal(Impact.HitLocation - Instigator.GetWeaponStartTraceLocation());
	}
	if ( bClientSideInstantHit && Role == ROLE_Authority && Instigator != None && Impact.HitActor != None &&
		//@hack: somehow can be melee attacking with CurrentFireMode == 0 in rare exploitable cases
		!IsMeleeing() &&
		// ~45 degrees
		ViewDotHitDir > AllowedViewDotHitDir )
	{
		// allow "late" client hits within reasonable window if the client hasn't already sent one for this fire attempt
		if (IsFiring() || (!bGotClientHit && WorldInfo.TimeSeconds - LastShotTime <= GetCSHDPingTolerance()))
		{
			// assume it told the truth about static things because the hit doesn't have significant gameplay implications
			if (Impact.HitActor.bStatic)
			{
				ProcessInstantHit_Internal(FiringMode, Impact);
			}
			else
			{
				// and the target is really there
				Impact.HitActor.GetComponentsBoundingBox(HitBox);
				// increase both a bit because the hitlocation is usually on the edge of the cylinder
				// and because we want to give a reasonable leeway to the client's results
				BoxExtent = 0.5 * (HitBox.Max - HitBox.Min);
				BoxExtent *= ClientSideHitLeeway;
				// avoid precision errors with really thin objects
				BoxExtent.X = FMax(10.0, BoxExtent.X);
				BoxExtent.Y = FMax(10.0, BoxExtent.Y);
				BoxExtent.Z = FMax(10.0, BoxExtent.Z);
				// if we're in co-op, allow as long as it's in the ballpark
				if (GearGameSP_Base(WorldInfo.Game) != None)
				{
					BoxExtent *= 3.0;
				}
				BoxCenter = (HitBox.Min + HitBox.Max) * 0.5;
				if ( Abs(Impact.HitLocation.Z - BoxCenter.Z) < BoxExtent.Z &&
					Abs(Impact.HitLocation.X - BoxCenter.X) < BoxExtent.X &&
					Abs(Impact.HitLocation.Y - BoxCenter.Y) < BoxExtent.Y )
				{
					GP = GearPawn(Impact.HitActor);
					if (GP != None)
					{
						GP.HandleServerSideComponentRemap(Impact, HitType);
					}
					ProcessInstantHit_Internal(FiringMode, Impact);
				}
			}
		}
		else if (bGotClientHit || IsInState('WeaponEquipping') || IsReloading())
		{
			// queue for a short time in case the client is slightly ahead
			QueuedCSHDInfo.FiringMode = FiringMode;
			QueuedCSHDInfo.Impact = Impact;
			QueuedCSHDInfo.HitType = HitType;
			QueuedCSHDInfo.NumHits = NumHits;
			QueuedCSHDInfo.Time = WorldInfo.TimeSeconds;
		}
		else
		{
			`Log(self @ "Rejected client side hit (not firing and out of ping tolerance)");
		}
	}
	else if (ViewDotHitDir <= AllowedViewDotHitDir)
	{
		`Log(self @ "Rejected client side hit due to facing too far from the hit direction" @ ViewDotHitDir);
	}
	else
	{
		`Log(self @ "Rejected client side hit");
	}

	bGotClientHit = true;
}

/*
 * Process Instant Hit is called to process a Hit.
 * It can be called from InstantFire() (LocalPlayer and Server) or CalcRemoteImpactEffects() (remote clients).
 * Using that same path for server/local/remote is specific to warfare.
 */
simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	local GearPawn GP;
	local Controller PawnController;
	local byte HitType;

	// Zero will always be reserved for no component getting hit
	HitType = 0;

	NumHits = Clamp(NumHits, 1, 255); // force <= 0 to 1, and clamp to byte range for replication
	if (bClientSideInstantHit && Instigator != None)
	{
		PawnController = GetWeaponController();
		if (PawnController != None)
		{
			if (Instigator.IsLocallyControlled(PawnController))
			{
				if (WorldInfo.NetMode == NM_Client && Impact.HitActor != None && Impact.HitActor.RemoteRole == ROLE_Authority)
				{
					GP = GearPawn(Impact.HitActor);
					if ( (GP != none) && (Impact.HitInfo.HitComponent != GP.Mesh) && (Impact.HitInfo.HitComponent != None) )
					{
						HitType = GP.GetPawnSpecificComponentHitType(Impact.HitInfo.HitComponent);
					}

					// multiply RayDir for replication to avoid effects of vector compression
					Impact.RayDir *= 1000.f;
					ServerNotifyHit(FiringMode, Impact, HitType, NumHits);
					Impact.RayDir *= 0.001f;
				}
			}
			else if ( Impact.HitActor != None
				&& ( Impact.HitActor.RemoteRole == ROLE_SimulatedProxy || Impact.HitActor.RemoteRole == ROLE_AutonomousProxy ||
					Impact.HitActor.bStatic || Impact.HitActor.bNoDelete ) )
			{
				// client will tell us if it hit this thing
				return;
			}
		}
	}

	ProcessInstantHit_Internal(FiringMode, Impact);
}

simulated final function bool ShouldRegisterDamage( Actor A )
{
	local GearPawn HitPawn;

	if (A != None && !bSuppressDamage)
	{
		if (WorldInfo.NetMode != NM_Client || A.Role == ROLE_Authority)
		{
			return TRUE;
		}

		HitPawn = GearPawn(A);
		if (HitPawn != None && HitPawn.bTearOff)
		{
			return TRUE;
		}

		// Acceptable client side hit actors
		if ( FracturedStaticMeshActor(A) != None || FluidSurfaceActor(A) != None || CrowdAgentBase(A) != None ||
			KAsset(A) != None || InteractiveFoliageActor(A) != None )
		{
			return TRUE;
		}
	}

	return FALSE;
}

/** handles the effects of weapon firing. Separated out so that clientside hit detection can just call this part
 * for valid client hits
 */
simulated final private function ProcessInstantHit_Internal(byte FiringMode, const out ImpactInfo Impact)
{
	local Controller		CheckPlayer;
	local GearPawn			HitPawn, TargetPawn;
	local GearPC			GearPC;
	local GearAI			AIShooter;
	local class<DamageType> DamageTypeToUse;
	local GearAI			AI;
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;
	local Actor HitActor;
	local int BeforeHitHealth;

	HitActor = Impact.HitActor;

	if (HitActor != None && HitActor.bWorldGeometry)
	{
		HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
		if ( (HitStaticMesh != None) && HitStaticMesh.CanBecomeDynamic() )
		{
			NewKActor = class'KActorFromStatic'.Static.MakeDynamic(HitStaticMesh);
			if ( NewKActor != None )
			{
				HitActor = NewKActor;
			}
		}
	}
	else
	{
		HitPawn = GearPawn(HitActor);
	}

	//debug
	`log( self@GetFuncName()@FiringMode@HitActor@Impact.HitInfo.HitComponent, bDebug );

	//`log(GetFuncName()@HitPawn@HitPawn.Health@HitPawn.bTearOff@GP);

	// use the default corresponding to our fire mode
	DamageTypeToUse = InstantHitDamageTypes[FiringMode];

	// if we hit something on the server, then deal damage to it.
	// We also accept dead pawns (torn off) on clients for local impacts and rag doll fun
	if( ShouldRegisterDamage( HitActor ) )
	{
		BeforeHitHealth = -9999999;
		//if the hit actor is a pawn, lets declare that a hit for now
		if (HitPawn != None)
		{
			BeforeHitHealth = HitPawn.Health;
		}

		HitActor.TakeDamage(	GetFireModeDamage( Impact.HitLocation, HitActor ),
									GetWeaponController(),
									Impact.HitLocation,
									InstantHitMomentum[FiringMode] * Impact.RayDir,
									DamageTypeToUse,
									Impact.HitInfo,
									self );

		if (BeforeHitHealth != -9999999 && BeforeHitHealth > HitPawn.Health && Instigator != None)
		{
			GearPC = GearPC(Instigator.Controller);
			if (GearPC != None && GearPC.StatManager != None)
			{
				GearPC.StatManager.ModifyStat(name(WeaponStatName $ "ShotsHit" $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix),1,GEARSTATMODTYPE_Delta);
			}
		}
	}

	// Skip impacts for triggers and trigger volumes. We just want to forward damage to these, nothing else.
	if( Trigger(HitActor) != None ||
		TriggerVolume(HitActor) != None ||
		GrenadeBlockingVolume(HitActor) != None )
	{
		return;
	}

	// notify nearby players of a miss. This assumes currently one impact point. If we end up having several (reflection, penetration) we have to revise this.
	if( (WorldInfo.Netmode != NM_Client) && (HitPawn == None) )
	{
		// if we didn't hit a player
		if ( GearPC(GetWeaponController()) != None)
		{
			// notify any nearby players of the near miss
			foreach WorldInfo.AllControllers(class'Controller', CheckPlayer)
			{
				if( GearPawn(CheckPlayer.Pawn) == None || CheckPlayer.Pawn == Instigator || WorldInfo.GRI.OnSameTeam(Instigator, CheckPlayer.Pawn) )
				{
					continue;
				}

				GearPC = GearPC(CheckPlayer);
				if( GearPC != None )
				{
					GearPC.CheckNearMiss(Instigator, Self, Impact, DamageTypeToUse);
				}
				else
				{
					AI = GearAI(CheckPlayer);
					if( AI != None )
					{
						AI.CheckNearMiss(Instigator, Self, Impact, DamageTypeToUse);
					}
				}
			}
		}
		else
		{
			// for AI shots, just notify the target
			AIShooter = GearAI(GetWeaponController());
			if ( AIShooter != None )
			{
				TargetPawn = GearPawn(AIShooter.FireTarget);
				if ( TargetPawn != None )
				{
					GearPC = GearPC(TargetPawn.Controller);
					if( GearPC != None )
					{
						GearPC.CheckNearMiss(Instigator, Self, Impact, DamageTypeToUse);
					}
					else
					{
						AI = GearAI(TargetPawn.Controller);
						if( AI != None )
						{
							AI.CheckNearMiss(Instigator, Self, Impact, DamageTypeToUse);
						}
					}
				}
			}
		}
	}

	// if a visual client, is relevant, hit something, and didn't hit a player (FX handled via TakeDamage->DoDamageEffects)
	if( WorldInfo.NetMode != NM_DedicatedServer
		&& HitActor != None
		&& (HitPawn == None || HitPawn.ShouldPlayNonDamageHitEffects(Impact, Instigator, DamageTypeToUse) )
		)
	{
		SpawnImpactFX( Instigator, self, class<GearDamageType>(DamageTypeToUse), Impact, false, false, false, bSuppressImpactFX);
	}
}

/** gives the weapon an opportunity to affect who gets points for damage inflicted by this weapon
 * currently only called for instant hit shots
 * @return whether the default behavior has been overridden; if false, standard scoring rules apply in addition to whatever happens here
 */
function bool ModifyDamageScoring(GearPRI DamagedPRI, GearPRI InstigatorPRI, float Damage, class<GearDamageType> DamageType);

/**
 * Kicks off sound/particles/decals based on an ImpactInfo struct, called on all visual clients either simulated locally or
 * replicated through GearPawn.ReplicatedPlayTakeHitEffects().
 * @param TheInstigator - Pawn that fired the weapon
 * @param Weapon - Reference to weapon (dummy fire has a weapon but no instigator, so Instigator.Weapon is not possible)
 * @param GearDmgType - damage type reference for effects
 * @param Impact - information about the impact
 * @param bFatalShot
 * @param bMeleeHit -
 * @param bPlayExplosiveRadialDamageEffects -
 * @param bSuppressImpactFXIn - should impact effects be played (dummy fire mostly)
 */
simulated static function SpawnImpactFX(Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, const out ImpactInfo Impact, bool bFatalShot, bool bMeleeHit, bool bPlayExplosiveRadialDamageEffects, bool bSuppressImpactFXIn)
{
	local PhysicalMaterial PhysMaterial;
	local GearPawn GP;
	local WorldInfo WI;

	WI = class'Engine'.static.GetCurrentWorldInfo();

	// we probably want to also move up the FrameRate Dependent checking to here instead of calling the function and then just returning nothing
	// so it is really this:
	// if the framerate allows us to spawn effect<type> then we need to go and look and see if it is relevant to us
	// (for all relevant effects we have to check framerate shizzle so might as ALWAYS just have a Framerate check cost
	// before doing the more expensive relevancy checks / or going through and trying to spawn stuff
	//

	if ( !GearDmgType.default.bSuppressImpactFX )
	{
		GP = GearPawn(Impact.HitActor);
		if( (GP == None) || (WI.TimeSeconds - GP.TimeOfDeath < 20.0) || !GP.bTearOff )
		{
			// grab the physical material to get things rolling
			PhysMaterial = class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterial(Impact);

			//`log( "SpawnImpactFX" @ default.class.name );
			// only Spawn impact effects if the Pawn has not been dead for too long
			if( (TheInstigator == None) || TheInstigator.EffectIsRelevant(Impact.HitLocation, false, 4000.0) )
			{
				// play the impact effect(s)
				SpawnImpactEffects( TheInstigator, Weapon, GearDmgType, Impact, PhysMaterial, bFatalShot, bMeleeHit, bPlayExplosiveRadialDamageEffects, bSuppressImpactFXIn );
				//`log( " SpawnImpactEffects" @ self );

				// only Spawn impact decals if the Pawn has not been dead for too long
				if( (GP == None) || (WI.TimeSeconds - GP.TimeOfDeath < 5.0) || !GP.bTearOff )
				{
					// leave a decal
					SpawnImpactDecal( TheInstigator, Weapon, GearDmgType, Impact, PhysMaterial );
				}
			}
		}

		// play an impact sound
		SpawnImpactSounds( TheInstigator, Weapon, GearDmgType, Impact, PhysMaterial );
	}
}

/**
 * This will spawn a PhysicalMaterial based effect.	 It looks up the PhysicalMaterial
 * tree until it finds a valid effect to Spawn.	 If it does not find one then
 * it defaults the effect coded in to the .uc file for that specific weapon
 * @param TheInstigator - Pawn that fired the weapon (none from dummy fire)
 * @param Weapon - Reference to weapon (dummy fire has a weapon but no instigator, so Instigator.Weapon is not possible)
 * @param GearDmgType - damage type reference for effects
 * @param Impact - information about the impact
 * @param PhysMaterial - physical material properties for the impact
 */
simulated static function SpawnImpactDecal(Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, const out ImpactInfo Impact, PhysicalMaterial PhysMaterial)
{
	local WorldInfo WI;
	local DecalData DecalData;
	local GearPawn GP;
	local SkeletalMeshComponent SkelMeshHitComponent;

	GP = GearPawn(Impact.HitActor);
	WI = class'Engine'.static.GetCurrentWorldInfo();

	// if we are NOT a head bone then we can leave a decal
	if( (GP == None) || ( GP.TookHeadShot(Impact.HitInfo.BoneName, Impact.HitLocation, Impact.RayDir) == FALSE ) )
	{
		SkelMeshHitComponent = SkeletalMeshComponent(Impact.HitInfo.HitComponent);
		if( (SkelMeshHitComponent == None)
			|| ( (SkelMeshHitComponent != None) && (TheInstigator != None) && (VSize(Impact.HitLocation - TheInstigator.Location) < default.DecalImpactRelevanceDistanceSkelMesh) )
			&& ( ClassIsChildOf( GearDmgType, class'GDT_Explosive' ) == FALSE )
			)
		{
			//`LogExt("Instigator:"@Instigator@"PhysMaterial:"@PhysMaterial@"HitActor:"@Impact.HitActor);
			DecalData = class'GearPhysicalMaterialProperty'.static.DetermineImpactDecalData( PhysMaterial, GearDmgType, GearPawn(TheInstigator) != None ? GearPawn(TheInstigator).bActiveReloadBonusActive : FALSE, WI, TheInstigator );

			//`log( "SpawnImpactDecal PhysMaterial: " $ PhysMaterial @ DecalData.DecalMaterial );

			// create the actual decal
			if( DecalData.bIsValid )
			{
				class'GearDecal'.static.StaticAttachFromImpact(TheInstigator, Impact, DecalData);
			}
		}

		// so now check to see if we hit a pawn (not on the shield or cleaver or a silverback) and need to do a exit wound splatter decal (50% of the time)
		if( ( Frand() < 0.50 ) && ( GP != None ) && GP.bSpawnHitEffectDecals &&
				!GP.IsA('GearPawn_SilverbackBase') && !GP.HitEquipment(Impact.HitInfo.HitComponent) )
		{
			//`LogExt("Instigator:"@Instigator@"PhysMaterial:"@PhysMaterial@"HitActor:"@Impact.HitActor);
			DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Impact.HitInfo ), GDTT_ExitWoundSplatter, WI );

			//`log( "SpawnImpactDecal PhysMaterial: " $ PhysMaterial @ DecalData.DecalMaterial );

			// create the actual decal
			if( DecalData.bIsValid )
			{
				class'GearDecal'.static.StaticAttachToSurface(TheInstigator, Impact.HitLocation, Impact.RayDir, 128.0f, Impact, DecalData);
			}
		}
	}
}

/** allows subclasses to override the particle system for impacts - ignored if the Pawn overrides first */
simulated static function ParticleSystem GetImpactOverrideParticleSystem(ImpactInfo Hit);

/**
 * Handles the visual effects portion of the impactFX based on an ImpactInfo struct, called on all visual clients either simulated locally or
 * replicated through GearPawn.ReplicatedPlayTakeHitEffects().
 * @param TheInstigator - Pawn that fired the weapon
 * @param Weapon - Reference to weapon (dummy fire has a weapon but no instigator, so Instigator.Weapon is not possible)
 * @param GearDmgType - damage type reference for effects
 * @param Impact - information about the impact
 * @param PhysMaterial - physical material properties for the impact
 * @param bWasFatalShot
 * @param bWasMeleeAttack
 * @param bPlayExplosiveRadialDamageEffects
 * @param bSuppressImpactFXIn - should impact effects be played (dummy fire mostly)
 */
simulated static function SpawnImpactEffects(Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, ImpactInfo Impact, PhysicalMaterial PhysMaterial, bool bWasFatalShot, bool bWasMeleeAttack, bool bPlayExplosiveRadialDamageEffects, bool bSuppressImpactFXIn )
{
	local WorldInfo WI;
	local SkeletalMeshComponent SMC;
	local vector DirectionToSprayParticles, BoneRelativeLocation;
	local rotator BoneRelativeRotation;
	local GearPawn HitPawn;
	local ParticleSystem ImpactPS;
	local ParticleSystemComponent ImpactPSC;
	local name AttachToBoneName;

	//`LogExt("Hit:"@Impact.HitActor@"HitComp"@Impact.HitInfo.HitComponent@"Fatal:"@bWasFatalShot@"Melee:"@bWasMeleeAttack@"PhysMat:"@PhysMaterial@GearDmgType@GearDmgType.default.bSuppressImpactFX);

	WI = class'Engine'.static.GetCurrentWorldInfo();

	// abort early if FX are turned off (dummy fire)
	if( bSuppressImpactFXIn || GearDmgType.default.bSuppressImpactFX || WI.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// check to see if we're dealing with a pawn
	HitPawn = GearPawn(Impact.HitActor);

	// if it's a fatal shot,we will spawn GoreExplosion blood there!

	// if it's a melee hit,
	if (bWasMeleeAttack)
	{
		if( WI.GRI.ShouldShowGore() && HitPawn != None )
		{
			ImpactPS = HitPawn.PS_MeleeImpactEffect;
		}
		// If gore is off, use the cleaver hit which is sparks
		else
		{
			ImpactPS = class'GearPhysicalMaterialProperty'.static.DetermineImpactParticleSystem( PhysMaterial, class'GDT_CleaverMelee', GearPawn(TheInstigator) != None ? GearPawn(TheInstigator).bActiveReloadBonusActive : FALSE, WI, TheInstigator );
		}
	}
	else if( bPlayExplosiveRadialDamageEffects )
	{
		if( WI.GRI.ShouldShowGore() )
		{
			ImpactPS = HitPawn.PS_RadialDamageEffect;
		}
		// If gore is off, use the cleaver hit which is sparks
		else
		{
			ImpactPS = class'GearPhysicalMaterialProperty'.static.DetermineImpactParticleSystem( PhysMaterial, class'GDT_CleaverMelee', GearPawn(TheInstigator) != None ? GearPawn(TheInstigator).bActiveReloadBonusActive : FALSE, WI, TheInstigator );
		}
	}
	else
	{
		// check for a pawn override
		// Pawn must exist, and you must have not shot the shield or a cleaver
		if (HitPawn != None && !HitPawn.HitEquipment(Impact.HitInfo.HitComponent) )
		{
			ImpactPS = HitPawn.GetImpactOverrideParticleSystem();
		}
		// check for a weapon override
		if (ImpactPS == None )
		{
			ImpactPS = GetImpactOverrideParticleSystem(Impact);
		}
		if (ImpactPS == None)
		{
			// otherwise look to the physical material
			ImpactPS = class'GearPhysicalMaterialProperty'.static.DetermineImpactParticleSystem( PhysMaterial, GearDmgType, GearPawn(TheInstigator) != None ? GearPawn(TheInstigator).bActiveReloadBonusActive : FALSE, WI, TheInstigator );
		}
	}

	//`LogExt("- ImpactPS:"@ImpactPS);

	// if we ended up with a particle system
	if (ImpactPS != None)
	{
		SMC = SkeletalMeshComponent(Impact.HitInfo.HitComponent);
		DirectionToSprayParticles = Impact.HitNormal;
		// attach to the skeletal mesh component if possible
		if (SMC != None)
		{
			// Make sure we always have a valid bone name (e.g. ink grenade damage)
			AttachToBoneName = (Impact.HitInfo.BoneName == '') ? HitPawn.MeleeDamageBoneName : Impact.HitInfo.BoneName;
			// Fall back is finding closest bone to hit location.
			if( AttachToBoneName == '' )
			{
				AttachToBoneName = SMC.FindClosestBone(Impact.HitLocation);
			}

			SMC.TransformToBoneSpace(AttachToBoneName, Impact.HitLocation, rotator(DirectionToSprayParticles), BoneRelativeLocation, BoneRelativeRotation);
			// get a particle system component for this system
			ImpactPSC = WI.MyEmitterPool.SpawnEmitterMeshAttachment(ImpactPS, SMC, AttachToBoneName, false, BoneRelativeLocation, BoneRelativeRotation);
			ImpactPSC.SetLODLevel(GearGRI(WI.GRI).GetLODLevelToUse(ImpactPSC.Template, Impact.HitLocation));
			ImpactPSC.SetAbsolute( ImpactPSC.AbsoluteTranslation, ImpactPSC.AbsoluteRotation, TRUE );
		}
		// otherwise grab an ol' fashioned emitter
		else
		{
			WI.MyEmitterPool.SpawnEmitter(ImpactPS, Impact.HitLocation, rotator(DirectionToSprayParticles), Impact.HitActor);
		}
	}
	else
	{
		`warn("No impact particle system found:"@default.Class@Impact.HitActor@PhysMaterial@GearDmgType);
	}
}


simulated function PlayMeleeScreenShake( GearPawn Victim )
{
	local GearPC PC;

	// shake attacker
	PC = GearPC(GetWeaponController());
	if( PC != None )
	{
		// we already do a forcefeedback elsewhere, no need to do it here too
		PC.ClientPlayCameraShake(MeleeImpactCamShake);
	}

	// shake victim
	if(Victim != None)
	{
		PC = GearPC(GetPawnController(Victim));
		if( PC != None )
		{
			// we already do a forcefeedback elsewhere, no need to do it here too
			PC.ClientPlayCameraShake(MeleeImpactCamShake,,, CAPS_UserDefined, rotator(Instigator.Location - Victim.Location));
		}
	}

}

/**
 * This will spawn a PhysicalMaterial based sound.	It looks up the PhysicalMaterial
 * tree until it finds a valid sound to Spawn.	If it does not find one then
 * it defaults the sound coded in to the .uc file for that specific weapon
 * @param TheInstigator - Pawn that fired the weapon
 * @param Weapon - Reference to weapon (dummy fire has a weapon but no instigator, so Instigator.Weapon is not possible)
 * @param GearDmgType - damage type reference for effects
 * @param Impact - information about the impact
 * @param PhysMaterial - physical material properties for the impact
 **/
simulated static function SpawnImpactSounds(Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, ImpactInfo Impact, PhysicalMaterial PhysMaterial)
{
	local SoundCue ImpactCue;
	local GearPC GPC;
	local bool bHitSelf;
	local bool bHitSquad;

	if (TheInstigator != None)
	{
		foreach TheInstigator.LocalPlayerControllers(class'GearPC', GPC)
		{
			if (GPC.Pawn == Impact.HitActor)
			{
				bHitSelf = true;
				break;
			}
			else if (GPC.Pawn != None && GPC.Pawn.IsSameTeam(Pawn(Impact.HitActor)))
			{
				bHitSquad = true;
			}
		}
	}

	ImpactCue = class'GearPhysicalMaterialProperty'.static.DetermineImpactSound(PhysMaterial, GearDmgType, bHitSelf, bHitSquad);

	if (ImpactCue != None)
	{
		// play the sound
		if (Weapon != None)
		{
			Weapon.PlaySound(ImpactCue, true, true, false, Impact.HitLocation, true);
		}
		else
		{
			Impact.HitActor.PlaySound(ImpactCue, true, true, false, Impact.HitLocation, true);
		}
	}
}

simulated function Actor GetTraceOwner()
{
	local Actor A;

	// For dummy fire weapon, try to trace from skeletal mesh actor
	if( bDummyFireWeapon )
	{
		A = DummyFireParent;
		while( A != None && !A.IsA('SkeletalMeshActor') )
		{
			A = A.Base;
		}
		if( A != None )
		{
			return A;
		}
	}

	return Super.GetTraceOwner();
}

simulated function SetCurrentFireMode(byte FiringModeNum)
{
	// slave weapons receive their firing mode through replication of the Pawn property
	if (!bSlaveWeapon)
	{
		Super.SetCurrentFireMode(FiringModeNum);
	}
}

simulated event DummyFire(byte FireModeNum, vector TargetLoc, optional Actor AttachedTo, optional float AimErrorDeg, optional Actor TargetActor)
{
	local ImpactInfo InstantHitImpact;
	local vector StartLoc, EndLoc;
	local rotator AimRot;
	local float AimErrorUnr;

	DummyFireParent = AttachedTo;
	bDummyFireWeapon = TRUE;
	DummyFireTargetLoc	= TargetLoc;
	DummyFireTargetActor = TargetActor;

	SetCurrentFireMode(FireModeNum);

	// impact effects
	switch (WeaponFireTypes[FireModeNum])
	{
	case EWFT_Projectile:
		// spit out a projectile
		ProjectileFireSimple(AimErrorDeg);
		break;
	case EWFT_InstantHit:
		// simulate instant hit weapon
		StartLoc = GetPhysicalFireStartLoc();

		AimRot = rotator(DummyFireTargetLoc - StartLoc);

		// modify Aim to add player aim error
		// and convert aim error from degrees to Unreal Units ( * 65536 / 360 )
		if (AimErrorDeg != 0.f)
		{
			AimErrorUnr = AimErrorDeg * 182.044;
			AimRot.Pitch += AimErrorUnr * (0.5 - FRand());
			AimRot.Yaw	 += AimErrorUnr * (0.5 - FRand());
		}

		EndLoc = StartLoc + vector(AimRot) * 30000;		// way out there

		InstantHitImpact = CalcWeaponFire(StartLoc, EndLoc);
		if (InstantHitImpact.HitActor != None)
		{
			WeaponFired(FireModeNum, InstantHitImpact.HitLocation);
			CalcRemoteImpactEffects(FireModeNum, InstantHitImpact.HitLocation, FALSE);
		}
		else
		{
			WeaponFired(FireModeNum, EndLoc);
		}
		break;
	case EWFT_Custom:
		// individual weapon subclass should overload DummyFire in this case
		`log(Self @ "cannot dummy fire because it has a custom fire method, implement DummyFire() on it");
	default:
		break;
	}
}

/** Overridden to add additional object types to ignore. */
simulated static function bool PassThroughDamage(Actor HitActor)
{
	local GearPawn HitPawn;

	HitPawn = GearPawn(HitActor);
	return Super.PassThroughDamage(HitActor) ||
		   HitActor.IsA('GrenadeBlockingVolume') ||
		   (HitPawn != None && HitPawn.bPassThroughDamage);
}

/** basically same as CalcWeaponFire, but a pure query, no side effects
 * @note: make sure the special cases stay mirrored (PassThroughDamage, etc)
 * @param TraceOwner - Actor firing the shot
 * @param StartTrace - point in world space shot originates from
 * @param EndTrace - point in world space shot ends
 */
simulated static function ImpactInfo CalcRemoteWeaponFire(Actor TraceOwner, vector StartTrace, vector EndTrace)
{
	local vector			HitLocation, HitNormal;
	local Actor				HitActor;
	local TraceHitInfo		HitInfo;
	local ImpactInfo		CurrentImpact;
	local bool				bOldBlockActors, bOldCollideActors;

	// Perform trace to retrieve hit info
	HitActor = TraceOwner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, TRUE, vect(0,0,0), HitInfo, TRACEFLAG_Bullet);

	// If we didn't hit anything, then set the HitLocation as being the EndTrace location
	if( HitActor == None )
	{
		HitLocation	= EndTrace;
	}

	// check to see if we've hit a trigger.
	// In this case, we want to add this actor to the list so we can give it damage, and then continue tracing through.
	if ( (HitActor != None) && PassThroughDamage(HitActor) )
	{
		// disable collision temporarily for the trigger so that we can catch anything inside the trigger
		HitActor.bProjTarget = FALSE;
		bOldCollideActors = HitActor.bCollideActors;
		bOldBlockActors = HitActor.bBlockActors;
		if (HitActor.IsA('Pawn'))
		{
			// For pawns, we need ti disable bCollideActors as well
			HitActor.SetCollision(false, false);
		}
		else
		{
			HitActor.SetCollision(bOldCollideActors, false);
		}
		// recurse another trace
		CurrentImpact = CalcRemoteWeaponFire(TraceOwner, HitLocation, EndTrace);
		// and re-enable collision for the trigger
		HitActor.bProjTarget = TRUE;
		HitActor.SetCollision(bOldCollideActors, bOldBlockActors);
	}
	else
	{
		// Convert Trace Information to ImpactInfo type.
		CurrentImpact.HitActor		= HitActor;
		CurrentImpact.HitLocation	= HitLocation;
		CurrentImpact.HitNormal		= HitNormal;
		CurrentImpact.RayDir		= Normal(EndTrace-StartTrace);
		CurrentImpact.HitInfo		= HitInfo;
	}

	return CurrentImpact;
}


/**
 * Calculate weapon impacts for remote clients.
 * Remote clients may only get a HitLocation replicated,
 * so we need to figure out the HitNormal and HitActor to play proper effects.
 * (If you change this, make sure it is appropriately handled in GearVehicle::CalcRemoteImpactEffects)
 */

simulated function CalcRemoteImpactEffects( byte FireModeNum, vector GivenHitLocation, bool bViaReplication )
{
	local vector TraceOffset, AimDir, WeaponLoc, MuzzleLoc;
	local ImpactInfo	TestImpact;
	local float			HitDistance;

	// if no instigator (some system is manipulating weapons by hand), measure from fire start location
	WeaponLoc = (Instigator != None) ? Instigator.Location : Location;

	// if we should spawn a tracer effect for remote clients, let's do so
	if( bViaReplication && ShouldSpawnTracerFX() )
	{
		HitDistance = VSize(GivenHitLocation - WeaponLoc);
		MuzzleLoc = GetMuzzleLoc();
		SpawnTracerEffect( Instigator, MuzzleLoc, Rotator(GivenHitLocation - MuzzleLoc), GivenHitLocation, HitDistance );
	}

	// do another trace to retrieve Hit Info
	AimDir		= Normal(GivenHitLocation - WeaponLoc);
	TraceOffset	= AimDir * 16.f;

	// Only trace slightly before and after our HitLocation
	TestImpact = CalcRemoteWeaponFire(GetTraceOwner(), GivenHitLocation-TraceOffset, GivenHitLocation+TraceOffset);

	// We didn't hit anything, use GivenHitLocation as our HitLocation
	if( TestImpact.HitActor == None )
	{
		TestImpact.HitLocation = GivenHitLocation;
	}

	// Process Instant Hit. We use same path as local clients and server.
	ProcessInstantHit_Internal(FireModeNum, TestImpact);
}


/** return true if should spawn tracer effect for instant trace hits */
simulated function bool ShouldSpawnTracerFX()
{
	return (bAllowTracers && !bSuppressTracers);
}

/**
 * Generate the tracer effect for the weapon
 *
 * @param bIsActiveReload - whether this is an active reload shot or not
 * @param bIsLocalPlayer - whether this is a local player or not
 * @param SpawnLocation - tracer originates here
 * @param SpawnRotation - tracer orientation
 * @param TargetLoc - where the tracer is ending up
 * @param InInstigator - optional actor that triggered this
 *
 * @return the projectile that is the tracer
 */
simulated static function GearProj_BulletTracer GetTracer(bool bIsActiveReload, bool bIsLocalPlayer, vector SpawnLocation, rotator SpawnRotation, vector TargetLoc,optional Actor InInstigator)
{
	local WorldInfo WI;
	local EWeaponTracerType TypeToSpawn;

	WI = class'Engine'.static.GetCurrentWorldInfo();
	if (WI.MyEmitterPool != None)
	{
		TypeToSpawn = bIsActiveReload ? default.TracerTypeAR : default.TracerType;

		return GearEmitterPool(WI.MyEmitterPool).SpawnTracer(TypeToSpawn, SpawnLocation, SpawnRotation, TargetLoc, bIsLocalPlayer);
	}

	return None;
}

/**
 * Spawn tracer effect for instant hit shots.
 * Network: All Clients
 *
 * @param TheInstigator - pawn shooting the weapon
 * @param SpawnLocation	Location of the weapon muzzle
 * @param GunRotation   Orientation of the weapon firing
 * @param HitLocation	Location instant trace did hit
 * @param HitDistance	Distance to the hit location
 */
simulated static function GearProj_BulletTracer SpawnTracerEffect( Pawn TheInstigator, vector SpawnLocation, rotator SpawnRotation, vector HitLocation, float HitDistance )
{
	local WorldInfo			WI;
	local GearPawn			InstigatorGP;
	local GearProj_BulletTracer	SpawnedProjectile;
	local GearPC GPC;
	local GearEmitterPool GEP;
	local bool bIsActiveReload, bIsLocalPlayer;

	WI = class'Engine'.static.GetCurrentWorldInfo();
	GEP = GearEmitterPool(WI.MyEmitterPool);
	if (WI.NetMode != NM_DedicatedServer &&
		GEP != None)
	{
		// NOTE we want the tracers to ALWAYS be relevant as there are lots of cases where people are shooting things far far away
		// and maybe have been hidden somewhere for more than 2 seconds.
		// and in MP seeing tracers from some hidden spot is vital
		// and in SP the AI often hides behind you so you can get into the case where they are shooting but you see not tracers

		InstigatorGP = GearPawn(TheInstigator);
		if (InstigatorGP != None)
		{
			// Is this an AR shot?
			bIsActiveReload = InstigatorGP.bActiveReloadBonusActive;
			GPC = GearPC(InstigatorGP.Controller);
			// Check for local player
			bIsLocalPlayer = GPC != None && GPC.IsLocalPlayerController() && GPC.IsViewingTarget(InstigatorGP);
		}

		// Spawn a tracer smoke trail only a percentage of the time - percentage is in spawntracersmoke now
		// also limit tracer smoke based on EffectIsRelevant
		if ( default.bAlwaysSpawnTracerSmoke
			|| bIsLocalPlayer || (!WI.bDropDetail && ((TheInstigator == None) || TheInstigator.EffectIsRelevant(TheInstigator.Location, false, 4000.0))) )
		{
			GEP.SpawnTracerSmoke(bIsActiveReload ? default.TracerTypeAR : default.TracerType,
				SpawnLocation,
				SpawnRotation,
				bIsLocalPlayer,
				HitLocation);
		}

		// always spawn a tracer
		// old-style projectile tracers.  The smoke trail is a beam particle effect but FX artists want this type of tracer
		if (HitDistance > default.ShowTracerDistance)
		{
			SpawnedProjectile = GetTracer(bIsActiveReload,
				bIsLocalPlayer,
				SpawnLocation,
				SpawnRotation,
				HitLocation,
				TheInstigator);
			if (SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe)
			{
				SpawnedProjectile.Instigator = TheInstigator;

				// set tracer scale to 0 for initial frame, tick will fix it
				SpawnedProjectile.SetDrawScale3D(Vect(0.0f,0.0f,0.0f));
			}
		}

		return SpawnedProjectile;
	}

	return None;
}


/**
 * Called when a shot is fired in the following situations:
 * 1) On local player and server.
 * 2) On remote clients if Pawn.FlashCount or Pawn.FlashLocation is incremented on the server.
 *
 * @NOTE:	this is not a state scoped function (non local clients ignore the state the weapon is in)
 *			use the supplied FireModeNum variable.
 *
 * Network: ALL
 *
 * @param	FireModeNum.
 * @param	HitLocation	optional, just sent when replication occured through SetFlashLocation()
 */
simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	local Controller PawnController;

	PawnController = GetWeaponController();

	// Start muzzle flash effect
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// only play the shell eject if we are a player controller
		if (Instigator != None)
		{
			if (Instigator.IsHumanControlled(PawnController) &&
				Instigator.IsLocallyControlled(PawnController))
			{
				PlayShellCaseEject();
				PlayerController(GetWeaponController()).ClientPlayForceFeedbackWaveform(WeaponFireWaveForm);
			}
		}

		// Play muzzle flash effect
		PlayMuzzleFlashEffect();

		// play weapon fire sound
		PlayFireSound();
	}

	// Play fire effects for owned player
	if (WorldInfo.Netmode != NM_Client || (Instigator != None && Instigator.IsLocallyControlled(PawnController)) || bDummyFireWeapon)
	{
		PlayOwnedFireEffects( FireModeNum, HitLocation );
	}
}


/**
 * Called when the weapon stops firing, allows for stoppage of
 * looping effects.
 */
simulated function StopFireEffects(byte FireModeNum)
{
	if (MuzzleFlash != None)
	{
		if( MuzzleFlash.bLoopMuzzleFlashLight )
		{
			// turn off muzzle flash light
			if( MuzzleFlash.MuzzleFlashLight != None )
			{
				MuzzleFlash.MuzzleFlashLight.SetEnabled(FALSE);
			}
		}
	}
}

simulated function PlayShellCaseEject()
{
	local GearPawn	GP;
	local Rotator	NewRot;

	// shell eject particle system
	if( PSC_ShellEject != None )
	{
		GP = GearPawn(Instigator);

		// If pawn is mirrored, then mirror shell ejection Y axis as well
		if( GP != None )
		{
			// we need to manually flip the meshes on the emitters so they are not backwards
			if( GP.bIsMirrored )
			{
				PSC_ShellEject.SetVectorParameter( 'MeshOrientation', vect(1,1,1) );
			}
			else
			{
				PSC_ShellEject.SetVectorParameter( 'MeshOrientation', vect(0,0,0) );
			}

			// we don't want to mirror the shell if we are using the muzzle flash socket as the weapon mesh already is scaled
			if( !ShouldUseMuzzleFlashSocketForShellEjectAttach() )
			{
				// LAURENT: forced offsets, because Component.default.Property doesn't work ATM.
				if( GP.bIsMirrored )
				{
					NewRot.Yaw = 16384;
				}
				else
				{
					NewRot.Yaw = -16384;
				}

				if( PSC_ShellEject.Rotation != NewRot )
				{
					PSC_ShellEject.SetRotation(NewRot);
				}
			}
		}

		ClearTimer( nameof(HidePSC_ShellEject) );
		PSC_ShellEject.SetHidden( FALSE );
	    //@SAS. Set the bJustAttched flag when activating...
		PSC_ShellEject.ActivateSystem(TRUE);
	}
}

/** @return where the tracer should start */
simulated function vector GetTracerStartLoc()
{
	return GetMuzzleLoc();
}

/**
 * Play fire effects for owned player
 * Network: Local Player and Server
 */
simulated function PlayOwnedFireEffects(byte FireModeNum, vector HitLocation)
{
	local vector TracerStart;

	// if we should spawn a tracer effect for the local player, let's do so
	if (WorldInfo.NetMode != NM_DedicatedServer && ShouldSpawnTracerFX() && !IsZero(HitLocation))
	{
		TracerStart = GetTracerStartLoc();
		// if no instigator (some system is manipulating weapons by hand), measure from fire start location
		SpawnTracerEffect(Instigator, TracerStart, rotator(HitLocation - TracerStart), HitLocation, (Instigator != None) ? VSize(HitLocation - Instigator.Location) : VSize(HitLocation - GetMuzzleLoc()));
	}

	if (Instigator != None && Instigator.Controller != None)
	{
		// Add weapon recoil effect to player's viewrotation
		SetWeaponRecoil(GetWeaponRecoil());
		PlayFireCameraEffects();
	}
}

/** Overrideable for special firing audio behavior. */
simulated protected function PlayFireSound()
{
	GearWeaponPlaySoundLocal(FireSound, FireSound_Player, FireSound_Squad,, 1.f);
}

/** Return the screenshake struct to play for this weapon */
simulated protected function GearCameraShake GetFireViewShake()
{
	return FireCameraShake;
}

/** Play Weapon Camera Shake, etc */
simulated function PlayFireCameraEffects( )
{
	local GearCameraShake FCS;
	local GearPC		GPC;

	GPC = GearPC(GetWeaponController());
	if (GPC != None && GPC.IsLocalPlayerController())
	{
		FCS = GetFireViewShake();
		if (FCS != None)
		{
			GPC.ClientPlayCameraShake( FCS, FireCameraShakeScale );
		}
	}
}

/************************************************************************************
 * Muzzle Flash
 ***********************************************************************************/


/** Returns TRUE, if muzzle flash effects should be played. */
simulated function bool IsMuzzleFlashRelevant()
{
	local float MuzzleFlashRadius;
	local Controller PawnController;

	// Not relevant if no effect or on dedicated server
	if ( (WorldInfo.NetMode == NM_DedicatedServer) || (MuzzleFlash == None) )
	{
		return FALSE;
	}

	// Always should muzzle flashes if the instigator is None (dummy fire) or if human controlled
	PawnController = GetWeaponController();
	if( Instigator == None || (Instigator.IsHumanControlled(PawnController) && Instigator.IsLocallyControlled(PawnController)) )
	{
		return TRUE;
	}

	// if frame rate is really bad and Pawn hasn't been rendered recently, then don't display effects
	if( WorldInfo.bAggressiveLOD && WorldInfo.TimeSeconds - Instigator.LastRenderTime > 0.5)
	{
		return FALSE;
	}

	// If we have a muzzle flash light, use its radius as an indication
	MuzzleFlashRadius = MuzzleFlash.MuzzleFlashLight == None ? 250.0 : MuzzleFlash.MuzzleFlashLight.Radius + 40.0;

	return Instigator.EffectIsRelevant(Instigator.Location, false, 5000.0, MuzzleFlashRadius);
}

/**
 * Start muzzle flash effect
 * Network: Local Player and Clients
 */
simulated function PlayMuzzleFlashEffect()
{
	// Play muzzle flash effects only if they are relevant
	if( !bSuppressMuzzleFlash && IsMuzzleFlashRelevant() )
	{
		// activate muzzle flash particle system
		if( MuzzleFlash.MuzFlashEmitter != None )
		{
			ClearTimer( nameof(HideMuzzleFlashEmitter) );
			MuzzleFlash.MuzFlashEmitter.SetHidden( FALSE );

			if (MuzzleFlash.bMuzFlashEmitterIsLooping)
			{
				MuzzleFlash.MuzFlashEmitter.SetLODLevel(GearGRI(WorldInfo.GRI).GetLODLevelToUse(MuzzleFlash.MuzFlashEmitter.Template, GetMuzzleLoc()));
				MuzzleFlash.MuzFlashEmitter.SetActive(TRUE);
			}
			else
			{
				MuzzleFlash.MuzFlashEmitter.SetLODLevel(GearGRI(WorldInfo.GRI).GetLODLevelToUse(MuzzleFlash.MuzFlashEmitter.Template, GetMuzzleLoc()));
				MuzzleFlash.MuzFlashEmitter.ActivateSystem(true);
			}
		}

		if( MuzzleFlash.MuzzleFlashLight != None
			&& !GearGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator)
			&& (!MuzzleFlash.bLoopMuzzleFlashLight || !MuzzleFlash.MuzzleFlashLight.bEnabled)
			)
		{
			MuzzleFlash.MuzzleFlashLight.CastDynamicShadows = bDynamicMuzzleFlashes;
			MuzzleFlash.MuzzleFlashLight.SetEnabled(TRUE);

			// Reset Pulse time to zero, so we start at the beginning.
			MuzzleFlash.MuzzleLightPulseTime = 0.f;
		}

		SetTimer( MuzzleFlash.MuzzleLightDuration, FALSE, nameof(StopMuzzleFlashEffect) );
	}
}



/**
 * Stop muzzle flash effect
 * Network: Local Player and Clients
 */
simulated function StopMuzzleFlashEffect()
{
	if (MuzzleFlash != None)
	{
		if( MuzzleFlash.MuzFlashEmitter != None )
		{
			MuzzleFlash.MuzFlashEmitter.SetActive(FALSE);
			SetTimer( MuzzleFlash.TimeToHideMuzzleFlashPS, FALSE, nameof(HideMuzzleFlashEmitter) );
		}

		// turn off muzzle flash light only if it's non looping
		// Looping ones are turned off when the weapon stops firing
		// Used by rapid fire weapons
		if( !MuzzleFlash.bLoopMuzzleFlashLight && MuzzleFlash.MuzzleFlashLight != None )
		{
			MuzzleFlash.MuzzleFlashLight.SetEnabled( FALSE );
		}
	}
}


simulated function HideMuzzleFlashEmitter()
{
	if (MuzzleFlash != None)
	{
		MuzzleFlash.MuzFlashEmitter.SetHidden( TRUE );
	}
}

simulated function HidePSC_ShellEject()
{
	PSC_ShellEject.SetHidden( TRUE );
	PSC_ShellEject.RewindEmitterInstances();
}

simulated function HidePSC_ReloadBarrelSmoke()
{
	PSC_ReloadBarrelSmoke.SetHidden( TRUE );
}

/************************************************************************************
 * HUD
 ***********************************************************************************/

/**
 * list important Weapon variables on canvas.  HUD will call DisplayDebug() on the current ViewTarget when
 * the ShowDebug exec is used
 *
 * @param	HUD		- HUD with canvas to draw on
 * @input	out_YL		- Height of the current font
 * @input	out_YPos	- Y position on Canvas. out_YPos += out_YL, gives position to draw text for next debug line.
 */

simulated function GetWeaponDebug( out Array<String> DebugInfo )
{
	super.GetWeaponDebug( DebugInfo );

	DebugInfo[DebugInfo.Length] = "AmmoUsedCount:" $ AmmoUsedCount @ "MagazineSize:" $ WeaponMagSize;
	DebugInfo[DebugInfo.Length] = "SpareAmmoCount:" $ SpareAmmoCount @ "SpareAmmoSize:" $ WeaponMaxSpareAmmo;
	DebugInfo[DebugInfo.Length] = "bDisableLeftHandIK:" $ bDisableLeftHandIK;
}


unreliable client function ClientFlushPersistentDebugLines()
{
	FlushPersistentDebugLines();
}


/** Returns TRUE if should draw crosshair */
simulated function bool ShouldDrawCrosshair()
{
	local GearPawn GP;
	local GearVehicle GV;
	local PlayerController PC;
	GP = GearPawn(Instigator);

	if (GP != None && GP.bIsTargeting)
	{
		if (bIronSightsCamera)
		{
			return false;
		}

		return TRUE;
	}

	GV = GearVehicle(Instigator);
	if(GV != None)
	{
		PC = PlayerController(GV.Controller);
	}
	if (PC != None && GV.WantsCrosshair(PC))
	{
		return TRUE;
	}

	return FALSE;
}

/** Returns the value to scale the cross hair by */
simulated function float GetCrossHairScale()
{
	local float MovementBasedAccuracyDegradation;

	if (bCrosshairExpanding)
	{
		if (!GearPawn(Instigator).IsInCover())
		{
			MovementBasedAccuracyDegradation = GearInventoryManager(InvManager).Accuracy;
		}

		if (GearPawn(Instigator).bIsZoomed)
		{
			return CrosshairFullAccurateZoomedScale + (BaseCrosshairScale - CrosshairFullAccurateZoomedScale) * FMax(CrosshairAccuracyMultiplier * MovementBasedAccuracyDegradation, CrosshairFiringScale * CrosshairExpansionFiringTime / CrosshairExpansionTime);
		}
		else
		{
			//`log(`showvar(CrosshairAccuracyMultiplier * MovementAccuracyDegradation));
			//`log(`showvar(CrosshairFiringScale * CrosshairExpansionFiringTime / CrosshairExpansionTime));

			return CrosshairFullAccurateScale + (BaseCrosshairScale - CrosshairFullAccurateScale) * FMax(CrosshairAccuracyMultiplier * MovementBasedAccuracyDegradation, CrosshairFiringScale * CrosshairExpansionFiringTime / CrosshairExpansionTime);
		}
	}

	return BaseCrosshairScale;
}

simulated function Texture2D GetCrosshairIcon(GearPC PC, out float XOffset, out float YOffset)
{
	return CrosshairIcon;
}

/** gives weapon a chance to draw additional info on the crosshair besides the simple image
 * not called if the HUD is already drawing an additional icon (such as the "it's a friendly, don't shoot" indicator)
 */
simulated function DrawAdditionalCrosshair(GearHUD_Base HUD);

/** gives weapon a chance to draw a special ammo indicator instead of the default ammo texture
 * @return whether the default behavior has been overridden so the HUD should do nothing more
 */
simulated function bool DrawSpecialAmmoInfo(GearHUD_Base HUD, float DrawX, float DrawY, float Alpha, float Scale, bool bHighlight)
{
	local float Heat, HeatDrawPercent;

	if (IsHeatLimited())
	{
		// this puts us in the ammo bar
		DrawX += 60.0;
		DrawY += 45.0 * Scale;

		HUD.Canvas.SetPos(DrawX, DrawY) ;
		HUD.Canvas.SetDrawColor(47, 47, 47, Alpha);
		HUD.Canvas.DrawTile(HUDDrawData.AmmoIcon.Texture, HUDDrawData.AmmoIcon.UL * Scale, HUDDrawData.AmmoIcon.VL * Scale, HUDDrawData.AmmoIcon.U, HUDDrawData.AmmoIcon.V, HUDDrawData.AmmoIcon.UL, HUDDrawData.AmmoIcon.VL);

		// Determine the color to draw
		Heat = GetCurrentBarrelHeat();
		if (Heat >= 0.5)
		{
			HeatDrawPercent = (Heat - 0.5) / 0.5;
			HUD.Canvas.SetDrawColor( 255 * (1.0 - HeatDrawPercent) + (OverheatHUDColor.R * HeatDrawPercent),
						255 * (1.0 - HeatDrawPercent) + (OverheatHUDColor.G * HeatDrawPercent),
						255 * (1.0 - HeatDrawPercent) + (OverheatHUDColor.B * HeatDrawPercent), Alpha );
		}
		else
		{
			`SetHUDDrawColorExt(HUD, HUD.HudColors[eWARHUDCOLOR_WHITE], Alpha);
		}

		HUD.Canvas.SetPos(DrawX, DrawY);
		HUD.Canvas.DrawTile(HUDDrawData.AmmoIcon.Texture, HUDDrawData.AmmoIcon.UL * Scale * Heat, HUDDrawData.AmmoIcon.VL * Scale, HUDDrawData.AmmoIcon.U, HUDDrawData.AmmoIcon.V, HUDDrawData.AmmoIcon.UL * Heat, HUDDrawData.AmmoIcon.VL);
		return true;
	}
	else
	{
		return false;
	}
}

/** returns whether or not the passed state name is from a state that actually fires **/
protected simulated function bool IsFireState( name StateName )
{
	return (FiringStatesArray.Find(StateName) != INDEX_NONE);
}

/** if we just reloaded and then consumed ammo, we might have gone to 0 and back to
 * the same value we had before in one tick
 * in this case, variable replication will think nothing has changed,
 * but the client only simulates the ammo counter reset, not the change from firing
 * this function forces an update regardless of the previous value
 */
reliable client final function ClientForceUpdateAmmoUsed(int NewAmmoUsed)
{
	AmmoUsedCount = NewAmmoUsed;
}

simulated function AutoSwitchToNewWeapon()
{
	GearInventoryManager(InvManager).AutoSwitchWeapon();
}

simulated function bool ShouldPreventWeaponSwitch()
{
	return FALSE;
}


/**
 * State Active
 * When a weapon is in the active state, it's up, ready but not doing anything. (idle)
 */
simulated state Active
{
	simulated function BeginState( Name PreviousStateName )
	{
		local int i;
		local bool bOutOfAmmo;
		local GearPawn GP;

		if( Role == ROLE_Authority )
		{
			// Cache a reference to the AI controller
			CacheAIController();
		}

		GP = GearPawn(Instigator);
		if (bIsScopeWeapon && GP != None)
		{
			if (ScopeClass != None && Scope == None && GP.IsLocallyControlled() && GP.IsHumanControlled())
			{
				Scope = Spawn(ScopeClass, Self);
				SetupScopeLighting();
			}

			// We've come in zoomed, probably directly off a reload, hide the meshes as we go FPS
			if (GP.bIsZoomed)
			{
				SetOwnerNoSee(TRUE);
			}
		}

		bOutOfAmmo = !HasAnyAmmo();
		`LogInv("PreviousStateName:" @ PreviousStateName @ "bOutOfAmmo:" @ bOutOfAmmo);

		if (bOutOfAmmo)
		{
			PlayNeedsAmmoChatter();
		}

		if( bWeaponPutDown )
		{
			// put weapon down first
			PutDownWeapon();
		}
		else if( (PendingFire(RELOAD_FIREMODE) || ShouldAutoReload()) && FiringStatesArray[RELOAD_FIREMODE] != '' )
		{
			// then check for weapon reloading
			BeginFire(RELOAD_FIREMODE);
		}
		else if( InvManager != None )
		{
			// if out of ammo, and can't have weapon selected w/o ammo,
			if( bOutOfAmmo &&
				 ( !bCanSelectWithoutAmmo ||
					(bAutoSwitchWhenOutOfAmmo && IsFireState(PreviousStateName) && (FiringStatesArray[MELEE_ATTACK_FIREMODE] != PreviousStateName) )
				 )
				)
			{
				AutoSwitchToNewWeapon();
			}
			else
			{
				// if either of the fire modes are pending, perform them
				for( i=0; i<GetPendingFireLength(); i++ )
				{
					if( PendingFire(i) )
					{
						BeginFire(i);
						// keep going if the BeginFire() didn't do anything
						// (e.g. holding down fire while clip is empty)
						if (GetStateName() != 'Active')
						{
							break;
						}
					}
				}
				//@see: ClientForceUpdateAmmoUsed()
				if (PreviousStateName == 'Reloading' && AmmoUsedCount > 0)
				{
					ClientForceUpdateAmmoUsed(AmmoUsedCount);
				}
			}
		}
	}

	simulated function EndState(Name NextStateName)
	{
		`LogInv("NextStateName:" @ NextStateName);
		super.EndState(NextStateName);
		ClearTimer( nameof(PlayNoAmmoFireSound) );

		if (bIsScopeWeapon && NextStateName != 'WeaponFiring')
		{
			SetOwnerNoSee(FALSE);
		}
	}

	/** Override BeginFire so that it will enter the firing state right away. */
	simulated function BeginFire(byte FireModeNum)
	{
		if( !bDeleteMe && Instigator != None )
		{
			Global.BeginFire(FireModeNum);

			// in the active state, fire right away if we have the ammunition
			if( PendingFire(FireModeNum) )
			{
				if( HasAmmo(FireModeNum) )
				{
					SendToFiringState(FireModeNum);
				}
				else if( FireModeNum == 0 )
				{
					if( !HasAnyAmmo() )
					{
						/** The weapon is out of ammo and this is the sound it makes when firing with no ammo **/
						//`log("no ammo fire sound!");
						PlayNoAmmoFireSound();
						if (NoAmmoFireSoundDelay > 0.f)
						{
							SetTimer( NoAmmoFireSoundDelay, TRUE, nameof(PlayNoAmmoFireSound) );
						}
					}
					else
					{
						// if failed to fire because out of ammo in current clip, then try to reload weapon instead.
						ForceReload();
					}
				}
			}
		}
	}

	simulated function EndFire(byte FireModeNum)
	{
		Global.EndFire(FireModeNum);
		ClearTimer( nameof(PlayNoAmmoFireSound) );
	}

	simulated function Activate()
	{
		// sanity check that we're attached properly; handles some issues when things are missing/out of order on clients
		if (GearPawn(Instigator) != None && GearPawn(Instigator).MyGearWeapon == self)
		{
			GearPawn(Instigator).AttachWeapon();
		}
	}

	/**
	 * Make sure zoom is left at the proper time
	 *
	 * @param P - the pawn changing targeting modes
	 */
	simulated function TargetingModeChanged(GearPawn P)
	{
		local GearPC PC;
		local GearPawn GP;

		Global.TargetingModeChanged(P);

		TimeSinceTargeting = WorldInfo.TimeSeconds;

		if (bIsScopeWeapon)
		{
			GP = GearPawn(Instigator);
			if (GP != None && GP.bIsZoomed)
			{
				// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
				// (which involves leaving targeting mode for a moment).
				PC = GearPC(GetWeaponController());
				if (PC != None && !PC.bIsTargeting)
				{
					SetZoomed(FALSE, TRUE);
				}
				else
				{
					SetOwnerNoSee(PC.bIsTargeting);
				}
			}
		}
	}
}

/** The weapon is out of ammo and this is the sound it makes when firing with no ammo **/
simulated function PlayNoAmmoFireSound()
{
	WeaponPlaySound(FireNoAmmoSound);
}

/**
 * Handle crosshair expansion, the super chain becomes hairy if Tick is overloaded inside WeaponFiring
 *
 * @param DeltaTime - the length of the last frame
 */
simulated event UpdateCrosshairExpansion(float DeltaTime)
{
	CrosshairExpansionFiringTime = FMax(CrosshairExpansionFiringTime - DeltaTime, 0.0);
}

simulated state WeaponFiring
{
	/**
	 * Handle crosshair expansion, the super chain becomes hairy if Tick is overloaded inside WeaponFiring
	 *
	 * @param DeltaTime - the length of the last frame
	 */
	simulated event UpdateCrosshairExpansion(float DeltaTime)
	{
		CrosshairExpansionFiringTime = FMin(CrosshairExpansionFiringTime + DeltaTime, CrosshairExpansionTime);
	}

	/**
	 * Make sure we re-enable rendering if leaving the state
	 *
	 * @param NextStateName - the next state
	 */
	simulated event EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );

		ClearTimer( nameof(NotifyWeaponRefireDelayExpired) );

		if (bIsScopeWeapon && NextStateName != 'Active')
		{
			SetOwnerNoSee(FALSE);
		}
	}

	/**
	 * Make sure zoom is left at the proper time
	 *
	 * @param P - the pawn changing targeting modes
	 */
	simulated function TargetingModeChanged(GearPawn P)
	{
		local GearPC PC;

		Global.TargetingModeChanged(P);

		TimeSinceTargeting = WorldInfo.TimeSeconds;

		if (bIsScopeWeapon && Instigator != None && GearPawn(Instigator).bIsZoomed)
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = GearPC(GetWeaponController());
			if (PC != None)
			{
				if (!PC.bIsTargeting && !IsReloading())
				{
					SetZoomed(FALSE,TRUE);
				}
				else
				{
					SetOwnerNoSee(PC.bIsTargeting);
				}
			}
		}
	}
}

/** When attaching to a turret, the state can get jumbled so that ClearFlashLocation fails. Force looping fire off here */
simulated function ForceEndFire()
{
	Super.ForceEndFire();

	WeaponStoppedFiring(CurrentFireMode);
}

/** forces the client to stop firing. Used to resynchronize when the client sends a fire command the server rejects as invalid */
reliable client final function ClientForceEndFire(byte FireModeNum)
{
	EndFire(FireModeNum);
}

reliable server function ServerStartFire(byte FireModeNum)
{
	local GearPawn GP;

	// validate that we're actually able to fire
	GP = GearPawn(Instigator);
	if ( (GP == None || !GP.IsDoingASpecialMove() || GP.SpecialMoves[GP.SpecialMove].bCanFireWeapon || FireModeNum == RELOAD_FIREMODE) &&
		(Instigator == None || !Instigator.bTearOff) )
	{
		Super.ServerStartFire(FireModeNum);
	}
	else
	{
		// special case for DBNO: we can't do the "real" firing logic due to issues with animations and such,
		// but allow any final hit notify from the client to be processed so that we can have both players firing
		// near-simultaneously result in both players going DBNO/killed
		if ((GP.SpecialMove == SM_DBNO || GP.SpecialMove == SM_Gunked) && LastShotTime < GP.TimeOfDBNO)
		{
			LastShotTime = GP.TimeOfDBNO;
			bGotClientHit = false;
		}
		// same for instant kills; we delay weapon throwing/destruction for this as well
		else if (GP.bTearOff && LastShotTime < GP.TimeOfDeath)
		{
			LastShotTime = GP.TimeOfDeath;
			bGotClientHit = false;
		}
		ClientForceEndFire(FireModeNum);
	}
}

/** Overridden to handle AI weapon firing */
simulated function StartFire( byte FireModeNum )
{
	local GearPawn GP;
	local GearPC GPC;

	GP = GearPawn(Instigator);
	if( GP != None )
	{
		// mark the last time the weapon was fired for AI use
		GP.LastWeaponStartFireTime = WorldInfo.TimeSeconds;

		GPC = GearPC(GP.Controller);
		if (GPC != None)
		{
			GPC.SetLastWeaponInfoTime(WorldInfo.TimeSeconds);
			if (GPC.MyGearHud != None)
			{
				GPC.MyGearHud.UpdateOutOfAmmoTime(FireModeNum);
			}
		}
	}

	// If AI cannot fire weapon right now, abort
	if(  AIController != None )
	{
		//debug
		`AILog_Ext( GetFuncName()@FireModeNum@AIController.CanFireWeapon( self, FireModeNum ), 'Weapon', GearAI(AIController) );

		if ((FireModeNum != MELEE_ATTACK_FIREMODE && !HasAnyAmmo()) || !AIController.CanFireWeapon(self, FireModeNum))
		{
			return;
		}

		// if we need to transition to a blind fire action, wait for that
		if (GearAIController != None && GearAIController.CheckBlindFire())
		{
			return;
		}

		// Init weapon firing variables for AI
		SetupWeaponFire( FireModeNum );
	}

	Super.StartFire( FireModeNum );
}

/**
 *	AIFunc - Function for AI to setup weapon firing variables
 */
function SetupWeaponFire( byte FireModeNum )
{
	// Setup the burst fire count if applicable
	RemainingBurstFireCount = (FireModeNum == 0) ? GetBurstFireCount()  : -1;
	RemainingBurstsToFire	= (FireModeNum == 0) ? GetBurstsToFire()	: -1;

	//debug
	`AILog_Ext( self@GetFuncName()@FireModeNum@RemainingBurstFireCount@RemainingBurstsToFire, 'Weapon', GearAI(AIController) );
}

/**
 *	AIFunc - Function to get the next burst fire count for AI
 */
function int GetBurstFireCount()
{
	local int AmmoRemaining, BurstCount;

	AmmoRemaining = (WeaponMagSize == 0) ? 65535 : int(WeaponMagSize - AmmoUsedCount);
	// Setup the burst fire count if applicable, clamped by how much ammo is left in the clip
	BurstCount = Min( AmmoRemaining, GetRangeValueByPct(AI_BurstFireCount,FRand()) );
	// If no burst is specified then default to the full clip
	if( BurstCount == 0 )
	{
		BurstCount = AmmoRemaining;
	}

	return BurstCount;
}

// Default to firing bursts until ammo is gone
function int GetBurstsToFire()
{
	if(GearAIController != none && GearAIController.DesiredBurstsToFire > 0)
	{
		return GearAIController.DesiredBurstsToFire;
	}
	return -1;
}

/** @return how close AI should get to an enemy before attempting melee
 * this doesn't affect the weapon's rules, just the AI behavior
 * so for correct behavior this should return a value equal or less than GetMeleeAttackRange()
 */
function float GetAIMeleeAttackRange()
{
	return MeleeAttackRange;
}

/** @see Weapon::ShouldRefire() */
simulated function bool ShouldRefire()
{
	local GearPawn GP;

	// If AI controlled...
	if( AIController != None )
	{
		// If AI doesn't want to refire - fail
		if( !AIController.CanFireWeapon( self, CurrentFireMode ) )
		{
			StopFire(CurrentFireMode);
			return FALSE;
		}
		// If AI is burst firing weapon and fired a full burst - fail
		if( RemainingBurstFireCount == 0 )
		{
			return FALSE;
		}
	}

	// If Pawn is not allowed to fire, then abort firing.
	GP = GearPawn(Instigator);
	if( GP != None )
	{
		if( !GP.CanFireWeapon() || GP.ShouldDelayFiring() )
		{
			return FALSE;
		}
	}

	// If melee attack is pending, then abort firing.
	if( PendingFire(MELEE_ATTACK_FIREMODE) )
	{
		return FALSE;
	}

	return Super.ShouldRefire();
}

/**
 *	Called from RefireCheckTimer when weapon should not refire
 *	Give weapon/AI a chance to do something other than return to the Active state
 */
simulated function HandleFinishedFiring()
{
	local float RefireDelay;

	// If AI controlled...
	if (AIController != None && HasAmmo(CurrentFireMode))
	{
		if (RemainingBurstFireCount < 1)
		{
			// Reset the burst fire count
			RemainingBurstFireCount = GetBurstFireCount();

			// If firing in bursts...
			if (RemainingBurstsToFire > 0)
			{
				// Reduce remaining bursts
				RemainingBurstsToFire--;
				if (RemainingBurstsToFire > 0)
				{
					// Clear refire check until we restart it again
					ClearTimer(nameof(RefireCheckTimer));
					ClearFlashCount();
					ClearFlashLocation();

					// Set the timer to check for the next burst
					RefireDelay = FMax(0.01, GetRangeValueByPct(AI_BurstFireDelay, FRand()));
					SetTimer(RefireDelay, false, nameof(NotifyWeaponRefireDelayExpired));
					return;
				}
				else
				{
					StopFire(CurrentFireMode);
					AIController.StopFiring();
				}
			}
		}
	}

	Super.HandleFinishedFiring();
}


simulated function FireAmmunition()
{
	local GearPC GPC;

	Super.FireAmmunition();
	GoalBarrelHeat += BarrelHeatPerShot;
	GoalBarrelHeat = FMin(GoalBarrelHeat, MaxBarrelHeat);

	// restart the firing timer with the potentially changed fire rate (i.e. if active reload ended)
	ClearTimer(nameof(RefireCheckTimer));
	TimeWeaponFiring(CurrentFireMode);

	LastShotTime = WorldInfo.TimeSeconds;
	bGotClientHit = false;

	// if we are the server and owned by a remote client, see if they sent us a valid CSHD result slightly early
	if (Role == ROLE_Authority && QueuedCSHDInfo.Time > 0.0 && Instigator != None && !Instigator.IsLocallyControlled())
	{
		if (WorldInfo.TimeSeconds - QueuedCSHDInfo.Time <= GetCSHDPingTolerance())
		{
			ServerNotifyHit(QueuedCSHDInfo.FiringMode, QueuedCSHDInfo.Impact, QueuedCSHDInfo.HitType, QueuedCSHDInfo.NumHits);
		}
		else
		{
			`Log(self @ "Rejected client side hit (received prior to firing and out of ping tolerance)");
		}
		QueuedCSHDInfo.Time = 0.0;
	}

	GPC = GearPC(Instigator.Controller);
	if (GPC != None && GPC.StatManager != None)
	{
		GPC.StatManager.ModifyStat(name(WeaponStatName $ "ShotsFired" $ class<GearGame>(WorldInfo.GRI.GameClass).default.StatGametypeSuffix),1,GEARSTATMODTYPE_Delta);
	}
}


/**
 *	Called from FireAmmunition (usually for a single shot)
 *	Updates AI burst logic
 */
function NotifyWeaponFired( byte FireMode )
{
	if( AIController != None )
	{
		// If firing in bursts...
		if( RemainingBurstFireCount > 0 )
		{
			// Reduce the number of shots in the current burst
			RemainingBurstFireCount--;
		}
	}

	Super.NotifyWeaponFired( FireMode );
}

/**
 *	Called when AI refire delay (used to handle bursts) expires
 */
function NotifyWeaponRefireDelayExpired()
{
	if( ShouldRefire() )
	{
		// Start firing again
		FireAmmunition();
		TimeWeaponFiring( CurrentFireMode );
	}
	else
	{
		HandleFinishedFiring();
	}
}

/** @return whether the this weapon can hit the given target */
function bool CanHit(vector ViewPt, vector TestLocation, rotator ViewRotation)
{
	return ( GearAIController != none
		&& GearAIController.CanSeeByPoints(ViewPt, TestLocation, ViewRotation)
		&& !GearAIController.IsBlockedByDeployedShield(ViewPt, TestLocation) );
}

/************************************************************************************
 * Weapon Reloading
 ***********************************************************************************/

/**
 * Called by Player to force current weapon to be reloaded
 * Network: LocalPlayer
 */
simulated function ForceReload()
{
	local Controller PawnController;

	// Make sure it's called for a locally controlled pawn.
	PawnController = GetWeaponController();
	if (Instigator.IsLocallyControlled(PawnController))
	{
		// if we can reload,
		if( CanReload() )
		{
			StartFire(RELOAD_FIREMODE);

			// Trigger the reload delegates in the GearPC
			FireReloadDelegates();
		}
	}
}

simulated function FireReloadDelegates()
{
	local GearPC MyGearPC;

	MyGearPC = GearPC(GetWeaponController());
	if ( MyGearPC != None )
	{
		MyGearPC.TriggerGearEventDelegates( eGED_Reload );
	}
}

function DropFrom(vector StartLocation, vector StartVelocity)
{
	local GearDroppedPickup DP;
	local bool bForceDestroy;
	local GearPawn MyGearPawn;
	local GearGame GG;
	local Pawn OldInstigator;
	local Controller OldController;
	local GearPRI PRI;
	local bool bPartOfCoopWeaponSet;

	if( !CanThrow() )
	{
		return;
	}

	// cache the Instigator, since the removal from the inventory manager will clear it
	OldInstigator = Instigator;
	OldController = GetWeaponController();

	// if the weapon has no ammo, just destroy it
	if (!HasAnyAmmo())
	{
		bForceDestroy = TRUE;
	}

	// If we're not allowed to drop the weapon, just destroy it.
	MyGearPawn = GearPawn(OldInstigator);
	GG = GearGame(WorldInfo.Game);
	if( MyGearPawn == None || !MyGearPawn.bAllowInventoryDrops || GG == None || !GG.CanDropWeapon(Self, OldInstigator.Location) )
	{
		bForceDestroy = TRUE;
	}

	// turn off infinite ammo for AI dropped weapons
	if( bInfiniteSpareAmmo && OldInstigator != None && GearAI(OldController) != None )
	{
		bInfiniteSpareAmmo = FALSE;
		SpareAmmoCount = SpareAmmoCount * RandRange(0.4f, 0.8f);
	}

	// check to see if an AI dropped then and then remove some of the ammo so we are
	// not always giving 100% ammo
	if (GearAI(OldController) != None && GearAI_TDM(OldController) == None)
	{
		SpareAmmoCount = GetDropFromAISpareAmmoCount();
	}

	if( !bForceDestroy && DroppedPickupMesh != None && SkeletalMeshComponent(DroppedPickupMesh).PhysicsAsset == None )
	{
		`log( GetFuncName() @ Self @ "has no physics asset! doing a non physics drop...");
		Super.DropFrom(StartLocation,StartVelocity);
		return;
	}

//	InitialMeshRot = Mesh.GetRotation();
//	InitialMeshLoc = Mesh.GetPosition();

	GotoState('Inactive');

	StopMuzzleFlashEffect();
	// somebody more knowledgeable about how this should work should figure out the actual problem :)
	ForceEndFire();
	// pseudo-hack: for whatever reason the host is not calling StopFireEffects via ForceEndFire(), so we add a redundant call
	StopFireEffects(CurrentFireMode);
	// Detach weapon components from instigator
	DetachWeapon();

	// remove it from our inventory
	if( OldInstigator != None && OldInstigator.InvManager != None )
	{
		OldInstigator.InvManager.RemoveFromInventory(self);
	}

	if (MyGearPawn.CoopWeaponSyncActor != None && (GearWeap_HeavyCoopMGAmmoBoxBase(Self) != None || GearWeap_HeavyCoopMGBase(Self) != None))
	{
		bPartOfCoopWeaponSet = TRUE;
	}

	// if cannot spawn a pickup, then destroy and quit
	if( bForceDestroy || DroppedPickupClass == None || DroppedPickupMesh == None )
	{
		if (bPartOfCoopWeaponSet)
		{
			MyGearPawn.CoopWeaponSyncActor.DestroyLinkedActors();
			MyGearPawn.CoopWeaponSyncActor.UnlinkAllAndDestroy();
		}

		Instigator = None;
		AIController = None;
		Destroy();
		return;
	}

	DP = GearDroppedPickup(Spawn(DroppedPickupClass,,, StartLocation));
	if (DP == None && OldInstigator != None)
	{
		// try fallback by dropping behind previous owner instead
		DP = GearDroppedPickup(Spawn(DroppedPickupClass,,, StartLocation - vector(OldInstigator.Rotation) * OldInstigator.GetCollisionRadius() * 2.0));
	}
	if( DP == None )
	{
		if (bPartOfCoopWeaponSet)
		{
			MyGearPawn.CoopWeaponSyncActor.DestroyLinkedActors();
			MyGearPawn.CoopWeaponSyncActor.UnlinkAllAndDestroy();
		}

		Instigator = None;
		AIController = None;
		Destroy();
		return;
	}

	if (bPartOfCoopWeaponSet)
	{
		MyGearPawn.CoopWeaponSyncActor.UpdateLink(OldInstigator, DP);
	}

	// the dropped pickup mesh is usually the same as the held mesh
	// so make sure to get rid of any mirroring
	if( DroppedPickupMesh != None )
	{
		DroppedPickupMesh.SetScale3D(default.DroppedPickupMesh.Scale3D);
	}

	DP.Inventory	= self;
	DP.InventoryClass = (DroppedWeaponClass != None) ? DroppedWeaponClass : Class;
	DP.Instigator = OldInstigator;
	DP.SetPickupMesh(DP.InventoryClass.default.DroppedPickupMesh);

	if (DP.Physics == PHYS_RigidBody)
	{
		DP.CollisionComponent.SetRBAngularVelocity(VRand() * RandRange(-WeaponDropAngularVelocity,WeaponDropAngularVelocity),TRUE);
		DP.CollisionComponent.SetRBLinearVelocity(StartVelocity);
	}

	if (OldInstigator != None)
	{
		DP.TeamIndexOfPreviousOwner = OldInstigator.GetTeamNum();
	}

	if (MyGearPawn != None)
	{
		// Set the team color on the dropped mesh
		DP.SetEmissiveColor(MyGearPawn.GetMPWeaponColorBasedOnClass());

		// Attempt to set the custom weapon skin if this mesh supports it
		PRI = GearPRI(MyGearPawn.PlayerReplicationInfo);
		if (PRI != None)
		{
			// Set the skin to the player's current setting
			if (MyGearPawn.GetWeaponSkinParametersForClass(Class,DP.WeaponSkin))
			{
				DP.UpdateWeaponSkin();
				// The pawn may no longer use this until it picks up one
				MyGearPawn.ClearWeaponSkinParametersForClass(Class);
			}
			else
			{
				DP.WeaponSkin.WeapClass = Class;
			}
		}
	}

	DP.CheckForWeaponFadeOut();

	// align pickup mesh with current real mesh pos, for continuity
	// @fixme, why isn't this working?
	//	DP.CollisionComponent.SetRBPosition(InitialMeshLoc);
	//	DP.CollisionComponent.SetRBRotation(InitialMeshRot);

	Instigator = None;
	AIController = None;
}

function int GetDropFromAISpareAmmoCount()
{
	// this is the actual number of bullets you get back
	return RandRange( SpareAmmoFromDrop.X,SpareAmmoFromDrop.Y );
}

/** Stop any timers that may have been started because the weapon use is being interrupted by something */
function AbortLatentActions();

/**
 * Returns true if weapon can potentially be reloaded
 *
 * @return	true if weapon can be reloaded
 */
simulated function bool CanReload()
{
	local GearPawn	P;
	local bool		bInstigatorCanReload;

	P = GearPawn(Instigator);

	// Cannot reload weapon when doing a special move
	// as this conflicts with the body stance animation
	bInstigatorCanReload = (P != None && P.CanReloadWeapon());

	return(	bWeaponCanBeReloaded	&&	// Weapon can be reloaded
			bInstigatorCanReload	&&	// Instigator can reload weapon
			AmmoUsedCount > 0		&&	// we fired at least a shot
			HasSpareAmmo()				// and we have more ammo to fill current magazine
			);
}


/**
 * returns true if the weapon's magazine is empty and needs to be reloaded
 *
 * @return	true if weapon needs to reload
 */
simulated function bool ShouldAutoReload()
{
	// If AI controlled...
	if( AIController != None )
	{
		// If can't reload - fail
		if( !CanReload() )
		{
			return FALSE;
		}
		// If AI doesn't want to reload - fail
		if( GearAIController != None && !GearAIController.ShouldAutoReload() )
		{
			return FALSE;
		}
		// If clip is full or no ammo to reload with - fail
		if( AmmoUsedCount == 0 || !HasAnyAmmo() )
		{
			return FALSE;
		}

		// If we have ammo in our clip
		if( WeaponMagSize - AmmoUsedCount > 0 )
		{
			if( GearAIController != None &&
				GearAIController.MyGearPawn != None &&
				GearAIController.MyGearPawn.CoverType != CT_None &&
				GearAIController.MyGearPawn.CoverAction == CA_Default)
			{
				// increase the chance the more ammo we've used
				return FRand() < (AmmoUsedCount/WeaponMagSize);
			}
			return FALSE;
		}

		return TRUE;
	}
	else
	{
		return CanReload() && WeaponMagSize > 0 && AmmoUsedCount >= WeaponMagSize;
	}
}


/** Is the weapon currently being reloaded? */
simulated function bool IsReloading()
{
	local GearPawn InstigatorGP;
	InstigatorGP = GearPawn(Instigator);
	return (InstigatorGP != None) && InstigatorGP.IsReloadingWeapon();
}

/**
 * Play weapon reloading effects.
 * Called when weapon enters reloading state.
 * Network: ALL
 */
simulated function PlayWeaponReloading()
{
	local GearPawn	GP;
	local Pawn		P;
	local float		ReloadTime;
	local Controller PawnController;

	GP = GearPawn(Instigator);
	P = (Instigator);

	//`log(GetFuncName()@self@GetStateName());
	if( P == None )
	{
		`log(WorldInfo.TimeSeconds @ GetFuncName() @ "Ouch no Pawn, so can't play animation!");
		EndOfReloadTimer();
		return;
	}

	// Tell pawn to play weapon reload animation
	if( GP != none )
	{
		ReloadTime = PlayPawnReloadingAnimation(GP);
	}

	if( ReloadTime > 0.f )
	{
		ReloadDuration = ReloadTime;
	}

	if( ReloadDuration > 0.f )
	{
		SetTimer( ReloadDuration - WeaponReloadBlendOutTime/2.f, FALSE, nameof(EndOfReloadTimer) );
	}
	else
	{
		`warn(WorldInfo.TimeSeconds @ Self @ GetStateName() $ "::" $ GetFuncName() @ "ReloadDuration is zero!! Triggering EndOfReload now!! Instigator:" @ Instigator @ "ReloadTime:" @ ReloadTime @ "ReloadDuration:" @ ReloadDuration);
		EndOfReloadTimer();
	}

	// Have weapon mesh play a synchronized reload animation as well
	if( WeaponReloadAnim != '' )
	{
		PlayWeaponAnimByDuration(WeaponReloadAnim, ReloadDuration);
	}

	// Play weapon reloading sound
	if( WeaponReloadSound != None && WorldInfo.NetMode != NM_DedicatedServer )
	{
		Instigator.PlaySound(WeaponReloadSound, true);
	}

	// only start the mini game on the client (active reload is client authoritative)
	PawnController = GetWeaponController();
	if( P.IsLocallyControlled(PawnController) )
	{
		`LogInfo( 'Gear_MiniGames', "Trying to start a StartAReloadMiniGame" );
		StartActiveReload();
	}

	// turn on after fire smoke effect
	if( PSC_ReloadBarrelSmoke != None && Instigator.IsHumanControlled(PawnController) && (WorldInfo.NetMode != NM_DedicatedServer) )
	{
		if( GP == None || `TimeSince(GP.LastWeaponEndFireTime) < 2.f )
		{
			ClearTimer( nameof(PSC_ReloadBarrelSmoke) );
			PSC_ReloadBarrelSmoke.SetHidden( FALSE );
			PSC_ReloadBarrelSmoke.ActivateSystem();
			SetTimer( 3.0f, FALSE, nameof(HidePSC_ReloadBarrelSmoke) );
		}
	}
}

simulated function float PlayPawnReloadingAnimation(GearPawn GP)
{
	local FLOAT         ReloadAnimTime;
	local INT	        i;
	local BodyStance	BS_Animation;

	// See if Pawn want to override animation with his own
	if( !GP.OverrideReloadAnimation(Self, BS_Animation) )
	{
		// Otherwise use default from weapon.
		BS_Animation = BS_PawnWeaponReload;
	}

	// Make sure Group starts from begining.
	GP.AnimTreeRootNode.ForceGroupRelativePosition('WeaponReload', 0.f);
	ReloadAnimTime = GP.BS_Play(BS_Animation, ReloadAnimRate, 0.25f, WeaponReloadBlendOutTime, FALSE, TRUE, 'WeaponReload');
	GP.BS_SetEarlyAnimEndNotify(BS_Animation, FALSE);

	// uh oh problem
	if( ReloadAnimTime == 0.f || !GP.BS_IsPlaying(BS_Animation) )
	{
		`DLog("Failed to play reload animation for" @ GP @ "ReloadAnimTime:" @ ReloadAnimTime @ "IsPlaying?" @ GP.BS_IsPlaying(BS_Animation) @ "AnimTree:" @ GP.Mesh.Animations @ "Template:" @ GP.Mesh.AnimTreeTemplate @ "FullBodyNode:" @ GP.FullBodyNode);
		for(i=0; i<BS_Animation.Stance.Length; i++)
		{
			if( BS_Animation.Stance[i].AnimName != '' )
			{
				`Log(" ["$i$"]" @ BS_Animation.Stance[i].Slot @ BS_Animation.Stance[i].AnimName @ GP.BodyStanceNodes[BS_Animation.Stance[i].Slot]);
			}
		}
	}

	return ReloadAnimTime;
}


/** needed to be visible at the GearWeapon scope.  Only ever used in state Reloading **/
simulated function EndOfReloadTimer()
{
	// End reload animations.
	EndReloadAnimations();
}

/** End Reload Animations */
simulated function EndReloadAnimations()
{
	local GearPawn	P;

	// Make sure below is set in case notifies couldn't be played
	// (doing a special move while reloading)
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// Show Ammo part on weapon mesh.
		SetWeaponAmmoBoneDisplay(TRUE);

		// Detach magazine mesh from instigator's hand
		SetPawnAmmoAttachment(FALSE);
	}

	// Stop weapon animations
	StopWeaponAnim(0.33f);

	P = GearPawn(Instigator);
	if( P == None )
	{
		return;
	}

	// Stop pawn reload animations
	P.BS_Stop(BS_PawnWeaponReload, WeaponReloadBlendOutTime);
	P.BS_Stop(BS_PawnWeaponReloadSuccess, WeaponReloadBlendOutTime);
	P.BS_Stop(BS_PawnWeaponReloadFail, WeaponReloadBlendOutTime);
}

/** Put down current weapon. */
simulated function PutDownWeapon()
{
	// When putting down weapon, abort reload if reload was still in progress
	if( IsTimerActive( nameof(EndOfReloadTimer) ) )
	{
		AbortWeaponReload();
	}

	Super.PutDownWeapon();
}


/**
 * Function called to abort weapon reload.
 * Can be called when starting a SpecialMove, in that case it is called on all clients.
 * Animation is stopped before special moves starts.
 * Reloading State also sends the weapon to the active state.
 */
simulated function AbortWeaponReload()
{
	if( (CurrentFireMode == FIREMODE_ACTIVERELOADSUPERSUCCESS) || (CurrentFireMode == FIREMODE_ACTIVERELOADSUCCESS) )
	{
		// we've successfully hit an AR and are in the process of finishing it up.
		// in this case, we will still award the ammo
		PerformReload();
	}

	// Clear reload timer.
	ClearTimer( nameof(EndOfReloadTimer) );

	// End reload animations
	EndReloadAnimations();
}

/**
 * Active Reload Success, speed up the reload animation
 *
 * @param bSuperReload - whether the
 */
simulated function PlayActiveReloadSuccess(bool bSuperReload)
{
	local GearPawn	GP;
	local Pawn      P;
	local float		SpeedUpPercent, NewTimerRate;

	GP = GearPawn(Instigator);
	P = (Instigator);
	// Need a Pawn doing a reload to proceed
	if (P == None || !IsTimerActive(nameof(EndOfReloadTimer)))
	{
		return;
	}

	if (bSuperReload)
	{
		SpeedUpPercent = SuperActiveReloadAnimationSpeedUp;
	}
	else
	{
		SpeedUpPercent = ActiveReloadAnimationSpeedUp;
	}

	if (GP != None)
	{
		// If we have a player reload success animation, play it
		if (BS_PawnWeaponReloadSuccess.Stance.Length > 0)
		{
			// Override normal reload animation with success one
			GP.BS_Override(BS_PawnWeaponReloadSuccess);
			NewTimerRate = GP.BS_GetTimeLeft(BS_PawnWeaponReloadSuccess);
		}
		// otherwise, scale up default reload animation
		else
		{
			// Scale player reload animation
			GP.BS_ScalePlayRate(BS_PawnWeaponReload, SpeedUpPercent);
			NewTimerRate = GP.BS_GetTimeLeft(BS_PawnWeaponReload);
		}
	}

	// Needed for prototyping when we don't have anims
	if (NewTimerRate <= 0.0f)
	{
		`warn(WorldInfo.TimeSeconds @ Self @ GetStateName() $ "::" $ GetFuncName() @ "Instigator:" @ Instigator @ "NewTimerRate:" @ NewTimerRate @ "!!! Setting fake animation time.");
		NewTimerRate = 1.3f;
	}

	// Adjust end of reload timer based on new animation
	SetTimer(NewTimerRate - WeaponReloadBlendOutTime/2.f, FALSE, nameof(EndOfReloadTimer));

	// Now, do the same for the weapon animation
	if (WeaponReloadAnimSuccess != '')
	{
		// Set animation on weapon.
		SetWeaponAnim(WeaponReloadAnimSuccess);
	}
	else
	{
		// Scale weapon reload animation
		ScaleWeaponAnimPlayRate(SpeedUpPercent);
	}
}


/** Active Reload failed, ouch... penalty follows. */
simulated function PlayActiveReloadFailed()
{
	local GearPawn	GP;

	GP = GearPawn(Instigator);
	// Need a Pawn doing a reload to proceed
	if( Instigator == None || !IsTimerActive( nameof(EndOfReloadTimer) ) )
	{
		return;
	}

	PlayPawnActiveReloadFailAnimation(GP);

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// Play the failed animation on the weapon
		if( WeaponReloadAnimFail != '' )
		{
			SetWeaponAnim(WeaponReloadAnimFail);
		}
	}
}

simulated function PlayPawnActiveReloadFailAnimation(GearPawn GP)
{
	local float NewTimerRate;

	// Play active reload failed animation
	if( BS_PawnWeaponReloadFail.Stance.Length > 0 && GP != None && GP.BS_IsPlaying(BS_PawnWeaponReload) )
	{
		GP.BS_Override(BS_PawnWeaponReloadFail);
		NewTimerRate = GP.BS_GetTimeLeft(BS_PawnWeaponReloadFail);

		// Needed for prototyping when we don't have anims
		if (NewTimerRate <= 0.0f)
		{
			`warn(WorldInfo.TimeSeconds @ Self @ GetStateName() $ "::" $ GetFuncName() @ "Instigator:" @ Instigator @ "NewTimerRate:" @ NewTimerRate @ "!!! Setting fake animation time.");
			NewTimerRate = 1.0f;
		}

		// Adjust end of reload timer based on new animation
		SetTimer( NewTimerRate - WeaponReloadBlendOutTime/2.f, FALSE, nameof(EndOfReloadTimer) );
	}
	else
	{
		`warn(WorldInfo.TimeSeconds @ Self @ GetStateName() $ "::" $ GetFuncName() @ "Instigator:" @ Instigator @ "BS_PawnWeaponReloadFail.Stance.Length:" @ BS_PawnWeaponReloadFail.Stance.Length @ "GP.BS_IsPlaying(BS_PawnWeaponReload):" @ GP.BS_IsPlaying(BS_PawnWeaponReload) @ "!!! Setting fake animation time.");
		// Needed for prototyping when we don't have anims
		SetTimer( 4.0f, FALSE, nameof(EndOfReloadTimer) );
	}
}

/** Performs actual ammo reloading */
simulated function PerformReload()
{
	local float	Amount;
	local GearPC PC;

	// reload weapon here
	if (bInfiniteSpareAmmo)
	{
		AmmoUsedCount = 0;
	}
	else if( WeaponMaxSpareAmmo > 0 && SpareAmmoCount > 0 )
	{
		Amount			= SpareAmmoCount - FMax(SpareAmmoCount - AmmoUsedCount, 0);
		AmmoUsedCount	= AmmoUsedCount - Amount;
		SpareAmmoCount	= SpareAmmoCount - Amount;
	}
	// right now some config values are not being read in correctly.
	// so if we ever get a MaxSpareAmmoSize of 0 we just reload it
	// this is what is occurring with grenades atm
	else if( WeaponMaxSpareAmmo == 0 )
	{
	//	`log( "something terrible has gone wrong with the config loading of MaxSpareAmmo " @ self );

		Amount			= SpareAmmoCount - FMax(SpareAmmoCount - AmmoUsedCount, 0);
		AmmoUsedCount	= AmmoUsedCount - Amount;
		SpareAmmoCount	= SpareAmmoCount - Amount;
	}

	// Trigger delegates reload finishing
	PC = GearPC(GetPawnController(Pawn(Owner)));
	if( PC != None )
	{
		PC.TriggerGearEventDelegates( eGED_ReloadFinished );
	}
}


/**
 * State Reloading
 * State the weapon is in when it is being reloaded (current magazine replaced with a new one, related animations and effects played).
 */
simulated state Reloading
{
	ignores ForceReload;

	simulated function BeginState(Name PreviousStateName)
	{
		local GearAI AI;
		local float SuperSweetSpotOffset, ARStartTime, SuperSweetSpotDuration, SweetSpotDuration;
		local bool bSweet, bJam;

		`LogInv("PreviousStateName:" @ PreviousStateName);

		ReloadStartTime = WorldInfo.TimeSeconds;

		bActiveReloadAttempted = FALSE;

		// animation is played when receiving the updated firing mode.
		SetCurrentFireMode(RELOAD_FIREMODE);

		// tell guds
		if (Role == ROLE_Authority && GetWeaponController().IsInCombat())
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Reloaded, Instigator);
		}

		AI = GearAI(GetWeaponController());
		if( AI != None && bCanActiveReload )
		{
			if (FRand() < AI.ActiveReloadAttemptPct)
			{
				bSweet = (FRand() < AI.ActiveReloadSweetPct);
				bJam   = (FRand() < AI.ActiveReloadJamPct);

				GetActiveReloadValues(ARStartTime, SuperSweetSpotOffset, SuperSweetSpotDuration, SweetSpotDuration);
				if (bSweet != bJam)
				{
					if (bSweet)
					{
						SetTimer(ARStartTime + SuperSweetSpotOffset, false, nameof(AISuperSweetReload));
					}
					else
					{
						LocalFailedActiveReload(true);
					}
				}
				else if (GearAI_TDM(AI) != None) // bots can also do the faster reload only AR
				{
					SetTimer(ARStartTime + SuperSweetSpotDuration + SweetSpotDuration, false, nameof(AISweetReload));
				}
			}
		}
		else if (Instigator != None && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
		{
			if (bAutoActiveReload)
			{
				GetActiveReloadValues(ARStartTime, SuperSweetSpotOffset, SuperSweetSpotDuration, SweetSpotDuration);
				SetTimer(ARStartTime + SuperSweetSpotOffset, false, nameof(AISuperSweetReload));
			}
			else if (bMustActiveReload)
			{
				SetTimer(GetTimerRate(nameof(EndOfReloadTimer)) - 0.5, false, nameof(ForceReloadFailure));
			}
		}
	}

	simulated function ForceReloadFailure()
	{
		if (CurrentFireMode == RELOAD_FIREMODE)
		{
			LocalFailedActiveReload(true);
		}
	}

	/** called on a timer when AI decides it should succeed AR */
	function AISweetReload()
	{
		AR_TimeActiveReloadAttempted = WorldInfo.TimeSeconds;
		LocalActiveReloadSuccess(false);
		bActiveReloadAttempted = true;
	}
	simulated function AISuperSweetReload() // simulated for use by bAutoActiveReload
	{
		AR_TimeActiveReloadAttempted = WorldInfo.TimeSeconds;
		LocalActiveReloadSuccess(true);
		bActiveReloadAttempted = true;
	}

	simulated function EndState(Name NextStateName)
	{
		`LogInfo('Gear_MiniGames', "Reloading EndState()");
		`LogInv("NextStateName:" @ NextStateName);

		// Was reload aborted??
		if( IsTimerActive( nameof(EndOfReloadTimer) ) )
		{
			// Call global version, so we're not forced to go to the Active state
			Global.AbortWeaponReload();
			ClearTimer( nameof(EndOfReloadTimer) );
		}
		ClearTimer(nameof(AISuperSweetReload));
		ClearTimer(nameof(AISweetReload));
		ClearTimer(nameof(ForceReloadFailure));

		EndFire( RELOAD_FIREMODE );

		// switch back to default firing mode.
		SetCurrentFireMode( 0 );

		if (Role == ROLE_Authority && !bActiveReloadAttempted)
		{
			//@STATS - Record Active Reload Skip
			`RecordWeaponIntStat(ACTIVE_RELOAD_SKIPPED,GetWeaponController(),Class,1);
		}
	}

	/** @see Weapon::TryPutDown() */
	simulated function bool TryPutDown()
	{
		// Put the weapon down right away, and abort weapon reloading
		PutDownWeapon();
		return TRUE;
	}

	/** Abort weapon reload... */
	simulated function AbortWeaponReload()
	{
		Global.AbortWeaponReload();

		// leave state and go back to active without reloading weapon
		GotoState('Active');
	}

	simulated function EndOfReloadTimer()
	{
		Global.EndOfReloadTimer();

		ClearTimer( nameof(EndOfReloadTimer) );

		// Reload weapon
		PerformReload();

		// we're done, leave state and go back to active
		GotoState('Active');
	}


	//// ActiveReload Functionality

	simulated function bool HandleButtonPress( coerce Name ButtonName )
	{
		// check to see if we have pressed the reload button
		if (!bActiveReloadAttempted && bCanActiveReload && !bAutoActiveReload && ButtonName == 'R1')
		{
			AR_TimeActiveReloadAttempted = WorldInfo.TimeSeconds;
			DetermineActiveReloadSuccessOrFailure();
			bActiveReloadAttempted = true;
			return true;
		}
		else
		{
			return false;
		}
	}

	simulated function BeginFire(byte FireModeNum)
	{
		Global.BeginFire(FireModeNum);

		// Melee aborts weapon reloads
		if( FireModeNum == MELEE_ATTACK_FIREMODE && PendingFire(MELEE_ATTACK_FIREMODE) )
		{
			if( IsTimerActive( nameof(EndOfReloadTimer) ) )
			{
				// Call global, because we don't want to go to the active state
				Global.AbortWeaponReload();
			}
			SendToFiringState(FireModeNum);
		}
	}

	simulated function bool IsFiring()
	{
		return FALSE;
	}
}


/**
 * This function will determine if the player has pressed the reload button fast enough to get
 * an AR success.  Or if they have failed.	This function then sends events back up to the Weapon
 * to tell it what has occurred.
 *
 **/
native function DetermineActiveReloadSuccessOrFailure();

native function GetActiveReloadValues(out float ActiveReloadStartTime, out float SuperSweetSpotOffset, out float SuperSweetSpotDuration, out float SweetSpotDuration);

/**
 * Resets the ActiveReload variables in the case of a failure
 * @Network: Local Player.
 */
simulated event LocalFailedActiveReload( bool bFailedActiveReload )
{
	local GearPC PC;

	if( Role < Role_Authority )
	{
		ServerFailedActiveReload( bFailedActiveReload );
	}

	FailedActiveReload( bFailedActiveReload );

	// play the failure sound and show failure message
	if (bFailedActiveReload == TRUE)
	{
		GearWeaponPlaySoundLocal(AR_FailSound,,, TRUE);
	}

	// Trigger delegates for active reload
	PC = GearPC(GetPawnController(Pawn(Owner)));
	if ( PC != None )
	{
		PC.TriggerGearEventDelegates( eGED_ActiveReloadFailed );
	}
}


/**
 * Event called when player failed to perform active reload.
 * @Network: Dedicated Server, or Listen Server.
 */
unreliable server function ServerFailedActiveReload( bool bFailedActiveReload )
{
	FailedActiveReload( bFailedActiveReload );
}


/**
 * Event called when player failed to perform active reload.
 * @param bFailedActiveReload - TRUE if the attempted the AR and failed.  FALSE if they did not attempt the AR
 * @Network: ALL
 */
simulated function FailedActiveReload(bool bFailedActiveReload)
{
	local GearPawn	GP;

	GP = GearPawn(Instigator);
	if ( (GP == None) && (Vehicle(Instigator) != None) )
	{
		GP = GearPawn(Vehicle(Instigator).Driver);
	}

	//debug
	`LogInfo( 'Gear_ActiveReload', "FailedActiveReload() bFailedActiveReload:" @ bFailedActiveReload );

	ActiveReload_NumBonusShots	= 0;
	if(GP != none)
	{
		GP.ActiveReload_CurrTier		= 0;
		GP.bActiveReloadBonusActive	= FALSE;
	}

	// if we actually failed not because time expired, play failed animation
	if( bFailedActiveReload == TRUE && ShouldPlayFailedActiveReload() )
	{
		SetCurrentFireMode(FIREMODE_FAILEDACTIVERELOAD);
	}

	// Notify Pawn
	if (GP != none)
	{
		GP.ActiveReloadFail(bFailedActiveReload);
	}

}

/** Have a chance to not play the active reload failed animation */
simulated function bool ShouldPlayFailedActiveReload()
{
	return TRUE;
}

/**
 * @Network: Local Player.
 */
simulated event LocalActiveReloadSuccess(bool bDidSuperSweetReload)
{
	local GearPC PC;
	//local SoundCue SoundToPlay;

	`LogInfo( 'Gear_ActiveReload', "LocalActiveReloadSuccess bDidSuperSweetReload:" @ bDidSuperSweetReload );

	if (bMustActiveReload && !bDidSuperSweetReload && Instigator != None && Instigator.IsHumanControlled())
	{
		LocalFailedActiveReload(true);
	}
	else
	{
		if( Role < Role_Authority )
		{
			ServerActiveReloadSuccess(bDidSuperSweetReload);
		}


		PC = GearPC(GetPawnController(Pawn(Owner)));
		if( PC != None )
		{
			if( bDidSuperSweetReload == TRUE )
			{
				PC.ClientPlayForceFeedbackWaveform( class'GearWaveForms'.default.ActiveReloadSuperSuccess );
			}
			else
			{
				PC.ClientPlayForceFeedbackWaveform( class'GearWaveForms'.default.ActiveReloadSuccess );
			}

			// Trigger delegates for active reload
			PC.TriggerGearEventDelegates( eGED_ActiveReloadSuccess );
		}

		ActiveReloadSuccess( bDidSuperSweetReload );
	}
}


/**
 * Event called when player succeeded to perform active reload.
 * @Network: Dedicated Server, or Listen Server.
 */
unreliable server function ServerActiveReloadSuccess(bool bDidSuperSweetReload)
{
	ActiveReloadSuccess(bDidSuperSweetReload);
}


/**
 * Event called when player succeeded to perform active reload.
 * @Network: ALL
 */
simulated function ActiveReloadSuccess(bool bDidSuperSweetReload)
{
	local GearPawn GP;
	`LogInfo( 'Gear_ActiveReload', "ActiveReloadSuccess bDidSuperSweetReload:" @ bDidSuperSweetReload );

	GP = GearPawn(Instigator);
	if ( (GP == None) && (Vehicle(Instigator) != None) )
	{
		GP = GearPawn(Vehicle(Instigator).Driver);
	}
	if (GP != none)
	{
		GP.ActiveReloadSuccess(bDidSuperSweetReload);
	}

	SetActiveReloadBonusActive(bDidSuperSweetReload);

	if( bDidSuperSweetReload )
	{
		SetCurrentFireMode(FIREMODE_ACTIVERELOADSUPERSUCCESS);
	}
	else
	{
		SetCurrentFireMode(FIREMODE_ACTIVERELOADSUCCESS);
	}
}


/**
 * This will start a reload mini game for the weapon reloading.
 * Additionally, this function will either be overridden or
 * will use the default properties for each weapon TYPE.
 */
simulated function StartActiveReload()
{
	local GearPC PC;

	AR_TimeReloadButtonWasPressed = WorldInfo.TimeSeconds;

	// tell the hud to reset the active reload data
	PC = GearPC(GetWeaponController());
	if ( (PC != None) && (PC.myHUD != None) )
	{
		GearHUD_Base(PC.myHUD).ResetActiveReload();
	}
}


/** Turn on the visual effects from an active reload **/
simulated function SetActiveReloadEffectsActive(bool bActive)
{
	if (bActiveReloadVisualEffectsActive != bActive)
	{
		bActiveReloadVisualEffectsActive = bActive;
		SetupMuzzleFlash();
	}
}

/** Internal.  Sets up proper muzzle flash based on AR state, etc. */
simulated protected function SetupMuzzleFlash()
{
	local GearPC GPC;
	local ParticleSystem PS;

	if (MuzzleFlash == None && MuzzleFlashArchetype != None)
	{
		// Instance the muzzle flash archetype
		MuzzleFlash = new(self) MuzzleFlashArchetype.Class(MuzzleFlashArchetype);
	}

	if (MuzzleFlash != None)
	{
		if( MuzzleFlash.MuzFlashEmitter != None )
		{
			GPC = GearPC(GetWeaponController());
			if ( (GPC != None) && GPC.IsLocalPlayerController() && GPC.IsViewingTarget(Instigator) )
			{
				// use special local-player-only muzzle flash
				// @fixme jf: how to deal with splitscreen?  play 2 muzzle flashes and use bOwnerOnly on the systems?
				PS = bActiveReloadVisualEffectsActive ? MuzzleFlash.MuzFlashParticleSystemActiveReload_Player : MuzzleFlash.MuzFlashParticleSystem_Player;
			}

			if (PS == None)
			{
				PS = bActiveReloadVisualEffectsActive ? MuzzleFlash.MuzFlashParticleSystemActiveReload : MuzzleFlash.MuzFlashParticleSystem;
			}

			if (PS != None)
			{
				MuzzleFlash.MuzFlashEmitter.SetTemplate(PS);
			}
			if (WorldInfo.GRI != None)
			{
				MuzzleFlash.MuzFlashEmitter.SetLODLevel(GearGRI(WorldInfo.GRI).GetLODLevelToUse(PS, GetMuzzleLoc()));
			}
		}

		if( MuzzleFlash.MuzzleFlashLight != None )
		{
			// scale based on which tier of active reload we are in
			if (bActiveReloadVisualEffectsActive)
			{
				MuzzleFlash.MuzzleFlashLight.Radius = MuzzleFlashArchetype.MuzzleFlashLight.Radius * 1.1f;       // 10% bigger
				MuzzleFlash.MuzzleFlashLight.SetLightProperties( MuzzleFlashArchetype.MuzzleFlashLight.Brightness * 1.1f, GetMuzzleFlashLightColor() );      // 10% brighter
			}
			else
			{
				// Reset light brightness and radius
				MuzzleFlash.MuzzleFlashLight.Radius = MuzzleFlashArchetype.MuzzleFlashLight.Radius;
				MuzzleFlash.MuzzleFlashLight.SetLightProperties( MuzzleFlashArchetype.MuzzleFlashLight.Brightness, GetMuzzleFlashLightColor() );
			}
		}
	}
}


/**
 * This will turn off the active reload bonus
 */
simulated function TurnOffActiveReloadBonus()
{
	`LogInfo( 'Gear_ActiveReload', "TurnOffActiveReloadBonus()" );
	if (GearPawn(Instigator) != None)
	{
		GearPawn(Instigator).bActiveReloadBonusActive = FALSE;
	}

	ClearTimer(nameof(TurnOffActiveReloadBonus));

	ActiveReload_NumBonusShots = 0;

	if (GearPawn(Owner) != None)
	{
		GearPawn(Owner).ActiveReload_CurrTier = 0;	// for now just turn off the AR tier if dam bonus ends
	}

	SetActiveReloadEffectsActive(false);

	PlaySound( SoundCue'MiniGames.Sounds.ActiveReload_DamageBonusEnd' );
}


/**
 * This will turn on the active reload bonus which will modify:
 *	-damage of hits
 *
 * Additionally, it will set a timer to turn off the active reload bonus.
 */
simulated function SetActiveReloadBonusActive(bool bSetSuperSweetSpotReward)
{
	local GearPawn GP;

	// check to make certain we have used most of the clip before giving
	// out the damage bonus
	if (IsApplicableForARDamageBonus())
	{
		GP = GearPawn(Instigator);

		// play the correct sound
		if (bSetSuperSweetSpotReward)
		{
			if (GP != None)
			{
				GP.bActiveReloadBonusActive = true;
				if( GP.ActiveReload_CurrTier < ACTIVE_RELOAD_TIERS-1 )
				{
					GP.ActiveReload_CurrTier++;
				}
			}

			// set the number of bonus bullets to the number of bullets reloaded
			ActiveReload_NumBonusShots = ActiveReload_NumBonusShots + SpareAmmoCount - FMax(SpareAmmoCount - AmmoUsedCount, 0);

			// set timer to disable AR bonus
			if (Role == ROLE_Authority)
			{
				SetTimer(AR_MagicBulletsTimeoutDuration, false, nameof(TurnOffActiveReloadBonus));
			}

			// turn off the muzzle flash in case it's still active
			// since active reload can replace the muzzle flash and cause
			// a strange particle pop
			if (MuzzleFlash != None && MuzzleFlash.MuzFlashEmitter != None)
			{
				HideMuzzleFlashEmitter();
			}

			// only turn on visuals for supersweet
			SetActiveReloadEffectsActive(true);
			GearWeaponPlaySoundLocal(AR_SuperSuccessSound,,, true);
		}
		else
		{

			ActiveReload_NumBonusShots = 0;
			if (GP != None)
			{
				GP.bActiveReloadBonusActive = false;
				GP.ActiveReload_CurrTier = 0;
			}

			GearWeaponPlaySoundLocal(AR_SuccessSound,,, true);
		}
	}
	// no damage bonus given
	else
	{
		`LogDebug('Gear_ActiveReload', "Not eligible");
	}
}


/**
 * This can be over ridden by specific weapons that have different behavior than the norm.
 */
simulated function bool IsApplicableForARDamageBonus()
{
	return (AmmoUsedCount > 0);
}


// Reload Ammo Effect

/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease();
/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease2();

/** notification fired from Pawn animation when player throws ammo */
simulated function Notify_AmmoThrow();

/** notification fired from Pawn animation when player grabs another magazine. */
simulated function Notify_AmmoGrab();

/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload();
/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload2();

/**
 * Show or Hide weapon ammo bone.
 * Done by using a bone scaling controller.
 */
simulated final function SetWeaponAmmoBoneDisplay(bool bShow, optional Name InControlName)
{
	local SkelControlBase		Control;
	local SkeletalMeshComponent	SkelMesh;

	SkelMesh = SkeletalMeshComponent(Mesh);
	if( SkelMesh != None )
	{
		if( InControlName == '' )
		{
			InControlName = 'AmmoControl';
		}

		Control = SkelMesh.FindSkelControl(InControlName);
		if( Control != None )
		{
			Control.SetSkelControlActive( !bShow );
		}
	}
}


/** Attach or Detach MagazineMesh on Pawn's left hand */
simulated final function SetPawnAmmoAttachment(bool bAttach, optional StaticMeshComponent InMagazineMesh, optional Name InBoneName, optional Rotator InRelativeRotation)
{
	local SkeletalMeshSocket	Socket;
	local Vector				NewScale3D;

	if( InMagazineMesh == None )
	{
		InMagazineMesh = MagazineMesh;
	}

	if( InMagazineMesh == None )
	{
		return;
	}

	if( bAttach )
	{
		// Set Shadow parent and light environment.
		InMagazineMesh.SetShadowParent(Instigator.Mesh);
		InMagazineMesh.SetLightEnvironment(GearPawn(Instigator).LightEnvironment);

		if( InBoneName != '' )
		{
			Instigator.Mesh.AttachComponent(InMagazineMesh, InBoneName,, InRelativeRotation);
		}
		else
		{
			Socket = Instigator.Mesh.GetSocketByName(GearPawn(Instigator).GetLeftHandSocketName());
			Instigator.Mesh.AttachComponent(InMagazineMesh, Socket.BoneName, Socket.RelativeLocation, Socket.RelativeRotation + InRelativeRotation, Socket.RelativeScale);
		}

		// Mirror weapon
		if( ShouldWeaponBeMirrored(GearPawn(Instigator)) )
		{
			NewScale3D = InMagazineMesh.default.Scale3D;
			NewScale3D.Y = -NewScale3D.Y;
			InMagazineMesh.SetScale3D( NewScale3D );
		}
		else
		{
			InMagazineMesh.SetScale3D(InMagazineMesh.default.Scale3D);
		}
	}
	else
	{
		// Set Shadow parent and light environment.
		InMagazineMesh.SetShadowParent(None);
		InMagazineMesh.SetLightEnvironment(None);

		// detach mesh from instigator
		if( Instigator.Mesh != None && Instigator.Mesh.IsComponentAttached(InMagazineMesh) )
		{
			Instigator.Mesh.DetachComponent(InMagazineMesh);
		}
	}
}


/** Spawn physics Magazine */
simulated function GearKActorSpawnableEffect SpawnPhysicsMagazine(Vector SpawnLoc, Rotator SpawnRot)
{
	local GearKActorSpawnableEffect	MagActor;
	local Vector			X, Y, Z;

	if (MagazineMesh == None || Instigator == None || !Instigator.EffectIsRelevant(Instigator.Location, false, 1000) )
	{
		return None;
	}

	MagActor = Spawn(class'GearKActorSpawnableEffect',,, SpawnLoc, SpawnRot);

	if( MagActor != None )
	{
		// Large invisible blocking volumes are used all over maps to deter glitching into geometry
		// and magazines will ends up spinning in air or magically reversing direction if they collide with them.
		MagActor.StaticMeshComponent.SetRBCollidesWithChannel(RBCC_BlockingVolume, false);

		MagActor.StaticMeshComponent.SetRBCollidesWithChannel(RBCC_Pawn, false);
		MagActor.StaticMeshComponent.SetScale(MagazineMesh.Scale);
		MagActor.StaticMeshComponent.SetStaticMesh(MagazineMesh.StaticMesh);
		MagActor.StaticMeshComponent.SetPhysMaterialOverride(PhysicalMaterial'WeaponPhysics.Physmats.WeaponPhysMat');
		MagActor.StaticMeshComponent.SetNotifyRigidBodyCollision(true);
		MagActor.SetPhysicalCollisionProperties();
		MagActor.StaticMeshComponent.WakeRigidBody();
		// Add a small impulse to have the clip slightly spinning
		GetAxes(Instigator.Rotation, X, Y, Z);
		MagActor.ApplyImpulse(Y + X*FRand(), 1.f + 2.f * FRand(), MagActor.Location);

		// turn off updating the DLE after a second
		MagActor.SetTimer( 1.0f, FALSE, nameof(MagActor.SetLightEnvironmentToNotBeDynamic) );
	}

	return MagActor;
}

/** Default Socket this weapon is attached to */
simulated event Name GetDefaultHandSocketName(GearPawn P)
{
	if( P != None )
	{
		return P.GetRightHandSocketName();
	}

	return '';
}

/**
 * Notification that Pawn just mirrored.
 * Swap weapon attachments...
 */
simulated function AdjustWeaponDueToMirror(GearPawn P)
{
	local Name	HandSocketName;

	HandSocketName = GetDefaultHandSocketName(P);
	if( SocketAttachedTo != HandSocketName && P.Mesh.IsComponentAttached(Mesh) )
	{
		// Detach weapon from current hand socket.
		DetachWeapon();

		// reattach weapon, now to inverted hand socket
		AttachWeaponTo(P.Mesh, HandSocketName);
		UpdateMagazineDueToMirror(P);
	}
}

simulated function UpdateMagazineDueToMirror(GearPawn P)
{
	// If player hapened to be in the middle of a weapon reload animation
	// handle case where clip was attached to left hand
	if( MagazineMesh != None && P.Mesh != None && P.Mesh.IsComponentAttached(MagazineMesh) )
	{
		SetPawnAmmoAttachment(FALSE);
		SetPawnAmmoAttachment(TRUE);
	}
}


/************************************************************************************
 * Melee Attacks
 * Code for weapon melee attacks
 ***********************************************************************************/

simulated function bool IsMeleeing()
{
	return FALSE;
}

/**
 * State MeleeAttacking
 * State the weapon is in when doing a melee attack
 */
simulated state MeleeAttacking
{
	simulated function bool IsMeleeing() { return TRUE; }

	simulated function BeginState(Name PreviousStateName)
	{
		//`LogInv("");

		// Change the weapon firing mode to MELEE_ATTACK_FIREMODE
		// This is used to synchronize clients to the new firing mode
		// MeleeAttackStarted() and MeleeAttackEnded() is called on clients based on the replication
		// of that firing mode.
		SetCurrentFireMode(MELEE_ATTACK_FIREMODE);

		// Melee attack is starting!
		MeleeAttackStarted();
	}

	simulated function EndState(Name NextStateName)
	{
		NotifyWeaponFinishedFiring( MELEE_ATTACK_FIREMODE );

		// Switch back to default firing mode.
		// This will call MeleeAttackEnded() on remote clients.
		SetCurrentFireMode(0);
		MeleeAttackEnded();
	}

	simulated function EndOfMeleeAttack()
	{
		// If player is still holding melee button
		if( PendingFire(MELEE_ATTACK_FIREMODE) )
		{
			// Clear flag to avoid going back to this state
			EndFire(MELEE_ATTACK_FIREMODE);
		}

		// we're done, leave state and go back to active
		GotoState('Active');
	}
}

/**
 * Some weapons can do SpecialMeleeAttacks which will end up killing the enemy in a glorious way
 * This function will check to see if that SpecialMeleeAttack is avail.	 (e.g. some might not be able
 * to be activated if you have been shot recently, or if you don't have the magic tokens)
 **/
simulated function bool CanDoSpecialMeleeAttack()
{
	return TRUE;
}


/**
 * Event called when melee attack begins.
 * This means when weapon is entering melee attacking state on local player and server.
 * When Pawn.FiringMode == MELEE_ATTACK_FIREMODE is replicated on remote clients.
 */
simulated function MeleeAttackStarted()
{
	// Weapons may have done their own ShouldMeleeKick check, reuse their results
	if (!bCheckedKickThisAttack && ShouldMeleeKick())
	{
		bKickThisAttack = TRUE;
	}

	if (bKickThisAttack)
	{
		ToggleInputOnKick(FALSE);

		// Have to hit b again if we kick. If we don't, bWantsToMelee can get stuck on from the cleaver swipe cancel into ticker kick.
		GearPawn(Instigator).StopMeleeAttack();
	}

	bCheckedKickThisAttack = FALSE;

	// Forward event to pawn owner
	GearPawn(Instigator).MeleeAttackStarted(Self);

	// Play melee attack animation.
	// This also sets the timer to call EndOfMeleeAttack.
	PlayMeleeAttack();

	// set the timer to check for hits
	if( bUseMeleeHitTimer )
	{
		// Clear complete time so it is intialized properly
		MeleeImpactCompleteTime = -1.f;
		SetTimer( MeleeInitialImpactDelay, FALSE, nameof(CheckMeleeAttackCollision) );
	}
}

/**
 *	Function handles checking for all types of melee impacts
 */
simulated function bool CheckMeleeAttackCollision()
{
	local bool bResult;

	// If this is the start first check of a melee attack
	if( MeleeImpactCompleteTime < 0.f )
	{
		// Update the window of time to repeat checks for impact
		MeleeImpactCompleteTime = WorldInfo.TimeSeconds + MeleeImpactRetryDuration;
	}
	// If window has expired - FAIL
	if( WorldInfo.TimeSeconds > MeleeImpactCompleteTime )
	{
		return FALSE;
	}

	// Check impacts for players first
	bResult = MeleeAttackImpact();
	// If no impact with player occurs
	if( !bResult && Role == ROLE_Authority && !bSlaveWeapon )
	{
		// Check for impact with world/destructibles
		bResult = MeleeAttackDestructibles();
	}

	// If no impact has occured
	if( !bResult )
	{
		// Set timer to retry impact
		SetTimer( 0.1, FALSE, nameof(CheckMeleeAttackCollision) );
	}

	return bResult;
}

/**
 * Check if we should kick instead of standard melee
 *
 * @return TRUE if we should be kicking
 */
simulated function bool ShouldMeleeKick()
{
	local GearPawn Victim, GPI;
	local float InstigatorZ, VictimZ;

	GPI = GearPawn(Instigator);
	if (GPI == None || !GPI.bCanMeleeKick || GPI.IsAKidnapper())
	{
		return FALSE;
	}

	if (MeleeAttackImpact( , Victim, , TRUE) && Victim != None)
	{
		InstigatorZ = Instigator.Location.Z + Instigator.GetCollisionHeight();
		VictimZ = Victim.Location.Z + Victim.GetCollisionHeight();
		//`log(`showvar(InstigatorZ - VictimZ));
		// If the victim is much lower than the player, kick them.
		if (InstigatorZ - VictimZ > MeleeKickZDiff || (Victim.IsDBNO() && (VictimZ - InstigatorZ < MeleeKickZDiff)))
		{
			return TRUE;
		}
	}

	return FALSE;
}

/**
 * Players shouldn't walk while kicking because it looks silly
 *
 * @param bEnableInput - whether to turn on or turn off input
 */
simulated function ToggleInputOnKick(bool bEnableInput)
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);
	if (PC != None)
	{
		PC.IgnoreMoveInput(!bEnableInput);
		// we might be in between the input reading and PlayerMove(), so we need to zero the inputs
		// to make sure a stray tick of motion doesn't get in
		if (PC.PlayerInput != None)
		{
			PC.PlayerInput.aForward = 0.f;
			PC.PlayerInput.aStrafe = 0.f;
			PC.PlayerInput.aUp = 0.f;
		}
	}
}

/**
 * Event called when melee attack ends.
 * This means when weapon leaves melee attacking state on local player and server.
 * When Pawn.FiringMode != MELEE_ATTACK_FIREMODE is replicated on remote clients, and previous firing mode was MELEE_ATTACK_FIREMODE.
 */
simulated function MeleeAttackEnded()
{
	if (GearPawn(Instigator) != None)
	{
		// Forward event to pawn owner
		GearPawn(Instigator).MeleeAttackEnded(Self);
	}

	if (bKickThisAttack)
	{
		ToggleInputOnKick(TRUE);
	}

	bHitWallThisAttack = FALSE;
	bKickThisAttack = FALSE;
	NumMeleeAttackAttempts = 0;

	ClearTimer( nameof(CheckMeleeAttackCollision) );
}

/**
 * Play Melee Attack
 * This function plays the melee attack animation
 * and sets a timer to call EndOfMeleeAttack(), which will trigger this end of the move
 * (and state transition).
 */
simulated function PlayMeleeAttack()
{
	local GearPC		GPC;
	local GearPawn	GP;
	local float		AnimDuration;

	GP = GearPawn(Instigator);
	if( GP == None )
	{
		return;
	}

	// Play melee attack animation.
	AnimDuration = PlayMeleeAttackAnimation(GP);
	TimeStartedSpecialMeleeAttack = WorldInfo.TimeSeconds;

	if( !bSuppressMeleeAttackCameraBoneAnim && MeleeAttackCameraBoneAnims.Length > 0 )
	{
		GPC = GearPC(GetWeaponController());
		if (GPC != None)
		{
			GPC.PlayRandomCameraBoneAnim(MeleeAttackCameraBoneAnims,, 0.1f, 0.1f,,, TRUE, TRUE, TRUE);
		}
	}

	// Set Timer to end melee attack state
	if( AnimDuration > 0.f )
	{
		SetTimer( AnimDuration, FALSE, nameof(EndOfMeleeAttack) );
	}
	else
	{
		`LogWarn('GearAnim',"PlayMeleeAttack" @ Self @ Instigator @ "AnimDuration is zero!!, ending melee attack now");
		EndOfMeleeAttack();
	}

	// play melee attack sound
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		GP.SoundGroup.PlayFoleySound(GP, GearFoley_MeleeAttackFX);
	}
}


/**
 * Play melee attack animation.
 * Returns the duration in seconds of the animation.
 */
simulated function float PlayMeleeAttackAnimation(GearPawn P)
{
	local float	AnimTime;
	local int	Idx;
	local BodyStance Stance;

	// Does Pawn want to override the melee animation with his own?
	if( P.OverridePlayMeleeAttackAnim(AnimTime) )
	{
		return AnimTime;
	}

	if (bKickThisAttack)
	{
		return P.BS_Play(BS_MeleeKick, 1.0f, 0.1f, 0.25f, FALSE, TRUE);
	}

	// pick random attack
	Idx = Rand(BS_MeleeAttack.Length);

//@todo -- This code is needlessly slow
	Stance = BS_MeleeAttack[Idx];
	return P.BS_Play(Stance, 1.f, 0.1f, 0.25f, FALSE, TRUE);
}


/**
 * Called by timer from PlayMeleeAttack()
 * Overloaded in state to end attack.
 */
simulated function EndOfMeleeAttack();


/** Notification called from Pawn animation, by GearAnimNotify_MeleeImpact. */
simulated function MeleeImpactNotify(GearAnimNotify_MeleeImpact Notify)
{
	local bool bResult;

	if (!bUseMeleeHitTimer && !bMeleeImpactNotifySemaphore)
	{
		// Check impacts for players first
		bResult = MeleeAttackImpact();
		// If no impact with player occurs
		if (!bResult && Role == ROLE_Authority && !bSlaveWeapon)
		{
			// Check for impact with world/destructibles
			bResult = MeleeAttackDestructibles();
		}
		bMeleeImpactNotifySemaphore = TRUE;
		SetTimer( MeleeAttackCoolDownInSeconds, FALSE, nameof(ClearMeleeImpactNotifySemaphore) );
	}
}

/** This resets the bMeleeImpactNotifySemaphore **/
simulated function ClearMeleeImpactNotifySemaphore()
{
	bMeleeImpactNotifySemaphore = FALSE;
}


/**
 * Returns the location that should be the start of traces for MeleeAttackImpact()
 */
simulated function vector GetMeleeStartTraceLocation()
{
	// we need to do it from the pawn's lower body so we can hit pawns that are "down but not out"
	return Instigator.Location - vect(0,0,32); // GetPhysicalFireStartLoc();
}

/**
 * Separate check for destructible objects, fixes issues with notifies/delays/etc.	Only
 * attack an object once per swing, etc.
 */
function bool MeleeAttackDestructibles()
{
	local Actor HitActor;
	local GearPawn GP;
	local vector StartTrace, EndTrace, HitLoc, HitNorm;
	local TraceHitInfo HitInfo;
	local bool bHitSomething;
	local GearPC PC;
	local Trigger_ChainsawInteraction Trigger;
	local class<DamageType> DT;

	GP = GearPawn(Instigator);
	StartTrace	= GetMeleeStartTraceLocation();
	EndTrace	= StartTrace + ( vector(GP.GetBaseAimRotation()) * MeleeAttackRange );
	bHitSomething = FALSE;

	// check for normal melee against chainsaw triggers that also accept melee
	foreach GP.TouchingActors(class'Trigger_ChainsawInteraction',Trigger)
	{
		// skip over triggers being used by other players
		if (Trigger.CurrentActivator != None && Trigger.CurrentActivator != Instigator)
		{
			continue;
		}
		if (Trigger.NumberOfMeleeHitsNeeded > 0 && Normal(Trigger.Location - GP.Location) dot vector(GP.Rotation) > 0.2f && (Trigger.TriggerEventClass(class'SeqEvt_ChainsawInteraction',GP,0,TRUE) || Trigger.bNoKismet))
		{
			bHitSomething = TRUE;
			if (Trigger.NumberOfMeleeHitsNeeded == Trigger.default.NumberOfMeleeHitsNeeded)
			{
				Trigger.bActivatedByMelee = TRUE;
				Trigger.TriggerEventClass(class'SeqEvt_ChainsawInteraction',GP,2,FALSE);
				Trigger.CurrentActivator = Instigator;
				Trigger.HitByMelee( GearPawn(Instigator) );
			}
			Trigger.NumberOfMeleeHitsNeeded--;
			if (Trigger.NumberOfMeleeHitsNeeded <= 0)
			{
				Trigger.TriggerEventClass(class'SeqEvt_ChainsawInteraction',GP,3,FALSE);
				Trigger.CurrentActivator = None;
				Trigger.TriggerEndChainsaw(GP);
			}
			WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'COG_Assaultrifle.Effects.P_COG_AssaultRifle_Impact_Melee', Trigger.Location, rotator(Instigator.Location - Trigger.Location));

			// Sound
			WeaponPlaySound(MeleeImpactSound); // hit wall
			break;
		}
	}

	if (!bHitSomething)
	{
		if (GP.IsCarryingShield())
		{
			DT = ShieldBashDamageType;
		}
		else if (bKickThisAttack)
		{
			DT = MeleeKickDamageType;
		}
		else
		{
			DT = InstantHitDamageTypes[MELEE_ATTACK_FIREMODE];
		}
		// attempt to hit an object in the world (e.g. destructible object)
		foreach GP.TraceActors(class'Actor', HitActor, HitLoc, HitNorm, EndTrace, StartTrace, MeleeTraceExtent, HitInfo)
		{
			if ( GearDestructibleObject(HitActor) != None || GlassActorBase(HitActor) != None ||
				(Turret(HitActor) != None && HitActor.bCanBeDamaged) ||
				(GearMeleeTarget(HitActor) != None && GearMeleeTarget(HitActor).IsValidMeleeTarget(Instigator)) )
			{
				HitActor.TakeDamage(MeleeAttackDamageMin, GP.Controller, HitLoc, HitNorm * -1.f, DT, HitInfo);
				bHitSomething = TRUE;
			}
		}

		// If we didn't hit something low down, try up a bit higher (need this for grapples)
		if(!bHitSomething)
		{
			foreach GP.TraceActors(class'Actor', HitActor, HitLoc, HitNorm, EndTrace + vect(0,0,64), StartTrace + vect(0,0,64), MeleeTraceExtent, HitInfo)
			{
				if ( GearDestructibleObject(HitActor) != None || GlassActorBase(HitActor) != None ||
					(Turret(HitActor) != None && HitActor.bCanBeDamaged) ||
					(GearMeleeTarget(HitActor) != None && GearMeleeTarget(HitActor).IsValidMeleeTarget(Instigator)) )
				{
					HitActor.TakeDamage(MeleeAttackDamageMin, GP.Controller, HitLoc, HitNorm * -1.f, DT, HitInfo);
					bHitSomething = TRUE;
				}
			}
		}
	}

	if( bHitSomething )
	{
		PC = GearPC(GetWeaponController());
		if( PC != None )
		{
			PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
		}
		PlayMeleeScreenShake(None);
		return TRUE;
	}

	return FALSE;
}

/** Trace, but ignore volumes and triggers unless they are blockers (i.e. BlockingVolume) */
simulated function Actor TraceNoVolumesOrTriggers(Pawn TraceOwner, vector End, vector Start, vector Extent, out vector HitLocation)
{
	local Actor HitActor;
	local vector HitLoc, HitNorm;

	// Iterate over each actor along trace...
	foreach TraceOwner.TraceActors(class'Actor', HitActor, HitLoc, HitNorm, End, Start, Extent)
	{
		// .. if it's not a trigger or a volume, use it!
		if ( (HitActor.bBlockActors || HitActor.bWorldGeometry || (Volume(HitActor) == None && Trigger(HitActor) == None && AIAvoidanceCylinder(HitActor) == None && GameCrowdInteractionPoint(HitActor) == None && GearWeaponPickupFactory(HitActor) == None && GearDroppedPickup(HitActor) == None)) &&
			(HitActor.bBlockActors || HitActor.bProjTarget || GearFortification(HitActor) == None) &&
			(GearFortification(HitActor) == None || GearFortification(HitActor).IsValidMeleeTarget(TraceOwner)) &&
			(GearPawn(HitActor) == None || !GearPawn(HitActor).IsAHostage()) )
		{
			HitLocation = HitLoc;
			return HitActor;
		}
	}

	// Found nothing non-volume or -trigger like :(
	return None;
}

/** Server side function to actually give the melee damage
 *	@param Victim - The pawn who will receive the damage
 *	@param InDamage - optional override for the damage value
 */
function ApplyMeleeDamage( GearPawn Victim, optional int InDamage)
{
	local GearPC PC;
	local float Damage;
	local GearPawn GP;

	GP = GearPawn(Instigator);

	if (Victim != None && GP != None)
	{
		// If no damage override, use defaults
		if( InDamage == 0 )
		{
			if( !GP.GetMeleeDamageOverride(Damage) )
			{
				Damage = RandRange(MeleeAttackDamageMin, MeleeAttackDamageMax);
			}
		}
		// otherwise, use damage override
		else
		{
			Damage = InDamage;
		}

		if( Damage > 0 )
		{
			// Force kill DBNO players.
			if( Victim.IsDBNO() )
			{
				Damage = Victim.DefaultHealth - Victim.DBNODeathThreshold + 1;
				//							`log("DBNO ForceKill Damage:" @ Damage);
			}
			// Give Damage
			GiveMeleeDamageTo(Victim, Damage);

			// and make them stumble
			if( !Victim.bPlayedDeath && !Victim.InGodMode() )
			{
				Victim.DoStumbleFromMeleeSpecialMove(GP);
			}
		}

		// do melee hit effects...
		PC = GearPC(GetPawnController(Victim));
		if( PC != None )
		{
			PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
		}
	}
}

/**
 * Melee Damage
 * @param	InDamage	Damage given to override the default RandRange(MeleeAttackDamageMin, MeleeAttackDamageMax)
 */
simulated function bool MeleeAttackImpact( optional int InDamage, optional out GearPawn OutVictimPawn, optional out TraceHitInfo OutHitInfo, optional bool bTest, optional float RangeMultiplier=1.0 )
{
	local GearPawn		GP, TestGP;
	local vector		CheckDir, DirToVictim, CheckDir2D, DirToVictim2D, HitLoc, EndTrace, StartTrace, TestGPLoc;
	local Actor			HitActor;
	local GearPC		 PC;
	local TraceHitInfo	HitInfo;
	local GearPawn		CurrWinner;
	local float			CurrClosestDistance;
	local float			DistanceToCheckAgainst;
	local ImpactInfo	TestImpact;
	local float			AttackRange;
	local GearAI		AI;
	local FracturedStaticMeshActor FracActor;
`if(`notdefined(FINAL_RELEASE))
	local bool			bShowDebugging;
`endif

	GP = GearPawn(Instigator);

`if(`notdefined(FINAL_RELEASE))
	bShowDebugging = GP != None && GP.bWeaponDebug_Accuracy && Instigator.IsLocallyControlled();
`endif

	// Make sure Pawn is allowed to melee. Pawn could have enterred a state preventing that like going DBNO.
	if (GP != None && !GP.CanEngageMelee() && !bTest)
	{
		return FALSE;
	}

//	`log(WorldInfo.TimeSeconds @ Self @ GetFuncName());

	// Limit to 4 checks
	if( NumMeleeAttackAttempts >= 4 )
	{
//		`log("rejected NumMeleeAttackAttempts");
		return FALSE;
	}


	CheckDir = vector(GP.GetBaseAimRotation());
	CurrClosestDistance = 99999999;

	// First do a check to see if we hit any Pawns, not on slave weapons
	if (!bSlaveWeapon || bTest)
	{
		AttackRange = MeleeAttackRange;
		AttackRange = AttackRange*RangeMultiplier;
		AI = GearAI(GetWeaponController());
		if( AI != None )
		{
			AttackRange = AI.EnemyDistance_Melee;
		}

		// Debugging
		`if(`notdefined(FINAL_RELEASE))
		if( bShowDebugging )
		{
			if( NumMeleeAttackAttempts == 0 )
			{
				FlushPersistentDebugLines();
			}
			DrawDebugCone(GP.Location, CheckDir, AttackRange, Acos(MeleeAcquireDotFOV.X), Acos(MeleeAcquireDotFOV.Y), 16, MakeColor(255,0,0,255), TRUE);
		}
		`endif

		foreach WorldInfo.AllPawns(class'GearPawn', TestGP)
		{
			// First make sure Pawn is relevant (ie not dead)
			if( TestGP != GP && !TestGP.bDeleteMe && !TestGP.bTearOff )
			{
				//`log(" Considering:" @ TestGP);
				TestGPLoc = TestGP.GetMeleeHitTestLocation();
				DistanceToCheckAgainst = VSize(TestGPLoc - GP.Location);

				// Then make sure Pawn is within melee range
				if( DistanceToCheckAgainst > AttackRange || DistanceToCheckAgainst > CurrClosestDistance ||
					Abs(TestGPLoc.Z - GP.Location.Z) > GP.CylinderComponent.CollisionHeight * 1.5 )
				{
					//`log("rejected within melee range");
					continue;
				}

				// Then Peform other relevancy checks
				if( !GP.TargetIsValidMeleeTarget(TestGP, TRUE, RangeMultiplier) )
				{
					//`log("rejected TargetIsValidMeleeTarget");
					continue;
				}

				// skip held meatshields
				if ( TestGP.IsAHostage() && Instigator == TestGP.InteractionPawn )
				{
					continue;
				}

				// Check that pawn is within FOV
				DirToVictim = Normal(TestGPLoc - GP.Location);

				// If our check FOV is a cone, then perform a simple dot product
				if( MeleeAcquireDotFOV.X == MeleeAcquireDotFOV.Y )
				{
					// Make sure victim is in FOV
					if( DirToVictim dot CheckDir < MeleeAcquireDotFOV.X )
					{
						//`log("rejected:"@TestGP@"dot:"@DirToVictim dot CheckDir);
						continue;
					}
				}
				// Not a cone, so do separate FOV checks for horizontal and vertical planes
				else
				{
					// First check for horizontal plane -- argh, why can't we use Vect(CheckDir.X, CheckDir.Y, 0.f) ????
					CheckDir2D.X	= CheckDir.X;
					CheckDir2D.Y	= CheckDir.Y;
					CheckDir2D.Z	= 0.f;
					CheckDir2D		= Normal(CheckDir2D);

					DirToVictim2D.X	= DirToVictim.X;
					DirToVictim2D.Y	= DirToVictim.Y;
					DirToVictim2D.Z	= 0.f;
					DirToVictim2D	= Normal(DirToVictim2D);

					// Debugging
					`if(`notdefined(FINAL_RELEASE))
					if( bShowDebugging )
					{
						DrawDebugLine(GP.Location, GP.Location + CheckDir2D * AttackRange, 0, 255, 0, TRUE);
						DrawDebugLine(GP.Location, GP.Location + DirToVictim2D * AttackRange, 0, 255, 0, TRUE);
					}
					`endif

					// Make sure victim is in horizontal FOV
					if( DirToVictim2D dot CheckDir2D < MeleeAcquireDotFOV.X )
					{
						//`log("rejected:"@TestGP@"horiz dot:"@DirToVictim2D dot CheckDir2D);
						continue;
					}

					// Then, check for vertical plane
					DirToVictim2D.X	= DirToVictim dot CheckDir2D;
					DirToVictim2D.Y	= 0.f;
					DirToVictim2D.Z	= DirToVictim.Z;
					DirToVictim2D	= Normal(DirToVictim2D);

					CheckDir2D		= Vect(1.f, 0.f, 0.f);

					// Debugging
					`if(`notdefined(FINAL_RELEASE))
					if( bShowDebugging )
					{
						DrawDebugLine(GP.Location, GP.Location + CheckDir2D * AttackRange, 0, 0, 255, TRUE);
						DrawDebugLine(GP.Location, GP.Location + DirToVictim2D * AttackRange, 0, 0, 255, TRUE);
					}
					`endif

					// Make sure victim is in vertical FOV
					if( DirToVictim2D dot CheckDir2D < MeleeAcquireDotFOV.Y )
					{
						//`log("rejected:"@TestGP@"vert dot:"@DirToVictim2D dot CheckDir2D);
						continue;
					}
				}

				// Force Start/EndTrace to be inside the pawns cylinders...
				// Fixes melee animations would cause the neck bone to go through thin geometry to the other side
				// and allow meleeing through walls
				StartTrace	 = GP.Location;
				StartTrace.Z = GP.GetPawnViewLocation().Z;
				EndTrace	 = TestGPLoc;
				EndTrace.Z	 = TestGP.GetPawnViewLocation().Z;

				// Finally trace to make sure there are no obstructions. ie acquiring someone through a wall
				//@note - can't use fasttrace since that'll collide against trigger volumes
				// @note2 - won't this hit triggers too?
				//  @note3 - jag: changed to avoid triggers etc
				//HitActor = Instigator.Trace(HitLoc,HitNorm,EndTrace,StartTrace,TRUE,vect(8,8,32));
				HitActor = TraceNoVolumesOrTriggers(Instigator, EndTrace, StartTrace, vect(8,8,32), HitLoc);

				if ( HitActor != None && HitActor != TestGP &&
					(HitActor != TestGP.DrivenVehicle || (CheckDir dot DirToVictim) < (CheckDir dot Normal(HitActor.Location - GP.Location))) )
				{
					//`log("rejected Trace"@HitActor);
					continue;
				}

				// We found someone!
				CurrWinner			= TestGP;
				CurrClosestDistance = DistanceToCheckAgainst;
			}
		}
	}

	TestGP = CurrWinner;
	if( TestGP != None )
	{
		if (!bTest && WorldInfo.NetMode != NM_Client)
		{
			ApplyMeleeDamage( TestGP, InDamage);
		}

		OutHitInfo		= HitInfo;
		OutVictimPawn	= TestGP;
		//`log("-"@self@WorldInfo.TimeSeconds@"hit"@TestGP@HitInfo.HitComponent@HitInfo.BoneName);

		// replicated effects
		if (!bTest && Role == ROLE_Authority)
		{
			// randomly choose between flesh and armor damage sounds
			if (MeleeShieldImpactSound != None && TestGP.IsDeployingShield() && TestGP.IsProtectedByShield(Normal(TestGP.Location - GP.Location),TRUE))
			{
				WeaponPlaySound(MeleeShieldImpactSound);
			}
			else if (0.5 > FRand())
			{
				TestGP.SoundGroup.PlayFoleySound(TestGP, GearFoley_MeleeAttackHitFleshFX, true);
			}
			else
			{
				TestGP.SoundGroup.PlayFoleySound(TestGP, GearFoley_MeleeAttackHitArmorFX, true);
			}
		}

		return TRUE; // we hit someone!
	}
	// If we haven't hit anybody see if we hit a wall
	else
	{
		//`log( "HitActor: " $ HitActor  );
		if( !bHitWallThisAttack )
		{
			// only do smoke if you are close to the wall
			StartTrace	= GetMeleeStartTraceLocation();
			EndTrace	= StartTrace + CheckDir * 96.f;

			TestImpact	= CalcWeaponFire(StartTrace, EndTrace);

			// Debugging
			`if(`notdefined(FINAL_RELEASE))
			if( bShowDebugging )
			{
				DrawDebugLine(StartTrace, EndTrace, 255, 0, 255, TRUE);
				`log(WorldInfo.TimeSeconds @ GetFuncName() @ "HitWallCheck, HitActor:" @ TestImpact.HitActor);
			}
			`endif

			// if we hit world geometry
			if( TestImpact.HitActor != None && (TestImpact.HitActor == WorldInfo || TestImpact.HitActor.bBlockActors) )
			{
				if (!bTest)
				{
					bHitWallThisAttack = true;

					// Particle
					HitLoc		= TestImpact.HitLocation;
					HitLoc.Z	= HitLoc.Z + 40; // Move it up slightly to match visual

					if (WorldInfo.NetMode != NM_DedicatedServer)
					{
						if (MeleeWallImpactEffect != None)
						{
							WorldInfo.MyEmitterPool.SpawnEmitter(MeleeWallImpactEffect, HitLoc, rotator(TestImpact.HitNormal));
						}

						// Sound
						if (MeleeShieldImpactSound != None && GearDroppedPickup_Shield(TestImpact.HitActor) != None)
						{
							WeaponPlaySound(MeleeShieldImpactSound); // hit shield
						}
						else if (MeleeShieldImpactSound != None && GearPawn(TestImpact.HitActor) != None && 
							GearPawn(TestImpact.HitActor).IsDeployingShield() && GearPawn(TestImpact.HitActor).IsProtectedByShield(Normal(TestImpact.HitActor.Location - GP.Location),TRUE))
						{
							WeaponPlaySound(MeleeShieldImpactSound); // hit shield
						}
						else
						{
							WeaponPlaySound(MeleeImpactSound); // hit wall
						}
						PlayMeleeScreenShake(None);

						PC = GearPC(GetWeaponController());
						if( PC != None )
						{
							PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
						}
					}

					// Fracture meshes if we hit them
					if(bAllowMeleeToFracture)
					{
						FracActor = FracturedStaticMeshActor(TestImpact.HitActor);
						if(FracActor != None)
						{
							FracActor.BreakOffPartsInRadius(HitLoc - (TestImpact.HitNormal * 15.0), 35.0, 100.0, TRUE);
							//DrawDebugSphere(HitLoc - (TestImpact.HitNormal * 15.0), 35.0, 16.0, 255,0,0, TRUE);
						}
					}
				}
			}
		}
	}

	if( !bTest )
	{
		NumMeleeAttackAttempts++;
		OutVictimPawn = None;
	}

	return FALSE;
}


/** Utility function to give melee damage */
function GiveMeleeDamageTo(GearPawn Victim, float Damage)
{
	local Vector			EndTrace, MomentumScale;
	local ImpactInfo		Impact;
	local class<DamageType>  DT;
	local Gearpawn			Gp;
	local GearPC            GPCShakeTarget;
	local bool bIsSpecialMeleeAttack;

	if (Damage < 1.f || bSlaveWeapon)
	{
		return;
	}

	GP = GearPawn(Owner);

	if (GP != None)
	{
		bIsSpecialMeleeAttack = GP.IsDoingSpecialMeleeAttack();
	}

	if ( Victim != None )
	{
		// wtf is this?	 should be rolled into PlayMeleeScreenShake functionality.
		if (!bIsSpecialMeleeAttack)
		{
			// Shake controller of Victim
			GPCShakeTarget = GearPC(GetPawnController(Victim));
			if (GPCShakeTarget != None)
			{
				GPCShakeTarget.ClientPlayForcefeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
			}

			// Shake controller of Hitter
			if (GP != None)
			{
				GPCShakeTarget = GearPC(GetPawnController(GP));
				if (GPCShakeTarget != None)
				{
					GPCShakeTarget.ClientPlayForcefeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
				}
			}
		}

		// Trace to neck for maximum blood in your face
		EndTrace = Victim.Mesh.GetBoneLocation(Victim.MeleeDamageBoneName);

		// Do a trace to get HitInfo
		Instigator.TraceComponent(Impact.HitLocation, Impact.HitNormal, Victim.Mesh, EndTrace, Instigator.Location, Vect(0,0,0), Impact.HitInfo);

		MomentumScale		= Impact.HitNormal * -1.f;
		Impact.HitActor		= Victim;
		Impact.RayDir		= Normal(Impact.HitLocation - Instigator.Location);


		if (GP.IsCarryingShield())
		{
			DT = ShieldBashDamageType;
		}
		else if (bKickThisAttack)
		{
			DT = MeleeKickDamageType;
		}
		else
		{
			DT = InstantHitDamageTypes[MELEE_ATTACK_FIREMODE];
		}
		Victim.TakeDamage(Damage, GetWeaponController(), Impact.HitLocation, MomentumScale, DT , Impact.HitInfo);

		//@FIXME: this block doesn't work for clients!
		//{

			// Play Physics Body Impact.
			Victim.PlayPhysicsBodyImpact(Impact.HitLocation, MomentumScale, DT, Impact.HitInfo);

			// Back up HitLocation a bit to spawn impact effects
			Impact.HitLocation = Impact.HitLocation + Impact.HitNormal * 3.f;

			SpawnImpactEffects(Instigator, self, class'GDT_Melee',Impact,class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterial(Impact),FALSE,TRUE,FALSE,bSuppressImpactFX);

		//}

		if (!bIsSpecialMeleeAttack)
		{
			PlayMeleeScreenShake( Victim );
		}
	}
	else
	{
		`log(WorldInfo.TimeSeconds @ GetFuncName() @ "SpecialMeleeAttackVictim == None");
	}
}


/************************************************************************************
 * Inventory / Slots / Attachments
 ***********************************************************************************/

reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	local GearPawn	GP;

	`LogInv(Self @ "bOptionalSet:" @ bOptionalSet @ "CharacterSlot:" @ CharacterSlot);

	GP = GearPawn(Instigator);

	// Make sure we have the replicated CharacterSlot before attaching the weapon.
	if( Instigator != None && GP != None && CharacterSlot == EASlot_None && WeaponType != WT_Heavy )
	{
		`LogInv("CharacterSlot == EASlot_None, going to PendingClientWeaponSet");
		GotoState('PendingClientWeaponSet');
		return;
	}

	Super.ClientWeaponSet(bOptionalSet, bDoNotActivate);

	if (GP != None && InvManager != none)
	{
		// Set attachment on local client player
		// When the weapon is initially replicated to the local player, it may not become the active weapon.
		// GearPawn::PlayWeaponSwitch() takes care of updating the slot attachments on the local player.
		// That function will only be called if the weapon becomes the active one.
		// So we force update the attachments here, so they are set for the local player.
		if( GP.Weapon != Self )
		{
			GP.AttachWeaponToSlot(Self);
		}
	}
}


/** @see Inventory::GivenTo */
function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
	local GearPawn.EAttachSlot	DesiredSlot;

	// if we're given a weapon, find an available slot for it
	if( GearInventoryManager(InvManager) != None && WorldInfo.NetMode != NM_Client )
	{
		// if checkpoint data mandates our slot, use that
		if ( CharacterSlot != EASlot_None && GearGameSP_Base(WorldInfo.Game) != None &&
			GearGameSP_Base(WorldInfo.Game).bCheckpointLoadInProgress )
		{
			DesiredSlot = CharacterSlot;
			CharacterSlot = EASlot_None; // avoids early out check
		}
		else
		{
			DesiredSlot = GearInventoryManager(InvManager).FindFreeSlotForInventoryClass(class);
		}
		AssignToSlot(DesiredSlot);
	}

	Super(Inventory).GivenTo(thisPawn, bDoNotActivate);
	`LogInv(Self @ "thisPawn:" @ thisPawn @ "bDoNotActivate:" @ bDoNotActivate @ "CharacterSlot:" @ CharacterSlot);

	if ( WorldInfo.NetMode != NM_Client && SiegeAmmoRegenFrequency > 0.0 && GearGameSiege_Base(WorldInfo.Game) != None &&
		Instigator != None && Instigator.GetTeamNum() == TEAM_LOCUST )
	{
		SetTimer(SiegeAmmoRegenFrequency, false, nameof(RegenAmmo));
	}

	// check for MP aid mode
	if (GearPC_MP(ThisPawn.Controller) != None && GearGameMP_Base(WorldInfo.Game).ShouldGiveNewbHelpTo(GearPC_MP(ThisPawn.Controller)))
	{
		AR_MagicBulletsTimeoutDuration = 0.0;
		bAutoActiveReload = true;
		// force active reload on for initial clip
		AmmoUsedCount = WeaponMagSize;
		SetActiveReloadBonusActive(true);
		AmmoUsedCount = 0;
	}
}


/** @see Inventory::ItemRemovedFromInvManager */
function ItemRemovedFromInvManager()
{
	local GearPawn	GP;

	// if weapon was attached, then remove it
	RemoveFromSlot();

	GP = GearPawn(Instigator);
	if( GP != None && GP.MyGearWeapon == Self )
	{
		GP.MyGearWeapon = None;
	}

	Super.ItemRemovedFromInvManager();
}


/**
 * Assign weapon to a given slot.
 * Triggers replication and visual updates through GearPawn.AttachWeaponToSlot()
 * Network: Server.
 */
function AssignToSlot(GearPawn.EAttachSlot Slot)
{
	local GearPawn	GP;

	GP = GearPawn(Instigator);

	if( GP != None )
	{
		`LogInv(Slot);
		if( Slot != EASlot_None )
		{
			if( CharacterSlot != Slot )
			{
				// force replication
				bForceNetUpdate = TRUE;
				// Assign slot
				CharacterSlot = Slot;
			}

			// trigger replication and visual updates
			GP.AttachWeaponToSlot(Self);
		}
	}
}


/**
 * Remove weapon from its slot. And set it to EASlot_None.
 * Triggers replication and visual updates through GearPawn.DetachWeaponFromSlot()
 * Network: Server.
 */
function RemoveFromSlot()
{
	local GearPawn	GP;

	GP = GearPawn(Instigator);
	if( GP != None )
	{
		`LogInv(CharacterSlot);

		if( CharacterSlot != EASlot_None )
		{
			// force replication
			bForceNetUpdate = TRUE;
			// trigger replication and visual updates
			GP.DetachWeaponFromSlot(Self);
			// clear slot
			CharacterSlot = EASlot_None;
		}
	}
}

simulated event Destroyed()
{
	local GearPawn	GP;

	Super.Destroyed();

	// make sure we got detached correctly
	if (CharacterSlot != EASlot_None)
	{
		GP = GearPawn(Instigator);
		if (GP != None)
		{
			GP.DetachWeaponFromSlot(self);
			CharacterSlot = EASlot_None;
		}
	}

	if (Scope != None)
	{
		Scope.Destroy();
	}
}

/** Sets up effects components that are attached to the weapon mesh. */
simulated event AttachMuzzleEffectsComponents(SkeletalMeshComponent SkelMesh)
{
	// we allowed attachment on dedicated servers, but we don't need stuff after this
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Attach muzzle flash related effects
	if( SkelMesh != None && MuzzleFlash != None && MuzzleFlash.MuzzleSocketName != '' )
	{
		// if we are pending kill then don't attach things
		if( SkelMesh.IsPendingKill() )
		{
			//ScriptTrace();
			return;
		}

		// attach muzzle flash emitter, and position to fire offset
		if( MuzzleFlash.MuzFlashEmitter != None && !SkelMesh.IsComponentAttached(MuzzleFlash.MuzFlashEmitter) )
		{
			SkelMesh.AttachComponentToSocket(MuzzleFlash.MuzFlashEmitter, MuzzleFlash.MuzzleSocketName);
			HideMuzzleFlashEmitter();
		}

		// Muzzle Flash dynamic light
		if( MuzzleFlash.MuzzleFlashLight != None && !SkelMesh.IsComponentAttached(MuzzleFlash.MuzzleFlashLight) )
		{
			MuzzleFlash.MuzzleFlashLight.SetTranslation(MuzzleFlash.MuzzleLightOffsetFromCannon);
			if (MuzzleFlash.MuzzleLightSocketName != '' && SkelMesh.GetSocketByName(MuzzleFlash.MuzzleLightSocketName) != None)
			{
				SkelMesh.AttachComponentToSocket(MuzzleFlash.MuzzleFlashLight, MuzzleFlash.MuzzleLightSocketName);
			}
			else
			{
				SkelMesh.AttachComponentToSocket(MuzzleFlash.MuzzleFlashLight, MuzzleFlash.MuzzleSocketName);
			}
		}

		// attach after fire particle system
		if( PSC_ReloadBarrelSmoke != None && !SkelMesh.IsComponentAttached(PSC_ReloadBarrelSmoke) )
		{
			SkelMesh.AttachComponentToSocket(PSC_ReloadBarrelSmoke, MuzzleFlash.MuzzleSocketName);
			HidePSC_ReloadBarrelSmoke();
		}
	}
}

/**
 * Returns TRUE if weapon should be mirrored when attached.
 * Uses MirrorNode.bPendingIsMirrored instead of PawnOwner.bIsMirrored, in case weapon attach is done before mirror has hapened.
 * This can happen with Heavy Weapons, as they use anim notifies, and are not synchronized with pawn mesh mirroring.
 */
simulated final function bool ShouldWeaponBeMirrored(GearPawn MyGearPawn)
{
	return !bNeverMirrorThisWeapon && MyGearPawn != None && MyGearPawn.MirrorNode != None && MyGearPawn.MirrorNode.bPendingIsMirrored;
}

/**
 * Attach Weapon Mesh to player's hand. This is not a slot attachment on the back,
 * but a full functioning weapon mesh in the player's hand to use.
 *
 * @param	SkeletalMeshComponent where to attach weapon
 * @param	SocketName of Socket to use in provided SkeletalMeshComponent
 */
simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	// Already attached there, skip.
	if( SocketName != '' && SocketAttachedTo == SocketName )
	{
		`Logd(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "Already attached to socket" @ SocketName @ ". Skipping attachment.");
		return;
	}

	SocketAttachedTo = SocketName;
	PerformWeaponAttachment(MeshCpnt, SocketName);
}

simulated function UpdateAnimNodeReferences()
{
	local SkeletalMeshComponent WeaponSkelMesh;

	WeaponSkelMesh = SkeletalMeshComponent(Mesh);
	if( WeaponSkelMesh == None )
	{
		`DLog("Warning:" @ Self @ "has no SkeletalMesh");
		return;
	}

	// See if for whatever reason our weapon didn't instance our AnimTree
	if( WeaponSkelMesh.Animations == None && WeaponSkelMesh.AnimTreeTemplate != None )
	{
		`DLog("Warning: AnimTreeTemplate not instanced!!!" @ WeaponSkelMesh.AnimTreeTemplate @ "Instigator" @ Instigator @ "Controller:" @ GetWeaponController());
		ScriptTrace();
 		WeaponSkelMesh.SetAnimTreeTemplate(WeaponSkelMesh.AnimTreeTemplate);
	}

	if( WeaponSkelMesh.Animations == None )
	{
		`DLog("Warning:" @ Self @ "has no Animations. AnimTreeTemplate:" @ WeaponSkelMesh.AnimTreeTemplate);
		return;
	}

	// Update our references
	CustomAnimNode = GearAnim_Slot(WeaponSkelMesh.FindAnimNode('CustomAnim'));
	AnimTreeRootNode = AnimTree(WeaponSkelMesh.Animations);
}

/** Notification called when one of our meshes gets his AnimTree updated */
simulated event AnimTreeUpdated(SkeletalMeshComponent SkelMesh)
{
// 	`DLog(SkelMesh.AnimTreeTemplate);
	if( SkelMesh == Mesh )
	{
		UpdateAnimNodeReferences();
	}

	Super.AnimTreeUpdated(SkelMesh);
}

/**
 * Called by AttachWeaponTo to perform weapon attachment after we're sure it's ok to do so.
 * @param   MeshCpnt    SkeletalMeshComponent where to attach weapon
 * @param	SocketName  Name of Socket to use in provided SkeletalMeshComponent
 */
simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	local SkeletalMeshComponent	SkelMesh;
	local GearPawn				P;
	local GearTurret            GT;
	local vector				NewScale3D;
	local name                  BoneName;

	// Add weapon specific animation sets
	// And remove unused ones.
	P = GearPawn(Instigator);
	GT = GearTurret(Instigator);
	SkelMesh = SkeletalMeshComponent(Mesh);

	`LogInv("MeshCpnt:" @ MeshCpnt @ "SocketName:" @ SocketName);

	BoneName = MeshCpnt.GetSocketBoneName(SocketName);

	// Attach Weapon mesh to player skelmesh
	if( Mesh != None && !MeshCpnt.IsComponentAttached(Mesh,BoneName) )
	{
		// Mirror weapon
		if( ShouldWeaponBeMirrored(P) )
		{
			NewScale3D = default.Mesh.Scale3D;
			NewScale3D.Y = -NewScale3D.Y;
			Mesh.SetScale3D( NewScale3D );
		}
		else
		{
			Mesh.SetScale3D(default.Mesh.Scale3D);
		}

		// Set Shadow parent and light environment.
		Mesh.SetShadowParent(MeshCpnt);
		if (P != None)
		{
			Mesh.SetLightEnvironment(P.LightEnvironment);
		}
		if (GT != None)
		{
			Mesh.SetLightEnvironment(GT.MyLightEnvironment);
		}

		MeshCpnt.AttachComponentToSocket(Mesh, SocketName);
	}

	if( SkelMesh != None )
	{
		if( SkelMesh.Animations != None )
		{
			UpdateAnimNodeReferences();
		}
		else
		{
			// AnimTree is not instanced right away, so set timer to cache nodes a little later.
			SetTimer(0.1f, FALSE, nameof(UpdateAnimNodeReferences) );
		}
	}

	AttachMuzzleEffectsComponents(SkelMesh);

	if (Owner != None && SkelMesh != None)
	{
		if (MIC_WeaponSkin == None)
		{
			MIC_WeaponSkin = SkelMesh.CreateAndSetMaterialInstanceConstant(0);
		}
		SetMaterialBasedOnTeam( SkelMesh, GearPawn(Owner) != none ? GearPawn(Owner).GetMPWeaponColorBasedOnClass() : Owner.GetTeamNum() );
		MIC_WeaponSkin.SetScalarParameterValue( 'Weap_DroppedGlow', 0.0f );
		MIC_WeaponSkin.SetScalarParameterValue( 'Weap_DropGlowAlpha', 0.0f );
	}

	// attach shell ejection particle system
	//@todo. Should this not check the SkelMesh if
	//    ShouldUseMuzzleFlashSocketForShellEjectAttach() == false???
	if( PSC_ShellEject != None && !MeshCpnt.IsComponentAttached(PSC_ShellEject) )
	{
		if( !ShouldUseMuzzleFlashSocketForShellEjectAttach() )
		{
			MeshCpnt.AttachComponentToSocket(PSC_ShellEject, SocketName);
		}
		else
		{
			SkelMesh.AttachComponentToSocket(PSC_ShellEject, MuzzleFlash.MuzzleSocketName);
		}

		PSC_ShellEject.bJustAttached = true;

		HidePSC_ShellEject();
	}

	if (bIsScopeWeapon)
	{
		SetupScopeLighting();
	}
}

/** Copy the light environment and shadow parent from the weapon mesh onto the scope */
simulated function SetupScopeLighting()
{
	if (Scope != None && Scope.Mesh != None && Mesh != None)
	{
		Scope.Mesh.SetLightEnvironment(Mesh.LightEnvironment);
		Scope.Mesh.SetShadowParent(Mesh.ShadowParent);
	}
}

/**
 * Some weapons end up in odd places when the do their reload.	As the PSC_ShellEject gets
 * attached to the hand bone (usually) we get crazy rotations when the shell eject actually happens
 * This allows us to override that behavior and attach to the muzzleFlash Socket which will be correct
 * orientation
 **/
simulated function bool ShouldUseMuzzleFlashSocketForShellEjectAttach()
{
	return FALSE;
}

/**
 * Detach weapon components from Instigator. Perform any clean up.
 */
simulated function DetachWeapon()
{
	local SkeletalMeshComponent SkelMeshComp;
	local SkeletalMeshComponent	PawnMesh;

	// when we are being scorched and switch weapons we need to turn off the burn value otherwise it will be there when we get it back
	if (MIC_WeaponSkin != None)
	{
		MIC_WeaponSkin.SetScalarParameterValue('Heat', 0.0);
		MIC_WeaponSkin.SetScalarParameterValue('Burn', 0.0);
	}

	// Stop holster animations at that point.
	StopHolsterAnims();

	// Clear socket name, so we can attach again later.
	SocketAttachedTo = '';

	// Clear node references so AnimTree can be garbage collected.
	CustomAnimNode = None;
	AnimTreeRootNode = None;


	if( Mesh != None )
	{
		SkelMeshComp = SkeletalMeshComponent(Mesh);
		if (SkelMeshComp != None)
		{
			PawnMesh = SkelMeshComp.AttachedToSkelComponent;
		}

		// Static meshes don't keep track of their attach parent, just wing it with the owner
		if (PawnMesh == None && Owner != None && Pawn(Owner) != None)
		{
			PawnMesh = Pawn(Owner).Mesh;
		}

		// detach mesh from instigator
		if (PawnMesh != None && PawnMesh.IsComponentAttached(Mesh))
		{
			PawnMesh.DetachComponent(Mesh);
		}

		// remove shadow parent and light environment, as this causes a nice little crash when garbage collection is performed.
		Mesh.SetShadowParent(None);
		Mesh.SetLightEnvironment(None);
	}

	if (PawnMesh != None)
	{
		// shell eject particle system
		if (PSC_ShellEject != None)
		{
			if (PawnMesh.IsComponentAttached(PSC_ShellEject))
			{
				PawnMesh.DetachComponent(PSC_ShellEject);
			}

			if (Mesh != None && SkelMeshComp != None && SkelMeshComp.IsComponentAttached(PSC_ShellEject))
			{
				SkelMeshComp.DetachComponent(PSC_ShellEject);
			}
		}
	}
}

simulated function HolsterWeaponTemporarily(bool bHolster)
{
	`LogInv("bHolster" @ bHolster);

	if( bHolster && !bTemporaryHolster )
	{
		bTemporaryHolster = TRUE;
		PutDownWeapon();
	}
	else if( !bHolster && bTemporaryHolster )
	{
		Activate();
		bTemporaryHolster = FALSE;
	}
}

/** @return whether this weapon can be martyred, that is, fired while DBNO */
simulated function bool CanMartyr();
/** called to trigger the weapon to use the suicide attack */
simulated function bool DoMartyrFire();

simulated state WeaponPuttingDown
{
	simulated function bool CanReload()
	{
		// no reloading when switching weapons
		return FALSE;
	}

	simulated function bool TryPutDown()
	{
		local GearPawn P;

		P = GearPawn(Instigator);
		if( P != None && P.IsDoingSpecialMove(SM_WeaponPickup) )
		{
			GSM_Pickup(P.SpecialMoves[SM_WeaponPickup]).TryToPutDownNotify();
		}
		else if (InvManager.PendingWeapon != None)
		{
			bTemporaryHolster = false;
			if (!IsTimerActive(nameof(WeaponIsDown)))
			{
				InvManager.ChangedWeapon();
			}
		}
		return FALSE;
	}

	/**
	 * Override WeaponIsDown() to not call DetachWeapon().
	 *
	 * We delay that to when the weapon pawn has played his weapon switching animation.
	 * When we switch weapons we lose our ActiveReload bonuses.
	 */
	simulated function WeaponIsDown()
	{
		local GearPawn P;

		P = GearPawn(Instigator);

		`LogInv("");

		if( bTemporaryHolster )
		{
			// tell pawn so he can detach and all that
			P.SetWeaponTemporarilyHolstered(TRUE);
		}
		else
		{
			if( InvManager.CancelWeaponChange() )
			{
				return;
			}

			// cancel the ActiveReload effects on this weapon
			if (AR_MagicBulletsTimeoutDuration > 0.0)
			{
				ActiveReload_NumBonusShots = 0;
				P.ActiveReload_CurrTier = 0;
				P.bActiveReloadBonusActive = false;
			}

			// switch to pending weapon
			InvManager.ChangedWeapon();
		}

		// Put weapon to sleep, except if instigator reselected the same weapon!
		if( Instigator.Weapon != Self )
		{
			GotoState('Inactive');
		}
	}

	/** Don't allow zooming in when putting down the weapon */
	simulated function SetZoomed(bool bNewZoomed, optional bool bToggleOwnerNoSee)
	{
		if (!bNewZoomed)
		{
			Global.SetZoomed(bNewZoomed, bToggleOwnerNoSee);
		}
	}

	/** Don't do any ammo grabbing if the weapon is being put down */
	simulated function Notify_AmmoGrab();
}


/**
 * Sets the timing for putting a weapon down.  The WeaponIsDown event is trigged when expired
 */
simulated function TimeWeaponPutDown()
{
	local GearPawn	P;
	local GearPC	PC;

	P = GearPawn(Instigator);

	if( P == None )
	{
		Super.TimeWeaponPutDown();
		return;
	}

	// If not a temporary holster, notify GearInventoryManager that we're putting our weapon down
	if( !bTemporaryHolster )
	{
		GearInventoryManager(InvManager).PuttingWeaponDown();
	}

	P.bSwitchingWeapons = TRUE;
	P.UpdateBoneLeftHandIK();

	// Set Timer for switch
	SetTimer( PutDownTime, FALSE, nameof(WeaponIsDown) );
	`LogInv("PutDownTime" @ PutDownTime);

	PC = GearPC(GetWeaponController());

	if( !P.bQuietWeaponEquipping
		&& ((WorldInfo.Game == None) || !WorldInfo.Game.bWaitingToStartMatch)
		&& (( PC != None && !PC.bCinematicMode) || ( PC == None ))
		)
	{
		if (WeaponDeEquipSound != None)
		{
			//`log( " EQ bQuietWeaponEquipping: " $ P.bQuietWeaponEquipping );
			//`log( "Hidden: " $ P.bHidden $ " PC.bCinematicMode: " $ PC.bCinematicMode	 );
			// Play putting down animation on Pawn
			P.PlaySound(WeaponDeEquipSound, TRUE);
		}
	}

	// First abort weapon related animations currently playing
	EndReloadAnimations();

	// Then play put down animation.
	PlayHolsterAnimation();

	if (bIsScopeWeapon)
	{
		SetZoomed(FALSE,TRUE);
	}
}

simulated function PlayHolsterAnimation()
{
	local GearPawn	P;

	P = GearPawn(Instigator);

	if ( P.OverrideHolsterAnimation(self)  == FALSE)
	{
		// Left Shoulder slot
		if( P.IsSlotLeftShoulder(CharacterSlot) )
		{
			P.BS_PlayByDuration(HolsterShoulderLeft, PutDownTime, 0.25f, -1.f,,, 'WeaponHolster');
		}
		// Right Shoulder Slot
		else if( P.IsSlotRightShoulder(CharacterSlot) )
		{
			P.BS_PlayByDuration(HolsterShoulderRight, PutDownTime, 0.25f, -1.f,,, 'WeaponHolster');
		}
		// Unsupported slot
		else
		{
			P.BS_PlayByDuration(HolsterShoulderRight, PutDownTime, 0.25f, -1.f,,, 'WeaponHolster');
		}
	}
}

/** Stop Holster animations */
simulated function StopHolsterAnims()
{
	local GearPawn P;

	P = GearPawn(Instigator);
	if (P != None)
	{
		P.BS_Stop(HolsterShoulderLeft, 0.25);
		P.BS_Stop(HolsterShoulderRight, 0.25);
	}
}

/**
 * Sets the timing for equipping a weapon.
 * The WeaponEquipped event is trigged when expired
 */
simulated function TimeWeaponEquipping()
{
	local GearPawn	P;
	local GearPC	PC;
	local int		i;
	local float		BlendInTime;

	P = GearPawn(Instigator);
	//`log(WorldInfo.TimeSeconds @ GetFuncName() );

	if( P == None )
	{
		SetTimer( 0.0001f, FALSE, nameof(WeaponEquipped) );
		return;
	}

	// We're switching weapons
	P.bSwitchingWeapons = TRUE;
	// Reset when we get a new weapon
	P.bTargetingNodeIsInIdleChannel = P.default.bTargetingNodeIsInIdleChannel;

	// Disable IK on Left Hand IK Bone if needed
	// Weapon such as grenades and pistol, don't want IK on Left Hand.
	P.UpdateBoneLeftHandIK();

	// Update AimOffset profiles.
	for(i=0; i<AimOffsetProfileNames.Length; i++)
	{
		P.SetAimOffsetNodesProfile(AimOffsetProfileNames[i]);
	}

	PC = GearPC(GetWeaponController());

	if( (!P.bQuietWeaponEquipping)
		&& ((WorldInfo.Game == None) || !WorldInfo.Game.bWaitingToStartMatch)
		&& ( ( PC != None && !PC.bCinematicMode) || ( PC == None ))
		)
	{
		if (WeaponEquipSound != None)
		{
			//`log( "De EQ bQuietWeaponEquipping: " $ P.bQuietWeaponEquipping $ " WorldInfo.Game: " $ WorldInfo.Game );
			//`log( "Hidden: " $ P.bHidden $ " PC.bCinematicMode: " $ PC.bCinematicMode	 );
			P.PlaySound(WeaponEquipSound, TRUE);
		}
	}

	SetTimer( EquipTime, FALSE, nameof(WeaponEquipped) );
	`LogInv("EquipTime" @ EquipTime);

	if( bTemporaryHolster )
	{
		// After a temporary holster, add a blend in time, because we're not perfectly transitioning from
		// the putdown animation.
		BlendInTime = 0.2f;
		SetTimer( BlendInTime, FALSE, nameof(EquipWeaponAfterTemporaryHolster) );
	}

	// Stop Holster Animations if they were playing.
	StopHolsterAnims();
	// End reloading animations
	EndReloadAnimations();

	PlayEquipAnimation(BlendInTime);

	// Attach weapon
	P.AttachWeapon();

	if (bIsScopeWeapon)
	{
		SetZoomed(FALSE,TRUE);
	}
}

reliable client function ClientWeaponThrown()
{
	local GearPawn	GP;
	local INT		i;

	GP = GearPawn(Instigator);

	Super.ClientWeaponThrown();

	// If we've thrown our currently held weapon, then we need to clear some things!
	// Like reset custom weapon animations.
	// This can cause bugs for ex.. if being chainsawed while carrying a heavy weapon.
	// Animations are not compatible, so we need to reset to default when weapon is dropped.
	if( GP != None && GP.MyGearWeapon == Self )
	{
		`LogInv("Updating animations.");
		// Clear reference to MyGearWeapon
		GP.MyGearWeapon = None;
		GP.Weapon = None;

		// Update animations to reflect this change.
		GP.bSwitchingWeapons = FALSE;
		GP.bEquipTransition = FALSE;
		// Update left hand IK
		GP.UpdateBoneLeftHandIK();

		// Update AimOffset profiles.
		for(i=0; i<class'GearWeapon'.default.AimOffsetProfileNames.Length; i++)
		{
			GP.SetAimOffsetNodesProfile(class'GearWeapon'.default.AimOffsetProfileNames[i]);
		}

		// Update the animation sets related to the current weapon
		// Adding or removing weapon specific sets.
		GP.UpdateAnimSetList();
		// Force Pawn mesh to be updated.
		GP.Mesh.ForceSkelUpdate();
	}
	RemoveFromSlot();
	Instigator = None;
}

simulated function PlayEquipAnimation(float BlendInTime)
{
	local GearPawn			P;
	local GearPawn_Infantry	InfantryPawn;

	P = GearPawn(Instigator);
	InfantryPawn = GearPawn_Infantry(Instigator);
	if( InfantryPawn != None )
	{
		InfantryPawn.StopIdleBreakAnim();
	}

	if( !P.IsDoingSpecialMove(SM_WeaponPickup) && !P.IsDoingSpecialMove(SM_TradeWeapons_Leader) && !P.IsDoingSpecialMove(SM_TradeWeapons_Follower) )
	{
		SetTimer(EquipTime * 0.5f, FALSE, nameof(TurnOnEquipTransition));

		if ( P.OverrideEquipAnimation(self, BlendInTime) == FALSE )
		{
			// Left Shoulder slot
			if( P.IsSlotLeftShoulder(CharacterSlot) )
			{
				// Verify we have slots for those animations.
				if( EquipShoulderLeft.Stance.Length > 0 && EquipShoulderLeft.Stance[0].Slot < P.BodyStanceNodes.Length && P.BodyStanceNodes[EquipShoulderLeft.Stance[0].Slot] != None )
				{
					P.BS_PlayByDuration(EquipShoulderLeft, EquipTime, BlendInTime, EquipTime * 0.5f,,, 'WeaponEquip');
				}
			}
			// Right Shoulder Slot or unsupported slot
			else
			{
				// Verify we have slots for those animations.
				if( EquipShoulderRight.Stance.Length > 0 && EquipShoulderRight.Stance[0].Slot < P.BodyStanceNodes.Length && P.BodyStanceNodes[EquipShoulderRight.Stance[0].Slot] != None )
				{
					P.BS_PlayByDuration(EquipShoulderRight, EquipTime, BlendInTime, EquipTime * 0.5f,,, 'WeaponEquip');
				}
			}
		}
	}
}

/** We use this to be able to turn on the IK sooner, so it blends in nicely */
simulated function TurnOnEquipTransition()
{
	local GearPawn	P;

	P = GearPawn(Instigator);
	if( P != None )
	{
		P.bEquipTransition = TRUE;
		P.UpdateBoneLeftHandIK();
	}
}

simulated function EquipWeaponAfterTemporaryHolster()
{
	GearPawn(Instigator).SetWeaponTemporarilyHolstered(FALSE);
}

state Inactive
{
	/**
	 * Force the scope hidden when we go inactive, fail safe
	 *
	 * @param PreviousStateName - the name of the previous state
	 */
	simulated event BeginState(Name PreviousStateName)
	{
		if (Scope != None)
		{
			Scope.SetHidden(TRUE);
		}

		Super.BeginState(PreviousStateName);
	}
}

simulated function WeaponEquipped();

/**
 * State WeaponEquipping
 * The Weapon is in this state while transitioning from Inactive to Active state.
 * Typically, the weapon will remain in this state while its selection animation is being played.
 * While in this state, the weapon cannot be fired.
 */
simulated state WeaponEquipping
{
	simulated function BeginState(Name PreviousStateName)
	{
		`LogInv("");
		Super.BeginState(PreviousStateName);

		// make sure the heat/burn effects are properly reset
		if (MIC_WeaponSkin != None)
		{
			MIC_WeaponSkin.SetScalarParameterValue('Heat', 0.0f);
			MIC_WeaponSkin.SetScalarParameterValue('Burn', 0.0f);
		}

		// make sure crosshair expansion is reset
		CrosshairExpansionFiringTime = 0.0;
	}

	simulated function EndState(Name NextStateName)
	{
		local GearPawn P;
		local GearPC PC;

		P = GearPawn(Instigator);
		if( P != None )
		{
			P.bSwitchingWeapons = FALSE;
			P.bEquipTransition = FALSE;
			// Update left hand IK
			P.UpdateBoneLeftHandIK();

			// Trigger the weapon equip delegates in the GearPC
			PC = GearPC(GetWeaponController());
			if ( PC != None )
			{
				PC.TriggerGearWeaponEquipDelegates( Class );
			}
		}

		Super.EndState(NextStateName);
	}

	simulated function WeaponEquipped()
	{
		if( bTemporaryHolster )
		{
			// tell pawn so he can detach and all that
			GearPawn(Instigator).SetWeaponTemporarilyHolstered(FALSE);
		}

		// If not a temporary holster, notify GearInventoryManager that we've equipped a weapon
		if( !bTemporaryHolster )
		{
			GearInventoryManager(InvManager).WeaponEquipped();
		}

		Super.WeaponEquipped();
	}
}

simulated function DrawDebugShot(vector StartLocation, rotator AimRot)
{
	DrawDebugLine( StartLocation, StartLocation + vector(AimRot) * 1024, 255, 255, 255, true );
}

/**
 * Returns the weapon-specific targeting FOV, or BaseFOV if the weapon
 * has no desire to specify a targeting FOV.
 */
simulated function float GetTargetingFOV(float BaseFOV)
{
	if (TargetingFOV <= 0)
	{
		return BaseFOV;
	}
	else
	{
		return TargetingFOV;
	}
}

/** Weapon can make situational FOV adjustments if it so chooses */
simulated function float GetAdjustedFOV(float BaseFOV)
{
	//local GearPawn	GP;
	//GP = GearPawn(Instigator);

	//if (GP != None)
	//{
	//	if (GP.IsInAimingPose())
	//	{
	//		return BaseFOV + AimingFOVAdjustment;
	//	}
	//}

	return BaseFOV;
}

/** Returns the amount of time AI should pause before firing first shot */
final function float GetAIAimDelay()
{
	return RandRange( AI_AimDelay.X, AI_AimDelay.Y );
}


//@see GearPawn.SetAttachmentVisibility
//@see GearShield for duplicated version of this as it has a different hierarchy
simulated function SetMaterialBasedOnTeam( MeshComponent TheMesh, int TeamNum )
{
	local LinearColor LC;
	local GearPawn GP;
	local Turret_MultiTurretBase Turret;

	if (TheMesh != None &&
		MIC_WeaponSkin != None)
	{
		GP = GearPawn(Owner);
		// Handle the player being on a turret
		if (GP == None)
		{
			Turret = Turret_MultiTurretBase(Owner);
			if (Turret != None)
			{
				GP = GearPawn(Turret.Driver);
			}
		}

		if (GP != None)
		{
		   TeamNum = GP.GetMPWeaponColorBasedOnClass();
		}

		// COG
		if( TeamNum == 0 )
		{
			LC = GetWeaponEmisColor_COG( WorldInfo, WeaponID );
		}
		else
		{
			LC = GetWeaponEmisColor_Locust( WorldInfo, WeaponID );
		}

		MIC_WeaponSkin.SetVectorParameterValue( 'Weap_EmisColor', LC );
	}
}

/** This will return the COG Emissive Color for this weapon for this map **/
static simulated function LinearColor GetWeaponEmisColor_COG( WorldInfo TheWorldInfo, EWeaponClass WeapID )
{
	local GearMapSpecificInfo GSI;
	local LinearColor LC;

	GSI = GearMapSpecificInfo(TheWorldInfo.GetMapInfo());
	if( ( GSI != none ) && ( GSI.ColorConfig != none ) )
	{
		LC = GSI.ColorConfig.WeaponColors[WeapID].EmissiveCOG;
		if( ( LC.A != 0 ) || ( LC.R != 0 ) || ( LC.G != 0 ) || ( LC.B != 0 ) )
		{
			//`log( "using EmissiveCOG " $ LC.A @ LC.R @ LC.G @ LC.B );
			return LC;
		}

		// so try default if there was no weapon specific setting
		LC = GSI.ColorConfig.DefaultWeaponColor.EmissiveCOG;
		if( ( LC.A != 0 ) || ( LC.R != 0 ) || ( LC.G != 0 ) || ( LC.B != 0 ) )
		{
			//`log( "using global EmissiveCOG " $ LC.A @ LC.R @ LC.G @ LC.B );
			return LC;
		}
	}
	//`log( "using GlobalDefaultColors.WeaponColors[WeapID].EmissiveCOG" );

	LC = default.GlobalDefaultColors.WeaponColors[WeapID].EmissiveCOG;
	if( ( LC.A != 0 ) || ( LC.R != 0 ) || ( LC.G != 0 ) || ( LC.B != 0 ) )
	{
		//`log( "using EmissiveCOG " $ LC.A @ LC.R @ LC.G @ LC.B );
		return LC;
	}

	//`log( "using default.EmissiveCOG" );
	return default.GlobalDefaultColors.DefaultWeaponColor.EmissiveCOG;
}

/** This will return the Locust Emissive Color for this weapon for this map **/
static simulated function LinearColor GetWeaponEmisColor_Locust( WorldInfo TheWorldInfo, EWeaponClass WeapID )
{
	local GearMapSpecificInfo GSI;
	local LinearColor LC;

	GSI = GearMapSpecificInfo(TheWorldInfo.GetMapInfo());
	if( ( GSI != none ) && ( GSI.ColorConfig != none ) )
	{
		LC = GSI.ColorConfig.WeaponColors[WeapID].EmissiveLocust;
		if( ( LC.A != 0 ) || ( LC.R != 0 ) || ( LC.G != 0 ) || ( LC.B != 0 ) )
		{
			//`log( "using EmissiveLocust " $ LC.A @ LC.R @ LC.G @ LC.B );
			return LC;
		}

		// so try default if there was no weapon specific setting
		LC = GSI.ColorConfig.DefaultWeaponColor.EmissiveLocust;
		if( ( LC.A != 0 ) || ( LC.R != 0 ) || ( LC.G != 0 ) || ( LC.B != 0 ) )
		{
			//`log( "using global EmissiveLocust " $ LC.A @ LC.R @ LC.G @ LC.B );
			return LC;
		}
	}
	//`log( "using GlobalDefaultColors.WeaponColors[WeapID].EmissiveLocust" );

	LC = default.GlobalDefaultColors.WeaponColors[WeapID].EmissiveLocust;
	if( ( LC.A != 0 ) || ( LC.R != 0 ) || ( LC.G != 0 ) || ( LC.B != 0 ) )
	{
		//`log( "using EmissiveCOG " $ LC.A @ LC.R @ LC.G @ LC.B );
		return LC;
	}


	//`log( "using default.LC_EmisDefaultLocust" );
	return default.GlobalDefaultColors.DefaultWeaponColor.EmissiveLocust;
}


/** This will return the muzzle flash light color for this map **/
simulated protected function Color GetMuzzleFlashLightColor()
{
	local GearMapSpecificInfo GSI;
	local Color LC;

	GSI = GearMapSpecificInfo(WorldInfo.GetMapInfo());
	if( ( GSI != none ) && ( GSI.ColorConfig != none ) )
	{
		LC = bActiveReloadVisualEffectsActive ? GSI.ColorConfig.WeaponColors[WeaponID].MuzzleFlashLightColor_AR : GSI.ColorConfig.WeaponColors[WeaponID].MuzzleFlashLightColor;
		if( ( LC.A != 0 ) || ( LC.R != 0 ) || ( LC.G != 0 ) || ( LC.B != 0 ) )
		{
			return LC;
		}

		// so try default if there was no weapon specific setting
		LC = bActiveReloadVisualEffectsActive ? GSI.ColorConfig.DefaultWeaponColor.MuzzleFlashLightColor_AR : GSI.ColorConfig.DefaultWeaponColor.MuzzleFlashLightColor;
		if( ( LC.A != 0 ) || ( LC.R != 0 ) || ( LC.G != 0 ) || ( LC.B != 0 ) )
		{
			return LC;
		}
	}

	return bActiveReloadVisualEffectsActive ? default.GlobalDefaultColors.DefaultWeaponColor.MuzzleFlashLightColor_AR : default.GlobalDefaultColors.DefaultWeaponColor.MuzzleFlashLightColor_AR;
}



/**
 * Causes this weapon to play the given audio. Will replicate to all non-owning clients.
 *
 * @param Sound			SoundCue to play.
 * @param NoiseLoudness	Optional intensity of AI noise.
 */
simulated function WeaponPlaySound( SoundCue Sound, optional float NoiseLoudness )
{
	if( (Sound == None) || bSuppressAudio )
	{
		return;
	}

	if ( Instigator != None )
	{
		// play spatialized, no replication
		PlaySound(Sound,, TRUE,, Instigator.Location);

		// Maybe alert AI of the noise
		if ( (NoiseLoudness > 0.f) && (WorldInfo.Netmode != NM_Client) )
		{
			Instigator.MakeNoise( NoiseLoudness, 'WeaponPlaySound' );
		}
	}
	else
	{
		// @check this, dummy fire weapons should replicate audio?
		PlaySound(Sound,, TRUE);
	}
}



/**
 * Similar to GearWeaponPlaySound, except it returns you the AudioComponent.  Useful for looping sounds, sounds you want greater control over, etc.
 * Does not replicate.
 *
 * @param Sound - SoundCue to play, must be valid.
 *
 * @param AltLocalSound - Optional alternate SoundCue to play for local players.  Implies bNonSpatialized=TRUE for local players.
 *
 * @param AltSquadSound - Optional alternate SoundCue to play when the weapon owner is a squadmate.
 *
 * @param AC - an audio component to reuse
 *
 * @param FadeInTime - how long it should take to fade in the sound
 *
 * @return the audio component of the played sound
 */
simulated function protected AudioComponent GearWeaponPlaySoundLocalEx(SoundCue Sound, optional SoundCue AltLocalSound, optional SoundCue AltSquadSound, optional AudioComponent AC, optional float FadeInTime)
{
	local GearPC GPC;
	local GearPC LocalPC;
	local Actor SoundOwner;

	// @todo, test this with dummyfire (e.g. gatling)

	if (bSuppressAudio)
	{
		return None;
	}

//	`log("GearWeaponPlaySoundLocalEx()"@Sound@AltLocalSound);

	// handles dummyfire, where instgator & owner are none
	SoundOwner = (Owner == None) ? self : Owner;

	// handle non-spatialized looping sounds
	if (AltLocalSound != None)
	{
		GPC = GearPC(GetWeaponController());

		if (GPC != None && GPC.IsLocalPlayerController() && GPC.IsViewingTarget(Instigator))
		{
			// play LocalSound non-spatialized
			if (AC == None || AC.IsPendingKill())
			{
				AC = SoundOwner.CreateAudioComponent(AltLocalSound, FALSE, TRUE);
			}
			if (AC != None)
			{
				AC.bUseOwnerLocation = TRUE;
				AC.bAllowSpatialization = FALSE;
				AC.bAutoDestroy = TRUE;
				AC.FadeIn(FadeInTime, 1.f);

				// done, bail
				return AC;
			}
		}
	}

	if (AltSquadSound != None && Instigator != None)
	{
		foreach LocalPlayerControllers(class'GearPC', LocalPC)
		{
			if (Instigator.IsSameTeam(LocalPC.Pawn))
			{
				//`log("Playing" @ `showvar(AltSquadSound));

				if (AC == None || AC.IsPendingKill())
				{
					AC = SoundOwner.CreateAudioComponent(AltSquadSound, FALSE, TRUE);
					if (AC != None)
					{
						AC.bUseOwnerLocation	= TRUE;
						AC.bAutoDestroy			= TRUE;
						SoundOwner.AttachComponent(AC);
					}
				}
				if (AC != None)
				{
					AC.FadeIn(FadeInTime, 1.f);

					return AC;
				}
			}
		}
	}

	if (Sound != None)
	{
		if (AC == None || AC.IsPendingKill())
		{
			AC = SoundOwner.CreateAudioComponent(Sound, FALSE, TRUE);
			if (AC != None)
			{
				AC.bUseOwnerLocation	= TRUE;
				AC.bAutoDestroy			= TRUE;
				SoundOwner.AttachComponent(AC);
			}
		}
		if (AC != None)
		{
			AC.FadeIn(FadeInTime, 1.f);
		}
	}

	return AC;
}


 /**
  * Causes this weapon to play the given audio. Does not replicate, plays only on this machine.
  *
  * @param Sound - SoundCue to play, must be valid.
  *
  * @param AltLocalSound - Optional alternate SoundCue to play for local players.  Implies bNonSpatialized=TRUE for local players.
  *
  * @param AltSquadSound - Optional alternate SoundCue to play when the weapon owner is a squadmate.
  *
  * @param bNonSpatialized - TRUE to play the sound nonspatialized.  Will only play for locally controlled players.
  *
  * @param NoiseLoudness - Optional intensity of AI noise.
  */
simulated protected function GearWeaponPlaySoundLocal(SoundCue Sound, optional SoundCue AltLocalSound, optional SoundCue AltSquadSound, optional bool bNonSpatialized, optional float NoiseLoudness)
{
	local AudioComponent AC;
	local GearPC GPC;
	local GearPC LocalPC;
	local SoundCue Cue;
	local Controller C;

	if (bSuppressAudio)
	{
		return;
	}

	//`log("GearWeaponPlaySoundLocal()"@Sound@AltLocalSound@bNonSpatialized@NoiseLoudness);

	// which cue to play
	if (AltLocalSound != None)
	{
		GPC = GearPC(GetWeaponController());
		if (GPC != None && GPC.IsLocalPlayerController() && GPC.IsViewingTarget(Instigator))
		{
			Cue = AltLocalSound;
			bNonSpatialized = TRUE;
		}
	}

	if (Cue == None && AltSquadSound != None && Instigator != None)
	{
		foreach LocalPlayerControllers(class'GearPC', LocalPC)
		{
			if (Instigator.IsSameTeam(LocalPC.Pawn))
			{
				Cue = AltSquadSound;
				break;
			}
		}
	}

	if (Cue == None)
	{
		Cue = Sound;
	}

	if (Cue == None)
	{
		return;
	}

	//`log(`showvar(Cue));

	// now play
	if (Instigator != None)
	{
		if (bNonSpatialized)
		{
			C = GetWeaponController();
			if (C != None && C.IsLocalPlayerController())
			{
				AC = Instigator.CreateAudioComponent(Cue, FALSE, TRUE);
				if (AC != None)
				{
					AC.bUseOwnerLocation = TRUE;
					AC.bAllowSpatialization = FALSE;
					AC.bAutoDestroy = TRUE;
					AC.Play();
				}
			}
		}
		else
		{
			// play spatialized, no replication
			PlaySound(Cue, TRUE,,, Instigator.Location);
		}

		// Maybe alert AI of the noise
		if (NoiseLoudness > 0.f && WorldInfo.Netmode != NM_Client)
		{
			Instigator.MakeNoise(NoiseLoudness, 'GearWeaponPlaySoundLocal');
		}
	}
	else
	{
		// play spatialized, no replication
		PlaySound(Sound, TRUE);
	}
}



/**
 * simplified version of ProjectileFire(), useful in situations where the weapon
 * has no Instigator and we need a simpler firing model (see DummyFire kismet action)
 */
simulated event Projectile ProjectileFireSimple(optional float AimErrorDeg)
{
	local vector RealStartLoc, AimDir;
	local Projectile SpawnedProjectile;
	local rotator AimRot;
	local float AimErrorUnr;

	// fire a projectile without an instigator.	 nothing fancy, just straight
	if( WorldInfo.Netmode != NM_Client )
	{
		AimRot = Rotation;

		// modify Aim to add player aim error
		// and convert aim error from degrees to Unreal Units ( * 65536 / 360 )
		if (AimErrorDeg != 0.f)
		{
			AimErrorUnr = AimErrorDeg * 182.044;
			AimRot.Pitch += AimErrorUnr * (0.5 - FRand());
			AimRot.Yaw	 += AimErrorUnr * (0.5 - FRand());
		}
		AimDir = vector(AimRot);
		RealStartLoc = GetPhysicalFireStartLoc();

		SpawnedProjectile = Spawn(GetProjectileClass(), Self,, RealStartLoc);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( AimDir );
			GearProjectile(SpawnedProjectile).bSuppressAudio = bSuppressAudio;
			if( bHideProjectile )
			{
				SpawnedProjectile.SetHidden(true);
			}
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}

/** This weapon was denied the opportunity to fire because it could not blind fired.  Give any desired feedback to the player. */
simulated function DoCannotBlindfireFeedback();

static function PrimitiveComponent GetPickupMesh(PickupFactory Factory)
{
	return default.DroppedPickupMesh;
}

function CreateCheckpointRecord(out InventoryRecord Record)
{
	Record.InventoryClassPath = PathName(Class);
	Record.AmmoUsedCount = AmmoUsedCount;
	Record.SpareAmmoCount = SpareAmmoCount;
	Record.CharacterSlot = CharacterSlot;
	Record.bIsActiveWeapon = (Instigator.Weapon == self);
}

function ApplyCheckpointRecord(const out InventoryRecord Record)
{
	AmmoUsedCount = Record.AmmoUsedCount;
	SpareAmmoCount = Record.SpareAmmoCount;
	CharacterSlot = EAttachSlot(Record.CharacterSlot);
}

simulated function bool IsFiring()
{
	return IsFireState(GetStateName());
}

/** @return whether the player is allowed to pick up something off the ground right now
 * used e.g. to prevent swapping weapons while doing uninterruptable weapon animations
 */
simulated function bool AllowPickupMove()
{
	return true;
}

/** gives the weapon an opportunity to affect analog input handling */
simulated function PreProcessInput(GearPlayerInput TheInput);

function PlayNeedsAmmoChatter()
{
	if (WorldInfo.NetMode != NM_Client)
	{
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_NeedAmmo, Instigator, None);
	}
}

/** Returns the number of ammo icons this weapon will display in a clip */
simulated function float GetAmmoIconCount()
{
	return HUDDrawData.DisplayCount;
}

/** Returns the pixel width of a single ammo for the HUD */
simulated function float GetPixelWidthOfAmmo()
{
	return HUDDrawData.ULPerAmmo;
}

simulated function DebugDrawFireLocation()
{
	local Vector V, D;
	local byte OFM;

	OFM = CurrentFireMode;
	CurrentFireMode = ALTFIRE_FIREMODE;

	GetProjectileFirePosition( V, D );
	DrawDebugBox( V, vect(10,10,10), 255, 0, 0 );
	DrawDebugLine( V, V + D * 128, 255, 0, 0 );
	CurrentFireMode = OFM;
}

/** the MP bot AI uses this to determine if it should delay its current action and pick this up when it gets close
 * currently the return value is used as a bool so just return 0 or 1
 */
static function float DetourWeight(Pawn Other, float PathWeight)
{
	local GearAI_TDM AI;
	local GearWeapon CompareWeapon;
	local GearInventoryManager GearInvManager;

	AI = GearAI_TDM(Other.Controller);
	if (!default.bAIAvoidsTaking && !AI.IsUnderHeavyFire() && AI.GetHealthPercentage() ~= 1.0)
	{
		// compare base rating to our current weapon in the slot, if any
		GearInvManager = GearInventoryManager(Other.InvManager);
		switch (default.WeaponType)
		{
			case WT_Normal:
				CompareWeapon = GearWeapon(GearInvManager.GetInventoryInSlot(EASlot_LeftShoulder));
				// avoid assault rifle
				if ( CompareWeapon != None &&
					(CompareWeapon.IsA('GearWeap_AssaultRifle') || CompareWeapon.IsA('GearWeap_LocustAssaultRifle')) )
				{
					CompareWeapon = GearWeapon(GearInvManager.GetInventoryInSlot(EASlot_RightShoulder));
				}
				break;
			case WT_Holster:
				CompareWeapon = GearWeapon(GearInvManager.GetInventoryInSlot(EASlot_Holster));
				break;
			case WT_Item:
				CompareWeapon = GearWeapon(GearInvManager.GetInventoryInSlot(EASlot_Belt));
			case WT_Heavy:
				break;
			default:
				`Warn("Unknown WeaponType" @ default.WeaponType @ "for" @ default.Class);
				break;
		}

		return (CompareWeapon == None || !CompareWeapon.HasAnyAmmo() || CompareWeapon.default.AIRating < default.AIRating) ? 1 : 0;
	}
	else
	{
		return 0;
	}
}

/** Returns TRUE if weapon wants to define focus loc, false otherwise. */
simulated function bool GetCameraDOFFocusLocation(out vector FocusLoc)
{
	return FALSE;
}

// when an AI wants to evade it will stop firing, then pause for however long this function tells it to before triggering an evade
function float AIDelayBeforeEvade(GearAI AI)
{
	return 0.f;
}

simulated protected native event UpdateBarrelHeatMaterial();
/** Returns the Barrel heat value if this weapons has one**/
simulated function float GetCurrentBarrelHeat()
{
	return CurrentBarrelHeat;
}
simulated function bool IsHeatLimited();
simulated function BeginActiveCooling();
simulated function EndActiveCooling();

/** Allow pawns to cause a weapon to overheat */
simulated function ForceOverheat();

/** Allow pawns to force clear a weapon that is overheating */
simulated function ClearOverheat();

/** If bOverrideDistanceForEnemyTrace is TRUE, this function will be called to provide distance to trace for enemies */
simulated function float GetWeaponDistanceForEnemyTrace()
{
	return class'GearGame.GearPC'.default.DistanceForEnemyTrace;
}

/** TRUE if reloading weapon takes out of TargetingMode, TRUE for most weapons. */
simulated event bool ShouldReloadingPreventTargeting()
{
	return bReloadingWeaponPreventsTargeting;
}

simulated event PostDemoRewind()
{
	// make sure firing effects get disabled if we're not firing now
	if (Instigator == None || (Instigator.FlashCount == 0 && IsZero(Instigator.FlashLocation)))
	{
		StopMuzzleFlashEffect();
		if (MuzzleFlash != None && MuzzleFlash.MuzFlashEmitter != None)
		{
			HideMuzzleFlashEmitter();
		}
		StopFireEffects(0);
	}
}

/**
 * When Controller Switches from AI to player (or vice versa), call this to clear it up
 *
 */
simulated function CacheAIController()
{
	local AIController OldAIController;

	OldAIController = AIController;

	Super.CacheAIController();

	if (AIController != OldAIController)
	{
		// Stop Firing
		ForceEndFire();
		GearAIController = GearAI(GetWeaponController());
	}
}


/** Returns MIC for zoomed hud overlay if this weapon has one. */
simulated function MaterialInstanceConstant GetZoomedHUDOverlay()
{
	if (ZoomHUDOverlayMaterial != None)
	{
		// create MIC if necessary
		if (ZoomHUDOverlayMIC == None)
		{
			ZoomHUDOverlayMIC = new(outer) class'MaterialInstanceConstant';
			ZoomHUDOverlayMIC.SetParent( ZoomHUDOverlayMaterial );
		}

		// check for team here?
		if( GearPawn_LocustBase(Instigator) == None )
		{
			ZoomHUDOverlayMIC.SetVectorParameterValue( 'SniperScopeColor', CogZoomColor ); // blue
		}
		else
		{
			ZoomHUDOverlayMIC.SetVectorParameterValue( 'SniperScopeColor', LocustZoomColor ); // red
		}

		SetHUDOverlayAspectRatio( ZoomHUDOverlayMIC );

		return ZoomHUDOverlayMIC;
	}

	return None;
}

/** This will set the correct Material Parameters on the Overlay to make the sniper work in 9:6 and 4:3 SP/SplitScreen **/
final protected native function SetHUDOverlayAspectRatio( MaterialInstanceConstant HUDOverlayMIC );

/** Accessor function to get the controller of the specified pawn. */
simulated native final function Controller GetPawnController(Pawn P) const;

/** Accessor function to get the controller of the pawn who is carrying this weapon */
simulated native final function Controller GetWeaponController() const;


/**
 * Sets the timing for the firing state on server and local client.
 * !!DO NOT!! loop the timer, because we need to reevaluate the fire interval on every shot due to active reload
 * When the delay has expired, the RefireCheckTimer event is triggered.
 *
 * Network: LocalPlayer and Server
 *
 * @param	FireModeNum		Fire Mode.
 */
simulated function TimeWeaponFiring( byte FireModeNum )
{
	// if weapon is not firing, then start timer. Firing state is responsible to stopping the timer.
	if( !IsTimerActive( nameof(RefireCheckTimer) ) )
	{
		SetTimer( GetFireInterval(FireModeNum), false, nameof(RefireCheckTimer) );
	}
}


/** Called when the aimlocation of the gearpawn_infantry holding this weapon has been updated
 *  At the moment only used by the heavy sniper to aim the targeting laser
 *  @param AimLocation - the point this weapon is aimed at
 */
simulated function AimLocationUpdated(vector AimLocation);

/**
 * called when an AI us using this weapon and can't see its target.  Allows the weapon to override the aimloc and provide a safe fire spot when the target is not visible
 * @param out_AimLoc - the aimloc to be adusted
 */
function AdjustAIAimLocWhenCantSeeEnemy(out vector AimLoc); //stub

/** @return whether the AI should fire this weapon suppressively - i.e, at enemies they can't currently see but believe are in cover to try to keep the enemy pinned down */
function bool IsSuppressive()
{
	return bIsSuppressive;
}

/**
 * Find the input of the controlling player
 *
 * @return a reference to the GearPlayerInput of the current controller
 */
simulated protected function GearPlayerInput GetControllingPlayerInput()
{
	local GearPC GPC;
	GPC = GearPC(GetWeaponController());
	return (GPC != None) ? GearPlayerInput(GPC.PlayerInput) : None;
}

/**
 * Remote pawn has changed the zoom level on their weapon
 *
 * @param bIsZoomed - whether it was zoomed in or out
 */
simulated function RemoteZoomLevelChanged(bool bIsZoomed);

defaultproperties
{
	GlobalDefaultColors=GearPerMapColorConfig'GearMapColorArchetypes.GlobalDefault'
	bKillDuringLevelTransition=FALSE

	bDynamicMuzzleFlashes=FALSE

	bCanThrowActiveWeapon=TRUE
	WeaponType=WT_Normal
	CharacterSlot=EASlot_None
	DroppedPickupClass=class'GearDroppedPickup'
	AmmoTypeClass=class'GearAmmoType' // this will make a weapon that has not defined any specific type get ammo from anything

	bAllowsRoadieRunning=TRUE
	bPlayIKRecoil=TRUE
	bPlayDefaultBlindFireStance=TRUE
	bBlindFirable=TRUE
	bSupports360AimingInCover=TRUE
	bAllowIdleStance=TRUE
	bAllowAimingStance=TRUE
	bAllowDownsightsStance=TRUE
	CrosshairExpandStrength=0.25

	MinBlindFireUpAimPitch=-16384
	MinBlindFireSideYaw=-4096

	// MAIN FIREMODE
	FiringStatesArray(0)="WeaponFiring"
	WeaponFireTypes(0)=EWFT_InstantHit
	InstantHitDamageTypes(0)=class'GearDamageType'
	InstantHitMomentum(0)=1
	InstantHitMomentum(1)=1

	// RELOAD
	FiringStatesArray(RELOAD_FIREMODE)="Reloading"
	WeaponFireTypes(RELOAD_FIREMODE)=EWFT_InstantHit	// this is not actually a firing mode, but this avoids an access None log spam

	// MELEE_ATTACK_FIREMODE
	FiringStatesArray(MELEE_ATTACK_FIREMODE)="MeleeAttacking"
	WeaponFireTypes(MELEE_ATTACK_FIREMODE)=EWFT_InstantHit
	InstantHitDamageTypes(MELEE_ATTACK_FIREMODE)=class'GDT_Melee'

	AimOffsetProfileNames(0)="Default"

	WeaponReloadBlendOutTime=0.45f
	BS_PawnWeaponReload={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_AR_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_AR_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_AR_Cov_Std_Reload"))
		)}

	// No success animations, just speed up the normal one.
	BS_PawnWeaponReloadSuccess={(Stance=())}

	BS_PawnWeaponReloadFail={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_AR_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_AR_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_AR_Cov_Std_Reload_Fail"))
		)}

	HolsterShoulderLeft={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_AR_Holster_Lt"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_AR_Cov_Std_Holster_Lt"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_AR_Cov_Mid_Holster_Lt"))
	)}

	HolsterShoulderRight={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_AR_Holster_Rt"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_AR_Cov_Std_Holster_Rt"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_AR_Cov_Mid_Holster_Rt"))
	)}

	EquipShoulderLeft={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_AR_Equip_Lt"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_AR_Cov_Std_Equip_Lt"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_AR_Cov_Mid_Equip_Lt"))
	)}

	EquipShoulderRight={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_AR_Equip_Rt"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_AR_Cov_Std_Equip_Rt"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_AR_Cov_Mid_Equip_Rt"))
	)}

	BS_MeleeAttack(0)=(Stance=((Slot=BS_Layer1,AnimName="ADD_AR_Melee_Smack_A")))
	BS_MeleeAttack(1)=(Stance=((Slot=BS_Layer1,AnimName="ADD_AR_Melee_Smack_C")))
	BS_MeleeAttack(2)=(Stance=((Slot=BS_Layer1,AnimName="ADD_AR_Melee_Smack_B")))
	BS_MeleeKick=(Stance=((Slot=BS_FullBody,AnimName="AR_Low_Kick")))
	bDoMeleeAdhesion=TRUE
	MeleeImpactCompleteTime=-1.f

	WeaponReloadSound=None

	FireSound=None
	FireNoAmmoSound=SoundCue'Weapon_AssaultRifle.Firing.CogRifleFireEmptyCue'
	WeaponEquipSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleRaiseCue'
	WeaponDeEquipSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleLowerCue'

	PickupSound=SoundCue'Weapon_AssaultRifle.Actions.CogRiflePickupCue'
	WeaponDropSound=SoundCue'Weapon_Sniper.Actions.CogSniperDropCue'

	bCanActiveReload=true
	AR_FailSound=SoundCue'Interface_Audio.Interface.ActiveReloadFailCue'
	AR_SuccessSound=SoundCue'Interface_Audio.Interface.ActiveReloadSuccessCue'
	AR_SuperSuccessSound=SoundCue'Interface_Audio.Interface.ActiveReloadSuperSuccessCue'

//	ActiveReload_BonusDurationTier=(3.0f,4.0f,5.0f)

	bIsSuppressive=TRUE

	AimAssistScale=1.0
	AimAssistScaleWhileTargeting=1.0

	TracerType=WTT_LongSkinny
	TracerTypeAR=WTT_LongSkinnyAR
	TracerScale=(X=1.f,Y=1.f,Z=1.f)
	TracerScaleAR=(X=1.15f,Y=1.15f,Z=1.15f)

	bCanDisplayReloadTutorial=FALSE
	DamageTypeClassForUI=class'GDT_AssaultRifle'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=222,V=100,UL=143,VL=46)
	IconXOffset = 0
	IconYOffset = 0

	AnnexWeaponIcon=(U=0,V=0,UL=128,VL=40)

	Recoil_Hand={(
					TimeDuration=0.33f,
					RotAmplitude=(X=1500,Y=200,Z=0),
					RotFrequency=(X=10,Y=10,Z=0),
					RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
					LocAmplitude=(X=-4,Y=0,Z=1),
					LocFrequency=(X=10,Y=0,Z=10),
					LocParams=(X=ERS_Zero,Y=ERS_Zero,Z=ERS_Random)
					)}

	Recoil_Spine={(
					TimeDuration=0.67f,
					RotAmplitude=(X=750,Y=100,Z=0),
					RotFrequency=(X=10,Y=10,Z=0),
					RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero)
					)}


	bCanSelectWithoutAmmo=TRUE
	bAutoSwitchWhenOutOfAmmo=FALSE
	bSwappable=TRUE

	NeedReloadNotifySound=SoundCue'Interface_Audio.Interface.NeedsReloadNotifyCue'

	bUseTargetingCamera=TRUE
	EquipTime=0.57f
	PutDownTime=0.425f

	HUDDrawData=(DisplayCount=30,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=240,UL=119,VL=7),ULPerAmmo=4)
	HUDDrawDataSuper=(DisplayCount=30,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=240,UL=119,VL=7),ULPerAmmo=4)

	bUseMeleeHitTimer=TRUE
	RespawnTime=30.0
	CrosshairIcon=Texture2D'Warfare_HUD.WarfareHUD_XHairs_assaultrifle'

	// Weapon Mesh
	Begin Object Class=SkeletalMeshComponent Name=WeaponMesh
		CollideActors=FALSE
		bCastDynamicShadow=TRUE
		MotionBlurScale=0.0
		bUpdateSkelWhenNotRendered=FALSE
		bAcceptsDynamicDecals=FALSE // Each decal on them causes entire SkelMesh to be rerendered
		bAllowAmbientOcclusion=false
		bPerBoneMotionBlur=TRUE
	End Object

	// shell case ejection emitter
	Begin Object Class=ParticleSystemComponent Name=PSC_WeaponShellCaseComp
	    bAutoActivate=FALSE
		Rotation=(Yaw=-16384)
		TickGroup=TG_PostUpdateWork
	End Object
	//PSC_ShellEject=PSC_WeaponShellCaseComp  // each subclass should set this if they want one

	// reload barrel smoke
	Begin Object Class=ParticleSystemComponent Name=PSC_WeaponReloadBarrelSmokeComp
	    bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	//PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp  // each subclass should set this if they want one


	bHitWallThisAttack = false;
	MeleeTraceExtent=(X=8,Y=8,Z=8)

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting0
		Samples(0)=(LeftAmplitude=20,RightAmplitude=20,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting0

	bReloadingWeaponPreventsTargeting=TRUE
	bForceWalkWhenTargeting=TRUE

	FireCameraShakeScale=1.f

	Begin Object Class=GearCameraShake Name=MeleeImpactCamShake0
		OscillationDuration=0.5f
		RotOscillation={(Pitch=(Amplitude=500.f,Frequency=100.f),
						Yaw=(Amplitude=500.f,Frequency=100.f),
						Roll=(Amplitude=200.f,Frequency=150.f))}
		LocOscillation={(Y=(Amplitude=3.f,Frequency=10.f),
						Z=(Amplitude=5.f,Frequency=10.f))}
		FOVOscillation=(Amplitude=2.f,Frequency=5.f)
	End Object
	MeleeImpactCamShake=MeleeImpactCamShake0

	bAllowTracers=FALSE
	bCanParryMelee=true
	bAllowMeleeToFracture=TRUE

	// CQC Long Executions
	LongExecutions(0)={(CQC_Long_KillerAnim="CTRL_PunchFace_Start",
						CQC_Long_KillerAnim_Loop="CTRL_PunchFace_Loop",
						CQC_Long_KillerAnim_End="CTRL_PunchFace_End",
						CQC_Long_VictimAnim="DBNO_PunchFace_Start",
						CQC_Long_VictimAnim_Loop="DBNO_PunchFace_Loop",
						CQC_Long_VictimAnim_End="DBNO_PunchFace_End",
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_Start_Cam01', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_Start_Cam02', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_Start_Cam03'),
						CQC_Long_CameraAnims_Loop=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_Loop_Cam01', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_Loop_Cam02', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_Loop_Cam03'),
						CQC_Long_CameraAnims_End=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_End_Cam01', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_End_Cam02', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_PunchFace_End_Cam03'),
						CQC_Long_bHolsterWeapon=TRUE,
						CQC_Long_VictimRotStartTime=0.5f,
						CQC_Long_VictimRotInterpSpeed=8.f,
						CQC_Long_VictimDeathTime=1.f,
						CQC_Long_DamageType=class'GDT_Execution_PunchFace',
						CQC_Long_EffortID=GearEffort_PunchFaceLongExecutionEffort,
						CameraLensEffect_Loop=class'Emit_CameraBlood_PunchSplatter',
						CameraLensEffect_End=class'Emit_CameraBlood_PunchSplatter_End',
						MarkerRelOffset=(X=84.570,Y=27.190,Z=0),
						AwardRequired="",
						TeamIndexRequired=0, //@note: this option will be forced regardless of team if no other options are available
						WeaponSpecial=false)}

	// CQC Long Executions
	LongExecutions(1)={(CQC_Long_KillerAnim="CTRL_ArmRip_Start",
						CQC_Long_KillerAnim_Loop="CTRL_ArmRip_Loop",
						CQC_Long_KillerAnim_End="CTRL_ArmRip_End",
						CQC_Long_VictimAnim="DBNO_ArmRip_Start",
						CQC_Long_VictimAnim_Loop="DBNO_ArmRip_Loop",
						CQC_Long_VictimAnim_End="DBNO_ArmRip_End",
						CQC_Long_bHolsterWeapon=TRUE,
						CQC_Long_VictimDeathTime=5.f,
						CQC_Long_VictimRotStartTime=0.0f,
						CQC_Long_VictimRotInterpSpeed=8.f,
						CQC_Long_CameraAnims=(CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam01_Start', CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam02_Start', CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam03_Start'),
						CQC_Long_CameraAnims_Loop=(CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam01_Loop', CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam02_Loop', CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam03_Loop'),
						CQC_Long_CameraAnims_End=(CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam01_End', CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam02_End', CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam03_End'),
						CQC_Long_DamageType=class'GDT_Execution_Default',
						CQC_Long_EffortID=GearEffort_PunchFaceLongExecutionEffort,
						MarkerRelOffset=(X=84.570,Y=27.190,Z=0.003),
						AwardRequired="",
						TeamIndexRequired=1,
						GoreExecution=true,
						WeaponSpecial=false,
						NonGoreExecutionIndex=0,
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_ArmRip')}// only locust can do

	// CQC Long Executions
	LongExecutions(2)={(CQC_Long_KillerAnim="CTRL_ArmRip_Start",
						CQC_Long_KillerAnim_Loop="CTRL_ArmRip_Alt_Loop",
						CQC_Long_KillerAnim_End="CTRL_ArmRip_Alt_End",
						CQC_Long_VictimAnim="DBNO_ArmRip_Start",
						CQC_Long_VictimAnim_Loop="DBNO_ArmRip_Alt_Loop",
						CQC_Long_VictimAnim_End="DBNO_ArmRip_Alt_End",
						CQC_Long_bHolsterWeapon=TRUE,
						CQC_Long_VictimDeathTime=5.f,
						CQC_Long_VictimRotStartTime=0.0f,
						CQC_Long_VictimRotInterpSpeed=8.f,
						CQC_Long_CameraAnims=(CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam01_Start', CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam02_Start', CameraAnim'Locust_Grunt.DBNO_ArmRip_Cam03_Start'),
						CQC_Long_CameraAnims_Loop=(CameraAnim'Locust_Grunt.DBNO_ArmRip_Alt_Cam01_Loop', CameraAnim'Locust_Grunt.DBNO_ArmRip_Alt_Cam02_Loop', CameraAnim'Locust_Grunt.DBNO_ArmRip_Alt_Cam03_Loop'),
						CQC_Long_CameraAnims_End=(CameraAnim'Locust_Grunt.DBNO_ArmRip_Alt_Cam01_End', CameraAnim'Locust_Grunt.DBNO_ArmRip_Alt_Cam02_End', CameraAnim'Locust_Grunt.DBNO_ArmRip_Alt_Cam03_End'),
						CQC_Long_DamageType=class'GDT_Execution_Default',
						CQC_Long_EffortID=GearEffort_PunchFaceLongExecutionEffort,
						MarkerRelOffset=(X=84.570,Y=27.190,Z=0.003),
						AwardRequired="",
						TeamIndexRequired=1,
						GoreExecution=true,
						NonGoreExecutionIndex=0,
						WeaponSpecial=false,
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_ArmRip')}// only locust can do


	bGotClientHit=true

	//bDebug=TRUE

	BaseCrosshairScale=0.7f

	CogZoomColor=(R=0.1,G=0.286,B=1.1,A=1.0)
	LocustZoomColor=(R=1.1,G=0.286,B=0.1,A=1.0)

	OverheatHUDColor=(R=237, G=28, B=36)

	MeleeWallImpactEffect=ParticleSystem'COG_Assaultrifle.Effects.P_COG_AssaultRifle_Impact_Melee'
	MeleeShieldImpactSound=SoundCue'Weapon_Shield.Shield.ShieldImpactLargeCue'
	ShieldBashDamageType=class'GDT_ShieldBash'
	MeleeKickDamageType=class'GDT_MeleeKick'

	AllowedViewDotHitDir = 0.7f
}
