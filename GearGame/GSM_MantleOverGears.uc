
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MantleOverGears extends GSM_MidLvlJumpOver
	native(SpecialMoves)
	config(Pawn);

// Base function to handle mantle over variations.
function INT PackSpecialMoveFlags()
{
	return 0;
}

/**
 * Use SpecialMove flags so server and client versions are in sync.
 */
simulated function INT PickVariationIndex()
{
	return PawnOwner.SpecialMoveFlags;
}

/**
 * Allow special moves to delay DBNO until they are complete
 * 
 * @return true if DBNO should be delayed
 */
function bool CanDelayDBNO()
{
	return TRUE;
}

defaultproperties
{
	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mid")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_End")))
	BSList_MirroredJump(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mirrored_Start")))
	BSList_MirroredFall(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mirrored_Mid")))
	BSList_MirroredLand(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mirrored_End")))
}