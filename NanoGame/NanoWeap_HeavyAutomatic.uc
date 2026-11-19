/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_HeavyAutomatic extends NanoWeap_PistolBase;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Pistol7'
		PhysicsAsset=PhysicsAsset'Weapon_Proto.Meshes.SK_WeaponProto_Pistol7_Physics'
	End Object

		InstantHitDamageTypes(0)=class'NDT_Pistol_HeavyAutomatic'

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_Pistols.DesertEagle.Pistol_DesertEagle_Fire_Cue'
	FireSound_Player=SoundCue'Weapon_Pistols.DesertEagle.Pistol_DesertEagle_Fire_Cue'

	EndFireSound=None
	EndFireSound_Player=None
}