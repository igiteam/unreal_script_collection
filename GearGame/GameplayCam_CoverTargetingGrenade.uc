/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_CoverTargetingGrenade extends GameplayCam_Cover
	config(Camera)
	native(Camera);

/** Affects camera pitch, but not pitch of grenade arc.  Goal is to limit camera pitch so plane the player is on is always visible. */
var() protected vector2d GrenadeCamPitchLimit;

cpptext
{
	// GearGameplayCameraMode interface
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
};


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

defaultproperties
{
	PawnRel_Posture_MidLevel=(X=0,Y=40,Z=-20)
	PawnRel_Mod_PopUp_MidLevel=(X=0,Y=30,Z=32)
	PawnRel_Mod_Lean_Standing=(X=0,Y=83,Z=0)
	PawnRel_Mod_Lean_MidLevel=(X=0,Y=70,Z=0)
	PawnRel_Mod_CoverEdge=(X=0,Y=0,Z=0)

	ViewOffset={(
		OffsetHigh=(X=-128,Y=0,Z=24),
		OffsetLow=(X=-140,Y=0,Z=32),
		OffsetMid=(X=-160,Y=0,Z=35),
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

	PerPawnViewOffsetAdjustments.Empty
	PerPawnViewOffsetAdjustments.Add((PawnClass=class'GearPawn_LocustKantusBase',Offset=(X=0,Y=0,Z=-30)))

	bUsePerAxisOriginLocInterp=true
	PerAxisOriginLocInterpSpeed=(Z=8.f)     // stay locked in X/Y

	bInterpRotation=TRUE
	OriginRotInterpSpeed=8

	WorstLocOffset=(X=0,Y=-15,Z=85)
	WorstLocOffsetLow=(X=0,Y=-15,Z=45)

	BlendTime=0.067f

	GrenadeCamPitchLimit=(X=-10000.f,Y=3500.f)
}

