/**
 * This class is the base class for Gear damage types
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearDamageType extends DamageType
	native
	config(Weapon)
	DependsOn(GUDTypes,GearTypes,GearPlayerCamera,GearSoundGroup)
	abstract;

/** FXInfo IDs for phys material based effects */
var const EImpactTypeBallistic ImpactTypeBallisticID;
var const EImpactTypeExplosion ImpactTypeExplosionID;


/** ==== General damage attributes ==== */

/** amount to scale Damage when this damagetype hits a fortification */
var config float FortificationDamageScale;

/** Amount to scale Damage in the event of a head shot (1.f == no head shots) */
var const config float HeadShotDamageScale;
/** force head shot check even when no actual damage multiplier (for when it changes effects but has no gameplay impact) */
var config bool bForceHeadShotCheck;

/** Chance a shot from this damage type will remove an attachment */
var const config float AttachmentRemovalChance;

/** If this weapon does head shots, is it capable of knocking the head off entirely for the special death? */
var(Gore) const config bool bAllowHeadShotGib;

/** If this weapon does head shots, is it allowed to skip DBNO and execute the player immediately? */
var const config bool bAllowHeadShotExecution;

/** Should this damage be applied regardless of cover? */
var const config bool bIgnoreCover;

/** Stopping power of this damage type, MovementPct per damage. */
var const config float StoppingPower;

/** TRUE if this damage type come from the 'environment' and not a weapon */
var const bool bEnvironmentalDamage;

/** If TRUE, play a high kick death animation. Suitable for explosives, or high kick weapons such as shotguns */
var const config bool	bHighKickDeathAnimation;

/** if TRUE, everyone will be damaged regardless of team */
var const config bool	bAlwaysDamageFriendlies;

/** ==== AI specific damage attributes ==== */

/** Whether or not this damage type should cause stumbles **/
var const config bool bShouldCauseStumbles;
/** The percent of a stumble for this damage type (0 - 1.f) **/
var const config float StumblePercent;
/** the damage value to pretend to do when evaluating a near-miss (to determine whether or not to flee from a near miss) */
var const config int NearMissPretentDamageValue;

/** Chance to play a full body hit reaction animation */
var const config FLOAT	FullBodyHitReactionAnimChance;

/** ==== Physics specific damage attributes ==== */

/** How long the physical hit reaction lasts. */
var config const float HitReactionTimeScale;

/** When this is TRUE, it forces a straight rag doll death, without playing death animations, nor motorized physics. */
var const bool bForceRagdollDeath;

/** When bShouldGib is set, DistFromHitLocToGib creates a cylinder of influence around the HitLocation, along the HitDirection,
 * And any constraints within that cylinder will be broken.	 Default value of -1.f breaks the whole body. */
var(Gore) config const float DistFromHitLocToGib;

/** How much force to apply to gibs when gibbing someone with this damagetype.  Basically KDamageImpulse, but for gibbing.  */
var(Gore) config float GibImpulseMagnitude;

/** Extra boost to KDeathUpKick when gibbing */
var(Gore) config float KDeathUpKickGib;

/** The types of gib impulses we support */
enum EGibImpulseType
{
	/** Legacy Gears2 penetration code */
	GIBIMPULSE_Penetration,
	/** Legacy Gears2 radial code */
	GIBIMPULSE_Radial,
	/** Thin disc of damage that pushes away radially but not on the Z axis */
	GIBIMPULSE_Disc,
	/** Point plus sphere for the breaking of joints, but momentum along the instigator to bone location */
	GIBIMPULSE_Cone
};

/** The impulse type to use when breaking constraints and applying impulses */
var(Gore) config EGibImpulseType GibImpulseType;

/** The amount of twist to apply to the mesh */
var(Gore) config float GibAngularVelocityMagnitude;

/** ==== Feedback related attributes ==== */

/** Killed by Icon **/
var const CanvasIcon KilledByIcon;
var const CanvasIcon HeadshotIcon;
var const float IconScale;

/** The text that goes before the player name in the killed by description */
var localized string KilledByText;

/** GUD event to throw when someone gets killed by this damage type.  Defaults to GUDEvent_None to fallback to default events. */
var const EGUDEventID KillGUDEvent;

/** Whether to play GUDEvent_DamagedEnemyHeavy when causing major damage */
var bool bPlayDamagedEnemyHeavyGUD;

/** Take Damage Camera Shake */
var() editinline protected CameraShake OnDamageCameraShake;

/** Scale properties of the screenshake based on the amount of damage taken in relation to the total health of our pawn */
var() protected float OnDamageCameraShakeScale;

/**
 * This is the Damage Type's suppress impact effects bool
 * Some weapons such as the InkGrenade cloud and flamethrower should not play impact effects.
 **/
var bool bSuppressImpactFX;

/**
 * This is the Damage Type's suppress blood decals
 * Some weapons such as the flamethrower are so expensive that we don't want to have more costs associated with them per frame
 **/
var bool bSuppressBloodDecals;


/**
 * Some explosion particle systems already have the blood and guts inside the Explosion so we do not want to play the additional
 * effect.
 **/
var bool bSuppressPlayExplosiveRadialDamageEffects;

var() const GearVoiceEffortID		DeathScreamEffortID;

/** Use the location for the hit indicator rather than the updated actor location. */
var config bool bUseLocationForIndicator;

/** @STATS -- Holds the tag that associated this damage type with a weapon type */
var EWeaponClass WeaponID;

/** when this is enabled, damage will be scaled proportionately to the player health scalar, so that it will do the same amount of proportionate damage across all difficulty levels */
var config bool bCompensateDamageForDifficulty;

/** whether players should get the suicide penalty applied to their score when they suicide by this damage type */
var bool bSuicidePenalty;

/**
 *  A scalar to manipulate how much protection a meatshield offers against this damage type.
 *  e.g. 2.0 = meatshield offers double protection against this damage
 *       1.0 = normal meatshield damage scaling (default)
 *       0.0 = meatshield offers no protection against this damage
 */
var() float  MeatshieldProtecionScale;

/** TRUE if this damage type deals damage to the baby Corpser when stunned */
var() config bool bDamagesBabyCorpser;

//The name of the weapon stat that this damage type represents
var config string WeaponStatName;

var const SoundCue GibExplodeSound;

var const float GibImpactSoundDelay;

/** Should the Pawn explode into chunky bits when killed with this damage type? */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return FALSE;
}

/** Should the Pawn play the special head shot death? */
static function bool ShouldHeadShotGib(Pawn TestPawn, Pawn Instigator)
{
	local GearPawn GP;
	// if we are capable
	if (default.bAllowHeadShotGib)
	{
		// return TRUE if the last hit was a head shot
		GP = GearPawn(TestPawn);
		if (GP != None && GP.bLastHitWasHeadShot)
		{
			return TRUE;
		}
	}
	return FALSE;
}

/** Should damage type ignore execution rules and allow ranged kill of DBNO enemy */
static function bool ShouldIgnoreExecutionRules( Pawn TestPawn, Pawn Instigator )
{
	return (default.bAllowHeadShotExecution && ShouldHeadShotGib(TestPawn, Instigator)) || ShouldGib(TestPawn, Instigator);
}

/** Should the Pawn transition to DBNO when killed with this damage type? */
static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	local GearPawn GP;
	GP = GearPawn(TestPawn);
	if (GP != None)
	{
		// make sure the pawn support DBNO at all
		if (!GP.bCanDBNO)
		{
			return FALSE;
		}
		// if we don't want to DBNO right now stop checking
		if (!GP.WantsToDBNO(Instigator,HitLocation,HitInfo))
		{
			return FALSE;
		}
		// check for the revive limit in multiplayer
		//`log(GetFuncName()@"MaxDownCount:"@GP.GetMaxDownCount());
		if ( GP.GetMaxDownCount() >= 0 && GP.DownCount >= GP.GetMaxDownCount() )
		{
			return FALSE;
		}
		// make sure we're not expecting a headshot gib instead of DBNO
		if (default.HeadShotDamageScale != 1.f && GP.bLastHitWasHeadShot && default.bAllowHeadShotExecution)
		{
			return FALSE;
		}
	}
	return TRUE;
}

/** @return whether we should check for headshots from damage of this type */
static function bool ShouldCheckHeadShot(Controller InstigatedBy)
{
	return ( (default.HeadShotDamageScale != 1.f || default.bForceHeadShotCheck) &&
		(GearAI(InstigatedBy) == None || GearAI(InstigatedBy).bCanHeadshot) );
}

/** @return headshot damage modifier **/
static function float GetHeadShotDamageModifier( byte bHasHelmet, GearPawn InstigatedGP )
{
	local float DamageModifier;

	DamageModifier = 1.f;

	if (default.HeadShotDamageScale != 1.f)
	{
		// if it has a helmet then negate damage (except if active reload bonus is active)
		if (bHasHelmet == 1 && (InstigatedGP == None || !InstigatedGP.bActiveReloadBonusActive))
		{
			// scale down the headshot damage scale slightly
			DamageModifier = 1.f + ((default.HeadshotDamageScale - 1.f) * 0.5f);
		}
		else
		{
			// otherwise scale the crap out of it
			DamageModifier = default.HeadShotDamageScale;
		}
	}

	return DamageModifier;
}

/** Called when a Pawn receives damage of this type, allows special case modifications (default implementation handles head shots) */
static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	local GearPawn GP, InstigatedGP;
	local byte bHasHelmet;
	local int BodyIndex;
	local GearPC GPC;
	local float CompensationFactor;

	GP = GearPawn(Victim);
	if (GP != None)
	{
		InstigatedGP = InstigatedBy != None ? GearPawn(InstigatedBy.Pawn) : None;
		bHasHelmet = 0;
		GP.bLastHitWasHeadShot = false;
		if (ShouldCheckHeadShot(InstigatedBy))
		{
			// head shot damage scaling
			if (GP.TookHeadShot(HitInfo.BoneName,HitLocation,Momentum,bHasHelmet))
			{
				Damage *= GetHeadShotDamageModifier(bHasHelmet, InstigatedGP);
				GP.bLastHitWasHeadShot = true;
			}
		}

		// flappy bit damage ignore
		if( GP.Mesh != None && GP.Mesh.PhysicsAsset != None )
		{
			BodyIndex = GP.Mesh.PhysicsAsset.FindBodyIndex(HitInfo.BoneName);
			if( BodyIndex != INDEX_NONE &&  GP.Mesh.PhysicsAsset.BodySetup[BodyIndex].bAlwaysFullAnimWeight )
			{
				`log("Hitting a bAlwaysFullAnimWeight physics body, ignoring damage");
				Damage = 0;
			}
		}

		if(default.bCompensateDamageForDifficulty)
		{
			GPC = GearPC(GP.Controller);
			if(GPC != none && !GP.WorldInfo.GRI.IsMultiplayerGame())
			{
				CompensationFactor = GearPRI(GPC.PlayerReplicationInfo).Difficulty.default.PlayerHealthMod / class'DifficultySettings_Hardcore'.default.PlayerHealthMod;
				//`log(GetFuncName()@Victim@Damage@"Compensating damage for difficulty!"@default.class@Damage * CompensationFactor @ GearPRI(GPC.PlayerReplicationInfo).Difficulty.default.PlayerHealthMod@GearPRI(GPC.PlayerReplicationInfo).Difficulty);
				Damage *= CompensationFactor;
			}
		}
	}
}

/** Called when a Pawn is killed with this damage type */
static function HandleKilledPawn(Pawn KilledPawn, Pawn Instigator);

/** Called on all clients when a pawn dies by this damage type */
static function HandleDeathFX(GearPawn DeadPawn);

/** Called when a Pawn is knocked DBNO with this damage type */
static function HandleDBNOPawn(Pawn DBNOPawn);

/**
 * Called when a Pawn is hurt with this damage type, after the damage has been applied.  Server side only.
 */
static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, vector Momentum);

/**
 * Called on all clients when a pawn has taken damage, used to kick off damage type specific FX.
 */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	local GearPC PC;
	local float	ShakeScale;
	local bool bDoPainFX;
	local HitStruct             TheHit;

	if ( DamagedPawn.WorldInfo.Netmode == NM_DedicatedServer )
	{
		return;
	}

	TheHit.Damage = HitInfo.Damage;
	TheHit.Time = DamagedPawn.WorldInfo.TimeSeconds;

	DamagedPawn.RecentHits.AddItem(TheHit);

	bDoPainFX = (DamagedPawn.WorldInfo.TimeSeconds - DamagedPawn.LastPainTime > 0.95f);

	PC = DamagedPawn.GetPC();
	if (PC != None && PC.IsLocalPlayerController())
	{
		// Don't send hit locator data if the instigator is too close or null
		if ( HitInfo.InstigatedBy != None && (VSizeSq(HitInfo.InstigatedBy.Location - DamagedPawn.Location) > (DamagedPawn.GetCollisionRadius() * DamagedPawn.GetCollisionRadius())) )
		{
			// add the hud hit indicator
			PC.MyGearHUD.AddNewHitLocatorData(HitInfo.InstigatedBy, HitInfo.Damage, default.bUseLocationForIndicator ? HitInfo.HitLocation : vect(0,0,0));
		}

		// do time-limited pain effects
		if (bDoPainFX)
		{
			if (!DamagedPawn.bIgnoreDamageShakes)
			{
				// do a lil' camera shake
				// figure out the scale based on percent of total health damaged
				ShakeScale = FClamp((HitInfo.Damage/float(DamagedPawn.DefaultHealth))*default.OnDamageCameraShakeScale, 0.15f, 1.f);

				// apply the camera shake(s)
				if (default.OnDamageCameraShake != None)
				{
					PC.ClientPlayCameraShake(default.OnDamageCameraShake, ShakeScale);
				}
			}

			if( ShouldPlayForceFeedback( DamagedPawn ) )
			{
				// fire off the damage waveform
				PC.ClientPlayForceFeedbackWaveform(default.DamagedFFWaveform);
			}
		}
	}

	if (bDoPainFX)
	{
		// let me hear you say "ungh", nanananana
		if (!DamagedPawn.bPlayedDeath && DamagedPawn.WorldInfo.NetMode != NM_DedicatedServer)
		{
			DamagedPawn.SoundGroup.PlayDamageEffort(DamagedPawn, HitInfo.Damage);
		}

		DamagedPawn.LastPainTime = DamagedPawn.WorldInfo.TimeSeconds;
	}
}

static function bool ShouldPlayForceFeedback( Pawn DamagedPawn )
{
	return TRUE;
}

static function bool IsScriptedDamageType()
{
	return FALSE;
}

static function HandleDeadPlayer(GearPC Player);

defaultproperties
{
	bSuppressImpactFX=FALSE
	bSuppressPlayExplosiveRadialDamageEffects=FALSE

	MeatshieldProtecionScale=1.f

	// feedback
	KillGUDEvent=GUDEvent_KilledEnemyGeneric
	DeathScreamEffortID=GearEffort_DeathScream

	// camera shake
	Begin Object Class=CameraShake Name=OnDamageCameraShake0
		OscillationDuration=0.67f
		RotOscillation={(Pitch=(Amplitude=-2000,Frequency=10),
						Yaw=(Amplitude=500,Frequency=10),
						Roll=(Amplitude=200,Frequency=10))}
	End Object
	OnDamageCameraShake=OnDamageCameraShake0
	OnDamageCameraShakeScale=5.f

	// Short "pop" of damage
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform0
		Samples(0)=(LeftAmplitude=64,RightAmplitude=96,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.25)
	End Object
	DamagedFFWaveform=ForceFeedbackWaveform0

	// Pretty violent rumble
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform1
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.75)
	End Object
	KilledFFWaveform=ForceFeedbackWaveform1
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=120,UL=77,VL=29)
	HeadshotIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=78,V=30,UL=77,VL=29)
	IconScale=1.f

	bSuicidePenalty=true

	// This is a hack.  The Stats system uses weapon id to determine what weapon did damage.  We default to an impossible id and reject anything
	// we see with this.
	WeaponID=WC_MAX

	GibExplodeSound=SoundCue'Foley_Flesh.Flesh.GibBodyExplodeCue'
}
