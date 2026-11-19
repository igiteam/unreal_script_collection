
/**
 * GSM_Berserker_HODHitReaction
 * Hammer of Dawn hit reaction animation.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_HODHitReaction extends GearSpecialMove;

var()	GearPawn.BodyStance	BS_Animation;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Play looping body stance animation.
	PawnOwner.BS_Play(BS_Animation, 1.f, 0.2f, -1.f, TRUE, TRUE);

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate);

	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);

	// Stop animation if it didn't already
	PawnOwner.BS_Stop(BS_Animation, 0.2f);

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;
}


defaultproperties
{
	bRestoreMovementAfterMove=FALSE
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="hod_death_loop")))
}
