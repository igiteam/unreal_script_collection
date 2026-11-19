
/**
 * Matinee Special Move
 * During this time, input is controlled, and animation is controlled by either Matinee or Kismet
 * This state can't be interrupted until it's disabled back again 
 * This state is to incorporate in-game cinematic to be more seamless without using SkeletalMeshActors
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_EngageMatinee extends GSM_Engage
		native(SpecialMoves);

var Actor TargetActor;

// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

protected function bool InternalCanDoSpecialMove()
{
	return TRUE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	TargetActor = PawnOwner.EngageMatineeMode_Actor;
	PawnOwner.SetPawnMuteGUDS( TRUE );

	Super.SpecialMoveStarted(bForced, PrevMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	TargetActor = none;
	PawnOwner.SetPawnMuteGUDS( FALSE );

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bCameraFocusOnPawn=TRUE
	bLockPawnRotation=TRUE
	bBreakFromCover=TRUE
	bDisableMovement=TRUE

	bDoMeshFloorConform=TRUE
	bDoIKFloorConform=FALSE
	bDoFootPlacement=TRUE
}
