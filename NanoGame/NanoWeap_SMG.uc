/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_SMG extends NanoWeap_MP7;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_SMG'
		PhysicsAsset=PhysicsAsset'Weapon_Proto2.Meshes.SK_WeaponProto_SMG_Physics'
	End Object

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_AssaultRifle.LocustAssault.LocustARifleFireEnemyCue'
	FireSound_Player=SoundCue'Weapon_AssaultRifle.LocustAssault.LocustARifleFirePlayerCue'

	EndFireSound=None
	EndFireSound_Player=None
}