/**
 *
 *	Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SkeletalMeshActorMAT_Lyrik extends SkeletalMeshActorMAT;

var SkeletalMeshComponent HandForgeSkelMesh;
var StaticMeshComponent HandForgeMesh;
var ParticleSystem PS_HandForge;
var transient ParticleSystemComponent PSC_HandForge;

var name HandForgeSocketName;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// create all of the handforge objects
	SkeletalMeshComponent.AttachComponentToSocket( HandForgeSkelMesh, HandForgeSocketName );
	SkeletalMeshComponent.AttachComponentToSocket( HandForgeMesh, HandForgeSocketName );

	PSC_HandForge = new(self) class'NanoParticleSystemComponent';
	PSC_HandForge.SetTemplate( PS_HandForge );
	SkeletalMeshComponent.AttachComponentToSocket( PSC_HandForge, HandForgeSocketName );

}


defaultproperties
{

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_REB_Lyrik_Body'
		PhysicsAsset=PhysicsAsset'REB_Lyrik.Physics.SK_REB_Lyrik_Body_Physics'
		Translation=(Z=-88.0)
		AlwaysCheckCollision=TRUE
		bEnableFullAnimWeightBodies=TRUE
	End Object

	Begin Object Class=SkeletalMeshComponent Name=NanoPawnHeadMesh
		SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_REB_Lyrik_Head'

		bAllowAmbientOcclusion=FALSE
		LightEnvironment=MyLightEnvironment
		ParentAnimComponent=SkeletalMeshComponent0
		ShadowParent=SkeletalMeshComponent0
		bUpdateSkelWhenNotRendered=TRUE
		bCastHiddenShadow=TRUE
		CastShadow=TRUE

		bEnableClothSimulation=TRUE
		bClothUseCompartment=FALSE
		bDisableClothCollision=FALSE
		bClothAwakeOnStartup=FALSE

		bClothBaseVelClamp=TRUE
		ClothBaseVelClampRange=(X=200,Y=200,Z=300)
		ClothBlendWeight=1.f

		bClothPositionalDampening=FALSE
		MinPosDampRange=(X=150,Y=100,Z=100)
		MaxPosDampRange=(X=50,Y=100,Z=150)
		MinPosDampScale=(X=1.f,Y=1.f,Z=1.f)
		MaxPosDampScale=(X=0.f,Y=0.f,Z=1.f)

		TickGroup=TG_PreAsyncWork
		AlwaysCheckCollision=TRUE
	End Object
	Components.Add(NanoPawnHeadMesh)


	Begin Object Class=SkeletalMeshComponent Name=NanoPawnScarfMesh
		SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_REB_Lyrik_Scarf'
		LightEnvironment=MyLightEnvironment
		bUpdateSkelWhenNotRendered=TRUE
		ParentAnimComponent=SkeletalMeshComponent0
		bCastHiddenShadow=TRUE
		CastShadow=TRUE
		ShadowParent=SkeletalMeshComponent0

		bEnableClothSimulation=TRUE
		bClothUseCompartment=FALSE
		bDisableClothCollision=FALSE
		bClothAwakeOnStartup=FALSE

		bClothBaseVelClamp=TRUE
		ClothBaseVelClampRange=(X=200,Y=200,Z=300)
		ClothBlendWeight=1.f

		ClothRBChannel=RBCC_Cloth
		ClothRBCollideWithChannels=(Pawn=TRUE)

		bClothPositionalDampening=FALSE
		MinPosDampRange=(X=150,Y=100,Z=100)
		MaxPosDampRange=(X=50,Y=100,Z=150)
		MinPosDampScale=(X=1.f,Y=1.f,Z=1.f)
		MaxPosDampScale=(X=0.f,Y=0.f,Z=1.f)

		TickGroup=TG_PreAsyncWork
		AlwaysCheckCollision=TRUE

		//		bClothWindRelativeToOwner=TRUE
		//		ClothWind=(X=-50.f,Y=0.f,Z=5.f)
	End Object
	//ScarfMesh=NanoPawnScarfMesh
	Components.Add(NanoPawnScarfMesh)





	HandForgeSocketName="HandForge"
	PS_HandForge=ParticleSystem'REB_Lyrik.P_Lyric_Handforge_Active' 



	Begin Object Class=StaticMeshComponent Name=HandForgeMeshComp
		StaticMesh=StaticMesh'REB_Lyrik.S_Nano_Handforge_Glow_01' // GlowOffset from .2 to -1 to hide the glow (and the inverse to reveal it).  
	End Object
	HandForgeMesh=HandForgeMeshComp
	Components.Add(HandForgeMeshComp)

	Begin Object Class=SkeletalMeshComponent Name=HandForgeSkelMeshComp
		SkeletalMesh=SkeletalMesh'REB_Lyrik.SK_REB_Lyrik_HandForge'
	End Object
	HandForgeSkelMesh=HandForgeSkelMeshComp
	Components.Add(HandForgeSkelMeshComp)


}
