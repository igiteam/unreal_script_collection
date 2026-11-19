/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoVehicle_Elevator extends NanoVehicle_ElevatorBase;


defaultproperties
{
	Components.Remove(VehicleMeshComponent0)

	Begin Object Class=SkeletalMeshComponent Name=ElevatorMesh0
		SkeletalMesh=SkeletalMesh'GEN_Elevator.SK_GEN_Elevator'
		Rotation=(Yaw=32768)
		PhysicsAsset=PhysicsAsset'GEN_Elevator.SK_GEN_Elevator_Physics'

		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE,Untitled2=TRUE,Untitled3=TRUE)
	    BlockRigidBody=TRUE
	    
		LightEnvironment=MyLightEnvironment
		bUsePrecomputedShadows=FALSE
		TickGroup=TG_PostAsyncWork
		
		CollideActors=TRUE
		BlockActors=TRUE
		BlockNonZeroExtent=TRUE
		BlockZeroExtent=TRUE
		CastShadow=FALSE

		bNotifyRigidBodyCollision=TRUE
		ScriptRigidBodyCollisionThreshold=100.0
	End Object
	CollisionComponent=ElevatorMesh0
	VehicleMeshComponent=ElevatorMesh0
	Components.Add(ElevatorMesh0)

	MovingCameraShake=NanoCameraShake'Nano_Proto_CrowdCars.ElevatorCameraShakeNormal'
	OverdriveCameraShake=NanoCameraShake'Nano_Proto_CrowdCars.ElevatorCameraShakeOverdrive'
	OverdriveLaunchThresholdCameraShake=NanoCameraShake'Nano_Proto_CrowdCars.ElevatorCameraShakeThreshold'
	StartStopCameraShake=NanoCameraShake'Nano_Proto_CrowdCars.ElevatorCameraShakeStart'

	Begin Object Class=RadialBlurComponent Name=RadialBlurComp
		BlurScale=0.25f
		bEnabled=FALSE
  	End Object
 	RB_OverdriveBlur=RadialBlurComp

	SupportedEvents.Add(class'SeqEvt_ElevatorOverdriveLaunch')

	MaxCarSpeed=500.0

	CarBankFactor=0.0
	CarBankMax=0.0
	
	StabAttachPos=(Y=380.f,Z=615.f)
	PerchLocationOffset=(Y=380.f,Z=615.f)

	bEnableStayUprightSpring=true
	StayUprightTorqueFactor=4000.0
	StayUprightMaxTorque=4500.0

	YawSpeedFilterSize=0

	UpCameraOffset=(X=-800.f,Z=-500.f)
	DownCameraOffset=(X=-800.f,Z=+500.f)
	LaunchSpeed_UpCameraOffset=(X=-800.f,Z=-500.f)
	LaunchSpeed_DownCameraOffset=(X=-800.f,Z=+500.f)
	YawDegreesOfFreedom=12000

	LaunchSlomoCurve=(Points=((InVal=0.0f,OutVal=1.f),(InVal=0.75f,OutVal=0.1f),(InVal=2.f,OutVal=0.1f),(InVal=2.3f,OutVal=1.0f)))

	LeftStick_CameraYawRate=3500.f

	NeutralCamViewDistance=500.f
	NeutralCamYawDegreesOfFreedom=14500
	NeutralCamPitchDegreesOfFreedom=2000

	OverrideAcceleration=0.25
	AccelCurveDuration=2.f
	AccelCurveExponent=2.f

	OverdriveSpeedModifier=1000.f
	OverdriveWhileDenseSpeedModifier=800.f

	OverdriveFOV=115.f

	OverdriveLaunchRange=5000.f
	OverdriveLaunchTargetTime=2.f

	bTravelRandomly=TRUE
	FloorWaitTime=4.f

	EngineSoundCues(0)=SoundCue'Ambient_Movers.Elevators.Elevator_OutSideRunningCM_01Cue'
	AirCarEnginePitchName="ElevatorOutsidePitch"

	PlayerAccelerating=SoundCue'Ambient_Movers.Elevators.Elevator_OutsideStart_01Cue'
 	PlayerDecelerating=SoundCue'Ambient_Movers.Elevators.Elevator_OutsideStop_01Cue'

	PlayerLandedCue=SoundCue'Vehicle_AirCar.Impacts.CarImpact_PlayerLand_01_Cue'
	
	PlayerRidingOverride=SoundCue'Ambient_Movers.Elevators.Elevator_OutsideOverride_Stereo_Cue'

	HitEndOfTrackSoundCue=SoundCue'Ambient_Movers.Elevators.Elevator_OutsideStopSudden_01Cue'

	OverdriveLaunchThresholdSound=SoundCue'Ambient_Movers.Elevators.Elevator_OutsideOverrideCommit_Stereo_Cue'

	OverdriveEffect=ParticleSystem'Nano_Proto_FX.Elevator.P_Elevator_Sparks'

	// Inherited from vehicle, but not needed for elevators
	PlayerOverridingControl=None
	PlayerRiding=None
	PlayerStoppingEngine=None
	AltitudeDeviationWarning=None
	MaxAltitudeWarning=None
	SpeedingWarning=None
	CollisionDetectedWarning=None

	InteractAction={(
				ActionName=ElevatorControl,
				TooltipText="LS to control elevator, X / Y to overdrive",
// 				ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
// 									(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=287,V=140,UL=91,VL=98)))	),
				)}
}