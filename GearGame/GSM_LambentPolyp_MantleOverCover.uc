
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentPolyp_MantleOverCover extends GSM_NonCoverUserMantleOverCover;

/** Overridden to use standard mantle's version */
function bool VerifyLandingClear(vector InMantleStartLoc, vector InMantleEndLoc)
{
	return Super(GSM_MantleOverCoverBase).VerifyLandingClear(InMantleStartLoc,InMantleEndLoc);
}

defaultproperties
{
	bCheckForMirrorTransition=FALSE
	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_fall")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_land")))
	// for now disable crawl animation - requested by Jay H
	//BSList_Jump(1)=(Stance=((Slot=BS_FullBody,AnimName="mantle_crawl_start")))
	//BSList_Fall(1)=(Stance=((Slot=BS_FullBody,AnimName="mantle_crawl_fall")))
	//BSList_Land(1)=(Stance=((Slot=BS_FullBody,AnimName="mantle_crawl_land")))

	DefaultMantleDistance=160.0f
	FallForwardVelocity=100.f
	GravityScale=1.5f
}
