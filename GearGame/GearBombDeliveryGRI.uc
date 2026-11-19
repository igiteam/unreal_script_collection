/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearBombDeliveryGRI extends GearGRI;

/** number of lives the bomb has remaining */
var byte BombLivesRemaining;

replication
{
	if (bNetDirty)
		BombLivesRemaining;
}
