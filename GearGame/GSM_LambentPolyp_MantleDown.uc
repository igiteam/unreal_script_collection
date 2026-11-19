
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_LambentPolyp_MantleDown extends GSM_MantleDown;

simulated function PlayJump()
{
	Super(GSM_BaseVariableFall).PlayJump();
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Jump, RBA_Translate, RBA_Translate, RBA_Translate);
	PawnOwner.Mesh.RootMotionAccelScale = vect(4, 4, 0.5);  // pipe_drop anim isn't really meant for small mantle down
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}

simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	PawnOwner.SetLocation(MatrixGetOrigin(PawnOwner.Mesh.GetBoneMatrix(0)) - PawnOwner.default.Mesh.Translation);
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
	BS_MantleDown=(Stance=((Slot=BS_FullBody,AnimName="pipe_drop")))
}
