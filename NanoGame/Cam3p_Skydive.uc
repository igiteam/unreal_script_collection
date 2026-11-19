/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Skydive extends NanoThirdPersonCameraMode
	config(Camera)
	native(Camera);

/** Name of the bone in the pawn's mesh to center on for the skydiving camera */
var name    FocusBoneName;

/** Distance offset behind the pawn to keep the camera origin */
var float   SkydiveCamOffsetDistance;

/** FOV to blend to when skydiving */
var float   SkydiveFOV;

/** Time to blend the FOV to SkydiveFOV */
var float   FOVBlendTime;

cpptext
{
	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);

	/** Returns time to interpolate FOV changes. */
	FLOAT GetFOVBlendTime(class APawn* Pawn);
};

function OnBecomeActive( Pawn TargetPawn, GameThirdPersonCameraMode PrevMode )
{
	local NanoPawn NP;

	Super.OnBecomeActive(TargetPawn, PrevMode);

	NP = NanoPawn(TargetPawn);
	if( NP != None )
	{
		NP.NotifySkydiveCamActivated();

		// If we're blending between view targets, go directly to the ideal location, since it's already being blended by the VT change
		if( NP.GetCamera().PlayerCamera.BlendTimeToGo != 0.f )
		{
			bInterpLocation=FALSE;
			bInterpRotation=FALSE;
		}
	}
}

function OnBecomeInActive( Pawn TargetPawn, GameThirdPersonCameraMode NewMode )
{
	local NanoPawn NP;
	local Rotator Rot;

	Super.OnBecomeInActive( TargetPawn, NewMode );

	Rot.Yaw = ThirdPersonCam.PlayerCamera.Rotation.Yaw;
	Rot.Pitch = 0;
	TargetPawn.SetRotation( Rot );
	TargetPawn.Controller.SetRotation( Rot );

	NP = NanoPawn(TargetPawn);
	if( NP != None )
	{
		NP.NotifySkydiveCamDeactivated();
	}
}

function float GetDesiredFOV( Pawn ViewedPawn )
{
	return SkydiveFOV;
}

defaultproperties
{
	bInterpToIdealLocThenLock=TRUE
	InterpLocTime=0.25f
	bInterpLocByTime=TRUE

	bInterpRotation=TRUE
	InterpRotTime=0.25f
	bInterpRotByTime=TRUE
	bInterpToIdealRotThenLock=TRUE

	bUseCameraBoneRotation=TRUE
	OriginRotInterpSpeed=20

	FocusBoneName=b_MF_Neck
	SkydiveCamOffsetDistance=256.f
	SkydiveFOV=120.f
	FOVBlendTime=1.f

	BlendTime=0.25f
}