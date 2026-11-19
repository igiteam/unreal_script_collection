/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Default extends Cam3p_Orbit_Base
	config(Camera)
	native(Camera);

cpptext
{
	FVector GetViewOffset(class APawn* ViewedPawn, FLOAT DeltaTime, const FVector& ViewOrigin, const FRotator& ViewRotation);
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
	virtual FVector GetLookatOffset();

	virtual FLOAT GetJeffCamDistance();
}

var transient bool bPlayerOutOfSafeZone;

var() float FramingPitchDelay;
var() float AutoCenterDelay;
var transient float FramingPitchCounter;

/** JeffCamDist when moving */
var(JeffCam) protected const float JeffCamDistanceWhenMoving;
var(JeffCam) protected const float JeffCamDistanceWhenFalling;

var(JeffCam) protected const float JeffCamFallCamRampInDelay;
var(JeffCam) protected const float JeffCamFallCamRampInDuration;

var transient protected bool bIsFalling;
var transient protected float FallStartTime;



/** Returns FOV that this camera mode desires. */
function float GetDesiredFOV( Pawn ViewedPawn )
{
	local NanoPawn NP;
	local NanoSkill_Dash DashSkill;
	local float SpeedPct, MaxSpeed;
	local float DesiredFOV;
	local Vector2D FOVRange, SpeedRange;
	local int MaxPip;

	DesiredFOV = Super.GetDesiredFOV( ViewedPawn );

	NP = NanoPawn(ViewedPawn);
	if( NP != None )
	{
		DashSkill = NP.GetActiveSkill(class'NanoSkill_Dash');
		if( DashSkill != None )
		{
			MaxPip = DashSkill.DashLevels[DashSkill.SkillLevel].MaxDashPips - 1;
			MaxSpeed = DashSkill.GetMaxSpeed( NP );
			SpeedRange.X = NP.GroundSpeed;
			SpeedRange.Y = MaxSpeed;
			SpeedPct = FClamp( GetRangePctByValue( SpeedRange, VSize(NP.Velocity) ), 0.f, 1.f );

			FOVRange.X = DesiredFOV;
			FOVRange.Y = DashSkill.DashPips[MaxPip].FOV;
			DesiredFOV = GetRangeValueByPct( FOVRange, SpeedPct );
		}
	}
	return DesiredFOV;
}

function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	//`log(`location);
	FramingPitchCounter = 0.f;
	Super.OnBecomeActive(TargetPawn,PrevMode);
}

final function float GetPitchInterpRate(NanoPawn NP)
{
	return bPlayerOutOfSafeZone ? 10.f : 5.f;
}


function bool ShouldSlideOffsetOnCamModeChange( Pawn TargetPawn, GameThirdPersonCameraMode PrevMode )
{
	return Cam3p_Melee(PrevMode) != None;
}

simulated function ProcessViewRotation( float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local NanoPawn NP;
//	local vector /*CamLoc,*/ TargetLoc;
//	local int PitchDiff;
//	local float /*TimeSinceLastDeltaRot, ClampRange,*/ InterpRateScale;
//	local rotator IdealRot;
//	local bool bApplyPitch;
//	local NanoPerchPoint Perch;
	NP = NanoPawn(ViewTarget);
	if (bUsePerAxisBuffer)
	{
		if (NP != None && (NP.bDodging || (NP.Velocity dot vector(NP.Rotation)) < 0.f))
		{
			PerAxisOriginLocInterpSpeed.X = default.PerAxisOriginLocInterpSpeed.X + 32.f;
		}
		else
		{
			PerAxisOriginLocInterpSpeed.X = default.PerAxisOriginLocInterpSpeed.X;
		}
	}
// 	if (NP != None)
// 	{
// 		FramingPitchCounter += DeltaTime * (ViewTarget.Physics == PHYS_Falling ? 3.f : 1.f);
// 		if (FramingPitchCounter > FramingPitchDelay)
// 		{
// 			if (out_DeltaRot.Pitch == 0 && out_DeltaRot.Yaw == 0 && NanoPerchPoint(NP.Base) != None)
// 			{
// 				Perch = NanoPerchPoint(NP.Base);
// 				if (Perch.PerchPole != None && Perch.PerchPole.PoleThrowTarget != None)
// 				{
// 					IdealRot = rotator(Perch.PerchPole.PoleThrowTarget.Location - ThirdPersonCam.PlayerCamera.Location);
// 				}
// 				else if (Perch.PerchPole != None)
// 				{
// 					IdealRot = rotator(Perch.PerchPole.PoleThrowPawnVel);
// 				}
// 				else if (Perch.FireEscape != None )
// 				{
// 					IdealRot = rotator(Perch.FireEscape.InstancedFloorMeshes.Bounds.Origin - Perch.Location);
// 				}
// 				else
// 				{
// 					IdealRot = NP.Rotation;
// 				}
// 				IdealRot.Pitch = Clamp(IdealRot.Pitch,-10000,10000);
// 				out_DeltaRot = RInterpTo(out_ViewRotation,IdealRot,DeltaTime,1.f) - out_ViewRotation;
// 			}
// 			else if (out_DeltaRot.Pitch == 0 && out_DeltaRot.Yaw == 0 && NP.SplineBase != None)
// 			{
// 				if (NP.Velocity.Z < -50)
// 				{
// 					//TargetLoc = NP.Location + (NP.Velocity * 512.f);
// 					//`log("looking down");
// 					TargetLoc = NP.SplineBase.Connections[0].SplineComponent.GetLocationAtDistanceAlongSpline(NP.SplineBase.Connections[0].SplineComponent.GetSplineLength());
// 					InterpRateScale = 0.25f;
// 				}
// 				else
// 				{
// 					//`log("looking at pawn");
// 					TargetLoc = NP.Location;
// 					InterpRateScale = 1.f;
// 				}
// 				IdealRot = rotator(TargetLoc - ThirdPersonCam.PlayerCamera.Location);
// 				out_DeltaRot = RInterpTo(out_ViewRotation,IdealRot,DeltaTime,4.f * InterpRateScale) - out_ViewRotation;
// 				//`log(NP.WorldInfo.TimeSeconds@"spline delta:"@`showvar(out_DeltaRot)@`showvar(NP.Velocity));
// 			}
// /*
// //test - move this to native code and use AutoPan instead of actually changing the controller rotation!
// 			else if (out_DeltaRot.Pitch == 0 && NP.CurrentLadder == None && NP.CurrentTurbine == None)
// 			{
// 				// try to always frame the player
// 				CamLoc = ThirdPersonCam.PlayerCamera.Location;
// 				IdealRot = rotator(ViewTarget.GetTargetLocation() + (ViewTarget.Velocity * DeltaTime) - CamLoc);
// 				//`log("Ideal pre clamp:"@IdealRot.Pitch);
// 				InterpRateScale = FMin((FramingPitchCounter - FramingPitchDelay)/2.5f,1.f);
// 				bApplyPitch = FALSE;
// 				if (ViewTarget.Physics == PHYS_Walking)
// 				{
// 					if (FramingPitchCounter > AutoCenterDelay)
// 					{
// 						// auto center
// 						ClampRange = 1024.f;
// 					}
// 					else
// 					{
// 						// keep the camera from ever auto-pitching too far when ont he ground
// 						ClampRange = 8192.f;
// 					}
// 					// only futz with the camera when walking if we're beyond the clamps
// 					bApplyPitch = (IdealRot.Pitch > ClampRange || IdealRot.Pitch < -ClampRange);
// 				}
// 				else
// 				{
// 					// always try to frame the player when in the air
// 					ClampRange = 10000.f;
// 					bApplyPitch = TRUE;
// 					InterpRateScale *= 2.f;
// 				}
// 				if (bApplyPitch)
// 				{
// 					if (IdealRot.Pitch > ClampRange || IdealRot.Pitch < -ClampRange)
// 					{
// 						IdealRot.Pitch = Clamp(IdealRot.Pitch,-ClampRange,ClampRange);
// 					}
// 					PitchDiff = IdealRot.Pitch - ThirdPersonCam.PlayerCamera.Rotation.Pitch;
// 					//`log("Ideal post clamp:"@IdealRot.Pitch@`showvar(PitchDiff)@"interp rate:"@(abs(PitchDiff)/16384.f * GetPitchInterpRate(NP) * InterpRateScale));
// 					if (abs(PitchDiff) > 500)
// 					{
// 						out_DeltaRot.Pitch += PitchDiff * DeltaTime * (1.f + (abs(PitchDiff)/16384.f * GetPitchInterpRate(NP) * InterpRateScale));
// 						TimeSinceLastDeltaRot = `TimeSinceEx(ViewTarget,LastDeltaRotTime);
// 						if (TimeSinceLastDeltaRot < 5.f)
// 						{
// 							out_DeltaRot.Pitch *= (TimeSinceLastDeltaRot/5.f);
// 						}
// 					}
// 				}
// 			}
// */
// 			else
// 			{
// 				FramingPitchCounter = 0.f;
// 			}
// 		}
// 	}
// 	else
// 	{
// 		LastDeltaRotTime = ViewTarget.WorldInfo.TimeSeconds;
// 		FramingPitchCounter = 0.f;
// 	}
	Super.ProcessViewRotation(DeltaTime,ViewTarget,out_ViewRotation,out_DeltaRot);
}

simulated function AdhereToCameraBone(bool bEnable)
{
	local ViewOffsetData NewViewOffset;
	//`log(`location@`showvar(bEnable));
	if (bEnable)
	{
		bUsePerAxisBuffer = FALSE;
		NewViewOffset.OffsetHigh = vect(0,0,0);
		NewViewOffset.OffsetLow = vect(0,0,0);
		NewViewOffset.OffsetMid = vect(0,0,0);
		SetViewOffset(NewViewOffset);
		OriginRotInterpSpeed = default.OriginRotInterpSpeed * 5.f;
		PerAxisOriginLocInterpSpeed = default.PerAxisOriginLocInterpSpeed * 5.f;
	}
	else
	{
		bInterpLocByTime = FALSE;
		bInterpToIdealLocThenLock = FALSE;
		SetViewOffset(default.ViewOffset);
		ViewOffsetInterp = 1.f;
		OriginRotInterpSpeed = default.OriginRotInterpSpeed;
		PerAxisOriginLocInterpSpeed = default.PerAxisOriginLocInterpSpeed;
	}
}

event OnTargetLeftSafeZone( Pawn TargetPawn )
{
	bPlayerOutOfSafeZone = TRUE;
}

event OnTargetEnteredSafeZone( Pawn TargetPawn )
{
	bPlayerOutOfSafeZone = FALSE;
}

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=-120,Y=60,Z=40),
		OffsetLow=(X=-120,Y=60,Z=40),
		OffsetMid=(X=-120,Y=60,Z=-20),
		)}

	WorstLocOffset=(X=-8,Y=1,Z=95)
	FinalCamOffset=(X=0,Y=20,Z=-8)
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=-30)

	MinSpeedForOffsetY=600
	MaxSpeedForOffsetY=1200
	MaxSpeedOffsetY=-60


	bValidateWorstLoc=FALSE

	bInterpLocation=TRUE
	bUsePerAxisBuffer=FALSE
	bUseCameraBoneRotation=FALSE

	bInterpRotation=TRUE
	bInterpRotByTime=FALSE
	InterpRotTime=0.25f
	bInterpToIdealRotThenLock=FALSE


	OriginLocInterpSpeed=10
	OriginRotInterpSpeed=5

	OffsetAdjustmentInterpSpeed=1.0f

//	bUseCameraBoneRotation=TRUE

	StrafeLeftAdjustment=(X=0,Y=0,Z=0)
	StrafeRightAdjustment=(X=0,Y=0,Z=0)
    StrafeOffsetScalingThreshold=0

	RunFwdAdjustment=(X=0,Y=0,Z=0)
	RunBackAdjustment=(X=-30,Y=0,Z=0)
	RunOffsetScalingThreshold=0

	BlendTime=0.25

	FramingPitchDelay=0.5f
	AutoCenterDelay=3.f

	FanOriginLocOffset=(X=-64.f,Y=0,Z=128)
	LadderOriginLocOffset=(X=-64.f,Y=0,Z=32)

	bDirectLook=FALSE
	bFollowTarget=FALSE

	JeffCamDistanceWhenMoving=100
	JeffCamDistanceWhenFalling=300

	JeffCamFallCamRampInDelay=0.5
	JeffCamFallCamRampInDuration=1

}
