/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Tavor extends NanoWeapon;



simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	Super.AttachWeaponTo(MeshCpnt, SocketName);
}


simulated function DetachWeapon()
{
	Super.DetachWeapon();
}




defaultproperties
{
	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'REB_SMG.SK_REB_SMG'
		PhysicsAsset=PhysicsAsset'REB_SMG.SK_REB_SMG_Physics'
		//AnimTreeTemplate=AnimTree'COG_AssaultRifle.AT_COG_AssaultRifle'
		//AnimSets(0)=AnimSet'COG_AssaultRifle.Animations.COG_AssaultRifle'
	End Object
	Mesh=WeaponMeshComp


	FireInterval(0)=+0.250f

}