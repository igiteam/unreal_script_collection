/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_Dropship extends NanoPawn;


defaultproperties
{
	ControllerClass=class'NanoAI_Dropship'
	TickGroup=TG_PostAsyncWork	

	// do we need a cylinder comp when we have the skelmesh above?
	Begin Object Name=CollisionCylinder
	    CollisionRadius=+0140.000000
	    CollisionHeight=+0200.000000
	End Object


	Begin Object Class=SkeletalMeshComponent Name=DropshipBase
	    SkeletalMesh=SkeletalMesh'MET_Dropship.Meshes.Nano_Transport_Base_SK'

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(DropshipBase)

	Begin Object Class=SkeletalMeshComponent Name=DropshipDeck
		SkeletalMesh=SkeletalMesh'MET_Dropship.Meshes.Nano_Transport_Deck_SK'
		
		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(DropshipDeck)


	Begin Object Class=SkeletalMeshComponent Name=DropshipNose
		SkeletalMesh=SkeletalMesh'MET_Dropship.Meshes.Nano_Transport_Nose_SK'

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(DropshipNose)

	Begin Object Class=SkeletalMeshComponent Name=DropshipRearFinL
		SkeletalMesh=SkeletalMesh'MET_Dropship.Meshes.Nano_Transport_RearFinL_SK'

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(DropshipRearFinL)

	Begin Object Class=SkeletalMeshComponent Name=DropshipRearFinR
		SkeletalMesh=SkeletalMesh'MET_Dropship.Meshes.Nano_Transport_RearFinR_SK'

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(DropshipRearFinR)

	Begin Object Class=SkeletalMeshComponent Name=DropshipTail
		SkeletalMesh=SkeletalMesh'MET_Dropship.Meshes.Nano_Transport_Tail_SK'

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(DropshipTail)

	Begin Object Class=SkeletalMeshComponent Name=DropshipTurbineL
		SkeletalMesh=SkeletalMesh'MET_Dropship.Meshes.Nano_Transport_TurbineL_SK'

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(DropshipTurbineL)

	Begin Object Class=SkeletalMeshComponent Name=DropshipTurbineR
		SkeletalMesh=SkeletalMesh'MET_Dropship.Meshes.Nano_Transport_TurbineR_SK'

		LightEnvironment=MyLightEnvironment
		Translation=(Z=-200.0)
	End Object
	Components.Add(DropshipTurbineR)




	//StabAttachPos=(X=20.0,Y=0.0,Z=90.0)


	// lots of flags
	bCollideActors=TRUE
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

}

