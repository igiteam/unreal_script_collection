/** 
 * Will call for rebel help.
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class RebelAntenna extends DynamicSMActor_Spawnable
	notplaceable;

var ParticleSystem PS_Broadcasting;

var transient ParticleSystemComponent PSC_Broadcasting;


function PostBeginPlay()
{
	Super.PostBeginPlay();


	PSC_Broadcasting = new(self) class'ParticleSystemComponent';
	PSC_Broadcasting.SetTemplate( PS_Broadcasting );
	AttachComponent( PSC_Broadcasting );
	PSC_Broadcasting.ActivateSystem();
}



function InitiateBroadcast()
{
	NanoGRI(WorldInfo.GRI).SendForMobileHelp_Urgent();

	// update the feed!
	NanoGRI(WorldInfo.GRI).MCP.UpdateLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.FeedEvent_RequestedMobileHelp, "FeedEvent_RequestedMobileHelp"  );

}




defaultproperties
{
	LifeSpan=60


	Begin Object Class=SkeletalMeshComponent Name=AntennaMesh
	    SkeletalMesh=SkeletalMesh'GEN_Antenna.SK_GEN_Antenna'
		Materials(0)=MaterialInstanceConstant'GEN_Antenna.Materials.M_GEN_Antenna_Gold'
		Scale=0.5f

		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Pawn
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,DeadPawn=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
		bIgnoreControllersWhenNotRendered=TRUE
		LightEnvironment=MyLightEnvironment
		MinDistFactorForKinematicUpdate=0.2
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=TRUE
		bCullModulatedShadowOnBackfaces=FALSE
		bAllowAmbientOcclusion=FALSE
		MotionBlurScale=0.0
	End Object
	Components.Add(AntennaMesh)

	PS_Broadcasting=ParticleSystem'GEN_Antenna.Effects.P_GEN_Antenna_Broadcasting' 


	bCollideActors=TRUE
	bBlockActors=FALSE

}
