
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentPolyp_MantleUpLowCover extends GSM_NonCoverUserMantleUpLowCover
	config(Pawn);

/** Scale factor for root motion */
var	float RootMotionScaleFactor;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	PawnOwner.Mesh.RootMotionAccelScale.X = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Y = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Z = RootMotionScaleFactor;

	Super.SpecialMoveStarted(bForced,PrevMove);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.Mesh.RootMotionAccelScale.X = 1.f;
	PawnOwner.Mesh.RootMotionAccelScale.Y = 1.f;
	PawnOwner.Mesh.RootMotionAccelScale.Z = 1.f;
}

defaultproperties
{
	BS_MantleUp=(Stance=((Slot=BS_FullBody,AnimName="mantle_over_start")))
	RootMotionScaleFactor=1.3f
}
