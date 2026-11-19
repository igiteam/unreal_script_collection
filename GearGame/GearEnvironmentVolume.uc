
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Used to define certain gameplay areas, and has optional support for interacting with the NavMesh
 * (To block some types of enemies from pathing through it).
 */

class GearEnvironmentVolume extends EnvironmentVolume
	native
	placeable;

/** If TRUE, BabyCorpsers won't be allowed burrowing through that volume */
var()   const bool  bNoBabyCorpserBurrowing;

defaultproperties
{
}
