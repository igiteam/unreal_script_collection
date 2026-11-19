
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_StumbleGetUp extends GearSpecialMove;

/** Get up animation */
var()	GearPawn.BodyStance	BS_Animation;

protected function bool InternalCanDoSpecialMove()
{
	return TRUE;
}

function PlayGetUpAnimation()
{
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.3f/SpeedModifier, 0.3f/SpeedModifier, FALSE, TRUE);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate );

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function ClearGetUpAnimation()
{
	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard );

	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Play body stance animation.
	PlayGetUpAnimation();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	ClearGetUpAnimation();
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_Getup")))

	bDisableAI=TRUE
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bCameraFocusOnPawn=TRUE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableMovement=TRUE
}
