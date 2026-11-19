/**
 * A facility to spawn pawns every multiplayer round.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawnFactory extends NavigationPoint
	placeable;

/** The type of pawn to spawn at this location */
var() class<GearPawnRidable_Base> PawnType;

defaultproperties
{
	Begin Object NAME=Sprite
		Sprite=Texture2D'GearsIcons.MeatflagIcon'
		Scale=0.25
	End Object
}