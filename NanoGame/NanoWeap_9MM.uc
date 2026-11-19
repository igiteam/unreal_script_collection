/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_9MM extends NanoWeap_MP7;





defaultproperties
{
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'Weapon_Proto.Meshes.SK_WeaponProto_Colt45'
		PhysicsAsset=PhysicsAsset'Weapon_Proto.Meshes.SK_WeaponProto_Colt45_Physics'
	End Object

	TracerType=WTT_ShortBullet

	FireSound=SoundCue'Weapon_Pistol.Pistol.9mmShot'
	FireSound_Player=SoundCue'Weapon_Pistol.Pistol.9mmShot'

	EndFireSound=None
	EndFireSound_Player=None


	// prob should get a better tracer

}


