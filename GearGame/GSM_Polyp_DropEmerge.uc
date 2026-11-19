
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Polyp_DropEmerge extends GSM_BaseVariableFall;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.SetCollision(TRUE, FALSE, FALSE);
	PawnOwner.bCollideWorld = FALSE;
	PawnOwner.SetHidden(FALSE);

	PawnOwner.SetTimer( 0.25f, FALSE, nameof(RestoreCollision), self );
	PawnOwner.SetPhysics( PHYS_Falling );
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	RestoreCollision();
	PawnOwner.FitCollision();
}

simulated function RestoreCollision()
{
	PawnOwner.ClearTimer( nameof(RestoreCollision), self );

	// restore collision
	PawnOwner.SetCollision(PawnOwner.default.bCollideActors, PawnOwner.default.bBlockActors, PawnOwner.default.bIgnoreEncroachers);
	PawnOwner.bCollideWorld = TRUE;
}

defaultproperties
{

	BS_Jump=(Stance=((Slot=BS_FullBody,AnimName="generic_drop_loop")))
	BS_Transition=()
	BS_Fall=(Stance=((Slot=BS_FullBody,AnimName="generic_drop_loop")))
	BS_Land=(Stance=((Slot=BS_FullBody,AnimName="generic_drop_land")))

	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bCameraFocusOnPawn=TRUE
	bLockPawnRotation=FALSE
	bBreakFromCover=TRUE
	bDisableCollision=FALSE
	bDisableMovement=TRUE
	bDisablePhysics=FALSE
	bDisableAI=TRUE

	bDoMeshFloorConform=FALSE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=FALSE
}
