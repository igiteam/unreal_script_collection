/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_ShotGunRevolver extends NanoWeap_PistolBase;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Pistol4'
		PhysicsAsset=PhysicsAsset'Weapon_Proto.Meshes.SK_WeaponProto_Pistol4_Physics'
	End Object

	InstantHitDamageTypes(0)=class'NDT_Pistol_ShotGunRevolver'

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_Pistols.Judge.Pistol_Judge_Fire_Cue'
	FireSound_Player=SoundCue'Weapon_Pistols.Judge.Pistol_Judge_Fire_Cue'

	EndFireSound=None
	EndFireSound_Player=None
}