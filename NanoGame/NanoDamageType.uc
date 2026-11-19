/**
 * This class is the base class for Nano damage types
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoDamageType extends DamageType
	native
	config(Weapon)
	abstract
	dependson(NanoTypes);


// this should be promoted to GameFramework. 


/** FXInfo IDs for phys material based effects */
var const EImpactTypeBallistic ImpactTypeBallisticID;
var const EImpactTypeExplosion ImpactTypeExplosionID;


/** ==== General damage attributes ==== */

/** Amount to scale Damage in the event of a head shot (0.f == no head shots) */
var const config float HeadShotDamageScale;

/** Chance a shot from this damage type will remove a helmet */
var const config float HelmetRemovalChance;

/** If this weapon does head shots, is it allowed to skip DBNO and execute the player immediately? */
var const config bool bAllowHeadShotExecution;

/** Stopping power of this damage type, MovementPct per damage. */
var const config float StoppingPower;





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




/** ==== Feedback related attributes ==== */


// MOVE THESE

/** Take Damage Camera Shake */
var() protected NanoCameraShake OnDamageCameraShake;

/** Scale properties of the screenshake based on the amount of damage taken in relation to the total health of our pawn */
var() protected float OnDamageCameraShakeScale;



//var() const NanoVoiceEffortID		DeathScreamEffortID;

/** Use the location for the hit indicator rather than the updated actor location. */
var config bool bUseLocationForIndicator;

/** @STATS -- Holds the tag that associated this damage type with a weapon type */
var EWeaponClass WeaponID;

/** when this is enabled, damage will be scaled proportionately to the player health scalar, so that it will do the same amount of proportionate damage across all difficulty levels */
var config bool bCompensateDamageForDifficulty;




/** ==== JUGGLE related attributes ==== */
var config float JuggleMag;
/** How much Z boost to give if falling when hit by this damage type */
var config float JuggleZ;


/** This is the material that should be used for the damage overlay when hit by this damage type **/
var const MaterialInterface MI_DamageOverlay;

/** This is the sound to play when you are damaged by this DamageType **/
var const SoundCue ExtraSoundToPlayWhenDamaged;

/** TRUE if this damage type come from the 'environment' and not a weapon */
var const bool bEnvironmentalDamage;

/** If TRUE, play a high kick death animation. Suitable for explosives, or high kick weapons such as shotguns */
var const config bool bHighKickDeathAnimation;

/** When this is TRUE, it forces a straight rag doll death, without playing death animations, nor motorized physics. */
var const bool bForceRagdollDeath;

/** When bShouldGib is set, DistFromHitLocToGib creates a cylinder of influence around the HitLocation, along the HitDirection,
* And any constraints within that cylinder will be broken.	 Default value of -1.f breaks the whole body. */
var const config float DistFromHitLocToGib;


/** Killed by Icon **/
var const CanvasIcon KilledByIcon;
var const CanvasIcon HeadshotIcon;
var const float IconScale;

/**
 * This is the Damage Type's suppress impact effects bool
 * Some weapons such should not play impact effects.
 **/
var const bool bSuppressImpactFX;

/**
 * This is the Damage Type's suppress blood decals
 * Some weapons are so expensive that we don't want to have more costs associated with them per frame
 **/
var const bool bSuppressBloodDecals;

/**
 * Some explosion particle systems already have the blood and guts inside the Explosion so we do not want to play the additional
 * effect.
 **/
var const bool bSuppressPlayExplosiveRadialDamageEffects;

/** If this weapon does head shots, is it capable of knocking the head off entirely for the special death? */
var const config bool bAllowHeadShotGib;


//// Damage modifiers based on where you / what state the foe was hit in
var config float KnockedDownDamageMultiplier;

var config float FlankAttackDamageMultiplier;
var config float FromBehindDamageMultiplier;

var config float HeadShotAttackDamageMultiplier;




/** Should the Pawn explode into chunky bits when killed with this damage type? */
static function PlayExtraDamageSound( Pawn VictimPawn )
{
	if( default.ExtraSoundToPlayWhenDamaged != none )
	{
		VictimPawn.PlaySound( default.ExtraSoundToPlayWhenDamaged );
	}
}


/** Should the Pawn explode into chunky bits when killed with this damage type? */
static function bool ShouldGib( Pawn TestPawn, Pawn Instigator )
{
	return FALSE;
}


static function bool ShouldPlayForceFeedback( Pawn DamagedPawn )
{
	return TRUE;
}


/**
 * Called when a Pawn is hurt with this damage type, after the damage has been applied.  Server side  only.
 */
static function HandleDamagedPawn( Pawn DamagedPawn, Pawn Instigator, int DamageAmt, vector Momentum );

/** Called when a Pawn receives damage of this type, allows special case modifications (default implementation handles head shots) */
static function ModifyDamage( Pawn Victim, Controller InstigatedBy, out int out_Damage, out vector out_Momentum, vector HitLocation, TraceHitInfo HitInfo )
{
	local NanoPawn	NP, InstigatedNP;
	local byte		bHasHelmet;
	local INT		BodyIndex;
	local NanoPC	NPC;
	local float		CompensationFactor;

	NP = NanoPawn(Victim);
	if (NP != None)
	{
		InstigatedNP = InstigatedBy != None ? NanoPawn(InstigatedBy.Pawn) : None;
		bHasHelmet = 0;
		NP.bLastHitWasHeadShot = FALSE;
		if (default.HeadShotDamageScale != 1.f )
		{
			// head shot damage scaling
			if (NP.TookHeadShot(HitInfo.BoneName,HitLocation,out_Momentum,bHasHelmet))
			{
				// if it has a helmet then negate damage (except if active reload bonus is active)
				if (bHasHelmet == 1 && (InstigatedNP == None || !InstigatedNP.bActiveReloadBonusActive))
				{
					// scale down the headshot damage scale slightly
					out_Damage *= 1.f + ((default.HeadshotDamageScale - 1.f) * 0.5f);
				}
				else
				{
					// otherwise scale the crap out of it
					out_Damage *= default.HeadShotDamageScale;
				}
				NP.bLastHitWasHeadShot = TRUE;
			}
		}

		// flappy bit damage ignore
		if( NP.Mesh != None && NP.Mesh.PhysicsAsset != None )
		{
			BodyIndex = NP.Mesh.PhysicsAsset.FindBodyIndex(HitInfo.BoneName);
			if( BodyIndex != INDEX_NONE &&  NP.Mesh.PhysicsAsset.BodySetup[BodyIndex].bAlwaysFullAnimWeight )
			{
				out_Damage = 0;
			}
		}

		if(default.bCompensateDamageForDifficulty)
		{
			NPC = NanoPC(NP.Controller);
			if(NPC != none && !NP.WorldInfo.GRI.IsMultiplayerGame())
			{
				//CompensationFactor = NanoPRI(NPC.PlayerReplicationInfo).Difficulty.default.PlayerHealthMod / class'DifficultySettings_Hardcore'.default.PlayerHealthMod;
				//`log(GetFuncName()@Victim@out_Damage@"Compensating damage for difficulty!"@default.class@out_Damage * CompensationFactor @ NanoPRI(NPC.PlayerReplicationInfo).Difficulty.default.PlayerHealthMod@NanoPRI(NPC.PlayerReplicationInfo).Difficulty);
				out_Damage *= CompensationFactor;
			}
		}
	}
}



defaultproperties
{
	bCausesFracture=TRUE

	bSuppressImpactFX=FALSE
	bSuppressPlayExplosiveRadialDamageEffects=FALSE

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
	

	MI_DamageOverlay=MaterialInterface'Nano_PostProcess.PPMI_GenericDamageOverlay';
}


