/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoBomb extends NanoBombBase;




defaultproperties
{

	// Weapon SkeletalMesh
	Begin Object Class=SkeletalMeshComponent Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'COG_Mortar.Mesh.Mortar_Shell'
		PhysicsAsset=PhysicsAsset'COG_Mortar.Mesh.Mortar_Shell_Physics'
		Rotation=(Pitch=0,Yaw=0,Roll=-16384)
		Scale=3.0f
		bUpdateSkelWhenNotRendered=FALSE
	End Object
	BombMesh=WeaponMeshComp
	Components.Add(WeaponMeshComp)

	Begin Object Class=NanoParticleSystemComponent Name=ParticleSystemComponent0
	    Template=ParticleSystem'COG_Mortar.Effects.P_Mortar_Ground_Explosion_Stone'
		bAutoActivate=FALSE
		Scale=10.0f
	End Object
	ExplosionParticleSystemComponent=ParticleSystemComponent0
	Components.Add(ParticleSystemComponent0)
	

	Begin Object Class=RB_RadialImpulseComponent Name=NanoBombImpulseComp
	    ImpulseRadius=4096.0f
		ImpulseStrength=768.0f
		bVelChange=TRUE
		ImpulseFalloff=RIF_Constant
	End Object
	NanoBombImpulse=NanoBombImpulseComp
	Components.Add(NanoBombImpulseComp)



	// for now just leave these around for 30 seconds
	LifeSpan=300.0f
}