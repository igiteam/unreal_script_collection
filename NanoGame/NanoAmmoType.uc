/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAmmoType extends Object
	abstract;

// needs to be promoted to GameFramework


/** This is a nice textual description of the ammo **/
var localized string DescriptionOfAmmo;

/** This is the sound which is played when this ammo is pickuped **/
var SoundCue AmmoPickupSound;


defaultproperties
{
	//AmmoPickupSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleClipPickupCue'
}
