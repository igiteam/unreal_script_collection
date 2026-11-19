
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LadderClimbUp extends GSM_LadderClimbDown;

simulated function GetLadderEntryPoint(out Vector Out_EntryLoc, out Rotator Out_EntryRot)
{
	PawnOwner.LadderTrigger.GetBottomEntryPoint(Out_EntryLoc, Out_EntryRot);
}

simulated function bool IsRightLadderTrigger()
{
	return !PawnOwner.LadderTrigger.bIsTopOfLadder;
}

simulated function CheckOverrideAnim()
{
	if (PawnOwner.LadderTrigger.ClimbUpAnim != '')
	{
		BS_Animation.AnimName[BS_FullBody] = PawnOwner.LadderTrigger.ClimbUpAnim;
	}
	else
	{
		BS_Animation.AnimName[BS_FullBody] = default.BS_Animation.AnimName[BS_FullBody];
	}
}

