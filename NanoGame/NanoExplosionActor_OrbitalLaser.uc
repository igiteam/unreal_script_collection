/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoExplosionActor_OrbitalLaser extends NanoExplosionActor;

/** Defines the explosion. */
var() instanced editinline NanoExplosion	ExploTemplate;
var() Vector	ExploDir;

function Init( NanoWeap_Orbital_Laser Weap, Vector ExploLoc, Vector ExploNorm, float Delay )
{
	Instigator = Weap.Instigator;
	InstigatorController = Weap.Instigator.Controller;

	ExploTemplate.Damage = Weap.ExploDamage;
	ExploTemplate.DamageRadius = Weap.ExploDamageRadius;
	ExploTemplate.DamageFalloffExponent = Weap.ExploDamageFalloffExp;
	if( Weap.bSuppressDamage )
	{
		ExploTemplate.Damage = 0.f;
	}
	ExploTemplate.DamageDelay = Weap.DelayBeforeTriggerDamage;

	// these are needed for the decal tracing later in NanoExplosionActor.Explode()
	ExploTemplate.HitActor		= None;
	ExploTemplate.HitLocation	= ExploLoc;
	ExploTemplate.HitNormal		= ExploNorm;

	ExploDir = Vector(Instigator.Rotation);

	SetTimer( FMax( Delay, 0.1 ), FALSE, nameof(DelayedExplosionTimerExpired) );
}

function DelayedExplosionTimerExpired()
{
	Explode( ExploTemplate, ExploDir );
}

defaultproperties
{	
	// explosion
	Begin Object Class=NanoExplosion Name=ExploTemplate0
		ParticleEmitterTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileExplosion_01'
		ExplosionSound=SoundCue'Weapon_Pistol.Pistol.Pistol_FirePlayer_Cue'

		MyDamageType=class'NDT_Bomb'
		MomentumTransferScale=1.f	// Scale momentum defined in DamageType
	End Object
	ExploTemplate=ExploTemplate0
}