/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_MagLev extends NanoThirdPersonCameraMode
	native(Camera)
	config(Camera);

/** Base distance away from the pawn that the camera should be at.  This will be scaled based on the speed of the pawn through the track */
var vector  BaseCameraDistance;

/** FOV to blend to when the player is at the max velocity allowed in the maglev track **/
var float   MaxVelocityFOV;

cpptext
{
	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
};

function float GetDesiredFOV( Pawn ViewedPawn )
{
	local NanoPawn NP;
	local float DesiredFOV;
	local NanoVehicleSpline_MagLev MLSpline;
	local float PathSpeed;
	local vector PathLoc, PathDir;

	// get the baseline desired FOV, so we can from it
	DesiredFOV = Super.GetDesiredFOV(ViewedPawn);

	NP = NanoPawn(ViewedPawn);
	if( (NP != None) && (NP.CurrentMagLevAttractor != None) )
	{
		MLSpline = NP.CurrentMagLevAttractor;
		MLSpline.GetMagLevAttractionInfo(ViewedPawn, PathLoc, PathDir, PathSpeed);

		// interpolate the camera's FOV based on the pawn's speed versus the maximum speed of the maglev spline
		return Lerp( DesiredFOV, MaxVelocityFOV, PathSpeed / MLSpline.MaxLevitaingSpeed );
	}

	return DesiredFOV;
}

defaultproperties
{
	BlendTime=0.0f

	BaseCameraDistance=(X=-150.f,Y=0.f,Z=0.f)

	ViewOffset={(
		OffsetHigh=(X=-150.f,Y=0.f,Z=0.f),
		OffsetLow=(X=-150.f,Y=0.f,Z=0.f),
		OffsetMid=(X=-150.f,Y=0.f,Z=0.f)
	)}

	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=5000.f

	InterpLocTime=0.f
	bInterpLocByTime=FALSE
	bInterpToIdealLocThenLock=FALSE
	OriginLocInterpSpeed=5000

	bInterpRotation=FALSE
	InterpRotTime=0.05f
	bInterpRotByTime=FALSE
	bInterpToIdealRotThenLock=FALSE
	
	bUseCameraBoneRotation=TRUE

	MaxVelocityFOV=120.f
}
