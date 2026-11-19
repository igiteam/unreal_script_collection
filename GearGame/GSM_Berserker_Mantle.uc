/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_Mantle extends GSM_NonCoverUserMantleOverCover;


/** Move started so clear the destination flag */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	PawnOwner.Mesh.RootMotionDelta.Translation = vect(0,0,0);
	PawnOwner.Mesh.RootMotionDelta.Scale = 0.0f;
	PawnOwner.Mesh.RootMotionDelta.Rotation.X = 0.0f;
	PawnOwner.Mesh.RootMotionDelta.Rotation.Y = 0.0f;
	PawnOwner.Mesh.RootMotionDelta.Rotation.Z = 0.0f;
	PawnOwner.Mesh.RootMotionDelta.Rotation.W = 0.0f;
	PawnOwner.Mesh.RootMotionVelocity = vect(0,0,0);
}


defaultproperties
{
	DefaultMantleDistance=230.0f
	FallForwardVelocity=0.f
	GravityScale=4.f
	bCheckForMirrorTransition=FALSE
	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Walk_Start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Walk_Mid")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Walk_End")))
	bLockPawnRotation=TRUE
}
