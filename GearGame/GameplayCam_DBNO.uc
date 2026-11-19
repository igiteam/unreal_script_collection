/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_DBNO extends GearGameplayCameraMode
	config(Camera)
	native(Camera);

var() protected const int	MinPitch;
var() protected const int	MaxPitch;

/** During self reviving, would like to move camera a bit far away **/
var() vector ViewOffsetWhenReviving;

cpptext
{
	/**
	* Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	* around this point, offsets are applied from here, etc.
	*/
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
};

/** 
 * Allows mode to make any final situational adjustments to the base view offset.
 */
function vector AdjustViewOffset( Pawn P, vector Offset )
{
	local GearPawn GP;
	local vector LocalViewOffset;

 	GP = GearPawn(P);

	LocalViewOffset = Super.AdjustViewOffset( P, Offset );

	// during self reviving, add offset to push back
	// you don't want to see your butt that close 
	if ( GP!=none && GP.bPlayingSelfReviving )
	{
		LocalViewOffset += ViewOffsetWhenReviving;
	}

	return LocalViewOffset;
}
/** Overridden to clamp pitch values. */
simulated function ProcessViewRotation( float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	// Clamp Pitch
	SClampRotAxis( DeltaTime, out_ViewRotation.Pitch-ViewTarget.Rotation.Pitch, out_DeltaRot.Pitch, MaxPitch, MinPitch, 4.f );

	super.ProcessViewRotation(DeltaTime, ViewTarget, out_ViewRotation, out_DeltaRot);
}

simulated protected function vector GetDOFFocusLoc(Actor TraceOwner, vector StartTrace, vector EndTrace)
{
	return GameplayCam.LastActualCameraOrigin;
}

defaultproperties
{
	//bAdjustDOF=true
	DOF_RadiusDistRange=(X=1,Y=1)
	DOF_RadiusRange=(X=100,Y=100)
	DOF_BlurKernelSize=15
	DOF_FalloffExponent=0.4f

	ViewOffset={(
		OffsetHigh=(X=-50,Y=0,Z=-10),
		OffsetLow=(X=-100,Y=0,Z=-10),
		OffsetMid=(X=-160,Y=0,Z=-10),
		)}

	BlendTime=0.5f

	bDoPredictiveAvoidance=TRUE
	bValidateWorstLoc=FALSE

	WorstLocOffset=(X=0,Y=0,Z=64)

	TargetRelativeCameraOriginOffset=(X=64,Y=0,Z=-80)

	// GameplayCam_DBNO vars
	MinPitch=-8000
	MaxPitch=-1000

	ViewOffsetWhenReviving = (X=-30, Y=0, Z=0);
}
