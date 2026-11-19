/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_HoldOutPistol extends NanoWeap_PistolBase;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Pistol1'
		PhysicsAsset=PhysicsAsset'Weapon_Proto.Meshes.SK_WeaponProto_Pistol1_Physics'
	End Object

	InstantHitDamageTypes(0)=class'NDT_Pistol_HoldOutPistol'

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_Pistols.Beretta.Pistol_Beretta_NPC_Fire_Cue'
	FireSound_Player=SoundCue'Weapon_Pistols.Beretta.Pistol_Beretta_Fire_Cue'

	EndFireSound=None
	EndFireSound_Player=None
}