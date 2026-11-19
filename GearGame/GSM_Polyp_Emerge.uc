
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Polyp_Emerge extends GearSpecialMove;

var GearPawn.BodyStance	BS_Animation;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, SpeedModifier, 0.0f, 0.2f/SpeedModifier, FALSE, TRUE );

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;

	PawnOwner.SetCollision(FALSE, FALSE, FALSE);
	PawnOwner.bCollideWorld = FALSE;
	PawnOwner.SetHidden(false);
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local vector NewLocation;

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);

	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	NewLocation = MatrixGetOrigin(PawnOwner.Mesh.GetBoneMatrix(0)) - PawnOwner.default.Mesh.Translation;
	PawnOwner.SetLocation(NewLocation);
	// restore collision
	PawnOwner.SetCollision(PawnOwner.default.bCollideActors, PawnOwner.default.bBlockActors, PawnOwner.default.bIgnoreEncroachers);
	PawnOwner.bCollideWorld = TRUE;

	PawnOwner.FitCollision();
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Emerge")))

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bCameraFocusOnPawn=TRUE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=TRUE
	bDisableAI=TRUE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE
}
