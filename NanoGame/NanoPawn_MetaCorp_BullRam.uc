/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_BullRam extends NanoPawn_MetaCorp_BullRamBase;

function ParticleSystem GetImpactOverrideParticleSystem()
{
	return ParticleSystem'Nano_Effects_Sentry_Turret.Impact.BullRamSparks';
}


defaultproperties
{
	ControllerClass=class'NanoAI_BullRam'
	TickGroup=TG_PostAsyncWork	

	//StaticMesh'HU_Deco7.SM.Mesh.S_HU_Deco_SM_BulletTrain_01'

// 	Begin Object Class=StaticMeshComponent Name=VehicleMeshComponent0
// 		StaticMesh=StaticMesh'MET_FlyingCar01.SM.Mesh.MET_FlyingCar01'
// 		//Rotation=(Yaw=-16384)
// 		
// 		RBChannel=RBCC_GameplayPhysics
// 		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE,Untitled2=TRUE,Untitled3=TRUE)
// 	    BlockRigidBody=TRUE
// 	    
// 		LightEnvironment=MyLightEnvironment
// 		bUsePrecomputedShadows=FALSE
// 		TickGroup=TG_PostAsyncWork
// 		
// 		CollideActors=TRUE
// 		BlockActors=TRUE
// 		BlockNonZeroExtent=TRUE
// 		BlockZeroExtent=TRUE
// 		CastShadow=FALSE
// 
// 		bNotifyRigidBodyCollision=TRUE
// 		ScriptRigidBodyCollisionThreshold=100.0
// 		//Scale3D=(X=0.5,Y=0.5,Z=0.5)
// 	End Object
// 	CollisionComponent=VehicleMeshComponent0
// 	VehicleMeshComponent=VehicleMeshComponent0
// 	Components.Add(VehicleMeshComponent0)

	// do we need a cylinder comp when we have the skelmesh above?
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0220.000000
		CollisionHeight=+0200.000000
		BlockZeroExtent=TRUE
	End Object



	Begin Object Class=SkeletalMeshComponent Name=BullRamArmL
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_ArmL_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamArmL)

	Begin Object Class=SkeletalMeshComponent Name=BullRamArmR
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_ArmR_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamArmR)

	Begin Object Class=SkeletalMeshComponent Name=BullRamBody
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_Body_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamBody)

	Begin Object Class=SkeletalMeshComponent Name=BullRamFrame
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_Frame_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamFrame)

	Begin Object Class=SkeletalMeshComponent Name=BullRamGuns
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_Guns_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamGuns)

	Begin Object Class=SkeletalMeshComponent Name=BullRamHead
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_Head_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamHead)

	Begin Object Class=SkeletalMeshComponent Name=BullRamHorns
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_Horns_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamHorns)

	Begin Object Class=SkeletalMeshComponent Name=BullRamLegsF
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_LegsF_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamLegsF)


	Begin Object Class=SkeletalMeshComponent Name=BullRamLegsR
	    SkeletalMesh=SkeletalMesh'MET_BullRam_Proto.SK.Nano_Bullram_LegsR_SK'
		Scale=0.5f

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(BullRamLegsR)



	StabAttachPos=(X=20.0,Y=0.0,Z=90.0)

	DeathEffect=ParticleSystem'MET_FlyingCar01.Effects.P_Nano_FlyingCar_Destruction'

	// lots of flags

	bBlockActors=TRUE	

	Buoyancy=+000.99000000
	UnderWaterTime=+00020.000000
	BaseEyeHeight=+00060.000000
	EyeHeight=+00060.000000
	CrouchHeight=+64.0
	CrouchRadius=+34.0
	GroundSpeed=400.0
	AirSpeed=+00200.000000

	WaterSpeed=+00300.000000
	AccelRate=+04096.000000
	JumpZ=+01024.000000
	MaxFallSpeed=+0900.0

	Begin Object Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=FALSE,DistancesToDrawIcon=(X=0,Y=0),Icon=Texture2D'UI_HUD.Minimap.EnemyBoss',IconScale=0.20f,IconColor=(R=255,G=64,B=64,A=255),bAlternateAboveBelowIcon=TRUE,AboveBelowIconScale=0.10f,TextName="",TextDescription="",TextVerticalOffset=0.0f)
	End Object
	UIComponent=UIIconComponent0

	DroppedOrbClasses.Add(class'NanoAbsorbOrb_BullRam')
	DroppedOrbClasses.Add(class'NanoAbsorbOrb_BullRam')
	DroppedOrbClasses.Add(class'NanoAbsorbOrb_CurrencySmall')
	DroppedOrbClasses.Add(class'NanoAbsorbOrb_CurrencyLarge')
	DroppedOrbClasses.Add(class'NanoAbsorbOrb_CurrencyLarge')


	DamageLightSocket="Damaged_Light"
	DamageMediumSocket="Damaged_Medium"
	DamageHeavySocket="Damaged_Heavy"
	DamageSparksSocket="Damaged_Sparks"

	// prob beed to add some sparks
	PS_Damaged_Light=ParticleSystem'AA_Test.Effects.PS_Fire_11'
	PS_Damaged_Medium=ParticleSystem'AA_Test.Effects.PS_Fire_13'
	PS_Damaged_Heavy=ParticleSystem'AA_Test.Effects.PS_Fire_13'
	PS_Damaged_Sparks=ParticleSystem'Nano_Effects_Enviroment.sparks.P_Sign_Sparks'

	DamagedAndOnFireSound=SoundCue'Ambient_Loops.Fires.fire_large01Cue'

	SpawnRoar=SoundCue'Enemy_Bullram.Roar.Bullram_SpawnRoar_Cue'

	StartMovingSound=SoundCue'Enemy_Bullram.Movement.Bullram_ChargeMove_Cue'

	BumpIntoSomethingRoar=SoundCue'Enemy_Bullram.Roar.Bullram_Roar_Cue'
}
