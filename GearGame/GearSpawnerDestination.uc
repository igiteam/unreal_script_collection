/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// GearSpawnerDestination, location where a spawner will attempt to toss a creature to
//=============================================================================
class GearSpawnerDestination extends Keypoint
	placeable
	native;


/** The minimum speed at which the spawner will shoot a creature in this direction */
var() float MinSpeed;

/** The maximum speed at which the spawner will shoot a creature in this direction */
var() float MaxSpeed;


defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'EditorMaterials.TargetIcon'
		Scale=0.2
	End Object

	MinSpeed=800.0f
	MaxSpeed=1000.0f

	bStatic=FALSE
}
