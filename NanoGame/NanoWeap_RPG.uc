/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_RPG extends NanoWeap_MP7;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_RocketLauncher'
		PhysicsAsset=PhysicsAsset'Weapon_Proto2.Meshes.SK_WeaponProto_RocketLauncher_Physics'
	End Object

	FireSound=SoundCue'Weapon_Boomer.Firing.BoomerFireCue'
	FireSound_Player=SoundCue'Weapon_Boomer.Firing.BoomerFirePlayerCue'

}