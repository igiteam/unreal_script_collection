/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_LookerGun extends NanoWeap_PistolBase;



defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Pistol6'
		PhysicsAsset=PhysicsAsset'Weapon_Proto.Meshes.SK_WeaponProto_Pistol6_Physics'
	End Object

	InstantHitDamageTypes(0)=class'NDT_Pistol_LookerGun'

	TracerType=WTT_ShortBullet

	//Also, for the electronic/electric weapons, I have two 1-second powerup sounds we can use if needed:
	//SoundCue'Weapon_Pistols.Looker.Pistol_ElectricPowerup_01_Cue'
	//SoundCue'Weapon_Pistols.Looker.Pistol_ElectricPowerup_02_Cue'

	FireSound=SoundCue'Weapon_Pistols.Looker.Pistol_Looker_Fire_Cue'
	FireSound_Player=SoundCue'Weapon_Pistols.Looker.Pistol_Looker_Fire_Cue'
 
	EndFireSound=None
	EndFireSound_Player=None
}