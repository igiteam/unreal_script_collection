/**
 * Provides menu items for the settings menu.
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMUIDataProvider_SettingsMenuItem extends TMUIResourceDataProvider
	native(UI)
	PerObjectConfig;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Friendly displayable name to the player. */
var localized string FriendlyName;

/** Localized description of the map */
var localized string Description;

/** Only valid for front-end menus - will be hidden ingame */
var	config bool	bFrontEndOnly;
