/**
 * GearProj_Arrow
 * Projectile tailored for Torque Bow weapon.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_Arrow extends GearProj_ArrowBase
	config(Weapon);

defaultproperties
{
	ImpactSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_ArrowImpactWallCue'
	ImpactFleshSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_ArrowImpactFleshCue'
	ImpactStickSound=SoundCue'Weapon_Grenade.Actions.GrenadeStick01Cue'
	RicochetSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_ArrowImpactRicochetCue'
	BounceSound=SoundCue'Weapon_Grenade.Impacts.GrenadeBounceCue'

	Begin Object Name=StaticMeshComponent0
    		StaticMesh=StaticMesh'Locust_Torquebow.Locust_Torquebow_Rocket'
	End Object

	Begin Object Name=CollisionCylinder
		CollideActors=true
	End Object

	TrailTemplate=ParticleSystem'Locust_Torquebow.EffectS.P_Torquebow_Arrow_Trail'
	InFlightSoundTemplate=None


	PS_ArrowImpactEffect=ParticleSystem'Locust_Torquebow.Effects.PS_Torquebow_Impact'
	PS_ArrowImpactEffectHuman=ParticleSystem'Locust_Torquebow.Effects.P_Torquebow_Sparks'

	StuckInPawnExplosionTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.TorqueBow.Arrow_In_Player_Explo'
	StuckInPawnExplosionTemplateLambent=GearExplosionContent'GearExplosion_Arch.Weapon.TorqueBow.Arrow_In_Player_Lambent_Explo'
	StuckInPawnExplosionNoGoreTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.TorqueBow.Arrow_In_Player_Explo_NO_GORE'
	StuckInPawnExplosionSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_ExplosionBodyCue'

	InAirExplosionEmitterTemplate=ParticleSystem'Locust_Torquebow.EffectS.P_Torquebow_Impact_Explo_Stuck_In'
	InAirExplosionSound=SoundCue'Weapon_TorqueBow.Weapons.Crossbow_ExplosionCue'

	// explosion
	Begin Object Name=ExploTemplate0
		ContentTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.TorqueBow.Arrow_Proj_Explo'
	End Object
}
