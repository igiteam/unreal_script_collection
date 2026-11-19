/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_SemiAutoPistol extends NanoWeap_PistolBase;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Pistol5'
		PhysicsAsset=PhysicsAsset'Weapon_Proto.Meshes.SK_WeaponProto_Pistol5_Physics'
	End Object

	InstantHitDamageTypes(0)=class'NDT_Pistol_SemiAutoPistol'

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_Pistols.Colt1911.Pistol_Colt1911_NPC_Fire_Cue'
	FireSound_Player=SoundCue'Weapon_Pistols.Colt1911.Pistol_Colt1911_Fire_Cue'

	EndFireSound=None
	EndFireSound_Player=None
}