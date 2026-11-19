/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_WallRun extends NSM_Mantle_Base;


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
	bCanBeUsedByAI=FALSE
	bCheckForPathInEditor=FALSE
	MantleType=MANTLE_WallRun
	MinAnimRate=0.8f
	MaxAnimRate=1.5f
	LowCheckDistance=30.f
	HighCheckDistance=30.f
	MinHeight=60.f
	MaxHeight=196.f
	RequiredPhysics=(PHYS_Walking,PHYS_Falling)
	MinRequiredSpeed=640
	bAllowJump=TRUE
	bForceCenterView=TRUE
	PostMantleVelocity=(X=512,Z=768)
	bResetOnLanding=TRUE
	MaxVelocityZ=100
	BlendInTime=0.1f
	BlendOutTime=0.2f
	ClothBlend=1.0

	CheckForMantleOnEnd=(NSM_Mantle_Waist,NSM_Mantle_ChestHigh,NSM_Mantle_Ledge)
	CheckForMantleContinuous=(NSM_Mantle_Ledge,NSM_Mantle_ChestHigh,NSM_Mantle_Waist)
}