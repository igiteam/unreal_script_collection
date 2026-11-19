/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Default extends GearGameplayCameraMode
	config(Camera)
	native(Camera);

var() protected const vector	ViewOffsetAdjustment_Evade;

/** Z adjustment to camera worst location if target pawn is in aiming stance */
var() protected const float		WorstLocAimingZOffset;

var protected transient bool	bTemporaryOriginRotInterp;
var() protected const float		TemporaryOriginRotInterpSpeed;


/** Get Pawn's relative offset (from location based on pawn's rotation */
function vector AdjustViewOffset(Pawn P, vector Offset)
{
	local GearPawn	GP;

	GP = GearPawn(P);
	if ( (GP != None) && GP.IsEvading() )
	{
		Offset += ViewOffsetAdjustment_Evade;
	}

	// do super last
	return Super.AdjustViewOffset(P, Offset);
}

simulated function vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
	local GearPawn	WP;
	local vector	WorstLocation;

	WorstLocation = super.GetCameraWorstCaseLoc(TargetPawn, CurrentViewTarget);

	WP = GearPawn(TargetPawn);
	if ( (WP != None) && WP.IsInAimingPose() )
	{
		WorstLocation.Z += WorstLocAimingZOffset;
	}
	// else super version just falls through

	return WorstLocation;
}

function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	super.OnBecomeActive(TargetPawn, PrevMode);

	// limiting to grenade modes for now, but might work ok for any modes?
	if ( ( (GameplayCam_CoverTargetingGrenade(PrevMode) != None) || (GameplayCam_TargetingGrenade(PrevMode) != None) ) &&
		 PrevMode.bInterpRotation
		) 
	{
		bTemporaryOriginRotInterp = TRUE;
	}
}

defaultproperties
{
	TemporaryOriginRotInterpSpeed=12.f

	WorstLocOffset=(X=-8,Y=1,Z=95)
	WorstLocAimingZOffset=-10
	bValidateWorstLoc=FALSE

	bUsePerAxisOriginLocInterp=true
	PerAxisOriginLocInterpSpeed=(X=5,Y=20,Z=20)

	ViewOffsetAdjustment_Evade=(Z=-28)

	ViewOffset={(
		OffsetHigh=(X=-128,Y=56,Z=40),
		OffsetLow=(X=-160,Y=48,Z=56),
		OffsetMid=(X=-160,Y=48,Z=16),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-12),
		OffsetLow=(X=0,Y=0,Z=-12),
		OffsetMid=(X=0,Y=0,Z=-12),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
		OffsetHigh=(X=70,Y=-30,Z=20),
		OffsetLow=(X=70,Y=-30,Z=20),
		OffsetMid=(X=70,Y=-30,Z=20),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_Full)={(
		OffsetHigh=(X=0,Y=0,Z=17),
		OffsetLow=(X=0,Y=0,Z=17),
		OffsetMid=(X=0,Y=0,Z=17),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-15),
		OffsetLow=(X=0,Y=0,Z=-15),
		OffsetMid=(X=0,Y=0,Z=-15),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	FOVAngle_ViewportAdjustments(CVT_16to9_VertSplit)=40

	PerPawnViewOffsetAdjustments.Empty
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustKantusArmorBase',Offset=(Y=15,Z=-25)))
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustKantusBase',Offset=(Z=-25)))
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustBoomerBase',Offset=(X=-10,Y=15,Z=-30)))
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustWretchBase',Offset=(X=-80,Y=30,Z=20)))
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustBloodMountBase',Offset=(X=-130,Y=40,Z=-20)))
	
	PerPawnWorstLocOffsetAdjustments.Empty
	PerPawnWorstLocOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustKantusBase',Offset=(Z=40)))
	PerPawnWorstLocOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustBloodMountBase',Offset=(Z=80)))

	BlendTime=0.67
}
