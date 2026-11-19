/**
 * Common base class for Locust
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustCreatureBase extends GearPawn
	abstract
	native(Pawn);

/** TRUE if this is a beast mode creature.  Cached for easy access. */
var protectedwrite transient bool bBeastMode;

simulated function PostBeginPlay()
{
	bBeastMode = ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSiege_Base');

	Super.PostBeginPlay();
}

