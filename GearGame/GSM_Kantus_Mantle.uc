/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Kantus_Mantle extends GSM_NonCoverUserMantleOverCover;

defaultproperties
{
	DefaultMantleDistance=136.0
	FallForwardVelocity=0
	GravityScale=4.0
	bCheckForMirrorTransition=false
	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="Kantus_Mantle_Start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="Kantus_Mantle_Mid")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="Kantus_Mantle_End")))
}
