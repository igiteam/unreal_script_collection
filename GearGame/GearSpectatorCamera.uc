/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearSpectatorCamera extends GameCameraBase
	native(Camera)
	config(Camera);

/** Autoframing fixed camera. */
var transient SpectatorCam_AutoFraming	AutoFramingCam;

/** FOV to fall back on if we can find no other. */
var() protected const float DefaultFOV;

/** control inputs passed from PlayerController to allow the user to nudge the camera */
var transient float ControlInfo_LookRight;
var transient float ControlInfo_LookUp;
var transient float ControlInfo_Zoom;

var rotator LastDeltaRot;

/** A cap on the ghost cam rotation speed */
var config float GhostCamMaxYawRotationRate;

simulated function Init()
{
	super.Init();

	// Setup camera modes
	if ( AutoFramingCam == None )
	{
		AutoFramingCam = new(Outer) class'SpectatorCam_AutoFraming';
		AutoFramingCam.SpectatorCam = self;
		//AutoFramingCam.Init();
	}
}

simulated function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
	local GearPC_MP GPC;
	local rotator NewDeltaRot;

	GPC = GearPC_MP(PlayerCamera.PCOwner);

	if (GPC != None && GPC.BattleCamPath != None && GPC.BattleCamPath.GetAssociatedCameraActor() == OutVT.Target)
	{
		if (GPC.bUseBattleCamAutoFraming && GPC.BattleCamPath.bAutomaticFraming)
		{
			// we're looking through a camera on a spectator camera path, and want to
			// use the autoframing code
			AutoFramingCam.UpdateCamera(CameraActor(OutVT.Target), GPC.BattleCamPath, DeltaTime, OutVT);
		}
		else
		{
			// allow the player to nudge the camera rotation, but nothing else
			NewDeltaRot.Yaw = int(ControlInfo_LookRight * 4096.0);
			NewDeltaRot.Pitch = int(ControlInfo_LookUp * -4096.0);
			LastDeltaRot = RInterpTo(LastDeltaRot, NewDeltaRot, DeltaTime, 1.0);

			OutVT.POV.Rotation = OutVT.Target.Rotation + LastDeltaRot;
			OutVT.POV.Location = OutVT.Target.Location;
			OutVT.POV.FOV = DefaultFOV;
		}
	}
	else if (GearSpectatorPoint(OutVT.Target) != None)
	{
		// use SpectatorPoint's location, controller's rotation
		OutVT.POV.Location = OutVT.Target.Location;
		OutVT.POV.Rotation = PlayerCamera.PCOwner.Rotation;
		OutVT.POV.FOV = GearSpectatorPoint(OutVT.Target).FOVAngle;
	}
	else if (CameraActor(OutVT.Target) != None)
	{
		OutVT.POV.Location = OutVT.Target.Location;
		OutVT.POV.Rotation = OutVT.Target.Rotation;
		OutVT.POV.FOV = CameraActor(OutVT.Target).FOVAngle;
	}
	else if (GearPC(OutVT.Target) != None)
	{
		OutVT.POV.Location = OutVT.Target.Location;
		OutVT.POV.Rotation = OutVT.Target.Rotation;
		if (GearPC_MP(OutVT.Target) != None)
		{
			OutVT.POV.Rotation.Pitch = GearPC_MP(OutVT.Target).GhostSpectatingPitch;
		}
		OutVT.POV.FOV = DefaultFOV;
	}
	else
	{
		// use target's loc and rot
		OutVT.POV.Location = OutVT.Target.Location;
		OutVT.POV.Rotation = OutVT.Target.Rotation;
		OutVT.POV.FOV = DefaultFOV;
	}

	// done with this data
	ControlInfo_LookRight = 0.f;
	ControlInfo_LookUp = 0.f;

	bResetCameraInterpolation = FALSE;
}


simulated static final protected function ClampAxis(int Axis, out int out_Delta, int BaseAxis, int MaxDelta)
{
	local int DesiredAxis, DeltaFromBase, AxisAdj;

	DesiredAxis = Axis + out_Delta;

	DeltaFromBase = NormalizeRotAxis(DesiredAxis - BaseAxis);

	if( DeltaFromBase > MaxDelta )
	{
		AxisAdj	= MaxDelta - DeltaFromBase;
	}
	else if( DeltaFromBase < -MaxDelta )
	{
		AxisAdj	= -(DeltaFromBase + MaxDelta);
	}

	out_Delta += AxisAdj;
};


simulated function ProcessViewRotation( float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local GearSpectatorPoint SpecPt;
	local GearPC_MP PC;
	local float MaxYaw;

	MaxYaw = GhostCamMaxYawRotationRate * DeltaTime;

	SpecPt = GearSpectatorPoint(PlayerCamera.PCOwner.ViewTarget);
	if (SpecPt != None)
	{
		ClampAxis(out_ViewRotation.Yaw, out_DeltaRot.Yaw, SpecPt.Rotation.Yaw, SpecPt.UserRotationRange.Yaw);
		ClampAxis(out_ViewRotation.Pitch, out_DeltaRot.Pitch, SpecPt.Rotation.Pitch, SpecPt.UserRotationRange.Pitch);
		ClampAxis(out_ViewRotation.Roll, out_DeltaRot.Roll, SpecPt.Rotation.Roll, SpecPt.UserRotationRange.Roll);
	}
	else
	{
		PC = GearPC_MP(PlayerCamera.PCOwner.ViewTarget);
		if (PC != None && PC == PlayerCamera.PCOwner && PC.IsInState('GhostSpectating'))
		{
			// ghost cam isn't rotating around something visible, cap the yaw
			if (out_DeltaRot.Yaw > MaxYaw)
			{
				out_DeltaRot.Yaw = MaxYaw;
			}
			else if (out_DeltaRot.Yaw < -MaxYaw)
			{
				out_DeltaRot.Yaw = -MaxYaw;
			}

			PC.GhostSpectatingPitch += out_DeltaRot.Pitch;
			PC.GhostSpectatingPitch = Clamp(PC.GhostSpectatingPitch,-8192,8192);
		}
		out_ViewRotation += out_DeltaRot;
	} 

	super.ProcessViewRotation(DeltaTime, ViewTarget, out_ViewRotation, out_DeltaRot);
}

/** Called when Camera mode becomes active */
function OnBecomeActive( GameCameraBase OldCamera )
{
	bResetCameraInterpolation = TRUE;
	AutoFramingCam.OnBecomeActive( OldCamera );
	super.OnBecomeActive( OldCamera );
}


defaultproperties
{
	DefaultFOV=80.f
}

