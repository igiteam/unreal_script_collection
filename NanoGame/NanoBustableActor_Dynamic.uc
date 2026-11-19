/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoBustableActor_Dynamic extends NanoBustableActor;




defaultproperties
{
	bNoDelete=FALSE
	bMovable=TRUE
	bGameRelevant=TRUE

	RemoteRole=ROLE_SimulatedProxy


	Begin Object Name=LightEnvironment0
	    bEnabled=TRUE
		bDynamic=TRUE
		bForceNonCompositeDynamicLights=TRUE // needed since we are using a static light environment
	End Object



	Begin Object Name=FracturedStaticMeshComponent0
	    StaticMesh=FracturedStaticMesh'Nano_ProtoFrac_A.SM.S_GOW_Buildings_SM_TypeB_Wall_256_Brick_FRACTURED'
		Rotation=(Pitch=0,Yaw=16384,Roll=0)
		LightEnvironment=LightEnvironment0
	End Object
}