/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Targeting extends GearGameplayCameraMode
	config(Camera);

var() protected const vector ViewOffsetAdjustment_Crouch;

var() protected const vector ViewOffsetAdjustment_Kidnapper;

/**
 * When in targeting mode, set depthprioritygroup of pawn and weapon to foreground to prevent clipping
 */
function OnBecomeActive(Pawn CameraTarget, GameThirdPersonCameraMode PrevMode)
{
	local GearPawn GP;

	Super.OnBecomeActive(CameraTarget, PrevMode);

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
			OldWeapon.Mesh.SetViewOwnerDepthPriorityGroup(FALSE, SDPG_World);
		}
		if ( NewWeapon != None && NewWeapon.Mesh != None )
		{
			NewWeapon.Mesh.SetViewOwnerDepthPriorityGroup(TRUE, SDPG_Foreground);
		}
	}
}

/** Get Pawn's relative offset (from location based on pawn's rotation */
function vector AdjustViewOffset( Pawn P, vector Offset )
{
	if( P.bIsCrouched && VSize(P.Velocity) < 1 )
	{
		Offset += ViewOffsetAdjustment_Crouch;
	}

	if (GearPawn(P).IsAKidnapper())
	{
		Offset += ViewOffsetAdjustment_Kidnapper;
	}

	// do super last
	return Super.AdjustViewOffset(P, Offset);
}

/** Returns camera mode desired FOV */
function float GetDesiredFOV( Pawn ViewedPawn )
{
	local GearWeapon Wpn;

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

defaultproperties
{
	bUsePerAxisOriginLocInterp=true
	PerAxisOriginLocInterpSpeed=(Z=8.f)     // stay locked in X/Y

	ViewOffset={(
		OffsetHigh=(X=-40,Y=40,Z=24),
		OffsetLow=(X=-125,Y=45,Z=20),
		OffsetMid=(X=-70,Y=40,Z=6),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-5),
		OffsetLow=(X=0,Y=0,Z=-5),
		OffsetMid=(X=0,Y=0,Z=-5),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
		OffsetHigh=(X=20,Y=-10,Z=0),
		OffsetLow=(X=20,Y=-10,Z=0),
		OffsetMid=(X=20,Y=-10,Z=0),
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

	FOVAngle_ViewportAdjustments(CVT_16to9_VertSplit)=30

	ViewOffsetAdjustment_Crouch=(Z=-15)
	ViewOffsetAdjustment_Kidnapper=(Z=10)

	PerPawnViewOffsetAdjustments.Empty
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustKantusBase',Offset=(X=-50.f,Y=2,Z=5)))
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustBoomerSavageBase',Offset=(X=-45,Y=30,Z=-20)))
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustBoomerBase',Offset=(X=-40,Y=10,Z=-10)))

	PerPawnWorstLocOffsetAdjustments.Empty
	PerPawnWorstLocOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustKantusBase',Offset=(Z=40)))

	WorstLocOffset=(X=0,Y=25,Z=70)

	BlendTime=0.067f

	bAdjustDOF=TRUE
}

