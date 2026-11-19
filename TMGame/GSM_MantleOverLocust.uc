
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MantleOverLocust extends GSM_MidLvlJumpOver
	native(TGSpecialMoves)
	config(TGPawn);

var config		bool	bForceMantleVariation;

/** Returns specialized ideal camera origin for when this special move is playing */
simulated native function vector GetIdealCameraOrigin();

// Base function to handle mantle over variations.
function INT PackSpecialMoveFlags()
{
	if( bForceMantleVariation )
	{
		return 1;
	}

	return Rand(BSList_Jump.Length);
}

/**
 * Use SpecialMove flags so server and client versions are in sync.
 */
simulated function INT PickVariationIndex()
{
	return PawnOwner.SpecialMoveFlags;
}

