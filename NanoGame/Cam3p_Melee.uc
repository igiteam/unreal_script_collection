/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Melee extends NanoThirdPersonCameraMode
	native(Camera)
	config(Camera);

cpptext
{
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
	virtual void InterpolateCameraOrigin( APawn* TargetPawn, FLOAT DeltaTime, FVector& out_ActualCameraOrigin, FVector const& IdealCameraOrigin, FRotator& out_ActualCameraOriginRot, FRotator const& IdealCameraOriginRot );
	virtual FVector InterpolateCameraOriginLoc(APawn* TargetPawn, FRotator const& CameraTargetRot, FVector const& LastLoc, FVector const& IdealLoc, FLOAT DeltaTime);
	virtual FRotator InterpolateCameraOriginRot(class APawn* TargetPawn, FRotator const& LastRot, FRotator const& IdealRot, FLOAT DeltaTime);

	virtual void ResetPlayerView();
};

struct native CameraConditionItem
{
	/** Minimum number of enemies for this condition to be active */
	var() int MinNumEnemies;
	/** Min/Max allowed distance for attack camera */
	var() Vector2D AllowDistRange;
	/** Min/Max allowed FOV after attack camera adjustments */
	var() Vector2D AllowFOVRange;
};
var() config array<CameraConditionItem> CameraConditions;

/** Whether was in attack camera mode last frame */
var()	bool		bCombatCamera;

/** Whether or not we need to reset the camera's autopan/slide interp speeds next frame */
var transient bool bNeedToResetCamInterpSpeeds;

/** Standard camera offset from pawn */
var() config  Vector	MeleeCameraOffset;
/** Amount of delay before updating rotation toward left thumbstick dir */
var() config  float		MeleeOrientationDelay;

var() config float AdjustRotationLimit;
var() config float AdjustRotationDelay;
var			 float AdjustRotationStartTime;
var			 Rotator AdjustRotationStart;
var() config float RotDegreesPerSecond;

var Rotator DesiredViewRotation;
var Rotator ActualViewRotation;

/** Min/Max pan value to add to the camera */
var() config Vector2D AutoPanYawRange;
/** Interpolated location of the AutoPan center */
var()	Vector	AutoPanYawCenter;
var() config float	AutoPanYawCenterInterpSpeed;

/** Height to slide the camera up/down when obstructed by an object to front/rear */
var() config float AutoSlideHeight_Front, AutoSlideHeight_Rear;
/** Amount to cap auto sliding due to melee attack/dodge - Side X=Left,Y=Right, Depth X=Backward,Y=Forward */
var() config Vector2D AutoSlideSideMax_Side, AutoSlideSideMax_Depth;

var() config float AutoPitchLevelInterpSpeed;

//debug
var() Vector	DebugPanYawCenter;
var() Actor		DebugPanPitchObstructor;

native function Vector2D GetCameraDistRange( NanoPawn NP );
native function Vector2D GetCameraFOVRange( NanoPawn NP );

/** Called when Camera mode becomes active */
function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	Super.OnBecomeActive( TargetPawn, PrevMode );

	if( TargetPawn != None && TargetPawn.Controller != None )
	{
		DesiredViewRotation.Yaw = TargetPawn.Controller.Rotation.Yaw;
		ActualViewRotation = DesiredViewRotation;
		AutoPanYawCenter = TargetPawn.Location;
		bCombatCamera = FALSE;
	}
}

defaultproperties
{
	BlendTime=0.2f

	ViewOffset={(
		OffsetHigh=(X=-225,Y=30,Z=40),
		OffsetLow=(X=-225,Y=30,Z=40),
		OffsetMid=(X=-225,Y=30,Z=-20),
		)}

	WorstLocOffset=(X=0,Y=0,Z=95)
	FinalCamOffset=(X=0,Y=0,Z=-70)
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=-60)

	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=1000.f

	bInterpLocation=TRUE
	InterpLocTime=0.25f
	bInterpLocByTime=FALSE
	bInterpToIdealLocThenLock=FALSE


	bInterpRotation=TRUE
	InterpRotTime=0.25f
	bInterpRotByTime=FALSE
	bInterpToIdealRotThenLock=FALSE
//	bRotInterpSpeedConstant=TRUE

	bUseCameraBoneRotation=FALSE

	OriginLocInterpSpeed=20
	OriginRotInterpSpeed=5
	OffsetAdjustmentInterpSpeed=1.0f

}
