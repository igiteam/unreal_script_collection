/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_ChestHigh extends NSM_Mantle_Base;

defaultproperties
{
	WalkAnimNames=("NW_Jump_Mantle_Up_ChestHigh","NW_Jump_Mantle_Up_ChestHigh_Roll")
	FallAnimNames=("NW_Jump_Mantle_Up_ChestHigh_Roll")
	InputDirection=DIR_Up
	bAllowSlopes=TRUE
	MantleType=MANTLE_ChestHigh
	MinAnimRate=0.6f
	MaxAnimRate=1.35f
	LowCheckDistance=60.f
	HighCheckDistance=80.f
	MinHeight=124.f
	MaxHeight=132.f
	RequiredPhysics=(PHYS_Walking,PHYS_Falling)
	PostMantleVelocity=(X=128)
	bRestorePreMantleVelocity=TRUE
	bRequireClearance=TRUE
	MinRequiredSpeed=640
	BlendInTime=0.2f
	BlendOutTime=0.1f
	ClothBlend=1.0
	bImmediateLanding=TRUE
}