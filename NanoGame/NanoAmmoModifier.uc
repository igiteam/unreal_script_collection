/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAmmoModifier extends NanoWeaponModifier
	config(Weapon)
	native(Weapon)
	abstract;



/** Override in child class to influence Victim */
static function HandleAmmoImpact( int AmmoModLevel, Actor Victim, Controller InstigatedBy, out int Damage, vector HitLocation, TraceHitInfo HitInfo );



defaultproperties
{

}