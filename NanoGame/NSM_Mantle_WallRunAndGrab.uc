/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_WallRunAndGrab extends NSM_Mantle_Base;

protected function bool InternalCanDoSpecialMove()
{
	// No wall run unless dashing or in the air
	if( MyNP.Physics == PHYS_Walking && !MyNP.bIsDashing )
	{
		return FALSE;
	}

	return Super.InternalCanDoSpecialMove();
}

defaultproperties
{
	WalkAnimNames=("NW_Wall_Run_Up")
	FallAnimNames=("NW_Wall_Run_Up")
	InputDirection=DIR_Up
	MantleType=MANTLE_WallRun
	MinAnimRate=0.8f
	MaxAnimRate=1.5f
	LowCheckDistance=30.f
	HighCheckDistance=30.f
	MinHeight=196.f
	MaxHeight=600.f
	RequiredPhysics=(PHYS_Walking,PHYS_Falling)
	MinRequiredSpeed=640
	bAllowJump=FALSE
	bForceCenterView=TRUE
	bForcePostMantleVelocity=TRUE
	PostMantleVelocity=(X=512,Z=768)
	bRequireClearance=TRUE
	bResetOnLanding=TRUE
	MaxVelocityZ=100
	BlendInTime=0.1f
	BlendOutTime=0.2f
	ClothBlend=1.0

	CheckForMantleOnEnd=(NSM_Mantle_Ledge,NSM_Mantle_Waist,NSM_Mantle_ChestHigh)
	CheckForMantleContinuous=(NSM_Mantle_Ledge,NSM_Mantle_ChestHigh,NSM_Mantle_Waist)

	CameraInterpTime=0.6f
}