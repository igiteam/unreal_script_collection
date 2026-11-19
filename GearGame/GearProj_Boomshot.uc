/**
 * Boomer Weapon Projectile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_Boomshot extends GearProj_BoomshotBase
	config(Weapon);

defaultproperties
{
	BombletClass=class'GearProj_BoomshotBomblet'

	TrailTemplate=ParticleSystem'Locust_Boomshot.Effects.P_Boomshot_smoke_trail'

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'Locust_Boomshot.locust_boomshot_ammo2'
	End Object

	InFlightSoundTemplate=SoundCue'Weapon_Boomer.Firing.BoomerInAirLoopCue'
	HitPawnExplosionTemplate=ParticleSystem'Locust_Boomshot.Effects.P_Boomshot_Explo_Main_Gib'
	HitPawnExplosionNoGoreTemplate=ParticleSystem'Locust_Boomshot.Effects.P_Boomshot_Explo_Main_Gib_NOGORE'

	// explosion
	Begin Object Name=ExploTemplate0
		ContentTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.BoomShot.Boomshot_Proj_Explo'
	End Object
}


