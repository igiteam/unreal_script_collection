/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_SniperZoom extends GearGameplayCameraMode
	native(Camera)
	config(Camera);

/** Save a reference to the scope, target pawn seems to drop weapon reference before we go inactive */
var GearScope_Sniper SniperScope;

cpptext
{
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
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

/**
 * Show the scope mesh
 * 
 * @param TargetPawn - the pawn we're viewing
 * 
 * @param PrevMode - the previous camera mode we were in
 */
function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	local GearWeapon GW;
	local GearPC GPC;

	if (TargetPawn != None)
	{
		GPC = GearPC(TargetPawn.Controller);
		// We don't want to mess with the scope if this cam is not the one the target pawn is using
		if (GPC != None && GPC.PlayerCamera == GameplayCam.PlayerCamera)
		{
			GW = GearWeapon(TargetPawn.Weapon);
			if (GW != None)
			{
				SniperScope = GW.Scope;
			}

			if (SniperScope != None)
			{
				SniperScope.EnableScope();
			}
		}
	}

	Super.OnBecomeActive(TargetPawn, PrevMode);
}

/**
 * Hide the scope mesh
 * 
 * @param TargetPawn - the pawn we're viewing
 * 
 * @param NewMode - the camera mode we're entering
 */
function OnBecomeInActive(Pawn TargetPawn, GameThirdPersonCameraMode NewMode)
{
	if (SniperScope != None)
	{
		SniperScope.DisableScope();
		SniperScope = None;
	}

	Super.OnBecomeInActive(TargetPawn, NewMode);
}

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	BlendTime=0.067f

	bDoPredictiveAvoidance=FALSE
	bInterpLocation=TRUE

	DOF_BlurKernelSize=8.f
	DOF_FocusInnerRadius=1000.f
	DOFDistanceInterpSpeed=8.f

	bAdjustDOF=TRUE

	bNoFOVPostProcess=TRUE
}

