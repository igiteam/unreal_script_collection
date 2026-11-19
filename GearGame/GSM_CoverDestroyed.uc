
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_CoverDestroyed extends GSM_PushOutOfCover;

function StartPushOut()
{
	Super.StartPushOut();

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(PlayedStance, RBA_Translate, RBA_Translate, RBA_Translate);
	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function DoPushOutSpecifics()
{
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(PlayedStance, RBA_Discard, RBA_Discard, RBA_Discard);
	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Cov_Mid_CoverBreak=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Mid_Destroy")))
	BS_Cov_Mid_CoverBreakMirrored=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Mid_Destroy")))
	BS_Cov_Std_CoverBreak=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Mid_Destroy")))
	BS_Cov_Std_CoverBreakMirrored=(Stance=((Slot=BS_FullBody,AnimName="AR_Cov_Mid_Destroy")))
}
