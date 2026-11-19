/**
 * Gear weapon skin data provider.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeaponSkinProvider extends UIResourceDataProvider;

/** Localized name of the skin */
var	localized String SkinName;

/** Localized description of how to unlock the skin */
var	localized String SkinUnlockDesc;

/** The enum of the weapon this skin can be used on */
var config EWeaponClass WeaponClassType;

/** The unique id for this skin */
var config int WeaponSkinUniqueId;

/** Path to the texture that will represent the skin in the UI */
var config String IconPath;

/** Path to the texture that contains the image of the weapon with this skin applied */
var config String SkinnedWeaponImagePath;

/** The skin data that this provider represents */
var config CoolSkin WeaponSkin;

/** Whether this skin is only selectable by Epic or not */
var config bool bIsEpicOnly;

/** The name of the award needed to unlock this skin */
var config name AwardName;
