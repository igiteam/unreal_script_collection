/**
 * Pacifier Bot Chassis Weapon - used for stomp attack
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Pacifier_Chassis extends NanoWeap_Pacifier_Base;

/** Amount of delay before explosion damage is done */
var() protected config float		DelayBeforeTriggerDamage;
/** Amount of damage done at the epicenter. */
var() protected config float		ExploDamage;
/** Damage range. */
var() protected const config float	ExploDamageRadius;
/** Defines how damage falls off.  High numbers cause faster falloff, lower (closer to zero) cause slower falloff.  1 is linear. */
var() protected const config float	ExploDamageFalloffExp;

var() array<float>	ExplosionTime;
var() int			ExplosionCnt;


/** Defines the explosion. */
var() instanced editinline NanoExplosion	ExplosionTemplate;


simulated state WeaponFiring
{
	simulated event BeginState( Name PreviousStateName )
	{
		ExplosionCnt = 0;
		SetTimer( ExplosionTime[ExplosionCnt], FALSE, nameof(CustomFire) );

		Limb.Bot.FullBodyNode.SetActiveChild( 2, 0.2f );
		Limb.Bot.Controller.MoveTimer = -1.f;
		Limb.Bot.ZeroMovementVariables();

		TimeWeaponFiring( CurrentFireMode );
	}


	simulated function EndState( Name NextStateName )
	{
		ClearTimer( nameof(CustomFire) );
		Limb.Bot.FullBodyNode.SetActiveChild( 0, 0.2f );

		Super.EndState( NextStateName );
	}

	// Extension happened without grabbing - just go back to active state
	simulated function RefireCheckTimer()
	{
		local float DelayFinish;

		DelayFinish = GetDelayFinishFiringTime();
		if( DelayFinish <= 0.f )
		{
			HandleFinishedFiring();
		}
		else
		{
			ClearTimer(nameof(RefireCheckTimer));
			ClearTimer(nameof(DelayedBurstFire));
			SetTimer( DelayFinish, FALSE, nameof(DelayFinishedFiring) );
		}
	}


	/** Returns values for radial damage. */
	simulated protected function GetRadialDamageValues(out float outDamage, out float outRadius, out float outFalloff)
	{
		local float DamageScale, RadScale;

		DamageScale = 1.f;
		RadScale = 1.f;

		outDamage = ExploDamage * DamageScale;
		outRadius = ExploDamageRadius * RadScale;
		outFalloff = ExploDamageFalloffExp;
	}

	simulated function PrepareExplosionTemplate()
	{
		GetRadialDamageValues(ExplosionTemplate.Damage, ExplosionTemplate.DamageRadius, ExplosionTemplate.DamageFalloffExponent);

		if( bSuppressDamage)
		{
			ExplosionTemplate.Damage = 0.f;
		}

		ExplosionTemplate.DamageDelay = DelayBeforeTriggerDamage;
	}


	simulated function CustomFire()
	{
		local NanoExplosionActor ExplosionActor;

		ExplosionActor = Spawn(class'NanoExplosionActor',,, Instigator.Location, Rotator(vect(0,0,1)));
		if( ExplosionActor != None )
		{
			ExplosionActor.Instigator = Instigator;
			ExplosionActor.InstigatorController = Instigator.Controller;

			PrepareExplosionTemplate();

			// these are needed for the decal tracing later in NanoExplosionActor.Explode()
			ExplosionTemplate.HitActor		= Instigator.Base;
			ExplosionTemplate.HitLocation	= Instigator.Location;
			ExplosionTemplate.HitNormal		= vect(0,0,1);

			// If desired, attach to mover if we hit one
			if( InterpActor(Instigator.Base) != None )
			{
				ExplosionActor.Attachee = Instigator.Base;
				ExplosionTemplate.bAttachExplosionEmitterToAttachee = TRUE;
				ExplosionActor.SetBase(Instigator.Base);
			}

			ExplosionActor.Explode(ExplosionTemplate);
		}

		ExplosionCnt++;
		if( ExplosionCnt < ExplosionTime.Length )
		{
			SetTimer( ExplosionTime[ExplosionCnt], FALSE, nameof(CustomFire) );
		}

		WeaponFired(CurrentFireMode);
	}
}


defaultproperties
{
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	Spread(0)=0.05f
	WeaponProjectiles(0)=None
	InstantHitDamageTypes(0)=class'NDT_Bomb'
	InstantHitDamage(0)=0.0f
	InstantHitMomentum(0)=0.0f
	FireInterval(0)=+2.6f

	// explosion
	Begin Object Class=NanoExplosion Name=ExploTemplate0
		ParticleEmitterTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileExplosion_01'
		ExplosionSound=SoundCue'Weapon_Pistol.Pistol.Pistol_FirePlayer_Cue'

		MyDamageType=class'NDT_Bomb'
		MomentumTransferScale=1.f	// Scale momentum defined in DamageType
	End Object
	ExplosionTemplate=ExploTemplate0

	ExplosionTime(0)=1.25f
	ExplosionTime(1)=0.47f
	ExplosionTime(2)=0.47f
}
