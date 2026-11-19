/**
 * Provides a possible key binding for the game.
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMUIDataProvider_KeyBinding extends TMUIResourceDataProvider
	native(UI)
	PerObjectConfig;

/** Friendly displayable name to the player. */
var config localized string FriendlyName;

/** Command to bind the key to. */
var config string Command;

/** Whether this bind must be bound to leave the screen or not. */
var config bool bIsCrucialBind;
