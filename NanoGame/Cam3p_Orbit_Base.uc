/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Orbit_Base extends NanoThirdPersonCameraMode
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

var float MinSpeedForOffsetY, MaxSpeedForOffsetY;
var float MaxSpeedOffsetY;
var transient float LastOffsetY;
var transient float LastDeltaRotTime;

var vector FanOriginLocOffset;
var vector LadderOriginLocOffset;
var vector PerchOriginLocOffset;

/** Standard camera offset from pawn */
var() config  Vector	OrbitCameraOffset;

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

defaultproperties
{
	MinSpeedForOffsetY=600
	MaxSpeedForOffsetY=1200
	MaxSpeedOffsetY=-60

	FanOriginLocOffset=(X=-64.f,Y=0,Z=128)
	LadderOriginLocOffset=(X=-64.f,Y=0,Z=32)


}