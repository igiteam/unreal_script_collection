/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoChasisModifier extends NanoWeaponModifier
	config(Weapon)
	native(Weapon)
	abstract;



/** Get how much faster of a reload this chasis affects */
static function float GetPercentFasterReload( int InModLevel );



defaultproperties
{
}