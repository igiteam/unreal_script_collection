
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MantleOverGears extends GSM_MidLvlJumpOver
	native(TGSpecialMoves)
	config(TGPawn);

var	transient	float	LastRollTime;
var config		float	SecondsBetweenRolls;
var config		float	RollChance;
var config		bool	bForceMantleVariation;
var()			float	RollCameraOriginZOffset;

/** Returns specialized ideal camera origin for when this special move is playing */
simulated native function vector GetIdealCameraOrigin();

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

