/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_SnubNoseRevolver extends NanoWeap_PistolBase;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Pistol2'
		PhysicsAsset=PhysicsAsset'Weapon_Proto.Meshes.SK_WeaponProto_Pistol2_Physics'
	End Object

	InstantHitDamageTypes(0)=class'NDT_Pistol_SnubNoseRevolver'

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_Pistols.38.Pistol_38_Fire_Cue'
	FireSound_Player=SoundCue'Weapon_Pistols.38.Pistol_38_Fire_Cue'

	EndFireSound=None
	EndFireSound_Player=None
}