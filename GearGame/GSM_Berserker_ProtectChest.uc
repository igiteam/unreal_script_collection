
/**
 * GSM_Berserker_ProtectChest
 * This is actually used for transitioning from one phase to another during the fight
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_ProtectChest extends GearSpecialMove;


/** References to the anims to use */
var() GearPawn.BodyStance BS_FirstTransition;
var() GearPawn.BodyStance BS_SecondTransition;

/** Reference to the anim that was actually used */
var GearPawn.BodyStance BS_TransitionUsed;


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustBerserkerLambentBase BerserkerPawn;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// Determine which transition anim to use
	BerserkerPawn = GearPawn_LocustBerserkerLambentBase(PawnOwner);
	BS_TransitionUsed = (BerserkerPawn.CurrentPhase == 0) ? BS_FirstTransition : BS_SecondTransition;

	// Play phase transition animation
	PawnOwner.BS_Play(BS_TransitionUsed, 1.f, 0.3f, 0.3f, false, true);

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_TransitionUsed, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.BS_SetAnimEndNotify(BS_TransitionUsed, TRUE);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.BS_SetAnimEndNotify(BS_TransitionUsed, FALSE);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_TransitionUsed, RBA_Discard, RBA_Discard, RBA_Discard);

	// Stop animation if it didn't already
	PawnOwner.BS_Stop(BS_TransitionUsed, 0.3f);

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	Super.SpecialMoveEnded(PrevMove, NextMove);
}


defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableAI=TRUE
	bRestoreMovementAfterMove=FALSE
	BS_FirstTransition=(Stance=((Slot=BS_FullBody,AnimName="AngerState_Transition_1")))
	BS_SecondTransition=(Stance=((Slot=BS_FullBody,AnimName="AngerState_Transition_1")))
}
