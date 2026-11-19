/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPickupFactory extends PickupFactory
	abstract
	hidecategories(Display,Collision);

/**
 * returns the display name of the item to be picked up
 */
simulated function String GetDisplayName()
{
	return GetHumanReadableName();
}

defaultproperties
{
}