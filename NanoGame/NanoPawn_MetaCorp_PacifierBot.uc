/**
 * MetaCorp UrbanPacificationMek
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_PacifierBot extends NanoPawn_MetaCorp_PacifierBotBase;



defaultproperties
{
	ControllerClass=class'NanoAI_PacifierBot'

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'MET_PacifierMechProto.SK_MET_PacifierMechProto_Torso'
		PhysicsAsset=PhysicsAsset'MET_PacifierMechProto.SK_MET_PacifierMechProto_Physics'
		AnimTreeTemplate=AnimTree'MET_PacifierMechProto.AT_PacifierMechProto'
		AnimSets.Empty()
		AnimSets.Add(AnimSet'MET_PacifierMechProto.AS_MET_PacifierMechProto')
		Translation=(Z=-88.0)
		Scale3D=(X=1.0f,Y=1.0f,Z=1.0f)
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,DeadPawn=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,GameplayPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
		bNotifyRigidBodyCollision=TRUE
		bTickAnimNodesWhenNotRendered=FALSE
	End Object

	Begin Object Name=CollisionCylinder
		CollisionRadius=128.f
		CollisionHeight=78.f
	End Object

	Begin Object Class=StaticMeshComponent Name=ChestPlateComp0
    	StaticMesh=StaticMesh'MET_PacifierMechProto.SM_MET_PacifierMechProto_ArmorPlate_A'
		HiddenGame=FALSE
        CastShadow=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockRigidBody=FALSE
    End Object
	Components.Add(ChestPlateComp0)
	ChestPlateComp=ChestPlateComp0	

    LimbList(0)=(LimbName=Chassis,LimbClass=class'PacifierLimb_Chasis_Wrapper')
 	LimbList(1)=(LimbName=RocketPack,LimbClass=class'PacifierLimb_RocketPack_Wrapper')
 	LimbList(2)=(LimbName=ShoulderGun,LimbClass=class'PacifierLimb_ShoulderGun')
  	LimbList(3)=(LimbName=BackGun,LimbClass=class'PacifierLimb_BackGun')
  	LimbList(4)=(LimbName=ArmGun,LimbClass=class'PacifierLimb_RightArmGun')
 	LimbList(5)=(LimbName=GrabArm,LimbClass=class'PacifierLimb_GrabArm')
	LimbList(6)=(LimbName=Core,LimbClass=class'PacifierLimb_Core')

	PeripheralVision=-0.4

	Docks(0)=(SocketName=EyeDock_Left_Front)
	Docks(1)=(SocketName=EyeDock_Right_Front)
	Docks(2)=(SocketName=EyeDock_Left_Back)
	Docks(3)=(SocketName=EyeDock_Right_Back)

    DistanceToGrabTattlers=2048.0f

    bCurrDistanceBasedPerformanceOn=FALSE // collision is on as starting default
	DistanceBasedPerformance=2048.0f

	// EFFECTS
	PS_ExhaustEffect=ParticleSystem'Nano_FX.Effects.P_FX_PacBot_Jets'

	// SOUNDS
	DetachFromChassisCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Body_Detaches_Cue'
	HoverIdleLoopCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Body_HoverLoop_Cue'
	HoverThrustCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Body_HoverThrust_Cue'
	DestroyedCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Body_Explodes_Cue'

	VO_Target(0)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_AcquiringCue'
	VO_Target(1)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_AnomalyDetectedCue'
	VO_Target(2)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_EradicationProtocallCue'
	VO_Target(3)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_LethalForceAuthorizedCue'
	VO_Target(4)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_ViolationCue'
	VO_Target(5)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_ViolatorCue'
	VO_Target(6)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_YouAreInViolationCue'
	VO_Target(7)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_YouWillBePacifiedCue'

	VO_Search(0)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_AcquisitionFailureCue'
	VO_Search(1)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_AreaSecureCue'
	VO_Search(2)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_ReconnoiteringCue'
	VO_Search(3)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_ScoutingAreaCue'
	VO_Search(4)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_SearchingContainmentAreaCue'

	VO_Damage(0)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_DamageCriticalCue'
	VO_Damage(1)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_DefenseMechanismDisabledCue'
	VO_Damage(2)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_RebootingCue'
	VO_Damage(3)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_SystemFailureCue'

	VO_Affirmative(0)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_ConfirmationCodeAcceptedCue'
	
	VO_Negative(0)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_DoesNotComputeCue'
	VO_Negative(1)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_FailureToCompileCue'
	VO_Negative(2)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_InfiniteLoopDetectedCue'
	VO_Negative(3)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_InvalidCommandParametersCue'
	VO_Negative(4)=SoundCue'Dialog_PacBot.PacBot.PacificationBot_UnableToComplyCue'

	TickFrequencyDecreaseDistanceStart=4000
	TickFrequencyDecreaseDistanceEnd=8000
	TickFrequencyAtEndDistance=0.1
}