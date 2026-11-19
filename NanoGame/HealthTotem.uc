/** 
 * Anyone near this Totem will constantly be healing and not have to wait the "time after <type>" events
 * before starting to heal.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class HealthTotem extends DynamicSMActor_Spawnable
	notplaceable;

var ParticleSystem PS_Broadcasting;

var transient ParticleSystemComponent PSC_Broadcasting;

var PointLightComponent HealingLight;

var SkeletalMeshComponent AntennaMesh;

function PostBeginPlay()
{
	Super.PostBeginPlay();


	PSC_Broadcasting = new(self) class'ParticleSystemComponent';
	PSC_Broadcasting.SetTemplate( PS_Broadcasting );
	AttachComponent( PSC_Broadcasting );
	PSC_Broadcasting.ActivateSystem();

	//AntennaMesh.AttachComponent( HealingLight, 'HealingLight' );
}



event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Super.Touch( Other, OtherComp, HitLocation, HitNormal );

	//`log( GetFuncName() @ `showvar(Other) );
	if( NanoPawn_RebelsBase(Other) != None )
	{
		NanoPawn_RebelsBase(Other).bTouchingHealthTotem = TRUE;
		NanoPawn_RebelsBase(Other).EnableHealthRecharge();
	}
}


event UnTouch( Actor Other )
{
	Super.UnTouch( Other );

	//`log( GetFuncName() @ `showvar(Other) );
	if( NanoPawn_RebelsBase(Other) != None )
	{
		NanoPawn_RebelsBase(Other).bTouchingHealthTotem = FALSE;
	}
}




defaultproperties
{
	LifeSpan=60

	Begin Object Class=SkeletalMeshComponent Name=AntennaMesh0
	    SkeletalMesh=SkeletalMesh'GEN_Antenna.SK_GEN_Antenna'
		Materials(0)=MaterialInstanceConstant'GEN_Antenna.Materials.M_GEN_Antenna_Red'
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
	AntennaMesh=AntennaMesh0
	Components.Add(AntennaMesh0)

	PS_Broadcasting=ParticleSystem'GEN_Antenna.Effects.P_GEN_Antenna_Healing' 


	Begin Object Class=PointLightComponent Name=HealingLight0
		Radius=1024
		Brightness=50.0f
		LightColor=(R=155,G=0,B=0,A=255)
		Translation=(Z=256)
		CastShadows=FALSE
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bForceDynamicLight=FALSE
		bEnabled=TRUE
	End Object
	HealingLight=HealingLight0
	Components.Add(HealingLight0)


	Begin Object Class=CylinderComponent Name=CollisionCylinder
	    CollisionRadius=800
	    CollisionHeight=256
	    CollideActors=TRUE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)


	bCollideActors=TRUE
	bBlockActors=FALSE

}
