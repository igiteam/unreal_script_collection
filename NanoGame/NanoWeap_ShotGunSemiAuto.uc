/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_ShotGunSemiAuto extends NanoWeap_MP7;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Shotgun'
		PhysicsAsset=PhysicsAsset'Weapon_Proto2.Meshes.SK_WeaponProto_Shotgun_Physics'
	End Object

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_Shotgun.Firing.ShotgunFireCue'
	FireSound_Player=SoundCue'Weapon_Shotgun.Shotgun.ShotgunFirePlayerCue'

	EndFireSound=None
	EndFireSound_Player=None
}