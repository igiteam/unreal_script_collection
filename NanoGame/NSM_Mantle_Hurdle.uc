/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_Hurdle extends NSM_Mantle_Base;

defaultproperties
{
	WalkAnimNames=("NW_Jump_Mantle_Hurdle")
	InputDirection=DIR_Up
	MantleType=MANTLE_Hurdle
	MinAnimRate=0.8f
	MaxAnimRate=1.4f
	LowCheckDistance=60.f
	HighCheckDistance=240.f
	MinHeight=70.f
	MaxHeight=100.f
	ClearanceDistance=100.f
	RequiredPhysics=(PHYS_Walking)
	PostMantleVelocity=(X=128)
	bRestorePreMantleVelocity=TRUE
	bRequireClearance=TRUE
	MinRequiredSpeed=640
	bImmediateLanding=TRUE
	BlendInTime=0.1f
	BlendOutTime=0.2f
	ClothBlend=1.0
	bRequireLandingClearance=TRUE
}