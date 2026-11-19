/**
 * Nano Weapon Base implementation.
 *
 * This just will have all of the vars that are needed for getting the client server functionality up and running
 * and try to keep that functionality separated from the nano specific functionality.
 *
 * Should make things a lot easier to debug.  And this code should not change that much so we can not have to look at it that
 * much during regular development
 *
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeaponBase extends Weapon
	abstract
	native(Weapon)
	config(Weapon);


struct native AimSpreadBucket
{
	var config vector2d	AimSpread;
	var config vector2d AimSpreadWhileTargeting;
	var config float	TimeTilNextBucket;
	var config vector2d WeaponRecoil;
};
var config array<AimSpreadBucket> AimSpreadBuckets;

var config array<vector2d> AimSpread;
var config float TimeToMaxAimSpread;
var config float TimeToMinAimSpread;
var transient float LastAimSpreadPct;

/** The class of the attachment to spawn */
var class<NanoWeaponAttachment> 	AttachmentClass;

/** Magazine Mesh */
var	StaticMeshComponent	MagazineMesh;

/** Is this weapon a slave weapon (used by remote clients) */
var				bool	bSlaveWeapon;

var bool bAllowTargeting;

/** Crosshair icon */
var Texture2D	CrosshairIcon;


/** activates client side hit detection for instant hit fire */
var bool bClientSideInstantHit;
/** multiplier to hitbox size of an actor the client said it hit that the shot must be within for the server to agree */
var float ClientSideHitLeeway;

/** true if this weapon is being temporarily holstered, false otherwise */
var transient bool bTemporaryHolster;


var() const config	float			WeaponDamage, WeaponDamageAI;

/** Keep track of last firing mode used */
var	byte	PreviousFiringMode;

// if this is on GetPhysicalFireStartLoc will return GetMuzzleLoc
var bool					bUseMuzzleLocForPhysicalFireStartLoc;

/*********************************************************************************************
    FireMode
**********************************************************************************************/

// Fire mode 0 is the default weapon firing.
const DEFAULT_FIREMODE			= 0;
/** arbitrary firemode for reloading */
const RELOAD_FIREMODE			= 1;
/** Firing mode used when doing a melee attack */
const MELEE_ATTACK_FIREMODE		= 2;
/** For weapons that have an alt fire instead of targeting */
const ALTFIRE_FIREMODE			= 3;


/*********************************************************************************************
  Ranges
**********************************************************************************************/

var const config float Range_Melee;
/** if this is non-zero we will roll the dice when inside this range and maybe charge our enemy and melee (useful for chainsaws! )*/
var const config float Range_MeleeCharge;
var const config float Range_Short;
var const config float Range_Medium;
var const config float Range_Long;

/** Interp curve that allows for us to modify the damage of a weapon based on distance to target **/
var() config InterpCurveFloat DamageDistanceMultiplierCurve;


/** Are we zoomed */
enum EZoomState
{
	ZST_NotZoomed,
	ZST_ZoomingOut,
	ZST_ZoomingIn,
	ZST_Zoomed,
};


/*********************************************************************************************
    Ammo
**********************************************************************************************/

/** Ammo used from current magazine */
var	repnotify int		AmmoUsedCount;
/** When reaching this amount, ammo becomes critical (warnings, flashing, beeping, whatever..). */
var()	config		int		CriticalAmmoCount;
/** Spare ammo, contained in extra magazines (outside of what's currently in the weapon) */
var	repnotify		int		SpareAmmoCount;
/** Number of magazines to start with */
var() 		config	int		InitialMagazines;
/** TRUE if weapon can be reloaded */
var() 				bool	bWeaponCanBeReloaded;
/** Number of magazines when this weapon is dropped */
var()       config  int     DropMagazines;

/** duration in seconds of reload sequence */
var		config		float	ReloadDuration;
/** Time this weapon last started a reload */
var 	transient	float	ReloadStartTime;

var() config	int		WeaponMagSize;
var() const config	int	WeaponMaxSpareAmmo;


var()	bool	bInfiniteSpareAmmo;

/** Time between FireNoAmmoSound instances if trigger is held.  0.f for no repeating sound. */
var() const protected float		NoAmmoFireSoundDelay;

/** Can this weapon be selected when it is out of ammo? */
var const bool bCanSelectWithoutAmmo;

/** When this Weapon runs out of ammo, attempt auto-switch to another weapon. */
var protected const bool bAutoSwitchWhenOutOfAmmo;

/** Sound to play when your current clip is nearly empty, as a subtle reminder. */
var protected const SoundCue	NeedReloadNotifySound;
/** Play notify sound when this many rounds remain in the clip */
var() protected int				NeedReloadNotifyThreshold;

/*********************************************************************************************
  Debugging
**********************************************************************************************/

/** true if instigator's bWeaponDebug_Accuracy is true (set when firing) */
var bool		bDebuggingShots;

/** Start location of the last shot I fired.  Used for debug displays in multiplayer */
var repnotify vector DebugShotStartLoc;
/** Aim direction of the last shot I fired.	 Used for debug displays in multiplayer */
var rotator			 DebugShotAimRot;


/*********************************************************************************************
  Weapon Recoil
**********************************************************************************************/

var() const config	vector2d		WeaponAimError;

var() const config	vector2d		WeaponRecoil;

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


/*********************************************************************************************
  Camera Shake
**********************************************************************************************/

/** Screen Shake to play when firing weapon */
var() NanoCameraShake  	FireCameraShake;
/** Scalar used to amplify/dampen firing CamShakes. */
var protected float		FireCameraShakeScale;


/** The controller vibration waveform for when firing this weapon **/
var ForceFeedbackWaveform WeaponFireWaveForm;


/*********************************************************************************************
  Crosshair
**********************************************************************************************/

/** Whether or not the weapon should draw a TargetSelection box **/
var config bool bShouldDrawTargetSelection;


/*********************************************************************************************
  Zooming
**********************************************************************************************/




/*********************************************************************************************
  Sound
**********************************************************************************************/

/** Fire sound to use when this weapon is fired by a local player.  Stereo, non-spatialized. */
var()			SoundCue	FireSound_Player;
/** Fire sound to use when this weapon is fired by everyone else.  Mono and spatialized. */
var()			SoundCue	FireSound;
var()			SoundCue	FireSoundLoop;
var transient AudioComponent AC_FireSoundLoop;

/** Weapon melee hit sound*/
var()			SoundCue	MeleeImpactSound;

/** Weapon fire sound to play when firing and this weapon has no ammo */
var() const		SoundCue	FireNoAmmoSound;


/**
* sound that is played when the bullets go whizzing past your head
*
* @see NanoPC.CheckNearMiss
**/
var() const				SoundCue		WeaponWhipSound;
var() const				float			MinTimeBetweenBulletWhips;
var() const				float			BulletWhipChance;

/** Sound played when local player is reloading weapon, Stereo, non-spatialized */
var() const protected	SoundCue		WeaponReloadSound_Player;
/** Sound played when everyone else is reloading weapon, mono and spatialized */
var() const protected	SoundCue		WeaponReloadSound;

/** Sound played when the player equips the weapon. (e.g. pulling it from his back or holster) **/
var() const protected	SoundCue		WeaponEquipSound;

/** Sound played when the player equips this weapon.  (e.g. stowing it away on his back or in his holster) **/
var() const protected	SoundCue		WeaponDeEquipSound;

/** Sound played when the player drops this weapon. **/
var() const				SoundCue		WeaponDropSound;

/** Sound that is played as the dropped weapon is flying through the air **/
var() const SoundCue SoundToPlayWhileFlyingThroughAirBeforeImpactGround;





/*********************************************************************************************
   Animation
**********************************************************************************************/

// we want to use the Nano2 sims object model to have the animation be on the weapon

/** Animation node used to play custom animations */
var	transient	AnimNodeSlot	CustomAnimNode; // was NanoAnim_Slot
/** Pointer to AnimTree RootNode. */
var	transient	AnimTree		AnimTreeRootNode;

/** Animation to play on weapon */
var() protected Name	WeaponFireAnim;
var() protected Name	WeaponReloadAnim;
var() protected Name	WeaponReloadAnimFail;
var() protected Name	WeaponReloadAnimSuccess;


/*********************************************************************************************
   Muzzle Flash
**********************************************************************************************/

/** Muzzle socket name, to attach effects on */
var()	Name					MuzzleSocketName;
/** Muzzle flash staticmesh, attached to weapon mesh */
var()	MeshComponent			MuzzleFlashMesh;
/** dynamic light */
var()	PointLightComponent		MuzzleFlashLight;
/** Time in seconds the muzzle flashes */
var()				float		MuzzleLightDuration;

var()				bool		bLoopMuzzleFlashLight;
var()				float		MuzzleLightPulseFreq;
var()				float		MuzzleLightPulseExp;
var()				transient float		MuzzleLightPulseTime;

/** offset light is positioned from cannon */
var()				vector		MuzzleLightOffsetFromCannon;
/** Muzzle Flash particle system */
var()	editinline	ParticleSystemComponent		MuzFlashEmitter;
/** Affects how we turn it on/off. */
var()				bool						bMuzFlashEmitterIsLooping;

/** Time after muzzle flash was deactivated to hide particle system */
var					float						TimeToHideMuzzleFlashPS;

/** Muzzle Flash particle system for normal shooting */
var()	editinline	ParticleSystem		MuzFlashParticleSystem;
/** Muzzle Flash particle system for ActiveReload */
var()	editinline	ParticleSystem		MuzFlashParticleSystemActiveReload;

var()	editinline	ParticleSystem		MuzSmokeParticleSystem;


/*********************************************************************************************
  Tracer
**********************************************************************************************/


/** Determines which tracer type to use for this weapon **/
var const protected EWeaponTracerType	TracerType;
/** These are the Distances for when to show tracers **/
var const protected config float		ShowTracerDistance;
/** Controls size of the tracers for this weapon */
var() const protected vector			TracerScale;
/** Effects to use for new tracers.	 Prototype for now, may replace old tracer system later. */
var() const protected ParticleSystem	TracerSmokeTrailEffect;
/** Effects to use for new tracers for active-reload bonus shots.  Prototype for now, may replace old tracer system later. */
var() const protected ParticleSystem	TracerSmokeTrailEffectAR;
/** Percentage chance that any given tracer will have a smoke trail. */
var() const protected config float		TracerSmokeTrailFrequency;



/*********************************************************************************************
   Adhesion Friction
**********************************************************************************************/

//// start of adhesion friction vars

// gears 2 style 

/** Per-weapon scale factor for amount of aim assistance to apply. */
var() float AimAssistScale;
/** Same as AimAssistScale, except this is used while in targeting/zoom mode. */
var() float AimAssistScaleWhileTargeting;

/** When the weapon is zoomed in then the turn speed is reduced by this much **/
var() config float ZoomedTurnSpeedScalePct;

/** Target friction enabled? */
var() config bool bTargetFrictionEnabled;

/** Interp curve that allows for piece wise functions for the TargetFrictionDistance amount at different ranges **/
var() config InterpCurveFloat TargetFrictionDistanceCurve;

/** Min/Max friction multiplier applied when target acquired */
var() config Vector2d TargetFrictionMultiplierRange;

/** Amount of additional radius/height given to target cylinder when at peak distance */
var() config float TargetFrictionPeakRadiusScale;
var() config float TargetFrictionPeakHeightScale;

/** Offset to apply to friction target location (aim for the chest, etc) */
var() config vector TargetFrictionOffset;

/** Boost the Target Friction by this much when zoomed in **/
var() config float TargetFrictionZoomedBoostValue;

var() config bool bTargetAdhesionEnabled;

/** Max time to attempt adhesion to the friction target */
var() config float TargetAdhesionTimeMax;

/** Max distance to allow adhesion to still kick in */
var() config float TargetAdhesionDistanceMax;

/** Max distance from edge of cylinder for adhesion to be valid */
var() config float TargetAdhesionAimDistY;
var() config float TargetAdhesionAimDistZ;

/** Min/Max amount to scale for adhesive purposes */
var() config Vector2d TargetAdhesionScaleRange;

/** Require the target to be moving for adhesion to kick in? */
var() config float TargetAdhesionTargetVelocityMin;

/** Require the player to be moving for adhesion to kick in? */
var() config float TargetAdhesionPlayerVelocityMin;

/** Boost the Target Adhesion by this much when zoomed in **/
var() config float TargetAdhesionZoomedBoostValue;

var const bool bAutoLevelCamera;




//// end of adhesion friction vars


/*********************************************************************************************
  Dummy Fire
**********************************************************************************************/

/** TRUE if this is a weapon meant for dummyfire use. */
var protected bool bDummyFireWeapon;
/** Actor this weapon is attached to, if it's a dummyfire weapon (ignored otherwise) */
var protected Actor DummyFireParent;
/** Location of dummyfire target */
var protected Vector DummyFireTargetLoc;
/** Actor that we were dummy firing at. */
var protected Actor DummyFireTargetActor;


/*********************************************************************************************
 Suppression
**********************************************************************************************/

/** True to spawn tracers on each shot, false for no tracrs. */
var() protected const bool bAllowTracers;

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

/*********************************************************************************************
  Effects
**********************************************************************************************/


/** Used By IsEffectRelevant as the cull distance for whether to spawn this effect or not **/
var config float ImpactRelevanceDistance;
/** Used by SpawnImpactDecal to determine min distance for spawning decals on skeletal meshes */
var config float DecalImpactRelevanceDistanceSkelMesh;

/** The name of the Shell eject socket **/
var name ShellEjectSocketName;

/** Shell case ejection particle system */
var()				ParticleSystemComponent		PSC_ShellEject;
/** After fire smoke effect */
var()				ParticleSystemComponent		PSC_ReloadBarrelSmoke;

/** Number of shots that need to be fired to increase chaos **/
var config int NumShotsToIncreaseChaos;
var transient int ShotsForChaos;


/*********************************************************************************************
  Melee
**********************************************************************************************/

/** FOV to acquire melee targets */
var const config Vector2D MeleeAcquireDotFOV;

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
var() NanoCameraShake MeleeImpactCamShake;

/** True to do camera and controller shakes on melee impact, false to skip them. */
var config bool bDoMeleeDamageShakes;

/** stores the wall being hit in a melee attack, so multiple sounds/effects aren't triggered.*/
var transient bool bHitWallThisAttack;

/**
 * This stores how many times we have attempted to attack with the melee attack.  We are doing a
 * a timed attack so you end up getting "Attacks" on the "return to idle" which is odd when you are
 * triggering a wall impact with it. so we will only trigger on the first k (3-4) and that will be the
 * down swing.
 **/
var transient int NumMeleeAttackAttempts;

/** The time stamp for when we started the melee special attack **/
var float TimeStartedSpecialMeleeAttack;

var ParticleSystem SummonEffect;
var Name SummonEffectSocketName;
var Name SummonAnimName, ThrowAwayAnimName;
var Name DrawWeaponAnim;
var Name HolsterWeaponAnim;
var float TimeToSummonWeapon;
var SoundCue SummonCue, DismissCue, UnholsterCue;

/** If a curve is specified, it will be played the first time the weapon is summoned, for emphasis */
var() InterpCurveFloat  SummonSlomoCurve;

/** This is how much nano power it costs to summon this weapon **/
var config float NanoSummonCost;

//
// Network replication
//

replication
{
	// Things the server should send to local player.
	if ( bNetInitial && bNetOwner )
		InitialMagazines, WeaponMagSize, WeaponMaxSpareAmmo;

	if( bNetOwner )
		AmmoUsedCount, SpareAmmoCount,
		bInfiniteSpareAmmo;

	if( bDebuggingShots && Role==ROLE_Authority )
		DebugShotStartLoc, DebugShotAimRot;
}

/** Check on various replicated data and act accordingly. */
simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent( VarName );

	Switch( VarName )
	{
		case 'DebugShotStartLoc' : DrawDebugShot(DebugShotStartLoc, DebugShotAimRot); break;
		case 'SpareAmmoCount' : AmmoUpdated(); break;
		case 'AmmoUsedCount' : AmmoUpdated(); break;
	}
}


/**
 * Called immediately before gameplay begins.
 */
event PreBeginPlay()
{
	super.PreBeginPlay();
	InitializeAmmo(); // setup starting ammo
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if( Mesh != none )
	{
		//FIXME MIC_WeaponSkin = Mesh.CreateAndSetMaterialInstanceConstant(0);
	}

	// get the color values from the archetype
	if( MuzzleFlashLight != none )
	{
		//FIXME MuzzleFlashLight.SetLightProperties( default.MuzzleFlashLight.Brightness, GetWeaponMuzzleFlashActiveReload() );
	}
}

/** Allow the weapon to do any special tweaks to the trace start location. */
simulated function vector AdjustStartTraceLocation(vector StartLoc, vector AimDir)
{
	return StartLoc;
}


/*********************************************************************************************
* Ammunition
*********************************************************************************************/

/**
* Initializes ammo counts, when weapon is spawned.
*/
function InitializeAmmo()
{
	AddAmmo(InitialMagazines * GetMagazineSize());
	// set the stash values
	NanoPawn(Instigator).GiveAmmo( Class, SpareAmmoCount, TRUE );
}

/** returns the size of the weapon's magazine */
simulated final function int GetMagazineSize()
{
	return WeaponMagSize;
}

/** Sets unlimited magazine size (= disables reloads) */
simulated final function SetInfiniteMagazineSize()
{
	WeaponMagSize = 0;
}

/** returns max amount of spare ammo */
simulated final function int GetMaxSpareAmmoSize()
{
	return WeaponMaxSpareAmmo;
}

/** Sets unlimited amount of spare ammo (= never runs out of ammo, but has to reload weapon */
simulated final function SetInfiniteSpareAmmo()
{
	bInfiniteSpareAmmo = TRUE;
}

/** Returns TRUE is weapon has unlimited spare ammo. */
simulated function bool HasInfiniteSpareAmmo()
{
	return bInfiniteSpareAmmo;
}

/** @return whether our remaining ammo is low (so draw red on HUD, etc) */
simulated function bool IsCriticalAmmoCount()
{
	return (SpareAmmoCount == 0);
}

/** Clears unlimited amount of spare ammo */
simulated final function ClearInfiniteSpareAmmo()
{
	bInfiniteSpareAmmo = default.bInfiniteSpareAmmo;
}

/**
* @see Weapon::ConsumeAmmo
* function also made simulated to ammo consumption is done instantly on client, before waiting for replication.
* this fixes auto reloads not working on a local machine, but lag could had induced other bugs.
* ammo is still replicated, so if it gets out of synch, client would still be corrected.
*/
simulated function ConsumeAmmo( byte FireModeNum )
{
	//local NanoPawn GP;

	if ( WorldInfo.Netmode != NM_Client )
	{
		AmmoUsedCount++;
	}

	// This is the "you are about to run out of ammo" sound better reload! (clickclick)
	if( ( (GetMagazineSize() - AmmoUsedCount) < NeedReloadNotifyThreshold ) && !HasInfiniteSpareAmmo() )
	{
		//FIXME NanoWeaponPlaySoundLocal(NeedReloadNotifySound,, TRUE);
	}
}

simulated function int GetDefaultAmmoAmount()
{
	return GetMagazineSize() * (1 + default.InitialMagazines);
}

simulated function int GetPickupAmmoAmount()
{
	return (GetMagazineSize() - AmmoUsedCount) + SpareAmmoCount;
}

simulated function int CopyAmmoAmountFromWeapon( NanoWeapon InvWeapon )
{
	AmmoUsedCount	= InvWeapon.AmmoUsedCount;
	SpareAmmoCount	= InvWeapon.SpareAmmoCount;

	return SpareAmmoCount + (GetMagazineSize() - AmmoUsedCount);
}

/**
*	Checks if weapon has room to pickup ANY ammo
*	@return		TRUE if ammo will be accepted, FALSE otherwise
*/
simulated function bool CanPickupAmmo()
{
	if( GetMaxSpareAmmoSize() > 0
		&& SpareAmmoCount < GetMaxSpareAmmoSize() )
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
	if( GetMaxSpareAmmoSize() <= 0 )
	{
		return 0;
	}

	MagazineSize		= GetMagazineSize();
	AmmoInCurrentMag	= MagazineSize - AmmoUsedCount;
	AmmoToReload		= AmmoUsedCount;
	OldAmount			= AmmoInCurrentMag + SpareAmmoCount;
	SpareAmmoCount		= SpareAmmoCount + Amount;

	// Take into account ammo that will be reloaded, so we cap to MaxSpareAmmoSize + AmmoToReload
	SpareAmmoCount		= Min(SpareAmmoCount, GetMaxSpareAmmoSize() + AmmoToReload);
	AmountAdded			= (SpareAmmoCount + AmmoInCurrentMag) - OldAmount;
	bForceNetUpdate		= TRUE;

	AmmoUpdated();

	//`log( `showvar(MagazineSize) @ `showvar(AmmoInCurrentMag) @  `showvar(AmmoToReload) @ `showvar(OldAmount) @ `showvar(SpareAmmoCount) @ `showvar(AmountAdded) );

	return AmountAdded;
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
function AddAmmoMessage( int AmountAdded )
{
	local NanoPawn GP;
	local NanoPC PC;

	GP = NanoPawn(Instigator);
	if (GP != None)
	{
		// tell the hud to draw the ammo addition
		PC = NanoPC(GP.Controller);
		if ( PC != None )
		{
			//FIXME PC.ClientAddAmmoMessage(DamageTypeClassForUI, AmountAdded);
		}
	}
}


/** Returns true if spare ammo is available (outside of current magazine) */
simulated function bool HasSpareAmmo()
{
	return( HasInfiniteSpareAmmo() ||	// unlimited extra ammo
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
	MagazineSize = GetMagazineSize();

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
	return (HasAmmo(0) || HasSpareAmmo());
}


/*********************************************************************************************
*  Animation
*********************************************************************************************/


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
			`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "NanoWeapon::PlayWeaponAnim - no animations :( Trying to play:" @ AnimName);
			return 0.f;
		}

		// Set right animation sequence if needed
		if( AnimNode.AnimSeq == None || AnimNode.AnimSeq.SequenceName != AnimName )
		{
			AnimNode.SetAnim(AnimName);
		}

		if( AnimNode.AnimSeq == None )
		{
			// TODO:  turn back on eventually.  Right now this just spams all the time
			//`log("NanoWeapon::PlayWeaponAnim - AnimSeq == None" @ Self @ "Instigator:" @ Instigator );
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
	//local NanoPawn	GPOwner;
	local NanoPC	PCOwner;

	// If melee is finished, send weapon to neutral state (remote clients)
	// and fire up MeleeAttackEnded() notification.
	if( bViaReplication && PreviousFiringMode == MELEE_ATTACK_FIREMODE )
	{
		MeleeAttackEnded();
	}

	// Handle reload aborts here.
	// If previous firing mode is for a reload
	bPrevIsReload = PreviousFiringMode == RELOAD_FIREMODE;

	// If new firing mode is for a reload
	bNewIsReload = FiringMode == RELOAD_FIREMODE;

	if( bPrevIsReload && !bNewIsReload )
	{
		// If weapon reload was aborted, then abort it...
		if( IsTimerActive(nameof(EndOfReloadTimer)) )
		{
			AbortWeaponReload();
		}

		// Update Heavy weapon mouting status if needed
		PCOwner = NanoPC(Instigator.Controller);
		if( PCOwner != None && PCOwner.IsLocalPlayerController() )
		{
			// First need to update Targeting status, to see if player is still targeting or not
			// This gets set to FALSE when reloading weapons
			//FIXME PCOwner.UpdateTargetingStatus();

		}
	}

	// if we're reloading our weapon, play anim
	switch( FiringMode )
	{
	case RELOAD_FIREMODE					: PlayWeaponReloading();	break;
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
* Play weapon reloading effects.
* Called when weapon enters reloading state.
* Network: ALL
*/
simulated function PlayWeaponReloading()
{
	local NanoPawn	GP;  // FIXME: should be NanoPawnBase
	local Pawn		P;
	local float		ReloadTime;

	GP = NanoPawn(Instigator);
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
		SetTimer( ReloadDuration, FALSE, nameof(EndOfReloadTimer) );
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
		Instigator.PlaySound( (NanoPC(Instigator.Controller) != None) ? WeaponReloadSound_Player : WeaponReloadSound, true);
	}

	// @todo:  prob make this check to see that you have fired a number of bullets in a row (i.e. the muzzle has heated up)
	// turn on after fire smoke effect
	if( PSC_ReloadBarrelSmoke != None && (WorldInfo.NetMode != NM_DedicatedServer) )
	{
		if( GP == None || `TimeSince(GP.LastWeaponEndFireTime) < 2.f )
		{
			ClearTimer( 'PSC_ReloadBarrelSmoke' );
			PSC_ReloadBarrelSmoke.SetHidden( FALSE );
			PSC_ReloadBarrelSmoke.ActivateSystem();
			SetTimer( 3.0f, FALSE, nameof(HidePSC_ReloadBarrelSmoke) );
		}
	}
}


simulated function float PlayPawnReloadingAnimation(NanoPawn NP)
{
	local float ReloadAnimTime;
	//local INT	i;
	//local ParticleSystemComponent PSC_ReloadEffect;

	local NanoPRI NPRI;
	local class<NanoChasisModifier> WeaponMod;
	local int ModLvl;
	local float PercentFaster;


	if( WeaponReloadAnim != '' )
	{
		// so here we need to ask the pawn's weapon if it has any WeaponMods to help make it reload faster
		PercentFaster = 1.25f;
		NPRI = NanoPRI(NP.Controller.PlayerReplicationInfo);
		if( NPRI != None )
		{
			WeaponMod = NPRI.GetChasisModClass( NP.MyNanoWeapon.Class, ModLvl );
			if( ( WeaponMod != None ) && ( ModLvl > -1 ) )
			{
			   PercentFaster = ( 1.0f + WeaponMod.static.GetPercentFasterReload( ModLvl ) );
			}
		}

		if( NP.PreAimFullBodySlot != none )
		{
			ReloadAnimTime = NP.TopHalfSlot.PlayCustomAnim( WeaponReloadAnim, PercentFaster, 0.1, 0.1, FALSE, TRUE );
		}
    
		// hack here
		//if( (NP.Mesh.GetSocketByName( 'HandForge' ) != None) && (WorldInfo.NetMode != NM_DedicatedServer) )
		//{
		//	PSC_ReloadEffect = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'Nano_FX.Effects.P_Nano_SMG_Spawn_Clip', NP.Mesh, 'HandForge', TRUE );
	//		PSC_ReloadEffect.ActivateSystem();
	//	}
	}

	//`log( "ReloadAnimTimeReloadAnimTimeReloadAnimTimeReloadAnimTimeReloadAnimTime" @ ReloadAnimTime );

// 	// Make sure Group starts from begining.
// 	NP.AnimTreeRootNode.ForceGroupRelativePosition('WeaponReload', 0.f);
// 	ReloadAnimTime = GP.BS_Play(BS_PawnWeaponReload, 1.f, 0.25f, 0.33f, FALSE, TRUE, 'WeaponReload');
// 	NP.BS_SetEarlyAnimEndNotify(BS_PawnWeaponReload, FALSE);
// 
// 	// uh oh problem
// 	if( ReloadAnimTime == 0.f || !GP.BS_IsPlaying(BS_PawnWeaponReload) )
// 	{
// 		`DLog("Failed to play reload animation for" @ GP @ "ReloadAnimTime:" @ ReloadAnimTime @ "IsPlaying?" @ NP.BS_IsPlaying(BS_PawnWeaponReload) @ "AnimTree:" @ NP.Mesh.Animations @ "Template:" @ NP.Mesh.AnimTreeTemplate @ "FullBodyNode:" @ NP.FullBodyNode);
// 		for(i=0; i<BS_PawnWeaponReload.AnimName.Length; i++)
// 		{
// 			if( BS_PawnWeaponReload.AnimName[i] != '' )
// 			{
// 				`Log(" ["$i$"]" @ BS_PawnWeaponReload.AnimName[i] @ NP.BodyStanceNodes[i]);
// 			}
// 		}
// 	}

	return ReloadAnimTime;
}





/** Performs actual ammo reloading */
simulated function PerformReload()
{
	local float	Amount;

	// reload weapon here
	if( HasInfiniteSpareAmmo() )
	{
		AmmoUsedCount = 0;
	}
	else if( GetMaxSpareAmmoSize() > 0 && SpareAmmoCount > 0 )
	{
		Amount			= SpareAmmoCount - FMax(SpareAmmoCount - AmmoUsedCount, 0);
		AmmoUsedCount	= AmmoUsedCount - Amount;
		SpareAmmoCount	= SpareAmmoCount - Amount;
	}
	// right now some config values are not being read in correctly.
	// so if we ever get a MaxSpareAmmoSize of 0 we just reload it
	// this is what is occurring with grenades atm
	else if( GetMaxSpareAmmoSize() == 0 )
	{
		`log( "something terrible has gone wrong with the config loading of MaxSpareAmmo " );

		Amount			= SpareAmmoCount - FMax(SpareAmmoCount - AmmoUsedCount, 0);
		AmmoUsedCount	= AmmoUsedCount - Amount;
		SpareAmmoCount	= SpareAmmoCount - Amount;
	}
}

/** Whether or not we're currently reloading */
simulated function bool IsReloading()
{
	return IsTimerActive(nameof(EndOfReloadTimer));
}

/**
* Function called to abort weapon reload.
* Can be called when starting a SpecialMove, in that case it is called on all clients.
* Animation is stopped before special moves starts.
* Reloading State also sends the weapon to the active state.
*/
simulated function AbortWeaponReload()
{
// 	if( (CurrentFireMode == FIREMODE_ACTIVERELOADSUPERSUCCESS) || (CurrentFireMode == FIREMODE_ACTIVERELOADSUCCESS) )
// 	{
// 		// we've successfully hit an AR and are in the process of finishing it up.
// 		// in this case, we will still award the ammo
// 		PerformReload();
// 	}

	// Clear reload timer.
	ClearTimer( nameof(EndOfReloadTimer) );

	// End reload animations
	EndReloadAnimations();
}


/** needed to be visible at the NanoWeapon scope.  Only ever used in state Reloading **/
simulated function EndOfReloadTimer()
{
	// End reload animations.
	EndReloadAnimations();
}

/** End Reload Animations */
simulated function EndReloadAnimations()
{
	local NanoPawn	NP;

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

	NP = NanoPawn(Instigator);
	if( NP == None )
	{
		return;
	}

	if( NP.PreAimFullBodySlot != None )
	{
		NP.PreAimFullBodySlot.StopCustomAnim( 0.1 );
	}
}



/**
 * Show or Hide weapon ammo bone.
 * Done by using a bone scaling controller.
 */
simulated function SetWeaponAmmoBoneDisplay(bool bShow, optional Name InControlName)
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
simulated function SetPawnAmmoAttachment(bool bAttach, optional StaticMeshComponent InMagazineMesh, optional Name InBoneName, optional Rotator InRelativeRotation)
{
	local SkeletalMeshSocket	Socket;
	//local Vector				NewScale3D;

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
		InMagazineMesh.SetLightEnvironment(NanoPawnBase(Instigator).LightEnvironment);

		if( InBoneName != '' )
		{
			Instigator.Mesh.AttachComponent(InMagazineMesh, InBoneName,, InRelativeRotation);
		}
		else
		{
			Socket = Instigator.Mesh.GetSocketByName(NanoPawnBase(Instigator).GetCurrHandSocketName());
			Instigator.Mesh.AttachComponent(InMagazineMesh, Socket.BoneName, Socket.RelativeLocation, Socket.RelativeRotation + InRelativeRotation, Socket.RelativeScale);
		}

		// Mirror weapon
	//	if( ShouldWeaponBeMirrored(NanoPawnBase(Instigator)) )
	//	{
	//		NewScale3D = InMagazineMesh.default.Scale3D;
	//		NewScale3D.Y = -NewScale3D.Y;
	//		InMagazineMesh.SetScale3D( NewScale3D );
	//	}
	//	else
	//	{
			InMagazineMesh.SetScale3D(InMagazineMesh.default.Scale3D);
	//	}
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
simulated function GameKActorSpawnableEffect SpawnPhysicsMagazine(Vector SpawnLoc, Rotator SpawnRot)
{
	local GameKActorSpawnableEffect	MagActor;
	local Vector			X, Y, Z;

	if ( MagazineMesh == None 
		|| Instigator == None 
		|| !NanoGRI(WorldInfo.GRI).IsEffectRelevant(Instigator, SpawnLoc, 1024.0f, FALSE, NanoGRI(WorldInfo.GRI).CheckEffectDistance_SpawnWithinCullDistanceAndInFront)
		)
	{
		return None;
	}

	MagActor = Spawn(class'GameKActorSpawnableEffect',,, SpawnLoc, SpawnRot);

	if( MagActor != None )
	{
		MagActor.StaticMeshComponent.SetRBCollidesWithChannel(RBCC_Pawn, false);
		MagActor.StaticMeshComponent.SetStaticMesh(MagazineMesh.StaticMesh);
		MagActor.StaticMeshComponent.SetPhysMaterialOverride(PhysicalMaterial'WeaponPhysics.Physmats.WeaponPhysMat');
		MagActor.StaticMeshComponent.SetNotifyRigidBodyCollision(true);
		MagActor.SetPhysicalCollisionProperties();
		MagActor.StaticMeshComponent.WakeRigidBody();
		// Add a small impulse to have the clip slightly spinning
		GetAxes(Instigator.Rotation, X, Y, Z);
		MagActor.ApplyImpulse( vect(0,0,-1), 5.0f + (2.0f * FRand()), MagActor.Location);

		// turn off updating the DLE after a second
		MagActor.SetTimer( 1.0f, FALSE, nameof(MagActor.SetLightEnvironmentToNotBeDynamic) );
	}

	return MagActor;
}


/**
* Called by Pawn when FlashCount has been updated.
* FlashCount > 0 denotes that weapon has fired.
* FlashCount == 0 denotes that weapon stopped firing.
* Network: ALL
*/
simulated function FlashCountUpdated( byte FlashCount, byte FiringMode, bool bViaReplication )
{
	if( FlashCount > 0 )
	{
		WeaponFired( FiringMode );
	}
	else
	{
		WeaponStoppedFiring( FiringMode );
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
* Changed this function for warfare's weapon system.
* WeaponFired() is called instantly on local clients, so there is no delay playing weapon firing effects.
* remote clients do everything when FlashLocation is replicated.
*
* Network: LocalPlayer and Server.
*/
simulated function InstantFire()
{
	local NanoPawn	InstigatorNP;
	local vector			StartTrace, EndTrace;
	local Array<ImpactInfo>	ImpactList;
	local int				Idx;
	local ImpactInfo		RealImpact;
`if(`notdefined(FINAL_RELEASE))
	local color             DebugLineColor;
`endif

	InstigatorNP = NanoPawn(Instigator);

	if( Role == ROLE_Authority && (InstigatorNP != None) )
	{
		if( ++ShotsForChaos > NumShotsToIncreaseChaos )
		{
			NanoGRI(WorldInfo.GRI).ModifyChaosLevel( InstigatorNP.GetChaosZone(), self, class'NanoCausingChaosValues'.default.Shooting );
			ShotsForChaos = 0; // reset
		}

		InstigatorNP.CauseCrowdPanic();
	}

	if (Instigator != None)
	{
		Instigator.TriggerEventClass(class'SeqEvt_NanoActionPerformed', Instigator, 15);
	}

	// Servers proceed as normal
	if (WorldInfo.Netmode != NM_Client || (bClientSideInstantHit && Instigator != None && Instigator.IsLocallyControlled()))
	{
		// If InteractionPawn is Based on PawnOwner, then disable his collision when firing.
		// This is to prevent kidnapper from firing through the hostage
		if( InstigatorNP != None && InstigatorNP.InteractionPawn != None && InstigatorNP.InteractionPawn.IsBasedOn(InstigatorNP) )
		{
			InstigatorNP.InteractionPawn.Mesh.SetTraceBlocking(FALSE, InstigatorNP.InteractionPawn.Mesh.BlockNonZeroExtent);
		}

		// define range to use for CalcWeaponFire()
		StartTrace = Instigator.GetWeaponStartTraceLocation();
		EndTrace = StartTrace + vector(GetAdjustedAim(StartTrace)) * GetTraceRange();

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
		if( InstigatorNP != None && InstigatorNP.InteractionPawn != None && InstigatorNP.InteractionPawn.IsBasedOn(InstigatorNP) )
		{
			InstigatorNP.InteractionPawn.Mesh.SetTraceBlocking(TRUE, InstigatorNP.InteractionPawn.Mesh.BlockNonZeroExtent);
		}

		`if(`notdefined(FINAL_RELEASE))
			if( InstigatorNP != None )
			{
				bDebuggingShots = InstigatorNP.bWeaponDebug_Accuracy;
				if( bDebuggingShots )
				{
					//ClientFlushPersistentDebugLines();

					DebugLineColor = (RealImpact.HitActor == None || RealImpact.HitActor.bWorldGeometry) ? MakeColor(64,64,255) : MakeColor(255,64,64);
					DrawDebugLine(StartTrace, RealImpact.HitLocation, DebugLineColor.R, DebugLineColor.G, DebugLineColor.B, true);

					//DebugShotStartLoc = Instigator.GetWeaponStartTraceLocation();
					//DebugShotAimRot = GetAdjustedAim(DebugShotStartLoc);
					//DrawDebugShot(DebugShotStartLoc, DebugShotAimRot);

					//DrawDebugLine( DebugShotStartLoc+vect(0,0,5), DebugShotStartLoc + vector(DebugShotAimRot) * Range_Melee, 255, 1, 1, true );
					//DrawDebugLine( DebugShotStartLoc+vect(0,0,5), DebugShotStartLoc + vector(DebugShotAimRot) * Range_Short, 255, 255, 1, true );
					//DrawDebugLine( DebugShotStartLoc+vect(0,0,10), DebugShotStartLoc + vector(DebugShotAimRot) * Range_Medium, 1, 255, 1, true );
					//DrawDebugLine( DebugShotStartLoc+vect(0,0,15), DebugShotStartLoc + vector(DebugShotAimRot) * Range_Long, 1, 1, 255, true );
				}
			}
			`endif
	}
	else if( Instigator != None && Instigator.IsLocallyControlled() )
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
	if( Instigator != None )
	{
		if( WorldInfo.Netmode != NM_Client )
		{
			Instigator.ClearFlashLocation( Self );
		}
		else if( Instigator.IsLocallyControlled() )
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

simulated function FlashLocationUpdated( byte FiringMode, vector FlashLocation, bool bViaReplication )
{
	local bool		bValidFiringUpdate;

	// ignore FlashLocation replication if using client side hit location
	//@FIXME: should change Pawn to not send it
	if (bViaReplication && bClientSideInstantHit && Instigator != None && Instigator.IsLocallyControlled())
	{
		return;
	}

	// valid firing update (impact location) if FlashLocation is non zero.
	// Zero is used to denote a weapon stopping to fire.
	bValidFiringUpdate = !IsZero(FlashLocation);

	// we cannot post process any impact while reloading, FiringMode was lost.
	if( FiringMode == RELOAD_FIREMODE )
	{
		`LogInv( `location @ " FiringMode is same as reload firemode:" @ RELOAD_FIREMODE @ "Abort and don't trigger a firing update." @ self @ Instigator );
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
			// stop the current fire mode in this case, rather than the passed in version
			WeaponStoppedFiring( CurrentFireMode /*FiringMode*/ );
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
	if (Instigator != None)
	{
		Instigator.WeaponFired(Self, FALSE, HitLocation);
	}
	PlayFireEffects(FiringMode, HitLocation);
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
	if (Instigator != None)
	{
		Instigator.WeaponStoppedFiring(Self, FALSE);
	}
	StopFireEffects(FiringMode);
	// turn off shell eject particle system
	if( PSC_ShellEject != None )
	{
		PSC_ShellEject.DeActivateSystem();
		//FIXME SetTimer( 1.0f, FALSE, nameof(HidePSC_ShellEject) );
	}
}

/** this is used for client side hit detection */
reliable server function ServerNotifyHit(byte FiringMode, ImpactInfo Impact, bool bHitShield)
{
	//local NanoPawn GP;
	local Box HitBox;
	local vector BoxExtent, BoxCenter;

	// if HitActor didn't replicate it, try to get it from the hit component
	// this most commonly happens when hitting StaticMeshCollectionActors, as they are created by the cooker and so don't replicate
	if (Impact.HitActor == None && Impact.HitInfo.HitComponent != None)
	{
		Impact.HitActor = Impact.HitInfo.HitComponent.Owner;
	}

	// validate the shot
	// check that we're actually using this fire mode
	// and we're facing in that general direction
	if ( bClientSideInstantHit && Role == ROLE_Authority && Instigator != None && Impact.HitActor != None &&
		IsFiring() && CurrentFireMode == FiringMode &&
		vector(Instigator.GetViewRotation()) dot Normal(Impact.HitLocation - Instigator.GetWeaponStartTraceLocation()) > 0.7 ) // ~45 degrees
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
			// if we're in co-op, allow as long as it's in the ballpark
			if (NanoGameSP_Base(WorldInfo.Game) != None)
			{
				BoxExtent *= 3.0;
			}
			BoxCenter = (HitBox.Min + HitBox.Max) * 0.5;
			if ( Abs(Impact.HitLocation.Z - BoxCenter.Z) < BoxExtent.Z &&
				Abs(Impact.HitLocation.X - BoxCenter.X) < BoxExtent.X &&
				Abs(Impact.HitLocation.Y - BoxCenter.Y) < BoxExtent.Y )
			{
				if (bHitShield)
				{
					//GP = NanoPawn(Impact.HitActor);
// 					if (GP.EquippedShield != None && GP.EquippedShield.Mesh != None)
// 					{
// 						Impact.HitInfo.HitComponent = GP.EquippedShield.Mesh;
// 					}
				}
				ProcessInstantHit_Internal(FiringMode, Impact);
			}
		}
	}
}

/*
* Process Instant Hit is called to process a Hit.
* It can be called from InstantFire() (LocalPlayer and Server) or CalcRemoteImpactEffects() (remote clients).
* Using that same path for server/local/remote is specific to warfare.
*/
simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	//local NanoPawn GP;

	if (bClientSideInstantHit && Instigator != None && Instigator.Controller != None)
	{
		if (Instigator.IsLocallyControlled())
		{
			if (WorldInfo.NetMode == NM_Client && Impact.HitActor != None && Impact.HitActor.Role < ROLE_Authority)
			{
				//GP = NanoPawn(Impact.HitActor);
				//ServerNotifyHit(FiringMode, Impact, GP != None && GP.ComponentIsAnEquippedShield(Impact.HitInfo.HitComponent));
				ServerNotifyHit(FiringMode, Impact, FALSE);
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

	ProcessInstantHit_Internal(FiringMode, Impact);
}

simulated function bool ShouldRegisterDamage( Actor A )
{
	local NanoPawn HitPawn;

	if( A != None && !bSuppressDamage )
	{
		if( WorldInfo.NetMode != NM_Client )
		{
			return TRUE;
		}

		HitPawn = NanoPawn(A);
		if( HitPawn != None && HitPawn.bTearOff )
		{
			return TRUE;
		}

		// Acceptable client side hit actors
		if( FracturedStaticMeshActor(A) != None ||
			//Hydra_Base(A)				!= None ||
			FluidSurfaceActor(A)		!= None ||
			CrowdAgentBase(A)			!= None )
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
	//local NanoPawn			GP, HitPawn;
	local NanoPC			NanoPC;
	local class<DamageType> DamageTypeToUse;
	//local NanoAI			AI;
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;
	local Actor ImpactActor;

	ImpactActor = Impact.HitActor;
	if( ( ImpactActor != None ) && ( ImpactActor.bWorldGeometry ) )
	{
		HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
		if ( (HitStaticMesh != None) && HitStaticMesh.CanBecomeDynamic() )
		{
			NewKActor = class'KActorFromStatic'.Static.MakeDynamic(HitStaticMesh);
			if ( NewKActor != None )
			{
				ImpactActor = NewKActor;
			}
		}
	}

	//GP = NanoPawn(Instigator);
	//HitPawn = NanoPawn(ImpactActor);

	//debug
	`LogInv( self@GetFuncName()@FiringMode@ImpactActor@Impact.HitInfo.HitComponent, bDebug );

	//`log(GetFuncName()@HitPawn@HitPawn.Health@HitPawn.bTearOff@GP);
	// substitute the active reload damage type if applicable


	// otherwise use the default corresponding to our fire mode
	DamageTypeToUse = InstantHitDamageTypes[FiringMode];


	// if we hit something on the server, then deal damage to it.
	// We also accept dead pawns (torn off) on clients for local impacts and rag doll fun
	if( ShouldRegisterDamage( ImpactActor ) )
	{
		ImpactActor.TakeDamage(	GetFireModeDamage( Impact.HitLocation, ImpactActor ),
			(Instigator != None ? Instigator.Controller : None),
			Impact.HitLocation,
			InstantHitMomentum[FiringMode] * (Instigator != None ? Normal(Impact.HitLocation - Instigator.Location) : Impact.RayDir), //Impact.RayDir, // @fixme: This is not correct. RayDir is from crosshair. should probably fix to be Normal(ImpactLoc - GunBarrel)
			DamageTypeToUse,
			Impact.HitInfo,
			self );
	}

	// Skip impacts for triggers and trigger volumes. We just want to forward damage to these, nothing else.
	if( Trigger(ImpactActor) != None
		|| TriggerVolume(ImpactActor) != None
		//|| GrenadeBlockingVolume(ImpactActor) != None
		)
	{
		return;
	}

	// notify nearby players of a miss. This assumes currently one impact point. If we end up having several (reflection, penetration) we have to revise this.
	if( WorldInfo.Netmode != NM_Client )
	{
		// if we didn't hit a player
		if (Instigator != None && Instigator.Controller != None)
		{
			// notify any nearby players of the near miss
			foreach WorldInfo.AllControllers(class'Controller', CheckPlayer)
			{
				if( NanoPawn(CheckPlayer.Pawn) == None || CheckPlayer.Pawn == Instigator || WorldInfo.GRI.OnSameTeam(Instigator, CheckPlayer.Pawn) )
				{
					continue;
				}

				NanoPC = NanoPC(CheckPlayer);
				if( NanoPC != None )
				{
					NanoPC.CheckNearMiss(Instigator, Self, Impact, DamageTypeToUse);
				}
// 				else
// 				{
// 					AI = NanoAI(CheckPlayer);
// 					if( AI != None )
// 					{
// 						AI.CheckNearMiss(Instigator, Self, Impact, DamageTypeToUse);
// 					}
// 				}
			}
		}
	}

	// if a visual client, is relevant, hit something, and didn't hit a player (FX handled via TakeDamage->DoDamageEffects)
	if( WorldInfo.NetMode != NM_DedicatedServer
		// NOTE: we are not checking his here atm as our sword swings often miss and that is how we are handling playing effects for misses and hits && Impact.HitActor != None
		//&& ( HitPawn == None || HitPawn.ComponentIsAnEquippedShield(Impact.HitInfo.HitComponent) )
		)
	{
		SpawnImpactFX(class<NanoDamageType>(DamageTypeToUse),Impact,FALSE,FALSE,FALSE);
	}
}

/**
* Kicks off sound/particles/decals based on an ImpactInfo struct, called on all visual clients either simulated locally or
* replicated through NanoPawn.ReplicatedPlayTakeHitEffects().
*/
simulated function SpawnImpactFX(const class<NanoDamageType> NanoDmgType, const out ImpactInfo Impact, bool bFatalShot, bool bMeleeHit, bool bPlayExplosiveRadialDamageEffects)
{
	local PhysicalMaterial PhysMaterial;
	local NanoPawn GP;
	local NanoGRI GRI;


	// we probably want to also move up the FrameRate Dependent checking to here instead of calling the function and then just returning nothing
	// so it is really this:
	// if the framerate allows us to spawn effect<type> then we need to go and look and see if it is relevant to us
	// (for all relevant effects we have to check framerate shizzle so might as ALWAYS just have a Framerate check cost
	// before doing the more expensive relevancy checks / or going through and trying to spawn stuff
	//

	if( NanoDmgType.default.bSuppressImpactFX == FALSE )
	{
		// grab the physical material to get things rolling
		PhysMaterial = class'NanoPhysicalMaterialProperty'.static.GetImpactPhysicalMaterial(Impact);

		GRI = NanoGRI(WorldInfo.GRI);
		GP = NanoPawn(Impact.HitActor);
		//`log( "SpawnImpactFX" @ self );
		// only Spawn impact effects if the Pawn has not been dead for too long
		if( ( GP == None)
			//FIXME//|| ( ( WorldInfo.TimeSeconds - GP.TimeOfDeath < 20.0f )
			|| (!GP.bTearOff) //)
			)
		{
			if( GRI.IsEffectRelevant( Instigator, Impact.HitLocation, 4000, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront ) )
			{
				// play the impact effect(s)
				SpawnImpactEffects( NanoDmgType, Impact, PhysMaterial, bFatalShot, bMeleeHit, bPlayExplosiveRadialDamageEffects );
				//`log( " SpawnImpactEffects" @ self );
			}
		}

		// only Spawn impact decals if the Pawn has not been dead for too long
		if( ( GP == None)
			//FIXME//|| ( ( WorldInfo.TimeSeconds - GP.TimeOfDeath < 5.0f )
			|| (!GP.bTearOff) //)
			)
		{
			if( GRI.IsEffectRelevant( Instigator, Impact.HitLocation, 4000, FALSE, GRI.CheckEffectDistance_SpawnBehindIfNear ) )
			{
				// leave a decal
				SpawnImpactDecal( NanoDmgType, Impact, PhysMaterial );
				//`log( " SpawnImpactDecal" );
			}
		}

		// how far can you hear impact effects from weapons?  Explosions are different  (According to the soundcue up to 6000 units!)
		if( GRI.IsEffectRelevant( Instigator, Impact.HitLocation, 3000, FALSE, GRI.CheckEffectDistance_SpawnWithinCullDistance ) )
		{
			// play an impact sound
			SpawnImpactSounds( NanoDmgType, Impact, PhysMaterial );
			//`log( " SpawnImpactSounds" );
		}
	}
}

/**
* This will spawn a PhysicalMaterial based effect.	 It looks up the PhysicalMaterial
* tree until it finds a valid effect to Spawn.	 If it does not find one then
* it defaults the effect coded in to the .uc file for that specific weapon
*/
simulated function SpawnImpactDecal(const class<NanoDamageType> NanoDmgType, const out ImpactInfo Impact, PhysicalMaterial PhysMaterial)
{
	local DecalData DecalData;
	local NanoPawn GP;
	local SkeletalMeshComponent SkelMeshHitComponent;

	GP = NanoPawn(Impact.HitActor);

	// if we are NOT a head bone then we can leave a decal
	if( ( GP == None) || ( GP.TookHeadShot(Impact.HitInfo.BoneName, Impact.HitLocation, Impact.RayDir) == FALSE ) )
	{
		SkelMeshHitComponent = SkeletalMeshComponent(Impact.HitInfo.HitComponent);
		if( (SkelMeshHitComponent == None)
			|| ( (SkelMeshHitComponent != None) && (Instigator != None) && (VSize(Impact.HitLocation - Instigator.Location) < DecalImpactRelevanceDistanceSkelMesh) )
			&& ( ClassIsChildOf( NanoDmgType, class'NDT_Explosive' ) == FALSE )
			)
		{
			//`LogExt("Instigator:"@Instigator@"PhysMaterial:"@PhysMaterial@"HitActor:"@Impact.HitActor);
			DecalData = class'NanoPhysicalMaterialProperty'.static.DetermineImpactDecalData( PhysMaterial, NanoDmgType, NanoPawn(Instigator) != None ? NanoPawn(Instigator).bActiveReloadBonusActive : FALSE, WorldInfo, Instigator );

			//`log( "SpawnImpactDecal PhysMaterial: " $ PhysMaterial @ DecalData.DecalMaterial );
			// HACK DECALS
			DecalData.DecalMaterial = MaterialInterface'Nano_WeaponFX.GEN.Materials.M_BulletHole_01_Decal';
			DecalData.bIsValid = TRUE;

			// create the actual decal
			if( DecalData.bIsValid )
			{
				class'NanoDecal'.static.StaticAttachFromImpact( class'NanoDecal_WeaponImpact', NanoPawn(Instigator), Impact, DecalData );
			}
		}

		// so now check to see if we hit a pawn and need to do a exit wound splatter decal (50% of the time)
		if( ( Frand() < 0.50f ) && ( GP != None )
			//FIXME//&& GP.bSpawnHitEffectDecals
			)
		{
			//`LogExt("Instigator:"@Instigator@"PhysMaterial:"@PhysMaterial@"HitActor:"@Impact.HitActor);
			DecalData = class'NanoPhysicalMaterialProperty'.static.GetBloodDecalData( class'NanoPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Impact.HitInfo ), NDTT_ExitWoundSplatter, WorldInfo );

			//`log( "SpawnImpactDecal PhysMaterial: " $ PhysMaterial @ DecalData.DecalMaterial @ DecalData.bIsValid );

			// create the actual decal
			if( DecalData.bIsValid )
			{
				class'NanoDecal'.static.StaticAttachToSurface( class'NanoDecal_WeaponImpact', NanoPawn(Instigator), Impact.HitLocation, Impact.RayDir, 128.0f, Impact, DecalData );
			}
		}
	}
}

simulated function ParticleSystemComponent GetImpactParticleSystemComponent( ParticleSystem PS_Type )
{
	return NanoGRI(WorldInfo.GRI).NOP.GetImpactParticleSystemComponent( PS_Type );
}


simulated function Emitter GetImpactEmitter( ParticleSystem PS_Type, vector SpawnLocation, rotator SpawnRotation )
{
	return NanoGRI(WorldInfo.GRI).NOP.GetImpactEmitter( PS_Type, SpawnLocation, SpawnRotation );

}


simulated function SpawnImpactEffects(const class<NanoDamageType> NanoDmgType, ImpactInfo Impact, PhysicalMaterial PhysMaterial, bool bWasFatalShot, bool bWasMeleeAttack, bool bPlayExplosiveRadialDamageEffects )
{
	local SkeletalMeshComponent SMC;
	local vector DirectionToSprayParticles, BoneRelativeLocation;
	local rotator BoneRelativeRotation;
	local NanoPawn HitPawn;
	local ParticleSystem ImpactPS;
	local ParticleSystemComponent ImpactPSC;
	local Emitter ImpactEmitter;
	local name AttachToBoneName;

	local vector HitLocation, HitNormal;
	local vector ExitWoundStart,ExitWoundEnd;

	//`Log("Hit:"@Impact.HitActor@"HitComp"@Impact.HitInfo.HitComponent@"Fatal:"@bWasFatalShot@"Melee:"@bWasMeleeAttack@"PhysMat:"@PhysMaterial@NanoDmgType@NanoDmgType.default.bSuppressImpactFX);

	// abort early if FX are turned off (dummy fire)
	if( bSuppressImpactFX || NanoDmgType.default.bSuppressImpactFX )
	{
		return;
	}

	// check to see if we're dealing with a pawn
	HitPawn = NanoPawn(Impact.HitActor);

	// if it's a fatal shot,we will spawn GoreExplosion blood there!

	// if it's a melee hit,
	if (bWasMeleeAttack)
	{
		if( WorldInfo.GRI.ShouldShowGore() && HitPawn != None )
		{
			//FIXME ImpactPS = HitPawn.PS_MeleeImpactEffect;
		}
		// we don't show any impact effects atm for melee hits when extreme content is off
		else
		{
			return;
		}
	}
	else if( bPlayExplosiveRadialDamageEffects )
	{
		if( WorldInfo.GRI.ShouldShowGore() )
		{
			//FIXME //ImpactPS = HitPawn.PS_RadialDamageEffect;
		}
		// we don't show any impact effects atm for melee hits when extreme content is off
		else
		{
			return;
		}
	}
	else
		// check for a pawn override
		/*
		if (HitPawn != None
			//FIXME //&& HitPawn.HasImpactOverride()
			)
		{
			//FIXME ImpactPS = HitPawn.GetImpactOverrideParticleSystem();
		}
		// otherwise look to the physical material
		else
		{
		*/

		if( (HitPawn != None ) 
			&& (
			Impact.HitInfo.HitComponent == HitPawn.ShieldMeshComp 
			|| (HitPawn.ResistenceToBullets == 1.0f) 
			|| HitPawn.CurrNanoState == ENS_Dense 
			|| HitPawn.bHasShield 
			) 
			&& Normal(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location - HitPawn.Location) dot vector(HitPawn.Rotation) > 0.0  // in front 
			)
		{
			//`log( "0" );
			ImpactPS = ParticleSystem'Nano_WeaponFX.GEN.Effects.P_Nano_Impact_BulletRicochet';
		}
		else if( ( HitPawn != None ) && ( HitPawn.HasImpactOverride() == TRUE ) )
		{
			//`log( "00" );
			ImpactPS = HitPawn.GetImpactOverrideParticleSystem();
		}
		else
		{
			//`log( "1" );
			ImpactPS = class'NanoPhysicalMaterialProperty'.static.DetermineImpactParticleSystem( PhysMaterial, NanoDmgType, NanoPawn(Instigator) != None ? NanoPawn(Instigator).bActiveReloadBonusActive : FALSE, WorldInfo, Instigator );
		}


		//}

		//`LogExt("- ImpactPS:"@ImpactPS);

		if( ImpactPS == None )
		{
			//FIXME
			if( HitPawn != None )
			{
				if( Impact.HitInfo.HitComponent == HitPawn.ShieldMeshComp 
					|| (HitPawn.ResistenceToBullets == 1.0f) 
					|| HitPawn.CurrNanoState == ENS_Dense 
					|| HitPawn.bHasShield 
					)
				{
					//`log( "2" );
					ImpactPS = ParticleSystem'Nano_WeaponFX.GEN.Effects.P_Nano_Impact_BulletRicochet';
				}
				else
				{
					//`log( "3" );
					ImpactPS = ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_ImpactBlood_01';
				}
			}
			else
			{
				// crowds can be killed so they bleed now
				if( NanoCrowd_PedestrianBase(Impact.HitActor) != None )
				{
					//`log( "4" );
				    ImpactPS = ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_ImpactBlood_01';
				}
			}
		}

		//`LogExt("- ImpactPS2:"@ImpactPS);

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

				// get a particle system component for this system
				ImpactPSC = GetImpactParticleSystemComponent(ImpactPS);
				`assert(ImpactPSC != None);
				// and transform/attach to the mesh
				SMC.TransformToBoneSpace(AttachToBoneName, Impact.HitLocation, Rotator(DirectionToSprayParticles), BoneRelativeLocation, BoneRelativeRotation);
				SMC.AttachComponent(ImpactPSC, AttachToBoneName, BoneRelativeLocation, BoneRelativeRotation);
				ImpactPSC.SetLODLevel(NanoGRI(WorldInfo.GRI).GetLODLevelToUse(ImpactPSC.Template, Impact.HitLocation));
				ImpactPSC.ActivateSystem();

				//`log( "ImpactInfo: " $ AttachToBoneName @ Impact.HitLocation @ BoneRelativeLocation @ BoneRelativeRotation @ ImpactPSC.Template );
				//DrawDebugCoordinateSystem( Impact.HitLocation, Rotator(DirectionToSprayParticles), 3.0f, TRUE );

				// now check for exit wound capability
				// only do this 20% of the time
				if( ( Frand() < 0.20f ) ) // &&( PhysMatProp.ExitWoundPS != none ) )
				{
					//`log( "wooot Exit Wound" );
					ImpactPS = class'NanoPhysicalMaterialProperty'.static.DetermineExitWoundParticleSystem( PhysMaterial, NanoDmgType, NanoPawn(Instigator) != None ? NanoPawn(Instigator).bActiveReloadBonusActive : FALSE, WorldInfo );
					if( ImpactPS != None )
					{
						ImpactPSC = GetImpactParticleSystemComponent(ImpactPS);

						ExitWoundEnd = Impact.HitLocation;
						ExitWoundStart = ExitWoundEnd + (-Impact.HitNormal * 32.0f);

						// note this will break if you have a shot -> body |air| body  then the trace back will be through the second body
						TraceComponent( HitLocation, HitNormal, SMC, ExitWoundEnd, ExitWoundStart,, );

						SMC.TransformToBoneSpace(AttachToBoneName, HitLocation, Rotator(HitNormal), BoneRelativeLocation, BoneRelativeRotation);

						SMC.AttachComponent(ImpactPSC, AttachToBoneName, BoneRelativeLocation, BoneRelativeRotation);
						ImpactPSC.SetLODLevel(NanoGRI(WorldInfo.GRI).GetLODLevelToUse(ImpactPSC.Template, Impact.HitLocation));
						ImpactPSC.ActivateSystem();

						//DrawDebugCoordinateSystem( HitLocation, Rotator(HitNormal), 3.0f, TRUE );
						//DrawDebugLine( ExitWoundStart, ExitWoundEnd , 255, 1, 1, TRUE );
					}

					// when ever we do an exit wound we also want to do a little blood splash
					// unless we already did one due to being really hurt
					if (HitPawn != none && HitPawn.Health >= 0.40 * HitPawn.DefaultHealth)
					{
						//HitPawn.SpawnABloodTrail_HitByABullet();
					}
				}
			}
			// otherwise grab an ol' fashioned emitter
			else
			{
				//FIXME
				ImpactEmitter = GetImpactEmitter(ImpactPS,Impact.HitLocation,rotator(DirectionToSprayParticles));
				`assert(ImpactEmitter != None);
				//`log( "SetBase: " $ Impact.HitActor );
				ImpactEmitter.SetBase(Impact.HitActor);
				ImpactEmitter.ParticleSystemComponent.ActivateSystem();
				//DrawDebugCoordinateSystem( Impact.HitLocation, Rotator(DirectionToSprayParticles), 10.0f, TRUE );

			}
		}
		else
		{
			// hack for now so we don't get spammed by something we know should not have impact effects
			if( NanoCrowd_PedestrianBase(Impact.HitActor) == none )
			{
				`warn("No impact particle system found:"@self@Impact.HitActor@PhysMaterial@NanoDmgType);
			}
		}
}


/**
* This will spawn a PhysicalMaterial based sound.	It looks up the PhysicalMaterial
* tree until it finds a valid sound to Spawn.	If it does not find one then
* it defaults the sound coded in to the .uc file for that specific weapon
*
**/
simulated function SpawnImpactSounds( const class<NanoDamageType> NanoDmgType, ImpactInfo Impact, PhysicalMaterial PhysMaterial )
{
	local SoundCue ImpactCue;

	ImpactCue = class'NanoPhysicalMaterialProperty'.static.DetermineImpactSound( PhysMaterial, NanoDmgType, NanoPawn(Instigator) != None ? NanoPawn(Instigator).bActiveReloadBonusActive : FALSE, WorldInfo );

	//`log( `showvar(ImpactCue) @ `showvar(PhysMaterial) @ `showvar( NanoDmgType) );

	// we should always have one as the BASE phys mat is REQUIRED to have sounds for all types
	if( ImpactCue != None )
	{
		// play the sound
		PlaySound( ImpactCue, TRUE, TRUE, FALSE, Impact.HitLocation, TRUE );
		//PlaySound(ImpactCue,TRUE,,TRUE,Impact.HitLocation);
	}
	else
	{
		`warn( "No impact sound found!!" @ `showvar(ImpactCue) @ `showvar(PhysMaterial) @ `showvar( NanoDmgType) );
	}
}



simulated function static ImpactInfo CalcRemoteWeaponFireStatic(Vector StartTrace, vector EndTrace, Actor TraceOwner)
{
	local vector			HitLocation, HitNormal;
	local Actor				HitActor;
	local TraceHitInfo		HitInfo;
	local ImpactInfo		CurrentImpact;
	local bool bToggledBlockActors;

	// Perform trace to retrieve hit info
	HitActor = TraceOwner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, TRUE, vect(0,0,0), HitInfo, TRACEFLAG_Bullet);

	// If we didn't hit anything, then set the HitLocation as being the EndTrace location
	if( HitActor == None )
	{
		HitLocation	= EndTrace;
	}

	// check to see if we've hit a trigger.
	// In this case, we want to add this actor to the list so we can give it damage, and then continue tracing through.
	if ( (HitActor != None) && PassThroughDamageStatic(HitActor) )
	{
		// disable collision temporarily for the trigger so that we can catch anything inside the trigger
		HitActor.bProjTarget = FALSE;
		if (HitActor.bBlockActors)
		{
			HitActor.SetCollision(HitActor.bCollideActors, false);
			bToggledBlockActors = true;
		}
		// recurse another trace
		CurrentImpact = CalcRemoteWeaponFireStatic(HitLocation, EndTrace,TraceOwner);
		// and re-enable collision for the trigger
		HitActor.bProjTarget = TRUE;
		if (bToggledBlockActors)
		{
			HitActor.SetCollision(HitActor.bCollideActors, true);
		}
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
/** basically same as CalcWeaponFire, but a pure query, no side effects
* @note: make sure the special cases stay mirrored (PassThroughDamage, etc)
*/
simulated function ImpactInfo CalcRemoteWeaponFire(vector StartTrace, vector EndTrace)
{
	local vector			HitLocation, HitNormal;
	local Actor				HitActor;
	local TraceHitInfo		HitInfo;
	local ImpactInfo		CurrentImpact;
	local bool bToggledBlockActors;

	// Perform trace to retrieve hit info
	HitActor =GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, StartTrace, TRUE, vect(0,0,0), HitInfo, TRACEFLAG_Bullet);

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
		if (HitActor.bBlockActors)
		{
			HitActor.SetCollision(HitActor.bCollideActors, false);
			bToggledBlockActors = true;
		}
		// recurse another trace
		CurrentImpact = CalcRemoteWeaponFire(HitLocation, EndTrace);
		// and re-enable collision for the trigger
		HitActor.bProjTarget = TRUE;
		if (bToggledBlockActors)
		{
			HitActor.SetCollision(HitActor.bCollideActors, true);
		}
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
*/

simulated function CalcRemoteImpactEffects( byte FireModeNum, vector GivenHitLocation, bool bViaReplication )
{
	local vector TraceOffset, AimDir, WeaponLoc;
	local ImpactInfo	TestImpact;
	local float			HitDistance;

	// if no instigator (some system is manipulating weapons by hand), measure from fire start location
	WeaponLoc = (Instigator != None) ? Instigator.Location : Location;

	// if we should spawn a tracer effect for remote clients, let's do so
	if( bViaReplication && ShouldSpawnTracerFX() )
	{
		HitDistance = VSize(GivenHitLocation - WeaponLoc);
		SpawnTracerEffect( GivenHitLocation, HitDistance );
	}

	// do another trace to retrieve Hit Info
	AimDir		= Normal(GivenHitLocation - WeaponLoc);
	TraceOffset	= AimDir * 16.f;

	// Only trace slightly before and after our HitLocation
	TestImpact = CalcRemoteWeaponFire(GivenHitLocation-TraceOffset, GivenHitLocation+TraceOffset);

	// We didn't hit anything, use GivenHitLocation as our HitLocation
	if( TestImpact.HitActor == None )
	{
		TestImpact.HitLocation = GivenHitLocation;
	}

	// Process Instant Hit. We use same path as local clients and server.
	ProcessInstantHit_Internal( FireModeNum, TestImpact );
}


/** return true if should spawn tracer effect for instant trace hits */
simulated function bool ShouldSpawnTracerFX()
{
	return (bAllowTracers && !bSuppressTracers);
}

simulated function NanoProj_BulletTracer GetTracer( vector SpawnLocation, rotator SpawnRotation )
{
	return NanoGRI(WorldInfo.GRI).NOP.GetTracer( TracerType, 0, SpawnLocation, SpawnRotation );
}


/**
* Spawn tracer effect for instant hit shots.
* Network: All Clients
*
* @param HitLocation	Location instant trace did hit
& @param HitDistance	Distance to the hit location
*/

simulated function NanoProj_BulletTracer SpawnTracerEffect( vector HitLocation, float HitDistance )
{
	local ParticleSystem	TracerFX;
	local NanoPawn			InstigatorGP;
	local vector			SpawnLoc;
	local Emitter		    SpawnedTracerEmitter;
	local rotator           SpawnRot;
	local NanoProj_BulletTracer	SpawnedProjectile;
	local vector			FinalTracerScale;

	SpawnLoc = GetMuzzleLoc();

	// NOTE we want the tracers to ALWAYS be relevant as there are lots of cases where people are shooting things far far away
	// and maybe have been hidden somewhere for more than 2 seconds.
	// and in MP seeing tracers from some hidden spot is vital
	// and in SP the AI often hides behind you so you can get into the case where they are shooting but you see not tracers

	// is this an AR shot?
	InstigatorGP = NanoPawn(Instigator);

	// spawn a tracer smoke trail only 50% of the time
	if( FRand() > TracerSmokeTrailFrequency )
	{
		TracerFX = ( (InstigatorGP != None) && (InstigatorGP.bActiveReloadBonusActive) && (TracerSmokeTrailEffectAR != None) ) ? TracerSmokeTrailEffectAR : TracerSmokeTrailEffect;
		if(TracerFX != None)
		{
			SpawnedTracerEmitter = GetImpactEmitter( TracerFX, SpawnLoc, Rotation );
			SpawnedTracerEmitter.ParticleSystemComponent.SetVectorParameter('SnipeEnd', HitLocation);
			SpawnedTracerEmitter.ParticleSystemComponent.ActivateSystem();
			//`log("***"@self@"spawned tracer"@TracerFX@SpawnLoc@HitLocation);
		}
	}

	// always spawn a tracer
	// old-style projectile tracers.  The smoke trail is a beam particle effect but FX artists want this type of tracer
	if( HitDistance > ShowTracerDistance )
	{
		SpawnedProjectile = GetTracer( SpawnLoc, SpawnRot );

		if ( (SpawnedProjectile != None) && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Instigator = Instigator;

			// set tracer scale
			FinalTracerScale = TracerScale;
			SpawnedProjectile.SetDrawScale3D(FinalTracerScale);

			// init!
			SpawnedProjectile.InitTracer(SpawnLoc, HitLocation);
		}
	}

	return SpawnedProjectile;

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
	// Start muzzle flash effect
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// only play the shell eject if we are a player controller
		if (Instigator != None && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
		{
			PlayShellCaseEject();
			PlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(WeaponFireWaveForm);
		}

		// Play muzzle flash effect
		PlayMuzzleFlashEffect();

		// play weapon fire sound
		PlayFireSound();
	}

	// Play fire effects for owned player
	if (WorldInfo.Netmode != NM_Client || (Instigator != None && Instigator.IsLocallyControlled()) || bDummyFireWeapon)
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
	if( bLoopMuzzleFlashLight )
	{
		// turn off muzzle flash light
		if( MuzzleFlashLight != None )
		{
			MuzzleFlashLight.SetEnabled(FALSE);
		}
	}

	if( AC_FireSoundLoop != None )
	{
		AC_FireSoundLoop.FadeOut( 0.250f, 0.0f );
		AC_FireSoundLoop = None;
	}

}


/**
* Play fire effects for owned player
* Network: Local Player and Server
*/
simulated function PlayOwnedFireEffects(byte FireModeNum, vector HitLocation)
{
	local int AimBucket;
	// if we should spawn a tracer effect for the local player, let's do so
	if( WorldInfo.NetMode != NM_DedicatedServer &&
		ShouldSpawnTracerFX() &&
		!IsZero(HitLocation)
		)
	{
		if (Instigator != None)
		{
			SpawnTracerEffect( HitLocation, VSize(HitLocation - Instigator.Location) );
		}
		else
		{
			// if no instigator (some system is manipulating weapons by hand), measure from fire start location
			SpawnTracerEffect( HitLocation, VSize(HitLocation - GetMuzzleLoc()) );
		}
	}

	if( (Instigator != None) && Instigator.IsHumanControlled() )
	{
		AimBucket = GetAimBucket(NanoPawnBase(Instigator));
		// Add weapon recoil effect to player's viewrotation
		if (AimBucket != INDEX_NONE)
		{
			WeaponRecoilOffset.Pitch	+= AimSpreadBuckets[AimBucket].WeaponRecoil.X;
			WeaponRecoilOffset.Yaw		+= AimSpreadBuckets[AimBucket].WeaponRecoil.Y * (FRand() > 0.33 ? (FRand() > 0.5f ? 0 : 1) : -1);
		}
		PlayFireCameraEffects();
	}
}

final function int GetAimBucket(NanoPawnBase NP, optional out float TimeInBucket)
{
	local int AimBucket;
	
	if (AimSpreadBuckets.length == 0)
	{
		return INDEX_NONE;
	}
	
	TimeInBucket = `TimeSince(NP.LastWeaponStartFireTime);
	AimBucket = 0;
	while (AimSpreadBuckets[AimBucket].TimeTilNextBucket > 0.f && TimeInBucket > AimSpreadBuckets[AimBucket].TimeTilNextBucket)
	{
		TimeInBucket -= AimSpreadBuckets[AimBucket].TimeTilNextBucket;
		AimBucket++;

		if( AimBucket >= AimSpreadBuckets.Length )
		{
			AimBucket--; // put back to previous bucket
			break;
		}
	}
	return AimBucket;
}

simulated function rotator AddSpread(rotator BaseAim)
{
	local vector X, Y, Z;
	local float CurrentSpread, RandY, RandZ, AimSpreadPct, TimeSpentFiring;
	local NanoPawnBase NP;
	local int AimBucket;
	NP = NanoPawnBase(Instigator);
	if (NP != None)
	{
		AimBucket = GetAimBucket(NP,TimeSpentFiring);
		if (AimBucket != INDEX_NONE)
		{
			if (AimSpreadBuckets[AimBucket].TimeTilNextBucket > 0.f)
			{
				AimSpreadPct = FMin(1.f,TimeSpentFiring/AimSpreadBuckets[AimBucket].TimeTilNextBucket);
			}
			else
			{
				AimSpreadPct = 1.f;
			}

			if (NP.bIsTargeting)
			{
				CurrentSpread = Lerp(AimSpreadBuckets[AimBucket].AimSpreadWhileTargeting.X,AimSpreadBuckets[AimBucket].AimSpreadWhileTargeting.Y,AimSpreadPct);
			}
			else
			{
				CurrentSpread = Lerp(AimSpreadBuckets[AimBucket].AimSpread.X,AimSpreadBuckets[AimBucket].AimSpread.Y,AimSpreadPct);
			}
		}

		//`log( `showvar(AimSpreadBuckets.Length) @ "bucket:"@AimBucket@"aim spread:"@AimSpreadPct@"result:"@CurrentSpread);
		LastAimSpreadPct = AimSpreadPct;
	}

	if (CurrentSpread == 0)
	{
		return BaseAim;
	}
	else
	{
		// Add in any spread.
		GetAxes(BaseAim, X, Y, Z);
		RandY = FRand() - 0.5;
		RandZ = Sqrt(0.5 - Square(RandY)) * (FRand() - 0.5);
		return rotator(X + RandY * CurrentSpread * Y + RandZ * CurrentSpread * Z);
	}
}

/** Overrideable for special firing audio behavior. */
simulated protected function PlayFireSound()
{
	//`log( "PlayFireSound" );
	//FIXME

	// if we have a looping sound
	if( FireSoundLoop != None )
	{
		// if the loop is not already running
		if( AC_FireSoundLoop == None )
		{
			// make a new AC
			AC_FireSoundLoop = new(self) class'AudioComponent';
			if( AC_FireSoundLoop != None )
			{
				AC_FireSoundLoop.SoundCue = FireSoundLoop;
				AttachComponent( AC_FireSoundLoop );
				AC_FireSoundLoop.FadeIn( 0.250f, 1.0f );
			}
		}

		return;
	}


	// HACK!!!!!  we will just abuse these vars
	// FireSound == enemy
	// FireSound_Player == player  (the names are just really poor.  Should be FireSound_Local
	if( NanoPC(Instigator.Controller) != none )
	{
		NanoWeaponPlaySoundLocal( FireSound_Player, FireSound_Player,, 1.f );
	}
	else
	{
		NanoWeaponPlaySoundLocal( FireSound, FireSound,, 1.f );
	}

	// DEMO_HACK
	//if( FireSound_Player != none )
	//{
	//	Instigator.PlaySound( FireSound_Player );
	//}
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
	default:
		break;
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
			NanoProjectile(SpawnedProjectile).bSuppressAudio = bSuppressAudio;
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}




/**
* Causes this weapon to play the given audio. Does not replicate, plays only on this machine.
*
* @param Sound			SoundCue to play, must be valid.
* @param AltLocalSound	Optional alternate SoundCue to play for local players.  Implies bNonSpatialized=TRUE for local players.  If none, base sound is played for all.
* @param bNonSpatialized	TRUE to play the sound nonspatialized.  Will only play for locally controlled players.
* @param NoiseLoudness	Optional intensity of AI noise.
*/
simulated protected function NanoWeaponPlaySoundLocal( SoundCue Sound, optional SoundCue AltLocalSound, optional bool bNonSpatialized, optional float NoiseLoudness )
{
	local AudioComponent AC;
	local NanoPC GPC;
	local SoundCue Cue;

	if( bSuppressAudio )
	{
		return;
	}

	//`log("GearWeaponPlaySoundLocal()"@Sound@AltLocalSound@bNonSpatialized@NoiseLoudness);

	// which cue to play
	if (AltLocalSound != None)
	{
		GPC = (Instigator != None) ? NanoPC(Instigator.Controller) : None;
		if ( (GPC != None) && GPC.IsLocalPlayerController() && GPC.IsViewingTarget(Instigator) )
		{
			Cue = AltLocalSound;
			bNonSpatialized = TRUE;
		}
		else
		{
			Cue = Sound;
		}
	}
	else
	{
		Cue = Sound;
	}

	if( Cue == None )
	{
		return;
	}

	// now play
	if ( Instigator != None )
	{
		if (bNonSpatialized)
		{
			if ( (Instigator.Controller != None) && Instigator.Controller.IsLocalPlayerController() )
			{
				AC = Instigator.CreateAudioComponent( Cue, FALSE, TRUE );
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
		if ( (NoiseLoudness > 0.f) && (WorldInfo.Netmode != NM_Client) )
		{
			Instigator.MakeNoise( NoiseLoudness,'NanoWeaponPlaySoundLocal' );
		}
	}
	else
	{
		// play spatialized, no replication
		PlaySound(Sound, TRUE);
	}
}



/** This determines if you can switch away from a weapon or not.  By default all weapons can be switched from only when in the active state. **/
simulated function bool CanSwitchAwayFromWeapon()
{
	return FALSE;
}


/**
* State Active
* When a weapon is in the active state, it's up, ready but not doing anything. (idle)
*/
simulated state Active
{
	/** This determines if you can switch away from a weapon or not.  By default all weapons can be switched from. **/
	simulated function bool CanSwitchAwayFromWeapon()
	{
		return TRUE;
	}

	simulated function BeginState( Name PreviousStateName )
	{
		local int i;
		local bool bOutOfAmmo;

		if( Role == ROLE_Authority )
		{
			// Cache a reference to the AI controller
			CacheAIController();
		}

		bOutOfAmmo = !HasAnyAmmo();
		`LogInv("PreviousStateName:" @ PreviousStateName @ "bOutOfAmmo:" @ bOutOfAmmo@`showvar(bWeaponPutDown));

		if (bOutOfAmmo)
		{
			//PlayNeedsAmmoChatter();
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
}

/** Used to control if this firing state locks nano powers */
simulated function bool WeaponFiringLocksNanoPowers()
{
	return FALSE;
}

simulated function float GetDelayBeforeUntarget()
{
	return 1.f;
}

simulated state WeaponFiring
{
	/** Used to control if this firing state locks nano powers */
	simulated function bool WeaponFiringLocksNanoPowers()
	{
		return TRUE;
	}

	simulated event BeginState( Name PreviousStateName )
	{
		local NanoPawnBase NP;
		NP = NanoPawnBase(Instigator);
		if( NP != None )
		{
			NP.bIsFiringWeapon = TRUE;
			// mark the last time the weapon was fired
			NP.LastWeaponStartFireTime = WorldInfo.TimeSeconds;
			//LastAimSpreadPct = FMin(LastAimSpreadPct,(1.f - FMin(1.f,(`TimeSince(NP.LastWeaponEndFireTime)/TimeToMinAimSpread))));
			if (TimeToMinAimSpread > 0.f)
			{
				LastAimSpreadPct *= (1.f - FMin(1.f,(`TimeSince(NP.LastWeaponEndFireTime)/TimeToMinAimSpread)));
				//`log("decayed aim pct:"@LastAimSpreadPct@`TimeSince(NP.LastWeaponEndFireTime));
			}

			NP.DelayBeforeUntarget = GetDelayBeforeUntarget();
		}
		Super.BeginState( PreviousStateName );

		if (NP != None && WeaponFiringLocksNanoPowers())
		{
			NanoPawn(NP).LockNanoPower( 'WeaponFiring' );
		}
	}

	simulated event EndState( Name NextStateName )
	{
		local NanoPawnBase NP;
		NP = NanoPawnBase(Instigator);
		if( NP != None )
		{
			NP.bIsFiringWeapon = FALSE;
			// mark the last time the weapon was fired
			NP.LastWeaponEndFireTime = WorldInfo.TimeSeconds;
			//`log("time fired:"@(NP.LastWeaponEndFireTime - NP.LastWeaponStartFireTime));
		}
		Super.EndState( NextStateName );

		ClearTimer( nameof(NotifyWeaponRefireDelayExpired) );

		if(NP != None && WeaponFiringLocksNanoPowers())
		{
			NanoPawn(NP).UnlockNanoPower( 'WeaponFiring' );
		}
	}
}

/** Overridden to handle AI weapon firing */
simulated function StartFire( byte FireModeNum )
{
	// If AI cannot fire weapon right now, abort
	if(  AIController != None )
	{
		//debug
		//`AILog_Ext( GetFuncName()@FireModeNum@AIController.CanFireWeapon( self, FireModeNum ), 'Weapon', NanoAI(AIController) );

		if (!HasAnyAmmo() || !AIController.CanFireWeapon(self, FireModeNum))
		{
			return;
		}

		// Init weapon firing variables for AI
		SetupWeaponFire( FireModeNum );
	}

	Super.StartFire( FireModeNum );
}

/**
* Called by Player to force current weapon to be reloaded
* Network: LocalPlayer
*/

simulated function ForceReload()
{
	// Make sure it's called for a locally controlled pawn.
	if( !Instigator.IsLocallyControlled() )
	{
		return;
	}

	// if we can reload,
	if( CanReload() )
	{
		StartFire(RELOAD_FIREMODE);

		// Trigger the reload delegates in the NanoPC
		FireReloadDelegates();
	}
}

simulated function FireReloadDelegates()
{
	local NanoPC MyNanoPC;

	if ( (Instigator != None) && (Instigator.Controller != None) )
	{
		MyNanoPC = NanoPC(Instigator.Controller);
		if ( MyNanoPC != None )
		{
			//MyNanoPC.TriggerNanoEventDelegates( eGED_Reload );
		}
	}
}

/**
* Returns true if weapon can potentially be reloaded
*
* @return	true if weapon can be reloaded
*/
simulated function bool CanReload()
{
	return(	bWeaponCanBeReloaded	&&	// Weapon can be reloaded
		AmmoUsedCount > 0		&&	// we fired at least a shot
		HasSpareAmmo()				// and we have more ammo to fill current magazine
		);
}



/**
*	AIFunc - Function for AI to setup weapon firing variables
*/
function SetupWeaponFire( byte FireModeNum )
{
	//FIXMEAI
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
		// Reset the timer to try again
		SetTimer( 0.2f, FALSE, nameof(NotifyWeaponRefireDelayExpired) );
	}
}

/**
* returns true if the weapon's magazine is empty and needs to be reloadedTrying 
*
* @return	true if weapon needs to reload
*/
simulated function bool ShouldAutoReload()
{
	return CanReload() && GetMagazineSize() > 0 && AmmoUsedCount >= GetMagazineSize();
}

/**
 * This function handles playing sounds for weapons.  How it plays the sound depends on the following:
 *
 * If we are a listen server, then this sound is played and replicated as normal
 * If we are a remote client, but locally controlled (ie: we are on the client) we play the sound and don't replicate it
 * If we are a dedicated server, play the sound and replicate it to everyone BUT the owner (he will play it locally).
 *
 *
 * @param	SoundCue	- The Source Cue to play
 */
simulated function WeaponPlaySound( SoundCue Sound, optional float NoiseLoudness )
{
	// if we are a listen server, just play the sound.  It will play locally
	// and be replicated to all other clients.
	if( Sound == None || Instigator == None )
	{
		return;
	}

	Instigator.PlaySound(Sound, false, true);
}

/** The weapon is out of ammo and this is the sound it makes when firing with no ammo **/
simulated function PlayNoAmmoFireSound()
{
	WeaponPlaySound(FireNoAmmoSound);
}


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
	local NanoPC	PC;

	// Add Weapon recoil offset to view rotation
	if( WeaponRecoilOffset != Rot(0,0,0) )
	{
		// add recoil offset smoothly
		DeltaRecoil.Pitch	= WeaponRecoilOffset.Pitch	- FInterpTo( WeaponRecoilOffset.Pitch,	0, DeltaTime, RecoilInterpSpeed );
		DeltaRecoil.Yaw		= WeaponRecoilOffset.Yaw	- FInterpTo( WeaponRecoilOffset.Yaw,	0, DeltaTime, RecoilInterpSpeed );

		WeaponRecoilOffset	-= DeltaRecoil;
		PC = NanoPC(Instigator.Controller);
		if( PC != None )
		{
			DeltaRecoil = Normalize(PC.LimitViewRotation( out_ViewRotation + DeltaRecoil, Instigator.ViewPitchMin, Instigator.ViewPitchMax ) - out_ViewRotation);
		}
		//`log(`location@`showvar(DeltaRecoil));
		out_DeltaRot		+= DeltaRecoil;

		if( DeltaRecoil == rot(0,0,0) )
		{
			WeaponRecoilOffset = rot(0,0,0);
		}

		AutoCorrectWeaponRecoilOffset += DeltaRecoil;
		RecoilAutoCorrectTime = WorldInfo.TimeSeconds + RecoilAutoCorrectDelay;
	}
	else if( AutoCorrectWeaponRecoilOffset != rot(0,0,0) 
		&& RecoilAutoCorrectSpeed > 0
		&& WorldInfo.TimeSeconds > RecoilAutoCorrectTime )
		{
			//`log( "1" );
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


/** returns whether or not the passed state name is from a state that actually fires **/
protected function bool IsFireState( name StateName )
{
	return (FiringStatesArray.Find(StateName) != INDEX_NONE);
}

simulated function AutoSwitchToNewWeapon()
{
	//FIXME
	//NanoInventoryManager(InvManager).AutoSwitchWeapon();
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

/** Play Weapon Camera Shake, etc */
simulated function PlayFireCameraEffects( )
{
	local NanoPC	  GPC;
	local NanoCameraShake FCS;

	if( Instigator != None )
	{
		if( Instigator.Controller != None )
		{
			GPC = NanoPC(Instigator.Controller);
		}
	}

	if( GPC != None )
	{
		FCS = GetFireViewShake();
		if (FCS != None)
		{
			GPC.ClientPlayCameraShake( FCS, FireCameraShakeScale );
		}
	}
}

/** Return the screenshake struct to play for this weapon */
simulated function NanoCameraShake GetFireViewShake()
{
	return FireCameraShake;
}


simulated function static bool PassThroughDamageStatic(Actor HitActor)
{
	return ((!HitActor.bBlockActors && (HitActor.IsA('Trigger') || HitActor.IsA('TriggerVolume')))) || HitActor.IsA('GrenadeBlockingVolume');
}


/**
* This function returns the damage for the current firing mode.
* @note: to apply modifiers on base damage, prefer using ModifyDamage(). See below.
*/
simulated function float GetFireModeDamage( Vector HitLocation, optional Actor HitActor )
{
	local float ModifiedDamage;

	if (WeaponDamageAI != 0.f && Instigator != None && NanoAI(Instigator.Controller) != None)
	{
		ModifiedDamage = WeaponDamageAI;
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
	local Actor ActorIter;
	local float Range;
	local float DamageMultiplier;

	//FIXME
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

	DamageMultiplier = GetValueFromRange( DamageDistanceMultiplierCurve, Range );

	//`log( GetFuncName() @ `showvar(DamageMultiplier) );


	BaseDamage *= DamageMultiplier;
}

/** This is our helper function which will allow us to call Eval on the InterpCurveFloat **/
final native function float GetValueFromRange( const out InterpCurveFloat TheCurve, float value ) const;

simulated function DrawDebugShot(vector StartLocation, rotator AimRot)
{
	DrawDebugLine( StartLocation, StartLocation + vector(AimRot) * 1024, 255, 255, 255, true );
}

unreliable client function ClientFlushPersistentDebugLines()
{
	FlushPersistentDebugLines();
}


simulated native function GetMuzzleLocAndRot(out vector Loc, out rotator Rot);

simulated native event vector GetPhysicalFireStartLoc(optional vector AimDir);

/**
* This function returns the world location for spawning the visual effects.
* Network: ALL
*/
simulated native event Vector GetMuzzleLoc();



/**
* Sets the timing for equipping a weapon.
* The WeaponEquipped event is trigged when expired
*/
simulated function TimeWeaponEquipping()
{
	local NanoPawn	P;
	local NanoPC	PC;
	//local int		i;
	local float		BlendInTime;

	P = NanoPawn(Instigator);
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
	//FIXME P.UpdateBoneLeftHandIK();

	// Update AimOffset profiles.
//FIXME
	// 	for(i=0; i<AimOffsetProfileNames.Length; i++)
// 	{
// 		P.SetAimOffsetNodesProfile(AimOffsetProfileNames[i]);
// 	}

	PC = NanoPC(P.Controller);

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

	SetTimer( EquipTime>0 ? EquipTime : 0.01 , FALSE, nameof(WeaponEquipped) );
	`LogInv("EquipTime" @ EquipTime);

	if( bTemporaryHolster )
	{
		// After a temporary holster, add a blend in time, because we're not perfectly transitioning from
		// the putdown animation.
		BlendInTime = 0.2f;
		SetTimer( BlendInTime, FALSE, nameof(EquipWeaponAfterTemporaryHolster) );
	}

	// Stop Holster Animations if they were playing.
	//FIXME StopHolsterAnims();
	// End reloading animations
	EndReloadAnimations();

	//FIXME PlayEquipAnimation(BlendInTime);

	// Attach weapon
	P.AttachWeapon();
}

simulated function PlayEquipAnimation(float BlendInTime);

simulated function EquipWeaponAfterTemporaryHolster()
{
	NanoPawn(Instigator).SetWeaponTemporarilyHolstered(FALSE);
}

state Inactive
{
	simulated event BeginState( Name PreviousStateName )
	{
		local NanoPawnBase NP;
		
		Super.BeginState( PreviousStateName );

		NP = NanoPawnBase(Instigator);
		if( NP != None )
		{
			NP.DelayBeforeUntarget = NP.default.DelayBeforeUntarget;
		}
	}
}

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
	}

	simulated function EndState(Name NextStateName)
	{
		local NanoPawn P;
		local int AmmoStashAmt;
		//local NanoPC PC;

		P = NanoPawn(Instigator);
		if( P != None )
		{
			P.bSwitchingWeapons = FALSE;
			P.bEquipTransition = FALSE;
			// Update left hand IK
			//FIXME P.UpdateBoneLeftHandIK();

			// Trigger the weapon equip delegates in the NanoPC
//FIXME
			// 			PC = NanoPC(P.Controller);
// 			if ( PC != None )
// 			{
// 				PC.TriggerNanoWeaponEquipDelegates( Class );
// 			}

			// Grab spare ammo from pawn
			if(!bMeleeWeapon && Instigator.IsHumanControlled())
			{
				AmmoStashAmt = P.GetStashAmmoForWeapon( class<NanoWeapon>(Class), TRUE );
				//AmmoUsedCount = Max(GetMagazineSize() - AmmoUsedCount, 0);
				SpareAmmoCount = Max(AmmoStashAmt - (GetMagazineSize()-AmmoUsedCount), 0);
				//`log( "Copy ammo from pawn to the weapon" @ Class );
				//`log( `showvar(AmmoStashAmt) @ `showvar(AmmoUsedCount) @ `showvar(SpareAmmoCount) @ `showvar(GetMagazineSize()) );

			}
		}

		Super.EndState(NextStateName);
	}

	simulated function WeaponEquipped()
	{
		//FIXME
// 		if( bTemporaryHolster )
// 		{
// 			// tell pawn so he can detach and all that
// 			NanoPawn(Instigator).SetWeaponTemporarilyHolstered(FALSE);
// 		}

		// If not a temporary holster, notify NanoInventoryManager that we've equipped a weapon
		if( !bTemporaryHolster )
		{
			NanoInventoryManager(InvManager).WeaponEquipped();
		}

		Super.WeaponEquipped();
	}
}


simulated state WeaponPuttingDown
{
	simulated function WeaponIsDown()
	{
		Super.WeaponIsDown();

		// give the ammo we have of this weapon type back to the pawn to store it
		if(!bMeleeWeapon && Instigator.IsHumanControlled())
		{
			//`log( "Copying ammo from weapon to pawn" @ Class @ `showvar(SpareAmmoCount) @ `showvar((GetMagazineSize() - AmmoUsedCount)) );
			NanoPawn(Instigator).GiveAmmo( class<NanoWeapon>(Class), SpareAmmoCount + (GetMagazineSize() - AmmoUsedCount), TRUE);
		}
	}
}

simulated function WeaponEquipped()
{
	`warn( "This should never be called!  need to be in state WeaponEquipping" );
}




/** Returns TRUE, if muzzle flash effects should be played. */
simulated function bool IsMuzzleFlashRelevant()
{
	return TRUE;
}


/**
* Start muzzle flash effect
* Network: Local Player and Clients
*/
simulated function PlayMuzzleFlashEffect()
{
	local vector		SpawnLoc;

//	`log( self@GetFuncName()@bSuppressMuzzleFlash@IsMuzzleFlashRelevant()@MuzFlashEmitter);

	// Play muzzle flash effects only if they are relevant
	if( !bSuppressMuzzleFlash && IsMuzzleFlashRelevant() )
	{
		// turn on muzzle flash mesh
		//`log("playing muzzle flash"@MuzzleFlashMesh@MuzFlashEmitter@MuzzleFlashLight);
		if( MuzzleFlashMesh != None )
		{
			MuzzleFlashMesh.SetHidden(FALSE);

			// Randomize muzzle flash mesh size
			RandomizeMuzzleFlash(MuzzleFlashMesh);
		}

		// activate muzzle flash particle system
		if( MuzFlashEmitter != None )
		{
			ClearTimer( nameof(HideMuzzleFlashEmitter) );
			MuzFlashEmitter.SetHidden( FALSE );

			if (bMuzFlashEmitterIsLooping)
			{
				MuzFlashEmitter.SetLODLevel(NanoGRI(WorldInfo.GRI).GetLODLevelToUse(MuzFlashEmitter.Template, GetMuzzleLoc()));
				MuzFlashEmitter.SetActive(TRUE);
			}
			else
			{
				MuzFlashEmitter.SetLODLevel(NanoGRI(WorldInfo.GRI).GetLODLevelToUse(MuzFlashEmitter.Template, GetMuzzleLoc()));
				MuzFlashEmitter.ActivateSystem();
			}
		}

		if( MuzzleFlashLight != None
			&& !NanoGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator)
			&& (!bLoopMuzzleFlashLight || !MuzzleFlashLight.bEnabled)
			)
		{
			//MuzzleFlashLight.CastDynamicShadows = bDynamicMuzzleFlashes;
			MuzzleFlashLight.SetEnabled(TRUE);

			// Reset Pulse time to zero, so we start at the beginning.
			MuzzleLightPulseTime = 0.f;
		}

		// maybe spawn lingering muzzle smoke
		if( (MuzSmokeParticleSystem != None)
			&& !NanoGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator)
			)
		{
			SpawnLoc = GetMuzzleLoc();
			WorldInfo.MyEmitterPool.SpawnEmitter(MuzSmokeParticleSystem, SpawnLoc, rot(0,0,0));
		}

		SetTimer( MuzzleLightDuration, FALSE, nameof(StopMuzzleFlashEffect) );
	}
}



/**
* Stop muzzle flash effect
* Network: Local Player and Clients
*/
simulated function StopMuzzleFlashEffect()
{
//	`log( self@GetFuncName() );

	// turn off muzzle flash mesh
	if( MuzzleFlashMesh != None )
	{
		MuzzleFlashMesh.SetHidden( TRUE );
	}

	if( MuzFlashEmitter != None )
	{
		MuzFlashEmitter.SetActive(FALSE);
		SetTimer( TimeToHideMuzzleFlashPS, FALSE, nameof(HideMuzzleFlashEmitter) );
	}

	// turn off muzzle flash light only if it's non looping
	// Looping ones are turned off when the weapon stops firing
	// Used by rapid fire weapons
	if( !bLoopMuzzleFlashLight && MuzzleFlashLight != None )
	{
		MuzzleFlashLight.SetEnabled( FALSE );
	}
}


simulated function HideMuzzleFlashEmitter()
{
	MuzFlashEmitter.SetHidden( TRUE );
}

simulated function HidePSC_ShellEject()
{
	PSC_ShellEject.SetHidden( TRUE );
	PSC_ShellEject.RewindEmitterInstances();
}

simulated function PlayShellCaseEject()
{
	// shell eject particle system
	if( PSC_ShellEject != None )
	{
		ClearTimer( nameof(HidePSC_ShellEject) );
		PSC_ShellEject.SetHidden( FALSE );
	    //@SAS. Set the bJustAttched flag when activating...
		PSC_ShellEject.ActivateSystem(TRUE);
	}
}


simulated function HidePSC_ReloadBarrelSmoke()
{
	PSC_ReloadBarrelSmoke.SetHidden( TRUE );
}


/**
* Randomizes muzzle flash mesh transform component. to give a random aspect to it.
*/

simulated function RandomizeMuzzleFlash( PrimitiveComponent MuzzleFlash )
{
	local Vector	V;
	local Rotator	R;

	// Randomize muzzle flash mesh size
	V.X = MuzzleFlash.default.Scale3D.X * ( 0.8 + 0.4*FRand() );
	V.Y = MuzzleFlash.default.Scale3D.Y * ( 0.8 + 0.4*FRand() );
	V.Z = MuzzleFlash.default.Scale3D.Z * ( 0.8 + 0.4*FRand() );

	MuzzleFlash.SetScale3D( V );

	// randomize muzzle flash mesh roll angle
	R = MuzzleFlash.Rotation;
	R.Roll = FRand() * 65536;
	MuzzleFlash.SetRotation( R );
}


/** Sets up effects components that are attached to the weapon mesh. */
simulated event AttachMuzzleEffectsComponents(SkeletalMeshComponent SkelMesh)
{
//	`log( self@GetFuncName()@SkelMesh@MuzFlashEmitter@MuzzleSocketName );

	// we allowed attachment on dedicated servers, but we don't need stuff after this
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Attach muzzle flash related effects
	if( SkelMesh != None && MuzzleSocketName != '' )
	{
		// if we are pending kill then don't attach things
		if( SkelMesh.IsPendingKill() )
		{
			//ScriptTrace();
			return;
		}

		if (Owner != None)
		{
// 			SetMaterialBasedOnTeam( SkelMesh, GearPawn(Owner) != none ? GearPawn(Owner).GetMPWeaponColorBasedOnClass() : Owner.GetTeamNum() );
// 			MIC_WeaponSkin.SetScalarParameterValue( 'Weap_SpecMult', 1.0f );
// 			MIC_WeaponSkin.SetScalarParameterValue( 'Weap_DroppedGlow', 0.0f );
// 			MIC_WeaponSkin.SetScalarParameterValue( 'Weap_DropGlowAlpha', 0.0f );
		}

		// Muzzle Flash Mesh
		if( MuzzleFlashMesh != None && !SkelMesh.IsComponentAttached(MuzzleFlashMesh) )
		{
			SkelMesh.AttachComponentToSocket(MuzzleFlashMesh, MuzzleSocketName);
		}

		// attach muzzle flash emitter, and position to fire offset
		if( MuzFlashEmitter != None && !SkelMesh.IsComponentAttached(MuzFlashEmitter) )
		{
			SkelMesh.AttachComponentToSocket(MuzFlashEmitter, MuzzleSocketName);
			HideMuzzleFlashEmitter();
		}

		// Muzzle Flash dynamic light
		if( MuzzleFlashLight != None && !SkelMesh.IsComponentAttached(MuzzleFlashLight) )
		{
			MuzzleFlashLight.SetTranslation(MuzzleLightOffsetFromCannon);
			SkelMesh.AttachComponentToSocket(MuzzleFlashLight, MuzzleSocketName);
		}

		// attach after fire particle system
		if( PSC_ReloadBarrelSmoke != None && !SkelMesh.IsComponentAttached(PSC_ReloadBarrelSmoke) )
		{
			SkelMesh.AttachComponentToSocket(PSC_ReloadBarrelSmoke, MuzzleSocketName);
			HidePSC_ReloadBarrelSmoke();
		}
	}
}


/**
 * Returns true if we are currently zoomed
 */
simulated function EZoomState GetZoomedState()
{
// 	local PlayerController PC;
// 	PC = PlayerController(Instigator.Controller);
// 	if ( PC != none && PC.FOVAngle != PC.DefaultFOV )
// 	{
// 		if ( PC.FOVAngle == PC.DesiredFOV )
// 		{
// 			return ZST_Zoomed;
// 		}
// 
// 		return ( PC.FOVAngle < PC.DesiredFOV ) ? ZST_ZoomingOut : ZST_ZoomingIn;
// 	}
	return ZST_NotZoomed;
}

/**
 * This determines whether or not the Weapon can have ViewAcceleration when Firing.
 **/
simulated function bool CanViewAccelerationWhenFiring()
{
	return FALSE;
}

/**
 * Returns true if this item can be thrown out.
 */
simulated function bool CanThrow()
{
	return bCanThrow && !bMeleeWeapon; // Currently don't drop melee weapons
}

function DropFrom(vector StartLocation, vector StartVelocity)
{
	local NanoDroppedWeapon Asset;
	local Pawn OldInstigator;
	local vector SocketLocation;
	local rotator SocketRotation;

	//`log(`location@`showvar(CanThrow())@`showvar(StartVelocity)@VSize(StartLocation - Instigator.Location));

	if( !CanThrow() )
	{
		return;
	}

	// cache the Instigator, since the removal from the inventory manager will clear it
	OldInstigator = Instigator;

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
		if (NanoPawn(OldInstigator) != None && NanoPawn(OldInstigator).MyNanoWeapon == self)
		{
			NanoPawn(OldInstigator).MyNanoWeapon = None;
		}
	}

	// change the StartLocation to be the Hand that the Trooper is wielding the weapon in
	if( OldInstigator.Mesh.GetSocketWorldLocationAndRotation( 'Weapon_R', SocketLocation, SocketRotation) == TRUE )
	{
		StartLocation = SocketLocation;
	}

	Asset = Spawn(class'NanoDroppedWeapon',,, StartLocation, SocketRotation);
	if (Asset != None)
	{

		if( SkeletalMeshComponent(Mesh).PhysicsAsset == none )
		{
			`warn( "!!!! DropFrom with a NONE PhysicsAsset !!!!"  );	
			ScriptTrace();
		}

		//ScriptTrace();

		Asset.WeaponClass = default.class;

		// Non-melee weapon pickups get ammo
		if(!bMeleeWeapon)
		{
			Asset.AmmoAmount = DropMagazines * WeaponMagSize;
		}

		Asset.SetMeshAndPhysAsset(SkeletalMeshComponent(Mesh).SkeletalMesh,SkeletalMeshComponent(Mesh).PhysicsAsset);
		Asset.SkeletalMeshComponent.WakeRigidBody();
		Asset.SkeletalMeshComponent.SetRBAngularVelocity(VRand() * RandRange(-64,64),TRUE);
		
		// we might want to randomize this instead of the default throw at the player
		StartVelocity = vect(0,0,-50);
		Asset.SkeletalMeshComponent.SetRBLinearVelocity(StartVelocity);

		Asset.SkeletalMeshComponent.SetNotifyRigidBodyCollision(TRUE);

		Asset.ActivateInFlightSounds();
	}

	Instigator = None;
	AIController = None;
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
	// Forward event to pawn owner
	NanoPawnBase(Instigator).MeleeAttackStarted(Self);

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
* Event called when melee attack ends.
* This means when weapon leaves melee attacking state on local player and server.
* When Pawn.FiringMode != MELEE_ATTACK_FIREMODE is replicated on remote clients, and previous firing mode was MELEE_ATTACK_FIREMODE.
*/
simulated function MeleeAttackEnded()
{
	if (NanoPawnBase(Instigator) != None)
	{
		// Forward event to pawn owner
		NanoPawnBase(Instigator).MeleeAttackEnded(Self);
	}

	bHitWallThisAttack = FALSE;
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
	//local NanoPCBase	GPC;
	local NanoPawnBase	GP;
	local float		AnimDuration;

	GP = NanoPawnBase(Instigator);
	if( GP == None )
	{
		return;
	}

	// Play melee attack animation.
	AnimDuration = PlayMeleeAttackAnimation(GP);
	TimeStartedSpecialMeleeAttack = WorldInfo.TimeSeconds;
// 
// 	if( !bSuppressMeleeAttackCameraBoneAnim && MeleeAttackCameraBoneAnims.Length > 0 )
// 	{
// 		GPC = NanoPCBase(GetWeaponController(Instigator));
// 		if (GPC != None)
// 		{
// 			GPC.PlayRandomCameraBoneAnim(MeleeAttackCameraBoneAnims,, 0.1f, 0.1f,,, TRUE, TRUE, TRUE);
// 		}
// 	}

	// Set Timer to end melee attack state
	if( AnimDuration > 0.f )
	{
		SetTimer( AnimDuration, FALSE, nameof(EndOfMeleeAttack) );
	}
	else
	{
		`Warn("PlayMeleeAttack" @ Self @ Instigator @ "AnimDuration is zero!!, ending melee attack now");
		EndOfMeleeAttack();
	}

// 	// play melee attack sound
// 	if( WorldInfo.NetMode != NM_DedicatedServer )
// 	{
// 		GP.SoundGroup.PlayFoleySound(GP, GearFoley_MeleeAttackFX);
// 	}
}


/**
* Play melee attack animation.
* Returns the duration in seconds of the animation.
*/
simulated function float PlayMeleeAttackAnimation(NanoPawnBase P)
{
	//local float	AnimTime;
	//local int	Idx;

	//FIXME
// 	// Does Pawn want to override the melee animation with his own?
// 	if( P.OverridePlayMeleeAttackAnim(AnimTime) )
// 	{
// 		return AnimTime;
// 	}

	// pick random attack
	//Idx = Rand(BS_MeleeAttack.Length);

	return NanoPawn(P).PreAimFullBodySlot.PlayCustomAnim( 'SMG_Melee_A', 1.0, 0.1, 0.1, FALSE, TRUE );

	//return P.BS_Play(BS_MeleeAttack[Idx], 1.f, 0.1f, 0.25f, FALSE, TRUE);
}


/**
* Called by timer from PlayMeleeAttack()
* Overloaded in state to end attack.
*/
simulated function EndOfMeleeAttack();


/** Notification called from Pawn animation, by GearAnimNotify_MeleeImpact. */
simulated function MeleeImpactNotify(NanoAnimNotify_MeleeImpact Notify)
{
	if( !bUseMeleeHitTimer && !bMeleeImpactNotifySemaphore )
	{
		// Give damage
		MeleeAttackImpact();
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
		if ( (HitActor.bBlockActors || HitActor.bWorldGeometry || (Volume(HitActor) == None && Trigger(HitActor) == None ) &&
			(NanoPawnBase(HitActor) == None) ))
		{
			HitLocation = HitLoc;
			return HitActor;
		}
	}

	// Found nothing non-volume or -trigger like :(
	return None;
}

/**
* Melee Damage
* @param	InDamage	Damage given to override the default RandRange(MeleeAttackDamageMin, MeleeAttackDamageMax)
*/
simulated function bool MeleeAttackImpact( optional int InDamage, optional out NanoPawnBase OutVictimPawn, optional out TraceHitInfo OutHitInfo, optional bool bTest )
{
	local NanoPawnBase		GP, TestGP;
	local vector		CheckDir, DirToVictim, CheckDir2D, DirToVictim2D, HitLoc, EndTrace, StartTrace, TestGPLoc;
	local float			Damage;
	local Actor			HitActor;
	//local NanoPCBase		 PC;
	local TraceHitInfo	HitInfo;
	local NanoPawnBase		CurrWinner;
	local float			CurrClosestDistance;
	local float			DistanceToCheckAgainst;
	local ImpactInfo	TestImpact;
	local float			AttackRange;
	local NanoAI		AI;
	//local FracturedStaticMeshActor FracActor;
	local Controller PawnController;

	`if(`notdefined(FINAL_RELEASE))
		local bool			bShowDebugging;
	`endif

		GP = NanoPawnBase(Instigator);
	`if(`notdefined(FINAL_RELEASE))
		bShowDebugging = GP != None && GP.bWeaponDebug_Accuracy && Instigator.IsLocallyControlled();
	`endif

		// Make sure Pawn is allowed to melee. Pawn could have enterred a state preventing that like going DBNO.
		if( GP != None && !GP.CanEngageMelee() )
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
		if( !bSlaveWeapon )
		{
			AttackRange = MeleeAttackRange;
			AI = NanoAI(Instigator.Controller);
			if( AI != None )
			{
				AttackRange = Range_MeleeCharge; // FIXME AI.EnemyDistance_Melee;
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

					foreach WorldInfo.AllPawns(class'NanoPawnBase', TestGP)
				{
					// First make sure Pawn is relevant (ie not dead)
					if( TestGP != GP && !TestGP.bDeleteMe && !TestGP.bTearOff )
					{
						//				`log(" Considering:" @ TestGP);
						TestGPLoc = TestGP.GetMeleeHitTestLocation();
						DistanceToCheckAgainst = VSize(TestGPLoc - GP.Location);

						// Then make sure Pawn is within melee range
						if( DistanceToCheckAgainst > AttackRange || DistanceToCheckAgainst > CurrClosestDistance ||
							Abs(TestGPLoc.Z - GP.Location.Z) > GP.CylinderComponent.CollisionHeight * 0.8f )
						{
							//					`log("rejected within melee range");
							continue;
						}

						// Then Peform other relevancy checks
						if( !GP.TargetIsValidMeleeTarget(TestGP, TRUE) )
						{
							//					`log("rejected TargetIsValidMeleeTarget");
							continue;
						}

						// skip held meatshields
// 						if ( TestGP.IsAHostage() && Instigator == TestGP.InteractionPawn )
// 						{
// 							continue;
// 						}

						// Check that pawn is within FOV
						DirToVictim = Normal(TestGPLoc - GP.Location);

						//if(GP.CarriedCrate == none )
						//{
							// If our check FOV is a cone, then perform a simple dot product
							if( MeleeAcquireDotFOV.X == MeleeAcquireDotFOV.Y )
							{
								// Make sure victim is in FOV
								if( DirToVictim dot CheckDir < MeleeAcquireDotFOV.X )
								{
									//						`log("rejected:"@TestGP@"dot:"@DirToVictim dot CheckDir);
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
											//						`log("rejected:"@TestGP@"horiz dot:"@DirToVictim2D dot CheckDir2D);
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
													//						`log("rejected:"@TestGP@"vert dot:"@DirToVictim2D dot CheckDir2D);
													continue;
												}
							}
						//}

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

						if (HitActor != None && HitActor != TestGP)
						{
							//					`log("rejected Trace"@HitActor);
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
			if( WorldInfo.NetMode != NM_Client )
			{
				if( !bTest )
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

					// If attacker is AI controlled
					PawnController = Instigator.Controller;
					if( !GP.IsHumanControlled(PawnController) )
					{
						Damage *= GP.AI_MeleeDamageScale;
					}

					//					`log("Damage:" @ Damage @ "for" @ TestGP);

					if( Damage > 0 )
					{
// 						// Force kill DBNO players.
// 						if( TestGP.IsDBNO() )
// 						{
// 							Damage = TestGP.DefaultHealth - TestGP.DBNODeathThreshold + 1;
// 							//							`log("DBNO ForceKill Damage:" @ Damage);
// 						}
						// Give Damage
						GiveMeleeDamageTo(TestGP, Damage);

// 						// and make them stumble
// 						if( !TestGP.bPlayedDeath && !TestGP.InGodMode() )
// 						{
// 							TestGP.DoStumbleFromMeleeSpecialMove();
// 						}
					}

					// do melee hit effects...
// 					PC = NanoPCBase(GetWeaponController(TestGP));
// 					if( PC != None )
// 					{
// 						PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
// 					}
				}

				OutHitInfo		= HitInfo;
				OutVictimPawn	= TestGP;
				//`log("-"@self@WorldInfo.TimeSeconds@"hit"@TestGP@HitInfo.HitComponent@HitInfo.BoneName);
			}

			// client-side nonreplicated effects
// 			if (!bTest)
// 			{
// 				// randomly choose between flesh and armor damage sounds
// 				if( 0.5f > FRand() )
// 				{
// 					TestGP.SoundGroup.PlayFoleySound( TestGP, GearFoley_MeleeAttackHitFleshFX );
// 				}
// 				else
// 				{
// 					TestGP.SoundGroup.PlayFoleySound( TestGP, GearFoley_MeleeAttackHitArmorFX );
// 				}
// 			}

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
							bHitWallThisAttack = TRUE;

							if( !bTest )
							{
								// Particle
								HitLoc		= TestImpact.HitLocation;
								HitLoc.Z	= HitLoc.Z + 100; // ?
								//WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'COG_Assaultrifle.Effects.P_COG_AssaultRifle_Impact_Melee', HitLoc, rotator(TestImpact.HitNormal));

								// Sound
								WeaponPlaySound(MeleeImpactSound); // hit wall
								//PlayMeleeScreenShake(None);

// 								PC = NanoPCBase(GetWeaponController(Instigator));
// 								if( PC != None )
// 								{
// 									PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
// 								}
// 
// 								// Fracture meshes if we hit them
// 								if(bAllowMeleeToFracture)
// 								{
// 									FracActor = FracturedStaticMeshActor(TestImpact.HitActor);
// 									if(FracActor != None)
// 									{
// 										FracActor.BreakOffPartsInRadius(HitLoc - (TestImpact.HitNormal * 15.0), 35.0, 100.0, TRUE);
// 										//DrawDebugSphere(HitLoc - (TestImpact.HitNormal * 15.0), 35.0, 16.0, 255,0,0, TRUE);
// 									}
// 								}
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
function GiveMeleeDamageTo(NanoPawnBase Victim, float Damage)
{
	local Vector			EndTrace, MomentumScale;
	local ImpactInfo		Impact;
	local class<DamageType>  DT;
	//local NanoPawnBase			Gp;

	if (Damage < 1.f || bSlaveWeapon)
	{
		return;
	}

	//GP = NanoPawnBase(Owner);

	if ( Victim != None )
	{
// 		// wtf is this?	 should be rolled into PlayMeleeScreenShake functionality.
// 		if (bDoMeleeDamageShakes)
// 		{
// 			// Shake controller of Victim
// 			if (NanoPCBase(GetWeaponController(Victim)) != None)
// 			{
// 				NanoPCBase(Victim.Controller).ClientPlayForcefeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
// 			}
// 			// Shake controller of Hitter
// 			if (GP != None && GearPC(GetWeaponController(GP)) != None)
// 			{
// 				NanoPCBase(GP.Controller).ClientPlayForcefeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
// 			}
// 		}

		// Trace to neck for maximum blood in your face
		EndTrace = Victim.Mesh.GetBoneLocation(Victim.MeleeDamageBoneName);

		// Do a trace to get HitInfo
		Instigator.TraceComponent(Impact.HitLocation, Impact.HitNormal, Victim.Mesh, EndTrace, Instigator.Location, Vect(0,0,0), Impact.HitInfo);

		MomentumScale		= Impact.HitNormal * -1.f;
		Impact.HitActor		= Victim;
		Impact.RayDir		= Normal(Impact.HitLocation - Instigator.Location);


// 		if(GP.IsCarryingShield())
// 		{
// 			DT = class'GDT_ShieldBash';
// 		}
// 		else
// 		{
// 			DT = InstantHitDamageTypes[MELEE_ATTACK_FIREMODE];
// 		}

		DT = InstantHitDamageTypes[MELEE_ATTACK_FIREMODE];
		Victim.TakeDamage(Damage, Instigator.Controller, Impact.HitLocation, MomentumScale, DT , Impact.HitInfo);

		//@FIXME: this block doesn't work for clients!
		//{

		// Play Physics Body Impact.
		//Victim.PlayPhysicsBodyImpact(Impact.HitLocation, MomentumScale, InstantHitDamageTypes[MELEE_ATTACK_FIREMODE], Impact.HitInfo);

		// Back up HitLocation a bit to spawn impact effects
		Impact.HitLocation = Impact.HitLocation + Impact.HitNormal * 3.f;

		//SpawnImpactEffects(class'GDT_Melee',Impact,class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterial(Impact),FALSE,TRUE,FALSE);

		//}

		// FIXME
		//if (bDoMeleeDamageShakes)
		//{
		//	PlayMeleeScreenShake( Victim );
		//}
	}
	else
	{
		`log(WorldInfo.TimeSeconds @ GetFuncName() @ "SpecialMeleeAttackVictim == None");
	}
}


/** Accessor function to get the controller of the pawn who is carrying this weapon */
simulated final function Controller GetWeaponController(Pawn P)
{
	local Controller C;

	if (Instigator != None)
	{
		// First try the controller of the instigator
		C = Instigator.Controller;

	}

	return C;
}

/** Instigator of this weapon has landed on the ground */
simulated function HandleLanded();

/** notification fired from weapon animation when clip is released from weapon. */
simulated function Notify_AmmoRelease();
/** Notify called when ammo is thrown by player */
simulated function Notify_AmmoThrow();
/** notification fired from weapon animation when player grabs another magazine. */
simulated function Notify_AmmoGrab();
/** notification fired from weapon animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload();



defaultproperties
{
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_InstantHit
	Spread(0)=0.0f
	WeaponProjectiles(0)=none
	InstantHitDamageTypes(0)=class'NDT_MP7'
	InstantHitDamage(0)=0.0f
	InstantHitMomentum(0)=0.0f
	FireInterval(0)=+1.0f

	EquipTime=0.0
	PutDownTime=0.0

	TracerScale=(X=1.f,Y=1.f,Z=1.f)
	bClientSideInstantHit=FALSE

	// per weapon really here to make things work

	bDebuggingShots=FALSE

	MuzzleSocketName="Muzzle"
    ShellEjectSocketName="ShellEject"

	bUseMuzzleLocForPhysicalFireStartLoc=TRUE
	bAllowTracers=TRUE

	bInstantHit=TRUE

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
	Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1


	bWeaponCanBeReloaded=TRUE
	TracerType=WTT_LongSkinny

	FireSound=None
	FireSound_Player=None
	//FireSound=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopEnemyCue'			// looping
	//FireSound_Player=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopPlayerCue'	// looping
	//StopFireSound=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireStopEnemyCue'
	//StopFireSound_Player=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireStopPlayerCue'



	// muzzle flash emitter
	Begin Object Class=NanoParticleSystemComponent Name=PSC_WeaponMuzzleMuzFlashComp
	    bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	MuzFlashEmitter=PSC_WeaponMuzzleMuzFlashComp

	MuzzleLightDuration=0.10f // LOL this is actually used to STOP the muzzle flash particle effect  WOW

	// Muzzle Flash point light
	Begin Object Class=PointLightComponent Name=WeaponMuzzleFlashLightComp
	    bEnabled=FALSE
		Brightness=10
		Radius=256
		bAffectCompositeShadowDirection=FALSE // do not affect light env shadow direction
	End Object
    //MuzzleFlashLight=WeaponMuzzleFlashLightComp  // each subclass should set this if they want one


	AimAssistScale=1.0f
	AimAssistScaleWhileTargeting=1.0f

	TimeToSummonWeapon=0.001
	CrosshairIcon=None

	FireCameraShakeScale=1.f
}
