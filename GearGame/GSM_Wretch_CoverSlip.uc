
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Wretch_CoverSlip extends GSM_CoverSlip;

// function StartCoverSlip()
// {
// 	Super.StartCoverSlip();
// 
// 	// now bash proper root motion mode
// 	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
// 
// }

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{   
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// now bash proper root motion mode
	PawnOwner.Mesh.RootMotionMode = RMM_Velocity;
}

defaultproperties
{
	BS_Cov_Mid_Slip=(Stance=((Slot=BS_FullBody,AnimName="coverbreak_rt")))
	BS_Cov_Mid_Slip_Mirrored=(Stance=((Slot=BS_FullBody,AnimName="coverbreak_lt")))
	BS_Cov_Std_Slip=(Stance=((Slot=BS_FullBody,AnimName="coverbreak_rt")))
	BS_Cov_Std_Slip_Mirrored=(Stance=((Slot=BS_FullBody,AnimName="coverbreak_lt")))
}
