/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_StepDown extends NSM_Mantle_Base;

defaultproperties
{
	WalkAnimNames=("NW_Jump_Mantle_Down_Waisthigh_Up")
	InputDirection=DIR_Up
	MantleType=MANTLE_StepDown
	MinAnimRate=0.8f
	MaxAnimRate=1.5f
	LowCheckDistance=5.f
	HighCheckDistance=40.f
	MinHeight=-10.f
	MaxHeight=10.f
	ClearanceDistance=100.f
	RequiredPhysics=(PHYS_Walking)
	PostMantleVelocity=(X=128)
	PostMantleFallSetName=MantleDown
	bRequireClearance=TRUE
	MinRequiredSpeed=10
	MaxSpeed=100
	BlendInTime=0.2f
	BlendOutTime=0.2f
	ClothBlend=1.0
	bRequireLandingClearance=TRUE
}