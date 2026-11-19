//=============================================================================
// This is an example player-specific camera
// Cameras define the Point of View of a player in world space.
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class NanoPlayerCamera extends GamePlayerCamera
	config(Camera)
	native(Camera);

/** Main Gameplay cameras */
var(Camera) transient protectedwrite editinline NanoThirdPersonCamera Cam_3p;

/////////////////////
// Camera Modifiers
/////////////////////

/** Camera modifier for camera bone animation */
var(Camera) private editinline	CameraModifier	NanoCamMod_CameraBone;


function float GetFOVAngle()
{
	if (CameraActor(ViewTarget.Target) != None)
	{
		return CameraCache.POV.FOV;
	}
	return Super.GetFOVAngle();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	Cam_3p = NanoThirdPersonCamera(ThirdPersonCam);

	// Setup camera modifiers
	if( NanoCamMod_CameraBone == None )
	{
//		NanoCamMod_CameraBone = NanoCamMod_CameraBone(CreateCameraModifier(class'NanoCamMod_CameraBone'));
	}
}

/**
* Internal.  Polls game state to determine best camera to use.
*/
protected function GameCameraBase FindBestCameraType(Actor CameraTarget)
{
	local GameCameraBase BestCam;

	// if not using a game-specific camera (i.e. not 'default'), we'll let the engine handle it
	if( CameraStyle == 'default' || CameraStyle == 'FreeCam_Default' )
	{
		if (CameraActor(CameraTarget) != None)
		{
			// if attached to a CameraActor and not spectating, use Fixed
			BestCam = FixedCam;
		}
		else 
		{
			BestCam = Cam_3p;
		}
	}

	return BestCam;
}

simulated event SetThirdPersonCamera( optional bool bForce )
{
	Cam_3p.SetThirdPersonCamera( bForce );
}

simulated function SetFirstPersonCamera( optional bool bForce )
{
	Cam_3p.SetFirstPersonCamera( bForce );
}

simulated event bool ShouldUseThirdPersonCamera()
{
	return Cam_3p.ShouldUseThirdPersonCamera();
}

/** Update any attached camera lens effects (e.g. blood) **/
simulated function UpdateCameraLensEffects( const out TViewTarget OutVT )
{
	local int Idx;

	for (Idx=0; Idx<CameraLensEffects.length; ++Idx)
	{
		if (CameraLensEffects[Idx] != None)
		{
			// get the actual camera FOV so the lens effect does not swim/shift
			CameraLensEffects[Idx].UpdateLocation(OutVT.POV.Location, OutVT.POV.Rotation, GetFOVAngle());
		}
	}
}


defaultproperties
{
	CameraStyle=Default
	DefaultFOV=85.0f
	SplitScreenShakeScale=0.5f

	ThirdPersonCameraClass=class'NanoThirdPersonCamera'
}
