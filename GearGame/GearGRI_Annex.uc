/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_Annex extends GearGRI_MP;


/** Current amount of CP resource points left */
var int CPResourceLeft;

/** The resource goal for Annex/KOTH (for use in displaying in the scoreboard) */
var int AnnexResourceGoal;


replication
{
	if (bNetDirty)
		CPResourceLeft;
	if (bNetInitial)
		AnnexResourceGoal;
}
