/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAmmoType extends Object
	abstract;

/** This is the sound which is played when this ammo is pickuped **/
var SoundCue AmmoPickupSound;

/** whether clips for this ammo type should be rounded to integers when picking up an ammo box */
var bool bRoundAmmoBoxClips;


defaultproperties
{
	AmmoPickupSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleClipPickupCue'
}
