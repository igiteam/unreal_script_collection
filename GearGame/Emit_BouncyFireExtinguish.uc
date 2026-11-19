/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Emit_BouncyFireExtinguish extends ReplicatedSpawnedGearEmitter
	notplaceable;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	PlaySound(SoundCue'Weapon_Grenade.IncendiaryGrenade.IncendiaryGrenade_WaterPuffExtinguish_Cue',,, false);
}

defaultproperties
{
	ParticleSystem=ParticleSystem'COG_IncendiaryGrenade.Effects.P_Incendiary_Body_Burn_Extinguish'
	bDestroyOnSystemFinish=true
	LifeSpan=10
}
