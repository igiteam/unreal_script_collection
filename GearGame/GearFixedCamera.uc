/**
 * "Fixed" camera mode.  Views through a CameraActor in the level.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearFixedCamera extends GameFixedCamera
	config(Camera);

/** Autoframing fixed camera. */
var protected transient FixedCam_AutoFraming	AutoFramingCam;


simulated function Init()
{
	super.Init();

	// Setup camera modes
	if ( AutoFramingCam == None )
	{
		AutoFramingCam = new(Outer) class'FixedCam_AutoFraming';
		AutoFramingCam.FixedCam = self;
		//AutoFramingCam.Init();
	}
}

/**
 * Overridden to deal with AutoFraming camera.
 */
simulated function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
	local CameraActor CamActor;

	// are we looking at a camera actor?
	CamActor = CameraActor(OutVT.Target);
	if (CamActor != None)
	{
		// we're attached to a camactor, use it's FOV
		OutVT.POV.FOV = CamActor.FOVAngle;
	}
	else
	{
		OutVT.POV.FOV = DefaultFOV;
	}

	// copy loc/rot from actor we're attached to
	if (OutVT.Target != None)
	{
		OutVT.POV.Location = CamActor.Location;
		OutVT.POV.Rotation = CamActor.Rotation;
	}

	// cameraanims, etc
	PlayerCamera.ApplyCameraModifiers(DeltaTime, OutVT.POV);

	// if we had to reset camera interpolation, then turn off flag once it's been processed.
	bResetCameraInterpolation = FALSE;
}

defaultproperties
{
}