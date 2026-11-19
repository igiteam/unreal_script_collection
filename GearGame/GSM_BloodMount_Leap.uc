/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_BloodMount_Leap extends GSM_Leap;

simulated function bool IsFallLooping()
{
	return false;
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="Hit_Reaction_Fwd_B")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Mid")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="Mantle_End")))

	PreImpactTime=0.0f
}
