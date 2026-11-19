
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentHuman_MantleDown extends GSM_MantleDown;

simulated function PlayJump()
{
	Super(GSM_BaseVariableFall).PlayJump();

	PawnOwner.BS_SetRootBoneAxisOptions(BS_Jump, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	PawnOwner.EndSpecialMove();
}

simulated function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	PawnOwner.SetCollision(PawnOwner.bCollideActors, false, true);
	Super.SpecialMoveStarted(bForced, PrevMove);
}

simulated function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.SetCollision(PawnOwner.bCollideActors, PawnOwner.default.bBlockActors, PawnOwner.default.bIgnoreEncroachers);
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_MantleDown=(Stance=((Slot=BS_FullBody,AnimName="mantle_down")))
	JumpingPhysics=PHYS_None
}
