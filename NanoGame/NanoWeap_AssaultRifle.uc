/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_AssaultRifle extends NanoWeap_MP7;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Assault'
		PhysicsAsset=PhysicsAsset'Weapon_Proto2.Meshes.SK_WeaponProto_Assault_Physics'
	End Object

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireEnemyCue'
	FireSound_Player=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFirePlayerCue'

	EndFireSound=None
	EndFireSound_Player=None
}