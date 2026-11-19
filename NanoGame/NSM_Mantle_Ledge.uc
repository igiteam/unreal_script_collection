/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Mantle_Ledge extends NSM_Mantle_Base;

defaultproperties
{
	WalkAnimNames=("NW_Jump_Mantle_Up")
	FallAnimNames=("NW_Jump_Mantle_Up")
	InputDirection=DIR_Up
	MantleType=MANTLE_Ledge
	MinAnimRate=0.8f
	MaxAnimRate=1.5f
	LowCheckDistance=60.f
	HighCheckDistance=80.f
	MinHeight=128.f
	MaxHeight=196.f
	BufferDistance=32.f
	RequiredPhysics=(PHYS_Walking,PHYS_Falling,PHYS_None)
	PostMantleVelocity=(X=384)
	bForceCenterView=TRUE
	bRequireClearance=TRUE
	bAllowJump=TRUE
	BlendInTime=0.2f
	BlendOutTime=0.2f
	ClothBlend=1.0
	bImmediateLanding=TRUE
}