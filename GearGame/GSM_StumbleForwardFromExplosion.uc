
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_StumbleForwardFromExplosion extends GSM_BasePlaySingleAnim
	config(Pawn);

/**
 * Checks to see if this Special Move can be done.
 */
protected function bool InternalCanDoSpecialMove()
{
	// in cover, you can't do
	if (PawnOwner.CoverType != CT_None)
	{
		return FALSE;
	}

	// hit something forward
	if (PawnOwner.FastTrace(PawnOwner.Location + vector(PawnOwner.Rotation)*200.f, PawnOwner.Location, vect(10, 10, 10)) == FALSE)
	{
		return FALSE;
	}

	// check to make sure it has enough space
	return Super.InternalCanDoSpecialMove();
}

function PlayAnimation()
{
	Super.PlayAnimation();

	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);
 	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AR_RoadieRun_Fwd_DropDown_Stumble")))

	BlendInTime=0.1f
	BlendOutTime=0.1f
}
