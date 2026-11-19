/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearBulletWhip extends Object
	hidecategories(Object)
	placeable;

/** Sound that is played when the bullets go whizzing past your head */
var() SoundCue WeaponWhipSound;

/** How long to wait between playing another bullet whip */
var() float MinTimeBetweenBulletWhips;

/** How likely it is that a bullet whip will play, 1.0 is 100% */
var() float BulletWhipChance;

defaultproperties
{
	MinTimeBetweenBulletWhips=2.f
	BulletWhipChance=1.0
}