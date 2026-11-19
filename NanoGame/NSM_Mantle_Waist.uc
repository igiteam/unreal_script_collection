/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_Waist extends NSM_Mantle_Base;

defaultproperties
{
	WalkAnimNames=("Sword_Jump_Mantle_Up_WaistHigh","Sword_Jump_Mantle_Up_WaistHigh_Roll")
	FallAnimNames=("Sword_Jump_Mantle_Up_WaistHigh_Roll")
	InputDirection=DIR_Up
	MantleType=MANTLE_Waist
	bAllowSlopes=TRUE
	MinAnimRate=0.6f
	MaxAnimRate=1.25f
	LowCheckDistance=60.f
	HighCheckDistance=80.f
	MinHeight=90.f
	MaxHeight=100.f
	RequiredPhysics=(PHYS_Walking,PHYS_Falling)
	PostMantleVelocity=(X=128)
	bRestorePreMantleVelocity=TRUE
	bRequireClearance=TRUE
	MinRequiredSpeed=640
	BlendInTime=0.1f
	BlendOutTime=0.1f
	ClothBlend=1.0
	bImmediateLanding=TRUE
}