/**s
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoForgedBoulder extends Nano_KActor_Spawnable
	implements(NanoInterface_Forgeable);

var protected StaticMeshComponent BoulderMesh;
var protected StaticMeshComponent SphereMesh;

var protected ParticleSystemComponent PSC_ForgeEffect;

var protected const SoundCue ForgeSound;

var protected transient float SphereScaleUpInterpTimeRemaining;
var() protected const float SphereScaleUpInterpTime;
var() protected const vector2d SphereScaleUpInterpRange;

var protected transient float SphereScaleDownInterpTimeRemaining;
var() protected const float SphereScaleDownInterpTime;
var() protected const vector2d SphereScaleDownInterpRange;

var protected transient float BoulderScaleUpInterpTimeRemaining;
var() protected const float BoulderScaleUpInterpTime;
var() protected const vector2d BoulderScaleUpInterpRange;

var() protected const vector InitialVelocity;

delegate OnFinishedForging();

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return false;
}

//var protected MaterialInstanceConstant MIC_Sphere;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

//	MIC_Sphere = SphereMesh.CreateAndSetMaterialInstanceConstant(0);
	
	ForgeActor();
}

/** from NanoInterface_Forgeable */
function ForgeActor(optional delegate<NanoPlan.OnForgeActorFinished> OnFinishCallback)
{
	// turn on right away
	PSC_ForgeEffect.ActivateSystem();
	SetTimer(4.2f, false, nameof(ForgeFinished));

	// start scale interps
	SphereMesh.SetHidden(false);
	SphereScaleUpInterpTimeRemaining = SphereScaleUpInterpTime;
	BoulderScaleUpInterpTimeRemaining = BoulderScaleUpInterpTime;

	SetTimer(4.4f, false, nameof(StartBoulderFall));

	PlaySound(ForgeSound);

	OnFinishedForging = OnFinishCallback;
}

protected function ForgeFinished()
{
	PSC_ForgeEffect.DeactivateSystem();

	// call delegate
	if (OnFinishedForging != None)
	{
		OnFinishedForging();
	}
}

protected function StartBoulderFall()
{
	SetPhysics(PHYS_RigidBody);
	Velocity = InitialVelocity;
}


simulated function Tick( float DeltaTime )
{
	local float Pct;

	super.Tick(DeltaTime);

	if (SphereScaleUpInterpTimeRemaining > 0.f)
	{
		SphereScaleUpInterpTimeRemaining = FMax(SphereScaleUpInterpTimeRemaining-DeltaTime, 0.f);
		Pct = 1.f - SphereScaleUpInterpTimeRemaining/SphereScaleUpInterpTime;
		SphereMesh.SetScale(GetRangeValueByPct(SphereScaleUpInterpRange, Pct));

		if (SphereScaleUpInterpTimeRemaining <= 0.f)
		{
			// finished scale up, kick off scale down
			SphereScaleDownInterpTimeRemaining = SphereScaleDownInterpTime;
		}
	}

	if (SphereScaleDownInterpTimeRemaining > 0.f)
	{
		SphereScaleDownInterpTimeRemaining = FMax(SphereScaleDownInterpTimeRemaining-DeltaTime, 0.f);
		Pct = 1.f - SphereScaleDownInterpTimeRemaining/SphereScaleDownInterpTime;
		SphereMesh.SetScale(GetRangeValueByPct(SphereScaleDownInterpRange, Pct));

		if (SphereScaleDownInterpTimeRemaining <= 0.f)
		{
			// scaled to 0, hide
			SphereMesh.SetHidden(true);
			SphereMesh.SetScale(1.f);
		}

	}

	if (BoulderScaleUpInterpTimeRemaining > 0.f)
	{
		BoulderScaleUpInterpTimeRemaining = FMax(BoulderScaleUpInterpTimeRemaining-DeltaTime, 0.f);
		Pct = 1.f - BoulderScaleUpInterpTimeRemaining/BoulderScaleUpInterpTime;
		BoulderMesh.SetScale(GetRangeValueByPct(BoulderScaleUpInterpRange, Pct));
	}

}

defaultproperties
{
// 	bCollideComplex=true
// 	bCollideActors=true
// 	bCollideWorld=true
// 	bProjTarget=true
// 	bBlockActors=true

	Physics=PHYS_None

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'DropWeight_Test_01.Meshes.S_RockMesh_01'
		//Scale=1.f
	End Object
	BoulderMesh=StaticMeshComponent0
//	Components.Add(BoulderMesh0)
//	CollisionComponent=BoulderMesh0

	Begin Object Class=StaticMeshComponent Name=SphereMesh0
		StaticMesh=StaticMesh'DropWeight_Test_01.Meshes.S_Coalesce_Sphere_01'
		//Scale=1.f
	End Object
	SphereMesh=SphereMesh0
	Components.Add(SphereMesh0)

// 	// define here as lot of sub classes which have moving parts will utilize this
// 	Begin Object Class=DynamicLightEnvironmentComponent Name=TurretLightEnvironment
// 	    bDynamic=FALSE
// 		bCastShadows=FALSE
// 		AmbientGlow=(R=0.3f,G=0.3f,B=0.3f,A=1.0f)
// 		TickGroup=TG_DuringAsyncWork
// 	End Object
// 	Components.Add(TurretLightEnvironment)

	Begin Object class=ParticleSystemComponent Name=ForgeFX0
		Template=ParticleSystem'DropWeight_Test_01.Effects.P_NanoBoom_01P_WeightInitiate_01'
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_ForgeEffect=ForgeFX0
	Components.Add(ForgeFX0)

	ForgeSound=SoundCue'Gameplay_Audio.Forging.Player_ForgeSmg_Stereo_Cue'

	SphereScaleUpInterpTime=3.3f
	SphereScaleUpInterpRange=(X=0.f,Y=1.f)
	SphereScaleDownInterpTime=0.9f
	SphereScaleDownInterpRange=(X=1.f,Y=0.f)
	BoulderScaleUpInterpTime=3.4f
	BoulderScaleUpInterpRange=(X=0.f,Y=1.f)

	InitialVelocity=(Z=-200)

}
