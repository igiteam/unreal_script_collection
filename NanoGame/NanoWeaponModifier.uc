/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeaponModifier extends Object
	config(Weapon)
	native(Weapon)
	abstract;



var config string WeaponModifierName;

var config string WeaponModifierDescription;

/** Texture to use for icon for this AmmoModifier */
var texture2D	WeaponModifierIconTexture;
/** Origin (top left corner) of icon on this texture (in pixels) */
var	vector2D	WeaponModifierconOrigin;
/** Dimensions of this icon on the texture (in pixels) */
var vector2D	WeaponModifierIconSize;


/** This contains the set of all weapons this modifier can actually modify **/
var array<class<NanoWeapon> > WeaponsThisCanModify;



/** Returns max number of pips available for this modifier */
static function int GetMaxModLevel();

/** Returns max number of pips available for this modifier for the UI */
static function int GetMaxModLevelUI();

/** Function to get icon info for this NanoAmmoModifier */
static function Texture2D GetIconInfo( out vector2D Origin, out vector2D Size )
{
	Origin = default.WeaponModifierconOrigin;
	Size = default.WeaponModifierIconSize;
	return default.WeaponModifierIconTexture;
}


defaultproperties
{
	WeaponModifierIconTexture=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_Menu_IconsA'
	WeaponModifierconOrigin=(X=192)
	WeaponModifierIconSize=(X=64,Y=64)
}