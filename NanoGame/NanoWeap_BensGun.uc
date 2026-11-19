/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_BensGun extends NanoWeap_PistolBase;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Pistol8'
		PhysicsAsset=PhysicsAsset'Weapon_Proto.Meshes.SK_WeaponProto_Pistol8_Physics'
	End Object

	InstantHitDamageTypes(0)=class'NDT_Pistol_BensGun'

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_Pistols.357Magnum.Pistol_357magnum_Fire_Cue'
	FireSound_Player=SoundCue'Weapon_Pistols.357Magnum.Pistol_357magnum_Fire_Cue'

	EndFireSound=None
	EndFireSound_Player=None
}