
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Wretch_Run2Cover extends GSM_Run2Cover;

defaultproperties
{
	BS_TravelAnimation=(Stance=((Slot=BS_FullBody,AnimName="run_fwd2cov_start")))
	BS_TravelAnimationMirrored=(Stance=((Slot=BS_FullBody,AnimName="run_fwd2cov_start"))) //@fixme laurent -- needs mirrored version
	BS_ImpactAnimation=(Stance=((Slot=BS_FullBody,AnimName="run_fwd2cov_stop")))
}
