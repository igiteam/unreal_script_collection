/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_FriendlyFire extends GearMutator;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	GearGame(WorldInfo.Game).bAllowFriendlyFire = true;
}
