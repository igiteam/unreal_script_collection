
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Emerge extends GearSpecialMove;

var Array<GearPawn.BodyStance>	StanceArray;
var int							VariationIndex;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local BodyStance Stance;

	Super.SpecialMoveStarted(bForced,PrevMove);

	VariationIndex	= PawnOwner.SpecialMove - SM_Emerge_Type1;

//@todo -- This code is needlessly slow
	Stance = StanceArray[VariationIndex];
	// Play body stance animation.
	PawnOwner.BS_Play(Stance, SpeedModifier, 0.0f, 0.2f/SpeedModifier, FALSE, TRUE );

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(Stance, RBA_Translate, RBA_Translate, RBA_Translate);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(Stance, TRUE);

	// Turn on Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = RMM_Translate;

	PawnOwner.SetCollision(PawnOwner.bCollideActors, FALSE);
	PawnOwner.bCollideWorld = FALSE;
    // Drudges start hidden until this plays
	PawnOwner.SetHidden(false);
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local BodyStance Stance;

	Super.SpecialMoveEnded(PrevMove, NextMove);

//@todo -- This code is needlessly slow
	Stance = StanceArray[VariationIndex];
	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(Stance, RBA_Discard, RBA_Discard, RBA_Discard);

	PawnOwner.BS_SetAnimEndNotify(Stance, FALSE);

	// Turn off Root motion on mesh.
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;

	// restore collision
	PawnOwner.SetCollision(PawnOwner.default.bCollideActors, PawnOwner.default.bBlockActors);
	PawnOwner.bCollideWorld = TRUE;

	PawnOwner.FitCollision();
}

defaultproperties
{
	StanceArray(0)=(Stance=((Slot=BS_FullBody,AnimName="Emerge")))
	StanceArray(1)=(Stance=((Slot=BS_FullBody,AnimName="Emerge")))

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
