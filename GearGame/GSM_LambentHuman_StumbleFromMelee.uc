
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_LambentHuman_StumbleFromMelee extends GSM_StumbleFromMelee;

/** Scale factor for root motion */
var	float RootMotionScaleFactor;

protected function bool InternalCanDoSpecialMove()
{
	// Allow stumble if we're doing a melee attack
	return ( Super.InternalCanDoSpecialMove() || PawnOwner.SpecialMove == GSM_SwipeAttack );
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	PawnOwner.Mesh.RootMotionAccelScale.X = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Y = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Z = 1.f;

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
	// We need a different class for this animation, as it uses different root motion
	// We need root motion to be consistant between client and server.
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_React2")))

	RootMotionScaleFactor=2.0f
}