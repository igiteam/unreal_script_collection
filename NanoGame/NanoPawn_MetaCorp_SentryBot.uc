/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_SentryBot extends NanoPawn_MetaCorp_SentryBotBase;

defaultproperties
{
	ControllerClass=class'NanoAI_SentryBot'

	Begin Object Class=AnimNodeSequence Name=AnimNodeSeq0
	End Object

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'MET_TattleCam.SK_MET_TattleCam'
		PhysicsAsset=PhysicsAsset'MET_TattleCam.SK_MET_TattleCam_Physics2'
		bHasPhysicsAssetInstance=TRUE
		Animations=AnimNodeSeq0
		AnimSets(0)=AnimSet'MET_TattleCam.AS_MET_TattleCam'
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Pawn
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,DeadPawn=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
		bIgnoreControllersWhenNotRendered=TRUE
		LightEnvironment=MyLightEnvironment
		MinDistFactorForKinematicUpdate=0.0f
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=TRUE
		bCullModulatedShadowOnBackfaces=FALSE
		bAllowAmbientOcclusion=FALSE
		MotionBlurScale=0.0

		bNotifyRigidBodyCollision=TRUE
		ScriptRigidBodyCollisionThreshold=10.0

		bUpdateSkelWhenNotRendered=FALSE
		bTickAnimNodesWhenNotRendered=FALSE

		Translation=(X=0,Y=0,Z=24)
	End Object
	Mesh=NanoPawnMesh
	Components.Add(NanoPawnMesh)

	BrokenMesh=SkeletalMesh'MET_TattleCam.SK_MET_TattleCam_Broken'
	BrokenAsset=PhysicsAsset'MET_TattleCam.SK_MET_TattleCam_Broken_Physics'

	Begin Object Class=PointLightComponent Name=AlertLight
	    LightAffectsClassification=LAC_STATIC_AFFECTING
	    CastShadows=TRUE
	    CastStaticShadows=TRUE
	    CastDynamicShadows=FALSE
	    bForceDynamicLight=FALSE
	    UseDirectLightMap=FALSE
	    LightingChannels=(BSP=TRUE,Static=TRUE,Dynamic=FALSE,bInitialized=TRUE)
		Radius=256.f
		LightColor=(R=255,G=0,B=0)
		bEnabled=FALSE
	End Object
	AlertLightComp=AlertLight
	Components.Add(AlertLight)

	Begin Object Class=RB_RadialImpulseComponent Name=DyingTattlerBotImpulseComp
	    ImpulseRadius=512.0f
		ImpulseStrength=512.0f
		bVelChange=TRUE
		ImpulseFalloff=RIF_Constant
	End Object
	DyingTattlerBotImpulse=DyingTattlerBotImpulseComp


	GroundSpeed=200
	SightRadius=10000.f
	PeripheralVision=0.f

	bCurrDistanceBasedPerformanceOn=FALSE // collision is on as starting default
	DistanceBasedPerformance=2048.0f


	ReleasedFromHousingCue=SoundCue'Vehicle_SecurityBot.SecurityBot.SecurityBot_ReleaseTattler_Cue'
	DeathCue=SoundCue'Vehicle_SecurityBot.SecurityBot.SecurityBot_Death_Cue'
	DeadBotImpactingGroundCue=SoundCue'Vehicle_SecurityBot.SecurityBot.SecurityBot_DeathImpact_Cue'
	AlarmCue=SoundCue'Vehicle_SecurityBot.SecurityBot.SecurityBot_AlarmLoop03_Cue'
	ScanningCue=SoundCue'Vehicle_SecurityBot.SecurityBot.SecurityBot_ScannerBeamLoop04_Cue'
	SummonDropPodWarningCue=SoundCue'Vehicle_SecurityBot.SecurityBot.SecurityBot_AlarmLoop02_Cue'

    PS_DeathEffect=ParticleSystem'Nano_FX.Effects.P_FX_TattleBot_Explode'
	PS_SummonDropPodBeacon=ParticleSystem'Nano_FX.Effects.P_FX_PacBot_Jets'

	bNoEncroachCheck=TRUE

	TickFrequencyDecreaseDistanceStart=5000
	TickFrequencyDecreaseDistanceEnd=10000
	TickFrequencyAtEndDistance=0.19

	TargetLocationSocketName="Lens"

	DroppedOrbClasses.Add(class'NanoAbsorbOrb_SentryBot')
}
