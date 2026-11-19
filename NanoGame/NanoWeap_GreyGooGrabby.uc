/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_GreyGooGrabby extends NanoWeap_GreyGooGrabbyBase;





defaultproperties
{
	FireInterval(0)=+0.150f
	GrabbyAreaClass=class'NanoGrabbyArea'

	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'COG_Bolo_Grenade.Smoke_Grenade'
		PhysicsAsset=PhysicsAsset'COG_Bolo_Grenade.Smoke_Grenade_Physics'
		AnimTreeTemplate=AnimTree'COG_Bolo_Grenade.Animations.AT_BoloGrenade'
		AnimSets(0)=AnimSet'COG_Bolo_Grenade.GrenadeAnims'
		Rotation=(Pitch=0,Yaw=0,Roll=-16384)
		Scale=0.3f
	End Object
	Mesh=WeaponMeshComp


	bAllowTracers=FALSE
}