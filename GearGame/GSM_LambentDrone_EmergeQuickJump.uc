/**
 * Special move for quickly jumping out of holes
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentDrone_EmergeQuickJump extends GSM_EmergeQuickJump;

simulated function bool IsFallLooping()
{
	return false;
}

defaultproperties
{
	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="vertical_jump_start")))
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="vertical_jump_middle")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="vertical_jump_end")))
}
