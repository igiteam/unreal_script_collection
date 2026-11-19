/**
 * Special move for quickly jumping out of holes
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Wretch_EmergeQuickJump extends GSM_EmergeQuickJump;

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_start")))
	BS_Transition=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_fall")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_fall")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_land")))
}
