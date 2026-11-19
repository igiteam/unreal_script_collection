/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class GearPointOfInterest_Stalk extends GearPointOfInterest;

/** Get the player readable text for the stalk POI */
simulated function String GetDisplayName()
{
	return GearLambentStalkBase(AttachedToActor).GetDisplayName();
}

