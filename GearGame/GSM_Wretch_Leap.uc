/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Wretch_Leap extends GSM_Leap;

simulated function bool IsFallLooping()
{
	return false;
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="ceiling_jump_start")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="ceiling_jump_fall")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="ceiling_drop_land")))

	PreImpactTime=0.0f
}
