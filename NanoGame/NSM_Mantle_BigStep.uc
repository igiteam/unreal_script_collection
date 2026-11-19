/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_BigStep extends NSM_Mantle_Base;

defaultproperties
{
	WalkAnimNames=("NW_Jump_Mantle_Up_BigStep")
	FallAnimNames=("NW_Jump_Mantle_Up_BigStep")
	InputDirection=DIR_Up
	MantleType=MANTLE_BigStep
	LowCheckDistance=60.f
	HighCheckDistance=80.f
	MinAnimRate=1.f
	MaxAnimRate=2.f
	MinHeight=60.f
	MaxHeight=70.f
	RequiredPhysics=(PHYS_Walking,PHYS_Falling)
	bAllowJump=TRUE
	bImmediateLanding=TRUE
	bRestorePreMantleVelocity=TRUE
	bRequireClearance=TRUE
	MinRequiredSpeed=640
	BlendInTime=0.1f
	BlendOutTime=0.2f
	ClothBlend=1.0
	bForceCenterView=TRUE
}