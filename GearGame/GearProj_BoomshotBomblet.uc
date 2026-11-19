/**
 * Boomshot Bomblet Weapon Projectile (emitted by GearProj_Boomshot, like a cluster bomb).
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_BoomshotBomblet extends GearProj_BoomshotBombletBase
	config(Weapon);

defaultproperties
{
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'Locust_Boomshot.locust_boomshot_ammo2'
	End Object

	// explosion
	Begin Object Name=ExploTemplate0
		ContentTemplate=GearExplosionContent'GearExplosion_Arch.Weapon.BoomShot.BoomshotBomblet_Proj_Explo'

		bAllowPerMaterialFX=false
		bParticleSystemIsBeingOverriddenDontUsePhysMatVersion=true
	End Object
}


