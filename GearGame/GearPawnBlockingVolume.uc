/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawnBlockingVolume extends BlockingVolume
	native;

/** whether to block PCs */
var() bool bBlockPlayers;
/** whether to block NPCs */
var() bool bBlockMonsters;

cpptext
{
	virtual UBOOL IgnoreBlockingBy(const AActor* Other) const;
}

defaultproperties
{
	bBlockPlayers=true
	bBlockMonsters=true
}
