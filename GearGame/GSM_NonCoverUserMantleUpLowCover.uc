
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_NonCoverUserMantleUpLowCover extends GSM_MantleUpBase
	native(SpecialMoves)
	config(Pawn);

/** Mantle Cover */
var transient CovPosInfo MantleCover;

native function bool HasMantleEdge();

protected function bool InternalCanDoSpecialMove()
{
	local Pawn Obstruction;
	local bool bResult;

	if (PawnOwner.SpecialMove == SM_MantleUpLowCover )
	{
		return FALSE;
	}

	if (PawnOwner.IsHumanControlled())
	{
		if ( PawnOwner.FindCoverFromLocAndDir(PawnOwner.Location, vector(PawnOwner.Rotation), 0.1, 100.0, MantleCover, Obstruction) &&
			 Obstruction == None )
		{
			// pretend we're in cover so we can do the usual mantle checks
			PawnOwner.CurrentLink = MantleCover.Link;
			PawnOwner.LeftSlotIdx = MantleCover.LtSlotIdx;
			PawnOwner.RightSlotIdx = MantleCover.RtSlotIdx;
			bResult = Super.InternalCanDoSpecialMove();
			PawnOwner.CurrentLink = None;
			PawnOwner.LeftSlotIdx = INDEX_NONE;
			PawnOwner.RightSlotIdx = INDEX_NONE;
			return bResult;
		}
		else
		{
			return FALSE;
		}
	}
	else
	{
		return HasMantleEdge();
	}
}

defaultproperties
{
	BS_MantleUp=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Up")))
	BS_MantleUpMirrored=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Up_Mirrored")))
}
