/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_ForgedRocket extends NanoProj_ExplosiveBase
	config(Weapon)
	implements(NanoInterface_Forgeable);

var protected SoundCue LaunchedCue;

var StaticMeshComponent	StaticMeshComp;

var protected ParticleSystemComponent PSC_ForgeEffect;
var protected transient MaterialInstanceConstant MIC_Missile;
var() protected const vector2d RezOffsetParamInterpRange;

/** How long it takes to forge */
var() protected const float ForgeTime;
var protected transient float ForgeTimeRemaining;

var() protected const SoundCue ForgeSound;

delegate OnFinishedForging();

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	MIC_Missile = StaticMeshComp.CreateAndSetMaterialInstanceConstant(0);

	ForgeActor();
}

/** From NanoInterface_Forgeable */
function ForgeActor(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	local vector EffectTranslation;

	PSC_ForgeEffect.ActivateSystem();
	EffectTranslation.X = -StaticMeshComp.Bounds.BoxExtent.X;
	PSC_ForgeEffect.SetTranslation(EffectTranslation);

	// kick things off
	ForgeTimeRemaining = ForgeTime;

	PlaySound(ForgeSound);

	OnFinishedForging = OnFinishCallback;
}

protected function ForgeFinished()
{
	// turn off emitter
	PSC_ForgeEffect.DeactivateSystem();

	// call delegate
	if (OnFinishedForging != None)
	{
		OnFinishedForging();
	}
}

simulated function Tick(float DeltaTime)
{
	local vector EffectTranslation;
	local float Pct;

	super.Tick(DeltaTime);

	if (ForgeTimeRemaining > 0.f)
	{
		ForgeTimeRemaining = FMax(ForgeTimeRemaining-DeltaTime, 0.f);
		Pct = 1.f - ForgeTimeRemaining/ForgeTime;

		EffectTranslation.X = (2.f * Pct - 1.f) * StaticMeshComp.Bounds.BoxExtent.X;
		PSC_ForgeEffect.SetTranslation(EffectTranslation);
	
		MIC_Missile.SetScalarParameterValue('RezOffset', GetRangeValueByPct(RezOffsetParamInterpRange, Pct));

		if (Pct >= 1.f)
		{
			// done!
			ForgeFinished();
		}
	}
}
	

function NanoProjInit( Vector Direction, optional Actor TargetActor )
{
	bRotationFollowsVelocity = true;

	Init( Direction );

	StartInFlightAudio();

	PlaySound( LaunchedCue );
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if( Physics != PHYS_RigidBody )
	{
		Super.ProcessTouch( Other, HitLocation, HitNormal );
	}
}

simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	if( Physics != PHYS_RigidBody )
	{
		Super.HitWall( HitNormal, Wall, WallComp );
	}
}

simulated function Landed( vector HitNormal, actor FloorActor )
{
	if( Physics != PHYS_RigidBody )
	{
		Super.Landed( HitNormal, FloorActor );
	}
}

event TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	if( Physics == PHYS_RigidBody )
	{
		Instigator = EventInstigator.Pawn;
		TriggerExplosion( Location, vect(0,0,1), None );
	}
}

defaultproperties
{
	ForgeTime=0.3f
	RezOffsetParamInterpRange=(X=-1.25f,Y=0.5f)

	ForgeSound=SoundCue'Gameplay_Audio.Forging.Player_ForgeRocket_Stereo_Cue'

	Begin Object Class=StaticMeshComponent Name=RocketStaticMesh0
    	StaticMesh=StaticMesh'AssembleTest.Mesh.S_SummonMissile_01'
		HiddenGame=FALSE
        CastShadow=FALSE
		CollideActors=TRUE
		BlockActors=TRUE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=FALSE
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE)
        Scale3D=(X=1.0,Y=1.0,Z=1.0)
		Scale=0.5f
    End Object
	Components.Add(RocketStaticMesh0)
	StaticMeshComp=RocketStaticMesh0
	CollisionComponent=RocketStaticMesh0


	Begin Object Class=ParticleSystemComponent Name=PSC_ForgeEffect0
		Template=ParticleSystem'AssembleTest.Effects.P_MissileCondense_01'
		bAutoActivate=false
		Scale=0.5f
	End Object
	PSC_ForgeEffect=PSC_ForgeEffect0
	Components.Add(PSC_ForgeEffect0)

	// explosion point light
	Begin Object Class=PointLightComponent Name=ExploLight0
		Radius=400.000000
		Brightness=500.000000
		LightColor=(B=35,G=185,R=255,A=255)
		Translation=(X=16)
		CastShadows=FALSE
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bForceDynamicLight=FALSE
		bEnabled=FALSE
	End Object

	// explosion
	Begin Object Class=NanoExplosion Name=ExploTemplate0
		ParticleEmitterTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileExplosion_01'
		ExplosionSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Rocket_Explode_Cue'

		MyDamageType=class'NDT_ForgedRocket'
		MomentumTransferScale=1.f	// Scale momentum defined in DamageType

		ExploLight=ExploLight0
		ExploLightFadeOutTime=0.17f

		bDoExploCameraAnimShake=TRUE
		ExploShakeInnerRadius=650
		ExploShakeOuterRadius=1500

		FractureMeshRadius=100.0
		FracturePartVel=300.0

		bAllowPerMaterialFX=TRUE

		bUsePerMaterialFogVolume=TRUE
	End Object
	ExplosionTemplate=ExploTemplate0

	TrailTemplate=ParticleSystem'Nano_WeaponFX.Missile.Effects.P_FX_MissileContrail_01_Cheap'
	LaunchedCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Rocket_Fire_Cue'
	InFlightSoundTemplate=SoundCue'Vehicle_PacBot.PacBot.PacBot_Rocket_InAirLoop_Cue'
	bAutoStartInFlightAudio=FALSE

	Speed=2000
	MaxSpeed=2000
//	AccelToTargetMag=4000
// 	IgniteTime=0.2f

	MyDamageType=class'NDT_ForgedRocket'

	// start false, will turn true once it launches
	bRotationFollowsVelocity=FALSE

	bBlockedByInstigator=FALSE
	bProjTarget=TRUE

	LifeSpan=+0060.000000 // when we are forging a large number of rockets we can take longer than the default LifeSpan to launch them

}