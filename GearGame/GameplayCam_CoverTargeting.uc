/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_CoverTargeting extends GameplayCam_Cover
	native(Camera)
	config(Camera);

var() protected vector LeanOriginOffset;
var() protected vector LeanOriginOffsetLow;

var ECoverAction LastCoverAction;

/** Blend time for lean <-> 360 aiming transition */
var() float		LeanTo360AimingBlendTime;

cpptext
{
	/** Returns time to interpolate FOV changes. */
	virtual FLOAT GetBlendTime(class APawn* Pawn);
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
}

/**
 * When in targeting mode, set depthprioritygroup of pawn and weapon to foreground to prevent clipping
 */
function OnBecomeActive(Pawn CameraTarget, GameThirdPersonCameraMode PrevMode)
{
	local GearPawn GP;

	Super.OnBecomeActive(CameraTarget, PrevMode);

	LastCoverAction = CA_Default;

	GP = GearPawn(CameraTarget);
	if ( (GP != None) && (CameraTarget.Controller != None) &&  CameraTarget.Controller.IsLocalPlayerController() )
	{
		GP.SetDepthPriorityGroup(SDPG_Foreground);
	}
}

/**
 * When leave targeting mode, reset depthprioritygroup of pawn and weapon to world
 */
function OnBecomeInActive(Pawn CameraTarget, GameThirdPersonCameraMode NewMode)
{
	local GearPawn GP;

	Super.OnBecomeInActive(CameraTarget, NewMode);

	GP = GearPawn(CameraTarget);
	if ( (GP != None) && (CameraTarget.Controller != None) &&  CameraTarget.Controller.IsLocalPlayerController() )
	{
		GP.SetDepthPriorityGroup(SDPG_World);
	}
}

/**
 * When in targeting mode, make sure weapon changes update the weapon mesh depthprioritygroup properly
 */
function WeaponChanged(Controller C, Weapon OldWeapon, Weapon NewWeapon)
{
	if ( (C != None) && C.IsLocalPlayerController() )
	{
		if ( OldWeapon != None && OldWeapon.Mesh != None )
		{
			OldWeapon.Mesh.SetViewOwnerDepthPriorityGroup(FALSE,SDPG_World);
		}
		if ( NewWeapon != None && NewWeapon.Mesh != None )
		{
			NewWeapon.Mesh.SetViewOwnerDepthPriorityGroup(TRUE,SDPG_Foreground);
		}
	}
}

/** returns camera mode desired FOV */
function float GetDesiredFOV( Pawn ViewedPawn )
{
	local GearWeapon			Wpn;

	Wpn = GearWeapon(ViewedPawn.Weapon);

	if (Wpn != None)
	{
		return Wpn.GetTargetingFOV(FOVAngle) + FOVAngle_ViewportAdjustments[CurrentViewportType];
	}
	else
	{
		return Super.GetDesiredFOV(ViewedPawn);
	}
}
 
/** Get Pawn's relative offset (from location based on pawn's rotation */
function vector AdjustViewOffset( Pawn P, vector Offset )
{
	local GearPawn WP;
	local float NonAnimWeight, LeanBlendWeight;
	local vector NewOffset;

	Offset = Super.AdjustViewOffset(P, Offset);

	WP = GearPawn(P);
	if( WP != None )
	{
		// Interpolate with animation so it's smoother
		NonAnimWeight = (WP.CoverAction == CA_LeanLeft || WP.CoverAction == CA_LeanRight) ? 1.f : 0.f;
		LeanBlendWeight = (WP.CoverBlendNode != None && (WP.IsDoing360ToLeaningTransition() || WP.IsDoingLeaningTo360Transition() || WP.IsDoingPopUpToLeanTransition()))
			? WP.CoverBlendNode.Children[5].Weight *  WP.CoverBlendNode.NodeTotalWeight : NonAnimWeight;

		if( LeanBlendWeight > 0.01f )
		{
			NewOffset = (WP.CoverType == CT_MidLevel) ? LeanOriginOffsetLow : LeanOriginOffset;
			if( WP.bIsMirrored )
			{
				NewOffset.Y = -NewOffset.Y;
			}
			Offset += NewOffset * LeanBlendWeight;
		}
	}

	return Offset;
}

simulated function RestoreInterpLocSpeedToDefault()
{
	OriginLocInterpSpeed = default.OriginLocInterpSpeed;
}

simulated protected function vector AdjustOffsetForStance(GearPawn WP, const out vector Offset)
{
	return Offset;
}

defaultproperties
{
	bUsePerAxisOriginLocInterp=true
	PerAxisOriginLocInterpSpeed=(Z=8.f)     // stay locked in X/Y

	PawnRel_Posture_Standing=(X=-10,Y=40,Z=8)
	PawnRel_Posture_MidLevel=(X=-10,Y=8,Z=-82)

	PawnRel_Mod_MidLvlBlindUp=(X=0,Y=40,Z=8)

	PawnRel_Mod_PopUp_MidLevel=(X=15,Y=34,Z=86)
	PawnRel_Mod_360Aim_PopUp=(X=-7,Y=42,Z=35)
	PawnRel_Mod_Lean_Standing=(X=0,Y=10,Z=-4)
	PawnRel_Mod_Lean_MidLevel=(X=0,Y=40,Z=35)

	PawnRel_Mod_Lean_360Aim_Standing=(X=0,Y=0,Z=0)
	PawnRel_Mod_Lean_360Aim_MidLevel=(X=0,Y=34,Z=86)		// same as PawnRel_Mod_360Aim_PopUp

	PawnRel_Mod_CoverEdge=(X=0,Y=0,Z=0)

	// modify these to offset the camera when you are in cover and are targeting
	ViewOffset={(
		OffsetHigh=(X=-80,Y=0,Z=64),
		OffsetMid=(X=-80,Y=0,Z=0),
		OffsetLow=(X=-96,Y=0,Z=8),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-5),
		OffsetLow=(X=0,Y=0,Z=-5),
		OffsetMid=(X=0,Y=0,Z=-5),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_Full)={(
		OffsetHigh=(X=0,Y=0,Z=3),
		OffsetLow=(X=0,Y=0,Z=3),
		OffsetMid=(X=0,Y=0,Z=3),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-5),
		OffsetLow=(X=0,Y=0,Z=-5),
		OffsetMid=(X=0,Y=0,Z=-5),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	WorstLocOffset=(X=0,Y=-15,Z=85)
	WorstLocOffsetLow=(X=0,Y=-15,Z=45)

	BlendTime=0.067f
	LeanTo360AimingBlendTime=0.30f

	LeanOriginOffset=(Y=48)
	LeanOriginOffsetLow=(Y=48)

	OriginLocInterpSpeed=8.f
	OffsetAdjustmentInterpSpeed=8.f

	bAdjustDOF=TRUE
}
