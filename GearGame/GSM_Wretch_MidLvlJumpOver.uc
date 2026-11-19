
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Wretch_MidLvlJumpOver extends GSM_MidLvlJumpOver;


defaultproperties
{
	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_fall")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_land")))

	bCheckForMirrorTransition=FALSE
	BSList_MirroredJump(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_start")))
	BSList_MirroredFall(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_fall")))
	BSList_MirroredLand(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_land")))

	DefaultMantleDistance=115.0
}
